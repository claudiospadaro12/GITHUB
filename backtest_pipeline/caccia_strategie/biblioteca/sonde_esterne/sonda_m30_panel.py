#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - PANNELLO CROSS-SEZIONALE OVERNIGHT->INTRADAY
# + LA DIAGNOSI DELL'ARTEFATTO CHE LA UCCIDE (look-ahead fra fusi orari).
#
# Replica la FORMA del paper "Overnight-Intraday Reversal Everywhere"
# (Della Corte, Kosowski, Liu, Wang -- [LETTO-VIA-SEARCH], PDF mai aperto):
# ogni giorno LONG l'asset col rendimento notturno piu' BASSO, SHORT il piu' ALTO,
# tenendo ciascuna gamba nella PROPRIA sessione cash.
#
# >>> IL RISULTATO GREZZO E' UN ARTEFATTO, E QUESTA SONDA LO DIMOSTRA IN TRE MOSSE:
#   (1) scomposizione per COPPIA: tutto il P/L sta nelle coppie EUROPA-vs-USA,
#       e la sola coppia a stesso orario (DAX vs ESTX50) e' NEGATIVA;
#   (2) ingresso ritardato di 1-2 barre M30: l'effetto non muore -> non e' prezzo stantio;
#   (3) LA CAUSA VERA: il "rendimento notturno" dell'S&P va dalla sua chiusura
#       (22:00 CET di ieri) alla sua apertura (15:30 CET di OGGI) e quindi CONTIENE
#       tutta la seduta europea di oggi. Ordinare su quella variabile per decidere
#       un trade sul DAX che parte alle 09:00 CET E' LOOK-AHEAD.
#
# Fonte dati: github FutureSharks/financial-data (histdata M1, GPL-3.0), fuso EST.
import os, glob
from collections import defaultdict
from statistics import mean, median, pstdev
import random

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
                bars.append((ts[0:8], int(ts[9:11]), int(ts[11:13]),
                             float(parts[1]), float(parts[2]), float(parts[3]), float(parts[4])))
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

def build(S, sym, cfg, delay_bars):
    a,b_,c,d_ = cfg
    bb = aggregate(load_m1(sorted(glob.glob(f"{S}/dati/{sym}_*.csv"))), 30)
    byday = defaultdict(list)
    for x in bb: byday[x[0]].append(x)
    ses = []
    for d in sorted(byday):
        xs = [x for x in byday[d]
              if (x[1] > a or (x[1] == a and x[2] >= b_))
              and (x[1] < c or (x[1] == c and x[2] <= d_))]
        if len(xs) < 8 + delay_bars: continue
        ses.append((d, xs[0][3], xs[delay_bars][3], xs[-1][6]))
    rows = {}
    for i in range(1, len(ses)):
        day, op, opd, cl = ses[i]; _,_,_,pcl = ses[i-1]
        if pcl > 0 and opd > 0:
            rows[day] = ((op-pcl)/pcl, (cl-opd)/opd)
    return rows

# sessioni cash in ora EST del feed histdata
CFG = {'GRXEUR': (3,0,11,30),    # DAX      09:00-17:30 CET
       'ETXEUR': (3,0,11,30),    # ESTX50   09:00-17:30 CET
       'SPXUSD': (9,30,16,0)}    # S&P500   09:30-16:00 ET

if __name__ == '__main__':
    S = os.environ['S']
    for delay in (0, 1, 2):
        data = {s: build(S, s, c, delay) for s, c in CFG.items()}
        common = sorted(set.intersection(*[set(v) for v in data.values()]))
        syms = list(CFG)
        pnl = []; bypair = defaultdict(list)
        for day in common:
            rank = sorted(syms, key=lambda s: data[s][day][0])
            lo, hi = rank[0], rank[-1]
            r = data[lo][day][1] - data[hi][day][1]
            pnl.append(r); bypair[(lo,hi)].append(r)
        print(f"\n=== INGRESSO {30*delay} MIN DOPO L'APERTURA | n={len(pnl)}")
        print(f"    TOTALE media {mean(pnl)*1e4:+7.2f} bp  t {tstat(pnl):+6.2f}  "
              f"%>0 {100*sum(1 for x in pnl if x>0)/len(pnl):5.1f}  mediana {median(pnl)*1e4:+7.2f}")
        for k in sorted(bypair, key=lambda k: -len(bypair[k])):
            v = bypair[k]
            same = "  <- STESSO ORARIO (cella pulita)" if {k[0],k[1]} == {'GRXEUR','ETXEUR'} else ""
            print(f"      long {k[0]:6s} / short {k[1]:6s} n={len(v):4d} media {mean(v)*1e4:+7.2f} bp "
                  f"t {tstat(v):+6.2f} %>0 {100*sum(1 for x in v if x>0)/len(v):5.1f}{same}")
        if delay == 0:
            random.seed(12345)
            ctrl = []
            for day in common:
                a2, b2 = random.sample(syms, 2)
                ctrl.append(data[a2][day][1] - data[b2][day][1])
            print(f"    CONTROLLO CASUALE (coppia a caso): media {mean(ctrl)*1e4:+.2f} bp  t {tstat(ctrl):+.2f}")
