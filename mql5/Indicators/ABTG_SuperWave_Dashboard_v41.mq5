//+------------------------------------------------------------------+
//|                              ABTG_SuperWave_Dashboard_v41.mq5     |
//|                                                                  |
//|  INDICATORE UNICO "SUPERWAVE" (strategia Chiari) - versione 4.1   |
//|  SOLA VISIONE: nessun ordine, nessuna rete, nessun conto toccato. |
//|  Base: il file v4.00 ricevuto da Claudio il 01/10/2026           |
//|  (docs/sorgenti_ricevuti/...ricevuto_2026-10-01.mq5).            |
//|                                                                  |
//|   1) GRIGLIA simboli x TF (M1 M3 M5 M15 H1 H4 D1): la cella si    |
//|      accende BUY/SELL quando il Supertrend InpMult1 (3,5) si e'   |
//|      INVERTITO entro InpFlipBars barre chiuse (come la v4.00).    |
//|   2) SIMBOLO evidenziato = CONFLUENZA H4/M3. Due modi:            |
//|      InpConflMode=1 (default, NUOVO): inversione M3 recente       |
//|        (entro InpConflFlipBars barre M3 chiuse) nella direzione   |
//|        dell'H4, con H4 STABILE (nessuna inversione H4 nelle       |
//|        ultime InpConflH4Stable barre H4 chiuse);                 |
//|      InpConflMode=0 (VECCHIO v4.00): H4 e M3 nella stessa         |
//|        direzione, qualunque eta' (circa meta' del tempo).         |
//|      Lampeggia solo per InpBlinkSeconds (20 s) dall'evento, poi   |
//|      resta FISSO. Nessun ridisegno se non cambia un colore.       |
//|   3) OPERAZIONE (pannello in alto a destra + linee): il SETUP     |
//|      appartiene a (simbolo, TF del segnale). Ingresso FISSO =     |
//|      chiusura della barra di inversione del Supertrend 3,5,       |
//|      stop = valore del Supertrend su quella barra, R fisso,       |
//|      TP1/2/3 = ingresso +- R x InpTPk_R, lotti dal rischio %.     |
//|      Clic su una cella ACCESA = seleziona QUEL setup (resta       |
//|      mostrato anche se il grafico e' su un altro TF). Senza       |
//|      selezione: il setup del TF del grafico. Clic sul titolo del  |
//|      pannello = torna al TF del grafico. I lotti sono INDICATIVI. |
//|   4) LINEE (tasto ST) e LIVELLI (tasto LIVELLI) come la v4.00.    |
//|                                                                  |
//|  STESSO ALGORITMO OVUNQUE: griglia, grafico e setup usano la      |
//|  funzione SW_STCore (ATR = media SEMPLICE del True Range, la      |
//|  convenzione di iATR di MT5). La griglia legge le ultime          |
//|  InpGridBars barre CHIUSE (default 1000): misurato su XAUUSD       |
//|  2021-2026 lo stato coincide con lo storico intero dopo al        |
//|  massimo 140 barre (moltiplicatore 3,5; 240 a 5,0). Un setup si   |
//|  fissa solo su un'inversione ad almeno SW_TRUST_BARS (300) barre  |
//|  dall'inizio della finestra: prima puo' essere un'inversione      |
//|  che esiste solo nella finestra (aggancio non ancora avvenuto).   |
//|                                                                  |
//|  STATO dei tasti (HA, LIVELLI, ST, Nascondi) e SELEZIONE del      |
//|  setup: GlobalVariable del terminale con la ChartID nel nome      |
//|  (sopravvivono al cambio simbolo/TF; tolti quando rimuovi         |
//|  l'indicatore). Setup per simbolo+TF: GlobalVariable "SW41S_"     |
//|  (servono solo se l'inversione e' piu' vecchia della finestra).   |
//|                                                                  |
//|  HEIKIN ASHI: le candele native si nascondono (colori a clrNONE)  |
//|  come in ABTG_Segnali_EMA_BB_ST.mq5 e tornano su CANDELE e a ogni |
//|  uscita. SE LE CANDELE SPARISCONO dopo un crash: rimetti          |
//|  l'indicatore (le ripara da solo) o F8 > Colori.                  |
//|  Un solo indicatore per grafico che nasconde le candele.          |
//|                                                                  |
//|  DIAGNOSI (InpDiagnosi=true): tooltip completi e righe nel        |
//|  Journal (Esperti): direzione H4/M3, ora della barra letta,       |
//|  barre usate, esito di CopyRates, a ogni cambio di confluenza.    |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "4.10"
#property description "SuperWave 4.1 - sola visione, nessun ordine"
#property indicator_chart_window
#property indicator_buffers 34
#property indicator_plots   7
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
#property indicator_label6  "MA 100"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrOrange
#property indicator_label7  "MA 200"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrTomato
#property indicator_width7  2

enum ENUM_SW_CONFL
  {
   CONFL_STESSA_DIREZIONE = 0,   // 0 = v4.00: H4 e M3 nella stessa direzione
   CONFL_INVERSIONE_M3    = 1    // 1 = v4.1: inversione M3 recente nel verso dell'H4 stabile
  };

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
input ENUM_MA_METHOD InpMAmethod = MODE_SMA; // tipo medie
input int    InpFlipBars  = 1;     // cella accesa = inversione entro N barre chiuse
input bool   InpBlink     = true;  // lampeggio del simbolo in confluenza (solo per InpBlinkSeconds)
//--- v4.1: confluenza, lampeggio, ricalcolo, diagnosi ---
input ENUM_SW_CONFL InpConflMode = CONFL_INVERSIONE_M3; // confluenza: 1 = inversione M3 nel verso H4 (nuovo), 0 = stessa direzione (v4.00)
input int    InpConflFlipBars = 3;  // modo 1: inversione M3 entro N barre M3 chiuse
input int    InpConflH4Stable = 3;  // modo 1: H4 senza inversioni nelle ultime N barre H4 (0 = non richiesto)
input int    InpBlinkSeconds  = 20; // secondi di lampeggio dall'evento, poi colore fisso (0 = mai lampeggio)
input int    InpBatch         = 6;  // simboli controllati per secondo (rotazione)
input int    InpGridBars      = 1000; // barre CHIUSE lette per cella (minimo 400)
input bool   InpClickCambiaTF = true; // clic su cella: il grafico passa anche a quel TF (false = resta sul TF attuale)
input bool   InpDiagnosi      = false; // DIAGNOSI: tooltip completi + righe nel Journal
//--- OPERAZIONE (ingresso/stop/target + size) ---
input bool   InpShowTrade = true;  // mostra operazione (grafico + pannello dx)
input double InpRiskPct   = 1.0;   // Rischio per operazione, in % del conto
input double InpTP1_R     = 1.0;   // TARGET 1 in R
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

#define SW_COL_UNSET ((color)0xFF000000)   // colore "mai impostato" per le cache (non e' un colore valido)
#define SW_TRUST_BARS 300                  // barre dall'inizio della finestra prima di fidarsi di un'inversione per il setup

string   P = "SW41_";      // prefisso oggetti (diverso dalla v4.00 "SWD_": possono convivere)

//--- simboli
string   gSyms[];
int      gNsym = 0;
bool     gSymOk[];
uint     gSymRetryMs[];

//--- tasti / stato
bool     gHA     = false;
bool     gHidden = false;
bool     gShowLevels = false;
bool     gShowST     = true;
bool     gInitOk = false;
int      gHealCount = 0;

//--- celle (k = s*NTF + c) + 1 slot EXTRA (k = gNC) per il setup di un simbolo/TF fuori griglia
int      gNC = 0;
int      gCDir[];  int gCBs[];  int gCUsed[];  int gCCopy[];
datetime gCBarT[]; datetime gCFlipT[]; datetime gCKey[];
bool     gCOk[];   bool gCProv[];  string gCNd[];  datetime gCNdT[];
bool     gCSuOk[]; int gCSuDir[]; double gCSuE[]; double gCSuS[]; datetime gCSuT[]; bool gCSuMem[]; string gCSuWhy[];
string   gXSym = ""; ENUM_TIMEFRAMES gXTf = PERIOD_CURRENT;   // a chi appartiene lo slot extra
//--- cio' che e' MOSTRATO (si scrive un oggetto solo se cambia)
color    gShBg[];  int gShVis[];  string gShTxt[];  string gShTip[];
//--- confluenza per simbolo
int      gConfl[]; uint gEvMs[]; color gShBox[]; color gShSymCol[]; string gShSymTip[];
int      gIdxH4 = 5, gIdxM3 = 1;
int      gRot = 0;
int      gGridBars = 500;
int      gMinBars = 20;

//--- selezione del setup (clic su cella accesa)
string   gSelSym = "";
ENUM_TIMEFRAMES gSelTf = PERIOD_CURRENT;

//--- setup mostrato (pannello + linee)
int      gDk = -1;              // slot mostrato
string   gDSym = ""; ENUM_TIMEFRAMES gDTf = PERIOD_CURRENT; bool gDSel = false;
int      gHitState = 0, gHitBest = 0; datetime gHitStopT = 0, gHitTpT = 0; double gHitPrice = 0.0;
bool     gHitOk = false; uint gHitMs = 0;
string   gPanelSig = "", gLinesSig = "";

//--- buffer
double haO[], haH[], haL[], haC[], haCol[];
double st1[], c1[], st2[], c2[], st3[], c3[];
double ma1[], ma2[], ma3[];
double kHaO[], kHaH[], kHaL[], kHaC[];
double kAtr[];
double kUp1[], kDn1[], kDir1[], kVal1[];
double kUp2[], kDn2[], kDir2[], kVal2[];
double kUp3[], kDn3[], kDir3[], kVal3[];
double kMa1[], kMa2[], kMa3[];
int    hMa1 = INVALID_HANDLE, hMa2 = INVALID_HANDLE, hMa3 = INVALID_HANDLE;

//--- stato del calcolo sul grafico
int      gRT = 0;
int      gAnchorIdx = -1; datetime gAnchorT = 0;
bool     gMaPending = true;
datetime gCurT = 0;
datetime gChartLcT = 0; int gChartLcDir = 0; int gChartLcBs = -1;
int      gLvlR = 0, gLvlS = 0;

//--- lavoro della griglia (riusati)
double   wH[], wL[], wC[], wA[], wU[], wD[], wDir[], wV[];

//--- colori nativi del grafico (Heikin Ashi)
color    gColBull = clrLime, gColBear = clrRed, gColUp = clrLime, gColDown = clrRed, gColLine = clrLime;
bool     gColsHidden = false;

//--- contatori (diagnosi): misurano il lavoro reale
int      gChg = 0;
long     gCopyCnt = 0, gCalcCnt = 0, gRedrawCnt = 0, gFullCnt = 0;
uint     gDiagMs = 0;
long     gDiagCopy0 = 0, gDiagCalc0 = 0, gDiagRedraw0 = 0;
int      gChkOk = 0, gChkBad = 0;

int gHeaderY, gRow0Y;

