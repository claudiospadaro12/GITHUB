//+------------------------------------------------------------------+
//|                   ORB_GOLD_FIBONACCI_EA.mq5                      |
//| Fonte: ABTG Webinar ORB Avanzato – Emiliano Monza (pag.9-14)    |
//|                                                                  |
//| LOGICA v2.20 — ORDINE LIMITE + FILTRI OTTIMIZZATI               |
//|  1. OR 15:30-16:00 CET (apertura New York)                      |
//|  2. Filtro OR in $: scarta range piatti o troppo volatili       |
//|  3. Filtro D1 EMA200: solo LONG in bull trend (Gold 2025)       |
//|  4. Breakout confermato (corpo >= 60%)                          |
//|  5. Tracking estremo post-breakout (2 barre di conferma)        |
//|  6. ORDINE LIMITE al 61.8% Fibonacci                            |
//|  7. SL al 78.6% Fibonacci + buffer                              |
//|  8. TP al livello 0% (estremo post-breakout)                    |
//|  9. Scadenza ordine alle 20:00 CET                              |
//| 10. Trailing EMA9 post TP1                                      |
//|                                                                  |
//| TIMEFRAME: M5 | STRUMENTO: XAUUSD | OR: 15:30-16:00 CET        |
//+------------------------------------------------------------------+
#property copyright "ABTG ORB Gold Fibonacci v2.20 - Emiliano Monza"
#property version   "2.20"
#property description "ORB GOLD Fibonacci v2.2: limite 61.8% + D1 EMA200 + Risk=5%"

#include <Trade\Trade.mqh>

//===================================================================
// INPUT PARAMETERS
//===================================================================
input group "=== STRUMENTO ==="
input string InpSymbol               = "";

input group "=== ORARIO OR NEW YORK (CET) ==="
input int    InpORStartHour          = 15;
input int    InpORStartMin           = 30;
input int    InpOREndHour            = 16;
input int    InpOREndMin             = 0;
input int    InpBrokerCETOffset      = 0;     // -1 per BCM Markets

input group "=== EMA FILTER ==="
input int    InpEMA_Fast             = 9;
input int    InpEMA_Slow             = 21;

input group "=== FIBONACCI ==="
input double InpFib_Entry            = 0.618; // Livello ordine limite (61.8%)
input double InpFib_SL               = 0.786; // Stop Loss (78.6%)

input group "=== BREAKOUT ==="
input double InpMinBodyRatio         = 0.60;  // Corpo min breakout
input int    InpBarsToConfirmExtreme = 2;     // Barre conferma estremo

input group "=== FILTRO OR IN DOLLARI ==="
input double InpOR_MinUSD            = 10.0;  // OR minimo $ (sotto = piatto)
input double InpOR_MaxUSD            = 40.0;  // OR massimo $ (sopra = troppo volatile)

input group "=== SCADENZA ORDINE ==="
input int    InpOrderExpireHour      = 20;
input int    InpOrderExpireMin       = 0;

input group "=== FILTRO TREND D1 ==="
input bool   InpD1_FilterEnabled     = true;
input int    InpD1_EMAPeriod         = 200;

input group "=== MONEY MANAGEMENT ==="
input double InpRiskPct              = 5.0;   // Rischio % per trade (Gold: alta qualità, pochi trade)
input double InpMinRR                = 1.5;
input double InpLotSize              = 0.1;

input group "=== FILTRI ==="
input int    InpMaxSpread            = 50;
input int    InpMagicNumber          = 20260304;

//===================================================================
// GLOBAL VARIABLES
//===================================================================
CTrade g_trade;
string g_sym = "";
datetime g_lastBarM5 = 0;
int g_hEMA9 = INVALID_HANDLE;
int g_hEMA21 = INVALID_HANDLE;
int g_hEMA200D1 = INVALID_HANDLE;

