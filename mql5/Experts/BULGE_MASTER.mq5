//+------------------------------------------------------------------+
//| BULGE_MASTER.mq5                                                  |
//| Consolidamento di 8 versioni dell'EA "BULGE MULTI SIGNAL"        |
//|                                                                  |
//| Strategia (INVARIATA): mean-reversion su Bollinger "Bulge",      |
//| basket forex, H1. Tre segnali:                                   |
//|   ARANCIO  — IN-BULGE meta' bulge (su barra 1)                   |
//|   BLU      — IN-BULGE 2a candela (conferma su barra 0)           |
//|   VIOLA    — POST-BULGE (su barra 0)                             |
//| SL = ATR x N (default 3) | TP = mediana BB dinamica.            |
//|                                                                  |
//| Feature consolidate come INPUT (da quale versione provengono):  |
//|   - Filtro ATR              ........ (base/tutte)                |
//|   - Filtro ADX anti-bandriding ..... (v3)                       |
//|   - Filtro news orario      ........ (STRATEGY_AUTO)            |
//|   - Parziale a R + Break-even ...... (STRATEGY_AUTO)            |
//|   - Kill switch giornaliero ........ (v12 + v2 + KILL)          |
//|   - Risk per-trade / total cap ..... (KILL / v2)               |
//|   - Gestione ordini manuali ........ (CLEAN)                   |
//|   - Notifiche con tag segnale ...... (PARALLEL)               |
//|                                                                  |
//| MIGLIORIE DI CODICE:                                            |
//|   - Cache degli handle indicatore (iBands/iATR/iADX) per simbolo|
//|     creati in OnInit, rilasciati in OnDeinit (niente leak/ricrea)|
//|   - Filling adattivo (FOK/IOC/RETURN da SYMBOL_FILLING_MODE)    |
//|   - PositionModify rispettano SYMBOL_TRADE_STOPS_LEVEL          |
//|   - Kill switch ricalcolato da HistoryDeals (robusto a restart) |
//|                                                                  |
//| ATTENZIONE: il consolidamento NON crea un nuovo edge. La logica |
//| di segnale e' identica alle versioni originali. Il backtest      |
//| precedente (PF 2,82 / WR 87% / 85 trade / 40% qualita' dati)     |
//| ha forti sospetti di overfitting: da validare OUT-OF-SAMPLE.    |
//+------------------------------------------------------------------+
#property strict
#property copyright "Claudio — Breaking Band Strategy (consolidato)"
#property version   "4.00"

#include <Trade\Trade.mqh>
CTrade trade;

//==================================================================
// ENUM — Modalita' di gestione del rischio
//==================================================================
enum ENUM_RISK_MODE
{
   RISK_PER_TRADE = 0,   // Rischio fisso % per ogni trade
   RISK_TOTAL_CAP = 1    // Tetto totale % diviso per Max_Trades
};

//==================================================================
// INPUT — BOLLINGER
//==================================================================
input group "=== Bollinger Bands ==="
input int    BB_Period     = 20;    // BB Period
input double BB_Deviation  = 2.0;   // BB Deviation

//==================================================================
// INPUT — ATR / BULGE
//==================================================================
input group "=== ATR / Bulge ==="
input int    ATR_Period    = 14;    // ATR Period
input double SL_ATR_Mult    = 3.0;   // SL = ATR x questo moltiplicatore
input int    BB_Width_Len  = 50;    // Lookback BB Width
input double Bulge_Multi    = 1.1;   // Bulge minimo x media
input int    Lookback_Bars = 20;    // Finestra impulso (barre)

//==================================================================
// INPUT — SEGNALI
//==================================================================
input group "=== Segnali ==="
input bool   Use_Orange = false;   // Arancio — IN-BULGE meta' bulge
input bool   Use_Blue   = true;    // Blu     — IN-BULGE 2a candela
input bool   Use_Purple = true;    // Viola   — POST-BULGE

//==================================================================
// INPUT — FILTRO ATR
//==================================================================
input group "=== Filtro ATR ==="
input bool   Use_ATR_Filter = true; // Attiva filtro ATR
input int    ATR_MA_Len     = 20;   // Periodo media ATR
input double ATR_Max_Mult   = 1.8;  // ATR max (x media) — caos
input double ATR_Min_Mult   = 0.5;  // ATR min (x media) — piatto

//==================================================================
// INPUT — FILTRO ADX ANTI-BANDRIDING (da v3)
//==================================================================
input group "=== Filtro ADX anti-bandriding (v3) ==="
input bool   Use_ADX_Filter      = true;  // Attiva filtro ADX
input int    ADX_Period          = 14;    // Periodo ADX
input double ADX_Threshold        = 30.0;  // Soglia ADX (>= -> trend forte -> blocca)
input bool   ADX_Apply_On_Blue   = true;  // Applica filtro a segnali BLU
input bool   ADX_Apply_On_Purple = false; // Applica filtro a segnali VIOLA
input bool   ADX_Apply_On_Orange = false; // Applica filtro a segnali ARANCIO

//==================================================================
// INPUT — FILTRO NEWS ORARIO (da STRATEGY_AUTO)
//==================================================================
input group "=== Filtro news orario (STRATEGY_AUTO) ==="
input bool   Use_News_Filter   = false;       // Attiva filtro ore news
input string News_Block_Hours  = "7,9,11,12,15,22"; // Ore UTC da bloccare (CSV)

