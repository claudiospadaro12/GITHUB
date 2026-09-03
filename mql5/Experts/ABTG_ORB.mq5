//+------------------------------------------------------------------+
//|                                                  ABTG_ORB.mq5     |
//|                                                                  |
//|  EA "ORB semplice" - MetaTrader 5 - VERSIONE TUTTO-IN-UNO        |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Replica la logica dell'ORB_Indicator_V15:                      |
//|   - RANGE = candela 14:25-14:30 (server) = 15:25-15:30 IT       |
//|     (i 5 minuti prima dell'apertura USA)                        |
//|   - Ingresso a EntryPoints x K oltre max/min del range:         |
//|     BUY STOP sopra, SELL STOP sotto (OCO)                       |
//|   - K = coefficiente per strumento (indici/oro=1.0, 225JPY=10,  |
//|     cross JPY=0.01, altri forex=0.0001, oil=0.01)               |
//|   - SL sull'estremo opposto (o ATR/fisso); TP a R multiplo      |
//|     (webinar: min 1:2) + parziale + breakeven                  |
//|   - Runner: trailing / uscita su EMA9 (M5), come da webinar     |
//|   - Cancella/chiude a 22:59 server; 1 trade a sessione          |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti. DEMO.   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                       |
//|  v1.01 (03/09/2026) - IL PANNELLO SMETTE DI MENTIRE.             |
//|        InpOneTradePerDay era DICHIARATO e MAI LETTO: unica        |
//|        occorrenza nel sorgente (riga 54 della v1.00), misurato in |
//|        report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md. In      |
//|        campo il conto lo dice: 20 operazioni in 16 giornate       |
//|        operative dove il pannello ne prometteva al massimo 16,    |
//|        cioe' +25% di frequenza rispetto al contratto (NASUSD,     |
//|        magic 770601). Da qui in avanti l'input FA quello che dice.|
//|                                                                   |
//|        COSA FA ADESSO, in due righe di decisione:                 |
//|         1. non RIARMA la giornata se oggi ho gia' un ingresso     |
//|            allo storico (PuoArmare_Calc);                         |
//|         2. quando il trade del giorno e' FINITO, cancella i       |
//|            pendenti superstiti, che con scadenza 600' potevano    |
//|            riaprire in giornata (GiornataSpesa_Calc). E' la       |
//|            stessa semantica del gemello ABTG_ORB_Ottimizzato      |
//|            (ramo gHadPos, fix v1.01 del 08/08/2026).              |
//|                                                                   |
//|        HEDGE-SAFE PER COSTRUZIONE. La conoscenza "oggi ho gia'    |
//|        operato" NON passa da PositionSelect(_Symbol): scorre      |
//|        PositionsTotal() filtrando SIMBOLO+MAGIC, e lo storico     |
//|        del giorno filtrando DEAL_SYMBOL+DEAL_MAGIC (lo stesso     |
//|        pattern di HaGiaOperatoOggi in ABTG_Dow_Apertura_US, che   |
//|        la VERIFICA del 03/09 dichiara immune al difetto). Il      |
//|        difetto C9 NON entra da questa porta.                      |
//|                                                                   |
//|        ATTENZIONE, QUELLO CHE QUESTO FIX NON FA. NON tocca        |
//|        SelPos(), che resta il PositionSelect(_Symbol) cieco di    |
//|        sempre: quindi NON impedisce che il secondo lato si apra   |
//|        MENTRE il primo e' ancora vivo (le 4 giornate su 16        |
//|        misurate nella VERIFICA). Quello e' il difetto C9, che ha  |
//|        una sua voce nella coda dei fix. Qui si chiude solo la     |
//|        RIAPERTURA DOPO che il trade del giorno e' finito.         |
//|                                                                   |
//|        ATTESO INERTE NEL TESTER, e vale la pena capire perche':   |
//|        nel tester l'EA e' solo sul simbolo, SelPos() non e' mai   |
//|        cieco e HandleOCO() cancella il pendente opposto           |
//|        nell'istante in cui la posizione nasce -- di superstiti da |
//|        cancellare non ce n'e'. E il ramo "non riarmare" non puo'  |
//|        scattare perche' gPhase e' ORB_WAIT solo prima del primo   |
//|        piazzamento. I backtest archiviati restano confrontabili;  |
//|        InpOneTradePerDay=false riproduce comunque la v1.00 esatta.|
//|        In CAMPO invece morde. Non e' un miglioramento promesso:   |
//|        e' l'EA che fa quello che dice il suo pannello. Se il      |
//|        numero di trade in forward scende verso 1/giorno, il fix   |
//|        sta lavorando.                                             |
//|        Aggiunto un AUTOTEST a tavolino (4 blocchi, 24 casi) sui   |
//|        predicati puri: gira in OnInit, non tocca il mercato.      |
//|  v1.00 - versione del corso.                                      |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.01"
#property strict

