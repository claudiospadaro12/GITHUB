//+------------------------------------------------------------------+
//|                                    BREAKOUT_EA_JPY_Multi.mq5      |
//|                     Breakout Strategy - Williams %R + SuperTrend |
//|                    Coppie YEN | Timeframe M15 | MULTI-SIMBOLO    |
//|                              v2.4                                |
//+------------------------------------------------------------------+
//  STRATEGIA (fedele al corso, IDENTICA alla v2.3 ma replicata per ogni
//  simbolo del paniere):
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
//  - Una sola posizione PER SIMBOLO per volta.
//
//  MULTI-SIMBOLO (v2.4):
//  - L'EA resta ATTACCATO A UN SOLO GRAFICO ma opera su un paniere di cross JPY.
//  - In OnTick processa TUTTI i simboli del paniere ad ogni tick (in backtest
//    multi-simbolo "Ogni tick basato su tick reali" MT5 fornisce i dati per ogni
//    simbolo richiesto via iTime/CopyBuffer/CopyHigh/...).
//  - Lo stato dell'operazione/segnale e' mantenuto PER SIMBOLO in una struct
//    (SymState) dentro l'array states[], parallelo all'array symbols[].
//  - Magic distinto per simbolo (MagicNumber + indice) per robustezza: cosi'
//    l'eventuale identificazione delle posizioni e' univoca. Il filtro di
//    selezione e' comunque magic+simbolo.
//  - Gli oggetti grafici vengono disegnati SOLO per il simbolo del grafico
//    corrente (sym == Symbol()); per gli altri simboli il disegno e' saltato.
//+------------------------------------------------------------------+
#property copyright "Breakout Strategy EA - Claudio v2.4 multi-simbolo"
#property link      ""
#property version   "2.40"
#property description "Breakout MULTI-SIMBOLO: Williams %R (140) + SuperTrend | M15 | Paniere YEN | v2.4"

#include <Trade/Trade.mqh>
#include <ABTG_PausaGuardian.mqh>
//--- GUARDIAN DEL CONTO -- firme B1 (pausa morbida giornaliera) e C1
//    (cap sul rischio aperto simultaneo) del 18/08/2026.
//    Verbale: report/FIRME_2026-08-18.md
//    true  = prima di APRIRE chiede il via libera al guardiano del conto.
//    false = comportamento identico a prima della migrazione.
//    ATTENZIONE, il default true NON cambia niente da solo: se il
//    Guardian non gira su questo conto -- e nel Strategy Tester, dove le
//    sue GlobalVariable non esistono -- la guardia lascia passare tutto
//    (fail-open totale). I backtest restano confrontabili con i vecchi.
//    Non tocca MAI le posizioni gia' aperte, i parziali, i trailing e le
//    uscite: blocca soltanto l'APERTURA di nuovo rischio.
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)

//=== INPUT MULTI-SIMBOLO ===
input string InpSymbols = "USDJPY,EURJPY,GBPJPY,CHFJPY,CADJPY,NZDJPY,AUDJPY"; // Paniere simboli (virgola)

//=== INPUT INDICATORI ===
input int    WilliamsPeriod = 140;    // Williams %R - Periodo
input int    ATRPeriod      = 10;     // SuperTrend - ATR Period
input double ATRMultiplier  = 3.0;    // SuperTrend - Moltiplicatore
input int    RectBars       = 20;     // Candele rettangolo congestione

//=== INPUT RISK MANAGEMENT ===
input double RiskPercent    = 1.0;    // Rischio % per operazione
input double MinRR          = 2.0;    // R:R minimo per entrare

//=== INPUT EA ===
input int    MagicNumber    = 123456; // Magic Number base (per simbolo: base+indice)
input string EAComment      = "BREAKOUT_EA"; // Commento ordine
input double MaxSpreadPips   = 3.0;   // Spread massimo (pips) per entrare
input bool   CloseOnOppositeSignal = false; // Chiusura anticipata su segnale/zona opposta (default FALSE: i test mostrano risultati migliori col target 3R)
input bool   ShowRectangle  = true;   // Mostra rettangolo congestione (solo grafico corrente)
input bool   ShowLevels     = true;   // Mostra linee SL/TP/Signal (solo grafico corrente)

