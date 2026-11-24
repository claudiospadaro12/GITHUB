#!/usr/bin/env python3
"""Breakout della notte (Emiliano) + filtro weekly/daily, forex H1. Criteri: report/NOTTE_EMILIANO_FOREX_CRITERI_2026-11-24.md (fissati prima dei numeri).
Uso: python3 -I notte_emiliano.py <cartella_H1> [<out_txt>]"""
import sys, os, itertools, math, collections
import numpy as np, pandas as pd
D = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else None
PAIRS = {'EURUSD':0.8,'USDJPY':1.0,'GBPUSD':1.2,'AUDUSD':1.2,'EURGBP':1.5,'USDCAD':1.5,'USDCHF':1.5,'NZDUSD':1.8,'EURJPY':1.8,'GBPJPY':2.8}
START, END, SPLIT = '2005-01-01', '2026-11-20', '2016-01-01'
out = []
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); out.append(s)
data = {}
for s in PAIRS:
    df = pd.read_csv(f'{D}/ABTG_H1_{s}.csv', sep=';')
    df['t'] = pd.to_datetime(df['date'], format='%Y.%m.%d %H:%M')
    df = df[(df.t >= START) & (df.t < END)].reset_index(drop=True)
    data[s] = df
# --- controllo fuso: ora del picco di tickvol per anno (EURUSD)
df = data['EURUSD']; df['y'] = df.t.dt.year; df['h'] = df.t.dt.hour
pk = {y: int(g.groupby('h').tickvol.mean().idxmax()) for y, g in df.groupby('y') if y in (2005, 2010, 2015, 2020, 2025)}
P('CONTROLLO FUSO ora del picco di tickvol EURUSD per anno:', pk)
if max(pk.values()) - min(pk.values()) > 1: P('FUSO NON COERENTE: test fermo'); sys.exit(1)

class Pair:
    def __init__(s, name, df):
        s.name = name; s.pip = 0.01 if 'JPY' in name else 0.0001
        s.t = df.t.values; s.o = df.open.values; s.h = df.high.values; s.l = df.low.values; s.c = df.close.values
        s.hour = df.t.dt.hour.values; s.date = df.t.dt.normalize().values
        # giornaliero (data server)
        g = df.assign(d=df.t.dt.normalize()).groupby('d')
        s.d_o = g.open.first(); s.d_c = g.close.last()
        s.days = list(s.d_o.index)
        wk = df.assign(w=df.t.dt.to_period('W-SUN'))  # settimana lun-dom
        s.w_o = wk.groupby('w').open.first(); s.w_c = wk.groupby('w').close.last()
        s.idx = {}  # data -> (i0, i1)
        d = s.date; st = 0
        starts = np.flatnonzero(np.r_[True, d[1:] != d[:-1]]); ends = np.r_[starts[1:], len(d)]
        for a, b in zip(starts, ends): s.idx[pd.Timestamp(d[a])] = (a, b)

