//+------------------------------------------------------------------+
//|                                 ABTG_SuperWave_Dashboard.mq5      |
//|                                                                  |
//|  INDICATORE UNICO "SUPERWAVE" (strategia Chiari) - tutto in uno:  |
//|                                                                  |
//|   1) DASHBOARD: griglia SIMBOLI x TIMEFRAME (BUY/SELL su          |
//|      inversione Supertrend). CLICK su una cella -> vai su quel    |
//|      simbolo E su quel timeframe. Simbolo LAMPEGGIA quando H4 e   |
//|      M3 concordano (confluenza), testo bianco = leggibile.       |
//|   2) LINEE (tasto SUPERTREND): 3 Supertrend + 3 medie.          |
//|   3) LIVELLI price action (tasto LIVELLI): supporti/resistenze.  |
//|   4) OPERAZIONE: pannello in alto a DESTRA con INGRESSO, STOP e   |
//|      3 TARGET, con la SIZE al rischio 1% divisa sui 3 ordini.    |
//|      Sul grafico: freccia BUY/SELL + linee ingresso/stop/3 tp.  |
//|                                                                  |
//|  Adatta InpSymbols ai TUOI ticker BCM. Metti su UN grafico.     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "4.00"
#property indicator_chart_window
#property indicator_buffers 15
#property indicator_plots   8
#property indicator_label1  "HeikinAshi"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen, clrRed
#property indicator_width1  2
#property indicator_label2  "ST 3.5"
#property indicator_type2   DRAW_COLOR_LINE
#property indicator_color2  clrLimeGreen, clrRed
#property indicator_width2  2
#property indicator_label3  "ST 3.0"
#property indicator_type3   DRAW_COLOR_LINE
#property indicator_color3  clrLimeGreen, clrRed
#property indicator_width3  1
#property indicator_label4  "ST 2.5"
#property indicator_type4   DRAW_COLOR_LINE
#property indicator_color4  clrLimeGreen, clrRed
#property indicator_width4  1
#property indicator_label5  "MA 14"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrAqua
#property indicator_label6  "MA 50"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrGold
#property indicator_label7  "MA 100"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrOrange
#property indicator_label8  "MA 200"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrTomato
#property indicator_width8  2

input string InpSymbols   = "D30EUR,NASUSD,SPXUSD,XAUUSD,EURUSD,EURGBP,EURJPY,EURCHF,EURAUD,EURCAD,EURNZD,GBPUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,CHFJPY,CADCHF,CADJPY,USDJPY,USDCHF,USDCAD,AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,BTCUSD"; // Simboli (adatta ai TUOI BCM!)
input int    InpAtrPeriod = 10;    // Periodo ATR del Supertrend
input double InpMult1     = 3.5;   // Supertrend 1 (segnale)
input double InpMult2     = 3.0;   // Supertrend 2
input double InpMult3     = 2.5;   // Supertrend 3
input bool   InpShowST2   = true;  // mostra ST 3.0
input bool   InpShowST3   = true;  // mostra ST 2.5
input int    InpMA1       = 14;    // Media veloce (riferimento pullback)
input int    InpMA2       = 50;    // Media 50 (per l'INCROCIO - Giorgio Bo)
input int    InpMA3       = 100;   // Media media
input int    InpMA4       = 200;   // Media lenta
input ENUM_MA_METHOD InpMAmethod = MODE_SMA; // tipo medie
input bool   InpShowCross = true;  // segna l'INCROCIO media50 x media200 a favore del Supertrend
input int    InpCrossWindow = 20;  // quanto indietro cercare l'incrocio (barre)
input int    InpMaxCandles= 10;    // accendi la cella solo se il segnale e' entro N candele
input int    InpBatch     = 6;     // simboli ricalcolati per secondo (piu' basso = grafico piu' fluido)
input bool   InpBlink     = true;  // lampeggio (dolce) dei simboli in confluenza H4/M3
//--- OPERAZIONE (ingresso/stop/target + size) ---
enum ENUM_TPMODE { TP_PRICEACTION, TP_RMULTIPLI };
input bool   InpShowTrade = true;  // mostra operazione (grafico + pannello dx)
input ENUM_TPMODE InpTPmode = TP_PRICEACTION; // criterio TP: livelli price action / multipli di R
input double InpStopAtrFloor = 1.0; // stop minimo = N x ATR (evita stop troppo stretti su M3)
input double InpRiskPct   = 1.0;   // Rischio per operazione, in % del conto
input double InpTP1_R     = 1.0;   // TARGET 1 in R (usato in modo R o come riserva)
input double InpTP2_R     = 2.0;   // TARGET 2 in R
input double InpTP3_R     = 3.0;   // TARGET 3 in R
input double InpSize1     = 40;    // % della size sul TP1
input double InpSize2     = 30;    // % della size sul TP2
input double InpSize3     = 30;    // % della size sul TP3
//--- LIVELLI price action ---
input bool   InpShowLevels   = false; // livelli ACCESI all'avvio? (c'e' il tasto)
input bool   InpShowSTstart  = true;  // linee Supertrend ACCESE all'avvio?
input int    InpLevelsLook   = 300;  // barre da analizzare per i livelli
input int    InpFractal      = 2;    // ampiezza swing (barre a dx/sx)
input int    InpMaxLevels    = 3;    // quanti supporti/resistenze per lato
//--- Pannello ---
input int    InpX         = 6;     // Posizione pannello X (px)
input int    InpY         = 44;    // Posizione pannello Y (px)
input int    InpSymW      = 64;    // Larghezza colonna simboli
input int    InpCellW     = 50;    // Larghezza celle TF
input int    InpCellH     = 19;    // Altezza righe
input int    InpFont      = 8;     // Dimensione testo
//--- COLORI (modificabili)
input color  InpBuyCol    = C'38,166,91';    // verde BUY
input color  InpSellCol   = C'200,55,50';    // rosso SELL
input color  InpEmptyCol  = C'24,26,32';     // nero pieno celle vuote
input color  InpPanelCol  = C'16,18,22';     // sfondo pannello (opaco)
input color  InpGridCol   = C'55,58,66';     // bordo celle
input color  InpTextCol   = C'205,208,214';  // testo simboli
input color  InpHeadCol   = clrWhite;        // testo intestazioni
input color  InpStopCol   = clrRed;          // linea STOP
input color  InpTargetCol = clrLime;         // linea TARGET
input color  InpResCol    = C'230,120,120';  // RESISTENZA
input color  InpSupCol    = C'120,180,230';  // SUPPORTO