//=== ENUM ===
enum TRACKING_ZONE { ZONE_NONE, ZONE_OB, ZONE_OS };

//+------------------------------------------------------------------+
//| Stato PER SIMBOLO. Raccoglie tutte le variabili che nella v2.3   |
//| erano globali e specifiche dell'operazione/segnale.              |
//+------------------------------------------------------------------+
struct SymState
{
    string        symbol;          // nome del simbolo
    int           magic;           // magic dedicato (MagicNumber + indice)
    int           wprHandle;       // handle iWPR del simbolo
    datetime      lastBarTime;     // ultima candela M15 processata

    TRACKING_ZONE trackZone;       // zona tracciata (OB/OS/NONE)
    bool          signalFired;     // segnale attivo / posizione gestita
    bool          breakEvenDone;   // BE gia' applicato
    bool          wasInPosition;   // stato posizione tick precedente

    // Livelli di riferimento dell'operazione, TUTTI ancorati alla candela di segnale.
    double        sigClose;        // chiusura candela di segnale (livello di BE)
    double        sigSL;           // stop loss teorico (1 pip oltre congestione)
    double        sigTP;           // target 3R dalla chiusura del segnale
    double        sigStopPips;     // distanza di stop in pips (dalla chiusura segnale)
    double        rectHigh;        // resistenza congestione
    double        rectLow;         // supporto congestione
};

//=== VARIABILI GLOBALI (non specifiche del singolo simbolo) ===
CTrade        trade;               // una sola istanza CTrade riutilizzata
string        symbols[];           // array dei simboli del paniere
SymState      states[];            // stato parallelo a symbols[]

//+------------------------------------------------------------------+
//| Parsing della lista simboli (separatore virgola, trim spazi).    |
//| Ritorna il numero di simboli validi inseriti in symbols[].       |
//+------------------------------------------------------------------+
int ParseSymbols(const string csv)
{
    ArrayResize(symbols, 0);
    string parts[];
    int n = StringSplit(csv, ',', parts);
    for(int i = 0; i < n; i++)
    {
        string s = parts[i];
        StringTrimLeft(s);
        StringTrimRight(s);
        if(StringLen(s) == 0) continue;

        // Verifica esistenza del simbolo: se non esiste, warning e skip.
        if(!SymbolSelect(s, true))
        {
            Print("[BREAKOUT] WARNING: simbolo '", s, "' non disponibile. Saltato.");
            continue;
        }
        int sz = ArraySize(symbols);
        ArrayResize(symbols, sz + 1);
        symbols[sz] = s;
    }
    return ArraySize(symbols);
}

//+------------------------------------------------------------------+
//| OnInit                                                           |
//+------------------------------------------------------------------+
int OnInit()
{
    if(Period() != PERIOD_M15)
        Print("[BREAKOUT] ATTENZIONE: EA progettato per M15. TF: ", EnumToString(Period()));

    int count = ParseSymbols(InpSymbols);
    if(count <= 0)
    {
        Print("[BREAKOUT] ERRORE: nessun simbolo valido nella lista '", InpSymbols, "'.");
        return INIT_FAILED;
    }

    // Inizializza lo stato e gli handle per ogni simbolo del paniere.
    ArrayResize(states, count);
    for(int i = 0; i < count; i++)
    {
        states[i].symbol        = symbols[i];
        states[i].magic         = MagicNumber + i;   // magic distinto per simbolo
        states[i].wprHandle     = iWPR(symbols[i], PERIOD_M15, WilliamsPeriod);
        states[i].lastBarTime   = 0;
        states[i].trackZone     = ZONE_NONE;
        states[i].signalFired   = false;
        states[i].breakEvenDone = false;
        states[i].wasInPosition = false;
        states[i].sigClose      = 0.0;
        states[i].sigSL         = 0.0;
        states[i].sigTP         = 0.0;
        states[i].sigStopPips   = 0.0;
        states[i].rectHigh      = 0.0;
        states[i].rectLow       = 0.0;

        if(states[i].wprHandle == INVALID_HANDLE)
        {
            Print("[BREAKOUT] ERRORE handle Williams per ", symbols[i], ": ", GetLastError());
            return INIT_FAILED;
        }
    }

    trade.SetDeviationInPoints(20);
    // Magic/Filling vengono impostati per-simbolo prima di ogni ordine.

    Print("[BREAKOUT] v2.4 multi-simbolo inizializzato | Simboli:", count,
          " | Risk:", RiskPercent, "% | MagicBase:", MagicNumber,
          " | CloseOnOpposite:", CloseOnOppositeSignal);
    for(int i = 0; i < count; i++)
        Print("[BREAKOUT]   -> ", symbols[i], " (magic ", states[i].magic, ")");

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| OnDeinit - rilascio di TUTTI gli handle e oggetti grafici.       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    for(int i = 0; i < ArraySize(states); i++)
    {
        if(states[i].wprHandle != INVALID_HANDLE)
        {
            IndicatorRelease(states[i].wprHandle);
            states[i].wprHandle = INVALID_HANDLE;
        }
        // Gli oggetti grafici esistono solo per il simbolo del grafico corrente.
        if(states[i].symbol == Symbol())
            DeleteAllObjects(states[i].symbol);
    }
    Print("[BREAKOUT] EA rimosso. Motivo:", reason);
}

