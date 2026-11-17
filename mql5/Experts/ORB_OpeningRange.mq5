//+------------------------------------------------------------------+
//|  ORB_OpeningRange.mq5                                             |
//|  EA Opening Range Breakout (ORB) intraday — versione SEMPLICE.    |
//|                                                                   |
//|  LOGICA (tutto su barre CHIUSE, nessun look-ahead)                |
//|   - OPENING RANGE: nella finestra [ORStart, ORStart+ORMinutes)    |
//|     si traccia max(high)/min(low) delle barre. A fine finestra    |
//|     ORHigh/ORLow vengono CONGELATI per la giornata.               |
//|   - ENTRY: una barra chiusa che CHIUDE sopra ORHigh -> LONG;      |
//|     che CHIUDE sotto ORLow -> SHORT. Solo nella finestra          |
//|     operativa (da fine OR fino a EntryEnd).                       |
//|   - SL = lato opposto dell'OR +/- buffer (validato vs broker);    |
//|     TP = RR * stopDist.                                           |
//|   - Chiusura intraday a fine sessione (CloseAtSessionEnd).        |
//|   - Reset di tutto a ogni nuovo giorno (cambio data).             |
//|                                                                   |
//|  Il TF del grafico E' il TF di lavoro/breakout (inteso M5).       |
//|  Sizing universale via TICK_VALUE/TICK_SIZE. Stop sempre          |
//|  validati contro i vincoli del broker con fallback apri-modifica. |
//|                                                                   |
//|  Helper di sizing/rischio/sessione riusati dal DAX M3 Supertrend. |
//+------------------------------------------------------------------+
#property copyright "Claudio — ORB Opening Range"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

//==================================================================
// INPUT
//==================================================================
input group "=== Opening Range ==="
input int    ORStartHour   = 9;     // Ora inizio OR (CET)
input int    ORStartMin    = 0;     // Min inizio OR (CET)
input int    ORMinutes     = 30;    // Durata Opening Range (minuti)
input int    ServerToCET   = 0;     // Offset: ore_server - ore_CET

input group "=== Finestra operativa ==="
input int    EntryEndHour  = 16;    // Ora fine ingressi (CET)
input int    EntryEndMin   = 30;    // Min fine ingressi (CET)
input int    CloseHour     = 17;    // Ora chiusura intraday (CET)
input int    CloseMin      = 25;    // Min chiusura intraday (CET)
input bool   CloseAtSessionEnd = true; // Chiudi posizioni a fine sessione
input bool   OneTradePerDay = true; // Un solo trade al giorno (entrambe le direzioni)

input group "=== SL / TP / Rischio ==="
input double RR            = 2.0;   // Reward:Risk (TP)
input int    BufferPoints  = 0;     // Buffer SL oltre l'OR (in points)
input double RiskPct       = 1.0;   // Rischio % per trade
input int    MaxTrades     = 3;     // Max trade contemporanei
input double MaxTotalRisk  = 3.0;   // Tetto rischio aperto (%)
input long   MagicNumber   = 20260627;

input group "=== Filtri (opzionali, default OFF) ==="
input bool   UseVolumeFilter = false; // Filtro volume sul breakout
input double VolFactor      = 1.5;   // Volume breakout >= VolFactor * media
input int    VolAvgBars     = 20;    // Barre per la media volume
input bool   UseEmaFilter   = false; // Filtro EMA fast/slow (TF grafico)
input int    EmaFast        = 9;     // EMA veloce
input int    EmaSlow        = 21;    // EMA lenta

//==================================================================
// GLOBALI
//==================================================================
int      hEmaFast = INVALID_HANDLE, hEmaSlow = INVALID_HANDLE;
datetime g_lastBar = 0;
string   g_sym;
int      g_digits;
double   g_point, g_tick;

// stato giornaliero dell'Opening Range
int      g_day = -1, g_mon = -1, g_year = -1; // data corrente tracciata
double   g_orHigh = 0.0, g_orLow = 0.0;       // livelli OR congelati
bool     g_orFormed = false;                  // OR formato e congelato
bool     g_tradeTakenToday = false;           // almeno un trade oggi (OneTradePerDay)
bool     g_longTaken = false, g_shortTaken = false; // per direzione (se !OneTradePerDay)

