//+------------------------------------------------------------------+
//|                                        ABTG_GapContinuation.mq5  |
//|                                                                  |
//|  EA ADOTTATO - MT5 - TUTTO-IN-UNO                                |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)       |
//|                                                                  |
//|  =========== ATTRIBUZIONE (regola sez.9 del cacciatore) ========  |
//|                                                                  |
//|  OPERA ORIGINALE   "Nikkei 225 Gap Continuation EA"              |
//|  AUTORE            Francesc Jordi Mallol Nolden                  |
//|                    (#property copyright, riga 6 del sorgente)    |
//|  VERSIONE          1.50                                          |
//|  PUBBLICATO        24/07/2026 10:56 - MQL5 Code Base             |
//|  PAGINA            https://www.mql5.com/en/code/75301            |
//|  SORGENTE          https://www.mql5.com/en/code/download/75301/  |
//|                    Nikkei225_Gap_Continuation_EA.mq5             |
//|  SCARICATO         16/08/2026 - HTTP 200, 43.393 byte,           |
//|                    1.160 righe, 31 input veri + 8 `input group`  |
//|                                                                  |
//|  LICENZA           !! NON DICHIARATA, ne' sulla pagina ne' nel    |
//|                    sorgente: l'header generato portava ancora    |
//|                    "Copyright 2020, CompanyName". Valgono i      |
//|                    termini generali del Code Base MQL5, che NON  |
//|                    sono stati verificati.                        |
//|                    -> USO INTERNO DI RICERCA. Prima di           |
//|                       QUALUNQUE distribuzione: verificare.       |
//|                                                                  |
//|  =========== COSA ABBIAMO CAMBIATO, E NIENT'ALTRO =============   |
//|                                                                  |
//|  Il dossier CACCIA_2026-08-16_C_NIKKEI_GAP.md la chiama          |
//|  "ADOZIONE MINIMA": il sorgente e' completo, pulito e gia' nella |
//|  nostra grammatica. LA LOGICA DI TRADING NON E' STATA TOCCATA.   |
//|                                                                  |
//|   1. AGGIUNTO il blocco OPTFRAME in fondo al file (OnTester /    |
//|      OnTesterInit / OnTesterDeinit + ExportTrades + PrintFunnel).|
//|      Senza `double OnTester(` il driver walkforward_generico.ps1 |
//|      (righe 143-147) RIFIUTA di partire: "NON esporta i          |
//|      risultati (manca OnTester)".                                |
//|   2. AGGIUNTA la macchineria di `gWorstDayPct` (peggior giornata |
//|      in % rispetto all'apertura del giorno), che alimenta la     |
//|      colonna prop del CSV. E' sola lettura dell'equity: NON      |
//|      interviene su nessun trade.                                 |
//|   3. AGGIUNTI i contatori del FUNNEL (variabili `cnt*`), pura    |
//|      strumentazione: contano DOVE muore la giornata, non         |
//|      cambiano nessuna decisione. Rispondono in UNA riga alla     |
//|      domanda zero del dossier ("quanti eventi esistono           |
//|      davvero?") e al sospetto n.1 ("e' il filtro spread che si   |
//|      mangia i trade?") senza dover accendere la diagnostica      |
//|      giornaliera su 54 celle.                                    |
//|   4. MAGIC: da 2250101 (dell'autore) a 774101, magic VERGINE     |
//|      nostro (verificato: non collide con nessuno dei 69 EA).     |
//|   5. AGGIUNTO l'input `InpComment` (default "GAPCONT") per       |
//|      riconoscere gli ordini anche da cellulare. E' un input      |
//|      NUOVO in coda: non rinomina e non sostituisce niente.       |
//|   6. `#include <Trade\Trade.mqh>` -> `<Trade/Trade.mqh>`, la     |
//|      forma usata dagli altri 49 EA del repo. E' la libreria      |
//|      STANDARD di MetaEditor, non una nostra dipendenza: l'EA     |
//|      resta tutto-in-uno e compila con F7 da solo.                |
//|                                                                  |
//|  !! I NOMI DEGLI INPUT ORIGINALI NON SONO STATI TOCCATI.         |
//|     Il file prova backtest_pipeline/prove/ABTG_GapContinuation   |
//|     .txt li elenca copiati uno per uno dal sorgente: se anche    |
//|     UNO venisse rinominato, quella riga punterebbe nel vuoto e   |
//|     MT5 la ignorerebbe IN SILENZIO (trappola di prove/LEGGIMI).  |
//|                                                                  |
//|  ** IL FUSO: il codice NON e' stato toccato. Si usa il modo      |
//|     MANUALE che l'EA gia' possiede (InpSessionTimeMode =         |
//|     SESSION_MANUAL_SERVER = 1), che prende gli orari COSI' COME  |
//|     SONO SCRITTI, in ora server (SessionTimeForDate, ~riga 172:  |
//|     in modo manuale ritorna TimeOnSameDate senza conversioni).   |
//|     Il file prova pinna 01:00 -> 07:30 ora server BCM, cioe' la  |
//|     seduta cash di Tokyo 09:00-15:30 JST.                        |
//|     !! Vale finche' il server BCM sta a UTC+1. Se d'inverno      |
//|        scala a UTC+0 l'apertura vera diventa 00:00: e' una       |
//|        MISURA APERTA del progetto (CODA sez.6), da chiudere      |
//|        PRIMA di leggere i numeri. In quel caso la patch e' in    |
//|        DarwinexServerUtcOffset (~riga 163): due costanti.        |
//|                                                                  |
//|  ** L'ASIMMETRIA long/short (InpReduceRiskOnSmallSellGap) e'     |
//|     RIMASTA NEL CODICE ed e' spenta DAL FILE PROVA. Non va       |
//|     rimossa: l'input deve continuare a esistere, altrimenti la   |
//|     riga del file prova punta nel vuoto.                         |
//|                                                                  |
//|  ** IL SIZING NON SI TOCCA: l'autore usa OrderCalcProfit         |
//|     (CalculateEntryVolume, ~riga 584) col commento "Avoids       |
//|     incorrect tick-value scaling on JPY-denominated CFDs".       |
//|     E' ESATTAMENTE la correzione del bug che ci ha ucciso il     |
//|     round 2 sul Nikkei (SYMBOL_TRADE_TICK_VALUE nudo, in yen,    |
//|     ~160x troppo grande -> lotto appoggiato al minimo).          |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Originale: Francesc Jordi Mallol Nolden - MQL5 Code Base 75301"
#property link      "https://www.mql5.com/en/code/75301"
#property version   "1.50"
#property description "ABTG_GapContinuation - adozione di 'Nikkei 225 Gap Continuation EA'"
#property description "v1.50 di Francesc Jordi Mallol Nolden (mql5.com/en/code/75301)."
#property description "Logica di trading INVARIATA; aggiunti OnTester/export e magic nostro."
#property strict

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

CTrade Trade;

enum ENUM_SESSION_TIME_MODE
  {
   SESSION_JST_DARWINEX_AUTO=0,
   SESSION_MANUAL_SERVER=1
  };

