//+------------------------------------------------------------------+
//|                                          ABTG_BreakoutCorso.mq5  |
//|  Strategia BREAKOUT del corso forex ABTG (lezioni 34-40), SOLO   |
//|  per il tester. Regole dal riepilogo (lezione 40):               |
//|   - M15; Williams %R 140; Supertrend (10, 3.0: valori non        |
//|     dichiarati nel corso, default degli indicatori comuni).      |
//|   - Rettangolo di congestione di max 20 candele costruito dal    |
//|     primo ingresso del Williams in area di ipercomprato (> -20)  |
//|     o ipervenduto (< -80) (InpRectMode=1), oppure ultime 20      |
//|     candele che finiscono nell'ultima barra in area (modo 0).    |
//|   - SELL: chiusura sotto il minimo del rettangolo, Supertrend    |
//|     rosso, Williams uscito dall'ipercomprato ma sopra -50.       |
//|     BUY: simmetrico (Williams tra -80 e -50, Supertrend verde).  |
//|   - SL = 1 pip oltre il lato opposto del rettangolo.             |
//|   - TP = 3 volte la distanza chiusura-segnale / SL (calcolato    |
//|     dalla chiusura della candela di segnale).                    |
//|   - Ingresso al mercato dopo la chiusura; si entra solo se il    |
//|     rapporto rischio/rendimento dal prezzo reale e' >= 1:2.      |
//|   - Stop a pari al raggiungimento di 1R. Esce su segnale opposto.|
//|  Un segnale per episodio. Una posizione per volta.               |
//|  Criteri: report/BREAKOUT_CORSO_CRITERI_2026-11-19.md            |
//+------------------------------------------------------------------+
#property copyright "Progetto EA Aperture Mercati"
#property version   "1.00"
#property strict

#include <Trade/Trade.mqh>
CTrade gT;

input group "=== Indicatori ==="
input ENUM_TIMEFRAMES InpTF = PERIOD_M15;
input int    InpWprPeriod   = 140;
input double InpOB          = -20.0;  // ipercomprato: Williams sopra
input double InpOS          = -80.0;  // ipervenduto: Williams sotto
input double InpMidLevel    = -50.0;  // il segnale e' valido finche' il Williams non supera -50
input int    InpStAtrPeriod = 10;
input double InpStMult      = 3.0;

input group "=== Rettangolo ==="
input int    InpRectBars    = 20;
input int    InpRectMode    = 1;      // 1 = dal primo ingresso nell'area (max 20); 0 = ultime 20 barre
input int    InpMaxAge      = 100;    // barre massime tra l'ultima barra in area e il segnale

input group "=== Ordine ==="
input double InpSlPips      = 1.0;
input double InpTpMult      = 3.0;
input double InpMinRR       = 2.0;
input double InpBeAtR       = 1.0;
input double InpRiskPct     = 1.0;
input bool   InpAllowLong   = true;
input bool   InpAllowShort  = true;
input long   InpMagic       = 20261120;

int      hW = INVALID_HANDLE, hAtr = INVALID_HANDLE;
double   stFU = 0, stFL = 0; int stDir = 0;
bool     stInit = false;
datetime lastBar = 0, lastSigSell = 0, lastSigBuy = 0;
double   pipSz = 0;

//+------------------------------------------------------------------+
int OnInit()
  {
   hW   = iWPR(_Symbol, InpTF, InpWprPeriod);
   hAtr = iATR(_Symbol, InpTF, InpStAtrPeriod);
   if(hW == INVALID_HANDLE || hAtr == INVALID_HANDLE) return(INIT_FAILED);
   gT.SetExpertMagicNumber(InpMagic);
   gT.SetDeviationInPoints(50);
   pipSz = (_Digits == 3 || _Digits == 5) ? _Point * 10.0 : _Point;
   if(StringFind(_Symbol, "XAU") == 0) pipSz = _Point * 10.0;
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   if(hW != INVALID_HANDLE) IndicatorRelease(hW);
   if(hAtr != INVALID_HANDLE) IndicatorRelease(hAtr);
  }

