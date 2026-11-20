import sys; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import sr_breakout as S, numpy as np, pandas as pd
from tv_concetti import SRC,load,rs,stats
pat,sep,cost,fmt=SRC['XAUUSD']; d1=load(pat,sep,fmt)
d=rs(d1,'1h'); dd=rs(d1,'1D')
cd=dd.c.values; ac=np.abs(np.diff(cd,prepend=cd[0])); sm=pd.Series(ac).rolling(20).sum().values
er=pd.Series(np.full(len(cd),np.nan),index=dd.index); er.iloc[20:]=np.abs(cd[20:]-cd[:-20])/sm[20:]
er_prev=er.shift(1)  # ER fino al giorno prima
h_er=er_prev.reindex(d.index.normalize()).values
o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); cut=int(n*.7)
for mode,k in (('E1',1.5),('E2',1.5)):
    tr=S.sim(o,h,l,c,cost,k,mode)
    df=pd.DataFrame(tr,columns=['t','d','R','mfe']); df['er']=h_er[df.t.values]; df=df.dropna(); df['IS']=df.t<cut
    q1,q2=np.percentile(df[df.IS].er,[33.3,66.7])
    print(mode,'terzili ER (IS):',round(q1,3),round(q2,3))
    for per,flag in (('IS',True),('OOS',False)):
        x=df[df.IS==flag]
        print(' ',per,'basso',stats(x[x.er<q1].R),'| medio',stats(x[(x.er>=q1)&(x.er<q2)].R),'| alto',stats(x[x.er>=q2].R))
        for sd,sn in ((1,'long'),(-1,'short')):
            y=x[(x.d==sd)&(x.er>=q2)]; print('     alto',sn,stats(y.R))
