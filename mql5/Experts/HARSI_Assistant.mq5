//+------------------------------------------------------------------+
//| HARSI_Assistant.mq5                                             |
//| Trade-assistant per la strategia "Heikin Ashi RSI Oscillator"   |
//| (HARSI by JayRogers).                                           |
//|                                                                  |
//| DUE COMPITI:                                                     |
//|  (A) Mostra (e opzionalmente trada) la strategia HARSI a 4      |
//|      condizioni, valutata sulla barra appena CHIUSA (index 1).  |
//|  (B) Trade manager disciplinato: pulsanti BUY/SELL con lot      |
//|      a rischio %, SL su swing, TP a R:R; gestione posizioni     |
//|      manuali (aggancio SL/TP, warning over-size); governance    |
//|      del rischio totale.                                        |
//|                                                                  |
//| UNIVERSALE: funziona su qualsiasi simbolo (forex/indici/        |
//| commodity) e qualsiasi timeframe. NIENTE pip/contract/tick      |
//| value hardcoded: il valore monetario e' derivato da            |
//| SYMBOL_TRADE_TICK_VALUE / SYMBOL_TRADE_TICK_SIZE.               |
//|                                                                  |
//| ATTENZIONE: le distanze SL/TP sono NOSTRE definizioni (la       |
//| strategia originale e' paywalled). Validare in backtest.        |
//+------------------------------------------------------------------+
#property copyright "Claudio — HARSI Assistant"
#property version   "1.00"
#property strict

#include <Trade\Trade.mqh>
CTrade trade;

//==================================================================
// INPUT — Rischio / Gestione
//==================================================================
input group "=== Rischio / Gestione ==="
input double RiskPct             = 1.0;        // Rischio % del balance per trade
input double RR                  = 2.0;        // Reward:Risk per il TP
input int    MaxConcurrentTrades = 3;          // Max trade aperti contemporanei
input double MaxTotalRiskPct     = 3.0;        // Tetto rischio totale aperto (%)
input int    SwingLookback       = 10;         // Barre per swing high/low (SL)
input int    SL_BufferPoints     = 50;         // Buffer extra oltre lo swing (in _Point)

//==================================================================
// INPUT — Comportamento
//==================================================================
input group "=== Comportamento ==="
input bool   ManageManualTrades  = true;       // Aggancia SL/TP a posizioni manuali
input bool   AutoTradeSignals    = false;      // Auto-apri sul segnale HARSI (chiusura barra)
input bool   ShowPanel           = true;       // Mostra pulsanti BUY/SELL
input long   MagicNumber         = 20260626;   // Magic Number

//==================================================================
// INPUT — Indicatore HARSI (passati a iCustom)
//==================================================================
input group "=== HARSI ==="
input int    RSI_Length          = 14;         // RSI Length
input int    RSI_Smoothing       = 1;          // RSI Smoothing
input double UpperExtreme        = 30.0;       // Banda estrema sup (+30 ~ RSI80)
input double UpperMild           = 20.0;       // Banda lieve sup   (+20 ~ RSI70)
input double LowerMild           = -20.0;      // Banda lieve inf   (-20 ~ RSI30)
input double LowerExtreme        = -30.0;      // Banda estrema inf (-30 ~ RSI20)

//==================================================================
// COSTANTI buffer indicatore (devono combaciare con HARSI_JayRogers)
//==================================================================
#define BUF_HA_OPEN   0
#define BUF_HA_HIGH   1
#define BUF_HA_LOW    2
#define BUF_HA_CLOSE  3
#define BUF_HA_COLOR  4
#define BUF_RSI_LINE  5

//==================================================================
// Oggetti grafici
//==================================================================
#define BTN_BUY   "HARSI_BTN_BUY"
#define BTN_SELL  "HARSI_BTN_SELL"
#define LBL_INFO  "HARSI_LBL_INFO"
#define ARROW_PFX "HARSI_ARR_"

