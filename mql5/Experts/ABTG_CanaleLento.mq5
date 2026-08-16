//+------------------------------------------------------------------+
//|                                          ABTG_CanaleLento.mq5    |
//|                                                                  |
//|  CANALE LENTO SIMMETRICO - MT5 - TUTTO-IN-UNO                    |
//|  (metti in MQL5\Experts e compila con F7: niente cartelle,       |
//|   l'unico #include e' la libreria standard Trade.mqh)            |
//+------------------------------------------------------------------+
//|                                                                  |
//|  ============  ATTRIBUZIONE (par.9 del cacciatore)  ============ |
//|                                                                  |
//|  TITOLO ORIGINALE  "Simple Yet Effective Breakout Strategy"      |
//|                    file sorgente: BreakoutStrategy.mq5           |
//|  AUTORE            Anh Quan Duong ("QuanDuong";                  |
//|                    intestazione del sorgente: "QuanAlpha")       |
//|  URL               https://www.mql5.com/en/code/49272            |
//|                    download: /en/code/download/49272/            |
//|                              breakoutstrategy.mq5                |
//|  DATA              17/04/2024 (datePublished 2024-04-17T12:12:06)|
//|  DIMENSIONE        291 righe, 13 input dichiarati di cui 3       |
//|                    stringhe decorative + 1 nome bot -> 6-7       |
//|                    manopole vere                                 |
//|  LICENZA           [INCERTO] - il sorgente porta soltanto        |
//|                    #property copyright "Copyright 2024,          |
//|                    QuanAlpha" e NON dichiara nessuna licenza.    |
//|                    Pubblicato sul Code Base MQL5, che ne         |
//|                    consente il download pubblico. Uso interno    |
//|                    di ricerca; l'attribuzione resta qui.         |
//|                                                                  |
//|  ============  COSA ABBIAMO CAMBIATO  ============               |
//|                                                                  |
//|  Le 8 correzioni del dossier                                     |
//|  backtest_pipeline/caccia_strategie/CACCIA_2026-08-16_E_CROLLO.md|
//|  par.5.F, piu' 5 difetti trovati da noi rileggendo il sorgente   |
//|  (marcati NUOVO qui sotto). Ogni punto e' ripetuto nel codice,   |
//|  sul posto, con il PERCHE'.                                      |
//|                                                                  |
//|   1. OnTester + OPTFRAME + ExportTrades + PrintFunnel: assenti   |
//|      nell'originale. Senza `double OnTester(`,                   |
//|      walkforward_generico.ps1 (righe 143-147) si RIFIUTA di      |
//|      partire. Modello di casa: ABTG_BreakingBand.mq5.            |
//|   2. BUG DI UNITA': l'originale confronta una DIFFERENZA DI      |
//|      PREZZO con SYMBOL_TRADE_STOPS_LEVEL, che e' un intero in    |
//|      PUNTI (righe 119, 132, 255, 269 dell'originale). Qui        |
//|      sempre `* _Point`. Su forex con stops_level > 0             |
//|      l'originale non avrebbe MAI aperto (0.0015 >= 10 e' falso); |
//|      su oro e indici passava per caso.                           |
//|   3. SIZING DISONESTO: l'originale, se il lotto calcolato sta    |
//|      SOTTO il minimo del broker, apre lo stesso al minimo        |
//|      (`if(lots < minlot) lots = minlot;` + `return MathMax(lots, |
//|      VOLUME_MIN)`), rischiando piu' del dichiarato. Qui: se non  |
//|      ci sta, NON si opera.                                       |
//|   4. SPREAD: nessun controllo nell'originale. Aggiunto           |
//|      InpMaxSpreadPctSL - spread come PERCENTUALE dello stop,     |
//|      mai in punti (lezione R55).                                 |
//|   5. INPUT DECORATIVI: via le 3 stringhe aa/bb/cc e BOT_NAME;    |
//|      via anche la sintassi non standard `string input aa`        |
//|      (qui `input` viene sempre PRIMA del tipo - e' anche cio'    |
//|      che il driver sa leggere).                                  |
//|   6. OrderManaging() dell'originale non incrementa mai `orders`: |
//|      restituisce sempre 0, valore assegnato e mai usato (codice  |
//|      morto, righe 148/160). Qui restituisce gli ordini           |
//|      DAVVERO cancellati e il numero finisce nel funnel.          |
//|   7. CalculateLotSize dell'originale calcola sempre lo SL SOTTO  |
//|      il prezzo (`sl_price = price - sl_value`) anche per lo      |
//|      short; il numero usciva giusto solo grazie a MathAbs(loss). |
//|      Qui la funzione prende il verso e i due prezzi veri.        |
//|   8. MAGIC: da EXPERT_MAGIC = 1 (indistinguibile da qualunque    |
//|      cosa) a 774301, verificato vergine contro tutti gli EA del  |
//|      repo. Piu' InpComment riconoscibile sugli ordini.           |
//|                                                                  |
//|   NUOVO A. PREZZI NON NORMALIZZATI. La mediana del canale        |
//|      (HH+LL)/2 puo' cadere a META' TICK: come SL il broker la    |
//|      rifiuta. E InpExitMiddle=1 e' dentro lo sweep, quindi il    |
//|      caso e' quello NORMALE, non un caso limite. Tutti i prezzi  |
//|      passano da NormalizzaPrezzo() (arrotondamento al            |
//|      SYMBOL_TRADE_TICK_SIZE, non solo a _Digits).                |
//|   NUOVO B. STORICO INSUFFICIENTE. iHighest/iLowest restituiscono |
//|      -1 quando le barre non bastano, e iHigh(...,-1) vale 0.0:   |
//|      l'originale avrebbe piazzato un ordine a "0 + un tick".     |
//|      Qui c'e' un cancello sulle barre disponibili e un controllo |
//|      di validita' su ogni livello di canale.                     |
//|   NUOVO C. HANDLE ATR IN PERDITA. L'originale chiama iATR()      |
//|      DENTRO la funzione ATR(), a ogni chiamata, senza mai        |
//|      IndicatorRelease. Qui l'handle si crea una volta in OnInit  |
//|      e si rilascia in OnDeinit.                                  |
//|   NUOVO D. LOTTO SPEZZATO IN PIU' ORDINI. L'originale, se il     |
//|      lotto supera SYMBOL_VOLUME_MAX, invia N ordini stop in un   |
//|      `while`: su conto HEDGING diventano N posizioni distinte e  |
//|      salta l'invariante "una posizione per lato" (e il ciclo     |
//|      sarebbe infinito se max_volume valesse 0). Nell'originale   |
//|      `maxlot` era peraltro letto e mai usato. Qui il lotto e'    |
//|      TAGLIATO a VOLUME_MAX: un ordine solo, per lato.            |
//|   NUOVO E. ORDER_TIME_DAY NON SUPPORTATO. Se il simbolo non      |
//|      espone SYMBOL_EXPIRATION_DAY l'ordine viene rifiutato e     |
//|      l'EA non opererebbe MAI, in silenzio. Qui si ripiega su     |
//|      ORDER_TIME_GTC, che qui e' equivalente perche' i pendenti   |
//|      vengono comunque cancellati a ogni nuova barra.             |
//|                                                                  |
//|  ============  COSA NON ABBIAMO CAMBIATO, DI PROPOSITO  ====     |
//|                                                                  |
//|  [VIETATO] NESSUN TAKE PROFIT. E' LA TESI, non una dimenticanza. |
//|     La skewness positiva del trend following e' strutturale      |
//|     (Sepp & Lucic, arXiv 2607.19497): il guadagno STA nella coda |
//|     destra. Chi mette un TP compra un motore diverso - e' il     |
//|     motivo per cui TurtleTrader (TP = 1 ATR) e' stato scartato.  |
//|  [VIETATO] NESSUN parziale a 1R, NESSUN breakeven, NESSUN runner |
//|     a 2R. E' la nostra grammatica delle sedie DAX/Dow ed e'      |
//|     l'UNICO punto del progetto in cui l'esperienza di casa e' la |
//|     cosa SBAGLIATA da applicare: taglierebbe la coda destra,     |
//|     cioe' l'unica fonte di guadagno di questo motore. Se un      |
//|     giorno la si vuole misurare, si misura come ASSE SEPARATO E  |
//|     DICHIARATO, mai come default.                                |
//|  [VIETATO] NESSUN InpAllowLong / InpAllowShort. La simmetria e'  |
//|     VINCOLATA DALLA MECCANICA: il lato lo decide quale bordo si  |
//|     rompe. Non c'e' un lato da spegnere sull'IS, che e' la       |
//|     malattia documentata in R52 (4 titolari su 5 con un lato     |
//|     SCELTO su 21 mesi di mercato in salita).                     |
//|  [VIETATO] NESSUN tetto alla durata (InpMaxBarsHold): un tetto   |
//|     sulla durata taglia la coda, cioe' la sola cosa che questo   |
//|     motore produce.                                              |
//|  [VIETATO] InpTF NON e' una manopola libera: default D1. Kurth,  |
//|     Eisler, Rej & Bouchaud (CFM, arXiv 2607.01550), ~100 futures |
//|     1995-2025: post-2008 l'ordine si ribalta e sopravvive solo il|
//|     ramo LENTO (Sharpe 0,40 a 50 giorni contro 0,12 a 5). Un     |
//|     canale a 55 barre su H4 sono 9 giorni: il ramo morto.        |
//|                                                                  |
//|  ============  MAPPA REGOLA -> CODICE  ============              |
//|                                                                  |
//|   INGRESSO  ordine STOP (BuyStop/SellStop) a un tick sopra il    |
//|             massimo / sotto il minimo delle ultime               |
//|             InpEntryPeriod barre CHIUSE (shift 1), ripiazzato    |
//|             a ogni nuova barra.            -> PiazzaOrdini()     |
//|   STOP      il bordo OPPOSTO del canale d'uscita (o la sua       |
//|             mediana se InpExitMiddle): un punto del grafico,     |
//|             non un numero di punti.        -> LivelliUscita()    |
//|   USCITA    nessun take profit. Trailing sul canale che si       |
//|             stringe barra dopo barra, o chiusura a mercato se    |
//|             il prezzo lo attraversa.       -> GestisciPosizioni()|
//|   RISCHIO   percentuale dell'equity, ancorata allo SL vero.      |
//|                                            -> CalcolaLotto()     |
//|   FREQUENZA una decisione per barra chiusa (NuovaBarra):         |
//|             niente repaint, niente look-ahead.                   |
//|                                                                  |
//|  ============  CONTO HEDGING  ============                       |
//|                                                                  |
//|  Il conto BCM 50503392 e' HEDGING. Verificato riga per riga:     |
//|  questo EA NON ha il problema di TurtleTrader (che restituiva    |
//|  INIT_FAILED sui conti hedging). Tutta la contabilita' qui e'    |
//|  scritta in semantica a TICKET - PositionGetTicket /             |
//|  PositionSelectByTicket / PositionClose(ticket) /                |
//|  PositionModify(ticket,...) - che e' esattamente la semantica    |
//|  giusta per l'hedging. Non c'e' nessun PositionSelect(_Symbol)   |
//|  ne' nessun conteggio netto. Nessun controllo su                 |
//|  ACCOUNT_MARGIN_MODE, quindi nessun INIT_FAILED possibile.       |
//|  [!] RESIDUO DICHIARATO: long e short sono contati               |
//|  SEPARATAMENTE, quindi su conto hedging l'EA puo' in teoria      |
//|  tenere una posizione long E una short insieme (se il prezzo     |
//|  attraversa entrambi i bordi del canale d'ingresso prima che il  |
//|  trailing chiuda la prima). E' il comportamento dell'originale   |
//|  e NON e' stato toccato: cambiarlo sarebbe una modifica alla     |
//|  meccanica, non una correzione. In pratica lo stop del primo     |
//|  lato (bordo del canale d'USCITA, piu' stretto) si trova prima   |
//|  del trigger opposto (bordo del canale d'INGRESSO, piu' largo)   |
//|  ogni volta che InpExitPeriod <= InpEntryPeriod, che e' vero in  |
//|  tutte le 20 celle dello sweep.                                  |
//+------------------------------------------------------------------+
#property copyright "Adozione ABTG - originale: Copyright 2024, QuanAlpha"
#property link      "https://www.mql5.com/en/code/49272"
#property version   "1.00"
#property strict
#property description "Canale di Donchian su barre CHIUSE, ordine stop al livello,"
#property description "stop sul bordo opposto del canale, NESSUN take profit."
#property description "Adozione di BreakoutStrategy.mq5 di Anh Quan Duong (2024)."

