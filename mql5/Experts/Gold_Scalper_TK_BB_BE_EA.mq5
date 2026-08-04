//+------------------------------------------------------------------+
//|                                  Gold_Scalper_TK_BB_BE_EA.mq5     |
//|                                                                  |
//|  Expert Advisor per XAUUSD (ORO) - timeframe operativo M5        |
//|                                                                  |
//|  Versione MECCANIZZATA "core trend" dello stile di scalping      |
//|  manuale di un trader su oro (vedi:                              |
//|  docs/Analisi_Trading_Manuale_Scalper.md).                      |
//|                                                                  |
//|  NB IMPORTANTE: le regole d'ingresso sono una MECCANIZZAZIONE    |
//|  di uno stile DISCREZIONALE dedotto da UN SOLO giorno di trade.  |
//|  E' una prima versione backtestabile, NON una replica fedele     |
//|  garantita: tutti i default vanno TARATI con backtest su dati    |
//|  M1 di qualita' (vedi avvertenze in fondo al file).             |
//|                                                                  |
//|  DUE MODALITA' DI INGRESSO (l'una OPPURE l'altra; entrambe       |
//|  attivabili da input). Ingresso su barra M5 CHIUSA (no repaint): |
//|                                                                  |
//|   MODO A - Ichimoku multi-timeframe:                            |
//|     cross Tenkan(7)/Kijun(22) [Ichimoku Donchian] su M5,        |
//|     CONFERMATO da almeno un altro TF (InpConfirmTF) che ha la   |
//|     stessa direzione (Tenkan>Kijun per long, Tenkan<Kijun per   |
//|     short).                                                      |
//|                                                                  |
//|   MODO B - Bande di Bollinger inclinate:                        |
//|     la media di Bollinger (SMA 20) e' INCLINATA oltre soglia    |
//|     nella STESSA direzione sia su M1 sia su M5 -> entra.        |
//|                                                                  |
//|   Ingresso = (MODO A valido) OPPURE (MODO B valido).            |
//|   Una sola posizione per volta (no piramidazione in v1).        |
//|                                                                  |
//|  GESTIONE v2 (dedotta dai trade reali - tutti INPUT):          |
//|   - Stop iniziale fisso in $ (default 4.0) o ATR (opzionale).   |
//|   - Break-even che RISPETTA la distanza minima del broker       |
//|     (SYMBOL_TRADE_STOPS_LEVEL): va a pari appena la piattaforma |
//|     lo consente (entry +/- stopsLevel + buffer).                |
//|   - Chiusura parziale 50% quando il PROFITTO FLOATING in valuta |
//|     conto (POSITION_PROFIT) supera InpPartialProfitMoney (€).   |
//|   - Trailing ATR-adattivo di DEFAULT (si allarga nei trend),    |
//|     con opzione trailing fisso in $. Monotono.                  |
//|   - Momentum-fade: quando la forza del prezzo rallenta (ATR o   |
//|     larghezza Bollinger in contrazione) ed e' in profitto,      |
//|     stringe il trailing o chiude il residuo.                    |
//|   - Tutte le modifiche di SL rispettano SYMBOL_TRADE_STOPS_LEVEL|
//|     tramite un helper di "clamp" (no rifiuti del broker).       |
//|   - Nessun TP fisso sul residuo (lascia correre col trailing).  |
//|                                                                  |
//|  Stile di codice (CTrade, filling adattivo, gestione handle,   |
//|  lotto normalizzato) ripreso da Gold_Ichimoku_TK_ATR_EA.mq5.   |
//|                                                                  |
//|  ----------------------------------------------------------------|
//|  v1.20 (v3) - SELETTIVITA' e regole di SESSIONE.                |
//|  In backtest la v1.10 apriva troppi trade (1174/anno) e perdeva |
//|  su broker a spread largo. La v1.20 rende l'EA SELETTIVO: poche  |
//|  operazioni di qualita', tenute poco, con tetto di profitto      |
//|  giornaliero. Modifiche mirate (resto della logica invariato):   |
//|                                                                  |
//|   1) FILTRO DI VOLATILITA' (InpUseVolFilter, InpVolMode):       |
//|      - VOL_ATR: entra solo se ATR(InpAtrLen) su M5 >=           |
//|        InpMinAtrDollars (si opera solo a mercato in movimento). |
//|      - VOL_ADR: entra solo se il range del giorno corrente      |
//|        finora e' < InpAdrUsedMaxPct% dell'ADR (media range      |
//|        High-Low giorn. su InpAdrDays): evita gli ingressi a     |
//|        fine corsa. SOGLIE DA TARARE col backtest.               |
//|   2) USCITA A TEMPO (InpMaxBarsInTrade): "due candele e poi     |
//|      chiudiamo". Trailing/partial restano attivi DENTRO quelle  |
//|      barre. Trade-off: limita i winner lunghi.                  |
//|   3) MAX TRADE/GIORNO (InpMaxTradesPerDay): tetto agli ingressi.|
//|   4) STOP SESSIONE su P&L giorn. REALIZZATO (InpDailyProfit-    |
//|      Target / InpDailyLossLimit): raggiunto il target/limite,   |
//|      chiude l'eventuale posizione e non riapre fino al giorno   |
//|      successivo.                                                 |
//|  +500/giorno e' un TETTO, non un'aspettativa realistica.       |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro - Claudio"
#property version   "1.20"
#property strict

#include <Trade/Trade.mqh>

CTrade trade;

//==================================================================
//  ENUM
//==================================================================
enum ENUM_SCALP_DIRECTION
  {
   SDIR_BOTH       = 0,   // Entrambe (Long + Short)
   SDIR_LONG_ONLY  = 1,   // Solo LONG
   SDIR_SHORT_ONLY = 2    // Solo SHORT
  };

//--- NUOVO v2: proxy per rilevare il rallentamento del momentum ----
enum ENUM_FADE_MODE
  {
   FADE_ATR     = 0,   // ATR in calo per N barre consecutive
   FADE_BBWIDTH = 1    // Larghezza bande Bollinger in contrazione per N barre
  };

//--- NUOVO v2: cosa fare quando il momentum rallenta ---------------
enum ENUM_FADE_ACTION
  {
   FADE_TIGHTEN = 0,   // Stringe il trailing (dimezza la distanza)
   FADE_CLOSE   = 1    // Chiude il residuo a mercato
  };

//--- NUOVO v3 (v1.20): modalita' del filtro di volatilita' ---------
enum ENUM_VOL_MODE
  {
   VOL_ATR = 0,   // ATR M5 >= soglia in $ (entra solo se il mercato si muove)
   VOL_ADR = 1    // range del giorno finora < % dell'ADR (spazio residuo)
  };

//==================================================================
//  INPUT
//==================================================================

//--- Indicatori: Ichimoku (Donchian) -----------------------------
input group "=== Ichimoku (Donchian) - Modo A ==="
input int    InpTenkan   = 7;     // Tenkan (Donchian) - linea rossa direzione
input int    InpKijun    = 22;    // Kijun (Donchian)
input int    InpSenkouB  = 44;    // Senkou B (Donchian)

//--- Indicatori: Bollinger ---------------------------------------
input group "=== Bollinger (SMA basis) - Modo B ==="
input int    InpBBLen    = 20;    // BB Lunghezza (basis = SMA close)
input double InpBBMult    = 2.0;  // BB Deviazioni (non usato nei segnali core, per coerenza)

