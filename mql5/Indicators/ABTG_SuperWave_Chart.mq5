//+------------------------------------------------------------------+
//|                                     ABTG_SuperWave_Chart.mq5      |
//|                                                                  |
//|  Disegna sul grafico gli indicatori della strategia SuperWave:  |
//|   - SUPERTREND (ATR 10) a 3 moltiplicatori: 3.5 (segnale),      |
//|     3.0 e 2.5 (opzionali). Verde = trend su, Rosso = trend giu'. |
//|   - MEDIE MOBILI 14 / 100 / 200 (SMA o EMA).                    |
//|  Mettilo su H4 e su M3 (e dove vuoi). Colori/periodi modificabili.|
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 9
#property indicator_plots   6

//--- Supertrend 3.5
#property indicator_label1  "ST 3.5"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrLimeGreen, clrRed
#property indicator_width1  2
//--- Supertrend 3.0
#property indicator_label2  "ST 3.0"
#property indicator_type2   DRAW_COLOR_LINE
#property indicator_color2  clrLimeGreen, clrRed
#property indicator_width2  1
//--- Supertrend 2.5
#property indicator_label3  "ST 2.5"
#property indicator_type3   DRAW_COLOR_LINE
#property indicator_color3  clrLimeGreen, clrRed
#property indicator_width3  1
//--- MA 14 / 100 / 200
#property indicator_label4  "MA 14"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrAqua
#property indicator_width4  1
#property indicator_label5  "MA 100"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrOrange
#property indicator_width5  1
#property indicator_label6  "MA 200"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrTomato
#property indicator_width6  2

input int    InpAtrPeriod = 10;     // Periodo ATR Supertrend
input double InpMult1     = 3.5;    // Supertrend 1 (segnale)
input double InpMult2     = 3.0;    // Supertrend 2
input double InpMult3     = 2.5;    // Supertrend 3
input bool   InpShowST2   = false;  // mostra ST 3.0
input bool   InpShowST3   = false;  // mostra ST 2.5
input int    InpMA1       = 14;     // Media veloce
input int    InpMA2       = 100;    // Media media
input int    InpMA3       = 200;    // Media lenta
input ENUM_MA_METHOD InpMAmethod = MODE_SMA; // tipo medie (SMA/EMA...)

double st1[], c1[], st2[], c2[], st3[], c3[];
double ma1[], ma2[], ma3[];
double up1[],dn1[],up2[],dn2[],up3[],dn3[];
int    hAtr, hMa1, hMa2, hMa3;

//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, st1, INDICATOR_DATA);  SetIndexBuffer(1, c1, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2, st2, INDICATOR_DATA);  SetIndexBuffer(3, c2, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(4, st3, INDICATOR_DATA);  SetIndexBuffer(5, c3, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(6, ma1, INDICATOR_DATA);
   SetIndexBuffer(7, ma2, INDICATOR_DATA);
   SetIndexBuffer(8, ma3, INDICATOR_DATA);
   for(int p=0;p<6;p++) PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   hAtr = iATR(_Symbol,_Period,InpAtrPeriod);
   hMa1 = iMA(_Symbol,_Period,InpMA1,0,InpMAmethod,PRICE_CLOSE);
   hMa2 = iMA(_Symbol,_Period,InpMA2,0,InpMAmethod,PRICE_CLOSE);
   hMa3 = iMA(_Symbol,_Period,InpMA3,0,InpMAmethod,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE) return(INIT_FAILED);
   IndicatorSetString(INDICATOR_SHORTNAME,"SuperWave Chart");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void ComputeST(double mult,const double &high[],const double &low[],const double &close[],
               const double &atr[],int rates_total,int prev,double &val[],double &col[],
               double &upF[],double &dnF[])
  {
   if(ArraySize(upF)!=rates_total){ ArrayResize(upF,rates_total); ArrayResize(dnF,rates_total); }
   int start=(prev>InpAtrPeriod+1)? prev-1 : InpAtrPeriod+1;
   for(int i=start;i<rates_total;i++)
     {
      if(atr[i]==0){ val[i]=EMPTY_VALUE; col[i]=0; continue; }
      double mid=(high[i]+low[i])/2.0, ub=mid+mult*atr[i], lb=mid-mult*atr[i];
      if(i==InpAtrPeriod+1){ upF[i]=ub; dnF[i]=lb; val[i]=lb; col[i]=0; continue; }
      upF[i]=(ub<upF[i-1] || close[i-1]>upF[i-1]) ? ub : upF[i-1];
      dnF[i]=(lb>dnF[i-1] || close[i-1]<dnF[i-1]) ? lb : dnF[i-1];
      int dir;
      if(close[i]>upF[i-1])      dir=1;
      else if(close[i]<dnF[i-1]) dir=-1;
      else                       dir=(val[i-1]==dnF[i-1])?1:-1;
      val[i]=(dir>0)?dnF[i]:upF[i];
      col[i]=(dir>0)?0:1;    // 0=verde, 1=rosso
     }
  }
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],
                const double &close[],const long &tick_volume[],const long &volume[],
                const int &spread[])
  {
   if(rates_total<InpAtrPeriod+5) return(0);
   double atr[]; ArrayResize(atr,rates_total);
   if(CopyBuffer(hAtr,0,0,rates_total,atr)<=0) return(prev_calculated);

   ComputeST(InpMult1,high,low,close,atr,rates_total,prev_calculated,st1,c1,up1,dn1);
   if(InpShowST2) ComputeST(InpMult2,high,low,close,atr,rates_total,prev_calculated,st2,c2,up2,dn2);
   else { for(int i=0;i<rates_total;i++) st2[i]=EMPTY_VALUE; }
   if(InpShowST3) ComputeST(InpMult3,high,low,close,atr,rates_total,prev_calculated,st3,c3,up3,dn3);
   else { for(int i=0;i<rates_total;i++) st3[i]=EMPTY_VALUE; }

   double m[];
   if(CopyBuffer(hMa1,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma1[i]=m[i];
   if(CopyBuffer(hMa2,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma2[i]=m[i];
   if(CopyBuffer(hMa3,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma3[i]=m[i];
   return(rates_total);
  }
//+------------------------------------------------------------------+
