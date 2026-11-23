//+------------------------------------------------------------------+
//|     BREAKING BAND - BACKTEST ALL FOREX CROSSES v2.0              |
//|     Guida Operativa v.11                                         |
//|                                                                  |
//|  ISTRUZIONI BACKTEST:                                            |
//|  1. Attacca su EURUSD H1 (o H4 per più segnali)                 |
//|  2. Strategy Tester → "Open prices only" (veloce)               |
//|     oppure "Every tick" per massima precisione                   |
//|  3. Parametri DEFAULT — NON ottimizzare                          |
//|  4. Aggiungi tutti i 28 pair al Market Watch prima di avviare   |
//|  5. Al termine leggi il RANKING nel tab "Experts" del Tester    |
//|                                                                  |
//|  COPPIE TESTATE (28 total — no indici, no crypto, no materie    |
//|  prime):                                                         |
//|  7 Majors  : EURUSD GBPUSD USDJPY USDCHF USDCAD AUDUSD NZDUSD  |
//|  6 EUR     : EURGBP EURJPY EURCHF EURCAD EURAUD EURNZD          |
//|  5 GBP     : GBPJPY GBPCHF GBPCAD GBPAUD GBPNZD                 |
//|  4 JPY     : CADJPY AUDJPY NZDJPY CHFJPY                        |
//|  3 AUD     : AUDCAD AUDCHF AUDNZD                               |
//|  3 Altro   : NZDCAD NZDCHF CADCHF                               |
//|                                                                  |
//|  OUTPUT FINALE (tab Experts):                                    |
//|  - Ranking per WIN RATE decrescente                              |
//|  - Ranking per VOLATILITA' (ATR medio) crescente                 |
//|  - Top 5 pair consigliati per strategia BB                      |
//+------------------------------------------------------------------+
#property copyright   "Breaking Band Backtest EA v2.3"
#property version     "2.30"
#property description "All Forex Crosses v2.3 - Pair Selezionati + SL Configurabile"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>

//============================================================
//  INPUT
//============================================================
input group "=== MAJORS (attivi: AUDUSD USDCHF USDCAD) ==="
input bool P_EURUSD = false; // EURUSD
input bool P_GBPUSD = false; // GBPUSD
input bool P_USDJPY = false; // USDJPY
input bool P_USDCHF = true;  // USDCHF  [v2.3 ON]
input bool P_USDCAD = true;  // USDCAD  [v2.3 ON]
input bool P_AUDUSD = true;  // AUDUSD  [v2.3 ON] campione assoluto
input bool P_NZDUSD = false; // NZDUSD

input group "=== EUR CROSS (attivi: EURGBP EURJPY EURNZD EURCHF) ==="
input bool P_EURGBP = true;  // EURGBP  [v2.3 ON]
input bool P_EURJPY = true;  // EURJPY  [v2.3 ON]
input bool P_EURCHF = true;  // EURCHF  [v2.3 ON]
input bool P_EURCAD = false; // EURCAD
input bool P_EURAUD = false; // EURAUD
input bool P_EURNZD = true;  // EURNZD  [v2.3 ON]

input group "=== GBP CROSS (attivo: GBPJPY) ==="
input bool P_GBPJPY = true;  // GBPJPY  [v2.3 ON]
input bool P_GBPCHF = false; // GBPCHF
input bool P_GBPCAD = false; // GBPCAD
input bool P_GBPAUD = false; // GBPAUD
input bool P_GBPNZD = false; // GBPNZD

input group "=== JPY CROSS (attivi: AUDJPY NZDJPY) ==="
input bool P_CADJPY = false; // CADJPY
input bool P_AUDJPY = true;  // AUDJPY  [v2.3 ON]
input bool P_NZDJPY = true;  // NZDJPY  [v2.3 ON]
input bool P_CHFJPY = false; // CHFJPY

input group "=== AUD CROSS (attivi: AUDCAD AUDNZD) ==="
input bool P_AUDCAD = true;  // AUDCAD  [v2.3 ON]
input bool P_AUDCHF = false; // AUDCHF
input bool P_AUDNZD = true;  // AUDNZD  [v2.3 ON]

input group "=== ALTRI CROSS (attivi: NZDCAD NZDCHF) ==="
input bool P_NZDCAD = true;  // NZDCAD  [v2.3 ON]
input bool P_NZDCHF = true;  // NZDCHF  [v2.3 ON]
input bool P_CADCHF = false; // CADCHF

input group "=== BOLLINGER BANDS (Guida v.11 — non modificare) ==="
input int    InpBBPeriod    = 20;
input double InpBBDev       = 2.0;

input group "=== INDICATORI ==="
input int    InpATRPer      = 14;
input int    InpStdDevPer   = 20;
input int    InpStdDevSMA   = 50;

input group "=== RISK MANAGEMENT ==="
input double InpRiskPct     = 1.0;   // Rischio per operazione (%)
input double InpSLMult      = 2.0;   // Moltiplicatore SL (strategia=3.0, test=2.0)
input int    InpMaxTrades   = 5;     // Max operazioni contemporanee (tutti i pair)
input bool   InpBreakEven   = true;
input double InpBEAtrMult   = 0.5;   // v2.3: BE più aggressivo (era 1.0)

input group "=== RILEVAMENTO PATTERN ==="
input double InpBulgeATRMin = 1.1;   // v2.2: 1.3->1.1 — accetta impulsi moderati
input int    InpMaxBulgeBar = 20;
input double InpBandExpFact = 0.85;  // v2.2: 1.0->0.85 — bulge rilevato in fase iniziale
input double InpRetATRMax   = 1.5;
input double InpRetATRMaxInv= 1.0;
input int    InpMaxRetBars  = 40;
input int    InpMinCongBars = 8;     // v2.1: 10->8 — congestione minima piu corta