//==================================================================//
//  FUNZIONI PURE: nessuna chiamata al terminale. Il collaudo        //
//  (backtest_pipeline/collaudo_superwave_v41.py) le ESTRAE da qui,   //
//  le compila come C++ e le confronta con lo specchio Python.        //
//  Se le cambi, rilancia il collaudo.                                //
//==================================================================//
//@@SW41_PURE_BEGIN
//--- Supertrend: UNICA implementazione per griglia, grafico e setup.
//    Indici 0 = barra piu' vecchia. Calcola le barre [from, n).
//    ATR = media SEMPLICE degli ultimi 'per' True Range (come iATR di MT5),
//    sommata ogni volta nello stesso ordine: lo stesso numero a qualunque
//    punto parta la serie (niente deriva di una somma che scorre).
//    dir: +1 su, -1 giu', 0 = non ancora calcolabile (i < per).
int SW_STCore(const double &h[],const double &l[],const double &c[],const int n,const int from,
              const int per,const double mult,double &atr[],double &upF[],double &dnF[],
              double &dir[],double &val[])
  {
   if(per<1) return 0;
   int st=from;
   if(st<0) st=0;
   for(int i=st;i<n;i++)
     {
      if(i<per)
        {
         atr[i]=0.0; upF[i]=0.0; dnF[i]=0.0; dir[i]=0.0; val[i]=0.0;
         continue;
        }
      double s=0.0;
      for(int k=i-per+1;k<=i;k++)
         s+=MathMax(h[k],c[k-1])-MathMin(l[k],c[k-1]);
      double a=s/per;
      atr[i]=a;
      double mid=(h[i]+l[i])/2.0;
      double ub=mid+mult*a;
      double lb=mid-mult*a;
      if(i==per)
        {
         upF[i]=ub;
         dnF[i]=lb;
         dir[i]=(c[i]>=mid) ? 1.0 : -1.0;
        }
      else
        {
         upF[i]=(ub<upF[i-1] || c[i-1]>upF[i-1]) ? ub : upF[i-1];
         dnF[i]=(lb>dnF[i-1] || c[i-1]<dnF[i-1]) ? lb : dnF[i-1];
         if(c[i]>upF[i-1])
            dir[i]=1.0;
         else
            if(c[i]<dnF[i-1])
               dir[i]=-1.0;
            else
               dir[i]=dir[i-1];
        }
      val[i]=(dir[i]>0.0) ? dnF[i] : upF[i];
     }
   return n;
  }
//--- barre dall'ultima inversione fino a 'last' (0 = inversione proprio su 'last').
//    Si confrontano solo le barre i > first (la barra 'first' e' il seme del calcolo).
//    -1 = nessuna inversione nel tratto.
int SW_BarsSinceFlip(const double &dir[],const int last,const int first)
  {
   if(last<=first) return -1;
   for(int i=last;i>first;i--)
      if(dir[i]!=dir[i-1])
         return last-i;
   return -1;
  }
//--- indice della barra dell'ultima inversione, -1 se non c'e'
int SW_LastFlip(const double &dir[],const int last,const int first)
  {
   int bs=SW_BarsSinceFlip(dir,last,first);
   if(bs<0) return -1;
   return last-bs;
  }
//--- cella della griglia accesa (stessa regola della v4.00: inversione entro flipBars barre chiuse)
bool SW_CellLit(const int d,const int bs,const int flipBars)
  {
   return (d!=0 && bs>=0 && bs<flipBars);
  }
//--- confluenza del simbolo: +1 BUY, -1 SELL, 0 niente
//    mode 0 = v4.00 (stessa direzione H4/M3, qualunque eta')
//    mode 1 = inversione M3 entro flipM3 barre, nel verso dell'H4, H4 senza inversioni
//             nelle ultime stableH4 barre (0 = non richiesto)
int SW_Confl(const int mode,const int dH4,const int bsH4,const int dM3,const int bsM3,
             const int flipM3,const int stableH4)
  {
   if(dH4==0 || dM3==0) return 0;
   if(mode==0)
      return (dH4==dM3) ? dH4 : 0;
   if(bsM3<0 || bsM3>=flipM3) return 0;
   if(dM3!=dH4) return 0;
   if(stableH4>0 && bsH4>=0 && bsH4<stableH4) return 0;
   return dH4;
  }
//--- fase del riquadro del simbolo: 0 spento, 1 pieno fisso, 2 lampeggio pieno, 3 lampeggio attenuato
int SW_BoxPhase(const int confl,const bool blink,const int blinkSec,const uint nowMs,const uint evMs)
  {
   if(confl==0) return 0;
   if(!blink || blinkSec<=0) return 1;
   uint el=nowMs-evMs;                      // uint: giusto anche quando il contatore riparte da 0
   if(el>=(uint)blinkSec*1000) return 1;
   return ((el/1000)%2==0) ? 2 : 3;
  }
//--- colore 'c' sfumato verso 'toward' (f=0 pieno, f=1 = toward)
color SW_Dim(const color c,const color toward,const double f)
  {
   int r=(int)(c&0xFF), g=(int)((c>>8)&0xFF), b=(int)((c>>16)&0xFF);
   int r2=(int)(toward&0xFF), g2=(int)((toward>>8)&0xFF), b2=(int)((toward>>16)&0xFF);
   int R=(int)(r+(r2-r)*f), G=(int)(g+(g2-g)*f), B=(int)(b+(b2-b)*f);
   return (color)((B<<16)|(G<<8)|R);
  }
//--- lotto al passo del simbolo, per DIFETTO, con tolleranza di 1e-7 passi
//    (0.3/0.01 = 29.999999999999996 deve dare 30 passi, non 29).
//    flag: 0 ok, 1 sotto il minimo (-> 0), 2 tagliato al massimo
double SW_NormLots(const double v,const double step,const double vmin,const double vmax,int &flag)
  {
   flag=0;
   double st=(step>0.0) ? step : 0.01;
   if(v<=0.0)
     {
      flag=1;
      return 0.0;
     }
   int dg=0;
   double t=st;
   while(dg<8 && MathAbs(t-MathRound(t))>1e-9)
     {
      t*=10.0;
      dg++;
     }
   double k=MathFloor(v/st+1e-7);
   double lot=NormalizeDouble(k*st,dg);
   if(vmax>0.0 && lot>vmax)
     {
      k=MathFloor(vmax/st+1e-7);
      lot=NormalizeDouble(k*st,dg);
      flag=2;
     }
   if(lot<=0.0 || lot<vmin)
     {
      flag=1;
      return 0.0;
     }
   return lot;
  }
//--- setup valido: stop dal lato giusto dell'ingresso
bool SW_SetupOk(const int d,const double entry,const double stop)
  {
   if(d>0) return (stop>0.0 && stop<entry);
   if(d<0) return (stop>entry);
   return false;
  }
//--- primo indice (>= from) in cui il prezzo TOCCA stop / TP1 / TP2 / TP3 (-1 = mai)
void SW_Hits(const double &h[],const double &l[],const int from,const int n,const int d,
             const double stop,const double tp1,const double tp2,const double tp3,
             int &iStop,int &i1,int &i2,int &i3)
  {
   iStop=-1; i1=-1; i2=-1; i3=-1;
   for(int i=from;i<n;i++)
     {
      if(d>0)
        {
         if(iStop<0 && l[i]<=stop) iStop=i;
         if(i1<0 && h[i]>=tp1) i1=i;
         if(i2<0 && h[i]>=tp2) i2=i;
         if(i3<0 && h[i]>=tp3) i3=i;
        }
      else
        {
         if(iStop<0 && h[i]>=stop) iStop=i;
         if(i1<0 && l[i]<=tp1) i1=i;
         if(i2<0 && l[i]<=tp2) i2=i;
         if(i3<0 && l[i]<=tp3) i3=i;
        }
     }
  }
//--- stato del setup dagli indici dei tocchi.
//    best = TP piu' alto toccato in una barra PRIMA di quella dello stop.
//    0 aperto, 1..3 TPk raggiunto (stop mai toccato), 4 INVALIDATO (stop prima di ogni TP),
//    5 TP 'best' poi stop, 6 stop e TP nella STESSA barra senza TP prima (ordine ignoto)
int SW_SetupState(const int iStop,const int i1,const int i2,const int i3,int &best)
  {
   best=0;
   if(i1>=0 && (iStop<0 || i1<iStop)) best=1;
   if(i2>=0 && (iStop<0 || i2<iStop)) best=2;
   if(i3>=0 && (iStop<0 || i3<iStop)) best=3;
   if(iStop<0) return best;
   if(best>0) return 5;
   if(i1==iStop || i2==iStop || i3==iStop) return 6;
   return 4;
  }
//--- prima di CopyRates: 0 = barra chiusa invariata (niente da fare),
//    1 = dati non pronti (si tiene lo stato), 2 = da calcolare
int SW_GatePre(const long tl,const long key,const bool ok)
  {
   if(tl<=0) return 1;
   if(ok && key==tl) return 0;
   return 2;
  }
//--- dopo CopyRates: 1 = non pronti (si tiene lo stato), 2 = calcolo definitivo,
//    3 = calcolo PROVVISORIO (serie non sincronizzata ma finestra piena: si rifa' al giro dopo)
int SW_GatePost(const int got,const int minBars,const int want,const bool synced,const long lastT,const long tl)
  {
   if(got<minBars) return 1;
   if(lastT!=tl) return 1;
   if(!synced) return (got>=want) ? 3 : 1;
   return 2;
  }
//@@SW41_PURE_END

//+------------------------------------------------------------------+
//| GlobalVariable                                                   |
//+------------------------------------------------------------------+
string GvKey(const string what)
  {
   return "SW41_" + IntegerToString(ChartID()) + "_" + what;
  }
void GvSave(const string what,const double v)
  {
   if(GlobalVariableSet(GvKey(what),v)==0)
      Print("[SuperWave 4.1] GlobalVariableSet fallita (",what,"), errore ",GetLastError(),
            ": lo stato non sopravvivera' al cambio simbolo/TF.");
  }
bool GvBool(const string what,const bool def)
  {
   string k=GvKey(what);
   if(!GlobalVariableCheck(k)) return def;
   return (GlobalVariableGet(k)>0.5);
  }
//--- tasto con un input di partenza: vale la GV solo se l'input non e' cambiato dal dialogo
bool GvToggle(const string what,const bool inp)
  {
   string ki=GvKey(what+"IN");
   if(GlobalVariableCheck(ki) && ((GlobalVariableGet(ki)>0.5)==inp))
      return GvBool(what,inp);
   GvSave(what+"IN",inp ? 1.0 : 0.0);
   GvSave(what,inp ? 1.0 : 0.0);
   return inp;
  }
string SelPrefix()
  {
   return GvKey("SEL_");
  }
void SelSave()
  {
   GlobalVariablesDeleteAll(SelPrefix());
   if(gSelSym=="") return;
   string k=SelPrefix()+gSelSym+"_"+IntegerToString(PeriodSeconds(gSelTf)/60);
   if(GlobalVariableSet(k,1.0)==0)
      Print("[SuperWave 4.1] selezione non salvata (nome GV troppo lungo?): ",k);
  }
void SelLoad()
  {
   gSelSym=""; gSelTf=PERIOD_CURRENT;
   string pre=SelPrefix();
   int tot=GlobalVariablesTotal();
   for(int i=0;i<tot;i++)
     {
      string nm=GlobalVariableName(i);
      if(StringFind(nm,pre)!=0) continue;
      string body=StringSubstr(nm,StringLen(pre));
      int us=-1;
      for(int j=StringLen(body)-1;j>=0;j--)
         if(StringGetCharacter(body,j)=='_') { us=j; break; }
      if(us<=0) continue;
      int mins=(int)StringToInteger(StringSubstr(body,us+1));
      for(int c=0;c<NTF;c++)
         if(PeriodSeconds(TFS[c])/60==mins)
           {
            gSelSym=StringSubstr(body,0,us);
            gSelTf=TFS[c];
           }
      break;
     }
  }
