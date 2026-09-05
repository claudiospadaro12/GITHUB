#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - LEAD-LAG CROSS-ASSET A M30 (indice vs valuta della stessa area)
# Fonte dati: github FutureSharks/financial-data, cartella Oanda (M1 con volume, GPL-3.0), fuso UTC.
# UN SOLO PROVIDER per entrambe le gambe: nessun disallineamento di feed.
# NON e' il nostro broker, NON ci sono costi. Misura CORRELAZIONE RITARDATA e CONDIZIONAMENTO.
import os, glob, csv
from collections import defaultdict
from statistics import mean, pstdev, median

def load_oanda(paths):
    out = {}  # 'YYYY-MM-DD HH:MM' -> close
    for p in sorted(paths):
        with open(p) as f:
            r = csv.DictReader(f)
            for row in r:
                out[row['time'][:16]] = float(row['close'])
    return out

def to_m30(closes):
    """closes: dict 'YYYY-MM-DD HH:MM'->px. Ritorna dict slot30 -> ultimo close della mezz'ora."""
    agg = {}
    for k in sorted(closes.keys()):
        d = k[:10]; hh = int(k[11:13]); mm = int(k[14:16])
        slot = f"{d} {hh:02d}:{(mm//30)*30:02d}"
        agg[slot] = closes[k]   # sorted -> l'ultimo vince
    return agg

def rets(agg):
    ks = sorted(agg.keys())
    out = []
    for i in range(1, len(ks)):
        # solo barre consecutive dello stesso giorno
        if ks[i][:10] != ks[i-1][:10]: continue
        p0, p1 = agg[ks[i-1]], agg[ks[i]]
        if p0 <= 0: continue
        out.append((ks[i], (p1-p0)/p0))
    return out

def corr(xs, ys):
    n = len(xs)
    if n < 30: return 0.0
    mx, my = mean(xs), mean(ys)
    sx, sy = pstdev(xs), pstdev(ys)
    if sx == 0 or sy == 0: return 0.0
    return sum((a-mx)*(b-my) for a, b in zip(xs, ys)) / (n*sx*sy)

def tstat(xs):
    n = len(xs)
    if n < 5: return 0.0
    m, s = mean(xs), pstdev(xs)
    return 0.0 if s == 0 else m/(s/(n**0.5))

if __name__ == '__main__':
    S = os.environ['S']
    IDX, FX = 'FR40_EUR', 'EUR_USD'
    idx = to_m30(load_oanda(glob.glob(f"{S}/oanda/{IDX}_*.csv")))
    fx  = to_m30(load_oanda(glob.glob(f"{S}/oanda/{FX}_*.csv")))
    ri = dict(rets(idx)); rf = dict(rets(fx))
    # finestra cash euro: 08:00-16:00 UTC (= 09:00-17:00 CET, 07:00-15:00 ora server BCM)
    ks = sorted(k for k in ri.keys() if k in rf and 8 <= int(k[11:13]) < 16)
    print(f"# {IDX} x {FX} -- barre M30 appaiate in sessione cash 08:00-16:00 UTC: {len(ks)}")
    print(f"# giorni: {len(set(k[:10] for k in ks))}")
    kset = {k: i for i, k in enumerate(ks)}
    # correlazione a lag: r_idx(t) vs r_fx(t-lag)
    print(f"\n{'lag(barre M30)':>16} {'n':>6} {'corr idx(t) ~ fx(t-lag)':>26}")
    for lag in (0, 1, 2, 3):
        xs, ys = [], []
        for i in range(lag, len(ks)):
            # richiedi contiguita' temporale reale
            if ks[i][:10] != ks[i-lag][:10]: continue
            xs.append(ri[ks[i]]); ys.append(rf[ks[i-lag]])
        print(f"{lag:>16} {len(xs):6d} {corr(xs, ys):26.4f}")

    # condizionamento: dopo una mezz'ora di FX oltre soglia, cosa fa l'indice la mezz'ora dopo?
    sig = pstdev([rf[k] for k in ks])
    print(f"\n# deviazione standard del rendimento M30 di {FX}: {sig*100:.4f}%")
    base = [ri[k] for k in ks]
    print(f"# BASE (tutte le barre)  n={len(base)}  media {mean(base)*1e4:+.3f} bp  t {tstat(base):+.2f}  %>0 {100*sum(1 for x in base if x>0)/len(base):.1f}")
    for mult in (1.0, 1.5, 2.0):
        for direction in (-1, +1):
            xs = []
            for i in range(1, len(ks)):
                if ks[i][:10] != ks[i-1][:10]: continue
                prev = rf[ks[i-1]]
                if direction < 0 and prev <= -mult*sig: xs.append(ri[ks[i]])
                if direction > 0 and prev >= +mult*sig: xs.append(ri[ks[i]])
            if len(xs) < 30: continue
            lab = f"{FX} {'<= -' if direction<0 else '>= +'}{mult:.1f} sigma"
            wr = 100*sum(1 for x in xs if x > 0)/len(xs)
            print(f"# {lab:22s} -> {IDX} barra dopo: n={len(xs):5d}  media {mean(xs)*1e4:+.3f} bp  "
                  f"t {tstat(xs):+.2f}  %>0 {wr:.1f}  (base {100*sum(1 for x in base if x>0)/len(base):.1f})")