#include <Trade/Trade.mqh>

//==================================================================
//  COSTANTI NON NEGOZIABILI (non sono manopole: non si spazzolano)
//==================================================================
//--- periodo dell'ATR usato SOLO come isteresi del trailing (per non
//    mandare una PositionModify a ogni frazione di tick). Nell'originale
//    era il letterale 20 dentro PositionManaging: qui almeno ha un nome.
#define ABTG_CL_ATR_PERIODO 20

//==================================================================
//  INPUT
//  [!] `input` viene SEMPRE prima del tipo (correzione 5): e' la
//     sintassi standard ed e' l'unica che walkforward_generico.ps1
//     sa leggere. I nomi qui sotto devono COMBACIARE, lettera per
//     lettera, con backtest_pipeline/prove/ABTG_CanaleLento.txt:
//     un nome che l'EA non ha, MT5 lo ignora IN SILENZIO.
//==================================================================
input group "=== Timeframe (CONGELATO: e' la tesi, non una manopola) ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_D1;        // TF operativo (D1 = 16408)

input group "=== INGRESSO: il canale che si rompe ==="
input int    InpEntryPeriod    = 55;            // barre del canale d'ingresso
input int    InpEntryShift     = 1;             // shift: 1 = SOLO barre chiuse (non toccare)

