#!/usr/bin/env python3
# SONDA POST-NEWS 2 -- stabilita' per anno, t-stat, mediana, + meccanismo SWEEP.
# Stessi limiti dichiarati della sonda 1.
import csv, os, glob, random, statistics as st, datetime as dt
from collections import defaultdict
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "sonda_postnews.py")).read().split("def main()")[0])

def simula_sweep(bars, t_start, t_exp, px_up, px_dn, sl_pip, tp_pip):
    """LIQUIDITY SWEEP: il primo strappo oltre il range e' una spazzata.
    Si entra nel verso OPPOSTO quando il prezzo RIENTRA nel range."""
    armato = None   # 'up' o 'dn' = lato spazzato
    pos = None
    pips = 0.0; nfill = 0
    t = t_start
    while t < t_exp:
        b = bars.get(t)
        if not b: t += dt.timedelta(minutes=1); continue
        o, h, l, c = b
        if pos:
            v, e, sl, tp = pos
            if v > 0:
                if l <= sl: pips += (sl-e)/PIP; pos=None
                elif h >= tp: pips += (tp-e)/PIP; pos=None
            else:
                if h >= sl: pips += (e-sl)/PIP; pos=None
                elif l <= tp: pips += (e-tp)/PIP; pos=None
        elif armato is None:
            if h >= px_up: armato = "up"
            elif l <= px_dn: armato = "dn"
        else:
            # rientro nel range -> entra al contrario
            if armato == "up" and c < px_up:
                v = -1; e = c
            elif armato == "dn" and c > px_dn:
                v = +1; e = c
            else:
                t += dt.timedelta(minutes=1); continue
            nfill += 1
            pos = (v, e, e - v*sl_pip*PIP, e + v*tp_pip*PIP)
            armato = "fatto"
        t += dt.timedelta(minutes=1)
    if pos:
        tc = t_exp
        for _ in range(30):
            if bars.get(tc): break
            tc -= dt.timedelta(minutes=1)
        b = bars.get(tc)
        if b: pips += pos[0]*(b[3]-pos[1])/PIP
    return pips, nfill, []

def stat(nome, res, anni):
    n = len(res); v = [r[0] for r in res]
    if n < 5: print(f"{nome:32s} n={n}"); return
    m = st.mean(v); sd = st.pstdev(v) or 1e-9
    t = m / (sd / (n ** 0.5))
    med = st.median(v)
    gw = sum(x for x in v if x > 0); gl = -sum(x for x in v if x < 0)
    pf = gw/gl if gl > 0 else float("inf")
    pa = defaultdict(float)
    for (r, a) in zip(res, anni): pa[a] += r[0]
    pos = sum(1 for a in pa if pa[a] > 0)
    print(f"{nome:32s} n={n:4d} media={m:6.2f} mediana={med:6.2f} t={t:5.2f} "
          f"PF={pf:5.2f} anni_positivi={pos}/{len(pa)}  " +
          " ".join(f"{a%100:02d}:{pa[a]:+6.0f}" for a in sorted(pa)))

def main():
    print("carico barre M1 EUR_USD ...")
    bars = carica_barre()
    print(f"barre: {len(bars):,}  {min(bars):%Y-%m-%d} -> {max(bars):%Y-%m-%d}\n")
    BLOCCHI = {
        "ISM/CB 15:00": (["ISM Manufacturing PMI","ISM Services PMI","CB Consumer Confidence"], 70),
        "13:30 CPI/Retail/PPI": (["CPI m/m","Core CPI m/m","Retail Sales m/m",
                                  "Core Retail Sales m/m","PPI m/m"], 60),
    }
    for nb, (titoli, durata) in BLOCCHI.items():
        eventi = carica_eventi(titoli)
        var = defaultdict(list); anni = []
        for t_ev, tit in eventi:
            rng = range_finestra(bars, t_ev, 5, 15)
            if rng is None: continue
            hi, lo = rng
            anni.append(t_ev.year)
            t_act = t_ev + dt.timedelta(minutes=15)
            t_exp = t_act + dt.timedelta(minutes=durata)
            up = hi + 3.0*PIP; dn = lo - 2.0*PIP
            var["A breakout OCO=off (replica)"].append(simula(bars,t_act,t_exp,up,dn,+1,-1,25,30,False))
            var["B breakout OCO=ON"].append(simula(bars,t_act,t_exp,up,dn,+1,-1,25,30,True))
            var["D fade OCO=ON"].append(simula(bars,t_act,t_exp,up,dn,-1,+1,25,30,True))
            var["E breakout tempo 30'"].append(simula(bars,t_act,t_exp,up,dn,+1,-1,25,9999,True,exit_min=30))
            var["F fade tempo 30'"].append(simula(bars,t_act,t_exp,up,dn,-1,+1,25,9999,True,exit_min=30))
            var["H liquidity sweep"].append(simula_sweep(bars,t_act,t_exp,up,dn,25,30))
            m = random.randint(0, max(0,durata-5)); t_r = t_act+dt.timedelta(minutes=m)
            br = bars.get(t_r); k=0
            while br is None and k<20: t_r+=dt.timedelta(minutes=1); br=bars.get(t_r); k+=1
            if br:
                vv = random.choice([+1,-1]); px = br[0]
                var["G CASUALE"].append(simula(bars,t_r,t_exp, px if vv>0 else 1e9,
                                               px if vv<0 else -1e9,+1,-1,25,30,True))
            else: var["G CASUALE"].append((0.0,0,[]))
        print("="*150); print(f"BLOCCO {nb}   eventi usati: {len(anni)}"); print("="*150)
        for k in sorted(var): stat(k, var[k], anni)
        print()

main()
