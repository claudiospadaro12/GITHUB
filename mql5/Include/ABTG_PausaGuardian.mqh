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
//|  USO tipico, una riga sola PRIMA di aprire:                        |
//|                                                                   |
//|     #include <ABTG_PausaGuardian.mqh>                              |
//|     ...                                                            |
//|     if(PausaGiornoAttiva()) return;   // niente nuovi ingressi     |
//|     if(CapRischioAttivo())  return;   // cap C1 sul rischio aperto |
//|                                                                    |
//|  oppure la scorciatoia:  if(!ABTG_PuoAprire()) return;             |
//|                                                                    |
//|  IMPORTANTE -- cosa NON fa:                                        |
//|   - non chiude niente e non tocca le posizioni gia' aperte:        |
//|     la gestione di una posizione viva resta all'EA;                |
//|   - blocca solo i NUOVI ingressi, se l'EA la chiama;               |
//|   - se il guardiano NON gira, tutto ritorna false (fail-open):     |
//|     un cane da guardia morto non deve fermare la flotta per        |
//|     sempre. Chi vuole il contrario usa GuardianVivo().             |
//|                                                                    |
//|  I nomi delle GlobalVariable devono restare IDENTICI a quelli in   |
//|  ABTG_Guardian.mq5 (blocco GV_PAUSA/GV_CAP/GV_BATTITO in OnInit).  |
//+------------------------------------------------------------------+
//  v1.00 -- 18/08/2026 (firme B1/C1). Nessun #property qui dentro:
//  sovrascriverebbe quelli dell'EA che include il file.
#ifndef ABTG_PAUSAGUARDIAN_MQH
#define ABTG_PAUSAGUARDIAN_MQH

//--- tolleranza di default sul battito del guardiano (secondi).
//    Il guardiano batte 1 volta al secondo: 120s = e' morto davvero,
//    non e' solo un terminale impegnato.
#define ABTG_BATTITO_TOLLERANZA 120

//+------------------------------------------------------------------+
//| Nomi delle GlobalVariable (per conto: il canale non si mischia    |
//| fra conti diversi aperti nello stesso terminale).                 |
//+------------------------------------------------------------------+
string ABTG_GVNome(const string radice)
  {
   return(StringFormat("%s_%I64d",radice,AccountInfoInteger(ACCOUNT_LOGIN)));
  }

//+------------------------------------------------------------------+
//| Lettura sicura: se la variabile non esiste ritorna 0.             |
//+------------------------------------------------------------------+
double ABTG_GVLeggi(const string radice)
  {
   string n=ABTG_GVNome(radice);
   if(!GlobalVariableCheck(n)) return(0.0);
   return(GlobalVariableGet(n));
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
   double ts=ABTG_GVLeggi("ABTG_PAUSA_GIORNO");
   if(ts<=0) return(false);                       // nessuna pausa scritta

   double fino=ABTG_GVLeggi("ABTG_PAUSA_FINO");
   if(fino>0)
      return(TimeCurrent()<(datetime)fino);       // pausa con scadenza dichiarata

   // scadenza mancante (guardiano vecchio o GV persa): ripiego prudente,
   // la pausa vale al massimo 24 ore dall'accensione
   return(TimeCurrent()-(datetime)ts < 24*3600);
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
   double ts=ABTG_GVLeggi("ABTG_CAP_RISCHIO");
   if(ts<=0) return(false);
   return(TimeCurrent()-(datetime)ts <= tolleranza_sec);
  }

//+------------------------------------------------------------------+
//| Il guardiano sta girando? (battito aggiornato di recente)         |
//| Serve a un EA che vuole essere PRUDENTE: "se il cane da guardia   |
//| non c'e', io non apro". E' una scelta dell'EA, non un default.    |
//+------------------------------------------------------------------+
bool GuardianVivo(const int tolleranza_sec=ABTG_BATTITO_TOLLERANZA)
  {
   double ts=ABTG_GVLeggi("ABTG_GUARDIAN_BATTITO");
   if(ts<=0) return(false);
   return(TimeCurrent()-(datetime)ts <= tolleranza_sec);
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
   if(PausaGiornoAttiva()) return(false);
   if(CapRischioAttivo())  return(false);
   if(pretendi_guardian && !GuardianVivo()) return(false);
   return(true);
  }

#endif // ABTG_PAUSAGUARDIAN_MQH
//+------------------------------------------------------------------+
