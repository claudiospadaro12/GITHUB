# Da lanciare dalla cartella di lavoro con oro/, gtp_anni/, wim_risultati/, oro_res.json, gtp_res.json, exp_all/ (vedi README del 11/11/2026). Uso: python3 -I
import itertools,pickle
from tre_calc import *
import tre_port as TP   # riusa overlap()
OPT={'GR':[None,'L0','L3'],'PH':[None,'L0','L1','L3'],'GB':[None,'L0','L3'],'GTP':[None,'COMBO']}
EA=list(OPT)
WORST=-0.036*DEP; RD=0.060*DEP
mc={}
def m(k):
    k=tuple(sorted(k))
    if k not in mc: mc[k]=metrics(list(k))
    return mc[k]
oc={}
def ov(a,b):
    ka=(tuple(sorted(a)),tuple(sorted(b)))
    if ka not in oc:
        h=0;e=0
        for y in YY:
            x,z=TP.overlap(list(a),list(b),y);h+=x;e+=z
        oc[ka]=(h,e)
    return oc[ka]
res=[]
for lvs in itertools.product(*[OPT[e] for e in EA]):
    act=[(e,l) for e,l in zip(EA,lvs) if l]
    if len(act)<2: continue
    for ass in itertools.product(range(2),repeat=len(act)):
        if ass[0]!=0 or len(set(ass))<2: continue
        g=[[act[i] for i in range(len(act)) if ass[i]==a] for a in range(2)]
        rs=[m(x) for x in g]
        if any(r['n43']>0 or r['worst']<WORST or r['rd']>RD or r['pftot']<1.5 for r in rs): continue
        h,e=ov(g[0],g[1])
        i=max(range(2),key=lambda j:rs[j]['pftot']) # 160k al PF migliore
        tot=2*rs[i]['avg']+rs[1-i]['avg']
        res.append((h,tot,i,g,rs,e))
print(len(res))
print('--- per ore di sovrapposizione crescenti (poi totale)')
for h,tot,i,g,rs,e in sorted(res,key=lambda x:(x[0],-x[1]))[:8]:
    print(round(h),'ore',e,'episodi | tot/anno',round(tot),'| 160k:',' + '.join(a+'_'+b for a,b in g[i]),'PF',round(rs[i]['pftot'],2),'avg',round(rs[i]['avg']),'| 80k:',' + '.join(a+'_'+b for a,b in g[1-i]),'PF',round(rs[1-i]['pftot'],2),'avg',round(rs[1-i]['avg']))
print('--- per totale decrescente')
for h,tot,i,g,rs,e in sorted(res,key=lambda x:-x[1])[:8]:
    print(round(h),'ore',e,'episodi | tot/anno',round(tot),'| 160k:',' + '.join(a+'_'+b for a,b in g[i]),'PF',round(rs[i]['pftot'],2),'avg',round(rs[i]['avg']),'| 80k:',' + '.join(a+'_'+b for a,b in g[1-i]),'PF',round(rs[1-i]['pftot'],2),'avg',round(rs[1-i]['avg']))
