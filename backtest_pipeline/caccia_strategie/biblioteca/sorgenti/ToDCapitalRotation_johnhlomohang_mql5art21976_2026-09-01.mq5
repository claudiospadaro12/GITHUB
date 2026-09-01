//+------------------------------------------------------------------+
//|                                             ToD Cap Rotation.mq5 |
//|                        GIT under Copyright 2025, MetaQuotes Ltd. |
//|                     https://www.mql5.com/en/users/johnhlomohang/ |
//+------------------------------------------------------------------+
#property copyright "GIT under Copyright 2025, MetaQuotes Ltd."
#property link      "https://www.mql5.com/en/users/johnhlomohang/"
#property version   "1.00"

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>

CTrade trade;
CPositionInfo posInfo;

//--- Input parameters
input string   Symbols                = "XAUUSD,GBPUSD,USDJPY,USDZAR"; // Symbols to monitor

//--- Session activation
input bool     UseAsianSession        = true;
input bool     UseLondonSession       = true;
input bool     UseNewYorkSession      = true;

//--- Session times (broker time, 24h format)
input int      AsianStart             = 0;
input int      AsianEnd               = 8;
input int      LondonStart            = 8;
input int      LondonEnd              = 16;
input int      NYStart                = 13;
input int      NYEnd                  = 22;

//--- Symbols active per session
input string   AsianSymbols           = "USDJPY,XAUUSD";
input string   LondonSymbols          = "GBPUSD";
input string   NYSymbols              = "XAUUSD,USDZAR";

//--- Session Range Parameters
input int      SessionRangeBars       = 100;       // Bars to look back for session high/low
input bool     RequireSessionFormation = true;     // Wait for session to form before trading
input int      SessionFormationMinutes = 60;       // Minutes after session start to start trading

//--- Volatility Stop Parameters
input bool     UseVolatilityStop      = true;      // Use ATR for volatility filter
input int      ATRPeriod              = 14;        // Period for ATR
input double   ATRMultiplier          = 1.5;       // ATR multiplier for volatility stop

// ============================================================
// CAPITAL ALLOCATION SETTINGS
// ============================================================
input double   DailyCapitalPercent    = 30.0;      // Total daily capital to risk (30%)

input bool     UseEqualSplit          = true;      // true = Equal split, false = Manual allocation

//--- Manual allocation (only used if UseEqualSplit = false)
input double   AsianAllocationPercent = 7.0;       // Asian session allocation (% of daily)
input double   LondonAllocationPercent = 8.0;      // London session allocation (% of daily)
input double   NYAllocationPercent    = 15.0;      // NY session allocation (% of daily)

//--- Breakout parameters
input double   StopLossATRMultiplier  = 1.5;       // SL = ATR * multiplier
input double   TakeProfitRR           = 2.0;       // Risk:Reward ratio
input bool     UseDynamicTP           = true;      // Use RR for TP instead of fixed

//--- Trade execution
input int      StopLoss_Pips_Fallback = 30;        // Fallback SL if ATR not available
input int      TakeProfit_Pips_Fallback = 60;      // Fallback TP if not using RR
input int      MagicNumber            = 123456;
input int      Slippage               = 30;

//+------------------------------------------------------------------+
//| Enumerations and structures                                      |
//+------------------------------------------------------------------+
enum SessionType
  {
   SESSION_ASIAN,
   SESSION_LONDON,
   SESSION_NEWYORK,
   SESSION_OFF
  };

struct SymbolData
  {
   string            name;
   double            sessionHigh;
   double            sessionLow;
   double            upperVolatilityStop;
   double            lowerVolatilityStop;
   bool              highBreakoutTriggered;
   bool              lowBreakoutTriggered;
   datetime          sessionStartTime;
   datetime          lastTradeTime;
   double            currentATR;
  };

struct SessionInfo
  {
   SessionType       type;
   double            allocationPercent;
   double            usedRisk;
   double            maxRisk;
   string            activeSymbols;
   datetime          startTime;
   datetime          endTime;
   bool              isActive;
  };

//+------------------------------------------------------------------+
//| Global variables                                                 |
//+------------------------------------------------------------------+
int         m_numSymbols;
SymbolData  m_symbols[];
SessionInfo m_currentSession;
SessionInfo m_asianSession;
SessionInfo m_londonSession;
SessionInfo m_nySession;
datetime    m_lastBarTime;
SessionType m_previousSession;
double      m_dailyRiskUsed;
double      m_dailyMaxRisk;
datetime    m_lastResetDate;
int         m_atrHandle[];
bool        m_dailyResetPrinted;
double      m_dailyNetProfit;
datetime    m_lastProfitUpdate;
bool        m_allocationValid;

