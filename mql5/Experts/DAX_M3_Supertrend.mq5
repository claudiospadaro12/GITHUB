//+------------------------------------------------------------------+
//| DAX_M3_Supertrend.mq5                                            |
//| Trend-following intraday EA — "DAX M3 Supertrend".               |
//|                                                                  |
//| Multi-timeframe Supertrend strategy (replica di una strategia    |
//| Pine validata):                                                  |
//|  - BIAS primario su H4: Supertrend H4 + EMA200 H4 + ADX H4.      |
//|  - TRIGGER su timeframe del grafico (inteso M3): flip del        |
//|    Supertrend nella direzione del bias, con filtro EMA200 e      |
//|    gate di sessione oraria.                                      |
//|  - SL = linea Supertrend del TF corrente; TP = RR * stopDist.    |
//|  - Uscita: Supertrend opposto e/o RR (ExitMode).                 |
//|                                                                  |
//| Supertrend implementato MANUALMENTE (formula standard,           |
//| equivalente a ta.supertrend di TradingView) su barre CHIUSE.     |
//|                                                                  |
//| UNIVERSALE per il sizing: nessun pip/contract/tickvalue          |
//| hardcoded — il valore monetario deriva da                        |
//| SYMBOL_TRADE_TICK_VALUE / SYMBOL_TRADE_TICK_SIZE.                |
//|                                                                  |
//| NB: il timeframe del grafico E' il timeframe di entrata.         |
//|     Per replicare "M3" aprire l'EA su un grafico M3.             |
//|     L'H4 e' fisso per il bias.                                   |
//+------------------------------------------------------------------+
#property copyright "Claudio — DAX M3 Supertrend"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

//==================================================================
// ENUM ExitMode
//==================================================================
enum ENUM_EXIT_MODE
{
   EXIT_ST_OPPOSITE_PLUS_RR = 0,   // Supertrend opposto + RR (TP)
   EXIT_RR_ONLY             = 1,   // Solo RR (TP)
   EXIT_ST_OPPOSITE_ONLY    = 2    // Solo Supertrend opposto
};

//==================================================================
// INPUT — Supertrend
//==================================================================
input group "=== Supertrend ==="
input double Factor              = 3.5;        // Supertrend Factor (moltiplicatore ATR)
input int    AtrPeriod           = 10;         // Supertrend ATR period
input int    ST_Lookback         = 300;        // Barre di lookback per stabilizzare la ricorsione

//==================================================================
// INPUT — Bias H4 (filtro primario)
//==================================================================
input group "=== Bias H4 ==="
input bool   UseEMA              = true;       // Usa filtro EMA200
input bool   UseADX              = true;       // Usa filtro ADX
input int    EmaPeriod           = 200;        // Periodo EMA (H4 e TF corrente)
input int    AdxLen              = 14;         // ADX length (H4)
input double AdxThreshold        = 25.0;       // ADX soglia minima per trend

//==================================================================
// INPUT — Sessione / Orario (interpretati come CET)
//==================================================================
input group "=== Sessione / Orario (CET) ==="
input int    SessionStartHour    = 9;          // Ora inizio sessione (CET)
input int    SessionStartMin     = 30;         // Min inizio sessione (CET)
input int    SessionEndHour      = 17;         // Ora fine sessione (CET)
input int    SessionEndMin       = 30;         // Min fine sessione (CET)
// L'ora del server MT5 spesso differisce dal CET. Impostare questo
// offset perche' la sessione si allinei al CET.
// effective_server_time = CET_time + ServerToCET_OffsetHours
// Es: se il server e' GMT+2 (estate) e il CET e' GMT+1, allora il
// server e' 1h AVANTI rispetto al CET => offset = +1.
// (Generalizzando: offset = ore_server - ore_CET.)
input int    ServerToCET_OffsetHours = 0;      // Offset ore: server_time - CET_time
input bool   CloseAtSessionEnd   = true;       // Chiudi tutte le posizioni EA a fine sessione

//==================================================================
// INPUT — Uscita / SL / TP
//==================================================================
input group "=== Uscita / SL / TP ==="
input ENUM_EXIT_MODE ExitMode    = EXIT_ST_OPPOSITE_PLUS_RR; // Modalita' di uscita
input double RR                  = 1.5;        // Reward:Risk per il TP
input bool   TrailWithST         = false;      // Trascina lo SL sulla linea Supertrend

