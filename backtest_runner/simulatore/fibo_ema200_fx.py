#!/usr/bin/env python3
"""Fibo H4 e Media 200 sui cross forex (traduzione meccanica). Criteri: report/FIBO_H4_MEDIA200_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I fibo_ema200_fx.py <cartella_H1> [<out.md>]"""
import sys, os
import numpy as np, pandas as pd
D = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else None
SP = {'EURUSD': 0.8, 'USDJPY': 1.0, 'GBPUSD': 1.2, 'AUDUSD': 1.2, 'EURGBP': 1.5, 'USDCAD': 1.5, 'USDCHF': 1.5, 'NZDUSD': 1.8, 'EURJPY': 1.8, 'GBPJPY': 2.8}
SLIP = 0.5; W = (1 / 3, 2 / 3)
out = []
def P(s=''): print(s); out.append(s)
def load(s):
    d = pd.read_csv(os.path.join(D, f'ABTG_H1_{s}.csv'), sep=';'); d['t'] = pd.to_datetime(d['date'], format='%Y.%m.%d %H:%M')
    d = d.set_index('t').sort_index(); d = d[(d.index >= '2005-01-01') & (d.index < '2026-11-24') & (d.high >= d.low)]
    return d[['open', 'high', 'low', 'close']]
def h4_of(h1):
    h = h1.resample('4h', origin='start_day').agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last'}).dropna()
    c = h.close; pc = c.shift(1)
    tr = pd.concat([h.high - h.low, (h.high - pc).abs(), (h.low - pc).abs()], axis=1).max(axis=1)
    h['atr'] = tr.rolling(14).mean(); h['e200'] = c.ewm(span=200, adjust=False).mean(); h['e14'] = c.ewm(span=14, adjust=False).mean()
    return h
def run_legs(H1, i0, icancel, iend, side, levels, sl, tp1, tp2, pip, sp):
    """H1 = (T,O,H,L,C) arrays. levels = [A, B]. Ritorna (R_pesato, n_fill)."""
    T, O, Hh, Ll, C = H1; leg = [None, None]; res = [None, None]; spd = sp * pip; long_ = side == 'buy'
    for i in range(i0, iend + 1):
        for k in range(2):
            if res[k] is not None: continue
            if leg[k] is None:
                if i >= icancel: continue
                lv = levels[k]
                hit = (Ll[i] + spd <= lv) if long_ else (Hh[i] >= lv)
                if not hit: continue
                leg[k] = {'ent': lv, 'stage': 0, 'slc': sl, 'p1': 0.0}
                if long_ and Ll[i] <= sl: res[k] = (sl - SLIP * pip - lv) / pip
                elif (not long_) and Hh[i] + spd >= sl: res[k] = (lv - (sl + SLIP * pip)) / pip
                continue
            g = leg[k]; ent = g['ent']
            if long_:
                if Ll[i] <= g['slc']: res[k] = g['p1'] + (0.5 if g['stage'] else 1.0) * ((g['slc'] - SLIP * pip - ent) / pip); continue
                if g['stage'] == 0 and Hh[i] >= tp1: g['stage'] = 1; g['p1'] = 0.5 * (tp1 - ent) / pip; g['slc'] = ent; continue
                if g['stage'] == 1 and Hh[i] >= tp2: res[k] = g['p1'] + 0.5 * (tp2 - ent) / pip
            else:
                if Hh[i] + spd >= g['slc']: res[k] = g['p1'] + (0.5 if g['stage'] else 1.0) * ((ent - (g['slc'] + SLIP * pip)) / pip); continue
                if g['stage'] == 0 and Ll[i] + spd <= tp1: g['stage'] = 1; g['p1'] = 0.5 * (ent - tp1) / pip; g['slc'] = ent; continue
                if g['stage'] == 1 and Ll[i] + spd <= tp2: res[k] = g['p1'] + 0.5 * (ent - tp2) / pip
    for k in range(2):
        if leg[k] is not None and res[k] is None:
            g = leg[k]; ex = C[iend] if long_ else C[iend] + spd
            res[k] = g['p1'] + (0.5 if g['stage'] else 1.0) * (((ex - g['ent']) if long_ else (g['ent'] - ex)) / pip)
    nf = sum(1 for k in range(2) if leg[k] is not None)
    if nf == 0: return None
    R = 0.0
    for k in range(2):
        if leg[k] is None: continue
        sld = abs(leg[k]['ent'] - sl) / pip
        R += W[k] * res[k] / sld
    return R, nf