input group "=== USCITA: il canale che stringe (nessun take profit) ==="
input int    InpExitPeriod     = 20;            // barre del canale d'uscita
input int    InpExitShift      = 1;             // shift: 1 = SOLO barre chiuse (non toccare)
input bool   InpExitMiddle     = true;          // true = trailing sulla MEDIANA, false = bordo opposto

input group "=== Rischio ==="
input double InpRiskPercent    = 1.0;           // rischio per operazione, % dell'EQUITY
input double InpMaxSpreadPctSL = 10.0;          // spread massimo, % della distanza di stop

input group "=== Generali ==="
input long   InpMagic          = 774301;        // magic VERGINE (verificato contro il repo)
input string InpComment        = "CanaleLento"; // commento ordini
input int    InpSlippage       = 10;            // deviazione massima, in punti
input bool   InpVerbose        = false;         // log dettagliato nel journal

//==================================================================
//  GLOBALI
//==================================================================
CTrade   gTrade;
int      gHandleAtr = INVALID_HANDLE;
datetime gUltimaBarra = 0;
ENUM_ORDER_TYPE_TIME gTipoScadenza = ORDER_TIME_DAY;   // vedi NUOVO E

//--- METRICHE DA PROP (schema di famiglia, identico ad ABTG_BreakingBand):
//    l'Equity DD dice se il conto sopravvive; una prop invece chiude per il
//    LIMITE GIORNALIERO, che e' un'altra cosa. Qui si segue l'equity dentro
//    la giornata e si tiene la caduta peggiore rispetto all'apertura del giorno.
double gDayStartEquity = 0.0;
double gDayMinEquity   = 0.0;
double gWorstDayPct    = 0.0;   // numero NEGATIVO
int    gDayEqStamp     = -1;

