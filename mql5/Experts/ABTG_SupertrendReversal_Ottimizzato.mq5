//+------------------------------------------------------------------+
//|                                      ABTG_SupertrendReversal.mq5  |
//|                                                                  |
//|  EA "SUPERTREND REVERSAL" - MT5 - VERSIONE TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Basato sul documento "Strategia SUPERTREND REVERSAL" (ABTG).   |
//|  TF consigliati H4/D1/W1 (esempi anche H1).                     |
//|                                                                  |
//|  CUORE MECCANICO (automatizzato):                               |
//|   - RIMBALZO: la candela tocca/viola il Supertrend(10,3.5) con  |
//|     l'ombra e CHIUDE VICINO al livello (perdita di forza).      |
//|   - CONFERMA: la candela successiva APRE "dentro" il Supertrend |
//|     (sul lato del trend) e conferma la direzione.              |
//|   - CONFLUENZA (richiesta): un livello tecnico vicino al        |
//|     rimbalzo (qui: prossimita' a una EMA 14/89/100/200).       |
//|   - INGRESSO frazionato: 1/3 a mercato + 2/3 pendente +/-20 pip.|
//|   - SL dinamico su Supertrend / estremo recente.               |
//|   - TP su RR (>=1:2); parziale al 1o target + stop in pari;    |
//|     trailing su Supertrend / uscita su flip.                   |
//|                                                                  |
//|  NON automatizzato (discrezionale, come da documento):          |
//|   Fibonacci/Multipivot/Larry Williams, Supply&Demand, timing    |
//|   intra-candela, lettura del contesto. Restano all'occhio umano.|
//|  DEMO. Nessun EA garantisce profitti.                          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.01"
#property strict

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

//==================================================================
//  INPUT
//==================================================================
input group "=== Supertrend e timeframe ==="
input ENUM_TIMEFRAMES InpTF   = PERIOD_H4;  // TF operativo (documento: H4/D1/W1)
input double InpStMult        = 2.5;        // OTT XAUUSD H4 (era 3.5)
input int    InpStAtrPeriod   = 7;          // OTT XAUUSD H4 (era 10)

input group "=== Pattern rimbalzo ==="
input double InpNearAtr       = 1.0;   // "chiude vicino": |chiusura - Supertrend| <= N*ATR
input bool   InpRequireConfirmBody = true; // candela di conferma coerente (corpo in direzione)
input bool   InpAllowLong     = true;
input bool   InpAllowShort    = true;

input group "=== Confluenza tecnica (richiesta dal documento) ==="
input bool   InpUseConfluence = true;  // il rimbalzo deve avvenire vicino a una EMA
input int    InpEma1          = 14;    // EMA (primo target naturale)
input int    InpEma2          = 89;
input int    InpEma3          = 100;
input int    InpEma4          = 200;
input double InpConflAtr       = 1.5;  // "vicino a EMA": distanza <= N*ATR

input group "=== Ingresso frazionato ==="
input double InpFirstFraction = 0.3333; // quota a mercato (documento: 1/3)
input bool   InpUsePending    = true;   // resto (2/3) su ordine pendente stop
input double InpPendingPips    = 20;    // distanza del pendente dal 1o ingresso (documento: ~20 pip)
input int    InpPendingExpiryBars = 3;  // scadenza del pendente in barre del TF operativo

input group "=== Stop / target ==="
input int    InpSLLookback    = 5;      // barre per il minimo/massimo recente dello SL
input double InpSLBufferPips   = 3;     // buffer extra sullo SL, in pip
input double InpTP1_R         = 1.0;    // 1o target in R -> parziale + stop in pari
input double InpTP1Pct        = 50;     // % chiusa al 1o target
input bool   InpBreakeven     = true;
input double InpTP_RR         = 2.5;    // OTT XAUUSD H4 (era 2.0)
input bool   InpTrailOnST      = true;  // trailing dello stop sul Supertrend
input bool   InpExitOnFlip     = true;  // esci se il Supertrend gira contro

input group "=== Rischio ==="
input double InpRiskPercent   = 2.0;    // OTT: rischio 2% (PF alto). DD backtest ~2,6% -> occhio alla concentrazione oro
input int    InpMaxTradesPerDay = 0;    // 0 = illimitato

