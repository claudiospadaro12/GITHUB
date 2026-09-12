//+------------------------------------------------------------------+
//|                              Nasdaq_PreOpen_Breakout_EA.mq5      |
//|  Strategia Nasdaq Breakout Pre-Apertura (5') — PDF strategia     |
//|  Candela 15:25-15:30 Roma | Pendenti H±7 | EMA50 | BE +20 | TP50 |
//+------------------------------------------------------------------+
#property copyright "Nasdaq Pre-Open Breakout"
#property version   "1.00"
#property description "Breakout pre-apertura Nasdaq: range 15:25-15:30 (Roma), pendenti ±7 pt, gestione BE+50% @+20, target +50."
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\OrderInfo.mqh>

//+------------------------------------------------------------------+
enum ENUM_NPO_TREND_MODE
  {
   NPO_TREND_BOTH       = 0,   // Entrambi i lati, size pesata su EMA 50
   NPO_TREND_TREND_ONLY = 1,   // Solo lato trend (EMA 50)
   NPO_TREND_NO_FILTER  = 2    // Entrambi i lati, stessa size
  };

//+------------------------------------------------------------------+
input group "=== SESSIONE (ora Roma) ==="
input int                  InpLocalUtcOffsetHours = 2;       // Roma vs GMT (2=CEST, 1=CET)
input int                  InpPreOpenHour           = 15;
input int                  InpPreOpenMin            = 25;
input int                  InpUSOpenHour            = 15;
input int                  InpUSOpenMin             = 30;
input int                  InpOrderExpireHour       = 18;
input int                  InpOrderExpireMin        = 0;
input int                  InpForceCloseHour        = 21;
input int                  InpForceCloseMin         = 55;

input group "=== STRATEGIA (M5) ==="
input ENUM_TIMEFRAMES      InpTimeframe             = PERIOD_M5;
input double               InpMinCandlePoints      = 17.0;   // Range minimo candela pre-open (pt)
input double               InpEntryBufferPoints     = 7.0;     // Buffer ingresso oltre H/L (pt)
input double               InpBreakevenPoints       = 20.0;    // BE + parziale 50% (pt)
input double               InpTargetPoints          = 50.0;    // Target finale (pt)
input double               InpPartialClosePercent   = 50.0;  // % chiusura a +20 pt
input double               InpPointSize             = 1.0;     // 1 pt strategia in unità prezzo
input int                  InpEarlyPlaceSeconds     = 0;      // Anticipo piazzamento (0=chiusura barra)

input group "=== FILTRO TREND (EMA 50) ==="
input ENUM_NPO_TREND_MODE  InpTrendMode             = NPO_TREND_BOTH;
input int                  InpEMA_Period            = 50;
input double               InpTrendLotWeight        = 70.0;    // % size lato trend (se entrambi)
input double               InpCounterLotWeight      = 30.0;    // % size lato contro-trend

input group "=== RISCHIO & TRADE ==="
input double               InpRiskPercent           = 1.0;   // % equity per trade (lato maggiore)
input double               InpFixedLots             = 0.01;  // Fallback se size < min
input double               InpMaxLotCap             = 50.0;
input ulong                InpMagic                 = 20260617;
input int                  InpMaxTradesPerDay       = 1;
input int                  InpMaxSlippagePoints     = 30;

input group "=== VISUALIZZAZIONE ==="
input bool                 InpShowChartObjects      = true;
input bool                 InpShowPanel             = true;
input bool                 InpAllowBuy              = true;
input bool                 InpAllowSell             = true;

#define NPO_PREFIX "NPO_EA_"

//+------------------------------------------------------------------+
CTrade         g_trade;
CPositionInfo  g_pos;
COrderInfo     g_order;

int            g_handleEma = INVALID_HANDLE;
int            g_dayKey    = -1;

double         g_preHigh   = 0.0;
double         g_preLow    = 0.0;
double         g_preRange  = 0.0;
bool           g_preReady  = false;
bool           g_strategyActive = false;

