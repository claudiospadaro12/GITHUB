import json,itertools,collections,numpy as np,datetime as dt
exec(open('combo6.py').read().split("OPT={")[0].replace("print(","(lambda *a,**k:None)("))
YY=('2013','2020','2025')
def arr(e,lv,y):
    r=get(e,lv,y);n=366 if int(y)%4==0 else 365;d0=dt.date(int(y),1,1)
    a=np.zeros(n)
    for d,v in r['daily'].items():
        i=(dt.date(int(d[:4]),int(d[5:7]),int(d[8:10]))-d0).days
        if 0<=i<n: a[i]+=v
    return a
LV={'GR':('L0','L1','L2','L3'),'PH':('L0','L1','L2','L3'),'GB':('L0','L1','L2','L3'),'GTP':('COMBO','PROPFIRM','LOWRISK'),'DTP':('on',),'LUNA':('on',)}
A={(e,lv):{y:arr(e,lv,y) for y in YY} for e in LV for lv in LV[e]}
LIM=0.043*DEP
def acct(members):  # members: list of (e,lv)
    nets=[];worst=0;n43=0;rd=0
    for y in YY:
        s=sum(A[m][y] for m in members)
        nets.append(s.sum());worst=min(worst,s.min());n43+=int((s<=-LIM).sum())
        c=np.cumsum(s);pk=np.maximum.accumulate(np.maximum(c,0));rd=max(rd,(pk-c).max())
    return dict(nets=nets,sum=sum(nets),worst=worst,n43=n43,rd=rd)
cache={}
def acc(members):
    k=tuple(sorted(members))
    if k not in cache: cache[k]=acct(list(k))
    return cache[k]
def run(EAS,ddlim,top=8):
    best=[]
    for assign in itertools.product(range(3),repeat=len(EAS)):
        if len(set(assign))<3: continue
        for lvs in itertools.product(*[LV[e] for e in EAS]):
            groups=[[ (e,lv) for e,lv,a in zip(EAS,lvs,assign) if a==g] for g in range(3)]
            rs=[acc(g) for g in groups]
            if any(r['n43']>0 or r['rd']>ddlim for r in rs): continue
            key=tuple(sorted(tuple(sorted(g)) for g in groups))
            rs=[acc(list(g)) for g in key];best.append((min(r['sum'] for r in rs),sum(r['sum'] for r in rs),key,rs))
    seen=set();out=[]
    for b in sorted(best,key=lambda x:(-x[0],-x[1])):
        if b[2] in seen: continue
        seen.add(b[2]);out.append(b)
        if len(out)>=top: break
    return out,len(best)
nm={'L0':'Prop','L1':'Grad.1','L2':'Medium','L3':'Combo','COMBO':'Combo','PROPFIRM':'Prop','LOWRISK':'Low','on':''}
def lab(g): return ' + '.join(({'GR':'Reaper','PH':'Phantom','GB':'Goldbot','GTP':'GTP','DTP':'DaytradePro Max9','LUNA':'Luna 4DD'}[e]+((' '+nm[lv]) if nm[lv] else '')) for e,lv in g)
def show(out,n):
    print('combinazioni valide',n)
    for mn,tot,key,rs in out:
        print(f'--- min conto {mn:,.0f}  totale {tot:,.0f}')
        for g,r in zip(key,rs):
            print('   ',lab(g),'|',' / '.join(f"{x:,.0f}" for x in r['nets']),'|',f"{r['sum']:,.0f}",'| worst',f"{100*r['worst']/DEP:.1f}%",'| DD',f"{100*r['rd']/DEP:.1f}%")
print('=== STRETTO: DD realizzato <=8% (6400), 5 EA senza Luna');out,n=run(['GR','PH','GB','GTP','DTP'],6400,6);show(out,n)
print('\n=== RILASSATO: con Luna, DD<=16% (12800)');out,n=run(['GR','PH','GB','GTP','DTP','LUNA'],12800,6);show(out,n)

print('\n=== VISTA COMPLESSIVA 3 CONTI (somma dei giorni sui tre conti)')
SER={'S1':[[('DTP','on'),('GTP','COMBO')],[('GB','L0'),('GR','L3')],[('PH','L1')]],
 'S2':[[('DTP','on'),('GTP','COMBO')],[('GB','L0')],[('GR','L3'),('PH','L1')]],
 'S3':[[('DTP','on'),('GR','L3')],[('GB','L3'),('GTP','COMBO')],[('PH','L1')]],
 'S4':[[('DTP','on'),('GR','L3')],[('GB','L0')],[('GTP','COMBO'),('PH','L3')]],
 'S5':[[('DTP','on'),('GTP','COMBO')],[('GB','L0'),('LUNA','on')],[('GR','L3'),('PH','L1')]]}
for k,S in SER.items():
    tot=0;worst=0;per=[];gg=0
    rows=[]
    for g in S:
        r=acc(g);rows.append(r)
    allw=[]
    for y in YY:
        s=sum(sum(A[m][y] for m in g) for g in S)
        worst=min(worst,s.min());tot+=s.sum()
        c=np.cumsum(s);pk=np.maximum.accumulate(np.maximum(c,0));allw.append((pk-c).max())
    # giorni in cui tutti e tre i conti sono in perdita
    allneg=0;anyneg=0
    for y in YY:
        ss=[sum(A[m][y] for m in g) for g in S]
        allneg+=int(sum(1 for i in range(len(ss[0])) if all(x[i]<0 for x in ss)))
    print(k,'totale 3 anni',round(tot),'peggior giorno sui 3 conti',round(worst),f"{100*worst/(3*DEP):.2f}% di 240k",'DD realizzato complessivo max',round(max(allw)),f"{100*max(allw)/(3*DEP):.2f}%",'giorni con 3 conti in perdita',allneg)
