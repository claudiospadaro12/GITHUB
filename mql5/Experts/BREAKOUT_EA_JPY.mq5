//+------------------------------------------------------------------+
//|                                          BREAKOUT_EA_JPY.mq5      |
//|                     Breakout Strategy - Williams %R + SuperTrend |
//|                          Coppie YEN | Timeframe M15             |
//|                              v2.3                                |
//+------------------------------------------------------------------+
//  STRATEGIA (fedele al corso):
//  - Strumenti: Williams %R (140) + SuperTrend (ATR 10, mult 3.0), M15, cross JPY.
//  - Direzione: si opera SOLO con Williams in zona estrema.
//        Williams in IPERCOMPRATO (>= -20)  -> si cerca SOLO un SELL (rottura ribasso)
//        Williams in IPERVENDUTO  (<= -80)  -> si cerca SOLO un BUY  (rottura rialzo)
//  - Rettangolo congestione = le 20 candele che PRECEDONO la candela di segnale
//        (NON include la candela di segnale). Max = resistenza, Min = supporto.
//  - Segnale (candela index 1, ultima chiusa) richiede TUTTE e tre le condizioni:
//        1) chiusura OLTRE il canale (SELL: close < min ; BUY: close > max)
//        2) SuperTrend girato (SELL: rosso/negativo ; BUY: verde/positivo)
//        3) Williams uscito dall'estremo verso il centro
//           (SELL: -50 < W < -20 ; BUY: -80 < W < -50)
//  - Stop: SELL = 1 pip sopra il massimo ; BUY = 1 pip sotto il minimo.
//        La distanza di stop si misura dalla CHIUSURA della candela di segnale.
//  - Target: 3R fisso, calcolato dalla CHIUSURA della candela di segnale.
//        RR minimo per entrare = 2.0.
//  - Money management:
//        * rischio 1% per operazione (lotto calcolato di conseguenza)
//        * a +1R (misurato dalla candela di segnale) -> stop a BREAK-EVEN posto
//          ESATTAMENTE sulla CHIUSURA della candela di segnale (video 38: NON sul
//          prezzo di fill reale)
//        * NESSUN trailing stop: dopo il BE si tiene la posizione fino al 3R.
//+------------------------------------------------------------------+
#property copyright "Breakout Strategy EA - Claudio v2.3"
#property link      ""
#property version   "2.30"
#property description "Breakout: Williams %R (140) + SuperTrend | M15 | Coppie YEN | v2.3"

#include <Trade/Trade.mqh>

//=== INPUT INDICATORI ===
input int    WilliamsPeriod = 140;    // Williams %R - Periodo
input int    ATRPeriod      = 10;     // SuperTrend - ATR Period
input double ATRMultiplier  = 3.0;    // SuperTrend - Moltiplicatore
input int    RectBars       = 20;     // Candele rettangolo congestione

//=== INPUT RISK MANAGEMENT ===
input double RiskPercent    = 1.0;    // Rischio % per operazione
input double MinRR          = 2.0;    // R:R minimo per entrare

//=== INPUT EA ===
input int    MagicNumber    = 123456; // Magic Number
input string EAComment      = "BREAKOUT_EA"; // Commento ordine
input double MaxSpreadPips   = 3.0;   // Spread massimo (pips) per entrare
input bool   CloseOnOppositeSignal = true; // Chiusura anticipata su segnale/zona opposta (A/B test)
input bool   ShowRectangle  = true;   // Mostra rettangolo congestione
input bool   ShowLevels     = true;   // Mostra linee SL/TP/Signal

//=== ENUM ===
enum TRACKING_ZONE { ZONE_NONE, ZONE_OB, ZONE_OS };

//=== VARIABILI GLOBALI ===
CTrade        trade;
int           wprHandle      = INVALID_HANDLE;
datetime      lastBarTime    = 0;

TRACKING_ZONE trackZone      = ZONE_NONE;
bool          signalFired    = false;   // segnale attivo / posizione gestita
bool          breakEvenDone  = false;   // BE gia' applicato
bool          wasInPosition  = false;   // stato posizione tick precedente

