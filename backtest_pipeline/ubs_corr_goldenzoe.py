import sys,os,glob,re,collections,datetime as dt
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
            px=min(O[i],stop); rec.append((idx4[start],idx4[i],(px-ent)/risk)); pos=0; continue
        ext=max(ext,H[i]); stop=max(stop,ext-3*atr[i])
gz=pd.Series({te:R for (_,te,R) in rec}); gz.index=pd.to_datetime(gz.index)
print('GoldenZoe trade',len(gz),gz.index.min(),gz.index.max())
def deals(h):
    t=open(h,'rb').read().decode('utf-16'); t=re.sub(r'<[^>]+>','|',t); t=re.sub(r'[|\s]*\|[|\s]*','|',t)
    i=t.find('|Affari|'); seg=t[i:]; out=[]
    for m in re.finditer(r'(\d{4}\.\d\d\.\d\d \d\d:\d\d:\d\d)\|\d+\|[A-Z]+\|(?:buy|sell)\|out\|[\d.]+\|[\d.]+\|\d+\|(-?[\d.]+)\|(-?[\d.]+)\|(-?[\d. ]+?)\|',seg):
        v=sum(float(x.replace(' ','')) for x in m.groups()[1:])
        out.append((pd.Timestamp(m.group(1).replace('.','-',2)),v))
    return pd.Series(dict(out)) if out else pd.Series(dtype=float)
base='/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/'
W={}
import json
R1b=json.load(open('/tmp/claude-0/ubs_r1b.json')); R1=json.load(open('/tmp/claude-0/ubs_r1.json'))
def rep(pat): 
    g=glob.glob(pat); return deals(glob.glob(g[0]+'/*/report/*.htm')[0]) if g else None
sets={}
for j in ['K016','K018','K020','K022','K032','K041','K042','K058','K059','K060','K061','K062','K063']:
    s=rep(base+'r1b/p?/UBSR1B_%s_*'%j); 
    if s is not None: sets['ORO_'+j]=s
for r in R1:
    if r['tf']=='D1' and r['cl'] in('CONFERMATO','PARZIALE') and r['simbolo'] in('USDJPY','EURUSD','GBPUSD','AUDUSD','NZDUSD','GBPJPY','EURJPY'):
        s=rep(base+'ubsn/p?/UBSNT_%s_*'%r['job']); 
        if s is not None: sets[r['simbolo']+'_'+r['job']]=s
wk=lambda s: s.resample('W').sum()
t0=pd.Timestamp('2021-06-01'); t1=pd.Timestamp('2026-10-31')
idx=pd.date_range(t0,t1,freq='W')
G=wk(gz[gz.index>=t0]).reindex(idx).fillna(0)
fam=collections.defaultdict(list)
for k,s in sets.items():
    s=s[(s.index>=t0)&(s.index<=t1)]; fam[k.split('_')[0]].append(wk(s).reindex(idx).fillna(0))
F={k:sum(v) for k,v in fam.items()}
F['GoldenZoe']=G
df=pd.DataFrame(F); print('settimane',len(df)); print(df.corr().round(2).to_string())
print('\nORO set singoli vs GoldenZoe (settimanale):')
for k,s in sets.items():
    if k.startswith('ORO_'):
        x=wk(s[(s.index>=t0)&(s.index<=t1)]).reindex(idx).fillna(0); print(k,round(np.corrcoef(x,G)[0,1],2))

print('\n=== mensile e trimestrale (P&L realizzato) ===')
gold=d['close'].resample('D').last().dropna()
for fr,lab in (('M','mensile'),('Q','trimestrale')):
    idx2=pd.period_range(t0,t1,freq=fr)
    def agg(s): 
        s=s[(s.index>=t0)&(s.index<=t1)]; return s.groupby(s.index.to_period(fr)).sum().reindex(idx2).fillna(0)
    Gm=agg(gz); gr=gold.groupby(gold.index.to_period(fr)).last().pct_change().reindex(idx2).fillna(0)
    fams=collections.defaultdict(list)
    for k,s in sets.items(): fams[k.split('_')[0]].append(agg(s))
    X=pd.DataFrame({k:sum(v) for k,v in fams.items()}); X['GoldenZoe']=Gm; X['rend_oro']=gr
    print(lab,len(idx2),'periodi'); print(X.corr().round(2)[['GoldenZoe','rend_oro']].T.to_string())
