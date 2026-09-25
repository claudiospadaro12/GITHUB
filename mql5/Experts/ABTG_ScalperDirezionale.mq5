//+------------------------------------------------------------------+
//|                                     ABTG_ScalperDirezionale.mq5  |
//|  Scalper a cicli brevi che segue il VERSO deciso da Claudio.     |
//|                                                                  |
//|  Richiesta di Claudio (25/09/2026), testuale:                    |
//|  "CHE ENTRA SEMPRE CON LO STESSO MIO SEGNO DI INGRESSO, LONG O   |
//|   SHORT. E CHE CHIUDA OPERAZIONI APPENA VA SOPRA DI QUALCHE      |
//|   EURO ED APPENA GENERA UN GUADAGNO X, AUMENTA I LOTTI           |
//|   PROGRESSIVAMENTE. DEVE FARE OPERAZIONI BREVI. 10 SECONDI       |
//|   MASSIMO."  -  "LO USO SUL MANUALE DEMO."                       |
//|                                                                  |
//|  SOLO DEMO (conto manuale 50503635, C:\MT5_MANUALE).             |
//|  NON per FTMO (tetto 2.000 richieste/giorno, Forbidden           |
//|  Practices) e NON per il conto reale 10105439.                   |
//|                                                                  |
//|  Cosa fa: una posizione alla volta nel verso scelto; chiude a    |
//|  +InpTargetEuro netti, o a -InpStopEuro netti (stop anche sul    |
//|  server), o dopo InpMaxSeconds; poi rientra. Il lotto SALE solo  |
//|  quando il guadagno chiuso cresce (anti-martingala), MAI dopo    |
//|  una perdita. Freni fissi: perdita di sessione, stop di fila,    |
//|  ordini al minuto, richieste al giorno. Ogni ciclo va in un CSV. |
//|  Modo CANDELA (aggiunto su richiesta, 25/09 sera): una sola     |
//|  operazione per candela (M1 consigliato), verso dal PRIMO        |
//|  MOVIMENTO della candela nuova (dopo N secondi) o dalla candela  |
//|  precedente. Non e' una strategia: e' un test misurato dal CSV. |
//|  I numeri onesti sono nel referto di casa.                       |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.00"
#property strict
#include <Trade\Trade.mqh>

enum ENUM_DIR_MODE   { DIR_FROM_MANUAL=0, DIR_LONG=1, DIR_SHORT=2 };
enum ENUM_ENTRY_MODE { ENTRY_MANUALE=0, ENTRY_CANDELA=1 };
enum ENUM_CANDLE_RULE { CR_PREV_CANDLE=0, CR_FIRST_MOVE=1 };

input group "=== Modo d'ingresso ==="
input ENUM_ENTRY_MODE InpEntryMode       = ENTRY_MANUALE;   // MANUALE: verso dalla tua posizione (o fisso), rientra subito. CANDELA: una operazione per candela
input ENUM_TIMEFRAMES InpCandleTF        = PERIOD_M1;       // CANDELA: timeframe della candela (M1 consigliato)
input ENUM_CANDLE_RULE InpCandleRule     = CR_FIRST_MOVE;   // CANDELA: verso dal PRIMO MOVIMENTO della candela nuova, oppure dalla candela PRECEDENTE
input int           InpFirstMoveSeconds  = 3;               // CANDELA/primo movimento: secondi dopo l'apertura in cui si legge il verso
input double        InpFirstMovePoints   = 1.0;             // CANDELA/primo movimento: movimento minimo in punti per decidere (sotto: si salta la candela)

input group "=== Verso e avvio (modo MANUALE) ==="
input ENUM_DIR_MODE InpDirection          = DIR_FROM_MANUAL; // Verso: dalla TUA prima posizione a mano, oppure fisso
input bool          InpAutoStart          = false;           // true = parte da solo appena conosce il verso (altrimenti pulsante START)
input bool          InpStopWhenManualClosed = true;          // si ferma se chiudi la posizione manuale che ha dato il verso

input group "=== Ciclo ==="
input double        InpTargetEuro         = 3.0;             // chiude in utile a +X euro NETTI
input double        InpStopEuro           = 2.0;             // chiude in perdita a -Y euro NETTI (stop anche sul server)
input int           InpMaxSeconds         = 10;              // durata massima di una posizione (secondi)
input int           InpPauseMs            = 500;             // pausa fra una chiusura e il rientro (ms)

