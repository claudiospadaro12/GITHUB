//+------------------------------------------------------------------+
//|                                        ABTG_VolExpBreak.mq5      |
//|                                                                  |
//|  EA "VOLATILITY EXPANSION BREAKOUT" - MT5 - TUTTO-IN-UNO         |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  DA DOVE VIENE (attribuzione obbligatoria)                       |
//|    Porting del Pine Script "Volatility Momentum Breakout          |
//|    Strategy" di cryptechcapital (TradingView dJe0bGvQ,           |
//|    scaricato il 13/09/2026, NESSUNA licenza dichiarata nel       |
//|    sorgente [INCERTO]).                                          |
//|    https://www.tradingview.com/script/dJe0bGvQ-                  |
//|    Copia fedele del sorgente in casa:                            |
//|      backtest_pipeline/caccia_strategie/biblioteca/sorgenti/     |
//|      VolatilityMomentumBreakout_cryptechcapital-NOLICENSE_       |
//|      tvdJe0bGvQ_2026-09-13.pine                                  |
//|    SPEC da cui nasce questo file (paragrafo 8, candidato C1):    |
//|      report/CACCIA_STOP_STRUTTURALE_2026-09-13.md                |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in       |
//|  forward finche' un round a TICK REALI non lo promuove.          |
//|  MAGIC 775301 -- blocco 7753xx VERGINE, verificato col grep      |
//|  repo-wide (.git escluso) il 13/09/2026: ZERO occorrenze di      |
//|  775300/775301/775302/775303 e ZERO occorrenze di qualunque      |
//|  7753xx in tutto il repository.                                  |
//|                                                                  |
//|  LA TESI IN UNA RIGA                                             |
//|    Quando il prezzo CHIUDE oltre il massimo (o il minimo) delle  |
//|    ultime N barre di una quantita' che vale gia' una frazione    |
//|    di ATR, quella non e' un'oscillazione dentro il range: e'     |
//|    un'espansione di volatilita' con direzione. Si entra con lei. |
//|                                                                  |
//|  IL MOTORE -- UNA CONDIZIONE SOLA, E BASTA                       |
//|    long  : close[1] > Highest(high, InpLookback)[2..] + kBreak*ATR|
//|    short : close[1] < Lowest (low , InpLookback)[2..] - kBreak*ATR|
//|    Nessun altro AND costitutivo. I filtri dell'autore (EMA50 e   |
//|    RSI50) ci sono ma nascono SPENTI: vedi sotto.                 |
//|                                                                  |
//|  >>> ANCORA UNICA -- E' LA RAGIONE PER CUI QUESTO EA ESISTE <<<  |
//|    STOP   = entry -/+ InpKStop * ATR(InpAtrPeriod)               |
//|             piu' il PAVIMENTO InpMinSLPts (lezione R109).        |
//|    TARGET = entry +/- R * InpTP_RR,  dove R = LA DISTANZA VERA   |
//|             DELLO STOP (quella dopo il pavimento, non quella     |
//|             grezza).                                             |
//|    Cioe' il target e' espresso in UNITA' DELLO STOP: se lo stop  |
//|    si allarga, il target si allarga con lui e l'attesa in R non  |
//|    cambia per costruzione aritmetica. E' la stessa forma di      |
//|    ABTG_AtrExhaustVol (r.647-649) e di ABTG_DAX_Apertura_EU      |
//|    (r.1070).                                                     |
//|                                                                  |
//|  >>> PERCHE' R E' LO STOP *DOPO* IL PAVIMENTO, E NON PRIMA <<<   |
//|    La SPEC del dossier scrive "TARGET = entry +/- (kStop x ATR)  |
//|    x InpTP_RR", cioe' ancorato allo stop GREZZO. Qui si e'       |
//|    scelto lo stop VERO, e lo scostamento e' dichiarato perche'   |
//|    cambia i numeri: se il pavimento morde e il target restasse   |
//|    ancorato al grezzo, il rapporto rischio/rendimento effettivo  |
//|    NON sarebbe piu' InpTP_RR -- e l'ancora unica, che e' tutta   |
//|    la ragione di questo candidato, si romperebbe proprio nelle   |
//|    barre in cui l'ATR e' piu' piccolo. Con InpMinSLPts = 0       |
//|    (default) le due formule coincidono alla cifra.               |
//|                                                                  |
//|  QUANTE VOLTE IL PAVIMENTO HA MORSO LO DICE IL CSV.              |
//|    Non e' un dettaglio: se il pavimento morde spesso, la cella   |
//|    "InpKStop = 1,0" non sta misurando 1,0 ATR, sta misurando il  |
//|    pavimento, e due celle basse diventano LA STESSA CELLA. Il    |
//|    contatore esce come colonna dell'OptFrame (Pavimento SL       |
//|    Morso): un asse degenere si vede, non si suppone.             |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Le condizioni si leggono sulla      |
//|  barra [1] (l'ultima chiusa) e il canale di rottura si legge     |
//|  dalle barre [2 .. 1+InpLookback]: la barra di segnale NON entra |
//|  nel proprio canale (e' il "ta.highest(high[1], lookback)"       |
//|  dell'autore) e NESSUNA barra in formazione entra nel calcolo.   |
//|  Niente ridipintura, per costruzione. L'ingresso parte           |
//|  all'apertura della barra nuova.                                 |
//|                                                                  |
//|  NIENTE FLAT DI FINE SEDUTA, ED E' VOLUTO.                       |
//|  Questo e' un motore ad ANCORA UNICA: l'unico meccanismo di      |
//|  uscita e' SL / TP in unita' di R. Un orologio che chiude a      |
//|  fine giornata ruberebbe i target piu' lontani e romperebbe      |
//|  l'invarianza in R proprio in cima alla scala di InpKStop (e'    |
//|  quello che succede a ABTG_HVAncora col flat delle 21:00).       |
//|  L'unica chiusura d'orologio che esiste qui e' InpFridayClose,   |
//|  che nasce SPENTA e serve a non tenere un CFD indice aperto sul  |
//|  gap del weekend.                                                |
//|                                                                  |
//|  I FILTRI DELL'AUTORE SONO PORTATI, MA SPENTI.                   |
//|  Il Pine mette in AND col segnale una EMA(50) e un RSI(14)>50.   |
//|  Il dossier li classifica "filtri appiccicati" e chiede di       |
//|  portarli spenti, accendendoli solo in un round dedicato. Qui    |
//|  sono due input con default false: con i default questo EA e' il |
//|  Pine SENZA i due filtri, ed e' dichiarato -- non e' il Pine     |
//|  tradotto alla lettera.                                          |
//|                                                                  |
//|  IL RISCHIO E' IL NOSTRO, NON QUELLO DELL'AUTORE.                |
//|  Il Pine dichiara un "riskPercent 2%" che nel suo codice non     |
//|  viene mai usato (la taglia esce da default_qty_type =           |
//|  percent_of_equity): e' una manopola INERTE, e non si porta.     |
//|  Qui la taglia esce da InpRiskPercent con lo stesso LotByRisk    |
//|  degli altri EA ABTG. Default 0,65 = contratto di casa.          |
//|                                                                  |
//|  >>> CLASSE 228 -- IL PAVIMENTO DEL LOTTO, DICHIARATO <<<        |
//|  Non si puo' evitare per costruzione: se il lotto calcolato      |
//|  scende sotto SYMBOL_VOLUME_MIN, MathMax lo ALZA e il rischio    |
//|  vero supera InpRiskPercent. E la quantizzazione al passo del    |
//|  volume (0,10 su U30USD e NASUSD, misurata sul CSV storico -     |
//|  DIARIO 17/08/2026) taglia il lotto VERSO IL BASSO, e taglia di  |
//|  piu' quando il lotto e' piccolo, cioe' quando lo stop e' largo. |
//|  QUINDI: su un asse che allarga lo stop la quantizzazione ABBASSA|
//|  il rischio vero in modo SISTEMATICO e crescente. Un asse su     |
//|  InpKStop letto su un conto piccolo mostrerebbe "edge che si     |
//|  diluisce" anche se l'edge in R fosse perfettamente piatto.      |
//|  Non e' correggibile qui dentro (il passo del volume e' del      |
//|  broker): si DICHIARA e si MISURA. Questo EA:                    |
//|    (a) scrive nel log lotto voluto / lotto piazzato / rischio    |
//|        voluto / rischio VERO / fattore, ogni volta che il        |
//|        pavimento ALZA (Regola A della classe 228);               |
//|    (b) conta le volte in cui la quantizzazione TAGLIA il lotto   |
//|        di piu' del 5%, e la esporta come colonna dell'OptFrame;  |
//|    (c) chiede, nel file prova, un DEPOSITO da 100.000, dove il   |
//|        taglio misurato scende sotto l'1% (classe 229: un difetto |
//|        che dipende dalla taglia si toglie misurando alla taglia  |
//|        giusta, non misurando meglio).                            |
//|                                                                  |
//|  IL COSTO SI MISURA IN PERCENTUALE DELLO STOP (R55), NON IN      |
//|  PUNTI: InpMaxSpreadPctOfStop. Un cancello in punti fissi mente  |
//|  cambiando simbolo e mente lungo un asse che cambia lo stop --   |
//|  ed e' esattamente l'asse di questo motore.                      |
//|                                                                  |
//|  DOVE DEVE GIRARE: INDICI (NASUSD, U30USD, D30EUR), M30.         |
//|  M15 solo con InpKStop >= 2,5, e MAI su D30EUR (frontiera del    |
//|  costo, dossier par. 4). Nessun calcolo assume il forex: la      |
//|  distanza dello stop e' in PREZZO, il lotto esce da              |
//|  OrderCalcProfit (che converte in valuta conto) e il ripiego e'  |
//|  tick value / tick size. Le soglie "in punti" sono PUNTI MT5     |
//|  (_Point): su U30USD e NASUSD 1 punto indice = 100 punti MT5.    |
//|  >>> LIMITE DICHIARATO DAL DOSSIER (par. 9.6): l'ATR M30 sul     |
//|      FOREX non e' misurato, quindi su GBPUSD/EURUSD questo       |
//|      motore NON ha un conto di costo e non si propone li'.       |
//|                                                                  |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO      |
//|  rispetto all'ora italiana (DAX 09:00 IT = 08:00 server).        |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le    |
//|  stringhe, niente emoji (convenzione degli altri EA ABTG).       |
//|  >>> NON COMPILATO E NON TESTATO DA CHI HA SCRITTO IL FILE:      |
//|      l'ambiente di scrittura non ha MetaEditor ne' lo Strategy   |
//|      Tester. Va compilato in MetaEditor (F7) e validato nel      |
//|      tester A TICK REALI prima di qualunque lettura.             |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - porting da cryptechcapital (TradingView dJe0bGvQ)"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a un EA non migrato.
//    Il default true NON cambia niente da solo: se il Guardian non gira su
//    questo conto -- e nel Strategy Tester, dove le sue GlobalVariable non
//    esistono -- la guardia lascia passare tutto (fail-open totale), quindi
//    i backtest restano confrontabili con quelli degli altri EA.
//    Non tocca MAI le posizioni gia' aperte, i parziali, il breakeven e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
//    >>> NASCE COL GUARDIAN DENTRO. La lezione piu' cara del 12/09/2026 e'
//        che ABTG_EMA200 -- la PRIMA sedia -- gira in campo con un binario
//        che non ha nemmeno l'input (fail-open doppio). Un EA nuovo non ha
//        nessuna scusa per nascere senza.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//
//  I NOVE DELLA SPEC, con la mappatura esplicita nome-SPEC -> nome-EA:
//     kBreak                -> InpKBreak
//     kStop                 -> InpKStop
//     InpTP_RR              -> InpTP_RR
//     InpAtrPeriod          -> InpAtrPeriod
//     InpLookback           -> InpLookback
//     InpRiskPercent        -> InpRiskPercent
//     InpMinSLPts           -> InpMinSLPts
//     InpMaxSpreadPctOfStop -> InpMaxSpreadPctOfStop
//     InpMagic              -> InpMagic
//
//  >>> E GLI INPUT SONO PIU' DI NOVE, ED E' UNA CONTRADDIZIONE DELLA
//      SPEC, NON UNA LICENZA CHE MI SONO PRESO. La stessa SPEC chiede
//      nella riga sopra la "GESTIONE nostra (parziale a 1R, breakeven,
//      runner a 2R)" e chiede di portare EMA50/RSI50 "SPENTI": ne' una
//      gestione ne' un filtro spegnibile possono esistere senza i loro
//      input, e la regola di casa vuole ogni comportamento dietro un
//      input con default neutro. I NOVE sono la lista del MOTORE; gli
//      altri sono gestione, filtri spenti, costo e igiene. Tutti quelli
//      in piu' nascono a un default che NON cambia il motore.
//==================================================================
input group "=== MOTORE (costitutivo: non si spegne) ==="
input double InpKBreak      = 1.5;   // kBreak: rottura oltre il canale di X * ATR (autore: 1.5). 0 = Donchian puro
input int    InpLookback    = 20;    // Barre del canale di rottura (autore: 20)
input int    InpAtrPeriod   = 14;    // Periodo ATR (autore: 14)
//  DIREZIONE COSTITUTIVA: non esiste nessun input di lato. Il segnale
//  decide da solo se e' long o short, e i due lati girano SEMPRE insieme.
//  >>> E' cosi' perche' lo chiede la SPEC alla lettera. Va pero' detto
//      che la REGOLA DEI DUE LATI del 25/08 chiede di misurare i lati
//      SEPARATI: con questo EA non si puo' fare, e il giorno in cui
//      servira' andra' aggiunto un input di lato in un round dedicato.
//      Dichiarato qui perche' e' una tensione vera fra due regole di
//      casa, non una dimenticanza.

