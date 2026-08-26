//+------------------------------------------------------------------+
//|                                          ABTG_FvgRetest.mq5      |
//|                                                                  |
//|  EA "FAIR VALUE GAP - RITORNO NEL VUOTO" - MT5 - TUTTO-IN-UNO    |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  DA DOVE VIENE (attribuzione obbligatoria)                       |
//|    Adattamento in casa di "KSQ Fair Value Gap EA - FVG with      |
//|    Regime Detection and Dual SL TP Mode", di Adiec7 /            |
//|    "KSQuantitative - KSQuants", MQL5 Code Base id 71467,         |
//|    pubblicato 2026-04-04, 949 righe, 53 input.                   |
//|    https://www.mql5.com/en/code/71467                            |
//|    LICENZA: nessuna licenza dichiarata ne' sulla pagina ne' nel   |
//|    sorgente -> uso interno di ricerca, attribuzione obbligatoria.|
//|    Copia del sorgente d'autore in casa:                          |
//|      backtest_pipeline/caccia_strategie/biblioteca/sorgenti/     |
//|      KsqFairValueGapEA_Adiec7-KSQuantitative_mql5code71467_2026-08-26.mq5
//|                                                                  |
//|    Le tre manopole di definizione (taglia a percentile mobile,   |
//|    eta' minima, mitigazione in %) vengono dal candidato P3 della |
//|    stessa caccia: "Order Block Volumatic FVG Strategy" di        |
//|    TagsTrading (TradingView PjH7wg3n, CC BY-NC-SA 4.0, derivato  |
//|    dichiarato da "Volumatic Fair Value Gaps" di BigBeluga).      |
//|    Attribuzione a TagsTrading e BigBeluga obbligatoria.          |
//|                                                                  |
//|    Scheda del candidato (P1, voto 9/10 - PROVA SUBITO):          |
//|      backtest_pipeline/caccia_strategie/CACCIA_SMC_OB_FVG_2026-08-26.md
//|    Tesi dell'adattamento (scostamenti dichiarati uno per uno):   |
//|      FVG_TESI.md                                                 |
//|                                                                  |
//|  PERCHE' SI CHIAMA "RETEST" E NON "REVERT"                       |
//|    Il meccanismo NON e' un ritorno alla media: si compra il      |
//|    RITORNO del prezzo dentro un vuoto lasciato da un movimento   |
//|    gia' avvenuto, NELLA DIREZIONE di quel movimento. E'          |
//|    continuazione su pullback. La parola "retest" e' quella del   |
//|    referto R42: "l'unica cosa che ha sempre pagato e' il RETEST  |
//|    - entrare sul RITORNO al livello DOPO la rottura confermata". |
//|    Un FVG e' un modo MECCANICO di definire quel livello.         |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in       |
//|  forward finche' un round a TICK REALI non lo promuove.          |
//|                                                                  |
//|  LA TESI IN UNA RIGA                                             |
//|    Un Fair Value Gap e' una finestra di prezzo che nessuno ha    |
//|    contrattato: tre candele in cui il mercato si e' mosso troppo |
//|    in fretta perche' ci fosse un venditore per ogni compratore.  |
//|    Quel vuoto non ha padroni, e il prezzo tende a tornarci a     |
//|    cercare gli ordini che li' non sono stati eseguiti.           |
//|                                                                  |
//|  LA DEFINIZIONE MECCANICA MISURATA QUI - UNA SOLA, DICHIARATA    |
//|    FVG RIALZISTA: tre barre CHIUSE consecutive i-2, i-1, i con   |
//|      low[i] > high[i-2].  Zona = [ high[i-2] , low[i] ].         |
//|    FVG RIBASSISTA: high[i] < low[i-2].                           |
//|      Zona = [ high[i] , low[i-2] ].                              |
//|    Nessun requisito sulla barra di mezzo (ne' corpo, ne'         |
//|    direzione, ne' volume): e' la definizione geometrica pura,    |
//|    quella dell'autore. Le varianti "la barra di mezzo dev'essere |
//|    d'impulso" e "serve displacement" NON sono implementate e     |
//|    NON sono misurate: un round misura UNA definizione (scoperta  |
//|    trasversale n.5 del dossier).                                 |
//|                                                                  |
//|  IL VUOTO DEVE ESSERE INTRADAY, NON DI SESSIONE.                 |
//|    InpSoloBarreContigue (default true) pretende che le tre barre |
//|    siano consecutive nel TEMPO. Senza, il salto di prezzo fra la |
//|    chiusura di una seduta e l'apertura della successiva verrebbe |
//|    contato come FVG: sarebbe ABTG_GapFill / ABTG_GapContinuation |
//|    con un altro nome (doppioni gia' in flotta), e i gap notturni |
//|    dominerebbero la soglia a percentile.                         |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Rilevazione, ingresso e stato dei   |
//|  gap si leggono tutti sulla barra [1] (l'ultima chiusa). La      |
//|  barra in formazione [0] NON entra in nessun calcolo: e' il      |
//|  difetto n.4 della scheda P1 (l'autore marcava il gap come       |
//|  riempito guardando la barra viva e perdeva il segnale in        |
//|  silenzio). Qui l'ordine e': rileva -> decidi -> aggiorna stato. |
//|                                                                  |
//|  PAVIMENTO DELLO STOP ATTIVO DI DEFAULT (criterio C4, lezione    |
//|  R109): InpMinSLAtr = 0,50 x ATR. Con lo stop dell'autore        |
//|  (1,5 x ATR) e' INERTE - non cambia la cella d'autore - e morde  |
//|  solo dove lo stop puo' collassare (modo STRUTT o punti fissi    |
//|  piccoli). R109 e' morto di stop senza pavimento: DD 44-68% e    |
//|  lotti tagliati da SYMBOL_VOLUME_MAX su 66 trade su 743.         |
//|                                                                  |
//|  DOVE DEVE GIRARE: INDICI (D30EUR, U30USD, NASUSD), M15 prima    |
//|  corsia. Nessun calcolo assume il forex: la distanza dello stop  |
//|  e' in PREZZO, il lotto esce da OrderCalcProfit e il ripiego e'  |
//|  tick value / tick size. Le soglie in "punti" sono PUNTI MT5     |
//|  (_Point), non punti indice: su U30USD e NASUSD 1 punto indice   |
//|  = 100 punti MT5 (misura R97).                                   |
//|                                                                  |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO      |
//|  rispetto all'ora italiana (DAX 09:00 IT = 08:00 server).        |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le    |
//|  stringhe, niente emoji (regola di casa dei .ps1, estesa qui     |
//|  perche' i log finiscono negli stessi strumenti).                |
//|  NON compilato ne' testato da chi ha scritto il file: compilare  |
//|  in MetaEditor e validare nel tester A TICK REALI.               |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - adattamento da Adiec7/KSQuantitative (MQL5 Code Base 71467)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    Il default true NON cambia niente da solo: se il Guardian non gira su
//    questo conto -- e nel Strategy Tester, dove le sue GlobalVariable non
//    esistono -- la guardia lascia passare tutto (fail-open totale). I
//    backtest restano quindi confrontabili con quelli degli altri EA.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//--- COME SI MISURA LA TAGLIA DEL GAP.
//    PERCENTILE = specifica P3: il gap deve valere almeno X% del gap piu'
//      grande delle ultime N barre. Si ritara DA SOLO fra DAX, Nasdaq e
//      EURUSD e fra un 2024 calmo e un 2025 volatile: e' l'unico modo che
//      gira uguale su indici e forex.
//    PUNTI = soglia assoluta dell'autore (InpMinGapPoints * _Point).
//      ATTENZIONE: e' il difetto n.1 della scheda P1. Su un indice dove
//      1 punto indice = 100 punti MT5, i 10 punti dell'autore valgono
//      0,1 punti indice: il filtro e' di fatto SPENTO.
enum ENUM_FVG_GAPMODE { GAP_PERCENTILE=0, GAP_PUNTI=1 };

//--- QUANDO SI ENTRA.
//    RITORNO = la tesi: si entra quando il prezzo TORNA dentro il vuoto,
//      almeno una barra DOPO che il vuoto si e' formato.
//    FORMAZIONE = si entra sulla barra che CHIUDE il gap a tre candele.
//      E' momentum di continuazione, non retest. Non e' una nostra
//      invenzione: e' quello che il codice dell'autore fa davvero
//      (vedi FVG_TESI.md par. 4.1) ed e' il braccio di ablazione
//      gratuito segnalato dal dossier (scarto S8).
enum ENUM_FVG_ENTRY { ENTRY_RITORNO=0, ENTRY_FORMAZIONE=1 };

