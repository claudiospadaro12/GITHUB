//+------------------------------------------------------------------+
//|                                              ABTG_LondonFx.mq5    |
//|                                                                  |
//|  IL CONTENITORE DEL ROUND R116 -- UN EA, TRE MOTORI A            |
//|  INTERRUTTORE. Canale di Londra nudo / canale + RSI / allineamento|
//|  di cinque medie, TUTTI DENTRO LO STESSO CONTENITORE.            |
//|                                                                  |
//|  ================================================================ |
//|  CRITERI FIRMATI -- QUESTO FILE NE E' L'ATTUAZIONE                |
//|  ================================================================ |
//|  backtest_pipeline\risultati_archivio\LONDONFX_TICK_CRITERI.md    |
//|  FIRMATO da Claudio il 03/09/2026 ~09:45 ("FIRMO TUTTO, ANCHE LA  |
//|  A SU F5"). Le dodici firme F1-F12 sono CONGELATE: questo file    |
//|  NON le reinterpreta e NON le allarga. Dove il documento lascia   |
//|  un dettaglio implementativo aperto, la scelta e' scritta qui     |
//|  sotto come NOTA NUMERATA (N1, N2, ...) e va letta PRIMA dei      |
//|  numeri, non dopo.                                                |
//|                                                                  |
//|  >>> NON COMPILATO E NON ESEGUITO da chi ha scritto il file: in   |
//|      quell'ambiente non esistono MetaEditor ne' Strategy Tester.  |
//|      Si compila in MetaEditor PRIMA di qualunque corsa, e la      |
//|      riga di lancio la costruisce il verificatore.                |
//|                                                                  |
//|  ================================================================ |
//|  ATTRIBUZIONE -- OBBLIGATORIA, E' UNA CONDIZIONE DI LICENZA       |
//|  ================================================================ |
//|  MOTORE 1 e MOTORE 2 (canale SMA5 high/low + conferma RSI):       |
//|     "EURUSD 5min london session strategy"                         |
//|     (c) SoftKill21, TradingView, 2020-08-30, Pine v4              |
//|     https://www.tradingview.com/script/E6yr9CoN-EURUSD-5min-london-session-strategy/
//|     MOZILLA PUBLIC LICENSE 2.0 (dichiarata alla riga 1 del Pine)  |
//|     Copia archiviata e letta riga per riga (52 righe):            |
//|       caccia_strategie\biblioteca\sorgenti\                       |
//|       EurUsd5minLondonSession_SoftKill21-MPL2_tvE6yr9CoN_2026-08-31.pine
//|     La MECCANICA DI SEGNALE arriva TALE E QUALE da               |
//|     mql5\Experts\ABTG_SondaLondonFx.mq5 (PASSO 0 del 31/08,       |
//|     autotest 16/16, gemelli identici, referto del 03/09): stesse  |
//|     funzioni pure, stessi #define, stessa decisione su BARRA      |
//|     CHIUSA. NON e' stata riscritta: e' stata RIUSATA.             |
//|                                                                  |
//|  MOTORE 3 (allineamento SMMA 3/6/9/50 + EMA200):                  |
//|     "Money maker EURUSD 15min daytrader"                          |
//|     (c) SoftKill21, TradingView, 2020-10-19, Pine v4              |
//|     https://www.tradingview.com/script/jU2JCWZr-Money-maker-EURUSD-15min-daytrader/
//|     MOZILLA PUBLIC LICENSE 2.0                                    |
//|     Il SEGNALE e' preso da mql5\Experts\ABTG_AllineaLondra.mq5    |
//|     (righe 356-373: AllineaLong_Calc / AllineaShort_Calc, scritte |
//|     il 28/08, verificate due volte, MAI GIRATE), copiato ALLA     |
//|     LETTERA. Di quell'EA NON viene preso NIENT'ALTRO: ne' la sua  |
//|     sessione (03:00-10:45), ne' il suo tetto di 2 ingressi, ne'   |
//|     il suo SL in ATR, ne' il suo TP in R, ne' il parziale, il     |
//|     breakeven e il trailing. E' la firma F3, opzione (i):         |
//|     IL MOTORE SI PORTA DENTRO, IL CONTENITORE E' QUESTO.          |
//|     >>> ABTG_AllineaLondra.mq5 RESTA INTATTO. Non e' stato        |
//|         toccato in questo giro: il suo PASSO 0 resta pinnato.     |
//|                                                                  |
//|  Questo file NON e' codice degli autori originali: e' una         |
//|  riscrittura. Il contenitore e le uscite sono NOSTRI.             |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  IL PRINCIPIO CHE E' TUTTO IL ROUND (criteri, par. 3.1)           |
//|  ------------------------------------------------------------    |
//|  IL CONTENITORE E' IDENTICO PER I TRE MOTORI. BIT PER BIT.        |
//|  Fra una cella e l'altra cambia UNA SOLA RIGA: InpMotore.         |
//|  Sessione, flat, tetto giornaliero, cap di perdita, rischio,      |
//|  geometria TP/SL, misura dello spread, slippage, canarino: tutto  |
//|  scritto UNA volta sola e attraversato da tutti e tre. Se il      |
//|  contenitore cambiasse fra un motore e l'altro, l'ablazione       |
//|  misurerebbe il contenitore e la domanda del round resterebbe     |
//|  senza risposta.                                                  |
//|                                                                  |
//|  ------------------------------------------------------------    |
//|  LE NOTE DI ATTUAZIONE, NUMERATE (si leggono PRIMA dei numeri)    |
//|  ------------------------------------------------------------    |
//|                                                                  |
//|  N1. GESTIONE POSIZIONI HEDGE-SAFE DALLA NASCITA.                 |
//|      Il conto BCM 50503392 e' HEDGING (CLAUDE.md). In quel        |
//|      regime PositionSelect(_Symbol) seleziona LA PIU' VECCHIA     |
//|      posizione del simbolo, QUALUNQUE sia il magic: un EA che la  |
//|      usa diventa cieco alla propria posizione, e CTrade con       |
//|      _Symbol chiude o modifica QUELLA DEL VICINO.                 |
//|      Censimento del difetto: report\AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md
//|      (26 file vulnerabili + 8 "mezzo fix", il caso peggiore).     |
//|      >>> QUI IL DIFETTO NON PUO' NASCERE, per costruzione:        |
//|        - LETTURA: si itera PositionsTotal() con                   |
//|          PositionGetTicket(i) e si filtra SIMBOLO **e** MAGIC;    |
//|        - SCRITTURA: l'unica chiamata di chiusura e'               |
//|          PositionClose(TICKET). Non esiste nessuna variante per   |
//|          simbolo in tutto il file.                                |
//|      L'audit dice che il mezzo fix (lettura sana + scrittura per  |
//|      simbolo) e' PIU' PERICOLOSO del bug originale: qui le due    |
//|      meta' nascono insieme.                                       |
//|                                                                  |
//|  N2. NESSUNA GESTIONE. NON E' UN INPUT SPENTO: NON ESISTE.        |
//|      I criteri (par. 3.3) dicono parziale / breakeven / trailing  |
//|      TUTTI SPENTI, con la lezione dell'EA oro citata testualmente |
//|      ("parziale precoce + breakeven immediato tappavano i         |
//|      vincenti mentre lo SL prendeva perdite piene").              |
//|      Qui quella gestione NON e' scritta affatto. Un input a       |
//|      false e' una riga che qualcuno puo' mettere a true dall'.ini |
//|      senza che nessuno se ne accorga; un codice che non esiste    |
//|      non si accende per sbaglio. La gestione e' un ROUND          |
//|      SUCCESSIVO, non un ingrediente del primo.                    |
//|                                                                  |
//|  N3. LA GEOMETRIA E' QUELLA DELLA FONTE, IN PIP, SU ENTRAMBE LE   |
//|      GAMBE: TP 15,0 / SL 8,0 pip (= 150/80 tick su feed a 5       |
//|      decimali, RR 1,875). Su GBPUSD lo stop vale ~1 ATR di        |
//|      sessione (8,58 pip misurati al PASSO 0): E' STRETTISSIMO, e  |
//|      NON si adatta (criteri par. 3.4). Se GBPUSD muore per stop   |
//|      troppo stretto, QUELLO E' IL RISULTATO.                      |
//|                                                                  |
//|  N4. LA SOGLIA RSI DELLO SHORT E' 20 (SIMMETRICA) -- FIRMA F5,    |
//|      OPZIONE A, firmata esplicitamente ("anche la A su F5").      |
//|      Un solo input InpRsiSoglia = 80 per il long, lo short usa    |
//|      100 - 80 = 20. E' PIU' PERMISSIVO del 10 dell'autore, ed e'  |
//|      la configurazione che ha PASSATO IL PASSO 0.                 |
//|      >>> CONSEGUENZA DA SCRIVERE NEL REFERTO se lo short passa:   |
//|          "passato con soglia 20, piu' permissiva del 10 della     |
//|          fonte".                                                  |
//|                                                                  |
//|  N5. L'ORA E' CONGELATA A 8 (08:00-16:00 ORA SERVER, FINE         |
//|      ESCLUSA) -- FIRMA F2. Server BCM = ora italiana - 1 = ora di |
//|      Londra: l'ora 8 E' la sessione di Londra, e non e' un        |
//|      vincitore pescato ma la previsione dichiarata PRIMA dei      |
//|      numeri nel PASSO 0. Le ore 4 e 6 NON sono un asse: tornano   |
//|      solo DOPO, e SOLO SE la 8 passa, come prova di fragilita'.   |
//|      Gli input restano (InpOraInizioServer / InpOreSessione)      |
//|      perche' un'ora sepolta in una costante e' un'ora che nessuno |
//|      puo' verificare: escono anche in COLONNA.                    |
//|      PROMEMORIA DI CASA (errore pagato il 06/08): le schede       |
//|      Esperti e Giornale di MT5 stampano in ORA LOCALE del PC, il  |
//|      GRAFICO e TimeCurrent() in ORA SERVER. Qui dentro si lavora  |
//|      SEMPRE in ora server.                                        |
//|                                                                  |
//|  N6. DOVE FINISCE L'ULTIMO INGRESSO, e perche' non e' un taglio.  |
//|      I criteri dicono "nessun taglio: si entra fino all'ultima    |
//|      barra della sessione". Il segnale pero' nasce sulla BARRA    |
//|      CHIUSA e l'ingresso avviene all'APERTURA DELLA BARRA         |
//|      SUCCESSIVA (fedelta' al Pine, che non ha                     |
//|      process_orders_on_close). Quindi il segnale dell'ultima      |
//|      barra di sessione (15:45 su M15) vorrebbe entrare alle       |
//|      16:00, cioe' FUORI, dove il flat chiuderebbe al tick dopo:   |
//|      sarebbe un'operazione nata morta, spread pagato e zero       |
//|      informazione.                                                |
//|      >>> SCELTA DICHIARATA: si apre solo se ANCHE IL MOMENTO      |
//|          DELL'INGRESSO e' dentro la sessione. Non e' un taglio    |
//|          anticipato (nessun "ultimo ingresso alle 15:00"): e' il  |
//|          MEDESIMO cancello di sessione applicato al momento in    |
//|          cui l'ordine parte davvero. Conseguenza aritmetica: su   |
//|          M15 l'ultima barra di SEGNALE utile e' quella delle      |
//|          15:30. Quanti segnali questo costi NON e' una stima: e'  |
//|          la colonna "Segnali Soppressi Fine Sessione".            |
//|                                                                  |
//|  N7. IL CAP DI PERDITA GIORNALIERA (2,0% dell'equity) FA DUE      |
//|      COSE, come nel Pine (max_intraday_loss(2, percent_of_equity)):
//|      chiude cio' che e' aperto E blocca i nuovi ingressi per il   |
//|      resto della giornata server. Il riferimento e' l'EQUITY AL   |
//|      PRIMO TICK DELLA GIORNATA SERVER.                            |
//|      >>> IL REGALO, SCRITTO PRIMA (criteri par. 5.4): con questo  |
//|          cap acceso il cancello A5 (peggior giornata >= -4,0%)    |
//|          passera' quasi certamente, e NON sara' un merito del     |
//|          segnale. Il merito che non si e' guadagnato non si       |
//|          incassa. E se A5 fallisse LO STESSO, la notizia e' che   |
//|          il cap non funziona come crediamo: si ferma il round e   |
//|          si indaga il CONTENITORE, prima del merito.              |
//|                                                                  |
//|  N8. LO SPREAD SI MISURA, NON SI FILTRA (lezione R55, firma F9).  |
//|      InpMaxSpread = 0 = filtro SPENTO. L'EA registra              |
//|      (ask - bid) / pip NEL MOMENTO ESATTO dell'ingresso e ne      |
//|      esporta MEDIANA e P95. Questo round produce il numero che    |
//|      manca a tutta la casa (spread BCM su EURUSD/GBPUSD nella     |
//|      sessione di Londra) ANCHE SE BOCCIA TUTTO IL RESTO: chiude   |
//|      la voce H12 del PIANO_PROP.                                  |
//|                                                                  |
//|  N9. LO SLIPPAGE (InpSlippagePts, firma F10 / R55-bis) NON e' la  |
//|      "deviation" di CTrade, ed e' importante non confonderli:     |
//|        - la DEVIATION e' la tolleranza che diamo al broker in     |
//|          esecuzione (resta FISSA a 30 punti per tutte le celle:   |
//|          e' contenitore, non asse);                               |
//|        - InpSlippagePts e' un COSTO SIMULATO, e si applica alla   |
//|          GEOMETRIA. L'aritmetica, per esteso, perche' e' la       |
//|          parte che si sbaglia: se l'ordine si riempisse S punti   |
//|          PEGGIO mentre SL e TP sono i prezzi calcolati sul        |
//|          prezzo VISTO, la perdita realizzata sarebbe (SL + S) e   |
//|          il guadagno realizzato (TP - S). Nel tester il           |
//|          riempimento e' esatto, quindi si ottiene lo stesso       |
//|          effetto spostando i livelli:                             |
//|              distanza SL = 8,0 pip + S punti                      |
//|              distanza TP = 15,0 pip - S punti                     |
//|          Con S = 5 punti (0,50 pip): SL 8,5 / TP 14,5.            |
//|          E' una penalita' su ENTRAMBI i lati, cioe' la lettura    |
//|          PRUDENZIALE, e su uno stop da 8 pip vale il 6,3% di un   |
//|          R -- la classe dell'ORB, che R55 ha misurato 11 volte    |
//|          piu' fragile del PTE.                                    |
//|          >>> Il lotto si calcola sulla distanza DAVVERO PIAZZATA  |
//|              (8,0 + S): il rischio in euro resta 0,65%, e 1R      |
//|              cresce. Dichiarato, non nascosto.                    |
//|                                                                  |
//|  N10. IL CANCELLO DI RISCALDAMENTO E' DEL CONTENITORE, NON DEL    |
//|      MOTORE: nessuna barra si valuta se non e' disponibile la     |
//|      coda di InpWarmupBarre barre (default 300). Cosi' i tre      |
//|      motori cominciano a poter armare lo stesso giorno.           |
//|      L'unica differenza ammessa e' che il motore 3 non arma       |
//|      finche' le SUE cinque medie non sono valide (l'EMA200 e'     |
//|      la piu' lenta): quella e' una proprieta' DEL MOTORE, ed e'   |
//|      dichiarata. Con 300 barre di coda le due cose praticamente   |
//|      coincidono.                                                  |
//|                                                                  |
//|  N11. UN SEGNALE CONTA IN UNA SOLA CASELLA. Le colonne del        |
//|      canarino DEVONO sommare: per questo le soppressioni sono     |
//|      valutate in ordine e sono MUTUAMENTE ESCLUSIVE. L'ordine e'  |
//|      dichiarato qui e non si cambia:                              |
//|        1) ingresso fuori sessione (N6)                            |
//|        2) posizione gia' aperta                                   |
//|        3) tetto ingressi del giorno                               |
//|        4) cap di perdita giornaliera                              |
//|        5) filtro di spread (di norma SPENTO)                      |
//|      Identita' che il verificatore puo' controllare a mano:       |
//|        Segnali Generati = Ingressi Totali + le cinque colonne     |
//|        di soppressione (+ gli ingressi falliti per lotto o        |
//|        retcode, che hanno la loro colonna).                       |
//|                                                                  |
//|  N12. "Segnali Generati" conta i segnali del MOTORE ATTIVO su     |
//|      BARRA CHIUSA DENTRO LA SESSIONE, prima di ogni cancello del  |
//|      contenitore. I due lati sono mutuamente esclusivi per        |
//|      costruzione (una chiusura non puo' stare sopra e sotto lo    |
//|      stesso canale), quindi al massimo un segnale per barra.      |
//|                                                                  |
//|  N13. LE COLONNE DEL CANARINO STANNO PRIME NEL CSV, PRIMA DEL     |
//|      CONTO ECONOMICO (criteri par. 4: "si legge PRIMA del conto   |
//|      economico"). E escono dai DATI (FrameAdd/OPTFRAME), non da   |
//|      Print: in ottimizzazione MT5 non esegue le Print degli       |
//|      agent (lezione R95 par. 3.1).                                |
//|                                                                  |
//|  N14. IL COLLAUDO DELLA TRADUZIONE RSI NON SI RIFA' QUI. Lo ha    |
//|      gia' fatto la sonda al PASSO 0 con la colonna "Rsi           |
//|      Divergenza Max" (RSI di Wilder nostro contro iRSI di MQL5,   |
//|      atteso ~1e-10), sullo STESSO codice che questo file riusa.   |
//|      Rifarlo qui vorrebbe dire un handle in piu' su tutte e tre   |
//|      le celle per riconfermare un numero gia' misurato. Se il     |
//|      verificatore lo volesse comunque, si riaccende la sonda:     |
//|      e' un'altra corsa, non un'altra colonna.                     |
//|                                                                  |
//|  DEMO. ASCII PURO: niente accenti dentro le stringhe, niente      |
//|  emoji (regola di casa dei .ps1, estesa ai .mq5 perche' log e     |
//|  CSV finiscono negli stessi strumenti).                           |
//+------------------------------------------------------------------+
#property copyright "ABTG - contenitore LondonFx R116 - riscritture da (c) SoftKill21, MPL 2.0"
#property link      "https://www.tradingview.com/script/E6yr9CoN-EURUSD-5min-london-session-strategy/"
#property version   "1.00"
#property description "R116: UN contenitore, TRE motori a interruttore (canale nudo / canale+RSI / allineamento 5 medie). Sessione Londra, flat obbligatorio, TP 15 / SL 8 pip, rischio 0,65%, cap 2%/giorno."
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report\FIRME_2026-08-18.md
//    Il default true NON cambia niente da solo: se il Guardian non gira
//    su questo conto -- e nel Strategy Tester, dove le sue
//    GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale) e i backtest restano confrontabili.
//    NOTA DI ROUND: con 1 posizione per volta il rischio aperto e'
//    <= 0,65%, ben sotto il cap C1 di 3,25%. Il cap NON MORDE MAI in
//    questo round, ed e' scritto qui perche' non lo si scopra dopo.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade gTrade;

