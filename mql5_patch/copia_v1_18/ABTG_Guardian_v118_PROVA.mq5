//+------------------------------------------------------------------+
//|                                              ABTG_Guardian.mq5    |
//|  GUARDIANO DI PORTAFOGLIO -- fa rispettare le regole di una prop  |
//|  sull'INTERO conto. Da usare SOLO sul demo 109k per il dry-run,   |
//|  NON sul conto forward (li' vogliamo il comportamento grezzo).    |
//|                                                                   |
//|  Modo A (autonomo): quando scatta un limite, CHIUDE TUTTO         |
//|  (posizioni + pendenti, di QUALSIASI magic) e BLOCCA i nuovi      |
//|  trade fino al reset giornaliero (stop giornaliero) o per sempre  |
//|  (stop DD totale = challenge fallita). Non serve toccare gli      |
//|  altri EA: il guardiano governa tutto il conto da solo.           |
//|                                                                   |
//|  Sorveglia via OnTimer (ogni secondo). Persiste i riferimenti in  |
//|  GlobalVariable, cosi' sopravvive a riavvii/ricompilazioni.       |
//|                                                                   |
//|  v1.10 (18/08/2026) -- FIRME di Claudio, report/FIRME_2026-08-18: |
//|   B1 PAUSA MORBIDA giornaliera: sotto -InpDailyPausePct il        |
//|      guardiano NON chiude niente, scrive solo una GlobalVariable  |
//|      di pausa che gli EA leggono PRIMA di aprire (modello         |
//|      "sibling" della raccolta set). Resta fino al reset del       |
//|      giorno prop, anche se l'equity risale (latch).               |
//|   C1 CAP RISCHIO APERTO: somma degli SL vivi in % dell'equity;    |
//|      oltre InpMaxOpenRiskPct scrive la GlobalVariable di cap.     |
//|      Anche qui NON chiude niente: blocca solo i nuovi ingressi.   |
//|   BATTITO: GlobalVariable aggiornata a ogni giro di timer, cosi'  |
//|      un EA capisce se il guardiano e' morto (fail-open sul cap).  |
//|   Lettura lato EA: mql5/Include/ABTG_PausaGuardian.mqh            |
//|   La logica di lockdown (chiudi+blocca) e' rimasta INTOCCATA.     |
//|                                                                   |
//|  Tutto-in-uno: compila con F7. Usa solo Trade.mqh (standard MT5). |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.18"
#property strict
#include <Trade/Trade.mqh>
//  v1.11 -- 19/08/2026. Il calcolo del cap e la scrittura delle bandiere
//  c'erano gia' in v1.10 e NON sono stati toccati: il conto si comporta
//  esattamente come ieri. Aggiunte due sole cose, entrambe di sola lettura:
//   1) la VERIFICA DEL FILO in OnInit -- il guardiano costruisce i nomi
//      delle GlobalVariable qui, gli EA li costruiscono nell'include:
//      due posti diversi. Se un giorno divergono, il canale muore in
//      SILENZIO (il guardiano scrive, nessuno legge, nessun errore).
//      Ora il guardiano confronta i propri nomi con quelli dell'include
//      e, se non coincidono, urla nel giornale.
//   2) l'AUTOTEST del nucleo di decisione (input InpAutotest, default
//      spento), cosi' il collaudo non dipende da un altro programma.
//  v1.12 -- 06/09/2026. BUG TROVATO SUL CONTO REALE (credito broker
//  stabile e non prelevabile, scoperto quel giorno): il saldo iniziale
//  e la baseline giornaliera venivano catturati dal BILANCIO (senza
//  credito), ma confrontati con l'EQUITA' corrente (con credito dentro).
//  Il credito, essendo costante, appariva come un "guadagno" permanente
//  che si sommava al cuscinetto reale -- coi numeri di quel giorno
//  (bilancio 5.000, credito 2.500) la pausa al 4,9% e il blocco al 9,9%
//  non sarebbero scattati fino a una perdita REALE di oltre 2.700/3.000
//  euro, cioe' oltre meta' del capitale vero. Fix: gStart e la baseline
//  giornaliera ora si catturano dall'EQUITA', non dal bilancio -- stessa
//  base su entrambi i lati del confronto, il credito si cancella da solo
//  e le soglie tornano a mordere ai punti percentuali dichiarati.
//  Le GlobalVariable di saldo/picco/giorno cambiano nome (suffisso _V2):
//  un conto gia' in campo con la v1.11 ha quei valori scritti col vecchio
//  criterio, e "sopravvivono a riavvii/ricompilazioni" e' voluto (persist-
//  enza) -- senza il nome nuovo la ricompilazione riletterebbe il vecchio
//  numero contaminato invece di ricatturarlo pulito. Nessun reset a mano
//  da F3 necessario: la cattura fresca e' automatica al primo avvio.
//  v1.13 -- 07/09/2026. TETTO DI RISCHIO APERTO PER CLUSTER CORRELATO
//  (C2), firmato da Claudio il 07/09 -- verbale report/FIRME_2026-09-07.md,
//  che lo dichiara testualmente "FIRMATO MA NON ATTIVO: nel Guardian il
//  tetto per cluster non esiste ancora". Adesso esiste.
//  PERCHE', misurato (dossier caccia_strategie/CONFIG_PROP_FREQUENZA_2026-09-06):
//  i due portafogli "prop firm ready" a larga base letti hanno drawdown
//  MISURATI del 32,59% e del 45,64%. La larghezza SENZA controllo della
//  correlazione e' la trappola, ed e' esattamente il rischio che la firma
//  gemella dello stesso giorno (pavimento di frequenza per FAMIGLIA = piu'
//  simboli) rende piu' probabile.
//  COME FUNZIONA: il guardiano somma il rischio degli SL vivi separatamente
//  per ogni CLUSTER dichiarato e, per ogni cluster oltre il tetto, timbra
//  una GlobalVariable dedicata -- lo STESSO meccanismo di C1, quindi lo
//  stesso fail-open (se il guardiano muore, il timbro invecchia e il tetto
//  scade da solo). Come C1, NON chiude niente: blocca i nuovi ingressi
//  degli EA che leggono il canale con ABTG_PausaGuardian.mqh.
//  STA ACCANTO A C1, NON AL SUO POSTO: C1 guarda il conto intero (3,25%),
//  C2 guarda un gruppo correlato (3,0%). Vince il piu' stringente dei due,
//  senza che nessuno dei due debba saperlo dell'altro.
//  DEFAULT = NO-OP ASSOLUTO: InpMaxClusterRiskPct=0 e InpClusterMappa=""
//  -> la mappa non viene nemmeno letta, nessuna GlobalVariable nuova viene
//  creata, nessuna riga nuova compare nel giornale, il pannello resta
//  identico. Su un conto in campo non cambia nulla finche' Claudio non
//  firma la mappa (proposta: report/CLUSTER_PROPOSTA.md) e non la scrive
//  nell'input.
//  IL CONFINE DEL CONTROLLO, dichiarato: come C1, C2 somma solo le
//  POSIZIONI con SL (buco B6: i pendenti non si contano, le posizioni
//  senza SL sono rischio ignoto ed escluse). E' un LIMITE INFERIORE del
//  rischio impegnato, non una misura esatta.
//  v1.14 -- 08/09/2026. MODO DICHIARATO PER LA BASELINE GIORNALIERA
//  (input InpDailyBaseline), nato dal dossier report/REGOLAMENTI_PROP_
//  2026-09-08.md par. 3.1 + "VERIFICA DI CLAUDE".
//  PERCHE' ESISTE: le prop NON misurano la giornata come noi. FTMO parte
//  dal SALDO registrato alle 00:00 CE(S)T; FundingPips dal PIU' ALTO fra
//  saldo ed equita' di apertura. Noi partiamo dall'EQUITA'. Se al reset
//  c'e' una posizione aperta in perdita flottante, l'equita' e' PIU'
//  BASSA del saldo e il nostro pavimento scende con lei mentre il loro
//  resta fermo: numeri del dossier, 100k con -0,8% flottante al reset ->
//  pavimento FTMO 95.000, nostro 94.200. Nel verso sbagliato: siamo PIU'
//  PERMISSIVI della prop, cioe' la challenge puo' essere gia' violata
//  mentre il guardiano e' ancora "in pausa morbida". Riguarda solo le
//  sedie che tengono posizioni attraverso l'ora del reset -- e la flotta
//  ne ha (le swing multi-day di report/ROTTA_PROP.md).
//  PERCHE' IL DEFAULT RESTA L'EQUITA': perche' tornare al bilancio
//  riaprirebbe il bug PAGATO sul conto REALE il 06/09 (vedi v1.12 qui
//  sopra): li' il broker tiene un CREDITO stabile e non prelevabile
//  (bilancio 5.000, credito 2.500) e una baseline presa dal bilancio,
//  confrontata con l'equita', trasformerebbe quel credito in un
//  cuscinetto falso da 2.500 euro. Le due esigenze sono entrambe vere,
//  ma su CONTI DIVERSI: per questo e' un MODO, non una correzione.
//  DEFAULT = NO-OP: InpDailyBaseline=0 e' esattamente la v1.13 (baseline
//  = equita'). Nessuna soglia, nessun cap, nessuna logica di chiusura e'
//  stata toccata. L'unica differenza visibile a default e' la riga di
//  giornale del nuovo giorno prop, che ora DICHIARA il modo: una
//  protezione che non dice come sta misurando non e' verificabile.
//  E' UNA FIRMA DI CLAUDIO: quale modo va su quale conto NON lo decide
//  l'EA e non lo decide chi scrive il codice. Il modo non e' in nessun
//  preset. Bussola: REALE (col credito) = 0 EQUITA' . prop FTMO = 1
//  SALDO . FundingPips/The5ers = 2 MAX. E i regolamenti citati sono
//  [LETTO-VIA-SEARCH], non letture dirette: prima di pagare una fee
//  vanno confermati da Claudio sul sito o per iscritto dal supporto.
#include <ABTG_PausaGuardian.mqh>

