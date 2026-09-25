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
//|  SOLO DEMO (conto manuale 50503635, C:\MT5_MANUALE): il conto e' |
//|  CONTROLLATO in OnInit (login + demo + hedging), non solo scritto|
//|  qui. NON per FTMO (tetto 2.000 richieste/giorno, Forbidden      |
//|  Practices) e NON per il conto reale 10105439.                   |
//|                                                                  |
//|  Cosa fa: una posizione alla volta nel verso scelto; chiude a    |
//|  +InpTargetEuro netti, o a -InpStopEuro netti (stop anche sul    |
//|  server), o dopo InpMaxSeconds; poi rientra. Il lotto SALE solo  |
//|  quando il guadagno chiuso cresce (anti-martingala), MAI dopo    |
//|  una perdita. Freni fissi: perdita di sessione, stop di fila,    |
//|  ordini al minuto, richieste dall'avvio. Ogni ciclo va in un CSV,|
//|  ANCHE se a chiudere e' stato lo SL/TP del server.               |
//|  Modo CANDELA (aggiunto su richiesta, 25/09 sera): una sola     |
//|  operazione per candela (M1 consigliato), verso dal PRIMO        |
//|  MOVIMENTO della candela nuova (dopo N secondi) o dalla candela  |
//|  precedente; oppure dai TICK: verso dal movimento degli ultimi   |
//|  N tick (default 5, minimo 1 punto), senza candele.              |
//|  Non e' una strategia: e' un test misurato dal CSV.             |
//|  I numeri onesti sono nel referto di casa.                       |
//|                                                                  |
//|  1.01 (25/09 sera, dopo il cancello - FAIL con 6 bloccanti):     |
//|   B1 conto controllato in OnInit e in TryOpen                    |
//|   B2 VOLUME_MIN > lotto dichiarato -> NON parte (niente taglie   |
//|      alzate in silenzio)                                         |
//|   B3 contabilita' per identificativo di posizione: le chiusure   |
//|      del server (SL/TP) passano dai freni e dal CSV              |
//|   B4 la posizione aperta si gestisce SEMPRE, anche da FERMO      |
//|   B5 orologio = TimeTradeServer(), i 10 s scattano senza tick    |
//|   B6 pausa vera in ms; un rifiuto aspetta 5 s; 5 rifiuti = STOP  |
//|  1.02 (seconda passata del cancello, PASS con residui):          |
//|   N1 "chiusura mandata" scade dopo 3 s: se il server non esegue  |
//|      (PLACED/PARTIAL) si rimanda, la posizione non resta orfana  |
//|   N2 OnDeinit chiude solo se il conto e' quello ammesso          |
//|   N3 identificativo di posizione letto dal deal d'ingresso       |
//|   N4 "perdite di fila" (conta anche le uscite a tempo);          |
//|      motivo di chiusura dal DEAL_REASON (sl/tp/a mano)           |
//|   pulsante START spostato sotto il pannello (il trading rapido   |
//|      di MT5 lo copriva: visto da Claudio il 25/09 sera)          |
//+------------------------------------------------------------------+
#property copyright "ABTG"
#property version   "1.02"
#include <Trade\Trade.mqh>

#define CONTO_AMMESSO 50503635   // il SOLO conto su cui questo EA accetta di girare

enum ENUM_DIR_MODE   { DIR_FROM_MANUAL=0, DIR_LONG=1, DIR_SHORT=2 };
enum ENUM_ENTRY_MODE { ENTRY_MANUALE=0, ENTRY_CANDELA=1 };
enum ENUM_CANDLE_RULE { CR_PREV_CANDLE=0, CR_FIRST_MOVE=1, CR_TICK=2 };