//--- FUNNEL DI MORTALITA': dove muore la cascata. Con poche decine di
//    operazioni in sei anni (D1, canale a 55 barre) un CSV vuoto e un CSV
//    "il motore non ha mai potuto sparare" si assomigliano troppo: questi
//    contatori sono l'unico modo per distinguerli senza rilanciare.
int   cBarre      = 0;   // barre valutate
int   cNoStorico  = 0;   // barre saltate: storico insufficiente
ulong cNoCanale   = 0;   // barre saltate: canale non calcolabile
int   cOrdiniCanc = 0;   // pendenti cancellati (correzione 6: valore VERO)
int   cLongTent   = 0, cShortTent  = 0;   // lato libero: si poteva provare
int   cLongRotto  = 0, cShortRotto = 0;   // scartati: rottura gia' avvenuta / troppo vicina
int   cLongStopKO = 0, cShortStopKO= 0;   // scartati: stop nullo o sotto lo stops level
int   cLongSpread = 0, cShortSpread= 0;   // scartati: spread > % dello stop
int   cLongLotto  = 0, cShortLotto = 0;   // scartati: rischio sotto il lotto minimo
int   cLongInvio  = 0, cShortInvio = 0;   // invio fallito (retcode)
int   cLongOk     = 0, cShortOk    = 0;   // ordini stop piazzati
int   cChiusure   = 0;   // posizioni chiuse a mercato dal trailing
int   cModifiche  = 0;   // trailing: SL spostati a favore
int   cModificaKO = 0;   // trailing: PositionModify fallita (retcode)

void Log(string m) { if(InpVerbose) Print("[CL] ", m); }

//==================================================================
//  INIT / DEINIT
//==================================================================
int OnInit()
  {
   //--- coerenza degli input: meglio un INIT_FAILED subito che una notte
   //    di macchina su una cella che non poteva funzionare.
   if(InpEntryPeriod < 2 || InpExitPeriod < 2)
     { Print("[CL] ERRORE: InpEntryPeriod e InpExitPeriod devono essere >= 2."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpEntryShift < 1 || InpExitShift < 1)
     { Print("[CL] ERRORE: gli shift devono essere >= 1 (si decide su BARRE CHIUSE)."); return(INIT_PARAMETERS_INCORRECT); }
   if(InpRiskPercent <= 0.0)
     { Print("[CL] ERRORE: InpRiskPercent deve essere > 0."); return(INIT_PARAMETERS_INCORRECT); }

   //--- NUOVO C: l'handle dell'ATR si crea UNA volta qui, non a ogni
   //    chiamata dentro la funzione come faceva l'originale.
   gHandleAtr = iATR(_Symbol, InpTF, ABTG_CL_ATR_PERIODO);
   if(gHandleAtr == INVALID_HANDLE)
     { Print("[CL] ERRORE: iATR non disponibile (err ", GetLastError(), ")."); return(INIT_FAILED); }

   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(InpSlippage);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.LogLevel(InpVerbose ? LOG_LEVEL_ALL : LOG_LEVEL_ERRORS);

   //--- NUOVO E: se il simbolo non supporta la scadenza "a fine giornata",
   //    l'ordine verrebbe RIFIUTATO e l'EA non opererebbe mai, in silenzio.
   //    Il ripiego GTC e' equivalente perche' i pendenti vengono comunque
   //    cancellati e ripiazzati a ogni nuova barra.
   long modi = SymbolInfoInteger(_Symbol, SYMBOL_EXPIRATION_MODE);
   gTipoScadenza = ((modi & SYMBOL_EXPIRATION_DAY) != 0) ? ORDER_TIME_DAY : ORDER_TIME_GTC;
   if(gTipoScadenza == ORDER_TIME_GTC)
      Print("[CL] AVVISO: il simbolo non espone SYMBOL_EXPIRATION_DAY -> pendenti in GTC (cancellati a ogni barra).");

   gUltimaBarra = 0;

   PrintFormat("[CL] ABTG_CanaleLento avviato. %s %s  canale %d/%d  mediana=%s  rischio=%.2f%%  magic=%d",
               _Symbol, EnumToString(InpTF), InpEntryPeriod, InpExitPeriod,
               (InpExitMiddle ? "SI" : "NO"), InpRiskPercent, (int)InpMagic);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   //--- gli handle si rilasciano SEMPRE qui (l'originale non lo faceva mai).
   if(gHandleAtr != INVALID_HANDLE) { IndicatorRelease(gHandleAtr); gHandleAtr = INVALID_HANDLE; }
   Log(StringFormat("uscita, codice %d", reason));
  }

//==================================================================
//  UTILITA' DI PREZZO E DI CANALE
//==================================================================

//--- NUOVO A: la mediana del canale (HH+LL)/2 puo' cadere a META' TICK.
//    Come SL o come prezzo d'ingresso il broker la rifiuta (invalid stops /
//    invalid price). E InpExitMiddle=1 e' dentro lo sweep: questo e' il caso
//    NORMALE, non un caso limite. Si arrotonda al TICK, non solo ai decimali.
double NormalizzaPrezzo(double prezzo)
  {
   double tick = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tick <= 0.0) tick = _Point;
   if(tick <= 0.0) return(NormalizeDouble(prezzo, _Digits));
   return(NormalizeDouble(MathRound(prezzo / tick) * tick, _Digits));
  }

