#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""maxmin_dax.py - criteri: report/MAXMIN_NOTTE_DAX_CRITERI_2026-11-18.md. Uso: python3 -I maxmin_dax.py DIR (D30EUR_M1_<anno>.csv, ora di New York con DST USA)"""
import sys, glob, math, itertools, datetime as D
GAP = False; COSTMULT = 1.0; VALID = False

def nth_sunday(y, m, n):
    d = D.date(y, m, 1); d += D.timedelta((6 - d.weekday()) % 7); return d + D.timedelta(7 * (n - 1))
def last_sunday(y, m):
    d = D.date(y, m + 1, 1) - D.timedelta(1) if m < 12 else D.date(y, 12, 31)
    return d - D.timedelta((d.weekday() + 1) % 7)
_cache = {}
def lim(y):
    if y not in _cache:
        us0 = D.datetime.combine(nth_sunday(y, 3, 2), D.time(2)); us1 = D.datetime.combine(nth_sunday(y, 11, 1), D.time(2))
        eu0 = D.datetime.combine(last_sunday(y, 3), D.time(1)); eu1 = D.datetime.combine(last_sunday(y, 10), D.time(1))
        _cache[y] = (us0, us1, eu0, eu1)
    return _cache[y]
def ny_to_cet(t):
    us0, us1, eu0, eu1 = lim(t.year)
    utc = t + D.timedelta(hours=4 if us0 <= t < us1 else 5)
    return utc + D.timedelta(hours=2 if eu0 <= utc < eu1 else 1)

def carica(d):
    S = {}
    for f in sorted(glob.glob(d + '/D30EUR_M1_*.csv')):
        for ln in open(f, encoding='utf-8-sig'):
            if ln[0] == 'T': continue
            p = ln.split(',')
            t = D.datetime(int(p[0][:4]), int(p[0][5:7]), int(p[0][8:10]), int(p[0][11:13]), int(p[0][14:16]))
            c = ny_to_cet(t); mm = c.hour * 60 + c.minute
            if mm <= 720: S.setdefault(c.date(), {})[mm] = (float(p[1]), float(p[2]), float(p[3]), float(p[4]))
    return S

def giorno(b, box, stop, gest):
    a, z = (120, 480) if box == 'A' else (0, 360)
    bars = [b[m] for m in range(a, z) if m in b]
    if len(bars) < 0.6 * (z - a): return None
    H = max(x[1] for x in bars); L = min(x[2] for x in bars); SC = H / 12000.0
    buf = 10 * SC; buy = H + buf; sell = L - buf; cost = 2.0 * SC * COSTMULT
    T = [30 * SC, 87 * SC, 113 * SC] if gest == 'A' else [30 * SC]
    side = None
    canbuy = cansell = True
    if VALID:
        pre = max((m for m in b if m < 540), default=None)
        if pre is not None:
            pc = b[pre][3]
            if pc >= buy: canbuy = False
            if pc <= sell: cansell = False
    for m in range(540, 660):
        x = b.get(m)
        if x is None: continue
        tu = x[1] >= buy and canbuy; td = x[2] <= sell and cansell
        if tu and td: return None
        if tu or td:
            side = 1 if tu else -1; ent = buy if tu else sell
            if GAP: ent = max(buy, x[0]) if tu else min(sell, x[0])
            m0 = m; break
    if side is None: return None
    sl0 = 30 * SC if stop == 'S30' else (ent - (L - buf) if side == 1 else (H + buf) - ent)
    sl = ent - side * sl0; frac = 1.0 / len(T); rem = len(T); pnl = 0.0; k = 0
    x = b[m0]
    if (side == 1 and x[2] <= sl) or (side == -1 and x[1] >= sl): return -sl0 - cost
    for m in range(m0 + 1, 706):
        x = b.get(m)
        if x is None: continue
        o, h, l, c = x
        if (side == 1 and l <= sl) or (side == -1 and h >= sl):
            pnl += rem * frac * side * (sl - ent); rem = 0; break
        newsl = sl
        while k < len(T) and ((side == 1 and h >= ent + T[k]) or (side == -1 and l <= ent - T[k])):
            pnl += frac * T[k]; rem -= 1
            if gest == 'A': newsl = ent if k == 0 else ent + side * T[0]
            k += 1
        sl = newsl
        if rem == 0: break
    if rem > 0:
        last = max((m for m in b if m0 < m <= 705), default=None)
        px = b[last][3] if last else ent
        pnl += rem * frac * side * (px - ent)
    return pnl - cost

def serie(S, d0, d1, **k):
    out = []
    for d in sorted(S):
        if not (d0 <= d <= d1) or d.weekday() >= 5: continue
        p = giorno(S[d], **k)
        if p is not None: out.append((d, p))
    return out

def metr(v):
    n = len(v)
    if n < 3: return n, 0, 0, 0, 0
    x = [p for _, p in v]; tot = sum(x); gp = sum(i for i in x if i > 0); gl = -sum(i for i in x if i < 0)
    mu = tot / n; sd = math.sqrt(sum((i - mu) ** 2 for i in x) / (n - 1))
    return n, tot, (gp / gl if gl > 0 else 9.99), (mu / (sd / math.sqrt(n)) if sd > 0 else 0), 100 * sum(1 for i in x if i > 0) / n

if __name__ == '__main__':
    S = carica(sys.argv[1]); D0 = D.date; sel = []
    P1 = (D0(2019, 1, 1), D0(2020, 6, 30)); P2 = (D0(2020, 7, 1), D0(2023, 11, 30)); P3 = (D0(2024, 1, 1), D0(2024, 12, 31))
    print('--- SELEZIONE DAX 2019-01..2020-06 (punti equiv. 12.000, costo 2,0) ---')
    res = {}
    for box, stop, gest in itertools.product(('A', 'B'), ('S30', 'OPP'), ('A', 'B')):
        k = dict(box=box, stop=stop, gest=gest); v = serie(S, *P1, **k); m = metr(v); n, tot, pf, t, w = m; res[(box, stop, gest)] = m
        y19 = sum(p for d, p in v if d.year == 2019); y20 = sum(p for d, p in v if d.year == 2020)
        ok = n >= 100 and tot > 0 and pf >= 1.2 and t >= 2.0 and y19 > 0 and y20 > 0
        print('box%s stop=%-3s gest=%s n=%3d netto %+8.0f PF %.2f t %+.2f vinc %.0f%% | 2019 %+.0f 2020H1 %+.0f %s' % (box, stop, gest, n, tot, pf, t, w, y19, y20, 'PASSA' if ok else ''))
        if ok: sel.append((t, k))
    sel.sort(key=lambda x: -x[0]); cand = [c for _, c in sel[:3]]
    print('passano: %d | candidati: %s' % (len(sel), cand or 'NESSUNO'))
    ga = [(res[(b, s, 'A')][2], res[(b, s, 'B')][2]) for b in ('A', 'B') for s in ('S30', 'OPP')]
    print('gestione A (scala) PF > gestione B in %d coppie su 4' % sum(1 for a, b in ga if a > b))
    for k in cand:
        for nome, P in (('2020-07..2023-11 (altro indice europeo)', P2), ('DAX 2024', P3)):
            n, tot, pf, t, w = metr(serie(S, *P, **k)); print('VALIDAZIONE %s %s n=%d netto %+.0f PF %.2f t %+.2f vinc %.0f%%' % (k, nome, n, tot, pf, t, w))
