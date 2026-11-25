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
def action_exp_old(row):
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

def action_exp(row, D=None):
    a = row.t + pd.Timedelta(minutes=D)
    return a, a + pd.Timedelta(minutes=195 if row.tipo == 'ECB' else 65)

PER = {'ECB': [('IS', 2013, 2020), ('OOS', 2021, 2024), ('HO', 2025, 2026)], 'FOMC': [('IS', 2016, 2021), ('OOS', 2022, 2024), ('HO', 2025, 2026)]}
GATE = {'ECB': (50, 25), 'FOMC': (30, 20)}
def pf(x):
    x = np.array(x)
    if len(x) == 0: return 0, 0.0
    l = -x[x < 0].sum(); return len(x), (x[x > 0].sum() / l if l > 0 else 99.0)
out = ['| tipo | coppia | D min | IS PF (n) | OOS PF (n) | HO PF (n) | passa |', '|---|---|---|---|---|---|---|']
ok = {}
for tipo in ['ECB', 'FOMC']:
    for sym in SYMS:
        m1 = load(sym)
        for D in (10, 25, 40, 70, 100):
            rows = []
            for r in ev[ev.tipo == tipo].itertuples():
                a, e = action_exp(r, D); st, p = simula(m1, sym, tipo, a, e, False)
                if st in ('ok', 'dbl'): rows.append((r.t.year, p))
            df = pd.DataFrame(rows, columns=['y', 'p']); rr = []
            for nome, y0, y1 in PER[tipo]:
                rr.append(pf(df[(df.y >= y0) & (df.y <= y1)].p.tolist()))
            (ni, pi), (no, po), (nh, ph) = rr
            g = ni >= GATE[tipo][0] and pi >= 1.3 and no >= GATE[tipo][1] and po > 1.2 and nh > 0 and ph > 1.0
            ok[(tipo, sym, D)] = g
            out.append(f'| {tipo} | {sym} | {D} | {pi:.2f} ({ni}) | {po:.2f} ({no}) | {ph:.2f} ({nh}) | {"SI" if g else "no"} |')
out.append('')
out.append('Plateau (>=3 orari consecutivi che passano nella stessa coppia e tipo):')
Ds = (10, 25, 40, 70, 100); trov = False
for tipo in ['ECB', 'FOMC']:
    for sym in SYMS:
        f = [ok[(tipo, sym, D)] for D in Ds]
        pl = any(f[i] and f[i+1] and f[i+2] for i in range(3))
        out.append(f'- {tipo} {sym}: passano {sum(f)}/5 orari -> ' + ('PLATEAU = CANDIDATA' if pl else 'nessun plateau')); trov |= pl
out.append(''); out.append('ESITO V2: ' + ('almeno una candidata' if trov else 'nessuna candidata'))
print('\n'.join(out))
if os.environ.get('POSTNEWS_OUT'): open(os.environ['POSTNEWS_OUT'], 'w').write('\n'.join(out) + '\n')
