#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - REVERSIONE OVERNIGHT -> INTRADAY (versione SERIE STORICA)
# Meccanismo: "Overnight-Intraday Reversal Everywhere" (Della Corte, Kosowski, Liu, Wang)
#   [LETTO-VIA-SEARCH: PDF NON APERTO, tre domini murati]
# Qui NON si replica il paper (che e' CROSS-SEZIONALE su panieri grandi):
# si misura la sua versione UNIVARIATA, l'unica traducibile su 4 indici.
#
# CRITERI CONGELATI PRIMA DI VEDERE UN NUMERO:
#   K1 TAGLIA      il bucket estremo deve dare |media R_intraday| >= 3x spread misurato
#                  (D30EUR 1,65 -> 4,95 punti indice; per gli altri si converte in bp)
#   K2 SEGNO       t-stat |t| >= 2,00 sul bucket estremo
#   K3 MONOTONIA   la media di R_intraday deve DECRESCERE al crescere di R_overnight
#                  su tutti e 5 i bucket. Se salta, e' rumore (e' il criterio che ha
#                  ucciso il test cross-asset di stamattina).
#   K4 DUE LATI    entrambi i bucket estremi devono avere lo stesso comportamento,
#                  di segno opposto.
# Fonte dati: github FutureSharks/financial-data (histdata M1, GPL-3.0), fuso EST.
import sys, os, glob
from collections import defaultdict
from statistics import mean, median, pstdev

def load_m1(paths):
    bars = []
    for p in sorted(paths):
        with open(p) as f:
            for line in f:
                line = line.strip()
                if not line: continue
                parts = line.split(';')
                if len(parts) < 5: continue
                ts = parts[0]
                o,h,l,c = float(parts[1]),float(parts[2]),float(parts[3]),float(parts[4])
                bars.append((ts[0:8], int(ts[9:11]), int(ts[11:13]), o,h,l,c))
    return bars

def aggregate(bars, minutes):
    out = []; cur = None
    for (d,hh,mm,o,h,l,c) in bars:
        slot = (d, hh, (mm//minutes)*minutes)
        if cur is None or cur[0] != slot:
            if cur is not None: out.append(cur[1])
            cur = (slot, [slot[0], slot[1], slot[2], o,h,l,c])
        else:
            b = cur[1]
            if h > b[4]: b[4] = h
            if l < b[5]: b[5] = l
            b[6] = c
    if cur is not None: out.append(cur[1])
    return out

def tstat(xs):
    n = len(xs)
    if n < 5: return 0.0
    m, s = mean(xs), pstdev(xs)
    return 0.0 if s == 0 else m/(s/(n**0.5))

def sessions(b, lo_h, lo_m, hi_h, hi_m):
    """Ritorna [(giorno, open, close)] della sessione cash, su barre M30."""
    byday = defaultdict(list)
    for x in b: byday[x[0]].append(x)
    out = []
    for d in sorted(byday):
        xs = [x for x in byday[d]
              if (x[1] > lo_h or (x[1] == lo_h and x[2] >= lo_m))
              and (x[1] < hi_h or (x[1] == hi_h and x[2] <= hi_m))]
        if len(xs) < 8: continue
        out.append((d, xs[0][3], xs[-1][6]))
    return out

def run(sym, files, lo_h, lo_m, hi_h, hi_m):
    bars = load_m1(files)
    b = aggregate(bars, 30)
    ses = sessions(b, lo_h, lo_m, hi_h, hi_m)
    rows = []
    for i in range(1, len(ses)):
        d, op, cl = ses[i]
        _, _, pcl = ses[i-1]
        if pcl <= 0 or op <= 0: continue
        rows.append((d, (op-pcl)/pcl, (cl-op)/op, cl-op, op))
    print(f"\n########## {sym}: {len(bars)} barre M1, {len(ses)} sessioni, {len(rows)} coppie notte/giorno")
    rows.sort(key=lambda r: r[1])
    n = len(rows); q = n//5
    print(f"  {'bucket R_overnight':>20} {'n':>5} {'R_on medio bp':>14} {'R_intraday medio bp':>20} "
          f"{'punti indice':>13} {'t':>6} {'%>0':>6}")
    means = []
    for k in range(5):
        lo = k*q; hi = (k+1)*q if k < 4 else n
        chunk = rows[lo:hi]
        rid = [r[2] for r in chunk]
        pts = [r[3] for r in chunk]
        means.append(mean(rid))
        print(f"  {'Q'+str(k+1):>20} {len(chunk):5d} {mean(r[1] for r in chunk)*1e4:14.1f} "
              f"{mean(rid)*1e4:20.2f} {mean(pts):13.2f} {tstat(rid):6.2f} "
              f"{100*sum(1 for x in rid if x>0)/len(rid):6.1f}")
    mono = all(means[i] >= means[i+1] for i in range(4))
    print(f"  K3 MONOTONIA decrescente su 5 bucket: {'PASSA' if mono else 'FALLITA'}")
    # spread di Q1 vs Q5 = il long/short della tesi
    q1 = [r[2] for r in rows[:q]]; q5 = [r[2] for r in rows[-q:]]
    ls = [a for a in q1] + [-b for b in q5]
    print(f"  LONG Q1 + SHORT Q5 (2 op/giorno): media {mean(ls)*1e4:+.2f} bp  t {tstat(ls):+.2f}  "
          f"%>0 {100*sum(1 for x in ls if x>0)/len(ls):.1f}  n={len(ls)}")
    pts_ls = [r[3] for r in rows[:q]] + [-r[3] for r in rows[-q:]]
    print(f"  ... in PUNTI INDICE: media {mean(pts_ls):+.2f}  mediana {median(pts_ls):+.2f}")

if __name__ == '__main__':
    S = os.environ['S']
    run("GRXEUR (DAX) cash 03:00-11:30 EST", sorted(glob.glob(f"{S}/dati/GRXEUR_*.csv")), 3, 0, 11, 30)
    run("SPXUSD (S&P500) cash 09:30-16:00 EST", sorted(glob.glob(f"{S}/dati/SPXUSD_*.csv")), 9, 30, 16, 0)
