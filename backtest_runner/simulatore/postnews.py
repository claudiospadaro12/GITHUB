#!/usr/bin/env python3
"""Post News BCE/FOMC: simulazione su M1 attorno agli eventi. Criteri: report/POSTNEWS_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I postnews.py <eventi.csv> <cartella_csv> [<cartella_csv2> ...]  (ABTG_EV_<SIM>_<ANNO>.csv)"""
import sys, glob, os, datetime as dt
import numpy as np, pandas as pd
from zoneinfo import ZoneInfo
EV = sys.argv[1]; DIRS = sys.argv[2:]
SYMS = ['EURUSD','GBPUSD','USDJPY','EURJPY']
BUF, SL, TP, SLIP, TRG, TRN = 3.0, 25.0, 50.0, 0.5, 25.0, 15.0
ROME = ZoneInfo('Europe/Rome')
ev = pd.read_csv(EV, sep=';'); ev['t'] = pd.to_datetime(ev['datetime_server'], format='%Y.%m.%d %H:%M')
def action_exp(row):
    te = row.t
    if row.tipo == 'ECB':
        d = te.normalize(); loc = dt.datetime(d.year, d.month, d.day, 12, 0, tzinfo=ROME)
        summer = loc.utcoffset() == dt.timedelta(hours=2)
        a = d + pd.Timedelta(hours=16) - pd.Timedelta(hours=1 if summer else 0)
        return a, a + pd.Timedelta(minutes=195)
    a = te + pd.Timedelta(minutes=10); return a, a + pd.Timedelta(minutes=65)
def load(sym):
    fs = []
    for D in DIRS: fs += glob.glob(os.path.join(D, f'ABTG_EV_{sym}_*.csv'))
    df = pd.concat([pd.read_csv(f, sep=';') for f in sorted(fs)])
    df['t'] = pd.to_datetime(df['time'], format='%Y.%m.%d %H:%M'); df = df.drop_duplicates('t').set_index('t').sort_index()
    return df
def simula(m1, sym, tipo, a, e, rev):
    pip = 0.01 if 'JPY' in sym else 0.0001; pt = pip / 10
    r = m1.loc[a - pd.Timedelta(minutes=10): a - pd.Timedelta(minutes=1)]
    if len(r) < 8: return 'nodata', None
    hi, lo = r.high.max(), r.low.min()
    if a not in m1.index: return 'nodata', None
    o = m1.loc[a, 'open']; sp0 = m1.loc[a, 'spread'] * pt
    buy, sell = hi + BUF * pip, lo - BUF * pip
    okb, oks = buy > o + sp0, sell < o
    bars = m1.loc[a: e - pd.Timedelta(minutes=1)]
    if len(bars) < 5: return 'nodata', None
    H, L, O, C, S = bars.high.values, bars.low.values, bars.open.values, bars.close.values, bars.spread.values * pt
    pos = None
    for i in range(len(bars)):
        sp = S[i]; tb = okb and H[i] + sp >= buy; ts = oks and L[i] <= sell
        if pos is None:
            if tb and ts: return 'dbl', -(SL + SLIP + SLIP + sp / pip)
            if tb or ts:
                up = tb                       # direzione di rottura
                lng = (not up) if rev else up
                nom = (buy if up else sell) + (sp if (lng and not up) else 0) - (sp if ((not lng) and up) else 0)
                ent = nom + (SLIP * pip if lng else -SLIP * pip)
                d = 1 if lng else -1; slp = nom - d * SL * pip; tpp = nom + d * TP * pip
                # barra di scatto: solo SL (conservativo)
                if (lng and L[i] <= slp) or ((not lng) and H[i] + sp >= slp):
                    return 'ok', (d * ((slp - d * SLIP * pip) - ent)) / pip
                pos = (d, ent, slp, tpp, nom); 
            continue
        d, ent, slp, tpp, nom = pos
        if d == 1:
            if L[i] <= slp: return 'ok', ((slp - SLIP * pip) - ent) / pip
            if H[i] >= tpp: return 'ok', (tpp - ent) / pip
            if tipo == 'ECB' and (H[i] - nom) / pip >= TRG: slp = max(slp, nom - TRN * pip)
        else:
            if H[i] + sp >= slp: return 'ok', (ent - (slp + SLIP * pip)) / pip
            if L[i] + sp <= tpp: return 'ok', (ent - tpp) / pip
            if tipo == 'ECB' and (nom - (L[i] + sp)) / pip >= TRG: slp = min(slp, nom + TRN * pip)
        pos = (d, ent, slp, tpp, nom)
    if pos is None: return 'nofill', 0.0
    d, ent, slp, tpp, nom = pos
    ex = C[-1] + (S[-1] if d == -1 else 0)
    return 'ok', d * (ex - ent) / pip