input group "=== Lotti (salgono SOLO col guadagno) ==="
input double        InpLotStart           = 0.01;            // lotto di partenza
input double        InpLotStep            = 0.01;            // aumento del lotto
input double        InpStepEveryEuro      = 10.0;            // ... ogni X euro di guadagno chiuso dall'avvio
input double        InpLotMax             = 0.10;            // tetto del lotto
input bool          InpResetOnLoss        = true;            // dopo una perdita si riparte dal lotto di partenza

input group "=== Freni (fissi) ==="
input double        InpMaxLossSessionEuro = 20.0;            // perdita massima chiusa dall'avvio: poi STOP
input int           InpMaxConsecutiveLosses = 3;             // stop di fila: poi STOP
input int           InpMaxTradesPerMinute = 6;               // aperture al minuto: oltre, aspetta
input int           InpMaxRequestsPerDay  = 500;             // richieste al server dall'avvio: poi STOP
input int           InpStartHour          = 0;               // ora SERVER da cui puo' operare
input int           InpEndHour            = 24;              // ora SERVER oltre la quale si ferma (24 = mai)

input group "=== Generali ==="
input long          InpMagic              = 779901;          // magic dell'EA (le posizioni a mano hanno magic 0)
input int           InpDeviationPts       = 50;              // slippage ammesso in punti
input bool          InpVerbose            = true;            // log nel giornale Esperti

//--- stato
CTrade   trade;
bool     gActive       = false;
int      gDir          = 0;      // 0 nessuno, +1 long, -1 short
bool     gDirFromManual= false;
ulong    gManualTicket = 0;
double   gLot          = 0.0;
double   gCumProgress  = 0.0;    // guadagno chiuso che fa salire il lotto (si azzera con InpResetOnLoss)
double   gCumTotal     = 0.0;    // netto chiuso dall'avvio
double   gLossSession  = 0.0;
int      gConsecLoss   = 0;
int      gCycles       = 0;
int      gRequests     = 0;
datetime gLastClose    = 0;
datetime gOpenTimes[];           // aperture recenti (per il tetto al minuto)
string   gStopReason   = "";
string   gLastAction   = "-";
string   gCsv          = "";
double   gLastProfitSeen = 0.0;
datetime gCandleDone   = 0;      // candela gia' usata (modo CANDELA)
double   gCandleOpen   = 0.0;
const string BTN = "ABTG_SCALPER_BTN";

//+------------------------------------------------------------------+
void Log(string s)
  {
   if(InpVerbose) Print("[SCALPER] ", s);
  }
//+------------------------------------------------------------------+
double NormLot(double lot)
  {
   double vmin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double vmax = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   if(step <= 0) step = vmin;
   lot = MathFloor(lot / step + 1e-9) * step;
   if(lot < vmin) lot = vmin;
   if(lot > vmax) lot = vmax;
   if(lot > InpLotMax) lot = MathFloor(InpLotMax / step + 1e-9) * step;
   if(lot < vmin) lot = vmin;
   return NormalizeDouble(lot, 8);
  }
//+------------------------------------------------------------------+
// distanza di prezzo che vale 'euro' per 'lot' lotti, gia' >= al minimo del broker
double EuroToPriceDist(double euro, double lot)
  {
   double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || ts <= 0 || lot <= 0) return 0.0;
   double dist = (euro / (lot * tv)) * ts;
   double minDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   if(dist < minDist) dist = minDist;
   return dist;
  }
//+------------------------------------------------------------------+
void DrawButton()
  {
   if(ObjectFind(0, BTN) < 0)
     {
      ObjectCreate(0, BTN, OBJ_BUTTON, 0, 0, 0);
      ObjectSetInteger(0, BTN, OBJPROP_CORNER, CORNER_LEFT_UPPER);
      ObjectSetInteger(0, BTN, OBJPROP_XDISTANCE, 10);
      ObjectSetInteger(0, BTN, OBJPROP_YDISTANCE, 25);
      ObjectSetInteger(0, BTN, OBJPROP_XSIZE, 160);
      ObjectSetInteger(0, BTN, OBJPROP_YSIZE, 28);
      ObjectSetInteger(0, BTN, OBJPROP_FONTSIZE, 10);
     }
   ObjectSetString(0, BTN, OBJPROP_TEXT, gActive ? "STOP  (scalper attivo)" : "START scalper");
   ObjectSetInteger(0, BTN, OBJPROP_BGCOLOR, gActive ? clrTomato : clrLimeGreen);
   ObjectSetInteger(0, BTN, OBJPROP_COLOR, clrBlack);
   ObjectSetInteger(0, BTN, OBJPROP_STATE, false);
  }
