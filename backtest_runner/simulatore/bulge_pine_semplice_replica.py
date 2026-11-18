import csv, glob, json, sys, math
import numpy as np
def load_h1(files):
    rows={}
    for f in files:
        with open(f) as fh:
            r=csv.reader(fh,delimiter=';'); next(r)
            for t,o,h,l,c,*_ in r:
                k=t[:13]; o,h,l,c=float(o),float(h),float(l),float(c)
                if k not in rows: rows[k]=[o,h,l,c]
                else:
                    x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
files=sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv'))
ks,A=load_h1(files); O,H,L,C=A.T; n=len(C)
#print("barre H1",n,ks[0],ks[-1],file=sys.stderr)
P,DEV=20,2.0
basis=np.full(n,np.nan);up=basis.copy();lo=basis.copy()
for i in range(P-1,n):
    w=C[i-P+1:i+1]; m=w.mean(); s=w.std()  # std popolazione come iBands
    basis[i]=m; up[i]=m+DEV*s; lo[i]=m-DEV*s
tr=np.zeros(n); tr[0]=H[0]-L[0]
for i in range(1,n): tr[i]=max(H[i]-L[i],abs(H[i]-C[i-1]),abs(L[i]-C[i-1]))
atr=np.full(n,np.nan)
for i in range(13,n): atr[i]=tr[i-13:i+1].mean()   # iATR MT5 = media semplice del TR
# ADX Wilder (approssimazione dell'iADX)
def adx14():
    pdm=np.zeros(n);mdm=np.zeros(n)
    for i in range(1,n):
        u=H[i]-H[i-1]; d=L[i-1]-L[i]
        pdm[i]=u if (u>d and u>0) else 0; mdm[i]=d if (d>u and d>0) else 0
    a=np.full(n,np.nan); 
    tr14=tr[1:15].sum(); p14=pdm[1:15].sum(); m14=mdm[1:15].sum(); dx=[]
    out=np.full(n,np.nan)
    for i in range(15,n):
        tr14=tr14-tr14/14+tr[i]; p14=p14-p14/14+pdm[i]; m14=m14-m14/14+mdm[i]
        pdi=100*p14/tr14; mdi=100*m14/tr14; dxi=100*abs(pdi-mdi)/(pdi+mdi) if pdi+mdi>0 else 0
        dx.append(dxi)
        if len(dx)==14: out[i]=np.mean(dx)
        elif len(dx)>14: out[i]=(out[i-1]*13+dxi)/14
    return out