//--- Modalita' di ingresso ---------------------------------------
input group "=== Modalita' di ingresso ==="
input bool   InpUseModeA  = true; // Attiva Modo A (Ichimoku multi-TF)
input bool   InpUseModeB  = true; // Attiva Modo B (Bollinger inclinate M1+M5)
input ENUM_TIMEFRAMES InpConfirmTF = PERIOD_M1; // TF di conferma Modo A (M1 o M15)
input ENUM_SCALP_DIRECTION InpTradeDirection = SDIR_BOTH; // Direzione consentita

//--- Modo B: definizione "banda inclinata" -----------------------
input group "=== Modo B: banda inclinata ==="
input int    InpSlopeBars      = 5;    // Barre per misurare la pendenza del basis
input double InpSlopeMinDollars = 0.3; // Pendenza minima in $ (|basis[0]-basis[N]|)

//--- Stop iniziale -----------------------------------------------
input group "=== Stop iniziale ==="
input double InpStopDollars  = 4.0;   // [DEDOTTO] SL iniziale fisso in $ (se non ATR)
input bool   InpUseAtrStop   = false; // true: SL = ATR x mult ; false: SL fisso in $
input int    InpAtrLen       = 14;    // ATR Lunghezza (se ATR usato)
input double InpAtrMultSL     = 1.5;  // ATR x Stop Loss (se ATR usato)

//--- Break-even / Parziale / Trailing (cuore dello stile) --------
input group "=== Gestione: Break-even / Parziale / Trailing ==="
// Break-even: scatta appena la piattaforma lo consente (distanza minima broker).
input double InpBreakEvenDollars = 0.0; // [DEDOTTO/regolabile] soglia BE alternativa in $ (0 = usa solo distanza minima broker)
input int    InpBeBufferPoints   = 2;   // [DEDOTTO/regolabile] buffer in POINT oltre la distanza minima broker per il BE
// Parziale 50% in valuta conto (€): usa POSITION_PROFIT (P&L floating gia' in valuta conto).
input double InpPartialProfitMoney = 20.0; // [DEDOTTO/regolabile] profitto floating in valuta conto (€) che attiva la parziale
input double InpPartialPercent   = 50.0;// [DEDOTTO/regolabile] % di volume chiusa alla parziale
// Trailing: ATR-adattivo di DEFAULT (si allarga nei trend forti).
input double InpTrailDollars      = 1.0;// [DEDOTTO] trailing fisso in $ sul residuo (se non ATR)
input bool   InpUseAtrTrail       = true;  // [DEDOTTO/regolabile] true: trailing = ATR x mult (DEFAULT) ; false: trailing fisso $
input double InpAtrMultTrail      = 2.0;   // [DEDOTTO/regolabile] ATR x Trailing (un po' piu' largo: "stare largo")
input bool   InpTrailOnlyAfterPartial = true; // trailing solo dopo la parziale (lascia correre il residuo)

//--- NUOVO v2: Momentum-fade (uscita/stringitura su forza in calo) -
input group "=== Momentum-fade (forza del prezzo in calo) ==="
input bool            InpUseMomentumFade = true;        // Attiva il rilevamento del rallentamento del momentum
input ENUM_FADE_MODE  InpFadeMode        = FADE_BBWIDTH;// Proxy: ATR in calo o larghezza Bollinger in contrazione
input ENUM_FADE_ACTION InpFadeAction     = FADE_TIGHTEN;// Azione: stringi il trailing o chiudi il residuo
input int             InpFadeBars        = 3;           // Barre consecutive di contrazione richieste

//--- Money management --------------------------------------------
input group "=== Money management ==="
input bool   InpUseRiskSize  = false; // true: rischio % ; false: lotto fisso
input double InpFixedLots     = 0.5;  // [DEDOTTO] lotto fisso (come il trader)
input double InpRiskPercent   = 0.5;  // Rischio per trade (% del balance) se InpUseRiskSize

//--- NUOVO v3 (v1.20): Filtro di volatilita' ---------------------
input group "=== v1.20 - Filtro di volatilita' (SELETTIVITA') ==="
input bool         InpUseVolFilter   = true;     // Attiva il filtro di volatilita' (non entrare su ogni candela)
input ENUM_VOL_MODE InpVolMode       = VOL_ATR;  // VOL_ATR (ATR M5 minimo) oppure VOL_ADR (spazio residuo nel giorno)
input double       InpMinAtrDollars  = 1.0;      // [VOL_ATR][DA TARARE] ATR(InpAtrLen) M5 minimo in $ per entrare
input int          InpAdrDays        = 14;       // [VOL_ADR] giorni per la media dell'Average Daily Range
input double       InpAdrUsedMaxPct  = 80.0;     // [VOL_ADR][DA TARARE] entra solo se range giorno finora < % dell'ADR

//--- NUOVO v3 (v1.20): Uscita a tempo ----------------------------
input group "=== v1.20 - Uscita a tempo (due candele e chiudiamo) ==="
input int    InpMaxBarsInTrade      = 2;  // Chiudi dopo N barre M5 chiuse dall'ingresso (0 = off). Limita i winner lunghi.

//--- NUOVO v3 (v1.20): Stop sessione su P&L giornaliero ----------
input group "=== v1.20 - Stop sessione su P&L giornaliero ==="
input double InpDailyProfitTarget   = 500.0; // Profitto REALIZZATO giorn. (valuta conto) che ferma la giornata (0 = off). TETTO, non aspettativa.
input double InpDailyLossLimit       = 300.0; // Perdita REALIZZATA giorn. (valuta conto) che ferma la giornata (0 = off).

//--- Sicurezza ---------------------------------------------------
input group "=== Sicurezza ==="
input int    InpMaxTradesPerDay     = 6; // [v1.20] max ingressi/giorno (0 = illimitato)
input double InpMaxDailyLossDollars  = 0;// 0 = off (stop operativita' oltre questa perdita giorn. su EQUITY floating)

//--- Filtri ------------------------------------------------------
input group "=== Filtri ==="
input bool   InpUseSession    = false; // il trader dice "nessun orario": default off
input int    InpSessionStart   = 14;   // ora server inizio sessione
input int    InpSessionEnd     = 21;   // ora server fine sessione (no nuove entrate dopo)

//--- Generali / esecuzione ---------------------------------------
input group "=== Generali / esecuzione ==="
input long   InpMagic          = 250618; // Numero magico
input int    InpMaxSpreadPoints = 0;     // Spread massimo (in POINT); 0 = disattivato

//==================================================================
//  STATO GLOBALE
//==================================================================
int hAtrM5      = INVALID_HANDLE; // ATR su M5 (per SL/trailing se ATR usato)
int hAtrFade    = INVALID_HANDLE; // NUOVO v2: ATR sul TF corrente (proxy momentum FADE_ATR)
int hBBFade     = INVALID_HANDLE; // NUOVO v2: Bollinger sul TF corrente (proxy momentum FADE_BBWIDTH)
int hAtrVol     = INVALID_HANDLE; // NUOVO v3: ATR M5 per il filtro di volatilita' (VOL_ATR)

datetime g_lastBarTime = 0;  // per rilevare la nuova barra M5

datetime g_lastFadeBarTime = 0; // NUOVO v2: ultima barra (TF corrente) su cui ho valutato il fade

// Stato del trade corrente (tra i tick: BE / parziale / trailing)
double g_entryPrice    = 0.0;  // prezzo di ingresso reale
long   g_posTicket     = 0;    // ticket della posizione gestita
bool   g_beDone        = false;// break-even gia' applicato?
bool   g_partialDone   = false;// chiusura parziale gia' eseguita?
double g_trailStop     = 0.0;  // valore corrente dello stop trailing (monotono)
double g_initVolume    = 0.0;  // volume iniziale della posizione (per la parziale)
bool   g_fadeTighten   = false;// NUOVO v2: il momentum-fade ha chiesto di stringere il trailing?
datetime g_entryBarTime = 0;   // NUOVO v3: ora (M5) della barra in cui e' stata aperta la posizione

