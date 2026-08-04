//+------------------------------------------------------------------+
//|                      ORB_DAX_BASE_EA.mq5                         |
//| Fonte esclusiva: ABTG Toolkit ORB – Emiliano Monza               |
//| Webinar Operativo 02.03.2026                                     |
//|                                                                  |
//| LOGICA (dal documento):                                          |
//|  1. 09:00–09:30 CET: osservare, tracciare High/Low del range    |
//|  2. Filtro EMA9 e EMA21 su M5 (rialzista/ribassista/neutro)     |
//|  3. Trigger: candela M5 chiude oltre il range nella dir. filtro  |
//|  4. SL: oltre lato opposto del range + buffer                    |
//|  5. TP: R:R minimo 1:1.5, ideale 1:2                            |
//|  6. Max 1 trade per sessione                                     |
//|  7. Filtro NEUTRO (medie intrecciate) → nessuna operazione       |
//|                                                                  |
//| TIMEFRAME OBBLIGATORIO: M5                                       |
//|                                                                  |
//| OPZIONE B — FILTRO TREND D1:                                     |
//|   Prezzo D1 > EMA200 → solo LONG                                 |
//|   Prezzo D1 < EMA200 → solo SHORT                               |
//|   Zona neutra (entro banda %) → ENTRAMBI o NESSUNO              |
//| STRUMENTO: D30EUR / DAX                                          |
//+------------------------------------------------------------------+
#property copyright "ABTG ORB Base – Emiliano Monza"
#property version   "2.00"
#property description "ORB DAX Base v2.0 LIVE: Body=0.65 RR=2.5 Risk=3%"

#include <Trade\Trade.mqh>

//===================================================================
// INPUT PARAMETERS
//===================================================================
input group "=== STRUMENTO ==="
input string InpSymbol         = "";       // Simbolo (vuoto = corrente)

input group "=== ORARIO OR (CET) ==="
input int    InpORStartHour    = 9;        // Ora inizio OR (CET)
input int    InpORStartMin     = 0;        // Minuto inizio OR
input int    InpOREndHour      = 9;        // Ora fine OR (CET)
input int    InpOREndMin       = 30;       // Minuto fine OR
input int    InpBrokerCETOffset = 0;       // Offset broker vs CET (es: -1 se broker UTC+3, CET UTC+2)

input group "=== EMA FILTER (dal documento ABTG) ==="
input int    InpEMA_Fast       = 9;        // EMA veloce (documento: EMA9)
input int    InpEMA_Slow       = 21;       // EMA lenta (documento: EMA21)

input group "=== CANDELA DI BREAKOUT ==="
input double InpMinBodyRatio   = 0.65;      // Corpo min / range candela (filtro candela forte)

input group "=== MONEY MANAGEMENT ==="
input double InpRiskPct        = 3.0;      // Rischio % per trade (demo: 3%)
input double InpRRRatio        = 2.5;      // R:R ratio (ottimizzato: 2.5 > Sharpe 3.54)
input double InpSLBuffer       = 5.0;      // Buffer SL in punti oltre il range opposto
input bool   InpUseEMA21Trail  = false;    // Trailing su EMA21 dopo TP1 (alternativa a TP fisso)
input double InpLotSize        = 0.1;      // Lotto fisso (usato se RiskPct = 0)

input group "=== FILTRI ==="
input int    InpMaxSpread      = 30;       // Spread max punti (0 = disabilitato)
input int    InpMagicNumber    = 20260302; // Magic Number

input group "=== FILTRO AMPIEZZA OR (documento ABTG) ==="
// "OR variabile: range troppo ampi riducono il R:R;
//  range stretti possono mancare di slancio." (ABTG pag.17)
// NOTA: valori in punti DAX reali (es. 30 = 30 pt DAX, non SYMBOL_POINT)
input double InpOR_MinPoints   = 0.0;     // OR minimo in punti DAX (sotto → no trade)
input double InpOR_MaxPoints   = 9999.0;    // OR massimo in punti DAX (sopra → no trade)

