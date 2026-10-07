//+------------------------------------------------------------------+
//|                                ABTG_PTE_Dashboard_Leggera.mq5    |
//|                                                                  |
//|  Dashboard PTE "versione nostra, leggera" (07/10/2026).          |
//|  SOLO VISIONE: nessun ordine, nessuna rete, nessun file,         |
//|  nessun handle di indicatore. Mette in MQL5\Indicators e         |
//|  compila con F7.                                                 |
//|                                                                  |
//|  PERCHE' ESISTE                                                  |
//|  La dashboard PTE_V3_18 3.18 (Emiliano Monza / ABTG, compilata,  |
//|  sorgente NON disponibile e NON decompilato) sul terminale       |
//|  manuale di Claudio va a scatti. Questa e' una tabella con la    |
//|  STESSA forma (PAIR / H1 / H4 / D1, simboli su 5 liste) ma       |
//|  con carico minimo. NON e' una copia dell'originale: la sua      |
//|  logica interna non la conosciamo.                               |
//|                                                                  |
//|  COSA SEGNA UNA CELLA (IPOTESI DI LAVORO, da confermare con un   |
//|  confronto visivo affiancato all'originale):                     |
//|   - accesa = sul simbolo/TF c'e' stata una DOJI col corpo FUORI  |
//|     dal canale TMA (lento / veloce / uno dei due / entrambi,     |
//|     input InpCanale) in una delle ultime InpBarreIndietro barre  |
//|     CHIUSE; si mostra la PIU' RECENTE;                           |
//|   - testo = ORA della candela (TF < D1), GIORNO della settimana  |
//|     (D1), gg/mm (W1), mese (MN). ORA SERVER del broker, come il  |
//|     grafico (BCM: UTC+1 fisso -> d'estate ora italiana -1,       |
//|     d'inverno = ora italiana; CLAUDE.md 24/09/2026);             |
//|   - VERDE = doji SOTTO il canale (rialzista, ritorno alla media),|
//|     ROSSO = doji SOPRA il canale (ribassista).                   |
//|                                                                  |
//|  LOGICA DI SEGNALE: COPIATA da mql5/Experts/ABTG_PTE.mq5         |
//|  (TmaBand -> PD_TmaEA, GetCandle -> PD_Candela modo 1,           |
//|  IsDoji -> PD_IsDoji), resa "pura" (lavora su array, non chiama  |
//|  il terminale) per poterla collaudare fuori da MetaTrader.       |
//|  DIFFERENZA ATTESA CON L'ORIGINALE: la TMA dell'EA e' NON-REPAINT |
//|  (media triangolare all'indietro, quindi IN RITARDO di circa     |
//|  mezzo periodo); i canali della dashboard originale PROBABILMENTE|
//|  ripitturano (TMA centrata). I valori dei canali quindi          |
//|  differiscono e alcune celle non coincideranno. Per il confronto |
//|  c'e' InpTmaModo = PD_TMA_CENTRATA: e' una NOSTRA IPOTESI di come |
//|  e' fatta l'originale (TMA centrata classica, mezza-lunghezza =  |
//|  periodo, solo barre chiuse), NON la sua formula.                |
//|  ATR: calcolato qui dalle barre (media semplice del true range,  |
//|  come iATR di MT5) invece che con un handle iATR: stesso numero, |
//|  zero handle.                                                    |
//|                                                                  |
//|  CARICO (perche' e' leggera) -- [STIMA], non misura:             |
//|   - handle di indicatori: 0;                                     |
//|   - oggetti: 3 + 2*nTF + nSimboli*(1+2*nTF); default 35 x 3 TF = |
//|     254 oggetti, creati UNA volta, aggiornati solo se testo o    |
//|     colore cambiano; ChartRedraw solo se qualcosa e' cambiato;   |
//|   - calcolo: SOLO a barra nuova di ciascun simbolo/TF (OnTimer   |
//|     1 s), mai a ogni tick. Fra una barra e la successiva una     |
//|     cella non chiama il terminale per niente (orario della       |
//|     prossima barra in memoria); quando la barra e' "dovuta" fa   |
//|     1 SeriesInfoInteger ogni InpRicontrolloSec secondi finche'   |
//|     la barra arriva;                                             |
//|   - copia: 1 CopyRates per cella per barra nuova, col numero     |
//|     MINIMO di barre (default 131: ATR lento 100 + 30 barre di    |
//|     ricerca + 1); a regime H1+H4+D1 su 35 simboli fanno circa    |
//|     35+8,75+1,5 = ~45 copie all'ora (una ogni ~80 s);            |
//|   - all'avvio: al massimo InpCellePerCiclo copie al secondo      |
//|     (default 20 -> 105 celle in ~6 s), per non bloccare il       |
//|     grafico;                                                     |
//|   - simboli senza dati: saltati, riprovati con attesa crescente  |
//|     2, 4, 8 ... 300 s.                                           |
//|  Confronto con l'originale: se (come sembra dagli scatti)        |
//|  ricalcolasse ~105-111 celle a OGNI tick, con 2-5 tick/s sarebbero|
//|  ~200-550 copie+ricalcoli al secondo contro ~0,013 qui. E' una   |
//|  IPOTESI sull'originale, non una misura.                         |
//|  NB: le 5 liste di default fanno 35 simboli (28 forex + XAUUSD + |
//|  USOIL + 5 indici); l'originale ne mostrerebbe 37: due mancano,  |
//|  vanno chiesti a Claudio, NON inventati.                         |
//|                                                                  |
//|  NON implementato (dichiarato): frecce sul grafico, candele      |
//|  Heikin Ashi disegnate, canali disegnati (la dashboard e' la     |
//|  tabella), email/push, pulsanti del grafico (CHART BUTTONS:      |
//|  non sappiamo cosa fanno). Alert: solo popup/suono, spenti.      |
//|  Un solo esemplare per grafico (prefisso oggetti fisso "PDL_").  |
//|  DEMO. Nessuna garanzia.                                         |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//==================================================================
//  ENUM (fuori dal blocco puro: servono agli input)
//==================================================================
enum ENUM_PD_CANALE
  {
   PD_CH_LENTO   = 0,   // Lento (TMA 56)
   PD_CH_VELOCE  = 1,   // Veloce (TMA 14)
   PD_CH_UNO     = 2,   // Uno dei due (CHSEL_EITHER dell'originale)
   PD_CH_ENTRAMBI= 3    // Entrambi (come l'EA con InpRequireOutSlow)
  };
