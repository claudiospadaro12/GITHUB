# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
import itertools,json,sys,pickle,os
from tre_lib import *
YY=('2013','2020','2025'); DEP=80000.0; LIM=0.043*DEP
COST={'GR':36,'PH':36,'GB':36,'GTP':36,'DTP':4,'STAB':4,'LUNA':4}   # EUR/lotto andata-ritorno, scenario centrale (costi_prop.py)
MEM=[('GR','L0'),('GR','L2'),('GR','L3'),('PH','L0'),('PH','L1'),('PH','L2'),('PH','L3'),('GB','L0'),('GB','L2'),('GB','L3'),('GTP','COMBO'),('DTP','on'),('STAB','low'),('LUNA','on')]
cache='tre_cache2.pkl'
if os.path.exists(cache): D=pickle.load(open(cache,'rb'))
else:
    D={}
    for e,lv in MEM:
        for y in YY:
            p=path(e,lv,y)
            if not p: print('manca',e,lv,y); continue
            D[(e,lv,y)]=deals(p)
    pickle.dump(D,open(cache,'wb'))
def series(e,lv,y,cost=True):
    """lista di (tempo, valore dopo costo, dr, vol, ty, sym)"""
    out=[]
    for x in D[(e,lv,y)]:
        v=x['v']-(COST[e]*x['vol']/2 if cost else 0)   # meta del costo all'apertura e meta alla chiusura
        out.append((x['t'],v,x['dr'],x['vol'],x['ty'],x['sym']))
    return out
def metrics(members,cost=True):
    res=dict(net=[],pf=[],worst=0,n43=0,n5=0,rd=0,nd=0)
    GP=GL=0.0
    for y in YY:
        ev=[]
        for e,lv in members: ev+=series(e,lv,y,cost)
        ev.sort(key=lambda z:z[0])
        day=collections.defaultdict(float)
        gp=gl=0.0
        for t,v,dr,vol,ty,sym in ev:
            day[t[:10]]+=v
            if v>0 and dr=='out': gp+=v
            else: gl+=-v if v<0 else 0
        net=sum(day.values()); res['net'].append(net); res['pf'].append(gp/gl if gl else 0); GP+=gp; GL+=gl
        res['worst']=min(res['worst'],min(day.values())); res['n43']+=sum(1 for v in day.values() if v<=-LIM); res['n5']+=sum(1 for v in day.values() if v<=-0.05*DEP)
        c=0;pk=0;dd=0
        for d in sorted(day): c+=day[d];pk=max(pk,c);dd=max(dd,pk-c)
        res['rd']=max(res['rd'],dd)
    res['pftot']=GP/GL if GL else 0; res['avg']=sum(res['net'])/len(YY)
    return res
if __name__=='__main__':
    for m in [[('GB','L0')],[('PH','L1')],[('GR','L0')] if ('GR','L0') in [(a,b) for a,b in MEM] else [('GR','L2')],[('GR','L2'),('PH','L2'),('GB','L2')]]:
        r=metrics(m);print(m,[round(x) for x in r['net']],'PF',round(r['pftot'],2),'worst',round(100*r['worst']/DEP,1),'n43',r['n43'],'rd',round(100*r['rd']/DEP,1))