input group "=== FILTRO TREND D1 — EMA200 (Opzione B) ==="
// Allinea la direzione del trade al trend di fondo giornaliero.
// Prezzo D1 > EMA200 D1 → solo LONG | Prezzo D1 < EMA200 → solo SHORT
// La banda neutra evita ingressi in mercati laterali sulla EMA200.
input bool   InpD1_FilterEnabled = false;   // Abilita filtro trend D1
input int    InpD1_EMAPeriod     = 200;    // EMA D1 (standard: 200)
input double InpD1_NeutralBand   = 0.3;    // Banda neutra % sopra/sotto EMA200
//   Es: 0.3% su DAX 24000 = 72 punti di banda → zona neutra ±72 pt dalla EMA200
//   Dentro la banda: InpD1_NeutralAction determina il comportamento
input int    InpD1_NeutralAction = 0;      // 0=entrambe le dir | 1=solo LONG | -1=solo SHORT | 99=skip

//===================================================================
// GLOBAL VARIABLES
//===================================================================
CTrade   g_trade;
string   g_sym       = "";
datetime g_lastBarM5 = 0;
int      g_barCount  = 0;

// Handle EMA M5
int g_hEMA9  = INVALID_HANDLE;
int g_hEMA21 = INVALID_HANDLE;

// Handle EMA D1 (filtro trend)
int g_hEMA200_D1 = INVALID_HANDLE;

// Stato giornaliero
enum DayState { DS_WAITING, DS_FORMING, DS_READY, DS_TRADED, DS_DONE };
DayState g_state    = DS_WAITING;
datetime g_lastDay  = 0;

double   g_orHigh   = 0;  // Massimo range 09:00-09:30 (incluse wick)
double   g_orLow    = 0;  // Minimo range 09:00-09:30 (incluse wick)
bool     g_orValid  = false;

// Nomi GlobalVariable per persistenza range OR (sopravvive al riavvio EA)
string GV_OR_HIGH  = "ORB_DAX_OR_HIGH";
string GV_OR_LOW   = "ORB_DAX_OR_LOW";
string GV_OR_VALID = "ORB_DAX_OR_VALID";
string GV_OR_DAY   = "ORB_DAX_OR_DAY";

//===================================================================
// UTILITY: converte orario broker in orario CET
//===================================================================
datetime BrokerToCET(datetime brokerTime)
{
    return brokerTime + (datetime)(InpBrokerCETOffset * 3600);
}

bool IsInORWindow(datetime brokerTime)
{
    datetime cet = BrokerToCET(brokerTime);
    MqlDateTime dt; TimeToStruct(cet, dt);
    int mins = dt.hour * 60 + dt.min;
    int start = InpORStartHour * 60 + InpORStartMin;
    int end_  = InpOREndHour   * 60 + InpOREndMin;
    return (mins >= start && mins < end_);
}

bool IsAfterOR(datetime brokerTime)
{
    datetime cet = BrokerToCET(brokerTime);
    MqlDateTime dt; TimeToStruct(cet, dt);
    int mins = dt.hour * 60 + dt.min;
    int end_ = InpOREndHour * 60 + InpOREndMin;
    return (mins >= end_);
}

//===================================================================
// UTILITY: nuovo giorno di trading
//===================================================================
bool IsNewTradingDay(datetime brokerTime)
{
    datetime cet = BrokerToCET(brokerTime);
    MqlDateTime dt; TimeToStruct(cet, dt);
    // Nuovo giorno se data CET cambiata
    MqlDateTime dtLast; TimeToStruct(BrokerToCET(g_lastDay), dtLast);
    return (dt.year != dtLast.year || dt.mon != dtLast.mon || dt.day != dtLast.day);
}