input group "=== Modo d'ingresso ==="
input ENUM_ENTRY_MODE InpEntryMode       = ENTRY_MANUALE;   // MANUALE: verso dalla tua posizione (o fisso), rientra subito. CANDELA: una operazione per candela
input ENUM_TIMEFRAMES InpCandleTF        = PERIOD_M1;       // CANDELA: timeframe della candela (M1 consigliato)
input ENUM_CANDLE_RULE InpCandleRule     = CR_TICK;         // CANDELA: verso dal PRIMO MOVIMENTO della candela, dalla candela PRECEDENTE, oppure dai TICK (senza candele)
input int           InpTickWindow        = 5;               // TICK: numero di tick su cui si misura il movimento
input int           InpFirstMoveSeconds  = 3;               // CANDELA/primo movimento: secondi dopo l'apertura in cui si legge il verso
input double        InpFirstMovePoints   = 1.0;             // CANDELA/primo movimento e TICK: movimento minimo in PUNTI MT5 (_Point) per decidere

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
input int           InpMaxRequestsPerDay  = 500;             // richieste al server dall'avvio (START le azzera): poi STOP
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
double   gLot          = 0.0;
double   gCumProgress  = 0.0;    // guadagno chiuso che fa salire il lotto (si azzera con InpResetOnLoss)
double   gCumTotal     = 0.0;    // netto chiuso dall'avvio
double   gLossSession  = 0.0;
int      gConsecLoss   = 0;
int      gCycles       = 0;
int      gRequests     = 0;
int      gRejects      = 0;      // aperture rifiutate di fila
datetime gOpenTimes[];           // aperture recenti (per il tetto al minuto)
string   gStopReason   = "";
string   gLastAction   = "-";
string   gCsv          = "";
double   gLastProfitSeen = 0.0;
datetime gCandleDone   = 0;      // candela gia' usata (modo CANDELA)
double   gTicks[];               // ultimi bid (modo TICK)
//--- pause in millisecondi (GetTickCount, differenza unsigned: regge il giro del contatore)
uint     gPauseFromMs  = 0;
uint     gPauseLenMs   = 0;
uint     gCloseRetryMs = 0;
uint     gCloseSentMs  = 0;
//--- la posizione in corso, per identificativo (B3): cosi' le chiusure del server vengono contate
ulong    gOpenPosId    = 0;
string   gOpenVerso    = "";
double   gOpenLot      = 0.0;
double   gOpenPin      = 0.0;
double   gClosePout    = 0.0;
datetime gOpenTime     = 0;
string   gCloseWhy     = "";
uint     gGoneMs       = 0;
const string BTN = "ABTG_SCALPER_BTN";

//+------------------------------------------------------------------+
void Log(string s)
  {
   if(InpVerbose) Print("[SCALPER] ", s);
  }
//+------------------------------------------------------------------+
bool ContoAmmesso()
  {
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   return (login == CONTO_AMMESSO
           && AccountInfoInteger(ACCOUNT_TRADE_MODE) == ACCOUNT_TRADE_MODE_DEMO
           && AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);
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
// distanza di prezzo che vale 'euro' per 'lot' lotti, gia' >= al minimo del broker (+ spread)
double EuroToPriceDist(double euro, double lot)
  {
   double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || ts <= 0 || lot <= 0) return 0.0;
   double dist = (euro / (lot * tv)) * ts;
   double spread = SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double minDist = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point + MathMax(spread, 0.0);
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
      ObjectSetInteger(0, BTN, OBJPROP_YDISTANCE, 150);   // sotto il pannello di stato: il trading rapido di MT5 copre l'angolo in alto
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
   string modo = (InpEntryMode == ENTRY_MANUALE) ? "MANUALE" : (InpCandleRule == CR_TICK ? "TICK (" + IntegerToString(InpTickWindow) + " tick, min " + DoubleToString(InpFirstMovePoints, 1) + " pt)" : "CANDELA " + EnumToString(InpCandleTF));
   string s = "ABTG_ScalperDirezionale 1.02  " + _Symbol + "   modo: " + modo + "\n";
   s += "stato: " + (gActive ? "ATTIVO" : "FERMO (premi START)") + (gStopReason != "" ? "  [" + gStopReason + "]" : "") + "\n";
   s += "verso: " + dir + (gDirFromManual ? " (dalla tua posizione a mano)" : "") + "\n";
   s += "lotto attuale: " + DoubleToString(gLot, 2) + "   cicli: " + IntegerToString(gCycles) + (gOpenPosId != 0 ? "   posizione aperta: " + IntegerToString((long)gOpenPosId) : "") + "\n";
   s += "netto chiuso: " + DoubleToString(gCumTotal, 2) + " EUR   perdita sessione: " + DoubleToString(gLossSession, 2) + " / " + DoubleToString(InpMaxLossSessionEuro, 2) + "\n";
   s += "perdite di fila: " + IntegerToString(gConsecLoss) + " / " + IntegerToString(InpMaxConsecutiveLosses) + "   richieste: " + IntegerToString(gRequests) + " / " + IntegerToString(InpMaxRequestsPerDay) + "\n";
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
   gRejects = 0;
   gPauseLenMs = 0;
   gLot = NormLot(InpLotStart);
   ArrayResize(gOpenTimes, 0);
   ArrayResize(gTicks, 0);
   gLastAction = "START";
   Log("START - lotto " + DoubleToString(gLot, 2));
   DrawButton();
   Status();
  }
