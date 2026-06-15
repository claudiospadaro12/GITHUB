//+------------------------------------------------------------------+
//|                            IchiCross_Bollinger_Dashboard.mq5     |
//|  Replica MT5 dell'indicatore Pine "Ichimoku TK Cross +          |
//|  Bollinger - Claudio".                                          |
//|                                                                  |
//|  CONTENUTO:                                                      |
//|   - Ichimoku 7/22/44 calcolato a mano (donchian = media di      |
//|     max/min) per essere IDENTICO al Pine. NON usa iIchimoku     |
//|     che adotta periodi/spostamenti diversi (9/26/52).           |
//|   - Bollinger 20 / 2.0 calcolato a mano (SMA + dev. std.).      |
//|   - Squeeze: bbWidth = upper-lower; media su 50; in squeeze se  |
//|     bbWidth < 0.8 * media.                                      |
//|   - Segnali TK cross con frecce + etichette LONG/SHORT.         |
//|   - Livelli chiave (Open D/W/M, PDH/PDL, PWH/PWL, numeri tondi).|
//|   - Dashboard di stato in alto a destra.                       |
//|                                                                  |
//|  DIFFERENZE NOTE rispetto al Pine (vedi note finali al fondo):  |
//|   - Fill Kumo: in MT5 il DRAW_FILLING e' bicolore up/down in    |
//|     base a quale buffer e' sopra: coincide col verde/viola del  |
//|     Pine (verde se SenkouA>SenkouB).                            |
//|   - Sfondo arancione in squeeze: NON e' nativo per-barra in     |
//|     MT5. Lo stato squeeze e' segnalato SOLO nella dashboard.    |
//+------------------------------------------------------------------+
#property copyright "Progetto Indicatori Oro"
#property version   "1.00"
#property strict
#property indicator_chart_window

//--- Buffer disegnati: 8 linee + 2 frecce + (SenkouA/B servono al filling)
//    Plot 1  Tenkan          (rosso)
//    Plot 2  Kijun           (blu)
//    Plot 3  Chikou          (lime, shift -displacement)
//    Plot 4  SenkouA         (verde tenue, shift +displacement)
//    Plot 5  SenkouB         (viola tenue, shift +displacement)
//    Plot 6  Kumo fill       (DRAW_FILLING tra SenkouA e SenkouB)
//    Plot 7  BB upper        (giallo)
//    Plot 8  BB basis        (giallo)
//    Plot 9  BB lower        (giallo)
//    Plot 10 Freccia LONG    (DRAW_ARROW 233)
//    Plot 11 Freccia SHORT   (DRAW_ARROW 234)
#property indicator_buffers 13
#property indicator_plots   11

//--- Plot 1: Tenkan
#property indicator_label1  "Tenkan"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_width1  1

//--- Plot 2: Kijun
#property indicator_label2  "Kijun"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRoyalBlue
#property indicator_width2  1

//--- Plot 3: Chikou (shift -displacement)
#property indicator_label3  "Chikou"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLime
#property indicator_width3  1

//--- Plot 4: Senkou A (shift +displacement)
#property indicator_label4  "SenkouA"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrSeaGreen
#property indicator_width4  1
#property indicator_style4  STYLE_DOT

//--- Plot 5: Senkou B (shift +displacement)
#property indicator_label5  "SenkouB"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrPurple
#property indicator_width5  1
#property indicator_style5  STYLE_DOT

//--- Plot 6: Kumo fill (DRAW_FILLING tra SenkouA e SenkouB)
//    Bicolore: primo colore = SenkouA sopra SenkouB (verde),
//    secondo colore = SenkouB sopra (viola). Coincide col Pine.
#property indicator_label6  "Kumo"
#property indicator_type6   DRAW_FILLING
#property indicator_color6  clrMediumSeaGreen,clrMediumPurple

//--- Plot 7: BB upper
#property indicator_label7  "BB Upper"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGold
#property indicator_width7  1

//--- Plot 8: BB basis
#property indicator_label8  "BB Basis"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrGold
#property indicator_style8  STYLE_DOT
#property indicator_width8  1

//--- Plot 9: BB lower
#property indicator_label9  "BB Lower"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrGold
#property indicator_width9  1

//--- Plot 10: Freccia LONG (sotto la barra)
#property indicator_label10 "LONG"
#property indicator_type10  DRAW_ARROW
#property indicator_color10 clrLime
#property indicator_width10 2

