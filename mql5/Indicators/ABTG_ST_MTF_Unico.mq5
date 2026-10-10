//+------------------------------------------------------------------+
//|                                          ABTG_ST_MTF_Unico.mq5   |
//|                                                                  |
//|  SUPERTREND MULTI-TIMEFRAME con pulsantiera + tasto UNICO.        |
//|  SOLA VISIONE: nessun ordine, nessun trade, nessun file scritto,  |
//|  nessuna GlobalVariable, nessun oggetto ALTRUI toccato: ogni      |
//|  oggetto creato qui inizia con il prefisso "ABTGSTU_" e viene     |
//|  tolto (per nome, uno per uno) all'uscita.                        |
//|                                                                  |
//|  RICOSTRUZIONE dell'indicatore "ST MTF-1" della collega, di cui   |
//|  NON abbiamo il sorgente: solo 3 screenshot dei Dati in Ingresso. |
//|  Nome DIVERSO apposta, per non confonderlo con l'originale.       |
//|  Input: stessi nomi, stessi default, stesso ordine delle sezioni  |
//|  degli screenshot. La descrizione di ogni input comincia col suo  |
//|  NOME, cosi' si confronta riga per riga con l'originale.          |
//|                                                                  |
//|  NOVITA' (richiesta 10/10/2026): tasto UNICO, subito a DESTRA dei |
//|  tre tasti ST (sotto, se la pulsantiera e' in colonna). Lo STESSO |
//|  tasto accende e spegne: se i SuperTrend ABILITATI sono TUTTI     |
//|  accesi -> un clic li spegne tutti; altrimenti (nessuno, uno o    |
//|  due accesi) -> un clic li accende tutti. Viola (InpUnicoOnColor) |
//|  solo quando sono tutti accesi, grigio (InpButtonInactiveColor)   |
//|  negli altri casi; si aggiorna anche coi clic sui tre tasti ST.   |
//|  Un ST disabilitato (InpEnableSTn=false) non ha tasto e non       |
//|  partecipa a UNICO. Con zero ST abilitati UNICO non compare.      |
//|                                                                  |
//|  CALCOLO: SW_STCore ricopiata IDENTICA dalla SuperWave v4.1       |
//|  (ATR = media SEMPLICE del True Range, come iATR di MT5; bande    |
//|  che si stringono soltanto). Per ogni TF acceso: CopyRates delle  |
//|  ultime InpBarsToCalculate barre di QUEL TF, Supertrend sui tre   |
//|  moltiplicatori, livello = valore sulla barra IN FORMAZIONE.      |
//|  Il calcolo gira nel TIMER (ogni InpTimerSeconds), mai a ogni     |
//|  tick; un TF si ricalcola solo se la sua ultima barra e' cambiata.|
//|  Dati non ancora caricati = quel TF salta il giro (nessuna linea  |
//|  inventata), riprova al giro dopo.                                |
//|                                                                  |
//|  DEDUZIONI dagli screenshot (l'originale NON e' visibile):        |
//|  [DEDOTTO 1] Tasto principale "ST MTF" (InpMainButtonWidth):      |
//|     mostra/nasconde la pulsantiera; le LINEE restano come sono.   |
//|     Verde (InpButtonMainColor) a pannello aperto, rosso           |
//|     (InpButtonOffColor) a pannello chiuso.                        |
//|  [DEDOTTO 2] 11 tasti TF (M1 M3 M5 M15 M30 H1 H4 H12 D1 W1 MN1,   |
//|     InpTFButtonWidth): acceso = InpButtonOnColor, spento =        |
//|     InpButtonInactiveColor. M3 e H12 sono TF NATIVI di MT5        |
//|     (PERIOD_M3, PERIOD_H12).                                      |
//|  [DEDOTTO 3] 3 tasti "ST 2.5" "ST 3.0" "ST 3.5" (InpSTButton-     |
//|     Width): acceso = InpButtonSTActiveColor, spento = Inactive.   |
//|  [DEDOTTO 4] Tasto comando "DEFAULT" (InpCommandButtonWidth,      |
//|     InpButtonDefaultColor): rimette TF e ST ai valori DEFAULT.    |
//|  [DEDOTTO 5] Ordine: ST MTF | 11 TF | 3 ST | UNICO | DEFAULT.     |
//|  [DEDOTTO 6] Una linea ORIZZONTALE (OBJ_HLINE) per ogni TF acceso |
//|     x ST acceso, al livello attuale del Supertrend di quel TF,    |
//|     colore del TF, stile/spessore del suo ST.                     |
//|  [DEDOTTO 7] Etichetta: "<TF> <molt> VERDE|ROSSO [prezzo]",       |
//|     a InpLabelRightOffsetPx px dal bordo DESTRO del grafico,      |
//|     InpLabelVerticalOffsetPx px rispetto alla linea (-8 = sopra). |
//|     Colore: InpLabelSameColorAsLine vince, poi InpLabelColor-     |
//|     ByTrend (su/giu'), altrimenti InpFixedLabelColor.             |
//|     Le etichette NON si impilano: due linee vicine = scritte      |
//|     sovrapposte.                                                  |
//|  [DEDOTTO 8] Stato dei tasti conservato al cambio di simbolo/TF   |
//|     (in un oggetto INVISIBILE del grafico, niente file); si       |
//|     riparte dai DEFAULT quando cambi i parametri o rimetti        |
//|     l'indicatore.                                                 |
//|  [DEDOTTO 9] Ordine degli input "Stile Linee": Style1/2/3 e poi   |
//|     Width1/2/3 (come elencato; l'originale potrebbe alternarli).  |
//|                                                                  |
//|  Angoli diversi da CORNER_LEFT_UPPER: NON provati su terminale.   |
//|  Una sola istanza per grafico (due istanze si contenderebbero gli |
//|  stessi nomi). Installazione: copia in MQL5\Indicators,           |
//|  MetaEditor, F7 (atteso: 0 errori, 0 avvisi), trascina sul        |
//|  grafico. Note: report/ST_MTF_UNICO_NOTE_2026-10-10.md            |
//+------------------------------------------------------------------+
#property copyright   "Progetto EA Aperture Mercati"
#property version     "1.00"
#property description "SuperTrend multi-timeframe con pulsantiera e tasto UNICO (accende/spegne i tre ST)."
#property description "Sola visione: nessun ordine, nessun file. Ricostruzione di 'ST MTF-1' (nome diverso)."
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

