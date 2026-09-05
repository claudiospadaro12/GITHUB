#!/usr/bin/env python3
# Taglio IS/OOS per EPOCA sul solo candidato con t>2, + ampiezza del range post-notizia.
import os, statistics as st, datetime as dt
from collections import defaultdict
exec(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "sonda_postnews.py")).read().split("def main()")[0])

def rep(nome, v):
    if len(v) < 5: print(f"{nome:38s} n={len(v)}"); return
    m = st.mean(v); sd = st.pstdev(v) or 1e-9; t = m/(sd/len(v)**0.5)
    gw = sum(x for x in v if x>0); gl = -sum(x for x in v if x<0)
    pf = gw/gl if gl>0 else float('inf')
    print(f"{nome:38s} n={len(v):4d} media={m:6.2f} t={t:5.2f} PF={pf:5.2f} tot={sum(v):8.1f}")

bars = carica_barre()
eventi = carica_eventi(["ISM Manufacturing PMI","ISM Services PMI","CB Consumer Confidence"])
E=defaultdict(list); B=defaultdict(list); amp=[]
for t_ev,_ in eventi:
    rng = range_finestra(bars,t_ev,5,15)
    if rng is None: continue
    hi,lo = rng; amp.append((hi-lo)/PIP)
    ta = t_ev+dt.timedelta(minutes=15); te = ta+dt.timedelta(minutes=70)
    up = hi+3.0*PIP; dn = lo-2.0*PIP
    e = simula(bars,ta,te,up,dn,+1,-1,25,9999,True,exit_min=30)[0]
    b = simula(bars,ta,te,up,dn,+1,-1,25,30,True)[0]
    ep = "2010-2011" if t_ev.year<=2011 else "2012-2020"
    E[ep].append(e); B[ep].append(b); E["tutto"].append(e); B["tutto"].append(b)

print("AMPIEZZA del range post-notizia (2 candele M5, ISM/CB), in pip EURUSD:")
print(f"   mediana={st.median(amp):5.1f}  media={st.mean(amp):5.1f}  "
      f"decile10={sorted(amp)[len(amp)//10]:4.1f}  decile90={sorted(amp)[9*len(amp)//10]:4.1f}  n={len(amp)}")
print(f"   -> lo SL di 25 pip vale {25/st.median(amp):4.2f} volte il range mediano\n")
for ep in ["tutto","2010-2011","2012-2020"]:
    print(f"--- epoca {ep} ---")
    rep("E breakout + uscita a tempo 30'", E[ep])
    rep("B breakout OCO=ON  TP30/SL25",    B[ep])
