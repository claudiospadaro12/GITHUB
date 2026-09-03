//+------------------------------------------------------------------+
//|                                      ABTG_ORB_Ottimizzato.mq5    |
//|                                                                  |
//|  LABORATORIO parallelo dell'ORB del corso (che resta INTATTO).  |
//|  Qui vivono fix e varianti misurabili; magic diverso, mai in     |
//|  sostituzione dell'originale (regola della flotta, 08/08/2026): |
//|   - fix InpOneTradePerDay (pendente opposto cancellato)          |
//|   - filtro EMA lunga opzionale (utenti ABTG: 200; scheda DAX: 50)|
//|   - SL 50%% del range (ORB_SL_HALFRANGE, utenti ABTG)             |
//|   - ampiezza minima range in %% del prezzo (scheda ORB DAX)       |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle)      |
//|                                                                  |
//|  Replica la logica dell'ORB_Indicator_V15:                      |
//|   - RANGE = candela 14:25-14:30 (server) = 15:25-15:30 IT       |
//|     (i 5 minuti prima dell'apertura USA)                        |
//|   - Ingresso a EntryPoints x K oltre max/min del range:         |
//|     BUY STOP sopra, SELL STOP sotto (OCO)                       |
//|   - K = coefficiente per strumento (indici/oro=1.0, 225JPY=10,  |
//|     cross JPY=0.01, altri forex=0.0001, oil=0.01)               |
//|   - SL sull'estremo opposto (o ATR/fisso); TP a R multiplo      |
//|     (webinar: min 1:2) + parziale + breakeven                  |
//|   - Runner: trailing / uscita su EMA9 (M5), come da webinar     |
//|   - Cancella/chiude a 22:59 server; 1 trade a sessione          |
//|                                                                  |
//|  ⚠️ Orari in ORA SERVER. Nessun EA garantisce profitti. DEMO.   |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|  CHANGELOG                                                       |
//|  v1.04 (03/09/2026) - LA CURA del difetto SelPos/HEDGING.        |
//|        Il dossier report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md    |
//|        ha CONFERMATO il meccanismo su tre giornate misurate      |
//|        (19/08, 21/08, 02/09) e con la FOTO A del 03/09           |
//|        (LARRY DOW S, magic 772341, aperta il 01/09 e viva per    |
//|        tutta la vita del trade ORB). Meccanismo, detto giusto:   |
//|        su conto HEDGING PositionSelect(_Symbol) seleziona la     |
//|        posizione col TICKET PIU' BASSO del simbolo -- NON "la    |
//|        piu' vecchia in orologio" (misurato in                    |
//|        report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md: il     |
//|        16,5% delle coppie ha l'ordine per ticket INVERTITO       |
//|        rispetto all'orologio, perche' una posizione nata da un   |
//|        pendente eredita il ticket di QUANDO il pendente e' stato |
//|        PIAZZATO). Se quel ticket e' di un'altra sedia, il        |
//|        controllo sul magic falliva e l'EA restava CIECO alla     |
//|        propria posizione: niente trailing, niente breakeven,     |
//|        niente OCO disarmato, niente OneTradePerDay, niente       |
//|        chiusura di fine giornata.                                |
//|        COSA CAMBIA QUI: ogni selezione passa da un nucleo puro   |
//|        che scorre PositionsTotal() filtrando SIMBOLO + MAGIC e   |
//|        restituisce il TICKET della NOSTRA posizione; ogni        |
//|        scrittura (PositionClose / PositionModify) usa quel       |
//|        TICKET e non piu' _Symbol. Lettura e scrittura corrette   |
//|        INSIEME, come impone                                      |
//|        report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md: farne  |
//|        una sola crea la categoria "arancione" (leggo la mia e    |
//|        chiudo quella del vicino), che e' PEGGIO del bug.         |
//|        I log diagnostici della v1.03 restano TUTTI. Il log n.4   |
//|        ("SelPos falso ma posizioni nostre esistenti") e' ora     |
//|        impossibile per costruzione ed e' sostituito dal log      |
//|        "ORB SELEZIONE:", che al primo trade con vicini stampa    |
//|        QUALE ticket nostro e' stato preso e quale avrebbe preso  |
//|        la v1.03: e' cosi' che il fix si VERIFICA in campo.       |
//|        Aggiunto un AUTOTEST a tavolino (10 blocchi, 33 casi) sul |
//|        nucleo puro della selezione: gira in OnInit, non tocca il |
//|        mercato.                                                  |
//|        NEL TESTER il comportamento deve restare IDENTICO al      |
//|        centesimo (l'EA e' solo sul simbolo: nessun vicino, il    |
//|        ticket piu' basso e' sempre il nostro). E' il test di     |
//|        NON-REGRESSIONE, non di merito.                            |
//|  v1.03 (02/09/2026, caccia ai GEMELLI CHE DIVERGONO) - SOLO      |
//|        STRUMENTAZIONE DIAGNOSTICA: nessun input nuovo, nessun    |
//|        cambio di logica di trading, nessuna riga di decisione    |
//|        toccata. Serve a rispondere alla domanda del dossier      |
//|        report/ORB_GEMELLI_DIVERGENZA_2026-08-22.md: perche' la   |
//|        stessa .ex5 traila lo stop sul 100k e NON lo muove mai,   |
//|        in silenzio totale, sul conto piccolo. Finora             |
//|        ManageRunner() non stampava NULLA: ne' quando muoveva lo  |
//|        stop, ne' quando usciva prima di muoverlo. Ora ogni ramo  |
//|        di uscita anticipata lascia una traccia con prefisso      |
//|        "ORB RUNNER:" / "ORB TP1:" / "ORB INIT:", stampata con    |
//|        Print() (NON con Log(), che dipende da InpVerbose: una    |
//|        diagnostica che si puo' spegnere per sbaglio non serve).  |
//|  v1.02 (19/08/2026, preparazione R88) - UN SOLO input nuovo:     |
//|        InpSLBufferPts (default 0 = comportamento IDENTICO a      |
//|        v1.01). Allontana lo stop di N punti oltre il livello     |
//|        calcolato nei modi OPPRANGE e HALFRANGE. Nasce da R55     |
//|        ("l'ORB non muore di PF, muore di drawdown - e la causa   |
//|        e' lo stop stretto") e dalla regola 5-10 punti del        |
//|        ToolKit ABTG. Vedi il blocco commentato sull'input.       |
//|  v1.01 - InpSlippagePts (R55), export per-trade, fix             |
//|        InpOneTradePerDay.                                        |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.04"
#property strict

//--- v1.04: QUANTI BLOCCHI E QUANTI CASI deve eseguire l'autotest.
//    Due contatori e non uno (pattern di casa, ABTG_LondonFx): un blocco
//    cancellato per sbaglio non deve poter passare per "tutto verde", e
//    nemmeno un blocco SVUOTATO delle sue asserzioni, che il conteggio
//    dei soli blocchi non vedrebbe. Se uno dei due conti non torna,
//    l'autotest si dichiara FALLITO.
#define ORBOTT_AUTOTEST_BLOCCHI_ATTESI 10
#define ORBOTT_AUTOTEST_CASI_ATTESI    33

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
CTrade gTrade;

enum ENUM_ORB_SL { ORB_SL_OPPRANGE=0, ORB_SL_ATR=1, ORB_SL_FIXED=2, ORB_SL_HALFRANGE=3 };
enum ENUM_ORB_TP { ORB_TP_R=0, ORB_TP_RANGE=1 };  // target in R sullo stop, oppure in multipli dell'ampiezza del range

//==================================================================
//  INPUT
//==================================================================
input group "=== Range ORB (ORARI SERVER, come l'indicatore) ==="
input int    InpRangeStartHour = 14;  // Inizio range (server). BCM: 14:25 = 15:25 IT
input int    InpRangeStartMin  = 25;
input int    InpRangeEndHour   = 14;  // Fine range (server). BCM: 14:30 = 15:30 IT
input int    InpRangeEndMin    = 30;
input int    InpEndHour        = 22;  // Fine giornata: cancella/chiude (server). Indicatore: 22:59
input int    InpEndMin         = 59;
input bool   InpCloseAtEnd     = true;
input bool   InpOneTradePerDay = true;
input int    InpPendingExpiryMin = 600;

input group "=== Ingresso (EntryPoints x K, come l'indicatore) ==="
input double InpEntryPoints = 10.0;   // Distanza ingresso oltre max/min (in unita' K)
input double InpK           = 1.0;    // Coefficiente: indici/oro=1.0; 225JPY=10; JPY=0.01; forex=0.0001; oil=0.01
input bool   InpAllowLong   = true;
input bool   InpAllowShort  = true;

input group "=== Stop, target, gestione ==="
input ENUM_ORB_SL InpSLMode = ORB_SL_OPPRANGE; // Estremo opposto range / ATR / punti fissi
input ENUM_TIMEFRAMES InpExecTF = PERIOD_M5;   // TF di esecuzione (ATR, EMA, trailing)
input int    InpAtrPeriod  = 14;
input double InpAtrSLmult   = 1.5;
input double InpSLFixedPts   = 1000;   // (FIXED) stop in punti
input double InpTP_R         = 2.0;    // Take profit in R (webinar: min 1:2)
input ENUM_ORB_TP InpTPMode  = ORB_TP_R;   // (articolo ORB filtrato) TP in R oppure in multipli del range
input double InpTPRangeMult  = 1.5;    // (TP_RANGE) target = breakout +/- ampiezza range x questo
input double InpTP1Pct       = 50;     // % chiusa al target
input bool   InpBreakeven    = true;   // Stop in pari dopo la parziale
input bool   InpUseTrailEMA  = true;   // Trailing dello stop sull'EMA veloce
input int    InpEmaFast      = 9;
input int    InpEmaSlow      = 21;
input bool   InpExitOnEmaClose = true; // Esci se una candela chiude oltre l'EMA9 opposta

