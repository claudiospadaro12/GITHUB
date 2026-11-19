"""Filtro di regime sull'incrocio EMA 9/21 (Universal Scalper). Criteri: report/FILTRO_REGIME_LATERALE_CRITERI_2026-11-19.md"""
import sys,random
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import SRC,load_m1,resample,prep
from tv_scout8_backtest import metrics,fmt,split
def features(r,P):
    O,H,L,C,atr,sig,ha,ks=P; c=r['close']; n=len(C)
    er=(c.diff(20).abs()/c.diff().abs().rolling(20).sum()).values
    es=c.ewm(span=21,adjust=False).mean(); slope=((es-es.shift(10)).abs()/pd.Series(atr,index=r.index)).values
    atrr=(pd.Series(atr,index=r.index)/pd.Series(atr,index=r.index).rolling(100).mean()).values
    up=r['high'].diff(); dn=-r['low'].diff(); pc=c.shift(1)
    tr=pd.concat([r['high']-r['low'],(r['high']-pc).abs(),(r['low']-pc).abs()],axis=1).max(axis=1)
    a14=tr.ewm(alpha=1/14,adjust=False).mean()
    pdm=np.where((up>dn)&(up>0),up,0.0); mdm=np.where((dn>up)&(dn>0),dn,0.0)
    pdi=100*pd.Series(pdm,index=r.index).ewm(alpha=1/14,adjust=False).mean()/a14; mdi=100*pd.Series(mdm,index=r.index).ewm(alpha=1/14,adjust=False).mean()/a14
    adx=(100*(pdi-mdi).abs()/(pdi+mdi).clip(lower=1e-12)).ewm(alpha=1/14,adjust=False).mean().values
    return {'ER20':er,'ADX':adx,'PENDENZA':slope,'ATRREL':atrr}
def sim(P,cost,mode,ok):
    O,H,L,C,atr,sig,ha,ks=P; n=len(C); tr=[]
    if mode=='A':
        busy=-1
        for i in range(120,n-2):
            d=sig[i]
            if d==0 or i<=busy or not ok[i]: continue
            a=atr[i]; sl=C[i]-d*1.5*a; tp=C[i]+d*2.0*a; j=i+1; px=O[j]; risk=abs(px-sl)
            if risk<0.2*a: continue
            res=None
            for m in range(j,min(n,j+300)):
                if d==1:
                    if L[m]<=sl: res=sl; ex=m; break
                    if H[m]>=tp: res=tp; ex=m; break
                else:
                    if H[m]>=sl: res=sl; ex=m; break
                    if L[m]<=tp: res=tp; ex=m; break
            if res is None: ex=min(n-1,j+299); res=C[ex]
            tr.append((ks[j],d*(res-px)/risk-cost/risk,i)); busy=ex
        return tr
    pos=0; ent=0.0; sl=0.0; risk=1.0; t0=''; pend=None; si=0
    for i in range(120,n-1):
        if pend is not None:
            kind,d,a,sidx=pend; pend=None
            if pos!=0: tr.append((t0,pos*(O[i]-ent)/risk-cost/risk,si)); pos=0
            if kind=='open' or (kind=='rev' and ok[sidx]):
                pos=d; ent=O[i]; risk=1.5*a; sl=ent-d*risk; t0=ks[i]; si=sidx
        if pos!=0:
            if (pos==1 and L[i]<=sl) or (pos==-1 and H[i]>=sl):
                px=min(O[i],sl) if pos==1 else max(O[i],sl)
                tr.append((t0,pos*(px-ent)/risk-cost/risk,si)); pos=0
        if pos!=0:
            if sig[i]==-pos: pend=('rev',sig[i],atr[i],i)
        else:
            if sig[i]!=0 and ok[i]: pend=('open',sig[i],atr[i],i)
    return tr
def pfm(tr): 
    m=metrics(tr); return m['pf']