//==================================================================
// INPUT — Rischio / Gestione
//==================================================================
input group "=== Rischio / Gestione ==="
input double RiskPct             = 1.0;        // Rischio % del balance per trade
input int    MaxConcurrentTrades = 3;          // Max trade aperti contemporanei
input double MaxTotalRiskPct     = 3.0;        // Tetto rischio totale aperto (%)
input long   MagicNumber         = 20260626;   // Magic Number

//==================================================================
// Globali
//==================================================================
int      hAtrCur   = INVALID_HANDLE;   // ATR sul TF corrente
int      hAtrH4    = INVALID_HANDLE;   // ATR su H4
int      hEmaCur   = INVALID_HANDLE;   // EMA200 sul TF corrente
int      hEmaH4    = INVALID_HANDLE;   // EMA200 su H4
int      hAdxH4    = INVALID_HANDLE;   // ADX su H4

datetime g_lastBar = 0;
string   g_sym;
int      g_digits;
double   g_point;

//==================================================================
// LOT SIZING UNIVERSALE  (riuso verbatim da HARSI_Assistant)
//------------------------------------------------------------------
// moneyPerLotPerPricePoint = tickValue / tickSize
//   = valore in valuta-conto di un movimento di 1.0 unita' di
//     prezzo, per 1 lotto. Funziona su FX/indici/commodity perche'
//     deriva il valore dal tick value/size del simbolo stesso.
// rawLot = riskMoney / (stopDistancePrice * moneyPerLotPerPricePoint)
// Poi clamp a MIN/MAX e arrotondamento DOWN allo STEP.
//==================================================================
double MoneyPerLotPerPricePoint()
{
   double tickValue = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0.0 || tickValue <= 0.0)
      return(0.0);
   return(tickValue / tickSize);
}

double RoundDownToStep(double lot)
{
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   if(step <= 0.0) step = 0.01;
   double r = MathFloor(lot / step) * step;
   // normalizza per evitare residui float
   int lotDigits = (int)MathRound(MathLog10(1.0 / step));
   if(lotDigits < 0) lotDigits = 0;
   return(NormalizeDouble(r, lotDigits));
}

//------------------------------------------------------------------
// Arrotonda un prezzo al tick size del simbolo (evita "invalid
// stops" da prezzi non allineati al tick del broker).
//------------------------------------------------------------------
double RoundToTick(double price)
{
   double tick = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tick <= 0.0) return(NormalizeDouble(price, g_digits));
   double r = MathRound(price / tick) * tick;
   return(NormalizeDouble(r, g_digits));
}

//------------------------------------------------------------------
// Distanza minima richiesta dal broker per SL/TP dal prezzo
// corrente (stops level / freeze level) + 1 tick di margine.
//------------------------------------------------------------------
double MinStopDistance()
{
   long stopsLvl  = SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL);
   long freezeLvl = SymbolInfoInteger(g_sym, SYMBOL_TRADE_FREEZE_LEVEL);
   double tick = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tick <= 0.0) tick = g_point;
   double minPts = (double)MathMax(stopsLvl, freezeLvl);
   return(minPts * g_point + tick);
}

//------------------------------------------------------------------
// Calcola il lotto a rischio. Ritorna 0 (e Print) se nemmeno il
// lotto minimo rispetta il budget di rischio.
//------------------------------------------------------------------
double CalcRiskLot(double stopDistancePrice, double riskPct)
{
   if(stopDistancePrice <= 0.0)
      return(0.0);

   double mppp = MoneyPerLotPerPricePoint();
   if(mppp <= 0.0)
   {
      Print("DAX_ST: tickValue/tickSize non validi su ", g_sym, " — trade annullato.");
      return(0.0);
   }

   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * riskPct / 100.0;
   double rawLot    = riskMoney / (stopDistancePrice * mppp);

   double minLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);

   double lot = RoundDownToStep(rawLot);
   if(lot < minLot)
   {
      // verifica se il lotto MINIMO rispetta il budget di rischio
      double minRisk = minLot * stopDistancePrice * mppp;
      if(minRisk > riskMoney)
      {
         Print("DAX_ST: il lotto minimo (", DoubleToString(minLot,2),
               ") rischia ", DoubleToString(minRisk,2),
               " > budget ", DoubleToString(riskMoney,2),
               " — trade RIFIUTATO.");
         return(0.0);
      }
      lot = minLot;
   }
   if(lot > maxLot) lot = maxLot;

   return(lot);
}

