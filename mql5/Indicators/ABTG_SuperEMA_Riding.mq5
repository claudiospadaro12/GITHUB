//+------------------------------------------------------------------+
//|                                         ABTG_SuperEMA_Riding.mq5 |
//|                                                          v2.00   |
//|                                                                  |
//|  PORTING IN MT5 di "ABTG BR+EMA v1.2" (Pine v5, 31/05/2026) piu' |
//|  le due cose che lui non ha e che Claudio ha chiesto il 17/09:    |
//|    + SUPERTREND, identico al Pine v4 classico di TradingView,    |
//|      come TERZA origine di segnale (la "rottura");               |
//|    + EMA 200, quarta media oltre alle 9/21/50 di Paolo.           |
//|                                                                  |
//|  Dal v1.2 e' portato TUTTO, con gli stessi nomi e gli stessi     |
//|  valori di default:                                              |
//|    - K COEFFICIENT (le soglie in punti si scalano da sole);      |
//|    - BB principale con parametri separati Indici/Oro vs Forex;   |
//|    - BB Cross Dashboard e il filtro di concordanza;              |
//|    - SLOPE delle bande su N barre (band riding di Emiliano);     |
//|    - ESPANSIONE minima della larghezza;                          |
//|    - ATR, triplo filtro A/B/C in AND;                            |
//|    - HEIKIN ASHI: niente ombra contraria su 2 candele;           |
//|    - CONFERMA della 2a candela;                                  |
//|    - ANTI-DOPPIONE globale sul regime.                           |
//|                                                                  |
//|  DUE MIGLIORIE dichiarate, nate leggendo il v1.2 (dettaglio in   |
//|  fondo al file, sezione NOTE):                                   |
//|    1. il rilevamento dello strumento NON si fa piu' a stringhe:  |
//|       in MT5 si chiede al broker (SYMBOL_TRADE_CALC_MODE e       |
//|       SYMBOL_CURRENCY_PROFIT). Nel Pine un EURUSD servito come   |
//|       CFD cadeva su K=1.0 e le soglie diventavano 10.000 volte   |
//|       piu' strette: zero segnali, e nessun messaggio.            |
//|    2. le soglie si possono misurare in ATR invece che in punti   |
//|       (InpSlopeInAtr), e il pannello GRIDA "K SOSPETTO" se la    |
//|       soglia in ATR e' fuori scala. Un fallimento visibile.      |
//|                                                                  |
//|  Uso MANUALE, SOLA LETTURA: non piazza ordini, non legge conti,  |
//|  non scrive file, non tocca nessun EA in forward.                |
//|                                                                  |
//|  INSTALLAZIONE - UN TERMINALE PER VOLTA, e il gesto F7 va fatto   |
//|  UNA VOLTA PER TERMINALE (l'.ex5 nasce accanto al sorgente):      |
//|    bersaglio consigliato  50504400  C:\MT5_Backtest              |
//|    oppure                 50504263  BCM Markets MT5 Terminal -V3  |
//|    MAI sul                10105439  C:\BCM_Reale                 |
//|  Se MetaEditor era gia' aperto: chiudilo e riaprilo, altrimenti   |
//|  il file nuovo non compare nell'albero.                           |
//|                                                                  |
//|  DUE AVVERTENZE MISURATE (non difetti: rodaggio dichiarato):      |
//|  1) Le prime ~50 barre disegnate dopo il margine di avvio possono |
//|     avere colore e flip DIVERSI da TradingView, perche' il        |
//|     ratchet del Supertrend ha memoria e qui parte a freddo.       |
//|     Misurato su 40 serie: converge entro 47 barre, media 12. E    |
//|     seminare con la banda grezza PEGGIORA (47 -> 66). Quindi si   |
//|     giudica al centro del grafico, non sul bordo sinistro.        |
//|  2) Questo NON e' ABTG_Supertrend.mq5: quello e' una VARIANTE     |
//|     (flip contro la banda CORRENTE). Sulle barre a gap i due      |
//|     danno il flip su barre DIVERSE - verificato a numeri. Questo  |
//|     segue il Pine alla lettera.                                  |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "2.00"
#property indicator_chart_window
#property indicator_buffers 25
#property indicator_plots   14

#property indicator_label1  "Supertrend"
#property indicator_type1   DRAW_COLOR_LINE
#property indicator_color1  clrLimeGreen,clrRed
#property indicator_width1  2

#property indicator_label2  "EMA 9"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrMediumPurple

#property indicator_label3  "EMA 21"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrLimeGreen

#property indicator_label4  "EMA 50"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrGold
#property indicator_width4  2

#property indicator_label5  "EMA 200"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrWhite
#property indicator_width5  2

#property indicator_label6  "BB alta"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrRoyalBlue
#property indicator_width6  2

#property indicator_label7  "BB media"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrGray
#property indicator_style7  STYLE_DASH

#property indicator_label8  "BB bassa"
#property indicator_type8   DRAW_LINE
#property indicator_color8  clrRoyalBlue
#property indicator_width8  2

#property indicator_label9  "Cross alta"
#property indicator_type9   DRAW_LINE
#property indicator_color9  clrDarkOrange
#property indicator_style9  STYLE_DOT

#property indicator_label10 "Cross bassa"
#property indicator_type10  DRAW_LINE
#property indicator_color10 clrDarkOrange
#property indicator_style10 STYLE_DOT

#property indicator_label11 "LONG"
#property indicator_type11  DRAW_ARROW
#property indicator_color11 clrLime
#property indicator_width11 3

#property indicator_label12 "SHORT"
#property indicator_type12  DRAW_ARROW
#property indicator_color12 clrRed
#property indicator_width12 3

#property indicator_label13 "Riding SU"
#property indicator_type13  DRAW_ARROW
#property indicator_color13 clrAqua

#property indicator_label14 "Riding GIU"
#property indicator_type14  DRAW_ARROW
#property indicator_color14 clrOrangeRed

//==================================================================
input group "=== MASTER: quali origini di segnale ==="
input bool   InpUsaBandRiding  = true;   // origine 1: BAND RIDING (Emiliano)
input bool   InpUsaEmaCross    = true;   // origine 2: incrocio 3 EMA (Paolo)
input bool   InpUsaFlipST      = true;   // origine 3: ROTTURA del Supertrend

input group "=== K COEFFICIENT (convenzione ABTG) ==="
input bool   InpKAuto          = true;   // K automatico dal simbolo (lo chiede al broker)
input double InpKManuale       = 1.0;    // K manuale, se K automatico e' spento
input bool   InpForzaCategoria = false;  // sovrascrivi la categoria rilevata
input int    InpCategoriaMan   = 0;      // categoria manuale: 0=INDEX 1=GOLD 2=FX 3=FX_JPY