//+------------------------------------------------------------------+
//| OnTick - processa TUTTI i simboli del paniere ad ogni tick.      |
//+------------------------------------------------------------------+
void OnTick()
{
    for(int i = 0; i < ArraySize(states); i++)
        ProcessSymbol(states[i]);
}

//+------------------------------------------------------------------+
//| Logica completa per UN simbolo (replica esatta della v2.3).      |
//| 'st' e' passato per riferimento: lo stato viene aggiornato.      |
//+------------------------------------------------------------------+
void ProcessSymbol(SymState &st)
{
    string sym = st.symbol;

    //=== GESTIONE POSIZIONE A OGNI TICK =============================
    // Il break-even va controllato ad ogni tick (non solo a nuova candela),
    // cosi' lo stop viene spostato a BE non appena il prezzo raggiunge +1R.
    if(SelectMyPosition(st))
        ManageBreakEven(st);

    //=== RILEVAMENTO SEGNALE / APERTURA SOLO A NUOVA CANDELA ========
    datetime barTime = iTime(sym, PERIOD_M15, 0);
    if(barTime == 0) return;                 // dati non ancora disponibili
    if(barTime == st.lastBarTime) return;
    st.lastBarTime = barTime;

    if(iBars(sym, PERIOD_M15) < WilliamsPeriod + RectBars + 20) return;

    //--- Williams su bar[1] (ultima candela chiusa) ---
    double wpr[];
    ArraySetAsSeries(wpr, true);
    if(CopyBuffer(st.wprHandle, 0, 0, 3, wpr) < 3)
    {
        Print("[BREAKOUT][", sym, "] Errore WPR: ", GetLastError());
        return;
    }
    double W = wpr[1];

    //--- SuperTrend su bar[1] ---
    double stDir = GetSuperTrendDir(sym, 1);

    //--- Rilevamento chiusura trade (TP/SL): reset segnale ---
    bool posNow = SelectMyPosition(st);
    if(st.wasInPosition && !posNow)
    {
        Print("[BREAKOUT][", sym, "] Trade chiuso (TP/SL). Reset segnale.");
        ResetSignal(st);
    }
    st.wasInPosition = posNow;

    //--- Aggiornamento TRACKING ZONE -------------------------------
    // trackZone si attiva entrando nell'area estrema (W >= -20 o W <= -80) e
    // RIMANE attiva anche dopo che W esce verso il centro, perche' il segnale
    // richiede che W sia GIA' uscito. Si azzera solo se W torna verso il neutro
    // oltre -50 (setup invalidato) o se raggiunge la zona opposta.
    if(W >= -20.0)
    {
        if(st.trackZone != ZONE_OB)
        {
            st.trackZone = ZONE_OB;
            ResetSignal(st);
            Print("[BREAKOUT][", sym, "] +IPERCOMPRATO | W=", W);
        }
    }
    else if(W <= -80.0)
    {
        if(st.trackZone != ZONE_OS)
        {
            st.trackZone = ZONE_OS;
            ResetSignal(st);
            Print("[BREAKOUT][", sym, "] +IPERVENDUTO | W=", W);
        }
    }
    else if(W <= -50.0 && st.trackZone == ZONE_OB)
    {
        // W troppo verso il neutro mentre tracciavamo un SELL -> setup annullato
        Print("[BREAKOUT][", sym, "] Setup OB annullato: W=", W, " sotto -50");
        st.trackZone = ZONE_NONE;
        ResetSignal(st);
        DeleteAllObjects(sym);
        return;
    }
    else if(W >= -50.0 && st.trackZone == ZONE_OS)
    {
        // W troppo verso il neutro mentre tracciavamo un BUY -> setup annullato
        Print("[BREAKOUT][", sym, "] Setup OS annullato: W=", W, " sopra -50");
        st.trackZone = ZONE_NONE;
        ResetSignal(st);
        DeleteAllObjects(sym);
        return;
    }

    if(st.trackZone == ZONE_NONE) { DeleteAllObjects(sym); return; }

    //--- Rettangolo congestione (20 candele PRECEDENTI il segnale) --
    if(!UpdateRectangle(st)) return;
    if(ShowRectangle && sym == Symbol()) DrawRectangle(st);

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
                Print("[BREAKOUT][", sym, "] Chiusura anticipata SELL (W in ipervenduto)");
                ClosePositionByTicket(st);
                ResetSignal(st);
                st.trackZone = ZONE_OS;
                st.wasInPosition = false;
                return;
            }
            if(posType == POSITION_TYPE_BUY && W >= -20.0)
            {
                Print("[BREAKOUT][", sym, "] Chiusura anticipata BUY (W in ipercomprato)");
                ClosePositionByTicket(st);
                ResetSignal(st);
                st.trackZone = ZONE_OB;
                st.wasInPosition = false;
                return;
            }

            // 2) Segnale operativo OPPOSTO completo.
            bool oppS = (posType == POSITION_TYPE_BUY)  && IsSellSignal(st, W, stDir);
            bool oppB = (posType == POSITION_TYPE_SELL) && IsBuySignal(st, W, stDir);
            if(oppS || oppB)
            {
                Print("[BREAKOUT][", sym, "] Segnale opposto rilevato. Chiusura posizione.");
                ClosePositionByTicket(st);
                ResetSignal(st);
                st.wasInPosition = false;
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
    if(!posNow && !st.signalFired)
    {
        // SELL setup: zona OB, Williams uscito (-50 < W < -20)
        if(st.trackZone == ZONE_OB && IsSellSignal(st, W, stDir))
            TryOpen(st, true, W);
        // BUY setup: zona OS, Williams uscito (-80 < W < -50)
        else if(st.trackZone == ZONE_OS && IsBuySignal(st, W, stDir))
            TryOpen(st, false, W);
    }
}

