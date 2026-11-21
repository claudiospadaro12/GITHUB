# Criteri: report/BARTIROMO_REGOLE_CRITERI_2026-11-21.md
import sys; sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import numpy as np, pandas as pd
from tv_concetti import SRC,load,stats
COST=0.35
pat,sep,_,fmt=SRC['XAUUSD']; d1=load(pat,sep,fmt)
d1.index=d1.index-pd.Timedelta(hours=1)   # ora italiana
d1=d1[~d1.index.duplicated()].sort_index()
T=d1.index.values; O=d1.o.values.astype(float); H=d1.h.values.astype(float); L=d1.l.values.astype(float); C=d1.c.values.astype(float)
def ix(ts): return int(np.searchsorted(T,np.datetime64(ts)))
days=pd.DatetimeIndex(sorted(set(d1.index.normalize())))
days=days[days.dayofweek<5]
dr=d1.resample('1D').agg({'h':'max','l':'min'}).dropna(); adr=(dr.h-dr.l).rolling(14).mean().shift(1)
def walk(i0,e,stop,tp,d,i_end):
    # da barra i0 (inclusa) a i_end; ritorna R netto
    risk=abs(e-stop)
    for j in range(i0,min(i_end,len(C))):
        if d==1:
            if L[j]<=stop: return (stop-e-COST)/risk
            if tp is not None and H[j]>=tp: return (tp-e-COST)/risk
        else:
            if H[j]>=stop: return (e-stop-COST)/risk
            if tp is not None and L[j]<=tp: return (e-tp-COST)/risk
    j=min(i_end,len(C))-1; return (d*(C[j]-e)-COST)/risk