ulong          g_buyStopTicket  = 0;
ulong          g_sellStopTicket = 0;
bool           g_ordersPlaced   = false;
bool           g_fillHandled    = false;
int            g_tradesToday   = 0;

string         g_status = "Avvio";

struct NPO_TradeState
  {
   ulong  ticket;
   bool   isBuy;
   double entry;
   double sl;
   double initialVolume;
   bool   beDone;
   bool   partialDone;
  };

NPO_TradeState g_ts;
bool           g_hasTradeState = false;

//+------------------------------------------------------------------+
double NPO_PointsToPrice(const double pts)
  {
   return pts * InpPointSize;
  }

double NPO_PriceToPoints(const double priceDist)
  {
   if(InpPointSize <= 0.0) return 0.0;
   return priceDist / InpPointSize;
  }

//+------------------------------------------------------------------+
datetime NPO_ServerToRome(const datetime srv)
  {
   datetime gmt = srv - (TimeTradeServer() - TimeGMT());
   return gmt + InpLocalUtcOffsetHours * 3600;
  }

datetime NPO_RomeToServer(const datetime rome)
  {
   datetime gmt = rome - InpLocalUtcOffsetHours * 3600;
   return gmt + (TimeTradeServer() - TimeGMT());
  }

int NPO_RomeMinutesOfDay(const datetime rome)
  {
   MqlDateTime dt;
   TimeToStruct(rome, dt);
   return dt.hour * 60 + dt.min;
  }

datetime NPO_RomeTimeToday(const int hour, const int minute)
  {
   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   MqlDateTime dt;
   TimeToStruct(romeNow, dt);
   dt.hour = hour;
   dt.min  = minute;
   dt.sec  = 0;
   return StructToTime(dt);
  }

int NPO_TodayKey(const datetime romeNow)
  {
   MqlDateTime dt;
   TimeToStruct(romeNow, dt);
   return dt.year * 10000 + dt.mon * 100 + dt.day;
  }

int NPO_PreOpenStartMin()
  {
   return InpPreOpenHour * 60 + InpPreOpenMin;
  }

int NPO_USOpenMin()
  {
   return InpUSOpenHour * 60 + InpUSOpenMin;
  }

//+------------------------------------------------------------------+
void NPO_ResetDayState()
  {
   g_preHigh   = 0.0;
   g_preLow    = 0.0;
   g_preRange  = 0.0;
   g_preReady  = false;
   g_strategyActive = false;
   g_buyStopTicket  = 0;
   g_sellStopTicket = 0;
   g_ordersPlaced   = false;
   g_fillHandled    = false;
   g_tradesToday    = 0;
   NPO_ClearTradeState();
   ObjectsDeleteAll(0, NPO_PREFIX);
  }

//+------------------------------------------------------------------+
double NPO_NormalizePrice(const double price)
  {
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double tick = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tick <= 0) return NormalizeDouble(price, digits);
   return NormalizeDouble(MathRound(price / tick) * tick, digits);
  }

double NPO_NormalizeLots(double lots)
  {
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep <= 0) lotStep = 0.01;

   lots = MathFloor(lots / lotStep) * lotStep;
   lots = MathMax(minLot, lots);
   if(maxLot > 0) lots = MathMin(maxLot, lots);
   if(InpMaxLotCap > 0) lots = MathMin(InpMaxLotCap, lots);

   int volDigits = (lotStep >= 1.0) ? 0 : ((lotStep >= 0.1) ? 1 : 2);
   return NormalizeDouble(lots, volDigits);
  }

//+------------------------------------------------------------------+
void NPO_SetFilling()
  {
   int fill = (int)SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if((fill & SYMBOL_FILLING_FOK) == SYMBOL_FILLING_FOK)
      g_trade.SetTypeFilling(ORDER_FILLING_FOK);
   else if((fill & SYMBOL_FILLING_IOC) == SYMBOL_FILLING_IOC)
      g_trade.SetTypeFilling(ORDER_FILLING_IOC);
   else
      g_trade.SetTypeFilling(ORDER_FILLING_RETURN);
  }

