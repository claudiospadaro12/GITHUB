//+------------------------------------------------------------------+
//|                                        ABTG_FiboH4_Multi.mq5      |
//|                                                                  |
//|  EA "FIBO H4 - MULTI-SIMBOLO" - MT5 - TUTTO-IN-UNO             |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Come ABTG_FiboH4 ma SCANSIONA PIU' CROSS da un solo grafico.   |
//|  Metti la lista in InpSymbols (separati da ; o ,). Su ogni      |
//|  simbolo cerca il setup engulfing + entry zone Fibo e piazza    |
//|  gli ordini se ci sono le condizioni. Gestione per-simbolo.     |
//|                                                                  |
//|  Un solo grafico -> molti cross. Magic 771602 (diverso dalla    |
//|  versione singola 771601). Tetto InpMaxTotalPositions come      |
//|  sicurezza sull'esposizione totale.                            |
//|                                                                  |
//|  NB: i simboli devono esistere sul broker (Market Watch) con    |
//|  storico H4 disponibile. Valori Fibo proprietari 1.88/2.88,     |
//|  SL 4.236, come nella versione singola. DEMO. Nessuna garanzia. |
//+------------------------------------------------------------------+
//
//==================================================================
//  QUELLO CHE VA DETTO PRIMA DI GUARDARE UN NUMERO DI QUESTO EA
//------------------------------------------------------------------
//  1. QUESTO EA NON IMPLEMENTA LA STRATEGIA DEL CORSO.
//     Implementa una strategia diversa che porta lo stesso nome.
//     Misurato il 18/08/2026 leggendo le lezioni 18-20
//     (backtest_pipeline\prove\FIBOH4_CORSO_SPEC.md par. 3.2, 3.3, 10
//      e caccia_strategie\ANALISI_CORSO_FIBOH4_MEDIA200_2026-08-18.md
//      par. 1.2). Le tre divergenze, coi fattori:
//        distanza dei 2 ordini  noi 1,0 x range  corso 0,10 x range  ~x10
//        target                 noi estremo opp. corso livello 100    x2,1
//        stop                   noi 4,236 fisso  corso 1 dei 7 metodi ~x4
//     Aritmetica gia' fatta: la gamba EZ1 ha R:R strutturale 0,80,
//     cioe' le serve win rate > 56% SOLO PER PAREGGIARE, prima di
//     spread e commissioni.
//
//  2. C'E' UN 0/8 IN ARCHIVIO, ed e' su QUESTA geometria.
//     Coda fascia B del 10-11/08/2026:
//     risultati_archivio\REFERTO_CODA_FASCIA_B.md riga 30 --
//     "ABTG_FiboH4_Multi -- 0/8 promossi. Zero promozioni su 8 coppie
//      forex+oro H4. Mai piu' senza una tesi nuova."
//     Il 18/08 quel verdetto e' stato RITIRATO DI FATTO nella sua
//     PORTATA (bocciava la nostra geometria, non quella insegnata),
//     NON nel suo numero: il numero resta 0/8 e resta valido su
//     QUESTO codice.
//
//  3. >>> DIFETTO DI BANCO TROVATO IL 21/08/2026, e riguarda proprio
//     quel 0/8. Questo EA e' MULTI-SIMBOLO: opera sui simboli di
//     InpSymbols, NON sul simbolo del grafico. Nello scan del 16/08
//     (backtest_pipeline\risultati_prove\ABTG_FiboH4_Multi\*.csv)
//     la colonna InpSymbols vale "GBPUSD;USDJPY;EURUSD" in TUTTE le
//     passate, comprese quelle intitolate AUDUSD, CADJPY, GBPJPY,
//     USDCHF: il blocco FiboH4 di scan_market.ps1 non pinna
//     InpSymbols per simbolo (il blocco Bulge lo fa, col segnaposto
//     __SYM__). I numeri lo confermano: 7 file su 8 danno lo STESSO
//     risultato (IS da -384,56 a -394,13 / OOS da +116,17 a +118,68).
//     >>> Cioe' quello scan ha misurato OTTO VOLTE LO STESSO BASKET
//         DI TRE CROSS, non otto mercati. Il "0/8" e' in realta'
//         "una configurazione bocciata, contata otto volte".
//     Chi rifa' un round su questo EA DEVE pinnare InpSymbols.
//
//  4. Il filtro notizie c'era gia' ed era SPENTO. Il corso lo rende
//     OBBLIGATORIO (FIBOH4_CORSO_SPEC.md par. 8). E' la riga D5 di
//     report\PIANO_PROP.md. R93 lo MISURA: non lo accende per fede.
//==================================================================
//  CHANGELOG
//  v1.00  EA originale (piano FiboH4). Logica dei segnali INTOCCATA
//         da qui in avanti.
//  v1.10  21/08/2026 -- MIGRAZIONE AGLI STANDARD DI CASA + il filtro
//         notizie reso USABILE NEL TESTER.
//         VERIFICA A MACCHINA, rifacibile e non a memoria:
//           python3 backtest_pipeline\diff_blocco_segnale.py \
//             mql5\Experts\ABTG_FiboH4_Multi.mq5 --auto \
//             "bool BullEngulf(" "bool BearEngulf(" "void TryPlace(" \
//             "void PlaceLimit(" "void OnNewBar("
//         Esito del 21/08/2026, v1.00 (3af47ed) contro v1.10:
//           BullEngulf  diff 0   IDENTICO
//           BearEngulf  diff 0   IDENTICO
//           TryPlace    diff 0   IDENTICO   <- la GEOMETRIA e' intatta
//           PlaceLimit  diff 1   +1 riga: la guardia del Guardian
//           OnNewBar    diff 1   +1 riga: il filtro news riceve il simbolo
//         Le DUE righe cambiate sono queste due e nessun'altra, e sono
//         dichiarate qui sotto ai punti 1 e 4(c). Le tre funzioni che
//         decidono DOVE va l'ordine non sono state toccate.
//         Cosa e' cambiato, tutto qui:
//          1. GUARDIAN (firme B1/C1 del 18/08): #include
//             <ABTG_PausaGuardian.mqh> + InpUsaGuardian (default
//             true) + ABTG_GuardiaIngresso() chiamata sul percorso di
//             APERTURA (dentro PlaceLimit, subito prima dell'ordine),
//             MAI sulle chiusure/cancellazioni. Nel tester le sue
//             GlobalVariable non esistono -> fail-open totale -> i
//             numeri restano confrontabili con quelli di prima.
//             >>> DIPENDENZA: il .mqh dev'essere in MQL5\Include.
//                 walkforward_generico.ps1 scarica SOLO il .mq5:
//                 lo installa lancia_r93.ps1 (o installa_guardian.ps1).
//          2. OnTester standard di famiglia: ExportTrades (per-trade,
//             DD di portafoglio) + gWorstDayPct (peggior giornata %)
//             + le 3 colonne che servono a una prop.
//          3. InpAutoTest (default true): stampa [FIBOH4][AUTOTEST]
//             in avvio. Si legge ESEGUENDO (test singolo nel tester),
//             non compilando: F7 compila e basta. Nessun ordine.
//          4. FILTRO NOTIZIE -- quattro correzioni di MECCANISMO, non
//             di strategia. Coi default il comportamento e' identico
//             a prima (InpUseNewsFilter resta false).
//             (a) FILE_COMMON (InpNewsCommon, default true): nel
//                 tester ogni agente ha la SUA sandbox MQL5\Files e
//                 il file NON ci arriva -> FileOpen falliva -> il
//                 filtro si spegneva DA SOLO, in silenzio. Common\
//                 Files e' condiviso dagli agenti locali (in casa e'
//                 gia' la strada di ExportTrades). Se non lo trova
//                 in Common ripiega sulla sandbox e LO DICE.
//             (b) CANARINO OBBLIGATORIO: se il filtro e' acceso e il
//                 file non si legge, o si legge e produce ZERO
//                 eventi utili, l'EA STAMPA IN CHIARO
//                 "[FIBOH4][NEWS] FILTRO ACCESO MA CIECO". E' il
//                 difetto 31-bis della checklist: un filtro senza
//                 dato diventa neutro e la cella esce identica alla
//                 baseline -> si scriverebbe "il filtro e' neutro"
//                 misurando un filtro che non e' mai girato.
//             (c) ESCLUSIONE PER VALUTA (InpNewsPerCurrency, default
//                 false = comportamento di prima). Prima gNewsCcy
//                 veniva CARICATO E MAI USATO: il blackout era
//                 GLOBALE, una notizia sullo yen fermava anche
//                 EURUSD. Il corso chiede l'esclusione per valuta
//                 ("come numeratore o denominatore").
//             (d) VELOCITA': gli eventi sotto InpNewsMinImpact non
//                 entrano piu' in memoria, l'array si alloca a
//                 blocchi e la ricerca e' BINARIA su array ordinato
//                 (con verifica dell'ordinamento e ripiego lineare
//                 dichiarato). Con 22.503 righe di calendario la
//                 scansione lineare a ogni barra x 3 simboli x 28
//                 passate non era proponibile.
//          5. NUOVO, SPENTO DI DEFAULT: InpNewsCancelPendings +
//             InpNewsDerogaPips (100). E' la regola del corso "prima
//             del dato gli ordini vanno tolti", con la deroga a >=100
//             pip di distanza. Default false = niente cambia.
//          6. ASCII puro.
//         COSA NON E' STATO TOCCATO, di proposito: la geometria
//         (1,88 / 2,88 / 4,236), il target, la mancanza di un filtro
//         di trend, la deroga "usa EZ2 se sei addosso a EZ1". Sono
//         le divergenze 1-6 dal corso: cambiarle e' un EA NUOVO, e
//         quella e' una decisione di Claudio, non una manutenzione.
//==================================================================
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.10"
#property strict

