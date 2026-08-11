//+------------------------------------------------------------------+
//|                                              ABTG_Supertrend.mq5 |
//|  Supertrend classico (hl2 +/- mult*ATR, bande che si stringono)  |
//|  per il trading manuale "Alta Velocita'": scaletta di gradini,   |
//|  VERDE sotto = supporti (trend su), ROSSO sopra = resistenze.    |
//|  La cuspide (cambio colore) e' il punto naturale dello stop.     |
//|  Parametri "standard" come negli EA della famiglia: ATR 10 x 3.  |
//|  Installazione: copia in MQL5\Indicators, MetaEditor, F7.        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1

#property indicator_label1  "Supertrend"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  2

input int    InpAtrPeriod = 10;   // periodo ATR
input double InpMult      = 3.0;  // moltiplicatore

double BufST[], BufColor[], BufUp[], BufDn[], BufDir[];
int hATR=INVALID_HANDLE;

int OnInit()
  {
   SetIndexBuffer(0,BufST,   INDICATOR_DATA);
   SetIndexBuffer(1,BufColor,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,BufUp,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(3,BufDn,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(4,BufDir,  INDICATOR_CALCULATIONS);
   IndicatorSetString(INDICATOR_SHORTNAME,
     StringFormat("ABTG Supertrend (%d, %.1f)",InpAtrPeriod,InpMult));
   hATR=iATR(_Symbol,_Period,InpAtrPeriod);
   if(hATR==INVALID_HANDLE) return(INIT_FAILED);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason){ if(hATR!=INVALID_HANDLE) IndicatorRelease(hATR); }

int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   if(rates_total<InpAtrPeriod+2) return(0);
   static double atr[];
   ArrayResize(atr,rates_total);
   int copied=CopyBuffer(hATR,0,0,rates_total,atr);
   if(copied<rates_total) return(prev_calculated);

   int start=(prev_calculated>0)?prev_calculated-1:InpAtrPeriod+1;
   if(start<InpAtrPeriod+1) start=InpAtrPeriod+1;
   for(int i=start;i<rates_total;i++)
     {
      double mid=(high[i]+low[i])/2.0;
      double up = mid + InpMult*atr[i];
      double dn = mid - InpMult*atr[i];

      //--- bande che si stringono soltanto
      BufUp[i] = (up<BufUp[i-1] || close[i-1]>BufUp[i-1]) ? up : BufUp[i-1];
      BufDn[i] = (dn>BufDn[i-1] || close[i-1]<BufDn[i-1]) ? dn : BufDn[i-1];

      //--- direzione: chiusura oltre la banda = flip
      double dirPrev=BufDir[i-1];
      if(dirPrev>=0.0) BufDir[i] = (close[i]<BufDn[i]) ? -1.0 : 1.0;
      else             BufDir[i] = (close[i]>BufUp[i]) ?  1.0 : -1.0;

      if(BufDir[i]>0.0){ BufST[i]=BufDn[i]; BufColor[i]=0.0; }
      else             { BufST[i]=BufUp[i]; BufColor[i]=1.0; }
     }
   return(rates_total);
  }
