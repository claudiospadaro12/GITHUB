//+------------------------------------------------------------------+
//| EA_BOLL_BULGE_Manager_PRO_MULTI_TF.mq4                           |
//| SORGENTE INTEGRALE di CLAUDIO - ripostato e salvato il 21/08/2026 |
//| (il 12/08 avevo salvato solo le note: sorgente perso, regola #1)  |
//| Trade Manager per strategia Bollinger                            |
//| - NON apre ordini                                                |
//| - Gestisce ordini gia' aperti                                    |
//| - SL automatico = ATR(TF grafico) x 3                            |
//| - TP immediato su mediana Bollinger del TF grafico               |
//| - TP aggiornato a ogni nuova candela del TF grafico              |
//| - Break-even + trailing opzionali                                |
//+------------------------------------------------------------------+
#property strict

extern string EA_Name = "EA_BOLL_BULGE_Manager_PRO_MULTI_TF";

// Filtro ordini: -1 = solo manuali (Magic=0) | 0 = tutti | >0 = quel magic
extern int    MagicFilter = -1;

// SL automatico ATR x 3
extern bool   AutoSetSL_IfMissing = true;
extern int    ATR_Period          = 14;
extern int    ATR_Timeframe       = 0;     // 0 = timeframe del grafico
extern double SL_ATR_Mult         = 3.0;

// TP sulla mediana Bollinger
extern bool   AutoSetTP_ToMedian  = true;
extern bool   UpdateTP_Dynamic    = true;
extern bool   UpdateTP_OnNewBar   = true;
extern int    TP_Timeframe        = 0;     // 0 = timeframe del grafico
extern int    BB_Period           = 20;
extern double BB_Deviation        = 2.0;
extern int    BB_Shift            = 0;
extern int    MedianBarIndex      = 0;     // 0 = barra attuale, 1 = barra chiusa
extern int    TP_MinMove_Points   = 10;

// Break Even
extern bool   Enable_BE            = true;
extern double BE_At_R              = 1.0;
extern int    BE_Offset_Points     = 2;

// Trailing in R
extern bool   Enable_Trailing_R    = true;
extern double Trail_Start_R        = 1.5;
extern double Trail_Step_R         = 0.25;
extern int    Trail_MinMove_Points = 10;

// Broker / protezioni
extern int    Slippage         = 3;
extern int    ModifyRetries    = 5;
extern int    RetrySleepMs     = 250;
extern bool   SkipIfSpreadHigh = false;
extern int    MaxSpread_Points = 30;

// Notifiche
extern bool   Enable_Alerts = true;
extern bool   Enable_Push   = true;

datetime g_lastBarTP = 0;

double ND(double price) { return NormalizeDouble(price, Digits); }
double SpreadPoints()   { return MarketInfo(Symbol(), MODE_SPREAD); }
int    StopLevelPoints(){ return (int)MarketInfo(Symbol(), MODE_STOPLEVEL); }

bool IsSpreadOk()
{
   if(!SkipIfSpreadHigh) return true;
   return (SpreadPoints() <= MaxSpread_Points);
}

bool IsTradeAllowedNow()
{
   if(!IsTradeAllowed())    return false;
   if(IsTradeContextBusy()) return false;
   if(!IsSpreadOk())        return false;
   return true;
}

void Notify(string msg)
{
   string full = EA_Name + " | " + Symbol() + " | " + msg;
   Print(full);
   if(Enable_Alerts) Alert(full);
   if(Enable_Push)   SendNotification(full);
}

string TFToString(int tf)
{
   if(tf == PERIOD_M1)   return "M1";
   if(tf == PERIOD_M5)   return "M5";
   if(tf == PERIOD_M15)  return "M15";
   if(tf == PERIOD_M30)  return "M30";
   if(tf == PERIOD_H1)   return "H1";
   if(tf == PERIOD_H4)   return "H4";
   if(tf == PERIOD_D1)   return "D1";
   if(tf == PERIOD_W1)   return "W1";
   if(tf == PERIOD_MN1)  return "MN1";
   return "TF_" + IntegerToString(tf);
}

int ResolveTF(int tf) { if(tf == 0) return Period(); return tf; }

bool MagicMatch()
{
   if(MagicFilter == 0)  return true;
   if(MagicFilter == -1) return (OrderMagicNumber() == 0);
   return (OrderMagicNumber() == MagicFilter);
}

bool IsManagedOrder()
{
   if(OrderSymbol() != Symbol()) return false;
   if(OrderType() != OP_BUY && OrderType() != OP_SELL) return false;
   if(!MagicMatch()) return false;
   return true;
}

bool IsNewBar(int tf, datetime &lastBar)
{
   int realTF = ResolveTF(tf);
   datetime t = iTime(Symbol(), realTF, 0);
   if(t == 0) return false;
   if(lastBar == 0) { lastBar = t; return false; }
   if(t != lastBar) { lastBar = t; return true; }
   return false;
}

double GetATR(int tf, int period)
{
   int realTF = ResolveTF(tf);
   double v = iATR(Symbol(), realTF, period, 0);
   if(v <= 0) return 0;
   return v;
}