input group "=== TP TRAILING ==="
input bool   InpTPTrail     = true;
input int    InpTPBars      = 2;

input group "=== RANKING ==="
input double InpMinWinRate  = 55.0;  // Win rate minimo per consiglio (%)
input double InpMaxATRPips  = 80.0;  // ATR massimo medio (pips) per "bassa volatilità"
input int    InpMinTrades   = 3;     // Trades minimi per considerare il pair valido

input group "=== GENERALE ==="
input long   InpMagic       = 20250001;
input bool   InpDebug       = false;
input bool   InpLogTrades   = true;

//============================================================
//  STRUTTURE
//============================================================
#define MAX_SYMBOLS  28

enum SYM_STATE {
   SS_SCAN, SS_CONG, SS_BULGE,
   SS_CONT_WAIT, SS_INV_MEDIAN, SS_INV_RETEST,
   SS_ORDER_ACTIVE
};

struct BulgeData {
   bool   valid;
   int    dir;
   double peakWidth;
   double impBand;
   double oppBand;
   double median;
   double atrVal;
};

struct CongData {
   bool   valid;
   int    type;
   double avgWidth;
};

// Stats per ranking
struct SymStats {
   int    wins;
   int    losses;
   double totalProfit;
   double totalLoss;
   double sumATR;       // Somma ATR al momento dell'entry (per media)
   int    atrCount;
   int    maxLossStreak;
   int    curLossStreak;
   double maxSingleLoss;
   double maxSingleWin;
};

struct SymbolState {
   string    name;
   bool      enabled;
   int       hBB;
   int       hATR;
   int       hStdDev;
   SYM_STATE state;
   int       stateCount;
   BulgeData bulge;
   CongData  cong;
   bool      medianTested;
   ulong     pendTicket;
   datetime  lastBar;
   int       totalSignals;
   int       totalOrders;
   SymStats  stats;
};

//============================================================
//  VARIABILI GLOBALI
//============================================================
SymbolState  sym[MAX_SYMBOLS];
int          symCount = 0;

CTrade        trade;
CPositionInfo posInfo;
COrderInfo    ordInfo;

//============================================================
//  OnInit — registra tutti i 28 pair per gruppo
//============================================================
int OnInit() {
   Print("=========================================================");
   Print("BREAKING BAND v2.0 — ALL FOREX CROSSES + RANKING");
   Print("Magic:", InpMagic, " | Rischio:", InpRiskPct, "% | BandExp:", InpBandExpFact);
   Print("=========================================================");

   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints(20);
   trade.SetTypeFilling(ORDER_FILLING_IOC);

   // Lista completa 28 pair con flag gruppo
   string allNames[MAX_SYMBOLS] = {
      // Majors (7)
      "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
      // EUR cross (6)
      "EURGBP","EURJPY","EURCHF","EURCAD","EURAUD","EURNZD",
      // GBP cross (5)
      "GBPJPY","GBPCHF","GBPCAD","GBPAUD","GBPNZD",
      // JPY cross (4)
      "CADJPY","AUDJPY","NZDJPY","CHFJPY",
      // AUD cross (3)
      "AUDCAD","AUDCHF","AUDNZD",
      // Altri (3)
      "NZDCAD","NZDCHF","CADCHF"
   };
   bool allFlags[MAX_SYMBOLS] = {
      P_EURUSD, P_GBPUSD, P_USDJPY, P_USDCHF, P_USDCAD, P_AUDUSD, P_NZDUSD,
      P_EURGBP, P_EURJPY, P_EURCHF, P_EURCAD, P_EURAUD, P_EURNZD,
      P_GBPJPY, P_GBPCHF, P_GBPCAD, P_GBPAUD, P_GBPNZD,
      P_CADJPY, P_AUDJPY, P_NZDJPY, P_CHFJPY,
      P_AUDCAD, P_AUDCHF, P_AUDNZD,
      P_NZDCAD, P_NZDCHF, P_CADCHF
   };

   symCount = 0;
   for(int i = 0; i < MAX_SYMBOLS; i++) {
      if(!allFlags[i]) continue;
      if(!SymbolSelect(allNames[i], true)) {
         Print("AVVISO: ", allNames[i], " non disponibile sul broker — saltato");
         continue;
      }
      // Verifica che il simbolo abbia dati
      if(SymbolInfoInteger(allNames[i], SYMBOL_SPREAD) == 0) {
         if(InpDebug) Print("AVVISO: ", allNames[i], " spread=0 — possibile no data");
      }

      ZeroMemory(sym[symCount]);
      sym[symCount].name    = allNames[i];
      sym[symCount].enabled = true;
      sym[symCount].state   = SS_SCAN;
      sym[symCount].hBB     = iBands  (allNames[i], PERIOD_CURRENT, InpBBPeriod, 0, InpBBDev, PRICE_CLOSE);
      sym[symCount].hATR    = iATR    (allNames[i], PERIOD_CURRENT, InpATRPer);
      sym[symCount].hStdDev = iStdDev (allNames[i], PERIOD_CURRENT, InpStdDevPer, 0, MODE_SMA, PRICE_CLOSE);

      if(sym[symCount].hBB    == INVALID_HANDLE ||
         sym[symCount].hATR   == INVALID_HANDLE ||
         sym[symCount].hStdDev== INVALID_HANDLE) {
         Print("ERRORE handle: ", allNames[i], " — saltato");
         continue;
      }
      symCount++;
   }

   if(symCount == 0) {
      Alert("Nessun simbolo disponibile! Aggiungi i pair al Market Watch.");
      return INIT_FAILED;
   }

   Print("Pair attivi: ", symCount, " / ", MAX_SYMBOLS);
   Print("=========================================================");
   return INIT_SUCCEEDED;
}