//--- SALDO / REGOLE PROP -------------------------------------------
input double InpStartBalance   = 0;      // Saldo iniziale challenge (0 = cattura in automatico al primo avvio). Es. 109000
input double InpDailyLossPct   = 5.0;    // Limite PERDITA GIORNALIERA (% del saldo iniziale)
input double InpTotalDDPct     = 10.0;   // Limite DRAWDOWN TOTALE (% del saldo iniziale)
input int    InpDDMode         = 0;      // DD totale: 0=STATICO (dal saldo iniziale) . 1=TRAILING (dal picco equity)
input int    InpDailyResetHour = 0;      // Ora SERVER in cui azzera il contatore giornaliero (0=mezzanotte broker)
//--- MODO DELLA BASELINE GIORNALIERA (v1.14, 08/09/2026) ------------
//  Da quale grandezza parte il conteggio della perdita del giorno.
//  OPT-IN e NO-OP di default, stessa forma del cap C2 qui sotto: a 0 il
//  guardiano si comporta ESATTAMENTE come la v1.13.
//    0 = EQUITA' (default, come oggi)  -- l'unico sicuro sul conto REALE,
//        dove il credito del broker contamina il bilancio (fix v1.12).
//    1 = SALDO                         -- il criterio di FTMO (saldo alle
//        00:00 CE(S)T). Su un conto CON CREDITO riaprirebbe il bug del
//        06/09: NON usarlo li'.
//    2 = MAX(saldo,equita)             -- il criterio di FundingPips, il
//        piu' prudente dei tre: non sta mai sotto nessuno dei due.
//  Valori fuori scala ripiegano sul default (0). La scelta del modo per
//  un conto e' una FIRMA DI CLAUDIO, non una decisione dell'EA.
input int    InpDailyBaseline  = 0;      // Baseline giornaliera: 0=EQUITA' (come oggi) . 1=SALDO (FTMO) . 2=MAX(saldo,equita)
//--- PAUSA MORBIDA E CAP RISCHIO (firme 18/08/2026) -----------------
//  Questi due NON chiudono e NON bloccano niente da soli: scrivono
//  GlobalVariable che gli EA leggono prima di aprire. Finche' nessun
//  EA e' migrato all'include, il comportamento del conto NON cambia.
input double InpDailyPausePct  = 4.0;    // PAUSA MORBIDA: perdita giornaliera % che blocca i NUOVI ingressi (0=spenta)
input double InpMaxOpenRiskPct = 3.25;   // CAP C1: rischio aperto simultaneo massimo, % equity (0=spento). 3.25 = 5 SL vivi da 0,65%
input int    InpRiskMode       = 0;      // Rischio aperto: 0=dall'INGRESSO (come la misura M2) . 1=dal PREZZO CORRENTE (perdita residua)
input bool   InpWarnNoSL       = true;   // logga un warning per le posizioni SENZA stop loss (rischio ignoto, non bloccante)
//--- CAP C2 PER CLUSTER CORRELATO (firma 07/09/2026) -----------------
//  OPT-IN e NO-OP di default: a tetto 0 O mappa vuota il guardiano si
//  comporta ESATTAMENTE come la v1.12, senza leggere e senza scrivere
//  niente in piu'. La MAPPA e' una SCELTA di Claudio e va firmata a parte
//  (il verbale del 07/09 lo dice testualmente): la proposta sta in
//  report/CLUSTER_PROPOSTA.md e NON e' in nessun preset.
//  Formato: "NOME=SYM,SYM;NOME2=SYM3"  -- tetto proprio opzionale con ':'
//  ("AZIONARIO:3.5=D30EUR,U30USD"), jolly finale per i suffissi broker
//  ("XAUUSD*"). Un simbolo puo' stare in piu' cluster.
input double InpMaxClusterRiskPct = 0;   // CAP C2: rischio aperto massimo per CLUSTER, % equity (0=spento). Firma 07/09: 3.0
input string InpClusterMappa      = "";  // CAP C2: mappa dei cluster ("" = spento). Es. USD=EURUSD,GBPUSD;METALLI=XAUUSD,XAGUSD
//--- E1 -- TETTO DI ESPOSIZIONE (v1.15, 19/10/2026) -----------------
//  PERCHE': il 19/10/2026 sul conto reale una griglia (Arena Nexus Grid)
//  ha aperto 15 BUY senza stop contro il calo, da 0,01 a 0,17 lotti
//  (0,89 lotti insieme): il saldo era +347 ma l'equity era gia' sotto il
//  limite giornaliero; il lockdown e' arrivato quando la perdita era
//  -838. Il lockdown guarda l'equity e arriva TARDI. Questo tetto guarda
//  la DIMENSIONE (lotti e numero di posizioni) e agisce PRIMA, su quanto
//  e' gia' aperto, indipendentemente dal prezzo e dagli stop.
//  OPT-IN e NO-OP di default: a 0 e 0 il guardiano si comporta ESATTAMENTE
//  come la v1.14 (nessun giro sulle posizioni in piu', nessuna riga).
//  I VALORI non li decide l'EA ne' chi scrive il codice: sono una scelta
//  di Claudio (taglia/rischio del conto).
//  NETTO: una griglia a due lati apre buy E sell insieme: i lotti TOTALI
//  includono la parte coperta. Il 19/10 il netto lungo ha raggiunto 0,83
//  lotti alle 14:43:39 mentre il totale era 0,87. Il tetto NETTO misura
//  la direzione scoperta (per simbolo), che e' quella che fa male.
//  Azione 0 = CANCELLA i pendenti (nessuno stop/limit puo' scattare e
//             far crescere l'esposizione; le posizioni gia' aperte restano)
//  Azione 1 = come 0 E CHIUDE le posizioni PIU' RECENTI finche' rientra
//             nel tetto (realizza la perdita di quelle: e' il costo)
//  Azione 2 = SOLO ALLARME (log e pannello, non tocca niente)
//  Un EA di terzi che apre a MERCATO puo' superare il tetto di un passo
//  entro 1 secondo (il guardiano controlla ogni secondo).
input double InpMaxTotalLots     = 0;   // E1: lotti totali aperti insieme, massimo (0=spento). Esempio: 0.30
input int    InpMaxOpenPositions = 0;   // E1: posizioni aperte insieme, massimo (0=spento). Esempio: 10
input double InpMaxNetLots       = 0;   // E1: esposizione NETTA massima su UN simbolo, |lotti buy - lotti sell| (0=spento). Esempio: 0.30
input int    InpExposureAction   = 1;   // E1: 0=cancella i pendenti . 1=cancella i pendenti E chiude le piu' recenti . 2=solo allarme
//--- F1 -- CHIUSURA DEL VENERDI' (v1.16, 07/11/2026) ----------------
//  Per i conti FTMO "Standard finanziati" (riassunto del 07/11, DA
//  VERIFICARE con FTMO): niente posizioni aperte nel weekend. Spento di
//  default = NESSUNA azione e nessuna riga in piu' nel giornale.
//  Quando e' acceso, il VENERDI' da (chiusura reale del mercato - N ore)
//  fino alla chiusura: chiude tutte le posizioni, cancella tutti i
//  pendenti (di QUALSIASI magic se InpCloseAllMagics) e ricaccia indietro
//  ogni nuovo ordine ogni secondo; accende anche la pausa nuovi ingressi
//  per gli EA ABTG. La chiusura del mercato si LEGGE dal broker
//  (SymbolInfoSessionTrade, ultima sessione del venerdi'), non e' un'ora
//  fissa: cambia di un'ora col cambio d'ora. Se non si legge, usa il
//  fallback (prudente: presto). Con InpAction=1 (solo allarme) scrive e basta.
input bool   InpFriEnable       = false;  // F1: chiudi tutto il venerdi' prima della chiusura del mercato (spento = nessuna azione)
input double InpFriHoursBefore  = 3.0;    // F1: ore PRIMA della chiusura reale del mercato in cui scatta (3.0 = tre ore prima)
input string InpFriSymbol       = "";     // F1: simbolo da cui leggere l'orario della sessione del venerdi' ("" = simbolo del grafico; consigliato XAUUSD)
input int    InpFriFallbackMin  = 1260;   // F1: minuti dalla mezzanotte SERVER della chiusura, se la sessione non si legge (1260 = 21:00)
//--- R1 (v1.17, 07/11/2026): CONTATORE DELLE RICHIESTE AL SERVER PER GIORNO.
//  FTMO (pratiche vietate, pagina letta il 07/11 via estensione): "piu di 2.000
//  richieste al server al giorno" su ordini/pendenti aperti, MODIFICATI o chiusi
//  = EA "iperattivo". Il Guardian conta gli eventi dell'intero conto (di
//  QUALSIASI EA) con OnTradeTransaction: nuovi ordini (aperture e chiusure a
//  mercato, pendenti), modifiche di SL/TP delle posizioni, modifiche e
//  cancellazioni dei pendenti. E' una STIMA per eccesso: NON VERIFICATO che
//  coincida col conteggio di FTMO (che cosa conti e da che ora non e' scritto).
//  Spento di default = nessuna GlobalVariable e nessuna riga in piu'.
//  Il giorno e' quello "prop" (InpDailyResetHour). L'azione 1 mette la pausa
//  nuovi ingressi per gli EA ABTG: gli EA di terzi NON la leggono e il
//  Guardian NON puo' fermare le loro modifiche senza chiudere tutto.
input bool   InpReqEnable       = false;  // R1: conta le richieste al server del giorno (spento = nessuna azione)
input int    InpReqWarn         = 1000;   // R1: soglia di AVVISO (log + Alert una volta al giorno)
input int    InpReqAlarm        = 1600;   // R1: soglia di ALLARME (log + Alert; FTMO: 2000 = vietato)
input int    InpReqAction       = 0;      // R1: 0=solo avvisi . 1=all'allarme anche pausa nuovi ingressi fino al reset
//--- P1 (v1.18, 10/11/2026): COMPORTAMENTO NELLA PAUSA (stato BLOCCATO/FALLITO e chiusura del venerdi').
//  Causa osservata sul conto di prova FTMO 1515150476 (09-10/11): con il
//  Guardian bloccato, FlattenAll() girava OGNI SECONDO e cancellava ogni
//  pendente di QUALSIASI EA; gli EA di Wim non leggono la pausa e lo
//  rimettevano subito -> ciclo piazza/cancella (760 piazzati / 796
//  cancellati in 4 ore, 748 nello stesso minuto) = richieste al server.
//  Qui si cambia SOLO la ripetizione nella pausa. Al momento dello scatto
//  (limite sfondato, o inizio finestra del venerdi') si fa SEMPRE un
//  FlattenAll() completo, come prima. Le POSIZIONI aperte si chiudono
//  SEMPRE entro 1 secondo, in tutti i modi.
//  0 = com'era (v1.17): cancella ogni pendente ogni secondo. DEFAULT.
//  1 = cancella solo i pendenti VICINI al prezzo (entro InpPauseNearPct %): gli altri restano.
//  2 = non cancella nessun pendente dopo lo scatto; chiude solo le posizioni che compaiono.
//  3 = cancella tutti i pendenti, ma al massimo ogni InpPauseEverySec secondi.
//  Un pendente lasciato vivo che scatta diventa posizione e viene chiusa
//  entro 1 secondo: perdita extra = slittamento di quel secondo (da misurare).
input int    InpPauseMode      = 0;      // P1: 0=come prima . 1=solo pendenti vicini . 2=nessun pendente cancellato . 3=cancella ogni N secondi
input double InpPauseNearPct   = 1.0;    // P1 modo 1: distanza massima dal prezzo (in %) entro cui un pendente si cancella
input int    InpPauseEverySec  = 60;     // P1 modo 3: intervallo minimo tra due cancellazioni complete (secondi)
input int    InpPauseMaxDelDay = 300;    // P1: tetto di cancellazioni di pendenti al giorno dal Guardian dopo lo scatto (modi 1-3; 0=nessun tetto). Le posizioni si chiudono sempre
input int    InpPauseRetrySec  = 30;     // P1: se la chiusura e' rifiutata (mercato chiuso ecc.) riprova al massimo ogni N secondi
input int    InpPauseLogSec    = 300;    // P1: una riga di riepilogo ogni N secondi, solo se ha agito (modi 1-3); le righe singole non si scrivono
//--- COMPORTAMENTO -------------------------------------------------
input int    InpAction         = 0;      // 0=CHIUDI+BLOCCA (enforce) . 1=SOLO ALLARME (monitor, non chiude)
input bool   InpCloseAllMagics = true;   // true=chiude posizioni/pendenti di QUALSIASI magic (tutto il conto)
input bool   InpShowPanel      = true;   // mostra pannello di stato sul grafico
input long   InpMagic          = 779001; // magic del guardiano (per i suoi log)
input string InpComment        = "GUARDIAN"; // commento
input bool   InpVerbose        = true;   // log dettagliato nel giornale
input bool   InpAutotest       = false;  // AUTOTEST: all'avvio esegue i casi del canale (pausa/cap/battito) e scrive l'esito nel giornale. Non tocca il conto

//--- nomi GlobalVariable (persistono nel terminale) ----------------
string GV_START, GV_PEAK, GV_DAYKEY, GV_DAYSTART, GV_BLOCKDAY, GV_FAILED;
//--- canale verso gli EA (leggerli con Include/ABTG_PausaGuardian.mqh)
//    ATTENZIONE: se cambi questi nomi, cambiali ANCHE nell'include.
string GV_PAUSA, GV_PAUSAFINO, GV_CAP, GV_RISKPCT, GV_BATTITO;
string GV_REQ, GV_REQDAY;        // R1 (v1.17): solo se InpReqEnable
int    gReqCat[5];               // R1: [1]=nuovi ordini [2]=SL/TP posizioni [3]=modifica pendenti [4]=cancella pendenti
int    gReqLivello=0;            // R1: 0=ok 1=avviso gia dato 2=allarme gia dato (oggi)
int    gReqBase=0;               // R1: totale gia contato prima di un riavvio dello stesso giorno (senza categorie)

//--- P1 (v1.18): stato della ripetizione nella pausa
long     gPauseKey[2]={0,0};     // per slot (0=bloccato/fallito, 1=venerdi'): chiave dello stato per cui il FlattenAll completo e' gia' stato fatto (0=nessuno)
datetime gPauseLastFull=0;       // modo 3: ultima cancellazione completa
datetime gPauseLastFail=0;       // ultimo rifiuto di una chiusura
int      gPauseDelDay=0;         // cancellazioni di pendenti dopo lo scatto, oggi
int      gPauseDayKey=0;
int      gPauseNDel=0,gPauseNClose=0,gPauseNFail=0;   // contatori dell'intervallo di log
int      gPauseReqDay=0;         // richieste fatte dal Guardian dopo lo scatto, oggi (riuscite + rifiutate)
datetime gPauseLogT=0;