enum ENUM_PD_CANDELA
  {
   PD_CAND_GIAPPONESE = 0, // Candele giapponesi
   PD_CAND_HA_EA      = 1, // Heikin Ashi come ABTG_PTE (2 barre di seme)
   PD_CAND_HA_PIENA   = 2  // Heikin Ashi ricorsiva su tutta la finestra
  };
enum ENUM_PD_TMA
  {
   PD_TMA_EA       = 0, // TMA dell'EA ABTG_PTE (non-repaint, in ritardo)
   PD_TMA_CENTRATA = 1  // TMA centrata (NOSTRA ipotesi dell'originale, ripittura)
  };

//==================================================================
//  INPUT (stessi gruppi dell'originale, dove ha senso)
//==================================================================
input group "=== DASHBOARD ==="
input ENUM_BASE_CORNER InpAngolo    = CORNER_LEFT_UPPER; // DashCorner (angoli diversi da Left upper: NON provati)
input int    InpOffsetX             = 80;     // Offset X (pixel)
input int    InpOffsetY             = 75;     // Offset Y (pixel)
input int    InpLarghezzaCella      = 72;     // Larghezza cella
input int    InpAltezzaCella        = 18;     // Altezza cella
input int    InpFontSize            = 8;      // Dimensione font
input string InpFont                = "Arial";// Font

input group "=== SIMBOLI (5 liste come l'originale) ==="
input string InpLista1 = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADCHF,CADJPY,CHFJPY"; // Lista 1
input string InpLista2 = "EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD";        // Lista 2
input string InpLista3 = "GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDCAD";        // Lista 3
input string InpLista4 = "NZDCHF,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY,XAUUSD,USOIL";  // Lista 4
input string InpLista5 = "225JPY,D30EUR,SPXUSD,U30USD,NASUSD";                      // Lista 5
input string InpSuffisso        = "";     // Suffisso del broker (es. ".r"), vuoto = nessuno
input bool   InpSoloMarketWatch = true;   // Solo i simboli del Market Watch (salta gli altri)

input group "=== TIMEFRAME (colonne) ==="
input bool InpM15 = false; // M15
input bool InpM30 = false; // M30
input bool InpH1  = true;  // H1
input bool InpH4  = true;  // H4
input bool InpH8  = false; // H8
input bool InpH12 = false; // H12
input bool InpD1  = true;  // D1
input bool InpW1  = false; // W1
input bool InpMN  = false; // MN

input group "=== DOJI CHANNEL FILTER ==="
input bool           InpSoloFuoriCanale = true;       // Segnala DOJI solo se corpo fuori da almeno un canale
input ENUM_PD_CANALE InpCanale          = PD_CH_UNO;  // Canale (CHSEL)

input group "=== TMA CHANNELS ==="
input ENUM_PD_TMA InpTmaModo    = PD_TMA_EA; // Calcolo TMA (default = quello dell'EA ABTG_PTE)
input int    InpTmaLento        = 56;     // Canale lento: periodo
input int    InpAtrLento        = 100;    // Canale lento: ATR
input double InpMultLento       = 2.0;    // Canale lento: moltiplicatore
input int    InpTmaVeloce       = 14;     // Canale veloce: periodo
input int    InpAtrVeloce       = 30;     // Canale veloce: ATR
input double InpMultVeloce      = 2.0;    // Canale veloce: moltiplicatore

input group "=== DOJI DETECTION ==="
input double          InpCorpoMaxPct  = 10.0;           // Body max % del range
input ENUM_PD_CANDELA InpCandela      = PD_CAND_HA_EA;  // Candele su cui cercare la doji (EA: Heikin Ashi)
input bool            InpUsaCode      = false;          // Richiedi coda (Dragonfly per verde, Gravestone per rosso)
input double          InpRapCodaInf   = 2.0;            // Rapporto coda inferiore (Dragonfly)
input double          InpRapCodaSup   = 2.0;            // Rapporto coda superiore (Gravestone)
input bool            InpConfermaFlip = false;          // Richiedi cambio colore della candela dopo (come l'EA)
input int             InpBarreIndietro= 30;             // Barre chiuse in cui cercare l'ultima doji
input int             InpSemeHA       = 50;             // Barre di seme per la Heikin Ashi ricorsiva

input group "=== COLORI ==="
input color InpColRialzo   = C'39,174,96';   // Cella rialzista (JP rialzista dell'originale)
input color InpColRibasso  = C'192,57,43';   // Cella ribassista (JP ribassista dell'originale)
input color InpColVuota    = C'28,28,28';    // Cella vuota
input color InpColPannello = C'18,18,18';    // Sfondo pannello
input color InpColIntest   = C'48,48,48';    // Intestazione
input color InpColBordo    = C'60,60,60';    // Bordo celle
input color InpColTesto    = clrWhite;       // Testo
input color InpColSpento   = C'110,110,110'; // Simbolo non disponibile

