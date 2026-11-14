s=open('bundle_search.py').read(); s=s[:s.index("RES={}")]
exec(s)
import json
def sim_all(inc,low,u,tgt):
    n=len(u); res=[]
    for st_ in range(n):
        c=np.cumsum(inc[st_:]); prev=c-inc[st_:]
        el=(u[st_:]-u[st_]).astype('timedelta64[D]').astype(int)+1
        fm=(low[st_:]<=-0.05*DEP)|(prev+low[st_:]<=-0.10*DEP); pm=(c>=tgt*DEP)&(el>=4)
        fi=np.argmax(fm) if fm.any() else 10**9; pi=np.argmax(pm) if pm.any() else 10**9
        if fi==10**9 and pi==10**9: res.append(('C',None))
        elif fi<=pi: res.append(('F',int(el[fi])))
        else: res.append(('P',int(el[pi])))
    return res
COMBOS={'P1 oro (Goldbot L0 + Phantom L1)':[('GB','L0'),('PH','L1')],
        'P4 oro (Goldbot L0 + Reaper L3)':[('GB','L0'),('GR','L3')],
        'P3 oro (Goldbot L3 + GTP Combo)':[('GB','L3'),('GTP','COMBO')]}
SCEN=[('base',1.0,1.0),('DD x1,15 e profitti x0,92',1.15,0.92),('DD x1,35 e profitti x0,85',1.35,0.85)]
out={}
for name,mem in COMBOS.items():
    for kc in (1.0,2.0):
        for sn,fd,fp in SCEN:
            F=0;N=0;P=0;C=0;per={}
            for y in YEARS:
                inc,low=series(mem,y,kc)
                inc2=np.where(inc>0,inc*fp,inc*fd); low2=low*np.where(low<0,fd,1.0)
                r=sim_all(inc2,low2,D[y]['u'],0.10)
                f=sum(1 for x in r if x[0]=='F'); F+=f; N+=len(r); P+=sum(1 for x in r if x[0]=='P'); C+=sum(1 for x in r if x[0]=='C'); per[y]=round(100*f/len(r),1)
            # giorni >=4,5% e peggior giorno (equity dal giorno prima, in % del deposito)
            w=min(float((series(mem,y,kc)[1]*np.where(series(mem,y,kc)[1]<0,fd,1.0)).min()) for y in YEARS)/DEP*100
            out['%s|costi x%s|%s'%(name,int(kc),sn)]=dict(fail=round(100*F/N,1),pass_=round(100*P/N,1),aperti=round(100*C/N,1),per_anno=per,peggior_giorno=round(w,2))
json.dump(out,open('stress_fail.json','w'),indent=1,ensure_ascii=False)
for k,v in out.items(): print(k,v)