//--- Plot 11: Freccia SHORT (sopra la barra)
#property indicator_label11 "SHORT"
#property indicator_type11  DRAW_ARROW
#property indicator_color11 clrRed
#property indicator_width11 2

//==================================================================
//  PARAMETRI DI INPUT (stessi nomi/valori del Pine)
//==================================================================

//--- Ichimoku
input group "=== Ichimoku ==="
input int    tenkanLen     = 7;   // Tenkan (donchian)
input int    kijunLen      = 22;  // Kijun (donchian)
input int    senkouBLen    = 44;  // Senkou Span B (donchian)
input int    displacement  = 26;  // Spostamento Kumo / Chikou

//--- Bollinger
input group "=== Bollinger ==="
input int    bbLength      = 20;  // Periodo Bollinger
input double bbStdDev      = 2.0; // Deviazioni standard

//--- Squeeze
input group "=== Squeeze ==="
input int    squeezeLookback  = 50;  // Finestra media larghezza bande
input double squeezeThreshold = 0.8; // In squeeze se larghezza < soglia x media

//--- Segnali
input group "=== Segnali TK cross ==="
input bool   ShowSignals    = true;  // Mostra frecce/etichette LONG/SHORT
input bool   EnableAlerts   = false; // Attiva Alert() sui nuovi segnali
input bool   AlertOnlyNoSqueeze = false; // Alert solo quando NON in squeeze

//--- Livelli chiave
input group "=== Livelli chiave ==="
input bool   ShowOpenLevels   = true; // Open giornaliero/settimanale/mensile
input bool   ShowPrevHL       = true; // PDH/PDL e PWH/PWL (precedenti)
input bool   ShowRoundLevels  = true; // Numeri tondi attorno al prezzo
input double RoundStep        = 25.0; // Passo numeri tondi (default 25$)
input int    RoundN           = 4;    // Quanti livelli tondi sopra e sotto

//--- Dashboard
input group "=== Dashboard ==="
input bool   ShowDashboard    = true; // Pannello stato in alto a destra

//==================================================================
//  BUFFER
//==================================================================
double TenkanBuf[];
double KijunBuf[];
double ChikouBuf[];
double SenkouABuf[];
double SenkouBBuf[];
double KumoFillA[];   // copia SenkouA per il filling (stesso shift)
double KumoFillB[];   // copia SenkouB per il filling (stesso shift)
double BBUpperBuf[];
double BBBasisBuf[];
double BBLowerBuf[];
double LongArrowBuf[];
double ShortArrowBuf[];
// Buffer di servizio (non plottato) per la bbWidth, utile alla media squeeze
double BBWidthBuf[];

//==================================================================
//  STATO INTERNO
//==================================================================
string const PREFIX = "ICB_";   // prefisso di tutti gli oggetti grafici
datetime g_lastAlertBar = 0;    // anti-ripetizione alert (una per barra)

//==================================================================
//  OnInit
//==================================================================
int OnInit()
{
   //--- Mappa buffer su indici
   SetIndexBuffer(0, TenkanBuf,    INDICATOR_DATA);
   SetIndexBuffer(1, KijunBuf,     INDICATOR_DATA);
   SetIndexBuffer(2, ChikouBuf,    INDICATOR_DATA);
   SetIndexBuffer(3, SenkouABuf,   INDICATOR_DATA);
   SetIndexBuffer(4, SenkouBBuf,   INDICATOR_DATA);
   SetIndexBuffer(5, KumoFillA,    INDICATOR_DATA);
   SetIndexBuffer(6, KumoFillB,    INDICATOR_DATA);
   SetIndexBuffer(7, BBUpperBuf,   INDICATOR_DATA);
   SetIndexBuffer(8, BBBasisBuf,   INDICATOR_DATA);
   SetIndexBuffer(9, BBLowerBuf,   INDICATOR_DATA);
   SetIndexBuffer(10, LongArrowBuf, INDICATOR_DATA);
   SetIndexBuffer(11, ShortArrowBuf, INDICATOR_DATA);
   SetIndexBuffer(12, BBWidthBuf,  INDICATOR_CALCULATIONS);

   //--- Plot 6 (Kumo fill) usa gli indici 5 e 6 (KumoFillA/KumoFillB)

   //--- Shift dei plot (come gli offset del Pine)
   //    Chikou: spostato indietro di displacement (offset negativo).
   PlotIndexSetInteger(2, PLOT_SHIFT, -displacement);
   //    Senkou A/B e relativo fill: spostati avanti di displacement.
   PlotIndexSetInteger(3, PLOT_SHIFT, displacement);
   PlotIndexSetInteger(4, PLOT_SHIFT, displacement);
   PlotIndexSetInteger(5, PLOT_SHIFT, displacement);

   //--- Codici freccia: 233 = freccia su (LONG), 234 = freccia giu' (SHORT)
   PlotIndexSetInteger(9,  PLOT_ARROW, 233);
   PlotIndexSetInteger(10, PLOT_ARROW, 234);

   //--- Valori vuoti: non disegnare lo 0
   for(int i=0; i<11; i++)
      PlotIndexSetDouble(i, PLOT_EMPTY_VALUE, 0.0);

   //--- Nome breve e precisione
   IndicatorSetString(INDICATOR_SHORTNAME, "IchiCross+Bollinger");
   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);

   return(INIT_SUCCEEDED);
}