//===================================================================
// LEGGI EMA da handle (unica chiamata per barra)
//===================================================================
double GetEMA(int handle)
{
    if(handle == INVALID_HANDLE) return 0;
    double buf[];
    ArraySetAsSeries(buf, true);
    if(CopyBuffer(handle, 0, 0, 1, buf) <= 0) return 0;
    return buf[0];
}

//===================================================================
// FILTRO EMA (documento ABTG):
// RIALZISTA: EMA9 > EMA21 AND prezzo > entrambe le medie → +1
// RIBASSISTA: EMA9 < EMA21 AND prezzo < entrambe le medie → -1
// NEUTRO: medie intrecciate o prezzo in mezzo → 0 (no trade)
//===================================================================
int GetEMAFilter()
{
    double ema9  = GetEMA(g_hEMA9);
    double ema21 = GetEMA(g_hEMA21);
    if(ema9 <= 0 || ema21 <= 0) return 0;

    double close[];
    ArraySetAsSeries(close, true);
    if(CopyClose(g_sym, PERIOD_M5, 0, 1, close) <= 0) return 0;
    double price = close[0];

    bool bullish = (ema9 > ema21 && price > ema9 && price > ema21);
    bool bearish = (ema9 < ema21 && price < ema9 && price < ema21);

    if(bullish)
    {
        Print(StringFormat("[EMA] RIALZISTA | EMA9=%.1f EMA21=%.1f Price=%.1f", ema9, ema21, price));
        return 1;
    }
    if(bearish)
    {
        Print(StringFormat("[EMA] RIBASSISTA | EMA9=%.1f EMA21=%.1f Price=%.1f", ema9, ema21, price));
        return -1;
    }
    Print(StringFormat("[EMA] NEUTRO – nessuna operazione | EMA9=%.1f EMA21=%.1f Price=%.1f", ema9, ema21, price));
    return 0;
}

//===================================================================
// FILTRO TREND D1 — OPZIONE B
// Ritorna:  1 = solo LONG ammesso
//          -1 = solo SHORT ammesso
//           0 = nessuna restrizione (entrambe le direzioni o skip)
//          99 = skip giornata (se InpD1_NeutralAction=99)
//
// Logica:
//   Prezzo chiusura D1 vs EMA200 D1
//   Se prezzo > EMA200 + banda% → trend RIALZISTA → ammette solo LONG
//   Se prezzo < EMA200 - banda% → trend RIBASSISTA → ammette solo SHORT
//   Se prezzo nella banda → NEUTRO → segue InpD1_NeutralAction
//===================================================================
int GetD1TrendBias()
{
    if(!InpD1_FilterEnabled) return 0; // Filtro disabilitato → nessuna restrizione

    if(g_hEMA200_D1 == INVALID_HANDLE)
    {
        Print("[D1] Handle EMA200 non disponibile → nessuna restrizione");
        return 0;
    }

    // EMA200 D1
    double ema200[];
    ArraySetAsSeries(ema200, true);
    if(CopyBuffer(g_hEMA200_D1, 0, 0, 1, ema200) <= 0)
    {
        Print("[D1] EMA200 non leggibile → nessuna restrizione");
        return 0;
    }
    double ema = ema200[0];
    if(ema <= 0) return 0;

    // Prezzo chiusura D1 (barra 1 = ultima chiusa, non quella in formazione)
    double closeD1[];
    ArraySetAsSeries(closeD1, true);
    if(CopyClose(g_sym, PERIOD_D1, 1, 1, closeD1) <= 0) return 0;
    double price = closeD1[0];

    // Banda neutra in valore assoluto
    double band = ema * InpD1_NeutralBand / 100.0;
    double upperBand = ema + band;
    double lowerBand = ema - band;

    if(price > upperBand)
    {
        Print(StringFormat("[D1] RIALZISTA | Close=%.1f > EMA200=%.1f + banda=%.1f → solo LONG",
                           price, ema, band));
        return 1;  // Solo LONG
    }
    if(price < lowerBand)
    {
        Print(StringFormat("[D1] RIBASSISTA | Close=%.1f < EMA200=%.1f - banda=%.1f → solo SHORT",
                           price, ema, band));
        return -1; // Solo SHORT
    }

    // Zona neutra
    Print(StringFormat("[D1] NEUTRO | Close=%.1f nella banda EMA200=%.1f ±%.1f → azione=%d",
                       price, ema, band, InpD1_NeutralAction));
    return (InpD1_NeutralAction == 99) ? 99 : InpD1_NeutralAction;
}

