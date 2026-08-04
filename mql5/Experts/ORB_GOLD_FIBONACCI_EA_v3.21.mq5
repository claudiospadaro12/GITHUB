//+------------------------------------------------------------------+
//|                   ORB_GOLD_FIBONACCI_EA_v3.21.mq5                |
//| Fonte: ABTG Webinar ORB Avanzato – Emiliano Monza               |
//|                                                                  |
//| LOGICA v3.21 — CORREZIONI BUG vs v3.20                          |
//|  BUG FIX #1: InpBrokerCETOffset default -1 (BCM Markets)        |
//|  BUG FIX #2: Doppio fill FIB1+FIB2 ora gestito correttamente    |
//|              (contatore posizioni + stato per ordine)            |
//|  BUG FIX #3: Trailing EMA9 separato per FIB1 e FIB2             |
//|              (g_tp1Hit e g_tp2Hit indipendenti)                  |
//|                                                                  |
//| INVARIATO da v3.20:                                              |
//|  FIB2 (50%): SL al 61.8% -> RR ~4.2:1                          |
//|  FIB1 (61.8%): SL al 78.6% -> RR 3.7:1                         |
//|  D1 SoftMode + SoftLotFactor 0.30                               |
//|  Sessioni Londra 10:00-10:30 + NY 15:30-16:00 CET               |
//|  MaxDailyLoss 2%, MaxMonthlyLoss 5%                             |
//|  Rischio 1.5% per trade                                         |
//|                                                                  |
//| TIMEFRAME: M5 | STRUMENTO: XAUUSD                               |
//+------------------------------------------------------------------+
#property copyright "ABTG ORB Gold Fibonacci v3.21 - Emiliano Monza"
#property version   "3.21"
#property description "ORB GOLD Fibonacci v3.21: BugFix offset+doppiofill+trailing | RR 4.2:1"

#include <Trade\Trade.mqh>

//===================================================================
// INPUT PARAMETERS
//===================================================================
input group "=== STRUMENTO ==="
input string InpSymbol                = "";           // Simbolo (vuoto = chart corrente)

input group "=== SESSIONE LONDRA (CET) ==="
input bool   InpUseLondonSession      = true;         // Abilita sessione Londra
input int    InpLondonORStartHour     = 10;           // Inizio OR Londra (ora)
input int    InpLondonORStartMin      = 0;            // Inizio OR Londra (min)
input int    InpLondonOREndHour       = 10;           // Fine OR Londra (ora)
input int    InpLondonOREndMin        = 30;           // Fine OR Londra (min)
input int    InpLondonExpireHour      = 13;           // Scadenza ordine Londra (ora)
input int    InpLondonExpireMin       = 0;            // Scadenza ordine Londra (min)

input group "=== SESSIONE NEW YORK (CET) ==="
input bool   InpUseNYSession          = true;         // Abilita sessione New York
input int    InpNYORStartHour         = 15;           // Inizio OR NY (ora)
input int    InpNYORStartMin          = 30;           // Inizio OR NY (min)
input int    InpNYOREndHour           = 16;           // Fine OR NY (ora)
input int    InpNYOREndMin            = 0;            // Fine OR NY (min)
input int    InpNYExpireHour          = 20;           // Scadenza ordine NY (ora)
input int    InpNYExpireMin           = 0;            // Scadenza ordine NY (min)

input group "=== OFFSET BROKER (ore vs CET) ==="
input int    InpBrokerCETOffset       = -1;           // Offset broker BCM Markets (-1). 0 = nessun offset

input group "=== EMA FILTER M5 ==="
input int    InpEMA_Fast              = 9;            // EMA veloce
input int    InpEMA_Slow              = 21;           // EMA lenta

input group "=== FIBONACCI ==="
input double InpFib_Entry1            = 0.618;        // Entry principale 61.8%
input double InpFib_Entry2            = 0.500;        // Entry secondario 50.0%
input bool   InpUseEntry2             = true;         // Abilita secondo livello Fib
input double InpEntry2LotFactor       = 0.50;         // Fattore lotto Entry2 (es. 0.50 = meta lotto)
input double InpFib_SL                = 0.786;        // Stop Loss FIB1 (78.6%)
input double InpFib_SL2               = 0.618;        // Stop Loss FIB2 = livello FIB1 (61.8%) -> RR ~4:1

input group "=== BREAKOUT ==="
input double InpMinBodyRatio          = 0.55;         // Corpo candela minimo (55%)
input int    InpBarsToConfirmExtreme  = 2;            // Barre di conferma estremo

input group "=== FILTRO OR IN DOLLARI ==="
input double InpOR_MinUSD             = 7.0;          // Range OR minimo $
input double InpOR_MaxUSD             = 55.0;         // Range OR massimo $

input group "=== FILTRO TREND D1 ==="
input bool   InpD1_FilterEnabled      = true;         // Abilita filtro D1 EMA200
input bool   InpD1_SoftMode           = true;         // Soft: permette controtend. con lot ridotto
input double InpD1_SoftLotFactor      = 0.30;         // Fattore lotto controtendenza (ridotto: 30%)
input int    InpD1_EMAPeriod          = 200;          // Periodo EMA Daily

input group "=== MONEY MANAGEMENT ==="
input double InpRiskPct               = 1.5;          // Rischio % per trade
input double InpMinRR                 = 1.5;          // R:R minimo accettabile
input double InpLotSize               = 0.10;         // Lotto fisso (fallback se RiskPct=0)