//+------------------------------------------------------------------+
//| Validate allocation inputs                                       |
//+------------------------------------------------------------------+
bool ValidateAllocation()
  {
   m_allocationValid = true;

   if(!UseEqualSplit)
     {
      double totalPercent = 0;
      int activeSessions = 0;

      if(UseAsianSession)
        {
         if(AsianAllocationPercent < 0 || AsianAllocationPercent > 100)
           {
            Print("ERROR: Asian allocation must be between 0 and 100. Got: ", AsianAllocationPercent);
            m_allocationValid = false;
           }
         totalPercent += AsianAllocationPercent;
         activeSessions++;
        }

      if(UseLondonSession)
        {
         if(LondonAllocationPercent < 0 || LondonAllocationPercent > 100)
           {
            Print("ERROR: London allocation must be between 0 and 100. Got: ", LondonAllocationPercent);
            m_allocationValid = false;
           }
         totalPercent += LondonAllocationPercent;
         activeSessions++;
        }

      if(UseNewYorkSession)
        {
         if(NYAllocationPercent < 0 || NYAllocationPercent > 100)
           {
            Print("ERROR: NY allocation must be between 0 and 100. Got: ", NYAllocationPercent);
            m_allocationValid = false;
           }
         totalPercent += NYAllocationPercent;
         activeSessions++;
        }

      //--- Check if total exceeds 100%
      if(totalPercent > 100.01) // Small tolerance for floating point
        {
         Print("ERROR: Total session allocation (", totalPercent, "%) exceeds 100% of daily capital!");
         m_allocationValid = false;
        }

      //--- Check if total is significantly less than 100%
      if(activeSessions > 0 && totalPercent < 99.99)
        {
         Print("WARNING: Total session allocation (", totalPercent, "%) is less than 100% of daily capital. Remaining ",
               100 - totalPercent, "% will not be used.");
        }

      if(m_allocationValid)
         Print("Allocation validation passed. Total: ", totalPercent, "%");
     }
   else
     {
      Print("Using equal split allocation mode");
     }

   return m_allocationValid;
  }

//+------------------------------------------------------------------+
//| Calculate session allocation based on user settings              |
//+------------------------------------------------------------------+
double CalculateSessionAllocation(SessionType session)
  {
   if(UseEqualSplit)
     {
      int activeSessions = 0;
      if(UseAsianSession)
         activeSessions++;
      if(UseLondonSession)
         activeSessions++;
      if(UseNewYorkSession)
         activeSessions++;

      if(activeSessions == 0)
         return 0;

      return 100.0 / activeSessions;
     }
   else
     {
      switch(session)
        {
         case SESSION_ASIAN:
            return AsianAllocationPercent;
         case SESSION_LONDON:
            return LondonAllocationPercent;
         case SESSION_NEWYORK:
            return NYAllocationPercent;
         default:
            return 0;
        }
     }
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- Validate allocation settings first
   if(!ValidateAllocation())
     {
      Print("FATAL: Allocation validation failed! EA will not start.");
      return(INIT_FAILED);
     }

   //--- Build symbol list
   string list = Symbols;
   if(StringFind(list, _Symbol) < 0)
      list = list + "," + _Symbol;

   string parts[];
   int num = StringSplit(list, ',', parts);
   if(num <= 0)
     {
      Print("No symbols specified!");
      return(INIT_FAILED);
     }

   m_numSymbols = num;
   ArrayResize(m_symbols, m_numSymbols);
   ArrayResize(m_atrHandle, m_numSymbols);

   for(int i = 0; i < m_numSymbols; i++)
     {
      string sym = parts[i];
      StringTrimRight(sym);

      if(!SymbolSelect(sym, true))
        {
         Print("Failed to select symbol: ", sym);
         return(INIT_FAILED);
        }

      m_symbols[i].name = sym;
      m_symbols[i].sessionHigh = 0;
      m_symbols[i].sessionLow = 0;
      m_symbols[i].upperVolatilityStop = 0;
      m_symbols[i].lowerVolatilityStop = 0;
      m_symbols[i].highBreakoutTriggered = false;
      m_symbols[i].lowBreakoutTriggered = false;
      m_symbols[i].sessionStartTime = 0;
      m_symbols[i].lastTradeTime = 0;
      m_symbols[i].currentATR = 0;

      //--- Create ATR handle for each symbol
      m_atrHandle[i] = iATR(sym, PERIOD_M15, ATRPeriod);
      if(m_atrHandle[i] == INVALID_HANDLE)
        {
         Print("Failed to create ATR handle for ", sym);
         return(INIT_FAILED);
        }
     }

   //--- Get account balance
   double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);

   //--- Initialize daily risk
   m_dailyMaxRisk = accountBalance * (DailyCapitalPercent / 100.0);
   m_dailyRiskUsed = 0;
   m_lastResetDate = 0;
   m_dailyResetPrinted = false;
   m_dailyNetProfit = 0;
   m_lastProfitUpdate = 0;

   //--- Calculate session allocations
   double asianAllocPct = CalculateSessionAllocation(SESSION_ASIAN);
   double londonAllocPct = CalculateSessionAllocation(SESSION_LONDON);
   double nyAllocPct = CalculateSessionAllocation(SESSION_NEWYORK);

   //--- Setup session configurations with calculated allocations
   m_asianSession.type = SESSION_ASIAN;
   m_asianSession.allocationPercent = asianAllocPct;
   m_asianSession.maxRisk = m_dailyMaxRisk * (asianAllocPct / 100.0);
   m_asianSession.usedRisk = 0;
   m_asianSession.activeSymbols = AsianSymbols;
   m_asianSession.startTime = 0;
   m_asianSession.endTime = 0;
   m_asianSession.isActive = false;

   m_londonSession.type = SESSION_LONDON;
   m_londonSession.allocationPercent = londonAllocPct;
   m_londonSession.maxRisk = m_dailyMaxRisk * (londonAllocPct / 100.0);
   m_londonSession.usedRisk = 0;
   m_londonSession.activeSymbols = LondonSymbols;
   m_londonSession.startTime = 0;
   m_londonSession.endTime = 0;
   m_londonSession.isActive = false;

   m_nySession.type = SESSION_NEWYORK;
   m_nySession.allocationPercent = nyAllocPct;
   m_nySession.maxRisk = m_dailyMaxRisk * (nyAllocPct / 100.0);
   m_nySession.usedRisk = 0;
   m_nySession.activeSymbols = NYSymbols;
   m_nySession.startTime = 0;
   m_nySession.endTime = 0;
   m_nySession.isActive = false;

   m_currentSession.type = SESSION_OFF;
   m_currentSession.maxRisk = 0;
   m_currentSession.usedRisk = 0;
   m_currentSession.isActive = false;

   m_previousSession = SESSION_OFF;
   m_lastBarTime = 0;

   trade.SetExpertMagicNumber(MagicNumber);

   //--- Print initialization summary
   Print("═══════════════════════════════════════════");
   Print("SESSION BASED CAPITAL ALLOC EA Initialized");
   Print("═══════════════════════════════════════════");
   Print("Account Balance: ", DoubleToString(accountBalance, 2));
   Print("Daily Capital: ", DoubleToString(m_dailyMaxRisk, 2), " (", DailyCapitalPercent, "% of balance)");
   Print("Allocation Mode: ", UseEqualSplit ? "EQUAL SPLIT" : "MANUAL");
   Print("───────────────────────────────────────────");
   if(UseAsianSession)
      Print("Asian Session: ", DoubleToString(asianAllocPct, 1), "% (", DoubleToString(m_asianSession.maxRisk, 2), ")");
   if(UseLondonSession)
      Print("London Session: ", DoubleToString(londonAllocPct, 1), "% (", DoubleToString(m_londonSession.maxRisk, 2), ")");
   if(UseNewYorkSession)
      Print("NY Session: ", DoubleToString(nyAllocPct, 1), "% (", DoubleToString(m_nySession.maxRisk, 2), ")");
   Print("═══════════════════════════════════════════");

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i = 0; i < m_numSymbols; i++)
     {
      if(m_atrHandle[i] != INVALID_HANDLE)
         IndicatorRelease(m_atrHandle[i]);
     }
   ObjectsDeleteAll(0, "Session_");
   Comment("");
  }

