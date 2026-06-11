//+------------------------------------------------------------------+
//|                                        IchiCross_Gold_722.mq5     |
//|  EA per XAUUSD (oro) su M5 — Ichimoku 7/22/44 + filtri trend.    |
//|                                                                  |
//|  FILTRI INGRESSO (default ON): bande Bollinger in espansione,   |
//|   ADX>=30 (no laterale), nuvola Kumo, concordanza H1, e filtro  |
//|   orario sessioni 8-22 (ora server).                           |
//|  GESTIONE: SL 2.75xATR, trailing 4xATR, uscita su incrocio      |
//|   opposto, rischio 0.5%. Niente parziale/breakeven di default.  |
//|                                                                  |
//|  BACKTEST 5 ANNI (XAUUSD M5, ticks reali, ADX30 + orario 8-22): |
//|    Totale ~+1421 EUR, PF 1.50, DD ~4.9%, 198 trade, TUTTI e 5   |
//|    gli anni positivi. Il filtro orario raddrizza il 2022 (da    |
//|    -143 a +214) e migliora la qualita' (PF 2024 1.99->3.15).   |
//|    Vs senza orario +1504 ma con 1 anno negativo e PF piu' basso:|
//|    -5% di profitto in cambio di molta piu' costanza.          |
//|  NOTA: orario in ora del SERVER del broker; se cambi broker     |
//|   ritara InpStartHour/InpEndHour.                              |
//|  CAVEAT: sempre demo / 1 broker / costi M5. Serve forward demo. |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Oro"
#property version   "1.60"
#property strict

#include <Trade/Trade.mqh>

CTrade trade;

//==================================================================
//  PARAMETRI DI INPUT
//==================================================================

//--- Ichimoku (impostazione manuale 7/22/44)
input group "=== Ichimoku ==="
input int    InpTenkan       = 7;     // Tenkan-sen
input int    InpKijun        = 22;    // Kijun-sen
input int    InpSenkouB      = 44;    // Senkou Span B (standard 52; 44 = custom)

//--- Filtro anti-compressione (Bollinger Bands)
input group "=== Filtro bande in espansione ==="
input int    InpBBPeriod        = 20;  // Periodo Bollinger
input double InpBBDev           = 2.0; // Deviazioni standard
input int    InpBBExpandLookback= 3;   // Bande in espansione se larghezza ora > larghezza N candele fa

//--- Filtri d'ingresso (config validata: entrambi ON)
input group "=== Filtri trend (default ON) ==="
input bool         InpUseKumoFilter = true;        // Long solo sopra la nuvola, short sotto
input bool         InpUseHTFFilter  = true;        // Concordanza con un time frame superiore
input ENUM_TIMEFRAMES InpHTF        = PERIOD_H1;    // Time frame del filtro superiore
input bool         InpUseADXFilter  = true;        // Filtro forza del trend (no mercato laterale)
input int          InpADXPeriod     = 14;          // Periodo ADX
input double       InpADXThreshold  = 30.0;       // Soglia ADX (sotto = laterale, niente trade)

//--- Conferma Heikin Ashi (opzionale)
input group "=== Conferma Heikin Ashi ==="
input bool   InpUseHAFilter   = false; // Entra solo se le candele Heikin Ashi confermano la direzione
input int    InpHAConfirmBars = 1;     // Quante candele HA consecutive devono confermare

//--- Uscita
input group "=== Uscita ==="
input bool   InpExitOnOppositeCross = true;  // Esci sull'incrocio Tenkan/Kijun opposto
input bool   InpUseTimeExit = false;         // Uscita a tempo: chiudi dopo N candele
input int    InpBarsInTrade  = 3;            // Numero di candele prima di chiudere (uscita a tempo)

//--- Rischio e gestione (tutto in ATR)
input group "=== Rischio e gestione (ATR) ==="
input int    InpATRPeriod      = 14;   // Periodo ATR
input double InpATR_SL         = 2.75; // Stop Loss iniziale = X x ATR
input double InpATR_PartialAt  = 1.0;  // Parzializza dopo +X x ATR di profitto
input double InpPartialPercent = 0;    // % da chiudere alla parziale (0 = parziale disattivata)
input bool   InpBreakevenAtPartial = false; // Alla parziale, sposta lo SL a pareggio
input double InpATR_TrailStart = 1.0;  // Il trailing parte dopo +X x ATR di profitto
input double InpATR_Trail      = 4.0;  // Distanza del trailing = X x ATR
input double InpRiskPercent    = 0.50; // Rischio per trade (% del capitale)

