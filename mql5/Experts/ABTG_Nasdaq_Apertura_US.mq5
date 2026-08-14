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
//|                                                                  |
//|  ROUND 30 (R30) - due leve OPT-IN, default SPENTO (comportamento |
//|  identico a prima se non si tocca niente):                       |
//|    1) InpUseVolRegime  = regime di volatilita' adattivo          |
//|       (percentile ATR -> buffer, stop e size cambiano di scala)  |
//|    2) InpUseSRFilter   = filtro prossimita' supporti/resistenze  |
//|       (max/min del giorno prec. + numeri tondi)                  |
//|  FONTE: idee prese dai PARAMETRI di un EA esterno (amico di       |
//|  Claudio); qui NON sono copiate come verita', sono messe          |
//|  nell'imbuto del progetto e testate una alla volta come tutte le  |
//|  altre. Finche' non passano il walk-forward restano spente.       |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.02"
#property strict

//--- DEFAULT specifici per il Nasdaq (usati dal motore ABTG_ApertureCore)
#define ABTG_DEF_NAME         "Nasdaq Apertura US"
#define ABTG_DEF_MAGIC        770201
#define ABTG_DEF_SESSION_HOUR 14     // Nasdaq 15:30 IT = 14:30 server BCM
#define ABTG_DEF_SESSION_MIN  30
#define ABTG_DEF_RANGE_MIN    15     // (usato in gap fill o se passi a range di apertura)
#define ABTG_DEF_RANGE_MODE   2      // 2=massimi/minimi della CANDELA PRECEDENTE (piano: su H1)
#define ABTG_DEF_LEVEL_TF     PERIOD_H1  // piano Nasdaq: "ordini nel time frame H1"
#define ABTG_DEF_CLOSE_HOUR   21     // flat prima della chiusura serale (server)
#define ABTG_DEF_CLOSE_MIN    45
#define ABTG_DEF_USE_GAPFILL  false  // metti true + InpEntryMode=GAPFILL per il gap fill
#define ABTG_DEF_RISK         2.0    // rischio max 2% (money management del piano)
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
   ABTG_GAPFILL  = 1,   // chiusura del gap di apertura (tipico USA)
   ABTG_RETEST   = 2,   // rottura + ritorno sul livello con LIMIT (Emiliano: niente slippage)
   ABTG_RANGE_FADE = 3, // fada gli estremi del range (mercati whipsaw, es. DAX)
   ABTG_DELAYED    = 4, // entrata RITARDATA/CONFERMATA: aspetta N minuti, poi entra a mercato dalla parte scelta
   ABTG_OPENCONFIRM = 5 // la candela deve APRIRE gia' oltre il livello, poi si entra a mercato (regola delle live)
  };

//--- come si combinano le due conferme di rottura (volumi / ATR)
enum ENUM_ABTG_CONFIRM
  {
   ABTG_CONF_OR  = 0,   // basta UNA delle due (PDF: "supportata da aumento di volumi O da una volatilita' coerente")
   ABTG_CONF_AND = 1    // servono ENTRAMBE (piu' selettivo: taglia molto il campione)
  };

//--- come si sceglie la direzione nell'entrata ritardata (InpEntryMode=DELAYED)
enum ENUM_ABTG_DELAYDIR
  {
   ABTG_DIR_BREAK  = 0,  // prezzo FUORI dal range di apertura (rottura confermata); dentro il range = niente trade
   ABTG_DIR_MID    = 1,  // prezzo sopra/sotto il centro del range (c'e' sempre una direzione)
   ABTG_DIR_CANDLE = 2   // direzione del CORPO della candela di apertura (first-candle follow)
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
input bool   InpOneTradePerDay = true;                // Un solo ciclo operativo al giorno (guardia reload-safe: legge lo storico deal del giorno)
input int    InpMaxPosSimbolo  = 0;                   // A1: tetto di posizioni+pendenti sul simbolo contando TUTTI gli EA (0 = nessun limite)

input group "=== Ingresso ==="
input ENUM_ABTG_ENTRY InpEntryMode = ABTG_BREAKOUT;   // Modalita' d'ingresso
input ENUM_ABTG_RANGE InpRangeMode = (ENUM_ABTG_RANGE)ABTG_DEF_RANGE_MODE; // Da dove prendo max/min
input ENUM_TIMEFRAMES InpLevelTF   = ABTG_DEF_LEVEL_TF; // (RANGE_PREVBAR) TF dei massimi/minimi prec. (Nasdaq: H1)
input int    InpPrevWindowMin = ABTG_DEF_PREVWIN;     // (RANGE_PREV) finestra prec. in minuti (live: 5 = candela pre-apertura)
input double InpBufferPoints  = ABTG_DEF_BUFFER;      // Buffer oltre il range, in punti (live: 700 = 7 punti indice)
input ENUM_TIMEFRAMES InpOCTimeframe = PERIOD_CURRENT; // (OPENCONFIRM) TF su cui si guarda l'APERTURA della candela.
                                                       //  PERIOD_CURRENT = quello del grafico (M5): valuta ogni 5 min.
                                                       //  PERIOD_M15 = come nelle live: una sola valutazione ogni 15 min,
                                                       //  cioe' le candele 09:15, 09:30, 09:45... (ora italiana).
input int    InpPendingExpiryMin = 120;               // Cancella il pendente non eseguito dopo N minuti
input bool   InpAllowLong     = true;                 // Consenti operazioni long
input bool   InpAllowShort    = true;                 // Consenti operazioni short
input double InpMinRangePts   = ABTG_DEF_MINRANGE;    // Ampiezza MIN candela/range in punti (live: 1700=17 punti; 0=off)
input double InpMaxRangePts   = ABTG_DEF_MAXRANGE;    // Ampiezza MAX candela/range in punti (live: 4000=40 punti; 0=off)

input group "=== Retest (InpEntryMode=RETEST, leva Emiliano) ==="
input double InpRetestOffsetPts = 0;  // Offset del LIMIT DENTRO il livello, in punti (0=sul livello; >0 entra piu' in profondita', meglio ma piu' no-fill)
input double InpFadeOffsetPts   = 0;  // (RANGE_FADE) offset del LIMIT OLTRE l'estremo, in punti (0=sull'estremo; >0 fada uno spike piu' ampio)

input group "=== Entrata ritardata/confermata (InpEntryMode=DELAYED) ==="
input int    InpDelayMinutes = 30;  // Minuti DOPO l'apertura in cui si decide (salta il rumore iniziale)
input ENUM_ABTG_DELAYDIR InpDelayDirMode = ABTG_DIR_BREAK; // Come si sceglie la direzione al momento della decisione

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
input bool   InpUseSupertrend3 = false;               // (Piano Europeo) TRE Supertrend 2.5/3.0/3.5: opero solo se concordano tutti e tre

input group "=== Filtro di correlazione (opzionale) ==="
input bool   InpUseCorrelation = false;               // Opera solo se l'indice guida concorda
input string InpCorrSymbol     = "SPXUSD";            // Indice guida (es. SPXUSD)
input ENUM_TIMEFRAMES InpCorrTF = PERIOD_H1;          // Timeframe correlazione
input int    InpCorrEmaFast    = 14;                  // EMA veloce indice guida
input int    InpCorrEmaSlow    = 100;                 // EMA lenta indice guida

input group "=== Filtro VWAP (live Emiliano, opt-in) ==="
input bool   InpUseVwapFilter = false;                // Opera solo dal lato giusto della VWAP di sessione
input ENUM_TIMEFRAMES InpVwapTF = PERIOD_M15;         // TF per la VWAP (guida Emiliano: M15)

input group "=== Rischio e gestione ==="
input double InpRiskPercent    = ABTG_DEF_RISK;       // Rischio per trade in % (piano: max 2%)
input ENUM_ABTG_SL InpSLMode   = ABTG_SL_RANGE;       // Come calcolo lo stop loss
input double InpAtrSlMult       = 1.5;                // (SL_ATR) stop = X * ATR
input int    InpAtrPeriodMgmt   = 14;                 // Periodo ATR per gestione
input double InpTP1_R           = 1.0;                // 1o obiettivo in R (se non uso i numeri tondi)
input double InpTP1_ClosePct    = 50;                 // % di posizione chiusa al 1o obiettivo (piano: "dimezzo")
input bool   InpBreakevenAtTP1  = true;               // Sposta stop in pari dopo la parziale
input double InpBEatR           = 0;                  // BE indipendente: sposta SL a pari a questo R (0=off; NON chiude nulla)
input bool   InpUseTrailing     = true;               // Attiva trailing stop
input double InpTrailStartR     = 0;                  // Il trailing NON arma prima di questo profitto in R (0 = come prima: arma subito)
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
input double InpSlippagePts   = 0;      // Slippage stimato in PUNTI: peggiora l'entry del breakout (backtest ONESTO + live). 0=off
input double InpMinStopPts    = 0;      // Floor minimo di STOP in punti (~ spread+slippage+cuscinetto). 0=off
input bool   InpSkipIfTight   = true;   // Se lo stop del breakout < floor -> SALTA il trade (invece di entrare troppo stretto)

input group "=== Filtro VOLUMI (regola Emiliano: rottura valida solo con volumi) ==="
input bool   InpUseVolumeFilter = false;  // Entra solo se il volume della rottura supera la media
input double InpVolMult          = 1.5;    // Volume rottura >= X * media (Emiliano: 1.5 = +50%)
input int    InpVolAvgBars       = 20;     // Barre per la media volume
input bool   InpUseAtrFilter    = false;  // (PDF) Entra solo con volatilita' coerente: ATR >= media ATR
input int    InpAtrFilterBars   = 20;     // Barre su cui calcolo la media dell'ATR
input double InpAtrFilterMult   = 1.0;    // ATR ultima barra >= X * media (PDF: "ATR > media")
input ENUM_ABTG_CONFIRM InpConfirmMode = ABTG_CONF_OR; // Se volumi E ATR sono entrambi accesi: basta una conferma (OR, come il PDF) o servono entrambe (AND)?

input group "=== Regime di volatilita' (R30, opt-in) ==="
//  IDEA (da EA esterno, da validare nell'imbuto): non tutti i giorni sono
//  uguali. Si misura l'ATR corrente e lo si mette in PERCENTILE rispetto alle
//  ultime N barre: giornata CALMA (percentile basso) -> buffer e stop stretti,
//  giornata di TEMPESTA (percentile alto) -> buffer e stop larghi e size
//  ridotta. Non e' un filtro che blocca: e' una SCALA sui parametri.
//  ⚠️ Con InpUseVolRegime=false tutti i moltiplicatori restano 1.0 e non
//     viene creato nemmeno l'handle ATR: comportamento identico a prima.
input bool   InpUseVolRegime   = false;  // Attiva il regime di volatilita' adattivo (R30)
input int    InpVolAtrPeriod   = 14;     // ATR del regime
input int    InpVolLookback    = 100;    // Barre per il calcolo dei percentili
input double InpVolLowPct      = 20.0;   // Sotto questo percentile = CALMA
input double InpVolHighPct     = 80.0;   // Sopra questo percentile = TEMPESTA
input double InpVolLowOffMult  = 0.7;    // Moltiplicatore del BUFFER in calma
input double InpVolHighOffMult = 1.5;    // Moltiplicatore del BUFFER in tempesta
input double InpVolLowSlMult   = 0.75;   // Moltiplicatore dello STOP in calma
input double InpVolHighSlMult  = 1.5;    // Moltiplicatore dello STOP in tempesta
input double InpVolHighSizeMult= 0.5;    // Riduzione della SIZE in tempesta (1.0 = nessuna)

input group "=== Filtro S/R (R30, opt-in) ==="
//  IDEA (da EA esterno, da validare nell'imbuto): non comprare con una
//  resistenza addosso e non vendere con un supporto sotto il naso. Si
//  guardano massimo/minimo del GIORNO PRECEDENTE e i numeri tondi: se il
//  livello d'ingresso ci sbatte contro entro InpSRProximityPts, il segnale
//  si salta. Blocca SOLO l'ingresso, mai la gestione di una posizione aperta.
//  ⚠️ Punti MT5: il Nasdaq quota a 2 decimali -> 1500 punti = 15 punti indice.
input bool   InpUseSRFilter      = false;  // Attiva il filtro di prossimita' S/R (R30)
input double InpSRProximityPts   = 1500;   // Distanza minima dal livello, in punti (1500 = 15 punti indice)
input bool   InpSRUsePrevDay     = true;   // Usa massimo/minimo del GIORNO PRECEDENTE (PDH/PDL)
input bool   InpSRUseRoundNumbers= true;   // Usa i numeri tondi
input double InpSRRoundInterval  = 10000;  // Passo dei numeri tondi, in punti (10000 = 100 punti indice)

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

//--- R30: regime di volatilita' (tutto inerte se InpUseVolRegime=false).
//    I moltiplicatori restano a 1.0 finche' la feature non e' accesa, cosi'
//    anche se per errore qualcuno li leggesse fuori dai rami if non
//    cambierebbe nulla.
int      gVolAtrH    = INVALID_HANDLE;  // handle ATR DEDICATO al regime
double   gVolOffMult = 1.0;             // scala del buffer d'ingresso
double   gVolSlMult  = 1.0;             // scala della distanza di stop
double   gVolSizeMult= 1.0;             // scala della size (solo in tempesta)
double   gVolPct     = -1.0;            // ultimo percentile calcolato
int      gVolRegime  = 0;               // -1 calma, 0 normale, +1 tempesta
datetime gVolBar     = 0;               // barra dell'ultimo calcolo (1 volta per barra)

// macchina a stati della giornata
enum ENUM_PHASE { PH_WAIT_OPEN, PH_BUILDING, PH_ARMED, PH_PLACED, PH_DONE };
ENUM_PHASE gPhase   = PH_WAIT_OPEN;
int      gDayStamp  = -1;          // per accorgersi del cambio giorno
int      gGuardiaGiorno = -1;     // A4: giorno in cui la guardia reload-safe e' gia' stata fatta
//--- METRICHE DA PROP: la peggior giornata singola.
//    Il drawdown di equity complessivo dice se il conto sopravvive nel tempo;
//    una prop invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra
//    cosa e non era misurata da nessuna parte. Qui si segue l'equity dentro
//    la giornata e si tiene la caduta peggiore rispetto all'apertura del giorno.
double   gDayStartEquity = 0.0;   // equity all'inizio della giornata
double   gDayMinEquity   = 0.0;   // minimo di equity toccato nella giornata
double   gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)

