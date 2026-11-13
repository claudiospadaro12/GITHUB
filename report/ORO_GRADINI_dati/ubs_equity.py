import re,glob,json,collections,sys,pickle
import numpy as np
CONV={'2013':0.752,'2018':0.847,'2020':0.877,'2025':0.888}
def conv(y): return CONV.get(y,0.85)
FILES={'2013':'exp_all/ABTG_M1_XAUUSD_2013.csv','2018':'exp_all/ABTG_M1_XAUUSD_2018.csv','2020':'exp_all/ABTG_M1_XAUUSD_2020.csv','2025':'exp_all/ABTG_M1_XAUUSD.csv'}
def deals(h):
    b=open(h,'rb').read(); raw=b.decode('utf-16','replace') if b[:2] in (b'\xff\xfe',b'\xfe\xff') else b.decode('utf-8','replace'); out=[]
    for rr in re.findall(r'<tr[^>]*>(.*?)</tr>',raw[raw.find('Affari'):],flags=re.S):
        c=[re.sub(r'<[^>]+>','',x).replace('&nbsp;',' ').strip() for x in re.findall(r'<td[^>]*>(.*?)</td>',rr,flags=re.S)]
        if len(c)>=12 and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d',c[0]) and c[3] in('buy','sell'):
            f=lambda s:float(s.replace(' ','').replace(',','') or 0)
            try: out.append(dict(t=c[0],sym=c[2],typ=c[3],dir=c[4],vol=f(c[5]),px=f(c[6]),com=f(c[8]),swap=f(c[9]),pr=f(c[10])))
            except: pass
    return out
def positions(dl):
    open_={'buy':[],'sell':[]};pos=[];unm=0
    for d in dl:
        if d['dir']=='in': open_['buy' if d['typ']=='buy' else 'sell'].append(d)
        elif d['dir']=='out':
            side='buy' if d['typ']=='sell' else 'sell'
            cand=[p for p in open_[side] if abs(p['vol']-d['vol'])<1e-6 and p['sym']==d['sym']]
            if not cand: cand=[p for p in open_[side] if p['sym']==d['sym']]
            if not cand: unm+=1;continue
            cv=conv(d['t'][:4])
            if d['sym'].startswith('XAU') and abs(d['pr'])>0:
                move=d['pr']/(d['vol']*100*cv); imp=d['px']-move if side=='buy' else d['px']+move
                p=min(cand,key=lambda p:abs(p['px']-imp))
            else: p=cand[0]
            open_[side].remove(p)
            pos.append(dict(t0=p['t'],t1=d['t'],entry=p['px'],vol=d['vol'],side=side,sym=d['sym'],pnl=d['pr']+d['com']+p['com']+d['swap']))
    return pos,unm,sum(len(v) for v in open_.values())
M1={}
def m1(y):
    if y in M1: return M1[y]
    T=[];H=[];L=[];C=[]
    for i,l in enumerate(open(FILES[y])):
        if i==0: continue
        p=l.strip().split(';')
        if not p[0].startswith(y): continue
        T.append(p[0].replace('.','-',2).replace(' ','T'));H.append(float(p[2]));L.append(float(p[3]));C.append(float(p[4]))
    M1[y]=(np.array(T,dtype='datetime64[m]'),np.array(H),np.array(L),np.array(C));return M1[y]
def year_equity(pos,y):
    T,hi,lo,cl=m1(y);n=len(T)
    t_start=np.datetime64(y+'-01-01T00:00');t_end=np.datetime64(str(int(y)+1)+'-01-01T00:00')
    def tm(ts): return np.datetime64(ts.replace('.','-',2).replace(' ','T')[:16])
    base=0.0; real=np.zeros(n); fa=np.zeros(n); fc=np.zeros(n); cv=conv(y)
    for p in pos:
        a=tm(p['t0']);b=tm(p['t1'])
        if b<t_start: base+=p['pnl']; continue
        if a>=t_end: continue
        i0=0 if a<t_start else min(int(np.searchsorted(T,a)),n-1)
        if b>=t_end: i1=n
        else: i1=min(int(np.searchsorted(T,b)),n-1); real[i1:]+=p['pnl']
        if p['sym'].startswith('XAU') and i1>i0:
            sgn=1 if p['side']=='buy' else -1;k=sgn*p['vol']*100*cv
            adv=lo[i0:i1] if sgn==1 else hi[i0:i1]
            fa[i0:i1]+=k*(adv-p['entry']);fc[i0:i1]+=k*(cl[i0:i1]-p['entry'])
    return base+real+fa, base+real+fc, T
if __name__=='__main__':
    tags=['PH_strat8','PH_strat3','GB_dailyC','GTP_E','GB_dailyI','GTP_a','GR_s5_H1','GR_s1_D1']
    OUT={}
    for t in tags:
        h=glob.glob(f'u2/UBSU2_B_{t}_100000_2013-2025/*/report/*.htm')[0]
        dl=deals(h); pos,unm,left=positions(dl)
        print(t,'deal',len(dl),'posizioni',len(pos),'non abbinati',unm,'aperti a fine',left)
        OUT[t]={y:year_equity(pos,y)[:2] for y in CONV}
        OUT['T']={y:year_equity(pos,y)[2] for y in CONV}
    pickle.dump(OUT,open('ubs_equity.pkl','wb'))