void GvClear()
  {
   GlobalVariablesDeleteAll(GvKey(""));
  }
//--- setup per simbolo+TF (solo come memoria per un'inversione piu' vecchia della finestra)
string SuKey(const string sym,const ENUM_TIMEFRAMES tf,const string w)
  {
   return "SW41S_" + sym + "_" + IntegerToString(PeriodSeconds(tf)/60) + "_" + w;
  }
void SetupSave(const string sym,const ENUM_TIMEFRAMES tf,const int d,const double e,const double s,const datetime t)
  {
   string kt=SuKey(sym,tf,"T");
   if(GlobalVariableCheck(kt) && (datetime)(long)GlobalVariableGet(kt)==t) return;   // gia' salvato
   GlobalVariableSet(SuKey(sym,tf,"E"),e);
   GlobalVariableSet(SuKey(sym,tf,"S"),s);
   GlobalVariableSet(SuKey(sym,tf,"D"),(double)d);
   GlobalVariableSet(kt,(double)(long)t);
  }
bool SetupLoad(const int k,const string sym,const ENUM_TIMEFRAMES tf,const datetime firstT)
  {
   string kt=SuKey(sym,tf,"T");
   if(!GlobalVariableCheck(kt)) return false;
   datetime t=(datetime)(long)GlobalVariableGet(kt);
   if(t<=0 || t>=firstT) return false;      // vale solo per un'inversione PRIMA della finestra letta
   int d=(int)GlobalVariableGet(SuKey(sym,tf,"D"));
   double e=GlobalVariableGet(SuKey(sym,tf,"E"));
   double s=GlobalVariableGet(SuKey(sym,tf,"S"));
   if(!SW_SetupOk(d,e,s)) return false;
   gCSuOk[k]=true; gCSuDir[k]=d; gCSuE[k]=e; gCSuS[k]=s; gCSuT[k]=t; gCSuMem[k]=true;
   return true;
  }

//+------------------------------------------------------------------+
//| Colori del grafico: nascondi (HA) / ripristina                    |
//| (tecnica di ABTG_Segnali_EMA_BB_ST.mq5, classi 963/971)           |
//+------------------------------------------------------------------+
color ColOrDefault(const long v,const color def)
  {
   color c=(color)v;
   if(c==clrNONE) return def;   // clrNONE = residuo di un'istanza morta: non si "ripristina" l'invisibile
   return c;
  }
void ColsHide()
  {
   if(gColsHidden) return;
   gColBull=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BULL),clrLime);
   gColBear=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CANDLE_BEAR),clrRed);
   gColUp  =ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_UP),clrLime);
   gColDown=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_DOWN),clrRed);
   gColLine=ColOrDefault(ChartGetInteger(0,CHART_COLOR_CHART_LINE),clrLime);
   gColsHidden=true;            // da qui OGNI uscita ripristina
   bool ok=true;
   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_UP,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrNONE) && ok;
   ok=ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrNONE) && ok;
   if(!ok)
      Print("[SuperWave 4.1] impossibile nascondere le candele native (errore ",GetLastError(),").");
  }
void ColsRestore()
  {
   if(!gColsHidden) return;
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,gColBull);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,gColBear);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,gColUp);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,gColDown);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,gColLine);
   gColsHidden=false;
  }
bool IsNone(const ENUM_CHART_PROPERTY_INTEGER prop)
  {
   return ((color)ChartGetInteger(0,prop)==clrNONE);
  }
