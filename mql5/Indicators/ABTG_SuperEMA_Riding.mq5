//+------------------------------------------------------------------+
//|                                         ABTG_SuperEMA_Riding.mq5 |
//|  Supertrend (identico al Pine v4 classico) + EMA 9/21/50/200 +   |
//|  Bande di Bollinger con rilevatore di BAND RIDING e di           |
//|  INCLINAZIONE delle bande.                                       |
//|                                                                  |
//|  A che serve: capire QUANDO PARTE UN TREND DIREZIONALE.          |
//|   - il trigger e' la ROTTURA del Supertrend (cambio colore);     |
//|   - la conferma opzionale e' l'INCROCIO EMA 9/21;                |
//|   - il BAND RIDING dice che il prezzo sta CORRENDO lungo una     |
//|     banda di Bollinger, e la PENDENZA dice che la banda e'       |
//|     "bella inclinata".                                           |
//|                                                                  |
//|  TUTTI i filtri sono INPUT accendibili/spegnibili uno per uno:   |
//|  si fanno le prove dalle impostazioni, senza ricompilare.        |
//|                                                                  |
//|  Uso MANUALE. Non piazza ordini, non legge conti, non tocca      |
//|  nessun EA. Installazione: copia in MQL5\Indicators, F7.         |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property indicator_chart_window
#property indicator_buffers 17
#property indicator_plots   12

#property indicator_label1  "Supertrend"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  2

#property indicator_label2  "EMA 9"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrDodgerBlue
#property indicator_width2  1

#property indicator_label3  "EMA 21"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrOrange
#property indicator_width3  1

#property indicator_label4  "EMA 50"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrMediumOrchid
#property indicator_width4  1

#property indicator_label5  "EMA 200"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrWhite
#property indicator_width5  2

#property indicator_label6  "BB alta"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrSilver
#property indicator_style6  STYLE_DOT

#property indicator_label7  "BB media"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrSilver
#property indicator_style7  STYLE_DASH

#property indicator_label8  "BB bassa"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrSilver
#property indicator_style8  STYLE_DOT

#property indicator_label9  "Segnale LONG"
#property indicator_type9   DRAW_ARROW
#property indicator_color9  clrLime
#property indicator_width9  3

#property indicator_label10 "Segnale SHORT"
#property indicator_type10  DRAW_ARROW
#property indicator_color10 clrRed
#property indicator_width10 3

#property indicator_label11 "Riding SU"
#property indicator_type11  DRAW_ARROW
#property indicator_color11 clrAqua
#property indicator_width11 1

#property indicator_label12 "Riding GIU"
#property indicator_type12  DRAW_ARROW
#property indicator_color12 clrOrangeRed
#property indicator_width12 1

//==================================================================
input group "--- SUPERTREND (come il Pine classico) ---"
input int    InpAtrPeriod        = 10;     // ATR Period (Pine: Periods)
input double InpMult             = 3.0;    // ATR Multiplier
input bool   InpAtrWilder        = true;   // true = ATR di Wilder | false = SMA del True Range
input bool   InpMostraSupertrend = true;   // disegna la linea Supertrend

input group "--- MEDIE ESPONENZIALI ---"
input bool   InpMostraEma        = true;   // disegna le EMA
input int    InpEmaVeloce        = 9;      // EMA veloce
input int    InpEmaMedia         = 21;     // EMA media
input int    InpEmaLenta         = 50;     // EMA lenta
input int    InpEmaFondo         = 200;    // EMA di fondo
input ENUM_APPLIED_PRICE InpEmaPrezzo = PRICE_CLOSE; // prezzo delle EMA

input group "--- BANDE DI BOLLINGER ---"
input bool   InpMostraBB         = true;   // disegna le Bollinger
input int    InpBBPeriodo        = 20;     // periodo Bollinger
input double InpBBDev            = 2.0;    // deviazioni standard
input ENUM_APPLIED_PRICE InpBBPrezzo = PRICE_CLOSE; // prezzo delle Bollinger

input group "--- BAND RIDING (il prezzo CORRE sulla banda) ---"
input bool   InpMostraRiding     = true;   // marca le barre in riding
input int    InpRidingModo       = 1;      // 0 = chiusura OLTRE la banda | 1 = chiusura nella fascia estrema
input double InpRidingTollPct    = 20.0;   // [modo 1] ampiezza fascia, % della semi-larghezza BB
input int    InpRidingBarre      = 3;      // barre consecutive per dichiarare RIDING

