//+------------------------------------------------------------------+
//|                                       IchiTrend_Gold_Base.mq5     |
//|                                                                  |
//|  EA BASE per XAUUSD (oro) su timeframe M5.                       |
//|                                                                  |
//|  LOGICA (versione 1.1 - solo le fondamenta):                    |
//|   - DIREZIONE (Ichimoku): rialzista se Tenkan>Kijun e prezzo    |
//|     sopra la nuvola (Kumo); ribassista nel caso opposto          |
//|   - INNESCO (Bollinger): entro sulla ROTTURA della banda nella  |
//|     direzione del trend (chiusura oltre la banda esterna).      |
//|     Bande compresse = niente rottura = niente trade             |
//|   - STOP e TRAILING dinamici basati su ATR (volatilita')        |
//|   - UNA sola posizione per volta (NIENTE piramidazione qui)     |
//|                                                                  |
//|  NOTA: questa e' la base da testare SU DEMO. Parzializzazione,  |
//|        breakeven avanzato e piramidazione arrivano dopo.        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

//--- oggetto per gestire gli ordini
CTrade trade;

//==================================================================
//  PARAMETRI DI INPUT (modificabili dal pannello dell'EA)
//==================================================================

//--- Ichimoku
input group "=== Ichimoku ==="
input int    InpTenkan      = 9;     // Tenkan-sen (periodo linea blu)
input int    InpKijun       = 26;    // Kijun-sen (periodo linea rossa)
input int    InpSenkouB     = 52;    // Senkou Span B

//--- Filtro volatilita' (Bollinger Bands)
input group "=== Bollinger (compressione/espansione) ==="
input int    InpBBPeriod    = 20;    // Periodo Bollinger
input double InpBBDev        = 2.0;   // Deviazioni standard delle bande

//--- Gestione del rischio (ATR)
input group "=== Rischio e gestione (ATR) ==="
input int    InpATRPeriod   = 14;    // Periodo ATR
input double InpATR_SL       = 1.5;   // Stop Loss = X volte l'ATR
input double InpATR_Trail    = 2.0;   // Trailing = X volte l'ATR
input double InpRiskPercent  = 0.5;   // Rischio per trade in % del capitale (0.5 = mezzo percento)

//--- Generali
input group "=== Generali ==="
input long   InpMagic        = 250604;// Numero magico (identifica i trade di questo EA)
input int    InpMaxSpread    = 50;    // Spread massimo consentito (in punti); 0 = nessun limite

//==================================================================
//  HANDLE DEGLI INDICATORI (creati una volta sola in OnInit)
//==================================================================
int hIchimoku = INVALID_HANDLE;
int hBands    = INVALID_HANDLE;
int hATR      = INVALID_HANDLE;

datetime lastBarTime = 0;   // per operare solo all'apertura di una nuova candela

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   //--- creo gli handle degli indicatori sul simbolo/timeframe correnti
   hIchimoku = iIchimoku(_Symbol, _Period, InpTenkan, InpKijun, InpSenkouB);
   hBands    = iBands(_Symbol, _Period, InpBBPeriod, 0, InpBBDev, PRICE_CLOSE);
   hATR      = iATR(_Symbol, _Period, InpATRPeriod);

   if(hIchimoku == INVALID_HANDLE || hBands == INVALID_HANDLE || hATR == INVALID_HANDLE)
     {
      Print("ERRORE: impossibile creare gli handle degli indicatori.");
      return(INIT_FAILED);
     }

   //--- imposto il numero magico per i trade
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetTypeFillingBySymbol(_Symbol);

   Print("IchiTrend_Gold_Base avviato su ", _Symbol, " ", EnumToString((ENUM_TIMEFRAMES)_Period));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione                                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hIchimoku != INVALID_HANDLE) IndicatorRelease(hIchimoku);
   if(hBands    != INVALID_HANDLE) IndicatorRelease(hBands);
   if(hATR      != INVALID_HANDLE) IndicatorRelease(hATR);
  }