enum FibState { FS_WAITING, FS_FORMING, FS_READY, FS_BREAKOUT, FS_ORDER_PLACED, FS_TRADED, FS_DONE };
FibState g_state = FS_WAITING;
datetime g_lastDay = 0;

double g_orHigh = 0, g_orLow = 0;
bool   g_orValid = false;
int    g_breakDir = 0;
double g_fibAnchor = 0, g_fibExtreme = 0;
double g_fibEntryPrice = 0, g_fibSLPrice = 0, g_fibTP1Price = 0;
bool   g_tp1Hit = false;
int    g_barsAfterBrk = 0;
ulong  g_pendingTicket = 0;

//===================================================================
// UTILITY
//===================================================================
datetime BrokerToCET(datetime t) { return t + (datetime)(InpBrokerCETOffset*3600); }

bool IsInORWindow(datetime b)
{
    MqlDateTime dt; TimeToStruct(BrokerToCET(b), dt);
    int m = dt.hour*60+dt.min;
    return (m >= InpORStartHour*60+InpORStartMin && m < InpOREndHour*60+InpOREndMin);
}

bool IsAfterOR(datetime b)
{
    MqlDateTime dt; TimeToStruct(BrokerToCET(b), dt);
    return (dt.hour*60+dt.min >= InpOREndHour*60+InpOREndMin);
}

bool IsNewDay(datetime b)
{
    if(g_lastDay==0) return true;
    MqlDateTime a,c; TimeToStruct(BrokerToCET(b),a); TimeToStruct(BrokerToCET(g_lastDay),c);
    return (a.year!=c.year||a.mon!=c.mon||a.day!=c.day);
}

double GetEMA(int h)
{
    if(h==INVALID_HANDLE) return 0;
    double buf[]; ArraySetAsSeries(buf,true);
    return (CopyBuffer(h,0,0,1,buf)>0)?buf[0]:0;
}

int GetEMAFilter()
{
    double e9=GetEMA(g_hEMA9),e21=GetEMA(g_hEMA21);
    if(e9<=0||e21<=0) return 0;
    return (e9>e21)?1:(e9<e21)?-1:0;
}

int GetD1TrendBias()
{
    if(!InpD1_FilterEnabled) return 0;
    if(g_hEMA200D1==INVALID_HANDLE) return 0;
    double ema[]; ArraySetAsSeries(ema,true);
    if(CopyBuffer(g_hEMA200D1,0,0,1,ema)<=0) return 0;
    double cl[]; ArraySetAsSeries(cl,true);
    if(CopyClose(g_sym,PERIOD_D1,1,1,cl)<=0) return 0;
    if(cl[0]>ema[0]) { Print(StringFormat("[D1] RIALZISTA %.2f > EMA200 %.2f -> solo LONG",cl[0],ema[0])); return 1; }
    Print(StringFormat("[D1] RIBASSISTA %.2f < EMA200 %.2f -> solo SHORT",cl[0],ema[0]));
    return -1;
}

void CalcFibLevels()
{
    double range=MathAbs(g_fibExtreme-g_fibAnchor); if(range<=0) return;
    if(g_breakDir==1)
    {
        g_fibTP1Price   = g_fibExtreme;
        g_fibEntryPrice = g_fibExtreme - InpFib_Entry*range;
        g_fibSLPrice    = g_fibExtreme - InpFib_SL*range;
    }
    else
    {
        g_fibTP1Price   = g_fibExtreme;
        g_fibEntryPrice = g_fibExtreme + InpFib_Entry*range;
        g_fibSLPrice    = g_fibExtreme + InpFib_SL*range;
    }
}

double NormPrice(double p)
{
    double ts=SymbolInfoDouble(g_sym,SYMBOL_TRADE_TICK_SIZE);
    int dg=(int)SymbolInfoInteger(g_sym,SYMBOL_DIGITS);
    if(ts<=0) ts=SymbolInfoDouble(g_sym,SYMBOL_POINT);
    return NormalizeDouble(MathRound(p/ts)*ts,dg);
}