//+------------------------------------------------------------------+
//| Tentativo di apertura (isSell = true -> SELL, false -> BUY)      |
//+------------------------------------------------------------------+
void TryOpen(SymState &st, bool isSell, double W)
{
    string sym = st.symbol;
    int    dg  = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
    double pip = GetPipSize(sym);
    double cl1 = iClose(sym, PERIOD_M15, 1);   // chiusura candela di segnale

    // SL: 1 pip oltre la congestione. Distanza misurata DALLA CHIUSURA del segnale.
    double sl, tp;
    if(isSell)
    {
        sl = NormalizeDouble(st.rectHigh + pip, dg);
        double stopDist = MathAbs(cl1 - sl);
        tp = NormalizeDouble(cl1 - stopDist * 3.0, dg);  // 3R dalla chiusura segnale
    }
    else
    {
        sl = NormalizeDouble(st.rectLow - pip, dg);
        double stopDist = MathAbs(cl1 - sl);
        tp = NormalizeDouble(cl1 + stopDist * 3.0, dg);  // 3R dalla chiusura segnale
    }

    double stopPips = MathAbs(cl1 - sl) / pip;
    if(stopPips <= 0)
    {
        Print("[BREAKOUT][", sym, "] StopPips non valido. Skip.");
        return;
    }

    // RR calcolato dal prezzo di mercato attuale (ingresso reale).
    double rr = CalcRR(sym, isSell ? SYMBOL_BID : SYMBOL_ASK, sl, tp);

    Print("[BREAKOUT][", sym, "] ", (isSell ? "SELL?" : "BUY?"),
          " cl1:", cl1, " rH:", st.rectHigh, " rL:", st.rectLow,
          " SL:", sl, " TP:", tp, " StopPips:", DoubleToString(stopPips, 1),
          " RR:", DoubleToString(rr, 2), " W:", DoubleToString(W, 1));

    if(rr < MinRR)
    {
        Print("[BREAKOUT][", sym, "] RR insufficiente (", DoubleToString(rr, 2), " < ", MinRR, "). Skip.");
        return;
    }

    // Filtro spread.
    double spreadPips = CurrentSpreadPips(sym);
    if(spreadPips > MaxSpreadPips)
    {
        Print("[BREAKOUT][", sym, "] Spread troppo alto (", DoubleToString(spreadPips, 1),
              " > ", MaxSpreadPips, "). Skip.");
        return;
    }

    double lots = CalculateLots(sym, stopPips);
    if(lots <= 0)
    {
        Print("[BREAKOUT][", sym, "] Lotto non valido. Skip.");
        return;
    }

    // Imposta magic e filling adeguati al simbolo PRIMA dell'ordine.
    trade.SetExpertMagicNumber(st.magic);
    trade.SetTypeFilling(GetBrokerFilling(sym));

    //--- firme B1/C1: il guardiano del conto puo' fermare i NUOVI ingressi
    if(!ABTG_GuardiaIngresso(InpUsaGuardian,"BREAKOUT_EA_JPY_Multi")) return;
    bool sent = isSell ? trade.Sell(lots, sym, 0, sl, tp, EAComment)
                       : trade.Buy (lots, sym, 0, sl, tp, EAComment);

    uint rc = trade.ResultRetcode();
    if(sent && (rc == TRADE_RETCODE_DONE || rc == TRADE_RETCODE_PLACED))
    {
        // Ancoriamo tutti i livelli alla candela di segnale.
        st.sigClose    = cl1;
        st.sigSL       = sl;
        st.sigTP       = tp;
        st.sigStopPips = stopPips;
        st.signalFired = true;
        st.breakEvenDone = false;
        Print("[BREAKOUT][", sym, "] ", (isSell ? "SELL" : "BUY"), " APERTO | Lots:", lots,
              " | sigClose(BE):", st.sigClose);
        if(ShowLevels && sym == Symbol()) DrawLevels(st);
    }
    else
    {
        Print("[BREAKOUT][", sym, "] Errore ordine: ", rc, " ", trade.ResultRetcodeDescription());
    }
}