def sim_day(p, day, prevday, win, stopmode, ex, wk, ctrl, cost):
    """ritorna (R_lordo, rischio_pip) oppure None"""
    ia = p.idx.get(day)
    if ia is None or prevday not in p.idx: return None
    # finestra notte
    if win == 'A':
        n0 = ia[0]; hh = p.hour[ia[0]:ia[1]]; sel = np.flatnonzero(hh < 8)
        if len(sel) < 4: return None
        nb = np.arange(ia[0], ia[0] + sel[-1] + 1); live_from = 8
    else:
        if day.weekday() == 0: return None
        pb = p.idx.get(prevday); sel_p = np.flatnonzero(p.hour[pb[0]:pb[1]] >= 22)
        sel_t = np.flatnonzero(p.hour[ia[0]:ia[1]] < 7)
        if len(sel_p) < 1 or len(sel_t) < 3: return None
        nb = np.r_[pb[0] + sel_p, ia[0] + sel_t]; live_from = 7
    NH = p.h[nb].max(); NL = p.l[nb].min(); rng = (NH - NL) / p.pip
    if rng < 8 or rng > 100: return None
    # direzione
    if not ctrl:
        dd = p.d_c[prevday] - p.d_o[prevday]
        if wk == 'W1':
            w = pd.Timestamp(day).to_period('W-SUN') - 1
            if w not in p.w_o.index: return None
            ww = p.w_c[w] - p.w_o[w]
        else:
            w = pd.Timestamp(day).to_period('W-SUN')
            if w not in p.w_o.index: return None
            ww = p.d_c[prevday] - p.w_o[w]
            if prevday.to_period('W-SUN') != w: return None  # lunedi: nessuna parte di settimana
        if dd > 0 and ww > 0: dirs = [1]
        elif dd < 0 and ww < 0: dirs = [-1]
        else: return None
    else: dirs = [1, -1]
    # barre di giornata dal live_from
    seg = np.flatnonzero((p.hour[ia[0]:ia[1]] >= live_from) & (p.hour[ia[0]:ia[1]] <= 20)) + ia[0]
    if len(seg) < 4: return None
    lv = {1: NH + 3 * p.pip, -1: NL - 3 * p.pip}
    filled = 0; fillp = 0.0
    for k in seg:
        if p.hour[k] >= 17 and not filled: return None
        if not filled:
            hit = [d for d in dirs if (p.h[k] >= lv[1] if d == 1 else p.l[k] <= lv[-1])]
            if not hit: continue
            if len(hit) > 1: return (-1.0, max(rng, 5.0))  # entrambi nella stessa barra: perdita (conservativo)
            d = hit[0]; filled = d
            fillp = max(lv[1], p.o[k]) if d == 1 else min(lv[-1], p.o[k])
            stop = NL if (stopmode == 'S1' and d == 1) else NH if (stopmode == 'S1') else (NH + NL) / 2
            R = abs(fillp - stop)
            if R / p.pip < 5 or R / p.pip > 80: return None
            t1 = fillp + d * R; t2 = fillp + d * 2 * R; stage = 0; part = 0.0
            # stessa barra: conservativo, se tocca lo stop e' perdita
            if (p.l[k] <= stop if d == 1 else p.h[k] >= stop): return (-1.0, R / p.pip)
            if (p.h[k] >= t1 if d == 1 else p.l[k] <= t1): stage = 1; part = 0.5; stop = fillp
            continue
        # posizione aperta, barra successiva
        hit_stop = (p.l[k] <= stop) if d == 1 else (p.h[k] >= stop)
        if hit_stop:
            if stage == 0: return (-1.0, R / p.pip)
            return (part + 0.0, R / p.pip)  # meta a +1R, resto a pari
        if stage == 0 and ((p.h[k] >= t1) if d == 1 else (p.l[k] <= t1)):
            stage = 1; part = 0.5; stop = fillp; continue
        if stage == 1 and ex == 'X2' and ((p.h[k] >= t2) if d == 1 else (p.l[k] <= t2)):
            return (part + 0.5 * 2.0, R / p.pip)
    if not filled: return None
    last = seg[-1]; rem = d * (p.c[last] - fillp) / R
    return ((part + 0.5 * rem) if stage == 1 else rem, R / p.pip)

pairs = {s: Pair(s, data[s]) for s in PAIRS}
cells = [(w, st, ex, wk, c) for w in 'AB' for st in ('S1', 'S2') for ex in ('X1', 'X2') for wk in ('W1', 'W2') for c in (False,)]
cells = [x for x in cells] + [(w, st, ex, 'W1', True) for w in 'AB' for st in ('S1', 'S2') for ex in ('X1', 'X2')]
P('celle', len(cells))
res = {}
for ci, cell in enumerate(cells):
    w, st, ex, wk, ctrl = cell; rows = []
    for s, p in pairs.items():
        dl = p.days
        for i in range(1, len(dl)):
            day, prev = dl[i], dl[i - 1]
            if (day - prev).days > 4: continue
            r = sim_day(p, day, prev, w, st, ex, wk, ctrl, PAIRS[s])
            if r: rows.append((day, s, r[0], r[1]))
    res[cell] = pd.DataFrame(rows, columns=['day', 'pair', 'g', 'rp'])
    P('cella', ci + 1, cell, 'operazioni', len(rows))