input group "=== SUPERTREND (Pine v4 classico) ==="
input int    InpAtrPeriodST    = 10;     // ATR Period del Supertrend
input double InpMultST         = 3.0;    // ATR Multiplier
input bool   InpAtrWilder      = true;   // true = ATR di Wilder | false = SMA del True Range
input bool   InpMostraST       = true;   // disegna la linea Supertrend

input group "=== BOLLINGER principale ==="
input int    InpBBLenIdx       = 37;     // BB Period - Indici/Oro
input double InpBBMultIdx      = 3.0;    // BB Deviation - Indici/Oro
input int    InpBBLenFx        = 22;     // BB Period - Forex
input double InpBBMultFx       = 2.0;    // BB Deviation - Forex
input ENUM_APPLIED_PRICE InpBBPrezzo = PRICE_CLOSE; // BB Source
input bool   InpMostraBB       = true;   // disegna la BB principale

input group "=== BB CROSS DASHBOARD ==="
input int    InpCrossLenIdx    = 37;     // BB Cross Period - Indici/Oro
input double InpCrossMultIdx   = 1.4;    // BB Cross Deviation - Indici/Oro
input int    InpCrossLenFx     = 22;     // BB Cross Period - Forex
input double InpCrossMultFx    = 2.0;    // BB Cross Deviation - Forex
input bool   InpMostraCross    = false;  // disegna le bande Cross
input bool   InpFiltroCross    = true;   // filtro: prezzo oltre la media Cross, nel verso

input group "=== SLOPE delle bande (band riding) ==="
input int    InpSlopeBarre     = 3;      // barre su cui si misura lo slope
input double InpSlopeMin       = 0.8;    // slope minimo (punti normalizzati, x K)
input bool   InpSlopeInAtr     = false;  // MIGLIORIA: misura lo slope in ATR invece che in punti
input double InpSlopeMinAtr    = 0.15;   // [se sopra e' true] slope minimo in ATR sull'intera finestra

input group "=== ESPANSIONE delle bande ==="
input double InpEspansioneMinPct = 0.0;  // espansione minima della larghezza, in %
input int    InpEspansioneBarre  = 1;    // su quante barre si confronta la larghezza

input group "=== ATR: triplo filtro in AND ==="
input bool   InpAtrFiltroA     = true;   // A: ATR sopra la sua media (regime)
input int    InpAtrLen         = 14;     // ATR Period
input int    InpAtrAvgLen      = 50;     // ATR Average Period
input bool   InpAtrFiltroB     = true;   // B: ATR sopra una soglia
input double InpAtrMin         = 8.0;    // ATR minimo (punti normalizzati, x K)
input bool   InpAtrFiltroC     = true;   // C: range candela sopra X volte l'ATR
input double InpCandleAtrMult  = 1.0;    // X (range candela / ATR)

input group "=== CONFERMA 2a candela ==="
input bool   InpConferma       = true;   // conferma della 2a candela (dura)

input group "=== HEIKIN ASHI (solo Band Riding) ==="
input bool   InpFiltroHA       = true;   // niente ombra contraria su 2 candele HA
input double InpHaWickToll     = 0.5;    // tolleranza ombra HA (punti normalizzati, x K)

input group "=== 3 EMA di Paolo + la 200 ==="
input int    InpEmaFast        = 9;      // EMA veloce
input int    InpEmaMid         = 21;     // EMA media
input int    InpEmaSlow        = 50;     // EMA lenta (trend di giornata)
input int    InpEmaFondo       = 200;    // EMA di fondo
input int    InpEmaSlopeBarre  = 3;      // barre per la pendenza della EMA lenta
input double InpEmaSlopeMin    = 0.2;    // pendenza minima EMA lenta (punti normalizzati, x K)
input bool   InpMostraEma      = true;   // disegna le EMA

input group "=== FILTRI EXTRA sul segnale finale ==="
input bool   InpFiltroEma200   = false;  // prezzo oltre la EMA 200, nel verso del segnale
input bool   InpFiltroST       = false;  // Supertrend concorde col verso del segnale
input bool   InpFiltroRiding   = false;  // serve il BAND RIDING attivo, nel verso
input int    InpRidingBarre    = 3;      // barre consecutive per dichiarare RIDING
input bool   InpMostraRiding   = true;   // marca le barre in riding
input bool   InpAntiDoppione   = true;   // anti-doppione globale sul regime
input bool   InpFiltroOrario   = false;  // finestra oraria (ORA SERVER: BCM = ora IT - 1)
input int    InpOraDa          = 8;      // ora server di inizio (inclusa)
input int    InpOraA           = 22;     // ora server di fine (esclusa)

input group "=== AVVISI ==="
input bool   InpAlertSegnale   = true;   // avvisa su LONG / SHORT
input bool   InpAlertRiding    = false;  // avvisa quando parte un BAND RIDING
input bool   InpSoloBarraChiusa= true;   // avvisa solo a barra CHIUSA
input bool   InpAlertPopup     = true;   // finestra di avviso
input bool   InpAlertPush      = false;  // notifica push
input bool   InpAlertSuono     = false;  // suono
input string InpFileSuono      = "alert.wav"; // file del suono

input group "=== PANNELLO ==="
input bool   InpPannello       = true;   // pannello di stato
input int    InpPannelloX      = 12;     // distanza dal bordo sinistro
input int    InpPannelloY      = 18;     // distanza dal bordo alto
input color  InpPannelloColore = clrGainsboro; // colore del testo

//==================================================================
double BufST[], BufSTCol[];
double BufE1[], BufE2[], BufE3[], BufE4[];
double BufBBU[], BufBBM[], BufBBD[];
double BufCRU[], BufCRD[];
double BufLong[], BufShort[], BufRideU[], BufRideD[];
double BufStLong[], BufStShort[], BufDir[], BufRide[];
double BufHaO[], BufHaC[], BufRegime[], BufRawL[], BufRawS[], BufCRM[];

int hATR=INVALID_HANDLE, hATRf=INVALID_HANDLE;
int hE1=INVALID_HANDLE, hE2=INVALID_HANDLE, hE3=INVALID_HANDLE, hE4=INVALID_HANDLE;
int hBB=INVALID_HANDLE, hCR=INVALID_HANDLE;