input group "=== PROTEZIONE PERDITE ==="
input bool   InpUseDailyLossLimit     = true;         // Abilita limite perdita giornaliera
input double InpMaxDailyLossPct       = 2.0;          // Max perdita giornaliera % sul bilancio
input bool   InpUseMonthlyLossLimit   = true;         // Abilita limite perdita mensile
input double InpMaxMonthlyLossPct     = 5.0;          // Max perdita mensile % sul bilancio

input group "=== FILTRI ==="
input int    InpMaxSpread             = 50;           // Spread massimo (punti)
input int    InpMagicNumber           = 20260304;     // Magic number EA

//===================================================================
// TIPI ENUMERATI
//===================================================================
enum FibState
{
    FS_WAITING,        // In attesa della finestra OR
    FS_FORMING,        // Dentro la finestra OR, raccogliamo High/Low
    FS_READY,          // OR chiuso, pronti per il breakout
    FS_BREAKOUT,       // Breakout rilevato, tracking estremo
    FS_ORDER_PLACED,   // Ordini limite piazzati, attesa fill
    FS_TRADED,         // Posizione aperta, gestione trailing
    FS_DONE            // Sessione terminata (nessuna ulteriore azione)
};

enum SessionType
{
    SES_NONE,
    SES_LONDON,
    SES_NY
};

//===================================================================
// VARIABILI GLOBALI
//===================================================================
CTrade      g_trade;
string      g_sym        = "";
datetime    g_lastBarM5  = 0;
int         g_hEMA9      = INVALID_HANDLE;
int         g_hEMA21     = INVALID_HANDLE;
int         g_hEMA200D1  = INVALID_HANDLE;

FibState    g_state      = FS_WAITING;
SessionType g_curSession = SES_NONE;
datetime    g_lastDay    = 0;
bool        g_londonDone = false;
bool        g_nyDone     = false;

// Protezione perdite
double g_dayStartBalance   = 0;   // Bilancio all'inizio della giornata
double g_monthStartBalance = 0;   // Bilancio all'inizio del mese
int    g_lastMonth         = -1;  // Mese corrente (per reset mensile)
bool   g_dailyLimitHit     = false;
bool   g_monthlyLimitHit   = false;

double g_orHigh      = 0;
double g_orLow       = 0;
bool   g_orValid     = false;
int    g_breakDir    = 0;   // +1 LONG / -1 SHORT
double g_fibAnchor   = 0;
double g_fibExtreme  = 0;
double g_fib1Entry   = 0;   // Livello 61.8%
double g_fib2Entry   = 0;   // Livello 50.0%
double g_fibSL       = 0;   // Stop Loss FIB1 (78.6%)
double g_fib2SL      = 0;   // Stop Loss FIB2 (61.8% = livello FIB1)
double g_fibTP       = 0;   // Take Profit (estremo)
ulong  g_ticket1     = 0;   // Ticket ordine FIB1
ulong  g_ticket2     = 0;   // Ticket ordine FIB2
bool   g_tp1Hit      = false;  // TP raggiunto da posizione FIB1
bool   g_tp2Hit      = false;  // TP raggiunto da posizione FIB2
ulong  g_pos1Ticket  = 0;   // Ticket posizione aperta da FIB1
ulong  g_pos2Ticket  = 0;   // Ticket posizione aperta da FIB2
int    g_barsAfterBrk = 0;
double g_d1LotFactor = 1.0; // Fattore correttivo lotto da filtro D1

//===================================================================
// UTILITY: TEMPO
//===================================================================
datetime BrokerToCET(datetime t)
{
    return t + (datetime)(InpBrokerCETOffset * 3600);
}

bool IsInSessionOR(datetime t, SessionType ses)
{
    MqlDateTime dt;
    TimeToStruct(BrokerToCET(t), dt);
    int m = dt.hour * 60 + dt.min;
    if(ses == SES_LONDON)
        return InpUseLondonSession &&
               m >= InpLondonORStartHour * 60 + InpLondonORStartMin &&
               m <  InpLondonOREndHour   * 60 + InpLondonOREndMin;
    if(ses == SES_NY)
        return InpUseNYSession &&
               m >= InpNYORStartHour * 60 + InpNYORStartMin &&
               m <  InpNYOREndHour   * 60 + InpNYOREndMin;
    return false;
}

bool IsAfterSessionOR(datetime t, SessionType ses)
{
    MqlDateTime dt;
    TimeToStruct(BrokerToCET(t), dt);
    int m = dt.hour * 60 + dt.min;
    if(ses == SES_LONDON)
        return m >= InpLondonOREndHour * 60 + InpLondonOREndMin;
    if(ses == SES_NY)
        return m >= InpNYOREndHour * 60 + InpNYOREndMin;
    return false;
}

bool IsSessionExpired(datetime t, SessionType ses)
{
    MqlDateTime dt;
    TimeToStruct(BrokerToCET(t), dt);
    int m = dt.hour * 60 + dt.min;
    if(ses == SES_LONDON && InpLondonExpireHour > 0)
        return m >= InpLondonExpireHour * 60 + InpLondonExpireMin;
    if(ses == SES_NY && InpNYExpireHour > 0)
        return m >= InpNYExpireHour * 60 + InpNYExpireMin;
    return false;
}

bool IsNewDay(datetime t)
{
    if(g_lastDay == 0) return true;
    MqlDateTime a, b;
    TimeToStruct(BrokerToCET(t), a);
    TimeToStruct(BrokerToCET(g_lastDay), b);
    return (a.year != b.year || a.mon != b.mon || a.day != b.day);
}