#include <Trade/Trade.mqh>
//--- firme B1/C1 del 18/08: la guardia del conto, lato EA.
//    Fail-open a tre livelli: input spento / canale inesistente /
//    battito vecchio. Nel tester e' inerte.
#include <ABTG_PausaGuardian.mqh>
CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== Simboli da scansionare ==="
input string InpSymbols = "GBPUSD;USDJPY;EURUSD"; // lista cross (separati da ; o ,). Vuoto = simbolo del grafico
input ENUM_TIMEFRAMES InpTF = PERIOD_H4;          // TF operativo (strategia: H4)
input int    InpMaxTotalPositions = 6;            // tetto posizioni aperte totali (sicurezza)

input group "=== Engulfing ==="
input int    InpEngulfLookback = 12;
input bool   InpAllowTwoCandle = true;
input double InpMinEngulfBodyPct = 25.0;
input bool   InpAllowLong  = true;
input bool   InpAllowShort = true;

input group "=== Entry Zone (Fibo FIBO H4 - valori proprietari) ==="
input double InpEZ1ratio = 1.88;
input double InpEZ2ratio = 2.88;
input double InpSLratio  = 4.236;
input bool   InpUseEZ2   = true;

input group "=== Distanza e validita' ==="
input double InpMinDistPips = 50.0;
input int    InpAtrPeriod   = 14;
input double InpMaxEngulfAtr = 3.0;
input int    InpPendingExpiryBars = 6;