//--- distanza minima imposta dal broker, IN PREZZO.
//    [!] CORREZIONE 2 - IL BUG DI UNITA'. SYMBOL_TRADE_STOPS_LEVEL e' un
//    intero in PUNTI: l'originale lo confrontava direttamente con una
//    differenza di prezzo (righe 119, 132, 255, 269). Su forex con
//    stops_level > 0 la condizione era sempre falsa (0.0015 >= 10) e l'EA
//    non avrebbe MAI aperto; su oro e indici passava soltanto per caso,
//    perche' le differenze di prezzo sono numeri grandi. Stesso errore di
//    NDTP() in Mean_Reversion di Tzadik.
double DistanzaMinima()
  {
   long punti = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   if(punti < 0) punti = 0;
   return((double)punti * _Point);
  }

//--- NUOVO B: iHighest/iLowest restituiscono -1 quando le barre non
//    bastano, e iHigh(_Symbol,tf,-1) vale 0.0. L'originale, con storico
//    corto, avrebbe piazzato un BuyStop a "0 + un tick". Qui il canale
//    o e' valido o non si opera, e la barra finisce nel funnel.
bool Canale(int periodo, int shift, double &hh, double &ll)
  {
   hh = 0.0; ll = 0.0;
   int ih = iHighest(_Symbol, InpTF, MODE_HIGH, periodo, shift);
   int il = iLowest (_Symbol, InpTF, MODE_LOW,  periodo, shift);
   if(ih < 0 || il < 0) return(false);
   hh = iHigh(_Symbol, InpTF, ih);
   ll = iLow (_Symbol, InpTF, il);
   if(hh <= 0.0 || ll <= 0.0 || hh < ll) return(false);
   return(true);
  }

//--- I DUE LIVELLI DI USCITA, cioe' LO STOP STRUTTURALE.
//    Non e' un numero di punti da ottimizzare: e' un punto del grafico.
//    InpExitMiddle=true -> mediana del canale d'uscita (piu' stretta: taglia
//    prima la coda, ed e' l'unico modo onesto di misurare quanto costa
//    stringere). InpExitMiddle=false -> bordo opposto del canale.
bool LivelliUscita(double &usc_long, double &usc_short)
  {
   double hh, ll;
   usc_long = 0.0; usc_short = 0.0;
   if(!Canale(InpExitPeriod, InpExitShift, hh, ll)) return(false);
   usc_long  = ll;    // stop di un LONG  = minimo del canale d'uscita
   usc_short = hh;    // stop di uno SHORT = massimo del canale d'uscita
   if(InpExitMiddle)
     {
      double mediana = (hh + ll) / 2.0;
      //--- MathMax/MathMin come nell'originale: la mediana non puo' rendere
      //    lo stop PIU' LARGO del bordo, solo piu' stretto.
      usc_long  = MathMax(mediana, usc_long);
      usc_short = MathMin(mediana, usc_short);
     }
   usc_long  = NormalizzaPrezzo(usc_long);
   usc_short = NormalizzaPrezzo(usc_short);
   return(true);
  }

//--- ATR di isteresi. Se non e' disponibile si torna 0: l'isteresi sparisce
//    ma la condizione di monotonia (lo SL si muove SOLO a favore) resta.
double AtrIsteresi()
  {
   double v[];
   if(gHandleAtr == INVALID_HANDLE) return(0.0);
   if(CopyBuffer(gHandleAtr, 0, InpExitShift, 1, v) < 1) return(0.0);
   if(v[0] <= 0.0 || !MathIsValidNumber(v[0])) return(0.0);
   return(v[0]);
  }

//==================================================================
//  SIZING - rischio in % dell'EQUITY, ancorato allo STOP VERO
//==================================================================
//  [!] CORREZIONE 3 - SIZING DISONESTO. L'originale faceva
//        if(lots < minlot) lots = minlot;
//     e chiudeva con
//        return MathMax(lots, SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));
//     cioe': se il rischio calcolato non arrivava al lotto minimo, apriva
//     LO STESSO al minimo, rischiando piu' del dichiarato - e proprio nei
//     casi peggiori (stop largo = canale largo = mercato agitato).
//     Qui: SE NON CI STA, NON SI OPERA. Il caso finisce nel funnel.
//
//  [!] CORREZIONE 7 - SIMMETRIA. L'originale calcolava sempre
//        sl_price = price - sl_value
//     anche per lo short (stop SOTTO il prezzo invece che sopra): il numero
//     usciva giusto solo grazie a MathAbs(loss). Qui la funzione prende il
//     verso e i due prezzi VERI, e il conto e' leggibile.
//
//  [!] NUOVO D - niente lotto spezzato in piu' ordini: si taglia a
//     VOLUME_MAX. Nell'originale `maxlot` era letto e mai usato, e lo
//     spezzettamento in un `while` produceva N posizioni su conto hedging.
//==================================================================
double CalcolaLotto(bool isLong, double prezzo_ingresso, double prezzo_stop)
  {
   double perdita_per_lotto = 0.0;
   ENUM_ORDER_TYPE tipo = isLong ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;

   if(!OrderCalcProfit(tipo, _Symbol, 1.0, prezzo_ingresso, prezzo_stop, perdita_per_lotto))
     { Log("OrderCalcProfit fallita, err " + IntegerToString(GetLastError())); return(0.0); }
   perdita_per_lotto = MathAbs(perdita_per_lotto);
   if(perdita_per_lotto <= 0.0) return(0.0);

   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   if(equity <= 0.0) return(0.0);
   //--- InpRiskPercent e' in PERCENTO (1.0 = 1%), non la frazione 0.01
   //    dell'originale: cosi' e' confrontabile con tutto l'archivio.
   double denaro_a_rischio = equity * InpRiskPercent / 100.0;

   double passo   = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double minimo  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double massimo = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(passo <= 0.0) passo = 0.01;

   //--- MathFloor, mai MathRound: si arrotonda SEMPRE verso il basso.
   double lotti = MathFloor((denaro_a_rischio / perdita_per_lotto) / passo) * passo;

   if(lotti < minimo - 1e-9) return(0.0);          // CORREZIONE 3
   if(massimo > 0.0 && lotti > massimo) lotti = massimo;   // NUOVO D

   //--- margine: se non basta si riduce, e se ridotto non arriva al minimo
   //    NON si opera (mai "apri comunque").
   double margine = 0.0;
   if(OrderCalcMargin(tipo, _Symbol, lotti, prezzo_ingresso, margine))
     {
      double libero = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
      if(libero <= 0.0) return(0.0);
      if(margine > libero)
        {
         lotti = MathFloor((lotti * libero / margine * 0.95) / passo) * passo;
         if(lotti < minimo - 1e-9) return(0.0);
        }
     }

   //--- decimali del volume dedotti dal passo del broker (0.01 -> 2 cifre).
   int cifre = 0; double s = passo;
   while(s < 1.0 - 1e-9 && cifre < 8) { s *= 10.0; cifre++; }
   return(NormalizeDouble(lotti, cifre));
  }

