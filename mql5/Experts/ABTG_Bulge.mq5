//+------------------------------------------------------------------+
//|                                                    ABTG_Bulge.mq5 |
//|                                                                   |
//|  BULGE -- mean-reversion su Bollinger "bulge", basket forex, H1.  |
//|                                                                   |
//|  PATERNITA': IL MOTORE E' DI CLAUDIO.                             |
//|  Questo file NON e' una strategia nuova: e' la copia migrata agli |
//|  standard di casa di mql5\Experts\BULGE_MASTER.mq5 v4.00, che a  |
//|  sua volta consolida OTTO versioni del "BULGE MULTI SIGNAL"       |
//|  scritte da Claudio e tradate da lui. BULGE_MASTER.mq5 RESTA al   |
//|  suo posto come originale: qui non si tocca la sua logica.        |
//|                                                                   |
//|  LA STRATEGIA (INVARIATA, riga per riga):                         |
//|    ARANCIO  IN-BULGE meta' bulge      (decisa su barra B+1)       |
//|    BLU      IN-BULGE 2a candela       (conferma su barra B)       |
//|    VIOLA    POST-BULGE                (su barra B)                |
//|    B = Signal_Bar_Offset (v5.20, default 1 = barre CHIUSE).       |
//|    Fino alla v5.10 era 0 fisso, cioe' la barra IN FORMAZIONE:     |
//|    e' il difetto misurato da R92, vedi il punto 13 sotto.         |
//|    SL = ATR x N (default 3)  |  TP = mediana BB, aggiornata       |
//|    a ogni tick (UpdateAllTP).                                     |
//|  Difesa del disegno, dichiarata dal coach e confermata in R91:    |
//|  "ATR x 3 e' difficile che venga toccato, e' fatto apposta" --    |
//|  cioe' alto win rate e perdite grosse ma rare. NON si "aggiusta"  |
//|  il rapporto rischio/rendimento senza una decisione di Claudio.   |
//|                                                                   |
//|  IL BACKTEST DI RIFERIMENTO (di Claudio, agli atti, MISURATO sul  |
//|  suo xlsx -- NON e' nostro e NON e' una promessa):                |
//|    BULGE_MULTI_SIGNAL, GBPUSD H1 + basket GBPJPY/NZDJPY/AUDUSD/   |
//|    CADJPY/NZDCAD, 2022.01.01-2026.03.30, Risk_Percent=3,          |
//|    deposito 10.000, qualita' storico 40% tick reali:              |
//|      netto +10.604,34 | PF 1,599 | 268 trade | 80,22% vinti       |
//|      media vincita +131,63 | media perdita -325,39                |
//|      max vincite consecutive 19 | max perdite consecutive 4       |
//|      DD bilancio 10,17% | DD equity 10,35% | Sharpe 3,675         |
//|      segnali attivi: BLU + VIOLA (ARANCIO spento)                 |
//|    LIMITI DA DICHIARARE SEMPRE ACCANTO A QUEI NUMERI: qualita'    |
//|    dati 40%, rischio 3% (fuori dai nostri cap), NESSUN IS/OOS,    |
//|    un solo periodo continuo, un solo broker.                      |
//+------------------------------------------------------------------+
//  CHANGELOG
//  v4.00  BULGE_MASTER.mq5 -- file di Claudio, resta l'originale.
//  v5.00  21/08/2026 -- ABTG_Bulge: MIGRAZIONE AGLI STANDARD DI CASA.
//         La logica dei segnali, delle bande, dello stop e del TP NON
//         E' STATA TOCCATA. Cosa e' cambiato, tutto qui dentro:
//          1. GUARDIAN (firme B1/C1 del 18/08): #include
//             <ABTG_PausaGuardian.mqh> + input InpUsaGuardian (default
//             true) + ABTG_GuardiaIngresso() chiamata IMMEDIATAMENTE
//             PRIMA di trade.Buy/trade.Sell in OpenOrder -- cioe' sul
//             percorso di APERTURA, non in cima a OnTick. Motivo agli
//             atti (REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md par.
//             1.3): uscire in cima cambierebbe la macchina a stati =
//             cambio di STRATEGIA travestito da regola di rischio.
//             NON e' chiamata sulle chiusure ne' sul parziale: quello
//             sarebbe impedire una presa di profitto.
//             Nel tester le GlobalVariable del Guardian non esistono
//             -> fail-open totale -> i numeri restano confrontabili.
//          2. Magic_Number -> InpMagic (default 772700, blocco libero:
//             verificato nel repo. 772701/772702 compaiono solo come
//             ASSE di sweep in R51, nessuna sedia viva).
//             EA_Comment  -> InpComment (default "BULGE").
//          3. Risk_Percent: default 1.00 [SUPERATO dalla v5.10, che lo
//             porta a 0.80 -- vedi il punto 8] (era 0.50 in BULGE_MASTER;
//             il backtest di Claudio girava a 3,00). E' un ALZAMENTO
//             rispetto al file di partenza e va detto: 1% e' il valore
//             comune di casa che rende confrontabili le celle fra loro,
//             NON una taglia di campo. Il cap totale (Risk_Mode =
//             RISK_TOTAL_CAP + Total_Risk_Percent) e' quello di prima.
//          4. OnTester standard di famiglia + OPTFRAME inlined
//             (CSV OptResults_*.csv per la pipeline) + ExportTrades
//             (per-trade, DD di portafoglio, ROTTA_PROP punto 4) +
//             metrica gWorstDayPct (peggior giornata %, la misura che
//             conta per una prop).
//          5. InpAutoTest (default true): stampa [BULGE][AUTOTEST] in
//             avvio -- casi puri su ExtractSignalTag e i 18 casi del
//             nucleo del Guardian. Si leggono ESEGUENDO, non
//             compilando. Nessun effetto sugli ordini.
//          6. InpVerbose (default true = comportamento identico a
//             prima): spegne le stampe informative nelle corse lunghe.
//             Gli ERRORI si stampano sempre.
//          7. ASCII puro (niente accenti, niente trattini lunghi).
//  v5.10  21/08/2026 -- DOPO LA FIRMA DI R92 ("c,firmo 0,8,misura
//         entrambe", `risultati_archivio\R92_CRITERI.md`) e dopo la
//         TRIANGOLAZIONE col Pine e col Manager MQ4 originali di
//         Claudio, salvati integrali oggi in `docs\breaking_band\`
//         (`risultati_archivio\TRIANGOLAZIONE_BULGE_PINE_2026-08-21.md`).
//         **Il segnale non e' stato scelto: sono state rese misurabili
//         DUE versioni di UNA condizione, e due gestioni.**
//          8. RISCHIO 0,80% (era 1,00 nella v5.00). Non e' un gusto:
//             0,80 x Max_Trades 4 = 3,20% di rischio aperto, SOTTO il
//             cap C1 di 3,25% firmato il 18/08. Con 1,00 erano 4,00%.
//          9. VIOLA, DUE VERSIONI -- input `Use_Purple_PineReaction`
//             (default **false** = comportamento attuale, invariato):
//               false VIOLA-EA   |close0-open0| <= 1,5 x ATR
//               true  VIOLA-PINE close0 > open0 (long) / < (short)
//             La differenza e' MISURATA, non supposta: il Pine di
//             Claudio chiede la candela di reazione VERDE, l'EA l'ha
//             sostituita con "candela non impulsiva" e cosi' apre long
//             anche su candele ROSSE. E' il segnale piu' usato.
//             >>> NESSUNA DELLE DUE E' LA CORREZIONE DELL'ALTRA: sono
//                 due ipotesi, e R92 le misura tutte e due. Chi vince
//                 lo dicono i numeri, non la memoria.
//             Dentro `CheckSignal` cambiano DUE RIGHE e basta: la
//             condizione vive in `PurpleReactionOk()`, fuori.
//         10. GESTIONE (b) -- PORTING del Trade Manager MT4 di Claudio
//             (`EA_BOLL_BULGE_Manager_PRO_MULTI_TF.mq4`): break-even a
//             1R (+2 punti) e trailing a gradini di R (start 1,5R,
//             passo 0,25R). Sette input nuovi, **tutti spenti di
//             default**: `Enable_BE_1R`, `BE_At_R`, `BE_Offset_Points`,
//             `Enable_Trailing_R`, `Trail_Start_R`, `Trail_Step_R`,
//             `Trail_MinMove_Points`. A default spenti il file si
//             comporta come BULGE_MASTER bit per bit.
//             Perche' esiste: quando Claudio operava A MANO i trade
//             erano protetti da BE+trailing; l'EA gira NUDO. Sono due
//             gestioni diverse sullo stesso motore, e la firma dice di
//             misurarle tutte e due ("quanto vale il break-even in
//             euro, invece di opinarlo").
//         11. CORREZIONE DEL DIFETTO EREDITATO DAL MANAGER (dichiarata
//             nella firma): nel MQ4 `InitialRiskPoints()` legge lo SL
//             **CORRENTE**, quindi appena il BE porta lo stop a pari il
//             denominatore va a ~0 e i multipli R esplodono -> il
//             trailing scatta a caso. Qui il rischio si misura sullo
//             **SL INIZIALE per ticket** (array in RAM + GlobalVariable
//             che sopravvive al riavvio, piu' riaggancio in OnInit
//             delle posizioni gia' vive). E' una correzione della
//             GESTIONE, non del segnale.
//         12-bis. PER-TRADE piu' ricco (telemetria, NON trading): il
//             CSV `abtg_trades_*` ora ha la colonna **signal**
//             (BLU/VIOLA/ARANCIO, ripescata dal commento del deal di
//             APERTURA) e il nome del file porta la variante del VIOLA.
//             Serve a rendere MISURABILE il canarino del BLU dai file
//             del round, senza rifare passate a mano: in ottimizzazione
//             MT5 non esegue le Print degli agent, quindi la riga
//             [BULGE-CONTA] nei log delle 88 passate NON c'e'.
//         12. Autotest allargato: le due versioni del VIOLA e la scala
//             del trailing (`TrailLockR`, aritmetica pura: r=1,40 ->
//             fermo, 1,50 -> +0,50R, 2,00 -> +1,00R, 2,60 -> +1,50R).
//
//  v5.20  21/08/2026 -- DECISIONE DI CLAUDIO ("VAI CON BARRA 1"),
//         cioe' la via 1 -- RACCOMANDATA -- del referto R92
//         (`backtest_pipeline\risultati_archivio\R92_REFERTO.md`).
//         UN SOLO input nuovo: `Signal_Bar_Offset` (default 1).
//         13. IL DIFETTO CORRETTO, COI NUMERI CHE LO HANNO MISURATO.
//             R92 non ha bocciato il BULGE per il profitto: si e'
//             fermato sul CAMPIONE (S1 n>=30: **0 simboli su 22**, il
//             massimo assoluto GBPUSD n=11) e nel farlo ha scoperto
//             PERCHE'. `CheckSignal` gira UNA VOLTA per barra, al
//             PRIMO TICK (guardia `g_lastBarTime` in `OnTick`): al
//             primo tick della barra 0 vale **close == open**. Da qui,
//             tre fatti MISURATI, non inferiti:
//               - **VIOLA-PINE: 0 trade su 44 celle su 44.** Non "piu'
//                 selettivo": morto. `close0 > open0` e' sempre falso.
//               - **BLU: 0 per costruzione** sul simbolo del grafico,
//                 cioe' su TUTTO lo scan (una passata = un simbolo).
//                 Il 6 su 115 visto sul basket veniva dai simboli NON
//                 del grafico, dove la barra 0 ha gia' un corpo perche'
//                 l'EA se ne accorge in ritardo: rumore
//                 d'implementazione, non una regola.
//               - **VIOLA-EA: acceso ma con la condizione SVUOTATA.**
//                 `|0| <= 1,5 x ATR` e' sempre vero. Le 106 operazioni
//                 di R92 sono TUTTE VIOLA **con un filtro in meno** --
//                 ed erano comunque **4,8 per simbolo su 4,5 anni**
//                 (~1,07 l'anno contro i ~10,5 dichiarati). E' il
//                 numero che pesa: la frequenza non era bassa
//                 *nonostante* i filtri, era bassa **con uno in meno**.
//             LA CORREZIONE: tutta la lettura di `CheckSignal` scorre
//             avanti di B barre (conferma su B, segnale base su B+1,
//             impulso da k=B+1, banda piatta su B+7). Il resto della
//             funzione leggeva GIA' la barra 1: la barra 0 era
//             l'ECCEZIONE, ed e' quella che e' stata tolta.
//             NON e' cosmetica: **cambia quali segnali esistono**,
//             quindi il round che ne esce e' un ROUND NUOVO, con
//             criteri da firmare PRIMA dei numeri. E il costo si
//             dichiara: l'ingresso avviene UNA BARRA DOPO.
//             `Signal_Bar_Offset = 0` riproduce la v5.10 in modo
//             ESATTO (stessi indici, stesso `barsNeeded`, stessi
//             bound): serve a poter rifare R92, non a operare.
//             14. `PurpleReactionOk` spaccata in due: la condizione
//             vive in `PurpleReactionCore(..., bool usePine)`, la
//             firma vecchia resta come guscio. Serve SOLO all'autotest
//             (provare entrambe le varianti nella stessa passata).
//             Nessun cambio di comportamento.
//             15. AUTOTEST: tre asserzioni nuove che provano a
//             macchina che il difetto e' morto -- (A) il PINE
//             distingue verde/rossa, (B) l'EA scarta la candela
//             impulsiva, (C) con `close==open` il PINE e' sempre falso
//             e l'EA sempre vero, cioe' il difetto di R92 riprodotto
//             apposta e dichiarato come comportamento di offset 0.
//             Piu' la stampa della MAPPA DELLE BARRE in avvio: senza
//             quella, un numero di questo EA non si sa a quale motore
//             appartiene.
//
//  [DA DECIDERE] -- COSE VISTE LEGGENDO IL CODICE, **NON** CORRETTE.
//  La logica e' di Claudio: la modifica e' una sua decisione, non una
//  nostra. Sono scritte qui perche' chi legge un numero di R92 sappia
//  cosa c'era sotto.
//   (a) [MISURATO da R92 il 21/08 -- e CORRETTO nella v5.20 con
//       Signal_Bar_Offset=1. Il testo resta qui sotto com'era scritto
//       PRIMA della misura: e' la traccia di cosa era inferito e cosa
//       poi si e' visto. R92 ha trovato che il difetto colpiva DUE
//       segnali, non uno: anche il VIOLA-PINE (0 trade su 44 celle su
//       44) e, alla rovescia, il VIOLA-EA (filtro sempre vero).]
//       IL BLU E' CIECO SUL SIMBOLO DEL GRAFICO. [INFERITO dal codice,
//       DA MISURARE] CheckSignal gira UNA VOLTA per barra, al primo
//       tick della nuova candela H1 (guardia g_lastBarTime). La
//       conferma BLU pretende closes[0] > opens[0] su barra 0: al
//       PRIMO tick di una candela close == open, quindi sul simbolo
//       DEL GRAFICO il BLU non puo' quasi mai scattare. In campo il
//       basket gira su UN grafico solo e gli altri 21 simboli vengono
//       guardati quando arriva un tick del grafico -- li' la barra 0
//       ha gia' un corpo. CONSEGUENZA PER I TEST: testando UN SIMBOLO
//       ALLA VOLTA (che e' l'unico modo pulito nel tester MT5, vedi
//       docs\Guida_Test_BULGE.md) si misura soprattutto il VIOLA.
//       Il canarino e' il conteggio: se il BLU fa ZERO trade su tutti
//       i simboli, non e' il mercato, e' il banco di prova.
//   (b) LA BARRA SI "CONSUMA" ANCHE SE IL SEGNALE NON VIENE GUARDATO.
//       In OnTick g_lastBarTime[i] viene aggiornato PRIMA dei cancelli
//       (kill switch, filtro news, Max_Trades): se un cancello e'
//       chiuso al primo tick della candela, quella candela non viene
//       piu' esaminata nemmeno se il cancello si riapre un secondo
//       dopo. E' esattamente il motivo per cui il Guardian NON e'
//       stato messo in cima a OnTick.
//   (c) HasOpenTrade riconosce la posizione confrontando il COMMENTO
//       (POSITION_COMMENT) con quello che manderemmo. Se il broker
//       tronca o riscrive il commento, il confronto non torna e il
//       doppione diventa possibile.
//   (d) Kill switch: isSL = (reason == DEAL_REASON_SL) || (profit < 0)
//       -- conta come "stop loss" QUALUNQUE deal in perdita, comprese
//       le chiusure parziali. E' una scelta prudente, ma va saputa
//       quando si leggono i contatori.
//+------------------------------------------------------------------+
#property strict
#property copyright "Claudio -- BULGE (motore di Claudio, migrato agli standard di casa)"
#property version   "5.20"

