#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""nasdaq_breakout_d1.py - criteri: report/CLAU12_NASDAQ_BREAKOUT_D1_CRITERI_2026-11-18.md. Uso: python3 -I nasdaq_breakout_d1.py DIR"""
import sys, glob, math, itertools, datetime as D
COSTO = 2.0; OFF = 0.10; MAXG = 20

def carica(d):
    S = {}; ordine = []
    for f in sorted(glob.glob(d + '/NASUSD_M1_*.csv')):
        for ln in open(f, encoding='utf-8-sig'):
            if ln[0] == 'T': continue
            p = ln.split(',')
            n = D.date(int(p[0][:4]), int(p[0][5:7]), int(p[0][8:10])).toordinal() * 1440 + int(p[0][11:13]) * 60 + int(p[0][14:16])
            k = (n + 360) // 1440
            b = (float(p[1]), float(p[2]), float(p[3]), float(p[4]))
            if k not in S: S[k] = []; ordine.append(k)
            S[k].append(b)
    ks = sorted(S)
    d1 = [(max(x[1] for x in S[k]), min(x[2] for x in S[k]), S[k][-1][3]) for k in ks]
    return ks, S, d1

def atr(d1, j):
    tr = []
    for i in range(j - 14, j):
        h, l, _ = d1[i]; pc = d1[i - 1][2]
        tr.append(max(h - l, abs(h - pc), abs(l - pc)))
    return sum(tr) / 14

def run(dat, N, s, rr, y0, y1):
    ks, S, d1 = dat; out = []; pos = None
    for j in range(max(N, 15), len(ks)):
        yr = D.date.fromordinal(ks[j]).year
        if pos is None and not (y0 <= yr <= y1): continue
        if pos is None:
            A = atr(d1, j); up = max(d1[i][0] for i in range(j - N, j)) + OFF * A; dn = min(d1[i][1] for i in range(j - N, j)) - OFF * A
        for b in S[ks[j]]:
            o, h, l, c = b
            if pos is None:
                tu = h >= up; td = l <= dn
                if tu and td: break
                if not (tu or td): continue
                side = 1 if tu else -1; ent = up if tu else dn; R = s * A
                sl = ent - side * R; tp = ent + side * rr * R
                if (side == 1 and l <= sl) or (side == -1 and h >= sl): out.append((yr, -R - COSTO)); break
                pos = [side, ent, sl, tp, 0, yr]; continue
            side, ent, sl, tp, age, y = pos
            if side == 1: hit_sl = l <= sl; hit_tp = h >= tp
            else: hit_sl = h >= sl; hit_tp = l <= tp
            if hit_sl: out.append((y, side * (sl - ent) - COSTO)); pos = None; break
            if hit_tp: out.append((y, side * (tp - ent) - COSTO)); pos = None; break
        if pos is not None:
            pos[4] += 1
            if pos[4] >= MAXG:
                c = S[ks[j]][-1][3]; out.append((pos[5], pos[0] * (c - pos[1]) - COSTO)); pos = None
    return [x for x in out if y0 <= x[0] <= y1]

def metr(v):
    n = len(v)
    if n < 3: return n, 0, 0, 0, {}
    x = [p for _, p in v]; tot = sum(x); gp = sum(i for i in x if i > 0); gl = -sum(i for i in x if i < 0)
    mu = tot / n; sd = math.sqrt(sum((i - mu) ** 2 for i in x) / (n - 1)); an = {}
    for y, p in v: an[y] = an.get(y, 0) + p
    return n, tot, (gp / gl if gl > 0 else 9.99), (mu / (sd / math.sqrt(n)) if sd > 0 else 0), an

def ok(m, ny):
    n, tot, pf, t, an = m
    return n >= 40 and tot > 0 and pf >= 1.3 and t >= 2.0 and sum(1 for v in an.values() if v > 0) >= 2

if __name__ == '__main__':
    dat = load = carica(sys.argv[1]); sel = []
    print('--- SELEZIONE 2015-2017 (punti netti, costo 2,0): n, netto, PF, t, per anno ---')
    for N, s, rr in itertools.product((10, 20), (0.4, 0.7), (2, 3)):
        m = metr(run(dat, N, s, rr, 2015, 2017)); n, tot, pf, t, an = m
        print('N%d s%.1f rr%d n=%3d netto %+8.0f PF %.2f t %+.2f %s %s' % (N, s, rr, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m, 3) else ''))
        if ok(m, 3): sel.append((t, (N, s, rr)))
    sel.sort(reverse=True); cand = [c for _, c in sel[:3]]
    print('passano: %d | candidati: %s' % (len(sel), cand or 'NESSUNO'))
    for c in cand:
        m = metr(run(dat, *c, 2018, 2020)); n, tot, pf, t, an = m
        print('VALIDAZIONE 2018-2020 %s n=%d netto %+.0f PF %.2f t %+.2f anni %s -> %s' % (c, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m, 3) else 'NO'))
