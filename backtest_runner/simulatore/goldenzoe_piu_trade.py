import sys,os,datetime as dt,csv
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
SW=float(os.environ.get('SW','0.055'))
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r)
cs=pd.Series(C); ema={T:cs.ewm(span=T,adjust=False).mean().values for T in (100,300)}
def P(x): return dt.datetime.strptime(x,'%Y.%m.%d %H:%M')
def trade(e55,ere,K,filt,cost=0.35,mi=3.0,mt=3.0):
    n=len(C); out=[]; pos=0; lastx=-10**9
    for i in range(320,n-1):
        if pos==0:
            if np.isnan(atr[i]): continue
            go=False
            if e55[i]==1 and (filt is None or C[i]>filt[i]): go=True
            elif ere is not None and ere[i]==1 and i-lastx<=K and C[i]>ema[100][i]: go=True
            if not go: continue
            ent=O[i+1]; risk=mi*atr[i]
            if risk<=0: continue
            pos=1; stop=ent-risk; ext=ent; t0=ks[i+1]; start=i+1
        if pos==1 and i>=start:
            if L[i]<=stop:
                px=min(O[i],stop); days=(P(ks[i])-P(t0)).total_seconds()/86400
                out.append((t0,(px-ent)/risk-cost/risk-(SW/360)*days*ent/risk)); pos=0; lastx=i; continue
            ext=max(ext,H[i]); stop=max(stop,ext-mt*atr[i])
    return out
per=lambda y:'A' if y<'2014.11' else ('B' if y<'2021' else 'C')
def st(v):
    v=np.array(v)
    if len(v)<3: return len(v),0.0,0.0,0.0
    g=v[v>0].sum(); l=-v[v<0].sum(); return len(v),(g/l if l>0 else 99.0),v.mean(),v.mean()/(v.std(ddof=1)/np.sqrt(len(v)))
def ev(tr):
    return {p:st([R for t,R in tr if per(t)==p]) for p in 'ABC'}|{'all':st([R for t,R in tr])}
E_=lambda N:np.where(entries_breakout(C,H,L,N)==1,1,0)
cells=[]
base=ev(trade(E_(55),None,0,None)); cells.append(('BASE 55',base))
for N in (10,20,30):
    for T in (None,100,300):
        cells.append(('F1 N%d EMA%s'%(N,T or '-'),ev(trade(E_(N),None,0,None if T is None else ema[T]))))
for Nre in (10,20):
    for K in (20,50):
        cells.append(('F2 re N%d K%d'%(Nre,K),ev(trade(E_(55),E_(Nre),K,None))))
nb=base['all'][0]; print('SW',SW,'base n',nb)
print('cella | n (x base) | PF tutto | t | PF A / B / C | porta')
out=[]
for name,v in cells:
    ok=v['all'][0]>=1.5*nb and all(v[p][1]>=1.3 for p in 'ABC') and v['all'][3]>=3
    print('%-16s | %4d (%.2fx) | %.2f | %.2f | %.2f / %.2f / %.2f | %s'%(name,v['all'][0],v['all'][0]/nb,v['all'][1],v['all'][3],v['A'][1],v['B'][1],v['C'][1],'PASSA' if ok else '-'))
    out.append([name,v['all'][0],round(v['all'][1],3),round(v['all'][3],2)]+[round(v[p][1],3) for p in 'ABC']+[ok])
os.makedirs('/home/user/GITHUB/report/GOLDENZOE_PIU_TRADE_dati',exist_ok=True)
csv.writer(open('/home/user/GITHUB/report/GOLDENZOE_PIU_TRADE_dati/risultati%s.csv'%('' if SW==0.055 else '_swap97'),'w',newline=''),delimiter=';').writerows([['cella','n','pf','t','pfA','pfB','pfC','porta']]+out)