//==================================================================
// Globali
//==================================================================
int      hHARSI       = INVALID_HANDLE;
datetime g_lastBar    = 0;
string   g_sym;
int      g_digits;
double   g_point;

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
   g_sym    = _Symbol;
   g_digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
   g_point  = SymbolInfoDouble(g_sym, SYMBOL_POINT);

   trade.SetExpertMagicNumber(MagicNumber);
   trade.SetAsyncMode(false);
   trade.SetTypeFillingBySymbol(g_sym);

   //--- carica l'indicatore HARSI con gli stessi parametri
   //    ordine input HARSI_JayRogers: RSI_Length, RSI_Smoothing,
   //    SourcePrice, ShowRSILine, UpperExtreme, UpperMild,
   //    LowerMild, LowerExtreme
   hHARSI = iCustom(g_sym, _Period, "HARSI_JayRogers",
                    RSI_Length,
                    RSI_Smoothing,
                    0,        // SourcePrice = HARSI_CLOSE
                    true,     // ShowRSILine
                    UpperExtreme,
                    UpperMild,
                    LowerMild,
                    LowerExtreme);
   if(hHARSI == INVALID_HANDLE)
   {
      Print("ERRORE: impossibile caricare HARSI_JayRogers. ",
            "Compilare l'indicatore in Indicators/ prima dell'EA.");
      return(INIT_FAILED);
   }

   if(ShowPanel)
      CreatePanel();

   g_lastBar = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);

   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(hHARSI != INVALID_HANDLE)
      IndicatorRelease(hHARSI);

   ObjectDelete(0, BTN_BUY);
   ObjectDelete(0, BTN_SELL);
   ObjectDelete(0, LBL_INFO);
   // gli ObjectName con prefisso ARROW restano per riferimento storico;
   // li ripuliamo solo al deinit per disattivazione/rimozione EA
   if(reason == REASON_REMOVE)
      ObjectsDeleteAll(0, ARROW_PFX);

   Comment("");
}

//==================================================================
// LOT SIZING UNIVERSALE
//------------------------------------------------------------------
// moneyPerLotPerPricePoint = tickValue / tickSize
//   = valore in valuta-conto di un movimento di 1.0 unita' di
//     prezzo, per 1 lotto. Funziona su FX/indici/commodity perche'
//     deriva il valore dal tick value/size del simbolo stesso.
// rawLot = riskMoney / (stopDistancePrice * moneyPerLotPerPricePoint)
// Poi clamp a MIN/MAX e arrotondamento DOWN allo STEP.
//==================================================================
double MoneyPerLotPerPricePoint()
{
   double tickValue = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
   if(tickSize <= 0.0 || tickValue <= 0.0)
      return(0.0);
   return(tickValue / tickSize);
}

double RoundDownToStep(double lot)
{
   double step = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
   if(step <= 0.0) step = 0.01;
   double r = MathFloor(lot / step) * step;
   // normalizza per evitare residui float
   int lotDigits = (int)MathRound(MathLog10(1.0 / step));
   if(lotDigits < 0) lotDigits = 0;
   return(NormalizeDouble(r, lotDigits));
}

//------------------------------------------------------------------
// Calcola il lotto a rischio. Ritorna 0 (e Alert) se nemmeno il
// lotto minimo rispetta il budget di rischio.
//------------------------------------------------------------------
double CalcRiskLot(double stopDistancePrice, double riskPct)
{
   if(stopDistancePrice <= 0.0)
      return(0.0);

   double mppp = MoneyPerLotPerPricePoint();
   if(mppp <= 0.0)
   {
      Alert("HARSI: tickValue/tickSize non validi su ", g_sym, " — trade annullato.");
      return(0.0);
   }

   double riskMoney = AccountInfoDouble(ACCOUNT_BALANCE) * riskPct / 100.0;
   double rawLot    = riskMoney / (stopDistancePrice * mppp);

   double minLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
   double maxLot = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);

   double lot = RoundDownToStep(rawLot);
   if(lot < minLot)
   {
      // verifica se il lotto MINIMO rispetta il budget di rischio
      double minRisk = minLot * stopDistancePrice * mppp;
      if(minRisk > riskMoney)
      {
         Alert("HARSI: il lotto minimo (", DoubleToString(minLot,2),
               ") rischia ", DoubleToString(minRisk,2),
               " > budget ", DoubleToString(riskMoney,2),
               " — trade RIFIUTATO.");
         return(0.0);
      }
      lot = minLot;
   }
   if(lot > maxLot) lot = maxLot;

   return(lot);
}

