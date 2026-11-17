//+------------------------------------------------------------------+
//|  DAX_M3_Supertrend.mq5                                            |
//|  EA trend-following intraday — "DAX M3 Supertrend".               |
//|  Riscrittura pulita (v2).                                         |
//|                                                                   |
//|  LOGICA                                                           |
//|   - BIAS (filtro primario) su H4: Supertrend H4 + EMA200 H4 +     |
//|     ADX H4. E' l'UNICA cosa che decide LONG / SHORT / NEUTRO.     |
//|   - TRIGGER sul TF del grafico (inteso M3): flip del Supertrend   |
//|     nella direzione del bias, con filtro EMA200 e gate orario.    |
//|   - SL = linea Supertrend del TF corrente; TP = RR * stopDist.    |
//|   - Uscita: Supertrend opposto e/o RR (ExitMode); chiusura        |
//|     intraday a fine sessione.                                     |
//|                                                                   |
//|  Tutto su barre CHIUSE (nessun look-ahead). Sizing universale     |
//|  via TICK_VALUE/TICK_SIZE. Stop sempre validati contro i vincoli  |
//|  del broker (stops level + tick) con fallback apri-poi-modifica.  |
//|                                                                   |
//|  NB: il TF del grafico E' il TF di entrata. Per "M3" aprire su    |
//|      grafico M3. L'H4 e' fisso per il bias.                       |
//+------------------------------------------------------------------+
#property copyright "Claudio — DAX M3 Supertrend v2"
#property version   "2.00"
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

//==================================================================
// ENUM
//==================================================================
enum ENUM_EXIT_MODE
{
   EXIT_ST_OPPOSITE_PLUS_RR = 0,  // Supertrend opposto + RR (TP)
   EXIT_RR_ONLY             = 1,  // Solo RR (TP)
   EXIT_ST_OPPOSITE_ONLY    = 2   // Solo Supertrend opposto
};

//==================================================================
// INPUT
//==================================================================
input group "=== Supertrend ==="
input double Factor        = 3.5;   // Supertrend Factor (x ATR)
input int    AtrPeriod     = 10;    // Supertrend ATR period
input int    ST_Lookback   = 150;   // Barre per stabilizzare la ricorsione (basta ~40-100)

input group "=== Bias H4 ==="
input bool   UseEMA        = true;  // Filtro EMA200 (H4 e TF corrente)
input bool   UseADX        = true;  // Filtro ADX (H4)
input int    EmaPeriod     = 200;   // Periodo EMA
input int    AdxLen        = 14;    // ADX length (H4)
input double AdxThreshold  = 25.0;  // ADX soglia minima

input group "=== Sessione (CET) ==="
input int    SessStartHour = 9;     // Ora inizio (CET)
input int    SessStartMin  = 30;    // Min inizio (CET)
input int    SessEndHour   = 17;    // Ora fine (CET)
input int    SessEndMin    = 30;    // Min fine (CET)
input int    ServerToCET   = 0;     // Offset: ore_server - ore_CET
input bool   CloseAtSessEnd= true;  // Chiudi posizioni a fine sessione

input group "=== Uscita / SL / TP ==="
input ENUM_EXIT_MODE ExitMode = EXIT_ST_OPPOSITE_PLUS_RR; // Modalita' uscita
input double RR            = 1.5;   // Reward:Risk (TP)
input bool   TrailWithST   = false; // Trascina SL sulla linea Supertrend

input group "=== Rischio ==="
input double RiskPct       = 1.0;   // Rischio % per trade
input int    MaxTrades     = 3;     // Max trade contemporanei
input double MaxTotalRisk  = 3.0;   // Tetto rischio aperto (%)
input long   MagicNumber   = 20260626;

//==================================================================
// GLOBALI
//==================================================================
int      hAtrCur = INVALID_HANDLE, hAtrH4 = INVALID_HANDLE;
int      hEmaCur = INVALID_HANDLE, hEmaH4 = INVALID_HANDLE;
int      hAdxH4  = INVALID_HANDLE;
datetime g_lastBar = 0;
string   g_sym;
int      g_digits;
double   g_point, g_tick;

//==================================================================
// UTILITY prezzo / lotto
//==================================================================
double RoundToTick(double price)
{
   if(g_tick <= 0.0) return(NormalizeDouble(price, g_digits));
   return(NormalizeDouble(MathRound(price / g_tick) * g_tick, g_digits));
}