input group "=== ALERTS ==="
input bool InpAlertPopup  = false;  // Popup (solo segnali NUOVI sull'ultima barra chiusa)
input bool InpAlertSuono  = false;  // Suono
input int  InpAlertMinuti = 5;      // Tempo minimo fra due alert della stessa cella (minuti)

input group "=== CONFRONTO E CARICO ==="
input bool InpModoConfronto  = false; // Modalita confronto: distanza corpo-canale in ATR nel tooltip
input int  InpCellePerCiclo  = 20;    // Celle ricalcolate al massimo per ciclo di timer (1 s)
input int  InpRicontrolloSec = 5;     // Barra dovuta ma non ancora arrivata: ricontrolla ogni N s

//==================================================================
//  BLOCCO PURO: niente chiamate al terminale, solo array e numeri.
//  Lo estrae e lo compila in C++ backtest_pipeline/
//  collaudo_pte_dashboard_leggera.py. Array in ordine "serie":
//  indice 0 = barra in formazione, 1 = ultima chiusa, ecc.
//==================================================================
//@@PD_PURE_BEGIN
#define PD_NODATI (-9)

struct PD_Par
  {
   int    candela;      // 0 giapponese, 1 HA come l'EA, 2 HA ricorsiva
   int    tmaModo;      // 0 TMA dell'EA (non-repaint), 1 TMA centrata (ipotesi)
   int    tmaS;
   int    atrS;
   double multS;
   int    tmaF;
   int    atrF;
   double multF;
   double corpoMaxPct;
   bool   soloFuori;
   int    canale;       // 0 lento, 1 veloce, 2 uno dei due, 3 entrambi
   bool   usaCode;
   double rapInf;
   double rapSup;
   bool   flip;
   int    semeHA;
  };

int PD_MaxI(int a,int b){ return(a>b ? a : b); }

//--- COPIATA da ABTG_PTE.mq5 TmaBand (parte di calcolo, stessa formula
//    e stesso controllo di storico need=period+m+shift+5): media
//    triangolare = SMA di SMA di lunghezza m, all'indietro dalla barra
//    'shift' -> non-repaint, ma in ritardo di circa mezzo periodo.
bool PD_TmaEA(const double &c[],int n,int period,int shift,double &mid)
  {
   int m=(period+1)/2; if(m<1) m=1;
   int need=period+m+shift+5;
   if(shift<0 || n<need) return(false);
   double tma=0;
   for(int k=0;k<m;k++)
     {
      double s=0;
      for(int j=0;j<m;j++) s+=c[shift+k+j];
      tma+=s/m;
     }
   tma/=m;
   mid=tma;
   return(true);
  }

//--- NOSTRA IPOTESI della TMA dell'originale (NON la sua formula): media
//    triangolare CENTRATA classica, mezza-lunghezza = period, pesi
//    period+1 al centro che scendono di 1 per lato. A destra usa solo le
//    barre CHIUSE disponibili (shift-j>=1): sulle barre recenti la media
//    e' monca e cambia quando arrivano barre nuove -> ripittura.
bool PD_TmaCentrata(const double &c[],int n,int period,int shift,double &mid)
  {
   if(period<1 || shift<1 || n<shift+period+1) return(false);
   double sum=(period+1)*c[shift];
   double sw=(period+1);
   for(int j=1;j<=period;j++)
     {
      double k=period+1-j;
      sum+=k*c[shift+j]; sw+=k;
      if(shift-j>=1){ sum+=k*c[shift-j]; sw+=k; }
     }
   mid=sum/sw;
   return(true);
  }

//--- ATR come iATR di MT5: media SEMPLICE del true range su 'period'
//    barre, TR = max(H, C prec.) - min(L, C prec.). Serve la barra
//    precedente all'ultima: n >= shift+period+1.
bool PD_Atr(const double &h[],const double &l[],const double &c[],int n,int period,int shift,double &atr)
  {
   if(period<1 || shift<0 || n<shift+period+1) return(false);
   double s=0;
   for(int i=shift;i<shift+period;i++)
      s+=MathMax(h[i],c[i+1])-MathMin(l[i],c[i+1]);
   atr=s/period;
   return(atr>0);
  }

//--- COPIATA da ABTG_PTE.mq5 GetCandle (modo 1: Heikin Ashi approssimata
//    con 2 barre di seme, formula identica). Modo 2: Heikin Ashi classica
//    ricorsiva, seme sulla barra piu' vecchia della finestra (l'errore del
//    seme si dimezza a ogni barra: con 50 barre e' sotto 1e-15).
bool PD_Candela(const double &o[],const double &h[],const double &l[],const double &c[],int n,int shift,int modo,
                double &O,double &H,double &L,double &C)
  {
   if(shift<0 || n<shift+1) return(false);
   H=h[shift]; L=l[shift];
   if(modo==0){ O=o[shift]; C=c[shift]; return(true); }
   if(modo==1)
     {
      if(n<shift+3) return(false);
      double haC=(o[shift]+h[shift]+l[shift]+c[shift])/4.0;
      double haO_prev=(o[shift+2]+c[shift+2])/2.0;
      double haC_prev=(o[shift+1]+h[shift+1]+l[shift+1]+c[shift+1])/4.0;
      double haO=(haO_prev+haC_prev)/2.0;
      O=haO; C=haC;
     }
   else
     {
      double ro=(o[n-1]+c[n-1])/2.0;
      double rc=(o[n-1]+h[n-1]+l[n-1]+c[n-1])/4.0;
      for(int i=n-2;i>=shift;i--)
        {
         ro=(ro+rc)/2.0;
         rc=(o[i]+h[i]+l[i]+c[i])/4.0;
        }
      O=ro; C=rc;
     }
   H=MathMax(H,MathMax(O,C)); L=MathMin(L,MathMin(O,C));
   return(true);
  }

