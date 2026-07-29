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
//|  Tutto-in-uno: compila con F7. Usa solo Trade.mqh (standard MT5). |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict
#include <Trade/Trade.mqh>

//--- SALDO / REGOLE PROP -------------------------------------------
input double InpStartBalance   = 0;      // Saldo iniziale challenge (0 = cattura in automatico al primo avvio). Es. 109000
input double InpDailyLossPct   = 5.0;    // Limite PERDITA GIORNALIERA (% del saldo iniziale)
input double InpTotalDDPct     = 10.0;   // Limite DRAWDOWN TOTALE (% del saldo iniziale)
input int    InpDDMode         = 0;      // DD totale: 0=STATICO (dal saldo iniziale) · 1=TRAILING (dal picco equity)
input int    InpDailyResetHour = 0;      // Ora SERVER in cui azzera il contatore giornaliero (0=mezzanotte broker)
//--- COMPORTAMENTO -------------------------------------------------
input int    InpAction         = 0;      // 0=CHIUDI+BLOCCA (enforce) · 1=SOLO ALLARME (monitor, non chiude)
input bool   InpCloseAllMagics = true;   // true=chiude posizioni/pendenti di QUALSIASI magic (tutto il conto)
input bool   InpShowPanel      = true;   // mostra pannello di stato sul grafico
input long   InpMagic          = 779001; // magic del guardiano (per i suoi log)
input string InpComment        = "GUARDIAN"; // commento
input bool   InpVerbose        = true;   // log dettagliato nel giornale

//--- nomi GlobalVariable (persistono nel terminale) ----------------
string GV_START, GV_PEAK, GV_DAYKEY, GV_DAYSTART, GV_BLOCKDAY, GV_FAILED;

CTrade gTrade;
double gStart=0, gPeak=0;
datetime gLastLog=0;

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
int OnInit()
  {
   long acc=AccountInfoInteger(ACCOUNT_LOGIN);
   GV_START   =StringFormat("ABTG_GUARD_%I64d_START",acc);
   GV_PEAK    =StringFormat("ABTG_GUARD_%I64d_PEAK",acc);
   GV_DAYKEY  =StringFormat("ABTG_GUARD_%I64d_DAYKEY",acc);
   GV_DAYSTART=StringFormat("ABTG_GUARD_%I64d_DAYSTART",acc);
   GV_BLOCKDAY=StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",acc);
   GV_FAILED  =StringFormat("ABTG_GUARD_%I64d_FAILED",acc);

   double bal=AccountInfoDouble(ACCOUNT_BALANCE);
   double eq =AccountInfoDouble(ACCOUNT_EQUITY);

   // saldo iniziale: input se >0, altrimenti cattura una volta e persisti
   if(InpStartBalance>0) gStart=InpStartBalance;
   else                  gStart=(GlobalVariableCheck(GV_START)? GlobalVariableGet(GV_START) : bal);
   GlobalVariableSet(GV_START,gStart);

   gPeak=(GlobalVariableCheck(GV_PEAK)? GlobalVariableGet(GV_PEAK) : MathMax(eq,gStart));
   if(eq>gPeak) gPeak=eq;
   GlobalVariableSet(GV_PEAK,gPeak);

   // baseline del giorno
   int pk=PropDayKey();
   if(!GlobalVariableCheck(GV_DAYKEY) || (int)GlobalVariableGet(GV_DAYKEY)!=pk)
     {
      GlobalVariableSet(GV_DAYKEY,pk);
      GlobalVariableSet(GV_DAYSTART,bal);      // baseline giornaliera = saldo a inizio giornata
      GlobalVariableSet(GV_BLOCKDAY,0);
     }

   gTrade.SetExpertMagicNumber(InpMagic);
   EventSetTimer(1);
   PrintFormat("[GUARDIAN] avviato. Saldo iniziale=%.2f  DailyLoss=%.1f%%  DD=%.1f%% (%s)  Azione=%s",
               gStart,InpDailyLossPct,InpTotalDDPct,(InpDDMode==1?"trailing":"statico"),
               (InpAction==1?"SOLO ALLARME":"CHIUDI+BLOCCA"));
   OnTimer();
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
void OnDeinit(const int reason){ EventKillTimer(); Comment(""); }

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

   // reset giornaliero se e' cambiato il "giorno prop"
   int pk=PropDayKey();
   if((int)GlobalVariableGet(GV_DAYKEY)!=pk)
     {
      GlobalVariableSet(GV_DAYKEY,pk);
      GlobalVariableSet(GV_DAYSTART,bal);
      GlobalVariableSet(GV_BLOCKDAY,0);
      if(InpVerbose) PrintFormat("[GUARDIAN] nuovo giorno prop: baseline=%.2f",bal);
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

   if(InpShowPanel)
     {
      string st= failed ? "CHALLENGE FALLITA (DD totale)" :
                 (((int)GlobalVariableGet(GV_BLOCKDAY)==pk)? "BLOCCATO PER OGGI (daily)" : "OK - operativo");
      string panel=StringFormat(
        "=== ABTG GUARDIAN ===\nStato: %s\nSaldo iniziale: %.2f\nEquity: %.2f   Balance: %.2f\n"
        "--- GIORNO ---\nInizio giorno: %.2f\nPerdita oggi: %.2f  (%.2f%% / limite %.1f%%)\n"
        "--- TOTALE (%s) ---\nPicco equity: %.2f\nDrawdown: %.2f  (%.2f%% / limite %.1f%%)\nAzione: %s",
        st,gStart,eq,bal,dayStart,dailyLoss,dailyPct,InpDailyLossPct,
        (InpDDMode==1?"trailing":"statico"),gPeak,totalDD,totalPct,InpTotalDDPct,
        (InpAction==1?"SOLO ALLARME":"CHIUDI+BLOCCA"));
      Comment(panel);
     }

   // log periodico (ogni 5 min) per lo storico
   if(InpVerbose && TimeCurrent()-gLastLog>=300)
     {
      gLastLog=TimeCurrent();
      PrintFormat("[GUARDIAN] eq=%.2f  dayLoss=%.2f%%  totDD=%.2f%%  stato=%s",
                  eq,dailyPct,totalPct,(failed?"FAILED":(((int)GlobalVariableGet(GV_BLOCKDAY)==pk)?"BLOCKED":"OK")));
     }
  }
//+------------------------------------------------------------------+
