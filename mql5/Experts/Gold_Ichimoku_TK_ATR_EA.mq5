//+------------------------------------------------------------------+
//|                                  Gold_Ichimoku_TK_ATR_EA.mq5      |
//|                                                                  |
//|  Expert Advisor per XAUUSD (ORO) - timeframe H1                  |
//|                                                                  |
//|  Replica FEDELE della strategia Pine v3:                        |
//|    "Gold Ichimoku TK + ATR Exits - Claudio v3"                  |
//|                                                                  |
//|  LOGICA (su barra CHIUSA, niente repaint / look-ahead):         |
//|   - Ichimoku basato su DONCHIAN:                                 |
//|        donchian(len) = (Highest(High,len)+Lowest(Low,len))/2     |
//|        tenkan = donchian(7), kijun = donchian(22)                |
//|        senkouA = (tenkan+kijun)/2, senkouB = donchian(44)        |
//|        (nuvola CORRENTE, NON spostata in avanti)                 |
//|   - SEGNALI: cross Tenkan/Kijun (crossover/crossunder)          |
//|   - FILTRI opzionali: Kumo (ON), ADX, Espansione BB, Kijun      |
//|   - DIREZIONE: Both / Solo Long (default) / Solo Short          |
//|   - USCITE: TP fisso / Cross (default) / Kijun / ATR trailing   |
//|   - SL ATR iniziale SEMPRE attivo. Una sola posizione.          |
//|                                                                  |
//|  DEFAULT = configurazione VALIDATA:                             |
//|   Solo Long, Kumo ON (altri filtri OFF), EXIT_CROSS,            |
//|   atrMultSL=1.5, rischio 0.5%.                                  |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro - Claudio"
#property version   "3.00"
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

CTrade trade;

//==================================================================
//  ENUM
//==================================================================
enum ENUM_TRADE_DIRECTION
  {
   DIR_BOTH       = 0,   // Entrambe (Long + Short)
   DIR_LONG_ONLY  = 1,   // Solo LONG
   DIR_SHORT_ONLY = 2    // Solo SHORT
  };

enum ENUM_EXIT_MODE
  {
   EXIT_TPFISSO  = 0,   // TP fisso 2R + cross opposto (come v2)
   EXIT_CROSS    = 1,   // Solo cross opposto (lascia correre)
   EXIT_KIJUN    = 2,   // Trailing/uscita sulla Kijun
   EXIT_ATRTRAIL = 3    // Chandelier ATR trailing
  };

//==================================================================
//  INPUT
//==================================================================

//--- Ichimoku (Donchian) -----------------------------------------
input group "=== Ichimoku (Donchian) ==="
input int    InpTenkan   = 7;     // Tenkan (Donchian)
input int    InpKijun    = 22;    // Kijun (Donchian)
input int    InpSenkouB  = 44;    // Senkou B (Donchian)

//--- Bollinger (filtro espansione) -------------------------------
input group "=== Bollinger (filtro espansione) ==="
input int    InpBBLen    = 20;    // BB Lunghezza
input double InpBBMult   = 2.0;   // BB Deviazioni
input int    InpSqzLen   = 50;    // Squeeze: media bbWidth
input double InpSqzFactor= 0.8;   // Squeeze: fattore (width < media*fattore)

//--- Filtri di selettivita' (entrata) ----------------------------
input group "=== Filtri di selettivita' (entrata) ==="
input bool   InpUseKumoFilter      = true;   // Filtro nuvola (Kumo): prezzo sopra/sotto la nuvola
input bool   InpUseADXFilter       = false;  // Filtro ADX: entra solo se trend forte (ADX > soglia)
input int    InpAdxLen             = 14;     // ADX: lunghezza (Wilder)
input double InpAdxMin             = 22.0;   // ADX: soglia minima per entrare
input bool   InpUseExpansionFilter = false;  // Filtro Espansione BB: entra solo con bande ESPANSE
input bool   InpUseKijunFilter     = false;  // Filtro Kijun: close oltre la Kijun

//--- Direzione consentita ----------------------------------------
input group "=== Direzione consentita ==="
input ENUM_TRADE_DIRECTION InpTradeDirection = DIR_LONG_ONLY; // Direzione dei trade

