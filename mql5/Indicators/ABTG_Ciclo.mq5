//+------------------------------------------------------------------+
//|                                                   ABTG_Ciclo.mq5 |
//|  Oscillatore CICLO "Alta Velocita'" — formula ORIGINALE          |
//|  (da Ciclo_TW1.odt / Ciclo.pine di Claudio, 11/08/2026).         |
//|                                                                  |
//|  Composito di 4 stocastici lisciati:                             |
//|    K1=SMA(St(5),3) K2=SMA(St(14),3) K3=SMA(St(45),14)            |
//|    K4=SMA(St(75),20)                                             |
//|    I = (4.1*K1 + 2.5*K2 + K3 + 4*K4) / 11.6                      |
//|    CICLO = I - SMA(I,9)                                          |
//|  Cambio di segno = fine ciclo: positivo->negativo = massimo di   |
//|  ciclo formato (nel PREZZO), negativo->positivo = minimo.        |
//|                                                                  |
//|  Installazione: copia in MQL5\Indicators, apri MetaEditor, F7.   |
//|  Uso da manuale: si guarda sul TF del ciclo che stai leggendo.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 4
#property indicator_plots   2

#property indicator_label1  "Ciclo"
#property indicator_type1   DRAW_COLOR_HISTOGRAM
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  2
#property indicator_label2  "Zero"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDodgerBlue
#property indicator_width2  1

input int InpK1Len = 5;    // Stoch 1 - K length
input int InpK1Smo = 3;    // Stoch 1 - smooth
input int InpK2Len = 14;   // Stoch 2 - K length
input int InpK2Smo = 3;    // Stoch 2 - smooth
input int InpK3Len = 45;   // Stoch 3 - K length
input int InpK3Smo = 14;   // Stoch 3 - smooth
input int InpK4Len = 75;   // Stoch 4 - K length
input int InpK4Smo = 20;   // Stoch 4 - smooth
input int InpMmLen = 9;    // MM - media mobile su I

double BufCiclo[], BufColor[], BufZero[], BufI[];

int OnInit()
  {
   SetIndexBuffer(0,BufCiclo,INDICATOR_DATA);
   SetIndexBuffer(1,BufColor,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2,BufZero, INDICATOR_DATA);
   SetIndexBuffer(3,BufI,    INDICATOR_CALCULATIONS);
   IndicatorSetString(INDICATOR_SHORTNAME,"ABTG Ciclo (AltaV)");
   IndicatorSetInteger(INDICATOR_DIGITS,2);
   return(INIT_SUCCEEDED);
  }

//--- %K stocastico grezzo lisciato con SMA, calcolato alla barra i
double StochSmooth(const int i,const int rates_total,
                   const double &high[],const double &low[],const double &close[],
                   const int kLen,const int smo)
  {
   double s=0.0; int n=0;
   for(int j=0;j<smo;j++)
     {
      int b=i-j;
      if(b<kLen-1) break;
      double hi=high[b], lo=low[b];
      for(int k=1;k<kLen;k++)
        {
         if(high[b-k]>hi) hi=high[b-k];
         if(low[b-k] <lo) lo=low[b-k];
        }
      double raw = (hi>lo) ? (close[b]-lo)/(hi-lo)*100.0 : 50.0;
      s+=raw; n++;
     }
   return (n>0) ? s/n : 50.0;
  }

int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   int minBars = InpK4Len + InpK4Smo + InpMmLen + 2;
   if(rates_total < minBars) return(0);

   int start = (prev_calculated>0) ? prev_calculated-1 : minBars;
   for(int i=start; i<rates_total; i++)
     {
      double k1=StochSmooth(i,rates_total,high,low,close,InpK1Len,InpK1Smo);
      double k2=StochSmooth(i,rates_total,high,low,close,InpK2Len,InpK2Smo);
      double k3=StochSmooth(i,rates_total,high,low,close,InpK3Len,InpK3Smo);
      double k4=StochSmooth(i,rates_total,high,low,close,InpK4Len,InpK4Smo);
      BufI[i]=(4.1*k1 + 2.5*k2 + k3 + 4.0*k4)/11.6;

      double mm=0.0; int n=0;
      for(int j=0;j<InpMmLen && i-j>=0;j++){ mm+=BufI[i-j]; n++; }
      mm = (n>0) ? mm/n : BufI[i];

      BufCiclo[i]=BufI[i]-mm;
      BufColor[i]=(BufCiclo[i]>=0.0)?0.0:1.0;
      BufZero[i]=0.0;
     }
   return(rates_total);
  }
