//+------------------------------------------------------------------+
//|                                            DAX_MASTER_PROP.mq5    |
//|              Consolidato prop-firm (FTMO low-DD) DAX D30EUR/DE40  |
//|                                       Progetto privato - 2026     |
//+------------------------------------------------------------------+
//|                                                                  |
//|  STATUS: DAX_MASTER_PROP - consolidamento da DAXMasterEA v2.0     |
//|          + protezioni FTMO low-drawdown (5 nuove protezioni).     |
//|                                                                  |
//|  ========================= ORIGINE =========================      |
//|  Questo EA NON e' una riscrittura: e' la base validata di         |
//|  DAXMasterEA v2.0 (catena di 24 EA DAX) con AGGIUNTE le           |
//|  protezioni mancanti per l'operativita' prop-firm FTMO.          |
//|                                                                  |
//|  COSA EREDITA DA v2.0 (logica di trading PRESERVATA INVARIATA):   |
//|   - State machine ORB mattutino M15 (2 candele), open 09:00       |
//|     server, EOD 21:00.                                            |
//|   - Segnale: corpo candela oltre ORB + close vs MA200 + buffer.   |
//|   - Filtri ATTIVI: ADX>=24, distanza MA200>=35, Daily Bias D1,    |
//|     4 anti-shock (gap 75, ATR D1 2.0x, shock M5 4.0x, candela     |
//|     esplosa 3.0x), news filter, day-of-week (Lun/Ven OFF).        |
//|   - Uscita: parziale 50% a +45, BE a +20 (offset +5), trailing    |
//|     ATR(D1)*0.30 clamp 10-50 attivo dopo BE.                      |
//|   - Sizing risk-based, cap lotti assoluto 3.0, SL min 15 / max    |
//|     100, broker stop level.                                       |
//|   - Journal CSV.                                                  |
//|   - Bugfix ATR (GetATRD1Ratio array-out-of-range, da v1.9).       |
//|   - Filtro Heiken Ashi (presente ma NON validato).                |
//|                                                                  |
//|  ====================== MODIFICHE PROP ======================     |
//|                                                                  |
//|  B) DISATTIVAZIONI (logica lasciata nel codice, default OFF):     |
//|   - InpHAFilterEnabled  = false  (Heiken Ashi NON validato)       |
//|   - InpTradeAfternoon   = false  (sessione pomeridiana OFF)       |
//|   - Stub Supertrend / VWAP_ATR / Market Profile / S/R / HTF /     |
//|     Correlation: tutti default OFF, NON possono passare           |
//|     silenziosamente come filtri attivi.                          |
//|                                                                  |
//|  C) 5 PROTEZIONI FTMO LOW-DD (cuore del consolidamento):          |
//|   1) DAILY LOSS SU EQUITY (non balance):                          |
//|      g_dayStartEquity catturata al primo tick del nuovo giorno;   |
//|      su OGNI tick se (g_dayStartEquity - Equity) >=               |
//|      InpMaxDailyLossPercent% * g_dayStartEquity -> chiude tutto e |
//|      blocca fino a fine giornata (STATE_EOD). Include il floating.|
//|      Il vecchio check su balance rimane come fallback.            |
//|   2) KILL-SWITCH DRAWDOWN TOTALE (overall FTMO):                  |
//|      g_initialBalance (auto da AccountBalance in OnInit, o        |
//|      InpInitialBalance se >0). Su ogni tick se Equity <=          |
//|      g_initialBalance*(1-InpMaxTotalDDPercent/100) -> chiude tutto|
//|      e DISABILITA l'EA permanentemente (g_killSwitch=true).       |
//|   3) STOP SU SL CONSECUTIVI (famiglia Emiliano):                  |
//|      InpMaxConsecutiveSL (default 3), scope DAILY/CROSSDAY.       |
//|      Contatore in OnTradeTransaction (profit<0 o DEAL_REASON_SL); |
//|      reset su trade vincente. DAILY: halt fino a fine giornata;   |
//|      CROSSDAY: halt finche' non arriva un trade vincente.         |
//|   4) FAIL-SAFE CONSERVATIVO sui filtri:                           |
//|      dati indicatori non pronti / handle invalido / CopyBuffer    |
//|      fallito -> NON opera (blocca il segnale). Unica eccezione:   |
//|      il news filter resta permissivo SOLO in Strategy Tester      |
//|      (MQL_TESTER); in LIVE se non legge il calendario NON opera.  |
//|   5) PERSISTENZA HANDLE INDICATORI:                               |
//|      iADX e iATR (D1 trailing, D1 spike, M5 spike, M5 candle)     |
//|      ora sono handle persistenti creati in OnInit e rilasciati    |
//|      in OnDeinit. Stessi parametri/buffer -> valori identici.     |
//|                                                                  |
//|  D) DEFAULT PROP-CONSERVATIVI:                                    |
//|   - InpRiskPerTradePercent = 0.5 (era 1.0)                        |
//|   - Max 2 trade/giorno (invariato)                               |
//|   - Soglie filtri ai valori v1.8.2/v2.0 (ADX 24, MA dist 35,     |
//|     gap 75, ATR spike 2.0, ATR M5 spike 4.0, max candle 3.0).    |
//|                                                                  |
//|  ====================== AVVERTENZA ==========================     |
//|  Le 5 nuove protezioni FTMO NON sono ancora validate su dati      |
//|  reali: vanno verificate via Strategy Tester su tick reali       |
//|  (every-tick / real-ticks) prima di qualsiasi uso in demo/live.  |
//|  Nessun risultato di backtest e' qui dichiarato come acquisito.   |
//|                                                                  |
//|  ============= MIGLIORIE ROBUSTEZZA v3.20 (post-backtest) ====    |
//|  Basate su un backtest IN-SAMPLE 2023-2024 girato con 0% tick     |
//|  reali (dati modellati, NON affidabili). Tutte le migliorie sono  |
//|  STRUTTURALI e TOGGLEABLE; il default preserva il comportamento    |
//|  attuale, TRANNE il bugfix del contatore SL (sicurezza). Ogni      |
//|  miglioria va VALIDATA su tick reali (Dukascopy) + out-of-sample   |
//|  prima di qualsiasi uso. Dettagli: docs/Analisi_Backtest_DAX_v1.md |
//|                                                                  |
//|  1) TP a R-MULTIPLO dello SL effettivo (anti payoff<1):           |
//|     InpUseRMultipleTP (def OFF). Il backtest mostra avg loss >    |
//|     avg win perche' il TP e' fisso in punti mentre lo SL e'       |
//|     tecnico/variabile -> R:R incoerente. Con R-mode il parziale   |
//|     (InpPartial_R_Multiple) e il TP finale (InpTP_R_Multiple)     |
//|     sono multipli della distanza SL reale -> R:R coerente.        |
//|  2) BE/TRAILING legati a R: InpUseRBasedActivation (def OFF).     |
//|     Attivazione di BE e trailing proporzionale al rischio reale   |
//|     (InpBreakEven_R, InpTrailingActivation_R) invece che a punti  |
//|     fissi. Protegge i profitti in proporzione, senza tagliare     |
//|     troppo presto sui trade ampi.                                 |
//|  3) BUGFIX CONTATORE SL CONSECUTIVI (sicurezza, InpSLCounterMode):|
//|     prima un parziale in profitto azzerava la streak anche se la  |
//|     posizione poi chiudeva in PERDITA NETTA -> il contatore       |
//|     sottostimava (es. 5 SL col limite 3). Ora il default          |
//|     (NET_LOSS_PER_POSITION) valuta la perdita netta dell'intera   |
//|     posizione solo a chiusura totale. Modalita' legacy e          |
//|     SL_REASON_ONLY restano selezionabili. NB: per streak che      |
//|     attraversano piu' giorni usare scope CROSSDAY.                |
//|  4) DIRECTION MODE: InpDirectionMode {BOTH(def)/LONG_ONLY/        |
//|     SHORT_ONLY} per A/B test dell'asimmetria L/S senza            |
//|     hardcodare short-only (eviterebbe overfit al regime).         |
//|                                                                  |
//|  ===================== CHANGELOG STORICO ====================     |
//|  v3.20: migliorie robustezza post-backtest (vedi sopra)          |
//|  v2.0 : clean rebuild da v1.9 (Heiken Ashi)                       |
//|  v1.9 : filtro Heiken Ashi + bugfix GetATRD1Ratio                 |
//|  v1.8.2: ottimizzazione genetica (ADX 24, MA dist 35)            |
//|  v1.8.1: calibrazione anti-shock (gap 75, ATR 2.0, M5 4.0, 3.0)   |
//|  v1.8 : 4 filtri anti-shock                                       |
//|  v1.7 : filtri qualita' ADX + distanza MA200                      |
//|  v1.4 : trailing dinamico ATR                                     |
//|  v1.2 : Daily Bias D1                                             |
//|  v1.1 : cap lotti + SL minimo + Lun/Ven OFF                       |
//|  v1.0 : journal CSV + default permissivi sui filtri opzionali     |
//|  v0.2-0.9: sizing, news, afternoon, HTF, breakout buffer          |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Private project"
#property link      ""
#property version   "3.20"
#property description "DAX_MASTER_PROP - consolidato FTMO low-DD + migliorie robustezza v3.20 (R-multiple TP, fix contatore SL, direction mode)"
#property strict

#include <Trade\Trade.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\SymbolInfo.mqh>
#include <Trade\AccountInfo.mqh>

//+------------------------------------------------------------------+
//| ENUMS                                                            |
//+------------------------------------------------------------------+
enum ETradingState
{
   STATE_IDLE,            // Fuori orari di trading
   STATE_PREOPEN,         // 15 min prima dell'apertura
   STATE_ORB_BUILDING,    // Prime N candele M15 post-open, costruzione range ORB
   STATE_WAIT_TRIGGER,    // ORB costruito, in attesa di segnale
   STATE_IN_TRADE,        // Posizione aperta, in gestione
   STATE_HEDGED,          // v2: hedge attivo (non raggiungibile in v0.1)
   STATE_EOD              // Fine giornata, niente piu' trade
};

enum ESignalDirection
{
   SIG_NONE,
   SIG_LONG,
   SIG_SHORT
};

enum ESessionType
{
   SESSION_NONE,
   SESSION_MORNING,       // DAX open 9:00 CET
   SESSION_AFTERNOON      // Sessione pomeridiana (dopo apertura USA)
};

// v1.2 - bias direzionale della giornata, calcolato in PREOPEN morning
enum EDailyBias
{
   BIAS_NONE,       // non ancora calcolato per oggi
   BIAS_BULL,       // candela D1 ieri rialzista -> accetta solo LONG
   BIAS_BEAR,       // candela D1 ieri ribassista -> accetta solo SHORT
   BIAS_NEUTRAL     // candela D1 ieri piccola -> accetta entrambe
};

// PROP - scope del circuit breaker su SL consecutivi
enum EConsecutiveSLScope
{
   SCOPE_DAILY,     // halt fino a fine giornata, reset domani
   SCOPE_CROSSDAY   // halt finche' non arriva un trade vincente (stile Emiliano)
};

// v3.20 - criterio per il contatore SL consecutivi (bugfix di sicurezza)
enum ESLCounterMode
{
   SL_MODE_NET_LOSS_PER_POSITION, // DEFAULT: conta la perdita NETTA per posizione (somma di tutti i deal di uscita). Un parziale positivo seguito da uno stop in perdita netta = 1 perdita (NON azzera la streak).
   SL_MODE_ANY_NEGATIVE_DEAL,     // legacy: ogni singolo deal di uscita con profit<0 incrementa, ogni deal>0 azzera (comportamento pre-3.20, sottostima la streak)
   SL_MODE_SL_REASON_ONLY         // conta solo i deal chiusi dal broker per Stop Loss (DEAL_REASON_SL)
};

// v3.20 - gate direzionale globale per A/B test dell'asimmetria Long/Short
enum EDirectionMode
{
   DIR_BOTH,        // DEFAULT: opera sia LONG sia SHORT (comportamento attuale)
   DIR_LONG_ONLY,   // solo LONG (per A/B test)
   DIR_SHORT_ONLY   // solo SHORT (per A/B test)
};

//+------------------------------------------------------------------+
//| INPUT PARAMETERS                                                 |
//+------------------------------------------------------------------+
input group "=== Money Management ==="
input double   InpRiskPerTradePercent = 0.5;     // PROP: Rischio per trade (% balance) - low-DD (era 1.0)
input double   InpMaxDailyLossPercent = 2.0;     // Max perdita giornaliera (% equity inizio giornata)
input int      InpMaxTradesPerDay     = 2;       // Max trade/giorno - Emiliano: 2
input bool     InpConservativeRisk    = false;   // Modalita' conservativa (dimezza il rischio)

input group "=== PROP - FTMO Equity Daily Stop (Protezione 1) ==="
input bool     InpUseEquityDailyStop  = true;    // PROP: daily loss su EQUITY (non balance), include floating
// Nota: la soglia % e' condivisa con InpMaxDailyLossPercent.

input group "=== PROP - FTMO Kill-Switch Drawdown Totale (Protezione 2) ==="
input double   InpInitialBalance      = 0;       // PROP: balance iniziale di riferimento (0 = auto da AccountBalance in OnInit)
input double   InpMaxTotalDDPercent   = 6.0;     // PROP: DD massimo totale % (margine sotto il 10% FTMO) -> kill-switch permanente

input group "=== PROP - Stop su SL consecutivi (Protezione 3) ==="
input int                  InpMaxConsecutiveSL    = 3;            // PROP: stop consecutivi prima dell'halt
input EConsecutiveSLScope  InpConsecutiveSLScope  = SCOPE_DAILY;  // PROP: DAILY (fino a fine giorno) / CROSSDAY (fino a vincita)
// v3.20 BUGFIX SICUREZZA: il default conta la perdita NETTA per POSIZIONE.
// Prima un parziale in profitto azzerava la streak anche se la posizione poi
// chiudeva in perdita netta -> il contatore sottostimava le streak (es. 5 SL col limite 3).
input ESLCounterMode       InpSLCounterMode       = SL_MODE_NET_LOSS_PER_POSITION; // v3.20: criterio contatore SL (default = perdita netta/posizione)

input group "=== Session Timing (server time) ==="
input int      InpMorningStartHour    = 9;       // Apertura DAX
input int      InpMorningStartMin     = 0;
input int      InpMorningEndHour      = 12;      // Fine sessione mattina
input bool     InpTradeAfternoon      = false;   // PROP: sessione pomeridiana OFF (NON validata)
input int      InpAfternoonStartHour  = 15;      // Inizio pomeriggio (pre-apertura USA)
input int      InpAfternoonStartMin   = 30;
input int      InpEODHour             = 21;      // End of day (chiusura forzata)
input int      InpEODMin              = 0;