adx=adx14()
LB=20; BWL=50; BM=1.1
barsNeeded=LB*2+10+1
def signals(j,B=1,noC=False):
    """decisione al primo tick della barra j (forming). indice 'k barre fa' -> j-k"""
    g=lambda arr,k: arr[j-k]
    if j-barsNeeded<0 or np.isnan(adx[j-1]) or np.isnan(lo[j-barsNeeded]): return []
    # AtrOk (barra 1)
    at=[g(atr,k) for k in range(1,21)]; atrMA=np.mean(at)
    if not (at[0]<=atrMA*1.8 and at[0]>=atrMA*0.5): return []
    iC,iS=B,B+1
    atrS=g(atr,iS); 
    wS=g(up,iS)-g(lo,iS); wMA=np.mean([g(up,k)-g(lo,k) for k in range(1,BWL+1)])
    isBulge=wS>=wMA*BM
    iDn=iUp=-1
    for k in range(iS,barsNeeded-1):
        body=abs(g(C,k)-g(O,k)); a=g(atr,k)
        if iDn<0 and g(L,k)<=g(lo,k) and g(C,k)<g(O,k) and body>=a*0.2: iDn=k
        if iUp<0 and g(H,k)>=g(up,k) and g(C,k)>g(O,k) and body>=a*0.2: iUp=k
        if iDn>=0 and iUp>=0: break
    rDn=-1 if iDn<0 else iDn-B; rUp=-1 if iUp<0 else iUp-B
    midDn=oppDn=midUp=oppUp=False
    if iDn>B:
        for k in range(iS,iDn):
            if g(H,k)>=g(basis,k) and g(L,k)<=g(basis,k): midDn=True
            if g(H,k)>=g(up,k): oppDn=True
    if iUp>B:
        for k in range(iS,iUp):
            if g(H,k)>=g(basis,k) and g(L,k)<=g(basis,k): midUp=True
            if g(L,k)<=g(lo,k): oppUp=True
    lowF=abs(g(lo,iS)-g(lo,iS+6))<=atrS*0.6; upF=abs(g(up,iS)-g(up,iS+6))<=atrS*0.6
    bullR=g(C,iS)>g(O,iS) and g(L,iS)<=g(lo,iS); bearR=g(C,iS)<g(O,iS) and g(H,iS)>=g(up,iS)
    oL=isBulge and 1<=rDn<=LB and not midDn and not oppDn and bullR
    oS=isBulge and 1<=rUp<=LB and not midUp and not oppUp and bearR
    out=[]
    adxOk=g(adx,1)<30
    cL=g(C,iC)>g(O,iC) and not (g(L,iC)<=g(lo,iC)) and g(C,iC)>g(L,iS)
    cS=g(C,iC)<g(O,iC) and not (g(H,iC)>=g(up,iC)) and g(C,iC)<g(H,iS)
    if oL and cL and adxOk: out.append(("BLU",True,atrS,g(basis,max(iC,1) if noC else iC),iDn,iS,iC))
    if oS and cS and adxOk: out.append(("BLU",False,atrS,g(basis,max(iC,1) if noC else iC),iUp,iS,iC))
    pe=abs(g(C,iC)-g(O,iC))<=atrS*1.5
    if 1<=rDn<=LB*2 and midDn and not oppDn and g(L,iC)<=g(lo,iC) and lowF and pe: out.append(("VIOLA",True,atrS,g(basis,iC),iDn,iS,iC))
    if 1<=rUp<=LB*2 and midUp and not oppUp and g(H,iC)>=g(up,iC) and upF and pe: out.append(("VIOLA",False,atrS,g(basis,iC),iUp,iS,iC))
    return out

import collections
def sim(j,isL,entry,sl,tp0,same_bar_start):
    """j = barra di ingresso. same_bar_start: se True controlla SL gia nella barra j (fill intrabar)"""
    tp=tp0; m=j
    while m<n-1:
        if m>j or not same_bar_start:
            pass
        if m>j:
            nt=basis[m-1]
            if isL and nt>entry and nt>O[m]+1e-5: tp=nt
            if (not isL) and nt<entry and nt<O[m]-1e-5: tp=nt
        if isL:
            if L[m]<=sl: return ('SL',m)
            if m>j or not same_bar_start:
                if H[m]>=tp: return ('TP',m,tp)
        else:
            if H[m]>=sl: return ('SL',m)
            if m>j or not same_bar_start:
                if L[m]<=tp: return ('TP',m,tp)
        m+=1
        if m-j>400: return None
    return None
def run(mode):
    out=[]; busy=-1
    for j in range(barsNeeded+60,n-60):
        if j<=busy: continue
        cand=[]
        if mode=='base':
            cand=[(t,isL,a,tp,'open') for (t,isL,a,tp,*_) in signals(j,1,False)]
        elif mode=='bluNoC':
            for (t,isL,a,tp,*_) in signals(j,0,True):
                if t=='BLU': cand.append((t,isL,a,tp,'open'))
        elif mode=='violaTouch':
            cand=viola_touch(j)
        for t,isL,a,tp0,how in cand:
            if how=='open': entry=O[j]; same=False
            else: entry,same=tp0[1],True; tp0=tp0[0]
            sl=entry-3*a if isL else entry+3*a
            if isL and tp0<=entry: continue
            if (not isL) and tp0>=entry: continue
            r=sim(j,isL,entry,sl,tp0,same)
            if r is None: continue
            if r[0]=='SL': pnl=-3*a; ex=r[1]
            else: pnl=(r[2]-entry) if isL else (entry-r[2]); ex=r[1]
            out.append(dict(tag=t,isL=isL,j=j,pnlR=pnl/(3*a),tp0R=abs(tp0-entry)/(3*a),win=r[0]=='TP',dur=ex-j)); busy=ex; break
    return out