#define PFX           "ABTGSTU_"           // prefisso UNICO di tutti gli oggetti creati qui
#define STU_NTF       11                   // timeframe della pulsantiera
#define STU_NST       3                    // SuperTrend (2.5 / 3.0 / 3.5)
#define STU_MAXB      17                   // tasti massimi: 1 + 11 + 3 + UNICO + DEFAULT
#define STU_YNUOVA    (-2)                 // etichetta mai posizionata
#define STU_YNASCOSTA (-1)                 // etichetta nascosta (linea fuori schermo)
#define STU_COL_UNSET ((color)0xFF000000)  // colore "mai impostato" per le cache

//=== Layout Pulsantiera ===
input group "=== Layout Pulsantiera ==="
input ENUM_BASE_CORNER InpCorner           = CORNER_LEFT_UPPER; // InpCorner - angolo della pulsantiera
input int              InpOffsetX          = 10;                // InpOffsetX - distanza orizzontale dall'angolo (px)
input int              InpOffsetY          = 50;                // InpOffsetY - distanza verticale dall'angolo (px)
input bool             InpHorizontalLayout = true;              // InpHorizontalLayout - tasti in riga (false = in colonna)
input int              InpButtonPadding    = 1;                 // InpButtonPadding - spazio fra i tasti (px)

//=== Dimensioni UI ===
input group "=== Dimensioni UI ==="
input int    InpTFButtonWidth      = 42;      // InpTFButtonWidth - larghezza tasti timeframe (px)
input int    InpSTButtonWidth      = 72;      // InpSTButtonWidth - larghezza tasti SuperTrend (px)
input int    InpButtonHeight       = 24;      // InpButtonHeight - altezza dei tasti (px)
input int    InpMainButtonWidth    = 64;      // InpMainButtonWidth - larghezza tasto principale (px)
input int    InpCommandButtonWidth = 86;      // InpCommandButtonWidth - larghezza tasto comando DEFAULT (px)
input int    InpButtonFontSize     = 9;       // InpButtonFontSize - dimensione testo dei tasti
input string InpButtonFont         = "Arial"; // InpButtonFont - carattere dei tasti

//=== Parametri SuperTrend ===
input group "=== Parametri SuperTrend ==="
input int    InpSTPeriod        = 10;   // InpSTPeriod - periodo ATR del SuperTrend
input double InpSTMultiplier1   = 2.5;  // InpSTMultiplier1 - moltiplicatore SuperTrend 1
input double InpSTMultiplier2   = 3.0;  // InpSTMultiplier2 - moltiplicatore SuperTrend 2
input double InpSTMultiplier3   = 3.5;  // InpSTMultiplier3 - moltiplicatore SuperTrend 3
input int    InpBarsToCalculate = 500;  // InpBarsToCalculate - barre lette per ogni timeframe

//=== Abilita SuperTrend ===
input group "=== Abilita SuperTrend ==="
input bool   InpEnableST1 = true;   // InpEnableST1 - SuperTrend 1 disponibile (tasto presente)
input bool   InpEnableST2 = true;   // InpEnableST2 - SuperTrend 2 disponibile (tasto presente)
input bool   InpEnableST3 = true;   // InpEnableST3 - SuperTrend 3 disponibile (tasto presente)

//=== DEFAULT SuperTrend Attivi ===
input group "=== DEFAULT SuperTrend Attivi ==="
input bool   InpDefaultST1 = false; // InpDefaultST1 - SuperTrend 1 acceso all'avvio / con DEFAULT
input bool   InpDefaultST2 = false; // InpDefaultST2 - SuperTrend 2 acceso all'avvio / con DEFAULT
input bool   InpDefaultST3 = true;  // InpDefaultST3 - SuperTrend 3 acceso all'avvio / con DEFAULT

//=== Opzioni Avanzate ===
input group "=== Opzioni Avanzate ==="
input bool   InpOnlyPanelNoLines    = false; // InpOnlyPanelNoLines - solo pulsantiera, nessuna linea
input bool   InpLinesInForeground   = true;  // InpLinesInForeground - linee sopra le candele
input bool   InpPanelVisibleAtStart = true;  // InpPanelVisibleAtStart - pulsantiera aperta all'avvio
input int    InpTimerSeconds        = 1;     // InpTimerSeconds - aggiornamento ogni N secondi

//=== Stile Linee SuperTrend ===
input group "=== Stile Linee SuperTrend ==="
input ENUM_LINE_STYLE InpSTLineStyle1 = STYLE_DASH; // InpSTLineStyle1 - stile linee SuperTrend 1
input ENUM_LINE_STYLE InpSTLineStyle2 = STYLE_DASH; // InpSTLineStyle2 - stile linee SuperTrend 2
input ENUM_LINE_STYLE InpSTLineStyle3 = STYLE_DASH; // InpSTLineStyle3 - stile linee SuperTrend 3
input int             InpSTLineWidth1 = 1;          // InpSTLineWidth1 - spessore linee SuperTrend 1
input int             InpSTLineWidth2 = 1;          // InpSTLineWidth2 - spessore linee SuperTrend 2
input int             InpSTLineWidth3 = 1;          // InpSTLineWidth3 - spessore linee SuperTrend 3

//=== Colori Linee per Timeframe ===
input group "=== Colori Linee per Timeframe ==="
input color  InpColorM1  = clrSilver;      // InpColorM1 - colore linee M1
input color  InpColorM3  = clrDeepSkyBlue; // InpColorM3 - colore linee M3
input color  InpColorM5  = clrWhite;       // InpColorM5 - colore linee M5
input color  InpColorM15 = clrYellow;      // InpColorM15 - colore linee M15
input color  InpColorM30 = clrTan;         // InpColorM30 - colore linee M30
input color  InpColorH1  = clrRoyalBlue;   // InpColorH1 - colore linee H1
input color  InpColorH4  = clrRed;         // InpColorH4 - colore linee H4
input color  InpColorH12 = clrLightCoral;  // InpColorH12 - colore linee H12
input color  InpColorD1  = clrLime;        // InpColorD1 - colore linee D1
input color  InpColorW1  = clrOrange;      // InpColorW1 - colore linee W1
input color  InpColorMN1 = clrAqua;        // InpColorMN1 - colore linee MN1

