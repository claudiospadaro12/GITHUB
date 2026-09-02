//+------------------------------------------------------------------+
//|                                           ABTG_PausaGuardian.mqh  |
//|  LETTURA DELLA PAUSA DEL GUARDIANO -- lato EA.                    |
//|                                                                   |
//|  A cosa serve: ABTG_Guardian.mq5 sorveglia TUTTO il conto e,      |
//|  quando la giornata va male (-4% di default) o quando il rischio   |
//|  aperto simultaneo supera il cap (3,25% di default), scrive delle  |
//|  GlobalVariable. Questo include e' l'UNICO punto in cui gli EA le  |
//|  leggono: nessuna dipendenza, nessuna classe, nessun handle.       |
//|                                                                   |
//|  USO CONSIGLIATO -- una riga sola IMMEDIATAMENTE PRIMA di mandare  |
//|  l'ordine di APERTURA (non in cima alla funzione: vedi sotto):     |
//|                                                                    |
//|     #include <ABTG_PausaGuardian.mqh>                              |
//|     input bool InpUsaGuardian = true;   // firme B1/C1             |
//|     ...                                                            |
//|     if(!ABTG_GuardiaIngresso(InpUsaGuardian,"NOME_EA")) return;    |
//|                                                                    |
//|  FRENO SULLE PERDITE CONSECUTIVE (P1, v1.30) -- OPZIONALE, spento: |
//|  la stessa riga con due argomenti in piu' (soglia 0 = come oggi):  |
//|                                                                    |
//|     input int InpStopDopoNPerdite = 0;  // 0 = spento (P1)         |
//|     ...                                                            |
//|     if(!ABTG_GuardiaIngresso(InpUsaGuardian,"NOME_EA",false,       |
//|                              InpStopDopoNPerdite,InpMagic)) return;|
//|                                                                    |
//|  STOP A OBIETTIVO RAGGIUNTO (S1, v1.40) -- OPZIONALE, spento:      |
//|  la stessa riga con tre argomenti in piu' (target 0 = come oggi):  |
//|                                                                    |
//|     input double InpSaldoRiferimento = 0;  // 0 = spento (S1)      |
//|     input double InpTargetPct        = 0;  // 0 = spento (S1)      |
//|     ...                                                            |
//|     if(!ABTG_GuardiaIngresso(InpUsaGuardian,"NOME_EA",false,       |
//|                              InpStopDopoNPerdite,InpMagic,         |
//|                              InpSaldoRiferimento,InpTargetPct))    |
//|        return;                                                     |
//|                                                                    |
//|  Restano disponibili i mattoni singoli, se servono per un pannello:|
//|     PausaGiornoAttiva() / CapRischioAttivo() / GuardianVivo()      |
//|     RischioApertoPct() / ABTG_PuoAprire()                          |
//|     ABTG_PerditeConsecutiveOggi() / ABTG_TroppePerditeConsecutive()|
//|     ABTG_ObiettivoRaggiunto() / ABTG_ObiettivoLatchScattato()      |
//|     ABTG_ObiettivoResetta() / ABTG_ObiettivoSoglia_Calc()          |
//|                                                                    |
//|  IMPORTANTE -- cosa NON fa:                                        |
//|   - non chiude niente e non tocca le posizioni gia' aperte:        |
//|     la gestione di una posizione viva resta all'EA;                |
//|   - blocca solo i NUOVI ingressi, se l'EA la chiama;               |
//|   - NON e' un cap istantaneo sul rischio: un ordine PENDENTE gia'  |
//|     piazzato quando il cap era libero scattera' lo stesso. Questa  |
//|     e' una guardia sull'AGGIUNTA di rischio. Il tetto duro sul     |
//|     rischio gia' in campo resta mestiere del Guardian, che chiude; |
//|   - se il guardiano NON gira, tutto ritorna false (fail-open):     |
//|     un cane da guardia morto non deve fermare la flotta per        |
//|     sempre. Chi vuole il contrario usa GuardianVivo().             |
//|                                                                    |
//|  DOVE si mette la chiamata -- regola imparata in ricognizione      |
//|  (referto REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md, par. 1.3):  |
//|  SEMPRE immediatamente PRIMA dell'invio, MAI in cima all'imbuto.   |
//|  Motivo: diversi imbuti (es. MonitorRetest degli EA "Apertura")    |
//|  aggiornano la macchina a stati PRIMA di mandare l'ordine. Se si   |
//|  esce in cima, la rottura non viene registrata e l'EA entrerebbe   |
//|  piu' tardi su un livello vecchio: sarebbe un cambio di STRATEGIA  |
//|  mascherato da regola di rischio. Messa prima dell'invio, l'unica  |
//|  cosa che cambia e' che l'ordine non parte -- esattamente come un  |
//|  rifiuto del broker, caso che ogni EA gestisce gia'.               |
//|                                                                    |
//|  E NON si mette sulle CHIUSURE: in hedging alcuni EA chiudono un   |
//|  parziale mandando un ordine opposto (es. GapContinuation.         |
//|  ClosePartial). Bloccare li' vorrebbe dire impedire una PRESA DI   |
//|  PROFITTO: l'opposto della firma C1.                               |
//|                                                                    |
//|  I nomi delle GlobalVariable devono restare IDENTICI a quelli in   |
//|  ABTG_Guardian.mq5 (blocco GV_PAUSA/GV_CAP/GV_BATTITO in OnInit).  |
//+------------------------------------------------------------------+
//  v1.00 -- 18/08/2026 (firme B1/C1). Nessun #property qui dentro:
//           sovrascriverebbe quelli dell'EA che include il file.
//  v1.20 -- 19/08/2026. Migrazione alla flotta (decisione n.1 PIANO_PROP v12):
//           - la logica di decisione e' stata separata in un NUCLEO PURO
//             (funzioni ..._Calc, che non leggono niente e prendono i
//             timestamp come argomenti): cosi' e' collaudabile a tavolino;
//           - le funzioni pubbliche di prima restano IDENTICHE nella firma
//             e nel comportamento, ora delegano al nucleo;
//           - NUOVA ABTG_GuardiaIngresso(): la riga unica da mettere negli
//             EA, con fail-open totale e log che non allaga il giornale;
//           - NUOVO ABTG_AutotestGuardia(): autotest puro, 12 casi.
//  v1.30 -- 22/08/2026. FRENO SULLE PERDITE CONSECUTIVE (proposta P1 del
//           dossier report/DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md, par.7).
//           PERCHE': Artemis (EA commerciale del Nasdaq, par.2.5 del dossier)
//           ferma la giornata dopo 6 perdite di fila; da noi lo stesso freno
//           esiste gia' ma COPIATO A MANO dentro i singoli EA (BULGE_MASTER
//           / ABTG_Bulge: Max_Consecutive_SL; DAX_MASTER_PROP:
//           InpMaxConsecutiveSL; ABTG_GoldenCross_Ottimizzato: TodayStats).
//           Codice duplicato = bug duplicati, e uno l'abbiamo gia' pagato:
//           il FIX 3 di GoldenCross v2.00 (audit 1.4-4) ha scoperto che
//           contare i DEAL invece delle POSIZIONI disinnesca il freno --
//           su conto HEDGING un parziale in utile seguito da uno stop sul
//           resto azzerava il contatore, e "parziale poi stop" valeva ZERO
//           perdite. BULGE_MASTER ha ANCORA quel difetto (conta i deal).
//           Qui la versione CONDIVISA e corretta, cosi' si sbaglia una
//           volta sola e si corregge in un posto solo:
//           - struct ABTG_DealRiga + ABTG_PerditeConsecutive_Calc():
//             NUCLEO PURO, raggruppa per DEAL_POSITION_ID e giudica sul
//             NETTO della posizione. Prende la lista dei deal come
//             argomento -> l'autotest la puo' costruire FINTA, senza conto
//             e senza tester (era l'unico modo di provare a macchina il
//             caso "parziali");
//           - ABTG_PerditeConsecutiveOggi() / ...Spiega(): il filo che
//             legge la cronologia vera e chiama il nucleo;
//           - ABTG_TroppePerditeConsecutive(): la decisione (soglia 0=off);
//           - ABTG_GuardiaIngresso() prende DUE argomenti nuovi IN CODA
//             (soglia=0, magic=0): tutte le ~40 chiamate esistenti nella
//             flotta restano valide riga per riga e a soglia 0 il
//             comportamento e' IDENTICO -- non e' un'opinione, e' il caso
//             di autotest "soglia=0 -> sempre false, qualunque storia".
//           NESSUN EA e' stato modificato: N e l'adozione per sedia li
//           firma Claudio (il dossier propone 3 = 3 x 0,65% = 1,95%, sotto
//           il cap C1 del 3,25%; ma il valore ENTRA in vigore solo con la
//           firma, qui e' solo un parametro).
//  v1.40 -- 23/08/2026. STOP A OBIETTIVO RAGGIUNTO (proposta S1 del referto
//           report/SWEEP_APPROFONDITO_EA_2026-08-22.md, par. 6 tabella madre
//           riga S1 + par. 2 riga 8 della "tabella dei buchi" + par. 5.2).
//           PERCHE': quel referto lo dice cosi', ed e' la lacuna piu' grave
//           trovata nel confronto con 30 utility "prop" del campo:
//             "e' l'unico buco della lista che puo' far fallire una
//              challenge GIA' VINTA. Tutti gli altri 23 meccanismi difendono
//              dal muro in basso; S1 e' l'unico che difende il traguardo.
//              Il giorno in cui il conto tocca +10%, la challenge e' finita
//              -- e oggi, nel nostro sistema, non esiste una sola riga di
//              codice che lo sappia."
//           I NUMERI, con la fonte (par. 5.2 dello stesso referto, due fonti
//           INDIPENDENTI sullo stesso valore -- riportati come LETTI, non
//           come regola di una prop che abbiamo verificato noi):
//             +10,1% = equity a cui chiudere tutto e smettere, fase 1
//                      (Code Base 49713 'PropFirmHelper': PASS_CRITERIA=110100
//                       su 100k; Market 150962 'Prop Firm Protector EZ': 10,1%)
//             +5,1%  = idem per la FASE 2 di verifica (Prop Firm Protector EZ)
//           Il decimo di punto SOPRA il 10% e' lo stesso margine che il campo
//           lascia in basso (4,5% contro muro 5%): si supera il traguardo di
//           un'incollatura, non lo si sfiora.
//           COSA HO SCRITTO QUI:
//           - ABTG_ObiettivoSoglia_Calc() / ABTG_ObiettivoRaggiunto_Calc() /
//             ABTG_ObiettivoLatch_Calc(): NUCLEO PURO, non leggono il conto,
//             prendono riferimento/valore/target come argomenti;
//           - il LATCH: una volta scattato, S1 resta scattato anche se il
//             conto ridiscende. Lo stato sta in una GlobalVariable del
//             terminale (stesso meccanismo di B1/C1) -> sopravvive al riavvio
//             del VPS e vale per TUTTE le sedie del conto che hanno S1 acceso.
//             Si sblocca SOLO A MANO: ABTG_ObiettivoResetta() o cancellando la
//             GV ABTG_OBIETTIVO_RAGGIUNTO_<login> dal terminale;
//           - ABTG_GuardiaIngresso() prende TRE argomenti nuovi IN CODA
//             (saldo_riferimento=0, obiettivo_pct=0, su_equity=false): a
//             target 0 il comportamento e' IDENTICO a prima e non viene
//             letta ne' scritta nessuna GV -- e' il caso di autotest
//             "target 0 -> mai, qualunque valore".
//           SI MISURA SUL SALDO (BALANCE), non sull'equity: un profit target
//           di challenge si porta a casa sul REALIZZATO, e il saldo non fa
//           picchi che rientrano. Il referto stesso avvisa: "attenzione a non
//           farlo scattare su un picco di equity intraday che poi rientra ->
//           va valutato su equity con conferma, o su saldo". Qui NON c'e'
//           nessuna conferma implementata, quindi si sceglie il saldo.
//           L'equity resta disponibile come argomento in coda (opt-in) per
//           chi la volesse, con il difetto dichiarato.
//           LIMITE DICHIARATO: non sappiamo se la prop misuri il target sul
//           saldo o sull'equity di fine giornata. Nei dossier del 21-22/08
//           quel dato NON c'e' -- c'e' solo cosa fanno gli EA del campo.
//           Resta una domanda per il supporto (report/DOMANDE_SUPPORTO_PROP).
//           NESSUN EA e' stato modificato: l'accensione per sedia e il valore
//           del target li firma Claudio (come per P1).
//  v1.50 -- 02/09/2026. TETTO PER SIMBOLO + LATO (cantiere P0, firmato da
//           Claudio il 02/09, verbale report/FIRME_2026-09-02.md commit
//           d3c4887). OPT-IN: default 0 = spento, comportamento identico
//           a oggi.
//           PERCHE': il 31/08 cinque EA diversi si sono trovati LONG sul Dow
//           nello stesso momento. Nessuno aveva sbagliato -- ogni sedia
//           rispettava il proprio InpMaxPositions, che pero' e' scritto
//           "per questo magic". Il pile-up di casa e' TRASVERSALE alle
//           famiglie, e non esisteva una sola riga di codice che guardasse
//           il CONTO invece della sedia.
//           CENSIMENTO PRIMA DI SCRIVERE (fase 1 del cantiere): il tetto
//           "A1" (InpMaxPosSimbolo) esiste gia', COPIATO A MANO e IDENTICO
//           in 5 EA della famiglia Aperture (DAX_Apertura_EU,
//           Dow_Apertura_US, Nasdaq_Apertura_US, Apertura_3Ingressi,
//           Apertura_Marco). Copre gia' due terzi del problema -- posizioni
//           + pendenti, tutti i magic -- ma conta il TOTALE sul simbolo,
//           NON per lato: con A1=1 un long e uno short sullo stesso simbolo
//           (che su conto hedging sono una copertura, non un pile-up) si
//           bloccherebbero a vicenda. P0 non lo duplica: e' la stessa idea
//           divisa per lato e messa in UN posto solo, disponibile a tutta
//           la flotta invece che ai 5 EA che hanno la copia.
//           COSA HO SCRITTO QUI:
//           - ABTG_LatoDaTipo_Calc() / ABTG_ContaSimboloLato_Calc() /
//             ABTG_TettoSimboloLatoRaggiunto_Calc(): NUCLEO PURO, ricevono
//             le righe di esposizione come argomento -> l'autotest ne passa
//             di FINTE e prova il conteggio senza conto e senza tester;
//           - ABTG_LeggiEsposizione() / ABTG_ContaSimboloLato() /
//             ABTG_TettoSimboloLato_Calc(): il filo che legge il terminale;
//           - ABTG_GuardiaIngresso() prende TRE argomenti nuovi IN CODA
//             (tetto=0, lato=0, simbolo=""): le 93 chiamate reali censite
//             in 65 file passano oggi 2 soli argomenti e restano valide
//             riga per riga, senza toccare un solo EA;
//           - motivo 6 nel giornale, con frase DIVERSA da B1/C1: vedi il
//             commento dentro la guardia (collaudo C9, blocchi orfani).
//           NESSUN EA e' stato modificato e NESSUN BINARIO CAMBIA: questa
//           e' una modifica di repository, inerte finche' Claudio non
//           ricompila (vincolo D1 del verbale). L'accensione per sedia e il
//           valore del tetto li firma lui, come per P1 e S1.
//  ASCII puro: niente accenti e niente emoji nelle stringhe.
#ifndef ABTG_PAUSAGUARDIAN_MQH
#define ABTG_PAUSAGUARDIAN_MQH

