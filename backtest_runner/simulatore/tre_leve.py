"""Tre leve: movimento/costo, TF alti, trend following con Chandelier. Criteri: report/TRE_LEVE_CRITERI_2026-11-19.md"""
import sys
import numpy as np,pandas as pd
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import SRC,load_m1,resample,prep
from universal_scalper_regime import sim
from tv_scout8_backtest import metrics,fmt,split
def trail(O,H,L,C,atr,ks,cost,entries,m=3.0):
    """entries: array int (0,+1,-1) alla chiusura della barra i; ingresso all'apertura i+1; stop iniziale m ATR; stop mobile chandelier"""
    n=len(C); tr=[]; pos=0
    for i in range(120,n-1):
        if pos==0:
            d=entries[i]
            if d==0 or np.isnan(atr[i]): continue
            pos=d; ent=O[i+1]; risk=m*atr[i]; stop=ent-d*risk; ext=ent; t0=ks[i+1]; start=i+1
            if risk<=0: pos=0; continue
        if pos!=0:
            j=i+1 if i+1>start else start
            # barra j gia' in posizione: controlla stop/aggiorna estremo
            pass
        # gestione barre successive all'ingresso
        if pos!=0 and i>=start:
            # barra i (>= start): controlla stop intrabarra
            hit=(pos==1 and L[i]<=stop) or (pos==-1 and H[i]>=stop)
            if hit:
                px=min(O[i],stop) if pos==1 else max(O[i],stop)
                tr.append((t0,pos*(px-ent)/risk-cost/risk)); pos=0; continue
            ext=max(ext,H[i]) if pos==1 else min(ext,L[i])
            a=atr[i]
            stop=max(stop,ext-m*a) if pos==1 else min(stop,ext+m*a)
    return tr
def entries_breakout(C,H,L,N):
    n=len(C); e=np.zeros(n,dtype=int)
    hh=pd.Series(H).rolling(N).max().shift(1).values; ll=pd.Series(L).rolling(N).min().shift(1).values
    for i in range(N+1,n):
        if C[i]>hh[i]: e[i]=1
        elif C[i]<ll[i]: e[i]=-1
    return e
def line(tr,cut):
    a,b=split(tr,cut); ma=metrics(a); mb=metrics(b)
    return ma,mb
def fmt2(ma,mb): return 'IS n=%d PF %.2f R %+.3f DD %.0f%% | OOS n=%d PF %.2f R %+.3f'%(ma['n'],ma['pf'],ma['R'],ma['dd'],mb['n'],mb['pf'],mb['R'])
if __name__=='__main__':
    res=[]
    for name,(pats,sep,cost) in SRC.items():
        d=load_m1(pats,sep); print('=====',name,flush=True)
        # leva 1: M15,M30,H1
        for tfn,rule in (('M15','15min'),('M30','30min'),('H1','1h')):
            r=resample(d,rule); P=prep(r); ks=P[7]; n=len(ks); cut=ks[int(0.7*n)]; atr=P[4]
            base=sim(P,cost,'B2',np.ones(n,bool)); bI,bO=line(base,cut)
            for thr in (0.10,0.06,0.04):
                ok=np.array([(not np.isnan(atr[i])) and atr[i]>0 and cost/(1.5*atr[i])<=thr for i in range(n)])
                ma,mb=line(sim(P,cost,'B2',ok),cut); res.append(('L1',name,tfn,'costo<=%.2f'%thr,ma,mb))
                print('L1 %s costo<=%.2f: %s   (base %s)'%(tfn,thr,fmt2(ma,mb),'IS PF %.2f n %d | OOS PF %.2f'%(bI['pf'],bI['n'],bO['pf'])),flush=True)
        # leva 2: H2,H4,H8,D1 con il segnale EMA
        for tfn,rule in (('H2','2h'),('H4','4h'),('H8','8h'),('D1','1D')):
            r=resample(d,rule); P=prep(r); ks=P[7]; n=len(ks); cut=ks[int(0.7*n)]
            ma,mb=line(sim(P,cost,'B2',np.ones(n,bool)),cut); res.append(('L2',name,tfn,'EMA B2',ma,mb)); print('L2 %s: %s'%(tfn,fmt2(ma,mb)),flush=True)
        # leva 3: trend following con chandelier
        for tfn,rule in (('H1','1h'),('H4','4h'),('D1','1D')):
            r=resample(d,rule); P=prep(r); O,H,L,C,atr,sig,ha,ks=P; n=len(ks); cut=ks[int(0.7*n)]
            for N in (20,55):
                ma,mb=line(trail(O,H,L,C,atr,ks,cost,entries_breakout(C,H,L,N)),cut); res.append(('L3a',name,tfn,'breakout%d'%N,ma,mb)); print('L3a %s breakout %d + chandelier 3 ATR: %s'%(tfn,N,fmt2(ma,mb)),flush=True)
            ma,mb=line(trail(O,H,L,C,atr,ks,cost,sig),cut); res.append(('L3b',name,tfn,'EMAcross',ma,mb)); print('L3b %s EMA9/21+chandelier: %s'%(tfn,fmt2(ma,mb)),flush=True)
    import json; json.dump(res,open('/tmp/claude-0/tre_leve.json','w'),default=float)
    print('=== RIEPILOGO ===')
    for L in ('L1','L2','L3a','L3b'):
        sub=[x for x in res if x[0]==L]; big=[x for x in sub if x[4]['n']>=100]
        print(L,'test',len(sub),'| con >=100 op IS:',len(big),'| PF IS mediano %.2f max %.2f | R IS>0 in %d'%(np.median([x[4]['pf'] for x in big]) if big else 0,max([x[4]['pf'] for x in big]) if big else 0,sum(1 for x in big if x[4]['R']>0)))
    cand=[x for x in res if x[4]['pf']>=1.2 and x[4]['n']>=100]
    print('PF IS>=1.2 con n>=100:',len(cand),'su',len(res))
    for x in sorted(cand,key=lambda x:-x[4]['pf'])[:12]: print('  ',x[0],x[1],x[2],x[3],fmt2(x[4],x[5]))
    val=[(x[0],x[1],x[2],x[3]) for x in res if x[4]['pf']>=1.5 and x[4]['dd']<=15 and x[4]['n']>=100 and x[5]['pf']>1.2 and x[5]['R']>0 and x[5]['n']>=30]
    print('VALIDATE:',val)
