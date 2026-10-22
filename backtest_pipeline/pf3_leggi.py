import sys,glob,re,collections
sys.path.insert(0,'.')
from parse_rep import deals,read
import csv
man={r['sonda']:r for r in csv.DictReader(open('pf3_zip/MANIFEST_PF3.csv'),delimiter=';')}
lab={1:'0.25 OFF',2:'0.25 ON',3:'0.5 ON',4:'0.75 OFF',5:'0.75 ON'}
out={}
for k in range(1,11):
    f=glob.glob(f'pf3_zip/report/*TRANCHE{k}_2*.htm')[0]
    D=deals(f); 
    ex=[d for d in D if d['dir']=='out']
    en=[d for d in D if d['dir']=='in']
    # lots ratio: vol of in-deals
    vols=[d['vol'] for d in en]
    # equity DD from manifest
    dd=float(man[f'TRANCHE{k}']['dd_equita'].split('(')[0])
    net=sum(d['profit']+d['comm']+d['swap'] for d in ex)
    mon=collections.defaultdict(float); yr=collections.defaultdict(float)
    for d in ex:
        p=d['profit']+d['comm']+d['swap']; mon[d['t'][:7]]+=p; yr[d['t'][:4]]+=p
    pos=sum(1 for v in mon.values() if v>0)
    worst=min(d['profit']+d['comm']+d['swap'] for d in ex)
    # positions open at same time
    ev=[]; 
    for d in D: ev.append((d['t'],1 if d['dir']=='in' else -1))
    ev.sort(key=lambda x:(x[0],-x[1])); c=0;mx=0
    for _,s in ev: c+=s; mx=max(mx,c)
    h1=sum(v for m,v in mon.items() if m<'2022') if k>5 else None
    print(f"T{k} {lab[(k-1)%5+1]:9} {'W2' if k>5 else 'W1'} n={len(ex)} primo={D[0]['t'][:10]} ultimo={D[-1]['t'][:10]} net={net:.0f} manif={man[f'TRANCHE{k}']['profitto']} PF={man[f'TRANCHE{k}']['pf']} DDeq={dd:.0f} = {dd/800:.2f}% di 80K | mesi+ {pos}/{len(mon)}={100*pos/len(mon):.0f}% | worst={worst:.0f} | lot min/max {min(vols)}/{max(vols)} ratio {max(vols)/min(vols):.1f} | maxpos {mx} | dur {man[f'TRANCHE{k}']['durata_s']}s")
    if k>5: print('    anni:',{y:round(v) for y,v in sorted(yr.items())})