//+------------------------------------------------------------------+
//| Tick function                                                    |
//+------------------------------------------------------------------+
void OnTick()
  {
   //--- Update daily net profit
   UpdateDailyNetProfit();

   //--- Reset daily risk at start of new day (ONCE per day)
   ResetDailyRisk();

   //--- Update ATR values for all symbols
   UpdateATRValues();

   //--- Session handling
   SessionType currentSessionType = GetCurrentSession();
   UpdateCurrentSession(currentSessionType);

   //--- Display session info on chart
   DisplaySessionInfo();

   //--- Draw session objects on chart
   DrawSessionObjects();

   //--- Detect session change and reset session state
   if(currentSessionType != m_previousSession)
     {
      OnSessionChange(currentSessionType);
      m_previousSession = currentSessionType;
     }

   if(m_currentSession.type == SESSION_OFF)
      return;

   //--- Update session ranges for all symbols
   for(int i = 0; i < m_numSymbols; i++)
     {
      UpdateSessionRange(i);
     }

   //--- Check for breakouts on all active symbols
   for(int i = 0; i < m_numSymbols; i++)
     {
      string sym = m_symbols[i].name;

      //--- Session activation check
      if(!IsSymbolActive(sym, m_currentSession.type))
         continue;

      //--- Check for breakouts using enhanced logic
      CheckForBreakouts(i);
     }
  }

//+------------------------------------------------------------------+
//| Update daily net profit from historical deals                    |
//+------------------------------------------------------------------+
void UpdateDailyNetProfit()
  {
   //--- Update every minute or when there's a new deal
   datetime now = TimeCurrent();
   if(now - m_lastProfitUpdate < 60 && m_lastProfitUpdate > 0)
      return;

   m_lastProfitUpdate = now;
   m_dailyNetProfit = GetDailyNetProfit();
  }

//+------------------------------------------------------------------+
//| Get daily net profit                                             |
//+------------------------------------------------------------------+
double GetDailyNetProfit()
  {
   double profit = 0.0;

   datetime todayStart;
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);

   dt.hour = 0;
   dt.min  = 0;
   dt.sec  = 0;

   todayStart = StructToTime(dt);

   if(!HistorySelect(todayStart, TimeCurrent()))
     {
      return 0;
     }

   for(int i = 0; i < HistoryDealsTotal(); i++)
     {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0)
         continue;

      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != MagicNumber)
         continue;

      double dealProfit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
      double dealCommission = HistoryDealGetDouble(ticket, DEAL_COMMISSION);
      double dealSwap = HistoryDealGetDouble(ticket, DEAL_SWAP);

      profit += dealProfit + dealCommission + dealSwap;
     }

   return profit;
  }

