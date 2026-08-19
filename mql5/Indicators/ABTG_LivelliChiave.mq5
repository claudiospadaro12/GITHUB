//+------------------------------------------------------------------+
//|                                           ABTG_LivelliChiave.mq5 |
//|                                                                  |
//|  INDICATORE "LIVELLI CHIAVE" - solo oggetti grafici.             |
//|  (metti in MQL5\Indicators, apri MetaEditor e compila con F7)    |
//|                                                                  |
//|  Disegna 5 livelli di riferimento che si aggiornano DA SOLI a    |
//|  ogni nuova giornata / nuova settimana:                          |
//|    1) MASSIMO di IERI          arancio, piena, spessore 2        |
//|    2) MINIMO di IERI           verde,   piena, spessore 2        |
//|    3) APERTURA di OGGI         oro,     tratteggiata, spess. 1   |
//|    4) MASSIMO SETT. SCORSA     viola,   tratto-punto, spess. 1   |
//|    5) MINIMO SETT. SCORSA      azzurro, tratto-punto, spess. 1   |
//|                                                                  |
//|  ATTENZIONE - Tutto e' in ORA SERVER: "ieri" e "oggi" sono le    |
//|  candele D1 del BROKER (shift 1 e shift 0), "settimana scorsa"   |
//|  e' la candela W1 shift 1. Nessuna conversione di fuso: se il    |
//|  server chiude la giornata alle 00:00 server, quello e' il       |
//|  confine che vedi qui.                                           |
//|                                                                  |
//|  NON PIAZZA ORDINI e non tocca nulla del trading: disegna e      |
//|  basta. In OnDeinit cancella SOLO i propri oggetti (prefisso     |
//|  ABTG_LK_), mai gli altri oggetti del grafico.                   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 0
#property indicator_plots   0

//==================================================================
//  INPUT
//==================================================================
input group "=== Livelli da mostrare (accensione) ==="
input bool InpMostraMaxIeri     = true;   // 1) MAX di IERI (D1 shift 1)
input bool InpMostraMinIeri     = true;   // 2) MIN di IERI (D1 shift 1)
input bool InpMostraOpenOggi    = true;   // 3) APERTURA di OGGI (D1 shift 0)
input bool InpMostraMaxSettimana= true;   // 4) MAX SETTIMANA SCORSA (W1 shift 1)
input bool InpMostraMinSettimana= true;   // 5) MIN SETTIMANA SCORSA (W1 shift 1)

input group "=== 1) MAX di IERI ==="
input color           InpColMaxIeri   = clrOrange;
input ENUM_LINE_STYLE InpStileMaxIeri = STYLE_SOLID;
input int             InpSpesMaxIeri  = 2;

input group "=== 2) MIN di IERI ==="
input color           InpColMinIeri   = clrLimeGreen;
input ENUM_LINE_STYLE InpStileMinIeri = STYLE_SOLID;
input int             InpSpesMinIeri  = 2;

input group "=== 3) APERTURA di OGGI ==="
input color           InpColOpenOggi   = clrGold;
input ENUM_LINE_STYLE InpStileOpenOggi = STYLE_DASH;
input int             InpSpesOpenOggi  = 1;

input group "=== 4) MAX SETTIMANA SCORSA ==="
input color           InpColMaxSett   = clrMediumOrchid;
input ENUM_LINE_STYLE InpStileMaxSett = STYLE_DASHDOT;
input int             InpSpesMaxSett  = 1;

input group "=== 5) MIN SETTIMANA SCORSA ==="
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
#define PFX "ABTG_LK_"     // prefisso UNICO: tutto cio' che creiamo inizia cosi'

//--- nomi degli oggetti (la linea; l'etichetta e' lo stesso nome + "_TXT")
#define N_MAXIERI  "ABTG_LK_MAX_IERI"
#define N_MINIERI  "ABTG_LK_MIN_IERI"
#define N_OPENOGGI "ABTG_LK_OPEN_OGGI"
#define N_MAXSETT  "ABTG_LK_MAX_SETT"
#define N_MINSETT  "ABTG_LK_MIN_SETT"

datetime g_lastD1 = 0;      // time della candela D1 corrente all'ultimo aggiornamento riuscito
datetime g_lastW1 = 0;      // idem per la W1
bool     g_pending = true;  // true = qualche dato mancava, si riprova al prossimo tick/timer

//--- prototipi (cosi' l'ordine di scrittura nel file non conta)
void     AggiornaLivelli(const bool forza);
bool     DisegnaLivello(const string name,const double price,const string etichetta,
                        const color col,const ENUM_LINE_STYLE stile,const int spessore);
void     RimuoviLivello(const string name);
bool     PrezzoValido(const double p);
datetime TempoBordoDestro();
void     RiposizionaEtichette();

//==================================================================
//  OnInit
//==================================================================
int OnInit()
  {
   IndicatorSetString(INDICATOR_SHORTNAME,"ABTG Livelli Chiave");

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
//  OnDeinit - pulizia CHIRURGICA: solo gli oggetti col nostro prefisso
//==================================================================
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectsDeleteAll(0, PFX);
   ChartRedraw();
  }

//==================================================================
//  OnCalculate - NON ricalcola a ogni tick: controlla solo se e'
//  cambiata la candela D1/W1 (o se c'era un dato in sospeso).
//==================================================================
int OnCalculate(const int rates_total,const int prev_calculated,
                const datetime &time[],const double &open[],
                const double &high[],const double &low[],const double &close[],
                const long &tick_volume[],const long &volume[],const int &spread[])
  {
   AggiornaLivelli(false);
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
   if(id==CHARTEVENT_CHART_CHANGE && InpMostraEtichette)
      RiposizionaEtichette();
  }

//==================================================================
//  MOTORE: legge i valori e aggiorna gli oggetti
//  forza = true -> aggiorna comunque (usato in OnInit)
//==================================================================
void AggiornaLivelli(const bool forza)
  {
   datetime tD1 = iTime(_Symbol, PERIOD_D1, 0);
   datetime tW1 = iTime(_Symbol, PERIOD_W1, 0);

   //--- storico non ancora pronto (tipico ai primi tick del lunedi' o
   //    appena aperto il grafico: errore 4401). Non disegniamo niente e
   //    riproviamo al prossimo giro: MAI una linea a prezzo 0.
   if(tD1<=0 || tW1<=0)
     {
      g_pending = true;
      if(InpVerbose)
         PrintFormat("ABTG_LK: storico D1/W1 non pronto (err=%d) - riprovo", GetLastError());
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
      PrintFormat("ABTG_LK: aggiornato (D1=%s, W1=%s) livelli mancanti=%d",
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
         PrintFormat("ABTG_LK: %s non disponibile (err=%d) - riprovo", etichetta, GetLastError());
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
            PrintFormat("ABTG_LK: ObjectCreate %s fallita (err=%d)", name, GetLastError());
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