input group "=== ANCORA UNICA: stop e target (il cuore) ==="
input double InpKStop       = 1.0;   // kStop: SL = entry -/+ X * ATR (autore: 1.0). E' l'ASSE del primo round
input double InpTP_RR       = 2.0;   // TP = X volte R, con R = LA DISTANZA VERA DELLO STOP (autore: 2.0). 0 = nessun TP
input double InpMinSLPts    = 0;     // PAVIMENTO dello stop in punti MT5 (lezione R109). 0 = spento = autore

input group "=== GESTIONE NOSTRA (default = AUTORE, cioe' spenta) ==="
//  PARZIALE e BREAKEVEN sono DUE BLOCCHI INDIPENDENTI, e non e' una
//  raffinatezza: su ABTG_Nasdaq_Live5m il breakeven stava DENTRO il ramo
//  della parziale, e al lotto minimo la parziale si disarmava portandosi
//  dietro anche il breakeven (lezione 07/08/2026, gia' riparata li'; su
//  ABTG_AtrExhaustVol la stessa riparazione e' nel commento della PTE
//  del 04/08). Qui i due non si toccano proprio: si puo' avere il
//  breakeven senza parziale e viceversa.
input double InpTP1_RR      = 1.0;   // Parziale: primo obiettivo in R
input double InpTP1Pct      = 0;     // % chiusa al primo obiettivo (0 = parziale SPENTO = autore)
input bool   InpBreakeven   = false; // Stop in pari (INDIPENDENTE dalla parziale)
input double InpBE_R        = 1.0;   // A quanti R lo stop va in pari

