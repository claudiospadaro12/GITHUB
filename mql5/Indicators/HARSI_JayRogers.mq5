//+------------------------------------------------------------------+
//| HARSI_JayRogers.mq5                                              |
//| Heikin Ashi RSI Oscillator (HARSI) — replica MQL5 della         |
//| versione TradingView di JayRogers.                              |
//|                                                                  |
//| LOGICA:                                                          |
//|   1. Costruisce candele Heikin-Ashi (HA) dai prezzi del grafico.|
//|   2. Calcola un RSI (lunghezza 14) su OGNUNO di HA open/high/    |
//|      low/close, poi ri-centra sottraendo 50 -> oscilla in       |
//|      ~[-50,+50].                                                 |
//|   3. Dalle 4 serie RSI ri-centrate costruisce nuove candele     |
//|      "HA-RSI":                                                   |
//|        haOpen  = (prevHaOpen + prevHaClose) / 2                 |
//|        haClose = (o + h + l + c) / 4                            |
//|        haHigh  = max(h, haOpen, haClose)                        |
//|        haLow   = min(l, haOpen, haClose)                        |
//|   4. Le disegna come DRAW_COLOR_CANDLES nella sotto-finestra.   |
//|   5. Linea RSI overlay opzionale (RSI sul source, ri-centrata,  |
//|      con smoothing).                                            |
//|                                                                  |
//| BUFFER (indici leggibili via iCustom):                          |
//|   0  HA_Open   (candela) — apertura HA-RSI ri-centrata          |
//|   1  HA_High   (candela)                                        |
//|   2  HA_Low    (candela)                                        |
//|   3  HA_Close  (candela) — chiusura HA-RSI ri-centrata          |
//|   4  HA_Color  (colore candela: 0=verde/bull, 1=rosso/bear)     |
//|   5  RSI_Line  (linea RSI overlay ri-centrata + smoothing)      |
//|                                                                  |
//| L'EA legge HA_Close (buf 3) e HA_Open (buf 0) per il colore     |
//| candela (haClose>haOpen = verde/bullish), e RSI_Line (buf 5).   |
//+------------------------------------------------------------------+
#property copyright "Claudio — HARSI replica (JayRogers)"
#property version   "1.00"
#property strict

#property indicator_separate_window
#property indicator_buffers 6
#property indicator_plots   2

//--- Plot 0: candele HA-RSI (usa buffer 0..3 + colore buffer 4)
#property indicator_label1  "HARSI"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  1

//--- Plot 1: linea RSI overlay
#property indicator_label2  "RSI"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrAqua
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

//==================================================================
// ENUM source
//==================================================================
enum ENUM_HARSI_PRICE
{
   HARSI_CLOSE = 0,   // Close
   HARSI_OHLC4 = 1    // (O+H+L+C)/4
};

//==================================================================
// INPUT
//==================================================================
input group "=== HARSI ==="
input int             RSI_Length    = 14;          // RSI Length
input int             RSI_Smoothing = 1;           // RSI Smoothing (linea overlay)
input ENUM_HARSI_PRICE SourcePrice  = HARSI_CLOSE; // Source (linea RSI overlay)
input bool            ShowRSILine   = true;        // Mostra linea RSI overlay

input group "=== Bande OB/OS (ri-centrate) ==="
input double          UpperExtreme  = 30.0;        // Banda estrema superiore (+30 ~ RSI 80)
input double          UpperMild     = 20.0;        // Banda lieve superiore   (+20 ~ RSI 70)
input double          LowerMild     = -20.0;       // Banda lieve inferiore   (-20 ~ RSI 30)
input double          LowerExtreme  = -30.0;       // Banda estrema inferiore (-30 ~ RSI 20)

//==================================================================
// BUFFER
//==================================================================
double bufHAOpen[];   // 0
double bufHAHigh[];   // 1
double bufHALow[];    // 2
double bufHAClose[];  // 3
double bufHAColor[];  // 4 (color index)
double bufRSILine[];  // 5