//--- tolleranza di default sul battito del guardiano (secondi).
//    Il guardiano batte 1 volta al secondo: 120s = e' morto davvero,
//    non e' solo un terminale impegnato.
//    (Un EA che la vuole diversa la puo' ridefinire PRIMA dell'#include.)
#ifndef ABTG_BATTITO_TOLLERANZA
#define ABTG_BATTITO_TOLLERANZA 120
#endif

//--- ogni quanti secondi, al massimo, la guardia scrive nel giornale
//    quando sta bloccando. Serve a non allagare il log: gli imbuti
//    possono essere interrogati a ogni tick.
#ifndef ABTG_LOG_OGNI_SEC
#define ABTG_LOG_OGNI_SEC 300
#endif

//--- tolleranza in VALUTA sul confronto col traguardo (S1, v1.40).
//    Un centesimo. Serve per un motivo aritmetico, non per generosita':
//    100000 * (1 + 10.1/100) in virgola mobile binaria NON fa esattamente
//    110100 (il 10,1% non e' rappresentabile), e senza tolleranza il caso
//    "conto esattamente al traguardo" potrebbe NON far scattare S1.
//    Un centesimo su 110.100 e' un errore da 0,00001%: dichiarato qui.
#ifndef ABTG_EPS_VALUTA
#define ABTG_EPS_VALUTA 0.01
#endif

//+------------------------------------------------------------------+
//|                                                                   |
//|   NUCLEO PURO -- nessuna lettura, nessun effetto collaterale.      |
//|   Prende i timestamp gia' letti e risponde. E' questa la parte     |
//|   che l'autotest puo' interrogare a tavolino, senza terminale,     |
//|   senza conto e senza guardiano acceso.                            |
//|                                                                   |
//+------------------------------------------------------------------+

//--- PAUSA MORBIDA GIORNALIERA (regola B1) -- nucleo.
//    ts_pausa = quando e' stata accesa (0 = mai)
//    ts_fino  = scadenza dichiarata dal guardiano (0 = non dichiarata)
//    ora      = TimeCurrent() del chiamante
bool ABTG_PausaAttiva_Calc(const double ts_pausa,const double ts_fino,const datetime ora)
  {
   if(ts_pausa<=0) return(false);                  // nessuna pausa scritta

   if(ts_fino>0)
      return(ora<(datetime)ts_fino);               // pausa con scadenza dichiarata

   // scadenza mancante (guardiano vecchio o GV persa): ripiego prudente,
   // la pausa vale al massimo 24 ore dall'accensione
   return(ora-(datetime)ts_pausa < 24*3600);
  }

//--- CAP SUL RISCHIO APERTO SIMULTANEO (regola C1) -- nucleo.
//    ts_cap = timestamp RI-TIMBRATO dal guardiano a ogni secondo finche'
//    il cap e' violato; azzerato appena il rischio rientra.
//    Il fail-open e' dentro la bandiera stessa: se il guardiano smette di
//    timbrare, entro la tolleranza il cap scade da solo.
bool ABTG_CapAttivo_Calc(const double ts_cap,const datetime ora,
                         const int tolleranza_sec)
  {
   if(ts_cap<=0) return(false);
   return(ora-(datetime)ts_cap <= tolleranza_sec);
  }

//--- IL GUARDIANO STA GIRANDO? -- nucleo (battito fresco).
bool ABTG_GuardianVivo_Calc(const double ts_battito,const datetime ora,
                            const int tolleranza_sec)
  {
   if(ts_battito<=0) return(false);
   return(ora-(datetime)ts_battito <= tolleranza_sec);
  }

//--- DECISIONE COMPLETA -- nucleo. Ritorna:
//      0 = si puo' aprire
//      1 = fermo per PAUSA giornaliera (B1)
//      2 = fermo per CAP rischio aperto (C1)
//      3 = fermo perche' il guardiano non batte e l'EA lo PRETENDE
//    (il numero, non un bool, cosi' il chiamante puo' dire il PERCHE')
int ABTG_MotivoStop_Calc(const double ts_pausa,const double ts_fino,
                         const double ts_cap,const double ts_battito,
                         const datetime ora,const int tolleranza_sec,
                         const bool pretendi_guardian)
  {
   if(ABTG_PausaAttiva_Calc(ts_pausa,ts_fino,ora))            return(1);
   if(ABTG_CapAttivo_Calc(ts_cap,ora,tolleranza_sec))         return(2);
   if(pretendi_guardian &&
      !ABTG_GuardianVivo_Calc(ts_battito,ora,tolleranza_sec)) return(3);
   return(0);
  }