def scan(pair, var, fam):
    pip = 0.01 if 'JPY' in pair else 0.0001; sp = SP[pair]
    h1 = load(pair); h4 = h1_to_h4 = h4_of(h1)
    T = h1.index.values; O, Hh, Ll, C = h1.open.values, h1.high.values, h1.low.values, h1.close.values; H1 = (T, O, Hh, Ll, C)
    h4i = h4.index; e200 = h4.e200.values; e14 = h4.e14.values; atr = h4.atr.values; hc = h4.close.values; hh = h4.high.values; hl = h4.low.values; ho = h4.open.values
    days = pd.date_range(h1.index[0].normalize() + pd.Timedelta(days=60), h1.index[-1].normalize(), freq='D'); days = [d for d in days if d.weekday() <= 3]
    rows = []; used = set(); dist = var.get('dist', 50) * pip
    for d in days:
        S = d + pd.Timedelta(hours=8); pos = h4i.searchsorted(S, 'left') - 1
        if pos < 210 or h4i[pos] != S - pd.Timedelta(hours=4): continue
        i0 = np.searchsorted(T, np.datetime64(S)); icancel = np.searchsorted(T, np.datetime64(d + pd.Timedelta(hours=18)))
        fri = d + pd.Timedelta(days=4 - d.weekday()); iend = np.searchsorted(T, np.datetime64(fri + pd.Timedelta(hours=20))) - 1
        if i0 >= len(T) or iend <= i0 or icancel >= len(T): continue
        a = atr[pos]; P0 = hc[pos]
        if not np.isfinite(a) or a <= 0: continue
        setups = []
        if fam == 'EMA':
            E = e200[pos]; slope = E - e200[pos - 20]
            long_ = (P0 - E >= dist) and (slope > 0 or not var.get('slope', True)); short_ = (E - P0 >= dist) and (slope < 0 or not var.get('slope', True))
            if long_:
                A = E + 10 * pip; B = E - 10 * pip; sl = B - var.get('atrsl', 2) * a; tp1 = e14[pos]
                if tp1 > A + 5 * pip: setups.append(('buy', [A, B], sl, tp1, tp1 + a))
            if short_:
                A = E - 10 * pip; B = E + 10 * pip; sl = B + var.get('atrsl', 2) * a; tp1 = e14[pos]
                if tp1 < A - 5 * pip: setups.append(('sell', [A, B], sl, tp1, tp1 - a))
        else:
            for i in range(pos - 11, pos):
                if i < 8: continue
                cov = None
                for m in (1, 2):
                    j = i + m
                    if j > pos: break
                    if hh[i + 1:j + 1].max() >= hh[i] and hl[i + 1:j + 1].min() <= hl[i]: cov = j; break
                if cov is None or cov < pos - 5: continue
                if (hh[i] - hl[i]) > 2 * atr[i]: continue
                mv = hc[i - 1] - hc[i - 7]
                if abs(mv) < 1.5 * atr[i]: continue
                down = mv < 0
                if down and not (hl[i] <= hl[i - 6:i].min() and hc[cov] > hc[i]): continue
                if (not down) and not (hh[i] >= hh[i - 6:i].max() and hc[cov] < hc[i]): continue
                key = (pair, h4i[i])
                if key in used: continue
                Hx = max(hh[i], hh[i + 1:cov + 1].max()); Lx = min(hl[i], hl[i + 1:cov + 1].min()); R = Hx - Lx
                if R <= 0: continue
                used.add(key)
                for z1, z2 in ((1.78, 1.88), (2.78, 2.88)):
                    # lato basso: buy limit
                    near = Hx - z1 * R if z1 == 1.78 else Hx - 2.78 * R; far = Hx - z2 * R
                    if P0 - near >= dist:
                        tp2 = Lx
                        tp1 = (Hx - 1.88 * R) if z1 == 2.78 else (near + tp2) / 2
                        if var.get('sl') == '4236': sl = Hx - 4.236 * R
                        else: sl = far - (tp1 - far)
                        if tp1 > far and sl < far: setups.append(('buy', [near, far], sl, tp1, tp2))
                    nearu = Lx + z1 * R; faru = Lx + z2 * R
                    if nearu - P0 >= dist:
                        tp2 = Hx
                        tp1 = (Lx + 1.88 * R) if z1 == 2.78 else (nearu + tp2) / 2
                        if var.get('sl') == '4236': sl = Lx + 4.236 * R
                        else: sl = faru + (faru - tp1)
                        if tp1 < faru and sl > faru: setups.append(('sell', [nearu, faru], sl, tp1, tp2))
        for side, lv, sl, tp1, tp2 in setups:
            r = run_legs(H1, i0, icancel, iend, side, lv, sl, tp1, tp2, pip, sp)
            if r is not None: rows.append((d, pair, r[0]))
    return rows