double NormLot(double l)
{
    double mn=SymbolInfoDouble(g_sym,SYMBOL_VOLUME_MIN);
    double mx=SymbolInfoDouble(g_sym,SYMBOL_VOLUME_MAX);
    double st=SymbolInfoDouble(g_sym,SYMBOL_VOLUME_STEP);
    if(st<=0) st=0.01;
    return MathMax(mn,MathMin(mx,MathFloor(l/st)*st));
}

double CalcLots(double slDist)
{
    if(InpRiskPct<=0||slDist<=0) return NormLot(InpLotSize);
    double tv=SymbolInfoDouble(g_sym,SYMBOL_TRADE_TICK_VALUE);
    double ts=SymbolInfoDouble(g_sym,SYMBOL_TRADE_TICK_SIZE);
    if(ts<=0||tv<=0) return NormLot(InpLotSize);
    return NormLot((AccountInfoDouble(ACCOUNT_BALANCE)*InpRiskPct/100.0)/((slDist/ts)*tv));
}

bool HasPosition()
{
    for(int i=0;i<PositionsTotal();i++)
    {
        ulong t=PositionGetTicket(i);
        if(PositionSelectByTicket(t)&&
           PositionGetString(POSITION_SYMBOL)==g_sym&&
           PositionGetInteger(POSITION_MAGIC)==InpMagicNumber) return true;
    }
    return false;
}

bool HasPendingOrder()
{
    if(g_pendingTicket==0) return false;
    for(int i=0;i<OrdersTotal();i++)
        if(OrderGetTicket(i)==g_pendingTicket&&
           OrderGetString(ORDER_SYMBOL)==g_sym&&
           OrderGetInteger(ORDER_MAGIC)==InpMagicNumber) return true;
    g_pendingTicket=0;
    return false;
}

void CancelPendingOrder(string reason)
{
    if(g_pendingTicket==0) return;
    if(HasPendingOrder())
    {
        if(g_trade.OrderDelete(g_pendingTicket))
            Print(StringFormat("[ORDINE] Cancellato #%d | %s",g_pendingTicket,reason));
    }
    g_pendingTicket=0;
}

bool PlaceLimitOrder()
{
    double sl=NormPrice(g_fibSLPrice);
    double tp=NormPrice(g_fibTP1Price);
    double lmt=NormPrice(g_fibEntryPrice);
    double lots=CalcLots(MathAbs(lmt-sl));
    double risk=MathAbs(lmt-sl),reward=MathAbs(tp-lmt);
    if(risk<=0||reward/risk<InpMinRR)
    { Print(StringFormat("[RR] %.2f < %.2f -> no ordine",reward/risk,InpMinRR)); return false; }
    Print(StringFormat("[LIMITE] %s | Entry=%.2f SL=%.2f TP=%.2f Lot=%.2f RR=1:%.2f",
          g_breakDir==1?"LONG":"SHORT",lmt,sl,tp,lots,reward/risk));
    bool ok=(g_breakDir==1)?
             g_trade.BuyLimit(lots,lmt,g_sym,sl,tp,ORDER_TIME_DAY,0,"ORB GOLD FIB BUY LMT"):
             g_trade.SellLimit(lots,lmt,g_sym,sl,tp,ORDER_TIME_DAY,0,"ORB GOLD FIB SELL LMT");
    if(ok){ g_pendingTicket=g_trade.ResultOrder(); Print("[LIMITE] Ordine #",g_pendingTicket); return true; }
    Print("[LIMITE] Errore: ",g_trade.ResultRetcodeDescription());
    return false;
}