//+------------------------------------------------------------------+
void StStep(double h, double l, double c, double prevClose, double atr)
  {
   double hl2 = (h + l) / 2.0;
   double bU = hl2 + InpStMult * atr, bL = hl2 - InpStMult * atr;
   double pFU = (stFU == 0) ? bU : stFU;
   double pFL = (stFL == 0) ? bL : stFL;
   double fU = (bU < pFU || prevClose > pFU) ? bU : pFU;
   double fL = (bL > pFL || prevClose < pFL) ? bL : pFL;
   if(c > pFU) stDir = 1; else if(c < pFL) stDir = -1;
   stFU = fU; stFL = fL;
  }

bool StWarm()
  {
   int need = 700;
   MqlRates r[]; ArraySetAsSeries(r, true);
   if(CopyRates(_Symbol, InpTF, 0, need, r) < need) return(false);
   double a[]; ArraySetAsSeries(a, true);
   if(CopyBuffer(hAtr, 0, 0, need, a) < need) return(false);
   stFU = 0; stFL = 0; stDir = 0;
   for(int i = need - 2; i >= 1; i--) StStep(r[i].high, r[i].low, r[i].close, r[i + 1].close, a[i]);
   return(true);
  }

//+------------------------------------------------------------------+
bool HavePos(int &type, ulong &ticket, double &openP, double &sl)
  {
   for(int i = PositionsTotal() - 1; i >= 0; i--)
     {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      type = (int)PositionGetInteger(POSITION_TYPE); ticket = tk;
      openP = PositionGetDouble(POSITION_PRICE_OPEN); sl = PositionGetDouble(POSITION_SL);
      return(true);
     }
   return(false);
  }

double LotFor(bool buy, double entry, double sl)
  {
   double pf = 0;
   if(!OrderCalcProfit(buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL, _Symbol, 1.0, entry, sl, pf)) return(0);
   double lossLot = -pf;
   if(lossLot <= 0) return(0);
   double risk = AccountInfoDouble(ACCOUNT_BALANCE) * InpRiskPct / 100.0;
   double lot = risk / lossLot;
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN), mx = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(st <= 0) st = 0.01;
   lot = MathFloor(lot / st) * st;
   if(lot < mn) return(0);
   if(lot > mx) lot = mx;
   return(NormalizeDouble(lot, 2));
  }

//+------------------------------------------------------------------+
//| +1 = segnale buy, -1 = segnale sell, 0 = nessuno                 |
//+------------------------------------------------------------------+
int Signal(double &hi, double &lo, datetime &ep)
  {
   int need = InpMaxAge + InpRectBars + 10;
   MqlRates r[]; ArraySetAsSeries(r, true);
   if(CopyRates(_Symbol, InpTF, 0, need, r) < need) return(0);
   double w[]; ArraySetAsSeries(w, true);
   if(CopyBuffer(hW, 0, 0, need, w) < need) return(0);

   //--- SELL
   if(stDir == -1 && w[1] <= InpOB && w[1] > InpMidLevel)
     {
      int j = -1;
      for(int k = 2; k <= InpMaxAge; k++)
        {
         if(w[k] <= InpMidLevel) break;
         if(w[k] > InpOB) { j = k; break; }
        }
      if(j > 0)
        {
         int e = j;
         if(InpRectMode == 1) { while(e + 1 < need && (e - j + 1) < InpRectBars && w[e + 1] > InpOB) e++; }
         else e = j + InpRectBars - 1;
         double H = r[j].high, L = r[j].low;
         for(int k = j; k <= e; k++) { if(r[k].high > H) H = r[k].high; if(r[k].low < L) L = r[k].low; }
         bool first = true;
         for(int k = 2; k < j; k++) if(r[k].close < L) { first = false; break; }
         if(first && r[1].close < L && r[j].time != lastSigSell)
           { hi = H; lo = L; ep = r[j].time; return(-1); }
        }
     }
   //--- BUY
   if(stDir == 1 && w[1] >= InpOS && w[1] < InpMidLevel)
     {
      int j = -1;
      for(int k = 2; k <= InpMaxAge; k++)
        {
         if(w[k] >= InpMidLevel) break;
         if(w[k] < InpOS) { j = k; break; }
        }
      if(j > 0)
        {
         int e = j;
         if(InpRectMode == 1) { while(e + 1 < need && (e - j + 1) < InpRectBars && w[e + 1] < InpOS) e++; }
         else e = j + InpRectBars - 1;
         double H = r[j].high, L = r[j].low;
         for(int k = j; k <= e; k++) { if(r[k].high > H) H = r[k].high; if(r[k].low < L) L = r[k].low; }
         bool first = true;
         for(int k = 2; k < j; k++) if(r[k].close > H) { first = false; break; }
         if(first && r[1].close > H && r[j].time != lastSigBuy)
           { hi = H; lo = L; ep = r[j].time; return(1); }
        }
     }
   return(0);
  }