//============================================================
//  OnDeinit — STAMPA RANKING COMPLETO
//============================================================
void OnDeinit(const int reason) {
   // Raccoglie stats dalla history deals
   CollectHistoryStats();

   Print("");
   Print("=========================================================");
   Print("   RANKING FINALE — BREAKING BAND ALL CROSSES");
   Print("   Periodo: ", TimeToString(iTime(_Symbol,PERIOD_CURRENT,0)));
   Print("=========================================================");

   // Rilascia handle
   for(int i = 0; i < symCount; i++) {
      IndicatorRelease(sym[i].hBB);
      IndicatorRelease(sym[i].hATR);
      IndicatorRelease(sym[i].hStdDev);
   }

   // Stampa ranking per WIN RATE
   PrintRankingByWinRate();
   // Stampa ranking per VOLATILITÀ
   PrintRankingByVolatility();
   // Top 5 consigliati
   PrintTopRecommended();

   Comment("");
}

//============================================================
//  RACCOGLIE STATS DALLA HISTORY (OnDeinit)
//============================================================
void CollectHistoryStats() {
   if(!HistorySelect(0, TimeCurrent())) return;
   int total = HistoryDealsTotal();

   for(int d = 0; d < total; d++) {
      ulong ticket = HistoryDealGetTicket(d);
      if(ticket == 0) continue;
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != InpMagic) continue;
      if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;

      string dSym  = HistoryDealGetString(ticket, DEAL_SYMBOL);
      double profit= HistoryDealGetDouble(ticket, DEAL_PROFIT)
                   + HistoryDealGetDouble(ticket, DEAL_SWAP)
                   + HistoryDealGetDouble(ticket, DEAL_COMMISSION);

      // Trova indice simbolo
      int idx = -1;
      for(int j = 0; j < symCount; j++) {
         if(sym[j].name == dSym) { idx = j; break; }
      }
      if(idx < 0) continue;

      if(profit > 0) {
         sym[idx].stats.wins++;
         sym[idx].stats.totalProfit += profit;
         if(profit > sym[idx].stats.maxSingleWin) sym[idx].stats.maxSingleWin = profit;
         sym[idx].stats.curLossStreak = 0;
      } else {
         sym[idx].stats.losses++;
         sym[idx].stats.totalLoss += profit; // negativo
         if(profit < sym[idx].stats.maxSingleLoss) sym[idx].stats.maxSingleLoss = profit;
         sym[idx].stats.curLossStreak++;
         if(sym[idx].stats.curLossStreak > sym[idx].stats.maxLossStreak)
            sym[idx].stats.maxLossStreak = sym[idx].stats.curLossStreak;
      }
   }

   // Calcola ATR medio per ogni simbolo (ultime 100 barre)
   for(int i = 0; i < symCount; i++) {
      double atrBuf[100];
      int copied = CopyBuffer(sym[i].hATR, 0, 1, 100, atrBuf);
      if(copied > 0) {
         double sum = 0;
         // Converti ATR in pips
         double pipFactor = (StringFind(sym[i].name,"JPY") >= 0) ? 100.0 : 10000.0;
         for(int k = 0; k < copied; k++) sum += atrBuf[k] * pipFactor;
         sym[i].stats.sumATR   = sum / copied; // ATR medio in pips
         sym[i].stats.atrCount = copied;
      }
   }
}

//============================================================
//  RANKING PER WIN RATE
//============================================================
void PrintRankingByWinRate() {
   Print("");
   Print("--- RANKING WIN RATE (decrescente) ---");
   PrintFormat("%-10s %6s %5s %5s %8s %8s %8s %6s",
               "PAIR","TRADES","WIN%","PF","AVG WIN","AVG LOSS","NET P/L","STREAK");

   // Bubble sort per win rate
   int order[MAX_SYMBOLS];
   for(int i=0; i<symCount; i++) order[i]=i;

   for(int i=0; i<symCount-1; i++) {
      for(int j=0; j<symCount-i-1; j++) {
         int a = order[j], b = order[j+1];
         int tA = sym[a].stats.wins + sym[a].stats.losses;
         int tB = sym[b].stats.wins + sym[b].stats.losses;
         double wrA = (tA > 0) ? 100.0*sym[a].stats.wins/tA : 0;
         double wrB = (tB > 0) ? 100.0*sym[b].stats.wins/tB : 0;
         if(wrA < wrB) { int tmp=order[j]; order[j]=order[j+1]; order[j+1]=tmp; }
      }
   }

   for(int r=0; r<symCount; r++) {
      int i = order[r];
      int tot = sym[i].stats.wins + sym[i].stats.losses;
      if(tot == 0) continue;
      double wr  = 100.0 * sym[i].stats.wins / tot;
      double avgW = (sym[i].stats.wins>0) ? sym[i].stats.totalProfit/sym[i].stats.wins : 0;
      double avgL = (sym[i].stats.losses>0) ? sym[i].stats.totalLoss/sym[i].stats.losses : 0;
      double netPL= sym[i].stats.totalProfit + sym[i].stats.totalLoss;
      double pf   = (sym[i].stats.totalLoss != 0) ? MathAbs(sym[i].stats.totalProfit/sym[i].stats.totalLoss) : 0;

      string star = (wr >= InpMinWinRate && tot >= InpMinTrades) ? " <<" : "";
      PrintFormat("%-10s %6d %5.1f %5.2f %8.2f %8.2f %8.2f %6d%s",
                  sym[i].name, tot, wr, pf, avgW, avgL, netPL,
                  sym[i].stats.maxLossStreak, star);
   }
}

