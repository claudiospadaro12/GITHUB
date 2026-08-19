//+------------------------------------------------------------------+
//|                                                    ABTG_Look.mq5 |
//|                                                                  |
//|  INDICATORE "LOOK ABTG" - tutto-in-uno da trascinare sul grafico. |
//|  (metti in MQL5\Indicators, apri MetaEditor e compila con F7)     |
//|                                                                  |
//|  Disegna in UN SOLO indicatore l'intero "look" approvato:         |
//|                                                                  |
//|   A) QUATTRO EMA sul TF del grafico (prezzo Close), come PLOT:    |
//|        EMA   9  bianca      spessore 1                           |
//|        EMA  21  magenta     spessore 1                           |
//|        EMA  50  azzurra     spessore 2                           |
//|        EMA 200  rossa       spessore 3                           |
//|                                                                  |
//|   B) BOLLINGER 20 / 2.0 / Close come TRE plot:                   |
//|        banda superiore e inferiore  acciaio  spessore 1          |
//|        media centrale               grigia   spessore 1          |
//|                                                                  |
//|   C) I 5 LIVELLI CHIAVE come oggetti grafici (stessa identica     |
//|      logica di ABTG_LivelliChiave.mq5):                          |
//|        1) MASSIMO di IERI       D1 shift 1  arancio, piena, sp.2  |
//|        2) MINIMO  di IERI       D1 shift 1  verde,   piena, sp.2  |
//|        3) APERTURA di OGGI      D1 shift 0  oro,     tratt., sp.1 |
//|        4) MAX SETTIMANA SCORSA  W1 shift 1  viola,   tr-punto     |
//|        5) MIN SETTIMANA SCORSA  W1 shift 1  azzurro, tr-punto     |
//|                                                                  |
//|  ATTENZIONE - I livelli sono in ORA SERVER: "ieri" e "oggi" sono  |
//|  le candele D1 del BROKER (shift 1 e shift 0), "settimana scorsa" |
//|  e' la candela W1 shift 1. Nessuna conversione di fuso.           |
//|                                                                  |
//|  CONVIVENZA: il prefisso degli oggetti e' ABTG_LOOK_ , diverso da |
//|  ABTG_LK_ usato da ABTG_LivelliChiave. I due indicatori possono   |
//|  quindi stare sullo stesso grafico senza cancellarsi gli oggetti  |
//|  a vicenda (si vedranno pero' linee doppie sovrapposte).          |
//|                                                                  |
//|  NON PIAZZA ORDINI e non tocca nulla del trading: disegna e       |
//|  basta. In OnDeinit cancella SOLO i propri oggetti (prefisso      |
//|  ABTG_LOOK_), mai gli altri oggetti del grafico.                 |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 7
#property indicator_plots   7

//--- 1) EMA veloce
#property indicator_label1  "EMA 9"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrWhite
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- 2) EMA breve
#property indicator_label2  "EMA 21"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrMagenta
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- 3) EMA media
#property indicator_label3  "EMA 50"
#property indicator_type3   DRAW_LINE
#property indicator_color3  clrDodgerBlue
#property indicator_style3  STYLE_SOLID
#property indicator_width3  2
//--- 4) EMA lenta (il "muro" del trend)
#property indicator_label4  "EMA 200"
#property indicator_type4   DRAW_LINE
#property indicator_color4  clrRed
#property indicator_style4  STYLE_SOLID
#property indicator_width4  3
//--- 5) Bollinger banda superiore
#property indicator_label5  "BB Upper"
#property indicator_type5   DRAW_LINE
#property indicator_color5  clrSteelBlue
#property indicator_style5  STYLE_SOLID
#property indicator_width5  1
//--- 6) Bollinger media centrale
#property indicator_label6  "BB Media"
#property indicator_type6   DRAW_LINE
#property indicator_color6  clrDarkGray
#property indicator_style6  STYLE_SOLID
#property indicator_width6  1
//--- 7) Bollinger banda inferiore
#property indicator_label7  "BB Lower"
#property indicator_type7   DRAW_LINE
#property indicator_color7  clrSteelBlue
#property indicator_style7  STYLE_SOLID
#property indicator_width7  1

//==================================================================
//  INPUT
//==================================================================
input group "=== Blocchi da mostrare (accensione) ==="
input bool InpMostraEma       = true;   // A) le 4 EMA
input bool InpMostraBollinger = true;   // B) le bande di Bollinger
input bool InpMostraLivelli   = true;   // C) i 5 livelli chiave

