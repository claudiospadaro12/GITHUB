# ORB + Fibonacci (Emiliano). Criteri: report/ORB_FIBO_EMILIANO_CRITERI_2026-11-20.md
import glob,sys
import numpy as np, pandas as pd
CELLS=[('NASUSD','/tmp/claude-0/nas/NASUSD_M1_*.csv',',','a',2.0,'ny',False),('SPXUSD','/tmp/claude-0/spx/SPXUSD_M1_*.csv',',','a',0.7,'ny',False),
       ('XAUUSD','/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',';','f',0.66,'srv',False),('XAUUSD','/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',';','f',0.66,'srv',True),
       ('EURUSD','/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',';','f',0.0001,'srv',False),('EURUSD','/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',';','f',0.0001,'srv',True)]
def load(pat,sep,fmt):
    dd=[]
    for f in sorted(glob.glob(pat)):
        if fmt=='a': d=pd.read_csv(f,sep=sep,usecols=[0,1,2,3,4]); d.columns=['t','o','h','l','c']; d['v']=0
        else:
            d=pd.read_csv(f,sep=sep,header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','v']
            d=d[~(d.t.str.endswith('00:00')&(d.v>2000))]
        dd.append(d)
    d=pd.concat(dd); d['t']=pd.to_datetime(d.t,format='%Y.%m.%d %H:%M'); return d.drop_duplicates('t').set_index('t').sort_index()
def to_m5(d,clock):
    if clock=='srv':
        idx=(d.index-pd.Timedelta(hours=1)).tz_localize('Europe/Rome',ambiguous='NaT',nonexistent='NaT')
        d=d.copy(); d.index=idx; d=d[d.index.notna()]; d.index=d.index.tz_convert('America/New_York').tz_localize(None)
    return d.resample('5min').agg({'o':'first','h':'max','l':'min','c':'last','v':'sum'}).dropna(subset=['o'])
def ema(x,p): return pd.Series(x).ewm(span=p,adjust=False).mean().values
def run(m5,cost,usevol,rrskip=True):
    o,h,l,c,v=[m5[x].values.astype(float) for x in ('o','h','l','c','v')]
    e9,e21=ema(c,9),ema(c,21); macd=ema(c,12)-ema(c,26); hist=macd-ema(macd,9)
    vavg=pd.Series(v).rolling(20).mean().shift(1).values
    ti=m5.index; day=ti.normalize(); hm=ti.hour*60+ti.minute
    out=[]; n=len(c)
    starts=np.r_[0,np.nonzero(np.diff(day.values.astype('int64')))[0]+1,n]
    for s,e in zip(starts[:-1],starts[1:]):
        if day[s].weekday()>4: continue
        hh=hm[s:e]; ix=np.arange(s,e)
        orm=(hh>=570)&(hh<600)
        if orm.sum()<5: continue
        orh=h[ix[orm]].max(); orl=l[ix[orm]].min()
        win=ix[(hh>=600)&(hh<=690)]   # 10:00 -> 11:30 (barre che iniziano)
        sess_start=ix[hh>=570][0]
        bo=None
        for i in win:
            rng=h[i]-l[i]
            if rng<=0 or abs(c[i]-o[i])<0.6*rng: continue
            if usevol and not (vavg[i]>0 and v[i]>=1.5*vavg[i]): continue
            if c[i]>orh and c[i]>e9[i] and c[i]>e21[i] and e9[i]>e21[i]: bo=(i,1); break
            if c[i]<orl and c[i]<e9[i] and c[i]<e21[i] and e9[i]<e21[i]: bo=(i,-1); break
        if bo is None: continue
        b,d=bo; trade=None; ext=h[b] if d==1 else l[b]
        for i in range(b,e):
            if hm[i]>690: break
            if d==1: ext=max(ext,h[i])
            else: ext=min(ext,l[i])
            if i==b: continue
            ref=l[sess_start:i+1].min() if d==1 else h[sess_start:i+1].max()
            rngf=(ext-ref)*d
            if rngf<=0: continue
            L50=ext-d*0.5*rngf; L618=ext-d*0.618*rngf; L786=ext-d*0.786*rngf
            if (d==1 and l[i]<L786) or (d==-1 and h[i]>L786): break   # zona rotta: nessun trade
            touch=(l[i]<=L50) if d==1 else (h[i]>=L50)
            strong=(c[i]>o[i] and c[i]>L618) if d==1 else (c[i]<o[i] and c[i]<L618)
            ema_ok=(c[i]>e9[i] and c[i]>e21[i]) if d==1 else (c[i]<e9[i] and c[i]<e21[i])
            curl=(hist[i]>hist[i-1]) if d==1 else (hist[i]<hist[i-1])
            if touch and strong and ema_ok and curl and i+1<e:
                en=o[i+1]; sl=L786; risk=(en-sl)*d
                if risk<=0: break
                if (ext-en)*d<=0: break
                if rrskip and (abs(ext-en))/risk<2: break
                trade=(i+1,en,sl,ext,risk); break
        if trade is None: continue
        j0,en,sl,tp,risk=trade; half=False; res=0.0; done=False
        for j in range(j0,e):
            rem=1.0-(0.5 if half else 0.0)
            if hm[j]>=960:
                res+=rem*(((o[j]-en)*d)/risk); done=True; break
            if (l[j]<=sl) if d==1 else (h[j]>=sl):
                res+=rem*(((sl-en)*d)/risk); done=True; break
            if (not half) and ((h[j]>=tp) if d==1 else (l[j]<=tp)):
                res+=0.5*(((tp-en)*d)/risk); half=True
            if half and ((c[j]<e9[j]) if d==1 else (c[j]>e9[j])):
                res+=0.5*(((c[j]-en)*d)/risk); done=True; break
        if not done:
            rem=1.0-(0.5 if half else 0.0); res+=rem*(((c[e-1]-en)*d)/risk)
        res-=cost/risk
        out.append((day[s],d,res))
    return out
def st(r):
    r=np.array(r)
    if len(r)==0: return 'n=0'
    w=r[r>0].sum(); l=-r[r<=0].sum(); m=r.mean(); sd=r.std(ddof=1) if len(r)>1 else 0
    return f"n={len(r):4d} R={m:+.3f} PF={(w/l if l>0 else 9.99):4.2f} t={(m/(sd/len(r)**.5) if sd>0 else 0):+.1f} win={100*(r>0).mean():.0f}%"
def main():
    cache={}
    for sym,pat,sep,fmt,cost,clock,uv in CELLS:
        key=(pat,clock)
        if key not in cache: cache[key]=to_m5(load(pat,sep,fmt),clock)
        m5=cache[key]
        for rrs in (True,False):
            res=run(m5,cost,uv,rrs); report(sym,uv,rrs,res,m5)
def report(sym,uv,rrs,res,m5):
    if True:
        allday=m5.index.normalize().unique(); cut=allday[int(len(allday)*0.7)]
        a=[r for r in res if r[0]<cut]; b=[r for r in res if r[0]>=cut]
        tag=f"{sym} vol={'si' if uv else 'no'} {'A(RR>=2)' if rrs else 'B(senza skip)'}"
        print(f"{tag:14s} IS {st([r[2] for r in a])} | OOS {st([r[2] for r in b])}")
        for d,nm in ((1,'long'),(-1,'short')):
            print(f"      {nm:5s} IS {st([r[2] for r in a if r[1]==d])} | OOS {st([r[2] for r in b if r[1]==d])}")
        ys={}
        for r in res: ys.setdefault(r[0].year,[]).append(r[2])
        print('      anni R medio:',{y:round(float(np.mean(v)),2) for y,v in sorted(ys.items())})
if __name__=='__main__': main()