//============================================================
//  RANKING PER VOLATILITÀ
//============================================================
void PrintRankingByVolatility() {
   Print("");
   Print("--- RANKING VOLATILITA' ATR medio (pip) — crescente = meno volatile ---");
   PrintFormat("%-10s %10s %10s %8s %8s",
               "PAIR","ATR_MEDIO","ATR_LABEL","TRADES","WIN%");

   // Sort per ATR crescente
   int order[MAX_SYMBOLS];
   for(int i=0; i<symCount; i++) order[i]=i;

   for(int i=0; i<symCount-1; i++) {
      for(int j=0; j<symCount-i-1; j++) {
         int a=order[j], b=order[j+1];
         if(sym[a].stats.sumATR > sym[b].stats.sumATR) {
            int tmp=order[j]; order[j]=order[j+1]; order[j+1]=tmp;
         }
      }
   }

   for(int r=0; r<symCount; r++) {
      int i = order[r];
      double atr = sym[i].stats.sumATR;
      int tot = sym[i].stats.wins + sym[i].stats.losses;
      double wr = (tot>0) ? 100.0*sym[i].stats.wins/tot : 0;

      string label;
      if(atr <= 20)       label = "BASSA";
      else if(atr <= 50)  label = "MEDIA";
      else if(atr <= 100) label = "ALTA";
      else                label = "MOLTO ALTA";

      string star = (atr <= InpMaxATRPips && tot >= InpMinTrades) ? " <<" : "";
      PrintFormat("%-10s %10.1f %10s %8d %8.1f%s",
                  sym[i].name, atr, label, tot, wr, star);
   }
}

//============================================================
//  TOP 5 PAIR CONSIGLIATI
//  Criteri: win rate >= InpMinWinRate E ATR <= InpMaxATRPips
//           E almeno InpMinTrades trade eseguiti
//============================================================
void PrintTopRecommended() {
   Print("");
   Print("=========================================================");
   Print("   TOP PAIR CONSIGLIATI PER STRATEGIA BB");
   Print("   Criteri: WinRate>=", InpMinWinRate, "% AND ATR<=",
         InpMaxATRPips, " pips AND Trades>=", InpMinTrades);
   Print("=========================================================");

   // Score composito: WR (peso 60%) + (1 - ATR_norm) (peso 40%)
   // ATR normalizzato su 0-200 pips
   double maxATR = 200.0;
   bool   anyFound = false;

   // Crea array score
   double scores[MAX_SYMBOLS];
   for(int i=0; i<symCount; i++) {
      int tot = sym[i].stats.wins + sym[i].stats.losses;
      double wr  = (tot>0) ? 100.0*sym[i].stats.wins/tot : 0;
      double atr = sym[i].stats.sumATR;
      double atrNorm = MathMin(atr / maxATR, 1.0);
      scores[i] = (wr/100.0)*0.60 + (1.0-atrNorm)*0.40;
      // Penalizza se troppo pochi trade
      if(tot < InpMinTrades) scores[i] = 0;
   }

   // Sort per score decrescente
   int order[MAX_SYMBOLS];
   for(int i=0; i<symCount; i++) order[i]=i;
   for(int i=0; i<symCount-1; i++) {
      for(int j=0; j<symCount-i-1; j++) {
         if(scores[order[j]] < scores[order[j+1]]) {
            int tmp=order[j]; order[j]=order[j+1]; order[j+1]=tmp;
         }
      }
   }

   int rank = 1;
   PrintFormat("%-4s %-10s %8s %10s %8s %8s %10s",
               "RANK","PAIR","TRADES","WIN%","ATR pips","NET P/L","SCORE");

   for(int r=0; r<symCount && rank<=10; r++) {
      int i = order[r];
      if(scores[i] <= 0) continue;
      int tot = sym[i].stats.wins + sym[i].stats.losses;
      if(tot < InpMinTrades) continue;

      double wr  = 100.0*sym[i].stats.wins/tot;
      double net = sym[i].stats.totalProfit + sym[i].stats.totalLoss;
      double atr = sym[i].stats.sumATR;

      // Giudizio
      string verdict = "";
      if(wr >= InpMinWinRate && atr <= InpMaxATRPips) verdict = "*** OTTIMO ***";
      else if(wr >= InpMinWinRate)                   verdict = "** WIN RATE OK";
      else if(atr <= InpMaxATRPips)                  verdict = "* BASSA VOLATILITA'";

      PrintFormat("#%-3d %-10s %8d %9.1f%% %8.1f %8.2f %10.3f  %s",
                  rank, sym[i].name, tot, wr, atr, net, scores[i], verdict);
      anyFound = true;
      rank++;
   }

   if(!anyFound) {
      Print("Nessun pair soddisfa i criteri minimi.");
      Print("Suggerimento: abbassa InpMinWinRate o riduci InpMinTrades.");
   }

   Print("=========================================================");
   Print("LEGENDA:");
   Print("  WinRate = trades chiusi in profitto / trades totali");
   Print("  ATR pips = volatilita' media recente (pips/candela)");
   Print("  Score = punteggio composito WR(60%) + BassaVolat(40%)");
   Print("  *** OTTIMO = soddisfa entrambi i criteri principali");
   Print("  Per selezione definitiva usare pair con score > 0.6");
   Print("=========================================================");
}

//============================================================
//  OnTick
//============================================================
void OnTick() {
   if(InpBreakEven) ManageBreakEven();
   if(InpTPTrail)   UpdateAllTP();

   for(int i = 0; i < symCount; i++) {
      if(!sym[i].enabled) continue;
      datetime curBar = iTime(sym[i].name, PERIOD_CURRENT, 0);
      if(curBar == sym[i].lastBar) continue;
      sym[i].lastBar = curBar;

      if(sym[i].state == SS_ORDER_ACTIVE) {
         CheckSymbolOrder(sym[i]);
         continue;
      }
      if(CountMyTrades() >= InpMaxTrades) continue;

      RunStateMachine(sym[i]);
      sym[i].stateCount++;
   }
   DrawComment();
}