//+------------------------------------------------------------------+
bool NPO_ValidateStops(const bool isBuy, const double entry, double &sl, double &tp)
  {
   int stopsLevel = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double minDist = stopsLevel * _Point;

   sl = NPO_NormalizePrice(sl);
   tp = NPO_NormalizePrice(tp);

   if(isBuy)
     {
      if(sl > 0 && entry - sl < minDist)
         sl = NPO_NormalizePrice(entry - minDist - _Point);
      if(tp > 0 && tp - entry < minDist)
         tp = NPO_NormalizePrice(entry + minDist + _Point);
     }
   else
     {
      if(sl > 0 && sl - entry < minDist)
         sl = NPO_NormalizePrice(entry + minDist + _Point);
      if(tp > 0 && entry - tp < minDist)
         tp = NPO_NormalizePrice(entry - minDist - _Point);
     }
   return true;
  }

//+------------------------------------------------------------------+
double NPO_CalcLots(const bool isBuy, const double entry, const double sl, const double weightPct)
  {
   if(entry <= 0 || sl <= 0 || weightPct <= 0) return 0.0;

   double slDist = isBuy ? (entry - sl) : (sl - entry);
   if(slDist <= 0) return 0.0;

   double capital = AccountInfoDouble(ACCOUNT_EQUITY);
   double riskMoney = capital * (InpRiskPercent / 100.0) * (weightPct / 100.0);
   if(riskMoney <= 0) return 0.0;

   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   if(tickSize <= 0 || tickValue <= 0) return 0.0;

   double lossPerLot = (slDist / tickSize) * tickValue;
   if(lossPerLot <= 0) return 0.0;

   return NPO_NormalizeLots(riskMoney / lossPerLot);
  }

//+------------------------------------------------------------------+
bool NPO_GetEma(const int shift, double &ema)
  {
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(g_handleEma, 0, shift, 1, buf) != 1) return false;
   ema = buf[0];
   return true;
  }

//+------------------------------------------------------------------+
// +1 = bullish trend, -1 = bearish, 0 = neutro
int NPO_GetTrendDirection()
  {
   double ema;
   if(!NPO_GetEma(1, ema)) return 0;
   double close = iClose(_Symbol, InpTimeframe, 1);
   if(close > ema) return 1;
   if(close < ema) return -1;
   return 0;
  }

//+------------------------------------------------------------------+
bool NPO_BarIsPreOpen(const datetime barOpenSrv)
  {
   datetime romeOpen = NPO_ServerToRome(barOpenSrv);
   int barMin = NPO_RomeMinutesOfDay(romeOpen);
   return (barMin == NPO_PreOpenStartMin());
  }

//+------------------------------------------------------------------+
bool NPO_LoadPreOpenCandle(const bool useFormingBar)
  {
   int shift = useFormingBar ? 0 : 1;
   datetime tOpen = iTime(_Symbol, InpTimeframe, shift);
   if(tOpen <= 0) return false;

   if(!NPO_BarIsPreOpen(tOpen))
      return false;

   g_preHigh  = iHigh(_Symbol, InpTimeframe, shift);
   g_preLow   = iLow(_Symbol, InpTimeframe, shift);
   g_preRange = g_preHigh - g_preLow;
   g_preReady = (g_preHigh > g_preLow);
   return g_preReady;
  }

//+------------------------------------------------------------------+
void NPO_UpdatePreOpenRange()
  {
   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   int todayKey = NPO_TodayKey(romeNow);
   if(todayKey != g_dayKey)
     {
      g_dayKey = todayKey;
      NPO_ResetDayState();
     }

   int nowMin = NPO_RomeMinutesOfDay(romeNow);
   int preStart = NPO_PreOpenStartMin();
   int usOpen   = NPO_USOpenMin();

   // Durante la candela pre-open: aggiorna range in formazione
   if(nowMin >= preStart && nowMin < usOpen)
     {
      if(NPO_LoadPreOpenCandle(true))
         g_status = StringFormat("Pre-open in formazione: range %.1f pt", NPO_PriceToPoints(g_preRange));
      return;
     }

   // Dopo chiusura candela pre-open
   if(nowMin >= usOpen && !g_preReady)
     {
      if(NPO_LoadPreOpenCandle(false))
        {
         double minPts = InpMinCandlePoints;
         g_strategyActive = (NPO_PriceToPoints(g_preRange) >= minPts);
         if(g_strategyActive)
            g_status = StringFormat("Range OK: %.1f pt (H=%.2f L=%.2f)",
                                    NPO_PriceToPoints(g_preRange), g_preHigh, g_preLow);
         else
            g_status = StringFormat("Range insufficiente: %.1f pt < %.1f pt",
                                    NPO_PriceToPoints(g_preRange), minPts);
        }
      else
         g_status = "Candela pre-open 15:25-15:30 non trovata";
     }
  }