//==================================================================
// INPUT — PARZIALE A R + BREAK-EVEN (da STRATEGY_AUTO)
//==================================================================
input group "=== Parziale a R + Break-even (STRATEGY_AUTO) ==="
input bool   Enable_Partial_Close = false;  // Attiva chiusura parziale a R
input double Partial_Close_Pct    = 0.5;    // % volume da chiudere (0.5 = 50%)
input double Partial_Close_R      = 1.0;    // R multiplo per la chiusura parziale

//==================================================================
// INPUT — KILL SWITCH GIORNALIERO (unione v12 + v2 + KILL)
//==================================================================
input group "=== Kill switch giornaliero (v12 + v2 + KILL) ==="
input bool   Use_Kill_Switch     = true;   // Master ON/OFF kill switch
input int    Max_SL_PerDay        = 4;      // Stop dopo N SL totali nel giorno (0=off)
input int    Max_Consecutive_SL  = 3;      // Stop dopo N SL consecutivi (0=off)
input double Max_Daily_Loss_Pct  = 2.0;    // Stop se perdita giornaliera >= % balance (0=off)

//==================================================================
// INPUT — GESTIONE RISCHIO
//==================================================================
input group "=== Gestione rischio ==="
input ENUM_RISK_MODE Risk_Mode    = RISK_PER_TRADE; // Modalita' rischio
input double Risk_Percent          = 0.5;   // [RISK_PER_TRADE] Rischio % per trade
input double Total_Risk_Percent   = 2.0;   // [RISK_TOTAL_CAP] Rischio totale % (/ Max_Trades)
input int    Max_Trades            = 4;      // Max trade contemporanei

//==================================================================
// INPUT — GESTIONE ORDINI MANUALI (da CLEAN)
//==================================================================
input group "=== Gestione ordini manuali (CLEAN) ==="
input bool   Manage_Manual_Orders = false; // Gestisci posizioni magic=0
input double Manual_SL_ATR_Mult   = 3.0;   // SL manuale = ATR x questo valore

//==================================================================
// INPUT — IDENTITA' / SIMBOLI
//==================================================================
input group "=== Identita' / Simboli ==="
input int    Magic_Number = 20250100; // Magic Number
input string EA_Comment    = "BULGE_M"; // Prefisso commento ordini
input string Symbols_List  = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"; // Basket (22 cross)

//==================================================================
// VARIABILI GLOBALI
//==================================================================
string   g_symbols[];
int      g_symbolCount = 0;
datetime g_lastBarTime[];

// --- CACHE HANDLE INDICATORE (uno per simbolo) ---
int      g_hBands[];   // handle iBands per simbolo
int      g_hATR[];     // handle iATR per simbolo
int      g_hADX[];     // handle iADX per simbolo

// --- KILL SWITCH ---
bool     g_kill_active      = false; // EA fermo per il resto del giorno?
string   g_kill_reason      = "";    // Motivo dello stop
datetime g_kill_today_start = 0;     // Inizio giornata corrente (server time)

//==================================================================
// HELPER — Estrae il tag segnale dal commento (da PARALLEL)
// Esempio: "BULGE_M_BLU_L" -> "BLU LONG"
//==================================================================
string ExtractSignalTag(string comment, bool addDirection = true)
{
   string tag = "?";
   if(StringFind(comment, "_BLU_")     >= 0) tag = "BLU";
   else if(StringFind(comment, "_VIOLA_")   >= 0) tag = "VIOLA";
   else if(StringFind(comment, "_ARANCIO_") >= 0) tag = "ARANCIO";

   string dir = "";
   int len = StringLen(comment);
   if(len >= 2)
   {
      string suffix = StringSubstr(comment, len - 2);
      if(suffix == "_L")      dir = "LONG";
      else if(suffix == "_S") dir = "SHORT";
   }

   if(addDirection && dir != "") return tag + " " + dir;
   return tag;
}

