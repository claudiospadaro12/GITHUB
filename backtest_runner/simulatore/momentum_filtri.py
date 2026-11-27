import sys,warnings;warnings.filterwarnings('ignore')
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np,pandas as pd
import momentum_30min as m
def pf(p):
    w=p[p>0].sum(); l=-p[p<0].sum(); return w/l if l>0 else np.nan
rng=np.random.default_rng(20261127)
for K in (1.0,0.0):
    print('=== costo x',K)
    for sym in ('NASUSD','SPXUSD'):
        t=m.days(sym).reset_index(drop=True); cost=m.COST[sym]*K
        gross=(t.o1600-t.o1530).values; yr=t.day.dt.year.values
        raw={'V1':(t.c959-t.prevclose),'V2':(t.c959-t.o930)}
        prevmove=(t.o1600-t.o930).shift(1)
        dayclose=t.o1600; trend=np.sign(dayclose.shift(1)-dayclose.shift(2).rolling(50).mean())
        for v,sig in raw.items():
            a=np.abs(sig); med=a.shift(1).rolling(60).median()
            F={'F1':(a>=med),'F2':(np.abs(prevmove)>=np.abs(prevmove).shift(1).rolling(60).median()),'F4':(np.sign(sig)==trend)}
            for fk,mask in F.items():
                s=np.sign(sig).values; mk=mask.fillna(False).values&(s!=0)
                p=s*gross-cost; res=[]
                for lo,hi in ((2015,2020),(2021,2024),(2025,2026)):
                    sel=mk&(yr>=lo)&(yr<=hi); res.append((sel.sum(),pf(p[sel])))
                ya=pd.Series(p[mk]).groupby(yr[mk]).sum(); pr=[]
                for _ in range(20):
                    rs=rng.choice([-1,1],len(t)); q=rs*gross-cost; sel=mk&(yr<=2024); pr.append(pf(q[sel]))
                print(sym,v,fk,'IS n=%d PF %.2f | OOS n=%d PF %.2f | HO n=%d PF %.2f | anni+ %d/%d | casuale %.2f'%(res[0][0],res[0][1],res[1][0],res[1][1],res[2][0],res[2][1],(ya>0).sum(),len(ya),np.nanmean(pr)))
