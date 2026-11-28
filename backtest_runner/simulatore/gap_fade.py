import sys,warnings,itertools;warnings.filterwarnings('ignore')
import numpy as np,pandas as pd
D='/tmp/idx/%s_M1_%d/%s_M1_%d.csv'; COST={'NASUSD':1.8/19000,'SPXUSD':0.6/6000}
def days(sym):
    out=[];prev=None
    for y in range(2010,2027):
        d=pd.read_csv(D%(sym,y,sym,y),usecols=['Time','Open','High','Low','Close']); d['Time']=pd.to_datetime(d['Time'],format='%Y.%m.%d %H:%M'); d['day']=d.Time.dt.normalize(); d['m']=d.Time.dt.hour*60+d.Time.dt.minute
        for day,g in d.groupby('day'):
            g=g[(g.m>=570)&(g.m<=960)]
            if len(g)<300 or g.m.iloc[0]!=570: continue
            m=g.m.values; i1559=np.nonzero(m==959)[0]
            if len(i1559)==0: continue
            out.append(dict(day=day,pc=prev,O=g.Open.values,H=g.High.values,L=g.Low.values,C=g.Close.values,m=m))
            prev=g.Close.values[i1559[0]]
    return [x for x in out if x['pc'] is not None]
def sim(x,gmin,tgt,k,ex,sign=None):
    gap=x['O'][0]-x['pc']; pct=abs(gap)/x['pc']
    if pct<gmin: return None
    d=-np.sign(gap) if sign is None else sign
    ent=x['O'][0]; G=abs(gap); stop=ent-d*k*G; tp=ent+d*tgt*(-d*np.sign(gap)*0+G)*(1 if np.sign(gap)*d<0 else 0) if False else ent-np.sign(gap)*tgt*G
    if sign is not None: tp=ent+d*tgt*G
    tend=720 if ex=='12' else 955
    for j in range(len(x['m'])):
        if x['m'][j]>=tend: px=x['O'][j]; break
        if j==0: 
            pass
        if d==1:
            if x['L'][j]<=stop: px=min(x['O'][j],stop) if j>0 else stop; break
            if x['H'][j]>=tp: px=tp; break
        else:
            if x['H'][j]>=stop: px=max(x['O'][j],stop) if j>0 else stop; break
            if x['L'][j]<=tp: px=tp; break
    else: px=x['C'][-1]
    return d*(px-ent)/ent, ent
def pf(a):
    a=np.array(a); w=a[a>0].sum(); l=-a[a<0].sum(); return w/l if l>0 else np.nan
if __name__=='__main__':
    data={s:days(s) for s in COST}; cells=list(itertools.product((0.002,0.004),(0.5,1.0),(1,2),('12','15')))
    rng=np.random.default_rng(20261128); res={}
    for s,dd in data.items(): print(s,'giorni',len(dd))
    for s,dd in data.items():
        for c in cells:
            rows=[]
            for x in dd:
                r=sim(x,*c)
                if r: rows.append((x['day'].year,r[0],COST[s]))
            a=pd.DataFrame(rows,columns=['y','r','c']); res[(s,c)]=a
    def met(a,cm,lo,hi):
        z=a[(a.y>=lo)&(a.y<=hi)]; return len(z),pf(z.r-cm*z.c)
    def ypos(a,cm): n=a.r-cm*a.c; g=n.groupby(a.y).sum(); return (g>0).mean()
    print('=== PF per cella (IS 2011-18 / OOS 2019-23 / HO 2024-26), netto costo x1 | costo zero')
    passed=[]
    for c in cells:
        line=[]; ok=True
        for s in COST:
            a=res[(s,c)]; i1=met(a,1,2011,2018); o1=met(a,1,2019,2023); h1=met(a,1,2024,2026); i0=met(a,0,2011,2018); o0=met(a,0,2019,2023); x2=met(a,2,2019,2023)
            line.append('%s n=%d IS %.2f OOS %.2f HO %.2f | zero IS %.2f OOS %.2f'%(s[:3],i1[0],i1[1],o1[1],h1[1],i0[1],o0[1]))
            ok&=(i1[0]>=100 and i1[1]>=1.25 and o1[1]>=1.15 and ypos(a,1)>=0.6 and x2[1]>1.0)
        print(c,' || '.join(line),'PASSA' if ok else ''); 
        if ok: passed.append(c)
    print('celle che passano i cancelli su entrambi gli indici:',passed)
    best=[]
    for rep in range(20):
        mx=0
        for s,dd in data.items():
            for c in cells:
                rows=[]
                for x in dd:
                    sg=rng.choice([-1,1]); r=sim(x,*c,sign=sg)
                    if r: rows.append((x['day'].year,r[0]-COST[s]))
                a=pd.DataFrame(rows,columns=['y','r']); z=a[(a.y>=2011)&(a.y<=2018)]; mx=max(mx,pf(z.r)) if len(z)>=100 else mx
        best.append(mx)
    print('NULLO casuale: miglior PF IS della griglia: media %.2f max %.2f'%(np.mean(best),np.max(best)))