//--- etichetta leggibile del motivo (per il giornale).
string ABTG_MotivoTesto(const int motivo)
  {
   if(motivo==1) return("PAUSA GIORNALIERA del Guardian (firma B1)");
   if(motivo==2) return("CAP RISCHIO APERTO raggiunto (firma C1)");
   if(motivo==3) return("Guardian non batte e questo EA lo pretende");
   if(motivo==4) return("PERDITE CONSECUTIVE OGGI su questa sedia (freno P1)");
   if(motivo==5) return("OBIETTIVO DELLA CHALLENGE GIA' RAGGIUNTO (stop S1) -- "
                        "si riapre SOLO A MANO");
   if(motivo==6) return("TETTO SIMBOLO+LATO raggiunto (P0)");
   return("nessuno");
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   FRENO SULLE PERDITE CONSECUTIVE (P1) -- NUCLEO PURO.             |
//|                                                                   |
//|   PERCHE' un nucleo puro anche qui: il conteggio vero deve leggere |
//|   la cronologia del conto, che a tavolino non esiste. Allora il    |
//|   PENSIERO (raggruppa per posizione, giudica sul netto, interrompi |
//|   alla prima vincita) sta in una funzione che riceve la lista dei  |
//|   deal COME ARGOMENTO: l'autotest gliene passa una FINTA e prova a |
//|   macchina proprio il caso che ci ha gia' fregato una volta, il    |
//|   parziale in utile seguito dallo stop sul resto.                  |
//|                                                                   |
//|   IL DIFETTO DA NON RIFARE (FIX 3 di GoldenCross v2.00, audit      |
//|   1.4-4): contare i DEAL. Su conto HEDGING una posizione si chiude |
//|   a pezzi -- ogni pezzo e' un DEAL_ENTRY_OUT, e il pezzo preso a   |
//|   target e' un deal IN PROFITTO. Chi conta i deal vede             |
//|   "vincita, perdita" dove c'e' UNA SOLA sconfitta, azzera il       |
//|   contatore e il freno non scatta mai. Si conta per POSIZIONE      |
//|   (DEAL_POSITION_ID) e si giudica sul NETTO della posizione.       |
//+------------------------------------------------------------------+

//--- una riga di cronologia, gia' letta. E' l'unico "dato" che il
//    nucleo conosce: nessuna funzione di terminale qui dentro.
struct ABTG_DealRiga
  {
   long     magic;      // DEAL_MAGIC
   long     entry;      // DEAL_ENTRY_IN / _OUT / _OUT_BY / _INOUT
   ulong    posid;      // DEAL_POSITION_ID -- LA CHIAVE del raggruppamento
   double   netto;      // DEAL_PROFIT + DEAL_SWAP + DEAL_COMMISSION
   double   volume;     // DEAL_VOLUME
   datetime quando;     // DEAL_TIME
  };

//--- INIZIO DEL GIORNO SERVER -- nucleo.
//    ora_reset = 0 -> mezzanotte server (default).
//    Il Guardian ha lo stesso concetto in PropDayKey()/NextResetTime() con
//    InpDailyResetHour: chi vuole il freno allineato al giorno PROP del
//    conto 100k (reset alle 23, firma del 18/08) passa 23 e le due
//    contabilita' cambiano giorno nello stesso istante.
datetime ABTG_InizioGiornoServer_Calc(const datetime ora,const int ora_reset)
  {
   int h=ora_reset; if(h<0) h=0; if(h>23) h=23;      // input a prova di dito
   datetime spostata=ora-(datetime)(h*3600);         // porto indietro l'orologio
   MqlDateTime s; TimeToStruct(spostata,s);
   s.hour=0; s.min=0; s.sec=0;
   return((datetime)(StructToTime(s)+(datetime)(h*3600)));
  }

//+------------------------------------------------------------------+
//| PERDITE CONSECUTIVE -- nucleo puro.                               |
//|                                                                    |
//| deals[]       = cronologia gia' letta (in qualunque ordine)         |
//| magic_voluto  = la SEDIA: i deal di altri magic si ignorano         |
//| da            = inizio della finestra (giorno server): i deal       |
//|                 precedenti si ignorano -> a giorno nuovo il         |
//|                 conteggio riparte da zero da solo, senza stato      |
//|                 salvato da nessuna parte (robusto al riavvio)       |
//| pos_vive[]    = POSITION_ID delle posizioni ANCORA APERTE: una      |
//|                 posizione che ha fatto il parziale ma sta ancora    |
//|                 correndo NON e' ne' vinta ne' persa, non si conta   |
//| perche        = spiegazione per il giornale (chi ha interrotto la   |
//|                 serie e con quale netto): una serie che si azzera   |
//|                 in silenzio e' un freno che non si sa spiegare      |
//|                                                                     |
//| Ritorna il numero di POSIZIONI CHIUSE IN PERDITA CONSECUTIVE piu'   |
//| recenti (0 = nessuna, o nessuna posizione chiusa oggi: non e' un    |
//| errore, e' una giornata che non ha ancora chiuso niente).           |
//+------------------------------------------------------------------+
int ABTG_PerditeConsecutive_Calc(const ABTG_DealRiga &deals[],
                                 const long magic_voluto,
                                 const datetime da,
                                 const ulong &pos_vive[],
                                 string &perche)
  {
   perche="";
   int nd=ArraySize(deals);
   int nv=ArraySize(pos_vive);

   //--- 1) RAGGRUPPAMENTO PER POSIZIONE (il cuore del fix).
   ulong    pid[];      // POSITION_ID
   double   pnet[];     // netto della posizione = somma di TUTTI i suoi deal
   double   pout[];     // volume USCITO: se 0 la posizione non ha chiuso niente
   datetime plast[];    // ora dell'ultimo deal = ordine di chiusura
   int np=0;

   for(int i=0;i<nd;i++)
     {
      if(deals[i].magic!=magic_voluto) continue;      // sedia di qualcun altro
      if(deals[i].quando<da)           continue;      // giorno precedente
      long e=deals[i].entry;
      // solo i deal di trading: saldi, crediti e bonus non sono trade
      if(e!=DEAL_ENTRY_IN && e!=DEAL_ENTRY_OUT &&
         e!=DEAL_ENTRY_OUT_BY && e!=DEAL_ENTRY_INOUT) continue;
      ulong pos=deals[i].posid;
      if(pos==0) continue;

      int idx=-1;
      for(int j=0;j<np;j++) if(pid[j]==pos) { idx=j; break; }
      if(idx<0)
        {
         idx=np; np++;
         ArrayResize(pid,np); ArrayResize(pnet,np);
         ArrayResize(pout,np); ArrayResize(plast,np);
         pid[idx]=pos; pnet[idx]=0.0; pout[idx]=0.0; plast[idx]=0;
        }
      // il deal d'INGRESSO entra nel netto: la commissione spesso sta li'
      pnet[idx]+=deals[i].netto;
      if(e!=DEAL_ENTRY_IN) pout[idx]+=deals[i].volume;
      if(deals[i].quando>plast[idx]) plast[idx]=deals[i].quando;
     }

   if(np==0)
     {
      perche="nessuna posizione di questa sedia nella finestra di oggi";
      return(0);
     }

   //--- 2) ORDINE DI CHIUSURA (ultimo deal). np e' un pugno di elementi:
   //    l'ordinamento a bolla qui costa niente ed e' leggibile.
   for(int a=0;a<np-1;a++)
      for(int b=a+1;b<np;b++)
         if(plast[b]<plast[a])
           {
            datetime tt=plast[a]; plast[a]=plast[b]; plast[b]=tt;
            ulong    ii=pid[a];   pid[a]=pid[b];     pid[b]=ii;
            double   nn=pnet[a];  pnet[a]=pnet[b];   pnet[b]=nn;
            double   vv=pout[a];  pout[a]=pout[b];   pout[b]=vv;
           }

   //--- 3) LA SERIE. Scorro in avanti e azzero a ogni vincita: quello che
   //    resta alla fine e' esattamente la serie che sta correndo ADESSO,
   //    cioe' "a ritroso fino alla prima posizione in utile".
   int    serie=0, chiuse=0;
   ulong  idRottura=0;
   double nettoRottura=0.0;

   for(int j=0;j<np;j++)
     {
      if(pout[j]<=0.0) continue;                  // aperta e mai toccata
      bool viva=false;
      for(int k=0;k<nv;k++) if(pos_vive[k]==pid[j]) { viva=true; break; }
      if(viva) continue;                          // parziale fatto, il resto corre
      chiuse++;
      if(pnet[j]<0.0) serie++;
      else { serie=0; idRottura=pid[j]; nettoRottura=pnet[j]; }  // netto>=0 = non e' una sconfitta
     }

   if(chiuse==0)
      perche="nessuna posizione CHIUSA oggi per questa sedia (solo posizioni ancora vive)";
   else if(idRottura!=0)
      perche=StringFormat("%d perdite consecutive su %d posizioni chiuse oggi; "
                          "la serie riparte dalla posizione #%I64d chiusa a %+.2f (netto >=0: interrompe il conteggio)",
                          serie,chiuse,(long)idRottura,nettoRottura);
   else
      perche=StringFormat("%d perdite consecutive su %d posizioni chiuse oggi "
                          "(nessuna vincita ha ancora interrotto la serie)",serie,chiuse);

   return(serie);
  }

//+------------------------------------------------------------------+
//| LA DECISIONE -- nucleo puro. soglia <= 0 significa SPENTO.        |
//| E' QUI che vive la garanzia di no-op: a soglia 0 non esiste una   |
//| storia, per quanto brutta, che faccia scattare il freno.          |
//+------------------------------------------------------------------+
bool ABTG_TroppePerditeConsecutive_Calc(const int perdite,const int soglia)
  {
   if(soglia<=0) return(false);      // 0 = spento (default della flotta)
   return(perdite>=soglia);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   STOP A OBIETTIVO RAGGIUNTO (S1) -- NUCLEO PURO.                  |
//|                                                                   |
//|   IL PROBLEMA, con le parole del referto che l'ha trovato          |
//|   (report/SWEEP_APPROFONDITO_EA_2026-08-22.md, par. 6):            |
//|   "il giorno in cui il conto tocca +10%, la challenge e' finita -- |
//|   e oggi, nel nostro sistema, non esiste una sola riga di codice   |
//|   che lo sappia: gli EA continuerebbero a operare, e un solo       |
//|   brutto pomeriggio riporterebbe l'equity sotto il target."        |
//|                                                                    |
//|   LA REGOLA, in una riga: raggiunto il traguardo, NON SI APRE PIU'.|
//|                                                                    |
//|   TRE COSE CHE S1 NON FA, e vanno lette prima di accenderlo:        |
//|    1. NON CHIUDE NIENTE. Blocca l'APERTURA, non tocca le posizioni |
//|       vive. Chiudere una posizione e' una decisione di rischio     |
//|       (puo' realizzare una perdita, o buttare via un utile che sta |
//|       correndo): quella resta di Claudio e, semmai, del Guardian   |
//|       che gia' sa chiudere. Un meccanismo NUOVO non se la prende.  |
//|       Il referto propone anche "chiudi tutto e cancella i          |
//|       pendenti": e' un pezzo SEPARATO, lato Guardian, e non e' qui.|
//|    2. NON SA DEI WEEKEND ne' delle giornate: non e' un contatore   |
//|       giornaliero, e' un traguardo raggiunto una volta per sempre. |
//|    3. NON SA cosa dice il regolamento della prop. Il numero (10,1) |
//|       e il saldo di riferimento glieli passa chi lo accende.       |
//+------------------------------------------------------------------+

//--- IL TRAGUARDO IN VALUTA. 0 = spento o dati non validi.
//    Utile anche solo per un pannello: "mancano X per finire".
double ABTG_ObiettivoSoglia_Calc(const double saldo_riferimento,const double target_pct)
  {
   if(saldo_riferimento<=0.0) return(0.0);      // riferimento non dichiarato
   if(target_pct<=0.0)        return(0.0);      // target spento / dito storto
   return(saldo_riferimento+saldo_riferimento*target_pct/100.0);
  }

//+------------------------------------------------------------------+
//| IL CONTO HA RAGGIUNTO IL TRAGUARDO? -- nucleo puro.               |
//|                                                                    |
//| saldo_riferimento = il capitale di partenza della challenge        |
//|                     (es. 100000). 0 = S1 SPENTO.                   |
//| valore_attuale    = saldo (scelta di casa) oppure equity, gia'     |
//|                     letto dal chiamante. Qui e' solo un numero.    |
//| target_pct        = il traguardo in percento (es. 10.1).           |
//|                     0 o negativo = S1 SPENTO.                      |
//|                                                                    |
//| E' QUI che vive la garanzia di no-op, esattamente come per P1:     |
//| a target 0 non esiste un saldo, per quanto grasso, che faccia      |
//| scattare S1.                                                       |
//+------------------------------------------------------------------+
bool ABTG_ObiettivoRaggiunto_Calc(const double saldo_riferimento,
                                  const double valore_attuale,
                                  const double target_pct)
  {
   if(target_pct<=0.0)        return(false);    // spento: no-op assoluto
   if(saldo_riferimento<=0.0) return(false);    // riferimento non dichiarato
   if(valore_attuale<=0.0)    return(false);    // conto a zero: non e' un traguardo

   double soglia=ABTG_ObiettivoSoglia_Calc(saldo_riferimento,target_pct);
   if(soglia<=0.0)            return(false);

   // ">=" con un centesimo di tolleranza: vedi ABTG_EPS_VALUTA.
   return(valore_attuale>=soglia-ABTG_EPS_VALUTA);
  }

//+------------------------------------------------------------------+
//| IL LATCH -- nucleo puro. "Scattato una volta, scattato per sempre"|
//| (fino al reset a mano).                                           |
//|                                                                    |
//| PERCHE' il latch e' il cuore di S1 e non un dettaglio: senza, un   |
//| conto che tocca +10,1% alle 15:00 e ridiscende a +9,8% alle 16:00  |
//| tornerebbe a operare -- cioe' proprio lo scenario da cui S1 deve   |
//| difendere ("restituire il giorno dopo tutto il guadagno").         |
//|                                                                    |
//| ORDINE DEI CONTROLLI, ognuno con la sua ragione:                   |
//|  1. target<=0 -> false. S1 spento su QUESTA sedia = no-op totale,  |
//|     anche se il latch e' acceso per il conto. E' il prezzo della   |
//|     retrocompatibilita' assoluta: una sedia che non ha mai sentito |
//|     parlare di S1 non deve cambiare comportamento. (Conseguenza    |
//|     dichiarata: S1 e' per CONTO nella MEMORIA, per SEDIA           |
//|     nell'EFFETTO. Chi vuole coprire tutto lo accende su tutto.)    |
//|  2. gia_scattato -> true, SENZA guardare i numeri. Il traguardo e' |
//|     un FATTO ACCADUTO, non una condizione da rivalutare.           |
//|  3. altrimenti si misura.                                          |
//+------------------------------------------------------------------+
bool ABTG_ObiettivoLatch_Calc(const bool gia_scattato,
                              const double saldo_riferimento,
                              const double valore_attuale,
                              const double target_pct)
  {
   if(target_pct<=0.0) return(false);           // 1. spento su questa sedia
   if(gia_scattato)    return(true);            // 2. IL LATCH
   return(ABTG_ObiettivoRaggiunto_Calc(saldo_riferimento,valore_attuale,target_pct)); // 3.
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   LETTURA DELLE GlobalVariable -- l'unico punto che tocca il       |
//|   terminale. Sopra c'e' il pensiero, qui c'e' il filo.             |
//|                                                                   |
//+------------------------------------------------------------------+

//--- Nomi delle GlobalVariable (per conto: il canale non si mischia
//    fra conti diversi aperti nello stesso terminale).
string ABTG_GVNome(const string radice)
  {
   return(StringFormat("%s_%I64d",radice,AccountInfoInteger(ACCOUNT_LOGIN)));
  }

//--- Lettura sicura: se la variabile non esiste ritorna 0.
double ABTG_GVLeggi(const string radice)
  {
   string n=ABTG_GVNome(radice);
   if(!GlobalVariableCheck(n)) return(0.0);
   return(GlobalVariableGet(n));
  }

//--- Scrittura (v1.40, la usa SOLO il latch S1: B1/C1 le scrive il
//    Guardian, questo include le legge e basta). GlobalVariableSet crea
//    la variabile se non c'e' e la fa persistere sul disco del terminale:
//    e' cosi' che il latch sopravvive al riavvio del VPS.
void ABTG_GVScrivi(const string radice,const double valore)
  {
   GlobalVariableSet(ABTG_GVNome(radice),valore);
  }

//--- Cancellazione (la usa SOLO il reset a mano di S1).
bool ABTG_GVCancella(const string radice)
  {
   string n=ABTG_GVNome(radice);
   if(!GlobalVariableCheck(n)) return(true);    // gia' assente: e' il risultato voluto
   return(GlobalVariableDel(n));
  }

//+------------------------------------------------------------------+
//| IL CANALE ESISTE SU QUESTO CONTO?                                 |
//| false = su questo conto/terminale il Guardian non e' MAI stato     |
//| avviato (nessuna delle sue GlobalVariable e' mai stata creata).    |
//|                                                                    |
//| E' il FAIL-OPEN TOTALE, ed e' il motivo per cui la migrazione si   |
//| puo' fare a default acceso senza cambiare il comportamento di      |
//| nessuno: conto senza Guardian, e Strategy Tester, si comportano    |
//| ESATTAMENTE come prima. Nel tester le GV del Guardian non esistono,|
//| quindi i backtest restano confrontabili con quelli di ieri.        |
//+------------------------------------------------------------------+
bool ABTG_CanaleEsiste()
  {
   if(GlobalVariableCheck(ABTG_GVNome("ABTG_GUARDIAN_BATTITO"))) return(true);
   if(GlobalVariableCheck(ABTG_GVNome("ABTG_PAUSA_GIORNO")))     return(true);
   if(GlobalVariableCheck(ABTG_GVNome("ABTG_CAP_RISCHIO")))      return(true);
   return(false);
  }

//+------------------------------------------------------------------+
//| PAUSA MORBIDA GIORNALIERA (regola B1, firma 18/08/2026).          |
//| true = il guardiano ha visto la giornata sotto la soglia (o e'    |
//| scattato il blocco d'emergenza / la challenge e' fallita):        |
//| NON si aprono nuovi trade fino al reset del giorno prop.          |
//|                                                                   |
//| La pausa ha una SCADENZA scritta dal guardiano (il prossimo reset |
//| giornaliero): se il guardiano muore con la pausa accesa, gli EA   |
//| non restano fermi in eterno.                                      |
//+------------------------------------------------------------------+
bool PausaGiornoAttiva()
  {
   return(ABTG_PausaAttiva_Calc(ABTG_GVLeggi("ABTG_PAUSA_GIORNO"),
                                ABTG_GVLeggi("ABTG_PAUSA_FINO"),
                                TimeCurrent()));
  }

//+------------------------------------------------------------------+
//| CAP SUL RISCHIO APERTO SIMULTANEO (regola C1, firma 18/08/2026).  |
//| true = la somma degli SL vivi ha raggiunto il cap: non si aggiunge|
//| altro rischio finche' non rientra.                                |
//|                                                                   |
//| Il guardiano riscrive il timestamp a ogni secondo: se smette di   |
//| aggiornarlo il cap scade da solo entro la tolleranza (fail-open). |
//+------------------------------------------------------------------+
bool CapRischioAttivo(const int tolleranza_sec=ABTG_BATTITO_TOLLERANZA)
  {
   return(ABTG_CapAttivo_Calc(ABTG_GVLeggi("ABTG_CAP_RISCHIO"),
                              TimeCurrent(),tolleranza_sec));
  }

//+------------------------------------------------------------------+
//| Il guardiano sta girando? (battito aggiornato di recente)         |
//| Serve a un EA che vuole essere PRUDENTE: "se il cane da guardia   |
//| non c'e', io non apro". E' una scelta dell'EA, non un default.    |
//+------------------------------------------------------------------+
bool GuardianVivo(const int tolleranza_sec=ABTG_BATTITO_TOLLERANZA)
  {
   return(ABTG_GuardianVivo_Calc(ABTG_GVLeggi("ABTG_GUARDIAN_BATTITO"),
                                 TimeCurrent(),tolleranza_sec));
  }

//+------------------------------------------------------------------+
//| Rischio aperto simultaneo in % dell'equity, come lo misura il     |
//| guardiano (informativo: per log e pannelli, non per decidere).    |
//+------------------------------------------------------------------+
double RischioApertoPct()
  {
   return(ABTG_GVLeggi("ABTG_RISCHIO_APERTO"));
  }

//+------------------------------------------------------------------+
//| Scorciatoia: true se si puo' aprire un nuovo trade.               |
//| pretendi_guardian=true -> non apre nemmeno se il guardiano e'     |
//| spento (uso su conto prop, dove la sorveglianza e' obbligatoria). |
//+------------------------------------------------------------------+
bool ABTG_PuoAprire(const bool pretendi_guardian=false)
  {
   if(!ABTG_CanaleEsiste()) return(true);       // nessun guardiano qui: fail-open
   return(ABTG_MotivoStop_Calc(ABTG_GVLeggi("ABTG_PAUSA_GIORNO"),
                               ABTG_GVLeggi("ABTG_PAUSA_FINO"),
                               ABTG_GVLeggi("ABTG_CAP_RISCHIO"),
                               ABTG_GVLeggi("ABTG_GUARDIAN_BATTITO"),
                               TimeCurrent(),ABTG_BATTITO_TOLLERANZA,
                               pretendi_guardian)==0);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   FRENO P1 -- IL FILO: legge la cronologia vera e chiama il nucleo.|
//|                                                                   |
//|   AVVISO IMPORTANTE (effetto collaterale dichiarato):              |
//|   HistorySelect() cambia la finestra di cronologia CONDIVISA del   |
//|   terminale. Se un EA fa HistorySelect(...) e POI scorre           |
//|   HistoryDealsTotal(), una nostra chiamata in mezzo gli cambia i   |
//|   deal sotto i piedi. Per questo il freno:                         |
//|    - non legge NIENTE quando la soglia e' 0 (default): a freno     |
//|      spento non tocca nemmeno la cronologia, quindi non puo'       |
//|      disturbare nessun EA della flotta;                            |
//|    - va chiamato dove va chiamata la guardia, cioe' subito PRIMA   |
//|      di mandare l'ordine, non in mezzo a un giro sulla cronologia. |
//|                                                                    |
//|   NEL TESTER FUNZIONA (a differenza di pausa e cap, che dipendono  |
//|   dalle GlobalVariable del Guardian e nel tester non esistono):    |
//|   il freno guarda solo la cronologia della sedia. E' voluto --     |
//|   e' l'unico modo di MISURARE N con un backtest prima di firmarlo. |
//+------------------------------------------------------------------+

//--- la posizione e' ancora aperta? (in hedging POSITION_IDENTIFIER e'
//    l'identificativo che i deal riportano in DEAL_POSITION_ID).
//    Mattone pubblico: il conteggio qui sotto si costruisce la sua lista
//    in un giro solo, ma un EA che deve chiederlo per UNA posizione ha
//    gia' la funzione e non se la riscrive.
bool ABTG_PosizioneAncoraAperta(const ulong pos_id)
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      if((ulong)PositionGetInteger(POSITION_IDENTIFIER)==pos_id) return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| POSIZIONI CHIUSE IN PERDITA CONSECUTIVE OGGI, con spiegazione.    |
//|                                                                    |
//| magic     = la sedia. I deal di altri magic sono ignorati.         |
//| perche    = spiegazione pronta per il giornale (in uscita).        |
//| ora_reset = ora server in cui gira il giorno (0 = mezzanotte).     |
//| simbolo   = "" (default) = tutti. Si passa _Symbol se per sbaglio  |
//|             lo stesso magic gira su piu' strumenti.                |
//|                                                                    |
//| LIMITE DICHIARATO (lo stesso di GoldenCross v2.00): la finestra e' |
//| la giornata. Di una posizione APERTA IERI e chiusa oggi si vede    |
//| solo la parte di oggi, quindi manca l'eventuale commissione        |
//| d'ingresso. Il SEGNO del netto quasi mai cambia per una            |
//| commissione, ma sta scritto qui e non nella testa di nessuno.      |
//|                                                                    |
//| Se la cronologia non e' disponibile ritorna 0 (FAIL-OPEN: un       |
//| conteggio che non si puo' fare non deve fermare la sedia).         |
//+------------------------------------------------------------------+
int ABTG_PerditeConsecutiveOggiSpiega(const long magic,string &perche,
                                      const int ora_reset=0,const string simbolo="")
  {
   perche="";
   datetime ora=TimeCurrent();
   datetime da =ABTG_InizioGiornoServer_Calc(ora,ora_reset);

   if(!HistorySelect(da,ora+1))
     {
      perche="cronologia non disponibile: conteggio sospeso (fail-open)";
      return(0);
     }

   ABTG_DealRiga deals[];
   int n=0;
   int tot=HistoryDealsTotal();
   for(int i=0;i<tot;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      if(HistoryDealGetInteger(tk,DEAL_MAGIC)!=magic) continue;
      if(simbolo!="" && HistoryDealGetString(tk,DEAL_SYMBOL)!=simbolo) continue;

      n++; ArrayResize(deals,n,64);   // riserva: i deal di un giorno sono pochi
      deals[n-1].magic  =(long)HistoryDealGetInteger(tk,DEAL_MAGIC);
      deals[n-1].entry  =(long)HistoryDealGetInteger(tk,DEAL_ENTRY);
      deals[n-1].posid  =(ulong)HistoryDealGetInteger(tk,DEAL_POSITION_ID);
      deals[n-1].netto  = HistoryDealGetDouble(tk,DEAL_PROFIT)
                         +HistoryDealGetDouble(tk,DEAL_SWAP)
                         +HistoryDealGetDouble(tk,DEAL_COMMISSION);
      deals[n-1].volume = HistoryDealGetDouble(tk,DEAL_VOLUME);
      deals[n-1].quando =(datetime)HistoryDealGetInteger(tk,DEAL_TIME);
     }

   //--- posizioni ancora vive di QUESTA sedia (parziale fatto, resto in corsa)
   ulong vive[];
   int nv=0;
   for(int p=PositionsTotal()-1;p>=0;p--)
     {
      ulong tk=PositionGetTicket(p);
      if(tk==0) continue;
      if(PositionGetInteger(POSITION_MAGIC)!=magic) continue;
      if(simbolo!="" && PositionGetString(POSITION_SYMBOL)!=simbolo) continue;
      nv++; ArrayResize(vive,nv);
      vive[nv-1]=(ulong)PositionGetInteger(POSITION_IDENTIFIER);
     }

   return(ABTG_PerditeConsecutive_Calc(deals,magic,da,vive,perche));
  }

//--- versione corta: il numero e basta.
int ABTG_PerditeConsecutiveOggi(const long magic,const int ora_reset=0,
                                const string simbolo="")
  {
   string ignorata="";
   return(ABTG_PerditeConsecutiveOggiSpiega(magic,ignorata,ora_reset,simbolo));
  }

//+------------------------------------------------------------------+
//| IL FRENO: true = questa sedia ha gia' incassato 'soglia' perdite  |
//| consecutive oggi e non deve aprire altro fino al giorno nuovo.    |
//|                                                                    |
//| soglia = 0 (default in tutta la flotta) -> SEMPRE false, e non     |
//| viene nemmeno letta la cronologia. Il valore di N NON e' deciso    |
//| qui: il dossier propone 3, la firma e' di Claudio, sedia per sedia.|
//+------------------------------------------------------------------+
bool ABTG_TroppePerditeConsecutive(const long magic,const int soglia,
                                   const string chi="EA",
                                   const int ora_reset=0,const string simbolo="")
  {
   if(soglia<=0) return(false);                 // spento: nemmeno una lettura

   string perche="";
   int perdite=ABTG_PerditeConsecutiveOggiSpiega(magic,perche,ora_reset,simbolo);
   bool  frena =ABTG_TroppePerditeConsecutive_Calc(perdite,soglia);

   // il giornale deve poter spiegare sia il blocco SIA il non-blocco:
   // una serie che si azzera in silenzio e' un freno che non si sa leggere.
   static datetime ultimoLogFreno=0;
   static bool     ultimoStatoFreno=false;
   datetime ora=TimeCurrent();
   if(frena!=ultimoStatoFreno || (ora-ultimoLogFreno)>=ABTG_LOG_OGNI_SEC)
     {
      PrintFormat("[FRENO P1] %s magic=%I64d: %s -- %s (soglia %d)",
                  chi,magic,(frena?"INGRESSI FERMI PER OGGI":"libero"),perche,soglia);
      ultimoLogFreno=ora;
     }
   ultimoStatoFreno=frena;
   return(frena);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   STOP S1 -- IL FILO: legge il conto, tiene il latch, spiega.      |
//|                                                                   |
//|   FAIL-OPEN o FAIL-CLOSED? La risposta e' DIVERSA da B1/C1, e va   |
//|   detta chiaro perche' e' il punto in cui S1 rompe con lo schema.  |
//|                                                                   |
//|   B1 e C1 sono fail-open per costruzione: dipendono dal BATTITO di |
//|   ABTG_Guardian.mq5, e un cane da guardia morto non deve fermare   |
//|   la flotta per sempre. S1 NON dipende dal battito: il latch sta   |
//|   in una GlobalVariable che scrive l'EA STESSO, e il traguardo si  |
//|   ricalcola da due numeri che l'EA ha nei suoi input (riferimento  |
//|   e target) piu' il saldo, che il terminale conosce sempre.        |
//|   Quindi S1 FUNZIONA ANCHE A GUARDIAN MORTO, ed e' voluto: e' il   |
//|   muro dalla parte del profitto, e bloccare un ingresso di troppo  |
//|   non ha mai fatto perdere una challenge.                          |
//|                                                                    |
//|   E se la GV si perde (terminale reinstallato, profilo nuovo, GV   |
//|   scaduta per inutilizzo -- MT5 cancella le GlobalVariable non     |
//|   usate da 4 settimane)? Allora S1 RICALCOLA dal saldo:            |
//|    - se il conto e' ancora sopra il traguardo -> riscatta subito,  |
//|      da solo. Il latch e' una MEMORIA, la VERITA' e' il saldo;     |
//|    - se il conto e' RIDISCESO sotto il traguardo -> S1 tornerebbe  |
//|      a lasciar passare gli ordini. E' l'UNICO buco di S1, ed e'    |
//|      dichiarato qui invece che scoperto dopo. Mitigazione pratica: |
//|      la GV viene letta a ogni tentativo d'ingresso, e una GV letta |
//|      non scade; e il giorno in cui il traguardo e' raggiunto la    |
//|      cosa giusta da fare comunque e' che la challenge la chiuda    |
//|      una persona, non un file.                                     |
//|                                                                    |
//|   NOTA sul Strategy Tester: le GlobalVariable esistono anche li',  |
//|   separate da quelle del terminale. A target 0 (default) S1 non ne |
//|   legge ne' scrive nessuna, quindi i backtest di ieri restano      |
//|   confrontabili riga per riga con quelli di domani.                |
//+------------------------------------------------------------------+

//--- IL LATCH E' ACCESO? (informativo: per pannelli e per il Guardian)
bool ABTG_ObiettivoLatchScattato()
  {
   return(ABTG_GVLeggi("ABTG_OBIETTIVO_RAGGIUNTO")>0.0);
  }

//--- QUANDO e' scattato (0 = mai).
datetime ABTG_ObiettivoQuandoScattato()
  {
   return((datetime)ABTG_GVLeggi("ABTG_OBIETTIVO_RAGGIUNTO"));
  }

//--- Il valore misurato all'istante dello scatto (0 = mai scattato).
double ABTG_ObiettivoValoreAlloScatto()
  {
   return(ABTG_GVLeggi("ABTG_OBIETTIVO_VALORE"));
  }

//+------------------------------------------------------------------+
//| ACCENDE IL LATCH e lo scrive su disco. Idempotente: se e' gia'    |
//| acceso non lo ritimbra (l'ora dello scatto e' l'ora del PRIMO     |
//| scatto, e deve restare quella -- serve a raccontare alla prop     |
//| quando abbiamo smesso).                                           |
//+------------------------------------------------------------------+
void ABTG_ObiettivoTimbra(const double valore,const double soglia,const string chi)
  {
   if(ABTG_ObiettivoLatchScattato()) return;    // gia' timbrato: non si sovrascrive

   ABTG_GVScrivi("ABTG_OBIETTIVO_VALORE",valore);
   ABTG_GVScrivi("ABTG_OBIETTIVO_SOGLIA",soglia);
   ABTG_GVScrivi("ABTG_OBIETTIVO_RAGGIUNTO",(double)TimeCurrent());   // per ultima: e' la bandiera

   PrintFormat("[STOP S1] %s: OBIETTIVO RAGGIUNTO. Misura=%.2f soglia=%.2f. "
               "Da adesso NESSUN nuovo ingresso su questo conto per le sedie con S1 acceso. "
               "Le posizioni gia' aperte NON vengono toccate. Si riapre SOLO A MANO "
               "(ABTG_ObiettivoResetta oppure cancellando la GlobalVariable %s).",
               chi,valore,soglia,ABTG_GVNome("ABTG_OBIETTIVO_RAGGIUNTO"));
  }

//+------------------------------------------------------------------+
//| RESET A MANO -- l'unico modo di rimettere in moto la flotta.      |
//|                                                                    |
//| Si usa in due modi, e sono equivalenti:                            |
//|  a) da uno script/EA:  ABTG_ObiettivoResetta("CLAUDIO");           |
//|  b) a mano dal terminale: F3 (Strumenti > Variabili globali),      |
//|     cancellare ABTG_OBIETTIVO_RAGGIUNTO_<login>.                   |
//|                                                                    |
//| ATTENZIONE, ed e' il motivo per cui non esiste un reset            |
//| automatico: se il conto e' ANCORA sopra il traguardo, la prima     |
//| sedia che prova ad aprire fara' riscattare S1 all'istante. Il      |
//| reset serve dopo che una PERSONA ha deciso cosa fare della         |
//| challenge (ritirare il profitto, passare alla fase 2, cambiare     |
//| il saldo di riferimento), non per continuare a tradare.            |
//+------------------------------------------------------------------+
bool ABTG_ObiettivoResetta(const string chi="MANO")
  {
   bool era=ABTG_ObiettivoLatchScattato();
   bool ok =ABTG_GVCancella("ABTG_OBIETTIVO_RAGGIUNTO");
   ABTG_GVCancella("ABTG_OBIETTIVO_VALORE");
   ABTG_GVCancella("ABTG_OBIETTIVO_SOGLIA");
   PrintFormat("[STOP S1] %s: reset del latch (era %s, cancellazione %s). "
               "Se il conto e' ancora sopra il traguardo, S1 riscattera' al primo ingresso.",
               chi,(era?"ACCESO":"gia' spento"),(ok?"riuscita":"FALLITA"));
   return(ok);
  }

//+------------------------------------------------------------------+
//| LA DOMANDA CHE FA L'EA: "posso ancora aprire, o abbiamo finito?"  |
//| true = OBIETTIVO RAGGIUNTO -> NON si apre piu'.                   |
//|                                                                    |
//| saldo_riferimento = capitale di partenza della challenge (0=off)  |
//| target_pct        = traguardo in percento (0=off; il campo usa    |
//|                     10,1 in fase 1 e 5,1 in fase 2 -- fonti nel   |
//|                     changelog v1.40 in testa al file)             |
//| chi               = nome della sedia, per il giornale             |
//| su_equity         = false (default) -> misura sul SALDO.          |
//|                     true -> misura sull'EQUITY: piu' pronto, ma   |
//|                     puo' scattare su un picco intraday che poi    |
//|                     rientra, E IL LATCH NON SI PENTE. Opt-in.     |
//|                                                                    |
//| A target 0 o riferimento 0 questa funzione esce PRIMA di toccare  |
//| qualunque GlobalVariable e qualunque dato di conto: no-op vero.   |
//+------------------------------------------------------------------+
bool ABTG_ObiettivoRaggiunto(const double saldo_riferimento,const double target_pct,
                             const string chi="EA",const bool su_equity=false)
  {
   if(target_pct<=0.0 || saldo_riferimento<=0.0) return(false);   // spento: nemmeno una lettura

   bool   latch =ABTG_ObiettivoLatchScattato();
   double valore=(su_equity? AccountInfoDouble(ACCOUNT_EQUITY)
                           : AccountInfoDouble(ACCOUNT_BALANCE));
   double soglia=ABTG_ObiettivoSoglia_Calc(saldo_riferimento,target_pct);

   bool fermo=ABTG_ObiettivoLatch_Calc(latch,saldo_riferimento,valore,target_pct);

   // primo scatto: si timbra (e si urla nel giornale una volta sola)
   if(fermo && !latch) ABTG_ObiettivoTimbra(valore,soglia,chi);

   // ripetizioni: al massimo una riga ogni ABTG_LOG_OGNI_SEC
   static datetime ultimoLogS1=0;
   datetime ora=TimeCurrent();
   if(fermo && latch && (ora-ultimoLogS1)>=ABTG_LOG_OGNI_SEC)
     {
      PrintFormat("[STOP S1] %s: ingresso rifiutato -- obiettivo raggiunto il %s "
                  "(misura allo scatto %.2f, soglia %.2f, %s ora %.2f). Reset solo a mano.",
                  chi,TimeToString(ABTG_ObiettivoQuandoScattato(),TIME_DATE|TIME_MINUTES),
                  ABTG_ObiettivoValoreAlloScatto(),soglia,
                  (su_equity?"equity":"saldo"),valore);
      ultimoLogS1=ora;
     }
   return(fermo);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   TETTO PER SIMBOLO + LATO (P0) -- NUCLEO PURO.                    |
//|                                                                   |
//|   QUESTA MODIFICA E' INERTE FINCHE' NON SI RICOMPILA. Vive nel     |
//|   repository; i binari .ex5 gia' in campo sul VPS non cambiano di  |
//|   una virgola finche' Claudio non li ricompila (vincolo D1 del     |
//|   verbale report/FIRME_2026-09-02.md). Il forward NON viene         |
//|   toccato da questo commit.                                        |
//|                                                                    |
//|   PERCHE' ESISTE: il pile-up di casa e' TRASVERSALE alle famiglie. |
//|   Misurato il 31/08: cinque EA diversi, cinque magic diversi, tutti |
//|   long sul Dow nello stesso momento. Ogni sedia rispettava il       |
//|   PROPRIO tetto (InpMaxPositions = 1 "per questo magic"): il conto  |
//|   si e' trovato con cinque volte il rischio previsto su UN solo     |
//|   sottostante e UN solo lato. Nessuno aveva sbagliato; mancava la   |
//|   regola che guarda il CONTO invece della sedia.                    |
//|                                                                    |
//|   COSA CONTA, detto senza ambiguita':                               |
//|    - POSIZIONI APERTE  + ORDINI PENDENTI (il buco B6 qui NON si    |
//|      ripete: un buy stop non ancora scattato e' rischio gia'        |
//|      impegnato, e va contato PRIMA che diventi una posizione);      |
//|    - stesso SIMBOLO;                                                |
//|    - stesso LATO: BUY + BUY_LIMIT + BUY_STOP + BUY_STOP_LIMIT       |
//|      fanno lato buy; i quattro speculari fanno lato sell. Due       |
//|      ordini OPPOSTI non si sommano: su conto hedging un buy e un    |
//|      sell sullo stesso simbolo sono una copertura, non un pile-up;  |
//|    - TUTTI I MAGIC, compresi quelli che questo EA non conosce e     |
//|      compreso l'eventuale ordine messo a mano. E' il punto: un      |
//|      tetto che guardasse solo il proprio magic non avrebbe visto    |
//|      NIENTE del caso del 31/08.                                     |
//|                                                                    |
//|   COSA NON FA (dichiarato, non scoperto dopo):                      |
//|    - non pesa il RISCHIO: conta le TESTE, non i lotti ne' la        |
//|      distanza dello stop. Cinque ordini da 0,01 contano cinque      |
//|      come cinque ordini pieni. Il tetto in percentuale resta        |
//|      mestiere del cap C1 del Guardian; questo e' un tetto sul       |
//|      NUMERO, piu' grezzo e piu' difficile da sbagliare;             |
//|    - non chiude niente e non tocca gli ordini gia' in campo: come   |
//|      tutta questa guardia, agisce solo sull'AGGIUNTA;               |
//|    - non conosce le CORRELAZIONI: Dow e Nasdaq restano due          |
//|      simboli distinti e questo tetto non li somma.                  |
//|                                                                    |
//|   NUCLEO PURO anche qui, per lo stesso motivo di P1: il conteggio   |
//|   vero deve interrogare il terminale, che a tavolino non esiste.    |
//|   Allora il PENSIERO (che cosa e' "stesso lato", che cosa conta)    |
//|   sta in funzioni che ricevono le righe COME ARGOMENTO, e           |
//|   l'autotest gliene passa di FINTE.                                 |
//+------------------------------------------------------------------+

//--- i due lati. Numeri semplici, non un enum: cosi' non collidono con
//    niente di gia' definito negli EA che includono questo file.
#ifndef ABTG_LATO_BUY
#define ABTG_LATO_BUY    1
#define ABTG_LATO_SELL  -1
#define ABTG_LATO_NULLO  0
#endif

//--- una riga di esposizione gia' letta (posizione O ordine pendente).
//    E' l'unico "dato" che il nucleo conosce: nessuna funzione di
//    terminale qui dentro.
struct ABTG_EspoRiga
  {
   string   simbolo;    // POSITION_SYMBOL / ORDER_SYMBOL
   int      tipo;       // POSITION_TYPE_* oppure ORDER_TYPE_*
   long     magic;      // tenuto solo per poter PROVARE che non filtra
  };

//+------------------------------------------------------------------+
//| Da che parte sta un tipo -- nucleo puro.                          |
//|                                                                    |
//| Vale sia per le POSIZIONI sia per gli ORDINI, e non e' una         |
//| scorciatoia: in MQL5 POSITION_TYPE_BUY e ORDER_TYPE_BUY valgono    |
//| entrambi 0, POSITION_TYPE_SELL e ORDER_TYPE_SELL entrambi 1.       |
//| Sono scritti tutti e otto a mano invece che con un "pari/dispari"  |
//| perche' un giorno qualcuno legge questa funzione e deve capire     |
//| la regola senza andarsi a ricordare l'ordine dell'enum.            |
//|                                                                    |
//| Ritorna ABTG_LATO_NULLO per qualunque altro valore (p.es.          |
//| ORDER_TYPE_CLOSE_BY): un tipo che non sappiamo leggere NON viene   |
//| contato, cioe' non blocca. Fail-open, come tutto il resto.         |
//+------------------------------------------------------------------+
//| (scritto a if e non a switch di proposito: i valori di POSITION_TYPE|
//| e di ORDER_TYPE si SOVRAPPONGONO -- 0 e 1 valgono per entrambi --   |
//| e un switch con due etichette dello stesso valore non compila.)     |
//+------------------------------------------------------------------+
int ABTG_LatoDaTipo_Calc(const int tipo)
  {
   if(tipo==(int)ORDER_TYPE_BUY             ||  // 0 -- e' anche POSITION_TYPE_BUY
      tipo==(int)ORDER_TYPE_BUY_LIMIT       ||  // 2
      tipo==(int)ORDER_TYPE_BUY_STOP        ||  // 4
      tipo==(int)ORDER_TYPE_BUY_STOP_LIMIT)     // 6
      return(ABTG_LATO_BUY);

   if(tipo==(int)ORDER_TYPE_SELL            ||  // 1 -- e' anche POSITION_TYPE_SELL
      tipo==(int)ORDER_TYPE_SELL_LIMIT      ||  // 3
      tipo==(int)ORDER_TYPE_SELL_STOP       ||  // 5
      tipo==(int)ORDER_TYPE_SELL_STOP_LIMIT)    // 7
      return(ABTG_LATO_SELL);

   return(ABTG_LATO_NULLO);
  }

//+------------------------------------------------------------------+
//| Quante teste ci sono su simbolo+lato -- nucleo puro.              |
//| righe[] = posizioni E pendenti gia' letti, in qualunque ordine.    |
//| Nessun filtro sul magic: e' voluto, ed e' il motivo per cui il     |
//| campo magic esiste nella struct (serve a provarlo a macchina).     |
//+------------------------------------------------------------------+
int ABTG_ContaSimboloLato_Calc(const ABTG_EspoRiga &righe[],
                               const string simbolo,const int lato)
  {
   if(lato==ABTG_LATO_NULLO) return(0);     // lato non dichiarato: non si conta
   int n=0;
   for(int i=ArraySize(righe)-1;i>=0;i--)
     {
      if(righe[i].simbolo!=simbolo)                    continue;
      if(ABTG_LatoDaTipo_Calc(righe[i].tipo)!=lato)    continue;
      n++;
     }
   return(n);
  }

//+------------------------------------------------------------------+
//| LA DECISIONE -- nucleo puro. true = tetto raggiunto, si rifiuta.  |
//| tetto_max <= 0 -> SPENTO, sempre false: e' il default neutro, e    |
//| non e' un'opinione ma un caso di autotest.                         |
//| Il confronto e' >= : con tetto 1 la PRIMA testa gia' presente      |
//| chiude la porta alla seconda.                                      |
//+------------------------------------------------------------------+
bool ABTG_TettoSimboloLatoRaggiunto_Calc(const ABTG_EspoRiga &righe[],
                                         const string simbolo,const int lato,
                                         const int tetto_max)
  {
   if(tetto_max<=0)          return(false); // spento (0) o dito storto (<0)
   if(lato==ABTG_LATO_NULLO) return(false); // lato non dichiarato: no-op
   return(ABTG_ContaSimboloLato_Calc(righe,simbolo,lato)>=tetto_max);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   TETTO SIMBOLO+LATO (P0) -- IL FILO: legge il terminale.          |
//|                                                                   |
//+------------------------------------------------------------------+

//--- riempie righe[] con TUTTE le posizioni e TUTTI gli ordini pendenti
//    del terminale. Ritorna quante righe ha scritto.
//    Si leggono tutti i simboli e tutti i magic: il filtro lo fa il
//    nucleo, cosi' la lettura resta una sola e banale da rileggere.
int ABTG_LeggiEsposizione(ABTG_EspoRiga &righe[])
  {
   int n=0;
   ArrayResize(righe,0);

   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong tk=PositionGetTicket(i);
      if(tk<=0) continue;
      ArrayResize(righe,n+1);
      righe[n].simbolo=PositionGetString(POSITION_SYMBOL);
      righe[n].tipo   =(int)PositionGetInteger(POSITION_TYPE);
      righe[n].magic  =(long)PositionGetInteger(POSITION_MAGIC);
      n++;
     }

   // I PENDENTI: e' la meta' che il Guardian (buco B6, ABTG_Guardian.mq5
   // riga 159) non guarda. Qui si guardano.
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong tk=OrderGetTicket(i);
      if(tk<=0) continue;
      ArrayResize(righe,n+1);
      righe[n].simbolo=OrderGetString(ORDER_SYMBOL);
      righe[n].tipo   =(int)OrderGetInteger(ORDER_TYPE);
      righe[n].magic  =(long)OrderGetInteger(ORDER_MAGIC);
      n++;
     }

   return(n);
  }

//--- quante teste ci sono ADESSO su simbolo+lato (informativo: serve al
//    giornale e a un eventuale pannello).
int ABTG_ContaSimboloLato(const string simbolo,const int lato)
  {
   ABTG_EspoRiga righe[];
   ABTG_LeggiEsposizione(righe);
   return(ABTG_ContaSimboloLato_Calc(righe,simbolo,lato));
  }

//+------------------------------------------------------------------+
//| LA FUNZIONE COMMISSIONATA (cantiere P0 del 02/09).                |
//| true = tetto raggiunto, l'ingresso va RIFIUTATO.                   |
//|                                                                    |
//| NOTA SUL NOME: in questo file il suffisso _Calc ha sempre voluto   |
//| dire "nucleo puro". Qui il nome e la firma sono quelli chiesti dal |
//| cantiere, ma la funzione LEGGE IL TERMINALE. Il nucleo puro esiste |
//| e si chiama ABTG_TettoSimboloLatoRaggiunto_Calc(): e' quello che   |
//| l'autotest interroga. Scritto qui per non lasciare una trappola a  |
//| chi legge il file fra sei mesi.                                    |
//+------------------------------------------------------------------+
bool ABTG_TettoSimboloLato_Calc(const string simbolo,const int lato,
                                const int tetto_max)
  {
   if(tetto_max<=0)          return(false); // spento: nemmeno una lettura
   if(lato==ABTG_LATO_NULLO) return(false); // lato non dichiarato: no-op

   ABTG_EspoRiga righe[];
   ABTG_LeggiEsposizione(righe);
   return(ABTG_TettoSimboloLatoRaggiunto_Calc(righe,simbolo,lato,tetto_max));
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   LA GUARDIA -- la riga unica da mettere negli EA.                 |
//|                                                                   |
//+------------------------------------------------------------------+
//| attiva            = l'input InpUsaGuardian dell'EA. false =        |
//|                     comportamento identico a prima della migrazione|
//| chi               = nome dell'EA, solo per il giornale (ASCII)     |
//| pretendi_guardian = false di default: un Guardian spento NON       |
//|                     blocca la flotta                               |
//|                                                                    |
//| Ritorna true = si puo' mandare l'ordine di APERTURA.                |
//|                                                                    |
//| Fail-open a tre livelli, tutti dichiarati:                          |
//|   1. input spento          -> passa                                 |
//|   2. canale inesistente    -> passa (conto senza Guardian, tester)  |
//|   3. battito vecchio       -> il cap scade da solo (nucleo)          |
//|                                                                     |
//| ARGOMENTI NUOVI v1.30 (freno P1), entrambi IN CODA e a default      |
//| neutro, cosi' le chiamate gia' scritte nella flotta non cambiano    |
//| di una virgola:                                                     |
//|   soglia_perdite_consecutive = 0 -> SPENTO, comportamento identico  |
//|                                     a prima (e nessuna lettura      |
//|                                     della cronologia);              |
//|   magic                      = il magic della sedia, serve solo se  |
//|                                la soglia e' > 0.                    |
//|                                                                     |
//| Il freno si valuta PRIMA del fail-open sul canale, perche' NON      |
//| dipende dal Guardian: e' una regola della SEDIA, e deve funzionare  |
//| anche nel tester e su un conto senza Guardian (altrimenti N non si  |
//| potrebbe misurare in backtest). Resta pero' sotto l'interruttore    |
//| 'attiva': chi lo vuole indipendente chiama direttamente             |
//| ABTG_TroppePerditeConsecutive().                                    |
//|                                                                     |
//| ARGOMENTI NUOVI v1.40 (stop S1), tutti e tre IN CODA e a default    |
//| neutro -- le chiamate della flotta (le ~40 di v1.20 e quelle a 5    |
//| argomenti di v1.30) restano valide riga per riga:                   |
//|   saldo_riferimento   = capitale di partenza della challenge        |
//|                         (0 = SPENTO, e nessuna GV viene toccata);   |
//|   obiettivo_pct       = traguardo in percento (0 = SPENTO);         |
//|   obiettivo_su_equity = false = si misura sul SALDO (scelta di      |
//|                         casa, motivata nel changelog in testa).     |
//|                                                                     |
//| S1 e' il PRIMO controllo, prima ancora del freno P1: e' l'unico     |
//| motivo di stop DEFINITIVO. Gli altri quattro dicono "non adesso",   |
//| S1 dice "abbiamo finito".                                           |
//+------------------------------------------------------------------+
//| ARGOMENTI NUOVI v1.50 (tetto P0), tutti e tre IN CODA e a default    |
//| neutro. La compatibilita' non e' una speranza, e' stata contata:     |
//| 93 chiamate reali in 65 file (mql5/Experts + standalone + Scripts,   |
//| censimento del 02/09) e TUTTE passano oggi 2 soli argomenti. Con i   |
//| default qui sotto nessuna di quelle righe cambia comportamento ne'   |
//| va toccata per compilare -- stesso identico pattern gia' usato per   |
//| P1 (v1.30, due argomenti in coda) e S1 (v1.40, tre in coda).         |
//|   tetto_simbolo_lato = 0 -> SPENTO, e nessuna lettura del terminale  |
//|                       (no-op puro, verificato in autotest);          |
//|   lato_ingresso      = ABTG_LATO_BUY / ABTG_LATO_SELL, la direzione  |
//|                       dell'ordine che si sta per mandare. 0          |
//|                       (default) = non dichiarata -> il tetto non     |
//|                       puo' decidere, e non decide;                   |
//|   simbolo_tetto      = "" (default) -> _Symbol. Si passa esplicito   |
//|                       solo dagli EA multi-simbolo, che operano su    |
//|                       un simbolo diverso da quello del grafico.      |
//|                                                                      |
//| P0 sta DOPO P1 e PRIMA del fail-open sul canale, per lo stesso       |
//| motivo di P1: non dipende dal Guardian, e' una regola del CONTO e    |
//| deve valere anche a guardiano spento e dentro il tester.             |
//+------------------------------------------------------------------+
bool ABTG_GuardiaIngresso(const bool attiva,const string chi="EA",
                          const bool pretendi_guardian=false,
                          const int soglia_perdite_consecutive=0,
                          const long magic=0,
                          const double saldo_riferimento=0.0,
                          const double obiettivo_pct=0.0,
                          const bool obiettivo_su_equity=false,
                          const int tetto_simbolo_lato=0,
                          const int lato_ingresso=ABTG_LATO_NULLO,
                          const string simbolo_tetto="")
  {
   if(!attiva) return(true);                    // 1. l'utente l'ha spenta

   // 1-ante. STOP S1 (opt-in): a target 0 o riferimento 0 e' un no-op puro
   if(obiettivo_pct>0.0 && saldo_riferimento>0.0 &&
      ABTG_ObiettivoRaggiunto(saldo_riferimento,obiettivo_pct,chi,obiettivo_su_equity))
      return(false);                            // motivo 5, gia' scritto nel giornale

   // 1-bis. freno P1 (opt-in): a soglia 0 questa riga e' un no-op puro
   if(soglia_perdite_consecutive>0 &&
      ABTG_TroppePerditeConsecutive(magic,soglia_perdite_consecutive,chi))
      return(false);

   // 1-ter. TETTO SIMBOLO+LATO (P0, opt-in): a tetto 0 o lato non
   //        dichiarato non si legge nemmeno il terminale.
   //        LA FRASE DEL GIORNALE E' DIVERSA DA QUELLA DI B1/C1, DI PROPOSITO:
   //        il collaudo enforcement (backtest_pipeline/attese_enforcement_fase1.txt)
   //        estrae il CAMPO C9.BLOCCO cercando la sottostringa "INGRESSO
   //        BLOCCATO --", e pretende che ogni riga cosi' trovata abbia nello
   //        stesso minuto una riga [GUARDIAN] che la spieghi. Un blocco P0 non
   //        ce l'ha e non puo' averla (P0 non passa dal Guardian): se usasse
   //        la stessa frase, il criterio 9 conterebbe un "blocco orfano" e
   //        segnalerebbe un difetto che non esiste. Qui si scrive INGRESSO
   //        RIFIUTATO, che non collide con nessuna ATTESA (C5.EA, C7.EA,
   //        C5/C8.RIENTRO, C6.PROMESSA) ne' con le quattro VIETATE.
   // stessa igiene di log del freno P1: si scrive al CAMBIO di stato e poi
   // al massimo una volta ogni ABTG_LOG_OGNI_SEC, perche' questa riga puo'
   // essere interrogata a ogni tick. (Dichiarate qui e non dentro il blocco
   // per restare sullo stesso schema delle statiche gia' collaudate piu'
   // sotto, ultimoMotivo/ultimoLog.)
   static datetime ultimoLogTetto  =0;
   static bool     ultimoStatoTetto=false;

   if(tetto_simbolo_lato>0 && lato_ingresso!=ABTG_LATO_NULLO)
     {
      string simP0=(StringLen(simbolo_tetto)>0 ? simbolo_tetto : _Symbol);
      int    nP0  =ABTG_ContaSimboloLato(simP0,lato_ingresso);
      bool   morde=(nP0>=tetto_simbolo_lato);
      datetime oraP0=TimeCurrent();

      if(morde && (morde!=ultimoStatoTetto || (oraP0-ultimoLogTetto)>=ABTG_LOG_OGNI_SEC))
        {
         PrintFormat("[GUARDIA] %s: INGRESSO RIFIUTATO -- %s. Su %s lato %s ci sono gia' "
                     "%d fra posizioni e pendenti (tetto %d, TUTTI i magic).",
                     chi,ABTG_MotivoTesto(6),simP0,
                     (lato_ingresso==ABTG_LATO_BUY?"BUY":"SELL"),
                     nP0,tetto_simbolo_lato);
         ultimoLogTetto=oraP0;
        }
      ultimoStatoTetto=morde;
      if(morde) return(false);
     }

   if(!ABTG_CanaleEsiste()) return(true);       // 2. nessun guardiano su questo conto

   datetime ora=TimeCurrent();
   int motivo=ABTG_MotivoStop_Calc(ABTG_GVLeggi("ABTG_PAUSA_GIORNO"),
                                   ABTG_GVLeggi("ABTG_PAUSA_FINO"),
                                   ABTG_GVLeggi("ABTG_CAP_RISCHIO"),
                                   ABTG_GVLeggi("ABTG_GUARDIAN_BATTITO"),
                                   ora,ABTG_BATTITO_TOLLERANZA,
                                   pretendi_guardian);

   // memoria per non allagare il giornale: si scrive al CAMBIO di stato
   // e poi al massimo una volta ogni ABTG_LOG_OGNI_SEC.
   static int      ultimoMotivo=-1;
   static datetime ultimoLog   =0;

   if(motivo==0)
     {
      if(ultimoMotivo>0)
         PrintFormat("[GUARDIA] %s: via libera, il blocco e' rientrato (%s). Rischio aperto %.2f%%",
                     chi,ABTG_MotivoTesto(ultimoMotivo),RischioApertoPct());
      ultimoMotivo=0;
      return(true);
     }

   if(motivo!=ultimoMotivo || (ora-ultimoLog)>=ABTG_LOG_OGNI_SEC)
     {
      PrintFormat("[GUARDIA] %s: INGRESSO BLOCCATO -- %s. Rischio aperto %.2f%%. "
                  "La posizione eventualmente gia' aperta NON viene toccata.",
                  chi,ABTG_MotivoTesto(motivo),RischioApertoPct());
      ultimoLog=ora;
     }
   ultimoMotivo=motivo;
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                   |
//|   AUTOTEST -- puro: non legge GlobalVariable, non tocca il conto,  |
//|   non manda ordini. Si puo' chiamare da OnInit di un EA o da uno   |
//|   script. Ritorna il numero di casi FALLITI (0 = tutto a posto).   |
//|                                                                   |
//+------------------------------------------------------------------+
int ABTG_AutotestCaso(const string nome,const bool ottenuto,const bool atteso,int &falliti)
  {
   bool ok=(ottenuto==atteso);
   if(!ok) falliti++;
   PrintFormat("[AUTOTEST] %-52s atteso=%s ottenuto=%s  %s",
               nome,(atteso?"SI":"NO"),(ottenuto?"SI":"NO"),(ok?"PASS":"*** FAIL ***"));
   return(falliti);
  }

//--- variante per i valori interi (il freno P1 conta, non risponde si'/no)
int ABTG_AutotestCasoInt(const string nome,const int ottenuto,const int atteso,int &falliti)
  {
   bool ok=(ottenuto==atteso);
   if(!ok) falliti++;
   PrintFormat("[AUTOTEST] %-52s atteso=%d ottenuto=%d  %s",
               nome,atteso,ottenuto,(ok?"PASS":"*** FAIL ***"));
   return(falliti);
  }

//--- aggiunge una riga alla cronologia FINTA dei test.
void ABTG_TestDeal(ABTG_DealRiga &v[],const long magic,const long entry,
                   const ulong posid,const double netto,const double volume,
                   const datetime quando)
  {
   int n=ArraySize(v)+1;
   ArrayResize(v,n);
   v[n-1].magic =magic;  v[n-1].entry =entry;  v[n-1].posid =posid;
   v[n-1].netto =netto;  v[n-1].volume=volume; v[n-1].quando=quando;
  }

//+------------------------------------------------------------------+
//| AUTOTEST DEL FRENO P1 -- 26 casi, tutti a tavolino.               |
//|                                                                    |
//| La cronologia e' FINTA e costruita qui: e' l'unico modo di provare |
//| a macchina il caso dei parziali senza un conto vero. MT5 non       |
//| permette di scrivere nella cronologia dei deal (HistoryDealGet*    |
//| e' in sola lettura, sia sul conto sia nel tester), quindi il       |
//| NUCLEO si prova con deal finti e IL FILO (lettura vera) resta da   |
//| verificare a mano UNA VOLTA su demo. Procedura, sul conto DEMO:    |
//|   1. su una sedia con soglia>0, aprire e chiudere a mano 3         |
//|      posizioni in perdita con lo STESSO magic, la terza chiusa a   |
//|      META' e poi per il resto (cosi' si prova anche il parziale);  |
//|   2. leggere le righe [FRENO P1] nel giornale: devono dire 1, 2, 3 |
//|      e "INGRESSI FERMI PER OGGI" alla terza -- non 4 per via del   |
//|      parziale;                                                     |
//|   3. il giorno dopo la prima riga deve tornare a 0 da sola.        |
//+------------------------------------------------------------------+
int ABTG_AutotestPerditeConsecutive()
  {
   int falliti=0;
   const long MAGIC=970301;      // la sedia sotto esame
   const long ALTRO=555111;      // un'altra sedia, stesso giorno

   MqlDateTime md;
   md.year=2026; md.mon=8; md.day=22; md.hour=0; md.min=0; md.sec=0;
   md.day_of_week=0; md.day_of_year=0;
   datetime OGGI=StructToTime(md);      // mezzanotte server del 22/08/2026
   datetime IERI=OGGI-86400;

   ABTG_DealRiga d[];
   ulong  nessuna[];                    // nessuna posizione ancora aperta
   ArrayResize(nessuna,0);
   string perche="";

   Print("[AUTOTEST] --- FRENO P1: perdite consecutive per POSIZIONE (hedging) ---");

   //--- 1) UNA perdita, UN solo deal di uscita -> 1
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,1001, -0.70,1.0,OGGI+10*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1001,-20.00,1.0,OGGI+11*3600);
   ABTG_AutotestCasoInt("perdita chiusa con UN deal -> 1",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),1,falliti);

   //--- 2) UNA perdita chiusa a PEZZI (3 uscite in perdita) -> 1, non 3
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,1002, -0.70,1.0,OGGI+12*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1002, -5.00,0.3,OGGI+12*3600+600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1002, -6.00,0.3,OGGI+12*3600+1200);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1002, -7.00,0.4,OGGI+12*3600+1800);
   ABTG_AutotestCasoInt("perdita chiusa in 3 PEZZI -> 1, non 3",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),1,falliti);

   //--- 3) IL CASO CHE CI HA GIA' FREGATO (FIX 3 GoldenCross):
   //    parziale in UTILE + stop sul resto, netto NEGATIVO -> 1 sconfitta.
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,1003, -0.70,1.0,OGGI+13*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1003, +8.00,0.5,OGGI+13*3600+900);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1003,-25.00,0.5,OGGI+13*3600+1800);
   ABTG_AutotestCasoInt("parziale in UTILE + stop sul resto (netto<0) -> 1",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),1,falliti);

   //--- 4) LA PROVA DEL DIFETTO: perdita piena, POI parziale-in-utile+stop.
   //    Chi conta i DEAL vede il +8 e azzera: direbbe 1. Sono DUE sconfitte.
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,1004, -0.70,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1004,-20.00,1.0,OGGI+10*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,1005, -0.70,1.0,OGGI+11*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1005, +8.00,0.5,OGGI+11*3600+900);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,1005,-25.00,0.5,OGGI+12*3600);
   ABTG_AutotestCasoInt("perdita + (parziale utile & stop) -> 2 (conta-deal direbbe 1)",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),2,falliti);

   //--- 5) UNA VINCITA IN MEZZO interrompe la serie: perdita, VINCITA,
   //    perdita, perdita -> 2 (non 3, non 0)
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2002,+30.00,1.0,OGGI+10*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2003,-11.00,1.0,OGGI+11*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2004,-12.00,1.0,OGGI+12*3600);
   ABTG_AutotestCasoInt("perdita, VINCITA, perdita, perdita -> 2",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),2,falliti);
   ABTG_AutotestCaso("la spiegazione NOMINA la vincita che ha rotto la serie",
                     (StringFind(perche,"#2002")>=0),true,falliti);
   PrintFormat("[AUTOTEST]   spiegazione prodotta: %s",perche);

   //--- 6) I DEAL ARRIVANO IN DISORDINE: conta l'ordine di CHIUSURA
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2004,-12.00,1.0,OGGI+12*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2003,-11.00,1.0,OGGI+11*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,2002,+30.00,1.0,OGGI+10*3600);
   ABTG_AutotestCasoInt("stessi deal in ORDINE SPARSO -> sempre 2",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),2,falliti);

   //--- 7) NETTO ESATTAMENTE ZERO (pareggio) = non e' una sconfitta
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,3001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,3002,  0.00,1.0,OGGI+10*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,3003,-11.00,1.0,OGGI+11*3600);
   ABTG_AutotestCasoInt("pareggio esatto (netto 0) -> interrompe la serie",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),1,falliti);

   //--- 8) DEAL DI UN'ALTRA SEDIA nello stesso giorno -> ignorati
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,4001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,ALTRO,DEAL_ENTRY_OUT,4002,+99.00,1.0,OGGI+10*3600);  // vincita ALTRUI
   ABTG_TestDeal(d,ALTRO,DEAL_ENTRY_OUT,4003,-99.00,1.0,OGGI+10*3600+60);  // perdita ALTRUI
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,4004,-11.00,1.0,OGGI+11*3600);
   ABTG_AutotestCasoInt("deal di un ALTRO magic -> ignorati, restano 2",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),2,falliti);
   ABTG_AutotestCasoInt("lo stesso storico letto dall'ALTRA sedia -> 1",
                        ABTG_PerditeConsecutive_Calc(d,ALTRO,OGGI,nessuna,perche),1,falliti);

   //--- 9) GIORNO NUOVO: le perdite di IERI non contano piu'
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,5001,-10.00,1.0,IERI+15*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,5002,-11.00,1.0,IERI+16*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,5003,-12.00,1.0,IERI+17*3600);
   ABTG_AutotestCasoInt("3 perdite di IERI, giorno nuovo -> 0",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),0,falliti);
   ABTG_AutotestCasoInt("le stesse 3 perdite dentro la finestra di IERI -> 3",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,IERI,nessuna,perche),3,falliti);

   //--- 10) NESSUN DEAL -> 0, e non e' un errore
   ArrayResize(d,0);
   ABTG_AutotestCasoInt("nessun deal oggi -> 0 (non e' un errore)",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),0,falliti);

   //--- 11) POSIZIONE APERTA E BASTA (nessuna uscita) -> non si conta
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,6001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,6002, -0.70,1.0,OGGI+10*3600);  // aperta ora
   ABTG_AutotestCasoInt("posizione appena aperta (solo IN) -> non conta, 1",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),1,falliti);

   //--- 12) PARZIALE FATTO MA POSIZIONE ANCORA VIVA -> non e' ancora
   //    ne' vinta ne' persa: non si conta (e non blocca la serie).
   ulong vive[];
   ArrayResize(vive,1); vive[0]=7002;
   ArrayResize(d,0);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,7001,-10.00,1.0,OGGI+9*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_IN ,7002, -0.70,1.0,OGGI+10*3600);
   ABTG_TestDeal(d,MAGIC,DEAL_ENTRY_OUT,7002, -3.00,0.5,OGGI+11*3600);  // parziale, resto in corsa
   ABTG_AutotestCasoInt("parziale fatto ma posizione VIVA -> non conta, 1",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,vive,perche),1,falliti);
   ABTG_AutotestCasoInt("la stessa, una volta CHIUSA -> 2",
                        ABTG_PerditeConsecutive_Calc(d,MAGIC,OGGI,nessuna,perche),2,falliti);

   //--- 13) INIZIO DEL GIORNO SERVER (mezzanotte e reset prop delle 23)
   MqlDateTime mm;
   mm.year=2026; mm.mon=8; mm.day=22; mm.hour=10; mm.min=30; mm.sec=0;
   mm.day_of_week=0; mm.day_of_year=0;
   datetime meta_mattina=StructToTime(mm);
   ABTG_AutotestCaso("giorno server reset 0 -> mezzanotte di oggi",
                     (ABTG_InizioGiornoServer_Calc(meta_mattina,0)==OGGI),true,falliti);
   ABTG_AutotestCaso("giorno server reset 23 -> ieri alle 23:00 (giorno prop)",
                     (ABTG_InizioGiornoServer_Calc(meta_mattina,23)==(IERI+23*3600)),true,falliti);
   ABTG_AutotestCaso("alle 23:30 con reset 23 -> il giorno prop e' gia' girato",
                     (ABTG_InizioGiornoServer_Calc(OGGI+23*3600+1800,23)==(OGGI+23*3600)),true,falliti);

   //--- 14) LA GARANZIA DI NO-OP: soglia 0 = SEMPRE false, qualunque storia.
   //    Se un giorno questo caso fallisce, qualcuno ha acceso il freno
   //    per sbaglio su tutta la flotta.
   ABTG_AutotestCaso("soglia 0 con 0 perdite -> NON frena",
                     ABTG_TroppePerditeConsecutive_Calc(0,0),false,falliti);
   ABTG_AutotestCaso("soglia 0 con 3 perdite -> NON frena (default = no-op)",
                     ABTG_TroppePerditeConsecutive_Calc(3,0),false,falliti);
   ABTG_AutotestCaso("soglia 0 con 99 perdite -> NON frena (default = no-op)",
                     ABTG_TroppePerditeConsecutive_Calc(99,0),false,falliti);
   ABTG_AutotestCaso("soglia negativa (dito storto) -> NON frena",
                     ABTG_TroppePerditeConsecutive_Calc(99,-5),false,falliti);

   //--- 15) SOGLIA ACCESA (la 3 proposta dal dossier, NON ancora firmata)
   ABTG_AutotestCaso("soglia 3 con 2 perdite -> non frena ancora",
                     ABTG_TroppePerditeConsecutive_Calc(2,3),false,falliti);
   ABTG_AutotestCaso("soglia 3 con 3 perdite -> FRENA",
                     ABTG_TroppePerditeConsecutive_Calc(3,3),true,falliti);
   ABTG_AutotestCaso("soglia 3 con 4 perdite -> FRENA (non si riapre da solo)",
                     ABTG_TroppePerditeConsecutive_Calc(4,3),true,falliti);

   return(falliti);
  }