input group "=== Filtro orari (ORA SERVER; opzionale) ==="
input bool   InpUseTimeWindow = false;
input int    InpStartHour     = 0;
input int    InpEndHour       = 24;

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 30;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies = "";

input group "=== Generali ==="
input string InpComment   = "STREV OTT";
input long   InpMagic     = 970901;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//--- IMBUTO DI MORTALITA' (11/09/2026): governa SOLO il log, non il trading.
//    true  = a fine giornata scrive nel Giornale una riga che dice quante
//            candidate d'ingresso sono state scartate e DA QUALE condizione.
//    false = nessuna riga (i contatori girano lo stesso, in memoria).
//    Default true: un log non e' un rischio, e senza di lui questa sedia era
//    CIECA (report/PERCHE_ENTRANO_POCO_2026-09-11.md).
input bool   InpLogImbuto = true;   // Imbuto: riepilogo giornaliero dei rifiuti nel Giornale

//==================================================================
//  STATO
//==================================================================
int  hAtr=INVALID_HANDLE, hE1=INVALID_HANDLE, hE2=INVALID_HANDLE, hE3=INVALID_HANDLE, hE4=INVALID_HANDLE;
datetime gLastBar=0, gPendingBar=0;
int  gDay=-1, gTradesToday=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[STReversal] ", m); }

//==================================================================
//  IMBUTO DI MORTALITA' [STREV-IMBUTO] -- SOLO DIAGNOSTICA (11/09/2026)
//  PERCHE': su questa sedia il rifiuto d'ingresso era MUTO. Dal log
//  non si distingueva "non c'era il segnale" da "il segnale c'era e
//  qualcosa l'ha fermato" (report/PERCHE_ENTRANO_POCO_2026-09-11.md,
//  paragrafo 5: sedie cieche). Qui si conta CHI ha ucciso l'ingresso.
//  !! Sono SOLO incrementi e Print: nessun contatore entra in una
//  condizione, nessuna soglia, nessun lotto, nessun ordine cambiano.
//  COME SI LEGGE -- l'imbuto e' ORDINATO: ogni candidata e' attribuita
//  alla PRIMA condizione che la ferma, nell'ordine in cui il codice le
//  controlla. Uno zero su un filtro in fondo NON vuol dire che quel
//  filtro non morde mai: vuol dire che le candidate erano gia' morte
//  prima. La 'quadratura' in fondo alla riga e' la prova che nessun
//  ramo sfugge al conteggio: somma dei rifiuti + ENTRATE == valutate.
//==================================================================
long cV_valutate=0;  // barre nuove arrivate alla valutazione d'ingresso
long cB_stnd=0;      // Supertrend non calcolabile (storico corto)
long cB_occupata=0;  // posizione gia' aperta: non si cercano ingressi
long cB_pendente=0;  // pendente 2/3 ancora in attesa
long cB_maxday=0;    // tetto di operazioni giornaliere raggiunto
long cB_orario=0;    // fuori dalla finestra oraria
long cB_news=0;      // blackout news
long cB_spread=0;    // spread oltre il massimo
long cF_stgirato=0;  // il Supertrend ha appena girato (niente continuazione)
long cF_pattern=0;   // niente pattern di rimbalzo (tocco/chiusura/apertura/corpo)
long cF_confl=0;     // nessuna confluenza EMA vicina
long cF_lato=0;      // lato disabilitato da input
long cF_atr=0;       // ATR non disponibile
long cO_sl=0;        // SL troppo vicino (stops level / buffer)
long cO_lotto=0;     // lotto nullo
long cO_guardian=0;  // fermato dal Guardian del conto
long cO_invio=0;     // invio dell'ordine a mercato fallito
long cI_entrate=0;   // INGRESSI ESEGUITI (tranche a mercato)
//--- riepilogo di fine giornata: i contatori restano CUMULATIVI (non si
//    azzerano mai, cosi' non si perde niente e OnTester resta valido) e
//    la riga stampa la DIFFERENZA con la fotografia di inizio giornata.
long     gImbSnap[];
int      gImbGiorno=-1;
datetime gImbData=0;