ENUM_TIMEFRAMES TFS[]     = {PERIOD_M1,PERIOD_M3,PERIOD_M5,PERIOD_M15,PERIOD_H1,PERIOD_H4,PERIOD_D1};
string          TFNAMES[] = {"M1","M3","M5","M15","H1","H4","D1"};
int             NTF       = 7;

string   gSyms[];
int      gNsym = 0;
int      gConfl[];        // per simbolo: +1 confl BUY, -1 confl SELL, 0 no
bool     gHA     = false;
bool     gHidden = false;
bool     gShowLevels = false;
bool     gShowST     = true;
double   gRiskPct = 1.0;    // rischio % modificabile dal pannello (parte da InpRiskPct)
bool     gCrossOK = false;  // incrocio medie a favore del Supertrend (condizione ottima)
int      gCrossDir = 0;
long     gcBull,gcBear,gcUp,gcDown;  // colori candele reali (per nasconderle in Heikin Ashi)
bool     gcSaved = false;
int      gUpdIdx = 0;       // indice del ricalcolo incrementale (a rotazione)
uint     gTick   = 0;
string   P = "SWD_";

double haO[], haH[], haL[], haC[], haCol[];
double st1[], c1[], st2[], c2[], st3[], c3[];
double ma1[], ma2[], ma3[], ma4[];
double up1[],dn1[],up2[],dn2[],up3[],dn3[];
int    hAtr, hMa1, hMa2, hMa3, hMa4;

int gHeaderY, gRow0Y;

//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, haO,  INDICATOR_DATA);
   SetIndexBuffer(1, haH,  INDICATOR_DATA);
   SetIndexBuffer(2, haL,  INDICATOR_DATA);
   SetIndexBuffer(3, haC,  INDICATOR_DATA);
   SetIndexBuffer(4, haCol,INDICATOR_COLOR_INDEX);
   SetIndexBuffer(5, st1,  INDICATOR_DATA);  SetIndexBuffer(6, c1, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(7, st2,  INDICATOR_DATA);  SetIndexBuffer(8, c2, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(9, st3,  INDICATOR_DATA);  SetIndexBuffer(10,c3, INDICATOR_COLOR_INDEX);
   SetIndexBuffer(11,ma1,  INDICATOR_DATA);
   SetIndexBuffer(12,ma2,  INDICATOR_DATA);
   SetIndexBuffer(13,ma3,  INDICATOR_DATA);
   SetIndexBuffer(14,ma4,  INDICATOR_DATA);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   for(int p=1;p<8;p++) PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   hAtr = iATR(_Symbol,_Period,InpAtrPeriod);
   hMa1 = iMA(_Symbol,_Period,InpMA1,0,InpMAmethod,PRICE_CLOSE);
   hMa2 = iMA(_Symbol,_Period,InpMA2,0,InpMAmethod,PRICE_CLOSE);
   hMa3 = iMA(_Symbol,_Period,InpMA3,0,InpMAmethod,PRICE_CLOSE);
   hMa4 = iMA(_Symbol,_Period,InpMA4,0,InpMAmethod,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE) return(INIT_FAILED);
   IndicatorSetString(INDICATOR_SHORTNAME,"SuperWave");

   gShowLevels = InpShowLevels;
   gShowST     = InpShowSTstart;
   gRiskPct    = InpRiskPct;
   gcBull=ChartGetInteger(0,CHART_COLOR_CANDLE_BULL);
   gcBear=ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR);
   gcUp  =ChartGetInteger(0,CHART_COLOR_CHART_UP);
   gcDown=ChartGetInteger(0,CHART_COLOR_CHART_DOWN);
   gcSaved=true;

   gNsym = StringSplit(InpSymbols, ',', gSyms);
   ArrayResize(gConfl, gNsym); ArrayInitialize(gConfl, 0);
   for(int i=0;i<gNsym;i++){ StringTrimLeft(gSyms[i]); StringTrimRight(gSyms[i]); if(StringLen(gSyms[i])>0) SymbolSelect(gSyms[i], true); }

   gHeaderY = InpY + InpCellH;
   gRow0Y   = gHeaderY + InpCellH;

   BuildPanel();
   EventSetTimer(1);            // 1s: lampeggio ogni sec, ricalcolo ogni 3
   UpdateAll();
   PrintFormat("[SuperWave] AVVIATO: %d simboli, operazione+linee+livelli su %s %s.",
               gNsym, _Symbol, EnumToString(_Period));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, P);
   if(gcSaved)   // ripristina le candele reali
     {
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,gcBull);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,gcBear);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,gcUp);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,gcDown);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//| Heikin Ashi ON -> nasconde le candele reali (colori = sfondo);   |
//| OFF -> ripristina i colori originali.                            |
//+------------------------------------------------------------------+
void ApplyHA()
  {
   if(!gcSaved) return;
   if(gHA)
     {
      long bg=ChartGetInteger(0,CHART_COLOR_BACKGROUND);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,bg);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,bg);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,bg);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,bg);
     }
   else
     {
      ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,gcBull);
      ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,gcBear);
      ChartSetInteger(0,CHART_COLOR_CHART_UP,gcUp);
      ChartSetInteger(0,CHART_COLOR_CHART_DOWN,gcDown);
     }
  }
//+------------------------------------------------------------------+
void OnTimer()
  {
   gTick++;
   UpdateBatch();                // pochi simboli per tick -> nessun blocco (fluido anche sotto carico)
   BlinkConfluence();            // lampeggio ogni secondo (leggero)
  }
