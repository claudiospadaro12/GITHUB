#!/usr/bin/env python3
"""Golden Cross HA (PDF) e Golden Cross di Paolo (Pine) su forex. Criteri: report/GOLDEN_CROSS_V2_CRITERI_2026-11-25.md
Versione ORO (preset GOLD del Pine). Uso: /usr/bin/python3 -I golden_cross_oro.py <cartella_H1_con_XAUUSD> [<out.md>]"""
import sys, os
import numpy as np, pandas as pd
D = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else None
SP = {'XAUUSD': 25, 'EURUSD': 0.8, 'USDJPY': 1.0, 'GBPUSD': 1.2, 'AUDUSD': 1.2, 'EURGBP': 1.5, 'USDCAD': 1.5, 'USDCHF': 1.5, 'NZDUSD': 1.8, 'EURJPY': 1.8, 'GBPJPY': 2.8}
SLIP = 0.5; out = []
def P(s=''): print(s); out.append(s)
def load(s, tf):
    d = pd.read_csv(os.path.join(D, f'ABTG_H1_{s}.csv'), sep=';'); d['t'] = pd.to_datetime(d['date'], format='%Y.%m.%d %H:%M')
    d = d.set_index('t').sort_index(); d = d[(d.index >= '2004-06-01') & (d.index < '2026-11-24') & (d.high >= d.low)][['open', 'high', 'low', 'close']]
    if tf == 'H4': d = d.resample('4h', origin='start_day').agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last'}).dropna()
    return d
def wilder(x, n): return x.ewm(alpha=1 / n, adjust=False).mean()
def indicators(d):
    c, h, l, o = d.close, d.high, d.low, d.open; pc = c.shift(1)
    tr = pd.concat([h - l, (h - pc).abs(), (l - pc).abs()], axis=1).max(axis=1)
    d['atr'] = tr.rolling(14).mean(); d['e9'] = c.ewm(span=9, adjust=False).mean(); d['e21'] = c.ewm(span=21, adjust=False).mean(); d['e50'] = c.ewm(span=50, adjust=False).mean()
    up = h.diff(); dn = -l.diff(); pdm = np.where((up > dn) & (up > 0), up, 0.0); mdm = np.where((dn > up) & (dn > 0), dn, 0.0)
    atrw = wilder(tr, 14); dip = 100 * wilder(pd.Series(pdm, index=d.index), 14) / atrw; dim = 100 * wilder(pd.Series(mdm, index=d.index), 14) / atrw
    dx = 100 * (dip - dim).abs() / (dip + dim).replace(0, np.nan); d['adx'] = wilder(dx.fillna(0), 14); d['dip'] = dip; d['dim'] = dim
    hac = (o + h + l + c) / 4; hao = np.zeros(len(d)); hao[0] = (o.iloc[0] + c.iloc[0]) / 2
    hav = hac.values
    for i in range(1, len(d)): hao[i] = (hao[i - 1] + hav[i - 1]) / 2
    hao = pd.Series(hao, index=d.index); d['hao'] = hao; d['hac'] = hac; d['hah'] = pd.concat([h, hao, hac], axis=1).max(axis=1); d['hal'] = pd.concat([l, hao, hac], axis=1).min(axis=1)
    return d
def signals_A(d, adx_min):
    c = d.close; e9, e21, e50 = d.e9, d.e21, d.e50
    cu = ((e9 > e21) & (e9.shift(1) <= e21.shift(1))).astype(int); cd = ((e9 < e21) & (e9.shift(1) >= e21.shift(1))).astype(int)
    cur = cu.rolling(6).max() > 0; cdr = cd.rolling(6).max() > 0
    bull = d.hac > d.hao; bear = d.hac < d.hao; body = (d.hac - d.hao).abs().replace(0, np.nan)
    lw = (pd.concat([d.hao, d.hac], axis=1).min(axis=1) - d.hal); uw = (d.hah - pd.concat([d.hao, d.hac], axis=1).max(axis=1))
    b3 = bull & bull.shift(1) & bull.shift(2) & (lw / body <= 0.25); s3 = bear & bear.shift(1) & bear.shift(2) & (uw / body <= 0.25)
    adxok = (d.adx >= adx_min) & (d.adx >= d.adx.shift(1) - 0.5)
    L = (c > e50) & (e50 >= e50.shift(3)) & (e9 > e21) & (e9 > e9.shift(2)) & (e21 > e21.shift(2)) & cur & b3 & adxok & (d.dip > d.dim) & ((c - e21) <= d.atr)
    S = (c < e50) & (e50 <= e50.shift(3)) & (e9 < e21) & (e9 < e9.shift(2)) & (e21 < e21.shift(2)) & cdr & s3 & adxok & (d.dim > d.dip) & ((e21 - c) <= d.atr)
    return L.fillna(False).values, S.fillna(False).values
