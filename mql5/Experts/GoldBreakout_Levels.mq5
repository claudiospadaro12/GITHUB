//+------------------------------------------------------------------+
//|                                       GoldBreakout_Levels.mq5     |
//|  EA #2 per XAUUSD (oro) su H1 — breakout da livelli chiave.       |
//|                                                                  |
//|  STRATEGIA (dall'eBook dell'utente, parte oggettiva):            |
//|   - SETUP: il prezzo forma un CONSOLIDAMENTO (range stretto di   |
//|     N candele) vicino a un LIVELLO CHIAVE (open D/W, max/min     |
//|     giorno prec., pivot, numeri tondi).                         |
//|   - INGRESSO: rottura immediata "al tocco" del box di           |
//|     consolidamento (long sopra il massimo, short sotto il min). |
//|   - SL: oltre il massimo/minimo assoluto del consolidamento.    |
//|   - USCITA: trailing in ATR, si lascia correre (niente TP fisso).|
//|   - Rischio % per trade, una posizione per volta.               |
//|                                                                  |
//|  Scorrelato dall'EA Ichimoku (timeframe H1 vs M5, logica        |
//|  breakout vs incrocio). DA VALIDARE su backtest multi-anno +    |
//|  forward demo prima del reale.                                  |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro"
#property version   "1.10"
#property strict

#include <Trade/Trade.mqh>
CTrade trade;

//--- Consolidamento (setup)
input group "=== Consolidamento ==="
input int    InpConsolBars   = 5;    // Candele del consolidamento (box)
input double InpConsolMaxATR  = 1.2; // Range del box <= X x ATR (piu' basso = piu' stretto)

//--- Livelli chiave (confluenza)
input group "=== Livelli chiave ==="
input bool   InpRequireLevel = true; // Il box deve essere vicino a un livello chiave
input double InpLevelDistATR  = 0.5; // Distanza max box-livello = X x ATR
input bool   InpUseDWOpen     = true;// Open Giornaliero + Settimanale
input bool   InpUsePDHL       = true;// Max/Min giorno precedente
input bool   InpUsePivot      = true;// Pivot di giornata (PP, R1/2, S1/2)
input bool   InpUseRound      = true;// Numeri tondi
input double InpRoundStep      = 25.0;// Passo numeri tondi ($)

//--- Filtro di trend (timeframe superiore)
input group "=== Filtro di trend ==="
input bool         InpUseTrendFilter = true;      // Breakout solo nella direzione del trend
input ENUM_TIMEFRAMES InpTrendTF     = PERIOD_H4; // Time frame del trend
input int          InpTrendMAPeriod  = 50;        // Periodo EMA del trend

//--- Rischio e gestione
input group "=== Rischio e gestione (ATR) ==="
input int    InpATRPeriod      = 14;  // Periodo ATR
input double InpSL_BufferATR   = 0.2; // SL oltre il box di X x ATR
input double InpATR_TrailStart = 1.0; // Il trailing parte dopo +X x ATR
input double InpATR_Trail      = 3.0; // Distanza del trailing = X x ATR
input double InpRiskPercent    = 0.50;// Rischio per trade (% del capitale)

//--- Generali
input group "=== Generali ==="
input long   InpMagic     = 250611;   // Numero magico (diverso dall'EA oro)
input int    InpMaxSpread = 50;       // Spread massimo (punti); 0 = nessun limite

int      hATR        = INVALID_HANDLE;
int      hTrend      = INVALID_HANDLE;
datetime lastBarTime = 0;
bool     g_armed     = false;   // setup pronto, in attesa della rottura
double   g_boxHigh   = 0;
double   g_boxLow    = 0;

//+------------------------------------------------------------------+
int OnInit()
  {
   hATR   = iATR(_Symbol, _Period, InpATRPeriod);
   hTrend = iMA(_Symbol, InpTrendTF, InpTrendMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
   if(hATR == INVALID_HANDLE || hTrend == INVALID_HANDLE)
     { Print("ERRORE: handle indicatori non creati."); return(INIT_FAILED); }

   trade.SetExpertMagicNumber(InpMagic);
   trade.SetTypeFillingBySymbol(_Symbol);
   Print("GoldBreakout_Levels avviato su ", _Symbol, " ",
         EnumToString((ENUM_TIMEFRAMES)_Period));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hATR   != INVALID_HANDLE) IndicatorRelease(hATR);
   if(hTrend != INVALID_HANDLE) IndicatorRelease(hTrend);
  }