//+------------------------------------------------------------------+
bool NPO_ShouldPlaceOrdersNow()
  {
   if(g_ordersPlaced || g_tradesToday >= InpMaxTradesPerDay)
      return false;
   if(NPO_HasOurPosition())
      return false;

   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   int nowMin = NPO_RomeMinutesOfDay(romeNow);
   int usOpen = NPO_USOpenMin();

   if(InpEarlyPlaceSeconds > 0)
     {
      datetime openSrv = NPO_RomeToServer(NPO_RomeTimeToday(InpUSOpenHour, InpUSOpenMin));
      if(TimeCurrent() >= openSrv - InpEarlyPlaceSeconds && nowMin >= NPO_PreOpenStartMin())
         return NPO_LoadPreOpenCandle(true);
     }

   if(nowMin >= usOpen)
      return (g_preReady || NPO_LoadPreOpenCandle(false));

   return false;
  }

//+------------------------------------------------------------------+
bool NPO_HasOurPosition()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!g_pos.SelectByIndex(i)) continue;
      if(g_pos.Symbol() != _Symbol) continue;
      if((ulong)g_pos.Magic() != InpMagic) continue;
      return true;
     }
   return false;
  }

bool NPO_SelectPosition()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      if(!g_pos.SelectByIndex(i)) continue;
      if(g_pos.Symbol() != _Symbol) continue;
      if((ulong)g_pos.Magic() != InpMagic) continue;
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
void NPO_CancelOrderByTicket(const ulong ticket)
  {
   if(ticket == 0) return;
   if(g_order.Select(ticket))
      g_trade.OrderDelete(ticket);
  }

void NPO_CancelAllPending()
  {
   NPO_CancelOrderByTicket(g_buyStopTicket);
   NPO_CancelOrderByTicket(g_sellStopTicket);
   g_buyStopTicket  = 0;
   g_sellStopTicket = 0;
  }

void NPO_CancelOppositePending(const bool filledBuy)
  {
   if(filledBuy)
      NPO_CancelOrderByTicket(g_sellStopTicket);
   else
      NPO_CancelOrderByTicket(g_buyStopTicket);

   if(filledBuy) g_sellStopTicket = 0;
   else          g_buyStopTicket  = 0;
  }

//+------------------------------------------------------------------+
datetime NPO_OrderExpiration()
  {
   return NPO_RomeToServer(NPO_RomeTimeToday(InpOrderExpireHour, InpOrderExpireMin));
  }

