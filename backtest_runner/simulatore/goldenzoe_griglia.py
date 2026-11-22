import sys,os,datetime as dt,itertools,csv
SW=float(os.environ.get('SW','0.055'))
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from universal_scalper_all import load_m1,resample,prep
from tre_leve import entries_breakout
d=load_m1(['/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv'],';')
r=resample(d,'4h'); O,H,L,C,atr,sig,ha,ks=prep(r)
def P(x): return dt.datetime.strptime(x,'%Y.%m.%d %H:%M')
def trade(entries,mi,mt,cost=0.35):
    n=len(C); out=[]; pos=0
    for i in range(120,n-1):
        if pos==0:
            if entries[i]!=1 or np.isnan(atr[i]): continue
            ent=O[i+1]; risk=mi*atr[i]
            if risk<=0: continue
            pos=1; stop=ent-risk; ext=ent; t0=ks[i+1]; start=i+1
        if pos==1 and i>=start:
            if L[i]<=stop:
                px=min(O[i],stop); days=(P(ks[i])-P(t0)).total_seconds()/86400
                R=(px-ent)/risk-cost/risk-(SW/360)*days*ent/risk
                out.append((t0,R)); pos=0; continue
            ext=max(ext,H[i]); stop=max(stop,ext-mt*atr[i])
    return out
per=lambda y:'A' if y<'2014.11' else ('B' if y<'2021' else 'C')
def st(v):
    v=np.array(v)
    if len(v)<2: return len(v),0.0,0.0
    g=v[v>0].sum(); l=-v[v<0].sum(); return len(v),(g/l if l>0 else 99.0),v.mean()
Ns=(30,40,55,80); MI=(2,3,4); MT=(2,3,4,5); res={}
for N in Ns:
    e=entries_breakout(C,H,L,N); e=np.where(e==1,1,0)
    for mi in MI:
        for mt in MT:
            tr=trade(e,mi,mt); res[(N,mi,mt)]={p:st([R for t,R in tr if per(t)==p]) for p in 'ABC'}
            res[(N,mi,mt)]['AB']=st([R for t,R in tr if per(t) in 'AB']); res[(N,mi,mt)]['all']=st([R for t,R in tr])
base=res[(55,3,3)]
def idx(k): return (Ns.index(k[0]),MI.index(k[1]),MT.index(k[2]))
def neigh(k):
    a,b,c=idx(k); out=[]
    for da,db,dc in ((1,0,0),(-1,0,0),(0,1,0),(0,-1,0),(0,0,1),(0,0,-1)):
        x,y,z=a+da,b+db,c+dc
        if 0<=x<4 and 0<=y<3 and 0<=z<4: out.append((Ns[x],MI[y],MT[z]))
    return out
def ok(k): v=res[k]; return v['A'][0]>=50 and v['B'][0]>=50 and v['A'][1]>=1.2 and v['B'][1]>=1.2
def plateau(k):
    nb=neigh(k); g=sum(1 for q in nb if res[q]['A'][1]>=1.1 and res[q]['B'][1]>=1.1); return g/len(nb)>=0.7,g/len(nb)
bm=min(base['A'][1],base['B'][1])
rows=[]
print('base N55/mi3/mt3: A n%d PF %.2f | B n%d PF %.2f | C n%d PF %.2f R %+.3f | tutto n%d PF %.2f'%(base['A'][0],base['A'][1],base['B'][0],base['B'][1],base['C'][0],base['C'][1],base['C'][2],base['all'][0],base['all'][1]))
for k,v in sorted(res.items(),key=lambda kv:-min(kv[1]['A'][1],kv[1]['B'][1])):
    pl,fr=plateau(k); idon=ok(k)
    cand=idon and pl and min(v['A'][1],v['B'][1])>=bm+0.10 and (v['A'][0]+v['B'][0])>=0.8*(base['A'][0]+base['B'][0])
    conf=cand and v['C'][1]>=base['C'][1] and v['C'][1]>=1.3 and v['C'][2]>0
    rows.append((k,v,idon,pl,fr,cand,conf))
print('N mi mt | nA PFA | nB PFB | nC PFC RC | idonea plateau(frac) cand CONF')
for k,v,idon,pl,fr,cand,conf in rows[:20]:
    print('%d %d %d | %d %.2f | %d %.2f | %d %.2f %+.3f | %s %s(%.2f) %s %s'%(k+(v['A'][0],v['A'][1],v['B'][0],v['B'][1],v['C'][0],v['C'][1],v['C'][2],idon,pl,fr,cand,conf)))
print('candidati:',[k for k,v,i,p,f,c,cf in rows if c],'| confermati:',[k for k,v,i,p,f,c,cf in rows if cf])
bestC=max(res,key=lambda k:res[k]['C'][1]); bestAB=rows[0][0]
print('best AB',bestAB,'best C',bestC,'idonee',sum(1 for r in rows if r[2]),'su 48')
# sensibilita per parametro: media PF_min (A,B) per valore
for name,pos,vals in (('N',0,Ns),('mi',1,MI),('mt',2,MT)):
    print(name,{v:round(np.mean([min(res[k]['A'][1],res[k]['B'][1]) for k in res if k[pos]==v]),3) for v in vals})
import os; os.makedirs('/home/user/GITHUB/report/GOLDENZOE_GRIGLIA_dati',exist_ok=True)
with open('/home/user/GITHUB/report/GOLDENZOE_GRIGLIA_dati/griglia%s.csv'%('' if SW==0.055 else '_swap%d'%round(SW*1000)),'w',newline='') as f:
    w=csv.writer(f,delimiter=';'); w.writerow(['N','mi','mt','nA','pfA','nB','pfB','nC','pfC','RC','idonea','plateau','frac','candidato','confermato'])
    for k,v,idon,pl,fr,cand,conf in rows: w.writerow(list(k)+[v['A'][0],round(v['A'][1],3),v['B'][0],round(v['B'][1],3),v['C'][0],round(v['C'][1],3),round(v['C'][2],4),idon,pl,round(fr,2),cand,conf])
print('--- confronto base / confermati (tutto 2004-2026): n PF R t ; AB n PF')
def tstat(k):
    e=entries_breakout(C,H,L,k[0]); e=np.where(e==1,1,0); v=np.array([R for t,R in trade(e,k[1],k[2])]); return v.mean()/(v.std(ddof=1)/np.sqrt(len(v)))
for k in ((55,3,3),(55,2,4),(55,3,4),(40,3,3)):
    v=res[k]; print(k,'tutto n%d PF %.2f R %+.3f t %.2f | AB n%d PF %.2f | C n%d PF %.2f'%(v['all'][0],v['all'][1],v['all'][2],tstat(k),v['AB'][0],v['AB'][1],v['C'][0],v['C'][1]))