// Livelli di riferimento dell'operazione, TUTTI ancorati alla candela di segnale.
double        sigClose       = 0.0;     // chiusura candela di segnale (livello di BE)
double        sigSL          = 0.0;     // stop loss teorico (1 pip oltre congestione)
double        sigTP          = 0.0;     // target 3R dalla chiusura del segnale
double        sigStopPips    = 0.0;     // distanza di stop in pips (dalla chiusura segnale)
double        rectHigh       = 0.0;     // resistenza congestione
double        rectLow        = 0.0;     // supporto congestione

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
    if(Period() != PERIOD_M15)
        Print("[BREAKOUT] ATTENZIONE: EA progettato per M15. TF: ", EnumToString(Period()));

    wprHandle = iWPR(Symbol(), PERIOD_M15, WilliamsPeriod);
    if(wprHandle == INVALID_HANDLE)
    {
        Print("[BREAKOUT] ERRORE handle Williams: ", GetLastError());
        return INIT_FAILED;
    }

    trade.SetExpertMagicNumber(MagicNumber);
    trade.SetDeviationInPoints(20);
    // Filling mode adattivo in base a cio' che il broker supporta.
    trade.SetTypeFilling(GetBrokerFilling());

    lastBarTime   = 0;
    trackZone     = ZONE_NONE;
    signalFired   = false;
    breakEvenDone = false;
    wasInPosition = false;

    Print("[BREAKOUT] v2.3 inizializzato | ", Symbol(), " | Risk:", RiskPercent,
          "% | Magic:", MagicNumber, " | CloseOnOpposite:", CloseOnOppositeSignal);
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnDeinit                                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    if(wprHandle != INVALID_HANDLE)
    {
        IndicatorRelease(wprHandle);
        wprHandle = INVALID_HANDLE;
    }
    DeleteAllObjects();
    Print("[BREAKOUT] EA rimosso. Motivo:", reason);
}