//+------------------------------------------------------------------+
//| Segnale SELL: tutte e tre le condizioni sulla candela index 1   |
//+------------------------------------------------------------------+
bool IsSellSignal(SymState &st, double W, double stDir)
{
    double cl1 = iClose(st.symbol, PERIOD_M15, 1);
    return (cl1 < st.rectLow &&     // 1) chiusura sotto il supporto
            stDir < 0        &&     // 2) SuperTrend rosso/negativo
            W < -20.0        &&     // 3) Williams uscito dall'ipercomprato...
            W > -50.0);            //    ...ma ancora nella meta' alta (-50..-20)
}

//+------------------------------------------------------------------+
//| Segnale BUY: tutte e tre le condizioni sulla candela index 1    |
//+------------------------------------------------------------------+
bool IsBuySignal(SymState &st, double W, double stDir)
{
    double cl1 = iClose(st.symbol, PERIOD_M15, 1);
    return (cl1 > st.rectHigh &&    // 1) chiusura sopra la resistenza
            stDir > 0         &&    // 2) SuperTrend verde/positivo
            W > -80.0         &&    // 3) Williams uscito dall'ipervenduto...
            W < -50.0);           //    ...ma ancora nella meta' bassa (-80..-50)
}

//+------------------------------------------------------------------+
//| Rettangolo: 20 candele che PRECEDONO la candela di segnale.      |
//| La candela di segnale e' index 1, quindi le 20 precedenti        |
//| partono da shift=2 (bar 2 ... bar RectBars+1).                  |
//| Cosi' la candela di segnale NON e' inclusa e la rottura          |
//| (close oltre rectLow/rectHigh) e' matematicamente possibile.     |
//+------------------------------------------------------------------+
bool UpdateRectangle(SymState &st)
{
    string sym = st.symbol;
    double highs[], lows[];
    ArraySetAsSeries(highs, true);
    ArraySetAsSeries(lows,  true);
    // shift = 2 -> esclude la candela di segnale (index 1) e la corrente (index 0)
    if(CopyHigh(sym, PERIOD_M15, 2, RectBars, highs) < RectBars) return false;
    if(CopyLow (sym, PERIOD_M15, 2, RectBars, lows)  < RectBars) return false;
    st.rectHigh = highs[ArrayMaximum(highs, 0, RectBars)];
    st.rectLow  = lows [ArrayMinimum(lows,  0, RectBars)];
    return true;
}

