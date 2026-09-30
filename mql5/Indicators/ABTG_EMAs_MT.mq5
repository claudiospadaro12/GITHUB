//+------------------------------------------------------------------+
//|                                              ABTG_EMAs_MT.mq5    |
//|  Fino a 4 EMA sul grafico, ognuna col SUO periodo e col SUO      |
//|  timeframe (Multi-Timeframe): per esempio la EMA 200 di H4 e    |
//|  di D1 disegnate su un grafico H1.                              |
//|                                                                  |
//|  Default: EMA 50 (corrente), EMA 200 (corrente), EMA 200 di H4, |
//|  EMA 200 di D1.  PERIOD_CURRENT = il TF del grafico.            |
//|                                                                  |
//|  Sola lettura: disegna linee, non tocca ordini.                  |
//|  Nota MTF: la EMA di un TF piu' alto e' a gradini, e la barra    |
//|  in formazione del TF alto si muove finche' non chiude.          |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_plots   4

#property indicator_label1  "EMA 1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_width1  1
#property indicator_label2  "EMA 2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGold
#property indicator_width2  2
#property indicator_label3  "EMA 3"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrangeRed
#property indicator_width3  2
#property indicator_label4  "EMA 4"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrMagenta
#property indicator_width4  2

input int             InpPeriod1 = 50;             // EMA 1: periodo (0 = spenta)
input ENUM_TIMEFRAMES InpTf1     = PERIOD_CURRENT; // EMA 1: timeframe
input int             InpPeriod2 = 200;            // EMA 2: periodo (0 = spenta)
input ENUM_TIMEFRAMES InpTf2     = PERIOD_CURRENT; // EMA 2: timeframe
input int             InpPeriod3 = 200;            // EMA 3: periodo (0 = spenta)
input ENUM_TIMEFRAMES InpTf3     = PERIOD_H4;      // EMA 3: timeframe
input int             InpPeriod4 = 200;            // EMA 4: periodo (0 = spenta)
input ENUM_TIMEFRAMES InpTf4     = PERIOD_D1;      // EMA 4: timeframe

#define NL 4

double gBuf1[], gBuf2[], gBuf3[], gBuf4[];
int    gH[NL];
int    gPer[NL];
ENUM_TIMEFRAMES gTf[NL];

//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, gBuf1, INDICATOR_DATA);
   SetIndexBuffer(1, gBuf2, INDICATOR_DATA);
   SetIndexBuffer(2, gBuf3, INDICATOR_DATA);
   SetIndexBuffer(3, gBuf4, INDICATOR_DATA);
   for(int i = 0; i < NL; i++)
      PlotIndexSetDouble(i, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   gPer[0] = InpPeriod1; gTf[0] = InpTf1;
   gPer[1] = InpPeriod2; gTf[1] = InpTf2;
   gPer[2] = InpPeriod3; gTf[2] = InpTf3;
   gPer[3] = InpPeriod4; gTf[3] = InpTf4;

   for(int i = 0; i < NL; i++)
     {
      gH[i] = INVALID_HANDLE;
      if(gPer[i] <= 0)
         continue;
      gH[i] = iMA(_Symbol, gTf[i], gPer[i], 0, MODE_EMA, PRICE_CLOSE);
      string tfn = (gTf[i] == PERIOD_CURRENT) ? EnumToString((ENUM_TIMEFRAMES)_Period) : EnumToString(gTf[i]);
      StringReplace(tfn, "PERIOD_", "");
      PlotIndexSetString(i, PLOT_LABEL, "EMA " + IntegerToString(gPer[i]) + " " + tfn);
     }
   IndicatorSetString(INDICATOR_SHORTNAME, "ABTG EMAs MT");
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   for(int i = 0; i < NL; i++)
      if(gH[i] != INVALID_HANDLE)
         IndicatorRelease(gH[i]);
  }

//+------------------------------------------------------------------+
//| Riempie il buffer 'b' per la EMA 'i' da 'from' a rates_total-1   |
//| Ritorna false se i dati non sono ancora pronti                   |
//+------------------------------------------------------------------+
bool FillLine(const int i, double &b[], const int from, const int rates_total, const datetime &time[])
  {
   if(gH[i] == INVALID_HANDLE)
     {
      for(int k = from; k < rates_total; k++)
         b[k] = EMPTY_VALUE;
      return true;
     }

   ENUM_TIMEFRAMES tf = (gTf[i] == PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)_Period : gTf[i];

   // stesso TF del grafico: copia diretta
   if(tf == (ENUM_TIMEFRAMES)_Period)
     {
      int n = rates_total - from;
      double tmp[];
      ArraySetAsSeries(tmp, false);
      // copia le ultime n barre in ordine cronologico
      if(CopyBuffer(gH[i], 0, 0, n, tmp) != n)
         return false;
      for(int k = 0; k < n; k++)
         b[from + k] = tmp[k];
      return true;
     }

   // TF diverso: per ogni barra del grafico prendo la EMA della barra del TF scelto che la contiene
   int bars = Bars(_Symbol, tf);
   if(bars <= 0)
      return false;
   double ma[];
   ArraySetAsSeries(ma, true);
   int got = CopyBuffer(gH[i], 0, 0, bars, ma);
   if(got <= 0)
      return false;
   for(int k = from; k < rates_total; k++)
     {
      int sh = iBarShift(_Symbol, tf, time[k], false);
      if(sh < 0 || sh >= got || ma[sh] == EMPTY_VALUE || ma[sh] <= 0.0)
         b[k] = EMPTY_VALUE;
      else
         b[k] = ma[sh];
     }
   return true;
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
  {
   if(rates_total < 2)
      return 0;
   // primo giro: tutto; poi solo le ultime barre (per gli altri TF basta poco)
   int from = (prev_calculated <= 0) ? 0 : MathMax(0, rates_total - 3);
   bool ok = true;
   ok = FillLine(0, gBuf1, from, rates_total, time) && ok;
   ok = FillLine(1, gBuf2, from, rates_total, time) && ok;
   ok = FillLine(2, gBuf3, from, rates_total, time) && ok;
   ok = FillLine(3, gBuf4, from, rates_total, time) && ok;
   if(!ok)
      return 0;   // dati non ancora pronti: riprova al prossimo tick con ricalcolo completo
   return rates_total;
  }
//+------------------------------------------------------------------+
