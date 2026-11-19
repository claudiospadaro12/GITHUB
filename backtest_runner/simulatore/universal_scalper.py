"""Universal Scalper Pro (Pine v5, EMA 9/21 + ADX>12, SL 1.5 ATR / TP 2 ATR). Criteri: report/UNIVERSAL_SCALPER_CRITERI_2026-11-19.md"""
import csv,glob,sys
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_backtest import metrics,fmt,split,rma,ema,trange
MK={'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',0.35),'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',0.0001)}
def load(pat,minutes):
    rows={}
    for f in sorted(glob.glob(pat)):
        with open(f) as fh:
            r=csv.reader(fh,delimiter=';'); next(r)
            for t,o,h,l,c,tv,*_ in r:
                if t.endswith('00:00') and float(tv)>2000: continue
                hh=int(t[11:13]); mm=int(t[14:16]); mb=(hh*60+mm)//minutes*minutes
                k=t[:10]+' %02d:%02d'%(mb//60,mb%60); o,h,l,c=float(o),float(h),float(l),float(c)
                if k not in rows: rows[k]=[o,h,l,c]
                else:
                    x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
def dmi_adx(H,L,C,p=14):
    n=len(C); up=np.diff(H,prepend=H[0]); dn=-np.diff(L,prepend=L[0])
    pdm=np.where((up>dn)&(up>0),up,0.0); mdm=np.where((dn>up)&(dn>0),dn,0.0)
    tr=trange(H,L,C); a=rma(tr[1:],p); pd=rma(pdm[1:],p); md=rma(mdm[1:],p)
    with np.errstate(divide='ignore',invalid='ignore'):
        pdi=100*pd/a; mdi=100*md/a; dx=100*np.abs(pdi-mdi)/(pdi+mdi)
    dxf=np.nan_to_num(dx,nan=0.0); adx=rma(dxf[p-1:],p)  # approssimazione (rma sul dx)
    out=np.full(n,np.nan); out[1+p-1+p-1:1+p-1+p-1+len(adx)]=adx[:n-(1+p-1+p-1)]
    return out
def backtest(ks,O,H,L,C,cost,fast=9,slow=21,adxt=12,slm=1.5,tpm=2.0,maxb=300):
    n=len(C); ef=ema(C,fast); es=ema(C,slow); atr=rma(trange(H,L,C),14); atr_full=np.full(n,np.nan); atr_full[13:13+len(atr)]=atr[:n-13]
    adx=dmi_adx(H,L,C); tr=[]; busy=-1
    for i in range(60,n-2):
        if i<=busy or np.isnan(adx[i]) or np.isnan(atr_full[i]): continue
        d=0
        if ef[i]>es[i] and ef[i-1]<=es[i-1] and adx[i]>adxt: d=1
        elif ef[i]<es[i] and ef[i-1]>=es[i-1] and adx[i]>adxt: d=-1
        if d==0: continue
        a=atr_full[i]; sl=C[i]-d*slm*a; tp=C[i]+d*tpm*a; j=i+1; px=O[j]; risk=abs(px-sl)
        if risk<0.2*a: continue
        res=None
        for m in range(j,min(n,j+maxb)):
            if d==1:
                if L[m]<=sl: res=sl; ex=m; break
                if H[m]>=tp: res=tp; ex=m; break
            else:
                if H[m]>=sl: res=sl; ex=m; break
                if L[m]<=tp: res=tp; ex=m; break
        if res is None: ex=min(n-1,j+maxb-1); res=C[ex]
        tr.append((ks[j],d*(res-px)/risk-cost/risk)); busy=ex
    return tr
if __name__=='__main__':
    for tf in (15,60):
        for name,(pat,cost) in MK.items():
            ks,A=load(pat,tf); O,H,L,C=A.T; cut=ks[int(0.7*len(C))]; tr=backtest(ks,O,H,L,C,cost)
            a,b=split(tr,cut); r=np.array([x[1] for x in tr]); 
            print('M%d %s barre %d | TUTTO %s'%(tf,name,len(C),fmt(metrics(tr))),'\n     IS',fmt(metrics(a)),'\n     OOS',fmt(metrics(b)),flush=True)
