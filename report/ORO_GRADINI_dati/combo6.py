import json,itertools,collections,glob,re,sys
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
R=json.load(open('oro_res.json'));G=json.load(open('gtp_res.json'))
d80={x['name']:x for x in json.load(open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/wim_full_88_passate.json'))}
GR={}
# gtp daily: ricarica
exec(open('parse_gtp.py').read().split("json.dump")[0].replace("out={}","out={}"))
G=out
W='wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/'
def fx(name,y):
    k=f'{name}_{y}'
    h=glob.glob(W+k+'/*/report/*.htm')[0]
    day=collections.defaultdict(float)
    for e in load_deals(h): day[e[0][:10]]+=e[1]
    x=d80[k]
    return dict(net=x['net'],ddE=x['eqDDmax'] if x['eqDDmax']<x['absEqDD']*1e9 else x['absEqDD'],relAbs=x['absEqDD'],daily=dict(day),eqDDpct=x['eqDDpct'])
Y=('2013','2020','2025');DEP=80000
FX={('DTP',y):fx('DTP_DaytradeProMax9DDlowrisk',y) for y in Y}
FX.update({('LUNA',y):fx('LUNA_Luna4DD',y) for y in Y})
for k,v in FX.items(): print(k,round(v['net']),'DDeq%',v['eqDDpct'],'worst',round(min(v['daily'].values())),'ddE',round(v['ddE']),'absEq',round(v['relAbs']))
def get(e,lv,y):
    if e in('DTP','LUNA'): return FX[(e,y)]
    if e=='GTP': return G[f'{lv}_{y}']
    return R[f'{lv}_{e}_{DEP}_{y}']
OPT={'GR':('L0','L1','L2','L3',None),'PH':('L0','L1','L2','L3',None),'GB':('L0','L1','L2','L3',None),'GTP':('COMBO','PROPFIRM','LOWRISK','MEDIUM','HIGHRISK',None),'DTP':('on',None),'LUNA':('on',None)}
EA=('GR','PH','GB','GTP','DTP','LUNA')
def ddv(r): return max(r.get('ddE',0),r.get('relAbs') or 0)
res=[]
for c in itertools.product(*[OPT[e] for e in EA]):
    if all(x is None for x in c): continue
    worst=0;n43=0;n5=0;bound=0;net=[]
    for y in Y:
        day=collections.defaultdict(float);b=0;n=0
        for e,lv in zip(EA,c):
            if lv is None: continue
            r=get(e,lv,y);n+=r['net'];b+=ddv(r)
            for d,v in r['daily'].items(): day[d]+=v
        net.append(n);bound=max(bound,b);worst=min(worst,min(day.values()))
        n43+=sum(1 for v in day.values() if v<=-0.043*DEP);n5+=sum(1 for v in day.values() if v<=-0.05*DEP)
    res.append(dict(c=c,net=net,sum=sum(net),worst=worst,n43=n43,n5=n5,bound=bound))
json.dump(res,open('combo6.json','w'),default=float)
ok=[r for r in res if r['n43']==0]
print('\ncombinazioni',len(res),'senza oltre -4.3%:',len(ok))
def show(L,n=10):
    for r in L[:n]: print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'DDlim',round(r['bound']),f"{100*r['bound']/DEP:.1f}%")
print('\nTOP 12 senza toccare -4.3% e DDlim<=8000, per somma'); show([r for r in sorted(ok,key=lambda r:-r['sum']) if r['bound']<=8000],12)
print('\nTOP 8 con DTP e LUNA entrambi'); show([r for r in sorted(ok,key=lambda r:-r['sum']) if r['c'][4] and r['c'][5] and r['bound']<=8000],8)
print('\nTOP 6 con almeno 3 EA oro + DTP+LUNA o diversi'); show([r for r in sorted(ok,key=lambda r:-r['sum']) if sum(1 for x in r['c'][:4] if x)>=3],6)
print('\nBASELINE oro (3 anni) e con DTP+LUNA:')
for base in [('L3','L3','L3',None),('L3','L3','L0',None),('L0','L0','L0',None),('L3','L1','L3',None),('L1','L1','L1',None),(None,'L1','L0',None),('L3','L3','L3','COMBO')]:
    for add in [(None,None),('on',None),(None,'on'),('on','on')]:
        c=base+add;r=[x for x in res if x['c']==c]
        if r: r=r[0];print(c,[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'gg4.3',r['n43'],'gg5',r['n5'],'DDlim',round(r['bound']))

# DD sul saldo realizzato (curva cumulata dei P&L giornalieri, picco massimo >=0)
def realdd(c):
    out=[]
    for y in Y:
        day=collections.defaultdict(float)
        for e,lv in zip(EA,c):
            if lv is None: continue
            for d,v in get(e,lv,y)['daily'].items(): day[d]+=v
        cum=0;pk=0;dd=0
        for d in sorted(day):
            cum+=day[d];pk=max(pk,cum);dd=max(dd,pk-cum)
        out.append(dd)
    return out
print('\n=== DD sul saldo realizzato (EUR per anno 2013/2020/2025) ===')
KEY=[(None,'L1','L0',None,None,None),(None,'L1','L0',None,'on',None),(None,'L1','L0',None,'on','on'),(None,'L1','L0',None,None,'on'),
 ('L3','L3','L0',None,None,None),('L3','L3','L0',None,'on',None),('L3','L3','L0',None,'on','on'),('L3','L3','L0',None,None,'on'),
 ('L3','L3','L3',None,None,None),('L3','L3','L3',None,'on',None),('L3','L3','L3',None,'on','on'),(None,None,None,None,'on',None),(None,None,None,None,None,'on'),(None,None,None,None,'on','on'),
 ('L3','L3','L3','COMBO',None,None),('L3','L3','L3','COMBO','on','on'),(None,'L1',None,'COMBO','on','on'),(None,'L1','L0','COMBO','on',None)]
for c in KEY:
    r=[x for x in res if x['c']==c][0];rd=realdd(c)
    print(c,'netti',[round(x) for x in r['net']],'somma',round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'gg4.3',r['n43'],'DDrealizzato',[round(x) for x in rd],f"max {100*max(rd)/DEP:.1f}%")
# ranking: senza -4.3%, DD realizzato max <= 6% (4800)
cands=[]
for r in ok:
    rd=realdd(r['c']);r['rd']=max(rd);cands.append(r)
print('\nTOP 10 senza -4.3% e DD realizzato max <=6% (4800)')
for r in sorted([r for r in cands if r['rd']<=4800],key=lambda r:-r['sum'])[:10]:
    print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),f"{100*r['worst']/DEP:.1f}%",'DDreal',round(r['rd']),f"{100*r['rd']/DEP:.1f}%")
print('\nTOP 6 senza -4.3% con DTP e Luna entrambi, per DD realizzato max')
for r in sorted([r for r in cands if r['c'][4] and r['c'][5]],key=lambda r:-r['sum'])[:6]:
    print(r['c'],[round(x) for x in r['net']],round(r['sum']),'worst',round(r['worst']),'DDreal',round(r['rd']))
json.dump([dict(c=r['c'],sum=r['sum'],net=r['net'],worst=r['worst'],rd=r['rd']) for r in cands],open('combo6_ok.json','w'),default=float)
print('\nEXTRA')
for c in [('L3','L3','L3',None,None,'on'),('L3','L3','L3',None,'on',None),(None,'L1','L0',None,None,'on'),('L3','L3','L0',None,None,'on')]:
    rd=realdd(c);r=[x for x in res if x['c']==c][0];print(c,round(r['sum']),[round(x) for x in rd],f"{100*max(rd)/DEP:.1f}%",r['n43'])