CTrade gTrade;
double gStart=0, gPeak=0;
datetime gLastLog=0, gLastWarnNoSL=0;
//--- C2: la mappa dei cluster, letta UNA volta in OnInit.
//    gClN=0 vuol dire SPENTO, ed e' il default: con 0 cluster nessuna
//    funzione nuova viene chiamata e nessuna GlobalVariable viene creata.
string   gClNomi[], gClMembri[];
double   gClTetti[];
bool     gClAttivo[];        // stato precedente, per scrivere solo al CAMBIO
int      gClN=0;

//+------------------------------------------------------------------+
int DayKey(datetime t){ MqlDateTime s; TimeToStruct(t,s); return s.year*1000+s.day_of_year; }

//+------------------------------------------------------------------+
//| Giorno "prop": cambia allo scoccare di InpDailyResetHour (server)|
//+------------------------------------------------------------------+
int PropDayKey()
  {
   datetime t=TimeCurrent();
   // sposto indietro l'orologio dell'ora di reset, cosi' il "giorno" scatta a InpDailyResetHour
   datetime shifted = t - (datetime)InpDailyResetHour*3600;
   return DayKey(shifted);
  }

//+------------------------------------------------------------------+
//| Istante (server) del PROSSIMO reset giornaliero.                 |
//| Serve a dare una SCADENZA alla pausa: se il guardiano muore       |
//| mentre la pausa e' attiva, gli EA non restano fermi per sempre.   |
//+------------------------------------------------------------------+
datetime NextResetTime()
  {
   datetime t=TimeCurrent();
   int h=InpDailyResetHour; if(h<0) h=0; if(h>23) h=23;   // input a prova di dito
   MqlDateTime s; TimeToStruct(t,s);
   s.hour=h; s.min=0; s.sec=0;
   datetime r=StructToTime(s);
   if(r<=t) r+=86400;                 // gia' passata oggi -> domani
   return(r);
  }

//+------------------------------------------------------------------+
//| v1.14 -- BASELINE DELLA GIORNATA.                                 |
//| La grandezza da cui parte il conteggio della perdita giornaliera. |
//| Funzione PURA: non legge il conto, non tocca GlobalVariable --    |
//| prende i due numeri e il modo e restituisce la baseline. E' pura  |
//| APPOSTA, cosi' l'autotest la collauda senza toccare niente.       |
//|   0 = EQUITA'  -> come v1.12/v1.13: comportamento invariato       |
//|   1 = SALDO    -> criterio FTMO (saldo alle 00:00 CE(S)T)         |
//|   2 = MAX      -> criterio FundingPips (il piu' alto dei due)     |
//| Qualsiasi altro valore ripiega sul DEFAULT: un input sbagliato    |
//| non deve MAI cambiare da solo il comportamento in campo.          |
//+------------------------------------------------------------------+
double BaselineGiorno_Calc(const double bal,const double eq,const int modo)
  {
   if(modo==1) return(bal);
   if(modo==2) return(MathMax(bal,eq));
   return(eq);                       // 0 e qualunque valore fuori scala
  }

//+------------------------------------------------------------------+
//| Il nome del modo, per il giornale e per il pannello. Una          |
//| protezione che non dichiara COME sta misurando non e'             |
//| verificabile da un censimento.                                    |
//+------------------------------------------------------------------+
string BaselineModoTesto(const int modo)
  {
   if(modo==1) return("SALDO");
   if(modo==2) return("MAX(saldo,equita)");
   if(modo==0) return("EQUITA'");
   return("EQUITA' (ripiego: input fuori scala)");
  }

//+------------------------------------------------------------------+
//| v1.14 -- AUTOTEST del modo della baseline (gira solo con          |
//| InpAutotest=true, all'avvio, e NON tocca il conto).               |
//| Sta QUI e non nell'include apposta: l'include e' condiviso con    |
//| tutti gli altri EA e il conteggio dei suoi casi (159, marcatore   |
//| v1.60) e' un cancello di collaudo -- il modo della baseline e'    |
//| roba del solo guardiano e non deve spostare quel numero.          |
//+------------------------------------------------------------------+
bool ExposureEccede(const double lots,const int npos,const double netAbs,const double capLots,const int capPos,const double capNet);   // prototipo (definita prima di OnTimer)
//--- v1.15: AUTOTEST del tetto di esposizione (funzione pura, conto non toccato)
int AutotestEsposizione()
  {
   int falliti=0;
   Print("[AUTOTEST] ABTG_Guardian v1.15 -- TETTO DI ESPOSIZIONE (funzione pura, conto non toccato)");
   ABTG_AutotestCaso("spento (0,0,0): non eccede mai", !ExposureEccede(5.0,50,4.0,0.0,0,0.0), true, falliti);
   ABTG_AutotestCaso("0,89 lotti con tetto 0,30: eccede", ExposureEccede(0.89,14,0.83,0.30,0,0.0), true, falliti);
   ABTG_AutotestCaso("0,30 lotti con tetto 0,30: NON eccede (uguale)", !ExposureEccede(0.30,3,0.10,0.30,0,0.0), true, falliti);
   ABTG_AutotestCaso("11 posizioni con tetto 10: eccede", ExposureEccede(0.11,11,0.11,0.0,10,0.0), true, falliti);
   ABTG_AutotestCaso("10 posizioni con tetto 10: NON eccede", !ExposureEccede(0.10,10,0.10,0.0,10,0.0), true, falliti);
   ABTG_AutotestCaso("totale 0,87 ma netto 0,05 con tetto netto 0,30: NON eccede (coperto)", !ExposureEccede(0.87,20,0.05,0.0,0,0.30), true, falliti);
   ABTG_AutotestCaso("netto 0,83 con tetto netto 0,30: eccede", ExposureEccede(0.87,14,0.83,0.0,0,0.30), true, falliti);
   ABTG_AutotestCaso("netto 0,30 con tetto netto 0,30: NON eccede (uguale)", !ExposureEccede(0.50,6,0.30,0.0,0,0.30), true, falliti);
   return(falliti);
  }

bool BaselineUguale(const double a,const double b){ return(MathAbs(a-b)<0.005); }

//+------------------------------------------------------------------+
//| F1 (v1.16) -- CHIUSURA DEL VENERDI'. Funzione PURA: non legge il  |
//| conto ne' il broker. Vera se, in minuti dalla mezzanotte server,  |
//| "adesso" sta nella finestra [chiusura - ore*60 , chiusura).       |
//+------------------------------------------------------------------+
bool FriInFinestra(const int minAdesso,const int minChiusura,const double oreP)
  {
   if(minChiusura<=0 || oreP<=0.0) return(false);
   int inizio=minChiusura-(int)MathRound(oreP*60.0);
   return(minAdesso>=inizio && minAdesso<minChiusura);
  }
//--- v1.16: AUTOTEST della finestra del venerdi' (funzione pura, conto non toccato)
int AutotestVenerdi()
  {
   int falliti=0;
   Print("[AUTOTEST] ABTG_Guardian v1.16 -- CHIUSURA DEL VENERDI' (funzione pura, conto non toccato)");
   // chiusura 21:55 = 1315 min; 3 ore prima = 18:55 = 1135 min
   ABTG_AutotestCaso("18:54 con chiusura 21:55 e 3 ore: FUORI", !FriInFinestra(1134,1315,3.0), true, falliti);
   ABTG_AutotestCaso("18:55 con chiusura 21:55 e 3 ore: DENTRO", FriInFinestra(1135,1315,3.0), true, falliti);
   ABTG_AutotestCaso("21:54 con chiusura 21:55: DENTRO", FriInFinestra(1314,1315,3.0), true, falliti);
   ABTG_AutotestCaso("21:55 = chiusura: FUORI (mercato chiuso)", !FriInFinestra(1315,1315,3.0), true, falliti);
   ABTG_AutotestCaso("chiusura non letta (0): mai dentro", !FriInFinestra(1200,0,3.0), true, falliti);
   ABTG_AutotestCaso("0 ore: mai dentro", !FriInFinestra(1314,1315,0.0), true, falliti);
   ABTG_AutotestCaso("20:55 (chiusura estiva) con 3 ore: 17:55 e' DENTRO", FriInFinestra(1075,1255,3.0), true, falliti);
   ABTG_AutotestCaso("2 ore: 19:55 DENTRO, 19:54 FUORI", FriInFinestra(1195,1315,2.0) && !FriInFinestra(1194,1315,2.0), true, falliti);
   return(falliti);
  }


int AutotestBaselineGiorno()
  {
   int falliti=0;
   Print("[AUTOTEST] ABTG_Guardian v1.14 -- MODO BASELINE GIORNALIERA (funzione pura, conto non toccato)");

   //--- A) IL CASO DEL DOSSIER: 100k con una posizione a -0,8% flottante
   //    al momento del reset (report/REGOLAMENTI_PROP_2026-09-08.md 3.1)
   double balA=100000.0, eqA=99200.0;
   ABTG_AutotestCaso("modo 0 su flottante NEGATIVO -> equita' 99200 (come v1.13)",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,0),99200.0),true,falliti);
   ABTG_AutotestCaso("modo 1 su flottante NEGATIVO -> saldo 100000 (criterio FTMO)",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,1),100000.0),true,falliti);
   ABTG_AutotestCaso("modo 2 su flottante NEGATIVO -> 100000 (il piu' alto)",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,2),100000.0),true,falliti);
   //    e i due PAVIMENTI del dossier, col limite del 5% su 100k = 5000
   ABTG_AutotestCaso("pavimento modo 1 = 95000 (identico a quello di FTMO)",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,1)-5000.0,95000.0),true,falliti);
   ABTG_AutotestCaso("pavimento modo 0 = 94200 (800 SOTTO quello di FTMO)",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,0)-5000.0,94200.0),true,falliti);

   //--- B) FLOTTANTE POSITIVO al reset: qui il verso si inverte
   double balB=100000.0, eqB=100500.0;
   ABTG_AutotestCaso("modo 0 su flottante POSITIVO -> equita' 100500 (piu' prudente)",
                     BaselineUguale(BaselineGiorno_Calc(balB,eqB,0),100500.0),true,falliti);
   ABTG_AutotestCaso("modo 1 su flottante POSITIVO -> saldo 100000",
                     BaselineUguale(BaselineGiorno_Calc(balB,eqB,1),100000.0),true,falliti);
   ABTG_AutotestCaso("modo 2 su flottante POSITIVO -> 100500 (il piu' alto)",
                     BaselineUguale(BaselineGiorno_Calc(balB,eqB,2),100500.0),true,falliti);

   //--- C) CONTO REALE COL CREDITO (i numeri del bug del 06/09):
   //    bilancio 5.000, credito 2.500 -> equita' 7.500 a flottante zero
   double balC=5000.0, eqC=7500.0;
   ABTG_AutotestCaso("credito: modo 0 -> 7500, il fix v1.12 resta intatto",
                     BaselineUguale(BaselineGiorno_Calc(balC,eqC,0),7500.0),true,falliti);
   ABTG_AutotestCaso("credito: modo 1 -> 5000, RIAPRE il bug (2500 di cuscinetto falso)",
                     BaselineUguale(BaselineGiorno_Calc(balC,eqC,1),5000.0),true,falliti);
   ABTG_AutotestCaso("credito: modo 2 -> 7500, coincide col modo 0 finche' eq>bal",
                     BaselineUguale(BaselineGiorno_Calc(balC,eqC,2),7500.0),true,falliti);
   //    credito MA flottante peggiore del credito: eq scende sotto il bilancio
   //    e il MAX torna a pescare il saldo contaminato. Limite DICHIARATO del
   //    modo 2 su un conto con credito.
   ABTG_AutotestCaso("credito + flottante oltre il credito: modo 2 -> 5000 (contaminato)",
                     BaselineUguale(BaselineGiorno_Calc(5000.0,4000.0,2),5000.0),true,falliti);

   //--- D) INPUT FUORI SCALA: si ripiega sul default, mai su un modo nuovo
   ABTG_AutotestCaso("modo 7 (fuori scala) -> ripiega su EQUITA'",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,7),99200.0),true,falliti);
   ABTG_AutotestCaso("modo -1 (fuori scala) -> ripiega su EQUITA'",
                     BaselineUguale(BaselineGiorno_Calc(balA,eqA,-1),99200.0),true,falliti);

   //--- E) INVARIANTI: il modo 2 non sta MAI sotto agli altri due
   ABTG_AutotestCaso("invariante: modo 2 >= modo 0 (flottante negativo)",
                     (BaselineGiorno_Calc(balA,eqA,2)>=BaselineGiorno_Calc(balA,eqA,0)),true,falliti);
   ABTG_AutotestCaso("invariante: modo 2 >= modo 1 (flottante positivo)",
                     (BaselineGiorno_Calc(balB,eqB,2)>=BaselineGiorno_Calc(balB,eqB,1)),true,falliti);
   ABTG_AutotestCaso("conto fermo (saldo=equita'): i tre modi coincidono",
                     (BaselineUguale(BaselineGiorno_Calc(100000.0,100000.0,0),100000.0) &&
                      BaselineUguale(BaselineGiorno_Calc(100000.0,100000.0,1),100000.0) &&
                      BaselineUguale(BaselineGiorno_Calc(100000.0,100000.0,2),100000.0)),true,falliti);

   //--- F) IL NOME DEL MODO, che e' quello che finisce nel giornale
   ABTG_AutotestCaso("il testo del modo 0 dice EQUITA'",
                     (StringFind(BaselineModoTesto(0),"EQUITA'")>=0),true,falliti);
   ABTG_AutotestCaso("il testo del modo 1 dice SALDO",
                     (BaselineModoTesto(1)=="SALDO"),true,falliti);
   ABTG_AutotestCaso("il testo del modo 2 dice MAX",
                     (StringFind(BaselineModoTesto(2),"MAX")>=0),true,falliti);
   ABTG_AutotestCaso("i tre testi sono DISTINTI fra loro",
                     (BaselineModoTesto(0)!=BaselineModoTesto(1) &&
                      BaselineModoTesto(1)!=BaselineModoTesto(2) &&
                      BaselineModoTesto(0)!=BaselineModoTesto(2)),true,falliti);
   ABTG_AutotestCaso("un modo fuori scala si DICHIARA come ripiego nel giornale",
                     (StringFind(BaselineModoTesto(7),"ripiego")>=0),true,falliti);

   if(falliti==0) Print("[AUTOTEST] baseline giornaliera: TUTTI I 22 CASI PASSATI.");
   else           PrintFormat("[AUTOTEST] baseline giornaliera: %d CASI FALLITI -- NON mettere in campo.",falliti);
   return(falliti);
  }