//=== Label Livelli SuperTrend ===
input group "=== Label Livelli SuperTrend ==="
input bool   InpShowLevelLabels        = true;           // InpShowLevelLabels - scritta accanto a ogni linea
input string InpLabelFont              = "Arial Narrow"; // InpLabelFont - carattere delle scritte
input int    InpLabelFontSize          = 8;              // InpLabelFontSize - dimensione delle scritte
input bool   InpLabelShowMultiplier    = true;           // InpLabelShowMultiplier - scrivi il moltiplicatore
input bool   InpLabelShowPrice         = false;          // InpLabelShowPrice - scrivi il prezzo del livello
input string InpLabelUpText            = "VERDE";        // InpLabelUpText - testo trend al rialzo
input string InpLabelDownText          = "ROSSO";        // InpLabelDownText - testo trend al ribasso
input bool   InpLabelColorByTrend      = true;           // InpLabelColorByTrend - colore della scritta dal trend
input color  InpLabelUpColor           = clrLime;        // InpLabelUpColor - colore scritta trend al rialzo
input color  InpLabelDownColor         = clrRed;         // InpLabelDownColor - colore scritta trend al ribasso
input bool   InpLabelSameColorAsLine   = false;          // InpLabelSameColorAsLine - scritta del colore della linea
input color  InpFixedLabelColor        = clrWhite;       // InpFixedLabelColor - colore fisso della scritta
input int    InpLabelRightOffsetPx     = 280;            // InpLabelRightOffsetPx - distanza dal bordo destro (px)
input int    InpLabelVerticalOffsetPx  = -8;             // InpLabelVerticalOffsetPx - spostamento verticale (px, negativo = sopra)

//=== DEFAULT Timeframe Attivi ===
input group "=== DEFAULT Timeframe Attivi ==="
input bool   InpDefaultM1  = false; // InpDefaultM1 - M1 acceso all'avvio / con DEFAULT
input bool   InpDefaultM3  = false; // InpDefaultM3 - M3 acceso all'avvio / con DEFAULT
input bool   InpDefaultM5  = false; // InpDefaultM5 - M5 acceso all'avvio / con DEFAULT
input bool   InpDefaultM15 = false; // InpDefaultM15 - M15 acceso all'avvio / con DEFAULT
input bool   InpDefaultM30 = false; // InpDefaultM30 - M30 acceso all'avvio / con DEFAULT
input bool   InpDefaultH1  = true;  // InpDefaultH1 - H1 acceso all'avvio / con DEFAULT
input bool   InpDefaultH4  = true;  // InpDefaultH4 - H4 acceso all'avvio / con DEFAULT
input bool   InpDefaultH12 = true;  // InpDefaultH12 - H12 acceso all'avvio / con DEFAULT
input bool   InpDefaultD1  = true;  // InpDefaultD1 - D1 acceso all'avvio / con DEFAULT
input bool   InpDefaultW1  = false; // InpDefaultW1 - W1 acceso all'avvio / con DEFAULT
input bool   InpDefaultMN1 = false; // InpDefaultMN1 - MN1 acceso all'avvio / con DEFAULT

//=== Colori Pulsanti ===
input group "=== Colori Pulsanti ==="
input color  InpButtonTextColor     = clrWhite;       // InpButtonTextColor - testo dei tasti
input color  InpButtonInactiveColor = clrDimGray;     // InpButtonInactiveColor - tasto spento
input color  InpButtonMainColor     = clrForestGreen; // InpButtonMainColor - tasto principale (pulsantiera aperta)
input color  InpButtonOnColor       = clrLime;        // InpButtonOnColor - tasto timeframe acceso
input color  InpButtonOffColor      = clrRed;         // InpButtonOffColor - tasto principale (pulsantiera chiusa)
input color  InpButtonDefaultColor  = clrRoyalBlue;   // InpButtonDefaultColor - tasto DEFAULT
input color  InpButtonSTActiveColor = clrCrimson;     // InpButtonSTActiveColor - tasto SuperTrend acceso

//=== Pulsante UNICO (NUOVO) ===
input group "=== Pulsante UNICO ==="
input bool   InpShowUnico    = true;          // InpShowUnico - mostra il tasto UNICO (accende/spegne i tre ST)
input string InpUnicoText    = "UNICO";       // InpUnicoText - testo del tasto UNICO
input int    InpUnicoWidth   = 64;            // InpUnicoWidth - larghezza del tasto UNICO (px)
input color  InpUnicoOnColor = clrDarkViolet; // InpUnicoOnColor - colore UNICO quando i tre ST sono accesi

//+------------------------------------------------------------------+
//| STATO                                                            |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES gTf[STU_NTF]     = {PERIOD_M1,PERIOD_M3,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,
                                    PERIOD_H4,PERIOD_H12,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
string          gTfName[STU_NTF] = {"M1","M3","M5","M15","M30","H1","H4","H12","D1","W1","MN1"};
color           gTfCol[STU_NTF];
bool            gTfDef[STU_NTF];
bool            gTfOn[STU_NTF];

double          gMult[STU_NST];
bool            gStEn[STU_NST];
bool            gStDef[STU_NST];
bool            gStOn[STU_NST];
ENUM_LINE_STYLE gStSty[STU_NST];
int             gStW[STU_NST];

bool   gPanel   = true;
bool   gInitOk  = false;
bool   gTimerOk = false;
uint   gLastUpdMs = 0;
int    gPer = 10, gBars = 500, gTimerSec = 1;
int    gWTf = 42, gWSt = 72, gBH = 24, gWMain = 64, gWCmd = 86, gWUni = 64, gPad = 1, gFs = 9, gLabFs = 8;

