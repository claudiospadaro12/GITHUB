import glob,itertools,csv,sys
import numpy as np,pandas as pd
fr=[pd.read_csv(f,sep=';') for f in sorted(glob.glob('/tmp/claude-0/btc/ABTG_M1_BTCUSD_20*.csv'))]
d=pd.concat(fr); d['time']=pd.to_datetime(d['time'],format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('time').set_index('time').sort_index()
D=d.resample('1D').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
print('barre D1',len(D),D.index[0].date(),D.index[-1].date(),'| prezzo min/max',round(D['close'].min(),1),round(D['close'].max()))
O,H,L,C=[D[k].values for k in ('open','high','low','close')]; idx=D.index; n=len(C)
pc=np.r_[C[0],C[:-1]]; tr=np.maximum.reduce([H-L,np.abs(H-pc),np.abs(L-pc)]); atr=pd.Series(tr).rolling(14).mean().values
def sim(N,mi,mt,swap=0.10,cost=0.0005):
    hh=pd.Series(H).rolling(N).max().shift(1).values; out=[]; i=max(N,14)+1
    while i<n-1:
        if C[i]>hh[i] and not np.isnan(atr[i]) and atr[i]>0:
            ent=O[i+1]; risk=mi*atr[i]; stop=ent-risk; ext=ent; j=i+1; res=None
            while j<n:
                if L[j]<=stop: px=min(O[j],stop) if j>i+1 else stop; res=px; break
                ext=max(ext,H[j]); stop=max(stop,ext-mt*atr[j]); j+=1
            if res is None: break
            days=(idx[j]-idx[i+1]).days+1
            R=((res-ent)-cost*ent-swap*ent*days/365.0)/risk
            out.append((idx[i+1],R,ent,res)); i=j+1
        else: i+=1
    return out
def st(v):
    v=np.array(v)
    if len(v)==0: return 0,0.0,0.0
    g=v[v>0].sum(); l=-v[v<0].sum(); return len(v),(g/l if l>0 else 99.0),v.sum()
WIN={'IS':('2015-01-01','2020-12-31'),'OOS':('2021-01-01','2023-12-31'),'HO':('2024-01-01','2026-11-13')}
def win(tr,w): a,b=map(pd.Timestamp,WIN[w]); return [R for t,R,*_ in tr if a<=t<=b+pd.Timedelta(days=1)]
Ns=(20,40,80); Ms=(2,3,4); Ts=(3,4,6); grid=list(itertools.product(range(3),range(3),range(3)))
lab=lambda g:'N%d s%d t%d'%(Ns[g[0]],Ms[g[1]],Ts[g[2]])
def nb(g):
    o=[]
    for k in range(3):
        for dd in (-1,1):
            x=list(g); x[k]+=dd
            if 0<=x[k]<3: o.append(tuple(x))
    return o
res={}; 
for g in grid:
    tr=sim(Ns[g[0]],Ms[g[1]],Ts[g[2]]); res[g]={w:st(win(tr,w)) for w in ('IS','OOS')}
    res[g]['sw']={s:st(win(sim(Ns[g[0]],Ms[g[1]],Ts[g[2]],swap=s),'IS')+win(sim(Ns[g[0]],Ms[g[1]],Ts[g[2]],swap=s),'OOS')) for s in (0.0,0.20)}
print('cella | IS n PF R | OOS n PF R | PF IS+OOS swap0 / swap20 | G1 G2 plateau')
fin=[]
for g in sorted(grid,key=lambda g:-res[g]['IS'][1]):
    a=res[g]['IS']; b=res[g]['OOS']; g1=a[0]>=40 and a[1]>=1.3; g2=b[0]>=20 and b[1]>=1.2 and b[2]>0
    nbs=nb(g); pl=sum(1 for q in nbs if res[q]['IS'][1]>1.0 and res[q]['OOS'][1]>1.0)/len(nbs)
    print('%-12s | %3d %.2f %+6.1f | %3d %.2f %+6.1f | %.2f / %.2f | %s %s %.2f'%(lab(g),a[0],a[1],a[2],b[0],b[1],b[2],res[g]['sw'][0.0][1],res[g]['sw'][0.20][1],g1,g2,pl))
    if g1 and g2 and pl>=0.7: fin.append(g)
print('FINALISTI:',[lab(g) for g in fin],'| IS PF mediano',round(float(np.median([res[g]['IS'][1] for g in grid])),2),'OOS',round(float(np.median([res[g]['OOS'][1] for g in grid])),2),'| medio PF IS+OOS swap0',round(float(np.mean([res[g]['sw'][0.0][1] for g in grid])),2),'swap20',round(float(np.mean([res[g]['sw'][0.20][1] for g in grid])),2))
with open('/home/user/GITHUB/report/BTC_D1_NOSTRO_dati_griglia.csv','w',newline='') as f:
    w=csv.writer(f,delimiter=';'); w.writerow(['cella','nIS','pfIS','RIS','nOOS','pfOOS','ROOS'])
    for g in grid: w.writerow([lab(g)]+[round(x,3) if isinstance(x,float) else x for x in res[g]['IS']+res[g]['OOS']])
import pickle; pickle.dump(fin,open('/tmp/claude-0/btc/fin.pkl','wb'))