#include <Trade\Trade.mqh>
//--- firme B1/C1 del 18/08: la guardia del conto, lato EA.
//    Fail-open totale: input spento, conto senza Guardian o Strategy
//    Tester -> si comporta ESATTAMENTE come prima della migrazione.
#include <ABTG_PausaGuardian.mqh>
CTrade trade;

//==================================================================
// ENUM -- Modalita' di gestione del rischio
//==================================================================
enum ENUM_RISK_MODE
{
   RISK_PER_TRADE = 0,   // Rischio fisso % per ogni trade
   RISK_TOTAL_CAP = 1    // Tetto totale % diviso per Max_Trades
};

//==================================================================
// INPUT -- BOLLINGER
//==================================================================
input group "=== Bollinger Bands ==="
input int    BB_Period     = 20;    // BB Period
input double BB_Deviation  = 2.0;   // BB Deviation

//==================================================================
// INPUT -- ATR / BULGE
//==================================================================
input group "=== ATR / Bulge ==="
input int    ATR_Period    = 14;    // ATR Period
input double SL_ATR_Mult    = 3.0;   // SL = ATR x questo moltiplicatore
input int    BB_Width_Len  = 50;    // Lookback BB Width
input double Bulge_Multi    = 1.1;   // Bulge minimo x media
input int    Lookback_Bars = 20;    // Finestra impulso (barre)

//==================================================================
// INPUT -- SEGNALI
//==================================================================
input group "=== Segnali ==="
input bool   Use_Orange = false;   // Arancio -- IN-BULGE meta' bulge
input bool   Use_Blue   = true;    // Blu     -- IN-BULGE 2a candela
input bool   Use_Purple = true;    // Viola   -- POST-BULGE

//--- v5.10 (FIRMA DI CLAUDIO 21/08, "misura entrambe"): LE DUE VERSIONI
//    DELL'ULTIMA CONDIZIONE DEL VIOLA. La divergenza e' MISURATA nella
//    triangolazione col Pine originale di Claudio
//    (risultati_archivio\TRIANGOLAZIONE_BULGE_PINE_2026-08-21.md):
//      false = VIOLA-EA   |close0-open0| <= 1,5 x ATR  (candela NON
//              impulsiva: apre anche su candela ROSSA in un long)
//      true  = VIOLA-PINE close0 > open0 nel long, close0 < open0 nel
//              short (candela di reazione VERDE / ROSSA, come il Pine)
//    >>> NESSUNA DELLE DUE E' "LA CORREZIONE" DELL'ALTRA. Sono due
//        ipotesi, e si misurano tutte e due (R92: 2 varianti x 22
//        simboli x 2 gestioni = 88 passate).
//    DEFAULT false = comportamento IDENTICO a BULGE_MASTER: nessun
//    cambio silenzioso, mai.
input bool   Use_Purple_PineReaction = false; // Viola: true = ultima condizione del PINE (candela verde/rossa)

//==================================================================
// v5.20 -- SIGNAL_BAR_OFFSET: TUTTO SU BARRE CHIUSE
// (decisione di Claudio del 21/08, in chat: "VAI CON BARRA 1", cioe'
//  la via 1 -- RACCOMANDATA -- del referto R92)
//
//  PERCHE'. R92 ha MISURATO, non supposto, che il motore girava con
//  due segnali su tre spenti da un difetto di indicizzazione:
//    - VIOLA-PINE:  0 trade su 44 celle su 44;
//    - BLU:         0 per costruzione sul simbolo del grafico;
//    - VIOLA-EA:    acceso ma con la sua condizione SVUOTATA, cioe'
//                   piu' largo dell'originale -- e con un filtro in
//                   MENO faceva comunque 4,8 trade per simbolo su
//                   4,5 anni (~1,07 l'anno contro i ~10,5 dichiarati).
//  La causa e' una riga sola, in due facce: CheckSignal gira UNA VOLTA
//  per barra, al PRIMO TICK (guardia g_lastBarTime in OnTick), e al
//  primo tick della barra 0 vale close == open. Quindi
//    close0 > open0            -> SEMPRE FALSO   (PINE e BLU: morti)
//    |close0-open0| <= 1,5xATR -> SEMPRE VERO    (EA: filtro svuotato)
//  Il resto di CheckSignal legge gia' la barra 1 (atr1, BB, isBulge1,
//  reazione, origLong1, ricerca impulso da k=1): la lettura della
//  barra 0 era l'ECCEZIONE, non la regola.
//
//  COSA FA. Detto B = Signal_Bar_Offset, sposta TUTTA la lettura in
//  avanti di B barre:
//    barra di CONFERMA (BLU) / POST-BULGE (VIOLA) : indice B
//    barra del SEGNALE BASE (origLong/origShort,
//      isBulge, candela di reazione, ATR e BB)    : indice B+1
//    ricerca dell'ultimo impulso                   : parte da k = B+1
//    banda piatta (6 barre prima del segnale)      : indice B+7
//  Con B=1 la barra di conferma e' l'ULTIMA CHIUSA e il segnale base
//  la penultima: nessun dato di una candela in formazione entra piu'
//  in una decisione. NESSUN LOOK-AHEAD: si leggono solo barre gia'
//  chiuse e si esegue al primo tick della barra 0, che e' il primo
//  istante in cui quei dati esistono.
//
//  SEMANTICA DICHIARATA (non nascosta): Lookback_Bars continua a
//  contare le barre RISPETTO ALLA BARRA DEL SEGNALE, non rispetto
//  all'indice assoluto. barsSinceImp* resta un INDICE di array (serve
//  a leggere highs[]/lows[] dell'impulso); il confronto con
//  Lookback_Bars usa la distanza RELATIVA (barsSinceImp* - B). Cosi'
//  la finestra dell'impulso e' la stessa di prima, solo traslata.
//
//  COSTO, DETTO CHIARO: l'ingresso avviene UNA BARRA DOPO rispetto
//  alla v5.10. E' un cambio di semantica VERO, ed e' il motivo per cui
//  il round che ne esce e' un ROUND NUOVO, con criteri da firmare
//  prima dei numeri (R92_REFERTO.md, sezione "cosa significa").
//
//  DEFAULT 1 = la correzione accesa. Con 0 il file ricade ESATTAMENTE
//  nel comportamento della v5.10 (no-op esatto: B=0 riduce ogni indice
//  e ogni bound alla forma di prima, barsNeeded compreso): serve a
//  poter RIPRODURRE R92 se un giorno servisse, non a usarlo.
//
//  EFFETTO ATTESO (da verificare col tester, NON dichiarato come
//  fatto): il BLU e il VIOLA-PINE tornano a poter scattare -> piu'
//  operazioni, quindi campione finalmente leggibile; il VIOLA-EA
//  diventa piu' SELETTIVO (la condizione torna a filtrare) -> meno
//  operazioni VIOLA di R92. Le due cose vanno in direzioni opposte:
//  il conteggio per segnale ([BULGE-CONTA] / colonna signal del
//  per-trade) e' l'unica misura che le separa.
//==================================================================
input int    Signal_Bar_Offset = 1;  // 0 = comportamento R92 (rotto, per riprodurlo) | 1 = tutto su barre chiuse

//==================================================================
// INPUT -- FILTRO ATR
//==================================================================
input group "=== Filtro ATR ==="
input bool   Use_ATR_Filter = true; // Attiva filtro ATR
input int    ATR_MA_Len     = 20;   // Periodo media ATR
input double ATR_Max_Mult   = 1.8;  // ATR max (x media) -- caos
input double ATR_Min_Mult   = 0.5;  // ATR min (x media) -- piatto

//==================================================================
// INPUT -- FILTRO ADX ANTI-BANDRIDING (da v3)
//==================================================================
input group "=== Filtro ADX anti-bandriding (v3) ==="
input bool   Use_ADX_Filter      = true;  // Attiva filtro ADX
input int    ADX_Period          = 14;    // Periodo ADX
input double ADX_Threshold        = 30.0;  // Soglia ADX (>= -> trend forte -> blocca)
input bool   ADX_Apply_On_Blue   = true;  // Applica filtro a segnali BLU
input bool   ADX_Apply_On_Purple = false; // Applica filtro a segnali VIOLA
input bool   ADX_Apply_On_Orange = false; // Applica filtro a segnali ARANCIO

//==================================================================
// INPUT -- FILTRO NEWS ORARIO (da STRATEGY_AUTO)
//==================================================================
input group "=== Filtro news orario (STRATEGY_AUTO) ==="
input bool   Use_News_Filter   = false;       // Attiva filtro ore news
input string News_Block_Hours  = "7,9,11,12,15,22"; // Ore UTC da bloccare (CSV)

//==================================================================
// INPUT -- PARZIALE A R + BREAK-EVEN (da STRATEGY_AUTO)
//==================================================================
input group "=== Parziale a R + Break-even (STRATEGY_AUTO) ==="
input bool   Enable_Partial_Close = false;  // Attiva chiusura parziale a R
input double Partial_Close_Pct    = 0.5;    // % volume da chiudere (0.5 = 50%)
input double Partial_Close_R      = 1.0;    // R multiplo per la chiusura parziale

//==================================================================
// INPUT -- KILL SWITCH GIORNALIERO (unione v12 + v2 + KILL)
//==================================================================
input group "=== Kill switch giornaliero (v12 + v2 + KILL) ==="
input bool   Use_Kill_Switch     = true;   // Master ON/OFF kill switch
input int    Max_SL_PerDay        = 4;      // Stop dopo N SL totali nel giorno (0=off)
input int    Max_Consecutive_SL  = 3;      // Stop dopo N SL consecutivi (0=off)
input double Max_Daily_Loss_Pct  = 2.0;    // Stop se perdita giornaliera >= % balance (0=off)

//==================================================================
// INPUT -- GESTIONE RISCHIO
//==================================================================
input group "=== Gestione rischio ==="
input ENUM_RISK_MODE Risk_Mode    = RISK_PER_TRADE; // Modalita' rischio
//--- v5.10 (FIRMA DI CLAUDIO 21/08, "0,8"): 0,80% NON e' un numero
//    scelto per gusto, e' il numero che fa REGGERE IL CAP.
//    0,80 x Max_Trades 4 = 3,20% di rischio aperto insieme, sotto il
//    cap C1 firmato il 18/08 (3,25%). Con l'1,00% della bozza erano
//    4,00%: sopra il cap. BULGE_MASTER aveva 0,50 e il backtest di
//    Claudio girava a 3,00 -> i profitti e i DD IN DENARO non sono
//    confrontabili con nessuno dei due; PF, win rate e n si'.
input double Risk_Percent          = 0.8;   // [RISK_PER_TRADE] Rischio % per trade
input double Total_Risk_Percent   = 2.0;   // [RISK_TOTAL_CAP] Rischio totale % (/ Max_Trades)
input int    Max_Trades            = 4;      // Max trade contemporanei

//==================================================================
// INPUT -- GESTIONE ORDINI MANUALI (da CLEAN)
//==================================================================
input group "=== Gestione ordini manuali (CLEAN) ==="
input bool   Manage_Manual_Orders = false; // Gestisci posizioni magic=0
input double Manual_SL_ATR_Mult   = 3.0;   // SL manuale = ATR x questo valore

