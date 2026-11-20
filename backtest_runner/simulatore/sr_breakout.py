# Criteri: report/SR_BREAKOUT_LUXALGO_CRITERI_2026-11-20.md
import glob,sys
import numpy as np, pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_concetti import SRC,load,rs,atr,stats
YF={'BTC':'D1_Bitcoin','ETH':'D1_Ethereum','DAX':'D1_DAX','ARG':'D1_Argento','WTI':'D1_Petrolio_WTI'}
L=R_=15
def levels(h,l):
    n=len(h); hs=pd.Series(h); ls=pd.Series(l)
    ph=(hs==hs.rolling(31,center=True).max()).values; pl=(ls==ls.rolling(31,center=True).min()).values
    res=np.full(n,np.nan); sup=np.full(n,np.nan)
    for p in np.nonzero(ph)[0]:
        if p+16<n: res[p+16]=h[p]
    for p in np.nonzero(pl)[0]:
        if p+16<n: sup[p+16]=l[p]
    return pd.Series(res).ffill().values,pd.Series(sup).ffill().values
def sim(o,h,l,c,cost,k,mode):
    n=len(c); a=atr(h,l,c); res,sup=levels(h,l); out=[]; t=40
    while t<n-2:
        R=res[t]; S=sup[t]
        if np.isnan(R) or np.isnan(S) or a[t-1]<=0: t+=1; continue
        buy=h[t]>=R and R>S; sell=l[t]<=S and R>S
        if buy==sell: t+=1; continue   # nessuno o entrambi
        d=1 if buy else -1; en=max(R,o[t]) if d==1 else min(S,o[t]); A=a[t-1]; R0=1.5*A; stop=en-d*R0; tp=en+d*k*A; mfe=0.0
        half=False; resR=0.0; j=t; done=False; ext=en
        while j<n-1:
            # barra j (la barra di ingresso e' controllata con la stessa regola, stop prima)
            if d==1: ext=max(ext,h[j]); mfe=max(mfe,(h[j]-en)/A)
            else: ext=min(ext,l[j]); mfe=max(mfe,(en-l[j])/A)
            if mode in ('E2','E3') and (mode=='E2' or half):
                tr=ext-d*3*A; stop=max(stop,tr) if d==1 else min(stop,tr)
            rem=1.0-(0.5 if half else 0.0)
            if (l[j]<=stop) if d==1 else (h[j]>=stop):
                resR+=rem*(((stop-en)*d)/R0); done=True; break
            if mode in('E1','E3') and not half and ((h[j]>=tp) if d==1 else (l[j]<=tp)):
                if mode=='E1': resR+=(((tp-en)*d)/R0); done=True; break
                resR+=0.5*(((tp-en)*d)/R0); half=True
            if j-t>=200:
                resR+=rem*(((c[j]-en)*d)/R0); done=True; break
            j+=1
        if not done: resR+=(1.0-(0.5 if half else 0.0))*(((c[min(j,n-1)]-en)*d)/R0)
        resR-=cost/R0; out.append((t,d,resR,mfe)); t=max(j+1,t+1)
    return out
def cells():
    for sym,(pat,sep,cost,fmt) in SRC.items():
        d1=load(pat,sep,fmt)
        for tf,rule in (('M15','15min'),('H1','1h'),('H4','4h'),('D1','1D')):
            d=rs(d1,rule); yield sym,tf,[d[x].values.astype(float) for x in 'ohlc'],cost,False
    for nm,f in YF.items():
        d=pd.read_csv(f'/tmp/claude-0/d1/{f}.csv',sep=';').dropna(); yield nm,'D1',[d[x].values.astype(float) for x in ('open','high','low','close')],0.0005,True
def main():
    for sym,tf,(o,h,l,c),cost,pct in cells():
        n=len(c); cut=int(n*.7)
        cst=(lambda p:cost*p) if pct else (lambda p:cost)
        # costo in unita' di prezzo: per D1 Yahoo e' percentuale (usiamo il prezzo medio dell'ingresso)
        cc=cost*np.nanmean(c) if pct else cost
        base=sim(o,h,l,c,cc,1.0,'E2'); isb=[r for r in base if r[0]<cut]
        k=max(0.5,float(np.median([r[3] for r in isb]))) if len(isb)>=20 else 1.0
        for mode in ('E1','E2','E3'):
            res=sim(o,h,l,c,cc,k,mode); a=[r for r in res if r[0]<cut]; b=[r for r in res if r[0]>=cut]
            print(f"{sym:7s}{tf:4s} {mode} k={k:4.2f} IS {stats([r[2] for r in a])} | OOS {stats([r[2] for r in b])} | long IS {stats([r[2] for r in a if r[1]==1])[:30]} short IS {stats([r[2] for r in a if r[1]==-1])[:30]}",flush=True)
if __name__=='__main__': main()
