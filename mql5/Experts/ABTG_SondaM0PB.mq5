//+------------------------------------------------------------------+
//|                                            ABTG_SondaM0PB.mq5     |
//|                                                                  |
//|  LA SONDA DI FREQUENZA DI M0PB -- E' UN CONTATORE, NON UN EA.     |
//|  PASSO 0 del promosso (9/10) della CACCIA FREQUENZA del 31/08.    |
//|                                                                  |
//|  ==============================================================  |
//|  QUESTO FILE NON APRE ORDINI. MAI. NEMMENO NEL TESTER.            |
//|  Non esiste #include <Trade/Trade.mqh>, non esiste nessun         |
//|  CTrade, non esiste nessun OrderSend, nessun PositionClose,       |
//|  nessun calcolo di lotto, nessun calcolo di rischio, nessun       |
//|  magic number (un magic serve a riconoscere ORDINI PROPRI: qui    |
//|  non ce ne sono). L'identificatore della corsa e' InpTag, che e'  |
//|  una ETICHETTA per i file e per il log, non un magic.             |
//|  LA RIGA DI GREP CHE LO DIMOSTRA STA NEL REFERTO, NON QUI, ED E'  |
//|  VOLUTO: scriverne il modello dentro il file lo farebbe           |
//|  combaciare CON SE STESSO e il controllo tornerebbe sempre        |
//|  sporco (successo alla prima stesura di questo file, corretto).   |
//|  ATTESO: ZERO occorrenze delle chiamate di trading FUORI dalle    |
//|  righe di commento. Le uniche occorrenze in tutto il sorgente     |
//|  sono le sei righe qui sopra, che le NEGANO.                      |
//|  ==============================================================  |
//|                                                                  |
//|  PRECEDENTE DI CASA, seguito riga per riga come pattern           |
//|  (firma di Claudio del 21/08, "metro, frequenza"):                |
//|    mql5\Scripts\ABTG_SondaMediazione.mq5                          |
//|    risultati_archivio\SONDA_MEDIAZIONE_FREQUENZA_2026-08-21.md    |
//|  Regola di quella sonda, che vale identica qui: NESSUN ordine,    |
//|  nessun lotto, nessun sizing, nessun forward, nessuna sedia --    |
//|  SOLO IL CONTEGGIO. E il conteggio deve poter essere RICONTATO A  |
//|  MANO: per questo esce anche un CSV riga-per-segnale, non solo    |
//|  una stampa.                                                      |
//|                                                                  |
//|  >>> PERCHE' STA IN Experts\ E NON IN Scripts\ COME LA            |
//|      MEDIAZIONE (differenza voluta, dichiarata):                  |
//|      la Mediazione leggeva lo storico H1 di tre cross da un       |
//|      grafico qualsiasi e non aveva bisogno del tester. Qui il     |
//|      file prova pinna @SIMBOLO / @PERIODO / @DAQUANDO e i         |
//|      cinque numeri devono uscire in COLONNE di OPTFRAME (perche'  |
//|      InpStopAtrMult e' sweepabile e in ottimizzazione le Print    |
//|      girano sugli agent e non le legge nessuno -- CHECKLIST       |
//|      punto 34, ribadito al 99). Un .mq5 in Scripts\ NON HA        |
//|      OnTester. Quindi: Expert Advisor che non fa l'expert.        |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  ORIGINE E ATTRIBUZIONE (obbligatoria, licenza MPL 2.0)           |
//|  ------------------------------------------------------------    |
//|  Meccanica di SEGNALE derivata da "M0PB" (Momentum Pull Back)     |
//|  di (c) Marcns_, TradingView, created 2022-12-13, Pine v5,        |
//|  scriptAccess "open_no_auth", licenza MOZILLA PUBLIC LICENSE 2.0  |
//|  dichiarata alla riga 1 del sorgente.                             |
//|    https://www.tradingview.com/script/GnsUpEsB-M0PB-Momentum-Pullback/
//|  Copia integrale archiviata in casa e letta riga per riga:        |
//|    caccia_strategie\biblioteca\sorgenti\                          |
//|    M0PB_MomentumPullback_Marcns_MPL2_tvGnsUpEsB_2026-08-31.pine   |
//|  Da quel sorgente questa sonda riproduce SOLO LA LOGICA DI        |
//|  SEGNALE e la GEOMETRIA di take e stop. NON riproduce gli         |
//|  ordini, la quantita' fissa di 2 contratti, la chiusura           |
//|  simulata alla barra dopo: quelle parti non servono a contare.    |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  LE TRE DOMANDE, E SONO LE UNICHE                                 |
//|  ------------------------------------------------------------    |
//|  dossier: caccia_strategie\CACCIA_FREQUENZA_2026-08-31.md (P1)    |
//|  criteri: prove\M0PB_FREQUENZA_M5.txt + gemella M15 (ex _BOZZA,   |
//|           promossa il 31/08 sera: criteri IDENTICI, congelati)     |
//|  firma  : report\FIRME_2026-08-31.md (FIRMA 2, cancello H8)       |
//|                                                                  |
//|   1. Quante volte al giorno, PER LATO, il mercato offre un        |
//|      impulso estremo seguito da un rientro?                       |
//|          CANCELLO F1: < 1,00 segnali/giorno -> MORTO.             |
//|   2. Quanto spazio ha davanti quel rientro, in PUNTI INDICE?      |
//|          CANCELLO F2: take mediano < 6,0 punti -> MORTO.          |
//|   3. Quel premio quanto vale contro il rischio?                   |
//|          CANCELLO H8 (firmato oggi): RR mediano < 0,70 -> MORTO   |
//|          PER ARITMETICA, senza spendere una corsa a tick.         |
//|                                                                  |
//|  I tre cancelli sono CONGELATI PRIMA di vedere qualunque numero.  |
//|  Questa sonda li stampa gia' applicati, cosi' nessuno li puo'     |
//|  ammorbidire dopo averli letti.                                   |
//|                                                                  |
//|  E I NUMERI SONO SEMPRE DUE, MAI UNO: LONG e SHORT SEPARATI       |
//|  (regola dei due lati, Claudio 25/08). Qui i due lati stanno      |
//|  nella STESSA corsa -- si puo' fare perche' non si apre niente e  |
//|  quindi non esiste nessuna posizione che i due lati si            |
//|  contendono -- ma NON esiste una sola colonna aggregata dei due:  |
//|  ogni numero di merito ha la sua colonna Long e la sua Short.     |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  COSA QUESTA SONDA NON DICE, e non e' una dimenticanza            |
//|  ------------------------------------------------------------    |
//|   - NON dice se M0PB guadagna. Un conteggio dice se un motore e'  |
//|     MISURABILE e se ha SPAZIO, non se ha EDGE. L'edge si misura   |
//|     a tick, dopo, e solo se questi numeri reggono (R57).          |
//|   - NON esce nessuna colonna di P/L, di Profit Factor, di         |
//|     drawdown: senza operazioni sarebbero tutti ZERO, e uno zero   |
//|     in colonna verrebbe letto prima o poi come un risultato.      |
//|     L'unica cosa che questa corsa produce sono CONTEGGI e         |
//|     DISTANZE.                                                     |
//|   - NON promuove niente e non tocca nessuna sedia viva.           |
//|                                                                  |
//|  DEMO. ASCII puro: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa qui perche' i log e i     |
//|  CSV finiscono negli stessi strumenti).                           |
//|  NON compilato ne' eseguito da chi ha scritto il file: in quel    |
//|  ambiente non esistono MetaEditor ne' Strategy Tester. Si         |
//|  compila in MetaEditor prima di qualunque corsa.                  |
//+------------------------------------------------------------------+
//
//  MAPPA PINE <-> CODICE (verificabile riga per riga sul sorgente)
//  ------------------------------------------------------------------
//  riga .pine | Pine                          | qui
//  -----------|-------------------------------|-------------------------
//  20         | r = ta.rsi(close,6)           | RsiWilderSerie_Calc + InpRsiPeriod
//  25         | if r >= 90 -> b := 1.0        | InpRsiHigh, armamento LONG
//  33         | if r <= 10 -> s := -1.0       | InpRsiLow,  armamento SHORT
//  46         | es = ta.ema(high,5)           | EmaSerie_Calc su HIGH, InpEmaPeriod
//  49         | el = ta.ema(low,5)            | EmaSerie_Calc su LOW,  InpEmaPeriod
//  55         | low[1] > el[1] and low <= el  | TriggerLong_Calc
//  62         | high[1] < es[1] and high>= es | TriggerShort_Calc
//  70         | ta.barssince(b==1.0) < 6      | FinestraArmata_Calc + InpFinestraBarre
//  80         | ta.barssince(s==-1.0) < 6     | FinestraArmata_Calc (specchio)
//  92         | ph = ta.highest(12)           | Massimo_Calc, InpBarreTarget  [T2]
//  95         | pl = ta.lowest(12)            | Minimo_Calc,  InpBarreTarget  [T2]
//  99         | atr_inp = input.float(2.75)   | InpStopAtrMult (UNICO input libero)
//  101        | atr = ta.atr(10)              | AtrSerie_Calc, InpAtrPeriod   [T3]
//  103/104    | stop = avg_price -/+ atr*inp  | InpStopAtrMult * atr          [T4]
//  108/112    | strategy.entry(..., 2)        | NON RIPRODOTTO: non si apre niente
//  116-126    | strategy.exit / close_all     | NON RIPRODOTTO: non si chiude niente
//
//
//  LE SCELTE DI TRADUZIONE, NUMERATE. Sono NOSTRE, non del Pine.
//  ==================================================================
//
//  T1. RSI PINE CONTRO iRSI DI MQL5 -- VERIFICATO, NON ASSUNTO.
//      ta.rsi(src,len) di Pine = 100 - 100/(1+rs) con
//      rs = ta.rma(guadagni,len)/ta.rma(perdite,len), e ta.rma e' la
//      MEDIA DI WILDER (alfa = 1/len) SEMINATA con la SMA dei primi
//      len valori. iRSI di MQL5 fa ESATTAMENTE la stessa cosa
//      (RSI.mq5 di serie: seme = somma/periodo dei primi len delta,
//      poi ricorsione (prec*(len-1)+nuovo)/len). QUINDI I DUE
//      COINCIDONO, e non e' un'opinione: la sonda calcola l'RSI col
//      PROPRIO codice puro E in parallelo legge iRSI, e mette lo
//      SCARTO MASSIMO fra i due in una colonna
//      ("Rsi Divergenza Max"). ATTESA: praticamente ZERO (~1e-10).
//      Se quella colonna non e' ~0, la traduzione e' sbagliata e i
//      numeri non valgono: e' un collaudo, non un ornamento.
//      Caso degenere dichiarato: perdite medie = 0 -> RSI 100 se ci
//      sono guadagni, 50 se il mercato e' perfettamente piatto (e'
//      la convenzione di RSI.mq5 di MQL5; Pine li' restituisce na).
//      Su un indice reale non capita mai; sta scritto perche' un
//      caso degenere non dichiarato e' un numero non spiegato.
//
//  T2. IL "MASSIMO MOBILE A 12 BARRE" -- QUI E' CONGELATO AL SEGNALE.
//      Nel Pine ph = ta.highest(12) e' passato come limit= di
//      strategy.exit e viene RICALCOLATO A OGNI BARRA: e' un target
//      che SCENDE da solo se il prezzo entra in consolidamento (e'
//      proprio la tesi dell'autore, riga 11-12 del sorgente).
//      QUESTA SONDA NON SIMULA L'USCITA, quindi non puo' e non deve
//      seguire il target mobile: MISURA LO SPAZIO CHE C'ERA DAVANTI
//      NELL'ISTANTE DEL SEGNALE, cioe' ta.highest(high,12) calcolato
//      SULLA BARRA DI SEGNALE, sulle 12 barre che finiscono con
//      quella barra (Pine include la barra corrente: 12 barre =
//      shift 0..11 al momento della decisione).
//      >>> CONSEGUENZA DA DICHIARARE NEL REFERTO: il take misurato
//      qui e' un LIMITE SUPERIORE di quello che il motore
//      incasserebbe davvero, perche' il target vero puo' solo
//      SCENDERE dopo. Se il take mediano MISURATO QUI non passa i
//      6,0 punti indice, quello vero passa ancora meno: il cancello
//      F2 e' quindi CONSERVATIVO NEL VERSO GIUSTO (boccia solo cio'
//      che merita di essere bocciato).
//      >>> E il valore puo' venire NON POSITIVO (il massimo delle
//      ultime 12 barre puo' stare SOTTO il prezzo d'ingresso dopo un
//      rientro profondo): quei casi NON entrano nella mediana del
//      take (un take negativo non e' un take) ma sono CONTATI in
//      colonna ("Take Non Positivi"), perche' sono segnali che il
//      motore prenderebbe e che non hanno nessuno spazio davanti.
//
//  T3. ATR PINE CONTRO iATR DI MQL5 -- QUI I DUE NON COINCIDONO.
//      E' la differenza piu' insidiosa del porting, e non riguarda
//      l'RSI: ta.atr(10) di Pine e' la RMA (Wilder, alfa = 1/10) del
//      True Range; iATR di MQL5 e' la MEDIA MOBILE SEMPLICE del True
//      Range (ATR.mq5 di serie: seme = media dei primi len TR, poi
//      ATR[i] = ATR[i-1] + (TR[i]-TR[i-len])/len, che e' una SMA
//      rotolante, non una Wilder). Sono due numeri diversi, e lo
//      stop dipende DIRETTAMENTE da questo.
//      SCELTA: default InpAtrModoPine = true, cioe' FEDELE AL PINE
//      (RMA di Wilder). Con InpAtrModoPine = false la sonda usa la
//      SMA del TR, cioe' la convenzione MT5: serve a due cose,
//      (a) misurare quanto pesa la differenza sullo stop mediano,
//      (b) fare da controllo, perche' in quella modalita' la colonna
//      "Atr Divergenza Rel Media Pct" contro iATR deve venire ~0.
//      True Range della PRIMA barra della finestra = high-low (e'
//      ta.tr di Pine): non c'e' una chiusura precedente.
//
//  T4. IL PREZZO D'INGRESSO -- il Pine entra alla barra DOPO.
//      strategy.entry(..., when=trade_l) in Pine v5 senza
//      process_orders_on_close esegue all'APERTURA DELLA BARRA
//      SUCCESSIVA a quella del segnale. La sonda fa lo stesso di
//      default (InpModoPrezzoIngresso = 1). Con 0 usa la CHIUSURA
//      della barra di segnale, che e' il prezzo "al momento del
//      segnale" citato dal dossier. Il take e lo stop si misurano
//      SEMPRE da questo prezzo, e i riferimenti (massimo mobile e
//      ATR) sono SEMPRE quelli della BARRA DI SEGNALE: cioe' quello
//      che era conoscibile quando la decisione e' stata presa.
//      Nel Pine lo stop e' misurato da strategy.position_avg_price
//      (il prezzo di riempimento): con il modo 1 e' la stessa cosa.
//
//  T5. IL SEGNALE NASCE SU BARRA CHIUSA, SEMPRE.
//      La sonda valuta la barra allo shift 1 (l'ultima CHIUSA) al
//      primo tick della barra nuova. Nessuna decisione tocca la
//      barra in formazione: niente repaint, per costruzione. Il
//      Pine originale e' senza calc_on_every_tick, quindi fa lo
//      stesso.
//
//  T6. I DUE LATI SONO INDIPENDENTI E POSSONO SPARARE SULLA STESSA
//      BARRA. Nel Pine sono due strategy.entry distinti e non c'e'
//      nessun blocco reciproco. Qui NON esiste nessun cap di
//      posizione, nessun "uno per volta": il cap (InpMaxTradesPerDay
//      dell'EA futuro) si TAGLIA SUI DATI, e i dati per tagliarlo
//      sono le colonne "Max Segnali Giorno". Mettere il cap dentro
//      la sonda vorrebbe dire misurare il cap invece del mercato.
//
//  T7. INDICATORI RICALCOLATI SU UNA CODA DI InpWarmupBarre BARRE
//      (default 300) a ogni barra nuova, con funzioni PURE che
//      lavorano su array. E' piu' lento di uno stato incrementale,
//      ma e' l'unica forma che l'AUTOTEST puo' interrogare a
//      tavolino. L'errore introdotto dal seme corto e' calcolabile e
//      trascurabile: la Wilder dell'RSI(6) dimentica il seme con
//      (5/6)^294 = 1e-23, quella dell'ATR(10) con (9/10)^290 =
//      1e-14. La colonna "Rsi Divergenza Max" contro iRSI (che parte
//      dall'inizio dello storico) lo verifica sul campo.
//
//  T8. PUNTI INDICE -- la conversione e' 100 e NON e' un'assunzione:
//      e' la misura del repo per U30USD, NASUSD e D30EUR (100 punti
//      MT5 = 1 punto indice; con SYMBOL_POINT = 0,01 il punto indice
//      vale 1,00 in prezzo). Sta in un input (InpPuntiPerIndice) e
//      il valore risultante ESCE IN COLONNA ("Punto Indice Prezzo"):
//      se su un simbolo non viene 1,00 il referto lo vede subito,
//      invece di leggere una taglia sbagliata di un fattore 10.
//
//  T9. LA GIORNATA = giornata di calendario del SERVER con almeno
//      una barra valutata. Non si contano i giorni del calendario
//      civile: un festivo senza barre non e' un giorno in cui il
//      motore "non ha trovato segnali", e' un giorno in cui il
//      mercato era chiuso. Dividere per quello gonfierebbe il
//      denominatore e ABBASSEREBBE la frequenza -- cioe'
//      sbaglierebbe contro il candidato.
//      L'ORA E' SEMPRE ORA SERVER (BCM = ora italiana - 1).
//
//  T10. LO SWEEP DI InpStopAtrMult E' ARITMETICO, E VA DETTO.
//      Lo stop e' mult * ATR: raddoppiando il moltiplicatore lo stop
//      mediano raddoppia esatto e l'RR si dimezza esatto. Quindi da
//      UNA SOLA corsa si legge tutta la curva:
//          RR(mult) = RR(2,75) * 2,75 / mult
//      Per questo esce anche "Atr Mediano Punti Indice": con quello
//      e il take mediano l'RR di qualunque moltiplicatore si
//      ricalcola a mano. Lo sweep resta possibile (l'input c'e', ed
//      e' la manopola del cancello H8) ma serve a CONFERMARE
//      l'aritmetica, non a scoprirla -- e soprattutto non a
//      PESCARE il moltiplicatore che fa passare il cancello.
//      >>> Attenzione, e va scritto nel referto: alzare l'RR
//      stringendo lo stop NON e' gratis. Meno spazio = piu' stop
//      presi. La sonda NON puo' vedere quel costo (non simula
//      esiti): lo vedra' la corsa a tick, dopo.
//+------------------------------------------------------------------+
#property copyright "ABTG - Sonda di frequenza M0PB (PASSO 0, caccia 31/08/2026)"
#property version   "1.00"
#property description "CONTATORE di segnali M0PB (impulso RSI + rientro EMA5). NON APRE ORDINI."
#property strict