def m5(i0,i1):
    # barre M5 sull'intervallo [i0,i1) -> lista (start_idx,end_idx,o,h,l,c)
    out=[]; k=i0
    t0=T[i0].astype('datetime64[m]').astype(np.int64)
    while k<i1:
        base=(T[k].astype('datetime64[m]').astype(np.int64)//5)*5; j=k
        while j<i1 and (T[j].astype('datetime64[m]').astype(np.int64)//5)*5==base: j+=1
        out.append((k,j,O[k],H[k:j].max(),L[k:j].min(),C[j-1])); k=j
    return out
rows=[]; cnt={'sweep':0,'break':0,'nessuno':0}
for day in days:
    a=adr.get(day,np.nan)
    if not a>0: continue
    ia,ib=ix(day),ix(day+pd.Timedelta(hours=8))
    if ib-ia<300: continue
    AH,AL=H[ia:ib].max(),L[ia:ib].min(); w=AH-AL
    # ---- Regola 1
    if w>=0.15*a:
        i_end=ix(day+pd.Timedelta(hours=17,minutes=30)); i11=ix(day+pd.Timedelta(hours=12))
        sig=None
        for (s,e_,o,h,l,c) in m5(ib,i11):
            ex_h=h>AH; ex_l=l<AL
            if not(ex_h or ex_l): continue
            if ex_h and ex_l: break
            inside=(AL<=c<=AH)
            if inside: sig=('sweep',s,e_,h,l,c,-1 if ex_h else 1)
            else: sig=('break',s,e_,h,l,c,1 if ex_h else -1)
            break
        if sig is None: cnt['nessuno']+=1
        else:
            kind,s,e_,h,l,c,d=sig; cnt[kind]+=1; en=C[e_-1]
            if kind=='sweep':
                stop=(h if d==-1 else l); 
                if abs(en-stop)<0.2*a: stop=en-d*0.2*a
                risk=abs(en-stop)
                for nm,tp in (('SWEEP_1R',en+d*risk),('SWEEP_2R',en+d*2*risk),('SWEEP_OPP',(AL if d==-1 else AH))):
                    rows.append((nm,day,d,walk(e_,en,stop,tp,d,i_end)))
            else:
                stop=(AH+AL)/2
                if abs(en-stop)<0.2*a: stop=en-d*0.2*a
                risk=abs(en-stop)
                for nm,tp in (('BREAK_1R',en+d*risk),('BREAK_2R',en+d*2*risk)):
                    rows.append((nm,day,d,walk(e_,en,stop,tp,d,i_end)))
    # ---- Regola 2
    pd_=day-pd.Timedelta(days=1)
    while pd_.dayofweek>=5: pd_-=pd.Timedelta(days=1)
    ip0,ip1=ix(pd_),ix(pd_+pd.Timedelta(days=1))
    if ip1-ip0<300: continue
    PH,PL=H[ip0:ip1].max(),L[ip0:ip1].min(); done=False; i_end=ix(day+pd.Timedelta(hours=20))
    for hh in (13,14,15):
        if done: break
        s,e_=ix(day+pd.Timedelta(hours=hh)),ix(day+pd.Timedelta(hours=hh+1))
        ps,pe=ix(day+pd.Timedelta(hours=hh-1)),s
        if e_-s<30 or pe-ps<30: continue
        bo,bh,bl,bc=O[s],H[s:e_].max(),L[s:e_].min(),C[e_-1]; rg=bh-bl
        po,pc=O[ps],C[pe-1]; pmax,pmin=max(po,pc),min(po,pc)
        lon0=ix(day+pd.Timedelta(hours=8)); lh=H[lon0:s].max() if s-lon0>30 else -1e9; ll=L[lon0:s].min() if s-lon0>30 else 1e9
        highs=[PH,AH,lh]; lows=[PL,AL,ll]
        if rg<=0: continue
        doji=abs(bc-bo)<=0.2*rg
        sd=0
        if bh>min(x for x in highs if x>-1e8) and any((bh>x and bc<x) for x in highs if x>-1e8) and bc<bo or (doji and any((bh>x and bc<x) for x in highs if x>-1e8)):
            sd=-1
        elif any((bl<x and bc>x) for x in lows if x<1e8) and (bc>bo or doji):
            sd=1
        if sd==0: continue
        eng=(sd==-1 and bo>=pmax and bc<pmin) or (sd==1 and bo<=pmin and bc>pmax)
        if not(eng or doji): continue
        if doji: en=bc; i0=e_
        else:
            lim=bc-sd*0.25*rg; i0=None
            for j in range(e_,min(e_+60,len(C))):
                if (sd==-1 and H[j]>=lim) or (sd==1 and L[j]<=lim): i0=j; break
            if i0 is None: continue
            en=lim
        stop=(bh+0.27*rg) if sd==-1 else (bl-0.27*rg); risk=abs(en-stop)
        if risk<0.1*a: continue
        done=True
        for nm,m in (('H1_1R',1.0),('H1_15R',1.5),('H1_2R',2.0)):
            rows.append((nm,day,sd,walk(i0,en,stop,en+sd*m*risk,sd,i_end)))
        rows.append(('H1_tipo_'+('doji' if doji else 'eng'),day,sd,walk(i0,en,stop,en+sd*1.0*risk,sd,i_end)))
print('giorni R1:',cnt)
df=pd.DataFrame(rows,columns=['cella','day','d','R']); cut=days[int(len(days)*.7)]
print('taglio IS/OOS:',cut.date())
for nm,g in df.groupby('cella'):
    a=g[g.day<cut]; b=g[g.day>=cut]
    wr=lambda x:f"{(x.R>0).mean()*100:.0f}%" if len(x) else '-'
    yr=g.groupby(g.day.dt.year).R.mean(); 
    print(f"{nm:11s} IS {stats(a.R)} wr {wr(a)} | OOS {stats(b.R)} wr {wr(b)} | anni R>=0: {(yr>=0).sum()}/{len(yr)}")
    for sd,sn in ((1,'long'),(-1,'short')): print(f"      {sn} IS {stats(a[a.d==sd].R)[:32]} | OOS {stats(b[b.d==sd].R)[:32]}")
