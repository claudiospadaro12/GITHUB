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
//|  Restano disponibili i mattoni singoli, se servono per un pannello:|
//|     PausaGiornoAttiva() / CapRischioAttivo() / GuardianVivo()      |
//|     RischioApertoPct() / ABTG_PuoAprire()                          |
//|     ABTG_PerditeConsecutiveOggi() / ABTG_TroppePerditeConsecutive()|
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
//+------------------------------------------------------------------+
bool ABTG_GuardiaIngresso(const bool attiva,const string chi="EA",
                          const bool pretendi_guardian=false,
                          const int soglia_perdite_consecutive=0,
                          const long magic=0)
  {
   if(!attiva) return(true);                    // 1. l'utente l'ha spenta

   // 1-bis. freno P1 (opt-in): a soglia 0 questa riga e' un no-op puro
   if(soglia_perdite_consecutive>0 &&
      ABTG_TroppePerditeConsecutive(magic,soglia_perdite_consecutive,chi))
      return(false);

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

int ABTG_AutotestGuardia()
  {
   int falliti=0;
   datetime ORA=(datetime)1000000;        // "adesso" finto, comodo per i conti
   int TOL=120;                           // tolleranza battito dei test

   PrintFormat("[AUTOTEST] ABTG_PausaGuardian v1.30 -- nucleo puro, ora finta=%I64d tolleranza=%d s",
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

   if(falliti==0) Print("[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.");
   else           PrintFormat("[AUTOTEST] ABTG_PausaGuardian: %d CASI FALLITI -- NON mettere in campo.",falliti);
   return(falliti);
  }

#endif // ABTG_PAUSAGUARDIAN_MQH
//+------------------------------------------------------------------+
