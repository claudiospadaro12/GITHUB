import warnings;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd,itertools
D='/tmp/idx/%s_M1_%d/%s_M1_%d.csv'; import sys
K=float(sys.argv[1]) if len(sys.argv)>1 else 1.0
COST={'NASUSD':1.8*K,'SPXUSD':0.6*K}
SE=[600,630,660,720,780,840,900]; EE=[None,720,780,840,900,930]
def mm(h,m=0): return h*60+m
def load(sym):
    fr=[]
    for y in range(2015,2027):
        d=pd.read_csv(D%(sym,y,sym,y),usecols=['Time','Open','Close']); d['Time']=pd.to_datetime(d['Time'],format='%Y.%m.%d %H:%M'); fr.append(d)
    d=pd.concat(fr); d['day']=d.Time.dt.normalize(); d['mod']=d.Time.dt.hour*60+d.Time.dt.minute
    need=set([570,959,960]+SE+[e for e in EE if e]+[s+k for s in SE for k in (30,60)]+[e+k for e in EE if e for k in (30,60)])
    need=[n for n in need if n<=960]
    o=d[d['mod'].isin(need)].pivot_table(index='day',columns='mod',values='Open',aggfunc='first')
    c=d[d['mod']==959].set_index('day')['Close']
    o['pc']=c.shift(1); return o.dropna(subset=[570,960,'pc'])
def cells():
    out=[]
    for ref in ('pc',570):
        for S in SE:
            for E in EE:
                e=S if E is None else E
                if e<S: continue
                for X in (e+30,e+60,960):
                    if X>960 or X<=e: continue
                    out.append((ref,S,e,X))
    return sorted(set(out),key=str)
def pf(p):
    w=p[p>0].sum(); l=-p[p<0].sum(); return w/l if l>0 else np.nan
def evalcell(o,cost,ref,S,e,X,sgn,rs=None):
    cols=[ref,S,e,X]; sub=o.dropna(subset=cols)
    s=np.sign(sub[S]-sub[ref]).values if rs is None else rs[:len(sub)]
    g=(sub[X]-sub[e]).values; p=sgn*s*g-cost; m=(s!=0)
    return sub.index[m],p[m]
def main():
    data={s:load(s) for s in COST}; C=cells(); print('celle posizione/uscita:',len(C),'x2 direzioni x2 indici')
    rows=[]
    for ref,S,e,X in C:
        for sgn in (1,-1):
            r={'ref':ref,'S':S,'E':e,'X':X,'dir':'cont' if sgn==1 else 'inv'}
            for sym,o in data.items():
                idx,p=evalcell(o,COST[sym],ref,S,e,X,sgn); yr=idx.year.values
                IS=p[(yr<=2020)];OO=p[(yr>=2021)&(yr<=2024)]
                _,p2=evalcell(o,COST[sym]*2,ref,S,e,X,sgn); y2=_.year.values; OO2=p2[(y2>=2021)&(y2<=2024)]
                ya=pd.Series(p).groupby(yr).sum()
                r.update({sym+'_nIS':len(IS),sym+'_pfIS':pf(IS),sym+'_pfOOS':pf(OO),sym+'_pfOOSx2':pf(OO2),sym+'_yrpos':(ya>0).mean()})
            rows.append(r)
    R=pd.DataFrame(rows)
    ok=lambda s:(R[s+'_nIS']>=200)&(R[s+'_pfIS']>=1.3)&(R[s+'_pfOOS']>=1.2)&(R[s+'_pfOOSx2']>1.0)&(R[s+'_yrpos']>=0.6)
    R['pass']=ok('NASUSD')&ok('SPXUSD'); R['passN']=ok('NASUSD'); R['passS']=ok('SPXUSD')
    print('celle totali',len(R),'| passano entrambi',R['pass'].sum(),'| solo NAS',R.passN.sum(),'| solo SPX',R.passS.sum())
    R['minIS']=R[['NASUSD_pfIS','SPXUSD_pfIS']].min(axis=1); R['minOOS']=R[['NASUSD_pfOOS','SPXUSD_pfOOS']].min(axis=1)
    print('MIGLIORI per min(PF IS) su entrambi:'); print(R.sort_values('minIS',ascending=False).head(8)[['ref','S','E','X','dir','NASUSD_pfIS','NASUSD_pfOOS','SPXUSD_pfIS','SPXUSD_pfOOS']].round(2).to_string(index=False))
    print('MIGLIORI per min(PF OOS):'); print(R.sort_values('minOOS',ascending=False).head(5)[['ref','S','E','X','dir','NASUSD_pfIS','NASUSD_pfOOS','SPXUSD_pfIS','SPXUSD_pfOOS']].round(2).to_string(index=False))
    print('Max PF IS singolo indice reale: NAS %.2f SPX %.2f | max PF OOS: NAS %.2f SPX %.2f'%(R.NASUSD_pfIS.max(),R.SPXUSD_pfIS.max(),R.NASUSD_pfOOS.max(),R.SPXUSD_pfOOS.max()))
    # nullo: segnale casuale, intera griglia, 20 repliche
    rng=np.random.default_rng(20261127); best=[]
    for rep in range(20):
        b=[]
        for sym,o in data.items():
            mx=[]
            for ref,S,e,X in C:
                sub=o.dropna(subset=[ref,S,e,X]); rs=rng.choice([-1,1],len(sub))
                idx,p=evalcell(o,COST[sym],ref,S,e,X,1,rs); yr=idx.year.values; mx.append(pf(p[yr<=2020]))
            b.append(np.nanmax(mx))
        best.append(b)
    best=np.array(best); print('NULLO casuale, miglior PF IS della griglia: NAS media %.2f max %.2f | SPX media %.2f max %.2f'%(best[:,0].mean(),best[:,0].max(),best[:,1].mean(),best[:,1].max()))
    R.to_csv('/tmp/work/momentum_griglia.csv',index=False)
main()