// valore in valuta-conto di 1.0 di prezzo, per 1 lotto
double MoneyPerPoint()
{
   double tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0.0 || ts <= 0.0) return(0.0);
   return(tv / ts);
}

// distanza minima richiesta dal broker per gli stop + margine 1 tick
double MinStopDist()
{
   long s = SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL);
   long f = SymbolInfoInteger(g_sym, SYMBOL_TRADE_FREEZE_LEVEL);
   double t = (g_tick > 0.0) ? g_tick : g_point;
   return((double)MathMax(s, f) * g_point + t);
}

double RiskLot(double stopDist)
{
   if(stopDist <= 0.0) return(0.0);
   double mpp = MoneyPerPoint();
   if(mpp <= 0.0)
   {
      Print("DAX_ST: tickValue/tickSize non validi — trade annullato.");
      return(0.0);
   }
   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * RiskPct / 100.0;
   double raw       = riskMoney / (stopDist * mpp);

   double minLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
   double step   = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   if(step <= 0.0) step = 0.01;

   double lot = MathFloor(raw / step) * step;
   int    ld  = (int)MathMax(0, MathRound(MathLog10(1.0 / step)));
   lot = NormalizeDouble(lot, ld);

   if(lot < minLot)
   {
      if(minLot * stopDist * mpp > riskMoney)
      {
         Print("DAX_ST: lotto minimo (", DoubleToString(minLot,2),
               ") rischia troppo > budget ", DoubleToString(riskMoney,2),
               " — trade RIFIUTATO.");
         return(0.0);
      }
      lot = minLot;
   }
   if(lot > maxLot) lot = maxLot;
   return(lot);
}

//==================================================================
// POSIZIONI (per simbolo + magic)
//==================================================================
bool IsMine(ulong ticket)
{
   if(!PositionSelectByTicket(ticket)) return(false);
   return(PositionGetString(POSITION_SYMBOL) == g_sym &&
          PositionGetInteger(POSITION_MAGIC) == MagicNumber);
}

// dir>0 BUY, dir<0 SELL, dir==0 tutte
int CountPos(int dir)
{
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(!IsMine(t)) continue;
      long pt = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && pt != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && pt != POSITION_TYPE_SELL) continue;
      n++;
   }
   return(n);
}

ulong NewestPos(int dir)
{
   ulong best = 0; datetime bt = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(!IsMine(t)) continue;
      long pt = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && pt != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && pt != POSITION_TYPE_SELL) continue;
      datetime ti = (datetime)PositionGetInteger(POSITION_TIME);
      if(ti >= bt) { bt = ti; best = t; }
   }
   return(best);
}

double OpenRiskPct()
{
   double mpp = MoneyPerPoint();
   double bal = AccountInfoDouble(ACCOUNT_BALANCE);
   if(mpp <= 0.0 || bal <= 0.0) return(0.0);
   double tot = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(!IsMine(t)) continue;
      double sl = PositionGetDouble(POSITION_SL);
      if(sl <= 0.0) continue;
      tot += PositionGetDouble(POSITION_VOLUME) *
             MathAbs(PositionGetDouble(POSITION_PRICE_OPEN) - sl) * mpp;
   }
   return(tot / bal * 100.0);
}

void ClosePos(int dir, string reason)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(!IsMine(t)) continue;
      long pt = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && pt != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && pt != POSITION_TYPE_SELL) continue;
      if(trade.PositionClose(t))
         Print("DAX_ST: CHIUSA ", (pt==POSITION_TYPE_BUY?"BUY":"SELL"),
               " #", t, " (", reason, ")");
      else
         Print("DAX_ST: PositionClose KO #", t, " retcode=", trade.ResultRetcode());
   }
}

//==================================================================
// SUPERTREND manuale (formula standard, su barre chiuse)
//   dir = +1 bull (prezzo sopra ST), -1 bear.
//==================================================================
struct ST
{
   bool   ok;
   int    dir;     // direzione barra chiusa (shift 1)
   int    dirPrev; // direzione barra precedente (shift 2)
   double line;    // linea ST sulla barra chiusa
   double close;   // close barra chiusa
};

