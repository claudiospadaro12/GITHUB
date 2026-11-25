#!/usr/bin/env python3
"""Media 200 rimbalzo corto (TP 10 pip). Criteri: report/EMA200_RIMBALZO_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I ema200_rimbalzo.py <cartella_H1> [<out.md>]"""
import sys, os
sys.argv = [sys.argv[0]] + sys.argv[1:]
src = open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'fibo_ema200_fx.py')).read().split("def run_legs")[0]
exec(src)
PERI = [('IS 2005-2015', 2005, 2015, 150), ('OOS 2016-2021', 2016, 2021, 80), ('HO 2022-2026', 2022, 2026, 50)]
def pf(x):
    x = np.array(x)
    if len(x) == 0: return 0, 0.0, 0.0
    w = x[x > 0].sum(); l = -x[x < 0].sum(); return len(x), (w / l if l > 0 else 99.0), (x > 0).mean() * 100
def run10(H1, i0, icancel, iend, side, levels, sl, tpp, pip, sp, opt):
    T, O, Hh, Ll, C = H1; spd = sp * pip; lg = side == 'buy'; fl = [None, None]; res = [None, None]
    for i in range(i0, iend + 1):
        for k in range(2):
            if res[k] is not None: continue
            lv = levels[k]; tp = lv + tpp * pip if lg else lv - tpp * pip
            if fl[k] is None:
                if i >= icancel: continue
                hit = (Ll[i] + spd <= lv) if lg else (Hh[i] >= lv)
                if not hit: continue
                fl[k] = True
                if lg and Ll[i] <= sl: res[k] = (sl - SLIP * pip - lv) / pip; continue
                if (not lg) and Hh[i] + spd >= sl: res[k] = (lv - (sl + SLIP * pip)) / pip; continue
                if opt == 1 and ((lg and Hh[i] >= tp) or ((not lg) and Ll[i] + spd <= tp)): res[k] = tpp
                if opt == 2 and ((lg and C[i] >= tp) or ((not lg) and C[i] + spd <= tp)): res[k] = tpp
                continue
            if lg:
                if Ll[i] <= sl: res[k] = (sl - SLIP * pip - lv) / pip
                elif Hh[i] >= tp: res[k] = tpp
            else:
                if Hh[i] + spd >= sl: res[k] = (lv - (sl + SLIP * pip)) / pip
                elif Ll[i] + spd <= tp: res[k] = tpp
    for k in range(2):
        if fl[k] is not None and res[k] is None:
            ex = C[iend] if lg else C[iend] + spd; res[k] = ((ex - levels[k]) if lg else (levels[k] - ex)) / pip
    if all(f is None for f in fl): return None
    R = 0.0; wins = []; 
    for k in range(2):
        if fl[k] is None: continue
        R += W[k] * res[k] / (abs(levels[k] - sl) / pip); wins.append(res[k] >= tpp - 1e-9)
    return R, wins
def scan10(pair, var, opt):
    pip = 0.01 if 'JPY' in pair else 0.0001; sp = SP[pair]; h1 = load(pair); h4 = h4_of(h1)
    T = h1.index.values; H1 = (T, h1.open.values, h1.high.values, h1.low.values, h1.close.values)
    h4i = h4.index; e200 = h4.e200.values; atr = h4.atr.values; hc = h4.close.values
    days = pd.date_range(h1.index[0].normalize() + pd.Timedelta(days=60), h1.index[-1].normalize(), freq='D'); days = [d for d in days if d.weekday() <= 3]
    rows = []; legs = []; tpp = var.get('tp', 10)
    for d in days:
        S = d + pd.Timedelta(hours=8); pos = h4i.searchsorted(S, 'left') - 1
        if pos < 210 or h4i[pos] != S - pd.Timedelta(hours=4): continue
        i0 = np.searchsorted(T, np.datetime64(S)); ic = np.searchsorted(T, np.datetime64(d + pd.Timedelta(hours=18)))
        fri = d + pd.Timedelta(days=4 - d.weekday()); ie = np.searchsorted(T, np.datetime64(fri + pd.Timedelta(hours=20))) - 1
        if i0 >= len(T) or ie <= i0 or ic >= len(T): continue
        a = atr[pos]; P0 = hc[pos]; E = e200[pos]; sl_ = e200[pos] - e200[pos - 20]
        if not np.isfinite(a) or a <= 0: continue
        slpips = var.get('slpips'); sld = slpips * pip if slpips else var.get('atrsl', 2) * a
        if P0 - E >= 50 * pip and sl_ > 0: side = 'buy'; A, B = E + 10 * pip, E - 10 * pip; sl = B - sld
        elif E - P0 >= 50 * pip and sl_ < 0: side = 'sell'; A, B = E - 10 * pip, E + 10 * pip; sl = B + sld
        else: continue
        r = run10(H1, i0, ic, ie, side, [A, B], sl, tpp, pip, sp, opt)
        if r is not None: rows.append((d, pair, r[0])); legs += r[1]
    return rows, legs
VARS = [('PRIMARIA (TP 10, SL 2 ATR)', {}), ('TP 15 pip', {'tp': 15}), ('SL 1 ATR', {'atrsl': 1}), ('SL fisso 30 pip', {'slpips': 30})]
verd = []
P('| variante | limite | periodo | setup | PF (R) | R medio | R/anno |'); P('|---|---|---|---|---|---|---|')
for nome, var in VARS:
    for opt, lim in ((0, 'pessimistico'), (2, 'rigoroso (chiusura oltre TP)'), (1, 'ottimistico')):
        rows = []; legs = []
        for p in SP:
            r, l = scan10(p, var, opt); rows += r; legs += l
        df = pd.DataFrame(rows, columns=['d', 'p', 'R']); df['y'] = df.d.dt.year; res = {}
        for pn, y0, y1, nmin in PERI:
            x = df[(df.y >= y0) & (df.y <= y1)].R.tolist(); n, f, w = pf(x); res[pn] = (n, f, nmin)
            P(f'| {nome} | {lim} | {pn} | {n} | {f:.2f} | {np.mean(x) if x else 0:.3f} | {sum(x)/(y1-y0+1):.1f} |')
        i, o, h = res['IS 2005-2015'], res['OOS 2016-2021'], res['HO 2022-2026']
        ok = i[0] >= i[2] and i[1] >= 1.3 and o[0] >= o[2] and o[1] > 1.2 and h[0] >= h[2] and h[1] > 1.0
        verd.append(f'- {nome} [{lim}]: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('PASSA' if ok else 'non passa') + f'; ordini che rimbalzano di {var.get("tp",10)} pip: {np.mean(legs)*100:.0f}% (su {len(legs)})')
P(); P('VERDETTO:'); [P(v) for v in verd]
if len(sys.argv) > 2: open(sys.argv[2], 'w').write('\n'.join(out) + '\n')