// Contatori di sicurezza giornalieri
int      g_dayTrades   = 0;     // numero trade aperti oggi
double   g_dayStartEquity = 0.0;// equity a inizio giornata (per perdita giorn.)
datetime g_currentDay  = 0;     // giorno corrente (per reset contatori)
bool     g_dayStopped  = false; // NUOVO v3: giornata fermata (target/limite P&L realizzato raggiunto)

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   // Handle ATR su M5: serve solo se SL o trailing usano l'ATR.
   if(InpUseAtrStop || InpUseAtrTrail)
     {
      hAtrM5 = iATR(_Symbol, PERIOD_M5, InpAtrLen);
      if(hAtrM5 == INVALID_HANDLE)
        {
         Print("ERRORE: impossibile creare l'handle ATR M5.");
         return(INIT_FAILED);
        }
     }

   // NUOVO v2: handle per il rilevamento del momentum-fade (sul TF corrente).
   // Creo solo il proxy selezionato per non sprecare handle.
   if(InpUseMomentumFade)
     {
      if(InpFadeMode == FADE_ATR)
        {
         hAtrFade = iATR(_Symbol, _Period, InpAtrLen);
         if(hAtrFade == INVALID_HANDLE)
           {
            Print("ERRORE: impossibile creare l'handle ATR (fade) sul TF corrente.");
            return(INIT_FAILED);
           }
        }
      else // FADE_BBWIDTH
        {
         // Bollinger 20, deviazioni InpBBMult, su close del TF corrente.
         hBBFade = iBands(_Symbol, _Period, InpBBLen, 0, InpBBMult, PRICE_CLOSE);
         if(hBBFade == INVALID_HANDLE)
           {
            Print("ERRORE: impossibile creare l'handle Bollinger (fade) sul TF corrente.");
            return(INIT_FAILED);
           }
        }
     }

   // NUOVO v3 (v1.20): handle ATR M5 per il filtro di volatilita' (solo VOL_ATR).
   // Lo creo separato da hAtrM5 perche' quest'ultimo esiste solo se SL/trailing usano l'ATR.
   if(InpUseVolFilter && InpVolMode == VOL_ATR)
     {
      hAtrVol = iATR(_Symbol, PERIOD_M5, InpAtrLen);
      if(hAtrVol == INVALID_HANDLE)
        {
         Print("ERRORE: impossibile creare l'handle ATR M5 (filtro volatilita').");
         return(INIT_FAILED);
        }
     }

   trade.SetExpertMagicNumber(InpMagic);
   ConfigureFilling();

   if(_Period != PERIOD_M5)
      Print("AVVISO: l'EA e' tarato su M5. Timeframe corrente del grafico: ",
            EnumToString((ENUM_TIMEFRAMES)_Period), " (l'EA gira comunque ma i segnali si calcolano su M5).");

   if(!InpUseModeA && !InpUseModeB)
      Print("AVVISO: entrambi i modi di ingresso (A e B) sono DISATTIVATI: l'EA non aprira' posizioni.");

   // Reset contatori giornalieri all'avvio
   ResetDailyCountersIfNewDay(true);

   // Se all'avvio esiste gia' una posizione di questo EA, ricostruisco lo stato
   AdoptExistingPosition();

   string volStr;
   if(!InpUseVolFilter)
      volStr = "OFF";
   else if(InpVolMode == VOL_ATR)
      volStr = "ATR>=$" + DoubleToString(InpMinAtrDollars, 2);
   else
      volStr = "ADR<" + DoubleToString(InpAdrUsedMaxPct, 1) + "%(" + IntegerToString(InpAdrDays) + "g)";

   Print("Gold_Scalper_TK_BB_BE_EA v1.20 avviato su ", _Symbol, " ",
         EnumToString((ENUM_TIMEFRAMES)_Period),
         " | ModoA=", (InpUseModeA?"ON":"OFF"),
         " | ModoB=", (InpUseModeB?"ON":"OFF"),
         " | ConfirmTF=", EnumToString(InpConfirmTF),
         " | Dir=", EnumToString(InpTradeDirection),
         " | Parziale@", DoubleToString(InpPartialProfitMoney, 2), AccountInfoString(ACCOUNT_CURRENCY),
         " | Trail=", (InpUseAtrTrail?("ATRx"+DoubleToString(InpAtrMultTrail,2)):("$"+DoubleToString(InpTrailDollars,2))),
         " | Fade=", (InpUseMomentumFade?EnumToString(InpFadeMode):"OFF"),
         "/", EnumToString(InpFadeAction),
         " | BeBuf=", IntegerToString(InpBeBufferPoints), "pt");
   Print("v1.20 SELETTIVITA' | VolFilter=", volStr,
         " | MaxBarsInTrade=", IntegerToString(InpMaxBarsInTrade),
         " | MaxTrades/gg=", IntegerToString(InpMaxTradesPerDay),
         " | TargetGG=", DoubleToString(InpDailyProfitTarget, 2),
         " | LossLimitGG=", DoubleToString(InpDailyLossLimit, 2),
         " ", AccountInfoString(ACCOUNT_CURRENCY),
         " (target = TETTO, non aspettativa; soglie DA TARARE)");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione (rilascio handle)                             |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hAtrM5   != INVALID_HANDLE) IndicatorRelease(hAtrM5);
   if(hAtrFade != INVALID_HANDLE) IndicatorRelease(hAtrFade); // NUOVO v2
   if(hBBFade  != INVALID_HANDLE) IndicatorRelease(hBBFade);  // NUOVO v2
   if(hAtrVol  != INVALID_HANDLE) IndicatorRelease(hAtrVol);  // NUOVO v3
  }

//+------------------------------------------------------------------+
//| Configura il filling mode adattivo (FOK / IOC / RETURN)          |
//+------------------------------------------------------------------+
void ConfigureFilling()
  {
   long modes = SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if((modes & SYMBOL_FILLING_FOK) != 0)
      trade.SetTypeFilling(ORDER_FILLING_FOK);
   else if((modes & SYMBOL_FILLING_IOC) != 0)
      trade.SetTypeFilling(ORDER_FILLING_IOC);
   else
      trade.SetTypeFilling(ORDER_FILLING_RETURN);
  }

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
  {
   // Reset contatori giornalieri se e' cambiato il giorno
   ResetDailyCountersIfNewDay(false);

   // NUOVO v3 (v1.20): stop sessione su P&L REALIZZATO giornaliero.
   // Se il target di profitto e' raggiunto (o la perdita ha sfondato il limite),
   // chiudo l'eventuale posizione e marco la giornata come ferma. La gestione di
   // una posizione gia' aperta (sotto) resta attiva finche' non e' chiusa, ma non
   // si apre piu' nulla fino al giorno successivo.
   CheckDailyPnLStop();

   // 1) Gestione della posizione aperta (BE / parziale / trailing / uscita a tempo) -> OGNI tick.
   ManagePosition();

   // 2) Segnali ed entrate SOLO a nuova barra M5 chiusa (no repaint).
   if(!IsNewBarM5())
      return;

   OnNewBarM5();
  }

//+------------------------------------------------------------------+
//| Ritorna true una sola volta per ogni nuova barra M5              |
//+------------------------------------------------------------------+
bool IsNewBarM5()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, PERIOD_M5, SERIES_LASTBAR_DATE);
   if(t != g_lastBarTime)
     {
      g_lastBarTime = t;
      return(true);
     }
   return(false);
  }

