#!/usr/bin/env python3
"""Controllo ingressi casuali di GoldenZoe (stessa frequenza, stesse uscite): scrive null.csv con colonna pf_null (PF netto su tutto il periodo, 100 repliche).
Uso: python3 goldenzoe_null.py <ABTG_H1_XAUUSD.csv> <out.csv>"""
import sys, numpy as np, pandas as pd
src, out = sys.argv[1], sys.argv[2]
d = pd.read_csv(src, sep=';'); d['t'] = pd.to_datetime(d['date'], format='%Y.%m.%d %H:%M'); d = d.set_index('t').sort_index()[['open', 'high', 'low', 'close']]
r = d.resample('4h', origin='start_day').agg({'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last'}).dropna()
O, H, L, C = [r[k].values for k in ('open', 'high', 'low', 'close')]; T = r.index; n = len(C)
pc = r.close.shift(1); tr = pd.concat([r.high - r.low, (r.high - pc).abs(), (r.low - pc).abs()], axis=1).max(axis=1); atr = tr.ewm(alpha=1 / 14, adjust=False).mean().values
hh = pd.Series(H).rolling(55).max().shift(1).values
def run(sig, MI=3.0, MT=3.0):
    rows = []; pos = 0
    for i in range(120, n - 1):
        if pos == 0:
            if not sig[i] or np.isnan(atr[i]): continue
            ent = O[i + 1]; risk = MI * atr[i]; pos = 1; stop = ent - risk; ext = ent; st = i + 1
        if pos == 1 and i >= st:
            if L[i] <= stop:
                px = min(O[i], stop); days = (T[i] - T[st]).total_seconds() / 86400
                rows.append((px - ent) / risk - (0.35 + 0.055 / 360 * days * ent) / risk); pos = 0; continue
            ext = max(ext, H[i]); stop = max(stop, ext - MT * atr[i])
    return np.array(rows)
pf = lambda a: a[a > 0].sum() / -a[a < 0].sum()
fr = len(run(C > hh)) / n; rng = np.random.default_rng(20261128)
pd.DataFrame({'pf_null': [pf(run(rng.random(n) < fr)) for _ in range(100)]}).to_csv(out, index=False); print('null ->', out)
