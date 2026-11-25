#!/usr/bin/env python3
"""Genera Breaking_Band_Scanner_v42.pine: UNA sola scheda di TradingView controlla 36 simboli (un solo alert 'Qualsiasi chiamata alert()').
Macchina a stati = BreakingBand_ALLCROSSES_v42.mq5 di Leonardo (bulge 1a/2a CONT, 3a INV), senza ordini: solo avvisi. Limite di Pine: 40 request.security per script."""
SYM = ['EURUSD','GBPUSD','USDJPY','USDCHF','USDCAD','AUDUSD','NZDUSD','EURGBP','EURJPY','EURCHF','EURCAD','EURAUD','EURNZD','GBPJPY','GBPCHF','GBPCAD','GBPAUD','GBPNZD','CADJPY','AUDJPY','NZDJPY','CHFJPY','AUDCAD','AUDCHF','AUDNZD','NZDCAD','NZDCHF','CADCHF',
       'XAUUSD','XAGUSD','DE30EUR','NAS100USD','SPX500USD','US30USD','JP225USD','UK100GBP']
assert len(SYM) == 36
L = []
L.append('''//@version=5
indicator("Breaking Band Scanner v4.2 (avvisi, 36 simboli)", overlay=true)
// ============================================================================
//  Scanner di Breaking Band (regole di Leonardo, v4.2) per TradingView.
//  NON apre ordini: manda avvisi. UN SOLO alert per tutti i simboli:
//  aggiungi lo script a un grafico H1 (qualsiasi simbolo), poi Crea alert ->
//  Condizione = questo script -> "Qualsiasi chiamata alert()" -> Una volta alla chiusura della barra.
//  Logica (come l'EA MT5): bulge = la barra tocca la banda di Bollinger 20/2; 1a e 2a bulge nella stessa
//  direzione = CONTINUAZIONE (ingresso al livello SALVATO della banda opposta); 3a = INVERSIONE (mediana, poi ritorno alla banda).
//  SL = 3 x ATR(14) salvato al bulge; TP = mediana corrente; timeout 40 barre; retrace richiesto per contare.
//  I nomi dei simboli sono quelli di OANDA: se il tuo TradingView usa un altro feed, cambiali negli input.
// ============================================================================
bbLen   = input.int(20, "Periodo Bollinger", minval=2)
bbDev   = input.float(2.0, "Deviazioni", minval=0.5)
atrLen  = input.int(14, "Periodo ATR", minval=1)
slMult  = input.float(3.0, "SL = n x ATR", minval=0.5)
tmo     = input.int(40, "Timeout (barre)", minval=5)
''')
for i, s in enumerate(SYM, 1):
    pref = 'OANDA:'
    L.append('s%02d = input.symbol("%s%s", "Simbolo %02d")' % (i, pref, s, i))