//============================================================
//  STATE MACHINE
//============================================================
void RunStateMachine(SymbolState &s) {
   switch(s.state) {
      case SS_SCAN:       DoScan(s);    break;
      case SS_CONG:       DoCong(s);    break;
      case SS_BULGE:      DoBulge(s);   break;
      case SS_CONT_WAIT:  DoCont(s);    break;
      case SS_INV_MEDIAN: DoInvMed(s);  break;
      case SS_INV_RETEST: DoInvRet(s);  break;
      default: ResetSym(s); break;
   }
}

//============================================================
//  LETTURA INDICATORI
//============================================================
double GetBBU(SymbolState &s,int sh=1){double b[1];CopyBuffer(s.hBB,1,sh,1,b);return b[0];}
double GetBBL(SymbolState &s,int sh=1){double b[1];CopyBuffer(s.hBB,2,sh,1,b);return b[0];}
double GetBBM(SymbolState &s,int sh=1){double b[1];CopyBuffer(s.hBB,0,sh,1,b);return b[0];}
double GetATR(SymbolState &s,int sh=1){double b[1];CopyBuffer(s.hATR,0,sh,1,b);return b[0];}
double GetSD (SymbolState &s,int sh=1){double b[1];CopyBuffer(s.hStdDev,0,sh,1,b);return b[0];}
double GetBW (SymbolState &s,int sh=1){return GetBBU(s,sh)-GetBBL(s,sh);}

double GetSdSMA50(SymbolState &s) {
   double v[50];
   if(CopyBuffer(s.hStdDev,0,1,50,v)<50) return 0;
   double sum=0; for(int i=0;i<50;i++) sum+=v[i]; return sum/50.0;
}
double AvgBW(SymbolState &s,int from,int cnt) {
   double sum=0; for(int i=from;i<from+cnt;i++) sum+=GetBW(s,i);
   return(cnt>0)?sum/cnt:0;
}
double CndRange(string s_,int sh){return iHigh(s_,PERIOD_CURRENT,sh)-iLow(s_,PERIOD_CURRENT,sh);}
double CndBody (string s_,int sh){return MathAbs(iClose(s_,PERIOD_CURRENT,sh)-iOpen(s_,PERIOD_CURRENT,sh));}
bool   IsImpulsive(string s_,int sh,double m,SymbolState &s){return CndRange(s_,sh)>GetATR(s,sh)*m;}
bool   IsDirectional(string s_,int sh){double r=CndRange(s_,sh);return(r>0)&&(CndBody(s_,sh)/r>=0.45);}
bool   IsBullish(string s_,int sh){return iClose(s_,PERIOD_CURRENT,sh)>=iOpen(s_,PERIOD_CURRENT,sh);}

//============================================================
//  CONGESTIONE
//============================================================
bool DetectCong(SymbolState &s) {
   double atr=GetATR(s,1),sd=GetSD(s,1),sdSMA=GetSdSMA50(s);
   if(sdSMA==0||atr==0) return false;
   double aw10=AvgBW(s,1,10),aw20=AvgBW(s,11,10);
   int cs=0;
   if(aw10<aw20*0.95) cs++;
   double avgR=0; for(int i=1;i<=10;i++) avgR+=CndRange(s.name,i); avgR/=10.0;
   if(avgR<atr*0.9) cs++;
   double hi=iHigh(s.name,PERIOD_CURRENT,iHighest(s.name,PERIOD_CURRENT,MODE_HIGH,10,1));
   double lo=iLow (s.name,PERIOD_CURRENT,iLowest (s.name,PERIOD_CURRENT,MODE_LOW, 10,1));
   if((hi-lo)<atr*4.0) cs++; // v2.2: 3.0->4.0 ATR
   bool noI=true; for(int i=1;i<=10;i++){if(IsImpulsive(s.name,i,1.5,s)){noI=false;break;}} if(noI) cs++;
   if(sd<sdSMA*1.0) cs++; // v2.2: 0.95->1.0 (basta che sia sotto SMA50)
   if(cs>=3){s.cong.valid=true;s.cong.type=1;s.cong.avgWidth=aw10;return true;} // v2.2: 4->3

   int lk=MathMax(InpMinCongBars,15);
   bool sdDecl=true; double sdP=GetSD(s,lk);
   for(int i=lk-1;i>=1;i--){if(GetSD(s,i)>sdP*1.10){sdDecl=false;break;}sdP=GetSD(s,i);}
   bool sdBelSMA=(sd<sdSMA);
   bool bNarrow=(aw10<AvgBW(s,11,10)*0.85);
   bool noI2=true; for(int i=1;i<=lk;i++){if(IsImpulsive(s.name,i,1.5,s)){noI2=false;break;}}
   double hi2=iHigh(s.name,PERIOD_CURRENT,iHighest(s.name,PERIOD_CURRENT,MODE_HIGH,lk,1));
   double lo2=iLow (s.name,PERIOD_CURRENT,iLowest (s.name,PERIOD_CURRENT,MODE_LOW, lk,1));
   bool ordered=((hi2-lo2)<atr*5.0);
   // v2.2: CDA valida con 4/5 criteri (era tutti e 5)
   int cdaScore=(sdDecl?1:0)+(sdBelSMA?1:0)+(bNarrow?1:0)+(noI2?1:0)+(ordered?1:0);
   if(cdaScore>=4){s.cong.valid=true;s.cong.type=2;s.cong.avgWidth=aw10;return true;}
   return false;
}

