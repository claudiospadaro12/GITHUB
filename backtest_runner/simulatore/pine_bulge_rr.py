#!/usr/bin/env python3
# Criteri: report/PINE_BULGE_FASCIANO_CRITERI_2026-11-24.md (AGGIUNTA 3)
import sys,os,glob
_orig=open('/home/user/GITHUB/backtest_runner/simulatore/pine_bulge_fasciano.py').read().split("sets={}\n")[0]
import numpy as np,pandas as pd
sys.argv_backup=sys.argv; sys.argv=[sys.argv[0]]
exec(_orig)
sys.argv=sys.argv_backup
MINRR=[0,0.3,0.5,0.7,1.0,1.2,1.5]
def prep2(O,H,L,C,idx,minrr):
    n=len(C); s=pd.Series(C)
    basis=s.rolling(20).mean().values; dev=2*s.rolling(20).std(ddof=0).values
    up=basis+dev; lo=basis-dev; w=up-lo; avgw=pd.Series(w).rolling(20).mean().values; bul=w>avgw*1.12
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum(H-L,np.maximum(abs(H-pc),abs(L-pc))); atr=pd.Series(tr).rolling(14).mean().values
    sig=np.zeros(n,int); lb=-1000; ls=-1000
    for t in range(41,n-2):
        if bul[t-1] and C[t-1]<lo[t-1] and C[t]>lo[t] and C[t]<basis[t]:
            risk=C[t]-(L[t]-3*atr[t]); rr=(basis[t]-C[t])/risk if risk>0 else 0
            if rr>=minrr and t-lb>6: sig[t]=1; lb=t
        if bul[t-1] and C[t-1]>up[t-1] and C[t]<up[t] and C[t]>basis[t]:
            risk=(H[t]+3*atr[t])-C[t]; rr=(C[t]-basis[t])/risk if risk>0 else 0
            if rr>=minrr and t-ls>6: sig[t]=-1; ls=t
    return sig,basis,atr
def run2(O,H,L,C,idx,pre):
    sig,basis,atr=pre; n=len(C); tr=[]; t=41
    while t<n-2:
        d=sig[t]
        if d==0: t+=1; continue
        ent=O[t+1]; sl=(L[t]-3*atr[t]) if d==1 else (H[t]+3*atr[t]); tp=basis[t]
        ex=None; j=t+1
        for j in range(t+1,min(t+1+TMO,n)):
            if d==1:
                if L[j]<=sl: ex=min(O[j],sl); break
                if H[j]>=tp and tp>ent: ex=max(O[j],tp) if O[j]>tp else tp; break
            else:
                if H[j]>=sl: ex=max(O[j],sl); break
                if L[j]<=tp and tp<ent: ex=min(O[j],tp) if O[j]<tp else tp; break
        if ex is None: ex=C[j]
        tr.append((idx[t+1],d*(ex-ent)/ent-2*CF)); t=j+1
    return tr
def spearmanr(a,b):
    a=pd.Series(a).rank().values; b=pd.Series(b).rank().values
    return (float(np.corrcoef(a,b)[0,1]),)
def gruppo(nome,sets):
    res={}
    for s,(d,iy) in sets.items():
        O,H,L,C=[d[c].values for c in ('open','high','low','close')]
        for m in MINRR: res[(s,m)]=(run2(O,H,L,C,d.index,prep2(O,H,L,C,d.index,m)),iy)
    print('=== %s ==='%nome)
    for m in MINRR:
        i=[];o=[]
        for (s,mm),(tr,iy) in res.items():
            if mm==m: i+=[x for d_,x in tr if d_.year<=iy]; o+=[x for d_,x in tr if d_.year>iy]
        print('  minRR %.1f  IS n=%6d PF %.2f | OOS n=%6d PF %.2f'%(m,len(i),pf(i),len(o),pf(o)))
    best=max(MINRR,key=lambda m:pf([x for (s,mm),(tr,iy) in res.items() if mm==m for d_,x in tr if d_.year<=iy]))
    print('  minRR migliore in-sample: %.1f'%best)
    rows=[]
    for s in sets:
        tr,iy=res[(s,best)]; i=[x for d_,x in tr if d_.year<=iy]; o=[x for d_,x in tr if d_.year>iy]
        rows.append((s,pf(i),len(i),pf(o),len(o)))
    rows.sort(key=lambda r:-(r[1] if r[1]==r[1] else -1))
    ok=[r for r in rows if r[1]==r[1] and r[3]==r[3]]
    rho=spearmanr([r[1] for r in ok],[r[3] for r in ok])[0] if len(ok)>3 else float('nan')
    print('  CLASSIFICA per PF in-sample (minRR %.1f): simbolo | IS PF (n) | OOS PF (n)'%best)
    for k,r in enumerate(rows,1): print('   %2d. %-12s IS %.2f (%d) | OOS %.2f (%d)'%(k,r[0],r[1],r[2],r[3],r[4]))
    print('  correlazione di rango IS vs OOS (Spearman): %.2f'%rho)
gruppo('FOREX H1 (10 cross)',load_forex_h1())
gruppo('FOREX D1 (28 cross)',load_d1())
h={}; h.update(load_h1()); h.update(load_h1_ext()); gruppo('H1 oro, Bitcoin, EURUSD, Nasdaq, S&P, DAX',h)
