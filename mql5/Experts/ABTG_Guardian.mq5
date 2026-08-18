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
#property version   "1.10"
#property strict
#include <Trade/Trade.mqh>

//--- SALDO / REGOLE PROP -------------------------------------------
input double InpStartBalance   = 0;      // Saldo iniziale challenge (0 = cattura in automatico al primo avvio). Es. 109000
input double InpDailyLossPct   = 5.0;    // Limite PERDITA GIORNALIERA (% del saldo iniziale)
input double InpTotalDDPct     = 10.0;   // Limite DRAWDOWN TOTALE (% del saldo iniziale)
input int    InpDDMode         = 0;      // DD totale: 0=STATICO (dal saldo iniziale) . 1=TRAILING (dal picco equity)
input int    InpDailyResetHour = 0;      // Ora SERVER in cui azzera il contatore giornaliero (0=mezzanotte broker)
//--- PAUSA MORBIDA E CAP RISCHIO (firme 18/08/2026) -----------------
//  Questi due NON chiudono e NON bloccano niente da soli: scrivono
//  GlobalVariable che gli EA leggono prima di aprire. Finche' nessun
//  EA e' migrato all'include, il comportamento del conto NON cambia.
input double InpDailyPausePct  = 4.0;    // PAUSA MORBIDA: perdita giornaliera % che blocca i NUOVI ingressi (0=spenta)
input double InpMaxOpenRiskPct = 3.25;   // CAP C1: rischio aperto simultaneo massimo, % equity (0=spento). 3.25 = 5 SL vivi da 0,65%
input int    InpRiskMode       = 0;      // Rischio aperto: 0=dall'INGRESSO (come la misura M2) . 1=dal PREZZO CORRENTE (perdita residua)
input bool   InpWarnNoSL       = true;   // logga un warning per le posizioni SENZA stop loss (rischio ignoto, non bloccante)
//--- COMPORTAMENTO -------------------------------------------------
input int    InpAction         = 0;      // 0=CHIUDI+BLOCCA (enforce) . 1=SOLO ALLARME (monitor, non chiude)
input bool   InpCloseAllMagics = true;   // true=chiude posizioni/pendenti di QUALSIASI magic (tutto il conto)
input bool   InpShowPanel      = true;   // mostra pannello di stato sul grafico
input long   InpMagic          = 779001; // magic del guardiano (per i suoi log)
input string InpComment        = "GUARDIAN"; // commento
input bool   InpVerbose        = true;   // log dettagliato nel giornale

//--- nomi GlobalVariable (persistono nel terminale) ----------------
string GV_START, GV_PEAK, GV_DAYKEY, GV_DAYSTART, GV_BLOCKDAY, GV_FAILED;
//--- canale verso gli EA (leggerli con Include/ABTG_PausaGuardian.mqh)
//    ATTENZIONE: se cambi questi nomi, cambiali ANCHE nell'include.
string GV_PAUSA, GV_PAUSAFINO, GV_CAP, GV_RISKPCT, GV_BATTITO;

CTrade gTrade;
double gStart=0, gPeak=0;
datetime gLastLog=0, gLastWarnNoSL=0;

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
int OnInit()
  {
   long acc=AccountInfoInteger(ACCOUNT_LOGIN);
   GV_START   =StringFormat("ABTG_GUARD_%I64d_START",acc);
   GV_PEAK    =StringFormat("ABTG_GUARD_%I64d_PEAK",acc);
   GV_DAYKEY  =StringFormat("ABTG_GUARD_%I64d_DAYKEY",acc);
   GV_DAYSTART=StringFormat("ABTG_GUARD_%I64d_DAYSTART",acc);
   GV_BLOCKDAY=StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",acc);
   GV_FAILED  =StringFormat("ABTG_GUARD_%I64d_FAILED",acc);
   // canale verso gli EA -- gli STESSI nomi stanno in ABTG_PausaGuardian.mqh
   GV_PAUSA    =StringFormat("ABTG_PAUSA_GIORNO_%I64d",acc);
   GV_PAUSAFINO=StringFormat("ABTG_PAUSA_FINO_%I64d",acc);
   GV_CAP      =StringFormat("ABTG_CAP_RISCHIO_%I64d",acc);
   GV_RISKPCT  =StringFormat("ABTG_RISCHIO_APERTO_%I64d",acc);
   GV_BATTITO  =StringFormat("ABTG_GUARDIAN_BATTITO_%I64d",acc);

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
      GlobalVariableSet(GV_PAUSA,0);           // giorno nuovo = pausa morbida azzerata
      GlobalVariableSet(GV_PAUSAFINO,0);
     }
   if(!GlobalVariableCheck(GV_PAUSA))    GlobalVariableSet(GV_PAUSA,0);
   if(!GlobalVariableCheck(GV_PAUSAFINO))GlobalVariableSet(GV_PAUSAFINO,0);
   GlobalVariableSet(GV_CAP,0);          // il cap si ricalcola da zero a ogni avvio

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
      GlobalVariableSet(GV_DAYKEY,pk);
      GlobalVariableSet(GV_DAYSTART,bal);
      GlobalVariableSet(GV_BLOCKDAY,0);
      GlobalVariableSet(GV_PAUSA,0);        // la pausa morbida dura un giorno prop
      GlobalVariableSet(GV_PAUSAFINO,0);
      if(InpVerbose) PrintFormat("[GUARDIAN] nuovo giorno prop: baseline=%.2f (pausa morbida azzerata)",bal);
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
     }
  }
//+------------------------------------------------------------------+