//--- LE SOGLIE CONGELATE PRIMA DI VEDERE I NUMERI. Sono #define e non
//    input APPOSTA: un cancello che si puo' spostare dalla riga di
//    lancio non e' un cancello.
#define M0PB_SOGLIA_SEGNALI_GIORNO  1.00    // F1, pavimento di Claudio
#define M0PB_SOGLIA_TAKE_PUNTI      6.00    // F2, 3 x 2,0 punti di spread [STIMA]
#define M0PB_SOGLIA_RR              0.70    // H8, FIRME_2026-08-31.md FIRMA 2
#define M0PB_E_TARGET_R             0.075   // H8, E >= 0,075R a tick

//--- capienza dei campioni per le mediane. Su M5 e 2 anni i segnali
//    attesi sono qualche migliaio per lato: 100.000 e' abbondante.
//    Se si arrivasse al tetto la mediana sarebbe TRONCATA, quindi il
//    fatto viene stampato a voce alta invece di essere ingoiato.
#define M0PB_MAX_CAMPIONI 100000

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI dal file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO, e' cosi' che e' nato il falso "0/8" del
//  FiboH4). NOTA: la BOZZA del 31/08 proponeva "InpAtrStopMult";
//  il nome VERO, quello che esiste in questo file, e'
//  >>> InpStopAtrMult <<<. Va aggiornato nel file prova.
//==================================================================
input group "=== IL MOTORE DI SEGNALE (tutto cablato dall'autore) ==="
input int    InpRsiPeriod      = 6;      // RSI: periodo (Pine riga 20)
input double InpRsiHigh        = 90.0;   // RSI: estremo che ARMA il LONG (Pine riga 25)
input double InpRsiLow         = 10.0;   // RSI: estremo che ARMA lo SHORT (Pine riga 33)
input int    InpEmaPeriod      = 5;      // EMA su HIGH e su LOW: le due bande d'ingresso
input int    InpFinestraBarre  = 6;      // barssince(estremo) < N: scadenza dell'armamento
input int    InpBarreTarget    = 12;     // massimo/minimo mobile: barre del target

input group "=== LO STOP -- L'UNICA MANOPOLA, ED E' QUELLA DEL CANCELLO H8 ==="
input int    InpAtrPeriod      = 10;     // ATR: periodo (Pine riga 101)
input double InpStopAtrMult    = 2.75;   // stop = N x ATR. UNICO input libero del sorgente. SWEEPABILE
input bool   InpAtrModoPine    = true;   // true = ATR alla Pine (Wilder/RMA). false = SMA del TR (modo MT5). Vedi T3

input group "=== TRADUZIONE (scelte nostre, dichiarate) ==="
input int    InpModoPrezzoIngresso = 1;  // 1 = apertura barra successiva (come il Pine). 0 = chiusura barra di segnale. Vedi T4
input double InpPuntiPerIndice = 100.0;  // punti MT5 per 1 punto indice. MISURATO = 100 su U30USD/NASUSD/D30EUR. Vedi T8

input group "=== FINESTRA ORARIA (default NEUTRO: si conta TUTTO) ==="
input bool   InpUsaFinestraOraria = false; // false = nessun filtro orario: si conta tutta la giornata
input int    InpOraInizioServer   = 14;    // ORA SERVER BCM (italiana - 1). 14 = 15:00 IT, apertura US
input int    InpOraFineServer     = 21;    // ORA SERVER BCM, inclusa

