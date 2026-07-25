//+------------------------------------------------------------------+
//|                                 ABTG_SuperWave_Dashboard.mq5      |
//|                                                                  |
//|  INDICATORE UNICO "SUPERWAVE" (strategia Chiari) - tutto in uno:  |
//|                                                                  |
//|   1) DASHBOARD: griglia SIMBOLI x TIMEFRAME che accende          |
//|      BUY (verde) / SELL (rosso) quando il SUPERTREND (ATR 10,    |
//|      molt. 3.5) si INVERTE. Clicca una cella -> vai su quel      |
//|      simbolo. Nome colorato quando H4 e M3 concordano.          |
//|   2) LINEE sul grafico: 3 SUPERTREND (3.5/3.0/2.5) + 3 MEDIE     |
//|      (14/100/200).                                              |
//|   3) LIVELLI di PRICE ACTION: supporti/resistenze (swing) col   |
//|      prezzo -> dove il prezzo potrebbe reagire.                 |
//|   4) OPERAZIONE PRONTA: in base al Supertrend mostra INGRESSO,   |
//|      STOP e TARGET con i PREZZI da mettere nell'ordine manuale   |
//|      (simbolo BUY verde / SELL rosso).                          |
//|                                                                  |
//|  Tasti: Heikin Ashi <-> Candele ; Nascondi/Mostra pannello.     |
//|  Adatta InpSymbols ai TUOI ticker BCM. Metti su UN grafico.     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "3.00"
#property indicator_chart_window
#property indicator_buffers 14
#property indicator_plots   7
//--- 1) Heikin Ashi (tasto)
#property indicator_label1  "HeikinAshi"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen, clrRed
#property indicator_width1  2
//--- 2) Supertrend 3.5 (segnale)
#property indicator_label2  "ST 3.5"
#property indicator_type2   DRAW_COLOR_LINE
#property indicator_color2  clrLimeGreen, clrRed
#property indicator_width2  2
//--- 3) Supertrend 3.0
#property indicator_label3  "ST 3.0"
#property indicator_type3   DRAW_COLOR_LINE
#property indicator_color3  clrLimeGreen, clrRed
#property indicator_width3  1
//--- 4) Supertrend 2.5
#property indicator_label4  "ST 2.5"
#property indicator_type4   DRAW_COLOR_LINE
#property indicator_color4  clrLimeGreen, clrRed
#property indicator_width4  1
//--- 5-7) Medie
#property indicator_label5  "MA 14"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrAqua
#property indicator_label6  "MA 100"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrOrange
#property indicator_label7  "MA 200"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrTomato
#property indicator_width7  2

input string InpSymbols   = "D30EUR,NASUSD,SPXUSD,XAUUSD,EURUSD,EURGBP,EURJPY,EURCHF,EURAUD,EURCAD,EURNZD,GBPUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,CHFJPY,CADCHF,CADJPY,USDJPY,USDCHF,USDCAD,AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,BTCUSD"; // Simboli (adatta ai TUOI BCM!)
input int    InpAtrPeriod = 10;    // Periodo ATR del Supertrend
input double InpMult1     = 3.5;   // Supertrend 1 (segnale)
input double InpMult2     = 3.0;   // Supertrend 2
input double InpMult3     = 2.5;   // Supertrend 3
input bool   InpShowST2   = true;  // mostra ST 3.0
input bool   InpShowST3   = true;  // mostra ST 2.5
input int    InpMA1       = 14;    // Media veloce
input int    InpMA2       = 100;   // Media media
input int    InpMA3       = 200;   // Media lenta
input ENUM_MA_METHOD InpMAmethod = MODE_SMA; // tipo medie (SMA/EMA...)
input int    InpFlipBars  = 1;     // "Inversione" = flip entro N barre chiuse (dashboard)
//--- OPERAZIONE (ingresso/stop/target) ---
input bool   InpShowTrade = true;  // mostra INGRESSO/STOP/TARGET sul grafico
input double InpTP_R      = 2.0;   // TARGET come multiplo del rischio (R)
//--- LIVELLI price action ---
input bool   InpShowLevels   = true; // mostra supporti/resistenze
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
bool     gHA     = false;
bool     gHidden = false;
string   P = "SWD_";