double   gRangeHigh = 0;
double   gRangeLow  = 0;
ulong    gBuyTicket = 0;           // ticket ordine pendente buy
ulong    gSellTicket= 0;           // ticket ordine pendente sell
// gestione PER-TICKET (Hedge-safe): ogni posizione ha il SUO stato, cosi'
// parziale e breakeven scattano su OGNI posizione aperta, non solo la prima.
// (Prima erano due bool globali -> con piu' posizioni la gestione saltava:
//  i profitti tornavano indietro fino allo stop pieno.)
ulong    gPartialTk[];             // ticket con parziale gia' eseguita
ulong    gBETk[];                  // ticket con BE indipendente gia' eseguito

// stato RETEST (rottura + ritorno sul livello con LIMIT)
double   gBuffer    = 0;           // buffer effettivo memorizzato all'arming
datetime gLastOCBar = 0;          // (OPENCONFIRM) ultima candela gia' valutata: una sola verifica per barra
int      gBias      = 0;           // bias di trend memorizzato all'arming
bool     gBrokeHigh = false;       // la rottura sopra e' gia' avvenuta?
bool     gBrokeLow  = false;       // la rottura sotto e' gia' avvenuta?

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

   //--- R30: handle ATR DEDICATO al regime di volatilita'. Creato SOLO se la
   //    feature e' accesa: a default spento l'EA non alloca niente in piu'.
   if(InpUseVolRegime)
     {
      gVolAtrH = iATR(_Symbol, PERIOD_CURRENT, InpVolAtrPeriod);
      if(gVolAtrH == INVALID_HANDLE)
        {
         Print("ERRORE: handle ATR del regime di volatilita' (R30) non creato.");
         return(INIT_FAILED);
        }
      ABTGLog(StringFormat("R30 REGIME VOLATILITA' ATTIVO: ATR(%d) su %s, lookback %d barre, soglie %.0f/%.0f percentile | calma: buffer x%.2f SL x%.2f | tempesta: buffer x%.2f SL x%.2f size x%.2f",
                           InpVolAtrPeriod, EnumToString((ENUM_TIMEFRAMES)Period()), InpVolLookback,
                           InpVolLowPct, InpVolHighPct,
                           InpVolLowOffMult, InpVolLowSlMult,
                           InpVolHighOffMult, InpVolHighSlMult, InpVolHighSizeMult));
     }

   if(InpUseSRFilter)
      ABTGLog(StringFormat("R30 FILTRO S/R ATTIVO: soglia %.0f pt | giorno prec.=%s | numeri tondi=%s (passo %.0f pt)",
                           InpSRProximityPts,
                           (InpSRUsePrevDay ? "si" : "no"),
                           (InpSRUseRoundNumbers ? "si" : "no"), InpSRRoundInterval));

   if(InpUseNewsFilter)
      LoadNews();

   ABTGLog(StringFormat("avviato su %s. Apertura server %02d:%02d, range %d min, flat %02d:%02d.",
                        _Symbol, InpSessionHour, InpSessionMin, InpRangeMinutes,
                        InpCloseHour, InpCloseMin));
   ABTGLog("RICORDA: gli orari sono quelli del SERVER del broker (quelli sul grafico), non l'ora italiana.");
   //--- Riga di CONTROLLO: MT5 salva i parametri SUL GRAFICO, quindi ricompilare
   //    non basta. Questa riga dice quali valori sta usando DAVVERO l'EA adesso:
   //    se dopo un aggiornamento non corrisponde, non e' stato premuto RIPRISTINA.
   // 07/08: aggiunti RANGE MODE e i LATI. Il 06/08 il buffer di un EA e' tornato
   // al default senza che nessuno se ne accorgesse, e questa riga non bastava a
   // vederlo: RangeMode e' il parametro che fuori campione vale -2444 EUR sul
   // Nasdaq, e non veniva stampato affatto.
   ABTGLog(StringFormat("CONFIG IN USO -> motore=%s | rangemode=%s | range=%d min | buffer=%.0f pt | offset retest=%.0f pt | lati=%s | rischio=%.2f%% | TP=%.1fR | parziale=%.0f%% | BE=%s | trail=%s %s | trail da=%.2fR",
                        EnumToString(InpEntryMode), EnumToString(InpRangeMode), InpRangeMinutes, InpBufferPoints, InpRetestOffsetPts,
                        (InpAllowLong && InpAllowShort ? "long+short" : (InpAllowLong ? "SOLO LONG" : (InpAllowShort ? "SOLO SHORT" : "NESSUNO!"))),
                        InpRiskPercent, InpTP1_R*3.0, InpTP1_ClosePct,
                        (InpBreakevenAtTP1 ? "si" : "no"),
                        EnumToString(InpTrailMode), EnumToString(InpTrailTF), InpTrailStartR));
   if(InpEntryMode == ABTG_GAPFILL && !InpUseGapFill)
      ABTGLog("NOTA: modalita' GAPFILL attiva. Il vecchio flag InpUseGapFill=false viene IGNORATO (prima faceva ricadere l'EA nel breakout senza dirlo).");
   if(InpEntryMode == ABTG_DELAYED && InpDelayDirMode == ABTG_DIR_BREAK &&
      InpRangeMode == ABTG_RANGE_OPENING && InpDelayMinutes <= InpRangeMinutes)
      ABTGLog(StringFormat("NOTA: DELAYED+BREAK con attesa %d min <= range %d min: la decisione cade alla chiusura del range, si aspetta la rottura fino a %d min dopo.",
                           InpDelayMinutes, InpRangeMinutes, InpPendingExpiryMin));
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
   if(gVolAtrH  != INVALID_HANDLE) IndicatorRelease(gVolAtrH);   // R30
  }

