import numpy as np, json, collections, sys
A=np.load('ohlc.npy'); ks=json.load(open('ks.json')); O,H,L,C=A.T; n=len(C)
def sma(x,p):
    o=np.full(n,np.nan)
    c=np.cumsum(np.insert(x,0,0.0)); 
    for i in range(p-1,n): o[i]=(c[i+1]-c[i+1-p])/p
    return o
def stdev(x,p):
    o=np.full(n,np.nan)
    for i in range(p-1,n): o[i]=x[i-p+1:i+1].std()
    return o
basis=sma(C,20); dev=2*stdev(C,20); up=basis+dev; lo=basis-dev; width=up-lo
sd=stdev(C,20); sdS=sma(np.nan_to_num(sd,nan=0.0),50); sdS[:70]=np.nan
tr=np.zeros(n); tr[0]=H[0]-L[0]
for i in range(1,n): tr[i]=max(H[i]-L[i],abs(H[i]-C[i-1]),abs(L[i]-C[i-1]))
atr=np.full(n,np.nan); atr[13]=tr[:14].mean()
for i in range(14,n): atr[i]=(atr[i-1]*13+tr[i])/14
rng=H-L
wRef=np.full(n,np.nan)
for i in range(1,n):
    if i-1>=19+19: wRef[i]=np.nanmean(width[i-20:i])
P=dict(bulgeMult=1.35,minBars=3,maxBars=20,impATR=1.5,netATR=1.0,cLen=15,csMin=4,csCompress=10.0,lateralATR=1.0,prevN=50,cdaStd=10,cdaTol=1,cdaDrop=15.0,postMax=30,contImp=1.5,invImp=1.0,invViolent=1,flatTol=0.05,reinfl=1.05,useCong=True)
def sdFall(i,o=0): j=i-o; return (sd[j]<sd[j-1] and sd[j-1]<sd[j-2]) or sd[j]<sdS[j]
def congCS(i,e):
    cl=P['cLen']; s=e+cl-1; ie=i-e; is_=i-s
    avgR=rng[is_:ie+1].mean(); maxR=rng[is_:ie+1].max(); avgP=rng[is_-P['prevN']:is_].mean()
    k=0
    k+= width[ie]<=width[is_]*(1-P['csCompress']/100)
    k+= (avgR<=avgP and maxR<=2*avgR)
    k+= abs(C[ie]-C[is_])<=P['lateralATR']*atr[ie]
    k+= maxR<1.5*atr[ie]
    k+= sd[ie]<=sdS[ie]
    return k>=P['csMin']
def congCDA(i,e):
    cl=P['cLen']; s=e+cl-1; ie=i-e; is_=i-s
    downs=sum(1 for q in range(ie-P['cdaStd']+1,ie+1) if sd[q]<=sd[q-1])
    maxR=rng[is_:ie+1].max(); nd=np.sign(C[ie]-C[is_])
    counter=any((C[q]-O[q])*nd<0 and rng[q]>=atr[ie] for q in range(is_,ie+1))
    return downs>=P['cdaStd']-P['cdaTol'] and sd[ie]<sdS[ie] and width[ie]<=width[is_]*(1-P['cdaDrop']/100) and maxR<1.5*atr[ie] and not counter