//==================================================================
// FILLING ADATTIVO — sceglie FOK/IOC/RETURN dal simbolo
//==================================================================
ENUM_ORDER_TYPE_FILLING GetFillingMode(string sym)
{
   long modes = (long)SymbolInfoInteger(sym, SYMBOL_FILLING_MODE);
   // SYMBOL_FILLING_FOK = 1, SYMBOL_FILLING_IOC = 2 (bitmask)
   if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
   if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

//==================================================================
// INIT
//==================================================================
int OnInit()
{
   trade.SetExpertMagicNumber(Magic_Number);
   trade.SetDeviationInPoints(10);

   // Parse simboli
   g_symbolCount = StringSplit(Symbols_List, ',', g_symbols);
   if(g_symbolCount <= 0)
   {
      Print("BULGE_MASTER | ERRORE: Symbols_List vuoto");
      return(INIT_FAILED);
   }

   ArrayResize(g_lastBarTime, g_symbolCount);
   ArrayInitialize(g_lastBarTime, 0);

   // Alloca array per la cache degli handle
   ArrayResize(g_hBands, g_symbolCount);
   ArrayResize(g_hATR,   g_symbolCount);
   ArrayResize(g_hADX,   g_symbolCount);

   for(int i = 0; i < g_symbolCount; i++)
   {
      StringTrimLeft(g_symbols[i]);
      StringTrimRight(g_symbols[i]);

      if(!SymbolSelect(g_symbols[i], true))
         Print("BULGE_MASTER | Simbolo non trovato: ", g_symbols[i]);

      // [MIGLIORIA] Crea UN handle per simbolo (cache), non a ogni chiamata
      g_hBands[i] = iBands(g_symbols[i], PERIOD_H1, BB_Period, 0, BB_Deviation, PRICE_CLOSE);
      g_hATR[i]   = iATR  (g_symbols[i], PERIOD_H1, ATR_Period);
      g_hADX[i]   = Use_ADX_Filter ? iADX(g_symbols[i], PERIOD_H1, ADX_Period) : INVALID_HANDLE;

      if(g_hBands[i] == INVALID_HANDLE || g_hATR[i] == INVALID_HANDLE)
         Print("BULGE_MASTER | ERRORE handle indicatore per ", g_symbols[i]);
   }

   // Init kill switch
   g_kill_today_start = GetTodayStart();
   g_kill_active      = false;
   g_kill_reason      = "";

   // Log riepilogo configurazione
   string adx_msg = "OFF";
   if(Use_ADX_Filter)
   {
      adx_msg = "ON soglia=" + DoubleToString(ADX_Threshold, 1) + " su:";
      if(ADX_Apply_On_Blue)   adx_msg += " BLU";
      if(ADX_Apply_On_Purple) adx_msg += " VIOLA";
      if(ADX_Apply_On_Orange) adx_msg += " ARANCIO";
   }
   string risk_msg = (Risk_Mode == RISK_PER_TRADE)
                     ? ("PER_TRADE " + DoubleToString(Risk_Percent, 2) + "%")
                     : ("TOTAL_CAP " + DoubleToString(Total_Risk_Percent, 2) + "% / " +
                        IntegerToString(Max_Trades));
   string kill_msg = Use_Kill_Switch
                     ? StringFormat("ON | SL/gg<%d | ConsecSL<%d | DailyLoss<=-%.1f%%",
                                    Max_SL_PerDay, Max_Consecutive_SL, Max_Daily_Loss_Pct)
                     : "OFF";

   Print("BULGE_MASTER | Init OK | Simboli: ", g_symbolCount,
         " | Rischio: ", risk_msg,
         " | Max trade: ", Max_Trades,
         " | ADX: ", adx_msg,
         " | Kill: ", kill_msg);

   return(INIT_SUCCEEDED);
}

//==================================================================
// DEINIT — rilascia tutti gli handle in cache (niente leak)
//==================================================================
void OnDeinit(const int reason)
{
   for(int i = 0; i < g_symbolCount; i++)
   {
      if(g_hBands[i] != INVALID_HANDLE) IndicatorRelease(g_hBands[i]);
      if(g_hATR[i]   != INVALID_HANDLE) IndicatorRelease(g_hATR[i]);
      if(g_hADX[i]   != INVALID_HANDLE) IndicatorRelease(g_hADX[i]);
   }
   Print("BULGE_MASTER | Deinit reason=", reason);
}

//==================================================================
// ONTICK
//==================================================================
void OnTick()
{
   // Reset giornaliero kill switch (se cambio giorno)
   KillSwitchDailyReset();

   bool canOpen = KillSwitchCanTrade();

   for(int i = 0; i < g_symbolCount; i++)
   {
      string sym = g_symbols[i];

      // Solo alla nuova candela H1 (segnali su barra chiusa, no look-ahead)
      datetime barTime = iTime(sym, PERIOD_H1, 0);
      if(barTime == g_lastBarTime[i]) continue;
      g_lastBarTime[i] = barTime;

      if(!canOpen)                          continue; // kill switch: niente nuove aperture
      if(Use_News_Filter && IsNewsHour())   continue; // filtro news orario
      if(CountOpenTrades() >= Max_Trades)   continue;

      CheckSignal(i);
   }

   // --- Gestione posizioni gia' aperte (continua anche con kill attivo) ---
   if(Enable_Partial_Close) DoPartialCloseIfNeeded();
   if(Manage_Manual_Orders) ManageManualOrders();
   UpdateAllTP();
}

//==================================================================
// NOTIFICA CHIUSURA TRADE CON P&L E SEGNALE (da PARALLEL)
//==================================================================
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest     &request,
                        const MqlTradeResult      &result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;

   ulong dealTicket = trans.deal;
   if(dealTicket == 0) return;
   if(!HistoryDealSelect(dealTicket)) return;

   // Solo deal di uscita (chiusura) dei nostri ordini
   if(HistoryDealGetInteger(dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) return;
   if(HistoryDealGetInteger(dealTicket, DEAL_MAGIC) != Magic_Number)   return;

   string sym    = HistoryDealGetString(dealTicket, DEAL_SYMBOL);
   double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                 + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION)
                 + HistoryDealGetDouble(dealTicket, DEAL_SWAP);
   long   reason = HistoryDealGetInteger(dealTicket, DEAL_REASON);

   // Recupera il tag segnale dal deal di apertura (POSITION_ID)
   long   posID = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
   string openComment = "";
   if(HistorySelectByPosition(posID))
   {
      int totalDeals = HistoryDealsTotal();
      for(int d = 0; d < totalDeals; d++)
      {
         ulong dt = HistoryDealGetTicket(d);
         if(HistoryDealGetInteger(dt, DEAL_ENTRY) == DEAL_ENTRY_IN)
         {
            openComment = HistoryDealGetString(dt, DEAL_COMMENT);
            break;
         }
      }
   }
   string signal = ExtractSignalTag(openComment, true);

   string reasonStr = "manuale";
   if(reason == DEAL_REASON_TP)          reasonStr = "TP";
   else if(reason == DEAL_REASON_SL)     reasonStr = "SL";
   else if(reason == DEAL_REASON_EXPERT) reasonStr = "EA";

   string result_str = (profit >= 0) ? "PROFITTO" : "PERDITA";

   string msg = EA_Comment + " | " + sym + " | " + signal + " | " + reasonStr +
                " | " + result_str + " " + DoubleToString(profit, 2);
   SendNotification(msg);
   Print("BULGE_MASTER | CHIUSURA | ", sym, " | ", signal,
         " | ", reasonStr, " | ", result_str, " | ", DoubleToString(profit, 2));

   // Dopo una chiusura ricontrolla il kill switch (conta da history)
   KillSwitchEvaluate();
}