//--- v1.01: QUANTI BLOCCHI E QUANTI CASI deve eseguire l'autotest.
//    Due contatori e non uno (pattern di casa, ABTG_LondonFx /
//    ABTG_ORB_Ottimizzato): un blocco cancellato per sbaglio non deve
//    poter passare per "tutto verde", e nemmeno un blocco SVUOTATO
//    delle sue asserzioni, che il conteggio dei soli blocchi non
//    vedrebbe. Se uno dei due conti non torna, l'autotest e' FALLITO.
#define ORB_AUTOTEST_BLOCCHI_ATTESI 4
#define ORB_AUTOTEST_CASI_ATTESI    24

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
CTrade gTrade;

enum ENUM_ORB_SL { ORB_SL_OPPRANGE=0, ORB_SL_ATR=1, ORB_SL_FIXED=2 };

//==================================================================
//  INPUT
//==================================================================
input group "=== Range ORB (ORARI SERVER, come l'indicatore) ==="
input int    InpRangeStartHour = 14;  // Inizio range (server). BCM: 14:25 = 15:25 IT
input int    InpRangeStartMin  = 25;
input int    InpRangeEndHour   = 14;  // Fine range (server). BCM: 14:30 = 15:30 IT
input int    InpRangeEndMin    = 30;
input int    InpEndHour        = 22;  // Fine giornata: cancella/chiude (server). Indicatore: 22:59
input int    InpEndMin         = 59;
input bool   InpCloseAtEnd     = true;
//--- v1.01: DA QUI IN AVANTI QUESTO INPUT E' LETTO DAVVERO (fino alla
//    v1.00 era dichiarato e mai usato: il pannello prometteva un trade
//    al giorno e il codice non lo applicava). true = un solo ciclo di
//    trade al giorno; false = comportamento IDENTICO alla v1.00.
input bool   InpOneTradePerDay = true;  // Un solo trade al giorno (v1.01: ora e' applicato davvero)
input int    InpPendingExpiryMin = 600;

input group "=== Ingresso (EntryPoints x K, come l'indicatore) ==="
input double InpEntryPoints = 10.0;   // Distanza ingresso oltre max/min (in unita' K)
input double InpK           = 1.0;    // Coefficiente: indici/oro=1.0; 225JPY=10; JPY=0.01; forex=0.0001; oil=0.01
input bool   InpAllowLong   = true;
input bool   InpAllowShort  = true;

input group "=== Stop, target, gestione ==="
input ENUM_ORB_SL InpSLMode = ORB_SL_OPPRANGE; // Estremo opposto range / ATR / punti fissi
input ENUM_TIMEFRAMES InpExecTF = PERIOD_M5;   // TF di esecuzione (ATR, EMA, trailing)
input int    InpAtrPeriod  = 14;
input double InpAtrSLmult   = 1.5;
input double InpSLFixedPts   = 1000;   // (FIXED) stop in punti
input double InpTP_R         = 2.0;    // Take profit in R (webinar: min 1:2)
input double InpTP1Pct       = 50;     // % chiusa al target
input bool   InpBreakeven    = true;   // Stop in pari dopo la parziale
input bool   InpUseTrailEMA  = true;   // Trailing dello stop sull'EMA veloce
input int    InpEmaFast      = 9;
input int    InpEmaSlow      = 21;
input bool   InpExitOnEmaClose = true; // Esci se una candela chiude oltre l'EMA9 opposta

input group "=== Ricetta ToolKit ABTG / live (tutto OPT-IN, default = comportamento attuale) ==="
input bool   InpUseCloseConfirm  = false;  // Entra alla CHIUSURA di una candela oltre il livello, invece che con pendenti STOP
input double InpMinBodyPct       = 50;     // (CLOSE_CONFIRM) corpo minimo della candela di rottura, in % del suo range (0=off)
input bool   InpUseEmaFilter     = false;  // Filtro direzionale: EMA veloce/lenta allineate E prezzo dalla parte giusta di ENTRAMBE
input bool   InpUseVolumeFilter  = false;  // Volume della candela di rottura >= X * media
input double InpVolMult          = 1.5;    // (volumi) moltiplicatore: 1.5 = +50%, come da live
input int    InpVolAvgBars       = 20;     // (volumi) barre per la media

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;    // Rischio per trade in %

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies= "USD";
input bool   InpNewsFlatten   = true;