//--- serie HA di prezzo (interne)
double haO[], haH[], haL[], haC[];

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   SetIndexBuffer(0, bufHAOpen,  INDICATOR_DATA);
   SetIndexBuffer(1, bufHAHigh,  INDICATOR_DATA);
   SetIndexBuffer(2, bufHALow,   INDICATOR_DATA);
   SetIndexBuffer(3, bufHAClose, INDICATOR_DATA);
   SetIndexBuffer(4, bufHAColor, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(5, bufRSILine, INDICATOR_DATA);

   IndicatorSetInteger(INDICATOR_DIGITS, 2);
   IndicatorSetString(INDICATOR_SHORTNAME, "HARSI(" + (string)RSI_Length + ")");

   //--- livelli orizzontali e fasce
   IndicatorSetInteger(INDICATOR_LEVELS, 5);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, UpperExtreme);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, UpperMild);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 2, 0.0);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 3, LowerMild);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 4, LowerExtreme);

   //--- fascia rossa (overbought) e fascia verde (oversold)
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 0, clrFireBrick);
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 1, clrFireBrick);
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 2, clrDimGray);
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 3, clrSeaGreen);
   IndicatorSetInteger(INDICATOR_LEVELCOLOR, 4, clrSeaGreen);

   for(int i = 0; i < 5; i++)
      IndicatorSetInteger(INDICATOR_LEVELSTYLE, i, STYLE_DOT);

   //--- nasconde la linea RSI se non richiesta
   if(!ShowRSILine)
      PlotIndexSetInteger(1, PLOT_DRAW_TYPE, DRAW_NONE);

   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetDouble(1, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| RSI di Wilder calcolato manualmente su una serie arbitraria.    |
//| src[] e' indicizzato come serie cronologica (0 = piu' vecchio). |
//| Calcola RSI per l'indice 'pos' usando lo stato medio gain/loss  |
//| passato per riferimento (avgGain, avgLoss). 'len' = periodo.    |
//| Ritorna RSI 0..100. NON ri-centrato.                            |
//+------------------------------------------------------------------+
double WilderRSI(const double &src[], const int pos, const int len,
                 double &avgGain, double &avgLoss, const bool seed)
{
   if(pos < 1)
      return(50.0);

   double change = src[pos] - src[pos - 1];
   double gain   = (change > 0.0) ? change : 0.0;
   double loss   = (change < 0.0) ? -change : 0.0;

   if(seed)
   {
      // media semplice iniziale sui primi 'len' delta
      double sg = 0.0, sl = 0.0;
      for(int k = pos - len + 1; k <= pos; k++)
      {
         double ch = src[k] - src[k - 1];
         sg += (ch > 0.0) ? ch : 0.0;
         sl += (ch < 0.0) ? -ch : 0.0;
      }
      avgGain = sg / len;
      avgLoss = sl / len;
   }
   else
   {
      avgGain = (avgGain * (len - 1) + gain) / len;
      avgLoss = (avgLoss * (len - 1) + loss) / len;
   }

   if(avgLoss == 0.0)
      return(100.0);

   double rs = avgGain / avgLoss;
   return(100.0 - (100.0 / (1.0 + rs)));
}

//+------------------------------------------------------------------+
//| OnCalculate                                                      |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   if(rates_total < RSI_Length + 3)
      return(0);

   //--- ridimensiona serie HA di prezzo
   ArrayResize(haO, rates_total);
   ArrayResize(haH, rates_total);
   ArrayResize(haL, rates_total);
   ArrayResize(haC, rates_total);

   //--- buffer come serie cronologiche (0 = barra piu' vecchia)
   //    (di default i buffer NON sono serie; lavoriamo con indici
   //     crescenti = tempo crescente, coerenti con open/high/...)
   ArraySetAsSeries(open,  false);
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);

   //=== 1) Heikin-Ashi di PREZZO =================================
   for(int i = 0; i < rates_total; i++)
   {
      haC[i] = (open[i] + high[i] + low[i] + close[i]) / 4.0;
      if(i == 0)
         haO[i] = (open[i] + close[i]) / 2.0;
      else
         haO[i] = (haO[i - 1] + haC[i - 1]) / 2.0;
      haH[i] = MathMax(high[i], MathMax(haO[i], haC[i]));
      haL[i] = MathMin(low[i],  MathMin(haO[i], haC[i]));
   }

   //=== 2) RSI su ognuna delle 4 serie HA, ri-centrato -50 ========
   //    Ricalcoliamo da zero (full recalc) per semplicita' e
   //    robustezza: gli oscillatori RSI dipendono dallo stato.
   static double rsiO[], rsiH[], rsiL[], rsiC[];
   ArrayResize(rsiO, rates_total);
   ArrayResize(rsiH, rates_total);
   ArrayResize(rsiL, rates_total);
   ArrayResize(rsiC, rates_total);

   double agO=0, alO=0, agH=0, alH=0, agL=0, alL=0, agC=0, alC=0;
   for(int i = 0; i < rates_total; i++)
   {
      bool seed = (i == RSI_Length);
      if(i < RSI_Length)
      {
         rsiO[i] = 0.0; rsiH[i] = 0.0; rsiL[i] = 0.0; rsiC[i] = 0.0;
         continue;
      }
      rsiO[i] = WilderRSI(haO, i, RSI_Length, agO, alO, seed) - 50.0;
      rsiH[i] = WilderRSI(haH, i, RSI_Length, agH, alH, seed) - 50.0;
      rsiL[i] = WilderRSI(haL, i, RSI_Length, agL, alL, seed) - 50.0;
      rsiC[i] = WilderRSI(haC, i, RSI_Length, agC, alC, seed) - 50.0;
   }

   //=== 3) Candele HA-RSI dalle 4 serie RSI ri-centrate ===========
   for(int i = 0; i < rates_total; i++)
   {
      if(i <= RSI_Length)
      {
         bufHAOpen[i]  = EMPTY_VALUE;
         bufHAHigh[i]  = EMPTY_VALUE;
         bufHALow[i]   = EMPTY_VALUE;
         bufHAClose[i] = EMPTY_VALUE;
         bufHAColor[i] = 0;
         continue;
      }

      double o = rsiO[i];
      double h = rsiH[i];
      double l = rsiL[i];
      double c = rsiC[i];

      double haClose = (o + h + l + c) / 4.0;
      double haOpen;
      if(bufHAOpen[i - 1] == EMPTY_VALUE)
         haOpen = (o + c) / 2.0;
      else
         haOpen = (bufHAOpen[i - 1] + bufHAClose[i - 1]) / 2.0;

      double haHigh = MathMax(h, MathMax(haOpen, haClose));
      double haLow  = MathMin(l, MathMin(haOpen, haClose));

      bufHAOpen[i]  = haOpen;
      bufHAHigh[i]  = haHigh;
      bufHALow[i]   = haLow;
      bufHAClose[i] = haClose;
      bufHAColor[i] = (haClose >= haOpen) ? 0.0 : 1.0; // 0=verde/bull, 1=rosso/bear
   }

   //=== 4) Linea RSI overlay (RSI sul source, ri-centrato) ========
   if(ShowRSILine)
   {
      static double srcArr[];
      ArrayResize(srcArr, rates_total);
      for(int i = 0; i < rates_total; i++)
         srcArr[i] = (SourcePrice == HARSI_OHLC4)
                     ? (open[i] + high[i] + low[i] + close[i]) / 4.0
                     : close[i];

      static double rsiRaw[];
      ArrayResize(rsiRaw, rates_total);
      double ag=0, al=0;
      for(int i = 0; i < rates_total; i++)
      {
         if(i < RSI_Length) { rsiRaw[i] = 0.0; continue; }
         bool seed = (i == RSI_Length);
         rsiRaw[i] = WilderRSI(srcArr, i, RSI_Length, ag, al, seed) - 50.0;
      }

      //--- smoothing (EMA semplice) della linea RSI
      int sm = MathMax(1, RSI_Smoothing);
      double alpha = 2.0 / (sm + 1.0);
      for(int i = 0; i < rates_total; i++)
      {
         if(i <= RSI_Length) { bufRSILine[i] = EMPTY_VALUE; continue; }
         if(sm <= 1 || bufRSILine[i - 1] == EMPTY_VALUE)
            bufRSILine[i] = rsiRaw[i];
         else
            bufRSILine[i] = bufRSILine[i - 1] + alpha * (rsiRaw[i] - bufRSILine[i - 1]);
      }
   }

   return(rates_total);
}
//+------------------------------------------------------------------+
