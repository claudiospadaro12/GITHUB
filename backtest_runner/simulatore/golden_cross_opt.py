#!/usr/bin/env python3
"""Ottimizzazione Golden Cross HA (famiglia A) coi cancelli della campagna di Wim. Criteri: report/GOLDEN_CROSS_OTTIMIZZAZIONE_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I golden_cross_opt.py <cartella_H1> [<out.md>]"""
import sys, os, itertools, random
HERE = os.path.dirname(os.path.abspath(__file__)); D_ARG = sys.argv[1]; OUTP = sys.argv[2] if len(sys.argv) > 2 else None
sys.argv = [sys.argv[0], D_ARG]
src = open(os.path.join(HERE, 'golden_cross_fx.py')).read().split("PERI = [")[0]
src = src.replace("d.index < '2026-11-24'", "d.index < ENDD").replace("<= 0.25", "<= 0.25").replace("((c - e21) <= d.atr)", "((c - e21) <= DIST * d.atr)").replace("((e21 - c) <= d.atr)", "((e21 - c) <= DIST * d.atr)")
src = src.replace("sl = min(l[i - 2:i + 1]) - 0.1 * atr[i]; R = entry - sl", "sl = (min(l[i - 2:i + 1]) - 0.1 * atr[i]) if STOP == 'S' else entry - STOP * atr[i]; R = entry - sl")
src = src.replace("sl = max(h[i - 2:i + 1]) + 0.1 * atr[i]; R = sl - ref", "sl = (max(h[i - 2:i + 1]) + 0.1 * atr[i]) if STOP == 'S' else ref + STOP * atr[i]; R = sl - ref")
src = src.replace("if not (0.3 * atr[i] <= R <= 2 * atr[i]): i += 1; continue", "if STOP == 'S' and not (0.3 * atr[i] <= R <= 2 * atr[i]): i += 1; continue")
src = src.replace("OUT = sys.argv[2] if len(sys.argv) > 2 else None", "OUT = None")
DIST = 1.0; STOP = 'S'; ENDD = '2016-01-01'
exec(src)
P = lambda s='': (print(s, flush=True), out.append(s))
ADX = [15, 20, 25, 30]; DISTS = [0.5, 1.0, 1.5]; KS = [1.0, 1.5, 2.0, 3.0]; STOPS = ['S', 1.5, 2.5]; EXS = [True, False]; TFS = ['H1', 'H4']
grid = list(itertools.product(TFS, ADX, DISTS, KS, STOPS, EXS)); P(f'Combinazioni (tentativi): {len(grid)}')
def run_combo(cfg, end):
    global ENDD, DIST, STOP
    tf, adx, dist, k, stop, ex = cfg; DIST = dist; STOP = stop; rows = []
    for p in SP:
        if p == 'XAUUSD': continue
        key = (p, tf, end)
        if key not in cache: ENDD = end; cache[key] = indicators(load(p, tf))
        d = cache[key]; L, S = signals_A(d, adx); rows += trade_loop(d, p, L, S, k, ex)
    return pd.DataFrame(rows, columns=['t', 'R']).sort_values('t')
cache = {}
def metrics(df, y0, y1):
    x = df[(df.t.dt.year >= y0) & (df.t.dt.year <= y1)]; r = x.R.values
    if len(r) == 0: return dict(n=0, pf=0, net=0, pos=0, dd=0)
    w = r[r > 0].sum(); l = -r[r < 0].sum(); cum = np.cumsum(r); dd = float((np.maximum.accumulate(cum) - cum).max())
    yr = x.groupby(x.t.dt.year).R.sum(); return dict(n=len(r), pf=(w / l if l > 0 else 99), net=float(r.sum()), pos=float((yr > 0).mean()), dd=dd)
IS = {}
import time; t0 = time.time()
for ci, cfg in enumerate(grid):
    df = run_combo(cfg, '2016-01-01'); IS[cfg] = (metrics(df, 2005, 2015))
    if ci % 96 == 0: P(f'  ... {ci}/{len(grid)} ({time.time()-t0:.0f}s)')
