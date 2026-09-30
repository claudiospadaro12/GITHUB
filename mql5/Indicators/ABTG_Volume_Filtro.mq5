//+------------------------------------------------------------------+
//|                                          ABTG_Volume_Filtro.mq5   |
//|  Pannello VOLUMI in sottofinestra: istogramma del volume TICK     |
//|  colorato + linea della media (e della soglia).                   |
//|                                                                   |
//|   - VERDE  = il volume della barra PASSA il filtro:               |
//|              tick_volume > SMA(tick_volume, InpVolMaPeriod)       |
//|                            * InpVolFactor                         |
//|   - GRIGIO = non passa (o storico troppo corto per la media).     |
//|   - Linea oro  = media dei volumi (SMA inclusiva della barra).    |
//|   - Linea rossa punteggiata = soglia (media x fattore); si vede   |
//|     solo se il fattore e' diverso da 1,00 (altrimenti coincide     |
//|     con la media e viene nascosta).                               |
//|                                                                   |
//|  E' lo STESSO calcolo del filtro (e) di ABTG_Segnali_EMA_BB_ST    |
//|  (motore ABTG_Confluenza.mqh): stessi default (periodo 20,        |
//|  fattore 1.0), stessa media inclusiva, stesso confronto stretto   |
//|  ">". Se cambi un default qui, cambialo anche la'.                |
//|                                                                   |
//|  VOLUME TICK, NON VOLUME REALE. In MT5 il "volume" di una barra   |
//|  su forex/CFD/oro/indici e' il NUMERO DI TICK (variazioni di      |
//|  prezzo ricevute dal broker), non i contratti o i lotti           |
//|  realmente scambiati. E' un'approssimazione dell'attivita': dice  |
//|  quanto si e' MOSSO il prezzo, non quanto si e' scambiato, e      |
//|  cambia da broker a broker (feed diversi = tick diversi). Il      |
//|  volume reale (campo "real volume") esiste solo per strumenti di  |
//|  borsa e qui NON viene usato.                                     |
//|                                                                   |
//|  Sola lettura: non tocca ordini ne' altri indicatori.             |
//|  Di norma lo aggiunge da solo ABTG_Segnali_EMA_BB_ST (input       |
//|  InpAutoPannelloVolumi); si puo' anche trascinare a mano.         |
//|  Installazione: copia in MQL5\Indicators, MetaEditor, F7.         |
//+------------------------------------------------------------------+
#property copyright "ABTG - progetto Claudio"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   3

#property indicator_label1  "Volume tick"
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  clrLimeGreen,clrGray
#property indicator_style1  STYLE_SOLID
#property indicator_width1  2

#property indicator_label2  "Media volume"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrGold
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

#property indicator_label3  "Soglia (media x fattore)"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrangeRed
#property indicator_style3  STYLE_DOT
#property indicator_width3  1

//--- ATTENZIONE: l'ordine dei DUE input e' quello con cui li passa iCustom
//    dal file principale (periodo, fattore). Non riordinarli.
input int    InpVolMaPeriod = 20;    // periodo della media dei volumi
input double InpVolFactor   = 1.0;   // fattore: passa se volume > media x fattore

double gVol[];     // 0: istogramma
double gCol[];     // 1: indice colore (0 verde, 1 grigio)
double gMa[];      // 2: media
double gThr[];     // 3: soglia

//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpVolMaPeriod < 1 || InpVolFactor <= 0.0)
     {
      Print("ABTG_Volume_Filtro: parametri non validi (periodo >= 1, fattore > 0).");
      return INIT_PARAMETERS_INCORRECT;
     }
   bool ok = true;
   ok = SetIndexBuffer(0, gVol, INDICATOR_DATA)        && ok;
   ok = SetIndexBuffer(1, gCol, INDICATOR_COLOR_INDEX) && ok;
   ok = SetIndexBuffer(2, gMa,  INDICATOR_DATA)        && ok;
   ok = SetIndexBuffer(3, gThr, INDICATOR_DATA)        && ok;
   if(!ok)
     {
      Print("ABTG_Volume_Filtro: SetIndexBuffer fallito, errore ", GetLastError());
      return INIT_FAILED;
     }
   for(int p = 0; p < 3; p++)
      PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);
   PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, InpVolMaPeriod - 1);
   PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, InpVolMaPeriod - 1);
   // con fattore 1,00 la soglia coincide con la media: si nasconde
   if(MathAbs(InpVolFactor - 1.0) < 1e-9)
      PlotIndexSetInteger(2, PLOT_DRAW_TYPE, DRAW_NONE);
   IndicatorSetInteger(INDICATOR_DIGITS, 0);
   // il nome inizia SEMPRE con "ABTG Volume Filtro": il file principale lo cerca per prefisso
   IndicatorSetString(INDICATOR_SHORTNAME,
                      StringFormat("ABTG Volume Filtro (%d, %.2f)", InpVolMaPeriod, InpVolFactor));
   return INIT_SUCCEEDED;
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
  {
   if(rates_total < 1)
      return 0;
   ArraySetAsSeries(tick_volume, false);
   int start = (prev_calculated <= 0 || prev_calculated > rates_total) ? 0 : prev_calculated - 1;
   for(int i = start; i < rates_total; i++)
     {
      gVol[i] = (double)tick_volume[i];
      if(i >= InpVolMaPeriod - 1)
        {
         double s = 0.0;
         for(int k = i - InpVolMaPeriod + 1; k <= i; k++)
            s += (double)tick_volume[k];
         double ma  = s / InpVolMaPeriod;
         double thr = ma * InpVolFactor;
         gMa[i]  = ma;
         gThr[i] = thr;
         gCol[i] = (gVol[i] > thr) ? 0.0 : 1.0;
        }
      else
        {
         gMa[i]  = EMPTY_VALUE;
         gThr[i] = EMPTY_VALUE;
         gCol[i] = 1.0;
        }
     }
   return rates_total;
  }
//+------------------------------------------------------------------+