void ManageEMATrail()
{
    for(int i=0;i<PositionsTotal();i++)
    {
        ulong ticket=PositionGetTicket(i);
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL)!=g_sym) continue;
        if(PositionGetInteger(POSITION_MAGIC)!=InpMagicNumber) continue;
        ENUM_POSITION_TYPE pt=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double ema9=GetEMA(g_hEMA9); if(ema9<=0) continue;
        double cl[]; ArraySetAsSeries(cl,true);
        if(CopyClose(g_sym,PERIOD_M5,1,1,cl)<=0) continue;
        if(!g_tp1Hit)
        {
            double cur=(pt==POSITION_TYPE_BUY)?SymbolInfoDouble(g_sym,SYMBOL_BID):SymbolInfoDouble(g_sym,SYMBOL_ASK);
            if(pt==POSITION_TYPE_BUY&&cur>=g_fibTP1Price) g_tp1Hit=true;
            if(pt==POSITION_TYPE_SELL&&cur<=g_fibTP1Price) g_tp1Hit=true;
            if(g_tp1Hit) Print("[TRAIL] TP1 raggiunto -> trailing EMA9");
        }
        if(!g_tp1Hit) return;
        if(pt==POSITION_TYPE_BUY&&cl[0]<ema9){ g_trade.PositionClose(ticket); g_state=FS_DONE; Print("[TRAIL] Long close<EMA9 -> chiudo"); }
        else if(pt==POSITION_TYPE_SELL&&cl[0]>ema9){ g_trade.PositionClose(ticket); g_state=FS_DONE; Print("[TRAIL] Short close>EMA9 -> chiudo"); }
    }
}

void UpdateOR()
{
    double h[],l[]; ArraySetAsSeries(h,true); ArraySetAsSeries(l,true);
    if(CopyHigh(g_sym,PERIOD_M5,1,1,h)<=0) return;
    if(CopyLow(g_sym,PERIOD_M5,1,1,l)<=0) return;
    if(!g_orValid){g_orHigh=h[0];g_orLow=l[0];g_orValid=true;}
    else{if(h[0]>g_orHigh)g_orHigh=h[0];if(l[0]<g_orLow)g_orLow=l[0];}
}

int CheckBreakout()
{
    if(!g_orValid||g_orHigh<=g_orLow) return 0;
    double o[],h[],l[],c[];
    ArraySetAsSeries(o,true);ArraySetAsSeries(h,true);ArraySetAsSeries(l,true);ArraySetAsSeries(c,true);
    if(CopyOpen(g_sym,PERIOD_M5,1,1,o)<=0) return 0;
    if(CopyHigh(g_sym,PERIOD_M5,1,1,h)<=0) return 0;
    if(CopyLow(g_sym,PERIOD_M5,1,1,l)<=0) return 0;
    if(CopyClose(g_sym,PERIOD_M5,1,1,c)<=0) return 0;
    double range=h[0]-l[0]; if(range<=0) return 0;
    double body=MathAbs(c[0]-o[0]);
    if(body/range<InpMinBodyRatio) return 0;
    if(c[0]>g_orHigh&&c[0]>o[0]) { Print(StringFormat("[BREAKOUT] LONG Close=%.2f OR H=%.2f Corpo=%.0f%%",c[0],g_orHigh,body/range*100)); return 1; }
    if(c[0]<g_orLow&&c[0]<o[0])  { Print(StringFormat("[BREAKOUT] SHORT Close=%.2f OR L=%.2f Corpo=%.0f%%",c[0],g_orLow,body/range*100)); return -1; }
    return 0;
}