//--- CANDELE ma native invisibili su TUTTE e cinque le proprieta' = residuo di un HA chiuso male
void RepairInvisibleNative()
  {
   if(!(IsNone(CHART_COLOR_CANDLE_BULL) && IsNone(CHART_COLOR_CANDLE_BEAR) &&
        IsNone(CHART_COLOR_CHART_UP) && IsNone(CHART_COLOR_CHART_DOWN) &&
        IsNone(CHART_COLOR_CHART_LINE)))
      return;
   ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrLime);
   ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLime);
   ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrRed);
   ChartSetInteger(0,CHART_COLOR_CHART_LINE,clrLime);
   Print("[SuperWave 4.1] candele native trovate INVISIBILI (residuo di Heikin Ashi chiuso male): ",
         "rimesse visibili verde/rosso (F8 > Colori per i tuoi).");
  }

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
   SetIndexBuffer(14,kHaO, INDICATOR_CALCULATIONS);
   SetIndexBuffer(15,kHaH, INDICATOR_CALCULATIONS);
   SetIndexBuffer(16,kHaL, INDICATOR_CALCULATIONS);
   SetIndexBuffer(17,kHaC, INDICATOR_CALCULATIONS);
   SetIndexBuffer(18,kAtr, INDICATOR_CALCULATIONS);
   SetIndexBuffer(19,kUp1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(20,kDn1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(21,kDir1,INDICATOR_CALCULATIONS);
   SetIndexBuffer(22,kVal1,INDICATOR_CALCULATIONS);
   SetIndexBuffer(23,kUp2, INDICATOR_CALCULATIONS);
   SetIndexBuffer(24,kDn2, INDICATOR_CALCULATIONS);
   SetIndexBuffer(25,kDir2,INDICATOR_CALCULATIONS);
   SetIndexBuffer(26,kVal2,INDICATOR_CALCULATIONS);
   SetIndexBuffer(27,kUp3, INDICATOR_CALCULATIONS);
   SetIndexBuffer(28,kDn3, INDICATOR_CALCULATIONS);
   SetIndexBuffer(29,kDir3,INDICATOR_CALCULATIONS);
   SetIndexBuffer(30,kVal3,INDICATOR_CALCULATIONS);
   SetIndexBuffer(31,kMa1, INDICATOR_CALCULATIONS);
   SetIndexBuffer(32,kMa2, INDICATOR_CALCULATIONS);
   SetIndexBuffer(33,kMa3, INDICATOR_CALCULATIONS);
   PlotIndexSetDouble(0, PLOT_EMPTY_VALUE, 0.0);
   for(int p=1;p<7;p++) PlotIndexSetDouble(p, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   if(InpAtrPeriod<1)
     {
      Print("[SuperWave 4.1] InpAtrPeriod deve essere almeno 1.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   gGridBars=InpGridBars;
   if(gGridBars<SW_TRUST_BARS+100)
     {
      Print("[SuperWave 4.1] InpGridBars=",InpGridBars," sotto il minimo: uso ",SW_TRUST_BARS+100,
            " (la finestra deve contenere l'aggancio dello stato piu' un tratto affidabile).");
      gGridBars=SW_TRUST_BARS+100;
     }
   if(gGridBars>5000) gGridBars=5000;
   int mx=InpFlipBars;
   if(InpConflFlipBars>mx) mx=InpConflFlipBars;
   if(InpConflH4Stable>mx) mx=InpConflH4Stable;
   gMinBars=InpAtrPeriod+3+mx;

   hMa1=iMA(_Symbol,_Period,InpMA1,0,InpMAmethod,PRICE_CLOSE);
   hMa2=iMA(_Symbol,_Period,InpMA2,0,InpMAmethod,PRICE_CLOSE);
   hMa3=iMA(_Symbol,_Period,InpMA3,0,InpMAmethod,PRICE_CLOSE);
   if(hMa1==INVALID_HANDLE || hMa2==INVALID_HANDLE || hMa3==INVALID_HANDLE)
      Print("[SuperWave 4.1] una media non e' disponibile (errore ",GetLastError(),"): quella linea restera' vuota.");
   IndicatorSetString(INDICATOR_SHORTNAME,"SuperWave 4.1");
   IndicatorSetInteger(INDICATOR_DIGITS,_Digits);

   //--- stato dei tasti e selezione: sopravvivono al cambio simbolo/TF
   gHA         = GvBool("HA",false);
   gHidden     = GvBool("HIDE",false);
   gShowLevels = GvToggle("LIV",InpShowLevels);
   gShowST     = GvToggle("ST",InpShowSTstart);
   SelLoad();

   //--- simboli: vuoti tolti, doppioni tolti (prima: riga vuota con etichetta "")
   string raw[];
   int nr=StringSplit(InpSymbols,',',raw);
   ArrayResize(gSyms,0); gNsym=0;
   for(int i=0;i<nr;i++)
     {
      string s=raw[i];
      StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      bool dup=false;
      for(int j=0;j<gNsym;j++) if(gSyms[j]==s) { dup=true; break; }
      if(dup) { Print("[SuperWave 4.1] simbolo doppio tolto: ",s); continue; }
      ArrayResize(gSyms,gNsym+1);
      gSyms[gNsym]=s;
      gNsym++;
     }
   ArrayResize(gSymOk,gNsym); ArrayResize(gSymRetryMs,gNsym);
   for(int i=0;i<gNsym;i++)
     {
      gSymOk[i]=SymbolSelect(gSyms[i],true);
      gSymRetryMs[i]=GetTickCount();
      if(!gSymOk[i]) Print("[SuperWave 4.1] simbolo non trovato su questo terminale: ",gSyms[i]," (la riga restera' n/d)");
     }
   for(int c=0;c<NTF;c++)
     {
      if(TFS[c]==PERIOD_H4) gIdxH4=c;
      if(TFS[c]==PERIOD_M3) gIdxM3=c;
     }

   gNC=gNsym*NTF;
   int nk=gNC+1;               // +1 = slot extra (setup di un simbolo/TF fuori griglia)
   ArrayResize(gCDir,nk); ArrayResize(gCBs,nk); ArrayResize(gCUsed,nk); ArrayResize(gCCopy,nk);
   ArrayResize(gCBarT,nk); ArrayResize(gCFlipT,nk); ArrayResize(gCKey,nk);
   ArrayResize(gCOk,nk); ArrayResize(gCProv,nk); ArrayResize(gCNd,nk); ArrayResize(gCNdT,nk);
   ArrayResize(gCSuOk,nk); ArrayResize(gCSuDir,nk); ArrayResize(gCSuE,nk); ArrayResize(gCSuS,nk);
   ArrayResize(gCSuT,nk); ArrayResize(gCSuMem,nk); ArrayResize(gCSuWhy,nk);
   ArrayResize(gShBg,nk); ArrayResize(gShVis,nk); ArrayResize(gShTxt,nk); ArrayResize(gShTip,nk);
   for(int k=0;k<nk;k++) ResetSlot(k);
   ArrayResize(gConfl,gNsym); ArrayResize(gEvMs,gNsym); ArrayResize(gShBox,gNsym);
   ArrayResize(gShSymCol,gNsym); ArrayResize(gShSymTip,gNsym);
   for(int s=0;s<gNsym;s++) { gConfl[s]=0; gEvMs[s]=0; }

   gHeaderY = InpY + InpCellH;
   gRow0Y   = gHeaderY + InpCellH;

   ObjectsDeleteAll(0,P);      // orfani di un'istanza morta male
   BuildPanel();
   InvalidateShown();
   if(gHidden) SetGridVisible(false);
   gInitOk=true;
   if(gHA) ColsHide();
   else    RepairInvisibleNative();
   // niente calcolo pesante qui: la griglia si riempie a rotazione dal timer (InpBatch simboli al secondo)
   if(!EventSetTimer(1))
      Print("[SuperWave 4.1] EventSetTimer fallito (errore ",GetLastError(),"): la griglia non si aggiornera'.");
   gDiagMs=GetTickCount();
   Print("[SuperWave 4.1] AVVIATO: ",gNsym," simboli, confluenza modo ",(int)InpConflMode,
         ", finestra ",gGridBars," barre, grafico ",_Symbol," ",EnumToString(_Period),
         (gSelSym!="" ? (", setup selezionato "+gSelSym+" "+TfName(gSelTf)) : ""),".");
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ColsRestore();                         // OGNI motivo di uscita: le candele native tornano
   ObjectsDeleteAll(0,P);
   if(hMa1!=INVALID_HANDLE) IndicatorRelease(hMa1);
   if(hMa2!=INVALID_HANDLE) IndicatorRelease(hMa2);
   if(hMa3!=INVALID_HANDLE) IndicatorRelease(hMa3);
   if(reason==REASON_REMOVE || reason==REASON_CHARTCLOSE)
      GvClear();                          // stato dei tasti e selezione: solo per questo grafico
   if(InpDiagnosi)
      Print("[SuperWave 4.1 diag] OnDeinit motivo=",reason," (1=rimosso, 3=cambio simbolo/TF, 5=parametri)");
   ChartRedraw(0);
  }
//+------------------------------------------------------------------+
void ResetSlot(const int k)
  {
   gCDir[k]=0; gCBs[k]=-1; gCUsed[k]=0; gCCopy[k]=0; gCBarT[k]=0; gCFlipT[k]=0; gCKey[k]=0;
   gCOk[k]=false; gCProv[k]=false; gCNd[k]=""; gCNdT[k]=0;
   gCSuOk[k]=false; gCSuDir[k]=0; gCSuE[k]=0.0; gCSuS[k]=0.0; gCSuT[k]=0; gCSuMem[k]=false; gCSuWhy[k]="";
  }
void InvalidateShown()
  {
   for(int k=0;k<ArraySize(gShBg);k++) { gShBg[k]=SW_COL_UNSET; gShVis[k]=-1; gShTxt[k]="\n"; gShTip[k]="\n"; }
   for(int s=0;s<gNsym;s++) { gShBox[s]=SW_COL_UNSET; gShSymCol[s]=SW_COL_UNSET; gShSymTip[s]="\n"; }
   gPanelSig=""; gLinesSig="";
  }
string TfName(const ENUM_TIMEFRAMES tf)
  {
   for(int c=0;c<NTF;c++) if(TFS[c]==tf) return TFNAMES[c];
   string s=EnumToString(tf);
   if(StringFind(s,"PERIOD_")==0) s=StringSubstr(s,7);
   return s;
  }
string DirTxt(const int d)
  {
   if(d>0) return "SU";
   if(d<0) return "GIU'";
   return "?";
  }
string HM(const datetime t)
  {
   if(t<=0) return "-";
   return TimeToString(t,TIME_DATE|TIME_MINUTES);
  }

//+------------------------------------------------------------------+
//| TIMER: rotazione, lampeggio, autoriparazione                      |
//+------------------------------------------------------------------+
void OnTimer()
  {
   gChg=0;
   SelfHeal();
   if(!gHidden && gNsym>0)
     {
      int n=InpBatch;
      if(n<1) n=1;
      if(n>gNsym) n=gNsym;
      for(int j=0;j<n;j++)
        {
         ProcessSymbol(gRot);
         gRot=(gRot+1)%gNsym;
        }
      UpdateBoxes();
     }
   //--- setup mostrato: il suo slot si controlla OGNI secondo (costa un iTime se la barra non e' cambiata)
   if(InpShowTrade) RefreshDisplay(false);
   if(gChg>0)
     {
      ChartRedraw(0);
      gRedrawCnt++;
     }
   if(InpDiagnosi) DiagMinute();
  }
//--- un simbolo: le sue 7 celle (si ricalcolano solo quelle con una barra chiusa nuova)
void ProcessSymbol(const int s)
  {
   if(s<0 || s>=gNsym) return;
   if(!gSymOk[s] && GetTickCount()-gSymRetryMs[s]>=60000)
     {
      gSymOk[s]=SymbolSelect(gSyms[s],true);      // ritenta una volta al minuto
      gSymRetryMs[s]=GetTickCount();
     }
   bool any=false;
   for(int c=0;c<NTF;c++)
     {
      int k=s*NTF+c;
      if(UpdateSlot(k,gSyms[s],TFS[c],gSymOk[s])) any=true;
      RenderCell(k);
     }
   if(any || gShSymTip[s]=="\n") RecalcConfl(s);
  }
//--- segna 'dati non pronti' SENZA toccare lo stato calcolato prima
bool SetNd(const int k,const string why)
  {
   if(gCNd[k]==why) return false;
   gCNd[k]=why;
   gCNdT[k]=TimeLocal();
   if(InpDiagnosi && k<gNC)
     {
      int c=k%NTF;
      if(c==gIdxH4 || c==gIdxM3)
         Print("[SuperWave 4.1 diag] ",gSyms[k/NTF]," ",TFNAMES[c]," n/d: ",why," (stato precedente mantenuto: dir ",gCDir[k],")");
     }
   return true;
  }
//--- calcolo di uno slot (cella della griglia o slot extra): CopyRates solo se la barra chiusa e' nuova
bool UpdateSlot(const int k,const string sym,const ENUM_TIMEFRAMES tf,const bool symOk)
  {
   if(!symOk) return SetNd(k,"simbolo non trovato su questo terminale (SymbolSelect fallita)");
   datetime tl=iTime(sym,tf,1);                    // ultima barra CHIUSA
   int g=SW_GatePre((long)tl,(long)gCKey[k],gCOk[k]);
   if(g==0) return false;
   if(g==1) return SetNd(k,"ultima barra chiusa non ancora disponibile (iTime=0)");
   MqlRates r[];
   ArraySetAsSeries(r,false);
   ResetLastError();
   int got=CopyRates(sym,tf,1,gGridBars,r);        // start=1: la barra in formazione e' esclusa
   gCopyCnt++;
   gCCopy[k]=got;
   bool synced=(SeriesInfoInteger(sym,tf,SERIES_SYNCHRONIZED)!=0);
   long lastT=(got>0) ? (long)r[got-1].time : 0;
   int g2=SW_GatePost(got,gMinBars,gGridBars,synced,lastT,(long)tl);
   if(g2==1)
     {
      string why;
      if(got<0) why="CopyRates fallita (errore "+IntegerToString(GetLastError())+")";
      else
         if(got<gMinBars) why="solo "+IntegerToString(got)+" barre (minimo "+IntegerToString(gMinBars)+")";
         else
            if(lastT!=(long)tl) why="dati in movimento (ultima barra copiata diversa da iTime)";
            else why="serie non sincronizzata e finestra incompleta ("+IntegerToString(got)+"/"+IntegerToString(gGridBars)+")";
      return SetNd(k,why);
     }
   if(ArraySize(wH)<got)
     {
      ArrayResize(wH,got); ArrayResize(wL,got); ArrayResize(wC,got); ArrayResize(wA,got);
      ArrayResize(wU,got); ArrayResize(wD,got); ArrayResize(wDir,got); ArrayResize(wV,got);
     }
   for(int i=0;i<got;i++) { wH[i]=r[i].high; wL[i]=r[i].low; wC[i]=r[i].close; }
   SW_STCore(wH,wL,wC,got,0,InpAtrPeriod,InpMult1,wA,wU,wD,wDir,wV);
   gCalcCnt++;
   int last=got-1;
   int first=InpAtrPeriod+1;
   int d=(int)wDir[last];
   int bs=SW_BarsSinceFlip(wDir,last,first);
   bool chg=(!gCOk[k] || d!=gCDir[k] || bs!=gCBs[k] || gCNd[k]!="" || gCProv[k]!=(g2==3));
   gCDir[k]=d; gCBs[k]=bs; gCUsed[k]=got; gCBarT[k]=r[last].time;
   gCFlipT[k]=(bs>=0) ? r[last-bs].time : 0;
   gCProv[k]=(g2==3);
   gCKey[k]=(g2==3) ? 0 : tl;                      // provvisorio: si rifa' al giro dopo
   gCOk[k]=true;
   gCNd[k]="";
   //--- setup di questo simbolo/TF: ingresso FISSO alla chiusura della barra di inversione.
   //    Ci si fida solo di un'inversione ad almeno SW_TRUST_BARS barre dall'inizio della finestra
   //    (prima lo stato della finestra puo' non aver ancora agganciato quello dello storico intero).
   int fi=SW_LastFlip(wDir,last,first);
   int trustFrom=first+SW_TRUST_BARS;
   datetime oldT=gCSuT[k];
   bool oldOk=gCSuOk[k], oldMem=gCSuMem[k];
   if(fi>=trustFrom)
     {
      gCSuDir[k]=(int)wDir[fi]; gCSuE[k]=wC[fi]; gCSuS[k]=wV[fi]; gCSuT[k]=r[fi].time; gCSuMem[k]=false;
      gCSuOk[k]=SW_SetupOk(gCSuDir[k],gCSuE[k],gCSuS[k]);
      gCSuWhy[k]=gCSuOk[k] ? "" : "stop dal lato sbagliato dell'ingresso alla barra di inversione";
      if(gCSuOk[k] && !gCProv[k] && k==gDk) SetupSave(sym,tf,gCSuDir[k],gCSuE[k],gCSuS[k],gCSuT[k]);
     }
   else
     {
      datetime tb=(trustFrom<got) ? r[trustFrom].time : r[last].time;
      if(oldOk && oldT>0 && oldT<tb)
        {
         gCSuMem[k]=oldMem;          // stesso setup gia' fissato in questa sessione: resta
        }
      else
        {
         gCSuOk[k]=false; gCSuMem[k]=false;
         if(SetupLoad(k,sym,tf,tb))  // memoria (GlobalVariable) di un'inversione piu' vecchia della zona affidabile
            gCSuWhy[k]="";
         else
            if(got<=trustFrom)
               gCSuWhy[k]="storico corto: "+IntegerToString(got)+" barre, ne servono piu' di "+IntegerToString(trustFrom);
            else
               gCSuWhy[k]="nessuna inversione nelle ultime "+IntegerToString(last-trustFrom)+" barre "+TfName(tf);
        }
     }
   if(gCSuT[k]!=oldT || gCSuOk[k]!=oldOk) chg=true;
   if(InpDiagnosi && sym==_Symbol && tf==_Period) CheckVsChart(k);
   return chg;
  }
//--- identita' griglia/grafico sul simbolo e TF del grafico (solo in diagnosi, scrive nel Journal)
void CheckVsChart(const int k)
  {
   if(gChartLcT!=gCBarT[k]) return;           // non stanno leggendo la stessa barra
   int bg=(gCBs[k]<0 || gCBs[k]>100) ? 100 : gCBs[k];
   int bc=(gChartLcBs<0 || gChartLcBs>100) ? 100 : gChartLcBs;
   if(gCDir[k]==gChartLcDir && bg==bc) { gChkOk++; return; }
   gChkBad++;
   Print("[SuperWave 4.1 diag] DIVERGENZA griglia/grafico su ",_Symbol," ",TfName(_Period)," barra ",HM(gCBarT[k]),
         ": griglia dir ",gCDir[k]," inv ",gCBs[k]," barre fa (",gCUsed[k]," barre) | grafico dir ",gChartLcDir,
         " inv ",gChartLcBs," barre fa (",gRT-1," barre). Se il grafico ha meno di ",gGridBars,
         " barre, alza 'Max barre nel grafico'.");
  }
//--- tooltip della cella
string CellTip(const int k)
  {
   int s=k/NTF, c=k%NTF;
   string t=gSyms[s]+" "+TFNAMES[c]+": ";
   if(!gCOk[k])
      return t+"n/d - "+(gCNd[k]!="" ? gCNd[k] : "in attesa del primo calcolo");
   t+="Supertrend "+DoubleToString(InpMult1,1)+" "+DirTxt(gCDir[k]);
   if(gCBs[k]>=0 && gCUsed[k]-1-gCBs[k]>=InpAtrPeriod+1+SW_TRUST_BARS)
      t+=", inversione "+IntegerToString(gCBs[k])+" barre fa ("+HM(gCFlipT[k])+")";
   else
      t+=", nessuna inversione nelle ultime "+IntegerToString((int)MathMax(0,gCUsed[k]-InpAtrPeriod-2-SW_TRUST_BARS))+" barre";
   t+="\nbarra chiusa letta: "+HM(gCBarT[k]);
   if(gCProv[k]) t+="\nPROVVISORIO: serie non ancora sincronizzata, si ricalcola";
   if(gCNd[k]!="") t+="\nn/d dalle "+TimeToString(gCNdT[k],TIME_SECONDS)+": "+gCNd[k]+" (stato precedente mantenuto)";
   if(gCSuOk[k]) t+="\nsetup "+(gCSuDir[k]>0?"BUY":"SELL")+" fissato alla barra "+HM(gCSuT[k])+": clic per selezionarlo";
   if(InpDiagnosi) t+="\n[diag] barre usate "+IntegerToString(gCUsed[k])+", CopyRates="+IntegerToString(gCCopy[k]);
   return t;
  }
//--- disegno di una cella: si tocca un oggetto solo se cambia
void RenderCell(const int k)
  {
   if(k<0 || k>=gNC) return;
   int s=k/NTF, c=k%NTF;
   string bg=P+"bg_"+IntegerToString(s)+"_"+IntegerToString(c);
   string tx=P+"cx_"+IntegerToString(s)+"_"+IntegerToString(c);
   bool lit=(gCOk[k] && SW_CellLit(gCDir[k],gCBs[k],InpFlipBars));
   color col=lit ? ((gCDir[k]>0) ? InpBuyCol : InpSellCol) : InpEmptyCol;
   if(gShBg[k]!=col)
     {
      ObjectSetInteger(0,bg,OBJPROP_BGCOLOR,col);
      gShBg[k]=col; gChg++;
     }
   if(lit)
     {
      string t=(gCDir[k]>0) ? "BUY" : "SELL";
      if(gShTxt[k]!=t)
        {
         ObjectSetString(0,tx,OBJPROP_TEXT,t);
         gShTxt[k]=t; gChg++;
        }
     }
   int vis=(lit && !gHidden) ? 1 : 0;
   if(gShVis[k]!=vis)
     {
      ObjectSetInteger(0,tx,OBJPROP_TIMEFRAMES,(vis==1) ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS);
      gShVis[k]=vis; gChg++;
     }
   string tip=CellTip(k);
   if(gShTip[k]!=tip)                          // il tooltip non richiede ridisegno
     {
      ObjectSetString(0,bg,OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,tx,OBJPROP_TOOLTIP,tip);
      gShTip[k]=tip;
     }
  }
//--- confluenza del simbolo dalle sue celle H4 e M3
void RecalcConfl(const int s)
  {
   int kH=s*NTF+gIdxH4, kM=s*NTF+gIdxM3;
   int nv=0;
   if(gCOk[kH] && gCOk[kM])
      nv=SW_Confl((int)InpConflMode,gCDir[kH],gCBs[kH],gCDir[kM],gCBs[kM],InpConflFlipBars,InpConflH4Stable);
   if(nv!=gConfl[s])
     {
      if(nv!=0) gEvMs[s]=GetTickCount();       // evento: parte il lampeggio (InpBlinkSeconds)
      if(InpDiagnosi)
         Print("[SuperWave 4.1 diag] ",gSyms[s]," confluenza ",ConflTxt(gConfl[s])," -> ",ConflTxt(nv),
               " | H4 dir ",gCDir[kH]," inv ",gCBs[kH]," barre fa, barra ",HM(gCBarT[kH]),", ",gCUsed[kH],
               " barre, CopyRates=",gCCopy[kH],(gCNd[kH]!="" ? (" n/d: "+gCNd[kH]) : ""),
               " | M3 dir ",gCDir[kM]," inv ",gCBs[kM]," barre fa, barra ",HM(gCBarT[kM]),", ",gCUsed[kM],
               " barre, CopyRates=",gCCopy[kM],(gCNd[kM]!="" ? (" n/d: "+gCNd[kM]) : ""),
               " | modo ",(int)InpConflMode," M3<",InpConflFlipBars," H4stab ",InpConflH4Stable);
      gConfl[s]=nv;
     }
   RenderSymbol(s);
  }
string ConflTxt(const int v)
  {
   if(v>0) return "BUY";
   if(v<0) return "SELL";
   return "nessuna";
  }
string RuleTxt()
  {
   if((int)InpConflMode==0)
      return "regola (modo 0): H4 e M3 nella stessa direzione";
   return "regola (modo 1): M3 invertito da meno di "+IntegerToString(InpConflFlipBars)+" barre nel verso dell'H4, "+
          (InpConflH4Stable>0 ? ("H4 senza inversioni nelle ultime "+IntegerToString(InpConflH4Stable)+" barre") : "H4 qualunque eta'");
  }
string SideTxt(const int k,const string tf)
  {
   string t=tf+" "+DirTxt(gCDir[k]);
   if(!gCOk[k]) return tf+" n/d";
   if(gCBs[k]>=0) t+=" (inv. "+IntegerToString(gCBs[k])+" barre fa)";
   else t+=" (nessuna inv. in finestra)";
   if(InpDiagnosi) t+=" barra "+HM(gCBarT[k])+", "+IntegerToString(gCUsed[k])+" barre, CopyRates="+IntegerToString(gCCopy[k]);
   if(gCNd[k]!="") t+=" [n/d: "+gCNd[k]+"]";
   return t;
  }
void RenderSymbol(const int s)
  {
   int kH=s*NTF+gIdxH4, kM=s*NTF+gIdxM3;
   color tc=(gConfl[s]!=0) ? clrWhite : InpTextCol;
   if(gShSymCol[s]!=tc)
     {
      ObjectSetInteger(0,P+"s_"+IntegerToString(s),OBJPROP_COLOR,tc);
      gShSymCol[s]=tc; gChg++;
     }
   string tip=gSyms[s]+" confluenza: "+ConflTxt(gConfl[s])+"\n"+SideTxt(kH,"H4")+"\n"+SideTxt(kM,"M3")+"\n"+RuleTxt();
   if(gShSymTip[s]!=tip)
     {
      ObjectSetString(0,P+"s_"+IntegerToString(s),OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,P+"sb_"+IntegerToString(s),OBJPROP_TOOLTIP,tip);
      gShSymTip[s]=tip;
     }
  }
//--- riquadri dei simboli: lampeggio solo per InpBlinkSeconds dall'evento, poi fisso
void UpdateBoxes()
  {
   uint now=GetTickCount();
   for(int s=0;s<gNsym;s++)
     {
      int ph=SW_BoxPhase(gConfl[s],InpBlink,InpBlinkSeconds,now,gEvMs[s]);
      color full=(gConfl[s]>0) ? InpBuyCol : InpSellCol;
      color col=InpEmptyCol;
      if(ph==1 || ph==2) col=full;
      if(ph==3) col=SW_Dim(full,InpPanelCol,0.55);     // fase attenuata, mai nero (dalla versione del repo)
      if(gShBox[s]!=col)
        {
         ObjectSetInteger(0,P+"sb_"+IntegerToString(s),OBJPROP_BGCOLOR,col);
         gShBox[s]=col; gChg++;
        }
     }
  }
//--- autoriparazione: oggetti cancellati dall'OnDeinit di un'istanza precedente (cambio TF), candele HA
void SelfHeal()
  {
   if(!gInitOk) return;
   if(ObjectFind(0,P+"btnHA")<0 || ObjectFind(0,P+"btnHide")<0 || ObjectFind(0,P+"panel")<0)
     {
      BuildPanel();
      InvalidateShown();
      if(gHidden) SetGridVisible(false);
      for(int k=0;k<gNC;k++) RenderCell(k);
      for(int s=0;s<gNsym;s++) RenderSymbol(s);
      gChg++;
     }
   if(gHA && gHealCount<3 &&
      !(IsNone(CHART_COLOR_CANDLE_BULL) && IsNone(CHART_COLOR_CANDLE_BEAR) &&
        IsNone(CHART_COLOR_CHART_UP) && IsNone(CHART_COLOR_CHART_DOWN)))
     {
      gHealCount++;
      gColsHidden=false;                          // si ricatturano i colori ATTUALI e si rinascondono
      ColsHide();
      if(gHealCount>=3)
         Print("[SuperWave 4.1] le candele native continuano a riapparire in Heikin Ashi: smetto di nasconderle.");
      gChg++;
     }
  }
//--- diagnosi: lavoro reale dell'ultimo minuto
void DiagMinute()
  {
   uint now=GetTickCount();
   if(now-gDiagMs<60000) return;
   int obj=0, tot=ObjectsTotal(0,-1,-1);
   for(int i=0;i<tot;i++) if(StringFind(ObjectName(0,i,-1,-1),P)==0) obj++;
   Print("[SuperWave 4.1 diag] ultimo minuto: CopyRates griglia ",gCopyCnt-gDiagCopy0,
         ", celle ricalcolate ",gCalcCnt-gDiagCalc0,", ridisegni ",gRedrawCnt-gDiagRedraw0,
         ", oggetti ",obj,", ricalcoli completi grafico ",gFullCnt,
         ", confronti griglia/grafico ok ",gChkOk," divergenti ",gChkBad);
   gDiagMs=now; gDiagCopy0=gCopyCnt; gDiagCalc0=gCalcCnt; gDiagRedraw0=gRedrawCnt;
  }

//+------------------------------------------------------------------+
//| GRAFICO                                                          |
//+------------------------------------------------------------------+
bool CopyMa(const int h,double &dst[],const int rt,const int cnt)
  {
   if(h==INVALID_HANDLE || cnt<=0) return false;
   if(BarsCalculated(h)<rt) return false;
   double m[];
   ArraySetAsSeries(m,false);
   int got=CopyBuffer(h,0,0,cnt,m);
   if(got!=cnt) return false;
   int off=rt-cnt;
   for(int j=0;j<cnt;j++) dst[off+j]=m[j];
   return true;
  }
//--- buffer mostrati dai buffer di calcolo, secondo i tasti (niente ricalcolo)
void FillDisplay(const int from,const int to)
  {
   int n=to;
   if(n>ArraySize(st1)) n=ArraySize(st1);
   int i0=(from<0) ? 0 : from;
   for(int i=i0;i<n;i++)
     {
      if(gHA)
        {
         haO[i]=kHaO[i]; haH[i]=kHaH[i]; haL[i]=kHaL[i]; haC[i]=kHaC[i];
         haCol[i]=(kHaC[i]>=kHaO[i]) ? 0.0 : 1.0;
        }
      else
        {
         haO[i]=0.0; haH[i]=0.0; haL[i]=0.0; haC[i]=0.0; haCol[i]=0.0;
        }
      st1[i]=(gShowST && kDir1[i]!=0.0) ? kVal1[i] : EMPTY_VALUE;
      c1[i] =(kDir1[i]>0.0) ? 0.0 : 1.0;
      st2[i]=(gShowST && InpShowST2 && kDir2[i]!=0.0) ? kVal2[i] : EMPTY_VALUE;
      c2[i] =(kDir2[i]>0.0) ? 0.0 : 1.0;
      st3[i]=(gShowST && InpShowST3 && kDir3[i]!=0.0) ? kVal3[i] : EMPTY_VALUE;
      c3[i] =(kDir3[i]>0.0) ? 0.0 : 1.0;
      ma1[i]=gShowST ? kMa1[i] : EMPTY_VALUE;
      ma2[i]=gShowST ? kMa2[i] : EMPTY_VALUE;
      ma3[i]=gShowST ? kMa3[i] : EMPTY_VALUE;
     }
  }
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],
                const double &open[],const double &high[],const double &low[],
                const double &close[],const long &tick_volume[],const long &volume[],
                const int &spread[])
  {
   if(rates_total<InpAtrPeriod+5) return(0);
   ArraySetAsSeries(time,false);
   ArraySetAsSeries(open,false);
   ArraySetAsSeries(high,false);
   ArraySetAsSeries(low,false);
   ArraySetAsSeries(close,false);

   //--- ricalcolo completo se il terminale lo chiede o se lo storico si e' spostato (ancora sull'ora, classe 965)
   bool full=(prev_calculated<=0 || prev_calculated>rates_total || gAnchorIdx<0);
   if(!full && (gAnchorIdx>=rates_total || time[gAnchorIdx]!=gAnchorT)) full=true;
   int start=full ? 0 : prev_calculated-1;
   if(start<0) start=0;
   if(full)
     {
      gFullCnt++;
      gMaPending=true;
      for(int i=0;i<rates_total;i++) { kMa1[i]=EMPTY_VALUE; kMa2[i]=EMPTY_VALUE; kMa3[i]=EMPTY_VALUE; }
      if(InpDiagnosi) Print("[SuperWave 4.1 diag] ricalcolo completo del grafico (",rates_total," barre)");
     }

   //--- Heikin Ashi interno (sempre calcolato, mostrato solo col tasto HA)
   for(int i=start;i<rates_total;i++)
     {
      double hc=(open[i]+high[i]+low[i]+close[i])/4.0;
      double ho=(i==0) ? open[0] : (kHaO[i-1]+kHaC[i-1])/2.0;
      kHaO[i]=ho; kHaC[i]=hc;
      kHaH[i]=(i==0) ? high[0] : MathMax(high[i],MathMax(ho,hc));
      kHaL[i]=(i==0) ? low[0]  : MathMin(low[i],MathMin(ho,hc));
     }
   //--- Supertrend: STESSA funzione della griglia (SW_STCore)
   SW_STCore(high,low,close,rates_total,start,InpAtrPeriod,InpMult1,kAtr,kUp1,kDn1,kDir1,kVal1);
   SW_STCore(high,low,close,rates_total,start,InpAtrPeriod,InpMult2,kAtr,kUp2,kDn2,kDir2,kVal2);
   SW_STCore(high,low,close,rates_total,start,InpAtrPeriod,InpMult3,kAtr,kUp3,kDn3,kDir3,kVal3);
   //--- medie (handle di MT5): solo la coda, tutto se in sospeso
   int cnt=gMaPending ? rates_total : rates_total-start;
   bool okMa=CopyMa(hMa1,kMa1,rates_total,cnt);
   okMa=CopyMa(hMa2,kMa2,rates_total,cnt) && okMa;
   okMa=CopyMa(hMa3,kMa3,rates_total,cnt) && okMa;
   int dispFrom=start;
   if(okMa && gMaPending) dispFrom=0;
   gMaPending=!okMa;
   FillDisplay(dispFrom,rates_total);

   gRT=rates_total;
   gCurT=time[rates_total-1];
   gAnchorIdx=rates_total-1;
   gAnchorT=time[rates_total-1];
   int lc=rates_total-2;
   gChartLcT=time[lc];
   gChartLcDir=(int)kDir1[lc];
   gChartLcBs=SW_BarsSinceFlip(kDir1,lc,InpAtrPeriod+1);

   if(InpShowTrade) RefreshDisplay(false);
   else DeleteTrade();
   if(gShowLevels) DrawLevelsArr(rates_total,time,high,low,close);
   else DeleteLevels();
   return(rates_total);
  }

//+------------------------------------------------------------------+
//| SETUP mostrato: selezionato dalla griglia, oppure TF del grafico  |
//+------------------------------------------------------------------+
int FindCell(const string sym,const ENUM_TIMEFRAMES tf)
  {
   for(int s=0;s<gNsym;s++)
      if(gSyms[s]==sym)
         for(int c=0;c<NTF;c++)
            if(TFS[c]==tf) return s*NTF+c;
   return -1;
  }
//--- sceglie lo slot, lo aggiorna (iTime; CopyRates solo a barra nuova), aggiorna i tocchi e ridisegna se serve
void RefreshDisplay(const bool force)
  {
   if(gRT<=0) return;                            // prima del primo OnCalculate non c'e' ancora l'ora della barra
   bool sel=(gSelSym!="" && gSelSym==_Symbol);
   ENUM_TIMEFRAMES tf=sel ? gSelTf : _Period;
   int k=FindCell(_Symbol,tf);
   if(k<0)
     {
      k=gNC;
      if(gXSym!=_Symbol || gXTf!=tf) { ResetSlot(k); gXSym=_Symbol; gXTf=tf; }
     }
   bool chgSlot=(k!=gDk || tf!=gDTf || sel!=gDSel || gDSym!=_Symbol);
   gDk=k; gDTf=tf; gDSel=sel; gDSym=_Symbol;
   bool symOk=true;
   if(k<gNC) symOk=gSymOk[k/NTF];
   bool chg=UpdateSlot(k,_Symbol,tf,symOk);
   if(chg && k<gNC) { RenderCell(k); RecalcConfl(k/NTF); }
   //--- tocchi di stop/TP dalla barra di inversione in poi: al massimo una volta al secondo
   uint now=GetTickCount();
   if(force || chg || chgSlot || now-gHitMs>=1000)
     {
      gHitMs=now;
      ComputeHits(k,tf);
     }
   DrawTrade();
  }
double TpPrice(const int d,const double e,const double risk,const double rr)
  {
   return (d>0) ? e+rr*risk : e-rr*risk;
  }
void ComputeHits(const int k,const ENUM_TIMEFRAMES tf)
  {
   gHitOk=false; gHitState=0; gHitBest=0; gHitStopT=0; gHitTpT=0; gHitPrice=0.0;
   if(!gCSuOk[k]) return;
   int sh=iBarShift(_Symbol,tf,gCSuT[k],true);
   if(sh<0) return;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(_Symbol,tf,0,sh+1,r);
   if(got!=sh+1 || got<1 || r[0].time!=gCSuT[k]) return;
   double hh[], ll[];
   ArrayResize(hh,got); ArrayResize(ll,got);
   for(int i=0;i<got;i++) { hh[i]=r[i].high; ll[i]=r[i].low; }
   int d=gCSuDir[k];
   double e=gCSuE[k], risk=MathAbs(gCSuE[k]-gCSuS[k]);
   int iS,i1,i2,i3;
   SW_Hits(hh,ll,1,got,d,gCSuS[k],TpPrice(d,e,risk,InpTP1_R),TpPrice(d,e,risk,InpTP2_R),
           TpPrice(d,e,risk,InpTP3_R),iS,i1,i2,i3);
   gHitState=SW_SetupState(iS,i1,i2,i3,gHitBest);
   if(iS>=0) gHitStopT=r[iS].time;
   if(gHitBest==1) gHitTpT=r[i1].time;
   if(gHitBest==2) gHitTpT=r[i2].time;
   if(gHitBest==3) gHitTpT=r[i3].time;
   gHitPrice=r[got-1].close;
   gHitOk=true;
  }
string StateTxt()
  {
   if(!gHitOk) return "stato: tocchi n/d (storico dalla barra di inversione non pronto)";
   string tp=(gHitBest>0) ? ("TP"+IntegerToString(gHitBest)) : "";
   if(gHitState==0) return "stato: APERTO, nessun TP ne' stop toccato";
   if(gHitState>=1 && gHitState<=3) return "stato: "+tp+" raggiunto "+HM(gHitTpT)+", stop mai toccato";
   if(gHitState==4) return "stato: INVALIDATO, stop toccato "+HM(gHitStopT);
   if(gHitState==5) return "stato: "+tp+" "+HM(gHitTpT)+", poi stop "+HM(gHitStopT);
   return "stato: stop e TP nella stessa barra "+HM(gHitStopT)+" (ordine non noto)";
  }
void DeleteTrade()
  {
   if(gPanelSig=="" && gLinesSig=="") return;  // gia' tolto
   ObjectsDeleteAll(0,P+"op_");
   ObjectsDeleteAll(0,P+"q_");
   gPanelSig=""; gLinesSig="";
  }
//--- linee e pannello del setup mostrato (si riscrive solo cio' che cambia)
void DrawTrade()
  {
   string pre=P+"op_";
   if(!InpShowTrade) { DeleteTrade(); return; }
   int k=gDk;
   if(k<0) return;
   if(!gCSuOk[k])
     {
      if(gLinesSig!="none") { ObjectsDeleteAll(0,pre); gLinesSig="none"; gChg++; }
      string why;
      string det=(gCNd[k]!="") ? gCNd[k] : ((gCSuWhy[k]!="") ? gCSuWhy[k] : "in attesa del primo calcolo");
      if(gDSel) why="setup "+TfName(gDTf)+" non disponibile: "+det;
      else      why="nessun setup selezionato (TF del grafico "+TfName(gDTf)+": "+det+")";
      DrawWaitPanel(why);
      return;
     }
   int d=gCSuDir[k];
   double entry=gCSuE[k], stop=gCSuS[k];
   double risk=MathAbs(entry-stop);
   double tp1=TpPrice(d,entry,risk,InpTP1_R);
   double tp2=TpPrice(d,entry,risk,InpTP2_R);
   double tp3=TpPrice(d,entry,risk,InpTP3_R);
   int dg=_Digits;
   color ecol=(d>0) ? InpBuyCol : InpSellCol;
   string etxt=(d>0) ? "BUY" : "SELL";
   string lsig=DoubleToString(entry,dg)+"|"+DoubleToString(stop,dg)+"|"+IntegerToString(d)+"|"+
               IntegerToString((long)gCurT)+"|"+IntegerToString((long)gCSuT[k])+"|"+TfName(gDTf);
   if(lsig!=gLinesSig)
     {
      datetime tnow=gCurT;
      HLine(pre+"entry",entry,ecol,STYLE_SOLID);
      HLine(pre+"sl",   stop, InpStopCol,STYLE_DASH);
      HLine(pre+"tp1",  tp1,  InpTargetCol,STYLE_DOT);
      HLine(pre+"tp2",  tp2,  InpTargetCol,STYLE_DOT);
      HLine(pre+"tp3",  tp3,  InpTargetCol,STYLE_DASH);
      Txt(pre+"entryT",tnow,entry,etxt+" "+TfName(gDTf)+"  "+DoubleToString(entry,dg)+" (ingresso fisso)",ecol);
      Txt(pre+"slT",   tnow,stop, "STOP  "+DoubleToString(stop,dg),  InpStopCol);
      Txt(pre+"tp1T",  tnow,tp1,  "TP1  "+DoubleToString(tp1,dg),    InpTargetCol);
      Txt(pre+"tp2T",  tnow,tp2,  "TP2  "+DoubleToString(tp2,dg),    InpTargetCol);
      Txt(pre+"tp3T",  tnow,tp3,  "TP3  "+DoubleToString(tp3,dg),    InpTargetCol);
      if(ObjectFind(0,pre+"arrow")<0) ObjectCreate(0,pre+"arrow",OBJ_ARROW,0,0,0);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_TIME,gCSuT[k]);    // sulla barra di inversione
      ObjectSetDouble (0,pre+"arrow",OBJPROP_PRICE,entry);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_ARROWCODE,(d>0) ? 233 : 234);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_COLOR,ecol);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_WIDTH,2);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_ANCHOR,(d>0) ? ANCHOR_TOP : ANCHOR_BOTTOM);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,pre+"arrow",OBJPROP_HIDDEN,true);
      ObjectSetString (0,pre+"arrow",OBJPROP_TOOLTIP,"setup "+TfName(gDTf)+" "+etxt+": ingresso fisso alla chiusura di questa barra");
      gLinesSig=lsig;
      gChg++;
     }
   DrawTradePanel(d,entry,stop,tp1,tp2,tp3);
  }