input group "=== Generali ==="
input string InpComment   = "ORB";
input long   InpMagic     = 770601;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
input bool   InpAutoTest  = true;     // Autotest dei predicati "un trade al giorno" (stampa in OnInit)

//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE, hEmaF=INVALID_HANDLE, hEmaS=INVALID_HANDLE;
enum ENUM_ORBPHASE { ORB_WAIT, ORB_ARMED, ORB_PLACED, ORB_DONE };
ENUM_ORBPHASE gPhase=ORB_WAIT;
int      gDay=-1;
double   gRangeHigh=0, gRangeLow=0;
bool     gPart1=false;
datetime gLastExec=0;
//--- v1.01, "un trade al giorno". gOperatoOggi e' un TIMBRO che si accende
//    una volta sola e non si spegne fino al cambio di giornata: acceso da
//    una posizione nostra viva (a costo zero, a ogni tick) oppure dallo
//    storico del giorno (che sopravvive a riavvio e ricompilazione).
//    gUltimoCheckStorico limita la lettura dello storico a una al minuto:
//    serve solo finche' il timbro e' spento, poi non si legge piu'.
bool     gOperatoOggi=false;
datetime gUltimoCheckStorico=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[ORB] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr =iATR(_Symbol,InpExecTF,InpAtrPeriod);
   hEmaF=iMA(_Symbol,InpExecTF,InpEmaFast,0,MODE_EMA,PRICE_CLOSE);
   hEmaS=iMA(_Symbol,InpExecTF,InpEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE||hEmaF==INVALID_HANDLE||hEmaS==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest) Autotest();   // v1.01: verifica a tavolino dei predicati "un trade al giorno"
   Log(StringFormat("avviato su %s. Range server %02d:%02d-%02d:%02d, ingresso %.1f x K(%.4f), fine %02d:%02d.",
       _Symbol,InpRangeStartHour,InpRangeStartMin,InpRangeEndHour,InpRangeEndMin,InpEntryPoints,InpK,InpEndHour,InpEndMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr !=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageTP1();
   HandleOCO();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   //--- v1.01: la guardia "un trade al giorno". Sta DOPO il cambio di
   //    giornata, non prima: al primo tick del giorno nuovo il timbro
   //    dev'essere gia' stato azzerato da ResetDay(), altrimenti la prima
   //    cosa che farebbe sarebbe cancellare i pendenti di ieri.
   UnTradeAlGiorno();

   bool newsBlk=InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten){ CancelPendings(); if(SelPos()) gTrade.PositionClose(_Symbol); }

   int nowMin=now.hour*60+now.min;
   if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }

   //--- gestione runner (EMA) a nuova barra M5
   datetime t=iTime(_Symbol,InpExecTF,0);
   bool newBar=(t!=gLastExec);
   if(newBar){ gLastExec=t; ManageRunner(); }

   //--- fine del range: piazzo i pendenti (classico) oppure ARMO la sorveglianza (ToolKit)
   if(gPhase==ORB_WAIT && nowMin>=InpRangeEndHour*60+InpRangeEndMin)
     {
      if(newsBlk) return;
      //--- v1.01: non RIARMARE una giornata gia' operata. Serve al riavvio /
      //    ricompilazione a giornata iniziata, dove la macchina a stati
      //    riparte da ORB_WAIT e senza questa riga ripiazzerebbe i pendenti
      //    su un giorno gia' speso (e' l'incidente del 05/08 sugli Aperture).
      //    Nel tester e' INERTE: gPhase e' ORB_WAIT solo prima del primo
      //    piazzamento, quando il timbro e' per forza spento.
      if(!PuoArmare_Calc(InpOneTradePerDay,gOperatoOggi))
        {
         gPhase=ORB_DONE;   // ORB_DONE e non ORB_WAIT: cosi' il log non si ripete a ogni tick
         Log("oggi ho gia' operato (storico simbolo+magic): non riarmo.");
         return;
        }
      if(InpUseCloseConfirm)
        {
         if(ArmCloseConfirm()) gPhase=ORB_ARMED;
        }
      else
        {
         if(TryPlace()) gPhase=ORB_PLACED;
        }
     }

   //--- ToolKit: aspetto che una candela CHIUDA oltre il livello. Valuto a nuova barra.
   if(gPhase==ORB_ARMED && newBar)
     {
      if(newsBlk) return;
      if(TryCloseConfirmEntry()) gPhase=ORB_PLACED;
     }
  }