//===================================================================
// AGGIORNA OR: massimo e minimo della finestra 09:00-09:30
// Include le wick (High/Low), non solo i corpi (documento pag. 5-6)
//===================================================================
void UpdateOR(datetime barTime)
{
    double high[], low[];
    ArraySetAsSeries(high, true);
    ArraySetAsSeries(low,  true);
    if(CopyHigh(g_sym, PERIOD_M5, 0, 1, high) <= 0) return;
    if(CopyLow (g_sym, PERIOD_M5, 0, 1, low)  <= 0) return;

    if(!g_orValid)
    {
        g_orHigh  = high[0];
        g_orLow   = low[0];
        g_orValid = true;
    }
    else
    {
        if(high[0] > g_orHigh) g_orHigh = high[0];
        if(low[0]  < g_orLow)  g_orLow  = low[0];
    }

    // Salva range OR in GlobalVariable → sopravvive al riavvio EA
    GlobalVariableSet(GV_OR_HIGH,  g_orHigh);
    GlobalVariableSet(GV_OR_LOW,   g_orLow);
    GlobalVariableSet(GV_OR_VALID, 1.0);
    GlobalVariableSet(GV_OR_DAY,   (double)g_lastDay);
}

//===================================================================
// CONTROLLA BREAKOUT (documento pag. 8):
// La candela M5 DEVE CHIUDERE oltre il range (non solo toccare)
// Il corpo deve essere ampio (filtro candela forte)
// La direzione deve essere coerente con il filtro EMA
// Ritorna: 1=BUY, -1=SELL, 0=nessun segnale
//===================================================================
int CheckBreakout(int emaFilter)
{
    if(!g_orValid || g_orHigh <= g_orLow) return 0;
    if(emaFilter == 0) return 0; // NEUTRO → nessuna operazione

    // Leggi candela chiusa (shift=1 = barra precedente completata)
    double open[], high[], low[], close[];
    ArraySetAsSeries(open,  true);
    ArraySetAsSeries(high,  true);
    ArraySetAsSeries(low,   true);
    ArraySetAsSeries(close, true);

    if(CopyOpen (g_sym, PERIOD_M5, 1, 1, open)  <= 0) return 0;
    if(CopyHigh (g_sym, PERIOD_M5, 1, 1, high)  <= 0) return 0;
    if(CopyLow  (g_sym, PERIOD_M5, 1, 1, low)   <= 0) return 0;
    if(CopyClose(g_sym, PERIOD_M5, 1, 1, close) <= 0) return 0;

    double candleRange = high[0] - low[0];
    if(candleRange <= 0) return 0;

    double body     = MathAbs(close[0] - open[0]);
    double bodyRatio = body / candleRange;

    // Filtro corpo ampio (documento: "corpo di candela ampio e ombre contenute")
    if(bodyRatio < InpMinBodyRatio)
    {
        Print(StringFormat("[BREAKOUT] Candela rifiutata: corpo troppo piccolo (%.0f%%)", bodyRatio*100));
        return 0;
    }

    // LONG: chiusura sopra massimo range + filtro rialzista + candela bullish
    if(emaFilter == 1 && close[0] > g_orHigh && close[0] > open[0])
    {
        Print(StringFormat("[BREAKOUT] LONG confermato | Close=%.1f > OR High=%.1f | Corpo=%.0f%%",
                           close[0], g_orHigh, bodyRatio*100));
        return 1;
    }

    // SHORT: chiusura sotto minimo range + filtro ribassista + candela bearish
    if(emaFilter == -1 && close[0] < g_orLow && close[0] < open[0])
    {
        Print(StringFormat("[BREAKOUT] SHORT confermato | Close=%.1f < OR Low=%.1f | Corpo=%.0f%%",
                           close[0], g_orLow, bodyRatio*100));
        return -1;
    }

    return 0;
}