//==================================================================
// GOVERNANCE RISCHIO  (riuso verbatim da HARSI_Assistant)
//------------------------------------------------------------------
// Somma del rischio aperto di tutte le posizioni dell'EA-symbol:
//   rischio = volume * |open - SL| * moneyPerLotPerPricePoint
//==================================================================
double CurrentOpenRiskPct()
{
   double mppp = MoneyPerLotPerPricePoint();
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   if(mppp <= 0.0 || bal <= 0.0)
      return(0.0);

   double total = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;

      double vol = PositionGetDouble(POSITION_VOLUME);
      double op  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl  = PositionGetDouble(POSITION_SL);
      if(sl <= 0.0) continue; // senza SL non quantifichiamo
      total += vol * MathAbs(op - sl) * mppp;
   }
   return(total / bal * 100.0);
}

int CountSymbolPositions()
{
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) == g_sym) n++;
   }
   return(n);
}

//------------------------------------------------------------------
// Conta le posizioni dell'EA (questo Magic) sul simbolo, per
// direzione. dir>0 = BUY, dir<0 = SELL, dir==0 = tutte.
//------------------------------------------------------------------
int CountEAPositions(int dir)
{
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      long ptype = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && ptype != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && ptype != POSITION_TYPE_SELL) continue;
      n++;
   }
   return(n);
}

//------------------------------------------------------------------
// Ticket della posizione EA piu' recente di una direzione (per il
// fallback "apri senza stop poi modifica").
//------------------------------------------------------------------
ulong NewestEAPositionTicket(int dir)
{
   ulong    best = 0;
   datetime bestTime = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;
      long ptype = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && ptype != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && ptype != POSITION_TYPE_SELL) continue;
      datetime t = (datetime)PositionGetInteger(POSITION_TIME);
      if(t >= bestTime) { bestTime = t; best = ticket; }
   }
   return(best);
}

//==================================================================
// SUPERTREND — implementazione manuale (formula standard,
// equivalente a ta.supertrend di TradingView).
//------------------------------------------------------------------
// Si ricostruisce la ricorsione su un blocco di barre per
// stabilizzarla, partendo dalla barra piu' vecchia disponibile.
//
// Per ogni barra i:
//   hl2        = (high[i]+low[i])/2
//   upperBasic = hl2 + Factor*atr[i]
//   lowerBasic = hl2 - Factor*atr[i]
//   upperBand[i] = (upperBasic < upperBand[i-1] || close[i-1] > upperBand[i-1])
//                  ? upperBasic : upperBand[i-1]
//   lowerBand[i] = (lowerBasic > lowerBand[i-1] || close[i-1] < lowerBand[i-1])
//                  ? lowerBasic : lowerBand[i-1]
//   dir: +1 bull (prezzo SOPRA lo Supertrend), -1 bear.
//     if close[i] > upperBand[i-1] -> dir=+1
//     else if close[i] < lowerBand[i-1] -> dir=-1
//     else dir = dir[i-1]   (con reset delle bande)
//   supertrend = (dir==+1) ? lowerBand[i] : upperBand[i]
//
// Risultato: direzione e linea sulla barra appena CHIUSA (shift 1)
// e direzione sulla barra precedente (shift 2), per rilevare il flip.
//==================================================================
struct ST_Result
{
   bool   valid;
   int    dirClosed;    // direzione barra chiusa (shift 1): +1 / -1
   int    dirPrev;      // direzione barra precedente (shift 2): +1 / -1
   double lineClosed;   // linea Supertrend sulla barra chiusa (shift 1)
   double closeClosed;  // close della barra chiusa (shift 1)
};

