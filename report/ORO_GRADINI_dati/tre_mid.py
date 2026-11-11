import itertools,sys
from tre_calc import *
import tre_port as TP
OPT={'GR':[None,'L0','L3'],'PH':[None,'L0','L1','L3'],'GB':[None,'L0','L3'],'GTP':[None,'COMBO'],'DTP':[None,'on']}
EA=list(OPT)
W=float(sys.argv[1]) if len(sys.argv)>1 else -0.040
RDM=float(sys.argv[2]) if len(sys.argv)>2 else 0.060
MAXREP=int(sys.argv[3]) if len(sys.argv)>3 else 2
V=[]
for lvs in itertools.product(*[OPT[e] for e in EA]):
    act=tuple((e,l) for e,l in zip(EA,lvs) if l)
    if not act: continue
    r=metrics(list(act))
    if r['n43']>0 or r['worst']<W*DEP or r['rd']>RDM*DEP or r['pftot']<1.5: continue
    V.append((act,r))
print('conti validi (singolo conto):',len(V))
res=[]
for i,j,k in itertools.combinations_with_replacement(range(len(V)),3):
    cnt=collections.Counter(m for x in (i,j,k) for m in V[x][0])
    if max(cnt.values())>MAXREP: continue
    av=[V[x][1]['avg'] for x in (i,j,k)]
    # 160k sul conto col PF piu alto
    b=max(range(3),key=lambda t:V[(i,j,k)[t]][1]['pftot'])
    tot=2*av[b]+sum(av)-av[b]
    res.append((tot,(i,j,k),b))
res.sort(key=lambda x:-x[0])
print('portafogli:',len(res))
def joint(idx,b):
    out=[]
    CAP=320000.0
    worst=0;dd=0;n=0
    for y in YY:
        jd=collections.defaultdict(float)
        for t,x in enumerate(idx):
            k=2 if t==b else 1
            for d,v in TP.daily_acc(list(V[x][0]),y).items(): jd[d]+=v*k
        c=0;pk=0
        for d in sorted(jd): c+=jd[d];pk=max(pk,c);dd=max(dd,pk-c)
        worst=min(worst,min(jd.values()))
    return worst/CAP,dd/CAP
shown=0
for tot,idx,b in res[:400]:
    jw,jdd=joint(idx,b)
    if jw<-0.030 or jdd>0.050: continue
    ho=0
    ms=[list(V[x][0]) for x in idx]
    for (p,q) in [(0,1),(0,2),(1,2)]:
        for y in YY: ho+=TP.overlap(ms[p],ms[q],y)[0]
    print('--- totale/anno',round(tot),'| joint worst %.1f%% DD %.1f%% | ore opposte (somma coppie) %d'%(100*jw,100*jdd,ho))
    for t,x in enumerate(idx):
        r=V[x][1];print('   ','160k' if t==b else ' 80k',' + '.join(a+'_'+b_ for a,b_ in V[x][0]),'| avg',round(r['avg']),'PF',round(r['pftot'],2),'worst %.1f rd %.1f'%(100*r['worst']/DEP,100*r['rd']/DEP))
    shown+=1
    if shown>=5: break