input group "--- TRIGGER: che cosa fa scattare il segnale ---"
input bool   InpTrigFlipST       = true;   // trigger: rottura del Supertrend (cambio colore)
input bool   InpTrigCrossEma     = false;  // trigger: incrocio EMA veloce/media
input bool   InpRichiediEntrambi = false;  // servono ENTRAMBI entro la finestra qui sotto
input int    InpFinestraConferma = 3;      // finestra di conferma, in barre

input group "--- FILTRI (ognuno si accende da solo) ---"
input bool   InpFiltroEmaVelMed  = false;  // filtro: EMA veloce oltre la media, nel verso del segnale
input bool   InpFiltroEmaLenta   = false;  // filtro: prezzo oltre la EMA lenta
input bool   InpFiltroEmaFondo   = false;  // filtro: prezzo oltre la EMA di fondo (200)
input bool   InpFiltroPendenzaBB = false;  // filtro: banda media BEN INCLINATA nel verso
input int    InpPendenzaBarre    = 5;      // barre su cui si misura la pendenza
input double InpPendenzaMinATR   = 0.05;   // pendenza minima per barra, in ATR
input bool   InpFiltroEspansione = false;  // filtro: le bande si stanno APRENDO
input double InpEspansioneMin    = 1.05;   // larghezza ora / larghezza N barre fa (min)
input bool   InpFiltroRiding     = false;  // filtro: serve il BAND RIDING nel verso
input bool   InpFiltroAtrMin     = false;  // filtro: volatilita' minima
input double InpAtrMinPunti      = 0.0;    // ATR minimo, in PUNTI
input bool   InpFiltroOrario     = false;  // filtro: finestra oraria (ORA SERVER, BCM = ora IT - 1)
input int    InpOraDa            = 8;      // ora server di inizio (inclusa)
input int    InpOraA             = 22;     // ora server di fine (esclusa)

input group "--- AVVISI ---"
input bool   InpAlertSegnale     = true;   // avvisa sul segnale direzionale
input bool   InpAlertRiding      = false;  // avvisa quando parte un BAND RIDING
input bool   InpSoloBarraChiusa  = true;   // avvisa solo su barra CHIUSA (niente ripitture)
input bool   InpAlertPopup       = true;   // finestra di avviso
input bool   InpAlertPush        = false;  // notifica push al telefono
input bool   InpAlertSuono       = false;  // suono
input string InpFileSuono        = "alert.wav"; // file del suono

input group "--- PANNELLO ---"
input bool   InpPannello         = true;   // pannello di stato in alto a sinistra
input int    InpPannelloX        = 12;     // distanza dal bordo sinistro
input int    InpPannelloY        = 20;     // distanza dal bordo alto
input color  InpPannelloColore   = clrGainsboro; // colore del testo

//==================================================================
double BufST[], BufSTCol[];
double BufE1[], BufE2[], BufE3[], BufE4[];
double BufBBU[], BufBBM[], BufBBD[];
double BufBuy[], BufSell[], BufRideU[], BufRideD[];
double BufStLong[], BufStShort[], BufDir[], BufRide[];

//--- prototipi (le funzioni vivono in fondo al file)
bool   CalcolaAtr(const int rates_total,const int daBarra,const bool tutto,
                  const double &high[],const double &low[],const double &close[]);
bool   FiltriOk(const int i,const int verso,const double &close[],
                const datetime &time[],const bool ridingSu,const bool ridingGiu);
double PendenzaAtr(const int i);
void   Avvisa(const string testo);
string EtichettaTF();
void   Riga(const int n,const string testo,const color col);
void   DisegnaPannello(const int rates_total,const double &close[],const datetime &time[]);

int hATR=INVALID_HANDLE, hE1=INVALID_HANDLE, hE2=INVALID_HANDLE;
int hE3=INVALID_HANDLE, hE4=INVALID_HANDLE, hBB=INVALID_HANDLE;

double   AtrVal[], TRv[];
datetime g_ultimoAlertSegnale=0, g_ultimoAlertRiding=0;
string   g_pre="";