//==================================================================
// UTILITY prezzo / lotto  (riusate dal DAX M3 Supertrend)
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
      Print("ORB: tickValue/tickSize non validi — trade annullato.");
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
         Print("ORB: lotto minimo (", DoubleToString(minLot,2),
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
// POSIZIONI (per simbolo + magic)  (riusate dal DAX M3 Supertrend)
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
         Print("ORB: CHIUSA ", (pt==POSITION_TYPE_BUY?"BUY":"SELL"),
               " #", t, " (", reason, ")");
      else
         Print("ORB: PositionClose KO #", t, " retcode=", trade.ResultRetcode());
   }
}

//==================================================================
// SESSIONE (minuti dalla mezzanotte, finestra CET -> ora server)
//   (riusate dal DAX M3 Supertrend)
//==================================================================
int MinOfDay(datetime t) { MqlDateTime d; TimeToStruct(t, d); return(d.hour*60 + d.min); }
int Wrap(int m)          { return(((m % 1440) + 1440) % 1440); }

// orario server (in minuti dalla mezzanotte) di un orario CET dato
int CetToServerMin(int hourCet, int minCet)
{
   int off = ServerToCET * 60;   // server = CET + offset
   return(Wrap(hourCet*60 + minCet + off));
}

//==================================================================
// LETTURA EMA (barra chiusa, shift 1)
//==================================================================
bool BufVal(int handle, double &v)
{
   if(handle == INVALID_HANDLE) return(false);
   double b[]; ArraySetAsSeries(b, true);
   if(CopyBuffer(handle, 0, 1, 1, b) < 1) return(false);
   v = b[0]; return(true);
}

//==================================================================
// FILTRO VOLUME: il tick volume della barra di breakout (shift 1)
// deve essere >= VolFactor * media dei VolAvgBars precedenti.
//==================================================================
bool VolumeOk()
{
   if(!UseVolumeFilter) return(true);
   if(VolAvgBars < 1)   return(true);
   long v[]; ArraySetAsSeries(v, true);
   int need = VolAvgBars + 1;                 // shift 1 + le VolAvgBars precedenti
   if(CopyTickVolume(g_sym, _Period, 1, need, v) < need) return(false);
   double sum = 0.0;
   for(int i = 1; i <= VolAvgBars; i++) sum += (double)v[i];
   double avg = sum / (double)VolAvgBars;
   if(avg <= 0.0) return(false);
   return((double)v[0] >= VolFactor * avg);
}

//==================================================================
// APERTURA trade (con validazione stop + fallback)  (stile DAX M3)
//   slRaw = livello SL grezzo (lato opposto OR +/- buffer)
//==================================================================
void Open(bool buy, double slRaw)
{
   int dir = buy ? 1 : -1;
   if(CountPos(dir) > 0)        return;              // una posizione per direzione
   if(CountPos(0) >= MaxTrades) { Print("ORB: MaxTrades raggiunto."); return; }

   double entry = buy ? SymbolInfoDouble(g_sym, SYMBOL_ASK)
                      : SymbolInfoDouble(g_sym, SYMBOL_BID);
   double sl = slRaw;
   if(sl <= 0.0) { Print("ORB: livello SL non valido."); return; }

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
   if(stopDist <= 0.0) { Print("ORB: stopDist nullo."); return; }

   double lot = RiskLot(stopDist);
   if(lot <= 0.0) return;

   // governance rischio totale
   double mpp = MoneyPerPoint();
   double bal = AccountInfoDouble(ACCOUNT_BALANCE);
   double thisR = (lot * stopDist * mpp) / bal * 100.0;
   if(OpenRiskPct() + thisR > MaxTotalRisk)
   {
      Print("ORB: rischio totale supererebbe ", DoubleToString(MaxTotalRisk,1),
            "% — trade bloccato.");
      return;
   }

   // TP = RR * stopDist con distanza minima garantita
   double tp = buy ? entry + RR*stopDist : entry - RR*stopDist;
   if(buy  && tp - entry < minD) tp = entry + minD;
   if(!buy && entry - tp < minD) tp = entry - minD;

   sl = RoundToTick(sl);
   tp = RoundToTick(tp);

   bool ok = buy ? trade.Buy (lot, g_sym, 0.0, sl, tp, "ORB BUY")
                 : trade.Sell(lot, g_sym, 0.0, sl, tp, "ORB SELL");

   // fallback: invalid stops -> apri nudo poi modifica
   if(!ok && trade.ResultRetcode() == 10016)
   {
      Print("ORB: invalid stops -> apro senza stop e modifico (SL=",
            DoubleToString(sl,g_digits), " TP=", DoubleToString(tp,g_digits),
            " minDist=", DoubleToString(minD,g_digits), ").");
      bool ok2 = buy ? trade.Buy (lot, g_sym, 0.0, 0.0, 0.0, "ORB BUY")
                     : trade.Sell(lot, g_sym, 0.0, 0.0, 0.0, "ORB SELL");
      if(ok2)
      {
         ulong tk = NewestPos(dir);
         if(tk != 0 && trade.PositionModify(tk, sl, tp)) ok = true;
         else Print("ORB: PositionModify KO retcode=", trade.ResultRetcode());
      }
   }

   if(ok)
   {
      // segna che il trade odierno e' stato preso
      g_tradeTakenToday = true;
      if(buy) g_longTaken = true; else g_shortTaken = true;
      Print("ORB ENTRY ", (buy?"BUY":"SELL"), " lot=", DoubleToString(lot,2),
            " entry=", DoubleToString(entry,g_digits),
            " SL=", DoubleToString(sl,g_digits),
            " TP=", DoubleToString(tp,g_digits),
            " dist=", DoubleToString(stopDist,g_digits),
            " ORH=", DoubleToString(g_orHigh,g_digits),
            " ORL=", DoubleToString(g_orLow,g_digits));
   }
   else
      Print("ORB: apertura ", (buy?"BUY":"SELL"), " fallita retcode=",
            trade.ResultRetcode(), " ", trade.ResultRetcodeDescription());
}

