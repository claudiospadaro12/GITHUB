//+------------------------------------------------------------------+
//| Template_EA_Wim.mq5  -  EA modulare "a input" per la fabbrica    |
//| di set (CLAU12). Versione 1.00 - 16/11/2026.                     |
//|                                                                  |
//| NON e il codice di Wim (proprietario, mai visto). E un EA scritto|
//| da zero che copia la STRUTTURA dei suoi input documentata nei    |
//| nostri file (livelli HL con forza L/R e countback, distanza      |
//| minima dal livello, offset, scadenza dei pendenti; uscite: stop, |
//| target, break-even, trailing; rischio: lotto fisso o % di rischio|
//| con tetti di perdita giornaliera e totale; filtri: spread,       |
//| sessione, trend). Tre modalita d'ingresso: BREAKOUT (ordini stop |
//| oltre i livelli), RETEST (rottura chiusa + ritorno sul livello   |
//| con ordine limit), LIMIT (rimbalzo sul livello). RETEST e LIMIT  |
//| NON sono modelli di Wim (suo parere sul retest: "non lo          |
//| consiglio"): sono nostri.                                        |
//|                                                                  |
//| DA COMPILARE E PROVARE: scritto senza compilatore. Se F7 da      |
//| errori, mandami il testo esatto. SOLO tester/demo.               |
//| Orari in ORA SERVER (vedi CLAU12_ORARI.mqh per le sessioni).     |
//+------------------------------------------------------------------+
#property copyright "CLAU12"
#property version   "1.00"
#property strict
#include <Trade/Trade.mqh>

enum ENUM_ENTRY_MODE { ENTRY_BREAKOUT = 0, ENTRY_RETEST = 1, ENTRY_LIMIT = 2 };
enum ENUM_SL_MODE    { SL_ATR = 0, SL_FIXED_PTS = 1, SL_LEVEL = 2 };
enum ENUM_TP_MODE    { TP_RR = 0, TP_ATR = 1, TP_FIXED_PTS = 2 };

input group "=== Identita ==="
input long   InpMagic            = 880001;      // magic number dell'EA
input string InpComment          = "TPL_WIM";   // commento degli ordini

input group "=== Livelli (struttura) ==="
input ENUM_TIMEFRAMES InpLevelTF = PERIOD_H1;   // timeframe su cui si cercano i livelli
input int    InpCountback        = 24;          // barre su cui cercare massimo e minimo
input bool   InpUsePivots        = false;       // true = livelli = pivot HL con forza L/R; false = massimo/minimo delle ultime N barre
input int    InpHLStrengthL      = 3;           // pivot: barre a sinistra
input int    InpHLStrengthR      = 2;           // pivot: barre a destra
input double InpMinDistLevelAtr  = 0.20;        // distanza minima prezzo-livello (in ATR) per piazzare l'ordine
input double InpOffsetAtr        = 0.10;        // offset dell'ordine oltre il livello (in ATR)

input group "=== Ingresso ==="
input ENUM_ENTRY_MODE InpEntryMode = ENTRY_BREAKOUT; // BREAKOUT / RETEST / LIMIT
input int    InpExpirationBars   = 24;          // scadenza dei pendenti (barre del timeframe livelli)
input int    InpRetestMaxBars    = 6;           // RETEST: barre massime per il ritorno sul livello
input double InpRetestTolAtr     = 0.15;        // RETEST: ordine limit a livello + tolleranza (in ATR)