def supertrend(d, per=10, mult=3.0):
    h, l, c = d.high.values, d.low.values, d.close.values; pc = np.r_[c[0], c[:-1]]
    tr = np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc))); atr = wilder(pd.Series(tr), per).values
    hl2 = (h + l) / 2; ub = hl2 + mult * atr; lb = hl2 - mult * atr; n = len(c); fu = ub.copy(); fl = lb.copy(); dr = np.ones(n)  # dr -1 = rialzo (come Pine: <0 = long)
    dr[0] = 1
    for i in range(1, n):
        fu[i] = ub[i] if (ub[i] < fu[i - 1] or c[i - 1] > fu[i - 1]) else fu[i - 1]
        fl[i] = lb[i] if (lb[i] > fl[i - 1] or c[i - 1] < fl[i - 1]) else fl[i - 1]
        if dr[i - 1] == 1 and c[i] > fu[i]: dr[i] = -1
        elif dr[i - 1] == -1 and c[i] < fl[i]: dr[i] = 1
        else: dr[i] = dr[i - 1]
    return pd.Series(dr, index=d.index)
def barssince(b):
    a = b.values; out = np.full(len(a), 9999); last = -10 ** 9
    for i in range(len(a)):
        if a[i]: last = i
        out[i] = i - last
    return pd.Series(out, index=b.index)
def signals_B(d, pair, trig):
    mt = 0.01; c, o = d.close, d.open; FLAT, MINSP, MINSL, BBSL = 0.05, 0.01, 0.1, 0.2; c, o = d.close, d.open
    dr = supertrend(d); flipL = (dr < 0) & (dr.shift(1) > 0); flipS = (dr > 0) & (dr.shift(1) < 0)
    cu = (d.e9 > d.e21) & (d.e9.shift(1) <= d.e21.shift(1)); cd = (d.e9 < d.e21) & (d.e9.shift(1) >= d.e21.shift(1))
    W = 3; bsL, bsS, bcu, bcd = barssince(flipL), barssince(flipS), barssince(cu), barssince(cd)
    longT = (flipL & (bcu <= W)) | (cu & (bsL <= W)); shortT = (flipS & (bcd <= W)) | (cd & (bsS <= W))
    sl9 = (d.e9 - d.e9.shift(3)) / 3; sl21 = (d.e21 - d.e21.shift(3)) / 3
    up_ok = (sl9 / mt > FLAT) & (sl21 / mt > FLAT); dn_ok = (sl9 / mt < -FLAT) & (sl21 / mt < -FLAT)
    sp1 = (d.e9 - d.e21).abs() / d.e21 * 100; sp2 = (d.e21 - d.e50).abs() / d.e50 * 100; qual = ((sp1 + sp2) / 2 >= MINSP) & (sl9.abs() / mt >= MINSL)
    if trig == 'FC': armL = longT & up_ok & qual; armS = shortT & dn_ok & qual
    else:
        mid = c.rolling(20).mean(); sd = c.rolling(20).std(ddof=0); w = 4 * sd / mid * 100
        bsl = (mid - mid.shift(5)) / 5 / mt; exp = (w - w.shift(3)) / w.shift(3) * 100
        cl = (bsl > BBSL) & (exp >= 5.0); cs = (bsl < -BBSL) & (exp >= 5.0)
        armL = (cl & ~cl.shift(1, fill_value=False).astype(bool)) & up_ok; armS = (cs & ~cs.shift(1, fill_value=False).astype(bool)) & dn_ok
    body = (c - o).abs() >= d.atr * 0.5
    L = armL.shift(1).fillna(False) & (c > o) & (c > c.shift(1)) & body; S = armS.shift(1).fillna(False) & (c < o) & (c < c.shift(1)) & body
    res = []
    for sig in (L, S):
        v = np.array(sig.fillna(False).values, dtype=bool, copy=True); last = -10 ** 9
        for i in range(len(v)):
            if v[i]:
                if i - last <= 6: v[i] = False
                else: last = i
        res.append(v)
    return res[0], res[1]