//+------------------------------------------------------------------+
//| AUTOTEST DELLO STOP S1 -- 30 casi, tutti a tavolino.              |
//|                                                                    |
//| Qui non serve nessuna cronologia finta: il nucleo di S1 prende tre |
//| numeri e risponde. Quello che NON si prova a macchina e' il filo   |
//| (lettura del saldo + scrittura della GlobalVariable), che va       |
//| verificato UNA VOLTA a mano su demo. Procedura, sul conto DEMO:    |
//|   1. su una sedia con S1 acceso, mettere un saldo_riferimento      |
//|      FINTO piu' basso del saldo vero (es. riferimento = saldo/1,2) |
//|      cosi' il traguardo risulta gia' superato;                     |
//|   2. al primo tentativo d'ingresso il giornale deve scrivere       |
//|      "[STOP S1] ... OBIETTIVO RAGGIUNTO" e l'ordine NON parte;     |
//|   3. F3 nel terminale: deve esistere                               |
//|      ABTG_OBIETTIVO_RAGGIUNTO_<login> con un timestamp;            |
//|   4. riavviare il terminale: il blocco deve essere ANCORA li'      |
//|      (e' la prova della persistenza, l'unica che conta davvero);   |
//|   5. cancellare la GV (o chiamare ABTG_ObiettivoResetta) e         |
//|      rimettere il riferimento vero: la sedia torna operativa.      |
//+------------------------------------------------------------------+
int ABTG_AutotestObiettivo()
  {
   int falliti=0;

   //--- i due numeri del campo (fonti nel changelog v1.40 in testa al file)
   const double RIF =100000.0;      // challenge 100k
   const double T1  =10.1;          // fase 1: PropFirmHelper + Prop Firm Protector EZ
   const double T2  =5.1;           // fase 2: Prop Firm Protector EZ

   Print("[AUTOTEST] --- STOP S1: obiettivo raggiunto (latch, no-op, tolleranza) ---");

   //--- A) IL TRAGUARDO IN VALUTA -----------------------------------
   ABTG_AutotestCaso("soglia: 100000 + 10,1% -> 110100.00",
                     (MathAbs(ABTG_ObiettivoSoglia_Calc(RIF,T1)-110100.0)<0.005),true,falliti);
   ABTG_AutotestCaso("soglia con target 0 -> 0 (spento)",
                     (MathAbs(ABTG_ObiettivoSoglia_Calc(RIF,0.0))<0.005),true,falliti);
   ABTG_AutotestCaso("soglia con riferimento 0 -> 0 (spento)",
                     (MathAbs(ABTG_ObiettivoSoglia_Calc(0.0,T1))<0.005),true,falliti);

   //--- B) LA GARANZIA DI NO-OP (la stessa promessa fatta per P1) ----
   //    Se un giorno uno di questi casi fallisce, qualcuno ha acceso S1
   //    per sbaglio su tutta la flotta.
   ABTG_AutotestCaso("target 0 con conto al doppio -> NON scatta (no-op)",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,200000.0,0.0),false,falliti);
   ABTG_AutotestCaso("target negativo (dito storto) -> NON scatta",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,200000.0,-10.0),false,falliti);
   ABTG_AutotestCaso("riferimento 0 -> NON scatta (no-op)",
                     ABTG_ObiettivoRaggiunto_Calc(0.0,200000.0,T1),false,falliti);
   ABTG_AutotestCaso("riferimento negativo (dito storto) -> NON scatta",
                     ABTG_ObiettivoRaggiunto_Calc(-100000.0,200000.0,T1),false,falliti);
   ABTG_AutotestCaso("valore 0 (conto vuoto) -> NON scatta",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,0.0,T1),false,falliti);
   ABTG_AutotestCaso("valore negativo -> NON scatta",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,-5.0,T1),false,falliti);

   //--- C) LA SOGLIA: sotto, esatto, sopra -------------------------
   ABTG_AutotestCaso("target 10%: 109999 -> sotto, si opera",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,109999.0,10.0),false,falliti);
   ABTG_AutotestCaso("target 10%: ESATTAMENTE 110000 -> SCATTA",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,110000.0,10.0),true,falliti);
   ABTG_AutotestCaso("target 10%: 115000 -> SCATTA",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,115000.0,10.0),true,falliti);
   ABTG_AutotestCaso("fase 1 (10,1%): ESATTAMENTE 110100 -> SCATTA",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,110100.0,T1),true,falliti);
   ABTG_AutotestCaso("fase 1 (10,1%): 110099 -> NON scatta ancora",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,110099.0,T1),false,falliti);
   ABTG_AutotestCaso("fase 2 (5,1%): ESATTAMENTE 105100 -> SCATTA",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,105100.0,T2),true,falliti);
   ABTG_AutotestCaso("conto da 50000, target 10%: 55000 -> SCATTA",
                     ABTG_ObiettivoRaggiunto_Calc(50000.0,55000.0,10.0),true,falliti);
   ABTG_AutotestCaso("conto da 50000, target 10%: 54999 -> NON scatta",
                     ABTG_ObiettivoRaggiunto_Calc(50000.0,54999.0,10.0),false,falliti);
   //    la tolleranza di un centesimo: c'e', ed e' UN CENTESIMO, non di piu'
   ABTG_AutotestCaso("mezzo centesimo sotto il traguardo -> SCATTA (tolleranza)",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,110099.995,T1),true,falliti);
   ABTG_AutotestCaso("dieci centesimi sotto -> NON scatta (tolleranza stretta)",
                     ABTG_ObiettivoRaggiunto_Calc(RIF,110099.90,T1),false,falliti);

   //--- D) IL LATCH: e' qui che S1 vale davvero --------------------
   ABTG_AutotestCaso("latch spento e conto sotto -> libero",
                     ABTG_ObiettivoLatch_Calc(false,RIF,109000.0,T1),false,falliti);
   ABTG_AutotestCaso("latch spento e conto sopra -> BLOCCA (primo scatto)",
                     ABTG_ObiettivoLatch_Calc(false,RIF,110500.0,T1),true,falliti);
   ABTG_AutotestCaso("latch ACCESO e conto RIDISCESO a 105000 -> RESTA BLOCCATO",
                     ABTG_ObiettivoLatch_Calc(true,RIF,105000.0,T1),true,falliti);
   ABTG_AutotestCaso("latch ACCESO e conto sotto il riferimento -> RESTA BLOCCATO",
                     ABTG_ObiettivoLatch_Calc(true,RIF,98000.0,T1),true,falliti);
   ABTG_AutotestCaso("latch ACCESO ma target 0 su questa sedia -> libero (no-op)",
                     ABTG_ObiettivoLatch_Calc(true,RIF,105000.0,0.0),false,falliti);
   ABTG_AutotestCaso("latch ACCESO con riferimento 0 (config storta) -> BLOCCA",
                     ABTG_ObiettivoLatch_Calc(true,0.0,105000.0,T1),true,falliti);
   ABTG_AutotestCaso("latch ACCESO con valore 0 (lettura fallita) -> BLOCCA",
                     ABTG_ObiettivoLatch_Calc(true,RIF,0.0,T1),true,falliti);
   //    il reset a mano si prova qui come "latch tornato spento"
   ABTG_AutotestCaso("dopo il RESET, conto sceso a 105000 -> libero",
                     ABTG_ObiettivoLatch_Calc(false,RIF,105000.0,T1),false,falliti);
   ABTG_AutotestCaso("dopo il RESET ma conto ANCORA sopra -> riscatta subito",
                     ABTG_ObiettivoLatch_Calc(false,RIF,111000.0,T1),true,falliti);

   //--- E) IL MOTIVO NEL GIORNALE ----------------------------------
   ABTG_AutotestCaso("motivo 5 = obiettivo raggiunto (testo dedicato)",
                     (StringFind(ABTG_MotivoTesto(5),"OBIETTIVO")>=0),true,falliti);
   ABTG_AutotestCaso("motivo 4 e' ancora il freno P1 (non spostato)",
                     (StringFind(ABTG_MotivoTesto(4),"P1")>=0),true,falliti);

   return(falliti);
  }

