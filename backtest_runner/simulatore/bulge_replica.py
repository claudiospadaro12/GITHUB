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
print("barre H1",n,ks[0],ks[-1],file=sys.stderr)
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
B=1; LB=20; BWL=50; BM=1.1
barsNeeded=LB*2+10+B
def signals(j):
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
    if oL and cL and adxOk: out.append(("BLU",True,atrS,g(basis,iC),iDn,iS,iC))
    if oS and cS and adxOk: out.append(("BLU",False,atrS,g(basis,iC),iUp,iS,iC))
    pe=abs(g(C,iC)-g(O,iC))<=atrS*1.5
    if 1<=rDn<=LB*2 and midDn and not oppDn and g(L,iC)<=g(lo,iC) and lowF and pe: out.append(("VIOLA",True,atrS,g(basis,iC),iDn,iS,iC))
    if 1<=rUp<=LB*2 and midUp and not oppUp and g(H,iC)>=g(up,iC) and upF and pe: out.append(("VIOLA",False,atrS,g(basis,iC),iUp,iS,iC))
    return out
trades=[]; busy_until=-1
for j in range(barsNeeded+60,n-60):
    if j<=busy_until: continue
    for tag,isL,atrS,tp0,iImp,iS,iC in signals(j):
        entry=O[j]; sl=entry-3*atrS if isL else entry+3*atrS; tp=tp0
        if isL and (tp<=entry): continue
        if (not isL) and (tp>=entry): continue
        res=None; m=j
        while m<n-1:
            if m>j:
                nt=basis[m-1]
                if isL and nt>entry and nt>O[m]+1e-5: tp=nt
                if (not isL) and nt<entry and nt<O[m]-1e-5: tp=nt
            if isL:
                if L[m]<=sl: res=(-3*atrS, 'SL'); break
                if H[m]>=tp: res=(tp-entry,'TP'); break
            else:
                if H[m]>=sl: res=(-3*atrS,'SL'); break
                if L[m]<=tp: res=(entry-tp,'TP'); break
            m+=1
            if m-j>400: break
        if res is None: continue
        trades.append(dict(tag=tag,long=isL,j=j,t=ks[j],imp=j-iImp,sig=j-iS,cnf=j-iC,entry=entry,sl=sl,tp0=tp0,atr=atrS,out=res[1],pnlR=res[0]/(3*atrS),exit=m,tp0R=abs(tp0-entry)/(3*atrS)))
        busy_until=m
        break
import collections
print("trade replica (illustrativo, EURUSD H1, 2014-2020 dove ci sono dati):",len(trades))
for tag in ("BLU","VIOLA"):
    for side in (True,False):
        s=[t for t in trades if t['tag']==tag and t['long']==side]
        if s: print(tag,'long' if side else 'short',len(s),'win%%=%.0f'%(100*np.mean([t['out']=='TP' for t in s])),'R medio=%.2f'%np.mean([t['pnlR'] for t in s]),'dist TP/SL mediana=%.2f'%np.median([t['tp0R'] for t in s]))
yrs=collections.Counter(t['t'][:4] for t in trades); print(dict(yrs))
json.dump(dict(trades=trades),open('trades.json','w'))
np.save('ohlc.npy',A); json.dump(ks,open('ks.json','w'))
np.savez('ind.npz',basis=basis,up=up,lo=lo,atr=atr,adx=adx)
