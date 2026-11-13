s=open('bundle_search.py').read(); s=s[:s.index("RES={}")]
exec(s)
import pickle
def sim_all(inc,low,u,tgt):
    n=len(u); res=[]
    for st in range(n):
        c=np.cumsum(inc[st:]); prev=c-inc[st:]
        el=(u[st:]-u[st]).astype('timedelta64[D]').astype(int)+1
        fm=(low[st:]<=-0.05*DEP)|(prev+low[st:]<=-0.10*DEP); pm=(c>=tgt*DEP)&(el>=4)
        fi=np.argmax(fm) if fm.any() else 10**9; pi=np.argmax(pm) if pm.any() else 10**9
        if fi==10**9 and pi==10**9: res.append(('C',None))
        elif fi<=pi: res.append(('F',int(el[fi])))
        else: res.append(('P',int(el[pi])))
    return res
def failall(mem,k):
    out={}; ft=0;nt=0
    for y in YEARS:
        inc,low=series(mem,y,k); u=D[y]['u']
        r10=sim_all(inc,low,u,0.10)
        # fase 2: chi passa la fase 1 riparte (semplificazione: fallimento fase 1 + fallimento fase 2 sulla stessa partenza non sommati)
        f=sum(1 for x in r10 if x[0]=='F'); ft+=f; nt+=len(r10); out[y]=100*f/len(r10)
    return 100*ft/nt,out
RES2={}
for gb in (None,)+EAS['GB']:
  for ph in (None,)+EAS['PH']:
    for gr in (None,)+EAS['GR']:
      for gt in (None,'COMBO'):
        mem=[m for m in ((('GB',gb) if gb else None),(('PH',ph) if ph else None),(('GR',gr) if gr else None),(('GTP','COMBO') if gt else None)) if m]
        if not mem: continue
        key='|'.join('%s_%s'%m for m in mem)
        f1,y1=failall(mem,1.0); f2,y2=failall(mem,2.0)
        RES2[key]=dict(fall_c=f1,fall_d=f2,per_anno=y1)
pickle.dump(RES2,open('bundle_res2.pkl','wb')); print(len(RES2))
