import sys
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import SRC,load_m1,resample,prep
from universal_scalper_regime import sim
from tv_scout8_backtest import metrics,split
blocks=[('00-08',0,8),('08-16',8,16),('16-24',16,24)]
res={}
for name,(pats,sep,cost) in SRC.items():
    d=load_m1(pats,sep)
    for tfn,rule in (('M15','15min'),('H1','1h')):
        r=resample(d,rule); P=prep(r); ks=P[7]; n=len(ks); cut=ks[int(0.7*n)]
        ok=np.ones(n,bool); net=sim(P,cost,'B2',ok); gro=sim(P,0.0,'B2',ok)
        mn=metrics(net); mg=metrics(gro); costR=np.mean([g[1]-x[1] for g,x in zip(gro,net)]) if len(net)==len(gro) else float('nan')
        print('%-7s %-3s n=%d  PF lordo %.2f netto %.2f | R lordo %+.3f netto %+.3f | costo medio %.3f R/trade'%(name,tfn,mn['n'],mg['pf'],mn['pf'],mg['R'],mn['R'],costR),flush=True)
        a,b=split(net,cut); line=[]
        for bn,h0,h1 in blocks:
            f=lambda tr:[x for x in tr if h0<=int(x[0][11:13])<h1]
            ia=f(a); ob=f(b); line.append('%s IS R %+.3f (n %d) OOS R %+.3f (n %d)'%(bn,np.mean([x[1] for x in ia]) if ia else 0,len(ia),np.mean([x[1] for x in ob]) if ob else 0,len(ob)))
            res[(name,tfn,bn)]=(np.mean([x[1] for x in ia]) if ia else 0,np.mean([x[1] for x in ob]) if ob else 0)
        print('      '+' | '.join(line),flush=True)
pe=0
for tfn in ('M15','H1'):
    for name in SRC:
        w_is=min(blocks,key=lambda b:res[(name,tfn,b[0])][0])[0]; w_oos=min(blocks,key=lambda b:res[(name,tfn,b[0])][1])[0]
        print('peggior blocco',name,tfn,'IS',w_is,'OOS',w_oos)
        if w_is=='00-08' and w_oos=='00-08': pe+=1
print('notte peggiore in IS e OOS in %d casi su 8'%pe)