//+------------------------------------------------------------------+
//| Loop principale                                                  |
//+------------------------------------------------------------------+
void ABTG_OnTick()
  {
   //--- la gestione della posizione va fatta ad ogni tick
   ManagePosition();
   HandleOCO();

   //--- GUARDIA ANTI-DUPLICATO (reload-safe): se ho gia' un pendente o una posizione
   //    del mio magic, NON ripiazzo -> evita ordini doppi a ogni ricompilazione/reload.
   if(gPhase==PH_WAIT_OPEN || gPhase==PH_BUILDING)
     {
      bool _hasOrd=false;
      for(int _i=OrdersTotal()-1;_i>=0;_i--)
        {
         ulong _t=OrderGetTicket(_i);
         if(_t>0 && OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic){ _hasOrd=true; break; }
        }
      if(_hasOrd || SelectMyPosition()) gPhase=PH_PLACED;
     }

   //--- reset a inizio di ogni nuovo giorno
   MqlDateTime now;
   TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year != gDayStamp)
     {
      gDayStamp = now.day_of_year;
      ResetDay();
      gDayStartEquity = AccountInfoDouble(ACCOUNT_EQUITY);
      gDayMinEquity   = gDayStartEquity;
     }

   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del giorno
   {
    double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
    if(gDayStartEquity <= 0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(_eq < gDayMinEquity)  gDayMinEquity = _eq;
    double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
    if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
   }

   //--- A4: guardia RELOAD-SAFE. Una volta al giorno (e a ogni riavvio,
   //    perche' le variabili globali ripartono da -1) chiedo allo storico
   //    se oggi ho gia' aperto. Se si', la giornata e' finita: non riarmo.
   if(InpOneTradePerDay && gGuardiaGiorno != now.day_of_year &&
      (gPhase == PH_WAIT_OPEN || gPhase == PH_BUILDING))
     {
      // Si timbra la giornata SOLO se lo storico ha risposto davvero.
      // Timbrarla PRIMA di sapere era il difetto trovato il 14/08/2026:
      // a storico non ancora sincronizzato la guardia passava una volta
      // sola, in silenzio, e non ci riprovava mai piu'.
      bool storicoOk = false;
      bool giaFatto  = HaGiaOperatoOggi(storicoOk);
      if(!storicoOk)
        {
         ABTGLog("storico deal non ancora pronto: rimando il controllo A4 al prossimo tick.");
         return;
        }
      gGuardiaGiorno = now.day_of_year;   // una volta al giorno, non a ogni tick
      if(giaFatto)
        {
         ABTGLog("oggi ho GIA' operato (storico deal del giorno): non riarmo. Guardia reload-safe.");
         gPhase = PH_DONE;
        }
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
         //--- A1: tetto di esposizione sul simbolo, contando TUTTI gli EA
         if(InpMaxPosSimbolo > 0 && EsposizioneSimbolo() >= InpMaxPosSimbolo)
           {
            ABTGLog(StringFormat("su %s ci sono gia' %d fra posizioni e pendenti (tetto %d, tutti gli EA): non piazzo.",
                                 _Symbol, EsposizioneSimbolo(), InpMaxPosSimbolo));
            gPhase = PH_DONE;
            break;
           }
         // costruisco il range e poi piazzo gli ordini.
         // avanzo a PH_PLACED SOLO se la decisione e' stata presa (orari/dati ok):
         // se i dati M1 non sono ancora pronti riprovo al tick successivo.
         // BUG 05/08: la modalita' GAPFILL era subordinata al flag legacy InpUseGapFill.
         // Con il flag a false l'EA cadeva nel ramo BREAKOUT SENZA dirlo: nel walk-forward
         // il motore 1 ha prodotto risultati identici al centesimo al motore 0 e il gap fill
         // non e' mai stato testato. Ora comanda la modalita'; il flag resta solo storico.
         if(InpEntryMode == ABTG_GAPFILL)
           {
            if(nowMin >= rangeEndMin)   // aspetto almeno la prima finestra come "conferma"
              { if(TryPlaceGapFill()) gPhase = PH_PLACED; }
           }
         else if(InpEntryMode == ABTG_RETEST)
           {
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            if(nowMin >= refEndMin)
              { if(ArmRetest()) gPhase = PH_ARMED; }
           }
         else if(InpEntryMode == ABTG_RANGE_FADE)
           {
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            if(nowMin >= refEndMin)
              { if(TryPlaceRangeFade()) gPhase = PH_PLACED; }
           }
         else if(InpEntryMode == ABTG_OPENCONFIRM)
           {
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            if(nowMin >= refEndMin)
              { if(ArmOpenConfirm()) gPhase = PH_ARMED; }
           }
         else if(InpEntryMode == ABTG_DELAYED)
           {
            // si decide DOPO InpDelayMinutes dall'apertura, mai prima che il range sia chiuso
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            int decideMin = openMin + InpDelayMinutes;
            if(decideMin < refEndMin) decideMin = refEndMin;
            if(nowMin >= decideMin)
              { if(TryPlaceDelayed()) gPhase = PH_PLACED; }
           }
         else // BREAKOUT
           {
            int refEndMin = (InpRangeMode == ABTG_RANGE_OPENING) ? rangeEndMin : openMin;
            if(nowMin >= refEndMin)
              { if(TryPlaceBreakout()) gPhase = PH_PLACED; }
           }
         break;

      case PH_ARMED:
         if(newsBlk) break;
         if(InpEntryMode == ABTG_OPENCONFIRM) MonitorOpenConfirm();  // aspetto una candela che APRA oltre
         else                                 MonitorRetest();       // RETEST: rottura poi LIMIT sul livello
         break;

      case PH_PLACED:
      case PH_DONE:
         break;
     }
  }

//+------------------------------------------------------------------+
//| Reset dello stato a inizio giornata                              |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| A4 - HO GIA' OPERATO OGGI? (guardia reload-safe)                 |
//|                                                                  |
//|  InpOneTradePerDay esisteva come input ma NON ERA USATO da       |
//|  nessuna parte: l'unica cosa che limitava a un ciclo al giorno   |
//|  era la macchina a stati, che al riavvio riparte da zero.        |
//|  Il 05/08 alle 09:46 il riattacco degli EA ha ripiazzato i       |
//|  pendenti su una giornata gia' operata (buy stop 26.440,50,      |
//|  ticket #3078825 e #3078827): la vecchia guardia guardava solo   |
//|  se c'era un ordine APERTO in quel momento, e a trade gia'       |
//|  chiuso non vedeva niente.                                       |
//|                                                                  |
//|  Questa invece legge lo STORICO dei deal del giorno per          |
//|  simbolo+magic: se oggi una posizione l'ho gia' aperta, non      |
//|  riarmo, anche se e' gia' chiusa e anche se l'EA e' stato        |
//|  ricompilato nel frattempo.                                      |
//+------------------------------------------------------------------+
//  14/08/2026 - AGGIUNTO storicoOk (stesso difetto corretto sul DAX).
//  Appena il terminale parte lo storico dei deal puo' non essere ancora
//  sincronizzato: HistorySelect ritorna false e la vecchia versione
//  rispondeva "no, oggi non ho operato" - indistinguibile da "non lo so".
//  Adesso sono due risposte diverse, e con "non lo so" il chiamante non
//  timbra la giornata e ripete il controllo al tick dopo.
bool HaGiaOperatoOggi(bool &storicoOk)
  {
   storicoOk = false;
   MqlDateTime d;
   TimeToStruct(TimeCurrent(), d);
   d.hour = 0; d.min = 0; d.sec = 0;
   datetime inizioGiorno = StructToTime(d);

   if(!HistorySelect(inizioGiorno, TimeCurrent() + 60)) return(false);
   storicoOk = true;

   int n = HistoryDealsTotal();
   for(int i = n - 1; i >= 0; i--)
     {
      ulong tk = HistoryDealGetTicket(i);
      if(tk <= 0) continue;
      if(HistoryDealGetString(tk, DEAL_SYMBOL) != _Symbol) continue;
      if(HistoryDealGetInteger(tk, DEAL_MAGIC) != InpMagic) continue;
      if(HistoryDealGetInteger(tk, DEAL_ENTRY) == DEAL_ENTRY_IN) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| A1 - QUANTA ROBA C'E' GIA' SU QUESTO SIMBOLO, DI CHIUNQUE        |
//|                                                                  |
//|  Conta posizioni E pendenti sul simbolo IGNORANDO il magic.      |
//|  Serve contro il caso `Apertura Marco` + `DAX Apertura EU`: due  |
//|  EA identici che il 05/08 hanno fatto lo stesso trade allo       |
//|  stesso secondo allo stesso prezzo, cioe' 2% + 2% = 4% su un     |
//|  segnale solo.                                                   |
//|                                                                  |
//|  ⚠️ E' una MITIGAZIONE, non una garanzia: due EA possono         |
//|  piazzare nello stesso tick e non vedersi a vicenda. La          |
//|  soluzione pulita resta spegnerne uno. Default 0 = spento, cosi' |
//|  nessun EA acceso cambia comportamento senza una scelta.         |
//+------------------------------------------------------------------+
int EsposizioneSimbolo()
  {
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol) n++;
     }
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong tk = OrderGetTicket(i);
      if(tk > 0 && OrderGetString(ORDER_SYMBOL) == _Symbol) n++;
     }
   return(n);
  }

