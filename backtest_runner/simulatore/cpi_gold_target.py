#!/usr/bin/env python3
"""CPI M5 oro: fedelta' M1 vs tester e bersaglio = ampiezza media 5 anni. Criteri: report/CPI_M5_BERSAGLIO_AMPIEZZA_CRITERI_2026-11-25.md
Uso: /usr/bin/python3 -I cpi_gold_target.py <cpi_ev2.pkl> <gold_m1.pkl> <testergraph.csv>"""
import sys, pandas as pd, numpy as np
c = pd.read_pickle(sys.argv[1]); m = pd.read_pickle(sys.argv[2]); ev = c[c.d.notna()].copy()
m = m[~m.index.duplicated()]
def sim(e, buf=1.0, tp=None, pen=0.0):
    pl = m.loc[e - pd.Timedelta(minutes=10):e - pd.Timedelta(minutes=5, seconds=1)]            # ultima M5 chiusa a T-5
    if len(pl) < 4: return None
    up, dn = pl.high.max() + buf, pl.low.min() - buf
    bars = m.loc[e - pd.Timedelta(minutes=5):e + pd.Timedelta(minutes=4)]
    if len(bars) < 8: return None
    pos = None; tpv = None
    for t, b in bars.iterrows():
        sp = b['spread'] * 0.01 if b['spread'] > 0 else 0.30
        hu = b.high + sp >= up; hd = b.low <= dn
        if pos is None:
            if hu and hd: return (-(up - dn) - sp - pen)
            if hu: pos = 'L'; ent = up; tpv = ent + tp if tp else None; continue
            if hd: pos = 'S'; ent = dn; tpv = ent - tp if tp else None; continue
        else:
            if pos == 'L':
                if b.low <= dn: return (dn - ent) - sp - pen
                if tpv is not None and b.high >= tpv: return tp - sp - pen
            else:
                if b.high + sp >= up: return (ent - up) - sp - pen
                if tpv is not None and b.low + sp <= tpv: return tp - sp - pen
    if pos is None: return 0.0
    last = bars.iloc[-1].close
    return ((last - ent) if pos == 'L' else (ent - (last + 0.0))) - sp - pen
# passo 0: tester reale
d = pd.read_csv(sys.argv[3], sep='\t', encoding='utf-16'); d.columns = ['t', 'bal', 'eq', 'load']; d['t'] = pd.to_datetime(d.t, format='%Y.%m.%d %H:%M')
ch = pd.DataFrame({'t': d.t.values[1:], 'd': np.diff(d.bal.values)}); ch = ch[ch.d.abs() > 0.005]; ch['day'] = pd.to_datetime(ch.t).dt.date
real = (ch.groupby('day').d.sum() / 10.0)   # USD/oz con 10 oz
rows = []
for e in ev.exp:
    if e.date() in real.index:
        s = sim(e)
        if s is not None: rows.append((e.date(), real[e.date()], s))
cmp_ = pd.DataFrame(rows, columns=['giorno', 'tester', 'm1']); cmp_['scarto'] = cmp_.m1 - cmp_.tester
print('PASSO 0: eventi confrontati', len(cmp_), '| tester medio %.2f, M1 medio %.2f, scarto medio %.2f, mediano %.2f | correlazione %.2f' % (cmp_.tester.mean(), cmp_.m1.mean(), cmp_.scarto.mean(), cmp_.scarto.median(), np.corrcoef(cmp_.tester, cmp_.m1)[0, 1]))
print(cmp_.round(2).to_string(index=False))
pen = float(cmp_.scarto.mean())
# ampiezza e rolling
A = pd.read_pickle('/tmp/claude-0/cpi_a.pkl')[['e', 'r']].set_index('e'); a = A.r
PX = {e: m.close.asof(e) for e in A.index}; PCT = pd.Series({e: A.r[e] / PX[e] * 100 for e in A.index})
print('\nAMPIEZZA candela CPI M5 (USD/oz) per anno: media / mediana'); print(a.groupby(a.index.year).agg(['mean', 'median', 'count']).round(2).to_string())
res = {}
for e in ev.exp:
    if e.year < 2018 or e not in a.index: continue
    past = a[(a.index < e) & (a.index >= e - pd.Timedelta(days=365 * 5))]
    if len(past) < 24: continue
    pp = PCT[(PCT.index < e) & (PCT.index >= e - pd.Timedelta(days=365 * 5))]
    res[e] = (past.mean(), past.median(), pp.mean() / 100 * PX[e], pp.median() / 100 * PX[e])
def run(name, tpf, pen_):
    out = []
    for e, (mn, md, pm, pmd) in res.items():
        s = sim(e, tp=tpf(mn, md, pm, pmd), pen=pen_)
        if s is not None: out.append((e, s))
    df = pd.DataFrame(out, columns=['e', 's']); r = {}
    for lab, y0, y1 in (('2018-2022', 2018, 2022), ('2023-2026', 2023, 2026)):
        x = df[(df.e.dt.year >= y0) & (df.e.dt.year <= y1)].s.values
        w = x[x > 0].sum(); l = -x[x < 0].sum(); r[lab] = (len(x), x.mean(), np.median(x), (w / l if l > 0 else 99))
    return r
print('\nVARIANTI (USD/oz per evento; n, media, mediana, PF) | penalita calibrata = %.2f' % pen)
for name, tpf in (('V0 nessun bersaglio', lambda mn, md, pm, pmd: None), ('V1 1,0 x media 5 anni', lambda mn, md, pm, pmd: 1.0 * mn), ('V2 0,5 x media', lambda mn, md, pm, pmd: 0.5 * mn), ('V3 1,0 x mediana', lambda mn, md, pm, pmd: 1.0 * md), ('V4* 1,0 x media % del prezzo (POST HOC)', lambda mn, md, pm, pmd: 1.0 * pm), ('V5* 0,5 x media % del prezzo (POST HOC)', lambda mn, md, pm, pmd: 0.5 * pm)):
    for lab_p, p in (('pen 0', 0.0), ('pen calibrata', pen)):
        r = run(name, tpf, p)
        print('%-24s %-14s' % (name, lab_p), ' | '.join('%s n=%d media %+.2f mediana %+.2f PF %.2f' % (k, *v) for k, v in r.items()))