//============================================================
//  BULGE
//============================================================
bool DetectBulge(SymbolState &s,int &dir) {
   double atr=GetATR(s,1),sd=GetSD(s,1),sdSMA=GetSdSMA50(s);
   double bw=GetBW(s,1),congW=s.cong.valid?s.cong.avgWidth:AvgBW(s,20,20);
   if(atr==0||sdSMA==0||congW==0) return false;
   bool bOpen=(bw>congW*InpBandExpFact);
   bool sdHi=(sd>sdSMA*0.90); // v2.2: cattura bulge in fase iniziale
   int impCnt=0;
   for(int i=1;i<=5;i++){if(IsImpulsive(s.name,i,InpBulgeATRMin,s)&&IsDirectional(s.name,i))impCnt++;}
   bool hasImp=(impCnt>=1);
   double med=GetBBM(s,1),cl1=iClose(s.name,PERIOD_CURRENT,1);
   bool away=(MathAbs(cl1-med)>atr*0.7); // v2.2: 1.0->0.7 ATR
   int up=0,dn=0;
   for(int i=1;i<=10;i++){if(IsBullish(s.name,i))up++;else dn++;}
   bool uni=((double)MathMax(up,dn)/10.0>=0.55); // v2.2: 60%->55%
   dir=(cl1>=med)?1:-1;
   int ride=0;
   for(int i=1;i<=20;i++){
      if(dir==1  &&iHigh(s.name,PERIOD_CURRENT,i)>=GetBBU(s,i))ride++;
      if(dir==-1 &&iLow (s.name,PERIOD_CURRENT,i)<=GetBBL(s,i))ride++;
   }
   bool noRide=(ride<=18); // v2.2: 15->18 barre
   return(bOpen&&sdHi&&hasImp&&away&&uni&&noRide);
}

//============================================================
//  STATI
//============================================================
void DoScan(SymbolState &s) {
   if(DetectCong(s)){s.state=SS_CONG;s.stateCount=0;}
}
void DoCong(SymbolState &s) {
   if(s.stateCount>35){ResetSym(s);return;} // v2.2: timeout 50->35
   int dir=0;
   if(DetectBulge(s,dir)){
      s.bulge.valid=true;s.bulge.dir=dir;s.bulge.peakWidth=GetBW(s,1);
      s.bulge.median=GetBBM(s,1);s.bulge.atrVal=GetATR(s,1);
      if(dir==1){s.bulge.impBand=GetBBU(s,1);s.bulge.oppBand=GetBBL(s,1);}
      else      {s.bulge.impBand=GetBBL(s,1);s.bulge.oppBand=GetBBU(s,1);}
      s.state=SS_BULGE;s.stateCount=0;s.totalSignals++;
      // Registra ATR entry per stats volatilità
      double pipF=(StringFind(s.name,"JPY")>=0)?100.0:10000.0;
      s.stats.sumATR+=GetATR(s,1)*pipF;s.stats.atrCount++;
      if(InpDebug) PrintFormat("%s BULGE dir=%d atr=%.5f",s.name,dir,s.bulge.atrVal);
   }
}
void DoBulge(SymbolState &s) {
   if(s.stateCount<2) return;
   if(s.stateCount>InpMaxBulgeBar){ResetSym(s);return;}
   int bad=0;
   for(int i=1;i<=MathMin(s.stateCount,5);i++){if(IsImpulsive(s.name,i,InpRetATRMax,s))bad++;}
   if(bad>=2){ResetSym(s);return;}
   double atr=GetATR(s,1),med=GetBBM(s,1),cl1=iClose(s.name,PERIOD_CURRENT,1);
   double distOpp=(s.bulge.dir==1)?cl1-GetBBL(s,1):GetBBU(s,1)-cl1;
   double distMed=(s.bulge.dir==1)?cl1-med:med-cl1;
   if(distOpp<=atr*1.5){s.state=SS_CONT_WAIT;s.stateCount=0;return;}
   if(distMed<=atr*0.5||(s.bulge.dir==1&&cl1<=med)||(s.bulge.dir==-1&&cl1>=med)){
      s.medianTested=false;s.state=SS_INV_MEDIAN;s.stateCount=0;
   }
}
bool CheckInvalidBase(SymbolState &s,bool isCont) {
   double mult=isCont?InpRetATRMax:InpRetATRMaxInv;
   if(IsImpulsive(s.name,1,mult,s)) return true;
   double rng=CndRange(s.name,1),atr=GetATR(s,1);
   if(rng>atr*1.2&&CndBody(s.name,1)<rng*0.3) return true;
   return false;
}
void DoCont(SymbolState &s) {
   if(s.stateCount>InpMaxRetBars){ResetSym(s);return;}
   if(CheckInvalidBase(s,true)){ResetSym(s);return;}
   double atr=GetATR(s,1),med=GetBBM(s,1);
   double hi1=iHigh(s.name,PERIOD_CURRENT,1),lo1=iLow(s.name,PERIOD_CURRENT,1);
   bool touched=false;int dir=0;double ent=0,sl=0,tp=0;
   if(s.bulge.dir==1&&lo1<=GetBBL(s,1)){touched=true;dir=1;ent=GetBBL(s,1);sl=ent-InpSLMult*atr;tp=med;}
   else if(s.bulge.dir==-1&&hi1>=GetBBU(s,1)){touched=true;dir=-1;ent=GetBBU(s,1);sl=ent+InpSLMult*atr;tp=med;}
   if(!touched) return;
   if(IsImpulsive(s.name,1,InpBulgeATRMin,s)){ResetSym(s);return;}
   if(GetBW(s,1)>GetBW(s,4)*1.15){ResetSym(s);return;}
   if(MathAbs(tp-ent)<atr*0.5){ResetSym(s);return;}
   if(PlaceOrder(s,dir,ent,sl,tp,"CONT")){s.state=SS_ORDER_ACTIVE;s.stateCount=0;s.totalOrders++;}
}
void DoInvMed(SymbolState &s) {
   if(s.stateCount>InpMaxRetBars){ResetSym(s);return;}
   if(CheckInvalidBase(s,false)){ResetSym(s);return;}
   double med=GetBBM(s,1);
   double hi1=iHigh(s.name,PERIOD_CURRENT,1),lo1=iLow(s.name,PERIOD_CURRENT,1),cl1=iClose(s.name,PERIOD_CURRENT,1);
   if(s.bulge.dir==1&&lo1<=GetBBL(s,1)){ResetSym(s);return;}
   if(s.bulge.dir==-1&&hi1>=GetBBU(s,1)){ResetSym(s);return;}
   bool mt=(s.bulge.dir==1)?(lo1<=med||cl1<=med*1.0005):(hi1>=med||cl1>=med*0.9995);
   if(mt){s.medianTested=true;s.state=SS_INV_RETEST;s.stateCount=0;}
}
void DoInvRet(SymbolState &s) {
   if(s.stateCount>30){ResetSym(s);return;}
   if(CheckInvalidBase(s,false)){ResetSym(s);return;}
   double atr=GetATR(s,1),med=GetBBM(s,1);
   double hi1=iHigh(s.name,PERIOD_CURRENT,1),lo1=iLow(s.name,PERIOD_CURRENT,1);
   if(GetBW(s,1)>GetBW(s,4)*1.15){ResetSym(s);return;}
   bool touched=false;int dir=0;double ent=0,sl=0,tp=0;
   if(s.bulge.dir==1){
      if(GetBBU(s,1)>GetBBU(s,4)*1.005){ResetSym(s);return;}
      if(hi1>=GetBBU(s,1)){
         if(IsImpulsive(s.name,1,InpRetATRMaxInv,s)){ResetSym(s);return;}
         touched=true;dir=-1;ent=GetBBU(s,1);sl=ent+InpSLMult*atr;tp=med;
      }
   } else {
      if(GetBBL(s,1)<GetBBL(s,4)*0.995){ResetSym(s);return;}
      if(lo1<=GetBBL(s,1)){
         if(IsImpulsive(s.name,1,InpRetATRMaxInv,s)){ResetSym(s);return;}
         touched=true;dir=1;ent=GetBBL(s,1);sl=ent-InpSLMult*atr;tp=med;
      }
   }
   if(!touched) return;
   if(MathAbs(tp-ent)<atr*0.5){ResetSym(s);return;}
   if(PlaceOrder(s,dir,ent,sl,tp,"INV")){s.state=SS_ORDER_ACTIVE;s.stateCount=0;s.totalOrders++;}
}