input group "=== Uscite ==="
input ENUM_SL_MODE InpSLMode     = SL_ATR;      // stop: multiplo di ATR / punti fissi / lato opposto del range
input double InpSLAtr            = 1.5;         // SL_ATR: moltiplicatore ATR
input double InpSLPts            = 300;         // SL_FIXED_PTS: punti
input ENUM_TP_MODE InpTPMode     = TP_RR;       // target: multiplo del rischio / multiplo di ATR / punti fissi
input double InpTP_RR            = 2.0;         // TP_RR: multiplo dello stop
input double InpTPAtr            = 3.0;         // TP_ATR: moltiplicatore ATR
input double InpTPPts            = 600;         // TP_FIXED_PTS: punti
input bool   InpUseBE            = true;        // break-even
input double InpBEStartR         = 1.0;         // break-even quando il profitto raggiunge N volte il rischio
input double InpBEExtraPts       = 10;          // punti oltre il prezzo d'ingresso
input bool   InpUseTrail         = false;       // trailing stop
input double InpTrailStartR      = 1.5;         // il trailing parte a N volte il rischio
input double InpTrailAtr          = 1.0;        // distanza del trailing (in ATR)

input group "=== Rischio ==="
input bool   InpFixedLot         = false;       // true = lotto fisso (consigliato per confrontare i test); false = % di rischio
input double InpLot              = 0.10;        // lotto fisso
input double InpRiskPct          = 1.0;         // % di equity rischiata per operazione (se InpFixedLot=false)
input double InpMaxDailyLossPct  = 3.0;         // tetto di perdita giornaliera in % dell'equity di inizio giorno (0 = spento)
input double InpMaxTotalDDPct    = 8.0;          // tetto di perdita totale in % dell'equity iniziale (0 = spento)
input bool   InpCloseOnBreach    = true;        // se un tetto scatta: chiude tutto e smette di operare
input int    InpMaxTradesPerDay  = 2;           // operazioni massime al giorno (0 = senza tetto)
input int    InpMaxOpenPos       = 1;           // posizioni aperte insieme (massimo)

input group "=== Filtri ==="
input int    InpATRPeriod        = 14;          // periodo ATR
input ENUM_TIMEFRAMES InpATRTF   = PERIOD_H1;   // timeframe dell'ATR
input int    InpMaxSpreadPts     = 0;           // spread massimo in punti (0 = spento)
input bool   InpUseSession       = false;       // filtro orario (ORA SERVER)
input int    InpSessionStartHour = 7;           // dalle ore (incluse)
input int    InpSessionEndHour   = 21;          // alle ore (escluse)
input bool   InpUseEmaFilter     = false;       // opera solo a favore di trend (EMA)
input int    InpEmaPeriod        = 200;         // periodo EMA
input ENUM_TIMEFRAMES InpEmaTF   = PERIOD_H1;   // timeframe della EMA

CTrade   gTrade;
int      gAtr = INVALID_HANDLE;
int      gEma = INVALID_HANDLE;
double   gStartEquity = 0;       // equity all'avvio (riferimento del tetto totale)
double   gDayEquity   = 0;       // equity a inizio giorno
int      gDayKey      = 0;
bool     gHalt        = false;   // fermo per sempre (tetto totale)
bool     gDayBlock    = false;   // fermo fino a domani (tetto giornaliero)
ulong    gTk[64];                // ticket gia visti
double   gRk[64];                // rischio iniziale (distanza stop all'ingresso)
int      gN = 0;

//+------------------------------------------------------------------+
int OnInit()
{
   gAtr = iATR(_Symbol, InpATRTF, InpATRPeriod);
   if(gAtr == INVALID_HANDLE){ Print("TPL_WIM: errore ATR"); return INIT_FAILED; }
   if(InpUseEmaFilter){ gEma = iMA(_Symbol, InpEmaTF, InpEmaPeriod, 0, MODE_EMA, PRICE_CLOSE); if(gEma == INVALID_HANDLE) return INIT_FAILED; }
   gTrade.SetExpertMagicNumber(InpMagic);
   gTrade.SetDeviationInPoints(50);
   gStartEquity = AccountInfoDouble(ACCOUNT_EQUITY);
   gDayEquity   = gStartEquity;
   PrintFormat("TPL_WIM v1.00: %s %s, ingresso %d, livelli %s countback %d, rischio %s",
               _Symbol, EnumToString((ENUM_TIMEFRAMES)_Period), (int)InpEntryMode, EnumToString(InpLevelTF), InpCountback, (InpFixedLot ? "lotto fisso" : "% di rischio"));
   return INIT_SUCCEEDED;
}
void OnDeinit(const int reason){ if(gAtr != INVALID_HANDLE) IndicatorRelease(gAtr); if(gEma != INVALID_HANDLE) IndicatorRelease(gEma); }