//==================================================================
//  CALCOLO INDICATORI
//==================================================================

//+------------------------------------------------------------------+
//| Donchian su un TF arbitrario:                                    |
//|   (Highest(High,len) + Lowest(Low,len)) / 2                      |
//|  shift = barra di riferimento (1 = ultima chiusa).              |
//+------------------------------------------------------------------+
bool DonchianTF(ENUM_TIMEFRAMES tf, int len, int shift, double &outVal)
  {
   int hiIdx = iHighest(_Symbol, tf, MODE_HIGH, len, shift);
   int loIdx = iLowest(_Symbol, tf, MODE_LOW,  len, shift);
   if(hiIdx < 0 || loIdx < 0)
      return(false);

   double hh = iHigh(_Symbol, tf, hiIdx);
   double ll = iLow(_Symbol, tf, loIdx);
   if(hh <= 0.0 && ll <= 0.0)
      return(false);

   outVal = (hh + ll) / 2.0;
   return(true);
  }

//+------------------------------------------------------------------+
//| Tenkan / Kijun (Donchian) a un certo shift su un TF             |
//+------------------------------------------------------------------+
bool GetTK(ENUM_TIMEFRAMES tf, int shift, double &tenkan, double &kijun)
  {
   if(!DonchianTF(tf, InpTenkan, shift, tenkan)) return(false);
   if(!DonchianTF(tf, InpKijun,  shift, kijun))  return(false);
   return(true);
  }

//+------------------------------------------------------------------+
//| Direzione TK su un TF (a barra chiusa, shift 1):                |
//|   +1 se Tenkan>Kijun, -1 se Tenkan<Kijun, 0 altrimenti          |
//+------------------------------------------------------------------+
int TKDirection(ENUM_TIMEFRAMES tf)
  {
   double t, k;
   if(!GetTK(tf, 1, t, k))
      return(0);
   if(t > k) return(+1);
   if(t < k) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Bollinger basis = SMA(close, bbLen) su un TF a un certo shift    |
//+------------------------------------------------------------------+
bool BBBasisAt(ENUM_TIMEFRAMES tf, int shift, double &basis)
  {
   double closes[];
   if(CopyClose(_Symbol, tf, shift, InpBBLen, closes) < InpBBLen)
      return(false);
   double sum = 0.0;
   for(int i = 0; i < InpBBLen; i++)
      sum += closes[i];
   basis = sum / InpBBLen;
   return(true);
  }

//+------------------------------------------------------------------+
//| Pendenza della banda (basis SMA) su un TF, a barre chiuse:      |
//|   slope = basis[1] - basis[1+InpSlopeBars]                       |
//|  Ritorna +1 (inclinata su), -1 (inclinata giu'), 0 (piatta o    |
//|  sotto soglia / dati insufficienti).                            |
//+------------------------------------------------------------------+
int BBSlopeDirection(ENUM_TIMEFRAMES tf)
  {
   double basisNow, basisPast;
   // Uso barre CHIUSE: shift 1 (ultima chiusa) e shift 1+InpSlopeBars.
   if(!BBBasisAt(tf, 1, basisNow))
      return(0);
   if(!BBBasisAt(tf, 1 + InpSlopeBars, basisPast))
      return(0);

   double slope = basisNow - basisPast;
   if(MathAbs(slope) < InpSlopeMinDollars)
      return(0);                  // piatta: sotto la soglia di inclinazione
   return(slope > 0.0 ? +1 : -1);
  }

//+------------------------------------------------------------------+
//| ATR M5 sull'ultima barra chiusa (shift 1)                       |
//+------------------------------------------------------------------+
bool GetATR(double &atrVal)
  {
   if(hAtrM5 == INVALID_HANDLE)
      return(false);
   double buf[1];
   if(CopyBuffer(hAtrM5, 0, 1, 1, buf) < 1)
      return(false);
   atrVal = buf[0];
   return(atrVal > 0.0);
  }

//==================================================================
//  VALUTAZIONE SEGNALI SU NUOVA BARRA M5 CHIUSA
//==================================================================
void OnNewBarM5()
  {
   // Una sola posizione per volta: se c'e' gia' una posizione, non valuto entrate.
   if(HasOpenPosition())
      return;

   if(!InpUseModeA && !InpUseModeB)
      return;

   // NUOVO v3 (v1.20): giornata fermata da target/limite P&L realizzato.
   if(g_dayStopped)
      return;

   // Filtri di sicurezza / sessione
   if(!SessionOK())
      return;
   if(!DailyLimitsOK())
      return;

   // NUOVO v3 (v1.20): filtro di volatilita' (non entrare su ogni candela).
   if(!VolatilityOK())
      return;

   // --- MODO A: cross TK su M5 (barre chiuse) + conferma multi-TF ---
   bool aLong  = false;
   bool aShort = false;
   if(InpUseModeA)
     {
      double t1, k1, t2, k2;
      // M5: barra chiusa (shift 1) e precedente (shift 2) per il cross
      if(GetTK(PERIOD_M5, 1, t1, k1) && GetTK(PERIOD_M5, 2, t2, k2))
        {
         bool longCross  = (t2 <= k2) && (t1 > k1);   // crossover Tenkan>Kijun
         bool shortCross = (t2 >= k2) && (t1 < k1);   // crossunder Tenkan<Kijun

         // Conferma: almeno il TF di conferma ha la STESSA direzione del cross M5.
         int confDir = TKDirection(InpConfirmTF);     // +1/-1/0 sul TF di conferma
         aLong  = longCross  && (confDir == +1);
         aShort = shortCross && (confDir == -1);
        }
     }

   // --- MODO B: banda di Bollinger inclinata stessa direzione su M1 E M5 ---
   bool bLong  = false;
   bool bShort = false;
   if(InpUseModeB)
     {
      int slopeM5 = BBSlopeDirection(PERIOD_M5);
      int slopeM1 = BBSlopeDirection(PERIOD_M1);
      // Stessa direzione (e diversa da 0) su entrambi i timeframe
      if(slopeM5 != 0 && slopeM5 == slopeM1)
        {
         bLong  = (slopeM5 == +1);
         bShort = (slopeM5 == -1);
        }
     }

   // --- Ingresso = (Modo A valido) OPPURE (Modo B valido) ---
   bool wantLong  = aLong  || bLong;
   bool wantShort = aShort || bShort;

   // Gate direzione consentita
   bool allowLong  = (InpTradeDirection == SDIR_BOTH || InpTradeDirection == SDIR_LONG_ONLY);
   bool allowShort = (InpTradeDirection == SDIR_BOTH || InpTradeDirection == SDIR_SHORT_ONLY);
   wantLong  = wantLong  && allowLong;
   wantShort = wantShort && allowShort;

   // Segnali contrastanti contemporanei: non opero (ambiguo).
   if(wantLong && wantShort)
      return;

   if(wantLong)
      OpenTrade(ORDER_TYPE_BUY);
   else if(wantShort)
      OpenTrade(ORDER_TYPE_SELL);
  }

//==================================================================
//  APERTURA POSIZIONE
//==================================================================
void OpenTrade(ENUM_ORDER_TYPE type)
  {
   if(!SpreadOK())
     {
      Print("Entrata saltata: spread troppo alto.");
      return;
     }

   // Distanza di stop iniziale (in prezzo).
   double stopDist = StopDistance();
   if(stopDist <= 0.0)
     {
      Print("Stop distance non valida. Entrata annullata.");
      return;
     }

   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double price  = (type == ORDER_TYPE_BUY)
                   ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                   : SymbolInfoDouble(_Symbol, SYMBOL_BID);

   double sl = (type == ORDER_TYPE_BUY) ? price - stopDist : price + stopDist;
   price = NormalizeDouble(price, digits);
   sl    = NormalizeDouble(sl, digits);

   double lot = CalcLot(stopDist);
   if(lot <= 0.0)
     {
      Print("Lotto calcolato non valido (<=0). Entrata annullata.");
      return;
     }

   bool ok;
   string cmt = (type == ORDER_TYPE_BUY) ? "Scalp long" : "Scalp short";
   if(type == ORDER_TYPE_BUY)
      ok = trade.Buy(lot, _Symbol, price, sl, 0.0, cmt);
   else
      ok = trade.Sell(lot, _Symbol, price, sl, 0.0, cmt);

   if(!ok)
     {
      Print("Apertura ordine FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
      return;
     }

   // Memorizzo lo stato del trade per la gestione.
   double realEntry = trade.ResultPrice();
   if(realEntry <= 0.0)
      realEntry = price;

   g_entryPrice  = realEntry;
   g_beDone      = false;
   g_partialDone = false;
   g_trailStop   = 0.0;
   g_fadeTighten = false;        // NUOVO v2
   g_initVolume  = lot;
   g_posTicket   = 0;            // verra' adottato a tick (PositionSelect)
   // NUOVO v3: memorizzo la barra M5 d'ingresso per l'uscita a tempo.
   g_entryBarTime = (datetime)SeriesInfoInteger(_Symbol, PERIOD_M5, SERIES_LASTBAR_DATE);

   g_dayTrades++;

   // Adotto subito i dati reali della posizione (ticket, volume effettivo).
   AdoptExistingPosition();
  }

//==================================================================
//  DISTANZA DI STOP INIZIALE (in prezzo)
//==================================================================
double StopDistance()
  {
   if(InpUseAtrStop)
     {
      double atrVal;
      if(!GetATR(atrVal))
         return(0.0);
      return(InpAtrMultSL * atrVal);
     }
   // SL fisso in dollari oro = distanza diretta in prezzo (1$ = 1.0 sul quotato XAUUSD).
   return(InpStopDollars);
  }

//==================================================================
//  MONEY MANAGEMENT: lotto fisso o per rischio % (corretto XAUUSD)
//==================================================================
double CalcLot(double stopDistPrice)
  {
   double lot;

   if(!InpUseRiskSize)
     {
      lot = InpFixedLots;            // lotto fisso (come fa il trader)
     }
   else
     {
      // Rischio % sul balance, calcolato sullo stop iniziale.
      double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
      double riskMoney = balance * InpRiskPercent / 100.0;

      double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
      double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      if(tickSize <= 0.0 || tickValue <= 0.0)
         return(0.0);

      double lossPerLot = (stopDistPrice / tickSize) * tickValue;
      if(lossPerLot <= 0.0)
         return(0.0);

      lot = riskMoney / lossPerLot;
     }

   return(NormalizeLot(lot));
  }

//+------------------------------------------------------------------+
//| Normalizza un volume ai vincoli del simbolo (STEP/MIN/MAX)       |
//+------------------------------------------------------------------+
double NormalizeLot(double lot)
  {
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep <= 0.0)
      lotStep = 0.01;

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));

   int lotDigits = 0;
   double s = lotStep;
   while(s < 1.0 && lotDigits < 8) { s *= 10.0; lotDigits++; }
   lot = NormalizeDouble(lot, lotDigits);

   return(lot);
  }

