import sys,glob,itertools,csv,datetime as dt
import numpy as np,pandas as pd
D='/tmp/claude-0/exp/x/'
def load(sym):
    fr=[pd.read_csv(f,sep=';') for f in sorted(glob.glob(D+'ABTG_M1_%s_20*.csv'%sym))]
    d=pd.concat(fr); d['time']=pd.to_datetime(d['time'],format='%Y.%m.%d %H:%M'); return d.drop_duplicates('time').set_index('time').sort_index()
def nth_sunday(y,m,n):
    d=dt.date(y,m,1); k=(6-d.weekday())%7; return d+dt.timedelta(days=k+7*(n-1))
def us_dst(day):
    a=nth_sunday(day.year,3,2); b=nth_sunday(day.year,11,1); return a<=day<b
def run(d,R,trend,stopmode,exitmode,t0=None,t1=None):
    ts=d.index.values; O=d['open'].values; H=d['high'].values; L=d['low'].values; C=d['close'].values; SP=d['spread'].values*0.01
    days=pd.Series(d.index.date); first={}
    for k,(x) in enumerate(d.index.date):
        if x not in first: first[x]=k
    dl=sorted(first); dc={}
    for x in dl:
        pass
    # chiusura giornaliera = ultima barra del giorno
    last={}
    for k,x in enumerate(d.index.date): last[x]=k
    dcl=[C[last[x]] for x in dl]; out=[]
    for di,x in enumerate(dl):
        if di<20: 
            if trend: continue
        up=dn=True
        if trend:
            pcl=dcl[di-1]; ma=np.mean(dcl[di-20:di]); up=pcl>ma; dn=pcl<ma
        op=pd.Timestamp(x)+pd.Timedelta(hours=14 if us_dst(x) else 15,minutes=30)
        i0=np.searchsorted(ts,np.datetime64(op)); 
        if i0>=len(ts) or (ts[i0]-np.datetime64(op))>np.timedelta64(5,'m'): continue
        iE=np.searchsorted(ts,np.datetime64(op+pd.Timedelta(minutes=R))); iS=np.searchsorted(ts,np.datetime64(op+pd.Timedelta(minutes=390)))
        if iE-i0<R*0.6 or iS<=iE+3 or iS>=len(ts): continue
        Hor=H[i0:iE].max(); Lor=L[i0:iE].min(); W=Hor-Lor
        if W<=0: continue
        j=iE; dirn=0
        while j<iS:
            lt=H[j]>Hor and up; st_=L[j]<Lor and dn
            if H[j]>Hor and L[j]<Lor: break
            if lt: dirn=1; break
            if st_: dirn=-1; break
            j+=1
        if dirn==0: continue
        ent=(Hor+SP[j]) if dirn==1 else Lor
        sl=(Lor if stopmode==0 else (Hor+Lor)/2) if dirn==1 else (Hor if stopmode==0 else (Hor+Lor)/2)
        risk=(ent-sl) if dirn==1 else (sl-ent)
        if risk<=0: continue
        m={0:1.0,1:2.0,2:None}[exitmode]
        tp=None if m is None else ((Hor+m*W) if dirn==1 else (Lor-m*W))
        k=j; res=None
        while k<iS:
            if dirn==1:
                if L[k]<=sl: res=min(O[k] if k>j else sl,sl)-ent; break
                if tp is not None and k>j and H[k]>=tp: res=max(O[k],tp)-ent; break
            else:
                if H[k]+SP[k]>=sl: res=ent-(max(O[k]+SP[k] if k>j else sl,sl)); break
                if tp is not None and k>j and L[k]+SP[k]<=tp: res=ent-min(O[k]+SP[k],tp); break
            k+=1
        if res is None: res=((O[iS]-ent) if dirn==1 else (ent-(O[iS]+SP[iS])))
        out.append((pd.Timestamp(ts[j]),res/risk,dirn))
    return out
def st(v):
    v=np.array(v)
    if len(v)==0: return 0,0.0,0.0
    g=v[v>0].sum(); l=-v[v<0].sum(); return len(v),(g/l if l>0 else 99.0),v.sum()
W={'IS':('2024-09-26','2025-06-30 23:59'),'OOS':('2025-07-01','2026-02-28 23:59'),'HO':('2026-03-01','2026-11-13 23:59')}
def win(tr,w): a,b=map(pd.Timestamp,W[w]); return [R for t,R,dd in tr if a<=t<=b]
Rs=(15,30); Ts=(False,True); Ss=(0,1); Es=(0,1,2)
grid=list(itertools.product(range(2),range(2),range(2),range(3)))
def lab(g): return 'R%d %s stop-%s %s'%(Rs[g[0]],'trend' if Ts[g[1]] else 'senza','opp' if g[2]==0 else 'meta',('TP1','TP2','fine')[g[3]])
def nb(g):
    out=[]
    for k,m in enumerate((2,2,2,3)):
        for dd in (-1,1):
            x=list(g); x[k]+=dd
            if 0<=x[k]<m: out.append(tuple(x))
    return out
if __name__=='__main__':
    d=load('U30USD'); res={}
    for g in grid:
        tr=run(d,Rs[g[0]],Ts[g[1]],Ss[g[2]],Es[g[3]]); res[g]={w:st(win(tr,w)) for w in ('IS','OOS')}
    print('cella | IS n PF R | OOS n PF R | G1 G2 plateau')
    fin=[]
    for g in sorted(grid,key=lambda g:-res[g]['IS'][1]):
        a=res[g]['IS']; b=res[g]['OOS']; g1=a[0]>=60 and a[1]>=1.2; g2=b[0]>=30 and b[1]>=1.1 and b[2]>0
        nbs=nb(g); pl=sum(1 for q in nbs if res[q]['IS'][1]>1.0 and res[q]['OOS'][1]>1.0)/len(nbs)
        print('%-26s | %3d %.2f %+6.1f | %3d %.2f %+6.1f | %s %s %.2f'%(lab(g),a[0],a[1],a[2],b[0],b[1],b[2],g1,g2,pl))
        if g1 and g2 and pl>=0.7: fin.append(g)
    print('FINALISTI:',[lab(g) for g in fin])
    print('IS PF>=1.2:',sum(1 for g in grid if res[g]['IS'][1]>=1.2),'| IS PF mediano',round(float(np.median([res[g]['IS'][1] for g in grid])),2),'| OOS PF mediano',round(float(np.median([res[g]['OOS'][1] for g in grid])),2),'| celle con n>=60 in IS:',sum(1 for g in grid if res[g]['IS'][0]>=60))
    with open('/home/user/GITHUB/report/DOWRAPTOR_APERTURA_USA_dati_griglia.csv','w',newline='') as f:
        w=csv.writer(f,delimiter=';'); w.writerow(['cella','nIS','pfIS','RIS','nOOS','pfOOS','ROOS'])
        for g in grid: w.writerow([lab(g)]+[round(x,3) if isinstance(x,float) else x for x in res[g]['IS']+res[g]['OOS']])