ST Supertrend(ENUM_TIMEFRAMES tf, int atrHandle)
{
   ST r; r.ok = false; r.dir = 0; r.dirPrev = 0; r.line = 0; r.close = 0;
   if(atrHandle == INVALID_HANDLE) return(r);

   int n = ST_Lookback; if(n < 50) n = 50;
   double hi[], lo[], cl[], atr[];
   ArraySetAsSeries(hi,false); ArraySetAsSeries(lo,false);
   ArraySetAsSeries(cl,false); ArraySetAsSeries(atr,false);

   // dallo shift 1 = ultima barra chiusa (escludiamo la barra in corso)
   if(CopyHigh (g_sym, tf, 1, n, hi)  < n) return(r);
   if(CopyLow  (g_sym, tf, 1, n, lo)  < n) return(r);
   if(CopyClose(g_sym, tf, 1, n, cl)  < n) return(r);
   if(CopyBuffer(atrHandle, 0, 1, n, atr) < n) return(r);

   double upBand = 0, loBand = 0, pUp = 0, pLo = 0;
   int    dir = 1, pDir = 1;
   int    dirPrev = 1;

   for(int i = 0; i < n; i++)
   {
      double hl2 = (hi[i] + lo[i]) / 2.0;
      double ub  = hl2 + Factor * atr[i];
      double lb  = hl2 - Factor * atr[i];

      if(i == 0) { upBand = ub; loBand = lb; dir = 1; }
      else
      {
         double pc = cl[i-1];
         upBand = (ub < pUp || pc > pUp) ? ub : pUp;
         loBand = (lb > pLo || pc < pLo) ? lb : pLo;
         if(cl[i] > pUp)      dir = 1;
         else if(cl[i] < pLo) dir = -1;
         else                 dir = pDir;
      }

      if(i == n - 1) dirPrev = pDir; // direzione della barra precedente
      pUp = upBand; pLo = loBand; pDir = dir;
   }

   r.dir     = dir;
   r.dirPrev = dirPrev;
   r.line    = (dir == 1) ? loBand : upBand;
   r.close   = cl[n-1];
   r.ok      = true;
   return(r);
}

//==================================================================
// LETTURE EMA / ADX (barra chiusa)
//==================================================================
bool BufVal(int handle, double &v)
{
   if(handle == INVALID_HANDLE) return(false);
   double b[]; ArraySetAsSeries(b, true);
   if(CopyBuffer(handle, 0, 1, 1, b) < 1) return(false);
   v = b[0]; return(true);
}

//==================================================================
// BIAS H4: +1 long, -1 short, 0 neutro
//==================================================================
int Bias()
{
   ST h4 = Supertrend(PERIOD_H4, hAtrH4);
   if(!h4.ok) return(0);

   double ema = 0, adx = 0;
   if(UseEMA && !BufVal(hEmaH4, ema)) return(0);
   if(UseADX && !BufVal(hAdxH4, adx)) return(0);

   bool emaL = !UseEMA || h4.close > ema;
   bool emaS = !UseEMA || h4.close < ema;
   bool adxOk= !UseADX || adx > AdxThreshold;

   if(h4.dir == 1  && emaL && adxOk) return(1);
   if(h4.dir == -1 && emaS && adxOk) return(-1);
   return(0);
}

//==================================================================
// SESSIONE (finestra CET tradotta in ora server)
//==================================================================
int MinOfDay(datetime t) { MqlDateTime d; TimeToStruct(t, d); return(d.hour*60 + d.min); }
int Wrap(int m)          { return(((m % 1440) + 1440) % 1440); }

bool InSession(datetime t)
{
   int off  = ServerToCET * 60;
   int a    = Wrap(SessStartHour*60 + SessStartMin + off);
   int b    = Wrap(SessEndHour*60   + SessEndMin   + off);
   int m    = MinOfDay(t);
   if(a <= b) return(m >= a && m <= b);
   return(m >= a || m <= b);   // finestra a cavallo della mezzanotte
}

bool AfterSessionEnd(datetime t)
{
   int off = ServerToCET * 60;
   int b   = Wrap(SessEndHour*60 + SessEndMin + off);
   return(!InSession(t) && MinOfDay(t) >= b);
}

//==================================================================
// TRAILING SL sulla linea Supertrend (solo a favore)
//==================================================================
void Trail(double line)
{
   if(line <= 0.0) return;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong t = PositionGetTicket(i);
      if(!IsMine(t)) continue;
      long   pt  = PositionGetInteger(POSITION_TYPE);
      double sl  = PositionGetDouble(POSITION_SL);
      double tp  = PositionGetDouble(POSITION_TP);
      double nl  = RoundToTick(line);
      bool   buy = (pt == POSITION_TYPE_BUY);
      if(buy  && sl > 0.0 && nl <= sl) continue;
      if(!buy && sl > 0.0 && nl >= sl) continue;
      trade.PositionModify(t, nl, tp);
   }
}

