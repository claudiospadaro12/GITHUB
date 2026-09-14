//+------------------------------------------------------------------+
//|                                              ABTG_Cycle.mq5      |
//|                                                                  |
//|  EA "CYCLE" - MT5 - TUTTO-IN-UNO                                 |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  DA DOVE VIENE (attribuzione obbligatoria)                       |
//|    Indicatore Pine Script v5 "Cycle - Ciclo", consegnato da      |
//|    Claudio il 14/09/2026 come indicatore di un collega           |
//|    (Emiliano), usato sulla price action del DAX.                 |
//|    >>> NON E' UN ARRIVO NUOVO IN CASA. La STESSA formula, alla   |
//|        cifra, e' gia' nel repository dall'11/08/2026:            |
//|          backtest_pipeline/prove/alta_velocita_ciclo.pine        |
//|        (intestazione: "formula ORIGINALE da Ciclo_TW1.odt di     |
//|        Claudio, 11/08/2026"), e la sua traduzione MQL5 gira      |
//|        gia' dentro mql5/Experts/ABTG_AltaVelocita.mq5, funzione  |
//|        CycleSeries() r.535-590.                                  |
//|    >>> LA FUNZIONE CycleSeries() DI QUESTO FILE E' COPIATA DA    |
//|        LI', RIGA PER RIGA. Non e' pigrizia: e' la regola di      |
//|        casa "non reinventare". Quella traduzione e' gia' stata   |
//|        letta contro il Pine una volta, e riscriverla da capo     |
//|        vorrebbe dire ricomprare lo stesso rischio di refuso.     |
//|                                                                  |
//|  E QUESTO EA NON E' ABTG_AltaVelocita, ED E' IL PUNTO            |
//|    ABTG_AltaVelocita e' BOCCIATO (11/08/2026,                    |
//|    risultati_archivio/REFERTO_ALTA_VELOCITA_V1.md): v1 a tick    |
//|    8/8 celle negative, v1.1 OOS 4/4 negative, su GBPUSD.         |
//|    Ma li' il CICLO non era il motore: era il SEGMENTATORE che    |
//|    contava le punte dell'RSI dentro una sequenza                 |
//|    Supertrend + RSI + Williams (1.422 righe). Il verdetto e'     |
//|    su QUELLA macchina, su UN simbolo forex, su UN TF.            |
//|    Qui il ciclo e' il motore e basta, su indici, su M30:         |
//|    e' un MECCANISMO diverso sulla stessa inefficienza, che e'    |
//|    esattamente quello che la REGOLA DELLA SECONDA CACCIA         |
//|    (19/08) ammette -- e NON e' "un'altra griglia di parametri    |
//|    su un motore morto", che la stessa regola vieta.              |
//|                                                                  |
//|  CHE COS'E' L'INDICATORE, LETTO NELLA SUA ARITMETICA             |
//|    K1 = SMA( Stoch%K(5),  3 )     peso 4.1                       |
//|    K2 = SMA( Stoch%K(14), 3 )     peso 2.5                       |
//|    K3 = SMA( Stoch%K(45), 14)     peso 1.0                       |
//|    K4 = SMA( Stoch%K(75), 20)     peso 4.0                       |
//|    I  = (4.1*K1 + 2.5*K2 + 1*K3 + 4*K4) / 11.6                   |
//|    CICLO = I - SMA(I, 9)                                         |
//|                                                                  |
//|    Ogni %K sta fra 0 e 100 e dice DOVE STA LA CHIUSURA DENTRO IL |
//|    RANGE delle ultime n barre. Quindi I e' "la posizione nel     |
//|    range, guardata a quattro orizzonti insieme" -- 0-100, non    |
//|    un prezzo.                                                    |
//|    E CICLO = I - SMA(I,9) e' un FILTRO PASSA-ALTO su I: per una  |
//|    I abbastanza liscia, I - SMA_n(I) e' proporzionale alla sua   |
//|    DERIVATA. Cioe':                                              |
//|      >>> CICLO NON E' "QUANTO SIAMO IN ALTO". E' "QUANTO IN      |
//|          FRETTA STIAMO SALENDO O SCENDENDO DENTRO IL RANGE". <<< |
//|    Da qui discende tutto il resto, e non e' un'opinione: e' la   |
//|    forma della formula.                                          |
//|                                                                  |
//|  LA REGOLA DI QUESTO EA, IN UNA RIGA                             |
//|    >>> SI ENTRA SULL'INCROCIO DELLO ZERO DEL CICLO, SU BARRA     |
//|        CHIUSA, E SI ESCE SULL'INCROCIO OPPOSTO. <<<              |
//|    Se CICLO e' la velocita', il suo cambio di segno e' il punto  |
//|    in cui la velocita' si azzera e riparte dall'altra parte:     |
//|    cioe' il MINIMO o il MASSIMO del ciclo, appena FORMATO.       |
//|    E non e' una mia lettura: e' la lettura scritta dall'autore   |
//|    della formula in casa nostra, verbatim da                     |
//|    prove/alta_velocita_ciclo.pine r.12-13:                       |
//|      "Cambio di segno del CICLO = fine ciclo (positivo->negativo |
//|       = massimo di ciclo formato; negativo->positivo = minimo di |
//|       ciclo formato)."                                           |
//|                                                                  |
//|  PERCHE' L'INCROCIO DELLO ZERO E NON UN ESTREMO CON SOGLIA       |
//|    Perche' l'incrocio dello zero NON HA UN PARAMETRO LIBERO. Una |
//|    soglia ("entra sotto -8") ne aggiunge uno, e su un motore di  |
//|    cui NON e' ancora dimostrato un edge un parametro libero e'   |
//|    soltanto un posto dove pescare (lezione del 19/08). Il segno  |
//|    di un numero non si tara.                                     |
//|                                                                  |
//|  E IL FALSIFICATORE STA DENTRO IL MOTORE: InpVerso               |
//|    InpVerso = 0 -> si trada CON l'incrocio (su = long).          |
//|    InpVerso = 1 -> si trada CONTRO l'incrocio (su = short).      |
//|    Siccome l'USCITA e' anch'essa un incrocio, i due versi        |
//|    coprono gli STESSI intervalli di tempo col segno rovesciato:  |
//|    senza stop e senza pedaggio i due P/L sarebbero esattamente   |
//|    opposti. Quindi:                                              |
//|      - se l'incrocio porta informazione, una delle due celle     |
//|        deve staccarsi dall'altra in modo netto;                  |
//|      - se non ne porta, le due celle perdono TUTTE E DUE, e      |
//|        perdono all'incirca il pedaggio.                          |
//|    >>> E L'ASIMMETRIA VA DICHIARATA, perche' NON e' a mio        |
//|        favore: lo stop TRONCA i perdenti, quindi la cella        |
//|        "contro" e' sistematicamente MEGLIO del semplice opposto  |
//|        della cella "con". Chi legge il round gia' con questo.    |
//|                                                                  |
//|  SECONDO MODO D'INGRESSO -- AGGIUNTO IL 14/09/2026, ADDITIVO      |
//|    Claudio ha mostrato uno screenshot TradingView di XAUUSD 1m   |
//|    con questo stesso indicatore, disegnando a mano il minimo     |
//|    LOCALE del Ciclo (una V, es. intorno a -11/-12) come punto     |
//|    d'ingresso -- POTENZIALMENTE PRIMA che il ciclo attraversi lo  |
//|    zero. E' un evento diverso: l'incrocio dello zero e' il punto  |
//|    in cui I (il composito) forma il suo estremo; il minimo/       |
//|    massimo LOCALE del CICLO stesso e' un estremo di UN LIVELLO DI |
//|    DERIVAZIONE IN PIU' (l'estremo della velocita', non della      |
//|    posizione), e in una salita tipica precede lo zero-cross.      |
//|                                                                   |
//|    InpModoIngresso seleziona il modo, DI FABBRICA = INCROCIO_ZERO |
//|    (0): con questo default il motore e' IDENTICO, bit per bit,    |
//|    a com'era prima di questa modifica -- R148a/R148b RESTANO      |
//|    RIPRODUCIBILI perche' i loro file prova non toccano questo     |
//|    input e MT5 gli applica il default.                            |
//|                                                                   |
//|    MODO_MINIMO_LOCALE (1): minimo/massimo locale a 3 barre        |
//|    CHIUSE del CICLO, ZERO PARAMETRI LIBERI come l'incrocio:        |
//|      LONG  se Ciclo(t-2) > Ciclo(t-1) E Ciclo(t-1) < Ciclo(t)      |
//|      SHORT se Ciclo(t-2) < Ciclo(t-1) E Ciclo(t-1) > Ciclo(t)      |
//|    (t = barra chiusa piu' recente = indice [1]). Nessuna soglia di |
//|    profondita': un minimo a -0,3 conta come un minimo a -20. E'   |
//|    la stessa disciplina della regola di casa: il PATTERN non si   |
//|    tara, altrimenti e' un posto dove pescare (lezione 19/08).     |
//|    >>> SE servisse una soglia di profondita' (es. "conta solo se  |
//|        |Ciclo|>=X"), quella e' un ASSE DEL ROUND SUCCESSIVO, da   |
//|        DICHIARARE e misurare -- non un numero da inventare qui.   |
//|        Vedi backtest_pipeline/prove/R148g_cycle_minimo_locale_    |
//|        verso_NASUSD.txt, sezione "GEMELLI PROPOSTI".              |
//|    >>> E IL FALSIFICATORE E' LO STESSO DI SEMPRE: InpVerso, che    |
//|        non cambia forma (VuoleLong_Calc legge +1/-1 da qualunque  |
//|        rilevatore, incrocio o estremo).                           |
//|    >>> COSTO ATTESO, DICHIARATO PRIMA DEI NUMERI: un minimo locale |
//|        a 3 barre scatta PIU' SPESSO di un incrocio dello zero (il  |
//|        ciclo oscilla intorno al suo stesso rumore ad ogni barra:  |
//|        su rumore puro un minimo/massimo locale a 3 punti capita in |
//|        media 1 barra su 3, contro 1 incrocio ogni 5,6-8,8 barre    |
//|        misurato in R148a). Vedi il contro-esempio nel file prova. |
//|                                                                  |
//|  DECIDE SOLO A BARRA CHIUSA. Il ciclo si legge agli indici [1] e |
//|  [2] (le due ultime barre CHIUSE): la barra [0], in formazione,  |
//|  non entra in nessun calcolo. Niente ridipintura, per            |
//|  costruzione.                                                    |
//|                                                                  |
//|  >>> LA TRAPPOLA CHE HA DECISO COME E' SCRITTO IL CALCOLO <<<    |
//|    iStochastic() di MT5 NON E' lo stocastico del Pine.           |
//|    MT5 calcola  SUM(close-LL, s) / SUM(HH-LL, s) * 100           |
//|    il Pine calcola  SMA( (close-LL)/(HH-LL) * 100 , s )          |
//|    cioe' rapporto-di-somme contro media-di-rapporti. Sono due    |
//|    numeri diversi. Usare iStochastic() qui sarebbe stato piu'    |
//|    corto e AVREBBE MISURATO UN ALTRO INDICATORE. Per questo il   |
//|    calcolo e' a mano, ed e' quello gia' scritto in casa.         |
//|                                                                  |
//|  DOVE PUO' GIRARE -- E' UN CONTO, NON UNA PREFERENZA             |
//|    Il motore non ha uno stop STRUTTURALE (un oscillatore non ha  |
//|    livelli): lo stop e' per forza InpKStop x ATR. Col pedaggio   |
//|    MISURATO e l'ATR per TF derivato dall'ADR MISURATO            |
//|    (report/CANCELLO_COSTO_FLOTTA_2026-09-10.md,                  |
//|     report/CACCIA_STOP_STRUTTURALE_2026-09-13.md par.4,          |
//|     report/ORO_1530_CANCELLO_COSTO_2026-09-10.md par.8):         |
//|      NASUSD M30, InpKStop 2.0  -> 50.3x lo spread   PASSA        |
//|      U30USD M30, InpKStop 2.0  -> 45.4x             PASSA        |
//|      D30EUR M30, InpKStop 3.0  -> 47.5x             PASSA        |
//|      XAUUSD M30, InpKStop 2.0  -> 44.9x             PASSA*       |
//|      NASUSD M15, InpKStop 2.5  -> 44.5x             PASSA        |
//|      *XAUUSD: il pedaggio include la commissione MISURATA        |
//|       (3,48 EUR/lotto = 0,0403 $), MA lo spread dell'oro ORA PER |
//|       ORA e' [NON MISURATO] e la profondita' a TICK di XAUUSD    |
//|       pure. Sull'oro si puo' fare SCREENING, mai un verdetto,    |
//|       finche' quelle due sonde non girano.                       |
//|    >>> M1 E M5 SONO ESCLUSI PER COSTO SU TUTTI E QUATTRO I       |
//|        SIMBOLI, e non di poco: su NASUSD M1 l'ATR vale ~8,3      |
//|        punti indice contro uno spread MISURATO di 1,80, quindi   |
//|        per arrivare al pavimento di lavoro 40x servirebbe        |
//|        InpKStop = 8,7 -- uno stop da H1 appeso a un segnale da   |
//|        M1. Sull'oro M1 l'ATR vale ~1,07 $ contro un pedaggio     |
//|        all-in di 0,26 $: servirebbe InpKStop = 9,8.              |
//|        Non e' una taratura da trovare: e' una geometria che non  |
//|        esiste. Il numero sta nel file prova.                     |
//|                                                                  |
//|  ORARI: SEMPRE ORA SERVER. Il server BCM e' UN'ORA INDIETRO      |
//|  rispetto all'ora italiana (DAX 09:00 IT = 08:00 server).        |
//|                                                                  |
//|  STATO: CANDIDATO DA BACKTEST. NON e' una sedia, NON va in       |
//|  forward finche' un round a TICK REALI non lo promuove.          |
//|  MAGIC 775701 -- blocco 7757xx VERGINE: grep repo-wide           |
//|  (.git escluso) il 14/09/2026, ZERO occorrenze di qualunque      |
//|  7757xx e ZERO di 775700/775701/775702/775703.                   |
//|                                                                  |
//|  DEMO. Nessuna garanzia. ASCII puro: niente accenti dentro le    |
//|  stringhe, niente emoji (convenzione degli altri EA ABTG).       |
//|  >>> NON COMPILATO E NON TESTATO DA CHI HA SCRITTO IL FILE:      |
//|      l'ambiente di scrittura non ha MetaEditor ne' lo Strategy   |
//|      Tester. Va compilato in MetaEditor (F7) e validato nel      |
//|      tester A TICK REALI prima di qualunque lettura. Il primo    |
//|      esito possibile di questo file e' un errore di              |
//|      compilazione, e va messo in conto.                          |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati - indicatore Cycle (Pine v5) di un collega di Claudio"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>