//+------------------------------------------------------------------+
//| Ad ogni tick                                                     |
//+------------------------------------------------------------------+
void OnTick()
  {
   //--- il trailing va aggiornato ad ogni tick (gestione posizione aperta)
   ManageTrailing();

   //--- i segnali d'ingresso li valuto SOLO all'apertura di una nuova candela
   if(!IsNewBar())
      return;

   //--- se ho gia' una posizione aperta di questo EA, non ne apro altre (versione base)
   if(HasOpenPosition())
      return;

   //--- controllo spread (l'oro puo' allargarlo molto)
   if(!SpreadOK())
      return;

   //--- leggo gli indicatori e valuto il segnale
   int signal = GetSignal();   // +1 = long, -1 = short, 0 = niente

   if(signal > 0)
      OpenTrade(ORDER_TYPE_BUY);
   else if(signal < 0)
      OpenTrade(ORDER_TYPE_SELL);
  }

//+------------------------------------------------------------------+
//| Ritorna true una sola volta per ogni nuova candela               |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if(t != lastBarTime)
     {
      lastBarTime = t;
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Calcola il segnale d'ingresso                                    |
//|  +1 = long, -1 = short, 0 = nessun segnale                       |
//+------------------------------------------------------------------+
int GetSignal()
  {
   double tenkan[1], kijun[1];
   double spanA[1], spanB[1];
   double upper[2], lower[2];

   //--- ICHIMOKU: leggo lo stato sull'ultima candela CHIUSA (indice 1)
   if(CopyBuffer(hIchimoku, 0, 1, 1, tenkan) < 1) return(0); // 0 = TENKANSEN (blu)
   if(CopyBuffer(hIchimoku, 1, 1, 1, kijun)  < 1) return(0); // 1 = KIJUNSEN (rossa)
   if(CopyBuffer(hIchimoku, 2, 1, 1, spanA)  < 1) return(0); // 2 = SENKOU SPAN A
   if(CopyBuffer(hIchimoku, 3, 1, 1, spanB)  < 1) return(0); // 3 = SENKOU SPAN B

   //--- BOLLINGER: bande sulle ultime 2 candele chiuse (per vedere la rottura "fresca")
   if(CopyBuffer(hBands, 1, 1, 2, upper) < 2) return(0); // 1 = UPPER_BAND
   if(CopyBuffer(hBands, 2, 1, 2, lower) < 2) return(0); // 2 = LOWER_BAND

   //--- chiusure: candela 1 (ultima chiusa) e candela 2 (quella prima)
   double closeNow  = iClose(_Symbol, _Period, 1);
   double closePrev = iClose(_Symbol, _Period, 2);

   //--- indice 0 = candela piu' recente tra quelle copiate (candela 1)
   double upperNow  = upper[0];
   double upperPrev = upper[1];
   double lowerNow  = lower[0];
   double lowerPrev = lower[1];

   //--- bordi della nuvola Ichimoku
   double kumoTop = MathMax(spanA[0], spanB[0]);
   double kumoBot = MathMin(spanA[0], spanB[0]);

   //--- DIREZIONE del trend secondo l'Ichimoku
   bool trendUp   = (tenkan[0] > kijun[0]) && (closeNow > kumoTop);
   bool trendDown = (tenkan[0] < kijun[0]) && (closeNow < kumoBot);

   //--- INNESCO: rottura "fresca" della banda
   //    long: prima la candela era dentro/sotto la banda sup, ora chiude sopra
   bool breakoutUp   = (closePrev <= upperPrev) && (closeNow > upperNow);
   //    short: prima dentro/sopra la banda inf, ora chiude sotto
   bool breakoutDown = (closePrev >= lowerPrev) && (closeNow < lowerNow);

   //--- LONG: trend rialzista Ichimoku + rottura della banda superiore
   if(trendUp && breakoutUp)
      return(+1);

   //--- SHORT: trend ribassista Ichimoku + rottura della banda inferiore
   if(trendDown && breakoutDown)
      return(-1);

   return(0);
  }

//+------------------------------------------------------------------+
//| Apre una posizione con SL su ATR e lotto da rischio %            |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
  {
   double atr[1];
   if(CopyBuffer(hATR, 0, 1, 1, atr) < 1) return;
   double atrVal = atr[0];
   if(atrVal <= 0) return;

   double slDistance = InpATR_SL * atrVal;      // distanza dello stop in prezzo

   double price = (type == ORDER_TYPE_BUY)
                  ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                  : SymbolInfoDouble(_Symbol, SYMBOL_BID);

   double sl = (type == ORDER_TYPE_BUY) ? price - slDistance : price + slDistance;

   //--- normalizzo allo stesso numero di decimali del simbolo
   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   sl    = NormalizeDouble(sl, digits);
   price = NormalizeDouble(price, digits);

   //--- calcolo il lotto in base al rischio %
   double lot = CalcLotByRisk(slDistance);
   if(lot <= 0) return;

   //--- niente take profit: usciamo con il trailing (lascio correre i profitti)
   bool ok;
   if(type == ORDER_TYPE_BUY)
      ok = trade.Buy(lot, _Symbol, price, sl, 0, "IchiTrend long");
   else
      ok = trade.Sell(lot, _Symbol, price, sl, 0, "IchiTrend short");

   if(!ok)
      Print("Apertura ordine FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Calcola il lotto in modo che la perdita allo SL sia ~ Risk%     |
//+------------------------------------------------------------------+
double CalcLotByRisk(double slDistancePrice)
  {
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   //--- valore di un tick per 1 lotto, e dimensione del tick
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickValue <= 0) return(0);

   //--- quanti tick di distanza ha lo stop
   double ticks = slDistancePrice / tickSize;
   //--- perdita per 1 lotto se va a stop
   double lossPerLot = ticks * tickValue;
   if(lossPerLot <= 0) return(0);

   double lot = riskMoney / lossPerLot;

   //--- arrotondo ai vincoli del simbolo (min, max, step)
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));

   return(lot);
  }

