"""Gold 4-Day Breakout (PDF Massimo 19/11): test su XAUUSD FTMO M1 2014-11..2020-12. Criteri: report/GOLD_4DAY_BREAKOUT_CRITERI_2026-11-19.md"""
import csv,glob,collections,sys
import numpy as np
COST=0.35
def load():
    D=collections.OrderedDict()
    for f in sorted(glob.glob('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv')):
        with open(f) as fh:
            r=csv.reader(fh,delimiter=';'); next(r)
            for t,o,h,l,c,tv,*_ in r:
                if t.endswith('00:00') and float(tv)>2000: continue
                D.setdefault(t[:10],[]).append((int(t[11:13])*60+int(t[14:16]),float(o),float(h),float(l),float(c)))
    # dedup/sort per day
    return {d:np.array(sorted(set(v))) for d,v in D.items()}
def run(D,N=4,k=0.5,atrp=14,fa=None,fb=None):
    days=sorted(D); dh=np.array([D[d][:,2].max() for d in days]); dl=np.array([D[d][:,3].min() for d in days]); dc=np.array([D[d][-1,4] for d in days])
    tr=np.maximum(dh-dl,np.maximum(abs(dh-np.roll(dc,1)),abs(dl-np.roll(dc,1)))); tr[0]=dh[0]-dl[0]
    out=[]
    for i in range(max(N,atrp,100)+1,len(days)):
        d=days[i]; hi=dh[i-N:i].max(); lo=dl[i-N:i].min(); atr=tr[i-atrp:i].mean(); sl=k*atr
        if fa is not None and atr/tr[i-100:i].mean()<=fa: continue
        if fb is not None and (hi-lo)/atr<=fb: continue
        B=D[d]; B=B[(B[:,0]>=600)&(B[:,0]<1320)]
        if len(B)<30: continue
        pos={}; done=set(); 
        for m,o,h,l,c in B:
            for dr in (1,-1):
                if dr in pos:
                    e,s=pos[dr]
                    if (dr==1 and l<=s) or (dr==-1 and h>=s):
                        out.append((d,dr,(-sl-COST)/sl)); del pos[dr]; done.add(dr)
        # ricostruisco in modo ordinato: ciclo unico
        pos={}; done=set()
        for m,o,h,l,c in B:
            for dr in (1,-1):
                if dr in pos:
                    e,s=pos[dr]
                    if (dr==1 and l<=s) or (dr==-1 and h>=s):
                        px=s; out_r=(dr*(px-e)-COST)/sl; out.append((d,dr,out_r)); del pos[dr]; done.add(dr)
            for dr in (1,-1):
                if dr in done or dr in pos: continue
                if dr==1 and h>=hi: e=max(hi,o)
                elif dr==-1 and l<=lo: e=min(lo,o)
                else: continue
                s=e-dr*sl; pos[dr]=(e,s)
                if (dr==1 and l<=s) or (dr==-1 and h>=s):
                    out.append((d,dr,(-sl-COST)/sl)); del pos[dr]; done.add(dr)
        last=B[-1,4]
        for dr,(e,s) in pos.items(): out.append((d,dr,(dr*(last-e)-COST)/sl))
    return out
def stats(tr):
    if not tr: return 'n=0'
    r=np.array([x[2] for x in tr]); g=r[r>0].sum(); l=-r[r<0].sum(); w=r[r>0]; ls=r[r<0]
    return 'n=%d R=%.3f PF=%.2f win=%.0f%% medio vinc %.2f perd %.2f'%(len(r),r.mean(),g/l if l>0 else 99,100*(r>0).mean(),w.mean() if len(w) else 0,ls.mean() if len(ls) else 0)
if __name__=='__main__':
    D=load(); print('giorni',len(D),min(D),max(D),flush=True)
    A=lambda tr:[x for x in tr if x[0]<'2019']; Bp=lambda tr:[x for x in tr if x[0]>='2019']
    base=run(D)
    print('BASE (4 giorni, 0,5 ATR)'); print(' A 2014-18 TUTTI',stats(A(base))); print('   long ',stats([x for x in A(base) if x[1]==1])); print('   short',stats([x for x in A(base) if x[1]==-1]))
    print(' B 2019-20 TUTTI',stats(Bp(base))); 
    by=collections.defaultdict(list)
    for x in base: by[x[0][:4]].append(x)
    print(' per anno:',' '.join('%s:%s'%(y,stats(v).split(' win')[0]) for y,v in sorted(by.items())))
    print('--- plateau periodo A (PF) ---')
    cells=0; good=0
    for N in (3,4,5,6):
        row=[]
        for k in (0.3,0.5,0.75,1.0):
            t=A(run(D,N,k)); r=np.array([x[2] for x in t]); g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l; row.append('k%.2f:%.2f/%d'%(k,pf,len(r))); cells+=1; good+= pf>1.1
        print(' N=%d '%N,' '.join(row))
    print('celle con PF>1.1 su 16:',good)