L.append('''
f_bb(int _len, float _dev, int _atrLen, float _slm, int _tmo) =>
    float basis = ta.sma(close, _len)
    float dev = _dev * ta.stdev(close, _len)
    float bu = basis + dev
    float bl = basis - dev
    float atr = ta.sma(ta.tr(true), _atrLen)
    var int st = 0
    var int cnt = 0
    var int bdir = 0
    var int bcnt = 0
    var bool oppR = false
    var float imp = na
    var float opp = na
    var float atrS = na
    int ev = 0
    int tdir = 0
    int kind = 0
    float ent = na
    float sl = na
    float tp = na
    if not na(bu) and not na(atr)
        if st == 0
            bool bUp = high >= bu
            bool bDn = low <= bl
            if bUp or bDn
                int nd = bUp ? 1 : -1
                if bdir == 0 or nd != bdir
                    bdir := nd
                    bcnt := 1
                else if oppR
                    bcnt := math.min(bcnt + 1, 3)
                else
                    bcnt := 1
                imp := nd == 1 ? bu : bl
                opp := nd == 1 ? bl : bu
                atrS := atr
                oppR := false
                cnt := 0
                st := bcnt <= 2 ? 1 : 2
                ev := 1
        else if st == 1
            if cnt > _tmo
                bcnt := 0
                bdir := 0
                oppR := false
                st := 0
            else
                bool reached = (bdir == 1 and low <= opp) or (bdir == -1 and high >= opp)
                if reached
                    oppR := true
                    if math.abs(basis - opp) >= atrS * 0.5
                        ev := 2
                        kind := 1
                        tdir := bdir
                        ent := opp
                        sl := ent - tdir * _slm * atrS
                        tp := basis
                    st := 0
        else if st == 2
            if cnt > _tmo
                bcnt := 0
                bdir := 0
                oppR := false
                st := 0
            else if (bdir == 1 and low <= opp) or (bdir == -1 and high >= opp)
                ev := 3
                st := 0
            else
                bool atMed = bdir == 1 ? (low <= basis or close <= basis * 1.001) : (high >= basis or close >= basis * 0.999)
                if atMed
                    st := 3
                    cnt := 0
        else if st == 3
            if cnt > _tmo
                bcnt := 0
                bdir := 0
                oppR := false
                st := 0
            else if (bdir == 1 and low <= opp) or (bdir == -1 and high >= opp)
                ev := 3
                st := 0
            else
                bool back = (bdir == 1 and high >= imp) or (bdir == -1 and low <= imp)
                if back
                    if math.abs(basis - imp) >= atrS * 0.5
                        ev := 2
                        kind := 2
                        tdir := -bdir
                        ent := imp
                        sl := ent - tdir * _slm * atrS
                        tp := basis
                    st := 0
        cnt := cnt + 1
    [ev, bcnt, bdir, tdir, ent, sl, tp, kind]

f_fire(string _sym, int _ev, int _bcnt, int _bdir, int _tdir, float _ent, float _sl, float _tp, int _kind) =>
    if _ev != 0 and barstate.isconfirmed
        string nm = array.get(str.split(_sym, ":"), array.size(str.split(_sym, ":")) - 1)
        string tf = timeframe.period
        string msg = ""
        if _ev == 1
            msg := "BULGE #" + str.tostring(_bcnt) + " " + (_bdir == 1 ? "SU" : "GIU") + " | " + nm + " " + tf + (_bcnt <= 2 ? " | CONTINUAZIONE: attendo il ritorno alla banda opposta" : " | INVERSIONE: attendo mediana poi ritorno alla banda")
        else if _ev == 2
            msg := "ZONA INGRESSO " + (_kind == 1 ? "CONT " : "INVE ") + (_tdir == 1 ? "BUY" : "SELL") + " | " + nm + " " + tf + " | entry " + str.tostring(_ent, "#.#####") + " | SL " + str.tostring(_sl, "#.#####") + " | TP mediana " + str.tostring(_tp, "#.#####") + " | CHECKLIST: guarda il grafico e il contesto, nessuna news ad alto impatto, decidi tu"
        else
            msg := "INVALIDATO | " + nm + " " + tf + " | il prezzo ha toccato la banda opposta"
        alert(msg, alert.freq_once_per_bar_close)
    0
''')
for i in range(1, len(SYM) + 1):
    L.append('[e%02d, c%02d, d%02d, t%02d, n%02d, l%02d, p%02d, k%02d] = request.security(s%02d, timeframe.period, f_bb(bbLen, bbDev, atrLen, slMult, tmo), lookahead=barmerge.lookahead_off)' % ((i,) * 9))
for i in range(1, len(SYM) + 1):
    L.append('f_fire(s%02d, nz(e%02d), nz(c%02d), nz(d%02d), nz(t%02d), nz(n%02d), nz(l%02d), nz(p%02d), nz(k%02d))' % ((i,) * 9))
L.append('''
plot(0, "dummy", display=display.none)''')
open('Breaking_Band_Scanner_v42.pine', 'w', encoding='utf-8').write('\n'.join(L) + '\n')
print('righe', len(L))