//--- COPIATA da ABTG_PTE.mq5 IsDoji (soglia passata come argomento)
bool PD_IsDoji(double o,double h,double l,double c,double bodyMaxPct)
  {
   double range=h-l; if(range<=0) return(false);
   return(MathAbs(c-o) <= bodyMaxPct/100.0*range);
  }

bool PD_Banda(const double &h[],const double &l[],const double &c[],int n,int shift,int modo,int period,int atrPer,double mult,
              double &mid,double &up,double &lo,double &atr)
  {
   double tma=0;
   if(modo==1){ if(!PD_TmaCentrata(c,n,period,shift,tma)) return(false); }
   else       { if(!PD_TmaEA(c,n,period,shift,tma)) return(false); }
   if(!PD_Atr(h,l,c,n,atrPer,shift,atr)) return(false);
   mid=tma; up=tma+atr*mult; lo=tma-atr*mult;
   return(true);
  }

//--- distanza del CORPO dal canale in ATR: > 0 = fuori (sopra o sotto),
//    < 0 = dentro. Serve alla modalita' confronto.
double PD_Dist(double blo,double bhi,double up,double lo,double atr)
  {
   return(MathMax(blo-up,lo-bhi)/atr);
  }

int PD_BisognoTma(int modo,int period,int s)
  {
   if(modo==1) return(s+period+1);
   int m=(period+1)/2; if(m<1) m=1;
   return(period+m+s+5);
  }

//--- barre MINIME da copiare per valutare le barre 1..barre
int PD_Bisogno(const PD_Par &p,int barre)
  {
   int s=barre;
   int b=s+3;
   if(p.candela==2) b=PD_MaxI(b,s+1+p.semeHA);
   b=PD_MaxI(b,PD_BisognoTma(p.tmaModo,p.tmaS,s));
   b=PD_MaxI(b,PD_BisognoTma(p.tmaModo,p.tmaF,s));
   b=PD_MaxI(b,s+p.atrS+1);
   b=PD_MaxI(b,s+p.atrF+1);
   return(b);
  }

//--- una barra: +1 doji rialzista (corpo SOTTO il canale), -1 ribassista
//    (corpo SOPRA), 0 niente, PD_NODATI storico corto. dF/dS: distanza
//    del corpo dal canale veloce/lento in ATR (calcolata anche senza doji).
int PD_Valuta(const double &o[],const double &h[],const double &l[],const double &c[],int n,int shift,const PD_Par &p,
              double &dF,double &dS)
  {
   dF=0.0; dS=0.0;
   double O=0,H=0,L=0,C=0;
   if(!PD_Candela(o,h,l,c,n,shift,p.candela,O,H,L,C)) return(PD_NODATI);
   double midF=0,upF=0,loF=0,aF=0,midS=0,upS=0,loS=0,aS=0;
   if(!PD_Banda(h,l,c,n,shift,p.tmaModo,p.tmaF,p.atrF,p.multF,midF,upF,loF,aF)) return(PD_NODATI);
   if(!PD_Banda(h,l,c,n,shift,p.tmaModo,p.tmaS,p.atrS,p.multS,midS,upS,loS,aS)) return(PD_NODATI);
   double bhi=MathMax(O,C), blo=MathMin(O,C);
   dF=PD_Dist(blo,bhi,upF,loF,aF);
   dS=PD_Dist(blo,bhi,upS,loS,aS);
   if(!PD_IsDoji(O,H,L,C,p.corpoMaxPct)) return(0);
   bool sopra=false, sotto=false;
   if(!p.soloFuori)
     {
      double mc=(blo+bhi)/2.0;               // senza filtro canale: lato rispetto alla TMA veloce
      sopra=(mc>midF); sotto=(mc<midF);
     }
   else
     {
      bool sF=(blo>upF), gF=(bhi<loF), sS=(blo>upS), gS=(bhi<loS);
      if(p.canale==0)      { sopra=sS; sotto=gS; }
      else if(p.canale==1) { sopra=sF; sotto=gF; }
      else if(p.canale==2) { sopra=(sF || sS); sotto=(gF || gS); }
      else                 { sopra=(sF && sS); sotto=(gF && gS); }
     }
   if(sopra==sotto) return(0);               // ne' sopra ne' sotto, o conflitto fra i due canali
   int dir=(sotto ? 1 : -1);                 // sotto = rialzista (ritorno alla media), sopra = ribassista
   if(p.usaCode)
     {
      double cs=H-bhi, ci=blo-L;
      if(dir>0 && !(ci>=p.rapInf*cs)) return(0);
      if(dir<0 && !(cs>=p.rapSup*ci)) return(0);
     }
   if(p.flip)
     {
      if(shift<2) return(0);                 // la candela di conferma non e' ancora chiusa
      double O1=0,H1=0,L1=0,C1=0;
      if(!PD_Candela(o,h,l,c,n,shift-1,p.candela,O1,H1,L1,C1)) return(PD_NODATI);
      if(dir>0 && !(C1>O1)) return(0);
      if(dir<0 && !(C1<O1)) return(0);
     }
   return(dir);
  }

