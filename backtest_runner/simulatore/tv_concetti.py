# Criteri: report/TV_CONCETTI_CRITERI_2026-11-20.md  (T1 z-score, T2 candela impulsiva, T3 filtro ER su Donchian D1)
import glob,sys
import numpy as np, pandas as pd
SRC={'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',';',0.35,'f'),'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',';',0.0001,'f'),
     'NASUSD':('/tmp/claude-0/nas/NASUSD_M1_*.csv',',',2.0,'a'),'SPXUSD':('/tmp/claude-0/spx/SPXUSD_M1_*.csv',',',0.7,'a')}
def load(pat,sep,fmt):
    dd=[]
    for f in sorted(glob.glob(pat)):
        if fmt=='a': d=pd.read_csv(f,sep=sep,usecols=[0,1,2,3,4]); d.columns=['t','o','h','l','c']
        else:
            d=pd.read_csv(f,sep=sep,header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']
            d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))].drop(columns='tv')
        dd.append(d)
    d=pd.concat(dd); d['t']=pd.to_datetime(d.t,format='%Y.%m.%d %H:%M'); return d.drop_duplicates('t').set_index('t').sort_index()
def rs(d,r): return d.resample(r).agg({'o':'first','h':'max','l':'min','c':'last'}).dropna()
def atr(h,l,c,p=14):
    pc=np.roll(c,1); tr=np.maximum(h-l,np.maximum(abs(h-pc),abs(l-pc))); tr[0]=h[0]-l[0]
    return pd.Series(tr).ewm(alpha=1/p,adjust=False).mean().values
def stats(r):
    r=np.array(r)
    if len(r)==0: return 'n=0'
    w=r[r>0].sum(); l=-r[r<=0].sum(); m=r.mean(); sd=r.std(ddof=1) if len(r)>1 else 0
    return f"n={len(r):4d} R={m:+.3f} PF={(w/l if l>0 else 9.99):4.2f} t={(m/(sd/len(r)**.5) if sd>0 else 0):+.1f}"
# ---------------- T1 ----------------
def t1(o,h,l,c,cost,k):
    n=len(c); s=pd.Series(c); m=s.rolling(100).mean().values; sd=s.rolling(100).std(ddof=0).values
    z=(c-m)/sd; a=atr(h,l,c); out=[]; i=101
    while i<n-2:
        sg=0
        if z[i]<=-k and z[i-1]>-k: sg=1
        elif z[i]>=k and z[i-1]<k: sg=-1
        if sg==0 or np.isnan(a[i]) or a[i]<=0: i+=1; continue
        e=o[i+1]; R=2*a[i]; sl=e-sg*R; j=i+1; ex=None
        while j<n-1:
            if (sg==1 and l[j]<=sl) or (sg==-1 and h[j]>=sl): ex=sl; break
            if (sg==1 and z[j]>=0) or (sg==-1 and z[j]<=0): ex=o[j+1]; break
            if j-i>=40: ex=c[j]; break
            j+=1
        if ex is None: ex=c[min(j,n-1)]
        out.append((i,sg,((ex-e)*sg-cost)/R)); i=max(j,i+1)
    return out
# ---------------- T2 ----------------
def t2(o,h,l,c,cost,H,mode):
    n=len(c); a=atr(h,l,c); rng=h-l; body=abs(c-o)
    imp=(rng>0)&(body>=0.7*rng)&(rng>=1.5*a); out=[]; i=20
    while i<n-H-2:
        if not imp[i]: i+=1; continue
        d=1 if c[i]>o[i] else -1; td=d if mode=='C' else -d
        e=o[i+1]; ex=c[i+H]; out.append((i,td,((ex-e)*td-cost)/a[i])); i+=H+1
    return out
def split(res,n,cut): 
    return [r for r in res if r[0]<cut],[r for r in res if r[0]>=cut]
