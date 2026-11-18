import csv,glob,sys,collections,json
import numpy as np
def load(pat):
    rows={}
    for f in sorted(glob.glob(pat)):
        with open(f) as fh:
            r=csv.reader(fh,delimiter=';'); next(r)
            for t,o,h,l,c,*_ in r:
                k=t[:13]; o,h,l,c=float(o),float(h),float(l),float(c)
                if k not in rows: rows[k]=[o,h,l,c]
                else:
                    x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
MK={'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',0.00008),'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',0.30)}
def atr_rma(H,L,C,p):
    n=len(C); tr=np.zeros(n); tr[0]=H[0]-L[0]
    for i in range(1,n): tr[i]=max(H[i]-L[i],abs(H[i]-C[i-1]),abs(L[i]-C[i-1]))
    a=np.full(n,np.nan); a[p-1]=tr[:p].mean()
    for i in range(p,n): a[i]=(a[i-1]*(p-1)+tr[i])/p
    return a
class Struct:
    """replica di getCurrentStructure + displayStructure (LuxAlgo) per un pivot size e per gli order block"""
    def __init__(s,size,internal,O,H,L,C,pH,pL,swing=None):
        s.size=size; s.internal=internal; s.O,s.H,s.L,s.C=O,H,L,C; s.pH,s.pL=pH,pL
        s.hi=dict(level=np.nan,last=np.nan,crossed=False,idx=0); s.lo=dict(level=np.nan,last=np.nan,crossed=False,idx=0)
        s.leg=0; s.bias=0; s.swing=swing; s.events=[]   # (t,tag,dir,ob(top,bottom,idx) )
    def step(s,t):
        z=s.size
        if t>=z+1:
            newH=s.H[t-z]>s.H[t-z+1:t+1].max() if z>0 else False
            newL=s.L[t-z]<s.L[t-z+1:t+1].min()
            prev=s.leg
            if newH: s.leg=0
            elif newL: s.leg=1
            if s.leg!=prev:
                if s.leg==1: # pivot low (start of bullish leg)
                    d=s.lo; d['last']=d['level']; d['level']=s.L[t-z]; d['crossed']=False; d['idx']=t-z
                else:
                    d=s.hi; d['last']=d['level']; d['level']=s.H[t-z]; d['crossed']=False; d['idx']=t-z
        # strutture
        h=s.hi
        if not np.isnan(h['level']) and not h['crossed'] and s.C[t]>h['level'] and s.C[t-1]<=h['level']:
            extra=True
            if s.internal and s.swing is not None: extra=(s.hi['level']!=s.swing.hi['level'])
            if extra:
                tag='CHOCH' if s.bias==-1 else 'BOS'
                h['crossed']=True; s.bias=1
                seg=s.pL[h['idx']:t]; k=h['idx']+int(np.argmin(seg)) if len(seg) else t-1
                s.events.append((t,tag,1,(s.pH[k],s.pL[k],k),dict(piv=s.lo['level'])))
        l=s.lo
        if not np.isnan(l['level']) and not l['crossed'] and s.C[t]<l['level'] and s.C[t-1]>=l['level']:
            extra=True
            if s.internal and s.swing is not None: extra=(s.lo['level']!=s.swing.lo['level'])
            if extra:
                tag='CHOCH' if s.bias==1 else 'BOS'
                l['crossed']=True; s.bias=-1
                seg=s.pH[l['idx']:t]; k=l['idx']+int(np.argmax(seg)) if len(seg) else t-1
                s.events.append((t,tag,-1,(s.pH[k],s.pL[k],k),dict(piv=s.hi['level'])))
def run(name):
    pat,cost=MK[name]; ks,A=load(pat); O,H,L,C=A.T; n=len(C)
    atr200=atr_rma(H,L,C,200); atr14=atr_rma(H,L,C,14)
    hv=(H-L)>=2*np.nan_to_num(atr200,nan=1e9)
    pH=np.where(hv,L,H); pL=np.where(hv,H,L)
    sw=Struct(50,False,O,H,L,C,pH,pL); it=Struct(5,True,O,H,L,C,pH,pL,swing=sw)
    for t in range(1,n):
        sw.step(t); it.step(t)
    return ks,O,H,L,C,atr14,sw,it,cost
