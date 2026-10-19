import sys,glob,os,statistics,re
sys.path.insert(0,'.')
from parse_rep import deals
import datetime
for d in sorted(glob.glob('deep/DEEP_*')):
    nm=os.path.basename(d)[5:]
    f=[x for x in glob.glob(d+'/report/*TRANCHE22_*.htm')][0]
    D=deals(f)
    D.sort(key=lambda x:x['t'])
    bal=5000.0; entries=[]; last_res=None; lastbal=5000.0
    # costruisci: per ogni deal in: lotto e saldo corrente; esito del trade precedente chiuso
    rows=[]
    for x in D:
        if x['dir'].lower().startswith('in'):
            rows.append(('in',x['vol'],lastbal,last_res))
        elif x['dir'].lower().startswith('out'):
            lastbal=x['bal']; last_res=x['profit']+x['comm']+x['swap']
    lots=[r[1] for r in rows]
    lpb=[r[1]/(r[2]/1000.0) for r in rows if r[2]>0]
    after_loss=[r[1]/(r[2]/1000.0) for r in rows if r[3] is not None and r[3]<0 and r[2]>0]
    after_win=[r[1]/(r[2]/1000.0) for r in rows if r[3] is not None and r[3]>0 and r[2]>0]
    cv=statistics.pstdev(lpb)/statistics.mean(lpb) if lpb and statistics.mean(lpb)>0 else 0
    avg_lot=statistics.mean(lots)
    n=len([x for x in D if x['dir'].lower().startswith('out')]); net=sum(x['profit']+x['comm']+x['swap'] for x in D if x['dir'].lower().startswith('out'))
    cost=0.18*(avg_lot/0.01)
    print('%-26s lotto %.2f-%.2f (x%.0f) medio %.2f | lotti per 1000 EUR di saldo: mediana %.3f CV %.2f | dopo perdita %.3f dopo vincita %.3f | media/op %.2f costo spread ~%.2f rapporto %.1f'%(nm[:26],min(lots),max(lots),max(lots)/min(lots),avg_lot,statistics.median(lpb),cv,statistics.mean(after_loss) if after_loss else 0,statistics.mean(after_win) if after_win else 0,net/n,cost,(net/n)/cost))