//+------------------------------------------------------------------+
//| Pannello OPERAZIONE in alto a DESTRA (stessa forma della v4.00)   |
//+------------------------------------------------------------------+
void DrawWaitPanel(const string why)
  {
   string q=P+"q_";
   string sig="WAIT|"+_Symbol+"|"+why;
   if(sig==gPanelSig && ObjectFind(0,q+"bg")>=0) return;
   ObjectsDeleteAll(0,q);
   int RM=8, BW=178, LH=15, y=20;
   int wl=StringLen(why)*6+14;
   if(wl>BW && wl<420) BW=wl;
   RectR(q+"bg", RM, y-4, BW, LH*4+8, InpPanelCol, InpGridCol);
   LblR(q+"t",   RM+6, y,      "OPERAZIONE  "+_Symbol, InpHeadCol, InpFont+1);
   LblR(q+"dir", RM+6, y+LH,   "in attesa di inversione", C'140,144,150', InpFont);
   LblR(q+"why", RM+6, y+2*LH, (StringLen(why)<=66 ? why : StringSubstr(why,0,63)+"..."), C'140,144,150', InpFont-1);
   LblR(q+"note",RM+6, y+3*LH, (gDSel ? "selezionato "+TfName(gDTf)+" (clic sul titolo = TF del grafico)" : "TF del grafico "+TfName(gDTf)), C'140,144,150', InpFont-1);
   ObjectSetString(0,q+"bg",OBJPROP_TOOLTIP,why);
   ObjectSetString(0,q+"dir",OBJPROP_TOOLTIP,why);
   ObjectSetString(0,q+"t",OBJPROP_TOOLTIP,"clic: torna al setup del TF del grafico");
   gPanelSig=sig;
   gChg++;
  }
