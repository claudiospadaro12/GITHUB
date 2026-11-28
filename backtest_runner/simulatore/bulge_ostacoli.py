import sys,warnings;warnings.filterwarnings('ignore')
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np,pandas as pd,bulge_sala as b
def supertrend(H,L,C,atr,per=10,mult=3.0):
    n=len(C); hl2=(H+L)/2; ub=hl2+mult*atr; lb=hl2-mult*atr; st=np.full(n,np.nan); dr=1
    fub=ub.copy(); flb=lb.copy(); i0=int(np.argmax(~np.isnan(atr)))
    for i in range(i0+1,n):
        fub[i]=ub[i] if (ub[i]<fub[i-1] or C[i-1]>fub[i-1]) else fub[i-1]
        flb[i]=lb[i] if (lb[i]>flb[i-1] or C[i-1]<flb[i-1]) else flb[i-1]
        if dr==1 and C[i]<flb[i]: dr=-1
        elif dr==-1 and C[i]>fub[i]: dr=1
        st[i]=flb[i] if dr==1 else fub[i]
    return st
def levels(d):
    O,H,L,C=[d[k].values for k in ('open','high','low','close')]; s=pd.Series(C); idx=d.index
    pc=np.r_[C[0],C[:-1]]; tr=np.maximum(H-L,np.maximum(abs(H-pc),abs(L-pc))); atr10=pd.Series(tr).rolling(10).mean().values
    lv={}
    for p in (50,100,200): lv['ema%d'%p]=s.ewm(span=p,adjust=False).mean().values
    lv['st']=supertrend(H,L,C,atr10)
    lv['sw20h']=pd.Series(H).rolling(20).max().shift(1).values; lv['sw20l']=pd.Series(L).rolling(20).min().shift(1).values
    lv['sw50h']=pd.Series(H).rolling(50).max().shift(1).values; lv['sw50l']=pd.Series(L).rolling(50).min().shift(1).values
    day=idx.normalize(); df=pd.DataFrame({'h':H,'l':L,'o':O,'day':day,'hr':idx.hour},index=idx)
    g=df.groupby('day'); dh=g.h.max(); dl=g.l.min(); do=g.o.first()
    days=dh.index; pdh=dh.shift(1); pdl=dl.shift(1)
    lv['pdh']=df.day.map(pdh).values; lv['pdl']=df.day.map(pdl).values; lv['dopen']=df.day.map(do).values
    wk=idx.to_period('W').start_time; wh=df.groupby(wk).h.max(); wl=df.groupby(wk).l.min(); pwh=wh.shift(1); pwl=wl.shift(1)
    lv['pwh']=pd.Series(wk,index=idx).map(pwh).values; lv['pwl']=pd.Series(wk,index=idx).map(pwl).values
    # notte: 22:00-07:59 -> chiave = data della mattina; ultima notte COMPLETATA al momento t
    nk=np.where(df.hr>=22,(df.day+pd.Timedelta(days=1)).values,df.day.values); nk=pd.to_datetime(nk)
    mask=(df.hr>=22)|(df.hr<8); nd=df[mask].groupby(nk[mask]); nh=nd.h.max(); nl=nd.l.min()
    # per t: notte completata piu recente = chiave <= day di t se hr>=8, altrimenti chiave < day di t
    cur=pd.Series(np.where(df.hr>=8,df.day.values,(df.day-pd.Timedelta(days=1)).values),index=idx); cur=pd.to_datetime(cur)
    lv['nh']=cur.map(nh).values; lv['nl']=cur.map(nl).values
    return lv,atr10