//--- livelli calcolati: [TF][ST]
double gLv[STU_NTF][STU_NST];
int    gLd[STU_NTF][STU_NST];
bool   gLok[STU_NTF][STU_NST];
//--- chiave della finestra gia' calcolata, per TF (si ricalcola solo se cambia)
bool     gKeyOk[STU_NTF];
int      gKeyN[STU_NTF];
datetime gKeyT0[STU_NTF];
datetime gKeyT1[STU_NTF];
double   gKeyH[STU_NTF];
double   gKeyL[STU_NTF];
double   gKeyC[STU_NTF];
//--- cio' che e' DISEGNATO (si scrive un oggetto solo se cambia)
bool   gDrOk[STU_NTF][STU_NST];
double gDrV[STU_NTF][STU_NST];
int    gDrD[STU_NTF][STU_NST];
int    gLabY[STU_NTF][STU_NST];
string gLabTxt[STU_NTF][STU_NST];
color  gLabCol[STU_NTF][STU_NST];

//--- tasti visibili in questo momento (ordine = ordine a schermo)
string gBN[STU_MAXB];
string gBT[STU_MAXB];
string gBTip[STU_MAXB];
int    gBW[STU_MAXB];
color  gBC[STU_MAXB];
int    gBNum = 0;

//--- lavoro del calcolo (riusati)
double wH[], wL[], wC[], wA[], wU[], wD[], wDir[], wV[];

//==================================================================//
//  FUNZIONI PURE: nessuna chiamata al terminale. Il collaudo        //
//  (backtest_pipeline/collaudo_st_mtf_unico.py) le ESTRAE da qui,    //
//  le compila come C++ e prova la tabella di verita' di UNICO.       //
//  SW_STCore e' la COPIA IDENTICA di quella della SuperWave v4.1:    //
//  il collaudo controlla che lo resti, carattere per carattere.      //
//==================================================================//
//@@STU_PURE_BEGIN
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

//--- UNICO e' ACCESO solo se ogni SuperTrend ABILITATO e' acceso (e ne esiste almeno uno abilitato).
//    e1..e3 = abilitato (InpEnableSTn), o1..o3 = acceso adesso.
bool UNI_Acceso(const bool e1,const bool e2,const bool e3,const bool o1,const bool o2,const bool o3)
  {
   if(!e1 && !e2 && !e3) return false;
   if(e1 && !o1) return false;
   if(e2 && !o2) return false;
   if(e3 && !o3) return false;
   return true;
  }

//--- clic su UNICO, LO STESSO TASTO: tutti gli abilitati accesi -> si spengono tutti;
//    altrimenti (nessuno, uno o due accesi) -> si accendono tutti. I disabilitati non si toccano.
void UNI_Clic(const bool e1,const bool e2,const bool e3,bool &o1,bool &o2,bool &o3)
  {
   bool target=!UNI_Acceso(e1,e2,e3,o1,o2,o3);
   if(e1) o1=target;
   if(e2) o2=target;
   if(e3) o3=target;
  }

//--- coordinata in pixel dall'angolo scelto. Tasti: punto di ancoraggio in ALTO A SINISTRA, quindi
//    negli angoli DESTRI (o BASSI) la distanza e' dal bordo al lato sinistro (alto) del tasto:
//    off + tot - pos. 'pos' = posizione logica da sinistra (dall'alto), 'tot' = ingombro totale.
int STU_Coord(const bool inverti,const int off,const int tot,const int pos)
  {
   if(inverti) return off+tot-pos;
   return off+pos;
  }
//@@STU_PURE_END

//+------------------------------------------------------------------+
//| UTILITA'                                                         |
//+------------------------------------------------------------------+
// moltiplicatore scritto come nei vocali: 2.5 / 3.0 / 3.5 (due decimali solo se servono, es. 2.25)
string MoltTxt(const double m)
  {
   bool unDec=(MathAbs(m*10.0-MathRound(m*10.0))<1e-9);
   return DoubleToString(m,unDec ? 1 : 2);
  }

string NameState()            { return PFX+"STATO"; }
string NameMain()             { return PFX+"B_MAIN"; }
string NameTF(const int i)    { return PFX+"B_TF"+IntegerToString(i); }
string NameST(const int j)    { return PFX+"B_ST"+IntegerToString(j); }
string NameUnico()            { return PFX+"B_UNICO"; }
string NameDef()              { return PFX+"B_DEF"; }
string NameL(const int i,const int j) { return PFX+"L"+IntegerToString(i)+"_"+IntegerToString(j); }
string NameT(const int i,const int j) { return PFX+"T"+IntegerToString(i)+"_"+IntegerToString(j); }

void DelObj(const string nm)
  {
   if(ObjectFind(0,nm)>=0)
      ObjectDelete(0,nm);
  }

int ClampInt(const int v,const int lo,const int hi)
  {
   if(v<lo) return lo;
   if(v>hi) return hi;
   return v;
  }

int NumStEn()
  {
   int n=0;
   for(int j=0;j<STU_NST;j++)
      if(gStEn[j]) n++;
   return n;
  }

bool AnyStOn()
  {
   for(int j=0;j<STU_NST;j++)
      if(gStEn[j] && gStOn[j]) return true;
   return false;
  }

bool UnicoOn()
  {
   return UNI_Acceso(gStEn[0],gStEn[1],gStEn[2],gStOn[0],gStOn[1],gStOn[2]);
  }

void ApplyDefaults()
  {
   for(int i=0;i<STU_NTF;i++)
      gTfOn[i]=gTfDef[i];
   for(int j=0;j<STU_NST;j++)
      gStOn[j]=(gStDef[j] && gStEn[j]);
  }

//+------------------------------------------------------------------+
//| STATO DEI TASTI tra un cambio di simbolo/TF e l'altro            |
//| Un OBJ_LABEL INVISIBILE (OBJ_NO_PERIODS) col testo               |
//| "STU1|P|TTTTTTTTTTT|SSS" (22 caratteri). Niente file, niente     |
//| GlobalVariable. Tolto all'uscita, tranne al cambio simbolo/TF.   |
//+------------------------------------------------------------------+
string StateEncode()
  {
   string s="STU1|";
   s+=(gPanel ? "1" : "0");
   s+="|";
   for(int i=0;i<STU_NTF;i++)
      s+=(gTfOn[i] ? "1" : "0");
   s+="|";
   for(int j=0;j<STU_NST;j++)
      s+=(gStOn[j] ? "1" : "0");
   return s;
  }

bool Is01(const ushort ch)
  {
   return (ch=='0' || ch=='1');
  }

