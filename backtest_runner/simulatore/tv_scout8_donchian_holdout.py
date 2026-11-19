"""Hold-out 2025-26 Donchian (len40, EMA400, stop 3 e 4 ATR) su NASUSD/SPXUSD. Criteri: report/DONCHIAN_HOLDOUT_2025_26_CRITERI_2026-11-19.md"""
import sys
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_donchian_indici import *
SRC={'NASUSD':(['/tmp/claude-0/nas/NASUSD_M1_2024.csv','/tmp/claude-0/ho/nas/NASUSD_M1_202*.csv'],2.0),'SPXUSD':(['/tmp/claude-0/spx/SPXUSD_M1_2024.csv','/tmp/claude-0/ho/spx/SPXUSD_M1_202*.csv'],0.7)}
def load2(pats):
    rows={}
    import glob,csv
    for pat in pats:
        for f in sorted(glob.glob(pat)):
            with open(f) as fh:
                r=csv.reader(fh); next(r)
                for t,o,h,l,c,*_ in r:
                    k=t[:13]; o,h,l,c=float(o),float(h),float(l),float(c)
                    if k not in rows: rows[k]=[o,h,l,c]
                    else:
                        x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
for nm,(pats,cost) in SRC.items():
    ks,A=load2(pats); O,H,L,C=A.T; E=Env(ks,O,H,L,C,cost)
    i25=next(i for i,k in enumerate(ks) if k>='2025'); print('==',nm,'barre',len(C),'dal',ks[0],'al',ks[-1],'di cui 2025-26:',len(C)-i25,'buy&hold 2025-26: x%.2f'%(C[-1]/C[i25]),flush=True)
    for stop in (3,4):
        for lab,filt in (('len40 ema400 stop%d'%stop,lambda t:True),):
            tr=[x for x in donch(E,40,400,stop) if x[0]>='2025']
            L_=[x for x in tr if x[2]==1]; S_=[x for x in tr if x[2]==-1]
            print(lab,'TUTTI',fmt(metrics(tr)),'\n    LONG ',fmt(metrics(L_)),'\n    SHORT',fmt(metrics(S_)))
    # riferimento: base len20 senza filtri e per anno
    tr=[x for x in donch(E,20,None,None) if x[0]>='2025']; print('riferimento len20 nudo',fmt(metrics(tr)))
    for y in ('2025','2026'):
        t=[x for x in donch(E,40,400,3) if x[0][:4]==y]; print('  len40 ema400 stop3 anno',y,fmt(metrics(t)))