//+------------------------------------------------------------------+
void Status()
  {
   string dir = (gDir > 0 ? "LONG" : (gDir < 0 ? "SHORT" : "nessuno"));
   string s = "ABTG_ScalperDirezionale  " + _Symbol + "   modo: " + (InpEntryMode == ENTRY_CANDELA ? "CANDELA " + EnumToString(InpCandleTF) : "MANUALE") + "\n";
   s += "stato: " + (gActive ? "ATTIVO" : "FERMO") + (gStopReason != "" ? "  [" + gStopReason + "]" : "") + "\n";
   s += "verso: " + dir + (gDirFromManual ? " (dalla tua posizione a mano)" : "") + "\n";
   s += "lotto attuale: " + DoubleToString(gLot, 2) + "   cicli: " + IntegerToString(gCycles) + "\n";
   s += "netto chiuso: " + DoubleToString(gCumTotal, 2) + " EUR   perdita sessione: " + DoubleToString(gLossSession, 2) + " / " + DoubleToString(InpMaxLossSessionEuro, 2) + "\n";
   s += "stop di fila: " + IntegerToString(gConsecLoss) + " / " + IntegerToString(InpMaxConsecutiveLosses) + "   richieste: " + IntegerToString(gRequests) + " / " + IntegerToString(InpMaxRequestsPerDay) + "\n";
   s += "ultima azione: " + gLastAction;
   Comment(s);
  }
//+------------------------------------------------------------------+
void StopAll(string why)
  {
   gActive = false;
   gStopReason = why;
   gLastAction = "STOP: " + why;
   Log("STOP - " + why);
   DrawButton();
   Status();
  }
//+------------------------------------------------------------------+
void StartAll()
  {
   gActive = true;
   gStopReason = "";
   gCumProgress = 0.0;
   gCumTotal = 0.0;
   gLossSession = 0.0;
   gConsecLoss = 0;
   gCycles = 0;
   gRequests = 0;
   gLot = NormLot(InpLotStart);
   ArrayResize(gOpenTimes, 0);
   gLastAction = "START";
   Log("START - lotto " + DoubleToString(gLot, 2));
   DrawButton();
   Status();
  }
//+------------------------------------------------------------------+
int OnInit()
  {
   trade.SetExpertMagicNumber(InpMagic);
   trade.SetDeviationInPoints(InpDeviationPts);
   trade.SetTypeFilling(ORDER_FILLING_IOC);
   if(InpDirection == DIR_LONG)  { gDir = 1;  gDirFromManual = false; }
   if(InpDirection == DIR_SHORT) { gDir = -1; gDirFromManual = false; }
   gLot = NormLot(InpLotStart);
   gCsv = "abtg_scalper_" + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + ".csv";
   if(!FileIsExist(gCsv))
     {
      int h = FileOpen(gCsv, FILE_WRITE | FILE_CSV | FILE_ANSI, ';');
      if(h != INVALID_HANDLE)
        {
         FileWrite(h, "ora_chiusura", "simbolo", "verso", "lotto", "ingresso", "uscita", "secondi", "netto", "cumulato", "motivo");
         FileClose(h);
        }
     }
   DrawButton();
   Status();
   Log("caricato su " + _Symbol + " - conto " + IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN)) + " - SOLO DEMO");
   if(InpAutoStart && (gDir != 0 || InpEntryMode == ENTRY_CANDELA)) StartAll();
   EventSetMillisecondTimer(250);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ObjectDelete(0, BTN);
   Comment("");
  }
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
  {
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == BTN)
     {
      if(gActive) StopAll("pulsante");
      else
        {
         if(InpEntryMode == ENTRY_MANUALE && gDir == 0) { gLastAction = "START rifiutato: verso sconosciuto (apri prima una posizione a mano)"; Log(gLastAction); DrawButton(); Status(); }
         else StartAll();
        }
     }
  }
//+------------------------------------------------------------------+
// posizione manuale (magic 0) sul simbolo: ritorna ticket e verso
bool FindManual(ulong &ticket, int &dir)
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != 0) continue;
      ticket = t;
      dir = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? 1 : -1;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
bool FindMine(ulong &ticket)
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong t = PositionGetTicket(i);
      if(t == 0 || !PositionSelectByTicket(t)) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      ticket = t;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
int OpensLastMinute()
  {
   int n = 0;
   datetime now = TimeCurrent();
   for(int i = 0; i < ArraySize(gOpenTimes); i++)
      if(now - gOpenTimes[i] < 60) n++;
   return n;
  }