double AtrST[], TRv[], AtrF[], AtrFAvg[];
double g_K=1.0;
string g_categoria="INDEX";
bool   g_catDaBroker=true;
int    g_bbLen=37, g_crLen=37;
double g_bbMult=3.0, g_crMult=1.4;
double g_slopeMinPrezzo=0.0, g_atrMinPrezzo=0.0, g_haTollPrezzo=0.0, g_emaSlopeMinPrezzo=0.0;
datetime g_ultAlertSeg=0, g_ultAlertRide=0;
string g_pre="";
string g_originaUlt="";

//--- prototipi
bool   CalcolaAtrST(const int rates_total,const int daBarra,const bool tutto,
                    const double &high[],const double &low[],const double &close[]);
bool   FiltriExtra(const int i,const int verso,const double &close[],const datetime &time[]);
void   Avvisa(const string testo);
string EtichettaTF();
string NomeCategoria(const int c);
void   Riga(const int n,const string testo,const color col);
void   DisegnaPannello(const int rates_total,const double &close[],const datetime &time[]);
double PendenzaEmaLenta(const int i);

//+------------------------------------------------------------------+
//| K COEFFICIENT: in MT5 lo si CHIEDE al broker, non si indovina    |
//| dal nome. Vedi NOTE in fondo (trappola del v1.2).                |
//+------------------------------------------------------------------+
void RilevaCategoriaEK()
  {
   string tick=_Symbol; StringToUpper(tick);
   long   cm  =SymbolInfoInteger(_Symbol,SYMBOL_TRADE_CALC_MODE);
   string prof=SymbolInfoString(_Symbol,SYMBOL_CURRENCY_PROFIT);
   string base=SymbolInfoString(_Symbol,SYMBOL_CURRENCY_BASE);
   StringToUpper(prof); StringToUpper(base);

   bool oro=(StringFind(tick,"XAU")>=0);
   bool fx =(cm==SYMBOL_CALC_MODE_FOREX || cm==SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE);

   //--- secondo indizio, indipendente dal CALC_MODE: se il broker serve il
   //    forex come CFD, base e profitto sono comunque due VALUTE e i decimali
   //    sono 3 o 5. Cosi' un EURUSD/CFD non finisce su K=1.0 in silenzio.
   if(!fx && !oro && StringLen(base)==3 && StringLen(prof)==3 &&
      base!=prof && (_Digits==3 || _Digits==5 || _Digits==2 || _Digits==4))
      fx=(StringFind(tick,base)>=0 && StringFind(tick,prof)>=0);

   g_catDaBroker=true;
   if(oro)                     g_categoria="GOLD";
   else if(fx && prof=="JPY")  g_categoria="FX_JPY";
   else if(fx)                 g_categoria="FX";
   else                        g_categoria="INDEX";

   if(InpForzaCategoria)
     { g_categoria=NomeCategoria(InpCategoriaMan); g_catDaBroker=false; }

   double autoK=1.0;
   if(g_categoria=="FX")     autoK=0.0001;
   if(g_categoria=="FX_JPY") autoK=0.01;
   g_K=(InpKAuto)?autoK:InpKManuale;

   bool fxCat=(g_categoria=="FX" || g_categoria=="FX_JPY");
   g_bbLen =(fxCat)?InpBBLenFx :InpBBLenIdx;
   g_bbMult=(fxCat)?InpBBMultFx:InpBBMultIdx;
   g_crLen =(fxCat)?InpCrossLenFx :InpCrossLenIdx;
   g_crMult=(fxCat)?InpCrossMultFx:InpCrossMultIdx;

   //--- le soglie in "punti normalizzati" diventano prezzo, come nel v1.2
   g_slopeMinPrezzo   =InpSlopeMin    *g_K;
   g_atrMinPrezzo     =InpAtrMin      *g_K;
   g_haTollPrezzo     =InpHaWickToll  *g_K;
   g_emaSlopeMinPrezzo=InpEmaSlopeMin *g_K;
  }