//==================================================================
//                     KILL SWITCH (robusto da HistoryDeals)
//==================================================================

//-- Inizio giornata corrente (server time)
datetime GetTodayStart()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   return StructToTime(dt);
}

//-- Reset al cambio giorno
void KillSwitchDailyReset()
{
   datetime today = GetTodayStart();
   if(today != g_kill_today_start)
   {
      g_kill_today_start = today;
      if(g_kill_active)
         Print("BULGE_MASTER | === NUOVO GIORNO === Kill switch RESET");
      g_kill_active = false;
      g_kill_reason = "";
   }
}

//-- Puo' aprire nuovi trade?
bool KillSwitchCanTrade()
{
   if(!Use_Kill_Switch) return true;
   KillSwitchDailyReset();
   if(!g_kill_active) KillSwitchEvaluate(); // valuta sempre lo stato corrente
   return !g_kill_active;
}

//-- Valuta i contatori giornalieri leggendoli da HistoryDeals.
//   Robusto a restart dell'EA: ricalcola sempre dalla history del giorno,
//   filtrando per magic. Conta: SL totali, SL consecutivi (sequenza finale),
//   P&L cumulato della giornata.
void KillSwitchEvaluate()
{
   if(!Use_Kill_Switch) return;

   datetime from = GetTodayStart();
   datetime to   = TimeCurrent() + 1;
   if(!HistorySelect(from, to)) return;

   double dayPnL       = 0.0;
   int    slCount      = 0;
   int    consecSL     = 0;   // SL consecutivi nella sequenza piu' recente
   int    runningSL    = 0;   // contatore corrente mentre scorro in ordine cronologico

   int total = HistoryDealsTotal();
   for(int d = 0; d < total; d++)
   {
      ulong ticket = HistoryDealGetTicket(d);
      if(ticket == 0) continue;
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != Magic_Number)   continue;
      if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;

      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT)
                    + HistoryDealGetDouble(ticket, DEAL_COMMISSION)
                    + HistoryDealGetDouble(ticket, DEAL_SWAP);
      long   reason = HistoryDealGetInteger(ticket, DEAL_REASON);

      dayPnL += profit;

      bool isSL = (reason == DEAL_REASON_SL) || (profit < 0.0);
      if(isSL)
      {
         slCount++;
         runningSL++;
      }
      else if(profit > 0.0)
      {
         runningSL = 0; // una vincita interrompe la sequenza consecutiva
      }
   }
   // Per il blocco "consecutivi" conta la sequenza piu' recente (in corso)
   consecSL = runningSL;

   // --- Valutazione condizioni di stop ---
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   if(Max_SL_PerDay > 0 && slCount >= Max_SL_PerDay)
      KillSwitchActivate(StringFormat("%d SL nel giorno (limite %d)", slCount, Max_SL_PerDay));

   else if(Max_Consecutive_SL > 0 && consecSL >= Max_Consecutive_SL)
      KillSwitchActivate(StringFormat("%d SL consecutivi (limite %d)", consecSL, Max_Consecutive_SL));

   else if(Max_Daily_Loss_Pct > 0.0 && balance > 0.0)
   {
      double lossPct = (dayPnL / balance) * 100.0;
      if(lossPct <= -Max_Daily_Loss_Pct)
         KillSwitchActivate(StringFormat("Daily Loss %.2f%% (limite -%.1f%%)",
                                         lossPct, Max_Daily_Loss_Pct));
   }
}

//-- Attiva il blocco (una sola notifica)
void KillSwitchActivate(string reason)
{
   if(g_kill_active) return;
   g_kill_active = true;
   g_kill_reason = reason;
   Print("BULGE_MASTER | *** KILL SWITCH ATTIVATO *** | ", reason);
   SendNotification(EA_Comment + " | KILL SWITCH | " + reason);
}

//==================================================================
// FILTRO ORARIO NEWS (da STRATEGY_AUTO)
//==================================================================
bool IsNewsHour()
{
   MqlDateTime dt;
   TimeToStruct(TimeGMT(), dt);
   int currentHour = dt.hour;

   string parts[];
   int count = StringSplit(News_Block_Hours, ',', parts);
   for(int i = 0; i < count; i++)
   {
      StringTrimLeft(parts[i]);
      StringTrimRight(parts[i]);
      if((int)StringToInteger(parts[i]) == currentHour) return true;
   }
   return false;
}

//==================================================================
// CONTEGGIO POSIZIONI
//==================================================================
int CountOpenTrades()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(PositionGetTicket(i) > 0)
         if(PositionGetInteger(POSITION_MAGIC) == Magic_Number)
            count++;
   return count;
}

//-- Gia' aperto sul simbolo con stesso commento (1 pos per simbolo/segnale)
bool HasOpenTrade(string sym, string comment)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionGetTicket(i) <= 0) continue;
      if(PositionGetString(POSITION_SYMBOL)  != sym)          continue;
      if(PositionGetInteger(POSITION_MAGIC)  != Magic_Number) continue;
      if(PositionGetString(POSITION_COMMENT) == comment)      return true;
   }
   return false;
}

