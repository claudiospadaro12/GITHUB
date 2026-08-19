//+------------------------------------------------------------------+
//|                                              ABTG_CrossEma.mq5    |
//|                                                                  |
//|  EA "CROSSEMA" - incrocio EMA 9/21 su barra CHIUSA.              |
//|                                                                  |
//|  DA DOVE VIENE: richiesta di Claudio (19/08/2026), ispirata a un |
//|  indicatore TradingView "EMA 9/21 Cross + Volume Filter". Qui il  |
//|  motore e' la parte OGGETTIVA di quella ricetta: incrocio delle   |
//|  due medie + (opzionale) la conferma di volume.                   |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in        |
//|  forward finche' un round a TICK REALI non lo promuove. Il file   |
//|  prova del round sta in backtest_pipeline/prove/.                 |
//|                                                                  |
//|  IL MOTORE (una regola sola, per poterla misurare):              |
//|    la EMA veloce chiude SOPRA la lenta  -> segnale LONG           |
//|    la EMA veloce chiude SOTTO la lenta  -> segnale SHORT          |
//|    Sempre e solo sulla BARRA CHIUSA [1] confrontata con la [2]:   |
//|    mai intrabar. Un incrocio intrabar si disfa, e un EA che lo    |
//|    insegue misura il rumore invece del segnale.                   |
//|                                                                  |
//|  I TRE FILTRI SONO TUTTI OPT-IN (default SPENTI), apposta:        |
//|  il round di ablazione deve poter girare la cella NUDA e poi      |
//|  accendere UNA gamba alla volta. Un default acceso sarebbe un     |
//|  pezzo di strategia nascosto dentro il codice.                    |
//|    a) InpUseVolumeFilter  volume della barra di segnale >= media  |
//|    b) InpUseEma200Filter  long solo sopra la EMA lenta di trend   |
//|    c) InpUseOppositeExit  esce all'incrocio opposto               |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti, niente       |
//|  emoji dentro le stringhe (regola di casa dei .ps1, estesa qui    |
//|  perche' i log finiscono negli stessi strumenti).                 |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a un EA non migrato.
//    Il default true NON cambia niente da solo: se il Guardian non gira su
//    questo conto -- e nel Strategy Tester, dove le sue GlobalVariable non
//    esistono -- la guardia lascia passare tutto (fail-open totale). I
//    backtest restano quindi confrontabili con quelli degli altri EA.
//    Non tocca MAI le posizioni gia' aperte, i parziali, il trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Motore: incrocio EMA (barra chiusa) ==="
input int    InpEmaFast        = 9;      // EMA veloce (ricetta TradingView: 9)
input int    InpEmaSlow        = 21;     // EMA lenta (ricetta TradingView: 21)
input bool   InpAllowLong      = true;   // Ammetti i LONG
input bool   InpAllowShort     = true;   // Ammetti gli SHORT

input group "=== Filtro A: VOLUME (opt-in) ==="
//  La ricetta di Claudio: la candela dell'incrocio vale solo se il suo
//  volume supera di InpVolMult la media delle InpVolAvgBars precedenti.
//  E' TICK VOLUME (numero di tick), non volume scambiato: sul forex e
//  sull'oro il volume vero non esiste nel feed del broker. Va scritto,
//  perche' l'indicatore TradingView su altri mercati usa un'altra cosa.
input bool   InpUseVolumeFilter = false; // Accendi il filtro volume
input double InpVolMult         = 1.5;   // Volume barra segnale >= X * media (ricetta: 1.5)
input int    InpVolAvgBars      = 20;    // Barre della media volume (ricetta: 20)

input group "=== Filtro B: EMA di trend (opt-in) ==="
//  Long solo se la chiusura della barra di segnale sta SOPRA la EMA di
//  trend, short solo se sta SOTTO. E' il filtro di direzione classico:
//  toglie gli incroci contro-tendenza, che su un motore a incroci sono
//  la maggioranza dei falsi.
input bool   InpUseEma200Filter = false; // Accendi il filtro EMA di trend
input int    InpEmaTrendPeriod  = 200;   // Periodo della EMA di trend