//--- la doji PIU' RECENTE fra le barre chiuse 1..barre
int PD_Ultimo(const double &o[],const double &h[],const double &l[],const double &c[],int n,int barre,const PD_Par &p,
              int &shiftSeg,double &dF,double &dS,double &dF1,double &dS1)
  {
   shiftSeg=0; dF=0.0; dS=0.0; dF1=0.0; dS1=0.0;
   for(int s=1;s<=barre;s++)
     {
      double a=0.0, b=0.0;
      int r=PD_Valuta(o,h,l,c,n,s,p,a,b);
      if(r==PD_NODATI) return(PD_NODATI);
      if(s==1){ dF1=a; dS1=b; }
      if(r!=0){ shiftSeg=s; dF=a; dS=b; return(r); }
     }
   return(0);
  }

string PD_Due(int v){ return((v<10 ? "0" : "")+IntegerToString(v)); }

//--- data civile da giorni dal 01/01/1970 (algoritmo "days from civil" inverso)
void PD_Data(long z,int &y,int &mo,int &d)
  {
   z+=719468;
   long era=(z>=0 ? z : z-146096)/146097;
   long doe=z-era*146097;
   long yoe=(doe-doe/1460+doe/36524-doe/146096)/365;
   long yy=yoe+era*400;
   long doy=doe-(365*yoe+yoe/4-yoe/100);
   long mp=(5*doy+2)/153;
   d=(int)(doy-(153*mp+2)/5+1);
   mo=(int)(mp<10 ? mp+3 : mp-9);
   y=(int)(yy+(mo<=2 ? 1 : 0));
  }

//--- testo della cella: ORA (TF < D1), GIORNO (D1), gg/mm (W1), mese (MN).
//    Il datetime della candela e' gia' in ORA SERVER: niente conversioni.
string PD_Testo(datetime t,int tfSec)
  {
   long g=(long)t/86400;
   int sec=(int)((long)t-g*86400);
   if(tfSec<86400) return(PD_Due(sec/3600)+":"+PD_Due((sec%3600)/60));
   if(tfSec<604800) return(StringSubstr("SunMonTueWedThuFriSat",(int)((g+4)%7)*3,3));
   int y=0, mo=0, d=0;
   PD_Data(g,y,mo,d);
   if(tfSec<2419200) return(PD_Due(d)+"/"+PD_Due(mo));
   return(StringSubstr("JanFebMarAprMayJunJulAugSepOctNovDec",(mo-1)*3,3));
  }
//@@PD_PURE_END

//==================================================================
//  STATO
//==================================================================
#define PD_PREF "PDL_"
#define PD_NOME "ABTG PTE Dashboard Leggera"

string          gSym[];      // simboli (con suffisso)
int             gNS=0;
ENUM_TIMEFRAMES gTF[];
string          gTFn[];
int             gNT=0;
int             gStatoSim[]; // 0 ok, 1 fuori Market Watch, 2 inesistente, -1 da valutare
color           gColSim[];   // colore attuale dell'etichetta del simbolo (cache)

//--- per cella k = i*gNT + j
datetime gUltBarra[];   // apertura della barra 0 con cui si e' calcolato
datetime gProssimo[];   // prima di questo istante (ora server) la cella non chiama il terminale
int      gAttesa[];     // attesa crescente dopo un fallimento (s)
int      gDir[];        // +1 / -1 / 0
datetime gTSeg[];       // apertura della candela del segnale
bool     gPronta[];     // almeno un calcolo riuscito
datetime gUltAllerta[];
double   gDF[], gDS[], gDF1[], gDS1[];
string   gTxt[];        // cache del disegno: si tocca l'oggetto solo se cambia
color    gBg[];
string   gTip[];

PD_Par   gPar;
int      gBisogno=0;
int      gCursore=0;
bool     gRidisegna=false;
bool     gProprietario=false;
bool     gDoppioVisto=false;
datetime gUltStato=0;
MqlRates gR[];
double   gO[], gH[], gL[], gC[];

//==================================================================
//  POSIZIONI (angolo dell'originale). Rettangoli: punto di ancoraggio
//  in alto a sinistra; etichette: centro. Angoli diversi da Left upper
//  NON provati (nessun terminale qui).
//==================================================================
int TotW(){ return(InpLarghezzaCella*(1+gNT)); }
int TotH(){ return(InpAltezzaCella*(2+gNS)); }
bool AngoloDestro(){ return(InpAngolo==CORNER_RIGHT_UPPER || InpAngolo==CORNER_RIGHT_LOWER); }
bool AngoloBasso(){ return(InpAngolo==CORNER_LEFT_LOWER || InpAngolo==CORNER_RIGHT_LOWER); }
int RX(int x){ return(AngoloDestro() ? InpOffsetX+TotW()-x : InpOffsetX+x); }
int RY(int y){ return(AngoloBasso()  ? InpOffsetY+TotH()-y : InpOffsetY+y); }
int CX(int x){ return(AngoloDestro() ? InpOffsetX+TotW()-x-InpLarghezzaCella/2 : InpOffsetX+x+InpLarghezzaCella/2); }
int CY(int y){ return(AngoloBasso()  ? InpOffsetY+TotH()-y-InpAltezzaCella/2 : InpOffsetY+y+InpAltezzaCella/2); }

void Rett(string nome,int x,int y,int w,int hh,color bg)
  {
   if(ObjectFind(0,nome)<0) ObjectCreate(0,nome,OBJ_RECTANGLE_LABEL,0,0,0);
   ObjectSetInteger(0,nome,OBJPROP_CORNER,InpAngolo);
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,nome,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,nome,OBJPROP_YSIZE,hh);
   ObjectSetInteger(0,nome,OBJPROP_BGCOLOR,bg);
   ObjectSetInteger(0,nome,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,InpColBordo);
   ObjectSetInteger(0,nome,OBJPROP_BACK,false);
   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
  }

