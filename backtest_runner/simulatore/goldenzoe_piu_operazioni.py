import sys,datetime as dt,collections
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import trail,entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
def P(x): return dt.datetime.strptime(x,'%Y.%m.%d %H:%M')
def swapR(t):
    t0,R,tx,ent,risk=t; days=(P(tx)-P(t0)).total_seconds()/86400
    return R-(0.055/360)*days*ent/risk
def stats(v):
    r=np.array(v); 
    if len(r)<2: return len(r),0,0,0
    g=r[r>0].sum(); l=-r[r<0].sum(); return len(r),(g/l if l>0 else 99),r.mean(),r.mean()/(r.std(ddof=1)/np.sqrt(len(r)))
per=lambda y:'A' if y<'2014.11' else ('B' if y<'2021' else 'C')
res={}
for tfn,rule in (('H4','4h'),('H2','2h'),('H1','1h')):
    r=resample(d,rule); Pr=prep(r); O,H,L,C,atr,sig,ha,ks=Pr
    for N in (55,40,30,20,10):
        e=entries_breakout(C,H,L,N); ee=np.where(e==1,e,0); tr=trail(O,H,L,C,atr,ks,0.35,ee)
        rr=[(x[0],swapR(x)) for x in tr]
        allr=[v for _,v in rr]; n,pf,m,t=stats(allr)
        pp={k:stats([v for tt,v in rr if per(tt)==k]) for k in 'ABC'}
        res[(tfn,N)]=(n,pf,t,pp)
        print('%s N=%-2d n=%4d (%.0f/anno) PF %.2f R %+.3f t %.1f | 2004-14 n%d PF %.2f | 2014-20 n%d PF %.2f | 2021-26 n%d PF %.2f'%(tfn,N,n,n/22.4,pf,m,t,pp['A'][0],pp['A'][1],pp['B'][0],pp['B'][1],pp['C'][0],pp['C'][1]),flush=True)
base=res[('H4',55)][0]
print('--- porta: >=1.5x operazioni di H4/55 (%d) e PF>=1.3 in tutti e tre i periodi e t>=3 ---'%base)
ok=[(k,v) for k,v in res.items() if v[0]>=1.5*base and all(v[3][p][1]>=1.3 for p in 'ABC') and v[2]>=3]
print('passano:',[k for k,v in ok])
