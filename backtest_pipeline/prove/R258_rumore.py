# R258_rumore.py -- contro-esempio di R258 (par. 8 di R258a): rumore del PF per un
# motore SENZA edge con la geometria del PDF. python3 R258_rumore.py (~10 s).
# Esito binario = varianza MASSIMA (le uscite a tempo la riducono): bande PRUDENTI.
import random
random.seed(258)
W=25.0; b=3.0; SL=W/2+b; TP=W; a=TP/SL; p0=SL/(SL+TP)
print(f"geometria W={W} SL={SL} TP={TP} payoff a={a:.3f} p0={p0:.3f}")
def pf(n,k):
    gp=gl=0.0
    for _ in range(n):
        x=(a if random.random()<p0 else -1.0)-k
        if x>0: gp+=x
        else: gl-=x
    return gp/gl
def q(v,f): v=sorted(v); return v[int(f*(len(v)-1))]
N=4000
for k,lab in [(0.0,"lordo"),(0.84/SL,"netto all-in GBPUSD")]:
    print("==",lab,"k=%.4f R"%k)
    for n,ni in [(150,100),(233,155),(300,200),(1900,1900)]:
        A=[pf(n,k) for _ in range(N)]; B=[pf(n,k) for _ in range(N)]
        Ai=[pf(ni,k) for _ in range(N)]; Bi=[pf(ni,k) for _ in range(N)]
        d=[abs(x-y) for x,y in zip(A,B)]
        q90,q95=q(d,0.90),q(d,0.95)
        out=f" nOOS={n:4d} nIS={ni:4d} P(PF>=1.10)={sum(x>=1.10 for x in A)/N:.3f} |dPF| q90={q90:.3f} q95={q95:.3f}"
        for s in [0.10,round(q90,2),round(q95,2)]:
            fd=sum(1 for i in range(N) if ((A[i]-B[i])>=s and (Ai[i]-Bi[i])>0) or ((B[i]-A[i])>=s and (Bi[i]-Ai[i])>0))/N
            out+=f" | s={s:.2f} falsoDECIDE={fd:.3f}"
        print(out)
