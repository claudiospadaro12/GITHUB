//+------------------------------------------------------------------+
//|                                 ABTG_Nasdaq_Apertura_US.mq5       |
//|                                                                  |
//|  EA "APERTURA AMERICANA" (Nasdaq / NASUSD) - MetaTrader 5        |
//|                                                                  |
//|  Basato sul piano di trading "Apertura Americana - Nasdaq":     |
//|   - apertura USA alle 15:30 (ora italiana): rottura dei         |
//|     massimi/minimi in apertura (BUY STOP / SELL STOP)           |
//|   - OCO, parziale al 1o obiettivo, stop in pari, trailing stop  |
//|   - MODALITA' GAP FILL opzionale (apertura in gap -> ritorno    |
//|     verso la chiusura precedente): imposta InpEntryMode=GAPFILL |
//|     e InpUseGapFill=true                                        |
//|                                                                  |
//|  ⚠️ Gli ORARI sono quelli del SERVER del broker (quelli sul      |
//|     grafico): imposta InpSessionHour cosi' che coincida con     |
//|     l'apertura reale del Nasdaq cash sul TUO grafico            |
//|     (spesso 16:30 su broker GMT+2, 15:30 su GMT+3, ecc.).       |
//|                                                                  |
//|  ⚠️ Nessun EA garantisce profitti. TESTA SU DEMO prima.          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

//--- DEFAULT specifici per il Nasdaq (usati dal motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "Nasdaq Apertura US OTT"
#define ABTG_DEF_MAGIC        770211
#define ABTG_DEF_SESSION_HOUR 14     // Nasdaq 15:30 IT = 14:30 server BCM
#define ABTG_DEF_SESSION_MIN  30
#define ABTG_DEF_RANGE_MIN    15     // (usato in gap fill o se passi a range di apertura)
#define ABTG_DEF_RANGE_MODE   2      // 2=massimi/minimi della CANDELA PRECEDENTE (piano: su H1)
#define ABTG_DEF_LEVEL_TF     PERIOD_H1  // piano Nasdaq: "ordini nel time frame H1"
#define ABTG_DEF_CLOSE_HOUR   21     // flat prima della chiusura serale (server)
#define ABTG_DEF_CLOSE_MIN    45
#define ABTG_DEF_USE_GAPFILL  false  // metti true + InpEntryMode=GAPFILL per il gap fill
#define ABTG_DEF_RISK         1.0    // OTT: rischio 1% (validato solo OHLC, prudenza)
#define ABTG_DEF_BUFFER       150    // OTT: buffer robusto solo-LONG
#define ABTG_DEF_TRAIL_MODE   1      // 1=base candela precedente su M1 (piano: "seguo su M1")

//  VERSIONE TUTTO-IN-UNO: il motore e' incluso qui sotto, NON serve
//  copiare nessun file .mqh ne creare la cartella Include\ABTG.
//  Basta mettere questo file in MQL5\Experts e compilarlo (F7).

//+------------------------------------------------------------------+
//|                                         ABTG_ApertureCore.mqh     |
//|                                                                  |
//|  MOTORE CONDIVISO per gli EA "Apertura Mercati" (DAX / Nasdaq).  |
//|                                                                  |
//|  Automatizza la parte MECCANICA dei piani di trading sulle       |
//|  aperture (Europa 09:00 / USA 15:30):                            |
//|                                                                  |
//|   1) RANGE DI APERTURA: massimo/minimo dei primi N minuti dopo   |
//|      l'apertura (oppure massimo/minimo della finestra precedente)|
//|   2) BREAKOUT con ordini pendenti: BUY STOP sopra il massimo,    |
//|      SELL STOP sotto il minimo (buffer configurabile)            |
//|   3) OCO: quando uno parte, l'altro viene cancellato             |
//|   4) GESTIONE: parziale al 1o obiettivo -> stop in pari ->       |
//|      trailing stop (proprio come descritto nei piani)            |
//|   5) RISCHIO: lotto calcolato in % del capitale sullo stop       |
//|   6) FILTRI opzionali: EMA, Supertrend, correlazione (SPX/...)   |
//|   7) MODALITA' GAP FILL opzionale (tipica dell'apertura USA)     |
//|                                                                  |
//|  I DEFAULT dei parametri si impostano nei singoli EA con delle   |
//|  #define PRIMA dell'#include (vedi i file .mq5).                  |
//|                                                                  |
//|  ⚠️ Nessun EA garantisce profitti. Testare SEMPRE su DEMO nello  |
//|     Strategy Tester prima di usare denaro reale.                 |
//+------------------------------------------------------------------+
#include <Trade/Trade.mqh>

//==================================================================
//  DEFAULT (sovrascrivibili con #define nel file .mq5 dell'EA)
//==================================================================
#ifndef ABTG_DEF_NAME
   #define ABTG_DEF_NAME        "ABTG Apertura"
#endif
#ifndef ABTG_DEF_MAGIC
   #define ABTG_DEF_MAGIC       770001
#endif
#ifndef ABTG_DEF_SESSION_HOUR
   #define ABTG_DEF_SESSION_HOUR 9     // ora (SERVER/broker) dell'apertura cash
#endif
#ifndef ABTG_DEF_SESSION_MIN
   #define ABTG_DEF_SESSION_MIN  0
#endif
#ifndef ABTG_DEF_RANGE_MIN
   #define ABTG_DEF_RANGE_MIN    15    // minuti del range di apertura
#endif
#ifndef ABTG_DEF_RANGE_MODE
   #define ABTG_DEF_RANGE_MODE   0     // 0=range apertura, 1=finestra prec., 2=candela prec.
#endif
#ifndef ABTG_DEF_LEVEL_TF
   #define ABTG_DEF_LEVEL_TF     PERIOD_H1  // TF dei "massimi/minimi precedenti" (piano Nasdaq: H1)
#endif
#ifndef ABTG_DEF_RISK
   #define ABTG_DEF_RISK         2.0   // rischio % per trade (piano: massimo 2%)
#endif
#ifndef ABTG_DEF_TRAIL_MODE
   #define ABTG_DEF_TRAIL_MODE   1     // 0=ATR, 1=base candela prec., 2=punti fissi
#endif
#ifndef ABTG_DEF_CLOSE_HOUR
   #define ABTG_DEF_CLOSE_HOUR   17    // ora (SERVER) di chiusura/flat della giornata