def trade_loop(d, pair, L, S, k, ema_exit):
    pip = 0.01; slipp = 10.0; sp = SP[pair] * pip; o = d.open.values; h = d.high.values; l = d.low.values; c = d.close.values
    atr = d.atr.values; e21 = d.e21.values; idx = d.index; n = len(d); res = []; i = 60; pos_end = -1
    day = idx.normalize().values; cnt = {}; losses = {}
    while i < n - 2:
        if i <= pos_end or not (L[i] or S[i]) or not np.isfinite(atr[i]): i += 1; continue
        long_ = bool(L[i]); j = i + 1; dkey = day[j]
        if cnt.get(dkey, 0) >= 2 or losses.get(dkey, 0) >= 2: i += 1; continue
        if (idx[j] - idx[i]) > pd.Timedelta(hours=30): i += 1; continue
        entry = o[j] + (sp if long_ else 0.0)
        ref = entry if long_ else o[j]
        if long_: sl = min(l[i - 2:i + 1]) - 0.1 * atr[i]; R = entry - sl
        else: sl = max(h[i - 2:i + 1]) + 0.1 * atr[i]; R = sl - ref
        if not (0.3 * atr[i] <= R <= 2 * atr[i]): i += 1; continue
        tp = (entry + k * R) if long_ else (ref - k * R); pnl = None; exit_j = j
        for m in range(j, min(n, j + 400)):
            nextgap = (idx[m + 1] - idx[m]) if m + 1 < n else pd.Timedelta(days=9)
            if long_:
                if l[m] <= sl: pnl = (sl - slipp * pip) - entry; exit_j = m; break
                if h[m] >= tp: pnl = tp - entry; exit_j = m; break
                if m > j and ema_exit and c[m] < e21[m]: pnl = c[m] - entry; exit_j = m; break
            else:
                if h[m] + sp >= sl: pnl = ref - (sl + slipp * pip); exit_j = m; break
                if l[m] + sp <= tp: pnl = ref - tp; exit_j = m; break
                if m > j and ema_exit and c[m] > e21[m]: pnl = ref - (c[m] + sp); exit_j = m; break
            if nextgap > pd.Timedelta(hours=30) or (idx[m].weekday() == 4 and idx[m].hour >= 20):
                pnl = (c[m] - entry) if long_ else (ref - (c[m] + sp)); exit_j = m; break
        if pnl is None: pnl = ((c[min(n - 1, j + 399)] - entry) if long_ else (ref - (c[min(n - 1, j + 399)] + sp))); exit_j = min(n - 1, j + 399)
        r = pnl / R; res.append((idx[j], r)); cnt[dkey] = cnt.get(dkey, 0) + 1
        if r < 0: losses[dkey] = losses.get(dkey, 0) + 1
        else: losses[dkey] = 0
        pos_end = exit_j; i = exit_j + 1
    return res
PERI = [('IS 2005-2015', 2005, 2015, 100), ('OOS 2016-2021', 2016, 2021, 60), ('HO 2022-2026', 2022, 2026, 40)]
def pf(x):
    x = np.array(x)
    if len(x) == 0: return 0, 0.0, 0.0
    w = x[x > 0].sum(); l = -x[x < 0].sum(); return len(x), (w / l if l > 0 else 99.0), (x > 0).mean() * 100
CELLE = [('A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA)', 'A', 'H1', dict(adx=20, k=1.5, ex=True)),
 ('A2 H4', 'A', 'H4', dict(adx=20, k=1.5, ex=True)), ('A3 ADX 25', 'A', 'H1', dict(adx=25, k=1.5, ex=True)),
 ('A4 target 1R', 'A', 'H1', dict(adx=20, k=1.0, ex=True)), ('A5 target 2R', 'A', 'H1', dict(adx=20, k=2.0, ex=True)),
 ('A6 senza uscita EMA21', 'A', 'H1', dict(adx=20, k=1.5, ex=False)),
 ('B1 Paolo FLIP+CROSS H1 (PRIMARIA)', 'B', 'H1', dict(trig='FC', k=1.5, ex=True)), ('B2 Paolo FLIP+CROSS H4', 'B', 'H4', dict(trig='FC', k=1.5, ex=True)),
 ('B3 Paolo bande inclinate H1', 'B', 'H1', dict(trig='BB', k=1.5, ex=True))]
cache = {}
def get(pair, tf):
    if (pair, tf) not in cache: cache[(pair, tf)] = indicators(load(pair, tf))
    return cache[(pair, tf)]
P('| cella | periodo | operazioni | PF (R) | % vincenti | R medio | R/anno |'); P('|---|---|---|---|---|---|---|')
verd = []
for nome, fam, tf, par in CELLE:
    rows = []
    for p in ['XAUUSD']:
        d = get(p, tf)
        L, S = signals_A(d, par['adx']) if fam == 'A' else signals_B(d, p, par['trig'])
        rows += trade_loop(d, p, L, S, par['k'], par['ex'])
    df = pd.DataFrame(rows, columns=['t', 'R']); df['y'] = df.t.dt.year; res = {}
    for pn, y0, y1, nmin in PERI:
        x = df[(df.y >= y0) & (df.y <= y1)].R.tolist(); n, f, w = pf(x); res[pn] = (n, f, nmin)
        P(f'| {nome} | {pn} | {n} | {f:.2f} | {w:.0f} | {np.mean(x) if x else 0:.3f} | {sum(x)/(y1-y0+1):.1f} |')
    i, o, h = res['IS 2005-2015'], res['OOS 2016-2021'], res['HO 2022-2026']
    ok = i[0] >= i[2] and i[1] >= 1.3 and o[0] >= o[2] and o[1] > 1.2 and h[0] >= h[2] and h[1] > 1.0
    verd.append(f'- {nome}: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('PASSA' if ok else 'non passa'))
P(); P('VERDETTO (soglie dei criteri):'); [P(v) for v in verd]
if OUT: open(OUT, 'w').write('\n'.join(out) + '\n')
