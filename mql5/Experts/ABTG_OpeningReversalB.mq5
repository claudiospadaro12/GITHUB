//+------------------------------------------------------------------+
//|                                   ABTG_OpeningReversalB.mq5       |
//|                                                                  |
//|  OPENING REVERSAL - MODEL B - MT5 - TUTTO-IN-UNO                 |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  ATTRIBUZIONE (obbligatoria, MPL 2.0):                           |
//|    Motore Opening Reversal Model B da alfredhastings_wk          |
//|    (TradingView), licenza MPL 2.0. Portato in MQL5, gestione e   |
//|    prop-hardening propri.                                        |
//|    Sorgente: OpeningReversalModelB_alfredhastings-MPL2           |
//|              _tva07f1256dc36_2026-08-28.pine                     |
//|    Mozilla Public License 2.0: https://mozilla.org/MPL/2.0/      |
//|                                                                  |
//|  COS'E' - un FADE del drive d'apertura, a TRE STADI di conferma. |
//|    Il drive dell'apertura US "fallisce" quando arriva a un       |
//|    livello anziano e lo RIFIUTA. Il motore misura il fallimento  |
//|    con due SCORING (evidenza di fallimento + candela di segnale),|
//|    poi pretende un FOLLOW-THROUGH del reversal, poi entra a STOP |
//|    sul PULLBACK (non sulla rottura). NON e' il momentum: e' il   |
//|    ritorno dentro dopo il rigetto.                               |
//|                                                                  |
//|  LA MACCHINA A SCORING (portata FEDELMENTE dal sorgente Pine)    |
//|    1. KEY-LEVELS anziani: max/min di IERI (RTH), estremo         |
//|       overnight, apertura di OGGI, chiusura di ieri (pdc),       |
//|       estremo dei primi InpFirst6Min minuti di seduta. Cinque    |
//|       livelli per lato, valutati TUTTI.                          |
//|    2. FAILURE-EVIDENCE SCORE >= InpFailScoreMin: somma di        |
//|       evidenze di rigetto del drive al livello (vedi              |
//|       BullFailureScore_Calc / BearFailureScore_Calc: 6           |
//|       componenti dal Pine f_bullFailureScore / f_bearFailureScore|
//|    3. SIGNAL-BAR SCORE >= InpSignalScoreMin: la candela di        |
//|       segnale conferma il rigetto (vedi SellSignalScore_Calc /   |
//|       BuySignalScore_Calc: 5 componenti dal Pine                 |
//|       f_sellSignalScore / f_buySignalScore).                     |
//|    4. FOLLOW-THROUGH >= InpFollowThroughPct: la barra successiva  |
//|       (entro InpFTBarsWindow) conferma la continuazione del      |
//|       reversal (corpo pieno nella direzione, o rottura           |
//|       dell'estremo di segnale).                                  |
//|    5. PULLBACK e INGRESSO a STOP: dopo il follow-through, si      |
//|       aspetta un pullback poco profondo (<= InpPBMaxDepthPct del |
//|       movimento) entro InpPBMaxBars barre; l'ingresso e' un      |
//|       ordine STOP oltre l'estremo della barra di pullback. SL    |
//|       reale oltre l'estremo del reversal + PAVIMENTO             |
//|       InpMinStopPts. TP a InpTP_R x R.                           |
//|                                                                  |
//|  STATO A MACCHINA (0=Idle,1=segnale/attesa FT,2=FT/attesa PB).   |
//|    Come nel Pine, i tre stadi possono avanzare NELLA STESSA      |
//|    barra (cascata 0->1->2), perche' i blocchi sono sequenziali   |
//|    e lo stato cambia subito. Qui si replica lo stesso ordine.    |
//|                                                                  |
//|  DUE LATI OBBLIGATORI (regola di casa 25/08): InpSide 0/1/2      |
//|    (0=solo long, 1=solo short, 2=entrambi, default 2). Ogni lato |
//|    si MISURA separato.                                           |
//|                                                                  |
//|  PROP-HARDENING (proprio, non del sorgente)                      |
//|    - Il Pine usava LOTTO FISSO: qui SIZING A RISCHIO (LotByRisk),|
//|      InpRiskPercent 0.65% di casa.                               |
//|    - Il Pine aveva il TICK 0.25 HARDCODED (NQ): qui si usa il    |
//|      tick VERO del simbolo (SYMBOL_TRADE_TICK_SIZE) e _Point,    |
//|      MAI valori hardcoded. Le conversioni in punti indice usano  |
//|      InpMT5PerPuntoIndice (US: 100 punti MT5 = 1 punto indice).  |
//|    - Il Pine non aveva PAVIMENTO SL: qui InpMinStopPts (R109),   |
//|      MAI zero -> OnInit RIFIUTA se il pavimento e' 0. Un fade    |
//|      entra CONTRO un drive: il pavimento e' load-bearing.        |
//|    - STOP LOSS VERO AL BROKER, allegato all'ordine STOP.         |
//|    - Una posizione per magic. NIENTE martingala/griglia/         |
//|      recovery/averaging/virtual-stop. Ingresso SINGOLO.          |
//|    - CAP GIORNALIERO (InpMaxTradesPerDay, default 2) sui trade   |
//|      ESEGUITI (fill), piu' conservativo del Pine che contava i   |
//|      piazzamenti.                                                |
//|    - FLAT OBBLIGATORIO a fine seduta (ora server): mai overnight.|
//|    - EXPORT PER-TRADE CSV + OnTester + AUTOTEST in avvio.        |
//|                                                                  |
//|  FUSO ORARIO - CRITICO. RTH cash US 09:30-16:00 ET. Su BCM il    |
//|    server e' IT-1h; l'apertura US = 15:30 IT = 14:30 SERVER.     |
//|    RTH su ora SERVER = 14:30 -> 21:00 (server = ET+5). Overnight |
//|    Pine 18:00-09:30 ET = 23:00 -> 14:30 SERVER. Tutti gli orari  |
//|    sono INPUT con default in ora server, cosi' il motore si puo' |
//|    spostare in una fascia diversa (es. pomeridiana) SENZA        |
//|    toccare il codice.                                            |
//|                                                                  |
//|  NOTA CORRELAZIONE (non e' codice): questo motore entra alla     |
//|    campanella US, dove GIA' operano la sedia viva 770202 (Dow    |
//|    Apertura long) e PREOPEN_RETEST. La correlazione va MISURATA  |
//|    prima di ogni deploy; gli orari-input permettono di spostare  |
//|    la fascia operativa senza modifiche di codice.                |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA (equivalente a calc_on_every_tick=   |
//|    false del Pine): il segnale si valuta sulla barra appena      |
//|    chiusa (shift 1), l'ordine STOP parte all'apertura della      |
//|    barra 0. Niente look-ahead, niente repaint.                   |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro dentro le stringhe (regola   |
//|  di casa). NON compilato ne' testato da chi ha scritto il file:  |
//|  compilare in MetaEditor (F7) e validare nel tester.             |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - Opening Reversal Model B (port da alfredhastings_wk, MPL 2.0)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== SCORING (le tre soglie del motore) ==="
input int    InpFailScoreMin      = 3;     // Min Failure Evidence Count (Pine i_minFailure=3)
input int    InpSignalScoreMin    = 4;     // Min Signal Bar Score (Pine i_minSignalBar=4)
input double InpFollowThroughPct  = 60.0;  // Follow-through: corpo min % del range (Pine i_ftBodyPct=60)
input int    InpFTBarsWindow       = 2;    // Finestra follow-through, barre dopo il segnale (Pine i_ftBarsWindow=2)
input int    InpPBMaxBars          = 3;    // Max barre di attesa del pullback (Pine i_pbMaxBars=3)
input double InpPBMaxDepthPct      = 50.0; // Max profondita' pullback, % del movimento FT (Pine i_pbMaxDepth=50)
input int    InpSignalMaxBar       = 15;   // Il segnale deve comparire prima della barra # (Pine i_signalMaxBar=15)

input group "=== KEY LEVELS ==="
input int    InpLevelZonePts       = 200;  // Zona attorno al livello, in PUNTI MT5 (Pine 2.0 pti indice = 200 MT5)
input int    InpFirst6Min          = 6;    // Barre della finestra 'primi minuti di seduta' (Pine 6)