void ResetDay(){ gPhase=ORB_WAIT; gRangeHigh=0; gRangeLow=0; gPart1=false;
                 gOperatoOggi=false; gUltimoCheckStorico=0;   // v1.01: il timbro del giorno riparte da zero
                 Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Calcola max/min del range (finestra server, anche a cavallo mezzanotte)|
//+------------------------------------------------------------------+
bool ComputeRange(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpRangeEndHour;   t.min=InpRangeEndMin;   datetime tEnd=StructToTime(t);
   t.hour=InpRangeStartHour; t.min=InpRangeStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;
   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   return(hi>0 && lo>0 && hi>lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti oltre il range (EntryPoints x K)      |
//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double entryDist=EntryDistance();
   double buyPx =NormalizePrice(gRangeHigh+entryDist);
   double sellPx=NormalizePrice(gRangeLow -entryDist);
   double atr=AtrVal();
   datetime exp=TimeCurrent()+InpPendingExpiryMin*60;

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB")) return(false);
   if(InpAllowLong)
     {
      double sl=SLforLong(buyPx,sellPx,atr);
      double dist=buyPx-sl;
      if(dist>0)
        {
         double tp=NormalizePrice(buyPx+dist*InpTP_R);
         double lot=LotByRisk(dist);
         if(lot>0 && gTrade.BuyStop(lot,buyPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" BUY"))
            Log(StringFormat("BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f",buyPx,sl,tp,lot));
        }
     }
   if(InpAllowShort)
     {
      double sl=SLforShort(sellPx,buyPx,atr);
      double dist=sl-sellPx;
      if(dist>0)
        {
         double tp=NormalizePrice(sellPx-dist*InpTP_R);
         double lot=LotByRisk(dist);
         if(lot>0 && gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" SELL"))
            Log(StringFormat("SELL STOP @ %.5f SL %.5f TP %.5f lot %.2f",sellPx,sl,tp,lot));
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ToolKit ABTG (Vol. V) + ricetta dalle live: invece di piazzare    |
//| pendenti STOP si ASPETTA che una candela CHIUDA oltre il livello. |
//|  «Non basta che il prezzo tocchi il livello: la candela deve      |
//|   chiudersi al di sopra. Questo conferma che la rottura e' reale.»|
//| Qui si calcola solo il range e si arma la sorveglianza.           |
//+------------------------------------------------------------------+
bool ArmCloseConfirm()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   Log(StringFormat("ARMATO (attesa chiusura confermata): range %.5f - %.5f", gRangeHigh, gRangeLow));
   return(true);
  }

//+------------------------------------------------------------------+
//| Filtro direzionale del ToolKit: EMA veloce/lenta allineate E      |
//| prezzo dalla parte giusta di ENTRAMBE. Medie intrecciate o        |
//| prezzo in mezzo = NESSUNA operazione.                             |
//+------------------------------------------------------------------+
bool EmaSideOK(int dir)
  {
   if(!InpUseEmaFilter) return(true);
   double f[1], s[1];
   if(CopyBuffer(hEmaF,0,1,1,f)<1 || CopyBuffer(hEmaS,0,1,1,s)<1) return(true); // dati insuff.: non blocco
   double px=iClose(_Symbol,InpExecTF,1);
   if(px<=0) return(true);
   if(dir>0) return(f[0]>s[0] && px>f[0] && px>s[0]);
   if(dir<0) return(f[0]<s[0] && px<f[0] && px<s[0]);
   return(false);
  }

//+------------------------------------------------------------------+
//| Volume DELLA CANDELA DI ROTTURA >= X * media delle N precedenti   |
//|  (live: "volumi >= +50%, cioe' 1,5x la media a 20")               |
//+------------------------------------------------------------------+
bool VolumeOK()
  {
   if(!InpUseVolumeFilter) return(true);
   int n=InpVolAvgBars;
   if(n<2) return(true);
   long v[];
   ArraySetAsSeries(v,true);
   if(CopyTickVolume(_Symbol,InpExecTF,1,n+1,v)<n+1) return(true);  // dati insuff.: non blocco
   double sum=0;
   for(int i=1;i<=n;i++) sum+=(double)v[i];
   double avg=sum/n;
   if(avg<=0) return(true);
   return((double)v[0] >= InpVolMult*avg);   // v[0] = la candela appena chiusa = quella che rompe
  }

//+------------------------------------------------------------------+
//| Valuta l'ultima candela CHIUSA: ha rotto il range con un corpo    |
//| ampio, con le medie allineate e i volumi in crescita? Allora      |
//| entra A MERCATO. Altrimenti aspetta la prossima.                  |
//+------------------------------------------------------------------+
bool TryCloseConfirmEntry()
  {
   double o=iOpen (_Symbol,InpExecTF,1), c=iClose(_Symbol,InpExecTF,1);
   double h=iHigh (_Symbol,InpExecTF,1), l=iLow  (_Symbol,InpExecTF,1);
   if(o<=0 || c<=0 || h<=l) return(false);

   int dir=0;
   if(c>gRangeHigh)      dir=+1;
   else if(c<gRangeLow)  dir=-1;
   else                  return(false);          // chiusura DENTRO il range: non e' un breakout valido

   if(dir>0 && !InpAllowLong)  return(false);
   if(dir<0 && !InpAllowShort) return(false);

   //--- corpo ampio: una candela con corpo piccolo e ombra lunga che attraversa
   //    il livello e' spesso un falso breakout (ToolKit, errori comuni)
   double rng=h-l, body=MathAbs(c-o);
   if(InpMinBodyPct>0 && (rng<=0 || body < rng*InpMinBodyPct/100.0))
     { Log("rottura con corpo piccolo: ignoro (probabile falso break)."); return(false); }

   if(!EmaSideOK(dir)) { Log("medie non allineate col breakout: niente trade."); return(false); }
   if(!VolumeOK())     { Log("volume della rottura sotto la media: niente trade."); return(false); }
   if(!SpreadOK())     { Log("spread alto: niente trade."); return(false); }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);

   double entry=(dir>0)?ask:bid;
   double atr=AtrVal();
   double sl=(dir>0)?SLforLong(entry,gRangeLow,atr):SLforShort(entry,gRangeHigh,atr);
   double dist=(dir>0)?(entry-sl):(sl-entry);
   if(dist<=0){ Log("stop dalla parte sbagliata: niente trade."); return(false); }

   double tp=NormalizePrice((dir>0)?entry+dist*InpTP_R:entry-dist*InpTP_R);
   double lot=LotByRisk(dist);
   if(lot<=0){ Log("lotto 0: niente trade."); return(false); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB")) return(false);
   bool ok=(dir>0) ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,InpComment+" BUY CC")
                   : gTrade.Sell(lot,_Symbol,0.0,sl,tp,InpComment+" SELL CC");
   if(ok) Log(StringFormat("%s a mercato su chiusura confermata @ %.5f SL %.5f TP %.5f lot %.2f",
                           (dir>0?"BUY":"SELL"), entry, sl, tp, lot));
   else   Log("ingresso su chiusura confermata FALLITO: "+gTrade.ResultRetcodeDescription());
   return(ok);
  }

double EntryDistance()
  {
   double d=InpEntryPoints*InpK;                      // distanza in PREZZO
   double minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   return(MathMax(d,minD));
  }

double SLforLong(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeLow;
   else if(InpSLMode==ORB_SL_FIXED) sl=entry-InpSLFixedPts*_Point;
   else sl=entry-atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }
double SLforShort(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeHigh;
   else if(InpSLMode==ORB_SL_FIXED) sl=entry+InpSLFixedPts*_Point;
   else sl=entry+atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }

//+------------------------------------------------------------------+
//| Parziale al target + stop in pari (ad ogni tick)                 |
//+------------------------------------------------------------------+
void ManageTP1()
  {
   if(!SelPos()) return;
   if(gPart1 || InpTP1Pct<=0 || InpTP1Pct>=100) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double risk=isLong?(openP-sl):(sl-openP);
   if(risk<=0) return;
   double tgt=isLong?openP+risk*InpTP_R:openP-risk*InpTP_R;
   bool hit=isLong?(bid>=tgt):(ask<=tgt);
   if(!hit) return;
   double cv=NormVol(vol*InpTP1Pct/100.0);
   // 07/08: lo stop in pari NON deve dipendere dalla riuscita del parziale.
   // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non parte, e con
   // lui saltava anche il breakeven. Stessa correzione gia' fatta il 04/08 sugli
   // EMA200, dove era costata -112,78 EUR su due short oro a 0,01 lotti.
   bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
   if(parzOK) gPart1=true;
   double bePari  = NormalizePrice(openP);
   double slPrec  = PositionGetDouble(POSITION_SL);
   bool   dirLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
   // il breakeven si fa SOLO se migliora lo stop: cosi' non si ripete a ogni tick
   bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                    (!dirLong && (slPrec==0 || bePari<slPrec))));
   if(beFatto) gTrade.PositionModify(_Symbol,bePari,PositionGetDouble(POSITION_TP));
   if(parzOK || beFatto)
      Log(parzOK ? "target: parziale + stop in pari."
                 : "target: stop in pari (parziale impossibile al lotto minimo).");
  }