input group "=== Filtro C: uscita sull'incrocio opposto (opt-in) ==="
//  Non e' un filtro d'INGRESSO: e' una regola di USCITA. Sta nel gruppo
//  dei tre perche' il round la misura come terza gamba dell'ablazione,
//  ma va letta sapendo che cambia le USCITE, non i segnali.
input bool   InpUseOppositeExit = false; // Chiudi la posizione all'incrocio opposto
//  L'incrocio opposto e' allo stesso tempo un'USCITA e un INGRESSO nuovo:
//  il motore, per costruzione, sta sempre in una direzione o nell'altra.
//    true  = dopo la chiusura valuta subito l'ingresso opposto (comportamento
//            naturale del motore: si gira);
//    false = chiude e basta, e aspetta l'incrocio DOPO per rientrare (meta'
//            dei segnali del motore vengono saltati: e' una misura diversa).
//  INERTE se InpUseOppositeExit e' false, quindi non tocca la cella nuda.
input bool   InpReverseOnOppositeExit = true; // All'incrocio opposto: chiudi E gira

input group "=== Stop, target, gestione ==="
input int    InpAtrPeriod   = 14;    // Periodo ATR per lo stop
input double InpSLatr       = 1.5;   // SL = X * ATR
input double InpTP_RR       = 2.0;   // TP = X volte R (0 = nessun TP: usare con l'uscita opposta)
input double InpTP1_RR      = 1.0;   // Primo target del parziale, in R
input double InpTP1Pct      = 0;     // % chiusa al primo target (0 = parziale SPENTO)
input bool   InpBreakeven   = true;  // Stop in pari dopo il primo target
input bool   InpUseTrailEma = false; // Trailing dello stop sulla EMA lenta

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay = 0;     // Max ingressi al giorno (0 = illimitato)
input bool   InpUseHourFilter   = false; // Filtro orario sulla barra di segnale
input int    InpHourStart       = 8;     // Ora SERVER di inizio (inclusa)
input int    InpHourEnd         = 20;    // Ora SERVER di fine (inclusa)
input bool   InpFridayClose     = false; // Chiudi tutto venerdi' prima della chiusura mercato (opt-in)
input int    InpFridayCloseHour = 20;    // Ora SERVER del venerdi' oltre cui chiudo (20 server = 21 IT)