//+------------------------------------------------------------------+
int OnInit()
  {
   long login = AccountInfoInteger(ACCOUNT_LOGIN);
   if(!ContoAmmesso())
     {
      Alert("ABTG_ScalperDirezionale: SOLO demo hedging ", CONTO_AMMESSO, " - qui ", login, ": NON parto");
      return(INIT_FAILED);
     }
   double vmin = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   if(vmin > InpLotStart + 1e-9 || vmin > InpLotMax + 1e-9)
     {
      Alert("ABTG_ScalperDirezionale: VOLUME_MIN ", DoubleToString(vmin, 2), " su ", _Symbol, " > lotto dichiarato: NON alzo la taglia da solo, NON parto");
      return(INIT_FAILED);
     }
   trade.SetExpertMagicNumber((ulong)InpMagic);
   trade.SetDeviationInPoints((ulong)InpDeviationPts);
   trade.SetTypeFillingBySymbol(_Symbol);
   if(InpDirection == DIR_LONG)  { gDir = 1;  gDirFromManual = false; }
   if(InpDirection == DIR_SHORT) { gDir = -1; gDirFromManual = false; }
   gLot = NormLot(InpLotStart);
   gCsv = "abtg_scalper_" + IntegerToString(login) + ".csv";
   if(!FileIsExist(gCsv))
     {
      int h = FileOpen(gCsv, FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_READ, ';');
      if(h != INVALID_HANDLE)
        {
         FileWrite(h, "ora_chiusura", "simbolo", "verso", "lotto", "ingresso", "uscita", "secondi", "netto", "cumulato", "motivo");
         FileClose(h);
        }
      else Log("CSV non creato (" + IntegerToString(GetLastError()) + "): " + gCsv);
     }
   DrawButton();
   Status();
   Log("1.02 caricato su " + _Symbol + " - conto " + IntegerToString(login) + " - SOLO DEMO - vmin " + DoubleToString(vmin, 2)
       + " tickvalue " + DoubleToString(SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE), 4)
       + " stopslevel " + IntegerToString(SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)));
   if(InpAutoStart && (gDir != 0 || InpEntryMode == ENTRY_CANDELA)) StartAll();
   EventSetMillisecondTimer(250);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   // una posizione dello scalper SENZA stop sul server non si lascia nuda quando l'EA viene staccato
   ulong mine = 0;
   if(reason != REASON_CHARTCHANGE && ContoAmmesso() && FindMine(mine) && PositionSelectByTicket(mine) && PositionGetDouble(POSITION_SL) == 0.0)
     {
      Log("stacco con posizione senza stop sul server: la chiudo (" + IntegerToString((long)mine) + ")");
      trade.PositionClose(mine);
     }
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
   datetime now = TimeTradeServer();
   int k = 0;
   for(int i = 0; i < ArraySize(gOpenTimes); i++)
      if(now - gOpenTimes[i] < 60) gOpenTimes[k++] = gOpenTimes[i];
   ArrayResize(gOpenTimes, k);
   return k;
  }
//+------------------------------------------------------------------+
// netto della posizione dallo storico; true solo se c'e' il deal di USCITA
bool NetOfPosition(ulong posId, double &net, double &pout, string &reason)
  {
   net = 0.0; pout = 0.0; reason = "";
   bool out = false;
   if(!HistorySelectByPosition((long)posId)) return false;
   int tot = HistoryDealsTotal();
   for(int i = 0; i < tot; i++)
     {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      net += HistoryDealGetDouble(d, DEAL_PROFIT) + HistoryDealGetDouble(d, DEAL_COMMISSION) + HistoryDealGetDouble(d, DEAL_SWAP) + HistoryDealGetDouble(d, DEAL_FEE);
      long e = HistoryDealGetInteger(d, DEAL_ENTRY);
      if(e == DEAL_ENTRY_OUT || e == DEAL_ENTRY_OUT_BY)
        {
         out = true; pout = HistoryDealGetDouble(d, DEAL_PRICE);
         long r = HistoryDealGetInteger(d, DEAL_REASON);
         reason = (r == DEAL_REASON_SL ? "server SL" : (r == DEAL_REASON_TP ? "server TP" : (r == DEAL_REASON_EXPERT ? "" : "chiusa a mano/altro")));
        }
     }
   return out;
  }