PER = {'ECB': [('IS', 2013, 2020), ('OOS', 2021, 2024), ('HO', 2025, 2026)], 'FOMC': [('IS', 2016, 2021), ('OOS', 2022, 2024), ('HO', 2025, 2026)]}
GATE = {'ECB': (50, 25), 'FOMC': (30, 20)}
out = []
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); out.append(s)
def stat(x):
    x = np.array(x); n = len(x)
    if n == 0: return 'n=0'
    w = x[x > 0].sum(); l = -x[x < 0].sum(); pf = w / l if l > 0 else float('inf')
    return n, pf, (x > 0).mean() * 100, x.mean()
P('| cella | periodo | operazioni | PF | %vincenti | pip medi | pip/anno | % anno a 3%/50pip |'); P('|---|---|---|---|---|---|---|---|')
res = {}; extra = []
for sym in SYMS:
    m1 = load(sym)
    for tipo in ['ECB', 'FOMC']:
        for rev in (False, True):
            rows = []
            for r in ev[ev.tipo == tipo].itertuples():
                a, e = action_exp(r); st, p = simula(m1, sym, tipo, a, e, rev)
                rows.append((r.t.year, st, p))
            df = pd.DataFrame(rows, columns=['y', 'st', 'p'])
            if not rev: extra.append(f'{tipo} {sym}: eventi {len(df)}, senza dati {int((df.st=="nodata").sum())}, doppio scatto {int((df.st=="dbl").sum())}, nessuno scatto {int((df.st=="nofill").sum())}')
            for nome, y0, y1 in PER[tipo]:
                x = df[(df.y >= y0) & (df.y <= y1) & df.st.isin(['ok', 'dbl'])].p.tolist()
                s = stat(x); anni = y1 - y0 + 1
                tag = f'{tipo} {sym}' + (' INVERSA' if rev else '')
                if isinstance(s, str): P(f'| {tag} | {nome} {y0}-{y1} | 0 | - | - | - | - | - |'); res[(tipo, sym, rev, nome)] = (0, 0); continue
                n, pf, wr, mn = s; ppa = sum(x) / anni
                P(f'| {tag} | {nome} {y0}-{y1} | {n} | {pf:.2f} | {wr:.0f} | {mn:.1f} | {ppa:.0f} | {ppa/50*3:.1f} |'); res[(tipo, sym, rev, nome)] = (n, pf)
P(''); P('Eventi per cella:'); [P('- ' + x) for x in extra]
P(''); P('VERDETTO (criteri: IS PF>=1,3 con n minimo, OOS PF>1,2 con n minimo, HO PF>1,0):')
for tipo in ['ECB', 'FOMC']:
    for sym in SYMS:
        i, o, h = res[(tipo, sym, False, 'IS')], res[(tipo, sym, False, 'OOS')], res[(tipo, sym, False, 'HO')]
        ok = i[0] >= GATE[tipo][0] and i[1] >= 1.3 and o[0] >= GATE[tipo][1] and o[1] > 1.2 and h[0] > 0 and h[1] > 1.0
        P(f'- {tipo} {sym}: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('CANDIDATA' if ok else 'non passa'))
if os.environ.get('POSTNEWS_OUT'): open(os.environ['POSTNEWS_OUT'], 'w').write('\n'.join(out) + '\n')
