#!/usr/bin/env python3
"""Scanner FX a UN solo alert dall'indicatore 'Bulge Signals FILTRO R/R - Breaking Band' di Claudio (logica identica, copiata dal suo Pine)."""
SYMS = ['EURUSD','GBPUSD','USDJPY','USDCHF','USDCAD','AUDUSD','NZDUSD','EURGBP','EURJPY','EURCHF','EURCAD','EURAUD','EURNZD','GBPJPY','GBPCHF','GBPCAD','GBPAUD','GBPNZD','AUDJPY','AUDCHF','AUDCAD','AUDNZD','CADJPY','CADCHF','CHFJPY','NZDJPY','NZDCHF','NZDCAD']
H = '''//@version=5
indicator("Bulge Signals Scanner FX (1 alert, 28 cross)", overlay=true)

// Scanner a UN SOLO ALERT: stessa logica dell'indicatore "Bulge Signals FILTRO R/R - Breaking Band"
// (bulge -> uscita dalla banda -> rientro, filtro R/R, anti-doppione), applicata a 28 cross OANDA
// sul timeframe del grafico su cui lo metti. Come usarlo: aggiungilo a un grafico H1 di qualsiasi
// simbolo, poi Alert -> Condizione: questo indicatore -> "Qualsiasi chiamata alert()" -> "Una volta alla chiusura della barra".

bbLen      = input.int(20,   "Periodo Bollinger", minval=1)
bbMult     = input.float(2.0,"Deviazioni Bollinger", minval=0.1)
expLook    = input.int(20,   "Barre per misurare l'espansione", minval=2)
expFactor  = input.float(1.12,"Fattore di espansione banda (bulge)", minval=1.0)
atrLen     = input.int(14,   "Periodo ATR (per lo stop)", minval=1)
slAtrMult  = input.float(3.0,"Stop = n x ATR oltre l'estremo", minval=0.1)
minRR      = input.float(1.5,"Rapporto R/R minimo per segnalare", minval=0.1)
antiRepeat = input.int(6,    "Barre di attesa tra due segnali (anti-doppione)", minval=0)

f_sig() =>
    basis = ta.sma(close, bbLen)
    dev   = bbMult * ta.stdev(close, bbLen)
    upper = basis + dev
    lower = basis - dev
    width = upper - lower
    avgWidth = ta.sma(width, expLook)
    isBulge  = width > avgWidth * expFactor
    atr = ta.atr(atrLen)
    rawBuy  = isBulge[1] and close[1] < lower[1] and close > lower and close < basis
    rawSell = isBulge[1] and close[1] > upper[1] and close < upper and close > basis
    buySL    = low  - slAtrMult * atr
    buyRisk  = close - buySL
    buyRR    = buyRisk > 0 ? (basis - close) / buyRisk : 0.0
    sellSL   = high + slAtrMult * atr
    sellRisk = sellSL - close
    sellRR   = sellRisk > 0 ? (close - basis) / sellRisk : 0.0
    buyOK  = rawBuy  and buyRR  >= minRR
    sellOK = rawSell and sellRR >= minRR
    var int lastBuyBar  = -1000
    var int lastSellBar = -1000
    buySig  = buyOK  and (bar_index - lastBuyBar  > antiRepeat)
    sellSig = sellOK and (bar_index - lastSellBar > antiRepeat)
    if buySig
        lastBuyBar := bar_index
    if sellSig
        lastSellBar := bar_index
    [buySig, sellSig, buyRR, sellRR, buySL, sellSL]

string msg = ""
'''
out = [H]
for i, s in enumerate(SYMS, 1):
    out.append(f'[b{i}, s{i}, br{i}, sr{i}, bl{i}, sl{i}] = request.security("OANDA:{s}", timeframe.period, f_sig(), lookahead=barmerge.lookahead_off)\n'
               f'if b{i}\n    msg += "BULGE BUY {s} | SL " + str.tostring(bl{i}, "#.#####") + " | R/R " + str.tostring(br{i}, "#.0") + "\\n"\n'
               f'if s{i}\n    msg += "BULGE SELL {s} | SL " + str.tostring(sl{i}, "#.#####") + " | R/R " + str.tostring(sr{i}, "#.0") + "\\n"\n')
out.append('\nif msg != ""\n    alert(msg, alert.freq_once_per_bar_close)\n\nplot(na)\n')
open('Bulge_Signals_Scanner_FX.pine', 'w').write(''.join(out))
print(len(SYMS), 'simboli')