//==================================================================
//  I TRE MOTORI. Sono #define e non un enum APPOSTA: nell'.ini si
//  pinna un numero, e un numero si legge nel CSV senza tabella di
//  conversione. La colonna "Motore" riporta il valore DAVVERO usato.
//==================================================================
#define LONDONFX_MOTORE_CANALE_NUDO   1   // ramo di CONTROLLO: l'autore dichiara l'RSI OPZIONALE
#define LONDONFX_MOTORE_CANALE_RSI    2   // LA BASELINE: e' il candidato, ed e' l'unico promuovibile
#define LONDONFX_MOTORE_ALLINEA5      3   // secondo ramo di controllo: segnale COMPLETAMENTE diverso

//--- LA GEOMETRIA DELLA FONTE, in pip. Sono #define e non input:
//    i criteri (par. 8.3) vietano l'adattamento per simbolo, e una
//    geometria che si puo' spostare dalla riga di lancio non e' una
//    geometria congelata. Escono comunque in colonna.
//    150 tick / 80 tick su feed a 5 decimali = 15,0 / 8,0 pip.
#define LONDONFX_TP_PIP   15.0
#define LONDONFX_SL_PIP    8.0

//--- I VINCOLI DEL CONTENITORE, dalla fonte. Stessa ragione: #define.
#define LONDONFX_MAX_TRADES_GIORNO   6     // Pine: max_intraday_filled_orders(6)
#define LONDONFX_CAP_GIORNALIERO_PCT 2.0   // Pine: max_intraday_loss(2, percent_of_equity)
#define LONDONFX_MAX_POSIZIONI       1     // Pine: pyramiding 1

//--- il cancello E del round, solo per il referto a schermo (non
//    decide niente qui dentro: decide il verificatore sul CSV).
#define LONDONFX_E_TARGET_R 0.075          // FIRMA 2 del 31/08, cancello A1

//--- capienza del campione di spread. Su 2 anni e ~2-3 trade/giorno
//    siamo nell'ordine delle migliaia: 100.000 e' abbondante. Se si
//    arrivasse al tetto, la mediana sarebbe TRONCATA e il fatto viene
//    detto a voce alta invece di essere ingoiato.
#define LONDONFX_MAX_CAMPIONI 100000

//--- QUANTI BLOCCHI E QUANTI CASI DEVE ESEGUIRE L'AUTOTEST.
//    Due contatori e non uno: un blocco cancellato per sbaglio non
//    deve poter passare per "tutto verde", e nemmeno un blocco
//    SVUOTATO delle sue asserzioni (che il conteggio dei soli blocchi
//    non vedrebbe). Se uno dei due conti non torna, l'autotest si
//    dichiara FALLITO.
#define LONDONFX_AUTOTEST_BLOCCHI_ATTESI 17
#define LONDONFX_AUTOTEST_CASI_ATTESI   112

//==================================================================
//  INPUT
//  I nomi vanno pinnati TALI E QUALI nel file prova: MT5 IGNORA IN
//  SILENZIO un pin che non trova (errore n.3 della
//  CHECKLIST_RIGA_DI_LANCIO: e' cosi' che e' nato il falso "0/8" del
//  FiboH4).
//==================================================================
input group "=== L'INTERRUTTORE DELL'ABLAZIONE (l'UNICA riga che cambia fra le celle) ==="
input int    InpMotore       = 2;        // 1=canale NUDO, 2=canale+RSI (BASELINE), 3=allineamento 5 medie

input group "=== MOTORE 1-2: il canale di Londra (congelato ai valori della fonte) ==="
input int    InpSmaPeriodo   = 5;        // SMA su HIGH e su LOW: il canale (Pine righe 6-15)
input int    InpRsiPeriodo   = 5;        // RSI: periodo (Pine riga 18)
input double InpRsiSoglia    = 80.0;     // RSI: soglia LONG. Lo SHORT usa 100 - questa = 20 (FIRMA F5, opzione A)

input group "=== MOTORE 3: allineamento 5 medie (congelato ai default dell'autore) ==="
input int    InpSmma1        = 3;        // SMMA veloce (Pine: smma  3)
input int    InpSmma2        = 6;        // SMMA        (Pine: smma2 6)
input int    InpSmma3        = 9;        // SMMA        (Pine: smma3 9)
input int    InpSmma4        = 50;       // SMMA lenta  (Pine: smma4 50)
input int    InpEmaLenta     = 200;      // EMA di fondo (Pine: ema200)

input group "=== IL CONTENITORE: la sessione, in ORA SERVER BCM (= ora italiana - 1) ==="
input int    InpOraInizioServer = 8;     // ORA SERVER di inizio. CONGELATA a 8 dalla firma F2 (08:00 = Londra)
input int    InpOreSessione     = 8;     // durata in ore, FINE ESCLUSA come in Pine (08:00-16:00)

input group "=== IL CONTENITORE: rischio e costi ==="
input double InpRiskPercent  = 0.65;     // Rischio per operazione, % del SALDO, sulla distanza dello stop (firma F6)
input int    InpMaxSpread    = 0;        // Filtro spread in punti MT5. 0 = SPENTO: lo spread si MISURA, non si filtra (F9)
input int    InpSlippagePts  = 0;        // COSTO SIMULATO in punti MT5 (R55-bis: 0 / 2 / 5). Vedi N9: NON e' la deviation

input group "=== TECNICI ==="
input double InpPipSize      = 0.0001;   // 1 pip in PREZZO. 0,0001 su EURUSD/GBPUSD. VERIFICATO contro DIGITS in OnInit
input int    InpWarmupBarre  = 300;      // coda di barre su cui si ricalcolano gli indicatori dei motori 1-2 (vedi N10)
input string InpComment      = "LONDONFX";        // Commento sugli ordini
input long   InpMagic        = 774001;   // Magic. Blocco 7740xx VERGINE nel repo (7741xx = GapContinuation): RI-VERIFICARE AL LANCIO
input bool   InpVerbose      = true;     // log (in ottimizzazione NON li legge nessuno: per quello ci sono le colonne)
input bool   InpAutoTest     = true;     // autotest del nucleo puro. L'esito esce in COLONNA, non nei log

//==================================================================
//  STATO
//==================================================================
//--- gli handle del MOTORE 3. Si creano SEMPRE, anche quando gira il
//    motore 1 o il 2: cosi' l'inizializzazione del banco e' identica
//    fra le tre celle e nessuno puo' dire che una cella e' partita
//    "piu' leggera" dell'altra. Costano una manciata di byte.
int      hSmma1 = INVALID_HANDLE, hSmma2 = INVALID_HANDLE;
int      hSmma3 = INVALID_HANDLE, hSmma4 = INVALID_HANDLE;
int      hEma   = INVALID_HANDLE;

datetime gLastBar = 0;

//--- la giornata operativa (ora SERVER)
int      gDayOper          = -1;
int      gTradesOggi       = 0;
bool     gTettoContatoOggi = false;
bool     gCapColpitoOggi   = false;

//--- la posizione viva. Lo stato e' legato AL TICKET.
ulong    gTicket = 0;
ulong    gTicketNotteContata = 0;

//--- LE OTTO COLONNE OBBLIGATORIE del canarino (criteri par. 4.3)
long     gSegnaliGenerati   = 0;   // 1
long     gSoppPosizione     = 0;   // 2
long     gSoppTetto         = 0;   // 3
long     gGiorniTetto       = 0;   // 4
long     gGiorniCap         = 0;   // 5
//   6 = Trade Chiusi dal FLAT (%): si calcola dalle uscite, sotto
//   7-8 = spread mediano e P95 all'ingresso: campione, sotto

//--- le altre soppressioni (N11): mutuamente esclusive con le sopra
long     gSoppFineSessione  = 0;
long     gSoppCap           = 0;
long     gSoppSpread        = 0;
long     gIngressiFalliti   = 0;   // lotto non calcolabile o retcode negativo

//--- anatomia degli ingressi e delle uscite
long     gIngressiTot   = 0;
long     gIngressiLong  = 0;
long     gIngressiShort = 0;
long     gUsciteFlat    = 0;       // le abbiamo chiuse noi a fine sessione
long     gUsciteCap     = 0;       // le ha chiuse il cap del 2%
long     gUsciteMercato = 0;       // se n'e' andata da sola: stop o take
long     gNottiAttrav   = 0;       // DEVE essere 0: se non lo e', il flat non e' ermetico
long     gLottiAlMinimo = 0;       // rischio REALE piu' alto del dichiarato, quante volte
long     gStopAllargato = 0;       // quante volte lo STOPS_LEVEL del broker ha allargato la geometria

//--- diagnostica del banco
long     gBarreSessione = 0;       // barre chiuse valutate DENTRO la sessione
long     gBarreSaltate  = 0;       // coda di dati non disponibile (vedi N10)
long     gGiorniContati = 0;
//--- timbro della giornata di borsa gia' contata. E' una globale e non
//    una 'static' dentro la funzione APPOSTA: le static in
//    ottimizzazione sono l'ultimo posto in cui si va a cercare uno
//    stato che sopravvive fra le passate, e AzzeraContatori() deve
//    poter azzerare TUTTO da un punto solo.
int      gStampGiorno   = -1;

//--- il campione dello spread all'ingresso, in PIP (firma F9)
double   gSpread[];
int      gNSpread   = 0;
bool     gTroncato  = false;

//--- il denominatore di E in R: rischio in valuta DICHIARATO
//    all'apertura, sommato operazione per operazione. Non e' una
//    stima: e' il numero che l'EA ha usato per dimensionare il lotto.
double   gSommaRischioValuta = 0.0;

//--- peggior giornata in % di equity (numero NEGATIVO). E' IL numero
//    del cancello A5 e del muro prop giornaliero.
double   gDayStartEquity = 0.0;
double   gDayMinEquity   = 0.0;
double   gWorstDayPct    = 0.0;
int      gDayEqStamp     = -1;

//--- collaudo. -1 = NON eseguito, che non e' "passato".
int      gAutotestFalliti = -1;
int      gAutotestBlocchi = 0;
int      gAutotestCasi    = 0;

void Log(string m){ if(InpVerbose) Print("[LONDONFX] ", m); }

//==================================================================
//
//   NUCLEO PURO -- funzioni che non leggono NIENTE dal terminale.
//   Prendono numeri e rispondono. E' questa la parte che l'AUTOTEST
//   interroga a tavolino, senza mercato.
//   Le prime cinque arrivano TALI E QUALI da ABTG_SondaLondonFx.mq5
//   (PASSO 0, autotest 16/16): riusate, non riscritte.
//
//==================================================================

//+------------------------------------------------------------------+
//| RSI da medie di Wilder gia' calcolate. Il caso degenere e'         |
//| esplicito: perdite nulle -> 100 se ci sono guadagni, 50 se il      |
//| mercato e' perfettamente piatto. E' la convenzione di RSI.mq5.     |
//+------------------------------------------------------------------+
double RsiDaMedie_Calc(const double mediaGuadagni, const double mediaPerdite)
  {
   if(mediaPerdite <= 0.0) return(mediaGuadagni > 0.0 ? 100.0 : 50.0);
   double rs = mediaGuadagni/mediaPerdite;
   return(100.0 - 100.0/(1.0 + rs));
  }