//+------------------------------------------------------------------+
bool NPO_PlacePendingOrders()
  {
   if(g_ordersPlaced || g_preHigh <= g_preLow)
      return false;

   if(NPO_PriceToPoints(g_preRange) < InpMinCandlePoints)
     {
      g_status = StringFormat("Range %.1f pt < min %.1f pt — ordini non piazzati",
                              NPO_PriceToPoints(g_preRange), InpMinCandlePoints);
      g_ordersPlaced = true;
      return false;
     }

   int trend = NPO_GetTrendDirection();
   bool placeBuy  = InpAllowBuy;
   bool placeSell = InpAllowSell;

   if(InpTrendMode == NPO_TREND_TREND_ONLY)
     {
      if(trend == 1)       placeSell = false;
      else if(trend == -1) placeBuy  = false;
      else
        {
         g_status = "Trend neutro — nessun ordine (solo trend)";
         g_ordersPlaced = true;
         return false;
        }
     }

   double buyPrice  = NPO_NormalizePrice(g_preHigh + NPO_PointsToPrice(InpEntryBufferPoints));
   double sellPrice = NPO_NormalizePrice(g_preLow  - NPO_PointsToPrice(InpEntryBufferPoints));
   double buySL     = NPO_NormalizePrice(g_preLow);
   double sellSL    = NPO_NormalizePrice(g_preHigh);

   double buyTP  = 0.0;
   double sellTP = 0.0;
   NPO_ValidateStops(true,  buyPrice,  buySL,  buyTP);
   NPO_ValidateStops(false, sellPrice, sellSL, sellTP);

   double buyWeight  = 100.0;
   double sellWeight = 100.0;
   if(InpTrendMode == NPO_TREND_BOTH)
     {
      buyWeight  = (trend == 1)  ? InpTrendLotWeight : InpCounterLotWeight;
      sellWeight = (trend == -1) ? InpTrendLotWeight : InpCounterLotWeight;
     }
   else if(InpTrendMode == NPO_TREND_TREND_ONLY)
     {
      buyWeight  = 100.0;
      sellWeight = 100.0;
     }

   datetime expiry = NPO_OrderExpiration();
   g_trade.SetExpertMagicNumber(InpMagic);
   g_trade.SetDeviationInPoints(InpMaxSlippagePoints);

   bool okBuy = false, okSell = false;

   if(placeBuy)
     {
      double lots = NPO_CalcLots(true, buyPrice, buySL, buyWeight);
      double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      if(lots < minLot) lots = InpFixedLots;

      if(lots >= minLot)
        {
         okBuy = g_trade.BuyStop(lots, buyPrice, _Symbol, buySL, 0.0,
                                 ORDER_TIME_SPECIFIED, expiry, "NPO|BUYSTOP");
         if(okBuy) g_buyStopTicket = g_trade.ResultOrder();
        }
     }

   if(placeSell)
     {
      double lots = NPO_CalcLots(false, sellPrice, sellSL, sellWeight);
      double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      if(lots < minLot) lots = InpFixedLots;

      if(lots >= minLot)
        {
         okSell = g_trade.SellStop(lots, sellPrice, _Symbol, sellSL, 0.0,
                                   ORDER_TIME_SPECIFIED, expiry, "NPO|SELLSTOP");
         if(okSell) g_sellStopTicket = g_trade.ResultOrder();
        }
     }

   if(okBuy || okSell)
     {
      g_ordersPlaced = true;
      g_status = StringFormat("Pendenti piazzati: BUY STOP @ %.2f | SELL STOP @ %.2f (trend=%d)",
                              buyPrice, sellPrice, trend);
      Print("NPO: ", g_status);
      return true;
     }

   g_status = "Errore piazzamento pendenti: " + IntegerToString(g_trade.ResultRetcode());
   return false;
  }

//+------------------------------------------------------------------+
void NPO_ClearTradeState()
  {
   ZeroMemory(g_ts);
   g_hasTradeState = false;
  }

bool NPO_RegisterTradeState()
  {
   if(!NPO_SelectPosition())
      return false;

   g_ts.ticket        = g_pos.Ticket();
   g_ts.isBuy         = (g_pos.PositionType() == POSITION_TYPE_BUY);
   g_ts.entry         = g_pos.PriceOpen();
   g_ts.sl            = g_pos.StopLoss();
   g_ts.initialVolume = g_pos.Volume();
   g_ts.beDone        = false;
   g_ts.partialDone   = false;
   g_hasTradeState    = true;
   return true;
  }

void NPO_SyncTradeState()
  {
   if(!NPO_SelectPosition())
     {
      NPO_ClearTradeState();
      return;
     }
   if(g_hasTradeState && g_ts.ticket == g_pos.Ticket())
      return;
   NPO_RegisterTradeState();
  }