def viola_touch(j):
    """limit sulla banda durante la candela C (=barra j in formazione). Pre-condizioni note a inizio barra j (S=barra 1)"""
    g=lambda arr,k: arr[j-k]
    if j-barsNeeded<0 or np.isnan(adx[j-1]) or np.isnan(lo[j-barsNeeded]): return []
    at=[g(atr,k) for k in range(1,21)]; atrMA=np.mean(at)
    if not (at[0]<=atrMA*1.8 and at[0]>=atrMA*0.5): return []
    iS=1; atrS=g(atr,1)
    iDn=iUp=-1
    for k in range(iS,barsNeeded-1):
        body=abs(g(C,k)-g(O,k)); a=g(atr,k)
        if iDn<0 and g(L,k)<=g(lo,k) and g(C,k)<g(O,k) and body>=a*0.2: iDn=k
        if iUp<0 and g(H,k)>=g(up,k) and g(C,k)>g(O,k) and body>=a*0.2: iUp=k
        if iDn>=0 and iUp>=0: break
    res=[]
    if iDn>=1 and iDn<=LB*2:
        mid=opp=False
        for k in range(iS,iDn):
            if g(H,k)>=g(basis,k) and g(L,k)<=g(basis,k): mid=True
            if g(H,k)>=g(up,k): opp=True
        flat=abs(g(lo,iS)-g(lo,iS+6))<=atrS*0.6
        if mid and not opp and flat:
            lim=g(lo,1)
            if O[j]<=lim or L[j]<=lim:
                px=min(O[j],lim)
                res.append(("VIOLA",True,atrS,(g(basis,1),px),'touch'))
    if iUp>=1 and iUp<=LB*2:
        mid=opp=False
        for k in range(iS,iUp):
            if g(H,k)>=g(basis,k) and g(L,k)<=g(basis,k): mid=True
            if g(L,k)<=g(lo,k): opp=True
        flat=abs(g(up,iS)-g(up,iS+6))<=atrS*0.6
        if mid and not opp and flat:
            lim=g(up,1)
            if O[j]>=lim or H[j]>=lim:
                px=max(O[j],lim)
                res.append(("VIOLA",False,atrS,(g(basis,1),px),'touch'))
    return res


import numpy as np
def run_simple(kind):
    out=[]; busy=-1; last={1:-99,-1:-99}
    for j in range(barsNeeded+60,n-60):
        i=j-1  # barra del segnale chiusa
        if j<=busy: continue
        sigs=[]
        # IN-BULGE
        if L[i]<=lo[i] and C[i]>lo[i] and C[i]<basis[i]: sigs.append(('IB',1))
        if H[i]>=up[i] and C[i]<up[i] and C[i]>basis[i]: sigs.append(('IB',-1))
        # POST-BULGE
        if L[i-1]<=lo[i-1] and C[i]>lo[i] and C[i]<basis[i]: sigs.append(('PB',1))
        if H[i-1]>=up[i-1] and C[i]<up[i] and C[i]>basis[i]: sigs.append(('PB',-1))
        for t,d in sigs:
            if kind!='ALL' and t!=kind: continue
            if i-last[d]<5: continue
            a=atr[i]; entry=O[j]; sl=entry-3*a if d==1 else entry+3*a; tp0=basis[i]
            if (d==1 and tp0<=entry) or (d==-1 and tp0>=entry): continue
            r=sim(j,d==1,entry,sl,tp0,False)
            if r is None: continue
            pnl=-3*a if r[0]=='SL' else ((r[2]-entry) if d==1 else (entry-r[2]))
            out.append(dict(tag=t,isL=d==1,j=j,pnlR=pnl/(3*a),tp0R=abs(tp0-entry)/(3*a),win=r[0]=='TP',dur=r[1]-j)); busy=r[1]; last[d]=i; break
    return out
COST=0.04
def rep(name,r):
    if not r: print(name,'nessuna'); return
    def blk(x):
        return 'n=%d win=%.0f%% R=%.3f Rnet=%.3f'%(len(x),100*np.mean([t['win'] for t in x]),np.mean([t['pnlR'] for t in x]),np.mean([t['pnlR'] for t in x])-COST) if x else 'n=0'
    a=[t for t in r if ks[t['j']]<'2018']; b=[t for t in r if ks[t['j']]>='2018']
    print('%-26s %s | TP/SL %.2f | 2014-17 %s | 2018-20 %s'%(name,blk(r),np.median([t['tp0R'] for t in r]),blk(a),blk(b)))
for k in ('IB','PB','ALL'): rep('Pine semplice '+k,run_simple(k))