//+------------------------------------------------------------------+
//| RSI DI WILDER su tutta la serie (indice 0 = barra piu' VECCHIA).   |
//| Seme = media semplice dei primi 'periodo' delta, poi ricorsione    |
//| di Wilder: e' rsi() di Pine ed e' iRSI di MQL5 (equivalenza gia'   |
//| MISURATA dalla sonda al PASSO 0, colonna "Rsi Divergenza Max").    |
//| out[i] = -1 dove l'RSI non e' ancora definito: -1 sta fuori dal    |
//| dominio [0,100], quindi nessun confronto di soglia lo scambia per  |
//| un valore vero.                                                    |
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
//| SMA alla Pine: definita dall'indice periodo-1 in poi.              |
//+------------------------------------------------------------------+
bool SmaSerie_Calc(const double &src[], const int n, const int periodo, double &out[])
  {
   if(periodo < 1 || n < periodo) return(false);
   if(ArrayResize(out, n) != n) return(false);
   for(int i = 0; i < n; i++) out[i] = 0.0;

   double s = 0.0;
   for(int i = 0; i < periodo; i++) s += src[i];
   out[periodo - 1] = s/(double)periodo;

   for(int i = periodo; i < n; i++)
     {
      s += src[i] - src[i - periodo];
      out[i] = s/(double)periodo;
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| IL CANALE, LATO LONG (Pine riga 25): close > sma(high) AND         |
//| close > sma(low). La seconda meta' e' RIDONDANTE (sma(high) sta    |
//| sempre sopra sma(low)) e si riproduce lo stesso, ALLA LETTERA:     |
//| fedelta' al sorgente, e un valore sporco non passa per caso.       |
//| I confronti sono STRETTI: una chiusura esattamente sulla media     |
//| NON e' una rottura.                                                |
//+------------------------------------------------------------------+
bool CanaleLong_Calc(const double chiusura, const double smaHigh, const double smaLow)
  {
   return(chiusura > smaHigh && chiusura > smaLow);
  }

//+------------------------------------------------------------------+
//| IL CANALE, LATO SHORT (Pine riga 26): specchio esatto.             |
//+------------------------------------------------------------------+
bool CanaleShort_Calc(const double chiusura, const double smaHigh, const double smaLow)
  {
   return(chiusura < smaHigh && chiusura < smaLow);
  }

//+------------------------------------------------------------------+
//| LA CONFERMA RSI, SIMMETRIZZATA -- FIRMA F5, OPZIONE A (vedi N4).   |
//| usa = false -> passa sempre: e' il ramo "canale NUDO", e deve      |
//| essere neutro per costruzione.                                     |
//| rsi < 0 = "non ancora definito": non passa mai.                    |
//| I confronti sono STRETTI su ENTRAMBI i lati: 80 esatto non e' un   |
//| long, 20 esatto non e' uno short. Lo stesso metro sui due lati e'  |
//| la regola dei due lati del 25/08.                                  |
//+------------------------------------------------------------------+
bool FiltroRsi_Calc(const bool usa, const bool latoLong, const double rsi, const double soglia)
  {
   if(!usa) return(true);
   if(rsi < 0.0) return(false);
   if(latoLong) return(rsi > soglia);
   return(rsi < (100.0 - soglia));
  }

//+------------------------------------------------------------------+
//| IL MOTORE 3, LATO LONG -- copiato ALLA LETTERA da                  |
//| ABTG_AllineaLondra.mq5 righe 356-362 (Pine righe 65-66).           |
//| Prezzo sopra tutte e cinque E medie impilate. Le due condizioni    |
//| sono ridondanti per transitivita' e si scrivono TUTTE lo stesso.   |
//+------------------------------------------------------------------+
bool AllineaLong_Calc(const double close, const double m1, const double m2,
                      const double m3, const double m4, const double ema)
  {
   if(close <= 0 || m1 <= 0 || m2 <= 0 || m3 <= 0 || m4 <= 0 || ema <= 0) return(false);
   if(!(close > m1 && close > m2 && close > m3 && close > m4 && close > ema)) return(false);
   return(m1 > m2 && m2 > m3 && m3 > m4 && m4 > ema);
  }

//+------------------------------------------------------------------+
//| IL MOTORE 3, LATO SHORT -- lo specchio esatto, stesso codice       |
//| (ABTG_AllineaLondra.mq5 righe 367-373).                            |
//+------------------------------------------------------------------+
bool AllineaShort_Calc(const double close, const double m1, const double m2,
                       const double m3, const double m4, const double ema)
  {
   if(close <= 0 || m1 <= 0 || m2 <= 0 || m3 <= 0 || m4 <= 0 || ema <= 0) return(false);
   if(!(close < m1 && close < m2 && close < m3 && close < m4 && close < ema)) return(false);
   return(m1 < m2 && m2 < m3 && m3 < m4 && m4 < ema);
  }

//+------------------------------------------------------------------+
//| L'INTERRUTTORE DELL'ABLAZIONE, IN UNA FUNZIONE SOLA E PURA.        |
//| +1 long, -1 short, 0 niente. E' QUI che i tre motori si            |
//| distinguono, e da nessun'altra parte: tutto quello che sta a valle |
//| (sessione, tetti, cap, geometria, rischio, uscite) e' identico.    |
//| Un motore sconosciuto risponde 0 -- non "long per difetto":        |
//| un interruttore rotto deve fermare l'EA, non farlo tirare a        |
//| indovinare. OnInit comunque rifiuta di partire (vedi sotto).       |
//+------------------------------------------------------------------+
int MotoreSegnale_Calc(const int motore,
                       const double chiusura, const double smaHigh, const double smaLow,
                       const double rsi, const double sogliaRsi,
                       const double m1, const double m2, const double m3,
                       const double m4, const double ema)
  {
   if(motore == LONDONFX_MOTORE_CANALE_NUDO)
     {
      if(CanaleLong_Calc (chiusura, smaHigh, smaLow)) return(+1);
      if(CanaleShort_Calc(chiusura, smaHigh, smaLow)) return(-1);
      return(0);
     }
   if(motore == LONDONFX_MOTORE_CANALE_RSI)
     {
      if(CanaleLong_Calc (chiusura, smaHigh, smaLow) &&
         FiltroRsi_Calc(true, true,  rsi, sogliaRsi)) return(+1);
      if(CanaleShort_Calc(chiusura, smaHigh, smaLow) &&
         FiltroRsi_Calc(true, false, rsi, sogliaRsi)) return(-1);
      return(0);
     }
   if(motore == LONDONFX_MOTORE_ALLINEA5)
     {
      if(AllineaLong_Calc (chiusura, m1, m2, m3, m4, ema)) return(+1);
      if(AllineaShort_Calc(chiusura, m1, m2, m3, m4, ema)) return(-1);
      return(0);
     }
   return(0);
  }

//+------------------------------------------------------------------+
//| LA SESSIONE IN ORA SERVER. Inizio INCLUSO, fine ESCLUSA, come la   |
//| session() di Pine. Regge anche il caso a cavallo della mezzanotte  |
//| (su Londra non serve, su una sessione asiatica servirebbe).        |
//+------------------------------------------------------------------+
bool SessioneAttiva_Calc(const int ora, const int inizio, const int ore)
  {
   if(ore <= 0 || ore > 24) return(false);
   if(ora < 0 || ora > 23) return(false);
   if(inizio < 0 || inizio > 23) return(false);
   if(ore == 24) return(true);
   int fine = inizio + ore;                       // ESCLUSA
   if(fine <= 24) return(ora >= inizio && ora < fine);
   return(ora >= inizio || ora < (fine - 24));
  }

//+------------------------------------------------------------------+
//| Da PIP a differenza di PREZZO. pipSize <= 0 -> 0.                  |
//| Collaudo che vale la pena tenere a mente:                          |
//|   DistanzaDaPip_Calc(15,0 ; 0,0001) = 0,00150 = il take della      |
//|   fonte (150 tick su feed a 5 decimali).                           |
//+------------------------------------------------------------------+
double DistanzaDaPip_Calc(const double pip, const double pipSize)
  {
   if(pipSize <= 0.0 || pip <= 0.0) return(0.0);
   return(pip*pipSize);
  }

//+------------------------------------------------------------------+
//| Da differenza di PREZZO a PIP (serve alla misura dello spread).    |
//+------------------------------------------------------------------+
double Pip_Calc(const double diffPrezzo, const double pipSize)
  {
   if(pipSize <= 0.0) return(0.0);
   return(diffPrezzo/pipSize);
  }

//+------------------------------------------------------------------+
//| IL PIP CHE IL SIMBOLO SI ASPETTA. Sui simboli a 5 decimali (major  |
//| non-JPY) e a 3 (JPY) il pip vale DIECI punti MT5; sui vecchi 4 e 2 |
//| ne vale uno. Serve al cancello di OnInit: leggere "15" dove il     |
//| vero numero e' "1,5" e' un errore di un fattore 10, ed e'          |
//| esattamente il tipo di errore che questa casa ha gia' pagato.      |
//+------------------------------------------------------------------+
double PipAttesoDaDigits_Calc(const double punto, const int decimali)
  {
   if(punto <= 0.0) return(0.0);
   if(decimali == 3 || decimali == 5) return(punto*10.0);
   return(punto);
  }

//+------------------------------------------------------------------+
//| LA DISTANZA DELLO STOP CON IL COSTO SIMULATO DI SLIPPAGE (N9).     |
//| SL = 8,0 pip + S punti: lo slippage ALLARGA la perdita.            |
//+------------------------------------------------------------------+
double DistSlConSlippage_Calc(const double slPip, const double pipSize,
                              const int slipPts, const double punto)
  {
   double d = DistanzaDaPip_Calc(slPip, pipSize);
   if(d <= 0.0) return(0.0);
   if(slipPts > 0 && punto > 0.0) d += (double)slipPts*punto;
   return(d);
  }

//+------------------------------------------------------------------+
//| LA DISTANZA DEL TAKE CON IL COSTO SIMULATO DI SLIPPAGE (N9).       |
//| TP = 15,0 pip - S punti: lo slippage ACCORCIA il guadagno.         |
//| Se lo slippage si mangiasse tutto il take, la distanza NON diventa |
//| negativa (un TP dalla parte sbagliata sarebbe un ordine assurdo):  |
//| resta un residuo positivo minimo di UN punto, e il fatto e'        |
//| visibile perche' la colonna "Slippage Pts" dice con che numero si  |
//| e' girato.                                                         |
//+------------------------------------------------------------------+
double DistTpConSlippage_Calc(const double tpPip, const double pipSize,
                              const int slipPts, const double punto)
  {
   double d = DistanzaDaPip_Calc(tpPip, pipSize);
   if(d <= 0.0) return(0.0);
   if(slipPts > 0 && punto > 0.0)
     {
      d -= (double)slipPts*punto;
      if(d < punto) d = punto;
     }
   return(d);
  }

//+------------------------------------------------------------------+
//| IL CAP DI PERDITA GIORNALIERA (N7). Il bordo e' ESATTO e va        |
//| verso la clausola PIU' SEVERA: una perdita di ESATTAMENTE il 2,00% |
//| E' il cap colpito, non "quasi". capPct <= 0 = spento (non          |
//| accade in questo round: e' un #define a 2,0).                      |
//+------------------------------------------------------------------+
bool CapGiornalieroColpito_Calc(const double equityInizio, const double equityOra,
                                const double capPct)
  {
   if(capPct <= 0.0) return(false);
   if(equityInizio <= 0.0) return(false);
   double pct = (equityOra - equityInizio)/equityInizio*100.0;
   return(pct <= -capPct);
  }

//+------------------------------------------------------------------+
//| IL TETTO DI INGRESSI DEL GIORNO. Bordo esatto: con tetto 6, il     |
//| SESTO ingresso e' ammesso e il SETTIMO no -- cioe' "fatti >= 6"    |
//| BLOCCA. tetto <= 0 = spento.                                       |
//+------------------------------------------------------------------+
bool TettoColpito_Calc(const int fatti, const int tetto)
  {
   if(tetto <= 0) return(false);
   return(fatti >= tetto);
  }

//+------------------------------------------------------------------+
//| IL FILTRO DI SPREAD, in punti MT5. maxPunti <= 0 = SPENTO, ed e'   |
//| il default del round (N8). Blocca solo SOPRA la soglia: spread     |
//| esattamente uguale al massimo passa.                               |
//+------------------------------------------------------------------+
bool SpreadFuoriLimite_Calc(const double spreadPunti, const double maxPunti)
  {
   if(maxPunti <= 0.0) return(false);
   return(spreadPunti > maxPunti);
  }

//+------------------------------------------------------------------+
//| MEDIANA di un vettore GIA' ORDINATO. Pari -> media dei centrali.   |
//| n <= 0 -> 0, che si legge "nessun campione", non "zero pip".       |
//+------------------------------------------------------------------+
double MedianaOrdinata_Calc(const double &v[], const int n)
  {
   if(n <= 0) return(0.0);
   if(n % 2 == 1) return(v[n/2]);
   return((v[n/2 - 1] + v[n/2])/2.0);
  }

//+------------------------------------------------------------------+
//| PERCENTILE di un vettore GIA' ORDINATO, metodo "nearest rank":     |
//| indice = ceil(p*n) - 1, tosato dentro il vettore.                  |
//| E' la definizione piu' semplice e la piu' facile da ricontare a    |
//| mano da un foglio -- e siccome il P95 dello spread finira' in un   |
//| referto, deve essere ricontabile. Con n = 100 e p = 0,95 risponde  |
//| il 95esimo valore ordinato, che e' quello che un umano si aspetta. |
//+------------------------------------------------------------------+
double PercentileOrdinato_Calc(const double &v[], const int n, const double p)
  {
   if(n <= 0) return(0.0);
   if(p <= 0.0) return(v[0]);
   int idx = (int)MathCeil(p*(double)n) - 1;
   if(idx < 0) idx = 0;
   if(idx > n-1) idx = n-1;
   return(v[idx]);
  }

//+------------------------------------------------------------------+
//| LOTTO GREZZO dal rischio: saldo * risk% / perdita per lotto.       |
//| Qualunque ingrediente non valido -> 0 (nessun ordine), mai un      |
//| numero inventato.                                                  |
//+------------------------------------------------------------------+
double LottoGrezzo_Calc(const double saldo, const double riskPct,
                        const double perditaPerLotto)
  {
   if(saldo <= 0 || riskPct <= 0 || perditaPerLotto <= 0) return(0.0);
   return((saldo*riskPct/100.0)/perditaPerLotto);
  }

//+------------------------------------------------------------------+
//| NORMALIZZAZIONE AI VINCOLI DI VOLUME DEL SIMBOLO -- CON FLOOR      |
//| ESPLICITO: sotto il minimo del broker si sale al minimo, MAI si    |
//| restituisce 0 per arrotondamento. In quel caso pero' il rischio    |
//| REALE e' piu' alto di quello dichiarato, e 'alMinimo' lo dice: il  |
//| fatto finisce in colonna, non sotto il tappeto.                    |
//+------------------------------------------------------------------+
double NormalizzaLotto_Calc(const double lotto, const double volMin,
                            const double volMax, const double volStep,
                            bool &alMinimo)
  {
   alMinimo = false;
   if(volStep <= 0 || volMin <= 0) return(0.0);
   if(lotto <= 0) return(0.0);
   double n = MathFloor(lotto/volStep)*volStep;
   if(n < volMin){ n = volMin; alMinimo = true; }
   if(volMax > 0 && n > volMax) n = volMax;
   return(n);
  }

//+------------------------------------------------------------------+
//| LA COLONNA 6 DEL CANARINO: percentuale di trade chiusi dal FLAT.   |
//| Denominatore = TUTTE le chiusure viste (flat + cap + mercato).     |
//| Denominatore 0 -> 0, che si legge "nessuna chiusura", non "0%".    |
//| CRITERIO CONGELATO (par. 4.3): sopra il 40% il round sta           |
//| misurando l'OROLOGIO, non il motore, e va scritto in quei termini. |
//+------------------------------------------------------------------+
double PercentualeFlat_Calc(const double usciteFlat, const double uscitetotali)
  {
   if(uscitetotali <= 0.0) return(0.0);
   return(100.0*usciteFlat/uscitetotali);
  }

//==================================================================
//  RACCOLTA DEI CAMPIONI (memoria, non pensiero)
//  Guardia anti-inf/nan: un valore non finito non entra MAI in un
//  vettore da mediana. Se ci entrasse, ArraySort lo metterebbe in
//  fondo e la mediana verrebbe plausibile e sbagliata.
//==================================================================
void Aggiungi(double &v[], int &n, const double x)
  {
   if(!MathIsValidNumber(x)) return;
   if(n >= LONDONFX_MAX_CAMPIONI){ gTroncato = true; return; }
   if(n >= ArraySize(v))
     {
      int nuovo = (ArraySize(v) <= 0) ? 4096 : ArraySize(v)*2;
      if(nuovo > LONDONFX_MAX_CAMPIONI) nuovo = LONDONFX_MAX_CAMPIONI;
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

double Percentile(const double &v[], const int n, const double p)
  {
   if(n <= 0) return(0.0);
   double c[];
   if(ArrayResize(c, n) != n) return(0.0);
   for(int i = 0; i < n; i++) c[i] = v[i];
   ArraySort(c);
   return(PercentileOrdinato_Calc(c, n, p));
  }

//==================================================================
//  CICLO DI VITA
//==================================================================

//+------------------------------------------------------------------+
//| AZZERAMENTO ESPLICITO DI TUTTI I CONTATORI.                       |
//| In ottimizzazione MT5 rilancia l'EA a ogni passata e le globali    |
//| DOVREBBERO ripartire dai loro valori iniziali. Con un asse di      |
//| ablazione, una passata che ereditasse i campioni della precedente  |
//| darebbe colonne plausibili e sbagliate -- e sarebbe proprio        |
//| l'ablazione a morire, che e' la domanda del round. Azzerare a mano |
//| costa una funzione e toglie il dubbio.                             |
//+------------------------------------------------------------------+
void AzzeraContatori()
  {
   gLastBar = 0;
   gDayOper = -1; gTradesOggi = 0; gTettoContatoOggi = false; gCapColpitoOggi = false;
   gTicket = 0; gTicketNotteContata = 0;
   gSegnaliGenerati = 0; gSoppPosizione = 0; gSoppTetto = 0;
   gGiorniTetto = 0; gGiorniCap = 0;
   gSoppFineSessione = 0; gSoppCap = 0; gSoppSpread = 0; gIngressiFalliti = 0;
   gIngressiTot = 0; gIngressiLong = 0; gIngressiShort = 0;
   gUsciteFlat = 0; gUsciteCap = 0; gUsciteMercato = 0;
   gNottiAttrav = 0; gLottiAlMinimo = 0; gStopAllargato = 0;
   gBarreSessione = 0; gBarreSaltate = 0; gGiorniContati = 0; gStampGiorno = -1;
   gNSpread = 0; gTroncato = false;
   gSommaRischioValuta = 0.0;
   gDayStartEquity = 0.0; gDayMinEquity = 0.0; gWorstDayPct = 0.0; gDayEqStamp = -1;
   gAutotestFalliti = -1; gAutotestBlocchi = 0; gAutotestCasi = 0;
  }

int OnInit()
  {
   AzzeraContatori();

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   //--- LA DEVIATION E' CONTENITORE, NON ASSE (N9): resta 30 punti per
   //    tutte e sei le celle e per tutte e tre le corse della FASE 2.
   //    Chi cerca lo slippage del round guardi InpSlippagePts.
   gTrade.SetDeviationInPoints(30);

   //--- CANCELLI DI CONFIGURAZIONE: rifiutano, non correggono in
   //    silenzio. Un default nascosto e' una misura che dice un'altra
   //    cosa da quella scritta nel file prova.
   if(InpMotore != LONDONFX_MOTORE_CANALE_NUDO &&
      InpMotore != LONDONFX_MOTORE_CANALE_RSI  &&
      InpMotore != LONDONFX_MOTORE_ALLINEA5)
     {
      PrintFormat("ERRORE: InpMotore = %d non esiste. Ammessi: 1 = canale NUDO, 2 = canale + RSI (baseline), 3 = allineamento 5 medie. QUESTA CORSA NON PARTE APPOSTA: una cella con un motore sconosciuto scriverebbe una riga di zeri che qualcuno leggerebbe come un verdetto.", InpMotore);
      return(INIT_FAILED);
     }
   if(InpSmaPeriodo < 1)
     { Print("ERRORE: InpSmaPeriodo deve essere >= 1 (la fonte dice 5)."); return(INIT_FAILED); }
   if(InpRsiPeriodo < 2)
     { Print("ERRORE: InpRsiPeriodo deve essere >= 2 (la fonte dice 5)."); return(INIT_FAILED); }
   if(InpRsiSoglia <= 50.0 || InpRsiSoglia >= 100.0)
     { Print("ERRORE: InpRsiSoglia deve stare fra 50 e 100, estremi esclusi (la fonte dice 80 per il long). Lo short usa 100 - questa = 20: FIRMA F5, opzione A."); return(INIT_FAILED); }
   if(InpSmma1 < 1 || InpSmma2 < 1 || InpSmma3 < 1 || InpSmma4 < 1 || InpEmaLenta < 1)
     { Print("ERRORE: i periodi delle medie del motore 3 devono essere >= 1."); return(INIT_FAILED); }
   if(!(InpSmma1 < InpSmma2 && InpSmma2 < InpSmma3 && InpSmma3 < InpSmma4 && InpSmma4 < InpEmaLenta))
     { Print("ERRORE: i periodi del motore 3 devono essere STRETTAMENTE CRESCENTI (default autore 3 < 6 < 9 < 50 < 200): un allineamento fra medie non ordinate non vuol dire niente."); return(INIT_FAILED); }
   if(InpOraInizioServer < 0 || InpOraInizioServer > 23)
     { Print("ERRORE: InpOraInizioServer deve stare fra 0 e 23, ed e' ORA SERVER BCM (= ora italiana - 1). La firma F2 la congela a 8."); return(INIT_FAILED); }
   if(InpOreSessione < 1 || InpOreSessione > 24)
     { Print("ERRORE: InpOreSessione deve stare fra 1 e 24 (la fonte dice 8, fine esclusa)."); return(INIT_FAILED); }
   if(InpRiskPercent <= 0.0 || InpRiskPercent > 5.0)
     { Print("ERRORE: InpRiskPercent deve stare fra 0 e 5 (la firma F6 dice 0,65 = la taglia di campo)."); return(INIT_FAILED); }
   if(InpSlippagePts < 0 || InpSlippagePts > 100)
     { Print("ERRORE: InpSlippagePts deve stare fra 0 e 100 punti MT5 (R55-bis usa 0 / 2 / 5). Vedi N9: e' un COSTO SIMULATO sulla geometria, non la deviation."); return(INIT_FAILED); }
   if(InpMaxSpread < 0)
     { Print("ERRORE: InpMaxSpread non puo' essere negativo. 0 = filtro SPENTO, ed e' il default del round (lo spread si MISURA)."); return(INIT_FAILED); }
   if(InpPipSize <= 0.0)
     { Print("ERRORE: InpPipSize deve essere > 0. E' 1 pip in PREZZO: 0,0001 su EURUSD/GBPUSD."); return(INIT_FAILED); }

   //--- IL CANCELLO DELL'UNITA' DI MISURA: il pip dichiarato contro il
   //    pip che il simbolo si aspetta. Un fattore 10 qui dentro farebbe
   //    girare uno stop da 80 pip (o da 0,8) e il round misurerebbe un
   //    altro motore. Rifiuta, NON corregge in silenzio, e il rifiuto e'
   //    RUMOROSO (errore di init nel Giornale), non una riga di zeri.
   double punto     = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   int    decimali  = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double pipAtteso = PipAttesoDaDigits_Calc(punto, decimali);
   if(pipAtteso <= 0.0)
     { Print("ERRORE: SYMBOL_POINT nullo: il pip non e' calcolabile e nessun numero di questa corsa varrebbe niente."); return(INIT_FAILED); }
   if(MathAbs(InpPipSize - pipAtteso) > pipAtteso*0.01)
     {
      PrintFormat("ERRORE UNITA' DI MISURA: InpPipSize = %.5f ma %s ha DIGITS = %d e POINT = %.5f, quindi il pip vale %.5f. QUESTA CORSA NON PARTE APPOSTA: con il pip sbagliato la geometria TP 15,0 / SL 8,0 uscirebbe falsata di un fattore. METTERE InpPipSize=%.5f nel file prova per questo simbolo.",
                  InpPipSize, _Symbol, decimali, punto, pipAtteso, pipAtteso);
      return(INIT_FAILED);
     }

   //--- la coda deve bastare a TUTTI i motori (vedi N10): il vincolo
   //    piu' lungo e' l'EMA200 del motore 3, e vale ANCHE per le celle
   //    1 e 2, altrimenti le tre celle non partirebbero lo stesso
   //    giorno e l'ablazione confronterebbe finestre diverse.
   int minimo = InpEmaLenta + InpSmaPeriodo + InpRsiPeriodo + 50;
   if(InpWarmupBarre < minimo)
     {
      PrintFormat("ERRORE: InpWarmupBarre = %d e' troppo corto: con questi periodi ne servono almeno %d perche' TUTTI E TRE i motori possano armare dallo stesso giorno (vedi N10).",
                  InpWarmupBarre, minimo);
      return(INIT_FAILED);
     }
   if(InpWarmupBarre > 5000)
     { Print("ERRORE: InpWarmupBarre sopra 5000 rallenta la corsa senza guadagnare precisione."); return(INIT_FAILED); }

   //--- GLI HANDLE DEL MOTORE 3: creati SEMPRE (vedi lo STATO in testa).
   hSmma1 = iMA(_Symbol, PERIOD_CURRENT, InpSmma1,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma2 = iMA(_Symbol, PERIOD_CURRENT, InpSmma2,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma3 = iMA(_Symbol, PERIOD_CURRENT, InpSmma3,    0, MODE_SMMA, PRICE_CLOSE);
   hSmma4 = iMA(_Symbol, PERIOD_CURRENT, InpSmma4,    0, MODE_SMMA, PRICE_CLOSE);
   hEma   = iMA(_Symbol, PERIOD_CURRENT, InpEmaLenta, 0, MODE_EMA,  PRICE_CLOSE);
   if(hSmma1 == INVALID_HANDLE || hSmma2 == INVALID_HANDLE || hSmma3 == INVALID_HANDLE ||
      hSmma4 == INVALID_HANDLE || hEma   == INVALID_HANDLE)
     {
      Print("ERRORE: handle delle medie del motore 3 non creati. La corsa non parte anche se il motore attivo e' 1 o 2: il banco dev'essere IDENTICO fra le tre celle.");
      return(INIT_FAILED);
     }

   ArrayResize(gSpread, 0);

   if(InpAutoTest) AutoTestLondonFx();

   Log(StringFormat("R116 -- contenitore LondonFx su %s %s. MOTORE %d = %s. Magic %I64d.",
                    _Symbol, EnumToString((ENUM_TIMEFRAMES)Period()), InpMotore, NomeMotore(InpMotore), InpMagic));
   Log(StringFormat("contenitore: sessione %02d:00-%02d:00 ORA SERVER (fine esclusa) | flat NON disattivabile | %d posizione per volta | tetto %d ingressi/giorno | cap perdita %.1f%% dell'equity",
                    InpOraInizioServer, (InpOraInizioServer + InpOreSessione)%24,
                    LONDONFX_MAX_POSIZIONI, LONDONFX_MAX_TRADES_GIORNO, LONDONFX_CAP_GIORNALIERO_PCT));
   Log(StringFormat("geometria della fonte: TP %.1f pip / SL %.1f pip (RR %.3f) su ENTRAMBE le gambe, NON adattata per simbolo | rischio %.2f%% | slippage simulato %d punti | filtro spread %s",
                    LONDONFX_TP_PIP, LONDONFX_SL_PIP, LONDONFX_TP_PIP/LONDONFX_SL_PIP,
                    InpRiskPercent, InpSlippagePts,
                    (InpMaxSpread > 0 ? "ACCESO (fuori standard di round!)" : "SPENTO: lo spread si MISURA")));
   Log("NESSUNA GESTIONE: parziale, breakeven e trailing NON esistono in questo file (vedi N2). Si esce a TP, a SL, dal FLAT di fine sessione o dal cap del 2%.");

   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hSmma1 != INVALID_HANDLE) IndicatorRelease(hSmma1);
   if(hSmma2 != INVALID_HANDLE) IndicatorRelease(hSmma2);
   if(hSmma3 != INVALID_HANDLE) IndicatorRelease(hSmma3);
   if(hSmma4 != INVALID_HANDLE) IndicatorRelease(hSmma4);
   if(hEma   != INVALID_HANDLE) IndicatorRelease(hEma);
  }

string NomeMotore(const int m)
  {
   if(m == LONDONFX_MOTORE_CANALE_NUDO) return("CANALE NUDO (ramo di controllo)");
   if(m == LONDONFX_MOTORE_CANALE_RSI)  return("CANALE + RSI (BASELINE, l'unico promuovibile)");
   if(m == LONDONFX_MOTORE_ALLINEA5)    return("ALLINEAMENTO 5 MEDIE (ramo di controllo)");
   return("SCONOSCIUTO");
  }

//+------------------------------------------------------------------+
//| L'ORDINE DEI GESTI, ED E' L'ORDINE CHE CONTA.                     |
//|  1. l'equity peggiore della giornata (si aggiorna a ogni tick: la |
//|     caduta peggiore succede in mezzo alla sessione, non alla sua  |
//|     chiusura);                                                     |
//|  2. il cambio di giornata SERVER azzera tetto e cap;              |
//|  3. si rileva se la posizione se n'e' andata da sola (stop/take)  |
//|     PRIMA di qualunque altra cosa, altrimenti i contatori delle   |
//|     uscite si sfasano;                                            |
//|  4. il CANARINO DELLA NOTTE si legge PRIMA del flat: dentro la    |
//|     gestione verrebbe saltato proprio a mezzanotte, cioe' nell'   |
//|     unico momento in cui una notte attraversata si puo' vedere,   |
//|     e una colonna che non puo' accendersi non e' un canarino;     |
//|  5. il CAP del 2%: chiude e blocca la giornata;                   |
//|  6. il FLAT: incondizionato, fuori sessione si chiude;            |
//|  7. la contabilita' del segnale, SOLO su barra nuova, in un solo  |
//|     punto (N11), con le soppressioni mutuamente esclusive.        |
//| Nota: il flat NON fa 'return'. La contabilita' del segnale deve   |
//| girare lo stesso, altrimenti la colonna "Segnali Soppressi Fine   |
//| Sessione" (N6) resterebbe 0 per costruzione.                      |
//+------------------------------------------------------------------+
void OnTick()
  {
   AggiornaPeggiorGiornata();

   MqlDateTime tn; TimeToStruct(TimeCurrent(), tn);
   if(tn.day_of_year != gDayOper)
     {
      gDayOper           = tn.day_of_year;
      gTradesOggi        = 0;
      gTettoContatoOggi  = false;
      gCapColpitoOggi    = false;
     }

   RilevaUsciteDiMercato();
   ControllaNotteAttraversata(tn.day_of_year);

   //--- 5. IL CAP DI PERDITA GIORNALIERA (N7).
   if(!gCapColpitoOggi &&
      CapGiornalieroColpito_Calc(gDayStartEquity, AccountInfoDouble(ACCOUNT_EQUITY), LONDONFX_CAP_GIORNALIERO_PCT))
     {
      gCapColpitoOggi = true;
      gGiorniCap++;
      Log(StringFormat("CAP GIORNALIERO del %.1f%% COLPITO: chiusura di tutto e nessun altro ingresso fino a domani (server).",
                       LONDONFX_CAP_GIORNALIERO_PCT));
     }
   if(gCapColpitoOggi) ChiudiTutto(true);

   //--- 6. IL FLAT. Incondizionato: non esiste nessun input che lo
   //    spenga (e' nella fonte, strategy.close_all).
   bool inSessione = SessioneAttiva_Calc(tn.hour, InpOraInizioServer, InpOreSessione);
   if(!inSessione) ChiudiTutto(false);

   //--- 7. il segnale, solo su barra nuova.
   if(!NuovaBarra()) return;
   ContabilizzaBarraChiusa(inSessione);
  }

bool NuovaBarra()
  {
   datetime t = iTime(_Symbol, PERIOD_CURRENT, 0);
   if(t == 0) return(false);
   if(t != gLastBar){ gLastBar = t; return(true); }
   return(false);
  }

//+------------------------------------------------------------------+
//| La peggior giornata in % di equity (numero NEGATIVO). E' IL numero |
//| del cancello A5 e del muro prop giornaliero. Registra anche        |
//| l'equity di inizio giornata, che e' il riferimento del cap (N7).   |
//+------------------------------------------------------------------+
void AggiornaPeggiorGiornata()
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(), t);
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(t.day_of_year != gDayEqStamp)
     {
      gDayEqStamp     = t.day_of_year;
      gDayStartEquity = eq;
      gDayMinEquity   = eq;
     }
   if(eq < gDayMinEquity) gDayMinEquity = eq;
   if(gDayStartEquity > 0)
     {
      double pct = (gDayMinEquity - gDayStartEquity)/gDayStartEquity*100.0;
      if(pct < gWorstDayPct) gWorstDayPct = pct;
     }
  }

//+------------------------------------------------------------------+
//| USCITE DI MERCATO: la posizione che seguivamo non c'e' piu' e non  |
//| l'abbiamo chiusa noi -> stop o take. Si rileva al primo tick       |
//| successivo. Se il ticket in memoria e' 0, si prova ad ADOTTARE una |
//| posizione orfana (riavvio del terminale): meglio gestita da noi    |
//| che abbandonata a se stessa.                                       |
//+------------------------------------------------------------------+
void RilevaUsciteDiMercato()
  {
   if(gTicket != 0)
     {
      if(!PositionSelectByTicket(gTicket))
        {
         gUsciteMercato++;
         gTicket = 0;
        }
      return;
     }
   ulong orfana = TrovaPosizioneMia();
   if(orfana != 0)
     {
      gTicket = orfana;
      Log("posizione orfana adottata (riavvio?): resta sotto il flat e sotto il cap come tutte le altre.");
     }
  }

//+------------------------------------------------------------------+
//| IL CANARINO DEL FLAT. Una posizione di questo magic ancora viva in |
//| una giornata server diversa da quella in cui e' stata aperta vuol  |
//| dire che il flat NON e' stato ermetico: il simbolo non ha mandato  |
//| tick in tempo, e abbiamo dormito in posizione. La colonna "Notti   |
//| Attraversate" DEVE essere ZERO. Se non lo e', si dichiara e non si |
//| interpreta. Ogni posizione conta UNA volta sola (chiave: ticket).  |
//| ITERAZIONE HEDGE-SAFE (N1): simbolo + magic, mai PositionSelect.   |
//+------------------------------------------------------------------+
void ControllaNotteAttraversata(const int giornoOggi)
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL)  != _Symbol)  continue;
      if(PositionGetInteger(POSITION_MAGIC)  != InpMagic) continue;
      if(tk == gTicketNotteContata) continue;
      MqlDateTime tApe; TimeToStruct((datetime)PositionGetInteger(POSITION_TIME), tApe);
      if(tApe.day_of_year != giornoOggi)
        {
         gNottiAttrav++;
         gTicketNotteContata = tk;
         Log("ATTENZIONE: posizione ancora viva al cambio di giornata del server. Il flat non ha trovato tick in tempo.");
        }
     }
  }

