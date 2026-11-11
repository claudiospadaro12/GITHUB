# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
import itertools,pickle
from tre_calc import *
mc=pickle.load(open('tre_mc.pkl','rb'))['mc']
def m(members):
    k=tuple(sorted(members))
    if k not in mc: mc[k]=metrics(list(k))
    return mc[k]
OPT={'GR':[None,'L0','L3'],'PH':[None,'L0','L1','L3'],'GB':[None,'L0','L3'],'GTP':[None,'COMBO'],'DTP':[None,'on']}
EA=list(OPT)
WORST=-0.036*DEP; RD=0.060*DEP; PFMIN=1.5
S={}
for lvs in itertools.product(*[OPT[e] for e in EA]):
    act=[(e,l) for e,l in zip(EA,lvs) if l]
    if len(act)<3: continue
    for ass in itertools.product(range(3),repeat=len(act)):
        if len(set(ass))<3: continue
        g=[[act[i] for i in range(len(act)) if ass[i]==a] for a in range(3)]
        key=tuple(sorted(tuple(sorted(x)) for x in g))
        if key in S: continue
        rs=[m(x) for x in key]
        if any(r['n43']>0 or r['worst']<WORST or r['rd']>RD or r['pftot']<PFMIN for r in rs): continue
        S[key]=rs
print('portafogli con criteri stretti:',len(S))
res=[]
for key,rs in S.items():
    av=[r['avg'] for r in rs]
    # 160k sul conto con PF piu alto (solido), poi 80k gli altri
    i=max(range(3),key=lambda j:rs[j]['pftot'])
    res.append((2*av[i]+sum(av)-av[i],i,key,rs))
res.sort(key=lambda x:-x[0])
def show(x):
    tot,i,key,rs=x
    print('--- totale/anno',round(tot),'(160k su',' + '.join(a+'_'+b for a,b in key[i]),')')
    for j,k in enumerate(key):
        r=rs[j];print('   ','160k' if j==i else ' 80k',' + '.join(a+'_'+b for a,b in k),'| avg',round(r['avg']),'PF',round(r['pftot'],2),'worst',round(100*r['worst']/DEP,1),'rd',round(100*r['rd']/DEP,1),[round(n) for n in r['net']])
for x in res[:10]: show(x)
pickle.dump(res[:60],open('tre_top.pkl','wb'))