//--- aggiunge una riga di esposizione FINTA (posizione o pendente).
void ABTG_TestEspo(ABTG_EspoRiga &v[],const string simbolo,const int tipo,
                   const long magic)
  {
   int n=ArraySize(v);
   ArrayResize(v,n+1);
   v[n].simbolo=simbolo;
   v[n].tipo   =tipo;
   v[n].magic  =magic;
  }

//+------------------------------------------------------------------+
//| AUTOTEST del TETTO SIMBOLO+LATO (P0, v1.50).                      |
//| Tutto sul nucleo puro: nessuna posizione, nessun ordine, nessun    |
//| terminale. E' il motivo per cui il nucleo esiste.                  |
//+------------------------------------------------------------------+
int ABTG_AutotestTettoSimboloLato()
  {
   int falliti=0;
   Print("[AUTOTEST] --- TETTO SIMBOLO+LATO (P0, v1.50) ---");

   //--- A) DA CHE PARTE STA UN TIPO --------------------------------
   ABTG_AutotestCasoInt("POSITION_TYPE_BUY -> lato buy",
                        ABTG_LatoDaTipo_Calc((int)POSITION_TYPE_BUY),ABTG_LATO_BUY,falliti);
   ABTG_AutotestCasoInt("POSITION_TYPE_SELL -> lato sell",
                        ABTG_LatoDaTipo_Calc((int)POSITION_TYPE_SELL),ABTG_LATO_SELL,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_BUY_STOP -> lato buy",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_BUY_STOP),ABTG_LATO_BUY,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_BUY_LIMIT -> lato buy",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_BUY_LIMIT),ABTG_LATO_BUY,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_BUY_STOP_LIMIT -> lato buy",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_BUY_STOP_LIMIT),ABTG_LATO_BUY,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_SELL_STOP -> lato sell",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_SELL_STOP),ABTG_LATO_SELL,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_SELL_LIMIT -> lato sell",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_SELL_LIMIT),ABTG_LATO_SELL,falliti);
   ABTG_AutotestCasoInt("ORDER_TYPE_SELL_STOP_LIMIT -> lato sell",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_SELL_STOP_LIMIT),ABTG_LATO_SELL,falliti);
   ABTG_AutotestCasoInt("tipo sconosciuto (CLOSE_BY) -> lato nullo, non conta",
                        ABTG_LatoDaTipo_Calc((int)ORDER_TYPE_CLOSE_BY),ABTG_LATO_NULLO,falliti);

   //--- B) IL CONTEGGIO --------------------------------------------
   ABTG_EspoRiga vuoto[];
   ABTG_AutotestCasoInt("niente in campo -> 0 teste",
                        ABTG_ContaSimboloLato_Calc(vuoto,"DAX",ABTG_LATO_BUY),0,falliti);

   // solo POSIZIONI
   ABTG_EspoRiga pos[];
   ABTG_TestEspo(pos,"DAX",(int)POSITION_TYPE_BUY,111);
   ABTG_TestEspo(pos,"DAX",(int)POSITION_TYPE_BUY,222);
   ABTG_AutotestCasoInt("2 POSIZIONI buy sul DAX -> 2 sul lato buy",
                        ABTG_ContaSimboloLato_Calc(pos,"DAX",ABTG_LATO_BUY),2,falliti);
   ABTG_AutotestCasoInt("le stesse guardate dal lato SELL -> 0 (i lati sono separati)",
                        ABTG_ContaSimboloLato_Calc(pos,"DAX",ABTG_LATO_SELL),0,falliti);

   // solo PENDENTI -- il buco B6 che qui NON si ripete
   ABTG_EspoRiga pend[];
   ABTG_TestEspo(pend,"DAX",(int)ORDER_TYPE_BUY_STOP,111);
   ABTG_TestEspo(pend,"DAX",(int)ORDER_TYPE_BUY_LIMIT,222);
   ABTG_AutotestCasoInt("2 PENDENTI buy e NESSUNA posizione -> 2 (buco B6 chiuso)",
                        ABTG_ContaSimboloLato_Calc(pend,"DAX",ABTG_LATO_BUY),2,falliti);

   // MISTI, due simboli, due lati, magic diversi
   ABTG_EspoRiga misto[];
   ABTG_TestEspo(misto,"DAX",(int)POSITION_TYPE_BUY,      770101);
   ABTG_TestEspo(misto,"DAX",(int)ORDER_TYPE_BUY_STOP,    770202);
   ABTG_TestEspo(misto,"DAX",(int)ORDER_TYPE_BUY_LIMIT,   0);        // messo a mano
   ABTG_TestEspo(misto,"DAX",(int)POSITION_TYPE_SELL,     770303);
   ABTG_TestEspo(misto,"DAX",(int)ORDER_TYPE_SELL_STOP,   770404);
   ABTG_TestEspo(misto,"DOW",(int)POSITION_TYPE_BUY,      770505);
   ABTG_AutotestCasoInt("misto: DAX lato buy -> 3 (1 posizione + 2 pendenti)",
                        ABTG_ContaSimboloLato_Calc(misto,"DAX",ABTG_LATO_BUY),3,falliti);
   ABTG_AutotestCasoInt("misto: DAX lato sell -> 2 (il buy non si somma al sell)",
                        ABTG_ContaSimboloLato_Calc(misto,"DAX",ABTG_LATO_SELL),2,falliti);
   ABTG_AutotestCasoInt("misto: DOW lato buy -> 1 (l'altro simbolo non conta)",
                        ABTG_ContaSimboloLato_Calc(misto,"DOW",ABTG_LATO_BUY),1,falliti);
   ABTG_AutotestCasoInt("misto: simbolo mai visto -> 0",
                        ABTG_ContaSimboloLato_Calc(misto,"EURUSD",ABTG_LATO_BUY),0,falliti);
   ABTG_AutotestCasoInt("il conteggio e' TRASVERSALE ai magic (4 magic + 1 a mano)",
                        ABTG_ContaSimboloLato_Calc(misto,"DAX",ABTG_LATO_BUY),3,falliti);
   ABTG_AutotestCasoInt("lato non dichiarato (0) -> conteggio 0, non decide",
                        ABTG_ContaSimboloLato_Calc(misto,"DAX",ABTG_LATO_NULLO),0,falliti);

   //--- C) LA DECISIONE, e prima di tutto il DEFAULT NEUTRO ---------
   ABTG_AutotestCaso("tetto 0 con 3 teste in campo -> NON frena (default = no-op)",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_BUY,0),false,falliti);
   ABTG_AutotestCaso("tetto 0 a campo VUOTO -> NON frena",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(vuoto,"DAX",ABTG_LATO_BUY,0),false,falliti);
   ABTG_AutotestCaso("tetto negativo (dito storto) -> NON frena",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_BUY,-1),false,falliti);
   ABTG_AutotestCaso("tetto 1 ma lato non dichiarato -> NON frena",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_NULLO,1),false,falliti);

   ABTG_AutotestCaso("tetto 1 a campo VUOTO -> si passa",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(vuoto,"DAX",ABTG_LATO_BUY,1),false,falliti);
   ABTG_AutotestCaso("tetto 1 con UNA posizione buy -> FRENA (la seconda non entra)",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(pos,"DAX",ABTG_LATO_BUY,1),true,falliti);
   ABTG_AutotestCaso("tetto 1 con UN SOLO PENDENTE buy -> FRENA lo stesso",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(pend,"DAX",ABTG_LATO_BUY,1),true,falliti);
   ABTG_AutotestCaso("tetto 3 con ESATTAMENTE 3 teste -> FRENA (il confronto e' >=)",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_BUY,3),true,falliti);
   ABTG_AutotestCaso("tetto 4 con 3 teste -> si passa (c'e' ancora posto)",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_BUY,4),false,falliti);
   ABTG_AutotestCaso("tetto 3 sul lato SELL con 2 teste sell -> si passa",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_SELL,3),false,falliti);
   ABTG_AutotestCaso("tetto 2 sul lato SELL con 2 teste sell -> FRENA",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DAX",ABTG_LATO_SELL,2),true,falliti);
   ABTG_AutotestCaso("tetto 1 sul DOW mentre il DAX e' pieno -> il DOW passa",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(misto,"DOW",ABTG_LATO_SELL,1),false,falliti);

   // il caso del 31/08 riprodotto: 5 sedie diverse, stesso simbolo, stesso lato
   ABTG_EspoRiga pileup[];
   ABTG_TestEspo(pileup,"DOW",(int)POSITION_TYPE_BUY,770201);
   ABTG_TestEspo(pileup,"DOW",(int)POSITION_TYPE_BUY,770202);
   ABTG_TestEspo(pileup,"DOW",(int)POSITION_TYPE_BUY,770203);
   ABTG_TestEspo(pileup,"DOW",(int)ORDER_TYPE_BUY_STOP,770204);
   ABTG_TestEspo(pileup,"DOW",(int)ORDER_TYPE_BUY_STOP,770205);
   ABTG_AutotestCasoInt("pile-up del 31/08: 5 sedie long sul Dow -> 5 teste viste",
                        ABTG_ContaSimboloLato_Calc(pileup,"DOW",ABTG_LATO_BUY),5,falliti);
   ABTG_AutotestCaso("pile-up del 31/08 con tetto 2 -> la TERZA sedia veniva fermata",
                     ABTG_TettoSimboloLatoRaggiunto_Calc(pileup,"DOW",ABTG_LATO_BUY,2),true,falliti);

   //--- D) IL MOTIVO NEL GIORNALE, E CHE NON COLLIDA ----------------
   ABTG_AutotestCaso("motivo 6 = tetto simbolo+lato (testo dedicato)",
                     (StringFind(ABTG_MotivoTesto(6),"TETTO SIMBOLO+LATO")>=0),true,falliti);
   ABTG_AutotestCaso("motivo 6 si dichiara P0",
                     (StringFind(ABTG_MotivoTesto(6),"(P0)")>=0),true,falliti);
   ABTG_AutotestCaso("motivo 6 NON contiene la frase del collaudo C9 (blocchi orfani)",
                     (StringFind(ABTG_MotivoTesto(6),"INGRESSO BLOCCATO")>=0),false,falliti);
   ABTG_AutotestCaso("motivo 6 e' DISTINTO dal motivo 1 (pausa B1)",
                     (ABTG_MotivoTesto(6)==ABTG_MotivoTesto(1)),false,falliti);
   ABTG_AutotestCaso("motivo 6 e' DISTINTO dal motivo 2 (cap C1)",
                     (ABTG_MotivoTesto(6)==ABTG_MotivoTesto(2)),false,falliti);
   ABTG_AutotestCaso("i motivi 1-5 non sono stati spostati (motivo 5 e' ancora S1)",
                     (StringFind(ABTG_MotivoTesto(5),"OBIETTIVO")>=0),true,falliti);

   return(falliti);
  }