//+------------------------------------------------------------------+
string NomeCategoria(const int c)
  {
   if(c==1) return("GOLD");
   if(c==2) return("FX");
   if(c==3) return("FX_JPY");
   return("INDEX");
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   //--- VALIDAZIONE. L'indicatore esiste per fare PROVE dalle impostazioni:
   //    ogni input e' una porta aperta. Una finestra NEGATIVA leggerebbe
   //    oltre la fine degli array (i-(-10) = i+10) e fermerebbe tutto.
   if(InpAtrPeriodST<1 || InpBBLenIdx<2 || InpBBLenFx<2 || InpMultST<=0.0 ||
      InpCrossLenIdx<2 || InpCrossLenFx<2 || InpAtrLen<1 || InpAtrAvgLen<1 ||
      InpEmaFast<1 || InpEmaMid<1 || InpEmaSlow<1 || InpEmaFondo<1 ||
      InpSlopeBarre<1 || InpEspansioneBarre<1 || InpEmaSlopeBarre<1 ||
      InpRidingBarre<1 || InpCandleAtrMult<=0.0 ||
      InpEspansioneMinPct<0.0 || InpHaWickToll<0.0 ||
      InpCategoriaMan<0 || InpCategoriaMan>3 || InpKManuale<=0.0)
     {
      Print("ABTG_SuperEMA_Riding: parametri non validi. Richiesti: periodi ATR/BB/Cross/EMA >= 1 ",
            "(BB e Cross >= 2), moltiplicatori > 0, SlopeBarre/EspansioneBarre/EmaSlopeBarre/",
            "RidingBarre >= 1, EspansioneMinPct >= 0, HaWickToll >= 0, CategoriaMan 0..3, KManuale > 0.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpFiltroOrario &&
      (InpOraDa<0 || InpOraDa>23 || InpOraA<0 || InpOraA>23 || InpOraDa==InpOraA))
     {
      Print("ABTG_SuperEMA_Riding: filtro orario non valido. Ore 0..23 in ORA SERVER ",
            "(BCM = ora italiana - 1: DAX 8, Nasdaq 14), e OraDa diversa da OraA.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(!InpUsaBandRiding && !InpUsaEmaCross && !InpUsaFlipST)
      Print("ABTG_SuperEMA_Riding: ATTENZIONE, nessuna origine attiva. L'indicatore disegna ",
            "le linee e il pannello ma NON produrra' MAI un segnale ne' un avviso.");
   RilevaCategoriaEK();

   SetIndexBuffer( 0,BufST,     INDICATOR_DATA);
   SetIndexBuffer( 1,BufSTCol,  INDICATOR_COLOR_INDEX);
   SetIndexBuffer( 2,BufE1,     INDICATOR_DATA);
   SetIndexBuffer( 3,BufE2,     INDICATOR_DATA);
   SetIndexBuffer( 4,BufE3,     INDICATOR_DATA);
   SetIndexBuffer( 5,BufE4,     INDICATOR_DATA);
   SetIndexBuffer( 6,BufBBU,    INDICATOR_DATA);
   SetIndexBuffer( 7,BufBBM,    INDICATOR_DATA);
   SetIndexBuffer( 8,BufBBD,    INDICATOR_DATA);
   SetIndexBuffer( 9,BufCRU,    INDICATOR_DATA);
   SetIndexBuffer(10,BufCRD,    INDICATOR_DATA);
   SetIndexBuffer(11,BufLong,   INDICATOR_DATA);
   SetIndexBuffer(12,BufShort,  INDICATOR_DATA);
   SetIndexBuffer(13,BufRideU,  INDICATOR_DATA);
   SetIndexBuffer(14,BufRideD,  INDICATOR_DATA);
   SetIndexBuffer(15,BufStLong, INDICATOR_CALCULATIONS);
   SetIndexBuffer(16,BufStShort,INDICATOR_CALCULATIONS);
   SetIndexBuffer(17,BufDir,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(18,BufRide,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(19,BufHaO,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(20,BufHaC,    INDICATOR_CALCULATIONS);
   SetIndexBuffer(21,BufRegime, INDICATOR_CALCULATIONS);
   SetIndexBuffer(22,BufRawL,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(23,BufRawS,   INDICATOR_CALCULATIONS);
   SetIndexBuffer(24,BufCRM,    INDICATOR_CALCULATIONS);

   for(int p=0;p<14;p++) PlotIndexSetDouble(p,PLOT_EMPTY_VALUE,0.0);
   PlotIndexSetInteger(10,PLOT_ARROW,233);   // LONG
   PlotIndexSetInteger(11,PLOT_ARROW,234);   // SHORT
   PlotIndexSetInteger(12,PLOT_ARROW,159);   // riding su
   PlotIndexSetInteger(13,PLOT_ARROW,159);   // riding giu

   if(!InpMostraST)     PlotIndexSetInteger(0,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraEma)    for(int p=1;p<=4;p++)  PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraBB)     for(int p=5;p<=7;p++)  PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraCross)  for(int p=8;p<=9;p++)  PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);
   if(!InpMostraRiding) for(int p=12;p<=13;p++)PlotIndexSetInteger(p,PLOT_DRAW_TYPE,DRAW_NONE);

   hE1=iMA(_Symbol,_Period,InpEmaFast ,0,MODE_EMA,PRICE_CLOSE);
   hE2=iMA(_Symbol,_Period,InpEmaMid  ,0,MODE_EMA,PRICE_CLOSE);
   hE3=iMA(_Symbol,_Period,InpEmaSlow ,0,MODE_EMA,PRICE_CLOSE);
   hE4=iMA(_Symbol,_Period,InpEmaFondo,0,MODE_EMA,PRICE_CLOSE);
   hBB=iBands(_Symbol,_Period,g_bbLen,0,g_bbMult,InpBBPrezzo);
   hCR=iBands(_Symbol,_Period,g_crLen,0,g_crMult,InpBBPrezzo);
   hATRf=iATR(_Symbol,_Period,InpAtrLen);
   if(InpAtrWilder) hATR=iATR(_Symbol,_Period,InpAtrPeriodST);

   if(hE1==INVALID_HANDLE || hE2==INVALID_HANDLE || hE3==INVALID_HANDLE ||
      hE4==INVALID_HANDLE || hBB==INVALID_HANDLE || hCR==INVALID_HANDLE ||
      hATRf==INVALID_HANDLE || (InpAtrWilder && hATR==INVALID_HANDLE))
     {
      Print("ABTG_SuperEMA_Riding: creazione handle fallita.");
      return(INIT_FAILED);
     }

   //--- il prefisso distingue l'ISTANZA, non solo il grafico: due copie dello
   //    stesso indicatore sullo stesso grafico si sovrascriverebbero il
   //    pannello a ogni tick, e si leggerebbero numeri dell'altro assetto.
   g_pre="ABTGSER_"+IntegerToString(ChartID())+"_"+
         IntegerToString(InpAtrPeriodST)+"x"+DoubleToString(InpMultST,1)+"_"+
         IntegerToString(g_bbLen)+"_"+IntegerToString(InpSlopeBarre)+"_"+
         IntegerToString(InpRidingBarre)+"_"+IntegerToString(InpPannelloY)+"_";
   IndicatorSetString(INDICATOR_SHORTNAME,
      StringFormat("ABTG BR+EMA+ST v2.00 [%s K=%s] (ST %d x %.1f | BB %d x %.1f | EMA %d/%d/%d/%d)",
         g_categoria,DoubleToString(g_K,6),InpAtrPeriodST,InpMultST,
         g_bbLen,g_bbMult,InpEmaFast,InpEmaMid,InpEmaSlow,InpEmaFondo));
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hATR !=INVALID_HANDLE) IndicatorRelease(hATR);
   if(hATRf!=INVALID_HANDLE) IndicatorRelease(hATRf);
   if(hE1  !=INVALID_HANDLE) IndicatorRelease(hE1);
   if(hE2  !=INVALID_HANDLE) IndicatorRelease(hE2);
   if(hE3  !=INVALID_HANDLE) IndicatorRelease(hE3);
   if(hE4  !=INVALID_HANDLE) IndicatorRelease(hE4);
   if(hBB  !=INVALID_HANDLE) IndicatorRelease(hBB);
   if(hCR  !=INVALID_HANDLE) IndicatorRelease(hCR);
   ObjectsDeleteAll(0,g_pre);
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//| ATR del Supertrend: Wilder (iATR) o SMA del True Range (Pine)    |
//+------------------------------------------------------------------+
bool CalcolaAtrST(const int rates_total,const int daBarra,const bool tutto,
                  const double &high[],const double &low[],const double &close[])
  {
   if(InpAtrWilder)
     {
      if(ArraySize(AtrST)!=rates_total) ArrayResize(AtrST,rates_total);
      ArraySetAsSeries(AtrST,false);
      return(CopyBuffer(hATR,0,0,rates_total,AtrST)==rates_total);
     }
   if(ArraySize(AtrST)!=rates_total) ArrayResize(AtrST,rates_total);
   if(ArraySize(TRv)  !=rates_total) ArrayResize(TRv,rates_total);
   ArraySetAsSeries(AtrST,false);
   ArraySetAsSeries(TRv,false);

   //--- al primo giro si rifa' TUTTO: partendo da meta' array la media
   //    leggerebbe gli zeri delle barre mai calcolate.
   int da=(tutto || daBarra<1)?0:daBarra;
   for(int i=da;i<rates_total;i++)
     {
      if(i==0){ TRv[0]=high[0]-low[0]; AtrST[0]=0.0; continue; }
      double a=high[i]-low[i];
      double b=MathAbs(high[i]-close[i-1]);
      double c=MathAbs(low[i] -close[i-1]);
      TRv[i]=MathMax(a,MathMax(b,c));
     }
   if(tutto) for(int i=0;i<InpAtrPeriodST-1 && i<rates_total;i++) AtrST[i]=0.0;
   int daA=(da<InpAtrPeriodST-1)?InpAtrPeriodST-1:da;
   for(int i=daA;i<rates_total;i++)
     {
      double s=0.0;
      for(int k=0;k<InpAtrPeriodST;k++) s+=TRv[i-k];
      AtrST[i]=s/InpAtrPeriodST;
     }
   return(true);
  }

//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   //--- il verso su cui si appoggia TUTTO il file, dichiarato invece che
   //    dato per buono: indice 0 = barra piu' VECCHIA.
   ArraySetAsSeries(time,false);  ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);  ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);

   int piuLungo=(int)MathMax(InpAtrPeriodST,MathMax(g_bbLen,MathMax(g_crLen,
                MathMax(InpEmaFondo,InpAtrLen+InpAtrAvgLen))));
   int coda=(int)MathMax(InpSlopeBarre,MathMax(InpEmaSlopeBarre,
            MathMax(InpEspansioneBarre,InpRidingBarre)));
   int minimo=piuLungo+coda+5;
   if(rates_total<minimo)
     {
      static bool dettoCorto=false;
      if(!dettoCorto)
        {
         dettoCorto=true;
         PrintFormat("ABTG_SuperEMA_Riding: servono almeno %d barre (la piu' lunga e' la EMA %d "
                     "piu' le finestre); sul grafico ce ne sono %d, quindi non disegno niente. "
                     "Carica piu' storico (Fine / PgUp) o sali di timeframe.",
                     minimo,InpEmaFondo,rates_total);
        }
      return(0);
     }

   int start=(prev_calculated>0)?prev_calculated-1:minimo;
   if(start<minimo) start=minimo;

   //--- serie di appoggio --------------------------------------------------
   if(!CalcolaAtrST(rates_total,start-InpAtrPeriodST-1,(prev_calculated==0),high,low,close))
      return(prev_calculated);
   if(ArraySize(AtrF)!=rates_total)
     { ArrayResize(AtrF,rates_total); ArrayResize(AtrFAvg,rates_total); }
   ArraySetAsSeries(AtrF,false); ArraySetAsSeries(AtrFAvg,false);
   if(CopyBuffer(hATRf,0,0,rates_total,AtrF)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE1,0,0,rates_total,BufE1)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE2,0,0,rates_total,BufE2)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE3,0,0,rates_total,BufE3)<rates_total) return(prev_calculated);
   if(CopyBuffer(hE4,0,0,rates_total,BufE4)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,BASE_LINE, 0,rates_total,BufBBM)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,UPPER_BAND,0,rates_total,BufBBU)<rates_total) return(prev_calculated);
   if(CopyBuffer(hBB,LOWER_BAND,0,rates_total,BufBBD)<rates_total) return(prev_calculated);
   if(CopyBuffer(hCR,BASE_LINE, 0,rates_total,BufCRM)<rates_total) return(prev_calculated);
   if(CopyBuffer(hCR,UPPER_BAND,0,rates_total,BufCRU)<rates_total) return(prev_calculated);
   if(CopyBuffer(hCR,LOWER_BAND,0,rates_total,BufCRD)<rates_total) return(prev_calculated);

   //--- media dell'ATR (filtro A) -----------------------------------------
   {
    int daA=(prev_calculated==0)?0:MathMax(0,start-InpAtrAvgLen-1);
    for(int i=daA;i<rates_total;i++)
      {
       if(i<InpAtrAvgLen-1){ AtrFAvg[i]=0.0; continue; }
       double s=0.0;
       for(int k=0;k<InpAtrAvgLen;k++) s+=AtrF[i-k];
       AtrFAvg[i]=s/InpAtrAvgLen;
      }
   }

   //--- pulizia della testa ------------------------------------------------
   if(prev_calculated==0)
      for(int i=0;i<minimo && i<rates_total;i++)
        {
         BufST[i]=0.0; BufSTCol[i]=0.0;
         BufLong[i]=0.0; BufShort[i]=0.0; BufRideU[i]=0.0; BufRideD[i]=0.0;
         BufStLong[i]=low[i]; BufStShort[i]=high[i]; BufDir[i]=1.0; BufRide[i]=0.0;
         BufHaO[i]=(open[i]+close[i])/2.0; BufHaC[i]=(open[i]+high[i]+low[i]+close[i])/4.0;
         BufRegime[i]=0.0; BufRawL[i]=0.0; BufRawS[i]=0.0;
        }

   for(int i=start;i<rates_total;i++)
     {
      BufLong[i]=0.0; BufShort[i]=0.0; BufRideU[i]=0.0; BufRideD[i]=0.0;

      //=========== SUPERTREND, identico al Pine v4 ======================
      //  NOMI: nel Pine "up" e' la banda BASSA (usata in trend SU) e "dn"
      //  la banda ALTA. Qui StLong / StShort, per non sbagliarsi.
      double mid=(high[i]+low[i])/2.0;
      double a  =InpMultST*AtrST[i];
      double up =mid-a;                 // Pine: up = src - Multiplier*atr
      double dn =mid+a;                 // Pine: dn = src + Multiplier*atr
      double up1=BufStLong[i-1];        // Pine: up1 = nz(up[1])
      double dn1=BufStShort[i-1];       // Pine: dn1 = nz(dn[1])
      if(close[i-1]>up1) up=MathMax(up,up1);
      if(close[i-1]<dn1) dn=MathMin(dn,dn1);
      BufStLong[i]=up; BufStShort[i]=dn;

      //--- il flip guarda la banda della barra PRECEDENTE (up1/dn1)
      double dirPrec=BufDir[i-1];
      double dir=dirPrec;
      if(dirPrec<0.0 && close[i]>dn1)      dir= 1.0;
      else if(dirPrec>0.0 && close[i]<up1) dir=-1.0;
      BufDir[i]=dir;
      if(dir>0.0){ BufST[i]=up; BufSTCol[i]=0.0; }
      else       { BufST[i]=dn; BufSTCol[i]=1.0; }

      //=========== HEIKIN ASHI ==========================================
      BufHaC[i]=(open[i]+high[i]+low[i]+close[i])/4.0;
      BufHaO[i]=(BufHaO[i-1]+BufHaC[i-1])/2.0;
      double haHi=MathMax(high[i],MathMax(BufHaO[i],BufHaC[i]));
      double haLo=MathMin(low[i], MathMin(BufHaO[i],BufHaC[i]));
      double wickGiu=MathMin(BufHaO[i],BufHaC[i])-haLo;
      double wickSu =haHi-MathMax(BufHaO[i],BufHaC[i]);
      double haHiP=MathMax(high[i-1],MathMax(BufHaO[i-1],BufHaC[i-1]));
      double haLoP=MathMin(low[i-1], MathMin(BufHaO[i-1],BufHaC[i-1]));
      double wickGiuP=MathMin(BufHaO[i-1],BufHaC[i-1])-haLoP;
      double wickSuP =haHiP-MathMax(BufHaO[i-1],BufHaC[i-1]);
      bool haLongOk =(!InpFiltroHA) || (wickGiu<=g_haTollPrezzo && wickGiuP<=g_haTollPrezzo);
      bool haShortOk=(!InpFiltroHA) || (wickSu <=g_haTollPrezzo && wickSuP <=g_haTollPrezzo);

      //=========== SLOPE, ESPANSIONE, CONCORDANZA CROSS =================
      int js=i-InpSlopeBarre; if(js<0) js=0;
      double slopeSu =BufBBU[i]-BufBBU[js];
      double slopeGiu=BufBBD[i]-BufBBD[js];
      double sogliaSlope=(InpSlopeInAtr)?(InpSlopeMinAtr*AtrF[i]):g_slopeMinPrezzo;
      bool slopeLongOk =(slopeSu >= sogliaSlope);
      bool slopeShortOk=(slopeGiu<=-sogliaSlope);

      int je=i-InpEspansioneBarre; if(je<0) je=0;
      double largOra=BufBBU[i]-BufBBD[i];
      double largPri=BufBBU[je]-BufBBD[je];
      bool espande=(largPri>0.0)
                   ? (largOra>=largPri*(1.0+InpEspansioneMinPct/100.0))
                   : false;

      bool crossLongOk =(!InpFiltroCross) || (close[i]>BufCRM[i]);
      bool crossShortOk=(!InpFiltroCross) || (close[i]<BufCRM[i]);

      //=========== ATR: triplo filtro in AND ============================
      bool fA=(!InpAtrFiltroA) || (AtrFAvg[i]>0.0 && AtrF[i]>AtrFAvg[i]);
      bool fB=(!InpAtrFiltroB) || (AtrF[i]>g_atrMinPrezzo);
      bool fC=(!InpAtrFiltroC) || ((high[i]-low[i])>InpCandleAtrMult*AtrF[i]);
      bool atrOk=(fA && fB && fC);

      //=========== BAND RIDING: conteggio consecutivo ===================
      bool toccaSu =(high[i]>=BufBBU[i]);
      bool toccaGiu=(low[i] <=BufBBD[i]);
      double prec=BufRide[i-1];
      if(toccaSu)       BufRide[i]=(prec>0.0)?prec+1.0: 1.0;
      else if(toccaGiu) BufRide[i]=(prec<0.0)?prec-1.0:-1.0;
      else              BufRide[i]=0.0;
      bool ridingSu =(BufRide[i]>= (double)InpRidingBarre);
      bool ridingGiu=(BufRide[i]<=-(double)InpRidingBarre);
      if(InpMostraRiding)
        {
         if(ridingSu)  BufRideU[i]=BufBBU[i];
         if(ridingGiu) BufRideD[i]=BufBBD[i];
        }

      //=========== ORIGINE 1: BAND RIDING (v1.2, identico) ==============
      bool rawLongBR =(toccaSu  && slopeLongOk  && espande && crossLongOk  && atrOk && haLongOk);
      bool rawShortBR=(toccaGiu && slopeShortOk && espande && crossShortOk && atrOk && haShortOk);

      //=========== ORIGINE 2: incrocio 3 EMA (v1.2, identico) ===========
      bool allLong  =(BufE1[i]>BufE2[i] && BufE2[i]>BufE3[i]);
      bool allShort =(BufE1[i]<BufE2[i] && BufE2[i]<BufE3[i]);
      bool allLongP =(BufE1[i-1]>BufE2[i-1] && BufE2[i-1]>BufE3[i-1]);
      bool allShortP=(BufE1[i-1]<BufE2[i-1] && BufE2[i-1]<BufE3[i-1]);
      double pend=PendenzaEmaLenta(i);
      bool rawLongEMA =(allLong  && !allLongP  && pend>= g_emaSlopeMinPrezzo);
      bool rawShortEMA=(allShort && !allShortP && pend<=-g_emaSlopeMinPrezzo);

      //=========== ORIGINE 3: ROTTURA del Supertrend ====================
      bool rawLongST =(BufDir[i]>0.0 && BufDir[i-1]<0.0);
      bool rawShortST=(BufDir[i]<0.0 && BufDir[i-1]>0.0);

      //--- il grezzo unificato, memorizzato per la conferma della 2a candela
      bool rawL=(InpUsaBandRiding && rawLongBR) ||(InpUsaEmaCross && rawLongEMA) ||(InpUsaFlipST && rawLongST);
      bool rawS=(InpUsaBandRiding && rawShortBR)||(InpUsaEmaCross && rawShortEMA)||(InpUsaFlipST && rawShortST);
      BufRawL[i]=(rawL)?1.0:0.0;
      BufRawS[i]=(rawS)?1.0:0.0;

      //=========== CONFERMA 2a CANDELA (v1.2, identico) =================
      bool confL,confS;
      if(InpConferma)
        {
         confL=(BufRawL[i-1]>0.0 && close[i]>high[i-1] && close[i]>open[i]);
         confS=(BufRawS[i-1]>0.0 && close[i]<low[i-1]  && close[i]<open[i]);
        }
      else { confL=rawL; confS=rawS; }

      //=========== FILTRI EXTRA sul segnale finale ======================
      if(confL && !FiltriExtra(i,+1,close,time)) confL=false;
      if(confS && !FiltriExtra(i,-1,close,time)) confS=false;
      if(confL && InpFiltroRiding && !ridingSu)  confL=false;
      if(confS && InpFiltroRiding && !ridingGiu) confS=false;

      //=========== ANTI-DOPPIONE GLOBALE sul regime =====================
      double regPrec=BufRegime[i-1];
      double reg=regPrec;
      bool segL=confL, segS=confS;
      if(InpAntiDoppione)
        {
         segL=(confL && regPrec!= 1.0);
         segS=(confS && regPrec!=-1.0);
        }
      if(segL)      reg= 1.0;
      else if(segS) reg=-1.0;
      BufRegime[i]=reg;

      //--- due versi sulla STESSA barra (possibile con InpConferma spento, se
      //    due origini puntano in direzioni opposte): non si sceglie a caso,
      //    si TACE. Senza questo, l'avviso direbbe "LONG" solo perche' guarda
      //    il buffer long per primo.
      if(segL && segS){ segL=false; segS=false; BufRegime[i]=regPrec; }
      if(segL) BufLong[i] =low[i] -AtrF[i]*0.6;
      if(segS) BufShort[i]=high[i]+AtrF[i]*0.6;

      //--- da dove e' nato: serve solo al pannello e all'avviso
      if((segL || segS) && i==rates_total-1)
        {
         g_originaUlt="";
         if(InpUsaBandRiding && (rawLongBR ||rawShortBR )) g_originaUlt+="BR ";
         if(InpUsaEmaCross   && (rawLongEMA||rawShortEMA)) g_originaUlt+="EMA ";
         if(InpUsaFlipST     && (rawLongST ||rawShortST )) g_originaUlt+="ST ";
         if(g_originaUlt=="") g_originaUlt="conferma";
        }
     }

   //=========== AVVISI ==================================================
   int ib=(InpSoloBarraChiusa)?rates_total-2:rates_total-1;
   if(ib>=minimo)
     {
      if(InpAlertSegnale && (BufLong[ib]>0.0 || BufShort[ib]>0.0) && g_ultAlertSeg!=time[ib])
        {
         g_ultAlertSeg=time[ib];
         string verso=(BufLong[ib]>0.0)?"LONG":"SHORT";
         Avvisa(StringFormat("ABTG %s %s: %s  [%s K=%s]  ST %s . EMA9 %s EMA21 . BB largh %.0f pt @ %s",
                _Symbol,EtichettaTF(),verso,g_categoria,DoubleToString(g_K,6),
                (BufDir[ib]>0.0?"verde":"rosso"),
                (BufE1[ib]>BufE2[ib]?">":"<"),
                (BufBBU[ib]-BufBBD[ib])/_Point,
                DoubleToString(close[ib],_Digits)));
        }
      bool partSu =(BufRide[ib]== (double)InpRidingBarre);
      bool partGiu=(BufRide[ib]==-(double)InpRidingBarre);
      if(InpAlertRiding && (partSu||partGiu) && g_ultAlertRide!=time[ib])
        {
         g_ultAlertRide=time[ib];
         int jj=ib-InpSlopeBarre; if(jj<0) jj=0;
         double sl=(partSu)?(BufBBU[ib]-BufBBU[jj]):(BufBBD[ib]-BufBBD[jj]);
         Avvisa(StringFormat("ABTG %s %s: BAND RIDING %s da %d barre - slope %.1f pt su %d barre, larghezza %.0f pt",
                _Symbol,EtichettaTF(),(partSu?"SU":"GIU"),InpRidingBarre,
                sl/_Point,InpSlopeBarre,(BufBBU[ib]-BufBBD[ib])/_Point));
        }
     }

   if(InpPannello) DisegnaPannello(rates_total,close,time);
   return(rates_total);
  }