//--- Uscita (modalita' + SL/TP ATR) ------------------------------
input group "=== Uscita (modalita' + SL/TP ATR + cross opposto) ==="
input ENUM_EXIT_MODE InpExitMode  = EXIT_CROSS; // Modalita' di uscita
input int    InpAtrLen        = 14;    // ATR Lunghezza
input double InpAtrMultSL      = 1.5;   // ATR x Stop Loss (SL iniziale, sempre attivo)
input double InpRewardRatio    = 2.0;   // Reward Ratio (TP = R x dist. stop) [solo EXIT_TPFISSO]
input double InpAtrTrailMult   = 3.0;   // ATR x Trailing (chandelier) [solo EXIT_ATRTRAIL]
input bool   InpUseOppositeExit= true;  // Uscita anticipata sul cross opposto (sempre attivo in EXIT_CROSS)

//--- Rischio / Money Management ----------------------------------
input group "=== Rischio (Money Management) ==="
input double InpRiskPercent   = 0.5;   // Rischio per trade (% del balance)

//--- Generali / esecuzione ---------------------------------------
input group "=== Generali / esecuzione ==="
input long   InpMagic          = 250604; // Numero magico
input int    InpMaxSpreadPoints = 0;     // Spread massimo (in POINT); 0 = disattivato

//==================================================================
//  STATO GLOBALE
//==================================================================
int hATR = INVALID_HANDLE;

// Handle indicatori per il calcolo manuale dell'ADX (TR / DM smoothing Wilder)
// (creati solo se il filtro ADX e' attivo)
int hADX = INVALID_HANDLE;   // usiamo l'iADX nativo per coerenza/robustezza

datetime g_lastBarTime = 0;  // per rilevare la nuova barra

// Stato del trade (mantenuto tra i tick per gestire trailing/uscite)
double g_entryPrice  = 0.0;  // prezzo di ingresso reale
double g_slInit      = 0.0;  // SL ATR iniziale (protezione di base)
double g_tpPrice     = 0.0;  // TP fisso (solo EXIT_TPFISSO)
double g_trailExtreme= 0.0;  // max(High) per LONG / min(Low) per SHORT dal trade
double g_trailStop   = 0.0;  // valore corrente dello stop trailing
bool   g_hasState    = false;// abbiamo memorizzato lo stato di una posizione aperta?

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   hATR = iATR(_Symbol, _Period, InpAtrLen);
   if(hATR == INVALID_HANDLE)
     {
      Print("ERRORE: impossibile creare l'handle ATR.");
      return(INIT_FAILED);
     }

   // Handle ADX solo se il filtro e' attivo (evito leak / risorse inutili)
   if(InpUseADXFilter)
     {
      hADX = iADX(_Symbol, _Period, InpAdxLen);
      if(hADX == INVALID_HANDLE)
        {
         Print("ERRORE: impossibile creare l'handle ADX.");
         return(INIT_FAILED);
        }
     }

   trade.SetExpertMagicNumber(InpMagic);
   ConfigureFilling();

   if(_Period != PERIOD_H1)
      Print("AVVISO: l'EA e' tarato su H1. Timeframe corrente: ",
            EnumToString((ENUM_TIMEFRAMES)_Period), " (l'EA gira comunque).");

   // Se all'avvio esiste gia' una posizione di questo EA, ricostruisco uno stato di base
   AdoptExistingPosition();

   Print("Gold_Ichimoku_TK_ATR_EA avviato su ", _Symbol, " ",
         EnumToString((ENUM_TIMEFRAMES)_Period),
         " | ExitMode=", EnumToString(InpExitMode),
         " | Dir=", EnumToString(InpTradeDirection));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione (rilascio handle)                             |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hATR != INVALID_HANDLE) IndicatorRelease(hATR);
   if(hADX != INVALID_HANDLE) IndicatorRelease(hADX);
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
   // 1) Gestione della posizione aperta (trailing ATR e SL hard) -> ogni tick.
   //    Il trailing chandelier ATR e' monotono e si aggiorna ad ogni tick
   //    (coerente col Pine, che aggiorna lo stop barra per barra ma in modo
   //    monotono; in MT5 lo facciamo ad ogni tick mantenendo la monotonia).
   ManagePosition();

   // 2) Segnali ed entrate SOLO a nuova barra H1 chiusa.
   if(!IsNewBar())
      return;

   // Su nuova barra: gestione uscite "su chiusura" (cross opposto, Kijun)
   // e poi eventuale nuova entrata.
   OnNewBar();
  }

