#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""nasdaq_lezioni.py - criteri: report/CLAU12_NASDAQ_LEZIONI_M1_M3_CRITERI_2026-11-18.md. Uso: python3 -I nasdaq_lezioni.py DIR (con NASUSD_M1_<anno>.csv, ora di New York)"""
import sys, glob, math, itertools, datetime as D
COSTO = 2.0; RMIN = 8.0; MIN_O = 510; MIN_A = 570; MIN_C = 960

def carica(d):
    g = {}
    for f in sorted(glob.glob(d + '/NASUSD_M1_*.csv')):
        for ln in open(f, encoding='utf-8-sig'):
            if ln[:4] < '2015' or ln[0] == 'T': continue
            p = ln.split(',')
            day = p[0][:10]; mm = int(p[0][11:13]) * 60 + int(p[0][14:16])
            if MIN_O <= mm <= MIN_C: g.setdefault(day, {})[mm] = (float(p[1]), float(p[2]), float(p[3]), float(p[4]))
    return g

def uscita(b, i0, side, sl, tp, ent):
    """b: dict minuto->barra; scorre dal minuto i0; restituisce pnl lordo in punti"""
    for m in range(i0, MIN_C):
        x = b.get(m)
        if x is None: continue
        o, h, l, c = x
        if side == 1:
            if l <= sl: return sl - ent
            if h >= tp: return tp - ent
        else:
            if h >= sl: return ent - sl
            if l <= tp: return ent - tp
    last = max((m for m in b if m < MIN_C), default=None)
    if last is None: return 0.0
    c = b[last][3]
    return (c - ent) if side == 1 else (ent - c)

def m1(b, bf, rr, E):
    pre = [b[m] for m in range(MIN_O, MIN_A) if m in b]
    if len(pre) < 45: return None
    H = max(x[1] for x in pre); L = min(x[2] for x in pre); buf = bf * (H - L)
    up = H + buf; dn = L - buf; R = up - dn
    if R < RMIN: return None
    for m in range(MIN_A, MIN_A + E):
        x = b.get(m)
        if x is None: continue
        o, h, l, c = x; tu = h >= up; td = l <= dn
        if tu and td: return -R
        if tu: return uscita(b, m + 1, 1, dn, up + rr * R, up)
        if td: return uscita(b, m + 1, -1, up, dn - rr * R, dn)
    return None

def m3(b, OR, slmode, rr):
    rng = [b[m] for m in range(MIN_A, MIN_A + OR) if m in b]
    if len(rng) < OR * 0.8: return None
    H = max(x[1] for x in rng); L = min(x[2] for x in rng)
    t = MIN_A + OR
    while t + 5 <= 690:
        bars = [b[m] for m in range(t, t + 5) if m in b]
        if bars:
            c = bars[-1][3]; e = b.get(t + 5)
            if e is None: t += 5; continue
            ent = e[0]
            for side, brk in ((1, c > H), (-1, c < L)):
                if not brk: continue
                sl = L if slmode == 'opp' else (H + L) / 2
                if side == -1: sl = H if slmode == 'opp' else (H + L) / 2
                R = abs(ent - sl)
                if R < RMIN or (side == 1 and sl >= ent) or (side == -1 and sl <= ent): return None
                tp = ent + side * rr * R
                # barra di entrata inclusa (SL prima); uscita dal minuto t+5
                return uscita(b, t + 5, side, sl, tp, ent)
        t += 5
    return None

def serie(g, a, z, f):
    out = []
    for day in sorted(g):
        if not (a <= day[:4] <= z): continue
        if D.date(int(day[:4]), int(day[5:7]), int(day[8:10])).weekday() >= 5: continue
        p = f(g[day])
        if p is not None: out.append((day, p - COSTO))
    return out

def metr(v):
    n = len(v)
    if n < 3: return n, 0, 0, 0, {}
    x = [p for _, p in v]; tot = sum(x); gp = sum(i for i in x if i > 0); gl = -sum(i for i in x if i < 0)
    mu = tot / n; sd = math.sqrt(sum((i - mu) ** 2 for i in x) / (n - 1)); an = {}
    for d, p in v: an[d[:4]] = an.get(d[:4], 0) + p
    return n, tot, (gp / gl if gl > 0 else 9.99), (mu / (sd / math.sqrt(n)) if sd > 0 else 0), an

def ok(m, anni_tot):
    n, tot, pf, t, an = m
    return n >= 100 and tot > 0 and pf >= 1.2 and t >= 2.0 and sum(1 for v in an.values() if v > 0) >= 2

if __name__ == '__main__':
    g = carica(sys.argv[1]); sets = []
    for bf, rr, E in itertools.product((0, 0.1), (1, 1.5, 2), (120, 390)):
        sets.append(('M1 buf%.1f rr%.1f E%d' % (bf, rr, E), (lambda bf, rr, E: lambda b: m1(b, bf, rr, E))(bf, rr, E)))
    for OR, sm, rr in itertools.product((15, 30), ('opp', 'mid'), (1, 2)):
        sets.append(('M3 OR%d sl-%s rr%d' % (OR, sm, rr), (lambda OR, sm, rr: lambda b: m3(b, OR, sm, rr))(OR, sm, rr)))
    print('--- SELEZIONE 2015-2017 (punti netti, costo 2,0): n, netto, PF, t, per anno ---')
    sel = []
    for nome, f in sets:
        m = metr(serie(g, '2015', '2017', f)); n, tot, pf, t, an = m
        print('%-22s n=%4d netto %+8.0f PF %.2f t %+.2f %s %s' % (nome, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m, 3) else ''))
        if ok(m, 3): sel.append((t, nome, f))
    sel.sort(key=lambda x: -x[0]); cand = sel[:3]
    print('passano: %d | candidati: %s' % (len(sel), [c[1] for c in cand] or 'NESSUNO'))
    for t, nome, f in cand:
        m = metr(serie(g, '2018', '2020', f)); n, tot, pf, tt, an = m
        print('VALIDAZIONE 2018-2020 %s n=%d netto %+.0f PF %.2f t %+.2f anni %s -> %s' % (nome, n, tot, pf, tt, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok(m, 3) else 'NO'))