//+------------------------------------------------------------------+
double PendenzaEmaLenta(const int i)
  {
   int n=(InpEmaSlopeBarre<1)?1:InpEmaSlopeBarre;
   int j=i-n;
   if(j<0) return(0.0);
   return(BufE3[i]-BufE3[j]);
  }

//+------------------------------------------------------------------+
//| I filtri EXTRA, quelli che NON stanno nel v1.2: si accendono a   |
//| uno a uno e valgono sul segnale finale, qualunque sia l'origine. |
//+------------------------------------------------------------------+
bool FiltriExtra(const int i,const int verso,const double &close[],const datetime &time[])
  {
   if(InpFiltroEma200)
     {
      if(verso>0 && !(close[i]>BufE4[i])) return(false);
      if(verso<0 && !(close[i]<BufE4[i])) return(false);
     }
   if(InpFiltroST)
     {
      if(verso>0 && !(BufDir[i]>0.0)) return(false);
      if(verso<0 && !(BufDir[i]<0.0)) return(false);
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
void Avvisa(const string testo)
  {
   if(InpAlertPopup) Alert(testo);
   else              Print(testo);
   if(InpAlertPush)  SendNotification(testo);
   if(InpAlertSuono) PlaySound(InpFileSuono);
  }

//+------------------------------------------------------------------+
string EtichettaTF()
  { return(StringSubstr(EnumToString((ENUM_TIMEFRAMES)_Period),7)); }

//+------------------------------------------------------------------+
void Riga(const int n,const string testo,const color col)
  {
   string nome=g_pre+"r"+IntegerToString(n);
   if(ObjectFind(0,nome)<0)
     {
      ObjectCreate(0,nome,OBJ_LABEL,0,0,0);
      ObjectSetInteger(0,nome,OBJPROP_CORNER,CORNER_LEFT_UPPER);
      ObjectSetInteger(0,nome,OBJPROP_FONTSIZE,8);
      ObjectSetString (0,nome,OBJPROP_FONT,"Consolas");
      ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
     }
   //--- la POSIZIONE si riapplica sempre: dentro il ramo di creazione,
   //    un'etichetta che esiste gia' non l'avrebbe mai letta.
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,InpPannelloX);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,InpPannelloY+n*14);
   ObjectSetString (0,nome,OBJPROP_TEXT,testo);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,col);
  }