//+------------------------------------------------------------------+
//| OnTick                                                           |
//+------------------------------------------------------------------+
void OnTick()
{
    //=== GESTIONE POSIZIONE A OGNI TICK =============================
    // Il break-even va controllato ad ogni tick (non solo a nuova candela),
    // cosi' lo stop viene spostato a BE non appena il prezzo raggiunge +1R.
    if(SelectMyPosition())
        ManageBreakEven();

    //=== RILEVAMENTO SEGNALE / APERTURA SOLO A NUOVA CANDELA ========
    datetime barTime = iTime(Symbol(), PERIOD_M15, 0);
    if(barTime == lastBarTime) return;
    lastBarTime = barTime;

    if(iBars(Symbol(), PERIOD_M15) < WilliamsPeriod + RectBars + 20) return;

    //--- Williams su bar[1] (ultima candela chiusa) ---
    double wpr[];
    ArraySetAsSeries(wpr, true);
    if(CopyBuffer(wprHandle, 0, 0, 3, wpr) < 3)
    {
        Print("[BREAKOUT] Errore WPR: ", GetLastError());
        return;
    }
    double W = wpr[1];

    //--- SuperTrend su bar[1] ---
    double stDir = GetSuperTrendDir(1);

    //--- Rilevamento chiusura trade (TP/SL): reset segnale ---
    bool posNow = SelectMyPosition();
    if(wasInPosition && !posNow)
    {
        Print("[BREAKOUT] Trade chiuso (TP/SL). Reset segnale.");
        ResetSignal();
    }
    wasInPosition = posNow;

    //--- Aggiornamento TRACKING ZONE -------------------------------
    // trackZone si attiva entrando nell'area estrema (W >= -20 o W <= -80) e
    // RIMANE attiva anche dopo che W esce verso il centro, perche' il segnale
    // richiede che W sia GIA' uscito. Si azzera solo se W torna verso il neutro
    // oltre -50 (setup invalidato) o se raggiunge la zona opposta.
    if(W >= -20.0)
    {
        if(trackZone != ZONE_OB)
        {
            trackZone = ZONE_OB;
            ResetSignal();
            Print("[BREAKOUT] +IPERCOMPRATO | W=", W);
        }
    }
    else if(W <= -80.0)
    {
        if(trackZone != ZONE_OS)
        {
            trackZone = ZONE_OS;
            ResetSignal();
            Print("[BREAKOUT] +IPERVENDUTO | W=", W);
        }
    }
    else if(W <= -50.0 && trackZone == ZONE_OB)
    {
        // W troppo verso il neutro mentre tracciavamo un SELL -> setup annullato
        Print("[BREAKOUT] Setup OB annullato: W=", W, " sotto -50");
        trackZone = ZONE_NONE;
        ResetSignal();
        DeleteAllObjects();
        return;
    }
    else if(W >= -50.0 && trackZone == ZONE_OS)
    {
        // W troppo verso il neutro mentre tracciavamo un BUY -> setup annullato
        Print("[BREAKOUT] Setup OS annullato: W=", W, " sopra -50");
        trackZone = ZONE_NONE;
        ResetSignal();
        DeleteAllObjects();
        return;
    }

    if(trackZone == ZONE_NONE) { DeleteAllObjects(); return; }

    //--- Rettangolo congestione (20 candele PRECEDENTI il segnale) --
    if(!UpdateRectangle()) return;
    if(ShowRectangle) DrawRectangle();

    //--- Gestione trade aperto (chiusura anticipata facoltativa) ----
    if(posNow)
    {
        long posType = PositionGetInteger(POSITION_TYPE);

        // Le chiusure anticipate dipendono dal flag CloseOnOppositeSignal.
        // Il break-even invece NON dipende dal flag (gestito ad ogni tick sopra).
        if(CloseOnOppositeSignal)
        {
            // 1) Williams raggiunge la zona estrema OPPOSTA prima del target.
            if(posType == POSITION_TYPE_SELL && W <= -80.0)
            {
                Print("[BREAKOUT] Chiusura anticipata SELL (W in ipervenduto)");
                ClosePositionByTicket();
                ResetSignal();
                trackZone = ZONE_OS;
                wasInPosition = false;
                return;
            }
            if(posType == POSITION_TYPE_BUY && W >= -20.0)
            {
                Print("[BREAKOUT] Chiusura anticipata BUY (W in ipercomprato)");
                ClosePositionByTicket();
                ResetSignal();
                trackZone = ZONE_OB;
                wasInPosition = false;
                return;
            }

            // 2) Segnale operativo OPPOSTO completo.
            bool oppS = (posType == POSITION_TYPE_BUY)  && IsSellSignal(W, stDir);
            bool oppB = (posType == POSITION_TYPE_SELL) && IsBuySignal(W, stDir);
            if(oppS || oppB)
            {
                Print("[BREAKOUT] Segnale opposto rilevato. Chiusura posizione.");
                ClosePositionByTicket();
                ResetSignal();
                wasInPosition = false;
                posNow = false;
            }
            else
            {
                return; // posizione mantenuta fino a BE / TP / SL
            }
        }
        else
        {
            // Flag OFF: si lascia correre fino a SL o TP (nessuna chiusura anticipata).
            return;
        }
    }

    //--- Apertura trade --------------------------------------------
    if(!posNow && !signalFired)
    {
        // SELL setup: zona OB, Williams uscito (-50 < W < -20)
        if(trackZone == ZONE_OB && IsSellSignal(W, stDir))
            TryOpen(true, W);
        // BUY setup: zona OS, Williams uscito (-80 < W < -50)
        else if(trackZone == ZONE_OS && IsBuySignal(W, stDir))
            TryOpen(false, W);
    }
}

