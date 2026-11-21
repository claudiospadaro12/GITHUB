# Criteri: report/SR_ORO_HOLDOUT_2021_26_CRITERI_2026-11-21.md
import sys,glob; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import sr_breakout as S, numpy as np, pandas as pd
from tv_concetti import load,rs,stats
COST=0.35
def prep(pat):
    d1=load(pat,';','f'); d=rs(d1,'1h'); dd=rs(d1,'1D')
    cd=dd.c.values; ac=np.abs(np.diff(cd,prepend=cd[0])); sm=pd.Series(ac).rolling(20).sum().values
    er=pd.Series(np.full(len(cd),np.nan),index=dd.index); er.iloc[20:]=np.abs(cd[20:]-cd[:-20])/sm[20:]
    return d,er.shift(1).reindex(d.index.normalize()).values
def trades(d,her,mode):
    o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']
    df=pd.DataFrame(S.sim(o,h,l,c,COST,1.5,mode),columns=['t','d','R','mfe']); df['er']=her[df.t.values]; df['time']=d.index[df.t.values]; return df.dropna()
old,her_o=prep('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')
new,her_n=prep('/tmp/claude-0/xau_2126/ABTG_M1_XAUUSD_*.csv')
print('vecchi',old.index[0],old.index[-1],'nuovi',new.index[0],new.index[-1])
for mode in ('E1','E2'):
    a=trades(old,her_o,mode); q1,q2=np.percentile(a.er,[33.3,66.7]); b=trades(new,her_n,mode)
    print(f'--- {mode}  terzili ER 2004-20 (congelati): {q1:.3f} {q2:.3f}  n={len(b)}')
    for nome,x in (('TUTTI',b),('ER alto',b[b.er>=q2]),('ER basso',b[b.er<q1])):
        print(f'{nome:9s}',stats(x.R))
    for sd,sn in ((1,'long'),(-1,'short')): print(f'  tutti {sn}',stats(b[b.d==sd].R),'| ER alto',stats(b[(b.d==sd)&(b.er>=q2)].R))
    for y,g in b.groupby(b.time.dt.year): print(' ',y,'tutti',stats(g.R)[:40],'| ER alto',stats(g[g.er>=q2].R)[:40])
    s=b[b.time>='2026-10-01']; print('  ott-nov 2026 tutti',stats(s.R),'| ER alto',stats(s[s.er>=q2].R))