//+------------------------------------------------------------------+
color Dim(color c,double f)   // sfuma 'c' verso il colore pannello (f=0 pieno, 1 spento)
  {
   int r=(c&0xFF), g=(c>>8)&0xFF, b=(c>>16)&0xFF;
   int r2=(InpPanelCol&0xFF), g2=(InpPanelCol>>8)&0xFF, b2=(InpPanelCol>>16)&0xFF;
   int R=(int)(r+(r2-r)*f), G=(int)(g+(g2-g)*f), B=(int)(b+(b2-b)*f);
   return (color)((B<<16)|(G<<8)|R);
  }
void BlinkConfluence()
  {
   if(gHidden) return;
   bool bright = (!InpBlink) || (((gTick/2)%2)==0);   // cambia ogni 2 secondi
   bool any=false;
   for(int s=0;s<gNsym;s++)
     {
      if(gConfl[s]==0) continue;
      any=true;
      color full = (gConfl[s]>0)?InpBuyCol:InpSellCol;
      color c = bright ? full : Dim(full,0.55);        // pulsazione dolce, mai nero
      ObjectSetInteger(0,P+"sb_"+(string)s,OBJPROP_BGCOLOR,c);
     }
   if(any) ChartRedraw();
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
      col[i]=(dir>0)?0:1;
     }
  }
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],
                const double &close[],const long &tick_volume[],const long &volume[],
                const int &spread[])
  {
   if(rates_total<InpAtrPeriod+5) return(0);

   if(!gHA)
     { for(int i=(prev_calculated>0?prev_calculated-1:0); i<rates_total; i++){ haO[i]=0;haH[i]=0;haL[i]=0;haC[i]=0;haCol[i]=0; } }
   else
     {
      int s=(prev_calculated>1)?prev_calculated-1:1;
      if(prev_calculated==0){ haO[0]=open[0];haH[0]=high[0];haL[0]=low[0];haC[0]=(open[0]+high[0]+low[0]+close[0])/4.0;haCol[0]=(haC[0]>=haO[0]?0:1); }
      for(int i=s;i<rates_total;i++)
        { double c=(open[i]+high[i]+low[i]+close[i])/4.0, o=(haO[i-1]+haC[i-1])/2.0;
          haO[i]=o;haH[i]=MathMax(high[i],MathMax(o,c));haL[i]=MathMin(low[i],MathMin(o,c));haC[i]=c;haCol[i]=(c>=o?0:1); }
     }

   double atr[]; ArrayResize(atr,rates_total);
   if(CopyBuffer(hAtr,0,0,rates_total,atr)<=0) return(prev_calculated);

   // ST 3.5 sempre calcolato (serve all'operazione), ma mostrato solo se gShowST
   ComputeST(InpMult1,high,low,close,atr,rates_total,prev_calculated,st1,c1,up1,dn1);
   if(gShowST && InpShowST2) ComputeST(InpMult2,high,low,close,atr,rates_total,prev_calculated,st2,c2,up2,dn2);
   else for(int i=0;i<rates_total;i++) st2[i]=EMPTY_VALUE;
   if(gShowST && InpShowST3) ComputeST(InpMult3,high,low,close,atr,rates_total,prev_calculated,st3,c3,up3,dn3);
   else for(int i=0;i<rates_total;i++) st3[i]=EMPTY_VALUE;

   if(gShowST)
     {
      double m[];
      if(CopyBuffer(hMa1,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma1[i]=m[i];
      if(CopyBuffer(hMa2,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma2[i]=m[i];
      if(CopyBuffer(hMa3,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma3[i]=m[i];
      if(CopyBuffer(hMa4,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma4[i]=m[i];
     }
   else
     { for(int i=0;i<rates_total;i++){ st1[i]=EMPTY_VALUE; ma1[i]=EMPTY_VALUE; ma2[i]=EMPTY_VALUE; ma3[i]=EMPTY_VALUE; ma4[i]=EMPTY_VALUE; } }

   DrawCross(rates_total,time);
   DrawTrade(rates_total,time,high,low,close);
   DrawLevels(rates_total,time,high,low,close);
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| INCROCIO media50 x media200 a favore del Supertrend = ottimo    |
//+------------------------------------------------------------------+
void DrawCross(int rt,const datetime &time[])
  {
   string nm=P+"cross";
   gCrossOK=false; gCrossDir=0;
   ObjectDelete(0,nm); ObjectDelete(0,nm+"t");
   if(!InpShowCross || !gShowST) return;
   int w=MathMin(InpCrossWindow, rt-3);
   for(int i=rt-2; i>=rt-2-w && i>1; i--)
     {
      if(ma2[i]==EMPTY_VALUE || ma4[i]==EMPTY_VALUE || ma2[i-1]==EMPTY_VALUE || ma4[i-1]==EMPTY_VALUE) continue;
      bool up = (ma2[i-1]<=ma4[i-1] && ma2[i]>ma4[i]);   // 50 incrocia 200 al rialzo
      bool dn = (ma2[i-1]>=ma4[i-1] && ma2[i]<ma4[i]);   // 50 incrocia 200 al ribasso
      if(!up && !dn) continue;
      int cdir  = up?1:-1;
      int stdir = (c1[i]==0)?1:-1;          // direzione Supertrend a quella barra
      bool agree = (cdir==stdir);           // l'incrocio "taglia" il Supertrend a favore
      gCrossOK=agree; gCrossDir=cdir;
      color col = agree ? (cdir>0?InpBuyCol:InpSellCol) : C'130,130,130';
      if(ObjectFind(0,nm)<0) ObjectCreate(0,nm,OBJ_ARROW,0,0,0);
      ObjectSetInteger(0,nm,OBJPROP_TIME,time[i]);
      ObjectSetDouble (0,nm,OBJPROP_PRICE,ma2[i]);
      ObjectSetInteger(0,nm,OBJPROP_ARROWCODE,118);   // diamante
      ObjectSetInteger(0,nm,OBJPROP_COLOR,col);
      ObjectSetInteger(0,nm,OBJPROP_WIDTH,3);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      Txt(nm+"t",time[i],ma2[i], agree?"INCROCIO OTTIMO":"incrocio 50x200", col);
      break;                                 // il piu' recente
     }
  }
//+------------------------------------------------------------------+
//| Calcola il segnale operativo corrente (dir/entry/stop)          |
//+------------------------------------------------------------------+
bool TradeSignal(int rt,const double &close[],int &dir,double &entry,double &stop)
  {
   int b=rt-2;
   if(b<InpAtrPeriod+2) return false;
   double stv;
   // st1 puo' essere EMPTY se ST nascosto: ricalcolo al volo il valore
   stv = st1[b];
   if(stv==EMPTY_VALUE || stv<=0)
     {
      double a[]; if(CopyBuffer(hAtr,0,0,rt,a)<=0) return false;
      double up[],dn[]; ArrayResize(up,rt); ArrayResize(dn,rt);
      double v[],cc[]; ArrayResize(v,rt); ArrayResize(cc,rt);
      MqlRates r[]; if(CopyRates(_Symbol,_Period,0,rt,r)<=0) return false;
      double h2[],l2[],c2b[]; ArrayResize(h2,rt);ArrayResize(l2,rt);ArrayResize(c2b,rt);
      for(int i=0;i<rt;i++){h2[i]=r[i].high;l2[i]=r[i].low;c2b[i]=r[i].close;}
      ComputeST(InpMult1,h2,l2,c2b,a,rt,0,v,cc,up,dn);
      stv=v[b]; if(stv==EMPTY_VALUE||stv<=0) return false;
      dir=(cc[b]==0)?1:-1;
     }
   else dir=(c1[b]==0)?1:-1;
   entry=close[rt-1];
   stop=stv;
   return (MathAbs(entry-stop)>0);
  }
//+------------------------------------------------------------------+
bool NearAny(double &arr[],double p,double tol)
  { for(int i=0;i<ArraySize(arr);i++) if(MathAbs(arr[i]-p)<tol) return true; return false; }
//--- sceglie i 3 TP: dai LIVELLI price action (modo C), riempiendo i mancanti coi multipli di R
void PickTPs(int dir,double entry,double risk,double &res[],double &sup[],double &o1,double &o2,double &o3)
  {
   double cand[]; ArrayResize(cand,0);
   double tol=risk*0.4;
   if(InpTPmode==TP_PRICEACTION)
     {
      if(dir>0)
         for(int i=0;i<ArraySize(res) && ArraySize(cand)<3;i++)
           { double p=res[i]; if(p<=entry+risk*0.2 || NearAny(cand,p,tol)) continue;
             int n=ArraySize(cand);ArrayResize(cand,n+1);cand[n]=p; }
      else
         for(int i=ArraySize(sup)-1;i>=0 && ArraySize(cand)<3;i--)
           { double p=sup[i]; if(p>=entry-risk*0.2 || NearAny(cand,p,tol)) continue;
             int n=ArraySize(cand);ArrayResize(cand,n+1);cand[n]=p; }
     }
   double rr[3]; rr[0]=InpTP1_R; rr[1]=InpTP2_R; rr[2]=InpTP3_R;
   for(int i=0;i<3 && ArraySize(cand)<3;i++)
     { double p=(dir>0)?entry+rr[i]*risk:entry-rr[i]*risk;
       if(NearAny(cand,p,tol)) continue; int n=ArraySize(cand);ArrayResize(cand,n+1);cand[n]=p; }
   for(int a=0;a<ArraySize(cand);a++) for(int b=a+1;b<ArraySize(cand);b++)
      if(MathAbs(cand[b]-entry)<MathAbs(cand[a]-entry)){ double t=cand[a];cand[a]=cand[b];cand[b]=t; }
   o1=(ArraySize(cand)>0)?cand[0]:entry;
   o2=(ArraySize(cand)>1)?cand[1]:o1;
   o3=(ArraySize(cand)>2)?cand[2]:o2;
  }
//+------------------------------------------------------------------+
void DrawTrade(int rt,const datetime &time[],const double &high[],const double &low[],const double &close[])
  {
   string pre=P+"op_";
   string names[9]={"entry","sl","tp1","tp2","tp3","entryT","slT","arrow","dir"};
   int dir; double entry,stop;
   if(!InpShowTrade || !TradeSignal(rt,close,dir,entry,stop))
     {
      for(int i=0;i<9;i++) ObjectDelete(0,pre+names[i]);
      ObjectDelete(0,pre+"tp1T"); ObjectDelete(0,pre+"tp2T"); ObjectDelete(0,pre+"tp3T");
      DrawTradePanel(false,0,0,0,0,0,0);
      return;
     }
   // protezione: se lo stop non e' valido, niente operazione (evita numeri assurdi)
   if(stop==EMPTY_VALUE || stop<=0 || MathAbs(entry-stop) > entry*0.5)
     {
      for(int i=0;i<9;i++) ObjectDelete(0,pre+names[i]);
      ObjectDelete(0,pre+"tp1T"); ObjectDelete(0,pre+"tp2T"); ObjectDelete(0,pre+"tp3T");
      DrawTradePanel(false,0,0,0,0,0,0);
      return;
     }
   // floor ATR sullo stop: su M3 il Supertrend e' troppo vicino -> non meno di N*ATR
   double ab[]; double atrv=0;
   if(CopyBuffer(hAtr,0,1,1,ab)==1 && ab[0]>0 && ab[0]<entry) atrv=ab[0];  // ATR ultima barra chiusa
   double floor=InpStopAtrFloor*atrv;
   if(floor>0 && MathAbs(entry-stop)<floor) stop=(dir>0)?entry-floor:entry+floor;
   double risk=MathAbs(entry-stop);
   // TP dai livelli di price action (con riserva a multipli di R)
   double res[],sup[]; ComputeLevels(rt,high,low,close,res,sup);
   double tp1,tp2,tp3; PickTPs(dir,entry,risk,res,sup,tp1,tp2,tp3);
   int dg=_Digits; datetime tnow=time[rt-1];
   color ecol=(dir>0)?InpBuyCol:InpSellCol;
   string etxt=(dir>0)?"BUY":"SELL";

   HLine(pre+"entry",entry,ecol,STYLE_SOLID);
   HLine(pre+"sl",   stop, InpStopCol,STYLE_DASH);
   HLine(pre+"tp1",  tp1,  InpTargetCol,STYLE_DOT);
   HLine(pre+"tp2",  tp2,  InpTargetCol,STYLE_DOT);
   HLine(pre+"tp3",  tp3,  InpTargetCol,STYLE_DASH);
   Txt(pre+"entryT",tnow,entry,etxt+"  "+DoubleToString(entry,dg),ecol);
   Txt(pre+"slT",   tnow,stop, "STOP  "+DoubleToString(stop,dg),  InpStopCol);
   Txt(pre+"tp1T",  tnow,tp1,  "TP1  "+DoubleToString(tp1,dg),    InpTargetCol);
   Txt(pre+"tp2T",  tnow,tp2,  "TP2  "+DoubleToString(tp2,dg),    InpTargetCol);
   Txt(pre+"tp3T",  tnow,tp3,  "TP3  "+DoubleToString(tp3,dg),    InpTargetCol);
   if(ObjectFind(0,pre+"arrow")<0) ObjectCreate(0,pre+"arrow",OBJ_ARROW,0,0,0);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_TIME,tnow);
   ObjectSetDouble (0,pre+"arrow",OBJPROP_PRICE,entry);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_ARROWCODE,(dir>0)?233:234);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_COLOR,ecol);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_WIDTH,2);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_ANCHOR,(dir>0)?ANCHOR_TOP:ANCHOR_BOTTOM);
   ObjectSetInteger(0,pre+"arrow",OBJPROP_SELECTABLE,false);

   DrawTradePanel(true,dir,entry,stop,tp1,tp2,tp3);
  }
//+------------------------------------------------------------------+
//| Pannello OPERAZIONE in alto a DESTRA: prezzi + size 1% x 3 TP    |
//+------------------------------------------------------------------+
void DrawTradePanel(bool ok,int dir,double entry,double stop,double tp1,double tp2,double tp3)
  {
   string q=P+"q_";
   int RM=8, BW=210, LH=16, y=20;
   if(!ok){ ObjectsDeleteAll(0,q); return; }

   double risk=MathAbs(entry-stop);
   int dg=_Digits;
   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney=bal*gRiskPct/100.0;
   double tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double tickSz =SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double lossPerLot=(tickSz>0)? (risk/tickSz)*tickVal : 0;
   double totLots=(lossPerLot>0)? riskMoney/lossPerLot : 0;
   double L1=NormLots(totLots*InpSize1/100.0);
   double L2=NormLots(totLots*InpSize2/100.0);
   double L3=NormLots(totLots*InpSize3/100.0);
   double slPts=risk/_Point;
   double d1=MathAbs(tp1-entry)/_Point, d2=MathAbs(tp2-entry)/_Point, d3=MathAbs(tp3-entry)/_Point;
   color ecol=(dir>0)?InpBuyCol:InpSellCol;

   //--- colonne (ancorate a destra: la casella si estende verso destra) ---
   int wPrice=66, wLots=42;
   int xLots  = wLots + 12;          // casella lotti
   int xPrice = wPrice + xLots + 4;  // casella prezzo (a sinistra dei lotti)
   int xName  = xPrice + 4;          // etichetta nome (a sinistra del prezzo)

   int BH=LH*10+10;
   RectR(q+"bg", RM, y-4, BW, BH, InpPanelCol, InpGridCol);
   LblR(q+"t",   RM+6, y,      "OPERAZIONE  "+_Symbol, InpHeadCol, InpFont+1);
   LblR(q+"dir", RM+6, y+LH,   (dir>0?"BUY":"SELL"),   ecol,       InpFont+1);

   LblR   (q+"in_l", xName,  y+2*LH,   "Ingresso", InpTextCol, InpFont);
   EditVal(q+"in_e", xPrice, y+2*LH-1, wPrice, LH-2, DoubleToString(entry,dg), InpTextCol);
   LblR   (q+"sl_l", xName,  y+3*LH,   "Stop "+DoubleToString(slPts,0)+"pt", InpStopCol, InpFont);
   EditVal(q+"sl_e", xPrice, y+3*LH-1, wPrice, LH-2, DoubleToString(stop,dg), InpStopCol);

   LblR(q+"h", RM+6, y+4*LH, "clic sul valore -> Ctrl+C     prezzo      lotti", C'150,154,160', InpFont-1);

   LblR   (q+"tp1_l", xName,  y+5*LH,   "TP1 "+DoubleToString(d1,0)+"pt", InpTargetCol, InpFont);
   EditVal(q+"tp1_e", xPrice, y+5*LH-1, wPrice, LH-2, DoubleToString(tp1,dg), InpTargetCol);
   EditVal(q+"tp1_L", xLots,  y+5*LH-1, wLots,  LH-2, DoubleToString(L1,2),    InpTextCol);
   LblR   (q+"tp2_l", xName,  y+6*LH,   "TP2 "+DoubleToString(d2,0)+"pt", InpTargetCol, InpFont);
   EditVal(q+"tp2_e", xPrice, y+6*LH-1, wPrice, LH-2, DoubleToString(tp2,dg), InpTargetCol);
   EditVal(q+"tp2_L", xLots,  y+6*LH-1, wLots,  LH-2, DoubleToString(L2,2),    InpTextCol);
   LblR   (q+"tp3_l", xName,  y+7*LH,   "TP3 "+DoubleToString(d3,0)+"pt", InpTargetCol, InpFont);
   EditVal(q+"tp3_e", xPrice, y+7*LH-1, wPrice, LH-2, DoubleToString(tp3,dg), InpTargetCol);
   EditVal(q+"tp3_L", xLots,  y+7*LH-1, wLots,  LH-2, DoubleToString(L3,2),    InpTextCol);

   // rischio %: etichetta (col denaro) + casella EDITABILE (clicca e scrivi)
   LblR (q+"risklbl", xName,  y+8*LH,   "Risk% ="+DoubleToString(riskMoney,2), InpTextCol, InpFont);
   EditR(q+"riskedit",xPrice, y+8*LH-1, wPrice, LH-2, DoubleToString(gRiskPct,2));
   string crossN = gCrossOK ? "  ·  INCROCIO OTTIMO" : "";
   color  noteC  = gCrossOK ? InpTargetCol : C'140,144,150';
   LblR (q+"note", RM+6, y+9*LH, "size "+DoubleToString(InpSize1,0)+"/"+DoubleToString(InpSize2,0)+"/"+DoubleToString(InpSize3,0)+"%  ·  tot "+DoubleToString(NormLots(totLots),2)+" lot"+crossN, noteC, InpFont-1);
  }
//+------------------------------------------------------------------+
double NormLots(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st+0.0000001)*st;
   if(v<mn) v=0.0;
   return v;
  }
//+------------------------------------------------------------------+
void ComputeLevels(int rt,const double &high[],const double &low[],const double &close[],double &res[],double &sup[])
  {
   ArrayResize(res,0); ArrayResize(sup,0);
   int k=InpFractal; if(k<1) k=1;
   int look=MathMin(rt-1, InpLevelsLook);
   int from=rt-1-look; if(from<k) from=k;
   double price=close[rt-1];
   for(int i=from; i<rt-1-k; i++)
     {
      bool sh=true, sl=true;
      for(int j=1;j<=k;j++)
        { if(high[i]<high[i-j] || high[i]<high[i+j]) sh=false;
          if(low[i] >low[i-j]  || low[i] >low[i+j])  sl=false; }
      if(sh && high[i]>price){ int n=ArraySize(res); ArrayResize(res,n+1); res[n]=high[i]; }
      if(sl && low[i] <price){ int n=ArraySize(sup); ArrayResize(sup,n+1); sup[n]=low[i]; }
     }
   ArraySort(res); ArraySort(sup);
  }
//+------------------------------------------------------------------+
void DrawLevels(int rt,const datetime &time[],const double &high[],const double &low[],const double &close[])
  {
   ObjectsDeleteAll(0, P+"lvl_");
   if(!gShowLevels) return;
   double res[],sup[]; ComputeLevels(rt,high,low,close,res,sup);
   double price=close[rt-1];
   double tol=price*0.0008;
   int dg=_Digits; datetime tnow=time[rt-1];
   int drawn=0; double last=-1;
   for(int i=0;i<ArraySize(res) && drawn<InpMaxLevels;i++)
     { if(last>0 && MathAbs(res[i]-last)<tol) continue; last=res[i];
       string nm=P+"lvl_r"+(string)drawn;
       HLine(nm,res[i],InpResCol,STYLE_DOT);
       Txt(nm+"t",tnow,res[i],"RESISTENZA  "+DoubleToString(res[i],dg),InpResCol); drawn++; }
   drawn=0; last=-1;
   for(int i=ArraySize(sup)-1;i>=0 && drawn<InpMaxLevels;i--)
     { if(last>0 && MathAbs(sup[i]-last)<tol) continue; last=sup[i];
       string nm=P+"lvl_s"+(string)drawn;
       HLine(nm,sup[i],InpSupCol,STYLE_DOT);
       Txt(nm+"t",tnow,sup[i],"SUPPORTO  "+DoubleToString(sup[i],dg),InpSupCol); drawn++; }
  }
//+------------------------------------------------------------------+
void HLine(string name,double price,color col,int style)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_HLINE,0,0,0);
   ObjectSetDouble (0,name,OBJPROP_PRICE,price);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_STYLE,style);
   ObjectSetInteger(0,name,OBJPROP_WIDTH,1);
   ObjectSetInteger(0,name,OBJPROP_BACK,true);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
void Txt(string name,datetime t,double price,string text,color col)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_TEXT,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_TIME,t);
   ObjectSetDouble (0,name,OBJPROP_PRICE,price);
   ObjectSetString (0,name,OBJPROP_TEXT," "+text);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,InpFont);
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_LEFT);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//+------------------------------------------------------------------+
int STdir(string sym, ENUM_TIMEFRAMES tf, int &barsSince)
  {
   barsSince=-1;
   int need=InpAtrPeriod+70;   // basta per warmup ATR + contare le candele dal segnale
   MqlRates r[];
   int n=CopyRates(sym,tf,0,need,r);
   if(n<InpAtrPeriod+10) return 0;
   double atr[]; ArrayResize(atr,n);
   double sum=0,tr;
   for(int i=1;i<n;i++)
     {
      double hl=r[i].high-r[i].low, hc=MathAbs(r[i].high-r[i-1].close), lc=MathAbs(r[i].low-r[i-1].close);
      tr=MathMax(hl,MathMax(hc,lc));
      if(i<=InpAtrPeriod){ sum+=tr; atr[i]=sum/InpAtrPeriod; }
      else atr[i]=(atr[i-1]*(InpAtrPeriod-1)+tr)/InpAtrPeriod;
     }
   double upF[]; ArrayResize(upF,n);
   double dnF[]; ArrayResize(dnF,n);
   int    dir[]; ArrayResize(dir,n);
   int start=InpAtrPeriod+1;
   for(int i=start;i<n;i++)
     {
      double mid=(r[i].high+r[i].low)/2.0, ub=mid+InpMult1*atr[i], lb=mid-InpMult1*atr[i];
      if(i==start){ upF[i]=ub; dnF[i]=lb; dir[i]=(r[i].close>=mid)?1:-1; continue; }
      upF[i]=(ub<upF[i-1] || r[i-1].close>upF[i-1]) ? ub : upF[i-1];
      dnF[i]=(lb>dnF[i-1] || r[i-1].close<dnF[i-1]) ? lb : dnF[i-1];
      if(r[i].close>upF[i-1])      dir[i]=1;
      else if(r[i].close<dnF[i-1]) dir[i]=-1;
      else                         dir[i]=dir[i-1];
     }
   int last=n-2;
   if(last<start+1){ barsSince=-1; return 0; }
   int d=dir[last];
   int bs=0;
   for(int i=last;i>start;i--){ if(dir[i]==d) bs++; else break; }
   barsSince=bs-1;    // 0 = inversione sull'ultima candela chiusa
   return d;
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   int panelW = InpSymW + NTF*InpCellW + 6;
   int panelH = (gNsym+2)*InpCellH + 10;
   Rect(P+"panel", InpX-3, InpY-3, panelW, panelH, InpPanelCol, InpPanelCol, false);

   Lbl(P+"title", InpX+2, InpY, "SUPERWAVE", InpHeadCol, InpFont+1);
   int bw=54, gap=2, by=InpY-2;
   int bx=InpX+panelW-4-(4*bw+3*gap);
   Btn(P+"btnHA",   bx,               by, bw, 15, gHA?"HA":"CANDELE");
   Btn(P+"btnLiv",  bx+(bw+gap),      by, bw, 15, "LIVELLI");
   Btn(P+"btnST",   bx+2*(bw+gap),    by, bw, 15, "ST");
   Btn(P+"btnHide", bx+3*(bw+gap),    by, bw, 15, "Nascondi");
   BtnState(P+"btnLiv", gShowLevels);
   BtnState(P+"btnST",  gShowST);

   Lbl(P+"h_sym", InpX+2, gHeaderY, "CROSS", InpHeadCol, InpFont);
   for(int c=0;c<NTF;c++)
      Lbl(P+"h_"+(string)c, ColX(c+1)+InpCellW/2-8, gHeaderY, TFNAMES[c], InpHeadCol, InpFont);

   for(int s=0;s<gNsym;s++)
     {
      int y=gRow0Y+s*InpCellH;
      Rect(P+"sb_"+(string)s, InpX-1, y-1, InpSymW, InpCellH-1, InpEmptyCol, InpGridCol, false);
      Lbl (P+"s_"+(string)s, InpX+3, y, gSyms[s], InpTextCol, InpFont);
      for(int c=0;c<NTF;c++)
        {
         Rect(P+"bg_"+(string)s+"_"+(string)c, ColX(c+1), y-1, InpCellW-1, InpCellH-1, InpEmptyCol, InpGridCol, false);
         Lbl (P+"cx_"+(string)s+"_"+(string)c, ColX(c+1)+InpCellW/2-11, y, "", clrWhite, InpFont);
         ObjectSetInteger(0,P+"cx_"+(string)s+"_"+(string)c,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
        }
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
//--- calcola/ridisegna la riga di UN simbolo (usato dal ricalcolo incrementale)
void UpdateSymbol(int s)
  {
   if(s<0 || s>=gNsym || StringLen(gSyms[s])==0) return;
   int dH4=0,dM3=0;
   for(int c=0;c<NTF;c++)
     {
      int bars=-1;
      int d=STdir(gSyms[s],TFS[c],bars);
      bool active = (d!=0 && bars>=0 && bars<=InpMaxCandles);  // segnale FRESCO (entro N candele)
      if(TFS[c]==PERIOD_H4) dH4 = active? d:0;
      if(TFS[c]==PERIOD_M3) dM3 = active? d:0;
      string bg=P+"bg_"+(string)s+"_"+(string)c;
      string tx=P+"cx_"+(string)s+"_"+(string)c;
      if(active)
        {
         ObjectSetInteger(0,bg,OBJPROP_BGCOLOR,(d>0)?InpBuyCol:InpSellCol);
         ObjectSetString (0,tx,OBJPROP_TEXT,(string)bars);
         ObjectSetInteger(0,tx,OBJPROP_COLOR,clrWhite);
         ObjectSetInteger(0,tx,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
        }
      else
        {
         ObjectSetInteger(0,bg,OBJPROP_BGCOLOR,InpEmptyCol);
         ObjectSetInteger(0,tx,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
        }
     }
   gConfl[s] = (dH4!=0 && dH4==dM3) ? dH4 : 0;
   ObjectSetInteger(0,P+"s_"+(string)s,OBJPROP_COLOR,clrWhite);
   if(gConfl[s]==0)
      ObjectSetInteger(0,P+"sb_"+(string)s,OBJPROP_BGCOLOR,InpEmptyCol);
  }
//--- ricalcolo COMPLETO (all'avvio e su richiesta)
void UpdateAll()
  {
   if(gHidden) return;
   for(int s=0;s<gNsym;s++) UpdateSymbol(s);
   ChartRedraw();
  }
//--- ricalcolo INCREMENTALE: pochi simboli per tick -> non blocca il grafico
void UpdateBatch()
  {
   if(gHidden) return;
   int n=MathMin(InpBatch, gNsym);
   for(int k=0;k<n;k++){ UpdateSymbol(gUpdIdx); gUpdIdx=(gUpdIdx+1)%gNsym; }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
int ColX(int col){ return (col==0)? InpX : InpX+InpSymW+(col-1)*InpCellW; }
//+------------------------------------------------------------------+
//| Estrae simbolo (s) e colonna TF (c) dal nome oggetto            |
//+------------------------------------------------------------------+
bool ParseCell(string name,int &s,int &c)
  {
   string body=StringSubstr(name,StringLen(P));
   string parts[]; int np=StringSplit(body,'_',parts);
   if(np>=3 && (parts[0]=="bg" || parts[0]=="cx"))
     { s=(int)StringToInteger(parts[1]); c=(int)StringToInteger(parts[2]); return true; }
   return false;
  }
int SymIndexFromObj(string name)
  {
   string body=StringSubstr(name,StringLen(P));
   string parts[]; int np=StringSplit(body,'_',parts);
   if(np>=2 && (parts[0]=="s" || parts[0]=="sb"))
      return (int)StringToInteger(parts[1]);
   return -1;
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   // rischio % modificato -> ricalcola i lotti dei 3 TP
   if(id==CHARTEVENT_OBJECT_ENDEDIT && sparam==P+"q_riskedit")
     {
      double v=StringToDouble(ObjectGetString(0,sparam,OBJPROP_TEXT));
      if(v>0 && v<=100){ gRiskPct=v; ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT); }
      else ObjectSetString(0,sparam,OBJPROP_TEXT,DoubleToString(gRiskPct,2)); // valore assurdo -> ripristino
      return;
     }
   // una casella-valore (prezzo/lotti) toccata per sbaglio -> ridisegna e ripristina il valore
   if(id==CHARTEVENT_OBJECT_ENDEDIT && StringFind(sparam,P+"q_")==0)
     { ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT); return; }
   if(id!=CHARTEVENT_OBJECT_CLICK) return;

   if(sparam==P+"btnHA")
     { gHA=!gHA; ObjectSetString(0,P+"btnHA",OBJPROP_TEXT, gHA?"HA":"CANDELE");
       ObjectSetInteger(0,P+"btnHA",OBJPROP_STATE,false);
       BtnState(P+"btnHA",gHA);
       ApplyHA();                                    // nasconde/mostra le candele reali
       ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT);  // ricalcola le candele HA
       return; }

   if(sparam==P+"btnLiv")
     { gShowLevels=!gShowLevels; ObjectSetInteger(0,P+"btnLiv",OBJPROP_STATE,false);
       BtnState(P+"btnLiv",gShowLevels); ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT); return; }

   if(sparam==P+"btnST")
     { gShowST=!gShowST; ObjectSetInteger(0,P+"btnST",OBJPROP_STATE,false);
       BtnState(P+"btnST",gShowST); ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT); return; }

   if(sparam==P+"btnHide")
     {
      gHidden=!gHidden;
      ObjectSetString(0,P+"btnHide",OBJPROP_TEXT, gHidden?"Mostra":"Nascondi");
      ObjectSetInteger(0,P+"btnHide",OBJPROP_STATE,false);
      long tf = gHidden?OBJ_NO_PERIODS:OBJ_ALL_PERIODS;
      for(int s=0;s<gNsym;s++)
        {
         ObjectSetInteger(0,P+"sb_"+(string)s,OBJPROP_TIMEFRAMES,tf);
         ObjectSetInteger(0,P+"s_"+(string)s,OBJPROP_TIMEFRAMES,tf);
         for(int c=0;c<NTF;c++)
            ObjectSetInteger(0,P+"bg_"+(string)s+"_"+(string)c,OBJPROP_TIMEFRAMES,tf);
        }
      ObjectSetInteger(0,P+"panel",OBJPROP_TIMEFRAMES,tf);
      for(int c=0;c<NTF;c++) ObjectSetInteger(0,P+"h_"+(string)c,OBJPROP_TIMEFRAMES,tf);
      ObjectSetInteger(0,P+"h_sym",OBJPROP_TIMEFRAMES,tf);
      if(!gHidden) UpdateAll(); else ChartRedraw();
      return;
     }

   // CLICK su una cella -> vai su quel SIMBOLO + quel TIMEFRAME
   int s2,c2;
   if(ParseCell(sparam,s2,c2) && s2>=0 && s2<gNsym && StringLen(gSyms[s2])>0)
     { ChartSetSymbolPeriod(0, gSyms[s2], TFS[c2]); return; }
   // click sul nome/box -> simbolo al TF corrente
   int si=SymIndexFromObj(sparam);
   if(si>=0 && si<gNsym && StringLen(gSyms[si])>0)
      ChartSetSymbolPeriod(0, gSyms[si], PERIOD_CURRENT);
  }
//+------------------------------------------------------------------+
void Lbl(string name,int x,int y,string text,color col,int fs)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString (0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fs);
   ObjectSetString (0,name,OBJPROP_FONT,"Arial");
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//--- Label ancorata in alto a DESTRA (pannello operazione)
void LblR(string name,int x,int y,string text,color col,int fs)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_ANCHOR,ANCHOR_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetString (0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fs);
   ObjectSetString (0,name,OBJPROP_FONT,"Consolas");
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
//--- casella EDITABILE ancorata a destra (rischio %)
void EditR(string name,int x,int y,int w,int h,string text)
  {
   bool created=false;
   if(ObjectFind(0,name)<0){ ObjectCreate(0,name,OBJ_EDIT,0,0,0); created=true; }
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'40,44,52');
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,clrGold);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,InpFont);
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_CENTER);
   ObjectSetInteger(0,name,OBJPROP_READONLY,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   if(created) ObjectSetString(0,name,OBJPROP_TEXT,text);  // NON sovrascrivo mentre l'utente digita
  }