#endif
#ifndef ABTG_DEF_CLOSE_MIN
   #define ABTG_DEF_CLOSE_MIN    30
#endif
#ifndef ABTG_DEF_USE_GAPFILL
   #define ABTG_DEF_USE_GAPFILL  false
#endif
#ifndef ABTG_DEF_BUFFER
   #define ABTG_DEF_BUFFER       200   // buffer oltre il range, in punti
#endif
#ifndef ABTG_DEF_PREVWIN
   #define ABTG_DEF_PREVWIN      60    // (RANGE_PREV) finestra precedente in minuti
#endif
#ifndef ABTG_DEF_MINRANGE
   #define ABTG_DEF_MINRANGE     0     // ampiezza minima del range/candela (punti; 0=off)
#endif
#ifndef ABTG_DEF_MAXRANGE
   #define ABTG_DEF_MAXRANGE     0     // ampiezza massima del range/candela (punti; 0=off)
#endif

//==================================================================
//  ENUM di supporto
//==================================================================
enum ENUM_ABTG_ENTRY
  {
   ABTG_BREAKOUT = 0,   // rottura del range di apertura (piani DAX + Nasdaq)
   ABTG_GAPFILL  = 1    // chiusura del gap di apertura (tipico USA)
  };

enum ENUM_ABTG_RANGE
  {
   ABTG_RANGE_OPENING = 0,  // range = primi N minuti DOPO l'apertura (PDF: primi 15 min)
   ABTG_RANGE_PREV    = 1,  // range = massimo/minimo dei N minuti PRIMA dell'apertura
   ABTG_RANGE_PREVBAR = 2   // range = massimo/minimo della CANDELA PRECEDENTE su InpLevelTF
                            //          (piano Nasdaq: "massimi/minimi precedenti" su H1)
  };

enum ENUM_ABTG_SL
  {
   ABTG_SL_RANGE = 0,   // stop sull'estremo opposto del range (piano: "stop sui massimi prec.")
   ABTG_SL_ATR   = 1    // stop a X volte l'ATR
  };

enum ENUM_ABTG_TRAIL
  {
   ABTG_TRAIL_ATR     = 0,  // trailing a X volte l'ATR
   ABTG_TRAIL_PREVBAR = 1,  // trailing alla BASE della candela precedente (piano: su M1)
   ABTG_TRAIL_FIXED   = 2   // trailing a distanza fissa in punti (piano DAX: es. 410 punti)
  };

//==================================================================
//  PARAMETRI DI INPUT (comuni a tutti gli EA che includono il core)
//==================================================================
input group "=== Sessione (ORARIO DEL SERVER/BROKER!) ==="
input int    InpSessionHour  = ABTG_DEF_SESSION_HOUR; // Ora apertura (server) - controlla sul TUO grafico
input int    InpSessionMin   = ABTG_DEF_SESSION_MIN;  // Minuti apertura (server)
input int    InpRangeMinutes = ABTG_DEF_RANGE_MIN;    // Durata del range (minuti)
input int    InpCloseHour    = ABTG_DEF_CLOSE_HOUR;   // Ora flat/chiusura (server)
input int    InpCloseMin     = ABTG_DEF_CLOSE_MIN;    // Minuti flat/chiusura (server)
input bool   InpCloseAtEnd   = true;                  // Chiudi posizioni residue a fine sessione
input bool   InpOneTradePerDay = true;                // Un solo ciclo operativo al giorno

input group "=== Ingresso ==="
input ENUM_ABTG_ENTRY InpEntryMode = ABTG_BREAKOUT;   // Modalita' d'ingresso
input ENUM_ABTG_RANGE InpRangeMode = (ENUM_ABTG_RANGE)ABTG_DEF_RANGE_MODE; // Da dove prendo max/min
input ENUM_TIMEFRAMES InpLevelTF   = ABTG_DEF_LEVEL_TF; // (RANGE_PREVBAR) TF dei massimi/minimi prec. (Nasdaq: H1)
input int    InpPrevWindowMin = ABTG_DEF_PREVWIN;     // (RANGE_PREV) finestra prec. in minuti (live: 5 = candela pre-apertura)
input double InpBufferPoints  = ABTG_DEF_BUFFER;      // Buffer oltre il range, in punti (live: 700 = 7 punti indice)
input int    InpPendingExpiryMin = 120;               // Cancella il pendente non eseguito dopo N minuti
input bool   InpAllowLong     = true;                 // Consenti operazioni long
input bool   InpAllowShort    = false;                // OTT: SOLO LONG (edge Nasdaq)
input double InpMinRangePts   = ABTG_DEF_MINRANGE;    // Ampiezza MIN candela/range in punti (live: 1700=17 punti; 0=off)
input double InpMaxRangePts   = ABTG_DEF_MAXRANGE;    // Ampiezza MAX candela/range in punti (live: 4000=40 punti; 0=off)

input group "=== Gap Fill (opzionale, tipico USA) ==="
input bool   InpUseGapFill    = ABTG_DEF_USE_GAPFILL; // Attiva modalita' gap fill se InpEntryMode=GAPFILL
input double InpGapMinPoints  = 150;                  // Gap minimo (in punti) per operare
input double InpGapMinRR      = 1.5;                  // Rapporto rischio/rendimento minimo (PDF: 1:1.5)

input group "=== Filtro di trend (opzionale) ==="
input bool   InpUseEmaFilter  = false;                // Filtro EMA: opera solo a favore di trend
input int    InpEmaFast       = 14;                   // EMA veloce
input int    InpEmaSlow       = 200;                  // EMA lenta
input ENUM_TIMEFRAMES InpFilterTF = PERIOD_H1;        // Timeframe del filtro EMA
input bool   InpUseSupertrend = false;                // Filtro Supertrend
input int    InpStAtrPeriod   = 10;                   // ATR del Supertrend
input double InpStMultiplier  = 2.5;                  // Moltiplicatore Supertrend
input ENUM_TIMEFRAMES InpStTF = PERIOD_H1;            // Timeframe del Supertrend

input group "=== Filtro di correlazione (opzionale) ==="
input bool   InpUseCorrelation = false;               // Opera solo se l'indice guida concorda
input string InpCorrSymbol     = "SPXUSD";            // Indice guida (es. SPXUSD)
input ENUM_TIMEFRAMES InpCorrTF = PERIOD_H1;          // Timeframe correlazione
input int    InpCorrEmaFast    = 14;                  // EMA veloce indice guida
input int    InpCorrEmaSlow    = 100;                 // EMA lenta indice guida