//+------------------------------------------------------------------+
void DisegnaPannello(const int rates_total,const double &close[],const datetime &time[])
  {
   int i=rates_total-1;
   if(i<3) return;
   int js=i-InpSlopeBarre; if(js<0) js=0;
   int je=i-InpEspansioneBarre; if(je<0) je=0;
   double slopeSu =(BufBBU[i]-BufBBU[js])/_Point;
   double slopeGiu=(BufBBD[i]-BufBBD[js])/_Point;
   double sogliaSlope=((InpSlopeInAtr)?(InpSlopeMinAtr*AtrF[i]):g_slopeMinPrezzo)/_Point;
   double largOra=BufBBU[i]-BufBBD[i];
   double largPri=BufBBU[je]-BufBBD[je];
   double cresc=(largPri>0.0)?((largOra-largPri)/largPri*100.0):0.0;
   bool espande=(largPri>0.0 && largOra>=largPri*(1.0+InpEspansioneMinPct/100.0));
   bool fA=(AtrFAvg[i]>0.0 && AtrF[i]>AtrFAvg[i]);
   bool fB=(AtrF[i]>g_atrMinPrezzo);
   int  ride=(int)BufRide[i];

   //--- IL CONTROLLO CHE IL v1.2 NON AVEVA: se la soglia, letta in ATR,
   //    e' fuori scala, il K e' quasi certamente sbagliato. Qui si VEDE.
   double sogliaInAtr=(AtrF[i]>0.0)
                      ? ((InpSlopeInAtr?InpSlopeMinAtr*AtrF[i]:g_slopeMinPrezzo)/AtrF[i])
                      : 0.0;
   bool kSospetto=(sogliaInAtr>5.0 || (sogliaInAtr<0.001 && sogliaInAtr>0.0));

   Riga(0,"ABTG BR+EMA+ST v2.00   "+_Symbol+" "+EtichettaTF(),InpPannelloColore);
   Riga(1,StringFormat("categoria  : %-7s %s   K = %s",
        g_categoria,(g_catDaBroker?"(broker)":"(MANUALE)"),DoubleToString(g_K,6)),
        (kSospetto?clrRed:clrYellow));
   if(kSospetto)
      Riga(2,StringFormat("K SOSPETTO : la soglia slope vale %.4f ATR - controlla categoria/K",sogliaInAtr),clrRed);
   else
      Riga(2,StringFormat("soglia slope: %.1f pt  (= %.3f ATR)",sogliaSlope,sogliaInAtr),InpPannelloColore);
   Riga(3,StringFormat("Supertrend : %-4s  linea a %.0f pt",
        (BufDir[i]>0.0?"SU":"GIU"),MathAbs(close[i]-BufST[i])/_Point),
        (BufDir[i]>0.0?clrLimeGreen:clrRed));
   Riga(4,StringFormat("EMA 9/21/50: %-5s   200: %s",
        (BufE1[i]>BufE2[i] && BufE2[i]>BufE3[i])?"LONG":((BufE1[i]<BufE2[i] && BufE2[i]<BufE3[i])?"SHORT":"MISTO"),
        (close[i]>BufE4[i]?"sopra":"sotto")),
        ((BufE1[i]>BufE2[i] && BufE2[i]>BufE3[i])?clrLimeGreen:
        ((BufE1[i]<BufE2[i] && BufE2[i]<BufE3[i])?clrRed:clrGray)));
   Riga(5,StringFormat("BB %d x %.1f : largh %.0f pt   espans %+.2f%% %s",
        g_bbLen,g_bbMult,largOra/_Point,cresc,(espande?"OK":"NO")),
        (espande?clrAqua:InpPannelloColore));
   Riga(6,StringFormat("slope su/giu: %+.1f / %+.1f pt  su %d barre",
        slopeSu,slopeGiu,InpSlopeBarre),InpPannelloColore);
   Riga(7,StringFormat("ATR(%d) %.1f pt   media %.1f pt   A:%s B:%s",
        InpAtrLen,AtrF[i]/_Point,AtrFAvg[i]/_Point,(fA?"OK":"no"),(fB?"OK":"no")),
        ((fA&&fB)?clrLimeGreen:clrOrange));
   Riga(8,StringFormat("BAND RIDING: %s%d barre  (soglia %d)",
        (ride>0?"SU ":(ride<0?"GIU ":"-- ")),(int)MathAbs((double)ride),InpRidingBarre),
        (ride>=InpRidingBarre?clrAqua:(ride<=-InpRidingBarre?clrOrangeRed:InpPannelloColore)));
   Riga(9,StringFormat("regime      : %s   origini: %s%s%s",
        (BufRegime[i]>0.0?"LONG":(BufRegime[i]<0.0?"SHORT":"--")),
        (InpUsaBandRiding?"BR ":""),(InpUsaEmaCross?"EMA ":""),(InpUsaFlipST?"ST":"")),
        (BufRegime[i]>0.0?clrLimeGreen:(BufRegime[i]<0.0?clrRed:clrGray)));
   Riga(10,"ora server barra: "+TimeToString(time[i],TIME_MINUTES)+"   (BCM = ora IT - 1)",
        InpPannelloColore);
   ChartRedraw();
  }