input group "=== Stop / target ==="
input double InpSLbufferPips = 3.0;
input double InpTP1_R        = 1.0;
input double InpTP1Pct       = 50;
input bool   InpBreakeven    = true;
input bool   InpUseTrailing  = true;
input double InpTrailAtrMult = 2.0;

input group "=== Rischio e size (1/3 + 2/3) ==="
input double InpRiskPercent  = 1.0;    // rischio % per simbolo (diviso tra i due ordini)
input double InpFirstFraction = 0.3333;

input group "=== Chiusura giornaliera / weekend (ORA SERVER) ==="
input bool   InpUseCutoff   = true;
input int    InpCutoffHour  = 17;
input int    InpCutoffMin   = 45;
input bool   InpFridayClose = true;
input int    InpFridayCloseHour = 21;
input int    InpFridayCloseMin  = 50;

input group "=== Filtro notizie (CSV) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input bool   InpNewsCommon    = true;   // true = cerca in Common\Files (l'UNICA strada che regge nel tester multi-agente)
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;   // minuti da SOMMARE agli orari del CSV per portarli in ORA SERVER
input bool   InpNewsPerCurrency  = false; // false = blackout globale (come prima). true = solo se la valuta tocca il simbolo
input bool   InpNewsCancelPendings = false; // regola del corso: prima del dato gli ordini si TOLGONO
input double InpNewsDerogaPips     = 100.0; // deroga del corso: se il pendente e' a >= tot pip, resta

input group "=== Generali ==="
input string InpComment   = "FIBOH4";
input long   InpMagic     = 771602;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
input bool   InpUsaGuardian = true;  // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1). Inerte nel tester
input bool   InpAutoTest    = true;  // stampa [FIBOH4][AUTOTEST] in avvio. Si legge ESEGUENDO, non compilando

//==================================================================
//  STATO (per-simbolo)
//==================================================================
string   gSym[];
int      gAtr[];
datetime gLastBar[];
int      gN=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

//--- stato del filtro notizie: serve al CANARINO, non alla strategia.
bool     gNewsSorted   = true;   // array ordinato per tempo -> ricerca binaria
int      gNewsScartate = 0;      // righe illeggibili: si CONTANO, non spariscono
int      gNewsSottoSoglia = 0;   // righe scartate perche' impatto < soglia
string   gNewsDove     = "(mai aperto)";
long     gNewsBlocchi  = 0;      // quante volte il filtro ha davvero fermato una barra
long     gNewsBarreViste = 0;    // quante volte e' stato interrogato
long     gNewsPendCancellati = 0;

//--- metrica di famiglia: la peggior giornata in % (quella che conta per una prop)
double   gWorstDayPct  = 0.0;    // numero NEGATIVO
double   gEqInizioGiorno = 0.0;
int      gGiornoCorrente = -1;

