import sys,glob,collections,statistics as st,datetime as dt,pickle,json
import numpy as np
sys.argv=['x']
from ubs_equity import deals,positions,year_equity,conv
COST=36.0; DEP=80000.0
tags=['PH_strat8','PH_strat3','GB_dailyC','GTP_E','GB_dailyI','GTP_a','GR_s5_H1','GR_s1_D1']
DL={}; POS={}
for t in tags:
    h=glob.glob(f'u2/UBSU2_B_{t}_100000_2013-2025/*/report/*.htm')[0]
    dl=deals(h); DL[t]=dl; POS[t]=positions(dl)[0]
def with_cost(pos,k):
    return [dict(p,pnl=p['pnl']-k*COST*p['vol']) for p in pos]
# giornaliero realizzato con costi: pnl dei deal + costo a meta per deal
def daily(t,k):
    d=collections.defaultdict(float)
    for x in DL[t]:
        d[x['t'][:10].replace('.','-')]+=x['pr']+x['com']+x['swap']-k*COST*x['vol']/2
    return d
def sim_cal(series,tgt):
    ds=sorted(series); cal=[dt.date.fromisoformat(d) for d in ds]; res=[]
    for s in range(0,len(ds),3):
        cum=0;out=('C',None)
        for kk in range(s,len(ds)):
            dd=(cal[kk]-cal[s]).days+1
            if dd>1100: break
            v=series[ds[kk]]
            if v<=-0.05*DEP or cum+v<=-0.10*DEP: out=('F',dd);break
            cum+=v
            if cum>=tgt*DEP and dd>=4: out=('P',dd);break
        res.append(out)
    n=len(res);p=[x[1] for x in res if x[0]=='P'];f=sum(1 for x in res if x[0]=='F');o=sum(1 for x in res if x[0]=='C')
    return 100*len(p)/n,100*f/n,100*o/n,(st.median(p) if p else None)
def run(tagsel,cush,k):
    scale=0.8/cush
    ser=collections.defaultdict(float)
    for t in tagsel:
        for d,v in daily(t,k).items(): ser[d]+=scale*v
    a=sim_cal(ser,0.10); b=sim_cal(ser,0.05)
    yrs=13.0; net=sum(ser.values())/yrs
    # equity per anno
    eq=[]
    for y in ('2013','2018','2020','2025'):
        A=0;C=0
        for t in tagsel:
            pp=with_cost(POS[t],k); ea,ec,T=year_equity(pp,y); A=A+ea;C=C+ec
        A=A*scale;C=C*scale
        days=T.astype('datetime64[D]'); u,idx=np.unique(days,return_index=True); ends=np.append(idx[1:]-1,len(T)-1)
        low=np.minimum.reduceat(np.minimum(A,C),idx); close=C[ends]; prev=np.concatenate([[C[0]],close[:-1]])
        loss=(prev-low); pk=np.maximum.accumulate(np.minimum(A,C)); dd=(pk-np.minimum(A,C)).max()
        eq.append((100*loss.max()/DEP,int((loss>=0.045*DEP).sum()),100*dd/DEP))
    return net,a,b,eq
S8=tags; S6=['PH_strat3','GB_dailyC','GTP_E','GB_dailyI','GTP_a','GR_s5_H1']
out={}
for lab,sel in (('8 set',S8),('6 set',S6)):
    for cush,k,desc in ((1.0,0,'senza cuscinetto, senza costi FTMO'),(1.0,1,'senza cuscinetto, costi centrali'),(1.5,0,'cuscinetto 1,5, senza costi FTMO'),(1.5,1,'cuscinetto 1,5 + costi centrali'),(1.5,2,'cuscinetto 1,5 + costi doppi')):
        net,a,b,eq=run(sel,cush,k); out[(lab,desc)]=(net,a,b,eq)
        print('%-6s %-38s netto/anno %6.0f (%.1f%%) | +10%%: passa %3.0f%% fall %.1f%% aperto %2.0f%% mediana %s | +5%%: passa %3.0f%% mediana %s | equity: peggior gg %s DD %s gg>=4,5%%: %d'%(lab,desc,net,100*net/DEP,a[0],a[1],a[2],a[3] and int(a[3]),b[0],b[3] and int(b[3]),'/'.join('%.1f'%e[0] for e in eq),'/'.join('%.1f'%e[2] for e in eq),sum(e[1] for e in eq)))