//==================================================================
//  GESTIONE POSIZIONE A TICK: break-even, parziale, trailing
//==================================================================
void ManagePosition()
  {
   if(!HasOpenPosition())
     {
      // Nessuna posizione: azzero lo stato.
      g_posTicket   = 0;
      g_beDone      = false;
      g_partialDone = false;
      g_trailStop   = 0.0;
      g_fadeTighten = false; // NUOVO v2
      return;
     }

   // Se non ho ancora lo stato (es. dopo restart) lo ricostruisco.
   if(g_posTicket == 0)
      AdoptExistingPosition();
   if(g_posTicket == 0)
      return;

   // NUOVO v3 (v1.20): USCITA A TEMPO ("due candele e poi chiudiamo").
   // Chiudo la posizione (residuo compreso) dopo InpMaxBarsInTrade barre M5
   // CHIUSE dall'ingresso, se ancora aperta. Conto le barre M5 trascorse dalla
   // barra d'ingresso a quella corrente (no look-ahead: uso la barra corrente).
   // Trailing/partial restano attivi DENTRO quelle barre; questo cap limita i
   // winner lunghi (trade-off voluto per la selettivita').
   if(CheckTimeExit())
      return; // posizione chiusa: lo stato si azzera al prossimo ManagePosition.

   long   ptype   = PositionGetInteger(POSITION_TYPE);
   bool   isLong  = (ptype == POSITION_TYPE_BUY);
   int    digits  = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double entry   = PositionGetDouble(POSITION_PRICE_OPEN);
   double curSL   = PositionGetDouble(POSITION_SL);
   double curTP   = PositionGetDouble(POSITION_TP);

   // Prezzo corrente "favorevole" per misurare il profitto in $:
   //  LONG -> uso il BID (prezzo a cui chiuderei); SHORT -> uso l'ASK.
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double profitDollars = isLong ? (bid - entry) : (entry - ask);  // in $ oro per unita' di prezzo

   // NUOVO v2: profitto FLOATING in valuta del conto (gia' al netto del volume).
   double profitMoney = PositionGetDouble(POSITION_PROFIT);

   //--- 1) BREAK-EVEN che RISPETTA la distanza minima del broker.
   //    Il trader va a pari "appena la piattaforma lo consente": cioe' appena il
   //    prezzo supera l'ingresso di almeno la distanza minima (StopsLevel) + buffer.
   //    La soglia effettiva di attivazione e' il MAX tra:
   //      - distanza minima broker + buffer (in prezzo)
   //      - InpBreakEvenDollars (soglia alternativa in prezzo; 0 = ignorata)
   if(!g_beDone)
     {
      double stopsLevelPrice = StopsLevelPrice();                 // distanza minima broker (in prezzo)
      double bufferPrice     = InpBeBufferPoints * _Point;        // buffer aggiuntivo
      double beTrigger       = MathMax(stopsLevelPrice + bufferPrice, InpBreakEvenDollars);

      if(profitDollars >= beTrigger)
        {
         // SL a pareggio (entry), poi clampato alla distanza minima consentita.
         double newSL = ClampStopToStopsLevel(NormalizeDouble(entry, digits), isLong, bid, ask);
         newSL = NormalizeDouble(newSL, digits);

         // Sposto solo se migliora (long: su; short: giu') rispetto allo SL attuale.
         bool improve = isLong ? (newSL > curSL + _Point/2.0)
                               : (curSL == 0.0 || newSL < curSL - _Point/2.0);
         if(improve)
           {
            if(ModifyStop(newSL, curTP))
               g_beDone = true;
           }
         else
           {
            g_beDone = true;  // SL gia' a pareggio o migliore: marco come fatto.
           }
         // Rileggo lo SL dopo l'eventuale modifica.
         curSL = PositionGetDouble(POSITION_SL);
        }
     }

   //--- 2) CHIUSURA PARZIALE 50%: una sola volta, sul PROFITTO IN VALUTA CONTO (€).
   //    Trigger = POSITION_PROFIT (P&L floating della posizione, gia' in valuta conto).
   if(!g_partialDone && profitMoney >= InpPartialProfitMoney && InpPartialPercent > 0.0)
     {
      double curVol = PositionGetDouble(POSITION_VOLUME);
      double closeVol = NormalizeLot(curVol * InpPartialPercent / 100.0);

      double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      // Eseguo la parziale solo se: il volume da chiudere e' valido E
      // rimane almeno il minimo lotto sul residuo (altrimenti chiuderei tutto).
      double residual = NormalizeLot(curVol - closeVol);
      if(closeVol >= minLot && residual >= minLot)
        {
         if(trade.PositionClosePartial(_Symbol, closeVol))
           {
            g_partialDone = true;
           }
         else
           {
            Print("PositionClosePartial FALLITA. Retcode=", trade.ResultRetcode(),
                  " - ", trade.ResultRetcodeDescription());
           }
        }
      else
        {
         // Volume troppo piccolo per parzializzare in modo pulito: salto la parziale
         // ma marco come fatta per non ritentare a ogni tick.
         g_partialDone = true;
        }
     }

   //--- 2-bis) NUOVO v2: MOMENTUM-FADE.
   //    Valuto il rallentamento della forza SOLO a barra chiusa (no repaint) e
   //    SOLO se la posizione e' gia' in profitto. Se rilevato, secondo InpFadeAction:
   //      FADE_TIGHTEN -> dimezzo la distanza di trailing (fattore applicato sotto);
   //      FADE_CLOSE   -> chiudo il residuo a mercato (ed esco subito).
   double trailFactor = 1.0;  // moltiplicatore della distanza di trailing (1.0 = nessuna stretta)
   if(InpUseMomentumFade && profitMoney > 0.0 && IsNewFadeBar())
     {
      // Valutazione del fade UNA SOLA VOLTA per barra chiusa del TF corrente.
      bool fading = MomentumIsFading();
      if(fading)
        {
         if(InpFadeAction == FADE_CLOSE)
           {
            if(trade.PositionClose(_Symbol))
              {
               Print("MOMENTUM-FADE: residuo chiuso a mercato (forza in calo, in profitto).");
               // Stato azzerato al prossimo ManagePosition (HasOpenPosition()==false).
               return;
              }
            else
              {
               Print("MOMENTUM-FADE: PositionClose FALLITA. Retcode=", trade.ResultRetcode(),
                     " - ", trade.ResultRetcodeDescription());
              }
           }
         else // FADE_TIGHTEN
           {
            g_fadeTighten = true; // attiva la stretta del trailing
           }
        }
      else
        {
         // La forza e' tornata a espandersi: rilascio la stretta.
         g_fadeTighten = false;
        }
     }
   // FADE_TIGHTEN: applico la stretta del trailing in modo persistente finche'
   // il fade resta attivo sull'ultima barra valutata (g_fadeTighten).
   if(InpUseMomentumFade && InpFadeAction == FADE_TIGHTEN && g_fadeTighten)
      trailFactor = 0.5; // dimezza la distanza di trailing

   //--- 3) TRAILING sul residuo (ATR-adattivo di default o fisso in $), monotono.
   //    Se InpTrailOnlyAfterPartial e' true, parte solo dopo la parziale (lascia correre).
   //    La distanza puo' essere ristretta dal momentum-fade (trailFactor).
   //    Lo SL e' SEMPRE clampato alla distanza minima del broker (StopsLevel).
   bool trailActive = (!InpTrailOnlyAfterPartial) || g_partialDone;
   if(trailActive)
     {
      double trailDist = TrailDistance() * trailFactor;
      if(trailDist > 0.0)
        {
         // Rileggo SL aggiornato.
         curSL = PositionGetDouble(POSITION_SL);
         curTP = PositionGetDouble(POSITION_TP);

         if(isLong)
           {
            double candidate = bid - trailDist;
            if(candidate > g_trailStop)        // trailing monotono (solo su)
               g_trailStop = candidate;

            // Clamp alla distanza minima del broker prima di inviare la modifica.
            double newSL = ClampStopToStopsLevel(NormalizeDouble(g_trailStop, digits), true, bid, ask);
            newSL = NormalizeDouble(newSL, digits);
            if(newSL > curSL + _Point/2.0)     // sposto solo IN SU
               ModifyStop(newSL, curTP);
           }
         else
           {
            double candidate = ask + trailDist;
            if(g_trailStop == 0.0 || candidate < g_trailStop)  // monotono (solo giu')
               g_trailStop = candidate;

            double newSL = ClampStopToStopsLevel(NormalizeDouble(g_trailStop, digits), false, bid, ask);
            newSL = NormalizeDouble(newSL, digits);
            if(curSL == 0.0 || newSL < curSL - _Point/2.0)     // sposto solo IN GIU
               ModifyStop(newSL, curTP);
           }
        }
     }
  }