//+------------------------------------------------------------------+
void WriteCsv(string verso, double lot, double pin, double pout, int secs, double net, string why)
  {
   int h = FileOpen(gCsv, FILE_READ | FILE_WRITE | FILE_CSV | FILE_ANSI | FILE_SHARE_READ, ';');
   if(h == INVALID_HANDLE) { Log("CSV non scrivibile (" + IntegerToString(GetLastError()) + "): riga persa"); return; }
   FileSeek(h, 0, SEEK_END);
   FileWrite(h, TimeToString(TimeTradeServer(), TIME_DATE | TIME_SECONDS), _Symbol, verso, DoubleToString(lot, 2),
             DoubleToString(pin, _Digits), DoubleToString(pout, _Digits), IntegerToString(secs),
             DoubleToString(net, 2), DoubleToString(gCumTotal, 2), why);
   FileClose(h);
  }
//+------------------------------------------------------------------+
void AfterClose(double net, string verso, double lot, double pin, double pout, int secs, string why)
  {
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
   gPauseFromMs = GetTickCount();
   gPauseLenMs = (uint)MathMax(InpPauseMs, 0);
   if(gLossSession >= InpMaxLossSessionEuro) StopAll("perdita di sessione " + DoubleToString(gLossSession, 2) + " >= " + DoubleToString(InpMaxLossSessionEuro, 2));
   else if(gConsecLoss >= InpMaxConsecutiveLosses) StopAll(IntegerToString(gConsecLoss) + " perdite di fila");
  }
//+------------------------------------------------------------------+
// B3: chiude i conti della posizione in corso quando non c'e' piu' (chiusa da noi O dal server).
// true = niente in sospeso, si puo' procedere.
bool Settle()
  {
   if(gOpenPosId == 0) return true;
   if(PositionSelectByTicket(gOpenPosId)) { gGoneMs = 0; return true; }
   if(gGoneMs == 0) gGoneMs = GetTickCount();
   double net = 0, pout = 0; string reason = "";
   if(!NetOfPosition(gOpenPosId, net, pout, reason))
     {
      if((uint)(GetTickCount() - gGoneMs) < 3000) return false;   // storico in arrivo: aspetta, non apre
      if(gCloseWhy == "") { StopAll("posizione sparita senza deal di uscita"); gOpenPosId = 0; gGoneMs = 0; return false; }
      net = gLastProfitSeen; pout = gClosePout; gCloseWhy += " (netto stimato)";
     }
   string why = (gCloseWhy != "" ? gCloseWhy : (reason != "" ? reason : "server SL/TP"));
   int secs = (int)(TimeTradeServer() - gOpenTime);
   gOpenPosId = 0; gGoneMs = 0; gCloseWhy = "";
   AfterClose(net, gOpenVerso, gOpenLot, gOpenPin, pout, secs, why);
   return true;
  }
//+------------------------------------------------------------------+
void Adopt(ulong ticket)   // dopo un riavvio: la posizione dello scalper gia' aperta entra nei conti
  {
   if(!PositionSelectByTicket(ticket)) return;
   gOpenPosId = (ulong)PositionGetInteger(POSITION_IDENTIFIER);
   gOpenVerso = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? "LONG" : "SHORT";
   gOpenLot   = PositionGetDouble(POSITION_VOLUME);
   gOpenPin   = PositionGetDouble(POSITION_PRICE_OPEN);
   gOpenTime  = (datetime)PositionGetInteger(POSITION_TIME);
   gCloseWhy  = ""; gGoneMs = 0;
   Log("posizione adottata: " + IntegerToString((long)gOpenPosId));
  }