//+------------------------------------------------------------------+
void ManageBE()
  {
   int type; ulong tk; double op, sl;
   if(!HavePos(type, tk, op, sl)) return;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID), ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double tp = PositionGetDouble(POSITION_TP);
   if(type == POSITION_TYPE_BUY && sl < op && sl > 0)
     {
      double R = op - sl;
      if(bid >= op + InpBeAtR * R) gT.PositionModify(tk, NormalizeDouble(op, _Digits), tp);
     }
   if(type == POSITION_TYPE_SELL && sl > op)
     {
      double R = sl - op;
      if(ask <= op - InpBeAtR * R) gT.PositionModify(tk, NormalizeDouble(op, _Digits), tp);
     }
  }

void OnTick()
  {
   if(!stInit)
     {
      if(!StWarm()) return;
      stInit = true; lastBar = iTime(_Symbol, InpTF, 0);
      return;
     }
   ManageBE();
   datetime t0 = iTime(_Symbol, InpTF, 0);
   if(t0 == lastBar) return;
   lastBar = t0;
   //--- aggiorna il Supertrend con la barra appena chiusa
   MqlRates r[]; ArraySetAsSeries(r, true);
   if(CopyRates(_Symbol, InpTF, 0, 3, r) < 3) return;
   double a[]; ArraySetAsSeries(a, true);
   if(CopyBuffer(hAtr, 0, 0, 3, a) < 3) return;
   StStep(r[1].high, r[1].low, r[1].close, r[2].close, a[1]);

   double hi = 0, lo = 0; datetime ep = 0;
   int sg = Signal(hi, lo, ep);
   if(sg == 0) return;
   if(sg == 1 && !InpAllowLong) return;
   if(sg == -1 && !InpAllowShort) return;

   int type; ulong tk; double op, sl0;
   if(HavePos(type, tk, op, sl0))
     {
      bool opposite = (sg == 1 && type == POSITION_TYPE_SELL) || (sg == -1 && type == POSITION_TYPE_BUY);
      if(!opposite) return;
      gT.PositionClose(tk);
     }
   double pip = InpSlPips * pipSz;
   double sigClose = r[1].close;
   if(sg == -1)
     {
      lastSigSell = ep;
      double sl = hi + pip, D = sl - sigClose;
      if(D <= 0) return;
      double tp = sigClose - InpTpMult * D;
      double entry = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      double risk = sl - entry, reward = entry - tp;
      if(risk <= 0 || reward / risk < InpMinRR) return;
      double lot = LotFor(false, entry, sl);
      if(lot <= 0) return;
      gT.Sell(lot, _Symbol, 0, NormalizeDouble(sl, _Digits), NormalizeDouble(tp, _Digits), "BC");
     }
   else
     {
      lastSigBuy = ep;
      double sl = lo - pip, D = sigClose - sl;
      if(D <= 0) return;
      double tp = sigClose + InpTpMult * D;
      double entry = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double risk = entry - sl, reward = tp - entry;
      if(risk <= 0 || reward / risk < InpMinRR) return;
      double lot = LotFor(true, entry, sl);
      if(lot <= 0) return;
      gT.Buy(lot, _Symbol, 0, NormalizeDouble(sl, _Digits), NormalizeDouble(tp, _Digits), "BC");
     }
  }