//==================================================================
// GOVERNANCE RISCHIO
//------------------------------------------------------------------
// Somma del rischio aperto di tutte le posizioni dell'EA-symbol:
//   rischio = volume * |open - SL| * moneyPerLotPerPricePoint
//==================================================================
double CurrentOpenRiskPct()
{
   double mppp = MoneyPerLotPerPricePoint();
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   if(mppp <= 0.0 || bal <= 0.0)
      return(0.0);

   double total = 0.0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;

      double vol = PositionGetDouble(POSITION_VOLUME);
      double op  = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl  = PositionGetDouble(POSITION_SL);
      if(sl <= 0.0) continue; // senza SL non quantifichiamo (verra' agganciato)
      total += vol * MathAbs(op - sl) * mppp;
   }
   return(total / bal * 100.0);
}

int CountSymbolPositions()
{
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) == g_sym) n++;
   }
   return(n);
}

//==================================================================
// SWING high/low (su barre 1..SwingLookback, escludendo la 0)
//==================================================================
double SwingLow()
{
   double low[];
   ArraySetAsSeries(low, true);
   int need = SwingLookback + 1;
   if(CopyLow(g_sym, _Period, 0, need, low) < need)
      return(0.0);
   double lo = low[1];
   for(int i = 1; i <= SwingLookback; i++)
      lo = MathMin(lo, low[i]);
   return(lo);
}

double SwingHigh()
{
   double high[];
   ArraySetAsSeries(high, true);
   int need = SwingLookback + 1;
   if(CopyHigh(g_sym, _Period, 0, need, high) < need)
      return(0.0);
   double hi = high[1];
   for(int i = 1; i <= SwingLookback; i++)
      hi = MathMax(hi, high[i]);
   return(hi);
}

double BufferPrice()
{
   return(SL_BufferPoints * g_point);
}

//==================================================================
// APERTURA MANAGED (pulsanti)
//==================================================================
void OpenManaged(bool isBuy)
{
   //--- limiti
   if(CountSymbolPositions() >= MaxConcurrentTrades)
   {
      Alert("HARSI: raggiunto MaxConcurrentTrades (", MaxConcurrentTrades, ") — nessun nuovo trade.");
      return;
   }

   double ask = SymbolInfoDouble(g_sym, SYMBOL_ASK);
   double bid = SymbolInfoDouble(g_sym, SYMBOL_BID);
   double entry = isBuy ? ask : bid;

   double sl;
   if(isBuy)
      sl = SwingLow() - BufferPrice();
   else
      sl = SwingHigh() + BufferPrice();

   if(sl <= 0.0)
   {
      Alert("HARSI: swing non disponibile — trade annullato.");
      return;
   }

   double stopDistance = MathAbs(entry - sl);
   if(stopDistance <= 0.0)
   {
      Alert("HARSI: distanza SL nulla — trade annullato.");
      return;
   }

   double lot = CalcRiskLot(stopDistance, RiskPct);
   if(lot <= 0.0)
      return; // gia' allertato

   //--- governance rischio totale: rischio di questo trade
   double mppp = MoneyPerLotPerPricePoint();
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
   double thisRiskPct = (lot * stopDistance * mppp) / bal * 100.0;
   if(CurrentOpenRiskPct() + thisRiskPct > MaxTotalRiskPct)
   {
      Alert("HARSI: rischio totale aperto (", DoubleToString(CurrentOpenRiskPct(),2),
            "%) + nuovo (", DoubleToString(thisRiskPct,2),
            "%) supererebbe MaxTotalRiskPct (", DoubleToString(MaxTotalRiskPct,2),
            "%) — trade BLOCCATO.");
      return;
   }

   double tp = isBuy ? entry + RR * stopDistance
                     : entry - RR * stopDistance;

   sl = NormalizeDouble(sl, g_digits);
   tp = NormalizeDouble(tp, g_digits);

   bool ok;
   if(isBuy)
      ok = trade.Buy(lot, g_sym, 0.0, sl, tp, "HARSI managed BUY");
   else
      ok = trade.Sell(lot, g_sym, 0.0, sl, tp, "HARSI managed SELL");

   if(!ok)
      Alert("HARSI: apertura fallita. retcode=", trade.ResultRetcode(),
            " ", trade.ResultRetcodeDescription());
   else
      Print("HARSI managed ", (isBuy ? "BUY" : "SELL"),
            " lot=", DoubleToString(lot,2),
            " SL=", DoubleToString(sl,g_digits),
            " TP=", DoubleToString(tp,g_digits));
}