input group "=== INGRESSO / USCITA ==="
input int    InpEntryOffsetPts     = 0;    // Offset ordine STOP oltre la barra, in PUNTI MT5 (0 = 1 tick del simbolo; Pine usava 1 tick 0.25 NQ)
input double InpTP_R               = 2.0;  // Take profit in multipli di R (Pine target = 2.0 R)
input int    InpMaxRiskIdxPts      = 20;   // Cap del rischio in PUNTI INDICE (Pine risk<=20; 0 = nessun cap)

input group "=== STOP LOSS (ordine vero al broker; pavimento R109) ==="
input int    InpMinStopPts         = 500;  // PAVIMENTO SL OBBLIGATORIO in PUNTI MT5 (5 pti indice). MAI 0.

input group "=== SESSIONE (ORA DEL FEED, lato SERVER; US = 14:30) ==="
input int    InpSessionHour        = 14;   // Ora apertura RTH (NY 09:30 ET -> server, apertura 14:30)
input int    InpSessionMin         = 30;   // Minuto apertura RTH (server 14:30)
input int    InpCloseHour          = 21;   // Ora FLAT/chiusura RTH (NY 16:00 ET -> server 21:00)
input int    InpCloseMin           = 0;    // Minuto FLAT/chiusura RTH (server 21:00)
input int    InpOvernightStartHour = 23;   // Ora inizio overnight (NY 18:00 ET -> server 23:00)
input int    InpOvernightStartMin  = 0;    // Minuto inizio overnight (server 23:00)

input group "=== Rischio e cap ==="
input double InpRiskPercent        = 0.65; // Rischio per trade, % dell'equity (default di casa; MAI il lotto fisso del Pine)
input int    InpMaxTradesPerDay    = 2;    // Max ingressi ESEGUITI al giorno (Pine i_maxTrades=2; 0 = illimitato)
input int    InpSide               = 2;    // Lato: 0=solo LONG, 1=solo SHORT, 2=ENTRAMBI (regola due lati)

input group "=== Conversione punti indice ==="
input double InpMT5PerPuntoIndice  = 100;  // Punti MT5 (_Point) per 1 punto indice (US: 100)

input group "=== Generali ==="
input string InpComment            = "ORB"; // Commento sugli ordini
input long   InpMagic              = 769400; // Numero magico (blocco 7694xx: verificato VERGINE nel repo)
input int    InpMaxSpread          = 0;      // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose            = true;   // Messaggi nel log
input bool   InpAutoTest           = true;   // Stampa le righe [ORB][AUTOTEST] in avvio (si leggono ESEGUENDO)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;

datetime gLastBar = 0;
int      gDay = -1;

//--- la MACCHINA A STATI del Model B (persistente tra le barre;
//    azzerata a inizio seduta e al flat, come newRTHDay nel Pine).
int      gState        = 0;   // 0=Idle, 1=segnale/attesa FT, 2=FT/attesa PB
int      gStateDir     = 0;   // -1=short in costruzione, +1=long, 0=nessuno
int      gStateBars    = 0;   // barre trascorse nello stadio corrente
double   gStateRevHigh = 0.0; // estremo alto del reversal (la barra di segnale, aggiornato al FT)
double   gStateRevLow  = 0.0; // estremo basso del reversal
double   gStateFTHigh  = 0.0; // estremo alto post follow-through
double   gStateFTLow   = 0.0; // estremo basso post follow-through
double   gStateLevel   = 0.0; // il livello anziano che ha respinto il drive

long     gLastSessionStamp = -1;  // marcatore di seduta: cambia -> nuova seduta -> reset
int      gTradesToday      = 0;   // ingressi ESEGUITI oggi (cap giornaliero)
ulong    gUltimoTicketContato = 0;

int      gFlatLogGiorno = -1;

//--- contatori in colonna nell'OPTFRAME (OnTester)
int      gAutotestFalliti = -1;   // -1 = non eseguito
int      gFlatGiorni      = 0;
int      gFlatChiusure    = 0;

//--- DIAGNOSTICA (solo misura): un contatore per stadio/blocco.
long gCntOnNewBar    = 0;   // chiamate totali a OnNewBar
long gCntGestione    = 0;   // return: c'era posizione aperta
long gCntNoContesto  = 0;   // return: contesto non pronto / barra non RTH
long gCntState1      = 0;   // segnali rilevati (0 -> 1)
long gCntState2      = 0;   // follow-through confermati (1 -> 2)
long gCntFTTimeout   = 0;   // follow-through scaduto (torna a 0)
long gCntPBTimeout   = 0;   // pullback scaduto (torna a 0)
long gCntEntryTrigger= 0;   // condizione di pullback+ingresso soddisfatta
long gCntShortPlaced = 0;   // ordini SELL STOP piazzati
long gCntLongPlaced  = 0;   // ordini BUY STOP piazzati
long gCntRiskReject  = 0;   // ingressi scartati (geometria/rischio/broker)

//--- peggior giornata in % (per la prop)
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;
int    gDayEqStamp     = -1;

void Log(string m){ if(InpVerbose) Print("[ORB] ", m); }

bool AllowLong()  { return(InpSide==0 || InpSide==2); }
bool AllowShort() { return(InpSide==1 || InpSide==2); }

//==================================================================
//
//   NUCLEO PURO - funzioni che non leggono niente dal terminale.
//   E' questa la parte che l'AUTOTEST interroga a tavolino. Ogni
//   funzione di scoring e' la traduzione 1:1 di un blocco del Pine.
//
//==================================================================

//+------------------------------------------------------------------+
//| Minuti dall'inizio del giorno.                                    |
//+------------------------------------------------------------------+
int MinutiDelGiorno_Calc(const int ora,const int minuto)
  {
   return(ora*60 + minuto);
  }

//+------------------------------------------------------------------+
//| Un istante (minuti del giorno) e' dentro [start,end)? Gestisce    |
//| anche le finestre che attraversano la mezzanotte (start>end):     |
//| la usiamo per la SEDUTA (start<=end) e per l'OVERNIGHT (start>end)|
//+------------------------------------------------------------------+
bool InFinestra_Calc(const int minutiOra,const int minutiStart,const int minutiEnd)
  {
   if(minutiStart <= minutiEnd) return(minutiOra>=minutiStart && minutiOra<minutiEnd);
   return(minutiOra>=minutiStart || minutiOra<minutiEnd);
  }

//+------------------------------------------------------------------+
//| Marcatore di SEDUTA (la seduta RTH non attraversa la mezzanotte). |
//| Due barre stanno nella stessa seduta se hanno lo stesso marcatore.|
//+------------------------------------------------------------------+
long SessionStamp_Calc(const datetime t,const int startMinuti)
  {
   long s = (long)t - (long)startMinuti*60;
   if(s<0) s=0;
   return(s/86400);
  }

//+------------------------------------------------------------------+
//| FLAT DI FINE SEDUTA - vero quando l'ora corrente ha raggiunto o   |
//| superato l'ora di chiusura RTH (confronto in minuti).             |
//+------------------------------------------------------------------+
bool DopoOrarioFlat_Calc(const int ora,const int minuto,
                         const int flatOra,const int flatMinuto)
  {
   return(ora*60+minuto >= flatOra*60+flatMinuto);
  }

//+------------------------------------------------------------------+
//| FAILURE EVIDENCE - lato SELL (drive RIALZISTA che fallisce alla   |
//| resistenza 'level'). Traduzione 1:1 di f_bullFailureScore del     |
//| Pine: sei componenti, ciascuna vale +1.                           |
//|   1. barra precedente rialzista ma chiusa SOTTO il livello        |
//|   2. barra precedente ha bucato il livello, la corrente richiude  |
//|      sotto                                                        |
//|   3. la corrente e' una barra ribassista a corpo dominante (>=50%)|
//|   4. nuovo minimo (low < low[1])                                  |
//|   5. massimo piu' basso (high < high[1])                          |
//|   6. doppio test: due barre (shift 2 e corrente) col massimo in   |
//|      zona e chiusura sotto il livello                             |
//+------------------------------------------------------------------+
int BullFailureScore_Calc(const bool hasLevel,const double level,const double zone,
                          const double c_o,const double c_h,const double c_l,const double c_c,
                          const double p1_o,const double p1_h,const double p1_l,const double p1_c,
                          const double p2_h,const double p2_c)
  {
   int score=0;
   if(!hasLevel) return(0);
   if(p1_c > p1_o && p1_c < level) score++;                              // 1
   if(p1_h >= level && c_c < level) score++;                            // 2
   double bRange = c_h - c_l;
   double bBody  = MathAbs(c_c - c_o);
   if(c_c < c_o && bRange > 0 && (bBody/bRange) >= 0.5) score++;         // 3
   if(c_l < p1_l) score++;                                              // 4
   if(c_h < p1_h) score++;                                              // 5
   if(p2_h >= (level-zone) && p2_h <= (level+zone) && p2_c < level &&
      c_h >= (level-zone) && c_c < level) score++;                      // 6
   return(score);
  }