int OnInit()
{
    g_sym=(InpSymbol=="")?_Symbol:InpSymbol;
    g_trade.SetExpertMagicNumber(InpMagicNumber);
    g_trade.SetDeviationInPoints(50);
    g_trade.SetTypeFilling(ORDER_FILLING_IOC);
    g_trade.LogLevel(LOG_LEVEL_ERRORS);
    g_hEMA9=iMA(g_sym,PERIOD_M5,InpEMA_Fast,0,MODE_EMA,PRICE_CLOSE);
    g_hEMA21=iMA(g_sym,PERIOD_M5,InpEMA_Slow,0,MODE_EMA,PRICE_CLOSE);
    if(g_hEMA9==INVALID_HANDLE||g_hEMA21==INVALID_HANDLE){Print("[INIT] ERRORE handle!");return INIT_FAILED;}
    if(InpD1_FilterEnabled)
    {
        g_hEMA200D1=iMA(g_sym,PERIOD_D1,InpD1_EMAPeriod,0,MODE_EMA,PRICE_CLOSE);
        if(g_hEMA200D1!=INVALID_HANDLE) Print("[INIT] Filtro D1 EMA",InpD1_EMAPeriod," attivo");
    }
    g_state=FS_WAITING; g_lastDay=0;
    Print("================================================");
    Print("  ORB GOLD FIBONACCI EA v2.20");
    Print("  OR NY: ",InpORStartHour,":",InpORStartMin," -> ",InpOREndHour,":",InpOREndMin," CET");
    Print("  Entry: ",InpFib_Entry*100,"% | SL: ",InpFib_SL*100,"%");
    Print("  OR filtro: $",InpOR_MinUSD,"-$",InpOR_MaxUSD);
    Print("  Scadenza: ",InpOrderExpireHour,":00 CET");
    Print("  D1 Filter: ",(InpD1_FilterEnabled?"ON":"OFF"));
    Print("  Rischio: ",InpRiskPct,"% | R:R min: 1:",InpMinRR);
    Print("  Offset: ",InpBrokerCETOffset,"h");
    Print("================================================");
    return INIT_SUCCEEDED;
}

