import json,glob,collections,datetime as dt,sys
sys.path.insert(0,'/home/user/GITHUB/report/UBS_PACCHETTO_WIM/analisi')
from wimlib import load_deals
import numpy as np
R=json.load(open('oro_res.json'))
def curve(daily,y):
    d0=dt.date(int(y),1,1);n=366 if int(y)%4==0 else 365
    a=np.zeros(n)
    for d,v in daily.items():
        i=(dt.date(int(d[:4]),int(d[5:7]),int(d[8:10]))-d0).days
        if 0<=i<n:a[i]+=v
    return a
def analyse(a,dep):
    c=np.cumsum(a);bal=dep+c
    hit=np.where(c>=dep)[0]
    pk=np.maximum.accumulate(bal)
    ddp=(pk-bal)/pk
    if len(hit)==0: return None,100*ddp.max(),100*ddp.max()>=50,c[-1]
    k=hit[0]
    return int(k)+1,100*ddp[:k+1].max(),100*ddp[:k+1].max()>=50,c[-1]
rows=[]
def add(name,dep,per_year):
    out=[]
    for y,a in per_year.items():
        out.append((y,)+analyse(a,dep))
    rows.append((name,dep,out))
Y4=('2013','2018','2020','2025')
# oro a 3745: trio per livello e singoli Medium
for lv,lab in (('L2','Trio Medium'),('L1','Trio Gradino 1'),('L0','Trio Prop'),('L3','Trio Combo')):
    add(f'ORO {lab}',3745,{y:sum(curve(R[f'{lv}_{e}_3745_{y}']['daily'],y) for e in ('GR','PH','GB')) for y in Y4})
# forex a 4000
FX={'Luna recommended':'LUNA_LunaAIrecommended','Luna lowrisk':'LUNA_LunaAIrecommendedlowrisk','Luna 4DD':'LUNA_Luna4DD','Apex extremerisk':'APEX_Apexextremerisk','Apex Elevated':'APEX_ApexElevatedGrid','Apex Conservative':'APEX_ApexConservativeGrid','Stability high':'STAB_stabilityprohighriskset','Stability medium-low':'STAB_stabilitypromediumlowriskset','Daytrade Pro Max50':'DTP_DaytradeProMax50DDhighrisk','Daytrade Pro Max20':'DTP_DaytradeProMax20DDmediumrisk'}
YF=('2013','2017','2020','2022','2025')
for lab,s in FX.items():
    py={}
    for y in YF:
        h=glob.glob(f'forex4k/z*/*/{s}_{y}/*/report/*.htm')[0]
        day=collections.defaultdict(float)
        for e in load_deals(h): day[e[0][:10]]+=e[1]
        py[y]=curve(day,y)
    add(lab,4000,py)
json.dump([(n,d,[(y,k,dd,b,float(f)) for y,k,dd,b,f in o]) for n,d,o in rows],open('raddoppio.json','w'),default=float)
for n,d,o in rows:
    print(n,d)
    for y,k,dd,b,f in o:
        print('   ',y,'raddoppia in',k,'giorni' if k else '— mai','| DD realizzato fino al raddoppio',round(dd),'%','(>=50%)' if b else '','| netto anno',round(f))