input group "Cash session"
input ENUM_SESSION_TIME_MODE InpSessionTimeMode = SESSION_JST_DARWINEX_AUTO; // Session time mode
input int      InpSessionOpenHour          = 9;      // Session open hour
input int      InpSessionOpenMinute        = 0;      // Session open minute
input int      InpSessionCloseHour         = 15;     // Session close hour
input int      InpSessionCloseMinute       = 30;     // Session close minute
input int      InpOpeningRangeMinutes      = 10;     // Opening range duration in minutes (5-15)
input int      InpMaxEntryMinutesFromOpen  = 90;     // Maximum entry time after session open (minutes)
input int      InpExitMinutesBeforeClose   = 5;      // Forced exit before session close (minutes)

input group "BUY - bullish gaps"
input bool     InpEnableBuyGaps            = true;   // Enable BUY trades on bullish gaps
input double   InpMinimumBuyGapPercent     = 1.0;    // Minimum bullish gap (%)

input group "SELL - bearish gaps"
input bool     InpEnableSellGaps           = true;   // Enable SELL trades on bearish gaps
input double   InpMinimumSellGapPercent    = 1.0;    // Minimum bearish gap (%)

input group "Common signal filters"
input bool     InpUseRealVolumeIfAvailable = true;   // Use real volume when available
input double   InpMaxSpreadPoints          = 0.0;    // Maximum spread in points (0 = disabled)
input double   InpMaxSpreadToStopPercent   = 10.0;   // Maximum spread as % of stop (0 = disabled)
input double   InpStopBufferPoints         = 0.0;    // Stop-loss buffer in points

input group "BUY risk"
input double   InpBuyRiskPercent           = 0.50;   // BUY risk per trade (% of equity)

input group "SELL risk"
input double   InpSellRiskPercent          = 0.50;   // Full SELL risk per trade (% of equity)
input bool     InpReduceRiskOnSmallSellGap = true;   // Reduce risk on smaller SELL gaps
input double   InpSellFullRiskFromGapPct   = 1.25;   // Gap required for full SELL risk (%)
input double   InpSmallSellRiskPercent     = 0.25;   // Reduced SELL risk (% of equity)

input group "Volume and exits"
input double   InpFixedLots                = 0.0;    // Fixed lot size (0 = risk-based sizing)
input double   InpMaxLots                  = 0.0;    // Maximum lot size (0 = broker limit)
input double   InpPartialClosePercent      = 40.0;   // Partial close size (%)
input double   InpPartialTargetR           = 1.0;    // Partial close target (R multiple)
input double   InpFinalTargetR             = 2.0;    // Final take-profit target (R multiple)
input bool     InpMoveStopToBreakEven      = true;   // Move stop to break-even after partial close

input group "Execution"
//--- MAGIC NOSTRO VERGINE. L'autore usava 2250101; 774101 e' stato
//    verificato contro i 69 EA del repo e non collide con nessuno.
//    Serve perche' FindOurPosition() distingue le NOSTRE posizioni: due
//    EA con lo stesso magic si gestirebbero i trade a vicenda.
input ulong    InpMagicNumber              = 774101;  // Expert Advisor magic number
input ulong    InpMaxSlippagePoints        = 30;      // Maximum slippage in points
input bool     InpShowStatusOnChart        = true;    // Show status panel on chart
input bool     InpPrintDailyDiagnostics    = true;    // Print daily diagnostic messages
//--- INPUT NUOVO (non rinomina niente): il commento che finisce
//    sull'ordine. Regola di progetto: un trade va riconosciuto anche
//    dall'app del cellulare, dove si vede il commento e non il magic.
input string   InpComment                  = "GAPCONT"; // commento ordini

// Daily state
int      g_day_key          = -1;
datetime g_session_open     = 0;
datetime g_session_close    = 0;
datetime g_range_end        = 0;
datetime g_entry_deadline   = 0;
datetime g_force_exit       = 0;

double   g_previous_close   = 0.0;
double   g_session_open_px  = 0.0;
double   g_gap_percent      = 0.0;
double   g_half_gap_level   = 0.0;
double   g_range_high       = 0.0;
double   g_range_low        = 0.0;
double   g_vwap             = 0.0;

bool     g_setup_ready      = false;
bool     g_cancelled        = false;
bool     g_traded_today     = false;
string   g_status           = "Initializing";

// Position state; also stored in terminal global variables.
double   g_initial_risk     = 0.0;
double   g_initial_volume   = 0.0;
bool     g_partial_done     = false;
double   g_last_loss_per_lot= 0.0;
double   g_last_raw_volume  = 0.0;

//==================================================================
//  AGGIUNTA NOSTRA - METRICHE DA PROP (schema di famiglia).
//  L'Equity DD dice se il CONTO sopravvive; una prop invece chiude
//  per il LIMITE GIORNALIERO, che e' un'altra cosa. Qui si segue
//  l'equity dentro la giornata e si tiene la caduta peggiore
//  rispetto all'apertura del giorno.
//  Sola lettura di ACCOUNT_EQUITY: non tocca nessuna decisione.
//==================================================================
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

//==================================================================
//  AGGIUNTA NOSTRA - FUNNEL DI MORTALITA' (solo contatori + Print).
//  PERCHE' ESISTE: il dossier pone due domande a cui una tabella di
//  profitti NON risponde.
//   1) la "domanda zero": quanti EVENTI esistono davvero? Se le celle
//      tornano vuote bisogna sapere se il gap non si e' mai
//      presentato (verdetto sul SIMBOLO) o se si e' presentato e
//      qualcosa lo ha fermato (verdetto sui FILTRI).
//   2) il "sospetto n.1": e' il filtro spread che si mangia i trade?
//      Su 225JPY BCM lo spread e' ~80 punti e InpMaxSpreadToStopPercent
//      =10 pretende uno stop di almeno 800 punti.
//  Senza questi contatori la diagnosi costerebbe una passata singola
//  con InpPrintDailyDiagnostics=1; con questi sta in una riga di log
//  per ogni cella, senza sporcare il CSV.
//  !! Sono SOLO incrementi: nessun contatore entra in una condizione.
//==================================================================
int cntGiorni        = 0;   // giornate di calendario viste (ResetDay)
int cntNoPrevClose   = 0;   // giorni senza chiusura di seduta precedente
int cntNoRange       = 0;   // giorni senza barre per il range di apertura
int cntLatoSpento    = 0;   // gap del lato disabilitato da input
int cntGapSotto      = 0;   // |gap| sotto la soglia -> giornata annullata
int cntSetupPronti   = 0;   // GIORNI CON EVENTO VALIDO  <- la domanda zero
int cntSetupLong     = 0;   //   di cui con gap positivo
int cntSetupShort    = 0;   //   di cui con gap negativo
int cntNoVwap        = 0;   // VWAP non calcolabile
int cntFill50        = 0;   // annullati: meta' gap gia' richiuso
int cntFinestraScad  = 0;   // annullati: nessuna rottura entro la finestra
int cntSpreadFisso   = 0;   // giorni in cui ha bloccato InpMaxSpreadPoints
int cntSpreadDin     = 0;   // giorni in cui ha bloccato la % sullo stop <- sospetto n.1
int cntVolZero       = 0;   // annullati: lotto minimo oltre il rischio
int cntInvioFallito  = 0;   // ordine rifiutato dal server
int cntIngressiLong  = 0;   // ingressi eseguiti long
int cntIngressiShort = 0;   // ingressi eseguiti short
//--- gestione: il parziale a 1R e' andato a segno, oppure il lotto era
//    indivisibile? Vedi il DIFETTO 3 del referto: quando il lotto sta
//    gia' al minimo del broker, l'originale segna il parziale come
//    "fatto" e NON porta mai lo stop a pareggio. Va SAPUTO, perche'
//    cambia il profilo di rischio rispetto alle nostre sedie DAX/Dow.
int cntParzialeFatto   = 0; // parziale 40% eseguito -> poi breakeven
int cntParzialeSaltato = 0; // 1R toccato ma lotto non divisibile: NO breakeven