input group "=== ORB Settings (Morning) ==="
input int      InpORBCandlesCount        = 2;            // Candele M15 ORB mattina - Emiliano: 2
input ENUM_TIMEFRAMES InpORBTimeframe    = PERIOD_M15;   // TF ORB mattina

input group "=== Trigger Selectivity (v0.9, default permissivi) ==="
input double   InpORBBreakoutBuffer      = 0;            // LONG: close >= ORB.H + buffer (price units). 0 = no buffer extra
input double   InpMinTriggerCandleRange  = 0;            // Range candela trigger min (high-low) price units. 0 = no filtro

input group "=== ORB Settings (Afternoon) ==="
input int      InpORBCandlesCountAfternoon = 1;          // Candele ORB pomeriggio - default 1 M30
input ENUM_TIMEFRAMES InpORBTimeframeAfternoon = PERIOD_M30; // TF ORB pomeriggio (Emiliano)
input double   InpAfternoonRiskMultiplier   = 0.5;       // Moltiplicatore rischio pom. (Emiliano: "size ridotte")

input group "=== MA 200 (baluardo principale Emiliano) ==="
input int      InpMA200Period         = 200;
input ENUM_TIMEFRAMES InpMA200TF      = PERIOD_M15;
input ENUM_MA_METHOD  InpMA200Method  = MODE_EMA;        // EMA di default

input group "=== Supertrend (STUB - direzione, default OFF) ==="
input bool     InpSupertrendEnabled   = false;          // PROP: stub non implementato, deve restare OFF
input int      InpSupertrendPeriod    = 10;
input double   InpSupertrendMult      = 3.0;
input ENUM_TIMEFRAMES InpSupertrendTF = PERIOD_M15;

input group "=== Volume Filter (reimplementazione RB_Volume) ==="
input bool     InpVolumeFilterEnabled = false;           // OFF di default
input int      InpVolumeMAPeriod      = 20;              // Da sorgente RB_Volume
input double   InpVolumeMultiplier    = 1.5;             // +50% sopra media = PASS

input group "=== News Filter ==="
input bool     InpNewsFilterEnabled   = true;
input int      InpNewsBufferMinutes   = 30;              // Mezz'ora prima/dopo news alto impatto
input ENUM_CALENDAR_EVENT_IMPORTANCE InpNewsMinImportance = CALENDAR_IMPORTANCE_HIGH; // Soglia minima
input bool     InpNewsCheckEUR        = true;            // Blocca per news EUR (DAX diretto)
input bool     InpNewsCheckUSD        = true;            // Blocca per news USD (via correlazione SPX)

input group "=== Day-of-week Filter ==="
input bool     InpTradeMonday         = false;           // OFF (Emiliano: lunedi debole)
input bool     InpTradeTuesday        = true;
input bool     InpTradeWednesday      = true;
input bool     InpTradeThursday       = true;
input bool     InpTradeFriday         = false;           // OFF (Emiliano: venerdi debole)

input group "=== Correlation Filter (S&P 500 vs DAX) - default OFF ==="
input bool     InpCorrelationEnabled  = false;           // OFF di default (edge zero in v0.8)
input string   InpSPXSymbol           = "SPXUSD";        // BCM Markets (case-sensitive)
input ENUM_TIMEFRAMES InpSPXTrendTF   = PERIOD_M15;      // TF direzione S&P
input int      InpSPXMAPeriod         = 50;              // MA per direzione S&P
input ENUM_MA_METHOD  InpSPXMAMethod  = MODE_EMA;

input group "=== HTF Trend Filter (macro direction) - default OFF ==="
input bool     InpHTFTrendEnabled     = false;           // OFF di default (edge zero in v0.8)
input ENUM_TIMEFRAMES InpHTFTrendTF   = PERIOD_H4;       // TF macro (H4 default)
input int      InpHTFMAPeriod         = 200;             // Emiliano: MA200 baluardo principale
input ENUM_MA_METHOD  InpHTFMAMethod  = MODE_EMA;

input group "=== S/R Proximity Filter (STUB - default OFF) ==="
input bool     InpSRFilterEnabled     = false;           // OFF di default - funzione e' stub non implementata
input int      InpSRMinDistance       = 15;              // Emiliano: S/R entro N price units -> no entry

input group "=== Position Management (valori in DAX price units) ==="
input double   InpSLBuffer      = 5;              // Buffer sotto/sopra cuspide candela segnale (price units)
input double   InpMinSLDistance = 15;             // SL minimo accettabile (price units). Sotto -> trade saltato
input double   InpMaxSLDistance = 100;            // Max SL distance accettabile (price units)
input double   InpMaxLotSize    = 3.0;            // Cap ASSOLUTO sui lot (indipendente dal rischio %)
input double   InpFirstTP       = 45;             // Parziale a +N (ottimizzazione validata)
input int      InpPartialPercent= 50;             // Parzializza 50% del volume
input double   InpBreakEven     = 20;             // Sposta SL a BE a +N price units
input double   InpBE_Offset     = 5;              // Offset BE (+N price units sicurezza)
input double   InpFinalTP       = 50;             // Target finale in price units

input group "=== v3.20 - TP a R-multiplo dello SL effettivo (anti payoff<1) ==="
// RAZIONALE: il TP fisso in punti vs SL tecnico variabile crea un R:R incoerente
// (backtest: avg loss > avg win). Con questa opzione il parziale e il TP finale
// diventano multipli della distanza SL EFFETTIVA del trade -> R:R coerente.
// DEFAULT OFF = comportamento attuale (TP fisso in punti) preservato per A/B test.
input bool     InpUseRMultipleTP    = false;      // v3.20: TP/parziale come R-multiplo dello SL reale (OFF = punti fissi attuali)
input double   InpPartial_R_Multiple = 0.9;       // v3.20: soglia parziale = R x distanza SL (se R-mode ON)
input double   InpTP_R_Multiple      = 1.8;       // v3.20: TP finale = R x distanza SL (se R-mode ON). >1 per payoff>=1

input group "=== v3.20 - BE/Trailing legati a R (toggleable) ==="
// RAZIONALE: attivazione di BE e trailing proporzionale al rischio reale, non a
// punti fissi. DEFAULT OFF = soglie in punti fisse attuali preservate.
input bool     InpUseRBasedActivation = false;    // v3.20: BE/trailing attivati a multipli di R dello SL reale (OFF = punti fissi)
input double   InpBreakEven_R          = 0.5;     // v3.20: BE attivato a R x distanza SL (se R-mode ON)
input double   InpTrailingActivation_R = 0.8;     // v3.20: trailing attivato a R x distanza SL (se R-mode ON)

input group "=== v3.20 - Direction Mode (A/B test asimmetria L/S) ==="
// RAZIONALE: il backtest mostra LONG debole / SHORT forte, ma forzare short-only
// sarebbe overfit al regime. Questo gate permette di testare le 3 varianti in A/B.
// DEFAULT BOTH = comportamento attuale (entrambe le direzioni).
input EDirectionMode InpDirectionMode = DIR_BOTH; // v3.20: BOTH (default) / LONG_ONLY / SHORT_ONLY

input group "=== Hedging Module (HOOKS - DISABLED) ==="
input bool     InpHedgingEnabled      = false;           // v1 = solo single-order
input double   InpHedgingMaxDist      = 100;             // <100pt tra i due ordini

input group "=== iCustom indicators (STUB) ==="
input bool     InpMarketProfileEnabled = false;          // PROP: Market Profile stub, default OFF
input string   InpMarketProfileName    = "MarketProfile - ITA"; // EarnForex version

input group "=== Trailing Stop Dynamic ATR (v1.4) ==="
input bool     InpTrailingEnabled         = true;            // Attiva trailing stop dinamico ATR-based
input double   InpTrailingATRMultiplier   = 0.30;            // Distanza trailing = ATR(D1) * coeff
input int      InpTrailingATRPeriod       = 14;              // Periodo ATR su daily timeframe
input double   InpTrailingMinDistance     = 10;              // Distanza minima trailing (price units)
input double   InpTrailingMaxDistance     = 50;              // Distanza massima trailing (price units)
input double   InpTrailingActivationProfit = 25;            // Profitto minimo (price units) prima del trailing

input group "=== Quality Filters (v1.7) ==="
input bool             InpADXFilterEnabled        = true;            // Filtro ADX (no laterale)
input ENUM_TIMEFRAMES  InpADXTimeframe            = PERIOD_M15;      // Timeframe ADX (coerente con ORB)
input int              InpADXPeriod               = 14;              // Periodo ADX standard
input double           InpADXMinValue             = 24;              // Soglia minima ADX (v1.8.2)
input bool             InpMinDistanceMA200Enabled = true;            // Filtro distanza minima MA200
input double           InpMinDistanceMA200        = 35;              // Distanza minima close-MA200 (v1.8.2)

input group "=== Anti-Shock Filters (v1.8) ==="
input bool             InpGapFilterEnabled              = true;       // Filtro gap apertura
input double           InpMaxGapPoints                  = 75.0;       // Gap massimo accettabile in punti (v1.8.1)
input bool             InpATRSpikeFilterEnabled         = true;       // Filtro ATR D1 anomalo
input double           InpATRSpikeMultiplier            = 2.0;        // ATR D1 corrente / media ATR (max) (v1.8.1)
input int              InpATRAvgPeriod                  = 50;         // Periodo media ATR D1 (giorni)
input bool             InpVolatilityShockFilterEnabled  = true;       // Filtro shock volatilita' M5
input double           InpATRM5SpikeMultiplier          = 4.0;        // ATR M5 / media ATR M5 (max) (v1.8.1)
input int              InpATRM5AvgPeriod                = 14;         // Periodo media ATR M5
input bool             InpCandleRangeFilterEnabled      = true;       // Filtro candela trigger esplosa
input double           InpMaxCandleATRMult              = 3.0;        // Range candela trigger / ATR M5 (max) (v1.8.1)

input group "=== Heiken Ashi Filter (v1.9 - NON validato, default OFF) ==="
input bool             InpHAFilterEnabled               = false;      // PROP: OFF di default (NON validato)
input ENUM_TIMEFRAMES  InpHATimeframe                   = PERIOD_M5;  // TF per calcolo HA
input bool             InpHAColorMatchRequired          = true;       // Richiede HA stesso colore del trigger
input int              InpHACheckPreviousCandles        = 0;          // N candele HA precedenti allineate (0 = solo corrente)
input bool             InpHARequireBody                 = false;      // Richiede corpo HA significativo

input group "=== Daily Bias Filter (v1.2) ==="
input bool     InpDailyBiasEnabled    = true;            // Filtra trade in base alla candela DAX D1 di ieri
input double   InpDailyBiasNeutralBodyPct = 0.30;        // Soglia % corpo D1 sotto cui NEUTRAL

input group "=== Journal CSV (v1.0) ==="
input bool     InpJournalEnabled      = true;            // Scrive un CSV con tutti i trade
input string   InpJournalPrefix       = "DAX_MASTER_PROP"; // Prefix nome file (sotto MQL5/Files)

input group "=== Debug / Logging ==="
input bool     InpLogToFile           = true;
input bool     InpVerboseMode         = false;

//+------------------------------------------------------------------+
//| GLOBAL STATE                                                     |
//+------------------------------------------------------------------+
CTrade        g_trade;
CPositionInfo g_position;
CSymbolInfo   g_symbol;

ETradingState g_state     = STATE_IDLE;
ESessionType  g_session   = SESSION_NONE;
datetime      g_dayStart  = 0;
int           g_tradesToday = 0;
double        g_dayStartBalance = 0;

// PROP - protezioni FTMO
double        g_dayStartEquity   = 0;       // equity di inizio giornata broker (Protezione 1)
double        g_initialBalance   = 0;       // balance iniziale di riferimento (Protezione 2)
bool          g_killSwitch       = false;   // kill-switch DD totale: una volta true, EA permanentemente disabilitato
int           g_consecutiveSL    = 0;       // contatore SL consecutivi (Protezione 3)
bool          g_crossdayHalt     = false;   // halt persistente cross-day (scope CROSSDAY)
bool          g_dailySLHalt      = false;   // halt giornaliero per SL consecutivi (scope DAILY)

// ORB values for the current session
double        g_orbHigh   = 0;
double        g_orbLow    = 0;
datetime      g_orbStart  = 0;
datetime      g_orbEnd    = 0;
bool          g_orbReady  = false;

// Signal candle tracker
datetime      g_lastSignalBar = 0;

// Indicator handles - native MT5
int           g_handleMA200          = INVALID_HANDLE;
int           g_handleMarketProfile  = INVALID_HANDLE;
// PROP - Protezione 5: handle persistenti (prima erano creati/rilasciati ad ogni tick)
int           g_handleADX            = INVALID_HANDLE;  // iADX(InpADXTimeframe, InpADXPeriod)
int           g_handleATRD1Spike     = INVALID_HANDLE;  // iATR(D1, 14)  - GetATRD1Ratio
int           g_handleATRM5Avg       = INVALID_HANDLE;  // iATR(M5, InpATRM5AvgPeriod) - GetATRM5Ratio + candela
int           g_handleATRD1Trail     = INVALID_HANDLE;  // iATR(D1, InpTrailingATRPeriod) - trailing

// Active position tracking (single-order v1)
ulong            g_activeTicket        = 0;
double           g_activeInitialVolume = 0;
double           g_activeEntryPrice    = 0;
bool             g_activePartialDone   = false;
bool             g_activeBEMoved       = false;
ESignalDirection g_activeDir           = SIG_NONE;

// v1.4 - Trailing tracking
double           g_activeMaxFavorable  = 0;
double           g_activeTrailingSL    = 0;

// v3.20 - distanza SL EFFETTIVA del trade corrente (price units), per TP/BE/trailing a R
double           g_activeSLDistance    = 0;
// v3.20 - id della posizione attiva (per accumulare la perdita netta della posizione)
long             g_activePositionId    = 0;

// Magic number
const long MAGIC_DAX_EA = 20260422;

// Runtime environment
bool g_isTester = false;  // true se in Strategy Tester - limita Calendar API

// Journal CSV (v1.0)
int  g_journalHandle = INVALID_HANDLE;