input group "=== Rischio e gestione ==="
input double InpRiskPercent    = ABTG_DEF_RISK;       // Rischio per trade in % (piano: max 2%)
input ENUM_ABTG_SL InpSLMode   = ABTG_SL_RANGE;       // Come calcolo lo stop loss
input double InpAtrSlMult       = 1.5;                // (SL_ATR) stop = X * ATR
input int    InpAtrPeriodMgmt   = 14;                 // Periodo ATR per gestione
input double InpTP1_R           = 1.0;                // 1o obiettivo in R (se non uso i numeri tondi)
input double InpTP1_ClosePct    = 50;                 // % di posizione chiusa al 1o obiettivo (piano: "dimezzo")
input bool   InpBreakevenAtTP1  = true;               // Sposta stop in pari dopo la parziale
input bool   InpUseTrailing     = true;               // Attiva trailing stop
input ENUM_ABTG_TRAIL InpTrailMode = (ENUM_ABTG_TRAIL)ABTG_DEF_TRAIL_MODE; // Tipo di trailing
input ENUM_TIMEFRAMES InpTrailTF = PERIOD_M1;         // (TRAIL_PREVBAR) TF della candela per il trailing (piano: M1)
input double InpTrailAtrMult    = 2.0;                // (TRAIL_ATR) trailing = X * ATR
input double InpTrailFixedPts   = 410;                // (TRAIL_FIXED) trailing in punti (piano DAX: 410 punti)

input group "=== Obiettivi a numeri tondi (approx. Multipivot/%Custom) ==="
input bool   InpUseRoundLevels  = false;              // Usa i numeri tondi come 1o obiettivo
input double InpRoundStep       = 100.0;              // Passo della griglia di numeri tondi (in PREZZO)
input double InpRoundMinDistPts = 50;                 // Distanza minima dall'ingresso (punti) per validare il livello

input group "=== Filtro notizie (file CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter   = false;              // Blocca il trading intorno alle news importanti
input string InpNewsFile        = "abtg_news.csv";    // File CSV con le notizie (in MQL5/Files)
input int    InpNewsMinImpact   = 3;                  // Impatto minimo da filtrare (3=High "3 tori")
input int    InpNewsBeforeMin   = 30;                 // Minuti di stop PRIMA della news
input int    InpNewsAfterMin    = 30;                 // Minuti di stop DOPO la news
input int    InpNewsShiftMinutes= 0;                  // Sposta gli orari del file per allinearli al SERVER
input string InpNewsCurrencies  = "";                 // Valute da filtrare, es. "USD,EUR" (vuoto = tutte)
input bool   InpNewsFlatten     = true;               // Chiudi posizioni e cancella pendenti prima della news

input group "=== Slippage & floor SL (consiglio amico) ==="
input double InpSlippagePts   = 100;    // OTT: slippage onesto 100 pt
input double InpMinStopPts    = 200;    // OTT: floor SL 200 pt (consiglio amico)
input bool   InpSkipIfTight   = true;   // Se lo stop del breakout < floor -> SALTA il trade (invece di entrare troppo stretto)

input group "=== Generali ==="
input long   InpMagic          = ABTG_DEF_MAGIC;      // Numero magico (identifica i trade dell'EA)
input int    InpMaxSpread      = 0;                   // Spread massimo in punti (0 = nessun limite)
input bool   InpVerbose        = true;                // Stampa messaggi nel log

//==================================================================
//  STATO INTERNO
//==================================================================
CTrade   gTrade;

// handle indicatori
int      gEmaFastH = INVALID_HANDLE;
int      gEmaSlowH = INVALID_HANDLE;
int      gAtrH     = INVALID_HANDLE;

// macchina a stati della giornata
enum ENUM_PHASE { PH_WAIT_OPEN, PH_BUILDING, PH_PLACED, PH_DONE };
ENUM_PHASE gPhase   = PH_WAIT_OPEN;
int      gDayStamp  = -1;          // per accorgersi del cambio giorno

double   gRangeHigh = 0;
double   gRangeLow  = 0;
ulong    gBuyTicket = 0;           // ticket ordine pendente buy
ulong    gSellTicket= 0;           // ticket ordine pendente sell
bool     gPartialDone = false;     // parziale gia' eseguita?

// calendario news caricato da file CSV
datetime gNewsTime[];              // orario evento (server, gia' shiftato)
int      gNewsImpact[];            // impatto: 3=High, 2=Medium, 1=Low
string   gNewsCcy[];               // valuta dell'evento
int      gNewsCount = 0;