//+------------------------------------------------------------------+
int OnInit()
  {
   if(InpAtrPeriod<1 || InpBBPeriodo<2 || InpMult<=0.0)
     {
      Print("ABTG_SuperEMA_Riding: parametri non validi (ATR>=1, BB>=2, mult>0).");
      return(INIT_PARAMETERS_INCORRECT);
     }

   SetIndexBuffer(0, BufST,     INDICATOR_DATA);
   SetIndexBuffer(1, BufSTCol,  INDICATOR_COLOR_INDEX);
   SetIndexBuffer(2, BufE1,     INDICATOR_DATA);
   SetIndexBuffer(3, BufE2,     INDICATOR_DATA);
   SetIndexBuffer(4, BufE3,     INDICATOR_DATA);
   SetIndexBuffer(5, BufE4,     INDICATOR_DATA);
   SetIndexBuffer(6, BufBBU,    INDICATOR_DATA);
   SetIndexBuffer(7, BufBBM,    INDICATOR_DATA);
   SetIndexBuffer(8, BufBBD,    INDICATOR_DATA);
   SetIndexBuffer(9, BufBuy,    INDICATOR_DATA);
   SetIndexBuffer(10,BufSell,   INDICATOR_DATA);
   SetIndexBuffer(11,BufRideU,  INDICATOR_DATA);
   SetIndexBuffer(12,BufRideD,  INDICATOR_DATA);
   SetIndexBuffer(13,BufStLong, INDICATOR_CALCULATIONS);
   SetIndexBuffer(14,BufStShort,INDICATOR_CALCULATIONS);
   SetIndexBuffer(15,BufDir,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(16,BufRide,   INDICATOR_CALCULATIONS);

   for(int p=0;p<12;p++) PlotIndexSetDouble(p,PLOT_EMPTY_VALUE,0.0);
   PlotIndexSetInteger(8, PLOT_ARROW,233);   // segnale long
   PlotIndexSetInteger(9, PLOT_ARROW,234);   // segnale short
   PlotIndexSetInteger(10,PLOT_ARROW,159);   // riding su
   PlotIndexSetInteger(11,PLOT_ARROW,159);   // riding giu

   //--- plot che l'utente ha spento: si nascondono, i numeri restano
   if(!InpMostraSupertrend) PlotIndexSetInteger(0,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraEma)
      for(int p=1;p<=4;p++) PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraBB)
      for(int p=5;p<=7;p++) PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraRiding)
      for(int p=10;p<=11;p++) PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);

   hE1=iMA(_Symbol,_Period,InpEmaVeloce,0,MODE_EMA,InpEmaPrezzo);
   hE2=iMA(_Symbol,_Period,InpEmaMedia ,0,MODE_EMA,InpEmaPrezzo);
   hE3=iMA(_Symbol,_Period,InpEmaLenta ,0,MODE_EMA,InpEmaPrezzo);
   hE4=iMA(_Symbol,_Period,InpEmaFondo ,0,MODE_EMA,InpEmaPrezzo);
   hBB=iBands(_Symbol,_Period,InpBBPeriodo,0,InpBBDev,InpBBPrezzo);
   if(InpAtrWilder) hATR=iATR(_Symbol,_Period,InpAtrPeriod);

   if(hE1==INVALID_HANDLE || hE2==INVALID_HANDLE || hE3==INVALID_HANDLE ||
      hE4==INVALID_HANDLE || hBB==INVALID_HANDLE ||
      (InpAtrWilder && hATR==INVALID_HANDLE))
     {
      Print("ABTG_SuperEMA_Riding: creazione handle fallita.");
      return(INIT_FAILED);
     }

   g_pre="ABTGSER_"+IntegerToString(ChartID())+"_";
   IndicatorSetString(INDICATOR_SHORTNAME,
      StringFormat("ABTG SuperEMA Riding (ST %d x %.1f | EMA %d/%d/%d/%d | BB %d x %.1f)",
                   InpAtrPeriod,InpMult,InpEmaVeloce,InpEmaMedia,InpEmaLenta,
                   InpEmaFondo,InpBBPeriodo,InpBBDev));
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hATR!=INVALID_HANDLE) IndicatorRelease(hATR);
   if(hE1 !=INVALID_HANDLE) IndicatorRelease(hE1);
   if(hE2 !=INVALID_HANDLE) IndicatorRelease(hE2);
   if(hE3 !=INVALID_HANDLE) IndicatorRelease(hE3);
   if(hE4 !=INVALID_HANDLE) IndicatorRelease(hE4);
   if(hBB !=INVALID_HANDLE) IndicatorRelease(hBB);
   ObjectsDeleteAll(0,g_pre);
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//| ATR: Wilder (iATR) oppure SMA del True Range, come il Pine       |
//+------------------------------------------------------------------+
bool CalcolaAtr(const int rates_total,const int daBarra,const bool tutto,
                const double &high[],const double &low[],const double &close[])
  {
   if(InpAtrWilder)
     {
      if(ArraySize(AtrVal)!=rates_total) ArrayResize(AtrVal,rates_total);
      ArraySetAsSeries(AtrVal,false);
      return(CopyBuffer(hATR,0,0,rates_total,AtrVal)==rates_total);
     }

   //--- SMA del True Range, come il Pine con changeATR = false
   if(ArraySize(AtrVal)!=rates_total) ArrayResize(AtrVal,rates_total);
   if(ArraySize(TRv)   !=rates_total) ArrayResize(TRv,rates_total);
   ArraySetAsSeries(AtrVal,false);
   ArraySetAsSeries(TRv,false);

   //--- al primo giro si rifa' TUTTO: se si partisse da meta' array, la media
   //    leggerebbe gli zeri delle barre mai calcolate e l'ATR uscirebbe basso.
   int da=(tutto || daBarra<1)?0:daBarra;
   for(int i=da;i<rates_total;i++)
     {
      if(i==0){ TRv[0]=high[0]-low[0]; AtrVal[0]=0.0; continue; }
      double a=high[i]-low[i];
      double b=MathAbs(high[i]-close[i-1]);
      double c=MathAbs(low[i] -close[i-1]);
      TRv[i]=MathMax(a,MathMax(b,c));
     }
   int daA=(da<InpAtrPeriod-1)?InpAtrPeriod-1:da;
   if(tutto) for(int i=0;i<InpAtrPeriod-1 && i<rates_total;i++) AtrVal[i]=0.0;
   for(int i=daA;i<rates_total;i++)
     {
      double s=0.0;
      for(int k=0;k<InpAtrPeriod;k++) s+=TRv[i-k];
      AtrVal[i]=s/InpAtrPeriod;
     }
   return(true);
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   int minimo=(int)MathMax(InpAtrPeriod,MathMax(InpBBPeriodo,InpEmaFondo))+
              (int)MathMax(InpPendenzaBarre,InpRidingBarre)+5;
   if(rates_total<minimo) return(0);

   int start=(prev_calculated>0)?prev_calculated-1:minimo;
   if(start<minimo) start=minimo;

   //--- serie di appoggio -------------------------------------------------
   if(!CalcolaAtr(rates_total,start-InpAtrPeriod-1,(prev_calculated==0),high,low,close))
      return(prev_calculated);
   if(CopyBuffer(hE1,0,0,rates_total,BufE1)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE2,0,0,rates_total,BufE2)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE3,0,0,rates_total,BufE3)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE4,0,0,rates_total,BufE4)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,BASE_LINE, 0,rates_total,BufBBM)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,UPPER_BAND,0,rates_total,BufBBU)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,LOWER_BAND,0,rates_total,BufBBD)<rates_total) return(prev_calculated);

   //--- primo giro: pulizia della testa -----------------------------------
   if(prev_calculated==0)
      for(int i=0;i<minimo && i<rates_total;i++)
        {
         BufST[i]=0.0; BufSTCol[i]=0.0;
         BufBuy[i]=0.0; BufSell[i]=0.0; BufRideU[i]=0.0; BufRideD[i]=0.0;
         BufStLong[i]=low[i]; BufStShort[i]=high[i]; BufDir[i]=1.0; BufRide[i]=0.0;
        }

   for(int i=start;i<rates_total;i++)
     {
      BufBuy[i]=0.0; BufSell[i]=0.0; BufRideU[i]=0.0; BufRideD[i]=0.0;

      //================= SUPERTREND, identico al Pine =====================
      //  Attenzione ai NOMI: nel Pine "up" e' la banda BASSA (quella che si
      //  usa in trend SU) e "dn" e' la banda ALTA. Qui si chiamano
      //  StLong / StShort per non sbagliarsi.
      double mid=(high[i]+low[i])/2.0;
      double a  =InpMult*AtrVal[i];
      double up = mid - a;          // Pine: up = src - Multiplier*atr
      double dn = mid + a;          // Pine: dn = src + Multiplier*atr

      double up1=BufStLong[i-1];    // Pine: up1 = nz(up[1])
      double dn1=BufStShort[i-1];   // Pine: dn1 = nz(dn[1])

      if(close[i-1]>up1) up=MathMax(up,up1);   // Pine: up := close[1]>up1 ? max(up,up1) : up
      if(close[i-1]<dn1) dn=MathMin(dn,dn1);   // Pine: dn := close[1]<dn1 ? min(dn,dn1) : dn
      BufStLong[i]=up; BufStShort[i]=dn;

      //--- il flip guarda la banda della barra PRECEDENTE (up1/dn1)
      double dirPrec=BufDir[i-1];
      double dir=dirPrec;
      if(dirPrec<0.0 && close[i]>dn1)      dir= 1.0;
      else if(dirPrec>0.0 && close[i]<up1) dir=-1.0;
      BufDir[i]=dir;

      if(dir>0.0){ BufST[i]=up; BufSTCol[i]=0.0; }
      else       { BufST[i]=dn; BufSTCol[i]=1.0; }

      //================= BAND RIDING sulle Bollinger ======================
      double semiSu=BufBBU[i]-BufBBM[i];
      double semiGiu=BufBBM[i]-BufBBD[i];
      bool rideSu=false, rideGiu=false;
      if(InpRidingModo==0)
        {
         rideSu =(close[i]>=BufBBU[i]);
         rideGiu=(close[i]<=BufBBD[i]);
        }
      else
        {
         double tol=InpRidingTollPct/100.0;
         rideSu =(semiSu >0.0 && close[i]>=BufBBU[i]-tol*semiSu);
         rideGiu=(semiGiu>0.0 && close[i]<=BufBBD[i]+tol*semiGiu);
        }
      double prec=BufRide[i-1];
      if(rideSu)       BufRide[i]=(prec>0.0)?prec+1.0: 1.0;
      else if(rideGiu) BufRide[i]=(prec<0.0)?prec-1.0:-1.0;
      else             BufRide[i]=0.0;

      bool ridingSu =(BufRide[i]>=(double)InpRidingBarre);
      bool ridingGiu=(BufRide[i]<=-(double)InpRidingBarre);
      if(InpMostraRiding)
        {
         if(ridingSu)  BufRideU[i]=BufBBU[i];
         if(ridingGiu) BufRideD[i]=BufBBD[i];
        }

      //================= TRIGGER ==========================================
      int fin=(InpFinestraConferma<0)?0:InpFinestraConferma;
      bool flipSu=false, flipGiu=false, crossSu=false, crossGiu=false;
      for(int k=0;k<=fin;k++)
        {
         int j=i-k;
         if(j<1) break;
         if(BufDir[j]>0.0 && BufDir[j-1]<0.0) flipSu=true;
         if(BufDir[j]<0.0 && BufDir[j-1]>0.0) flipGiu=true;
         if(BufE1[j]>BufE2[j] && BufE1[j-1]<=BufE2[j-1]) crossSu=true;
         if(BufE1[j]<BufE2[j] && BufE1[j-1]>=BufE2[j-1]) crossGiu=true;
        }
      //--- il segnale deve NASCERE su questa barra, non strascicare
      bool flipSuOra =(BufDir[i]>0.0 && BufDir[i-1]<0.0);
      bool flipGiuOra=(BufDir[i]<0.0 && BufDir[i-1]>0.0);
      bool crossSuOra =(BufE1[i]>BufE2[i] && BufE1[i-1]<=BufE2[i-1]);
      bool crossGiuOra=(BufE1[i]<BufE2[i] && BufE1[i-1]>=BufE2[i-1]);

      bool trigSu=false, trigGiu=false;
      if(InpRichiediEntrambi)
        {
         //--- servono tutti e due entro la finestra, e almeno uno e' di OGGI
         trigSu =(flipSu  && crossSu  && (flipSuOra  || crossSuOra));
         trigGiu=(flipGiu && crossGiu && (flipGiuOra || crossGiuOra));
        }
      else
        {
         trigSu =(InpTrigFlipST && flipSuOra)  || (InpTrigCrossEma && crossSuOra);
         trigGiu=(InpTrigFlipST && flipGiuOra) || (InpTrigCrossEma && crossGiuOra);
        }

      //================= FILTRI ===========================================
      if(trigSu  && !FiltriOk(i,+1,close,time,ridingSu,ridingGiu)) trigSu=false;
      if(trigGiu && !FiltriOk(i,-1,close,time,ridingSu,ridingGiu)) trigGiu=false;

      if(trigSu)  BufBuy[i] =low[i] -AtrVal[i]*0.5;
      if(trigGiu) BufSell[i]=high[i]+AtrVal[i]*0.5;
     }

   //================= AVVISI =============================================
   int ib=(InpSoloBarraChiusa)?rates_total-2:rates_total-1;
   if(ib>=minimo)
     {
      if(InpAlertSegnale && (BufBuy[ib]>0.0 || BufSell[ib]>0.0) &&
         g_ultimoAlertSegnale!=time[ib])
        {
         g_ultimoAlertSegnale=time[ib];
         string verso=(BufBuy[ib]>0.0)?"LONG":"SHORT";
         Avvisa(StringFormat("ABTG %s %s: SEGNALE %s  (ST %s, EMA9 %s EMA21) @ %s",
                _Symbol,EtichettaTF(),verso,
                (BufDir[ib]>0.0?"verde":"rosso"),
                (BufE1[ib]>BufE2[ib]?">":"<"),
                DoubleToString(close[ib],_Digits)));
        }
      bool partitoSu =(BufRide[ib]== (double)InpRidingBarre);
      bool partitoGiu=(BufRide[ib]==-(double)InpRidingBarre);
      if(InpAlertRiding && (partitoSu||partitoGiu) && g_ultimoAlertRiding!=time[ib])
        {
         g_ultimoAlertRiding=time[ib];
         double larg=(BufBBU[ib]-BufBBD[ib])/_Point;
         Avvisa(StringFormat("ABTG %s %s: BAND RIDING %s da %d barre - larghezza BB %.0f punti, pendenza %.2f ATR",
                _Symbol,EtichettaTF(),(partitoSu?"SU":"GIU"),InpRidingBarre,
                larg,PendenzaAtr(ib)));
        }
     }

   if(InpPannello) DisegnaPannello(rates_total,close,time);
   return(rates_total);
  }