//+------------------------------------------------------------------+
//| Tentativo di apertura (isSell = true -> SELL, false -> BUY)      |
//+------------------------------------------------------------------+
void TryOpen(bool isSell, double W)
{
    double pip = GetPipSize();
    double cl1 = iClose(Symbol(), PERIOD_M15, 1);   // chiusura candela di segnale

    // SL: 1 pip oltre la congestione. Distanza misurata DALLA CHIUSURA del segnale.
    double sl, tp;
    if(isSell)
    {
        sl = NormalizeDouble(rectHigh + pip, _Digits);
        double stopDist = MathAbs(cl1 - sl);
        tp = NormalizeDouble(cl1 - stopDist * 3.0, _Digits);  // 3R dalla chiusura segnale
    }
    else
    {
        sl = NormalizeDouble(rectLow - pip, _Digits);
        double stopDist = MathAbs(cl1 - sl);
        tp = NormalizeDouble(cl1 + stopDist * 3.0, _Digits);  // 3R dalla chiusura segnale
    }

    double stopPips = MathAbs(cl1 - sl) / pip;
    if(stopPips <= 0)
    {
        Print("[BREAKOUT] StopPips non valido. Skip.");
        return;
    }

    // RR calcolato dal prezzo di mercato attuale (ingresso reale).
    double rr = CalcRR(isSell ? SYMBOL_BID : SYMBOL_ASK, sl, tp);

    Print("[BREAKOUT] ", (isSell ? "SELL?" : "BUY?"),
          " cl1:", cl1, " rH:", rectHigh, " rL:", rectLow,
          " SL:", sl, " TP:", tp, " StopPips:", DoubleToString(stopPips, 1),
          " RR:", DoubleToString(rr, 2), " W:", DoubleToString(W, 1));

    if(rr < MinRR)
    {
        Print("[BREAKOUT] RR insufficiente (", DoubleToString(rr, 2), " < ", MinRR, "). Skip.");
        return;
    }

    // Filtro spread.
    double spreadPips = CurrentSpreadPips();
    if(spreadPips > MaxSpreadPips)
    {
        Print("[BREAKOUT] Spread troppo alto (", DoubleToString(spreadPips, 1),
              " > ", MaxSpreadPips, "). Skip.");
        return;
    }

    double lots = CalculateLots(stopPips);
    if(lots <= 0)
    {
        Print("[BREAKOUT] Lotto non valido. Skip.");
        return;
    }

    bool sent = isSell ? trade.Sell(lots, Symbol(), 0, sl, tp, EAComment)
                       : trade.Buy (lots, Symbol(), 0, sl, tp, EAComment);

    uint rc = trade.ResultRetcode();
    if(sent && (rc == TRADE_RETCODE_DONE || rc == TRADE_RETCODE_PLACED))
    {
        // Ancoriamo tutti i livelli alla candela di segnale.
        sigClose    = cl1;
        sigSL       = sl;
        sigTP       = tp;
        sigStopPips = stopPips;
        signalFired = true;
        breakEvenDone = false;
        Print("[BREAKOUT] ", (isSell ? "SELL" : "BUY"), " APERTO | Lots:", lots,
              " | sigClose(BE):", sigClose);
        if(ShowLevels) DrawLevels();
    }
    else
    {
        Print("[BREAKOUT] Errore ordine: ", rc, " ", trade.ResultRetcodeDescription());
    }
}

//+------------------------------------------------------------------+
//| Segnale SELL: tutte e tre le condizioni sulla candela index 1   |
//+------------------------------------------------------------------+
bool IsSellSignal(double W, double stDir)
{
    double cl1 = iClose(Symbol(), PERIOD_M15, 1);
    return (cl1 < rectLow &&        // 1) chiusura sotto il supporto
            stDir < 0      &&        // 2) SuperTrend rosso/negativo
            W < -20.0      &&        // 3) Williams uscito dall'ipercomprato...
            W > -50.0);              //    ...ma ancora nella meta' alta (-50..-20)
}

//+------------------------------------------------------------------+
//| Segnale BUY: tutte e tre le condizioni sulla candela index 1    |
//+------------------------------------------------------------------+
bool IsBuySignal(double W, double stDir)
{
    double cl1 = iClose(Symbol(), PERIOD_M15, 1);
    return (cl1 > rectHigh &&       // 1) chiusura sopra la resistenza
            stDir > 0       &&       // 2) SuperTrend verde/positivo
            W > -80.0       &&       // 3) Williams uscito dall'ipervenduto...
            W < -50.0);             //    ...ma ancora nella meta' bassa (-80..-50)
}

//+------------------------------------------------------------------+
//| Rettangolo: 20 candele che PRECEDONO la candela di segnale.      |
//| La candela di segnale e' index 1, quindi le 20 precedenti        |
//| partono da shift=2 (bar 2 ... bar RectBars+1).                  |
//| Cosi' la candela di segnale NON e' inclusa e la rottura          |
//| (close oltre rectLow/rectHigh) e' matematicamente possibile.     |
//+------------------------------------------------------------------+
bool UpdateRectangle()
{
    double highs[], lows[];
    ArraySetAsSeries(highs, true);
    ArraySetAsSeries(lows,  true);
    // shift = 2 -> esclude la candela di segnale (index 1) e la corrente (index 0)
    if(CopyHigh(Symbol(), PERIOD_M15, 2, RectBars, highs) < RectBars) return false;
    if(CopyLow (Symbol(), PERIOD_M15, 2, RectBars, lows)  < RectBars) return false;
    rectHigh = highs[ArrayMaximum(highs, 0, RectBars)];
    rectLow  = lows [ArrayMinimum(lows,  0, RectBars)];
    return true;
}

