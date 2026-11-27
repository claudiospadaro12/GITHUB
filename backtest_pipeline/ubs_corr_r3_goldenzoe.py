import sys,glob,re,collections
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index
e55=np.where(entries_breakout(C,H,L,55)==1,1,0)
rec=[]; pos=0
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
print('GoldenZoe ricostruito',len(gz),gz.index.min().date(),gz.index.max().date())
rx=re.compile(r'<td>(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)</td><td>\d+</td><td>[A-Z]+</td><td>(?:buy|sell)</td><td>out</td><td>[\d.]+</td><td>[\d.]+</td><td>\d+</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td><td>(-?[\d. ]+)</td>')
def num(x): return float(x.replace(' ','').replace('\xa0',''))
def deals(h):
    t=open(h,'rb').read().decode('utf-16'); out={}
    for m in rx.finditer(t):
        ts=pd.Timestamp(m.group(1).replace('.','-',2)); out[ts]=out.get(ts,0)+sum(num(x) for x in m.groups()[1:])
    return pd.Series(out).sort_index()
B='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/'
S={}
for k in range(1,11):
    for tag,per in (('A','p'),('B','q')):
        g=glob.glob(B+'r3/UBSR3_RC%02d%s_*'%(k,tag)); S[(k,tag)]=deals(glob.glob(g[0]+'/*/report/*.htm')[0])
D1=[]
for j in ['RK016','RK018','RK020','RK022','RK032','RK041','RK042','RK058','RK059','RK060','RK061','RK062','RK063']:
    g=glob.glob(B+'r2/p?/UBSR2_%s_*'%j)
    if g: D1.append(deals(glob.glob(g[0]+'/*/report/*.htm')[0]))
D1=pd.concat(D1).sort_index() if D1 else pd.Series(dtype=float)
gold=d['close'].resample('D').last().dropna()
def per(s,fr,t0,t1):
    s=s[(s.index>=t0)&(s.index<=t1)]; idx=pd.period_range(t0,t1,freq=fr)
    return s.groupby(s.index.to_period(fr)).sum().reindex(idx).fillna(0)
def report(t0,t1,tag,keys):
    print('\n=== %s %s -> %s'%(tag,t0,t1))
    for fr,lab in (('M','mensile'),('Q','trimestrale')):
        X={}
        G=per(gz,fr,t0,t1); X['GoldenZoe']=G
        g50=sum(per(S[(k,tag)],fr,t0,t1) for k in range(1,6)); g80=sum(per(S[(k,tag)],fr,t0,t1) for k in range(6,11))
        X['G50 (5 set)']=g50; X['G80 (5 set)']=g80; X['tutti 10']=g50+g80
        if tag=='A': X['UBS oro D1 (13)']=per(D1,fr,t0,t1)
        idx=pd.period_range(t0,t1,freq=fr); gr=gold.groupby(gold.index.to_period(fr)).last().pct_change().reindex(idx).fillna(0); X['rend_oro']=gr
        df=pd.DataFrame(X); c=df.corr().round(2)
        print(lab,len(idx),'periodi'); print(c[['GoldenZoe','rend_oro']].T.to_string())
        if lab=='mensile':
            sing=[(k,round(np.corrcoef(per(S[(k,tag)],fr,t0,t1),G)[0,1],2)) for k in range(1,11)]; print('singoli vs GoldenZoe (mensile):',sing)
            m=pd.DataFrame({k:per(S[(k,tag)],fr,t0,t1) for k in range(1,11)}).corr().values; print('correlazione fra set (mensile): media %.2f max %.2f'%(m[np.triu_indices(10,1)].mean(),m[np.triu_indices(10,1)].max()))
report(pd.Timestamp('2004-09-01'),pd.Timestamp('2019-12-31'),'A',None)
report(pd.Timestamp('2025-01-01'),pd.Timestamp('2026-10-31'),'B',None)