//==================================================================
// DATI BARRE H1
//==================================================================
bool GetBars(string sym, int count,
             double &highs[], double &lows[],
             double &opens[], double &closes[])
{
   ArraySetAsSeries(highs,  true);
   ArraySetAsSeries(lows,   true);
   ArraySetAsSeries(opens,  true);
   ArraySetAsSeries(closes, true);
   if(CopyHigh (sym, PERIOD_H1, 0, count, highs)  < count) return false;
   if(CopyLow  (sym, PERIOD_H1, 0, count, lows)   < count) return false;
   if(CopyOpen (sym, PERIOD_H1, 0, count, opens)  < count) return false;
   if(CopyClose(sym, PERIOD_H1, 0, count, closes) < count) return false;
   return true;
}

//==================================================================
// [MIGLIORIA] LETTURA BB DALLA CACHE
// Legge "count" barre dei 3 buffer BB a partire da "start" con un solo
// Copybuffer per buffer, usando l'handle in cache del simbolo.
//==================================================================
bool GetBBSeries(int symIdx, int start, int count,
                 double &upper[], double &lower[], double &basis[])
{
   int h = g_hBands[symIdx];
   if(h == INVALID_HANDLE) return false;
   ArraySetAsSeries(upper, true);
   ArraySetAsSeries(lower, true);
   ArraySetAsSeries(basis, true);
   if(CopyBuffer(h, 1, start, count, upper) < count) return false; // upper band
   if(CopyBuffer(h, 2, start, count, lower) < count) return false; // lower band
   if(CopyBuffer(h, 0, start, count, basis) < count) return false; // media (mediana)
   return true;
}

//-- BB su una singola barra (usa la cache)
bool GetBB(int symIdx, int barIndex, double &bbUpper, double &bbLower, double &bbBasis)
{
   double u[], l[], b[];
   if(!GetBBSeries(symIdx, barIndex, 1, u, l, b)) return false;
   bbUpper = u[0]; bbLower = l[0]; bbBasis = b[0];
   return true;
}

//==================================================================
// [MIGLIORIA] LETTURA ATR DALLA CACHE
//==================================================================
bool GetATRSeries(int symIdx, int start, int count, double &atr[])
{
   int h = g_hATR[symIdx];
   if(h == INVALID_HANDLE) return false;
   ArraySetAsSeries(atr, true);
   if(CopyBuffer(h, 0, start, count, atr) < count) return false;
   return true;
}

double GetATR(int symIdx, int barIndex = 1)
{
   double a[];
   if(!GetATRSeries(symIdx, barIndex, 1, a)) return 0.0;
   return a[0];
}

//==================================================================
// FILTRO ATR (usa la cache)
//==================================================================
bool AtrOk(int symIdx)
{
   if(!Use_ATR_Filter) return true;
   double atr[];
   int needed = ATR_MA_Len + 2;
   if(!GetATRSeries(symIdx, 1, needed, atr)) return false;
   double sum = 0;
   for(int i = 0; i < ATR_MA_Len; i++) sum += atr[i];
   double atrMA  = sum / ATR_MA_Len;
   double atrNow = atr[0];
   return (atrNow <= atrMA * ATR_Max_Mult && atrNow >= atrMA * ATR_Min_Mult);
}

//==================================================================
// [v3] FILTRO ADX (usa la cache)
//==================================================================
double GetADX(int symIdx, int barIndex = 1)
{
   int h = g_hADX[symIdx];
   if(h == INVALID_HANDLE) return -1.0;
   double adx[];
   ArraySetAsSeries(adx, true);
   if(CopyBuffer(h, 0, barIndex, 1, adx) < 1) return -1.0; // buffer 0 = ADX main
   return adx[0];
}

//-- Ritorna TRUE se il trade puo' procedere, FALSE se va bloccato
bool AdxFilterOk(int symIdx, string sym, string signalType)
{
   if(!Use_ADX_Filter) return true;

   bool applyFilter = false;
   if(signalType == "BLU"     && ADX_Apply_On_Blue)   applyFilter = true;
   if(signalType == "VIOLA"   && ADX_Apply_On_Purple) applyFilter = true;
   if(signalType == "ARANCIO" && ADX_Apply_On_Orange) applyFilter = true;
   if(!applyFilter) return true;

   double adx = GetADX(symIdx, 1);
   if(adx < 0) return true; // se non calcolabile, lascio passare

   if(adx >= ADX_Threshold)
   {
      Print("BULGE_MASTER | ADX FILTER | ", sym, " | ", signalType,
            " bloccato | ADX=", DoubleToString(adx, 2),
            " >= soglia=", DoubleToString(ADX_Threshold, 2));
      return false;
   }
   return true;
}

//==================================================================
// BB WIDTH MA (per filtro bulge) — usa la cache
//==================================================================
double GetBBWidthMA(int symIdx)
{
   double upper[], lower[], basis[];
   int needed = BB_Width_Len + 2;
   if(!GetBBSeries(symIdx, 1, needed, upper, lower, basis)) return 0.0;
   double sum = 0;
   for(int i = 0; i < BB_Width_Len; i++) sum += (upper[i] - lower[i]);
   return sum / BB_Width_Len;
}

//==================================================================
// CALCOLO LOTTI DA RISCHIO %
//==================================================================
double CalcLots(string sym, double slDist)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   // Rischio % effettivo a seconda della modalita'
   double riskPct = (Risk_Mode == RISK_PER_TRADE)
                    ? Risk_Percent
                    : (Total_Risk_Percent / MathMax(1, Max_Trades));

   double riskAmt   = balance * riskPct / 100.0;
   double tickValue = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   double point     = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(tickSize <= 0 || tickValue <= 0 || point <= 0) return 0.01;

   double slPoints = slDist / point;
   double lots     = riskAmt / (slPoints * tickValue / tickSize * point);

   double lotStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double lotMin  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double lotMax  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   if(lotStep <= 0) lotStep = 0.01;
   lots = MathFloor(lots / lotStep) * lotStep;
   return NormalizeDouble(MathMax(lotMin, MathMin(lotMax, lots)), 2);
}