//+------------------------------------------------------------------+
double NetOfPosition(ulong posId)
  {
   double net = 0.0;
   if(!HistorySelectByPosition(posId)) return 0.0;
   int tot = HistoryDealsTotal();
   for(int i = 0; i < tot; i++)
     {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      net += HistoryDealGetDouble(d, DEAL_PROFIT) + HistoryDealGetDouble(d, DEAL_COMMISSION) + HistoryDealGetDouble(d, DEAL_SWAP);
     }
   return net;
  }
//+------------------------------------------------------------------+
void WriteCsv(string verso, double lot, double pin, double pout, int secs, double net, string why)
  {
   int h = FileOpen(gCsv, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI, ';');
   if(h == INVALID_HANDLE) return;
   FileSeek(h, 0, SEEK_END);
   FileWrite(h, TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS), _Symbol, verso, DoubleToString(lot, 2),
             DoubleToString(pin, _Digits), DoubleToString(pout, _Digits), IntegerToString(secs),
             DoubleToString(net, 2), DoubleToString(gCumTotal, 2), why);
   FileClose(h);
  }
//+------------------------------------------------------------------+
void AfterClose(ulong posId, string verso, double lot, double pin, double pout, int secs, string why)
  {
   double net = NetOfPosition(posId);
   gCycles++;
   gCumTotal += net;
   if(net > 0)
     {
      gConsecLoss = 0;
      gCumProgress += net;
      double steps = MathFloor(gCumProgress / MathMax(InpStepEveryEuro, 0.01));
      gLot = NormLot(InpLotStart + steps * InpLotStep);
     }
   else if(net < 0)
     {
      gConsecLoss++;
      gLossSession += -net;
      if(InpResetOnLoss) { gCumProgress = 0.0; gLot = NormLot(InpLotStart); }
     }
   WriteCsv(verso, lot, pin, pout, secs, net, why);
   gLastAction = "chiuso " + why + " netto " + DoubleToString(net, 2) + " -> lotto " + DoubleToString(gLot, 2);
   Log(gLastAction);
   gLastClose = TimeCurrent();
   if(gLossSession >= InpMaxLossSessionEuro) StopAll("perdita di sessione " + DoubleToString(gLossSession, 2) + " >= " + DoubleToString(InpMaxLossSessionEuro, 2));
   else if(gConsecLoss >= InpMaxConsecutiveLosses) StopAll(IntegerToString(gConsecLoss) + " stop di fila");
  }
//+------------------------------------------------------------------+
void ManageOpen(ulong ticket)
  {
   if(!PositionSelectByTicket(ticket)) return;
   double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   gLastProfitSeen = profit;
   datetime opened = (datetime)PositionGetInteger(POSITION_TIME);
   int age = (int)(TimeCurrent() - opened);
   double pin = PositionGetDouble(POSITION_PRICE_OPEN);
   double lot = PositionGetDouble(POSITION_VOLUME);
   ulong posId = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
   string verso = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? "LONG" : "SHORT";
   string why = "";
   if(profit >= InpTargetEuro) why = "target";
   else if(profit <= -InpStopEuro) why = "stop";
   else if(age >= InpMaxSeconds) why = "tempo";
   if(why == "") return;
   double pout = (verso == "LONG") ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   gRequests++;
   if(trade.PositionClose(ticket))
     {
      AfterClose(posId, verso, lot, pin, pout, age, why);
     }
   else
     {
      gLastAction = "chiusura RIFIUTATA (" + IntegerToString(trade.ResultRetcode()) + ") - riprovo al prossimo tick";
      Log(gLastAction);
     }
  }
