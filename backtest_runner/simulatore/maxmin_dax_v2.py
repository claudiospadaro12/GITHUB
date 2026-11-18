#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""maxmin_dax_v2.py - ROUND 2, criteri: report/MAXMIN_NOTTE_DAX_CRITERI_2026-11-18.md. Esecuzione realista fissa."""
import sys, glob, math, itertools, statistics as ST, datetime as D
sys.path.insert(0, __file__.rsplit('/', 1)[0])
from maxmin_dax import ny_to_cet, metr

def carica(d):
    S = {}
    for f in sorted(glob.glob(d + '/D30EUR_M1_*.csv')):
        for ln in open(f, encoding='utf-8-sig'):
            if ln[0] == 'T': continue
            p = ln.split(',')
            t = D.datetime(int(p[0][:4]), int(p[0][5:7]), int(p[0][8:10]), int(p[0][11:13]), int(p[0][14:16]))
            c = ny_to_cet(t); mm = c.hour * 60 + c.minute
            if mm <= 1140: S.setdefault(c.date(), {})[mm] = (float(p[1]), float(p[2]), float(p[3]), float(p[4]))
    return S

def box(b, bx):
    a, z = (120, 480) if bx == 'A' else (0, 360)
    bars = [b[m] for m in range(a, z) if m in b]
    if len(bars) < 0.6 * (z - a): return None
    return max(x[1] for x in bars), min(x[2] for x in bars)

def giorno(b, H, L, val, stop, tmax=180):
    SC = H / 12000.0; buf = 10 * SC; buy = H + buf; sell = L - buf; cost = 2.0 * SC
    T = [30 * SC, 87 * SC, 113 * SC]
    pre = max((m for m in b if m < 540), default=None)
    if pre is None: return None
    pc = b[pre][3]; canbuy = pc < buy; cansell = pc > sell
    end = 660 if val == 'S' else 1110
    side = None
    for m in range(540, end):
        x = b.get(m)
        if x is None: continue
        tu = canbuy and x[1] >= buy; td = cansell and x[2] <= sell
        if tu and td: return None
        if tu or td:
            side = 1 if tu else -1
            ent = max(buy, x[0]) if tu else min(sell, x[0]); m0 = m; break
    if side is None: return None
    sl0 = 30 * SC if stop == 'S30' else (ent - (L - buf) if side == 1 else (H + buf) - ent)
    if sl0 <= 0: return None
    sl = ent - side * sl0; frac = 1 / 3; rem = 3; pnl = 0.0; k = 0
    x = b[m0]
    if (side == 1 and x[2] <= sl) or (side == -1 and x[1] >= sl): return -sl0 - cost
    mexit = min(m0 + tmax, 1110)
    for m in range(m0 + 1, mexit + 1):
        x = b.get(m)
        if x is None: continue
        o, h, l, c = x
        if (side == 1 and l <= sl) or (side == -1 and h >= sl):
            pnl += rem * frac * side * (sl - ent); rem = 0; break
        newsl = sl
        while k < 3 and ((side == 1 and h >= ent + T[k]) or (side == -1 and l <= ent - T[k])):
            pnl += frac * T[k]; rem -= 1; newsl = ent if k == 0 else ent + side * T[0]; k += 1
        sl = newsl
        if rem == 0: break
    if rem > 0:
        last = max((m for m in b if m0 < m <= mexit), default=None)
        px = b[last][3] if last else ent
        pnl += rem * frac * side * (px - ent)
    return pnl - cost

def serie(S, d0, d1, bx, val, stop, vol):
    out = []; hist = []
    for d in sorted(S):
        if d.weekday() >= 5: continue
        bb = box(S[d], bx)
        if bb is None: continue
        amp = (bb[0] - bb[1]) / bb[0]
        ok = True
        if vol and len(hist) >= 10 and amp < 0.6 * ST.median(hist[-20:]): ok = False
        hist.append(amp)
        if not (d0 <= d <= d1) or not ok: continue
        p = giorno(S[d], bb[0], bb[1], val, stop)
        if p is not None: out.append((d, p))
    return out

if __name__ == '__main__':
    S = carica(sys.argv[1]); d0 = D.date
    P1 = (d0(2019, 1, 1), d0(2020, 6, 30)); P3 = (d0(2024, 1, 1), d0(2024, 12, 31)); res = {}; ok_l = []
    print('--- ROUND 2: selezione su DAX 2019-01..2020-06 (P1) e DAX 2024 (P3); punti equiv. 12.000 ---')
    for bx, val, stop, vol in itertools.product(('A', 'B'), ('S', 'L'), ('S30', 'OPP'), (False, True)):
        v1 = serie(S, *P1, bx, val, stop, vol); v3 = serie(S, *P3, bx, val, stop, vol)
        m1 = metr(v1); m3 = metr(v3); mt = metr(v1 + v3); res[(bx, val, stop, vol)] = (m1, m3)
        g = all(m[0] >= 80 and m[1] > 0 and m[2] >= 1.15 for m in (m1, m3)) and mt[3] >= 2.5; w = mt[4]
        print('box%s val=%s stop=%-3s vol=%d | P1 n%3d %+6.0f PF%.2f | P3 n%3d %+6.0f PF%.2f | tot t%+.2f vinc %.0f%% %s' % (bx, val, stop, vol, m1[0], m1[1], m1[2], m3[0], m3[1], m3[2], mt[3], w, 'PASSA' if g else ''))
        if g: ok_l.append((bx, val, stop, vol))
    print('passano: %d %s' % (len(ok_l), ok_l or ''))
    def pf2(a, b): return sum(1 for x, y in zip(a, b) if x > y)
    keys = list(res)
    pfagg = lambda k: (res[k][0][2] * res[k][0][0] + res[k][1][2] * res[k][1][0]) / (res[k][0][0] + res[k][1][0])
    vv = [(pfagg((b, v, s, True)), pfagg((b, v, s, False))) for b in 'AB' for v in 'SL' for s in ('S30', 'OPP')]
    print('filtro volatilita migliore in %d coppie su 8' % pf2([a for a, b in vv], [b for a, b in vv]))
    lv = [(pfagg((b, 'L', s, f)), pfagg((b, 'S', s, f))) for b in 'AB' for s in ('S30', 'OPP') for f in (False, True)]
    print('validita 18:30 migliore in %d coppie su 8' % pf2([a for a, b in lv], [b for a, b in lv]))
