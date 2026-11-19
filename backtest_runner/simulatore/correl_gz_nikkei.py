#!/usr/bin/env python3
# Correlazione GoldenZoe oro H4 (simulatore, swap FTMO 5,5% annuo) contro Nikkei 225 D1 long-only (N=20 e 55), serie mensili in R per data di uscita.
import sys,datetime as dt,collections,os
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import trail as trail_gold,entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
P=lambda x: dt.datetime.strptime(x,'%Y.%m.%d %H:%M')
def swapR(t):
    t0,R,tx,ent,risk=t; days=(P(tx)-P(t0)).total_seconds()/86400
    return R-(0.055/360)*days*ent/risk
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r)
e=entries_breakout(C,H,L,55); ee=np.where(e==1,e,0); tr=trail_gold(O,H,L,C,atr,ks,0.35,ee)
gold=[(x[2][:7].replace('.','-'),swapR(x)) for x in tr]       # (mese di uscita, R)
# Nikkei D1
COST=0.0005
def trail_d(O,H,L,C,atr,ks,entries,m=3.0):
    n=len(C); tr=[]; pos=0
    for i in range(120,n-1):
        if pos==0:
            dd=entries[i]
            if dd==0 or np.isnan(atr[i]): continue
            pos=dd; ent=O[i+1]; risk=m*atr[i]; stop=ent-dd*risk; ext=ent; start=i+1
            if risk<=0: pos=0; continue
        if pos!=0 and i>=start:
            hit=(pos==1 and L[i]<=stop) or (pos==-1 and H[i]>=stop)
            if hit:
                px=min(O[i],stop) if pos==1 else max(O[i],stop)
                tr.append((ks[i][:7],pos*(px-ent)/risk-COST*ent/risk)); pos=0; continue
            ext=max(ext,H[i]) if pos==1 else min(ext,L[i])
            a=atr[i]; stop=max(stop,ext-m*a) if pos==1 else min(stop,ext+m*a)
    return tr
def entries_d(C,H,L,N):
    n=len(C); e=np.zeros(n,dtype=int)
    hh=pd.Series(H).rolling(N).max().shift(1).values
    for i in range(N+1,n):
        if C[i]>hh[i]: e[i]=1
    return e
nk=pd.read_csv('/tmp/claude-0/d1/D1_Nikkei225.csv',sep=';'); nk['date']=pd.to_datetime(nk['date']); nk=nk.dropna().reset_index(drop=True)
Ok,Hk,Lk,Ck=[nk[k].values.astype(float) for k in ('open','high','low','close')]
pc=pd.Series(Ck).shift(1); trr=pd.concat([pd.Series(Hk)-pd.Series(Lk),(pd.Series(Hk)-pc).abs(),(pd.Series(Lk)-pc).abs()],axis=1).max(axis=1)
atrk=trr.ewm(alpha=1/14,adjust=False).mean().values; ksk=nk['date'].dt.strftime('%Y-%m-%d').values
months=pd.period_range('2005-01','2026-10',freq='M').astype(str)
def serie(tr):
    s=collections.defaultdict(float)
    for m,rr in tr: s[m]+=rr
    return np.array([s.get(m,0.0) for m in months])
G=serie(gold)
print('GoldenZoe oro: operazioni',len(gold),'| R totale %.1f'%G.sum(),'| mesi con uscite',int((G!=0).sum()),'su',len(months))
def dd(x):
    eq=np.cumsum(x); pk=np.maximum.accumulate(np.concatenate([[0],eq]))[1:]; return (pk-eq).max()
for N in (20,55):
    NK=serie(trail_d(Ok,Hk,Lk,Ck,atrk,ksk,entries_d(Ck,Hk,Lk,N)))
    sp=pd.Series(G).rank().corr(pd.Series(NK).rank()); pe=np.corrcoef(G,NK)[0,1]
    # trimestri
    Gq=G.reshape(-1,3)[: len(G)//3].sum(axis=1) if len(G)%3==0 else np.add.reduceat(G,np.arange(0,len(G),3)); NKq=np.add.reduceat(NK,np.arange(0,len(NK),3))
    pq=np.corrcoef(Gq,NKq)[0,1]
    comb=G+NK
    both_neg=int(((G<0)&(NK<0)).sum()); gneg=int((G<0).sum()); nneg=int((NK<0).sum())
    print('Nikkei N=%d: R totale %.1f | corr mensile Pearson %+.2f Spearman %+.2f | trimestrale %+.2f | DD (somma R) oro %.1f Nikkei %.1f portafoglio 1+1 %.1f | mesi negativi insieme %d (oro %d, Nikkei %d)'%(N,NK.sum(),pe,sp,pq,dd(G),dd(NK),dd(comb),both_neg,gneg,nneg))
# correlazione dei mercati sottostanti (rendimenti mensili)
g=r['close'].resample('ME').last().pct_change() if hasattr(r['close'],'resample') else None
nkm=nk.set_index('date')['close'].resample('ME').last().pct_change()
gm=r['close'].resample('ME').last().pct_change()
j=pd.concat([gm.rename('oro'),nkm.rename('nikkei')],axis=1).dropna()
j=j[(j.index>='2005-01-01')]
print('correlazione rendimenti mensili sottostanti oro/Nikkei 2005-2026: %+.2f (n=%d)'%(j['oro'].corr(j['nikkei']),len(j)))