// prima si VALIDA tutto, poi si assegna: un testo storto non tocca niente
bool StateDecode(const string s)
  {
   if(StringLen(s)!=22) return false;
   if(StringSubstr(s,0,5)!="STU1|") return false;
   if(StringGetCharacter(s,6)!='|' || StringGetCharacter(s,18)!='|') return false;
   if(!Is01(StringGetCharacter(s,5))) return false;
   for(int i=0;i<STU_NTF;i++)
      if(!Is01(StringGetCharacter(s,7+i))) return false;
   for(int j=0;j<STU_NST;j++)
      if(!Is01(StringGetCharacter(s,19+j))) return false;
   gPanel=(StringGetCharacter(s,5)=='1');
   for(int i=0;i<STU_NTF;i++)
      gTfOn[i]=(StringGetCharacter(s,7+i)=='1');
   for(int j=0;j<STU_NST;j++)
      gStOn[j]=(StringGetCharacter(s,19+j)=='1' && gStEn[j]);
   return true;
  }

void SaveState()
  {
   string nm=NameState();
   if(ObjectFind(0,nm)<0)
     {
      if(!ObjectCreate(0,nm,OBJ_LABEL,0,0,0))
         return;                                  // senza memoria si vive lo stesso: al cambio TF, DEFAULT
      ObjectSetInteger(0,nm,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
     }
   ObjectSetString(0,nm,OBJPROP_TEXT,StateEncode());
  }

//+------------------------------------------------------------------+
//| PULSANTIERA                                                      |
//+------------------------------------------------------------------+
void BAdd(const string nm,const string tx,const int wd,const color bg,const string tip)
  {
   if(gBNum>=STU_MAXB) return;
   gBN[gBNum]=nm;
   gBT[gBNum]=tx;
   gBW[gBNum]=wd;
   gBC[gBNum]=bg;
   gBTip[gBNum]=tip;
   gBNum++;
  }

bool InList(const string nm)
  {
   for(int k=0;k<gBNum;k++)
      if(gBN[k]==nm) return true;
   return false;
  }

void MakeButton(const int k,const int xd,const int yd)
  {
   string nm=gBN[k];
   if(ObjectFind(0,nm)<0)
     {
      if(!ObjectCreate(0,nm,OBJ_BUTTON,0,0,0))
        {
         Print("ABTG_ST_MTF_Unico: creazione tasto fallita (",gBT[k],"), errore ",GetLastError());
         return;
        }
      ObjectSetInteger(0,nm,OBJPROP_SELECTABLE,false);
      ObjectSetInteger(0,nm,OBJPROP_HIDDEN,true);
      ObjectSetInteger(0,nm,OBJPROP_BACK,false);
      ObjectSetInteger(0,nm,OBJPROP_ZORDER,10);
     }
   ObjectSetInteger(0,nm,OBJPROP_CORNER,InpCorner);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,xd);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,yd);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,gBW[k]);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,gBH);
   ObjectSetString(0,nm,OBJPROP_FONT,InpButtonFont);
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,gFs);
   ObjectSetString(0,nm,OBJPROP_TEXT,gBT[k]);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,InpButtonTextColor);
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,gBC[k]);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,InpButtonTextColor);
   ObjectSetInteger(0,nm,OBJPROP_STATE,false);     // il clic lo preme: lo stato si legge dal colore
   ObjectSetString(0,nm,OBJPROP_TOOLTIP,gBTip[k]);
  }

// elenco dei tasti visibili, nell'ordine a schermo; toglie quelli che non servono piu'; li posa
void BuildButtons()
  {
   gBNum=0;
   BAdd(NameMain(),"ST MTF",gWMain,gPanel ? InpButtonMainColor : InpButtonOffColor,
        gPanel ? "Pulsantiera aperta (clic = chiudi)" : "Pulsantiera chiusa (clic = apri)");
   if(gPanel)
     {
      for(int i=0;i<STU_NTF;i++)
         BAdd(NameTF(i),gTfName[i],gWTf,gTfOn[i] ? InpButtonOnColor : InpButtonInactiveColor,
              gTfName[i]+(gTfOn[i] ? ": ACCESO (clic = spegni)" : ": spento (clic = accendi)"));
      for(int j=0;j<STU_NST;j++)
         if(gStEn[j])
            BAdd(NameST(j),"ST "+MoltTxt(gMult[j]),gWSt,gStOn[j] ? InpButtonSTActiveColor : InpButtonInactiveColor,
                 "SuperTrend "+MoltTxt(gMult[j])+(gStOn[j] ? ": ACCESO (clic = spegni)" : ": spento (clic = accendi)"));
      if(InpShowUnico && NumStEn()>0)
        {
         bool u=UnicoOn();
         BAdd(NameUnico(),InpUnicoText,gWUni,u ? InpUnicoOnColor : InpButtonInactiveColor,
              u ? "UNICO: tutti i SuperTrend ACCESI (clic = spegni tutti)"
                : "UNICO: non tutti accesi (clic = accendi tutti)");
        }
      BAdd(NameDef(),"DEFAULT",gWCmd,InpButtonDefaultColor,"Rimette timeframe e SuperTrend ai valori DEFAULT");
     }
   //--- via i tasti che non sono nell'elenco (pulsantiera chiusa, ST disabilitato, UNICO nascosto)
   if(!InList(NameMain())) DelObj(NameMain());
   for(int i=0;i<STU_NTF;i++)
      if(!InList(NameTF(i))) DelObj(NameTF(i));
   for(int j=0;j<STU_NST;j++)
      if(!InList(NameST(j))) DelObj(NameST(j));
   if(!InList(NameUnico())) DelObj(NameUnico());
   if(!InList(NameDef())) DelObj(NameDef());
   //--- posizioni logiche da sinistra/dall'alto
   int lx[STU_MAXB];
   int ly[STU_MAXB];
   int x=0, y=0, totW=0, totH=0;
   for(int k=0;k<gBNum;k++)
     {
      lx[k]=x;
      ly[k]=y;
      if(InpHorizontalLayout)
        {
         x+=gBW[k]+gPad;
         totW=lx[k]+gBW[k];
         totH=gBH;
        }
      else
        {
         y+=gBH+gPad;
         totH=ly[k]+gBH;
         if(gBW[k]>totW) totW=gBW[k];
        }
     }
   bool destro=(InpCorner==CORNER_RIGHT_UPPER || InpCorner==CORNER_RIGHT_LOWER);
   bool basso =(InpCorner==CORNER_LEFT_LOWER  || InpCorner==CORNER_RIGHT_LOWER);
   for(int k=0;k<gBNum;k++)
      MakeButton(k,STU_Coord(destro,InpOffsetX,totW,lx[k]),STU_Coord(basso,InpOffsetY,totH,ly[k]));
  }

