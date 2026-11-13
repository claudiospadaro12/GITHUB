s=open('equity_livelli.py').read()
ns={}; exec(s[:s.index("LV=['L0'")],ns)
np=ns['np']; ea_eq=ns['ea_eq']; DEP=ns['DEP']
import sys,collections,statistics as st,datetime as dt,itertools,json,pickle
sys.path.insert(0,'.')
from tre_lib import deals,path
COST=36.0
YEARS=('2013','2018','2020','2025')
EAS={'GB':('L0','L1','L2','L3'),'PH':('L0','L1','L2','L3'),'GR':('L0','L1','L2','L3')}
KEYS=[(e,lv) for e in EAS for lv in EAS[e]]+[('GTP','COMBO')]
D={}   # (y) -> dict
for y in YEARS:
    arr={}; T0=None
    for e,lv in KEYS:
        a,cc,T,info=ea_eq(e,lv,y)
        if T0 is None: T0=T
        assert len(T)==len(T0)
        arr[(e,lv)]=(a,cc)
    days=T0.astype('datetime64[D]'); u,idx=np.unique(days,return_index=True)
    ends=np.append(idx[1:]-1,len(T0)-1)
    # costi per giorno
    cost={}
    for e,lv in KEYS:
        d=collections.defaultdict(float)
        for x in deals(path(e,lv,y)):
            k=np.datetime64(x['t'][:10].replace('.','-'))
            d[k]+=COST*x['vol']/2
        cost[(e,lv)]=np.array([d.get(k,0.0) for k in u])
    D[y]=dict(arr=arr,u=u,idx=idx,ends=ends,cost=cost)
def series(mem,y,k):
    d=D[y]; A=0;C=0;cs=0
    for m in mem:
        a,cc=d['arr'][m]; A=A+a; C=C+cc; cs=cs+d['cost'][m]
    lowd=np.minimum.reduceat(np.minimum(A,C),d['idx'])
    close=C[d['ends']]; inc=np.diff(np.concatenate([[0.0],close])); prev=np.concatenate([[0.0],close[:-1]])
    low=lowd-prev
    return inc-k*cs, low-k*cs
def sim(inc,low,u,tgt):
    n=len(u); res=[]
    for s in range(n):
        if str(u[s])[5:]>'03-31': break
        c=np.cumsum(inc[s:]); prev=c-inc[s:]
        el=(u[s:]-u[s]).astype('timedelta64[D]').astype(int)+1
        fm=(low[s:]<=-0.05*DEP)|(prev+low[s:]<=-0.10*DEP)
        pm=(c>=tgt*DEP)&(el>=4)
        fi=np.argmax(fm) if fm.any() else 10**9
        pi=np.argmax(pm) if pm.any() else 10**9
        if fi==10**9 and pi==10**9: res.append(('C',None))
        elif fi<=pi: res.append(('F',int(el[fi])))
        else: res.append(('P',int(el[pi])))
    return res
def evalc(mem,k):
    out={}
    r10=[];r5=[];net=0;n45=0
    for y in YEARS:
        inc,low=series(mem,y,k); u=D[y]['u']
        r10+=sim(inc,low,u,0.10); r5+=sim(inc,low,u,0.05); net+=inc.sum()
        # giorni con perdita >=4,5% (equity, dal giorno precedente)
        n45+=int((low<=-0.045*DEP).sum())
    def summ(r):
        n=len(r); p=[x[1] for x in r if x[0]=='P']; f=sum(1 for x in r if x[0]=='F'); c=sum(1 for x in r if x[0]=='C')
        return dict(pass_=100*len(p)/n,fail=100*f/n,open_=100*c/n,med=(float(np.median(p)) if p else None),p75=(float(np.percentile(p,75)) if p else None))
    return dict(s10=summ(r10),s5=summ(r5),net=net/len(YEARS),n45=n45)
RES={}
for gb in (None,)+EAS['GB']:
  for ph in (None,)+EAS['PH']:
    for gr in (None,)+EAS['GR']:
      for gt in (None,'COMBO'):
        mem=[m for m in ((('GB',gb) if gb else None),(('PH',ph) if ph else None),(('GR',gr) if gr else None),(('GTP','COMBO') if gt else None)) if m]
        if not mem: continue
        key='|'.join('%s_%s'%m for m in mem)
        RES[key]={ 'c1':evalc(mem,1.0), 'c0':evalc(mem,0.0), 'c2':evalc(mem,2.0)}
pickle.dump(RES,open('bundle_res.pkl','wb'))
print(len(RES))