void OnTick()
{
    int barsNow=Bars(g_sym,PERIOD_M5);
    if(barsNow<=0||(int)g_lastBarM5==barsNow) return;
    g_lastBarM5=(datetime)barsNow;
    datetime now=TimeCurrent();

    if(IsNewDay(now))
    {
        CancelPendingOrder("fine giornata");
        g_lastDay=now; g_state=FS_WAITING;
        g_orHigh=0;g_orLow=0;g_orValid=false;
        g_breakDir=0;g_fibAnchor=0;g_fibExtreme=0;
        g_fibEntryPrice=0;g_fibSLPrice=0;g_fibTP1Price=0;
        g_tp1Hit=false;g_barsAfterBrk=0;g_pendingTicket=0;
        Print(StringFormat("[DAY] Reset | %s",TimeToString(BrokerToCET(now),TIME_DATE)));
    }

    if(g_state==FS_TRADED){ManageEMATrail();return;}
    if(g_state==FS_DONE) return;

    if(InpMaxSpread>0&&!MQLInfoInteger(MQL_TESTER))
        if(SymbolInfoInteger(g_sym,SYMBOL_SPREAD)>InpMaxSpread) return;

    if(IsInORWindow(now))
    {
        if(g_state==FS_WAITING){g_state=FS_FORMING;Print(StringFormat("[OR] Inizio | %s",TimeToString(BrokerToCET(now),TIME_MINUTES)));}
        UpdateOR(); return;
    }
    if(!IsAfterOR(now)) return;
    if(!g_orValid||g_orHigh<=g_orLow){g_state=FS_DONE;return;}

    if(g_state==FS_FORMING)
    {
        double orWidth=g_orHigh-g_orLow;
        if(InpOR_MinUSD>0&&orWidth<InpOR_MinUSD){Print(StringFormat("[OR] STRETTO $%.2f < $%.2f -> skip",orWidth,InpOR_MinUSD));g_state=FS_DONE;return;}
        if(InpOR_MaxUSD>0&&orWidth>InpOR_MaxUSD){Print(StringFormat("[OR] AMPIO $%.2f > $%.2f -> skip",orWidth,InpOR_MaxUSD));g_state=FS_DONE;return;}
        g_state=FS_READY;
        Print(StringFormat("[OR] Fissato | H=%.2f L=%.2f Amp=$%.2f",g_orHigh,g_orLow,orWidth));
    }

    if(g_state==FS_READY)
    {
        int d1=GetD1TrendBias();
        int ema=GetEMAFilter();
        int brk=CheckBreakout();
        if(brk!=0)
        {
            if(d1!=0&&d1!=brk){Print(StringFormat("[D1] Breakout %s vs trend D1 -> skip",brk==1?"LONG":"SHORT"));g_state=FS_DONE;return;}
            if(ema!=0&&ema!=brk){Print("[EMA] Contrario al breakout -> skip");g_state=FS_DONE;return;}
            g_breakDir=brk;
            g_fibAnchor=(brk==1)?g_orLow:g_orHigh;
            g_fibExtreme=(brk==1)?g_orHigh:g_orLow;
            g_barsAfterBrk=0;
            g_state=FS_BREAKOUT;
            Print(StringFormat("[BREAKOUT] %s | Anchor=%.2f Extreme=%.2f",brk==1?"LONG":"SHORT",g_fibAnchor,g_fibExtreme));
        }
        return;
    }

    if(g_state==FS_BREAKOUT)
    {
        double h[],l[],c[];
        ArraySetAsSeries(h,true);ArraySetAsSeries(l,true);ArraySetAsSeries(c,true);
        if(CopyHigh(g_sym,PERIOD_M5,1,1,h)<=0) return;
        if(CopyLow(g_sym,PERIOD_M5,1,1,l)<=0) return;
        if(CopyClose(g_sym,PERIOD_M5,0,1,c)<=0) return;
        g_barsAfterBrk++;
        bool updated=false;
        if(g_breakDir==1&&h[0]>g_fibExtreme){g_fibExtreme=h[0];updated=true;}
        if(g_breakDir==-1&&l[0]<g_fibExtreme){g_fibExtreme=l[0];updated=true;}
        CalcFibLevels();
        if(g_breakDir==1&&c[0]<g_fibSLPrice){Print("[FIB] SL 78.6% violato -> stop");g_state=FS_DONE;return;}
        if(g_breakDir==-1&&c[0]>g_fibSLPrice){Print("[FIB] SL 78.6% violato -> stop");g_state=FS_DONE;return;}
        if(g_barsAfterBrk>=InpBarsToConfirmExtreme&&!updated)
        {
            Print(StringFormat("[FIB] Estremo %.2f confermato -> piazzo limite a %.2f",g_fibExtreme,g_fibEntryPrice));
            if(PlaceLimitOrder()) g_state=FS_ORDER_PLACED;
            else g_state=FS_DONE;
        }
        return;
    }

    if(g_state==FS_ORDER_PLACED)
    {
        if(HasPosition()&&!HasPendingOrder()){Print("[ORDINE] Riempito");g_pendingTicket=0;g_state=FS_TRADED;return;}
        if(InpOrderExpireHour>0)
        {
            MqlDateTime ct; TimeToStruct(BrokerToCET(now),ct);
            if(ct.hour*60+ct.min>=InpOrderExpireHour*60+InpOrderExpireMin)
            {Print(StringFormat("[ORDINE] Scadenza %d:%02d CET",InpOrderExpireHour,InpOrderExpireMin));CancelPendingOrder("scadenza");g_state=FS_DONE;return;}
        }
        if(!HasPendingOrder()){if(HasPosition()){Print("[ORDINE] Riempito");g_state=FS_TRADED;}else{Print("[ORDINE] Non attivo");g_state=FS_DONE;}}
    }
}

void OnDeinit(const int reason)
{
    CancelPendingOrder("deinit");
    IndicatorRelease(g_hEMA9);
    IndicatorRelease(g_hEMA21);
    if(g_hEMA200D1!=INVALID_HANDLE) IndicatorRelease(g_hEMA200D1);
    Print("ORB GOLD FIBONACCI EA v2.20 - Rimosso | reason=",reason);
}