input group "=== A) EMA (prezzo Close, TF del grafico) ==="
input int InpEma1 = 9;     // EMA 1 - bianca, spessore 1
input int InpEma2 = 21;    // EMA 2 - magenta, spessore 1
input int InpEma3 = 50;    // EMA 3 - azzurra, spessore 2
input int InpEma4 = 200;   // EMA 4 - rossa, spessore 3

input group "=== B) Bollinger (prezzo Close) ==="
input int    InpBbPeriodo    = 20;    // periodo
input double InpBbDeviazione = 2.0;   // deviazione standard

input group "=== C) Livelli chiave: accensione singola ==="
input bool InpMostraMaxIeri     = true;   // 1) MAX di IERI (D1 shift 1)
input bool InpMostraMinIeri     = true;   // 2) MIN di IERI (D1 shift 1)
input bool InpMostraOpenOggi    = true;   // 3) APERTURA di OGGI (D1 shift 0)
input bool InpMostraMaxSettimana= true;   // 4) MAX SETTIMANA SCORSA (W1 shift 1)
input bool InpMostraMinSettimana= true;   // 5) MIN SETTIMANA SCORSA (W1 shift 1)

input group "=== C1) MAX di IERI ==="
input color           InpColMaxIeri   = clrOrange;
input ENUM_LINE_STYLE InpStileMaxIeri = STYLE_SOLID;
input int             InpSpesMaxIeri  = 2;

input group "=== C2) MIN di IERI ==="
input color           InpColMinIeri   = clrLimeGreen;
input ENUM_LINE_STYLE InpStileMinIeri = STYLE_SOLID;
input int             InpSpesMinIeri  = 2;

input group "=== C3) APERTURA di OGGI ==="
input color           InpColOpenOggi   = clrGold;
input ENUM_LINE_STYLE InpStileOpenOggi = STYLE_DASH;
input int             InpSpesOpenOggi  = 1;

input group "=== C4) MAX SETTIMANA SCORSA ==="
input color           InpColMaxSett   = clrMediumOrchid;
input ENUM_LINE_STYLE InpStileMaxSett = STYLE_DASHDOT;
input int             InpSpesMaxSett  = 1;

input group "=== C5) MIN SETTIMANA SCORSA ==="
input color           InpColMinSett   = clrDeepSkyBlue;
input ENUM_LINE_STYLE InpStileMinSett = STYLE_DASHDOT;
input int             InpSpesMinSett  = 1;

input group "=== Generale ==="
input bool InpMostraEtichette = true;   // Etichetta di testo accanto a ogni livello
input int  InpFontSize        = 9;      // Dimensione del testo delle etichette
input bool InpVerbose         = false;  // Log dettagliato (Esperti) su aggiornamenti e dati mancanti

//==================================================================
//  COSTANTI E STATO
//==================================================================
//--- prefisso UNIVOCO: tutto cio' che creiamo inizia cosi'.
//    Volutamente DIVERSO da ABTG_LK_ di ABTG_LivelliChiave, cosi' i
//    due indicatori non si cancellano gli oggetti a vicenda.
#define PFX "ABTG_LOOK_"

//--- nomi degli oggetti (la linea; l'etichetta e' lo stesso nome + "_TXT")
#define N_MAXIERI  "ABTG_LOOK_MAX_IERI"
#define N_MINIERI  "ABTG_LOOK_MIN_IERI"
#define N_OPENOGGI "ABTG_LOOK_OPEN_OGGI"
#define N_MAXSETT  "ABTG_LOOK_MAX_SETT"
#define N_MINSETT  "ABTG_LOOK_MIN_SETT"

//--- buffer dei 7 plot
double BufEma1[];
double BufEma2[];
double BufEma3[];
double BufEma4[];
double BufBbUp[];
double BufBbMid[];
double BufBbLo[];

//--- handle degli indicatori tecnici (creati UNA volta in OnInit)
int hEma1 = INVALID_HANDLE;
int hEma2 = INVALID_HANDLE;
int hEma3 = INVALID_HANDLE;
int hEma4 = INVALID_HANDLE;
int hBb   = INVALID_HANDLE;

//--- stato dei livelli
datetime g_lastD1  = 0;     // time della candela D1 corrente all'ultimo aggiornamento riuscito
datetime g_lastW1  = 0;     // idem per la W1
bool     g_pending = true;  // true = qualche dato mancava, si riprova al prossimo tick/timer

