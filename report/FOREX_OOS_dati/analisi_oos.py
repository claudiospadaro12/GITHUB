import json,collections
new=json.load(open('oos_res.json'));old=json.load(open('forex4k_res.json'));oldh=json.load(open('forex4k_htm.json'))
NY=['2014','2016','2018','2019','2021','2023','2024'];OY=['2013','2017','2020','2022','2025']
sets=collections.OrderedDict()
for k in sorted(new):
    s,y=k.rsplit('_',1);sets.setdefault(s,{})[y]=k
# validita
inval=[k for k,r in new.items() if r['stato']!='OK' or r.get('dep')!=4000 or r['input_ok']=='no' or not (r['qual'] or '').startswith('100')]
print('NON valide:',inval)
CAND=['APEX_ApexConservativeGrid','APEX_ApexUltraConservativeGrid','DTP_DaytradeProMax9DDlowrisk','DTP_DaytradeProMax20DDmediumrisk','DTP_DaytradeProMax50DDhighrisk','LUNA_Luna4DD','STAB_stabilityprolowriskset']
rows={}
for s,ys in sets.items():
    nn=[];dn=[];fin=[];wd=[];exc=[]
    for y in NY:
        k=ys[y];r=new[k]
        if k in inval: exc.append(y);continue
        nn.append((y,r['net']));dn.append((y,r['ddEp']));fin.append(r['final']);wd.append((y,r.get('worst')))
    od=[];on=[];of=[]
    for y in OY:
        k=s+'_'+y;o=old[k];od.append((y,max(o['ddEp'] or 0,oldh[k]['rel'] or 0)));on.append((y,o['net']));of.append(o['final'])
    rows[s]=dict(new_net=nn,new_dd=dn,new_fin=fin,new_worst=wd,excl=exc,old_net=on,old_dd=od,old_fin=of)
def row(s):
    r=rows[s]
    ndd=max(d for y,d in r['new_dd']);odd=max(d for y,d in r['old_dd'])
    allnet=[n for y,n in r['new_net']]+[n for y,n in r['old_net']]
    allfin=r['new_fin']+r['old_fin']
    pos_new=sum(1 for y,n in r['new_net'] if n>0);pos_all=sum(1 for n in allnet if n>0)
    return ndd,odd,pos_new,len(r['new_net']),pos_all,len(allnet),min(allfin),min([w for y,w in r['new_worst'] if w is not None] or [0])
print()
for s in sets:
    ndd,odd,pn,nn_,pa,na,mf,w=row(s)
    dd12=max(ndd,odd)
    v='SCARTATO' if dd12>50 or mf<2000 else ('ZONA GRIGIA' if dd12>35 else ('TESTATO OOS (>=10/12 positivi)' if pa>=10 and mf>=3000 else 'NON PASSA (positivi %d/%d o finale<3000)'%(pa,na)))
    print(f"{s:36s} DDmax nuovi {ndd:5.1f}%  vecchi {odd:5.1f}%  12 anni {dd12:5.1f}% | netto>0 nuovi {pn}/{nn_}  totale {pa}/{na} | finale min {mf:7.0f} | peggior gg nuovi {w:8.0f} | {v}  esclusi:{rows[s]['excl']}")
    print('     DD nuovi',[(y,round(d,1)) for y,d in rows[s]['new_dd']]);print('     net nuovi',[(y,round(n)) for y,n in rows[s]['new_net']])
json.dump(rows,open('oos_analisi.json','w'),indent=1)
# F7: anni nuovi con >=3 candidati in perdita
print('\nF7 candidati in perdita per anno nuovo')
for y in NY:
    l=[s for s in CAND if s in sets and new[sets[s][y]]['net']<=0 and sets[s][y] not in inval]
    print(y,len(l),l)
# F8 giorni <= -20% (800) Apex
print('\nF8 peggior giorno Apex')
for s in sets:
    if s.startswith('APEX'):
        print(s,[(y,round(new[sets[s][y]].get('worst'))) for y in NY if new[sets[s][y]].get('worst') is not None])
# nmin
print('\nquota lotto minimo / maxlot')
for s in sets:
    q=[(y,round(100*new[sets[s][y]]['nmin']/new[sets[s][y]]['nin'])) for y in NY if new[sets[s][y]].get('nin')]
    print(s,q)