void Etic(string nome,int x,int y,string testo,color col)
  {
   if(ObjectFind(0,nome)<0) ObjectCreate(0,nome,OBJ_LABEL,0,0,0);
   ObjectSetInteger(0,nome,OBJPROP_CORNER,InpAngolo);
   ObjectSetInteger(0,nome,OBJPROP_ANCHOR,ANCHOR_CENTER);
   ObjectSetInteger(0,nome,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,nome,OBJPROP_YDISTANCE,y);
   ObjectSetString(0,nome,OBJPROP_TEXT,testo);
   ObjectSetString(0,nome,OBJPROP_FONT,InpFont);
   ObjectSetInteger(0,nome,OBJPROP_FONTSIZE,InpFontSize);
   ObjectSetInteger(0,nome,OBJPROP_COLOR,col);
   ObjectSetInteger(0,nome,OBJPROP_SELECTABLE,false);
   ObjectSetInteger(0,nome,OBJPROP_HIDDEN,true);
  }

string NomeR(int i,int j){ return(PD_PREF+"r_"+IntegerToString(i)+"_"+IntegerToString(j)); }
string NomeT(int i,int j){ return(PD_PREF+"t_"+IntegerToString(i)+"_"+IntegerToString(j)); }
string NomeS(int i){ return(PD_PREF+"s_"+IntegerToString(i)); }

//--- costruisce TUTTI gli oggetti una volta (e azzera la cache del disegno)
void Struttura()
  {
   int W=InpLarghezzaCella, Hc=InpAltezzaCella;
   Rett(PD_PREF+"pannello",RX(0),RY(0),TotW(),TotH(),InpColPannello);
   Etic(PD_PREF+"titolo",RX(0)+(AngoloDestro() ? -TotW()/2 : TotW()/2),CY(0),"PTE DASHBOARD (leggera)",InpColTesto);
   Etic(PD_PREF+"h_pair",CX(0),CY(Hc),"PAIR",InpColTesto);
   for(int j=0;j<gNT;j++)
     {
      Rett(PD_PREF+"hr_"+IntegerToString(j),RX(W*(1+j)),RY(Hc),W,Hc,InpColIntest);
      Etic(PD_PREF+"ht_"+IntegerToString(j),CX(W*(1+j)),CY(Hc),gTFn[j],InpColTesto);
     }
   for(int i=0;i<gNS;i++)
     {
      int y=Hc*(2+i);
      color cs=(gStatoSim[i]==0 ? InpColTesto : InpColSpento);   // anche quando si ricostruisce
      Etic(NomeS(i),CX(0),CY(y),gSym[i],cs);
      gColSim[i]=cs;
      for(int j=0;j<gNT;j++)
        {
         int k=i*gNT+j;
         Rett(NomeR(i,j),RX(W*(1+j)),RY(y),W,Hc,InpColVuota);
         Etic(NomeT(i,j),CX(W*(1+j)),CY(y)," ",InpColTesto);   // " ": un'etichetta vuota mostrerebbe "Label"
         gTxt[k]=" "; gBg[k]=InpColVuota; gTip[k]="";
         AggiornaCella(k);
        }
     }
   gRidisegna=true;
  }

//==================================================================
//  CELLA: compone testo/colore/tooltip e tocca l'oggetto SOLO se cambia
//==================================================================
void AggiornaCella(int k)
  {
   int i=k/gNT, j=k%gNT;
   string txt=" ";
   color  bg=InpColVuota;
   string base=gSym[i]+" "+gTFn[j]+": ";
   string tip;
   if(gStatoSim[i]==1)      tip=base+"fuori dal Market Watch (saltato)";
   else if(gStatoSim[i]==2) tip=base+"simbolo inesistente sul broker";
   else if(!gPronta[k])     tip=base+"dati non ancora pronti (riprova da solo)";
   else if(gDir[k]==0)      tip=base+"nessuna doji fuori canale nelle ultime "+IntegerToString(InpBarreIndietro)+" barre chiuse";
   else
     {
      txt=PD_Testo(gTSeg[k],PeriodSeconds(gTF[j]));
      bg=(gDir[k]>0 ? InpColRialzo : InpColRibasso);
      tip=base+(gDir[k]>0 ? "doji RIALZISTA (sotto)" : "doji RIBASSISTA (sopra)")+" "+
          TimeToString(gTSeg[k],TIME_DATE|TIME_MINUTES)+" ora server";
     }
   if(InpModoConfronto && gPronta[k] && gStatoSim[i]==0)
     {
      if(gDir[k]!=0) tip+=StringFormat(" | segnale V %+.2f L %+.2f ATR",gDF[k],gDS[k]);
      tip+=StringFormat(" | ultima chiusa V %+.2f L %+.2f ATR (>0 = corpo fuori)",gDF1[k],gDS1[k]);
     }
   if(txt!=gTxt[k]){ ObjectSetString(0,NomeT(i,j),OBJPROP_TEXT,txt); gTxt[k]=txt; gRidisegna=true; }
   if(bg!=gBg[k]){ ObjectSetInteger(0,NomeR(i,j),OBJPROP_BGCOLOR,bg); gBg[k]=bg; gRidisegna=true; }
   if(tip!=gTip[k])
     {
      ObjectSetString(0,NomeR(i,j),OBJPROP_TOOLTIP,tip);
      ObjectSetString(0,NomeT(i,j),OBJPROP_TOOLTIP,tip);
      gTip[k]=tip;
     }
  }

//==================================================================
//  SIMBOLI E TIMEFRAME
//==================================================================
void AggiungiLista(string lista)
  {
   string parti[];
   int n=StringSplit(lista,',',parti);
   for(int x=0;x<n;x++)
     {
      string s=parti[x];
      StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s)==0) continue;
      ArrayResize(gSym,gNS+1);
      gSym[gNS]=s+InpSuffisso;
      gNS++;
     }
  }