//==================================================================
//  NUOVO v2: DISTANZA MINIMA DEL BROKER (StopsLevel / FreezeLevel)
//==================================================================

//+------------------------------------------------------------------+
//| Distanza minima consentita per gli stop, in PREZZO.              |
//|  Considera sia SYMBOL_TRADE_STOPS_LEVEL sia SYMBOL_TRADE_FREEZE_ |
//|  LEVEL (prendo il max, piu' prudente). Se il broker ritorna 0,   |
//|  resta 0 (nessun vincolo dichiarato).                            |
//+------------------------------------------------------------------+
double StopsLevelPrice()
  {
   long stopsLevel  = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL);
   long freezeLevel = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_FREEZE_LEVEL);
   long lvl = (stopsLevel > freezeLevel) ? stopsLevel : freezeLevel;
   if(lvl < 0) lvl = 0;
   return((double)lvl * _Point);
  }

//+------------------------------------------------------------------+
//| Clampa uno SL proposto in modo che NON sia mai piu' vicino al    |
//| prezzo della distanza minima del broker (StopsLevel/FreezeLevel).|
//|  LONG  -> SL deve stare almeno (bid - minDist) o piu' in basso;  |
//|           se proposto troppo alto, lo abbasso a (bid - minDist). |
//|  SHORT -> SL deve stare almeno (ask + minDist) o piu' in alto;   |
//|           se proposto troppo basso, lo alzo a (ask + minDist).   |
//|  Cosi' la PositionModify non viene rifiutata dal broker.         |
//+------------------------------------------------------------------+
double ClampStopToStopsLevel(double proposedSL, bool isLong, double bid, double ask)
  {
   double minDist = StopsLevelPrice();
   if(minDist <= 0.0)
      return(proposedSL); // nessun vincolo dichiarato dal broker

   if(isLong)
     {
      double maxAllowedSL = bid - minDist;   // lo SL long non puo' superare questo livello
      if(proposedSL > maxAllowedSL)
         return(maxAllowedSL);
     }
   else
     {
      double minAllowedSL = ask + minDist;   // lo SL short non puo' scendere sotto questo livello
      if(proposedSL < minAllowedSL)
         return(minAllowedSL);
     }
   return(proposedSL);
  }

//==================================================================
//  DISTANZA DI TRAILING (in prezzo)
//==================================================================
double TrailDistance()
  {
   if(InpUseAtrTrail)
     {
      double atrVal;
      if(!GetATR(atrVal))
         return(0.0);
      return(InpAtrMultTrail * atrVal);
     }
   return(InpTrailDollars);
  }

//==================================================================
//  NUOVO v2: MOMENTUM-FADE (rilevamento del rallentamento)
//==================================================================

