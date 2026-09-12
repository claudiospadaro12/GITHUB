#!/usr/bin/env python3
# CODA AVVERSA DELLE NOTTI NEL 2020 (finestra COVID) -- SPX500_USD Oanda, UTC.
# I file histdata degli INDICI finiscono nel 2018 (404 su 2019 e 2020, VERIFICATO):
# per il 2020 si usa la cartella Oanda, che e' in UTC (LEGGIMI sonde_esterne, punto 2).
# DST USA 2020: inizia domenica 8 marzo. Sessione cash in UTC:
#   prima del 08/03 -> 14:30-21:00 ; dal 08/03 -> 13:30-20:00
import glob, datetime
from collections import defaultdict
from statistics import mean, median, pstdev

bars=[]
for p in sorted(glob.glob('oanda/SPX500_USD_2020_*.csv')):
    first=True
    for line in open(p):
        if first: first=False; continue
        q=line.strip().split(',')
        if len(q)<5: continue
        t=q[0]; d=t[0:10]; hh=int(t[11:13]); mm=int(t[14:16])
        bars.append((d, hh, mm, float(q[4]), float(q[2]), float(q[3]), float(q[1])))  # o,h,l,c
bars.sort()
print("barre M1 lette:", len(bars), "dal", bars[0][0], "al", bars[-1][0])

DST = datetime.date(2020,3,8)
byday=defaultdict(list)
for b in bars:
    y,m,dd = int(b[0][:4]), int(b[0][5:7]), int(b[0][8:10])
    dt = datetime.date(y,m,dd)
    lo,hi = (13*60+30, 20*60) if dt>=DST else (14*60+30, 21*60)
    t=b[1]*60+b[2]
    if lo<=t<=hi: byday[b[0]].append(b)

S=[]
for d in sorted(byday):
    v=byday[d]
    if len(v)<60: continue
    S.append((d, v[0][3], v[-1][6]))
print("sedute usate:", len(S), "dal", S[0][0], "al", S[-1][0])

notte=[]; giorno=[]
for i in range(1,len(S)):
    pc=S[i-1][2]; o=S[i][1]; c=S[i][2]
    notte.append((S[i][0], (o-pc)/pc*100.0))
    giorno.append((S[i][0], (c-o)/o*100.0))
print(f"NOTTE  n={len(notte)}  media%={mean([x[1] for x in notte]):+8.5f}  mediana%={median([x[1] for x in notte]):+8.5f}  %pos={100*sum(1 for x in notte if x[1]>0)/len(notte):.1f}  sigma%={pstdev([x[1] for x in notte]):.4f}")
print(f"GIORNO n={len(giorno)}  media%={mean([x[1] for x in giorno]):+8.5f}  mediana%={median([x[1] for x in giorno]):+8.5f}")
print()
print("LE 10 NOTTI PEGGIORI (gen-mag 2020):")
for d,r in sorted(notte, key=lambda x:x[1])[:10]: print(f"   {d}  {r:+7.2f}%")
for s in (1.0,2.0,3.0,4.0):
    k=sum(1 for x in notte if x[1]<=-s)
    print(f"   notti <= -{s:.1f}% : {k:3d} su {len(notte)}  ({100*k/len(notte):.2f}%)")