//===================================================================
// CALCOLO LOTTO
//===================================================================
double NormLot(double lots)
{
    double mn = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MIN);
    double mx = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_MAX);
    double st = SymbolInfoDouble(g_sym, SYMBOL_VOLUME_STEP);
    if(st <= 0) st = 0.01;
    return MathMax(mn, MathMin(mx, MathFloor(lots/st)*st));
}

//===================================================================
// NORMALIZZA PREZZO AL TICK SIZE — Fix "invalid stops"
// D30EUR BCM Markets usa tick size 0.5 punti. SL/TP devono essere
// multipli esatti del tick size altrimenti MT5 rifiuta con
// "Invalid stops". NormPrice() risolve il problema.
//===================================================================
double NormPrice(double price)
{
    double ts  = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
    int    dg  = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
    if(ts <= 0) ts = SymbolInfoDouble(g_sym, SYMBOL_POINT);
    return NormalizeDouble(MathRound(price / ts) * ts, dg);
}


double CalcLots(double slDist)
{
    if(InpRiskPct <= 0 || slDist <= 0) return NormLot(InpLotSize);
    double tv = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_VALUE);
    double ts = SymbolInfoDouble(g_sym, SYMBOL_TRADE_TICK_SIZE);
    if(ts <= 0 || tv <= 0) return NormLot(InpLotSize);
    double lots = (AccountInfoDouble(ACCOUNT_BALANCE) * InpRiskPct/100.0) / ((slDist/ts)*tv);
    return NormLot(lots);
}

//===================================================================
// POSIZIONE APERTA
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

//===================================================================
// EMA21 TRAILING (documento pag. 10):
// "Usate la EMA21 come trailing stop naturale. Quando il prezzo
// chiude una candela dall'altra parte della EMA21 → chiudete."
//===================================================================
void ManageTrailing()
{
    if(!InpUseEMA21Trail) return;

    for(int i = 0; i < PositionsTotal(); i++)
    {
        ulong ticket = PositionGetTicket(i);
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL)  != g_sym)     continue;
        if(PositionGetInteger(POSITION_MAGIC)  != InpMagicNumber) continue;

        ENUM_POSITION_TYPE ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double ema21 = GetEMA(g_hEMA21);
        if(ema21 <= 0) continue;

        double close[];
        ArraySetAsSeries(close, true);
        if(CopyClose(g_sym, PERIOD_M5, 1, 1, close) <= 0) continue;

        // Chiusura candela dall'altra parte della EMA21
        if(ptype == POSITION_TYPE_BUY && close[0] < ema21)
        {
            Print("[TRAIL] Long: candela chiude sotto EMA21 → chiudo posizione");
            g_trade.PositionClose(ticket);
        }
        else if(ptype == POSITION_TYPE_SELL && close[0] > ema21)
        {
            Print("[TRAIL] Short: candela chiude sopra EMA21 → chiudo posizione");
            g_trade.PositionClose(ticket);
        }
    }
}