//------------------------------------------------------------------
// Calcola lo Supertrend per un dato timeframe + handle ATR.
// Le serie price sono in ordine cronologico (index 0 = piu' vecchia).
//------------------------------------------------------------------
bool ComputeSupertrend(ENUM_TIMEFRAMES tf, int atrHandle, int lookback, ST_Result &res)
{
   res.valid = false;
   if(atrHandle == INVALID_HANDLE) return(false);
   if(lookback < 5) lookback = 5;

   // Servono almeno lookback barre chiuse + le 2 da valutare (shift 1 e 2).
   // Copiamo a partire dallo shift 1 (escludiamo la barra in formazione, shift 0).
   int count = lookback;

   double high[], low[], close[], atr[];
   // NON come serie: vogliamo index 0 = piu' VECCHIA per la ricorsione.
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);
   ArraySetAsSeries(atr,   false);

   // CopyXxx(symbol, tf, start_pos=1, count): start_pos=1 -> ultima barra CHIUSA.
   if(CopyHigh (g_sym, tf, 1, count, high)  < count) return(false);
   if(CopyLow  (g_sym, tf, 1, count, low)   < count) return(false);
   if(CopyClose(g_sym, tf, 1, count, close) < count) return(false);
   if(CopyBuffer(atrHandle, 0, 1, count, atr) < count) return(false);

   // Dopo la copia non-serie: index (count-1) = barra piu' RECENTE = shift 1.
   // index (count-2) = shift 2.
   int n = count;

   double upperBand = 0.0, lowerBand = 0.0;
   int    dir = 1;            // direzione iniziale
   double prevUpper = 0.0, prevLower = 0.0;
   int    prevDir = 1;

   double dirAt[];            // memorizza la direzione per ogni index
   double lineAt[];
   ArrayResize(dirAt, n);
   ArrayResize(lineAt, n);

   for(int i = 0; i < n; i++)
   {
      double hl2        = (high[i] + low[i]) / 2.0;
      double upperBasic = hl2 + Factor * atr[i];
      double lowerBasic = hl2 - Factor * atr[i];

      if(i == 0)
      {
         upperBand = upperBasic;
         lowerBand = lowerBasic;
         dir       = 1;          // seed bullish (verra' corretto dalle barre seguenti)
      }
      else
      {
         double prevClose = close[i-1];

         // banda superiore
         if(upperBasic < prevUpper || prevClose > prevUpper)
            upperBand = upperBasic;
         else
            upperBand = prevUpper;

         // banda inferiore
         if(lowerBasic > prevLower || prevClose < prevLower)
            lowerBand = lowerBasic;
         else
            lowerBand = prevLower;

         // direzione (con riferimento alle bande della barra precedente)
         if(close[i] > prevUpper)
            dir = 1;
         else if(close[i] < prevLower)
            dir = -1;
         else
            dir = prevDir;
      }

      double line = (dir == 1) ? lowerBand : upperBand;
      dirAt[i]  = (double)dir;
      lineAt[i] = line;

      prevUpper = upperBand;
      prevLower = lowerBand;
      prevDir   = dir;
   }

   res.dirClosed   = (int)dirAt[n-1];
   res.dirPrev     = (n >= 2) ? (int)dirAt[n-2] : (int)dirAt[n-1];
   res.lineClosed  = lineAt[n-1];
   res.closeClosed = close[n-1];
   res.valid       = true;
   return(true);
}

//==================================================================
// LETTURE INDICATORI helper
//==================================================================
bool ReadEMA(int handle, double &valClosed)
{
   if(handle == INVALID_HANDLE) return(false);
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(handle, 0, 1, 1, buf) < 1) return(false);
   valClosed = buf[0];
   return(true);
}

bool ReadADX(int handle, double &valClosed)
{
   if(handle == INVALID_HANDLE) return(false);
   double buf[];
   ArraySetAsSeries(buf, true);
   // buffer 0 = ADX main line
   if(CopyBuffer(handle, 0, 1, 1, buf) < 1) return(false);
   valClosed = buf[0];
   return(true);
}