//+------------------------------------------------------------------+
//| Ritorna true una sola volta per ogni nuova barra CHIUSA del TF   |
//| corrente: cosi' il fade si valuta a barra chiusa (no repaint).   |
//+------------------------------------------------------------------+
bool IsNewFadeBar()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if(t != g_lastFadeBarTime)
     {
      g_lastFadeBarTime = t;
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Il momentum sta rallentando? (valutato su barre CHIUSE)          |
//|  FADE_ATR:     ATR(InpAtrLen) in calo per InpFadeBars barre.     |
//|  FADE_BBWIDTH: larghezza bande (upper-lower) in contrazione      |
//|                per InpFadeBars barre.                            |
//|  Richiede una sequenza STRETTAMENTE monotona decrescente di      |
//|  InpFadeBars valori consecutivi (barra chiusa piu' recente=sh.1).|
//+------------------------------------------------------------------+
bool MomentumIsFading()
  {
   if(InpFadeBars < 1)
      return(false);

   // Mi servono InpFadeBars confronti consecutivi -> InpFadeBars+1 valori.
   int need = InpFadeBars + 1;

   if(InpFadeMode == FADE_ATR)
     {
      if(hAtrFade == INVALID_HANDLE)
         return(false);
      double atr[];
      // shift 1 = ultima barra chiusa; copio need valori a partire da shift 1.
      if(CopyBuffer(hAtrFade, 0, 1, need, atr) < need)
         return(false);
      // atr[0] = barra chiusa piu' recente, atr[need-1] = la piu' vecchia.
      for(int i = 0; i < InpFadeBars; i++)
        {
         if(!(atr[i] < atr[i + 1])) // deve essere strettamente decrescente nel tempo
            return(false);
        }
      return(true);
     }
   else // FADE_BBWIDTH
     {
      if(hBBFade == INVALID_HANDLE)
         return(false);
      double up[], lo[];
      // buffer 1 = upper band, buffer 2 = lower band (iBands).
      if(CopyBuffer(hBBFade, 1, 1, need, up) < need)
         return(false);
      if(CopyBuffer(hBBFade, 2, 1, need, lo) < need)
         return(false);
      // Larghezza = upper - lower. Deve contrarsi per InpFadeBars barre.
      for(int i = 0; i < InpFadeBars; i++)
        {
         double wNew = up[i]     - lo[i];     // barra piu' recente
         double wOld = up[i + 1] - lo[i + 1]; // barra precedente
         if(!(wNew < wOld))                   // deve essere in contrazione nel tempo
            return(false);
        }
      return(true);
     }
  }

//+------------------------------------------------------------------+
//| Modifica lo SL della posizione corrente con controllo retcode    |
//+------------------------------------------------------------------+
bool ModifyStop(double newSL, double tp)
  {
   if(!trade.PositionModify(_Symbol, newSL, tp))
     {
      Print("PositionModify FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
      return(false);
     }
   return(true);
  }

//==================================================================
//  UTILITY
//==================================================================

//+------------------------------------------------------------------+
//| C'e' una posizione aperta di QUESTO EA su questo simbolo?         |
//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   if(!PositionSelect(_Symbol))
      return(false);
   return(PositionGetInteger(POSITION_MAGIC) == InpMagic);
  }

//+------------------------------------------------------------------+
//| Lo spread e' accettabile?                                        |
//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpreadPoints <= 0)
      return(true);
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   return(spread <= InpMaxSpreadPoints);
  }

//+------------------------------------------------------------------+
//| Filtro sessione (ora server). Default off.                       |
//+------------------------------------------------------------------+
bool SessionOK()
  {
   if(!InpUseSession)
      return(true);
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int h = dt.hour;
   if(InpSessionStart <= InpSessionEnd)
      return(h >= InpSessionStart && h < InpSessionEnd);
   // Sessione che attraversa la mezzanotte
   return(h >= InpSessionStart || h < InpSessionEnd);
  }