//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a un EA non migrato.
//    Nel Strategy Tester le GlobalVariable del Guardian non esistono e la
//    guardia lascia passare tutto (fail-open): i backtest restano
//    confrontabili con quelli degli altri EA.
//    >>> NASCE COL GUARDIAN DENTRO, per la lezione del 12/09/2026: la
//        PRIMA sedia gira in campo con un binario che non ha nemmeno
//        l'input. Un EA nuovo non ha nessuna scusa.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  INPUT
//==================================================================
input group "=== L'INDICATORE (i nove numeri della fonte) ==="
//  Sono i valori del Pine, uno per uno. NON sono le manopole del primo
//  round: tararli prima di sapere se il segnale esiste sarebbe pesca.
//  Esistono come input solo perche' un giorno andranno confrontati con
//  un'altra lunghezza, e allora servira' un asse -- non oggi.
input int    InpK1Len  = 5;    // Stoch 1 - lunghezza K (fonte: 5)
input int    InpK1Smo  = 3;    // Stoch 1 - lisciatura  (fonte: 3)
input int    InpK2Len  = 14;   // Stoch 2 - lunghezza K (fonte: 14)
input int    InpK2Smo  = 3;    // Stoch 2 - lisciatura  (fonte: 3)
input int    InpK3Len  = 45;   // Stoch 3 - lunghezza K (fonte: 45)
input int    InpK3Smo  = 14;   // Stoch 3 - lisciatura  (fonte: 14)
input int    InpK4Len  = 75;   // Stoch 4 - lunghezza K (fonte: 75)
input int    InpK4Smo  = 20;   // Stoch 4 - lisciatura  (fonte: 20)
input int    InpMmLen  = 9;    // MM: la media mobile che viene sottratta (fonte: 9)
//  I PESI 4.1 / 2.5 / 1.0 / 4.0 NON SONO INPUT, ED E' UNA SCELTA.
//  Sono la FIRMA dell'indicatore: quattro numeri liberi su un motore
//  senza edge dimostrato sono quattro posti dove pescare. Stanno in
//  CicloPesi_Get(), sono verificati dall'AUTOTEST (la loro somma DEVE
//  fare 11.6, altrimenti l'indicatore non e' piu' normalizzato 0-100),
//  e si toccano solo con un round dedicato che li dichiari prima.

