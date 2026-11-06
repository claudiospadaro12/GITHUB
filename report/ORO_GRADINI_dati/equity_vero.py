import re,glob,json,collections,sys
import numpy as np
R=json.load(open('oro_res.json'))
CONV={'2013':0.752,'2020':0.877,'2025':0.888}
def deals(h):
    raw=open(h,'rb').read().decode('utf-16','replace');out=[]
    for rr in re.findall(r'<tr[^>]*>(.*?)</tr>',raw[raw.find('Affari'):],flags=re.S):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',rr,flags=re.S)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in('buy','sell'):
            f=lambda s:float(s.replace(' ','').replace(',','') or 0)
            try: out.append(dict(t=c[0],sym=c[2],typ=c[3],dir=c[4],vol=f(c[5]),px=f(c[6]),com=f(c[8]),swap=f(c[9]),pr=f(c[10])))
            except: pass
    return out
def positions(dl,y):
    cv=CONV[y];open_={'buy':[],'sell':[]};pos=[];unm=0
    for d in dl:
        if d['dir']=='in': open_['buy' if d['typ']=='buy' else 'sell'].append(d)
        elif d['dir']=='out':
            side='buy' if d['typ']=='sell' else 'sell'   # un sell chiude un buy
            cand=[p for p in open_[side] if abs(p['vol']-d['vol'])<1e-6 and p['sym']==d['sym']]
            if not cand: cand=[p for p in open_[side] if p['sym']==d['sym']]
            if not cand: unm+=1;continue
            if d['sym'].startswith('XAU') and abs(d['pr'])>0:
                move=d['pr']/(d['vol']*100*cv)       # USD per oncia
                imp=d['px']-move if side=='buy' else d['px']+move
                p=min(cand,key=lambda p:abs(p['px']-imp))
            else: p=cand[0]
            open_[side].remove(p)
            pos.append(dict(t0=p['t'],t1=d['t'],entry=p['px'],exit=d['px'],vol=d['vol'],side=side,sym=d['sym'],pnl=d['pr']+d['com']+p['com']+d['swap'],gross=d['pr']))
    return pos,unm,sum(len(v) for v in open_.values())
M1={}
def m1(y):
    if y in M1: return M1[y]
    f={'2013':'xau/ABTG_M1_XAUUSD_2013.csv','2025':'xau/ABTG_M1_XAUUSD.csv'}[y]
    T=[];H=[];L=[];C=[]
    for i,l in enumerate(open(f)):
        if i==0: continue
        p=l.strip().split(';')
        if not p[0].startswith(y): continue
        T.append(p[0].replace('.','-',2).replace(' ','T'));H.append(float(p[2]));L.append(float(p[3]));C.append(float(p[4]))
    M1[y]=(np.array(T,dtype='datetime64[m]'),np.array(H),np.array(L),np.array(C));return M1[y]
def equity_ea(h,y,dep):
    dl=deals(h);pos,unm,left=positions(dl,y)
    T,hi,lo,cl=m1(y);n=len(T)
    real=np.zeros(n);flt_adv=np.zeros(n);flt_cl=np.zeros(n)
    def idx(ts):
        t=np.datetime64(ts.replace('.','-',2).replace(' ','T')[:16]);return min(int(np.searchsorted(T,t)),n-1)
    cv=CONV[y]
    for p in pos:
        i0=idx(p['t0']);i1=idx(p['t1']);real[i1:]+=p['pnl']
        if p['sym'].startswith('XAU') and i1>i0:
            sgn=1 if p['side']=='buy' else -1;k=sgn*p['vol']*100*cv
            adv=lo[i0:i1] if sgn==1 else hi[i0:i1]
            flt_adv[i0:i1]+=k*(adv-p['entry']);flt_cl[i0:i1]+=k*(cl[i0:i1]-p['entry'])
    return dep+real+flt_adv, dep+real+flt_cl, dict(pos=len(pos),unm=unm,left=left,T=T)