//==================================================================
// INPUT -- GESTIONE (b): BREAK-EVEN A 1R + TRAILING A GRADINI DI R
// v5.10 -- PORTING del Trade Manager MT4 di Claudio
//   docs\breaking_band\EA_BOLL_BULGE_Manager_PRO_MULTI_TF.mq4
//   (DoBreakEvenIfNeeded / DoTrailingRIfNeeded, righe 295-370)
// E' la gestione che Claudio usava A MANO su MT4 mentre l'EA MT5 gira
// NUDO (SL 3xATR + TP sulla mediana, nient'altro). Sono due gestioni
// diverse sullo stesso motore, e la firma del 21/08 dice di misurarle
// tutte e due: "sapere quanto vale il break-even in euro, invece di
// opinarlo".
// >>> TUTTI I DEFAULT SONO SPENTI: con questi valori il comportamento
//     dell'EA e' identico BIT PER BIT a BULGE_MASTER. Non e' cortesia:
//     e' l'unico modo di sapere quale delle due gestioni ha mosso i
//     numeri.
// >>> NON tocca il TP (che resta la mediana dinamica di UpdateAllTP) e
//     NON c'entra niente col break-even che vive dentro
//     DoPartialCloseIfNeeded (quello e' legato a Enable_Partial_Close,
//     e' un'altra cosa e resta spento). I due non si intrecciano mai.
//==================================================================
input group "=== Gestione (b): BE 1R + trailing R (Manager MQ4) ==="
input bool   Enable_BE_1R          = false; // Break-even a R (SPENTO = gestione nuda)
input double BE_At_R               = 1.0;   // A quanti R portare a pari
input int    BE_Offset_Points      = 2;     // Punti oltre il pari (Manager: 2)
input bool   Enable_Trailing_R     = false; // Trailing a gradini di R (SPENTO = gestione nuda)
input double Trail_Start_R         = 1.5;   // Da quanti R parte il trailing
input double Trail_Step_R          = 0.25;  // Ampiezza del gradino, in R
input int    Trail_MinMove_Points  = 10;    // Movimento minimo per mandare la modifica

//==================================================================
// INPUT -- IDENTITA' / SIMBOLI
//==================================================================
input group "=== Identita' / Simboli ==="
//--- 772700: blocco verificato libero nel repo (grep su tutti i .mq5,
//    .md, .txt e .ps1). 772701/772702 compaiono SOLO come asse di
//    sweep in R51 -- nessuna sedia viva. 772701 resta riservato
//    all'asse di controllo gemello dei banchi (R92-scan).
input long   InpMagic      = 772700;    // Magic Number (identifica i trade dell'EA)
input string InpComment    = "BULGE";   // Prefisso commento ordini
//--- BANCO DI PROVA: nel tester si mette QUI il solo simbolo del
//    grafico (docs\Guida_Test_BULGE.md). MT5 modella male i simboli
//    diversi da quello del grafico: un basket intero da un grafico
//    solo, nel tester, NON e' una misura -- e' una stima.
input string Symbols_List  = "EURUSD,GBPUSD,AUDUSD,NZDUSD,USDCAD,USDCHF,USDJPY,EURGBP,EURNZD,GBPJPY,GBPAUD,GBPCAD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF,CHFJPY"; // Basket (22 cross)

//==================================================================
// INPUT -- GENERALI (standard di casa, v5.00)
//==================================================================
input group "=== Generali (standard di casa) ==="
input bool   InpUsaGuardian = true;  // Guardian: ferma i NUOVI ingressi (firme B1/C1)
input bool   InpVerbose     = true;  // Stampe informative nel giornale (gli errori si stampano sempre)
input bool   InpAutoTest    = true;  // Stampa le righe [BULGE][AUTOTEST] in avvio

//==================================================================
// VARIABILI GLOBALI
//==================================================================
string   g_symbols[];
int      g_symbolCount = 0;
datetime g_lastBarTime[];

//--- v5.20: Signal_Bar_Offset gia' validato (un input non si puo'
//    scrivere). Un valore negativo o assurdo qui dentro diventerebbe
//    un indice negativo = ArrayOutOfRange silenzioso, quindi si
//    limita UNA VOLTA in OnInit e si usa sempre questa copia.
int      g_sigOff = 1;

// --- CACHE HANDLE INDICATORE (uno per simbolo) ---
int      g_hBands[];   // handle iBands per simbolo
int      g_hATR[];     // handle iATR per simbolo
int      g_hADX[];     // handle iADX per simbolo

// --- KILL SWITCH ---
bool     g_kill_active      = false; // EA fermo per il resto del giorno?
string   g_kill_reason      = "";    // Motivo dello stop
datetime g_kill_today_start = 0;     // Inizio giornata corrente (server time)

//--- v5.10 SL INIZIALE PER TICKET (serve SOLO alla gestione (b)).
//    E' LA CORREZIONE DEL DIFETTO EREDITATO dal Manager MQ4: li'
//    InitialRiskPoints() legge lo SL **CORRENTE**, quindi appena il
//    break-even sposta lo stop sul prezzo d'ingresso il denominatore
//    va a ~0 e i multipli R esplodono (il trailing scatta a caso).
//    Qui il rischio iniziale si misura UNA VOLTA, alla prima volta che
//    si vede il ticket, e non cambia piu'.
//    Doppia memoria, come gia' fa il parziale in questo stesso file:
//      - array in RAM (veloce, e' quello che si legge a ogni tick)
//      - GlobalVariable (sopravvive a un riavvio del terminale: senza,
//        dopo un restart si rileggerebbe lo SL gia' spostato = il
//        difetto di prima, per un'altra strada)
ulong    g_r0Ticket[];
double   g_r0Dist[];

//--- v5.00 METRICHE DA PROP (schema di famiglia): l'Equity DD dice se
//    il conto sopravvive; una prop invece ti chiude per il LIMITE
//    GIORNALIERO, che e' un'altra cosa. Qui si segue l'equity dentro
//    la giornata e si tiene la caduta peggiore rispetto all'apertura.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

//--- v5.00: stampa informativa (l'ERRORE si stampa sempre, questa no)
void Log(string m) { if(InpVerbose) Print("[BULGE] ", m); }

//==================================================================
// HELPER -- Estrae il tag segnale dal commento (da PARALLEL)
// Esempio: "BULGE_M_BLU_L" -> "BLU LONG"
//==================================================================
string ExtractSignalTag(string comment, bool addDirection = true)
{
   string tag = "?";
   if(StringFind(comment, "_BLU_")     >= 0) tag = "BLU";
   else if(StringFind(comment, "_VIOLA_")   >= 0) tag = "VIOLA";
   else if(StringFind(comment, "_ARANCIO_") >= 0) tag = "ARANCIO";

   string dir = "";
   int len = StringLen(comment);
   if(len >= 2)
   {
      string suffix = StringSubstr(comment, len - 2);
      if(suffix == "_L")      dir = "LONG";
      else if(suffix == "_S") dir = "SHORT";
   }

   if(addDirection && dir != "") return tag + " " + dir;
   return tag;
}

//==================================================================
// FILLING ADATTIVO -- sceglie FOK/IOC/RETURN dal simbolo
//==================================================================
ENUM_ORDER_TYPE_FILLING GetFillingMode(string sym)
{
   long modes = (long)SymbolInfoInteger(sym, SYMBOL_FILLING_MODE);
   // SYMBOL_FILLING_FOK = 1, SYMBOL_FILLING_IOC = 2 (bitmask)
   if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
   if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
   return ORDER_FILLING_RETURN;
}

//==================================================================
// INIT
//==================================================================
int OnInit()
{
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints(10);

   //--- v5.20: l'offset delle barre si valida QUI, una volta sola.
   //    Fuori dall'intervallo [0..5] non c'e' nessun uso sensato: 0 e'
   //    il comportamento rotto di R92 (tenuto solo per riprodurlo), 1
   //    e' la correzione firmata; oltre si sposterebbe il segnale cosi'
   //    indietro da non essere piu' lo stesso motore. Un valore
   //    negativo darebbe indici negativi = ArrayOutOfRange muto.
   g_sigOff = Signal_Bar_Offset;
   if(g_sigOff < 0) g_sigOff = 0;
   if(g_sigOff > 5) g_sigOff = 5;
   if(g_sigOff != Signal_Bar_Offset)
      PrintFormat("[BULGE] ATTENZIONE: Signal_Bar_Offset=%d fuori intervallo [0..5], limitato a %d",
                  Signal_Bar_Offset, g_sigOff);

   // Parse simboli
   g_symbolCount = StringSplit(Symbols_List, ',', g_symbols);
   if(g_symbolCount <= 0)
   {
      Print("[BULGE] ERRORE: Symbols_List vuoto");
      return(INIT_FAILED);
   }

   ArrayResize(g_lastBarTime, g_symbolCount);
   ArrayInitialize(g_lastBarTime, 0);

   // Alloca array per la cache degli handle
   ArrayResize(g_hBands, g_symbolCount);
   ArrayResize(g_hATR,   g_symbolCount);
   ArrayResize(g_hADX,   g_symbolCount);

   for(int i = 0; i < g_symbolCount; i++)
   {
      StringTrimLeft(g_symbols[i]);
      StringTrimRight(g_symbols[i]);

      if(!SymbolSelect(g_symbols[i], true))
         Print("[BULGE] Simbolo non trovato: ", g_symbols[i]);

      // [MIGLIORIA] Crea UN handle per simbolo (cache), non a ogni chiamata
      g_hBands[i] = iBands(g_symbols[i], PERIOD_H1, BB_Period, 0, BB_Deviation, PRICE_CLOSE);
      g_hATR[i]   = iATR  (g_symbols[i], PERIOD_H1, ATR_Period);
      g_hADX[i]   = Use_ADX_Filter ? iADX(g_symbols[i], PERIOD_H1, ADX_Period) : INVALID_HANDLE;

      if(g_hBands[i] == INVALID_HANDLE || g_hATR[i] == INVALID_HANDLE)
         Print("[BULGE] ERRORE handle indicatore per ", g_symbols[i]);
   }

   // Init kill switch
   g_kill_today_start = GetTodayStart();
   g_kill_active      = false;
   g_kill_reason      = "";

   // Log riepilogo configurazione
   string adx_msg = "OFF";
   if(Use_ADX_Filter)
   {
      adx_msg = "ON soglia=" + DoubleToString(ADX_Threshold, 1) + " su:";
      if(ADX_Apply_On_Blue)   adx_msg += " BLU";
      if(ADX_Apply_On_Purple) adx_msg += " VIOLA";
      if(ADX_Apply_On_Orange) adx_msg += " ARANCIO";
   }
   string risk_msg = (Risk_Mode == RISK_PER_TRADE)
                     ? ("PER_TRADE " + DoubleToString(Risk_Percent, 2) + "%")
                     : ("TOTAL_CAP " + DoubleToString(Total_Risk_Percent, 2) + "% / " +
                        IntegerToString(Max_Trades));
   string kill_msg = Use_Kill_Switch
                     ? StringFormat("ON | SL/gg<%d | ConsecSL<%d | DailyLoss<=-%.1f%%",
                                    Max_SL_PerDay, Max_Consecutive_SL, Max_Daily_Loss_Pct)
                     : "OFF";

   Print("[BULGE] Init OK | Simboli: ", g_symbolCount,
         " | Rischio: ", risk_msg,
         " | Max trade: ", Max_Trades,
         " | ADX: ", adx_msg,
         " | Kill: ", kill_msg,
         //--- v5.20: l'offset va SEMPRE nel giornale, perche' senza di
         //    esso un numero di questo EA non si sa a quale motore
         //    appartiene (0 = R92 rotto, 1 = barre chiuse).
         " | Signal_Bar_Offset: ", g_sigOff,
         (g_sigOff == 0 ? " (R92 -- BLU e VIOLA-PINE MUTI, VIOLA-EA senza filtro)" : " (conferma su barra chiusa)"));

   //--- v5.10: riaggancio delle posizioni gia' vive, per misurare il
   //    rischio iniziale anche dopo un riavvio (gestione (b)).
   ArrayResize(g_r0Ticket, 0);
   ArrayResize(g_r0Dist,   0);
   R0RegisterExisting();

   //--- v5.00: autotest puro (nessun ordine, nessuna lettura di conto).
   //    Le righe si leggono ESEGUENDO l'EA, non compilandolo.
   if(InpAutoTest) AutoTestBulge();

   return(INIT_SUCCEEDED);
}