//+------------------------------------------------------------------+
//| Reset daily risk at start of new trading day (ONCE per day)      |
//+------------------------------------------------------------------+
void ResetDailyRisk()
  {
   datetime now = TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now, dt);

   //--- Set to midnight of current day for comparison
   MqlDateTime todayDt;
   TimeToStruct(now, todayDt);
   todayDt.hour = 0;
   todayDt.min = 0;
   todayDt.sec = 0;
   datetime todayStart = StructToTime(todayDt);

   //--- Check if we need to reset (new day detected)
   if(m_lastResetDate == 0)
     {
      m_lastResetDate = todayStart;
      m_dailyResetPrinted = false;
      return;
     }

   //--- If last reset date is before today's start, we need to reset
   if(m_lastResetDate < todayStart)
     {
      double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);

      //--- Reset daily tracking
      m_dailyRiskUsed = 0;
      m_dailyMaxRisk = accountBalance * (DailyCapitalPercent / 100.0);

      //--- Recalculate session allocations based on current balance
      double asianAllocPct = CalculateSessionAllocation(SESSION_ASIAN);
      double londonAllocPct = CalculateSessionAllocation(SESSION_LONDON);
      double nyAllocPct = CalculateSessionAllocation(SESSION_NEWYORK);

      //--- Reset session risks with updated values
      m_asianSession.maxRisk = m_dailyMaxRisk * (asianAllocPct / 100.0);
      m_asianSession.usedRisk = 0;
      m_asianSession.allocationPercent = asianAllocPct;

      m_londonSession.maxRisk = m_dailyMaxRisk * (londonAllocPct / 100.0);
      m_londonSession.usedRisk = 0;
      m_londonSession.allocationPercent = londonAllocPct;

      m_nySession.maxRisk = m_dailyMaxRisk * (nyAllocPct / 100.0);
      m_nySession.usedRisk = 0;
      m_nySession.allocationPercent = nyAllocPct;

      //--- Update current session max risk if active
      if(m_currentSession.type != SESSION_OFF)
        {
         switch(m_currentSession.type)
           {
            case SESSION_ASIAN:
               m_currentSession.maxRisk = m_asianSession.maxRisk;
               break;
            case SESSION_LONDON:
               m_currentSession.maxRisk = m_londonSession.maxRisk;
               break;
            case SESSION_NEWYORK:
               m_currentSession.maxRisk = m_nySession.maxRisk;
               break;
           }
        }

      m_lastResetDate = todayStart;
      m_dailyResetPrinted = false;

      //--- Print reset message only once
      if(!m_dailyResetPrinted)
        {
         Print("═══════════════════════════════════════════");
         Print("        DAILY RISK RESET - NEW DAY         ");
         Print("═══════════════════════════════════════════");
         Print("Account Balance: ", DoubleToString(accountBalance, 2));
         Print("New Daily Max Risk: ", DoubleToString(m_dailyMaxRisk, 2), " (", DailyCapitalPercent, "% of balance)");
         Print("Allocation Mode: ", UseEqualSplit ? "EQUAL SPLIT" : "MANUAL");
         Print("Asian Session Max: ", DoubleToString(m_asianSession.maxRisk, 2), " (", DoubleToString(asianAllocPct, 1), "%)");
         Print("London Session Max: ", DoubleToString(m_londonSession.maxRisk, 2), " (", DoubleToString(londonAllocPct, 1), "%)");
         Print("NY Session Max: ", DoubleToString(m_nySession.maxRisk, 2), " (", DoubleToString(nyAllocPct, 1), "%)");
         Print("═══════════════════════════════════════════");
         m_dailyResetPrinted = true;
        }
     }
  }

//+------------------------------------------------------------------+
//| Update risk used after trade execution                           |
//+------------------------------------------------------------------+
void UpdateRiskUsed(int index, double lot, int slPips, double pipValue)
  {
   double tradeRisk = lot * slPips * pipValue;

   //--- Update session risk
   m_currentSession.usedRisk += tradeRisk;

   //--- Update session specific risk based on session type
   switch(m_currentSession.type)
     {
      case SESSION_ASIAN:
         m_asianSession.usedRisk += tradeRisk;
         break;
      case SESSION_LONDON:
         m_londonSession.usedRisk += tradeRisk;
         break;
      case SESSION_NEWYORK:
         m_nySession.usedRisk += tradeRisk;
         break;
     }

   //--- Update daily risk
   m_dailyRiskUsed += tradeRisk;

   Print("═══════════════════════════════════════════");
   Print("RISK UPDATED AFTER TRADE:");
   Print("Trade Risk: ", DoubleToString(tradeRisk, 2));
   Print("Session Risk Used: ", DoubleToString(m_currentSession.usedRisk, 2), "/", DoubleToString(m_currentSession.maxRisk, 2));
   Print("Daily Risk Used: ", DoubleToString(m_dailyRiskUsed, 2), "/", DoubleToString(m_dailyMaxRisk, 2));
   Print("═══════════════════════════════════════════");
  }

//+------------------------------------------------------------------+
//| Update ATR values for all symbols                                |
//+------------------------------------------------------------------+
void UpdateATRValues()
  {
   for(int i = 0; i < m_numSymbols; i++)
     {
      double atr[1];
      if(CopyBuffer(m_atrHandle[i], 0, 0, 1, atr) > 0)
        {
         m_symbols[i].currentATR = atr[0];
        }
     }
  }