//+------------------------------------------------------------------+
double Atr()
{
   double b[]; ArraySetAsSeries(b, true);
   if(CopyBuffer(gAtr, 0, 1, 1, b) < 1) return 0;
   return b[0];
}
bool NuovaBarra()
{
   static datetime ultima = 0;
   datetime c = iTime(_Symbol, InpLevelTF, 0);
   if(c == 0 || c == ultima) return false;
   ultima = c; return true;
}
double NormLot(double l)
{
   double st = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP), mn = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN), mx = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   if(st <= 0) st = 0.01;
   l = MathFloor(l / st) * st; l = MathMax(mn, MathMin(mx, l));
   int dg = (int)MathRound(-MathLog10(st)); if(dg < 0) dg = 0;
   return NormalizeDouble(l, dg);
}
double Lotti(double slDist)
{
   if(InpFixedLot) return NormLot(InpLot);
   double tv = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE), ts = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tv <= 0 || ts <= 0 || slDist <= 0) return NormLot(InpLot);
   double rischio = AccountInfoDouble(ACCOUNT_EQUITY) * InpRiskPct / 100.0;
   return NormLot(rischio / (slDist / ts * tv));
}
double DistMinima()   // distanza minima da prezzo/stop richiesta dal broker (+ spread)
{
   double lv = (double)SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * _Point;
   double sp = (double)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) * _Point;
   return lv + sp;
}

//+------------------------------------------------------------------+
//| Livelli: massimo/minimo delle ultime N barre chiuse (da 'primo'),|
//| oppure ultimo pivot alto/basso con forza L/R                      |
//+------------------------------------------------------------------+
bool Pivot(bool alto, int primo, double &val)
{
   int maxScan = InpCountback + InpHLStrengthL + InpHLStrengthR + primo + 2;
   for(int s = primo + InpHLStrengthR; s < maxScan; s++)
   {
      double v = alto ? iHigh(_Symbol, InpLevelTF, s) : iLow(_Symbol, InpLevelTF, s);
      bool ok = true;
      for(int k = 1; k <= InpHLStrengthR && ok; k++){ double w = alto ? iHigh(_Symbol, InpLevelTF, s - k) : iLow(_Symbol, InpLevelTF, s - k); if(alto ? (w >= v) : (w <= v)) ok = false; }
      for(int k = 1; k <= InpHLStrengthL && ok; k++){ double w = alto ? iHigh(_Symbol, InpLevelTF, s + k) : iLow(_Symbol, InpLevelTF, s + k); if(alto ? (w > v) : (w < v)) ok = false; }
      if(ok){ val = v; return true; }
   }
   return false;
}
bool Livelli(int primo, double &hh, double &ll)
{
   if(InpUsePivots) return (Pivot(true, primo, hh) && Pivot(false, primo, ll));
   int ih = iHighest(_Symbol, InpLevelTF, MODE_HIGH, InpCountback, primo);
   int il = iLowest(_Symbol, InpLevelTF, MODE_LOW, InpCountback, primo);
   if(ih < 0 || il < 0) return false;
   hh = iHigh(_Symbol, InpLevelTF, ih); ll = iLow(_Symbol, InpLevelTF, il);
   return (hh > ll);
}