//==================================================================
// v5.00 -- AUTOTEST (puro): controlla i mattoni che si possono
// controllare a tavolino, cioe' senza mercato e senza conto.
//  1. ExtractSignalTag: e' quello che scrive il tag nelle notifiche e
//     nel referto di chiusura. Se sbaglia, si legge male OGNI trade.
//  2. Il nucleo del Guardian (18 casi, dentro l'include): se qui esce
//     anche un solo FAIL, l'EA NON si mette in campo.
// NON prova la logica dei segnali: quella pretende le barre, e una
// prova che ha bisogno del mercato non e' un autotest.
//==================================================================
void AutoTestBulge()
{
   PrintFormat("[BULGE][AUTOTEST] magic %s | commento \"%s\" | rischio %.2f%% | segnali: %s%s%s",
               IntegerToString(InpMagic), InpComment, Risk_Percent,
               (Use_Orange ? "ARANCIO " : ""), (Use_Blue ? "BLU " : ""),
               (Use_Purple ? "VIOLA" : ""));

   string cBlu     = InpComment + "_BLU_L";
   string cViola   = InpComment + "_VIOLA_S";
   string cArancio = InpComment + "_ARANCIO_L";

   bool t1 = (ExtractSignalTag(cBlu,     true)  == "BLU LONG");
   bool t2 = (ExtractSignalTag(cViola,   true)  == "VIOLA SHORT");
   bool t3 = (ExtractSignalTag(cArancio, true)  == "ARANCIO LONG");
   bool t4 = (ExtractSignalTag(cBlu,     false) == "BLU");
   bool t5 = (ExtractSignalTag("commento_di_un_altro", true) == "?");

   PrintFormat("[BULGE][AUTOTEST] tag segnale: BLU_L=%s VIOLA_S=%s ARANCIO_L=%s senzaDirezione=%s estraneo=%s",
               (t1?"PASS":"*** FAIL ***"), (t2?"PASS":"*** FAIL ***"),
               (t3?"PASS":"*** FAIL ***"), (t4?"PASS":"*** FAIL ***"),
               (t5?"PASS":"*** FAIL ***"));
   if(!(t1 && t2 && t3 && t4 && t5))
      Print("[BULGE][AUTOTEST] ATTENZIONE: il tag segnale DIVERGE. Con questo InpComment ",
            "le notifiche e il referto di chiusura non sanno piu' dire quale segnale ha aperto.");

   //--- v5.10 VIOLA: le due versioni dell'ultima condizione.
   //    ATR finto 0,0010; candela rossa di 2 pip; candela verde di 2 pip.
   bool vEA_rossa  = PurpleReactionOk(true,  1.10020, 1.10000, 0.0010); // EA: passa (non impulsiva)
   bool vEA_verde  = PurpleReactionOk(true,  1.10000, 1.10020, 0.0010); // EA: passa
   bool vEA_impuls = PurpleReactionOk(true,  1.10000, 1.10200, 0.0010); // EA: 200 pip > 1,5xATR -> NO
   PrintFormat("[BULGE][AUTOTEST] VIOLA (Use_Purple_PineReaction=%s): rossa=%s verde=%s impulsiva=%s",
               (Use_Purple_PineReaction ? "true PINE" : "false EA"),
               (vEA_rossa?"passa":"scarta"), (vEA_verde?"passa":"scarta"), (vEA_impuls?"passa":"scarta"));
   if(!Use_Purple_PineReaction)
      Print("[BULGE][AUTOTEST] atteso col default: rossa=passa verde=passa impulsiva=scarta ",
            ((vEA_rossa && vEA_verde && !vEA_impuls) ? "PASS" : "*** FAIL ***"));
   else
      Print("[BULGE][AUTOTEST] atteso col Pine: rossa=scarta verde=passa impulsiva=passa ",
            ((!vEA_rossa && vEA_verde && vEA_impuls) ? "PASS" : "*** FAIL ***"));

   //================================================================
   //--- v5.20 -- LA PROVA CHE IL DIFETTO DI R92 E' MORTO.
   //    Non e' una stampa di cortesia: R92 ha misurato 0 trade su 44
   //    celle su 44 col VIOLA-PINE, e 106 operazioni VIOLA-EA con la
   //    condizione svuotata. Le tre asserzioni qui sotto provano A
   //    MACCHINA, senza mercato, che:
   //      A) su barre CHIUSE il PINE DISTINGUE verde e rossa;
   //      B) su barre CHIUSE l'EA SCARTA davvero la candela impulsiva;
   //      C) con close == open (cioe' Signal_Bar_Offset=0, il primo
   //         tick della barra in formazione) il PINE e' sempre falso e
   //         l'EA sempre vero -- il difetto, RIPRODOTTO APPOSTA.
   //    Sono aritmetica pura su candele sintetiche: valgono uguale nel
   //    tester, sul demo e sul reale. ATR finto = 0,0010 (10 pip),
   //    soglia EA = 1,5 x ATR = 0,0015 (15 pip).
   //================================================================
   PrintFormat("[BULGE][AUTOTEST] mappa barre: Signal_Bar_Offset=%d -> conferma su barra %d, segnale base su barra %d, impulso da k=%d, banda piatta su barra %d, barsNeeded=%d",
               g_sigOff, g_sigOff, g_sigOff + 1, g_sigOff + 1, g_sigOff + 7,
               Lookback_Bars * 2 + 10 + g_sigOff);

   //--- A) PINE su barra CHIUSA: verde -> long si', short no; rossa -> il contrario.
   bool pVerdeL = PurpleReactionCore(true,  1.10000, 1.10020, 0.0010, true);  // atteso true
   bool pVerdeS = PurpleReactionCore(false, 1.10000, 1.10020, 0.0010, true);  // atteso false
   bool pRossaL = PurpleReactionCore(true,  1.10020, 1.10000, 0.0010, true);  // atteso false
   bool pRossaS = PurpleReactionCore(false, 1.10020, 1.10000, 0.0010, true);  // atteso true
   bool aPine   = (pVerdeL && !pVerdeS && !pRossaL && pRossaS);
   PrintFormat("[BULGE][AUTOTEST] A) PINE su barra chiusa: verde(long=%s short=%s) rossa(long=%s short=%s) -> atteso true/false/false/true: %s",
               (pVerdeL?"true":"false"), (pVerdeS?"true":"false"),
               (pRossaL?"true":"false"), (pRossaS?"true":"false"),
               (aPine ? "PASS" : "*** FAIL ***"));

   //--- B) EA su barra CHIUSA: il filtro deve poter SCARTARE qualcosa.
   //    corpo 20 pip <= 15 pip? no -> deve scartare. corpo 5 pip -> passa.
   bool eImpuls = PurpleReactionCore(true,  1.10000, 1.10200, 0.0010, false); // corpo 200 pip -> atteso false
   bool eLargo  = PurpleReactionCore(true,  1.10000, 1.10020, 0.0010, false); // corpo 20 pip  -> atteso false
   bool ePicco  = PurpleReactionCore(true,  1.10000, 1.10005, 0.0010, false); // corpo 5 pip   -> atteso true
   bool aEA     = (!eImpuls && !eLargo && ePicco);
   PrintFormat("[BULGE][AUTOTEST] B) EA su barra chiusa: corpo200pip=%s corpo20pip=%s corpo5pip=%s -> atteso scarta/scarta/passa: %s",
               (eImpuls?"passa":"scarta"), (eLargo?"passa":"scarta"), (ePicco?"passa":"scarta"),
               (aEA ? "PASS" : "*** FAIL ***"));

   //--- C) IL DIFETTO DI R92, RIPRODOTTO APPOSTA (close == open).
   bool r92PineL = PurpleReactionCore(true,  1.10000, 1.10000, 0.0010, true);  // atteso false
   bool r92PineS = PurpleReactionCore(false, 1.10000, 1.10000, 0.0010, true);  // atteso false
   bool r92EaL   = PurpleReactionCore(true,  1.10000, 1.10000, 0.0010, false); // atteso true
   bool r92EaS   = PurpleReactionCore(false, 1.10000, 1.10000, 0.0010, false); // atteso true
   bool aR92     = (!r92PineL && !r92PineS && r92EaL && r92EaS);
   PrintFormat("[BULGE][AUTOTEST] C) difetto R92 riprodotto apposta (close==open, primo tick della barra 0): PINE long=%s short=%s (sempre FALSO = 0 trade su 44 celle su 44) | EA long=%s short=%s (sempre VERO = filtro svuotato): %s",
               (r92PineL?"true":"false"), (r92PineS?"true":"false"),
               (r92EaL?"true":"false"),   (r92EaS?"true":"false"),
               (aR92 ? "PASS (riprodotto)" : "*** FAIL ***"));
   Print("[BULGE][AUTOTEST] C) NB: quel comportamento e' quello di Signal_Bar_Offset=0, NON un guasto di oggi. ",
         "E' tenuto vivo solo per poter riprodurre R92 -- non e' una configurazione da usare.");

   //--- Verdetto d'insieme + coerenza con l'offset configurato.
   if(!(aPine && aEA && aR92))
      Print("[BULGE][AUTOTEST] *** FAIL *** la condizione del VIOLA non si comporta come atteso: NON mettere in campo.");
   else if(g_sigOff >= 1)
      Print("[BULGE][AUTOTEST] VERDETTO: PASS. Signal_Bar_Offset=", g_sigOff,
            " -> conferma e post-bulge leggono una barra CHIUSA: BLU e VIOLA-PINE possono scattare, ",
            "il filtro del VIOLA-EA torna a filtrare. Nessuna barra in formazione entra in una decisione (niente look-ahead).");
   else
      Print("[BULGE][AUTOTEST] VERDETTO: le tre prove passano, MA Signal_Bar_Offset=0 -> stai girando col motore di R92: ",
            "BLU e VIOLA-PINE MUTI, VIOLA-EA senza filtro. I numeri che escono NON sono confrontabili con quelli a offset 1.");

   //--- v5.10 GESTIONE (b): la scala del trailing, aritmetica pura.
   if(Enable_BE_1R || Enable_Trailing_R)
   {
      PrintFormat("[BULGE][AUTOTEST] gestione (b) ACCESA: BE=%s a %.2fR (+%d punti) | trailing=%s start %.2fR passo %.2fR",
                  (Enable_BE_1R?"SI":"no"), BE_At_R, BE_Offset_Points,
                  (Enable_Trailing_R?"SI":"no"), Trail_Start_R, Trail_Step_R);
      PrintFormat("[BULGE][AUTOTEST] scala trailing: r=1.40 -> %.2f | r=1.50 -> %.2f | r=2.00 -> %.2f | r=2.60 -> %.2f   (-1 = trailing fermo)",
                  TrailLockR(1.40), TrailLockR(1.50), TrailLockR(2.00), TrailLockR(2.60));
      if(MathAbs(Trail_Start_R - 1.5) < 1e-9 && MathAbs(Trail_Step_R - 0.25) < 1e-9)
      {
         bool s1 = (TrailLockR(1.40) < 0.0);
         bool s2 = (MathAbs(TrailLockR(1.50) - 0.50) < 1e-9);
         bool s3 = (MathAbs(TrailLockR(2.00) - 1.00) < 1e-9);
         bool s4 = (MathAbs(TrailLockR(2.60) - 1.50) < 1e-9);
         Print("[BULGE][AUTOTEST] scala attesa (-1 / 0.50 / 1.00 / 1.50): ",
               ((s1 && s2 && s3 && s4) ? "PASS" : "*** FAIL ***"));
      }
   }
   else
      Print("[BULGE][AUTOTEST] gestione (b) SPENTA: SL 3xATR fisso + TP mediana. E' la gestione NUDA, identica a BULGE_MASTER.");

   int fallitiGuardia = ABTG_AutotestGuardia();
   if(fallitiGuardia > 0)
      PrintFormat("[BULGE][AUTOTEST] Guardian: %d casi falliti -- NON mettere in campo.", fallitiGuardia);
}

//==================================================================
// DEINIT -- rilascia tutti gli handle in cache (niente leak)
//==================================================================
void OnDeinit(const int reason)
{
   for(int i = 0; i < g_symbolCount; i++)
   {
      if(g_hBands[i] != INVALID_HANDLE) IndicatorRelease(g_hBands[i]);
      if(g_hATR[i]   != INVALID_HANDLE) IndicatorRelease(g_hATR[i]);
      if(g_hADX[i]   != INVALID_HANDLE) IndicatorRelease(g_hADX[i]);
   }
   Print("[BULGE] Deinit reason=", reason);
}

//==================================================================
// ONTICK
//==================================================================
void OnTick()
{
   //--- v5.00 metrica da prop: quanto sono sceso OGGI rispetto all'apertura
   //    del giorno. Sta QUI, prima di qualunque filtro: la caduta peggiore
   //    di giornata succede in mezzo alla candela, non alla sua apertura.
   //    Non tocca nessuna decisione: e' solo misura, va nel CSV.
   {
    MqlDateTime _n; TimeToStruct(TimeCurrent(), _n);
    double _eq = AccountInfoDouble(ACCOUNT_EQUITY);
    if(_n.day_of_year != gDayEqStamp)
      { gDayEqStamp = _n.day_of_year; gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(gDayStartEquity <= 0) { gDayStartEquity = _eq; gDayMinEquity = _eq; }
    if(_eq < gDayMinEquity)  gDayMinEquity = _eq;
    double _giornata = 100.0 * (gDayMinEquity - gDayStartEquity) / gDayStartEquity;
    if(_giornata < gWorstDayPct) gWorstDayPct = _giornata;
   }

   // Reset giornaliero kill switch (se cambio giorno)
   KillSwitchDailyReset();

   bool canOpen = KillSwitchCanTrade();

   for(int i = 0; i < g_symbolCount; i++)
   {
      string sym = g_symbols[i];

      // Solo alla nuova candela H1: UNA valutazione per barra, al PRIMO
      // tick. v5.20 -- e' proprio questa guardia che rendeva velenosa la
      // lettura della barra 0 (al primo tick close == open): adesso
      // CheckSignal legge da Signal_Bar_Offset in poi, cioe' solo barre
      // gia' CHIUSE col default 1. Niente look-ahead: si decide nel
      // primo istante in cui quei dati esistono.
      datetime barTime = iTime(sym, PERIOD_H1, 0);
      if(barTime == g_lastBarTime[i]) continue;
      g_lastBarTime[i] = barTime;

      if(!canOpen)                          continue; // kill switch: niente nuove aperture
      if(Use_News_Filter && IsNewsHour())   continue; // filtro news orario
      if(CountOpenTrades() >= Max_Trades)   continue;

      CheckSignal(i);
   }

   // --- Gestione posizioni gia' aperte (continua anche con kill attivo) ---
   if(Enable_Partial_Close) DoPartialCloseIfNeeded();
   if(Manage_Manual_Orders) ManageManualOrders();
   ManageBeAndTrailing();   // v5.10 gestione (b): inerte se i due input sono spenti
   UpdateAllTP();
}

//==================================================================
// NOTIFICA CHIUSURA TRADE CON P&L E SEGNALE (da PARALLEL)
//==================================================================
void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest     &request,
                        const MqlTradeResult      &result)
{
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;

   ulong dealTicket = trans.deal;
   if(dealTicket == 0) return;
   if(!HistoryDealSelect(dealTicket)) return;

   // Solo deal di uscita (chiusura) dei nostri ordini
   if(HistoryDealGetInteger(dealTicket, DEAL_ENTRY) != DEAL_ENTRY_OUT) return;
   if(HistoryDealGetInteger(dealTicket, DEAL_MAGIC) != InpMagic)   return;

   string sym    = HistoryDealGetString(dealTicket, DEAL_SYMBOL);
   double profit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                 + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION)
                 + HistoryDealGetDouble(dealTicket, DEAL_SWAP);
   long   reason = HistoryDealGetInteger(dealTicket, DEAL_REASON);

   // Recupera il tag segnale dal deal di apertura (POSITION_ID)
   long   posID = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
   string openComment = "";
   if(HistorySelectByPosition(posID))
   {
      int totalDeals = HistoryDealsTotal();
      for(int d = 0; d < totalDeals; d++)
      {
         ulong dt = HistoryDealGetTicket(d);
         if(HistoryDealGetInteger(dt, DEAL_ENTRY) == DEAL_ENTRY_IN)
         {
            openComment = HistoryDealGetString(dt, DEAL_COMMENT);
            break;
         }
      }
   }
   string signal = ExtractSignalTag(openComment, true);

   string reasonStr = "manuale";
   if(reason == DEAL_REASON_TP)          reasonStr = "TP";
   else if(reason == DEAL_REASON_SL)     reasonStr = "SL";
   else if(reason == DEAL_REASON_EXPERT) reasonStr = "EA";

   string result_str = (profit >= 0) ? "PROFITTO" : "PERDITA";

   string msg = InpComment + " | " + sym + " | " + signal + " | " + reasonStr +
                " | " + result_str + " " + DoubleToString(profit, 2);
   SendNotification(msg);
   if(InpVerbose) Print("[BULGE] CHIUSURA | ", sym, " | ", signal,
         " | ", reasonStr, " | ", result_str, " | ", DoubleToString(profit, 2));

   // Dopo una chiusura ricontrolla il kill switch (conta da history)
   KillSwitchEvaluate();
}