//+------------------------------------------------------------------+
//| Ritorna true una sola volta per ogni nuova barra                 |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if(t != g_lastBarTime)
     {
      g_lastBarTime = t;
      return(true);
     }
   return(false);
  }

//==================================================================
//  CALCOLO INDICATORI (Donchian = IDENTICO al Pine)
//==================================================================

//+------------------------------------------------------------------+
//| Donchian: (Highest(High,len) + Lowest(Low,len)) / 2              |
//|  shift = barra di riferimento (1 = ultima chiusa)               |
//+------------------------------------------------------------------+
bool Donchian(int len, int shift, double &outVal)
  {
   int hiIdx = iHighest(_Symbol, _Period, MODE_HIGH, len, shift);
   int loIdx = iLowest(_Symbol, _Period, MODE_LOW,  len, shift);
   if(hiIdx < 0 || loIdx < 0)
      return(false);

   double hh = iHigh(_Symbol, _Period, hiIdx);
   double ll = iLow(_Symbol, _Period, loIdx);
   if(hh == 0.0 && ll == 0.0)
      return(false);

   outVal = (hh + ll) / 2.0;
   return(true);
  }

//+------------------------------------------------------------------+
//| Calcola Tenkan / Kijun / SenkouA / SenkouB a un certo shift      |
//+------------------------------------------------------------------+
bool GetIchimoku(int shift, double &tenkan, double &kijun, double &senkouA, double &senkouB)
  {
   if(!Donchian(InpTenkan,  shift, tenkan))  return(false);
   if(!Donchian(InpKijun,   shift, kijun))   return(false);
   if(!Donchian(InpSenkouB, shift, senkouB)) return(false);
   senkouA = (tenkan + kijun) / 2.0;
   return(true);
  }

//+------------------------------------------------------------------+
//| ATR sull'ultima barra chiusa (shift 1)                           |
//+------------------------------------------------------------------+
bool GetATR(double &atrVal)
  {
   double buf[1];
   if(CopyBuffer(hATR, 0, 1, 1, buf) < 1)
      return(false);
   atrVal = buf[0];
   return(atrVal > 0.0);
  }

//+------------------------------------------------------------------+
//| ADX sull'ultima barra chiusa (shift 1) - solo se filtro attivo   |
//+------------------------------------------------------------------+
bool GetADX(double &adxVal)
  {
   if(hADX == INVALID_HANDLE)
      return(false);
   double buf[1];
   if(CopyBuffer(hADX, 0, 1, 1, buf) < 1)   // buffer 0 = ADX main line
      return(false);
   adxVal = buf[0];
   return(true);
  }

//+------------------------------------------------------------------+
//| Filtro Espansione BB: bbWidth >= sma(bbWidth, sqzLen)*sqzFactor   |
//|  (NON in squeeze). Replica del calcolo Pine sull'ultima chiusa.  |
//+------------------------------------------------------------------+
bool ExpansionOK()
  {
   if(!InpUseExpansionFilter)
      return(true);

   // Ho bisogno della bbWidth corrente (shift 1) e della media delle
   // ultime InpSqzLen bbWidth. bbWidth = 2*mult*stdev(close, bbLen).
   // Calcolo stdev manualmente su ciascuna barra necessaria.
   int need = InpSqzLen;             // numero di valori di bbWidth da mediare
   double sumWidth = 0.0;
   double widthNow = 0.0;

   for(int k = 0; k < need; k++)
     {
      int shift = 1 + k;             // dalla barra chiusa a ritroso
      double w;
      if(!BBWidthAt(shift, w))
         return(true);               // dati insufficienti: non filtro
      if(k == 0)
         widthNow = w;
      sumWidth += w;
     }

   double avgWidth = sumWidth / need;
   bool inSqueeze = widthNow < avgWidth * InpSqzFactor;
   return(!inSqueeze);
  }

//+------------------------------------------------------------------+
//| bbWidth a un certo shift = 2*mult*stdev(close, bbLen)            |
//+------------------------------------------------------------------+
bool BBWidthAt(int shift, double &width)
  {
   double closes[];
   if(CopyClose(_Symbol, _Period, shift, InpBBLen, closes) < InpBBLen)
      return(false);

   // media
   double sum = 0.0;
   for(int i = 0; i < InpBBLen; i++)
      sum += closes[i];
   double mean = sum / InpBBLen;

   // deviazione standard (popolazione, come ta.stdev di Pine)
   double sq = 0.0;
   for(int i = 0; i < InpBBLen; i++)
     {
      double d = closes[i] - mean;
      sq += d * d;
     }
   double stdev = MathSqrt(sq / InpBBLen);

   width = 2.0 * InpBBMult * stdev;   // upper - lower
   return(true);
  }