//+------------------------------------------------------------------+
//| Enhanced breakout checking logic                                 |
//+------------------------------------------------------------------+
void CheckForBreakouts(int index)
  {
   string sym = m_symbols[index].name;

   //--- Get current bid/ask
   double bid = SymbolInfoDouble(sym, SYMBOL_BID);
   double ask = SymbolInfoDouble(sym, SYMBOL_ASK);

   //--- Check if session has formed enough (optional)
   if(RequireSessionFormation)
     {
      datetime now = TimeCurrent();
      int minutesSinceStart = (int)((now - m_symbols[index].sessionStartTime) / 60);
      if(minutesSinceStart < SessionFormationMinutes)
         return;
     }

   //--- Calculate volatility stops
   if(UseVolatilityStop && m_symbols[index].currentATR > 0)
     {
      m_symbols[index].upperVolatilityStop = m_symbols[index].sessionHigh + (m_symbols[index].currentATR * ATRMultiplier);
      m_symbols[index].lowerVolatilityStop = m_symbols[index].sessionLow - (m_symbols[index].currentATR * ATRMultiplier);
     }
   else
     {
      //--- Fallback: use session range * 0.5 as volatility stop
      double range = m_symbols[index].sessionHigh - m_symbols[index].sessionLow;
      m_symbols[index].upperVolatilityStop = m_symbols[index].sessionHigh + (range * 0.5);
      m_symbols[index].lowerVolatilityStop = m_symbols[index].sessionLow - (range * 0.5);
     }

   //--- Check for HIGH breakout (price breaks above session high)
   if(!m_symbols[index].highBreakoutTriggered && ask >= m_symbols[index].sessionHigh)
     {
      m_symbols[index].highBreakoutTriggered = true;
      m_symbols[index].lastTradeTime = TimeCurrent();

      //--- Check if price has cleared volatility stop (genuine breakout)
      if(UseVolatilityStop && ask >= m_symbols[index].upperVolatilityStop)
        {
         Print("GENUINE HIGH breakout on ", sym, " - GOING LONG");
         ExecuteBreakoutTrade(index, ORDER_TYPE_BUY, "Genuine High Breakout - Long");
        }
      else
        {
         Print("FALSE HIGH breakout on ", sym, " - FADING SHORT");
         ExecuteBreakoutTrade(index, ORDER_TYPE_SELL, "False High Breakout - Fade Short");
        }
     }

   //--- Check for LOW breakout (price breaks below session low)
   if(!m_symbols[index].lowBreakoutTriggered && bid <= m_symbols[index].sessionLow)
     {
      m_symbols[index].lowBreakoutTriggered = true;
      m_symbols[index].lastTradeTime = TimeCurrent();

      //--- Check if price has cleared volatility stop (genuine breakout)
      if(UseVolatilityStop && bid <= m_symbols[index].lowerVolatilityStop)
        {
         Print("GENUINE LOW breakout on ", sym, " - GOING SHORT");
         ExecuteBreakoutTrade(index, ORDER_TYPE_SELL, "Genuine Low Breakout - Short");
        }
      else
        {
         Print("FALSE LOW breakout on ", sym, " - FADING LONG");
         ExecuteBreakoutTrade(index, ORDER_TYPE_BUY, "False Low Breakout - Fade Long");
        }
     }
  }

//+------------------------------------------------------------------+
//| Execute breakout trade                                           |
//+------------------------------------------------------------------+
void ExecuteBreakoutTrade(int index, ENUM_ORDER_TYPE direction, string reason)
  {
   string sym = m_symbols[index].name;

   //--- Check if already have a position
   if(PositionSelect(sym))
     {
      Print("Already have position on ", sym, " - skipping");
      return;
     }

   //--- Check if we still have risk budget for this session
   if(m_currentSession.usedRisk >= m_currentSession.maxRisk)
     {
      Print("Session risk limit reached. Used: ", m_currentSession.usedRisk, " Max: ", m_currentSession.maxRisk);
      return;
     }

   //--- Calculate remaining risk for this trade
   double remainingRisk = m_currentSession.maxRisk - m_currentSession.usedRisk;

   //--- Calculate stop loss in pips
   int slPips = GetStopLossPips(index);
   if(slPips <= 0)
      slPips = StopLoss_Pips_Fallback;

   //--- Calculate lot size based on available risk
   double pipValue = GetPipValue(sym);
   if(pipValue <= 0)
      return;

   double lot = remainingRisk / (slPips * pipValue);
   lot = NormalizeDouble(lot, 2);
   lot = MathMax(lot, SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN));
   lot = MathMin(lot, SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX));

   if(lot <= 0)
     {
      Print("Lot size too small for ", sym);
      return;
     }

   //--- Calculate SL and TP prices
   double price, slPrice, tpPrice;
   double pipSize = GetPipSize(sym);

   if(direction == ORDER_TYPE_BUY)
     {
      price = SymbolInfoDouble(sym, SYMBOL_ASK);
      slPrice = price - slPips * pipSize;

      if(UseDynamicTP)
         tpPrice = price + (slPips * TakeProfitRR) * pipSize;
      else
         tpPrice = price + TakeProfit_Pips_Fallback * pipSize;

      Print("═══════════════════════════════════════════");
      Print("BUY on ", sym, " - ", reason);
      Print("Lot: ", lot, " SL: ", slPips, "pips TP: ", (UseDynamicTP ? TakeProfitRR * slPips : TakeProfit_Pips_Fallback), "pips");
      Print("═══════════════════════════════════════════");

      if(trade.Buy(lot, sym, price, slPrice, tpPrice, "Session Breakout - " + reason))
        {
         Print("BUY executed successfully");
         UpdateRiskUsed(index, lot, slPips, pipValue);
        }
      else
         Print("BUY failed. Error: ", GetLastError());
     }
   else
      if(direction == ORDER_TYPE_SELL)
        {
         price = SymbolInfoDouble(sym, SYMBOL_BID);
         slPrice = price + slPips * pipSize;

         if(UseDynamicTP)
            tpPrice = price - (slPips * TakeProfitRR) * pipSize;
         else
            tpPrice = price - TakeProfit_Pips_Fallback * pipSize;

         Print("═══════════════════════════════════════════");
         Print("SELL on ", sym, " - ", reason);
         Print("Lot: ", lot, " SL: ", slPips, "pips TP: ", (UseDynamicTP ? TakeProfitRR * slPips : TakeProfit_Pips_Fallback), "pips");
         Print("═══════════════════════════════════════════");

         if(trade.Sell(lot, sym, price, slPrice, tpPrice, "Session Breakout - " + reason))
           {
            Print("SELL executed successfully");
            UpdateRiskUsed(index, lot, slPips, pipValue);
           }
         else
            Print("SELL failed. Error: ", GetLastError());
        }
  }

