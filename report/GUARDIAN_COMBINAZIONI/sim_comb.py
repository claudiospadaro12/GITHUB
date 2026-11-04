import json,itertools,datetime as dt,sys
import numpy as np
EV=json.load(open('ev/events.json'))
YEARS=('2013','2018','2020','2025')
BAL=80000.0; DAY=0.043*BAL; TOT=0.093*BAL; WTGT=0.05*BAL; DLIM=0.05*BAL; TLIM=0.10*BAL; W=14
# per ogni serie, eventi per anno ordinati
R=['D9','DD6','DD12','DD15','LIVE30','LIVE9','R50A','R50B']
G=[None,'PF525','PF105','LOW3']
P=[None,'PROPCOMBO_D4','PROPFIRM_D9','LOWRISK_D10','MEDIUM_D30','HIGHRISK_D60']
T=[None,'COMBO','PROPFIRM_R1','LOWRISK_R15','MEDIUM_R3','HIGHRISK_R6']
def keys(c):
    r,g,p,t=c
    ks=[f'Reaper|{r}']
    if g: ks.append(f'Goldbot|{g}')
    if p: ks.append(f'Phantom|{p}')
    if t: ks.append(f'GTP|{t}')
    return ks
cache={}
def daily(c,y,model):
    ev=[]
    for k in keys(c): ev+=EV[f'{k}|{y}']
    ev.sort(key=lambda x:x[0])
    d0=dt.date(int(y),1,1)
    s=np.zeros(366)
    ntrig=0
    cur=None;run=0.0;stopped=False
    def flush():
        nonlocal run
        if cur is not None:
            idx=(dt.date(int(cur[:4]),int(cur[5:7]),int(cur[8:10]))-d0).days
            if 0<=idx<366: s[idx]=run
    for t,v in ev:
        d=t[:10]
        if d!=cur:
            flush(); cur=d; run=0.0; stopped=False
        if stopped: continue
        run+=v
        if model!='none' and run<=-DAY:
            ntrig+=1
            if model=='A': run=-DAY
            stopped=True
    flush()
    return s[:365],ntrig
def windows(s):
    n=365-W
    idx=np.arange(n)[:,None]+np.arange(W)[None,:]
    return s[idx]          # n x W giornaliero
def outcome(win,model):
    cum=np.cumsum(win,axis=1)
    fail=np.zeros(win.shape,bool); stop=np.zeros(win.shape,bool); pas=cum>=WTGT
    if model=='none':
        fail=(win<=-DLIM)|(cum<=-TLIM)
    else:
        fail=(win<=-DLIM)
        stop=cum<=-TOT
    big=10**9
    def first(m): 
        r=np.where(m.any(axis=1),m.argmax(axis=1),big); return r
    f=first(fail); st=first(stop); p=first(pas)
    ev_ = np.minimum(f,st)
    pa=(p<big)&(p<ev_)
    fa=(f<big)&(f<=p)&(f<=st)
    return pa.sum(),fa.sum(),len(win)
def evaluate(c):
    out={}
    for model in ('none','A','B'):
        pa=fa=n=0; wd=0; dd=0; net=0; trig=0; per={}
        for y in YEARS:
            s,nt=daily(c,y,model); trig+=nt
            w=windows(s); a,b,m=outcome(w,model); pa+=a;fa+=b;n+=m
            cum=np.cumsum(s);pk=np.maximum.accumulate(np.maximum(cum,0));ddy=(pk-cum).max()
            wd=min(wd,s.min());dd=max(dd,ddy);net+=s.sum();per[y]=(round(100*b/m,1),round(s.min()),round(s.sum()))
        out[model]=dict(pass_=100*pa/n,fail=100*fa/n,scade=100-100*(pa+fa)/n,wd=wd,dd=dd,net=net/4,trig=trig,per=per)
    return out
if __name__=='__main__':
    combos=[(r,g,p,t) for r in R for g in G for p in P for t in T]
    res={}
    for i,c in enumerate(combos):
        res[c]=evaluate(c)
    import pickle; pickle.dump(res,open('ev/res.pkl','wb'))
    print('combinazioni',len(res))
