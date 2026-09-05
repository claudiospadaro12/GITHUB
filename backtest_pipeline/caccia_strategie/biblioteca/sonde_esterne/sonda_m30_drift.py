#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - DERIVA ORARIA A MEZZ'ORA (M30) SUGLI INDICI
# Meccanismo M27 della tassonomia (Knuteson arXiv:2010.01727; Lou-Polk-Skouras JFE 2019)
# Fonte dati: github FutureSharks/financial-data (histdata M1, GPL-3.0), fuso EST.
# NON e' il nostro broker, NON ci sono costi. Conta OCCASIONI e misura la TAGLIA.
import sys, os, glob
from collections import defaultdict
from statistics import median, mean, pstdev

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
                d = ts[0:8]; hh = int(ts[9:11]); mm = int(ts[11:13])
                bars.append((d, hh, mm, o,h,l,c))
    return bars

def aggregate(bars, minutes):
    out = []
    cur = None
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
    m = mean(xs); s = pstdev(xs)
    if s == 0: return 0.0
    return m / (s / (n ** 0.5))

def run(path_glob, label, sess_lo, sess_hi):
    """sess_lo/sess_hi = ora EST di inizio/fine sessione cash."""
    files = glob.glob(path_glob)
    bars = load_m1(files)
    b = aggregate(bars, 30)
    print(f"\n########## {label}: {len(bars)} barre M1 -> {len(b)} barre M30, {len(files)} file")

    # --- 1. rendimento per SLOT di mezz'ora, in punti indice ---
    slots = defaultdict(list)
    prev = None
    for x in b:
        d,hh,mm,o,h,l,c = x
        if prev is not None and prev[0] == d:
            slots[(hh,mm)].append(c - prev[6])
        prev = x
    print(f"  giorni distinti: {len(set(x[0] for x in b))}")
    print(f"  {'slot EST':>9} {'n':>5} {'media':>8} {'mediana':>8} {'t-stat':>7} {'somma':>10}")
    tot_sess = 0.0
    for k in sorted(slots.keys()):
        hh,mm = k
        v = slots[k]
        if len(v) < 20: continue
        insess = (sess_lo <= hh < sess_hi) or (hh == sess_hi and mm == 0)
        mark = "*" if insess else " "
        if insess: tot_sess += sum(v)
        print(f"  {mark}{hh:02d}:{mm:02d}   {len(v):5d} {mean(v):8.2f} {median(v):8.2f} {tstat(v):7.2f} {sum(v):10.1f}")

    # --- 2. sessione cash contro notte, per giorno ---
    byday = defaultdict(list)
    for x in b: byday[x[0]].append(x)
    days = sorted(byday.keys())
    intraday = []; overnight = []
    prev_close = None
    for d in days:
        xs = byday[d]
        sess = [x for x in xs if sess_lo <= x[1] < sess_hi or (x[1]==sess_hi and x[2]==0)]
        if len(sess) < 8:
            continue
        op = sess[0][3]; cl = sess[-1][6]
        intraday.append(cl - op)
        if prev_close is not None:
            overnight.append(op - prev_close)
        prev_close = cl
    print(f"  --- SESSIONE CASH {sess_lo:02d}:00-{sess_hi:02d}:00 EST, {len(intraday)} giorni")
    print(f"      INTRADAY  media {mean(intraday):7.2f}  mediana {median(intraday):7.2f}  "
          f"t {tstat(intraday):6.2f}  somma {sum(intraday):9.1f}  %giorni>0 {100*sum(1 for x in intraday if x>0)/len(intraday):.1f}")
    print(f"      OVERNIGHT media {mean(overnight):7.2f}  mediana {median(overnight):7.2f}  "
          f"t {tstat(overnight):6.2f}  somma {sum(overnight):9.1f}  %giorni>0 {100*sum(1 for x in overnight if x>0)/len(overnight):.1f}")

if __name__ == '__main__':
    S = os.environ['S']
    for y in sys.argv[1:]:
        run(f"{S}/dati/GRXEUR_{y}.csv", f"GRXEUR (DAX) {y}", 3, 11)