bool ButtonsMissing()
  {
   for(int k=0;k<gBNum;k++)
      if(ObjectFind(0,gBN[k])<0) return true;
   return false;
  }

//+------------------------------------------------------------------+
//| CALCOLO: un TF. 1 = ricalcolato, 0 = invariato, -1 = dati non    |
//| pronti (si salta il giro, restano gli ultimi valori buoni).       |
//+------------------------------------------------------------------+
int CalcTF(const int i)
  {
   MqlRates r[];
   ArraySetAsSeries(r,false);
   ResetLastError();
   int got=CopyRates(_Symbol,gTf[i],0,gBars,r);   // dalla barra IN FORMAZIONE indietro
   if(got<gPer+2 || ArraySize(r)<got)
      return -1;
   //--- finestra corta: buona solo se la serie e' sincronizzata (e' tutto lo storico che c'e')
   if(got<gBars && SeriesInfoInteger(_Symbol,gTf[i],SERIES_SYNCHRONIZED)==0)
      return -1;
   int last=got-1;
   if(gKeyOk[i] && gKeyN[i]==got && gKeyT0[i]==r[0].time && gKeyT1[i]==r[last].time &&
      gKeyH[i]==r[last].high && gKeyL[i]==r[last].low && gKeyC[i]==r[last].close)
      return 0;
   if(ArraySize(wH)<got)
     {
      if(ArrayResize(wH,got)<got || ArrayResize(wL,got)<got || ArrayResize(wC,got)<got ||
         ArrayResize(wA,got)<got || ArrayResize(wU,got)<got || ArrayResize(wD,got)<got ||
         ArrayResize(wDir,got)<got || ArrayResize(wV,got)<got)
         return -1;
     }
   for(int k=0;k<got;k++)
     {
      wH[k]=r[k].high;
      wL[k]=r[k].low;
      wC[k]=r[k].close;
     }
   bool allOk=true;
   for(int j=0;j<STU_NST;j++)
     {
      if(!gStEn[j])
        {
         gLok[i][j]=false;
         continue;
        }
      SW_STCore(wH,wL,wC,got,0,gPer,gMult[j],wA,wU,wD,wDir,wV);
      double v=wV[last];
      double d=wDir[last];
      if(d==0.0 || !MathIsValidNumber(v) || v<=0.0)
        {
         allOk=false;                              // MAI un valore inventato: resta l'ultimo buono
         continue;
        }
      gLv[i][j]=v;
      gLd[i][j]=(d>0.0) ? 1 : -1;
      gLok[i][j]=true;
     }
   if(!allOk)
      return -1;                                   // chiave non salvata: si riprova al giro dopo
   gKeyOk[i]=true;
   gKeyN[i]=got;
   gKeyT0[i]=r[0].time;
   gKeyT1[i]=r[last].time;
   gKeyH[i]=r[last].high;
   gKeyL[i]=r[last].low;
   gKeyC[i]=r[last].close;
   return 1;
  }

//+------------------------------------------------------------------+
//| DISEGNO: linee + etichette, scritte solo se cambia qualcosa      |
//+------------------------------------------------------------------+
string LineTip(const int i,const int j)
  {
   return gTfName[i]+" SuperTrend "+MoltTxt(gMult[j])+" ("+IntegerToString(gPer)+") "+
          ((gLd[i][j]>0) ? InpLabelUpText : InpLabelDownText)+" "+DoubleToString(gLv[i][j],_Digits);
  }

string LabelText(const int i,const int j)
  {
   string s=gTfName[i];
   if(InpLabelShowMultiplier)
      s+=" "+MoltTxt(gMult[j]);
   s+=" "+((gLd[i][j]>0) ? InpLabelUpText : InpLabelDownText);
   if(InpLabelShowPrice)
      s+=" "+DoubleToString(gLv[i][j],_Digits);
   return s;
  }

color LabelColor(const int i,const int j)
  {
   if(InpLabelSameColorAsLine)
      return gTfCol[i];
   if(InpLabelColorByTrend)
      return (gLd[i][j]>0) ? InpLabelUpColor : InpLabelDownColor;
   return InpFixedLabelColor;
  }