void Log(string m){ if(InpVerbose) Print("[FiboH4Multi] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(30);

   string list=InpSymbols; StringReplace(list,","," "); StringReplace(list,";"," ");
   string parts[]; int k=StringSplit(list,' ',parts);
   ArrayResize(gSym,0);
   for(int i=0;i<k;i++)
     {
      string s=parts[i]; StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      int n=ArraySize(gSym); ArrayResize(gSym,n+1); gSym[n]=s;
     }
   if(ArraySize(gSym)==0){ ArrayResize(gSym,1); gSym[0]=_Symbol; }
   gN=ArraySize(gSym);

   ArrayResize(gAtr,gN); ArrayResize(gLastBar,gN);
   for(int i=0;i<gN;i++)
     {
      if(!SymbolSelect(gSym[i],true)) Log("attenzione: simbolo non selezionabile: "+gSym[i]);
      gAtr[i]=iATR(gSym[i],InpTF,InpAtrPeriod);
      gLastBar[i]=0;
      if(gAtr[i]==INVALID_HANDLE) Log("ATR non disponibile per "+gSym[i]);
     }
   gTrade.SetTypeFillingBySymbol(gSym[0]);
   if(InpUseNewsFilter) LoadNews();
   gEqInizioGiorno=AccountInfoDouble(ACCOUNT_EQUITY);
   Log(StringFormat("avviato su %d simboli, %s. EZ %.2f/%.2f, SL %.3f.",gN,EnumToString(InpTF),InpEZ1ratio,InpEZ2ratio,InpSLratio));
   if(InpAutoTest) AutoTestFiboH4();
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   for(int i=0;i<gN;i++) if(gAtr[i]!=INVALID_HANDLE) IndicatorRelease(gAtr[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   for(int i=0;i<gN;i++)
     {
      string sym=gSym[i];
      ManageAll(sym);
      CutoffCheck(sym);
      NewsCancelCheck(sym);
      FridayCloseCheck(sym);

      datetime t=iTime(sym,InpTF,0);
      if(t<=0 || t==gLastBar[i]) continue;
      gLastBar[i]=t;
      OnNewBar(sym,gAtr[i]);
     }
  }

//==================================================================
//  UTILITY PER-SIMBOLO
//==================================================================
double PipSize(string sym)
  {
   int d=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   double pt=SymbolInfoDouble(sym,SYMBOL_POINT);
   return (d==3 || d==5) ? pt*10.0 : pt;
  }

double AtrVal(int atrHandle)
  {
   double a[1]; if(CopyBuffer(atrHandle,0,1,1,a)!=1) return(0); return(a[0]);
  }

double NormalizePrice(string sym,double price)
  {
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Engulfing per-simbolo
bool BullEngulf(string sym,int i,double &swingHigh,double &swingLow)
  {
   double oi=iOpen(sym,InpTF,i), ci=iClose(sym,InpTF,i);
   double hi=iHigh(sym,InpTF,i), li=iLow(sym,InpTF,i);
   double op=iOpen(sym,InpTF,i+1), cp=iClose(sym,InpTF,i+1);
   double hp=iHigh(sym,InpTF,i+1), lp=iLow(sym,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBear=(cp<op);
   bool coverFull=(hi>=hp && li<=lp && ci>oi);
   if(prevBear && coverFull && strong){ swingHigh=hp; swingLow=li; return(true); }
   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(sym,InpTF,i-1));
      double l2=MathMin(li,iLow(sym,InpTF,i-1));
      double c2=iClose(sym,InpTF,i-1);
      if(prevBear && h2>=hp && l2<=lp && c2>op){ swingHigh=hp; swingLow=l2; return(true); }
     }
   return(false);
  }

bool BearEngulf(string sym,int i,double &swingHigh,double &swingLow)
  {
   double oi=iOpen(sym,InpTF,i), ci=iClose(sym,InpTF,i);
   double hi=iHigh(sym,InpTF,i), li=iLow(sym,InpTF,i);
   double op=iOpen(sym,InpTF,i+1), cp=iClose(sym,InpTF,i+1);
   double hp=iHigh(sym,InpTF,i+1), lp=iLow(sym,InpTF,i+1);
   double rng=hi-li; if(rng<=0) return(false);
   bool strong=(MathAbs(ci-oi) >= InpMinEngulfBodyPct/100.0*rng);
   bool prevBull=(cp>op);
   bool coverFull=(hi>=hp && li<=lp && ci<oi);
   if(prevBull && coverFull && strong){ swingHigh=hi; swingLow=lp; return(true); }
   if(InpAllowTwoCandle && i>=2)
     {
      double h2=MathMax(hi,iHigh(sym,InpTF,i-1));
      double l2=MathMin(li,iLow(sym,InpTF,i-1));
      double c2=iClose(sym,InpTF,i-1);
      if(prevBull && h2>=hp && l2<=lp && c2<op){ swingHigh=h2; swingLow=lp; return(true); }
     }
   return(false);
  }

//+------------------------------------------------------------------+
void OnNewBar(string sym,int atrHandle)
  {
   if(HasPosition(sym) || HasPending(sym)) return;
   if(CountTotalPositions() >= InpMaxTotalPositions) return;
   // v1.10: unica riga cambiata nel blocco dei segnali. Il simbolo
   // serve all'esclusione PER VALUTA (InpNewsPerCurrency). Con quel
   // input a false la decisione e' identica a quella della v1.00.
   if(InpUseNewsFilter && InNewsBlackout(sym,TimeCurrent())) return;
   if(!SpreadOK(sym)) return;

   double atr=AtrVal(atrHandle); if(atr<=0) return;

   for(int i=1;i<=InpEngulfLookback;i++)
     {
      double sh,sl;
      if(InpAllowLong && BullEngulf(sym,i,sh,sl))
        { if((sh-sl)<=InpMaxEngulfAtr*atr){ TryPlace(sym,true,sh,sl); return; } }
      if(InpAllowShort && BearEngulf(sym,i,sh,sl))
        { if((sh-sl)<=InpMaxEngulfAtr*atr){ TryPlace(sym,false,sh,sl); return; } }
     }
  }

//+------------------------------------------------------------------+
void TryPlace(string sym,bool isLong,double swingHigh,double swingLow)
  {
   double range=swingHigh-swingLow; if(range<=0) return;
   double pip=PipSize(sym);
   double bid=SymbolInfoDouble(sym,SYMBOL_BID), ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   double px=isLong?ask:bid;

   double ez1 = isLong ? swingHigh-InpEZ1ratio*range : swingLow+InpEZ1ratio*range;
   double ez2 = isLong ? swingHigh-InpEZ2ratio*range : swingLow+InpEZ2ratio*range;
   double target = isLong ? swingHigh : swingLow;
   double sl = isLong ? NormalizePrice(sym,swingHigh-InpSLratio*range-InpSLbufferPips*pip)
                      : NormalizePrice(sym,swingLow +InpSLratio*range+InpSLbufferPips*pip);

   if(MathAbs(px-ez1) < InpMinDistPips*pip) return;   // troppo vicino alla 1a zona

   int nOrders = InpUseEZ2 ? 2 : 1;
   double f1 = nOrders==2 ? InpFirstFraction : 1.0;
   PlaceLimit(sym,isLong,NormalizePrice(sym,ez1),sl,NormalizePrice(sym,target),InpRiskPercent*f1,"EZ1");
   if(InpUseEZ2) PlaceLimit(sym,isLong,NormalizePrice(sym,ez2),sl,NormalizePrice(sym,target),InpRiskPercent*(1.0-f1),"EZ2");
  }

void PlaceLimit(string sym,bool isLong,double px,double sl,double tp,double riskPct,string tag)
  {
   double risk=isLong?(px-sl):(sl-px);
   if(risk<=0) return;
   double lot=LotByRisk(sym,risk,riskPct);
   if(lot<=0){ Log("lotto nullo "+sym+" "+tag); return; }
   datetime exp=TimeCurrent()+InpPendingExpiryBars*PeriodSeconds(InpTF);
   string cm=InpComment+(isLong?" L ":" S ")+tag;
   // v1.10 -- GUARDIAN sul percorso di APERTURA, mai sulle chiusure.
   // Nel tester il canale non esiste: fail-open, numeri invariati.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_FiboH4_Multi")) return;
   gTrade.SetTypeFillingBySymbol(sym);
   bool ok=isLong?gTrade.BuyLimit(lot,px,sym,sl,tp,ORDER_TIME_SPECIFIED,exp,cm)
                 :gTrade.SellLimit(lot,px,sym,sl,tp,ORDER_TIME_SPECIFIED,exp,cm);
   if(ok) Log(StringFormat("%s %s LIMIT %s @ %s SL %s TP %s lot %.2f",sym,isLong?"BUY":"SELL",tag,
           DoubleToString(px,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),
           DoubleToString(sl,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),
           DoubleToString(tp,(int)SymbolInfoInteger(sym,SYMBOL_DIGITS)),lot));
   else Log(sym+" ordine "+tag+" fallito: "+gTrade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
void ManageAll(string sym)
  {
   double bid=SymbolInfoDouble(sym,SYMBOL_BID), ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   int idx=SymIndex(sym); double atr=(idx>=0?AtrVal(gAtr[idx]):0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=sym || PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double sl=PositionGetDouble(POSITION_SL);
      double tp=PositionGetDouble(POSITION_TP);
      double vol=PositionGetDouble(POSITION_VOLUME);
      bool beDone = isLong ? (sl>=openP) : (sl<=openP && sl>0);
      double risk = isLong ? (openP-sl) : (sl-openP);

      if(!beDone && risk>0 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100)
        {
         double tgt=isLong?openP+risk*InpTP1_R:openP-risk*InpTP1_R;
         bool hit=isLong?(bid>=tgt):(ask<=tgt);
         if(hit)
           {
            double cv=NormVol(sym,vol*InpTP1Pct/100.0);
            // 07/08: lo stop in pari NON deve dipendere dalla riuscita del parziale.
            // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non parte, e con
            // lui saltava anche il breakeven. Stessa correzione gia' fatta il 04/08 sugli
            // EMA200, dove era costata -112,78 EUR su due short oro a 0,01 lotti.
            bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            double bePari  = NormalizePrice(sym,openP);
            double slPrec  = PositionGetDouble(POSITION_SL);
            bool   dirLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
            // il breakeven si fa SOLO se migliora lo stop: cosi' non si ripete a ogni tick
            bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                             (!dirLong && (slPrec==0 || bePari<slPrec))));
            if(beFatto) gTrade.PositionModify(tk,bePari,tp);
            if(parzOK || beFatto)
               Log(parzOK ? "1o target: parziale + stop in pari."
                          : "1o target: stop in pari (parziale impossibile al lotto minimo).");
           }
        }
      if(InpUseTrailing && beDone && atr>0)
        {
         double n=isLong?NormalizePrice(sym,bid-atr*InpTrailAtrMult):NormalizePrice(sym,ask+atr*InpTrailAtrMult);
         double slNow=PositionGetDouble(POSITION_SL);
         if(isLong && n>slNow && n<bid) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
         if(!isLong && (n<slNow||slNow==0) && n>ask) gTrade.PositionModify(tk,n,PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
void CutoffCheck(string sym)
  {
   if(!InpUseCutoff) return;
   if(HasPosition(sym)) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.hour*60+now.min < InpCutoffHour*60+InpCutoffMin) return;
   if(HasPending(sym)) CancelPendings(sym);
  }

void FridayCloseCheck(string sym)
  {
   if(!InpFridayClose) return;
   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_week!=5) return;
   if(now.hour*60+now.min < InpFridayCloseHour*60+InpFridayCloseMin) return;
   CancelPendings(sym);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==sym && PositionGetInteger(POSITION_MAGIC)==InpMagic) gTrade.PositionClose(tk);
     }
  }

//==================================================================
//  UTILITY
//==================================================================
int SymIndex(string sym){ for(int i=0;i<gN;i++) if(gSym[i]==sym) return(i); return(-1); }

double LotByRisk(string sym,double slDist,double riskPct)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*riskPct/100.0;
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(sym,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,sym,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(sym,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(string sym,double v)
  {
   double st=SymbolInfoDouble(sym,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(sym,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK(string sym){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(sym,SYMBOL_SPREAD)<=InpMaxSpread); }

bool HasPosition(string sym)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==sym && PositionGetInteger(POSITION_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

int CountTotalPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

bool HasPending(string sym)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==sym && OrderGetInteger(ORDER_MAGIC)==InpMagic) return(true);
     }
   return(false);
  }

void CancelPendings(string sym)
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=sym || OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

//==================================================================
//  FILTRO NOTIZIE  -- v1.10
//  FORMATO ATTESO del CSV, separatore ';' :
//      Data Ora ; Impatto ; Valuta ; Titolo
//      2021.01.07 13:30;High;USD;Nonfarm Payrolls
//  ATTENZIONE: i due CALENDARI in biblioteca hanno le colonne 2 e 3
//  SCAMBIATE (data;PAESE;impatto;evento). Dati cosi' come sono,
//  ImpactToInt legge "United States", torna 0, e con soglia 3 il
//  filtro NON BLOCCA MAI NIENTE: non fallisce, diventa NEUTRO IN
//  SILENZIO. Si convertono prima, con
//  backtest_pipeline\converti_calendario_news.py.
//==================================================================
void LoadNews()
  {
   gNewsCount=0; gNewsScartate=0; gNewsSottoSoglia=0; gNewsSorted=true;
   ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);

   // (a) NEL TESTER OGNI AGENTE HA LA SUA SANDBOX MQL5\Files, e il
   //     file non ci arriva: Common\Files invece e' condiviso (in casa
   //     e' gia' la strada di ExportTrades). Si prova prima Common, poi
   //     la sandbox, e si DICE quale delle due ha risposto.
   int h=INVALID_HANDLE;
   if(InpNewsCommon)
     {
      h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
      if(h!=INVALID_HANDLE) gNewsDove="Common\\Files";
     }
   if(h==INVALID_HANDLE)
     {
      h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
      if(h!=INVALID_HANDLE) gNewsDove="MQL5\\Files (sandbox)";
     }
   if(h==INVALID_HANDLE)
     {
      gNewsDove="(non trovato)";
      Print("[FIBOH4][NEWS] FILTRO ACCESO MA CIECO: '",InpNewsFile,
            "' non trovato ne' in Common\\Files ne' nella sandbox. ",
            "Il filtro NON filtrera' niente e la passata sara' IDENTICA ",
            "alla baseline: NON leggerla come 'il filtro e' neutro'.");
      return;
     }

   datetime ultimo=0;
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0){ gNewsScartate++; continue; }   // intestazione compresa
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      // (d) sotto soglia NON entra in memoria: con 22.503 righe di
      //     calendario la differenza fra tenerle e buttarle e' ore.
      if(imp<InpNewsMinImpact){ gNewsSottoSoglia++; continue; }
      if(t<ultimo) gNewsSorted=false;
      ultimo=t;
      int n=gNewsCount;
      // riserva a blocchi: senza, ArrayResize rialloca a ogni riga.
      ArrayResize(gNewsTime,n+1,4096); ArrayResize(gNewsImpact,n+1,4096); ArrayResize(gNewsCcy,n+1,4096);
      StringTrimLeft(sCcy); StringTrimRight(sCcy); StringToUpper(sCcy);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);

   PrintFormat("[FIBOH4][NEWS] letto da %s | eventi utili %d (impatto >= %d) | "
               "sotto soglia %d | righe scartate %d | ordinato %s | shift %d min | per valuta %s",
               gNewsDove,gNewsCount,InpNewsMinImpact,gNewsSottoSoglia,gNewsScartate,
               (gNewsSorted?"si":"NO (ricerca lineare)"),InpNewsShiftMinutes,
               (InpNewsPerCurrency?"si":"no (blackout globale)"));
   if(gNewsCount>0)
      PrintFormat("[FIBOH4][NEWS] primo evento %s | ultimo evento %s  <-- se la finestra "
                  "del test esce da questo intervallo, li' il filtro e' CIECO.",
                  TimeToString(gNewsTime[0],TIME_DATE|TIME_MINUTES),
                  TimeToString(gNewsTime[gNewsCount-1],TIME_DATE|TIME_MINUTES));

   // (b) IL CANARINO. Un filtro acceso che non ha dati NON e' un
   //     filtro neutro: e' un filtro non eseguito. Va detto forte.
   if(gNewsCount==0)
      Print("[FIBOH4][NEWS] FILTRO ACCESO MA CIECO: ZERO eventi utili. ",
            "Cause tipiche: colonne del calendario scambiate (data;PAESE;impatto), ",
            "oppure soglia InpNewsMinImpact troppo alta. La passata uscira' ",
            "IDENTICA alla baseline e NON e' una misura del filtro.");
   if(gNewsScartate>1)
      PrintFormat("[FIBOH4][NEWS] ATTENZIONE: %d righe non convertite in data. ",gNewsScartate);
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

//--- la valuta della notizia tocca questo simbolo? (base o quotata)
bool NewsToccaSimbolo(string sym,string ccy)
  {
   if(StringLen(ccy)==0) return(true);       // valuta ignota: prudenza, blocca
   string b=SymbolInfoString(sym,SYMBOL_CURRENCY_BASE);
   string p=SymbolInfoString(sym,SYMBOL_CURRENCY_PROFIT);
   StringToUpper(b); StringToUpper(p);
   return(ccy==b || ccy==p);
  }

//--- primo indice con gNewsTime >= t (array ORDINATO). -1 se nessuno.
int NewsLowerBound(datetime t)
  {
   int lo=0, hi=gNewsCount;
   while(lo<hi){ int mid=(lo+hi)/2; if(gNewsTime[mid]<t) lo=mid+1; else hi=mid; }
   return(lo);
  }

bool InNewsBlackout(string sym,datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   gNewsBarreViste++;
   datetime lo=now-InpNewsAfterMin*60;      // evento >= lo  -> now <= evento+After
   datetime hi=now+InpNewsBeforeMin*60;     // evento <= hi  -> now >= evento-Before
   if(gNewsSorted)
     {
      for(int i=NewsLowerBound(lo); i<gNewsCount && gNewsTime[i]<=hi; i++)
        {
         if(InpNewsPerCurrency && !NewsToccaSimbolo(sym,gNewsCcy[i])) continue;
         gNewsBlocchi++;
         return(true);
        }
      return(false);
     }
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsTime[i]<lo || gNewsTime[i]>hi) continue;
      if(InpNewsPerCurrency && !NewsToccaSimbolo(sym,gNewsCcy[i])) continue;
      gNewsBlocchi++;
      return(true);
     }
   return(false);
  }

//==================================================================
//  v1.10, SPENTO DI DEFAULT -- la regola del corso:
//  "prima del rilascio di ogni dato macroeconomico gli ordini vanno
//   TOLTI. Noi non scommettiamo sul mercato." (lez. 18)
//  con la deroga dettata: se il prezzo e' distante >= 100 pip dal
//  livello, si possono lasciare.
//  NB: il filtro dell'ingresso (sopra) impedisce di PIAZZARE; questo
//  toglie quelli GIA' PIAZZATI. Sono due cose diverse e vanno
//  misurate separatamente.
//==================================================================
void NewsCancelCheck(string sym)
  {
   if(!InpUseNewsFilter || !InpNewsCancelPendings) return;
   if(gNewsCount==0) return;
   if(!HasPending(sym)) return;
   if(!InNewsBlackout(sym,TimeCurrent())) return;

   double pip=PipSize(sym);
   double bid=SymbolInfoDouble(sym,SYMBOL_BID);
   double ask=SymbolInfoDouble(sym,SYMBOL_ASK);
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=sym || OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      double px=OrderGetDouble(ORDER_PRICE_OPEN);
      long tp=OrderGetInteger(ORDER_TYPE);
      double rif=(tp==ORDER_TYPE_BUY_LIMIT||tp==ORDER_TYPE_BUY_STOP)?ask:bid;
      double distPips=MathAbs(rif-px)/pip;
      if(InpNewsDerogaPips>0 && distPips>=InpNewsDerogaPips) continue;  // deroga del corso
      if(gTrade.OrderDelete(t)) gNewsPendCancellati++;
     }
  }