// Daily Bias (v1.2)
EDailyBias g_dailyBias        = BIAS_NONE;
datetime   g_dailyBiasDay     = 0;

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("[DAX_MASTER_PROP] Initializing on ", _Symbol);

   g_isTester = (bool)MQLInfoInteger(MQL_TESTER);
   if(g_isTester && InpNewsFilterEnabled)
      Print("[NEWS] Strategy Tester detected: news filter permissive (Calendar API "
            "unavailable in backtest, MT5 limitation, error 4014).");

   // Symbol info
   if(!g_symbol.Name(_Symbol))
   {
      Print("[ERROR] Cannot load symbol info for ", _Symbol);
      return INIT_FAILED;
   }

   // Trade object setup
   g_trade.SetExpertMagicNumber(MAGIC_DAX_EA);
   g_trade.SetTypeFillingBySymbol(_Symbol);
   g_trade.SetDeviationInPoints(10);

   // Verifica account mode se hedging attivo
   if(InpHedgingEnabled)
   {
      ENUM_ACCOUNT_MARGIN_MODE marginMode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
      if(marginMode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
      {
         Print("[ERROR] Hedging enabled but account is NETTING mode.");
         return INIT_FAILED;
      }
   }

   // Create indicator handles (PROP - Protezione 5: tutti persistenti)
   if(!CreateIndicatorHandles())
      return INIT_FAILED;

   // Initialize daily tracking
   g_dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   g_dayStartEquity  = AccountInfoDouble(ACCOUNT_EQUITY);   // PROP - Protezione 1
   g_tradesToday     = 0;
   g_dayStart        = TimeCurrent();

   // PROP - Protezione 2: balance iniziale di riferimento per il kill-switch DD totale
   if(InpInitialBalance > 0)
      g_initialBalance = InpInitialBalance;
   else
      g_initialBalance = AccountInfoDouble(ACCOUNT_BALANCE);  // auto-capture
   g_killSwitch = false;

   // PROP - Protezione 3: reset contatori SL consecutivi
   g_consecutiveSL = 0;
   g_crossdayHalt  = false;
   g_dailySLHalt   = false;

   // Apertura Journal CSV
   if(InpJournalEnabled)
   {
      if(!OpenJournal())
         Print("[JOURNAL][WARN] Could not open CSV file. Trades will not be logged to file.");
   }

   // Timer 5s per state transitions
   EventSetTimer(5);

   Print("[DAX_MASTER_PROP] Initialized. Magic=", MAGIC_DAX_EA);
   Print("  Risk/trade: ", InpRiskPerTradePercent, "%  (PROP low-DD)");
   Print("  Max daily loss: ", InpMaxDailyLossPercent, "% (driver: ",
         (InpUseEquityDailyStop ? "EQUITY" : "balance"), ")");
   Print("  Max total DD (kill-switch): ", InpMaxTotalDDPercent, "%  ref balance=", g_initialBalance);
   Print("  Max consecutive SL: ", InpMaxConsecutiveSL, " scope=",
         (InpConsecutiveSLScope == SCOPE_DAILY ? "DAILY" : "CROSSDAY"));
   Print("  Max trades/day: ", InpMaxTradesPerDay);
   Print("  Afternoon session: ", (InpTradeAfternoon ? "ON" : "OFF"),
         " | Heiken Ashi: ", (InpHAFilterEnabled ? "ON" : "OFF"));
   Print("  Hedging: ", InpHedgingEnabled ? "ENABLED" : "disabled (v1 single-order)");
   // v3.20 - migliorie robustezza
   Print("  [v3.20] SL counter mode: ", EnumToString(InpSLCounterMode));
   Print("  [v3.20] Direction mode: ", EnumToString(InpDirectionMode));
   Print("  [v3.20] R-multiple TP: ", (InpUseRMultipleTP ? "ON" : "OFF"),
         (InpUseRMultipleTP ? StringFormat(" (partial %.2fR / final %.2fR)",
                                           InpPartial_R_Multiple, InpTP_R_Multiple) : ""));
   Print("  [v3.20] R-based BE/trailing: ", (InpUseRBasedActivation ? "ON" : "OFF"),
         (InpUseRBasedActivation ? StringFormat(" (BE %.2fR / trail %.2fR)",
                                                InpBreakEven_R, InpTrailingActivation_R) : ""));

   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();

   if(g_handleMA200 != INVALID_HANDLE)          IndicatorRelease(g_handleMA200);
   if(g_handleMarketProfile != INVALID_HANDLE)  IndicatorRelease(g_handleMarketProfile);
   // PROP - Protezione 5: rilascio handle persistenti
   if(g_handleADX != INVALID_HANDLE)            IndicatorRelease(g_handleADX);
   if(g_handleATRD1Spike != INVALID_HANDLE)     IndicatorRelease(g_handleATRD1Spike);
   if(g_handleATRM5Avg != INVALID_HANDLE)       IndicatorRelease(g_handleATRM5Avg);
   if(g_handleATRD1Trail != INVALID_HANDLE)     IndicatorRelease(g_handleATRD1Trail);

   CloseJournal();

   Print("[DAX_MASTER_PROP] Deinitialized. Reason=", reason);
}

//+------------------------------------------------------------------+
//| OnTick - main dispatcher                                         |
//+------------------------------------------------------------------+
void OnTick()
{
   // PROP - Protezione 2: kill-switch DD totale ha priorita' assoluta.
   // Una volta scattato, l'EA e' permanentemente disabilitato per questa sessione.
   if(g_killSwitch)
      return;

   if(CheckTotalDrawdownKillSwitch())
      return;  // ha gia' chiuso tutto e settato g_killSwitch

   // Daily reset check (resetta anche g_dayStartEquity)
   CheckDailyReset();

   // PROP - Protezione 1: daily loss su EQUITY (include floating). Su OGNI tick.
   if(CheckEquityDailyStop())
   {
      // CheckEquityDailyStop ha gia' chiuso tutto e forzato STATE_EOD
      return;
   }

   // Safety: limiti giornalieri (fallback su balance + max trade) -> EOD
   if(!DailyLimitsOK())
   {
      if(g_state != STATE_EOD)
      {
         Print("[DAILY LIMIT] Triggered - shutting down for the day");
         g_state = STATE_EOD;
      }
      return;
   }

   // PROP - Protezione 3: halt per SL consecutivi
   if(IsConsecutiveSLHalt())
   {
      if(g_state != STATE_EOD && CountMyPositions() == 0)
         g_state = STATE_EOD;
      // se restano posizioni, lasciamo che si chiudano naturalmente (no force-close qui)
      if(CountMyPositions() == 0)
         return;
   }

   // State machine dispatch
   switch(g_state)
   {
      case STATE_IDLE:          HandleIdle();          break;
      case STATE_PREOPEN:       HandlePreOpen();       break;
      case STATE_ORB_BUILDING:  HandleORBBuilding();   break;
      case STATE_WAIT_TRIGGER:  HandleWaitTrigger();   break;
      case STATE_IN_TRADE:      HandleInTrade();       break;
      case STATE_HEDGED:        HandleHedged();        break;   // v2 only
      case STATE_EOD:           HandleEOD();           break;
   }
}

//+------------------------------------------------------------------+
//| OnTimer - transizioni temporali                                  |
//+------------------------------------------------------------------+
void OnTimer()
{
   if(g_killSwitch) return;
   UpdateStateByTime();
}

//+------------------------------------------------------------------+
//| OnTradeTransaction - reset tracking + contatore SL consecutivi   |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;
   if(trans.deal <= 0) return;
   if(!HistoryDealSelect(trans.deal)) return;

   long dealMagic = HistoryDealGetInteger(trans.deal, DEAL_MAGIC);
   if(dealMagic != MAGIC_DAX_EA) return;

   long dealEntry = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);

   // DEAL_ENTRY_OUT = chiusura totale o parziale
   if(dealEntry == DEAL_ENTRY_OUT || dealEntry == DEAL_ENTRY_INOUT)
   {
      // Journal CSV: riga di chiusura per ogni deal di uscita
      JournalWriteClose(trans.deal);

      // PROP - Protezione 3: aggiorna contatore SL consecutivi sul deal di uscita
      UpdateConsecutiveSLCounter(trans.deal);

      // Se non rimangono posizioni nostre -> reset tracking
      if(CountMyPositions() == 0)
      {
         Print("[CLOSE] Position fully closed. Resetting tracking.");
         ResetActivePositionTracking();
      }
   }
}

//+------------------------------------------------------------------+
//| PROP - Protezione 3: aggiorna contatore SL consecutivi           |
//| v3.20 BUGFIX SICUREZZA: tre modalita' (InpSLCounterMode).         |
//|                                                                  |
//| SL_MODE_NET_LOSS_PER_POSITION (default): valuta la PERDITA NETTA  |
//|   dell'INTERA posizione (somma di TUTTI i deal di uscita) solo    |
//|   quando la posizione e' completamente chiusa. Cosi' un parziale  |
//|   in profitto seguito da uno stop in perdita netta conta come 1   |
//|   perdita e NON azzera la streak (bug pre-3.20).                  |
//| SL_MODE_ANY_NEGATIVE_DEAL: comportamento legacy pre-3.20 (ogni    |
//|   deal di uscita con profit<0 incrementa, ogni >0 azzera).        |
//| SL_MODE_SL_REASON_ONLY: conta solo i deal con DEAL_REASON_SL.     |
//+------------------------------------------------------------------+
void UpdateConsecutiveSLCounter(ulong dealTicket)
{
   double dealProfit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                     + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                     + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
   long dealReason = HistoryDealGetInteger(dealTicket, DEAL_REASON);

   bool isLoss;
   bool isWin;
   double evalProfit = dealProfit;   // valore mostrato nei log

   if(InpSLCounterMode == SL_MODE_NET_LOSS_PER_POSITION)
   {
      // BUGFIX: decidi SOLO quando la posizione e' interamente chiusa,
      // sulla perdita NETTA aggregata di tutti i suoi deal di uscita.
      long posId = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
      if(PositionStillOpenById(posId))
         return;   // parziale: aspetta la chiusura totale per decidere

      double netProfit = GetPositionNetProfit(posId);
      evalProfit = netProfit;
      isLoss = (netProfit < 0);
      isWin  = (netProfit > 0);
   }
   else if(InpSLCounterMode == SL_MODE_SL_REASON_ONLY)
   {
      isLoss = (dealReason == DEAL_REASON_SL);
      // un'uscita NON-SL in profitto azzera; un'uscita NON-SL in perdita e' neutra
      isWin  = (dealReason != DEAL_REASON_SL && dealProfit > 0);
   }
   else // SL_MODE_ANY_NEGATIVE_DEAL (legacy pre-3.20)
   {
      isLoss = (dealProfit < 0) || (dealReason == DEAL_REASON_SL);
      isWin  = (dealProfit > 0) && (dealReason != DEAL_REASON_SL);
   }

   if(isLoss)
   {
      g_consecutiveSL++;
      Print("[PROP][SL-STREAK] Trade chiuso in perdita. Consecutivi: ",
            g_consecutiveSL, "/", InpMaxConsecutiveSL,
            " (netProfit=", DoubleToString(evalProfit, 2),
            ", mode=", EnumToString(InpSLCounterMode), ")");

      if(g_consecutiveSL >= InpMaxConsecutiveSL)
      {
         if(InpConsecutiveSLScope == SCOPE_DAILY)
         {
            g_dailySLHalt = true;
            Print("[PROP][SL-STREAK][HALT] Raggiunti ", InpMaxConsecutiveSL,
                  " SL consecutivi. Halt DAILY: stop fino a fine giornata.");
         }
         else // SCOPE_CROSSDAY
         {
            g_crossdayHalt = true;
            Print("[PROP][SL-STREAK][HALT] Raggiunti ", InpMaxConsecutiveSL,
                  " SL consecutivi. Halt CROSSDAY: stop finche' non arriva un trade vincente.");
         }
      }
   }
   else if(isWin)
   {
      if(g_consecutiveSL > 0)
         Print("[PROP][SL-STREAK] Trade vincente: azzero contatore (era ", g_consecutiveSL, ")");
      g_consecutiveSL = 0;
      // un trade vincente riapre l'operativita' cross-day
      g_crossdayHalt = false;
   }
   // breakeven esatto (netProfit==0): neutro, non tocca la streak
}

//+------------------------------------------------------------------+
//| v3.20 - true se la posizione (per id) e' ancora aperta           |
//| (cioe' restano deal/volume da chiudere -> il deal corrente e' un |
//| parziale, non la chiusura totale).                               |
//+------------------------------------------------------------------+
bool PositionStillOpenById(long posId)
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(!g_position.SelectByIndex(i)) continue;
      if(g_position.Magic() != MAGIC_DAX_EA) continue;
      if((long)g_position.Identifier() == posId) return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| v3.20 - somma il profit NETTO di TUTTI i deal di uscita di una    |
//| posizione (per id). Usato dal contatore SL in modalita' NET.     |
//+------------------------------------------------------------------+
double GetPositionNetProfit(long posId)
{
   if(!HistorySelectByPosition(posId))
      return 0;

   double net = 0;
   int total = HistoryDealsTotal();
   for(int i = 0; i < total; i++)
   {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      long entry = HistoryDealGetInteger(d, DEAL_ENTRY);
      if(entry == DEAL_ENTRY_IN) continue;   // solo i deal di uscita
      net += HistoryDealGetDouble(d, DEAL_PROFIT)
           + HistoryDealGetDouble(d, DEAL_SWAP)
           + HistoryDealGetDouble(d, DEAL_COMMISSION);
   }
   return net;
}

//+------------------------------------------------------------------+
//| PROP - Protezione 3: l'EA e' in halt per SL consecutivi?         |
//+------------------------------------------------------------------+
bool IsConsecutiveSLHalt()
{
   if(InpMaxConsecutiveSL <= 0) return false;
   if(InpConsecutiveSLScope == SCOPE_DAILY)
      return g_dailySLHalt;
   else
      return g_crossdayHalt;
}