input group "=== TECNICI ==="
input int    InpWarmupBarre    = 300;    // coda di barre su cui si ricalcolano gli indicatori. Vedi T7
input bool   InpConfrontaMT5   = true;   // legge anche iRSI/iATR e mette lo SCARTO in colonna (collaudo T1/T3)
input bool   InpScriviCsv      = true;   // CSV riga-per-segnale + CSV totali (SOLO fuori ottimizzazione)
input bool   InpVerbose        = true;   // log (in ottimizzazione NON li legge nessuno: vedi le colonne)
input bool   InpAutoTest       = true;   // autotest del nucleo puro. L'esito esce in COLONNA
input string InpTag            = "M0PB_SONDA"; // ETICHETTA della corsa (NON e' un magic: qui non ci sono ordini)

//==================================================================
//  STATO -- tutti accumulatori di conteggio. Nessuno stato di
//  posizione, perche' non esistono posizioni.
//==================================================================
datetime gLastBar = 0;

//--- handle dei DUE indicatori MT5, usati SOLO per il collaudo T1/T3
int    hRsiMt5 = INVALID_HANDLE;
int    hAtrMt5 = INVALID_HANDLE;

//--- conversione prezzo <-> punto indice
double gPuntoIndice = 0.0;

//--- conteggi generali
long   gBarreValutate   = 0;
long   gBarreSaltateDati= 0;   // storico corto: la barra non e' stata valutata
long   gScartatiOrario  = 0;   // segnali caduti fuori dalla finestra oraria

//--- conteggi per LATO (mai aggregati in una colonna sola)
long   gSegnaliLong  = 0,  gSegnaliShort  = 0;
long   gEstremiLong  = 0,  gEstremiShort  = 0;
long   gTakeNegLong  = 0,  gTakeNegShort  = 0;

//--- giornate
int    gDayStamp        = -1;
int    gDaySigLong      = 0, gDaySigShort = 0;
long   gGiorniContati   = 0;
long   gMaxGiornoLong   = 0, gMaxGiornoShort = 0, gMaxGiornoTot = 0;
long   gG1Long = 0, gG2Long = 0, gG1Short = 0, gG2Short = 0;
long   gG1Tot  = 0, gG2Tot  = 0, gGiorniZero = 0;

//--- campioni per le mediane (in PUNTI INDICE)
double gTakeL[], gTakeS[], gStopL[], gStopS[], gRrL[], gRrS[], gAtrPts[];
int    gNTakeL = 0, gNTakeS = 0, gNStopL = 0, gNStopS = 0;
int    gNRrL   = 0, gNRrS   = 0, gNAtr   = 0;
bool   gTroncato = false;

//--- somme per le medie (la media accanto alla mediana dice l'asimmetria)
double gSommaTakeL = 0.0, gSommaTakeS = 0.0;

//--- collaudo T1/T3
double gRsiDivMax    = 0.0;
double gAtrDivRelSom = 0.0;
long   gAtrDivN      = 0;

//--- autotest: -1 = NON eseguito, che non e' "passato"
int    gAutotestFalliti = -1;
int    gAutotestBlocchi = 0;

//--- CSV riga-per-segnale
int    gCsvSeg = INVALID_HANDLE;