//--- prototipi (cosi' l'ordine di scrittura nel file non conta)
bool     CopiaBuffer(const int handle,const int indice,double &dest[],const int quanti);
void     AggiornaLivelli(const bool forza);
bool     DisegnaLivello(const string name,const double price,const string etichetta,
                        const color col,const ENUM_LINE_STYLE stile,const int spessore);
void     RimuoviLivello(const string name);
void     RimuoviTuttiILivelli();
bool     PrezzoValido(const double p);
datetime TempoBordoDestro();
void     RiposizionaEtichette();

//==================================================================
//  OnInit
//==================================================================
int OnInit()
  {
   //--- i buffer nell'ordine dei #property plot (0..6)
   SetIndexBuffer(0, BufEma1,  INDICATOR_DATA);
   SetIndexBuffer(1, BufEma2,  INDICATOR_DATA);
   SetIndexBuffer(2, BufEma3,  INDICATOR_DATA);
   SetIndexBuffer(3, BufEma4,  INDICATOR_DATA);
   SetIndexBuffer(4, BufBbUp,  INDICATOR_DATA);
   SetIndexBuffer(5, BufBbMid, INDICATOR_DATA);
   SetIndexBuffer(6, BufBbLo,  INDICATOR_DATA);

   //--- periodi: se qualcuno mette 0 o meno, si torna al valore standard
   int p1 = (InpEma1 > 0) ? InpEma1 : 9;
   int p2 = (InpEma2 > 0) ? InpEma2 : 21;
   int p3 = (InpEma3 > 0) ? InpEma3 : 50;
   int p4 = (InpEma4 > 0) ? InpEma4 : 200;
   int pb = (InpBbPeriodo > 0) ? InpBbPeriodo : 20;

   //--- niente linea prima che la media abbia abbastanza barre: cosi'
   //    non si vede il "gancio" iniziale che non significa nulla.
   PlotIndexSetInteger(0, PLOT_DRAW_BEGIN, p1);
   PlotIndexSetInteger(1, PLOT_DRAW_BEGIN, p2);
   PlotIndexSetInteger(2, PLOT_DRAW_BEGIN, p3);
   PlotIndexSetInteger(3, PLOT_DRAW_BEGIN, p4);
   PlotIndexSetInteger(4, PLOT_DRAW_BEGIN, pb);
   PlotIndexSetInteger(5, PLOT_DRAW_BEGIN, pb);
   PlotIndexSetInteger(6, PLOT_DRAW_BEGIN, pb);

   for(int i=0; i<7; i++)
      PlotIndexSetDouble(i, PLOT_EMPTY_VALUE, EMPTY_VALUE);

   //--- etichette dinamiche (rispecchiano i periodi realmente usati)
   PlotIndexSetString(0, PLOT_LABEL, StringFormat("EMA %d", p1));
   PlotIndexSetString(1, PLOT_LABEL, StringFormat("EMA %d", p2));
   PlotIndexSetString(2, PLOT_LABEL, StringFormat("EMA %d", p3));
   PlotIndexSetString(3, PLOT_LABEL, StringFormat("EMA %d", p4));
   PlotIndexSetString(4, PLOT_LABEL, StringFormat("BB %d Upper", pb));
   PlotIndexSetString(5, PLOT_LABEL, StringFormat("BB %d Media", pb));
   PlotIndexSetString(6, PLOT_LABEL, StringFormat("BB %d Lower", pb));

   //--- blocchi spenti: il plot esiste ma non si disegna (DRAW_NONE).
   //    Cosi' l'accensione/spegnimento non cambia la numerazione dei buffer.
   if(!InpMostraEma)
      for(int i=0; i<4; i++)
         PlotIndexSetInteger(i, PLOT_DRAW_TYPE, DRAW_NONE);
   if(!InpMostraBollinger)
      for(int i=4; i<7; i++)
         PlotIndexSetInteger(i, PLOT_DRAW_TYPE, DRAW_NONE);

   IndicatorSetInteger(INDICATOR_DIGITS, _Digits);
   IndicatorSetString(INDICATOR_SHORTNAME,
                      StringFormat("ABTG Look (EMA %d/%d/%d/%d - BB %d/%.1f)",
                                   p1, p2, p3, p4, pb, InpBbDeviazione));

   //--- handle: si creano SOLO se il blocco e' acceso (niente calcoli inutili)
   if(InpMostraEma)
     {
      hEma1 = iMA(_Symbol, _Period, p1, 0, MODE_EMA, PRICE_CLOSE);
      hEma2 = iMA(_Symbol, _Period, p2, 0, MODE_EMA, PRICE_CLOSE);
      hEma3 = iMA(_Symbol, _Period, p3, 0, MODE_EMA, PRICE_CLOSE);
      hEma4 = iMA(_Symbol, _Period, p4, 0, MODE_EMA, PRICE_CLOSE);
      if(hEma1==INVALID_HANDLE || hEma2==INVALID_HANDLE ||
         hEma3==INVALID_HANDLE || hEma4==INVALID_HANDLE)
        {
         PrintFormat("ABTG_LOOK: creazione handle EMA fallita (err=%d)", GetLastError());
         return(INIT_FAILED);
        }
     }

   if(InpMostraBollinger)
     {
      hBb = iBands(_Symbol, _Period, pb, 0, InpBbDeviazione, PRICE_CLOSE);
      if(hBb==INVALID_HANDLE)
        {
         PrintFormat("ABTG_LOOK: creazione handle Bollinger fallita (err=%d)", GetLastError());
         return(INIT_FAILED);
        }
     }

   //--- ripulisce eventuali residui di una istanza precedente (solo i NOSTRI)
   ObjectsDeleteAll(0, PFX);

   g_lastD1  = 0;
   g_lastW1  = 0;
   g_pending = true;

   //--- timer di sicurezza: se per qualche motivo non arrivano tick
   //    (mercato chiuso, weekend, simbolo fermo) il cambio giorno viene
   //    comunque intercettato entro un minuto.
   EventSetTimer(60);

   //--- primo tentativo: se lo storico D1/W1 non e' ancora scaricato
   //    fallisce in silenzio e g_pending resta true (riprova dopo).
   AggiornaLivelli(true);

   return(INIT_SUCCEEDED);
  }

