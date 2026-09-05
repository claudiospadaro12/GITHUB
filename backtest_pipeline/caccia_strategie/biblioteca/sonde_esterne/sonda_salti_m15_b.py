#!/usr/bin/env python3
# SONDA SALTO STATISTICO M15 - PARTE B: le tre domande che decidono
#   B1 il take in PUNTI (cancello 3x lo spread)
#   B2 l'edge sta nei salti CON notizia (= ABTG_PostNews, C4 lo boccia) o SENZA?
#   B3 il lato: salto in su e salto in giu' vanno uguale?  + tenuta per ANNO
# Stesse convenzioni della parte A. Dati esterni, ZERO costi. Occasioni, non verdetti.
import os, glob, math, random, statistics as st
from collections import defaultdict
S=os.environ['S']
import importlib.util
spec=importlib.util.spec_from_file_location("A", S+"/sonda_salti_m15.py")

C=math.sqrt(2.0/math.pi); K=156; H=12

def load_histdata(paths):
    out=[]
    for p in sorted(paths):
        with open(p) as f:
            for line in f:
                q=line.strip().split(';')
                if len(q)<5: continue
                ts=q[0]
                out.append((ts[0:8],int(ts[9:11]),int(ts[11:13]),float(q[1]),float(q[2]),float(q[3]),float(q[4])))
    return out
def load_oanda(paths):
    out=[]
    for p in sorted(paths):
        with open(p) as f:
            first=True
            for line in f:
                if first: first=False; continue
                q=line.strip().split(',')
                if len(q)<5: continue
                t=q[0]; d=t[0:4]+t[5:7]+t[8:10]
                out.append((d,int(t[11:13]),int(t[14:16]),float(q[4]),float(q[2]),float(q[3]),float(q[1])))
    return out