//==================================================================
// GESTIONE POSIZIONI MANUALI / ESTERNE
//==================================================================
void ManagePositions()
{
   int symCount = CountSymbolPositions();
   if(symCount > MaxConcurrentTrades)
      Alert("HARSI: ", symCount, " posizioni aperte su ", g_sym,
            " > MaxConcurrentTrades (", MaxConcurrentTrades, ").");

   double mppp = MoneyPerLotPerPricePoint();
   double bal  = AccountInfoDouble(ACCOUNT_BALANCE);

   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket == 0) continue;
      if(!PositionSelectByTicket(ticket)) continue;
      if(PositionGetString(POSITION_SYMBOL) != g_sym) continue;

      long   ptype = PositionGetInteger(POSITION_TYPE);
      double op    = PositionGetDouble(POSITION_PRICE_OPEN);
      double sl    = PositionGetDouble(POSITION_SL);
      double tp    = PositionGetDouble(POSITION_TP);
      double vol   = PositionGetDouble(POSITION_VOLUME);
      bool   isBuy = (ptype == POSITION_TYPE_BUY);

      //--- aggancio SL/TP a posizioni senza protezione (manuali)
      if(ManageManualTrades && (sl <= 0.0 || tp <= 0.0))
      {
         double newSL = isBuy ? SwingLow() - BufferPrice()
                              : SwingHigh() + BufferPrice();
         if(newSL <= 0.0) continue;

         double stopDistance = MathAbs(op - newSL);
         if(stopDistance <= 0.0) continue;

         double newTP = isBuy ? op + RR * stopDistance
                              : op - RR * stopDistance;

         newSL = NormalizeDouble(newSL, g_digits);
         newTP = NormalizeDouble(newTP, g_digits);

         // mantieni eventuale SL/TP gia' esistente, riempi solo il mancante
         double setSL = (sl > 0.0) ? sl : newSL;
         double setTP = (tp > 0.0) ? tp : newTP;

         if(!trade.PositionModify(ticket, setSL, setTP))
            Print("HARSI: PositionModify fallita ticket ", ticket,
                  " retcode=", trade.ResultRetcode());
         else
            Print("HARSI: agganciati SL/TP a posizione manuale ticket ", ticket);

         sl = setSL; // aggiorna per il check over-size sotto
      }

      //--- warning over-size (NON chiude/ridimensiona, solo avvisa)
      if(mppp > 0.0 && sl > 0.0 && bal > 0.0)
      {
         double posRiskPct = vol * MathAbs(op - sl) * mppp / bal * 100.0;
         if(posRiskPct > RiskPct + 0.0001)
            Alert("HARSI: posizione ", ticket, " su ", g_sym,
                  " e' OVER-SIZED: rischio ", DoubleToString(posRiskPct,2),
                  "% > RiskPct ", DoubleToString(RiskPct,2),
                  "%. (Nessuna azione automatica.)");
      }
   }
}

//==================================================================
// LETTURA HARSI + valutazione 4 condizioni
//------------------------------------------------------------------
// Valutate sulla barra CHIUSA (index 1). Servono index 1 e 2.
//==================================================================
struct HARSI_Snapshot
{
   double haOpen1, haClose1;   // candela chiusa
   double haOpen2, haClose2;   // candela precedente
   double rsi1, rsi2;          // linea RSI ri-centrata
   bool   valid;
};

bool ReadHARSI(HARSI_Snapshot &s)
{
   s.valid = false;
   double haO[], haC[], rsi[];
   ArraySetAsSeries(haO, true);
   ArraySetAsSeries(haC, true);
   ArraySetAsSeries(rsi, true);

   // copiamo index 0..2 (corrente + 2 chiuse)
   if(CopyBuffer(hHARSI, BUF_HA_OPEN,  0, 3, haO) < 3) return(false);
   if(CopyBuffer(hHARSI, BUF_HA_CLOSE, 0, 3, haC) < 3) return(false);
   if(CopyBuffer(hHARSI, BUF_RSI_LINE, 0, 3, rsi) < 3) return(false);

   s.haOpen1  = haO[1];  s.haClose1 = haC[1];
   s.haOpen2  = haO[2];  s.haClose2 = haC[2];
   s.rsi1     = rsi[1];  s.rsi2     = rsi[2];

   if(s.haClose1 == EMPTY_VALUE || s.haClose2 == EMPTY_VALUE)
      return(false);

   s.valid = true;
   return(true);
}