//==================================================================
// RESET giornaliero
//==================================================================
void ResetDay(const MqlDateTime &d)
{
   g_day = d.day; g_mon = d.mon; g_year = d.year;
   g_orHigh = 0.0; g_orLow = 0.0;
   g_orFormed = false;
   g_tradeTakenToday = false;
   g_longTaken = false; g_shortTaken = false;
}

//==================================================================
// LOGICA su nuova barra (valutata sulla barra CHIUSA shift 1)
//==================================================================
void OnNewBar()
{
   // dati della barra appena chiusa (shift 1)
   datetime bt[]; double bh[], bl[], bc[];
   ArraySetAsSeries(bt,true); ArraySetAsSeries(bh,true);
   ArraySetAsSeries(bl,true); ArraySetAsSeries(bc,true);
   if(CopyTime (g_sym, _Period, 1, 1, bt) < 1) return;
   if(CopyHigh (g_sym, _Period, 1, 1, bh) < 1) return;
   if(CopyLow  (g_sym, _Period, 1, 1, bl) < 1) return;
   if(CopyClose(g_sym, _Period, 1, 1, bc) < 1) return;

   datetime tClosed = bt[0];
   double   hi = bh[0], lo = bl[0], cl = bc[0];

   MqlDateTime d; TimeToStruct(tClosed, d);

   // cambio data -> reset completo dello stato giornaliero
   if(d.day != g_day || d.mon != g_mon || d.year != g_year)
      ResetDay(d);

   int m       = MinOfDay(tClosed);
   int orStart = CetToServerMin(ORStartHour, ORStartMin);
   int orEnd   = Wrap(orStart + ORMinutes);
   int entEnd  = CetToServerMin(EntryEndHour, EntryEndMin);
   int closeM  = CetToServerMin(CloseHour, CloseMin);

   // distanza in minuti dall'inizio OR, gestendo il cavallo di mezzanotte
   int sinceStart = Wrap(m - orStart);

   //--------------------------------------------------------------
   // 1) CHIUSURA INTRADAY: a/dopo l'orario di chiusura, flat + stop
   //    (dopo questo orario niente nuovi ingressi)
   //--------------------------------------------------------------
   int sinceClose = Wrap(m - closeM);
   // "siamo a/dopo l'orario di chiusura" entro la finestra operativa odierna:
   // sinceClose piccolo significa appena passato closeM; usiamo la finestra
   // [closeM, orStart) come zona di fine giornata.
   bool afterClose = (Wrap(closeM - orStart) <= sinceStart);
   if(afterClose)
   {
      if(CloseAtSessionEnd && CountPos(0) > 0) ClosePos(0, "fine sessione");
      return;   // niente ingressi dopo la chiusura
   }

   //--------------------------------------------------------------
   // 2) FORMAZIONE OPENING RANGE: durante [orStart, orStart+ORMinutes)
   //--------------------------------------------------------------
   bool inORWindow = (sinceStart < ORMinutes);
   if(inORWindow)
   {
      if(g_orHigh == 0.0 || hi > g_orHigh) g_orHigh = hi;
      if(g_orLow  == 0.0 || lo < g_orLow)  g_orLow  = lo;
      return;   // durante la formazione non si opera
   }

   // a finestra terminata, se abbiamo dati validi, congela l'OR
   if(!g_orFormed)
   {
      if(g_orHigh > 0.0 && g_orLow > 0.0 && g_orHigh > g_orLow)
         g_orFormed = true;
      else
         return; // OR non valido (es. avvio a meta' giornata): niente trade oggi
   }

   //--------------------------------------------------------------
   // 3) FINESTRA OPERATIVA: da fine OR fino a EntryEnd (CET)
   //--------------------------------------------------------------
   int sinceOrEnd = Wrap(m - orEnd);
   int entEndFromEnd = Wrap(entEnd - orEnd);
   bool inTradeWindow = (sinceOrEnd <= entEndFromEnd);
   if(!inTradeWindow) return;

   //--------------------------------------------------------------
   // 4) ONE TRADE PER DAY / per direzione
   //--------------------------------------------------------------
   if(OneTradePerDay && g_tradeTakenToday) return;

   //--------------------------------------------------------------
   // 5) SEGNALE: chiusura strettamente oltre l'OR
   //--------------------------------------------------------------
   bool wantLong  = (cl > g_orHigh);
   bool wantShort = (cl < g_orLow);
   if(!wantLong && !wantShort) return;

   // se !OneTradePerDay, una sola entrata per direzione
   if(!OneTradePerDay)
   {
      if(wantLong  && g_longTaken)  wantLong  = false;
      if(wantShort && g_shortTaken) wantShort = false;
      if(!wantLong && !wantShort) return;
   }

   //--------------------------------------------------------------
   // 6) FILTRI OPZIONALI (default OFF)
   //--------------------------------------------------------------
   if(!VolumeOk()) return;

   if(UseEmaFilter)
   {
      double ef = 0.0, es = 0.0;
      if(!BufVal(hEmaFast, ef) || !BufVal(hEmaSlow, es)) return;
      if(wantLong  && !(cl > ef && cl > es && ef >= es)) return;
      if(wantShort && !(cl < ef && cl < es && ef <= es)) return;
   }

   //--------------------------------------------------------------
   // 7) APERTURA: SL = lato opposto dell'OR +/- buffer
   //--------------------------------------------------------------
   double buf = BufferPoints * g_point;
   if(wantLong)
      Open(true,  g_orLow  - buf);   // long SL = ORLow - buffer
   else if(wantShort)
      Open(false, g_orHigh + buf);   // short SL = ORHigh + buffer
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

   if(UseEmaFilter)
   {
      hEmaFast = iMA(g_sym, _Period, EmaFast, 0, MODE_EMA, PRICE_CLOSE);
      hEmaSlow = iMA(g_sym, _Period, EmaSlow, 0, MODE_EMA, PRICE_CLOSE);
      if(hEmaFast == INVALID_HANDLE || hEmaSlow == INVALID_HANDLE)
      { Print("ORB: errore handle EMA."); return(INIT_FAILED); }
   }

   g_lastBar = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);

   Print("ORB VINCOLI ", g_sym, " digits=", g_digits,
         " tickSize=", DoubleToString(g_tick,5),
         " tickValue=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_TRADE_TICK_VALUE),5),
         " stopsLevel=", (long)SymbolInfoInteger(g_sym,SYMBOL_TRADE_STOPS_LEVEL),
         " freezeLevel=", (long)SymbolInfoInteger(g_sym,SYMBOL_TRADE_FREEZE_LEVEL),
         " volMin=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_VOLUME_MIN),2),
         " volStep=", DoubleToString(SymbolInfoDouble(g_sym,SYMBOL_VOLUME_STEP),2),
         " minStopDist=", DoubleToString(MinStopDist(),g_digits));
   Print("ORB avviato su ", g_sym, " TF=", EnumToString((ENUM_TIMEFRAMES)_Period),
         " OR=", ORStartHour, ":", ORStartMin, " +", ORMinutes, "min (CET)",
         " RR=", DoubleToString(RR,2),
         " OneTradePerDay=", (OneTradePerDay?"true":"false"),
         " ServerToCET=", ServerToCET);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   if(hEmaFast != INVALID_HANDLE) IndicatorRelease(hEmaFast);
   if(hEmaSlow != INVALID_HANDLE) IndicatorRelease(hEmaSlow);
}

void OnTick()
{
   datetime cur = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);
   if(cur != g_lastBar) { g_lastBar = cur; OnNewBar(); }
}
//+------------------------------------------------------------------+