//==================================================================
// APERTURA trade (con validazione stop + fallback)
//==================================================================
void Open(bool buy, double stLine)
{
   int dir = buy ? 1 : -1;
   if(CountPos(dir) > 0)        return;              // una posizione per direzione
   if(CountPos(0) >= MaxTrades) { Print("DAX_ST: MaxTrades raggiunto."); return; }

   double entry = buy ? SymbolInfoDouble(g_sym, SYMBOL_ASK)
                      : SymbolInfoDouble(g_sym, SYMBOL_BID);
   double sl = stLine;
   if(sl <= 0.0) { Print("DAX_ST: linea ST non valida."); return; }

   // lato corretto + distanza minima del broker
   double minD = MinStopDist();
   if(buy)
   {
      if(sl >= entry) sl = entry - minD;
      if(entry - sl < minD) sl = entry - minD;
   }
   else
   {
      if(sl <= entry) sl = entry + minD;
      if(sl - entry < minD) sl = entry + minD;
   }

   double stopDist = MathAbs(entry - sl);
   if(stopDist <= 0.0) { Print("DAX_ST: stopDist nullo."); return; }

   double lot = RiskLot(stopDist);
   if(lot <= 0.0) return;

   // governance rischio totale
   double mpp = MoneyPerPoint();
   double bal = AccountInfoDouble(ACCOUNT_BALANCE);
   double thisR = (lot * stopDist * mpp) / bal * 100.0;
   if(OpenRiskPct() + thisR > MaxTotalRisk)
   {
      Print("DAX_ST: rischio totale supererebbe ", DoubleToString(MaxTotalRisk,1),
            "% — trade bloccato.");
      return;
   }

   // TP (se RR) con distanza minima garantita
   bool useRR = (ExitMode == EXIT_ST_OPPOSITE_PLUS_RR || ExitMode == EXIT_RR_ONLY);
   double tp = 0.0;
   if(useRR)
   {
      tp = buy ? entry + RR*stopDist : entry - RR*stopDist;
      if(buy  && tp - entry < minD) tp = entry + minD;
      if(!buy && entry - tp < minD) tp = entry - minD;
   }

   sl = RoundToTick(sl);
   tp = (tp > 0.0) ? RoundToTick(tp) : 0.0;

   bool ok = buy ? trade.Buy (lot, g_sym, 0.0, sl, tp, "DAX_ST BUY")
                 : trade.Sell(lot, g_sym, 0.0, sl, tp, "DAX_ST SELL");

   // fallback: invalid stops -> apri nudo poi modifica
   if(!ok && trade.ResultRetcode() == 10016)
   {
      Print("DAX_ST: invalid stops -> apro senza stop e modifico (SL=",
            DoubleToString(sl,g_digits), " TP=", DoubleToString(tp,g_digits),
            " minDist=", DoubleToString(minD,g_digits), ").");
      bool ok2 = buy ? trade.Buy (lot, g_sym, 0.0, 0.0, 0.0, "DAX_ST BUY")
                     : trade.Sell(lot, g_sym, 0.0, 0.0, 0.0, "DAX_ST SELL");
      if(ok2)
      {
         ulong tk = NewestPos(dir);
         if(tk != 0 && trade.PositionModify(tk, sl, tp)) ok = true;
         else Print("DAX_ST: PositionModify KO retcode=", trade.ResultRetcode());
      }
   }

   if(ok)
      Print("DAX_ST ENTRY ", (buy?"BUY":"SELL"), " lot=", DoubleToString(lot,2),
            " entry=", DoubleToString(entry,g_digits),
            " SL=", DoubleToString(sl,g_digits),
            " TP=", (tp>0?DoubleToString(tp,g_digits):"-"),
            " dist=", DoubleToString(stopDist,g_digits));
   else
      Print("DAX_ST: apertura ", (buy?"BUY":"SELL"), " fallita retcode=",
            trade.ResultRetcode(), " ", trade.ResultRetcodeDescription());
}