//==================================================================
//  GESTIONE DEI PENDENTI
//  Gli ordini stop si cancellano e si ripiazzano a OGNI nuova barra:
//  il canale si e' mosso, quindi il livello di rottura non e' piu'
//  quello. E' la meccanica dell'originale, tenuta tale e quale.
//
//  [!] CORREZIONE 6. Nell'originale la variabile `orders` non veniva MAI
//     incrementata: la funzione restituiva sempre 0 e il valore veniva
//     assegnato in ExecuteTrade e mai usato (codice morto, righe 148/160).
//     Qui torna il numero di pendenti DAVVERO cancellati e finisce nel
//     funnel, dove serve a distinguere "non ho mai piazzato niente" da
//     "piazzo e cancello a vuoto tutti i giorni".
//==================================================================
int CancellaPendenti()
  {
   int cancellati = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong ticket = OrderGetTicket(i);
      if(ticket == 0) continue;
      if(!OrderSelect(ticket)) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
      if(OrderGetInteger(ORDER_MAGIC) != InpMagic) continue;
      if(gTrade.OrderDelete(ticket)) cancellati++;
      else Log(StringFormat("OrderDelete #%s fallita, retcode %d", IntegerToString((long)ticket), gTrade.ResultRetcode()));
     }
   return(cancellati);
  }

//==================================================================
//  GESTIONE DELLE POSIZIONI - trailing di canale, NESSUN TAKE PROFIT
//
//  Restituisce quante posizioni di quel lato restano aperte: e' il
//  contatore che vincola "una posizione per lato".
//
//  [!] Conteggio per SIMBOLO + MAGIC + TIPO, e selezione per TICKET.
//     E' il pregio dell'originale (il difetto n.1 di MeanReversion di
//     Yashar, che usava PositionsTotal() di conto, qui non c'e') ed e'
//     anche cio' che rende l'EA corretto su conto HEDGING.
//==================================================================
int GestisciPosizioni(ENUM_POSITION_TYPE tipo_posizione, double trail_long, double trail_short)
  {
   int aperte = 0;
   double atr     = AtrIsteresi();
   double dist_min = DistanzaMinima();

   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      if(PositionGetInteger(POSITION_TYPE) != tipo_posizione) continue;

      aperte++;
      double sl = PositionGetDouble(POSITION_SL);
      double cp = PositionGetDouble(POSITION_PRICE_CURRENT);

      if(tipo_posizione == POSITION_TYPE_BUY)
        {
         //--- il prezzo ha attraversato il canale: si esce a mercato.
         if(cp < trail_long)
           {
            if(gTrade.PositionClose(ticket)) { aperte--; cChiusure++; }
            else Log(StringFormat("PositionClose #%s fallita, retcode %d", IntegerToString((long)ticket), gTrade.ResultRetcode()));
           }
         //--- il canale si e' alzato: lo stop lo segue. SOLO a favore, e
         //    solo se il guadagno supera l'isteresi (0.1 ATR) - altrimenti
         //    si manderebbe una PositionModify per ogni frazione di tick.
         //    [!] CORREZIONE 2 applicata qui: `dist_min`, non l'intero nudo.
         else if(trail_long > sl + 0.1 * atr && (cp - trail_long) >= dist_min)
           {
            //--- NESSUN take profit: il terzo argomento e' 0.0 e resta 0.0.
            if(gTrade.PositionModify(ticket, NormalizzaPrezzo(trail_long), 0.0)) cModifiche++;
            else { cModificaKO++; Log(StringFormat("PositionModify #%s fallita, retcode %d", IntegerToString((long)ticket), gTrade.ResultRetcode())); }
           }
        }
      else if(tipo_posizione == POSITION_TYPE_SELL)
        {
         if(cp > trail_short)
           {
            if(gTrade.PositionClose(ticket)) { aperte--; cChiusure++; }
            else Log(StringFormat("PositionClose #%s fallita, retcode %d", IntegerToString((long)ticket), gTrade.ResultRetcode()));
           }
         else if(trail_short < sl - 0.1 * atr && (trail_short - cp) >= dist_min)
           {
            if(gTrade.PositionModify(ticket, NormalizzaPrezzo(trail_short), 0.0)) cModifiche++;
            else { cModificaKO++; Log(StringFormat("PositionModify #%s fallita, retcode %d", IntegerToString((long)ticket), gTrade.ResultRetcode())); }
           }
        }
     }
   return(aperte > 0 ? aperte : 0);
  }

