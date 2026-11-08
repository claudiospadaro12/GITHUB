# Simula la challenge FTMO 2-Step (fase 1 +10%, fase 2 +5%, perdita giornaliera 5%, totale 10%) su finestre di partenza giornaliere
# dei P&L giornalieri REALIZZATI delle combo P1,P3,P4,P5 a 80k (anni 2013, 2020, 2025). Da lanciare dalla cartella con oro_res.json, gtp_res.json, wim_risultati/.
import json,glob,collections,sys,datetime
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
src=open('/home/user/GITHUB/report/ORO_GRADINI_dati/rischio160.py').read()
exec(src[:src.index('Y=(')])
cost=json.load(open('/home/user/GITHUB/report/ORO_GRADINI_dati/costi_prop.json'))
Y=('2013','2020','2025')
def series(c,y,scen):
    day=collections.defaultdict(float)
    for e,lv in COMBO[c]:
        for d,v in get(e,lv,y)['daily'].items(): day[d]+=v
    ds=sorted(day);adj=cost[c][y]['tester']-cost[c][y][scen] if scen!='tester' else 0
    return ds,[day[d]-adj/len(ds) for d in ds]
DEP=80000.0;T1=0.10*DEP;T2=0.05*DEP;DL=0.05*DEP;TL=0.10*DEP
def run(vals,DS,i0,target,H):
    cum=0.0;d0=datetime.date.fromisoformat(DS[i0].replace('.','-'))
    for k in range(i0,len(vals)):
        if (datetime.date.fromisoformat(DS[k].replace('.','-'))-d0).days>H: return 'open',k
        v=vals[k]
        if v<=-DL: return 'fail_day',k
        cum+=v
        if cum<=-TL: return 'fail_tot',k
        if cum>=target: return 'pass',k
    return 'open',len(vals)
for scen in ('tester','centrale','prudente'):
  for H in (90,180):
    print('\n== costi',scen,'| orizzonte',H,'giorni')
    for c in ('P1','P3','P4','P5'):
        tot=collections.Counter();both=0;n=0
        for y in Y:
            DS,vals=series(c,y,scen)
            for i0 in range(len(vals)):
                st1,k1=run(vals,DS,i0,T1,H);n+=1;tot[st1]+=1
                if st1=='pass' and k1+1<len(vals) and run(vals,DS,k1+1,T2,H)[0]=='pass': both+=1
        print(c,{k:round(100*v/n) for k,v in tot.items()},'ENTRAMBE',round(100*both/n),'n',n)
