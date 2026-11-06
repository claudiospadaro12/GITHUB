exec(open('prop3.py').read().split("def acct(")[0])
import numpy as np
ACC={'A':[('DTP','on'),('GR','L3')],'B':[('GB','L0')],'C':[('GTP','COMBO'),('PH','L3')]}
def ops(e,lv,y):
    if e=='DTP': return d80[f'DTP_DaytradeProMax9DDlowrisk_{y}']['trades']
    if e=='GTP': return G[f'{lv}_{y}']['ops']
    return R[f'{lv}_{e}_{DEP}_{y}']['ops']
for k,mem in ACC.items():
    w=[]
    for y in YY:
        s=sum(A[m][y] for m in mem);cs=np.concatenate([[0],np.cumsum(s)])
        w+=[cs[i+56]-cs[i] for i in range(len(s)-56)]
    w=np.array(w)
    o=[sum(ops(e,lv,y) for e,lv in mem) for y in YY]
    print(k,'ops/anno',o,'a settimana',round(np.mean(o)/52,1),'| 8 sett: min',round(w.min()),'P10',round(np.percentile(w,10)),'mediana',round(np.median(w)),'P90',round(np.percentile(w,90)),'% negative',round(100*np.mean(w<0)),'| 8sett in % di 80k: mediana',round(100*np.median(w)/DEP,1),'P10',round(100*np.percentile(w,10)/DEP,1))
# complessivo e giorni 3 conti in perdita
tot=0
for y in YY:
    ss=[sum(sum(A[m][y] for m in mem) for mem in [v]) for v in ACC.values()]
    n=len(ss[0]);tot+=n
print('quota giorni con 3 conti in perdita (S4): 36 su',tot,'=',round(100*36/tot,1),'%')
# giorni di trading effettivi: giorni con P&L !=0
nz=sum(int(((sum(sum(A[m][y] for m in v) for v in [list(ACC.values())[0]])!=0)).sum()) for y in YY)