input group "=== FILTRI DELL'AUTORE, PORTATI SPENTI (round dedicato) ==="
input bool   InpUseEmaFilter = false; // Filtro EMA dell'autore: long solo sopra la EMA, short solo sotto
input int    InpEmaPeriod    = 50;    // Periodo EMA (autore: 50)
input bool   InpUseRsiFilter = false; // Filtro RSI dell'autore: long solo con RSI > soglia, short sotto
input int    InpRsiPeriod    = 14;    // Periodo RSI (autore: 14)
input double InpRsiLevel     = 50.0;  // Soglia RSI (autore: 50)

input group "=== COSTO (R55: in % dello stop, mai in punti fissi) ==="
input double InpMaxSpreadPctOfStop = 2.5; // Spread <= X% dello stop, altrimenti si salta. 2.5% = la frontiera dei 40x

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay = 3;  // Max ingressi al giorno (C6: obbligatorio, 0 = illimitato)
input bool   InpUseHourFilter   = false; // Filtro orario sulla barra di segnale (ORA SERVER)
input int    InpHourStart       = 14; // Ora SERVER di inizio (inclusa). BCM: 14 = 15:00 IT = cassa USA
input int    InpHourEnd         = 20; // Ora SERVER di fine (inclusa)
input bool   InpFridayClose     = false; // Venerdi': chiudi tutto oltre l'ora e non riaprire (0 = autore)
input int    InpFridayCloseHour = 20; // Ora SERVER del venerdi' oltre cui chiudo

input group "=== Rischio ==="
input double InpRiskPercent = 0.65;   // Rischio per trade, % del SALDO. 0,65 = contratto di casa

input group "=== Generali ==="
input string InpComment  = "VOLEXP"; // Commento sugli ordini
input long   InpMagic    = 775301;   // Numero magico (blocco 7753xx: VERGINE, grep repo-wide 13/09/2026)
input bool   InpVerbose  = true;     // Messaggi nel log
input bool   InpAutoTest = true;     // Stampa le righe [VOLEXP][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//  (tutte le globali stanno QUI, PRIMA di ogni funzione che le legge:
//   in MQL5 le funzioni si possono chiamare in avanti, le VARIABILI
//   GLOBALI no -- classe 230 del 11/09/2026.)
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hAtr = INVALID_HANDLE;
int      hEma = INVALID_HANDLE;
int      hRsi = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gTradesToday = 0;

//--- la posizione in corso: ticket, R INIZIALE e stato della parziale.
//    Si "adotta" in ManageAll: se il ticket trovato non e' quello che ho
//    in memoria, e' una posizione nuova e le si legge R adesso, mentre lo
//    stop e' ancora quello originale.
//    [LIMITE DICHIARATO: dopo un riavvio del terminale a posizione aperta
//     e stop gia' mosso, R viene riletto dallo stop MOSSO e quindi risulta
//     piu' piccolo del vero. Nel tester non succede mai; in forward e' un
//     caso raro e non silenzioso, perche' il log scrive l'adozione.]
ulong    gPosTicket   = 0;
double   gPosR        = 0.0;
bool     gPosParzFatta = false;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

//--- CONTATORI DIAGNOSTICI. Escono come colonne dell'OptFrame: servono a
//    capire se l'asse ha davvero morso o se il round ha misurato un tappo.
long gCntSegnali       = 0;   // rotture grezze viste (il denominatore)
long gCntPavimentoSL   = 0;   // volte in cui InpMinSLPts ha allargato lo stop
long gCntLottoAlzato   = 0;   // volte in cui il pavimento del LOTTO ha alzato il rischio (classe 228)
long gCntLottoTagliato = 0;   // volte in cui la quantizzazione ha tagliato il lotto oltre il 5%
long gCntSpreadGate    = 0;   // rifiuti del cancello di spread (R55)
long gCntGuardian      = 0;   // rifiuti del Guardian

