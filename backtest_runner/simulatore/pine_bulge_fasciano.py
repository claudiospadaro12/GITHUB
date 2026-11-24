#!/usr/bin/env python3
# Criteri: report/PINE_BULGE_FASCIANO_CRITERI_2026-11-24.md
import sys,os,glob,numpy as np,pandas as pd
CF=0.0002; TMO=40
RRS=[None,0.3,0.5,0.7,1.0,1.2,1.5]
def prep(O,H,L,C,idx):
    n=len(C); s=pd.Series(C)
    basis=s.rolling(20).mean().values; dev=2*s.rolling(20).std(ddof=0).values
    up=basis+dev; lo=basis-dev; w=up-lo; avgw=pd.Series(w).rolling(20).mean().values
    bul=w>avgw*1.12
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum(H-L,np.maximum(abs(H-pc),abs(L-pc))); atr=pd.Series(tr).rolling(14).mean().values
    buy=np.zeros(n,bool); sell=np.zeros(n,bool)
    for t in range(41,n-2):
        if bul[t-1] and C[t-1]<lo[t-1] and C[t]>lo[t] and C[t]<basis[t]: buy[t]=True
        if bul[t-1] and C[t-1]>up[t-1] and C[t]<up[t] and C[t]>basis[t]: sell[t]=True
    return basis,atr,buy,sell
def run(O,H,L,C,idx,pre,rr):
    basis,atr,buy,sell=pre; n=len(C); tr=[]; t=41
    while t<n-2:
        d=1 if buy[t] else (-1 if sell[t] else 0)
        if d==0: t+=1; continue
        ent=O[t+1]; sl=(L[t]-3*atr[t]) if d==1 else (H[t]+3*atr[t])
        risk=abs(ent-sl)
        if risk<=0 or np.isnan(risk): t+=1; continue
        tp_fixed=None if rr is None else ent+d*rr*risk
        ex=None; j=t+1
        for j in range(t+1,min(t+1+TMO,n)):
            tp=tp_fixed if rr is not None else basis[j-1] if j>t+1 else basis[t]
            if d==1:
                if L[j]<=sl: ex=min(O[j],sl); break
                if H[j]>=tp and tp>ent: ex=max(O[j],tp) if O[j]>tp else tp; break
            else:
                if H[j]>=sl: ex=max(O[j],sl); break
                if L[j]<=tp and tp<ent: ex=min(O[j],tp) if O[j]<tp else tp; break
        if ex is None: ex=C[j]
        tr.append((idx[t+1],d*(ex-ent)/ent-2*CF)); t=j+1
    return tr
def pf(r):
    r=np.array(r)
    if len(r)==0: return np.nan
    gp=r[r>0].sum(); gl=-r[r<0].sum(); return gp/gl if gl>0 else np.inf
def load_d1():
    out={}
    for f in sorted(glob.glob('/tmp/claude-0/fxd/ABTG_D1_*.csv')):
        s=os.path.basename(f)[8:-4]
        d=pd.read_csv(f,sep=';',parse_dates=['date'],date_format='%Y.%m.%d').set_index('date')
        d=d[(d.index>=pd.Timestamp('2000-01-01'))&(d.index<pd.Timestamp('2026-11-24'))&(d.high>d.low)]; out[s]=(d,2015)
    return out
def m1_h1(files,sep=';'):
    ds=[]
    for f in files:
        d=pd.read_csv(f,sep=sep,header=0,names=['t','open','high','low','close','tv','sp'])
        d['t']=pd.to_datetime(d['t'],format='%Y.%m.%d %H:%M'); ds.append(d)
    d=pd.concat(ds).set_index('t').sort_index()
    d=d[~((d.index.hour==0)&(d.index.minute==0)&(d.tv>2000))]
    h=d.resample('1h').agg({'open':'first','high':'max','low':'min','close':'last'}).dropna()
    return h
def load_h1():
    out={}
    g=sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')); out['XAUUSD_H1']=(m1_h1(g),2018)
    b=[f for f in sorted(glob.glob('/tmp/claude-0/btc/ABTG_M1_BTCUSD_*.csv')) if int(f[-8:-4])>=2017]; out['BTCUSD_H1']=(m1_h1(b),2018)
    return out
sets={}
sets.update(load_d1()); 
if '--solo-d1' not in sys.argv: sets.update(load_h1())
res={}
for s,(d,iy) in sets.items():
    O,H,L,C=[d[c].values for c in ('open','high','low','close')]; pre=prep(O,H,L,C,d.index)
    for rr in RRS: res[(s,rr)]=(run(O,H,L,C,d.index,pre,rr),iy)
name=lambda rr:'mediana' if rr is None else 'R=%.1f'%rr
print('=== POOLED per cella (tutti i simboli D1 insieme; H1 a parte) ===')
for grp,filt in (('D1 forex',lambda s:not s.endswith('_H1')),('H1 oro+BTC',lambda s:s.endswith('_H1'))):
    print(grp)
    for rr in RRS:
        i=[];o=[]
        for (s,r),(tr,iy) in res.items():
            if r==rr and filt(s):
                i+=[x for d_,x in tr if d_.year<=iy]; o+=[x for d_,x in tr if d_.year>iy]
        print('  %-8s IS n=%5d PF %.2f | OOS n=%5d PF %.2f'%(name(rr),len(i),pf(i),len(o),pf(o)))
best=None
bi=-1
for rr in RRS:
    i=[x for (s,r),(tr,iy) in res.items() if r==rr and not s.endswith('_H1') for d_,x in tr if d_.year<=iy]
    if len(i)>=150 and pf(i)>bi: bi=pf(i); best=rr
print('Cella migliore in-sample (D1 forex):',name(best),'PF IS %.2f'%bi)
print('=== PF per simbolo: [mediana] e [migliore %s] (IS | OOS, n) ==='%name(best))
for s in sets:
    row=[]
    for rr in (None,best):
        tr,iy=res[(s,rr)]
        i=[x for d_,x in tr if d_.year<=iy]; o=[x for d_,x in tr if d_.year>iy]
        row.append('%s IS %.2f(%d) OOS %.2f(%d)'%(name(rr),pf(i),len(i),pf(o),len(o)))
    print('%-10s | %s'%(s,' || '.join(row)))