//==================================================================
// BIAS H4
//   biasLong  = ST_H4 dir == +1 AND close_H4 > EMA200_H4 AND ADX_H4 > thr
//   biasShort = ST_H4 dir == -1 AND close_H4 < EMA200_H4 AND ADX_H4 > thr
//   else NEUTRO
// Ritorna: +1 long, -1 short, 0 neutro.
//==================================================================
int ComputeBias()
{
   ST_Result stH4;
   if(!ComputeSupertrend(PERIOD_H4, hAtrH4, ST_Lookback, stH4))
      return(0);

   double emaH4 = 0.0;
   if(UseEMA && !ReadEMA(hEmaH4, emaH4))
      return(0);

   double adxH4 = 0.0;
   if(UseADX && !ReadADX(hAdxH4, adxH4))
      return(0);

   bool emaOkLong  = (!UseEMA) || (stH4.closeClosed > emaH4);
   bool emaOkShort = (!UseEMA) || (stH4.closeClosed < emaH4);
   bool adxOk      = (!UseADX) || (adxH4 > AdxThreshold);

   if(stH4.dirClosed == 1  && emaOkLong  && adxOk) return(1);
   if(stH4.dirClosed == -1 && emaOkShort && adxOk) return(-1);
   return(0);
}

//==================================================================
// SESSIONE — true se l'ora-del-giorno (server) della barra rientra
// nella finestra di sessione CET tradotta in ora server.
//------------------------------------------------------------------
// La sessione e' definita in CET. La traduciamo in minuti-del-giorno
// server: server = CET + offset. Confrontiamo con i minuti-del-giorno
// della barra (gia' in ora server).
//==================================================================
bool InSession(datetime barTime)
{
   MqlDateTime dt;
   TimeToStruct(barTime, dt);
   int barMinOfDay = dt.hour * 60 + dt.min;

   int offMin   = ServerToCET_OffsetHours * 60;
   int startCET = SessionStartHour * 60 + SessionStartMin;
   int endCET   = SessionEndHour   * 60 + SessionEndMin;

   // Converti la finestra CET in ora server e normalizza in [0,1440).
   int startSrv = ((startCET + offMin) % 1440 + 1440) % 1440;
   int endSrv   = ((endCET   + offMin) % 1440 + 1440) % 1440;

   if(startSrv <= endSrv)
      return(barMinOfDay >= startSrv && barMinOfDay <= endSrv);
   else
      // finestra che attraversa la mezzanotte (server)
      return(barMinOfDay >= startSrv || barMinOfDay <= endSrv);
}

//------------------------------------------------------------------
// True se l'ora della barra e' a/oltre la fine sessione (per la
// chiusura intraday).
//------------------------------------------------------------------
bool AtOrAfterSessionEnd(datetime barTime)
{
   MqlDateTime dt;
   TimeToStruct(barTime, dt);
   int barMinOfDay = dt.hour * 60 + dt.min;

   int offMin = ServerToCET_OffsetHours * 60;
   int endCET = SessionEndHour * 60 + SessionEndMin;
   int endSrv = ((endCET + offMin) % 1440 + 1440) % 1440;

   // Consideriamo "fuori sessione" quando non e' piu' InSession e
   // l'ora ha raggiunto/superato la fine. Per semplicita': se NON in
   // sessione -> chiudibile.
   return(!InSession(barTime) && barMinOfDay >= endSrv);
}

//==================================================================
// CHIUSURA posizioni EA
//==================================================================
void CloseAllEAPositions(string reason)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      long   ptype = PositionGetInteger(POSITION_TYPE);
      double vol   = PositionGetDouble(POSITION_VOLUME);
      if(trade.PositionClose(ticket))
         Print("DAX_ST: CHIUSA ", (ptype == POSITION_TYPE_BUY ? "BUY" : "SELL"),
               " ticket=", ticket, " vol=", DoubleToString(vol,2),
               " motivo=", reason);
      else
         Print("DAX_ST: PositionClose fallita ticket ", ticket,
               " retcode=", trade.ResultRetcode(), " ",
               trade.ResultRetcodeDescription());
   }
}

//------------------------------------------------------------------
// Chiudi le sole posizioni EA di una data direzione.
// dir>0 chiude i BUY, dir<0 chiude i SELL.
//------------------------------------------------------------------
void CloseEADirection(int dir, string reason)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      long ptype = PositionGetInteger(POSITION_TYPE);
      if(dir > 0 && ptype != POSITION_TYPE_BUY)  continue;
      if(dir < 0 && ptype != POSITION_TYPE_SELL) continue;

      double vol = PositionGetDouble(POSITION_VOLUME);
      if(trade.PositionClose(ticket))
         Print("DAX_ST: CHIUSA ", (ptype == POSITION_TYPE_BUY ? "BUY" : "SELL"),
               " ticket=", ticket, " vol=", DoubleToString(vol,2),
               " motivo=", reason);
      else
         Print("DAX_ST: PositionClose fallita ticket ", ticket,
               " retcode=", trade.ResultRetcode());
   }
}