//+------------------------------------------------------------------+
//| Runner: trailing su EMA9 + uscita se chiude oltre EMA9 opposta   |
//+------------------------------------------------------------------+
void ManageRunner()
  {
   if(!SelPos()) return;
   if(!InpUseTrailEMA && !InpExitOnEmaClose) return;
   double ef[1]; if(CopyBuffer(hEmaF,0,1,1,ef)!=1) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double close1=iClose(_Symbol,InpExecTF,1);

   if(InpExitOnEmaClose)
     {
      if(isLong && close1<ef[0]) { gTrade.PositionClose(_Symbol); Log("chiusura M5 sotto EMA9: uscita."); return; }
      if(!isLong && close1>ef[0]){ gTrade.PositionClose(_Symbol); Log("chiusura M5 sopra EMA9: uscita."); return; }
     }
   if(InpUseTrailEMA)
     {
      double sl=PositionGetDouble(POSITION_SL);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double newSL=NormalizePrice(ef[0]);
      if(isLong && newSL>sl && newSL<SymbolInfoDouble(_Symbol,SYMBOL_BID))
         gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
      if(!isLong && (newSL<sl||sl==0) && newSL>SymbolInfoDouble(_Symbol,SYMBOL_ASK))
         gTrade.PositionModify(_Symbol,newSL,PositionGetDouble(POSITION_TP));
     }
  }