//==================================================================
//  LA CHIUSURA -- chiude TUTTE le posizioni di questo magic su questo
//  simbolo, anche quelle di cui non abbiamo il ticket in memoria
//  (riavvio, chiusura fallita, ticket perso). Non chiede permesso a
//  nessuno stato interno. Se una chiusura fallisce non si registra
//  niente e si ritenta al tick dopo; se dovesse fallire fino al
//  cambio giorno, la colonna "Notti Attraversate" lo dice.
//  SCRITTURA HEDGE-SAFE (N1): PositionClose(TICKET), mai per simbolo.
//==================================================================
void ChiudiTutto(const bool perCap)
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(gTrade.PositionClose(tk))
        {
         if(perCap) gUsciteCap++; else gUsciteFlat++;
         if(tk == gTicket) gTicket = 0;
        }
      else
         Log(StringFormat("CHIUSURA NON riuscita sul ticket %I64u (retcode %d): ritento al tick successivo.",
                          tk, gTrade.ResultRetcode()));
     }
  }

//==================================================================
//  LA CONTABILITA' DEL SEGNALE -- UN SOLO PUNTO IN TUTTO IL FILE.
//  Qui nascono le colonne del canarino, e qui vale la regola N11:
//  un segnale conta in UNA sola casella, le soppressioni sono
//  MUTUAMENTE ESCLUSIVE e valutate nell'ordine dichiarato.
//  IDENTITA' RICONTABILE A MANO DAL CSV:
//    Segnali Generati = Ingressi Totali
//                     + Soppressi Fine Sessione
//                     + Soppressi Posizione Aperta
//                     + Soppressi Tetto Giorno
//                     + Soppressi Cap
//                     + Soppressi Spread
//                     + Ingressi Falliti
//  Se quella somma non torna, il canarino e' rotto e le colonne non
//  si leggono. E' un gate, non un ornamento.
//==================================================================
void ContabilizzaBarraChiusa(const bool inSessioneOra)
  {
   datetime tBarra = 0;
   int      seg    = SegnaleBarraChiusa(tBarra);
   if(tBarra == 0) return;

   MqlDateTime tb; TimeToStruct(tBarra, tb);

   //--- LA BARRA DI SEGNALE DEVE STARE DENTRO LA SESSIONE. Fuori non
   //    e' un segnale del round: e' un'occasione di un altro orario, e
   //    il Pine non la vedrebbe nemmeno (la condizione contiene
   //    timeinrange).
   if(!SessioneAttiva_Calc(tb.hour, InpOraInizioServer, InpOreSessione)) return;

   //--- la giornata di borsa (denominatore dei conteggi): si contano i
   //    giorni con almeno una barra di SESSIONE valutata, non i giorni
   //    di calendario. Un festivo senza barre non e' un giorno in cui
   //    il motore "non ha trovato segnali": e' un giorno di mercato
   //    chiuso, e dividere per quello sbaglierebbe contro il candidato.
   gBarreSessione++;
   int stamp = tb.year*1000 + tb.day_of_year;
   if(stamp != gStampGiorno){ gStampGiorno = stamp; gGiorniContati++; }

   if(seg == 0) return;

   //--- N12: da qui in poi e' un SEGNALE del motore attivo.
   gSegnaliGenerati++;

   //--- 1) l'ingresso cadrebbe FUORI dalla sessione (N6).
   if(!inSessioneOra){ gSoppFineSessione++; return; }

   //--- 2) posizione gia' aperta (pyramiding 1 della fonte).
   if(ContaPosizioniMie() >= LONDONFX_MAX_POSIZIONI){ gSoppPosizione++; return; }

   //--- 3) tetto ingressi del giorno (6 della fonte, per TUTTI E TRE i
   //    motori: contenitore identico batte fedelta' del ramo di
   //    controllo, ed e' dichiarato nei criteri).
   if(TettoColpito_Calc(gTradesOggi, LONDONFX_MAX_TRADES_GIORNO))
     {
      gSoppTetto++;
      if(!gTettoContatoOggi){ gGiorniTetto++; gTettoContatoOggi = true; }
      return;
     }

   //--- 4) cap di perdita giornaliera gia' colpito (N7).
   if(gCapColpitoOggi){ gSoppCap++; return; }

   //--- 5) filtro di spread: di norma SPENTO (N8).
   double spreadPunti = (double)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   if(SpreadFuoriLimite_Calc(spreadPunti, (double)InpMaxSpread)){ gSoppSpread++; return; }

   Apri(seg > 0);
  }