//+------------------------------------------------------------------+
//| I filtri accesi. verso = +1 long, -1 short.                      |
//+------------------------------------------------------------------+
bool FiltriOk(const int i,const int verso,const double &close[],
              const datetime &time[],const bool ridingSu,const bool ridingGiu)
  {
   if(InpFiltroEmaVelMed)
     {
      if(verso>0 && !(BufE1[i]>BufE2[i])) return(false);
      if(verso<0 && !(BufE1[i]<BufE2[i])) return(false);
     }
   if(InpFiltroEmaLenta)
     {
      if(verso>0 && !(close[i]>BufE3[i])) return(false);
      if(verso<0 && !(close[i]<BufE3[i])) return(false);
     }
   if(InpFiltroEmaFondo)
     {
      if(verso>0 && !(close[i]>BufE4[i])) return(false);
      if(verso<0 && !(close[i]<BufE4[i])) return(false);
     }
   if(InpFiltroPendenzaBB)
     {
      double p=PendenzaAtr(i);                 // ATR per barra, col segno
      if(verso>0 && !(p>= InpPendenzaMinATR)) return(false);
      if(verso<0 && !(p<=-InpPendenzaMinATR)) return(false);
     }
   if(InpFiltroEspansione)
     {
      int j=i-InpPendenzaBarre;
      if(j<1) return(false);
      double ora=BufBBU[i]-BufBBD[i];
      double pri=BufBBU[j]-BufBBD[j];
      if(pri<=0.0) return(false);
      if(ora/pri < InpEspansioneMin) return(false);
     }
   if(InpFiltroRiding)
     {
      if(verso>0 && !ridingSu)  return(false);
      if(verso<0 && !ridingGiu) return(false);
     }
   if(InpFiltroAtrMin)
     {
      if(AtrVal[i] < InpAtrMinPunti*_Point) return(false);
     }
   if(InpFiltroOrario)
     {
      //--- ORA SERVER: sul BCM e' l'ora italiana MENO UNA
      MqlDateTime dt; TimeToStruct(time[i],dt);
      if(InpOraDa<=InpOraA)
        { if(dt.hour<InpOraDa || dt.hour>=InpOraA) return(false); }
      else
        { if(dt.hour<InpOraDa && dt.hour>=InpOraA) return(false); }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Pendenza della banda MEDIA, in ATR per barra, col segno          |
//+------------------------------------------------------------------+
double PendenzaAtr(const int i)
  {
   int n=(InpPendenzaBarre<1)?1:InpPendenzaBarre;
   int j=i-n;
   if(j<0) return(0.0);
   if(AtrVal[i]<=0.0) return(0.0);
   return((BufBBM[i]-BufBBM[j])/(double)n/AtrVal[i]);
  }

//+------------------------------------------------------------------+
void Avvisa(const string testo)
  {
   if(InpAlertPopup) Alert(testo);
   else              Print(testo);
   if(InpAlertPush)  SendNotification(testo);
   if(InpAlertSuono) PlaySound(InpFileSuono);
  }

//+------------------------------------------------------------------+
string EtichettaTF()
  {
   return(StringSubstr(EnumToString((ENUM_TIMEFRAMES)_Period),7));
  }

//+------------------------------------------------------------------+
void Riga(const int n,const string testo,const color col)
  {
   string nome=g_pre+"r"+IntegerToString(n);
   if(ObjectFind(0,nome)<0)
     {
      ObjectCreate(0,nome,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,nome,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,InpPannelloX);
      ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,InpPannelloY+n*14);
      ObjectSetInteger(0,nome,OBJPROP_FONTSIZE,8);
      ObjectSetString (0,nome,OBJPROP_FONT,"Consolas");
      ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
     }
   ObjectSetString (0,nome,OBJPROP_TEXT,testo);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,col);
  }

