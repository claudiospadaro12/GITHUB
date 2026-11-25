//+------------------------------------------------------------------+
//|                                                  ABTG_CpiM5.mq5  |
//|  Breakout bidirezionale SOLO sulla candela M5 della news CPI USA |
//|  Buy Stop + Sell Stop a T-5 minuti, OCO, uscita a fine M5.       |
//|  DEMO / tester. Nessuna garanzia. Ora = ORA SERVER del broker.   |
//|  v1.00 (25/11/2026)                                              |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gTrade;

//==================== INPUT ====================
input group "=== Notizia (date in ORA SERVER) ==="
input int    InpNewsMode      = 2;                  // 0=solo CSV, 1=solo calendario MT5, 2=auto (tester: CSV; live: calendario, CSV di riserva)
input string InpCsvFile       = "abtg_cpi_dates.csv"; // in Common\Files; una data per riga: AAAA.MM.GG HH:MM
input string InpNewsKeyword   = "CPI";              // calendario: il nome evento contiene (USD)
input bool   InpOnlyHigh      = true;               // calendario: solo impatto alto
input int    InpTimeShiftSec  = 0;                  // correzione dell'orario della news (secondi)

input group "=== Tempi ==="
input int    InpPreSec        = 300;                // piazza gli ordini a T - secondi
input int    InpExitSec       = 299;                // chiude tutto a T + secondi (299 = ultimo secondo della M5)
input bool   InpExitNextBar   = false;              // true: chiude al primo tick della M5 successiva (T + 300)

input group "=== Livelli ==="
input int    InpLevelMode     = 1;                  // 0=A distanza fissa dal prezzo, 1=B max/min dell'ultima M5 chiusa + buffer
input int    InpFixedPoints   = 400;                // A: distanza in punti dal prezzo
input int    InpBufferPoints  = 100;                // B: buffer in punti oltre max/min della M5 precedente
input int    InpRepriceSec    = 0;                  // A: ricalcola i pendenti ogni N secondi fino a T-InpFreezeSec (0=off)
input int    InpFreezeSec     = 10;                 // niente piu modifiche negli ultimi N secondi prima di T
input int    InpExtraStopsPts = 10;                // punti extra oltre STOPS_LEVEL e spread

input group "=== Gestione ==="
input bool   InpUseOCO        = true;               // al primo scatto cancella l'altro pendente
input int    InpSlMode        = 0;                  // 0=SL sul livello opposto, 1=SL fisso in punti
input int    InpSlPoints      = 600;                // SL fisso (punti)
input int    InpMaxSpreadPts  = 0;                  // 0=nessun filtro; altrimenti niente ordini se lo spread supera
input double InpLots          = 0.10;               // lotto fisso
input double InpRiskPct       = 0.0;                // 0=lotto fisso; altrimenti % di equity rischiata sullo SL

input group "=== Generali ==="
input long   InpMagic         = 770801;
input string InpComment       = "CPI M5";
input bool   InpDraw          = true;               // linee dei livelli sul grafico
input bool   InpVerbose       = true;               // log nel Journal

//==================== STATO ====================
datetime gNews[];                 // orari news (server), ordinati
datetime gCalLoaded = 0;
int      gState = 0;              // 0=attesa, 1=ordini piazzati
datetime gT = 0;                  // news attiva
datetime gLastDone = 0;           // ultima news gestita
ulong    gBuyTk = 0, gSellTk = 0;
double   gBuyLvl = 0, gSellLvl = 0, gReqBuy = 0, gReqSell = 0;
datetime gLastReprice = 0;
double   gPnl = 0;

void Log(const string m) { if(InpVerbose) Print("[CpiM5] ", m); }

//+------------------------------------------------------------------+
datetime Now() { return (datetime)TimeCurrent(); }