//==================================================================
//  OnDeinit - rilascia gli handle e pulisce SOLO i propri oggetti
//==================================================================
void OnDeinit(const int reason)
  {
   EventKillTimer();

   if(hEma1!=INVALID_HANDLE) IndicatorRelease(hEma1);
   if(hEma2!=INVALID_HANDLE) IndicatorRelease(hEma2);
   if(hEma3!=INVALID_HANDLE) IndicatorRelease(hEma3);
   if(hEma4!=INVALID_HANDLE) IndicatorRelease(hEma4);
   if(hBb  !=INVALID_HANDLE) IndicatorRelease(hBb);

   hEma1 = INVALID_HANDLE;
   hEma2 = INVALID_HANDLE;
   hEma3 = INVALID_HANDLE;
   hEma4 = INVALID_HANDLE;
   hBb   = INVALID_HANDLE;

   ObjectsDeleteAll(0, PFX);
   ChartRedraw();
  }

//==================================================================
//  OnCalculate
//  - copia i valori di EMA/Bollinger dagli handle nei buffer;
//  - aggiorna i livelli solo al cambio di candela D1/W1.
//  Se un handle non ha ancora calcolato (primi tick dopo l'apertura
//  del grafico) si esce con return(0): MT5 richiamera' OnCalculate al
//  tick successivo e si riprova da capo. Nessun ArrayInitialize a
//  caso: meglio nessuna linea che una linea sbagliata.
//==================================================================
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   //--- i livelli non dipendono dai buffer: si aggiornano comunque
   AggiornaLivelli(false);

   if(rates_total <= 0)
      return(0);

   //--- quante barre ricopiare: tutto la prima volta, poi solo la coda
   int to_copy;
   if(prev_calculated <= 0 || prev_calculated > rates_total)
      to_copy = rates_total;
   else
     {
      to_copy = rates_total - prev_calculated;
      to_copy++;                       // ricopia anche l'ultima barra gia' nota
     }
   if(to_copy > rates_total) to_copy = rates_total;

   //--- A) le quattro EMA
   if(InpMostraEma)
     {
      if(!CopiaBuffer(hEma1, 0, BufEma1, to_copy)) return(0);
      if(!CopiaBuffer(hEma2, 0, BufEma2, to_copy)) return(0);
      if(!CopiaBuffer(hEma3, 0, BufEma3, to_copy)) return(0);
      if(!CopiaBuffer(hEma4, 0, BufEma4, to_copy)) return(0);
     }

   //--- B) le bande di Bollinger
   //    buffer di iBands: 0 = BASE_LINE (media), 1 = UPPER, 2 = LOWER
   if(InpMostraBollinger)
     {
      if(!CopiaBuffer(hBb, 1, BufBbUp,  to_copy)) return(0);
      if(!CopiaBuffer(hBb, 0, BufBbMid, to_copy)) return(0);
      if(!CopiaBuffer(hBb, 2, BufBbLo,  to_copy)) return(0);
     }

   return(rates_total);
  }