//+------------------------------------------------------------------+
//| Filtro trend: il prezzo e' dalla parte giusta dell'EMA superiore |
//+------------------------------------------------------------------+
bool TrendOk(int dir)
  {
   if(!InpUseTrendFilter) return(true);
   double ema[1];
   if(CopyBuffer(hTrend, 0, 0, 1, ema) < 1) return(false);
   double px = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(dir > 0) return(px > ema[0]);
   if(dir < 0) return(px < ema[0]);
   return(false);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   //--- trailing a ogni tick
   ManageTrailing();

   //--- ingresso "al tocco": controllato a ogni tick mentre il setup e' armato
   if(g_armed && !HasOpenPosition() && SpreadOK())
     {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      if(ask >= g_boxHigh && TrendOk(+1))     { OpenTrade(ORDER_TYPE_BUY);  g_armed = false; }
      else if(bid <= g_boxLow && TrendOk(-1)) { OpenTrade(ORDER_TYPE_SELL); g_armed = false; }
     }

   //--- rivalutazione del setup: solo a nuova candela
   if(!IsNewBar())
      return;

   if(HasOpenPosition())
     { g_armed = false; return; }

   EvaluateSetup();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if(t != lastBarTime) { lastBarTime = t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
double ATRvalue()
  {
   double atr[1];
   if(CopyBuffer(hATR, 0, 1, 1, atr) < 1) return(0);
   return(atr[0]);
  }

//+------------------------------------------------------------------+
//| Valuta il setup: consolidamento stretto + vicino a un livello    |
//+------------------------------------------------------------------+
void EvaluateSetup()
  {
   g_armed = false;
   double atr = ATRvalue();
   if(atr <= 0) return;

   //--- box = max/min delle ultime N candele chiuse
   double boxHigh = -DBL_MAX, boxLow = DBL_MAX;
   for(int i = 1; i <= InpConsolBars; i++)
     {
      double hi = iHigh(_Symbol, _Period, i);
      double lo = iLow(_Symbol, _Period, i);
      if(hi > boxHigh) boxHigh = hi;
      if(lo < boxLow)  boxLow  = lo;
     }
   double range = boxHigh - boxLow;
   if(range <= 0) return;

   //--- consolidamento "stretto"?
   if(range > InpConsolMaxATR * atr) return;

   //--- confluenza con un livello chiave
   if(InpRequireLevel && !NearLevel(boxLow, boxHigh, atr)) return;

   //--- il prezzo deve essere ANCORA dentro il box (non gia' rotto)
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask >= boxHigh || bid <= boxLow) return;

   g_boxHigh = boxHigh;
   g_boxLow  = boxLow;
   g_armed   = true;
  }

//+------------------------------------------------------------------+
//| Il box e' vicino ad almeno un livello chiave?                    |
//+------------------------------------------------------------------+
bool NearLevel(double boxLow, double boxHigh, double atr)
  {
   double tol = InpLevelDistATR * atr;
   double lv[];
   ArrayResize(lv, 32);
   int n = 0;

   if(InpUseDWOpen)
     {
      lv[n++] = iOpen(_Symbol, PERIOD_D1, 0);
      lv[n++] = iOpen(_Symbol, PERIOD_W1, 0);
     }
   if(InpUsePDHL || InpUsePivot)
     {
      double pdh = iHigh (_Symbol, PERIOD_D1, 1);
      double pdl = iLow  (_Symbol, PERIOD_D1, 1);
      double pdc = iClose(_Symbol, PERIOD_D1, 1);
      if(InpUsePDHL)
        { lv[n++] = pdh; lv[n++] = pdl; }
      if(InpUsePivot)
        {
         double pp = (pdh + pdl + pdc) / 3.0;
         lv[n++] = pp;
         lv[n++] = 2*pp - pdl;       // R1
         lv[n++] = 2*pp - pdh;       // S1
         lv[n++] = pp + (pdh - pdl); // R2
         lv[n++] = pp - (pdh - pdl); // S2
        }
     }
   if(InpUseRound)
     {
      double mid  = (boxHigh + boxLow) / 2.0;
      double base = MathRound(mid / InpRoundStep) * InpRoundStep;
      for(int k = -2; k <= 2; k++)
         lv[n++] = base + k * InpRoundStep;
     }

   for(int i = 0; i < n; i++)
     {
      double L = lv[i];
      if(L <= 0) continue;
      if(L >= boxLow - tol && L <= boxHigh + tol) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Apre la posizione di breakout con SL oltre il box                |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
  {
   double atr = ATRvalue();
   if(atr <= 0) return;

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double price = (type == ORDER_TYPE_BUY) ? ask : bid;

   double sl = (type == ORDER_TYPE_BUY)
               ? g_boxLow  - InpSL_BufferATR * atr
               : g_boxHigh + InpSL_BufferATR * atr;

   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   sl    = NormalizeDouble(sl, digits);
   price = NormalizeDouble(price, digits);

   double slDist = MathAbs(price - sl);
   if(slDist <= 0) return;

   double lot = CalcLotByRisk(slDist);
   if(lot <= 0) return;

   bool ok;
   if(type == ORDER_TYPE_BUY)
      ok = trade.Buy(lot, _Symbol, price, sl, 0, "Breakout long");
   else
      ok = trade.Sell(lot, _Symbol, price, sl, 0, "Breakout short");

   if(!ok)
      Print("Apertura ordine FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
double CalcLotByRisk(double slDistancePrice)
  {
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickValue <= 0) return(0);

   double lossPerLot = (slDistancePrice / tickSize) * tickValue;
   if(lossPerLot <= 0) return(0);

   double lot = riskMoney / lossPerLot;

   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));
   return(lot);
  }

//+------------------------------------------------------------------+
//| Trailing dinamico in ATR (unica gestione dell'uscita)            |
//+------------------------------------------------------------------+
void ManageTrailing()
  {
   if(!PositionSelect(_Symbol)) return;
   if(PositionGetInteger(POSITION_MAGIC) != InpMagic) return;

   double atr = ATRvalue();
   if(atr <= 0) return;

   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   long   type   = PositionGetInteger(POSITION_TYPE);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double bid    = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double curSL  = PositionGetDouble(POSITION_SL);

   double profitPrice = (type == POSITION_TYPE_BUY) ? (bid - openP) : (openP - ask);
   if(profitPrice < InpATR_TrailStart * atr) return;

   double trailDist = InpATR_Trail * atr;
   if(type == POSITION_TYPE_BUY)
     {
      double newSL = NormalizeDouble(bid - trailDist, digits);
      if(newSL > curSL)
         trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
     }
   else
     {
      double newSL = NormalizeDouble(ask + trailDist, digits);
      if(curSL == 0 || newSL < curSL)
         trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
     }
  }

//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   if(!PositionSelect(_Symbol)) return(false);
   return(PositionGetInteger(POSITION_MAGIC) == InpMagic);
  }

//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpread <= 0) return(true);
   return(SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) <= InpMaxSpread);
  }
//+------------------------------------------------------------------+