void DrawTradePanel(const int dir,const double entry,const double stop,const double tp1,const double tp2,const double tp3)
  {
   string q=P+"q_";
   int RM=8, BW=178, LH=15, y=20;
   int k=gDk;
   double risk=MathAbs(entry-stop);
   int dg=_Digits;
   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney=bal*InpRiskPct/100.0;
   double tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tickVal<=0.0) tickVal=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
   double tickSz =SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   double lossPerLot=(tickSz>0) ? (risk/tickSz)*tickVal : 0;
   double totLots=(lossPerLot>0) ? riskMoney/lossPerLot : 0;
   double vst=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double vmn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double vmx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   int f1,f2,f3,ft;
   double L1=SW_NormLots(totLots*InpSize1/100.0,vst,vmn,vmx,f1);
   double L2=SW_NormLots(totLots*InpSize2/100.0,vst,vmn,vmx,f2);
   double L3=SW_NormLots(totLots*InpSize3/100.0,vst,vmn,vmx,f3);
   double LT=SW_NormLots(totLots,vst,vmn,vmx,ft);
   int ldg=2;
   double t=(vst>0.0) ? vst : 0.01;
   int sd=0;
   while(sd<8 && MathAbs(t-MathRound(t))>1e-9) { t*=10.0; sd++; }
   if(sd>ldg) ldg=sd;
   double slPts=(_Point>0) ? risk/_Point : 0;
   color ecol=(dir>0) ? InpBuyCol : InpSellCol;
   datetime fixT=gCSuT[k]+PeriodSeconds(gDTf);        // chiusura della barra di inversione
   string src=gDSel ? "selezionato dalla griglia" : "TF del grafico";
   string sDir="Setup "+TfName(gDTf)+" "+(dir>0 ? "BUY" : "SELL")+", fissato alle "+TimeToString(fixT,TIME_MINUTES);
   string sIn ="Ingresso  "+DoubleToString(entry,dg)+" (barra di inversione)";
   string sSl ="Stop  "+DoubleToString(stop,dg)+"  ("+DoubleToString(slPts,0)+" pt)";
   string s1="TP1 ("+DoubleToString(InpTP1_R,1)+"R)  "+DoubleToString(tp1,dg)+"   "+DoubleToString(L1,ldg);
   string s2="TP2 ("+DoubleToString(InpTP2_R,1)+"R)  "+DoubleToString(tp2,dg)+"   "+DoubleToString(L2,ldg);
   string s3="TP3 ("+DoubleToString(InpTP3_R,1)+"R)  "+DoubleToString(tp3,dg)+"   "+DoubleToString(L3,ldg);
   string sR="Rischio "+DoubleToString(InpRiskPct,1)+"% = "+DoubleToString(riskMoney,2)+"  (tot "+DoubleToString(LT,ldg)+" lot)";
   string sN="size divisa "+DoubleToString(InpSize1,0)+"/"+DoubleToString(InpSize2,0)+"/"+DoubleToString(InpSize3,0)+"%  lotti indicativi";
   string sFix="ingresso fisso a "+HM(fixT)+" | "+src+(gCSuMem[k] ? " | da memoria" : "");
   string sSt;
   if(gHitOk && risk>0.0)
     {
      double dist=(gHitPrice-entry)*dir;
      double pts=(_Point>0) ? dist/_Point : 0;
      sSt="prezzo "+(pts>=0 ? "+" : "")+DoubleToString(pts,0)+" pt ("+(dist>=0 ? "+" : "")+DoubleToString(dist/risk,2)+"R)";
     }
   else sSt="prezzo: n/d";
   string sSt2=StateTxt();
   string lotNote="";
   if(f1==1 || f2==1 || f3==1) lotNote+=" | una quota e' SOTTO il lotto minimo: 0";
   if(f1==2 || f2==2 || f3==2 || ft==2) lotNote+=" | lotto tagliato al MASSIMO del simbolo";
   string sig=sDir+sIn+sSl+s1+s2+s3+sR+sN+sFix+sSt+sSt2+lotNote;
   if(sig==gPanelSig && ObjectFind(0,q+"bg")>=0) return;
   if(StringFind(gPanelSig,"WAIT|")==0) ObjectsDeleteAll(0,q);
   //--- larghezza dal testo piu' lungo (Consolas: ~6 px per carattere a 8 pt, ~7 px a 9 pt)
   int wmax=StringLen(sDir)*7;
   string rows[11];
   rows[0]=sIn; rows[1]=sSl; rows[2]=s1; rows[3]=s2; rows[4]=s3; rows[5]=sR; rows[6]=sN;
   rows[7]=sFix; rows[8]=sSt; rows[9]=sSt2; rows[10]="OPERAZIONE  "+_Symbol;
   for(int i=0;i<11;i++) if(StringLen(rows[i])*6>wmax) wmax=StringLen(rows[i])*6;
   if(wmax+14>BW) BW=wmax+14;
   int BH=LH*13+8;
   RectR(q+"bg", RM, y-4, BW, BH, InpPanelCol, InpGridCol);
   LblR(q+"t",   RM+6, y,        "OPERAZIONE  "+_Symbol, InpHeadCol, InpFont+1);
   LblR(q+"dir", RM+6, y+LH,     sDir, ecol, InpFont+1);
   LblR(q+"in",  RM+6, y+2*LH,   sIn,  InpTextCol, InpFont);
   LblR(q+"sl",  RM+6, y+3*LH,   sSl,  InpStopCol, InpFont);
   LblR(q+"h",   RM+6, y+4*LH,   "TARGET           prezzo      lotti", InpHeadCol, InpFont-1);
   LblR(q+"tp1", RM+6, y+5*LH,   s1,   InpTargetCol, InpFont);
   LblR(q+"tp2", RM+6, y+6*LH,   s2,   InpTargetCol, InpFont);
   LblR(q+"tp3", RM+6, y+7*LH,   s3,   InpTargetCol, InpFont);
   LblR(q+"risk",RM+6, y+8*LH,   sR,   InpTextCol, InpFont);
   LblR(q+"note",RM+6, y+9*LH,   sN,   C'140,144,150', InpFont-1);
   LblR(q+"fix", RM+6, y+10*LH,  sFix, C'140,144,150', InpFont-1);
   LblR(q+"st",  RM+6, y+11*LH,  sSt,  InpTextCol, InpFont-1);
   LblR(q+"st2", RM+6, y+12*LH,  sSt2, (gHitState==4 ? InpStopCol : InpTextCol), InpFont-1);
   string tip="Setup "+TfName(gDTf)+" "+(dir>0 ? "BUY" : "SELL")+" su "+_Symbol+
              "\ningresso FISSO = chiusura della barra di inversione del Supertrend "+DoubleToString(InpMult1,1)+
              " (barra "+HM(gCSuT[k])+", fissato alle "+HM(fixT)+")"+
              "\nstop = Supertrend su quella barra; R = "+DoubleToString(slPts,0)+" pt; resta fisso fino alla prossima inversione"+
              "\nlotti indicativi (rischio % del saldo, quote 40/30/30): NON e' un ordine"+lotNote+
              "\nclic sul titolo: torna al setup del TF del grafico";
   ObjectSetString(0,q+"bg",OBJPROP_TOOLTIP,tip);
   ObjectSetString(0,q+"dir",OBJPROP_TOOLTIP,tip);
   ObjectSetString(0,q+"fix",OBJPROP_TOOLTIP,tip);
   ObjectSetString(0,q+"t",OBJPROP_TOOLTIP,"clic: torna al setup del TF del grafico");
   gPanelSig=sig;
   gChg++;
  }