//--- I DUE MODI D'INGRESSO. Aggiunto 14/09/2026, ADDITIVO: il default
//    (0) e' il comportamento di sempre, bit per bit (vedi la nota nel
//    blocco di intestazione). NON e' un asse di questo file: ogni round
//    fissa UN modo solo, non li mescola in griglia (una variabile alla
//    volta -- lezione del 19/08 applicata anche qui).
enum ENUM_ABTG_CYCLE_MODO
  {
   MODO_INCROCIO_ZERO = 0,   // di fabbrica: entra sull'incrocio dello zero, esce sull'incrocio opposto (R148a/R148b)
   MODO_MINIMO_LOCALE = 1    // nuovo 14/09: entra sul minimo/massimo LOCALE del ciclo a 3 barre, zero soglie
  };

input group "=== INGRESSO: l'incrocio dello zero, e il suo falsificatore ==="
input ENUM_ABTG_CYCLE_MODO InpModoIngresso = MODO_INCROCIO_ZERO; // Rilevatore del segnale. Default preserva R148a/b bit-per-bit
input int    InpVerso    = 0;     // 0 = CON il segnale (su = long). 1 = CONTRO (su = short). E' l'asse del primo round, in QUALUNQUE modo
input bool   InpAllowLong  = true;  // Abilita il lato LONG  (regola dei due lati, 25/08)
input bool   InpAllowShort = true;  // Abilita il lato SHORT (regola dei due lati, 25/08)

input group "=== USCITA ==="
input bool   InpEsciSuCrossOpposto = true; // true = si esce all'incrocio opposto (l'uscita dell'indicatore). false = solo SL/TP

input group "=== STOP E TARGET ==="
//  Il motore NON ha uno stop strutturale: un oscillatore non ha livelli.
//  Lo stop e' per forza in ATR, e la sua ampiezza e' quello che il
//  CANCELLO DEL COSTO giudica.
input double InpKStop     = 2.0;  // SL = entry -/+ X * ATR(InpAtrPeriod). Su NASUSD M30 X=2.0 vale 50,3x lo spread MISURATO
input int    InpAtrPeriod = 14;   // Periodo ATR per lo stop
input double InpTP_RR     = 0.0;  // TP = X volte R (R = distanza VERA dello stop). 0 = NESSUN TP: esce l'indicatore
input double InpMinSLPts  = 0;    // PAVIMENTO dello stop in punti MT5 (lezione R109). 0 = spento

input group "=== GESTIONE NOSTRA (default = SPENTA) ==="
//  PARZIALE e BREAKEVEN sono DUE BLOCCHI INDIPENDENTI, e non e' una
//  raffinatezza: su ABTG_Nasdaq_Live5m il breakeven stava DENTRO il ramo
//  della parziale, e al lotto minimo la parziale si disarmava portandosi
//  dietro anche il breakeven (lezione 07/08/2026).
input double InpTP1_RR    = 1.0;   // Parziale: primo obiettivo in R
input double InpTP1Pct    = 0;     // % chiusa al primo obiettivo (0 = parziale SPENTO)
input bool   InpBreakeven = false; // Stop in pari (INDIPENDENTE dalla parziale)
input double InpBE_R      = 1.0;   // A quanti R lo stop va in pari

input group "=== COSTO (R55: in % dello stop, mai in punti fissi) ==="
input double InpMaxSpreadPctOfStop = 2.5; // Spread <= X% dello stop, altrimenti si salta. 2,5% = la frontiera dei 40x

input group "=== Gestione operativa ==="
input int    InpMaxTradesPerDay = 6;  // Max ingressi al giorno (C6). 0 = illimitato
input bool   InpUseHourFilter   = false; // Filtro orario sulla barra di segnale (ORA SERVER)
input int    InpHourStart       = 14; // Ora SERVER di inizio (inclusa). BCM: 14 = 15:00 IT = cassa USA
input int    InpHourEnd         = 20; // Ora SERVER di fine (inclusa)
input bool   InpFridayClose     = false; // Venerdi': chiudi tutto oltre l'ora e non riaprire
input int    InpFridayCloseHour = 20; // Ora SERVER del venerdi' oltre cui chiudo

input group "=== Rischio ==="
input double InpRiskPercent = 0.65;   // Rischio per trade, % del SALDO. 0,65 = contratto di casa

input group "=== Generali ==="
input string InpComment  = "CYCLE";  // Commento sugli ordini
input long   InpMagic    = 775701;   // Numero magico (blocco 7757xx: VERGINE, grep repo-wide 14/09/2026)
input bool   InpVerbose  = true;     // Messaggi nel log
input bool   InpAutoTest = true;     // Stampa le righe [CYCLE][AUTOTEST] in avvio (si leggono ESEGUENDO, non compilando)

//==================================================================
//  STATO
//  (tutte le globali stanno QUI, PRIMA di ogni funzione che le legge:
//   in MQL5 le funzioni si possono chiamare in avanti, le VARIABILI
//   GLOBALI no -- classe 230 del 11/09/2026.)
//==================================================================
ENUM_TIMEFRAMES gTF = PERIOD_CURRENT;   // il TF del grafico: lo fissa @PERIODO del file prova

int      hAtr = INVALID_HANDLE;

datetime gLastBar = 0;
int      gDay = -1, gIngressiOggi = 0;

//--- la posizione in corso: ticket, R INIZIALE e stato della parziale.
ulong    gPosTicket    = 0;
double   gPosR         = 0.0;
bool     gPosParzFatta = false;

//--- METRICHE DA PROP. L'Equity DD dice se il conto sopravvive; una prop
//    invece ti chiude per il LIMITE GIORNALIERO, che e' un'altra cosa.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // la peggiore di tutte, in % (numero NEGATIVO)
int    gDayEqStamp     = -1;

//--- CONTATORI DIAGNOSTICI. Escono come colonne dell'OptFrame.
//    Su un motore di cui non si sa niente servono piu' del PF: dicono
//    se il round ha misurato il segnale o un tappo.
long gCntIncroci       = 0;   // INCROCI DELLO ZERO VISTI -- il denominatore VERO
long gCntPavimentoSL   = 0;   // volte in cui InpMinSLPts ha allargato lo stop
long gCntLottoAlzato   = 0;   // volte in cui il pavimento del LOTTO ha alzato il rischio (classe 228)
long gCntLottoTagliato = 0;   // volte in cui la quantizzazione ha tagliato il lotto oltre il 5%
long gCntSpreadGate    = 0;   // rifiuti del cancello di spread (R55)
long gCntGuardian      = 0;   // rifiuti del Guardian
long gCntIngressi      = 0;   // ingressi andati a buon fine
long gCntUscitaCross   = 0;   // chiusure fatte DA ME sull'incrocio opposto
long gBarreTenute      = 0;   // barre chiuse passate con una posizione aperta
long gMaxIngressiGiorno = 0;  // il massimo di ingressi visto in una giornata