//==================================================================
//  OnTimer - rete di sicurezza (cambio giorno senza tick, retry dati)
//==================================================================
void OnTimer()
  {
   AggiornaLivelli(false);
  }

//==================================================================
//  OnChartEvent - se l'utente scorre/zooma, le etichette seguono il
//  bordo destro. Non ricalcola i livelli: sposta solo il testo.
//==================================================================
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_CHART_CHANGE && InpMostraLivelli && InpMostraEtichette)
      RiposizionaEtichette();
  }

//==================================================================
//  Copia "quanti" valori dal buffer di un handle nel buffer del plot.
//  Ritorna false se l'indicatore non ha ancora calcolato o se la
//  CopyBuffer fallisce (-1): in quel caso il chiamante fa return(0)
//  e ritenta al tick successivo, senza sporcare i buffer.
//==================================================================
bool CopiaBuffer(const int handle,const int indice,double &dest[],const int quanti)
  {
   if(handle==INVALID_HANDLE || quanti<=0)
      return(false);

   //--- l'indicatore ha gia' prodotto qualcosa?
   int calcolate = BarsCalculated(handle);
   if(calcolate <= 0)
     {
      if(InpVerbose)
         PrintFormat("ABTG_LOOK: handle %d non ancora pronto (BarsCalculated=%d, err=%d)",
                     handle, calcolate, GetLastError());
      ResetLastError();
      return(false);
     }
   if(calcolate < quanti)
     {
      if(InpVerbose)
         PrintFormat("ABTG_LOOK: handle %d ha solo %d barre su %d richieste - riprovo",
                     handle, calcolate, quanti);
      return(false);
     }

   int copiate = CopyBuffer(handle, indice, 0, quanti, dest);
   if(copiate <= 0)
     {
      if(InpVerbose)
         PrintFormat("ABTG_LOOK: CopyBuffer handle %d buf %d fallita (ret=%d, err=%d)",
                     handle, indice, copiate, GetLastError());
      ResetLastError();
      return(false);
     }

   return(true);
  }