//+------------------------------------------------------------------+
//| LIVELLI price action (stessa regola della v4.00)                  |
//+------------------------------------------------------------------+
void DeleteLevels()
  {
   if(gLvlR==0 && gLvlS==0) return;
   ObjectsDeleteAll(0,P+"lvl_");
   gLvlR=0; gLvlS=0;
  }
void DrawLevelsArr(const int rt,const datetime &time[],const double &high[],const double &low[],const double &close[])
  {
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
   ArraySort(res);
   ArraySort(sup);
   double tol=price*0.0008;
   int dg=_Digits; datetime tnow=time[rt-1];
   int drawn=0; double last=-1;
   for(int i=0;i<ArraySize(res) && drawn<InpMaxLevels;i++)
     { if(last>0 && MathAbs(res[i]-last)<tol) continue; last=res[i];
       string nm=P+"lvl_r"+IntegerToString(drawn);
       HLine(nm,res[i],InpResCol,STYLE_DOT);
       Txt(nm+"t",tnow,res[i],"RESISTENZA  "+DoubleToString(res[i],dg),InpResCol); drawn++; }
   for(int i=drawn;i<gLvlR;i++) { ObjectDelete(0,P+"lvl_r"+IntegerToString(i)); ObjectDelete(0,P+"lvl_r"+IntegerToString(i)+"t"); }
   gLvlR=drawn;
   drawn=0; last=-1;
   for(int i=ArraySize(sup)-1;i>=0 && drawn<InpMaxLevels;i--)
     { if(last>0 && MathAbs(sup[i]-last)<tol) continue; last=sup[i];
       string nm=P+"lvl_s"+IntegerToString(drawn);
       HLine(nm,sup[i],InpSupCol,STYLE_DOT);
       Txt(nm+"t",tnow,sup[i],"SUPPORTO  "+DoubleToString(sup[i],dg),InpSupCol); drawn++; }
   for(int i=drawn;i<gLvlS;i++) { ObjectDelete(0,P+"lvl_s"+IntegerToString(i)); ObjectDelete(0,P+"lvl_s"+IntegerToString(i)+"t"); }
   gLvlS=drawn;
  }