//--- Filtro orario (sessioni) — VALIDATO ON: migliora la costanza
input group "=== Filtro orario (sessioni) ==="
input bool   InpUseSessionFilter = true;  // Opera solo in una fascia oraria (ora del server)
input int    InpStartHour        = 8;     // Ora di inizio (server)
input int    InpEndHour          = 22;    // Ora di fine (server, esclusa)

//--- Generali
input group "=== Generali ==="
input long   InpMagic     = 250604;    // Numero magico
input int    InpMaxSpread = 50;        // Spread massimo (punti); 0 = nessun limite

//==================================================================
//  HANDLE E STATO
//==================================================================
int hIchimoku    = INVALID_HANDLE;
int hIchimokuHTF = INVALID_HANDLE;
int hBands       = INVALID_HANDLE;
int hATR         = INVALID_HANDLE;
int hADX         = INVALID_HANDLE;

datetime lastBarTime  = 0;
long     g_ticket     = 0;       // ticket della posizione in gestione
bool     g_partialDone= false;   // parziale gia' eseguita su questa posizione
int      g_barsHeld   = 0;       // candele trascorse dall'ingresso (uscita a tempo)

//+------------------------------------------------------------------+
//| Inizializzazione                                                 |
//+------------------------------------------------------------------+
int OnInit()
  {
   hIchimoku    = iIchimoku(_Symbol, _Period, InpTenkan, InpKijun, InpSenkouB);
   hIchimokuHTF = iIchimoku(_Symbol, InpHTF,  InpTenkan, InpKijun, InpSenkouB);
   hBands       = iBands(_Symbol, _Period, InpBBPeriod, 0, InpBBDev, PRICE_CLOSE);
   hATR         = iATR(_Symbol, _Period, InpATRPeriod);
   hADX         = iADX(_Symbol, _Period, InpADXPeriod);

   if(hIchimoku == INVALID_HANDLE || hIchimokuHTF == INVALID_HANDLE ||
      hBands == INVALID_HANDLE || hATR == INVALID_HANDLE || hADX == INVALID_HANDLE)
     {
      Print("ERRORE: impossibile creare gli handle degli indicatori.");
      return(INIT_FAILED);
     }

   trade.SetExpertMagicNumber(InpMagic);
   trade.SetTypeFillingBySymbol(_Symbol);

   Print("IchiCross_Gold_722 avviato su ", _Symbol, " ",
         EnumToString((ENUM_TIMEFRAMES)_Period));
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Deinizializzazione                                               |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   if(hIchimoku    != INVALID_HANDLE) IndicatorRelease(hIchimoku);
   if(hIchimokuHTF != INVALID_HANDLE) IndicatorRelease(hIchimokuHTF);
   if(hBands       != INVALID_HANDLE) IndicatorRelease(hBands);
   if(hATR         != INVALID_HANDLE) IndicatorRelease(hATR);
   if(hADX         != INVALID_HANDLE) IndicatorRelease(hADX);
  }

//+------------------------------------------------------------------+
//| Ad ogni tick                                                     |
//+------------------------------------------------------------------+
void OnTick()
  {
   //--- la gestione della posizione (parziale + breakeven + trailing)
   //    va aggiornata a ogni tick
   ManageOpenPosition();

   //--- ingressi e uscite su incrocio: solo all'apertura di una nuova candela
   if(!IsNewBar())
      return;

   //--- se ho una posizione aperta: valuto le uscite (tempo / incrocio opposto)
   if(HasOpenPosition())
     {
      //--- uscita a tempo: chiudi dopo N candele dall'ingresso
      if(InpUseTimeExit)
        {
         g_barsHeld++;
         if(g_barsHeld >= InpBarsInTrade)
           { CloseCurrent(); return; }
        }
      if(InpExitOnOppositeCross)
        {
         int    cross = GetCross();
         long   type  = PositionGetInteger(POSITION_TYPE);
         if(type == POSITION_TYPE_BUY  && cross < 0) CloseCurrent();
         else if(type == POSITION_TYPE_SELL && cross > 0) CloseCurrent();
        }
      return;
     }

   //--- nessuna posizione: valuto un nuovo ingresso
   if(!SpreadOK())
      return;
   if(!SessionOk())          // fuori dalla fascia oraria: niente nuovi ingressi
      return;

   int signal = GetEntrySignal();   // +1 long, -1 short, 0 niente
   if(signal > 0)
      OpenTrade(ORDER_TYPE_BUY);
   else if(signal < 0)
      OpenTrade(ORDER_TYPE_SELL);
  }

