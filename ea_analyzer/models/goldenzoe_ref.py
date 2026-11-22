"""Modello di riferimento di GoldenZoe_H4 (v1.11-1.13, solo acquisti) scritto in Python SULLA BASE DEL NOSTRO CODICE MQL5 (mql5/Experts/GoldenZoe_H4.mq5).
Serve per misurare quanto il tester e questo modello coincidano: ingresso a mercato alla prima quotazione della candela H4 dopo la chiusura sopra il massimo delle N precedenti,
stop iniziale = k x ATR(14, media semplice come iATR di MT5), stop mobile Chandelier, nessun target, una posizione, attesa di una candela dopo la chiusura."""
import numpy as np, pandas as pd


def simulate(m1, N=55, atr_period=14, stop_atr=3.0, trail_atr=3.0, tf="4h", digits=2, point=0.01, min_dist=0.0):
    ts = 10 ** (-digits)
    b = m1.resample(tf).agg({"open": "first", "high": "max", "low": "min", "close": "last"}).dropna()
    O, H, L, C = [b[k].values for k in ("open", "high", "low", "close")]; idx = b.index; n = len(b)
    pc = np.r_[C[0], C[:-1]]; tr = np.maximum.reduce([H - L, np.abs(H - pc), np.abs(L - pc)])
    atr = pd.Series(tr).rolling(atr_period).mean().values
    mo = m1["open"].values; ml = m1["low"].values; mt = m1.index.values; msp = m1["spread"].values * point if "spread" in m1 else np.zeros(len(m1))
    rnd = lambda x: round(round(x / ts) * ts, digits)
    out = []; i = max(N, atr_period) + 2; last_had_bar = -10
    while i < n - 1:
        b0 = i + 1  # candela in cui si entra; segnale sulla candela i (chiusa)
        if b0 - 1 <= last_had_bar:   # esisteva una posizione nella candela del segnale
            i += 1; continue
        if np.isnan(atr[i]) or not (C[i] > H[i - N:i].max()):
            i += 1; continue
        k0 = np.searchsorted(mt, np.datetime64(idx[b0]))
        if k0 >= len(mt):
            break
        ask = mo[k0] + msp[k0]; sl = rnd(ask - stop_atr * atr[i]); ent = ask; ext = ask; t_in = pd.Timestamp(mt[k0])
        j = b0; exit_t = exit_p = None; sl0 = sl
        while j < n:
            kb = np.searchsorted(mt, np.datetime64(idx[j])); ke = np.searchsorted(mt, np.datetime64(idx[j] + pd.Timedelta(tf)))
            if j > b0:  # al primo tick della candela: aggiorno lo stop mobile
                ext = max(ext, H[b0:j].max()); ns = rnd(ext - trail_atr * atr[j - 1]); bid = mo[kb]
                if ns > sl + point * 0.5 and ns <= bid - min_dist:
                    sl = ns
            if kb >= ke:
                j += 1; continue
            lows = ml[kb:ke]; hit = np.where(lows <= sl)[0]
            if len(hit):
                kh = kb + hit[0]; exit_p = mo[kh] if mo[kh] < sl else sl; exit_t = pd.Timestamp(mt[kh]); break
            j += 1
        if exit_t is None:
            break
        out.append(dict(open_time=t_in, close_time=exit_t, side="buy", open_price=ent, close_price=exit_p, sl=sl0, sl_final=sl))
        last_had_bar = int(np.searchsorted(idx.values, np.datetime64(exit_t), side="right") - 1)
        i = last_had_bar + 1 - 1 + 1
    return pd.DataFrame(out)