TIPI={'media':['ema50','ema100','ema200'],'supertrend':['st'],'swing':['sw20h','sw20l','sw50h','sw50l'],'giorno_prec':['pdh','pdl','dopen'],'notte':['nh','nl'],'settimana_prec':['pwh','pwl']}
def count(entry,target,lv,t,pip,types):
    lo,hi=min(entry,target),max(entry,target); res={k:0 for k in TIPI}
    for k,names in TIPI.items():
        for nme in names:
            v=lv[nme][t]
            if not np.isnan(v) and lo<v<hi: res[k]+=1
    step=50*pip; r=0; x=np.floor(lo/step)*step+step
    while x<hi: r+=1; x+=step
    res['tondo']=r; return res
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
if __name__=='__main__':
    raw=b.load(); rows=[]; vol=[]
    for s,d in raw.items():
        P=b.prep(d); O,H,L,C,basis,atr,sig,wa=P; idx=d.index; lv,_=levels(d); pip=0.01 if 'JPY' in s else 0.0001
        dr=pd.DataFrame({'h':H,'l':L},index=idx).groupby(idx.normalize()).agg(h=('h','max'),l=('l','min')); adr20=(dr.h-dr.l).rolling(20).mean().shift(1); adr250=(dr.h-dr.l).rolling(250).mean().shift(1)
        dh=pd.Series(H,index=idx).groupby(idx.normalize()).cummax(); dl=pd.Series(L,index=idx).groupby(idx.normalize()).cummin()
        for t in np.nonzero(sig)[0]:
            d_=sig[t]; r=b.sim(P,t,d_,3.0,'med',0,0)
            if r is None: continue
            ent=O[t+1]; a=atr[t]; sl=(L[t]-3*a) if d_==1 else (H[t]+3*a); risk=abs(ent-sl); cost=(b.SPR[s]+0.2)*pip/risk
            tgt=basis[t]; c=count(ent,tgt,lv,t,pip,TIPI); day=idx[t].normalize()
            used=(dh.iloc[t]-dl.iloc[t])/adr20.get(day,np.nan) if adr20.get(day,np.nan)>0 else np.nan
            reg=adr20.get(day,np.nan)/adr250.get(day,np.nan) if adr250.get(day,np.nan)>0 else np.nan
            row=dict(s=s,t=idx[t+1],R=r,net=r-cost,**c,used=used,reg=reg); rows.append(row)
    df=pd.DataFrame(rows); df['nob']=df[list(TIPI)+['tondo']].sum(axis=1); df['y']=df.t.dt.year; df.to_pickle('/tmp/work/bulge_ostacoli.pkl'); print('segnali',len(df))
    def blk(m,nome):
        a=df[m&(df.y<=2015)].net; o=df[m&(df.y>=2016)].net; print('  %-34s n=%5d (%4.0f%%) IS %.2f OOS %.2f | win %.0f%%'%(nome,m.sum(),100*m.mean(),pf(a),pf(o),100*(df[m].net>0).mean()))
    print('--- per numero di ostacoli (tutti i tipi)')
    for k in (0,1,2,3): blk((df.nob==k) if k<3 else (df.nob>=3),'ostacoli %s'%(k if k<3 else '3+'))
    print('--- per tipo: presente / assente')
    for k in list(TIPI)+['tondo']:
        blk(df[k]>0,k+' PRESENTE'); blk(df[k]==0,k+' assente')
    df['strutt']=df['supertrend']+df['giorno_prec']+df['notte']+df['settimana_prec']
    print('--- livelli STRUTTURALI (Supertrend + giorno prec. + notte + settimana prec., senza medie/tondi/swing)')
    for k in (0,1,2): blk((df.strutt==k) if k<2 else (df.strutt>=2),'strutturali %s'%(k if k<2 else '2+'))
    print('--- volatilita: quota ADR20 gia consumata')
    q=df.used.quantile([1/3,2/3]).values
    blk(df.used<=q[0],'consumata bassa'); blk((df.used>q[0])&(df.used<=q[1]),'consumata media'); blk(df.used>q[1],'consumata alta (%.2f)'%q[1])
    print('--- regime ADR20/ADR250'); q=df.reg.quantile([1/3,2/3]).values
    blk(df.reg<=q[0],'regime calmo'); blk((df.reg>q[0])&(df.reg<=q[1]),'regime medio'); blk(df.reg>q[1],'regime volatile')
    # controllo del caso: etichette casuali sul gruppo libero
    free=(df.strutt==0); real=pf(df[free&(df.y<=2015)].net)-pf(df[~free&(df.y<=2015)].net); rng=np.random.default_rng(20261128); nul=[]
    for _ in range(200):
        m=rng.random(len(df))<free.mean(); nul.append(pf(df[m&(df.y<=2015)].net)-pf(df[~m&(df.y<=2015)].net))
    print('differenza PF IS libero - ostacolato: reale %.2f | casuale p95 %.2f'%(real,np.percentile(nul,95)))
