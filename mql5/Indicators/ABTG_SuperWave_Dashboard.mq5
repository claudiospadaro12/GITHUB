//+------------------------------------------------------------------+
//|                                 ABTG_SuperWave_Dashboard.mq5      |
//|                                                                  |
//|  Dashboard "SUPERWAVE ST INVERSION": griglia SIMBOLI x TIMEFRAME |
//|  che accende BUY (verde) / SELL (rosso) quando il SUPERTREND     |
//|  (ATR 10, molt. 3.5) si INVERTE su quel simbolo/TF.             |
//|                                                                  |
//|   - CLICCA una cella (o il nome) -> il grafico va su quel simbolo|
//|   - Nome simbolo colorato quando H4 e M3 CONCORDANO (confluenza) |
//|   - Celle senza segnale: vuote, nere piene (opache)             |
//|   - Tasto Heikin Ashi <-> Candele ; Tasto Nascondi/Mostra       |
//|   - Colori tutti modificabili dagli input                       |
//|                                                                  |
//|  Adatta InpSymbols ai TUOI ticker BCM. Metti su UN grafico.     |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "2.00"
#property indicator_chart_window
#property indicator_buffers 5
#property indicator_plots   1
#property indicator_label1  "HeikinAshi"
#property indicator_type1   DRAW_COLOR_CANDLES
#property indicator_color1  clrLimeGreen, clrRed
#property indicator_width1  2

input string InpSymbols   = "D30EUR,NASUSD,SPXUSD,XAUUSD,EURUSD,EURGBP,EURJPY,EURCHF,EURAUD,EURCAD,EURNZD,GBPUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,CHFJPY,CADCHF,CADJPY,USDJPY,USDCHF,USDCAD,AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,BTCUSD"; // Simboli (adatta ai TUOI BCM!)
input int    InpAtrPeriod = 10;    // Periodo ATR del Supertrend
input double InpMult      = 3.5;   // Moltiplicatore Supertrend (segnale)
input int    InpFlipBars  = 1;     // "Inversione" = flip entro N barre chiuse
input int    InpX         = 6;     // Posizione pannello X (px)
input int    InpY         = 44;    // Posizione pannello Y (px) - piu' in basso
input int    InpSymW      = 64;    // Larghezza colonna simboli
input int    InpCellW     = 50;    // Larghezza celle TF
input int    InpCellH     = 19;    // Altezza righe
input int    InpFont      = 8;     // Dimensione testo
//--- COLORI (modificabili)
input color  InpBuyCol    = C'38,166,91';    // verde BUY
input color  InpSellCol   = C'200,55,50';    // rosso SELL
input color  InpEmptyCol  = C'24,26,32';     // nero pieno celle vuote (diverso dallo sfondo)
input color  InpPanelCol  = C'16,18,22';     // sfondo pannello (opaco)
input color  InpGridCol   = C'55,58,66';     // bordo celle
input color  InpTextCol   = C'205,208,214';  // testo simboli
input color  InpHeadCol   = clrWhite;        // testo intestazioni

ENUM_TIMEFRAMES TFS[]     = {PERIOD_M1,PERIOD_M3,PERIOD_M5,PERIOD_M15,PERIOD_H1,PERIOD_H4,PERIOD_D1};
string          TFNAMES[] = {"M1","M3","M5","M15","H1","H4","D1"};
int             NTF       = 7;

string   gSyms[];
int      gNsym = 0;
bool     gHA     = false;
bool     gHidden = false;
long     gOrigMode = -1;
string   P = "SWD_";

double haO[], haH[], haL[], haC[], haCol[];

int gHeaderY, gRow0Y;