//==================================================================
//  MOTORE DEI LIVELLI: legge i valori e aggiorna gli oggetti.
//  forza = true -> aggiorna comunque (usato in OnInit)
//==================================================================
void AggiornaLivelli(const bool forza)
  {
   //--- blocco spento: via gli oggetti e basta
   if(!InpMostraLivelli)
     {
      RimuoviTuttiILivelli();
      return;
     }

   datetime tD1 = iTime(_Symbol, PERIOD_D1, 0);
   datetime tW1 = iTime(_Symbol, PERIOD_W1, 0);

   //--- storico non ancora pronto (tipico ai primi tick del lunedi' o
   //    appena aperto il grafico: errore 4401). Non disegniamo niente e
   //    riproviamo al prossimo giro: MAI una linea a prezzo 0.
   if(tD1<=0 || tW1<=0)
     {
      g_pending = true;
      if(InpVerbose)
         PrintFormat("ABTG_LOOK: storico D1/W1 non pronto (err=%d) - riprovo", GetLastError());
      ResetLastError();
      return;
     }

   //--- niente da fare: stessa giornata, stessa settimana, nessun dato in sospeso
   if(!forza && !g_pending && tD1==g_lastD1 && tW1==g_lastW1)
      return;

   int mancanti = 0;

   //--- 1) MASSIMO DI IERI ---------------------------------------
   if(InpMostraMaxIeri)
     {
      double v = iHigh(_Symbol, PERIOD_D1, 1);
      if(!DisegnaLivello(N_MAXIERI, v, "MAX IERI", InpColMaxIeri, InpStileMaxIeri, InpSpesMaxIeri))
         mancanti++;
     }
   else RimuoviLivello(N_MAXIERI);

   //--- 2) MINIMO DI IERI ----------------------------------------
   if(InpMostraMinIeri)
     {
      double v = iLow(_Symbol, PERIOD_D1, 1);
      if(!DisegnaLivello(N_MINIERI, v, "MIN IERI", InpColMinIeri, InpStileMinIeri, InpSpesMinIeri))
         mancanti++;
     }
   else RimuoviLivello(N_MINIERI);

   //--- 3) APERTURA DI OGGI (candela D1 in corso) ----------------
   if(InpMostraOpenOggi)
     {
      double v = iOpen(_Symbol, PERIOD_D1, 0);
      if(!DisegnaLivello(N_OPENOGGI, v, "OPEN OGGI", InpColOpenOggi, InpStileOpenOggi, InpSpesOpenOggi))
         mancanti++;
     }
   else RimuoviLivello(N_OPENOGGI);

   //--- 4) MASSIMO SETTIMANA SCORSA ------------------------------
   if(InpMostraMaxSettimana)
     {
      double v = iHigh(_Symbol, PERIOD_W1, 1);
      if(!DisegnaLivello(N_MAXSETT, v, "MAX SETT.SCORSA", InpColMaxSett, InpStileMaxSett, InpSpesMaxSett))
         mancanti++;
     }
   else RimuoviLivello(N_MAXSETT);

   //--- 5) MINIMO SETTIMANA SCORSA -------------------------------
   if(InpMostraMinSettimana)
     {
      double v = iLow(_Symbol, PERIOD_W1, 1);
      if(!DisegnaLivello(N_MINSETT, v, "MIN SETT.SCORSA", InpColMinSett, InpStileMinSett, InpSpesMinSett))
         mancanti++;
     }
   else RimuoviLivello(N_MINSETT);

   //--- se manca ancora qualcosa restiamo "in sospeso" e NON registriamo
   //    la giornata come fatta: al prossimo tick/timer si ritenta.
   g_pending = (mancanti>0);
   if(!g_pending)
     {
      g_lastD1 = tD1;
      g_lastW1 = tW1;
     }

   if(InpVerbose)
      PrintFormat("ABTG_LOOK: livelli aggiornati (D1=%s, W1=%s) mancanti=%d",
                  TimeToString(tD1,TIME_DATE), TimeToString(tW1,TIME_DATE), mancanti);

   ChartRedraw();
  }

//==================================================================
//  Disegna/aggiorna UN livello (linea + etichetta).
//  Ritorna false se il prezzo non e' utilizzabile (dato non pronto):
//  in quel caso l'oggetto viene rimosso, cosi' non resta a schermo
//  un livello vecchio spacciato per quello di oggi.
//==================================================================
bool DisegnaLivello(const string name,const double price,const string etichetta,
                    const color col,const ENUM_LINE_STYLE stile,const int spessore)
  {
   if(!PrezzoValido(price))
     {
      RimuoviLivello(name);
      if(InpVerbose)
         PrintFormat("ABTG_LOOK: %s non disponibile (err=%d) - riprovo", etichetta, GetLastError());
      ResetLastError();
      return(false);
     }

   string testo = etichetta + " " + DoubleToString(price, _Digits);

   //--- LINEA ORIZZONTALE: si crea UNA volta, poi si sposta con ObjectMove
   if(ObjectFind(0, name) < 0)
     {
      if(!ObjectCreate(0, name, OBJ_HLINE, 0, 0, price))
        {
         if(InpVerbose)
            PrintFormat("ABTG_LOOK: ObjectCreate %s fallita (err=%d)", name, GetLastError());
         ResetLastError();
         return(false);
        }
      ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
      ObjectSetInteger(0, name, OBJPROP_SELECTED,   false);
      ObjectSetInteger(0, name, OBJPROP_HIDDEN,     true);
      ObjectSetInteger(0, name, OBJPROP_BACK,       true);
     }
   else
     {
      ObjectMove(0, name, 0, 0, price);   // HLINE: time ignorato, conta il prezzo
     }

   ObjectSetInteger(0, name, OBJPROP_COLOR,   col);
   ObjectSetInteger(0, name, OBJPROP_STYLE,   stile);
   ObjectSetInteger(0, name, OBJPROP_WIDTH,   spessore);
   ObjectSetString (0, name, OBJPROP_TEXT,    testo);
   ObjectSetString (0, name, OBJPROP_TOOLTIP, testo);

   //--- ETICHETTA di testo, ancorata al bordo destro del grafico
   string nt = name + "_TXT";
   if(InpMostraEtichette)
     {
      datetime tAnc = TempoBordoDestro();
      if(ObjectFind(0, nt) < 0)
        {
         if(!ObjectCreate(0, nt, OBJ_TEXT, 0, tAnc, price))
           {
            ResetLastError();
            return(true);   // la linea c'e': l'etichetta e' un di piu'
           }
         ObjectSetInteger(0, nt, OBJPROP_SELECTABLE, false);
         ObjectSetInteger(0, nt, OBJPROP_SELECTED,   false);
         ObjectSetInteger(0, nt, OBJPROP_HIDDEN,     true);
         ObjectSetInteger(0, nt, OBJPROP_BACK,       false);
         ObjectSetInteger(0, nt, OBJPROP_ANCHOR,     ANCHOR_RIGHT_LOWER);
         ObjectSetString (0, nt, OBJPROP_FONT,       "Arial");
        }
      else
        {
         ObjectMove(0, nt, 0, tAnc, price);
        }
      ObjectSetString (0, nt, OBJPROP_TEXT,     testo + " ");
      ObjectSetInteger(0, nt, OBJPROP_COLOR,    col);
      ObjectSetInteger(0, nt, OBJPROP_FONTSIZE, InpFontSize);
      ObjectSetString (0, nt, OBJPROP_TOOLTIP,  testo);
     }
   else
     {
      if(ObjectFind(0, nt) >= 0) ObjectDelete(0, nt);
     }

   return(true);
  }