def main():
    print('=== T1 z-score mean reversion ==='); print('(IS|OOS)')
    cells=[]
    for sym,(pat,sep,cost,fmt) in SRC.items():
        d1=load(pat,sep,fmt)
        for tf,rule in (('H1','1h'),('H4','4h'),('D1','1D'),('M30','30min')):
            d=rs(d1,rule); o,h,l,c=[d[x].values.astype(float) for x in 'ohlc']; n=len(c); cut=int(n*.7)
            if tf!='M30':
                for k in (2.0,2.5):
                    res=t1(o,h,l,c,cost,k); a,b=split(res,n,cut)
                    ra=[r[2] for r in a]; rb=[r[2] for r in b]
                    print(f"T1 {sym:7s} {tf:3s} k={k}  IS {stats(ra)} | OOS {stats(rb)}")
            else:
                for H in (4,8):
                    for mode in ('C','F'):
                        res=t2(o,h,l,c,cost,H,mode); a,b=split(res,n,cut)
                        print(f"T2 {sym:7s} M30 H={H} {mode}  IS {stats([r[2] for r in a])} | OOS {stats([r[2] for r in b])}")
    # T3
    print('\n=== T3 Donchian D1 + ER(20) ===')
    files={'BTC':'D1_Bitcoin','ETH':'D1_Ethereum','ORO':'D1_Oro','ARG':'D1_Argento','WTI':'D1_Petrolio_WTI','DAX':'D1_DAX','NDX':'D1_Nasdaq100','SPX':'D1_SP500'}
    allr=[]
    for nm,f in files.items():
        d=pd.read_csv(f'/tmp/claude-0/d1/{f}.csv',sep=';'); d=d.dropna(); o,h,l,c=[d[x].values.astype(float) for x in ('open','high','low','close')]
        n=len(c); cut=int(n*.7); a=atr(h,l,c,20); hh=pd.Series(h).rolling(55).max().shift(1).values; ll=pd.Series(l).rolling(55).min().shift(1).values
        h20=pd.Series(h).rolling(20).max().shift(1).values; l20=pd.Series(l).rolling(20).min().shift(1).values
        er=np.full(n,np.nan); ac=np.abs(np.diff(c,prepend=c[0])); sm=pd.Series(ac).rolling(20).sum().values
        er[20:]=np.abs(c[20:]-c[:-20])/sm[20:]
        i=60
        while i<n-2:
            sg=0
            if c[i]>hh[i]: sg=1
            elif c[i]<ll[i]: sg=-1
            if sg==0 or np.isnan(er[i]): i+=1; continue
            e=o[i+1]; R=2*a[i]; j=i+1; ex=None
            while j<n-1:
                if (sg==1 and c[j]<l20[j]) or (sg==-1 and c[j]>h20[j]): ex=o[j+1]; break
                j+=1
            if ex is None: ex=c[min(j,n-1)]
            allr.append((nm,i<cut,sg,er[i],((ex-e)*sg-0.0005*e)/R)); i=max(j,i+1)
    df=pd.DataFrame(allr,columns=['m','IS','side','er','R'])
    q1,q2=np.nanpercentile(df[df.IS].er,[33.3,66.7]); print(f"terzili ER (IS): {q1:.3f} {q2:.3f}")
    for per,flag in (('IS',True),('OOS',False)):
        x=df[df.IS==flag]
        print(f"  {per}: tutti {stats(x.R)} | ER basso {stats(x[x.er<q1].R)} | medio {stats(x[(x.er>=q1)&(x.er<q2)].R)} | ER alto {stats(x[x.er>=q2].R)}")
        for sd,sn in ((1,'long'),(-1,'short')):
            y=x[x.side==sd]; print(f"     {sn}: basso {stats(y[y.er<q1].R)} | alto {stats(y[y.er>=q2].R)}")
    # per mercato (alto - basso) in OOS e IS
    ok=0
    for nm in files:
        x=df[df.m==nm]; r=[]
        for flag in (True,False):
            y=x[x.IS==flag]; hi=y[y.er>=q2].R.mean(); lo=y[y.er<q1].R.mean(); r.append(hi-lo)
        ok+= (r[0]>0 and r[1]>0); print(f"   {nm}: alto-basso IS {r[0]:+.2f} OOS {r[1]:+.2f}")
    print('mercati con alto>basso in IS e OOS:',ok,'/ 8')
if __name__=='__main__': main()