input group "=== Rischio ==="
input double InpRiskPercent = 1.0;   // Rischio per trade, % del saldo

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "CROSSEMA"; // Commento sugli ordini
input long   InpMagic     = 772500;     // Numero magico
input int    InpMaxSpread = 0;          // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose   = true;       // Messaggi nel log
input bool   InpAutoTest  = true;       // Stampa le righe [CROSSEMA][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hEmaF = INVALID_HANDLE;
int      hEmaS = INVALID_HANDLE;
int      hEmaT = INVALID_HANDLE;
int      hAtr  = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
//    Qui si segue l'equity dentro la giornata e si tiene la caduta
//    peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[CROSSEMA] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| L'INCROCIO. fPrev/sPrev = barra [2], fNow/sNow = barra [1].       |
//| Ritorna +1 (long), -1 (short), 0 (niente).                        |
//| Il "<=" e il ">=" sul lato precedente servono a NON perdere       |
//| l'incrocio quando le due medie coincidono su una barra: senza,    |
//| un tocco esatto (raro ma esiste, e sui dati a 2 decimali degli    |
//| indici succede) farebbe sparire il segnale.                       |
//+------------------------------------------------------------------+
int CrossDirezione(const double fPrev,const double sPrev,
                   const double fNow, const double sNow,
                   const bool allowLong,const bool allowShort)
  {
   bool su  = (fPrev<=sPrev && fNow>sNow);
   bool giu = (fPrev>=sPrev && fNow<sNow);
   if(su  && allowLong)  return(+1);
   if(giu && allowShort) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Filtro volume -- nucleo. media<=0 = dato non utilizzabile:        |
//| NON si blocca (un filtro senza dati non deve inventare un veto).  |
//+------------------------------------------------------------------+
bool VolumeSopraMedia_Calc(const double volSegnale,const double media,const double mult)
  {
   if(media<=0) return(true);
   return(volSegnale >= mult*media);
  }

//+------------------------------------------------------------------+
//| Filtro EMA di trend -- nucleo. Long sopra, short sotto.           |
//+------------------------------------------------------------------+
bool TrendEmaOK_Calc(const double chiusura,const double ema,const bool isLong)
  {
   return(isLong ? (chiusura>ema) : (chiusura<ema));
  }

//+------------------------------------------------------------------+
//| Filtro orario -- nucleo. Estremi INCLUSI.                         |
//| Gestisce anche la fascia a cavallo della mezzanotte (start>end):  |
//| sull'oro una sessione 22->6 e' una domanda legittima, e far       |
//| fallire l'init sarebbe una limitazione senza motivo.              |
//+------------------------------------------------------------------+
bool OraAmmessa_Calc(const int ora,const int start,const int end)
  {
   if(start<=end) return(ora>=start && ora<=end);
   return(ora>=start || ora<=end);          // fascia a cavallo della mezzanotte
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpEmaFast<1 || InpEmaSlow<1)
     { Print("ERRORE: i periodi delle EMA devono essere >= 1."); return(INIT_FAILED); }
   if(InpEmaFast>=InpEmaSlow)
     { Print("ERRORE: InpEmaFast deve essere MINORE di InpEmaSlow (9/21, non il contrario)."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpSLatr<=0)
     { Print("ERRORE: InpSLatr deve essere > 0: senza stop non si dimensiona il lotto."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }

   hEmaF = iMA(_Symbol, gTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
   hEmaS = iMA(_Symbol, gTF, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
   hEmaT = iMA(_Symbol, gTF, InpEmaTrendPeriod, 0, MODE_EMA, PRICE_CLOSE);
   hAtr  = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hEmaF==INVALID_HANDLE || hEmaS==INVALID_HANDLE || hEmaT==INVALID_HANDLE || hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione: se un filtro e' acceso, la cella
   //    NON e' la cella nuda. Non lo spegne l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova lo pinna. Se questa riga
   //    compare nel log di una cella "nuda", quella cella e' da buttare.
   if(InpUseVolumeFilter || InpUseEma200Filter || InpUseOppositeExit || InpUseNewsFilter ||
      InpUseHourFilter   || InpUseTrailEma     || InpTP1Pct>0)
      Log("ATTENZIONE: c'e' almeno un FILTRO/GESTIONE acceso. Questa cella NON e' la cella nuda dell'ablazione.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestCrossEma();

   Log(StringFormat("avviato su %s %s. EMA %d/%d, SL %.2f ATR(%d), TP %.2f R, rischio %.2f%%, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpEmaFast, InpEmaSlow,
       InpSLatr, InpAtrPeriod, InpTP_RR, InpRiskPercent, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   int hs[4]={hEmaF,hEmaS,hEmaT,hAtr};
   for(int i=0;i<4;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(FridayCloseCheck()) return;      // venerdi' oltre l'ora: chiudo e non riapro

   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari / trailing: a ogni tick

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| Il segnale GREZZO della barra chiusa, senza nessun filtro.        |
//| Grezzo apposta: serve sia all'INGRESSO (dove poi passa i filtri)  |
//| sia all'USCITA sull'incrocio opposto, che i filtri d'ingresso     |
//| NON deve vederli (un'uscita filtrata e' una posizione che resta   |
//| aperta perche' mancava il volume: l'opposto di una regola di      |
//| protezione).                                                      |
//+------------------------------------------------------------------+
int SegnaleGrezzo()
  {
   double f[], s[];
   ArraySetAsSeries(f,true); ArraySetAsSeries(s,true);
   if(CopyBuffer(hEmaF,0,1,2,f)!=2) return(0);
   if(CopyBuffer(hEmaS,0,1,2,s)!=2) return(0);
   // f[0]/s[0] = barra chiusa [1]; f[1]/s[1] = barra [2]
   return(CrossDirezione(f[1],s[1],f[0],s[0],true,true));
  }

//+------------------------------------------------------------------+
void OnNewBar()
  {
   int grezzo = SegnaleGrezzo();

   //--- 1. USCITA sull'incrocio opposto (se accesa). PRIMA dell'ingresso:
   //    la posizione va chiusa comunque, anche se poi l'ingresso nuovo
   //    verra' fermato da un filtro o dal Guardian.
   bool haChiuso = false;
   if(InpUseOppositeExit && grezzo!=0)
      haChiuso = ChiudiSeOpposto(grezzo);

   //--- 2. INGRESSO
   if(grezzo==0) return;
   if(haChiuso && !InpReverseOnOppositeExit) return;   // chiude e basta: niente giro
   if(grezzo>0 && !InpAllowLong)  return;
   if(grezzo<0 && !InpAllowShort) return;

   if(CountPositions()>0) return;                      // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!OraOK())    return;
   if(!SpreadOK()) return;
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;

   bool isLong = (grezzo>0);
   if(InpUseVolumeFilter  && !VolumeOK())        return;
   if(InpUseEma200Filter  && !TrendEmaOK(isLong)) return;

   Enter(isLong);
  }

//==================================================================
//  FILTRI (la lettura dei dati; il pensiero sta nel nucleo puro)
//==================================================================

//--- Volume della barra di SEGNALE [1] contro la media delle
//    InpVolAvgBars barre PRECEDENTI ([2] in poi). La barra di segnale
//    NON entra nella sua media: altrimenti si confronterebbe con se
//    stessa e la soglia si abbasserebbe da sola.
bool VolumeOK()
  {
   int n = InpVolAvgBars;
   if(n<2) return(true);
   long v[];
   ArraySetAsSeries(v,true);
   if(CopyTickVolume(_Symbol,gTF,1,n+1,v) < n+1) return(true);   // dati insuff.: non blocco
   double somma=0;
   for(int i=1;i<=n;i++) somma += (double)v[i];
   return(VolumeSopraMedia_Calc((double)v[0], somma/n, InpVolMult));
  }

//--- Chiusura della barra di segnale contro la EMA di trend.
bool TrendEmaOK(bool isLong)
  {
   double e[1];
   if(CopyBuffer(hEmaT,0,1,1,e)!=1) return(true);   // dati insuff.: non blocco
   return(TrendEmaOK_Calc(iClose(_Symbol,gTF,1), e[0], isLong));
  }

//--- Orario della BARRA DI SEGNALE, in ORA SERVER (mai l'ora italiana:
//    regola di casa, il server BCM e' un'ora indietro).
bool OraOK()
  {
   if(!InpUseHourFilter) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   return(OraAmmessa_Calc(t.hour, InpHourStart, InpHourEnd));
  }

//==================================================================
//  INGRESSO
//==================================================================
void Enter(bool isLong)
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1 || a[0]<=0){ Log("ATR non disponibile: salto."); return; }
   double atr = a[0];

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry = isLong ? ask : bid;

   double sl = NormalizePrice(isLong ? entry-atr*InpSLatr : entry+atr*InpSLatr);
   double R  = isLong ? (entry-sl) : (sl-entry);

   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=0 || R<=minDist){ Log("SL troppo vicino al prezzo (stops level): salto."); return; }

   //--- TP: 0 = nessun target. Ha senso con l'uscita sull'incrocio
   //    opposto accesa, che diventa l'unica uscita a favore.
   double tp = 0;
   if(InpTP_RR>0)
     {
      tp = NormalizePrice(isLong ? entry+R*InpTP_RR : entry-R*InpTP_RR);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return; }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_CrossEma")) return;

   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      Log(StringFormat("%s @ %s SL %s TP %s lot %.2f (R %s)",
          isLong?"LONG":"SHORT",
          DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits)));
     }
   else Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
  }

//==================================================================
//  USCITE E GESTIONE
//==================================================================

//+------------------------------------------------------------------+
//| Chiude la posizione se l'incrocio va CONTRO di lei.               |
//| Ritorna true se ha effettivamente mandato una chiusura.           |
//+------------------------------------------------------------------+
bool ChiudiSeOpposto(int grezzo)
  {
   bool fatto=false;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      bool contro = (isLong && grezzo<0) || (!isLong && grezzo>0);
      if(!contro) continue;

      if(gTrade.PositionClose(tk))
        { fatto=true; Log("incrocio opposto: posizione chiusa."); }
      else
         Log("incrocio opposto: chiusura fallita: "+gTrade.ResultRetcodeDescription());
     }
   return(fatto);
  }

//+------------------------------------------------------------------+
//| Parziale al primo target + stop in pari, poi trailing sulla EMA   |
//| lenta. Gira a OGNI tick: il target si tocca in mezzo alla barra.  |
//|                                                                   |
//| NOTA SUL DEFAULT: con InpTP1Pct=0 questo blocco NON fa niente     |
//| (niente parziale, e quindi niente stop in pari, che per firma     |
//| viene "dopo la parziale"). E' voluto: la cella nuda del round     |
//| dev'essere SL/TP e basta.                                         |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double es[1]; bool haveEmaS = (CopyBuffer(hEmaS,0,1,1,es)==1);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      double vol    = PositionGetDouble(POSITION_VOLUME);
      if(sl<=0) continue;                       // senza stop non so quanto vale 1 R

      double R = isLong ? (openP-sl) : (sl-openP);
      bool   beFatto = isLong ? (sl>=openP) : (sl<=openP);

      //--- primo target: parziale + stop in pari
      if(!beFatto && InpTP1Pct>0 && R>0)
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            //  LEZIONE PTE (04/08/2026): lo STOP IN PARI non deve dipendere
            //  dalla riuscita del parziale. Al lotto minimo NormVol() arrotonda
            //  a 0, il parziale non parte, e prima di quella lezione con lui
            //  saltava anche il breakeven: posizioni a +1,28R tornate in perdita
            //  con lo stop ancora all'originale.
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakeven)
              {
               gTrade.PositionModify(tk,NormalizePrice(openP),tp);
               beFatto = true;
              }
            Log(parz ? "primo target: parziale eseguito."
                     : "primo target: parziale impossibile al lotto minimo.");
           }
        }

      //--- trailing sulla EMA lenta: lo stop si muove SOLO a favore
      if(InpUseTrailEma && haveEmaS)
        {
         double n = NormalizePrice(es[0]);
         double slOra = PositionGetDouble(POSITION_SL);
         if(isLong  && n>slOra && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
         if(!isLong && n<slOra && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Venerdi' oltre l'ora: chiudo tutto e non riapro.                  |
//| L'ora e' quella del SERVER (TimeCurrent), mai quella del PC.      |
//+------------------------------------------------------------------+
bool FridayCloseCheck()
  {
   if(!InpFridayClose) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(t.day_of_week!=5 || t.hour<InpFridayCloseHour) return(false);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         gTrade.PositionClose(p);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
//| Sta fuori dal filtro della barra nuova apposta: su H1 la caduta   |
//| peggiore di giornata succede in mezzo a una candela.              |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;              // conto a zero: niente da dividere
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   double giornata = 100.0*(gDayMinEquity-gDayStartEquity)/gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int    dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Lotto dalla distanza dello stop, come negli altri EA ABTG.
//    PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026):
//    su 225JPY il tick value arriva non convertito in valuta conto e il
//    lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit converte
//    correttamente; il tick value resta come ripiego. Sui simboli sani i
//    due calcoli coincidono: cambia SOLO dove il tick value mente.
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot = -profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);

   double lot = risk/lossPerLot;
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot = MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//==================================================================
void AutoTestCrossEma()
  {
   int falliti=0;

   PrintFormat("[CROSSEMA][AUTOTEST] EMA %d/%d | magic %I64d | %s | filtri: vol=%d ema200=%d opp=%d",
               InpEmaFast, InpEmaSlow, InpMagic, _Symbol,
               (int)InpUseVolumeFilter, (int)InpUseEma200Filter, (int)InpUseOppositeExit);

   //--- L'INCROCIO (medie finte, cosi' il caso e' leggibile a occhio)
   int c1 = CrossDirezione( 9.0,10.0, 11.0,10.0, true,true);   // sotto -> sopra  = +1
   int c2 = CrossDirezione(11.0,10.0,  9.0,10.0, true,true);   // sopra -> sotto  = -1
   int c3 = CrossDirezione(11.0,10.0, 12.0,10.0, true,true);   // gia' sopra, resta sopra = 0
   int c4 = CrossDirezione(10.0,10.0, 11.0,10.0, true,true);   // tocco esatto poi sopra  = +1
   int c5 = CrossDirezione( 9.0,10.0, 11.0,10.0, false,true);  // long vietato dai lati   = 0
   int c6 = CrossDirezione(11.0,10.0,  9.0,10.0, true,false);  // short vietato dai lati  = 0
   PrintFormat("[CROSSEMA][AUTOTEST] incrocio: su=%d (atteso +1) | giu=%d (atteso -1) | nessuno=%d (atteso 0)", c1,c2,c3);
   PrintFormat("[CROSSEMA][AUTOTEST] incrocio: tocco=%d (atteso +1) | long off=%d (atteso 0) | short off=%d (atteso 0)", c4,c5,c6);
   if(!(c1==1 && c2==-1 && c3==0 && c4==1 && c5==0 && c6==0)) falliti++;

   //--- IL VOLUME
   bool v1 = VolumeSopraMedia_Calc(200.0,100.0,1.5);   // 2,0x la media -> passa
   bool v2 = VolumeSopraMedia_Calc(140.0,100.0,1.5);   // 1,4x la media -> blocca
   bool v3 = VolumeSopraMedia_Calc(150.0,100.0,1.5);   // esattamente 1,5x -> passa
   bool v4 = VolumeSopraMedia_Calc(  1.0,  0.0,1.5);   // media nulla -> non blocco
   PrintFormat("[CROSSEMA][AUTOTEST] volume: 2.0x=%d (atteso 1) | 1.4x=%d (atteso 0) | 1.5x=%d (atteso 1) | media 0=%d (atteso 1)",
               (int)v1,(int)v2,(int)v3,(int)v4);
   if(!(v1 && !v2 && v3 && v4)) falliti++;

   //--- LA EMA DI TREND
   bool t1 = TrendEmaOK_Calc(105.0,100.0,true);    // long sopra  -> passa
   bool t2 = TrendEmaOK_Calc( 95.0,100.0,true);    // long sotto  -> blocca
   bool t3 = TrendEmaOK_Calc( 95.0,100.0,false);   // short sotto -> passa
   PrintFormat("[CROSSEMA][AUTOTEST] ema trend: long sopra=%d (atteso 1) | long sotto=%d (atteso 0) | short sotto=%d (atteso 1)",
               (int)t1,(int)t2,(int)t3);
   if(!(t1 && !t2 && t3)) falliti++;

   //--- L'ORARIO (ORA SERVER)
   bool o1 = OraAmmessa_Calc(10, 8,20);    // dentro
   bool o2 = OraAmmessa_Calc(21, 8,20);    // fuori
   bool o3 = OraAmmessa_Calc( 8, 8,20);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[CROSSEMA][AUTOTEST] orario: 10 in 8-20=%d (atteso 1) | 21=%d (atteso 0) | estremo 8=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(o1 && !o2 && o3 && o4)) falliti++;

   Print("[CROSSEMA][AUTOTEST] esito motore: ", (falliti==0
         ? "QUATTRO BLOCCHI SU QUATTRO, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- blocco standard ABTG
//  Formato per riga (separatore ';'):
//    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che servono per rispondere "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
//+------------------------------------------------------------------+
