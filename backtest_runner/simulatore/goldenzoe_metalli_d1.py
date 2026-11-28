import sys,warnings,itertools;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd
MK={'Oro':0.0003,'Argento':0.0010,'Platino':0.0020,'Palladio':0.0030,'Rame':0.0005}
def load(n):
    d=pd.read_csv('/tmp/claude-0/d1/D1_%s.csv'%n,sep=';',parse_dates=['date']).set_index('date'); d=d[(d.high>=d.low)&(d.close>0)]
    pc=d.close.shift(1); tr=pd.concat([d.high-d.low,(d.high-pc).abs(),(d.low-pc).abs()],axis=1).max(axis=1); d['atr']=tr.ewm(alpha=1/14,adjust=False).mean(); return d
def trades(d,N,mi,mt,cost,fin,rand=None):
    O,H,L,C,A=[d[k].values for k in ('open','high','low','close','atr')]; hh=pd.Series(d.high).rolling(N).max().shift(1).values; idx=d.index; n=len(d); out=[]; t=max(N,20)+1
    sig=(C>hh) if rand is None else rand
    while t<n-1:
        if not sig[t] or np.isnan(A[t]): t+=1; continue
        ent=O[t+1]; risk=mi*A[t]; stop=ent-risk; ext=ent; j=t+1; ex=None
        while j<n:
            if L[j]<=stop: ex=min(O[j],stop); break
            ext=max(ext,H[j]); stop=max(stop,ext-mt*A[j]); j+=1
        if ex is None: ex=C[n-1]; j=n-1
        days=(idx[j]-idx[t+1]).days; out.append((idx[t+1],(ex-ent)/risk-(cost*ent+fin*ent*days/365)/risk)); t=j+1
    return pd.DataFrame(out,columns=['t','R'])
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
rng=np.random.default_rng(20261128)
if __name__=='__main__':
    gz=pd.read_csv('/tmp/work/gz_trades.csv',parse_dates=['ts_close']); gzm=(gz.R_gross-gz.cost_R).groupby(gz.ts_close.dt.to_period('M')).sum()
    for name,cost in MK.items():
        d=load(name); sp=d.index[0].year; print('=====',name,sp,'-2026, barre',len(d))
        cell={}
        for N,m in itertools.product((10,20,55),(2.5,3.0,3.5)):
            a=trades(d,N,m,m,cost,0.055); st=trades(d,N,m,m,cost*2,0.097); cell[(N,m)]=(a,st)
        for N,m in itertools.product((10,20,55),(2.5,3.0,3.5)):
            a,st=cell[(N,m)]; is_=a[a.t.dt.year<=2014]; oo=a[a.t.dt.year>=2015]; ya=(a.groupby(a.t.dt.year).R.sum()>0).mean(); 
            print('  N=%2d mi=mt=%.1f n=%3d IS %.2f OOS %.2f all %.2f anni+ %.0f%% stress %.2f'%(N,m,len(a),pf(is_.R),pf(oo.R),pf(a.R),100*ya,pf(st.R)),'*' if (N,m)==(20,3.0) else '')
        a,st=cell[(20,3.0)]; is_=a[a.t.dt.year<=2014]; oo=a[a.t.dt.year>=2015]
        nb=[pf(cell[k][0].R)>1.0 for k in cell if k!=(20,3.0)]
        base=trades(d,20,3.0,3.0,cost,0.055); freq=len(base)/len(d); nl=[]
        for _ in range(100):
            r=trades(d,20,3.0,3.0,cost,0.055,rand=(rng.random(len(d))<freq)); z=r[r.t.dt.year<=2014]
            if len(z)>=30: nl.append(pf(z.R))
        ok=(pf(is_.R)>=1.25 and pf(oo.R)>=1.15 and len(a)>=100 and (a.groupby(a.t.dt.year).R.sum()>0).mean()>=0.6 and pf(st.R)>1.0 and sum(nb)>=7 and pf(is_.R)>np.percentile(nl,95))
        m=a.groupby(a.t.dt.to_period('M')).R.sum(); cr=pd.concat([m,gzm],axis=1,join='inner').corr().iloc[0,1]
        print('  PRIMARIA: IS %.2f OOS %.2f | plateau vicini>1: %d/8 | casuale IS p95 %.2f media %.2f | corr mensile con GoldenZoe %.2f ->'%(pf(is_.R),pf(oo.R),sum(nb),np.percentile(nl,95),np.mean(nl),cr),'CANDIDATO' if ok else 'no')