//==================================================================
//  OnDeinit — rilascia oggetti grafici col prefisso
//==================================================================
void OnDeinit(const int reason)
{
   ObjectsDeleteAll(0, PREFIX);
   Comment("");
}

//==================================================================
//  Donchian = media tra massimo e minimo su 'len' barre,
//  calcolata fino allo shift 'i' (incluso). Serie NON timeseries:
//  l'array high/low e' indicizzato 0..rates_total-1 (cronologico).
//==================================================================
double Donchian(const double &high[], const double &low[], int i, int len)
{
   double hh = high[i];
   double ll = low[i];
   for(int k=1; k<len; k++)
   {
      int idx = i - k;
      if(idx < 0) break;
      if(high[idx] > hh) hh = high[idx];
      if(low[idx]  < ll) ll = low[idx];
   }
   return((hh + ll) / 2.0);
}

//==================================================================
//  OnCalculate
//==================================================================
int OnCalculate(const int        rates_total,
                const int        prev_calculated,
                const datetime  &time[],
                const double    &open[],
                const double    &high[],
                const double    &low[],
                const double    &close[],
                const long      &tick_volume[],
                const long      &volume[],
                const int       &spread[])
{
   //--- Numero minimo di barre necessario
   int maxLen = MathMax(MathMax(tenkanLen, kijunLen), MathMax(senkouBLen, bbLength));
   if(rates_total <= maxLen + squeezeLookback) return(0);

   //--- Punto di partenza: ricalcola solo le barre nuove,
   //    lasciando un margine per la media squeeze.
   int start;
   if(prev_calculated == 0)
      start = maxLen;
   else
      start = prev_calculated - 1;
   if(start < maxLen) start = maxLen;

   for(int i = start; i < rates_total; i++)
   {
      //--- Ichimoku a mano (donchian)
      double tk = Donchian(high, low, i, tenkanLen);
      double kj = Donchian(high, low, i, kijunLen);
      double sb = Donchian(high, low, i, senkouBLen);
      double sa = (tk + kj) / 2.0;

      TenkanBuf[i] = tk;
      KijunBuf[i]  = kj;
      SenkouABuf[i] = sa;
      SenkouBBuf[i] = sb;
      KumoFillA[i]  = sa;
      KumoFillB[i]  = sb;

      //--- Chikou = close (lo shift negativo del plot lo proietta indietro)
      ChikouBuf[i] = close[i];

      //--- Bollinger a mano (SMA + dev. std. di popolazione, come Pine ta.stdev)
      double sum = 0.0;
      for(int k=0; k<bbLength; k++)
         sum += close[i-k];
      double basis = sum / bbLength;

      double sqsum = 0.0;
      for(int k=0; k<bbLength; k++)
      {
         double d = close[i-k] - basis;
         sqsum += d*d;
      }
      double dev = MathSqrt(sqsum / bbLength); // popolazione: divisione per N (Pine ta.stdev)
      double up  = basis + bbStdDev * dev;
      double lo  = basis - bbStdDev * dev;

      BBBasisBuf[i] = basis;
      BBUpperBuf[i] = up;
      BBLowerBuf[i] = lo;
      BBWidthBuf[i] = up - lo;

      //--- Segnali TK cross sull'incrocio (barra i rispetto a i-1)
      LongArrowBuf[i]  = 0.0;
      ShortArrowBuf[i] = 0.0;
      if(ShowSignals && i >= maxLen + 1)
      {
         double tkPrev = TenkanBuf[i-1];
         double kjPrev = KijunBuf[i-1];
         bool crossUp   = (tkPrev <= kjPrev && tk >  kj);
         bool crossDown = (tkPrev >= kjPrev && tk <  kj);

         //--- LONG sotto la barra, SHORT sopra (piccolo offset visivo)
         double pad = (high[i]-low[i]) * 0.5;
         if(pad <= 0) pad = 10*_Point;
         if(crossUp)  LongArrowBuf[i]  = low[i]  - pad;
         if(crossDown) ShortArrowBuf[i] = high[i] + pad;
      }
   }

   //--- Squeeze + dashboard + alert: solo sull'ultima barra
   int last = rates_total - 1;
   if(last >= maxLen + squeezeLookback)
   {
      //--- Media della larghezza bande sulle ultime squeezeLookback barre
      double wsum = 0.0;
      for(int k=0; k<squeezeLookback; k++)
         wsum += BBWidthBuf[last-k];
      double wAvg = wsum / squeezeLookback;
      double wNow = BBWidthBuf[last];
      bool inSqueeze = (wAvg > 0.0) && (wNow < wAvg * squeezeThreshold);
      double widthPct = (wAvg > 0.0) ? (wNow / wAvg * 100.0) : 0.0;

      //--- Dashboard
      if(ShowDashboard)
         UpdateDashboard(inSqueeze, widthPct, squeezeThreshold*100.0);

      //--- Livelli chiave (ridisegnati ogni tick sull'ultima barra)
      DrawKeyLevels(close[last]);

      //--- Alert sull'ultima barra CHIUSA (i = last-1), una sola per barra
      if(EnableAlerts && last >= maxLen + 2)
      {
         int sigBar = last - 1; // ultima barra chiusa
         if(time[sigBar] != g_lastAlertBar)
         {
            bool isLong  = (LongArrowBuf[sigBar]  != 0.0);
            bool isShort = (ShortArrowBuf[sigBar] != 0.0);
            if(isLong || isShort)
            {
               // Per l'alert "no squeeze" rivaluto lo squeeze a quella barra
               bool okToAlert = true;
               if(AlertOnlyNoSqueeze)
               {
                  double s = 0.0;
                  for(int k=0; k<squeezeLookback; k++)
                     s += BBWidthBuf[sigBar-k];
                  double a = s / squeezeLookback;
                  bool sq = (a > 0.0) && (BBWidthBuf[sigBar] < a*squeezeThreshold);
                  okToAlert = !sq;
               }
               if(okToAlert)
               {
                  string dir = isLong ? "LONG" : "SHORT";
                  Alert(_Symbol, " ", EnumToString((ENUM_TIMEFRAMES)_Period),
                        " TK cross ", dir);
                  g_lastAlertBar = time[sigBar];
               }
            }
         }
      }
   }

   return(rates_total);
}