//--- condizioni SHORT (mean-reversion da overbought)
// 1. haClose1 >= UpperMild (candela chiusa dentro fascia rossa)
// 2. RSI line >= UpperExtreme (estremo, ~RSI 80) sulla barra chiusa
// 3. flip colore a ribasso: candela 2 bull (close>open) e candela 1 bear (close<open)
// 4. RSI gira giu': rsi1 < rsi2
bool ShortConds(const HARSI_Snapshot &s, bool &c1, bool &c2, bool &c3, bool &c4)
{
   c1 = (s.haClose1 >= UpperMild);
   c2 = (s.rsi1     >= UpperExtreme);
   c3 = (s.haClose2 > s.haOpen2) && (s.haClose1 < s.haOpen1);
   c4 = (s.rsi1 < s.rsi2);
   return(c1 && c2 && c3 && c4);
}

//--- condizioni LONG (mirror, da oversold)
bool LongConds(const HARSI_Snapshot &s, bool &c1, bool &c2, bool &c3, bool &c4)
{
   c1 = (s.haClose1 <= LowerMild);
   c2 = (s.rsi1     <= LowerExtreme);
   c3 = (s.haClose2 < s.haOpen2) && (s.haClose1 > s.haOpen1);
   c4 = (s.rsi1 > s.rsi2);
   return(c1 && c2 && c3 && c4);
}

//==================================================================
// Disegna freccia + label sul bar del segnale
//==================================================================
void DrawSignalArrow(bool isBuy, datetime barTime)
{
   string name = ARROW_PFX + (string)(long)barTime;
   if(ObjectFind(0, name) >= 0) return;

   double price;
   double high[], low[];
   ArraySetAsSeries(high, true);
   ArraySetAsSeries(low, true);
   if(CopyHigh(g_sym, _Period, 1, 1, high) < 1) return;
   if(CopyLow(g_sym, _Period, 1, 1, low) < 1) return;

   double off = 3.0 * BufferPrice();
   if(off <= 0.0) off = 10 * g_point;

   if(isBuy)
   {
      price = low[0] - off;
      ObjectCreate(0, name, OBJ_ARROW_UP, 0, barTime, price);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrLime);
   }
   else
   {
      price = high[0] + off;
      ObjectCreate(0, name, OBJ_ARROW_DOWN, 0, barTime, price);
      ObjectSetInteger(0, name, OBJPROP_COLOR, clrRed);
   }
   ObjectSetInteger(0, name, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, name, OBJPROP_ANCHOR, isBuy ? ANCHOR_TOP : ANCHOR_BOTTOM);
}

//==================================================================
// Comment di stato setup (quale delle 4 condizioni e' soddisfatta)
//==================================================================
string Mark(bool b) { return b ? "[X]" : "[ ]"; }