//==================================================================
// LOGICA su nuova barra
//==================================================================
void OnNewBar()
{
   datetime bt[]; ArraySetAsSeries(bt, true);
   if(CopyTime(g_sym, _Period, 1, 1, bt) < 1) return;
   datetime tClosed = bt[0];

   // chiusura intraday
   if(CloseAtSessEnd && AfterSessionEnd(tClosed))
   {
      if(CountPos(0) > 0) ClosePos(0, "fine sessione");
      return;
   }

   ST cur = Supertrend(_Period, hAtrCur);
   if(!cur.ok) return;

   bool flipL = (cur.dir == 1  && cur.dirPrev <= 0);
   bool flipS = (cur.dir == -1 && cur.dirPrev >= 0);

   // uscite su Supertrend opposto
   if(ExitMode == EXIT_ST_OPPOSITE_PLUS_RR || ExitMode == EXIT_ST_OPPOSITE_ONLY)
   {
      if(flipS && CountPos(1)  > 0) ClosePos(1,  "ST opposto");
      if(flipL && CountPos(-1) > 0) ClosePos(-1, "ST opposto");
   }

   if(TrailWithST) Trail(cur.line);

   // bias + filtri + sessione
   int bias = Bias();
   double ema = 0; bool emaOk = BufVal(hEmaCur, ema);
   if(UseEMA && !emaOk) return;
   bool emaL = !UseEMA || cur.close > ema;
   bool emaS = !UseEMA || cur.close < ema;
   bool sess = InSession(tClosed);

   if(bias == 1  && flipL && emaL && sess) Open(true,  cur.line);
   else if(bias == -1 && flipS && emaS && sess) Open(false, cur.line);
}

//==================================================================
// INIT / DEINIT / TICK
//==================================================================
int OnInit()
{
   g_sym    = _Symbol;
   g_digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   g_point  = SymbolInfoDouble(g_sym, SYMBOL_POINT);
   g_tick   = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);

   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetAsyncMode(false);
   trade.SetTypeFillingBySymbol(g_sym);

   hAtrCur = iATR(g_sym, _Period,   AtrPeriod);
   hAtrH4  = iATR(g_sym, PERIOD_H4, AtrPeriod);
   hEmaCur = iMA (g_sym, _Period,   EmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   hEmaH4  = iMA (g_sym, PERIOD_H4, EmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   hAdxH4  = iADX(g_sym, PERIOD_H4, AdxLen);

   if(hAtrCur==INVALID_HANDLE || hAtrH4==INVALID_HANDLE || hEmaCur==INVALID_HANDLE ||
      hEmaH4==INVALID_HANDLE  || hAdxH4==INVALID_HANDLE)
   { Print("DAX_ST: errore handle indicatori."); return(INIT_FAILED); }

   g_lastBar = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);

   Print("DAX_ST VINCOLI ", g_sym, " digits=", g_digits,
         " tickSize=", DoubleToString(g_tick,5),
         " tickValue=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_TRADE_TICK_VALUE),5),
         " stopsLevel=", (long)SymbolInfoInteger(g_sym,SYMBOL_TRADE_STOPS_LEVEL),
         " freezeLevel=", (long)SymbolInfoInteger(g_sym,SYMBOL_TRADE_FREEZE_LEVEL),
         " volMin=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_VOLUME_MIN),2),
         " volStep=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_VOLUME_STEP),2),
         " minStopDist=", DoubleToString(MinStopDist(),g_digits));
   Print("DAX_ST v2 avviato su ", g_sym, " TF=", EnumToString((ENUM_TIMEFRAMES)_Period),
         " / H4 bias. Factor=", DoubleToString(Factor,2), " ATR=", AtrPeriod,
         " RR=", DoubleToString(RR,2), " ExitMode=", EnumToString(ExitMode));
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   if(hAtrCur!=INVALID_HANDLE) IndicatorRelease(hAtrCur);
   if(hAtrH4 !=INVALID_HANDLE) IndicatorRelease(hAtrH4);
   if(hEmaCur!=INVALID_HANDLE) IndicatorRelease(hEmaCur);
   if(hEmaH4 !=INVALID_HANDLE) IndicatorRelease(hEmaH4);
   if(hAdxH4 !=INVALID_HANDLE) IndicatorRelease(hAdxH4);
}

void OnTick()
{
   datetime cur = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);
   if(cur != g_lastBar) { g_lastBar = cur; OnNewBar(); }
}
//+------------------------------------------------------------------+
