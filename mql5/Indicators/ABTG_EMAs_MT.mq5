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
//|  TF piu' BASSO del grafico: ogni barra mostra la EMA dell'ultima |
//|  barra del TF basso che le sta DENTRO (la chiusura, non l'inizio).|
//|  Se all'avvio i dati non sono pronti (es. weekend, niente tick)  |
//|  un timer chiede "Aggiorna" al grafico, max 60 volte.            |
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
bool   gPending = false;   // ultimo OnCalculate senza dati pronti
int    gTries   = 0;       // aggiornamenti forzati dal timer dall'ultimo calcolo riuscito

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
   gPending = false;
   gTries   = 0;
   EventSetTimer(1);
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   for(int i = 0; i < NL; i++)
      if(gH[i] != INVALID_HANDLE)
         IndicatorRelease(gH[i]);
  }

//+------------------------------------------------------------------+
//| Riempie il buffer 'b' per la EMA 'i' da 'from' a rates_total-1   |
//| Ritorna false se i dati non sono ancora pronti                   |
//+------------------------------------------------------------------+
bool FillLine(const int i, double &b[], const int from0, const int rates_total, const datetime &time[])
  {
   if(gH[i] == INVALID_HANDLE)
     {
      for(int k = from0; k < rates_total; k++)
         b[k] = EMPTY_VALUE;
      return true;
     }

   ENUM_TIMEFRAMES tf = (gTf[i] == PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)_Period : gTf[i];
   int per = gPer[i];

   // stesso TF del grafico: copia diretta
   if(tf == (ENUM_TIMEFRAMES)_Period)
     {
      // la EMA non ha ancora calcolato tutte le barre del grafico: allineamento non garantito
      if(BarsCalculated(gH[i]) < rates_total)
         return false;
      int n = rates_total - from0;
      double tmp[];
      ArraySetAsSeries(tmp, false);
      // copia le ultime n barre in ordine cronologico
      if(CopyBuffer(gH[i], 0, 0, n, tmp) != n)
         return false;
      for(int k = 0; k < n; k++)
        {
         int idx = from0 + k;
         // prime per-1 barre = riscaldamento, non e' ancora una EMA 'per'
         if(idx < per - 1 || tmp[k] == EMPTY_VALUE || tmp[k] <= 0.0)
            b[idx] = EMPTY_VALUE;
         else
            b[idx] = tmp[k];
        }
      return true;
     }

   // TF diverso
   int bars = Bars(_Symbol, tf);
   if(bars <= 0 || BarsCalculated(gH[i]) < bars)
      return false;
   bool higher = (PeriodSeconds(tf) > PeriodSeconds((ENUM_TIMEFRAMES)_Period));

   int from = from0;
   if(from > 0 && higher)
     {
      // TF piu' alto: la sua barra in corso (e quella appena chiusa) coprono MOLTE barre
      // del grafico, e vanno riscritte tutte, non solo le ultime 3 (se no il gradino
      // resta una rampa di valori intermedi).
      datetime t1 = iTime(_Symbol, tf, 1);
      if(t1 <= 0)
         return false;
      while(from > 0 && time[from - 1] >= t1)
         from--;
     }

   // quante barre del TF scelto servono: tutte al primo giro, poche dopo
   int cnt = bars;
   if(from > 0)
     {
      int shFrom = iBarShift(_Symbol, tf, time[from], false);
      if(shFrom >= 0)
         cnt = MathMin(bars, shFrom + 2);
     }
   double ma[];
   ArraySetAsSeries(ma, true);
   int got = CopyBuffer(gH[i], 0, 0, cnt, ma);
   if(got <= 0 || (from > 0 && got < cnt))
      return false;

   for(int k = from; k < rates_total; k++)
     {
      int sh = -1;
      if(higher)
         sh = iBarShift(_Symbol, tf, time[k], false);         // barra del TF alto che CONTIENE la barra del grafico
      else
         if(k < rates_total - 1)
            sh = iBarShift(_Symbol, tf, time[k + 1] - 1, false); // TF basso: ultima sua barra DENTRO la barra del grafico
         else
            sh = 0;                                               // barra in corso: il valore piu' recente
      if(sh < 0 || sh >= got || (bars - 1 - sh) < per - 1 || ma[sh] == EMPTY_VALUE || ma[sh] <= 0.0)
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
   // primo giro: tutto; poi dalle ultime barre gia' calcolate (anche se ne sono arrivate
   // molte insieme, es. dopo una riconnessione). I TF alti allargano da soli in FillLine.
   int from = (prev_calculated <= 0) ? 0 : MathMax(0, MathMin(prev_calculated, rates_total) - 3);
   bool ok = true;
   ok = FillLine(0, gBuf1, from, rates_total, time) && ok;
   ok = FillLine(1, gBuf2, from, rates_total, time) && ok;
   ok = FillLine(2, gBuf3, from, rates_total, time) && ok;
   ok = FillLine(3, gBuf4, from, rates_total, time) && ok;
   if(!ok)
     {
      gPending = true;   // il timer forza un ricalcolo anche senza tick (weekend)
      return 0;          // dati non ancora pronti: ricalcolo completo al prossimo giro
     }
   gPending = false;
   gTries   = 0;
   return rates_total;
  }

//+------------------------------------------------------------------+
//| Senza tick (weekend, mercato chiuso) OnCalculate non riparte da  |
//| solo: finche' i dati degli altri TF non sono pronti, si chiede   |
//| al grafico un aggiornamento (stesso simbolo e stesso TF = e' il  |
//| comando "Aggiorna", non cambia nulla).                           |
//+------------------------------------------------------------------+
void OnTimer()
  {
   if(!gPending || gTries >= 60)   // al massimo un minuto di tentativi, poi si aspetta il tick
      return;
   gPending = false;
   gTries++;
   ChartSetSymbolPeriod(0, _Symbol, _Period);
  }
//+------------------------------------------------------------------+