//+------------------------------------------------------------------+
void HandleOCO(){ if(SelPos()) CancelPendings(); }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

void EndOfDay()
  {
   CancelPendings();
   if(InpCloseAtEnd && SelPos()){ gTrade.PositionClose(_Symbol); Log("fine giornata: posizione chiusa."); }
   gPhase=ORB_DONE;
  }

//==================================================================
//  v1.01 -- "UN SOLO TRADE AL GIORNO"
//
//  La regola e' divisa in QUATTRO PREDICATI PURI (nessuna chiamata al
//  terminale dentro) piu' due gusci che leggono il mercato. Non e'
//  pignoleria: senza MetaEditor ne' Strategy Tester in questo ambiente,
//  i predicati puri sono l'unica parte che si puo' PROVARE prima di
//  metterla in campo -- ed e' quello che fa Autotest() qui sotto sul
//  codice che gira davvero, non su una sua copia.
//
//  DUE CONOSCENZE DIVERSE, e vanno tenute separate:
//   - "ho una posizione MIA viva ADESSO"  -> guarda le posizioni;
//   - "oggi un mio ingresso c'e' GIA' STATO" -> guarda lo storico, e
//     resta vero anche a trade chiuso, anche dopo un riavvio.
//  La prima da sola era il difetto degli Aperture del 05/08 ("la
//  vecchia guardia guardava solo se c'era un ordine APERTO in quel
//  momento, e a trade gia' chiuso non vedeva niente").
//==================================================================

//--- Predicato puro: questa roba e' NOSTRA? SIMBOLO e MAGIC, tutti e due.
//    Il magic da solo non basta (lo stesso EA gira su piu' simboli), il
//    simbolo da solo e' esattamente il difetto C9 di questo audit.
bool PosMia_Calc(const string sym,const long magic,const string mioSym,const long mioMagic)
  { return(sym==mioSym && magic==mioMagic); }

//--- Predicato puro: devo TIMBRARE la giornata come "gia' operata"?
//    La riga che conta e' la seconda: storicoLetto==false vuol dire
//    "NON LO SO" (HistorySelect non ancora sincronizzato all'avvio del
//    terminale), e "non lo so" NON e' "si". Non si timbra e si riprova
//    al giro dopo. Stessa correzione fatta il 14/08 sugli Aperture.
bool TimbraGiornata_Calc(const bool posMiaAperta,const bool storicoLetto,const bool giaOperatoOggi)
  {
   if(posMiaAperta)  return(true);
   if(!storicoLetto) return(false);
   return(giaOperatoOggi);
  }

//--- Predicato puro: il trade del giorno e' FINITO e quindi i pendenti
//    superstiti vanno tolti di mezzo? Serve che il timbro sia acceso E
//    che nessuna posizione nostra sia piu' viva: finche' e' viva non c'e'
//    niente da cancellare (ci pensa gia' l'OCO) e non e' ancora "finito".
bool GiornataSpesa_Calc(const bool unoAlGiorno,const bool operatoOggi,const bool posMiaAperta)
  { return(unoAlGiorno && operatoOggi && !posMiaAperta); }