//===================================================================
// UTILITY: INDICATORI
//===================================================================
double GetEMA(int h)
{
    if(h == INVALID_HANDLE) return 0;
    double buf[];
    ArraySetAsSeries(buf, true);
    return (CopyBuffer(h, 0, 0, 1, buf) > 0) ? buf[0] : 0;
}

int GetEMAFilter()
{
    double e9  = GetEMA(g_hEMA9);
    double e21 = GetEMA(g_hEMA21);
    if(e9 <= 0 || e21 <= 0) return 0;
    return (e9 > e21) ? 1 : (e9 < e21) ? -1 : 0;
}

// Restituisce +1 (bull) / -1 (bear) / 0 (non disponibile)
int GetD1Direction()
{
    if(!InpD1_FilterEnabled || g_hEMA200D1 == INVALID_HANDLE) return 0;
    double ema[];
    ArraySetAsSeries(ema, true);
    if(CopyBuffer(g_hEMA200D1, 0, 0, 1, ema) <= 0) return 0;
    double cl[];
    ArraySetAsSeries(cl, true);
    if(CopyClose(g_sym, PERIOD_D1, 1, 1, cl) <= 0) return 0;
    int d = (cl[0] > ema[0]) ? 1 : -1;
    Print(StringFormat("[D1] %s | Close=%.2f EMA%d=%.2f",
          d == 1 ? "RIALZISTA" : "RIBASSISTA",
          cl[0], InpD1_EMAPeriod, ema[0]));
    return d;
}

//===================================================================
// PROTEZIONE PERDITE: CONTROLLO LIMITI GIORNALIERI E MENSILI
//===================================================================
bool IsDailyLossLimitHit()
{
    if(!InpUseDailyLossLimit || InpMaxDailyLossPct <= 0) return false;
    if(g_dayStartBalance <= 0) return false;
    double curBal  = AccountInfoDouble(ACCOUNT_BALANCE);
    double lossPct = (g_dayStartBalance - curBal) / g_dayStartBalance * 100.0;
    if(lossPct >= InpMaxDailyLossPct)
    {
        if(!g_dailyLimitHit)
            Print(StringFormat("[RISK] Limite giornaliero raggiunto: -%.2f%% (max %.1f%%) -> stop oggi",
                  lossPct, InpMaxDailyLossPct));
        return true;
    }
    return false;
}

bool IsMonthlyLossLimitHit()
{
    if(!InpUseMonthlyLossLimit || InpMaxMonthlyLossPct <= 0) return false;
    if(g_monthStartBalance <= 0) return false;
    double curBal  = AccountInfoDouble(ACCOUNT_BALANCE);
    double lossPct = (g_monthStartBalance - curBal) / g_monthStartBalance * 100.0;
    if(lossPct >= InpMaxMonthlyLossPct)
    {
        if(!g_monthlyLimitHit)
            Print(StringFormat("[RISK] Limite mensile raggiunto: -%.2f%% (max %.1f%%) -> stop mese",
                  lossPct, InpMaxMonthlyLossPct));
        return true;
    }
    return false;
}

//===================================================================
// FIBONACCI
//===================================================================
void CalcFibLevels()
{
    double range = MathAbs(g_fibExtreme - g_fibAnchor);
    if(range <= 0) return;

    g_fibTP = g_fibExtreme; // TP = estremo post-breakout

    if(g_breakDir == 1) // LONG: prezzo ritraccia verso il basso
    {
        g_fib1Entry = g_fibExtreme - InpFib_Entry1 * range; // 61.8%
        g_fib2Entry = g_fibExtreme - InpFib_Entry2 * range; // 50.0%
        g_fibSL     = g_fibExtreme - InpFib_SL     * range; // 78.6% -> SL per FIB1
        g_fib2SL    = g_fibExtreme - InpFib_SL2    * range; // 61.8% -> SL per FIB2 (= livello FIB1)
    }
    else // SHORT: prezzo ritraccia verso l'alto
    {
        g_fib1Entry = g_fibExtreme + InpFib_Entry1 * range; // 61.8%
        g_fib2Entry = g_fibExtreme + InpFib_Entry2 * range; // 50.0%
        g_fibSL     = g_fibExtreme + InpFib_SL     * range; // 78.6% -> SL per FIB1
        g_fib2SL    = g_fibExtreme + InpFib_SL2    * range; // 61.8% -> SL per FIB2
    }
}

//===================================================================
// UTILITY: PREZZI E LOTTI
//===================================================================
double NormPrice(double p)
{
    double ts = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
    int    dg = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
    if(ts <= 0) ts = SymbolInfoDouble(g_sym, SYMBOL_POINT);
    return NormalizeDouble(MathRound(p / ts) * ts, dg);
}

double NormLot(double l)
{
    double mn = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
    double mx = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
    double st = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
    if(st <= 0) st = 0.01;
    return MathMax(mn, MathMin(mx, MathFloor(l / st) * st));
}

// factor: moltiplicatore aggiuntivo (D1 soft mode, entry2 reduced lot, ecc.)
double CalcLots(double slDist, double factor)
{
    if(factor <= 0) factor = 1.0;
    if(slDist <= 0 || InpRiskPct <= 0) return NormLot(InpLotSize * factor);
    double tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
    double ts = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
    if(ts <= 0 || tv <= 0) return NormLot(InpLotSize * factor);
    double rawLot = (AccountInfoDouble(ACCOUNT_BALANCE) * InpRiskPct / 100.0)
                    / ((slDist / ts) * tv);
    return NormLot(rawLot * factor);
}