//+------------------------------------------------------------------+
//| IL SEGNALE SULLA BARRA CHIUSA (shift 1). Restituisce +1/-1/0 e     |
//| l'ora della barra. Nessuna decisione tocca la barra in formazione: |
//| niente repaint, per costruzione (il Pine e' senza                  |
//| calc_on_every_tick, quindi valuta a barra chiusa: qui idem).       |
//| Gli indicatori dei motori 1-2 si ricalcolano con le funzioni PURE  |
//| su una coda di InpWarmupBarre barre -- e' piu' lento di uno stato  |
//| incrementale, ma e' l'unica forma che l'AUTOTEST puo' interrogare  |
//| a tavolino. L'errore del seme corto e' calcolabile e trascurabile: |
//| la Wilder dell'RSI(5) dimentica il seme con (4/5)^N e la SMA(5)    |
//| non ha memoria oltre 5 barre.                                      |
//| Le medie del motore 3 si leggono dagli handle allo shift 1.        |
//| Se manca UN SOLO dato si risponde 0: non si tira a indovinare con  |
//| una media non ancora pronta (N10).                                 |
//+------------------------------------------------------------------+
int SegnaleBarraChiusa(datetime &tBarra)
  {
   tBarra = iTime(_Symbol, PERIOD_CURRENT, 1);
   if(tBarra == 0){ gBarreSaltate++; return(0); }

   int n = InpWarmupBarre;
   double high[], low[], close[];
   ArraySetAsSeries(high,  false);
   ArraySetAsSeries(low,   false);
   ArraySetAsSeries(close, false);

   //--- si copiano n barre che FINISCONO sull'ultima CHIUSA: l'indice
   //    n-1 e' la barra di segnale.
   if(CopyHigh (_Symbol, PERIOD_CURRENT, 1, n, high)  != n ||
      CopyLow  (_Symbol, PERIOD_CURRENT, 1, n, low)   != n ||
      CopyClose(_Symbol, PERIOD_CURRENT, 1, n, close) != n)
     { gBarreSaltate++; return(0); }

   double rsi[], smaHigh[], smaLow[];
   if(!RsiWilderSerie_Calc(close, n, InpRsiPeriodo, rsi)) { gBarreSaltate++; return(0); }
   if(!SmaSerie_Calc(high, n, InpSmaPeriodo, smaHigh))    { gBarreSaltate++; return(0); }
   if(!SmaSerie_Calc(low,  n, InpSmaPeriodo, smaLow))     { gBarreSaltate++; return(0); }

   int    i        = n - 1;
   double chiusura = close[i];
   double sHigh    = smaHigh[i];
   double sLow     = smaLow[i];
   double rsiv     = rsi[i];
   if(!MathIsValidNumber(chiusura) || !MathIsValidNumber(sHigh) || !MathIsValidNumber(sLow) ||
      chiusura <= 0.0 || sHigh <= 0.0 || sLow <= 0.0)
     { gBarreSaltate++; return(0); }

   //--- le cinque medie del motore 3. Si leggono SEMPRE (banco
   //    identico): se non sono pronte valgono 0 e il motore 3 non arma,
   //    mentre i motori 1-2 non le guardano nemmeno.
   double m1 = ValMedia(hSmma1, 1);
   double m2 = ValMedia(hSmma2, 1);
   double m3 = ValMedia(hSmma3, 1);
   double m4 = ValMedia(hSmma4, 1);
   double em = ValMedia(hEma,   1);

   return(MotoreSegnale_Calc(InpMotore, chiusura, sHigh, sLow, rsiv, InpRsiSoglia,
                             m1, m2, m3, m4, em));
  }

//==================================================================
//  L'APERTURA -- geometria fissa della fonte, rischio 0,65%,
//  spread MISURATO nel momento esatto dell'ordine.
//==================================================================
void Apri(const bool isLong)
  {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0 || ask < bid){ gIngressiFalliti++; return; }

   double punto = SymbolInfoDouble(_Symbol, SYMBOL_POINT);

   //--- LA GEOMETRIA, col costo simulato di slippage (N9).
   double distSL = DistSlConSlippage_Calc(LONDONFX_SL_PIP, InpPipSize, InpSlippagePts, punto);
   double distTP = DistTpConSlippage_Calc(LONDONFX_TP_PIP, InpPipSize, InpSlippagePts, punto);
   if(distSL <= 0.0 || distTP <= 0.0){ gIngressiFalliti++; return; }

   //--- rispetto ESPLICITO di SYMBOL_TRADE_STOPS_LEVEL: un ordine
   //    rifiutato dal broker non e' un dato, e' un buco nel campione.
   //    Se il broker impone una distanza piu' larga, la geometria della
   //    fonte NON e' piu' quella -- e allora si CONTA, in colonna
   //    ("Stop Allargato"): un numero diverso da 0 li' vuol dire che la
   //    cella non ha girato la geometria dichiarata, e va scritto nel
   //    referto. Su forex major questo numero e' atteso 0.
   double minStop = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)*punto;
   bool   allargato = false;
   if(minStop > 0.0)
     {
      if(distSL < minStop){ distSL = minStop; allargato = true; }
      if(distTP < minStop){ distTP = minStop; allargato = true; }
     }

   double entry = isLong ? ask : bid;
   double sl    = NormalizzaPrezzo(isLong ? entry - distSL : entry + distSL);
   double tp    = NormalizzaPrezzo(isLong ? entry + distTP : entry - distTP);

   //--- IL LOTTO. Il rischio in euro sta su 0,65% del SALDO, misurato
   //    sulla distanza DAVVERO piazzata (con lo slippage dentro: N9).
   double perditaLotto = PerditaPerLotto(distSL);
   bool   alMinimo     = false;
   double lotto        = NormalizzaLotto_Calc(
                            LottoGrezzo_Calc(AccountInfoDouble(ACCOUNT_BALANCE), InpRiskPercent, perditaLotto),
                            SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN),
                            SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX),
                            SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP),
                            alMinimo);
   if(lotto <= 0.0)
     {
      gIngressiFalliti++;
      Log("lotto non calcolabile (perdita per lotto nulla?): nessun ordine.");
      return;
     }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI
   //    ingressi. La chiamata sta QUI, immediatamente prima dell'invio.
   //    Nel tester e' un no-op (le sue GlobalVariable non esistono).
   //    NOTA DI ROUND: con 1 posizione per volta a 0,65%, il cap C1 di
   //    3,25% non morde mai. Se questa riga fermasse un ingresso in
   //    backtest, il banco e' sporco.
   if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_LondonFx")) return;

   bool ok = isLong ? gTrade.Buy (lotto, _Symbol, 0.0, sl, tp, InpComment)
                    : gTrade.Sell(lotto, _Symbol, 0.0, sl, tp, InpComment);
   if(!ok)
     {
      gIngressiFalliti++;
      Log(StringFormat("ordine NON eseguito (retcode %d, lotto %.2f).", gTrade.ResultRetcode(), lotto));
      return;
     }

   //--- LA MISURA DELLO SPREAD (firma F9, N8): si registra QUI, nel
   //    momento esatto dell'operazione, in PIP. E' il numero che manca
   //    a tutta la casa, e questo round lo produce anche se boccia
   //    tutto il resto.
   double spreadPip = Pip_Calc(ask - bid, InpPipSize);
   if(spreadPip >= 0.0) Aggiungi(gSpread, gNSpread, spreadPip);

   gTicket = TrovaPosizioneMia();
   if(gTicket == 0)
      Log("ordine eseguito ma posizione non trovata: verra' adottata al tick successivo.");

   gTradesOggi++;
   gIngressiTot++;
   if(isLong) gIngressiLong++; else gIngressiShort++;
   if(alMinimo) gLottiAlMinimo++;
   if(allargato) gStopAllargato++;
   gSommaRischioValuta += lotto*perditaLotto;

   Log(StringFormat("%s a %.5f | SL %.5f (%.1f pip) | TP %.5f (%.1f pip) | lotto %.2f | spread %.2f pip | %d/%d di oggi",
                    (isLong ? "LONG" : "SHORT"), entry, sl, Pip_Calc(distSL, InpPipSize),
                    tp, Pip_Calc(distTP, InpPipSize), lotto, spreadPip,
                    gTradesOggi, LONDONFX_MAX_TRADES_GIORNO));
  }