//+------------------------------------------------------------------+
//| Get stop loss in pips based on ATR or range                      |
//+------------------------------------------------------------------+
int GetStopLossPips(int index)
  {
   double pipSize = GetPipSize(m_symbols[index].name);

   if(UseVolatilityStop && m_symbols[index].currentATR > 0)
     {
      int slPips = (int)((m_symbols[index].currentATR * StopLossATRMultiplier) / pipSize);
      if(slPips >= 10)
         return slPips;
     }

   //--- Fallback to range-based SL
   double range = m_symbols[index].sessionHigh - m_symbols[index].sessionLow;
   if(range > 0 && pipSize > 0)
     {
      int slPips = (int)((range * 0.5) / pipSize);
      if(slPips >= 10)
         return slPips;
     }

   return StopLoss_Pips_Fallback;
  }

//+------------------------------------------------------------------+
//| Update session range for a symbol                                |
//+------------------------------------------------------------------+
void UpdateSessionRange(int index)
  {
   string sym = m_symbols[index].name;

   double highs[], lows[];
   ArrayResize(highs, 0);
   ArrayResize(lows, 0);
   ArraySetAsSeries(highs, true);
   ArraySetAsSeries(lows, true);

   //--- Get high/low data for the range period
   if(CopyHigh(sym, PERIOD_M15, 1, SessionRangeBars, highs) <= 0)
      return;

   if(CopyLow(sym, PERIOD_M15, 1, SessionRangeBars, lows) <= 0)
      return;

   //--- Find highest high and lowest low
   double maxH = highs[0];
   double minL = lows[0];

   for(int i = 1; i < ArraySize(highs); i++)
     {
      if(highs[i] > maxH)
         maxH = highs[i];
      if(lows[i] < minL)
         minL = lows[i];
     }

   //--- Only update if not already triggered (preserve breakout state)
   if(!m_symbols[index].highBreakoutTriggered)
      m_symbols[index].sessionHigh = maxH;

   if(!m_symbols[index].lowBreakoutTriggered)
      m_symbols[index].sessionLow = minL;
  }

//+------------------------------------------------------------------+
//| Handle session change                                            |
//+------------------------------------------------------------------+
void OnSessionChange(SessionType newSession)
  {
   Print("═══════════════════════════════════════════");
   Print("Session changed to: ", EnumToString(newSession));
   Print("═══════════════════════════════════════════");

   //--- Reset breakout triggers for all symbols for the new session
   for(int i = 0; i < m_numSymbols; i++)
     {
      m_symbols[i].highBreakoutTriggered = false;
      m_symbols[i].lowBreakoutTriggered = false;
      m_symbols[i].sessionStartTime = TimeCurrent();
     }

   //--- Close losing positions from previous session
   CloseLosingPositionsFromPreviousSession();
  }

//+------------------------------------------------------------------+
//| Update current session info                                      |
//+------------------------------------------------------------------+
void UpdateCurrentSession(SessionType sessionType)
  {
   datetime now = TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now, dt);

   switch(sessionType)
     {
      case SESSION_ASIAN:
         m_currentSession = m_asianSession;
         dt.hour = AsianStart;
         dt.min = 0;
         dt.sec = 0;
         m_currentSession.startTime = StructToTime(dt);
         dt.hour = AsianEnd;
         m_currentSession.endTime = StructToTime(dt);
         m_currentSession.isActive = true;
         break;
      case SESSION_LONDON:
         m_currentSession = m_londonSession;
         dt.hour = LondonStart;
         dt.min = 0;
         dt.sec = 0;
         m_currentSession.startTime = StructToTime(dt);
         dt.hour = LondonEnd;
         m_currentSession.endTime = StructToTime(dt);
         m_currentSession.isActive = true;
         break;
      case SESSION_NEWYORK:
         m_currentSession = m_nySession;
         dt.hour = NYStart;
         dt.min = 0;
         dt.sec = 0;
         m_currentSession.startTime = StructToTime(dt);
         dt.hour = NYEnd;
         m_currentSession.endTime = StructToTime(dt);
         m_currentSession.isActive = true;
         break;
      default:
         m_currentSession.type = SESSION_OFF;
         m_currentSession.maxRisk = 0;
         m_currentSession.usedRisk = 0;
         m_currentSession.isActive = false;
         break;
     }
  }