//+------------------------------------------------------------------+
//| True una sola volta per ogni nuova candela                       |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   datetime t = (datetime)SeriesInfoInteger(_Symbol, _Period, SERIES_LASTBAR_DATE);
   if(t != lastBarTime)
     {
      lastBarTime = t;
      return(true);
     }
   return(false);
  }

//+------------------------------------------------------------------+
//| Incrocio Tenkan/Kijun sull'ultima candela chiusa                 |
//|  +1 = incrocio verso l'alto, -1 = verso il basso, 0 = nessuno    |
//+------------------------------------------------------------------+
int GetCross()
  {
   double tenkan[2], kijun[2];
   ArraySetAsSeries(tenkan, true);
   ArraySetAsSeries(kijun,  true);

   //--- copio le ultime 2 candele chiuse: [0] = candela 1, [1] = candela 2
   if(CopyBuffer(hIchimoku, 0, 1, 2, tenkan) < 2) return(0);
   if(CopyBuffer(hIchimoku, 1, 1, 2, kijun)  < 2) return(0);

   bool crossUp   = (tenkan[1] <= kijun[1]) && (tenkan[0] > kijun[0]);
   bool crossDown = (tenkan[1] >= kijun[1]) && (tenkan[0] < kijun[0]);

   if(crossUp)   return(+1);
   if(crossDown) return(-1);
   return(0);
  }

//+------------------------------------------------------------------+
//| Le bande di Bollinger sono in espansione?                        |
//|  (larghezza candela 1 > larghezza di InpBBExpandLookback fa)     |
//+------------------------------------------------------------------+
bool BandsExpanding()
  {
   int count = InpBBExpandLookback + 1;          // serve l'indice [lookback]
   if(count < 2) count = 2;

   double upper[], lower[];
   ArraySetAsSeries(upper, true);
   ArraySetAsSeries(lower, true);

   if(CopyBuffer(hBands, 1, 1, count, upper) < count) return(false); // 1 = UPPER
   if(CopyBuffer(hBands, 2, 1, count, lower) < count) return(false); // 2 = LOWER

   double widthNow  = upper[0] - lower[0];
   double widthPast = upper[InpBBExpandLookback] - lower[InpBBExpandLookback];

   return(widthNow > widthPast);
  }

//+------------------------------------------------------------------+
//| Filtro nuvola Kumo (opzionale): prezzo dalla parte giusta        |
//+------------------------------------------------------------------+
bool KumoOk(int dir)
  {
   double spanA[1], spanB[1];
   if(CopyBuffer(hIchimoku, 2, 1, 1, spanA) < 1) return(false); // SENKOU SPAN A
   if(CopyBuffer(hIchimoku, 3, 1, 1, spanB) < 1) return(false); // SENKOU SPAN B

   double kumoTop = MathMax(spanA[0], spanB[0]);
   double kumoBot = MathMin(spanA[0], spanB[0]);
   double close1  = iClose(_Symbol, _Period, 1);

   if(dir > 0) return(close1 > kumoTop);
   if(dir < 0) return(close1 < kumoBot);
   return(false);
  }

//+------------------------------------------------------------------+
//| Filtro time frame superiore (opzionale)                          |
//+------------------------------------------------------------------+
bool HtfOk(int dir)
  {
   double tenkan[1], kijun[1];
   if(CopyBuffer(hIchimokuHTF, 0, 1, 1, tenkan) < 1) return(false);
   if(CopyBuffer(hIchimokuHTF, 1, 1, 1, kijun)  < 1) return(false);

   if(dir > 0) return(tenkan[0] > kijun[0]);
   if(dir < 0) return(tenkan[0] < kijun[0]);
   return(false);
  }

//+------------------------------------------------------------------+
//| Filtro forza del trend: ADX sopra la soglia (no laterale)        |
//+------------------------------------------------------------------+
bool AdxOk()
  {
   double adx[1];
   if(CopyBuffer(hADX, 0, 1, 1, adx) < 1) return(false); // buffer 0 = linea ADX
   return(adx[0] >= InpADXThreshold);
  }