double GetBollingerMedian(int tf, int period, double dev, int shift, int barIndex)
{
   int realTF = ResolveTF(tf);
   double mid = iBands(Symbol(), realTF, period, dev, shift, PRICE_CLOSE, MODE_MAIN, barIndex);
   if(mid <= 0) return 0;
   return ND(mid);
}

double ClampSL(int type, double sl)
{
   if(sl <= 0) return 0;
   double minDist = (StopLevelPoints() + 5) * Point;
   if(type == OP_BUY)       { if(sl >= Bid) sl = Bid - minDist; }
   else if(type == OP_SELL) { if(sl <= Ask) sl = Ask + minDist; }
   return ND(sl);
}

double ClampTP(int type, double tp)
{
   if(tp <= 0) return 0;
   double minDist = (StopLevelPoints() + 5) * Point;
   if(type == OP_BUY)       { if(tp <= Bid) tp = Bid + minDist; }
   else if(type == OP_SELL) { if(tp >= Ask) tp = Ask - minDist; }
   return ND(tp);
}

bool ValidateStopsForBroker(int type, double sl, double tp)
{
   double stopLvl = StopLevelPoints() * Point;
   if(type == OP_BUY)
   {
      if(sl > 0 && (Bid - sl) < stopLvl) return false;
      if(tp > 0 && (tp - Bid) < stopLvl) return false;
   }
   else if(type == OP_SELL)
   {
      if(sl > 0 && (sl - Ask) < stopLvl) return false;
      if(tp > 0 && (Ask - tp) < stopLvl) return false;
   }
   return true;
}

bool SafeOrderModify(int ticket, double openPrice, double sl, double tp, datetime exp, color clr)
{
   for(int k = 0; k < ModifyRetries; k++)
   {
      RefreshRates();
      ResetLastError();
      bool ok = OrderModify(ticket, openPrice, sl, tp, exp, clr);
      if(ok) return true;
      int err = GetLastError();
      Print(EA_Name, " | OrderModify FAIL | ticket=", ticket, " err=", err,
            " sl=", DoubleToString(sl, Digits), " tp=", DoubleToString(tp, Digits));
      Sleep(RetrySleepMs);
   }
   return false;
}

// ATTENZIONE (difetto trovato da Claude il 12/08, NON corretto qui: e' il
// sorgente originale di Claudio): il rischio iniziale e' calcolato sullo SL
// CORRENTE. Dopo il break-even riskPts ~ 0 e i multipli R esplodono ->
// il trailing perde senso. In un eventuale porting a MT5 va memorizzato
// lo SL INIZIALE per ticket, come fanno gli ABTG.
double InitialRiskPoints(int type)
{
   double op = OrderOpenPrice();
   double sl = OrderStopLoss();
   if(sl <= 0) return 0;
   if(type == OP_BUY)  return MathAbs(op - sl) / Point;
   if(type == OP_SELL) return MathAbs(sl - op) / Point;
   return 0;
}

double ProfitPointsNow(int type)
{
   double op = OrderOpenPrice();
   if(type == OP_BUY)  return (Bid - op) / Point;
   if(type == OP_SELL) return (op - Ask) / Point;
   return 0;
}

double CurrentR(int type)
{
   double riskPts = InitialRiskPoints(type);
   if(riskPts <= 0) return 0;
   return ProfitPointsNow(type) / riskPts;
}

void EnsureSL(int type)
{
   if(!AutoSetSL_IfMissing) return;
   double currentSL = OrderStopLoss();
   if(currentSL > 0) return;

   int realATR_TF = ResolveTF(ATR_Timeframe);
   double atr = GetATR(ATR_Timeframe, ATR_Period);
   if(atr <= 0) return;

   double dist  = atr * SL_ATR_Mult;
   double newSL = 0.0;
   if(type == OP_BUY)       newSL = OrderOpenPrice() - dist;
   else if(type == OP_SELL) newSL = OrderOpenPrice() + dist;
   else return;

   newSL = ClampSL(type, newSL);
   double tp = ClampTP(type, OrderTakeProfit());

   if(!ValidateStopsForBroker(type, newSL, tp)) return;
   if(!IsTradeAllowedNow()) return;

   if(SafeOrderModify(OrderTicket(), OrderOpenPrice(), newSL, tp, 0, clrNONE))
      Notify("SL automatico impostato | ATR(" + TFToString(realATR_TF) + ") x "
             + DoubleToString(SL_ATR_Mult, 2) + " | SL=" + DoubleToString(newSL, Digits));
}