//==================================================================
//                     KILL SWITCH (robusto da HistoryDeals)
//==================================================================

//-- Inizio giornata corrente (server time)
datetime GetTodayStart()
{
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   return StructToTime(dt);
}

//-- Reset al cambio giorno
void KillSwitchDailyReset()
{
   datetime today = GetTodayStart();
   if(today != g_kill_today_start)
   {
      g_kill_today_start = today;
      if(g_kill_active)
         Print("[BULGE] === NUOVO GIORNO === Kill switch RESET");
      g_kill_active = false;
      g_kill_reason = "";
   }
}

//-- Puo' aprire nuovi trade?
bool KillSwitchCanTrade()
{
   if(!Use_Kill_Switch) return true;
   KillSwitchDailyReset();
   if(!g_kill_active) KillSwitchEvaluate(); // valuta sempre lo stato corrente
   return !g_kill_active;
}

//-- Valuta i contatori giornalieri leggendoli da HistoryDeals.
//   Robusto a restart dell'EA: ricalcola sempre dalla history del giorno,
//   filtrando per magic. Conta: SL totali, SL consecutivi (sequenza finale),
//   P&L cumulato della giornata.
void KillSwitchEvaluate()
{
   if(!Use_Kill_Switch) return;

   datetime from = GetTodayStart();
   datetime to   = TimeCurrent() + 1;
   if(!HistorySelect(from, to)) return;

   double dayPnL       = 0.0;
   int    slCount      = 0;
   int    consecSL     = 0;   // SL consecutivi nella sequenza piu' recente
   int    runningSL    = 0;   // contatore corrente mentre scorro in ordine cronologico

   int total = HistoryDealsTotal();
   for(int d = 0; d < total; d++)
   {
      ulong ticket = HistoryDealGetTicket(d);
      if(ticket == 0) continue;
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != InpMagic)   continue;
      if(HistoryDealGetInteger(ticket, DEAL_ENTRY) != DEAL_ENTRY_OUT) continue;

      double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT)
                    + HistoryDealGetDouble(ticket, DEAL_COMMISSION)
                    + HistoryDealGetDouble(ticket, DEAL_SWAP);
      long   reason = HistoryDealGetInteger(ticket, DEAL_REASON);

      dayPnL += profit;

      bool isSL = (reason == DEAL_REASON_SL) || (profit < 0.0);
      if(isSL)
      {
         slCount++;
         runningSL++;
      }
      else if(profit > 0.0)
      {
         runningSL = 0; // una vincita interrompe la sequenza consecutiva
      }
   }
   // Per il blocco "consecutivi" conta la sequenza piu' recente (in corso)
   consecSL = runningSL;

   // --- Valutazione condizioni di stop ---
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   if(Max_SL_PerDay > 0 && slCount >= Max_SL_PerDay)
      KillSwitchActivate(StringFormat("%d SL nel giorno (limite %d)", slCount, Max_SL_PerDay));

   else if(Max_Consecutive_SL > 0 && consecSL >= Max_Consecutive_SL)
      KillSwitchActivate(StringFormat("%d SL consecutivi (limite %d)", consecSL, Max_Consecutive_SL));

   else if(Max_Daily_Loss_Pct > 0.0 && balance > 0.0)
   {
      double lossPct = (dayPnL / balance) * 100.0;
      if(lossPct <= -Max_Daily_Loss_Pct)
         KillSwitchActivate(StringFormat("Daily Loss %.2f%% (limite -%.1f%%)",
                                         lossPct, Max_Daily_Loss_Pct));
   }
}

//-- Attiva il blocco (una sola notifica)
void KillSwitchActivate(string reason)
{
   if(g_kill_active) return;
   g_kill_active = true;
   g_kill_reason = reason;
   Print("[BULGE] *** KILL SWITCH ATTIVATO *** | ", reason);
   SendNotification(InpComment + " | KILL SWITCH | " + reason);
}

//==================================================================
// FILTRO ORARIO NEWS (da STRATEGY_AUTO)
//==================================================================
bool IsNewsHour()
{
   MqlDateTime dt;
   TimeToStruct(TimeGMT(), dt);
   int currentHour = dt.hour;

   string parts[];
   int count = StringSplit(News_Block_Hours, ',', parts);
   for(int i = 0; i < count; i++)
   {
      StringTrimLeft(parts[i]);
      StringTrimRight(parts[i]);
      if((int)StringToInteger(parts[i]) == currentHour) return true;
   }
   return false;
}

//==================================================================
// CONTEGGIO POSIZIONI
//==================================================================
int CountOpenTrades()
{
   int count = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
      if(PositionGetTicket(i) > 0)
         if(PositionGetInteger(POSITION_MAGIC) == InpMagic)
            count++;
   return count;
}

//-- Gia' aperto sul simbolo con stesso commento (1 pos per simbolo/segnale)
bool HasOpenTrade(string sym, string comment)
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      if(PositionGetTicket(i) <= 0) continue;
      if(PositionGetString(POSITION_SYMBOL)  != sym)          continue;
      if(PositionGetInteger(POSITION_MAGIC)  != InpMagic) continue;
      if(PositionGetString(POSITION_COMMENT) == comment)      return true;
   }
   return false;
}

//==================================================================
// DATI BARRE H1
//==================================================================
bool GetBars(string sym, int count,
             double &highs[], double &lows[],
             double &opens[], double &closes[])
{
   ArraySetAsSeries(highs,  true);
   ArraySetAsSeries(lows,   true);
   ArraySetAsSeries(opens,  true);
   ArraySetAsSeries(closes, true);
   if(CopyHigh (sym, PERIOD_H1, 0, count, highs)  < count) return false;
   if(CopyLow  (sym, PERIOD_H1, 0, count, lows)   < count) return false;
   if(CopyOpen (sym, PERIOD_H1, 0, count, opens)  < count) return false;
   if(CopyClose(sym, PERIOD_H1, 0, count, closes) < count) return false;
   return true;
}

//==================================================================
// [MIGLIORIA] LETTURA BB DALLA CACHE
// Legge "count" barre dei 3 buffer BB a partire da "start" con un solo
// Copybuffer per buffer, usando l'handle in cache del simbolo.
//==================================================================
bool GetBBSeries(int symIdx, int start, int count,
                 double &upper[], double &lower[], double &basis[])
{
   int h = g_hBands[symIdx];
   if(h == INVALID_HANDLE) return false;
   ArraySetAsSeries(upper, true);
   ArraySetAsSeries(lower, true);
   ArraySetAsSeries(basis, true);
   if(CopyBuffer(h, 1, start, count, upper) < count) return false; // upper band
   if(CopyBuffer(h, 2, start, count, lower) < count) return false; // lower band
   if(CopyBuffer(h, 0, start, count, basis) < count) return false; // media (mediana)
   return true;
}

//-- BB su una singola barra (usa la cache)
bool GetBB(int symIdx, int barIndex, double &bbUpper, double &bbLower, double &bbBasis)
{
   double u[], l[], b[];
   if(!GetBBSeries(symIdx, barIndex, 1, u, l, b)) return false;
   bbUpper = u[0]; bbLower = l[0]; bbBasis = b[0];
   return true;
}

//==================================================================
// [MIGLIORIA] LETTURA ATR DALLA CACHE
//==================================================================
bool GetATRSeries(int symIdx, int start, int count, double &atr[])
{
   int h = g_hATR[symIdx];
   if(h == INVALID_HANDLE) return false;
   ArraySetAsSeries(atr, true);
   if(CopyBuffer(h, 0, start, count, atr) < count) return false;
   return true;
}

double GetATR(int symIdx, int barIndex = 1)
{
   double a[];
   if(!GetATRSeries(symIdx, barIndex, 1, a)) return 0.0;
   return a[0];
}

//==================================================================
// FILTRO ATR (usa la cache)
//==================================================================
bool AtrOk(int symIdx)
{
   if(!Use_ATR_Filter) return true;
   double atr[];
   int needed = ATR_MA_Len + 2;
   if(!GetATRSeries(symIdx, 1, needed, atr)) return false;
   double sum = 0;
   for(int i = 0; i < ATR_MA_Len; i++) sum += atr[i];
   double atrMA  = sum / ATR_MA_Len;
   double atrNow = atr[0];
   return (atrNow <= atrMA * ATR_Max_Mult && atrNow >= atrMA * ATR_Min_Mult);
}

//==================================================================
// [v3] FILTRO ADX (usa la cache)
//==================================================================
double GetADX(int symIdx, int barIndex = 1)
{
   int h = g_hADX[symIdx];
   if(h == INVALID_HANDLE) return -1.0;
   double adx[];
   ArraySetAsSeries(adx, true);
   if(CopyBuffer(h, 0, barIndex, 1, adx) < 1) return -1.0; // buffer 0 = ADX main
   return adx[0];
}

//-- Ritorna TRUE se il trade puo' procedere, FALSE se va bloccato
bool AdxFilterOk(int symIdx, string sym, string signalType)
{
   if(!Use_ADX_Filter) return true;

   bool applyFilter = false;
   if(signalType == "BLU"     && ADX_Apply_On_Blue)   applyFilter = true;
   if(signalType == "VIOLA"   && ADX_Apply_On_Purple) applyFilter = true;
   if(signalType == "ARANCIO" && ADX_Apply_On_Orange) applyFilter = true;
   if(!applyFilter) return true;

   double adx = GetADX(symIdx, 1);
   if(adx < 0) return true; // se non calcolabile, lascio passare

   if(adx >= ADX_Threshold)
   {
      if(InpVerbose) Print("[BULGE] ADX FILTER | ", sym, " | ", signalType,
            " bloccato | ADX=", DoubleToString(adx, 2),
            " >= soglia=", DoubleToString(ADX_Threshold, 2));
      return false;
   }
   return true;
}

//==================================================================
// BB WIDTH MA (per filtro bulge) -- usa la cache
//==================================================================
double GetBBWidthMA(int symIdx)
{
   double upper[], lower[], basis[];
   int needed = BB_Width_Len + 2;
   if(!GetBBSeries(symIdx, 1, needed, upper, lower, basis)) return 0.0;
   double sum = 0;
   for(int i = 0; i < BB_Width_Len; i++) sum += (upper[i] - lower[i]);
   return sum / BB_Width_Len;
}

//==================================================================
// CALCOLO LOTTI DA RISCHIO %
//==================================================================
double CalcLots(string sym, double slDist)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   // Rischio % effettivo a seconda della modalita'
   double riskPct = (Risk_Mode == RISK_PER_TRADE)
                    ? Risk_Percent
                    : (Total_Risk_Percent / MathMax(1, Max_Trades));

   double riskAmt   = balance * riskPct / 100.0;
   double tickValue = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
   double point     = SymbolInfoDouble(sym, SYMBOL_POINT);
   if(tickSize <= 0 || tickValue <= 0 || point <= 0) return 0.01;

   double slPoints = slDist / point;
   double lots     = riskAmt / (slPoints * tickValue / tickSize * point);

   double lotStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
   double lotMin  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
   double lotMax  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
   if(lotStep <= 0) lotStep = 0.01;
   lots = MathFloor(lots / lotStep) * lotStep;
   return NormalizeDouble(MathMax(lotMin, MathMin(lotMax, lots)), 2);
}