//==================================================================
//  GESTIONE SU NUOVA BARRA: uscite "su chiusura" + entrate
//==================================================================
void OnNewBar()
  {
   // Valori sull'ultima barra chiusa (shift 1) e precedente (shift 2)
   double t1, k1, sA1, sB1;   // barra chiusa: per filtri e nuvola corrente
   double t2, k2;             // barra precedente: servono solo per il cross
   if(!GetIchimoku(1, t1, k1, sA1, sB1)) return;
   // Per il cross bastano Tenkan/Kijun della barra precedente (Donchian diretto)
   if(!Donchian(InpTenkan, 2, t2)) return;
   if(!Donchian(InpKijun,  2, k2)) return;

   double close1 = iClose(_Symbol, _Period, 1);

   // Cross valutati su barre chiuse (shift 1 vs 2)
   bool longCross  = (t2 <= k2) && (t1 > k1);   // crossover Tenkan>Kijun
   bool shortCross = (t2 >= k2) && (t1 < k1);   // crossunder Tenkan<Kijun

   // -------- GESTIONE USCITE SU CHIUSURA (per posizione aperta) --------
   //  Coerente col Pine indicator: prima si gestisce l'uscita, poi (se flat)
   //  si valuta una nuova entrata SULLA STESSA BARRA. Nota: nella config
   //  validata (Solo Long + EXIT_CROSS) l'uscita avviene su shortCross e una
   //  nuova entrata long richiede longCross: eventi mutuamente esclusivi,
   //  quindi non c'e' mai re-entry sulla stessa barra. La gestione sotto e'
   //  per fedelta' anche in DIR_BOTH.
   if(HasOpenPosition())
     {
      long ptype = PositionGetInteger(POSITION_TYPE);
      bool isLong  = (ptype == POSITION_TYPE_BUY);
      bool isShort = (ptype == POSITION_TYPE_SELL);

      bool crossExitActive = (InpExitMode == EXIT_CROSS) || InpUseOppositeExit;
      bool closed = false;

      // 1) Uscita su CROSS opposto (priorita' alta, come nel Pine indicator)
      if(crossExitActive && isLong && shortCross)
        {
         ClosePosition("Cross opposto");
         closed = true;
        }
      else if(crossExitActive && isShort && longCross)
        {
         ClosePosition("Cross opposto");
         closed = true;
        }
      // 2) Uscita EXIT_KIJUN: chiusura quando il prezzo CHIUDE oltre la Kijun
      else if(InpExitMode == EXIT_KIJUN && isLong && close1 < k1)
        {
         ClosePosition("Kijun");
         closed = true;
        }
      else if(InpExitMode == EXIT_KIJUN && isShort && close1 > k1)
        {
         ClosePosition("Kijun");
         closed = true;
        }

      // Se la posizione e' ancora aperta (nessuna uscita su chiusura),
      // NON apro nulla di nuovo: una sola posizione per volta.
      if(!closed || HasOpenPosition())
         return;
      // Altrimenti proseguo: la stessa barra puo' generare una nuova entrata.
     }

   // -------- NESSUNA POSIZIONE: valuto le ENTRATE --------
   double atrVal;
   if(!GetATR(atrVal))
      return;

   // Bordi nuvola corrente (valori NON spostati)
   double kumoTop = MathMax(sA1, sB1);
   double kumoBot = MathMin(sA1, sB1);

   // Filtri
   bool adxOk = true;
   if(InpUseADXFilter)
     {
      double adxVal;
      adxOk = GetADX(adxVal) && (adxVal > InpAdxMin);
     }
   bool expansionOk = ExpansionOK();
   bool kumoOkLong  = !InpUseKumoFilter || (close1 > kumoTop);
   bool kumoOkShort = !InpUseKumoFilter || (close1 < kumoBot);
   bool kijunOkLong  = !InpUseKijunFilter || (close1 > k1);
   bool kijunOkShort = !InpUseKijunFilter || (close1 < k1);

   bool allowLong  = (InpTradeDirection == DIR_BOTH || InpTradeDirection == DIR_LONG_ONLY);
   bool allowShort = (InpTradeDirection == DIR_BOTH || InpTradeDirection == DIR_SHORT_ONLY);

   bool longSignal  = longCross  && adxOk && expansionOk && kumoOkLong  && kijunOkLong  && allowLong;
   bool shortSignal = shortCross && adxOk && expansionOk && kumoOkShort && kijunOkShort && allowShort;

   if(longSignal && !shortSignal)
      OpenTrade(ORDER_TYPE_BUY, atrVal, k1);
   else if(shortSignal && !longSignal)
      OpenTrade(ORDER_TYPE_SELL, atrVal, k1);
  }