//+------------------------------------------------------------------+
//| Trailing stop dinamico su ATR (mette al sicuro i profitti)       |
//+------------------------------------------------------------------+
void ManageTrailing()
  {
   if(!PositionSelect(_Symbol))
      return;
   if(PositionGetInteger(POSITION_MAGIC) != InpMagic)
      return;

   double atr[1];
   if(CopyBuffer(hATR, 0, 1, 1, atr) < 1) return;
   double trailDist = InpATR_Trail * atr[0];
   if(trailDist <= 0) return;

   int    digits   = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   long   type     = PositionGetInteger(POSITION_TYPE);
   double openP    = PositionGetDouble(POSITION_PRICE_OPEN);
   double curSL    = PositionGetDouble(POSITION_SL);

   if(type == POSITION_TYPE_BUY)
     {
      double bid    = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double newSL  = NormalizeDouble(bid - trailDist, digits);
      //--- sposto lo SL solo IN SU e solo se siamo gia' in profitto rispetto all'ingresso
      if(newSL > curSL && newSL > openP)
         trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
     }
   else if(type == POSITION_TYPE_SELL)
     {
      double ask    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double newSL  = NormalizeDouble(ask + trailDist, digits);
      //--- sposto lo SL solo IN GIU e solo se siamo gia' in profitto
      if((newSL < curSL || curSL == 0) && newSL < openP)
         trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
     }
  }

//+------------------------------------------------------------------+
//| C'e' una posizione aperta di QUESTO ea?                          |
//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   if(!PositionSelect(_Symbol))
      return(false);
   return(PositionGetInteger(POSITION_MAGIC) == InpMagic);
  }

//+------------------------------------------------------------------+
//| Lo spread e' accettabile?                                        |
//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpread <= 0)
      return(true);
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   return(spread <= InpMaxSpread);
  }
//+------------------------------------------------------------------+