//+------------------------------------------------------------------+
//| PROP - Protezione 1: daily loss su EQUITY                        |
//| Su OGNI tick: se (g_dayStartEquity - Equity) >=                  |
//| soglia% * g_dayStartEquity -> chiude tutto e forza STATE_EOD.    |
//| Include il floating delle posizioni aperte.                      |
//| Ritorna true se ha bloccato l'operativita'.                      |
//+------------------------------------------------------------------+
bool CheckEquityDailyStop()
{
   if(!InpUseEquityDailyStop) return false;
   if(g_dayStartEquity <= 0)  return false;

   double equity   = AccountInfoDouble(ACCOUNT_EQUITY);
   double loss     = g_dayStartEquity - equity;
   double threshold = InpMaxDailyLossPercent / 100.0 * g_dayStartEquity;

   if(loss >= threshold)
   {
      if(g_state != STATE_EOD || CountMyPositions() > 0)
      {
         Print("[PROP][EQUITY-DAILY-STOP] Equity loss ", DoubleToString(loss, 2),
               " >= soglia ", DoubleToString(threshold, 2),
               " (", DoubleToString(InpMaxDailyLossPercent, 2), "% di ",
               DoubleToString(g_dayStartEquity, 2),
               "). Chiusura totale + halt giornaliero.");
         CloseAllMyPositions("EQUITY_DAILY_STOP");
      }
      g_state = STATE_EOD;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| PROP - Protezione 2: kill-switch DD totale (overall FTMO)        |
//| Se Equity <= g_initialBalance*(1-InpMaxTotalDDPercent/100) ->    |
//| chiude tutto e disabilita l'EA in modo permanente.               |
//| Ritorna true se il kill-switch e' scattato.                      |
//+------------------------------------------------------------------+
bool CheckTotalDrawdownKillSwitch()
{
   if(g_initialBalance <= 0)    return false;
   if(InpMaxTotalDDPercent <= 0) return false;

   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double floor  = g_initialBalance * (1.0 - InpMaxTotalDDPercent / 100.0);

   if(equity <= floor)
   {
      Print("[PROP][KILL-SWITCH] !!! DRAWDOWN TOTALE !!! Equity ",
            DoubleToString(equity, 2), " <= soglia ", DoubleToString(floor, 2),
            " (", DoubleToString(InpMaxTotalDDPercent, 2), "% sotto balance iniziale ",
            DoubleToString(g_initialBalance, 2), "). Chiusura totale e EA DISABILITATO ",
            "in modo permanente (richiede riavvio/ottimizzazione manuale per il reset).");
      CloseAllMyPositions("KILL_SWITCH_TOTAL_DD");
      g_killSwitch = true;
      g_state = STATE_EOD;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| STATE HANDLERS                                                   |
//+------------------------------------------------------------------+
void HandleIdle()
{
   // Nothing - in attesa che UpdateStateByTime() cambi stato
}

void HandlePreOpen()
{
   LogTodaysNewsBriefing();

   if(g_session == SESSION_MORNING)
      EvaluateDailyBias();
}

void HandleORBBuilding()
{
   BuildORBRange();

   if(IsORBComplete())
   {
      g_orbReady = true;
      ResetSignalCandleTracker();
      g_state = STATE_WAIT_TRIGGER;
      Print("[ORB] ", (g_session == SESSION_MORNING) ? "Morning" : "Afternoon",
            " complete. High=", DoubleToString(g_orbHigh, g_symbol.Digits()),
            " Low=",  DoubleToString(g_orbLow,  g_symbol.Digits()));
   }
}

void HandleWaitTrigger()
{
   // PROP - Protezione 3: se in halt SL consecutivi, non valutare nuovi trigger
   if(IsConsecutiveSLHalt()) return;

   // Agisci solo su chiusura di nuova candela
   if(!IsNewSignalCandle()) return;

   // Pre-filter non direzionali (day, news, S/R)
   if(!AllFiltersPass()) return;

   ESignalDirection sig = GenerateSignal();
   if(sig == SIG_NONE) return;

   // v3.20: gate direzionale globale (A/B test asimmetria L/S)
   if(!DirectionModePass(sig))
   {
      if(InpVerboseMode)
         Print("[SIGNAL][BLOCKED] ", EnumToString(sig),
               " filtrato da InpDirectionMode=", EnumToString(InpDirectionMode));
      return;
   }

   // v1.2: Daily Bias filter
   if(!DailyBiasFilterPass(sig))
   {
      Print("[SIGNAL][BLOCKED] ", EnumToString(sig),
            " filtered by daily bias (", DailyBiasName(g_dailyBias), ")");
      return;
   }

   // v0.8: filtri direzionali (HTF trend + correlation S&P)
   if(!DirectionalFiltersPass(sig))
   {
      if(InpVerboseMode)
         Print("[SIGNAL][BLOCKED] ", EnumToString(sig),
               " filtered by directional filters");
      return;
   }

   if(OpenPosition(sig))
   {
      g_state = STATE_IN_TRADE;
      g_tradesToday++;
      LogTrade(sig);
   }
}

void HandleInTrade()
{
   ManageActivePositions();

   if(CountMyPositions() == 0)
   {
      if(g_tradesToday >= InpMaxTradesPerDay)
         g_state = STATE_EOD;
      else
         g_state = STATE_WAIT_TRIGGER;
   }
}

void HandleHedged()
{
   // v2: gestione del doppio ordine, regole di rilascio. Non raggiungibile in v1.
}

void HandleEOD()
{
   if(CountMyPositions() > 0)
      CloseAllMyPositions("EOD");
   if(g_activeTicket != 0 && CountMyPositions() == 0)
      ResetActivePositionTracking();
}

//+------------------------------------------------------------------+
//| INDICATOR ADAPTER LAYER                                          |
//+------------------------------------------------------------------+
bool CreateIndicatorHandles()
{
   // MA 200 - native MT5 iMA
   g_handleMA200 = iMA(_Symbol, InpMA200TF, InpMA200Period, 0, InpMA200Method, PRICE_CLOSE);
   if(g_handleMA200 == INVALID_HANDLE)
   {
      Print("[ERROR] Failed to create MA200 handle");
      return false;
   }

   // PROP - Protezione 5: handle persistenti (stessi parametri/buffer della v2.0)
   if(InpADXFilterEnabled)
   {
      g_handleADX = iADX(_Symbol, InpADXTimeframe, InpADXPeriod);
      if(g_handleADX == INVALID_HANDLE)
      {
         Print("[ERROR] Failed to create ADX handle");
         return false;
      }
   }
   if(InpATRSpikeFilterEnabled)
   {
      g_handleATRD1Spike = iATR(_Symbol, PERIOD_D1, 14);
      if(g_handleATRD1Spike == INVALID_HANDLE)
      {
         Print("[ERROR] Failed to create ATR D1 spike handle");
         return false;
      }
   }
   if(InpVolatilityShockFilterEnabled || InpCandleRangeFilterEnabled)
   {
      g_handleATRM5Avg = iATR(_Symbol, PERIOD_M5, InpATRM5AvgPeriod);
      if(g_handleATRM5Avg == INVALID_HANDLE)
      {
         Print("[ERROR] Failed to create ATR M5 handle");
         return false;
      }
   }
   if(InpTrailingEnabled)
   {
      g_handleATRD1Trail = iATR(_Symbol, PERIOD_D1, InpTrailingATRPeriod);
      if(g_handleATRD1Trail == INVALID_HANDLE)
      {
         Print("[ERROR] Failed to create ATR D1 trailing handle");
         return false;
      }
   }

   // Market Profile via iCustom (EarnForex ver.) - stub, default OFF
   if(InpMarketProfileEnabled)
   {
      g_handleMarketProfile = iCustom(_Symbol, PERIOD_CURRENT, InpMarketProfileName);
      if(g_handleMarketProfile == INVALID_HANDLE)
         Print("[WARN] MarketProfile handle failed. Continuing without POC/VAH/VAL.");
   }

   return true;
}

// MA 200 - valore su shift (default 1 = ultima candela chiusa)
// PROP - fail-safe conservativo: ritorna 0 se i dati non sono pronti (caller blocca il segnale)
double GetMA200Value(int shift = 1)
{
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(g_handleMA200, 0, shift, 1, buf) <= 0) return 0;
   return buf[0];
}

//+------------------------------------------------------------------+
//| GetADXValue (v1.7) - handle persistente (PROP - Protezione 5)    |
//| FAIL-SAFE: se l'handle e' invalido o i dati non sono pronti       |
//| ritorna -1 (segnale "non disponibile"). Il caller deve bloccare.  |
//+------------------------------------------------------------------+
double GetADXValue()
{
   if(g_handleADX == INVALID_HANDLE) return -1;

   double buf[];
   ArraySetAsSeries(buf, true);
   // Buffer 0 = ADX main line, shift 1 = ultima candela chiusa
   if(CopyBuffer(g_handleADX, 0, 1, 1, buf) <= 0) return -1;
   return buf[0];
}

//+------------------------------------------------------------------+
//| GetGapPoints (v1.8) - gap apertura giornaliera                   |
//| FAIL-SAFE: ritorna -1 se i dati non sono disponibili.            |
//+------------------------------------------------------------------+
double GetGapPoints()
{
   MqlRates m5[];
   ArraySetAsSeries(m5, true);
   if(CopyRates(_Symbol, PERIOD_M5, 0, 1, m5) <= 0) return -1;
   double openToday = m5[0].open;

   MqlRates d1[];
   ArraySetAsSeries(d1, true);
   if(CopyRates(_Symbol, PERIOD_D1, 1, 1, d1) <= 0) return -1;
   double closeYesterday = d1[0].close;

   return MathAbs(openToday - closeYesterday);
}

//+------------------------------------------------------------------+
//| GetATRD1Ratio (v1.8 + bugfix v1.9) - handle persistente          |
//| FAIL-SAFE: ritorna -1 se i dati non sono pronti (caller blocca). |
//| (in v2.0 ritornava 1.0 = permissivo: qui reso conservativo)      |
//+------------------------------------------------------------------+
double GetATRD1Ratio()
{
   if(g_handleATRD1Spike == INVALID_HANDLE) return -1;

   double buf[];
   ArraySetAsSeries(buf, true);
   int needed = InpATRAvgPeriod + 1;
   int copied = CopyBuffer(g_handleATRD1Spike, 0, 0, needed, buf);

   // bugfix v1.9: serve almeno needed valori
   if(copied < needed) return -1;
   if(ArraySize(buf) < 2) return -1;

   double atrCurrent = buf[0];

   int maxIdx = MathMin(InpATRAvgPeriod, ArraySize(buf) - 1);
   if(maxIdx < 1) return -1;

   double sum = 0;
   for(int i = 1; i <= maxIdx; i++)
      sum += buf[i];
   double atrAvg = sum / maxIdx;

   if(atrAvg <= 0) return -1;
   return atrCurrent / atrAvg;
}

//+------------------------------------------------------------------+
//| GetATRM5Ratio (v1.8) - handle persistente                        |
//| FAIL-SAFE: ritorna -1 se i dati non sono pronti (caller blocca). |
//+------------------------------------------------------------------+
double GetATRM5Ratio()
{
   if(g_handleATRM5Avg == INVALID_HANDLE) return -1;

   double buf[];
   ArraySetAsSeries(buf, true);
   int needed = InpATRM5AvgPeriod * 3 + 1;
   if(CopyBuffer(g_handleATRM5Avg, 0, 1, needed, buf) < needed) return -1;

   double atrCurrent = buf[0];

   // Media storica (escluse ultime 2 candele per evitare auto-correlazione)
   double sum = 0;
   int count = 0;
   for(int i = 2; i < needed; i++)
   {
      sum += buf[i];
      count++;
   }
   if(count <= 0) return -1;
   double atrAvg = sum / count;

   if(atrAvg <= 0) return -1;
   return atrCurrent / atrAvg;
}

//+------------------------------------------------------------------+
//| GetATRM5Value (v1.8 filtro 4) - ATR M5 ultima candela chiusa     |
//| Handle persistente. FAIL-SAFE: ritorna -1 se non disponibile.    |
//+------------------------------------------------------------------+
double GetATRM5Value()
{
   if(g_handleATRM5Avg == INVALID_HANDLE) return -1;
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(g_handleATRM5Avg, 0, 1, 1, buf) <= 0) return -1;
   return buf[0];
}

//+------------------------------------------------------------------+
//| HEIKEN ASHI HELPER (v1.9 - presente ma default OFF)              |
//+------------------------------------------------------------------+
bool IsHeikenAshiAligned(ESignalDirection dir)
{
   if(!InpHAFilterEnabled) return true;  // filtro disattivato -> passa sempre
   if(dir == SIG_NONE) return false;

   int candlesToCheck = MathMax(1, InpHACheckPreviousCandles + 1);
   int lookback = 50;
   int totalNeeded = lookback + candlesToCheck;

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(_Symbol, InpHATimeframe, 1, totalNeeded, rates);
   if(copied < totalNeeded)
   {
      // PROP - fail-safe conservativo: se il filtro HA e' attivo ma mancano
      // dati, NON operare (in v2.0 era permissivo). Filtro OFF di default.
      Print("[HA] WARN: insufficienti candele OHLC su ", EnumToString(InpHATimeframe),
            " (", copied, "/", totalNeeded, ") -> blocco conservativo");
      return false;
   }

   double ha_open[], ha_close[];
   ArrayResize(ha_open, totalNeeded);
   ArrayResize(ha_close, totalNeeded);

   int oldest = totalNeeded - 1;
   ha_open[oldest]  = (rates[oldest].open + rates[oldest].close) / 2.0;
   ha_close[oldest] = (rates[oldest].open + rates[oldest].high + rates[oldest].low + rates[oldest].close) / 4.0;

   for(int i = oldest - 1; i >= 0; i--)
   {
      ha_close[i] = (rates[i].open + rates[i].high + rates[i].low + rates[i].close) / 4.0;
      ha_open[i]  = (ha_open[i+1] + ha_close[i+1]) / 2.0;
   }

   for(int j = 0; j < candlesToCheck; j++)
   {
      double ho = ha_open[j];
      double hc = ha_close[j];
      bool isGreen = (hc > ho);
      bool isRed   = (hc < ho);

      if(InpHAColorMatchRequired)
      {
         if(dir == SIG_LONG && !isGreen)
         {
            if(InpVerboseMode) Print("[HA] REJECT LONG: candela HA[", j, "] non verde");
            return false;
         }
         if(dir == SIG_SHORT && !isRed)
         {
            if(InpVerboseMode) Print("[HA] REJECT SHORT: candela HA[", j, "] non rossa");
            return false;
         }
      }

      if(InpHARequireBody)
      {
         double hh = MathMax(rates[j].high, MathMax(ho, hc));
         double hl = MathMin(rates[j].low,  MathMin(ho, hc));
         double range = hh - hl;
         double body  = MathAbs(hc - ho);
         if(range > 0 && (body / range) < 0.30)
         {
            if(InpVerboseMode) Print("[HA] REJECT: candela HA[", j, "] corpo troppo piccolo");
            return false;
         }
      }
   }

   if(InpVerboseMode) Print("[HA] PASS: ", candlesToCheck, " candele HA allineate per ", EnumToString(dir));
   return true;
}

// ORB range - costruzione nativa
void BuildORBRange()
{
   ENUM_TIMEFRAMES tf = GetCurrentORBTimeframe();
   int candlesCount   = GetCurrentORBCandlesCount();

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   int copied = CopyRates(_Symbol, tf, 1, candlesCount, rates);
   if(copied < candlesCount) return;

   double hi = rates[0].high;
   double lo = rates[0].low;
   for(int i = 1; i < copied; i++)
   {
      if(rates[i].high > hi) hi = rates[i].high;
      if(rates[i].low  < lo) lo = rates[i].low;
   }
   g_orbHigh = hi;
   g_orbLow  = lo;
}

bool IsORBComplete()
{
   int candlesCount = GetCurrentORBCandlesCount();
   int tfMinutes    = PeriodSeconds(GetCurrentORBTimeframe()) / 60;

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int minutesNow = dt.hour * 60 + dt.min;

   int sessionStartMinutes = 0;
   if(g_session == SESSION_MORNING)
      sessionStartMinutes = InpMorningStartHour * 60 + InpMorningStartMin;
   else if(g_session == SESSION_AFTERNOON)
      sessionStartMinutes = InpAfternoonStartHour * 60 + InpAfternoonStartMin;
   else
      return false;

   int minutesSinceOpen = minutesNow - sessionStartMinutes;
   return (minutesSinceOpen >= candlesCount * tfMinutes);
}

//+------------------------------------------------------------------+
//| Helper: TF e count ORB correnti (dipendono dalla sessione)       |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES GetCurrentORBTimeframe()
{
   return (g_session == SESSION_AFTERNOON) ? InpORBTimeframeAfternoon : InpORBTimeframe;
}

int GetCurrentORBCandlesCount()
{
   return (g_session == SESSION_AFTERNOON) ? InpORBCandlesCountAfternoon : InpORBCandlesCount;
}

void ResetORBState()
{
   g_orbHigh  = 0;
   g_orbLow   = 0;
   g_orbStart = 0;
   g_orbEnd   = 0;
   g_orbReady = false;
}

void ResetSignalCandleTracker()
{
   g_lastSignalBar = iTime(_Symbol, GetCurrentORBTimeframe(), 0);
}

// RB_Volume logic - reimplementazione nativa
bool VolumeFilterPass()
{
   if(!InpVolumeFilterEnabled) return true;

   long volBuf[];
   ArraySetAsSeries(volBuf, true);
   int copied = CopyTickVolume(_Symbol, GetCurrentORBTimeframe(), 1, InpVolumeMAPeriod + 1, volBuf);
   // PROP - fail-safe conservativo: filtro attivo ma dati insufficienti -> blocca
   if(copied < InpVolumeMAPeriod + 1) return false;

   double ma = 0;
   for(int i = 1; i <= InpVolumeMAPeriod; i++) ma += (double)volBuf[i];
   ma /= InpVolumeMAPeriod;

   double ratio = (ma > 0) ? (double)volBuf[0] / ma : 0;
   return (ratio >= InpVolumeMultiplier);
}

// Market Profile POC - da iCustom buffer (stub adapter)
double GetMarketProfilePOC(int shift = 0)
{
   if(!InpMarketProfileEnabled) return 0;
   if(g_handleMarketProfile == INVALID_HANDLE) return 0;
   double buf[];
   ArraySetAsSeries(buf, true);
   if(CopyBuffer(g_handleMarketProfile, 0, shift, 1, buf) <= 0) return 0;
   return buf[0];
}

// STUB VWAP_ATR - in attesa di sorgente Emiliano (non usato come filtro)
double GetVWAPATR_Upper(int shift = 1)  { return 0; }
double GetVWAPATR_Lower(int shift = 1)  { return 0; }

// STUB Supertrend - non implementato. Default OFF, non usato come filtro.
int GetSupertrendDirection(int shift = 1)
{
   // Return: +1 long, -1 short, 0 neutral. Stub: sempre 0 (neutro).
   return 0;
}

//+------------------------------------------------------------------+
//| SIGNAL GENERATOR (con diagnostica verbose)                       |
//| PROP - fail-safe conservativo: ogni filtro/indicatore con dati   |
//| non pronti BLOCCA il segnale (ritorna SIG_NONE).                 |
//+------------------------------------------------------------------+
ESignalDirection GenerateSignal()
{
   if(!g_orbReady)
   {
      LogSignalReject("ORB not ready");
      return SIG_NONE;
   }

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, GetCurrentORBTimeframe(), 1, 1, rates) <= 0)
   {
      LogSignalReject("CopyRates failed");
      return SIG_NONE;
   }

   double open  = rates[0].open;
   double close = rates[0].close;
   double high  = rates[0].high;
   double low   = rates[0].low;
   double bodyHigh = MathMax(open, close);
   double bodyLow  = MathMin(open, close);
   double candleRange = high - low;
   int dg = g_symbol.Digits();

   double ma200 = GetMA200Value(1);
   if(ma200 == 0)
   {
      LogSignalReject(StringFormat("MA200=0 (buffer not ready, need %d bars history)", InpMA200Period));
      return SIG_NONE;
   }

   if(candleRange < InpMinTriggerCandleRange)
   {
      LogSignalReject(StringFormat("Candle range %.2f < min %.2f (too small)",
                      candleRange, InpMinTriggerCandleRange));
      return SIG_NONE;
   }

   bool volOK = VolumeFilterPass();
   double volRatio = ComputeVolumeRatioLastCandle();

   if(!volOK)
   {
      LogSignalReject(StringFormat("Volume fail: ratio=%.2f < %.2f",
                      volRatio, InpVolumeMultiplier));
      return SIG_NONE;
   }

   double longBreakoutLevel  = g_orbHigh + InpORBBreakoutBuffer;
   double shortBreakoutLevel = g_orbLow  - InpORBBreakoutBuffer;

   bool longBreakout  = (bodyLow  > g_orbHigh) && (close >= longBreakoutLevel);
   bool longMaOK      = (close > ma200);
   bool shortBreakout = (bodyHigh < g_orbLow)  && (close <= shortBreakoutLevel);
   bool shortMaOK     = (close < ma200);

   if(longBreakout && longMaOK)
   {
      if(!QualityFiltersPass(SIG_LONG, close, ma200, candleRange))
         return SIG_NONE;

      Print("[SIGNAL][LONG] Fired! body[",
            DoubleToString(bodyLow, dg), "-", DoubleToString(bodyHigh, dg),
            "] > ORB.H=", DoubleToString(g_orbHigh, dg),
            " | close=", DoubleToString(close, dg),
            " >= trigger=", DoubleToString(longBreakoutLevel, dg),
            " | MA200=", DoubleToString(ma200, dg),
            " | range=", DoubleToString(candleRange, 2),
            " | volRatio=", DoubleToString(volRatio, 2));
      return SIG_LONG;
   }

   if(shortBreakout && shortMaOK)
   {
      if(!QualityFiltersPass(SIG_SHORT, close, ma200, candleRange))
         return SIG_NONE;

      Print("[SIGNAL][SHORT] Fired! body[",
            DoubleToString(bodyLow, dg), "-", DoubleToString(bodyHigh, dg),
            "] < ORB.L=", DoubleToString(g_orbLow, dg),
            " | close=", DoubleToString(close, dg),
            " <= trigger=", DoubleToString(shortBreakoutLevel, dg),
            " | MA200=", DoubleToString(ma200, dg),
            " | range=", DoubleToString(candleRange, 2),
            " | volRatio=", DoubleToString(volRatio, 2));
      return SIG_SHORT;
   }

   // Nessun breakout - diagnostica
   if(InpVerboseMode)
   {
      string reason = "No breakout: ";
      reason += StringFormat("body[%s-%s] ORB[%s-%s] triggers[L>=%s S<=%s]",
                  DoubleToString(bodyLow, dg), DoubleToString(bodyHigh, dg),
                  DoubleToString(g_orbLow, dg), DoubleToString(g_orbHigh, dg),
                  DoubleToString(longBreakoutLevel, dg),
                  DoubleToString(shortBreakoutLevel, dg));
      reason += StringFormat(" | close=%s ma200=%s",
                  DoubleToString(close, dg), DoubleToString(ma200, dg));
      if(bodyLow > g_orbHigh && close < longBreakoutLevel)
         reason += " [LONG body OK but close < trigger buffer]";
      else if(bodyHigh < g_orbLow && close > shortBreakoutLevel)
         reason += " [SHORT body OK but close > trigger buffer]";
      else if(bodyLow > g_orbHigh && !longMaOK)
         reason += " [LONG breakout OK but close<ma200]";
      else if(bodyHigh < g_orbLow && !shortMaOK)
         reason += " [SHORT breakout OK but close>ma200]";
      else if(!longBreakout && !shortBreakout)
         reason += " [body inside ORB range]";
      LogSignalReject(reason);
   }

   return SIG_NONE;
}