//===================================================================
// UTILITY: POSIZIONI E ORDINI
//===================================================================
bool HasPosition()
{
    for(int i = 0; i < PositionsTotal(); i++)
    {
        ulong t = PositionGetTicket(i);
        if(PositionSelectByTicket(t) &&
           PositionGetString(POSITION_SYMBOL)  == g_sym &&
           PositionGetInteger(POSITION_MAGIC)  == InpMagicNumber)
            return true;
    }
    return false;
}

bool IsTicketPending(ulong ticket)
{
    if(ticket == 0) return false;
    for(int i = 0; i < OrdersTotal(); i++)
    {
        if(OrderGetTicket(i)             == ticket         &&
           OrderGetString(ORDER_SYMBOL)  == g_sym          &&
           OrderGetInteger(ORDER_MAGIC)  == InpMagicNumber)
            return true;
    }
    return false;
}

void CancelTicket(ulong &ticket, string reason)
{
    if(ticket == 0) return;
    if(IsTicketPending(ticket))
    {
        if(g_trade.OrderDelete(ticket))
            Print(StringFormat("[CANCEL] #%d | %s", ticket, reason));
        else
            Print(StringFormat("[CANCEL] Errore #%d: %s", ticket,
                  g_trade.ResultRetcodeDescription()));
    }
    ticket = 0;
}

void CancelAllPending(string reason)
{
    CancelTicket(g_ticket1, reason);
    CancelTicket(g_ticket2, reason);
}

//===================================================================
// RESET VARIABILI DI SESSIONE
//===================================================================
void ResetSessionVars()
{
    g_orHigh      = 0; g_orLow = 0; g_orValid = false;
    g_breakDir    = 0; g_fibAnchor = 0; g_fibExtreme = 0;
    g_fib1Entry   = 0; g_fib2Entry = 0; g_fibSL = 0; g_fib2SL = 0; g_fibTP = 0;
    g_ticket1     = 0; g_ticket2 = 0;
    g_tp1Hit      = false; g_tp2Hit = false;
    g_pos1Ticket  = 0;  g_pos2Ticket = 0;
    g_barsAfterBrk = 0; g_d1LotFactor = 1.0;
}

//===================================================================
// AGGIORNAMENTO OPENING RANGE
//===================================================================
void UpdateOR()
{
    double h[], l[];
    ArraySetAsSeries(h, true); ArraySetAsSeries(l, true);
    if(CopyHigh(g_sym, PERIOD_M5, 1, 1, h) <= 0) return;
    if(CopyLow(g_sym,  PERIOD_M5, 1, 1, l) <= 0) return;
    if(!g_orValid) { g_orHigh = h[0]; g_orLow = l[0]; g_orValid = true; }
    else
    {
        if(h[0] > g_orHigh) g_orHigh = h[0];
        if(l[0] < g_orLow)  g_orLow  = l[0];
    }
}

//===================================================================
// RILEVAMENTO BREAKOUT
//===================================================================
int CheckBreakout()
{
    if(!g_orValid || g_orHigh <= g_orLow) return 0;
    double o[], h[], l[], c[];
    ArraySetAsSeries(o, true); ArraySetAsSeries(h, true);
    ArraySetAsSeries(l, true); ArraySetAsSeries(c, true);
    if(CopyOpen(g_sym,  PERIOD_M5, 1, 1, o) <= 0) return 0;
    if(CopyHigh(g_sym,  PERIOD_M5, 1, 1, h) <= 0) return 0;
    if(CopyLow(g_sym,   PERIOD_M5, 1, 1, l) <= 0) return 0;
    if(CopyClose(g_sym, PERIOD_M5, 1, 1, c) <= 0) return 0;

    double range = h[0] - l[0];
    if(range <= 0) return 0;
    double body = MathAbs(c[0] - o[0]);
    if(body / range < InpMinBodyRatio) return 0;

    if(c[0] > g_orHigh && c[0] > o[0])
    {
        Print(StringFormat("[BRK] LONG | Close=%.2f OR_H=%.2f Corpo=%.0f%%",
              c[0], g_orHigh, body / range * 100));
        return 1;
    }
    if(c[0] < g_orLow && c[0] < o[0])
    {
        Print(StringFormat("[BRK] SHORT | Close=%.2f OR_L=%.2f Corpo=%.0f%%",
              c[0], g_orLow, body / range * 100));
        return -1;
    }
    return 0;
}