void Log(string m){ if(InpVerbose) Print("[VOLEXP] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| ROTTURA AL RIALZO.                                                |
//|   close della barra di segnale > massimo del canale + k * ATR     |
//| Confronto STRETTO come l'autore (close > longBreakoutLevel).      |
//| atr<=0 o canale<=0 = dato non utilizzabile -> NIENTE segnale: il  |
//| canale e l'ATR sono COSTITUTIVI, non filtri, e un motore senza il |
//| suo dato non esiste.                                              |
//| k puo' valere 0: allora e' una rottura Donchian pura, ed e' un    |
//| caso legittimo (sara' la cella di controllo di un round futuro).  |
//+------------------------------------------------------------------+
bool RotturaLong_Calc(const double close1, const double canaleAlto,
                      const double atr, const double k)
  {
   if(canaleAlto<=0 || atr<=0 || k<0) return(false);
   return(close1 > canaleAlto + k*atr);
  }

//+------------------------------------------------------------------+
//| ROTTURA AL RIBASSO. Specchio esatto della precedente.             |
//+------------------------------------------------------------------+
bool RotturaShort_Calc(const double close1, const double canaleBasso,
                       const double atr, const double k)
  {
   if(canaleBasso<=0 || atr<=0 || k<0) return(false);
   return(close1 < canaleBasso - k*atr);
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (lezione R109). Se lo stop e' piu' vicino    |
//| del pavimento, lo stop si ALLARGA al pavimento (semantica di      |
//| "minimo"), non si salta il trade. pavimento<=0 = spento.          |
//| Serve perche' con un ATR schiacciato InpKStop*ATR puo' nascere a  |
//| pochi punti dal prezzo: li' il lotto per rischio esplode e lo     |
//| slippage si mangia l'operazione intera.                           |
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
//| CANCELLO DI SPREAD IN % DELLO STOP (R55).                         |
//| true = si puo' operare. Un cancello in punti fissi mente cambiando|
//| simbolo E mente lungo un asse che cambia l'ampiezza dello stop:   |
//| qui la soglia si muove insieme allo stop, per costruzione.        |
//| pctMax<=0 e' vietato da OnInit: qui rispondo false per non        |
//| lasciare passare niente per sbaglio.                              |
//+------------------------------------------------------------------+
bool SpreadGate_Calc(const double spreadPrezzo, const double slDist, const double pctMax)
  {
   if(slDist<=0 || pctMax<=0) return(false);
   if(spreadPrezzo<0) return(false);
   return(spreadPrezzo <= (pctMax/100.0)*slDist);
  }

//+------------------------------------------------------------------+
//| TARGET dall'ancora: entry +/- R * rr. rr<=0 = nessun TP (0).      |
//| R e' la distanza VERA dello stop (dopo il pavimento).             |
//+------------------------------------------------------------------+
double TargetDaR_Calc(const bool isLong, const double entry,
                      const double R, const double rr)
  {
   if(R<=0 || rr<=0) return(0.0);
   return(isLong ? entry+R*rr : entry-R*rr);
  }

//+------------------------------------------------------------------+
//| Filtro orario -- nucleo. Estremi INCLUSI. Gestisce anche la       |
//| fascia a cavallo della mezzanotte (start>end).                    |
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
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpLookback<1)
     { Print("ERRORE: InpLookback deve essere >= 1: senza canale non c'e' rottura."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpKBreak<0)
     { Print("ERRORE: InpKBreak non puo' essere negativo (0 = rottura Donchian pura)."); return(INIT_FAILED); }
   if(InpKStop<=0)
     { Print("ERRORE: InpKStop deve essere > 0: senza stop in ATR non e' questo motore."); return(INIT_FAILED); }
   if(InpTP_RR<0)
     { Print("ERRORE: InpTP_RR non puo' essere negativo (0 = nessun TP)."); return(INIT_FAILED); }
   if(InpMinSLPts<0)
     { Print("ERRORE: InpMinSLPts non puo' essere negativo (0 = pavimento spento)."); return(INIT_FAILED); }
   if(InpTP1Pct<0 || InpTP1Pct>=100)
     { Print("ERRORE: InpTP1Pct deve stare fra 0 (spento) e 99."); return(INIT_FAILED); }
   if(InpTP1Pct>0 && InpTP1_RR<=0)
     { Print("ERRORE: con la parziale accesa InpTP1_RR deve essere > 0."); return(INIT_FAILED); }
   if(InpBreakeven && InpBE_R<=0)
     { Print("ERRORE: con il breakeven acceso InpBE_R deve essere > 0."); return(INIT_FAILED); }
   if(InpUseEmaFilter && InpEmaPeriod<1)
     { Print("ERRORE: InpEmaPeriod deve essere >= 1 col filtro EMA acceso."); return(INIT_FAILED); }
   if(InpUseRsiFilter && (InpRsiPeriod<1 || InpRsiLevel<=0 || InpRsiLevel>=100))
     { Print("ERRORE: parametri RSI fuori scala col filtro RSI acceso."); return(INIT_FAILED); }
   if(InpMaxSpreadPctOfStop<=0)
     { Print("ERRORE: InpMaxSpreadPctOfStop deve essere > 0 (R55: il cancello di spread e' in % dello stop)."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpFridayCloseHour<0 || InpFridayCloseHour>23)
     { Print("ERRORE: InpFridayCloseHour deve stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- gli handle dei due filtri si creano SOLO se il filtro e' acceso:
   //    un handle in piu' e' memoria e tempo in ogni passata di griglia.
   if(InpUseEmaFilter)
     {
      hEma = iMA(_Symbol, gTF, InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE);
      if(hEma==INVALID_HANDLE){ Print("ERRORE: handle EMA."); return(INIT_FAILED); }
     }
   if(InpUseRsiFilter)
     {
      hRsi = iRSI(_Symbol, gTF, InpRsiPeriod, PRICE_CLOSE);
      if(hRsi==INVALID_HANDLE){ Print("ERRORE: handle RSI."); return(INIT_FAILED); }
     }

   //--- DICHIARAZIONE, non correzione: se qualcosa e' acceso, la cella
   //    NON e' la cella "autore". Non lo spegne l'EA (sarebbe un default
   //    nascosto): lo DICE, e il file prova lo pinna.
   if(InpUseEmaFilter || InpUseRsiFilter || InpTP1Pct>0 || InpBreakeven ||
      InpMinSLPts>0 || InpUseHourFilter || InpFridayClose)
      Log("ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' la cella AUTORE del porting.");

   if(InpAutoTest) AutoTestVolExpBreak();

   Log(StringFormat("avviato su %s %s. canale %d barre, rottura %.2f x ATR(%d), SL %.2f x ATR + pavimento %.0f pti MT5, TP %.2f R, spread <= %.2f%% dello stop, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()),
       InpLookback, InpKBreak, InpAtrPeriod, InpKStop, InpMinSLPts,
       InpTP_RR, InpMaxSpreadPctOfStop, InpRiskPercent,
       InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEma!=INVALID_HANDLE) IndicatorRelease(hEma);
   if(hRsi!=INVALID_HANDLE) IndicatorRelease(hRsi);

   //--- il riepilogo dei contatori: nel test SINGOLO si legge qui, in
   //    ottimizzazione si legge nelle colonne dell'OptFrame.
   PrintFormat("[VOLEXP][CONTATORI] segnali %I64d | pavimento SL morso %I64d | lotto ALZATO (228) %I64d | lotto tagliato oltre 5%% %I64d | spread gate %I64d | guardian %I64d",
               gCntSegnali, gCntPavimentoSL, gCntLottoAlzato,
               gCntLottoTagliato, gCntSpreadGate, gCntGuardian);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   if(FridayCloseCheck()) return;      // venerdi' oltre l'ora: chiudo e non riapro

   //--- Sta QUI e non dopo il filtro della nuova barra: su M30 la caduta
   //    peggiore di giornata succede in mezzo a una candela.
   AggiornaPeggiorGiornata();
   ManageAll();                        // parziale / pari: a ogni tick

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
//| Il giro di una barra nuova.                                       |
//| Nessuno stato da aggiornare prima: il canale di rottura si        |
//| ricalcola ogni volta dalle barre [2 .. 1+InpLookback], non c'e'   |
//| memoria da tenere e quindi non ci sono buchi dopo un trade.       |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   if(CountPositions()>0) return;                       // una posizione alla volta per magic
   if(InpMaxTradesPerDay>0 && gTradesToday>=InpMaxTradesPerDay) return;
   if(!OraOK()) return;

   //--- il canale di rottura: massimo/minimo delle InpLookback barre che
   //    PRECEDONO la barra di segnale. Partenza dallo shift 2, cioe' la
   //    barra [1] NON entra nel proprio canale (e' "high[1]" dell'autore)
   //    e la barra [0], in formazione, non e' nemmeno guardata.
   if(Bars(_Symbol,gTF) < InpLookback+4) return;
   int idxH = iHighest(_Symbol,gTF,MODE_HIGH,InpLookback,2);
   int idxL = iLowest (_Symbol,gTF,MODE_LOW ,InpLookback,2);
   if(idxH<0 || idxL<0) return;
   double canaleAlto  = iHigh(_Symbol,gTF,idxH);
   double canaleBasso = iLow (_Symbol,gTF,idxL);
   double c1          = iClose(_Symbol,gTF,1);
   if(canaleAlto<=0 || canaleBasso<=0 || c1<=0) return;

   double atr = AtrVal();
   if(atr<=0) return;                                   // senza ATR non c'e' misura di espansione

   bool segLong  = RotturaLong_Calc (c1, canaleAlto , atr, InpKBreak);
   bool segShort = RotturaShort_Calc(c1, canaleBasso, atr, InpKBreak);
   if(!segLong && !segShort) return;

   gCntSegnali++;                                       // il denominatore, prima di ogni filtro

   //--- i due filtri dell'autore, SPENTI di default. Un filtro senza dati
   //    NON inventa un veto (al contrario del motore, che senza dati non
   //    esiste): e' la convenzione di casa.
   if(segLong  && !FiltriAutoreOK(true,  c1)) return;
   if(segShort && !FiltriAutoreOK(false, c1)) return;

   //--- long e short non possono essere veri insieme (canaleAlto >=
   //    canaleBasso per costruzione), ma l'ordine e' comunque esplicito.
   if(segLong)  { Enter(true,  atr); return; }
   if(segShort) { Enter(false, atr); }
  }

//==================================================================
//  LETTURA DEI DATI (il pensiero sta nel nucleo puro)
//==================================================================
double AtrVal()
  {
   double a[1];
   if(CopyBuffer(hAtr,0,1,1,a)!=1) return(0);
   return(a[0]);
  }

//+------------------------------------------------------------------+
//| I DUE FILTRI DELL'AUTORE, letti sulla barra di segnale [1].       |
//| Spenti = true (non filtrano niente). A dati mancanti = true: un   |
//| FILTRO che non ha i suoi dati non deve inventare un veto.         |
//+------------------------------------------------------------------+
bool FiltriAutoreOK(const bool isLong, const double close1)
  {
   if(InpUseEmaFilter && hEma!=INVALID_HANDLE)
     {
      double e[1];
      if(CopyBuffer(hEma,0,1,1,e)==1 && e[0]>0)
        {
         if(isLong  && close1 <= e[0]) return(false);
         if(!isLong && close1 >= e[0]) return(false);
        }
     }
   if(InpUseRsiFilter && hRsi!=INVALID_HANDLE)
     {
      double r[1];
      if(CopyBuffer(hRsi,0,1,1,r)==1 && r[0]>0)
        {
         if(isLong  && r[0] <= InpRsiLevel) return(false);
         if(!isLong && r[0] >= InpRsiLevel) return(false);
        }
     }
   return(true);
  }

//--- Orario della BARRA DI SEGNALE, in ORA SERVER (mai l'ora italiana:
//    regola di casa, il server BCM e' un'ora indietro).
bool OraOK()
  {
   if(!InpUseHourFilter) return(true);
   MqlDateTime t; TimeToStruct(iTime(_Symbol,gTF,1), t);
   return(OraAmmessa_Calc(t.hour, InpHourStart, InpHourEnd));
  }

//==================================================================
//  INGRESSO
//==================================================================
//+------------------------------------------------------------------+
//| Apre a mercato. Lo stop nasce dall'ATR (InpKStop), poi passa il   |
//| pavimento R109, poi lo STOPS_LEVEL del broker; il target nasce    |
//| dallo stop VERO (ancora unica).                                   |
//| Ritorna true SOLO se l'ordine e' partito davvero.                 |
//+------------------------------------------------------------------+
bool Enter(const bool isLong, const double atr)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0 || atr<=0) return(false);
   double entry = isLong ? ask : bid;

   //--- STOP dalla fonte: InpKStop x ATR della barra di segnale.
   double slGrezzo = isLong ? (entry - InpKStop*atr) : (entry + InpKStop*atr);
   double pavimento = InpMinSLPts*_Point;
   double sl = PavimentoSL_Calc(isLong, entry, slGrezzo, pavimento);
   if(MathAbs(sl-slGrezzo) > _Point/2.0) gCntPavimentoSL++;   // il pavimento ha morso: si conta

   sl = NormalizePrice(sl);
   double R = isLong ? (entry-sl) : (sl-entry);
   if(R<=0){ Log("geometria SL non valida (distanza <= 0): salto."); return(false); }

   //--- CANCELLO DI SPREAD IN % DELLO STOP (R55). Sta PRIMA del lotto:
   //    se il costo e' fuori misura non serve nemmeno calcolare la taglia.
   double spreadPrezzo = ask-bid;
   if(!SpreadGate_Calc(spreadPrezzo, R, InpMaxSpreadPctOfStop))
     {
      gCntSpreadGate++;
      Log(StringFormat("spread %s oltre il %.2f%% dello stop (%s): salto (R55).",
          DoubleToString(spreadPrezzo,_Digits), InpMaxSpreadPctOfStop,
          DoubleToString(R,_Digits)));
      return(false);
     }

   double minDist = (double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(R<=minDist)
     { Log("SL troppo vicino al prezzo (stops level): salto."); return(false); }

   //--- TARGET: L'ANCORA UNICA. R e' la distanza VERA dello stop.
   double tp = TargetDaR_Calc(isLong, entry, R, InpTP_RR);
   if(tp>0)
     {
      tp = NormalizePrice(tp);
      double distTp = isLong ? (tp-entry) : (entry-tp);
      if(distTp<=minDist){ Log("TP dentro lo stops level: lo tolgo e lascio la gestione."); tp=0; }
     }

   double lotVoluto=0, perdPerLotto=0;
   double lot = LotByRisk(R, lotVoluto, perdPerLotto);
   if(lot<=0){ Log("lotto nullo: salto."); return(false); }
   DichiaraScostamentoLotto(lot, lotVoluto, perdPerLotto);

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
   //    Sta QUI, immediatamente prima dell'invio, e non in cima all'imbuto:
   //    cosi' l'unica cosa che cambia e' che l'ordine non parte -- come un
   //    rifiuto del broker, caso gia' gestito.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_VolExpBreak"))
     { gCntGuardian++; return(false); }

   string cm = InpComment + (isLong ? " L" : " S");
   bool ok = isLong ? gTrade.Buy (lot,_Symbol,ask,sl,tp,cm)
                    : gTrade.Sell(lot,_Symbol,bid,sl,tp,cm);
   if(!ok)
     {
      Log(StringFormat("apertura fallita: %s (retcode %d)",
          gTrade.ResultRetcodeDescription(), (int)gTrade.ResultRetcode()));
      return(false);
     }

   gTradesToday++;
   Log(StringFormat("%s @ %s SL %s TP %s lot %.2f (R %s = %.2f x ATR %s)",
       isLong?"LONG":"SHORT",
       DoubleToString(entry,_Digits), DoubleToString(sl,_Digits),
       DoubleToString(tp,_Digits), lot, DoubleToString(R,_Digits),
       InpKStop, DoubleToString(atr,_Digits)));
   return(true);
  }

//+------------------------------------------------------------------+
//| CLASSE 228, REGOLA A -- IL PAVIMENTO DEL LOTTO DEVE PARLARE.      |
//| Non corregge niente: DICHIARA. Un rischio che sfora dichiarato e' |
//| un problema di taglia; un rischio che sfora in silenzio e' un     |
//| problema di fiducia.                                              |
//| Due scostamenti, e sono DIVERSI:                                  |
//|  (a) il pavimento ALZA il lotto sopra quello voluto -> il rischio |
//|      vero e' PIU' ALTO di InpRiskPercent (il caso della classe);  |
//|  (b) la quantizzazione al passo del volume TAGLIA il lotto -> il  |
//|      rischio vero e' PIU' BASSO. E' il caso che rovina un ASSE    |
//|      SULLO STOP, perche' taglia di piu' dove lo stop e' largo.    |
//+------------------------------------------------------------------+
void DichiaraScostamentoLotto(const double lot, const double lotVoluto, const double perdPerLotto)
  {
   if(lotVoluto<=0 || perdPerLotto<=0) return;
   double saldo = AccountInfoDouble(ACCOUNT_BALANCE);
   if(saldo<=0) return;
   double rischioVero = 100.0*lot*perdPerLotto/saldo;

   if(lot > lotVoluto*1.0001)
     {
      gCntLottoAlzato++;
      Log(StringFormat("PAVIMENTO DEL LOTTO (classe 228): voluto %.4f, piazzato %.2f, rischio voluto %.2f%%, rischio VERO %.2f%%, fattore %.2fx.",
          lotVoluto, lot, InpRiskPercent, rischioVero, lot/lotVoluto));
      return;
     }
   if(lot < lotVoluto*0.95)
     {
      gCntLottoTagliato++;
      Log(StringFormat("QUANTIZZAZIONE DEL LOTTO: voluto %.4f, piazzato %.2f, rischio voluto %.2f%%, rischio VERO %.2f%% (taglio %.1f%%). Su un asse che allarga lo stop questo taglio CRESCE: leggere la colonna dell'OptFrame prima di concludere che l'edge si diluisce.",
          lotVoluto, lot, InpRiskPercent, rischioVero, 100.0*(1.0-lot/lotVoluto)));
     }
  }

//==================================================================
//  GESTIONE DELLA POSIZIONE
//==================================================================
//+------------------------------------------------------------------+
//| Parziale al primo obiettivo e stop in pari -- DUE BLOCCHI         |
//| INDIPENDENTI. Gira a OGNI tick: gli obiettivi si toccano in mezzo |
//| alla barra.                                                       |
//|                                                                   |
//| NOTA SUL DEFAULT: con InpTP1Pct=0 e InpBreakeven=false questo     |
//| blocco NON fa niente. E' voluto: la cella "autore" del round      |
//| dev'essere SL e TP a 2R e basta, come il Pine. Il "runner a 2R"   |
//| della SPEC e' il TP dell'ordine, non un pezzo di questo codice.   |
//+------------------------------------------------------------------+
void ManageAll()
  {
   if(InpTP1Pct<=0 && !InpBreakeven) return;

   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   if(bid<=0 || ask<=0) return;

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

      //--- ADOZIONE: posizione nuova -> le si legge R ADESSO, mentre lo
      //    stop e' ancora quello originale. Se non lo facessi, dopo il
      //    breakeven R diventerebbe 0 e il primo obiettivo si sposterebbe
      //    da solo: e' il difetto che ABTG_Nasdaq_Live5m tampona con un
      //    ripiego sull'ATR (r.976) invece di ricordare il numero vero.
      if(tk!=gPosTicket)
        {
         gPosTicket    = tk;
         gPosR         = isLong ? (openP-sl) : (sl-openP);
         gPosParzFatta = false;
         Log(StringFormat("adottata posizione %I64u: R iniziale %s.", tk, DoubleToString(gPosR,_Digits)));
        }
      double R = gPosR;
      if(R<=0) continue;

      //--- 1) PARZIALE al primo obiettivo. NON tocca il breakeven.
      if(InpTP1Pct>0 && !gPosParzFatta)
        {
         double tgt = isLong ? openP+R*InpTP1_RR : openP-R*InpTP1_RR;
         bool   hit = isLong ? (bid>=tgt) : (ask<=tgt);
         if(hit)
           {
            double cv = NormVol(vol*InpTP1Pct/100.0);
            if(cv>0 && cv<vol && gTrade.PositionClosePartial(tk,cv))
              {
               gPosParzFatta = true;
               Log(StringFormat("primo obiettivo (%.2f R): chiusi %.2f lotti su %.2f.", InpTP1_RR, cv, vol));
              }
            else
               Log(StringFormat("primo obiettivo (%.2f R): parziale IMPOSSIBILE al lotto %.2f (minimo/passo del broker). Il breakeven NON dipende da questo.", InpTP1_RR, vol));
           }
        }

      //--- 2) BREAKEVEN. BLOCCO SEPARATO, non annidato dentro la parziale:
      //    al lotto minimo la parziale si disarma, e prima della lezione
      //    del 07/08/2026 si portava dietro anche il breakeven (posizioni
      //    a +1,28R tornate in perdita con lo stop ancora all'originale).
      //    "Gia' fatto" si riconosce dallo stop stesso (stateless): niente
      //    flag da tenere allineato, niente stato che si perde al riavvio.
      if(InpBreakeven)
        {
         bool beFatto = isLong ? (sl>=openP-_Point/2.0) : (sl<=openP+_Point/2.0);
         if(!beFatto)
           {
            double tgtBE = isLong ? openP+R*InpBE_R : openP-R*InpBE_R;
            bool   hitBE = isLong ? (bid>=tgtBE) : (ask<=tgtBE);
            if(hitBE)
              {
               double be = NormalizePrice(openP);
               //--- mai arretrare lo stop, e mai metterlo dalla parte
               //    sbagliata del prezzo corrente.
               bool ok = isLong ? (be>sl && be<bid) : (be<sl && be>ask);
               if(ok && gTrade.PositionModify(tk,be,tp))
                  Log(StringFormat("breakeven a %.2f R: stop in pari a %s.", InpBE_R, DoubleToString(be,_Digits)));
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Venerdi' oltre l'ora: chiudo tutto e non riapro.                  |
//| L'ora e' quella del SERVER (TimeCurrent), mai quella del PC.      |
//| NASCE SPENTO: e' l'unico orologio di questo EA, e va acceso solo  |
//| quando si accetta che rompa l'invarianza in R (chiude a un        |
//| multiplo di R qualunque), cosa che su un asse sullo stop conta.   |
//+------------------------------------------------------------------+
bool FridayCloseCheck()
  {
   if(!InpFridayClose) return(false);
   MqlDateTime t; TimeToStruct(TimeCurrent(),t);
   if(t.day_of_week!=5 || t.hour<InpFridayCloseHour) return(false);
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong p=PositionGetTicket(i);
      if(p>0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==InpMagic)
         gTrade.PositionClose(p);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Quanto sono sceso OGGI rispetto all'apertura del giorno.          |
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

//+------------------------------------------------------------------+
//| Lotto dalla distanza dello stop, come negli altri EA ABTG.        |
//| PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/26): |
//| su 225JPY il tick value arriva non convertito in valuta conto e   |
//| il lotto usciva ~0, finendo SEMPRE al minimo. OrderCalcProfit     |
//| converte correttamente; il tick value resta come ripiego. Sui     |
//| simboli sani i due calcoli coincidono.                            |
//|                                                                   |
//| Restituisce anche lotVoluto (PRIMA di quantizzazione, pavimento e |
//| tetto) e perdPerLotto, perche' il chiamante possa DICHIARARE lo   |
//| scostamento invece di nasconderlo (classe 228).                   |
//+------------------------------------------------------------------+
double LotByRisk(const double slDist, double &lotVoluto, double &perdPerLotto)
  {
   lotVoluto=0; perdPerLotto=0;
   if(slDist<=0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   if(risk<=0) return(0);

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
   perdPerLotto = lossPerLot;

   double lot = risk/lossPerLot;
   lotVoluto  = lot;                              // il numero PRIMA di ogni arrotondamento

   double mn = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st = SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot = MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
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
//==================================================================
void AutoTestVolExpBreak()
  {
   int falliti=0;

   PrintFormat("[VOLEXP][AUTOTEST] canale %d | kBreak %.2f | kStop %.2f | ATR(%d) | TP %.2f R | pavimento %.0f pti | spread <= %.2f%% | %s | magic %I64d",
               InpLookback, InpKBreak, InpKStop, InpAtrPeriod, InpTP_RR,
               InpMinSLPts, InpMaxSpreadPctOfStop, _Symbol, InpMagic);

   //--- LA ROTTURA (canale alto 100, ATR 10, k 1,5 -> soglia 115)
   bool b1 = RotturaLong_Calc(116.0,100.0,10.0,1.5);   // oltre la soglia -> passa
   bool b2 = RotturaLong_Calc(115.0,100.0,10.0,1.5);   // ESATTAMENTE sulla soglia -> blocca (stretto)
   bool b3 = RotturaLong_Calc(112.0,100.0,10.0,1.5);   // sopra il canale ma sotto la soglia -> blocca
   bool b4 = RotturaLong_Calc(116.0,100.0, 0.0,1.5);   // ATR mancante -> blocca (costitutivo)
   bool b5 = RotturaLong_Calc(101.0,100.0,10.0,0.0);   // k = 0: Donchian puro -> passa
   PrintFormat("[VOLEXP][AUTOTEST] rottura long: 116=%d (atteso 1) | 115 sul bordo=%d (atteso 0) | 112=%d (atteso 0) | ATR 0=%d (atteso 0) | k=0 Donchian=%d (atteso 1)",
               (int)b1,(int)b2,(int)b3,(int)b4,(int)b5);
   if(!(b1 && !b2 && !b3 && !b4 && b5)) falliti++;

   //--- LA ROTTURA SHORT, specchio esatto (canale basso 100 -> soglia 85)
   bool s1 = RotturaShort_Calc( 84.0,100.0,10.0,1.5);  // sotto la soglia -> passa
   bool s2 = RotturaShort_Calc( 85.0,100.0,10.0,1.5);  // sul bordo -> blocca
   bool s3 = RotturaShort_Calc( 88.0,100.0,10.0,1.5);  // sotto il canale ma sopra la soglia -> blocca
   bool s4 = RotturaShort_Calc( 84.0,  0.0,10.0,1.5);  // canale mai visto -> blocca
   PrintFormat("[VOLEXP][AUTOTEST] rottura short: 84=%d (atteso 1) | 85 sul bordo=%d (atteso 0) | 88=%d (atteso 0) | canale 0=%d (atteso 0)",
               (int)s1,(int)s2,(int)s3,(int)s4);
   if(!(s1 && !s2 && !s3 && !s4)) falliti++;

   //--- I DUE LATI NON POSSONO ESSERE VERI INSIEME (canale alto >= basso).
   //    Controesempio costruito apposta: prezzo 116 con canale 100/100.
   bool d1 = RotturaLong_Calc (116.0,100.0,10.0,1.5);
   bool d2 = RotturaShort_Calc(116.0,100.0,10.0,1.5);
   PrintFormat("[VOLEXP][AUTOTEST] esclusivita': long=%d short=%d (atteso 1 e 0: non esiste una barra che rompe da tutte e due le parti)",
               (int)d1,(int)d2);
   if(!(d1 && !d2)) falliti++;

   //--- IL PAVIMENTO DELLO STOP (entry 100, stop grezzo a 99,8 = 0,2)
   double f1 = PavimentoSL_Calc(true, 100.0, 99.8, 1.0);   // pavimento 1,0 -> allargato a 99,0
   double f2 = PavimentoSL_Calc(true, 100.0, 97.0, 1.0);   // gia' oltre il pavimento -> invariato
   double f3 = PavimentoSL_Calc(true, 100.0, 99.8, 0.0);   // pavimento spento -> invariato
   double f4 = PavimentoSL_Calc(false,100.0,100.2, 1.0);   // short -> allargato a 101,0
   PrintFormat("[VOLEXP][AUTOTEST] pavimento SL: %.2f (atteso 99.00) | %.2f (atteso 97.00) | %.2f (atteso 99.80) | short %.2f (atteso 101.00)",
               f1,f2,f3,f4);
   if(MathAbs(f1-99.0)>0.0001 || MathAbs(f2-97.0)>0.0001 ||
      MathAbs(f3-99.8)>0.0001 || MathAbs(f4-101.0)>0.0001) falliti++;

   //--- L'ANCORA UNICA, ED E' IL CONTROLLO CHE CONTA DI PIU'.
   //    L'invarianza in R si prova cosi': DUE stop diversi (1,0 e 2,5) e
   //    si verifica che il rapporto (target-entry)/(entry-stop) sia LO
   //    STESSO numero. Se non lo fosse, il motore non avrebbe un'ancora
   //    unica e tutto il round successivo sarebbe senza senso.
   double Ra = 10.0, Rb = 25.0;
   double ta = TargetDaR_Calc(true, 100.0, Ra, 2.0);       // atteso 120
   double tb = TargetDaR_Calc(true, 100.0, Rb, 2.0);       // atteso 150
   double rra = (ta-100.0)/Ra;
   double rrb = (tb-100.0)/Rb;
   double tc = TargetDaR_Calc(false,100.0, Ra, 2.0);       // short: atteso 80
   double td = TargetDaR_Calc(true, 100.0, Ra, 0.0);       // rr = 0 -> nessun TP
   PrintFormat("[VOLEXP][AUTOTEST] ancora unica: target(R=10)=%.2f (atteso 120.00) | target(R=25)=%.2f (atteso 150.00) | R:R %.4f contro %.4f (DEVONO coincidere) | short %.2f (atteso 80.00) | rr=0 -> %.2f (atteso 0.00)",
               ta,tb,rra,rrb,tc,td);
   if(MathAbs(ta-120.0)>0.0001 || MathAbs(tb-150.0)>0.0001 ||
      MathAbs(rra-rrb)>0.000001 || MathAbs(tc-80.0)>0.0001 ||
      MathAbs(td)>0.0001) falliti++;

   //--- IL CANCELLO DI SPREAD IN % DELLO STOP (R55)
   //    stop 100, soglia 2,5% -> passa fino a 2,5 compreso.
   bool g1 = SpreadGate_Calc( 2.0,100.0,2.5);   // 2,0% -> passa
   bool g2 = SpreadGate_Calc( 2.5,100.0,2.5);   // sul bordo -> passa (<=)
   bool g3 = SpreadGate_Calc( 3.0,100.0,2.5);   // 3,0% -> blocca
   //    E LA META' CHE SPIEGA PERCHE' IL CANCELLO E' RELATIVO: lo STESSO
   //    spread di 3,0 su uno stop DOPPIO (200) passa, perche' pesa meta'.
   bool g4 = SpreadGate_Calc( 3.0,200.0,2.5);   // stesso spread, stop doppio -> passa
   bool g5 = SpreadGate_Calc( 2.0,  0.0,2.5);   // stop nullo -> blocca
   PrintFormat("[VOLEXP][AUTOTEST] spread gate: 2.0%%=%d (atteso 1) | bordo 2.5%%=%d (atteso 1) | 3.0%%=%d (atteso 0) | stesso spread su stop DOPPIO=%d (atteso 1) | stop 0=%d (atteso 0)",
               (int)g1,(int)g2,(int)g3,(int)g4,(int)g5);
   if(!(g1 && g2 && !g3 && g4 && !g5)) falliti++;

   //--- L'ORARIO (ORA SERVER)
   bool o1 = OraAmmessa_Calc(15,14,20);    // dentro
   bool o2 = OraAmmessa_Calc(21,14,20);    // fuori
   bool o3 = OraAmmessa_Calc(14,14,20);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[VOLEXP][AUTOTEST] orario: 15 in 14-20=%d (atteso 1) | 21=%d (atteso 0) | estremo 14=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(o1 && !o2 && o3 && o4)) falliti++;

   Print("[VOLEXP][AUTOTEST] esito motore: ", (falliti==0
         ? "SETTE BLOCCHI SU SETTE, la regola ragiona come la firma."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//+------------------------------------------------------------------+
//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//                                                                   //
//  QUI LE COLONNE SONO 16 INVECE DI 10: le sei in piu' sono i       //
//  CONTATORI DIAGNOSTICI, e servono a stabilire se l'asse ha morso  //
//  o se il round ha misurato un tappo.                              //
//    stats[10] Pavimento SL Morso    -> due celle basse identiche?  //
//    stats[11] Lotto Alzato 228      -> rischio VERO sopra il detto //
//    stats[12] Lotto Tagliato 5pct   -> rischio VERO sotto il detto //
//    stats[13] Spread Gate Rifiuti   -> il cancello R55 sta filtrando//
//    stats[14] Segnali Grezzi        -> il denominatore di tutto    //
//    stats[15] Guardian Rifiuti      -> nel tester dev'essere 0     //
//  HEADER E RIGA SI TOCCANO INSIEME, o le colonne scalano di posto. //
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
   double stats[16];
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
   //--- e le sei che dicono se l'ASSE ha morso o se ho misurato un tappo
   stats[10] = (double)gCntPavimentoSL;
   stats[11] = (double)gCntLottoAlzato;
   stats[12] = (double)gCntLottoTagliato;
   stats[13] = (double)gCntSpreadGate;
   stats[14] = (double)gCntSegnali;
   stats[15] = (double)gCntGuardian;
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
         //--- HEADER E RIGA SI TOCCANO INSIEME, o le colonne scalano di posto.
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Pavimento SL Morso,Lotto Alzato 228,Lotto Tagliato 5pct,Spread Gate Rifiuti,Segnali Grezzi,Guardian Rifiuti";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- la guardia su ArraySize non e' cosmetica: -1 dice "questa passata
      //    NON ha prodotto il contatore" ed e' diverso da 0, che dice "il
      //    contatore ha girato e non ha contato niente".
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                (ArraySize(data)> 7?data[ 7]: 0.0), (ArraySize(data)> 8?data[ 8]: 0.0),
                                (ArraySize(data)> 9?data[ 9]: 0.0), (ArraySize(data)>10?data[10]:-1.0),
                                (ArraySize(data)>11?data[11]:-1.0), (ArraySize(data)>12?data[12]:-1.0),
                                (ArraySize(data)>13?data[13]:-1.0), (ArraySize(data)>14?data[14]:-1.0),
                                (ArraySize(data)>15?data[15]:-1.0));
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