//+------------------------------------------------------------------+
//| Session detection                                                |
//+------------------------------------------------------------------+
SessionType GetCurrentSession()
  {
   datetime now = TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(now, dt);
   int hour = dt.hour;

   if(UseAsianSession && hour >= AsianStart && hour < AsianEnd)
      return SESSION_ASIAN;
   if(UseLondonSession && hour >= LondonStart && hour < LondonEnd)
      return SESSION_LONDON;
   if(UseNewYorkSession && hour >= NYStart && hour < NYEnd)
      return SESSION_NEWYORK;
   return SESSION_OFF;
  }

//+------------------------------------------------------------------+
//| Check if symbol is active during current session                 |
//+------------------------------------------------------------------+
bool IsSymbolActive(string symbol, SessionType session)
  {
   string activeList = "";
   switch(session)
     {
      case SESSION_ASIAN:
         activeList = AsianSymbols;
         break;
      case SESSION_LONDON:
         activeList = LondonSymbols;
         break;
      case SESSION_NEWYORK:
         activeList = NYSymbols;
         break;
      default:
         return false;
     }

   string parts[];
   int count = StringSplit(activeList, ',', parts);
   for(int i = 0; i < count; i++)
     {
      string sym = parts[i];
      StringTrimRight(sym);
      if(sym == symbol)
         return true;
     }
   return false;
  }


//+------------------------------------------------------------------+
//| Display session info on chart                                    |
//+------------------------------------------------------------------+
void DisplaySessionInfo()
  {
   string sessionName = "";
   double allocPercent = 0;
   double usedRisk = 0;
   double maxRisk = 0;

   if(m_currentSession.type == SESSION_OFF)
     {
      Comment("NO ACTIVE SESSION");
      return;
     }

   switch(m_currentSession.type)
     {
      case SESSION_ASIAN:
         sessionName = "ASIAN";
         allocPercent = m_asianSession.allocationPercent;
         break;
      case SESSION_LONDON:
         sessionName = "LONDON";
         allocPercent = m_londonSession.allocationPercent;
         break;
      case SESSION_NEWYORK:
         sessionName = "NEW YORK";
         allocPercent = m_nySession.allocationPercent;
         break;
     }

   usedRisk = m_currentSession.usedRisk;
   maxRisk  = m_currentSession.maxRisk;

   double sessionPct = (maxRisk > 0) ? (usedRisk / maxRisk) * 100 : 0;
   double sessionAccountPct = (AccountInfoDouble(ACCOUNT_BALANCE) > 0) ? (usedRisk / AccountInfoDouble(ACCOUNT_BALANCE)) * 100 : 0;

   double dailyPct = (m_dailyMaxRisk > 0) ? (m_dailyRiskUsed / m_dailyMaxRisk) * 100 : 0;
   double dailyAccountPct = (AccountInfoDouble(ACCOUNT_BALANCE) > 0) ? (m_dailyRiskUsed / AccountInfoDouble(ACCOUNT_BALANCE)) * 100 : 0;

   string profitSign = (m_dailyNetProfit >= 0) ? "+" : "";

   string info = "";
   info += "═══════════════════════════════════════════\n";
   info += "   SESSION BASED CAPITAL ALLOCATION EA\n";
   info += "═══════════════════════════════════════════\n";
   info += "Session: " + sessionName + "\n";
   info += "Mode: " + (UseEqualSplit ? "EQUAL SPLIT" : "MANUAL") + "\n";
   info += "───────────────────────────────────────────\n";
   info += "Daily Net PnL: " + profitSign + DoubleToString(m_dailyNetProfit, 2) + "\n";
   info += "Daily Budget: " + DoubleToString(DailyCapitalPercent, 1) + "%\n";
   info += "Used: " + DoubleToString(dailyPct, 1) + "% of daily\n";
   info += "Exposure: " + DoubleToString(dailyAccountPct, 2) + "% account\n";
   info += "───────────────────────────────────────────\n";
   info += "Session Budget: " + DoubleToString(allocPercent, 1) + "%\n";
   info += "Used: " + DoubleToString(sessionPct, 1) + "% of session\n";
   info += "Exposure: " + DoubleToString(sessionAccountPct, 2) + "% account\n";
   info += "───────────────────────────────────────────\n";
   info += "Symbols: " + m_currentSession.activeSymbols + "\n";
   info += "═══════════════════════════════════════════";

   Comment(info);
  }