//+------------------------------------------------------------------+
//| Break-even: a +1R (misurato dalla candela di segnale) sposta lo  |
//| stop ESATTAMENTE sulla CHIUSURA della candela di segnale.        |
//| FEDELTA' (video 38): il BE NON usa il prezzo di fill reale.      |
//| Nessun trailing: dopo il BE la posizione si tiene fino al 3R.    |
//+------------------------------------------------------------------+
void ManageBreakEven()
{
    if(breakEvenDone)  return;
    if(sigStopPips <= 0) return;   // niente livelli ancorati: nulla da fare

    long   pt    = PositionGetInteger(POSITION_TYPE);
    ulong  tkt   = PositionGetInteger(POSITION_TICKET);
    double curSL = PositionGetDouble(POSITION_SL);
    double curTP = PositionGetDouble(POSITION_TP);
    double bid   = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    double ask   = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double trig  = sigStopPips * GetPipSize();      // distanza +1R
    double nSL   = NormalizeDouble(sigClose, _Digits);  // BE = chiusura segnale

    if(pt == POSITION_TYPE_SELL && bid <= sigClose - trig)
    {
        if(curSL == 0 || nSL < curSL)   // solo se migliora (mai peggiora) lo stop
        {
            if(trade.PositionModify(tkt, nSL, curTP) &&
               trade.ResultRetcode() == TRADE_RETCODE_DONE)
            { breakEvenDone = true; Print("[BREAKOUT] BE SELL -> SL:", nSL); }
        }
    }
    else if(pt == POSITION_TYPE_BUY && ask >= sigClose + trig)
    {
        if(curSL == 0 || nSL > curSL)
        {
            if(trade.PositionModify(tkt, nSL, curTP) &&
               trade.ResultRetcode() == TRADE_RETCODE_DONE)
            { breakEvenDone = true; Print("[BREAKOUT] BE BUY -> SL:", nSL); }
        }
    }
}

//+------------------------------------------------------------------+
//| Selezione posizione filtrata per MAGIC + SIMBOLO.               |
//| Cicla su PositionsTotal e seleziona via ticket (anti-doppia).   |
//| Ritorna true se la posizione e' selezionata (PositionGet... ok). |
//+------------------------------------------------------------------+
bool SelectMyPosition()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong tkt = PositionGetTicket(i);
        if(tkt == 0) continue;
        if(PositionGetInteger(POSITION_MAGIC) == MagicNumber &&
           PositionGetString(POSITION_SYMBOL) == Symbol())
            return true;   // posizione selezionata da PositionGetTicket
    }
    return false;
}

//+------------------------------------------------------------------+
//| Chiusura della posizione corrente per TICKET.                   |
//+------------------------------------------------------------------+
void ClosePositionByTicket()
{
    if(!SelectMyPosition()) return;
    ulong tkt = PositionGetInteger(POSITION_TICKET);
    if(trade.PositionClose(tkt))
    {
        uint rc = trade.ResultRetcode();
        if(rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_PLACED)
            Print("[BREAKOUT] Errore chiusura: ", rc, " ", trade.ResultRetcodeDescription());
    }
    else
        Print("[BREAKOUT] Errore chiusura: ", trade.ResultRetcode(),
              " ", trade.ResultRetcodeDescription());
}

//+------------------------------------------------------------------+
//| RR dal prezzo di mercato corrente.                              |
//+------------------------------------------------------------------+
double CalcRR(ENUM_SYMBOL_INFO_DOUBLE priceType, double sl, double tp)
{
    double price = SymbolInfoDouble(Symbol(), priceType);
    double dSL   = MathAbs(price - sl);
    if(dSL <= 0) return 0;
    return MathAbs(price - tp) / dSL;
}

