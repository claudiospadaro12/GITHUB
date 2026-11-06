exec(open('equity_vero.py').read())
import glob,json
DEP=80000;S=2
def path(e,lv,y):
    if e=='DTP': return glob.glob(f'wim_risultati/ANNO80K_WIM_PACCHETTO_20261104_2139/DTP_DaytradeProMax9DDlowrisk_{y}/*/report/*.htm')[0]
    if e=='GTP': return glob.glob(f'gtp_anni/{y}_M1_GTP_COMBO/*/report/*.htm')[0]
    return glob.glob(f'oro/z*/*/{lv}_{e}_80000_{y}/*/report/*.htm')[0]
COMBO={'P1':[('PH','L1'),('GB','L0'),('DTP','on')],'P2':[('GR','L3'),('PH','L3'),('GB','L0'),('DTP','on')],'P3':[('GB','L3'),('GTP','COMBO'),('DTP','on')],'P4':[('GR','L3'),('GB','L0'),('DTP','on')],'P5':[('PH','L0'),('GB','L0'),('DTP','on')]}
cache={}
def ea_eq(e,lv,y):
    k=(e,lv,y)
    if k not in cache:
        a,c,info=equity_ea(path(e,lv,y),y,DEP);cache[k]=(a-DEP,c-DEP,info['T'])
    return cache[k]
res={}
for c,mem in COMBO.items():
    res[c]={}
    for y in ('2013','2025'):
        adv=0;cl=0
        for e,lv in mem:
            a,cc,T=ea_eq(e,lv,y);adv=adv+a;cl=cl+cc
        adv=adv*S;cl=cl*S   # scala a 160k
        eq=DEP*S+adv;eqc=DEP*S+cl
        pk=np.maximum.accumulate(eq);dd=(pk-eq).max();ddi=int((pk-eq).argmax())
        minloss=DEP*S-eq.min();mini=int(eq.argmin())
        days=T.astype('datetime64[D]');ud=np.unique(days)
        worst=(0,None);cnt={2:0,3:0,4.3:0,5:0};loss=[]
        for d in ud:
            m=np.where(days==d)[0];i0=m[0]
            start=eqc[i0-1] if i0>0 else DEP*S
            l=start-eq[m].min();loss.append(l)
            if l>worst[0]: worst=(l,str(d))
            for k in cnt:
                if l>=k/100*(DEP*S): cnt[k]+=1
        res[c][y]=dict(dd=dd,dd_date=str(T[ddi]),minloss=minloss,min_date=str(T[mini]),worst_day=worst[0],worst_day_date=worst[1],cnt=cnt,final=eq[-1]-DEP*S)
        r=res[c][y];print(c,y,'DD equity',round(r['dd']),f"{100*r['dd']/(DEP*S):.1f}%",r['dd_date'][:10],'| perdita max dall iniziale',round(r['minloss']),f"{100*r['minloss']/(DEP*S):.1f}%",r['min_date'][:10],'| peggior giorno in equity',round(r['worst_day']),f"{100*r['worst_day']/(DEP*S):.1f}%",r['worst_day_date'],'| giorni >=2/3/4.3/5%',r['cnt'][2],r['cnt'][3],r['cnt'][4.3],r['cnt'][5],'| netto anno',round(r['final']))
json.dump(res,open('equity_combo.json','w'),default=float)

print('\nGIORNI con perdita in equity >=3% (a 160k)')
for c,mem in COMBO.items():
    for y in ('2013','2025'):
        adv=0;cl=0
        for e,lv in mem:
            a,cc,T=ea_eq(e,lv,y);adv=adv+a;cl=cl+cc
        eq=DEP*S+adv*S;eqc=DEP*S+cl*S
        days=T.astype('datetime64[D]');out=[]
        for d in np.unique(days):
            m=np.where(days==d)[0];i0=m[0];start=eqc[i0-1] if i0>0 else DEP*S
            l=start-eq[m].min()
            if l>=0.03*DEP*S: out.append((str(d),round(l),round(100*l/(DEP*S),1)))
        print(c,y,out)