//===================================================================
// PIAZZAMENTO ORDINI LIMITE (FIB1 + FIB2)
//===================================================================
bool PlaceLimitOrders()
{
    double sl  = NormPrice(g_fibSL);
    double tp  = NormPrice(g_fibTP);
    string ses = (g_curSession == SES_LONDON) ? "LON" : "NY";

    // ---- FIB1: 61.8% ----
    double lmt1    = NormPrice(g_fib1Entry);
    double slDst1  = MathAbs(lmt1 - sl);
    double rwd1    = MathAbs(tp   - lmt1);

    if(slDst1 <= 0)
    { Print("[FIB1] Distanza SL nulla -> skip"); return false; }
    if(rwd1 / slDst1 < InpMinRR)
    { Print(StringFormat("[FIB1] RR=%.2f < %.2f -> skip", rwd1 / slDst1, InpMinRR)); return false; }

    double lots1 = CalcLots(slDst1, g_d1LotFactor);

    bool ok1 = (g_breakDir == 1) ?
               g_trade.BuyLimit(lots1, lmt1, g_sym, sl, tp,
                                ORDER_TIME_DAY, 0, "ORB_FIB1_BUY_"  + ses) :
               g_trade.SellLimit(lots1, lmt1, g_sym, sl, tp,
                                 ORDER_TIME_DAY, 0, "ORB_FIB1_SELL_" + ses);
    if(!ok1)
    { Print("[FIB1] Errore: ", g_trade.ResultRetcodeDescription()); return false; }

    g_ticket1 = g_trade.ResultOrder();
    Print(StringFormat("[FIB1] %s | Entry=%.2f SL=%.2f TP=%.2f Lot=%.2f RR=1:%.2f",
          g_breakDir == 1 ? "LONG" : "SHORT", lmt1, sl, tp, lots1, rwd1 / slDst1));

    // ---- FIB2: 50.0% con SL al 61.8% (RR ~4:1) ----
    if(InpUseEntry2)
    {
        double lmt2   = NormPrice(g_fib2Entry);
        double sl2    = NormPrice(g_fib2SL);       // SL al 61.8% = livello FIB1
        double slDst2 = MathAbs(lmt2 - sl2);
        double rwd2   = MathAbs(tp   - lmt2);

        if(slDst2 > 0 && rwd2 / slDst2 >= InpMinRR)
        {
            double lots2 = CalcLots(slDst2, g_d1LotFactor * InpEntry2LotFactor);

            bool ok2 = (g_breakDir == 1) ?
                       g_trade.BuyLimit(lots2, lmt2, g_sym, sl2, tp,
                                        ORDER_TIME_DAY, 0, "ORB_FIB2_BUY_"  + ses) :
                       g_trade.SellLimit(lots2, lmt2, g_sym, sl2, tp,
                                         ORDER_TIME_DAY, 0, "ORB_FIB2_SELL_" + ses);
            if(ok2)
            {
                g_ticket2 = g_trade.ResultOrder();
                Print(StringFormat("[FIB2] %s | Entry=%.2f SL=%.2f(61.8%%) Lot=%.2f RR=1:%.2f",
                      g_breakDir == 1 ? "LONG" : "SHORT", lmt2, sl2, lots2, rwd2 / slDst2));
            }
            else
                Print("[FIB2] Errore: ", g_trade.ResultRetcodeDescription());
        }
        else
            Print(StringFormat("[FIB2] RR=%.2f < %.2f -> skip",
                  (slDst2 > 0) ? rwd2 / slDst2 : 0.0, InpMinRR));
    }

    return true; // FIB1 piazzato con successo
}

//===================================================================
// TRAILING STOP CON EMA9 — gestione separata FIB1 e FIB2
//===================================================================
void ManageEMATrail()
{
    double ema9 = GetEMA(g_hEMA9);
    if(ema9 <= 0) return;

    double cl[];
    ArraySetAsSeries(cl, true);
    if(CopyClose(g_sym, PERIOD_M5, 1, 1, cl) <= 0) return;

    bool anyOpen = false;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL)  != g_sym) continue;
        if(PositionGetInteger(POSITION_MAGIC)  != InpMagicNumber) continue;

        anyOpen = true;
        ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

        // Determina se questa posizione è FIB1 o FIB2
        bool isFib1 = (ticket == g_pos1Ticket);

        // Leggi il flag TP corretto (MQL5 non supporta & con operatore ternario)
        bool tpAlreadyHit = isFib1 ? g_tp1Hit : g_tp2Hit;

        // Controlla raggiungimento TP
        if(!tpAlreadyHit)
        {
            double cur = (pt == POSITION_TYPE_BUY) ?
                         SymbolInfoDouble(g_sym, SYMBOL_BID) :
                         SymbolInfoDouble(g_sym, SYMBOL_ASK);
            bool justHit = false;
            if(pt == POSITION_TYPE_BUY  && cur >= g_fibTP) justHit = true;
            if(pt == POSITION_TYPE_SELL && cur <= g_fibTP) justHit = true;
            if(justHit)
            {
                // Scrivi il flag corretto esplicitamente
                if(isFib1) g_tp1Hit = true; else g_tp2Hit = true;
                tpAlreadyHit = true;
                Print(StringFormat("[TRAIL] TP raggiunto pos #%d -> EMA9 trailing attivo", ticket));
            }
        }
        if(!tpAlreadyHit) continue;

        // Chiusura su segnale EMA9
        if(pt == POSITION_TYPE_BUY  && cl[0] < ema9)
        {
            g_trade.PositionClose(ticket);
            Print(StringFormat("[TRAIL] LONG #%d chiuso sotto EMA9=%.2f", ticket, ema9));
        }
        else if(pt == POSITION_TYPE_SELL && cl[0] > ema9)
        {
            g_trade.PositionClose(ticket);
            Print(StringFormat("[TRAIL] SHORT #%d chiuso sopra EMA9=%.2f", ticket, ema9));
        }
    }

    // Se non ci sono più posizioni aperte, sessione terminata
    if(!anyOpen) g_state = FS_DONE;
}