pfs = np.array([m['pf'] for m in IS.values() if m['n'] >= 300]); P(); P(f'DISTRIBUZIONE PF IN CAMPIONE (IS 2005-2015), combinazioni con >= 300 operazioni: {len(pfs)}')
P(f'  massimo {pfs.max():.2f}, 90 percentile {np.percentile(pfs,90):.2f}, mediana {np.median(pfs):.2f}, minimo {pfs.min():.2f}')
elig = [c for c, m in IS.items() if m['pf'] >= 1.30 and m['n'] >= 300 and m['net'] > 0 and m['pos'] >= 0.6]
P(f'IDONEI IS (PF >= 1,30, n >= 300, profitto > 0, anni positivi >= 60%): {len(elig)} su {len(grid)}')
cands = []
if elig:
    rnd = random.Random(2026); best = sorted(elig, key=lambda c: -IS[c]['net'])[:4]; rest = [c for c in elig if c not in best]
    div = []
    for _ in range(3):
        pool = [c for c in rest if c not in div]
        if not pool: break
        ref = best + div; div.append(max(pool, key=lambda c: min(abs(IS[c]['pf'] - IS[r]['pf']) + abs(IS[c]['dd'] - IS[r]['dd']) / 10 + abs(IS[c]['n'] - IS[r]['n']) / 500 for r in ref)))
    left = [c for c in rest if c not in div]; rnd.shuffle(left); cands = best + div + left[:3]; cands = cands[:10]
    P(f'Selezionati {len(cands)} candidati (40% migliori, 30% diversi, 30% a sorte)')
    for c in cands:
        m1 = metrics(run_combo(c, '2027-01-01') if False else None, 2016, 2021) if False else None
    P(); P('| config (TF, ADX, dist, target, stop, exit EMA21) | IS PF | IS n | V1 OOS PF | V1 n | V1 anni non neg. | V2 varianti PF>1 IS+V1 | V1 | V2 | V4 hold-out |'); P('|---|---|---|---|---|---|---|---|---|---|')
    def nbrs(c):
        tf, adx, dist, k, stop, ex = c; res = []
        for lst, idx in ((ADX, 1), (DISTS, 2), (KS, 3), (STOPS, 4)):
            i = lst.index(c[idx])
            for j in (i - 1, i + 1):
                if 0 <= j < len(lst): n = list(c); n[idx] = lst[j]; res.append(tuple(n))
        return res
    for c in cands:
        full = run_combo(c, '2027-01-01'); m1 = metrics(full, 2016, 2021); yr = full[(full.t.dt.year >= 2016) & (full.t.dt.year <= 2021)].groupby(full.t.dt.year).R.sum()
        v1 = m1['pf'] >= 1.20 and m1['net'] > 0 and m1['n'] >= 150 and (yr >= 0).mean() >= 0.6
        nb = nbrs(c); ok = 0
        for n in nb:
            if n in IS: pis = IS[n]['pf']
            else: pis = metrics(run_combo(n, '2016-01-01'), 2005, 2015)['pf']
            pv = metrics(run_combo(n, '2027-01-01'), 2016, 2021)['pf']; ok += (pis > 1.0 and pv > 1.0)
        v2 = ok / max(1, len(nb)) >= 0.7; m4 = metrics(full, 2022, 2026); v4 = m4['pf'] > 1.0 and m4['n'] >= 100 if (v1 and v2) else None
        P(f'| {c} | {IS[c]["pf"]:.2f} | {IS[c]["n"]} | {m1["pf"]:.2f} | {m1["n"]} | {(yr>=0).mean()*100:.0f}% | {ok}/{len(nb)} | {"SI" if v1 else "no"} | {"SI" if v2 else "no"} | ' + ('non aperto' if v4 is None else f'PF {m4["pf"]:.2f} (n={m4["n"]}) {"SI" if v4 else "no"}') + ' |')
P(); P('ESITO: ' + ('nessun candidato: zero combinazioni idonee in campione.' if not elig else 'vedi tabella.'))
if OUTP: open(OUTP, 'w').write('\n'.join(out) + '\n')