//==================================================================
// APRE ORDINE
//==================================================================
void OpenOrder(string sym, bool isLong, double atr, double bbBasis, string comment)
{
   if(HasOpenTrade(sym, comment))      return;
   if(CountOpenTrades() >= Max_Trades) return;

   trade.SetTypeFilling(GetFillingMode(sym)); // filling adattivo per simbolo

   int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
   double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
   double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
   double slDist = atr * SL_ATR_Mult;
   double lots   = CalcLots(sym, slDist);
   if(lots <= 0) return;

   if(isLong)
   {
      double sl = NormalizeDouble(ask - slDist, digits);
      double tp = NormalizeDouble(bbBasis, digits);
      if(tp <= ask) { if(InpVerbose) Print("[BULGE] LONG skip TP<ask | ", sym); return; }
      if(sl >= ask) { if(InpVerbose) Print("[BULGE] LONG skip SL>ask | ", sym); return; }
      //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi.
      //    Sta QUI, immediatamente prima dell'invio: e' l'unico punto in cui
      //    l'unica cosa che cambia e' che l'ordine non parte (come un rifiuto
      //    del broker). La posizione gia' aperta NON viene toccata.
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_Bulge")) return;
      if(trade.Buy(lots, sym, ask, sl, tp, comment))
      {
         string signal = ExtractSignalTag(comment, false);
         if(InpVerbose) Print("[BULGE] LONG | ", comment, " | ", sym,
               " | Lots=", lots, " | SL=", sl, " | TP=", tp);
         SendNotification(InpComment + " | " + sym + " | BUY | " + signal);
      }
      else
         Print("[BULGE] LONG ERR | ", sym, " | ", trade.ResultRetcodeDescription());
   }
   else
   {
      double sl = NormalizeDouble(bid + slDist, digits);
      double tp = NormalizeDouble(bbBasis, digits);
      if(tp >= bid) { if(InpVerbose) Print("[BULGE] SHORT skip TP>bid | ", sym); return; }
      if(sl <= bid) { if(InpVerbose) Print("[BULGE] SHORT skip SL<bid | ", sym); return; }
      //--- firme B1/C1: idem sul lato corto, immediatamente prima dell'invio.
      if(!ABTG_GuardiaIngresso(InpUsaGuardian, "ABTG_Bulge")) return;
      if(trade.Sell(lots, sym, bid, sl, tp, comment))
      {
         string signal = ExtractSignalTag(comment, false);
         if(InpVerbose) Print("[BULGE] SHORT | ", comment, " | ", sym,
               " | Lots=", lots, " | SL=", sl, " | TP=", tp);
         SendNotification(InpComment + " | " + sym + " | SELL | " + signal);
      }
      else
         Print("[BULGE] SHORT ERR | ", sym, " | ", trade.ResultRetcodeDescription());
   }
}

//==================================================================
// v5.10 -- L'UNICA CONDIZIONE DEL VIOLA CHE HA DUE VERSIONI.
// Sta QUI FUORI apposta: cosi' dentro CheckSignal cambiano due righe
// e non una virgola di piu', e il confronto riga-per-riga con
// BULGE_MASTER.mq5 resta leggibile (verifica a macchina nel referto).
// Col default (Use_Purple_PineReaction=false) questa funzione ritorna
// ESATTAMENTE il vecchio candleNotImpulsive, per tutti e due i lati.
//==================================================================
//
// v5.20 -- SPACCATA IN DUE, SENZA CAMBIARE NIENTE DI LOGICO.
// La condizione vera vive in PurpleReactionCore(), che prende la
// variante come PARAMETRO invece di leggerla dall'input globale.
// Motivo: l'autotest deve poter provare TUTTE E DUE le versioni nella
// stessa passata (altrimenti provi solo quella configurata, e il
// difetto di R92 -- PINE sempre falso / EA sempre vero -- non lo
// dimostri a macchina). La firma di PurpleReactionOk NON cambia:
// i chiamanti dentro CheckSignal restano identici.
// Le due barre passate sono ora quelle della barra di conferma
// (indice Signal_Bar_Offset) e l'ATR e' quello della barra del
// segnale base (indice Signal_Bar_Offset+1): vedi CheckSignal.
//
bool PurpleReactionCore(bool isLong, double openB, double closeB, double atrSig, bool usePine)
{
   if(usePine)
      return isLong ? (closeB > openB) : (closeB < openB);   // VIOLA-PINE
   return (MathAbs(closeB - openB) <= atrSig * 1.5);         // VIOLA-EA (default)
}

bool PurpleReactionOk(bool isLong, double open0, double close0, double atr1)
{
   return PurpleReactionCore(isLong, open0, close0, atr1, Use_Purple_PineReaction);
}

//==================================================================
// LOGICA PRINCIPALE -- tutti e 3 i segnali
//
// v5.20 -- L'UNICA COSA CAMBIATA E' L'INDICE DELLE BARRE.
// Nessuna condizione e' stata aggiunta, tolta o riscritta: sono le
// stesse identiche disuguaglianze della v5.10, lette B barre piu'
// indietro (B = g_sigOff = Signal_Bar_Offset validato).
//
//   iCnf = B      barra di CONFERMA (BLU) e di POST-BULGE (VIOLA)
//   iSig = B + 1  barra del SEGNALE BASE (origLong/origShort,
//                 isBulge, candela di reazione, ATR e BB del segnale)
//
// Con B=0 ogni indice qui sotto torna esattamente a quello della
// v5.10 (iCnf=0, iSig=1, ricerca impulso da k=1, banda piatta su
// bbLSeries[7], barsNeeded = Lookback_Bars*2+10): il no-op e' esatto.
// Con B=1 -- il default firmato -- la barra di conferma e' l'ULTIMA
// CHIUSA, quindi close != open e' possibile: e' esattamente il difetto
// che R92 ha misurato (PINE sempre falso, EA sempre vero) a morire.
//
// NIENTE LOOK-AHEAD, e si vede da qui: con B>=1 tutti gli indici letti
// sono >= 1, cioe' barre gia' chiuse, e CheckSignal viene chiamata al
// PRIMO tick della barra 0 (guardia g_lastBarTime in OnTick). Il primo
// istante in cui questi dati esistono e' anche quello in cui si opera.
//
// NB: sorgente dati invariata (handle in cache via GetBB/GetATR).
//==================================================================
void CheckSignal(int symIdx)
{
   string sym = g_symbols[symIdx];

   //--- v5.20: i due indici, calcolati una volta sola.
   int iCnf = g_sigOff;       // barra di conferma / post-bulge
   int iSig = g_sigOff + 1;   // barra del segnale base

   //--- v5.20: barsNeeded cresce di B, altrimenti spostando la finestra
   //    in avanti si accorcerebbe la PORTATA RELATIVA della ricerca
   //    dell'impulso (il VIOLA guarda fino a Lookback_Bars*2 barre
   //    indietro dal segnale). Con B=0 il valore e' quello di prima.
   //    Serve anche a coprire l'indice iSig+6 della banda piatta.
   int barsNeeded = Lookback_Bars * 2 + 10 + g_sigOff;

   double highs[], lows[], opens[], closes[];
   if(!GetBars(sym, barsNeeded, highs, lows, opens, closes)) return;

   //--- v5.20, SCELTA DICHIARATA (era ambigua, e va detto invece di
   //    nasconderla): i FILTRI DI CONTESTO -- AtrOk (ATR di barra 1 vs
   //    la sua media), GetBBWidthMA (larghezza media delle bande) e
   //    AdxFilterOk (ADX di barra 1) -- **NON** sono stati traslati:
   //    continuano a leggere dalla barra 1, cioe' il dato CHIUSO piu'
   //    fresco al momento della decisione.
   //    PERCHE': (1) leggevano gia' barre chiuse, quindi non erano
   //    parte del difetto di R92 e non introducono look-ahead nemmeno
   //    adesso; (2) sono misure di REGIME, non geometria del segnale:
   //    la cosa sensata e' guardarle il piu' vicino possibile
   //    all'istante in cui si apre, non una barra indietro.
   //    CONSEGUENZA da sapere leggendo i numeri: con B=1 questi filtri
   //    valutano la barra SUCCESSIVA a quella del segnale base. Se un
   //    round volesse allinearli al segnale, e' una modifica separata,
   //    con il suo confronto: non e' stata fatta qui.
   if(!AtrOk(symIdx)) return;

   //--- ATR e BB della barra del SEGNALE BASE (chiusa)
   double atrSig = GetATR(symIdx, iSig);
   if(atrSig <= 0) return;

   double bbUpperSig, bbLowerSig, bbBasisSig;
   if(!GetBB(symIdx, iSig, bbUpperSig, bbLowerSig, bbBasisSig)) return;

   // BB Width del segnale e MA
   double bbWidthSig = bbUpperSig - bbLowerSig;
   double bbWidthMA  = GetBBWidthMA(symIdx);
   if(bbWidthMA <= 0) return;
   bool isBulgeSig = (bbWidthSig >= bbWidthMA * Bulge_Multi);

   //--- BB della barra di CONFERMA (con B=1 e' l'ultima chiusa; con
   //    B=0 e' la barra in formazione = il difetto di R92).
   //    E' anche la mediana usata come TP iniziale: la piu' recente
   //    disponibile fra i dati chiusi.
   double bbUpperCnf, bbLowerCnf, bbBasisCnf;
   if(!GetBB(symIdx, iCnf, bbUpperCnf, bbLowerCnf, bbBasisCnf)) return;

   // Pre-carica le serie ATR e BB per il loop impulso (un solo CopyBuffer)
   double atrSeries[];
   double bbUSeries[], bbLSeries[], bbBSeries[];
   if(!GetATRSeries(symIdx, 0, barsNeeded, atrSeries)) return;
   if(!GetBBSeries(symIdx, 0, barsNeeded, bbUSeries, bbLSeries, bbBSeries)) return;

   //----------------------------------------------------------------
   // TROVA ULTIMO IMPULSO
   // v5.20: la ricerca parte da iSig (= B+1), cioe' dalla barra del
   // segnale, non piu' da 1. barsSinceImp* resta un INDICE ASSOLUTO
   // di array (serve a leggere highs[]/lows[] dell'impulso); la
   // distanza da confrontare con Lookback_Bars e' quella RELATIVA al
   // segnale, calcolata sotto (relImp*). Dichiarato apposta: la
   // finestra dell'impulso e' la stessa di prima, solo traslata.
   //----------------------------------------------------------------
   int barsSinceImpDown = -1;
   int barsSinceImpUp   = -1;

   for(int k = iSig; k < barsNeeded - 1; k++)
   {
      double atrK = atrSeries[k];
      double bbUK = bbUSeries[k], bbLK = bbLSeries[k];

      bool impDown = (lows[k]  <= bbLK && closes[k] < opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);
      bool impUp   = (highs[k] >= bbUK && closes[k] > opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);

      if(impDown && barsSinceImpDown < 0) barsSinceImpDown = k;
      if(impUp   && barsSinceImpUp   < 0) barsSinceImpUp   = k;
      if(barsSinceImpDown >= 0 && barsSinceImpUp >= 0) break;
   }

   //--- v5.20: distanza dell'impulso RISPETTO ALLA BARRA DEL SEGNALE.
   //    1 = l'impulso E' la barra del segnale (come nella v5.10, dove
   //    barsSinceImp*=1 significava proprio quello). Con B=0
   //    relImp* == barsSinceImp*: no-op esatto.
   int relImpDown = (barsSinceImpDown < 0) ? -1 : (barsSinceImpDown - g_sigOff);
   int relImpUp   = (barsSinceImpUp   < 0) ? -1 : (barsSinceImpUp   - g_sigOff);

   //----------------------------------------------------------------
   // MEDIANA E BANDA OPPOSTA TOCCATE DOPO IMPULSO
   // v5.20: la scansione parte da iSig, non da 1 -- le barre fra la
   // conferma e il segnale non fanno parte del "dopo l'impulso".
   //----------------------------------------------------------------
   bool midAfterImpDown = false, midAfterImpUp = false;
   bool oppAfterImpDown = false, oppAfterImpUp = false;

   if(barsSinceImpDown > g_sigOff)   // == "> 0" quando B = 0
   {
      for(int k = iSig; k < barsSinceImpDown; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpDown = true; }
         if(highs[k] >= bbUK)                     { oppAfterImpDown = true; }
      }
   }
   if(barsSinceImpUp > g_sigOff)
   {
      for(int k = iSig; k < barsSinceImpUp; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpUp = true; }
         if(lows[k]  <= bbLK)                     { oppAfterImpUp = true; }
      }
   }

   //----------------------------------------------------------------
   // BANDA PIATTA (per POST-BULGE)
   // v5.20: sempre 6 barre PRIMA della barra del segnale -> iSig+6,
   // cioe' g_sigOff+7 (con B=0 e' il vecchio indice 7).
   //----------------------------------------------------------------
   bool lowerFlat = false, upperFlat = false;
   {
      int idxFlat = iSig + 6;   // = g_sigOff + 7
      double bbU6 = bbUSeries[idxFlat], bbL6 = bbLSeries[idxFlat];
      lowerFlat = MathAbs(bbLowerSig - bbL6) <= atrSig * 0.6;
      upperFlat = MathAbs(bbUpperSig - bbU6) <= atrSig * 0.6;
   }

   //----------------------------------------------------------------
   // CANDELA DI REAZIONE SULLA BARRA DEL SEGNALE (iSig)
   //----------------------------------------------------------------
   bool bullReactionSig = (closes[iSig] > opens[iSig] && lows[iSig]  <= bbLowerSig);
   bool bearReactionSig = (closes[iSig] < opens[iSig] && highs[iSig] >= bbUpperSig);

   //----------------------------------------------------------------
   // SEGNALE ORIGINALE SULLA BARRA iSig (base per arancio e blu)
   //----------------------------------------------------------------
   bool origLongSig = isBulgeSig &&
        relImpDown >= 1 && relImpDown <= Lookback_Bars &&
        !midAfterImpDown && !oppAfterImpDown && bullReactionSig;

   bool origShortSig = isBulgeSig &&
        relImpUp >= 1 && relImpUp <= Lookback_Bars &&
        !midAfterImpUp && !oppAfterImpUp && bearReactionSig;

   //----------------------------------------------------------------
   // ARANCIO -- META' BULGE (sulla barra del segnale)
   //----------------------------------------------------------------
   if(Use_Orange)
   {
      if(origLongSig && barsSinceImpDown > g_sigOff)   // == "> 0" quando B = 0
      {
         double impMid = (highs[barsSinceImpDown] + lows[barsSinceImpDown]) / 2.0;
         if(closes[iSig] >= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, true, atrSig, bbBasisSig, InpComment + "_ARANCIO_L");
      }
      if(origShortSig && barsSinceImpUp > g_sigOff)
      {
         double impMid = (highs[barsSinceImpUp] + lows[barsSinceImpUp]) / 2.0;
         if(closes[iSig] <= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, false, atrSig, bbBasisSig, InpComment + "_ARANCIO_S");
      }
   }

   //----------------------------------------------------------------
   // BLU -- 2A CANDELA (conferma sulla barra iCnf)
   // v5.20: QUI viveva meta' del difetto di R92. Con B=0 la conferma
   // pretende closes[0] > opens[0] su una barra appena aperta, dove
   // close == open: FALSO SEMPRE, quindi il BLU non poteva scattare
   // (0 per costruzione sul simbolo del grafico, cioe' su tutto lo
   // scan a un simbolo per passata). Con B=1 la barra e' chiusa.
   // L'ultimo termine confronta con il MINIMO/MASSIMO della barra del
   // SEGNALE (iSig), non della conferma: era lows[1]/highs[1] quando
   // la conferma era 0, e resta la stessa relazione.
   //----------------------------------------------------------------
   if(Use_Blue)
   {
      bool confirmLong  = (closes[iCnf] > opens[iCnf] && !(lows[iCnf]  <= bbLowerCnf) && closes[iCnf] > lows[iSig]);
      bool confirmShort = (closes[iCnf] < opens[iCnf] && !(highs[iCnf] >= bbUpperCnf) && closes[iCnf] < highs[iSig]);

      if(origLongSig  && confirmLong  && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, true,  atrSig, bbBasisCnf, InpComment + "_BLU_L");
      if(origShortSig && confirmShort && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, false, atrSig, bbBasisCnf, InpComment + "_BLU_S");
   }

   //----------------------------------------------------------------
   // VIOLA -- POST-BULGE (sulla barra iCnf)
   // v5.20: e QUI viveva l'altra meta'. Con B=0 la stessa riga rendeva
   // il PINE sempre FALSO (0 trade su 44 celle su 44) e l'EA sempre
   // VERO (|0| <= 1,5xATR): le 106 operazioni di R92 sono tutte VIOLA
   // con la condizione "candela di reazione" DISATTIVATA.
   //----------------------------------------------------------------
   if(Use_Purple)
   {
      // v5.10: le due versioni della condizione (vedi PurpleReactionOk).
      // v5.20: le legge sulla barra di conferma iCnf, con l'ATR della
      //        barra del segnale (iSig) come metro.
      bool reactionLongCnf  = PurpleReactionOk(true,  opens[iCnf], closes[iCnf], atrSig);
      bool reactionShortCnf = PurpleReactionOk(false, opens[iCnf], closes[iCnf], atrSig);

      bool postBulgeLong =
           relImpDown >= 1 && relImpDown <= Lookback_Bars * 2 &&
           midAfterImpDown && !oppAfterImpDown &&
           lows[iCnf] <= bbLowerCnf && lowerFlat &&
           reactionLongCnf;

      bool postBulgeShort =
           relImpUp >= 1 && relImpUp <= Lookback_Bars * 2 &&
           midAfterImpUp && !oppAfterImpUp &&
           highs[iCnf] >= bbUpperCnf && upperFlat &&
           reactionShortCnf;

      if(postBulgeLong  && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, true,  atrSig, bbBasisCnf, InpComment + "_VIOLA_L");
      if(postBulgeShort && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, false, atrSig, bbBasisCnf, InpComment + "_VIOLA_S");
   }
}