//+------------------------------------------------------------------+
void DisegnaPannello(const int rates_total,const double &close[],const datetime &time[])
  {
   int i=rates_total-1;
   if(i<2) return;
   double larg=(BufBBU[i]-BufBBD[i])/_Point;
   double pend=PendenzaAtr(i);
   int    ride=(int)BufRide[i];
   double distST=MathAbs(close[i]-BufST[i])/_Point;

   Riga(0,"ABTG SuperEMA Riding  "+_Symbol+" "+EtichettaTF(),InpPannelloColore);
   Riga(1,StringFormat("Supertrend : %-6s  (linea a %.0f punti)",
        (BufDir[i]>0.0?"SU":"GIU"),distST),
        (BufDir[i]>0.0?clrLimeGreen:clrRed));
   Riga(2,StringFormat("EMA 9/21   : %-6s   50: %-5s   200: %-5s",
        (BufE1[i]>BufE2[i]?"SU":"GIU"),
        (close[i]>BufE3[i]?"sopra":"sotto"),
        (close[i]>BufE4[i]?"sopra":"sotto")),
        (BufE1[i]>BufE2[i]?clrLimeGreen:clrRed));
   Riga(3,StringFormat("BB larghez.: %.0f punti   pendenza: %+.2f ATR/barra",larg,pend),
        (MathAbs(pend)>=InpPendenzaMinATR?clrAqua:InpPannelloColore));
   Riga(4,StringFormat("BAND RIDING: %s%d barre  (soglia %d)",
        (ride>0?"SU ":(ride<0?"GIU ":"-- ")),MathAbs(ride),InpRidingBarre),
        (ride>=InpRidingBarre?clrAqua:(ride<=-InpRidingBarre?clrOrangeRed:InpPannelloColore)));
   Riga(5,"ora server barra: "+TimeToString(time[i],TIME_MINUTES)+
          "   (BCM = ora IT - 1)",InpPannelloColore);
   ChartRedraw();
  }
//+------------------------------------------------------------------+