//==================================================================
//  DASHBOARD — pannello in alto a destra (OBJ_LABEL)
//==================================================================
void CreateLabel(string name, int x, int y, string text, color clr, int size=9)
{
   if(ObjectFind(0, name) < 0)
   {
      ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
      ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_RIGHT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
      ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
      ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
      ObjectSetString(0, name, OBJPROP_FONT, "Consolas");
      ObjectSetInteger(0, name, OBJPROP_FONTSIZE, size);
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
   }
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
}

void UpdateDashboard(bool inSqueeze, double widthPct, double thresholdPct)
{
   string nTitle  = PREFIX + "dash_title";
   string nSym    = PREFIX + "dash_sym";
   string nStato  = PREFIX + "dash_stato";
   string nLarg   = PREFIX + "dash_larg";
   string nSoglia = PREFIX + "dash_soglia";

   color statoClr = inSqueeze ? clrOrange : clrLimeGreen;
   string statoTxt = inSqueeze ? "SQUEEZE" : "ESPANSIONE";

   CreateLabel(nTitle, 10, 18,  "BOLLINGER", clrWhite, 10);
   CreateLabel(nSym,   10, 36,  _Symbol + "  " + EnumToString((ENUM_TIMEFRAMES)_Period), clrSilver);
   CreateLabel(nStato, 10, 56,  "Stato:     " + statoTxt, statoClr);
   CreateLabel(nLarg,  10, 74,  "Larghezza: " + DoubleToString(widthPct, 1) + " %", clrSilver);
   CreateLabel(nSoglia,10, 92,  "Soglia:    " + DoubleToString(thresholdPct, 1) + " %", clrSilver);
}