//--- Predicato puro: posso ancora ARMARE la giornata? No, se ho gia'
//    operato oggi. Attenzione: qui NON si guarda se la posizione e' viva
//    -- riarmare mentre il trade e' ancora aperto sarebbe il caso
//    peggiore di tutti, due posizioni sullo stesso segnale.
bool PuoArmare_Calc(const bool unoAlGiorno,const bool operatoOggi)
  { return(!(unoAlGiorno && operatoOggi)); }

//--- Guscio HEDGE-SAFE: quante posizioni NOSTRE ci sono adesso.
//    Scorre PositionsTotal(); NON usa PositionSelect(_Symbol), che su
//    conto hedging aggancia il ticket piu' basso del simbolo e puo'
//    essere quello di un'altra sedia (difetto C9, audit del 03/09).
int ContaPosizioniMie()
  {
   int q=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PosMia_Calc(PositionGetString(POSITION_SYMBOL),
                     PositionGetInteger(POSITION_MAGIC),_Symbol,InpMagic)) q++;
     }
   return(q);
  }

//--- Guscio: nello STORICO DI OGGI c'e' un MIO ingresso?
//    Filtra DEAL_SYMBOL + DEAL_MAGIC, come HaGiaOperatoOggi() in
//    ABTG_Dow_Apertura_US:740-745, che la VERIFICA del 03/09 dichiara
//    "hedge-safe e immune al difetto di questo audit".
bool HaGiaOperatoOggi(bool &storicoLetto)
  {
   storicoLetto=false;
   MqlDateTime d; TimeToStruct(TimeCurrent(),d);
   d.hour=0; d.min=0; d.sec=0;
   datetime inizioGiorno=StructToTime(d);
   if(!HistorySelect(inizioGiorno,TimeCurrent()+60)) return(false);
   storicoLetto=true;
   int n=HistoryDealsTotal();
   for(int i=n-1;i>=0;i--)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk<=0) continue;
      if(!PosMia_Calc(HistoryDealGetString(tk,DEAL_SYMBOL),
                      HistoryDealGetInteger(tk,DEAL_MAGIC),_Symbol,InpMagic)) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)==DEAL_ENTRY_IN) return(true);
     }
   return(false);
  }

//--- La guardia vera e propria, chiamata a ogni tick da OnTick().
void UnTradeAlGiorno()
  {
   bool posMia=(ContaPosizioniMie()>0);

   //--- (1) CONOSCENZA. Il timbro si accende una volta sola. La posizione
   //    viva si guarda sempre (non costa niente); lo storico si interroga
   //    al massimo UNA VOLTA AL MINUTO e solo finche' il timbro e' spento:
   //    in campo sono poche letture al giorno, nel tester una al minuto
   //    simulato, e appena il timbro si accende non si legge piu'.
   if(!gOperatoOggi)
     {
      bool storicoLetto=false, gia=false;
      if(!posMia && TimeCurrent()-gUltimoCheckStorico>=60)
        {
         gUltimoCheckStorico=TimeCurrent();
         gia=HaGiaOperatoOggi(storicoLetto);
        }
      if(TimbraGiornata_Calc(posMia,storicoLetto,gia)) gOperatoOggi=true;
     }

   //--- (2) AZIONE, identica al gemello ABTG_ORB_Ottimizzato (ramo gHadPos):
   //    finito il trade del giorno, i pendenti superstiti non devono poter
   //    riaprire in giornata. CancelPendings() filtra gia' simbolo+magic e
   //    quando non c'e' niente da cancellare non fa nessuna chiamata.
   if(GiornataSpesa_Calc(InpOneTradePerDay,gOperatoOggi,posMia)) CancelPendings();
  }