//--- IL FILTRO DI REGIME, STACCABILE.
//    NONE = motore NUDO: e' la BASELINE del round (il dossier lo impone:
//      in casa il filtro appiccicato a un motore gia' tarato fa 0 successi
//      su 5, ROBUSTEZZA.md par. 5B). L'autore parte da BOTH.
enum ENUM_FVG_REGIME { REG_NONE=0, REG_EMA=1, REG_ADX=2, REG_BOTH=3 };

//--- COME NASCE LO STOP.
//    SL_ATR   = autore: X * ATR.
//    SL_PUNTI = autore: punti MT5 fissi.
//    SL_STRUTT= casa: oltre il bordo LONTANO del gap piu' un buffer in ATR.
//      In questo modo il pavimento NON e' decorazione: senza, lo stop puo'
//      nascere a due punti dal prezzo (R109).
enum ENUM_FVG_SLMODE { SL_ATR=0, SL_PUNTI=1, SL_STRUTT=2 };

//--- COME NASCE IL TARGET.
enum ENUM_FVG_TPMODE { TP_ATR=0, TP_PUNTI=1, TP_RR=2 };

//==================================================================
//  INPUT
//==================================================================
input group "=== MOTORE: rilevazione del vuoto ==="
input bool   InpAllowLong        = true;   // Ammetti i LONG (i lati si misurano SEPARATI)
input bool   InpAllowShort       = true;   // Ammetti gli SHORT
input ENUM_FVG_GAPMODE InpGapMode = GAP_PERCENTILE; // Taglia del gap: percentile mobile (P3) o punti (autore)
input double InpGapPctOfMax      = 10.0;   // (PERCENTILE) gap >= X% del gap MASSIMO della finestra (P3: 10)
input int    InpGapPctLookback   = 1000;   // (PERCENTILE) barre della finestra del massimo (P3: 1000)
input int    InpMinGapPts        = 10;     // (PUNTI) taglia minima del gap in punti MT5 (autore: 10)
input bool   InpSoloBarreContigue = true;  // Le 3 barre devono essere consecutive nel TEMPO (esclude i gap di sessione)
input int    InpMaxFvgTrack      = 50;     // Quanti gap vivi tenere in memoria (autore: 50)

input group "=== MOTORE: ingresso nel vuoto ==="
input ENUM_FVG_ENTRY InpEntryMode = ENTRY_RITORNO; // Ingresso: al RITORNO (tesi) o alla FORMAZIONE (codice autore)
input int    InpMinAgeBars       = 0;      // Eta' MINIMA del gap in barre (P3: 40). In RITORNO il minimo vero e' 1
input double InpMinMitigPct      = 5.0;    // Mitigazione MINIMA per entrare, % dell'altezza del vuoto (P3: 5)
input double InpMaxMitigPct      = 100.0;  // Mitigazione MASSIMA per entrare, % (100 = inerte)
input double InpInvalidPct       = 100.0;  // Oltre questa mitigazione % il gap e' MORTO (autore: al primo tocco)
input bool   InpConfirmCandle    = true;   // Serve la candela di conferma dentro la zona (autore: true)

input group "=== FILTRO DI REGIME (staccabile: la baseline e' NONE) ==="
input ENUM_FVG_REGIME InpRegimeMode = REG_NONE; // Regime: NONE = motore nudo (autore: BOTH)
input ENUM_TIMEFRAMES InpRegimeHTF  = PERIOD_H4; // TF superiore per le EMA (autore: H4)
input int    InpEmaFast          = 50;     // EMA veloce sul TF superiore (autore: 50)
input int    InpEmaSlow          = 200;    // EMA lenta sul TF superiore (autore: 200)
input int    InpAdxPeriod        = 14;     // Periodo ADX (autore: 14)
input double InpAdxMin           = 20.0;   // ADX minimo (autore: 20)

input group "=== Stop, target, gestione ==="
input int    InpAtrPeriod        = 14;     // Periodo ATR (autore: 14)
input ENUM_FVG_SLMODE InpSLMode  = SL_ATR; // Modo dello stop (autore: ATR)
input double InpSLAtrMult        = 1.5;    // (ATR) stop = X * ATR (autore: 1.5)
input int    InpSLPts            = 150;    // (PUNTI) stop in punti MT5 (autore: 150)
input double InpSLStructBufAtr   = 0.25;   // (STRUTT) buffer oltre il bordo lontano del gap, in ATR
input double InpMinSLAtr         = 0.50;   // PAVIMENTO dello stop in ATR - ATTIVO (C4/R109). 0 = spento
input double InpMinSLPts         = 0;      // PAVIMENTO dello stop in punti MT5 (0 = spento). Vale il piu' LARGO dei due
input ENUM_FVG_TPMODE InpTPMode  = TP_ATR; // Modo del target (autore: ATR)
input double InpTPAtrMult        = 3.0;    // (ATR) target = X * ATR (autore: 3.0)
input int    InpTPPts            = 300;    // (PUNTI) target in punti MT5 (autore: 300)
input double InpTP_RR            = 2.0;    // (RR) target = X volte R
input double InpTP1Pct           = 0;      // % chiusa al primo target (0 = parziale SPENTO; autore: 50)
input double InpTP1_RR           = 1.0;    // Primo target del parziale, in R (a SL 1.5ATR e TP 3ATR, 1R = meta' TP = autore)
input bool   InpBreakeven        = true;   // Stop in pari al primo target (inerte se InpTP1Pct = 0)
input double InpBEAtrTrigger     = 0;      // Stop in pari autonomo dopo X * ATR di utile (0 = spento; autore: 1.0)
input int    InpBEBufferPts      = 0;      // Punti MT5 oltre il pari quando si va in pari (autore: 5)
input bool   InpUseTrailAtr      = false;  // Trailing dello stop in ATR (autore: true)
input double InpTrailAtrMult     = 1.0;    // Trailing = X * ATR (autore: 1.0)

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay  = 3;      // Max ingressi al giorno (C6: obbligatorio, 0 = illimitato)
input bool   InpUseHourFilter    = false;  // Filtro orario sulla barra di segnale (ORA SERVER)
input int    InpHourStart        = 7;      // Ora SERVER di inizio (inclusa). Autore: 7
input int    InpHourEnd          = 20;     // Ora SERVER di fine (inclusa). Autore: 20
input bool   InpNoOvernight      = false;  // Niente overnight: chiudi tutto oltre l'ora e non riaprire
input int    InpNoOvernightHour  = 21;     // Ora SERVER oltre cui chiudo (se InpNoOvernight)
input bool   InpFridayClose      = false;  // Venerdi': chiudi tutto oltre l'ora e non riaprire
input int    InpFridayCloseHour  = 20;     // Ora SERVER del venerdi' oltre cui chiudo
input double InpMaxDailyDDPct    = 0;      // Muro giornaliero % (0 = SPENTO in backtest; autore: 5)
input double InpMaxTotalDDPct    = 0;      // Muro totale % (0 = SPENTO in backtest; autore: 10)

input group "=== Rischio ==="
input double InpRiskPercent      = 1.0;    // Rischio per trade, % del saldo (in campo si gira a 0,65)

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter    = false;
input string InpNewsFile         = "abtg_news.csv";
input int    InpNewsMinImpact    = 3;
input int    InpNewsBeforeMin    = 30;
input int    InpNewsAfterMin     = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies   = "";

input group "=== Generali ==="
input string InpComment   = "FVGRET";   // Commento sugli ordini
input long   InpMagic     = 775501;     // Numero magico (blocco 7755xx: VERGINE, verificato nel repo il 26/08/2026)
input int    InpMaxSpread = 0;          // Spread massimo in punti MT5 (0 = nessun limite)
input bool   InpVerbose   = true;       // Messaggi nel log
input bool   InpAutoTest  = true;       // Stampa le righe [FVGRET][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova
int      gTfSec = 0;                    // secondi di una barra del TF corrente

//--- un vuoto di prezzo vivo
struct FvgZona
  {
   double   bordoAlto;      // bordo superiore della zona
   double   bordoBasso;     // bordo inferiore della zona
   datetime tNascita;       // ora della TERZA barra, quella che completa il gap
   bool     rialzista;
   bool     morto;          // mitigato oltre InpInvalidPct
   bool     tradato;        // un gap = un solo ingresso (regola dell'autore)
   double   mitigMax;       // massima penetrazione vista, in % dell'altezza
  };

FvgZona  gFvg[];
int      gFvgCount = 0;