//+------------------------------------------------------------------+
void ManageOpen(ulong ticket)
  {
   if(!PositionSelectByTicket(ticket)) return;
   if(gOpenPosId == 0) Adopt(ticket);
   if(ticket == gOpenPosId && gCloseWhy != "")            // chiusura gia' mandata: evita il doppio close...
     {
      if((uint)(GetTickCount() - gCloseSentMs) < 3000) return;
      Log("chiusura (" + gCloseWhy + ") mandata 3 s fa, posizione ancora aperta: riprovo");   // ...ma non per sempre (N1)
      gCloseWhy = "";
     }
   double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
   gLastProfitSeen = profit;
   datetime opened = (datetime)PositionGetInteger(POSITION_TIME);
   int age = (int)(TimeTradeServer() - opened);
   string verso = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? "LONG" : "SHORT";
   string why = "";
   if(profit >= InpTargetEuro) why = "target";
   else if(profit <= -InpStopEuro) why = "stop";
   else if(age >= InpMaxSeconds) why = "tempo";
   if(why == "") return;
   if(gCloseRetryMs != 0 && (uint)(GetTickCount() - gCloseRetryMs) < 1000) return;   // chiusura rifiutata: si riprova dopo 1 s
   double pout = (verso == "LONG") ? SymbolInfoDouble(_Symbol, SYMBOL_BID) : SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   gRequests++;
   if(trade.PositionClose(ticket) && trade.ResultRetcode() == TRADE_RETCODE_DONE)
     {
      gCloseWhy = why; gClosePout = pout; gCloseRetryMs = 0; gCloseSentMs = GetTickCount();
      gLastAction = "chiusura mandata (" + why + ")";
     }
   else
     {
      gCloseRetryMs = GetTickCount();
      gLastAction = "chiusura RIFIUTATA (" + IntegerToString((int)trade.ResultRetcode()) + ") - riprovo fra 1 s";
      Log(gLastAction);
     }
  }
//+------------------------------------------------------------------+
void Registra(double lot)   // apertura riuscita: la posizione entra nei conti
  {
   gOpenPosId = trade.ResultOrder();
   if(trade.ResultDeal() > 0 && HistoryDealSelect(trade.ResultDeal()))
      gOpenPosId = (ulong)HistoryDealGetInteger(trade.ResultDeal(), DEAL_POSITION_ID);   // N3: l'identificativo vero, dal deal d'ingresso
   gOpenVerso = (gDir > 0 ? "LONG" : "SHORT");
   gOpenLot   = lot;
   gOpenPin   = trade.ResultPrice();
   gOpenTime  = TimeTradeServer();
   gCloseWhy  = ""; gGoneMs = 0; gRejects = 0; gCloseRetryMs = 0;
   int n = ArraySize(gOpenTimes);
   ArrayResize(gOpenTimes, n + 1);
   gOpenTimes[n] = gOpenTime;
  }