bool RenderLines()
  {
   bool chg=false;
   for(int i=0;i<STU_NTF;i++)
      for(int j=0;j<STU_NST;j++)
        {
         string nl=NameL(i,j);
         string nt=NameT(i,j);
         bool want=(!InpOnlyPanelNoLines && gTfOn[i] && gStEn[j] && gStOn[j] && gLok[i][j]);
         if(!want)
           {
            if(ObjectFind(0,nl)>=0) { ObjectDelete(0,nl); chg=true; }
            if(ObjectFind(0,nt)>=0) { ObjectDelete(0,nt); chg=true; }
            gDrOk[i][j]=false;
            gLabY[i][j]=STU_YNUOVA;
            continue;
           }
         //--- linea
         bool fresh=false;
         if(ObjectFind(0,nl)<0)
           {
            if(!ObjectCreate(0,nl,OBJ_HLINE,0,0,gLv[i][j]))
               continue;
            ObjectSetInteger(0,nl,OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,nl,OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,nl,OBJPROP_BACK,!InpLinesInForeground);
            ObjectSetInteger(0,nl,OBJPROP_COLOR,gTfCol[i]);
            ObjectSetInteger(0,nl,OBJPROP_STYLE,gStSty[j]);
            ObjectSetInteger(0,nl,OBJPROP_WIDTH,gStW[j]);
            fresh=true;
            chg=true;
           }
         if(fresh || !gDrOk[i][j] || gDrV[i][j]!=gLv[i][j] || gDrD[i][j]!=gLd[i][j])
           {
            ObjectSetDouble(0,nl,OBJPROP_PRICE,gLv[i][j]);
            ObjectSetString(0,nl,OBJPROP_TOOLTIP,LineTip(i,j));
            gDrV[i][j]=gLv[i][j];
            gDrD[i][j]=gLd[i][j];
            gDrOk[i][j]=true;
            gLabY[i][j]=STU_YNUOVA;                // livello mosso: l'etichetta va riposata
            chg=true;
           }
         //--- etichetta
         if(!InpShowLevelLabels)
           {
            if(ObjectFind(0,nt)>=0) { ObjectDelete(0,nt); chg=true; }
            continue;
           }
         if(ObjectFind(0,nt)<0)
           {
            if(!ObjectCreate(0,nt,OBJ_LABEL,0,0,0))
               continue;
            ObjectSetInteger(0,nt,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
            ObjectSetInteger(0,nt,OBJPROP_ANCHOR,ANCHOR_LEFT);
            ObjectSetInteger(0,nt,OBJPROP_XDISTANCE,ClampInt(InpLabelRightOffsetPx,0,10000));
            ObjectSetInteger(0,nt,OBJPROP_YDISTANCE,0);
            ObjectSetString(0,nt,OBJPROP_FONT,InpLabelFont);
            ObjectSetInteger(0,nt,OBJPROP_FONTSIZE,gLabFs);
            ObjectSetInteger(0,nt,OBJPROP_SELECTABLE,false);
            ObjectSetInteger(0,nt,OBJPROP_HIDDEN,true);
            ObjectSetInteger(0,nt,OBJPROP_BACK,false);
            ObjectSetInteger(0,nt,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);   // invisibile finche' non e' posata
            gLabY[i][j]=STU_YNUOVA;
            gLabTxt[i][j]="";
            gLabCol[i][j]=STU_COL_UNSET;
            chg=true;
           }
         string tx=LabelText(i,j);
         if(tx!=gLabTxt[i][j])
           {
            ObjectSetString(0,nt,OBJPROP_TEXT,tx);
            gLabTxt[i][j]=tx;
            chg=true;
           }
         color lc=LabelColor(i,j);
         if(lc!=gLabCol[i][j])
           {
            ObjectSetInteger(0,nt,OBJPROP_COLOR,lc);
            gLabCol[i][j]=lc;
            chg=true;
           }
        }
   return chg;
  }

// etichette all'altezza della loro linea (+ InpLabelVerticalOffsetPx); nascoste se la linea e' fuori
// dallo schermo. Si muove un oggetto solo se cambia la sua Y.
bool PlaceLabels()
  {
   if(InpOnlyPanelNoLines || !InpShowLevelLabels)
      return false;
   datetime t=iTime(_Symbol,_Period,0);
   if(t<=0)
      t=TimeCurrent();
   int hgt=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS,0);
   bool chg=false;
   for(int i=0;i<STU_NTF;i++)
      for(int j=0;j<STU_NST;j++)
        {
         string nt=NameT(i,j);
         if(!gDrOk[i][j] || ObjectFind(0,nt)<0)
            continue;
         int x=0, y=0;
         bool ok=ChartTimePriceToXY(0,0,t,gLv[i][j],x,y);
         int want=STU_YNASCOSTA;
         if(ok && y>=0 && (hgt<=0 || y<=hgt))
           {
            want=y+InpLabelVerticalOffsetPx;
            if(want<0)
               want=0;
           }
         if(want==gLabY[i][j])
            continue;
         if(want==STU_YNASCOSTA)
            ObjectSetInteger(0,nt,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
         else
           {
            ObjectSetInteger(0,nt,OBJPROP_YDISTANCE,want);
            if(gLabY[i][j]<0)
               ObjectSetInteger(0,nt,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
           }
         gLabY[i][j]=want;
         chg=true;
        }
   return chg;
  }

// un giro completo: calcolo dei TF accesi (solo se serve) + disegno. true = qualcosa e' cambiato
bool UpdateAll()
  {
   if(!InpOnlyPanelNoLines && AnyStOn())
      for(int i=0;i<STU_NTF;i++)
         if(gTfOn[i])
            CalcTF(i);
   bool chg=false;
   if(RenderLines())
      chg=true;
   if(PlaceLabels())
      chg=true;
   return chg;
  }

// toglie TUTTO cio' che puo' aver creato questo indicatore, per NOME (nessun ObjectsDeleteAll)
void DeleteAllOurs(const bool keepState)
  {
   DelObj(NameMain());
   for(int i=0;i<STU_NTF;i++)
      DelObj(NameTF(i));
   for(int j=0;j<STU_NST;j++)
      DelObj(NameST(j));
   DelObj(NameUnico());
   DelObj(NameDef());
   for(int i=0;i<STU_NTF;i++)
      for(int j=0;j<STU_NST;j++)
        {
         DelObj(NameL(i,j));
         DelObj(NameT(i,j));
         gDrOk[i][j]=false;
         gLabY[i][j]=STU_YNUOVA;
         gLabTxt[i][j]="";
         gLabCol[i][j]=STU_COL_UNSET;
        }
   if(!keepState)
      DelObj(NameState());
  }

//+------------------------------------------------------------------+
//| EVENTI                                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   gInitOk=false;
   //--- parametri: valori assurdi riportati in un intervallo sensato (con avviso), mai un crash
   gPer=ClampInt(InpSTPeriod,1,200);
   if(gPer!=InpSTPeriod)
      Print("ABTG_ST_MTF_Unico: InpSTPeriod fuori intervallo, uso ",gPer);
   gBars=ClampInt(InpBarsToCalculate,gPer+50,5000);
   if(gBars!=InpBarsToCalculate)
      Print("ABTG_ST_MTF_Unico: InpBarsToCalculate fuori intervallo, uso ",gBars);
   gTimerSec=ClampInt(InpTimerSeconds,1,3600);
   gWTf  =ClampInt(InpTFButtonWidth,10,500);
   gWSt  =ClampInt(InpSTButtonWidth,10,500);
   gBH   =ClampInt(InpButtonHeight,10,200);
   gWMain=ClampInt(InpMainButtonWidth,10,500);
   gWCmd =ClampInt(InpCommandButtonWidth,10,500);
   gWUni =ClampInt(InpUnicoWidth,10,500);
   gPad  =ClampInt(InpButtonPadding,0,100);
   gFs   =ClampInt(InpButtonFontSize,5,40);
   gLabFs=ClampInt(InpLabelFontSize,5,40);

   gMult[0]=InpSTMultiplier1;
   gMult[1]=InpSTMultiplier2;
   gMult[2]=InpSTMultiplier3;
   gStEn[0]=InpEnableST1;
   gStEn[1]=InpEnableST2;
   gStEn[2]=InpEnableST3;
   gStDef[0]=InpDefaultST1;
   gStDef[1]=InpDefaultST2;
   gStDef[2]=InpDefaultST3;
   gStSty[0]=InpSTLineStyle1;
   gStSty[1]=InpSTLineStyle2;
   gStSty[2]=InpSTLineStyle3;
   gStW[0]=ClampInt(InpSTLineWidth1,1,5);
   gStW[1]=ClampInt(InpSTLineWidth2,1,5);
   gStW[2]=ClampInt(InpSTLineWidth3,1,5);
   for(int j=0;j<STU_NST;j++)
      if(gStEn[j] && !(gMult[j]>0.0))
        {
         gStEn[j]=false;
         Print("ABTG_ST_MTF_Unico: moltiplicatore ",j+1," non positivo, SuperTrend ",j+1," disabilitato");
        }

   gTfCol[0]=InpColorM1;   gTfCol[1]=InpColorM3;  gTfCol[2]=InpColorM5;  gTfCol[3]=InpColorM15;
   gTfCol[4]=InpColorM30;  gTfCol[5]=InpColorH1;  gTfCol[6]=InpColorH4;  gTfCol[7]=InpColorH12;
   gTfCol[8]=InpColorD1;   gTfCol[9]=InpColorW1;  gTfCol[10]=InpColorMN1;
   gTfDef[0]=InpDefaultM1;  gTfDef[1]=InpDefaultM3;  gTfDef[2]=InpDefaultM5;  gTfDef[3]=InpDefaultM15;
   gTfDef[4]=InpDefaultM30; gTfDef[5]=InpDefaultH1;  gTfDef[6]=InpDefaultH4;  gTfDef[7]=InpDefaultH12;
   gTfDef[8]=InpDefaultD1;  gTfDef[9]=InpDefaultW1;  gTfDef[10]=InpDefaultMN1;

   for(int i=0;i<STU_NTF;i++)
     {
      gKeyOk[i]=false;
      for(int j=0;j<STU_NST;j++)
        {
         gLok[i][j]=false;
         gLv[i][j]=0.0;
         gLd[i][j]=0;
        }
     }

   //--- stato: DEFAULT, poi (se c'e') quello conservato al cambio di simbolo/TF
   ApplyDefaults();
   gPanel=InpPanelVisibleAtStart;
   string st="";
   if(ObjectFind(0,NameState())>=0)
      st=ObjectGetString(0,NameState(),OBJPROP_TEXT);
   if(st!="" && !StateDecode(st))
      Print("ABTG_ST_MTF_Unico: stato conservato illeggibile, riparto dai DEFAULT");

   DeleteAllOurs(true);                           // orfani di un'istanza vecchia: via, poi si ricrea
   SaveState();
   BuildButtons();
   IndicatorSetString(INDICATOR_SHORTNAME,"ABTG ST MTF Unico");

   gTimerOk=EventSetTimer(gTimerSec);
   if(!gTimerOk)
      Print("ABTG_ST_MTF_Unico: EventSetTimer fallito (errore ",GetLastError(),"): aggiorno sui tick.");
   gInitOk=true;
   ChartRedraw(0);
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason)
  {
   EventKillTimer();
   // al cambio di simbolo/TF lo stato dei tasti resta (oggetto invisibile); in tutti gli altri casi via tutto
   DeleteAllOurs(reason==REASON_CHARTCHANGE);
   ChartRedraw(0);
  }

void OnTimer()
  {
   if(!gInitOk)
      return;
   bool chg=false;
   //--- tasti spariti (per esempio l'OnDeinit dell'istanza vecchia arrivato DOPO questo OnInit)
   if(ButtonsMissing())
     {
      SaveState();
      BuildButtons();
      chg=true;
     }
   if(UpdateAll())
      chg=true;
   if(chg)
      ChartRedraw(0);
  }

void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(!gInitOk)
      return;
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      if(PlaceLabels())                           // scorrimento/zoom: le etichette seguono le linee
         ChartRedraw(0);
      return;
     }
   if(id!=CHARTEVENT_OBJECT_CLICK)
      return;
   if(StringFind(sparam,PFX)!=0)                  // guardia: solo i NOSTRI oggetti
      return;
   bool chg=false;
   if(sparam==NameMain())
     {
      gPanel=!gPanel;
      chg=true;
     }
   else
      if(sparam==NameUnico())
        {
         bool a=gStOn[0], b=gStOn[1], c=gStOn[2];
         UNI_Clic(gStEn[0],gStEn[1],gStEn[2],a,b,c);
         gStOn[0]=a;
         gStOn[1]=b;
         gStOn[2]=c;
         chg=true;
        }
      else
         if(sparam==NameDef())
           {
            ApplyDefaults();
            chg=true;
           }
         else
           {
            for(int i=0;i<STU_NTF && !chg;i++)
               if(sparam==NameTF(i))
                 {
                  gTfOn[i]=!gTfOn[i];
                  chg=true;
                 }
            for(int j=0;j<STU_NST && !chg;j++)
               if(gStEn[j] && sparam==NameST(j))
                 {
                  gStOn[j]=!gStOn[j];
                  chg=true;
                 }
           }
   if(!chg)
      return;
   SaveState();
   BuildButtons();                                // ridipinge anche UNICO (acceso solo se tutti accesi)
   UpdateAll();                                   // linee subito, anche a mercato chiuso
   ChartRedraw(0);
  }

int OnCalculate(const int rates_total,const int prev_calculated,const int begin,const double &price[])
  {
   //--- il lavoro lo fa il TIMER; sui tick solo se il timer non e' partito, e non piu' di una volta per periodo
   if(gInitOk && !gTimerOk)
     {
      uint now=GetTickCount();
      if(now-gLastUpdMs>=(uint)gTimerSec*1000)
        {
         gLastUpdMs=now;
         if(UpdateAll())
            ChartRedraw(0);
        }
     }
   return rates_total;
  }
//+------------------------------------------------------------------+