//+------------------------------------------------------------------+
//| Stop e target dall'ingresso                                       |
//+------------------------------------------------------------------+
bool CalcolaSLTP(bool buy, double entry, double livelloOpposto, double atr, double &sl, double &tp)
{
   double slDist;
   if(InpSLMode == SL_ATR) slDist = InpSLAtr * atr;
   else if(InpSLMode == SL_FIXED_PTS) slDist = InpSLPts * _Point;
   else slDist = MathMin(MathMax(MathAbs(entry - livelloOpposto), 0.5 * atr), 4.0 * atr);
   double minimo = MathMax(DistMinima() * 1.5, 0.3 * atr);
   if(slDist < minimo) slDist = minimo;
   double tpDist;
   if(InpTPMode == TP_RR) tpDist = InpTP_RR * slDist;
   else if(InpTPMode == TP_ATR) tpDist = InpTPAtr * atr;
   else tpDist = InpTPPts * _Point;
   if(tpDist < minimo) tpDist = minimo;
   sl = NormalizeDouble(buy ? entry - slDist : entry + slDist, _Digits);
   tp = NormalizeDouble(buy ? entry + tpDist : entry - tpDist, _Digits);
   return (slDist > 0 && tpDist > 0);
}
bool TrendOk(bool buy)
{
   if(!InpUseEmaFilter) return true;
   double e[]; ArraySetAsSeries(e, true);
   if(CopyBuffer(gEma, 0, 1, 1, e) < 1) return false;
   double c = iClose(_Symbol, InpEmaTF, 1);
   return buy ? (c > e[0]) : (c < e[0]);
}

//+------------------------------------------------------------------+
//| Stato dei conti: tetti di perdita, ordini del giorno             |
//+------------------------------------------------------------------+
int ChiaveGiorno(){ MqlDateTime t; TimeToStruct(TimeCurrent(), t); return t.year * 10000 + t.mon * 100 + t.day; }
void CancellaPendenti()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong tk = OrderGetTicket(i);
      if(tk == 0) continue;
      if(OrderGetString(ORDER_SYMBOL) != _Symbol || OrderGetInteger(ORDER_MAGIC) != InpMagic) continue;
      gTrade.OrderDelete(tk);
   }
}
void ChiudiTutto()
{
   CancellaPendenti();
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      gTrade.PositionClose(tk);
   }
}
int NPosizioni()
{
   int n = 0;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk != 0 && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_MAGIC) == InpMagic) n++;
   }
   return n;
}
int NPendenti()
{
   int n = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      ulong tk = OrderGetTicket(i);
      if(tk != 0 && OrderGetString(ORDER_SYMBOL) == _Symbol && OrderGetInteger(ORDER_MAGIC) == InpMagic) n++;
   }
   return n;
}
int OperazioniOggi()
{
   MqlDateTime t; TimeToStruct(TimeCurrent(), t); t.hour = 0; t.min = 0; t.sec = 0;
   if(!HistorySelect(StructToTime(t), TimeCurrent() + 60)) return 0;
   int n = 0;
   for(int i = HistoryDealsTotal() - 1; i >= 0; i--)
   {
      ulong d = HistoryDealGetTicket(i);
      if(d == 0) continue;
      if(HistoryDealGetInteger(d, DEAL_MAGIC) == InpMagic && HistoryDealGetInteger(d, DEAL_ENTRY) == DEAL_ENTRY_IN) n++;
   }
   return n;
}
void AggiornaTetti()
{
   int k = ChiaveGiorno();
   if(k != gDayKey){ gDayKey = k; gDayEquity = AccountInfoDouble(ACCOUNT_EQUITY); gDayBlock = false; }
   double eq = AccountInfoDouble(ACCOUNT_EQUITY);
   if(InpMaxDailyLossPct > 0 && gDayEquity > 0 && (gDayEquity - eq) / gDayEquity * 100.0 >= InpMaxDailyLossPct && !gDayBlock)
   { gDayBlock = true; Print("TPL_WIM: tetto giornaliero raggiunto"); if(InpCloseOnBreach) ChiudiTutto(); }
   if(InpMaxTotalDDPct > 0 && gStartEquity > 0 && (gStartEquity - eq) / gStartEquity * 100.0 >= InpMaxTotalDDPct && !gHalt)
   { gHalt = true; Print("TPL_WIM: tetto totale raggiunto: EA fermo"); if(InpCloseOnBreach) ChiudiTutto(); }
}
bool ConsentitoOperare()
{
   if(gHalt || gDayBlock) return false;
   if(InpMaxSpreadPts > 0 && SymbolInfoInteger(_Symbol, SYMBOL_SPREAD) > InpMaxSpreadPts) return false;
   if(InpUseSession){ MqlDateTime t; TimeToStruct(TimeCurrent(), t); if(t.hour < InpSessionStartHour || t.hour >= InpSessionEndHour) return false; }
   if(InpMaxOpenPos > 0 && NPosizioni() >= InpMaxOpenPos) return false;
   if(InpMaxTradesPerDay > 0 && OperazioniOggi() >= InpMaxTradesPerDay) return false;
   return true;
}