//+------------------------------------------------------------------+
//| Carica le date dal CSV                                           |
//+------------------------------------------------------------------+
int LoadCsv(datetime &out[])
  {
   int h = FileOpen(InpCsvFile, FILE_READ | FILE_TXT | FILE_ANSI | FILE_COMMON);
   if(h == INVALID_HANDLE) { Log("CSV non trovato in Common\\Files: " + InpCsvFile + " (err " + IntegerToString(GetLastError()) + ")"); return 0; }
   int n = 0;
   while(!FileIsEnding(h))
     {
      string s = FileReadString(h);
      StringTrimLeft(s); StringTrimRight(s);
      if(StringLen(s) < 10) continue;
      if(StringGetCharacter(s, 0) < '0' || StringGetCharacter(s, 0) > '9') continue;   // intestazione/commenti
      datetime t = StringToTime(s);
      if(t <= 0) continue;
      ArrayResize(out, n + 1); out[n++] = t;
     }
   FileClose(h);
   return n;
  }

//+------------------------------------------------------------------+
//| Carica le date dal calendario nativo (solo live)                 |
//+------------------------------------------------------------------+
int LoadCalendar(datetime &out[])
  {
   MqlCalendarValue vals[];
   datetime from = Now() - 2 * 86400, to = Now() + 45 * 86400;
   int got = CalendarValueHistory(vals, from, to, "US");
   if(got <= 0) { Log("calendario: nessun evento (err " + IntegerToString(GetLastError()) + ")"); return 0; }
   int n = 0;
   for(int i = 0; i < got; i++)
     {
      MqlCalendarEvent ev;
      if(!CalendarEventById(vals[i].event_id, ev)) continue;
      if(InpOnlyHigh && ev.importance != CALENDAR_IMPORTANCE_HIGH) continue;
      string up = ev.name; StringToUpper(up);
      string kw = InpNewsKeyword; StringToUpper(kw);
      if(StringFind(up, kw) < 0) continue;
      if(vals[i].time <= 0) continue;
      bool dup = false;
      for(int k = 0; k < n; k++) if(out[k] == vals[i].time) { dup = true; break; }
      if(dup) continue;
      ArrayResize(out, n + 1); out[n++] = vals[i].time;
     }
   return n;
  }

//+------------------------------------------------------------------+
void SortAsc(datetime &a[])
  {
   int n = ArraySize(a);
   for(int i = 1; i < n; i++) { datetime x = a[i]; int j = i - 1; while(j >= 0 && a[j] > x) { a[j + 1] = a[j]; j--; } a[j + 1] = x; }
  }

//+------------------------------------------------------------------+
void LoadNews()
  {
   datetime tmp[]; ArrayResize(tmp, 0);
   bool tester = (bool)MQLInfoInteger(MQL_TESTER);
   int n = 0;
   bool useCal = (InpNewsMode == 1) || (InpNewsMode == 2 && !tester);
   if(useCal) n = LoadCalendar(tmp);
   if(n == 0 && (InpNewsMode == 0 || InpNewsMode == 2)) n = LoadCsv(tmp);
   SortAsc(tmp);
   ArrayResize(gNews, n);
   for(int i = 0; i < n; i++) gNews[i] = tmp[i] + InpTimeShiftSec;
   gCalLoaded = Now();
   Log(StringFormat("date news caricate: %d (%s)", n, useCal && n > 0 ? "calendario" : "CSV"));
  }

//+------------------------------------------------------------------+
double Pt() { return SymbolInfoDouble(_Symbol, SYMBOL_POINT); }
double Norm(const double p) { double ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE); if(ts <= 0) ts = Pt(); return NormalizeDouble(MathRound(p / ts) * ts, _Digits); }

//+------------------------------------------------------------------+
int MyPositions()
  {
   int c = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     { ulong tk = PositionGetTicket(i); if(tk > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagic) c++; }
   return c;
  }

int MyOrders()
  {
   int c = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     { ulong tk = OrderGetTicket(i); if(tk > 0 && OrderGetString(ORDER_SYMBOL) == _Symbol && OrderGetInteger(ORDER_MAGIC) == InpMagic) c++; }
   return c;
  }