//==================================================================
// PARZIALE A R + BREAK-EVEN (da STRATEGY_AUTO)
// - Quando il profitto raggiunge Partial_Close_R volte il rischio,
//   chiude Partial_Close_Pct del volume e sposta SL a BE.
// - Marca la posizione tramite GlobalVariable per non ripetere.
//==================================================================
string PartialDoneKey(ulong ticket)
{
   return "BULGE_M_PC_" + IntegerToString(InpMagic) + "_" + IntegerToString((long)ticket);
}

void DoPartialCloseIfNeeded()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      string key = PartialDoneKey(ticket);
      if(GlobalVariableCheck(key)) continue; // gia' fatto su questa posizione

      string sym    = PositionGetString(POSITION_SYMBOL);
      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double volume = PositionGetDouble(POSITION_VOLUME);
      double curTP  = PositionGetDouble(POSITION_TP);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);

      if(sl <= 0) continue;
      double risk = MathAbs(entry - sl);
      if(risk <= 0) continue;

      double curPrice = (type == POSITION_TYPE_BUY)
                        ? SymbolInfoDouble(sym, SYMBOL_BID)
                        : SymbolInfoDouble(sym, SYMBOL_ASK);
      double profitDist = (type == POSITION_TYPE_BUY) ? (curPrice - entry) : (entry - curPrice);
      double curR = profitDist / risk;
      if(curR < Partial_Close_R) continue;

      // Volume da chiudere (rispetta step/min e lascia un residuo >= lotMin)
      double lotStep = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);
      double lotMin  = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
      if(lotStep <= 0) lotStep = 0.01;
      double closeVol = MathFloor(volume * Partial_Close_Pct / lotStep) * lotStep;
      closeVol = MathMax(lotMin, closeVol);
      if(closeVol >= volume) closeVol = MathFloor((volume - lotMin) / lotStep) * lotStep;
      // 07/08: qui c'era "if(closeVol < lotMin) continue;", che sulla posizione
      // troppo piccola per essere parzializzata saltava anche il BREAK-EVEN e la
      // lasciava a rischio pieno. Adesso il parziale e' facoltativo, il pari no.
      trade.SetTypeFilling(GetFillingMode(sym));

      bool parzOK = false;
      if(closeVol >= lotMin && trade.PositionClosePartial(ticket, closeVol))
      {
         parzOK = true;
         if(InpVerbose) Print("[BULGE] Partial Close | ", sym,
               " | R=", DoubleToString(curR, 2),
               " | Chiusi ", DoubleToString(closeVol, 2), " lotti");
      }
      else if(closeVol < lotMin)
         if(InpVerbose) Print("[BULGE] Parziale impossibile (volume ", DoubleToString(volume, 2),
               " sotto il minimo) | ", sym, " | faccio comunque il BE");

      // Sposta SL a break-even sul residuo (rispetta STOPS_LEVEL)
      bool beOK = false;
      if(PositionSelectByTicket(ticket))
      {
         double newSL  = NormalizeDouble(entry, digits);
         double minDist = (double)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL) * point;
         double nowPrice = (type == POSITION_TYPE_BUY)
                           ? SymbolInfoDouble(sym, SYMBOL_BID)
                           : SymbolInfoDouble(sym, SYMBOL_ASK);
         double slNow  = PositionGetDouble(POSITION_SL);

         // valido se rispetta lo STOPS_LEVEL e se MIGLIORA lo stop (mai arretrare)
         bool beValid = ((type == POSITION_TYPE_BUY)
                         ? ((nowPrice - newSL) > minDist && newSL > slNow)
                         : ((newSL - nowPrice) > minDist && (slNow == 0 || newSL < slNow)));

         if(beValid && trade.PositionModify(ticket, newSL, curTP))
         {
            beOK = true;
            if(InpVerbose) Print("[BULGE] BE impostato | ", sym, " | BE=", DoubleToString(newSL, digits));
         }
      }

      // Marca solo se qualcosa e' andato a buon fine: se il BE non e' passato per
      // lo STOPS_LEVEL, al tick dopo si riprova invece di perderlo per sempre.
      if(parzOK || beOK)
         GlobalVariableSet(key, (double)TimeCurrent());
   }
}

//==================================================================
// GESTIONE ORDINI MANUALI (da CLEAN)
// Su posizioni magic=0: imposta SL=ATR x Manual_SL_ATR_Mult se mancante
// e TP=mediana BB (dinamico). Rispetta STOPS_LEVEL.
//==================================================================
void ManageManualOrders()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != 0) continue; // solo manuali

      string sym = PositionGetString(POSITION_SYMBOL);

      // Serve l'handle in cache: cerca l'indice del simbolo
      int symIdx = SymbolIndex(sym);
      if(symIdx < 0) continue; // simbolo non nel basket: non gestibile via cache

      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl     = PositionGetDouble(POSITION_SL);
      double tp     = PositionGetDouble(POSITION_TP);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
      double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      double minDist= (double)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL) * point;

      double atr = GetATR(symIdx, 1);
      if(atr <= 0) continue;

      double bbU, bbL, bbMid;
      if(!GetBB(symIdx, 1, bbU, bbL, bbMid)) continue;

      double newSL = sl;
      double newTP = NormalizeDouble(bbMid, digits);

      // SL se mancante
      if(sl == 0)
      {
         newSL = (type == POSITION_TYPE_BUY)
                 ? NormalizeDouble(entry - atr * Manual_SL_ATR_Mult, digits)
                 : NormalizeDouble(entry + atr * Manual_SL_ATR_Mult, digits);
      }

      // Valida TP sulla mediana (deve essere dalla parte giusta e oltre STOPS_LEVEL)
      bool tpValid = (type == POSITION_TYPE_BUY)
                     ? (newTP > bid + minDist && newTP > entry)
                     : (newTP < ask - minDist && newTP < entry);
      if(!tpValid) newTP = tp; // se non valido lascia il TP attuale

      bool slChanged = (MathAbs(newSL - sl) > 5 * point);
      bool tpChanged = (MathAbs(newTP - tp) > 5 * point);
      if(slChanged || tpChanged)
         trade.PositionModify(ticket, newSL, newTP);
   }
}

//-- Indice del simbolo nell'array (per accedere alla cache); -1 se assente
int SymbolIndex(string sym)
{
   for(int i = 0; i < g_symbolCount; i++)
      if(g_symbols[i] == sym) return i;
   return -1;
}

//==================================================================
// v5.10 -- GESTIONE (b): BE a 1R + TRAILING A GRADINI DI R
// Traduzione MT4 -> MT5 del Manager di Claudio. Le differenze di
// traduzione, tutte dichiarate:
//   1. il rischio si misura sullo SL INIZIALE (vedi sopra), non su
//      quello corrente: e' la correzione del difetto ereditato;
//   2. una sola PositionModify per tick e per posizione (il MQ4 ne
//      poteva mandare due: una del BE e una del trailing). Il livello
//      scelto e' lo STESSO -- quando il trailing e' attivo (r >= 1,5)
//      il suo target e' sempre oltre il pari, quindi vince lui;
//   3. STOPS_LEVEL del simbolo rispettato prima di mandare la
//      modifica, come fa gia' il resto del file;
//   4. il TP non si tocca MAI: resta quello che UpdateAllTP tiene
//      sulla mediana.
//==================================================================
//-- Il GRADINO del trailing, isolato e PURO: nessuna lettura di conto,
//   nessun ordine. Sta qui fuori perche' e' l'unico pezzo di aritmetica
//   della gestione (b) che si puo' collaudare a tavolino (autotest).
//   Ritorna gli R da bloccare, oppure -1 se il trailing non e' attivo.
double TrailLockR(double r)
{
   if(Trail_Step_R <= 0.0) return -1.0;
   if(r < Trail_Start_R)   return -1.0;
   double steps = MathFloor((r - Trail_Start_R) / Trail_Step_R);
   if(steps < 0) steps = 0;
   double lockR = (Trail_Start_R + steps * Trail_Step_R) - 1.0;
   if(lockR < 0) lockR = 0;
   return lockR;
}

string R0Key(ulong ticket)
{
   return "BULGE_R0_" + IntegerToString(InpMagic) + "_" + IntegerToString((long)ticket);
}

//-- Distanza di rischio INIZIALE del ticket (prezzo, non punti).
//   La prima volta che si vede la posizione la misura e la memorizza.
double R0Dist(ulong ticket, double entry, double slNow)
{
   for(int j = 0; j < ArraySize(g_r0Ticket); j++)
      if(g_r0Ticket[j] == ticket) return g_r0Dist[j];

   double d = 0.0;
   string key = R0Key(ticket);
   if(GlobalVariableCheck(key)) d = GlobalVariableGet(key);   // riavvio: la memoria vera e' questa
   else
   {
      d = MathAbs(entry - slNow);
      if(d > 0.0) GlobalVariableSet(key, d);
   }
   if(d <= 0.0) return 0.0;

   int n = ArraySize(g_r0Ticket);
   ArrayResize(g_r0Ticket, n + 1);
   ArrayResize(g_r0Dist,   n + 1);
   g_r0Ticket[n] = ticket;
   g_r0Dist[n]   = d;
   return d;
}

//-- Riaggancio delle posizioni gia' vive (riavvio dell'EA / del terminale)
void R0RegisterExisting()
{
   if(!Enable_BE_1R && !Enable_Trailing_R) return;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      double sl = PositionGetDouble(POSITION_SL);
      if(sl <= 0) continue;
      R0Dist(ticket, PositionGetDouble(POSITION_PRICE_OPEN), sl);
   }
}

//-- Pulizia: la posizione e' chiusa, via il ticket dalla RAM e la sua GV
void R0Cleanup()
{
   for(int j = ArraySize(g_r0Ticket) - 1; j >= 0; j--)
   {
      if(PositionSelectByTicket(g_r0Ticket[j])) continue;
      string key = R0Key(g_r0Ticket[j]);
      if(GlobalVariableCheck(key)) GlobalVariableDel(key);
      int last = ArraySize(g_r0Ticket) - 1;
      g_r0Ticket[j] = g_r0Ticket[last];
      g_r0Dist[j]   = g_r0Dist[last];
      ArrayResize(g_r0Ticket, last);
      ArrayResize(g_r0Dist,   last);
   }
}