//+------------------------------------------------------------------+
//| SuperTrend (ricalcolo manuale) - direzione su targetBar         |
//| Ritorna +1 (verde/rialzista) o -1 (rosso/ribassista).           |
//+------------------------------------------------------------------+
double GetSuperTrendDir(int targetBar)
{
    int totalBars = iBars(Symbol(), PERIOD_M15);
    int lookback  = (int)MathMin(500, totalBars - 2);
    if(lookback < ATRPeriod + 30) return 0;

    double hi[], lo[], cl[];
    ArraySetAsSeries(hi, true);
    ArraySetAsSeries(lo, true);
    ArraySetAsSeries(cl, true);
    if(CopyHigh (Symbol(), PERIOD_M15, 0, lookback, hi) < lookback) return 0;
    if(CopyLow  (Symbol(), PERIOD_M15, 0, lookback, lo) < lookback) return 0;
    if(CopyClose(Symbol(), PERIOD_M15, 0, lookback, cl) < lookback) return 0;

    double atr[];
    ArrayResize(atr, lookback);
    ArraySetAsSeries(atr, true);
    ArrayInitialize(atr, 0);

    // ATR seed (media semplice del True Range) sulle barre piu' vecchie.
    int startIdx = lookback - 2;
    double sumTR = 0;
    int cnt = 0;
    for(int k = startIdx; k > startIdx - ATRPeriod && k >= 1; k--)
    {
        double tr = MathMax(hi[k]-lo[k],
                   MathMax(MathAbs(hi[k]-cl[k+1]), MathAbs(lo[k]-cl[k+1])));
        sumTR += tr; cnt++;
    }
    int atrS = startIdx - ATRPeriod + 1;
    if(atrS < 1) atrS = 1;
    if(cnt > 0) atr[atrS] = sumTR / cnt;
    for(int i = atrS - 1; i >= 1; i--)
    {
        double tr = MathMax(hi[i]-lo[i],
                   MathMax(MathAbs(hi[i]-cl[i+1]), MathAbs(lo[i]-cl[i+1])));
        atr[i] = (atr[i+1] * (ATRPeriod-1) + tr) / ATRPeriod;
    }

    double upB[], loB[], dir[];
    ArrayResize(upB, lookback); ArraySetAsSeries(upB, true); ArrayInitialize(upB, 0);
    ArrayResize(loB, lookback); ArraySetAsSeries(loB, true); ArrayInitialize(loB, 0);
    ArrayResize(dir, lookback); ArraySetAsSeries(dir, true); ArrayInitialize(dir, 0);

    int ss    = atrS;
    double h2 = (hi[ss]+lo[ss])/2.0;
    upB[ss]   = h2 + ATRMultiplier * atr[ss];
    loB[ss]   = h2 - ATRMultiplier * atr[ss];
    dir[ss]   = (cl[ss] > upB[ss]) ? 1.0 : -1.0;

    for(int i = ss - 1; i >= targetBar; i--)
    {
        h2 = (hi[i]+lo[i])/2.0;
        double bU = h2 + ATRMultiplier * atr[i];
        double bL = h2 - ATRMultiplier * atr[i];
        upB[i] = (bU < upB[i+1] || cl[i+1] > upB[i+1]) ? bU : upB[i+1];
        loB[i] = (bL > loB[i+1] || cl[i+1] < loB[i+1]) ? bL : loB[i+1];
        if(dir[i+1] < 0)
            dir[i] = (cl[i] > upB[i]) ? 1.0 : -1.0;
        else
            dir[i] = (cl[i] < loB[i]) ? -1.0 : 1.0;
    }
    return dir[targetBar];
}

//+------------------------------------------------------------------+
//| Calcolo lotto: rischio 1% del capitale sullo stop in pips.      |
//| Normalizzato sui decimali del VOLUME_STEP.                      |
//+------------------------------------------------------------------+
double CalculateLots(double stopPips)
{
    if(stopPips <= 0) return 0;
    double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
    double risk = bal * RiskPercent / 100.0;
    double tv   = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
    double ts   = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
    double ps   = GetPipSize();
    if(tv <= 0 || ts <= 0 || ps <= 0) return 0;

    double pv   = (ps / ts) * tv;   // valore di 1 pip per 1 lotto
    if(pv <= 0) return 0;

    double lots = risk / (stopPips * pv);
    double mn   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    double mx   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
    double st   = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);

    lots = MathFloor(lots / st) * st;
    lots = MathMax(mn, MathMin(mx, lots));

    int volDigits = VolumeDigits(st);
    lots = NormalizeDouble(lots, volDigits);

    Print("[BREAKOUT] Lots:", lots, " (Risk:", risk, " StopPip:",
          DoubleToString(stopPips, 1), " PipVal:", pv, ")");
    return lots;
}

//+------------------------------------------------------------------+
//| Numero di decimali del VOLUME_STEP.                             |
//+------------------------------------------------------------------+
int VolumeDigits(double step)
{
    if(step <= 0) return 2;
    int d = 0;
    double s = step;
    while(d < 8 && MathAbs(s - MathRound(s)) > 1e-9)
    {
        s *= 10.0;
        d++;
    }
    return d;
}

