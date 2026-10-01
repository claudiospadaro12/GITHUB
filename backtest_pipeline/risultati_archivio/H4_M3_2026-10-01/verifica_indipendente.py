# riconto indipendente a cicli espliciti (non usa prepara/sistema/searchsorted dello strumento)
import sys, numpy as np, bisect
sys.path.insert(0, "/home/user/GITHUB/backtest_pipeline")
import collaudo_superwave_v41 as CS
nome = sys.argv[1]
z = np.load("/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/cache_m1/m1_%s.npz" % nome)
t = z["t"].tolist(); h = z["h"].tolist(); l = z["l"].tolist(); c = z["c"].tolist()
def bars(tf):
    S=[];H=[];L=[];C=[]
    cur=None
    for i in range(len(t)):
        b=(t[i]+60)//tf
        if b!=cur:
            cur=b; S.append(b*tf-60); H.append(h[i]); L.append(l[i]); C.append(c[i])
        else:
            if h[i]>H[-1]: H[-1]=h[i]
            if l[i]<L[-1]: L[-1]=l[i]
            C[-1]=c[i]
    return S,H,L,C
S3,H3,L3,C3=bars(3); S4,H4,L4,C4=bars(240); S1,H1,L1,C1=bars(60)
_,_,_,r3,v3=CS.st_full(H3,L3,C3,10,3.5)
_,_,_,r4,v4=CS.st_full(H4,L4,C4,10,3.5)
# ATR14 H1: media semplice del TR (TR[0] = h-l con pc = open... uso pc = close precedente; barra 0 esclusa dalla zona)
tr=[0.0]*len(C1)
for i in range(1,len(C1)): tr[i]=max(H1[i]-L1[i],abs(H1[i]-C1[i-1]),abs(L1[i]-C1[i-1]))
A1=[float('nan')]*len(C1)
for i in range(14,len(C1)): A1[i]=sum(tr[i-13:i+1])/14.0
E4=[s+240 for s in S4]; E1=[s+60 for s in S1]
# bs H4 con ciclo
lf=-1; bs4=[-1]*len(C4)
for i in range(len(C4)):
    if i>=12 and r4[i]!=r4[i-1]: lf=i
    bs4[i]=(i-lf) if lf>=0 else -1
Avalid=[a for a in A1[300:] if a==a and a>0]; amed=float(np.median(Avalid)) if False else None
res={}
for k in range(300,len(C3)):
    if not (k>=12 and r3[k]!=r3[k-1]): continue
    tE=S3[k]+3
    j=bisect.bisect_right(E4,tE)-1; jh=bisect.bisect_right(E1,tE)-1
    if j<300 or jh<300: continue
    A=A1[jh]
    if not(A==A and A>0): continue
    s=int(r3[k]); d=int(r4[j]); st=not(bs4[j]>=0 and bs4[j]<3)
    if not st: continue
    g=("ALL" if d==s else "CON")+("_long" if s>0 else "_short")
    i0=bisect.bisect_left(t,tE); i1=bisect.bisect_left(t,tE+60)
    if not(i1-i0>=30 and i1<len(t) and i1>i0): continue
    R=s*(c[i1-1]-C3[k])/A
    res.setdefault(g,[]).append(R)
for g in sorted(res): print(nome, g, len(res[g]), "%.4f" % np.mean(res[g]))