//--- livelli dal tasto (fuori da OnCalculate): legge le barre da se'
void DrawLevelsNow()
  {
   if(!gShowLevels) { DeleteLevels(); return; }
   int need=InpLevelsLook+2;
   MqlRates r[];
   ArraySetAsSeries(r,false);
   int got=CopyRates(_Symbol,_Period,0,need,r);
   if(got<5) return;
   datetime tt[]; double hh[], ll[], cc[];
   ArrayResize(tt,got); ArrayResize(hh,got); ArrayResize(ll,got); ArrayResize(cc,got);
   for(int i=0;i<got;i++) { tt[i]=r[i].time; hh[i]=r[i].high; ll[i]=r[i].low; cc[i]=r[i].close; }
   DrawLevelsArr(got,tt,hh,ll,cc);
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
void BuildPanel()
  {
   int panelW = InpSymW + NTF*InpCellW + 6;
   int panelH = (gNsym+2)*InpCellH + 10;
   Rect(P+"panel", InpX-3, InpY-3, panelW, panelH, InpPanelCol, InpPanelCol, false);

   Lbl(P+"title", InpX+2, InpY, "SUPERWAVE 4.1", InpHeadCol, InpFont+1);
   int bw=54, gap=2, by=InpY-2;
   int bx=InpX+panelW-4-(4*bw+3*gap);
   Btn(P+"btnHA",   bx,               by, bw, 15, gHA ? "HA" : "CANDELE");
   Btn(P+"btnLiv",  bx+(bw+gap),      by, bw, 15, "LIVELLI");
   Btn(P+"btnST",   bx+2*(bw+gap),    by, bw, 15, "ST");
   Btn(P+"btnHide", bx+3*(bw+gap),    by, bw, 15, gHidden ? "Mostra" : "Nascondi");
   BtnState(P+"btnHA",  gHA);
   BtnState(P+"btnLiv", gShowLevels);
   BtnState(P+"btnST",  gShowST);

   Lbl(P+"h_sym", InpX+2, gHeaderY, "CROSS", InpHeadCol, InpFont);
   ObjectSetString(0,P+"h_sym",OBJPROP_TOOLTIP,RuleTxt());
   for(int c=0;c<NTF;c++)
      Lbl(P+"h_"+IntegerToString(c), ColX(c+1)+InpCellW/2-8, gHeaderY, TFNAMES[c], InpHeadCol, InpFont);

   for(int s=0;s<gNsym;s++)
     {
      int y=gRow0Y+s*InpCellH;
      Rect(P+"sb_"+IntegerToString(s), InpX-1, y-1, InpSymW, InpCellH-1, InpEmptyCol, InpGridCol, false);
      Lbl (P+"s_"+IntegerToString(s), InpX+3, y, gSyms[s], InpTextCol, InpFont);
      for(int c=0;c<NTF;c++)
        {
         string cs=IntegerToString(s)+"_"+IntegerToString(c);
         Rect(P+"bg_"+cs, ColX(c+1), y-1, InpCellW-1, InpCellH-1, InpEmptyCol, InpGridCol, false);
         Lbl (P+"cx_"+cs, ColX(c+1)+InpCellW/2-11, y, " ", clrWhite, InpFont);
         ObjectSetInteger(0,P+"cx_"+cs,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
        }
     }
  }
//--- Nascondi/Mostra: TUTTA la griglia (anche titolo e scritte BUY/SELL, che la v4.00 lasciava a galla)
void SetGridVisible(const bool v)
  {
   long tf=v ? OBJ_ALL_PERIODS : OBJ_NO_PERIODS;
   ObjectSetInteger(0,P+"panel",OBJPROP_TIMEFRAMES,tf);
   ObjectSetInteger(0,P+"title",OBJPROP_TIMEFRAMES,tf);
   ObjectSetInteger(0,P+"h_sym",OBJPROP_TIMEFRAMES,tf);
   for(int c=0;c<NTF;c++) ObjectSetInteger(0,P+"h_"+IntegerToString(c),OBJPROP_TIMEFRAMES,tf);
   for(int s=0;s<gNsym;s++)
     {
      ObjectSetInteger(0,P+"sb_"+IntegerToString(s),OBJPROP_TIMEFRAMES,tf);
      ObjectSetInteger(0,P+"s_"+IntegerToString(s),OBJPROP_TIMEFRAMES,tf);
      for(int c=0;c<NTF;c++)
        {
         string cs=IntegerToString(s)+"_"+IntegerToString(c);
         ObjectSetInteger(0,P+"bg_"+cs,OBJPROP_TIMEFRAMES,tf);
         if(!v) ObjectSetInteger(0,P+"cx_"+cs,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         gShVis[s*NTF+c]=v ? -1 : 0;     // mostrando, la cella decide da sola
        }
     }
  }
//+------------------------------------------------------------------+
int ColX(int col){ return (col==0) ? InpX : InpX+InpSymW+(col-1)*InpCellW; }
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
//--- cambia simbolo/TF solo se cambia davvero (stesso simbolo e TF = nessuna chiamata)
void GoTo(const string sym,const ENUM_TIMEFRAMES tf)
  {
   ENUM_TIMEFRAMES t=(tf==PERIOD_CURRENT) ? _Period : tf;
   if(sym==_Symbol && t==_Period) return;
   ChartSetSymbolPeriod(0,sym,t);
  }
//+------------------------------------------------------------------+
//| TASTI: nessuna ricarica dell'indicatore (la v4.00 chiamava         |
//| ChartSetSymbolPeriod a ogni clic = ricalcolo completo del grafico)|
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!gInitOk || id!=CHARTEVENT_OBJECT_CLICK) return;
   if(StringFind(sparam,P)!=0) return;            // solo i NOSTRI oggetti

   if(sparam==P+"btnHA")
     {
      gHA=!gHA; GvSave("HA",gHA ? 1.0 : 0.0);
      ObjectSetString(0,sparam,OBJPROP_TEXT,gHA ? "HA" : "CANDELE");
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      BtnState(sparam,gHA);
      if(gHA) ColsHide();
      else    ColsRestore();
      FillDisplay(0,gRT);
      ChartRedraw(0);
      return;
     }
   if(sparam==P+"btnLiv")
     {
      gShowLevels=!gShowLevels; GvSave("LIV",gShowLevels ? 1.0 : 0.0);
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      BtnState(sparam,gShowLevels);
      DrawLevelsNow();
      ChartRedraw(0);
      return;
     }
   if(sparam==P+"btnST")
     {
      gShowST=!gShowST; GvSave("ST",gShowST ? 1.0 : 0.0);
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      BtnState(sparam,gShowST);
      FillDisplay(0,gRT);
      ChartRedraw(0);
      return;
     }
   if(sparam==P+"btnHide")
     {
      gHidden=!gHidden; GvSave("HIDE",gHidden ? 1.0 : 0.0);
      ObjectSetString(0,sparam,OBJPROP_TEXT,gHidden ? "Mostra" : "Nascondi");
      ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
      SetGridVisible(!gHidden);
      if(!gHidden)
        {
         InvalidateShown();
         for(int k=0;k<gNC;k++) RenderCell(k);
         for(int s=0;s<gNsym;s++) RenderSymbol(s);
         UpdateBoxes();
        }
      ChartRedraw(0);
      return;
     }
   if(sparam==P+"q_t")                           // titolo del pannello: torna al TF del grafico
     {
      gSelSym=""; gSelTf=PERIOD_CURRENT; SelSave();
      gChg=0; RefreshDisplay(true); ChartRedraw(0);
      return;
     }

   //--- CLICK su una cella: ACCESA = seleziona quel setup; sempre: vai su quel SIMBOLO (+ TF se InpClickCambiaTF)
   int s2,c2;
   if(ParseCell(sparam,s2,c2) && s2>=0 && s2<gNsym && c2>=0 && c2<NTF)
     {
      int k=s2*NTF+c2;
      bool lit=(gCOk[k] && SW_CellLit(gCDir[k],gCBs[k],InpFlipBars));
      if(lit) { gSelSym=gSyms[s2]; gSelTf=TFS[c2]; }
      else    { gSelSym=""; gSelTf=PERIOD_CURRENT; }
      SelSave();
      GoTo(gSyms[s2], InpClickCambiaTF ? TFS[c2] : PERIOD_CURRENT);
      gChg=0; RefreshDisplay(true); ChartRedraw(0);   // se il grafico non cambia, il pannello si aggiorna subito
      return;
     }
   //--- click sul nome/box -> simbolo al TF corrente (selezione tolta)
   int si=SymIndexFromObj(sparam);
   if(si>=0 && si<gNsym)
     {
      gSelSym=""; gSelTf=PERIOD_CURRENT; SelSave();
      GoTo(gSyms[si],PERIOD_CURRENT);
      gChg=0; RefreshDisplay(true); ChartRedraw(0);
     }
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
   ObjectSetInteger(0,name,OBJPROP_BGCOLOR, on ? C'38,110,70' : C'50,54,62');
  }
//+------------------------------------------------------------------+