//==================================================================
// APRE ORDINE
//==================================================================
void OpenOrder(string sym, bool isLong, double atr, double bbBasis, string comment)
{
   if(HasOpenTrade(sym, comment))      return;
   if(CountOpenTrades() >= Max_Trades) return;

   trade.SetTypeFilling(GetFillingMode(sym)); // filling adattivo per simbolo

   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
   double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
   double slDist = atr * SL_ATR_Mult;
   double lots   = CalcLots(sym, slDist);
   if(lots <= 0) return;

   if(isLong)
   {
      double sl = NormalizeDouble(ask - slDist, digits);
      double tp = NormalizeDouble(bbBasis, digits);
      if(tp <= ask) { Print("BULGE_MASTER | LONG skip TP<ask | ", sym); return; }
      if(sl >= ask) { Print("BULGE_MASTER | LONG skip SL>ask | ", sym); return; }
      if(trade.Buy(lots, sym, ask, sl, tp, comment))
      {
         string signal = ExtractSignalTag(comment, false);
         Print("BULGE_MASTER | LONG | ", comment, " | ", sym,
               " | Lots=", lots, " | SL=", sl, " | TP=", tp);
         SendNotification(EA_Comment + " | " + sym + " | BUY | " + signal);
      }
      else
         Print("BULGE_MASTER | LONG ERR | ", sym, " | ", trade.ResultRetcodeDescription());
   }
   else
   {
      double sl = NormalizeDouble(bid + slDist, digits);
      double tp = NormalizeDouble(bbBasis, digits);
      if(tp >= bid) { Print("BULGE_MASTER | SHORT skip TP>bid | ", sym); return; }
      if(sl <= bid) { Print("BULGE_MASTER | SHORT skip SL<bid | ", sym); return; }
      if(trade.Sell(lots, sym, bid, sl, tp, comment))
      {
         string signal = ExtractSignalTag(comment, false);
         Print("BULGE_MASTER | SHORT | ", comment, " | ", sym,
               " | Lots=", lots, " | SL=", sl, " | TP=", tp);
         SendNotification(EA_Comment + " | " + sym + " | SELL | " + signal);
      }
      else
         Print("BULGE_MASTER | SHORT ERR | ", sym, " | ", trade.ResultRetcodeDescription());
   }
}

