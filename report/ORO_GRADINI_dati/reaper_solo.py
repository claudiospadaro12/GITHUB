exec(open('l1_costi.py').read().split("BASE={")[0])
YEARS=('2013','2018','2020','2025')

def run(sb,so,tgt,N):
    dates=sorted(set(sb)|set(so)); res=[]
    for s in range(len(dates)):
        if dates[s][5:]>'03-31': break
        d0=dt.date.fromisoformat(dates[s]); cum=0;out=('C',None)
        for kk in range(s,len(dates)):
            dk=dt.date.fromisoformat(dates[kk]); ser=sb
            inc,low=ser.get(dates[kk],(0.0,0.0))
            if low<=-0.05*DEP or cum+low<=-0.10*DEP: out=('F',(dk-d0).days+1);break
            cum+=inc
            if cum>=tgt*DEP and (dk-d0).days+1>=4: out=('P',(dk-d0).days+1);break
        res.append(out)
    return res
def series_g(mem,y,k):
    g=gold(mem,y); cost=collections.defaultdict(float)
    for e,lv in mem:
        _,c=dealday(e,lv,y)
        for kk,v in c.items(): cost[kk]+=v
    return {kk:(gi-k*cost.get(kk,0.0),gl-k*cost.get(kk,0.0)) for kk,(gi,gl) in g.items()}
LV={'L3 Combo 3GOLD (Gold_reaper_propfirm_combo_3GOLD.set)':'L3','L0 Prop (Gold_reaper_propfirm.set)':'L0','L1 15% maxrisk (gold_reaper_15%maxrisk.set)':'L1','L2 Medium (gold_reaper_default.set)':'L2'}
for nm,lv in LV.items():
    print(nm)
    for k,lab in ((0,'senza costi FTMO'),(1,'costi centrali')):
        row=[]; netl=[]
        for y in YEARS: netl.append(sum(i for i,_ in series_g([('GR',lv)],y,k).values()))
        for t in (0.10,0.05):
            r=[]
            for y in YEARS:
                s=series_g([('GR',lv)],y,k); r+=run(s,s,t,None)
            n=len(r); p=[x[1] for x in r if x[0]=='P']; f=sum(1 for x in r if x[0]=='F'); c=sum(1 for x in r if x[0]=='C')
            row.append('+%d%%: passa %3.0f%% falli %3.0f%% aperto %3.0f%% | gg mediana %s (25-75: %s-%s)'%(t*100,100*len(p)/n,100*f/n,100*c/n,int(st.median(p)) if p else '-',int(np.percentile(p,25)) if p else '-',int(np.percentile(p,75)) if p else '-'))
        print('   %-16s netto/anno %6.0f | %s'%(lab,sum(netl)/4,' || '.join(row)))
