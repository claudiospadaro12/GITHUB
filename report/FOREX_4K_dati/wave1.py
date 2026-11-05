exec(open('trio_corr.py').read().split("CAND=[")[0])
import numpy as np,json
SETS={'Stability low':'STAB_stabilityprolowriskset','Luna 4DD':'LUNA_Luna4DD','Apex Conservative':'APEX_ApexConservativeGrid','Daytrade Pro Max20':'DTP_DaytradeProMax20DDmediumrisk'}
def series(s,y):
    d0=dt.date(int(y),1,1);n=366 if int(y)%4==0 else 365
    c=daily(load_deals(first(f'forex4k/z*/*/{s}_{y}/*/report/*.htm')),y)
    return np.array([c.get((d0+dt.timedelta(i)).strftime('%Y.%m.%d'),0.0) for i in range(n)])
res={}
for y in ('2013','2017','2020','2022','2025'):
    S={k:series(v,y) for k,v in SETS.items()}
    tot=sum(S.values())
    def dd(s):
        c=np.cumsum(s);pk=np.maximum.accumulate(np.maximum(c,0));return float((pk-c).max())
    cs=np.concatenate([[0],np.cumsum(tot)])
    w56=min(cs[i+56]-cs[i] for i in range(len(tot)-56))
    w28=min(cs[i+28]-cs[i] for i in range(len(tot)-28))
    # share of 8-week windows that end negative
    wins=[cs[i+56]-cs[i] for i in range(len(tot)-56)]
    res[y]=dict(net=float(tot.sum()),dd_real=dd(tot),worst_day=float(tot.min()),worst56=float(w56),worst28=float(w28),neg56=float(np.mean(np.array(wins)<0)*100),p10_56=float(np.percentile(wins,10)),
       single={k:dict(net=float(v.sum()),dd=dd(v),worst56=float(min((np.concatenate([[0],np.cumsum(v)])[i+56]-np.concatenate([[0],np.cumsum(v)])[i]) for i in range(len(v)-56)))) for k,v in S.items()})
    # trades/week
    print(y,{k:round(x) if isinstance(x,float) else '' for k,x in res[y].items() if k!='single'})
    for k,v in res[y]['single'].items(): print('    ',k,{a:round(b) for a,b in v.items()})
json.dump(res,open('wave1.json','w'),indent=1)
