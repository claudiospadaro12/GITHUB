import sys,warnings,itertools;warnings.filterwarnings('ignore')
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np,pandas as pd,gap_fade as g
COST={'NASUSD':1.8/19000,'SPXUSD':0.6/6000}
def d1(sym):
    r=[]
    for x in g.days(sym):
        i=np.nonzero(x['m']==959)[0]
        if len(i)==0: continue
        r.append((x['day'],x['O'][0],x['H'][:i[0]+1].max(),x['L'][:i[0]+1].min(),x['C'][i[0]]))
    d=pd.DataFrame(r,columns=['day','O','H','L','C']).set_index('day'); d=d[d.H>d.L]
    d['ibs']=(d.C-d.L)/(d.H-d.L); d['sma']=d.C.rolling(200).mean(); return d
def run(d,e,filt,ex,fin,cm,rand=None):
    C=d.C.values; ibs=d.ibs.values; sma=d.sma.values; idx=d.index; n=len(d); out=[]; t=200
    sig=(ibs<=e)&((C>sma) if filt else True)
    if rand is not None: sig=rand
    while t<n-1:
        if not sig[t]: t+=1; continue
        j=t+1
        while j<n-1:
            if ex=='ibs5' and ibs[j]>=0.5: break
            if ex=='ibs8' and ibs[j]>=0.8: break
            if ex=='d1' and j-t>=1: break
            if ex=='d3' and j-t>=3: break
            j+=1
        days=(idx[j]-idx[t]).days; r=C[j]/C[t]-1-cm*COST_[0]-fin*days/365
        out.append((idx[t].year,r)); t=j+1
    return pd.DataFrame(out,columns=['y','r'])
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
if __name__=='__main__':
    cells=list(itertools.product((0.13,0.2,0.3),(False,True),('ibs5','ibs8','d1','d3'))); data={s:d1(s) for s in COST}; rng=np.random.default_rng(20261128); res={}
    for s,d in data.items(): print(s,'giorni',len(d))
    for s,d in data.items():
        COST_=[COST[s]]
        for c in cells: res[(s,c)]={k:run(d,*c,fin,cm) for k,(fin,cm) in {'n':(0.075,1),'st':(0.14,2),'z':(0.0,0)}.items()}
    passed=[]; print('=== cella: IS/OOS/HO netto | zero | stress OOS')
    for c in cells:
        line=[];ok=True
        for s in COST:
            r=res[(s,c)]; a=r['n']; f=lambda df,lo,hi:df[(df.y>=lo)&(df.y<=hi)]
            i=f(a,2011,2018);o=f(a,2019,2023);h=f(a,2024,2026); iz=f(r['z'],2011,2018); st=f(r['st'],2019,2023); ya=(a.groupby('y').r.sum()>0).mean()
            line.append('%s n=%d IS %.2f OOS %.2f HO %.2f | z IS %.2f | st %.2f'%(s[:3],len(i),pf(i.r),pf(o.r),pf(h.r),pf(iz.r),pf(st.r)))
            ok&=(len(i)>=100 and pf(i.r)>=1.25 and pf(o.r)>=1.15 and ya>=0.6 and pf(st.r)>1.0)
        print(c,' || '.join(line),'PASSA' if ok else '')
        if ok: passed.append(c)
    print('passano su entrambi:',passed)
    best=[]
    for rep in range(20):
        mx=0
        for s,d in data.items():
            COST_=[COST[s]]
            for c in cells:
                base=run(d,*c,0.075,1); freq=len(base)/max(1,len(d))
                rd=rng.random(len(d))<(freq*1.0); a=run(d,*c,0.075,1,rand=rd); z=a[(a.y>=2011)&(a.y<=2018)]
                if len(z)>=100: mx=max(mx,pf(z.r))
        best.append(mx)
    print('NULLO (ingressi casuali): miglior PF IS della griglia media %.2f max %.2f'%(np.mean(best),np.max(best)))
