import sys,warnings;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd
D='/tmp/idx/%s_M1_%d/%s_M1_%d.csv'
COST={'NASUSD':1.8,'SPXUSD':0.6}
def load(sym):
    fr=[]
    for y in range(2015,2027):
        d=pd.read_csv(D%(sym,y,sym,y)); d['Time']=pd.to_datetime(d['Time'],format='%Y.%m.%d %H:%M'); fr.append(d.set_index('Time'))
    return pd.concat(fr).sort_index()
def days(sym):
    d=load(sym); c=d['Close']; o=d['Open']; rows=[]; prev=None
    for day,g in d.groupby(d.index.date):
        t=lambda h,m:pd.Timestamp(day)+pd.Timedelta(hours=h,minutes=m)
        try:
            c959=c.at[t(9,59)];o930=o.at[t(9,30)];c1500=c.at[t(14,59)];o1530=o.at[t(15,30)];o1600=o.at[t(16,0)];c1559=c.at[t(15,59)]
        except KeyError: continue
        o1500=o.at[t(15,0)] if t(15,0) in o.index else np.nan
        cl=c.get(t(15,59),np.nan)
        rows.append(dict(day=pd.Timestamp(day),c959=c959,o930=o930,o1500=o1500,o1530=o1530,o1600=o1600,prevclose=prev))
        prev=c1559
    return pd.DataFrame(rows).dropna()
def stats(pnl,label):
    if len(pnl)==0: return label,0,np.nan,np.nan,np.nan
    w=pnl[pnl>0].sum(); l=-pnl[pnl<0].sum(); pf=w/l if l>0 else np.inf
    return label,len(pnl),pf,pnl.mean(),pnl.sum()
def run(sym):
    t=days(sym); cost=COST[sym]; out={}
    r1=np.sign(t.c959-t.prevclose); r2=np.sign(t.c959-t.o930); r12=np.sign(t.o1530-t.o1500)
    sig={'V1':r1,'V2':r2,'V3':np.where(r1==r12,r1,0)}
    gross=t.o1600-t.o1530
    rng=np.random.default_rng(20261127)
    res=[]
    per={'IS':(2015,2020),'OOS':(2021,2024),'HO':(2025,2026)}
    for k,s in sig.items():
        s=pd.Series(s,index=t.index); m=s!=0
        for cm in (1.0,2.0,0.5):
            pnl=(s*gross-cost*cm)[m]; yr=t.day[m].dt.year
            for pn,(a,b) in per.items():
                sel=(yr>=a)&(yr<=b)
                res.append((sym,k,cm,pn)+stats(pnl[sel],'')[1:])
        pnl=(s*gross-cost)[m]; yr=t.day[m].dt.year
        ya=pnl.groupby(yr).sum(); print(sym,k,'anni positivi %d/%d'%((ya>0).sum(),len(ya)),' '.join('%d:%+.0f'%(y,v) for y,v in ya.items()))
        # controllo direzione casuale (20 repliche, 2015-2024)
        pfs=[]
        for _ in range(20):
            rs=pd.Series(rng.choice([-1,1],len(t)),index=t.index)*m
            p=(rs*gross-cost)[m]; sel=(yr<=2024); w=p[sel][p[sel]>0].sum(); l=-p[sel][p[sel]<0].sum(); pfs.append(w/l)
        print('   controllo casuale PF',round(np.mean(pfs),2),round(min(pfs),2),round(max(pfs),2))
    # sempre long 15:30-16:00
    al=(gross-cost); yr=t.day.dt.year
    for pn,(a,b) in per.items():
        sel=(yr>=a)&(yr<=b); print(sym,'sempre long',pn,stats(al[sel],'')[1:])
    return pd.DataFrame(res,columns=['sym','var','costx','per','n','PF','media','tot'])
if __name__=='__main__':
    allr=[run(s) for s in ('NASUSD','SPXUSD')]
    r=pd.concat(allr); pd.set_option('display.width',200)
    print(r[r.costx==1.0].round(3).to_string(index=False)); print(r[r.costx!=1.0].round(3).to_string(index=False))
    r.to_csv('/tmp/work/momentum_res.csv',index=False)