//--- bandierine di giornata: i blocchi "in attesa" si ripetono a OGNI
//    tick, ma noi vogliamo contare GIORNI, non tick. Si alzano una
//    volta sola e ResetDay le riabbassa.
bool fNoPrevClose  = false;
bool fNoRange      = false;
bool fNoVwap       = false;
bool fSpreadFisso  = false;
bool fSpreadDin    = false;

//+------------------------------------------------------------------+
//| Date and state utilities                                         |
//+------------------------------------------------------------------+
int DateKey(const datetime value)
  {
   MqlDateTime parts;
   TimeToStruct(value,parts);
   return(parts.year*10000+parts.mon*100+parts.day);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime TimeOnSameDate(const datetime base,const int hour,const int minute)
  {
   MqlDateTime parts;
   TimeToStruct(base,parts);
   parts.hour=hour;
   parts.min=minute;
   parts.sec=0;
   return(StructToTime(parts));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int NthSundayOfMonth(const int year,const int month,const int occurrence)
  {
   MqlDateTime parts;
   ZeroMemory(parts);
   parts.year=year;
   parts.mon=month;
   parts.day=1;
   parts.hour=12;
   datetime first_day=StructToTime(parts);
   TimeToStruct(first_day,parts);

   int first_sunday=1+((7-parts.day_of_week)%7);
   return(first_sunday+(occurrence-1)*7);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsDarwinexUsSummerTime(const datetime server_date)
  {
// US rule in effect since 2007:
// second Sunday in March through the first Sunday in November.
// Japanese sessions run Monday through Friday, so the exact intraday
// time of the Sunday clock change does not need to be modeled.
   MqlDateTime parts;
   TimeToStruct(server_date,parts);

   if(parts.mon<3 || parts.mon>11)
      return(false);
   if(parts.mon>3 && parts.mon<11)
      return(true);

   int start_day=NthSundayOfMonth(parts.year,3,2);
   int end_day=NthSundayOfMonth(parts.year,11,1);
   if(parts.mon==3)
      return(parts.day>=start_day);
   return(parts.day<end_day);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int DarwinexServerUtcOffset(const datetime server_date)
  {
   return(IsDarwinexUsSummerTime(server_date) ? 3 : 2);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime SessionTimeForDate(const datetime base,const int session_hour,const int session_minute)
  {
   if(InpSessionTimeMode==SESSION_MANUAL_SERVER)
      return(TimeOnSameDate(base,session_hour,session_minute));

// Tokyo uses JST (UTC+9) year-round. Darwinex uses UTC+2/UTC+3.
   int server_offset=DarwinexServerUtcOffset(base);
   int total_minutes=session_hour*60+session_minute-9*60+server_offset*60;
   int day_shift=0;
   while(total_minutes<0)
     {
      total_minutes+=1440;
      day_shift--;
     }
   while(total_minutes>=1440)
     {
      total_minutes-=1440;
      day_shift++;
     }

   int server_hour=total_minutes/60;
   int server_minute=total_minutes%60;
   return(TimeOnSameDate(base,server_hour,server_minute)+day_shift*86400);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string SessionModeDescription(const datetime now)
  {
   if(InpSessionTimeMode==SESSION_MANUAL_SERVER)
      return("Manual: server time");
   return("JST->Darwinex automatic (GMT+"+
          IntegerToString(DarwinexServerUtcOffset(now))+")");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string StateKey(const string suffix)
  {
   string key="N225GAP."+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN))+"."+
              IntegerToString((long)InpMagicNumber)+"."+_Symbol;
   if(StringLen(key)>50)
      key=StringSubstr(key,0,50);
   return(key+"."+suffix);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SavePositionState(const int position_day)
  {
   GlobalVariableSet(StateKey("DAY"),(double)position_day);
   GlobalVariableSet(StateKey("RISK"),g_initial_risk);
   GlobalVariableSet(StateKey("VOL"),g_initial_volume);
   GlobalVariableSet(StateKey("PART"),g_partial_done ? 1.0 : 0.0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LoadPositionState(const ulong ticket)
  {
   if(ticket==0 || !PositionSelectByTicket(ticket))
      return;

   datetime position_time=(datetime)PositionGetInteger(POSITION_TIME);
   int position_day=DateKey(position_time);

   if(GlobalVariableCheck(StateKey("DAY")) &&
      (int)GlobalVariableGet(StateKey("DAY"))==position_day)
     {
      g_initial_risk=GlobalVariableGet(StateKey("RISK"));
      g_initial_volume=GlobalVariableGet(StateKey("VOL"));
      g_partial_done=(GlobalVariableGet(StateKey("PART"))>0.5);
      return;
     }

   double entry=PositionGetDouble(POSITION_PRICE_OPEN);
   double stop=PositionGetDouble(POSITION_SL);
   g_initial_risk=(stop>0.0 ? MathAbs(entry-stop) : 0.0);
   g_initial_volume=PositionGetDouble(POSITION_VOLUME);
   g_partial_done=false;
   SavePositionState(position_day);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ResetDay(const datetime now)
  {
   g_day_key=DateKey(now);
   g_session_open=SessionTimeForDate(now,InpSessionOpenHour,InpSessionOpenMinute);
   g_session_close=SessionTimeForDate(now,InpSessionCloseHour,InpSessionCloseMinute);
   g_range_end=g_session_open+InpOpeningRangeMinutes*60;
   g_entry_deadline=g_session_open+InpMaxEntryMinutesFromOpen*60;
   g_force_exit=g_session_close-InpExitMinutesBeforeClose*60;

   g_previous_close=0.0;
   g_session_open_px=0.0;
   g_gap_percent=0.0;
   g_half_gap_level=0.0;
   g_range_high=0.0;
   g_range_low=0.0;
   g_vwap=0.0;
   g_setup_ready=false;
   g_cancelled=false;
   g_traded_today=false;
   g_status="Waiting for session open";

   g_initial_risk=0.0;
   g_initial_volume=0.0;
   g_partial_done=false;
   g_last_loss_per_lot=0.0;
   g_last_raw_volume=0.0;

//--- AGGIUNTA NOSTRA (funnel): un giro di ResetDay = una giornata.
//    Le bandierine tornano gia' a false qui, cosi' i blocchi "in
//    attesa" contano UNA volta per giorno e non una per tick.
   cntGiorni++;
   fNoPrevClose=false;
   fNoRange=false;
   fNoVwap=false;
   fSpreadFisso=false;
   fSpreadDin=false;
  }

//+------------------------------------------------------------------+
//| Position and history access                                      |
//+------------------------------------------------------------------+
ulong FindOurPosition()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(ticket==0)
         continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol &&
         (ulong)PositionGetInteger(POSITION_MAGIC)==InpMagicNumber)
         return(ticket);
     }
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| CORREZIONE 16/08 - PRIMA guardava QUALUNQUE posizione sul         |
//| simbolo, di chiunque:                                            |
//|     if(ticket>0 && PositionGetString(POSITION_SYMBOL)==_Symbol)  |
//| Nel tester non si vede (gira un EA solo), ma in FORWARD su        |
//| 225JPY girano gia' ABTG_SupertrendReversal H2 (magic 770901, uno  |
//| swing che tiene le posizioni per GIORNI) e ABTG_GapFill H1        |
//| (772235): con la versione vecchia questo EA si sarebbe            |
//| AUTOZITTITO quasi sempre, e in forward il sintomo e' "non fa      |
//| niente" -- cioe' quello che si scambia per "la tesi non           |
//| funziona".                                                        |
//| Ora conta SOLO le proprie posizioni. La semantica voluta e'       |
//| "una posizione alla volta per QUESTO EA", che e' quella che       |
//| l'EA gia' applica altrove (FindOurPosition, HasEnteredToday).     |
//| ⚠️ NON cambia nessun numero di R65/R66: nel tester le uniche      |
//| posizioni sul simbolo erano gia' le sue.                          |
//+------------------------------------------------------------------+
bool HasAnyPositionOnSymbol()
  {
   for(int i=PositionsTotal()-1;i>=0;i--)
     {
      ulong ticket=PositionGetTicket(i);
      if(ticket==0)
         continue;
      if(PositionGetString(POSITION_SYMBOL)==_Symbol &&
         (ulong)PositionGetInteger(POSITION_MAGIC)==InpMagicNumber)
         return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool HasEnteredToday()
  {
   if(!HistorySelect(g_session_open,TimeCurrent()))
      return(false);

   int total=HistoryDealsTotal();
   for(int i=total-1;i>=0;i--)
     {
      ulong deal=HistoryDealGetTicket(i);
      if(deal==0)
         continue;
      if(HistoryDealGetString(deal,DEAL_SYMBOL)!=_Symbol)
         continue;
      if((ulong)HistoryDealGetInteger(deal,DEAL_MAGIC)!=InpMagicNumber)
         continue;

      ENUM_DEAL_ENTRY entry=(ENUM_DEAL_ENTRY)HistoryDealGetInteger(deal,DEAL_ENTRY);
      if(entry==DEAL_ENTRY_IN || entry==DEAL_ENTRY_INOUT)
         return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Session, range and VWAP data                                     |
//+------------------------------------------------------------------+
bool FindPreviousSessionClose(double &close_price)
  {
// Search up to seven calendar days back to cover weekends.
   for(int days_back=1;days_back<=7;days_back++)
     {
      datetime candidate=g_session_open-days_back*86400;
      datetime from=SessionTimeForDate(candidate,InpSessionOpenHour,InpSessionOpenMinute);
      datetime to=SessionTimeForDate(candidate,InpSessionCloseHour,InpSessionCloseMinute)-1;

      MqlRates rates[];
      int copied=CopyRates(_Symbol,PERIOD_M1,from,to,rates);
      if(copied>0)
        {
         close_price=rates[copied-1].close;
         return(close_price>0.0);
        }
     }
   return(false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LoadOpeningRange()
  {
   MqlRates rates[];
   int copied=CopyRates(_Symbol,PERIOD_M1,g_session_open,g_range_end-1,rates);
   if(copied<=0)
      return(false);

   g_session_open_px=rates[0].open;
   g_range_high=rates[0].high;
   g_range_low=rates[0].low;

   for(int i=1;i<copied;i++)
     {
      g_range_high=MathMax(g_range_high,rates[i].high);
      g_range_low=MathMin(g_range_low,rates[i].low);
     }
   return(g_session_open_px>0.0 && g_range_high>g_range_low);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CalculateSessionMetrics(const datetime now,double &vwap,double &session_high,double &session_low)
  {
   MqlRates rates[];
   int copied=CopyRates(_Symbol,PERIOD_M1,g_session_open,now,rates);
   if(copied<=0)
      return(false);

   double weighted_sum=0.0;
   double volume_sum=0.0;
   session_high=rates[0].high;
   session_low=rates[0].low;

   for(int i=0;i<copied;i++)
     {
      double typical=(rates[i].high+rates[i].low+rates[i].close)/3.0;
      double volume=0.0;
      if(InpUseRealVolumeIfAvailable && rates[i].real_volume>0)
         volume=(double)rates[i].real_volume;
      else
         volume=(double)rates[i].tick_volume;
      if(volume<=0.0)
         volume=1.0;

      weighted_sum+=typical*volume;
      volume_sum+=volume;
      session_high=MathMax(session_high,rates[i].high);
      session_low=MathMin(session_low,rates[i].low);
     }

   if(volume_sum<=0.0)
      return(false);
   vwap=weighted_sum/volume_sum;
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool PrepareSetup()
  {
   if(g_setup_ready || g_cancelled)
      return(g_setup_ready);

   if(!FindPreviousSessionClose(g_previous_close))
     {
      if(!fNoPrevClose){ fNoPrevClose=true; cntNoPrevClose++; }   // funnel
      g_status="Previous session close data unavailable";
      return(false);
     }

   if(!LoadOpeningRange())
     {
      if(!fNoRange){ fNoRange=true; cntNoRange++; }               // funnel
      g_status="Waiting for opening range bars";
      return(false);
     }

   g_gap_percent=(g_session_open_px/g_previous_close-1.0)*100.0;

   if(g_gap_percent>0.0 && !InpEnableBuyGaps)
     {
      g_cancelled=true;
      cntLatoSpento++;                                            // funnel
      g_status="Cancelled: BUY gaps disabled";
      return(false);
     }
   if(g_gap_percent<0.0 && !InpEnableSellGaps)
     {
      g_cancelled=true;
      cntLatoSpento++;                                            // funnel
      g_status="Cancelled: SELL gaps disabled";
      return(false);
     }

   double minimum_gap=(g_gap_percent>0.0 ?
                       InpMinimumBuyGapPercent :
                       InpMinimumSellGapPercent);
   if(MathAbs(g_gap_percent)<minimum_gap)
     {
      g_cancelled=true;
      cntGapSotto++;                                              // funnel
      g_status=(g_gap_percent>0.0 ?
                "Cancelled: BUY gap below minimum" :
                "Cancelled: SELL gap below minimum");
      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | SKIPPED %s gap=%.2f%% (< %.2f%%) | previous close=%.2f open=%.2f",
                     TimeToString(g_session_open,TIME_DATE),
                     (g_gap_percent>0.0 ? "BUY" : "SELL"),g_gap_percent,
                     minimum_gap,g_previous_close,g_session_open_px);
      return(false);
     }

   g_half_gap_level=g_previous_close+0.5*(g_session_open_px-g_previous_close);
   g_setup_ready=true;
//--- funnel: QUESTO e' il conteggio degli EVENTI, cioe' la "domanda
//    zero" del dossier. Sotto i 15 di famiglia il round non da' un
//    verdetto sulla TESI, ma sul SIMBOLO.
   cntSetupPronti++;
   if(g_gap_percent>0.0) cntSetupLong++; else cntSetupShort++;
   g_status="Setup active: waiting for breakout and VWAP";
   if(InpPrintDailyDiagnostics)
      PrintFormat("DIAG %s | SETUP gap=%.2f%% | previous=%.2f open=%.2f range=%.2f-%.2f half_gap=%.2f",
                  TimeToString(g_session_open,TIME_DATE),g_gap_percent,g_previous_close,
                  g_session_open_px,g_range_low,g_range_high,g_half_gap_level);
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool UpdateSetupMetrics(const datetime now)
  {
   double session_high=0.0;
   double session_low=0.0;
   if(!CalculateSessionMetrics(now,g_vwap,session_high,session_low))
     {
      if(!fNoVwap){ fNoVwap=true; cntNoVwap++; }                   // funnel
      g_status="Unable to calculate VWAP";
      return(false);
     }

// Once more than 50% of the gap is filled, cancellation is permanent for the day.
   if(g_gap_percent>0.0 && session_low<=g_half_gap_level)
     {
      g_cancelled=true;
      g_setup_ready=false;
      cntFill50++;                                                // funnel
      g_status="Cancelled: bullish gap filled by more than 50%";
      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | CANCELLED 50%% bullish gap fill | low=%.2f level=%.2f",
                     TimeToString(g_session_open,TIME_DATE),session_low,g_half_gap_level);
      return(false);
     }
   if(g_gap_percent<0.0 && session_high>=g_half_gap_level)
     {
      g_cancelled=true;
      g_setup_ready=false;
      cntFill50++;                                                // funnel
      g_status="Cancelled: bearish gap filled by more than 50%";
      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | CANCELLED 50%% bearish gap fill | high=%.2f level=%.2f",
                     TimeToString(g_session_open,TIME_DATE),session_high,g_half_gap_level);
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Volume and execution validation                                  |
//+------------------------------------------------------------------+
int VolumeDigits()
  {
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   int digits=0;
   while(step<1.0 && digits<8)
     {
      step*=10.0;
      digits++;
     }
   return(digits);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NormalizeVolumeDown(double volume)
  {
   double minimum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double maximum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double step=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   if(step<=0.0 || minimum<=0.0)
      return(0.0);

   volume=MathMin(volume,maximum);
   volume=MathFloor((volume+1e-12)/step)*step;
   volume=NormalizeDouble(volume,VolumeDigits());
   if(volume<minimum)
      return(0.0);
   return(volume);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CalculateEntryVolume(const double entry,const double stop,const double risk_percent)
  {
   if(InpFixedLots>0.0)
      return(NormalizeVolumeDown(InpFixedLots));

   if(risk_percent<=0.0)
      return(0.0);

   double distance=MathAbs(entry-stop);
   if(distance<=0.0)
      return(0.0);

   double risk_money=AccountInfoDouble(ACCOUNT_EQUITY)*risk_percent/100.0;
   ENUM_ORDER_TYPE order_type=(entry>stop ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   double calculated_profit=0.0;
   double loss_per_lot=0.0;

// Returns the loss already converted to the account currency.
// Avoids incorrect tick-value scaling on JPY-denominated CFDs.
   ResetLastError();
   if(OrderCalcProfit(order_type,_Symbol,1.0,entry,stop,calculated_profit))
      loss_per_lot=MathAbs(calculated_profit);

// Fallback if the server does not allow OrderCalcProfit at that moment.
   if(loss_per_lot<=0.0)
     {
      double tick_size=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      double tick_value=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE_LOSS);
      if(tick_value<=0.0)
         tick_value=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      if(tick_size<=0.0 || tick_value<=0.0)
         return(0.0);
      loss_per_lot=(distance/tick_size)*tick_value;
     }

   if(loss_per_lot<=0.0)
      return(0.0);

   g_last_loss_per_lot=loss_per_lot;
   g_last_raw_volume=risk_money/loss_per_lot;
   if(InpMaxLots>0.0)
      g_last_raw_volume=MathMin(g_last_raw_volume,InpMaxLots);
   return(NormalizeVolumeDown(g_last_raw_volume));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double CurrentSellRiskPercent()
  {
   if(!InpReduceRiskOnSmallSellGap)
      return(InpSellRiskPercent);

   if(MathAbs(g_gap_percent)<InpSellFullRiskFromGapPct)
      return(InpSmallSellRiskPercent);

   return(InpSellRiskPercent);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TradeResultSucceeded()
  {
   uint code=Trade.ResultRetcode();
   return(code==TRADE_RETCODE_DONE ||
          code==TRADE_RETCODE_DONE_PARTIAL ||
          code==TRADE_RETCODE_PLACED ||
          code==TRADE_RETCODE_NO_CHANGES);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ReportTradeFailure(const string action)
  {
   Print(action," failed. Retcode=",Trade.ResultRetcode(),
         " (",Trade.ResultRetcodeDescription(),")");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SpreadIsAcceptable(const MqlTick &tick)
  {
   if(InpMaxSpreadPoints<=0.0)
      return(true);
   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   if(point<=0.0)
      return(false);
   return((tick.ask-tick.bid)/point<=InpMaxSpreadPoints);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool DynamicSpreadIsAcceptable(const MqlTick &tick,
                               const double stop_distance,
                               double &spread_percent)
  {
   spread_percent=0.0;
   if(InpMaxSpreadToStopPercent<=0.0)
      return(true);

   double spread=tick.ask-tick.bid;
   if(spread<0.0 || stop_distance<=0.0)
     {
      spread_percent=DBL_MAX;
      return(false);
     }

   spread_percent=100.0*spread/stop_distance;
   return(spread_percent<=InpMaxSpreadToStopPercent);
  }

//+------------------------------------------------------------------+
//| Entry                                                            |
//+------------------------------------------------------------------+
void StoreNewPositionState(const ulong ticket)
  {
   if(ticket==0 || !PositionSelectByTicket(ticket))
      return;

   double entry=PositionGetDouble(POSITION_PRICE_OPEN);
   double stop=PositionGetDouble(POSITION_SL);
   g_initial_risk=MathAbs(entry-stop);
   g_initial_volume=PositionGetDouble(POSITION_VOLUME);
   g_partial_done=false;
   SavePositionState(DateKey((datetime)PositionGetInteger(POSITION_TIME)));

   ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   int digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   double current_target=PositionGetDouble(POSITION_TP);
   double final_target=(type==POSITION_TYPE_BUY ?
                        entry+InpFinalTargetR*g_initial_risk :
                        entry-InpFinalTargetR*g_initial_risk);
   final_target=NormalizeDouble(final_target,digits);

// Avoid modifying a newly opened order when the TP already matches.
// Some servers reject this redundant modification due to the freeze level.
   double tick_size=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   if(current_target>0.0 && MathAbs(current_target-final_target)<=tick_size)
      return;

   if(!Trade.PositionModify(ticket,stop,final_target) || !TradeResultSucceeded())
      ReportTradeFailure("Final target adjustment");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TryEntry(const datetime now)
  {
   if(now>g_entry_deadline)
     {
      g_cancelled=true;
      g_setup_ready=false;
      cntFinestraScad++;                                          // funnel
      g_status="Cancelled: entry window expired";
      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | CANCELLED no valid breakout before %s",
                     TimeToString(g_session_open,TIME_DATE),
                     TimeToString(g_entry_deadline,TIME_MINUTES));
      return;
     }

   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick) || tick.ask<=0.0 || tick.bid<=0.0)
      return;

   if(!SpreadIsAcceptable(tick))
     {
      if(!fSpreadFisso){ fSpreadFisso=true; cntSpreadFisso++; }    // funnel
      g_status="Waiting: spread too wide";
      return;
     }

   double point=SymbolInfoDouble(_Symbol,SYMBOL_POINT);
   int digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   double broker_stop_distance=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*point;
   double buffer=InpStopBufferPoints*point;

   if(g_gap_percent>0.0)
     {
      if(!(tick.bid>g_range_high && tick.bid>g_vwap))
        {
         g_status="Bullish gap: waiting for breakout above range and VWAP";
         return;
        }

      double stop=MathMin(g_range_low-buffer,tick.bid-broker_stop_distance);
      stop=NormalizeDouble(stop,digits);
      double risk=tick.ask-stop;
      if(risk<=0.0)
         return;
      double spread_percent=0.0;
      if(!DynamicSpreadIsAcceptable(tick,risk,spread_percent))
        {
         if(!fSpreadDin){ fSpreadDin=true; cntSpreadDin++; }        // funnel
         g_status=StringFormat("Waiting: spread %.1f%% of stop (max %.1f%%)",
                               spread_percent,InpMaxSpreadToStopPercent);
         return;
        }
      double target=NormalizeDouble(tick.ask+InpFinalTargetR*risk,digits);
      double applied_risk_percent=InpBuyRiskPercent;
      double volume=CalculateEntryVolume(tick.ask,stop,applied_risk_percent);
      if(volume<=0.0)
        {
         g_cancelled=true;
         g_setup_ready=false;
         cntVolZero++;                                              // funnel
         g_status="Cancelled: minimum volume exceeds allowed risk";
         if(InpPrintDailyDiagnostics)
            PrintFormat("DIAG %s | CANCELLED volume | entry=%.2f stop=%.2f loss_per_lot=%.2f raw_volume=%.4f minimum=%.2f",
                        TimeToString(g_session_open,TIME_DATE),tick.ask,stop,
                        g_last_loss_per_lot,g_last_raw_volume,
                        SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
         return;
        }

      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | LONG ENTRY | entry=%.2f stop=%.2f volume=%.2f risk=%.2f%% loss_per_lot=%.2f spread_to_stop=%.2f%%",
                     TimeToString(g_session_open,TIME_DATE),tick.ask,stop,volume,
                     applied_risk_percent,g_last_loss_per_lot,spread_percent);

      //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
      if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_GapContinuation")) return;
      bool sent=Trade.Buy(volume,_Symbol,0.0,stop,target,InpComment+" L");
      if(!sent || !TradeResultSucceeded())
        {
         cntInvioFallito++;                                         // funnel
         ReportTradeFailure("Long entry");
         g_status="Failed to execute long entry";
         return;
        }
     }
   else
     {
      if(!(tick.ask<g_range_low && tick.ask<g_vwap))
        {
         g_status="Bearish gap: waiting for breakout below range and VWAP";
         return;
        }

      double stop=MathMax(g_range_high+buffer,tick.ask+broker_stop_distance);
      stop=NormalizeDouble(stop,digits);
      double risk=stop-tick.bid;
      if(risk<=0.0)
         return;
      double spread_percent=0.0;
      if(!DynamicSpreadIsAcceptable(tick,risk,spread_percent))
        {
         if(!fSpreadDin){ fSpreadDin=true; cntSpreadDin++; }        // funnel
         g_status=StringFormat("Waiting: spread %.1f%% of stop (max %.1f%%)",
                               spread_percent,InpMaxSpreadToStopPercent);
         return;
        }
      double target=NormalizeDouble(tick.bid-InpFinalTargetR*risk,digits);
      double applied_risk_percent=CurrentSellRiskPercent();
      double volume=CalculateEntryVolume(tick.bid,stop,applied_risk_percent);
      if(volume<=0.0)
        {
         g_cancelled=true;
         g_setup_ready=false;
         cntVolZero++;                                              // funnel
         g_status="Cancelled: minimum volume exceeds allowed risk";
         if(InpPrintDailyDiagnostics)
            PrintFormat("DIAG %s | CANCELLED volume | entry=%.2f stop=%.2f loss_per_lot=%.2f raw_volume=%.4f minimum=%.2f",
                        TimeToString(g_session_open,TIME_DATE),tick.bid,stop,
                        g_last_loss_per_lot,g_last_raw_volume,
                        SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
         return;
        }

      if(InpPrintDailyDiagnostics)
         PrintFormat("DIAG %s | SHORT ENTRY | entry=%.2f stop=%.2f volume=%.2f risk=%.2f%% gap=%.2f%% loss_per_lot=%.2f spread_to_stop=%.2f%%",
                     TimeToString(g_session_open,TIME_DATE),tick.bid,stop,volume,
                     applied_risk_percent,MathAbs(g_gap_percent),
                     g_last_loss_per_lot,spread_percent);

      //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
      if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_GapContinuation")) return;
      bool sent=Trade.Sell(volume,_Symbol,0.0,stop,target,InpComment+" S");
      if(!sent || !TradeResultSucceeded())
        {
         cntInvioFallito++;                                         // funnel
         ReportTradeFailure("Short entry");
         g_status="Failed to execute short entry";
         return;
        }
     }

   ulong ticket=FindOurPosition();
   if(ticket>0)
     {
      StoreNewPositionState(ticket);
      g_traded_today=true;
      //--- funnel: il lato lo decide IL SEGNO DEL GAP, non un indicatore.
      //    Long e short vanno letti SEPARATAMENTE (criterio 2 del file
      //    prova): se regge solo il long, il buco degli short resta.
      if(g_gap_percent>0.0) cntIngressiLong++; else cntIngressiShort++;
      g_status="Position open";
     }
  }

//+------------------------------------------------------------------+
//| Position management                                              |
//+------------------------------------------------------------------+
double PartialCloseVolume(const double current_volume)
  {
   double minimum=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double desired=NormalizeVolumeDown(current_volume*InpPartialClosePercent/100.0);
   double maximum_close=NormalizeVolumeDown(current_volume-minimum);
   if(desired<=0.0 || maximum_close<=0.0)
      return(0.0);
   return(MathMin(desired,maximum_close));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ClosePartial(const ulong ticket,const double volume)
  {
   if(!PositionSelectByTicket(ticket))
      return(false);

   ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   ENUM_ACCOUNT_MARGIN_MODE mode=(ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
   bool sent=false;

   if(mode==ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
      sent=Trade.PositionClosePartial(ticket,volume,InpMaxSlippagePoints);
   else
     {
      // In netting mode, an opposite trade reduces the position volume.
      if(type==POSITION_TYPE_BUY)
         sent=Trade.Sell(volume,_Symbol,0.0,0.0,0.0,InpComment+" PARZ");
      else
         sent=Trade.Buy(volume,_Symbol,0.0,0.0,0.0,InpComment+" PARZ");
     }

   if(!sent || !TradeResultSucceeded())
     {
      ReportTradeFailure("Partial close");
      return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MoveStopToBreakEven()
  {
   ulong ticket=FindOurPosition();
   if(ticket==0 || !PositionSelectByTicket(ticket))
      return;

   double entry=PositionGetDouble(POSITION_PRICE_OPEN);
   double target=PositionGetDouble(POSITION_TP);
   int digits=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   entry=NormalizeDouble(entry,digits);

   if(!Trade.PositionModify(ticket,entry,target) || !TradeResultSucceeded())
      ReportTradeFailure("Move stop to break-even");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAtSessionEnd(const ulong ticket)
  {
   if(!Trade.PositionClose(ticket,InpMaxSlippagePoints) || !TradeResultSucceeded())
     {
      ReportTradeFailure("End-of-session close");
      g_status="Unable to close at the end of the session";
      return;
     }
   g_status="Position closed at the end of the session";
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ManagePosition(const ulong ticket,const datetime now)
  {
   if(!PositionSelectByTicket(ticket))
      return;

// Also closes a residual position when reconnecting outside the session.
   if(now<g_session_open || now>=g_force_exit)
     {
      CloseAtSessionEnd(ticket);
      return;
     }

   if(g_initial_risk<=0.0)
      LoadPositionState(ticket);
   if(g_initial_risk<=0.0)
     {
      g_status="Position open, but initial risk could not be restored";
      return;
     }

   ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   double entry=PositionGetDouble(POSITION_PRICE_OPEN);
   double current_volume=PositionGetDouble(POSITION_VOLUME);

   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick))
      return;

   double partial_target=(type==POSITION_TYPE_BUY ?
                          entry+InpPartialTargetR*g_initial_risk :
                          entry-InpPartialTargetR*g_initial_risk);
   bool target_hit=(type==POSITION_TYPE_BUY ? tick.bid>=partial_target : tick.ask<=partial_target);

   if(!g_partial_done && target_hit)
     {
      double close_volume=PartialCloseVolume(current_volume);
      if(close_volume<=0.0)
        {
         // The lot is too small to split. Avoid repeated attempts.
         cntParzialeSaltato++;                                      // funnel
         g_partial_done=true;
         SavePositionState(g_day_key);
         g_status="1R reached; insufficient volume for partial close";
         return;
        }

      if(ClosePartial(ticket,close_volume))
        {
         cntParzialeFatto++;                                        // funnel
         g_partial_done=true;
         SavePositionState(g_day_key);
         g_status="Partial close executed at 1R";
         if(InpMoveStopToBreakEven)
            MoveStopToBreakEven();
        }
     }
   else
      g_status=(g_partial_done ? "Managing remaining volume until target/close" :
                "Position open: waiting for 1R");
  }

//+------------------------------------------------------------------+
//| Information panel                                                |
//+------------------------------------------------------------------+
void UpdateChartStatus(const datetime now)
  {
   if(!InpShowStatusOnChart)
      return;

   string gap_text=(g_session_open_px>0.0 ? DoubleToString(g_gap_percent,2)+"%" : "n/a");
   string vwap_text=(g_vwap>0.0 ? DoubleToString(g_vwap,_Digits) : "n/a");
   string range_text=(g_range_high>0.0 ?
                      DoubleToString(g_range_low,_Digits)+" - "+DoubleToString(g_range_high,_Digits) : "n/a");

   Comment("Nikkei 225 - Gap Continuation EA\n",
           "Server time: ",TimeToString(now,TIME_DATE|TIME_SECONDS),"\n",
           "Schedule: ",SessionModeDescription(now),"\n",
           "Effective session: ",TimeToString(g_session_open,TIME_MINUTES)," - ",
           TimeToString(g_session_close,TIME_MINUTES),"\n",
           "Gap: ",gap_text," | VWAP: ",vwap_text,"\n",
           "Opening range: ",range_text,"\n",
           "Status: ",g_status);
  }

//+------------------------------------------------------------------+
//| Events                                                           |
//+------------------------------------------------------------------+
int OnInit()
  {
   int open_minutes=InpSessionOpenHour*60+InpSessionOpenMinute;
   int close_minutes=InpSessionCloseHour*60+InpSessionCloseMinute;

   if(InpSessionOpenHour<0 || InpSessionOpenHour>23 ||
      InpSessionCloseHour<0 || InpSessionCloseHour>23 ||
      InpSessionOpenMinute<0 || InpSessionOpenMinute>59 ||
      InpSessionCloseMinute<0 || InpSessionCloseMinute>59 ||
      close_minutes<=open_minutes)
     {
      Print("Invalid session parameters.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpOpeningRangeMinutes<5 || InpOpeningRangeMinutes>15 ||
      InpMaxEntryMinutesFromOpen<InpOpeningRangeMinutes ||
      InpExitMinutesBeforeClose<0 ||
      InpExitMinutesBeforeClose>=close_minutes-open_minutes)
     {
      Print("Invalid opening range, entry window or session exit parameters.");
      return(INIT_PARAMETERS_INCORRECT);
     }
   if(InpMinimumBuyGapPercent<=0.0 || InpMinimumSellGapPercent<=0.0 ||
      InpBuyRiskPercent<=0.0 || InpSellRiskPercent<=0.0 ||
      (InpReduceRiskOnSmallSellGap &&
       (InpSmallSellRiskPercent<=0.0 ||
        InpSmallSellRiskPercent>InpSellRiskPercent ||
        InpSellFullRiskFromGapPct<InpMinimumSellGapPercent)) ||
      InpFixedLots<0.0 ||
      InpMaxLots<0.0 ||
      InpMaxSpreadPoints<0.0 || InpMaxSpreadToStopPercent<0.0 ||
      InpStopBufferPoints<0.0 ||
      InpPartialClosePercent<=0.0 || InpPartialClosePercent>=100.0 ||
      InpPartialTargetR<=0.0 || InpFinalTargetR<=InpPartialTargetR)
     {
      Print("Invalid signal/risk parameters.");
      return(INIT_PARAMETERS_INCORRECT);
     }

   if(!SymbolSelect(_Symbol,true))
     {
      Print("Unable to select symbol ",_Symbol);
      return(INIT_FAILED);
     }

   Trade.SetExpertMagicNumber(InpMagicNumber);
   Trade.SetDeviationInPoints(InpMaxSlippagePoints);
   Trade.SetTypeFillingBySymbol(_Symbol);
   Trade.SetAsyncMode(false);

   datetime now=TimeCurrent();
   ResetDay(now);
   ulong ticket=FindOurPosition();
   if(ticket>0)
      LoadPositionState(ticket);

   Print("Nikkei225 Gap Continuation EA started on ",_Symbol,
         ". Time mode: ",SessionModeDescription(now),
         ". Effective server session: ",TimeToString(g_session_open,TIME_MINUTES),
         "-",TimeToString(g_session_close,TIME_MINUTES));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(InpShowStatusOnChart)
      Comment("");
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- AGGIUNTA NOSTRA (metrica da prop): quanto sono sceso OGGI rispetto
//    all'apertura del giorno. Sta QUI, in cima e prima di ogni return,
//    perche' la caduta peggiore di giornata succede DENTRO la seduta e
//    OnTick esce presto in un sacco di rami (fuori sessione, gia'
//    tradato, posizione aperta...). Non tocca nessuna decisione.
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

   datetime now=TimeCurrent();
   if(now<=0)
      return;

   if(DateKey(now)!=g_day_key)
      ResetDay(now);

   ulong our_position=FindOurPosition();
   if(our_position>0)
     {
      ManagePosition(our_position,now);
      UpdateChartStatus(now);
      return;
     }

   if(now<g_session_open)
     {
      g_status="Waiting for session open";
      UpdateChartStatus(now);
      return;
     }
   if(now>=g_force_exit)
     {
      g_status="Session finished";
      UpdateChartStatus(now);
      return;
     }

   if(g_traded_today || HasEnteredToday())
     {
      g_traded_today=true;
      g_status="Daily trade already completed";
      UpdateChartStatus(now);
      return;
     }

   if(HasAnyPositionOnSymbol())
     {
      g_status="Blocked: another position exists on the symbol";
      UpdateChartStatus(now);
      return;
     }

   if(now<g_range_end)
     {
      g_status="Building opening range";
      UpdateChartStatus(now);
      return;
     }

   if(!PrepareSetup())
     {
      UpdateChartStatus(now);
      return;
     }

   if(!UpdateSetupMetrics(now))
     {
      UpdateChartStatus(now);
      return;
     }

   TryEntry(now);
   UpdateChartStatus(now);
  }
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.      //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:   //
//      python optimizer/batch_analyze.py <cartella>                //
//  In live/backtest singolo e' inerte (gira solo in ottimizzazione)//
//                                                                  //
//  !! BLOCCO AGGIUNTO DA NOI: NON esiste nell'originale di          //
//     Francesc Jordi Mallol Nolden. Senza `double OnTester(` il    //
//     driver walkforward_generico.ps1 (righe 143-147) si ferma     //
//     prima di partire: "NON esporta i risultati (manca            //
//     OnTester)". LEGGIMI.md: 22 EA su 61 bocciati esattamente qui.//
//     Copiato dal modello di casa ABTG_BreakingBand.mq5 e adattato //
//     ai nomi di questo EA (InpMagic -> InpMagicNumber) e al suo   //
//     funnel.                                                      //
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//------------------------------------------------------------------
//  Export per-trade: serve alla misura del DD COMBINATO chiesta da
//  ROTTA_PROP.md punto 2. Su 225JPY non e' un di piu': il simbolo e'
//  gia' occupato da ABTG_SupertrendReversal, e la scorrelazione fra
//  i due NON si dichiara, si misura trade per trade.
//------------------------------------------------------------------
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagicNumber)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit");
   int n=HistoryDealsTotal();
   for(int i=0;i<n;i++)
     {
      ulong tk=HistoryDealGetTicket(i);
      if(tk==0) continue;
      long entry=HistoryDealGetInteger(tk,DEAL_ENTRY);
      if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_OUT_BY) continue;
      double net=HistoryDealGetDouble(tk,DEAL_PROFIT)+HistoryDealGetDouble(tk,DEAL_SWAP)+HistoryDealGetDouble(tk,DEAL_COMMISSION);
      FileWrite(h,
                TimeToString((datetime)HistoryDealGetInteger(tk,DEAL_TIME),TIME_DATE|TIME_MINUTES|TIME_SECONDS),
                HistoryDealGetString(tk,DEAL_SYMBOL),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_MAGIC)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_POSITION_ID)),
                IntegerToString(HistoryDealGetInteger(tk,DEAL_TYPE)),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_VOLUME),2),
                DoubleToString(HistoryDealGetDouble(tk,DEAL_PRICE),_Digits),
                DoubleToString(net,2));
     }
   FileClose(h);
  }

//==================================================================
//  FUNNEL DI MORTALITA' (solo Print a fine passata).
//  Dice DOVE muore la giornata: quante giornate sono state viste,
//  quante hanno prodotto un EVENTO vero (gap oltre soglia), e per
//  quale motivo le altre sono morte. Nessun impatto sul CSV (il CSV
//  nasce da FrameAdd/OnTesterDeinit).
//
//  COME SI LEGGE, nell'ordine in cui il dossier pone le domande:
//   1. "EVENTI VALIDI" e' la domanda zero. Sotto i 15 di famiglia il
//      round da' un verdetto sul SIMBOLO, non sulla TESI: la mossa
//      giusta e' portare la stessa tesi su DAX e Nasdaq, NON
//      abbassare la soglia per fare numero.
//   2. se EVENTI e' alto ma INGRESSI e' ~0, il colpevole sta nella
//      riga FILTRI: "spread%stop" e' il sospetto n.1 (su 225JPY BCM
//      lo spread e' ~80 punti e la soglia al 10% pretende uno stop
//      di almeno 800 punti). NON e' la tesi che ha fallito.
//   3. long e short si leggono SEPARATAMENTE: se regge solo il long,
//      il buco degli short NON e' stato riempito, anche col totale
//      verde (criterio 2 del file prova).
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[GAPCONT-FUNNEL] %s | modo=%s sessione=%02d:%02d-%02d:%02d server | range=%d' finestra=%d' | gapMin buy=%.2f%% sell=%.2f%% | finalR=%.2f",
               _Symbol,
               (InpSessionTimeMode==SESSION_MANUAL_SERVER ? "MANUALE(ora server)" : "AUTO(JST->Darwinex)"),
               InpSessionOpenHour,InpSessionOpenMinute,InpSessionCloseHour,InpSessionCloseMinute,
               InpOpeningRangeMinutes,InpMaxEntryMinutesFromOpen,
               InpMinimumBuyGapPercent,InpMinimumSellGapPercent,InpFinalTargetR);
   PrintFormat("[GAPCONT-FUNNEL] DATI     giornate viste=%d | morte prima del gap: senzaChiusuraPrecedente=%d senzaRangeApertura=%d senzaVWAP=%d",
               cntGiorni,cntNoPrevClose,cntNoRange,cntNoVwap);
   PrintFormat("[GAPCONT-FUNNEL] EVENTO   gapSottoSoglia=%d latoSpento=%d  ==> EVENTI VALIDI=%d (long=%d short=%d)   <-- DOMANDA ZERO",
               cntGapSotto,cntLatoSpento,cntSetupPronti,cntSetupLong,cntSetupShort);
   PrintFormat("[GAPCONT-FUNNEL] MORTE    meta'GapRichiuso=%d finestraScaduta%d'=%d",
               cntFill50,InpMaxEntryMinutesFromOpen,cntFinestraScad);
   PrintFormat("[GAPCONT-FUNNEL] FILTRI   spreadPunti=%d spread%%stop=%d (max %.1f%%)  <-- SOSPETTO N.1 se gli ingressi sono ~0",
               cntSpreadFisso,cntSpreadDin,InpMaxSpreadToStopPercent);
   PrintFormat("[GAPCONT-FUNNEL] GESTIONE parziale1R eseguito=%d | 1R toccato ma LOTTO INDIVISIBILE=%d (in quei trade NON c'e' stato il breakeven)",
               cntParzialeFatto,cntParzialeSaltato);
   PrintFormat("[GAPCONT-FUNNEL] ORDINI   lottoOltreRischio=%d invioFallito=%d  ==> INGRESSI=%d (long=%d short=%d) | trade chiusi dal tester=%d",
               cntVolZero,cntInvioFallito,
               cntIngressiLong+cntIngressiShort,cntIngressiLong,cntIngressiShort,
               (int)TesterStatistics(STAT_TRADES));
  }

double OnTester()
  {
   PrintFunnel();
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
   FrameFilter(OPTFRAME_NAME, OPTFRAME_ID);
   ulong pass; string name; long id; double value; double data[];
   bool header_scritto = false; int righe = 0;
   while(FrameNext(pass, name, id, value, data))
     {
      string params[]; uint pcount = 0;
      FrameInputs(pass, params, pcount);
      if(!header_scritto)
        {
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,Serie Perdente Peggiore";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f,%.4f,%.0f,%.2f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6],
                                data[7], data[8], data[9]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
