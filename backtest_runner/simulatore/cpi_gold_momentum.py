#!/usr/bin/env python3
"""CPI M5 oro: famiglia M (ingresso a mercato dopo il primo minuto se spara forte). Criteri: report/CPI_M5_BERSAGLIO_AMPIEZZA_CRITERI_2026-11-25.md (aggiunta)"""
import sys, pandas as pd, numpy as np
c = pd.read_pickle(sys.argv[1]); m = pd.read_pickle(sys.argv[2]); m = m[~m.index.duplicated()]; ev = c[c.d.notna()].copy()
A = pd.read_pickle(sys.argv[3])[['e', 'r']].set_index('e'); PX = {e: m.close.asof(e) for e in A.index}; PCT = pd.Series({e: A.r[e] / PX[e] * 100 for e in A.index})
def trade(e, f, ref, tp_mult, pen):
    b0 = m.loc[e] if e in m.index else None
    if b0 is None: return None
    r1 = b0.high - b0.low; body = abs(b0.close - b0.open)
    if r1 < f * ref or body < 0.5 * r1 or r1 <= 0: return ('skip', 0.0)
    long_ = b0.close > b0.open; t1 = e + pd.Timedelta(minutes=1); bars = m.loc[t1:e + pd.Timedelta(minutes=4)]
    if len(bars) < 3: return None
    sp = max((bars.iloc[0]['spread'] * 0.01) if bars.iloc[0]['spread'] > 0 else 0.0, 0.50)
    ent = bars.iloc[0].open + (sp if long_ else 0.0); entb = bars.iloc[0].open
    sl = b0.low if long_ else b0.high; tp = (ent + tp_mult * ref) if (tp_mult and long_) else ((entb - tp_mult * ref) if tp_mult else None)
    for t, b in bars.iterrows():
        if long_:
            if b.low <= sl: return ('ok', (sl - ent) - pen)
            if tp is not None and b.high >= tp: return ('ok', (tp - ent) - pen)
        else:
            if b.high + sp >= sl: return ('ok', (entb - (sl + sp)) - pen)
            if tp is not None and b.low + sp <= tp: return ('ok', (entb - tp - sp) - pen)
    last = bars.iloc[-1].close
    return ('ok', ((last - ent) if long_ else (entb - (last + sp))) - pen)
refs = {}
for e in ev.exp:
    if e.year < 2018 or e not in A.index: continue
    pp = PCT[(PCT.index < e) & (PCT.index >= e - pd.Timedelta(days=365 * 5))]
    if len(pp) >= 24: refs[e] = pp.mean() / 100 * PX[e]
print('eventi con riferimento:', len(refs), '| ampiezza di riferimento mediana %.1f USD' % np.median(list(refs.values())))
for name, f, tpm in (('M1 f=0,25', 0.25, None), ('M2 f=0,5', 0.5, None), ('M3 f=0,5 + TP 1,0xA', 0.5, 1.0)):
    for lab, pen in (('pen 0', 0.0), ('pen 1,0', 1.0)):
        out = []
        for e, ref in refs.items():
            r = trade(e, f, ref, tpm, pen)
            if r and r[0] == 'ok': out.append((e, r[1]))
        df = pd.DataFrame(out, columns=['e', 's']); cols = []
        for lb, y0, y1 in (('2018-2022', 2018, 2022), ('2023-2026', 2023, 2026)):
            x = df[(df.e.dt.year >= y0) & (df.e.dt.year <= y1)].s.values
            if len(x) == 0: cols.append(lb + ' n=0'); continue
            w = x[x > 0].sum(); l = -x[x < 0].sum(); cols.append('%s n=%d media %+.2f mediana %+.2f PF %.2f' % (lb, len(x), x.mean(), np.median(x), w / l if l > 0 else 99))
        print('%-22s %-8s' % (name, lab), ' | '.join(cols))