//==================================================================
//  PIAZZAMENTO DEGLI ORDINI STOP
//
//  SIMMETRIA VINCOLATA: non c'e' nessun input che sceglie il lato.
//  Si piazzano SEMPRE entrambi gli ordini; il lato lo decide quale
//  bordo del canale il mercato rompera' per primo.
//==================================================================
void PiazzaOrdini(double ing_hh, double ing_ll, double usc_long, double usc_short,
                  int long_aperte, int short_aperte)
  {
   double bid  = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask  = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double tick = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tick <= 0.0) tick = _Point;
   double dist_min = DistanzaMinima();
   double spread   = ask - bid;
   if(bid <= 0.0 || ask <= 0.0 || spread < 0.0) return;

   //--- il trigger sta UN TICK oltre il bordo del canale su barre chiuse.
   double trigger_long  = NormalizzaPrezzo(ing_hh + tick);
   double trigger_short = NormalizzaPrezzo(ing_ll - tick);

   //--------------------------- LONG ---------------------------
   if(long_aperte == 0)
     {
      cLongTent++;
      double sl_dist = trigger_long - usc_long;
      //--- [!] CORREZIONE 2: `dist_min`, non SYMBOL_TRADE_STOPS_LEVEL nudo.
      //    Quando stops_level vale 0 la condizione torna `>= 0`, cioe' la
      //    proprieta' che vogliamo tenere dell'originale: NON si rincorre
      //    il prezzo se la rottura e' gia' avvenuta.
      if((trigger_long - ask) < dist_min)                       cLongRotto++;
      else if(sl_dist <= 0.0 || sl_dist < dist_min)             cLongStopKO++;
      //--- [!] CORREZIONE 4: spread come PERCENTUALE dello stop, mai in
      //    punti (R55). Uno stop di canale su D1 e' enorme e uno su H1 e'
      //    piccolo: una soglia in punti misurerebbe due cose diverse.
      else if(spread > InpMaxSpreadPctSL / 100.0 * sl_dist)     cLongSpread++;
      else
        {
         double lotto = CalcolaLotto(true, trigger_long, usc_long);
         if(lotto <= 0.0) cLongLotto++;   // CORREZIONE 3: non ci sta, non si opera
         else
           {
            //--- il quinto argomento e' il TAKE PROFIT: resta 0.0. E' LA TESI.
            if(gTrade.BuyStop(lotto, trigger_long, _Symbol, usc_long, 0.0,
                              gTipoScadenza, 0, InpComment + " L"))
               cLongOk++;
            else
              {
               cLongInvio++;
               Log(StringFormat("BuyStop fallito: lotto=%.2f trigger=%s sl=%s retcode=%d",
                                lotto, DoubleToString(trigger_long,_Digits),
                                DoubleToString(usc_long,_Digits), gTrade.ResultRetcode()));
              }
           }
        }
     }

   //--------------------------- SHORT --------------------------
   if(short_aperte == 0)
     {
      cShortTent++;
      double sl_dist = usc_short - trigger_short;
      if((bid - trigger_short) < dist_min)                      cShortRotto++;
      else if(sl_dist <= 0.0 || sl_dist < dist_min)             cShortStopKO++;
      else if(spread > InpMaxSpreadPctSL / 100.0 * sl_dist)     cShortSpread++;
      else
        {
         double lotto = CalcolaLotto(false, trigger_short, usc_short);
         if(lotto <= 0.0) cShortLotto++;
         else
           {
            if(gTrade.SellStop(lotto, trigger_short, _Symbol, usc_short, 0.0,
                               gTipoScadenza, 0, InpComment + " S"))
               cShortOk++;
            else
              {
               cShortInvio++;
               Log(StringFormat("SellStop fallito: lotto=%.2f trigger=%s sl=%s retcode=%d",
                                lotto, DoubleToString(trigger_short,_Digits),
                                DoubleToString(usc_short,_Digits), gTrade.ResultRetcode()));
              }
           }
        }
     }
  }

//==================================================================
//  UNA DECISIONE PER BARRA CHIUSA (niente repaint, niente look-ahead)
//==================================================================
bool NuovaBarra()
  {
   datetime t = iTime(_Symbol, InpTF, 0);
   if(t <= 0 || t == gUltimaBarra) return(false);
   gUltimaBarra = t;
   return(true);
  }