//+------------------------------------------------------------------+
//| Break-even: a +1R (misurato dalla candela di segnale) sposta lo  |
//| stop ESATTAMENTE sulla CHIUSURA della candela di segnale.        |
//| FEDELTA' (video 38): il BE NON usa il prezzo di fill reale.      |
//| Nessun trailing: dopo il BE la posizione si tiene fino al 3R.    |
//+------------------------------------------------------------------+
void ManageBreakEven(SymState &st)
{
    if(st.breakEvenDone)  return;
    if(st.sigStopPips <= 0) return;   // niente livelli ancorati: nulla da fare

    string sym   = st.symbol;
    int    dg    = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
    long   pt    = PositionGetInteger(POSITION_TYPE);
    ulong  tkt   = PositionGetInteger(POSITION_TICKET);
    double curSL = PositionGetDouble(POSITION_SL);
    double curTP = PositionGetDouble(POSITION_TP);
    double bid   = SymbolInfoDouble(sym, SYMBOL_BID);
    double ask   = SymbolInfoDouble(sym, SYMBOL_ASK);
    double trig  = st.sigStopPips * GetPipSize(sym);    // distanza +1R
    double nSL   = NormalizeDouble(st.sigClose, dg);    // BE = chiusura segnale

    if(pt == POSITION_TYPE_SELL && bid <= st.sigClose - trig)
    {
        if(curSL == 0 || nSL < curSL)   // solo se migliora (mai peggiora) lo stop
        {
            if(trade.PositionModify(tkt, nSL, curTP) &&
               trade.ResultRetcode() == TRADE_RETCODE_DONE)
            { st.breakEvenDone = true; Print("[BREAKOUT][", sym, "] BE SELL -> SL:", nSL); }
        }
    }
    else if(pt == POSITION_TYPE_BUY && ask >= st.sigClose + trig)
    {
        if(curSL == 0 || nSL > curSL)
        {
            if(trade.PositionModify(tkt, nSL, curTP) &&
               trade.ResultRetcode() == TRADE_RETCODE_DONE)
            { st.breakEvenDone = true; Print("[BREAKOUT][", sym, "] BE BUY -> SL:", nSL); }
        }
    }
}

//+------------------------------------------------------------------+
//| Selezione posizione filtrata per MAGIC (del simbolo) + SIMBOLO. |
//| Cicla su PositionsTotal e seleziona via ticket (anti-doppia).   |
//| Ritorna true se la posizione e' selezionata (PositionGet... ok). |
//+------------------------------------------------------------------+
bool SelectMyPosition(SymState &st)
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong tkt = PositionGetTicket(i);
        if(tkt == 0) continue;
        if(PositionGetInteger(POSITION_MAGIC) == st.magic &&
           PositionGetString(POSITION_SYMBOL) == st.symbol)
            return true;   // posizione selezionata da PositionGetTicket
    }
    return false;
}