//+------------------------------------------------------------------+
void DeletePendings()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      ulong tk = OrderGetTicket(i);
      if(tk > 0 && OrderGetString(ORDER_SYMBOL) == _Symbol && OrderGetInteger(ORDER_MAGIC) == InpMagic)
         if(!gTrade.OrderDelete(tk)) Log("OrderDelete fallito " + IntegerToString((long)tk) + ": " + gTrade.ResultRetcodeDescription());
     }
  }

void CloseAllPositions()
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagic)
        {
         double pr = PositionGetDouble(POSITION_PRICE_OPEN);
         if(gTrade.PositionClose(tk)) Log(StringFormat("chiusa posizione %I64u (apertura %s)", tk, DoubleToString(pr, _Digits)));
         else Log("PositionClose fallito: " + gTrade.ResultRetcodeDescription());
        }
     }
  }

//+------------------------------------------------------------------+
double LotsFor(const double entry, const double sl)
  {
   double lot = InpLots;
   if(InpRiskPct > 0)
     {
      double risk = AccountInfoDouble(ACCOUNT_EQUITY) * InpRiskPct / 100.0, prof = 0;
      if(OrderCalcProfit(ORDER_TYPE_BUY, _Symbol, 1.0, entry, sl, prof) && MathAbs(prof) > 0) lot = risk / MathAbs(prof);
     }
   double step = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP), mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN), mx = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(step <= 0) step = 0.01;
   lot = MathFloor(lot / step) * step;
   return MathMax(mn, MathMin(mx, lot));
  }

//+------------------------------------------------------------------+
void DrawLevel(const string name, const double price, const color c)
  {
   if(!InpDraw) return;
   if(ObjectFind(0, name) < 0) ObjectCreate(0, name, OBJ_HLINE, 0, 0, price);
   ObjectSetDouble(0, name, OBJPROP_PRICE, price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, c);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASH);
  }

//+------------------------------------------------------------------+
//| Calcola i livelli; ritorna false se non validi                    |
//+------------------------------------------------------------------+
bool ComputeLevels(double &buy, double &sell)
  {
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK), bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   if(ask <= 0 || bid <= 0) return false;
   double pt = Pt();
   if(InpLevelMode == 1)
     {
      double hi = iHigh(_Symbol, PERIOD_M5, 1), lo = iLow(_Symbol, PERIOD_M5, 1);       // ultima M5 chiusa
      if(hi <= 0 || lo <= 0 || hi <= lo) return false;
      buy = hi + InpBufferPoints * pt; sell = lo - InpBufferPoints * pt;
     }
   else { buy = ask + InpFixedPoints * pt; sell = bid - InpFixedPoints * pt; }
   // distanza minima dal prezzo: STOPS_LEVEL + spread + extra
   double minDist = (SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) + (ask - bid) / pt + InpExtraStopsPts) * pt;
   if(buy < ask + minDist) buy = ask + minDist;
   if(sell > bid - minDist) sell = bid - minDist;
   buy = Norm(buy); sell = Norm(sell);
   return (buy > sell);
  }

