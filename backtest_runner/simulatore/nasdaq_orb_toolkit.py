#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""nasdaq_orb_toolkit.py - criteri: report/ORB_TOOLKIT_AMERICA_CRITERI_2026-11-18.md. Uso: python3 -I nasdaq_orb_toolkit.py DIR (NASUSD_M1_<anno>.csv, ora NY)"""
import sys, glob, math, itertools, datetime as D
COSTO = 2.0; RMIN = 8.0

def carica(d):
    m5 = {}; M1 = {}
    for f in sorted(glob.glob(d + '/NASUSD_M1_*.csv')):
        for ln in open(f, encoding='utf-8-sig'):
            if ln[0] == 'T': continue
            p = ln.split(',')
            dt = D.date(int(p[0][:4]), int(p[0][5:7]), int(p[0][8:10])); mm = int(p[0][11:13]) * 60 + int(p[0][14:16])
            n = dt.toordinal() * 1440 + mm; b = n // 5
            o, h, l, c = float(p[1]), float(p[2]), float(p[3]), float(p[4])
            x = m5.get(b)
            if x is None: m5[b] = [o, h, l, c]
            else:
                if h > x[1]: x[1] = h
                if l < x[2]: x[2] = l
                x[3] = c
            if 570 <= mm < 960: M1.setdefault(dt, {})[mm] = (o, h, l, c)
    ks = sorted(m5); e9 = e21 = None; k9 = 2 / 10; k21 = 2 / 22; E = {}
    for b in ks:
        c = m5[b][3]; e9 = c if e9 is None else e9 + k9 * (c - e9); e21 = c if e21 is None else e21 + k21 * (c - e21); E[b] = (e9, e21)
    return m5, E, M1

def giorno(dt, m5, E, M1, filt, body, buf, ex):
    b1 = M1.get(dt)
    if not b1: return None
    base = dt.toordinal() * 1440
    rng = [m5.get((base + 570 + 5 * i) // 5) for i in range(6)]
    if any(x is None for x in rng): return None
    H = max(x[1] for x in rng); L = min(x[2] for x in rng)
    for i in range(6, 24):                      # candele M5 che iniziano 10:00 .. 11:25
        st = 570 + 5 * i; bk = (base + st) // 5; c5 = m5.get(bk)
        if c5 is None: continue
        o, h, l, c = c5; e9, e21 = E[bk]
        side = 1 if c > H else (-1 if c < L else 0)
        if side == 0: continue
        if side == 1 and not c > o: continue
        if side == -1 and not c < o: continue
        if body and abs(c - o) < 0.5 * (h - l): continue
        if filt:
            if side == 1 and not (e9 > e21 and c > e9 and c > e21): continue
            if side == -1 and not (e9 < e21 and c < e9 and c < e21): continue
        t0 = st + 5; ent_bar = b1.get(t0)
        if ent_bar is None: return None
        ent = ent_bar[0]; sl = (L - buf) if side == 1 else (H + buf); R = abs(ent - sl)
        if R < RMIN or (side == 1 and sl >= ent) or (side == -1 and sl <= ent): return None
        tp = None if ex == 'EMA' else ent + side * ex * R
        for m in range(t0, 960):
            x = b1.get(m)
            if x is None: continue
            o1, h1, l1, c1 = x
            if side == 1:
                if l1 <= sl: return -R - COSTO
                if tp is not None and h1 >= tp: return ex * R - COSTO
            else:
                if h1 >= sl: return -R - COSTO
                if tp is not None and l1 <= tp: return ex * R - COSTO
            if ex == 'EMA' and (m + 1) % 5 == 0:   # chiusura di una M5
                kb = (base + m - 4) // 5; cc = m5.get(kb)
                if cc is not None and m > t0 - 1:
                    ee = E[kb][1]
                    if (side == 1 and cc[3] < ee) or (side == -1 and cc[3] > ee):
                        n2 = b1.get(m + 1); px = n2[0] if n2 else c1
                        return side * (px - ent) - COSTO
        last = max((m for m in b1 if m < 960), default=None)
        return side * (b1[last][3] - ent) - COSTO if last else None
    return None

def serie(m5, E, M1, a, z, **k):
    out = []
    for dt in sorted(M1):
        if not (a <= dt.year <= z) or dt.weekday() >= 5: continue
        p = giorno(dt, m5, E, M1, **k)
        if p is not None: out.append((str(dt.year), p))
    return out

def metr(v):
    n = len(v)
    if n < 3: return n, 0, 0, 0, {}
    x = [p for _, p in v]; tot = sum(x); gp = sum(i for i in x if i > 0); gl = -sum(i for i in x if i < 0)
    mu = tot / n; sd = math.sqrt(sum((i - mu) ** 2 for i in x) / (n - 1)); an = {}
    for y, p in v: an[y] = an.get(y, 0) + p
    return n, tot, (gp / gl if gl > 0 else 9.99), (mu / (sd / math.sqrt(n)) if sd > 0 else 0), an

def ok(m):
    n, tot, pf, t, an = m
    return n >= 100 and tot > 0 and pf >= 1.2 and t >= 2.0 and sum(1 for v in an.values() if v > 0) >= 2

if __name__ == '__main__':
    m5, E, M1 = carica(sys.argv[1]); res = {}; sel = []
    print('--- SELEZIONE 2015-2017 (punti netti, costo 2,0) ---')
    for filt, body, buf, ex in itertools.product((True, False), (True, False), (5, 10), (1.5, 2, 'EMA')):
        k = dict(filt=filt, body=body, buf=buf, ex=ex); m = metr(serie(m5, E, M1, 2015, 2017, **k)); n, tot, pf, t, an = m
        res[(filt, body, buf, ex)] = m
        print('EMAf=%d corpo=%d buf%2d ex=%-4s n=%4d netto %+8.0f PF %.2f t %+.2f %s %s' % (filt, body, buf, ex, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m) else ''))
        if ok(m): sel.append((t, k))
    sel.sort(key=lambda x: -x[0]); cand = [c for _, c in sel[:3]]
    print('passano: %d | candidati: %s' % (len(sel), cand or 'NESSUNO'))
    # domanda secondaria: filtro EMA acceso contro spento (12 coppie)
    pa = []; 
    for body, buf, ex in itertools.product((True, False), (5, 10), (1.5, 2, 'EMA')):
        a = res[(True, body, buf, ex)]; b = res[(False, body, buf, ex)]; pa.append((a[2], b[2]))
    print('filtro EMA acceso > spento (PF) in %d coppie su %d' % (sum(1 for a, b in pa if a > b), len(pa)))
    for k in cand:
        m = metr(serie(m5, E, M1, 2018, 2020, **k)); n, tot, pf, t, an = m
        print('VALIDAZIONE 2018-2020 %s n=%d netto %+.0f PF %.2f t %+.2f anni %s -> %s' % (k, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m) else 'NO'))