//+------------------------------------------------------------------+
double NPO_VolumeFromPercent(const double baseVol, const double pct)
  {
   if(baseVol <= 0.0 || pct <= 0.0) return 0.0;
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep <= 0.0) lotStep = 0.01;

   double vol = baseVol * (pct / 100.0);
   vol = MathFloor(vol / lotStep) * lotStep;
   vol = NormalizeDouble(vol, (lotStep >= 1.0) ? 0 : ((lotStep >= 0.1) ? 1 : 2));
   if(vol < minLot) return 0.0;
   return MathMin(vol, baseVol);
  }

//+------------------------------------------------------------------+
void NPO_HandleFill()
  {
   if(g_fillHandled) return;
   if(!NPO_SelectPosition()) return;

   g_fillHandled = true;
   g_tradesToday++;

   bool isBuy = (g_pos.PositionType() == POSITION_TYPE_BUY);
   NPO_CancelOppositePending(isBuy);

   double sl = isBuy ? NPO_NormalizePrice(g_preLow) : NPO_NormalizePrice(g_preHigh);
   double tp = 0.0;
   double entry = g_pos.PriceOpen();
   NPO_ValidateStops(isBuy, entry, sl, tp);

   if(MathAbs(g_pos.StopLoss() - sl) > _Point)
      g_trade.PositionModify(g_pos.Ticket(), sl, 0.0);

   NPO_RegisterTradeState();
   g_status = StringFormat("Fill %s @ %.2f | SL %.2f | BE @ +%.0f pt | Target +%.0f pt",
                           isBuy ? "LONG" : "SHORT", entry, sl,
                           InpBreakevenPoints, InpTargetPoints);
   Print("NPO: ", g_status);
  }

//+------------------------------------------------------------------+
void NPO_ManageOpenPosition()
  {
   if(!NPO_SelectPosition())
      return;

   NPO_SyncTradeState();
   if(!g_hasTradeState) return;

   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   int nowMin = NPO_RomeMinutesOfDay(romeNow);
   int forceMin = InpForceCloseHour * 60 + InpForceCloseMin;
   if(nowMin >= forceMin)
     {
      g_trade.PositionClose(g_ts.ticket);
      NPO_ClearTradeState();
      g_status = "Chiusura forzata fine sessione";
      return;
     }

   bool isBuy = g_ts.isBuy;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double price = isBuy ? bid : ask;
   double profitPts = isBuy ? NPO_PriceToPoints(price - g_ts.entry)
                            : NPO_PriceToPoints(g_ts.entry - price);

   double beDist = NPO_PointsToPrice(InpBreakevenPoints);
   double tgtDist = NPO_PointsToPrice(InpTargetPoints);
   double bePrice = isBuy ? NPO_NormalizePrice(g_ts.entry) : NPO_NormalizePrice(g_ts.entry);
   double tgtPrice = isBuy ? NPO_NormalizePrice(g_ts.entry + tgtDist)
                           : NPO_NormalizePrice(g_ts.entry - tgtDist);

   // Target +50 pt — chiude il residuo
   bool hitTarget = isBuy ? (price >= tgtPrice) : (price <= tgtPrice);
   if(hitTarget)
     {
      if(g_trade.PositionClose(g_ts.ticket))
        {
         g_status = StringFormat("Target +%.0f pt raggiunto — posizione chiusa", InpTargetPoints);
         NPO_ClearTradeState();
         Print("NPO: ", g_status);
        }
      return;
     }

   // +20 pt: breakeven + chiusura 50%
   if(!g_ts.partialDone && profitPts >= InpBreakevenPoints)
     {
      if(!g_ts.beDone)
        {
         double sl = bePrice;
         double tp = 0.0;
         NPO_ValidateStops(isBuy, g_ts.entry, sl, tp);
         if(g_trade.PositionModify(g_ts.ticket, sl, 0.0))
           {
            g_ts.beDone = true;
            g_ts.sl = sl;
            Print("NPO: SL spostato a breakeven @ ", sl);
           }
        }

      double vol = g_pos.Volume();
      double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      double closeVol = NPO_VolumeFromPercent(g_ts.initialVolume, InpPartialClosePercent);

      if(closeVol <= 0.0 || closeVol >= vol || (vol - closeVol) < minLot)
         closeVol = vol * 0.5;

      closeVol = NPO_NormalizeLots(closeVol);
      if(closeVol >= minLot && closeVol < vol)
        {
         if(g_trade.PositionClosePartial(g_ts.ticket, closeVol))
           {
            g_ts.partialDone = true;
            g_status = StringFormat("+%.0f pt: BE attivo, chiuso %.0f%% (%.2f lot)",
                                    InpBreakevenPoints, InpPartialClosePercent, closeVol);
            Print("NPO: ", g_status);
           }
        }
      else if(closeVol >= vol - 0.0000001)
        {
         g_ts.partialDone = true;
        }
     }
  }

