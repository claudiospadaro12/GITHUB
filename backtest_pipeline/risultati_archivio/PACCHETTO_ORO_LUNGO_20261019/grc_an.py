import sys,collections,glob,os
sys.path.insert(0,'.')
from parse_rep import deals
D=deals('w3_GRC/report/GRC_TRANCHE1_20261019_033114.htm')
print(len(D),D[0]['t'],D[-1]['t'])
# deals: out deals only carry profit; count closes (dir out)
closes=[d for d in D if d['dir'] in ('out','Out','out/in')]
print('closes',len(closes))
m=collections.OrderedDict()
vol=collections.defaultdict(list)
for d in D:
    k=d['t'][:7]
    if d['dir'].lower().startswith('out'):
        x=m.setdefault(k,[0,0.0,0]); x[0]+=1; x[1]+=d['profit']+d['comm']+d['swap']; x[2]+= (1 if d['profit']+d['comm']+d['swap']>0 else 0)
    if d['dir'].lower().startswith('in'): vol[k].append(d['vol'])
bal=5000.0
print('mese  n  netto  saldo  maxlot  medlot')
for k,(n,p,w) in m.items():
    bal+=p; v=vol[k]
    print(k,n,round(p,1),round(bal,1),max(v) if v else 0,round(sum(v)/len(v),3) if v else 0)