//------------------------------------------------------------------
// Trascina lo SL di tutte le posizioni EA sulla linea Supertrend
// del TF corrente (solo se migliora, mai peggiora).
//------------------------------------------------------------------
void TrailStops(double stLine)
{
   if(stLine <= 0.0) return;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;
      if(PositionGetInteger(POSITION_MAGIC) != MagicNumber) continue;

      long   ptype = PositionGetInteger(POSITION_TYPE);
      double curSL = PositionGetDouble(POSITION_SL);
      double curTP = PositionGetDouble(POSITION_TP);
      double newSL = NormalizeDouble(stLine, g_digits);

      bool isBuy = (ptype == POSITION_TYPE_BUY);
      // muovi solo nella direzione favorevole
      if(isBuy)
      {
         if(curSL > 0.0 && newSL <= curSL) continue;
      }
      else
      {
         if(curSL > 0.0 && newSL >= curSL) continue;
      }

      if(!trade.PositionModify(ticket, newSL, curTP))
         Print("DAX_ST: trailing PositionModify fallita ticket ", ticket,
               " retcode=", trade.ResultRetcode());
      else
         Print("DAX_ST: trailing SL -> ", DoubleToString(newSL,g_digits),
               " ticket=", ticket);
   }
}

//==================================================================
// APERTURA trade
//==================================================================
void OpenTrade(bool isBuy, double stLine)
{
   // pyramiding: una sola posizione per direzione
   int dir = isBuy ? 1 : -1;
   if(CountEAPositions(dir) > 0)
      return;

   // limite trade concorrenti
   if(CountSymbolPositions() >= MaxConcurrentTrades)
   {
      Print("DAX_ST: raggiunto MaxConcurrentTrades (", MaxConcurrentTrades,
            ") — nessun nuovo trade.");
      return;
   }

   double ask = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid = SymbolInfoDouble(g_sym, SYMBOL_BID);
   double entry = isBuy ? ask : bid;

   // SL = linea Supertrend del TF corrente
   double sl = stLine;
   if(sl <= 0.0)
   {
      Print("DAX_ST: linea Supertrend non valida — trade annullato.");
      return;
   }

   // Coerenza: per un long lo SL deve stare sotto l'entry, per uno
   // short sopra. Se la linea e' dal lato sbagliato (es. prezzo gia'
   // mosso oltre), annulla per sicurezza.
   if(isBuy && sl >= entry)
   {
      Print("DAX_ST: SL (", DoubleToString(sl,g_digits),
            ") non sotto l'entry BUY (", DoubleToString(entry,g_digits),
            ") — trade annullato.");
      return;
   }
   if(!isBuy && sl <= entry)
   {
      Print("DAX_ST: SL (", DoubleToString(sl,g_digits),
            ") non sopra l'entry SELL (", DoubleToString(entry,g_digits),
            ") — trade annullato.");
      return;
   }

   //--- rispetta la distanza minima del broker: allarga SL se troppo vicino
   double minDist = MinStopDistance();
   if(isBuy)
   {
      if(entry - sl < minDist) sl = entry - minDist;
   }
   else
   {
      if(sl - entry < minDist) sl = entry + minDist;
   }

   double stopDistance = MathAbs(entry - sl);
   if(stopDistance <= 0.0)
   {
      Print("DAX_ST: distanza SL nulla — trade annullato.");
      return;
   }

   double lot = CalcRiskLot(stopDistance, RiskPct);
   if(lot <= 0.0)
      return; // gia' loggato

   // governance rischio totale
   double mppp = MoneyPerLotPerPricePoint();
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   double thisRiskPct = (lot * stopDistance * mppp) / bal * 100.0;
   if(CurrentOpenRiskPct() + thisRiskPct > MaxTotalRiskPct)
   {
      Print("DAX_ST: rischio totale aperto (", DoubleToString(CurrentOpenRiskPct(),2),
            "%) + nuovo (", DoubleToString(thisRiskPct,2),
            "%) supererebbe MaxTotalRiskPct (", DoubleToString(MaxTotalRiskPct,2),
            "%) — trade BLOCCATO.");
      return;
   }

   // TP solo se la modalita' usa RR (con distanza minima garantita)
   bool useRR = (ExitMode == EXIT_ST_OPPOSITE_PLUS_RR || ExitMode == EXIT_RR_ONLY);
   double tp = 0.0;
   if(useRR)
   {
      tp = isBuy ? entry + RR * stopDistance
                 : entry - RR * stopDistance;
      if(isBuy  && (tp - entry) < minDist) tp = entry + minDist;
      if(!isBuy && (entry - tp) < minDist) tp = entry - minDist;
   }

   sl = RoundToTick(sl);
   tp = (tp > 0.0) ? RoundToTick(tp) : 0.0;

   bool ok;
   if(isBuy)
      ok = trade.Buy(lot, g_sym, 0.0, sl, tp, "DAX_ST BUY");
   else
      ok = trade.Sell(lot, g_sym, 0.0, sl, tp, "DAX_ST SELL");

   //--- fallback: se "invalid stops" (10016), apri senza stop e poi modifica
   if(!ok && trade.ResultRetcode() == 10016)
   {
      Print("DAX_ST: invalid stops (entry=", DoubleToString(entry,g_digits),
            " SL=", DoubleToString(sl,g_digits), " TP=", DoubleToString(tp,g_digits),
            " minDist=", DoubleToString(minDist,g_digits),
            ") -> riprovo senza stop + PositionModify.");
      bool ok2 = isBuy ? trade.Buy(lot, g_sym, 0.0, 0.0, 0.0, "DAX_ST BUY")
                       : trade.Sell(lot, g_sym, 0.0, 0.0, 0.0, "DAX_ST SELL");
      if(ok2)
      {
         ulong tk = NewestEAPositionTicket(isBuy ? 1 : -1);
         if(tk != 0 && trade.PositionModify(tk, sl, tp))
            ok = true;
         else
            Print("DAX_ST: PositionModify post-apertura fallita. retcode=",
                  trade.ResultRetcode(), " ", trade.ResultRetcodeDescription());
      }
   }

   if(!ok)
      Print("DAX_ST: apertura ", (isBuy ? "BUY" : "SELL"),
            " fallita. retcode=", trade.ResultRetcode(), " ",
            trade.ResultRetcodeDescription());
   else
      Print("DAX_ST ENTRY ", (isBuy ? "BUY" : "SELL"),
            " lot=", DoubleToString(lot,2),
            " entry=", DoubleToString(entry,g_digits),
            " SL=", DoubleToString(sl,g_digits),
            " TP=", (tp > 0.0 ? DoubleToString(tp,g_digits) : "none"),
            " stopDist=", DoubleToString(stopDistance,g_digits),
            " ExitMode=", EnumToString(ExitMode));
}