//--- BUFFER SULLO STOP (19/08/2026, v1.02 - opt-in, default 0)
//  PERCHE'. R55 ha misurato che questa sedia "non muore di PF, muore di
//  DRAWDOWN": sfonda il cancello del 10% con 1,5 punti indice di
//  slippage, con una sensibilita' 11 volte quella del PTE. Il referto
//  nomina anche la causa: lo stop e' STRETTISSIMO (50% del range) e il
//  lotto si calcola come rischio/distanza_stop -> stop stretto = piu'
//  lotti = ogni punto costa di piu'. La via indicata da
//  report/ORB_100K_CRITERI.md punto D e' ALLARGARE LO STOP, non
//  abbassare ancora il peso. Il ToolKit ABTG, dal canto suo, mette lo
//  stop "5-10 punti oltre l'estremo opposto del range": lo stesso
//  buffer, scritto dal corso.
//
//  COSA FA. Nei modi OPPRANGE (estremo opposto) e HALFRANGE (50% del
//  range) allontana lo stop di N punti oltre il livello calcolato:
//  long  -> sl = livello - N*_Point
//  short -> sl = livello + N*_Point
//  Non tocca i modi ATR e FIXED, che hanno gia' la loro distanza.
//
//  UNITA'. PUNTI MT5, come InpSlippagePts e InpSLFixedPts. Su U30USD a
//  BCM 100 punti = 1 punto indice (misurato in R55): i "5-10 punti" del
//  ToolKit sono quindi 500-1000 qui dentro.
//
//  DIFFERENZA VOLUTA RISPETTO A ABTG_ORB_Fibo.mq5. La' il buffer e'
//  MathMax(InpSLBufferPts, SYMBOL_TRADE_STOPS_LEVEL): comodo, ma con
//  default 0 il comportamento NON sarebbe identico a prima su un broker
//  con stops level > 0. Qui il default 0 deve essere un no-op esatto,
//  perche' il round R88 confronta con/senza a parita' di tutto il
//  resto. Il rispetto dello stops level resta dov'era (EntryDistance).
//
//  EFFETTO ATTESO (da verificare col tester, non dichiarato come fatto):
//  meno lotti a parita' di rischio %, quindi DD piu' basso e meno
//  fragilita' allo slippage; in cambio piu' stop presi per intero.
input double InpSLBufferPts  = 0;      // Buffer extra sullo stop in PUNTI (0 = come v1.01). Solo modi OPPRANGE/HALFRANGE

input group "=== Ricetta ToolKit ABTG / live (tutto OPT-IN, default = comportamento attuale) ==="
input bool   InpUseCloseConfirm  = false;  // Entra alla CHIUSURA di una candela oltre il livello, invece che con pendenti STOP
input double InpMinBodyPct       = 50;     // (CLOSE_CONFIRM) corpo minimo della candela di rottura, in % del suo range (0=off)
input bool   InpUseEmaFilter     = false;  // Filtro direzionale: EMA veloce/lenta allineate E prezzo dalla parte giusta di ENTRAMBE
input bool   InpUseEma200Filter  = false;  // (utenti ABTG) long solo sopra la EMA lunga, short solo sotto
input int    InpEma200Period     = 200;    // periodo della EMA lunga (sul TF di esecuzione)
input double InpMinRangePct      = 0;      // (ORB DAX) ampiezza minima del range in % del prezzo (0.2 = 0,2%); 0 = off
input double InpMaxRangePct      = 0;      // (edgeful) ampiezza MASSIMA del range in % del prezzo (0.8 = 0,8%); 0 = off
input bool   InpUseVolumeFilter  = false;  // Volume della candela di rottura >= X * media
input double InpVolMult          = 1.5;    // (volumi) moltiplicatore: 1.5 = +50%, come da live
input int    InpVolAvgBars       = 20;     // (volumi) barre per la media

input group "=== Rischio ==="
input double InpRiskPercent  = 1.0;    // Rischio per trade in %

input group "=== Filtro notizie (CSV in MQL5/Files) ==="
input bool   InpUseNewsFilter = false;
input string InpNewsFile      = "abtg_news.csv";
input int    InpNewsMinImpact = 3;
input int    InpNewsBeforeMin = 30;
input int    InpNewsAfterMin  = 30;
input int    InpNewsShiftMinutes = 0;
input string InpNewsCurrencies= "USD";
input bool   InpNewsFlatten   = true;

input group "=== Generali ==="
input string InpComment   = "ORB OTT";
input long   InpMagic     = 770611;   // magic DIVERSO dal corso (770601)
input int    InpMaxSpread = 0;
input bool   InpVerbose   = true;
//--- v1.04: autotest a tavolino del nucleo di selezione hedge-safe.
//    NON tocca il mercato, NON cambia una sola decisione di trading:
//    stampa in OnInit e basta. Default true perche' una verifica che si
//    puo' spegnere da pannello per sbaglio non serve a niente -- e
//    perche' e' l'unica prova che qui si puo' produrre senza MetaEditor.
input bool   InpAutoTest  = true;     // Autotest del nucleo di selezione (stampa in OnInit)

input group "=== Slippage stimato (R55: quanto scala questa cella) ==="
//  PERCHE' (15/08/2026, R55). Tutti i backtest del progetto girano con
//  riempimento PERFETTO. Qui l'ingresso e' un pendente STOP, cioe' il
//  caso in cui lo slippage morde di piu': la rottura e' il momento in
//  cui il book e' piu' sottile.
//
//  COME E' MODELLATO: nel tester non si puo' cambiare il prezzo a cui
//  il broker riempie, ma uno slippage di X punti equivale a chiudere X
//  punti piu' in la' nel verso sfavorevole. Quindi SL e TP si spostano
//  di X nel verso contrario al trade, DOPO il calcolo del lotto (che
//  resta sul rischio ORIGINALE, quello visto al momento di decidere).
//  Netto: -X punti su ogni trade, vincente o perdente.
//
//  LIMITE DICHIARATO: modello del primo ordine. Non simula riempimento
//  parziale ne' profondita' del book - MT5 non li modella affatto.
//
//  DEFAULT 0 = comportamento identico a prima, forward invariato.
input double InpSlippagePts = 0;   // R55: slippage stimato in PUNTI (0 = off, come sempre)


//==================================================================
//  STATO
//==================================================================
int      hAtr=INVALID_HANDLE, hEmaF=INVALID_HANDLE, hEmaS=INVALID_HANDLE, hEma200=INVALID_HANDLE;
enum ENUM_ORBPHASE { ORB_WAIT, ORB_ARMED, ORB_PLACED, ORB_DONE };
ENUM_ORBPHASE gPhase=ORB_WAIT;
int      gDay=-1;
double   gRangeHigh=0, gRangeLow=0;
bool     gPart1=false;
bool     gHadPos=false;
datetime gLastExec=0;

//--- v1.04: IL TICKET DELLA NOSTRA POSIZIONE. Lo scrive SelPos() a ogni
//    selezione riuscita ed e' l'unico appiglio usato dalle scritture
//    (PositionModify / PositionClose). Vale 0 quando non abbiamo niente
//    di aperto: qualunque scrittura con gTicketMio==0 e' un errore di
//    programmazione, non una condizione di mercato.
ulong    gTicketMio=0;
//--- v1.04: buffer riusati per fotografare le posizioni del terminale.
//    Globali e non locali apposta: la lettura gira a ogni tick e non
//    deve allocare/liberare array ogni volta.
string   gPosSym[]; long gPosMag[]; ulong gPosTk[];

datetime gNewsTime[]; int gNewsImpact[]; string gNewsCcy[]; int gNewsCount=0;

void Log(string m){ if(InpVerbose) Print("[ORB_OTT] ", m); }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(30);
   hAtr =iATR(_Symbol,InpExecTF,InpAtrPeriod);
   //--- v1.03: la EMA veloce e' l'indicatore da cui dipende TUTTO il runner
   //    (trailing + uscita su chiusura oltre l'EMA). L'ipotesi n.2 del dossier
   //    22/08 e' proprio che su un terminale l'handle non si carichi e la
   //    funzione esca in silenzio: qui si dichiara l'esito alla nascita, cosi'
   //    la prima riga del log del terminale gia' assolve o accusa l'handle.
   ResetLastError();
   hEmaF=iMA(_Symbol,InpExecTF,InpEmaFast,0,MODE_EMA,PRICE_CLOSE);
   if(hEmaF==INVALID_HANDLE)
      PrintFormat("ORB INIT: handle EMA veloce INVALID_HANDLE (%s, TF %d, periodo %d, EMA, PRICE_CLOSE) err=%d",
                  _Symbol,(int)InpExecTF,InpEmaFast,GetLastError());
   else
      PrintFormat("ORB INIT: handle EMA veloce OK = %d (%s, TF %d, periodo %d, EMA, PRICE_CLOSE). Trailing EMA=%s, uscita su chiusura oltre EMA=%s",
                  hEmaF,_Symbol,(int)InpExecTF,InpEmaFast,
                  (InpUseTrailEMA?"ON":"OFF"),(InpExitOnEmaClose?"ON":"OFF"));
   hEmaS=iMA(_Symbol,InpExecTF,InpEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   hEma200=iMA(_Symbol,InpExecTF,InpEma200Period,0,MODE_EMA,PRICE_CLOSE);
   if(hAtr==INVALID_HANDLE||hEmaF==INVALID_HANDLE||hEmaS==INVALID_HANDLE||hEma200==INVALID_HANDLE)
     {
      //--- v1.03: dire QUALE handle e' saltato, non solo che qualcosa e' saltato
      PrintFormat("ORB INIT: ERRORE handle indicatori (ATR=%d EMAveloce=%d EMAlenta=%d EMAlunga=%d), err=%d",
                  hAtr,hEmaF,hEmaS,hEma200,GetLastError());
      return(INIT_FAILED);
     }
   if(InpUseNewsFilter) LoadNews();
   if(InpAutoTest) Autotest();   // v1.04: verifica a tavolino del nucleo di selezione
   Log(StringFormat("avviato su %s. Range server %02d:%02d-%02d:%02d, ingresso %.1f x K(%.4f), fine %02d:%02d.",
       _Symbol,InpRangeStartHour,InpRangeStartMin,InpRangeEndHour,InpRangeEndMin,InpEntryPoints,InpK,InpEndHour,InpEndMin));
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hAtr !=INVALID_HANDLE) IndicatorRelease(hAtr);
   if(hEmaF!=INVALID_HANDLE) IndicatorRelease(hEmaF);
   if(hEmaS!=INVALID_HANDLE) IndicatorRelease(hEmaS);
   if(hEma200!=INVALID_HANDLE) IndicatorRelease(hEma200);
  }