void ResetDay()
  {
   gPhase      = PH_WAIT_OPEN;
   gRangeHigh  = 0;
   gRangeLow   = 0;
   gBuyTicket  = 0;
   gSellTicket = 0;
   ArrayResize(gPartialTk, 0);
   ArrayResize(gBETk, 0);
   gBuffer     = 0;
   gBias       = 0;
   gBrokeHigh  = false;
   gBrokeLow   = false;
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
   if(!ConfirmOK()) { ABTGLog("rottura non confermata (ne' volumi ne' ATR sopra la media): niente trade."); return(true); }

   UpdateVolRegime();   // R30: qui si decide, quindi qui si misura il regime

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
      sl = NormalizePrice(VolRegimeSL(entry, sl));                    // R30: scala lo stop col regime
      double dist  = entry - sl;
      bool   skip  = false;
      if(SRBlocked(entry, +1)) skip = true;                           // R30: resistenza addosso -> salto
      if(!skip && InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
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
      sl = NormalizePrice(VolRegimeSL(entry, sl));                    // R30: scala lo stop col regime
      double dist  = sl - entry;
      bool   skip  = false;
      if(SRBlocked(entry, -1)) skip = true;                           // R30: supporto addosso -> salto
      if(!skip && InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
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
//| RETEST (leva Emiliano): calcola il range e i filtri, poi ARMA.   |
//|  Non piazza nulla: aspetta la rottura e il ritorno sul livello.  |
//|  Ritorna true quando la decisione e' presa; false = dati non     |
//|  pronti (riprova al tick successivo).                            |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| RANGE-FADE: mercato che apre in whipsaw -> fada gli estremi.     |
//|  SELL LIMIT sul massimo del range, BUY LIMIT sul minimo.         |
//|  Sullo spike del falso break entra all'estremo e guadagna sul    |
//|  ritorno verso il centro. SL poco oltre l'estremo (se rompe      |
//|  davvero, taglia). Adatto ai mercati ballerini (DAX).            |
//+------------------------------------------------------------------+
bool TryPlaceRangeFade()
  {
   if(!ComputeLevels(gRangeHigh, gRangeLow))
     { ABTGLog("FADE: livelli non ancora calcolabili: riprovo."); return(false); }

   double rangePts = (gRangeHigh - gRangeLow) / _Point;
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(StringFormat("FADE: candela %.0f pt < min %.0f: niente trade.", rangePts, InpMinRangePts)); return(true); }
   if(InpMaxRangePts > 0 && rangePts > InpMaxRangePts)
     { ABTGLog(StringFormat("FADE: candela %.0f pt > max %.0f: niente trade.", rangePts, InpMaxRangePts)); return(true); }
   if(!SpreadOK()) { ABTGLog("FADE: spread troppo alto: niente trade."); return(true); }
   // BUG 05/08: il fade non passava MAI dai filtri di conferma (volumi/ATR). Nel walk-forward
   // le righe con filtro volumi ON e OFF erano identiche al centesimo: il filtro non faceva nulla.
   if(!ConfirmOK()) { ABTGLog("FADE: conferma (volumi/ATR) assente: niente trade."); return(true); }

   UpdateVolRegime();   // R30: qui si decide, quindi qui si misura il regime

   int  bias    = TrendBias();
   bool longOK  = (bias == 0 || bias == +1);   // BUY LIMIT sul minimo
   bool shortOK = (bias == 0 || bias == -1);   // SELL LIMIT sul massimo
   datetime expiry = TimeCurrent() + InpPendingExpiryMin*60;

   double slDist = AtrValue()*InpAtrSlMult;
   if(slDist <= 0) slDist = EffectiveBuffer();
   if(InpUseVolRegime) slDist *= gVolSlMult;                          // R30: scala lo stop col regime
   if(InpMinStopPts > 0 && slDist < InpMinStopPts*_Point) slDist = InpMinStopPts*_Point;

   //--- SELL LIMIT sul MASSIMO (fada lo spike in alto)
   if(InpAllowShort && shortOK)
     {
      double entry = NormalizePrice(gRangeHigh + InpFadeOffsetPts*_Point);
      double sl    = NormalizePrice(entry + slDist);
      double dist  = sl - entry;
      double lot   = SRBlocked(entry, -1) ? 0.0 : CalcLotByRisk(dist);   // R30: filtro S/R
      double tp    = (InpTP1_R > 0) ? NormalizePrice(entry - dist*TpTotalR()) : 0.0;
      if(lot > 0 && dist > 0)
        {
         if(gTrade.SellLimit(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" FADE SELL"))
           { gSellTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("SELL LIMIT (fade) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
         else
            ABTGLog("SELL LIMIT (fade) fallito: "+gTrade.ResultRetcodeDescription());
        }
     }

   //--- BUY LIMIT sul MINIMO (fada lo spike in basso)
   if(InpAllowLong && longOK)
     {
      double entry = NormalizePrice(gRangeLow - InpFadeOffsetPts*_Point);
      double sl    = NormalizePrice(entry - slDist);
      double dist  = entry - sl;
      double lot   = SRBlocked(entry, +1) ? 0.0 : CalcLotByRisk(dist);   // R30: filtro S/R
      double tp    = (InpTP1_R > 0) ? NormalizePrice(entry + dist*TpTotalR()) : 0.0;
      if(lot > 0 && dist > 0)
        {
         if(gTrade.BuyLimit(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" FADE BUY"))
           { gBuyTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("BUY LIMIT (fade) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
         else
            ABTGLog("BUY LIMIT (fade) fallito: "+gTrade.ResultRetcodeDescription());
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Direzione del CORPO della candela di apertura (first-candle):    |
//|  apertura del primo minuto della finestra vs chiusura dell'ultimo|
//|  +1 corpo rialzista, -1 ribassista, 0 doji / dati non pronti.    |
//+------------------------------------------------------------------+
int OpeningBodyDir()
  {
   int openMin = InpSessionHour*60 + InpSessionMin;
   int fromMin, toMin;
   if(InpRangeMode == ABTG_RANGE_PREV)
     { fromMin = openMin - InpPrevWindowMin; toMin = openMin; }
   else
     { fromMin = openMin; toMin = openMin + InpRangeMinutes; }

   MqlDateTime d;
   TimeToStruct(TimeCurrent(), d);
   d.hour = fromMin/60; d.min = fromMin%60; d.sec = 0;
   datetime tStart = StructToTime(d);
   d.hour = toMin/60;   d.min = toMin%60;   d.sec = 0;
   datetime tEnd   = StructToTime(d);

   int idxStart = iBarShift(_Symbol, PERIOD_M1, tStart, false);
   int idxEnd   = iBarShift(_Symbol, PERIOD_M1, tEnd,   false);
   if(idxStart < 0 || idxEnd < 0) return(0);

   // su M1 l'indice piu' ALTO e' la barra piu' vecchia (inizio finestra)
   double op = iOpen (_Symbol, PERIOD_M1, MathMax(idxStart, idxEnd));
   double cl = iClose(_Symbol, PERIOD_M1, MathMin(idxStart, idxEnd));
   if(op <= 0 || cl <= 0) return(0);
   return(cl > op ? +1 : (cl < op ? -1 : 0));
  }

//+------------------------------------------------------------------+
//| ENTRATA RITARDATA / CONFERMATA (motori #4 e #6 del menu caccia). |
//|  All'apertura c'e' rumore: falsi break, whipsaw. Invece di       |
//|  piazzare pendenti si ASPETTA InpDelayMinutes, poi si guarda da  |
//|  che parte il mercato ha scelto di stare e si entra A MERCATO.   |
//|  Nessuno stop da inseguire -> niente slippage di rottura (il     |
//|  difetto che ha ucciso lo STOP breakout su Nasdaq/DAX).          |
//|  Direzione secondo InpDelayDirMode:                              |
//|    BREAK  = prezzo fuori dal range (rottura confermata)          |
//|    MID    = prezzo sopra/sotto il centro del range               |
//|    CANDLE = direzione del corpo della candela di apertura        |
//|  SL: bordo opposto del range (o ATR), come nel breakout.         |
//+------------------------------------------------------------------+
bool TryPlaceDelayed()
  {
   if(!ComputeLevels(gRangeHigh, gRangeLow))
     { ABTGLog("DELAYED: livelli non ancora calcolabili: riprovo."); return(false); }

   double rangePts = (gRangeHigh - gRangeLow) / _Point;
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(StringFormat("DELAYED: range %.0f pt < min %.0f: niente trade.", rangePts, InpMinRangePts)); return(true); }
   if(InpMaxRangePts > 0 && rangePts > InpMaxRangePts)
     { ABTGLog(StringFormat("DELAYED: range %.0f pt > max %.0f: niente trade.", rangePts, InpMaxRangePts)); return(true); }
   if(!SpreadOK()) { ABTGLog("DELAYED: spread troppo alto: niente trade."); return(true); }
   if(!ConfirmOK()) { ABTGLog("DELAYED: rottura non confermata (ne' volumi ne' ATR): niente trade."); return(true); }

   UpdateVolRegime();   // R30: qui si decide, quindi qui si misura il regime

   //--- 1) la direzione CONFERMATA dopo l'attesa
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   if(bid <= 0 || ask <= 0) { ABTGLog("DELAYED: prezzi non disponibili: riprovo."); return(false); }

   int dir = 0;
   if(InpDelayDirMode == ABTG_DIR_BREAK)
     {
      if(bid > gRangeHigh)     dir = +1;
      else if(bid < gRangeLow) dir = -1;
      else
        {
         // BUG 05/08: qui si rispondeva "giornata chiusa" (return true) al primo controllo.
         // Con RangeMode=OPENING il momento della decisione coincide con la chiusura del range,
         // quindi il prezzo e' DENTRO il range PER COSTRUZIONE: DELAYED+BREAK non poteva mai
         // entrare (0 trade su 30 mesi nel walk-forward). Ora si continua ad aspettare la
         // rottura vera, entro una finestra di attesa limitata.
         MqlDateTime _d; TimeToStruct(TimeCurrent(), _d);
         int nowMin    = TimeInMinutes(_d);
         int openMin   = InpSessionHour*60 + InpSessionMin;
         int decideMin = openMin + InpDelayMinutes;
         if(InpRangeMode == ABTG_RANGE_OPENING && decideMin < openMin + InpRangeMinutes)
            decideMin = openMin + InpRangeMinutes;
         int limite = (InpPendingExpiryMin > 0) ? decideMin + InpPendingExpiryMin
                                                : InpCloseHour*60 + InpCloseMin;
         if(nowMin >= limite)
           { ABTGLog("DELAYED: nessuna rottura entro la finestra di attesa: niente trade."); return(true); }
         return(false);   // riprovo al tick successivo: aspetto la rottura
        }
     }
   else if(InpDelayDirMode == ABTG_DIR_MID)
     {
      double mid = (gRangeHigh + gRangeLow) / 2.0;
      dir = (bid >= mid) ? +1 : -1;
     }
   else // ABTG_DIR_CANDLE: seguo il corpo della candela di apertura
     {
      dir = OpeningBodyDir();
      if(dir == 0)
        { ABTGLog("DELAYED: candela di apertura senza corpo (doji) o dati non pronti: niente trade."); return(true); }
     }

   //--- 2) filtri di trend: se il bias contrasta la direzione, si sta fuori
   int bias = TrendBias();                 // 0 = nessun vincolo, 2 = conflitto (blocca tutto)
   if(bias != 0 && bias != dir)
     { ABTGLog(StringFormat("DELAYED: direzione %d bocciata dal filtro di trend (bias %d): niente trade.", dir, bias)); return(true); }
   if(dir > 0 && !InpAllowLong)  { ABTGLog("DELAYED: long non consentito: niente trade.");  return(true); }
   if(dir < 0 && !InpAllowShort) { ABTGLog("DELAYED: short non consentito: niente trade."); return(true); }

   //--- 3) stop sul bordo opposto del range (o ATR), col floor minimo
   double entry = (dir > 0) ? ask : bid;
   double sl    = (InpSLMode == ABTG_SL_RANGE)
                  ? ((dir > 0) ? gRangeLow : gRangeHigh)
                  : ((dir > 0) ? entry - AtrValue()*InpAtrSlMult : entry + AtrValue()*InpAtrSlMult);
   sl = NormalizePrice(VolRegimeSL(entry, sl));   // R30: scala lo stop col regime
   double dist = (dir > 0) ? (entry - sl) : (sl - entry);
   if(dist <= 0)
     { ABTGLog("DELAYED: stop dalla parte sbagliata (prezzo gia' oltre il bordo opposto): niente trade."); return(true); }
   if(SRBlocked(entry, dir)) return(true);        // R30: livello S/R addosso -> niente trade
   if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
     {
      if(InpSkipIfTight)
        { ABTGLog(StringFormat("DELAYED: stop %.0f pt < floor %.0f pt: trade saltato.", dist/_Point, InpMinStopPts)); return(true); }
      sl   = NormalizePrice((dir > 0) ? entry - InpMinStopPts*_Point : entry + InpMinStopPts*_Point);
      dist = (dir > 0) ? (entry - sl) : (sl - entry);
     }

   double lot = CalcLotByRisk(dist);
   if(lot <= 0) { ABTGLog("DELAYED: lotto calcolato a 0: niente trade."); return(true); }
   double tp = (InpTP1_R > 0) ? NormalizePrice((dir > 0) ? entry + dist*TpTotalR() : entry - dist*TpTotalR()) : 0.0;

   if(dir > 0)
     {
      if(gTrade.Buy(lot, _Symbol, 0.0, sl, tp, ABTG_DEF_NAME+" DELAY BUY"))
        { gBuyTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("BUY a mercato (ritardata) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
      else
         ABTGLog("BUY a mercato (ritardata) fallito: "+gTrade.ResultRetcodeDescription());
     }
   else
     {
      if(gTrade.Sell(lot, _Symbol, 0.0, sl, tp, ABTG_DEF_NAME+" DELAY SELL"))
        { gSellTicket = gTrade.ResultOrder(); ABTGLog(StringFormat("SELL a mercato (ritardata) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
      else
         ABTGLog("SELL a mercato (ritardata) fallito: "+gTrade.ResultRetcodeDescription());
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| OPENCONFIRM -- la regola come la descrive Emiliano nelle live.    |
//|                                                                  |
//|  "se mi apre sotto l'orb, quindi la candela a 15 minuti, mi apre  |
//|   la candela sotto E c'e' un incremento dei volumi, io li' lo     |
//|   shorto"                                                         |
//|                                                                  |
//|  Cioe': NON si insegue la rottura con un ordine pendente sul      |
//|  livello. Si aspetta che una candela APRA gia' oltre, e solo      |
//|  allora si entra a mercato -- e solo con i volumi a favore.       |
//|                                                                  |
//|  Perche' conta: il 04/08 in forward lo sweep d'apertura ha preso  |
//|  i due Live5m proprio perche' avevano pendenti appoggiati al      |
//|  livello (DAX stoppato in 61 s, Nasdaq in 20 s dopo aver venduto  |
//|  133 punti sopra il massimo notturno). Una candela che APRE oltre |
//|  non puo' essere prodotta da uno sweep: lo sweep e' intra-candela.|
//+------------------------------------------------------------------+
bool ArmOpenConfirm()
  {
   if(!ComputeLevels(gRangeHigh, gRangeLow))
     { ABTGLog("OPENCONFIRM: livelli non ancora calcolabili: riprovo."); return(false); }

   double rangePts = (gRangeHigh - gRangeLow) / _Point;
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(StringFormat("OPENCONFIRM: range %.0f pt < min %.0f: niente trade.", rangePts, InpMinRangePts)); return(true); }
   if(InpMaxRangePts > 0 && rangePts > InpMaxRangePts)
     { ABTGLog(StringFormat("OPENCONFIRM: range %.0f pt > max %.0f: niente trade.", rangePts, InpMaxRangePts)); return(true); }
   if(!SpreadOK()) { ABTGLog("OPENCONFIRM: spread troppo alto: nessun trade oggi."); return(true); }

   UpdateVolRegime();   // R30: il regime si misura all'ARMING, come gBuffer e gBias

   gBuffer    = EffectiveBuffer();
   gBias      = TrendBias();
   gLastOCBar = 0;
   ABTGLog(StringFormat("OPENCONFIRM armato: range %.5f-%.5f, buffer %.0f pt, bias %d. Attendo una candela che APRA oltre.",
                        gRangeHigh, gRangeLow, gBuffer/_Point, gBias));
   return(true);
  }

//+------------------------------------------------------------------+
//| OPENCONFIRM: a ogni candela nuova guarda la sua APERTURA.        |
//+------------------------------------------------------------------+
void MonitorOpenConfirm()
  {
   ENUM_TIMEFRAMES octf = (InpOCTimeframe == PERIOD_CURRENT) ? (ENUM_TIMEFRAMES)Period() : InpOCTimeframe;

   datetime bt = iTime(_Symbol, octf, 0);
   if(bt <= 0 || bt == gLastOCBar) return;    // una sola valutazione per candela
   gLastOCBar = bt;

   double op = iOpen(_Symbol, octf, 0);
   if(op <= 0) return;

   double buyTrig  = NormalizePrice(gRangeHigh + gBuffer);
   double sellTrig = NormalizePrice(gRangeLow  - gBuffer);
   bool   longOK   = (gBias == 0 || gBias == +1);
   bool   shortOK  = (gBias == 0 || gBias == -1);

   int dir = 0;
   if(InpAllowLong  && longOK  && op >= buyTrig)  dir = +1;
   if(InpAllowShort && shortOK && op <= sellTrig) dir = -1;
   if(dir == 0) return;

   if(!VolumeOKtf(octf))
     { ABTGLog("OPENCONFIRM: candela aperta oltre il livello ma volumi insufficienti: salto."); return; }

   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0) return;

   double entry = (dir > 0) ? ask : bid;
   double sl;
   if(InpSLMode == ABTG_SL_RANGE) sl = (dir > 0) ? sellTrig : buyTrig;
   else                           sl = (dir > 0) ? entry - AtrValue()*InpAtrSlMult
                                                 : entry + AtrValue()*InpAtrSlMult;
   sl = NormalizePrice(VolRegimeSL(entry, sl));   // R30: scala lo stop col regime

   double dist = (dir > 0) ? (entry - sl) : (sl - entry);
   if(dist <= 0) { ABTGLog("OPENCONFIRM: distanza di stop nulla, salto."); return; }
   //--- R30: filtro S/R. Si SALTA questa candela (come per i volumi): il
   //    prezzo si muove, alla candela dopo il livello puo' non essere piu' addosso.
   if(SRBlocked(entry, dir)) return;
   if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
     {
      if(InpSkipIfTight)
        { ABTGLog(StringFormat("OPENCONFIRM saltato: stop %.0f pt < floor %.0f pt.", dist/_Point, InpMinStopPts));
          gPhase = PH_DONE; return; }
      dist = InpMinStopPts*_Point;
      sl   = NormalizePrice((dir > 0) ? entry - dist : entry + dist);
     }

   double tp  = (InpTP1_R > 0) ? NormalizePrice((dir > 0) ? entry + dist*TpTotalR()
                                                          : entry - dist*TpTotalR()) : 0.0;
   double lot = CalcLotByRisk(dist);
   if(lot <= 0) { ABTGLog("OPENCONFIRM: lotto nullo, niente trade."); gPhase = PH_DONE; return; }

   bool ok = (dir > 0) ? gTrade.Buy (lot, _Symbol, 0.0, sl, tp, ABTG_DEF_NAME+" OPENCONF BUY")
                       : gTrade.Sell(lot, _Symbol, 0.0, sl, tp, ABTG_DEF_NAME+" OPENCONF SELL");
   if(ok)
     {
      gPhase = PH_PLACED;
      ABTGLog(StringFormat("OPENCONFIRM %s: candela aperta a %.5f oltre %.5f, volumi ok -> entrato a mercato.",
                           (dir > 0 ? "BUY" : "SELL"), op, (dir > 0 ? buyTrig : sellTrig)));
     }
  }

bool ArmRetest()
  {
   if(!ComputeLevels(gRangeHigh, gRangeLow))
     { ABTGLog("RETEST: livelli non ancora calcolabili (dati non pronti): riprovo."); return(false); }

   double rangePts = (gRangeHigh - gRangeLow) / _Point;
   if(InpMinRangePts > 0 && rangePts < InpMinRangePts)
     { ABTGLog(StringFormat("RETEST: candela %.0f pt < min %.0f: niente trade (whipsaw).", rangePts, InpMinRangePts)); return(true); }
   if(InpMaxRangePts > 0 && rangePts > InpMaxRangePts)
     { ABTGLog(StringFormat("RETEST: candela %.0f pt > max %.0f: niente trade (stop troppo largo).", rangePts, InpMaxRangePts)); return(true); }
   if(!SpreadOK()) { ABTGLog("RETEST: spread troppo alto: nessun ordine oggi."); return(true); }

   UpdateVolRegime();   // R30: il regime si misura all'ARMING, come gBuffer e gBias

   gBuffer    = EffectiveBuffer();
   gBias      = TrendBias();           // 0 entrambi, +1 solo long, -1 solo short, 2 conflitto
   gBrokeHigh = false;
   gBrokeLow  = false;
   ABTGLog(StringFormat("RETEST armato: range %.5f-%.5f, buffer %.0f pt, bias %d. Attendo rottura + ritorno sul livello.",
                        gRangeHigh, gRangeLow, gBuffer/_Point, gBias));
   return(true);
  }

//+------------------------------------------------------------------+
//| RETEST: sorveglia la rottura; appena rotto il range piazza il    |
//|  LIMIT sul livello (ritorno) -> fill a prezzo migliore, niente   |
//|  slippage. SL uguale al breakout (bordo opposto) -> stop piu'    |
//|  stretto -> R migliore. Se il prezzo scappa senza tornare, il    |
//|  limit scade non eseguito (trade mancato = costo del metodo).    |
//+------------------------------------------------------------------+
void MonitorRetest()
  {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0) return;

   double buyTrig  = NormalizePrice(gRangeHigh + gBuffer);   // livello di rottura sopra
   double sellTrig = NormalizePrice(gRangeLow  - gBuffer);   // livello di rottura sotto
   double buyPx    = buyTrig;                                // per l'SL a range (bordo opposto)
   double sellPx   = sellTrig;
   datetime expiry = TimeCurrent() + InpPendingExpiryMin*60;

   bool longOK  = (gBias == 0 || gBias == +1);
   bool shortOK = (gBias == 0 || gBias == -1);

   //--- LONG: rottura sopra avvenuta -> BUY LIMIT sul livello rotto (ritorno)
   if(InpAllowLong && longOK && !gBrokeHigh && ask >= buyTrig)
     {
      gBrokeHigh = true;
      if(!VolumeOK())
         ABTGLog("RETEST BUY: rottura con volumi insufficienti, salto (regola Emiliano).");
      else
        {
         double entry = NormalizePrice(gRangeHigh - InpRetestOffsetPts*_Point); // limit sul livello (niente buffer/slippage)
         double sl    = (InpSLMode == ABTG_SL_RANGE) ? sellPx : entry - AtrValue()*InpAtrSlMult;
         sl = NormalizePrice(VolRegimeSL(entry, sl));                           // R30: scala lo stop col regime
         double dist  = entry - sl;
         bool   skip  = false;
         if(SRBlocked(entry, +1)) skip = true;                                  // R30: filtro S/R
         if(!skip && InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
           {
            if(InpSkipIfTight) { skip=true; ABTGLog(StringFormat("RETEST BUY saltato: stop %.0f pt < floor %.0f pt.", dist/_Point, InpMinStopPts)); }
            else               { sl = NormalizePrice(entry - InpMinStopPts*_Point); dist = entry - sl; }
           }
         double lot = skip ? 0.0 : CalcLotByRisk(dist);
         double tp  = (InpTP1_R > 0) ? NormalizePrice(entry + dist*TpTotalR()) : 0.0;
         if(!skip && lot > 0 && dist > 0)
           {
            if(gTrade.BuyLimit(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" RETEST BUY"))
              { gBuyTicket = gTrade.ResultOrder(); gPhase = PH_PLACED;
                ABTGLog(StringFormat("BUY LIMIT (retest) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
            else
               ABTGLog("BUY LIMIT (retest) fallito: "+gTrade.ResultRetcodeDescription());
           }
        }
     }

   //--- SHORT: rottura sotto avvenuta -> SELL LIMIT sul livello rotto (ritorno)
   if(InpAllowShort && shortOK && !gBrokeLow && bid <= sellTrig)
     {
      gBrokeLow = true;
      if(!VolumeOK())
         ABTGLog("RETEST SELL: rottura con volumi insufficienti, salto (regola Emiliano).");
      else
        {
         double entry = NormalizePrice(gRangeLow + InpRetestOffsetPts*_Point);
         double sl    = (InpSLMode == ABTG_SL_RANGE) ? buyPx : entry + AtrValue()*InpAtrSlMult;
         sl = NormalizePrice(VolRegimeSL(entry, sl));                           // R30: scala lo stop col regime
         double dist  = sl - entry;
         bool   skip  = false;
         if(SRBlocked(entry, -1)) skip = true;                                  // R30: filtro S/R
         if(!skip && InpMinStopPts > 0 && dist < InpMinStopPts*_Point)
           {
            if(InpSkipIfTight) { skip=true; ABTGLog(StringFormat("RETEST SELL saltato: stop %.0f pt < floor %.0f pt.", dist/_Point, InpMinStopPts)); }
            else               { sl = NormalizePrice(entry + InpMinStopPts*_Point); dist = sl - entry; }
           }
         double lot = skip ? 0.0 : CalcLotByRisk(dist);
         double tp  = (InpTP1_R > 0) ? NormalizePrice(entry - dist*TpTotalR()) : 0.0;
         if(!skip && lot > 0 && dist > 0)
           {
            if(gTrade.SellLimit(lot, entry, _Symbol, sl, tp, ORDER_TIME_SPECIFIED, expiry, ABTG_DEF_NAME+" RETEST SELL"))
              { gSellTicket = gTrade.ResultOrder(); gPhase = PH_PLACED;
                ABTGLog(StringFormat("SELL LIMIT (retest) @ %.5f  SL %.5f  lot %.2f", entry, sl, lot)); }
            else
               ABTGLog("SELL LIMIT (retest) fallito: "+gTrade.ResultRetcodeDescription());
           }
        }
     }
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
   // BUG 06/08: quarto motore trovato a ignorare i filtri di conferma, dopo il
   // fade. Il 05/08 avevo corretto il fade senza controllare gli altri rami con
   // lo stesso schema: nella FASE B rifatta GAPFILL con volumi ON e OFF dava di
   // nuovo due righe identiche al centesimo.
   if(!ConfirmOK()) { ABTGLog("GAP FILL: conferma (volumi/ATR) assente: niente trade."); return(true); }

   UpdateVolRegime();   // R30: qui si decide, quindi qui si misura il regime

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
      double sl    = NormalizePrice(VolRegimeSL(entry, hi + buffer));   // R30: scala lo stop col regime
      double risk  = sl - entry;
      double reward= entry - tp;
      if(risk <= 0 || reward <= 0) { ABTGLog("gap fill up: geometria non valida."); return(true); }
      if(SRBlocked(entry, -1)) return(true);                            // R30: filtro S/R
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
      double sl    = NormalizePrice(VolRegimeSL(entry, lo - buffer));   // R30: scala lo stop col regime
      double risk  = entry - sl;
      double reward= tp - entry;
      if(risk <= 0 || reward <= 0) { ABTGLog("gap fill down: geometria non valida."); return(true); }
      if(SRBlocked(entry, +1)) return(true);                            // R30: filtro S/R
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
//| Bias VWAP di sessione (live Emiliano): +1 se prezzo sopra VWAP,  |
//|  -1 se sotto. VWAP ancorata all'inizio del giorno, su InpVwapTF. |
//+------------------------------------------------------------------+
int VwapBias()
  {
   MqlRates r[]; ArraySetAsSeries(r, true);
   int copied = CopyRates(_Symbol, InpVwapTF, 0, 300, r);
   if(copied < 2) return(0);
   MqlDateTime nowdt; TimeToStruct(TimeCurrent(), nowdt);
   double pv = 0, vv = 0;
   for(int i = 1; i < copied; i++)
     {
      MqlDateTime bt; TimeToStruct(r[i].time, bt);
      if(bt.day != nowdt.day || bt.mon != nowdt.mon || bt.year != nowdt.year) break; // solo la sessione odierna
      double tp = (r[i].high + r[i].low + r[i].close) / 3.0;
      double vol = (double)r[i].tick_volume;
      pv += tp * vol; vv += vol;
     }
   if(vv <= 0) return(0);
   double vwap = pv / vv;
   double px = r[1].close;
   if(px > vwap) return(+1);
   if(px < vwap) return(-1);
   return(0);
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

   //--- Piano Europeo: "Super Trend, quando cambiano TUTTI E TRE, posso entrare a mercato"
   if(InpUseSupertrend3)
     {
      int s25 = SupertrendDir(_Symbol, InpStTF, InpStAtrPeriod, 2.5);
      int s30 = SupertrendDir(_Symbol, InpStTF, InpStAtrPeriod, 3.0);
      int s35 = SupertrendDir(_Symbol, InpStTF, InpStAtrPeriod, 3.5);
      if(s25 != 0 && s25 == s30 && s30 == s35) bias = CombineBias(bias, s25);
      else                                     bias = 2;   // non concordi = nessun ordine
     }

   if(InpUseCorrelation && StringLen(InpCorrSymbol) > 0)
     {
      int c = SymbolTrendDir(InpCorrSymbol, InpCorrTF, InpCorrEmaFast, InpCorrEmaSlow);
      if(c != 0) bias = CombineBias(bias, c);
     }

   if(InpUseVwapFilter)
     {
      int v = VwapBias();
      if(v != 0) bias = CombineBias(bias, v);
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

//==================================================================
//  R30 - REGIME DI VOLATILITA' ADATTIVO (opt-in, default spento)
//
//  Perche': con buffer e stop FISSI in punti, la stessa impostazione e'
//  troppo larga nelle giornate morte e troppo stretta nelle giornate
//  isteriche. Qui l'ATR corrente viene messo in PERCENTILE rispetto alle
//  ultime InpVolLookback barre e si scalano buffer / stop / size.
//
//  ⚠️ NON e' un filtro: non blocca mai un trade. Se i dati mancano si
//     torna a regime NORMAL (moltiplicatori 1.0) e si logga: un dato
//     assente non deve cambiare le decisioni operative.
//  ⚠️ Il calcolo si fa UNA VOLTA PER BARRA, non a ogni tick: le funzioni
//     di ingresso possono essere richiamate a raffica mentre aspettano
//     che i dati siano pronti.
//==================================================================
void SetVolRegimeNormal()
  {
   gVolRegime   = 0;
   gVolOffMult  = 1.0;
   gVolSlMult   = 1.0;
   gVolSizeMult = 1.0;
  }

string VolRegimeName(int r)
  {
   if(r > 0) return("TEMPESTA");
   if(r < 0) return("CALMA");
   return("NORMALE");
  }

void UpdateVolRegime()
  {
   if(!InpUseVolRegime) return;                       // percorso di default: mai eseguito

   datetime bt = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(bt > 0 && bt == gVolBar) return;                // gia' calcolato su questa barra
   gVolBar = bt;

   int n = InpVolLookback;
   if(n < 10) n = 10;                                 // sotto le 10 letture il percentile e' rumore

   double a[];
   ArraySetAsSeries(a, true);
   if(gVolAtrH == INVALID_HANDLE || CopyBuffer(gVolAtrH, 0, 1, n, a) < n)
     {
      SetVolRegimeNormal();
      gVolPct = -1.0;
      ABTGLog("[VolRegime] dati ATR insufficienti: regime NORMALE (nessuna scala applicata).");
      return;
     }

   double cur = a[0];                                 // ATR dell'ultima barra CHIUSA
   if(cur <= 0)
     {
      SetVolRegimeNormal();
      gVolPct = -1.0;
      ABTGLog("[VolRegime] ATR corrente nullo: regime NORMALE.");
      return;
     }

   int sotto = 0;
   for(int i = 1; i < n; i++)
      if(a[i] < cur) sotto++;
   gVolPct = 100.0 * sotto / (n - 1);                 // rango percentile della lettura corrente

   if(gVolPct < InpVolLowPct)
     {
      gVolRegime   = -1;
      gVolOffMult  = InpVolLowOffMult;
      gVolSlMult   = InpVolLowSlMult;
      gVolSizeMult = 1.0;                             // in calma la size non si tocca
     }
   else if(gVolPct > InpVolHighPct)
     {
      gVolRegime   = +1;
      gVolOffMult  = InpVolHighOffMult;
      gVolSlMult   = InpVolHighSlMult;
      gVolSizeMult = InpVolHighSizeMult;
     }
   else
      SetVolRegimeNormal();

   ABTGLog(StringFormat("[VolRegime] percentile %.0f -> %s: buffer x%.2f, SL x%.2f, size x%.2f (ATR %.5f)",
                        gVolPct, VolRegimeName(gVolRegime), gVolOffMult, gVolSlMult, gVolSizeMult, cur));
  }

//+------------------------------------------------------------------+
//| R30 - riscala la DISTANZA di stop secondo il regime.             |
//|  Lavora sul segno (sl-entry): vale sia per i long sia per gli    |
//|  short senza doversi passare la direzione.                       |
//+------------------------------------------------------------------+
double VolRegimeSL(double entry, double sl)
  {
   if(!InpUseVolRegime || gVolSlMult == 1.0 || sl <= 0 || entry <= 0) return(sl);
   return(entry + (sl - entry) * gVolSlMult);
  }

//==================================================================
//  R30 - FILTRO PROSSIMITA' SUPPORTI / RESISTENZE (opt-in)
//
//  Ritorna TRUE se il livello d'ingresso ha un ostacolo davanti entro
//  InpSRProximityPts NELLA DIREZIONE del trade (per un buy: livello
//  SOPRA l'ingresso; per un sell: livello SOTTO). In quel caso il
//  segnale si salta: il trade parte gia' con poco spazio prima di
//  incontrare il livello che tutti guardano.
//
//  ⚠️ Blocca SOLO l'apertura. Non tocca mai parziale, breakeven,
//     trailing o chiusura di fine sessione.
//==================================================================
bool SRBlocked(double entryPx, int dir)
  {
   if(!InpUseSRFilter) return(false);                 // percorso di default: esce subito
   if(entryPx <= 0 || dir == 0) return(false);
   double thr = InpSRProximityPts * _Point;
   if(thr <= 0) return(false);

   double lv[8];
   string nm[8];
   int    n = 0;

   //--- massimo/minimo del GIORNO PRECEDENTE (PDH/PDL)
   if(InpSRUsePrevDay)
     {
      double pdh = iHigh(_Symbol, PERIOD_D1, 1);
      double pdl = iLow (_Symbol, PERIOD_D1, 1);
      if(pdh > 0) { lv[n] = pdh; nm[n] = "PDH"; n++; }
      if(pdl > 0) { lv[n] = pdl; nm[n] = "PDL"; n++; }
     }

   //--- numeri tondi immediatamente sopra e sotto l'ingresso
   if(InpSRUseRoundNumbers && InpSRRoundInterval > 0)
     {
      double step = InpSRRoundInterval * _Point;
      if(step > 0)
        {
         lv[n] = MathCeil (entryPx/step)*step; nm[n] = "numero tondo"; n++;
         lv[n] = MathFloor(entryPx/step)*step; nm[n] = "numero tondo"; n++;
        }
     }

   for(int i = 0; i < n; i++)
     {
      double d = (dir > 0) ? (lv[i] - entryPx) : (entryPx - lv[i]);   // solo davanti al trade
      if(d >= 0 && d <= thr)
        {
         ABTGLog(StringFormat("[SR] %s saltato: %s a %.0f pt (livello %.5f, soglia %.0f pt).",
                              (dir > 0 ? "buy" : "sell"), nm[i], d/_Point, lv[i], InpSRProximityPts));
         return(true);
        }
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Lotto in base al rischio % sullo stop                           |
//+------------------------------------------------------------------+
double CalcLotByRisk(double slDistancePrice)
  {
   if(slDistancePrice <= 0) return(0);
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot = 0;
   double pxCalc  = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double profCalc = 0;
   if(pxCalc > slDistancePrice &&
      OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, pxCalc, pxCalc - slDistancePrice, profCalc) && profCalc < 0)
      lossPerLot = -profCalc;
   if(lossPerLot <= 0)
     {
      double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickSize <= 0 || tickValue <= 0) return(0);
      lossPerLot = (slDistancePrice / tickSize) * tickValue;
     }
   if(lossPerLot <= 0) return(0);

   double lot = riskMoney / lossPerLot;

   //--- R30: in TEMPESTA si riduce la size (il rischio % nominale resta
   //    quello, ma il colpo preso su uno stop saltato e' piu' piccolo).
   //    Con la feature spenta questa riga non tocca niente.
   if(InpUseVolRegime && gVolSizeMult > 0 && gVolSizeMult != 1.0)
      lot *= gVolSizeMult;

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
//--- helper stato gestione per-ticket (Hedge-safe) ---
bool TkDone(ulong t, const ulong &arr[]) { for(int i=ArraySize(arr)-1;i>=0;i--) if(arr[i]==t) return(true); return(false); }
void TkMark(ulong t, ulong &arr[]) { if(TkDone(t,arr)) return; int n=ArraySize(arr); ArrayResize(arr,n+1); arr[n]=t; }

void ManagePosition()
  {
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   // Hedge-safe: gestisco OGNI mia posizione (simbolo+magic), una per una.
   // Prima si gestiva solo la PRIMA -> le altre restavano senza parziale/BE
   // e i profitti tornavano indietro fino allo stop pieno.
   for(int _i=PositionsTotal()-1; _i>=0; _i--)
     {
      ulong ticket = PositionGetTicket(_i);
      if(ticket==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      ManageOneTicket(ticket, bid, ask);
     }
  }

//+------------------------------------------------------------------+
//| Gestione di UNA posizione (gia' selezionata da PositionGetTicket)|
//|  parziale + breakeven + trailing, con stato PER-TICKET.          |
//+------------------------------------------------------------------+
void ManageOneTicket(ulong ticket, double bid, double ask)
  {
   long   type   = PositionGetInteger(POSITION_TYPE);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl     = PositionGetDouble(POSITION_SL);
   double tp     = PositionGetDouble(POSITION_TP);
   double vol    = PositionGetDouble(POSITION_VOLUME);

   bool partialDone = TkDone(ticket, gPartialTk);

   // distanza di rischio iniziale (per calcolare 1R)
   double riskDist = (type == POSITION_TYPE_BUY) ? (openP - InitialSL(openP, sl, type, partialDone)) : (InitialSL(openP, sl, type, partialDone) - openP);
   if(riskDist <= 0) riskDist = AtrValue()*InpAtrSlMult;

   //--- 1) PARZIALE al primo obiettivo
   if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)
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
               TkMark(ticket, gPartialTk);
               ABTGLog(StringFormat("1o obiettivo @ %.5f: chiusa parziale %.2f lotti (ticket %I64u).", target, closeVol, ticket));
              }
           }

         //--- 2) BREAKEVEN al primo obiettivo -- FUORI dal ramo della parziale.
         //  07/08/2026: stava DENTRO "se la parziale e' riuscita". Al lotto minimo il
         //  50% arrotonda sotto il minimo del broker, NormalizeVolume torna 0, la
         //  parziale non parte -- e cosi' il breakeven non veniva NEMMENO PROVATO:
         //  la posizione restava a rischio pieno anche dopo il primo obiettivo.
         //  (riskDist non cambia: con lo stop a pari InitialSL da' 0 e scatta lo
         //   stesso ripiego sull'ATR che c'era gia' dopo la parziale.)
         if(InpBreakevenAtTP1 && !TkDone(ticket, gBETk))
           {
            double be = NormalizePrice(openP);
            if((type==POSITION_TYPE_BUY  && (be>sl || sl==0)) ||          // mai arretrare lo stop
               (type==POSITION_TYPE_SELL && (be<sl || sl==0)))
               gTrade.PositionModify(ticket, be, tp);
            TkMark(ticket, gBETk);
            if(closeVol <= 0)
               ABTGLog(StringFormat("1o obiettivo @ %.5f: parziale impossibile al lotto %.2f (minimo del broker), stop a pari lo stesso (ticket %I64u).", target, vol, ticket));
           }
        }
     }

   //--- 2b) BREAK-EVEN INDIPENDENTE (a InpBEatR, senza chiudere nulla)
   if(InpBEatR > 0 && !TkDone(ticket, gBETk))
     {
      int dirSignBE = (type == POSITION_TYPE_BUY) ? +1 : -1;
      double beTarget = openP + dirSignBE*riskDist*InpBEatR;
      bool beHit = (type == POSITION_TYPE_BUY) ? (bid >= beTarget) : (ask <= beTarget);
      if(beHit)
        {
         double be = NormalizePrice(openP);
         // sposta a BE solo se migliora lo stop (mai arretrare)
         if((type==POSITION_TYPE_BUY  && (be>sl || sl==0)) ||
            (type==POSITION_TYPE_SELL && (be<sl || sl==0)))
            gTrade.PositionModify(ticket, be, tp);
         TkMark(ticket, gBETk);
         ABTGLog(StringFormat("BE indipendente @ %.5f R=%.2f: stop a pari (ticket %I64u).", beTarget, InpBEatR, ticket));
        }
     }

   //--- 3) TRAILING STOP (protegge i profitti)
   //  07/08/2026 -- SOGLIA MINIMA PRIMA DI ARMARE IL TRAILING.
   //  Prima non c'era: l'unica condizione era che la candela precedente fosse
   //  gia' oltre il prezzo d'ingresso. Su M5, dentro un movimento veloce, quel
   //  livello puo' stare due punti indice sopra l'entrata -- e la posizione e'
   //  finita. Il 07/08 tre trade d'apertura sono usciti dal trailing a
   //  +0,043R (17 secondi), +0,077R (32 min) e +0,027R (79 secondi): tre
   //  "vincenti" che insieme valevano 0,15R. Dimostrato dai prezzi: per un BUY
   //  lo stop iniziale sta SEMPRE sotto l'entrata e il breakeven lo mette
   //  ESATTAMENTE all'entrata; quelle uscite erano OLTRE, quindi trailing.
   //
   //  ⚠️ DEFAULT 0 = COMPORTAMENTO IDENTICO A PRIMA. Non cambia niente in
   //  forward. Adesso e' una LEVA MISURABILE, non una correzione applicata a
   //  occhio: il 05/08 il trailing e' stato cambiato in forward su una misura
   //  in campione e fuori campione era il PEGGIORE dei cinque.
   double profR = (riskDist > 0)
                  ? (((type == POSITION_TYPE_BUY) ? (bid - openP) : (openP - ask)) / riskDist)
                  : 0;
   bool trailArmato = (InpTrailStartR <= 0) || (profR >= InpTrailStartR);
   if(InpUseTrailing && trailArmato)
     {
      if(type == POSITION_TYPE_BUY)
        {
         double newSL = TrailStopBuy(bid);
         if(newSL > 0 && newSL > sl && newSL > openP)
            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
        }
      else if(type == POSITION_TYPE_SELL)
        {
         double newSL = TrailStopSell(ask);
         if(newSL > 0 && (newSL < sl || sl == 0) && newSL < openP)
            gTrade.PositionModify(ticket, NormalizePrice(newSL), tp);
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
double InitialSL(double openP, double curSL, long type, bool partialDone)
  {
   if(partialDone || curSL == 0)
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
   double bufPts   = InpBufferPoints;
   //--- R30: il buffer si stringe in calma e si allarga in tempesta.
   //    Il pavimento dello "stops level" del broker resta comunque sotto:
   //    non si scende mai a un livello che il broker rifiuterebbe.
   if(InpUseVolRegime && gVolOffMult > 0 && gVolOffMult != 1.0)
      bufPts *= gVolOffMult;
   bufPts = MathMax(bufPts, stopsLvl);
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
   // Hedge-safe: scorro TUTTE le posizioni e seleziono la MIA (simbolo+magic).
   // PositionSelect(_Symbol) prendeva la prima posizione qualsiasi sul simbolo:
   // con piu' EA sullo stesso strumento la gestione saltava. Ora per ticket.
   for(int _i=PositionsTotal()-1;_i>=0;_i--)
     {
      ulong _tk=PositionGetTicket(_i);
      if(_tk>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         return(true); // PositionGetTicket ha gia' selezionato la posizione
     }
   return(false);
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
//| Volumi in crescita alla rottura? (Emiliano: >= mult * media)     |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CONFERMA DELLA ROTTURA (PDF, strategia breakout notturno):       |
//|   "Entra solo se la rottura e' supportata da aumento di volumi   |
//|    O da una volatilita' coerente (ATR > media)."                 |
//|  E' un OR, non un AND: basta UNA delle due conferme. Applicarle  |
//|  a cascata (prima i volumi, poi l'ATR) le rende un AND e         |
//|  moltiplica via il campione -- errore del primo giro del 02/08,  |
//|  che aveva ridotto il Nasdaq a 72 trade in 2,5 anni.             |
//|  InpConfirmMode permette comunque di provare l'AND.              |
//+------------------------------------------------------------------+
bool ConfirmOK()
  {
   if(!InpUseVolumeFilter && !InpUseAtrFilter) return(true);   // nessuna conferma richiesta
   if(InpUseVolumeFilter && !InpUseAtrFilter)  return(VolumeOK());
   if(!InpUseVolumeFilter && InpUseAtrFilter)  return(AtrOK());
   bool v = VolumeOK();
   bool a = AtrOK();
   return((InpConfirmMode == ABTG_CONF_AND) ? (v && a) : (v || a));
  }

//+------------------------------------------------------------------+
//| Volatilita' coerente? (PDF: "ATR > media")                       |
//|  Il piano ammette il breakout se e' sostenuto DA VOLUMI **O** da |
//|  una volatilita' coerente. Qui confronto l'ATR dell'ultima barra |
//|  chiusa con la sua media sulle ultime N barre: serve a NON       |
//|  operare le aperture fiacche (dove il breakout e' rumore).       |
//+------------------------------------------------------------------+
bool AtrOK()
  {
   if(!InpUseAtrFilter) return(true);
   int n = InpAtrFilterBars;
   if(n < 2) return(true);
   double a[];
   ArraySetAsSeries(a, true);
   if(CopyBuffer(gAtrH, 0, 1, n, a) < n) return(true);   // dati insuff.: non blocco
   double sum = 0;
   for(int i = 0; i < n; i++) sum += a[i];
   double avg = sum / n;
   if(avg <= 0) return(true);
   return(a[0] >= InpAtrFilterMult * avg);               // ATR dell'ultima barra vs la sua media
  }

bool VolumeOKtf(ENUM_TIMEFRAMES tf)
  {
   if(!InpUseVolumeFilter) return(true);
   int n = InpVolAvgBars;
   if(n < 2) return(true);
   long v[];
   ArraySetAsSeries(v, true);
   if(CopyTickVolume(_Symbol, tf, 1, n+1, v) < n+1) return(true); // dati insuff.: non blocco
   double sum = 0;
   for(int i = 1; i <= n; i++) sum += (double)v[i];                 // media delle n barre PRIMA della rottura
   double avg = sum / n;
   if(avg <= 0) return(true);
   return((double)v[0] >= InpVolMult * avg);                        // volume dell'ultima barra chiusa (rottura)
  }

// Il volume va letto sulla STESSA candela di cui si guarda l'apertura:
// se si valuta l'apertura su M15, non ha senso misurare il volume su M5.
bool VolumeOK(){ return(VolumeOKtf(PERIOD_CURRENT)); }
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

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE (09/08/2026) - serve al DD di PORTAFOGLIO.       |
//| A fine test scrive nella cartella COMUNE (Files comuni) un CSV    |
//| con una riga per ogni trade CHIUSO (ora di chiusura e netto):     |
//| con le serie di piu' EA si calcolano DD combinato e Monte Carlo   |
//| (backtest_pipeline/dd_portafoglio.py). Solo tester. In            |
//| ottimizzazione ogni pass sovrascrive il file del proprio magic:   |
//| usarlo su run singoli / magic-sweep, non sulle griglie larghe.    |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }
double OnTester()
  {
   ExportTrades();   // per-trade per il DD di portafoglio (ROTTA_PROP punto 4)
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- METRICHE DA PROP (06/08): il DD di equity dice se il conto sopravvive,
   //    la prop ti chiude sul LIMITE GIORNALIERO e sulla serie di perdite.
   stats[7] = gWorstDayPct;                          // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);  // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);     // Serie Perdente Peggiore (denaro)
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