//+------------------------------------------------------------------+
//| Filtro Heikin Ashi: le ultime candele HA confermano la direzione |
//|  (long = HA rialziste, short = HA ribassiste)                    |
//+------------------------------------------------------------------+
bool HaOk(int dir)
  {
   int need = (InpHAConfirmBars < 1) ? 1 : InpHAConfirmBars;
   int n    = need + 60;          // candele extra per stabilizzare la ricorsione HA

   double o[], h[], l[], c[];
   ArraySetAsSeries(o,true); ArraySetAsSeries(h,true);
   ArraySetAsSeries(l,true); ArraySetAsSeries(c,true);
   if(CopyOpen (_Symbol,_Period,1,n,o) < n) return(false);
   if(CopyHigh (_Symbol,_Period,1,n,h) < n) return(false);
   if(CopyLow  (_Symbol,_Period,1,n,l) < n) return(false);
   if(CopyClose(_Symbol,_Period,1,n,c) < n) return(false);

   //--- calcolo HA dal piu' vecchio (n-1) al piu' recente (0)
   double haOpen[], haClose[];
   ArrayResize(haOpen,n); ArrayResize(haClose,n);
   int old = n - 1;
   haClose[old] = (o[old]+h[old]+l[old]+c[old]) / 4.0;
   haOpen[old]  = (o[old]+c[old]) / 2.0;
   for(int i = old-1; i >= 0; i--)
     {
      haClose[i] = (o[i]+h[i]+l[i]+c[i]) / 4.0;
      haOpen[i]  = (haOpen[i+1] + haClose[i+1]) / 2.0;
     }

   //--- le ultime 'need' candele HA (index 0..need-1) devono concordare
   for(int k = 0; k < need; k++)
     {
      bool bull = haClose[k] > haOpen[k];
      if(dir > 0 && !bull) return(false);
      if(dir < 0 &&  bull) return(false);
     }
   return(true);
  }

//+------------------------------------------------------------------+
//| Segnale d'ingresso completo (incrocio + filtri)                  |
//+------------------------------------------------------------------+
int GetEntrySignal()
  {
   int cross = GetCross();
   if(cross == 0)            return(0);
   if(!BandsExpanding())     return(0);     // niente trade in compressione
   if(InpUseADXFilter  && !AdxOk())       return(0);  // niente trade nel laterale
   if(InpUseKumoFilter && !KumoOk(cross)) return(0);
   if(InpUseHTFFilter  && !HtfOk(cross))  return(0);
   if(InpUseHAFilter   && !HaOk(cross))   return(0);  // conferma Heikin Ashi
   return(cross);
  }

//+------------------------------------------------------------------+
//| Valore ATR sull'ultima candela chiusa                            |
//+------------------------------------------------------------------+
double ATRvalue()
  {
   double atr[1];
   if(CopyBuffer(hATR, 0, 1, 1, atr) < 1) return(0);
   return(atr[0]);
  }

//+------------------------------------------------------------------+
//| Apre una posizione con SL su ATR e lotto da rischio %            |
//+------------------------------------------------------------------+
void OpenTrade(ENUM_ORDER_TYPE type)
  {
   double atr = ATRvalue();
   if(atr <= 0) return;

   double slDistance = InpATR_SL * atr;

   double price = (type == ORDER_TYPE_BUY)
                  ? SymbolInfoDouble(_Symbol, SYMBOL_ASK)
                  : SymbolInfoDouble(_Symbol, SYMBOL_BID);

   double sl = (type == ORDER_TYPE_BUY) ? price - slDistance : price + slDistance;

   int digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   sl    = NormalizeDouble(sl, digits);
   price = NormalizeDouble(price, digits);

   double lot = CalcLotByRisk(slDistance);
   if(lot <= 0) return;

   //--- nessun take profit: usciamo con trailing / parziale / incrocio opposto
   bool ok;
   if(type == ORDER_TYPE_BUY)
      ok = trade.Buy(lot, _Symbol, price, sl, 0, "IchiCross long");
   else
      ok = trade.Sell(lot, _Symbol, price, sl, 0, "IchiCross short");

   if(!ok)
      Print("Apertura ordine FALLITA. Retcode=", trade.ResultRetcode(),
            " - ", trade.ResultRetcodeDescription());
  }

//+------------------------------------------------------------------+
//| Lotto tale che la perdita allo SL sia ~ InpRiskPercent %         |
//+------------------------------------------------------------------+
double CalcLotByRisk(double slDistancePrice)
  {
   double balance   = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskMoney = balance * InpRiskPercent / 100.0;

   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0 || tickValue <= 0) return(0);

   double ticks      = slDistancePrice / tickSize;
   double lossPerLot = ticks * tickValue;
   if(lossPerLot <= 0) return(0);

   double lot = riskMoney / lossPerLot;

   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

   lot = MathFloor(lot / lotStep) * lotStep;
   lot = MathMax(minLot, MathMin(maxLot, lot));
   return(lot);
  }

