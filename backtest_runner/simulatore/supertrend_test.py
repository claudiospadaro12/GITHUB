# Criteri: report/SUPERTREND_CRITERI_2026-11-21.md
import sys,glob; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np, pandas as pd
from tv_concetti import SRC,load,rs
HO=pd.Timestamp('2025-06-01'); out=[]
def P(*a):
    s=' '.join(str(x) for x in a); out.append(s); print(s,flush=True)
def supertrend(o,h,l,c,per=10,mult=3.0):
    n=len(c); pc=np.r_[np.nan,c[:-1]]; tr=np.maximum(h-l,np.maximum(np.abs(h-pc),np.abs(l-pc))); tr[0]=h[0]-l[0]
    atr=pd.Series(tr).ewm(alpha=1/per,adjust=False).mean().values; hl2=(h+l)/2
    up=np.empty(n); dn=np.empty(n); tre=np.ones(n,int)
    up[0]=hl2[0]-mult*atr[0]; dn[0]=hl2[0]+mult*atr[0]
    for i in range(1,n):
        u=hl2[i]-mult*atr[i]; d=hl2[i]+mult*atr[i]
        up[i]=max(u,up[i-1]) if c[i-1]>up[i-1] else u
        dn[i]=min(d,dn[i-1]) if c[i-1]<dn[i-1] else d
        t=tre[i-1]
        if t==-1 and c[i]>dn[i-1]: t=1
        elif t==1 and c[i]<up[i-1]: t=-1
        tre[i]=t
    return tre,up,dn
def trades(d,cost_fn,swap):
    o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); idx=d.index
    tre,up,dn=supertrend(o,h,l,c); fl=np.nonzero(tre[1:]!=tre[:-1])[0]+1; fl=fl[fl<n-1]; out=[]
    for k,i in enumerate(fl):
        j=fl[k+1] if k+1<len(fl) else None
        if j is None: break
        e=o[i+1]; x=o[j+1]; side=tre[i]; band=up[i] if side==1 else dn[i]; risk=abs(e-band)/e
        if risk<=0: continue
        nights=(idx[j+1].normalize()-idx[i+1].normalize()).days
        ret=side*(x/e-1)-cost_fn(e)-(swap/100/365*nights if side==1 else 0)
        out.append((idx[i+1],side,ret/risk))
    return pd.DataFrame(out,columns=['t','side','R'])
def stt(x):
    n=len(x)
    if n==0: return (0,np.nan,np.nan)
    r=x.R.values; g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l if l>0 else np.inf
    t=r.mean()/(r.std(ddof=1)/np.sqrt(n)) if n>2 and r.std(ddof=1)>0 else 0.0
    return (n,pf,t)
def evalcell(name,cl,tf,T,idx):
    pre=idx[idx<HO]; cut=pre[int(len(pre)*.7)]; res=[]
    for lab,sel in (('long',T.side==1),('short',T.side==-1),('both',T.side!=0)):
        x=T[sel]; a=x[x.t<cut]; b=x[(x.t>=cut)&(x.t<HO)]; h=x[x.t>=HO]; sa,sb,sh=stt(a),stt(b),stt(h)
        ps=sa[0]>=30 and sa[1]>=1.3 and sa[2]>=2 and sb[0]>=15 and sb[1]>1.2
        ho='NV' if sh[0]<8 else ('ok' if sh[1]>1.0 else 'KO')
        res.append((name,cl,tf,lab,sa,sb,sh,ho,ps))
    return res