//==================================================================
//  Rimuove linea + etichetta di un livello (spento o dato assente)
//==================================================================
void RimuoviLivello(const string name)
  {
   if(ObjectFind(0, name) >= 0)         ObjectDelete(0, name);
   if(ObjectFind(0, name+"_TXT") >= 0)  ObjectDelete(0, name+"_TXT");
  }

//==================================================================
//  Toglie tutti e cinque i livelli (blocco C spento)
//==================================================================
void RimuoviTuttiILivelli()
  {
   RimuoviLivello(N_MAXIERI);
   RimuoviLivello(N_MINIERI);
   RimuoviLivello(N_OPENOGGI);
   RimuoviLivello(N_MAXSETT);
   RimuoviLivello(N_MINSETT);
  }

//==================================================================
//  Un prezzo e' utilizzabile solo se e' un numero finito e > 0:
//  iHigh/iLow/iOpen tornano 0 (o EMPTY_VALUE) quando lo storico non
//  e' ancora pronto. Mai disegnare una linea a zero.
//==================================================================
bool PrezzoValido(const double p)
  {
   if(!MathIsValidNumber(p)) return(false);
   if(p <= 0.0)              return(false);
   if(p >= EMPTY_VALUE)      return(false);
   return(true);
  }

//==================================================================
//  Tempo della barra piu' a destra fra quelle visibili: serve come
//  ancoraggio delle etichette (che restano cosi' sul bordo destro).
//==================================================================
datetime TempoBordoDestro()
  {
   long first = ChartGetInteger(0, CHART_FIRST_VISIBLE_BAR);
   long vis   = ChartGetInteger(0, CHART_VISIBLE_BARS);
   int  idx   = (int)(first - vis + 1);
   if(idx < 0) idx = 0;

   datetime t = iTime(_Symbol, _Period, idx);
   if(t <= 0) t = iTime(_Symbol, _Period, 0);
   if(t <= 0) t = TimeCurrent();
   return(t);
  }

//==================================================================
//  Sposta le sole etichette al nuovo bordo destro, mantenendo il
//  prezzo della rispettiva linea (nessun ricalcolo dei livelli).
//==================================================================
void RiposizionaEtichette()
  {
   datetime tAnc = TempoBordoDestro();
   string nomi[5] = {N_MAXIERI, N_MINIERI, N_OPENOGGI, N_MAXSETT, N_MINSETT};

   for(int i=0; i<5; i++)
     {
      string nt = nomi[i] + "_TXT";
      if(ObjectFind(0, nomi[i]) < 0) continue;
      if(ObjectFind(0, nt)      < 0) continue;
      double p = ObjectGetDouble(0, nomi[i], OBJPROP_PRICE);
      if(!PrezzoValido(p)) continue;
      ObjectMove(0, nt, 0, tAnc, p);
     }
   ChartRedraw();
  }
//+------------------------------------------------------------------+