//===================================================================
// OnInit
//===================================================================
int OnInit()
{
    g_sym = (InpSymbol == "") ? _Symbol : InpSymbol;

    g_trade.SetExpertMagicNumber(InpMagicNumber);
    g_trade.SetDeviationInPoints(30);
    g_trade.SetTypeFilling(ORDER_FILLING_IOC);
    g_trade.LogLevel(LOG_LEVEL_ERRORS);

    g_hEMA9  = iMA(g_sym, PERIOD_M5, InpEMA_Fast, 0, MODE_EMA, PRICE_CLOSE);
    g_hEMA21 = iMA(g_sym, PERIOD_M5, InpEMA_Slow, 0, MODE_EMA, PRICE_CLOSE);

    // Handle EMA200 D1 per filtro trend (Opzione B)
    if(InpD1_FilterEnabled)
    {
        g_hEMA200_D1 = iMA(g_sym, PERIOD_D1, InpD1_EMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
        if(g_hEMA200_D1 == INVALID_HANDLE)
            Print("[INIT] Attenzione: EMA200 D1 non creata — filtro trend disabilitato");
    }

    if(g_hEMA9 == INVALID_HANDLE || g_hEMA21 == INVALID_HANDLE)
    {
        Print("[INIT] ERRORE: impossibile creare handle EMA M5!");
        return INIT_FAILED;
    }

    g_state   = DS_WAITING;
    g_lastDay = 0;

    // ── RIPRISTINO RANGE OR DA GLOBALVARIABLE ────────────────────
    // Se l'EA si riavvia (reason=5 chart change, reconnect feed dati)
    // recupera il range OR già formato per non perdere il trade.
    datetime nowCET = BrokerToCET(TimeCurrent());
    MqlDateTime dtNow; TimeToStruct(nowCET, dtNow);
    bool afterOR = (dtNow.hour * 60 + dtNow.min) >= (InpOREndHour * 60 + InpOREndMin);

    if(afterOR &&
       GlobalVariableCheck(GV_OR_HIGH)  &&
       GlobalVariableCheck(GV_OR_LOW)   &&
       GlobalVariableCheck(GV_OR_VALID) &&
       GlobalVariableCheck(GV_OR_DAY))
    {
        datetime savedDay = (datetime)GlobalVariableGet(GV_OR_DAY);
        MqlDateTime dtSaved; TimeToStruct(BrokerToCET(savedDay), dtSaved);

        // Usa il range salvato solo se è dello stesso giorno
        if(dtSaved.year == dtNow.year && dtSaved.mon == dtNow.mon && dtSaved.day == dtNow.day)
        {
            g_orHigh  = GlobalVariableGet(GV_OR_HIGH);
            g_orLow   = GlobalVariableGet(GV_OR_LOW);
            g_orValid = (GlobalVariableGet(GV_OR_VALID) == 1.0);
            g_lastDay = savedDay;
            g_state   = DS_READY;
            Print(StringFormat("[INIT] Range OR ripristinato da GlobalVar | High=%.1f Low=%.1f",
                               g_orHigh, g_orLow));
        }
        else
        {
            Print("[INIT] GlobalVar OR di giorno diverso → ignorate");
        }
    }

    Print("════════════════════════════════════════");
    Print("  ORB DAX BASE EA v2.00");
    Print("  Fonte: ABTG Toolkit ORB – E.Monza");
    Print("  Simbolo  : ", g_sym);
    Print("  OR       : ", InpORStartHour, ":", InpORStartMin,
          " → ", InpOREndHour, ":", InpOREndMin, " CET");
    Print("  EMA      : ", InpEMA_Fast, " / ", InpEMA_Slow);
    Print("  R:R      : 1:", InpRRRatio);
    Print("  Rischio  : ", InpRiskPct, "%");
    Print("  Trailing : ", InpUseEMA21Trail ? "EMA21" : "TP fisso");
    Print("════════════════════════════════════════");

    return INIT_SUCCEEDED;
}

//===================================================================
// OnTick — LOGICA PRINCIPALE
//===================================================================
void OnTick()
{
    // Nuova barra M5
    int barsNow = Bars(g_sym, PERIOD_M5);
    if(barsNow <= 0 || barsNow == (int)g_lastBarM5) return;
    g_lastBarM5 = (datetime)barsNow;

    datetime brokerNow = TimeCurrent();

    // ── RESET GIORNALIERO ────────────────────────────────────────
    if(g_lastDay == 0 || IsNewTradingDay(brokerNow))
    {
        g_lastDay  = brokerNow;
        g_state    = DS_WAITING;
        g_orHigh   = 0;
        g_orLow    = 0;
        g_orValid  = false;
        // Pulisci GlobalVariable del giorno precedente
        GlobalVariableDel(GV_OR_HIGH);
        GlobalVariableDel(GV_OR_LOW);
        GlobalVariableDel(GV_OR_VALID);
        GlobalVariableDel(GV_OR_DAY);
        Print(StringFormat("[DAY] Nuovo giorno → reset stato | %s",
                           TimeToString(BrokerToCET(brokerNow), TIME_DATE)));
    }

    // ── TRAILING (se attivo) ──────────────────────────────────────
    if(g_state == DS_TRADED && InpUseEMA21Trail)
    {
        ManageTrailing();
        return;
    }

    if(g_state == DS_DONE || g_state == DS_TRADED) return;

    // ── SPREAD ───────────────────────────────────────────────────
    if(InpMaxSpread > 0 && !MQLInfoInteger(MQL_TESTER))
    {
        if(SymbolInfoInteger(g_sym, SYMBOL_SPREAD) > InpMaxSpread) return;
    }

    // ── FASE 2: FORMAZIONE OR (09:00–09:30) ─────────────────────
    if(IsInORWindow(brokerNow))
    {
        if(g_state == DS_WAITING) g_state = DS_FORMING;
        UpdateOR(brokerNow);
        return;
    }

    // ── FASE 3 in poi: DOPO LE 09:30 ─────────────────────────────
    if(!IsAfterOR(brokerNow)) return;

    // Range non valido → skip
    if(!g_orValid || g_orHigh <= g_orLow)
    {
        Print("[OR] Range non valido → nessuna operazione oggi");
        g_state = DS_DONE;
        return;
    }

    // Range OR formato → ora in attesa del segnale
    if(g_state == DS_FORMING)
    {
        // FIX v1.21: usa differenza prezzo diretta (NON dividere per SYMBOL_POINT).
        // D30EUR BCM Markets ha SYMBOL_POINT=0.01 → dividere gonfiava il valore x100
        // causando "Range TROPPO AMPIO: 10500 pt" per un OR normale di 105 punti DAX.
        // Ora: orWidth = differenza prezzo in punti DAX (es. 50.0 = 50 punti DAX)
        double orWidth = g_orHigh - g_orLow;

        // ── FILTRO AMPIEZZA OR (ABTG pag.17) ─────────────────────────
        // "Range troppo ampi riducono il R:R;
        //  range stretti possono mancare di slancio."
        if(orWidth < InpOR_MinPoints)
        {
            Print(StringFormat("[OR] Range TROPPO STRETTO: %.1f pt (min=%d) → skip giornata",
                               orWidth, InpOR_MinPoints));
            g_state = DS_DONE;
            return;
        }
        if(orWidth > InpOR_MaxPoints)
        {
            Print(StringFormat("[OR] Range TROPPO AMPIO: %.1f pt (max=%d) → skip giornata",
                               orWidth, InpOR_MaxPoints));
            g_state = DS_DONE;
            return;
        }

        g_state = DS_READY;
        Print(StringFormat("[OR] Range OK | High=%.1f Low=%.1f Ampiezza=%.1f pt (filtro %d-%d pt)",
                           g_orHigh, g_orLow, orWidth, InpOR_MinPoints, InpOR_MaxPoints));
    }

    if(g_state != DS_READY) return;
    if(HasPosition()) { g_state = DS_TRADED; return; }

    // ── FASE 3: FILTRO EMA ────────────────────────────────────────
    int emaFilter = GetEMAFilter();
    if(emaFilter == 0)
    {
        Print("[EMA] Filtro NEUTRO → nessuna operazione");
        return; // Non blocca per sempre: può cambiare barra dopo barra
    }

    // ── FILTRO TREND D1 (OPZIONE B) ──────────────────────────────
    int d1Bias = GetD1TrendBias();

    // d1Bias=99 → zona neutra con azione=skip → no trade
    if(d1Bias == 99) { Print("[D1] Skip per zona neutra"); g_state = DS_DONE; return; }

    // Se D1 impone una direzione contraria all'EMA M5 → skip
    if(d1Bias != 0 && emaFilter != 0 && emaFilter != d1Bias)
    {
        Print(StringFormat("[D1] EMA M5 dir=%+d vs D1 trend=%+d → skip (direzioni opposte)",
                           emaFilter, d1Bias));
        return;
    }

    // Direzione effettiva: EMA M5 ha priorità, D1 come rinforzo
    int effectiveFilter = (emaFilter != 0) ? emaFilter :
                          (d1Bias   != 0) ? d1Bias    : 0;
    if(effectiveFilter == 0) { Print("[D1+EMA] Direzione non definita → skip"); return; }

    // ── FASE 4: SEGNALE DI BREAKOUT ──────────────────────────────
    int signal = CheckBreakout(effectiveFilter);
    if(signal == 0) return;

    // ── FASE 5: CALCOLO SL, TP, LOTTI ────────────────────────────
    double ask    = SymbolInfoDouble(g_sym, SYMBOL_ASK);
    double bid    = SymbolInfoDouble(g_sym, SYMBOL_BID);
    int    digits = (int)SymbolInfoInteger(g_sym, SYMBOL_DIGITS);
    double point  = SymbolInfoDouble(g_sym, SYMBOL_POINT);
    double buffer = InpSLBuffer * point;

    double price, sl, tp, slDist, lots;

    if(signal == 1) // LONG
    {
        price  = ask;
        sl     = NormPrice(g_orLow - buffer);
        slDist = price - sl;
        tp     = InpUseEMA21Trail ? 0 :
                 NormPrice(price + slDist * InpRRRatio);
        lots   = CalcLots(slDist);

        Print(StringFormat("[EXEC] LONG | Ask=%.1f SL=%.1f TP=%.1f Lot=%.2f R:R=1:%.1f",
                           price, sl, tp, lots, InpRRRatio));
        if(g_trade.Buy(lots, g_sym, price, sl, tp, "ORB BASE LONG"))
        {
            Print("[EXEC] BUY aperto #", g_trade.ResultOrder());
            g_state = DS_TRADED;
        }
        else
            Print("[EXEC] Errore BUY: ", g_trade.ResultRetcodeDescription());
    }
    else if(signal == -1) // SHORT
    {
        price  = bid;
        sl     = NormPrice(g_orHigh + buffer);
        slDist = sl - price;
        tp     = InpUseEMA21Trail ? 0 :
                 NormPrice(price - slDist * InpRRRatio);
        lots   = CalcLots(slDist);

        Print(StringFormat("[EXEC] SHORT | Bid=%.1f SL=%.1f TP=%.1f Lot=%.2f R:R=1:%.1f",
                           price, sl, tp, lots, InpRRRatio));
        if(g_trade.Sell(lots, g_sym, price, sl, tp, "ORB BASE SHORT"))
        {
            Print("[EXEC] SELL aperto #", g_trade.ResultOrder());
            g_state = DS_TRADED;
        }
        else
            Print("[EXEC] Errore SELL: ", g_trade.ResultRetcodeDescription());
    }
}

//===================================================================
// OnDeinit
//===================================================================
void OnDeinit(const int reason)
{
    IndicatorRelease(g_hEMA9);
    IndicatorRelease(g_hEMA21);
    if(g_hEMA200_D1 != INVALID_HANDLE) IndicatorRelease(g_hEMA200_D1);
    Print("ORB DAX BASE EA – Rimosso | reason=", reason);
}
//+------------------------------------------------------------------+
