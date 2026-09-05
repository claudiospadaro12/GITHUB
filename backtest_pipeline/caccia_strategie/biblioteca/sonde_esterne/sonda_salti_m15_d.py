#!/usr/bin/env python3
# SONDA SALTO STATISTICO M15 - PARTE C: L'ASPETTATIVA IN R, confrontabile col
# cancello H8 congelato (E >= 0,075R). Geometria DICHIARATA PRIMA e NON scelta
# su questi dati: SL = 1,2 ATR / TP = 1,4 ATR e' la stessa di
# biblioteca/sonde_esterne/sonda_sweep_wr.py (scritta il 03/09 per un ALTRO
# meccanismo). Seconda geometria di controllo: simmetrica 1,0/1,0.
# Uscita a TEMPO alla barra 12 se ne' TP ne' SL. Ambiguita' intrabarra SEMPRE
# a sfavore. ZERO costi dentro la sonda: il costo si sottrae DOPO, in R.
import os, glob, math, random, statistics as st, datetime
from collections import defaultdict
S=os.environ["S"]; C=math.sqrt(2.0/math.pi); K=156; H=int(os.environ.get("HH","12"))

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
                t=q[0]
                out.append((t[0:4]+t[5:7]+t[8:10],int(t[11:13]),int(t[14:16]),float(q[4]),float(q[2]),float(q[3]),float(q[1])))
    return out
def aggregate(bars,m):
    out=[];cur=None
    for (d,hh,mm,o,h,l,c) in bars:
        s=(d,hh,(mm//m)*m)
        if cur is None or cur[0]!=s:
            if cur is not None: out.append(cur[1])
            cur=(s,[s[0],s[1],s[2],o,h,l,c])
        else:
            b=cur[1]
            if h>b[4]: b[4]=h
            if l<b[5]: b[5]=l
            b[6]=c
    if cur is not None: out.append(cur[1])
    return out
def atr(b,n=14):
    out=[None]*len(b); trs=[]; pc=None; s=0.0
    for i,x in enumerate(b):
        h,l,c=x[4],x[5],x[6]
        tr=h-l if pc is None else max(h-l,abs(h-pc),abs(l-pc))
        trs.append(tr); pc=c
        if i>=n: s-=trs[i-n]
        s+=tr
        if i>=n-1: out[i]=s/n
    return out
def load_cal(p):
    ev=set()
    with open(p) as f:
        first=True
        for line in f:
            if first: first=False; continue
            q=line.strip().split(';')
            if len(q)<4: continue
            dt=q[0]; ev.add((dt[0:4]+dt[5:7]+dt[8:10],int(dt[11:13])*60+int(dt[14:16])))
    return ev
def us_dst(ds):
    y=int(ds[0:4]); day=datetime.date(y,int(ds[4:6]),int(ds[6:8]))
    mar=datetime.date(y,3,1); a=mar+datetime.timedelta(days=(6-mar.weekday())%7+7)
    nov=datetime.date(y,11,1); z=nov+datetime.timedelta(days=(6-nov.weekday())%7)
    return a<=day<z

def trade(b,i,s,av,slM,tpM,n):
    """rendimento in R. R = SL. TP=+tpM/slM R. Uscita a tempo alla barra 12."""
    e=b[i][6]; sl=slM*av; tp=tpM*av; RR=tpM/slM
    for j in range(i+1,min(i+1+H,n)):
        if b[j][0]!=b[i][0]: break
        hi,lo=b[j][4],b[j][5]
        hs=(lo<=e-sl) if s>0 else (hi>=e+sl)
        ht=(hi>=e+tp) if s>0 else (lo<=e-tp)
        if hs: return -1.0
        if ht: return RR
    j=min(i+H,n-1)
    while j>i and b[j][0]!=b[i][0]: j-=1
    return (b[j][6]-e)*s/sl

def studia(nome,b,sess,tz,cal,unita,spread,soglie=(2.0,2.5,3.0,3.5,4.0,4.5),seed=11):
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
    ins=lambda x:h0<=x[1]*60+x[2]<h1
    gg=len({x[0] for x in b if ins(x)})
    pool=[i for i in range(K+20,n-H-1) if a[i] and ins(b[i]) and z[i] is not None]
    def is_news(i):
        d=b[i][0]; t=b[i][1]*60+b[i][2]
        off=(4*60 if us_dst(d) else 5*60) if tz=="ET" else 0
        return any((d,m) in cal for m in range(t+off-20,t+off+16))
    sN={i for i in pool if is_news(i)}
    poolS=[i for i in pool if i not in sN]
    rng=random.Random(seed)
    matr=st.median([a[i] for i in pool])
    print(f"\n=== {nome} ===")
    print(f"    giorni={gg}  ATR(14) M15 mediana={matr:.4f} {unita}")
    for slM,tpM in ((float(os.environ.get("SLM","1.2")),float(os.environ.get("TPM","1.4"))),):
        Rsl=slM*matr; costoR=spread/Rsl if spread else float('nan')
        print(f"  -- geometria SL={slM} ATR / TP={tpM} ATR  (RR {tpM/slM:.3f}) | 1R = {Rsl:.3f} {unita}"
              f" | spread di convenzione {spread} -> COSTO = {costoR:.3f} R per operazione")
        print(f"  {'soglia':>6} | {'TUTTI':>26} | {'SENZA NOTIZIA':>26} | {'caso':>14}")
        print(f"  {'':>6} | {'n':>5} {'/gg lato':>8} {'E lordo':>10} | {'n':>5} {'/gg lato':>8} {'E lordo':>10} | {'E caso':>14}")
        for thr in soglie:
            J=[i for i in pool if abs(z[i])>=thr]
            if len(J)<50: continue
            RT=[trade(b,i,1 if r[i]>0 else -1,a[i],slM,tpM,n) for i in J]
            JS=[i for i in J if i not in sN]
            RS=[trade(b,i,1 if r[i]>0 else -1,a[i],slM,tpM,n) for i in JS]
            RC=[trade(b,i,1 if rng.random()<0.5 else -1,a[i],slM,tpM,n)
                for i in (rng.choice(poolS) for _ in range(min(6000,max(len(JS),1000))))]
            print(f"  {thr:6.1f} | {len(J):5d} {len(J)/gg/2:8.2f} {st.mean(RT):+10.4f} | "
                  f"{len(JS):5d} {len(JS)/gg/2:8.2f} {st.mean(RS):+10.4f} | {st.mean(RC):+14.4f}")

cal=load_cal(S+"/CALENDARIO_FF_High_2010-2023_UTC.csv")
print("CANCELLO H8 CONGELATO: E >= 0,075 R  (netta, a tick, sul nostro banco)")
print("Qui i numeri sono LORDI, su dati esterni OHLC, ZERO costi: sono OCCASIONI, non verdetti.")
studia("GRXEUR (DAX) 08:00-16:30 server", aggregate(load_histdata(glob.glob(f"{S}/dati/GRXEUR_*.csv")),15),(180,690),"ET",cal,"punti indice",1.7)
studia("SPXUSD (S&P) 14:30-21:00 server", aggregate(load_histdata(glob.glob(f"{S}/dati/SPXUSD_*.csv")),15),(570,960),"ET",cal,"punti indice",0.5)
studia("EURUSD 08:00-21:00 server", aggregate(load_oanda(glob.glob(f"{S}/dati/EURUSDo_*.csv")),15),(420,1200),"UTC",cal,"prezzo",0.0001)