//+------------------------------------------------------------------+
void TryOpen()
  {
   if(!ContoAmmesso()) { StopAll("conto non ammesso"); return; }
   // cancelli PRIMA della decisione del verso (che consuma tick o candela)
   MqlDateTime dt; TimeToStruct(TimeTradeServer(), dt);
   if(dt.hour < InpStartHour || dt.hour >= InpEndHour) { gLastAction = "fuori orario"; return; }
   if(gRequests >= InpMaxRequestsPerDay) { StopAll("tetto richieste " + IntegerToString(InpMaxRequestsPerDay)); return; }
   if(OpensLastMinute() >= InpMaxTradesPerMinute) { gLastAction = "attesa: tetto aperture al minuto"; return; }
   if(gPauseLenMs > 0 && (uint)(GetTickCount() - gPauseFromMs) < gPauseLenMs) return;
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_TICK)
     {
      int n = ArraySize(gTicks);
      if(n < MathMax(InpTickWindow, 2)) { gLastAction = "TICK: raccolgo " + IntegerToString(n) + "/" + IntegerToString(InpTickWindow) + " tick"; return; }
      double mv = (gTicks[n - 1] - gTicks[0]) / _Point;
      int dir = 0;
      if(mv >= InpFirstMovePoints) dir = 1; else if(mv <= -InpFirstMovePoints) dir = -1;
      if(dir == 0) { gLastAction = "TICK: movimento " + DoubleToString(mv, 1) + " pt, sotto il minimo: aspetto"; return; }
      ArrayResize(gTicks, 0);   // dopo la decisione si ricomincia a contare
      gDir = dir; gDirFromManual = false;
     }
   else if(InpEntryMode == ENTRY_CANDELA)
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
         if(TimeTradeServer() - bt < InpFirstMoveSeconds) { gLastAction = "candela nuova: leggo il verso fra " + IntegerToString(InpFirstMoveSeconds) + " s"; return; }
         double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
         double mv = (bid - op) / _Point;
         if(mv >= InpFirstMovePoints) dir = 1; else if(mv <= -InpFirstMovePoints) dir = -1;
        }
      gCandleDone = bt;   // una sola decisione per candela, anche se si salta
      if(dir == 0) { gLastAction = "candela senza verso: saltata"; return; }
      gDir = dir; gDirFromManual = false;
     }
   if(gDir == 0) return;
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
      Registra(lot);
      gLastAction = "aperto " + (gDir > 0 ? "LONG " : "SHORT ") + DoubleToString(lot, 2) + " sl " + DoubleToString(sl, _Digits) + " tp " + DoubleToString(tp, _Digits);
      Log(gLastAction);
      return;
     }
   // se lo stop e' rifiutato (troppo vicino), UN tentativo senza stop sul server: lo stop morbido resta
   uint rc = trade.ResultRetcode();
   if(rc == TRADE_RETCODE_INVALID_STOPS)
     {
      gRequests++;
      ok = (gDir > 0) ? trade.Buy(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER LONG (stop morbido)")
                      : trade.Sell(lot, _Symbol, 0.0, 0.0, 0.0, "SCALPER SHORT (stop morbido)");
      if(ok && trade.ResultRetcode() == TRADE_RETCODE_DONE)
        {
         Registra(lot);
         gLastAction = "aperto SENZA stop sul server (troppo vicino al minimo del broker): stop morbido a -" + DoubleToString(InpStopEuro, 2) + " EUR";
         Log(gLastAction);
         return;
        }
      rc = trade.ResultRetcode();
     }
   // rifiuto: pausa di 5 s, e al quinto rifiuto di fila STOP (niente raffiche verso il server)
   gPauseFromMs = GetTickCount();
   gPauseLenMs = 5000;
   gRejects++;
   gLastAction = "apertura RIFIUTATA (" + IntegerToString((int)rc) + ") - " + IntegerToString(gRejects) + "/5, riprovo fra 5 s";
   Log(gLastAction);
   if(gRejects >= 5) StopAll("5 aperture rifiutate di fila, ultimo codice " + IntegerToString((int)rc));
  }
//+------------------------------------------------------------------+
void Work()
  {
   if(InpEntryMode == ENTRY_CANDELA && InpCandleRule == CR_TICK)
     {
      double b = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      int n = ArraySize(gTicks);
      if(n == 0 || gTicks[n - 1] != b) { ArrayResize(gTicks, n + 1); gTicks[n] = b; if(n + 1 > MathMax(InpTickWindow, 2)) ArrayRemove(gTicks, 0, 1); }
     }
   // verso dalla posizione a mano
   ulong mt = 0; int md = 0;
   bool manual = FindManual(mt, md);
   if(InpEntryMode == ENTRY_MANUALE && InpDirection == DIR_FROM_MANUAL)
     {
      if(gDir == 0 && manual) { gDir = md; gDirFromManual = true; gLastAction = "verso preso dalla tua posizione: " + (md > 0 ? "LONG" : "SHORT"); Log(gLastAction); if(InpAutoStart && !gActive) StartAll(); }
      else if(gDirFromManual && manual && md != gDir) { gDir = md; gLastAction = "verso aggiornato dalla tua posizione: " + (md > 0 ? "LONG" : "SHORT"); Log(gLastAction); }
      if(gActive && gDirFromManual && InpStopWhenManualClosed && !manual) { StopAll("posizione manuale chiusa"); gDir = 0; gDirFromManual = false; }
     }
   // B3/B4: prima si chiudono i conti della posizione appena sparita, poi si gestisce quella aperta, SEMPRE (anche da FERMO)
   if(!Settle()) { Status(); return; }
   ulong mine = 0;
   if(FindMine(mine)) { ManageOpen(mine); Status(); return; }
   if(!gActive) { Status(); return; }
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) { gLastAction = "Algo Trading spento"; Status(); return; }
   TryOpen();
   Status();
  }
//+------------------------------------------------------------------+
void OnTick()  { Work(); }
void OnTimer() { Work(); }   // il tempo massimo scatta anche senza tick (orologio TimeTradeServer)
//+------------------------------------------------------------------+
