#!/usr/bin/env python3
"""accordo_score.py (A4) - accordo fra due serie di score (data;score_overall), criterio v2 punto 10:
segno concorde >= 85% dei giorni, kappa di Cohen >= 0,70 sui tre stati, correlazione >= 0,90.
Uso: python3 -I accordo_score.py a.csv b.csv [data_inizio=2008-07-01]"""
import sys, csv, math, datetime as dt


def leggi(p):
    m = {}
    for r in csv.DictReader(open(p, newline=''), delimiter=';'):
        v = r['score_overall'].strip()
        m[dt.date.fromisoformat(r['data'].strip().replace('.', '-'))] = float(v) if v not in ('', 'nan', 'None') else None
    return m


def st(s):
    return 1 if s >= 15 else (-1 if s <= -15 else 0)


a, b = leggi(sys.argv[1]), leggi(sys.argv[2])
d0 = dt.date.fromisoformat(sys.argv[3]) if len(sys.argv) > 3 else dt.date(2008, 7, 1)
ds = sorted(d for d in a if d in b and d >= d0 and a[d] is not None and b[d] is not None)
n = len(ds)
xs, ys = [a[d] for d in ds], [b[d] for d in ds]
segno = sum(1 for x, y in zip(xs, ys) if (x > 0) == (y > 0)) / n
sa, sb = [st(x) for x in xs], [st(y) for y in ys]
stat = sum(1 for x, y in zip(sa, sb) if x == y) / n
pe = sum((sa.count(k) / n) * (sb.count(k) / n) for k in (-1, 0, 1))
kappa = (stat - pe) / (1 - pe)
mx, my = sum(xs) / n, sum(ys) / n
cov = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
corr = cov / math.sqrt(sum((x - mx) ** 2 for x in xs) * sum((y - my) ** 2 for y in ys))
print('giorni confrontati %d (dal %s)\nsegno concorde %.1f%% (soglia 85%%)\naccordo sui 3 stati %.1f%% | kappa di Cohen %.3f (soglia 0,70)\ncorrelazione degli score grezzi %.3f (soglia 0,90)' % (
    n, d0, 100 * segno, 100 * stat, kappa, corr))