//==================================================================
//  IMBUTO: raccolta, stampa e giro di giornata. Tre funzioni che
//  NON toccano ne' il mercato ne' lo stato dell'EA: leggono contatori
//  e scrivono una riga. La riga esce al primo tick del giorno DOPO
//  (e a OnDeinit per l'ultimo giorno aperto): un riepilogo per
//  giornata, non una riga per tick.
//==================================================================
void ImbutoRaccogli(long &v[])
  {
   ArrayResize(v,18);
   v[0]=cV_valutate;
   v[1]=cB_stnd;
   v[2]=cB_occupata;
   v[3]=cB_pendente;
   v[4]=cB_maxday;
   v[5]=cB_orario;
   v[6]=cB_news;
   v[7]=cB_spread;
   v[8]=cF_stgirato;
   v[9]=cF_pattern;
   v[10]=cF_confl;
   v[11]=cF_lato;
   v[12]=cF_atr;
   v[13]=cO_sl;
   v[14]=cO_lotto;
   v[15]=cO_guardian;
   v[16]=cO_invio;
   v[17]=cI_entrate;
  }

void ImbutoStampa(string quando)
  {
   if(!InpLogImbuto) return;
   long v[]; ImbutoRaccogli(v);
   int n=ArraySize(v);
   if(ArraySize(gImbSnap)!=n){ ArrayResize(gImbSnap,n); ArrayInitialize(gImbSnap,0); }
   long d[]; ArrayResize(d,n);
   for(int i=0;i<n;i++) d[i]=v[i]-gImbSnap[i];
   long somma=0; for(int i=1;i<n;i++) somma+=d[i];
   if(d[0]<=0 && somma<=0) return;   // giornata senza candidate: niente riga
   string s="[STREV-IMBUTO] "+_Symbol+" "+EnumToString(InpTF)+" "+quando+
            " | valutate "+IntegerToString(d[0])+
            " | supertrend n/d "+IntegerToString(d[1])+
            " | occupata "+IntegerToString(d[2])+
            " | pendente in attesa "+IntegerToString(d[3])+
            " | tetto giornaliero "+IntegerToString(d[4])+
            " | fuori orario "+IntegerToString(d[5])+
            " | news "+IntegerToString(d[6])+
            " | spread "+IntegerToString(d[7])+
            " | supertrend girato "+IntegerToString(d[8])+
            " | niente pattern "+IntegerToString(d[9])+
            " | confluenza EMA assente "+IntegerToString(d[10])+
            " | lato spento "+IntegerToString(d[11])+
            " | ATR n/d "+IntegerToString(d[12])+
            " | SL troppo vicino "+IntegerToString(d[13])+
            " | lotto nullo "+IntegerToString(d[14])+
            " | guardian "+IntegerToString(d[15])+
            " | invio fallito "+IntegerToString(d[16])+
            " | ENTRATE "+IntegerToString(d[17])+
            " | quadratura "+((somma==d[0])?"OK":
             ("ROTTA: somma "+IntegerToString(somma)+" contro valutate "+IntegerToString(d[0])));
   Print(s);
  }

void ImbutoGiro()
  {
   if(!InpLogImbuto) return;
   datetime ora=TimeCurrent();
   MqlDateTime t; TimeToStruct(ora,t);
   if(gImbGiorno<0){ gImbGiorno=t.day_of_year; gImbData=ora; ImbutoRaccogli(gImbSnap); return; }
   if(t.day_of_year==gImbGiorno) return;
   ImbutoStampa("giorno "+TimeToString(gImbData,TIME_DATE));
   ImbutoRaccogli(gImbSnap);
   gImbGiorno=t.day_of_year; gImbData=ora;
  }

//+------------------------------------------------------------------+
double PipSize()
  {
   int d=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   return (d==3 || d==5) ? _Point*10.0 : _Point;
  }