//==================================================================
//  LIVELLI CHIAVE — linee orizzontali + etichetta prezzo
//==================================================================
void DrawHLevel(string id, double price, color clr, ENUM_LINE_STYLE style, string text)
{
   if(price <= 0.0) return;
   string nLine = PREFIX + "lvl_" + id;
   string nTxt  = PREFIX + "txt_" + id;

   //--- Linea orizzontale
   if(ObjectFind(0, nLine) < 0)
   {
      ObjectCreate(0, nLine, OBJ_HLINE, 0, 0, price);
      ObjectSetInteger(0, nLine, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, nLine, OBJPROP_STYLE, style);
      ObjectSetInteger(0, nLine, OBJPROP_WIDTH, 1);
      ObjectSetInteger(0, nLine, OBJPROP_BACK, true);
      ObjectSetInteger(0, nLine, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, nLine, OBJPROP_HIDDEN, true);
   }
   ObjectSetDouble(0, nLine, OBJPROP_PRICE, price);
   ObjectSetInteger(0, nLine, OBJPROP_COLOR, clr);

   //--- Etichetta prezzo, ancorata all'ultima barra (a destra)
   datetime tAnchor = TimeCurrent() + PeriodSeconds() * 3;
   if(ObjectFind(0, nTxt) < 0)
   {
      ObjectCreate(0, nTxt, OBJ_TEXT, 0, tAnchor, price);
      ObjectSetInteger(0, nTxt, OBJPROP_COLOR, clr);
      ObjectSetInteger(0, nTxt, OBJPROP_FONTSIZE, 8);
      ObjectSetInteger(0, nTxt, OBJPROP_ANCHOR, ANCHOR_LEFT);
      ObjectSetInteger(0, nTxt, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, nTxt, OBJPROP_HIDDEN, true);
   }
   ObjectSetInteger(0, nTxt, OBJPROP_TIME, tAnchor);
   ObjectSetDouble(0, nTxt, OBJPROP_PRICE, price);
   ObjectSetInteger(0, nTxt, OBJPROP_COLOR, clr);
   ObjectSetString(0, nTxt, OBJPROP_TEXT,
                   text + " " + DoubleToString(price, _Digits));
}

void DrawKeyLevels(double currentPrice)
{
   //--- Open giornaliero / settimanale / mensile
   if(ShowOpenLevels)
   {
      double od = iOpen(_Symbol, PERIOD_D1, 0);
      double ow = iOpen(_Symbol, PERIOD_W1, 0);
      double om = iOpen(_Symbol, PERIOD_MN1, 0);
      DrawHLevel("openD", od, clrDodgerBlue, STYLE_DASH,  "Open D");
      DrawHLevel("openW", ow, clrOrange,     STYLE_DASH,  "Open W");
      DrawHLevel("openM", om, clrMagenta,    STYLE_DASH,  "Open M");
   }

   //--- Massimi/minimi precedenti (giornaliero e settimanale)
   if(ShowPrevHL)
   {
      double pdh = iHigh(_Symbol, PERIOD_D1, 1);
      double pdl = iLow (_Symbol, PERIOD_D1, 1);
      double pwh = iHigh(_Symbol, PERIOD_W1, 1);
      double pwl = iLow (_Symbol, PERIOD_W1, 1);
      DrawHLevel("PDH", pdh, clrTomato,     STYLE_DOT, "PDH");
      DrawHLevel("PDL", pdl, clrTomato,     STYLE_DOT, "PDL");
      DrawHLevel("PWH", pwh, clrCrimson,    STYLE_DOT, "PWH");
      DrawHLevel("PWL", pwl, clrCrimson,    STYLE_DOT, "PWL");
   }

   //--- Numeri tondi attorno al prezzo (passo RoundStep, RoundN sopra/sotto)
   if(ShowRoundLevels && RoundStep > 0.0)
   {
      double base = MathFloor(currentPrice / RoundStep) * RoundStep;
      // Prima cancello i tondi vecchi che potrebbero essere usciti dal range
      for(int n = -RoundN; n <= RoundN; n++)
      {
         double lvl = base + n * RoundStep;
         string id = "round_" + IntegerToString(n + RoundN);
         DrawHLevel(id, lvl, clrDimGray, STYLE_DOT, "");
      }
   }
}
//+------------------------------------------------------------------+
