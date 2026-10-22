import sys,glob,collections,csv
sys.path.insert(0,'.')
from parse_rep import deals
import datetime as dt
man={r['sonda']:r for r in csv.DictReader(open('pf4_zip/PF4_PROPFIRMGOLDEA/MANIFEST_PF4.csv'),delimiter=';')}
lab={1:'0.25',2:'0.5',3:'0.75'}
for k in range(1,7):
    f=glob.glob(f'pf4_zip/PF4_PROPFIRMGOLDEA/report/*TRANCHE{k}_2*.htm')[0]
    D=[d for d in deals(f) if abs(d['profit']+d['comm']+d['swap']-80000)>1]
    ex=[d for d in D if d['dir']=='out']; en=[d for d in D if d['dir']=='in']
    mon=collections.defaultdict(float); yr=collections.defaultdict(float)
    for d in D:
        p=d['profit']+d['comm']+d['swap']; mon[d['t'][:7]]+=p; yr[d['t'][:4]]+=p
    pos=sum(v>0 for v in mon.values())
    dd=float(man[f'TRANCHE{k}']['dd_equita'].split('(')[0])
    vols=[d['vol'] for d in en]
    wd=collections.Counter(dt.datetime.strptime(d['t'],'%Y.%m.%d %H:%M:%S').weekday() for d in D)
    hrs=collections.Counter(int(d['t'][11:13]) for d in en)
    worst=min(d['profit']+d['comm']+d['swap'] for d in ex)
    print(f"T{k} risk {lab[(k-1)%3+1]} {'W2' if k>3 else 'W1'} n={len(ex)} primo={D[0]['t']} ultimo={D[-1]['t']} net={man[f'TRANCHE{k}']['profitto']} PF={man[f'TRANCHE{k}']['pf']} DD={dd:.0f}={dd/800:.2f}% mesi+ {pos}/{len(mon)}={100*pos/len(mon):.0f}% worst={worst:.0f} lotti {min(vols)}-{max(vols)} ratio {max(vols)/min(vols):.1f} dom={wd.get(6,0)} lun={wd.get(0,0)} ven={wd.get(4,0)} sab={wd.get(5,0)}")
    if k in (1,2,5): print('   ore ingresso',sorted(hrs.items()))
    if k>3: print('   anni',{y:round(v) for y,v in sorted(yr.items())})