int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr = iATR(_Symbol,InpTF,InpStAtrPeriod);
   hE1  = iMA(_Symbol,InpTF,InpEma1,0,MODE_EMA,PRICE_CLOSE);
   hE2  = iMA(_Symbol,InpTF,InpEma2,0,MODE_EMA,PRICE_CLOSE);
   hE3  = iMA(_Symbol,InpTF,InpEma3,0,MODE_EMA,PRICE_CLOSE);
   hE4  = iMA(_Symbol,InpTF,InpEma4,0,MODE_EMA,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE||hE1==INVALID_HANDLE||hE2==INVALID_HANDLE||hE3==INVALID_HANDLE||hE4==INVALID_HANDLE)
     { Print("ERRORE: handle indicatori."); return(INIT_FAILED); }
   if(InpUseNewsFilter) LoadNews();
   Log(StringFormat("avviato su %s %s. Supertrend(%d,%.1f). 1 pip=%.5f",
       _Symbol,EnumToString(InpTF),InpStAtrPeriod,InpStMult,PipSize()));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   ImbutoStampa("parziale del "+TimeToString(gImbData,TIME_DATE));
   int hs[5]={hAtr,hE1,hE2,hE3,hE4};
   for(int i=0;i<5;i++) if(hs[i]!=INVALID_HANDLE) IndicatorRelease(hs[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ImbutoGiro();   // IMBUTO: solo log, nessuna decisione
   ManageAll();

   datetime t=iTime(_Symbol,InpTF,0);
   if(t==gLastBar) return;
   gLastBar=t;

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar(now);
  }

//+------------------------------------------------------------------+
void OnNewBar(MqlDateTime &now)
  {
   cV_valutate++;                                  // IMBUTO: una candidata per barra nuova
   double dir[],line[];
   if(!SupertrendSeries(5,dir,line)){ cB_stnd++; return; }

   //--- uscita su flip (runner): chiude TUTTE le posizioni del magic
   if(HasPosition())
     {
      cB_occupata++;   // IMBUTO: un solo incremento per ENTRAMBE le uscite del blocco
      int d1=(int)dir[1];
      if(InpExitOnFlip && ((d1<0 && LongOpen())||(d1>0 && ShortOpen())))
        { CloseAllPositions(); CancelPendings(); Log("Supertrend flip: uscita."); return; }
      return;                       // con posizione aperta non cerco nuovi ingressi
     }
   if(HasPending()){ cB_pendente++; return; }   // pendente 2/3 gia' in attesa

   //--- filtri generali
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay){ cB_maxday++; return; }
   if(InpUseTimeWindow && (now.hour<InpStartHour || now.hour>=InpEndHour)){ cB_orario++; return; }
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())){ cB_news++; return; }
   if(!SpreadOK()){ cB_spread++; return; }

   //--- Supertrend deve NON aver girato (continuazione): dir[2]==dir[1]
   int d1=(int)dir[1], d2=(int)dir[2];
   if(d1!=d2){ cF_stgirato++; return; }
   bool up=(d1>0);
   if(up && !InpAllowLong){ cF_lato++; return; }
   if(!up && !InpAllowShort){ cF_lato++; return; }

   //--- pattern rimbalzo su candela [2] (tocco) confermata da candela [1] (apre dentro)
   double atr=AtrVal(); if(atr<=0){ cF_atr++; return; }
   double stTouch=line[2], stConf=line[1];
   double lo2=iLow(_Symbol,InpTF,2), hi2=iHigh(_Symbol,InpTF,2), cl2=iClose(_Symbol,InpTF,2);
   double op1=iOpen(_Symbol,InpTF,1), cl1=iClose(_Symbol,InpTF,1);

   bool touch, closeNear, opensInside, bodyOK, timingOK=true;
   if(up)
     {
      touch       = (lo2<=stTouch);              // l'ombra viola il floor
      closeNear   = (cl2>stTouch) && ((cl2-stTouch)<=InpNearAtr*atr); // chiude sopra e vicino
      opensInside = (op1>=stConf);               // la successiva apre dentro (sopra il floor)
      bodyOK      = (!InpRequireConfirmBody) || (cl1>=op1);
     }
   else
     {
      touch       = (hi2>=stTouch);
      closeNear   = (cl2<stTouch) && ((stTouch-cl2)<=InpNearAtr*atr);
      opensInside = (op1<=stConf);
      bodyOK      = (!InpRequireConfirmBody) || (cl1<=op1);
     }
   if(!(touch && closeNear && opensInside && bodyOK)){ cF_pattern++; return; }

   //--- confluenza: il rimbalzo (stTouch) e' vicino a una EMA
   if(InpUseConfluence && !ConfluenceOK(stTouch,atr)) { cF_confl++; Log("nessuna confluenza EMA vicina: skip."); return; }

   Enter(up,line[1]);
  }