//+------------------------------------------------------------------+
//| FAILURE EVIDENCE - lato BUY (drive RIBASSISTA che fallisce al     |
//| supporto 'level'). Traduzione 1:1 di f_bearFailureScore.          |
//+------------------------------------------------------------------+
int BearFailureScore_Calc(const bool hasLevel,const double level,const double zone,
                          const double c_o,const double c_h,const double c_l,const double c_c,
                          const double p1_o,const double p1_h,const double p1_l,const double p1_c,
                          const double p2_l,const double p2_c)
  {
   int score=0;
   if(!hasLevel) return(0);
   if(p1_c < p1_o && p1_c > level) score++;                              // 1
   if(p1_l <= level && c_c > level) score++;                            // 2
   double bRange = c_h - c_l;
   double bBody  = MathAbs(c_c - c_o);
   if(c_c > c_o && bRange > 0 && (bBody/bRange) >= 0.5) score++;         // 3
   if(c_h > p1_h) score++;                                              // 4
   if(c_l > p1_l) score++;                                              // 5
   if(p2_l >= (level-zone) && p2_l <= (level+zone) && p2_c > level &&
      c_l <= (level+zone) && c_c > level) score++;                      // 6
   return(score);
  }

//+------------------------------------------------------------------+
//| SIGNAL BAR SCORE - lato SELL. Traduzione 1:1 di f_sellSignalScore.|
//| avgRange = media a 10 barre di (high-low). Se <0 (meno di 10      |
//| barre) la 5a componente non vale (come 'na' nel Pine).            |
//|   1. chiusura sotto il punto medio della barra                    |
//|   2. coda superiore >= corpo (rigetto in alto)                    |
//|   3. chiusura sotto il minimo precedente                          |
//|   4. il massimo precedente era in zona del livello                |
//|   5. barra abbastanza ampia (range >= 0.5 * media)                |
//+------------------------------------------------------------------+
int SellSignalScore_Calc(const bool hasLevel,const double level,const double zone,
                         const double c_o,const double c_h,const double c_l,const double c_c,
                         const double p1_h,const double p1_l,const double avgRange)
  {
   int score=0;
   double barMid = (c_h + c_l)/2.0;
   double bBody  = MathAbs(c_c - c_o);
   double bRange = c_h - c_l;
   double upperTail = c_h - MathMax(c_o,c_c);
   if(c_c < barMid) score++;                                            // 1
   if(bBody > 0 && upperTail >= bBody) score++;                         // 2
   if(c_c < p1_l) score++;                                              // 3: chiude sotto il min precedente
   if(hasLevel && p1_h >= (level-zone)) score++;                        // 4: max precedente in zona
   if(avgRange >= 0 && bRange >= avgRange*0.5) score++;                 // 5
   return(score);
  }

//+------------------------------------------------------------------+
//| SIGNAL BAR SCORE - lato BUY. Traduzione 1:1 di f_buySignalScore.  |
//+------------------------------------------------------------------+
int BuySignalScore_Calc(const bool hasLevel,const double level,const double zone,
                        const double c_o,const double c_h,const double c_l,const double c_c,
                        const double p1_h,const double p1_l,const double avgRange)
  {
   int score=0;
   double barMid = (c_h + c_l)/2.0;
   double bBody  = MathAbs(c_c - c_o);
   double bRange = c_h - c_l;
   double lowerTail = MathMin(c_o,c_c) - c_l;
   if(c_c > barMid) score++;                                            // 1
   if(bBody > 0 && lowerTail >= bBody) score++;                         // 2
   if(c_c > p1_h) score++;                                              // 3: chiude sopra il max precedente
   if(hasLevel && p1_l <= (level+zone)) score++;                        // 4: min precedente in zona
   if(avgRange >= 0 && bRange >= avgRange*0.5) score++;                 // 5
   return(score);
  }

