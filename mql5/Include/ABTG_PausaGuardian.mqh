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
//|  Restano disponibili i mattoni singoli, se servono per un pannello:|
//|     PausaGiornoAttiva() / CapRischioAttivo() / GuardianVivo()      |
//|     RischioApertoPct() / ABTG_PuoAprire()                          |
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
   return("nessuno");
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
//+------------------------------------------------------------------+
bool ABTG_GuardiaIngresso(const bool attiva,const string chi="EA",
                          const bool pretendi_guardian=false)
  {
   if(!attiva) return(true);                    // 1. l'utente l'ha spenta
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

int ABTG_AutotestGuardia()
  {
   int falliti=0;
   datetime ORA=(datetime)1000000;        // "adesso" finto, comodo per i conti
   int TOL=120;                           // tolleranza battito dei test

   PrintFormat("[AUTOTEST] ABTG_PausaGuardian v1.20 -- nucleo puro, ora finta=%I64d tolleranza=%d s",
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

   if(falliti==0) Print("[AUTOTEST] ABTG_PausaGuardian: TUTTI I CASI PASSATI.");
   else           PrintFormat("[AUTOTEST] ABTG_PausaGuardian: %d CASI FALLITI -- NON mettere in campo.",falliti);
   return(falliti);
  }

#endif // ABTG_PAUSAGUARDIAN_MQH
//+------------------------------------------------------------------+