//--- campioni della taglia dei gap, per la soglia a percentile mobile (P3).
//    Buffer circolare: un campione per barra CHIUSA, in % del prezzo.
double   gRaw[];
int      gRawPos = 0, gRawCount = 0;
bool     gBackfillFatto = false;
#define  FVG_MIN_CAMPIONI 100            // sotto questo numero il riferimento non e' misurabile

int      hAtr = INVALID_HANDLE;
int      hAdx = INVALID_HANDLE;
int      hEmaF = INVALID_HANDLE, hEmaS = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;
double gStartEquity    = 0.0;

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[FVGRET] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| FVG RIALZISTA: il minimo della terza barra sta SOPRA il massimo   |
//| della prima. Confronto STRETTO: due barre che si toccano          |
//| esattamente non lasciano nessun vuoto.                            |
//+------------------------------------------------------------------+
bool FvgRialzista_Calc(const double lowI, const double highI2)
  {
   return(lowI > highI2);
  }

//+------------------------------------------------------------------+
//| FVG RIBASSISTA: specchio esatto.                                  |
//+------------------------------------------------------------------+
bool FvgRibassista_Calc(const double highI, const double lowI2)
  {
   return(highI < lowI2);
  }

//+------------------------------------------------------------------+
//| CONTIGUITA' NEL TEMPO delle tre barre.                            |
//| t2 = ora della prima barra (i-2), t0 = ora della terza (i).        |
//| Fra loro devono passare esattamente DUE barre del TF.              |
//| Se non e' cosi', in mezzo c'e' una chiusura di sessione o un fine  |
//| settimana: quel salto e' un GAP DI APERTURA (ABTG_GapFill /        |
//| ABTG_GapContinuation, gia' in flotta), non un vuoto intraday.      |
//+------------------------------------------------------------------+
bool Contigue_Calc(const datetime t2, const datetime t0, const int tfSec)
  {
   if(tfSec<=0) return(false);
   return((long)(t0-t2) == (long)(2*tfSec));
  }

//+------------------------------------------------------------------+
//| TAGLIA DEL GAP a PERCENTILE MOBILE (specifica P3).                |
//| pct = ampiezza del gap in % del prezzo della barra.                |
//| rif = la MASSIMA ampiezza vista nella finestra, sempre in % del    |
//|       prezzo (equivale al percentile 100 di ta.percentile_nearest_ |
//|       rank(diff,1000,100) del Pine).                               |
//| soglia = quanta parte di quel massimo deve valere il gap.          |
//| rif<=0 = riferimento non misurabile -> NON passa: e' una           |
//| condizione COSTITUTIVA (senza scala non c'e' taglia).              |
//+------------------------------------------------------------------+
bool TagliaPercentile_Calc(const double pct, const double rif, const double soglia)
  {
   if(pct<=0 || rif<=0 || soglia<0) return(false);
   return(pct >= rif*soglia/100.0);
  }

//+------------------------------------------------------------------+
//| MITIGAZIONE: quanto in PROFONDITA' il prezzo e' rientrato nel      |
//| vuoto, in percentuale dell'altezza del vuoto (specifica P3).       |
//|   0   = ha appena toccato il bordo d'ingresso                      |
//|   100 = ha raggiunto il bordo opposto (vuoto colmato)              |
//|   >100= ha sfondato il vuoto                                       |
//|   <0  = non e' nemmeno arrivato al bordo                           |
//| NON e' limitata a 0..100 di proposito: la parte oltre 100 serve a  |
//| decidere quando il gap e' MORTO, e la parte sotto 0 a distinguere  |
//| "non toccato" da "toccato appena".                                 |
//+------------------------------------------------------------------+
double Mitigazione_Calc(const bool rialzista, const double bordoAlto,
                        const double bordoBasso, const double estremoBarra)
  {
   double h = bordoAlto-bordoBasso;
   if(h<=0) return(-1.0);
   if(rialzista) return((bordoAlto-estremoBarra)/h*100.0);
   return((estremoBarra-bordoBasso)/h*100.0);
  }