//==================================================================
//  LETTURE DAL TERMINALE (il pensiero sta nel nucleo puro)
//==================================================================
double ValMedia(const int handle, const int shift)
  {
   if(handle == INVALID_HANDLE) return(0.0);
   double b[1];
   if(CopyBuffer(handle, 0, shift, 1, b) != 1) return(0.0);
   if(!MathIsValidNumber(b[0])) return(0.0);
   return(b[0]);
  }

double NormalizzaPrezzo(const double prezzo)
  {
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   int    dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   if(ts <= 0) return(NormalizeDouble(prezzo, dg));
   return(NormalizeDouble(MathRound(prezzo/ts)*ts, dg));
  }

//+------------------------------------------------------------------+
//| PERDITA IN VALUTA CONTO DI UN LOTTO SE LO STOP VIENE PRESO.        |
//| Si chiede al broker (OrderCalcProfit), non al tick value nudo: su  |
//| alcuni simboli il tick value arriva non convertito e il lotto      |
//| uscirebbe ~0, finendo SEMPRE al minimo (lezione dell'08/08 su      |
//| 225JPY). Il tick value resta come ripiego.                         |
//+------------------------------------------------------------------+
double PerditaPerLotto(const double slDist)
  {
   if(slDist <= 0) return(0.0);
   double px   = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double prof = 0.0;
   if(px > slDist && OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, px, px-slDist, prof) && prof < 0)
      return(-prof);
   double tv  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tsz = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || tsz <= 0) return(0.0);
   return((slDist/tsz)*tv);
  }

//+------------------------------------------------------------------+
//| CONTEGGIO E RICERCA DELLE POSIZIONI -- HEDGE-SAFE (N1).            |
//| Si itera PositionsTotal() con PositionGetTicket(i) e si filtra     |
//| SIMBOLO e MAGIC. In tutto questo file non esiste nessuna chiamata  |
//| PositionSelect(_Symbol), ne' nessuna PositionClose/PositionModify  |
//| per simbolo: e' il difetto censito il 03/09 su 34 file di flotta,  |
//| e qui non deve poter nascere.                                      |
//+------------------------------------------------------------------+
int ContaPosizioniMie()
  {
   int n = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      n++;
     }
   return(n);
  }

ulong TrovaPosizioneMia()
  {
   for(int i = PositionsTotal()-1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol)  continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      return(tk);
     }
   return(0);
  }