//==================================================================
// LOGICA PRINCIPALE — tutti e 3 i segnali (INVARIATA)
// NB: identica a v3_PARALLEL_KILL. Cambia SOLO la sorgente dati
//     (handle in cache via GetBB/GetATR per symIdx).
//==================================================================
void CheckSignal(int symIdx)
{
   string sym = g_symbols[symIdx];
   int barsNeeded = Lookback_Bars * 2 + 10;

   double highs[], lows[], opens[], closes[];
   if(!GetBars(sym, barsNeeded, highs, lows, opens, closes)) return;

   if(!AtrOk(symIdx)) return;

   // ATR e BB sulla barra 1 (chiusa)
   double atr1 = GetATR(symIdx, 1);
   if(atr1 <= 0) return;

   double bbUpper1, bbLower1, bbBasis1;
   if(!GetBB(symIdx, 1, bbUpper1, bbLower1, bbBasis1)) return;

   // BB Width corrente e MA
   double bbWidth1  = bbUpper1 - bbLower1;
   double bbWidthMA = GetBBWidthMA(symIdx);
   if(bbWidthMA <= 0) return;
   bool isBulge1 = (bbWidth1 >= bbWidthMA * Bulge_Multi);

   // BB sulla barra 0 (corrente) per il TP iniziale
   double bbUpper0, bbLower0, bbBasis0;
   if(!GetBB(symIdx, 0, bbUpper0, bbLower0, bbBasis0)) return;

   // Pre-carica le serie ATR e BB per il loop impulso (un solo CopyBuffer)
   double atrSeries[];
   double bbUSeries[], bbLSeries[], bbBSeries[];
   if(!GetATRSeries(symIdx, 0, barsNeeded, atrSeries)) return;
   if(!GetBBSeries(symIdx, 0, barsNeeded, bbUSeries, bbLSeries, bbBSeries)) return;

   //----------------------------------------------------------------
   // TROVA ULTIMO IMPULSO
   //----------------------------------------------------------------
   int barsSinceImpDown = -1;
   int barsSinceImpUp   = -1;

   for(int k = 1; k < barsNeeded - 1; k++)
   {
      double atrK = atrSeries[k];
      double bbUK = bbUSeries[k], bbLK = bbLSeries[k];

      bool impDown = (lows[k]  <= bbLK && closes[k] < opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);
      bool impUp   = (highs[k] >= bbUK && closes[k] > opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);

      if(impDown && barsSinceImpDown < 0) barsSinceImpDown = k;
      if(impUp   && barsSinceImpUp   < 0) barsSinceImpUp   = k;
      if(barsSinceImpDown >= 0 && barsSinceImpUp >= 0) break;
   }

   //----------------------------------------------------------------
   // MEDIANA E BANDA OPPOSTA TOCCATE DOPO IMPULSO
   //----------------------------------------------------------------
   bool midAfterImpDown = false, midAfterImpUp = false;
   bool oppAfterImpDown = false, oppAfterImpUp = false;

   if(barsSinceImpDown > 0)
   {
      for(int k = 1; k < barsSinceImpDown; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpDown = true; }
         if(highs[k] >= bbUK)                     { oppAfterImpDown = true; }
      }
   }
   if(barsSinceImpUp > 0)
   {
      for(int k = 1; k < barsSinceImpUp; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpUp = true; }
         if(lows[k]  <= bbLK)                     { oppAfterImpUp = true; }
      }
   }

   //----------------------------------------------------------------
   // BANDA PIATTA (per POST-BULGE)
   //----------------------------------------------------------------
   bool lowerFlat = false, upperFlat = false;
   {
      double bbU6 = bbUSeries[7], bbL6 = bbLSeries[7];
      lowerFlat = MathAbs(bbLower1 - bbL6) <= atr1 * 0.6;
      upperFlat = MathAbs(bbUpper1 - bbU6) <= atr1 * 0.6;
   }

   //----------------------------------------------------------------
   // CANDELA DI REAZIONE SU BARRA 1
   //----------------------------------------------------------------
   bool bullReaction1 = (closes[1] > opens[1] && lows[1]  <= bbLower1);
   bool bearReaction1 = (closes[1] < opens[1] && highs[1] >= bbUpper1);

   //----------------------------------------------------------------
   // SEGNALE ORIGINALE SU BARRA 1 (base per arancio e blu)
   //----------------------------------------------------------------
   bool origLong1 = isBulge1 &&
        barsSinceImpDown >= 1 && barsSinceImpDown <= Lookback_Bars &&
        !midAfterImpDown && !oppAfterImpDown && bullReaction1;

   bool origShort1 = isBulge1 &&
        barsSinceImpUp >= 1 && barsSinceImpUp <= Lookback_Bars &&
        !midAfterImpUp && !oppAfterImpUp && bearReaction1;

   //----------------------------------------------------------------
   // ARANCIO — META' BULGE (su barra 1)
   //----------------------------------------------------------------
   if(Use_Orange)
   {
      if(origLong1 && barsSinceImpDown > 0)
      {
         double impMid = (highs[barsSinceImpDown] + lows[barsSinceImpDown]) / 2.0;
         if(closes[1] >= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, true, atr1, bbBasis1, EA_Comment + "_ARANCIO_L");
      }
      if(origShort1 && barsSinceImpUp > 0)
      {
         double impMid = (highs[barsSinceImpUp] + lows[barsSinceImpUp]) / 2.0;
         if(closes[1] <= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, false, atr1, bbBasis1, EA_Comment + "_ARANCIO_S");
      }
   }

   //----------------------------------------------------------------
   // BLU — 2A CANDELA (conferma su barra 0)
   //----------------------------------------------------------------
   if(Use_Blue)
   {
      bool confirmLong  = (closes[0] > opens[0] && !(lows[0]  <= bbLower0) && closes[0] > lows[1]);
      bool confirmShort = (closes[0] < opens[0] && !(highs[0] >= bbUpper0) && closes[0] < highs[1]);

      if(origLong1  && confirmLong  && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, true,  atr1, bbBasis0, EA_Comment + "_BLU_L");
      if(origShort1 && confirmShort && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, false, atr1, bbBasis0, EA_Comment + "_BLU_S");
   }

   //----------------------------------------------------------------
   // VIOLA — POST-BULGE (su barra 0)
   //----------------------------------------------------------------
   if(Use_Purple)
   {
      bool candleNotImpulsive = MathAbs(closes[0] - opens[0]) <= atr1 * 1.5;

      bool postBulgeLong =
           barsSinceImpDown >= 1 && barsSinceImpDown <= Lookback_Bars * 2 &&
           midAfterImpDown && !oppAfterImpDown &&
           lows[0] <= bbLower0 && lowerFlat &&
           candleNotImpulsive;

      bool postBulgeShort =
           barsSinceImpUp >= 1 && barsSinceImpUp <= Lookback_Bars * 2 &&
           midAfterImpUp && !oppAfterImpUp &&
           highs[0] >= bbUpper0 && upperFlat &&
           candleNotImpulsive;

      if(postBulgeLong  && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, true,  atr1, bbBasis0, EA_Comment + "_VIOLA_L");
      if(postBulgeShort && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, false, atr1, bbBasis0, EA_Comment + "_VIOLA_S");
   }
}

//==================================================================
// PARZIALE A R + BREAK-EVEN (da STRATEGY_AUTO)
// - Quando il profitto raggiunge Partial_Close_R volte il rischio,
//   chiude Partial_Close_Pct del volume e sposta SL a BE.
// - Marca la posizione tramite GlobalVariable per non ripetere.
//==================================================================
string PartialDoneKey(ulong ticket)
{
   return "BULGE_M_PC_" + IntegerToString(Magic_Number) + "_" + IntegerToString((long)ticket);
}

