"""Filtro di volatilita' Gold 4-Day Breakout (PDF v2). Criteri: report/GOLD_4DAY_FILTRO_VOL_CRITERI_2026-11-19.md"""
import sys,itertools,random
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from gold_4day_breakout import load,run,stats
D=load()
def pf(tr):
    r=np.array([x[2] for x in tr]); g=r[r>0].sum(); l=-r[r<0].sum(); return g/l if l>0 else 99.0
A=lambda tr:[x for x in tr if x[0]<'2019']; B=lambda tr:[x for x in tr if x[0]>='2019']
base=run(D); bA=A(base); bB=B(base)
print('BASE  A(2014-18) %s | B(2019-20) %s'%(stats(bA),stats(bB)),flush=True)
random.seed(7)
def placebo(tr_all,tr_f,per):
    # estrazioni di giorni a caso, stesso numero di giorni operativi del filtro, dentro lo stesso periodo
    dd=sorted(set(x[0] for x in tr_all if per(x))); nf=len(set(x[0] for x in tr_f)); 
    by={}
    for x in tr_all:
        if per(x): by.setdefault(x[0],[]).append(x)
    obs=pf(tr_f); c=0; n=300
    for _ in range(n):
        s=random.sample(dd,min(nf,len(dd))); t=[x for d in s for x in by[d]]
        if pf(t)>=obs: c+=1
    return (c+1)/(n+1)
cells=[('A',fa,None) for fa in (0.9,1.0,1.1,1.2)]+[('B',None,fb) for fb in (2.0,2.5,3.0)]+[('C',fa,fb) for fa in (0.9,1.0,1.1,1.2) for fb in (2.0,2.5,3.0)]
res=[]
for tag,fa,fb in cells:
    t=run(D,4,0.5,14,fa,fb); a=A(t); b=B(t)
    pa=placebo(base,t,lambda x:x[0]<'2019') if len(a)>0 else 1; 
    res.append((tag,fa,fb,pf(a) if a else 0,len(a),pf(b) if b else 0,len(b),pa))
    print('%s ATRx%-4s canale>%-4s | A: PF %.2f n=%d (p caso %.3f) | B: PF %.2f n=%d'%(tag,fa,fb,res[-1][3],res[-1][4],pa,res[-1][5],res[-1][6]),flush=True)
# scelta su B (2019-20) tra celle con n>=50 in B
ok=[r for r in res if r[6]>=50]; best=max(ok,key=lambda r:r[5]) if ok else None
print('cella scelta su B (PF max con >=50 op):',best[:3],'PF B %.2f n=%d -> giudizio su A: PF %.2f n=%d p=%.3f'%(best[5],best[6],best[3],best[4],best[7]) if best else None)
print('celle con PF A > 1.2 e n>=100:',[(r[0],r[1],r[2],round(r[3],2),r[4]) for r in res if r[3]>1.2 and r[4]>=100])
print('miglior PF in A:',max(r[3] for r in res if r[4]>=100) if any(r[4]>=100 for r in res) else None,'| celle con p<0.01 in A:',[r[:3] for r in res if r[7]<0.01])
print('celle con PF B > base B (%.2f): %d su %d'%(pf(bB),sum(1 for r in res if r[5]>pf(bB)),len(res)))