//+------------------------------------------------------------------+
//| Filtro EMA lunga (utenti ABTG): long solo sopra, short solo sotto|
//| Confronto sulla CHIUSURA dell'ultima candela chiusa del TF exec. |
//+------------------------------------------------------------------+
bool Ema200SideOK(int dir)
  {
   if(!InpUseEma200Filter) return(true);
   double e[1];
   if(CopyBuffer(hEma200,0,1,1,e)<1) return(true); // dati insuff.: non blocco
   double px=iClose(_Symbol,InpExecTF,1);
   if(px<=0) return(true);
   return(dir>0 ? px>e[0] : px<e[0]);
  }

//+------------------------------------------------------------------+
void OnTick()
  {
   ManageTP1();
   HandleOCO();

   // 08/08/2026 -- InpOneTradePerDay era dichiarato e MAI letto: dopo lo stop
   // il pendente opposto restava vivo (scadenza 600') e riapriva in giornata
   // ("si gira e ristoppato", visto live il 06/08). Con il flag acceso, chiuso
   // il trade del giorno si cancellano i pendenti superstiti.
   //--- v1.04, CAMBIO DI COMPORTAMENTO REALE, da tenere davanti agli occhi:
   //    il codice qui sotto e' identico, ma SelPos() ora VEDE. Nelle giornate
   //    con un vicino a ticket piu' basso gHadPos restava falso per sempre e
   //    "un trade al giorno" NON SI ARMAVA MAI: i pendenti superstiti
   //    restavano vivi e potevano riaprire in giornata. Da adesso quelle
   //    giornate si comportano come tutte le altre -> su un simbolo affollato
   //    ci si aspetta MENO trade, non di piu'. Non e' un miglioramento
   //    promesso: e' l'EA che fa quello che dice il suo pannello.
   if(SelPos()) gHadPos=true;
   else if(gHadPos && InpOneTradePerDay) CancelPendings();

   MqlDateTime now; TimeToStruct(TimeCurrent(),now);
   if(now.day_of_year!=gDay){ gDay=now.day_of_year; ResetDay(); }

   bool newsBlk=InNewsBlackout(TimeCurrent());
   //--- v1.04: il flatten notizie chiudeva con PositionClose(_Symbol), cioe'
   //    "chiudi il ticket piu' basso del simbolo": su hedging poteva essere
   //    la posizione di un'ALTRA sedia (categoria arancione dell'audit del
   //    03/09). Ora chiude SOLO le nostre, una per una, per TICKET.
   //    NB: in tutto il forward questo ramo non e' mai stato eseguito
   //    (InpUseNewsFilter=false e abtg_news.csv vuoto, misurato in
   //    report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md): si corregge
   //    perche' il ramo esiste, non perche' abbia fatto danni.
   if(newsBlk && InpNewsFlatten){ CancelPendings(); ChiudiPosizioniMie("blackout notizie"); }

   int nowMin=now.hour*60+now.min;
   if(nowMin>=InpEndHour*60+InpEndMin){ EndOfDay(); return; }

   //--- gestione runner (EMA) a nuova barra M5
   datetime t=iTime(_Symbol,InpExecTF,0);
   bool newBar=(t!=gLastExec);
   if(newBar){ gLastExec=t; ManageRunner(); }

   //--- fine del range: piazzo i pendenti (classico) oppure ARMO la sorveglianza (ToolKit)
   if(gPhase==ORB_WAIT && nowMin>=InpRangeEndHour*60+InpRangeEndMin)
     {
      if(newsBlk) return;
      if(InpUseCloseConfirm)
        {
         if(ArmCloseConfirm()) gPhase=ORB_ARMED;
        }
      else
        {
         if(TryPlace()) gPhase=ORB_PLACED;
        }
     }

   //--- ToolKit: aspetto che una candela CHIUDA oltre il livello. Valuto a nuova barra.
   if(gPhase==ORB_ARMED && newBar)
     {
      if(newsBlk) return;
      if(TryCloseConfirmEntry()) gPhase=ORB_PLACED;
     }
  }

void ResetDay(){ gPhase=ORB_WAIT; gRangeHigh=0; gRangeLow=0; gPart1=false; gHadPos=false; Log("nuovo giorno."); }

//+------------------------------------------------------------------+
//| Calcola max/min del range (finestra server, anche a cavallo mezzanotte)|
//+------------------------------------------------------------------+
bool ComputeRange(double &hi,double &lo)
  {
   MqlDateTime t; TimeToStruct(TimeCurrent(),t); t.sec=0;
   t.hour=InpRangeEndHour;   t.min=InpRangeEndMin;   datetime tEnd=StructToTime(t);
   t.hour=InpRangeStartHour; t.min=InpRangeStartMin; datetime tStart=StructToTime(t);
   if(tStart>=tEnd) tStart-=86400;
   int iS=iBarShift(_Symbol,PERIOD_M1,tStart,false);
   int iE=iBarShift(_Symbol,PERIOD_M1,tEnd,false);
   if(iS<0||iE<0) return(false);
   int start=MathMin(iS,iE);
   int count=MathAbs(iS-iE)+1;
   if(count<1) return(false);
   int hIdx=iHighest(_Symbol,PERIOD_M1,MODE_HIGH,count,start);
   int lIdx=iLowest (_Symbol,PERIOD_M1,MODE_LOW, count,start);
   if(hIdx<0||lIdx<0) return(false);
   hi=iHigh(_Symbol,PERIOD_M1,hIdx);
   lo=iLow (_Symbol,PERIOD_M1,lIdx);
   return(hi>0 && lo>0 && hi>lo);
  }