//+------------------------------------------------------------------+
//| VALIDITA' SETUP - lato SELL. Traduzione di f_isSellValid: livello |
//| presente, dentro la finestra di segnale, massimo in zona,         |
//| chiusura tornata SOTTO il livello, i due score alle soglie, e il  |
//| rischio grezzo (range + 2 offset) sotto il cap.                   |
//+------------------------------------------------------------------+
bool SellValid_Calc(const bool hasLevel,const bool inSigWin,
                    const double level,const double zone,
                    const int failScore,const int sigScore,
                    const int minFail,const int minSig,
                    const double c_h,const double c_l,const double c_c,
                    const double offset,const double riskCapPrice)
  {
   if(!hasLevel || !inSigWin) return(false);
   bool inZone     = (c_h >= (level-zone) && c_h <= (level+zone));
   bool closedBack = (c_c < level);
   if(!(inZone && closedBack)) return(false);
   if(failScore < minFail || sigScore < minSig) return(false);
   double entry = c_l - offset;
   double stop  = c_h + offset;
   double risk  = stop - entry;
   if(risk <= 0) return(false);
   if(riskCapPrice > 0 && risk > riskCapPrice) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| VALIDITA' SETUP - lato BUY. Traduzione di f_isBuyValid.           |
//+------------------------------------------------------------------+
bool BuyValid_Calc(const bool hasLevel,const bool inSigWin,
                   const double level,const double zone,
                   const int failScore,const int sigScore,
                   const int minFail,const int minSig,
                   const double c_h,const double c_l,const double c_c,
                   const double offset,const double riskCapPrice)
  {
   if(!hasLevel || !inSigWin) return(false);
   bool inZone     = (c_l >= (level-zone) && c_l <= (level+zone));
   bool closedBack = (c_c > level);
   if(!(inZone && closedBack)) return(false);
   if(failScore < minFail || sigScore < minSig) return(false);
   double entry = c_h + offset;
   double stop  = c_l - offset;
   double risk  = entry - stop;
   if(risk <= 0) return(false);
   if(riskCapPrice > 0 && risk > riskCapPrice) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| FOLLOW-THROUGH: la barra ha corpo pieno nella direzione. Per lo   |
//| short = barra ribassista con corpo >= pct% del range; per il long |
//| = barra rialzista. Traduzione di isBearFT / isBullFT del Pine.    |
//+------------------------------------------------------------------+
bool FollowThroughBar_Calc(const bool isBear,
                           const double o,const double h,const double l,const double c,
                           const double pct)
  {
   double r = h - l;
   double b = MathAbs(c - o);
   if(r <= 0) return(false);
   if(isBear) return(c < o && (b/r) >= (pct/100.0));
   return(c > o && (b/r) >= (pct/100.0));
  }

//+------------------------------------------------------------------+
//| PULLBACK poco profondo: pbDepth <= maxPct% del movimento FT.      |
//| Traduzione di pbOK del Pine.                                      |
//+------------------------------------------------------------------+
bool PullbackOk_Calc(const double ftMove,const double pbDepth,const double maxPct)
  {
   if(ftMove <= 0) return(false);
   return((pbDepth/ftMove) <= (maxPct/100.0));
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (R109). Se lo stop e' piu' vicino del        |
//| pavimento, si ALLARGA al pavimento; non si salta il trade e non   |
//| si lascia lo stop a zero.                                         |
//+------------------------------------------------------------------+
double SlFloor_Calc(const bool isLong,const double entry,
                    const double slGrezzo,const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R>=pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Conversione: distanza di PREZZO -> PUNTI INDICE.                  |
//+------------------------------------------------------------------+
double PrezzoInPuntiIndice_Calc(const double distPrezzo,
                                const double mt5PerIdx,const double point)
  {
   double den = mt5PerIdx*point;
   if(den<=0) return(0);
   return(distPrezzo/den);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpFailScoreMin<1 || InpFailScoreMin>6)
     { Print("ERRORE: InpFailScoreMin deve stare tra 1 e 6 (sei componenti di failure)."); return(INIT_FAILED); }
   if(InpSignalScoreMin<1 || InpSignalScoreMin>5)
     { Print("ERRORE: InpSignalScoreMin deve stare tra 1 e 5 (cinque componenti di signal bar)."); return(INIT_FAILED); }
   if(InpFollowThroughPct<=0 || InpFollowThroughPct>100)
     { Print("ERRORE: InpFollowThroughPct deve stare tra 0 (escluso) e 100."); return(INIT_FAILED); }
   if(InpFTBarsWindow<1)
     { Print("ERRORE: InpFTBarsWindow deve essere >= 1."); return(INIT_FAILED); }
   if(InpPBMaxBars<1)
     { Print("ERRORE: InpPBMaxBars deve essere >= 1."); return(INIT_FAILED); }
   if(InpPBMaxDepthPct<=0 || InpPBMaxDepthPct>100)
     { Print("ERRORE: InpPBMaxDepthPct deve stare tra 0 (escluso) e 100."); return(INIT_FAILED); }
   if(InpSignalMaxBar<1)
     { Print("ERRORE: InpSignalMaxBar deve essere >= 1."); return(INIT_FAILED); }
   if(InpLevelZonePts<0)
     { Print("ERRORE: InpLevelZonePts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpFirst6Min<1)
     { Print("ERRORE: InpFirst6Min deve essere >= 1."); return(INIT_FAILED); }
   if(InpEntryOffsetPts<0)
     { Print("ERRORE: InpEntryOffsetPts non puo' essere negativo (0 = 1 tick del simbolo)."); return(INIT_FAILED); }
   if(InpTP_R<=0)
     { Print("ERRORE: InpTP_R deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxRiskIdxPts<0)
     { Print("ERRORE: InpMaxRiskIdxPts non puo' essere negativo (0 = nessun cap)."); return(INIT_FAILED); }
   //--- R109: il PAVIMENTO SL NON puo' essere zero. E' load-bearing per un
   //    fade (si entra CONTRO un drive): OnInit rifiuta se e' 0.
   if(InpMinStopPts<=0)
     { Print("ERRORE: PAVIMENTO SL a zero (R109): InpMinStopPts deve essere > 0. Un fade senza stop vero non si testa."); return(INIT_FAILED); }
   if(InpSessionHour<0 || InpSessionHour>23 || InpSessionMin<0 || InpSessionMin>59)
     { Print("ERRORE: ora/minuto di apertura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpCloseHour<0 || InpCloseHour>23 || InpCloseMin<0 || InpCloseMin>59)
     { Print("ERRORE: ora/minuto di chiusura seduta fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(InpOvernightStartHour<0 || InpOvernightStartHour>23 || InpOvernightStartMin<0 || InpOvernightStartMin>59)
     { Print("ERRORE: ora/minuto di inizio overnight fuori range (0-23 / 0-59)."); return(INIT_FAILED); }
   if(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin) >= MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin))
     { Print("ERRORE: la seduta RTH NON attraversa la mezzanotte: apertura deve precedere la chiusura."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpMaxTradesPerDay<0)
     { Print("ERRORE: InpMaxTradesPerDay non puo' essere negativo (0 = illimitato)."); return(INIT_FAILED); }
   if(InpMT5PerPuntoIndice<=0)
     { Print("ERRORE: InpMT5PerPuntoIndice deve essere > 0."); return(INIT_FAILED); }
   if(InpSide<0 || InpSide>2)
     { Print("ERRORE: InpSide deve essere 0 (long), 1 (short) o 2 (entrambi)."); return(INIT_FAILED); }

   ResetStateMachine();
   gLastSessionStamp = -1;

   if(InpAutoTest) AutoTestReversal();

   Log(StringFormat("avviato su %s %s. scoring[fail>=%d, sig>=%d, FT>=%.0f%%/%dbarre, PB<=%.0f%%/%dbarre, sigMaxBar %d], zona %d pti MT5, offset %s, TP %.2fR, capRischio %d pti idx, pavimento SL %d pti, rischio %.2f%%, cap %d/gg, lato %d, seduta %02d:%02d-%02d:%02d, overnight da %02d:%02d, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpFailScoreMin, InpSignalScoreMin, InpFollowThroughPct, InpFTBarsWindow,
       InpPBMaxDepthPct, InpPBMaxBars, InpSignalMaxBar,
       InpLevelZonePts, (InpEntryOffsetPts>0?IntegerToString(InpEntryOffsetPts)+" pti":"1 tick"),
       InpTP_R, InpMaxRiskIdxPts, InpMinStopPts, InpRiskPercent, InpMaxTradesPerDay, InpSide,
       InpSessionHour, InpSessionMin, InpCloseHour, InpCloseMin,
       InpOvernightStartHour, InpOvernightStartMin, InpMagic));
   Log("FLAT DI FINE SEDUTA ACCESO per costruzione: motore INTRADAY di reversal, niente overnight. Ingresso SINGOLO a STOP sul pullback: nessuna aggiunta/mediazione/griglia su posizione aperta.");
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- nessun handle indicatore da rilasciare: livelli, score e VWAP
   //    (qui non serve) sono ricostruiti da CopyRates, senza stato
   //    persistente sul terminale.
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();
   AggiornaContatoreTrade();               // il cap conta gli ingressi ESEGUITI

   if(CountPositions()>0) CancelPendings(); // una posizione per magic: via i pending residui

   if(FlatFineSedutaCheck()) return;        // fine seduta: chiudo tutto, cancello pending, azzero lo stato

   if(!IsNewBar()) return;                  // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(TimeCurrent(), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

void ResetStateMachine()
  {
   gState=0; gStateDir=0; gStateBars=0;
   gStateRevHigh=0.0; gStateRevLow=0.0;
   gStateFTHigh=0.0;  gStateFTLow=0.0;
   gStateLevel=0.0;
  }

//==================================================================
//  IL CONTESTO - livelli anziani, barre di scoring, sessione. Letto
//  dai dati e SENZA stato persistente (sopravvive a un riavvio).
//==================================================================
struct Contesto
  {
   //--- barra valutata (shift 1) e le due precedenti (shift 2, 3)
   double  o,h,l,c;
   double  p1o,p1h,p1l,p1c;
   double  p2h,p2l,p2c;
   double  avgRange;          // media a 10 barre di (high-low); <0 = insufficiente
   //--- sessione
   long    stamp;
   int     barsSinceOpen;     // 1 = prima barra RTH (come nel Pine)
   bool    inSignalWindow;    // barsSinceOpen entro InpSignalMaxBar
   double  todayOpen;
   //--- livelli anziani + flag di presenza (na del Pine)
   double  pdh,pdl,pdc;   bool hasPrev;
   double  onh,onl;       bool hasON;
   double  first6High,first6Low; bool f6Usable;
  };

//+------------------------------------------------------------------+
//| Media a 10 barre di (high-low) terminante a 'start' (inclusa).    |
//| <0 se non ci sono abbastanza barre (equivalente a 'na' nel Pine). |
//+------------------------------------------------------------------+
double AvgRange_Read(const MqlRates &r[],const int copied,const int start,const int n)
  {
   if(start+n>copied) return(-1.0);
   double s=0;
   for(int i=start;i<start+n;i++) s += (r[i].high - r[i].low);
   return(s/n);
  }

//+------------------------------------------------------------------+
//| Ricostruisce il CONTESTO per la barra a shiftEval. Ritorna false  |
//| se la barra non e' RTH o mancano dati.                            |
//+------------------------------------------------------------------+
bool LeggiContesto(const int shiftEval,const MqlRates &r[],const int copied,Contesto &c)
  {
   if(shiftEval<1 || copied<=shiftEval+3) return(false);
   if(!BarraInSeduta(r[shiftEval].time)) return(false);

   int  startMin = MinutiStartSeduta();
   c.stamp = SessionStamp_Calc(r[shiftEval].time, startMin);

   //--- prima barra della seduta: il piu' VECCHIO shift contiguo con lo
   //    stesso stamp (barsSinceOpen==1 sulla prima barra RTH, come Pine).
   int firstShift = shiftEval;
   for(int i=shiftEval+1;i<copied;i++)
     {
      if(!BarraInSeduta(r[i].time)) break;
      if(SessionStamp_Calc(r[i].time,startMin)!=c.stamp) break;
      firstShift = i;
     }
   c.barsSinceOpen = firstShift - shiftEval + 1;
   c.inSignalWindow = (c.barsSinceOpen>=1 && c.barsSinceOpen<=InpSignalMaxBar);
   c.todayOpen = r[firstShift].open;

   //--- barre di scoring (corrente + due precedenti)
   c.o=r[shiftEval].open;   c.h=r[shiftEval].high;   c.l=r[shiftEval].low;   c.c=r[shiftEval].close;
   c.p1o=r[shiftEval+1].open; c.p1h=r[shiftEval+1].high; c.p1l=r[shiftEval+1].low; c.p1c=r[shiftEval+1].close;
   c.p2h=r[shiftEval+2].high; c.p2l=r[shiftEval+2].low; c.p2c=r[shiftEval+2].close;
   c.avgRange = AvgRange_Read(r,copied,shiftEval,10);

   //--- first6: massimo/minimo delle prime InpFirst6Min barre di seduta.
   //    NIENTE look-ahead: si scandiscono solo shift >= shiftEval (barre
   //    non piu' recenti della valutata). Il livello e' USABILE solo dopo
   //    la finestra (barsSinceOpen > InpFirst6Min), come nel Pine.
   c.first6High=-DBL_MAX; c.first6Low=DBL_MAX;
   for(int i=firstShift; i>=firstShift-(InpFirst6Min-1) && i>=shiftEval; i--)
     {
      if(i<0) break;
      if(r[i].high>c.first6High) c.first6High=r[i].high;
      if(r[i].low <c.first6Low ) c.first6Low =r[i].low;
     }
   c.f6Usable = (c.barsSinceOpen>InpFirst6Min);
   if(c.first6High==-DBL_MAX){ c.first6High=0; c.first6Low=0; c.f6Usable=false; }

   //--- overnight e sessione precedente: si risale da firstShift+1.
   c.hasON=false; c.onh=0; c.onl=0;
   c.hasPrev=false; c.pdh=0; c.pdl=0; c.pdc=0;
   double onH=-DBL_MAX,onL=DBL_MAX; bool anyON=false;
   int prevNewest=-1;
   int onStartMin = MinutiDelGiorno_Calc(InpOvernightStartHour,InpOvernightStartMin);
   for(int j=firstShift+1;j<copied;j++)
     {
      if(BarraInSeduta(r[j].time)){ prevNewest=j; break; }   // raggiunta la seduta precedente
      MqlDateTime dt; TimeToStruct(r[j].time,dt);
      int mm = MinutiDelGiorno_Calc(dt.hour,dt.min);
      if(InFinestra_Calc(mm, onStartMin, startMin))          // overnight = [onStart, sessOpen)
        {
         anyON=true;
         if(r[j].high>onH) onH=r[j].high;
         if(r[j].low <onL) onL=r[j].low;
        }
     }
   if(anyON){ c.hasON=true; c.onh=onH; c.onl=onL; }

   if(prevNewest>=0)
     {
      long pstamp = SessionStamp_Calc(r[prevNewest].time,startMin);
      c.pdc = r[prevNewest].close;    // chiusura RTH = close dell'ultima barra della seduta precedente
      double ph=-DBL_MAX, pl=DBL_MAX;
      for(int k=prevNewest;k<copied;k++)
        {
         if(!BarraInSeduta(r[k].time)) break;
         if(SessionStamp_Calc(r[k].time,startMin)!=pstamp) break;
         if(r[k].high>ph) ph=r[k].high;
         if(r[k].low <pl) pl=r[k].low;
        }
      if(ph>-DBL_MAX){ c.hasPrev=true; c.pdh=ph; c.pdl=pl; }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova: valuta la barra APPENA CHIUSA (shift  |
//| 1) e fa avanzare la MACCHINA A STATI di UNO stadio. I tre blocchi |
//| (0->1, 1->2, 2->ingresso) girano in sequenza sulla STESSA barra,  |
//| identici al Pine (la cascata puo' attraversare piu' stadi).       |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   gCntOnNewBar++;

   MqlRates r[]; ArraySetAsSeries(r,true);
   int need = 4*BarrePerGiornoPieno() + 30;
   if(need>30000) need=30000;
   int copied = CopyRates(_Symbol, gTF, 0, need, r);
   if(copied<12){ gCntNoContesto++; return; }

   Contesto c;
   bool ok = LeggiContesto(1, r, copied, c);

   //--- nuova seduta -> reset macchina/contatore/pending (come newRTHDay)
   if(ok && c.stamp!=gLastSessionStamp)
     {
      ResetStateMachine();
      gTradesToday=0;
      CancelPendings();
      gLastSessionStamp=c.stamp;
     }

   //--- posizione aperta: la si lascia ai suoi SL/TP veri e al flat.
   if(CountPositions()>0){ gCntGestione++; CancelPendings(); return; }

   if(!ok){ gCntNoContesto++; return; }

   double zone   = InpLevelZonePts*_Point;
   double off    = EntryOffset();
   double cap    = RiskCapPrice();

   //--- ================ SCORING SU TUTTI I LIVELLI ================
   //    Come nel Pine: si valutano TUTTI i cinque livelli per lato.
   bool vSellPDH=false,vSellONH=false,vSellPDC=false,vSellOpen=false,vSellF6=false;
   bool vBuyPDL =false,vBuyONL =false,vBuyPDC =false,vBuyOpen =false,vBuyF6 =false;

   //--- lato SELL (drive rialzista che fallisce a resistenza)
   {
    int f,s;
    f=BullFailureScore_Calc(c.hasPrev,c.pdh,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2h,c.p2c);
    s=SellSignalScore_Calc (c.hasPrev,c.pdh,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vSellPDH=SellValid_Calc(c.hasPrev,c.inSignalWindow,c.pdh,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BullFailureScore_Calc(c.hasON,c.onh,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2h,c.p2c);
    s=SellSignalScore_Calc (c.hasON,c.onh,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vSellONH=SellValid_Calc(c.hasON,c.inSignalWindow,c.onh,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BullFailureScore_Calc(c.hasPrev,c.pdc,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2h,c.p2c);
    s=SellSignalScore_Calc (c.hasPrev,c.pdc,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vSellPDC=SellValid_Calc(c.hasPrev,c.inSignalWindow,c.pdc,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BullFailureScore_Calc(true,c.todayOpen,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2h,c.p2c);
    s=SellSignalScore_Calc (true,c.todayOpen,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vSellOpen=SellValid_Calc(true,c.inSignalWindow,c.todayOpen,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BullFailureScore_Calc(c.f6Usable,c.first6High,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2h,c.p2c);
    s=SellSignalScore_Calc (c.f6Usable,c.first6High,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vSellF6 =SellValid_Calc(c.f6Usable,c.inSignalWindow,c.first6High,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);
   }

   //--- lato BUY (drive ribassista che fallisce a supporto)
   {
    int f,s;
    f=BearFailureScore_Calc(c.hasPrev,c.pdl,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2l,c.p2c);
    s=BuySignalScore_Calc  (c.hasPrev,c.pdl,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vBuyPDL=BuyValid_Calc  (c.hasPrev,c.inSignalWindow,c.pdl,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BearFailureScore_Calc(c.hasON,c.onl,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2l,c.p2c);
    s=BuySignalScore_Calc  (c.hasON,c.onl,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vBuyONL=BuyValid_Calc  (c.hasON,c.inSignalWindow,c.onl,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BearFailureScore_Calc(c.hasPrev,c.pdc,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2l,c.p2c);
    s=BuySignalScore_Calc  (c.hasPrev,c.pdc,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vBuyPDC=BuyValid_Calc  (c.hasPrev,c.inSignalWindow,c.pdc,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BearFailureScore_Calc(true,c.todayOpen,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2l,c.p2c);
    s=BuySignalScore_Calc  (true,c.todayOpen,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vBuyOpen=BuyValid_Calc (true,c.inSignalWindow,c.todayOpen,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);

    f=BearFailureScore_Calc(c.f6Usable,c.first6Low,zone,c.o,c.h,c.l,c.c,c.p1o,c.p1h,c.p1l,c.p1c,c.p2l,c.p2c);
    s=BuySignalScore_Calc  (c.f6Usable,c.first6Low,zone,c.o,c.h,c.l,c.c,c.p1h,c.p1l,c.avgRange);
    vBuyF6 =BuyValid_Calc  (c.f6Usable,c.inSignalWindow,c.first6Low,zone,f,s,InpFailScoreMin,InpSignalScoreMin,c.h,c.l,c.c,off,cap);
   }

   bool anySell = (vSellPDH||vSellONH||vSellPDC||vSellOpen||vSellF6);
   bool anyBuy  = (vBuyPDL ||vBuyONL ||vBuyPDC ||vBuyOpen ||vBuyF6);

   //--- ================ STATO 0 -> 1: segnale rilevato ================
   bool capOk = (InpMaxTradesPerDay<=0 || gTradesToday<InpMaxTradesPerDay);
   if(gState==0 && capOk && c.inSignalWindow)
     {
      if(anySell && AllowShort())
        {
         gState=1; gStateDir=-1; gStateBars=0;
         gStateRevHigh=c.h; gStateRevLow=c.l;
         gStateLevel = vSellPDH? c.pdh : vSellONH? c.onh : vSellPDC? c.pdc : vSellOpen? c.todayOpen : c.first6High;
         gCntState1++;
        }
      else if(anyBuy && AllowLong())
        {
         gState=1; gStateDir=1; gStateBars=0;
         gStateRevHigh=c.h; gStateRevLow=c.l;
         gStateLevel = vBuyPDL? c.pdl : vBuyONL? c.onl : vBuyPDC? c.pdc : vBuyOpen? c.todayOpen : c.first6Low;
         gCntState1++;
        }
     }

   //--- ================ STATO 1 -> 2: follow-through ================
   if(gState==1)
     {
      gStateBars++;
      if(gStateDir==-1)
        {
         bool ftBar   = FollowThroughBar_Calc(true, c.o,c.h,c.l,c.c, InpFollowThroughPct);
         bool brokeLow= (c.c < gStateRevLow);
         if(ftBar || brokeLow)
           {
            gState=2; gStateBars=0;
            gStateFTLow  = c.l;
            gStateFTHigh = MathMax(gStateRevHigh, c.p1h);
            gStateRevHigh= MathMax(gStateRevHigh, c.p1h);
            gCntState2++;
           }
         else if(gStateBars>InpFTBarsWindow){ gState=0; gStateDir=0; gCntFTTimeout++; }
        }
      else if(gStateDir==1)
        {
         bool ftBar    = FollowThroughBar_Calc(false, c.o,c.h,c.l,c.c, InpFollowThroughPct);
         bool brokeHigh= (c.c > gStateRevHigh);
         if(ftBar || brokeHigh)
           {
            gState=2; gStateBars=0;
            gStateFTHigh = c.h;
            gStateFTLow  = MathMin(gStateRevLow, c.p1l);
            gStateRevLow = MathMin(gStateRevLow, c.p1l);
            gCntState2++;
           }
         else if(gStateBars>InpFTBarsWindow){ gState=0; gStateDir=0; gCntFTTimeout++; }
        }
     }

   //--- ================ STATO 2 -> INGRESSO: pullback ================
   if(gState==2)
     {
      gStateBars++;
      if(gStateDir==-1)
        {
         double barMid = (c.h + c.l)/2.0;
         bool   isPB   = (c.c > c.o || c.c > barMid);
         double ftMove = gStateRevHigh - gStateFTLow;
         double pbDepth= c.h - gStateFTLow;
         if(isPB && PullbackOk_Calc(ftMove,pbDepth,InpPBMaxDepthPct))
           {
            double entryP = c.l - off;
            double stopP  = gStateRevHigh + off;
            double risk   = stopP - entryP;
            if(risk>0 && (cap<=0 || risk<=cap))
              {
               gCntEntryTrigger++;
               PiazzaStop(false, entryP, stopP);
               gState=0; gStateDir=0;
              }
           }
         if(gState==2 && gStateBars>InpPBMaxBars){ gState=0; gStateDir=0; gCntPBTimeout++; }
        }
      else if(gStateDir==1)
        {
         double barMid = (c.h + c.l)/2.0;
         bool   isPB   = (c.c < c.o || c.c < barMid);
         double ftMove = gStateFTHigh - gStateRevLow;
         double pbDepth= gStateFTHigh - c.l;
         if(isPB && PullbackOk_Calc(ftMove,pbDepth,InpPBMaxDepthPct))
           {
            double entryP = c.h + off;
            double stopP  = gStateRevLow - off;
            double risk   = entryP - stopP;
            if(risk>0 && (cap<=0 || risk<=cap))
              {
               gCntEntryTrigger++;
               PiazzaStop(true, entryP, stopP);
               gState=0; gStateDir=0;
              }
           }
         if(gState==2 && gStateBars>InpPBMaxBars){ gState=0; gStateDir=0; gCntPBTimeout++; }
        }
     }
  }

//==================================================================
//  INGRESSO - ordine STOP con SL e TP veri al broker
//==================================================================
//+------------------------------------------------------------------+
//| Piazza un ordine STOP (BuyStop/SellStop) al prezzo di ingresso    |
//| sul pullback. SL = estremo del reversal (buffer offset), poi      |
//| SEMPRE dal PAVIMENTO (mai a zero, mai dentro lo stops-level). TP  |
//| a InpTP_R x R sulla distanza FINALE. Lotto da LotByRisk.          |
//+------------------------------------------------------------------+
bool PiazzaStop(const bool isLong,const double entryP,const double stopRaw)
  {
   if(!SpreadOK()){ gCntRiskReject++; Log("spread oltre il massimo: salto."); return(false); }
   double point   = _Point;
   double stopsLvl= (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double pav     = MathMax(InpMinStopPts*point, stopsLvl);
   if(pav<=0){ gCntRiskReject++; Log("pavimento SL nullo: salto (R109)."); return(false); }

   double slFinal = SlFloor_Calc(isLong, entryP, stopRaw, pav);
   double slDist  = isLong ? (entryP-slFinal) : (slFinal-entryP);
   if(slDist<=0){ gCntRiskReject++; Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   double cap = RiskCapPrice();
   if(cap>0 && slDist>cap){ gCntRiskReject++; Log("rischio oltre il cap: salto."); return(false); }

   double tp = isLong ? (entryP+InpTP_R*slDist) : (entryP-InpTP_R*slDist);

   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0){ gCntRiskReject++; return(false); }

   double eP = NormalizePrice(entryP);
   double sP = NormalizePrice(slFinal);
   double tP = NormalizePrice(tp);

   //--- un ordine STOP deve stare OLTRE il mercato di almeno stops-level;
   //    se il prezzo e' gia' passato (setup gia' andato), NON si insegue.
   if(isLong)
     { if(eP <= ask+stopsLvl){ gCntRiskReject++; Log("buy stop troppo vicino/sotto mercato: salto."); return(false); } }
   else
     { if(eP >= bid-stopsLvl){ gCntRiskReject++; Log("sell stop troppo vicino/sopra mercato: salto."); return(false); } }

   //--- TP rispetta lo stops-level (SL gia' >= pavimento >= stops-level)
   if(MathAbs(eP - tP) < stopsLvl)
     { tP = isLong ? eP+stopsLvl : eP-stopsLvl; tP = NormalizePrice(tP); }

   double lot = LotByRisk(slDist);
   if(lot<=0){ gCntRiskReject++; Log("lotto nullo: salto."); return(false); }

   CancelPendings();   // un solo pending per magic (replace, come strategy.entry per id nel Pine)

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.BuyStop (lot,eP,_Symbol,sP,tP,ORDER_TIME_GTC,0,cm)
                    : gTrade.SellStop(lot,eP,_Symbol,sP,tP,ORDER_TIME_GTC,0,cm);
   if(ok)
     {
      if(isLong) gCntLongPlaced++; else gCntShortPlaced++;
      double idxRisk = PrezzoInPuntiIndice_Calc(slDist, InpMT5PerPuntoIndice, point);
      Log(StringFormat("%s STOP @ %s SL %s TP %s lot %.2f (rischio %.1f pti idx | livello %s)",
          isLong?"BUY(reversal supporto)":"SELL(reversal resistenza)",
          DoubleToString(eP,_Digits), DoubleToString(sP,_Digits), DoubleToString(tP,_Digits),
          lot, idxRisk, DoubleToString(gStateLevel,_Digits)));
      return(true);
     }
   Log("piazzamento STOP fallito: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//+------------------------------------------------------------------+
//| Offset dell'ordine STOP oltre la barra: se InpEntryOffsetPts>0 lo |
//| si usa (in punti MT5), altrimenti 1 TICK VERO del simbolo (mai il |
//| 0.25 hardcoded del Pine). Fallback difensivo a _Point.            |
//+------------------------------------------------------------------+
double EntryOffset()
  {
   if(InpEntryOffsetPts>0) return(InpEntryOffsetPts*_Point);
   double ts = SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(ts>0) return(ts);
   return(_Point);
  }

//+------------------------------------------------------------------+
//| Cap del rischio (Pine risk<=20) in PREZZO. 0 = nessun cap.        |
//+------------------------------------------------------------------+
double RiskCapPrice()
  {
   if(InpMaxRiskIdxPts<=0) return(0);
   return(InpMaxRiskIdxPts*InpMT5PerPuntoIndice*_Point);
  }

//==================================================================
//  FLAT DI FINE SEDUTA / CAP / PEGGIOR GIORNATA
//==================================================================
bool FlatFineSedutaCheck()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(!DopoOrarioFlat_Calc(t.hour,t.min,InpCloseHour,InpCloseMin)) return(false);

   int chiuse=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(p)) chiuse++;
      else Log("flat di fine seduta: chiusura FALLITA - "+gTrade.ResultRetcodeDescription());
     }
   gFlatChiusure += chiuse;

   CancelPendings();       // niente ordini appesi overnight
   ResetStateMachine();    // niente stato che sopravvive alla seduta

   if(t.day_of_year!=gFlatLogGiorno)
     {
      gFlatLogGiorno = t.day_of_year;
      gFlatGiorni++;
      if(chiuse>0)
         Log(StringFormat("flat di fine seduta alle %02d:%02d: %d posizioni chiuse, niente overnight.",
                          InpCloseHour, InpCloseMin, chiuse));
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Il cap giornaliero conta gli ingressi ESEGUITI (fill), non i      |
//| piazzamenti (piu' conservativo del Pine).                         |
//+------------------------------------------------------------------+
void AggiornaContatoreTrade()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(tk!=gUltimoTicketContato)
        { gUltimoTicketContato=tk; gTradesToday++; }
      return;
     }
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno (%).      |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   double giornata = 100.0*(gDayMinEquity-gDayStartEquity)/gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//==================================================================
//  LETTURA DEI DATI (aiutanti di sessione)
//==================================================================
int MinutiStartSeduta(){ return(MinutiDelGiorno_Calc(InpSessionHour,InpSessionMin)); }
int MinutiEndSeduta()  { return(MinutiDelGiorno_Calc(InpCloseHour,InpCloseMin)); }

bool BarraInSeduta(const datetime t)
  {
   MqlDateTime d; TimeToStruct(t,d);
   return(InFinestra_Calc(MinutiDelGiorno_Calc(d.hour,d.min), MinutiStartSeduta(), MinutiEndSeduta()));
  }

//--- barre di un GIORNO PIENO (~24h / TF): dimensiona la copia storica.
int BarrePerGiornoPieno()
  {
   long per = PeriodSeconds(gTF); if(per<=0) per=300;
   int b = (int)(86400/per);
   return(b<10?10:b);
  }

//==================================================================
//  UTILITY
//==================================================================
double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int    dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

//--- Lotto dalla distanza dello stop. PERDITA PER LOTTO DAL BROKER
//    (OrderCalcProfit converte in valuta conto); tick value come ripiego.
double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;

   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot = -profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);

   double lot = risk/lossPerLot;
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot = MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

bool SpreadOK()
  {
   if(InpMaxSpread<=0) return(true);
   return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread);
  }

int CountPositions()
  {
   int n=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

int CountPendings()
  {
   int n=0;
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong tk=OrderGetTicket(i);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)==_Symbol && OrderGetInteger(ORDER_MAGIC)==InpMagic) n++;
     }
   return(n);
  }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong tk=OrderGetTicket(i);
      if(tk==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(tk);
     }
  }

//==================================================================
//  AUTOTEST - stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester). F7 compila e basta.
//  Verifica la MACCHINA A SCORING a tavolino, contro il sorgente.
//==================================================================
void AutoTestReversal()
  {
   int falliti=0;

   PrintFormat("[ORB][AUTOTEST] scoring[fail>=%d,sig>=%d,FT>=%.0f%%] lato %d | %s | magic %I64d",
               InpFailScoreMin,InpSignalScoreMin,InpFollowThroughPct,InpSide,_Symbol,InpMagic);

   double zone=2.0, off=0.25;

   //--- 1. BULL FAILURE (lato SELL) - caso costruito per fare 6/6.
   //    level 100. current o100.5 h101 l97.5 c98 ; p1 o98 h101.5 l98 c99 ; p2 h101 c99.
   int bf=BullFailureScore_Calc(true,100.0,zone, 100.5,101.0,97.5,98.0, 98.0,101.5,98.0,99.0, 101.0,99.0);
   int bf0=BullFailureScore_Calc(false,100.0,zone, 100.5,101.0,97.5,98.0, 98.0,101.5,98.0,99.0, 101.0,99.0);
   PrintFormat("[ORB][AUTOTEST] bullFailure: pieno=%d (atteso 6) | senzaLivello=%d (atteso 0)", bf, bf0);
   if(!(bf==6 && bf0==0)) falliti++;

   //--- 2. BEAR FAILURE (lato BUY) - costruito per 6/6.
   //    level 100. current o99.5 h102.5 l99 c102 ; p1 o102 h102 l98.5 c101 ; p2 l99 c101.
   int rf=BearFailureScore_Calc(true,100.0,zone, 99.5,102.5,99.0,102.0, 102.0,102.0,98.5,101.0, 99.0,101.0);
   int rf0=BearFailureScore_Calc(false,100.0,zone, 99.5,102.5,99.0,102.0, 102.0,102.0,98.5,101.0, 99.0,101.0);
   PrintFormat("[ORB][AUTOTEST] bearFailure: pieno=%d (atteso 6) | senzaLivello=%d (atteso 0)", rf, rf0);
   if(!(rf==6 && rf0==0)) falliti++;

   //--- 3. SELL SIGNAL SCORE - costruito per 5/5. avgRange 2.
   //    current h102 l98 o99.5 c99 ; p1_high 99. (comp3 usa low[1]=99.5)
   int ss=SellSignalScore_Calc(true,100.0,zone, 99.5,102.0,98.0,99.0, 99.0,99.5, 2.0);
   PrintFormat("[ORB][AUTOTEST] sellSignal: pieno=%d (atteso 5)", ss);
   if(!(ss==5)) falliti++;

   //--- 4. BUY SIGNAL SCORE - costruito per 5/5. avgRange 2.
   //    current h102 l98 o100.5 c101 ; p1_high 100.5 p1_low 100.
   int bs=BuySignalScore_Calc(true,100.0,zone, 100.5,102.0,98.0,101.0, 100.5,100.0, 2.0);
   PrintFormat("[ORB][AUTOTEST] buySignal: pieno=%d (atteso 5)", bs);
   if(!(bs==5)) falliti++;

   //--- 5. VALIDITA' (sell/buy) - soglie e zona.
   bool vS =SellValid_Calc(true,true,100.0,zone, 6,5, 3,4, 101.0,97.5,98.0, off,0);   // ok
   bool vSf=SellValid_Calc(true,true,100.0,zone, 6,2, 3,4, 101.0,97.5,98.0, off,0);   // sig sotto soglia -> no
   bool vSw=SellValid_Calc(true,false,100.0,zone,6,5, 3,4, 101.0,97.5,98.0, off,0);   // fuori finestra -> no
   bool vB =BuyValid_Calc (true,true,100.0,zone, 6,5, 3,4, 102.0,99.5,101.0, off,0);  // ok (low 99.5 in zona, close 101>100)
   bool vBf=BuyValid_Calc (true,true,100.0,zone, 2,5, 3,4, 102.0,99.5,101.0, off,0);  // fail sotto soglia -> no
   PrintFormat("[ORB][AUTOTEST] validita': sellOk=%d(1) sellSig=%d(0) sellWin=%d(0) buyOk=%d(1) buyFail=%d(0)",
               (int)vS,(int)vSf,(int)vSw,(int)vB,(int)vBf);
   if(!(vS && !vSf && !vSw && vB && !vBf)) falliti++;

   //--- 6. FOLLOW-THROUGH (corpo >= pct del range).
   bool ftBear=FollowThroughBar_Calc(true, 100.0,100.5,97.0,97.5, 60.0);  // ribassista corpo 2.5/3.5=71% -> vero
   bool ftBearNo=FollowThroughBar_Calc(true, 100.0,101.0,99.5,100.4,60.0);// corpo piccolo -> falso? 0.4/1.5=27%
   bool ftBull=FollowThroughBar_Calc(false, 97.5,101.0,97.0,100.5,60.0);  // rialzista corpo 3/4=75% -> vero
   PrintFormat("[ORB][AUTOTEST] followThrough: bear=%d(1) bearNo=%d(0) bull=%d(1)",
               (int)ftBear,(int)ftBearNo,(int)ftBull);
   if(!(ftBear && !ftBearNo && ftBull)) falliti++;

   //--- 7. PULLBACK poco profondo (<= maxPct del movimento).
   bool pb1=PullbackOk_Calc(10.0,4.0,50.0);   // 40% <= 50 -> vero
   bool pb2=PullbackOk_Calc(10.0,6.0,50.0);   // 60% > 50 -> falso
   bool pb3=PullbackOk_Calc(0.0,1.0,50.0);    // ftMove nullo -> falso
   PrintFormat("[ORB][AUTOTEST] pullback: dentro=%d(1) troppo=%d(0) noMove=%d(0)",
               (int)pb1,(int)pb2,(int)pb3);
   if(!(pb1 && !pb2 && !pb3)) falliti++;

   //--- 8. PAVIMENTO SL (mai a zero: R109) + geometria.
   double p1=SlFloor_Calc(true ,100.0, 99.8,2.0);  // dist 0.2 < 2 -> 98.00
   double p2=SlFloor_Calc(true ,100.0, 97.0,2.0);  // gia' oltre -> 97.00
   double p3=SlFloor_Calc(false,100.0,100.2,2.0);  // short vicino -> 102.00
   PrintFormat("[ORB][AUTOTEST] pavimento SL: %.2f (98.00) %.2f (97.00) short %.2f (102.00)", p1,p2,p3);
   if(!(MathAbs(p1-98.0)<1e-6 && MathAbs(p2-97.0)<1e-6 && MathAbs(p3-102.0)<1e-6)) falliti++;

   //--- 9. SEDUTA / STAMP / FLAT / OVERNIGHT / conversione (server 14:30-21:00)
   int mS=MinutiDelGiorno_Calc(14,30), mE=MinutiDelGiorno_Calc(21,0);
   int onS=MinutiDelGiorno_Calc(23,0);
   bool se1=InFinestra_Calc(MinutiDelGiorno_Calc(14,30),mS,mE);  // apertura inclusa
   bool se2=InFinestra_Calc(MinutiDelGiorno_Calc(17, 0),mS,mE);  // dentro
   bool se3=InFinestra_Calc(MinutiDelGiorno_Calc(21, 0),mS,mE);  // chiusura esclusa
   bool se4=InFinestra_Calc(MinutiDelGiorno_Calc(14,15),mS,mE);  // prima
   bool on1=InFinestra_Calc(MinutiDelGiorno_Calc(23,30),onS,mS); // overnight (sera)
   bool on2=InFinestra_Calc(MinutiDelGiorno_Calc( 6, 0),onS,mS); // overnight (notte)
   bool on3=InFinestra_Calc(MinutiDelGiorno_Calc(16, 0),onS,mS); // fuori overnight (pomeriggio)
   bool fl1=DopoOrarioFlat_Calc(21, 0,21,0);   // esatto -> flat
   bool fl2=DopoOrarioFlat_Calc(20,59,21,0);   // prima -> no
   datetime tA=D'2026.08.25 15:00:00';
   datetime tB=D'2026.08.25 20:00:00';
   datetime tC=D'2026.08.26 15:00:00';
   bool sm1=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tB,mS));  // stessa seduta
   bool sm2=(SessionStamp_Calc(tA,mS)==SessionStamp_Calc(tC,mS));  // diverse
   double ip1=PrezzoInPuntiIndice_Calc(5.0,100.0,0.01);           // 5.0
   PrintFormat("[ORB][AUTOTEST] seduta: ap=%d(1) dentro=%d(1) fine=%d(0) pre=%d(0) | overnight sera=%d(1) notte=%d(1) pome=%d(0) | flat esatto=%d(1) prima=%d(0) | stamp same=%d(1) diff=%d(0) | conv=%.2f(5.00)",
               (int)se1,(int)se2,(int)se3,(int)se4,(int)on1,(int)on2,(int)on3,(int)fl1,(int)fl2,(int)sm1,(int)sm2,ip1);
   if(!(se1 && se2 && !se3 && !se4 && on1 && on2 && !on3 && fl1 && !fl2 && sm1 && !sm2 && MathAbs(ip1-5.0)<1e-6)) falliti++;

   Print("[ORB][AUTOTEST] esito motore: ", (falliti==0
         ? "NOVE BLOCCHI SU NOVE, la macchina a scoring ragiona come il sorgente."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   gAutotestFalliti = falliti;
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. In backtest singolo e'       //
//  inerte (gira solo in ottimizzazione).                           //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE in Common\Files: ogni riga = una posizione       |
//| CHIUSA, con prezzo d'ingresso e di uscita, per calcolare la       |
//| mediana del take in PUNTI INDICE prima di leggere qualunque PF.   |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   int nd=HistoryDealsTotal();

   long   idIn[];   double pxIn[];   long dirIn[];   string cmIn[];
   int    cIn=0;
   ArrayResize(idIn,nd); ArrayResize(pxIn,nd); ArrayResize(dirIn,nd); ArrayResize(cmIn,nd);
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      idIn[cIn]  = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      pxIn[cIn]  = HistoryDealGetDouble (tk,DEAL_PRICE);
      dirIn[cIn] = HistoryDealGetInteger(tk,DEAL_TYPE);
      cmIn[cIn]  = HistoryDealGetString (tk,DEAL_COMMENT);
      cIn++;
     }

   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","dir","volume",
             "entry_price","exit_price","take_idx_pts","net_profit","comment");

   double den = InpMT5PerPuntoIndice*_Point;
   for(int i=0;i<nd;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;

      long   posId = HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      double pxOut = HistoryDealGetDouble (tk,DEAL_PRICE);
      double net   = HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);

      double pxEntry=0; long dir=-1; string cm=""; bool trovato=false;
      for(int k=0;k<cIn;k++)
         if(idIn[k]==posId){ pxEntry=pxIn[k]; dir=dirIn[k]; cm=cmIn[k]; trovato=true; break; }

      bool isLong = (dir==DEAL_TYPE_BUY);
      double takeIdx = 0;
      if(trovato && den>0)
        {
         double mossaPrezzo = isLong ? (pxOut-pxEntry) : (pxEntry-pxOut);
         takeIdx = mossaPrezzo/den;
        }

      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(InpMagic),
                IntegerToString(posId),
                (trovato ? (isLong?"LONG":"SHORT") : "?"),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(pxEntry,_Digits),
                DoubleToString(pxOut,_Digits),
                DoubleToString(takeIdx,1),
                DoubleToString(net,2),
                cm);
     }
   FileClose(h);
  }

double OnTester()
  {
   ExportTrades();
   double stats[24];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne "va bene per una prop?"
   stats[7] = gWorstDayPct;
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);
   //--- le tre colonne di COLLAUDO (gate, non merito)
   stats[10] = (double)gAutotestFalliti;
   stats[11] = (double)gFlatGiorni;
   stats[12] = (double)gFlatChiusure;
   //--- DIAGNOSTICA per-stadio (l'ordine QUI e nell'header di
   //    OnTesterDeinit si toccano SEMPRE INSIEME).
   stats[13] = (double)gCntOnNewBar;
   stats[14] = (double)gCntGestione;
   stats[15] = (double)gCntNoContesto;
   stats[16] = (double)gCntState1;
   stats[17] = (double)gCntState2;
   stats[18] = (double)gCntFTTimeout;
   stats[19] = (double)gCntPBTimeout;
   stats[20] = (double)gCntEntryTrigger;
   stats[21] = (double)gCntShortPlaced;
   stats[22] = (double)gCntLongPlaced;
   stats[23] = (double)gCntRiskReject;

   PrintFormat("[ORB][DIAG] OnNewBar=%I64d | gestione=%I64d noContesto=%I64d | state1=%I64d state2=%I64d ftTO=%I64d pbTO=%I64d | entryTrig=%I64d shortStop=%I64d longStop=%I64d riskRej=%I64d",
               gCntOnNewBar, gCntGestione, gCntNoContesto, gCntState1, gCntState2,
               gCntFTTimeout, gCntPBTimeout, gCntEntryTrigger,
               gCntShortPlaced, gCntLongPlaced, gCntRiskReject);

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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Autotest Falliti,Flat Giorni,Flat Chiusure,OnNewBar Chiamate,Ret Gestione,Ret No Contesto,State1,State2,FT Timeout,PB Timeout,Entry Trigger,Short Stop,Long Stop,Risk Reject";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9],
                                data[10], data[11], data[12],
                                data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