//+------------------------------------------------------------------+
bool ConfluenceOK(double level,double atr)
  {
   double e[1];
   int hs[4]={hE1,hE2,hE3,hE4};
   for(int i=0;i<4;i++)
      if(CopyBuffer(hs[i],0,1,1,e)==1 && MathAbs(level-e[0])<=InpConflAtr*atr) return(true);
   return(false);
  }

//+------------------------------------------------------------------+
//| Ingresso: 1/3 a mercato + 2/3 pendente stop +/-20 pip            |
//+------------------------------------------------------------------+
void Enter(bool isLong,double stLine)
  {
   double pip=PipSize();
   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK), bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double entry=isLong?ask:bid;

   //--- SL dinamico: Supertrend o estremo recente (il piu' protettivo), + buffer
   double ext = isLong ? iLow(_Symbol,InpTF,iLowest(_Symbol,InpTF,MODE_LOW,InpSLLookback,1))
                       : iHigh(_Symbol,InpTF,iHighest(_Symbol,InpTF,MODE_HIGH,InpSLLookback,1));
   double buf=InpSLBufferPips*pip;
   double sl = isLong ? MathMin(stLine,ext)-buf : MathMax(stLine,ext)+buf;
   sl=NormalizePrice(sl);

   double risk=isLong?(entry-sl):(sl-entry);
   double minDist=MathMax(buf,(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point);
   if(risk<minDist){ cO_sl++; Log("SL troppo vicino: skip."); return; }

   double tp = isLong ? entry+risk*InpTP_RR : entry-risk*InpTP_RR;
   tp=NormalizePrice(tp);

   double totLot=LotByRisk(risk);
   if(totLot<=0){ cO_lotto++; Log("lotto nullo."); return; }

   double lotMkt=NormVol(totLot*InpFirstFraction);
   //--- CORREZIONE 08/09/2026: il pavimento del lotto minimo ora e' applicato
   //    PRIMA del calcolo di lotPend. Con l'ordine precedente, se NormVol()
   //    azzerava lotMkt (tranche sotto il minimo), lotPend si prendeva TUTTO
   //    totLot e subito dopo lotMkt risorgeva al minimo: volume totale
   //    totLot+volMin, cioe' fino al doppio del rischio dichiarato.
   //    Misurato in campo il 20/08/2026: 1,42% su un contratto da 1,0%.
   //    Ora lotPend si calcola su cio' che resta DAVVERO; se resta sotto il
   //    minimo NormVol torna 0 e la guardia (InpUsePending && lotPend>0)
   //    salta il pendente: volume totale = lotMkt. Coerente.
   if(lotMkt<=0) lotMkt=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double lotPend=NormVol(totLot-lotMkt);

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_SupertrendReversal_Ottimizzato")){ cO_guardian++; return; }
   bool ok=isLong?gTrade.Buy(lotMkt,_Symbol,ask,sl,tp,InpComment+" L 1/3")
                 :gTrade.Sell(lotMkt,_Symbol,bid,sl,tp,InpComment+" S 1/3");
   if(!ok){ cO_invio++; Log("apertura a mercato fallita: "+gTrade.ResultRetcodeDescription()); return; }
   cI_entrate++;
   gTradesToday++;
   Log(StringFormat("%s mercato %.2f lot @ %s SL %s TP %s",isLong?"LONG":"SHORT",lotMkt,
       DoubleToString(entry,_Digits),DoubleToString(sl,_Digits),DoubleToString(tp,_Digits)));

   //--- 2/3 su pendente stop nella direzione del trade
   if(InpUsePending && lotPend>0)
     {
      double px = isLong ? NormalizePrice(entry+InpPendingPips*pip) : NormalizePrice(entry-InpPendingPips*pip);
      double tpP= isLong ? NormalizePrice(px+risk*InpTP_RR) : NormalizePrice(px-risk*InpTP_RR);
      datetime exp=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(InpTF);
      bool okp=isLong?gTrade.BuyStop(lotPend,px,_Symbol,sl,tpP,ORDER_TIME_SPECIFIED,exp,InpComment+" L 2/3")
                     :gTrade.SellStop(lotPend,px,_Symbol,sl,tpP,ORDER_TIME_SPECIFIED,exp,InpComment+" S 2/3");
      if(okp){ gPendingBar=iTime(_Symbol,InpTF,0); Log(StringFormat("pendente 2/3 %.2f lot @ %s",lotPend,DoubleToString(px,_Digits))); }
     }
  }