//==================================================================
//  APERTURA POSIZIONE
//==================================================================
void OpenTrade(ENUM_ORDER_TYPE type, double atrVal, double kijun1)
  {
   if(!SpreadOK())
     {
      Print("Entrata saltata: spread troppo alto.");
      return;
     }

   double stopDist = InpAtrMultSL * atrVal;
   if(stopDist <= 0.0)
      return;

   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double price  = (type == ORDER_TYPE_BUY)
                   ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                   : SymbolInfoDouble(_Symbol, SYMBOL_BID);

   double sl = (type == ORDER_TYPE_BUY) ? price - stopDist : price + stopDist;
   double tp = 0.0;
   if(InpExitMode == EXIT_TPFISSO)
      tp = (type == ORDER_TYPE_BUY)
           ? price + InpRewardRatio * stopDist
           : price - InpRewardRatio * stopDist;

   price = NormalizeDouble(price, digits);
   sl    = NormalizeDouble(sl, digits);
   tp    = NormalizeDouble(tp, digits);

   double lot = CalcLotByRisk(stopDist);
   if(lot <= 0.0)
     {
      Print("Lotto calcolato non valido (<=0). Entrata annullata.");
      return;
     }

   //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
   if(!ABTG_GuardiaIngresso(InpUsaGuardian,"Gold_Ichimoku_TK_ATR_EA")) return;
   bool ok;
   string cmt = (type == ORDER_TYPE_BUY) ? "TK long" : "TK short";
   if(type == ORDER_TYPE_BUY)
      ok = trade.Buy(lot, _Symbol, price, sl, tp, cmt);
   else
      ok = trade.Sell(lot, _Symbol, price, sl, tp, cmt);

   if(!ok)
     {
      Print("Apertura ordine FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
      return;
     }

   // Memorizzo lo stato del trade per la gestione (trailing / uscite)
   double realEntry = trade.ResultPrice();
   if(realEntry <= 0.0)
      realEntry = price;

   g_entryPrice = realEntry;
   g_slInit     = (type == ORDER_TYPE_BUY) ? realEntry - stopDist : realEntry + stopDist;
   g_slInit     = NormalizeDouble(g_slInit, digits);
   g_tpPrice    = tp;

   // Reset dei valori di trailing all'apertura della posizione
   if(type == ORDER_TYPE_BUY)
     {
      g_trailExtreme = iHigh(_Symbol, _Period, 1);  // estremo iniziale = high barra chiusa
      g_trailStop    = (InpExitMode == EXIT_ATRTRAIL)
                       ? g_trailExtreme - InpAtrTrailMult * atrVal
                       : ((InpExitMode == EXIT_KIJUN) ? kijun1 : 0.0);
     }
   else
     {
      g_trailExtreme = iLow(_Symbol, _Period, 1);
      g_trailStop    = (InpExitMode == EXIT_ATRTRAIL)
                       ? g_trailExtreme + InpAtrTrailMult * atrVal
                       : ((InpExitMode == EXIT_KIJUN) ? kijun1 : 0.0);
     }
   g_hasState = true;
  }

//==================================================================
//  MONEY MANAGEMENT: lotto per rischio % (corretto per XAUUSD)
//==================================================================
double CalcLotByRisk(double stopDistPrice)
  {
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0.0 || tickValue <= 0.0)
      return(0.0);

   // perdita per 1 lotto se va a stop = (dist / tickSize) * tickValue
   double lossPerLot = (stopDistPrice / tickSize) * tickValue;
   if(lossPerLot <= 0.0)
      return(0.0);

   double lot = riskMoney / lossPerLot;

   // Normalizzo ai vincoli del simbolo
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(lotStep <= 0.0)
      lotStep = 0.01;

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));

   // arrotondo alla precisione dello step per evitare errori di volume
   int lotDigits = 0;
   double s = lotStep;
   while(s < 1.0 && lotDigits < 8) { s *= 10.0; lotDigits++; }
   lot = NormalizeDouble(lot, lotDigits);

   return(lot);
  }

