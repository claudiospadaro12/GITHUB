import json,glob,collections,re,sys
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
R=json.load(open('oro_res.json'));G=json.load(open('gtp_res.json'))
d80={x['name']:x for x in json.load(open('/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi/wim_full_88_passate.json'))}
def dtp(y):
    h=glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_{y}/*/report/*.htm')[0]
    day=collections.defaultdict(float)
    for e in load_deals(h): day[e[0][:10]]+=e[1]
    x=d80[f'DTP_DaytradeProMax9DDlowrisk_{y}'];return dict(daily=dict(day),dd=max(x['eqDDmax'],x['absEqDD']))
def get(e,lv,y):
    if e=='DTP': return dtp(y)
    if e=='GTP': r=G[f'COMBO_{y}'];return dict(daily=r['daily'],dd=max(r['ddE'],r['relAbs']))
    r=R[f'{lv}_{e}_80000_{y}'];return dict(daily=r['daily'],dd=max(r['ddE'],r.get('relAbs') or 0))
COMBO={'P1':[('PH','L1'),('GB','L0'),('DTP','on')],'P2':[('GR','L3'),('PH','L3'),('GB','L0'),('DTP','on')],'P3':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4':[('GR','L3'),('GB','L0'),('DTP','on')],'P5':[('PH','L0'),('GB','L0'),('DTP','on')]}
Y=('2013','2020','2025');S=2;DEP=160000
out={}
for c,mem in COMBO.items():
    cnt={2:0,3:0,4.3:0,5:0};worst=(0,None);ddr=(0,None);bound=0
    for y in Y:
        day=collections.defaultdict(float);b=0
        for e,lv in mem:
            r=get(e,lv,y);b+=r['dd']
            for d,v in r['daily'].items(): day[d]+=v
        bound=max(bound,b)
        cum=0;pk=0
        for d in sorted(day):
            v=day[d]*S;cum+=v;pk=max(pk,cum)
            if v<worst[0]: worst=(v,d)
            if pk-cum>ddr[0]: ddr=(pk-cum,d)
            for k in cnt:
                if v<=-k/100*DEP: cnt[k]+=1
    out[c]=dict(worst=worst,ddr=ddr,bound=bound*S,cnt=cnt)
    print(c,'peggior giorno',round(worst[0]),worst[1],f"{100*worst[0]/DEP:.2f}%",'| DD realizzato',round(ddr[0]),ddr[1],f"{100*ddr[0]/DEP:.2f}%",'| DD equity limite',round(bound*S),f"{100*bound*S/DEP:.1f}%",'| giorni <=-2/-3/-4.3/-5%',cnt[2],cnt[3],cnt[4.3],cnt[5])
json.dump(out,open('rischio160.json','w'),default=float)