//============================================================
//  PIAZZA ORDINE LIMIT
//============================================================
bool PlaceOrder(SymbolState &s,int dir,double entry,double sl,double tp,string ptype) {
   int digs=(int)SymbolInfoInteger(s.name,SYMBOL_DIGITS);
   double point=SymbolInfoDouble(s.name,SYMBOL_POINT);
   entry=NormalizeDouble(entry,digs);sl=NormalizeDouble(sl,digs);tp=NormalizeDouble(tp,digs);
   double lots=CalcLots(s.name,entry,sl);
   if(lots<=0) return false;
   double ask=SymbolInfoDouble(s.name,SYMBOL_ASK),bid=SymbolInfoDouble(s.name,SYMBOL_BID);
   long stopLv=SymbolInfoInteger(s.name,SYMBOL_TRADE_STOPS_LEVEL);
   double minD=stopLv*point;
   string cmt="BB|"+ptype+"|"+s.name+"|Magic:"+IntegerToString(InpMagic);
   bool ok=false;
   if(dir==1){
      if(entry>=bid-minD) entry=NormalizeDouble(bid-minD-point*2,digs);
      sl=NormalizeDouble(entry-InpSLMult*GetATR(s,1),digs);
      ok=trade.BuyLimit(lots,entry,s.name,sl,tp,ORDER_TIME_GTC,0,cmt);
   } else {
      if(entry<=ask+minD) entry=NormalizeDouble(ask+minD+point*2,digs);
      sl=NormalizeDouble(entry+InpSLMult*GetATR(s,1),digs);
      ok=trade.SellLimit(lots,entry,s.name,sl,tp,ORDER_TIME_GTC,0,cmt);
   }
   if(ok){
      s.pendTicket=trade.ResultOrder();
      if(InpLogTrades)
         PrintFormat("[%s] %s %s lots=%.2f entry=%.5f sl=%.5f tp=%.5f",
                     s.name,(dir==1?"BUY_LIM":"SELL_LIM"),ptype,lots,entry,sl,tp);
   } else {
      PrintFormat("[%s] ERRORE: %s",s.name,trade.ResultRetcodeDescription());
   }
   return ok;
}

//============================================================
//  CALCOLO LOTTI
//============================================================
double CalcLots(string symName,double entry,double sl) {
   double balance=AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmt=balance*InpRiskPct/100.0;
   double tickVal=SymbolInfoDouble(symName,SYMBOL_TRADE_TICK_VALUE);
   double tickSz =SymbolInfoDouble(symName,SYMBOL_TRADE_TICK_SIZE);
   double point  =SymbolInfoDouble(symName,SYMBOL_POINT);
   double slDist =MathAbs(entry-sl);
   if(slDist<=0||tickSz<=0) return 0;
   double valPtLot=(tickVal/tickSz)*point;
   if(valPtLot<=0) return 0;
   double lots=riskAmt/(slDist/point*valPtLot);
   double minLot=SymbolInfoDouble(symName,SYMBOL_VOLUME_MIN);
   double maxLot=SymbolInfoDouble(symName,SYMBOL_VOLUME_MAX);
   double stepLot=SymbolInfoDouble(symName,SYMBOL_VOLUME_STEP);
   if(stepLot>0) lots=MathFloor(lots/stepLot)*stepLot;
   return MathMax(minLot,MathMin(maxLot,lots));
}