//+------------------------------------------------------------------+
int OnInit()
  {
   SetIndexBuffer(0, haO,   INDICATOR_DATA);
   SetIndexBuffer(1, haH,   INDICATOR_DATA);
   SetIndexBuffer(2, haL,   INDICATOR_DATA);
   SetIndexBuffer(3, haC,   INDICATOR_DATA);
   SetIndexBuffer(4, haCol, INDICATOR_COLOR_INDEX);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);

   gNsym = StringSplit(InpSymbols, ',', gSyms);
   for(int i=0;i<gNsym;i++){ StringTrimLeft(gSyms[i]); StringTrimRight(gSyms[i]); if(StringLen(gSyms[i])>0) SymbolSelect(gSyms[i], true); }

   gHeaderY = InpY + InpCellH;
   gRow0Y   = gHeaderY + InpCellH;

   gOrigMode = ChartGetInteger(0, CHART_MODE);
   BuildPanel();
   EventSetTimer(3);
   UpdateAll();
   PrintFormat("[SuperWave] dashboard AVVIATA: %d simboli x %d TF (pannello a X=%d Y=%d). Se non la vedi, l'oggetto e' fuori schermo: riduci InpX/InpY.", gNsym, NTF, InpX, InpY);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, P);
   if(gOrigMode>=0) ChartSetInteger(0, CHART_MODE, gOrigMode);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total, const int prev_calculated,
                const datetime &time[], const double &open[], const double &high[],
                const double &low[], const double &close[], const long &tick_volume[],
                const long &volume[], const int &spread[])
  {
   if(!gHA)
     {
      for(int i=(prev_calculated>0?prev_calculated-1:0); i<rates_total; i++)
        { haO[i]=0; haH[i]=0; haL[i]=0; haC[i]=0; haCol[i]=0; }
      return(rates_total);
     }
   int start = (prev_calculated>1)? prev_calculated-1 : 1;
   if(start<1) start=1;
   if(prev_calculated==0 && rates_total>0)
     { haO[0]=open[0]; haH[0]=high[0]; haL[0]=low[0]; haC[0]=(open[0]+high[0]+low[0]+close[0])/4.0; haCol[0]=(haC[0]>=haO[0]?0:1); }
   for(int i=start; i<rates_total; i++)
     {
      double c=(open[i]+high[i]+low[i]+close[i])/4.0;
      double o=(haO[i-1]+haC[i-1])/2.0;
      double h=MathMax(high[i],MathMax(o,c));
      double l=MathMin(low[i], MathMin(o,c));
      haO[i]=o; haH[i]=h; haL[i]=l; haC[i]=c; haCol[i]=(c>=o?0:1);
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+
void OnTimer(){ UpdateAll(); }
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
      double mid=(r[i].high+r[i].low)/2.0, ub=mid+InpMult*atr[i], lb=mid-InpMult*atr[i];
      if(i==start){ upF[i]=ub; dnF[i]=lb; dir[i]=(r[i].close>=mid)?1:-1; continue; }
      upF[i]=(ub<upF[i-1] || r[i-1].close>upF[i-1]) ? ub : upF[i-1];
      dnF[i]=(lb>dnF[i-1] || r[i-1].close<dnF[i-1]) ? lb : dnF[i-1];
      if(r[i].close>upF[i-1])      dir[i]=1;
      else if(r[i].close<dnF[i-1]) dir[i]=-1;
      else                         dir[i]=dir[i-1];
     }
   int last=n-2;
   if(last<start+1) return 0;
   for(int k=0;k<InpFlipBars && (last-k)>start;k++)
      if(dir[last-k]!=dir[last-k-1]){ flip=true; break; }
   return dir[last];
  }
//+------------------------------------------------------------------+
void BuildPanel()
  {
   int panelW = InpSymW + NTF*InpCellW + 6;
   int panelH = (gNsym+2)*InpCellH + 10;
   Rect(P+"panel", InpX-3, InpY-3, panelW, panelH, InpPanelCol, InpPanelCol, false); // false = SOPRA le candele (opaco, ben visibile)

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
         ObjectSetInteger(0,P+"cx_"+(string)s+"_"+(string)c,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS); // testo nascosto finche' non c'e' segnale
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
//| Estrae l'indice simbolo da un nome oggetto SWD_bg_S_C o SWD_s_S  |
//+------------------------------------------------------------------+
int SymIndexFromObj(string name)
  {
   string body=StringSubstr(name,StringLen(P)); // es "bg_3_5" o "s_3"
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
      ChartSetInteger(0,CHART_MODE, gHA?CHART_LINE:CHART_CANDLES);
      ChartSetInteger(0,CHART_COLOR_CHART_LINE, clrDimGray);
      ChartSetSymbolPeriod(0,NULL,PERIOD_CURRENT);
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

   // click su una cella o sul nome -> vai su quel simbolo
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