//+------------------------------------------------------------------+
//| Chiusura della posizione corrente per TICKET.                   |
//+------------------------------------------------------------------+
void ClosePositionByTicket(SymState &st)
{
    if(!SelectMyPosition(st)) return;
    ulong tkt = PositionGetInteger(POSITION_TICKET);
    // Filling adeguato al simbolo prima della chiusura.
    trade.SetTypeFilling(GetBrokerFilling(st.symbol));
    if(trade.PositionClose(tkt))
    {
        uint rc = trade.ResultRetcode();
        if(rc != TRADE_RETCODE_DONE && rc != TRADE_RETCODE_PLACED)
            Print("[BREAKOUT][", st.symbol, "] Errore chiusura: ", rc, " ", trade.ResultRetcodeDescription());
    }
    else
        Print("[BREAKOUT][", st.symbol, "] Errore chiusura: ", trade.ResultRetcode(),
              " ", trade.ResultRetcodeDescription());
}

//+------------------------------------------------------------------+
//| RR dal prezzo di mercato corrente.                              |
//+------------------------------------------------------------------+
double CalcRR(string sym, ENUM_SYMBOL_INFO_DOUBLE priceType, double sl, double tp)
{
    double price = SymbolInfoDouble(sym, priceType);
    double dSL   = MathAbs(price - sl);
    if(dSL <= 0) return 0;
    return MathAbs(price - tp) / dSL;
}