int ABTG_AutotestGuardia()
  {
   int falliti=0;
   datetime ORA=(datetime)1000000;        // "adesso" finto, comodo per i conti
   int TOL=120;                           // tolleranza battito dei test

   PrintFormat("[AUTOTEST] ABTG_PausaGuardian v1.50 -- nucleo puro, ora finta=%I64d tolleranza=%d s",
               (long)ORA,TOL);

   //--- PAUSA (B1) -------------------------------------------------
   ABTG_AutotestCaso("pausa mai accesa (0,0) -> libero",
                     ABTG_PausaAttiva_Calc(0,0,ORA),false,falliti);
   ABTG_AutotestCaso("pausa accesa, scadenza NEL FUTURO -> bloccato",
                     ABTG_PausaAttiva_Calc((double)(ORA-60),(double)(ORA+3600),ORA),true,falliti);
   ABTG_AutotestCaso("pausa accesa, scadenza GIA' PASSATA -> libero",
                     ABTG_PausaAttiva_Calc((double)(ORA-7200),(double)(ORA-60),ORA),false,falliti);
   ABTG_AutotestCaso("pausa accesa 1h fa, scadenza MANCANTE -> bloccato (ripiego 24h)",
                     ABTG_PausaAttiva_Calc((double)(ORA-3600),0,ORA),true,falliti);
   ABTG_AutotestCaso("pausa accesa 25h fa, scadenza MANCANTE -> libero (ripiego scaduto)",
                     ABTG_PausaAttiva_Calc((double)(ORA-25*3600),0,ORA),false,falliti);

   //--- CAP (C1) ---------------------------------------------------
   ABTG_AutotestCaso("cap non scritto (0) -> libero",
                     ABTG_CapAttivo_Calc(0,ORA,TOL),false,falliti);
   ABTG_AutotestCaso("cap timbrato 1 s fa (battito fresco) -> bloccato",
                     ABTG_CapAttivo_Calc((double)(ORA-1),ORA,TOL),true,falliti);
   ABTG_AutotestCaso("cap timbrato 119 s fa (al limite dentro) -> bloccato",
                     ABTG_CapAttivo_Calc((double)(ORA-119),ORA,TOL),true,falliti);
   ABTG_AutotestCaso("cap timbrato 300 s fa (Guardian morto) -> libero, FAIL-OPEN",
                     ABTG_CapAttivo_Calc((double)(ORA-300),ORA,TOL),false,falliti);

   //--- BATTITO ----------------------------------------------------
   ABTG_AutotestCaso("battito assente (0) -> Guardian NON vivo",
                     ABTG_GuardianVivo_Calc(0,ORA,TOL),false,falliti);
   ABTG_AutotestCaso("battito di 2 s fa -> Guardian vivo",
                     ABTG_GuardianVivo_Calc((double)(ORA-2),ORA,TOL),true,falliti);
   ABTG_AutotestCaso("battito di 600 s fa -> Guardian NON vivo",
                     ABTG_GuardianVivo_Calc((double)(ORA-600),ORA,TOL),false,falliti);

   //--- DECISIONE COMPLETA (i tre motivi, e la loro precedenza) -----
   ABTG_AutotestCaso("tutto tranquillo -> si apre",
                     ABTG_MotivoStop_Calc(0,0,0,(double)(ORA-1),ORA,TOL,false)==0,true,falliti);
   ABTG_AutotestCaso("solo pausa -> motivo 1",
                     ABTG_MotivoStop_Calc((double)(ORA-60),(double)(ORA+3600),0,(double)(ORA-1),ORA,TOL,false)==1,true,falliti);
   ABTG_AutotestCaso("solo cap -> motivo 2",
                     ABTG_MotivoStop_Calc(0,0,(double)(ORA-1),(double)(ORA-1),ORA,TOL,false)==2,true,falliti);
   ABTG_AutotestCaso("pausa E cap insieme -> vince la pausa (motivo 1)",
                     ABTG_MotivoStop_Calc((double)(ORA-60),(double)(ORA+3600),(double)(ORA-1),(double)(ORA-1),ORA,TOL,false)==1,true,falliti);
   ABTG_AutotestCaso("Guardian morto e NON lo pretendo -> si apre (fail-open)",
                     ABTG_MotivoStop_Calc(0,0,0,0,ORA,TOL,false)==0,true,falliti);
   ABTG_AutotestCaso("Guardian morto e LO pretendo -> motivo 3",
                     ABTG_MotivoStop_Calc(0,0,0,0,ORA,TOL,true)==3,true,falliti);
   ABTG_AutotestCaso("Guardian morto CON cap vecchio -> si apre lo stesso (fail-open)",
                     ABTG_MotivoStop_Calc(0,0,(double)(ORA-300),(double)(ORA-300),ORA,TOL,false)==0,true,falliti);

   //--- FRENO P1 (v1.30): l'autotest nuovo gira dentro quello vecchio, cosi'
   //    gli EA che gia' chiamano ABTG_AutotestGuardia() lo ereditano senza
   //    essere toccati.
   falliti+=ABTG_AutotestPerditeConsecutive();

   //--- STOP S1 (v1.40): stessa scelta del P1 -- l'autotest nuovo gira
   //    dentro quello vecchio, cosi' ogni EA che gia' chiama
   //    ABTG_AutotestGuardia() eredita i casi nuovi senza essere toccato.
   //    Conteggio dei casi: 19 (B1/C1/battito/decisione) + 26 (P1) + 30 (S1)
   //    + 39 (P0, v1.50) = 114.
   falliti+=ABTG_AutotestObiettivo();

   //--- TETTO P0 (v1.50): stessa scelta di P1 e S1 -- l'autotest nuovo gira
   //    dentro quello vecchio, cosi' ogni EA che gia' chiama
   //    ABTG_AutotestGuardia() eredita i casi nuovi senza essere toccato.
   falliti+=ABTG_AutotestTettoSimboloLato();

   if(falliti==0) Print("[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.");
   else           PrintFormat("[AUTOTEST] ABTG_PausaGuardian: %d CASI FALLITI -- NON mettere in campo.",falliti);
   return(falliti);
  }

#endif // ABTG_PAUSAGUARDIAN_MQH
//+------------------------------------------------------------------+