//==================================================================
//  AUTOTEST DEI PREDICATI (v1.01)
//
//  Perche' esiste: qui non c'e' MetaEditor ne' Strategy Tester, quindi
//  senza questa funzione l'unica prova che le tabelle di verita' siano
//  scritte giuste sarebbe "l'ho riletto". Le quattro tabelle sono
//  COMPLETE (tutte le combinazioni), non a campione.
//  Cosa NON prova: che il terminale risponda quello che ci aspettiamo
//  (posizioni, storico, sincronizzazione). Quella resta la prova in
//  campo. Qui si prova che, DATE le risposte, decidiamo giusto.
//  Si legge ESEGUENDO: le righe escono nel Giornale al caricamento.
//==================================================================
void Autotest()
  {
   int blocchi=0, casi=0, falliti=0;

   const string S="MIOSIMBOLO";   // il nostro simbolo (finto: i predicati non toccano il terminale)
   const string A="ALTROSIMB";    // un simbolo qualsiasi che non e' il nostro
   const long   M=770601;         // il NOSTRO magic
   const long   V=772341;         // un vicino (il magic di LARRY DOW S, la FOTO A del 03/09)

   //--- BLOCCO 1: simbolo+magic. Il magic da solo non basta, il simbolo nemmeno.
   blocchi++; casi+=4;
   if(!( PosMia_Calc(S,M,S,M) && !PosMia_Calc(A,M,S,M) &&
        !PosMia_Calc(S,V,S,M) && !PosMia_Calc(A,V,S,M) ))
     { falliti++; Print("ORB AUTOTEST: 1 PosMia_Calc DIVERGE"); }

   //--- BLOCCO 2: il timbro. Tabella completa (posMia, storicoLetto, gia).
   //    Le due righe che contano sono (F,F,T) e (F,F,F): storico NON letto
   //    = "non lo so" = NON si timbra, mai.
   blocchi++; casi+=8;
   if(!( TimbraGiornata_Calc(true ,false,false) && TimbraGiornata_Calc(true ,false,true ) &&
         TimbraGiornata_Calc(true ,true ,false) && TimbraGiornata_Calc(true ,true ,true ) &&
        !TimbraGiornata_Calc(false,false,false) && !TimbraGiornata_Calc(false,false,true ) &&
        !TimbraGiornata_Calc(false,true ,false) &&  TimbraGiornata_Calc(false,true ,true ) ))
     { falliti++; Print("ORB AUTOTEST: 2 TimbraGiornata_Calc DIVERGE"); }

   //--- BLOCCO 3: giornata spesa. Tabella completa (uno, operato, posMia).
   //    L'unico VERO e' (T,T,F): input acceso, ho operato, e la posizione
   //    non c'e' piu'. Con la posizione ancora viva deve essere FALSO.
   blocchi++; casi+=8;
   if(!( !GiornataSpesa_Calc(false,false,false) && !GiornataSpesa_Calc(false,false,true ) &&
         !GiornataSpesa_Calc(false,true ,false) && !GiornataSpesa_Calc(false,true ,true ) &&
         !GiornataSpesa_Calc(true ,false,false) && !GiornataSpesa_Calc(true ,false,true ) &&
          GiornataSpesa_Calc(true ,true ,false) && !GiornataSpesa_Calc(true ,true ,true ) ))
     { falliti++; Print("ORB AUTOTEST: 3 GiornataSpesa_Calc DIVERGE"); }

   //--- BLOCCO 4: il riarmo. Tabella completa (uno, operato). Con l'input
   //    SPENTO si arma sempre = la v1.00 esatta.
   blocchi++; casi+=4;
   if(!( PuoArmare_Calc(false,false) && PuoArmare_Calc(false,true ) &&
         PuoArmare_Calc(true ,false) && !PuoArmare_Calc(true ,true ) ))
     { falliti++; Print("ORB AUTOTEST: 4 PuoArmare_Calc DIVERGE"); }

   //--- IL CONTROLLO SUL CONTROLLO. Un gate che non conta quello che ha
   //    eseguito non e' un gate: un blocco cancellato passerebbe per
   //    "tutto verde", e un blocco svuotato delle asserzioni pure.
   if(blocchi!=ORB_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      PrintFormat("ORB AUTOTEST: eseguiti %d blocchi ma ne erano attesi %d: MANCA UN BLOCCO. Autotest FALLITO.",
                  blocchi,ORB_AUTOTEST_BLOCCHI_ATTESI);
     }
   if(casi!=ORB_AUTOTEST_CASI_ATTESI)
     {
      falliti++;
      PrintFormat("ORB AUTOTEST: dichiarati %d casi ma ne erano attesi %d: un blocco e' stato SVUOTATO. Autotest FALLITO.",
                  casi,ORB_AUTOTEST_CASI_ATTESI);
     }

   PrintFormat("ORB AUTOTEST: %d blocchi su %d passati, %d casi dichiarati, %d falliti. %s",
               blocchi-falliti,blocchi,casi,falliti,
               (falliti==0 ? "Predicati 'un trade al giorno' VERIFICATI a tavolino (NON sostituisce la prova in campo)."
                           : "ATTENZIONE: i predicati NON sono quelli attesi. NON mettere in forward."));
  }

//==================================================================
//  UTILITY
//==================================================================
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)<1) return(0); return(a[0]); }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
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

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }
bool SelPos(){ if(!PositionSelect(_Symbol)) return(false); return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro spento."); return; }
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
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

double OnTester()
  {
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
