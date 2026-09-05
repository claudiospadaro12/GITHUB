#!/usr/bin/env python3
# Stessa sonda su XAU_USD. La geometria e' SCALATA sul range post-notizia
# dell'oro con gli STESSI rapporti misurati su EURUSD:
#   offset_buy = 0.23 x range_mediano   offset_sell = 0.15 x range_mediano
#   SL = 1.89 x range_mediano           TP = 2.27 x range_mediano
# (su EURUSD: range mediano 13,2 pip -> 3 / 2 / 25 / 30 pip)
import os, glob, csv, random, statistics as st, datetime as dt
from collections import defaultdict
SRC = os.path.join(os.path.dirname(os.path.abspath(__file__)), "sonda_postnews.py")
exec(open(SRC).read().split("def main()")[0])

def carica_oro():
    bars = {}
    for f in sorted(glob.glob(os.path.join(DIR, "dati", "XAU_USD", "*.csv"))):
        for row in csv.DictReader(open(f)):
            t = dt.datetime.strptime(row["time"], "%Y-%m-%d %H:%M:%S")
            bars[t] = (float(row["open"]), float(row["high"]), float(row["low"]), float(row["close"]))
    return bars

def rep(nome, res, anni):
    v = [r[0] for r in res]
    if len(v) < 5: print(f"{nome:34s} n={len(v)}"); return
    m = st.mean(v); sd = st.pstdev(v) or 1e-9; t = m/(sd/len(v)**0.5)
    gw = sum(x for x in v if x>0); gl = -sum(x for x in v if x<0)
    pf = gw/gl if gl>0 else float('inf')
    pa = defaultdict(float)
    for r,a in zip(res,anni): pa[a]+=r[0]
    print(f"{nome:34s} n={len(v):4d} media={m:7.2f} t={t:5.2f} PF={pf:5.2f} "
          f"anni+={sum(1 for a in pa if pa[a]>0)}/{len(pa)}  "+" ".join(f"{a%100:02d}:{pa[a]:+6.0f}" for a in sorted(pa)))

bars = carica_oro()
print(f"barre M1 XAU_USD: {len(bars):,}  {min(bars):%Y-%m-%d} -> {max(bars):%Y-%m-%d}\n")
BL = {"ISM/CB 15:00": (["ISM Manufacturing PMI","ISM Services PMI","CB Consumer Confidence"],70),
      "13:30 CPI/Retail/PPI": (["CPI m/m","Core CPI m/m","Retail Sales m/m","Core Retail Sales m/m","PPI m/m"],60)}
for nb,(tit,dur) in BL.items():
    ev = carica_eventi(tit)
    # 1a passata: ampiezza mediana del range in DOLLARI oro
    amp=[]
    for t_ev,_ in ev:
        r = range_finestra(bars,t_ev,5,15)
        if r: amp.append(r[0]-r[1])
    if not amp: continue
    R = st.median(amp)
    OB, OS, SL, TP = 0.23*R, 0.15*R, 1.89*R, 2.27*R
    print("="*150)
    print(f"BLOCCO {nb} su XAU_USD  |  range post-notizia mediano = {R:.2f} $  "
          f"-> offset {OB:.2f}/{OS:.2f}  SL {SL:.2f}  TP {TP:.2f} (dollari oro)")
    print("="*150)
    var=defaultdict(list); anni=[]
    for t_ev,_ in ev:
        r = range_finestra(bars,t_ev,5,15)
        if r is None: continue
        hi,lo = r; anni.append(t_ev.year)
        ta = t_ev+dt.timedelta(minutes=15); te = ta+dt.timedelta(minutes=dur)
        up, dn = hi+OB, lo-OS
        # qui PIP globale = 1.0 perche' lavoriamo direttamente in dollari oro
        var["A breakout OCO=off (replica)"].append(simula(bars,ta,te,up,dn,+1,-1,SL/PIP,TP/PIP,False))
        var["B breakout OCO=ON"].append(simula(bars,ta,te,up,dn,+1,-1,SL/PIP,TP/PIP,True))
        var["D fade OCO=ON"].append(simula(bars,ta,te,up,dn,-1,+1,SL/PIP,TP/PIP,True))
        var["E breakout tempo 30'"].append(simula(bars,ta,te,up,dn,+1,-1,SL/PIP,9e9,True,exit_min=30))
        m = random.randint(0,max(0,dur-5)); tr = ta+dt.timedelta(minutes=m)
        br = bars.get(tr); k=0
        while br is None and k<20: tr+=dt.timedelta(minutes=1); br=bars.get(tr); k+=1
        if br:
            vv = random.choice([+1,-1]); px=br[0]
            var["G CASUALE"].append(simula(bars,tr,te, px if vv>0 else 1e12, px if vv<0 else -1e12,
                                           +1,-1,SL/PIP,TP/PIP,True))
        else: var["G CASUALE"].append((0.0,0,[]))
    print(f"eventi usati: {len(anni)}   (valori in DOLLARI ORO per evento)")
    for k in sorted(var): rep(k,var[k],anni)
    print()