//+------------------------------------------------------------------+
//| Piazza gli ordini pendenti oltre il range (EntryPoints x K)      |
//+------------------------------------------------------------------+
bool TryPlace()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   if(!RangeWideEnough()){ return(true); }   // giornata senza setup: range sotto la soglia %
   if(!SpreadOK()){ Log("spread alto: niente ordini."); return(true); }

   double entryDist=EntryDistance();
   double buyPx =NormalizePrice(gRangeHigh+entryDist);
   double sellPx=NormalizePrice(gRangeLow -entryDist);
   double atr=AtrVal();
   datetime exp=TimeCurrent()+InpPendingExpiryMin*60;

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB_Ottimizzato")) return(false);
   if(InpAllowLong && Ema200SideOK(+1))
     {
      double sl=SLforLong(buyPx,sellPx,atr);
      double dist=buyPx-sl;
      if(dist>0)
        {
         double tp=NormalizePrice(InpTPMode==ORB_TP_RANGE ? buyPx+(gRangeHigh-gRangeLow)*InpTPRangeMult
                                                          : buyPx+dist*InpTP_R);
         double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
         if(InpSlippagePts>0)          // R55: SL e TP scendono di X -> -X punti sul trade
           { double sp=InpSlippagePts*_Point; sl=NormalizePrice(sl-sp); tp=NormalizePrice(tp-sp); }
         if(lot>0 && gTrade.BuyStop(lot,buyPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" BUY"))
            Log(StringFormat("BUY STOP @ %.5f SL %.5f TP %.5f lot %.2f",buyPx,sl,tp,lot));
        }
     }
   if(InpAllowShort && Ema200SideOK(-1))
     {
      double sl=SLforShort(sellPx,buyPx,atr);
      double dist=sl-sellPx;
      if(dist>0)
        {
         double tp=NormalizePrice(InpTPMode==ORB_TP_RANGE ? sellPx-(gRangeHigh-gRangeLow)*InpTPRangeMult
                                                          : sellPx-dist*InpTP_R);
         double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
         if(InpSlippagePts>0)          // R55: SL e TP salgono di X -> -X punti sul trade
           { double sp=InpSlippagePts*_Point; sl=NormalizePrice(sl+sp); tp=NormalizePrice(tp+sp); }
         if(lot>0 && gTrade.SellStop(lot,sellPx,_Symbol,sl,tp,ORDER_TIME_SPECIFIED,exp,InpComment+" SELL"))
            Log(StringFormat("SELL STOP @ %.5f SL %.5f TP %.5f lot %.2f",sellPx,sl,tp,lot));
        }
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| ToolKit ABTG (Vol. V) + ricetta dalle live: invece di piazzare    |
//| pendenti STOP si ASPETTA che una candela CHIUDA oltre il livello. |
//|  «Non basta che il prezzo tocchi il livello: la candela deve      |
//|   chiudersi al di sopra. Questo conferma che la rottura e' reale.»|
//| Qui si calcola solo il range e si arma la sorveglianza.           |
//+------------------------------------------------------------------+
bool ArmCloseConfirm()
  {
   if(!ComputeRange(gRangeHigh,gRangeLow))
     { Log("range non ancora calcolabile (dati M1): riprovo."); return(false); }
   if(!RangeWideEnough()){ gPhase=ORB_DONE; return(false); }   // giornata senza setup: chiusa qui
   Log(StringFormat("ARMATO (attesa chiusura confermata): range %.5f - %.5f", gRangeHigh, gRangeLow));
   return(true);
  }

//+------------------------------------------------------------------+
//| (ORB DAX) range valido solo se ampio almeno InpMinRangePct% del   |
//| prezzo: un range sotto soglia = giornata compressa, niente setup. |
//+------------------------------------------------------------------+
bool RangeWideEnough()
  {
   double px=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(px<=0) return(true);
   double rng=gRangeHigh-gRangeLow;
   if(InpMinRangePct>0 && rng < px*InpMinRangePct/100.0)
     { Log(StringFormat("range %.1f sotto la soglia %.2f%%: niente setup oggi.",rng,InpMinRangePct)); return(false); }
   if(InpMaxRangePct>0 && rng > px*InpMaxRangePct/100.0)
     { Log(StringFormat("range %.1f sopra il tetto %.2f%% (movimento gia' fatto): niente setup oggi.",rng,InpMaxRangePct)); return(false); }
   return(true);
  }

//+------------------------------------------------------------------+
//| Filtro direzionale del ToolKit: EMA veloce/lenta allineate E      |
//| prezzo dalla parte giusta di ENTRAMBE. Medie intrecciate o        |
//| prezzo in mezzo = NESSUNA operazione.                             |
//+------------------------------------------------------------------+
bool EmaSideOK(int dir)
  {
   if(!InpUseEmaFilter) return(true);
   double f[1], s[1];
   if(CopyBuffer(hEmaF,0,1,1,f)<1 || CopyBuffer(hEmaS,0,1,1,s)<1) return(true); // dati insuff.: non blocco
   double px=iClose(_Symbol,InpExecTF,1);
   if(px<=0) return(true);
   if(dir>0) return(f[0]>s[0] && px>f[0] && px>s[0]);
   if(dir<0) return(f[0]<s[0] && px<f[0] && px<s[0]);
   return(false);
  }

//+------------------------------------------------------------------+
//| Volume DELLA CANDELA DI ROTTURA >= X * media delle N precedenti   |
//|  (live: "volumi >= +50%, cioe' 1,5x la media a 20")               |
//+------------------------------------------------------------------+
bool VolumeOK()
  {
   if(!InpUseVolumeFilter) return(true);
   int n=InpVolAvgBars;
   if(n<2) return(true);
   long v[];
   ArraySetAsSeries(v,true);
   if(CopyTickVolume(_Symbol,InpExecTF,1,n+1,v)<n+1) return(true);  // dati insuff.: non blocco
   double sum=0;
   for(int i=1;i<=n;i++) sum+=(double)v[i];
   double avg=sum/n;
   if(avg<=0) return(true);
   return((double)v[0] >= InpVolMult*avg);   // v[0] = la candela appena chiusa = quella che rompe
  }

//+------------------------------------------------------------------+
//| Valuta l'ultima candela CHIUSA: ha rotto il range con un corpo    |
//| ampio, con le medie allineate e i volumi in crescita? Allora      |
//| entra A MERCATO. Altrimenti aspetta la prossima.                  |
//+------------------------------------------------------------------+
bool TryCloseConfirmEntry()
  {
   double o=iOpen (_Symbol,InpExecTF,1), c=iClose(_Symbol,InpExecTF,1);
   double h=iHigh (_Symbol,InpExecTF,1), l=iLow  (_Symbol,InpExecTF,1);
   if(o<=0 || c<=0 || h<=l) return(false);

   int dir=0;
   if(c>gRangeHigh)      dir=+1;
   else if(c<gRangeLow)  dir=-1;
   else                  return(false);          // chiusura DENTRO il range: non e' un breakout valido

   if(dir>0 && !InpAllowLong)  return(false);
   if(dir<0 && !InpAllowShort) return(false);

   //--- corpo ampio: una candela con corpo piccolo e ombra lunga che attraversa
   //    il livello e' spesso un falso breakout (ToolKit, errori comuni)
   double rng=h-l, body=MathAbs(c-o);
   if(InpMinBodyPct>0 && (rng<=0 || body < rng*InpMinBodyPct/100.0))
     { Log("rottura con corpo piccolo: ignoro (probabile falso break)."); return(false); }

   if(!EmaSideOK(dir)) { Log("medie non allineate col breakout: niente trade."); return(false); }
   if(!Ema200SideOK(dir)) { Log("prezzo dal lato sbagliato della EMA lunga: niente trade."); return(false); }
   if(!VolumeOK())     { Log("volume della rottura sotto la media: niente trade."); return(false); }
   if(!SpreadOK())     { Log("spread alto: niente trade."); return(false); }

   double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   if(ask<=0 || bid<=0) return(false);

   double entry=(dir>0)?ask:bid;
   double atr=AtrVal();
   double sl=(dir>0)?SLforLong(entry,gRangeLow,atr):SLforShort(entry,gRangeHigh,atr);
   double dist=(dir>0)?(entry-sl):(sl-entry);
   if(dist<=0){ Log("stop dalla parte sbagliata: niente trade."); return(false); }

   double rngH=gRangeHigh-gRangeLow;
   double tp;
   if(InpTPMode==ORB_TP_RANGE) tp=NormalizePrice((dir>0)?entry+rngH*InpTPRangeMult:entry-rngH*InpTPRangeMult);
   else                        tp=NormalizePrice((dir>0)?entry+dist*InpTP_R:entry-dist*InpTP_R);
   double lot=LotByRisk(dist);   // lotto dal rischio ORIGINALE, prima dello slippage
   if(lot<=0){ Log("lotto 0: niente trade."); return(false); }

   // R55: anche il ramo a mercato (chiusura confermata) paga lo slippage.
   // Coperto qui apposta: la cella viva gira con InpUseCloseConfirm=0, ma se
   // qualcuno lo accendesse lo slippage sparirebbe in silenzio, ed e' il
   // genere di buco che poi non si trova piu'.
   if(InpSlippagePts>0)
     { double sp=InpSlippagePts*_Point;
       sl=NormalizePrice((dir>0)?sl-sp:sl+sp);
       tp=NormalizePrice((dir>0)?tp-sp:tp+sp); }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_ORB_Ottimizzato")) return(false);
   bool ok=(dir>0) ? gTrade.Buy (lot,_Symbol,0.0,sl,tp,InpComment+" BUY CC")
                   : gTrade.Sell(lot,_Symbol,0.0,sl,tp,InpComment+" SELL CC");
   if(ok) Log(StringFormat("%s a mercato su chiusura confermata @ %.5f SL %.5f TP %.5f lot %.2f",
                           (dir>0?"BUY":"SELL"), entry, sl, tp, lot));
   else   Log("ingresso su chiusura confermata FALLITO: "+gTrade.ResultRetcodeDescription());
   return(ok);
  }

double EntryDistance()
  {
   double d=InpEntryPoints*InpK;                      // distanza in PREZZO
   double minD=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   return(MathMax(d,minD));
  }

//--- v1.02: buffer sullo stop in punti. Con InpSLBufferPts=0 vale 0 e
//    tutto resta identico a v1.01 (no-op esatto, voluto: vedi il blocco
//    commentato sull'input).
double SLBuffer(){ return(InpSLBufferPts>0 ? InpSLBufferPts*_Point : 0.0); }

double SLforLong(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeLow-SLBuffer();
   else if(InpSLMode==ORB_SL_FIXED) sl=entry-InpSLFixedPts*_Point;
   else if(InpSLMode==ORB_SL_HALFRANGE) sl=entry-0.5*(gRangeHigh-gRangeLow)-SLBuffer();
   else sl=entry-atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }
double SLforShort(double entry,double oppEntry,double atr)
  {
   double sl;
   if(InpSLMode==ORB_SL_OPPRANGE) sl=gRangeHigh+SLBuffer();
   else if(InpSLMode==ORB_SL_FIXED) sl=entry+InpSLFixedPts*_Point;
   else if(InpSLMode==ORB_SL_HALFRANGE) sl=entry+0.5*(gRangeHigh-gRangeLow)+SLBuffer();
   else sl=entry+atr*InpAtrSLmult;
   return(NormalizePrice(sl));
  }

//+------------------------------------------------------------------+
//| Parziale al target + stop in pari (ad ogni tick)                 |
//+------------------------------------------------------------------+
void ManageTP1()
  {
   if(!SelPos()) return;
   //--- v1.03: DIFETTO N.2 del dossier 22/08, dichiarato UNA VOLTA SOLA.
   //    Il breakeven (InpBreakeven) vive DENTRO questa funzione, dopo il
   //    parziale: se InpTP1Pct<=0 si esce qui e lo stop in pari non puo'
   //    scattare MAI, anche con InpBreakeven=true nel pannello. Sul conto
   //    piccolo lo screenshot del 22/08 mostra proprio InpTP1Pct=0. Flag
   //    statico: e' una condizione di configurazione, non un evento -- va
   //    detta all'inizio, non a ogni tick.
   if(InpTP1Pct<=0)
     {
      static bool avvisatoTP1Zero=false;
      if(!avvisatoTP1Zero)
        {
         avvisatoTP1Zero=true;
         PrintFormat("ORB TP1: TP1/breakeven disattivati da InpTP1Pct=%.1f (<=0). Nessun parziale e NESSUNO stop in pari, anche se InpBreakeven=%s.",
                     InpTP1Pct,(InpBreakeven?"true":"false"));
        }
      return;
     }
   if(gPart1 || InpTP1Pct>=100) return;
   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double openP=PositionGetDouble(POSITION_PRICE_OPEN);
   double sl=PositionGetDouble(POSITION_SL);
   double vol=PositionGetDouble(POSITION_VOLUME);
   ulong ticket=PositionGetInteger(POSITION_TICKET);
   double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID), ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double risk=isLong?(openP-sl):(sl-openP);
   if(risk<=0) return;
   double tgt=isLong?openP+risk*InpTP_R:openP-risk*InpTP_R;
   bool hit=isLong?(bid>=tgt):(ask<=tgt);
   if(!hit) return;
   double cv=NormVol(vol*InpTP1Pct/100.0);
   // 07/08: lo stop in pari NON deve dipendere dalla riuscita del parziale.
   // Al lotto minimo NormVol(vol*%) arrotonda a 0: il parziale non parte, e con
   // lui saltava anche il breakeven. Stessa correzione gia' fatta il 04/08 sugli
   // EMA200, dove era costata -112,78 EUR su due short oro a 0,01 lotti.
   bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
   if(parzOK) gPart1=true;
   //--- v1.04: dopo il parziale la posizione e' CAMBIATA (volume ridotto, e
   //    in casi limite chiusa del tutto). Prima si continuava a leggere SL e
   //    tipo dalla selezione precedente, cioe' da dati vecchi. Ci si
   //    riaggancia PER TICKET: se il ticket non esiste piu', non c'e' niente
   //    da portare in pari e si esce.
   if(!PositionSelectByTicket(ticket)) return;
   double bePari  = NormalizePrice(openP);
   double slPrec  = PositionGetDouble(POSITION_SL);
   bool   dirLong = (PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY);
   // il breakeven si fa SOLO se migliora lo stop: cosi' non si ripete a ogni tick
   bool beFatto = (InpBreakeven && ((dirLong && bePari>slPrec) ||
                                    (!dirLong && (slPrec==0 || bePari<slPrec))));
   //--- v1.04: lo stop in pari si mette sul NOSTRO TICKET. Con
   //    PositionModify(_Symbol,...) su hedging si sarebbe spostato lo stop
   //    della posizione col ticket piu' basso del simbolo -- cioe', con un
   //    vicino davanti, LO STOP DI UN'ALTRA SEDIA.
   if(beFatto)
     {
      ResetLastError();
      if(!gTrade.PositionModify(gTicketMio,bePari,PositionGetDouble(POSITION_TP)))
        {
         beFatto=false;
         PrintFormat("ORB TP1: stop in pari FALLITO sul ticket #%I64u (-> %s), retcode %u (%s), err=%d",
                     gTicketMio,DoubleToString(bePari,_Digits),
                     gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
        }
     }
   if(parzOK || beFatto)
      Log(parzOK ? "target: parziale + stop in pari."
                 : "target: stop in pari (parziale impossibile al lotto minimo).");
  }

//+------------------------------------------------------------------+
//| Runner: trailing su EMA9 + uscita se chiude oltre EMA9 opposta   |
//+------------------------------------------------------------------+
void ManageRunner()
  {
   //--- v1.03 -- STRUMENTAZIONE. Fino alla v1.02 questa funzione era MUTA:
   //    usciva in silenzio su cinque rami diversi e non diceva niente nemmeno
   //    quando il trailing FUNZIONAVA. Ecco perche' il 19/08, il 21/08 e il
   //    02/09 la divergenza fra i due conti si e' potuta ricostruire solo
   //    confrontando a mano i prezzi di chiusura. Da qui in poi ogni uscita
   //    anticipata lascia il suo motivo nel Giornale del terminale.
   //    THROTTLE: ManageRunner e' gia' chiamata una sola volta per barra M5
   //    (OnTick, ramo newBar), ma i rami "normali" -- posizione assente,
   //    condizione EMA non soddisfatta -- si stampano comunque al massimo una
   //    volta per barra, cosi' la protezione regge anche se un domani qualcuno
   //    spostasse la chiamata a ogni tick.
   static datetime gDiagBar=0;
   datetime barOra=iTime(_Symbol,InpExecTF,0);
   bool unaPerBarra=(barOra!=gDiagBar);
   if(unaPerBarra) gDiagBar=barOra;

   if(!SelPos())
     {
      //--- Ramo 1. Nessuna posizione NOSTRA selezionabile.
      //    v1.03: qui si stampava il log n.4, "SelPos() falso ma posizioni
      //    nostre esistenti", che era IL test dell'ipotesi hedging.
      //    v1.04: quella condizione e' IMPOSSIBILE PER COSTRUZIONE -- SelPos()
      //    non usa piu' PositionSelect(_Symbol) ma sceglie il nostro ticket
      //    scorrendo tutte le posizioni. Il controllo resta come INVARIANTE:
      //    se dovesse stampare ancora, non e' piu' il difetto hedging, e' una
      //    PositionSelectByTicket che fallisce su un ticket appena letto
      //    (posizione chiusa nel frattempo, o guaio serio del terminale). Va
      //    letta come un allarme, non come la conferma di un'ipotesi.
      //    La prova POSITIVA del fix la stampa ora "ORB SELEZIONE:" dentro
      //    SelPos(), al primo trade con vicini.
      int nostre=ContaPosizioniMagic();
      if(nostre>0 && unaPerBarra)
         PrintFormat("ORB RUNNER: INVARIANTE VIOLATA -- risultano %d posizioni con magic %I64d su %s ma la selezione per ticket e' fallita. Gestione del runner SALTATA su questa barra.",
                     nostre,InpMagic,_Symbol);
      return;
     }

   if(!InpUseTrailEMA && !InpExitOnEmaClose)
     {
      //--- Ramo 2. Configurazione: entrambe le gestioni EMA sono spente.
      if(unaPerBarra)
         Print("ORB RUNNER: InpUseTrailEMA=false E InpExitOnEmaClose=false -> nessuna gestione del runner, lo stop resta dov'e'.");
      return;
     }

   if(hEmaF==INVALID_HANDLE)
     {
      //--- Ramo 3. Handle mai nato (ipotesi n.2 del dossier). OnInit fallisce
      //    gia' in questo caso, ma se l'EA fosse stato ricaricato a caldo la
      //    riga qui sotto e' l'unica prova che resta.
      Print("ORB RUNNER: handle EMA veloce INVALID_HANDLE -> impossibile trailare. Ricaricare l'EA sul grafico.");
      return;
     }

   //--- Ramo 4. L'handle c'e' ma i dati no: CopyBuffer fallisce (dati non
   //    ancora sincronizzati, storico in caricamento, indicatore non calcolato).
   //    Nella v1.02 questo era il silenzio perfetto: return e nessuna traccia.
   double ef[1];
   ResetLastError();
   int copiati=CopyBuffer(hEmaF,0,1,1,ef);
   if(copiati!=1)
     {
      PrintFormat("ORB RUNNER: CopyBuffer(EMA%d handle %d, shift 1) ha restituito %d invece di 1, err=%d -> gestione saltata su questa barra.",
                  InpEmaFast,hEmaF,copiati,GetLastError());
      return;
     }

   long type=PositionGetInteger(POSITION_TYPE);
   bool isLong=(type==POSITION_TYPE_BUY);
   double close1=iClose(_Symbol,InpExecTF,1);
   if(close1<=0)
      PrintFormat("ORB RUNNER: iClose(%s,TF %d,shift 1) = %.5f (dato assente): il confronto con l'EMA usa un prezzo non valido.",
                  _Symbol,(int)InpExecTF,close1);

   //--- v1.04: le due uscite su EMA chiudono IL NOSTRO TICKET. Con
   //    PositionClose(_Symbol) su hedging si sarebbe chiusa la posizione col
   //    ticket piu' basso del simbolo: con un vicino davanti, il trade di
   //    un'altra sedia. Nella v1.03 il danno non si e' mai prodotto solo
   //    perche' SelPos() era falso proprio in quei casi e non si arrivava
   //    fin qui: correggere la lettura SENZA la scrittura avrebbe ARMATO il
   //    colpo (categoria arancione dell'audit del 03/09).
   if(InpExitOnEmaClose)
     {
      if(isLong && close1<ef[0])
        {
         ResetLastError();
         bool okC=gTrade.PositionClose(gTicketMio);
         if(okC) Log(StringFormat("chiusura M5 sotto EMA9: uscita (ticket #%I64u).",gTicketMio));
         else    PrintFormat("ORB RUNNER: uscita per chiusura sotto EMA%d FALLITA sul ticket #%I64u, retcode %u (%s), err=%d",
                             InpEmaFast,gTicketMio,gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
         return;
        }
      if(!isLong && close1>ef[0])
        {
         ResetLastError();
         bool okC=gTrade.PositionClose(gTicketMio);
         if(okC) Log(StringFormat("chiusura M5 sopra EMA9: uscita (ticket #%I64u).",gTicketMio));
         else    PrintFormat("ORB RUNNER: uscita per chiusura sopra EMA%d FALLITA sul ticket #%I64u, retcode %u (%s), err=%d",
                             InpEmaFast,gTicketMio,gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
         return;
        }
     }
   if(InpUseTrailEMA)
     {
      double sl=PositionGetDouble(POSITION_SL);
      double openP=PositionGetDouble(POSITION_PRICE_OPEN);
      double newSL=NormalizePrice(ef[0]);
      double bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      //--- v1.04: il trascinamento dello stop va sul NOSTRO TICKET (vedi sopra:
      //    PositionModify(_Symbol,...) spostava lo stop del ticket piu' basso
      //    del simbolo). Il ticket compare anche nel log: sul conto piccolo,
      //    con i vicini, e' la riga che prova che il fix funziona.
      if(isLong && newSL>sl && newSL<bid)
        {
         ResetLastError();
         if(gTrade.PositionModify(gTicketMio,newSL,PositionGetDouble(POSITION_TP)))
            PrintFormat("ORB RUNNER: stop LONG trascinato su EMA%d sul ticket #%I64u: %s -> %s (apertura %s, BID %s).",
                        InpEmaFast,gTicketMio,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        DoubleToString(openP,_Digits),DoubleToString(bid,_Digits));
         else
            PrintFormat("ORB RUNNER: PositionModify LONG FALLITA sul ticket #%I64u (%s -> %s), retcode %u (%s), err=%d",
                        gTicketMio,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
        }
      else if(isLong && unaPerBarra)
         //--- Ramo 5. Condizione non soddisfatta: si dicono i tre numeri che la
         //    decidono, cosi' dal log si capisce SUBITO se l'EMA e' sotto lo
         //    stop attuale (nulla da trascinare) o se e' il vincolo sul BID a
         //    mordere. Una riga per barra, non a ogni tick.
         PrintFormat("ORB RUNNER: nessun trascinamento LONG. EMA%d=%s, SL attuale=%s, BID=%s (servono EMA>SL e EMA<BID).",
                     InpEmaFast,DoubleToString(newSL,_Digits),DoubleToString(sl,_Digits),DoubleToString(bid,_Digits));

      if(!isLong && (newSL<sl||sl==0) && newSL>ask)
        {
         ResetLastError();
         if(gTrade.PositionModify(gTicketMio,newSL,PositionGetDouble(POSITION_TP)))
            PrintFormat("ORB RUNNER: stop SHORT trascinato su EMA%d sul ticket #%I64u: %s -> %s (apertura %s, ASK %s).",
                        InpEmaFast,gTicketMio,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        DoubleToString(openP,_Digits),DoubleToString(ask,_Digits));
         else
            PrintFormat("ORB RUNNER: PositionModify SHORT FALLITA sul ticket #%I64u (%s -> %s), retcode %u (%s), err=%d",
                        gTicketMio,DoubleToString(sl,_Digits),DoubleToString(newSL,_Digits),
                        gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
        }
      else if(!isLong && unaPerBarra)
         PrintFormat("ORB RUNNER: nessun trascinamento SHORT. EMA%d=%s, SL attuale=%s, ASK=%s (servono EMA<SL o SL=0, e EMA>ASK).",
                     InpEmaFast,DoubleToString(newSL,_Digits),DoubleToString(sl,_Digits),DoubleToString(ask,_Digits));
     }
  }

//==================================================================
//  v1.04 -- SELEZIONE HEDGE-SAFE DELLE POSIZIONI
//
//  IL DIFETTO CHE CURA (misurato, non ipotizzato):
//    bool SelPos(){ if(!PositionSelect(_Symbol)) return(false);
//                   return(PositionGetInteger(POSITION_MAGIC)==InpMagic); }
//  Su conto HEDGING PositionSelect(_Symbol) aggancia la posizione col
//  TICKET PIU' BASSO del simbolo, qualunque sia il magic. Se non e' la
//  nostra, il controllo sul magic fallisce e l'EA diventa CIECO alla
//  propria posizione: niente trailing, niente breakeven, niente OCO
//  disarmato, niente OneTradePerDay, niente chiusura di fine giornata.
//  Osservato tre volte sul conto piccolo (19/08, 21/08, 02/09) e
//  inchiodato dalla FOTO A del 03/09.
//
//  "TICKET PIU' BASSO", NON "PIU' VECCHIA IN OROLOGIO". La formulazione
//  giusta e' quella misurata in
//  report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md: su 170 coppie, il
//  16,5% ha l'ordine per ticket INVERTITO rispetto all'orologio, perche'
//  una posizione nata da un PENDENTE eredita il ticket di quando il
//  pendente e' stato PIAZZATO, non di quando si e' riempito. E questo EA
//  entra proprio con BuyStop/SellStop piazzati a inizio sessione.
//
//  LA FORMA DEL FIX: nucleo PURO (nessuna chiamata al terminale, quindi
//  autotestabile a tavolino) + un guscio sottile che gli passa la foto
//  delle posizioni. Il pensiero sta nel nucleo, cosi' l'autotest prova
//  il codice che gira davvero, non una sua copia.
//==================================================================

//--- Il predicato, una riga sola: la posizione e' NOSTRA se coincidono
//    SIMBOLO e MAGIC. Il magic da solo non basta (lo stesso EA puo'
//    girare su piu' simboli), il simbolo da solo e' il difetto di
//    HARSI_Assistant censito nell'audit.
bool PosMia_Calc(const string sym,const long magic,const string mioSym,const long mioMagic)
  { return(sym==mioSym && magic==mioMagic); }

//--- Elenca i ticket NOSTRI, ORDINATI PER TICKET CRESCENTE.
//    L'ordinamento non e' estetica: fissa quale posizione si gestisce
//    quando ne abbiamo piu' d'una (la piu' bassa, cioe' la prima nata),
//    e rende l'esito indipendente dall'ordine con cui il terminale
//    restituisce gli indici -- che NON e' l'ordine dei ticket.
int ElencaTicketMiei_Calc(const string &sym[],const long &mag[],const ulong &tk[],const int n,
                          const string mioSym,const long mioMagic,ulong &miei[])
  {
   ArrayResize(miei,0);
   int q=0;
   for(int i=0;i<n;i++)
     {
      if(tk[i]==0) continue;
      if(!PosMia_Calc(sym[i],mag[i],mioSym,mioMagic)) continue;
      ArrayResize(miei,q+1);
      int j=q-1;
      while(j>=0 && miei[j]>tk[i]){ miei[j+1]=miei[j]; j--; }
      miei[j+1]=tk[i];
      q++;
     }
   return(q);
  }

//--- Sceglie IL NOSTRO ticket e, gratis, dice anche quale ticket avrebbe
//    agganciato PositionSelect(_Symbol) (= il piu' basso del simbolo,
//    qualunque magic) e di chi e'. Quel secondo dato non decide niente:
//    serve al log "ORB SELEZIONE:", che e' il modo in cui questo fix si
//    verifica in campo al primo trade con vicini.
ulong ScegliTicketMio_Calc(const string &sym[],const long &mag[],const ulong &tk[],const int n,
                           const string mioSym,const long mioMagic,
                           int &quanteMie,ulong &tkPrimoLista,long &magicPrimoLista)
  {
   ulong miei[];
   quanteMie=ElencaTicketMiei_Calc(sym,mag,tk,n,mioSym,mioMagic,miei);
   tkPrimoLista=0; magicPrimoLista=0;
   for(int i=0;i<n;i++)
     {
      if(tk[i]==0) continue;
      if(sym[i]!=mioSym) continue;                    // i vicini di ALTRI simboli non contano
      if(tkPrimoLista==0 || tk[i]<tkPrimoLista){ tkPrimoLista=tk[i]; magicPrimoLista=mag[i]; }
     }
   return(quanteMie>0 ? miei[0] : 0);
  }

//--- Il guscio: fotografa le posizioni del terminale negli array globali.
//    Attenzione, PositionGetTicket(i) SELEZIONA la posizione all'indice i:
//    dopo questa funzione la "posizione corrente" e' l'ultima letta, mai
//    dare per buono che sia la nostra. Chi deve leggerne i campi passa
//    sempre da SelPos(), che rifa' PositionSelectByTicket.
int LeggiPosizioni()
  {
   int tot=PositionsTotal();
   ArrayResize(gPosSym,tot); ArrayResize(gPosMag,tot); ArrayResize(gPosTk,tot);
   int n=0;
   for(int i=0;i<tot;i++)
     {
      ulong tk=PositionGetTicket(i);
      if(tk==0) continue;
      gPosTk[n] =tk;
      gPosSym[n]=PositionGetString(POSITION_SYMBOL);
      gPosMag[n]=PositionGetInteger(POSITION_MAGIC);
      n++;
     }
   return(n);
  }

//--- Quante posizioni NOSTRE ci sono davvero. Era la funzione di sola
//    diagnostica della v1.03 (l'audit del 03/09 la cita come "il pattern
//    sano gia' in casa"): ora e' scritta sopra al nucleo puro, cosi' non
//    esistono due implementazioni dello stesso filtro che possono
//    divergere.
int ContaPosizioniMagic()
  {
   ulong miei[];
   int n=LeggiPosizioni();
   return(ElencaTicketMiei_Calc(gPosSym,gPosMag,gPosTk,n,_Symbol,InpMagic,miei));
  }

//+------------------------------------------------------------------+
//| v1.04 -- CHIUSURA DELLE NOSTRE POSIZIONI, UNA PER UNA, PER TICKET.|
//| Sostituisce PositionClose(_Symbol) nei due punti di "flatten"      |
//| (fine giornata e blackout notizie). Tre cose che cambiano:         |
//|  1. non puo' piu' toccare la posizione di un'altra sedia;          |
//|  2. se per qualunque motivo di NOSTRE ce ne fossero due (il caso   |
//|     che l'OCO cieco rendeva possibile), le chiude ENTRAMBE;        |
//|  3. quando non abbiamo niente non fa NESSUNA chiamata: EndOfDay(), |
//|     che gira a ogni tick dopo l'ora di fine, resta muto invece di  |
//|     ritentare all'infinito (il "ciclo che chiude i vicini a        |
//|     catena" descritto nella VERIFICA del 03/09 qui non puo'        |
//|     nascere).                                                      |
//+------------------------------------------------------------------+
int ChiudiPosizioniMie(const string motivo)
  {
   ulong miei[];
   int n=LeggiPosizioni();
   int q=ElencaTicketMiei_Calc(gPosSym,gPosMag,gPosTk,n,_Symbol,InpMagic,miei);
   int chiuse=0;
   for(int i=0;i<q;i++)
     {
      ResetLastError();
      if(gTrade.PositionClose(miei[i]))
        { chiuse++; Log(StringFormat("%s: chiusa la posizione #%I64u.",motivo,miei[i])); }
      else
         PrintFormat("ORB CHIUSURA: PositionClose(#%I64u) FALLITA (%s), retcode %u (%s), err=%d",
                     miei[i],motivo,gTrade.ResultRetcode(),gTrade.ResultRetcodeDescription(),GetLastError());
     }
   if(chiuse>0) gTicketMio=0;
   return(chiuse);
  }

//+------------------------------------------------------------------+
//| OCO: appena una posizione NOSTRA esiste, il pendente opposto si    |
//| cancella. v1.04: prima questa riga era dietro il SelPos() cieco,   |
//| quindi nelle giornate con un vicino a ticket piu' basso il secondo |
//| lato restava ARMATO -- misurato in forward sul gemello nativo      |
//| (ABTG_ORB, 4 giornate su 16 con il secondo lato riempito,          |
//| report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md). Sul 770611 non |
//| si e' ancora prodotto, ma era possibile per costruzione.           |
//+------------------------------------------------------------------+
void HandleOCO(){ if(SelPos()) CancelPendings(); }

void CancelPendings()
  {
   for(int i=OrdersTotal()-1;i>=0;i--)
     {
      ulong t=OrderGetTicket(i);
      if(t==0) continue;
      if(OrderGetString(ORDER_SYMBOL)!=_Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC)!=InpMagic) continue;
      gTrade.OrderDelete(t);
     }
  }

void EndOfDay()
  {
   CancelPendings();
   //--- v1.04: chiusura di fine giornata PER TICKET, e solo delle nostre.
   //    Prima: SelPos() cieco -> nelle giornate con vicini la posizione NON
   //    veniva chiusa affatto; e se SelPos() fosse stato corretto da solo,
   //    PositionClose(_Symbol) avrebbe chiuso il trade del vicino.
   if(InpCloseAtEnd) ChiudiPosizioniMie("fine giornata");
   gPhase=ORB_DONE;
  }

//==================================================================
//  UTILITY
//==================================================================
double AtrVal(){ double a[1]; if(CopyBuffer(hAtr,0,1,1,a)<1) return(0); return(a[0]); }

double NormalizePrice(double price)
  {
   double ts=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
   int dg=(int)SymbolInfoInteger(_Symbol,SYMBOL_DIGITS);
   if(ts<=0) return(NormalizeDouble(price,dg));
   return(NormalizeDouble(MathRound(price/ts)*ts,dg));
  }

double LotByRisk(double slDist)
  {
   if(slDist<=0) return(0);
   double risk=AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPercent/100.0;
   //  08/08/2026 -- PERDITA PER LOTTO DAL BROKER, NON DAL TICK VALUE NUDO.
   //  Su 225JPY il tick value arriva non convertito in valuta conto: il lotto
   //  usciva ~0 e finiva SEMPRE al minimo (round 2: a deposito 100k profitti
   //  identici al 10k, DD 0,01%). OrderCalcProfit converte correttamente; il
   //  tick value resta come ripiego. Sui simboli sani i due calcoli coincidono:
   //  il comportamento cambia SOLO dove il tick value mente.
   double lossPerLot=0;
   double pxCalc=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   double profCalc=0;
   if(pxCalc>slDist && OrderCalcProfit(ORDER_TYPE_BUY,_Symbol,1.0,pxCalc,pxCalc-slDist,profCalc) && profCalc<0)
      lossPerLot=-profCalc;
   if(lossPerLot<=0)
     {
      double tv=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_VALUE);
      double tsz=SymbolInfoDouble(_Symbol,SYMBOL_TRADE_TICK_SIZE);
      if(tv<=0||tsz<=0) return(0);
      lossPerLot=(slDist/tsz)*tv;
     }
   if(lossPerLot<=0) return(0);
   double lot=risk/lossPerLot;
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   double mx=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP); if(st<=0) st=0.01;
   lot=MathFloor(lot/st)*st;
   return(MathMax(mn,MathMin(mx,lot)));
  }

double NormVol(double v)
  {
   double st=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
   double mn=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
   if(st<=0) st=0.01;
   v=MathFloor(v/st)*st;
   return(v<mn?0:v);
  }

bool SpreadOK(){ if(InpMaxSpread<=0) return(true); return(SymbolInfoInteger(_Symbol,SYMBOL_SPREAD)<=InpMaxSpread); }

//+------------------------------------------------------------------+
//| SelPos() -- v1.04, HEDGE-SAFE. Nome invariato apposta: tutti i     |
//| punti di chiamata (ManageTP1, ManageRunner, HandleOCO, il ramo     |
//| gHadPos/InpOneTradePerDay) restano una riga uguale a prima, e la   |
//| revisione prima della firma guarda UNA funzione sola.              |
//| Contratto: true = la NOSTRA posizione esiste ED E' SELEZIONATA per |
//| ticket, quindi tutte le PositionGet* che seguono leggono lei.      |
//| Effetto collaterale voluto: scrive gTicketMio, che e' l'appiglio   |
//| di ogni scrittura (modify/close).                                  |
//+------------------------------------------------------------------+
bool SelPos()
  {
   int  quante=0; ulong tkPrimo=0; long magicPrimo=0;
   int  n=LeggiPosizioni();
   gTicketMio=ScegliTicketMio_Calc(gPosSym,gPosMag,gPosTk,n,_Symbol,InpMagic,quante,tkPrimo,magicPrimo);
   if(gTicketMio==0) return(false);

   //--- LA PROVA SUL CAMPO DEL FIX (sostituisce il log n.4 della v1.03,
   //    "SelPos falso ma posizioni nostre esistenti", che ora e'
   //    impossibile per costruzione). Stampa SOLO quando il ticket piu'
   //    basso del simbolo NON e' il nostro: cioe' esattamente nei casi in
   //    cui la v1.03 sarebbe uscita cieca. Una riga per TICKET nostro
   //    (non per barra, non per tick): al primo trade con vicini si vede
   //    una volta e basta, e dice tutto quello che serve.
   static ulong ultimoAnnunciato=0;
   if(tkPrimo!=gTicketMio && gTicketMio!=ultimoAnnunciato)
     {
      ultimoAnnunciato=gTicketMio;
      PrintFormat("ORB SELEZIONE: presa la NOSTRA posizione #%I64u (magic %I64d, %d nostra/e su %s). Il ticket piu' basso del simbolo e' #%I64u di magic %I64d: la v1.03 avrebbe agganciato QUELLO e sarebbe uscita CIECA. Gestione attiva.",
                  gTicketMio,InpMagic,quante,_Symbol,tkPrimo,magicPrimo);
     }

   //--- L'aggancio vero. Se fallisce (posizione chiusa fra la lettura e
   //    adesso) si azzera il ticket: nessuna scrittura deve poter partire
   //    su un appiglio morto.
   if(!PositionSelectByTicket(gTicketMio)){ gTicketMio=0; return(false); }
   return(true);
  }

//==================================================================
//  v1.04 -- AUTOTEST DEL NUCLEO DI SELEZIONE (gira in OnInit)
//
//  Perche' esiste. Qui non c'e' MetaEditor ne' Strategy Tester: senza
//  questa funzione l'unica prova che il fix e' scritto giusto sarebbe
//  "l'ho riletto". L'autotest interroga il NUCLEO PURO -- lo stesso che
//  gira in campo, non una copia -- con posizioni finte, e in particolare
//  con IL caso che ha prodotto il difetto: un vicino di un altro magic
//  col TICKET PIU' BASSO del nostro.
//
//  Cosa NON prova: che PositionSelect(_Symbol) scelga davvero il ticket
//  piu' basso su conto hedging. Quella resta una premessa (dichiarata
//  come tale nella VERIFICA del 03/09, limite n.4), coerente con 16
//  giornate su 16 dello storico. Qui si prova che, QUALUNQUE cosa
//  scelga il terminale, noi scegliamo LA NOSTRA.
//
//  Si legge ESEGUENDO, non compilando: le righe escono nel Giornale al
//  caricamento dell'EA sul grafico (e all'avvio di ogni backtest).
//==================================================================
void CasoPos(string &sym[],long &mag[],ulong &tk[],const int idx,
             const string s,const long m,const ulong t)
  { sym[idx]=s; mag[idx]=m; tk[idx]=t; }

void DimensionaCaso(string &sym[],long &mag[],ulong &tk[],const int k)
  { ArrayResize(sym,k); ArrayResize(mag,k); ArrayResize(tk,k); }

void Autotest()
  {
   int blocchi=0, casi=0, falliti=0;
   string sym[]; long mag[]; ulong tk[];
   ulong  miei[];
   int    q=0; ulong ret=0, primo=0; long magicPrimo=0;

   const string S="MIOSIMBOLO";   // il nostro simbolo (finto: il nucleo non tocca il terminale)
   const string A="ALTROSIMB";    // un simbolo qualsiasi che non e' il nostro
   const long   M=770611;         // il NOSTRO magic
   const long   V=772341;         // il vicino: e' il magic di LARRY DOW S, quello della FOTO A

   //--- BLOCCO 1: il predicato simbolo+magic. Il magic da solo non basta,
   //    il simbolo da solo nemmeno.
   blocchi++; casi+=4;
   if(!( PosMia_Calc(S,M,S,M) && !PosMia_Calc(A,M,S,M) &&
        !PosMia_Calc(S,V,S,M) && !PosMia_Calc(A,V,S,M) ))
     { falliti++; Print("ORB AUTOTEST: 1 PosMia_Calc DIVERGE"); }

   //--- BLOCCO 2: nessuna posizione al mondo. Niente da selezionare, e
   //    soprattutto nessun ticket inventato.
   blocchi++; casi+=3;
   DimensionaCaso(sym,mag,tk,0);
   ret=ScegliTicketMio_Calc(sym,mag,tk,0,S,M,q,primo,magicPrimo);
   if(!(ret==0 && q==0 && primo==0))
     { falliti++; Print("ORB AUTOTEST: 2 lista vuota DIVERGE"); }

   //--- BLOCCO 3: una sola posizione, nostra. Il caso del conto 100k, dove
   //    l'ORB sul Dow e' quasi sempre solo: qui il difetto non mordeva.
   blocchi++; casi+=3;
   DimensionaCaso(sym,mag,tk,1);
   CasoPos(sym,mag,tk,0,S,M,5000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,1,S,M,q,primo,magicPrimo);
   if(!(ret==5000 && q==1 && primo==5000))
     { falliti++; Print("ORB AUTOTEST: 3 una sola nostra DIVERGE"); }

   //--- BLOCCO 4: c'e' SOLO un vicino. Non dobbiamo selezionare niente --
   //    ma dobbiamo saper dire di CHI e' il ticket piu' basso.
   blocchi++; casi+=4;
   DimensionaCaso(sym,mag,tk,1);
   CasoPos(sym,mag,tk,0,S,V,4000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,1,S,M,q,primo,magicPrimo);
   if(!(ret==0 && q==0 && primo==4000 && magicPrimo==V))
     { falliti++; Print("ORB AUTOTEST: 4 solo vicino DIVERGE"); }

   //--- BLOCCO 5: IL CASO DEL 02/09. Vicino di un altro magic col ticket
   //    PIU' BASSO + la nostra posizione. La v1.02/v1.03 usciva cieca qui.
   //    Il nucleo deve restituire IL NOSTRO ticket e, insieme, il ticket
   //    del vicino per il log di verifica.
   blocchi++; casi+=4;
   DimensionaCaso(sym,mag,tk,2);
   CasoPos(sym,mag,tk,0,S,V,4000);
   CasoPos(sym,mag,tk,1,S,M,5000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,2,S,M,q,primo,magicPrimo);
   if(!(ret==5000 && q==1 && primo==4000 && magicPrimo==V))
     { falliti++; Print("ORB AUTOTEST: 5 vicino con ticket PIU' BASSO DIVERGE (e' IL caso del difetto)"); }

   //--- BLOCCO 6: vicino col ticket piu' ALTO. Anche prima funzionava:
   //    deve continuare a funzionare uguale (non-regressione).
   blocchi++; casi+=3;
   DimensionaCaso(sym,mag,tk,2);
   CasoPos(sym,mag,tk,0,S,M,4000);
   CasoPos(sym,mag,tk,1,S,V,5000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,2,S,M,q,primo,magicPrimo);
   if(!(ret==4000 && q==1 && primo==4000))
     { falliti++; Print("ORB AUTOTEST: 6 vicino con ticket piu' alto DIVERGE"); }

   //--- BLOCCO 7: DUE posizioni nostre (il caso che l'OCO cieco rendeva
   //    possibile) piu' un vicino davanti. Si gestisce la nostra col
   //    ticket piu' basso, e il conteggio deve dire 2 -- e' l'unico modo
   //    per accorgersi di un doppio ingresso.
   blocchi++; casi+=3;
   DimensionaCaso(sym,mag,tk,3);
   CasoPos(sym,mag,tk,0,S,V,4000);
   CasoPos(sym,mag,tk,1,S,M,6000);
   CasoPos(sym,mag,tk,2,S,M,5000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,3,S,M,q,primo,magicPrimo);
   if(!(ret==5000 && q==2 && primo==4000))
     { falliti++; Print("ORB AUTOTEST: 7 due posizioni nostre DIVERGE"); }

   //--- BLOCCO 8: l'ordine della LISTA non e' l'ordine dei TICKET.
   //    Stesso scenario del blocco 5 con gli indici invertiti: l'esito
   //    deve essere identico. E' la traduzione in codice della correzione
   //    di premessa del 03/09 ("ticket piu' basso", non "piu' vecchia").
   blocchi++; casi+=2;
   DimensionaCaso(sym,mag,tk,2);
   CasoPos(sym,mag,tk,0,S,M,5000);
   CasoPos(sym,mag,tk,1,S,V,4000);
   ret=ScegliTicketMio_Calc(sym,mag,tk,2,S,M,q,primo,magicPrimo);
   if(!(ret==5000 && primo==4000))
     { falliti++; Print("ORB AUTOTEST: 8 indipendenza dall'ordine di lista DIVERGE"); }

   //--- BLOCCO 9: il filtro SIMBOLO. Una posizione NOSTRA su un altro
   //    simbolo (stesso EA su un altro grafico) non si tocca; e un ticket
   //    bassissimo su un altro simbolo non deve entrare nel confronto.
   blocchi++; casi+=3;
   DimensionaCaso(sym,mag,tk,3);
   CasoPos(sym,mag,tk,0,A,V,1000);   // vicino, ALTRO simbolo: irrilevante
   CasoPos(sym,mag,tk,1,A,M,3000);   // NOSTRO magic ma ALTRO simbolo: non e' nostra qui
   CasoPos(sym,mag,tk,2,S,V,4000);   // vicino sul nostro simbolo
   ret=ScegliTicketMio_Calc(sym,mag,tk,3,S,M,q,primo,magicPrimo);
   if(!(ret==0 && q==0 && primo==4000))
     { falliti++; Print("ORB AUTOTEST: 9 filtro simbolo DIVERGE"); }

   //--- BLOCCO 10: l'elenco usato dalle CHIUSURE (ChiudiPosizioniMie).
   //    Deve contenere solo le nostre, ordinate per ticket crescente: e'
   //    la garanzia che il flatten non possa mai toccare un vicino.
   blocchi++; casi+=4;
   DimensionaCaso(sym,mag,tk,0);
   int q0=ElencaTicketMiei_Calc(sym,mag,tk,0,S,M,miei);
   DimensionaCaso(sym,mag,tk,4);
   CasoPos(sym,mag,tk,0,S,V,4000);
   CasoPos(sym,mag,tk,1,S,M,6000);
   CasoPos(sym,mag,tk,2,A,M,2000);
   CasoPos(sym,mag,tk,3,S,M,5000);
   int q4=ElencaTicketMiei_Calc(sym,mag,tk,4,S,M,miei);
   if(!(q0==0 && q4==2 && miei[0]==5000 && miei[1]==6000))
     { falliti++; Print("ORB AUTOTEST: 10 ElencaTicketMiei_Calc DIVERGE"); }

   //--- IL CONTROLLO SUL CONTROLLO. Un gate che non conta quello che ha
   //    eseguito non e' un gate: un blocco cancellato passerebbe per
   //    "tutto verde", e un blocco svuotato delle asserzioni pure.
   if(blocchi!=ORBOTT_AUTOTEST_BLOCCHI_ATTESI)
     {
      falliti++;
      PrintFormat("ORB AUTOTEST: eseguiti %d blocchi ma ne erano attesi %d: MANCA UN BLOCCO. Autotest FALLITO.",
                  blocchi,ORBOTT_AUTOTEST_BLOCCHI_ATTESI);
     }
   if(casi!=ORBOTT_AUTOTEST_CASI_ATTESI)
     {
      falliti++;
      PrintFormat("ORB AUTOTEST: dichiarati %d casi ma ne erano attesi %d: un blocco e' stato SVUOTATO. Autotest FALLITO.",
                  casi,ORBOTT_AUTOTEST_CASI_ATTESI);
     }

   PrintFormat("ORB AUTOTEST: %d blocchi su %d passati, %d casi dichiarati, %d falliti. %s",
               blocchi-falliti,blocchi,casi,falliti,
               (falliti==0 ? "Nucleo di selezione hedge-safe VERIFICATO a tavolino (NON sostituisce la prova in campo)."
                           : "ATTENZIONE: il nucleo di selezione NON e' quello atteso. NON mettere in forward."));
  }

//==================================================================
//  FILTRO NOTIZIE (CSV in MQL5/Files)
//==================================================================
void LoadNews()
  {
   gNewsCount=0; ArrayResize(gNewsTime,0); ArrayResize(gNewsImpact,0); ArrayResize(gNewsCcy,0);
   int h=FileOpen(InpNewsFile,FILE_READ|FILE_CSV|FILE_ANSI,';');
   if(h==INVALID_HANDLE){ Log("file news non trovato: filtro spento."); return; }
   while(!FileIsEnding(h))
     {
      string sTime=FileReadString(h);
      if(FileIsLineEnding(h)&&StringLen(sTime)==0) continue;
      string sImp=FileIsLineEnding(h)?"":FileReadString(h);
      string sCcy=FileIsLineEnding(h)?"":FileReadString(h);
      while(!FileIsLineEnding(h)&&!FileIsEnding(h)) FileReadString(h);
      datetime t=StringToTime(sTime);
      if(t<=0) continue;
      t+=InpNewsShiftMinutes*60;
      int imp=ImpactToInt(sImp);
      int n=gNewsCount;
      ArrayResize(gNewsTime,n+1); ArrayResize(gNewsImpact,n+1); ArrayResize(gNewsCcy,n+1);
      gNewsTime[n]=t; gNewsImpact[n]=imp; gNewsCcy[n]=sCcy; gNewsCount=n+1;
     }
   FileClose(h);
   Log(StringFormat("news caricate: %d.",gNewsCount));
  }

int ImpactToInt(string s)
  {
   string u=s; StringToUpper(u); StringTrimLeft(u); StringTrimRight(u);
   if(StringFind(u,"HIGH")>=0||u=="3") return(3);
   if(StringFind(u,"MED") >=0||u=="2") return(2);
   if(StringFind(u,"LOW") >=0||u=="1") return(1);
   return(0);
  }

bool InNewsBlackout(datetime now)
  {
   if(!InpUseNewsFilter||gNewsCount==0) return(false);
   bool filt=(StringLen(InpNewsCurrencies)>0);
   for(int i=0;i<gNewsCount;i++)
     {
      if(gNewsImpact[i]<InpNewsMinImpact) continue;
      if(filt && StringFind(InpNewsCurrencies,gNewsCcy[i])<0) continue;
      if(now>=gNewsTime[i]-InpNewsBeforeMin*60 && now<=gNewsTime[i]+InpNewsAfterMin*60) return(true);
     }
   return(false);
  }
//+------------------------------------------------------------------+

//==================================================================//
//  OPTFRAME (inlined, self-contained) - export automatico dei      //
//  risultati di OTTIMIZZAZIONE in CSV.  NON richiede include.       //
//  Scrive MQL5\Files\OptResults_<EA>_<Symbol>.csv, leggibile da:    //
//      python optimizer/batch_analyze.py <cartella>                 //
//  In live/backtest singolo e inerte (gira solo in ottimizzazione).//
//==================================================================//
#define OPTFRAME_NAME "OptFrame"
#define OPTFRAME_ID   1

string OptFrame_FileName()
  {
   return StringFormat("OptResults_%s_%s.csv", MQLInfoString(MQL_PROGRAM_NAME), _Symbol);
  }

//+------------------------------------------------------------------+
//| EXPORT PER-TRADE (09/08/2026) - serve al DD di PORTAFOGLIO.       |
//| A fine test scrive nella cartella COMUNE (Files comuni) un CSV    |
//| con una riga per ogni trade CHIUSO (ora di chiusura e netto):     |
//| con le serie di piu' EA si calcolano DD combinato e Monte Carlo   |
//| (backtest_pipeline/dd_portafoglio.py). Solo tester. In            |
//| ottimizzazione ogni pass sovrascrive il file del proprio magic:   |
//| usarlo su run singoli / magic-sweep, non sulle griglie larghe.    |
//+------------------------------------------------------------------+
void ExportTrades()
  {
   if(!HistorySelect(0,TimeCurrent())) return;
   string fn="abtg_trades_"+MQLInfoString(MQL_PROGRAM_NAME)+"_"+_Symbol+"_"+IntegerToString((long)InpMagic)+".csv";
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
double OnTester()
  {
   ExportTrades();   // per-trade per il DD di portafoglio (ROTTA_PROP punto 4)
   double stats[7];
   stats[0] = TesterStatistics(STAT_PROFIT);
   stats[1] = TesterStatistics(STAT_EXPECTED_PAYOFF);
   stats[2] = TesterStatistics(STAT_PROFIT_FACTOR);
   stats[3] = TesterStatistics(STAT_RECOVERY_FACTOR);
   stats[4] = TesterStatistics(STAT_SHARPE_RATIO);
   stats[5] = TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   stats[6] = TesterStatistics(STAT_TRADES);
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
         string head = "Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,Equity DD %,Trades";
         for(uint i = 0; i < pcount; i++)
           { string kv[]; if(StringSplit(params[i], '=', kv) == 2) head += "," + kv[0]; }
         FileWrite(h, head); header_scritto = true;
        }
      string row = StringFormat("%d,%.2f,%.5f,%.5f,%.5f,%.5f,%.4f,%.0f",
                                (int)pass, data[0], data[1], data[2], data[3], data[4], data[5], data[6]);
      for(uint i = 0; i < pcount; i++)
        { string kv[]; if(StringSplit(params[i], '=', kv) == 2) row += "," + kv[1]; }
      FileWrite(h, row); righe++;
     }
   FileClose(h);
   PrintFormat("OptFrame: scritte %d passate in MQL5\\Files\\%s", righe, fname);
  }
//================== fine OPTFRAME inlined ==========================//
