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
#property version   "1.14"
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
bool BaselineUguale(const double a,const double b){ return(MathAbs(a-b)<0.005); }

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

   //--- v1.11: il filo verso gli EA e' integro? (solo lettura e log)
   VerificaFilo();
   if(InpAutotest)
     {
      ABTG_AutotestGuardia();       // casi del canale (nell'include, INVARIATI)
      AutotestBaselineGiorno();     // v1.14: casi del modo della baseline
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
      if(PositionsTotal()>0 || OrdersTotal()>0) FlattenAll();
     }

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
      if(gClN>0)
         PrintFormat("[GUARDIAN] cluster: %d dichiarati, peggiore %s clusterMax=%.2f%% (tetto generale %.2f%%)",
                     gClN,(StringLen(clMaxNome)>0?clMaxNome:"-"),clMax,InpMaxClusterRiskPct);
     }
  }
//+------------------------------------------------------------------+