//+------------------------------------------------------------------+

//==================================================================
//  v1.10 -- METRICA DI FAMIGLIA: la PEGGIOR GIORNATA in %.
//  E' la misura che una prop guarda per prima (daily loss), e nel
//  report standard di MT5 non c'e'.
//==================================================================
void AggiornaPeggiorGiornata()
  {
   MqlDateTime d; TimeToStruct(TimeCurrent(),d);
   double eq=AccountInfoDouble(ACCOUNT_EQUITY);
   if(d.day_of_year!=gGiornoCorrente)
     { gGiornoCorrente=d.day_of_year; gEqInizioGiorno=eq; return; }
   if(gEqInizioGiorno<=0) { gEqInizioGiorno=eq; return; }
   double pct=(eq-gEqInizioGiorno)/gEqInizioGiorno*100.0;
   if(pct<gWorstDayPct) gWorstDayPct=pct;
  }

//==================================================================
//  v1.10 -- AUTOTEST (puro): niente ordini, niente file, niente
//  GlobalVariable. Si legge ESEGUENDO un test SINGOLO nel tester.
//  F7 compila e basta: da MetaEditor queste righe non escono.
//==================================================================
void AutoTestFiboH4()
  {
   int falliti=0;
   //--- 1. ImpactToInt: i due formati che circolano in casa
   if(ImpactToInt("High")!=3){ falliti++; Print("[FIBOH4][AUTOTEST] FALLITO: ImpactToInt(High)!=3"); }
   if(ImpactToInt("3")!=3)   { falliti++; Print("[FIBOH4][AUTOTEST] FALLITO: ImpactToInt(3)!=3"); }
   if(ImpactToInt("Medium")!=2){ falliti++; Print("[FIBOH4][AUTOTEST] FALLITO: ImpactToInt(Medium)!=2"); }
   //--- 2. il caso che uccide il round: colonne del calendario SCAMBIATE.
   //    "United States" nella colonna dell'impatto deve dare 0, cioe'
   //    sotto qualunque soglia: e' il motivo per cui il file va CONVERTITO.
   if(ImpactToInt("United States")!=0)
     { falliti++; Print("[FIBOH4][AUTOTEST] FALLITO: un paese non deve valere un impatto"); }
   PrintFormat("[FIBOH4][AUTOTEST] magic %d | commento \"%s\" | rischio %.2f%% | simboli \"%s\"",
               (int)InpMagic,InpComment,InpRiskPercent,InpSymbols);
   PrintFormat("[FIBOH4][AUTOTEST] news: uso=%s file=\"%s\" common=%s soglia=%d finestra -%d/+%d min shift=%d perValuta=%s cancellaPendenti=%s deroga=%.0f pip",
               (InpUseNewsFilter?"SI":"no"),InpNewsFile,(InpNewsCommon?"si":"no"),
               InpNewsMinImpact,InpNewsBeforeMin,InpNewsAfterMin,InpNewsShiftMinutes,
               (InpNewsPerCurrency?"si":"no"),(InpNewsCancelPendings?"si":"no"),InpNewsDerogaPips);
   PrintFormat("[FIBOH4][AUTOTEST] cancelli: cutoff=%s %02d:%02d server | venerdi=%s %02d:%02d server",
               (InpUseCutoff?"SI":"no"),InpCutoffHour,InpCutoffMin,
               (InpFridayClose?"SI":"no"),InpFridayCloseHour,InpFridayCloseMin);
   //--- 3. il nucleo del Guardian (18 casi puri, dall'include)
   int fg=ABTG_AutotestGuardia();
   if(fg>0){ falliti+=fg; PrintFormat("[FIBOH4][AUTOTEST] Guardian: %d casi falliti -- NON mettere in campo.",fg); }
   //--- 4. il promemoria che non deve sparire dal giornale
   Print("[FIBOH4][AUTOTEST] PROMEMORIA: questo EA e' MULTI-SIMBOLO. ",
         "Opera su InpSymbols, NON sul simbolo del grafico. Un round che ",
         "non pinna InpSymbols misura sempre lo stesso basket (difetto ",
         "trovato il 21/08 nello scan del 16/08).");
   PrintFormat("[FIBOH4][AUTOTEST] %d casi falliti in tutto.",falliti);
  }

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