//+------------------------------------------------------------------+
//| FINESTRA DI MITIGAZIONE ammessa per entrare.                       |
//| E' la domanda di mercato del dossier (scoperta n.6): si compra sul  |
//| BORDO del vuoto o DENTRO il vuoto? Con min e max si risponde.       |
//+------------------------------------------------------------------+
bool FinestraMitig_Calc(const double m, const double minPct, const double maxPct)
  {
   if(m<minPct) return(false);
   if(m>maxPct) return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| ETA' del gap in barre chiuse.                                      |
//| modoRitorno = true -> il minimo VERO e' 1: entrare sulla barra che  |
//| crea il gap non e' un ritorno, e' la formazione (difetto S8).       |
//+------------------------------------------------------------------+
bool EtaOk_Calc(const int eta, const int minEta, const bool modoRitorno)
  {
   if(eta<0) return(false);
   int soglia = minEta;
   if(modoRitorno && soglia<1) soglia = 1;
   return(eta >= soglia);
  }

//+------------------------------------------------------------------+
//| CANDELA DI CONFERMA (regola dell'autore).                          |
//|   long : chiude in su' E chiude sopra il bordo basso della zona     |
//|   short: chiude in giu' E chiude sotto il bordo alto della zona     |
//| richiesta = false -> passa sempre (InpConfirmCandle spento).        |
//+------------------------------------------------------------------+
bool Conferma_Calc(const bool isLong, const double o, const double c,
                   const double bordo, const bool richiesta)
  {
   if(!richiesta) return(true);
   if(isLong) return(c>o && c>=bordo);
   return(c<o && c<=bordo);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop. Se lo stop e' piu' vicino del pavimento, lo  |
//| stop si ALLARGA al pavimento (semantica di "minimo"), non si salta  |
//| il trade. pavimento<=0 = spento.                                    |
//| Serve perche' uno stop puo' nascere a due punti dal prezzo: li' il  |
//| lotto per rischio esplode, sbatte su SYMBOL_VOLUME_MAX e lo         |
//| slippage si mangia l'operazione intera (R109, misurato).            |
//+------------------------------------------------------------------+
double PavimentoSL_Calc(const bool isLong, const double entry,
                        const double slGrezzo, const double pavimento)
  {
   if(pavimento<=0) return(slGrezzo);
   double R = isLong ? (entry-slGrezzo) : (slGrezzo-entry);
   if(R >= pavimento) return(slGrezzo);
   return(isLong ? entry-pavimento : entry+pavimento);
  }

//+------------------------------------------------------------------+
//| Filtro orario -- nucleo. Estremi INCLUSI. Gestisce anche la        |
//| fascia a cavallo della mezzanotte (start>end).                     |
//+------------------------------------------------------------------+
bool OraAmmessa_Calc(const int ora, const int start, const int end)
  {
   if(start<=end) return(ora>=start && ora<=end);
   return(ora>=start || ora<=end);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);   // l'autore forzava FOK: su BCM non e' detto che il simbolo lo ammetta
   gTrade.SetDeviationInPoints(30);

   gTfSec = PeriodSeconds(_Period);
   if(gTfSec<=0)
     { Print("ERRORE: periodo del grafico non leggibile."); return(INIT_FAILED); }

   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: entrambi i lati spenti: l'EA non avrebbe niente da fare."); return(INIT_FAILED); }
   if(InpGapMode==GAP_PERCENTILE && (InpGapPctOfMax<=0 || InpGapPctOfMax>100))
     { Print("ERRORE: InpGapPctOfMax deve stare fra 0 (escluso) e 100."); return(INIT_FAILED); }
   if(InpGapMode==GAP_PERCENTILE && InpGapPctLookback<FVG_MIN_CAMPIONI)
     { Print("ERRORE: InpGapPctLookback deve essere >= ", FVG_MIN_CAMPIONI, ": sotto, il massimo mobile non e' una misura."); return(INIT_FAILED); }
   if(InpGapMode==GAP_PUNTI && InpMinGapPts<0)
     { Print("ERRORE: InpMinGapPts non puo' essere negativo."); return(INIT_FAILED); }
   if(InpMaxFvgTrack<1)
     { Print("ERRORE: InpMaxFvgTrack deve essere >= 1."); return(INIT_FAILED); }
   if(InpMinAgeBars<0)
     { Print("ERRORE: InpMinAgeBars non puo' essere negativo."); return(INIT_FAILED); }
   if(InpMaxMitigPct < InpMinMitigPct)
     { Print("ERRORE: InpMaxMitigPct deve essere >= InpMinMitigPct."); return(INIT_FAILED); }
   if(InpInvalidPct<=0)
     { Print("ERRORE: InpInvalidPct deve essere > 0."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpSLMode==SL_ATR && InpSLAtrMult<=0)
     { Print("ERRORE: InpSLAtrMult deve essere > 0 nel modo ATR."); return(INIT_FAILED); }
   if(InpSLMode==SL_PUNTI && InpSLPts<=0)
     { Print("ERRORE: InpSLPts deve essere > 0 nel modo PUNTI."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }

   //--- CRITERIO C4, NON NEGOZIABILE (lezione R109, costata un round intero).
   //    Nel modo STRUTT lo stop nasce dal bordo del gap e puo' cadere a
   //    pochi punti dal prezzo: senza pavimento il lotto esplode, sbatte
   //    sul tetto del volume e i drawdown misurati SOTTOSTIMANO il rischio.
   if(InpSLMode==SL_STRUTT && InpMinSLAtr<=0 && InpMinSLPts<=0)
     {
      Print("ERRORE: stop STRUTTURALE senza pavimento. Criterio C4 (R109): ",
            "accendere InpMinSLAtr (consigliato 0.50) o InpMinSLPts.");
      return(INIT_FAILED);
     }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   if(InpRegimeMode==REG_ADX || InpRegimeMode==REG_BOTH)
     {
      hAdx = iADX(_Symbol, gTF, InpAdxPeriod);
      if(hAdx==INVALID_HANDLE)
        { Print("ERRORE: handle ADX."); return(INIT_FAILED); }
     }
   if(InpRegimeMode==REG_EMA || InpRegimeMode==REG_BOTH)
     {
      hEmaF = iMA(_Symbol, InpRegimeHTF, InpEmaFast, 0, MODE_EMA, PRICE_CLOSE);
      hEmaS = iMA(_Symbol, InpRegimeHTF, InpEmaSlow, 0, MODE_EMA, PRICE_CLOSE);
      if(hEmaF==INVALID_HANDLE || hEmaS==INVALID_HANDLE)
        { Print("ERRORE: handle EMA sul TF superiore."); return(INIT_FAILED); }
     }

   ArrayFree(gFvg); gFvgCount=0;
   ArrayResize(gRaw, InpGapPctLookback);
   ArrayInitialize(gRaw, -1.0);
   gRawPos=0; gRawCount=0; gBackfillFatto=false;

   gStartEquity = AccountInfoDouble(ACCOUNT_EQUITY);

   //--- DICHIARAZIONE, non correzione: se qualcosa e' acceso, la cella
   //    NON e' la BASELINE NUDA del round. Non lo spegne l'EA (sarebbe un
   //    default nascosto): lo DICE, e il file prova lo pinna.
   if(InpRegimeMode!=REG_NONE || InpEntryMode!=ENTRY_RITORNO || InpGapMode!=GAP_PERCENTILE ||
      InpTP1Pct>0 || InpUseTrailAtr || InpBEAtrTrigger>0 || InpSLMode!=SL_ATR ||
      InpTPMode!=TP_ATR || InpUseHourFilter || InpUseNewsFilter || InpNoOvernight ||
      InpFridayClose || InpMaxDailyDDPct>0 || InpMaxTotalDDPct>0 || !InpSoloBarreContigue)
      Log("ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' la BASELINE NUDA dell'adattamento.");

   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest)      AutoTestFvg();

   Log(StringFormat("avviato su %s %s. taglia %s, ingresso %s, eta>=%d, mitig %.1f-%.1f%%, morte a %.1f%%, regime %s, SL %s, TP %s, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       (InpGapMode==GAP_PERCENTILE?StringFormat("%.1f%% del max su %d barre",InpGapPctOfMax,InpGapPctLookback):StringFormat("%d punti MT5",InpMinGapPts)),
       (InpEntryMode==ENTRY_RITORNO?"RITORNO":"FORMAZIONE"),
       InpMinAgeBars, InpMinMitigPct, InpMaxMitigPct, InpInvalidPct,
       EnumToString(InpRegimeMode), EnumToString(InpSLMode), EnumToString(InpTPMode),
       InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr !=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hAdx !=INVALID_HANDLE) IndicatorRelease(hAdx);
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(ChiusuraForzata()) return;       // venerdi'/overnight oltre l'ora: chiudo e non riapro

   //--- Sta QUI e non dopo il filtro della nuova barra: su M15 la caduta
   //    peggiore di giornata succede in mezzo a una candela.
   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari / trailing: a ogni tick

   if(!IsNewBar()) return;             // le DECISIONI solo a barra chiusa

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; gTradesToday=0; }

   OnNewBar();
  }

//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = iTime(_Symbol, gTF, 0);
   if(t!=gLastBar){ gLastBar=t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| Il giro di una barra nuova. L'ORDINE E' LA CORREZIONE DEL DIFETTO |
//| n.4 della scheda P1:                                              |
//|   1. campione della taglia (serve al percentile, include la barra |
//|      corrente come nel Pine di P3)                                |
//|   2. rilevazione del gap che si chiude sulla barra [1]            |
//|   3. DECISIONE d'ingresso, letta sulla barra [1]                  |
//|   4. SOLO ADESSO si aggiorna lo stato dei gap (mitigazione,       |
//|      morte). L'autore lo faceva PRIMA e guardando la barra viva:  |
//|      un gap toccato all'apertura moriva prima che l'ingresso lo   |
//|      vedesse, e il segnale spariva in silenzio.                   |
//| I punti 1 e 2 girano SEMPRE, anche con una posizione aperta: la   |
//| memoria dei vuoti non deve avere buchi.                           |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   //--- 1. il campione della barra [1]. Al primo giro il riempimento
   //    iniziale lo comprende gia': non si conta due volte.
   if(!gBackfillFatto) BackfillCampioni();
   else                AggiornaCampioneGap();

   RilevaFvgNuovo();           // 2

   if(IngressiAmmessi())       // 3
      CercaIngresso();

   AggiornaMitigazione();      // 4
   PurgaFvg();
  }

//+------------------------------------------------------------------+
//| Tutti i cancelli che NON riguardano il segnale.                   |
//+------------------------------------------------------------------+
bool IngressiAmmessi()
  {
   if(CountPositions()>0) return(false);                       // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return(false);
   if(MuroDrawdown()) return(false);
   if(!OraOK())    return(false);
   if(!SpreadOK()) return(false);
   if(InpUseNewsFilter && InNewsBlackout(TimeCurrent())) return(false);
   return(true);
  }

//==================================================================
//  IL VUOTO: campioni, rilevazione, stato
//==================================================================

//+------------------------------------------------------------------+
//| Il campione di taglia della barra [s]: ampiezza del vuoto che si   |
//| chiude su quella barra, in % del prezzo della barra stessa         |
//| (esattamente il "diff" del Pine di P3, che divide per low sul lato |
//| rialzista e per high su quello ribassista).                        |
//| Nessun vuoto -> 0. Dato mancante o barre non contigue -> -1.        |
//| ATTENZIONE: la contiguita' vale ANCHE qui. Se i gap di sessione     |
//| entrassero nei campioni, il massimo della finestra sarebbe sempre   |
//| un salto notturno e la soglia intraday diventerebbe irraggiungibile.|
//+------------------------------------------------------------------+
double CampioneGapPct(const int s)
  {
   double lo0=iLow (_Symbol,gTF,s),   hi0=iHigh(_Symbol,gTF,s);
   double lo2=iLow (_Symbol,gTF,s+2), hi2=iHigh(_Symbol,gTF,s+2);
   if(lo0<=0 || hi0<=0 || lo2<=0 || hi2<=0) return(-1.0);
   if(InpSoloBarreContigue)
     {
      datetime t0=iTime(_Symbol,gTF,s), t2=iTime(_Symbol,gTF,s+2);
      if(t0<=0 || t2<=0) return(-1.0);
      if(!Contigue_Calc(t2,t0,gTfSec)) return(-1.0);
     }
   if(FvgRialzista_Calc(lo0,hi2)) return((lo0-hi2)/lo0*100.0);
   if(FvgRibassista_Calc(hi0,lo2)) return((lo2-hi0)/hi0*100.0);
   return(0.0);
  }

void PushCampione(const double v)
  {
   int n = ArraySize(gRaw);
   if(n<=0) return;
   gRaw[gRawPos] = v;
   gRawPos = (gRawPos+1)%n;
   if(gRawCount<n) gRawCount++;
  }

//--- riempimento iniziale della finestra: senza, i primi 1000 segnali
//    girerebbero con una scala che non c'e'.
void BackfillCampioni()
  {
   int disp = Bars(_Symbol,gTF)-3;
   if(disp<1) return;
   int quanti = MathMin(ArraySize(gRaw), disp);
   for(int s=quanti; s>=1; s--) PushCampione(CampioneGapPct(s));
   gBackfillFatto=true;
   Log(StringFormat("finestra della taglia riempita con %d campioni (riferimento %.4f%%).",
                    gRawCount, RiferimentoMax()));
  }

void AggiornaCampioneGap()
  {
   if(!gBackfillFatto) return;
   PushCampione(CampioneGapPct(1));
  }

//+------------------------------------------------------------------+
//| Il MASSIMO della finestra, in % del prezzo. E' il percentile 100   |
//| del Pine di P3. Sotto FVG_MIN_CAMPIONI campioni non e' una misura: |
//| torna -1 e nessun gap passa il filtro di taglia.                   |
//+------------------------------------------------------------------+
double RiferimentoMax()
  {
   if(gRawCount<FVG_MIN_CAMPIONI) return(-1.0);
   double mx=-1.0;
   for(int i=0;i<gRawCount;i++) if(gRaw[i]>mx) mx=gRaw[i];
   if(mx<=0) return(-1.0);
   return(mx);
  }

//+------------------------------------------------------------------+
//| La taglia del gap secondo il modo scelto.                          |
//+------------------------------------------------------------------+
bool TagliaOk(const double ampiezza, const double prezzoBarra)
  {
   if(ampiezza<=0) return(false);
   if(InpGapMode==GAP_PUNTI) return(ampiezza >= InpMinGapPts*_Point);
   if(prezzoBarra<=0) return(false);
   double pct = ampiezza/prezzoBarra*100.0;
   return(TagliaPercentile_Calc(pct, RiferimentoMax(), InpGapPctOfMax));
  }

//+------------------------------------------------------------------+
//| Rileva il vuoto che si CHIUDE sulla barra [1] (l'ultima chiusa).   |
//| Solo quello: la scansione all'indietro dell'autore (200 barre a    |
//| ogni tick) e' inutile una volta che la lista e' incrementale, e    |
//| col riferimento a percentile costerebbe 200.000 confronti a barra. |
//| Nota: i due versi si escludono a vicenda per costruzione (se       |
//| low[i]>high[i-2] allora high[i]>=low[i]>high[i-2]>=low[i-2]).      |
//+------------------------------------------------------------------+
void RilevaFvgNuovo()
  {
   const int s = 1;
   double lo0=iLow (_Symbol,gTF,s),   hi0=iHigh(_Symbol,gTF,s);
   double lo2=iLow (_Symbol,gTF,s+2), hi2=iHigh(_Symbol,gTF,s+2);
   datetime t0=iTime(_Symbol,gTF,s),  t2=iTime(_Symbol,gTF,s+2);
   if(lo0<=0 || hi0<=0 || lo2<=0 || hi2<=0 || t0<=0 || t2<=0) return;
   if(InpSoloBarreContigue && !Contigue_Calc(t2,t0,gTfSec)) return;

   if(FvgRialzista_Calc(lo0,hi2))
     {
      if(TagliaOk(lo0-hi2, lo0)) AggiungiFvg(lo0, hi2, t0, true);
      return;
     }
   if(FvgRibassista_Calc(hi0,lo2))
     {
      if(TagliaOk(lo2-hi0, hi0)) AggiungiFvg(lo2, hi0, t0, false);
     }
  }

void AggiungiFvg(const double bordoAlto, const double bordoBasso,
                 const datetime tNascita, const bool rialzista)
  {
   if(bordoAlto<=bordoBasso) return;
   if(gFvgCount>=InpMaxFvgTrack) RimuoviPiuVecchio();
   gFvgCount++;
   ArrayResize(gFvg, gFvgCount, 20);
   int k=gFvgCount-1;
   gFvg[k].bordoAlto  = bordoAlto;
   gFvg[k].bordoBasso = bordoBasso;
   gFvg[k].tNascita   = tNascita;
   gFvg[k].rialzista  = rialzista;
   gFvg[k].morto      = false;
   gFvg[k].tradato    = false;
   gFvg[k].mitigMax   = -1.0;
  }

void RimuoviPiuVecchio()
  {
   if(gFvgCount<=0) return;
   for(int i=0;i<gFvgCount-1;i++) gFvg[i]=gFvg[i+1];
   gFvgCount--;
   ArrayResize(gFvg, gFvgCount, 20);
  }

//+------------------------------------------------------------------+
//| Aggiorna la mitigazione di ogni vuoto vivo con la barra [1] e      |
//| dichiara morti quelli sfondati oltre InpInvalidPct.                |
//| Gira DOPO la decisione d'ingresso: e' il punto in cui l'autore     |
//| perdeva i segnali.                                                 |
//+------------------------------------------------------------------+
void AggiornaMitigazione()
  {
   double h1=iHigh(_Symbol,gTF,1), l1=iLow(_Symbol,gTF,1);
   if(h1<=0 || l1<=0) return;
   for(int i=0;i<gFvgCount;i++)
     {
      if(gFvg[i].morto) continue;
      double m = Mitigazione_Calc(gFvg[i].rialzista, gFvg[i].bordoAlto,
                                  gFvg[i].bordoBasso, gFvg[i].rialzista ? l1 : h1);
      if(m>gFvg[i].mitigMax) gFvg[i].mitigMax=m;
      if(gFvg[i].mitigMax>=InpInvalidPct) gFvg[i].morto=true;
     }
  }

//--- toglie dalla lista i vuoti morti o gia' usati: la memoria resta corta
//    e l'ordine (dal piu' vecchio al piu' recente) non cambia.
void PurgaFvg()
  {
   int w=0;
   for(int i=0;i<gFvgCount;i++)
     {
      if(gFvg[i].morto || gFvg[i].tradato) continue;
      if(w!=i) gFvg[w]=gFvg[i];
      w++;
     }
   if(w!=gFvgCount){ gFvgCount=w; ArrayResize(gFvg, gFvgCount, 20); }
  }

//--- eta' del vuoto in barre chiuse: 0 = e' nato sulla barra di segnale.
int EtaBarre(const datetime tNascita)
  {
   int sh = iBarShift(_Symbol, gTF, tNascita, false);
   if(sh<0) return(-1);
   return(sh-1);
  }

//==================================================================
//  LA DECISIONE
//==================================================================
//+------------------------------------------------------------------+
//| Cerca l'ingresso sulla barra [1].                                  |
//| SCELTA DICHIARATA: si scorre dal vuoto PIU' RECENTE al piu'        |
//| vecchio e si prende il PRIMO che qualifica (l'autore prendeva il   |
//| piu' vecchio). Motivo: il vuoto piu' recente e' quello dentro cui  |
//| il prezzo e' appena tornato, ed e' il piu' stretto rispetto al     |
//| prezzo - quindi lo stop strutturale piu' piccolo. L'eta' minima    |
//| resta la manopola che governa "quanto vecchio" (P3).               |
//| Una sola decisione per barra, qualunque sia il lato.               |
//+------------------------------------------------------------------+
void CercaIngresso()
  {
   double o1=iOpen (_Symbol,gTF,1), c1=iClose(_Symbol,gTF,1);
   double h1=iHigh (_Symbol,gTF,1), l1=iLow  (_Symbol,gTF,1);
   if(o1<=0 || c1<=0 || h1<=0 || l1<=0) return;

   for(int i=gFvgCount-1;i>=0;i--)
     {
      if(gFvg[i].morto || gFvg[i].tradato) continue;
      bool isLong = gFvg[i].rialzista;
      if(isLong && !InpAllowLong)  continue;
      if(!isLong && !InpAllowShort) continue;

      int eta = EtaBarre(gFvg[i].tNascita);
      if(!EtaOk_Calc(eta, InpMinAgeBars, InpEntryMode==ENTRY_RITORNO)) continue;

      if(InpEntryMode==ENTRY_RITORNO)
        {
         //--- il prezzo deve essere TORNATO dentro il vuoto, e alla
         //    profondita' richiesta (specifica P3).
         double m = Mitigazione_Calc(isLong, gFvg[i].bordoAlto, gFvg[i].bordoBasso,
                                     isLong ? l1 : h1);
         if(!FinestraMitig_Calc(m, InpMinMitigPct, InpMaxMitigPct)) continue;
        }
      else
        {
         //--- FORMAZIONE: solo la barra che chiude il gap, e nessun
         //    requisito di profondita' (per costruzione sarebbe 0).
         if(eta!=0) continue;
        }

      double bordoConf = isLong ? gFvg[i].bordoBasso : gFvg[i].bordoAlto;
      if(!Conferma_Calc(isLong, o1, c1, bordoConf, InpConfirmCandle)) continue;
      if(!RegimeOk(isLong)) continue;

      if(Enter(isLong, gFvg[i])) gFvg[i].tradato=true;
      return;                              // una sola decisione per barra
     }
  }

//+------------------------------------------------------------------+
//| REGIME - filtro STACCABILE, non parte del motore.                  |
//| REG_NONE (default) = passa sempre: e' la BASELINE del round.       |
//| Gli altri tre gradini sono quelli dell'autore, e servono come      |
//| ABLAZIONE: in casa il filtro appiccicato a un motore gia' tarato   |
//| fa 0 successi su 5 (ROBUSTEZZA.md par. 5B), e l'ADX e' uno dei     |
//| cinque. Se il motore nudo non regge, il filtro non lo salva.       |
//| SCOSTAMENTO: l'autore leggeva EMA e ADX allo shift 0 (barra viva); |
//| qui si legge lo shift 1 (barra chiusa), regola di casa.            |
//+------------------------------------------------------------------+
bool RegimeOk(const bool isLong)
  {
   if(InpRegimeMode==REG_NONE) return(true);

   bool emaOk=true, adxOk=true;

   if(InpRegimeMode==REG_EMA || InpRegimeMode==REG_BOTH)
     {
      double ef[1], es[1];
      if(CopyBuffer(hEmaF,0,1,1,ef)!=1) return(false);
      if(CopyBuffer(hEmaS,0,1,1,es)!=1) return(false);
      double px = iClose(_Symbol,gTF,1);
      if(px<=0) return(false);
      emaOk = isLong ? (px>ef[0] && ef[0]>es[0]) : (px<ef[0] && ef[0]<es[0]);
     }

   if(InpRegimeMode==REG_ADX || InpRegimeMode==REG_BOTH)
     {
      double ax[1], dp[1], dm[1];
      if(CopyBuffer(hAdx,0,1,1,ax)!=1) return(false);
      if(CopyBuffer(hAdx,1,1,1,dp)!=1) return(false);
      if(CopyBuffer(hAdx,2,1,1,dm)!=1) return(false);
      adxOk = (ax[0]>=InpAdxMin) && (isLong ? (dp[0]>dm[0]) : (dm[0]>dp[0]));
     }

   return(emaOk && adxOk);
  }

//--- Orario della BARRA DI SEGNALE, in ORA SERVER (mai l'ora italiana:
//    regola di casa, il server BCM e' un'ora indietro).
bool OraOK()
  {
   if(!InpUseHourFilter) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   return(OraAmmessa_Calc(t.hour, InpHourStart, InpHourEnd));
  }

double AtrVal()
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0);
   return(a[0]);
  }