void EnsureTP_ImmediateOrUpdate(int type, bool forceNow)
{
   if(!AutoSetTP_ToMedian) return;
   int realTP_TF = ResolveTF(TP_Timeframe);
   double entry = OrderOpenPrice();
   if(entry <= 0) return;

   double mid = GetBollingerMedian(TP_Timeframe, BB_Period, BB_Deviation, BB_Shift, MedianBarIndex);
   if(mid <= 0) return;

   double currentTP = OrderTakeProfit();
   bool tpMissing   = (currentTP <= 0);

   if(!tpMissing)
   {
      if(!UpdateTP_Dynamic) return;
      if(!forceNow) return;
   }

   double newTP = ClampTP(type, mid);

   if(currentTP > 0)
      if(MathAbs(currentTP - newTP) <= TP_MinMove_Points * Point) return;

   double sl = ClampSL(type, OrderStopLoss());

   if(!ValidateStopsForBroker(type, sl, newTP)) return;
   if(!IsTradeAllowedNow()) return;

   if(SafeOrderModify(OrderTicket(), entry, sl, newTP, 0, clrNONE))
   {
      if(tpMissing)
         Notify("TP immediato su mediana " + TFToString(realTP_TF)
                + " | Entry=" + DoubleToString(entry, Digits)
                + " | Mid=" + DoubleToString(mid, Digits)
                + " | TP=" + DoubleToString(newTP, Digits));
      else
         Notify("TP aggiornato su nuova " + TFToString(realTP_TF)
                + " | Entry=" + DoubleToString(entry, Digits)
                + " | Mid=" + DoubleToString(mid, Digits)
                + " | TP=" + DoubleToString(newTP, Digits));
   }
}

void DoBreakEvenIfNeeded(int type)
{
   if(!Enable_BE) return;
   double sl = OrderStopLoss();
   if(sl <= 0) return;
   double riskPts = InitialRiskPoints(type);
   if(riskPts <= 0) return;
   double r = CurrentR(type);
   if(r < BE_At_R) return;

   double op    = OrderOpenPrice();
   double newSL = sl;

   if(type == OP_BUY)
   {
      double target = op + BE_Offset_Points * Point;
      if(sl < target) newSL = target; else return;
   }
   else if(type == OP_SELL)
   {
      double target = op - BE_Offset_Points * Point;
      if(sl > target) newSL = target; else return;
   }
   else return;

   newSL = ClampSL(type, newSL);
   double tp = ClampTP(type, OrderTakeProfit());

   if(!ValidateStopsForBroker(type, newSL, tp)) return;
   if(!IsTradeAllowedNow()) return;

   if(SafeOrderModify(OrderTicket(), op, newSL, tp, 0, clrNONE))
      Notify("BE attivato | R=" + DoubleToString(r, 2) + " | SL=" + DoubleToString(newSL, Digits));
}

void DoTrailingRIfNeeded(int type)
{
   if(!Enable_Trailing_R) return;
   double sl = OrderStopLoss();
   if(sl <= 0) return;
   double riskPts = InitialRiskPoints(type);
   if(riskPts <= 0) return;
   double r = CurrentR(type);
   if(r < Trail_Start_R) return;

   double steps = MathFloor((r - Trail_Start_R) / Trail_Step_R);
   if(steps < 0) return;

   double lockR = (Trail_Start_R + steps * Trail_Step_R) - 1.0;
   if(lockR < 0) lockR = 0;

   double op       = OrderOpenPrice();
   double targetSL = sl;

   if(type == OP_BUY)
   {
      targetSL = op + lockR * riskPts * Point;
      if(targetSL <= sl + Trail_MinMove_Points * Point) return;
   }
   else if(type == OP_SELL)
   {
      targetSL = op - lockR * riskPts * Point;
      if(targetSL >= sl - Trail_MinMove_Points * Point) return;
   }
   else return;

   targetSL = ClampSL(type, targetSL);
   double tp = ClampTP(type, OrderTakeProfit());

   if(!ValidateStopsForBroker(type, targetSL, tp)) return;
   if(!IsTradeAllowedNow()) return;

   if(SafeOrderModify(OrderTicket(), op, targetSL, tp, 0, clrNONE))
      Notify("Trailing R aggiornato | R=" + DoubleToString(r, 2)
             + " | SL=" + DoubleToString(targetSL, Digits));
}

int OnInit()
{
   int realATR_TF = ResolveTF(ATR_Timeframe);
   int realTP_TF  = ResolveTF(TP_Timeframe);
   Print(EA_Name, " init su ", Symbol(),
         " | ChartTF=", TFToString(Period()),
         " | MagicFilter=", MagicFilter,
         " | ATR TF=", TFToString(realATR_TF),
         " | TP TF=", TFToString(realTP_TF),
         " | SL=ATRx", DoubleToString(SL_ATR_Mult, 2));
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason) { Print(EA_Name, " deinit reason=", reason); }

void OnTick()
{
   RefreshRates();

   bool newBarForTP = false;
   if(UpdateTP_OnNewBar) newBarForTP = IsNewBar(TP_Timeframe, g_lastBarTP);
   else                  newBarForTP = true;

   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(!IsManagedOrder()) continue;

      int type = OrderType();
      EnsureSL(type);                                  // 1) SL subito se manca
      EnsureTP_ImmediateOrUpdate(type, newBarForTP);   // 2) TP mediana + update
      DoBreakEvenIfNeeded(type);                       // 3) Break Even
      DoTrailingRIfNeeded(type);                       // 4) Trailing
   }
}
//+------------------------------------------------------------------+