//--- per-trade: serve al DD di PORTAFOGLIO (ROTTA_PROP punto 4).
//    Con un basket la colonna 'symbol' non e' decorativa: dice su quale
//    cross e' finito ogni deal anche quando il grafico e' un altro.
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","comment");
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
                DoubleToString(net,2),
                HistoryDealGetString(tk,DEAL_COMMENT));
     }
   FileClose(h);
  }

//==================================================================
//  IL CONTATORE DEL FILTRO NOTIZIE (solo Print a fine passata).
//  E' IL CANARINO DI R93, e va letto PRIMA di qualunque profitto:
//  dice se il filtro ha FILTRATO oppure se e' stato solo acceso.
//  Atteso, calcolato PRIMA sul calendario 2021-2025 convertito
//  (converti_calendario_news.py, impatto High, finestra -60/+30):
//  fra l'8% e il 12% delle aperture di barra H4 bloccate.
//  bloccate = 0  ->  il filtro NON HA GIRATO. La passata non e' una
//                    misura del filtro: e' la baseline con un'etichetta
//                    diversa. Si butta e si cerca il file.
//  bloccate = 100% -> il file e' letto male (colonne scambiate al
//                    contrario, shift assurdo). Si butta lo stesso.
//==================================================================
void PrintContaNews()
  {
   if(!InpUseNewsFilter)
     { Print("[FIBOH4][NEWS] filtro SPENTO in questa passata (baseline)."); return; }
   double pct = (gNewsBarreViste>0) ? 100.0*(double)gNewsBlocchi/(double)gNewsBarreViste : 0.0;
   PrintFormat("[FIBOH4][NEWS-CONTA] eventi in memoria=%d | interrogazioni=%I64d | "
               "bloccate=%I64d (%.2f%%) | pendenti cancellati=%I64d | letto da %s",
               gNewsCount,gNewsBarreViste,gNewsBlocchi,pct,gNewsPendCancellati,gNewsDove);
   if(gNewsBlocchi==0)
      Print("[FIBOH4][NEWS-CONTA] CANARINO ROSSO: il filtro e' ACCESO e non ha ",
            "bloccato NIENTE. Atteso 8-12%. Questa passata NON misura il filtro.");
   if(pct>50.0)
      Print("[FIBOH4][NEWS-CONTA] CANARINO ROSSO: bloccato piu' del 50% delle ",
            "interrogazioni. Atteso 8-12%. File letto male o shift sbagliato.");
  }

