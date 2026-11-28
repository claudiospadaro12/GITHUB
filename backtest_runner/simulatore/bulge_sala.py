import sys,os,glob,itertools,warnings;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd
SPR={'EURUSD':0.8,'USDJPY':1.0,'GBPUSD':1.2,'AUDUSD':1.2,'EURGBP':1.5,'USDCAD':1.5,'USDCHF':1.5,'NZDUSD':1.8,'EURJPY':1.8,'GBPJPY':2.8}
def load():
    out={}
    for s in SPR:
        d=pd.read_csv('/tmp/claude-0/fxh1/ABTG_H1_%s.csv'%s,sep=';'); d['t']=pd.to_datetime(d['date'],format='%Y.%m.%d %H:%M'); d=d.set_index('t')[['open','high','low','close']]
        out[s]=d[(d.index>='2005-01-01')&(d.index<'2026-11-24')&(d.high>d.low)]
    return out
def prep(d):
    O,H,L,C=[d[k].values for k in ('open','high','low','close')]; n=len(C); s=pd.Series(C)
    basis=s.rolling(20).mean().values; dev=2*s.rolling(20).std(ddof=0).values; up=basis+dev; lo=basis-dev; w=up-lo; avgw=pd.Series(w).rolling(20).mean().values; bul=w>avgw*1.12
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum(H-L,np.maximum(abs(H-pc),abs(L-pc))); atr=pd.Series(tr).rolling(14).mean().values
    sig=np.zeros(n,int)
    for t in range(41,n-2):
        if bul[t-1] and C[t-1]<lo[t-1] and C[t]>lo[t] and C[t]<basis[t]: sig[t]=1
        elif bul[t-1] and C[t-1]>up[t-1] and C[t]<up[t] and C[t]>basis[t]: sig[t]=-1
    return O,H,L,C,basis,atr,sig,w/np.where(atr>0,atr,np.nan)
def sim(P,t,d,slm,tp,be,trail,T=40):
    O,H,L,C,basis,atr,sig,wa=P; ent=O[t+1]; a=atr[t]
    sl=(L[t]-slm*a) if d==1 else (H[t]+slm*a)
    if tp=='rev': sl=ent-d*slm*a
    risk=abs(ent-sl)
    if risk<=0 or np.isnan(risk): return None
    tpf=None if tp in ('med',) else ent+d*tp*risk
    stop=sl; be_on=False; ex=None; j=t+1; hi=ent; lo_=ent
    for j in range(t+1,min(t+1+T,len(C))):
        tpx=tpf if tpf is not None else (basis[j-1] if j>t+1 else basis[t])
        if d==1:
            if L[j]<=stop: ex=min(O[j],stop); break
            if H[j]>=tpx and tpx>ent: ex=max(O[j],tpx) if O[j]>tpx else tpx; break
            hi=max(hi,H[j])
            if be and not be_on and hi>=ent+be*a: be_on=True; stop=max(stop,ent)
            if trail and be_on: stop=max(stop,hi-trail*a)
        else:
            if H[j]>=stop: ex=max(O[j],stop); break
            if L[j]<=tpx and tpx<ent: ex=min(O[j],tpx) if O[j]<tpx else tpx; break
            lo_=min(lo_,L[j])
            if be and not be_on and lo_<=ent-be*a: be_on=True; stop=min(stop,ent)
            if trail and be_on: stop=min(stop,lo_+trail*a)
    if ex is None: ex=C[j]
    return d*(ex-ent)/risk
def run(data,cfg,rev=False,keep=None):
    rows=[]
    for s,(P,idx) in data.items():
        pip=0.01 if 'JPY' in s else 0.0001; sig=P[6]
        for t in np.nonzero(sig)[0]:
            if keep is not None and not keep(s,t,P,idx): continue
            d=-sig[t] if rev else sig[t]
            slm,tp,be,tr=cfg; r=sim(P,t,d,slm,tp,be,tr)
            if r is None: continue
            ent=P[0][t+1]; risk=abs(ent-((P[1+0*0][t]) if False else 0)) 
            a=P[5][t]; sl=(P[2][t]-slm*a) if d==1 else (P[1][t]+slm*a)
            if rev: sl=ent-d*slm*a
            risk=abs(ent-sl); cA=(SPR[s]+0.2)*pip/risk; cB=2*0.0002*ent/risk
            rows.append((idx[t+1],s,r,cA,cB,idx[t+1].hour,P[7][t]))
    return pd.DataFrame(rows,columns=['t','s','R','cA','cB','h','wa'])
def pf(x):
    w=x[x>0].sum(); l=-x[x<0].sum(); return w/l if l>0 else np.nan
def rep(df,mod):
    c='cA' if mod=='A' else 'cB'; n=df.R-df[c]; is_=df.t.dt.year<=2015; ya=n.groupby(df.t.dt.year).sum()
    x2=df.R-2*df[c]
    return len(df),pf(n[is_]),pf(n[~is_]),(ya>0).mean(),pf(x2)
if __name__=='__main__':
    raw=load(); data={}
    for s,d in raw.items():
        P=prep(d); data[s]=(P,d.index)
    nsig=sum(int(abs(P[6]).sum()) for P,_ in data.values()); print('segnali grezzi totali:',nsig)
    cfgs=[(sl,tp,be,tr) for sl in (1.5,3.0) for tp in ('med',1.0,1.5) for be,tr in ((0,0),(1.0,0),(1.0,2.0))]
    res=[]
    for cfg in cfgs:
        df=run(data,cfg)
        a=rep(df,'A'); b=rep(df,'B'); res.append((cfg,a,b)); print('USCITE',cfg,'n=%d | A: IS %.2f OOS %.2f anni+ %.0f%% x2 %.2f | B: IS %.2f OOS %.2f'%(a[0],a[1],a[2],100*a[3],a[4],b[1],b[2]),flush=True)
    for slm in (1.5,3.0):
        for tp in (1.0,1.5):
            df=run(data,(slm,tp,0,0),rev=True); a=rep(df,'A'); b=rep(df,'B'); print('REVERSE',(slm,tp),'n=%d | A: IS %.2f OOS %.2f anni+ %.0f%% | B: IS %.2f OOS %.2f'%(a[0],a[1],a[2],100*a[3],b[1],b[2]),flush=True)
    best=max(res,key=lambda r:r[1][1]); print('MIGLIORE su IS (modello A):',best[0],best[1])
    cfg=best[0]; df=run(data,cfg)
    thr=df[df.t.dt.year<=2015].wa.quantile(0.9)
    for nome,keep in (('senza ore 22-23',lambda s,t,P,idx:idx[t+1].hour not in (22,23)),('senza decile largo',lambda s,t,P,idx:P[7][t]<=thr)):
        d2=run(data,cfg,keep=keep); a=rep(d2,'A'); print('FILTRO',nome,'ritenzione %.0f%% | A: IS %.2f OOS %.2f'%(100*len(d2)/len(df),a[1],a[2]))