//+------------------------------------------------------------------+
void NPO_ExpirePendingIfNeeded()
  {
   if(!g_ordersPlaced || g_fillHandled) return;
   if(NPO_HasOurPosition()) return;

   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   int nowMin = NPO_RomeMinutesOfDay(romeNow);
   int expMin = InpOrderExpireHour * 60 + InpOrderExpireMin;

   if(nowMin >= expMin)
     {
      NPO_CancelAllPending();
      g_status = "Pendenti scaduti — nessun fill";
     }
  }

//+------------------------------------------------------------------+
void NPO_OnTradeTransaction(const MqlTradeTransaction &trans,
                            const MqlTradeRequest &request,
                            const MqlTradeResult &result)
  {
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD)
      return;
   if(trans.symbol != _Symbol)
      return;

   if(!HistoryDealSelect(trans.deal))
      return;
   if((ulong)HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != InpMagic)
      return;

   long entry = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
   if(entry == DEAL_ENTRY_IN)
      NPO_HandleFill();
  }

//+------------------------------------------------------------------+
void NPO_UpdateRect(const string name, const datetime t1, const double top,
                    const datetime t2, const double bottom, const color clr)
  {
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_RECTANGLE, 0, t1, top, t2, bottom);
   else
     {
      ObjectMove(0, name, 0, t1, top);
      ObjectMove(0, name, 1, t2, bottom);
     }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
   ObjectSetInteger(0, name, OBJPROP_FILL, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
  }

void NPO_UpdateHLine(const string name, const datetime t1, const double price,
                     const datetime t2, const color clr, const ENUM_LINE_STYLE style = STYLE_SOLID)
  {
   if(ObjectFind(0, name) < 0)
      ObjectCreate(0, name, OBJ_TREND, 0, t1, price, t2, price);
   else
     {
      ObjectMove(0, name, 0, t1, price);
      ObjectMove(0, name, 1, t2, price);
     }
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, name, OBJPROP_STYLE, style);
   ObjectSetInteger(0, name, OBJPROP_RAY_RIGHT, true);
   ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
  }

void NPO_DrawChart()
  {
   if(!InpShowChartObjects || !g_preReady || g_preHigh <= g_preLow)
      return;

   datetime srvStart = NPO_RomeToServer(NPO_RomeTimeToday(InpPreOpenHour, InpPreOpenMin));
   datetime srvEnd   = NPO_RomeToServer(NPO_RomeTimeToday(InpUSOpenHour, InpUSOpenMin));
   datetime lineEnd  = srvEnd + 4 * 3600;

   double buyLvl  = NPO_NormalizePrice(g_preHigh + NPO_PointsToPrice(InpEntryBufferPoints));
   double sellLvl = NPO_NormalizePrice(g_preLow  - NPO_PointsToPrice(InpEntryBufferPoints));

   NPO_UpdateRect(NPO_PREFIX + "BOX", srvStart, g_preHigh, srvEnd, g_preLow, C'30,80,160');
   NPO_UpdateHLine(NPO_PREFIX + "H", srvEnd, g_preHigh, lineEnd, clrDodgerBlue);
   NPO_UpdateHLine(NPO_PREFIX + "L", srvEnd, g_preLow, lineEnd, clrOrangeRed);
   NPO_UpdateHLine(NPO_PREFIX + "BUY", srvEnd, buyLvl, lineEnd, clrLime, STYLE_DASH);
   NPO_UpdateHLine(NPO_PREFIX + "SELL", srvEnd, sellLvl, lineEnd, clrRed, STYLE_DASH);

   if(g_hasTradeState)
     {
      double tgt = g_ts.isBuy
                   ? NPO_NormalizePrice(g_ts.entry + NPO_PointsToPrice(InpTargetPoints))
                   : NPO_NormalizePrice(g_ts.entry - NPO_PointsToPrice(InpTargetPoints));
      double beLvl = g_ts.isBuy
                     ? NPO_NormalizePrice(g_ts.entry + NPO_PointsToPrice(InpBreakevenPoints))
                     : NPO_NormalizePrice(g_ts.entry - NPO_PointsToPrice(InpBreakevenPoints));
      NPO_UpdateHLine(NPO_PREFIX + "BE", srvEnd, beLvl, lineEnd, clrGold, STYLE_DOT);
      NPO_UpdateHLine(NPO_PREFIX + "TP", srvEnd, tgt, lineEnd, clrAqua, STYLE_DASH);
     }
  }