double OnTester()
  {
   PrintContaNews();
   ExportTrades();
   //--- 21/08 (difetto 34 della checklist): i CANARINI viaggiano coi DATI.
   //    In OTTIMIZZAZIONE MT5 non fa vedere le Print degli AGENT: finiscono
   //    nei log per-agente, che nessuno raccoglie e che nello zip non ci
   //    sono. E walkforward_generico.ps1 scrive SEMPRE Optimization=1, cioe'
   //    TUTTE le 68 passate di R93 girano cosi'. Il canarino non trattabile
   //    del round ("cella news ON con bloccate=0 si BUTTA") sarebbe stato
   //    illeggibile. FrameAdd attraversa il confine agente -> terminale e
   //    OnTesterDeinit, che gira SUL TERMINALE, lo scrive come COLONNA.
   //    Le Print restano dove sono: servono nel test singolo a mano.
   double stats[13];
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
   //--- e le tre che rendono LEGGIBILE il canarino del filtro news anche
   //    quando la passata gira su un agente muto.
   stats[10] = (double)gNewsBlocchi;      // News Bloccate       (0 = filtro NON eseguito)
   stats[11] = (double)gNewsBarreViste;   // News Interrogazioni (il denominatore)
   stats[12] = (double)gNewsCount;        // News Eventi         (0 = file assente o letto male)
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
         //--- HEADER E RIGA SI TOCCANO INSIEME, o le colonne scalano di posto.
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,News Bloccate,News Interrogazioni,News Eventi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- la guardia su ArraySize non e' cosmetica: -1 dice "questa passata
      //    NON ha prodotto il canarino" ed e' diverso da 0, che dice "il
      //    filtro ha girato e non ha bloccato niente". Con 0 le due cose si
      //    confonderebbero, ed e' esattamente la confusione che il canarino
      //    doveva togliere.
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                (ArraySize(data)>7?data[7]:0.0), (ArraySize(data)>8?data[8]:0.0), (ArraySize(data)>9?data[9]:0.0),
                                (ArraySize(data)>10?data[10]:-1.0), (ArraySize(data)>11?data[11]:-1.0), (ArraySize(data)>12?data[12]:-1.0));
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