def sim_ob(ks,O,H,L,C,events,cost,validity=100,rr=2.0):
    n=len(C); trades=[]; busy=-1
    obs=[(e[0],e[2],e[3]) for e in events]  # (t_creazione, dir, (top,bottom,idx))
    for (t0,d,(top,bot,idx)) in obs:
        entry=None
        for t in range(t0+1,min(n-1,t0+validity)):
            touched = (L[t]<=top) if d==1 else (H[t]>=bot)
            if not touched: continue
            if t<=busy: break            # toccato mentre un'altra operazione e aperta: il blocco e consumato
            px=min(O[t],top) if d==1 else max(O[t],bot)
            sl=bot if d==1 else top
            risk=(px-sl) if d==1 else (sl-px)
            if risk<=0: break
            tp=px+rr*risk if d==1 else px-rr*risk
            if (d==1 and L[t]<=sl) or (d==-1 and H[t]>=sl): res=-1.0; ex=t   # barra di fill: solo lo SL
            else:
                res=None
                for m in range(t+1,min(n,t+500)):
                    if d==1:
                        if L[m]<=sl: res=-1.0; ex=m; break
                        if H[m]>=tp: res=rr; ex=m; break
                    else:
                        if H[m]>=sl: res=-1.0; ex=m; break
                        if L[m]<=tp: res=rr; ex=m; break
                if res is None: break
            trades.append((ks[t],d,res-cost/risk,risk)); busy=ex; break
    return trades
def sim_choch(ks,O,H,L,C,atr14,events,cost,rr=2.0):
    n=len(C); trades=[]; busy=-1
    for (t0,tag,d,ob,info) in events:
        if tag!='CHOCH' or t0<=busy or t0+1>=n: continue
        j=t0+1; px=O[j]; sl=info['piv']
        if np.isnan(sl): continue
        risk=(px-sl) if d==1 else (sl-px)
        if risk<=0 or risk>5*atr14[t0]: continue
        tp=px+rr*risk if d==1 else px-rr*risk
        res=None
        for m in range(j,min(n,j+500)):
            if d==1:
                if L[m]<=sl: res=-1.0; ex=m; break
                if H[m]>=tp and m>j: res=rr; ex=m; break
            else:
                if H[m]>=sl: res=-1.0; ex=m; break
                if L[m]<=tp and m>j: res=rr; ex=m; break
        if res is None: continue
        trades.append((ks[j],d,res-cost/risk,risk)); busy=ex
    return trades
def stats(tr):
    if not tr: return 'n=0'
    r=np.array([x[2] for x in tr]); g=r[r>0].sum(); l=-r[r<0].sum(); pf=g/l if l>0 else float('inf')
    t=r.mean()/(r.std(ddof=1)/np.sqrt(len(r))) if len(r)>1 and r.std()>0 else 0
    return 'n=%d R=%.3f PF=%.2f t=%.1f win=%.0f%%'%(len(r),r.mean(),pf,t,100*(r>0).mean())
if __name__=='__main__':
    out={}
    for name in ('EURUSD','XAUUSD'):
        ks,O,H,L,C,a14,sw,it,cost=run(name)
        print(name,'barre',len(C),'eventi swing',len(sw.events),'(CHoCH %d)'%sum(1 for e in sw.events if e[1]=='CHOCH'),'interni',len(it.events))
        mods={'A_INT':sim_ob(ks,O,H,L,C,it.events,cost),'A_SWG':sim_ob(ks,O,H,L,C,sw.events,cost),'B_CHOCH':sim_choch(ks,O,H,L,C,a14,sw.events,cost)}
        for m,tr in mods.items():
            h1=[x for x in tr if x[0]<'2018']; h2=[x for x in tr if x[0]>='2018']
            print('  %-8s TUTTI %s | 2014-17 %s | 2018-20 %s'%(m,stats(tr),stats(h1),stats(h2)))
