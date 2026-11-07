import json,collections,datetime as dt
R=json.load(open('r21_res.json'));DEP=3745
def ser(keys):
    day=collections.defaultdict(float)
    for k in keys:
        for d,v in R[k]['daily'].items(): day[d]+=v
    return day
out={}
for mod in (1,4):
  for lv in ('L2','L0','L1','L3'):
    keys=[f'R21_M{mod}_{lv}_{e}' for e in ('GR','PH','GB')]
    if not all(k in R for k in keys): continue
    day=ser(keys);ds=sorted(day)
    cum=0;pk=0;ddrel=0;ddabs=0;worst=(0,None);double=None;bal=DEP;pkb=DEP;worstrel=0
    months=collections.defaultdict(float)
    for d in ds:
        v=day[d];cum+=v;b=DEP+cum
        if v<worst[0]: worst=(v,d)
        worstrel=min(worstrel,v/(b-v))
        pkb=max(pkb,b);ddrel=max(ddrel,(pkb-b)/pkb);ddabs=max(ddabs,pkb-b)
        if double is None and cum>=DEP: double=ds.index(d)+1
        months[d[:7]]+=v
    net=sum(R[k]['net'] for k in keys);bound=sum(max(R[k]['ddE'],R[k].get('relAbs') or 0) for k in keys);relsum=sum(R[k]['ddEp'] for k in keys)
    dd1=[R[k]['ddEp'] for k in keys]
    out[(mod,lv)]=dict(net=net,ops=sum(R[k]['ops'] for k in keys),bound=bound,relsum=relsum,worst=worst,ddrel=100*ddrel,ddabs=ddabs,double=double,final=DEP+net,wm=min(months.values()),wmn=min(months,key=months.get),worstrel=100*worstrel,ea=[(k[-2:],round(R[k]['net']),R[k]['ddEp'],round(max(R[k]['ddE'],R[k].get('relAbs') or 0))) for k in keys])
    o=out[(mod,lv)]
    print(f"M{mod} {lv}: netto {net:8.0f} ({100*net/DEP:6.0f}%) finale {DEP+net:8.0f} | DD limite assoluto {bound:6.0f} ({100*bound/DEP:5.1f}% di 3745) | somma DD relativi EA {relsum:5.1f}% | DD saldo realizzato dal picco {100*ddrel:.1f}% ({ddabs:.0f}) | peggior giorno {worst[0]:.0f} il {worst[1]} (in % del saldo di allora {100*o['worstrel']:.1f}%) | giorni per raddoppiare {double} | mese peggiore {o['wm']:.0f} ({o['wmn']}) | EA {o['ea']}")
json.dump({f'{k[0]}|{k[1]}':v for k,v in out.items()},open('r21_agg.json','w'),default=float)
print()
for lv in ('L2','L3','L1'):
    a=out.get((1,lv));b=out.get((4,lv))
    if a and b: print(lv,'M4/M1 netto trio',round(b['net']/a['net'],2),'| per EA',[ (x[0],round(y[1]/x[1],2)) for x,y in zip(a['ea'],b['ea'])])