//+------------------------------------------------------------------+
//| Perdita in valuta se lo SL di QUESTA posizione venisse colpito.   |
//| from = prezzo di riferimento (ingresso o prezzo corrente).        |
//| Usa OrderCalcProfit (gestisce contratto e conversione valuta);    |
//| se fallisce, ripiega sull'aritmetica tick_value/tick_size.        |
//| Ritorna 0 se lo SL e' gia' in profitto (rischio nullo, non        |
//| negativo: un profitto bloccato non "finanzia" altro rischio).     |
//+------------------------------------------------------------------+
double LossIfStopHit(const string sym,const long ptype,const double vol,
                     const double from,const double sl)
  {
   if(sl<=0 || vol<=0 || from<=0) return(0.0);

   ENUM_ORDER_TYPE ot=(ptype==POSITION_TYPE_BUY)? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
   double profit=0;
   if(OrderCalcProfit(ot,sym,vol,from,sl,profit))
      return(profit<0 ? -profit : 0.0);

   // ripiego: distanza in tick x valore del tick
   double ts=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_SIZE);
   double tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE_LOSS);
   if(tv<=0) tv=SymbolInfoDouble(sym,SYMBOL_TRADE_TICK_VALUE);
   if(ts<=0 || tv<=0) return(0.0);

   // rischio solo se lo SL sta dalla parte sbagliata del prezzo
   double dist=(ptype==POSITION_TYPE_BUY)? (from-sl) : (sl-from);
   if(dist<=0) return(0.0);
   return(dist/ts*tv*vol);
  }

//+------------------------------------------------------------------+
//| C1 -- RISCHIO APERTO SIMULTANEO in % dell'equity.                |
//| Somma su TUTTE le posizioni del conto (qualsiasi magic: la regola |
//| prop e' sul conto, non sulla singola sedia).                      |
//| InpRiskMode: 0 = distanza INGRESSO->SL (rischio "pieno" preso     |
//|   all'ingresso, la stessa convenzione della misura M2 su cui e'   |
//|   tarato il 3,25%; con lo SL portato a pareggio va a zero da se). |
//|   1 = distanza PREZZO CORRENTE->SL (quanto posso ANCORA perdere   |
//|   da qui; e' la lettura coerente col limite giornaliero).         |
//| senzaSL: quante posizioni sono senza stop = rischio IGNOTO.       |
//+------------------------------------------------------------------+
double OpenRiskPct(const double equity,int &senzaSL,string &listaNoSL)
  {
   senzaSL=0; listaNoSL="";
   if(equity<=0) return(0.0);

   double tot=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;

      double sl=PositionGetDouble(POSITION_SL);
      if(sl<=0)
        {
         senzaSL++;
         if(StringLen(listaNoSL)<200)
            listaNoSL+=StringFormat("#%I64u(%s) ",tk,PositionGetString(POSITION_SYMBOL));
         continue;                    // rischio ignoto: si segnala, non si somma
        }

      string sym =PositionGetString(POSITION_SYMBOL);
      long   ptp =PositionGetInteger(POSITION_TYPE);
      double vol =PositionGetDouble(POSITION_VOLUME);
      double from=(InpRiskMode==1)? PositionGetDouble(POSITION_PRICE_CURRENT)
                                  : PositionGetDouble(POSITION_PRICE_OPEN);
      tot+=LossIfStopHit(sym,ptp,vol,from,sl);
     }
   return(100.0*tot/equity);
  }

//+------------------------------------------------------------------+
//| C2 -- RISCHIO APERTO PER CLUSTER, in % dell'equity.               |
//| Riempie perc[] con una voce per cluster (stesso ordine di gClNomi).|
//|                                                                    |
//| PERCHE' UN SECONDO GIRO invece di allargare OpenRiskPct(): perche' |
//| OpenRiskPct() e' codice IN CAMPO, e il collaudo enforcement legge  |
//| il suo numero (campo C9.RISCHIO). Lasciandolo intatto, a cluster   |
//| spenti questa funzione non viene MAI chiamata e il comportamento   |
//| del guardiano e' identico byte per byte a prima. Il costo del giro |
//| in piu' e' una volta al secondo, solo a tetto acceso.              |
//|                                                                    |
//| Stesse convenzioni di C1, di proposito (un numero che si legge     |
//| accanto all'altro deve essere misurato allo stesso modo):          |
//|  - stessa distanza (InpRiskMode: ingresso o prezzo corrente);      |
//|  - posizioni SENZA SL escluse (rischio ignoto, gia' segnalato);    |
//|  - pendenti NON contati (buco B6, dichiarato in testa al file);    |
//|  - un simbolo che sta in PIU' cluster pesa su TUTTI: e' voluto,    |
//|    EURUSD e' rischio dollaro E rischio euro nello stesso istante.  |
//+------------------------------------------------------------------+
int ClusterRiskPct(const double equity,double &perc[])
  {
   ArrayResize(perc,gClN);
   for(int c=0;c<gClN;c++) perc[c]=0.0;
   if(gClN<=0 || equity<=0) return(gClN);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;

      double sl=PositionGetDouble(POSITION_SL);
      if(sl<=0) continue;                       // rischio ignoto: escluso, come in C1

      string sym =PositionGetString(POSITION_SYMBOL);
      long   ptp =PositionGetInteger(POSITION_TYPE);
      double vol =PositionGetDouble(POSITION_VOLUME);
      double from=(InpRiskMode==1)? PositionGetDouble(POSITION_PRICE_CURRENT)
                                  : PositionGetDouble(POSITION_PRICE_OPEN);
      double perdita=LossIfStopHit(sym,ptp,vol,from,sl);
      if(perdita<=0) continue;                  // SL gia' in profitto: rischio nullo

      for(int c=0;c<gClN;c++)
         if(ABTG_SimboloNelCluster_Calc(sym,gClMembri[c]))
            perc[c]+=perdita;
     }

   for(int c=0;c<gClN;c++) perc[c]=100.0*perc[c]/equity;
   return(gClN);
  }

//+------------------------------------------------------------------+
//| Il tetto che vale per il cluster c: quello proprio se dichiarato,  |
//| altrimenti quello generale dell'input.                             |
//+------------------------------------------------------------------+
double ClusterTetto(const int c)
  {
   if(c<0 || c>=gClN) return(InpMaxClusterRiskPct);
   return(gClTetti[c]>0.0 ? gClTetti[c] : InpMaxClusterRiskPct);
  }

//+------------------------------------------------------------------+
//| Accende la pausa morbida (latch: si spegne solo al reset del      |
//| giorno prop, o alla scadenza se il guardiano muore).              |
//+------------------------------------------------------------------+
void SetPausa(const datetime fino,const string motivo)
  {
   if(GlobalVariableGet(GV_PAUSA)<=0)   // prima accensione: timbro l'ora e lo dico
     {
      GlobalVariableSet(GV_PAUSA,(double)TimeCurrent());
      PrintFormat("[GUARDIAN] * PAUSA NUOVI INGRESSI attiva: %s (fino a %s server)",
                  motivo,TimeToString(fino,TIME_DATE|TIME_MINUTES));
     }
   // la scadenza si tiene sempre aggiornata (mai accorciata): e' la rete
   // di sicurezza se il guardiano muore con la pausa accesa
   if(GlobalVariableGet(GV_PAUSAFINO)<(double)fino)
      GlobalVariableSet(GV_PAUSAFINO,(double)fino);
  }

//+------------------------------------------------------------------+
//| v1.11 -- VERIFICA DEL FILO.                                       |
//| Il guardiano SCRIVE su nomi costruiti qui sopra; gli EA LEGGONO   |
//| da nomi costruiti dentro ABTG_PausaGuardian.mqh. Sono due posti   |
//| diversi: se divergono (un refuso, una radice cambiata a meta'),   |
//| il canale si spegne senza che nessuno se ne accorga -- il         |
//| guardiano continua a scrivere e gli EA continuano ad aprire.      |
//| Qui li si confronta una volta all'avvio. Non cambia niente:       |
//| scrive e basta. Ritorna il numero di nomi che NON coincidono.     |
//+------------------------------------------------------------------+
int VerificaFilo()
  {
   int diff=0;
   string coppie[5][2];   // [i][0]=radice per l'include . [i][1]=nome usato qui
   coppie[0][0]="ABTG_PAUSA_GIORNO";      coppie[0][1]=GV_PAUSA;
   coppie[1][0]="ABTG_PAUSA_FINO";        coppie[1][1]=GV_PAUSAFINO;
   coppie[2][0]="ABTG_CAP_RISCHIO";       coppie[2][1]=GV_CAP;
   coppie[3][0]="ABTG_RISCHIO_APERTO";    coppie[3][1]=GV_RISKPCT;
   coppie[4][0]="ABTG_GUARDIAN_BATTITO";  coppie[4][1]=GV_BATTITO;

   for(int i=0;i<5;i++)
     {
      string atteso=ABTG_GVNome(coppie[i][0]);     // come lo costruisce l'include
      if(atteso!=coppie[i][1])
        {
         diff++;
         PrintFormat("[GUARDIAN] *** FILO ROTTO *** il guardiano scrive su '%s' ma gli EA leggono '%s'. "
                     "Il canale NON funziona: allineare ABTG_Guardian.mq5 e ABTG_PausaGuardian.mqh.",
                     coppie[i][1],atteso);
        }
     }
   if(diff==0)
      PrintFormat("[GUARDIAN] filo verificato: 5 GlobalVariable su 5 con lo stesso nome fra guardiano e include (conto %I64d).",
                  AccountInfoInteger(ACCOUNT_LOGIN));
   return(diff);
  }

