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
//|    ARANCIO  IN-BULGE meta' bulge      (decisa su barra 1)         |
//|    BLU      IN-BULGE 2a candela       (conferma su barra 0)       |
//|    VIOLA    POST-BULGE                (su barra 0)                |
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
//          3. Risk_Percent: default 1.00 (era 0.50 in BULGE_MASTER;
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
//
//  [DA DECIDERE] -- COSE VISTE LEGGENDO IL CODICE, **NON** CORRETTE.
//  La logica e' di Claudio: la modifica e' una sua decisione, non una
//  nostra. Sono scritte qui perche' chi legge un numero di R92 sappia
//  cosa c'era sotto.
//   (a) IL BLU E' CIECO SUL SIMBOLO DEL GRAFICO. [INFERITO dal codice,
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
#property version   "5.00"

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

// --- CACHE HANDLE INDICATORE (uno per simbolo) ---
int      g_hBands[];   // handle iBands per simbolo
int      g_hATR[];     // handle iATR per simbolo
int      g_hADX[];     // handle iADX per simbolo

// --- KILL SWITCH ---
bool     g_kill_active      = false; // EA fermo per il resto del giorno?
string   g_kill_reason      = "";    // Motivo dello stop
datetime g_kill_today_start = 0;     // Inizio giornata corrente (server time)

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
         " | Kill: ", kill_msg);

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

      // Solo alla nuova candela H1 (segnali su barra chiusa, no look-ahead)
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
bool PurpleReactionOk(bool isLong, double open0, double close0, double atr1)
{
   if(Use_Purple_PineReaction)
      return isLong ? (close0 > open0) : (close0 < open0);   // VIOLA-PINE
   return (MathAbs(close0 - open0) <= atr1 * 1.5);           // VIOLA-EA (default)
}