//+------------------------------------------------------------------+
void PlaceOrders()
  {
   long spr = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   if(InpMaxSpreadPts > 0 && spr > InpMaxSpreadPts) { Log(StringFormat("spread %d > massimo %d: niente ordini per questa news", (int)spr, InpMaxSpreadPts)); gLastDone = gT; return; }
   double buy, sell;
   if(!ComputeLevels(buy, sell)) { Log("livelli non calcolabili: riprovo al prossimo tick"); return; }
   double slB, slS, pt = Pt();
   if(InpSlMode == 0) { slB = sell; slS = buy; } else { slB = buy - InpSlPoints * pt; slS = sell + InpSlPoints * pt; }
   slB = Norm(slB); slS = Norm(slS);
   datetime exp = gT + (InpExitNextBar ? 300 : InpExitSec) + 120;                     // scadenza di sicurezza dopo l'uscita prevista
   double lotB = LotsFor(buy, slB), lotS = LotsFor(sell, slS);
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetTypeFillingBySymbol(_Symbol);
   gTrade.SetDeviationInPoints(50);
   bool okB = gTrade.BuyStop(lotB, buy, _Symbol, slB, 0.0, ORDER_TIME_SPECIFIED, exp, InpComment + " BUY");
   gBuyTk = okB ? gTrade.ResultOrder() : 0;
   bool okS = gTrade.SellStop(lotS, sell, _Symbol, slS, 0.0, ORDER_TIME_SPECIFIED, exp, InpComment + " SELL");
   gSellTk = okS ? gTrade.ResultOrder() : 0;
   gBuyLvl = buy; gSellLvl = sell; gReqBuy = buy; gReqSell = sell; gLastReprice = Now();
   Log(StringFormat("PIAZZATI a %s (T-%d s) | BUY STOP %s SL %s lot %.2f %s | SELL STOP %s SL %s lot %.2f %s | spread %d pt | stops level %d",
       TimeToString(Now(), TIME_DATE | TIME_SECONDS), (int)(gT - Now()), DoubleToString(buy, _Digits), DoubleToString(slB, _Digits), lotB, okB ? "OK" : "FALLITO:" + gTrade.ResultRetcodeDescription(),
       DoubleToString(sell, _Digits), DoubleToString(slS, _Digits), lotS, okS ? "OK" : "FALLITO:" + gTrade.ResultRetcodeDescription(),
       (int)spr, (int)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)));
   DrawLevel("CPI_BUY", buy, clrLimeGreen); DrawLevel("CPI_SELL", sell, clrTomato);
   if(okB || okS) gState = 1; else { Log("ordini rifiutati: news saltata"); gLastDone = gT; }
  }

//+------------------------------------------------------------------+
void Reprice()
  {
   if(InpLevelMode != 0 || InpRepriceSec <= 0) return;
   if(MyPositions() > 0) return;
   if((long)(gT - Now()) <= InpFreezeSec) return;
   if(Now() - gLastReprice < InpRepriceSec) return;
   double buy, sell; if(!ComputeLevels(buy, sell)) return;
   double pt = Pt(), slB, slS;
   if(InpSlMode == 0) { slB = sell; slS = buy; } else { slB = buy - InpSlPoints * pt; slS = sell + InpSlPoints * pt; }
   datetime exp = gT + (InpExitNextBar ? 300 : InpExitSec) + 120;
   if(gBuyTk > 0 && OrderSelect(gBuyTk)) gTrade.OrderModify(gBuyTk, buy, Norm(slB), 0.0, ORDER_TIME_SPECIFIED, exp);
   if(gSellTk > 0 && OrderSelect(gSellTk)) gTrade.OrderModify(gSellTk, sell, Norm(slS), 0.0, ORDER_TIME_SPECIFIED, exp);
   gBuyLvl = buy; gSellLvl = sell; gReqBuy = buy; gReqSell = sell; gLastReprice = Now();
   DrawLevel("CPI_BUY", buy, clrLimeGreen); DrawLevel("CPI_SELL", sell, clrTomato);
  }

//+------------------------------------------------------------------+
void OcoCheck()
  {
   if(!InpUseOCO) return;
   if(MyPositions() > 0 && MyOrders() > 0) { DeletePendings(); Log("OCO: cancellato l'ordine pendente rimasto"); }
  }

//+------------------------------------------------------------------+
void Finish()
  {
   CloseAllPositions();
   DeletePendings();
   Log(StringFormat("FINE news %s: tutto chiuso/cancellato alle %s", TimeToString(gT, TIME_DATE | TIME_MINUTES), TimeToString(Now(), TIME_DATE | TIME_SECONDS)));
   gLastDone = gT; gState = 0; gPnl = 0;
   ObjectDelete(0, "CPI_BUY"); ObjectDelete(0, "CPI_SELL");
  }

