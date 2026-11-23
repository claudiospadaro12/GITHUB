#!/usr/bin/env python3
# Criteri: report/BTC_INTRADAY_CRITERI_2026-11-23.md. Hold-out 2025+ NON stampato salvo --holdout.
import sys,glob,numpy as np,pandas as pd
HOLD='--holdout' in sys.argv
CF=0.0006
fs=sorted(glob.glob('/tmp/claude-0/btc/ABTG_M1_BTCUSD_20[12][0-9].csv'))
fs=[f for f in fs if int(f[-8:-4])>=2017]
d=pd.concat([pd.read_csv(f,sep=';',names=['t','o','h','l','c','v','s'],header=0) for f in fs])
d['t']=pd.to_datetime(d['t'],format='%Y.%m.%d %H:%M'); d=d.set_index('t').sort_index()
d=d[~((d.index.hour==0)&(d.index.minute==0))]
h=d.resample('1h').agg({'o':'first','c':'last'}).dropna()
h['date']=h.index.date; h['hr']=h.index.hour
O=h.pivot(index='date',columns='hr',values='o'); C=h.pivot(index='date',columns='hr',values='c')
O.index=pd.to_datetime(O.index); C.index=pd.to_datetime(C.index)
cells={}
for s in (0,8,16):
    r=(C[s+7]/O[s]-1)
    cells['A long %02d-%02d'%(s,s+8)]=r-CF; cells['A short %02d-%02d'%(s,s+8)]=-r-CF
for x in (8,12,16):
    mom=np.sign(O[x]/O[0]-1); rr=(C[23]/O[x]-1)
    cells['B mom da %02d'%x]=mom*rr-CF; cells['B fade da %02d'%x]=-mom*rr-CF
dw=['lun','mar','mer','gio','ven','sab','dom']
full=(C[23]/O[0]-1)
for k in range(7):
    cells['C long '+dw[k]]=(full-CF)[full.index.dayofweek==k]
ref=((C[23]/O[0]-1)-CF)
def pf(r):
    r=r.dropna(); gp=r[r>0].sum(); gl=-r[r<0].sum(); return (gp/gl if gl>0 else np.inf),len(r)
def yrs(r,lo,hi):
    r=r.dropna(); r=r[(r.index.year>=lo)&(r.index.year<=hi)]; g=r.groupby(r.index.year).sum(); return (g>0).sum(),len(g)
oro=pd.read_csv('/tmp/claude-0/d1/D1_Oro.csv',sep=';',parse_dates=['date']).set_index('date').close.pct_change()
dow=pd.read_csv('/tmp/claude-0/d1/D1_Dow30.csv',sep=';',parse_dates=['date']).set_index('date').close.pct_change()
print('riferimento long 00-24 tutti i giorni: IS PF %.2f OOS PF %.2f'%(pf(ref[ref.index.year<=2021])[0],pf(ref[(ref.index.year>=2022)&(ref.index.year<=2024)])[0]))
print('cella                 | IS n  PF  anni+ | OOS n  PF  anni+ | meta1 meta2 | esito')
fin=[]
for k,r in cells.items():
    i=r[r.index.year<=2021]; o=r[(r.index.year>=2022)&(r.index.year<=2024)]
    p1,n1=pf(i); p2,n2=pf(o); a1=yrs(r,2017,2021); a2=yrs(r,2022,2024)
    m1=pf(r[(r.index.year>=2017)&(r.index.year<=2019)])[0]; m2=pf(r[(r.index.year>=2020)&(r.index.year<=2021)])[0]
    g1=n1>=150 and p1>=1.25 and a1[0]>=3; g2=n2>=80 and p2>=1.15 and a2[0]>=2; g3=m1>1 and m2>1
    es='PASSA g1-3' if g1 and g2 and g3 else ('g1' if g1 else '')
    print('%-21s | %4d %.2f %d/%d | %4d %.2f %d/%d | %.2f %.2f | %s'%(k,n1,p1,a1[0],a1[1],n2,p2,a2[0],a2[1],m1,m2,es))
    if g1 and g2 and g3:
        c1=r.reindex(oro.index).dropna().corr(oro.reindex(r.dropna().index).dropna()) if False else r.dropna().corr(oro.reindex(r.dropna().index))
        c2=r.dropna().corr(dow.reindex(r.dropna().index)); fin.append((k,c1,c2,r)); print('    corr oro %.2f dow %.2f'%(c1,c2))
print('finalisti G1-G3:',len(fin))
if HOLD:
    for k,c1,c2,r in fin[:3]: print('HOLD-OUT',k,pf(r[r.index.year>=2025]))