//==================================================================
// Logica per nuova barra (TF corrente)
//==================================================================
void OnNewBar()
{
   // tempo della barra appena chiusa (shift 1)
   datetime barTime[];
   ArraySetAsSeries(barTime, true);
   if(CopyTime(g_sym, _Period, 1, 1, barTime) < 1) return;
   datetime tClosed = barTime[0];

   //--- chiusura intraday a fine sessione
   if(CloseAtSessionEnd && AtOrAfterSessionEnd(tClosed))
   {
      if(CountEAPositions(0) > 0)
         CloseAllEAPositions("fine sessione");
      return; // niente nuove entrate fuori sessione
   }

   //--- Supertrend TF corrente
   ST_Result stCur;
   if(!ComputeSupertrend(_Period, hAtrCur, ST_Lookback, stCur))
      return;

   //--- gestione uscite Supertrend opposto (su posizioni aperte)
   bool exitOnST = (ExitMode == EXIT_ST_OPPOSITE_PLUS_RR ||
                    ExitMode == EXIT_ST_OPPOSITE_ONLY);

   // flip rilevati sul TF corrente, barra chiusa
   bool flipLong  = (stCur.dirClosed == 1  && stCur.dirPrev <= 0);
   bool flipShort = (stCur.dirClosed == -1 && stCur.dirPrev >= 0);

   if(exitOnST)
   {
      // in long e flip short -> chiudi i long; in short e flip long -> chiudi gli short
      if(flipShort && CountEAPositions(1) > 0)
         CloseEADirection(1, "Supertrend opposto (flip short)");
      if(flipLong && CountEAPositions(-1) > 0)
         CloseEADirection(-1, "Supertrend opposto (flip long)");
   }

   //--- trailing SL sulla linea Supertrend (opzionale)
   if(TrailWithST)
      TrailStops(stCur.lineClosed);

   //--- BIAS H4
   int bias = ComputeBias();

   //--- filtro EMA200 sul TF corrente
   double emaCur = 0.0;
   bool emaReady = ReadEMA(hEmaCur, emaCur);
   bool emaOkL = (!UseEMA) || (emaReady && stCur.closeClosed > emaCur);
   bool emaOkS = (!UseEMA) || (emaReady && stCur.closeClosed < emaCur);
   if(UseEMA && !emaReady)
      return; // EMA non pronta

   //--- gate di sessione
   bool inSess = InSession(tClosed);

   //--- segnali
   bool longSignal  = (bias == 1)  && flipLong  && emaOkL && inSess;
   bool shortSignal = (bias == -1) && flipShort && emaOkS && inSess;

   if(longSignal)
      OpenTrade(true, stCur.lineClosed);
   else if(shortSignal)
      OpenTrade(false, stCur.lineClosed);
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   g_sym    = _Symbol;
   g_digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   g_point  = SymbolInfoDouble(g_sym, SYMBOL_POINT);

   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetAsyncMode(false);
   trade.SetTypeFillingBySymbol(g_sym);

   //--- handle indicatori
   hAtrCur = iATR(g_sym, _Period,    AtrPeriod);
   hAtrH4  = iATR(g_sym, PERIOD_H4,  AtrPeriod);
   hEmaCur = iMA (g_sym, _Period,    EmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   hEmaH4  = iMA (g_sym, PERIOD_H4,  EmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
   hAdxH4  = iADX(g_sym, PERIOD_H4,  AdxLen);

   if(hAtrCur == INVALID_HANDLE || hAtrH4 == INVALID_HANDLE ||
      hEmaCur == INVALID_HANDLE || hEmaH4 == INVALID_HANDLE ||
      hAdxH4  == INVALID_HANDLE)
   {
      Print("DAX_ST: ERRORE creazione handle indicatori.");
      return(INIT_FAILED);
   }

   g_lastBar = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);

   //--- DIAGNOSTICA vincoli broker (per capire eventuali "invalid stops")
   Print("DAX_ST VINCOLI ", g_sym,
         " | digits=", g_digits,
         " point=", DoubleToString(g_point, g_digits),
         " tickSize=", DoubleToString(SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE), 5),
         " tickValue=", DoubleToString(SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE), 5),
         " stopsLevel=", (long)SymbolInfoInteger(g_sym, SYMBOL_TRADE_STOPS_LEVEL),
         " freezeLevel=", (long)SymbolInfoInteger(g_sym, SYMBOL_TRADE_FREEZE_LEVEL),
         " volMin=", DoubleToString(SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN), 2),
         " volStep=", DoubleToString(SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP), 2),
         " minStopDist=", DoubleToString(MinStopDistance(), g_digits));

   Print("DAX_ST avviato su ", g_sym,
         " TF=", EnumToString((ENUM_TIMEFRAMES)_Period),
         " (entrata) / H4 (bias). Factor=", DoubleToString(Factor,2),
         " ATR=", AtrPeriod, " RR=", DoubleToString(RR,2),
         " ExitMode=", EnumToString(ExitMode));

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(hAtrCur != INVALID_HANDLE) IndicatorRelease(hAtrCur);
   if(hAtrH4  != INVALID_HANDLE) IndicatorRelease(hAtrH4);
   if(hEmaCur != INVALID_HANDLE) IndicatorRelease(hEmaCur);
   if(hEmaH4  != INVALID_HANDLE) IndicatorRelease(hEmaH4);
   if(hAdxH4  != INVALID_HANDLE) IndicatorRelease(hAdxH4);
}

//+------------------------------------------------------------------+
//| OnTick — esegue una volta per barra chiusa                       |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime cur = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);
   if(cur != g_lastBar)
   {
      g_lastBar = cur;
      OnNewBar();
   }
}
//+------------------------------------------------------------------+