//+------------------------------------------------------------------+
//| Ordini                                                            |
//+------------------------------------------------------------------+
void Piazza(ENUM_ORDER_TYPE tipo, double prezzo, double livelloOpposto, double atr)
{
   bool buy = (tipo == ORDER_TYPE_BUY_STOP || tipo == ORDER_TYPE_BUY_LIMIT);
   if(!TrendOk(buy)) return;
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK), bid = SymbolInfoDouble(_Symbol, SYMBOL_BID), dm = DistMinima();
   prezzo = NormalizeDouble(prezzo, _Digits);
   // distanza minima dal mercato richiesta dal broker
   if(tipo == ORDER_TYPE_BUY_STOP && prezzo < ask + dm) return;
   if(tipo == ORDER_TYPE_SELL_STOP && prezzo > bid - dm) return;
   if(tipo == ORDER_TYPE_BUY_LIMIT && prezzo > ask - dm) return;
   if(tipo == ORDER_TYPE_SELL_LIMIT && prezzo < bid + dm) return;
   // distanza minima dal livello (in ATR): evita ordini attaccati al prezzo
   double ref = buy ? ask : bid;
   if(MathAbs(prezzo - ref) < InpMinDistLevelAtr * atr) return;
   double sl, tp;
   if(!CalcolaSLTP(buy, prezzo, livelloOpposto, atr, sl, tp)) return;
   double lot = Lotti(MathAbs(prezzo - sl));
   if(lot <= 0) return;
   datetime scad = TimeCurrent() + (datetime)(InpExpirationBars * PeriodSeconds(InpLevelTF));
   if(InpEntryMode == ENTRY_RETEST) scad = TimeCurrent() + (datetime)(InpRetestMaxBars * PeriodSeconds(InpLevelTF));
   if(!gTrade.OrderOpen(_Symbol, tipo, lot, 0, prezzo, sl, tp, ORDER_TIME_SPECIFIED, scad, InpComment))
      PrintFormat("TPL_WIM: ordine rifiutato (%d) tipo %d prezzo %.5f", gTrade.ResultRetcode(), (int)tipo, prezzo);
}
void IngressoBreakout(double hh, double ll, double atr)
{
   double off = InpOffsetAtr * atr;
   Piazza(ORDER_TYPE_BUY_STOP, hh + off, ll, atr);
   Piazza(ORDER_TYPE_SELL_STOP, ll - off, hh, atr);
}
void IngressoLimit(double hh, double ll, double atr)
{
   double off = InpOffsetAtr * atr;
   Piazza(ORDER_TYPE_SELL_LIMIT, hh - off, ll, atr);   // rimbalzo giu dalla resistenza
   Piazza(ORDER_TYPE_BUY_LIMIT, ll + off, hh, atr);    // rimbalzo su dal supporto
}
void IngressoRetest(double atr)
{
   double hh, ll;
   if(!Livelli(2, hh, ll)) return;                       // livelli SENZA l'ultima barra chiusa
   double c1 = iClose(_Symbol, InpLevelTF, 1), c2 = iClose(_Symbol, InpLevelTF, 2);
   double tol = InpRetestTolAtr * atr;
   if(c1 > hh && c2 <= hh) Piazza(ORDER_TYPE_BUY_LIMIT, hh + tol, ll, atr);      // rottura al rialzo appena chiusa: aspetta il ritorno sul livello
   if(c1 < ll && c2 >= ll) Piazza(ORDER_TYPE_SELL_LIMIT, ll - tol, hh, atr);     // rottura al ribasso appena chiusa
}