//--- casella VALORE (sola lettura ma SELEZIONABILE/COPIABILE); aggiorna solo se cambia
void EditVal(string name,int x,int y,int w,int h,string text,color col)
  {
   bool created=false;
   if(ObjectFind(0,name)<0){ ObjectCreate(0,name,OBJ_EDIT,0,0,0); created=true; }
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'28,30,36');
   ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,C'70,74,82');
   ObjectSetInteger(0,name,OBJPROP_COLOR,col);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,InpFont);
   ObjectSetInteger(0,name,OBJPROP_ALIGN,ALIGN_LEFT);
   ObjectSetInteger(0,name,OBJPROP_READONLY,false);  // scrivibile SOLO per poter selezionare+copiare
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false); // (se lo tocchi, si auto-ripristina: vedi OnChartEvent)
   // aggiorna il testo SOLO se e' cambiato, per non perdere la selezione mentre copi
   if(created || ObjectGetString(0,name,OBJPROP_TEXT)!=text)
      ObjectSetString(0,name,OBJPROP_TEXT,text);
  }
void Rect(string name,int x,int y,int w,int h,color bg,color border,bool back)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_COLOR,border);
   ObjectSetInteger(0,name,OBJPROP_BACK,back);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
void RectR(string name,int x,int y,int w,int h,color bg,color border)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,name,OBJPROP_COLOR,border);
   ObjectSetInteger(0,name,OBJPROP_BACK,false);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
void Btn(string name,int x,int y,int w,int h,string text)
  {
   if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
   ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
   ObjectSetString (0,name,OBJPROP_TEXT,text);
   ObjectSetInteger(0,name,OBJPROP_FONTSIZE,InpFont);
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR,C'50,54,62');
   ObjectSetInteger(0,name,OBJPROP_COLOR,clrWhite);
   ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
  }
void BtnState(string name,bool on)
  {
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR, on?C'38,110,70':C'50,54,62');
  }
//+------------------------------------------------------------------+
