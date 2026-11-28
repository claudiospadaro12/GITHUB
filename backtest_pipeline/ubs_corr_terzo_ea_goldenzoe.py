import sys,glob,re
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index
e55=np.where(entries_breakout(C,H,L,55)==1,1,0); rec=[]; pos=0
for i in range(120,len(C)-1):
    if pos==0:
        if e55[i]!=1 or np.isnan(atr[i]): continue
        ent=O[i+1]; risk=3*atr[i]
        if risk<=0: continue
        pos=1; stop=ent-risk; ext=ent; start=i+1
    if pos==1 and i>=start:
        if L[i]<=stop:
            px=min(O[i],stop); rec.append((idx4[i],(px-ent)/risk)); pos=0; continue
        ext=max(ext,H[i]); stop=max(stop,ext-3*atr[i])
gz=pd.Series(dict(rec)); gz.index=pd.to_datetime(gz.index)
print('GoldenZoe ricostruito (R per operazione)',len(gz),gz.index.min().date(),gz.index.max().date())
rx=re.compile(r'<td>(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)</td><td>\d+</td><td>[A-Z]+</td><td>(?:buy|sell)</td><td>out</td><td>[\d.]+</td><td>[\d.]+</td><td>\d+</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td>')
num=lambda x: float(x.replace(' ','').replace('\xa0',''))
def deals(h):
    t=open(h,'rb').read().decode('utf-16'); out={}
    for m in rx.finditer(t):
        ts=pd.Timestamp(m.group(1).replace('.','-',2)); out[ts]=out.get(ts,0)+sum(num(x) for x in m.groups()[1:])
    return pd.Series(out).sort_index()
B='/tmp/r4/'
S={}
for k in (4,10,14,2):
    for tag in 'AB': S[(k,tag)]=deals(glob.glob(B+'UBSR4_RO%02d%s_*/*/report/*.htm'%(k,tag))[0])
gold=d['close'].resample('D').last().dropna()
def per(s,fr,t0,t1):
    s=s[(s.index>=t0)&(s.index<=t1)]; idx=pd.period_range(t0,t1,freq=fr)
    return s.groupby(s.index.to_period(fr)).sum().reindex(idx).fillna(0)
def boot(a,b,n=5000):
    rng=np.random.default_rng(7); L=len(a); out=[]
    for _ in range(n):
        ix=rng.integers(0,L,L); 
        if a.values[ix].std()>0 and b.values[ix].std()>0: out.append(np.corrcoef(a.values[ix],b.values[ix])[0,1])
    return np.percentile(out,[2.5,97.5])
for tag,t0,t1 in (('A','2004-09-01','2012-12-31'),('B','2025-01-01','2026-10-31')):
    t0=pd.Timestamp(t0); t1=pd.Timestamp(t1); print('\n=== %s %s -> %s'%(tag,t0.date(),t1.date()))
    for fr,lab in (('M','mensile'),('Q','trimestrale')):
        G=per(gz,fr,t0,t1); idx=pd.period_range(t0,t1,freq=fr)
        gr=gold.groupby(gold.index.to_period(fr)).last().pct_change().reindex(idx).fillna(0)
        for k in (4,10,14,2):
            x=per(S[(k,tag)],fr,t0,t1); c=np.corrcoef(x,G)[0,1]; co=np.corrcoef(x,gr)[0,1]
            ci=boot(x,G) if lab=='mensile' else (np.nan,np.nan)
            print('%s n.%-2d vs GoldenZoe r=%5.2f [IC95 %5.2f;%5.2f]  vs rend.oro r=%5.2f  (%d periodi)'%(lab,k,c,ci[0],ci[1],co,len(idx)))
# sovrapposizione giorni in posizione non misurabile: correlazione giornaliera
for tag,t0,t1 in (('A','2004-09-01','2012-12-31'),('B','2025-01-01','2026-10-31')):
    t0=pd.Timestamp(t0); t1=pd.Timestamp(t1)
    x=S[(4,tag)]; x=x[(x.index>=t0)&(x.index<=t1)].resample('W').sum(); G=gz[(gz.index>=t0)&(gz.index<=t1)].resample('W').sum()
    ix=x.index.union(G.index); print(tag,'settimanale n.4 vs GoldenZoe r=%.2f (%d sett)'%(np.corrcoef(x.reindex(ix).fillna(0),G.reindex(ix).fillna(0))[0,1],len(ix)))
