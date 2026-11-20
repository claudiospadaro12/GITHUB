# Criteri: report/BTC_D1_SCALPER_PENDENZA_BANDE_CRITERI_2026-11-20.md
import csv,numpy as np
d=list(csv.reader(open(__import__('sys').argv[1] if len(__import__('sys').argv)>1 else '/tmp/claude-0/d1/D1_Bitcoin.csv'),delimiter=';'))[1:]
D=[x[0] for x in d]; O,H,L,C=[np.array([float(x[k]) for x in d]) for k in (1,2,3,4)]
n=len(C)
def ema(x,p):
    a=2/(p+1); o=np.empty_like(x); o[0]=x[0]
    for i in range(1,len(x)): o[i]=a*x[i]+(1-a)*o[i-1]
    return o
def rma(x,p):
    o=np.full(len(x),np.nan); o[p-1]=x[:p].mean()
    for i in range(p,len(x)): o[i]=(o[i-1]*(p-1)+x[i])/p
    return o
tr=np.maximum(H-L,np.maximum(abs(H-np.roll(C,1)),abs(L-np.roll(C,1)))); tr[0]=H[0]-L[0]
atr=rma(tr,14)
up=np.diff(H,prepend=H[0]); dn=-np.diff(L,prepend=L[0])
pdm=np.where((up>dn)&(up>0),up,0.0); mdm=np.where((dn>up)&(dn>0),dn,0.0)
pdi=100*rma(pdm,14)/atr; mdi=100*rma(mdm,14)/atr
dx=100*abs(pdi-mdi)/(pdi+mdi); adx=np.full(n,np.nan)
v=~np.isnan(dx); i0=np.argmax(v); adx[i0+13:]=rma(dx[i0:],14)[13:]
e9,e21=ema(C,9),ema(C,21)
sma=np.array([C[max(0,i-19):i+1].mean() if i>=19 else np.nan for i in range(n)])
slope=np.full(n,np.nan); slope[24:]=(sma[24:]-sma[19:-5])/(5*atr[24:])
haC=(O+H+L+C)/4; haO=np.empty(n); haO[0]=(O[0]+C[0])/2
for i in range(1,n): haO[i]=(haO[i-1]+haC[i-1])/2
green=haC>haO
cut=int(n*0.7)
q33,q67=np.nanpercentile(abs(slope[:cut]),[33.3,66.7])
COST=0.001
def sim(exitm):
    T=[]; i=40; 
    while i<n-2:
        sg=0
        if adx[i]>12 and not np.isnan(atr[i]):
            if e9[i]>e21[i] and e9[i-1]<=e21[i-1]: sg=1
            elif e9[i]<e21[i] and e9[i-1]>=e21[i-1]: sg=-1
        if sg==0: i+=1; continue
        en=O[i+1]; R=1.5*atr[i]; sl=C[i]-sg*1.5*atr[i]; tp=C[i]+sg*2*atr[i]; ex=None; j=i+1
        while j<n-1:
            if exitm=='A':
                if sg==1:
                    if L[j]<=sl: ex=sl;break
                    if H[j]>=tp: ex=tp;break
                else:
                    if H[j]>=sl: ex=sl;break
                    if L[j]<=tp: ex=tp;break
                if j-i>=60: ex=C[j];break
            elif exitm=='B':
                if (sg==1 and e9[j]<e21[j] and e9[j-1]>=e21[j-1] and adx[j]>12) or (sg==-1 and e9[j]>e21[j] and e9[j-1]<=e21[j-1] and adx[j]>12): ex=O[j+1];break
            else:
                if (sg==1 and not green[j]) or (sg==-1 and green[j]): ex=O[j+1];break
            j+=1
        if ex is None: ex=C[min(j,n-1)]
        r=((ex-en)*sg-COST*en)/R
        T.append((i,sg,abs(slope[i]),r,j)); i=max(j,i+1)
    return T
def st(x):
    if len(x)==0: return 'n=0'
    r=np.array([t[3] for t in x]); w=r[r>0].sum(); l=-r[r<=0].sum()
    return f"n={len(r):3d} win={100*(r>0).mean():4.0f}% R={r.mean():+.2f} PF={(w/l if l>0 else 9.99):4.2f}"
for ex in 'ABC':
    T=sim(ex); print(f"\n=== uscita {ex}: {len(T)} operazioni totali ===")
    for per,f in (('IS ',lambda t:t[0]<cut),('OOS',lambda t:t[0]>=cut)):
        S=[t for t in T if f(t)]
        print(f" {per} tutte   {st(S)}   long {st([t for t in S if t[1]==1])} | short {st([t for t in S if t[1]==-1])}")
        for nm,g in (('bassa',lambda t:t[2]<q33),('media',lambda t:q33<=t[2]<q67),('alta ',lambda t:t[2]>=q67)):
            print(f"    pendenza {nm} {st([t for t in S if g(t)])}")
# test 2
print('\n=== TEST 2: rendimento nella direzione della pendenza dopo HA contraria ===')
for per,lo,hi in (('IS ',45,cut),('OOS',cut,n-11)):
    for k in (5,10):
        def fw(mask):
            idx=[i for i in range(lo,hi) if mask(i)]
            if not idx: return 'n=0'
            v=np.array([np.sign(slope[i])*(C[i+k]/C[i]-1) for i in idx])
            return f"n={len(v):3d} medio={100*v.mean():+.2f}% pos={100*(v>0).mean():.0f}%"
        hi_=lambda i:abs(slope[i])>=q67; lo_=lambda i:abs(slope[i])<q33
        con=lambda i:(green[i] and slope[i]<0) or ((not green[i]) and slope[i]>0)
        print(f" {per} {k:2d}gg  alta+HA contraria: {fw(lambda i:hi_(i) and con(i))} | alta senza: {fw(lambda i:hi_(i) and not con(i))} | bassa+HA contraria: {fw(lambda i:lo_(i) and con(i))}")
print('\nsoglie IS: q33=%.3f q67=%.3f ATR/barra; IS fino a %s'%(q33,q67,D[cut-1]))
# --- diagnostica fragilita' (uscita B e C), aggiunta dopo i primi numeri ---
print('\n=== DIAGNOSTICA uscita B (cambio segnale) ===')
T=sim('B'); r=np.array([t[3] for t in T]); yrs=np.array([int(D[t[0]][:4]) for t in T])
print('operazioni',len(r),'R totale %.1f'%r.sum(),'peggiore %.1f R'%r.min(),'migliore %.1f R'%r.max())
s=np.sort(r)[::-1]; print('top5 R: %.1f = %.0f%% del totale; senza top5 R medio %+.2f; senza top10 %+.2f'%(s[:5].sum(),100*s[:5].sum()/r.sum(),s[5:].mean(),s[10:].mean()))
for y in sorted(set(yrs)):
    x=r[yrs==y]; print(' ',y,'n=%2d R=%+6.1f'%(len(x),x.sum()),end=' |')
print()
for nm,sgn in (('long',1),('short',-1)):
    x=np.array([t[3] for t in T if t[1]==sgn]); y2=np.array([t[3] for t in T if t[1]==sgn and t[0]>=cut]); print(nm,'R totale %.1f  senza top3 %.1f  OOS R %.1f'%(x.sum(),np.sort(x)[::-1][3:].sum(),y2.sum()))
bh=C[-1]/C[45]-1; print('buy&hold BTC 2014-26: %+.0f%%'%(100*bh))