//+------------------------------------------------------------------+
void NPO_UpdatePanel()
  {
   if(!InpShowPanel)
     {
      Comment("");
      return;
     }

   datetime romeNow = NPO_ServerToRome(TimeCurrent());
   string rangeStr = g_preReady
                     ? StringFormat("%.1f pt (H=%.2f L=%.2f)", NPO_PriceToPoints(g_preRange), g_preHigh, g_preLow)
                     : "—";

   Comment(
      "Nasdaq Pre-Open Breakout EA v1.00\n",
      "Ora Roma: ", TimeToString(romeNow, TIME_MINUTES),
      "  |  Offset GMT+", InpLocalUtcOffsetHours, "\n",
      "Candela pre-open 15:25-15:30: ", rangeStr, "\n",
      "Strategia attiva: ", (g_strategyActive ? "SI" : "NO"),
      "  |  Pendenti: ", (g_ordersPlaced ? "SI" : "NO"), "\n",
      "Trade oggi: ", g_tradesToday, "/", InpMaxTradesPerDay, "\n",
      "Parametri: min ", InpMinCandlePoints, " pt | buffer ±", InpEntryBufferPoints,
      " pt | BE +", InpBreakevenPoints, " pt | TP +", InpTargetPoints, " pt\n",
      "Status: ", g_status
   );
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpTimeframe != PERIOD_M5)
      Print("NPO: strategia definita su M5; timeframe attuale: ", EnumToString(InpTimeframe));

   g_trade.SetExpertMagicNumber(InpMagic);
   NPO_SetFilling();

   g_handleEma = iMA(_Symbol, InpTimeframe, InpEMA_Period, 0, MODE_EMA, PRICE_CLOSE);
   if(g_handleEma == INVALID_HANDLE)
     {
      Print("NPO: errore creazione EMA ", InpEMA_Period);
      return INIT_FAILED;
   }

   NPO_UpdatePreOpenRange();
   NPO_SyncTradeState();
   if(NPO_HasOurPosition())
      g_fillHandled = true;

   Print("NPO EA avviato su ", _Symbol,
         " | pre-open ", InpPreOpenHour, ":", InpPreOpenMin,
         " | apertura USA ", InpUSOpenHour, ":", InpUSOpenMin, " (Roma)");
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(g_handleEma != INVALID_HANDLE)
      IndicatorRelease(g_handleEma);
   ObjectsDeleteAll(0, NPO_PREFIX);
   Comment("");
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   NPO_UpdatePreOpenRange();

   if(NPO_ShouldPlaceOrdersNow())
      NPO_PlacePendingOrders();

   if(NPO_HasOurPosition())
      NPO_HandleFill();

   NPO_ManageOpenPosition();
   NPO_ExpirePendingIfNeeded();

   NPO_DrawChart();
   NPO_UpdatePanel();
  }

//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
  {
   NPO_OnTradeTransaction(trans, request, result);
  }

//+------------------------------------------------------------------+