//+------------------------------------------------------------------+
void Step()
  {
   datetime now = Now();
   // ricarica il calendario ogni 6 ore (solo live, fuori da una news)
   if(!(bool)MQLInfoInteger(MQL_TESTER) && InpNewsMode != 0 && now - gCalLoaded > 6 * 3600 && gState != 1) LoadNews();
   long endOff = InpExitNextBar ? 300 : InpExitSec;
   if(gState == 0)
     {
      datetime nxt = 0;
      for(int i = 0; i < ArraySize(gNews); i++)
         if(gNews[i] > gLastDone && (long)now <= (long)gNews[i] + endOff + 5) { nxt = gNews[i]; break; }
      if(nxt == 0) return;
      long toT = (long)nxt - (long)now;
      if(toT > InpPreSec) return;                                   // troppo presto
      gT = nxt;
      if(toT <= 0) { Log("news " + TimeToString(gT, TIME_DATE | TIME_MINUTES) + ": arrivato dopo T, nessun ordine"); gLastDone = gT; return; }
      PlaceOrders();
      return;
     }
   if(gState == 1)
     {
      OcoCheck();
      Reprice();
      if((long)now >= (long)gT + endOff) Finish();
     }
  }

//+------------------------------------------------------------------+
int OnInit()
  {
   gTrade.SetExpertMagicNumber(InpMagic);
   LoadNews();
   EventSetTimer(1);
   // ripresa dopo riavvio: se ci sono ordini/posizioni miei, riprende la gestione
   if(MyOrders() > 0 || MyPositions() > 0)
     {
      for(int i = 0; i < ArraySize(gNews); i++) if((long)gNews[i] + InpExitSec + 120 >= (long)Now()) { gT = gNews[i]; gState = 1; gLastDone = gT - 1; break; }
      Log("riavvio con ordini/posizioni aperte: gestione ripresa");
     }
   Log(StringFormat("avviato su %s, magic %I64d, pre %d s, uscita T+%d s, livelli modo %d", _Symbol, InpMagic, InpPreSec, InpExitSec, InpLevelMode));
   return INIT_SUCCEEDED;
  }

void OnDeinit(const int reason) { EventKillTimer(); }

void OnTick()  { Step(); }
void OnTimer() { Step(); }

//+------------------------------------------------------------------+
//| Misura lo slippage reale e applica l'OCO subito                  |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &request, const MqlTradeResult &result)
  {
   if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;
   if(!HistoryDealSelect(trans.deal)) return;
   if(HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != InpMagic) return;
   long entry = HistoryDealGetInteger(trans.deal, DEAL_ENTRY);
   double price = HistoryDealGetDouble(trans.deal, DEAL_PRICE);
   long type = HistoryDealGetInteger(trans.deal, DEAL_TYPE);
   if(entry == DEAL_ENTRY_IN)
     {
      double req = (type == DEAL_TYPE_BUY) ? gReqBuy : gReqSell;
      double slipPts = ((type == DEAL_TYPE_BUY) ? (price - req) : (req - price)) / Pt();
      Log(StringFormat("INGRESSO %s alle %s | prezzo richiesto %s, eseguito %s | slippage %.0f punti (positivo = sfavorevole)",
          type == DEAL_TYPE_BUY ? "BUY" : "SELL", TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS), DoubleToString(req, _Digits), DoubleToString(price, _Digits), slipPts));
      if(InpUseOCO && MyOrders() > 0) { DeletePendings(); Log("OCO: cancellato l'altro pendente"); }
     }
   else if(entry == DEAL_ENTRY_OUT)
     {
      double p = HistoryDealGetDouble(trans.deal, DEAL_PROFIT) + HistoryDealGetDouble(trans.deal, DEAL_COMMISSION) + HistoryDealGetDouble(trans.deal, DEAL_SWAP);
      gPnl += p;
      Log(StringFormat("USCITA alle %s a %s | profitto deal %.2f (somma news %.2f) | motivo %s", TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS), DoubleToString(price, _Digits), p, gPnl,
          (HistoryDealGetInteger(trans.deal, DEAL_REASON) == DEAL_REASON_SL) ? "SL" : "chiusura/altro"));
     }
  }
//+------------------------------------------------------------------+