void AggiungiTF(bool acceso,ENUM_TIMEFRAMES tf,string nome)
  {
   if(!acceso) return;
   ArrayResize(gTF,gNT+1); ArrayResize(gTFn,gNT+1);
   gTF[gNT]=tf; gTFn[gNT]=nome; gNT++;
  }

//--- stato dei simboli: all'avvio e poi ogni 60 s (37 letture, niente dati)
void AggiornaStatoSimboli()
  {
   for(int i=0;i<gNS;i++)
     {
      bool custom=false;
      int st=0;
      if(!SymbolExist(gSym[i],custom)) st=2;
      else if(InpSoloMarketWatch && SymbolInfoInteger(gSym[i],SYMBOL_SELECT)==0) st=1;
      if(st==gStatoSim[i]) continue;
      gStatoSim[i]=st;
      color col=(st==0 ? InpColTesto : InpColSpento);
      if(col!=gColSim[i]){ ObjectSetInteger(0,NomeS(i),OBJPROP_COLOR,col); gColSim[i]=col; gRidisegna=true; }
      for(int j=0;j<gNT;j++)
        {
         int k=i*gNT+j;
         if(st==0){ gProssimo[k]=0; gAttesa[k]=0; gUltBarra[k]=0; }
         AggiornaCella(k);
        }
     }
  }

int DurataBarra(ENUM_TIMEFRAMES tf)
  {
   if(tf==PERIOD_MN1) return(28*86400);      // il mese piu' corto: mai in ritardo sulla barra nuova
   return(PeriodSeconds(tf));
  }

void Rinvia(int k,datetime ora)
  {
   gAttesa[k]=(gAttesa[k]<=0 ? 2 : (gAttesa[k]>=150 ? 300 : gAttesa[k]*2));
   gProssimo[k]=ora+gAttesa[k];
  }

//==================================================================
//  UNA CELLA: ricalcolo SOLO se il simbolo/TF ha una barra nuova.
//  Ritorna true se ha fatto una copia di dati (costo vero).
//==================================================================
bool Elabora(int k,datetime ora)
  {
   int i=k/gNT, j=k%gNT;
   if(gStatoSim[i]!=0) return(false);
   if(ora<gProssimo[k]) return(false);
   string s=gSym[i];
   ENUM_TIMEFRAMES tf=gTF[j];
   datetime lb=(datetime)SeriesInfoInteger(s,tf,SERIES_LASTBAR_DATE);
   if(lb==0){ Rinvia(k,ora); return(false); }                                   // storico non pronto
   if(lb==gUltBarra[k]){ gProssimo[k]=ora+InpRicontrolloSec; return(false); }   // nessuna barra nuova: niente copia
   int got=CopyRates(s,tf,0,gBisogno,gR);
   if(got<gBisogno){ Rinvia(k,ora); return(true); }
   ArrayResize(gO,got); ArrayResize(gH,got); ArrayResize(gL,got); ArrayResize(gC,got);
   for(int x=0;x<got;x++){ gO[x]=gR[x].open; gH[x]=gR[x].high; gL[x]=gR[x].low; gC[x]=gR[x].close; }
   int sh=0;
   double a=0, b=0, a1=0, b1=0;
   int r=PD_Ultimo(gO,gH,gL,gC,got,InpBarreIndietro,gPar,sh,a,b,a1,b1);
   if(r==PD_NODATI){ Rinvia(k,ora); return(true); }
   datetime tseg=(r!=0 ? gR[sh].time : (datetime)0);
   //--- alert: solo un segnale NUOVO sull'ultima barra chiusa, mai al primo calcolo
   if((InpAlertPopup || InpAlertSuono) && r!=0 && sh==1 && gPronta[k] && tseg!=gTSeg[k] &&
      ora-gUltAllerta[k]>=(long)InpAlertMinuti*60)
     {
      gUltAllerta[k]=ora;
      string m="PTE leggera: "+s+" "+gTFn[j]+(r>0 ? " doji RIALZISTA " : " doji RIBASSISTA ")+TimeToString(tseg,TIME_DATE|TIME_MINUTES);
      if(InpAlertPopup) Alert(m);
      if(InpAlertSuono) PlaySound("alert.wav");
     }
   gDir[k]=r; gTSeg[k]=tseg; gDF[k]=a; gDS[k]=b; gDF1[k]=a1; gDS1[k]=b1;
   gPronta[k]=true;
   gUltBarra[k]=gR[0].time;
   gAttesa[k]=0;
   gProssimo[k]=gR[0].time+DurataBarra(tf);   // prima della prossima barra non c'e' niente da fare
   AggiornaCella(k);
   return(true);
  }

//--- avviso se sul grafico ci sono due copie (si pestano gli oggetti PDL_)
void ControllaDoppio()
  {
   gDoppioVisto=true;
   int n=0, tot=ChartIndicatorsTotal(0,0);
   for(int x=0;x<tot;x++) if(ChartIndicatorName(0,0,x)==PD_NOME) n++;
   if(n>=2)
     {
      Print("[PTE leggera] ATTENZIONE: ",n," copie su questo grafico. Ne serve UNA: rimuovi le altre.");
      ObjectSetString(0,PD_PREF+"titolo",OBJPROP_TEXT,"PTE DASHBOARD: 2 COPIE! rimuovine una");
      gRidisegna=true;
     }
  }

