# BandSlope_Analyzer.py - segnali IN-BULGE/POST-BULGE (indicatore Pine di Claudio, riprodotto) + filtro pendenza/espansione bande
# Criteri scritti prima: report/BANDSLOPE_CRITERI_2026-11-20.md.  Uso: python BandSlope_Analyzer.py [prova]
import glob,sys,time,json,itertools
import numpy as np, pandas as pd
OUT='/tmp/claude-0/bandslope'
import os; os.makedirs(OUT,exist_ok=True)
SRC={ # simbolo: (pattern, sep, costo in punti, formato)
 'NASUSD':('/tmp/claude-0/nas/NASUSD_M1_*.csv',',',2.0,'a'),
 'SPXUSD':('/tmp/claude-0/spx/SPXUSD_M1_*.csv',',',0.7,'a'),
 'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',';',0.35,'f'),
 'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',';',0.0001,'f')}
D1Y={'DAX':('/tmp/claude-0/d1/D1_DAX.csv',2.0),'Dow30':('/tmp/claude-0/d1/D1_Dow30.csv',3.0)}
TFS={'M5':'5min','M15':'15min','M30':'30min','H1':'1h','H4':'4h','D1':'1D'}
BB=[(L,d) for L in (14,20,30) for d in (1.5,2.0,2.5)]
SL_T=(0.25,0.5,1.0); MODES=('ABS','WITH','AGAINST'); EX_T=(1.0,1.1,1.25)
TGT=1.0; STP=1.0; MAXB=30; N_SLOPE=6; X_EXP=50
def load_m1(pat,sep,fmt):
    fs=sorted(glob.glob(pat)); dd=[]
    for f in fs:
        if fmt=='a': d=pd.read_csv(f,sep=sep,usecols=[0,1,2,3,4]); d.columns=['t','o','h','l','c']
        else:
            d=pd.read_csv(f,sep=sep,header=0,usecols=[0,1,2,3,4,5]); d.columns=['t','o','h','l','c','tv']
            d=d[~(d.t.str.endswith('00:00')&(d.tv>2000))].drop(columns='tv')
        dd.append(d)
    d=pd.concat(dd); d['t']=pd.to_datetime(d.t,format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('t').set_index('t').sort_index(); return d
def resample(d,rule):
    r=d.resample(rule).agg({'o':'first','h':'max','l':'min','c':'last'}).dropna(); return r
def barssince(c):
    i=np.arange(len(c)); last=np.maximum.accumulate(np.where(c,i,-1)); return np.where(last>=0,i-last,10**9)
def signals(o,h,l,c,L,dev):
    s=pd.Series(c); basis=s.rolling(L).mean().values; sd=s.rolling(L).std(ddof=0).values
    up=basis+dev*sd; lo=basis-dev*sd
    pc=np.roll(c,1); tr=np.maximum(h-l,np.maximum(abs(h-pc),abs(l-pc))); tr[0]=h[0]-l[0]
    atr=pd.Series(tr).ewm(alpha=1/14,adjust=False).mean().values
    w=up-lo; wma=pd.Series(w).rolling(X_EXP).mean().values
    bulge=w>=wma*1.1
    impU=(h>=up)&(c>o)&(abs(c-o)>=atr*0.2); impD=(l<=lo)&(c<o)&(abs(c-o)>=atr*0.2)
    bU=barssince(impU); bD=barssince(impD)
    bM=barssince((h>=basis)&(l<=basis)); bUt=barssince(h>=up); bLt=barssince(l<=lo)
    mU=bM<bU; mD=bM<bD; oU=bLt<bU; oD=bUt<bD
    upf=np.zeros(len(c),bool); lof=np.zeros(len(c),bool)
    upf[6:]=abs(up[6:]-up[:-6])<=atr[6:]*0.6; lof[6:]=abs(lo[6:]-lo[:-6])<=atr[6:]*0.6
    inL=bulge&(bD>=1)&(bD<=20)&~mD&~oD&(c>o)&(l<=lo)
    inS=bulge&(bU>=1)&(bU<=20)&~mU&~oU&(c<o)&(h>=up)
    poL=(bD>=1)&(bD<=40)&mD&~oD&(l<=lo)&lof&(c>o)
    poS=(bU>=1)&(bU<=40)&mU&~oU&(h>=up)&upf&(c<o)
    lg=inL|poL; sh=inS|poS
    slope=np.full(len(c),np.nan); slope[N_SLOPE:]=(basis[N_SLOPE:]-basis[:-N_SLOPE])/atr[N_SLOPE:]
    exp=w/wma
    idx=np.where((lg|sh)&~np.isnan(slope)&~np.isnan(exp)&(np.arange(len(c))<len(c)-MAXB-2))[0]
    return idx,np.where(lg[idx],1,-1),slope[idx],exp[idx],atr[idx]
def outcomes(o,h,l,c,idx,dirn,atr,cost):
    n=len(idx); r=np.zeros(n); si=np.zeros(n,bool)
    for k in range(n):
        i=idx[k]; e=o[i+1]; a=atr[k]; d=dirn[k]
        H=h[i+1:i+1+MAXB]; Lw=l[i+1:i+1+MAXB]
        if d==1: fav=np.nonzero(H>=e+TGT*a)[0]; adv=np.nonzero(Lw<=e-STP*a)[0]
        else: fav=np.nonzero(Lw<=e-TGT*a)[0]; adv=np.nonzero(H>=e+STP*a)[0]
        f=fav[0] if len(fav) else 10**9; v=adv[0] if len(adv) else 10**9
        if f<v: r[k]=TGT/STP; si[k]=True
        elif v<10**9: r[k]=-1.0
        else: r[k]=(c[i+MAXB]-e)*d/(STP*a)
        r[k]-=cost/(STP*a)
    return r,si
def filt(slope,exp,dirn,sm,st,et):
    m=np.ones(len(slope),bool)
    if sm=='ABS': m&=abs(slope)>=st
    elif sm=='WITH': m&=slope*dirn>=st
    elif sm=='AGAINST': m&=slope*dirn<=-st
    if et is not None: m&=exp>=et
    return m
FILTERS=[(sm,st,et) for sm,st in [(None,None)]+[(m,t) for m in MODES for t in SL_T] for et in (None,)+EX_T]
def main():
    prova=len(sys.argv)>1
    cells=[]
    for s,(pat,sep,cost,fmt) in SRC.items():
        d1=load_m1(pat,sep,fmt); print(s,len(d1),'barre M1',d1.index[0],d1.index[-1],flush=True)
        for tf,rule in TFS.items(): cells.append((s,tf,resample(d1,rule),cost))
        if prova: break
    if not prova:
        for s,(p,cost) in D1Y.items():
            d=pd.read_csv(p,sep=';'); d.columns=['t','o','h','l','c','v']; d['t']=pd.to_datetime(d.t); d=d.set_index('t')[['o','h','l','c']].dropna()
            cells.append((s,'D1',d,cost))
    rows=[]; t0=time.time()
    for s,tf,d,cost in cells:
        if prova and tf not in('M15','H1'): continue
        o,h,l,c=[d[k].values.astype(float) for k in 'ohlc']; n=len(c); cut=int(n*0.7)
        for (L,dev) in BB:
            idx,dirn,slope,exp,atr=signals(o,h,l,c,L,dev)
            if len(idx)<40: continue
            r,si=outcomes(o,h,l,c,idx,dirn,atr,cost); isis=idx<cut
            for (sm,st,et) in FILTERS:
                m=filt(slope,exp,dirn,sm,st,et)
                for per,pm in (('IS',isis),('OOS',~isis)):
                    x=m&pm; nn=int(x.sum()); tot=int(pm.sum())
                    rows.append(dict(sym=s,tf=tf,L=L,dev=dev,sm=sm or 'nessuno',st=st if st is not None else 0,et=et if et is not None else 0,per=per,n=nn,ntot=tot,
                        R=float(r[x].mean()) if nn else np.nan,si=float(si[x].mean()) if nn else np.nan,
                        no_rim=float(((~si)&pm&~m).sum()/max(1,((~si)&pm).sum())),si_mant=float((si&x).sum()/max(1,(si&pm).sum())),
                        atr_med=float(np.median(atr))))
        print(s,tf,'fatto',round(time.time()-t0),'s',flush=True)
    df=pd.DataFrame(rows); df.to_csv(OUT+('/prova.csv' if prova else '/risultati.csv'),index=False); print('righe',len(df))
if __name__=='__main__': main()