//==================================================================
//  INGRESSO
//==================================================================
//+------------------------------------------------------------------+
//| Apre a mercato all'apertura della barra nuova.                     |
//| Ordine: stop grezzo -> PAVIMENTO -> normalizzazione -> STOPS_LEVEL |
//| -> target -> lotto -> Guardian -> invio.                           |
//| Ritorna true SOLO se l'ordine e' partito davvero.                  |
//+------------------------------------------------------------------+
bool Enter(const bool isLong, const FvgZona &z)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);
   double entry = isLong ? ask : bid;

   double atr = AtrVal();
   if(atr<=0 && (InpSLMode==SL_ATR || InpTPMode==TP_ATR || InpMinSLAtr>0 || InpSLMode==SL_STRUTT))
     { Log("ATR non disponibile: salto."); return(false); }

   //--- STOP GREZZO
   double sl=0;
   if(InpSLMode==SL_ATR)
      sl = isLong ? entry-atr*InpSLAtrMult : entry+atr*InpSLAtrMult;
   else if(InpSLMode==SL_PUNTI)
      sl = isLong ? entry-InpSLPts*_Point : entry+InpSLPts*_Point;
   else
     {
      //--- STRUTT: oltre il bordo LONTANO del vuoto (quello che, se
      //    superato, dice che il vuoto non ha tenuto), piu' un buffer ATR.
      double buf = atr*InpSLStructBufAtr;
      sl = isLong ? z.bordoBasso-buf : z.bordoAlto+buf;
     }

   //--- PAVIMENTO (C4/R109): vale il piu' LARGO fra i due, e allarga lo
   //    stop, non salta il trade.
   double pavimento = MathMax(InpMinSLAtr>0 ? InpMinSLAtr*atr : 0.0,
                              InpMinSLPts>0 ? InpMinSLPts*_Point : 0.0);
   sl = PavimentoSL_Calc(isLong, entry, sl, pavimento);
   sl = NormalizePrice(sl);

   if(isLong && sl>=entry){ Log("stop dalla parte sbagliata del prezzo: salto."); return(false); }
   if(!isLong && sl<=entry){ Log("stop dalla parte sbagliata del prezzo: salto."); return(false); }

   double R = isLong ? (entry-sl) : (sl-entry);
   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=0 || R<=minDist)
     { Log("SL troppo vicino al prezzo (stops level): salto."); return(false); }

   //--- TARGET
   double tp=0, tpDist=0;
   if(InpTPMode==TP_ATR)        tpDist = atr*InpTPAtrMult;
   else if(InpTPMode==TP_PUNTI) tpDist = InpTPPts*_Point;
   else                         tpDist = R*InpTP_RR;
   if(tpDist>0)
     {
      tp = NormalizePrice(isLong ? entry+tpDist : entry-tpDist);
      double d = isLong ? (tp-entry) : (entry-tp);
      if(d<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lot = LotByRisk(R);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }

   string cm = InpComment + (isLong ? " L" : " S");

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_FvgRetest")) return(false);

   bool ok = isLong ? gTrade.Buy(lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(ok)
     {
      gTradesToday++;
      Log(StringFormat("%s @ %s SL %s TP %s lot %.2f (R %s | vuoto %s-%s | eta %d barre | mitig %.1f%%)",
          isLong?"LONG":"SHORT",
          DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
          DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits),
          DoubleToString(z.bordoBasso,_Digits), DoubleToString(z.bordoAlto,_Digits),
          EtaBarre(z.tNascita),
          Mitigazione_Calc(isLong,z.bordoAlto,z.bordoBasso,
                           isLong?iLow(_Symbol,gTF,1):iHigh(_Symbol,gTF,1))));
      return(true);
     }
   Log("apertura fallita: "+gTrade.ResultRetcodeDescription());
   return(false);
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE
//==================================================================
//+------------------------------------------------------------------+
//| Parziale al primo target + stop in pari, stop in pari autonomo in  |
//| ATR, trailing in ATR. Gira a OGNI tick: il target si tocca in      |
//| mezzo alla barra.                                                  |
//|                                                                    |
//| NOTA SUL DEFAULT: con InpTP1Pct=0, InpBEAtrTrigger=0 e             |
//| InpUseTrailAtr=false questo blocco NON fa niente. E' VOLUTO ed e'  |
//| uno scostamento dichiarato dall'autore (che ha parziale, pari e    |
//| trailing tutti ACCESI): il PASSO 0 del round deve misurare la      |
//| mediana del take LORDO del meccanismo, e tre strati di gestione    |
//| accesi la rendono illeggibile. La cella d'autore si riproduce      |
//| accendendo tre interruttori (vedi FVG_TESI.md par. 3).             |
//+------------------------------------------------------------------+
void ManageAll()
  {
   if(InpTP1Pct<=0 && InpBEAtrTrigger<=0 && !InpUseTrailAtr) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;
   double atr = ((InpUseTrailAtr || InpBEAtrTrigger>0) ? AtrVal() : 0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;

      bool   isLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      double vol    = PositionGetDouble(POSITION_VOLUME);
      if(sl<=0) continue;                       // senza stop non so quanto vale 1 R

      double R = isLong ? (openP-sl) : (sl-openP);
      bool   beFatto = isLong ? (sl>=openP) : (sl<=openP);
      double bePrice = NormalizePrice(isLong ? openP+InpBEBufferPts*_Point
                                             : openP-InpBEBufferPts*_Point);

      //--- primo target: parziale + stop in pari
      if(!beFatto && InpTP1Pct>0 && R>0)
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            //  LEZIONE PTE (04/08/2026): lo STOP IN PARI non deve dipendere
            //  dalla riuscita del parziale. Al lotto minimo NormVol()
            //  arrotonda a 0, il parziale non parte, e prima di quella
            //  lezione con lui saltava anche il breakeven.
            bool parz = (cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv));
            if(InpBreakeven){ gTrade.PositionModify(tk,bePrice,tp); beFatto=true; }
            Log(parz ? "primo target: parziale eseguito."
                     : "primo target: parziale impossibile al lotto minimo.");
           }
        }

      //--- stop in pari autonomo (regola dell'autore): dopo X * ATR di utile
      if(!beFatto && InpBEAtrTrigger>0 && atr>0)
        {
         double trig = isLong ? openP+atr*InpBEAtrTrigger : openP-atr*InpBEAtrTrigger;
         bool   hit  = isLong ? (bid>=trig) : (ask<=trig);
         if(hit)
           {
            double slOra = PositionGetDouble(POSITION_SL);
            if(isLong  && bePrice>slOra && bePrice<bid) gTrade.PositionModify(tk,bePrice,tp);
            if(!isLong && bePrice<slOra && bePrice>ask) gTrade.PositionModify(tk,bePrice,tp);
           }
        }

      //--- trailing in ATR: lo stop si muove SOLO a favore, mai indietro
      if(InpUseTrailAtr && atr>0)
        {
         double slOra = PositionGetDouble(POSITION_SL);
         double tpOra = PositionGetDouble(POSITION_TP);
         if(isLong)
           {
            double n = NormalizePrice(bid-atr*InpTrailAtrMult);
            if(n>slOra && n<bid) gTrade.PositionModify(tk,n,tpOra);
           }
         else
           {
            double n = NormalizePrice(ask+atr*InpTrailAtrMult);
            if((slOra<=0 || n<slOra) && n>ask) gTrade.PositionModify(tk,n,tpOra);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Venerdi' oltre l'ora, oppure niente overnight: chiudo tutto e non  |
//| riapro. L'ora e' quella del SERVER (TimeCurrent), mai quella del   |
//| PC (i log di MT5 sono in ora locale: lezione 06/08).               |
//| L'autore non ha ne' l'una ne' l'altra regola: sono due opzioni di  |
//| casa, SPENTE di default.                                           |
//+------------------------------------------------------------------+
bool ChiusuraForzata()
  {
   if(!InpFridayClose && !InpNoOvernight) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   bool chiudi=false;
   if(InpFridayClose && t.day_of_week==5 && t.hour>=InpFridayCloseHour) chiudi=true;
   if(InpNoOvernight && t.hour>=InpNoOvernightHour) chiudi=true;
   if(!chiudi) return(false);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         gTrade.PositionClose(p);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.           |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime n; TimeToStruct(TimeCurrent(), n);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(n.day_of_year != gDayEqStamp)
     { gDayEqStamp = n.day_of_year; gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) { gDayStartEquity = eq; gDayMinEquity = eq; }
   if(gDayStartEquity <= 0) return;              // conto a zero: niente da dividere
   if(eq < gDayMinEquity)   gDayMinEquity = eq;
   double giornata = 100.0*(gDayMinEquity-gDayStartEquity)/gDayStartEquity;
   if(giornata < gWorstDayPct) gWorstDayPct = giornata;
  }

//+------------------------------------------------------------------+
//| MURI DI DRAWDOWN dell'autore (giornaliero e totale).               |
//| SPENTI di default, e non e' una svista: in BACKTEST un muro        |
//| NASCONDE il rischio che il round deve misurare. R109 con un muro   |
//| al 10% avrebbe scritto "DD 10%" invece del 56% vero, e il verdetto |
//| di rischio - l'unico che vale a campione sottile - sarebbe stato   |
//| falso. Sul conto vivo questa funzione la fa il Guardian.           |
//+------------------------------------------------------------------+
bool MuroDrawdown()
  {
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(InpMaxDailyDDPct>0 && gDayStartEquity>0)
     {
      double dd = 100.0*(gDayStartEquity-eq)/gDayStartEquity;
      if(dd>=InpMaxDailyDDPct){ Log("muro giornaliero raggiunto: niente nuovi ingressi."); return(true); }
     }
   if(InpMaxTotalDDPct>0 && gStartEquity>0)
     {
      double dd = 100.0*(gStartEquity-eq)/gStartEquity;
      if(dd>=InpMaxTotalDDPct){ Log("muro totale raggiunto: niente nuovi ingressi."); return(true); }
     }
   return(false);
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

//--- Lotto dalla distanza dello stop, come negli altri EA ABTG.
//    PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/2026):
//    su 225JPY il tick value arriva non convertito in valuta conto e il
//    lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit converte
//    correttamente; il tick value resta come ripiego.
//    Su un INDICE (D30EUR, U30USD, NASUSD) questa e' la strada giusta: la
//    distanza e' in PREZZO, non in pip, e non c'e' nessuna ipotesi forex
//    nascosta nel calcolo.
//    LEZIONE R109: quando il lotto sbatte sul TETTO del volume, quel trade
//    rischia MENO del richiesto e il drawdown del round SOTTOSTIMA il
//    rischio. Non si corregge in silenzio: si SCRIVE nel log.
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

   double grezzo = risk/lossPerLot;
   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   double lot = MathFloor(grezzo/st)*st;
   if(mx>0 && lot>mx)
     {
      Log(StringFormat("ATTENZIONE: lotto %.2f oltre il tetto %.2f: questo trade rischia MENO dell'%.2f%% richiesto (lezione R109).",
                       lot, mx, InpRiskPercent));
      lot = mx;
     }
   if(lot<mn) lot = mn;
   return(lot);
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
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

//==================================================================
//  AUTOTEST -- stampa in OnInit, quindi lo si legge SOLO ESEGUENDO
//  (test singolo nello Strategy Tester): F7 compila e basta, non
//  stampa niente. E MAI attaccando l'EA a un grafico del PC di
//  backtest: quel terminale e' collegato al conto vivo.
//
//  Le barre sintetiche qui sotto sono numeri tondi scelti perche' si
//  leggano a occhio: chi controlla non deve rifare i conti.
//==================================================================
void AutoTestFvg()
  {
   int falliti=0;

   PrintFormat("[FVGRET][AUTOTEST] taglia=%s | ingresso=%s | eta>=%d | mitig %.1f-%.1f%% | morte %.1f%% | regime=%s | %s | magic %I64d",
               (InpGapMode==GAP_PERCENTILE?"PERCENTILE":"PUNTI"),
               (InpEntryMode==ENTRY_RITORNO?"RITORNO":"FORMAZIONE"),
               InpMinAgeBars, InpMinMitigPct, InpMaxMitigPct, InpInvalidPct,
               EnumToString(InpRegimeMode), _Symbol, InpMagic);

   //--- 1. LA RILEVAZIONE DEL VUOTO
   //    barra i-2: high 100 | barra i: low 102  -> vuoto [100,102]
   bool g1 = FvgRialzista_Calc(102.0,100.0);   // vuoto vero
   bool g2 = FvgRialzista_Calc(100.0,100.0);   // si toccano: NESSUN vuoto (confronto stretto)
   bool g3 = FvgRialzista_Calc( 99.0,100.0);   // sovrapposte
   bool g4 = FvgRibassista_Calc(98.0,100.0);   // vuoto ribassista [98,100]
   bool g5 = FvgRibassista_Calc(100.0,100.0);  // si toccano: nessun vuoto
   PrintFormat("[FVGRET][AUTOTEST] vuoto: rialzista=%d (atteso 1) | pareggio=%d (atteso 0) | sovrapposte=%d (atteso 0) | ribassista=%d (atteso 1) | pareggio short=%d (atteso 0)",
               (int)g1,(int)g2,(int)g3,(int)g4,(int)g5);
   if(!(g1 && !g2 && !g3 && g4 && !g5)) falliti++;

   //--- 2. LA CONTIGUITA' NEL TEMPO (TF di 900 secondi = M15)
   bool k1 = Contigue_Calc((datetime)0,(datetime)1800,900);   // due barre esatte
   bool k2 = Contigue_Calc((datetime)0,(datetime)2700,900);   // ne manca una: c'e' stata una pausa
   bool k3 = Contigue_Calc((datetime)0,(datetime)57600,900);  // salto notturno
   bool k4 = Contigue_Calc((datetime)0,(datetime)1800,0);     // TF non leggibile -> blocca
   PrintFormat("[FVGRET][AUTOTEST] contiguita': esatta=%d (atteso 1) | buco=%d (atteso 0) | notte=%d (atteso 0) | TF 0=%d (atteso 0)",
               (int)k1,(int)k2,(int)k3,(int)k4);
   if(!(k1 && !k2 && !k3 && !k4)) falliti++;

   //--- 3. LA TAGLIA A PERCENTILE MOBILE (riferimento 2,0% ; soglia 10%
   //    -> serve almeno lo 0,20%)
   bool p1 = TagliaPercentile_Calc(0.30,2.0,10.0);   // 0,30% -> passa
   bool p2 = TagliaPercentile_Calc(0.10,2.0,10.0);   // 0,10% -> blocca
   bool p3 = TagliaPercentile_Calc(0.20,2.0,10.0);   // sul bordo -> incluso
   bool p4 = TagliaPercentile_Calc(0.30,-1.0,10.0);  // riferimento assente -> BLOCCA (costitutivo)
   bool p5 = TagliaPercentile_Calc(0.30,2.0,100.0);  // soglia = il massimo stesso -> blocca
   PrintFormat("[FVGRET][AUTOTEST] taglia: 0.30%%=%d (atteso 1) | 0.10%%=%d (atteso 0) | bordo=%d (atteso 1) | senza riferimento=%d (atteso 0) | soglia 100%%=%d (atteso 0)",
               (int)p1,(int)p2,(int)p3,(int)p4,(int)p5);
   if(!(p1 && !p2 && p3 && !p4 && !p5)) falliti++;

   //--- 4. LA MITIGAZIONE (vuoto rialzista [100,110], altezza 10)
   double m1 = Mitigazione_Calc(true,110.0,100.0,110.0);   // tocca il bordo alto -> 0%
   double m2 = Mitigazione_Calc(true,110.0,100.0,105.0);   // meta' vuoto -> 50%
   double m3 = Mitigazione_Calc(true,110.0,100.0,100.0);   // fondo del vuoto -> 100%
   double m4 = Mitigazione_Calc(true,110.0,100.0, 95.0);   // sfondato -> 150%
   double m5 = Mitigazione_Calc(true,110.0,100.0,112.0);   // non arrivato -> -20%
   double m6 = Mitigazione_Calc(false,110.0,100.0,105.0);  // short, meta' vuoto -> 50%
   PrintFormat("[FVGRET][AUTOTEST] mitigazione: bordo=%.1f (atteso 0.0) | meta=%.1f (atteso 50.0) | fondo=%.1f (atteso 100.0) | sfondato=%.1f (atteso 150.0) | lontano=%.1f (atteso -20.0) | short=%.1f (atteso 50.0)",
               m1,m2,m3,m4,m5,m6);
   if(MathAbs(m1-0.0)>0.001 || MathAbs(m2-50.0)>0.001 || MathAbs(m3-100.0)>0.001 ||
      MathAbs(m4-150.0)>0.001 || MathAbs(m5+20.0)>0.001 || MathAbs(m6-50.0)>0.001) falliti++;

   //--- 5. LA FINESTRA DI MITIGAZIONE (5% - 100%)
   bool f1 = FinestraMitig_Calc( 50.0,5.0,100.0);   // dentro
   bool f2 = FinestraMitig_Calc(  1.0,5.0,100.0);   // troppo poco (sfiorato)
   bool f3 = FinestraMitig_Calc(150.0,5.0,100.0);   // sfondato
   bool f4 = FinestraMitig_Calc(  5.0,5.0,100.0);   // bordo minimo incluso
   bool f5 = FinestraMitig_Calc( 30.0,5.0, 25.0);   // finestra stretta "solo sul bordo"
   PrintFormat("[FVGRET][AUTOTEST] finestra: 50%%=%d (atteso 1) | 1%%=%d (atteso 0) | 150%%=%d (atteso 0) | bordo=%d (atteso 1) | fuori tetto=%d (atteso 0)",
               (int)f1,(int)f2,(int)f3,(int)f4,(int)f5);
   if(!(f1 && !f2 && !f3 && f4 && !f5)) falliti++;

   //--- 6. L'ETA' -- il pezzo che separa il RETEST dalla FORMAZIONE
   bool e1 = EtaOk_Calc(0,0,true);    // RITORNO su eta 0 -> BLOCCA: e' la formazione, non un ritorno
   bool e2 = EtaOk_Calc(1,0,true);    // una barra dopo -> passa
   bool e3 = EtaOk_Calc(0,0,false);   // FORMAZIONE -> passa
   bool e4 = EtaOk_Calc(39,40,true);  // sotto l'eta' minima di P3
   bool e5 = EtaOk_Calc(40,40,true);  // esattamente l'eta' minima -> passa
   bool e6 = EtaOk_Calc(-1,0,false);  // barra di nascita non trovata -> blocca
   PrintFormat("[FVGRET][AUTOTEST] eta': ritorno a 0=%d (atteso 0) | ritorno a 1=%d (atteso 1) | formazione a 0=%d (atteso 1) | 39 su 40=%d (atteso 0) | 40 su 40=%d (atteso 1) | ignota=%d (atteso 0)",
               (int)e1,(int)e2,(int)e3,(int)e4,(int)e5,(int)e6);
   if(!(!e1 && e2 && e3 && !e4 && e5 && !e6)) falliti++;

   //--- 7. LA CANDELA DI CONFERMA (vuoto rialzista, bordo basso 100)
   bool c1 = Conferma_Calc(true, 99.0,101.0,100.0,true);   // chiude in su' e sopra il bordo -> passa
   bool c2 = Conferma_Calc(true,101.0, 99.0,100.0,true);   // chiude in giu' -> blocca
   bool c3 = Conferma_Calc(true, 98.0, 99.0,100.0,true);   // chiude in su' ma sotto il bordo -> blocca
   bool c4 = Conferma_Calc(true,101.0, 99.0,100.0,false);  // conferma spenta -> passa
   bool c5 = Conferma_Calc(false,101.0,99.0,100.0,true);   // short: chiude in giu' e sotto il bordo alto -> passa
   PrintFormat("[FVGRET][AUTOTEST] conferma: buona=%d (atteso 1) | rossa=%d (atteso 0) | sotto il bordo=%d (atteso 0) | spenta=%d (atteso 1) | short=%d (atteso 1)",
               (int)c1,(int)c2,(int)c3,(int)c4,(int)c5);
   if(!(c1 && !c2 && !c3 && c4 && c5)) falliti++;

   //--- 8. IL PAVIMENTO DELLO STOP (entry 100, stop a 99,8 = 0,2)
   double s1 = PavimentoSL_Calc(true, 100.0, 99.8, 1.0);   // pavimento 1,0 -> stop allargato a 99,0
   double s2 = PavimentoSL_Calc(true, 100.0, 97.0, 1.0);   // gia' oltre il pavimento -> invariato
   double s3 = PavimentoSL_Calc(true, 100.0, 99.8, 0.0);   // pavimento spento -> invariato
   double s4 = PavimentoSL_Calc(false,100.0,100.2, 1.0);   // short -> stop allargato a 101,0
   PrintFormat("[FVGRET][AUTOTEST] pavimento SL: %.2f (atteso 99.00) | %.2f (atteso 97.00) | %.2f (atteso 99.80) | short %.2f (atteso 101.00)",
               s1,s2,s3,s4);
   if(MathAbs(s1-99.0)>0.0001 || MathAbs(s2-97.0)>0.0001 ||
      MathAbs(s3-99.8)>0.0001 || MathAbs(s4-101.0)>0.0001) falliti++;

   //--- 9. L'ORARIO (ORA SERVER)
   bool o1 = OraAmmessa_Calc(10, 7,20);    // dentro
   bool o2 = OraAmmessa_Calc(21, 7,20);    // fuori
   bool o3 = OraAmmessa_Calc( 7, 7,20);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[FVGRET][AUTOTEST] orario: 10 in 7-20=%d (atteso 1) | 21=%d (atteso 0) | estremo 7=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(o1 && !o2 && o3 && o4)) falliti++;

   Print("[FVGRET][AUTOTEST] esito motore: ", (falliti==0
         ? "NOVE BLOCCHI SU NOVE, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files) -- blocco standard ABTG
//  Formato per riga (separatore ';'):
//    YYYY.MM.DD HH:MM ; Impatto ; Valuta ; Titolo
//  Impatto: High/Medium/Low oppure 3/2/1.
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro di fatto spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }

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
//| Export per-trade in Common\Files (per dd_portafoglio.py).         |
//| Solo tester: in griglia ogni pass con lo stesso magic SOVRASCRIVE |
//| il file -> usare solo con pin + magic-sweep (2 celle).            |
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
   ExportTrades();
   double stats[10];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
   //--- le tre colonne che servono per rispondere "va bene per una prop?"
   stats[7] = gWorstDayPct;                             // Peggior Giornata % (negativo)
   stats[8] = TesterStatistics(STAT_MAX_CONLOSSES);     // Perdite Consecutive Max
   stats[9] = TesterStatistics(STAT_CONLOSSMAX);        // Serie Perdente Peggiore (denaro)
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
                                (int)pass, data[0], data[1], data[2], data[3], data[4],
                                data[5], data[6], data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