//--- buffer: HA (5) + ST1(2) + ST2(2) + ST3(2) + MA1/2/3 (3) = 14
double haO[], haH[], haL[], haC[], haCol[];
double st1[], c1[], st2[], c2[], st3[], c3[];
double ma1[], ma2[], ma3[];
double up1[],dn1[],up2[],dn2[],up3[],dn3[];
int    hAtr, hMa1, hMa2, hMa3;

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
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   for(int p=1;p<7;p++) PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   hAtr = iATR(_Symbol,_Period,InpAtrPeriod);
   hMa1 = iMA(_Symbol,_Period,InpMA1,0,InpMAmethod,PRICE_CLOSE);
   hMa2 = iMA(_Symbol,_Period,InpMA2,0,InpMAmethod,PRICE_CLOSE);
   hMa3 = iMA(_Symbol,_Period,InpMA3,0,InpMAmethod,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE) return(INIT_FAILED);
   IndicatorSetString(INDICATOR_SHORTNAME,"SuperWave");

   gNsym = StringSplit(InpSymbols, ',', gSyms);
   for(int i=0;i<gNsym;i++){ StringTrimLeft(gSyms[i]); StringTrimRight(gSyms[i]); if(StringLen(gSyms[i])>0) SymbolSelect(gSyms[i], true); }

   gHeaderY = InpY + InpCellH;
   gRow0Y   = gHeaderY + InpCellH;

   BuildPanel();
   EventSetTimer(3);
   UpdateAll();
   PrintFormat("[SuperWave] AVVIATO: %d simboli, linee+livelli+operazione su %s %s.",
               gNsym, _Symbol, EnumToString(_Period));
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, P);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
void OnTimer(){ UpdateAll(); }
//+------------------------------------------------------------------+
//| Supertrend su un multiplo (per le LINEE del grafico corrente)    |
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

   //--- Heikin Ashi (solo se attivo il tasto)
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

   //--- Supertrend + medie (linee)
   double atr[]; ArrayResize(atr,rates_total);
   if(CopyBuffer(hAtr,0,0,rates_total,atr)<=0) return(prev_calculated);
   ComputeST(InpMult1,high,low,close,atr,rates_total,prev_calculated,st1,c1,up1,dn1);
   if(InpShowST2) ComputeST(InpMult2,high,low,close,atr,rates_total,prev_calculated,st2,c2,up2,dn2);
   else for(int i=0;i<rates_total;i++) st2[i]=EMPTY_VALUE;
   if(InpShowST3) ComputeST(InpMult3,high,low,close,atr,rates_total,prev_calculated,st3,c3,up3,dn3);
   else for(int i=0;i<rates_total;i++) st3[i]=EMPTY_VALUE;
   double m[];
   if(CopyBuffer(hMa1,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma1[i]=m[i];
   if(CopyBuffer(hMa2,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma2[i]=m[i];
   if(CopyBuffer(hMa3,0,0,rates_total,m)>0) for(int i=0;i<rates_total;i++) ma3[i]=m[i];

   DrawTrade(rates_total,time,close);
   DrawLevels(rates_total,time,high,low,close);
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| INGRESSO / STOP / TARGET in base al Supertrend 3.5               |
//+------------------------------------------------------------------+
void DrawTrade(int rt,const datetime &time[],const double &close[])
  {
   string en=P+"op_entry", sl=P+"op_sl", tp=P+"op_tp";
   string enT=P+"op_entryT", slT=P+"op_slT", tpT=P+"op_tpT", ar=P+"op_arrow";
   if(!InpShowTrade){ ObjectDelete(0,en);ObjectDelete(0,sl);ObjectDelete(0,tp);
                      ObjectDelete(0,enT);ObjectDelete(0,slT);ObjectDelete(0,tpT);ObjectDelete(0,ar); return; }
   int b=rt-2;                       // ultima barra CHIUSA
   if(b<InpAtrPeriod+2) return;
   double stv=st1[b];
   if(stv==EMPTY_VALUE || stv<=0) return;
   int dir=(c1[b]==0)?1:-1;          // 0=verde/su, 1=rosso/giu'
   double entry=close[rt-1];         // prezzo attuale
   double stop=stv;                  // stop = linea Supertrend
   double risk=MathAbs(entry-stop);
   if(risk<=0) return;
   double target=(dir>0)? entry+InpTP_R*risk : entry-InpTP_R*risk;
   int    dg=_Digits;
   datetime tnow=time[rt-1];
   color  ecol=(dir>0)?InpBuyCol:InpSellCol;
   string etxt=(dir>0)?"BUY":"SELL";

   HLine(en, entry, ecol,       STYLE_SOLID);
   HLine(sl, stop,  InpStopCol,  STYLE_DASH);
   HLine(tp, target,InpTargetCol,STYLE_DASH);
   Txt(enT, tnow, entry,  etxt+"  "+DoubleToString(entry,dg),  ecol);
   Txt(slT, tnow, stop,   "STOP  "+DoubleToString(stop,dg),    InpStopCol);
   Txt(tpT, tnow, target, "TARGET  "+DoubleToString(target,dg),InpTargetCol);
   if(ObjectFind(0,ar)<0) ObjectCreate(0,ar,OBJ_ARROW,0,0,0);
   ObjectSetInteger(0,ar,OBJPROP_TIME,tnow);
   ObjectSetDouble (0,ar,OBJPROP_PRICE,entry);
   ObjectSetInteger(0,ar,OBJPROP_ARROWCODE,(dir>0)?233:234);
   ObjectSetInteger(0,ar,OBJPROP_COLOR,ecol);
   ObjectSetInteger(0,ar,OBJPROP_WIDTH,2);
   ObjectSetInteger(0,ar,OBJPROP_ANCHOR,(dir>0)?ANCHOR_TOP:ANCHOR_BOTTOM);
   ObjectSetInteger(0,ar,OBJPROP_SELECTABLE,false);
  }
//+------------------------------------------------------------------+
//| Supporti / resistenze (swing) col prezzo                        |
//+------------------------------------------------------------------+
void DrawLevels(int rt,const datetime &time[],const double &high[],const double &low[],const double &close[])
  {
   ObjectsDeleteAll(0, P+"lvl_");
   if(!InpShowLevels) return;
   int k=InpFractal; if(k<1) k=1;
   int look=MathMin(rt-1, InpLevelsLook);
   int from=rt-1-look; if(from<k) from=k;
   double price=close[rt-1];
   double res[]; ArrayResize(res,0);
   double sup[]; ArrayResize(sup,0);
   for(int i=from; i<rt-1-k; i++)
     {
      bool sh=true, sl=true;
      for(int j=1;j<=k;j++)
        { if(high[i]<high[i-j] || high[i]<high[i+j]) sh=false;
          if(low[i] >low[i-j]  || low[i] >low[i+j])  sl=false; }
      if(sh && high[i]>price){ int n=ArraySize(res); ArrayResize(res,n+1); res[n]=high[i]; }
      if(sl && low[i] <price){ int n=ArraySize(sup); ArrayResize(sup,n+1); sup[n]=low[i]; }
     }
   ArraySort(res);                       // crescente: le prime = piu' vicine sopra
   ArraySort(sup);                       // crescente: le ultime = piu' vicine sotto
   double tol=price*0.0008;              // fonde livelli troppo vicini
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
int STdir(string sym, ENUM_TIMEFRAMES tf, bool &flip)
  {
   flip=false;
   int need=InpAtrPeriod+80;
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
   if(last<start+1) return 0;
   for(int kk=0;kk<InpFlipBars && (last-kk)>start;kk++)
      if(dir[last-kk]!=dir[last-kk-1]){ flip=true; break; }
   return dir[last];
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   int panelW = InpSymW + NTF*InpCellW + 6;
   int panelH = (gNsym+2)*InpCellH + 10;
   Rect(P+"panel", InpX-3, InpY-3, panelW, panelH, InpPanelCol, InpPanelCol, false);

   Lbl(P+"title", InpX+2, InpY, "SUPERWAVE  ST  INVERSION", InpHeadCol, InpFont+1);
   Btn(P+"btnHA",   InpX+InpSymW+3*InpCellW, InpY-2, 3*InpCellW-2, 15, gHA?"HEIKIN ASHI":"CANDELE");
   Btn(P+"btnHide", InpX+InpSymW+6*InpCellW, InpY-2, InpCellW,     15, "Nascondi");

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
void UpdateAll()
  {
   if(gHidden) return;
   for(int s=0;s<gNsym;s++)
     {
      if(StringLen(gSyms[s])==0) continue;
      int dH4=0,dM3=0;
      for(int c=0;c<NTF;c++)
        {
         bool flip=false;
         int d=STdir(gSyms[s],TFS[c],flip);
         if(TFS[c]==PERIOD_H4) dH4=d;
         if(TFS[c]==PERIOD_M3) dM3=d;
         string bg=P+"bg_"+(string)s+"_"+(string)c;
         string tx=P+"cx_"+(string)s+"_"+(string)c;
         if(flip && d!=0)
           {
            ObjectSetInteger(0,bg,OBJPROP_BGCOLOR,(d>0)?InpBuyCol:InpSellCol);
            ObjectSetString (0,tx,OBJPROP_TEXT,(d>0)?"BUY":"SELL");
            ObjectSetInteger(0,tx,OBJPROP_COLOR,clrWhite);
            ObjectSetInteger(0,tx,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
           }
         else
           {
            ObjectSetInteger(0,bg,OBJPROP_BGCOLOR,InpEmptyCol);
            ObjectSetInteger(0,tx,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
           }
        }
      color nc=InpTextCol;
      if(dH4!=0 && dH4==dM3) nc=(dH4>0)?InpBuyCol:InpSellCol;
      ObjectSetInteger(0,P+"s_"+(string)s,OBJPROP_COLOR,nc);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
int ColX(int col){ return (col==0)? InpX : InpX+InpSymW+(col-1)*InpCellW; }
//+------------------------------------------------------------------+
int SymIndexFromObj(string name)
  {
   string body=StringSubstr(name,StringLen(P));
   string parts[]; int np=StringSplit(body,'_',parts);
   if(np>=2 && (parts[0]=="bg" || parts[0]=="s" || parts[0]=="sb"))
      return (int)StringToInteger(parts[1]);
   return -1;
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id!=CHARTEVENT_OBJECT_CLICK) return;
   if(sparam==P+"btnHA")
     {
      gHA=!gHA;
      ObjectSetString(0,P+"btnHA",OBJPROP_TEXT, gHA?"HEIKIN ASHI":"CANDELE");
      ObjectSetInteger(0,P+"btnHA",OBJPROP_STATE,false);
      ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT); // forza il ricalcolo delle candele HA
      return;
     }
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
//+------------------------------------------------------------------+