//+------------------------------------------------------------------+
//| R1 (v1.17) -- CONTATORE DELLE RICHIESTE AL SERVER.                |
//| ReqClassifica e ReqLivello sono PURE (non leggono il conto).      |
//| Categorie: 0=non conta . 1=nuovo ordine (apertura/chiusura a      |
//| mercato o pendente) . 2=modifica SL/TP di una posizione (evento   |
//| di posizione senza deal) . 3=modifica di un pendente . 4=         |
//| cancellazione di un pendente. Per eccesso: un pendente che scatta |
//| conta anche come "cancellazione". NON VERIFICATO sul broker.      |
//+------------------------------------------------------------------+
int ReqClassifica(const ENUM_TRADE_TRANSACTION_TYPE tipo,const ulong deal,const ENUM_ORDER_TYPE otipo)
  {
   bool pend=(otipo!=ORDER_TYPE_BUY && otipo!=ORDER_TYPE_SELL && otipo!=ORDER_TYPE_CLOSE_BY);
   if(tipo==TRADE_TRANSACTION_ORDER_ADD) return(1);
   if(tipo==TRADE_TRANSACTION_POSITION && deal==0) return(2);
   if(tipo==TRADE_TRANSACTION_ORDER_UPDATE && pend) return(3);
   if(tipo==TRADE_TRANSACTION_ORDER_DELETE && pend) return(4);
   return(0);
  }
//--- livello: 0 sotto l'avviso . 1 da avviso a allarme (escluso) . 2 allarme o oltre. Soglie <=0 = quel livello spento.
int ReqLivello(const int n,const int avviso,const int allarme)
  {
   if(allarme>0 && n>=allarme) return(2);
   if(avviso>0 && n>=avviso) return(1);
   return(0);
  }
int ReqTotale(){ return(gReqBase+gReqCat[1]+gReqCat[2]+gReqCat[3]+gReqCat[4]); }
//--- cambio giorno prop: azzera i contatori (e il livello). Restituisce true se ha azzerato.
bool ReqRollGiorno()
  {
   int pk=PropDayKey();
   if((int)GlobalVariableGet(GV_REQDAY)==pk) return(false);
   for(int i=0;i<5;i++) gReqCat[i]=0;
   gReqBase=0;
   gReqLivello=0;
   GlobalVariableSet(GV_REQDAY,pk);
   GlobalVariableSet(GV_REQ,0);
   return(true);
  }
void ReqRegistra(const int cat)
  {
   ReqRollGiorno();
   gReqCat[cat]++;
   int n=ReqTotale();
   GlobalVariableSet(GV_REQ,(double)n);
   int lv=ReqLivello(n,InpReqWarn,InpReqAlarm);
   if(lv>gReqLivello)
     {
      gReqLivello=lv;
      string msg=StringFormat("[GUARDIAN] RICHIESTE AL SERVER oggi: %d (%s) -- nuovi ordini %d, SL/TP posizioni %d, modifica pendenti %d, cancella pendenti %d. Limite FTMO 2000/giorno (stima per eccesso, NON VERIFICATO).",
                              n,(lv==2?"ALLARME":"AVVISO"),gReqCat[1],gReqCat[2],gReqCat[3],gReqCat[4]);
      Print(msg);
      Alert(msg);
      if(lv==2 && InpReqAction==1)
         SetPausa(NextResetTime(),StringFormat("richieste al server %d >= %d",n,InpReqAlarm));
     }
  }
//+------------------------------------------------------------------+
//| Gli eventi di conto arrivano a ogni EA: il Guardian li vede anche |
//| se li hanno generati altri EA o l'utente (NON VERIFICATO sul      |
//| broker: confrontare col Journal il primo giorno).                 |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans,const MqlTradeRequest &request,const MqlTradeResult &result)
  {
   if(!InpReqEnable) return;
   int cat=ReqClassifica(trans.type,trans.deal,trans.order_type);
   if(cat>0) ReqRegistra(cat);
  }
//--- v1.17: AUTOTEST del contatore (funzioni pure, conto non toccato)
int AutotestRichieste()
  {
   int falliti=0;
   Print("[AUTOTEST] ABTG_Guardian v1.17 -- CONTATORE RICHIESTE (funzioni pure, conto non toccato)");
   ABTG_AutotestCaso("ORDER_ADD (mercato BUY) conta 1", ReqClassifica(TRADE_TRANSACTION_ORDER_ADD,0,ORDER_TYPE_BUY)==1, true, falliti);
   ABTG_AutotestCaso("ORDER_ADD (pendente BUY_STOP) conta 1", ReqClassifica(TRADE_TRANSACTION_ORDER_ADD,0,ORDER_TYPE_BUY_STOP)==1, true, falliti);
   ABTG_AutotestCaso("POSITION senza deal = modifica SL/TP (2)", ReqClassifica(TRADE_TRANSACTION_POSITION,0,ORDER_TYPE_BUY)==2, true, falliti);
   ABTG_AutotestCaso("POSITION con deal NON conta", ReqClassifica(TRADE_TRANSACTION_POSITION,12345,ORDER_TYPE_BUY)==0, true, falliti);
   ABTG_AutotestCaso("ORDER_UPDATE di un pendente = modifica (3)", ReqClassifica(TRADE_TRANSACTION_ORDER_UPDATE,0,ORDER_TYPE_SELL_LIMIT)==3, true, falliti);
   ABTG_AutotestCaso("ORDER_UPDATE di un ordine a mercato NON conta", ReqClassifica(TRADE_TRANSACTION_ORDER_UPDATE,0,ORDER_TYPE_BUY)==0, true, falliti);
   ABTG_AutotestCaso("ORDER_DELETE di un pendente = cancellazione (4)", ReqClassifica(TRADE_TRANSACTION_ORDER_DELETE,0,ORDER_TYPE_BUY_LIMIT)==4, true, falliti);
   ABTG_AutotestCaso("ORDER_DELETE di un ordine a mercato NON conta", ReqClassifica(TRADE_TRANSACTION_ORDER_DELETE,0,ORDER_TYPE_SELL)==0, true, falliti);
   ABTG_AutotestCaso("DEAL_ADD NON conta", ReqClassifica(TRADE_TRANSACTION_DEAL_ADD,777,ORDER_TYPE_BUY)==0, true, falliti);
   ABTG_AutotestCaso("HISTORY_ADD NON conta", ReqClassifica(TRADE_TRANSACTION_HISTORY_ADD,0,ORDER_TYPE_BUY)==0, true, falliti);
   ABTG_AutotestCaso("livello 999 con 1000/1600 = 0", ReqLivello(999,1000,1600)==0, true, falliti);
   ABTG_AutotestCaso("livello 1000 = 1 (avviso)", ReqLivello(1000,1000,1600)==1, true, falliti);
   ABTG_AutotestCaso("livello 1599 = 1", ReqLivello(1599,1000,1600)==1, true, falliti);
   ABTG_AutotestCaso("livello 1600 = 2 (allarme)", ReqLivello(1600,1000,1600)==2, true, falliti);
   ABTG_AutotestCaso("soglie a 0 = spente", ReqLivello(5000,0,0)==0, true, falliti);
   return(falliti);
  }