//+------------------------------------------------------------------+
//| NOTE -- le due differenze rispetto al Pine v1.2, dichiarate      |
//|                                                                  |
//| 1) IL RILEVAMENTO DELLO STRUMENTO. Nel v1.2 la categoria nasce   |
//|    da str.contains() sul ticker piu' syminfo.type. Se il broker  |
//|    serve il FOREX come "cfd" (capita), un EURUSD non e' ne'      |
//|    forex ne' indice ne' oro, e l'ultimo ramo del ternario lo     |
//|    manda su "INDEX" -> K = 1.0 invece di 0.0001. Le soglie       |
//|    diventano 10.000 volte piu' strette e NON ESCE PIU' NESSUN    |
//|    SEGNALE, senza un messaggio che lo dica. Qui la categoria la  |
//|    da' il broker (SYMBOL_TRADE_CALC_MODE + le due valute), con   |
//|    un secondo indizio di riserva sui decimali, e il pannello     |
//|    scrive sempre da dove viene (broker o manuale).               |
//|                                                                  |
//| 2) IL FALLIMENTO SILENZIOSO DIVENTA VISIBILE. Il pannello        |
//|    converte la soglia di slope in ATR: se vale piu' di 5 ATR o   |
//|    meno di 0,001 ATR, scrive "K SOSPETTO" in rosso. E' lo stesso |
//|    motivo per cui esiste InpSlopeInAtr: una soglia in ATR non    |
//|    dipende dal livello di prezzo, mentre una soglia in punti su  |
//|    INDEX (K=1.0) vale una cosa diversa sul Dow a 45.000 e sul    |
//|    SP500 a 5.500. Non e' un difetto del v1.2: e' il limite della |
//|    convenzione in punti, e ora si puo' misurare in due modi e    |
//|    confrontarli.                                                |
//|                                                                  |
//| 3) ATTENZIONE, PAROLA UGUALE E USO OPPOSTO: in ABTG_BreakingBand |
//|    il "band riding" e' una INVALIDAZIONE (oltre 20 candele sulla |
//|    banda = impulso esaurito, si scarta); qui e' un INGRESSO      |
//|    (il prezzo sta correndo, si entra). Sono due misure diverse   |
//|    con lo stesso nome: non si citano una per l'altra.            |
//+------------------------------------------------------------------+