void DoPartialCloseIfNeeded()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != Magic_Number) continue;

      string key = PartialDoneKey(ticket);
      if(GlobalVariableCheck(key)) continue; // gia' fatto su questa posizione

      string sym    = PositionGetString(POSITION_SYMBOL);
      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double volume = PositionGetDouble(POSITION_VOLUME);
      double curTP  = PositionGetDouble(POSITION_TP);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);

      if(sl <= 0) continue;
      double risk = MathAbs(entry - sl);
      if(risk <= 0) continue;

      double curPrice = (type == POSITION_TYPE_BUY)
                        ? SymbolInfoDouble(sym, SYMBOL_BID)
                        : SymbolInfoDouble(sym, SYMBOL_ASK);
      double profitDist = (type == POSITION_TYPE_BUY) ? (curPrice - entry) : (entry - curPrice);
      double curR = profitDist / risk;
      if(curR < Partial_Close_R) continue;

      // Volume da chiudere (rispetta step/min e lascia un residuo >= lotMin)
      double lotStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
      double lotMin  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
      if(lotStep <= 0) lotStep = 0.01;
      double closeVol = MathFloor(volume * Partial_Close_Pct / lotStep) * lotStep;
      closeVol = MathMax(lotMin, closeVol);
      if(closeVol >= volume) closeVol = MathFloor((volume - lotMin) / lotStep) * lotStep;
      if(closeVol < lotMin) continue;

      trade.SetTypeFilling(GetFillingMode(sym));
      if(trade.PositionClosePartial(ticket, closeVol))
      {
         Print("BULGE_MASTER | Partial Close | ", sym,
               " | R=", DoubleToString(curR, 2),
               " | Chiusi ", DoubleToString(closeVol, 2), " lotti");

         // Sposta SL a break-even sul residuo (rispetta STOPS_LEVEL)
         if(PositionSelectByTicket(ticket))
         {
            double newSL  = NormalizeDouble(entry, digits);
            double minDist = (double)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL) * point;
            double nowPrice = (type == POSITION_TYPE_BUY)
                              ? SymbolInfoDouble(sym, SYMBOL_BID)
                              : SymbolInfoDouble(sym, SYMBOL_ASK);

            bool beValid = (type == POSITION_TYPE_BUY)
                           ? ((nowPrice - newSL) > minDist)
                           : ((newSL - nowPrice) > minDist);

            if(beValid && trade.PositionModify(ticket, newSL, curTP))
               Print("BULGE_MASTER | BE impostato | ", sym, " | BE=", DoubleToString(newSL, digits));
         }

         // Marca la posizione come gia' parzializzata
         GlobalVariableSet(key, (double)TimeCurrent());
      }
   }
}

//==================================================================
// GESTIONE ORDINI MANUALI (da CLEAN)
// Su posizioni magic=0: imposta SL=ATR x Manual_SL_ATR_Mult se mancante
// e TP=mediana BB (dinamico). Rispetta STOPS_LEVEL.
//==================================================================
void ManageManualOrders()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != 0) continue; // solo manuali

      string sym = PositionGetString(POSITION_SYMBOL);

      // Serve l'handle in cache: cerca l'indice del simbolo
      int symIdx = SymbolIndex(sym);
      if(symIdx < 0) continue; // simbolo non nel basket: non gestibile via cache

      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
      double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      double minDist= (double)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL) * point;

      double atr = GetATR(symIdx, 1);
      if(atr <= 0) continue;

      double bbU, bbL, bbMid;
      if(!GetBB(symIdx, 1, bbU, bbL, bbMid)) continue;

      double newSL = sl;
      double newTP = NormalizeDouble(bbMid, digits);

      // SL se mancante
      if(sl == 0)
      {
         newSL = (type == POSITION_TYPE_BUY)
                 ? NormalizeDouble(entry - atr * Manual_SL_ATR_Mult, digits)
                 : NormalizeDouble(entry + atr * Manual_SL_ATR_Mult, digits);
      }

      // Valida TP sulla mediana (deve essere dalla parte giusta e oltre STOPS_LEVEL)
      bool tpValid = (type == POSITION_TYPE_BUY)
                     ? (newTP > bid + minDist && newTP > entry)
                     : (newTP < ask - minDist && newTP < entry);
      if(!tpValid) newTP = tp; // se non valido lascia il TP attuale

      bool slChanged = (MathAbs(newSL - sl) > 5 * point);
      bool tpChanged = (MathAbs(newTP - tp) > 5 * point);
      if(slChanged || tpChanged)
         trade.PositionModify(ticket, newSL, newTP);
   }
}

//-- Indice del simbolo nell'array (per accedere alla cache); -1 se assente
int SymbolIndex(string sym)
{
   for(int i = 0; i < g_symbolCount; i++)
      if(g_symbols[i] == sym) return i;
   return -1;
}

//==================================================================
// AGGIORNA TP SULLA MEDIANA AD OGNI TICK (INVARIATO)
// - Mediana dalla barra 1 (chiusa) per stabilita'
// - Non sposta il TP "contro" l'entrata; non tocca lo SL (BE preservato)
//==================================================================
void UpdateAllTP()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != Magic_Number) continue;

      string sym    = PositionGetString(POSITION_SYMBOL);
      int    symIdx = SymbolIndex(sym);
      if(symIdx < 0) continue;

      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double sl     = PositionGetDouble(POSITION_SL);
      double curTP  = PositionGetDouble(POSITION_TP);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);

      double bbU, bbL, bbMid;
      if(!GetBB(symIdx, 1, bbU, bbL, bbMid)) continue;
      double newTP = NormalizeDouble(bbMid, digits);

      double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
      double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      double minDist = 10 * point;

      if(type == POSITION_TYPE_BUY)
      {
         if(newTP <= entry)         continue;
         if(newTP <= bid + minDist) continue;
      }
      else if(type == POSITION_TYPE_SELL)
      {
         if(newTP >= entry)         continue;
         if(newTP >= ask - minDist) continue;
      }

      if(MathAbs(newTP - curTP) <= 5 * point) continue;

      trade.PositionModify(ticket, sl, newTP);
   }
}
//+------------------------------------------------------------------+