//+------------------------------------------------------------------+
//| SuperTrend (ricalcolo manuale) - direzione su targetBar         |
//| Ritorna +1 (verde/rialzista) o -1 (rosso/ribassista).           |
//+------------------------------------------------------------------+
double GetSuperTrendDir(string sym, int targetBar)
{
    int totalBars = iBars(sym, PERIOD_M15);
    int lookback  = (int)MathMin(500, totalBars - 2);
    if(lookback < ATRPeriod + 30) return 0;

    double hi[], lo[], cl[];
    ArraySetAsSeries(hi, true);
    ArraySetAsSeries(lo, true);
    ArraySetAsSeries(cl, true);
    if(CopyHigh (sym, PERIOD_M15, 0, lookback, hi) < lookback) return 0;
    if(CopyLow  (sym, PERIOD_M15, 0, lookback, lo) < lookback) return 0;
    if(CopyClose(sym, PERIOD_M15, 0, lookback, cl) < lookback) return 0;

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
double CalculateLots(string sym, double stopPips)
{
    if(stopPips <= 0) return 0;
    double bal  = AccountInfoDouble(ACCOUNT_BALANCE);
    double risk = bal * RiskPercent / 100.0;
    double tv   = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_VALUE);
    double ts   = SymbolInfoDouble(sym, SYMBOL_TRADE_TICK_SIZE);
    double ps   = GetPipSize(sym);
    if(tv <= 0 || ts <= 0 || ps <= 0) return 0;

    double pv   = (ps / ts) * tv;   // valore di 1 pip per 1 lotto
    if(pv <= 0) return 0;

    double lots = risk / (stopPips * pv);
    double mn   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MIN);
    double mx   = SymbolInfoDouble(sym, SYMBOL_VOLUME_MAX);
    double stp  = SymbolInfoDouble(sym, SYMBOL_VOLUME_STEP);

    lots = MathFloor(lots / stp) * stp;
    lots = MathMax(mn, MathMin(mx, lots));

    int volDigits = VolumeDigits(stp);
    lots = NormalizeDouble(lots, volDigits);

    Print("[BREAKOUT][", sym, "] Lots:", lots, " (Risk:", risk, " StopPip:",
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
double GetPipSize(string sym)
{
    int d = (int)SymbolInfoInteger(sym, SYMBOL_DIGITS);
    double p = SymbolInfoDouble(sym, SYMBOL_POINT);
    return (d == 5 || d == 3) ? p * 10.0 : p;
}

//+------------------------------------------------------------------+
//| Spread corrente in pips.                                        |
//+------------------------------------------------------------------+
double CurrentSpreadPips(string sym)
{
    double bid = SymbolInfoDouble(sym, SYMBOL_BID);
    double ask = SymbolInfoDouble(sym, SYMBOL_ASK);
    double pip = GetPipSize(sym);
    if(pip <= 0) return 0;
    return (ask - bid) / pip;
}

//+------------------------------------------------------------------+
//| Filling mode adattivo in base a SYMBOL_FILLING_MODE.            |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE_FILLING GetBrokerFilling(string sym)
{
    long modes = SymbolInfoInteger(sym, SYMBOL_FILLING_MODE);
    if((modes & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
    if((modes & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
    return ORDER_FILLING_RETURN;
}

//+------------------------------------------------------------------+
//| Reset stato segnale e cancellazione livelli grafici.            |
//+------------------------------------------------------------------+
void ResetSignal(SymState &st)
{
    st.signalFired   = false;
    st.breakEvenDone = false;
    st.sigClose = 0; st.sigSL = 0; st.sigTP = 0; st.sigStopPips = 0;
    // Cancella i livelli solo se siamo sul grafico del simbolo corrente.
    if(st.symbol == Symbol())
    {
        ObjectDelete(0, ObjName(st.symbol, "SIG"));
        ObjectDelete(0, ObjName(st.symbol, "SL"));
        ObjectDelete(0, ObjName(st.symbol, "TP"));
        ChartRedraw();
    }
}

//+------------------------------------------------------------------+
//| Nome oggetto grafico univoco per simbolo.                       |
//+------------------------------------------------------------------+
string ObjName(string sym, string suffix)
{
    return "BREAK_" + sym + "_" + suffix;
}

//+------------------------------------------------------------------+
//| Disegno rettangolo congestione allineato (bar 2 -> bar RectBars+1)|
//| Disegnato SOLO per il simbolo del grafico corrente.             |
//+------------------------------------------------------------------+
void DrawRectangle(SymState &st)
{
    string   sym = st.symbol;
    string   n   = ObjName(sym, "RECT");
    datetime t1  = iTime(sym, PERIOD_M15, 2);            // candela piu' recente del rettangolo
    datetime t2  = iTime(sym, PERIOD_M15, RectBars + 1); // candela piu' vecchia del rettangolo
    color c = (st.trackZone == ZONE_OB) ? clrRoyalBlue : clrForestGreen;
    if(ObjectFind(0, n) < 0) ObjectCreate(0, n, OBJ_RECTANGLE, 0, t1, st.rectHigh, t2, st.rectLow);
    ObjectSetInteger(0, n, OBJPROP_TIME,  0, t1);
    ObjectSetDouble (0, n, OBJPROP_PRICE, 0, st.rectHigh);
    ObjectSetInteger(0, n, OBJPROP_TIME,  1, t2);
    ObjectSetDouble (0, n, OBJPROP_PRICE, 1, st.rectLow);
    ObjectSetInteger(0, n, OBJPROP_COLOR, c);
    ObjectSetInteger(0, n, OBJPROP_BACK,  true);
    ObjectSetInteger(0, n, OBJPROP_FILL,  true);
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Disegno livelli Signal / SL / TP (solo grafico corrente).       |
//+------------------------------------------------------------------+
void DrawLevels(SymState &st)
{
    int dg = (int)SymbolInfoInteger(st.symbol, SYMBOL_DIGITS);
    DrawHLine(ObjName(st.symbol, "SIG"), st.sigClose, clrYellow, 2, "Signal:" + DoubleToString(st.sigClose, dg));
    DrawHLine(ObjName(st.symbol, "SL"),  st.sigSL,    clrRed,    2, "SL:"     + DoubleToString(st.sigSL,    dg));
    DrawHLine(ObjName(st.symbol, "TP"),  st.sigTP,    clrLime,   2, "TP:"     + DoubleToString(st.sigTP,    dg));
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
//| Cancellazione di tutti gli oggetti grafici dell'EA per simbolo. |
//+------------------------------------------------------------------+
void DeleteAllObjects(string sym)
{
    string ns[] = {"RECT", "SIG", "SL", "TP"};
    for(int i = 0; i < ArraySize(ns); i++)
    {
        string nm = ObjName(sym, ns[i]);
        if(ObjectFind(0, nm) >= 0) ObjectDelete(0, nm);
    }
    ChartRedraw();
}
//+------------------------------------------------------------------+