//==================================================================
//  GESTIONE POSIZIONE A TICK: trailing ATR / SL hard
//==================================================================
void ManagePosition()
  {
   if(!HasOpenPosition())
     {
      g_hasState = false;
      return;
     }
   if(!g_hasState)
     {
      // Posizione aperta ma senza stato (es. dopo restart): la adotto.
      AdoptExistingPosition();
      if(!g_hasState)
         return;
     }

   long   ptype  = PositionGetInteger(POSITION_TYPE);
   bool   isLong = (ptype == POSITION_TYPE_BUY);
   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   double curSL  = PositionGetDouble(POSITION_SL);
   double curTP  = PositionGetDouble(POSITION_TP);

   // Solo EXIT_ATRTRAIL aggiorna lo stop a livello broker (chandelier monotono).
   // Le altre modalita' tengono lo SL ATR iniziale gia' impostato all'apertura.
   if(InpExitMode != EXIT_ATRTRAIL)
      return;

   double atrVal;
   if(!GetATR(atrVal))
      return;

   if(isLong)
     {
      // estremo = massimo tra estremo memorizzato e high corrente (in-progress)
      double curHigh = iHigh(_Symbol, _Period, 0);
      if(curHigh > g_trailExtreme)
         g_trailExtreme = curHigh;

      double candidate = g_trailExtreme - InpAtrTrailMult * atrVal;
      if(candidate > g_trailStop)
         g_trailStop = candidate;

      // stop effettivo = max(SL iniziale, chandelier) -> puo' solo migliorare
      double effSL = MathMax(g_slInit, g_trailStop);
      effSL = NormalizeDouble(effSL, digits);

      if(effSL > curSL + _Point/2.0)   // sposto solo IN SU
         ModifyStop(effSL, curTP);
     }
   else
     {
      double curLow = iLow(_Symbol, _Period, 0);
      if(curLow < g_trailExtreme || g_trailExtreme == 0.0)
         g_trailExtreme = curLow;

      double candidate = g_trailExtreme + InpAtrTrailMult * atrVal;
      if(candidate < g_trailStop || g_trailStop == 0.0)
         g_trailStop = candidate;

      double effSL = MathMin(g_slInit, g_trailStop);
      effSL = NormalizeDouble(effSL, digits);

      if(curSL == 0.0 || effSL < curSL - _Point/2.0)   // sposto solo IN GIU
         ModifyStop(effSL, curTP);
     }
  }

//+------------------------------------------------------------------+
//| Modifica lo SL della posizione corrente con controllo retcode    |
//+------------------------------------------------------------------+
void ModifyStop(double newSL, double tp)
  {
   if(!trade.PositionModify(_Symbol, newSL, tp))
      Print("PositionModify FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Chiude la posizione corrente con controllo retcode               |
//+------------------------------------------------------------------+
void ClosePosition(string reason)
  {
   if(!trade.PositionClose(_Symbol))
     {
      Print("PositionClose FALLITA (", reason, "). Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
      return;
     }
   g_hasState = false;
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
//| Adotta una posizione gia' esistente (es. dopo restart EA)        |
//|  Ricostruisce uno stato di base coerente.                        |
//+------------------------------------------------------------------+
void AdoptExistingPosition()
  {
   if(!HasOpenPosition())
     {
      g_hasState = false;
      return;
     }

   long   ptype = PositionGetInteger(POSITION_TYPE);
   double openP = PositionGetDouble(POSITION_PRICE_OPEN);
   double sl    = PositionGetDouble(POSITION_SL);
   double tp    = PositionGetDouble(POSITION_TP);

   g_entryPrice = openP;
   g_slInit     = (sl > 0.0) ? sl : openP;   // se non c'e' SL uso l'entry come base
   g_tpPrice    = tp;

   // Inizializzo l'estremo del trailing con l'estremo dell'ultima barra chiusa
   if(ptype == POSITION_TYPE_BUY)
     {
      g_trailExtreme = iHigh(_Symbol, _Period, 1);
      g_trailStop    = sl;
     }
   else
     {
      g_trailExtreme = iLow(_Symbol, _Period, 1);
      g_trailStop    = sl;
     }
   g_hasState = true;
  }
//+------------------------------------------------------------------+
