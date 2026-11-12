import glob,collections,sys,json
sys.path.insert(0,'/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad')
from tre_lib import deals
DEP=80000.0
def path(e,lv,y):
    if e=='DTP': g=glob.glob('wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_%s/*/report/*.htm'%y)
    elif e=='GTP': g=glob.glob('gtp_anni/%s_M1_GTP_COMBO/*/report/*.htm'%y)
    else: g=glob.glob('oro/z*/*/%s_%s_80000_%s/*/report/*.htm'%(lv,e,y))
    return g[0] if g else None
def daily(e,lv,y):
    p=path(e,lv,y)
    if not p: return None
    d=collections.defaultdict(float)
    for x in deals(p): d[x['t'][:10]]+=x['v']
    return d
EAS=[('Goldbot One Prop (L0)','GB','L0',('2013','2018','2020','2025')),('Goldbot One Combo 3GOLD (L3)','GB','L3',('2013','2018','2020','2025')),
 ('Gold Phantom Gradino 1 (L1)','PH','L1',('2013','2018','2020','2025')),('Gold Reaper Combo 3GOLD (L3)','GR','L3',('2013','2018','2020','2025')),
 ('Gold Trade Pro Combo','GTP','COMBO',('2013','2018','2020','2025')),('Daytrade Pro Max9','DTP','on',('2013','2017','2020','2022','2025'))]
T={'4,3%':0.043,'4,5%':0.045,'5,0%':0.05}
out={}
print('== SINGOLI EA (80.000 EUR, perdita giornaliera REALIZZATA dai deal del tester) ==')
for nm,e,lv,ys in EAS:
    row=[];tot=collections.Counter();worst=0
    for y in ys:
        d=daily(e,lv,y)
        if d is None: row.append('%s:n.d.'%y); continue
        w=min(d.values()); worst=min(worst,w)
        c={k:sum(1 for v in d.values() if v<=-t*DEP) for k,t in T.items()}
        for k in c: tot[k]+=c[k]
        row.append('%s: %d/%d/%d (peggiore %.1f%%)'%(y,c['4,3%'],c['4,5%'],c['5,0%'],100*w/DEP))
    print('%-30s'%nm,' | '.join(row),'|| TOTALE >=4,3/4,5/5,0%%: %d/%d/%d, peggiore in assoluto %.1f%%'%(tot['4,3%'],tot['4,5%'],tot['5,0%'],100*worst/DEP))
    out[nm]=dict(tot=dict(tot),worst=worst)
json.dump(out,open('soglia45_singoli.json','w'))
# combo
COMBO={'P1 (160k): Phantom Gradino 1 + Goldbot Prop + Daytrade Pro':[('PH','L1'),('GB','L0'),('DTP','on')],'P3 (80k): Goldbot Combo + Gold Trade Pro Combo + Daytrade Pro':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4 (80k): Reaper Combo + Goldbot Prop + Daytrade Pro':[('GR','L3'),('GB','L0'),('DTP','on')]}
print('\n== COMBINAZIONI SCELTE (tester, 3 anni 2013/2020/2025, per conto) ==')
allacc={}
for nm,mem in COMBO.items():
    row=[];tot=collections.Counter();worst=0;acc={}
    for y in ('2013','2020','2025'):
        day=collections.defaultdict(float)
        for e,lv in mem:
            d=daily(e,lv,y)
            for k,v in d.items(): day[k]+=v
        acc[y]=day
        w=min(day.values());worst=min(worst,w)
        c={k:sum(1 for v in day.values() if v<=-t*DEP) for k,t in T.items()}
        for k in c: tot[k]+=c[k]
        row.append('%s: %d/%d/%d (peggiore %.1f%%)'%(y,c['4,3%'],c['4,5%'],c['5,0%'],100*w/DEP))
    allacc[nm]=acc
    print(nm); print('    ',' | '.join(row),'|| TOTALE %d/%d/%d, peggiore %.1f%%'%(tot['4,3%'],tot['4,5%'],tot['5,0%'],100*worst/DEP))
# giorni in cui almeno un conto del portafoglio supera 4,5%
import itertools
n=0;dl=[]
for y in ('2013','2020','2025'):
    days=set()
    for nm,acc in allacc.items():
        for k,v in acc[y].items():
            if v<=-0.045*DEP: days.add((k,nm.split(' ')[0]))
    for k,c in sorted(days): dl.append((k,c))
print('\nGiorni <= -4,5% per conto (data, conto):',dl)