void Cicla()
  {
   cBarre++;

   //--- NUOVO B: cancello sullo storico. Sugli indici il driver diceva
   //    2024.01.01 mentre i dati partivano dal 26/09/2024: meta' finestra
   //    non esisteva. Senza questo cancello l'EA piazzerebbe ordini su
   //    livelli calcolati a 0.0.
   int servono = InpEntryPeriod + InpEntryShift;
   if(InpExitPeriod + InpExitShift          > servono) servono = InpExitPeriod + InpExitShift;
   if(ABTG_CL_ATR_PERIODO + InpExitShift    > servono) servono = ABTG_CL_ATR_PERIODO + InpExitShift;
   servono += 2;
   if(Bars(_Symbol, InpTF) < servono) { cNoStorico++; return; }

   double ing_hh, ing_ll, usc_long, usc_short;
   if(!Canale(InpEntryPeriod, InpEntryShift, ing_hh, ing_ll)) { cNoCanale++; return; }
   if(!LivelliUscita(usc_long, usc_short))                    { cNoCanale++; return; }

   //--- 1. via i pendenti della barra precedente: il canale si e' mosso.
   cOrdiniCanc += CancellaPendenti();

   //--- 2. trailing e uscite. I livelli di trailing sono gli STESSI che
   //       fanno da stop iniziale: lo stop e' un punto del grafico che si
   //       stringe da solo, non un parametro da tarare.
   double trail_long  = usc_long;
   double trail_short = usc_short;
   int long_aperte  = GestisciPosizioni(POSITION_TYPE_BUY,  trail_long, trail_short);
   int short_aperte = GestisciPosizioni(POSITION_TYPE_SELL, trail_long, trail_short);

   //--- 3. i nuovi ordini stop, su entrambi i lati.
   PiazzaOrdini(ing_hh, ing_ll, usc_long, usc_short, long_aperte, short_aperte);
  }

//==================================================================
//  ONTICK
//==================================================================
void OnTick()
  {
   //--- metrica da prop: quanto sono sceso OGGI rispetto all'apertura del
   //    giorno. Sta QUI e non dentro il filtro della nuova barra: su D1 la
   //    caduta peggiore di giornata succede in mezzo alla candela, e su
   //    questo motore la candela e' il giorno intero.
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

   //--- TUTTA la logica gira su BARRA CHIUSA.
   if(!NuovaBarra()) return;
   Cicla();
  }

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

//==================================================================
//  FUNNEL DI MORTALITA' (solo Print a fine test).
//  Su questo motore serve piu' che altrove: con poche decine di
//  operazioni in sei anni, "zero trade perche' il mercato non si e'
//  mai rotto" e "zero trade perche' il codice non poteva sparare"
//  producono lo stesso CSV vuoto. Il funnel li distingue.
//==================================================================
void PrintFunnel()
  {
   PrintFormat("[CL-FUNNEL] %s %s  canale ingresso=%d uscita=%d  mediana=%d  rischio=%.2f%%  spreadMax=%.1f%%SL",
               _Symbol, EnumToString(InpTF), InpEntryPeriod, InpExitPeriod,
               (int)InpExitMiddle, InpRiskPercent, InpMaxSpreadPctSL);
   PrintFormat("[CL-FUNNEL] BARRE  valutate=%d | saltate: storicoCorto=%d canaleNonCalcolabile=%d",
               cBarre, cNoStorico, cNoCanale);
   PrintFormat("[CL-FUNNEL] LONG   lato libero=%d | scartati: rotturaGiaAvvenuta=%d stopNullo/sottoStopsLevel=%d "
               "spread=%d lottoSottoMinimo=%d invioFallito=%d  ==> ORDINI STOP PIAZZATI=%d",
               cLongTent, cLongRotto, cLongStopKO, cLongSpread, cLongLotto, cLongInvio, cLongOk);
   PrintFormat("[CL-FUNNEL] SHORT  lato libero=%d | scartati: rotturaGiaAvvenuta=%d stopNullo/sottoStopsLevel=%d "
               "spread=%d lottoSottoMinimo=%d invioFallito=%d  ==> ORDINI STOP PIAZZATI=%d",
               cShortTent, cShortRotto, cShortStopKO, cShortSpread, cShortLotto, cShortInvio, cShortOk);
   PrintFormat("[CL-FUNNEL] GESTIONE  pendenti cancellati=%d | trailing: SL spostati=%d falliti=%d | "
               "chiusure a mercato=%d",
               cOrdiniCanc, cModifiche, cModificaKO, cChiusure);
   //--- CONTROLLO DI IDENTITA' (non e' un cancello): un trend follower senza
   //    TP deve uscire con win rate BASSO e payoff ALTO. Se esce win rate
   //    alto e payoff basso, il motore NON sta facendo trend following e il
   //    trailing lo sta strozzando: si guarda il codice, non il parametro.
   double n_tr = TesterStatistics(STAT_TRADES);
   double n_wi = TesterStatistics(STAT_PROFIT_TRADES);
   PrintFormat("[CL-FUNNEL] IDENTITA'  trade=%.0f  winRate=%.1f%% (atteso SOTTO il 40%%)  "
               "vinciteMedie=%.2f  perditeMedie=%.2f  payoff=%.2f  (n<20 => NON GIUDICABILE)",
               n_tr, (n_tr > 0 ? 100.0 * n_wi / n_tr : 0.0),
               TesterStatistics(STAT_GROSS_PROFIT) / MathMax(n_wi, 1.0),
               MathAbs(TesterStatistics(STAT_GROSS_LOSS)) / MathMax(n_tr - n_wi, 1.0),
               TesterStatistics(STAT_EXPECTED_PAYOFF));
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
