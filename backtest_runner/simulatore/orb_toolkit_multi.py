#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""orb_toolkit_multi.py - estensione a oro/EURUSD FTMO (criteri: report/ORB_TOOLKIT_AMERICA_CRITERI_2026-11-18.md, sezione ESTENSIONE). Uso: python3 -I orb_toolkit_multi.py DIR [DIR..]"""
import sys, glob, math, datetime as D
OPEN = 990; RNG_END = 1020; ENT_END = 1110; EXIT = 1380
CFG = {'XAUUSD': 0.66, 'EURUSD': 0.00010}

def carica(dirs, sym):
    m5 = {}; M1 = {}
    for d in dirs:
        for f in sorted(glob.glob(d + '/ABTG_M1_%s_*.csv' % sym)):
            for ln in open(f, encoding='utf-8-sig'):
                p = ln.split(';')
                if not p[0][:4].isdigit(): continue
                mm = int(p[0][11:13]) * 60 + int(p[0][14:16])
                if mm < 65: continue
                dt = D.date(int(p[0][:4]), int(p[0][5:7]), int(p[0][8:10])); n = dt.toordinal() * 1440 + mm; b = n // 5
                o, h, l, c = float(p[1]), float(p[2]), float(p[3]), float(p[4])
                x = m5.get(b)
                if x is None: m5[b] = [o, h, l, c]
                else:
                    if h > x[1]: x[1] = h
                    if l < x[2]: x[2] = l
                    x[3] = c
                if OPEN <= mm < EXIT: M1.setdefault(dt, {})[mm] = (o, h, l, c)
    e9 = e21 = None; E = {}
    for b in sorted(m5):
        c = m5[b][3]; e9 = c if e9 is None else e9 + 0.2 * (c - e9); e21 = c if e21 is None else e21 + (2 / 22) * (c - e21); E[b] = (e9, e21)
    return m5, E, M1

def giorno(dt, m5, E, M1, ex, costo):
    b1 = M1.get(dt)
    if not b1: return None
    base = dt.toordinal() * 1440
    rng = [m5.get((base + OPEN + 5 * i) // 5) for i in range((RNG_END - OPEN) // 5)]
    if any(x is None for x in rng): return None
    H = max(x[1] for x in rng); L = min(x[2] for x in rng); buf = 0.002 * H; rmin = 0.0016 * H
    for st in range(RNG_END, ENT_END, 5):
        bk = (base + st) // 5; c5 = m5.get(bk)
        if c5 is None: continue
        o, h, l, c = c5; e9, e21 = E[bk]
        side = 1 if c > H else (-1 if c < L else 0)
        if side == 0 or (side == 1 and not c > o) or (side == -1 and not c < o): continue
        if abs(c - o) < 0.5 * (h - l): continue
        if side == 1 and not (e9 > e21 and c > e9 and c > e21): continue
        if side == -1 and not (e9 < e21 and c < e9 and c < e21): continue
        t0 = st + 5; eb = b1.get(t0)
        if eb is None: return None
        ent = eb[0]; sl = (L - buf) if side == 1 else (H + buf); R = abs(ent - sl)
        if R < rmin or (side == 1 and sl >= ent) or (side == -1 and sl <= ent): return None
        tp = None if ex == 'EMA' else ent + side * ex * R
        for m in range(t0, EXIT):
            x = b1.get(m)
            if x is None: continue
            o1, h1, l1, c1 = x
            if side == 1:
                if l1 <= sl: return -R - costo
                if tp is not None and h1 >= tp: return ex * R - costo
            else:
                if h1 >= sl: return -R - costo
                if tp is not None and l1 <= tp: return ex * R - costo
            if ex == 'EMA' and (m + 1) % 5 == 0:
                kb = (base + m - 4) // 5; cc = m5.get(kb)
                if cc is not None:
                    ee = E[kb][1]
                    if (side == 1 and cc[3] < ee) or (side == -1 and cc[3] > ee):
                        n2 = b1.get(m + 1); px = n2[0] if n2 else c1
                        return side * (px - ent) - costo
        last = max((m for m in b1 if m < EXIT), default=None)
        return side * (b1[last][3] - ent) - costo if last else None
    return None

def metr(v):
    n = len(v)
    if n < 3: return n, 0, 0, 0, {}
    x = [p for _, p in v]; tot = sum(x); gp = sum(i for i in x if i > 0); gl = -sum(i for i in x if i < 0)
    mu = tot / n; sd = math.sqrt(sum((i - mu) ** 2 for i in x) / (n - 1)); an = {}
    for y, p in v: an[y] = an.get(y, 0) + p
    return n, tot, (gp / gl if gl > 0 else 9.99), (mu / (sd / math.sqrt(n)) if sd > 0 else 0), an

if __name__ == '__main__':
    dirs = sys.argv[1:]
    for sym, costo in CFG.items():
        m5, E, M1 = carica(dirs, sym)
        for ex in (2, 'EMA'):
            row = []; ok = True
            for a, z in ((2015, 2017), (2018, 2020)):
                v = [(str(dt.year), p) for dt in sorted(M1) if a <= dt.year <= z and dt.weekday() < 5 for p in [giorno(dt, m5, E, M1, ex, costo)] if p is not None]
                n, tot, pf, t, an = metr(v)
                rel = lambda x: x if sym == 'XAUUSD' else x * 10000
                g = n >= 100 and tot > 0 and pf >= 1.2 and t >= 2.0 and sum(1 for q in an.values() if q > 0) >= 2; ok = ok and g
                print('%s ex=%-3s %d-%d n=%4d netto %+9.2f PF %.2f t %+.2f anni %s %s' % (sym, ex, a, z, n, rel(tot), pf, t, {y: round(rel(q), 1) for y, q in sorted(an.items())}, 'PASSA' if g else ''))
            print('  -> %s ex=%s: %s' % (sym, ex, 'PASSA ENTRAMBI I PERIODI' if ok else 'NO'))