sig=[]
phase=0
for i in range(150,n):
    if np.isnan(wRef[i]) or np.isnan(sdS[i]) or np.isnan(atr[i]): continue
    if phase==0:
        if width[i]>=P['bulgeMult']*wRef[i] and sd[i]>sd[i-1]:
            phase=1; bS=i; bLen=1; bBase=C[i-1]; bAtr=atr[i]; bPk=width[i]; bImp=rng[i]>=P['impATR']*atr[i]; bSd=sd[i]>sdS[i]; tU=H[i]>=up[i]; tD=L[i]<=lo[i]
    elif phase==1:
        bLen+=1; bPk=max(bPk,width[i]); bImp=bImp or rng[i]>=P['impATR']*bAtr; bSd=bSd or sd[i]>sdS[i]; tU=tU or H[i]>=up[i]; tD=tD or L[i]<=lo[i]
        narrowing=width[i]<width[i-1] and width[i-1]<width[i-2]
        if bLen>P['maxBars']: phase=0
        elif bLen>=P['minBars'] and narrowing:
            net=C[i]-bBase; d=1 if net>0 else -1
            ok=bImp and bSd and abs(net)>=P['netATR']*bAtr and (tU if d==1 else tD)
            if ok and P['useCong']:
                e=i-bS+1
                ok=(bS-1-P['cLen']-P['prevN']>=0) and (congCS(i,e) or congCDA(i,e))
            if ok:
                phase=2; pS=i; pD=d; pA=atr[i]; pPk=bPk; cA=True; iA=True; medBar=-1; vN=0
            else: phase=0
    elif phase==2 and i>pS:
        oppT=(L[i]<=lo[i]) if pD==1 else (H[i]>=up[i]); impT=(H[i]>=up[i]) if pD==1 else (L[i]<=lo[i]); medT=(L[i]<=basis[i]) if pD==1 else (H[i]>=basis[i])
        vC=rng[i]>=P['contImp']*pA; vI=rng[i]>=P['invImp']*pA
        if i-pS>P['postMax']: cA=False; iA=False
        if cA:
            if oppT:
                if width[i]<width[i-2] and width[i]<pPk and sdFall(i) and not vC: sig.append((i,'CONT',pD))
                cA=False
            elif vC: cA=False
        if iA:
            if oppT: iA=False
            else:
                if medBar<0:
                    if vI:
                        vN+=1
                        if vN>=P['invViolent']: iA=False
                    if medT: medBar=i
                elif impT:
                    flat=(up[i-1]-up[i-4]<=P['flatTol']*pA*3) if pD==1 else (lo[i-1]-lo[i-4]>=-P['flatTol']*pA*3)
                    if flat and width[i-1]<width[i-3] and sdFall(i,1) and width[i]<=pPk*P['reinfl'] and not vI: sig.append((i,'INV',-pD))
                    iA=False
        if not cA and not iA: phase=0
print('barre',n,'segnali',len(sig))
c=collections.Counter((t,d) for _,t,d in sig); print(dict(c))
yr=collections.Counter(ks[i][:4] for i,_,_ in sig); print(dict(sorted(yr.items())))
# esito indicativo: ingresso all'apertura della barra successiva, SL 3 ATR, TP mediana (aggiornata), SL prima del TP
res=[]
for i,t,d in sig:
    j=i+1; entry=O[j]; a=atr[i]; sl=entry-3*a if d==1 else entry+3*a; tp=basis[i]
    if (d==1 and tp<=entry) or (d==-1 and tp>=entry): res.append((t,d,None)); continue
    out=None
    for m in range(j,min(n-1,j+400)):
        if m>j:
            nt=basis[m-1]
            if d==1 and nt>entry: tp=nt
            if d==-1 and nt<entry: tp=nt
        if d==1:
            if L[m]<=sl: out=-1.0; break
            if H[m]>=tp: out=(tp-entry)/(3*a); break
        else:
            if H[m]>=sl: out=-1.0; break
            if L[m]<=tp: out=(entry-tp)/(3*a); break
    res.append((t,d,out))
import statistics as st
for t in ('CONT','INV'):
    r=[x[2] for x in res if x[0]==t and x[2] is not None]
    if r: print(t,'n=%d win%%=%.0f R=%.3f'%(len(r),100*np.mean([x>0 for x in r]),np.mean(r)))
r=[x[2] for x in res if x[2] is not None]; print('tutti n=%d win%%=%.0f R=%.3f'%(len(r),100*np.mean([x>0 for x in r]),np.mean(r)))