CLS={'Oro':'metalli','Argento':'metalli','Platino':'metalli','Rame':'metalli','Bitcoin':'cripto','Ethereum':'cripto','Benzina':'energia','Gas_naturale':'energia','Gasolio_riscaldamento':'energia','Petrolio_Brent':'energia','Petrolio_WTI':'energia','Cacao':'agricoli','Caffe':'agricoli','Cotone':'agricoli','Grano':'agricoli','Mais':'agricoli','Soia':'agricoli','Zucchero':'agricoli','Treasury_10a':'tassi_fx','Treasury_30a':'tassi_fx','Indice_dollaro':'tassi_fx'}
COST={'Argento':0.081,'Petrolio_Brent':0.074,'Petrolio_WTI':0.089,'Platino':0.42,'Rame':0.095,'Russell2000':0.034,'HangSeng':0.03,'FTSE100':0.021,'EuroStoxx50':0.021,'Ethereum':0.03,'Oro':0.02,'Bitcoin':0.02,'Nikkei225':0.02,'Nasdaq100':0.02,'SP500':0.02,'DAX':0.02,'CAC40':0.02,'Dow30':0.02,'ASX200':0.02}
SWAP={'Oro':5.6,'Argento':5.6,'Bitcoin':10,'Ethereum':10,'Petrolio_Brent':5,'Petrolio_WTI':5,'Nikkei225':5.5}
cells=[]; allres=[]
def addm1(name,cl,pats,sep,fmt,cost_pts,swap,tfs):
    dd=[]
    for p in pats:
        for f in sorted(glob.glob(p)):
            if fmt=='a': d=pd.read_csv(f,sep=sep,usecols=[0,1,2,3,4]); d.columns=['t','o','h','l','c']
            else:
                d=pd.read_csv(f,sep=sep,header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']; d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))].drop(columns='tv')
            dd.append(d)
    d1=pd.concat(dd); d1['t']=pd.to_datetime(d1.t,format='%Y.%m.%d %H:%M'); d1=d1.drop_duplicates('t').set_index('t').sort_index()
    for tf,rule in tfs:
        d=rs(d1,rule); T=trades(d,lambda e:cost_pts/e,swap); allres.extend(evalcell(name,cl,tf,T,d.index)); P(f'  fatto {name} {tf} barre {len(d)} trade {len(T)}')
TF=[('M15','15min'),('M30','30min'),('H1','1h'),('H4','4h'),('D1','1D')]
addm1('XAUUSD_M1','metalli',['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';','f',0.35,5.6,TF)
addm1('EURUSD_M1','tassi_fx',['/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv'],';','f',0.0001,0.8,TF)
addm1('NASUSD_M1','indici',['/tmp/claude-0/nas/NASUSD_M1_*.csv','/tmp/claude-0/ext2526/NASUSD_M1_*.csv'],',','a',2.0,7.5,TF[:4])
addm1('SPXUSD_M1','indici',['/tmp/claude-0/spx/SPXUSD_M1_*.csv','/tmp/claude-0/ext2526/SPXUSD_M1_*.csv'],',','a',0.7,7.5,TF[:4])
import glob as G
for f in sorted(G.glob('/tmp/claude-0/d1/D1_*.csv')):
    m=f.split('D1_')[1][:-4]
    if m in ('ELENCO','Palladio'): continue
    d=pd.read_csv(f,sep=';'); d.columns=['t','o','h','l','c','v']; d['t']=pd.to_datetime(d.t); d=d.dropna(subset=['o','h','l','c']).sort_values('t').set_index('t'); d=d[d.c>0]
    ok=(d.h>d.l).astype(float).rolling(60).mean(); fi=ok.index[ok>0.95]
    if not len(fi): continue
    d=d[d.index>=fi[0]]; cl=CLS.get(m,'indici'); cst=COST.get(m,0.05 if m in CLS else 0.02)
    T=trades(d,lambda e,c=cst:c/100,SWAP.get(m,7.5 if cl=='indici' else 5)); allres.extend(evalcell(m,cl,'D1y',T,d.index))
P(f'\nvalutazioni: {len(allres)}')
pas=[r for r in allres if r[8]]
P('celle-lato che passano IS+OOS:',len(pas))
for r in pas: P(f'  PASSA {r[0]:15s}{r[1]:9s}{r[2]:4s}{r[3]:6s} IS {r[4][0]} {r[4][1]:.2f} t{r[4][2]:+.1f} | OOS {r[5][0]} {r[5][1]:.2f} | HO {r[6][0]} {r[6][1]:.2f} {r[7]}')
P('\n=== PF IS medio per TF e lato (tutte le celle)')
df=pd.DataFrame([(r[2],r[3],r[4][1],r[5][1]) for r in allres],columns=['tf','lato','pfIS','pfOOS']).replace([np.inf],np.nan)
P(df.groupby(['tf','lato']).agg(pfIS=('pfIS','median'),pfOOS=('pfOOS','median'),n=('pfIS','count')).round(2).to_string())
P('\n=== coerenza di classe (stesso TF e lato, >=2 mercati della stessa classe)')
from collections import defaultdict
g=defaultdict(set)
for r in pas: g[(r[2],r[3],r[1])].add(r[0].replace('_M1',''))
for k,v in g.items(): P(' ',k,sorted(v),'-> CANDIDATO' if len(v)>=2 else '-> da guardare')
P('\n=== le 8 celle piu\' vicine (PF IS x t) tra quelle non passanti con IS n>=30')
cand=[r for r in allres if not r[8] and r[4][0]>=30 and r[4][1]==r[4][1]]; cand.sort(key=lambda r:-r[4][1])
for r in cand[:8]: P(f'  {r[0]:15s}{r[2]:4s}{r[3]:6s} IS {r[4][0]} {r[4][1]:.2f} t{r[4][2]:+.1f} | OOS {r[5][0]} {r[5][1]:.2f} | HO {r[6][0]} {r[6][1]:.2f} {r[7]}')
open('/home/user/GITHUB/report/SUPERTREND_RISULTATI_2026-11-21.txt','w',encoding='utf-8').write('\n'.join(out)+'\n')