//===================================================================
// PROCESSAMENTO SESSIONE — MACCHINA A STATI
//===================================================================
void ProcessSession(datetime now)
{
    if(g_state == FS_DONE) return;

    // Filtro spread (solo live, non nel tester)
    if(InpMaxSpread > 0 && !MQLInfoInteger(MQL_TESTER))
    {
        if((int)SymbolInfoInteger(g_sym, SYMBOL_SPREAD) > InpMaxSpread) return;
    }

    // ----------------------------------------------------------------
    // FASE 1: Raccolta dati nella finestra OR
    // ----------------------------------------------------------------
    if(IsInSessionOR(now, g_curSession))
    {
        if(g_state == FS_WAITING)
        {
            g_state = FS_FORMING;
            Print(StringFormat("[OR][%s] Inizio | %s",
                  g_curSession == SES_LONDON ? "LON" : "NY",
                  TimeToString(BrokerToCET(now), TIME_MINUTES)));
        }
        UpdateOR();
        return;
    }

    // Non siamo ancora dopo la finestra OR -> nessuna azione
    if(!IsAfterSessionOR(now, g_curSession)) return;

    // OR non valido -> sessione saltata
    if(!g_orValid || g_orHigh <= g_orLow) { g_state = FS_DONE; return; }

    // ----------------------------------------------------------------
    // FASE 2: Validazione ampiezza del range OR
    // ----------------------------------------------------------------
    if(g_state == FS_FORMING)
    {
        double orW = g_orHigh - g_orLow;
        if(InpOR_MinUSD > 0 && orW < InpOR_MinUSD)
        {
            Print(StringFormat("[OR] Stretto $%.2f < $%.2f -> skip", orW, InpOR_MinUSD));
            g_state = FS_DONE;
            return;
        }
        if(InpOR_MaxUSD > 0 && orW > InpOR_MaxUSD)
        {
            Print(StringFormat("[OR] Ampio $%.2f > $%.2f -> skip", orW, InpOR_MaxUSD));
            g_state = FS_DONE;
            return;
        }
        g_state = FS_READY;
        Print(StringFormat("[OR][%s] Fissato | H=%.2f L=%.2f Amp=$%.2f",
              g_curSession == SES_LONDON ? "LON" : "NY",
              g_orHigh, g_orLow, orW));
    }

    // Scadenza ordine pendente
    if(g_state == FS_ORDER_PLACED && IsSessionExpired(now, g_curSession))
    {
        Print(StringFormat("[EXPIRE] Scadenza sessione %s",
              g_curSession == SES_LONDON ? "LON" : "NY"));
        CancelAllPending("scadenza");
        g_state = FS_DONE;
        return;
    }

    // ----------------------------------------------------------------
    // FASE 3: Rilevamento breakout + filtri
    // ----------------------------------------------------------------
    if(g_state == FS_READY)
    {
        int brk = CheckBreakout();
        if(brk != 0)
        {
            // Filtro D1 EMA200
            int d1 = GetD1Direction();
            if(InpD1_FilterEnabled && d1 != 0 && d1 != brk)
            {
                if(!InpD1_SoftMode)
                {
                    Print("[D1] Hard block: breakout controtendenza -> skip");
                    g_state = FS_DONE;
                    return;
                }
                // Soft mode: permette ma riduce il lotto
                g_d1LotFactor = InpD1_SoftLotFactor;
                Print(StringFormat("[D1] Soft mode | lotto ridotto x%.2f", g_d1LotFactor));
            }

            // Filtro EMA M5
            int emaDir = GetEMAFilter();
            if(emaDir != 0 && emaDir != brk)
            {
                Print("[EMA M5] Controtendenza -> skip");
                g_state = FS_DONE;
                return;
            }

            g_breakDir    = brk;
            g_fibAnchor   = (brk == 1) ? g_orLow  : g_orHigh;
            g_fibExtreme  = (brk == 1) ? g_orHigh : g_orLow;
            g_barsAfterBrk = 0;
            g_state = FS_BREAKOUT;
            Print(StringFormat("[BRK] %s | Anchor=%.2f Extreme=%.2f",
                  brk == 1 ? "LONG" : "SHORT", g_fibAnchor, g_fibExtreme));
        }
        return;
    }

    // ----------------------------------------------------------------
    // FASE 4: Tracking estremo + piazzamento ordini
    // ----------------------------------------------------------------
    if(g_state == FS_BREAKOUT)
    {
        double h[], l[], c[];
        ArraySetAsSeries(h, true); ArraySetAsSeries(l, true); ArraySetAsSeries(c, true);
        if(CopyHigh(g_sym,  PERIOD_M5, 1, 1, h) <= 0) return;
        if(CopyLow(g_sym,   PERIOD_M5, 1, 1, l) <= 0) return;
        if(CopyClose(g_sym, PERIOD_M5, 0, 1, c) <= 0) return;

        g_barsAfterBrk++;
        bool updated = false;
        if(g_breakDir ==  1 && h[0] > g_fibExtreme) { g_fibExtreme = h[0]; updated = true; }
        if(g_breakDir == -1 && l[0] < g_fibExtreme) { g_fibExtreme = l[0]; updated = true; }

        CalcFibLevels();

        // SL 78.6% già violato prima del fill -> annulla
        if(g_breakDir ==  1 && c[0] < g_fibSL)
        { Print("[FIB] 78.6% violato pre-entry -> stop"); g_state = FS_DONE; return; }
        if(g_breakDir == -1 && c[0] > g_fibSL)
        { Print("[FIB] 78.6% violato pre-entry -> stop"); g_state = FS_DONE; return; }

        // Estremo stabile per InpBarsToConfirmExtreme barre consecutive
        if(g_barsAfterBrk >= InpBarsToConfirmExtreme && !updated)
        {
            Print(StringFormat("[FIB] Estremo=%.2f confermato | FIB1=%.2f FIB2=%.2f SL=%.2f TP=%.2f",
                  g_fibExtreme, g_fib1Entry, g_fib2Entry, g_fibSL, g_fibTP));
            g_state = PlaceLimitOrders() ? FS_ORDER_PLACED : FS_DONE;
        }
        return;
    }

    // ----------------------------------------------------------------
    // FASE 5: Attesa fill degli ordini limite
    // ----------------------------------------------------------------
    if(g_state == FS_ORDER_PLACED)
    {
        bool p1 = IsTicketPending(g_ticket1);
        bool p2 = IsTicketPending(g_ticket2);

        // Conta le posizioni aperte con il nostro magic number
        int openPositions = 0;
        for(int i = 0; i < PositionsTotal(); i++)
        {
            ulong t = PositionGetTicket(i);
            if(PositionSelectByTicket(t) &&
               PositionGetString(POSITION_SYMBOL) == g_sym &&
               PositionGetInteger(POSITION_MAGIC) == InpMagicNumber)
                openPositions++;
        }

        // --- FIB1 (61.8%) riempito: era pending, ora non c'è più ---
        if(g_ticket1 != 0 && !p1 && g_pos1Ticket == 0)
        {
            // Cerca il ticket della posizione appena aperta
            for(int i = 0; i < PositionsTotal(); i++)
            {
                ulong t = PositionGetTicket(i);
                if(PositionSelectByTicket(t) &&
                   PositionGetString(POSITION_SYMBOL) == g_sym &&
                   PositionGetInteger(POSITION_MAGIC) == InpMagicNumber &&
                   t != g_pos2Ticket)
                {
                    g_pos1Ticket = t;
                    Print(StringFormat("[FILL] FIB1 (61.8%%) riempito -> pos #%d", g_pos1Ticket));
                    // CORREZIONE BUG #2: NON cancelliamo FIB2 automaticamente.
                    // FIB2 è a 50%, più profondo: può essere riempito se il
                    // ritracciamento continua. Lo lasciamo attivo.
                    // Lo annulliamo solo alla scadenza sessione.
                    break;
                }
            }
            g_ticket1 = 0;
        }

        // --- FIB2 (50%) riempito ---
        if(g_ticket2 != 0 && !p2 && g_pos2Ticket == 0)
        {
            for(int i = 0; i < PositionsTotal(); i++)
            {
                ulong t = PositionGetTicket(i);
                if(PositionSelectByTicket(t) &&
                   PositionGetString(POSITION_SYMBOL) == g_sym &&
                   PositionGetInteger(POSITION_MAGIC) == InpMagicNumber &&
                   t != g_pos1Ticket)
                {
                    g_pos2Ticket = t;
                    Print(StringFormat("[FILL] FIB2 (50.0%%) riempito -> pos #%d", g_pos2Ticket));
                    break;
                }
            }
            g_ticket2 = 0;
        }

        // Transizione a FS_TRADED se almeno una posizione è aperta
        if(openPositions > 0)
        {
            g_state = FS_TRADED;
            Print(StringFormat("[FILL] %d posizione/i attiva/e -> FS_TRADED", openPositions));
            return;
        }

        // Nessuna posizione e nessun ordine pendente -> fine sessione
        if(!p1 && !p2 && openPositions == 0)
        {
            Print("[ORDINE] Nessun ordine/posizione attiva -> FS_DONE");
            g_state = FS_DONE;
        }
    }
}

