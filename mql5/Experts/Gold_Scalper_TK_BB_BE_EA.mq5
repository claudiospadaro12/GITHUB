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
//|  GESTIONE (dedotta dai trade reali - tutti INPUT):             |
//|   - Stop iniziale fisso in $ (default 4.0) o ATR (opzionale).   |
//|   - Break-even rapido quando profitto >= InpBreakEvenDollars.   |
//|   - Chiusura parziale 50% quando profitto >= InpPartialDollars. |
//|   - Trailing sul residuo (fisso in $ o ATR) per far correre.    |
//|   - Nessun TP fisso sul residuo (lascia correre col trailing).  |
//|                                                                  |
//|  Stile di codice (CTrade, filling adattivo, gestione handle,   |
//|  lotto normalizzato) ripreso da Gold_Ichimoku_TK_ATR_EA.mq5.   |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro - Claudio"
#property version   "1.00"
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
input double InpBreakEvenDollars = 0.3; // [DEDOTTO] profitto in $ che porta SL a pareggio
input double InpPartialDollars   = 0.5; // [DEDOTTO] profitto in $ che attiva la parziale
input double InpPartialPercent   = 50.0;// [DEDOTTO] % di volume chiusa alla parziale
input double InpTrailDollars      = 1.0;// [DEDOTTO] trailing fisso in $ sul residuo (se non ATR)
input bool   InpUseAtrTrail       = false; // true: trailing = ATR x mult ; false: trailing fisso $
input double InpAtrMultTrail      = 1.5;   // ATR x Trailing (se ATR usato)
input bool   InpTrailOnlyAfterPartial = true; // trailing solo dopo la parziale (lascia correre il residuo)

//--- Money management --------------------------------------------
input group "=== Money management ==="
input bool   InpUseRiskSize  = false; // true: rischio % ; false: lotto fisso
input double InpFixedLots     = 0.5;  // [DEDOTTO] lotto fisso (come il trader)
input double InpRiskPercent   = 0.5;  // Rischio per trade (% del balance) se InpUseRiskSize

//--- Sicurezza ---------------------------------------------------
input group "=== Sicurezza ==="
input int    InpMaxTradesPerDay     = 0; // 0 = nessun limite
input double InpMaxDailyLossDollars  = 0;// 0 = off (stop operativita' oltre questa perdita giorn.)

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
int hAtrM5 = INVALID_HANDLE; // ATR su M5 (per SL/trailing se ATR usato)

datetime g_lastBarTime = 0;  // per rilevare la nuova barra M5

// Stato del trade corrente (tra i tick: BE / parziale / trailing)
double g_entryPrice    = 0.0;  // prezzo di ingresso reale
long   g_posTicket     = 0;    // ticket della posizione gestita
bool   g_beDone        = false;// break-even gia' applicato?
bool   g_partialDone   = false;// chiusura parziale gia' eseguita?
double g_trailStop     = 0.0;  // valore corrente dello stop trailing (monotono)
double g_initVolume    = 0.0;  // volume iniziale della posizione (per la parziale)

// Contatori di sicurezza giornalieri
int      g_dayTrades   = 0;     // numero trade aperti oggi
double   g_dayStartEquity = 0.0;// equity a inizio giornata (per perdita giorn.)
datetime g_currentDay  = 0;     // giorno corrente (per reset contatori)

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

   Print("Gold_Scalper_TK_BB_BE_EA avviato su ", _Symbol, " ",
         EnumToString((ENUM_TIMEFRAMES)_Period),
         " | ModoA=", (InpUseModeA?"ON":"OFF"),
         " | ModoB=", (InpUseModeB?"ON":"OFF"),
         " | ConfirmTF=", EnumToString(InpConfirmTF),
         " | Dir=", EnumToString(InpTradeDirection));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione (rilascio handle)                             |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hAtrM5 != INVALID_HANDLE) IndicatorRelease(hAtrM5);
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

   // 1) Gestione della posizione aperta (BE / parziale / trailing) -> OGNI tick.
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

   // Filtri di sicurezza / sessione
   if(!SessionOK())
      return;
   if(!DailyLimitsOK())
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
   g_initVolume  = lot;
   g_posTicket   = 0;            // verra' adottato a tick (PositionSelect)

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
      return;
     }

   // Se non ho ancora lo stato (es. dopo restart) lo ricostruisco.
   if(g_posTicket == 0)
      AdoptExistingPosition();
   if(g_posTicket == 0)
      return;

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

   //--- 1) BREAK-EVEN rapido: appena il profitto raggiunge la soglia, SL a entry.
   if(!g_beDone && profitDollars >= InpBreakEvenDollars)
     {
      double newSL = NormalizeDouble(entry, digits);
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

   //--- 2) CHIUSURA PARZIALE 50%: una sola volta, alla soglia di profitto.
   if(!g_partialDone && profitDollars >= InpPartialDollars && InpPartialPercent > 0.0)
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

   //--- 3) TRAILING sul residuo (fisso in $ o ATR), monotono.
   //    Se InpTrailOnlyAfterPartial e' true, parte solo dopo la parziale (lascia correre).
   bool trailActive = (!InpTrailOnlyAfterPartial) || g_partialDone;
   if(trailActive)
     {
      double trailDist = TrailDistance();
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

            double newSL = NormalizeDouble(g_trailStop, digits);
            if(newSL > curSL + _Point/2.0)     // sposto solo IN SU
               ModifyStop(newSL, curTP);
           }
         else
           {
            double candidate = ask + trailDist;
            if(g_trailStop == 0.0 || candidate < g_trailStop)  // monotono (solo giu')
               g_trailStop = candidate;

            double newSL = NormalizeDouble(g_trailStop, digits);
            if(curSL == 0.0 || newSL < curSL - _Point/2.0)     // sposto solo IN GIU
               ModifyStop(newSL, curTP);
           }
        }
     }
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
     }
  }
//+------------------------------------------------------------------+