//==================================================================
//  AUTOTEST DEL NUCLEO PURO
//  Gira in OnInit. NON stampa un verdetto che nessuno legge: il
//  numero di blocchi falliti finisce nelle COLONNE "Autotest
//  Falliti" / "Autotest Blocchi" / "Autotest Casi" (in ottimizzazione
//  MT5 non esegue le Print degli agent).
//  REGOLA DI SCRITTURA: ogni blocco usa nomi di variabile con il
//  PROPRIO PREFISSO (b1_, b2_, ...). In MQL5 due dichiarazioni dello
//  stesso nome nello stesso scope sono un errore secco di
//  compilazione, e nessuna rilettura distratta lo vede.
//  DUE CONTATORI E NON UNO: blocchi e CASI. Un blocco cancellato per
//  sbaglio non deve poter passare per "tutto verde", e nemmeno un
//  blocco SVUOTATO delle sue asserzioni -- che il conteggio dei soli
//  blocchi non vedrebbe.
//  E I BORDI SONO ESATTI: le fasce che questo EA calcola in proprio
//  (cap 2%, tetto 6, sessione 8-16, soglia RSI 20 dello short,
//  uguaglianza stretta sul canale) sono esercitate SUL BORDO, non
//  vicino al bordo. Un gate che ricopia le SOGLIE senza ricopiare le
//  DISUGUAGLIANZE e' come non averlo (lezione della CHECKLIST 31/08).
//==================================================================
void AutoTestLondonFx()
  {
   int falliti = 0;
   int blocchi = 0;
   int casi    = 0;

   //--- BLOCCO 1: il caso degenere dell'RSI (convenzione di RSI.mq5).
   blocchi++; casi += 4;
   double b1_su = RsiDaMedie_Calc(1.0, 0.0);    // solo guadagni -> 100
   double b1_pi = RsiDaMedie_Calc(0.0, 0.0);    // mercato piatto -> 50
   double b1_eq = RsiDaMedie_Calc(1.0, 1.0);    // rs = 1 -> 50
   double b1_gi = RsiDaMedie_Calc(0.0, 1.0);    // solo perdite -> 0
   if(MathAbs(b1_su-100.0)>0.0001 || MathAbs(b1_pi-50.0)>0.0001 ||
      MathAbs(b1_eq- 50.0)>0.0001 || MathAbs(b1_gi- 0.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 1 RsiDaMedie_Calc (casi degeneri) DIVERGE"); }

   //--- BLOCCO 2: RSI di Wilder, due casi calcolati A MANO.
   //    periodo 2 su [10,11,12,11]: delta +1,+1,-1.
   //      seme  -> guadagni 1,0  perdite 0,0 -> perdite nulle -> 100
   //      passo -> guadagni 0,5  perdite 0,5 -> rs 1 -> 50
   //    periodo 3 su [10,11,10,11,12]: delta +1,-1,+1,+1.
   //      seme  -> 2/3 e 1/3 -> rs 2   -> 66,6667
   //      passo -> 7/9 e 2/9 -> rs 3,5 -> 77,7778
   blocchi++; casi += 8;
   double b2_c1[]; ArrayResize(b2_c1, 4);
   b2_c1[0]=10.0; b2_c1[1]=11.0; b2_c1[2]=12.0; b2_c1[3]=11.0;
   double b2_r1[];
   bool   b2_ok1 = RsiWilderSerie_Calc(b2_c1, 4, 2, b2_r1);
   double b2_c2[]; ArrayResize(b2_c2, 5);
   b2_c2[0]=10.0; b2_c2[1]=11.0; b2_c2[2]=10.0; b2_c2[3]=11.0; b2_c2[4]=12.0;
   double b2_r2[];
   bool   b2_ok2 = RsiWilderSerie_Calc(b2_c2, 5, 3, b2_r2);
   double b2_r3[];
   bool   b2_ko  = RsiWilderSerie_Calc(b2_c1, 2, 6, b2_r3);   // serie piu' corta del periodo -> falso
   if(!b2_ok1 || !b2_ok2 || b2_ko ||
      MathAbs(b2_r1[2] - 100.0)     > 0.0001 ||
      MathAbs(b2_r1[3] -  50.0)     > 0.0001 ||
      MathAbs(b2_r2[3] -  66.66667) > 0.001  ||
      MathAbs(b2_r2[4] -  77.77778) > 0.001  ||
      b2_r2[2] > -0.5)                                   // prima del seme deve valere -1
     { falliti++; Log("[AUTOTEST] 2 RsiWilderSerie_Calc DIVERGE"); }

   //--- BLOCCO 3: SMA. periodo 3 su [1,2,3,4,5]: 2, 3, 4.
   blocchi++; casi += 8;
   double b3_s[]; ArrayResize(b3_s, 5);
   b3_s[0]=1.0; b3_s[1]=2.0; b3_s[2]=3.0; b3_s[3]=4.0; b3_s[4]=5.0;
   double b3_m[];
   bool   b3_ok  = SmaSerie_Calc(b3_s, 5, 3, b3_m);
   double b3_u[];
   bool   b3_ok1 = SmaSerie_Calc(b3_s, 5, 1, b3_u);
   double b3_v[];
   bool   b3_ko  = SmaSerie_Calc(b3_s, 2, 5, b3_v);
   if(!b3_ok || !b3_ok1 || b3_ko ||
      MathAbs(b3_m[2]-2.0)>0.0001 || MathAbs(b3_m[3]-3.0)>0.0001 || MathAbs(b3_m[4]-4.0)>0.0001 ||
      MathAbs(b3_u[0]-1.0)>0.0001 || MathAbs(b3_u[4]-5.0)>0.0001)
     { falliti++; Log("[AUTOTEST] 3 SmaSerie_Calc DIVERGE"); }

   //--- BLOCCO 4: il canale (Pine righe 25-26), BORDI COMPRESI.
   //    I confronti sono STRETTI: una chiusura ESATTAMENTE sulla media
   //    NON e' una rottura.
   blocchi++; casi += 6;
   bool b4_l1 = CanaleLong_Calc (11.0, 10.0, 9.0);   // sopra tutto       -> si
   bool b4_l2 = CanaleLong_Calc (10.0, 10.0, 9.0);   // ESATTAMENTE sopra -> NO
   bool b4_l3 = CanaleLong_Calc ( 9.5, 10.0, 9.0);   // dentro il canale  -> no
   bool b4_s1 = CanaleShort_Calc( 8.0, 10.0, 9.0);   // sotto tutto       -> si
   bool b4_s2 = CanaleShort_Calc( 9.0, 10.0, 9.0);   // ESATTAMENTE sotto -> NO
   bool b4_s3 = CanaleShort_Calc( 9.5, 10.0, 9.0);   // dentro il canale  -> no
   if(!(b4_l1 && !b4_l2 && !b4_l3 && b4_s1 && !b4_s2 && !b4_s3))
     { falliti++; Log("[AUTOTEST] 4 CanaleLong_Calc/CanaleShort_Calc DIVERGONO"); }

   //--- BLOCCO 5: LA CONFERMA RSI SIMMETRIZZATA -- E' LA FIRMA F5,
   //    OPZIONE A, ESEGUITA SUL BORDO. Long > 80 stretto, short < 20
   //    stretto: 80,0 e 20,0 esatti NON armano. Se questo blocco
   //    passasse con >= al posto di >, la cella girerebbe una soglia
   //    diversa da quella firmata e nessuno se ne accorgerebbe.
   blocchi++; casi += 9;
   bool b5_off1 = FiltroRsi_Calc(false, true,  50.0, 80.0);   // spento -> vero
   bool b5_off2 = FiltroRsi_Calc(false, false, -1.0, 80.0);   // spento -> vero anche con RSI non definito
   bool b5_lsi  = FiltroRsi_Calc(true,  true,  81.0, 80.0);   // long: sopra soglia   -> si
   bool b5_lbo  = FiltroRsi_Calc(true,  true,  80.0, 80.0);   // long: BORDO ESATTO   -> no
   bool b5_lno  = FiltroRsi_Calc(true,  true,  79.0, 80.0);   // long: sotto          -> no
   bool b5_ssi  = FiltroRsi_Calc(true,  false, 19.0, 80.0);   // short: sotto 20      -> si
   bool b5_sbo  = FiltroRsi_Calc(true,  false, 20.0, 80.0);   // short: BORDO ESATTO  -> no
   bool b5_sno  = FiltroRsi_Calc(true,  false, 21.0, 80.0);   // short: sopra         -> no
   bool b5_nd   = FiltroRsi_Calc(true,  true,  -1.0, 80.0);   // RSI non definito     -> no
   if(!(b5_off1 && b5_off2 && b5_lsi && !b5_lbo && !b5_lno &&
        b5_ssi && !b5_sbo && !b5_sno && !b5_nd))
     { falliti++; Log("[AUTOTEST] 5 FiltroRsi_Calc DIVERGE: la soglia short SIMMETRICA a 20 (firma F5, opzione A) non e' quella che gira"); }

   //--- BLOCCO 6: il MOTORE 3 (allineamento 5 medie), long e short.
   //    Compreso il pareggio fra due medie: l'ordine e' STRETTO.
   blocchi++; casi += 8;
   bool b6_l1 = AllineaLong_Calc (1.1010, 1.1005, 1.1004, 1.1003, 1.1002, 1.1001);  // ordine giusto -> si
   bool b6_l2 = AllineaLong_Calc (1.1010, 1.1005, 1.1004, 1.1003, 1.1001, 1.1002);  // 50 sotto la 200 -> no
   bool b6_l3 = AllineaLong_Calc (1.1000, 1.1005, 1.1004, 1.1003, 1.1002, 1.1001);  // prezzo sotto -> no
   bool b6_l4 = AllineaLong_Calc (1.1010, 0.0,    1.1004, 1.1003, 1.1002, 1.1001);  // dato mancante -> no
   bool b6_s1 = AllineaShort_Calc(1.0990, 1.0995, 1.0996, 1.0997, 1.0998, 1.0999);  // specchio -> si
   bool b6_s2 = AllineaShort_Calc(1.0990, 1.0995, 1.0996, 1.0997, 1.0999, 1.0998);  // fuori ordine -> no
   bool b6_s3 = AllineaShort_Calc(1.1000, 1.0995, 1.0996, 1.0997, 1.0998, 1.0999);  // prezzo sopra -> no
   bool b6_s4 = AllineaShort_Calc(1.0990, 1.0995, 1.0995, 1.0997, 1.0998, 1.0999);  // pareggio -> no
   if(!(b6_l1 && !b6_l2 && !b6_l3 && !b6_l4 && b6_s1 && !b6_s2 && !b6_s3 && !b6_s4))
     { falliti++; Log("[AUTOTEST] 6 AllineaLong_Calc/AllineaShort_Calc DIVERGONO"); }

   //--- BLOCCO 7: L'INTERRUTTORE DELL'ABLAZIONE.
   //    E' il blocco che vale il round: con GLI STESSI IDENTICI
   //    INGREDIENTI i tre motori devono rispondere in modo diverso, e
   //    ciascuno deve IGNORARE cio' che non e' suo.
   //      - dati canale: chiusura 11,0 sopra sma(high) 10,0 e sma(low) 9,0
   //      - RSI 50: NON conferma il long (serve > 80)
   //      - medie del motore 3 impilate LONG anche se la chiusura sta
   //        sotto il canale: cosi' si vede che il motore 3 non guarda
   //        il canale e i motori 1-2 non guardano le medie.
   blocchi++; casi += 9;
   int b7_1a = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_NUDO, 11.0, 10.0, 9.0, 50.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        // +1: l'RSI non conta
   int b7_2a = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_RSI,  11.0, 10.0, 9.0, 50.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        //  0: l'RSI non conferma
   int b7_2b = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_RSI,  11.0, 10.0, 9.0, 81.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        // +1: conferma
   int b7_1s = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_NUDO,  8.0, 10.0, 9.0, 50.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        // -1
   int b7_2s = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_RSI,   8.0, 10.0, 9.0, 50.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        //  0
   int b7_2t = MotoreSegnale_Calc(LONDONFX_MOTORE_CANALE_RSI,   8.0, 10.0, 9.0, 19.0, 80.0, 0.0,0.0,0.0,0.0,0.0);        // -1
   int b7_3a = MotoreSegnale_Calc(LONDONFX_MOTORE_ALLINEA5,    11.0, 10.0, 9.0, 81.0, 80.0, 12.0,11.0,10.5,10.2,10.1); //  0: prezzo sotto la veloce
   int b7_3b = MotoreSegnale_Calc(LONDONFX_MOTORE_ALLINEA5,     8.0, 10.0, 9.0, 50.0, 80.0,  7.0, 6.0, 5.0, 4.0, 3.0); // +1: ignora il canale
   int b7_ko = MotoreSegnale_Calc(9, 11.0, 10.0, 9.0, 81.0, 80.0, 7.0,6.0,5.0,4.0,3.0);                        //  0: motore inesistente
   if(!(b7_1a == +1 && b7_2a == 0 && b7_2b == +1 &&
        b7_1s == -1 && b7_2s == 0 && b7_2t == -1 &&
        b7_3a ==  0 && b7_3b == +1 && b7_ko == 0))
     { falliti++; Log("[AUTOTEST] 7 MotoreSegnale_Calc DIVERGE: L'INTERRUTTORE DELL'ABLAZIONE NON E' CABLATO COME DICHIARATO"); }

   //--- BLOCCO 8: la sessione. INIZIO INCLUSO, FINE ESCLUSA, sui bordi
   //    veri del round (8 e 16 ora server), piu' il caso a cavallo
   //    della mezzanotte e gli input impossibili.
   blocchi++; casi += 10;
   bool b8_in = SessioneAttiva_Calc( 8,  8, 8);   // 08:00 BORDO INIZIALE -> dentro
   bool b8_dn = SessioneAttiva_Calc(15,  8, 8);   // 15:00 ultima ora     -> dentro
   bool b8_fu = SessioneAttiva_Calc(16,  8, 8);   // 16:00 FINE ESCLUSA   -> fuori
   bool b8_pr = SessioneAttiva_Calc( 7,  8, 8);   // 07:00 prima          -> fuori
   bool b8_t  = SessioneAttiva_Calc(13,  0, 24);  // 24 ore -> sempre dentro
   bool b8_k1 = SessioneAttiva_Calc(24,  8, 8);   // ora impossibile
   bool b8_k2 = SessioneAttiva_Calc( 8,  8, 0);   // durata impossibile
   bool b8_w1 = SessioneAttiva_Calc(23, 22, 5);   // a cavallo: dentro
   bool b8_w2 = SessioneAttiva_Calc( 2, 22, 5);   // a cavallo: dentro
   bool b8_w3 = SessioneAttiva_Calc( 3, 22, 5);   // a cavallo: fine esclusa -> fuori
   if(!(b8_in && b8_dn && !b8_fu && !b8_pr && b8_t && !b8_k1 && !b8_k2 &&
        b8_w1 && b8_w2 && !b8_w3))
     { falliti++; Log("[AUTOTEST] 8 SessioneAttiva_Calc DIVERGE"); }

   //--- BLOCCO 9: I PIP. I casi di collaudo SONO la geometria della
   //    fonte: 150 tick = 0,00150 = 15,0 pip di take, 80 tick =
   //    0,00080 = 8,0 pip di stop su un feed a 5 decimali.
   blocchi++; casi += 10;
   double b9_tp = Pip_Calc(0.00150, 0.0001);   // 15,0
   double b9_sl = Pip_Calc(0.00080, 0.0001);   //  8,0
   double b9_sp = Pip_Calc(0.00012, 0.0001);   //  1,2 (uno spread tipico)
   double b9_ne = Pip_Calc(-0.0002, 0.0001);   // -2,0 (il segno passa: decide il chiamante)
   double b9_ko = Pip_Calc(0.00150, 0.0);      // non convertibile -> 0
   double b9_e5 = PipAttesoDaDigits_Calc(0.00001, 5);   // EURUSD moderno -> 0,0001
   double b9_e4 = PipAttesoDaDigits_Calc(0.0001,  4);   // EURUSD vecchio -> 0,0001
   double b9_j3 = PipAttesoDaDigits_Calc(0.001,   3);   // USDJPY moderno -> 0,01
   double b9_j2 = PipAttesoDaDigits_Calc(0.01,    2);   // USDJPY vecchio -> 0,01
   double b9_kp = PipAttesoDaDigits_Calc(0.0,     5);   // POINT nullo -> 0
   if(MathAbs(b9_tp-15.0)>0.000001 || MathAbs(b9_sl-8.0)>0.000001 ||
      MathAbs(b9_sp- 1.2)>0.000001 || MathAbs(b9_ne+2.0)>0.000001 ||
      MathAbs(b9_ko)>0.000001 ||
      MathAbs(b9_e5-0.0001)>0.0000001 || MathAbs(b9_e4-0.0001)>0.0000001 ||
      MathAbs(b9_j3-0.01)  >0.0000001 || MathAbs(b9_j2-0.01)  >0.0000001 ||
      MathAbs(b9_kp)       >0.0000001)
     { falliti++; Log("[AUTOTEST] 9 Pip_Calc/PipAttesoDaDigits_Calc DIVERGONO"); }

   //--- BLOCCO 10: LA GEOMETRIA CON IL COSTO SIMULATO DI SLIPPAGE (N9).
   //    A 5 punti (0,50 pip) su feed a 5 decimali: SL 8,0 -> 8,5 pip e
   //    TP 15,0 -> 14,5 pip. E a slippage 0 la geometria deve restare
   //    ESATTAMENTE quella della fonte, altrimenti le celle della FASE
   //    2 non sarebbero confrontabili con la corsa principale.
   blocchi++; casi += 8;
   double b10_sl = DistanzaDaPip_Calc( 8.0, 0.0001);              // 0,00080
   double b10_tp = DistanzaDaPip_Calc(15.0, 0.0001);              // 0,00150
   double b10_ze = DistanzaDaPip_Calc( 0.0, 0.0001);              // guardia -> 0
   double b10_s0 = DistSlConSlippage_Calc( 8.0, 0.0001, 0, 0.00001);  // 0,00080
   double b10_s5 = DistSlConSlippage_Calc( 8.0, 0.0001, 5, 0.00001);  // 0,00085 = 8,5 pip
   double b10_t0 = DistTpConSlippage_Calc(15.0, 0.0001, 0, 0.00001);  // 0,00150
   double b10_t5 = DistTpConSlippage_Calc(15.0, 0.0001, 5, 0.00001);  // 0,00145 = 14,5 pip
   double b10_tx = DistTpConSlippage_Calc(15.0, 0.0001, 200, 0.00001);// mangiato tutto -> residuo 1 punto
   if(MathAbs(b10_sl-0.00080)>0.0000001 || MathAbs(b10_tp-0.00150)>0.0000001 ||
      MathAbs(b10_ze)        >0.0000001 ||
      MathAbs(b10_s0-0.00080)>0.0000001 || MathAbs(b10_s5-0.00085)>0.0000001 ||
      MathAbs(b10_t0-0.00150)>0.0000001 || MathAbs(b10_t5-0.00145)>0.0000001 ||
      MathAbs(b10_tx-0.00001)>0.0000001)
     { falliti++; Log("[AUTOTEST] 10 la geometria TP/SL con slippage DIVERGE"); }

   //--- BLOCCO 11: IL CAP DI PERDITA GIORNALIERA, SUL BORDO ESATTO.
   //    -2,00% E' il cap colpito (clausola piu' severa), -1,99% no.
   blocchi++; casi += 6;
   bool b11_bo = CapGiornalieroColpito_Calc(100000.0, 98000.0, 2.0);   // -2,00% BORDO -> colpito
   bool b11_no = CapGiornalieroColpito_Calc(100000.0, 98010.0, 2.0);   // -1,99% -> no
   bool b11_ol = CapGiornalieroColpito_Calc(100000.0, 97990.0, 2.0);   // -2,01% -> colpito
   bool b11_sp = CapGiornalieroColpito_Calc(100000.0, 90000.0, 0.0);   // cap spento -> mai
   bool b11_k0 = CapGiornalieroColpito_Calc(     0.0, 90000.0, 2.0);   // riferimento assurdo -> no
   bool b11_up = CapGiornalieroColpito_Calc(100000.0,101000.0, 2.0);   // in profitto -> no
   if(!(b11_bo && !b11_no && b11_ol && !b11_sp && !b11_k0 && !b11_up))
     { falliti++; Log("[AUTOTEST] 11 CapGiornalieroColpito_Calc DIVERGE sul BORDO del 2%"); }

   //--- BLOCCO 12: IL TETTO DEL GIORNO, SUL BORDO ESATTO. Con tetto 6
   //    il SESTO ingresso e' ammesso, il SETTIMO no.
   blocchi++; casi += 4;
   bool b12_so = TettoColpito_Calc(5, LONDONFX_MAX_TRADES_GIORNO);   // 5 fatti -> si puo' ancora
   bool b12_bo = TettoColpito_Calc(6, LONDONFX_MAX_TRADES_GIORNO);   // 6 fatti -> BORDO: bloccato
   bool b12_ol = TettoColpito_Calc(7, LONDONFX_MAX_TRADES_GIORNO);   // 7 -> bloccato
   bool b12_sp = TettoColpito_Calc(99, 0);                           // tetto spento -> mai
   if(!(!b12_so && b12_bo && b12_ol && !b12_sp))
     { falliti++; Log("[AUTOTEST] 12 TettoColpito_Calc DIVERGE sul BORDO dei 6 ingressi"); }

   //--- BLOCCO 13: mediana, dispari / pari / vuota.
   blocchi++; casi += 3;
   double b13_d[]; ArrayResize(b13_d, 5);
   b13_d[0]=1.0; b13_d[1]=2.0; b13_d[2]=3.0; b13_d[3]=10.0; b13_d[4]=100.0;
   double b13_m  = MedianaOrdinata_Calc(b13_d, 5);   // 3
   double b13_p[]; ArrayResize(b13_p, 4);
   b13_p[0]=1.0; b13_p[1]=2.0; b13_p[2]=4.0; b13_p[3]=8.0;
   double b13_mp = MedianaOrdinata_Calc(b13_p, 4);   // (2+4)/2 = 3
   double b13_vu = MedianaOrdinata_Calc(b13_d, 0);   // niente dati -> 0
   if(MathAbs(b13_m-3.0)>0.0001 || MathAbs(b13_mp-3.0)>0.0001 || MathAbs(b13_vu)>0.0001)
     { falliti++; Log("[AUTOTEST] 13 MedianaOrdinata_Calc DIVERGE"); }

   //--- BLOCCO 14: IL P95 DELLO SPREAD (colonna 8 del canarino).
   //    Su un vettore 1..100 il P95 deve rispondere 95: e' il valore
   //    che un umano si aspetta e che deve poter ricontare a mano.
   blocchi++; casi += 6;
   double b14_v[]; ArrayResize(b14_v, 100);
   for(int b14_i = 0; b14_i < 100; b14_i++) b14_v[b14_i] = (double)(b14_i+1);
   double b14_95 = PercentileOrdinato_Calc(b14_v, 100, 0.95);   // 95
   double b14_00 = PercentileOrdinato_Calc(b14_v, 100, 0.0);    // il minimo
   double b14_11 = PercentileOrdinato_Calc(b14_v, 100, 1.0);    // il massimo
   double b14_20 = PercentileOrdinato_Calc(b14_v,  20, 0.95);   // ceil(19)-1 = 18 -> 19
   double b14_u1 = PercentileOrdinato_Calc(b14_v,   1, 0.95);   // un solo campione
   double b14_vu = PercentileOrdinato_Calc(b14_v,   0, 0.95);   // nessun campione -> 0
   if(MathAbs(b14_95-95.0)>0.0001 || MathAbs(b14_00- 1.0)>0.0001 ||
      MathAbs(b14_11-100.0)>0.0001 || MathAbs(b14_20-19.0)>0.0001 ||
      MathAbs(b14_u1- 1.0)>0.0001 || MathAbs(b14_vu)>0.0001)
     { falliti++; Log("[AUTOTEST] 14 PercentileOrdinato_Calc DIVERGE: il P95 dello spread non e' ricontabile"); }

   //--- BLOCCO 15: il lotto dal rischio e il suo FLOOR.
   //    650 di rischio con 100 di perdita per lotto -> 6,5 lotti.
   blocchi++; casi += 7;
   double b15_g  = LottoGrezzo_Calc(100000.0, 0.65, 100.0);
   bool   b15_m1 = false;
   double b15_n  = NormalizzaLotto_Calc(b15_g, 0.01, 100.0, 0.01, b15_m1);
   bool   b15_m2 = false;
   double b15_p  = NormalizzaLotto_Calc(0.001, 0.01, 100.0, 0.01, b15_m2);   // sotto il minimo -> floor
   bool   b15_m3 = false;
   double b15_z  = NormalizzaLotto_Calc(0.0,   0.01, 100.0, 0.01, b15_m3);   // niente lotto -> 0
   double b15_bd = LottoGrezzo_Calc(100000.0, 0.65, 0.0);                    // stop nullo -> 0
   if(MathAbs(b15_g - 6.5) > 0.0001 || MathAbs(b15_n - 6.5) > 0.0001 || b15_m1 ||
      MathAbs(b15_p - 0.01) > 0.0001 || !b15_m2 || MathAbs(b15_z) > 0.0001 ||
      MathAbs(b15_bd) > 0.0001)
     { falliti++; Log("[AUTOTEST] 15 LottoGrezzo_Calc/NormalizzaLotto_Calc DIVERGONO"); }

   //--- BLOCCO 16: la colonna 6 del canarino (% chiusi dal FLAT).
   blocchi++; casi += 3;
   double b16_me = PercentualeFlat_Calc(50.0, 100.0);   // 50%
   double b16_tu = PercentualeFlat_Calc(30.0,  30.0);   // 100%
   double b16_vu = PercentualeFlat_Calc( 0.0,   0.0);   // nessuna chiusura -> 0
   if(MathAbs(b16_me-50.0)>0.0001 || MathAbs(b16_tu-100.0)>0.0001 || MathAbs(b16_vu)>0.0001)
     { falliti++; Log("[AUTOTEST] 16 PercentualeFlat_Calc DIVERGE"); }

   //--- BLOCCO 17: il filtro di spread. SPENTO e' il default del round
   //    (lo spread si MISURA): a 0 non deve bloccare NIENTE, nemmeno
   //    uno spread assurdo. E sul bordo, blocca solo SOPRA.
   blocchi++; casi += 3;
   bool b17_sp = SpreadFuoriLimite_Calc(9999.0, 0.0);    // SPENTO -> mai
   bool b17_bo = SpreadFuoriLimite_Calc(  10.0, 10.0);   // BORDO ESATTO -> passa
   bool b17_no = SpreadFuoriLimite_Calc(  11.0, 10.0);   // sopra -> bloccato
   if(!(!b17_sp && !b17_bo && b17_no))
     { falliti++; Log("[AUTOTEST] 17 SpreadFuoriLimite_Calc DIVERGE"); }

   //--- IL CONTROLLO SUL CONTROLLO: blocchi E casi devono essere quelli
   //    attesi. Un gate che non conta quello che ha eseguito non e' un
   //    gate (lezione R95 G4).
   if(blocchi != LONDONFX_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      Log(StringFormat("[AUTOTEST] eseguiti %d blocchi ma ne erano attesi %d: MANCA UN BLOCCO. L'autotest si dichiara FALLITO.",
                       blocchi, LONDONFX_AUTOTEST_BLOCCHI_ATTESI));
     }
   if(casi != LONDONFX_AUTOTEST_CASI_ATTESI)
     {
      falliti++;
      Log(StringFormat("[AUTOTEST] dichiarati %d casi ma ne erano attesi %d: un blocco e' stato SVUOTATO. L'autotest si dichiara FALLITO.",
                       casi, LONDONFX_AUTOTEST_CASI_ATTESI));
     }

   gAutotestFalliti = falliti;
   gAutotestBlocchi = blocchi;
   gAutotestCasi    = casi;
   Log(StringFormat("AUTOTEST: %d blocchi su %d passati, %d casi dichiarati (falliti %d). L'esito VERO esce nelle colonne 'Autotest Falliti' / 'Autotest Blocchi' / 'Autotest Casi': in ottimizzazione questa riga non la legge nessuno.",
                    blocchi - falliti, blocchi, casi, falliti));
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

double OnTester()
  {
   //--- IL CANARINO, PRIMA DI TUTTO IL RESTO (N13).
   double spreadMed = Mediana  (gSpread, gNSpread);
   double spreadP95 = Percentile(gSpread, gNSpread, 0.95);
   double usciteTot = (double)(gUsciteFlat + gUsciteCap + gUsciteMercato);
   double flatPct   = PercentualeFlat_Calc((double)gUsciteFlat, usciteTot);

   //--- L'IDENTITA' DI N11, CALCOLATA DALL'EA E MESSA IN COLONNA: se
   //    non torna, le colonne del canarino non si leggono. Meglio un
   //    1/0 in colonna che una somma che il verificatore deve rifare a
   //    mano su sei celle.
   long   sommaCanarino = gIngressiTot + gSoppFineSessione + gSoppPosizione +
                          gSoppTetto + gSoppCap + gSoppSpread + gIngressiFalliti;
   double canarinoTorna = (sommaCanarino == gSegnaliGenerati) ? 1.0 : 0.0;

   //--- E IN R, e da dove esce il denominatore: NON e' una scalatura
   //    inferita. gSommaRischioValuta e' la somma dei rischi in euro
   //    DICHIARATI ALL'APERTURA (lotto x perdita per lotto sulla
   //    distanza DAVVERO piazzata). Il numeratore e' il payoff medio
   //    del tester. Limite dichiarato: il rischio in euro cresce col
   //    saldo (composizione), quindi questo E in R e' esatto al primo
   //    ordine, non al centesimo. Il cancello A1 (E >= 0,075R) si
   //    legge su questa colonna SAPENDOLO.
   double rischioMedio = (gIngressiTot > 0) ? gSommaRischioValuta/(double)gIngressiTot : 0.0;
   double payoff       = TesterStatistics(STAT_EXPECTED_PAYOFF);
   double eInR         = (rischioMedio > 0.0) ? payoff/rischioMedio : 0.0;

   double punto  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double pipPti = (punto > 0.0) ? InpPipSize/punto : 0.0;

   //--- REFERTO A SCHERMO (corsa singola). In ottimizzazione non lo
   //    legge nessuno: per quello ci sono le colonne qui sotto.
   Print("==============================================================");
   PrintFormat("[LONDONFX] R116 su %s %s | MOTORE %d = %s", _Symbol,
               EnumToString((ENUM_TIMEFRAMES)Period()), InpMotore, NomeMotore(InpMotore));
   PrintFormat("   sessione %02d:00-%02d:00 SERVER (fine esclusa) | TP %.1f / SL %.1f pip | slippage simulato %d pt | rischio %.2f%%",
               InpOraInizioServer, (InpOraInizioServer + InpOreSessione)%24,
               LONDONFX_TP_PIP, LONDONFX_SL_PIP, InpSlippagePts, InpRiskPercent);
   Print("--------------------------------------------------------------");
   Print("   IL CANARINO (si legge PRIMA del conto economico):");
   PrintFormat("   1. Segnali Generati                 : %d", (int)gSegnaliGenerati);
   PrintFormat("   2. Soppressi da POSIZIONE APERTA    : %d", (int)gSoppPosizione);
   PrintFormat("   3. Soppressi dal TETTO del giorno   : %d", (int)gSoppTetto);
   PrintFormat("   4. Giorni col TETTO colpito         : %d su %d giorni contati", (int)gGiorniTetto, (int)gGiorniContati);
   PrintFormat("   5. Giorni fermati dal CAP del %.1f%%  : %d", LONDONFX_CAP_GIORNALIERO_PCT, (int)gGiorniCap);
   PrintFormat("   6. Trade chiusi dal FLAT            : %.2f%%   (sopra il 40%% il round misura l'OROLOGIO, non il motore)", flatPct);
   PrintFormat("   7. Spread MEDIANO all'ingresso      : %.3f pip   (campione %d)", spreadMed, gNSpread);
   PrintFormat("   8. Spread P95 all'ingresso          : %.3f pip   (e' il numero che chiude H12: si archivia ANCHE se il round boccia)", spreadP95);
   PrintFormat("   +  soppressi FINE SESSIONE %d | soppressi CAP %d | soppressi SPREAD %d | ingressi falliti %d",
               (int)gSoppFineSessione, (int)gSoppCap, (int)gSoppSpread, (int)gIngressiFalliti);
   if(canarinoTorna < 0.5)
      PrintFormat("   >>> ALLARME: la somma del canarino NON torna (%d contro %d segnali generati). LE COLONNE NON SI LEGGONO.",
                  (int)sommaCanarino, (int)gSegnaliGenerati);
   if(gGiorniTetto > 0 && gGiorniContati > 0 && (100.0*(double)gGiorniTetto/(double)gGiorniContati) > 20.0)
      Print("   >>> DICHIARAZIONE OBBLIGATORIA: piu' del 20% dei giorni ha colpito il tetto. Questo motore ha girato STROZZATO DAL CONTENITORE: il suo posto nel confronto S1 e' CONTAMINATO e si legge come confronto operativo, non come prova segnale-contro-contenitore.");
   if(flatPct > 40.0)
      Print("   >>> DICHIARAZIONE OBBLIGATORIA: piu' del 40% dei trade e' stato chiuso dal FLAT. Il round sta misurando l'OROLOGIO, non il motore, e va scritto in quei termini.");
   if(gNottiAttrav > 0)
      PrintFormat("   >>> ALLARME: %d notti attraversate. Il flat NON e' stato ermetico e il rischio overnight NON e' quello dichiarato.", (int)gNottiAttrav);
   if(gStopAllargato > 0)
      PrintFormat("   >>> ATTENZIONE: %d ingressi con la geometria ALLARGATA dallo STOPS_LEVEL del broker: quella cella NON ha girato TP 15,0 / SL 8,0.", (int)gStopAllargato);
   if(gTroncato)
      Print("   >>> ATTENZIONE: il campione dello spread ha toccato il tetto di 100.000: mediana e P95 possono essere TRONCATE.");
   Print("--------------------------------------------------------------");
   PrintFormat("   conto economico: profitto %.2f | PF %.3f | payoff %.5f | E in R %.4f (cancello A1: >= %.3f) | DD equity %.2f%% | peggior giornata %.2f%% | trade %d",
               TesterStatistics(STAT_PROFIT), TesterStatistics(STAT_PROFIT_FACTOR), payoff,
               eInR, LONDONFX_E_TARGET_R, TesterStatistics(STAT_EQUITY_DDREL_PERCENT),
               gWorstDayPct, (int)TesterStatistics(STAT_TRADES));
   PrintFormat("   ingressi %d (long %d / short %d) | uscite: flat %d, cap %d, mercato %d | rischio medio dichiarato %.2f in valuta conto",
               (int)gIngressiTot, (int)gIngressiLong, (int)gIngressiShort,
               (int)gUsciteFlat, (int)gUsciteCap, (int)gUsciteMercato, rischioMedio);
   Print("   PROMEMORIA DI ROUND: un solo regime, tick reali dal 2024.07.05. Da qui NON esce una sedia, e i rami di controllo (motore 1 e 3) NON sono promuovibili.");
   Print("==============================================================");

   //--- ATTENZIONE: 'stats', l'header di OnTesterDeinit e il suo
   //    StringFormat SI TOCCANO SEMPRE INSIEME. Una colonna aggiunta a
   //    uno solo dei tre sfasa tutto il CSV e chi legge trova il numero
   //    sbagliato sotto il nome giusto.
   //    CONTEGGIO CONGELATO: 53 valori -> 56 nomi (Pass, Simbolo,
   //    Periodo + 53) -> 56 specificatori -> 56 argomenti.
   //    Margine dichiarato: StringFormat riceve 1 formato + 56
   //    argomenti = 57 parametri, contro il tetto di 64 di MQL5.
   //    AGGIUNGERE PIU' DI SETTE COLONNE QUI OBBLIGA A SPEZZARE LA
   //    RIGA IN DUE StringFormat.
   double stats[53];
   //--- LE OTTO COLONNE OBBLIGATORIE, PRIME (criteri par. 4.3)
   stats[0]  = (double)gSegnaliGenerati;
   stats[1]  = (double)gSoppPosizione;
   stats[2]  = (double)gSoppTetto;
   stats[3]  = (double)gGiorniTetto;
   stats[4]  = (double)gGiorniCap;
   stats[5]  = flatPct;
   stats[6]  = spreadMed;
   stats[7]  = spreadP95;
   //--- POI il conto economico
   stats[8]  = TesterStatistics(STAT_PROFIT);
   stats[9]  = payoff;
   stats[10] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[11] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[12] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[13] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);   // cancello A4
   stats[14] = TesterStatistics(STAT_TRADES);
   stats[15] = gWorstDayPct;                                  // cancello A5
   stats[16] = eInR;                                          // cancello A1
   stats[17] = rischioMedio;                                  // il denominatore di A1, per ricontarlo
   //--- ANATOMIA
   stats[18] = (double)gIngressiTot;
   stats[19] = (double)gIngressiLong;
   stats[20] = (double)gIngressiShort;
   stats[21] = (double)gUsciteFlat;
   stats[22] = (double)gUsciteCap;
   stats[23] = (double)gUsciteMercato;
   stats[24] = (double)gNottiAttrav;      // DEVE essere 0
   stats[25] = (double)gSoppFineSessione;
   stats[26] = (double)gSoppCap;
   stats[27] = (double)gSoppSpread;
   stats[28] = (double)gIngressiFalliti;
   stats[29] = (double)gLottiAlMinimo;
   stats[30] = (double)gStopAllargato;    // != 0 -> la geometria NON e' quella dichiarata
   stats[31] = (double)gBarreSessione;
   stats[32] = (double)gBarreSaltate;
   stats[33] = (double)gGiorniContati;
   stats[34] = (double)gNSpread;
   stats[35] = canarinoTorna;             // 1 = l'identita' di N11 torna; 0 = colonne NON leggibili
   //--- ECO DELLA CONFIGURAZIONE: sono i numeri che l'EA ha DAVVERO
   //    usato, non quello che l'.ini credeva di passargli.
   stats[36] = (double)InpMotore;
   stats[37] = (double)InpOraInizioServer;
   stats[38] = (double)InpOreSessione;
   stats[39] = LONDONFX_TP_PIP;
   stats[40] = LONDONFX_SL_PIP;
   stats[41] = (double)InpSlippagePts;
   stats[42] = InpRiskPercent;
   stats[43] = (double)LONDONFX_MAX_TRADES_GIORNO;
   stats[44] = LONDONFX_CAP_GIORNALIERO_PCT;
   stats[45] = InpRsiSoglia;              // 80 = long
   stats[46] = 100.0 - InpRsiSoglia;      // 20 = short: FIRMA F5, opzione A, in colonna
   stats[47] = InpPipSize;
   stats[48] = pipPti;                    // deve valere 10 su un simbolo a 5 decimali
   //--- COLLAUDO
   stats[49] = (double)InpMaxSpread;
   stats[50] = (double)gAutotestFalliti;  // 0 = tutti passati; >0 DIVERGE; -1 NON eseguito
   stats[51] = (double)gAutotestBlocchi;
   stats[52] = (double)gAutotestCasi;

   //--- MT5 vuole un criterio di ottimizzazione. QUI NON SI SCEGLIE
   //    NIENTE E NESSUNA CELLA VIENE PROMOSSA (criteri par. 5.2:
   //    questo round non ha una griglia, quindi non ha un picco). Si
   //    dichiara il Recovery Factor, come il resto della flotta,
   //    SOLO perche' il tester pretende un numero: ordina le righe,
   //    non promuove nessuno. Leggere "la cella migliore" da questa
   //    colonna e' VIETATO dai criteri firmati.
   double criterion = stats[11];
   FrameAdd(OPTFRAME_NAME, OPTFRAME_ID, criterion, stats);
   return(criterion);
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
         //--- 56 nomi = Pass + Simbolo + Periodo + 53 valori di stats[].
         //    I nomi sono ASCII e SENZA VIRGOLE (il CSV e' separato da
         //    virgole): "Trade Chiusi Dal Flat Pct" e' la colonna 6 dei
         //    criteri ("Trade Chiusi dal FLAT (%)"), "Spread Mediano
         //    Ingresso Pip" la 7, "Spread P95 Ingresso Pip" la 8.
         string head = "Pass,Simbolo,Periodo,Segnali Generati,Segnali Soppressi Posizione Aperta,Segnali Soppressi Tetto Giorno,Giorni Col Tetto Colpito,Giorni Fermati Dal Cap,Trade Chiusi Dal Flat Pct,Spread Mediano Ingresso Pip,Spread P95 Ingresso Pip,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD Pct,Trades,Peggior Giornata Pct,E In R,Rischio Medio Valuta,Ingressi Totali,Ingressi Long,Ingressi Short,Uscite Flat,Uscite Cap,Uscite Mercato,Notti Attraversate,Segnali Soppressi Fine Sessione,Segnali Soppressi Cap,Segnali Soppressi Spread,Ingressi Falliti,Lotti Al Minimo,Stop Allargato,Barre Sessione Valutate,Barre Saltate Dati,Giorni Contati,Spread Campioni,Canarino Torna,Motore,Ora Inizio Server,Ore Sessione,Tp Pip,Sl Pip,Slippage Pts,Risk Pct,Max Trades Giorno,Cap Giornaliero Pct,Rsi Soglia Long,Rsi Soglia Short,Pip Size Prezzo,Pip In Punti Mt5,Max Spread Pts,Autotest Falliti,Autotest Blocchi,Autotest Casi";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      //--- 56 specificatori = 56 argomenti (pass, simbolo, periodo, data[0..52]).
      string row = StringFormat("%d,%s,%s,%.0f,%.0f,%.0f,%.0f,%.0f,%.2f,%.3f,%.3f,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.5f,%.2f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.1f,%.1f,%.0f,%.2f,%.0f,%.1f,%.1f,%.1f,%.5f,%.2f,%.0f,%.0f,%.0f,%.0f",
                                (int)pass, _Symbol, periodo,
                                data[0],  data[1],  data[2],  data[3],  data[4],  data[5],
                                data[6],  data[7],  data[8],  data[9],  data[10], data[11],
                                data[12], data[13], data[14], data[15], data[16], data[17],
                                data[18], data[19], data[20], data[21], data[22], data[23],
                                data[24], data[25], data[26], data[27], data[28], data[29],
                                data[30], data[31], data[32], data[33], data[34], data[35],
                                data[36], data[37], data[38], data[39], data[40], data[41],
                                data[42], data[43], data[44], data[45], data[46], data[47],
                                data[48], data[49], data[50], data[51], data[52]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