//===================================================================
// INIT
//===================================================================
int OnInit()
{
    g_sym = (InpSymbol == "") ? _Symbol : InpSymbol;

    g_trade.SetExpertMagicNumber(InpMagicNumber);
    g_trade.SetDeviationInPoints(50);
    g_trade.SetTypeFilling(ORDER_FILLING_IOC);
    g_trade.LogLevel(LOG_LEVEL_ERRORS);

    g_hEMA9  = iMA(g_sym, PERIOD_M5, InpEMA_Fast, 0, MODE_EMA, PRICE_CLOSE);
    g_hEMA21 = iMA(g_sym, PERIOD_M5, InpEMA_Slow, 0, MODE_EMA, PRICE_CLOSE);
    if(g_hEMA9 == INVALID_HANDLE || g_hEMA21 == INVALID_HANDLE)
    { Print("[INIT] ERRORE: handle EMA M5 non valido!"); return INIT_FAILED; }

    if(InpD1_FilterEnabled)
    {
        g_hEMA200D1 = iMA(g_sym, PERIOD_D1, InpD1_EMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
        if(g_hEMA200D1 == INVALID_HANDLE)
            Print("[INIT] ATTENZIONE: handle EMA D1 non valido - filtro D1 disattivato");
        else
            Print(StringFormat("[INIT] D1 EMA%d attiva | SoftMode=%s | LotFactor=%.2f",
                  InpD1_EMAPeriod,
                  InpD1_SoftMode ? "SI" : "NO",
                  InpD1_SoftLotFactor));
    }

    g_state      = FS_WAITING;
    g_lastDay    = 0;
    g_londonDone = false;
    g_nyDone     = false;
    g_curSession = SES_NONE;
    ResetSessionVars();

    // Inizializzazione protezione perdite
    g_dayStartBalance   = AccountInfoDouble(ACCOUNT_BALANCE);
    g_monthStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
    g_lastMonth         = dt.mon;
    g_dailyLimitHit     = false;
    g_monthlyLimitHit   = false;

    Print("================================================");
    Print("  ORB GOLD FIBONACCI EA v3.21");
    Print("  >>> BugFix: Offset, DopioFill, Trailing <<<");
    Print("  Simbolo: ", g_sym);
    if(InpUseLondonSession)
        Print(StringFormat("  Londra : %d:%02d -> %d:%02d CET | Exp %d:%02d",
              InpLondonORStartHour, InpLondonORStartMin,
              InpLondonOREndHour,   InpLondonOREndMin,
              InpLondonExpireHour,  InpLondonExpireMin));
    if(InpUseNYSession)
        Print(StringFormat("  NY     : %d:%02d -> %d:%02d CET | Exp %d:%02d",
              InpNYORStartHour, InpNYORStartMin,
              InpNYOREndHour,   InpNYOREndMin,
              InpNYExpireHour,  InpNYExpireMin));
    Print(StringFormat("  FIB1=%.1f%% SL=%.1f%% | FIB2=%.1f%% SL=%.1f%%(x%.2f) | Corpo>=%.0f%%",
          InpFib_Entry1*100, InpFib_SL*100,
          InpFib_Entry2*100, InpFib_SL2*100,
          InpEntry2LotFactor, InpMinBodyRatio*100));
    Print(StringFormat("  OR: $%.1f-$%.1f | Rischio=%.1f%% | RR min=1:%.1f | Offset=%dh",
          InpOR_MinUSD, InpOR_MaxUSD, InpRiskPct, InpMinRR, InpBrokerCETOffset));
    Print(StringFormat("  Max Loss Giorno: %.1f%% | Mese: %.1f%% | D1 Soft: %.0f%%",
          InpMaxDailyLossPct, InpMaxMonthlyLossPct, InpD1_SoftLotFactor*100));
    Print("================================================");
    return INIT_SUCCEEDED;
}

//===================================================================
// TICK
//===================================================================
void OnTick()
{
    // Esegui solo su nuova barra M5 (evita ricalcoli multipli per tick)
    int barsNow = Bars(g_sym, PERIOD_M5);
    if(barsNow <= 0 || (int)g_lastBarM5 == barsNow) return;
    g_lastBarM5 = (datetime)barsNow;

    datetime now = TimeCurrent();

    // ---- RESET MENSILE (primo del mese) ----
    MqlDateTime nowDt; TimeToStruct(BrokerToCET(now), nowDt);
    if(nowDt.mon != g_lastMonth)
    {
        g_lastMonth         = nowDt.mon;
        g_monthStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        g_monthlyLimitHit   = false;
        Print(StringFormat("[MONTH] Nuovo mese -> bilancio base $%.2f", g_monthStartBalance));
    }

    // ---- RESET GIORNALIERO ----
    if(IsNewDay(now))
    {
        CancelAllPending("fine giornata");
        g_lastDay         = now;
        g_londonDone      = false;
        g_nyDone          = false;
        g_curSession      = SES_NONE;
        g_state           = FS_WAITING;
        g_dayStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        g_dailyLimitHit   = false;
        ResetSessionVars();
        Print(StringFormat("[DAY] Reset | %s | Bilancio $%.2f",
              TimeToString(BrokerToCET(now), TIME_DATE),
              g_dayStartBalance));
    }

    // ---- BLOCCO PER LIMITE PERDITA MENSILE ----
    if(IsMonthlyLossLimitHit())
    {
        if(!g_monthlyLimitHit) { CancelAllPending("limite mensile"); g_monthlyLimitHit = true; }
        return;
    }

    // ---- BLOCCO PER LIMITE PERDITA GIORNALIERA ----
    if(IsDailyLossLimitHit())
    {
        if(!g_dailyLimitHit) { CancelAllPending("limite giornaliero"); g_dailyLimitHit = true; }
        return;
    }

    // ---- TRAILING POSIZIONE ATTIVA ----
    if(g_state == FS_TRADED) { ManageEMATrail(); return; }

    // ---- TRANSIZIONE: LONDRA COMPLETATA -> pronto per NY ----
    if(g_curSession == SES_LONDON && g_state == FS_DONE)
    {
        g_londonDone = true;
        g_curSession = SES_NONE;
        g_state      = FS_WAITING;
        ResetSessionVars();
        Print("[SESSION] Londra chiusa -> in attesa di NY");
    }

    // ---- TRANSIZIONE: NY COMPLETATA ----
    if(g_curSession == SES_NY && g_state == FS_DONE)
    {
        g_nyDone = true;
        return; // Giornata operativa finita
    }

    // ---- NY COMPLETATA: nessuna ulteriore azione oggi ----
    if(g_nyDone) return;

    // ---- RILEVAMENTO SESSIONE ATTIVA ----
    if(g_curSession == SES_NONE)
    {
        // Controlla finestra Londra
        if(!g_londonDone && IsInSessionOR(now, SES_LONDON))
        {
            g_curSession = SES_LONDON;
            Print(StringFormat("[SESSION] Londra avviata | %s",
                  TimeToString(BrokerToCET(now), TIME_MINUTES)));
        }
        // Controlla finestra NY
        else if(!g_nyDone && IsInSessionOR(now, SES_NY))
        {
            g_curSession = SES_NY;
            Print(StringFormat("[SESSION] New York avviata | %s",
                  TimeToString(BrokerToCET(now), TIME_MINUTES)));
        }
        else return; // Nessuna sessione attiva in questo momento
    }

    // ---- PROCESSING SESSIONE ----
    ProcessSession(now);
}

//===================================================================
// DEINIT
//===================================================================
void OnDeinit(const int reason)
{
    CancelAllPending("deinit");
    if(g_hEMA9     != INVALID_HANDLE) IndicatorRelease(g_hEMA9);
    if(g_hEMA21    != INVALID_HANDLE) IndicatorRelease(g_hEMA21);
    if(g_hEMA200D1 != INVALID_HANDLE) IndicatorRelease(g_hEMA200D1);
    Print(StringFormat("ORB GOLD FIBONACCI EA v3.21 - Rimosso | reason=%d", reason));
}