//--- v1.18: AUTOTEST della decisione di pausa (funzioni pure, conto non toccato)
int AutotestPausa()
  {
   int falliti=0;
   Print("[AUTOTEST] ABTG_Guardian v1.18 -- PAUSA (funzioni pure, conto non toccato)");
   ABTG_AutotestCaso("scatto (primo giro): sempre completo, modo 2", PausaDecidi(2,true,0,60)==2, true, falliti);
   ABTG_AutotestCaso("modo 0 dopo lo scatto: completo", PausaDecidi(0,false,0,60)==2, true, falliti);
   ABTG_AutotestCaso("modo 1 dopo lo scatto: solo vicini", PausaDecidi(1,false,0,60)==1, true, falliti);
   ABTG_AutotestCaso("modo 2 dopo lo scatto: nessuna cancellazione", PausaDecidi(2,false,999,60)==0, true, falliti);
   ABTG_AutotestCaso("modo 3 dopo 59 s: nulla", PausaDecidi(3,false,59,60)==0, true, falliti);
   ABTG_AutotestCaso("modo 3 dopo 60 s: completo", PausaDecidi(3,false,60,60)==2, true, falliti);
   ABTG_AutotestCaso("modo sconosciuto 9: nessuna cancellazione", PausaDecidi(9,false,0,60)==0, true, falliti);
   ABTG_AutotestCaso("pendente a 0,5% con soglia 1%: vicino", PausaVicino(2010.0,2000.0,1.0), true, falliti);
   ABTG_AutotestCaso("pendente a 1,5% con soglia 1%: lontano", !PausaVicino(2030.0,2000.0,1.0), true, falliti);
   ABTG_AutotestCaso("pendente esattamente a 1%: vicino (<=)", PausaVicino(2020.0,2000.0,1.0), true, falliti);
   ABTG_AutotestCaso("prezzo di riferimento assente: prudente = vicino", PausaVicino(2020.0,0.0,1.0), true, falliti);
   ABTG_AutotestCaso("tetto 300, fatte 299: si puo'", PausaTettoOk(299,300), true, falliti);
   ABTG_AutotestCaso("tetto 300, fatte 300: no", !PausaTettoOk(300,300), true, falliti);
   ABTG_AutotestCaso("tetto 0 = nessun tetto", PausaTettoOk(100000,0), true, falliti);
   return(falliti);
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   long acc=AccountInfoInteger(ACCOUNT_LOGIN);
   // v1.12: le cinque GlobalVariable della baseline (saldo/picco/giorno)
   // cambiano nome con un suffisso _V2 -- APPOSTA. Un conto che aveva gia'
   // il guardiano v1.11 in campo ha questi valori GIA' SCRITTI col vecchio
   // criterio (baseline dal bilancio, contaminata da un eventuale credito);
   // "sopravvivono a riavvii/ricompilazioni" e' una caratteristica voluta
   // (persistenza), quindi senza cambiare nome il fix di codice non
   // servirebbe a niente: alla prima ricompilazione riletterebbe il
   // vecchio numero sbagliato invece di ricatturarlo. Il nome nuovo forza
   // una cattura fresca col criterio corretto (v1.12: dall'equita'),
   // senza bisogno di cancellare nulla a mano da F3.
   GV_START   =StringFormat("ABTG_GUARD_%I64d_START_V2",acc);
   GV_PEAK    =StringFormat("ABTG_GUARD_%I64d_PEAK_V2",acc);
   GV_DAYKEY  =StringFormat("ABTG_GUARD_%I64d_DAYKEY_V2",acc);
   GV_DAYSTART=StringFormat("ABTG_GUARD_%I64d_DAYSTART_V2",acc);
   GV_BLOCKDAY=StringFormat("ABTG_GUARD_%I64d_BLOCKDAY_V2",acc);
   GV_FAILED  =StringFormat("ABTG_GUARD_%I64d_FAILED",acc);
   // canale verso gli EA -- gli STESSI nomi stanno in ABTG_PausaGuardian.mqh
   GV_PAUSA    =StringFormat("ABTG_PAUSA_GIORNO_%I64d",acc);
   GV_PAUSAFINO=StringFormat("ABTG_PAUSA_FINO_%I64d",acc);
   GV_CAP      =StringFormat("ABTG_CAP_RISCHIO_%I64d",acc);
   GV_RISKPCT  =StringFormat("ABTG_RISCHIO_APERTO_%I64d",acc);
   GV_BATTITO  =StringFormat("ABTG_GUARDIAN_BATTITO_%I64d",acc);
   if(InpReqEnable)
     {
      GV_REQ   =StringFormat("ABTG_GUARD_%I64d_REQ_V1",acc);
      GV_REQDAY=StringFormat("ABTG_GUARD_%I64d_REQDAY_V1",acc);
      // dopo un riavvio nello stesso giorno il totale persiste (le categorie ripartono da zero, dichiarato)
      if((int)GlobalVariableGet(GV_REQDAY)==PropDayKey())
         gReqBase=(int)GlobalVariableGet(GV_REQ);
     }

   //--- v1.11: il filo verso gli EA e' integro? (solo lettura e log)
   VerificaFilo();
   if(InpAutotest)
     {
      ABTG_AutotestGuardia();       // casi del canale (nell'include, INVARIATI)
      AutotestBaselineGiorno();     // v1.14: casi del modo della baseline
      AutotestEsposizione();        // v1.15: casi del tetto di esposizione
      AutotestVenerdi();            // v1.16: casi della finestra del venerdi'
      AutotestRichieste();          // v1.17: casi del contatore delle richieste
      AutotestPausa();              // v1.18: casi della decisione di pausa
     }

   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double eq =AccountInfoDouble(ACCOUNT_EQUITY);

   // saldo iniziale: input se >0, altrimenti cattura una volta e persisti.
   // v1.12: cattura dall'EQUITA' (non dal bilancio) -- stessa base con cui
   // verra' confrontato piu' sotto, cosi' un eventuale credito del broker
   // (costante) si cancella da solo invece di restare come cuscinetto.
   if(InpStartBalance>0) gStart=InpStartBalance;
   else                  gStart=(GlobalVariableCheck(GV_START)? GlobalVariableGet(GV_START) : eq);
   GlobalVariableSet(GV_START,gStart);

   // v1.12: la RIGA DELLA PROVA. Stampa le due grandezze fianco a fianco,
   // cosi' il credito del broker (equita' MENO bilancio) si legge con gli
   // occhi nella scheda Esperti invece di doverlo dedurre. Era esattamente
   // il numero invisibile che ha nascosto il bug fino al 06/09: su quel
   // conto il bilancio diceva 5000 e l'equita' 7500, e il guardiano
   // prendeva il primo per confrontarlo col secondo. Serve anche a un
   // secondo scopo, meno ovvio: tiene VIVA la variabile bal, che dopo il
   // fix non avrebbe piu' nessun lettore in OnInit -- e una variabile non
   // usata e' un WARNING di compilazione, che la riga di deploy tratta
   // come un PROBLEMA che ferma tutto il collaudo.
   PrintFormat("[GUARDIAN] baseline presa dall'EQUITA' (v1.12): equity=%.2f  bilancio=%.2f  differenza=%.2f "
               "(se la differenza non e' zero e' il CREDITO del broker: non e' tuo, e infatti NON allarga le soglie)",
               eq,bal,eq-bal);

   gPeak=(GlobalVariableCheck(GV_PEAK)? GlobalVariableGet(GV_PEAK) : MathMax(eq,gStart));
   if(eq>gPeak) gPeak=eq;
   GlobalVariableSet(GV_PEAK,gPeak);

   // v1.14: il MODO della baseline si dichiara all'avvio, e a voce alta se
   // NON e' quello di default. A default (0) questa riga non compare: il
   // giornale resta quello della v1.13.
   if(InpDailyBaseline!=0)
      PrintFormat("[GUARDIAN] MODO BASELINE GIORNALIERA = %s (InpDailyBaseline=%d). NON e' il default: "
                  "e' una scelta di conto FIRMATA. Su un conto CON CREDITO del broker il modo 1 (SALDO) "
                  "riaprirebbe il bug del 06/09 -- li' vale solo il modo 0.",
                  BaselineModoTesto(InpDailyBaseline),InpDailyBaseline);
   if(InpDailyBaseline<0 || InpDailyBaseline>2)
      PrintFormat("[GUARDIAN] *** InpDailyBaseline=%d FUORI SCALA (attesi 0/1/2): uso il DEFAULT, baseline = EQUITA'.",
                  InpDailyBaseline);

   // baseline del giorno
   int pk=PropDayKey();
   if(!GlobalVariableCheck(GV_DAYKEY) || (int)GlobalVariableGet(GV_DAYKEY)!=pk)
     {
      // v1.12: la baseline giornaliera NON viene dal bilancio (credito del
      // broker). v1.14: da quale grandezza viene lo dice il MODO -- default
      // 0 = EQUITA', cioe' identico alla v1.13.
      double base=BaselineGiorno_Calc(bal,eq,InpDailyBaseline);
      GlobalVariableSet(GV_DAYKEY,pk);
      GlobalVariableSet(GV_DAYSTART,base);
      GlobalVariableSet(GV_BLOCKDAY,0);
      GlobalVariableSet(GV_PAUSA,0);           // giorno nuovo = pausa morbida azzerata
      GlobalVariableSet(GV_PAUSAFINO,0);
      PrintFormat("[GUARDIAN] nuovo giorno prop: baseline=%.2f (modo=%s)  [equity=%.2f bilancio=%.2f]",
                  base,BaselineModoTesto(InpDailyBaseline),eq,bal);
     }
   if(!GlobalVariableCheck(GV_PAUSA))    GlobalVariableSet(GV_PAUSA,0);
   if(!GlobalVariableCheck(GV_PAUSAFINO))GlobalVariableSet(GV_PAUSAFINO,0);
   GlobalVariableSet(GV_CAP,0);          // il cap si ricalcola da zero a ogni avvio

   //--- C2 (07/09/2026): la mappa dei cluster si legge UNA volta, qui.
   //    NO-OP di default: se il tetto e' 0 O la mappa e' vuota non si
   //    parsifica niente, non si crea nessuna GlobalVariable e non si
   //    stampa nessuna riga in piu' -- il giornale resta quello della v1.12.
   gClN=0;
   if(InpMaxClusterRiskPct>0 && StringLen(InpClusterMappa)>0)
     {
      gClN=ABTG_ClusterParse_Calc(InpClusterMappa,gClNomi,gClMembri,gClTetti);
      if(gClN<=0)
         Print("[GUARDIAN] ATTENZIONE: InpClusterMappa non contiene nessun cluster valido -> "
               "tetto per cluster SPENTO. Formato atteso: NOME=SYM,SYM;NOME2:3.5=SYM3");
      else
        {
         ArrayResize(gClAttivo,gClN);
         for(int c=0;c<gClN;c++)
           {
            gClAttivo[c]=false;
            // la bandiera si CREA subito a 0, anche se il cluster e' libero:
            // e' cosi' che un EA puo' accorgersi che la sua mappa e quella del
            // guardiano divergono (ABTG_ClusterFiloOk nell'include).
            GlobalVariableSet(ABTG_GVNome(ABTG_ClusterGVRadice(gClNomi[c])),0);
            PrintFormat("[GUARDIAN] cluster %d/%d: %s tetto %.2f%% membri [%s]",
                        c+1,gClN,gClNomi[c],ClusterTetto(c),gClMembri[c]);
           }
         PrintFormat("[GUARDIAN] cap per CLUSTER correlato ATTIVO: %d cluster, tetto generale %.2f%% "
                     "(firma 07/09/2026). Il cap complessivo resta %.2f%%: vince il piu' stringente.",
                     gClN,InpMaxClusterRiskPct,InpMaxOpenRiskPct);
        }
     }

   gTrade.SetExpertMagicNumber(InpMagic);
   EventSetTimer(1);
   PrintFormat("[GUARDIAN] avviato. Saldo iniziale=%.2f  DailyLoss=%.1f%%  DD=%.1f%% (%s)  Azione=%s",
               gStart,InpDailyLossPct,InpTotalDDPct,(InpDDMode==1?"trailing":"statico"),
               (InpAction==1?"SOLO ALLARME":"CHIUDI+BLOCCA"));
   PrintFormat("[GUARDIAN] pausa morbida=%.2f%%  cap rischio aperto=%.2f%% (modo %s)  reset giorno=%02d:00 server",
               InpDailyPausePct,InpMaxOpenRiskPct,
               (InpRiskMode==1?"prezzo corrente":"ingresso"),InpDailyResetHour);
   if(InpMaxTotalLots>0 || InpMaxOpenPositions>0 || InpMaxNetLots>0)
      PrintFormat("[GUARDIAN] tetto di esposizione ATTIVO: %.2f lotti, %d posizioni, netto %.2f, azione %d (0=pendenti, 1=pendenti+chiude piu recenti, 2=allarme)",
                  InpMaxTotalLots,InpMaxOpenPositions,InpMaxNetLots,InpExposureAction);
   if(InpFriEnable)
     {
      string sy=(StringLen(InpFriSymbol)>0)?InpFriSymbol:_Symbol;
      SymbolSelect(sy,true);
      PrintFormat("[GUARDIAN] chiusura del VENERDI' ATTIVA: %.1f ore prima della chiusura del mercato (sessione di %s), azione %s",
                  InpFriHoursBefore,sy,(InpAction==1?"SOLO ALLARME":"CHIUDI+BLOCCA"));
     }
   if(InpReqEnable)
      PrintFormat("[GUARDIAN] contatore RICHIESTE ATTIVO: avviso %d, allarme %d, azione %d (0=avvisi, 1=pausa nuovi ingressi all'allarme). Stima per eccesso, NON VERIFICATO contro FTMO.",
                  InpReqWarn,InpReqAlarm,InpReqAction);
   if(InpPauseMode!=0)
      PrintFormat("[GUARDIAN] PAUSA modo %d ATTIVO (0=come prima, 1=solo pendenti vicini entro %.2f%%, 2=nessun pendente cancellato dopo lo scatto, 3=cancella ogni %d s). Tetto %d cancellazioni/giorno. Posizioni: chiuse sempre entro 1 s.",
                  InpPauseMode,InpPauseNearPct,InpPauseEverySec,InpPauseMaxDelDay);
   OnTimer();
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   Comment("");
   // battito a zero: se il guardiano se ne va, gli EA lo vedono subito
   // (su ricompilazione/cambio parametri OnInit lo rimette entro un attimo)
   if(StringLen(GV_BATTITO)>0) GlobalVariableSet(GV_BATTITO,0);
  }

//+------------------------------------------------------------------+
//| Chiude TUTTE le posizioni e cancella TUTTI i pendenti            |
//+------------------------------------------------------------------+
int FlattenAll()
  {
   int acted=0;
   // posizioni
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(!InpCloseAllMagics && PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      if(gTrade.PositionClose(tk)) acted++;
     }
   // pendenti
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      if(!InpCloseAllMagics && OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      if(gTrade.OrderDelete(tk)) acted++;
     }
   return(acted);
  }

//+------------------------------------------------------------------+
//| P1 (v1.18) -- funzioni PURE (non leggono il conto)                |
//+------------------------------------------------------------------+
//--- vera se il pendente (prezzo p) e' entro pct % dal prezzo di riferimento ref
bool PausaVicino(const double p,const double ref,const double pct)
  {
   if(ref<=0.0 || p<=0.0) return(true);          // dati assenti: prudente, si considera vicino
   return(MathAbs(p-ref)/ref*100.0<=pct);
  }
//--- decide se in questo giro si cancellano i pendenti.
//    modo: 0..3. since: secondi dall'ultima cancellazione completa. every: intervallo del modo 3.
//    primo: true = e' il giro dello scatto (sempre completo). Restituisce 0=no 1=solo vicini 2=tutti.
int PausaDecidi(const int modo,const bool primo,const int since,const int every)
  {
   if(primo) return(2);
   if(modo==0) return(2);
   if(modo==1) return(1);
   if(modo==3) return(since>=every?2:0);
   return(0);                                    // modo 2 (e ogni valore sconosciuto: piu' prudente = non cancella ma le posizioni si chiudono)
  }
//--- tetto di cancellazioni al giorno: vera se si puo' ancora cancellare
bool PausaTettoOk(const int fatte,const int tetto){ return(tetto<=0 || fatte<tetto); }

//--- riepilogo (una riga) se c'e' stata attivita'; azzera i contatori
void PausaLog(const bool forza)
  {
   if(InpPauseMode==0) return;
   datetime t=TimeCurrent();
   if(!forza && t-gPauseLogT<InpPauseLogSec) return;
   if(gPauseLogT==0){ gPauseLogT=t; if(!forza) return; }
   if(gPauseNDel+gPauseNClose+gPauseNFail>0)
      PrintFormat("[GUARDIAN] PAUSA modo %d (ultimi %d s): pendenti cancellati %d, posizioni chiuse %d, richieste rifiutate %d; pendenti ancora presenti %d. Oggi: cancellazioni %d (tetto %d), richieste del Guardian dopo lo scatto %d.",
                  InpPauseMode,(int)(t-gPauseLogT),gPauseNDel,gPauseNClose,gPauseNFail,OrdersTotal(),gPauseDelDay,InpPauseMaxDelDay,gPauseReqDay);
   gPauseNDel=0; gPauseNClose=0; gPauseNFail=0;
   gPauseLogT=t;
  }