random.seed(11)
if __name__=='__main__':
    allres=[]; diag=[]
    for name,(pats,sep,cost) in SRC.items():
        d=load_m1(pats,sep)
        for tfn,rule in (('M15','15min'),('H1','1h')):
            r=resample(d,rule); P=prep(r); F=features(r,P); ks=P[7]; n=len(ks); cut=ks[int(0.7*n)]; sig=P[5]
            sigidx=[i for i in range(120,n) if sig[i]!=0]; isidx=[i for i in sigidx if ks[i]<cut]
            for mode in ('B2','A'):
                base=sim(P,cost,mode,np.ones(n,bool)); bI,bO=split(base,cut)
                if mode=='B2':  # diagnosi: mediane per esito (tutti i trade)
                    for k,f in F.items():
                        L_=[f[x[2]] for x in base if x[1]<-0.5 and not np.isnan(f[x[2]])]; S_=[f[x[2]] for x in base if abs(x[1])<=0.3 and not np.isnan(f[x[2]])]; W_=[f[x[2]] for x in base if x[1]>0.3 and not np.isnan(f[x[2]])]
                        diag.append((name,tfn,k,len(L_),np.median(L_),len(S_),np.median(S_),len(W_),np.median(W_)))
                for k,f in F.items():
                    thr=np.nanmedian([f[i] for i in isidx]); ok=np.array([(not np.isnan(f[i])) and f[i]>thr for i in range(n)])
                    fl=sim(P,cost,mode,ok); fI,fO=split(fl,cut)
                    # placebo OOS: meta' casuale dei segnali non filtrati
                    sigO=[i for i in sigidx if ks[i]>=cut]; cnt=0; nn=150
                    for _ in range(nn):
                        s=set(random.sample(sigO,len(sigO)//2)); okr=np.array([i in s for i in range(n)]); rl=sim(P,cost,mode,okr); _,rO=split(rl,cut)
                        if pfm(rO)>=pfm(fO): cnt+=1
                    allres.append((name,tfn,mode,k,metrics(bI),metrics(bO),metrics(fI),metrics(fO),(cnt+1)/(nn+1)))
            print(name,tfn,'fatto',flush=True)
    print('--- DIAGNOSI (mediana dell indicatore al segnale: perdenti R<-0.5 | piccoli |R|<=0.3 | vincenti R>0.3), uscita B2 ---')
    for k in ('ER20','ADX','PENDENZA','ATRREL'):
        sub=[x for x in diag if x[2]==k]; 
        print(k,'perdenti %.3f | piccoli %.3f | vincenti %.3f  (medie delle mediane su %d serie)'%(np.mean([x[4] for x in sub]),np.mean([x[6] for x in sub]),np.mean([x[8] for x in sub]),len(sub)))
        print('   vincenti > perdenti in %d serie su %d'%(sum(1 for x in sub if x[8]>x[4]),len(sub)))
    print('--- FILTRO (sopra la mediana IS): OOS PF non filtrato -> filtrato (n), p-caso ---')
    aiuta=[]
    for x in allres:
        nm,tf,mo,k,bI,bO,fI,fO,p=x
        flag= (fO['pf']>=bO['pf']+0.10 and fO['n']>=100 and fO['pf']>1.0 and p<0.05)
        if flag: aiuta.append((nm,tf,mo,k))
        print('%-7s %-3s %-2s %-8s IS %.2f->%.2f (n %d->%d) | OOS %.2f->%.2f (n %d->%d) p=%.2f %s'%(nm,tf,mo,k,bI['pf'],fI['pf'],bI['n'],fI['n'],bO['pf'],fO['pf'],bO['n'],fO['n'],p,'<<AIUTA' if flag else ''))
    print('combinazioni che passano la porta di aiuto:',aiuta)
    mig=[x for x in allres if x[7]['pf']-x[5]['pf']>0.0]; print('filtro migliora il PF OOS in %d test su %d; in IS in %d su %d'%(len(mig),len(allres),sum(1 for x in allres if x[6]['pf']>x[4]['pf']),len(allres)))
    val=[(x[0],x[1],x[2],x[3]) for x in allres if x[6]['pf']>=1.5 and x[6]['dd']<=15 and x[6]['n']>=100 and x[7]['pf']>1.2 and x[7]['n']>=30]
    print('VALIDATE (porte di Claudio):',val)