//============================================================
//  BREAK-EVEN
//============================================================
void ManageBreakEven() {
   for(int i=PositionsTotal()-1;i>=0;i--) {
      if(!posInfo.SelectByIndex(i)) continue;
      if(posInfo.Magic()!=InpMagic) continue;
      int psIdx=-1;
      for(int j=0;j<symCount;j++){if(sym[j].name==posInfo.Symbol()){psIdx=j;break;}}
      if(psIdx<0) continue;
      double open=posInfo.PriceOpen(),curSL=posInfo.StopLoss();
      double point=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_POINT);
      int digs=(int)SymbolInfoInteger(posInfo.Symbol(),SYMBOL_DIGITS);
      double atr=GetATR(sym[psIdx],1); if(atr==0) continue;
      double bid=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_BID);
      double ask=SymbolInfoDouble(posInfo.Symbol(),SYMBOL_ASK);
      if(posInfo.PositionType()==POSITION_TYPE_BUY){
         if((bid-open)>=InpBEAtrMult*atr&&curSL<open)
            trade.PositionModify(posInfo.Ticket(),NormalizeDouble(open+point,digs),posInfo.TakeProfit());
      } else {
         if((open-ask)>=InpBEAtrMult*atr&&curSL>open)
            trade.PositionModify(posInfo.Ticket(),NormalizeDouble(open-point,digs),posInfo.TakeProfit());
      }
   }
}

//============================================================
//  TP TRAILING MEDIANA
//============================================================
void UpdateAllTP() {
   static datetime lastCheck=0;
   datetime curBar=iTime(_Symbol,PERIOD_CURRENT,0);
   if(curBar==lastCheck) return; lastCheck=curBar;
   for(int i=PositionsTotal()-1;i>=0;i--) {
      if(!posInfo.SelectByIndex(i)) continue;
      if(posInfo.Magic()!=InpMagic) continue;
      int psIdx=-1;
      for(int j=0;j<symCount;j++){if(sym[j].name==posInfo.Symbol()){psIdx=j;break;}}
      if(psIdx<0) continue;
      double newTP=GetBBM(sym[psIdx],1);
      int digs=(int)SymbolInfoInteger(posInfo.Symbol(),SYMBOL_DIGITS);
      double ntp=NormalizeDouble(newTP,digs),curTP=posInfo.TakeProfit();
      bool improve=false;
      if(posInfo.PositionType()==POSITION_TYPE_BUY&&ntp>curTP)  improve=true;
      if(posInfo.PositionType()==POSITION_TYPE_SELL&&ntp<curTP) improve=true;
      if(improve) trade.PositionModify(posInfo.Ticket(),posInfo.StopLoss(),ntp);
   }
}

//============================================================
//  CHECK ORDINE SIMBOLO
//============================================================
void CheckSymbolOrder(SymbolState &s) {
   bool ordOk=false,posOk=false;
   for(int i=OrdersTotal()-1;i>=0;i--){
      if(ordInfo.SelectByIndex(i)&&ordInfo.Magic()==InpMagic&&ordInfo.Symbol()==s.name){ordOk=true;break;}
   }
   for(int i=PositionsTotal()-1;i>=0;i--){
      if(posInfo.SelectByIndex(i)&&posInfo.Magic()==InpMagic&&posInfo.Symbol()==s.name){posOk=true;break;}
   }
   if(!ordOk&&!posOk) ResetSym(s);
}

//============================================================
//  UTILITY
//============================================================
int CountMyTrades() {
   int cnt=0;
   for(int i=PositionsTotal()-1;i>=0;i--){if(posInfo.SelectByIndex(i)&&posInfo.Magic()==InpMagic)cnt++;}
   for(int i=OrdersTotal()-1;i>=0;i--){if(ordInfo.SelectByIndex(i)&&ordInfo.Magic()==InpMagic)cnt++;}
   return cnt;
}
void ResetSym(SymbolState &s) {
   s.state=SS_SCAN;s.stateCount=0;
   ZeroMemory(s.bulge);ZeroMemory(s.cong);
   s.medianTested=false;s.pendTicket=0;
}

//============================================================
//  DASHBOARD BACKTEST
//============================================================
void DrawComment() {
   string stN[]={"SCAN","CONG","BULGE","CONT","INV-M","INV-R","ORD"};
   string txt="=== BB BACKTEST v2.0 — ALL CROSSES ===\n";
   txt+=StringFormat("Pair attivi:%d | Trades:%d/%d | Rischio:%.1f%%\n",
                     symCount,CountMyTrades(),InpMaxTrades,InpRiskPct);
   txt+="---\n";
   for(int i=0;i<symCount;i++) {
      int tot=sym[i].stats.wins+sym[i].stats.losses;
      double wr=(tot>0)?100.0*sym[i].stats.wins/tot:0;
      txt+=StringFormat("%-8s|%-6s|sig:%-3d|ord:%-3d|WR:%.0f%%\n",
                        sym[i].name,stN[(int)sym[i].state],
                        sym[i].totalSignals,sym[i].totalOrders,wr);
   }
   Comment(txt);
}

//+------------------------------------------------------------------+
//  FINE EA BREAKING BAND ALL CROSSES v2.0                           |
//+------------------------------------------------------------------+