void ShowStatus(const HARSI_Snapshot &s)
{
   bool sc1,sc2,sc3,sc4, lc1,lc2,lc3,lc4;
   bool shortSig = ShortConds(s, sc1,sc2,sc3,sc4);
   bool longSig  = LongConds(s, lc1,lc2,lc3,lc4);

   string txt = "=== HARSI Assistant ===\n";
   txt += "Symbol: " + g_sym + "  TF: " + EnumToString((ENUM_TIMEFRAMES)_Period) + "\n";
   txt += "HA close[1]=" + DoubleToString(s.haClose1,2) +
          "  RSI[1]=" + DoubleToString(s.rsi1,2) + "\n";
   txt += "\n-- SHORT (da overbought) --\n";
   txt += Mark(sc1) + " 1) haClose>= +" + DoubleToString(UpperMild,1) + " (fascia rossa)\n";
   txt += Mark(sc2) + " 2) RSI>= +"     + DoubleToString(UpperExtreme,1) + "\n";
   txt += Mark(sc3) + " 3) flip colore -> bear\n";
   txt += Mark(sc4) + " 4) RSI gira giu'\n";
   txt += shortSig ? ">>> SEGNALE SHORT <<<\n" : "";
   txt += "\n-- LONG (da oversold) --\n";
   txt += Mark(lc1) + " 1) haClose<= " + DoubleToString(LowerMild,1) + " (fascia verde)\n";
   txt += Mark(lc2) + " 2) RSI<= "     + DoubleToString(LowerExtreme,1) + "\n";
   txt += Mark(lc3) + " 3) flip colore -> bull\n";
   txt += Mark(lc4) + " 4) RSI gira su'\n";
   txt += longSig ? ">>> SEGNALE LONG <<<\n" : "";
   txt += "\nOpen risk: " + DoubleToString(CurrentOpenRiskPct(),2) + "% / max " +
          DoubleToString(MaxTotalRiskPct,1) + "%   Trades: " +
          (string)CountSymbolPositions() + "/" + (string)MaxConcurrentTrades + "\n";
   txt += "AutoTrade: " + (AutoTradeSignals ? "ON" : "OFF") + "\n";

   Comment(txt);
}

//==================================================================
// Logica per nuova barra
//==================================================================
void OnNewBar()
{
   //--- gestione posizioni (aggancio SL/TP, warning)
   ManagePositions();

   //--- valuta HARSI
   HARSI_Snapshot s;
   if(!ReadHARSI(s))
   {
      Comment("HARSI: dati indicatore non pronti...");
      return;
   }

   ShowStatus(s);

   bool sc1,sc2,sc3,sc4, lc1,lc2,lc3,lc4;
   bool shortSig = ShortConds(s, sc1,sc2,sc3,sc4);
   bool longSig  = LongConds(s, lc1,lc2,lc3,lc4);

   datetime barTime[];
   ArraySetAsSeries(barTime, true);
   if(CopyTime(g_sym, _Period, 1, 1, barTime) < 1) return;

   if(shortSig)
   {
      DrawSignalArrow(false, barTime[0]);
      if(AutoTradeSignals) OpenManaged(false);
   }
   if(longSig)
   {
      DrawSignalArrow(true, barTime[0]);
      if(AutoTradeSignals) OpenManaged(true);
   }
}

//+------------------------------------------------------------------+
//| OnTick                                                          |
//+------------------------------------------------------------------+
void OnTick()
{
   datetime cur = (datetime)SeriesInfoInteger(g_sym, _Period, SERIES_LASTBAR_DATE);
   if(cur != g_lastBar)
   {
      g_lastBar = cur;
      OnNewBar();
   }
}

//==================================================================
// PANNELLO (pulsanti)
//==================================================================
void CreateButton(string name, string text, int x, int y, color bg)
{
   ObjectCreate(0, name, OBJ_BUTTON, 0, 0, 0);
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, name, OBJPROP_XSIZE, 110);
   ObjectSetInteger(0, name, OBJPROP_YSIZE, 28);
   ObjectSetString(0, name, OBJPROP_TEXT, text);
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
   ObjectSetInteger(0, name, OBJPROP_STATE, false);
   ObjectSetInteger(0, name, OBJPROP_HIDDEN, false);
   ObjectSetInteger(0, name, OBJPROP_ZORDER, 10);
}

void CreatePanel()
{
   CreateButton(BTN_BUY,  "BUY " + DoubleToString(RiskPct,1) + "%", 10, 24, clrSeaGreen);
   CreateButton(BTN_SELL, "SELL " + DoubleToString(RiskPct,1) + "%", 130, 24, clrFireBrick);
}

//+------------------------------------------------------------------+
//| OnChartEvent — click pulsanti                                   |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
   if(id != CHARTEVENT_OBJECT_CLICK) return;

   if(sparam == BTN_BUY)
   {
      OpenManaged(true);
      ObjectSetInteger(0, BTN_BUY, OBJPROP_STATE, false);
      ChartRedraw(0);
   }
   else if(sparam == BTN_SELL)
   {
      OpenManaged(false);
      ObjectSetInteger(0, BTN_SELL, OBJPROP_STATE, false);
      ChartRedraw(0);
   }
}
//+------------------------------------------------------------------+