//+------------------------------------------------------------------+
//| Gestione di TUTTE le posizioni del magic (netting o hedging):    |
//| parziale a 1R + stop in pari, poi trailing sul Supertrend.       |
//| "Parziale gia' fatto" e' dedotto dallo SL gia' in pari (nessuno  |
//| stato globale, robusto anche con piu' posizioni contemporanee).  |
//+------------------------------------------------------------------+
void ManageAll()
  {
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double stLine=0; bool haveST=false;
   double dir[],line[];
   if(InpTrailOnST && SupertrendSeries(3,dir,line)){ stLine=NormalizePrice(line[1]); haveST=true; }

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      double vol=PositionGetDouble(POSITION_VOLUME);

      // parziale a 1R (solo se lo SL non e' ancora in pari)
      bool beDone = isLong ? (sl>=openP) : (sl<=openP && sl>0);
      double risk = isLong ? (openP-sl) : (sl-openP);
      if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
            double cv=NormVol(vol*InpTP1Pct/100.0);
            // Lo STOP IN PARI non deve dipendere dalla riuscita del parziale.
            // Al LOTTO MINIMO NormVol(vol*50%) arrotonda a 0: il parziale non
            // parte mai e, prima del 04/08/2026, con lui saltava anche il
            // breakeven. Misurato: due short oro a 0,01 lotti hanno toccato
            // 1,28R di profitto con lo stop ancora all'originale, e sono
            // tornati in perdita (-112,78 EUR di oscillazione).
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakeven) gTrade.PositionModify(tk,NormalizePrice(openP),tp);
            Log(parz ? "1o target (1R): parziale + stop in pari."
                     : "1o target (1R): stop in pari (parziale impossibile al lotto minimo).");
           }
        }

      // trailing sul Supertrend
      if(haveST)
        {
         double slNow=PositionGetDouble(POSITION_SL);
         if(isLong && stLine>slNow && stLine<bid) gTrade.PositionModify(tk,stLine,PositionGetDouble(POSITION_TP));
         if(!isLong && (stLine<slNow||slNow==0) && stLine>ask) gTrade.PositionModify(tk,stLine,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Supertrend (series): dir (+1/-1) e linea, per barra chiusa idx1  |
//+------------------------------------------------------------------+
bool SupertrendSeries(int count,double &dirOut[],double &lineOut[])
  {
   int need=InpStAtrPeriod+count+220;
   MqlRates r[]; ArraySetAsSeries(r,true);
   int copied=CopyRates(_Symbol,InpTF,0,need,r);
   if(copied<InpStAtrPeriod+count+5) return(false);
   double atr[]; ArraySetAsSeries(atr,true);
   if(CopyBuffer(hAtr,0,0,copied,atr)<copied) return(false);

   ArrayResize(dirOut,copied); ArrayResize(lineOut,copied);
   ArraySetAsSeries(dirOut,true); ArraySetAsSeries(lineOut,true);

   double finalUpper=0, finalLower=0; int dir=+1;
   for(int i=copied-2;i>=0;i--)
     {
      double hl2=(r[i].high+r[i].low)/2.0;
      double bUp=hl2+InpStMult*atr[i], bLo=hl2-InpStMult*atr[i];
      double prevFU=(finalUpper==0)?bUp:finalUpper;
      double prevFL=(finalLower==0)?bLo:finalLower;
      double pc=r[i+1].close;
      double fU=(bUp<prevFU||pc>prevFU)?bUp:prevFU;
      double fL=(bLo>prevFL||pc<prevFL)?bLo:prevFL;
      if(r[i].close > (dir==-1?prevFU:fU))      dir=+1;
      else if(r[i].close < (dir==+1?prevFL:fL)) dir=-1;
      finalUpper=fU; finalLower=fL;
      dirOut[i]=dir;
      lineOut[i]=(dir>0)?fL:fU;
     }
   return(true);
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

//--- posizioni del magic (compatibile netting e hedging)
bool HasPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

bool DirOpen(bool wantLong)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      if(isLong==wantLong) return(true);
     }
   return(false);
  }
bool LongOpen(){ return(DirOpen(true)); }
bool ShortOpen(){ return(DirOpen(false)); }

void CloseAllPositions()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      gTrade.PositionClose(tk);
     }
  }

bool HasPending()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

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

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
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