void Log(string m){ if(InpVerbose) Print("[M0PB-SONDA] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono numeri e rispondono. E' questa la parte che
//   l'AUTOTEST interroga a tavolino, senza mercato.
//
//==================================================================

//+------------------------------------------------------------------+
//| RSI da medie di Wilder gia' calcolate. Il caso degenere e'        |
//| esplicito (vedi T1): perdite nulle -> 100 se ci sono guadagni,    |
//| 50 se il mercato e' perfettamente piatto. E' la convenzione di    |
//| RSI.mq5 di MQL5.                                                  |
//+------------------------------------------------------------------+
double RsiDaMedie_Calc(const double mediaGuadagni, const double mediaPerdite)
  {
   if(mediaPerdite <= 0.0) return(mediaGuadagni > 0.0 ? 100.0 : 50.0);
   double rs = mediaGuadagni/mediaPerdite;
   return(100.0 - 100.0/(1.0 + rs));
  }

//+------------------------------------------------------------------+
//| RSI DI WILDER su tutta la serie (indice 0 = barra piu' VECCHIA).  |
//| Seme = media semplice dei primi 'periodo' delta, poi ricorsione   |
//| di Wilder: e' ta.rsi di Pine ed e' iRSI di MQL5 (vedi T1).        |
//| out[i] = -1 sulle barre in cui l'RSI non e' ancora definito: -1   |
//| e' fuori dal dominio [0,100], quindi nessun confronto di soglia   |
//| lo puo' scambiare per un valore vero.                             |
//+------------------------------------------------------------------+
bool RsiWilderSerie_Calc(const double &close[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n <= periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = -1.0;

   double sg = 0.0, sp = 0.0;
   for(int i = 1; i <= periodo; i++)
     {
      double d = close[i] - close[i-1];
      if(d > 0.0) sg += d; else sp += -d;
     }
   double ag = sg/(double)periodo;
   double ap = sp/(double)periodo;
   out[periodo] = RsiDaMedie_Calc(ag, ap);

   for(int i = periodo + 1; i < n; i++)
     {
      double d = close[i] - close[i-1];
      double g = (d > 0.0) ?  d : 0.0;
      double p = (d < 0.0) ? -d : 0.0;
      ag = (ag*(periodo - 1.0) + g)/(double)periodo;
      ap = (ap*(periodo - 1.0) + p)/(double)periodo;
      out[i] = RsiDaMedie_Calc(ag, ap);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| EMA alla Pine: seme = SMA dei primi 'periodo' valori, poi         |
//| alfa = 2/(periodo+1). Le barre prima del seme restano a 0 e non   |
//| vengono mai lette (il chiamante parte molto dopo).                |
//+------------------------------------------------------------------+
bool EmaSerie_Calc(const double &src[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += src[i];
   out[periodo - 1] = s/(double)periodo;

   double a = 2.0/(periodo + 1.0);
   for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(src[i] - out[i-1]);
   return(true);
  }

//+------------------------------------------------------------------+
//| TRUE RANGE alla Pine (ta.tr): sulla PRIMA barra della finestra    |
//| non c'e' chiusura precedente, quindi TR = high - low.             |
//+------------------------------------------------------------------+
bool TrSerie_Calc(const double &high[], const double &low[], const double &close[],
                  const int n, double &out[])
  {
   if(n < 1) return(false);
   if(ArrayResize(out, n) != n) return(false);
   out[0] = high[0] - low[0];
   for(int i = 1; i < n; i++)
     {
      double a = high[i] - low[i];
      double b = MathAbs(high[i] - close[i-1]);
      double c = MathAbs(low[i]  - close[i-1]);
      double m = a;
      if(b > m) m = b;
      if(c > m) m = c;
      out[i] = m;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ATR. modoRma = true -> Wilder/RMA, cioe' ta.atr di Pine.          |
//|      modoRma = false -> media mobile SEMPLICE del TR, cioe' la    |
//|      convenzione di iATR in MQL5. I DUE NUMERI SONO DIVERSI e     |
//|      lo stop dipende da questo: vedi T3.                          |
//+------------------------------------------------------------------+
bool AtrSerie_Calc(const double &tr[], const int n, const int periodo,
                   const bool modoRma, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += tr[i];
   out[periodo - 1] = s/(double)periodo;

   if(modoRma)
     {
      double a = 1.0/(double)periodo;
      for(int i = periodo; i < n; i++) out[i] = out[i-1] + a*(tr[i] - out[i-1]);
     }
   else
     {
      double somma = s;
      for(int i = periodo; i < n; i++)
        {
         somma += tr[i] - tr[i - periodo];
         out[i] = somma/(double)periodo;
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| MASSIMO / MINIMO su una finestra che FINISCE all'indice 'fine'    |
//| e comprende 'quante' barre (la barra 'fine' inclusa): e' esatta-  |
//| mente ta.highest(quante) / ta.lowest(quante) di Pine.             |
//+------------------------------------------------------------------+
double Massimo_Calc(const double &v[], const int n, const int fine, const int quante)
  {
   if(quante < 1 || fine < 0 || fine >= n) return(0.0);
   int da = fine - quante + 1;
   if(da < 0) da = 0;
   double m = v[da];
   for(int i = da + 1; i <= fine; i++) if(v[i] > m) m = v[i];
   return(m);
  }

double Minimo_Calc(const double &v[], const int n, const int fine, const int quante)
  {
   if(quante < 1 || fine < 0 || fine >= n) return(0.0);
   int da = fine - quante + 1;
   if(da < 0) da = 0;
   double m = v[da];
   for(int i = da + 1; i <= fine; i++) if(v[i] < m) m = v[i];
   return(m);
  }

//+------------------------------------------------------------------+
//| IL GRILLETTO LONG, Pine riga 55: low[1] > el[1] and low <= el.    |
//| I due confronti sono ASIMMETRICI nel sorgente ( > stretto sulla   |
//| barra prima, <= sulla barra corrente) e restano asimmetrici qui:  |
//| se la barra precedente TOCCAVA gia' la banda, non c'e' rientro.   |
//+------------------------------------------------------------------+
bool TriggerLong_Calc(const double lowPrec, const double emaLowPrec,
                      const double low,     const double emaLow)
  {
   return(lowPrec > emaLowPrec && low <= emaLow);
  }

//+------------------------------------------------------------------+
//| IL GRILLETTO SHORT, Pine riga 62: high[1] < es[1] and high >= es. |
//+------------------------------------------------------------------+
bool TriggerShort_Calc(const double highPrec, const double emaHighPrec,
                       const double high,     const double emaHigh)
  {
   return(highPrec < emaHighPrec && high >= emaHigh);
  }

//+------------------------------------------------------------------+
//| ta.barssince(estremo) < finestra. barreDa = -1 significa "non e'  |
//| mai successo": in Pine barssince e' na e na < 6 e' FALSO, quindi  |
//| qui deve venire falso. barreDa = 0 = l'estremo e' sulla barra     |
//| stessa del rientro: in Pine e' AMMESSO (0 < 6), e resta ammesso.  |
//+------------------------------------------------------------------+
bool FinestraArmata_Calc(const int barreDa, const int finestra)
  {
   if(barreDa < 0) return(false);
   if(finestra < 1) return(false);
   return(barreDa < finestra);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.  |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PUNTI INDICE. puntoIndice <= 0 -> 0,    |
//| che si legge "non convertibile", e la colonna                     |
//| "Punto Indice Prezzo" dice perche'.                               |
//+------------------------------------------------------------------+
double PuntiIndice_Calc(const double diffPrezzo, const double puntoIndice)
  {
   if(puntoIndice <= 0.0) return(0.0);
   return(diffPrezzo/puntoIndice);
  }

//+------------------------------------------------------------------+
//| IL NUMERO 5 DEL DOSSIER: RR = mediana(take) / mediana(stop).      |
//| E' definito COSI' nel dossier (numero 2 diviso numero 3), non     |
//| come mediana dei rapporti: sono due numeri diversi e la sonda li  |
//| stampa TUTTI E DUE, dichiarando quale e' il cancello.             |
//+------------------------------------------------------------------+
double RrDaMediane_Calc(const double takeMediano, const double stopMediano)
  {
   if(stopMediano <= 0.0) return(0.0);
   return(takeMediano/stopMediano);
  }

//+------------------------------------------------------------------+
//| L'ARITMETICA DEL CANCELLO H8, in una funzione sola.               |
//| Da E = p*RR - (1-p) segue p = (E+1)/(RR+1): e' il win rate        |
//| NECESSARIO perche' il valore atteso raggiunga E.                  |
//| Riproduce la tabella CONGELATA nel dossier (par. 5-bis):          |
//|   RR 0,36 -> 79,0% | 0,50 -> 71,7% | 0,73 -> 62,2% | 1,00 -> 53,8%|
//| L'autotest confronta con QUEI quattro valori: se la formula si    |
//| muove, il cancello si accorge.                                    |
//+------------------------------------------------------------------+
double WinRateNecessario_Calc(const double rr, const double eTarget)
  {
   if(rr <= -1.0) return(0.0);
   return((eTarget + 1.0)/(rr + 1.0));
  }

//+------------------------------------------------------------------+
//| La finestra oraria in ORA SERVER, estremi INCLUSI. Sostiene       |
//| anche il caso a cavallo della mezzanotte (inizio > fine), che su  |
//| un indice non serve ma su un futuro asiatico si'.                 |
//+------------------------------------------------------------------+
bool FinestraOraria_Calc(const int ora, const int inizio, const int fine, const bool attiva)
  {
   if(!attiva) return(true);
   if(ora < 0 || ora > 23) return(false);
   if(inizio <= fine) return(ora >= inizio && ora <= fine);
   return(ora >= inizio || ora <= fine);
  }

//==================================================================
//  RACCOLTA DEI CAMPIONI (memoria, non pensiero)
//==================================================================
void Aggiungi(double &v[], int &n, const double x)
  {
   if(n >= M0PB_MAX_CAMPIONI){ gTroncato = true; return; }
   if(n >= ArraySize(v))
     {
      int nuovo = (ArraySize(v) <= 0) ? 4096 : ArraySize(v)*2;
      if(nuovo > M0PB_MAX_CAMPIONI) nuovo = M0PB_MAX_CAMPIONI;
      if(ArrayResize(v, nuovo) <= n){ gTroncato = true; return; }
     }
   v[n] = x;
   n++;
  }

double Mediana(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   double c[];
   if(ArrayResize(c, n) != n) return(0.0);
   for(int i = 0; i < n; i++) c[i] = v[i];
   ArraySort(c);
   return(MedianaOrdinata_Calc(c, n));
  }

//==================================================================
//  CICLO DI VITA
//==================================================================

//+------------------------------------------------------------------+
//| AZZERAMENTO ESPLICITO DI TUTTI I CONTATORI.                       |
//| In ottimizzazione MT5 rilancia l'EA a ogni passata e le globali   |
//| dovrebbero ripartire dai loro valori iniziali -- DOVREBBERO. Con  |
//| InpStopAtrMult sweepabile, una passata che ereditasse i campioni  |
//| della precedente darebbe mediane sporche e nessuno se ne          |
//| accorgerebbe guardando il CSV: i numeri sarebbero plausibili e    |
//| sbagliati. Azzerare a mano costa una funzione e toglie il dubbio. |
//+------------------------------------------------------------------+
void AzzeraContatori()
  {
   gLastBar = 0;
   gBarreValutate = 0; gBarreSaltateDati = 0; gScartatiOrario = 0;
   gSegnaliLong = 0; gSegnaliShort = 0;
   gEstremiLong = 0; gEstremiShort = 0;
   gTakeNegLong = 0; gTakeNegShort = 0;
   gDayStamp = -1; gDaySigLong = 0; gDaySigShort = 0;
   gGiorniContati = 0;
   gMaxGiornoLong = 0; gMaxGiornoShort = 0; gMaxGiornoTot = 0;
   gG1Long = 0; gG2Long = 0; gG1Short = 0; gG2Short = 0;
   gG1Tot = 0; gG2Tot = 0; gGiorniZero = 0;
   gNTakeL = 0; gNTakeS = 0; gNStopL = 0; gNStopS = 0;
   gNRrL = 0; gNRrS = 0; gNAtr = 0;
   gTroncato = false;
   gSommaTakeL = 0.0; gSommaTakeS = 0.0;
   gRsiDivMax = 0.0; gAtrDivRelSom = 0.0; gAtrDivN = 0;
   gAutotestFalliti = -1; gAutotestBlocchi = 0;
  }

int OnInit()
  {
   AzzeraContatori();

   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che dice un'altra
   //    cosa da quella che c'e' scritta nel file prova.
   if(InpRsiPeriod < 2)
     { Print("ERRORE: InpRsiPeriod deve essere >= 2 (il sorgente dice 6)."); return(INIT_FAILED); }
   if(InpRsiHigh <= 50.0 || InpRsiHigh > 100.0)
     { Print("ERRORE: InpRsiHigh deve stare fra 50 (escluso) e 100 (il sorgente dice 90)."); return(INIT_FAILED); }
   if(InpRsiLow < 0.0 || InpRsiLow >= 50.0)
     { Print("ERRORE: InpRsiLow deve stare fra 0 e 50 (escluso) (il sorgente dice 10)."); return(INIT_FAILED); }
   if(InpEmaPeriod < 1)
     { Print("ERRORE: InpEmaPeriod deve essere >= 1 (il sorgente dice 5)."); return(INIT_FAILED); }
   if(InpFinestraBarre < 1)
     { Print("ERRORE: InpFinestraBarre deve essere >= 1 (il sorgente dice 6)."); return(INIT_FAILED); }
   if(InpBarreTarget < 1)
     { Print("ERRORE: InpBarreTarget deve essere >= 1 (il sorgente dice 12)."); return(INIT_FAILED); }
   if(InpAtrPeriod < 2)
     { Print("ERRORE: InpAtrPeriod deve essere >= 2 (il sorgente dice 10)."); return(INIT_FAILED); }
   if(InpStopAtrMult < 0.1 || InpStopAtrMult > 6.0)
     { Print("ERRORE: InpStopAtrMult deve stare fra 0,1 e 6,0: sono gli estremi che l'autore ha messo su input.float(2.75, minval=0.1, maxval=6.0). Fuori di li' si sta misurando un'altra cosa."); return(INIT_FAILED); }
   if(InpModoPrezzoIngresso != 0 && InpModoPrezzoIngresso != 1)
     { Print("ERRORE: InpModoPrezzoIngresso ammette solo 0 (chiusura barra di segnale) o 1 (apertura barra successiva, come il Pine)."); return(INIT_FAILED); }
   if(InpPuntiPerIndice <= 0.0)
     { Print("ERRORE: InpPuntiPerIndice deve essere > 0 (misurato = 100 su U30USD/NASUSD/D30EUR)."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23 || InpOraFineServer < 0 || InpOraFineServer > 23)
     { Print("ERRORE: le ore della finestra devono stare fra 0 e 23, e sono ORE SERVER (BCM = ora italiana - 1)."); return(INIT_FAILED); }

   //--- la coda deve bastare a TUTTI gli indicatori piu' un margine
   //    di riscaldamento vero, altrimenti il seme corto si vede.
   int minimo = InpRsiPeriod + InpAtrPeriod + InpEmaPeriod + InpBarreTarget + InpFinestraBarre + 50;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con questi periodi servono almeno %d barre (vedi T7).",
                  InpWarmupBarre, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 5000)
     { Print("ERRORE: InpWarmupBarre sopra 5000 rallenta la corsa senza guadagnare precisione (il seme e' gia' dimenticato: vedi T7)."); return(INIT_FAILED); }

   //--- conversione in punti indice, e la si DICHIARA subito.
   gPuntoIndice = InpPuntiPerIndice*_Point;
   if(gPuntoIndice <= 0.0)
     { Print("ERRORE: punto indice non calcolabile (SYMBOL_POINT nullo)."); return(INIT_FAILED); }
   if(MathAbs(gPuntoIndice - 1.0) > 0.001)
      Log(StringFormat("ATTENZIONE: il punto indice vale %.5f in prezzo, NON 1,00. Su U30USD/NASUSD/D30EUR (Point %.5f, conversione 100) deve venire 1,00. Se non viene, la TAGLIA del take esce sbagliata di un fattore: controllare InpPuntiPerIndice PRIMA di leggere qualunque numero.",
                       gPuntoIndice, _Point));

   //--- gli unici due handle del file, e non decidono NIENTE: servono
   //    solo al collaudo T1/T3 (le colonne di divergenza).
   if(InpConfrontaMT5)
     {
      hRsiMt5 = iRSI(_Symbol, PERIOD_CURRENT, InpRsiPeriod, PRICE_CLOSE);
      hAtrMt5 = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriod);
      if(hRsiMt5 == INVALID_HANDLE || hAtrMt5 == INVALID_HANDLE)
         Log("ATTENZIONE: handle iRSI/iATR non creati. Le colonne di divergenza resteranno a 0, cioe' IL COLLAUDO T1/T3 NON E' STATO FATTO (che non e' 'passato').");
     }

   ArrayResize(gTakeL, 0); ArrayResize(gTakeS, 0);
   ArrayResize(gStopL, 0); ArrayResize(gStopS, 0);
   ArrayResize(gRrL,   0); ArrayResize(gRrS,   0);
   ArrayResize(gAtrPts,0);

   if(InpAutoTest) AutoTestM0PB();

   Log(StringFormat("SONDA DI FREQUENZA M0PB avviata su %s %s. Etichetta '%s'. NON APRE ORDINI: e' un contatore.",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag));
   Log(StringFormat("motore: RSI(%d) estremi %.1f/%.1f NEL VERSO, rientro su EMA(%d) di HIGH/LOW entro %d barre, target = massimo mobile %d barre, stop = %.2f x ATR(%d) [%s].",
                    InpRsiPeriod, InpRsiHigh, InpRsiLow, InpEmaPeriod, InpFinestraBarre,
                    InpBarreTarget, InpStopAtrMult, InpAtrPeriod,
                    (InpAtrModoPine ? "ATR alla Pine, Wilder/RMA" : "ATR come SMA del TR, modo MT5")));
   Log(StringFormat("cancelli CONGELATI: F1 segnali/giorno >= %.2f | F2 take mediano >= %.1f punti indice | H8 RR mediano >= %.2f (E >= %.3fR a tick).",
                    M0PB_SOGLIA_SEGNALI_GIORNO, M0PB_SOGLIA_TAKE_PUNTI, M0PB_SOGLIA_RR, M0PB_E_TARGET_R));

   //--- il CSV riga-per-segnale esiste SOLO fuori dall'ottimizzazione:
   //    con piu' passate che condividono lo stesso file ogni passata
   //    sovrascriverebbe la precedente (trappola gia' scritta nel
   //    referto FVGRET).
   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION))
     {
      string f = StringFormat("ABTG_SondaM0PB_%s_%s_segnali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
      gCsvSeg = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
      if(gCsvSeg != INVALID_HANDLE)
         FileWrite(gCsvSeg, "ora_barra_segnale", "lato", "rsi_segnale", "prezzo_ingresso",
                   "riferimento_target", "take_punti_indice", "atr_prezzo", "stop_punti_indice",
                   "rr_segnale", "barre_da_estremo");
      else
         Log("ATTENZIONE: CSV dei segnali non aperto: il conteggio restera' solo nelle colonne, non ricontabile a mano.");
     }
   else if(InpScriviCsv)
      Log("CSV riga-per-segnale NON scritto: siamo in OTTIMIZZAZIONE e le passate si sovrascriverebbero. I numeri escono nelle colonne di OPTFRAME.");

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hRsiMt5 != INVALID_HANDLE) IndicatorRelease(hRsiMt5);
   if(hAtrMt5 != INVALID_HANDLE) IndicatorRelease(hAtrMt5);
   if(gCsvSeg != INVALID_HANDLE){ FileClose(gCsvSeg); gCsvSeg = INVALID_HANDLE; }
  }

//+------------------------------------------------------------------+
//| Un solo gesto per tick: se e' nata una barra nuova, si valuta la  |
//| barra CHIUSA che l'ha preceduta. Non c'e' nient'altro da fare:    |
//| non ci sono posizioni da gestire (T5).                            |
//+------------------------------------------------------------------+
void OnTick()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t == gLastBar || t == 0) return;
   gLastBar = t;
   ValutaBarraChiusa();
  }

//+------------------------------------------------------------------+
//| Chiude la contabilita' della giornata appena finita. E' l'unico   |
//| posto in cui crescono i contatori "giorni con >= N segnali" e i   |
//| massimi giornalieri: un solo punto da leggere.                    |
//+------------------------------------------------------------------+
void ChiudiGiornata()
  {
   if(gDayStamp == -1) return;
   long tot = (long)gDaySigLong + (long)gDaySigShort;
   if(gDaySigLong  >= 1) gG1Long++;
   if(gDaySigLong  >= 2) gG2Long++;
   if(gDaySigShort >= 1) gG1Short++;
   if(gDaySigShort >= 2) gG2Short++;
   if(tot >= 1) gG1Tot++;
   if(tot >= 2) gG2Tot++;
   if(tot == 0) gGiorniZero++;
   if((long)gDaySigLong  > gMaxGiornoLong)  gMaxGiornoLong  = gDaySigLong;
   if((long)gDaySigShort > gMaxGiornoShort) gMaxGiornoShort = gDaySigShort;
   if(tot > gMaxGiornoTot) gMaxGiornoTot = tot;
  }

//+------------------------------------------------------------------+
//| IL CUORE. Legge la coda di barre, ricalcola gli indicatori con le |
//| funzioni pure e decide se sulla barra chiusa c'era un segnale.    |
//| Non apre niente e non chiude niente: conta e misura distanze.     |
//+------------------------------------------------------------------+
void ValutaBarraChiusa()
  {
   int n = InpWarmupBarre;
   double high[], low[], close[];
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);

   //--- shift 1 = ultima barra CHIUSA. Si copiano n barre che
   //    FINISCONO li': l'indice n-1 e' la barra di segnale.
   if(CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)  != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)   != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close) != n)
     { gBarreSaltateDati++; return; }

   double rsi[], emaHigh[], emaLow[], tr[], atr[];
   if(!RsiWilderSerie_Calc(close, n, InpRsiPeriod, rsi))      { gBarreSaltateDati++; return; }
   if(!EmaSerie_Calc(high, n, InpEmaPeriod, emaHigh))         { gBarreSaltateDati++; return; }
   if(!EmaSerie_Calc(low,  n, InpEmaPeriod, emaLow))          { gBarreSaltateDati++; return; }
   if(!TrSerie_Calc(high, low, close, n, tr))                 { gBarreSaltateDati++; return; }
   if(!AtrSerie_Calc(tr, n, InpAtrPeriod, InpAtrModoPine, atr)){ gBarreSaltateDati++; return; }

   int iSeg = n - 1;      // la barra di segnale
   int iPre = n - 2;      // la barra prima (il "[1]" del Pine)
   if(iPre < 0){ gBarreSaltateDati++; return; }

   double rsiSeg = rsi[iSeg];
   double atrSeg = atr[iSeg];
   if(rsiSeg < 0.0 || atrSeg <= 0.0){ gBarreSaltateDati++; return; }

   //--- COLLAUDO T1/T3: si confronta con gli indicatori di MT5. Non
   //    decide niente, ma se diverge la traduzione e' sbagliata.
   if(InpConfrontaMT5) AggiornaDivergenze(rsiSeg, atrSeg);

   //--- l'ora della barra di SEGNALE, in ORA SERVER (T9).
   datetime tSeg = iTime(_Symbol, PERIOD_CURRENT, 1);
   MqlDateTime ts; TimeToStruct(tSeg, ts);

   //--- barssince: quante barre fa e' caduto l'estremo, dentro la
   //    finestra ammessa. -1 = mai (in Pine e' na, e na < 6 e' falso).
   int barreDaLong  = -1, barreDaShort = -1;
   for(int k = 0; k < InpFinestraBarre; k++)
     {
      int j = iSeg - k;
      if(j < 0) break;
      if(rsi[j] < 0.0) continue;
      if(barreDaLong  < 0 && rsi[j] >= InpRsiHigh) barreDaLong  = k;
      if(barreDaShort < 0 && rsi[j] <= InpRsiLow)  barreDaShort = k;
     }

   //--- i due grilletti, indipendenti (T6).
   bool sigLong  = FinestraArmata_Calc(barreDaLong,  InpFinestraBarre) &&
                   TriggerLong_Calc(low[iPre],  emaLow[iPre],  low[iSeg],  emaLow[iSeg]);
   bool sigShort = FinestraArmata_Calc(barreDaShort, InpFinestraBarre) &&
                   TriggerShort_Calc(high[iPre], emaHigh[iPre], high[iSeg], emaHigh[iSeg]);

   //--- FILTRO ORARIO. I segnali caduti fuori NON spariscono: si
   //    contano in colonna, e la barra non entra nel denominatore
   //    dei giorni (T9).
   if(!FinestraOraria_Calc(ts.hour, InpOraInizioServer, InpOraFineServer, InpUsaFinestraOraria))
     {
      if(sigLong)  gScartatiOrario++;
      if(sigShort) gScartatiOrario++;
      return;
     }

   gBarreValutate++;

   //--- L'ARMAMENTO sulla barra stessa, contato a parte: dice se il
   //    collo di bottiglia e' l'ESTREMO o il RIENTRO. Si conta QUI,
   //    cioe' DOPO il filtro orario e non prima, apposta: se lo si
   //    contasse su tutte le 24 ore mentre i segnali si contano solo
   //    dentro la finestra, il rapporto "armamenti su segnali" -- che
   //    e' l'unica cosa per cui questo numero esiste -- direbbe una
   //    bugia. Con la finestra spenta i due conteggi coincidono.
   if(rsiSeg >= InpRsiHigh) gEstremiLong++;
   if(rsiSeg <= InpRsiLow)  gEstremiShort++;

   //--- contabilita' della giornata (T9)
   int stamp = ts.year*1000 + ts.day_of_year;
   if(stamp != gDayStamp)
     {
      ChiudiGiornata();
      gDayStamp    = stamp;
      gDaySigLong  = 0;
      gDaySigShort = 0;
      gGiorniContati++;
     }

   if(!sigLong && !sigShort) return;

   //--- IL PREZZO D'INGRESSO (T4). Con il modo 1 e' l'apertura della
   //    barra appena nata, che e' esattamente dove il Pine riempie.
   double ingresso = (InpModoPrezzoIngresso == 1)
                     ? iOpen(_Symbol, PERIOD_CURRENT, 0)
                     : close[iSeg];
   if(ingresso <= 0.0){ gBarreSaltateDati++; return; }

   //--- lo stop e' lo stesso per i due lati: e' una DISTANZA.
   double stopPrezzo = InpStopAtrMult*atrSeg;
   double stopPts    = PuntiIndice_Calc(stopPrezzo, gPuntoIndice);
   Aggiungi(gAtrPts, gNAtr, PuntiIndice_Calc(atrSeg, gPuntoIndice));

   if(sigLong)
     {
      gSegnaliLong++;
      gDaySigLong++;
      double rif     = Massimo_Calc(high, n, iSeg, InpBarreTarget);   // ta.highest(12) al segnale (T2)
      double takePts = PuntiIndice_Calc(rif - ingresso, gPuntoIndice);
      double rr      = 0.0;
      if(takePts > 0.0)
        {
         Aggiungi(gTakeL, gNTakeL, takePts);
         Aggiungi(gStopL, gNStopL, stopPts);
         gSommaTakeL += takePts;
         if(stopPts > 0.0){ rr = takePts/stopPts; Aggiungi(gRrL, gNRrL, rr); }
        }
      else gTakeNegLong++;
      ScriviSegnale(tSeg, "LONG", rsiSeg, ingresso, rif, takePts, atrSeg, stopPts, rr, barreDaLong);
     }

   if(sigShort)
     {
      gSegnaliShort++;
      gDaySigShort++;
      double rif     = Minimo_Calc(low, n, iSeg, InpBarreTarget);     // ta.lowest(12) al segnale (T2)
      double takePts = PuntiIndice_Calc(ingresso - rif, gPuntoIndice);
      double rr      = 0.0;
      if(takePts > 0.0)
        {
         Aggiungi(gTakeS, gNTakeS, takePts);
         Aggiungi(gStopS, gNStopS, stopPts);
         gSommaTakeS += takePts;
         if(stopPts > 0.0){ rr = takePts/stopPts; Aggiungi(gRrS, gNRrS, rr); }
        }
      else gTakeNegShort++;
      ScriviSegnale(tSeg, "SHORT", rsiSeg, ingresso, rif, takePts, atrSeg, stopPts, rr, barreDaShort);
     }
  }

//+------------------------------------------------------------------+
//| Il confronto con gli indicatori di serie di MQL5 (T1 e T3).       |
//| RSI: atteso ~0 (le due formule sono la stessa).                   |
//| ATR: atteso NON zero con InpAtrModoPine = true (Wilder contro     |
//|      SMA), atteso ~0 con InpAtrModoPine = false.                  |
//+------------------------------------------------------------------+
void AggiornaDivergenze(const double rsiMio, const double atrMio)
  {
   double b[1];
   if(hRsiMt5 != INVALID_HANDLE && CopyBuffer(hRsiMt5, 0, 1, 1, b) == 1)
     {
      double d = MathAbs(b[0] - rsiMio);
      if(d > gRsiDivMax) gRsiDivMax = d;
     }
   if(hAtrMt5 != INVALID_HANDLE && CopyBuffer(hAtrMt5, 0, 1, 1, b) == 1)
     {
      if(b[0] > 0.0)
        {
         gAtrDivRelSom += 100.0*MathAbs(b[0] - atrMio)/b[0];
         gAtrDivN++;
        }
     }
  }

//+------------------------------------------------------------------+
//| Una riga per segnale, cosi' i cinque numeri si possono RICONTARE  |
//| A MANO da un foglio (e' la regola della SondaMediazione).         |
//+------------------------------------------------------------------+
void ScriviSegnale(const datetime t, const string lato, const double rsiv,
                   const double ingresso, const double rif, const double takePts,
                   const double atrv, const double stopPts, const double rr, const int barreDa)
  {
   if(gCsvSeg == INVALID_HANDLE) return;
   int dgt = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   FileWrite(gCsvSeg,
             TimeToString(t, TIME_DATE|TIME_MINUTES), lato,
             DoubleToString(rsiv, 2),
             DoubleToString(ingresso, dgt),
             DoubleToString(rif, dgt),
             DoubleToString(takePts, 3),
             DoubleToString(atrv, dgt),
             DoubleToString(stopPts, 3),
             DoubleToString(rr, 4),
             IntegerToString(barreDa));
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit. NON stampa un verdetto che nessuno legge: il
//  numero di blocchi falliti finisce nella colonna "Autotest
//  Falliti" del CSV di ottimizzazione (CHECKLIST punto 99), insieme
//  al numero di blocchi eseguiti.
//  REGOLA DI SCRITTURA (CHECKLIST punto 98): ogni blocco usa nomi di
//  variabile con il PROPRIO PREFISSO (a1_, a2_, ...). In MQL5 due
//  dichiarazioni dello stesso nome nello stesso scope sono un errore
//  secco di compilazione, e nessuna rilettura lo vede.
//==================================================================
void AutoTestM0PB()
  {
   int falliti = 0;
   int blocchi = 0;

   //--- BLOCCO 1: RSI di Wilder, due casi calcolati A MANO.
   //    periodo 2 su [10,11,12,11]: delta +1,+1,-1.
   //      seme  -> guadagni 1,0  perdite 0,0 -> perdite nulle -> 100
   //      passo -> guadagni 0,5  perdite 0,5 -> rs 1 -> 50
   //    periodo 3 su [10,11,10,11,12]: delta +1,-1,+1,+1.
   //      seme  -> 2/3 e 1/3 -> rs 2   -> 66,6667
   //      passo -> 7/9 e 2/9 -> rs 3,5 -> 77,7778
   blocchi++;
   double a1_c1[]; ArrayResize(a1_c1, 4);
   a1_c1[0]=10.0; a1_c1[1]=11.0; a1_c1[2]=12.0; a1_c1[3]=11.0;
   double a1_r1[];
   bool   a1_ok1 = RsiWilderSerie_Calc(a1_c1, 4, 2, a1_r1);
   double a1_c2[]; ArrayResize(a1_c2, 5);
   a1_c2[0]=10.0; a1_c2[1]=11.0; a1_c2[2]=10.0; a1_c2[3]=11.0; a1_c2[4]=12.0;
   double a1_r2[];
   bool   a1_ok2 = RsiWilderSerie_Calc(a1_c2, 5, 3, a1_r2);
   bool   a1_ko  = RsiWilderSerie_Calc(a1_c1, 2, 6, a1_r1);   // serie piu' corta del periodo -> falso
   if(!a1_ok1 || !a1_ok2 || a1_ko ||
      MathAbs(a1_r1[2] - 100.0)     > 0.0001 ||
      MathAbs(a1_r1[3] -  50.0)     > 0.0001 ||
      MathAbs(a1_r2[3] -  66.66667) > 0.001  ||
      MathAbs(a1_r2[4] -  77.77778) > 0.001  ||
      a1_r2[2] > -0.5)                                   // prima del seme deve valere -1
     { falliti++; Log("[AUTOTEST] 1 RsiWilderSerie_Calc DIVERGE"); }

   //--- BLOCCO 2: il caso degenere dell'RSI, dichiarato in T1.
   blocchi++;
   double a2_su = RsiDaMedie_Calc(1.0, 0.0);    // solo guadagni -> 100
   double a2_pi = RsiDaMedie_Calc(0.0, 0.0);    // mercato piatto -> 50
   double a2_eq = RsiDaMedie_Calc(1.0, 1.0);    // rs = 1 -> 50
   double a2_gi = RsiDaMedie_Calc(0.0, 1.0);    // solo perdite -> 0
   if(MathAbs(a2_su-100.0)>0.0001 || MathAbs(a2_pi-50.0)>0.0001 ||
      MathAbs(a2_eq- 50.0)>0.0001 || MathAbs(a2_gi- 0.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 2 RsiDaMedie_Calc (casi degeneri) DIVERGE"); }

   //--- BLOCCO 3: EMA alla Pine. periodo 3 su [1,2,3,4,5]:
   //    seme = SMA(1,2,3) = 2, alfa 0,5 -> 3 -> 4.
   //    periodo 1: l'EMA e' la serie stessa.
   blocchi++;
   double a3_s[]; ArrayResize(a3_s, 5);
   a3_s[0]=1.0; a3_s[1]=2.0; a3_s[2]=3.0; a3_s[3]=4.0; a3_s[4]=5.0;
   double a3_e[];
   bool   a3_ok = EmaSerie_Calc(a3_s, 5, 3, a3_e);
   double a3_u[];
   bool   a3_ok1 = EmaSerie_Calc(a3_s, 5, 1, a3_u);
   if(!a3_ok || !a3_ok1 ||
      MathAbs(a3_e[2]-2.0)>0.0001 || MathAbs(a3_e[3]-3.0)>0.0001 || MathAbs(a3_e[4]-4.0)>0.0001 ||
      MathAbs(a3_u[4]-5.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 3 EmaSerie_Calc DIVERGE"); }

   //--- BLOCCO 4: TRUE RANGE, compresa la prima barra (high-low).
   //    h=[10,11,12] l=[9,10,11] c=[9.5,10.5,11.5]
   //    TR = [1 ; max(1; 1,5; 0,5)=1,5 ; max(1; 1,5; 0,5)=1,5]
   blocchi++;
   double a4_h[]; ArrayResize(a4_h,3); a4_h[0]=10.0; a4_h[1]=11.0; a4_h[2]=12.0;
   double a4_l[]; ArrayResize(a4_l,3); a4_l[0]= 9.0; a4_l[1]=10.0; a4_l[2]=11.0;
   double a4_c[]; ArrayResize(a4_c,3); a4_c[0]= 9.5; a4_c[1]=10.5; a4_c[2]=11.5;
   double a4_tr[];
   bool   a4_ok = TrSerie_Calc(a4_h, a4_l, a4_c, 3, a4_tr);
   if(!a4_ok || MathAbs(a4_tr[0]-1.0)>0.0001 ||
                MathAbs(a4_tr[1]-1.5)>0.0001 || MathAbs(a4_tr[2]-1.5)>0.0001)
     { falliti++; Log("[AUTOTEST] 4 TrSerie_Calc DIVERGE"); }

   //--- BLOCCO 5: LA DIFFERENZA T3 IN NUMERI. Sullo stesso TR
   //    [1; 1,5; 1,5] con periodo 2:
   //      Wilder/RMA (Pine) -> seme 1,25 ; poi 1,25+0,5*(1,5-1,25) = 1,375
   //      SMA (modo MT5)    -> (1,5+1,5)/2 = 1,5
   //    Il blocco fallisce anche se i due VENISSERO UGUALI: se
   //    coincidessero, T3 sarebbe una bugia scritta in testa al file.
   blocchi++;
   double a5_rma[], a5_sma[];
   bool   a5_o1 = AtrSerie_Calc(a4_tr, 3, 2, true,  a5_rma);
   bool   a5_o2 = AtrSerie_Calc(a4_tr, 3, 2, false, a5_sma);
   if(!a5_o1 || !a5_o2 ||
      MathAbs(a5_rma[1]-1.25 )>0.0001 || MathAbs(a5_rma[2]-1.375)>0.0001 ||
      MathAbs(a5_sma[1]-1.25 )>0.0001 || MathAbs(a5_sma[2]-1.5  )>0.0001 ||
      MathAbs(a5_rma[2]-a5_sma[2]) < 0.0001)
     { falliti++; Log("[AUTOTEST] 5 AtrSerie_Calc DIVERGE (o le due modalita' coincidono, e allora T3 e' sbagliata)"); }

   //--- BLOCCO 6: massimo e minimo mobili, compreso il caso in cui la
   //    finestra sborda all'indietro (si tosa, non si legge fuori).
   blocchi++;
   double a6_v[]; ArrayResize(a6_v, 6);
   a6_v[0]=5.0; a6_v[1]=9.0; a6_v[2]=3.0; a6_v[3]=7.0; a6_v[4]=1.0; a6_v[5]=4.0;
   double a6_max3 = Massimo_Calc(a6_v, 6, 5, 3);   // {7;1;4} -> 7
   double a6_min3 = Minimo_Calc (a6_v, 6, 5, 3);   // {7;1;4} -> 1
   double a6_max6 = Massimo_Calc(a6_v, 6, 5, 6);   // tutto   -> 9
   double a6_sbor = Massimo_Calc(a6_v, 6, 1, 5);   // {5;9}   -> 9
   double a6_ko   = Massimo_Calc(a6_v, 6, 9, 3);   // fine fuori range -> 0
   if(MathAbs(a6_max3-7.0)>0.0001 || MathAbs(a6_min3-1.0)>0.0001 ||
      MathAbs(a6_max6-9.0)>0.0001 || MathAbs(a6_sbor-9.0)>0.0001 ||
      MathAbs(a6_ko)      >0.0001)
     { falliti++; Log("[AUTOTEST] 6 Massimo_Calc/Minimo_Calc DIVERGONO"); }

   //--- BLOCCO 7: il grilletto LONG (Pine riga 55), bordi compresi.
   blocchi++;
   bool a7_si  = TriggerLong_Calc(10.0,  9.0,  8.0,  8.5);   // era sopra, ora tocca -> si
   bool a7_no1 = TriggerLong_Calc(10.0, 11.0,  8.0,  8.5);   // era gia' SOTTO       -> no
   bool a7_no2 = TriggerLong_Calc(10.0,  9.0,  9.0,  8.5);   // non tocca            -> no
   bool a7_bo1 = TriggerLong_Calc(10.0,  9.0,  8.5,  8.5);   // tocco esatto (<=)    -> si
   bool a7_bo2 = TriggerLong_Calc( 9.0,  9.0,  8.0,  8.5);   // prima UGUALE (>)     -> no
   if(!(a7_si && !a7_no1 && !a7_no2 && a7_bo1 && !a7_bo2))
     { falliti++; Log("[AUTOTEST] 7 TriggerLong_Calc DIVERGE"); }

   //--- BLOCCO 8: il grilletto SHORT (Pine riga 62), specchio esatto.
   blocchi++;
   bool a8_si  = TriggerShort_Calc( 8.0,  9.0, 10.0,  9.5);
   bool a8_no1 = TriggerShort_Calc(10.0,  9.0, 10.0,  9.5);
   bool a8_no2 = TriggerShort_Calc( 8.0,  9.0,  9.0,  9.5);
   bool a8_bo1 = TriggerShort_Calc( 8.0,  9.0,  9.5,  9.5);
   bool a8_bo2 = TriggerShort_Calc( 9.0,  9.0, 10.0,  9.5);
   if(!(a8_si && !a8_no1 && !a8_no2 && a8_bo1 && !a8_bo2))
     { falliti++; Log("[AUTOTEST] 8 TriggerShort_Calc DIVERGE"); }

   //--- BLOCCO 9: la finestra dell'armamento (barssince < 6).
   blocchi++;
   bool a9_0  = FinestraArmata_Calc(0, 6);    // stessa barra -> ammesso
   bool a9_5  = FinestraArmata_Calc(5, 6);    // ultimo ammesso
   bool a9_6  = FinestraArmata_Calc(6, 6);    // scaduto
   bool a9_ma = FinestraArmata_Calc(-1, 6);   // mai successo (na) -> falso
   if(!(a9_0 && a9_5 && !a9_6 && !a9_ma))
     { falliti++; Log("[AUTOTEST] 9 FinestraArmata_Calc DIVERGE"); }

   //--- BLOCCO 10: mediana, punti indice, RR da mediane.
   blocchi++;
   double a10_d[]; ArrayResize(a10_d, 5);
   a10_d[0]=1.0; a10_d[1]=2.0; a10_d[2]=3.0; a10_d[3]=10.0; a10_d[4]=100.0;
   double a10_m  = MedianaOrdinata_Calc(a10_d, 5);   // 3
   double a10_p[]; ArrayResize(a10_p, 4);
   a10_p[0]=1.0; a10_p[1]=2.0; a10_p[2]=4.0; a10_p[3]=8.0;
   double a10_mp = MedianaOrdinata_Calc(a10_p, 4);   // (2+4)/2 = 3
   double a10_vu = MedianaOrdinata_Calc(a10_d, 0);   // niente dati -> 0
   double a10_pi = PuntiIndice_Calc(12.5, 1.0);      // punto indice = 1,00 -> 12,5
   double a10_p2 = PuntiIndice_Calc(12.5, 0.5);      // 25
   double a10_pz = PuntiIndice_Calc(12.5, 0.0);      // non convertibile -> 0
   double a10_rr = RrDaMediane_Calc(6.0, 8.0);       // 0,75
   double a10_rz = RrDaMediane_Calc(6.0, 0.0);       // stop nullo -> 0
   if(MathAbs(a10_m-3.0)>0.0001 || MathAbs(a10_mp-3.0)>0.0001 || MathAbs(a10_vu)>0.0001 ||
      MathAbs(a10_pi-12.5)>0.0001 || MathAbs(a10_p2-25.0)>0.0001 || MathAbs(a10_pz)>0.0001 ||
      MathAbs(a10_rr-0.75)>0.0001 || MathAbs(a10_rz)>0.0001)
     { falliti++; Log("[AUTOTEST] 10 mediana / punti indice / RR DIVERGONO"); }

   //--- BLOCCO 11: L'ARITMETICA DEL CANCELLO H8 CONTRO LA TABELLA
   //    CONGELATA NEL DOSSIER (par. 5-bis). Non e' un test di
   //    comodo: se questa formula si muove, si muove il cancello.
   blocchi++;
   double a11_a = WinRateNecessario_Calc(0.36, M0PB_E_TARGET_R);   // 0,790
   double a11_b = WinRateNecessario_Calc(0.50, M0PB_E_TARGET_R);   // 0,717
   double a11_c = WinRateNecessario_Calc(0.73, M0PB_E_TARGET_R);   // 0,622
   double a11_d = WinRateNecessario_Calc(1.00, M0PB_E_TARGET_R);   // 0,538
   if(MathAbs(a11_a-0.790)>0.001 || MathAbs(a11_b-0.717)>0.001 ||
      MathAbs(a11_c-0.622)>0.001 || MathAbs(a11_d-0.538)>0.001)
     { falliti++; Log("[AUTOTEST] 11 WinRateNecessario_Calc NON riproduce la tabella congelata del dossier"); }

   //--- BLOCCO 12: la finestra oraria, compreso il caso a cavallo
   //    della mezzanotte e il caso "filtro spento".
   blocchi++;
   bool a12_off = FinestraOraria_Calc( 3, 14, 21, false);   // spento -> sempre vero
   bool a12_in  = FinestraOraria_Calc(14, 14, 21, true);    // bordo iniziale incluso
   bool a12_fi  = FinestraOraria_Calc(21, 14, 21, true);    // bordo finale incluso
   bool a12_ou  = FinestraOraria_Calc(22, 14, 21, true);    // fuori
   bool a12_w1  = FinestraOraria_Calc(23, 22,  2, true);    // a cavallo: dentro
   bool a12_w2  = FinestraOraria_Calc( 2, 22,  2, true);    // a cavallo: bordo
   bool a12_w3  = FinestraOraria_Calc(10, 22,  2, true);    // a cavallo: fuori
   bool a12_ko  = FinestraOraria_Calc(24, 14, 21, true);    // ora impossibile
   if(!(a12_off && a12_in && a12_fi && !a12_ou && a12_w1 && a12_w2 && !a12_w3 && !a12_ko))
     { falliti++; Log("[AUTOTEST] 12 FinestraOraria_Calc DIVERGE"); }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   Log(StringFormat("AUTOTEST: %d BLOCCHI SU %d PASSATI (falliti %d). L'esito VERO esce nelle colonne 'Autotest Falliti' e 'Autotest Blocchi': in ottimizzazione questa riga non la legge nessuno.",
                    blocchi - falliti, blocchi, falliti));
  }

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV. NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv.                 //
//  In backtest singolo e' inerte (FrameAdd gira in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| Il referto a schermo del BACKTEST SINGOLO, con i cancelli GIA'    |
//| applicati. Le stesse cose escono in colonna: qui si stampano      |
//| perche' nella corsa singola le Print SI LEGGONO, ed e' li' che    |
//| Claudio guarda il numero la prima volta.                          |
//+------------------------------------------------------------------+
void StampaLato(const string lato, const double sigGiorno, const double takeMed,
                const double stopMed, const double rr, const long segnali,
                const long maxGiorno, const long g1, const long g2, const long takeNeg)
  {
   Print("--------------------------------------------------------------");
   PrintFormat("[M0PB-SONDA] ===== LATO %s =====", lato);
   PrintFormat("   1. segnali/giorno      : %.3f   (segnali %d)   %s",
               sigGiorno, (int)segnali,
               (sigGiorno < M0PB_SOGLIA_SEGNALI_GIORNO ? "<<< F1 NON PASSATO: MORTO" : "F1 passato"));
   PrintFormat("   2. take MEDIANO        : %.2f punti indice   %s",
               takeMed,
               (takeMed < M0PB_SOGLIA_TAKE_PUNTI ? "<<< F2 NON PASSATO: MORTO" : "F2 passato"));
   PrintFormat("   3. stop MEDIANO        : %.2f punti indice   (%.2f x ATR)", stopMed, InpStopAtrMult);
   PrintFormat("   4. RR MEDIANO (2/3)    : %.3f   %s",
               rr,
               (rr < M0PB_SOGLIA_RR ? "<<< H8 NON PASSATO: MORTO PER ARITMETICA" : "H8 passato"));
   PrintFormat("      win rate NECESSARIO per E >= %.3fR : %.1f%%",
               M0PB_E_TARGET_R, 100.0*WinRateNecessario_Calc(rr, M0PB_E_TARGET_R));
   PrintFormat("   5. MASSIMO in un giorno: %d   (muro giornaliero: e' da qui che si taglia InpMaxTradesPerDay)",
               (int)maxGiorno);
   PrintFormat("      giorni con >= 1      : %d      giorni con >= 2 : %d   (pavimento di Claudio: 1-2 al giorno)",
               (int)g1, (int)g2);
   PrintFormat("      take non positivi    : %d   (segnali senza spazio davanti, fuori dalla mediana ma CONTATI)",
               (int)takeNeg);
  }

double OnTester()
  {
   //--- l'ultima giornata va chiusa a mano: nessuna barra nuova la
   //    chiudera' piu'.
   ChiudiGiornata();
   gDayStamp = -1;

   double takeMedL = Mediana(gTakeL, gNTakeL);
   double takeMedS = Mediana(gTakeS, gNTakeS);
   double stopMedL = Mediana(gStopL, gNStopL);
   double stopMedS = Mediana(gStopS, gNStopS);
   double rrMedL   = RrDaMediane_Calc(takeMedL, stopMedL);
   double rrMedS   = RrDaMediane_Calc(takeMedS, stopMedS);
   double rrSegL   = Mediana(gRrL, gNRrL);
   double rrSegS   = Mediana(gRrS, gNRrS);
   double atrMed   = Mediana(gAtrPts, gNAtr);

   double gg      = (gGiorniContati > 0) ? (double)gGiorniContati : 0.0;
   double sigGgL  = (gg > 0.0) ? (double)gSegnaliLong /gg : 0.0;
   double sigGgS  = (gg > 0.0) ? (double)gSegnaliShort/gg : 0.0;
   double sigGgT  = (gg > 0.0) ? (double)(gSegnaliLong + gSegnaliShort)/gg : 0.0;
   double takeAvgL= (gNTakeL > 0) ? gSommaTakeL/(double)gNTakeL : 0.0;
   double takeAvgS= (gNTakeS > 0) ? gSommaTakeS/(double)gNTakeS : 0.0;
   double atrDiv  = (gAtrDivN > 0) ? gAtrDivRelSom/(double)gAtrDivN : 0.0;

   //--- REFERTO A SCHERMO (corsa singola). In ottimizzazione non lo
   //    legge nessuno: per quello ci sono le colonne qui sotto.
   Print("==============================================================");
   PrintFormat("[M0PB-SONDA] CONTATORE M0PB su %s %s - etichetta '%s'. NESSUN ORDINE APERTO.",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpTag);
   PrintFormat("   barre valutate %d | barre saltate per dati %d | giorni contati %d | segnali fuori orario %d",
               (int)gBarreValutate, (int)gBarreSaltateDati, (int)gGiorniContati, (int)gScartatiOrario);
   PrintFormat("   armamenti RSI: LONG %d  SHORT %d  (se gli armamenti sono tanti e i segnali pochi, il collo di bottiglia e' il RIENTRO, non l'estremo)",
               (int)gEstremiLong, (int)gEstremiShort);
   PrintFormat("   ATR mediano %.4f punti indice -> l'RR di QUALUNQUE moltiplicatore si ricalcola a mano: RR(mult) = RR(%.2f) * %.2f / mult",
               atrMed, InpStopAtrMult, InpStopAtrMult);
   PrintFormat("   collaudo traduzione: scarto MAX contro iRSI = %.8f (atteso ~0, vedi T1) | scarto medio contro iATR = %.4f%% (atteso NON zero con ATR alla Pine, ~0 con InpAtrModoPine=false, vedi T3)",
               gRsiDivMax, atrDiv);
   if(gTroncato)
      Print("   >>> ATTENZIONE: raggiunto il tetto dei campioni: LE MEDIANE SONO TRONCATE e non valgono. Rifare con una finestra piu' corta.");

   StampaLato("LONG",  sigGgL, takeMedL, stopMedL, rrMedL, gSegnaliLong,
              gMaxGiornoLong, gG1Long, gG2Long, gTakeNegLong);
   StampaLato("SHORT", sigGgS, takeMedS, stopMedS, rrMedS, gSegnaliShort,
              gMaxGiornoShort, gG1Short, gG2Short, gTakeNegShort);

   Print("--------------------------------------------------------------");
   PrintFormat("[M0PB-SONDA] i DUE LATI insieme (solo per il muro giornaliero, MAI per il merito): %.3f segnali/giorno, massimo %d in un giorno, giorni con >=1 %d, con >=2 %d, giorni a zero %d",
               sigGgT, (int)gMaxGiornoTot, (int)gG1Tot, (int)gG2Tot, (int)gGiorniZero);
   Print("[M0PB-SONDA] questa corsa NON promuove niente e NON dice se il motore guadagna: e' un conteggio. Il merito si misura a tick, dopo, e solo se questi numeri reggono.");
   Print("==============================================================");

   //--- ATTENZIONE: 'stats', l'header di OnTesterDeinit e il suo
   //    StringFormat SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta a
   //    uno solo dei tre sfasa tutto il CSV e chi legge trova il numero
   //    sbagliato sotto il nome giusto.
   //    CONTEGGIO CONGELATO: 45 valori -> 48 nomi (Pass, Simbolo,
   //    Periodo + 45) -> 48 specificatori -> 48 argomenti.
   double stats[45];
   stats[0]  = (double)gSegnaliLong;
   stats[1]  = (double)gSegnaliShort;
   stats[2]  = (double)gGiorniContati;
   stats[3]  = sigGgL;                 // NUMERO 1 del dossier, LONG  (cancello F1)
   stats[4]  = sigGgS;                 // NUMERO 1 del dossier, SHORT (cancello F1)
   stats[5]  = sigGgT;
   stats[6]  = takeMedL;               // NUMERO 2, LONG  (cancello F2)
   stats[7]  = takeMedS;               // NUMERO 2, SHORT (cancello F2)
   stats[8]  = stopMedL;               // NUMERO 3, LONG
   stats[9]  = stopMedS;               // NUMERO 3, SHORT
   stats[10] = rrMedL;                 // NUMERO 4, LONG  (cancello H8) = 2/3
   stats[11] = rrMedS;                 // NUMERO 4, SHORT (cancello H8) = 2/3
   stats[12] = rrSegL;                 // mediana dei rapporti per segnale: NON e' il cancello
   stats[13] = rrSegS;
   stats[14] = 100.0*WinRateNecessario_Calc(rrMedL, M0PB_E_TARGET_R);
   stats[15] = 100.0*WinRateNecessario_Calc(rrMedS, M0PB_E_TARGET_R);
   stats[16] = (double)gMaxGiornoLong;  // NUMERO 5, LONG
   stats[17] = (double)gMaxGiornoShort; // NUMERO 5, SHORT
   stats[18] = (double)gMaxGiornoTot;
   stats[19] = (double)gG1Long;
   stats[20] = (double)gG2Long;
   stats[21] = (double)gG1Short;
   stats[22] = (double)gG2Short;
   stats[23] = (double)gG1Tot;
   stats[24] = (double)gG2Tot;
   stats[25] = (double)gGiorniZero;
   stats[26] = (double)gEstremiLong;
   stats[27] = (double)gEstremiShort;
   stats[28] = (double)gTakeNegLong;
   stats[29] = (double)gTakeNegShort;
   stats[30] = takeAvgL;
   stats[31] = takeAvgS;
   stats[32] = atrMed;                  // con questo l'RR di ogni mult si ricalcola (T10)
   stats[33] = (double)gBarreValutate;
   stats[34] = (double)gBarreSaltateDati;
   stats[35] = (double)gScartatiOrario;
   stats[36] = gRsiDivMax;              // collaudo T1: atteso ~0
   stats[37] = atrDiv;                  // collaudo T3
   stats[38] = gPuntoIndice;            // eco T8: deve valere 1,00 sui tre indici
   stats[39] = InpStopAtrMult;          // eco della manopola sweepata
   stats[40] = (InpAtrModoPine ? 1.0 : 0.0);
   stats[41] = (double)InpModoPrezzoIngresso;
   stats[42] = (InpUsaFinestraOraria ? 1.0 : 0.0);
   stats[43] = (double)gAutotestFalliti; // 0 = tutti passati; >0 DIVERGE; -1 non eseguito
   stats[44] = (double)gAutotestBlocchi;

   if(InpScriviCsv && !MQLInfoInteger(MQL_OPTIMIZATION)) ScriviCsvTotali(stats);

   //--- MT5 vuole un criterio di ottimizzazione. Qui NON si sceglie
   //    niente e NESSUNA CELLA VIENE PROMOSSA: si dichiara il numero
   //    di segnali totali, che e' cio' che la sonda conta. Leggerlo
   //    per sbaglio come "il migliore" vorrebbe dire "quello che ha
   //    contato di piu'", che non e' un merito: il numero di segnali
   //    NON dipende nemmeno da InpStopAtrMult, l'unico asse sweepato.
   double criterion = (double)(gSegnaliLong + gSegnaliShort);
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
  }

//+------------------------------------------------------------------+
//| CSV dei totali della corsa singola: gli stessi numeri delle       |
//| colonne, in un file, cosi' il referto non dipende dal log.        |
//+------------------------------------------------------------------+
void ScriviCsvTotali(const double &s[])
  {
   string f = StringFormat("ABTG_SondaM0PB_%s_%s_totali.csv", _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()));
   int h = FileOpen(f, FILE_WRITE|FILE_CSV|FILE_ANSI, ";");
   if(h == INVALID_HANDLE)
     { Log(StringFormat("CSV totali non scritto (err %d).", GetLastError())); return; }

   FileWrite(h, "numero", "grandezza", "LONG", "SHORT", "cancello");
   FileWrite(h, "1", "segnali al giorno", DoubleToString(s[3], 3), DoubleToString(s[4], 3),
             StringFormat("F1: >= %.2f", M0PB_SOGLIA_SEGNALI_GIORNO));
   FileWrite(h, "2", "take mediano punti indice", DoubleToString(s[6], 3), DoubleToString(s[7], 3),
             StringFormat("F2: >= %.1f", M0PB_SOGLIA_TAKE_PUNTI));
   FileWrite(h, "3", "stop mediano punti indice", DoubleToString(s[8], 3), DoubleToString(s[9], 3),
             StringFormat("nessun cancello (%.2f x ATR)", InpStopAtrMult));
   FileWrite(h, "4", "RR mediano = 2/3", DoubleToString(s[10], 4), DoubleToString(s[11], 4),
             StringFormat("H8: >= %.2f", M0PB_SOGLIA_RR));
   FileWrite(h, "5", "massimo segnali in un giorno", DoubleToString(s[16], 0), DoubleToString(s[17], 0),
             "muro giornaliero prop");
   FileWrite(h, "-", "segnali totali", DoubleToString(s[0], 0), DoubleToString(s[1], 0), "");
   FileWrite(h, "-", "giorni con almeno 1 segnale", DoubleToString(s[19], 0), DoubleToString(s[21], 0),
             "pavimento di Claudio: 1-2 al giorno");
   FileWrite(h, "-", "giorni con almeno 2 segnali", DoubleToString(s[20], 0), DoubleToString(s[22], 0), "");
   FileWrite(h, "-", "win rate necessario % per E >= 0,075R", DoubleToString(s[14], 2), DoubleToString(s[15], 2),
             "aritmetica H8, par. 5-bis del dossier");
   FileWrite(h, "-", "take medio punti indice", DoubleToString(s[30], 3), DoubleToString(s[31], 3),
             "accanto alla mediana dice l'asimmetria");
   FileWrite(h, "-", "take non positivi", DoubleToString(s[28], 0), DoubleToString(s[29], 0),
             "fuori dalla mediana ma contati (T2)");
   FileWrite(h, "-", "armamenti RSI", DoubleToString(s[26], 0), DoubleToString(s[27], 0), "");
   FileWrite(h, "-", "RR mediano per segnale", DoubleToString(s[12], 4), DoubleToString(s[13], 4),
             "NON e' il cancello: il cancello e' 2/3");
   FileWrite(h, "-", "giorni contati", DoubleToString(s[2], 0), "", "T9");
   FileWrite(h, "-", "giorni a zero segnali (due lati)", DoubleToString(s[25], 0), "", "");
   FileWrite(h, "-", "ATR mediano punti indice", DoubleToString(s[32], 4), "",
             "RR(mult) = RR corrente * mult corrente / mult nuovo (T10)");
   FileWrite(h, "-", "barre valutate", DoubleToString(s[33], 0), "", "");
   FileWrite(h, "-", "barre saltate per dati", DoubleToString(s[34], 0), "", "deve essere ~0");
   FileWrite(h, "-", "segnali scartati orario", DoubleToString(s[35], 0), "",
             "0 se InpUsaFinestraOraria = false");
   FileWrite(h, "-", "scarto max contro iRSI", DoubleToString(s[36], 8), "", "collaudo T1: atteso ~0");
   FileWrite(h, "-", "scarto medio % contro iATR", DoubleToString(s[37], 4), "", "collaudo T3");
   FileWrite(h, "-", "punto indice in prezzo", DoubleToString(s[38], 5), "", "T8: deve valere 1,00");
   FileWrite(h, "-", "autotest falliti su blocchi", DoubleToString(s[43], 0), DoubleToString(s[44], 0),
             "0 falliti = passato; -1 = NON eseguito");
   FileClose(h);
   Log(StringFormat("scritto MQL5\\Files\\%s", f));
  }

int OnTesterInit() { return(INIT_SUCCEEDED); }

void OnTesterDeinit()
  {
   string fname = OptFrame_FileName();
   int h = FileOpen(fname, FILE_WRITE|FILE_CSV|FILE_ANSI, ",");
   if(h == INVALID_HANDLE)
     { PrintFormat("OptFrame: impossibile creare %s (err %d)", fname, GetLastError()); return; }
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   string periodo = EnumToString((ENUM_TIMEFRAMES)Period());
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         //--- 48 nomi = Pass + Simbolo + Periodo + 45 valori di stats[].
         string head = "Pass,Simbolo,Periodo,Segnali Long,Segnali Short,Giorni Contati,Segnali Long Al Giorno,Segnali Short Al Giorno,Segnali Totali Al Giorno,Take Mediano Long Punti Indice,Take Mediano Short Punti Indice,Stop Mediano Long Punti Indice,Stop Mediano Short Punti Indice,RR Da Mediane Long,RR Da Mediane Short,RR Mediano Per Segnale Long,RR Mediano Per Segnale Short,Win Rate Necessario Long Pct,Win Rate Necessario Short Pct,Max Segnali Giorno Long,Max Segnali Giorno Short,Max Segnali Giorno Totale,Giorni Almeno 1 Long,Giorni Almeno 2 Long,Giorni Almeno 1 Short,Giorni Almeno 2 Short,Giorni Almeno 1 Totale,Giorni Almeno 2 Totale,Giorni Zero Segnali,Estremi Rsi Long,Estremi Rsi Short,Take Non Positivi Long,Take Non Positivi Short,Take Medio Long Punti Indice,Take Medio Short Punti Indice,Atr Mediano Punti Indice,Barre Valutate,Barre Saltate Dati,Segnali Scartati Orario,Rsi Divergenza Max,Atr Divergenza Rel Media Pct,Punto Indice Prezzo,Stop Atr Mult,Modo Atr Pine,Modo Prezzo Ingresso,Finestra Oraria Attiva,Autotest Falliti,Autotest Blocchi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 48 specificatori = 48 argomenti (pass, simbolo, periodo, data[0..44]).
      string row = StringFormat("%d,%s,%s,%.0f,%.0f,%.0f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f,%.4f,%.4f,%.4f,%.4f,%.2f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.3f,%.3f,%.4f,%.0f,%.0f,%.0f,%.8f,%.4f,%.5f,%.3f,%.0f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, _Symbol, periodo,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25], data[26], data[27], data[28], data[29],
                                data[30], data[31], data[32], data[33], data[34], data[35],
                                data[36], data[37], data[38], data[39], data[40], data[41],
                                data[42], data[43], data[44]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