//==================================================================
// LOGICA PRINCIPALE -- tutti e 3 i segnali (INVARIATA)
// NB: identica a v3_PARALLEL_KILL. Cambia SOLO la sorgente dati
//     (handle in cache via GetBB/GetATR per symIdx).
//==================================================================
void CheckSignal(int symIdx)
{
   string sym = g_symbols[symIdx];
   int barsNeeded = Lookback_Bars * 2 + 10;

   double highs[], lows[], opens[], closes[];
   if(!GetBars(sym, barsNeeded, highs, lows, opens, closes)) return;

   if(!AtrOk(symIdx)) return;

   // ATR e BB sulla barra 1 (chiusa)
   double atr1 = GetATR(symIdx, 1);
   if(atr1 <= 0) return;

   double bbUpper1, bbLower1, bbBasis1;
   if(!GetBB(symIdx, 1, bbUpper1, bbLower1, bbBasis1)) return;

   // BB Width corrente e MA
   double bbWidth1  = bbUpper1 - bbLower1;
   double bbWidthMA = GetBBWidthMA(symIdx);
   if(bbWidthMA <= 0) return;
   bool isBulge1 = (bbWidth1 >= bbWidthMA * Bulge_Multi);

   // BB sulla barra 0 (corrente) per il TP iniziale
   double bbUpper0, bbLower0, bbBasis0;
   if(!GetBB(symIdx, 0, bbUpper0, bbLower0, bbBasis0)) return;

   // Pre-carica le serie ATR e BB per il loop impulso (un solo CopyBuffer)
   double atrSeries[];
   double bbUSeries[], bbLSeries[], bbBSeries[];
   if(!GetATRSeries(symIdx, 0, barsNeeded, atrSeries)) return;
   if(!GetBBSeries(symIdx, 0, barsNeeded, bbUSeries, bbLSeries, bbBSeries)) return;

   //----------------------------------------------------------------
   // TROVA ULTIMO IMPULSO
   //----------------------------------------------------------------
   int barsSinceImpDown = -1;
   int barsSinceImpUp   = -1;

   for(int k = 1; k < barsNeeded - 1; k++)
   {
      double atrK = atrSeries[k];
      double bbUK = bbUSeries[k], bbLK = bbLSeries[k];

      bool impDown = (lows[k]  <= bbLK && closes[k] < opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);
      bool impUp   = (highs[k] >= bbUK && closes[k] > opens[k] && MathAbs(closes[k]-opens[k]) >= atrK * 0.2);

      if(impDown && barsSinceImpDown < 0) barsSinceImpDown = k;
      if(impUp   && barsSinceImpUp   < 0) barsSinceImpUp   = k;
      if(barsSinceImpDown >= 0 && barsSinceImpUp >= 0) break;
   }

   //----------------------------------------------------------------
   // MEDIANA E BANDA OPPOSTA TOCCATE DOPO IMPULSO
   //----------------------------------------------------------------
   bool midAfterImpDown = false, midAfterImpUp = false;
   bool oppAfterImpDown = false, oppAfterImpUp = false;

   if(barsSinceImpDown > 0)
   {
      for(int k = 1; k < barsSinceImpDown; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpDown = true; }
         if(highs[k] >= bbUK)                     { oppAfterImpDown = true; }
      }
   }
   if(barsSinceImpUp > 0)
   {
      for(int k = 1; k < barsSinceImpUp; k++)
      {
         double bbUK = bbUSeries[k], bbLK = bbLSeries[k], bbBK = bbBSeries[k];
         if(highs[k] >= bbBK && lows[k] <= bbBK) { midAfterImpUp = true; }
         if(lows[k]  <= bbLK)                     { oppAfterImpUp = true; }
      }
   }

   //----------------------------------------------------------------
   // BANDA PIATTA (per POST-BULGE)
   //----------------------------------------------------------------
   bool lowerFlat = false, upperFlat = false;
   {
      double bbU6 = bbUSeries[7], bbL6 = bbLSeries[7];
      lowerFlat = MathAbs(bbLower1 - bbL6) <= atr1 * 0.6;
      upperFlat = MathAbs(bbUpper1 - bbU6) <= atr1 * 0.6;
   }

   //----------------------------------------------------------------
   // CANDELA DI REAZIONE SU BARRA 1
   //----------------------------------------------------------------
   bool bullReaction1 = (closes[1] > opens[1] && lows[1]  <= bbLower1);
   bool bearReaction1 = (closes[1] < opens[1] && highs[1] >= bbUpper1);

   //----------------------------------------------------------------
   // SEGNALE ORIGINALE SU BARRA 1 (base per arancio e blu)
   //----------------------------------------------------------------
   bool origLong1 = isBulge1 &&
        barsSinceImpDown >= 1 && barsSinceImpDown <= Lookback_Bars &&
        !midAfterImpDown && !oppAfterImpDown && bullReaction1;

   bool origShort1 = isBulge1 &&
        barsSinceImpUp >= 1 && barsSinceImpUp <= Lookback_Bars &&
        !midAfterImpUp && !oppAfterImpUp && bearReaction1;

   //----------------------------------------------------------------
   // ARANCIO -- META' BULGE (su barra 1)
   //----------------------------------------------------------------
   if(Use_Orange)
   {
      if(origLong1 && barsSinceImpDown > 0)
      {
         double impMid = (highs[barsSinceImpDown] + lows[barsSinceImpDown]) / 2.0;
         if(closes[1] >= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, true, atr1, bbBasis1, InpComment + "_ARANCIO_L");
      }
      if(origShort1 && barsSinceImpUp > 0)
      {
         double impMid = (highs[barsSinceImpUp] + lows[barsSinceImpUp]) / 2.0;
         if(closes[1] <= impMid && AdxFilterOk(symIdx, sym, "ARANCIO"))
            OpenOrder(sym, false, atr1, bbBasis1, InpComment + "_ARANCIO_S");
      }
   }

   //----------------------------------------------------------------
   // BLU -- 2A CANDELA (conferma su barra 0)
   //----------------------------------------------------------------
   if(Use_Blue)
   {
      bool confirmLong  = (closes[0] > opens[0] && !(lows[0]  <= bbLower0) && closes[0] > lows[1]);
      bool confirmShort = (closes[0] < opens[0] && !(highs[0] >= bbUpper0) && closes[0] < highs[1]);

      if(origLong1  && confirmLong  && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, true,  atr1, bbBasis0, InpComment + "_BLU_L");
      if(origShort1 && confirmShort && AdxFilterOk(symIdx, sym, "BLU"))
         OpenOrder(sym, false, atr1, bbBasis0, InpComment + "_BLU_S");
   }

   //----------------------------------------------------------------
   // VIOLA -- POST-BULGE (su barra 0)
   //----------------------------------------------------------------
   if(Use_Purple)
   {
      // v5.10: LE UNICHE RIGHE CAMBIATE DENTRO CheckSignal. Col default
      // valgono il vecchio candleNotImpulsive, identico per i due lati.
      bool reactionLong0  = PurpleReactionOk(true,  opens[0], closes[0], atr1);
      bool reactionShort0 = PurpleReactionOk(false, opens[0], closes[0], atr1);

      bool postBulgeLong =
           barsSinceImpDown >= 1 && barsSinceImpDown <= Lookback_Bars * 2 &&
           midAfterImpDown && !oppAfterImpDown &&
           lows[0] <= bbLower0 && lowerFlat &&
           reactionLong0;

      bool postBulgeShort =
           barsSinceImpUp >= 1 && barsSinceImpUp <= Lookback_Bars * 2 &&
           midAfterImpUp && !oppAfterImpUp &&
           highs[0] >= bbUpper0 && upperFlat &&
           reactionShort0;

      if(postBulgeLong  && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, true,  atr1, bbBasis0, InpComment + "_VIOLA_L");
      if(postBulgeShort && AdxFilterOk(symIdx, sym, "VIOLA"))
         OpenOrder(sym, false, atr1, bbBasis0, InpComment + "_VIOLA_S");
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

//--- per-trade: serve al DD di PORTAFOGLIO (ROTTA_PROP punto 4).
//    Con un basket la colonna 'symbol' non e' decorativa: dice su quale
//    cross e' finito ogni deal anche quando il grafico e' un altro.
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
   int h=FileOpen(fn,FILE_WRITE|FILE_CSV|FILE_ANSI|FILE_COMMON,';');
   if(h==INVALID_HANDLE) return;
   FileWrite(h,"close_time","symbol","magic","position_id","deal_type","volume","price","net_profit","comment");
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
                DoubleToString(net,2),
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