//+------------------------------------------------------------------+
//| Gestione posizione aperta: parziale + breakeven + trailing       |
//+------------------------------------------------------------------+
void ManageOpenPosition()
  {
   if(!PositionSelect(_Symbol))
      return;
   if(PositionGetInteger(POSITION_MAGIC) != InpMagic)
      return;

   //--- nuova posizione? azzero lo stato della parziale
   long ticket = PositionGetInteger(POSITION_TICKET);
   if(ticket != g_ticket)
     {
      g_ticket      = ticket;
      g_partialDone = false;
      g_barsHeld    = 0;          // nuova posizione: azzero il contatore candele
     }

   double atr = ATRvalue();
   if(atr <= 0) return;

   int    digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   long   type   = PositionGetInteger(POSITION_TYPE);
   double openP  = PositionGetDouble(POSITION_PRICE_OPEN);
   double volume = PositionGetDouble(POSITION_VOLUME);
   double bid    = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask    = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   //--- profitto corrente in prezzo (a favore)
   double profitPrice = (type == POSITION_TYPE_BUY) ? (bid - openP) : (openP - ask);

   //--- 1) PARZIALE + BREAKEVEN (una sola volta)
   if(!g_partialDone && profitPrice >= InpATR_PartialAt * atr)
     {
      double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
      double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);

      double closeVol = volume * InpPartialPercent / 100.0;
      closeVol = MathFloor(closeVol / lotStep) * lotStep;

      //--- parzializzo solo se il residuo resta >= lotto minimo
      if(closeVol >= minLot && (volume - closeVol) >= minLot)
         trade.PositionClosePartial(_Symbol, closeVol);

      //--- breakeven: SL a pareggio
      if(InpBreakevenAtPartial && PositionSelect(_Symbol))
        {
         double be    = NormalizeDouble(openP, digits);
         double curSL = PositionGetDouble(POSITION_SL);
         bool   improve = (type == POSITION_TYPE_BUY) ? (be > curSL)
                                                      : (curSL == 0 || be < curSL);
         if(improve)
            trade.PositionModify(_Symbol, be, PositionGetDouble(POSITION_TP));
        }

      g_partialDone = true;
     }

   //--- 2) TRAILING dinamico in ATR
   if(profitPrice >= InpATR_TrailStart * atr && PositionSelect(_Symbol))
     {
      double trailDist = InpATR_Trail * atr;
      double curSL     = PositionGetDouble(POSITION_SL);

      if(type == POSITION_TYPE_BUY)
        {
         double newSL = NormalizeDouble(bid - trailDist, digits);
         if(newSL > curSL)
            trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
        }
      else
        {
         double newSL = NormalizeDouble(ask + trailDist, digits);
         if(curSL == 0 || newSL < curSL)
            trade.PositionModify(_Symbol, newSL, PositionGetDouble(POSITION_TP));
        }
     }
  }

//+------------------------------------------------------------------+
//| Chiude la posizione corrente di questo EA                        |
//+------------------------------------------------------------------+
void CloseCurrent()
  {
   if(trade.PositionClose(_Symbol))
     {
      g_ticket      = 0;
      g_partialDone = false;
      g_barsHeld    = 0;
     }
  }

//+------------------------------------------------------------------+
//| C'e' una posizione aperta di QUESTO EA?                          |
//+------------------------------------------------------------------+
bool HasOpenPosition()
  {
   if(!PositionSelect(_Symbol))
      return(false);
   return(PositionGetInteger(POSITION_MAGIC) == InpMagic);
  }

//+------------------------------------------------------------------+
//| Spread accettabile?                                              |
//+------------------------------------------------------------------+
bool SpreadOK()
  {
   if(InpMaxSpread <= 0)
      return(true);
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   return(spread <= InpMaxSpread);
  }

//+------------------------------------------------------------------+
//| Siamo nella fascia oraria operativa? (ora del server)            |
//+------------------------------------------------------------------+
bool SessionOk()
  {
   if(!InpUseSessionFilter)
      return(true);
   MqlDateTime t;
   TimeToStruct(TimeCurrent(), t);
   int h = t.hour;
   if(InpStartHour <= InpEndHour)
      return(h >= InpStartHour && h < InpEndHour);
   //--- fascia che attraversa la mezzanotte
   return(h >= InpStartHour || h < InpEndHour);
  }
//+------------------------------------------------------------------+
