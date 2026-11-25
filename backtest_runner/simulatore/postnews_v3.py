#!/usr/bin/env python3
"""Post News V3 FEDELE al corso (lezioni 4-10). Criteri: report/POSTNEWS_V3_FEDELE_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I postnews_v3.py <eventi.csv> <cartella_csv> [...]   (ABTG_EV_<SIM>*.csv, finestre lunghe)"""
import sys, glob, os, datetime as dt
import numpy as np, pandas as pd
from zoneinfo import ZoneInfo
EV = sys.argv[1]; DIRS = sys.argv[2:]
ROME = ZoneInfo('Europe/Rome')
BUYOFF, SELLOFF, SL, TP, SLIP, TRG, TRN = 3.0, 2.0, 25.0, 50.0, 0.5, 25.0, 15.0
ev = pd.read_csv(EV, sep=';'); ev['t'] = pd.to_datetime(ev['datetime_server'], format='%Y.%m.%d %H:%M')
def shift(d):  # ora italiana - ora server (0 inverno, 1 estate)
    return int(dt.datetime(d.year, d.month, d.day, 12, 0, tzinfo=ROME).utcoffset().total_seconds() // 3600) - 1
def srv(day, h, m):  # ora italiana h:m del giorno -> ora server
    d = pd.Timestamp(day).normalize(); return d + pd.Timedelta(hours=h, minutes=m) - pd.Timedelta(hours=shift(d))
def load(sym):
    fs = []
    for D in DIRS: fs += glob.glob(os.path.join(D, f'ABTG_EV_{sym}*.csv'))
    df = pd.concat([pd.read_csv(f, sep=';') for f in sorted(fs)])
    df['t'] = pd.to_datetime(df['time'], format='%Y.%m.%d %H:%M'); return df.drop_duplicates('t').set_index('t').sort_index()
def leg(bars, side, level, sp0, act, exp, fclose, pip, trail):
    """bars: DataFrame M1 da act in poi. Ritorna (esito, pip) con esito 'nofill' o 'ok'."""
    pt = pip / 10
    T = bars.index.values; H = bars.high.values; L = bars.low.values; O = bars.open.values; C = bars.close.values; S = bars.spread.values * pt
    exp64 = np.datetime64(exp); fc64 = np.datetime64(fclose); long_ = side == 'buy'
    pos = False
    for i in range(len(bars)):
        sp = S[i]
        if not pos:
            if T[i] >= exp64: return 'nofill', 0.0
            hit = (H[i] + sp >= level) if long_ else (L[i] <= level)
            if not hit: continue
            nom = level; ent = nom + SLIP * pip if long_ else nom - SLIP * pip
            slp = nom - SL * pip if long_ else nom + SL * pip; tpp = nom + TP * pip if long_ else nom - TP * pip
            if long_ and L[i] <= slp: return 'ok', ((slp - SLIP * pip) - ent) / pip
            if (not long_) and H[i] + sp >= slp: return 'ok', (ent - (slp + SLIP * pip)) / pip
            pos = True; continue
        if T[i] >= fc64:
            ex = O[i] if long_ else O[i] + sp
            return 'ok', ((ex - ent) if long_ else (ent - ex)) / pip
        if long_:
            if L[i] <= slp: return 'ok', ((slp - SLIP * pip) - ent) / pip
            if H[i] >= tpp: return 'ok', (tpp - ent) / pip
            if trail and (H[i] - nom) / pip >= TRG: slp = max(slp, nom - TRN * pip)
        else:
            if H[i] + sp >= slp: return 'ok', (ent - (slp + SLIP * pip)) / pip
            if L[i] + sp <= tpp: return 'ok', (ent - tpp) / pip
            if trail and (nom - (L[i] + sp)) / pip >= TRG: slp = min(slp, nom + TRN * pip)
    if not pos: return 'nofill', 0.0
    ex = C[-1] if long_ else C[-1] + S[-1]
    return 'ok_fine_dati', ((ex - ent) if long_ else (ent - ex)) / pip
def run(sym, tipo, trail):
    m1 = load(sym); pip = 0.01 if 'JPY' in sym else 0.0001; rows = []
    for r in ev[ev.tipo == tipo].itertuples():
        te = r.t; d = te.normalize()
        if tipo == 'ECB': r0, r1, act = te + pd.Timedelta(minutes=5), te + pd.Timedelta(minutes=15), te + pd.Timedelta(minutes=15); exp = srv(d, 18, 15)
        else: r0, r1, act = te, te + pd.Timedelta(minutes=10), te + pd.Timedelta(minutes=10); exp = te + pd.Timedelta(minutes=75)
        fri = d + pd.Timedelta(days=(4 - d.weekday()) % 7 if d.weekday() <= 4 else 0); fclose = srv(fri, 22, 50)
        rng = m1.loc[r0:r1 - pd.Timedelta(minutes=1)]
        if len(rng) < 8 or act not in m1.index: rows.append((te.year, 'nodata', 0, 0, 0)); continue
        o = m1.loc[act, 'open']; sp0 = m1.loc[act, 'spread'] * pip / 10
        buy = rng.high.max() + BUYOFF * pip; sell = rng.low.min() - SELLOFF * pip
        bars = m1.loc[act:fclose]; res = []
        if buy > o + sp0: res.append(leg(bars, 'buy', buy, sp0, act, exp, fclose, pip, trail))
        if sell < o: res.append(leg(bars, 'sell', sell, sp0, act, exp, fclose, pip, trail))
        fills = [x for x in res if x[0].startswith('ok')]
        rows.append((te.year, 'ok', len(fills), sum(x[1] for x in fills), [x[1] for x in fills]))
    return rows
PER = {'ECB': [('IS', 2013, 2020), ('OOS', 2021, 2024), ('HO', 2025, 2026)], 'FOMC': [('IS', 2016, 2021), ('OOS', 2022, 2024), ('HO', 2025, 2026)]}
GATE = {'ECB': (50, 25, 15), 'FOMC': (30, 20, 15)}
CELLE = [('ECB', 'EURJPY', True, 'BCE EURJPY (con trailing, PRIMARIA)'), ('FOMC', 'EURUSD', False, 'FOMC EURUSD (PRIMARIA)'), ('ECB', 'EURJPY', False, 'BCE EURJPY senza trailing (sensibilita)')]
out = []
def P(s=''): print(s); out.append(s)
P('| cella | periodo | eventi | operazioni | PF | % vincenti | pip medi/op. | pip/anno | % anno a 3%/50pip |'); P('|---|---|---|---|---|---|---|---|---|')
verd = []
for tipo, sym, trail, nome in CELLE:
    rows = run(sym, tipo, trail); res = {}
    for pn, y0, y1 in PER[tipo]:
        legs = [p for (y, st, n, s, pl) in rows if st == 'ok' and y0 <= y <= y1 for p in pl]
        evs = [s for (y, st, n, s, pl) in rows if st == 'ok' and y0 <= y <= y1 and n > 0]; ne = sum(1 for (y, st, n, s, pl) in rows if st == 'ok' and y0 <= y <= y1)
        x = np.array(legs); anni = y1 - y0 + 1
        if len(x) == 0: P(f'| {nome} | {pn} {y0}-{y1} | {ne} | 0 | - | - | - | - | - |'); res[pn] = (0, 0); continue
        w = x[x > 0].sum(); l = -x[x < 0].sum(); pf = w / l if l > 0 else 99.0
        P(f'| {nome} | {pn} {y0}-{y1} | {ne} | {len(x)} | {pf:.2f} | {(x>0).mean()*100:.0f} | {x.mean():.1f} | {x.sum()/anni:.0f} | {sum(evs)/anni/50*3:.1f} |'); res[pn] = (len(x), pf)
    nd = sum(1 for r in rows if r[1] == 'nodata'); dbl = sum(1 for r in rows if r[1] == 'ok' and r[2] == 2); P(f'  ({nome}: eventi {len(rows)}, senza dati {nd}, eventi con entrambi gli ordini scattati {dbl})')
    i, o, h = res['IS'], res['OOS'], res['HO']; g = GATE[tipo]
    ok = i[0] >= g[0] and i[1] >= 1.3 and o[0] >= g[1] and o[1] > 1.2 and h[0] >= g[2] and h[1] > 1.0
    verd.append(f'- {nome}: IS {i[1]:.2f} (n={i[0]}), OOS {o[1]:.2f} (n={o[0]}), HO {h[1]:.2f} (n={h[0]}) -> ' + ('CANDIDATA' if ok else 'non passa'))
P(); P('VERDETTO (soglie dei criteri V3):'); [P(v) for v in verd]
if os.environ.get('POSTNEWS_OUT'): open(os.environ['POSTNEWS_OUT'], 'w').write('\n'.join(out) + '\n')