//+------------------------------------------------------------------+
//| QualityFiltersPass - tutti i filtri qualita'/anti-shock (v1.7+v1.8)|
//| Fattorizzato da GenerateSignal (LONG/SHORT erano duplicati).      |
//| PROP - fail-safe conservativo: dati non pronti -> blocca (false). |
//+------------------------------------------------------------------+
bool QualityFiltersPass(ESignalDirection dir, double close, double ma200, double candleRange)
{
   string tag = (dir == SIG_LONG) ? "LONG" : "SHORT";

   // v1.7: Filtro ADX
   if(InpADXFilterEnabled)
   {
      double adx = GetADXValue();
      if(adx < 0)  // dati non pronti / handle invalido
      {
         LogSignalReject(tag + " ADX non disponibile -> blocco conservativo");
         return false;
      }
      if(adx < InpADXMinValue)
      {
         LogSignalReject(StringFormat("%s ADX too low: %.2f < %.2f (mercato laterale)",
                                      tag, adx, InpADXMinValue));
         return false;
      }
   }

   // v1.7: Filtro distanza minima MA200
   if(InpMinDistanceMA200Enabled)
   {
      double dist = MathAbs(close - ma200);
      if(dist < InpMinDistanceMA200)
      {
         LogSignalReject(StringFormat("%s too close to MA200: dist=%.2f < %.2f (entry stanco)",
                                      tag, dist, InpMinDistanceMA200));
         return false;
      }
   }

   // v1.8: Filtro 1 - Gap apertura
   if(InpGapFilterEnabled)
   {
      double gap = GetGapPoints();
      if(gap < 0)  // dati non disponibili
      {
         LogSignalReject(tag + " gap non disponibile -> blocco conservativo");
         return false;
      }
      if(gap > InpMaxGapPoints)
      {
         LogSignalReject(StringFormat("%s gap too large: %.2fpt > %.2fpt (shock di apertura)",
                                      tag, gap, InpMaxGapPoints));
         return false;
      }
   }

   // v1.8: Filtro 2 - ATR D1 estremo
   if(InpATRSpikeFilterEnabled)
   {
      double atrRatio = GetATRD1Ratio();
      if(atrRatio < 0)  // dati non pronti
      {
         LogSignalReject(tag + " ATR D1 non disponibile -> blocco conservativo");
         return false;
      }
      if(atrRatio > InpATRSpikeMultiplier)
      {
         LogSignalReject(StringFormat("%s ATR D1 spike: %.2fx > %.2fx (volatilita' anomala)",
                                      tag, atrRatio, InpATRSpikeMultiplier));
         return false;
      }
   }

   // v1.8: Filtro 3 - Volatility shock M5
   if(InpVolatilityShockFilterEnabled)
   {
      double atrM5Ratio = GetATRM5Ratio();
      if(atrM5Ratio < 0)  // dati non pronti
      {
         LogSignalReject(tag + " ATR M5 non disponibile -> blocco conservativo");
         return false;
      }
      if(atrM5Ratio > InpATRM5SpikeMultiplier)
      {
         LogSignalReject(StringFormat("%s ATR M5 shock: %.2fx > %.2fx (news/shock in atto)",
                                      tag, atrM5Ratio, InpATRM5SpikeMultiplier));
         return false;
      }
   }

   // v1.8: Filtro 4 - Candela trigger esplosa
   if(InpCandleRangeFilterEnabled)
   {
      double atrM5 = GetATRM5Value();
      if(atrM5 < 0)  // dati non pronti
      {
         LogSignalReject(tag + " ATR M5 (candela) non disponibile -> blocco conservativo");
         return false;
      }
      double maxAllowedRange = atrM5 * InpMaxCandleATRMult;
      if(atrM5 > 0 && candleRange > maxAllowedRange)
      {
         LogSignalReject(StringFormat("%s candle range %.2f > %.2f (%.2fx ATR, candela esplosa)",
                                      tag, candleRange, maxAllowedRange, candleRange/atrM5));
         return false;
      }
   }

   // v1.9: Filtro Heiken Ashi (default OFF in PROP)
   if(!IsHeikenAshiAligned(dir))
   {
      LogSignalReject(tag + " bloccato da filtro Heiken Ashi");
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| LogSignalReject - stampa motivo del signal NONE (solo verbose)   |
//+------------------------------------------------------------------+
void LogSignalReject(string reason)
{
   if(!InpVerboseMode) return;
   Print("[SIGNAL][NONE] ", reason);
}

//+------------------------------------------------------------------+
//| ComputeVolumeRatioLastCandle - helper diagnostico                |
//+------------------------------------------------------------------+
double ComputeVolumeRatioLastCandle()
{
   long volBuf[];
   ArraySetAsSeries(volBuf, true);
   int copied = CopyTickVolume(_Symbol, GetCurrentORBTimeframe(), 1, InpVolumeMAPeriod + 1, volBuf);
   if(copied < InpVolumeMAPeriod + 1) return 0;

   double ma = 0;
   for(int i = 1; i <= InpVolumeMAPeriod; i++) ma += (double)volBuf[i];
   ma /= InpVolumeMAPeriod;

   return (ma > 0) ? (double)volBuf[0] / ma : 0;
}

//+------------------------------------------------------------------+
//| FILTERS (non direzionali)                                        |
//+------------------------------------------------------------------+
bool AllFiltersPass()
{
   if(!DayOfWeekFilterPass())    { if(InpVerboseMode) Print("[FILTER] Day of week block"); return false; }
   if(!NewsFilterPass())         { if(InpVerboseMode) Print("[FILTER] News block");        return false; }
   if(!SRProximityFilterPass())  { if(InpVerboseMode) Print("[FILTER] S/R proximity");     return false; }
   return true;
}

bool DayOfWeekFilterPass()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   switch(dt.day_of_week)
   {
      case 1: return InpTradeMonday;
      case 2: return InpTradeTuesday;
      case 3: return InpTradeWednesday;
      case 4: return InpTradeThursday;
      case 5: return InpTradeFriday;
   }
   return false;
}

//+------------------------------------------------------------------+
//| NewsFilterPass                                                   |
//| PROP - Protezione 4: in Strategy Tester resta permissivo         |
//| (Calendar non disponibile). In LIVE se la Calendar non e'        |
//| leggibile -> conservativo (NON opera).                           |
//+------------------------------------------------------------------+
bool NewsFilterPass()
{
   if(!InpNewsFilterEnabled) return true;

   // Eccezione PROP: nel Tester la Calendar API ritorna 4014. Permissivo SOLO qui.
   if(g_isTester) return true;

   datetime now  = TimeTradeServer();
   datetime from = now - (InpNewsBufferMinutes * 60);
   datetime to   = now + (InpNewsBufferMinutes * 60);

   string   blockName = "";
   datetime blockTime = 0;
   bool     apiError  = false;

   // EUR news: impattano DAX direttamente
   if(InpNewsCheckEUR && HasBlockingNewsForCurrency("EUR", from, to, blockName, blockTime, apiError))
   {
      Print("[NEWS BLOCK] EUR event '", blockName, "' at ",
            TimeToString(blockTime, TIME_DATE|TIME_MINUTES),
            " within +/-", InpNewsBufferMinutes, "min window");
      return false;
   }
   // PROP - Protezione 4: errore Calendar in LIVE -> NON opera
   if(apiError)
   {
      Print("[NEWS][LIVE] Calendar non leggibile (EUR) -> blocco conservativo (no trade).");
      return false;
   }

   // USD news: impattano DAX via correlazione SPX/Nasdaq
   if(InpNewsCheckUSD && HasBlockingNewsForCurrency("USD", from, to, blockName, blockTime, apiError))
   {
      Print("[NEWS BLOCK] USD event '", blockName, "' at ",
            TimeToString(blockTime, TIME_DATE|TIME_MINUTES),
            " within +/-", InpNewsBufferMinutes, "min window");
      return false;
   }
   if(apiError)
   {
      Print("[NEWS][LIVE] Calendar non leggibile (USD) -> blocco conservativo (no trade).");
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| HasBlockingNewsForCurrency                                       |
//| PROP - Protezione 4: segnala l'errore API tramite apiError (out) |
//| invece di "passare permissivo" come faceva v2.0.                 |
//+------------------------------------------------------------------+
bool HasBlockingNewsForCurrency(string currency, datetime from, datetime to,
                                 string &blockingName, datetime &blockingTime,
                                 bool &apiError)
{
   apiError = false;
   MqlCalendarValue values[];
   int count = CalendarValueHistory(values, from, to, NULL, currency);

   if(count < 0)
   {
      // API error - segnalalo al caller (in LIVE -> blocco conservativo)
      Print("[NEWS][WARN] CalendarValueHistory error for ", currency,
            ". Code=", GetLastError());
      apiError = true;
      return false;
   }
   if(count == 0) return false;

   for(int i = 0; i < count; i++)
   {
      MqlCalendarEvent event;
      if(!CalendarEventById(values[i].event_id, event)) continue;

      if(event.importance >= InpNewsMinImportance)
      {
         blockingName = event.name;
         blockingTime = values[i].time;
         return true;
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| LogTodaysNewsBriefing                                            |
//+------------------------------------------------------------------+
void LogTodaysNewsBriefing()
{
   static datetime lastBriefingDay = 0;

   if(g_isTester) return;

   datetime now = TimeTradeServer();
   MqlDateTime dtNow;
   TimeToStruct(now, dtNow);

   datetime today0000 = now - (dtNow.hour * 3600 + dtNow.min * 60 + dtNow.sec);
   if(lastBriefingDay == today0000) return;
   lastBriefingDay = today0000;

   datetime tomorrow0000 = today0000 + 86400;

   Print("[NEWS BRIEFING] Scheduled events >= ",
         EnumToString(InpNewsMinImportance), " for today:");

   string currencies[2] = {"EUR", "USD"};
   int    totalListed   = 0;

   for(int c = 0; c < 2; c++)
   {
      if(c == 0 && !InpNewsCheckEUR) continue;
      if(c == 1 && !InpNewsCheckUSD) continue;

      MqlCalendarValue values[];
      int count = CalendarValueHistory(values, today0000, tomorrow0000, NULL, currencies[c]);
      if(count <= 0) continue;

      for(int i = 0; i < count; i++)
      {
         MqlCalendarEvent event;
         if(!CalendarEventById(values[i].event_id, event)) continue;
         if(event.importance < InpNewsMinImportance) continue;

         Print("  ", currencies[c], " ",
               TimeToString(values[i].time, TIME_MINUTES),
               " - ", event.name);
         totalListed++;
      }
   }

   if(totalListed == 0)
      Print("  (no high-impact events today)");
   else
      Print("[NEWS BRIEFING] ", totalListed, " event(s) listed. Trading blocked +/-",
            InpNewsBufferMinutes, "min around each.");
}

//+------------------------------------------------------------------+
//| CorrelationFilterPass (v0.8) - default OFF                       |
//| Fail-safe permissivo SOLO perche' il filtro e' opzionale e OFF.  |
//+------------------------------------------------------------------+
bool CorrelationFilterPass(ESignalDirection dir)
{
   if(!InpCorrelationEnabled) return true;
   if(dir == SIG_NONE)        return true;

   if(!SymbolSelect(InpSPXSymbol, true))
   {
      // PROP - se il filtro e' stato ATTIVATO ma il simbolo non c'e', blocca
      Print("[FILTER][CORR] Symbol '", InpSPXSymbol, "' not available -> blocco conservativo");
      return false;
   }

   MqlRates spxRates[];
   ArraySetAsSeries(spxRates, true);
   if(CopyRates(InpSPXSymbol, InpSPXTrendTF, 1, 1, spxRates) <= 0)
   {
      Print("[FILTER][CORR] CopyRates failed for ", InpSPXSymbol,
            " (err=", GetLastError(), ") -> blocco conservativo");
      return false;
   }
   double spxClose = spxRates[0].close;

   int spxMAHandle = iMA(InpSPXSymbol, InpSPXTrendTF,
                         InpSPXMAPeriod, 0, InpSPXMAMethod, PRICE_CLOSE);
   if(spxMAHandle == INVALID_HANDLE)
   {
      Print("[FILTER][CORR] iMA handle invalid on ", InpSPXSymbol, " -> blocco conservativo");
      return false;
   }

   double maBuf[];
   ArraySetAsSeries(maBuf, true);
   int copied = CopyBuffer(spxMAHandle, 0, 1, 1, maBuf);
   IndicatorRelease(spxMAHandle);

   if(copied <= 0)
   {
      Print("[FILTER][CORR] CopyBuffer MA failed on ", InpSPXSymbol, " -> blocco conservativo");
      return false;
   }

   double spxMA = maBuf[0];
   bool spxBullish = (spxClose > spxMA);
   bool spxBearish = (spxClose < spxMA);

   if(dir == SIG_LONG && !spxBullish)
   {
      if(InpVerboseMode)
         Print("[FILTER][CORR] LONG blocked: S&P bearish");
      return false;
   }
   if(dir == SIG_SHORT && !spxBearish)
   {
      if(InpVerboseMode)
         Print("[FILTER][CORR] SHORT blocked: S&P bullish");
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| HTFTrendFilterPass (v0.8) - default OFF                          |
//| PROP - se attivato ma i dati non sono pronti -> blocca.          |
//+------------------------------------------------------------------+
bool HTFTrendFilterPass(ESignalDirection dir)
{
   if(!InpHTFTrendEnabled) return true;
   if(dir == SIG_NONE)     return true;

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, InpHTFTrendTF, 1, 1, rates) <= 0)
   {
      Print("[FILTER][HTF] CopyRates failed (err=", GetLastError(), ") -> blocco conservativo");
      return false;
   }
   double htfClose = rates[0].close;

   int htfHandle = iMA(_Symbol, InpHTFTrendTF,
                       InpHTFMAPeriod, 0, InpHTFMAMethod, PRICE_CLOSE);
   if(htfHandle == INVALID_HANDLE)
   {
      Print("[FILTER][HTF] iMA handle invalid -> blocco conservativo");
      return false;
   }

   double maBuf[];
   ArraySetAsSeries(maBuf, true);
   int copied = CopyBuffer(htfHandle, 0, 1, 1, maBuf);
   IndicatorRelease(htfHandle);

   if(copied <= 0)
   {
      Print("[FILTER][HTF] CopyBuffer MA failed -> blocco conservativo");
      return false;
   }

   double htfMA = maBuf[0];
   bool htfBull = (htfClose > htfMA);
   bool htfBear = (htfClose < htfMA);

   if(dir == SIG_LONG && !htfBull)
   {
      if(InpVerboseMode) Print("[FILTER][HTF] LONG blocked: HTF bearish");
      return false;
   }
   if(dir == SIG_SHORT && !htfBear)
   {
      if(InpVerboseMode) Print("[FILTER][HTF] SHORT blocked: HTF bullish");
      return false;
   }

   return true;
}

//+------------------------------------------------------------------+
//| DirectionalFiltersPass (v0.8)                                    |
//+------------------------------------------------------------------+
bool DirectionalFiltersPass(ESignalDirection dir)
{
   if(!HTFTrendFilterPass(dir))    return false;
   if(!CorrelationFilterPass(dir)) return false;
   return true;
}

//+------------------------------------------------------------------+
//| v3.20 - DirectionModePass: gate direzionale globale per A/B test  |
//| dell'asimmetria Long/Short. DEFAULT DIR_BOTH = nessun filtro.     |
//+------------------------------------------------------------------+
bool DirectionModePass(ESignalDirection dir)
{
   if(InpDirectionMode == DIR_BOTH) return true;
   if(InpDirectionMode == DIR_LONG_ONLY)  return (dir == SIG_LONG);
   if(InpDirectionMode == DIR_SHORT_ONLY) return (dir == SIG_SHORT);
   return true;
}

//+------------------------------------------------------------------+
//| SRProximityFilterPass (STUB - default OFF)                       |
//| Funzione non implementata. Se attivata, blocca conservativamente |
//| invece di passare silenziosamente come "filtro attivo" finto.    |
//+------------------------------------------------------------------+
bool SRProximityFilterPass()
{
   if(!InpSRFilterEnabled) return true;
   // PROP - stub non implementato: se l'utente lo attiva, NON deve credere
   // che stia filtrando. Blocchiamo conservativamente e avvisiamo.
   static bool warned = false;
   if(!warned)
   {
      Print("[FILTER][S/R] ATTENZIONE: filtro S/R attivato ma NON implementato (stub). ",
            "Blocco conservativo di tutti i segnali finche' resta ON.");
      warned = true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| POSITION MANAGER                                                 |
//+------------------------------------------------------------------+
bool OpenPosition(ESignalDirection dir)
{
   if(!g_symbol.RefreshRates())
   {
      Print("[OPEN][ERROR] Cannot refresh rates");
      return false;
   }

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, GetCurrentORBTimeframe(), 1, 1, rates) <= 0)
   {
      Print("[OPEN][ERROR] Cannot copy signal candle");
      return false;
   }

   double slPrice = CalculateStopLossPrice(dir, rates[0]);

   double entryPrice = (dir == SIG_LONG) ? g_symbol.Ask() : g_symbol.Bid();
   double slDistance = MathAbs(entryPrice - slPrice);

   int    stopLevelMT5 = (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   double stopLevelPriceUnits = stopLevelMT5 * g_symbol.Point();

   if(slDistance < stopLevelPriceUnits)
   {
      Print("[OPEN][REJECT] SL distance ", DoubleToString(slDistance, 2),
            " units below broker stop level ", DoubleToString(stopLevelPriceUnits, 2), " units");
      return false;
   }

   if(slDistance < InpMinSLDistance)
   {
      Print("[OPEN][REJECT] SL distance ", DoubleToString(slDistance, 2),
            " units below user min ", DoubleToString(InpMinSLDistance, 2),
            " units (would generate oversize lot)");
      return false;
   }

   if(slDistance > InpMaxSLDistance)
   {
      Print("[OPEN][REJECT] SL distance ", DoubleToString(slDistance, 2),
            " units above safety cap ", DoubleToString(InpMaxSLDistance, 2), " units");
      return false;
   }

   // v3.20: TP finale fisso in punti (default) oppure a R-multiplo dello SL reale.
   // R-mode rende il R:R coerente con il rischio effettivo del trade (anti payoff<1).
   double finalTPdist = InpFinalTP;
   if(InpUseRMultipleTP)
      finalTPdist = InpTP_R_Multiple * slDistance;

   double tpPrice = 0;
   if(dir == SIG_LONG)
      tpPrice = entryPrice + finalTPdist;
   else
      tpPrice = entryPrice - finalTPdist;

   double lots = CalculateLotSize(slDistance);
   if(lots <= 0)
   {
      Print("[OPEN][REJECT] Invalid lot size (", lots, ")");
      return false;
   }

   slPrice  = NormalizeDouble(slPrice,  g_symbol.Digits());
   tpPrice  = NormalizeDouble(tpPrice,  g_symbol.Digits());

   bool ok = false;
   string comment = "DAX_MASTER_PROP";

   if(dir == SIG_LONG)
      ok = g_trade.Buy(lots, _Symbol, 0, slPrice, tpPrice, comment);
   else
      ok = g_trade.Sell(lots, _Symbol, 0, slPrice, tpPrice, comment);

   if(!ok)
   {
      Print("[OPEN][ERROR] Trade failed. retcode=", g_trade.ResultRetcode(),
            " desc=", g_trade.ResultRetcodeDescription());
      return false;
   }

   g_activeTicket        = g_trade.ResultOrder();
   g_activeInitialVolume = lots;
   g_activeEntryPrice    = entryPrice;
   g_activePartialDone   = false;
   g_activeBEMoved       = false;
   g_activeDir           = dir;
   g_activeMaxFavorable  = 0;
   g_activeTrailingSL    = 0;
   g_activeSLDistance    = slDistance;   // v3.20: distanza SL reale per TP/BE/trailing a R
   g_activePositionId    = 0;
   if(g_position.SelectByTicket(g_activeTicket))
      g_activePositionId = (long)g_position.Identifier();

   Print("[OPEN][OK] ", EnumToString(dir),
         " ticket=", g_activeTicket,
         " lots=",   DoubleToString(lots, 2),
         " entry=",  DoubleToString(entryPrice, g_symbol.Digits()),
         " SL=",     DoubleToString(slPrice, g_symbol.Digits()),
         " (",       DoubleToString(slDistance, 2), " units)",
         " TP=",     DoubleToString(tpPrice, g_symbol.Digits()));

   return true;
}

//+------------------------------------------------------------------+
//| Calcolo SL tecnico - "sotto cuspide" della candela segnale       |
//+------------------------------------------------------------------+
double CalculateStopLossPrice(ESignalDirection dir, const MqlRates &signalCandle)
{
   if(dir == SIG_LONG)
      return signalCandle.low - InpSLBuffer;
   else
      return signalCandle.high + InpSLBuffer;
}

//+------------------------------------------------------------------+
//| Calcolo lot size per rischiare InpRiskPerTradePercent del balance|
//+------------------------------------------------------------------+
double CalculateLotSize(double slDistancePrice)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskPct = InpConservativeRisk ? (InpRiskPerTradePercent * 0.5) : InpRiskPerTradePercent;

   if(g_session == SESSION_AFTERNOON)
      riskPct *= InpAfternoonRiskMultiplier;

   double riskAmount = balance * riskPct / 100.0;

   double tickValue = g_symbol.TickValue();
   double tickSize  = g_symbol.TickSize();

   if(tickValue <= 0 || tickSize <= 0 || slDistancePrice <= 0)
   {
      Print("[SIZING][ERROR] Invalid tickValue=", tickValue,
            " tickSize=", tickSize, " slDist=", slDistancePrice);
      return 0;
   }

   double lossPerLot = (slDistancePrice / tickSize) * tickValue;
   double lots = riskAmount / lossPerLot;

   double lotStep = g_symbol.LotsStep();
   double lotMin  = g_symbol.LotsMin();
   double lotMax  = g_symbol.LotsMax();

   lots = MathFloor(lots / lotStep) * lotStep;

   if(lots < lotMin)
   {
      Print("[SIZING][REJECT] Calculated lot ", lots,
            " below broker min ", lotMin,
            ". Balance=", balance, " risk%=", riskPct,
            " slDist=", slDistancePrice);
      return 0;
   }

   if(InpMaxLotSize > 0 && lots > InpMaxLotSize)
   {
      Print("[SIZING][CAP] Lot calculated=", DoubleToString(lots, 2),
            " > user max ", DoubleToString(InpMaxLotSize, 2),
            ". Capped to ", DoubleToString(InpMaxLotSize, 2),
            " (slDist=", DoubleToString(slDistancePrice, 2),
            " units, risk=", DoubleToString(riskPct, 2), "%)");
      lots = InpMaxLotSize;
   }

   if(lots > lotMax)
   {
      Print("[SIZING][CAP] Capped from ", lots, " to broker max ", lotMax);
      lots = lotMax;
   }

   return NormalizeDouble(lots, 2);
}

//+------------------------------------------------------------------+
//| ManageActivePositions                                            |
//+------------------------------------------------------------------+
void ManageActivePositions()
{
   if(g_activeTicket == 0) return;

   if(!g_position.SelectByTicket(g_activeTicket))
   {
      Print("[MANAGE] Active ticket ", g_activeTicket, " not found. Resetting.");
      ResetActivePositionTracking();
      return;
   }

   if(!g_symbol.RefreshRates()) return;

   if(!g_activePartialDone) ManagePartial();
   if(!g_activeBEMoved)     ManageBreakeven();
   if(InpTrailingEnabled && g_activeBEMoved) ManageTrailing();
}

//+------------------------------------------------------------------+
//| ManagePartial                                                    |
//+------------------------------------------------------------------+
void ManagePartial()
{
   double currentPrice = (g_activeDir == SIG_LONG) ? g_symbol.Bid() : g_symbol.Ask();
   double moveUnits = 0;

   if(g_activeDir == SIG_LONG)
      moveUnits = currentPrice - g_activeEntryPrice;
   else
      moveUnits = g_activeEntryPrice - currentPrice;

   // v3.20: soglia parziale fissa (default) o a R-multiplo dello SL reale
   double partialThreshold = InpFirstTP;
   if(InpUseRMultipleTP && g_activeSLDistance > 0)
      partialThreshold = InpPartial_R_Multiple * g_activeSLDistance;

   if(moveUnits < partialThreshold) return;

   double volumeToClose = g_activeInitialVolume * InpPartialPercent / 100.0;
   double lotStep = g_symbol.LotsStep();
   volumeToClose = MathFloor(volumeToClose / lotStep) * lotStep;
   volumeToClose = NormalizeDouble(volumeToClose, 2);

   if(volumeToClose < g_symbol.LotsMin())
   {
      if(InpVerboseMode)
         Print("[PARTIAL][SKIP] Volume ", volumeToClose, " below min. Marking as done.");
      g_activePartialDone = true;
      return;
   }

   if(g_trade.PositionClosePartial(g_activeTicket, volumeToClose))
   {
      Print("[PARTIAL][OK] Closed ", DoubleToString(volumeToClose, 2),
            " lots at +", DoubleToString(moveUnits, 2), " units");
      g_activePartialDone = true;
   }
   else
   {
      Print("[PARTIAL][ERROR] retcode=", g_trade.ResultRetcode(),
            " desc=", g_trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| ManageBreakeven                                                  |
//+------------------------------------------------------------------+
void ManageBreakeven()
{
   double currentPrice = (g_activeDir == SIG_LONG) ? g_symbol.Bid() : g_symbol.Ask();
   double moveUnits = 0;

   if(g_activeDir == SIG_LONG)
      moveUnits = currentPrice - g_activeEntryPrice;
   else
      moveUnits = g_activeEntryPrice - currentPrice;

   // v3.20: attivazione BE fissa (default) o a R-multiplo dello SL reale
   double beThreshold = InpBreakEven;
   if(InpUseRBasedActivation && g_activeSLDistance > 0)
      beThreshold = InpBreakEven_R * g_activeSLDistance;

   if(moveUnits < beThreshold) return;

   double newSL = 0;
   if(g_activeDir == SIG_LONG)
      newSL = g_activeEntryPrice + InpBE_Offset;
   else
      newSL = g_activeEntryPrice - InpBE_Offset;

   newSL = NormalizeDouble(newSL, g_symbol.Digits());
   double currentTP = g_position.TakeProfit();
   double currentSL = g_position.StopLoss();

   if(g_activeDir == SIG_LONG && newSL <= currentSL)
   {
      g_activeBEMoved = true;
      return;
   }
   if(g_activeDir == SIG_SHORT && newSL >= currentSL)
   {
      g_activeBEMoved = true;
      return;
   }

   if(g_trade.PositionModify(g_activeTicket, newSL, currentTP))
   {
      Print("[BE][OK] SL -> breakeven+", DoubleToString(InpBE_Offset, 2),
            " units at ", DoubleToString(newSL, g_symbol.Digits()));
      g_activeBEMoved = true;
   }
   else
   {
      Print("[BE][ERROR] retcode=", g_trade.ResultRetcode(),
            " desc=", g_trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| GetTrailingDistance - distanza trailing dinamica ATR(D1)         |
//| Handle persistente (PROP - Protezione 5).                        |
//+------------------------------------------------------------------+
double GetTrailingDistance()
{
   if(g_handleATRD1Trail == INVALID_HANDLE) return InpTrailingMinDistance;

   double atr[];
   ArraySetAsSeries(atr, true);
   double atrValue = 0;
   if(CopyBuffer(g_handleATRD1Trail, 0, 1, 1, atr) > 0)
      atrValue = atr[0];

   if(atrValue <= 0) return InpTrailingMinDistance;

   double trailDist = atrValue * InpTrailingATRMultiplier;

   if(trailDist < InpTrailingMinDistance) trailDist = InpTrailingMinDistance;
   if(trailDist > InpTrailingMaxDistance) trailDist = InpTrailingMaxDistance;

   return trailDist;
}

//+------------------------------------------------------------------+
//| ManageTrailing - aggiorna SL trailing basato su ATR              |
//+------------------------------------------------------------------+
void ManageTrailing()
{
   double currentPrice = (g_activeDir == SIG_LONG) ? g_symbol.Bid() : g_symbol.Ask();
   double moveUnits = 0;

   if(g_activeDir == SIG_LONG)
      moveUnits = currentPrice - g_activeEntryPrice;
   else
      moveUnits = g_activeEntryPrice - currentPrice;

   // v3.20: attivazione trailing fissa (default) o a R-multiplo dello SL reale
   double trailActivation = InpTrailingActivationProfit;
   if(InpUseRBasedActivation && g_activeSLDistance > 0)
      trailActivation = InpTrailingActivation_R * g_activeSLDistance;

   if(moveUnits < trailActivation) return;

   if(moveUnits <= g_activeMaxFavorable) return;
   g_activeMaxFavorable = moveUnits;

   double trailDist = GetTrailingDistance();

   double newSL = 0;
   if(g_activeDir == SIG_LONG)
      newSL = currentPrice - trailDist;
   else
      newSL = currentPrice + trailDist;

   newSL = NormalizeDouble(newSL, g_symbol.Digits());
   double currentTP = g_position.TakeProfit();
   double currentSL = g_position.StopLoss();

   bool shouldUpdate = false;
   if(g_activeDir == SIG_LONG  && newSL > currentSL) shouldUpdate = true;
   if(g_activeDir == SIG_SHORT && newSL < currentSL) shouldUpdate = true;

   if(!shouldUpdate) return;

   long stopLevel = g_symbol.StopsLevel();
   double stopLevelPrice = stopLevel * g_symbol.Point();
   if(g_activeDir == SIG_LONG && (currentPrice - newSL) < stopLevelPrice)
      return;
   if(g_activeDir == SIG_SHORT && (newSL - currentPrice) < stopLevelPrice)
      return;

   if(g_trade.PositionModify(g_activeTicket, newSL, currentTP))
   {
      g_activeTrailingSL = newSL;
      Print("[TRAIL][OK] SL -> ", DoubleToString(newSL, g_symbol.Digits()),
            " (move=", DoubleToString(moveUnits, 2),
            " trailDist=", DoubleToString(trailDist, 2), ")");
   }
   else
   {
      Print("[TRAIL][ERROR] retcode=", g_trade.ResultRetcode(),
            " desc=", g_trade.ResultRetcodeDescription());
   }
}

//+------------------------------------------------------------------+
//| ResetActivePositionTracking                                      |
//+------------------------------------------------------------------+
void ResetActivePositionTracking()
{
   g_activeTicket        = 0;
   g_activeInitialVolume = 0;
   g_activeEntryPrice    = 0;
   g_activePartialDone   = false;
   g_activeBEMoved       = false;
   g_activeDir           = SIG_NONE;
   g_activeMaxFavorable  = 0;
   g_activeTrailingSL    = 0;
   g_activeSLDistance    = 0;   // v3.20
   g_activePositionId    = 0;   // v3.20
}

int CountMyPositions()
{
   int count = 0;
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(!g_position.SelectByIndex(i)) continue;
      if(g_position.Magic() != MAGIC_DAX_EA) continue;
      if(g_position.Symbol() != _Symbol) continue;
      count++;
   }
   return count;
}

void CloseAllMyPositions(string reason)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(!g_position.SelectByIndex(i)) continue;
      if(g_position.Magic() != MAGIC_DAX_EA) continue;
      if(g_position.Symbol() != _Symbol) continue;
      g_trade.PositionClose(g_position.Ticket());
      Print("[CLOSE] Ticket=", g_position.Ticket(), " reason=", reason);
   }
}

//+------------------------------------------------------------------+
//| HEDGING HOOKS (disabled)                                        |
//+------------------------------------------------------------------+
bool HedgingConditionsMet()
{
   return false;
}

bool ReleaseHedge(int whichSide)
{
   return false;
}

//+------------------------------------------------------------------+
//| TIME & STATE TRANSITIONS                                         |
//+------------------------------------------------------------------+
void UpdateStateByTime()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int minutesNow      = dt.hour * 60 + dt.min;
   int morningStart    = InpMorningStartHour    * 60 + InpMorningStartMin;
   int morningEnd      = InpMorningEndHour      * 60;
   int afternoonStart  = InpAfternoonStartHour  * 60 + InpAfternoonStartMin;
   int eod             = InpEODHour             * 60 + InpEODMin;

   // ========== EOD (priorita' massima) ==========
   if(minutesNow >= eod)
   {
      if(g_state != STATE_EOD)
      {
         g_state = STATE_EOD;
         Print("[STATE] EOD reached");
      }
      return;
   }

   // PROP - Protezione 3: se in halt SL consecutivi, non riarmare nuove sessioni
   if(IsConsecutiveSLHalt())
      return;

   // ========== MORNING SESSION ==========
   if(g_state == STATE_IDLE && g_session == SESSION_NONE &&
      minutesNow >= morningStart - 15 && minutesNow < morningStart)
   {
      g_state   = STATE_PREOPEN;
      g_session = SESSION_MORNING;
      Print("[STATE] PREOPEN (morning)");
   }

   if(g_state == STATE_PREOPEN && g_session == SESSION_MORNING && minutesNow >= morningStart)
   {
      ResetORBState();
      g_state = STATE_ORB_BUILDING;
      Print("[STATE] ORB_BUILDING (morning, TF=", EnumToString(InpORBTimeframe),
            ", candles=", InpORBCandlesCount, ")");
   }

   if(g_session == SESSION_MORNING && minutesNow >= morningEnd &&
      (g_state == STATE_WAIT_TRIGGER || g_state == STATE_ORB_BUILDING))
   {
      g_state   = STATE_IDLE;
      g_session = SESSION_NONE;
      ResetORBState();
      Print("[STATE] Morning session ended. Waiting for afternoon.");
   }

   // ========== AFTERNOON SESSION (default OFF) ==========
   if(InpTradeAfternoon)
   {
      if(g_state == STATE_IDLE && g_session == SESSION_NONE &&
         minutesNow >= afternoonStart - 15 && minutesNow < afternoonStart)
      {
         g_state   = STATE_PREOPEN;
         g_session = SESSION_AFTERNOON;
         Print("[STATE] PREOPEN (afternoon)");
      }

      if(g_state == STATE_PREOPEN && g_session == SESSION_AFTERNOON && minutesNow >= afternoonStart)
      {
         ResetORBState();
         g_state = STATE_ORB_BUILDING;
         Print("[STATE] ORB_BUILDING (afternoon, TF=", EnumToString(InpORBTimeframeAfternoon),
               ", candles=", InpORBCandlesCountAfternoon, ")");
      }
   }
}

//+------------------------------------------------------------------+
//| CheckDailyReset - resetta contatori e g_dayStartEquity           |
//+------------------------------------------------------------------+
void CheckDailyReset()
{
   MqlDateTime dtNow, dtStart;
   TimeToStruct(TimeCurrent(), dtNow);
   TimeToStruct(g_dayStart,   dtStart);

   if(dtNow.day != dtStart.day)
   {
      g_dayStart        = TimeCurrent();
      g_dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      g_dayStartEquity  = AccountInfoDouble(ACCOUNT_EQUITY);  // PROP - Protezione 1: reset equity giornaliera
      g_tradesToday     = 0;
      g_orbReady        = false;
      g_orbHigh         = 0;
      g_orbLow          = 0;
      g_lastSignalBar   = 0;
      g_state           = STATE_IDLE;
      g_session         = SESSION_NONE;

      // PROP - Protezione 3: l'halt DAILY si resetta a inizio giornata.
      // L'halt CROSSDAY e g_consecutiveSL NON si resettano qui (cross-day).
      g_dailySLHalt     = false;

      Print("[NEW DAY] Counters reset. dayStartEquity=", DoubleToString(g_dayStartEquity, 2),
            " | SL-streak=", g_consecutiveSL,
            " | crossdayHalt=", (g_crossdayHalt ? "ON" : "off"));
   }
}

//+------------------------------------------------------------------+
//| DailyLimitsOK - fallback su balance + max trade/giorno           |
//| (il driver primario del daily loss e' CheckEquityDailyStop)      |
//+------------------------------------------------------------------+
bool DailyLimitsOK()
{
   if(g_tradesToday >= InpMaxTradesPerDay) return false;

   // Fallback su balance (il driver primario e' l'equity, Protezione 1)
   if(g_dayStartBalance > 0)
   {
      double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
      double dayLossPct = (g_dayStartBalance - currentBalance) / g_dayStartBalance * 100.0;
      if(dayLossPct >= InpMaxDailyLossPercent) return false;
   }

   return true;
}

bool IsNewSignalCandle()
{
   datetime currentBar = iTime(_Symbol, GetCurrentORBTimeframe(), 0);
   if(currentBar != g_lastSignalBar)
   {
      g_lastSignalBar = currentBar;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| DAILY BIAS (v1.2)                                                |
//+------------------------------------------------------------------+
string DailyBiasName(EDailyBias b)
{
   switch(b)
   {
      case BIAS_BULL:    return "BULL";
      case BIAS_BEAR:    return "BEAR";
      case BIAS_NEUTRAL: return "NEUTRAL";
   }
   return "NONE";
}

//+------------------------------------------------------------------+
//| EvaluateDailyBias                                                |
//+------------------------------------------------------------------+
void EvaluateDailyBias()
{
   datetime nowTs = TimeCurrent();
   MqlDateTime dt;
   TimeToStruct(nowTs, dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   datetime today = StructToTime(dt);

   if(g_dailyBiasDay == today && g_dailyBias != BIAS_NONE)
      return;

   MqlRates d1[];
   ArraySetAsSeries(d1, true);
   if(CopyRates(_Symbol, PERIOD_D1, 1, 1, d1) <= 0)
   {
      // PROP - fail-safe conservativo: se non leggo la D1 di ieri NON assumo
      // NEUTRAL (permissivo). Lascio BIAS_NONE e non marco il giorno cosi'
      // verra' ritentato; il filtro bias con BIAS_NONE e' gestito a valle.
      Print("[BIAS][WARN] CopyRates D1 failed (err=", GetLastError(),
            ") -> bias non calcolato (ritento al prossimo PREOPEN)");
      return;
   }

   double dOpen  = d1[0].open;
   double dClose = d1[0].close;
   double bodyAbs = MathAbs(dClose - dOpen);
   double bodyPct = (dOpen > 0) ? (bodyAbs / dOpen * 100.0) : 0;

   string ts = TimeToString(d1[0].time, TIME_DATE);
   int dg = g_symbol.Digits();

   if(bodyPct < InpDailyBiasNeutralBodyPct)
   {
      g_dailyBias = BIAS_NEUTRAL;
      Print("[BIAS] D1 (", ts, ") small body: ",
            DoubleToString(bodyAbs, dg), " (", DoubleToString(bodyPct, 3),
            "%) < threshold ", DoubleToString(InpDailyBiasNeutralBodyPct, 2),
            "% -> NEUTRAL (entrambe direzioni)");
   }
   else if(dClose > dOpen)
   {
      g_dailyBias = BIAS_BULL;
      Print("[BIAS] D1 (", ts, ") bullish -> BULL (solo LONG)");
   }
   else
   {
      g_dailyBias = BIAS_BEAR;
      Print("[BIAS] D1 (", ts, ") bearish -> BEAR (solo SHORT)");
   }

   g_dailyBiasDay = today;
}

//+------------------------------------------------------------------+
//| DailyBiasFilterPass                                              |
//| PROP - fail-safe: con bias attivo ma NON ancora calcolato        |
//| (BIAS_NONE) NON operare (conservativo).                          |
//+------------------------------------------------------------------+
bool DailyBiasFilterPass(ESignalDirection dir)
{
   if(!InpDailyBiasEnabled) return true;
   if(dir == SIG_NONE)      return true;

   // PROP - conservativo: bias non calcolato -> blocca
   if(g_dailyBias == BIAS_NONE)
   {
      if(InpVerboseMode) Print("[BIAS] non calcolato -> blocco conservativo");
      return false;
   }

   if(g_dailyBias == BIAS_NEUTRAL) return true;

   if(g_dailyBias == BIAS_BULL  && dir == SIG_LONG)  return true;
   if(g_dailyBias == BIAS_BEAR  && dir == SIG_SHORT) return true;

   return false;
}

//+------------------------------------------------------------------+
//| LOGGING / JOURNAL (v1.0)                                         |
//+------------------------------------------------------------------+
string JournalFileName()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   return StringFormat("%s_%s_%04d%02d%02d.csv",
                       InpJournalPrefix, _Symbol, dt.year, dt.mon, dt.day);
}

bool OpenJournal()
{
   string fname = JournalFileName();

   bool exists = FileIsExist(fname);

   g_journalHandle = FileOpen(fname, FILE_READ|FILE_WRITE|FILE_TXT|FILE_ANSI|FILE_SHARE_READ);
   if(g_journalHandle == INVALID_HANDLE)
   {
      Print("[JOURNAL][ERROR] FileOpen failed for '", fname, "'. err=", GetLastError());
      return false;
   }

   FileSeek(g_journalHandle, 0, SEEK_END);

   if(!exists || FileTell(g_journalHandle) == 0)
      JournalWriteHeader();

   Print("[JOURNAL] Opened: ", fname, " (tester=", g_isTester, ")");
   return true;
}

void CloseJournal()
{
   if(g_journalHandle != INVALID_HANDLE)
   {
      FileClose(g_journalHandle);
      g_journalHandle = INVALID_HANDLE;
      Print("[JOURNAL] Closed.");
   }
}

void JournalWriteHeader()
{
   if(g_journalHandle == INVALID_HANDLE) return;

   string header = "timestamp,event,ticket,session,direction,"
                   "price,sl,tp,lot,sl_distance,profit,close_reason,"
                   "ma200,orb_high,orb_low,candle_range,vol_ratio,"
                   "htf_close,htf_ma,spx_close,spx_ma,"
                   "day_of_week,minutes_since_session_start,daily_bias";
   FileWriteString(g_journalHandle, header + "\n");
   FileFlush(g_journalHandle);
}

struct JournalContext
{
   double ma200;
   double orbHigh;
   double orbLow;
   double candleRange;
   double volRatio;
   double htfClose;
   double htfMA;
   double spxClose;
   double spxMA;
   int    minutesSinceSessionStart;
};

void FillJournalContext(JournalContext &ctx)
{
   ctx.ma200       = GetMA200Value(1);
   ctx.orbHigh     = g_orbHigh;
   ctx.orbLow      = g_orbLow;

   MqlRates rates[];
   ArraySetAsSeries(rates, true);
   if(CopyRates(_Symbol, GetCurrentORBTimeframe(), 1, 1, rates) > 0)
      ctx.candleRange = rates[0].high - rates[0].low;
   else
      ctx.candleRange = 0;

   ctx.volRatio    = ComputeVolumeRatioLastCandle();

   ctx.htfClose = 0; ctx.htfMA = 0;
   if(CopyRates(_Symbol, InpHTFTrendTF, 1, 1, rates) > 0)
      ctx.htfClose = rates[0].close;
   int htfH = iMA(_Symbol, InpHTFTrendTF, InpHTFMAPeriod, 0, InpHTFMAMethod, PRICE_CLOSE);
   if(htfH != INVALID_HANDLE)
   {
      double buf[];
      ArraySetAsSeries(buf, true);
      if(CopyBuffer(htfH, 0, 1, 1, buf) > 0) ctx.htfMA = buf[0];
      IndicatorRelease(htfH);
   }

   ctx.spxClose = 0; ctx.spxMA = 0;
   if(SymbolSelect(InpSPXSymbol, true))
   {
      MqlRates spxR[];
      ArraySetAsSeries(spxR, true);
      if(CopyRates(InpSPXSymbol, InpSPXTrendTF, 1, 1, spxR) > 0)
         ctx.spxClose = spxR[0].close;
      int spxH = iMA(InpSPXSymbol, InpSPXTrendTF, InpSPXMAPeriod, 0, InpSPXMAMethod, PRICE_CLOSE);
      if(spxH != INVALID_HANDLE)
      {
         double buf[];
         ArraySetAsSeries(buf, true);
         if(CopyBuffer(spxH, 0, 1, 1, buf) > 0) ctx.spxMA = buf[0];
         IndicatorRelease(spxH);
      }
   }

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int minutesNow = dt.hour * 60 + dt.min;
   if(g_session == SESSION_MORNING)
      ctx.minutesSinceSessionStart = minutesNow - (InpMorningStartHour * 60 + InpMorningStartMin);
   else if(g_session == SESSION_AFTERNOON)
      ctx.minutesSinceSessionStart = minutesNow - (InpAfternoonStartHour * 60 + InpAfternoonStartMin);
   else
      ctx.minutesSinceSessionStart = -1;
}

string SessionName(ESessionType s)
{
   if(s == SESSION_MORNING)   return "morning";
   if(s == SESSION_AFTERNOON) return "afternoon";
   return "none";
}

string DirName(ESignalDirection d)
{
   if(d == SIG_LONG)  return "LONG";
   if(d == SIG_SHORT) return "SHORT";
   return "NONE";
}

void JournalWriteOpen(ESignalDirection dir)
{
   if(g_journalHandle == INVALID_HANDLE) return;
   if(g_activeTicket == 0) return;

   JournalContext ctx;
   FillJournalContext(ctx);

   double slDistance = 0;
   if(g_position.SelectByTicket(g_activeTicket))
      slDistance = MathAbs(g_position.PriceOpen() - g_position.StopLoss());

   double slVal = (g_position.SelectByTicket(g_activeTicket) ? g_position.StopLoss()   : 0);
   double tpVal = (g_position.SelectByTicket(g_activeTicket) ? g_position.TakeProfit() : 0);

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);

   string row = StringFormat(
      "%04d-%02d-%02d %02d:%02d:%02d,OPEN,%I64u,%s,%s,"
      "%.5f,%.5f,%.5f,%.2f,%.2f,,,"
      "%.5f,%.5f,%.5f,%.2f,%.2f,"
      "%.5f,%.5f,%.5f,%.5f,"
      "%d,%d,%s",
      dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec,
      g_activeTicket, SessionName(g_session), DirName(dir),
      g_activeEntryPrice, slVal, tpVal,
      g_activeInitialVolume,
      slDistance,
      ctx.ma200, ctx.orbHigh, ctx.orbLow, ctx.candleRange, ctx.volRatio,
      ctx.htfClose, ctx.htfMA, ctx.spxClose, ctx.spxMA,
      dt.day_of_week, ctx.minutesSinceSessionStart, DailyBiasName(g_dailyBias)
   );

   FileWriteString(g_journalHandle, row + "\n");
   FileFlush(g_journalHandle);
}

void JournalWriteClose(ulong dealTicket)
{
   if(g_journalHandle == INVALID_HANDLE) return;
   if(!HistoryDealSelect(dealTicket)) return;

   long   posTicket  = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
   double dealPrice  = HistoryDealGetDouble(dealTicket, DEAL_PRICE);
   double dealVolume = HistoryDealGetDouble(dealTicket, DEAL_VOLUME);
   double dealProfit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                     + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                     + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
   long   dealReason = HistoryDealGetInteger(dealTicket, DEAL_REASON);
   datetime dealTime = (datetime)HistoryDealGetInteger(dealTicket, DEAL_TIME);

   string reasonStr = "UNKNOWN";
   switch(dealReason)
   {
      case DEAL_REASON_CLIENT:   reasonStr = "MANUAL";  break;
      case DEAL_REASON_EXPERT:   reasonStr = "EA";      break;
      case DEAL_REASON_SL:       reasonStr = "SL";      break;
      case DEAL_REASON_TP:       reasonStr = "TP";      break;
      case DEAL_REASON_SO:       reasonStr = "STOPOUT"; break;
   }

   MqlDateTime dt;
   TimeToStruct(dealTime, dt);

   string row = StringFormat(
      "%04d-%02d-%02d %02d:%02d:%02d,CLOSE,%I64d,%s,%s,"
      "%.5f,,,%.2f,,%.2f,%s,"
      ",,,,,"
      ",,,,"
      ",,",
      dt.year, dt.mon, dt.day, dt.hour, dt.min, dt.sec,
      posTicket, SessionName(g_session), DirName(g_activeDir),
      dealPrice, dealVolume, dealProfit, reasonStr
   );

   FileWriteString(g_journalHandle, row + "\n");
   FileFlush(g_journalHandle);
}

//+------------------------------------------------------------------+
//| LogTrade (v1.0)                                                  |
//+------------------------------------------------------------------+
void LogTrade(ESignalDirection dir)
{
   if(!InpLogToFile) return;
   Print("[JOURNAL] Trade logged: ", EnumToString(dir),
         " ticket=", g_activeTicket,
         " entry=", DoubleToString(g_activeEntryPrice, g_symbol.Digits()));
   JournalWriteOpen(dir);
}

//+------------------------------------------------------------------+
//| END OF FILE                                                      |
//+------------------------------------------------------------------+