//+------------------------------------------------------------------+
//| Gestione posizioni: OCO, break-even, trailing                    |
//+------------------------------------------------------------------+
double RischioIniziale(ulong tk, double apertura, double sl)
{
   for(int i = 0; i < gN; i++) if(gTk[i] == tk) return gRk[i];
   double r = MathAbs(apertura - sl);
   if(gN < 64){ gTk[gN] = tk; gRk[gN] = r; gN++; }
   else { for(int i = 1; i < 64; i++){ gTk[i - 1] = gTk[i]; gRk[i - 1] = gRk[i]; } gTk[63] = tk; gRk[63] = r; }
   return r;
}
void GestisciPosizioni()
{
   bool aperta = false;
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk == 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != InpMagic) continue;
      aperta = true;
      long tipo = PositionGetInteger(POSITION_TYPE);
      double ap = PositionGetDouble(POSITION_PRICE_OPEN), sl = PositionGetDouble(POSITION_SL), tp = PositionGetDouble(POSITION_TP);
      double r = RischioIniziale(tk, ap, sl);
      if(r <= 0) continue;
      bool buy = (tipo == POSITION_TYPE_BUY);
      double px = SymbolInfoDouble(_Symbol, buy ? SYMBOL_BID : SYMBOL_ASK);
      double profittoR = (buy ? px - ap : ap - px) / r;
      double nuovo = sl; double dm = DistMinima();
      if(InpUseBE && profittoR >= InpBEStartR)
      {
         double be = NormalizeDouble(buy ? ap + InpBEExtraPts * _Point : ap - InpBEExtraPts * _Point, _Digits);
         if(buy ? (be > nuovo) : (be < nuovo || nuovo == 0)) nuovo = be;
      }
      if(InpUseTrail && profittoR >= InpTrailStartR)
      {
         double atr = Atr();
         if(atr > 0)
         {
            double tr = NormalizeDouble(buy ? px - InpTrailAtr * atr : px + InpTrailAtr * atr, _Digits);
            if(buy ? (tr > nuovo) : (tr < nuovo || nuovo == 0)) nuovo = tr;
         }
      }
      if(nuovo != sl && MathAbs(px - nuovo) >= dm)
         gTrade.PositionModify(tk, nuovo, tp);
   }
   if(aperta && NPendenti() > 0) CancellaPendenti();     // OCO: con una posizione aperta si tolgono gli altri pendenti
}

//+------------------------------------------------------------------+
void OnTick()
{
   AggiornaTetti();
   GestisciPosizioni();
   if(!NuovaBarra()) return;
   if(NPosizioni() > 0) return;
   CancellaPendenti();                                    // si riarma a ogni nuova barra
   if(!ConsentitoOperare()) return;
   double atr = Atr(); if(atr <= 0) return;
   double hh, ll;
   if(InpEntryMode == ENTRY_RETEST){ IngressoRetest(atr); return; }
   if(!Livelli(1, hh, ll)) return;
   if(InpEntryMode == ENTRY_BREAKOUT) IngressoBreakout(hh, ll, atr);
   else IngressoLimit(hh, ll, atr);
}
//+------------------------------------------------------------------+