//+------------------------------------------------------------------+
//| Draw session objects on chart                                    |
//+------------------------------------------------------------------+
void DrawSessionObjects()
  {
   if(m_currentSession.type == SESSION_OFF)
      return;

   int chartIndex = GetSymbolIndex(_Symbol);
   if(chartIndex < 0)
      return;

   //--- Draw session high line
   string highLineName = "Session_High";
   ObjectDelete(0, highLineName);
   if(m_symbols[chartIndex].sessionHigh > 0)
     {
      ObjectCreate(0, highLineName, OBJ_HLINE, 0, 0, m_symbols[chartIndex].sessionHigh);
      ObjectSetInteger(0, highLineName, OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0, highLineName, OBJPROP_STYLE, STYLE_DASH);
      ObjectSetInteger(0, highLineName, OBJPROP_WIDTH, 2);
     }

   //--- Draw session low line
   string lowLineName = "Session_Low";
   ObjectDelete(0, lowLineName);
   if(m_symbols[chartIndex].sessionLow > 0)
     {
      ObjectCreate(0, lowLineName, OBJ_HLINE, 0, 0, m_symbols[chartIndex].sessionLow);
      ObjectSetInteger(0, lowLineName, OBJPROP_COLOR, clrBlue);
      ObjectSetInteger(0, lowLineName, OBJPROP_STYLE, STYLE_DASH);
      ObjectSetInteger(0, lowLineName, OBJPROP_WIDTH, 2);
     }

   //--- Draw volatility stops if enabled
   if(UseVolatilityStop)
     {
      string upperStopName = "Upper_Vol_Stop";
      ObjectDelete(0, upperStopName);
      if(m_symbols[chartIndex].upperVolatilityStop > 0)
        {
         ObjectCreate(0, upperStopName, OBJ_HLINE, 0, 0, m_symbols[chartIndex].upperVolatilityStop);
         ObjectSetInteger(0, upperStopName, OBJPROP_COLOR, clrOrange);
         ObjectSetInteger(0, upperStopName, OBJPROP_STYLE, STYLE_DOT);
         ObjectSetInteger(0, upperStopName, OBJPROP_WIDTH, 1);
        }

      string lowerStopName = "Lower_Vol_Stop";
      ObjectDelete(0, lowerStopName);
      if(m_symbols[chartIndex].lowerVolatilityStop > 0)
        {
         ObjectCreate(0, lowerStopName, OBJ_HLINE, 0, 0, m_symbols[chartIndex].lowerVolatilityStop);
         ObjectSetInteger(0, lowerStopName, OBJPROP_COLOR, clrOrange);
         ObjectSetInteger(0, lowerStopName, OBJPROP_STYLE, STYLE_DOT);
         ObjectSetInteger(0, lowerStopName, OBJPROP_WIDTH, 1);
        }
     }

   //--- Draw session start time line
   if(m_currentSession.startTime > 0)
     {
      string startLineName = "Session_Start";
      ObjectDelete(0, startLineName);
      ObjectCreate(0, startLineName, OBJ_VLINE, 0, m_currentSession.startTime, 0);
      ObjectSetInteger(0, startLineName, OBJPROP_COLOR, clrGreen);
      ObjectSetInteger(0, startLineName, OBJPROP_WIDTH, 1);
     }

   //--- Draw session end time line
   if(m_currentSession.endTime > 0)
     {
      string endLineName = "Session_End";
      ObjectDelete(0, endLineName);
      ObjectCreate(0, endLineName, OBJ_VLINE, 0, m_currentSession.endTime, 0);
      ObjectSetInteger(0, endLineName, OBJPROP_COLOR, clrRed);
      ObjectSetInteger(0, endLineName, OBJPROP_WIDTH, 1);
     }
  }

//+------------------------------------------------------------------+
//| Close losing positions from previous session                     |
//+------------------------------------------------------------------+
void CloseLosingPositionsFromPreviousSession()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
        {
         if(PositionGetInteger(POSITION_MAGIC) != MagicNumber)
            continue;

         double profit = PositionGetDouble(POSITION_PROFIT);

         if(profit < 0)
           {
            trade.PositionClose(ticket);
            Print("Closed losing position. Ticket: ", ticket, " Profit: ", profit);
           }
         else
           {
            Print("Keeping profitable position. Ticket: ", ticket, " Profit: ", profit);
           }
        }
     }
  }


//+------------------------------------------------------------------+
//| Get symbol index by name                                         |
//+------------------------------------------------------------------+
int GetSymbolIndex(string symbol)
  {
   for(int i = 0; i < m_numSymbols; i++)
     {
      if(m_symbols[i].name == symbol)
         return i;
     }
   return -1;
  }

//+------------------------------------------------------------------+
//| Get pip value                                                    |
//+------------------------------------------------------------------+
double GetPipValue(string symbol)
  {
   double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   double pipSize = GetPipSize(symbol);

   if(tickSize == 0.0)
      return 0.0;

   return tickValue * (pipSize / tickSize);
  }

//+------------------------------------------------------------------+
//| Get pip size for any instrument                                  |
//+------------------------------------------------------------------+
double GetPipSize(string symbol)
  {
   int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);

   if(StringFind(symbol, "JPY") != -1)
     {
      if(digits == 3)
         return point * 10;
      else
         return point;
     }
   else
      if(StringFind(symbol, "XAU") != -1 || StringFind(symbol, "GOLD") != -1)
        {
         return 0.10;
        }
      else
         if(StringFind(symbol, "XAG") != -1 || StringFind(symbol, "SILVER") != -1)
           {
            return 0.01;
           }
         else
            if(StringFind(symbol, "BTC") != -1 || StringFind(symbol, "ETH") != -1)
              {
               return point * 100.0;
              }
            else
               if(StringFind(symbol, "US") != -1 && digits <= 2)
                 {
                  return point;
                 }
               else
                  if(digits == 3 || digits == 5)
                    {
                     return point * 10;
                    }

   return point;
  }
//+------------------------------------------------------------------+