def stats(df, k=1.0):
    if len(df) == 0: return dict(n=0, pf=0, t=0, mean=0, tot=0)
    net = df.g - k * df.pair.map(PAIRS) / df.rp
    gp = net[net > 0].sum(); gl = -net[net <= 0].sum()
    dsum = net.groupby(df.day).sum()
    t = dsum.mean() / (dsum.std(ddof=1) / math.sqrt(len(dsum))) if len(dsum) > 2 and dsum.std() > 0 else 0
    return dict(n=len(df), pf=gp / gl if gl > 0 else 99, t=t, mean=net.mean(), tot=net.sum())
sp = pd.Timestamp(SPLIT); s2 = pd.Timestamp('2025-01-01')
P('\n%-22s | %5s %5s %5s | %5s %5s %5s | OOS x2 PF | coppie>0 OOS | 2025-26 R | gate' % ('cella', 'nIS', 'PFis', 't', 'nOOS', 'PFoo', 'Rmed'))
summ = {}
for cell, df in res.items():
    isd = df[df.day < sp]; oo = df[df.day >= sp]
    a = stats(isd); b = stats(oo); b2 = stats(oo, 2.0); r2526 = stats(df[df.day >= s2])['tot']
    pos = sum(1 for s in PAIRS if stats(oo[oo.pair == s])['tot'] > 0)
    summ[cell] = (a, b, b2, pos, r2526)
for cell, (a, b, b2, pos, r2526) in summ.items():
    w, st, ex, wk, ctrl = cell
    ctl = summ[(w, st, ex, 'W1', True)][1]['pf'] if not ctrl else None
    g = ''
    if not ctrl:
        ok = a['pf'] >= 1.15 and a['t'] >= 2.5 and b['pf'] >= 1.10 and b['mean'] > 0 and b2['pf'] >= 1.05 and pos >= 6 and r2526 >= 0 and b['pf'] - ctl >= 0.10
        g = 'PASSA' if ok else 'no'
    P('%-22s | %5d %5.2f %5.1f | %5d %5.2f %5.3f | %5.2f | %d | %+8.1f | %s' % (('CTRL ' if ctrl else '') + w + st + ex + ('' if ctrl else wk), a['n'], a['pf'], a['t'], b['n'], b['pf'], b['mean'], b2['pf'], pos, r2526, g))
f = [c for c in summ if not c[4]]
pfo = sorted(summ[c][1]['pf'] for c in f)
P('\nPF OOS mediano delle 16 celle:', round(float(np.median(pfo)), 3), '| celle con IS PF>=1.15 e t>=2.5:', sum(1 for c in f if summ[c][0]['pf'] >= 1.15 and summ[c][0]['t'] >= 2.5))
P('filtro batte il controllo (PF OOS) in', sum(1 for c in f if summ[c][1]['pf'] > summ[(c[0], c[1], c[2], 'W1', True)][1]['pf']), 'celle su 16')
P('S2 > S1 (PF IS) in', sum(1 for w in 'AB' for ex in ('X1','X2') for wk in ('W1','W2') if summ[(w,'S2',ex,wk,False)][0]['pf'] > summ[(w,'S1',ex,wk,False)][0]['pf']), 'confronti su 8')
P('\nDIAGNOSTICA (non e una cella): PF LORDO (costi 0), IS / OOS, e quota di operazioni chiuse a -1R esatto')
for cell, df in res.items():
    w, st, ex, wk, ctrl = cell
    a0 = stats(df[df.day < sp], 0.0); b0 = stats(df[df.day >= sp], 0.0)
    P('%-22s | PF lordo IS %.2f OOS %.2f | -1R esatto %.0f%% | rischio mediano %.1f pip' % (('CTRL ' if ctrl else '') + w + st + ex + ('' if ctrl else wk), a0['pf'], b0['pf'], 100 * (df.g == -1.0).mean(), df.rp.median()))
if OUT: open(OUT, 'w').write('\n'.join(out) + '\n')