def aggregate(bars,minutes):
    out=[];cur=None
    for (d,hh,mm,o,h,l,c) in bars:
        slot=(d,hh,(mm//minutes)*minutes)
        if cur is None or cur[0]!=slot:
            if cur is not None: out.append(cur[1])
            cur=(slot,[slot[0],slot[1],slot[2],o,h,l,c])
        else:
            b=cur[1]
            if h>b[4]: b[4]=h
            if l<b[5]: b[5]=l
            b[6]=c
    if cur is not None: out.append(cur[1])
    return out
def atr(bars,n=14):
    out=[None]*len(bars); trs=[]; pc=None; s=0.0
    for i,b in enumerate(bars):
        h,l,c=b[4],b[5],b[6]
        tr=h-l if pc is None else max(h-l,abs(h-pc),abs(l-pc))
        trs.append(tr); pc=c
        if i>=n: s-=trs[i-n]
        s+=tr
        if i>=n-1: out[i]=s/n
    return out
def load_cal(path):
    ev=set()
    with open(path) as f:
        first=True
        for line in f:
            if first: first=False; continue
            q=line.strip().split(';')
            if len(q)<4: continue
            dt=q[0]
            ev.add((dt[0:4]+dt[5:7]+dt[8:10],int(dt[11:13])*60+int(dt[14:16])))
    return ev
import datetime
def us_dst(dstr):
    y=int(dstr[0:4]); day=datetime.date(y,int(dstr[4:6]),int(dstr[6:8]))
    mar=datetime.date(y,3,1); start=mar+datetime.timedelta(days=(6-mar.weekday())%7+7)
    nov=datetime.date(y,11,1); end=nov+datetime.timedelta(days=(6-nov.weekday())%7)
    return start<=day<end

def esito(b,i,s,lvl,n):
    e=b[i][6]
    for j in range(i+1,min(i+1+H,n)):
        if b[j][0]!=b[i][0]: break
        hi,lo=b[j][4],b[j][5]
        hs=(lo<=e-lvl) if s>0 else (hi>=e+lvl)
        ht=(hi>=e+lvl) if s>0 else (lo<=e-lvl)
        if hs: return 0
        if ht: return 1
    return -1

def studia(nome,b,sess,tz,cal,unita,soglie,seed=11):
    a=atr(b,14); n=len(b)
    r=[None]*n
    for i in range(1,n):
        if b[i][0]==b[i-1][0] and b[i-1][6]>0: r[i]=math.log(b[i][6]/b[i-1][6])
    z=[None]*n; buf=[]
    for i in range(n):
        if r[i] is None: continue
        if len(buf)>=K:
            pr=[abs(buf[j])*abs(buf[j-1]) for j in range(1,len(buf))]
            s2=sum(pr)/len(pr)
            if s2>0: z[i]=r[i]*C/math.sqrt(s2)
        buf.append(r[i])
        if len(buf)>K: buf.pop(0)
    h0,h1=sess
    ins=lambda x: h0<=x[1]*60+x[2]<h1
    giorni=len({x[0] for x in b if ins(x)})
    pool=[i for i in range(K+20,n-H-1) if a[i] and ins(b[i]) and z[i] is not None]
    rng=random.Random(seed)
    def is_news(i):
        d=b[i][0]; t=b[i][1]*60+b[i][2]
        off=(4*60 if us_dst(d) else 5*60) if tz=="ET" else 0
        tu=t+off
        return any((d,m) in cal for m in range(tu-20,tu+16))
    poolN=[i for i in pool if is_news(i)]
    sN=set(poolN)
    poolS=[i for i in pool if i not in sN]
    print(f"\n=== {nome} === barre M15={n} giorni={giorni} | ATR(14) M15 MEDIANA = "
          f"{st.median([a[i] for i in pool]):.4f} {unita}  (TP = 1,00 ATR)")
    print(f"{'soglia':>6} {'n':>5} {'/gg tot':>7} {'/gg lato':>8} | {'CON NOTIZIA':>22} | {'SENZA NOTIZIA':>22} | {'UP':>13} {'DOWN':>13}")
    print(f"{'':>6} {'':>5} {'':>7} {'':>8} | {'n':>5} {'WR':>7} {'caso':>7} | {'n':>5} {'WR':>7} {'caso':>7} | {'n WR':>13} {'n WR':>13}")
    for thr in soglie:
        J=[i for i in pool if abs(z[i])>=thr]
        if len(J)<50: continue
        grp=defaultdict(lambda:[0,0]); side=defaultdict(lambda:[0,0])
        anni=defaultdict(lambda:[0,0])
        for i in J:
            s=1 if r[i]>0 else -1
            e=esito(b,i,s,a[i],n)
            d=b[i][0]; news=is_news(i)
            if e in (0,1):
                grp[news][e]+=1; side[s][e]+=1; anni[d[0:4]][e]+=1
        # controllo casuale, stessa numerosita'
        cw=cl=0
        for _ in range(len(J)):
            i=rng.choice(pool); s=1 if rng.random()<0.5 else -1
            e=esito(b,i,s,a[i],n)
            if e==1: cw+=1
            elif e==0: cl+=1
        # controllo casuale RISTRETTO ai minuti di notizia e ai minuti senza
        cg=defaultdict(lambda:[0,0])
        for flag,pp in ((True,poolN),(False,poolS)):
            if not pp: continue
            for _ in range(min(len(J),4000)):
                i=rng.choice(pp); s=1 if rng.random()<0.5 else -1
                e=esito(b,i,s,a[i],n)
                if e in (0,1): cg[flag][e]+=1
        def wr(x): return x[1]/(x[0]+x[1])*100 if x[0]+x[1] else 0
        print(f"{thr:6.1f} {len(J):5d} {len(J)/giorni:7.2f} {len(J)/giorni/2:8.2f} | "
              f"{sum(grp[True]):5d} {wr(grp[True]):6.1f}% {wr(cg[True]):6.1f}% | "
              f"{sum(grp[False]):5d} {wr(grp[False]):6.1f}% {wr(cg[False]):6.1f}% | "
              f"{sum(side[1]):5d} {wr(side[1]):6.1f}% {sum(side[-1]):5d} {wr(side[-1]):6.1f}%")
        if abs(thr-3.0)<1e-9 or abs(thr-4.0)<1e-9:
            print(f"        anno per anno (WR CONT): " +
                  " ".join(f"{y}:{wr(v):.0f}%({sum(v)})" for y,v in sorted(anni.items())))

cal=load_cal(S+"/CALENDARIO_FF_High_2010-2023_UTC.csv")
print(f"cancello H8 a RR 1,00 -> win rate richiesto 53,75%   (p >= 1,075/(RR+1))")
SOG=(2.0,2.5,3.0,3.5,4.0,4.5)
studia("GRXEUR (DAX) 03:00-11:30 ET = 08:00-16:30 server", aggregate(load_histdata(glob.glob(f"{S}/dati/GRXEUR_*.csv")),15),(180,690),"ET",cal,"punti indice",SOG)
studia("SPXUSD (S&P) 09:30-16:00 ET = 14:30-21:00 server", aggregate(load_histdata(glob.glob(f"{S}/dati/SPXUSD_*.csv")),15),(570,960),"ET",cal,"punti indice",SOG)
studia("EURUSD 07:00-20:00 UTC = 08:00-21:00 server (estate)", aggregate(load_oanda(glob.glob(f"{S}/dati/EURUSDo_*.csv")),15),(420,1200),"UTC",cal,"prezzo (x10000 = pip)",SOG)