//+------------------------------------------------------------------+
//| Log helper                                                       |
//+------------------------------------------------------------------+
void ABTGLog(string msg)
  {
   if(InpVerbose)
      Print("[", ABTG_DEF_NAME, "] ", msg);
  }

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int ABTG_OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(20);

   gAtrH = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriodMgmt);
   if(gAtrH == INVALID_HANDLE)
     {
      Print("ERRORE: handle ATR non creato.");
      return(INIT_FAILED);
     }

   if(InpUseEmaFilter)
     {
      gEmaFastH = iMA(_Symbol, InpFilterTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
      gEmaSlowH = iMA(_Symbol, InpFilterTF, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
      if(gEmaFastH == INVALID_HANDLE || gEmaSlowH == INVALID_HANDLE)
        {
         Print("ERRORE: handle EMA non creati.");
         return(INIT_FAILED);
        }
     }

   if(InpUseNewsFilter)
      LoadNews();

   ABTGLog(StringFormat("avviato su %s. Apertura server %02d:%02d, range %d min, flat %02d:%02d.",
                        _Symbol, InpSessionHour, InpSessionMin, InpRangeMinutes,
                        InpCloseHour, InpCloseMin));
   ABTGLog("RICORDA: gli orari sono quelli del SERVER del broker (quelli sul grafico), non l'ora italiana.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Carica le news da un file CSV in MQL5/Files.                     |
//|  Formato per riga (separatore ';'):                              |
//|    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo                  |
//|  Impatto: High/Medium/Low oppure 3/2/1. Righe non valide (es.    |
//|  intestazione) vengono ignorate.                                 |
//+------------------------------------------------------------------+
void LoadNews()
  {
   gNewsCount = 0;
   ArrayResize(gNewsTime, 0);
   ArrayResize(gNewsImpact, 0);
   ArrayResize(gNewsCcy, 0);

   int h = FileOpen(InpNewsFile, FILE_READ|FILE_CSV|FILE_ANSI, ';');
   if(h == INVALID_HANDLE)
     {
      ABTGLog("ATTENZIONE: file news '"+InpNewsFile+"' non trovato in MQL5/Files. Filtro news disattivato di fatto.");
      return;
     }

   while(!FileIsEnding(h))
     {
      string sTime = FileReadString(h);
      if(FileIsLineEnding(h) && StringLen(sTime) == 0) continue;
      string sImp  = FileIsLineEnding(h) ? "" : FileReadString(h);
      string sCcy  = FileIsLineEnding(h) ? "" : FileReadString(h);
      // consumo eventuali colonne extra (es. titolo) fino a fine riga
      while(!FileIsLineEnding(h) && !FileIsEnding(h)) FileReadString(h);

      datetime t = StringToTime(sTime);
      if(t <= 0) continue;                    // riga non valida (intestazione ecc.)
      t += InpNewsShiftMinutes * 60;          // allineo all'orario del server

      int imp = ImpactToInt(sImp);

      int n = gNewsCount;
      ArrayResize(gNewsTime,   n+1);
      ArrayResize(gNewsImpact, n+1);
      ArrayResize(gNewsCcy,    n+1);
      gNewsTime[n]   = t;
      gNewsImpact[n] = imp;
      gNewsCcy[n]    = sCcy;
      gNewsCount     = n+1;
     }
   FileClose(h);
   ABTGLog(StringFormat("news caricate: %d eventi dal file '%s'.", gNewsCount, InpNewsFile));
  }

//+------------------------------------------------------------------+
//| Converte l'impatto testuale/numerico in intero (3/2/1/0)        |
//+------------------------------------------------------------------+
int ImpactToInt(string s)
  {
   string u = s;
   StringToUpper(u);
   StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0 || u=="3") return(3);
   if(StringFind(u,"MED") >=0 || u=="2") return(2);
   if(StringFind(u,"LOW") >=0 || u=="1") return(1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Siamo nella finestra di blackout di una news importante?         |
//+------------------------------------------------------------------+
bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter || gNewsCount == 0) return(false);
   bool filterCcy = (StringLen(InpNewsCurrencies) > 0);

   for(int i = 0; i < gNewsCount; i++)
     {
      if(gNewsImpact[i] < InpNewsMinImpact) continue;
      if(filterCcy && StringFind(InpNewsCurrencies, gNewsCcy[i]) < 0) continue;

      datetime from = gNewsTime[i] - InpNewsBeforeMin*60;
      datetime to   = gNewsTime[i] + InpNewsAfterMin*60;
      if(now >= from && now <= to) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione                                               |
//+------------------------------------------------------------------+
void ABTG_OnDeinit(const int reason)
  {
   if(gAtrH     != INVALID_HANDLE) IndicatorRelease(gAtrH);
   if(gEmaFastH != INVALID_HANDLE) IndicatorRelease(gEmaFastH);
   if(gEmaSlowH != INVALID_HANDLE) IndicatorRelease(gEmaSlowH);
  }

//+------------------------------------------------------------------+
//| Loop principale                                                  |
//+------------------------------------------------------------------+
void ABTG_OnTick()
  {
   //--- la gestione della posizione va fatta ad ogni tick
   ManagePosition();
   HandleOCO();

   //--- reset a inizio di ogni nuovo giorno
   MqlDateTime now;
   TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year != gDayStamp)
     {
      gDayStamp = now.day_of_year;
      ResetDay();
     }

   //--- FILTRO NEWS: se siamo vicino a un dato importante, "tolgo tutto"
   //    (come dice il piano: prima di un dato a 3 tori si azzera l'esposizione)
   bool newsBlk = InNewsBlackout(TimeCurrent());
   if(newsBlk && InpNewsFlatten)
     {
      CancelMyPendings();
      if(SelectMyPosition()) gTrade.PositionClose(_Symbol);
     }

   //--- a fine sessione: cancella i pendenti ed (eventualmente) chiudi
   if(TimeInMinutes(now) >= InpCloseHour*60 + InpCloseMin)
     {
      EndOfSession();
      return;
     }

   int nowMin     = TimeInMinutes(now);
   int openMin     = InpSessionHour*60 + InpSessionMin;
   int rangeEndMin = openMin + InpRangeMinutes;

   switch(gPhase)
     {
      case PH_WAIT_OPEN:
         // per il gap fill valuto gia' all'apertura; per il breakout aspetto il range
         if(nowMin >= openMin)
            gPhase = PH_BUILDING;
         break;

      case PH_BUILDING:
         // durante il blackout news non piazzo nulla: aspetto che passi
         if(newsBlk) break;
         // costruisco il range e poi piazzo gli ordini.
         // avanzo a PH_PLACED SOLO se la decisione e' stata presa (orari/dati ok):
         // se i dati M1 non sono ancora pronti riprovo al tick successivo.
         if(InpEntryMode == ABTG_GAPFILL && InpUseGapFill)
           {
            if(nowMin >= rangeEndMin)   // aspetto almeno la prima finestra come "conferma"
              { if(TryPlaceGapFill()) gPhase = PH_PLACED; }
           }
         else // BREAKOUT
           {
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            if(nowMin >= refEndMin)
              { if(TryPlaceBreakout()) gPhase = PH_PLACED; }
           }
         break;

      case PH_PLACED:
      case PH_DONE:
         break;
     }
  }

//+------------------------------------------------------------------+
//| Reset dello stato a inizio giornata                              |
//+------------------------------------------------------------------+
void ResetDay()
  {
   gPhase      = PH_WAIT_OPEN;
   gRangeHigh  = 0;
   gRangeLow   = 0;
   gBuyTicket  = 0;
   gSellTicket = 0;
   gPartialDone= false;
   ABTGLog("nuovo giorno: stato resettato, in attesa dell'apertura.");
  }

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno                                    |
//+------------------------------------------------------------------+
int TimeInMinutes(const MqlDateTime &t)
  {
   return(t.hour*60 + t.min);
  }

//+------------------------------------------------------------------+
//| Calcola i livelli max/min secondo InpRangeMode                   |
//|  - OPENING: primi N minuti dopo l'apertura                       |
//|  - PREV:    finestra di N minuti prima dell'apertura             |
//|  - PREVBAR: candela precedente su InpLevelTF (piano Nasdaq: H1)  |
//+------------------------------------------------------------------+
bool ComputeLevels(double &hi, double &lo)
  {
   if(InpRangeMode == ABTG_RANGE_PREVBAR)
     {
      // "massimi/minimi precedenti": massimo e minimo dell'ULTIMA candela chiusa su InpLevelTF
      hi = iHigh(_Symbol, InpLevelTF, 1);
      lo = iLow (_Symbol, InpLevelTF, 1);
      return(hi > 0 && lo > 0 && hi > lo);
     }

   int openMin = InpSessionHour*60 + InpSessionMin;
   int fromMin, toMin;
   if(InpRangeMode == ABTG_RANGE_OPENING)
     { fromMin = openMin; toMin = openMin + InpRangeMinutes; }
   else // ABTG_RANGE_PREV
     { fromMin = openMin - InpPrevWindowMin; toMin = openMin; }

   return(ComputeRangeWindow(fromMin, toMin, hi, lo));
  }

//+------------------------------------------------------------------+
//| Calcola il range (massimo/minimo) su una finestra in minuti     |
//|  fromMin/toMin sono minuti dall'inizio giornata (server)         |
//+------------------------------------------------------------------+
bool ComputeRangeWindow(int fromMin, int toMin, double &hi, double &lo)
  {
   //--- costruisco i datetime di inizio/fine finestra per OGGI
   MqlDateTime d;
   TimeToStruct(TimeCurrent(), d);
   d.hour = fromMin/60; d.min = fromMin%60; d.sec = 0;
   datetime tStart = StructToTime(d);
   d.hour = toMin/60;   d.min = toMin%60;   d.sec = 0;
   datetime tEnd   = StructToTime(d);

   int idxStart = iBarShift(_Symbol, PERIOD_M1, tStart, false);
   int idxEnd   = iBarShift(_Symbol, PERIOD_M1, tEnd,   false);
   if(idxStart < 0 || idxEnd < 0) return(false);

   // su M1 l'indice piu' vecchio ha numero piu' alto
   int count = MathAbs(idxStart - idxEnd) + 1;
   if(count < 1) return(false);

   int hIdx = iHighest(_Symbol, PERIOD_M1, MODE_HIGH, count, MathMin(idxStart,idxEnd));
   int lIdx = iLowest (_Symbol, PERIOD_M1, MODE_LOW,  count, MathMin(idxStart,idxEnd));
   if(hIdx < 0 || lIdx < 0) return(false);

   hi = iHigh(_Symbol, PERIOD_M1, hIdx);
   lo = iLow (_Symbol, PERIOD_M1, lIdx);
   return(hi > 0 && lo > 0 && hi > lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti di breakout (BUY STOP / SELL STOP)   |
//|  Ritorna true quando la decisione e' presa (orari/dati ok),     |
//|  false se i dati non sono pronti e conviene riprovare.          |
//+------------------------------------------------------------------+
bool TryPlaceBreakout()
  {
   if(!ComputeLevels(gRangeHigh, gRangeLow))
     { ABTGLog("livelli non ancora calcolabili (dati non pronti): riprovo."); return(false); }

   //--- FILTRO AMPIEZZA (strategia live: candela deve stare tra 17 e 40 punti indice)
   double rangePts = (gRangeHigh - gRangeLow) / _Point;
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(StringFormat("candela %.0f pt < min %.0f: niente trade (whipsaw).", rangePts, InpMinRangePts)); return(true); }
   if(InpMaxRangePts > 0 && rangePts > InpMaxRangePts)
     { ABTGLog(StringFormat("candela %.0f pt > max %.0f: niente trade (stop troppo largo).", rangePts, InpMaxRangePts)); return(true); }

   if(!SpreadOK()) { ABTGLog("spread troppo alto: nessun ordine oggi."); return(true); }

   double buffer  = EffectiveBuffer();
   double buyPx   = NormalizePrice(gRangeHigh + buffer);
   double sellPx  = NormalizePrice(gRangeLow  - buffer);

   int  bias    = TrendBias();                 // 0 entrambi, +1 solo long, -1 solo short, 2 conflitto (nessuno)
   bool longOK  = (bias == 0 || bias == +1);
   bool shortOK = (bias == 0 || bias == -1);

   datetime expiry = TimeCurrent() + InpPendingExpiryMin*60;

   //--- BUY STOP (con slippage sull'entry + floor minimo di SL - consiglio amico)
   if(InpAllowLong && longOK)
     {
      double entry = NormalizePrice(buyPx + InpSlippagePts*_Point);   // slippage: in realta' si riempie OLTRE il livello
      double sl    = (InpSLMode == ABTG_SL_RANGE) ? sellPx : entry - AtrValue()*InpAtrSlMult;
      sl = NormalizePrice(sl);
      double dist  = entry - sl;
      bool   skip  = false;
      if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
        {
         if(InpSkipIfTight) { skip=true; ABTGLog(StringFormat("BUY saltato: stop %.0f pt < floor %.0f pt (troppo stretto per lo slippage).", dist/_Point, InpMinStopPts)); }
         else               { sl = NormalizePrice(entry - InpMinStopPts*_Point); dist = entry - sl; }
        }
      double lot = skip ? 0.0 : CalcLotByRisk(dist);
      double tp  = (InpTP1_R > 0) ? NormalizePrice(entry + dist*TpTotalR()) : 0.0;
      if(!skip && lot > 0 && dist > 0)
        {
         if(gTrade.BuyStop(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" BUY"))
           { gBuyTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("BUY STOP @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
         else
            ABTGLog("BUY STOP fallito: "+gTrade.ResultRetcodeDescription());
        }
     }

   //--- SELL STOP (con slippage sull'entry + floor minimo di SL - consiglio amico)
   if(InpAllowShort && shortOK)
     {
      double entry = NormalizePrice(sellPx - InpSlippagePts*_Point);  // slippage: in realta' si riempie OLTRE il livello
      double sl    = (InpSLMode == ABTG_SL_RANGE) ? buyPx : entry + AtrValue()*InpAtrSlMult;
      sl = NormalizePrice(sl);
      double dist  = sl - entry;
      bool   skip  = false;
      if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
        {
         if(InpSkipIfTight) { skip=true; ABTGLog(StringFormat("SELL saltato: stop %.0f pt < floor %.0f pt (troppo stretto per lo slippage).", dist/_Point, InpMinStopPts)); }
         else               { sl = NormalizePrice(entry + InpMinStopPts*_Point); dist = sl - entry; }
        }
      double lot = skip ? 0.0 : CalcLotByRisk(dist);
      double tp  = (InpTP1_R > 0) ? NormalizePrice(entry - dist*TpTotalR()) : 0.0;
      if(!skip && lot > 0 && dist > 0)
        {
         if(gTrade.SellStop(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" SELL"))
           { gSellTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("SELL STOP @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
         else
            ABTGLog("SELL STOP fallito: "+gTrade.ResultRetcodeDescription());
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Modalita' GAP FILL: se apre in gap, opero verso la chiusura      |
//| precedente. Gap up -> SELL verso il fill; gap down -> BUY.       |
//+------------------------------------------------------------------+
bool TryPlaceGapFill()
  {
   double prevClose = iClose(_Symbol, PERIOD_D1, 1);   // chiusura di ieri
   double todayOpen = iOpen (_Symbol, PERIOD_D1, 0);   // apertura di oggi
   if(prevClose <= 0 || todayOpen <= 0) return(false); // dati non pronti: riprovo

   double gap = (todayOpen - prevClose) / _Point;      // gap in punti (segno = direzione)
   if(MathAbs(gap) < InpGapMinPoints)
     { ABTGLog(StringFormat("gap %.0f pt < soglia %.0f: nessuna operazione.", gap, InpGapMinPoints)); return(true); }

   if(!SpreadOK()) { ABTGLog("spread troppo alto: salto il gap fill."); return(true); }

   //--- livelli della prima finestra di apertura (la "conferma" del PDF, es. prime candele)
   int openMin = InpSessionHour*60 + InpSessionMin;
   double hi, lo;
   if(!ComputeRangeWindow(openMin, openMin + InpRangeMinutes, hi, lo))
     { ABTGLog("gap fill: livelli di apertura non pronti, riprovo."); return(false); }

   double buffer = EffectiveBuffer();
   double tp     = NormalizePrice(prevClose);   // obiettivo = chiusura precedente (fill completo)
   datetime expiry = TimeCurrent() + InpPendingExpiryMin*60;

   int  bias    = TrendBias();
   bool longOK  = (bias == 0 || bias == +1);
   bool shortOK = (bias == 0 || bias == -1);

   if(gap > 0 && InpAllowShort && shortOK)
     {
      // GAP UP -> mi aspetto il ritorno giu': SELL STOP al break sotto il minimo iniziale,
      // SL sopra il massimo iniziale, TP = chiusura precedente (come esempio Nasdaq del PDF)
      double entry = NormalizePrice(lo - buffer);
      double sl    = NormalizePrice(hi + buffer);
      double risk  = sl - entry;
      double reward= entry - tp;
      if(risk <= 0 || reward <= 0) { ABTGLog("gap fill up: geometria non valida."); return(true); }
      if(reward/risk < InpGapMinRR)
        { ABTGLog(StringFormat("gap fill up: RR %.2f < %.2f, salto.", reward/risk, InpGapMinRR)); return(true); }
      double lot = CalcLotByRisk(risk);
      if(lot > 0 && gTrade.SellStop(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" GAPFILL SELL"))
         ABTGLog(StringFormat("GAP UP %.0f pt -> SELL STOP @ %.5f  SL %.5f  TP %.5f (RR %.2f)", gap, entry, sl, tp, reward/risk));
     }
   else if(gap < 0 && InpAllowLong && longOK)
     {
      // GAP DOWN -> mi aspetto la risalita: BUY STOP al break sopra il massimo iniziale,
      // SL sotto il minimo iniziale, TP = chiusura precedente
      double entry = NormalizePrice(hi + buffer);
      double sl    = NormalizePrice(lo - buffer);
      double risk  = entry - sl;
      double reward= tp - entry;
      if(risk <= 0 || reward <= 0) { ABTGLog("gap fill down: geometria non valida."); return(true); }
      if(reward/risk < InpGapMinRR)
        { ABTGLog(StringFormat("gap fill down: RR %.2f < %.2f, salto.", reward/risk, InpGapMinRR)); return(true); }
      double lot = CalcLotByRisk(risk);
      if(lot > 0 && gTrade.BuyStop(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" GAPFILL BUY"))
         ABTGLog(StringFormat("GAP DOWN %.0f pt -> BUY STOP @ %.5f  SL %.5f  TP %.5f (RR %.2f)", gap, entry, sl, tp, reward/risk));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Somma degli R fino al take profit finale (per gli ordini stop)  |
//|  Se c'e' parziale a TP1_R lascio comunque un TP piu' ampio.     |
//+------------------------------------------------------------------+
double TpTotalR()
  {
   // TP dell'ordine impostato piu' lontano (es. 3R); la parziale a TP1_R
   // e la gestione avvengono comunque via ManagePosition().
   double r = InpTP1_R > 0 ? InpTP1_R*3.0 : 0.0;
   return(r <= 0 ? 3.0 : r);
  }

//+------------------------------------------------------------------+
//| Bias di trend combinato (filtri EMA + Supertrend + correlazione)|
//|  Ritorna +1 (solo long), -1 (solo short), 0 (entrambi consentiti)|
//+------------------------------------------------------------------+
int TrendBias()
  {
   int bias = 0;   // 0 = nessun vincolo

   if(InpUseEmaFilter)
     {
      double f[1], s[1];
      if(CopyBuffer(gEmaFastH, 0, 1, 1, f) == 1 && CopyBuffer(gEmaSlowH, 0, 1, 1, s) == 1)
        {
         int e = (f[0] > s[0]) ? +1 : (f[0] < s[0] ? -1 : 0);
         if(e != 0) bias = CombineBias(bias, e);
        }
     }

   if(InpUseSupertrend)
     {
      int st = SupertrendDir(_Symbol, InpStTF, InpStAtrPeriod, InpStMultiplier);
      if(st != 0) bias = CombineBias(bias, st);
     }

   if(InpUseCorrelation && StringLen(InpCorrSymbol) > 0)
     {
      int c = SymbolTrendDir(InpCorrSymbol, InpCorrTF, InpCorrEmaFast, InpCorrEmaSlow);
      if(c != 0) bias = CombineBias(bias, c);
     }

   return(bias);
  }

//+------------------------------------------------------------------+
//| Combina due bias: se concordi tengo la direzione, se discordi   |
//| blocco entrambe (ritorno un valore "impossibile" -> 2 nega tutto)|
//+------------------------------------------------------------------+
int CombineBias(int a, int b)
  {
   if(a == 0) return(b);
   if(a == b) return(a);
   return(2);   // 2 = conflitto: TrendBias>=0 e <=0 entrambi falsi -> nessun ordine
  }

//+------------------------------------------------------------------+
//| Direzione EMA di un simbolo qualunque (per la correlazione)     |
//+------------------------------------------------------------------+
int SymbolTrendDir(string sym, ENUM_TIMEFRAMES tf, int fast, int slow)
  {
   int hf = iMA(sym, tf, fast, 0, MODE_EMA, PRICE_CLOSE);
   int hs = iMA(sym, tf, slow, 0, MODE_EMA, PRICE_CLOSE);
   if(hf == INVALID_HANDLE || hs == INVALID_HANDLE) return(0);
   double f[1], s[1];
   int dir = 0;
   if(CopyBuffer(hf, 0, 1, 1, f) == 1 && CopyBuffer(hs, 0, 1, 1, s) == 1)
      dir = (f[0] > s[0]) ? +1 : (f[0] < s[0] ? -1 : 0);
   IndicatorRelease(hf);
   IndicatorRelease(hs);
   return(dir);
  }

//+------------------------------------------------------------------+
//| Direzione del Supertrend (MT5 non lo ha nativo: lo calcolo qui) |
//|  Ritorna +1 (rialzo), -1 (ribasso), 0 (dati insufficienti)      |
//+------------------------------------------------------------------+
int SupertrendDir(string sym, ENUM_TIMEFRAMES tf, int atrPeriod, double mult)
  {
   int need = atrPeriod + 205;
   MqlRates r[];
   ArraySetAsSeries(r, true);
   int copied = CopyRates(sym, tf, 0, need, r);
   if(copied < atrPeriod + 5) return(0);

   int atrH = iATR(sym, tf, atrPeriod);
   if(atrH == INVALID_HANDLE) return(0);
   double atr[];
   ArraySetAsSeries(atr, true);
   if(CopyBuffer(atrH, 0, 0, copied, atr) < copied) { IndicatorRelease(atrH); return(0); }
   IndicatorRelease(atrH);

   // calcolo iterativo dalla candela piu' vecchia alla piu' recente chiusa (indice 1).
   // parto da copied-2 perche' uso r[i+1] (la candela precedente) come riferimento.
   double finalUpper = 0, finalLower = 0;
   int    dir = +1;
   for(int i = copied - 2; i >= 1; i--)
     {
      double hl2  = (r[i].high + r[i].low) / 2.0;
      double bUp  = hl2 + mult * atr[i];
      double bLo  = hl2 - mult * atr[i];

      double prevFU = (finalUpper == 0) ? bUp : finalUpper;
      double prevFL = (finalLower == 0) ? bLo : finalLower;
      double prevClose = r[i+1].close;

      double fU = (bUp < prevFU || prevClose > prevFU) ? bUp : prevFU;
      double fL = (bLo > prevFL || prevClose < prevFL) ? bLo : prevFL;

      if(r[i].close > (dir == -1 ? prevFU : fU))      dir = +1;
      else if(r[i].close < (dir == +1 ? prevFL : fL)) dir = -1;

      finalUpper = fU;
      finalLower = fL;
     }
   return(dir);
  }

//+------------------------------------------------------------------+
//| Valore ATR corrente (candela chiusa)                            |
//+------------------------------------------------------------------+
double AtrValue()
  {
   double a[1];
   if(CopyBuffer(gAtrH, 0, 1, 1, a) < 1) return(0);
   return(a[0]);
  }

//+------------------------------------------------------------------+
//| Lotto in base al rischio % sullo stop                           |
//+------------------------------------------------------------------+
double CalcLotByRisk(double slDistancePrice)
  {
   if(slDistancePrice <= 0) return(0);
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickValue <= 0) return(0);

   double ticks      = slDistancePrice / tickSize;
   double lossPerLot = ticks * tickValue;
   if(lossPerLot <= 0) return(0);

   double lot = riskMoney / lossPerLot;

   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep <= 0) lotStep = 0.01;

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));
   return(lot);
  }

//+------------------------------------------------------------------+
//| Cancella tutti gli ordini pendenti di QUESTO EA sul simbolo      |
//+------------------------------------------------------------------+
void CancelMyPendings()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC) != InpMagic) continue;
      gTrade.OrderDelete(ticket);
     }
   gBuyTicket  = 0;
   gSellTicket = 0;
  }

//+------------------------------------------------------------------+
//| OCO: se una posizione dell'EA e' aperta, cancella i pendenti     |
//+------------------------------------------------------------------+
void HandleOCO()
  {
   if(!HasOpenPosition()) return;
   CancelMyPendings();
  }

//+------------------------------------------------------------------+
//| Gestione posizione: parziale al 1o target, breakeven, trailing  |
//+------------------------------------------------------------------+
void ManagePosition()
  {
   if(!SelectMyPosition()) return;

   long   type   = PositionGetInteger(POSITION_TYPE);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl     = PositionGetDouble(POSITION_SL);
   double tp     = PositionGetDouble(POSITION_TP);
   double vol    = PositionGetDouble(POSITION_VOLUME);
   ulong  ticket = PositionGetInteger(POSITION_TICKET);

   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   // distanza di rischio iniziale (per calcolare 1R)
   double riskDist = (type == POSITION_TYPE_BUY) ? (openP - InitialSL(openP, sl, type)) : (InitialSL(openP, sl, type) - openP);
   if(riskDist <= 0) riskDist = AtrValue()*InpAtrSlMult;

   //--- 1) PARZIALE al primo obiettivo
   if(!gPartialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)
     {
      int dirSign = (type == POSITION_TYPE_BUY) ? +1 : -1;

      // obiettivo: numero tondo (se attivo) oppure R-multiplo
      double target;
      if(InpUseRoundLevels && InpRoundStep > 0)
         target = NextRoundLevel(openP, dirSign, InpRoundStep, InpRoundMinDistPts*_Point);
      else
         target = openP + dirSign*riskDist*InpTP1_R;

      bool reached = (target > 0) &&
                     ((type == POSITION_TYPE_BUY) ? (bid >= target) : (ask <= target));
      if(reached)
        {
         double closeVol = NormalizeVolume(vol * InpTP1_ClosePct/100.0);
         if(closeVol > 0 && closeVol < vol)
           {
            if(gTrade.PositionClosePartial(ticket, closeVol))
              {
               gPartialDone = true;
               ABTGLog(StringFormat("1o obiettivo @ %.5f: chiusa parziale %.2f lotti.", target, closeVol));
               //--- 2) BREAKEVEN sul residuo
               if(InpBreakevenAtTP1)
                 {
                  double be = NormalizePrice(openP);
                  gTrade.PositionModify(_Symbol, be, tp);
                 }
              }
           }
        }
     }

   //--- 3) TRAILING STOP (protegge i profitti)
   if(InpUseTrailing)
     {
      if(type == POSITION_TYPE_BUY)
        {
         double newSL = TrailStopBuy(bid);
         if(newSL > 0 && newSL > sl && newSL > openP)
            gTrade.PositionModify(_Symbol, NormalizePrice(newSL), PositionGetDouble(POSITION_TP));
        }
      else if(type == POSITION_TYPE_SELL)
        {
         double newSL = TrailStopSell(ask);
         if(newSL > 0 && (newSL < sl || sl == 0) && newSL < openP)
            gTrade.PositionModify(_Symbol, NormalizePrice(newSL), PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Nuovo stop di trailing per un LONG secondo InpTrailMode          |
//+------------------------------------------------------------------+
double TrailStopBuy(double bid)
  {
   if(InpTrailMode == ABTG_TRAIL_PREVBAR)
      return(iLow(_Symbol, InpTrailTF, 1));                 // base (minimo) candela prec.
   if(InpTrailMode == ABTG_TRAIL_FIXED)
      return(bid - InpTrailFixedPts * _Point);
   double atr = AtrValue();                                 // ABTG_TRAIL_ATR
   return(atr > 0 ? bid - atr*InpTrailAtrMult : 0);
  }

//+------------------------------------------------------------------+
//| Nuovo stop di trailing per uno SHORT secondo InpTrailMode        |
//+------------------------------------------------------------------+
double TrailStopSell(double ask)
  {
   if(InpTrailMode == ABTG_TRAIL_PREVBAR)
      return(iHigh(_Symbol, InpTrailTF, 1));                // base (massimo) candela prec.
   if(InpTrailMode == ABTG_TRAIL_FIXED)
      return(ask + InpTrailFixedPts * _Point);
   double atr = AtrValue();                                 // ABTG_TRAIL_ATR
   return(atr > 0 ? ask + atr*InpTrailAtrMult : 0);
  }

//+------------------------------------------------------------------+
//| Stima dello stop iniziale (se e' gia' stato spostato a BE uso    |
//| l'ATR come riferimento per il calcolo di R)                      |
//+------------------------------------------------------------------+
double InitialSL(double openP, double curSL, long type)
  {
   if(gPartialDone || curSL == 0)
      return((type == POSITION_TYPE_BUY) ? openP - AtrValue()*InpAtrSlMult
                                          : openP + AtrValue()*InpAtrSlMult);
   return(curSL);
  }

//+------------------------------------------------------------------+
//| Primo NUMERO TONDO nella direzione del trade, ad almeno         |
//| minDistPrice dal prezzo (approssima i livelli %Custom/Multipivot)|
//+------------------------------------------------------------------+
double NextRoundLevel(double price, int dir, double stepPrice, double minDistPrice)
  {
   if(stepPrice <= 0) return(0);
   double lvl;
   if(dir > 0)
     {
      lvl = MathCeil(price/stepPrice)*stepPrice;
      while(lvl - price < minDistPrice) lvl += stepPrice;
     }
   else
     {
      lvl = MathFloor(price/stepPrice)*stepPrice;
      while(price - lvl < minDistPrice) lvl -= stepPrice;
     }
   return(lvl);
  }

//+------------------------------------------------------------------+
//| Arrotonda un prezzo al TICK del simbolo (non solo ai decimali).  |
//| Necessario sui simboli con tick size > point (es. indici a       |
//| step 0.10 con 2 cifre), altrimenti il broker rifiuta l'ordine.   |
//+------------------------------------------------------------------+
double NormalizePrice(double price)
  {
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   int    dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(ts <= 0) return(NormalizeDouble(price, dg));
   return(NormalizeDouble(MathRound(price/ts)*ts, dg));
  }

//+------------------------------------------------------------------+
//| Buffer effettivo in prezzo: almeno il "livello degli stop" del   |
//| broker, cosi' gli ordini non vengono rifiutati perche' troppo    |
//| vicini (es. NASUSD ha stops level = 100 punti).                  |
//+------------------------------------------------------------------+
double EffectiveBuffer()
  {
   double stopsLvl = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double bufPts   = MathMax(InpBufferPoints, stopsLvl);
   return(bufPts * _Point);
  }

//+------------------------------------------------------------------+
//| Normalizza un volume ai vincoli del simbolo                     |
//+------------------------------------------------------------------+
double NormalizeVolume(double v)
  {
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double mn   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(step <= 0) step = 0.01;
   v = MathFloor(v/step)*step;
   if(v < mn) v = 0;   // troppo piccolo per essere chiuso separatamente
   return(v);
  }

//+------------------------------------------------------------------+
//| A fine sessione: cancella pendenti ed (eventualmente) chiudi     |
//+------------------------------------------------------------------+
void EndOfSession()
  {
   // cancella eventuali ordini pendenti dell'EA
   CancelMyPendings();
   // chiudi la posizione se richiesto
   if(InpCloseAtEnd && SelectMyPosition())
     {
      gTrade.PositionClose(_Symbol);
      ABTGLog("fine sessione: posizione chiusa.");
     }
   gPhase = PH_DONE;
  }

//+------------------------------------------------------------------+
//| Seleziona la posizione di QUESTO EA sul simbolo corrente         |
//+------------------------------------------------------------------+
bool SelectMyPosition()
  {
   if(!PositionSelect(_Symbol)) return(false);
   return(PositionGetInteger(POSITION_MAGIC) == InpMagic);
  }

bool HasOpenPosition() { return(SelectMyPosition()); }

//+------------------------------------------------------------------+
//| Spread accettabile?                                              |
//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpread <= 0) return(true);
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   return(spread <= InpMaxSpread);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
int  OnInit()                         { return ABTG_OnInit();  }
void OnDeinit(const int reason)       { ABTG_OnDeinit(reason); }
void OnTick()                         { ABTG_OnTick();         }
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

double OnTester()
  {
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   double criterion = stats[3];              // ottimizza per Recovery Factor (robusto)
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE | FILE_CSV | FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