//==================================================================
//  EVENTI
//==================================================================
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,PD_NOME);
   if(InpLarghezzaCella<10 || InpAltezzaCella<8 || InpFontSize<4 || InpBarreIndietro<1 || InpBarreIndietro>500 ||
      InpTmaLento<1 || InpTmaVeloce<1 || InpAtrLento<1 || InpAtrVeloce<1 || InpMultLento<=0 || InpMultVeloce<=0 ||
      InpCorpoMaxPct<=0 || InpCellePerCiclo<1 || InpRicontrolloSec<1 || InpSemeHA<0 || InpAlertMinuti<0)
     {
      Print("[PTE leggera] parametri non validi: controlla dimensioni, periodi, moltiplicatori e barre (1-500).");
      return(INIT_PARAMETERS_INCORRECT);
     }
   gNS=0; ArrayResize(gSym,0);
   AggiungiLista(InpLista1); AggiungiLista(InpLista2); AggiungiLista(InpLista3);
   AggiungiLista(InpLista4); AggiungiLista(InpLista5);
   gNT=0; ArrayResize(gTF,0); ArrayResize(gTFn,0);
   AggiungiTF(InpM15,PERIOD_M15,"M15"); AggiungiTF(InpM30,PERIOD_M30,"M30");
   AggiungiTF(InpH1,PERIOD_H1,"H1");    AggiungiTF(InpH4,PERIOD_H4,"H4");
   AggiungiTF(InpH8,PERIOD_H8,"H8");    AggiungiTF(InpH12,PERIOD_H12,"H12");
   AggiungiTF(InpD1,PERIOD_D1,"D1");    AggiungiTF(InpW1,PERIOD_W1,"W1");
   AggiungiTF(InpMN,PERIOD_MN1,"MN");
   if(gNS==0 || gNT==0)
     {
      Print("[PTE leggera] nessun simbolo o nessun timeframe acceso: niente da mostrare.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   gPar.candela=(int)InpCandela;  gPar.tmaModo=(int)InpTmaModo;
   gPar.tmaS=InpTmaLento;         gPar.atrS=InpAtrLento;   gPar.multS=InpMultLento;
   gPar.tmaF=InpTmaVeloce;        gPar.atrF=InpAtrVeloce;  gPar.multF=InpMultVeloce;
   gPar.corpoMaxPct=InpCorpoMaxPct;
   gPar.soloFuori=InpSoloFuoriCanale; gPar.canale=(int)InpCanale;
   gPar.usaCode=InpUsaCode; gPar.rapInf=InpRapCodaInf; gPar.rapSup=InpRapCodaSup;
   gPar.flip=InpConfermaFlip; gPar.semeHA=InpSemeHA;
   gBisogno=PD_Bisogno(gPar,InpBarreIndietro);

   int nc=gNS*gNT;
   ArrayResize(gStatoSim,gNS); ArrayInitialize(gStatoSim,-1);
   ArrayResize(gColSim,gNS);
   ArrayResize(gUltBarra,nc);  ArrayInitialize(gUltBarra,0);
   ArrayResize(gProssimo,nc);  ArrayInitialize(gProssimo,0);
   ArrayResize(gAttesa,nc);    ArrayInitialize(gAttesa,0);
   ArrayResize(gDir,nc);       ArrayInitialize(gDir,0);
   ArrayResize(gTSeg,nc);      ArrayInitialize(gTSeg,0);
   ArrayResize(gPronta,nc);    for(int x=0;x<nc;x++) gPronta[x]=false;
   ArrayResize(gUltAllerta,nc);ArrayInitialize(gUltAllerta,0);
   ArrayResize(gDF,nc);  ArrayResize(gDS,nc);  ArrayResize(gDF1,nc);  ArrayResize(gDS1,nc);
   ArrayInitialize(gDF,0); ArrayInitialize(gDS,0); ArrayInitialize(gDF1,0); ArrayInitialize(gDS1,0);
   ArrayResize(gTxt,nc); ArrayResize(gBg,nc); ArrayResize(gTip,nc);
   ArraySetAsSeries(gR,true);                 // gR[0] = barra in formazione, come gli array del blocco puro

   ObjectsDeleteAll(0,PD_PREF);               // oggetti rimasti da una chiusura anomala
   gProprietario=true;
   gCursore=0; gDoppioVisto=false;
   Struttura();
   AggiornaStatoSimboli();
   gUltStato=TimeCurrent();
   EventSetTimer(1);
   PrintFormat("[PTE leggera] %d simboli x %d TF = %d celle, %d oggetti, %d barre per copia, 0 handle. TMA %s, candele %s, canale %d.",
               gNS,gNT,nc,3+2*gNT+gNS*(1+2*gNT),gBisogno,EnumToString(InpTmaModo),EnumToString(InpCandela),(int)InpCanale);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   if(gProprietario) ObjectsDeleteAll(0,PD_PREF);
   ChartRedraw(0);
  }

void OnTimer()
  {
   datetime ora=TimeCurrent();
   if(!gDoppioVisto) ControllaDoppio();
   if(ora-gUltStato>=60)
     {
      gUltStato=ora;
      if(ObjectFind(0,PD_PREF+"pannello")<0) Struttura();   // oggetti cancellati a mano: si ricostruiscono
      AggiornaStatoSimboli();
     }
   int tot=gNS*gNT, fatte=0, viste=0;
   while(viste<tot && fatte<InpCellePerCiclo)
     {
      int k=gCursore;
      gCursore=(gCursore+1)%tot;
      viste++;
      if(Elabora(k,ora)) fatte++;
     }
   if(gRidisegna)
     {
      gRidisegna=false;
      ChartRedraw(0);
     }
  }

//--- niente calcolo qui: tutto avviene nel timer, a barra nuova
int OnCalculate(const int rates_total,const int prev_calculated,const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],const long &tick_volume[],
                const long &volume[],const int &spread[])
  {
   return(rates_total);
  }
//+------------------------------------------------------------------+
