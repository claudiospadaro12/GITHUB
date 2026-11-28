import sys,warnings;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd
CELLS=[(0.13,False,'ibs8'),(0.13,False,'d3'),(0.13,True,'ibs8'),(0.13,True,'d3'),(0.2,False,'ibs8')]
M={'SP500':(1970,2009),'Nasdaq100':(1985,2009),'Dow30':(1992,2009),'DAX':(1987,2009),'FTSE100':(1984,2009),'CAC40':(1990,2009),'Nikkei225':(1970,2009),'Russell2000':(1987,2009)}
def load(n):
    d=pd.read_csv('/tmp/claude-0/d1/D1_%s.csv'%n,sep=';',parse_dates=['date']).set_index('date'); d=d[d.high>d.low]; d['ibs']=(d.close-d.low)/(d.high-d.low); d['sma']=d.close.rolling(200).mean(); return d
def run(d,e,filt,ex,fin,cost,rand=None):
    C=d.close.values; ibs=d.ibs.values; sma=d.sma.values; idx=d.index; n=len(d); out=[]; t=200
    sig=(ibs<=e)&((C>sma) if filt else True)
    if rand is not None: sig=rand
    while t<n-1:
        if not sig[t]: t+=1; continue
        j=t+1
        while j<n-1:
            if ex=='ibs8' and ibs[j]>=0.8: break
            if ex=='d3' and j-t>=3: break
            j+=1
        out.append((idx[t].year,C[j]/C[t]-1-cost-fin*(idx[j]-idx[t]).days/365)); t=j+1
    return pd.DataFrame(out,columns=['y','r'])
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
rng=np.random.default_rng(20261128)
def period(d,lo,hi): return d[(d.index.year>=lo)&(d.index.year<=hi)]
res={}
for per,label in (('pre','PRE-2010 (primario)'),('post','2010-2026 (secondario)')):
    print('=====',label)
    mk=M if per=='pre' else {k:(2010,2026) for k in ('DAX','FTSE100','CAC40','Nikkei225','Russell2000')}
    for c in CELLS:
        rows=[]
        for n,(lo,hi) in mk.items():
            d=period(load(n),lo-1 if lo>1970 else lo,hi); d=d if len(d)>300 else d
            a=run(d,*c,0.075,0.0003); a=a[a.y>=lo]; st=run(d,*c,0.14,0.0006); st=st[st.y>=lo]
            base=run(d,*c,0.075,0.0003); freq=len(base)/len(d); nl=[]
            for _ in range(100):
                z=run(d,*c,0.075,0.0003,rand=(rng.random(len(d))<freq)); z=z[z.y>=lo]
                if len(z)>=30: nl.append(pf(z.r))
            ya=(a.groupby('y').r.sum()>0).mean() if len(a) else np.nan
            rows.append((n,len(a),pf(a.r),pf(st.r),(np.array(nl)<pf(a.r)).mean(),np.percentile(nl,90),ya))
        R=pd.DataFrame(rows,columns=['mkt','n','pf','pf_stress','rango_nullo','null_p90','anni_pos'])
        ok1=(R.pf>=1.15).sum(); ok2=(R.pf>1.0).sum(); ok3=(R.pf<0.85).sum(); ok4=(R.pf>R.null_p90).sum()
        print(c,'| PF>=1,15: %d/%d, PF>1: %d/%d, PF<0,85: %d, sopra p90 casuale: %d/%d, stress>1: %d/%d'%(ok1,len(R),ok2,len(R),ok3,ok4,len(R),(R.pf_stress>1).sum(),len(R)),
              '| CONFERMATA' if (per=='pre' and ok1>=6 and ok2>=7 and ok3==0 and ok4>=6 and (R.pf_stress>1).sum()>=len(R)/2+0.5) else '')
        print('   '+'; '.join('%s n=%d PF %.2f (casuale p90 %.2f)'%(r.mkt[:6],r.n,r.pf,r.null_p90) for r in R.itertuples()))