//+------------------------------------------------------------------+
//| Pip size (gestisce simboli a 3/5 decimali).                     |
//+------------------------------------------------------------------+
double GetPipSize()
{
    int d = (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    double p = SymbolInfoDouble(Symbol(), SYMBOL_POINT);
    return (d == 5 || d == 3) ? p * 10.0 : p;
}

//+------------------------------------------------------------------+
//| Spread corrente in pips.                                        |
//+------------------------------------------------------------------+
double CurrentSpreadPips()
{
    double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
    double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double pip = GetPipSize();
    if(pip <= 0) return 0;
    return (ask - bid) / pip;
}

//+------------------------------------------------------------------+
//| Filling mode adattivo in base a SYMBOL_FILLING_MODE.            |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING GetBrokerFilling()
{
    long modes = SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
    if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
    if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
    return ORDER_FILLING_RETURN;
}

//+------------------------------------------------------------------+
//| Reset stato segnale e cancellazione livelli grafici.            |
//+------------------------------------------------------------------+
void ResetSignal()
{
    signalFired   = false;
    breakEvenDone = false;
    sigClose = 0; sigSL = 0; sigTP = 0; sigStopPips = 0;
    ObjectDelete(0, "BREAK_SIG");
    ObjectDelete(0, "BREAK_SL");
    ObjectDelete(0, "BREAK_TP");
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Disegno rettangolo congestione allineato (bar 2 -> bar RectBars+1)|
//+------------------------------------------------------------------+
void DrawRectangle()
{
    string   n  = "BREAK_RECT";
    datetime t1 = iTime(Symbol(), PERIOD_M15, 2);            // candela piu' recente del rettangolo
    datetime t2 = iTime(Symbol(), PERIOD_M15, RectBars + 1); // candela piu' vecchia del rettangolo
    color c = (trackZone == ZONE_OB) ? clrRoyalBlue : clrForestGreen;
    if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_RECTANGLE, 0, t1, rectHigh, t2, rectLow);
    ObjectSetInteger(0, n, OBJPROP_TIME,  0, t1);
    ObjectSetDouble (0, n, OBJPROP_PRICE, 0, rectHigh);
    ObjectSetInteger(0, n, OBJPROP_TIME,  1, t2);
    ObjectSetDouble (0, n, OBJPROP_PRICE, 1, rectLow);
    ObjectSetInteger(0, n, OBJPROP_COLOR, c);
    ObjectSetInteger(0, n, OBJPROP_BACK,  true);
    ObjectSetInteger(0, n, OBJPROP_FILL,  true);
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Disegno livelli Signal / SL / TP.                               |
//+------------------------------------------------------------------+
void DrawLevels()
{
    DrawHLine("BREAK_SIG", sigClose, clrYellow, 2, "Signal:" + DoubleToString(sigClose, _Digits));
    DrawHLine("BREAK_SL",  sigSL,    clrRed,    2, "SL:"     + DoubleToString(sigSL,    _Digits));
    DrawHLine("BREAK_TP",  sigTP,    clrLime,   2, "TP:"     + DoubleToString(sigTP,    _Digits));
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Linea orizzontale helper.                                       |
//+------------------------------------------------------------------+
void DrawHLine(string n, double price, color c, int w, string lbl)
{
    if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_HLINE, 0, 0, price);
    ObjectSetDouble (0, n, OBJPROP_PRICE, price);
    ObjectSetInteger(0, n, OBJPROP_COLOR, c);
    ObjectSetInteger(0, n, OBJPROP_WIDTH, w);
    ObjectSetInteger(0, n, OBJPROP_STYLE, STYLE_DASH);
    ObjectSetString (0, n, OBJPROP_TEXT,  lbl);
}

//+------------------------------------------------------------------+
//| Cancellazione di tutti gli oggetti grafici dell'EA.             |
//+------------------------------------------------------------------+
void DeleteAllObjects()
{
    string ns[] = {"BREAK_RECT", "BREAK_SIG", "BREAK_SL", "BREAK_TP"};
    for(int i = 0; i < ArraySize(ns); i++)
        if(ObjectFind(0, ns[i]) >= 0) ObjectDelete(0, ns[i]);
    ChartRedraw();
}
//+------------------------------------------------------------------+