//+------------------------------------------------------------------+
void TryOpen()
  {
   if(InpEntryMode == ENTRY_CANDELA)
     {
      datetime bt = iTime(_Symbol, InpCandleTF, 0);
      if(bt == 0) return;
      if(bt == gCandleDone) { gLastAction = "candela gia' usata: aspetto la prossima"; return; }
      double op = iOpen(_Symbol, InpCandleTF, 0);
      int dir = 0;
      if(InpCandleRule == CR_PREV_CANDLE)
        {
         double po = iOpen(_Symbol, InpCandleTF, 1), pc = iClose(_Symbol, InpCandleTF, 1);
         if(pc > po) dir = 1; else if(pc < po) dir = -1;
        }
      else
        {
         if(TimeCurrent() - bt < InpFirstMoveSeconds) { gLastAction = "candela nuova: leggo il verso fra " + IntegerToString(InpFirstMoveSeconds) + " s"; return; }
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double mv = (bid - op) / _Point;
         if(mv >= InpFirstMovePoints) dir = 1; else if(mv <= -InpFirstMovePoints) dir = -1;
        }
      gCandleDone = bt;   // una sola decisione per candela, anche se si salta
      if(dir == 0) { gLastAction = "candela senza verso: saltata"; return; }
      gDir = dir; gDirFromManual = false;
     }
   if(gDir == 0) return;
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   if(dt.hour < InpStartHour || dt.hour >= InpEndHour) { gLastAction = "fuori orario"; return; }
   if(gRequests >= InpMaxRequestsPerDay) { StopAll("tetto richieste " + IntegerToString(InpMaxRequestsPerDay)); return; }
   if(OpensLastMinute() >= InpMaxTradesPerMinute) { gLastAction = "attesa: tetto aperture al minuto"; return; }
   if(gLastClose > 0 && (TimeCurrent() - gLastClose) * 1000 < InpPauseMs && GetTickCount() % 1000 < (uint)InpPauseMs) { return; }
   double lot = NormLot(gLot);
   double slDist = EuroToPriceDist(InpStopEuro, lot);
   double tpDist = EuroToPriceDist(InpTargetEuro, lot);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl = 0, tp = 0;
   bool ok = false;
   gRequests++;
   if(gDir > 0)
     {
      sl = NormalizeDouble(ask - slDist, _Digits);
      tp = NormalizeDouble(ask + tpDist, _Digits);
      ok = trade.Buy(lot, _Symbol, 0.0, sl, tp, "SCALPER LONG");
     }
   else
     {
      sl = NormalizeDouble(bid + slDist, _Digits);
      tp = NormalizeDouble(bid - tpDist, _Digits);
      ok = trade.Sell(lot, _Symbol, 0.0, sl, tp, "SCALPER SHORT");
     }
   if(ok && trade.ResultRetcode() == TRADE_RETCODE_DONE)
     {
      int n = ArraySize(gOpenTimes);
      ArrayResize(gOpenTimes, n + 1);
      gOpenTimes[n] = TimeCurrent();
      gLastAction = "aperto " + (gDir > 0 ? "LONG " : "SHORT ") + DoubleToString(lot, 2) + " sl " + DoubleToString(sl, _Digits) + " tp " + DoubleToString(tp, _Digits);
      Log(gLastAction);
     }
   else
     {
      // se lo stop e' rifiutato (troppo vicino), riprova senza stop sul server: lo stop morbido resta
      uint rc = trade.ResultRetcode();
      if(rc == TRADE_RETCODE_INVALID_STOPS)
        {
         gRequests++;
         ok = (gDir > 0) ? trade.Buy(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER LONG (stop morbido)")
                         : trade.Sell(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER SHORT (stop morbido)");
         if(ok && trade.ResultRetcode() == TRADE_RETCODE_DONE)
           {
            int n = ArraySize(gOpenTimes);
            ArrayResize(gOpenTimes, n + 1);
            gOpenTimes[n] = TimeCurrent();
            gLastAction = "aperto SENZA stop sul server (troppo vicino al minimo del broker): stop morbido a -" + DoubleToString(InpStopEuro, 2) + " EUR";
            Log(gLastAction);
            return;
           }
        }
      gLastAction = "apertura RIFIUTATA (" + IntegerToString((int)rc) + ")";
      Log(gLastAction);
      gLastClose = TimeCurrent(); // piccola pausa prima di riprovare
     }
  }
//+------------------------------------------------------------------+
void Work()
  {
   // verso dalla posizione a mano
   ulong mt = 0; int md = 0;
   bool manual = FindManual(mt, md);
   if(InpEntryMode == ENTRY_MANUALE && InpDirection == DIR_FROM_MANUAL)
     {
      if(gDir == 0 && manual) { gDir = md; gDirFromManual = true; gManualTicket = mt; gLastAction = "verso preso dalla tua posizione: " + (md > 0 ? "LONG" : "SHORT"); Log(gLastAction); if(InpAutoStart && !gActive) StartAll(); }
      if(gActive && gDirFromManual && InpStopWhenManualClosed && !manual) { StopAll("posizione manuale chiusa"); gDir = 0; gDirFromManual = false; }
     }
   if(!gActive) { Status(); return; }
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) { gLastAction = "Algo Trading spento"; Status(); return; }
   ulong mine = 0;
   if(FindMine(mine)) ManageOpen(mine);
   else TryOpen();
   Status();
  }
//+------------------------------------------------------------------+
void OnTick()  { Work(); }
void OnTimer() { Work(); }   // il tempo massimo scatta anche senza tick
//+------------------------------------------------------------------+