void Log(string m){ if(InpVerbose) Print("[CYCLE] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono niente dal terminale.
//   Prendono i numeri gia' letti e rispondono. E' questa la parte
//   che l'AUTOTEST puo' interrogare a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| I QUATTRO PESI DELL'INDICATORE, in un posto solo.                 |
//| Non sono input: vedere la nota nel blocco degli input.            |
//| La loro SOMMA e' il divisore (11.6), e l'AUTOTEST lo verifica:    |
//| se somma e divisore non coincidono l'indicatore smette di stare   |
//| fra 0 e 100 e non e' piu' quello della fonte.                     |
//+------------------------------------------------------------------+
void CicloPesi_Get(double &w[])
  {
   ArrayResize(w,4);
   w[0]=4.1; w[1]=2.5; w[2]=1.0; w[3]=4.0;
  }

double CicloDivisore_Get() { return(11.6); }

//+------------------------------------------------------------------+
//| STOCASTICO GREZZO, un valore solo.                                |
//|   (close - lo) / (hi - lo) * 100                                  |
//| RANGE NULLO -> 50, cioe' NEUTRO. E' la stessa protezione che ha   |
//| la traduzione di casa: una divisione per zero qui produrrebbe un  |
//| NaN che si propaga a tutte e nove le medie successive.            |
//| >>> E il 50 non e' arbitrario: e' il valore che lo stocastico     |
//|     assume per continuita' quando il range si chiude (prezzo che  |
//|     non si muove = ne' in alto ne' in basso nel range).           |
//+------------------------------------------------------------------+
double StocRaw_Calc(const double close, const double lo, const double hi)
  {
   double rng = hi-lo;
   if(rng<=0.0) return(50.0);
   return((close-lo)/rng*100.0);
  }

//+------------------------------------------------------------------+
//| IL COMPOSITO I: la media pesata dei quattro %K lisciati.          |
//|   I = (4.1*K1 + 2.5*K2 + 1.0*K3 + 4.0*K4) / 11.6                  |
//+------------------------------------------------------------------+
double CompositoI_Calc(const double k1, const double k2,
                       const double k3, const double k4)
  {
   double w[]; CicloPesi_Get(w);
   double div = CicloDivisore_Get();
   if(div<=0.0) return(0.0);
   return((w[0]*k1 + w[1]*k2 + w[2]*k3 + w[3]*k4)/div);
  }

//+------------------------------------------------------------------+
//| L'INCROCIO DELLO ZERO, sulle due ultime barre CHIUSE.             |
//|   cyc1 = barra [1] (l'ultima chiusa)                              |
//|   cyc2 = barra [2] (quella prima)                                 |
//| Ritorna:                                                          |
//|   +1 incrocio verso l'ALTO  = MINIMO di ciclo formato             |
//|   -1 incrocio verso il BASSO = MASSIMO di ciclo formato           |
//|    0 nessun incrocio                                              |
//| Lo ZERO ESATTO e' assegnato al lato POSITIVO (>=0), cosi' i due   |
//| rami sono mutuamente esclusivi e una serie che resta appoggiata a |
//| zero NON produce un segnale a ogni barra.                         |
//+------------------------------------------------------------------+
int CrossCiclo_Calc(const double cyc1, const double cyc2)
  {
   if(cyc2 <  0.0 && cyc1 >= 0.0) return(+1);
   if(cyc2 >= 0.0 && cyc1 <  0.0) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| IL MINIMO/MASSIMO LOCALE DEL CICLO, su 3 barre CHIUSE.            |
//| AGGIUNTA 14/09/2026 (screenshot XAUUSD di Claudio, V a mano       |
//| sull'oscillatore). ZERO PARAMETRI LIBERI, come CrossCiclo_Calc:   |
//| nessuna soglia di profondita', il pattern e' puramente ordinale. |
//|   cyc1 = barra [1] (l'ultima chiusa, "t")                         |
//|   cyc2 = barra [2] ("t-1", il centro del pattern)                  |
//|   cyc3 = barra [3] ("t-2")                                        |
//| Ritorna:                                                          |
//|   +1  MINIMO locale in cyc2 (cyc3>cyc2 E cyc2<cyc1) = potenziale  |
//|       LONG, simmetrico a "incrocio verso l'alto"                  |
//|   -1  MASSIMO locale in cyc2 (cyc3<cyc2 E cyc2>cyc1) = potenziale |
//|       SHORT                                                       |
//|    0  nessun estremo (compresa qualunque parita': un plateau non  |
//|       produce un segnale ripetuto, stessa logica dello zero       |
//|       esatto in CrossCiclo_Calc)                                  |
//| >>> IL VALORE DI RITORNO E' NELLA STESSA CONVENZIONE DI           |
//|     CrossCiclo_Calc (+1 = "su" = long col verso 0): VuoleLong_Calc |
//|     si riusa IDENTICO, senza toccarlo.                             |
//+------------------------------------------------------------------+
int EstremoCiclo_Calc(const double cyc1, const double cyc2, const double cyc3)
  {
   if(cyc3 > cyc2 && cyc2 < cyc1) return(+1);
   if(cyc3 < cyc2 && cyc2 > cyc1) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| DIREZIONE VOLUTA dall'incrocio, dopo il verso.                    |
//| verso 0 = CON l'incrocio, verso 1 = CONTRO.                       |
//| cross deve valere +1 o -1: con 0 non si chiama.                   |
//+------------------------------------------------------------------+
bool VuoleLong_Calc(const int cross, const int verso)
  {
   bool su = (cross>0);
   return( (verso==0) ? su : !su );
  }

//+------------------------------------------------------------------+
//| PAVIMENTO dello stop (lezione R109). Se lo stop e' piu' vicino    |
//| del pavimento, lo stop si ALLARGA al pavimento (semantica di      |
//| "minimo"), non si salta il trade. pavimento<=0 = spento.          |
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
//| simbolo E mente lungo un asse che cambia l'ampiezza dello stop.   |
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

//+------------------------------------------------------------------+
//| CICLO: traduzione 1:1 di alta_velocita_ciclo.pine                 |
//|   K1=SMA(St(5),3) K2=SMA(St(14),3) K3=SMA(St(45),14)              |
//|   K4=SMA(St(75),20)                                               |
//|   I=(4.1*K1+2.5*K2+K3+4*K4)/11.6 ; CICLO = I - SMA(I,9)           |
//| St(n) = (close-lowest(low,n))/(highest(high,n)-lowest(low,n))*100 |
//|                                                                   |
//| >>> COPIATA RIGA PER RIGA da mql5/Experts/ABTG_AltaVelocita.mq5   |
//|     r.535-590 (11/08/2026). Le uniche differenze, dichiarate:     |
//|       - le lunghezze e le lisciature vengono dagli input (li'     |
//|         erano costanti nel corpo della funzione);                 |
//|       - i pesi e il divisore passano da CompositoI_Calc(), cosi'  |
//|         l'AUTOTEST puo' interrogarli;                             |
//|       - lo stocastico grezzo passa da StocRaw_Calc(), idem.       |
//|     Il RISULTATO e' lo stesso numero: le tre modifiche spostano   |
//|     DOVE sta scritta l'aritmetica, non l'aritmetica.              |
//|                                                                   |
//| 'need' = quante barre RECENTI di CICLO servono (indici 0..need).   |
//| Si calcolano SOLO quelle: qui serve fino all'indice 2, calcolare  |
//| 600 barre a ogni candela costerebbe ore di tester.                |
//+------------------------------------------------------------------+
bool CycleSeries(ENUM_TIMEFRAMES tf,int need,double &cycOut[])
  {
   if(need<2) need=2;
   int maxSmo = (int)MathMax(MathMax(InpK1Smo,InpK2Smo),MathMax(InpK3Smo,InpK4Smo));
   int maxLen = (int)MathMax(MathMax(InpK1Len,InpK2Len),MathMax(InpK3Len,InpK4Len));
   int mRaw  = need + maxSmo + InpMmLen + 3;   // margine per la lisciatura piu' lunga e per la MM finale
   int nBars = mRaw + maxLen + 5;              // + la finestra stocastica piu' lunga

   MqlRates r[]; ArraySetAsSeries(r,true);
   int n=CopyRates(_Symbol,tf,0,nBars,r);
   if(n<nBars) return(false);           // storia insufficiente: riprova dopo

   int    kLen[4]; int kSmo[4];
   kLen[0]=InpK1Len; kLen[1]=InpK2Len; kLen[2]=InpK3Len; kLen[3]=InpK4Len;
   kSmo[0]=InpK1Smo; kSmo[1]=InpK2Smo; kSmo[2]=InpK3Smo; kSmo[3]=InpK4Smo;

   //--- i quattro %K lisciati, per indice di barra.
   //    ATTENZIONE ALLA FORMA: in MQL5 solo la PRIMA dimensione puo'
   //    essere dinamica, quindi si scrive [ ][4] e si indicizza [barra][k].
   //    Scriverlo [4][ ] non compila.
   double kSm[][4]; ArrayResize(kSm,mRaw);

   double raw[];  ArrayResize(raw,mRaw);
   for(int k=0;k<4;k++)
     {
      int L=kLen[k], S=kSmo[k];
      //--- stocastico grezzo (indice 0 = barra in corso, j va indietro nel tempo)
      for(int i=0;i<mRaw;i++)
        {
         int len=(int)MathMin(L,n-i);
         double hi=r[i].high, lo=r[i].low;
         for(int j=i;j<i+len;j++)
           { if(r[j].high>hi) hi=r[j].high; if(r[j].low<lo) lo=r[j].low; }
         raw[i]=StocRaw_Calc(r[i].close, lo, hi);
        }
      //--- lisciatura SMA(S). Gli ultimi S-1 indici escono dalla finestra
      //    calcolata: restano dentro il margine e non vengono mai letti.
      for(int i=0;i<mRaw;i++)
        {
         int len=(int)MathMin(S,mRaw-i);
         double s=0.0;
         for(int j=i;j<i+len;j++) s+=raw[j];
         kSm[i][k]=s/len;
        }
     }

   //--- il composito I, barra per barra
   double comp[]; ArrayResize(comp,mRaw);
   for(int i=0;i<mRaw;i++)
      comp[i]=CompositoI_Calc(kSm[i][0],kSm[i][1],kSm[i][2],kSm[i][3]);

   //--- CICLO = I - SMA(I, InpMmLen)
   ArrayResize(cycOut,need+1);
   for(int i=0;i<=need;i++)
     {
      int len=(int)MathMin(InpMmLen,mRaw-i);
      double s=0.0;
      for(int j=i;j<i+len;j++) s+=comp[j];
      cycOut[i]=comp[i]-s/len;
     }
   return(true);
  }

//==================================================================
//  CICLO DI VITA
//==================================================================
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);

   if(InpK1Len<1 || InpK2Len<1 || InpK3Len<1 || InpK4Len<1)
     { Print("ERRORE: le lunghezze degli stocastici devono essere >= 1."); return(INIT_FAILED); }
   if(InpK1Smo<1 || InpK2Smo<1 || InpK3Smo<1 || InpK4Smo<1)
     { Print("ERRORE: le lisciature degli stocastici devono essere >= 1."); return(INIT_FAILED); }
   if(InpMmLen<1)
     { Print("ERRORE: InpMmLen deve essere >= 1: senza la media sottratta il CICLO non esiste."); return(INIT_FAILED); }
   if(InpVerso!=0 && InpVerso!=1)
     { Print("ERRORE: InpVerso vale 0 (con l'incrocio) oppure 1 (contro)."); return(INIT_FAILED); }
   if(InpModoIngresso!=MODO_INCROCIO_ZERO && InpModoIngresso!=MODO_MINIMO_LOCALE)
     { Print("ERRORE: InpModoIngresso vale 0 (incrocio zero) oppure 1 (minimo/massimo locale)."); return(INIT_FAILED); }
   if(!InpAllowLong && !InpAllowShort)
     { Print("ERRORE: tutti e due i lati spenti: non c'e' niente da misurare."); return(INIT_FAILED); }
   if(InpAtrPeriod<1)
     { Print("ERRORE: InpAtrPeriod deve essere >= 1."); return(INIT_FAILED); }
   if(InpKStop<=0)
     { Print("ERRORE: InpKStop deve essere > 0: senza stop in ATR questo motore non ha nessuno stop."); return(INIT_FAILED); }
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
   if(InpMaxSpreadPctOfStop<=0)
     { Print("ERRORE: InpMaxSpreadPctOfStop deve essere > 0 (R55: il cancello di spread e' in % dello stop)."); return(INIT_FAILED); }
   if(InpHourStart<0 || InpHourStart>23 || InpHourEnd<0 || InpHourEnd>23)
     { Print("ERRORE: InpHourStart e InpHourEnd devono stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpFridayCloseHour<0 || InpFridayCloseHour>23)
     { Print("ERRORE: InpFridayCloseHour deve stare fra 0 e 23."); return(INIT_FAILED); }
   if(InpRiskPercent<=0)
     { Print("ERRORE: InpRiskPercent deve essere > 0."); return(INIT_FAILED); }
   if(!InpEsciSuCrossOpposto && InpTP_RR<=0)
     Print("[CYCLE] ATTENZIONE: uscita sull'incrocio SPENTA e nessun TP: l'unica uscita e' lo STOP. E' una configurazione lecita ma va voluta.");

   hAtr = iATR(_Symbol, gTF, InpAtrPeriod);
   if(hAtr==INVALID_HANDLE)
     { Print("ERRORE: handle ATR."); return(INIT_FAILED); }

   //--- DICHIARAZIONE, non correzione: se qualcosa e' acceso, la cella
   //    NON e' la cella "indicatore puro". Non lo spegne l'EA (sarebbe un
   //    default nascosto): lo DICE, e il file prova lo pinna.
   if(InpTP1Pct>0 || InpBreakeven || InpMinSLPts>0 || InpUseHourFilter ||
      InpFridayClose || InpTP_RR>0 || !InpEsciSuCrossOpposto)
      Log("ATTENZIONE: almeno una variante e' accesa. Questa cella NON e' l'INDICATORE PURO (incrocio dentro, incrocio fuori).");

   if(InpAutoTest) AutoTestCycle();

   Log(StringFormat("avviato su %s %s. Modo %s, Stoch %d/%d %d/%d %d/%d %d/%d, MM %d, verso %d, uscita su segnale opposto %s, SL %.2f x ATR(%d) + pavimento %.0f pti MT5, TP %.2f R, spread <= %.2f%% dello stop, rischio %.2f%%, cap %d/giorno, magic %I64d.",
       _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), EnumToString(InpModoIngresso),
       InpK1Len,InpK1Smo, InpK2Len,InpK2Smo, InpK3Len,InpK3Smo, InpK4Len,InpK4Smo,
       InpMmLen, InpVerso, (InpEsciSuCrossOpposto?"SI":"NO"),
       InpKStop, InpAtrPeriod, InpMinSLPts, InpTP_RR,
       InpMaxSpreadPctOfStop, InpRiskPercent, InpMaxTradesPerDay, InpMagic));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr!=INVALID_HANDLE) IndicatorRelease(hAtr);

   //--- il riepilogo dei contatori: nel test SINGOLO si legge qui, in
   //    ottimizzazione si legge nelle colonne dell'OptFrame.
   double barreMedie = (gCntIngressi>0) ? (double)gBarreTenute/(double)gCntIngressi : 0.0;
   PrintFormat("[CYCLE][CONTATORI] incroci %I64d | ingressi %I64d | uscite su incrocio %I64d | barre tenute %I64d (media %.2f per ingresso) | max ingressi in un giorno %I64d | pavimento SL morso %I64d | lotto ALZATO (228) %I64d | lotto tagliato oltre 5%% %I64d | spread gate %I64d | guardian %I64d",
               gCntIncroci, gCntIngressi, gCntUscitaCross, gBarreTenute, barreMedie,
               gMaxIngressiGiorno, gCntPavimentoSL, gCntLottoAlzato,
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

   //--- la durata media delle posizioni, in BARRE. Non e' cosmesi: dice
   //    QUANTO SI MUOVE il prezzo dentro un'operazione, e quindi se il
   //    movimento catturato batte il pedaggio. Su un motore nuovo e'
   //    l'unico modo di saperlo senza aprire i per-trade.
   if(CountPositions()>0) gBarreTenute++;

   MqlDateTime now; TimeToStruct(iTime(_Symbol,gTF,0), now);
   if(now.day_of_year!=gDay)
     {
      if(gIngressiOggi>gMaxIngressiGiorno) gMaxIngressiGiorno=gIngressiOggi;
      gDay=now.day_of_year; gIngressiOggi=0;
     }

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
//|                                                                   |
//| ORDINE DELLE COSE, ED E' VOLUTO:                                  |
//|   1. si conta l'INCROCIO -- prima di qualunque cancello, cosi'    |
//|      il contatore e' il denominatore VERO e non "gli incroci      |
//|      visti quando il posto era libero". (Su ABTG_VolExpBreak      |
//|      quella distinzione e' costata una correzione: li' il         |
//|      contatore sta DOPO i return di occupazione. Qui no, e il     |
//|      confronto fra "incroci" e "ingressi" e' proprio la misura    |
//|      di quanto il posto occupato mangia i segnali.)               |
//|   2. si ESCE sull'incrocio opposto -- anche fuori orario: un      |
//|      filtro d'ingresso non deve mai trattenere una posizione.     |
//|   3. si ENTRA, se tutti i cancelli lo permettono.                 |
//+------------------------------------------------------------------+
void OnNewBar()
  {
   //--- il MODO decide quante barre di ciclo servono: l'incrocio guarda
   //    2 barre chiuse, il minimo/massimo locale ne guarda 3. Con
   //    InpModoIngresso al suo DEFAULT (0) questo resta need=2, IDENTICO
   //    a prima della modifica del 14/09 -- R148a/R148b non cambiano.
   double cyc[];
   int need = (InpModoIngresso==MODO_MINIMO_LOCALE) ? 3 : 2;
   if(!CycleSeries(gTF, need, cyc)) return;     // storia insufficiente: si riprova alla prossima barra

   int segnale = (InpModoIngresso==MODO_MINIMO_LOCALE)
                 ? EstremoCiclo_Calc(cyc[1], cyc[2], cyc[3])
                 : CrossCiclo_Calc(cyc[1], cyc[2]);
   if(segnale==0) return;

   gCntIncroci++;                               // IL DENOMINATORE VERO: sta prima di ogni cancello
                                                 // (in MODO_MINIMO_LOCALE conta gli ESTREMI locali, non gli incroci: stesso ruolo, nome storico)

   bool vuoleLong = VuoleLong_Calc(segnale, InpVerso);

   //--- 2) USCITA: l'incrocio opposto chiude quello che ho in mano.
   //    Gira PRIMA dei cancelli d'ingresso, e senza filtro orario.
   if(InpEsciSuCrossOpposto) ChiudiSeContraria(vuoleLong);

   //--- 3) INGRESSO
   if(vuoleLong  && !InpAllowLong)  return;
   if(!vuoleLong && !InpAllowShort) return;
   if(CountPositions()>0)
     { Log("incrocio con il posto ancora occupato: niente ingresso."); return; }
   if(InpMaxTradesPerDay>0 && gIngressiOggi>=InpMaxTradesPerDay) return;
   if(!OraOK()) return;

   double atr = AtrVal();
   if(atr<=0) return;                           // senza ATR non c'e' stop, e senza stop non si entra

   Enter(vuoleLong, atr);
  }

//+------------------------------------------------------------------+
//| Chiude le posizioni di questo magic che vanno CONTRO la direzione |
//| voluta dall'incrocio appena avvenuto.                             |
//| E' l'uscita dell'indicatore: l'incrocio che apre una direzione e' |
//| lo stesso evento che chiude quella opposta.                       |
//+------------------------------------------------------------------+
void ChiudiSeContraria(const bool vuoleLong)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(PositionGetString(POSITION_SYMBOL)!=_Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      bool isLong=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
      if(isLong==vuoleLong) continue;           // gia' dalla parte giusta: non si tocca
      if(gTrade.PositionClose(tk))
        {
         gCntUscitaCross++;
         Log(StringFormat("incrocio opposto: chiusa la posizione %I64u (%s).", tk, isLong?"LONG":"SHORT"));
        }
      else
         Log(StringFormat("incrocio opposto: chiusura FALLITA su %I64u: %s (retcode %d). La posizione resta, lo stop la copre.",
             tk, gTrade.ResultRetcodeDescription(), (int)gTrade.ResultRetcode()));
     }
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
//| pavimento R109, poi lo STOPS_LEVEL del broker; il target, se c'e',|
//| nasce dallo stop VERO.                                            |
//| Ritorna true SOLO se l'ordine e' partito davvero.                 |
//+------------------------------------------------------------------+
bool Enter(const bool isLong, const double atr)
  {
   double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0 || atr<=0) return(false);
   double entry = isLong ? ask : bid;

   //--- STOP dalla fonte: InpKStop x ATR.
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

   //--- TARGET: solo se InpTP_RR > 0. Di default NON c'e': l'uscita e'
   //    l'incrocio opposto, cioe' l'indicatore stesso.
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
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_Cycle"))
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

   gIngressiOggi++;
   gCntIngressi++;
   if(gIngressiOggi>gMaxIngressiGiorno) gMaxIngressiGiorno=gIngressiOggi;
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
      Log(StringFormat("QUANTIZZAZIONE DEL LOTTO: voluto %.4f, piazzato %.2f, rischio voluto %.2f%%, rischio VERO %.2f%% (taglio %.1f%%).",
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
//| blocco NON fa niente. E' voluto: la cella "indicatore puro"       |
//| dev'essere incrocio dentro / incrocio fuori, e basta.             |
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
      //    da solo.
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
      //    del 07/08/2026 si portava dietro anche il breakeven.
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
//| NASCE SPENTO: e' l'unico orologio di questo EA.                   |
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
//| PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO (08/08/26). |
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
void AutoTestCycle()
  {
   int falliti=0;

   PrintFormat("[CYCLE][AUTOTEST] Stoch %d/%d %d/%d %d/%d %d/%d | MM %d | verso %d | kStop %.2f | ATR(%d) | TP %.2f R | %s | magic %I64d",
               InpK1Len,InpK1Smo, InpK2Len,InpK2Smo, InpK3Len,InpK3Smo, InpK4Len,InpK4Smo,
               InpMmLen, InpVerso, InpKStop, InpAtrPeriod, InpTP_RR, _Symbol, InpMagic);

   //--- 1) I PESI. E' il controllo che vale di piu', perche' un refuso su
   //    un peso NON si vede in nessun altro modo: l'indicatore continua a
   //    disegnare una linea plausibile.
   //    Il falsificatore: se i quattro pesi sommassero a un numero diverso
   //    dal divisore, allora con TUTTI i K uguali a 50 il composito NON
   //    farebbe 50. Con 4.0 al posto di 4.1 farebbe 49.57.
   double w[]; CicloPesi_Get(w);
   double somma = w[0]+w[1]+w[2]+w[3];
   double i50   = CompositoI_Calc(50.0,50.0,50.0,50.0);     // atteso 50.00
   double i100  = CompositoI_Calc(100.0,100.0,100.0,100.0);  // atteso 100.00
   double i0    = CompositoI_Calc(0.0,0.0,0.0,0.0);          // atteso 0.00
   double iK1   = CompositoI_Calc(100.0,0.0,0.0,0.0);        // atteso 4.1*100/11.6 = 35.3448
   double iK4   = CompositoI_Calc(0.0,0.0,0.0,100.0);        // atteso 4.0*100/11.6 = 34.4828
   PrintFormat("[CYCLE][AUTOTEST] pesi 4.1/2.5/1.0/4.0 somma %.4f (atteso 11.6000 = il divisore) | I(50,50,50,50)=%.4f (atteso 50.0000) | I(100x4)=%.4f (atteso 100.0000) | I(0x4)=%.4f (atteso 0.0000) | solo K1=%.4f (atteso 35.3448) | solo K4=%.4f (atteso 34.4828)",
               somma, i50, i100, i0, iK1, iK4);
   if(MathAbs(somma-CicloDivisore_Get())>0.000001 ||
      MathAbs(i50-50.0)>0.000001 || MathAbs(i100-100.0)>0.000001 ||
      MathAbs(i0)>0.000001 ||
      MathAbs(iK1-35.344827586)>0.00001 || MathAbs(iK4-34.482758621)>0.00001) falliti++;

   //--- 2) LO STOCASTICO GREZZO, compresa la protezione sul range nullo.
   double p1 = StocRaw_Calc(110.0,100.0,120.0);   // meta' del range -> 50
   double p2 = StocRaw_Calc(120.0,100.0,120.0);   // sul massimo     -> 100
   double p3 = StocRaw_Calc(100.0,100.0,120.0);   // sul minimo      -> 0
   double p4 = StocRaw_Calc(100.0,100.0,100.0);   // range NULLO     -> 50 (neutro, mai NaN)
   PrintFormat("[CYCLE][AUTOTEST] stocastico grezzo: meta'=%.2f (atteso 50.00) | massimo=%.2f (atteso 100.00) | minimo=%.2f (atteso 0.00) | range nullo=%.2f (atteso 50.00, NON NaN)",
               p1,p2,p3,p4);
   if(MathAbs(p1-50.0)>0.0001 || MathAbs(p2-100.0)>0.0001 ||
      MathAbs(p3)>0.0001 || MathAbs(p4-50.0)>0.0001) falliti++;

   //--- 3) L'INCROCIO DELLO ZERO, compreso lo zero esatto.
   int c1 = CrossCiclo_Calc( 0.5,-0.5);   // da sotto a sopra -> +1
   int c2 = CrossCiclo_Calc(-0.5, 0.5);   // da sopra a sotto -> -1
   int c3 = CrossCiclo_Calc( 0.8, 0.5);   // tutte e due sopra -> 0
   int c4 = CrossCiclo_Calc(-0.8,-0.5);   // tutte e due sotto -> 0
   int c5 = CrossCiclo_Calc( 0.0,-0.5);   // atterra ESATTAMENTE su zero da sotto -> +1
   int c6 = CrossCiclo_Calc( 0.0, 0.0);   // appoggiata a zero due barre -> 0 (niente segnale ripetuto)
   int c7 = CrossCiclo_Calc(-0.5, 0.0);   // da zero a sotto -> -1
   PrintFormat("[CYCLE][AUTOTEST] incrocio: su=%d (atteso 1) | giu=%d (atteso -1) | entrambe sopra=%d (atteso 0) | entrambe sotto=%d (atteso 0) | zero esatto da sotto=%d (atteso 1) | zero su zero=%d (atteso 0) | da zero a sotto=%d (atteso -1)",
               c1,c2,c3,c4,c5,c6,c7);
   if(!(c1==1 && c2==-1 && c3==0 && c4==0 && c5==1 && c6==0 && c7==-1)) falliti++;

   //--- 4) IL VERSO, cioe' il falsificatore del round. Le due colonne
   //    DEVONO essere l'una il rovescio dell'altra: se non lo sono,
   //    l'asse InpVerso non misura quello che il file prova dice.
   bool v1 = VuoleLong_Calc(+1,0);   // con l'incrocio, su   -> LONG
   bool v2 = VuoleLong_Calc(-1,0);   // con l'incrocio, giu  -> SHORT
   bool v3 = VuoleLong_Calc(+1,1);   // contro, su           -> SHORT
   bool v4 = VuoleLong_Calc(-1,1);   // contro, giu          -> LONG
   PrintFormat("[CYCLE][AUTOTEST] verso: (su,con)=%d (atteso 1) | (giu,con)=%d (atteso 0) | (su,contro)=%d (atteso 0) | (giu,contro)=%d (atteso 1) -- le due coppie sono l'una il rovescio dell'altra",
               (int)v1,(int)v2,(int)v3,(int)v4);
   if(!(v1 && !v2 && !v3 && v4)) falliti++;

   //--- 5) IL PAVIMENTO DELLO STOP (entry 100, stop grezzo a 99,8 = 0,2)
   double f1 = PavimentoSL_Calc(true, 100.0, 99.8, 1.0);   // pavimento 1,0 -> allargato a 99,0
   double f2 = PavimentoSL_Calc(true, 100.0, 97.0, 1.0);   // gia' oltre il pavimento -> invariato
   double f3 = PavimentoSL_Calc(true, 100.0, 99.8, 0.0);   // pavimento spento -> invariato
   double f4 = PavimentoSL_Calc(false,100.0,100.2, 1.0);   // short -> allargato a 101,0
   PrintFormat("[CYCLE][AUTOTEST] pavimento SL: %.2f (atteso 99.00) | %.2f (atteso 97.00) | %.2f (atteso 99.80) | short %.2f (atteso 101.00)",
               f1,f2,f3,f4);
   if(MathAbs(f1-99.0)>0.0001 || MathAbs(f2-97.0)>0.0001 ||
      MathAbs(f3-99.8)>0.0001 || MathAbs(f4-101.0)>0.0001) falliti++;

   //--- 6) IL CANCELLO DI SPREAD IN % DELLO STOP (R55)
   bool g1 = SpreadGate_Calc( 2.0,100.0,2.5);   // 2,0% -> passa
   bool g2 = SpreadGate_Calc( 2.5,100.0,2.5);   // sul bordo -> passa (<=)
   bool g3 = SpreadGate_Calc( 3.0,100.0,2.5);   // 3,0% -> blocca
   bool g4 = SpreadGate_Calc( 3.0,200.0,2.5);   // stesso spread, stop DOPPIO -> passa
   bool g5 = SpreadGate_Calc( 2.0,  0.0,2.5);   // stop nullo -> blocca
   PrintFormat("[CYCLE][AUTOTEST] spread gate: 2.0%%=%d (atteso 1) | bordo 2.5%%=%d (atteso 1) | 3.0%%=%d (atteso 0) | stesso spread su stop DOPPIO=%d (atteso 1) | stop 0=%d (atteso 0)",
               (int)g1,(int)g2,(int)g3,(int)g4,(int)g5);
   if(!(g1 && g2 && !g3 && g4 && !g5)) falliti++;

   //--- 7) IL TARGET, che qui e' SPENTO di default (rr = 0).
   double t1 = TargetDaR_Calc(true, 100.0, 10.0, 2.0);   // atteso 120
   double t2 = TargetDaR_Calc(false,100.0, 10.0, 2.0);   // atteso 80
   double t3 = TargetDaR_Calc(true, 100.0, 10.0, 0.0);   // rr=0 -> nessun TP
   PrintFormat("[CYCLE][AUTOTEST] target: long %.2f (atteso 120.00) | short %.2f (atteso 80.00) | rr=0 -> %.2f (atteso 0.00, cioe' NESSUN TP: esce l'indicatore)",
               t1,t2,t3);
   if(MathAbs(t1-120.0)>0.0001 || MathAbs(t2-80.0)>0.0001 || MathAbs(t3)>0.0001) falliti++;

   //--- 8) L'ORARIO (ORA SERVER)
   bool o1 = OraAmmessa_Calc(15,14,20);    // dentro
   bool o2 = OraAmmessa_Calc(21,14,20);    // fuori
   bool o3 = OraAmmessa_Calc(14,14,20);    // estremo incluso
   bool o4 = OraAmmessa_Calc( 2,22, 6);    // fascia a cavallo della mezzanotte
   PrintFormat("[CYCLE][AUTOTEST] orario: 15 in 14-20=%d (atteso 1) | 21=%d (atteso 0) | estremo 14=%d (atteso 1) | 2 in 22-6=%d (atteso 1)",
               (int)o1,(int)o2,(int)o3,(int)o4);
   if(!(o1 && !o2 && o3 && o4)) falliti++;

   //--- 9) IL CICLO SUI DATI VERI, e vale come SANITY sul mercato.
   //    >>> IL FALSIFICATORE GIUSTO E' IL SEGNO, NON LA TAGLIA.
   //        I sta fra 0 e 100 e NON E' MAI NEGATIVO: quindi un valore
   //        NEGATIVO del ciclo prova, da solo, che la sottrazione della
   //        SMA e' avvenuta. Se invece il numero stesse stabilmente
   //        intorno a 50 e non scendesse mai sotto zero, si starebbe
   //        leggendo I al posto del ciclo.
   //    >>> E LA TAGLIA NON E' "DELL'ORDINE DELLE UNITA'": e' MISURATA
   //        fuori da MT5 (12 semi x 4.000 barre, random walk / random
   //        walk con deriva / serie a onde):
   //           |ciclo| mediana 6,8 - 9,7 | p95 19,4 - 23,7 | max 38,7
   //        Cioe' un [1] = -25 e' NORMALE e non e' un difetto. Questa
   //        riga prima diceva "numeri piccoli, dell'ordine delle
   //        unita'": era un'attesa SBAGLIATA, e avrebbe fatto sospettare
   //        un bug davanti a un valore sano (14/09/2026).
   double cyc[];
   if(CycleSeries(gTF,2,cyc))
      PrintFormat("[CYCLE][AUTOTEST] ciclo sui dati veri: [1]=%.4f [2]=%.4f (DEVE poter essere NEGATIVO: I sta fra 0 e 100 e non e' mai negativo, quindi il segno meno prova la sottrazione. Banda MISURATA fuori MT5: |ciclo| mediana 6,8-9,7, p95 19,4-23,7, max 38,7 -- un -25 e' NORMALE. Se stesse fermo intorno a +50 si starebbe leggendo I, non il ciclo.)",
                  cyc[1], cyc[2]);
   else
      Print("[CYCLE][AUTOTEST] ciclo sui dati veri: storia ancora insufficiente in OnInit. NON e' un errore: si ricalcola alla prima barra utile.");

   //--- 10) IL MINIMO/MASSIMO LOCALE (MODO_MINIMO_LOCALE, aggiunto 14/09).
   //    Stessa idea del blocco 3: pattern puramente ordinale, zero soglie.
   int e1 = EstremoCiclo_Calc( 5.0, 2.0, 4.0);    // scende poi risale: minimo in cyc2 -> +1
   int e2 = EstremoCiclo_Calc( 2.0, 5.0, 4.0);    // sale poi scende: massimo in cyc2  -> -1
   int e3 = EstremoCiclo_Calc( 6.0, 5.0, 4.0);    // monotona crescente (indietro nel tempo) -> 0
   int e4 = EstremoCiclo_Calc( 4.0, 5.0, 6.0);    // monotona nell'altro verso -> 0
   int e5 = EstremoCiclo_Calc( 3.0, 3.0, 5.0);    // plateau su un lato -> 0 (niente segnale ripetuto)
   int e6 = EstremoCiclo_Calc(-4.0,-12.0,-3.0);   // minimo NEGATIVO (il caso di Claudio, es. -11/-12) -> +1
   PrintFormat("[CYCLE][AUTOTEST] estremo locale: minimo=%d (atteso 1) | massimo=%d (atteso -1) | monot.su=%d (atteso 0) | monot.giu=%d (atteso 0) | plateau=%d (atteso 0) | minimo negativo (-12)=%d (atteso 1)",
               e1,e2,e3,e4,e5,e6);
   if(!(e1==1 && e2==-1 && e3==0 && e4==0 && e5==0 && e6==1)) falliti++;

   Print("[CYCLE][AUTOTEST] esito motore: ", (falliti==0
         ? "NOVE BLOCCHI SU NOVE, la regola ragiona come la formula."
         : "DIVERGE: non usare i risultati, c'e' da guardare il codice."));

   //--- e la guardia del conto, col suo autotest gia' pronto nell'include
   ABTG_AutotestGuardia();
  }

//+------------------------------------------------------------------+
//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                  //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione).//
//                                                                   //
//  QUI LE COLONNE SONO 20: le dieci in piu' sono i CONTATORI        //
//  DIAGNOSTICI, e su un motore nuovo dicono piu' del PF.            //
//    stats[10] Pavimento SL Morso   -> lo stop misurava il pavimento?//
//    stats[11] Lotto Alzato 228     -> rischio VERO sopra il detto  //
//    stats[12] Lotto Tagliato 5pct  -> rischio VERO sotto il detto  //
//    stats[13] Spread Gate Rifiuti  -> il cancello R55 sta filtrando//
//    stats[14] Incroci Visti        -> IL DENOMINATORE VERO          //
//    stats[15] Guardian Rifiuti     -> nel tester dev'essere 0      //
//    stats[16] Uscite Su Incrocio   -> quante uscite le fa l'indicat.//
//    stats[17] Barre Tenute         -> / Ingressi = durata media     //
//    stats[18] Max Ingressi Giorno  -> a quanto tarare il tetto C6   //
//    stats[19] Ingressi             -> Incroci - Ingressi = i persi  //
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
//| il file -> i numeri per cella si leggono nell'OPTFRAME.           |
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
   double stats[20];
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
   //--- e le dieci che dicono se il round ha misurato il SEGNALE o un tappo
   stats[10] = (double)gCntPavimentoSL;
   stats[11] = (double)gCntLottoAlzato;
   stats[12] = (double)gCntLottoTagliato;
   stats[13] = (double)gCntSpreadGate;
   stats[14] = (double)gCntIncroci;
   stats[15] = (double)gCntGuardian;
   stats[16] = (double)gCntUscitaCross;
   stats[17] = (double)gBarreTenute;
   stats[18] = (double)gMaxIngressiGiorno;
   stats[19] = (double)gCntIngressi;
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore,Pavimento SL Morso,Lotto Alzato 228,Lotto Tagliato 5pct,Spread Gate Rifiuti,Incroci Visti,Guardian Rifiuti,Uscite Su Incrocio,Barre Tenute,Max Ingressi Giorno,Ingressi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- la guardia su ArraySize non e' cosmetica: -1 dice "questa passata
      //    NON ha prodotto il contatore" ed e' diverso da 0, che dice "il
      //    contatore ha girato e non ha contato niente".
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                (ArraySize(data)> 7?data[ 7]: 0.0), (ArraySize(data)> 8?data[ 8]: 0.0),
                                (ArraySize(data)> 9?data[ 9]: 0.0), (ArraySize(data)>10?data[10]:-1.0),
                                (ArraySize(data)>11?data[11]:-1.0), (ArraySize(data)>12?data[12]:-1.0),
                                (ArraySize(data)>13?data[13]:-1.0), (ArraySize(data)>14?data[14]:-1.0),
                                (ArraySize(data)>15?data[15]:-1.0), (ArraySize(data)>16?data[16]:-1.0),
                                (ArraySize(data)>17?data[17]:-1.0), (ArraySize(data)>18?data[18]:-1.0),
                                (ArraySize(data)>19?data[19]:-1.0));
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
