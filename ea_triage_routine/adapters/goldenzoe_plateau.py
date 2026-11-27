#!/usr/bin/env python3
"""Plateau di GoldenZoe: 27 combinazioni N in {45,55,65} x stop iniziale in {2,5; 3; 3,5} x chandelier in {2,5; 3; 3,5} (centro = 55/3/3).
Uso: python3 goldenzoe_plateau.py <ABTG_H1_XAUUSD.csv> <out.csv>"""
import sys, os, itertools, numpy as np, pandas as pd
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import goldenzoe_trades as gz
src, out = sys.argv[1], sys.argv[2]; rows = []
pf = lambda x: float(x[x > 0].sum() / -x[x < 0].sum()) if (x < 0).any() else float('inf')
for N, mi, mt in itertools.product((45, 55, 65), (2.5, 3.0, 3.5), (2.5, 3.0, 3.5)):
    d = gz.run(src, N, mi, mt); net = d.R_gross - d.cost_R; cut = d.ts_open.quantile(0.6); isx = d.ts_open <= cut
    rows.append(dict(config='N%d_mi%g_mt%g' % (N, mi, mt), centro=(N, mi, mt) == (55, 3.0, 3.0), n=len(d), pf_netto=pf(net), pf_is=pf(net[isx]), pf_oos=pf(net[~isx])))
pd.DataFrame(rows).to_csv(out, index=False); print('plateau:', len(rows), 'combinazioni ->', out)
