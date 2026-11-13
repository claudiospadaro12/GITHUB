s=open('equity_livelli.py').read()
ns={}; exec(s[:s.index("LV=['L0'")],ns)
np=ns['np']; ea_eq=ns['ea_eq']; DEP=ns['DEP']
import sys,glob,collections,statistics as st,datetime as dt,json
sys.path.insert(0,'.')
from tre_lib import deals,path
COST={'GB':36,'PH':36,'GR':36,'GTP':36,'DTP':4}
def gold(mem,y):
    cl=0;adv=0
    for e,lv in mem:
        a,cc,T,info=ea_eq(e,lv,y); adv=adv+a; cl=cl+cc
    days=T.astype('datetime64[D]'); u=np.unique(days); close=[];low=[];prev=0.0
    for d in u:
        m=np.where(days==d)[0]; low.append(min(adv[m].min(),cl[m].min())-prev); close.append(cl[m[-1]]); prev=cl[m[-1]]
    close=np.array(close); inc=np.diff(np.concatenate([[0],close]))
    return {str(d):(float(i),float(l)) for d,i,l in zip(u,inc,low)}
def dealday(e,lv,y):
    d=collections.defaultdict(float); c=collections.defaultdict(float)
    for x in deals(path(e,lv,y)):
        k=x['t'][:10].replace('.','-'); d[k]+=x['v']; c[k]+=COST[e]*x['vol']/2
    return d,c
BASE={'P1 160k':[('PH','L1'),('GB','L0')],'P3 80k':[('GB','L3'),('GTP','COMBO')],'P4 80k':[('GR','L3'),('GB','L0')]}
BOOST={'P1 160k':[('PH','L1'),('GB','L1')],'P3 80k':[('GB','L1'),('GTP','COMBO')],'P4 80k':[('GR','L1'),('GB','L1')]}
YEARS=('2013','2020','2025')
def series(mem,y,k):
    g=gold(mem,y); dd,dc=dealday('DTP','on',y)
    cost=collections.defaultdict(float)
    for e,lv in mem:
        _,c=dealday(e,lv,y)
        for kk,v in c.items(): cost[kk]+=v
    for kk,v in dc.items(): cost[kk]+=v
    out={}
    for kk in set(g)|set(dd):
        gi,gl=g.get(kk,(0.0,0.0)); di=dd.get(kk,0.0); c=k*cost.get(kk,0.0)
        out[kk]=(gi+di-c,gl+min(di,0.0)-c)
    return out
def run(sb,so,tgt,N):
    dates=sorted(set(sb)|set(so)); res=[]
    for s in range(len(dates)):
        if dates[s][5:]>'03-31': break
        d0=dt.date.fromisoformat(dates[s]); cum=0;out=('C',None)
        for kk in range(s,len(dates)):
            dk=dt.date.fromisoformat(dates[kk]); ser=sb if (N is None or kk-s<N) else so
            inc,low=ser.get(dates[kk],(0.0,0.0))
            if low<=-0.05*DEP or cum+low<=-0.10*DEP: out=('F',(dk-d0).days+1);break
            cum+=inc
            if cum>=tgt*DEP and (dk-d0).days+1>=4: out=('P',(dk-d0).days+1);break
        res.append(out)
    return res
OUT={}
for nm in BASE:
    print(nm)
    for k,lab in ((1,'costi centrali'),(2,'costi prudenti')):
        for N,l2 in ((None,'solo Prop'),(2,'2 giorni Prop poi L1')):
            row=[]
            for t in (0.10,0.05):
                r=[]
                for y in YEARS: r+=run(series(BASE[nm],y,k),series(BOOST[nm],y,k),t,N)
                n=len(r); p=[x[1] for x in r if x[0]=='P']; f=sum(1 for x in r if x[0]=='F'); c=sum(1 for x in r if x[0]=='C')
                row.append((100*len(p)/n,100*f/n,100*c/n,st.median(p) if p else None,np.percentile(p,25) if p else None,np.percentile(p,75) if p else None,max(p) if p else None))
            OUT[(nm,lab,l2)]=row
            a,b=row
            print('  %-15s %-22s | +10%%: passa %3.0f%% falli %2.0f%% aperto %2.0f%% gg mediana %3s (25-75: %s-%s, max %s) | +5%%: passa %3.0f%% falli %2.0f%% gg mediana %3s | totale ~%s'%(lab,l2,a[0],a[1],a[2],a[3] and int(a[3]),a[4] and int(a[4]),a[5] and int(a[5]),a[6],b[0],b[1],b[3] and int(b[3]),(int(a[3])+int(b[3])) if a[3] and b[3] else '-'))
json.dump({'|'.join(k):v for k,v in OUT.items()},open('l1_costi.json','w'),default=float)
