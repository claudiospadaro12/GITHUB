import sys,glob,itertools,csv,os
import numpy as np,pandas as pd
D='/tmp/claude-0/exp/x/'
def load(sym):
    fr=[pd.read_csv(f,sep=';') for f in sorted(glob.glob(D+'ABTG_M1_%s_20*.csv'%sym))]
    d=pd.concat(fr); d['time']=pd.to_datetime(d['time'],format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('time').set_index('time').sort_index()
    r=d.resample('15min').agg({'open':'first','high':'max','low':'min','close':'last','spread':'first'}).dropna()
    return r
def sim(r,N,comp,mi,mt,t0=None,t1=None):
    O,H,L,C=[r[k].values for k in ('open','high','low','close')]; SP=r['spread'].values*0.01; idx=r.index; n=len(C)
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum.reduce([H-L,np.abs(H-pc),np.abs(L-pc)])
    af=pd.Series(tr).rolling(14).mean().values; as_=pd.Series(tr).rolling(96).mean().values
    hh=pd.Series(H).rolling(N).max().shift(1).values; ll=pd.Series(L).rolling(N).min().shift(1).values
    out=[]; pos=0; i=max(N,96)+2
    while i<n-1:
        if pos==0:
            if np.isnan(af[i]) or af[i]<=0 or np.isnan(as_[i]): i+=1; continue
            if comp>0 and af[i]/as_[i]>comp: i+=1; continue
            d=0
            if C[i]>hh[i]: d=1
            elif C[i]<ll[i]: d=-1
            if d==0: i+=1; continue
            sp=SP[i+1]; ent=O[i+1]+(sp if d==1 else 0.0); risk=mi*af[i]
            stop=ent-d*risk; ext=O[i+1]; j=i+1; atr_t=af[i]; res=None
            while j<n:
                if d==1:
                    if L[j]<=stop: px=min(O[j],stop); res=(px-ent); break
                    ext=max(ext,H[j]); stop=max(stop,ext-mt*af[j])
                else:
                    if H[j]+SP[j]>=stop: px=max(O[j]+SP[j],stop); res=(ent-px); break
                    ext=min(ext,L[j]); stop=min(stop,ext+mt*af[j])
                j+=1
            if res is None: break
            out.append((idx[i+1],res/risk,d)); i=j+1
        else: i+=1
    return out
def st(v):
    v=np.array(v)
    if len(v)==0: return 0,0.0,0.0
    g=v[v>0].sum(); l=-v[v<0].sum(); return len(v),(g/l if l>0 else 99.0),v.sum()
W={'IS':('2024-09-26','2025-06-30 23:59'),'OOS':('2025-07-01','2026-02-28 23:59'),'HO':('2026-03-01','2026-11-13 23:59')}
def win(tr,w): a,b=map(pd.Timestamp,W[w]); return [R for t,R,d in tr if a<=t<=b]
Ns=(16,24,48); Cs=(0.0,0.8); Ms=(1.5,2.5); Ts=(2.0,3.0)
grid=list(itertools.product(range(3),range(2),range(2),range(2)))
rd=load('U30USD'); print('barre M15',len(rd),rd.index[0],rd.index[-1],'spread medio punti',round(rd['spread'].mean(),1),flush=True)
res={}; trs={}
for g in grid:
    tr=sim(rd,Ns[g[0]],Cs[g[1]],Ms[g[2]],Ts[g[3]]); trs[g]=tr
    res[g]={w:st(win(tr,w)) for w in ('IS','OOS')}
def nb(g):
    out=[]
    for k,m in enumerate((3,2,2,2)):
        for dd in (-1,1):
            x=list(g); x[k]+=dd
            if 0<=x[k]<m: out.append(tuple(x))
    return out
def lab(g): return 'N%d c%s s%.1f t%.0f'%(Ns[g[0]],('off' if Cs[g[1]]==0 else '0.8'),Ms[g[2]],Ts[g[3]])
print('cella | IS n PF R | OOS n PF R | G1 G2 plateau')
fin=[]
for g in sorted(grid,key=lambda g:-res[g]['IS'][1]):
    a=res[g]['IS']; b=res[g]['OOS']
    g1=a[0]>=60 and a[1]>=1.20; g2=b[0]>=30 and b[1]>=1.10 and b[2]>0
    nbs=nb(g); pl=sum(1 for q in nbs if res[q]['IS'][1]>1.0 and res[q]['OOS'][1]>1.0)/len(nbs)
    print('%-18s | %3d %.2f %+6.1f | %3d %.2f %+6.1f | %s %s %.2f'%(lab(g),a[0],a[1],a[2],b[0],b[1],b[2],g1,g2,pl))
    if g1 and g2 and pl>=0.7: fin.append(g)
print('FINALISTI (G1+G2+G3):',[lab(g) for g in fin])
print('celle con IS PF>=1.2:',sum(1 for g in grid if res[g]['IS'][1]>=1.2),'| con OOS PF>=1.1:',sum(1 for g in grid if res[g]['OOS'][1]>=1.1),'| IS PF mediano',round(float(np.median([res[g]['IS'][1] for g in grid])),2),'OOS PF mediano',round(float(np.median([res[g]['OOS'][1] for g in grid])),2))
with open('/home/user/GITHUB/report/DOWRAPTOR_NOSTRO_dati_griglia.csv','w',newline='') as f:
    w=csv.writer(f,delimiter=';'); w.writerow(['cella','nIS','pfIS','RIS','nOOS','pfOOS','ROOS'])
    for g in grid: w.writerow([lab(g)]+[round(x,3) if isinstance(x,float) else x for x in res[g]['IS']+res[g]['OOS']])