PERI = [('IS 2005-2015', 2005, 2015, 150), ('OOS 2016-2021', 2016, 2021, 80), ('HO 2022-2026', 2022, 2026, 50)]
def pf(x):
    x = np.array(x)
    if len(x) == 0: return 0, 0.0, 0.0
    w = x[x > 0].sum(); l = -x[x < 0].sum(); return len(x), (w / l if l > 0 else 99.0), (x > 0).mean() * 100
FAMS = {
 'EMA': [('Media 200 PRIMARIA (50 pip, 2 ATR, filtro pendenza)', {}), ('SL 1 ATR', {'atrsl': 1}), ('distanza 70 pip', {'dist': 70}), ('senza filtro pendenza', {'slope': False})],
 'FIBO': [('Fibo H4 PRIMARIA (50 pip, SL 1:1)', {}), ('SL al livello 4,236', {'sl': '4236'}), ('distanza 35 pip', {'dist': 35})]}
PAIRS = list(SP)
verd = []
P('| strategia / variante | periodo | setup | PF (R) | % vincenti | R medio | R/anno |'); P('|---|---|---|---|---|---|---|')
perpair = {}
for fam, vars_ in FAMS.items():
    for nome, var in vars_:
        rows = []
        for p in PAIRS:
            r = scan(p, var, fam); rows += r
            if var == {}: perpair[(fam, p)] = r
        df = pd.DataFrame(rows, columns=['d', 'p', 'R']); df['y'] = df.d.dt.year; res = {}
        for pn, y0, y1, nmin in PERI:
            x = df[(df.y >= y0) & (df.y <= y1)].R.tolist(); n, f, w = pf(x); res[pn] = (n, f, nmin)
            P(f'| {nome} | {pn} | {n} | {f:.2f} | {w:.0f} | {np.mean(x) if x else 0:.2f} | {sum(x)/(y1-y0+1):.1f} |')
        i, o, h = res['IS 2005-2015'], res['OOS 2016-2021'], res['HO 2022-2026']
        ok = i[0] >= i[2] and i[1] >= 1.3 and o[0] >= o[2] and o[1] > 1.2 and h[0] >= h[2] and h[1] > 1.0
        verd.append(f'- {nome}: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('CANDIDATA' if ok else 'non passa'))
P(); P('PF(R) per coppia, sistema primario, tutto il periodo (descrittivo):')
for fam in FAMS:
    P(f'  {fam}: ' + ', '.join(f'{p} {pf([r[2] for r in perpair[(fam, p)]])[1]:.2f} (n={len(perpair[(fam, p)])})' for p in PAIRS))
P(); P('VERDETTO (soglie dei criteri):'); [P(v) for v in verd]
if OUT: open(OUT, 'w').write('\n'.join(out) + '\n')
