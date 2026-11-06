import json,itertools,collections
R=json.load(open('oro_res.json'));G=json.load(open('gtp_res.json'))
Y=('2013','2018','2020','2025');DEP=80000
def get(e,lv,y):
    if e=='GTP': return G[f'{lv}_{y}']
    return R[f'{lv}_{e}_{DEP}_{y}']
OPT={'GR':('L0','L1','L2','L3',None),'PH':('L0','L1','L2','L3',None),'GB':('L0','L1','L2','L3',None),'GTP':('COMBO','PROPFIRM','LOWRISK','MEDIUM','HIGHRISK',None)}
EA=('GR','PH','GB','GTP')
print('GTP singolo: netto 13/18/20/25 | DD max | peggior giorno | gg<=-4.3% | gg<=-5%')
for lv in OPT['GTP'][:-1]:
    rs=[get('GTP',lv,y) for y in Y]
    n43=sum(1 for r in rs for v in r['daily'].values() if v<=-0.043*DEP);n5=sum(1 for r in rs for v in r['daily'].values() if v<=-0.05*DEP)
    print(lv,[round(r['net']) for r in rs],'DD',round(max(max(r['ddE'],r['relAbs']) for r in rs)),f"{100*max(max(r['ddE'],r['relAbs']) for r in rs)/DEP:.1f}%",'worst',round(min(min(r['daily'].values()) for r in rs)),n43,n5)
res=[]
for c in itertools.product(*[OPT[e] for e in EA]):
    if all(x is None for x in c): continue
    worst=0;n43=0;n5=0;bound=0;net=[]
    for y in Y:
        day=collections.defaultdict(float);b=0;n=0
        for e,lv in zip(EA,c):
            if lv is None: continue
            r=get(e,lv,y);n+=r['net'];b+=max(r['ddE'],r.get('relAbs') or 0)
            for d,v in r['daily'].items(): day[d]+=v
        net.append(n);bound=max(bound,b);worst=min(worst,min(day.values()))
        n43+=sum(1 for v in day.values() if v<=-0.043*DEP);n5+=sum(1 for v in day.values() if v<=-0.05*DEP)
    res.append(dict(c=c,net=net,sum=sum(net),worst=worst,n43=n43,n5=n5,bound=bound))
json.dump(res,open('combo4.json','w'),default=float)
ok=[r for r in res if r['n43']==0]
print('\ncombinazioni',len(res),'senza oltre -4.3%:',len(ok),'; con GTP presente:',sum(1 for r in ok if r['c'][3]))
print('\nTOP 10 senza toccare -4.3% (con DDlim<=8000):')
top=[r for r in sorted(ok,key=lambda r:-r['sum']) if r['bound']<=8000][:10]
for r in top: print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'DDlim',round(r['bound']))
print('\nTOP 8 senza toccare -4.3% (qualsiasi DDlim):')
for r in sorted(ok,key=lambda r:-r['sum'])[:8]: print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),'DDlim',round(r['bound']))
print('\nTOP 8 senza toccare -4.3% CON GTP:')
for r in [r for r in sorted(ok,key=lambda r:-r['sum']) if r['c'][3]][:8]: print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),'DDlim',round(r['bound']))
print('\n4 EA stessa filosofia:')
for c in [('L3','L3','L3','COMBO'),('L0','L0','L0','PROPFIRM'),('L1','L1','L1','LOWRISK'),('L2','L2','L2','MEDIUM')]:
    r=[x for x in res if x['c']==c][0];print(c,[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'gg4.3',r['n43'],'gg5',r['n5'],'DDlim',round(r['bound']))
print('\nsolo GTP aggiunto ai migliori 3EA:')
for base in [('L3','L3','L3'),('L3','L3','L0'),('L3','L0','L0'),('L3','L1','L3')]:
    for g in ('COMBO','PROPFIRM',None):
        r=[x for x in res if x['c']==base+(g,)][0];print(base,g,round(r['sum']),'worst',round(r['worst']),'gg4.3',r['n43'],'DDlim',round(r['bound']))
