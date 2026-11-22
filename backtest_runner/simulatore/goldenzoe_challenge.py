import sys,os,datetime as dt
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r); idx4=r.index; n=len(C)
e55=np.where(entries_breakout(C,H,L,55)==1,1,0)
D_START=pd.Timestamp('2014-12-01')
m=d.loc[d.index>=D_START]; mi=m.index.values; lo=m['low'].values; cl=m['close'].values; op=m['open'].values
mday=mi.astype('datetime64[D]')
SW=0.055/360.0
trades={}   # i_signal -> dict
def build(i):
    ent=O[i+1]; risk=3*atr[i]
    if risk<=0 or np.isnan(atr[i]): return None
    stop=ent-risk; ext=ent; start=i+1; j=None; px=None
    for k in range(start,n):
        if L[k]<=stop: px=min(O[k],stop); j=k; break
        ext=max(ext,H[k]); stop=max(stop,ext-3*atr[k])
    if j is None: return None
    ts=idx4[start]; te=idx4[j]
    if ts<D_START: return None
    a=np.searchsorted(mi,np.datetime64(ts)); b=np.searchsorted(mi,np.datetime64(te)); end=min(b+240,len(m)); k=b
    while k<end and lo[k]>px+1e-9 and not (op[k]<=px): k+=1
    k=min(k,len(m)-1)
    if k<=a: return None
    dd_=(mi[a:k+1]-mi[a]).astype('timedelta64[s]').astype(float)/86400.0
    swap=ent*SW*dd_
    fl_lo=(lo[a:k+1]-ent)-0.35-swap; fl_cl=(cl[a:k+1]-ent)-0.35-swap
    freal=(px-ent)-0.35-swap[-1]; fl_lo[-1]=freal; fl_cl[-1]=freal
    days=mday[a:k+1]; ud,first=np.unique(days,return_index=True)
    rows=[]
    for q,u in enumerate(ud):
        s=first[q]; e_=(first[q+1] if q+1<len(ud) else len(days))
        rows.append((u,fl_lo[s:e_].min(),fl_cl[e_-1]))
    return dict(i=i,j=j,risk=risk,rows=rows,freal=freal,tentry=pd.Timestamp(ts),texit=pd.Timestamp(mi[k]))
sigs=[i for i in range(120,n-1) if e55[i]==1 and idx4[i+1]>=D_START]
for i in sigs:
    t=build(i)
    if t: trades[i]=t
sig_arr=np.array(sorted(trades))
print('segnali',len(sig_arr),flush=True)
def nextsig(minidx):
    p=np.searchsorted(sig_arr,minidx); return sig_arr[p] if p<len(sig_arr) else None
B0=80000.0
def run(start,risk,target):
    B=B0; i=nextsig(0)
    # primo segnale con ingresso >= start
    ts_arr=[trades[k]['tentry'] for k in sig_arr]
    p=0
    while p<len(sig_arr) and trades[sig_arr[p]]['tentry']<start: p+=1
    while p<len(sig_arr):
        t=trades[sig_arr[p]]; oz=B*risk/100.0/t['risk']; eq_prev=B
        for (u,fmin,fend) in t['rows']:
            emin=B+oz*fmin
            if (eq_prev-emin)/B0>=0.05: return ('daily',pd.Timestamp(u))
            if emin<=B0*0.90: return ('total',pd.Timestamp(u))
            eq_prev=B+oz*fend
        B+=oz*t['freal']
        if B>=B0*(1+target): return ('pass',t['texit'])
        # prossimo segnale con indice >= j
        jn=t['j']; q=np.searchsorted(sig_arr,jn)
        p=q
    return ('open',None)
T_END=idx4[-1]
res_all={}
for label,w0 in (('dal 2015',pd.Timestamp('2015-01-01')),('ultimi 4 anni',pd.Timestamp('2022-11-22'))):
    starts=pd.date_range(w0,T_END-pd.Timedelta(days=120),freq='7D')
    for target in (0.10,0.05):
        for risk in (0.5,0.9,1.0,1.3):
            out=[run(s,risk,target) for s in starts]
            tot_n=len(out); pas=[(o[1]-s).days for o,s in zip(out,starts) if o[0]=='pass']
            fails=sum(1 for o in out if o[0] in ('daily','total'))
            line=[]
            for H in (180,365,545,730):
                ok=[(o,s) for o,s in zip(out,starts) if (T_END-s).days>=H]
                if not ok: line.append('-'); continue
                pp=sum(1 for o,s in ok if o[0]=='pass' and (o[1]-s).days<=H); ff=sum(1 for o,s in ok if o[0] in ('daily','total') and (o[1]-s).days<=H)
                line.append('%d%%/%d%%'%(round(100*pp/len(ok)),round(100*ff/len(ok))))
            print(label,'obiettivo %d%%'%(target*100),'rischio',risk,'| partenze',tot_n,'| entro 6/12/18/24 mesi passata/fallita:',' '.join(line),'| fallite totali',fails,'| mediana giorni (solo passate)',int(np.median(pas)) if pas else -1,flush=True)
