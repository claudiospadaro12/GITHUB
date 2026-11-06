import json,itertools,collections
R=json.load(open('oro_res.json'))
Y=('2013','2018','2020','2025');DEP=80000
LV=('L0','L1','L2','L3');EA=('GR','PH','GB')
def ser(lv,e,y): return R[f'{lv}_{e}_{DEP}_{y}']
# singoli
print('SINGOLI (80k): net per anno | DD%max | peggior giorno% | giorni<=-4.3% totali')
single={}
for e in EA:
  for lv in LV:
    nets=[ser(lv,e,y)['net'] for y in Y]
    dd=max(max(ser(lv,e,y)['ddE'],ser(lv,e,y).get('relAbs') or 0) for y in Y)
    wd=min(min(ser(lv,e,y)['daily'].values()) for y in Y)
    n43=sum(1 for y in Y for v in ser(lv,e,y)['daily'].values() if v<=-0.043*DEP)
    n5=sum(1 for y in Y for v in ser(lv,e,y)['daily'].values() if v<=-0.05*DEP)
    single[(e,lv)]=dict(nets=nets,dd=dd,wd=wd,n43=n43,n5=n5)
    print(e,lv,[round(x) for x in nets],'DDmax',round(dd),f'{100*dd/DEP:.1f}%','worst',round(wd),f'{100*wd/DEP:.1f}%','gg<=-4.3%',n43,'gg<=-5%',n5)
# combinazioni (livello per EA, oppure spento)
opts=LV+(None,)
res=[]
for c in itertools.product(opts,repeat=3):
    if all(x is None for x in c): continue
    tot={};worst=0;n43=0;n5=0;bound=0;net=[]
    for y in Y:
        day=collections.defaultdict(float);b=0;n=0
        for e,lv in zip(EA,c):
            if lv is None: continue
            r=ser(lv,e,y);n+=r['net']
            b+=max(r['ddE'],r.get('relAbs') or 0)
            for d,v in r['daily'].items(): day[d]+=v
        net.append(n);bound=max(bound,b)
        worst=min(worst,min(day.values()))
        n43+=sum(1 for v in day.values() if v<=-0.043*DEP);n5+=sum(1 for v in day.values() if v<=-0.05*DEP)
    res.append(dict(c=c,net=net,sum=sum(net),worst=worst,n43=n43,n5=n5,bound=bound,minyear=min(net)))
json.dump(res,open('combo_oro.json','w'),default=float)
ok43=[r for r in res if r['n43']==0]
ok5=[r for r in res if r['n5']==0]
print('\ncombinazioni totali',len(res),'senza giorni<=-4.3%:',len(ok43),' senza giorni<=-5%:',len(ok5))
print('\nTOP senza toccare -4.3% (per somma netti 4 anni):')
for r in sorted(ok43,key=lambda r:-r['sum'])[:12]:
    print(r['c'],[round(x) for x in r['net']],'somma',round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'DDlim max',round(r['bound']),f"{100*r['bound']/DEP:.1f}%")
print('\nTOP senza toccare -5% ma che toccano -4.3%:')
for r in sorted([r for r in ok5 if r['n43']>0],key=lambda r:-r['sum'])[:6]:
    print(r['c'],'somma',round(r['sum']),'worst',round(r['worst']),'gg4.3',r['n43'])
print('\nI 4 trii puri:')
for lv in LV:
    r=[x for x in res if x['c']==(lv,lv,lv)][0]
    print(lv,[round(x) for x in r['net']],'somma',round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'gg<=-4.3%',r['n43'],'gg<=-5%',r['n5'],'DDlim',round(r['bound']))
