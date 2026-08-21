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
//  3. 🔴 DIFETTO DI BANCO TROVATO IL 21/08/2026, e riguarda proprio
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
//         notizie reso USABILE NEL TESTER. Il blocco dei segnali
//         (BullEngulf, BearEngulf, TryPlace, PlaceLimit) e' rimasto
//         IDENTICO CARATTERE PER CARATTERE: verificato a macchina con
//         diff normalizzato = 0 righe. In OnNewBar cambia UNA riga
//         sola, la chiamata al filtro notizie, che ora riceve il
//         simbolo (serviva per l'esclusione per valuta).
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

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin  = 60;
input int    InpNewsAfterMin   = 30;
input int    InpNewsShiftMinutes = 0;

input group "=== Generali ==="
input string InpComment   = "FIBOH4";
input long   InpMagic     = 771602;
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;

//==================================================================
//  STATO (per-simbolo)
//==================================================================
string   gSym[];
int      gAtr[];
datetime gLastBar[];
int      gN=0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

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
   Log(StringFormat("avviato su %d simboli, %s. EZ %.2f/%.2f, SL %.3f.",gN,EnumToString(InpTF),InpEZ1ratio,InpEZ2ratio,InpSLratio));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   for(int i=0;i<gN;i++) if(gAtr[i]!=INVALID_HANDLE) IndicatorRelease(gAtr[i]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   for(int i=0;i<gN;i++)
     {
      string sym=gSym[i];
      ManageAll(sym);
      CutoffCheck(sym);
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
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return;
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
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
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