//+------------------------------------------------------------------+
//| Limiti di sicurezza giornalieri (trade/giorno + perdita giorn.)  |
//+------------------------------------------------------------------+
bool DailyLimitsOK()
  {
   if(InpMaxTradesPerDay > 0 && g_dayTrades >= InpMaxTradesPerDay)
     {
      return(false);
     }
   if(InpMaxDailyLossDollars > 0.0)
     {
      double equity = AccountInfoDouble(ACCOUNT_EQUITY);
      double dayPnL = equity - g_dayStartEquity;   // perdita = valore negativo
      if(dayPnL <= -InpMaxDailyLossDollars)
         return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Reset contatori giornalieri al cambio di giorno (ora server)     |
//+------------------------------------------------------------------+
void ResetDailyCountersIfNewDay(bool force)
  {
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   dt.hour = 0; dt.min = 0; dt.sec = 0;
   datetime today = StructToTime(dt);

   if(force || today != g_currentDay)
     {
      g_currentDay      = today;
      g_dayTrades       = 0;
      g_dayStartEquity  = AccountInfoDouble(ACCOUNT_EQUITY);
      g_dayStopped      = false;   // NUOVO v3: la giornata riparte "operativa"
     }
  }

//==================================================================
//  NUOVO v3 (v1.20): FILTRO DI VOLATILITA'
//==================================================================

//+------------------------------------------------------------------+
//| Filtro di volatilita': decide se il mercato e' "operabile".      |
//|  VOL_ATR: ATR(InpAtrLen) M5 (ultima barra chiusa) >= soglia $.   |
//|  VOL_ADR: range del giorno corrente finora < % dell'ADR (media   |
//|           del range High-Low giornaliero su InpAdrDays).         |
//|  Valutato a barra M5 chiusa (nessun look-ahead: la barra d'oggi  |
//|  "finora" usa High/Low correnti del giorno in corso).            |
//+------------------------------------------------------------------+
bool VolatilityOK()
  {
   if(!InpUseVolFilter)
      return(true);

   if(InpVolMode == VOL_ATR)
     {
      if(hAtrVol == INVALID_HANDLE)
         return(true); // handle non disponibile: non blocco (fail-open)
      double buf[1];
      if(CopyBuffer(hAtrVol, 0, 1, 1, buf) < 1) // shift 1 = ultima barra chiusa
         return(false);
      double atrVal = buf[0];
      // ATR su XAUUSD e' gia' espresso in $ (1.0 di prezzo = 1$ per unita').
      return(atrVal >= InpMinAtrDollars);
     }

   // VOL_ADR: confronto il range del giorno corrente finora con l'ADR.
   double adr = AverageDailyRange(InpAdrDays);
   if(adr <= 0.0)
      return(true); // dati insufficienti: non blocco

   double todayRange = TodayRangeSoFar();
   if(todayRange < 0.0)
      return(true); // dati insufficienti: non blocco

   // Entra solo se c'e' ancora "spazio": range usato finora < % dell'ADR.
   double usedPct = (todayRange / adr) * 100.0;
   return(usedPct < InpAdrUsedMaxPct);
  }

//+------------------------------------------------------------------+
//| Average Daily Range: media del range High-Low giornaliero        |
//| sugli ultimi 'days' giorni CHIUSI (shift 1..days, no giorno      |
//| corrente per evitare di mischiare un range incompleto).          |
//+------------------------------------------------------------------+
double AverageDailyRange(int days)
  {
   if(days < 1)
      return(0.0);
   double hi[], lo[];
   // shift 1 = ultimo giorno chiuso; copio 'days' giorni chiusi.
   if(CopyHigh(_Symbol, PERIOD_D1, 1, days, hi) < days)
      return(0.0);
   if(CopyLow(_Symbol, PERIOD_D1, 1, days, lo) < days)
      return(0.0);
   double sum = 0.0;
   for(int i = 0; i < days; i++)
      sum += (hi[i] - lo[i]);
   return(sum / days);
  }

//+------------------------------------------------------------------+
//| Range del GIORNO CORRENTE finora (High-Low della barra D1 a      |
//| shift 0, cioe' il giorno in corso). Nessun look-ahead: usa solo  |
//| i massimi/minimi gia' formati fino a ora.                        |
//+------------------------------------------------------------------+
double TodayRangeSoFar()
  {
   double hi[], lo[];
   if(CopyHigh(_Symbol, PERIOD_D1, 0, 1, hi) < 1)
      return(-1.0);
   if(CopyLow(_Symbol, PERIOD_D1, 0, 1, lo) < 1)
      return(-1.0);
   return(hi[0] - lo[0]);
  }

//==================================================================
//  NUOVO v3 (v1.20): USCITA A TEMPO
//==================================================================

//+------------------------------------------------------------------+
//| Uscita a tempo: chiude la posizione dopo InpMaxBarsInTrade barre |
//| M5 CHIUSE dall'ingresso. Ritorna true se ha chiuso (cosi' il     |
//| chiamante puo' uscire subito dalla gestione).                    |
//|  Conteggio: numero di barre M5 la cui ora di apertura e'         |
//|  strettamente > g_entryBarTime (ovvero barre nate DOPO quella    |
//|  d'ingresso). Quando raggiunge InpMaxBarsInTrade, chiudo.        |
//+------------------------------------------------------------------+
bool CheckTimeExit()
  {
   if(InpMaxBarsInTrade <= 0)
      return(false);
   if(g_entryBarTime == 0)
      return(false);

   int barsSince = iBarShift(_Symbol, PERIOD_M5, g_entryBarTime, false);
   // iBarShift(entryBarTime) = quante barre M5 fa e' stata aperta la posizione,
   // cioe' il numero di barre M5 CHIUSE trascorse dall'ingresso (barra corrente
   // = shift 0). Esempio: ingresso su barra X; alla 2a barra chiusa dopo X,
   // barsSince == 2 -> chiudo.
   if(barsSince < 0)
      return(false);

   if(barsSince >= InpMaxBarsInTrade)
     {
      if(trade.PositionClose(_Symbol))
        {
         Print("USCITA A TEMPO: posizione chiusa dopo ", barsSince,
               " barre M5 dall'ingresso (cap=", InpMaxBarsInTrade, ").");
         return(true);
        }
      else
        {
         Print("USCITA A TEMPO: PositionClose FALLITA. Retcode=", trade.ResultRetcode(),
               " - ", trade.ResultRetcodeDescription());
        }
     }
   return(false);
  }

//==================================================================
//  NUOVO v3 (v1.20): STOP SESSIONE SU P&L REALIZZATO GIORNALIERO
//==================================================================

//+------------------------------------------------------------------+
//| P&L REALIZZATO del giorno corrente (valuta conto): somma di      |
//| profit + commission + swap dei DEAL chiusi oggi su questo        |
//| simbolo e questo magic. Si basa sullo storico dei deal del       |
//| giorno (dal mezzanotte server a ora).                            |
//+------------------------------------------------------------------+
double RealizedPnLToday()
  {
   datetime from = g_currentDay;                 // mezzanotte server del giorno corrente
   datetime to   = TimeCurrent() + 1;            // fino ad ora (inclusiva)
   if(!HistorySelect(from, to))
      return(0.0);

   double pnl = 0.0;
   int total = HistoryDealsTotal();
   for(int i = 0; i < total; i++)
     {
      ulong ticket = HistoryDealGetTicket(i);
      if(ticket == 0)
         continue;
      // Solo deal di QUESTO EA e simbolo.
      if(HistoryDealGetInteger(ticket, DEAL_MAGIC) != InpMagic)
         continue;
      if(HistoryDealGetString(ticket, DEAL_SYMBOL) != _Symbol)
         continue;
      // Considero solo i deal che incidono sul P&L (uscite / parziali / chiusure).
      long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
      if(entry == DEAL_ENTRY_IN)
         continue; // l'apertura non realizza P&L
      pnl += HistoryDealGetDouble(ticket, DEAL_PROFIT)
           + HistoryDealGetDouble(ticket, DEAL_COMMISSION)
           + HistoryDealGetDouble(ticket, DEAL_SWAP);
     }
   return(pnl);
  }

//+------------------------------------------------------------------+
//| Stop sessione: se il P&L realizzato del giorno raggiunge il      |
//| target di profitto o sfonda il limite di perdita, chiude         |
//| l'eventuale posizione e ferma la giornata (niente nuove entrate  |
//| fino al giorno successivo).                                       |
//+------------------------------------------------------------------+
void CheckDailyPnLStop()
  {
   if(g_dayStopped)
      return;
   if(InpDailyProfitTarget <= 0.0 && InpDailyLossLimit <= 0.0)
      return;

   double realized = RealizedPnLToday();

   bool hitTarget = (InpDailyProfitTarget > 0.0 && realized >= InpDailyProfitTarget);
   bool hitLoss   = (InpDailyLossLimit   > 0.0 && realized <= -InpDailyLossLimit);

   if(hitTarget || hitLoss)
     {
      g_dayStopped = true;
      // Chiudo l'eventuale posizione aperta di questo EA.
      if(HasOpenPosition())
        {
         if(trade.PositionClose(_Symbol))
            Print("STOP GIORNATA: posizione chiusa. P&L realizzato oggi=",
                  DoubleToString(realized, 2), " ", AccountInfoString(ACCOUNT_CURRENCY),
                  hitTarget ? " (TARGET raggiunto)" : " (LIMITE perdita raggiunto)");
         else
            Print("STOP GIORNATA: PositionClose FALLITA. Retcode=", trade.ResultRetcode(),
                  " - ", trade.ResultRetcodeDescription());
        }
      else
        {
         Print("STOP GIORNATA: niente nuove entrate fino a domani. P&L realizzato oggi=",
               DoubleToString(realized, 2), " ", AccountInfoString(ACCOUNT_CURRENCY),
               hitTarget ? " (TARGET raggiunto)" : " (LIMITE perdita raggiunto)");
        }
     }
  }

//+------------------------------------------------------------------+
//| Adotta la posizione esistente: ricostruisce lo stato di base.    |
//|  Usato all'avvio, dopo l'apertura e dopo un restart EA.          |
//+------------------------------------------------------------------+
void AdoptExistingPosition()
  {
   if(!HasOpenPosition())
     {
      g_posTicket = 0;
      return;
     }

   long ticket = (long)PositionGetInteger(POSITION_TICKET);

   // Se e' una posizione NUOVA (ticket diverso) ricostruisco lo stato base.
   if(ticket != g_posTicket)
     {
      g_posTicket  = ticket;
      g_entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
      g_initVolume = PositionGetDouble(POSITION_VOLUME);
      // Conservativo dopo un restart: NON so se BE/parziale erano gia' stati
      // fatti, quindi li lascio a false (verranno applicati se le condizioni
      // di profitto sono soddisfatte; lo SL si sposta solo se migliora).
      g_beDone      = false;
      g_partialDone = false;
      g_trailStop   = 0.0;
      g_fadeTighten = false; // NUOVO v2
      // NUOVO v3: per l'uscita a tempo dopo un restart uso l'ora di apertura
      // della posizione mappata sulla barra M5 corrispondente (conservativo:
      // la posizione potrebbe gia' aver superato il cap e verra' chiusa subito).
      datetime posOpen = (datetime)PositionGetInteger(POSITION_TIME);
      int sh = iBarShift(_Symbol, PERIOD_M5, posOpen, false);
      if(sh >= 0)
         g_entryBarTime = (datetime)iTime(_Symbol, PERIOD_M5, sh);
      else
         g_entryBarTime = posOpen;
     }
  }
//+------------------------------------------------------------------+