//+------------------------------------------------------------------+
//| P1 (v1.18) -- ripetizione dell'azione nella pausa. Modo 0 =       |
//| FlattenAll() come nella v1.17 (identico). key = chiave dello      |
//| stato (bloccato oggi / fallito / venerdi'): la prima volta con    |
//| una chiave nuova il FlattenAll e' completo.                       |
//+------------------------------------------------------------------+
int PausaEnforce(const int slot,const long key)
  {
   if(InpPauseMode==0) return(FlattenAll());
   int acted=0;
   datetime now=TimeCurrent();
   int dk=PropDayKey();
   if(gPauseDayKey!=dk){ gPauseDayKey=dk; gPauseDelDay=0; gPauseReqDay=0; }
   bool primo=(gPauseKey[slot]!=key);
   if(primo)
     {
      gPauseKey[slot]=key;
      gPauseLastFull=now;
      acted=FlattenAll();                          // lo scatto: completo, come prima
      return(acted);
     }
   // 1) POSIZIONI: sempre, ogni secondo (la sicurezza non cambia). Dopo un rifiuto, al massimo ogni InpPauseRetrySec.
   bool puoProvare=(gPauseLastFail==0 || now-gPauseLastFail>=InpPauseRetrySec);
   if(PositionsTotal()>0 && puoProvare)
     {
      for(int i=PositionsTotal()-1;i>=0;i--)
        {
         ulong tk=PositionGetTicket(i);
         if(tk==0) continue;
         if(!InpCloseAllMagics && PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
         gPauseReqDay++;
         if(gTrade.PositionClose(tk)){ acted++; gPauseNClose++; gPauseLastFail=0; }
         else { gPauseNFail++; gPauseLastFail=now; break; }   // rifiutata: non martellare
        }
     }
   // 2) PENDENTI: secondo il modo
   int d=PausaDecidi(InpPauseMode,false,(int)(now-gPauseLastFull),InpPauseEverySec);
   if(OrdersTotal()>0)
     {
      if(d!=0)
        {
         if(d==2) gPauseLastFull=now;
         for(int j=OrdersTotal()-1;j>=0;j--)
           {
            ulong tk=OrderGetTicket(j);
            if(tk==0) continue;
            if(!InpCloseAllMagics && OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
            if(d==1)
              {
               string sy=OrderGetString(ORDER_SYMBOL);
               ENUM_ORDER_TYPE ot=(ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
               bool compra=(ot==ORDER_TYPE_BUY_LIMIT || ot==ORDER_TYPE_BUY_STOP || ot==ORDER_TYPE_BUY_STOP_LIMIT);
               double ref=compra?SymbolInfoDouble(sy,SYMBOL_ASK):SymbolInfoDouble(sy,SYMBOL_BID);
               if(!PausaVicino(OrderGetDouble(ORDER_PRICE_OPEN),ref,InpPauseNearPct)) continue;
              }
            if(!PausaTettoOk(gPauseDelDay,InpPauseMaxDelDay)) continue;
            gPauseReqDay++;
            if(gTrade.OrderDelete(tk)){ acted++; gPauseNDel++; gPauseDelDay++; }
            else gPauseNFail++;
           }
        }
     }
   PausaLog(false);
   return(acted);
  }

//+------------------------------------------------------------------+
//| F1 (v1.16) -- minuto di chiusura del VENERDI' letto dal broker    |
//| (ultima sessione di trading del venerdi', minuti dalla mezzanotte |
//| server). -1 se non si legge.                                      |
//+------------------------------------------------------------------+
int FriMinutoChiusura(const string sym)
  {
   datetime da=0,a=0; int ultimo=-1;
   for(int k=0;k<10;k++)
     {
      if(!SymbolInfoSessionTrade(sym,FRIDAY,k,da,a)) break;
      int m=(int)(a/60);
      if(m>ultimo) ultimo=m;
     }
   return(ultimo);
  }

int gFriGiornoLog=0;   // un solo log al giorno
void FridayCheck()
  {
   MqlDateTime s; TimeToStruct(TimeCurrent(),s);
   if(s.day_of_week!=FRIDAY) return;
   string sym=(StringLen(InpFriSymbol)>0)?InpFriSymbol:_Symbol;
   int chiusura=FriMinutoChiusura(sym);
   bool fallback=false;
   if(chiusura<=0){ chiusura=InpFriFallbackMin; fallback=true; }
   int adesso=s.hour*60+s.min;
   if(!FriInFinestra(adesso,chiusura,InpFriHoursBefore)) return;
   int dk=s.year*1000+s.day_of_year;
   if(gFriGiornoLog!=dk)
     {
      gFriGiornoLog=dk;
      PrintFormat("[GUARDIAN] VENERDI': chiusura mercato %02d:%02d server (%s), finestra attiva da %02d:%02d. %s",
                  chiusura/60,chiusura%60,(fallback?"FALLBACK: sessione non letta":"letta dal broker"),
                  (chiusura-(int)MathRound(InpFriHoursBefore*60.0))/60,(chiusura-(int)MathRound(InpFriHoursBefore*60.0))%60,
                  (InpAction==0?"CHIUDO TUTTO e cancello i pendenti":"SOLO ALLARME"));
     }
   if(InpAction!=0) return;
   // nuovi ingressi: pausa per gli EA ABTG (gli altri EA si ricacciano qui sotto)
   SetPausa(TimeCurrent()+(datetime)((chiusura-adesso+60)*60),"chiusura del venerdi' prima del weekend");
   if(PositionsTotal()>0 || OrdersTotal()>0)
     {
      int a=PausaEnforce(1,2000000000L+(long)dk);       // v1.18: modo 0 = FlattenAll() come prima
      if(a>0 && InpVerbose && InpPauseMode==0) PrintFormat("[GUARDIAN] VENERDI': chiusi/cancellati %d ordini",a);
     }
  }

//+------------------------------------------------------------------+
//| E1 -- TETTO DI ESPOSIZIONE (v1.15)                                |
//+------------------------------------------------------------------+
bool gEsposizioneOn=false;

// Funzione PURA: non legge il conto. Vera se lotti, posizioni o esposizione netta superano un tetto acceso.
bool ExposureEccede(const double lots,const int npos,const double netAbs,
                    const double capLots,const int capPos,const double capNet)
  {
   if(capLots>0 && lots>capLots+0.0000001) return(true);
   if(capPos>0 && npos>capPos) return(true);
   if(capNet>0 && netAbs>capNet+0.0000001) return(true);
   return(false);
  }

// Misura: lotti totali, numero di posizioni, e l'esposizione NETTA piu' grande fra i simboli
// (netSigned > 0 = lunga: piu' buy che sell; il simbolo in netSym).
void ExposureMisura(double &lots,int &npos,double &netSigned,string &netSym)
  {
   lots=0.0; npos=0; netSigned=0.0; netSym="";
   string sy[64]; double nt[64]; int ns=0;
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if(!InpCloseAllMagics && PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
      double v=PositionGetDouble(POSITION_VOLUME);
      lots+=v; npos++;
      string s=PositionGetString(POSITION_SYMBOL);
      double sg=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)? v : -v;
      int k=-1;
      for(int q=0;q<ns;q++) if(sy[q]==s){ k=q; break; }
      if(k<0 && ns<64){ k=ns; sy[k]=s; nt[k]=0.0; ns++; }
      if(k>=0) nt[k]+=sg;
     }
   for(int q=0;q<ns;q++)
      if(MathAbs(nt[q])>MathAbs(netSigned)){ netSigned=nt[q]; netSym=sy[q]; }
  }

// Torna il numero di azioni fatte (0 se spento, rientrato o solo allarme).
int ExposureCheck(double &lots,int &npos,double &netSigned)
  {
   lots=0.0; npos=0; netSigned=0.0;
   if(InpMaxTotalLots<=0 && InpMaxOpenPositions<=0 && InpMaxNetLots<=0) return(0);   // spento: NO-OP
   string netSym="";
   ExposureMisura(lots,npos,netSigned,netSym);
   if(!ExposureEccede(lots,npos,MathAbs(netSigned),InpMaxTotalLots,InpMaxOpenPositions,InpMaxNetLots))
     {
      if(gEsposizioneOn)
         PrintFormat("[GUARDIAN] tetto esposizione rientrato: %.2f lotti, %d posizioni, netto %.2f",lots,npos,netSigned);
      gEsposizioneOn=false;
      return(0);
     }
   int azione=(InpAction==1)? 2 : InpExposureAction;                 // monitor: mai agire
   if(!gEsposizioneOn)
      PrintFormat("[GUARDIAN] # TETTO ESPOSIZIONE superato: %.2f lotti (tetto %.2f), %d posizioni (tetto %d), netto %.2f su %s (tetto %.2f). Azione=%s",
                  lots,InpMaxTotalLots,npos,InpMaxOpenPositions,netSigned,netSym,InpMaxNetLots,
                  (azione==2?"SOLO ALLARME":(azione==1?"CANCELLA PENDENTI + CHIUDE LE PIU RECENTI":"CANCELLA PENDENTI")));
   gEsposizioneOn=true;
   if(azione==2) return(0);

   int acted=0;
   // 1) tutti i pendenti: nessuno stop/limit deve poter scattare e far crescere l'esposizione
   for(int j=OrdersTotal()-1;j>=0;j--)
     {
      ulong tk=OrderGetTicket(j);
      if(tk==0) continue;
      if(!InpCloseAllMagics && OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      if(gTrade.OrderDelete(tk)) acted++;
     }
   // 2) azione 1: chiude la posizione PIU' RECENTE (per tempo in millisecondi) finche' rientra nel tetto.
   //    Se a sforare e' il NETTO, si chiude la piu' recente del lato scoperto di quel simbolo.
   if(azione==1)
     {
      for(int giro=0;giro<200;giro++)
        {
         ExposureMisura(lots,npos,netSigned,netSym);
         if(!ExposureEccede(lots,npos,MathAbs(netSigned),InpMaxTotalLots,InpMaxOpenPositions,InpMaxNetLots)) break;
         bool soloNetto=(!(InpMaxTotalLots>0 && lots>InpMaxTotalLots+0.0000001) &&
                         !(InpMaxOpenPositions>0 && npos>InpMaxOpenPositions));
         ulong best=0; long bt=0;
         for(int i=PositionsTotal()-1;i>=0;i--)
           {
            ulong tk=PositionGetTicket(i);
            if(tk==0) continue;
            if(!InpCloseAllMagics && PositionGetInteger(POSITION_MAGIC)!=InpMagic) continue;
            if(soloNetto)
              {
               if(PositionGetString(POSITION_SYMBOL)!=netSym) continue;
               bool buy=(PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
               if(buy!=(netSigned>0)) continue;
              }
            long tm=PositionGetInteger(POSITION_TIME_MSC);
            if(best==0 || tm>bt){ best=tk; bt=tm; }
           }
         if(best==0) break;
         if(gTrade.PositionClose(best)) acted++; else break;
        }
      ExposureMisura(lots,npos,netSigned,netSym);
     }
   if(acted>0)
      PrintFormat("[GUARDIAN] # tetto esposizione: %d azioni; ora %.2f lotti, %d posizioni, netto %.2f",acted,lots,npos,netSigned);
   return(acted);
  }

//+------------------------------------------------------------------+
void OnTimer()
  {
   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double eq =AccountInfoDouble(ACCOUNT_EQUITY);

   // BATTITO: prima cosa a ogni giro. Un EA che lo trova vecchio sa che
   // il guardiano non sta piu' sorvegliando (e puo' decidere di fermarsi).
   GlobalVariableSet(GV_BATTITO,(double)TimeCurrent());

   // reset giornaliero se e' cambiato il "giorno prop"
   int pk=PropDayKey();
   if((int)GlobalVariableGet(GV_DAYKEY)!=pk)
     {
      // v1.12: non dal bilancio (credito del broker). v1.14: la scelta la
      // fa il MODO -- default 0 = EQUITA', identico alla v1.13.
      double base=BaselineGiorno_Calc(bal,eq,InpDailyBaseline);
      GlobalVariableSet(GV_DAYKEY,pk);
      GlobalVariableSet(GV_DAYSTART,base);
      GlobalVariableSet(GV_BLOCKDAY,0);
      GlobalVariableSet(GV_PAUSA,0);        // la pausa morbida dura un giorno prop
      GlobalVariableSet(GV_PAUSAFINO,0);
      if(InpVerbose)
         PrintFormat("[GUARDIAN] nuovo giorno prop: baseline=%.2f (modo=%s)  [equity=%.2f bilancio=%.2f] (pausa morbida azzerata)",
                     base,BaselineModoTesto(InpDailyBaseline),eq,bal);
     }

   // aggiorno picco equity (per trailing)
   if(eq>gPeak){ gPeak=eq; GlobalVariableSet(GV_PEAK,gPeak); }

   double dayStart=GlobalVariableGet(GV_DAYSTART);
   bool   failed  =(GlobalVariableGet(GV_FAILED)>0);
   bool   blocked =((int)GlobalVariableGet(GV_BLOCKDAY)==pk);

   // limiti in valuta
   double dailyLimit =InpDailyLossPct/100.0*gStart;
   double totalLimit =InpTotalDDPct  /100.0*gStart;

   // perdite correnti
   double dailyLoss =dayStart-eq;                          // perdita rispetto a inizio giornata
   double totalDD   =(InpDDMode==1)? (gPeak-eq) : (gStart-eq); // trailing dal picco, o statico dal saldo iniziale

   double dailyPct=(gStart>0)?100.0*dailyLoss/gStart:0;
   double totalPct=(gStart>0)?100.0*totalDD  /gStart:0;

   // --- controllo violazioni ---
   bool breachTotal = (totalDD >= totalLimit);
   bool breachDaily = (dailyLoss >= dailyLimit);

   if(breachTotal && !failed)
     {
      int a=(InpAction==0)? FlattenAll():0;
      GlobalVariableSet(GV_FAILED,1);
      PrintFormat("[GUARDIAN] !!! DD TOTALE SFONDATO: %.2f (%.2f%%) >= %.2f. %s (%d ordini)",
                  totalDD,totalPct,totalLimit,(InpAction==0?"CHIUSO TUTTO, CHALLENGE FERMATA":"ALLARME"),a);
     }
   else if(breachDaily && !blocked && !failed)
     {
      int a=(InpAction==0)? FlattenAll():0;
      GlobalVariableSet(GV_BLOCKDAY,pk);
      PrintFormat("[GUARDIAN] !! PERDITA GIORNALIERA SFONDATA: %.2f (%.2f%%) >= %.2f. %s (%d ordini)",
                  dailyLoss,dailyPct,dailyLimit,(InpAction==0?"CHIUSO TUTTO, BLOCCATO PER OGGI":"ALLARME"),a);
     }

   // se bloccato/fallito e in enforce: continuo a ricacciare indietro ogni nuovo trade
   if(InpAction==0 && (failed || (int)GlobalVariableGet(GV_BLOCKDAY)==pk))
     {
      if(PositionsTotal()>0 || OrdersTotal()>0)
         PausaEnforce(0,failed ? 1000000000L : (long)pk);   // v1.18: modo 0 = FlattenAll() come prima
     }

   //=== F1 -- CHIUSURA DEL VENERDI' (v1.16): spenta di default = nessuna azione ===
   if(InpFriEnable) FridayCheck();

   //=== E1 -- TETTO DI ESPOSIZIONE (v1.15): spento a 0/0 = nessuna azione ===
   double esLots=0.0; int esPos=0; double esNet=0.0;
   if(InpMaxTotalLots>0 || InpMaxOpenPositions>0 || InpMaxNetLots>0) ExposureCheck(esLots,esPos,esNet);

   //=== B1 -- PAUSA MORBIDA (non chiude niente, blocca i NUOVI ingressi) ===
   bool nowBlocked=((int)GlobalVariableGet(GV_BLOCKDAY)==pk);
   bool nowFailed =(GlobalVariableGet(GV_FAILED)>0);
   if(InpDailyPausePct>0 && dailyPct>=InpDailyPausePct)
      SetPausa(NextResetTime(),StringFormat("perdita giornaliera %.2f%% >= %.2f%%",dailyPct,InpDailyPausePct));
   // se il lockdown duro e' scattato, la pausa vale a maggior ragione:
   // gli EA non devono nemmeno provare ad aprire
   if(nowBlocked) SetPausa(NextResetTime(),"blocco giornaliero d'emergenza");
   if(nowFailed)  SetPausa(TimeCurrent()+30*86400,"challenge fallita (DD totale)");
   bool pausaOn=(GlobalVariableGet(GV_PAUSA)>0);

   //=== C1 -- CAP SUL RISCHIO APERTO SIMULTANEO ===========================
   int    senzaSL=0; string listaNoSL="";
   double riskPct=OpenRiskPct(eq,senzaSL,listaNoSL);
   GlobalVariableSet(GV_RISKPCT,riskPct);          // informativa, sempre aggiornata
   bool capOn=false;
   if(InpMaxOpenRiskPct>0 && riskPct>=InpMaxOpenRiskPct)
     {
      capOn=true;
      if(GlobalVariableGet(GV_CAP)<=0)
         PrintFormat("[GUARDIAN] * CAP RISCHIO APERTO attivo: %.2f%% >= %.2f%% (nuovi ingressi sospesi)",
                     riskPct,InpMaxOpenRiskPct);
      // il valore e' il timestamp: si rinfresca a ogni giro, cosi' scade
      // da solo se il guardiano muore (fail-open, non blocco eterno)
      GlobalVariableSet(GV_CAP,(double)TimeCurrent());
     }
   else
     {
      if(GlobalVariableGet(GV_CAP)>0)
         PrintFormat("[GUARDIAN] cap rischio aperto rientrato: %.2f%% < %.2f%%",riskPct,InpMaxOpenRiskPct);
      GlobalVariableSet(GV_CAP,0);
     }

   //=== C2 -- CAP SUL RISCHIO APERTO PER CLUSTER CORRELATO ===============
   //  A cluster spenti (gClN=0) questo blocco non fa NIENTE: nessun giro
   //  sulle posizioni, nessuna GlobalVariable, nessuna riga di giornale.
   //  Le frasi sono VOLUTAMENTE diverse da quelle di C1: il collaudo
   //  enforcement (backtest_pipeline/attese_enforcement_fase1.txt) cerca
   //  "[GUARDIAN] * CAP RISCHIO APERTO attivo:" e "[GUARDIAN] cap rischio
   //  aperto rientrato:" come attese di C7, e "rischioAperto=" come campo
   //  di C9. Nessuna riga qui sotto contiene una di quelle sottostringhe.
   string clPanel="";
   double clMax=0.0; string clMaxNome="";
   if(gClN>0)
     {
      double clPct[];
      ClusterRiskPct(eq,clPct);
      for(int c=0;c<gClN;c++)
        {
         double tetto=ClusterTetto(c);
         bool   morde=(clPct[c]>=tetto);
         string gv   =ABTG_GVNome(ABTG_ClusterGVRadice(gClNomi[c]));

         if(morde)
           {
            if(!gClAttivo[c])
               PrintFormat("[GUARDIAN] # CAP CLUSTER attivo: %s a %.2f%% >= %.2f%% "
                           "(nuovi ingressi sospesi sui simboli di questo cluster)",
                           gClNomi[c],clPct[c],tetto);
            // il valore e' il timestamp e si rinfresca a ogni giro: se il
            // guardiano muore, il tetto scade da solo (fail-open, come C1)
            GlobalVariableSet(gv,(double)TimeCurrent());
           }
         else
           {
            if(gClAttivo[c])
               PrintFormat("[GUARDIAN] cap cluster rientrato: %s a %.2f%% < %.2f%%",
                           gClNomi[c],clPct[c],tetto);
            GlobalVariableSet(gv,0);
           }
         gClAttivo[c]=morde;

         if(clPct[c]>clMax){ clMax=clPct[c]; clMaxNome=gClNomi[c]; }
         if(morde) clPanel+=StringFormat("\n  %s %.2f%%/%.2f%% CAP ATTIVO",gClNomi[c],clPct[c],tetto);
        }
     }

   // posizioni senza SL = rischio IGNOTO: si segnala, non si blocca
   if(InpWarnNoSL && senzaSL>0 && TimeCurrent()-gLastWarnNoSL>=300)
     {
      gLastWarnNoSL=TimeCurrent();
      PrintFormat("[GUARDIAN] ATTENZIONE: %d posizioni SENZA SL (rischio non calcolabile, escluse dal cap): %s",
                  senzaSL,listaNoSL);
     }

   if(InpShowPanel)
     {
      string st= failed ? "CHALLENGE FALLITA (DD totale)" :
                 (((int)GlobalVariableGet(GV_BLOCKDAY)==pk)? "BLOCCATO PER OGGI (daily)" : "OK - operativo");
      string panel=StringFormat(
        "=== ABTG GUARDIAN ===\nStato: %s\nSaldo iniziale: %.2f\nEquity: %.2f   Balance: %.2f\n"
        "--- GIORNO ---\nInizio giorno: %.2f\nPerdita oggi: %.2f  (%.2f%% / limite %.1f%%)\n"
        "--- TOTALE (%s) ---\nPicco equity: %.2f\nDrawdown: %.2f  (%.2f%% / limite %.1f%%)\nAzione: %s\n"
        "--- NUOVI INGRESSI ---\nPausa morbida (%.1f%%): %s\n"
        "Rischio aperto: %.2f%% / cap %.2f%% -> %s%s",
        st,gStart,eq,bal,dayStart,dailyLoss,dailyPct,InpDailyLossPct,
        (InpDDMode==1?"trailing":"statico"),gPeak,totalDD,totalPct,InpTotalDDPct,
        (InpAction==1?"SOLO ALLARME":"CHIUDI+BLOCCA"),
        InpDailyPausePct,(InpDailyPausePct<=0?"spenta":(pausaOn?"ATTIVA (stop nuovi ingressi)":"libera")),
        riskPct,InpMaxOpenRiskPct,(InpMaxOpenRiskPct<=0?"spento":(capOn?"CAP ATTIVO":"ok")),
        (senzaSL>0?StringFormat("\n!! %d posizioni SENZA SL (rischio ignoto)",senzaSL):""));
      // C2: il pannello cresce SOLO se il tetto per cluster e' acceso
      if(gClN>0)
         panel+=StringFormat("\nCluster (%d, tetto %.2f%%): peggiore %s %.2f%%%s",
                             gClN,InpMaxClusterRiskPct,
                             (StringLen(clMaxNome)>0?clMaxNome:"-"),clMax,
                             (StringLen(clPanel)>0?clPanel:""));
      // E1: il pannello cresce SOLO se il tetto di esposizione e' acceso
      if(InpMaxTotalLots>0 || InpMaxOpenPositions>0 || InpMaxNetLots>0)
         panel+=StringFormat("\nEsposizione: %.2f lotti / tetto %.2f . %d pos / tetto %d . netto %.2f / tetto %.2f%s",
                             esLots,InpMaxTotalLots,esPos,InpMaxOpenPositions,esNet,InpMaxNetLots,
                             (gEsposizioneOn?"  -> TETTO SUPERATO":""));
      // R1: il pannello cresce SOLO se il contatore e' acceso
      if(InpReqEnable)
        {
         ReqRollGiorno();
         panel+=StringFormat("\nRichieste oggi: %d (nuovi %d . SL/TP %d . mod pend %d . canc pend %d) / avviso %d . allarme %d",
                             ReqTotale(),gReqCat[1],gReqCat[2],gReqCat[3],gReqCat[4],InpReqWarn,InpReqAlarm);
        }
      Comment(panel);
     }

   // log periodico (ogni 5 min) per lo storico
   if(InpVerbose && TimeCurrent()-gLastLog>=300)
     {
      gLastLog=TimeCurrent();
      PrintFormat("[GUARDIAN] eq=%.2f  dayLoss=%.2f%%  totDD=%.2f%%  rischioAperto=%.2f%%  stato=%s  pausa=%s  cap=%s",
                  eq,dailyPct,totalPct,riskPct,
                  (failed?"FAILED":(nowBlocked?"BLOCKED":"OK")),
                  (pausaOn?"ON":"off"),(capOn?"ON":"off"));
      // riga SEPARATA per C2, e solo a tetto acceso: non contiene
      // "rischioAperto=" apposta, cosi' il campo C9.RISCHIO del collaudo
      // enforcement continua a estrarre SOLO il numero di C1.
      if(InpMaxTotalLots>0 || InpMaxOpenPositions>0 || InpMaxNetLots>0)
         PrintFormat("[GUARDIAN] esposizione: %.2f lotti (tetto %.2f), %d posizioni (tetto %d), netto %.2f (tetto %.2f), tetto=%s",
                     esLots,InpMaxTotalLots,esPos,InpMaxOpenPositions,esNet,InpMaxNetLots,(gEsposizioneOn?"SUPERATO":"ok"));
      if(InpReqEnable)
        {
         ReqRollGiorno();
         PrintFormat("[GUARDIAN] richieste al server oggi: %d (nuovi ordini %d, SL/TP %d, mod pendenti %d, canc pendenti %d), avviso %d, allarme %d",
                     ReqTotale(),gReqCat[1],gReqCat[2],gReqCat[3],gReqCat[4],InpReqWarn,InpReqAlarm);
        }
      if(gClN>0)
         PrintFormat("[GUARDIAN] cluster: %d dichiarati, peggiore %s clusterMax=%.2f%% (tetto generale %.2f%%)",
                     gClN,(StringLen(clMaxNome)>0?clMaxNome:"-"),clMax,InpMaxClusterRiskPct);
     }
  }
//+------------------------------------------------------------------+
