import sys,glob,itertools,csv
import numpy as np,pandas as pd
base='/home/user/GITHUB/backtest_runner/simulatore/'
s1=open(base+'dowraptor_nostro_griglia.py').read(); s1=s1[:s1.index("Ns=(16,24,48)")]
s2=open(base+'dowraptor_apertura_usa.py').read(); s2=s2[:s2.index("if __name__")]
s2=s2.replace("pd.Timedelta(hours=14 if us_dst(x) else 15,minutes=30)","pd.Timedelta(hours=16,minutes=30)")
assert "hours=16,minutes=30" in s2
def loadf():
    fr=[pd.read_csv(f,sep=';') for f in sorted(glob.glob('/tmp/claude-0/ftmo/x/ABTG_M1_US30.cash_20*.csv'))]
    d=pd.concat(fr); d['time']=pd.to_datetime(d['time'],format='%Y.%m.%d %H:%M'); d=d.drop_duplicates('time').set_index('time').sort_index()
    d['spread']=d['spread'].where(d['spread']>0,200)   # 2,0 punti dove manca
    return d
g1={}; exec(s1,g1); g2={}; exec(s2,g2)
g1['Ns']=(16,24,48); g1['Cs']=(0.0,0.8); g1['Ms']=(1.5,2.5); g1['Ts']=(2.0,3.0)
g1['grid']=list(itertools.product(range(3),range(2),range(2),range(2)))
def _lab1(g): return 'N%d c%s s%.1f t%.0f'%(g1['Ns'][g[0]],('off' if g1['Cs'][g[1]]==0 else '0.8'),g1['Ms'][g[2]],g1['Ts'][g[3]])
def _nb1(g):
    out=[]
    for k,m in enumerate((3,2,2,2)):
        for dd in (-1,1):
            x=list(g); x[k]+=dd
            if 0<=x[k]<m: out.append(tuple(x))
    return out
g1['lab']=_lab1; g1['nb']=_nb1
d=loadf()
WIN={'IS':('2019-11-01','2022-12-31 23:59'),'OOS':('2023-01-01','2025-03-31 23:59'),'HO':('2025-04-01','2026-11-13 23:59')}
def win(tr,w): a,b=map(pd.Timestamp,WIN[w]); return [R for t,R,*_ in tr if a<=t<=b]
st=g1['st']
def report(name,grid,runf,lab,nb,minIS,minOOS,minHO,out):
    res={}
    for g in grid:
        tr=runf(g); res[g]={w:st(win(tr,w)) for w in ('IS','OOS')}
    print('=====',name,'| cella | IS n PF R | OOS n PF R | G1 G2 plateau')
    fin=[]
    for g in sorted(grid,key=lambda g:-res[g]['IS'][1]):
        a=res[g]['IS']; b=res[g]['OOS']; q1=a[0]>=minIS and a[1]>=1.2; q2=b[0]>=minOOS and b[1]>=1.1 and b[2]>0
        nbs=nb(g); pl=sum(1 for q in nbs if res[q]['IS'][1]>1.0 and res[q]['OOS'][1]>1.0)/len(nbs)
        print('%-26s | %4d %.2f %+7.1f | %4d %.2f %+7.1f | %s %s %.2f'%(lab(g),a[0],a[1],a[2],b[0],b[1],b[2],q1,q2,pl))
        if q1 and q2 and pl>=0.7: fin.append(g)
    print('FINALISTI',name,':',[lab(g) for g in fin],'| IS PF mediano',round(float(np.median([res[g]['IS'][1] for g in grid])),2),'| OOS PF mediano',round(float(np.median([res[g]['OOS'][1] for g in grid])),2),'| IS PF>=1.2:',sum(1 for g in grid if res[g]['IS'][1]>=1.2),flush=True)
    with open(out,'w',newline='') as f:
        w=csv.writer(f,delimiter=';'); w.writerow(['cella','nIS','pfIS','RIS','nOOS','pfOOS','ROOS'])
        for g in grid: w.writerow([lab(g)]+[round(x,3) if isinstance(x,float) else x for x in res[g]['IS']+res[g]['OOS']])
    return fin
# famiglia 1: barre M15
r15=d.resample('15min').agg({'open':'first','high':'max','low':'min','close':'last','spread':'first'}).dropna()
f1=report('FAMIGLIA 1 canale M15',g1['grid'],lambda g:g1['sim'](r15,g1['Ns'][g[0]],g1['Cs'][g[1]],g1['Ms'][g[2]],g1['Ts'][g[3]]),g1['lab'],g1['nb'],200,100,60,'/home/user/GITHUB/report/DOWRAPTOR_FTMO_dati_fam1.csv')
f2=report('FAMIGLIA 2 apertura USA',g2['grid'],lambda g:g2['run'](d,g2['Rs'][g[0]],g2['Ts'][g[1]],g2['Ss'][g[2]],g2['Es'][g[3]]),g2['lab'],g2['nb'],150,80,40,'/home/user/GITHUB/report/DOWRAPTOR_FTMO_dati_fam2.csv')
import pickle; pickle.dump((f1,f2),open('/tmp/claude-0/ftmo/fin.pkl','wb'))