void ManageBeAndTrailing()
{
   if(!Enable_BE_1R && !Enable_Trailing_R) return;   // gestione NUDA: qui non succede niente

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      string sym    = PositionGetString(POSITION_SYMBOL);
      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      double slNow  = PositionGetDouble(POSITION_SL);
      double curTP  = PositionGetDouble(POSITION_TP);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      if(slNow <= 0 || point <= 0) continue;

      double risk = R0Dist(ticket, entry, slNow);   // SL INIZIALE, non corrente
      if(risk <= 0) continue;

      double bid = SymbolInfoDouble(sym, SYMBOL_BID);
      double ask = SymbolInfoDouble(sym, SYMBOL_ASK);
      double curPrice   = (type == POSITION_TYPE_BUY) ? bid : ask;
      double profitDist = (type == POSITION_TYPE_BUY) ? (curPrice - entry) : (entry - curPrice);
      double r = profitDist / risk;

      double newSL = slNow;

      //--- BREAK-EVEN (Manager: DoBreakEvenIfNeeded) ---
      if(Enable_BE_1R && r >= BE_At_R)
      {
         double target = (type == POSITION_TYPE_BUY)
                         ? entry + BE_Offset_Points * point
                         : entry - BE_Offset_Points * point;
         if(type == POSITION_TYPE_BUY) { if(target > newSL) newSL = target; }
         else                          { if(target < newSL) newSL = target; }
      }

      //--- TRAILING A GRADINI DI R (Manager: DoTrailingRIfNeeded) ---
      //    steps = quanti gradini interi oltre lo start; il livello
      //    bloccato e' (start + steps*passo) - 1R, mai sotto zero.
      //    A r=1,5 con passo 0,25 -> lockR = 0,5 -> SL a +0,5R.
      double lockR = Enable_Trailing_R ? TrailLockR(r) : -1.0;
      if(lockR >= 0.0)
      {
         double target = (type == POSITION_TYPE_BUY)
                         ? entry + lockR * risk
                         : entry - lockR * risk;

         // il "movimento minimo" del Manager: non si manda una modifica
         // per due punti, si intasa e basta
         if(type == POSITION_TYPE_BUY)
           { if(target > newSL + Trail_MinMove_Points * point) newSL = target; }
         else
           { if(target < newSL - Trail_MinMove_Points * point) newSL = target; }
      }

      if(MathAbs(newSL - slNow) <= 0.0) continue;
      newSL = NormalizeDouble(newSL, digits);

      //--- STOPS_LEVEL e regola "lo stop non arretra MAI"
      double minDist = (double)SymbolInfoInteger(sym, SYMBOL_TRADE_STOPS_LEVEL) * point;
      bool valido = (type == POSITION_TYPE_BUY)
                    ? ((bid - newSL) > minDist && newSL > slNow)
                    : ((newSL - ask) > minDist && newSL < slNow);
      if(!valido) continue;

      if(trade.PositionModify(ticket, newSL, curTP))   // il TP non si tocca
      {
         if(InpVerbose) Print("[BULGE] GESTIONE(b) | ", sym, " | R=", DoubleToString(r, 2),
                              " | SL ", DoubleToString(slNow, digits),
                              " -> ", DoubleToString(newSL, digits));
      }
   }

   R0Cleanup();
}

//==================================================================
// AGGIORNA TP SULLA MEDIANA AD OGNI TICK (INVARIATO)
// - Mediana dalla barra 1 (chiusa) per stabilita'
// - Non sposta il TP "contro" l'entrata; non tocca lo SL (BE preservato)
//==================================================================
void UpdateAllTP()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;

      string sym    = PositionGetString(POSITION_SYMBOL);
      int    symIdx = SymbolIndex(sym);
      if(symIdx < 0) continue;

      int    type   = (int)PositionGetInteger(POSITION_TYPE);
      double sl     = PositionGetDouble(POSITION_SL);
      double curTP  = PositionGetDouble(POSITION_TP);
      double entry  = PositionGetDouble(POSITION_PRICE_OPEN);
      int    digits = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);

      double bbU, bbL, bbMid;
      if(!GetBB(symIdx, 1, bbU, bbL, bbMid)) continue;
      double newTP = NormalizeDouble(bbMid, digits);

      double ask    = SymbolInfoDouble(sym, SYMBOL_ASK);
      double bid    = SymbolInfoDouble(sym, SYMBOL_BID);
      double point  = SymbolInfoDouble(sym, SYMBOL_POINT);
      double minDist = 10 * point;

      if(type == POSITION_TYPE_BUY)
      {
         if(newTP <= entry)         continue;
         if(newTP <= bid + minDist) continue;
      }
      else if(type == POSITION_TYPE_SELL)
      {
         if(newTP >= entry)         continue;
         if(newTP >= ask - minDist) continue;
      }

      if(MathAbs(newTP - curTP) <= 5 * point) continue;

      trade.PositionModify(ticket, sl, newTP);
   }
}
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei       //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, che e' quello    //
//  che la pipeline di casa legge (walkforward_generico.ps1 /        //
//  scan_market.ps1).  In live e nel backtest singolo e' inerte:     //
//  i frame esistono solo in ottimizzazione.                         //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//------------------------------------------------------------------//
//  v5.11 - LE TRE PEZZE AL CSV DELL'OTTIMIZZAZIONE.                 //
//  Difetto trovato in R92 (44 CSV su 44): header 60 colonne, righe  //
//  65. La causa NON era un frame fantasma: e' che il VALORE di un   //
//  input puo' contenere VIRGOLE, e finiva grezzo dentro un file     //
//  separato da virgole. `News_Block_Hours="7,9,11,12,15,22"` porta  //
//  5 virgole -> 5 campi in piu' PER RIGA, mentre l'header (che usa  //
//  i NOMI, senza virgole) restava di 60. Da li' in poi ogni colonna //
//  aveva il nome sbagliato sopra il valore giusto.                  //
//  Nota: `Symbols_List` col basket intero ne porta altre 21 - lo    //
//  scan la sovrascrive con un simbolo solo, ma non e' garantito.    //
//------------------------------------------------------------------//

//--- (1) un campo CSV che contiene virgole/apici/a-capo va fra virgolette
//    (RFC4180). Cosi' pandas (analyze_optimization.py) e Import-Csv lo
//    rileggono come UN campo solo, virgole comprese, senza perdere il dato.
string OptFrame_CsvField(const string v)
  {
   if(StringFind(v, ",")  < 0 && StringFind(v, "\"") < 0 &&
      StringFind(v, "\n") < 0 && StringFind(v, "\r") < 0)
      return(v);
   string t = v;
   StringReplace(t, "\"", "\"\"");
   return("\"" + t + "\"");
  }

//--- (2) "nome=valore" si spezza al PRIMO '=', non con StringSplit.
//    StringSplit==2 SCARTAVA in silenzio ogni input il cui valore
//    contenesse un '=' (3 pezzi invece di 2): colonna sparita, senza
//    un avviso. Qui il valore puo' contenere tutti gli '=' che vuole.
bool OptFrame_SplitKV(const string s, string &k, string &v)
  {
   int p = StringFind(s, "=");
   if(p <= 0) return(false);
   k = StringSubstr(s, 0, p);
   v = StringSubstr(s, p + 1);
   return(true);
  }

int OptFrame_IndexOf(const string &arr[], const string k)
  {
   int n = ArraySize(arr);
   for(int i = 0; i < n; i++) if(arr[i] == k) return(i);
   return(-1);
  }

//--- per-trade: serve al DD di PORTAFOGLIO (ROTTA_PROP punto 4).
//    Con un basket la colonna 'symbol' non e' decorativa: dice su quale
//    cross e' finito ogni deal anche quando il grafico e' un altro.
//
//    v5.10, DUE AGGIUNTE che non toccano il trading ma cambiano cosa si
//    puo' MISURARE dopo:
//     (a) colonna 'signal' = BLU / VIOLA / ARANCIO. Il tag sta nel
//         commento del deal di APERTURA, non in quello di chiusura (che
//         il broker riscrive in "sl"/"tp"): quindi si fa un primo giro
//         per raccogliere i commenti d'ingresso per position_id, e poi
//         il giro vero. NON si usa HistorySelectByPosition dentro il
//         ciclo: azzererebbe la selezione della history e il ciclo
//         esterno perderebbe i deal. Trappola nota di MT5.
//         >>> E' cosi' che il canarino del BLU diventa MISURABILE dai
//             file del round, senza dover rifare una passata a mano.
//     (b) il nome del file porta anche la VARIANTE DEL VIOLA, altrimenti
//         la seconda cella di ogni corsa sovrascrive la prima e meta'
//         del round sparisce.
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"
             +IntegerToString((long)InpMagic)+"_viola"
             +(Use_Purple_PineReaction?"PINE":"EA")+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","signal","entry_comment","exit_comment");

   int n=HistoryDealsTotal();

   //--- giro 1: i commenti dei deal di APERTURA, per position_id
   long   posId[];  string posCom[];
   int    np=0;
   ArrayResize(posId,n); ArrayResize(posCom,n);
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
      posId[np] =HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      posCom[np]=HistoryDealGetString(tk,DEAL_COMMENT);
      np++;
     }

   //--- giro 2: i deal di CHIUSURA, con il tag ripescato dall'apertura
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);

      long   pid=HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      string comIn="";
      for(int k=0;k<np;k++) if(posId[k]==pid){ comIn=posCom[k]; break; }

      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(pid),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2),
                ExtractSignalTag(comIn,false),
                comIn,
                HistoryDealGetString(tk,DEAL_COMMENT));
     }
   FileClose(h);
  }

//==================================================================
//  IL CONTATORE DEI SEGNALI (solo Print a fine passata).
//  Un solo run nel tester dice QUALE dei tre segnali ha davvero
//  aperto: e' il canarino del punto [DA DECIDERE] (a) in cima al
//  file -- se il BLU fa zero trade, il problema e' il banco di
//  prova, non il mercato. Nessun impatto sul CSV.
//==================================================================
void PrintContaSegnali()
  {
   int nBlu=0, nViola=0, nArancio=0, nAltro=0, nTot=0;
   if(HistorySelect(0,TimeCurrent()))
     {
      int n=HistoryDealsTotal();
      for(int i=0;i<n;i++)
        {
         ulong tk=HistoryDealGetTicket(i);
         if(tk==0) continue;
         if(HistoryDealGetInteger(tk,DEAL_ENTRY)!=DEAL_ENTRY_IN) continue;
         if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=InpMagic)      continue;
         string c=HistoryDealGetString(tk,DEAL_COMMENT);
         nTot++;
         if(StringFind(c,"_BLU_")>=0)          nBlu++;
         else if(StringFind(c,"_VIOLA_")>=0)   nViola++;
         else if(StringFind(c,"_ARANCIO_")>=0) nArancio++;
         else                                  nAltro++;
        }
     }
   PrintFormat("[BULGE-CONTA] %s | aperture=%d -> BLU=%d VIOLA=%d ARANCIO=%d senzaTag=%d | attivi: %s%s%s",
               Symbols_List, nTot, nBlu, nViola, nArancio, nAltro,
               (Use_Orange?"ARANCIO ":""), (Use_Blue?"BLU ":""), (Use_Purple?"VIOLA":""));
   if(Use_Blue && nBlu==0)
      Print("[BULGE-CONTA] CANARINO: il BLU e' acceso e ha aperto ZERO volte. ",
            "Vedi [DA DECIDERE] (a) in cima al file: sul simbolo DEL GRAFICO la ",
            "conferma su barra 0 e' cieca al primo tick. Il numero non e' un verdetto di mercato.");
   if(nAltro>0)
      Print("[BULGE-CONTA] ATTENZIONE: ", nAltro, " aperture senza tag riconoscibile: ",
            "il broker (o il tester) sta riscrivendo il commento. Vedi [DA DECIDERE] (c).");
  }

double OnTester()
  {
   PrintContaSegnali();
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

   ulong pass; string name; long id; double value; double data[];
   string params[]; uint pcount = 0;
   string k = "", v = "";

   //--- (3) l'header NON si prende piu' dalla PRIMA passata iterata.
   //    Prima si fidava di quella: se il flusso dei frame avesse contenuto
   //    un frame di un altro run/altra EA (OPTFRAME_NAME/ID sono le stesse
   //    costanti in ~60 file di casa), lo schema di UNA passata avrebbe
   //    deciso le colonne di TUTTE. Ora si fa un primo giro a vuoto e si
   //    tiene l'UNIONE dei nomi visti in QUALSIASI passata: nessun frame
   //    puo' piu' "vincere" da solo la scelta delle colonne, e ogni riga
   //    viene poi riallineata per NOME, non per posizione.
   string cols[]; ArrayResize(cols, 0);
   //    FrameFirst() riporta il puntatore all'inizio MA azzera il filtro:
   //    quindi il filtro si rimette DOPO, non prima.
   FrameFirst(); FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   while(FrameNext(pass, name, id, value, data))
     {
      if(ArraySize(data) < 10) continue;   // frame di uno schema diverso: si salta
      pcount = 0; FrameInputs(pass, params, pcount);
      for(uint i = 0; i < pcount; i++)
        {
         if(!OptFrame_SplitKV(params[i], k, v)) continue;
         if(OptFrame_IndexOf(cols, k) >= 0)    continue;
         int n = ArraySize(cols); ArrayResize(cols, n + 1); cols[n] = k;
        }
     }
   int ncol = ArraySize(cols);

   string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
   for(int i = 0; i < ncol; i++) head += "," + OptFrame_CsvField(cols[i]);
   FileWrite(h, head);

   //--- secondo giro: le righe, una colonna per nome dell'unione.
   //    Le prime 11 restano lo StringFormat fisso di sempre (erano gia'
   //    corrette anche col difetto: il verdetto di R92 su n/PF/DD e' salvo).
   int righe = 0, scartati = 0;
   string vals[]; ArrayResize(vals, ncol);
   FrameFirst(); FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   while(FrameNext(pass, name, id, value, data))
     {
      if(ArraySize(data) < 10) { scartati++; continue; }
      for(int i = 0; i < ncol; i++) vals[i] = "";
      pcount = 0; FrameInputs(pass, params, pcount);
      for(uint i = 0; i < pcount; i++)
        {
         if(!OptFrame_SplitKV(params[i], k, v)) continue;
         int c = OptFrame_IndexOf(cols, k);
         if(c >= 0) vals[c] = v;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(int i = 0; i < ncol; i++) row += "," + OptFrame_CsvField(vals[i]);
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate (%d colonne: 11 fisse + %d input) in MQL5\\Files\\%s",
               righe, 11 + ncol, ncol, fname);
   if(scartati > 0)
      PrintFormat("OptFrame: ATTENZIONE, %d frame SCARTATI (meno di 10 statistiche): "
                  "schema diverso, probabile residuo di un altro run/altra EA.", scartati);
  }
//================== fine OPTFRAME inlined ==========================//
