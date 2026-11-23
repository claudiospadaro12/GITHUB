#!/usr/bin/env python3
# Criteri: report/RV_D1_COPPIE_CRITERI_2026-11-23.md. Hold-out 2024+ NON stampato salvo --holdout.
import sys, numpy as np, pandas as pd
D='/tmp/claude-0/d1/'
HOLD='--holdout' in sys.argv
PAIRS=[('Oro','Argento'),('Oro','Platino'),('Platino','Palladio'),('Nasdaq100','SP500'),('Dow30','SP500'),
       ('Russell2000','SP500'),('DAX','EuroStoxx50'),('DAX','FTSE100'),('Petrolio_Brent','Petrolio_WTI')]
GRID=[(L,E) for L in (60,120,250) for E in (2.0,2.5)]
CF=0.0005; SWL=0.08; SWS=0.02
def load(n):
    d=pd.read_csv(D+'D1_%s.csv'%n,sep=';',parse_dates=['date']).set_index('date')
    return d[['open','close']]
def run(a,b,L,E):
    df=pd.concat([a.add_suffix('_a'),b.add_suffix('_b')],axis=1).dropna()
    df=df[(df>0).all(axis=1)]
    x=np.log(df.close_a/df.close_b); z=((x-x.rolling(L).mean())/x.rolling(L).std()).values
    oa=df.open_a.values; ob=df.open_b.values; n=len(df)
    ret=np.zeros(n); pos=0; ent=-1; locked=False; trades=[]; cur=0.0; pnl=np.zeros(n)
    for t in range(L,n-2):
        # posizione tenuta da open t+1 a open t+2, decisa a close t
        zt=z[t]; newpos=pos
        if pos==0:
            if locked:
                if abs(zt)<1: locked=False
            elif zt>E: newpos=-1   # short A long B
            elif zt<-E: newpos=1
        else:
            if abs(zt)<0.5 or (t-ent)>=60: newpos=0
            elif abs(zt)>4: newpos=0; locked=True
        cost=CF if newpos!=pos else 0.0   # per lato 0,05% del lordo (giro completo 0,1%)
        if pos==0 and newpos!=0: ent=t
        if newpos!=0:
            ra=oa[t+2]/oa[t+1]-1; rb=ob[t+2]/ob[t+1]-1
            g=newpos*0.5*(ra-rb)
            sw=(0.5*(SWL if newpos>0 else SWS)+0.5*(SWL if newpos<0 else SWS))/365
            g-=sw
        else: g=0.0
        g-=cost
        pnl[t+1]=g
        if pos==0 and newpos!=0: cur=g
        elif pos!=0 and newpos!=0: cur+=g
        elif pos!=0 and newpos==0: trades.append((df.index[t],cur+g)); cur=0.0
        pos=newpos
    return df.index,pnl,trades
def stats(trades,lo,hi):
    r=np.array([p for d,p in trades if lo<=d.year<=hi])
    if len(r)==0: return 0,0,np.nan,0
    gp=r[r>0].sum(); gl=-r[r<0].sum(); pf=gp/gl if gl>0 else np.inf
    yrs=pd.Series([p for d,p in trades if lo<=d.year<=hi],index=[d.year for d,p in trades if lo<=d.year<=hi]).groupby(level=0).sum()
    return len(r),pf,(yrs>0).mean(),r.sum()
oro=load('Oro').close.pct_change(); dow=load('Dow30').close.pct_change()
print('coppia            L   E   | IS n  PF  anni+ | OOS n PF | G3(IS PF>1 vicini)')
fin=[]
for A,B in PAIRS:
    a,b=load(A),load(B); res={}
    for L,E in GRID:
        idx,pnl,tr=run(a,b,L,E); res[(L,E)]=(idx,pnl,tr)
    for L,E in GRID:
        idx,pnl,tr=res[(L,E)]
        n1,pf1,ap,_=stats(tr,1900,2015); n2,pf2,_,_=stats(tr,2016,2023)
        nb=sum(1 for k in GRID if k!=(L,E) and stats(res[k][2],1900,2015)[1]>1.0)
        g1=n1>=60 and pf1>=1.3 and ap>=0.6; g2=n2>=20 and pf2>=1.2; g3=nb>=4
        flag='PASSA' if g1 and g2 and g3 else ('g1' if g1 else '')
        print('%-18s %3d %.1f | %3d %.2f %.2f | %3d %.2f | %d/5 %s'%(A+'/'+B,L,E,n1,pf1,ap if ap==ap else 0,n2,pf2,nb,flag))
        if g1 and g2 and g3:
            s=pd.Series(pnl,index=idx); m=(s.index.year<=2023)
            c1=s[m].corr(oro.reindex(s.index)[m]); c2=s[m].corr(dow.reindex(s.index)[m])
            print('   correlazioni: oro %.2f dow %.2f'%(c1,c2)); fin.append((A,B,L,E,c1,c2,tr))
print('finalisti G1+G2+G3:',len(fin))
if HOLD:
    for A,B,L,E,c1,c2,tr in fin[:3]:
        print('HOLD-OUT',A,B,L,E,stats(tr,2024,2026))
