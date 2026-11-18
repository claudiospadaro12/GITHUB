import sys,json,collections,itertools
import numpy as np
sys.path.insert(0,'/tmp/claude-0/bul')
import smc
MK={'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',0.0001),'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',0.35)}
def rma(x,p):
    o=np.full(len(x),np.nan); o[p-1]=np.mean(x[:p])
    for i in range(p,len(x)): o[i]=(o[i-1]*(p-1)+x[i])/p
    return o
def trange(H,L,C):
    tr=np.zeros(len(C)); tr[0]=H[0]-L[0]
    for i in range(1,len(C)): tr[i]=max(H[i]-L[i],abs(H[i]-C[i-1]),abs(L[i]-C[i-1]))
    return tr
def metrics(tr,years=None):
    """tr: lista di (tempo, R_netto)"""
    if not tr: return dict(n=0,R=0,pf=0,dd=0,t=0,win=0)
    r=np.array([x[1] for x in tr]); g=r[r>0].sum(); l=-r[r<0].sum()
    eq=1.0; pk=1.0; dd=0.0
    for v in r:
        eq*=max(1e-9,1+0.01*v); pk=max(pk,eq); dd=max(dd,(pk-eq)/pk)
    t=r.mean()/(r.std(ddof=1)/np.sqrt(len(r))) if len(r)>1 and r.std()>0 else 0
    return dict(n=len(r),R=float(r.mean()),pf=float(g/l) if l>0 else 99.0,dd=float(dd*100),t=float(t),win=float((r>0).mean()*100))
def fmt(m): return 'n=%d R=%.3f PF=%.2f DD=%.1f%% t=%.1f win=%.0f%%'%(m['n'],m['R'],m['pf'],m['dd'],m['t'],m['win'])
def supertrend_trades(ks,O,H,L,C,period,mult,cost):
    n=len(C); tr_=trange(H,L,C); atr=rma(tr_,period); src=(H+L)/2
    up=np.full(n,np.nan); dn=np.full(n,np.nan); trend=np.zeros(n,dtype=int)
    start=period
    up[start]=src[start]-mult*atr[start]; dn[start]=src[start]+mult*atr[start]; trend[start]=1
    for i in range(start+1,n):
        u=src[i]-mult*atr[i]; u1=up[i-1]
        u=max(u,u1) if C[i-1]>u1 else u
        d=src[i]+mult*atr[i]; d1=dn[i-1]
        d=min(d,d1) if C[i-1]<d1 else d
        up[i]=u; dn[i]=d
        t=trend[i-1]
        if t==-1 and C[i]>d1: t=1
        elif t==1 and C[i]<u1: t=-1
        trend[i]=t
    trades=[]; pos=0; ent=None
    for i in range(start+1,n-1):
        flip = trend[i]!=trend[i-1]
        if flip:
            j=i+1; px=O[j]
            if pos!=0:
                pnl=(px-ent[0])*pos; risk=ent[1]
                trades.append((ent[2],pnl/risk-cost/risk))
            pos=trend[i]
            line=up[i] if pos==1 else dn[i]
            risk=abs(px-line)
            if risk<=0: risk=atr[i]
            ent=(px,risk,ks[j])
    return trades
def breakout_trades(ks,O,H,L,C,atr14,look,slm,cost,rr=2.0):
    n=len(C); trades=[]; busy=-1
    hh=np.full(n,np.nan); ll=np.full(n,np.nan)
    for i in range(look,n): hh[i]=H[i-look+1:i+1].max(); ll[i]=L[i-look+1:i+1].min()
    for i in range(look+1,n-2):
        if i<=busy: continue
        d=0
        if H[i]>hh[i-1]: d=1
        elif L[i]<ll[i-1]: d=-1
        if d==0 or np.isnan(atr14[i]): continue
        j=i+1; px=O[j]; risk=slm*atr14[i]
        sl=px-d*risk; tp=px+d*rr*risk; res=None
        for m in range(j,min(n,j+300)):
            if d==1:
                if L[m]<=sl: res=-1.0; ex=m; break
                if H[m]>=tp: res=rr; ex=m; break
            else:
                if H[m]>=sl: res=-1.0; ex=m; break
                if L[m]<=tp: res=rr; ex=m; break
        if res is None: continue
        trades.append((ks[j],res-cost/risk)); busy=ex
    return trades
def split(tr,cut): return [x for x in tr if x[0]<cut],[x for x in tr if x[0]>=cut]
if __name__=='__main__':
    out={}
    for name,(pat,cost) in MK.items():
        ks,A=smc.load(pat); O,H,L,C=A.T; n=len(C); cut=ks[int(0.7*n)]
        atr14=smc.atr_rma(H,L,C,14)
        print('=====',name,'barre',n,'taglio IS/OOS',cut)
        # S1 supertrend baseline
        tr=supertrend_trades(ks,O,H,L,C,10,3.0,cost); a,b=split(tr,cut)
        print('S1 Supertrend baseline (10,3): IS',fmt(metrics(a)),'| OOS',fmt(metrics(b)))
        # griglia IS
        grid={}
        for p in (7,10,14,21):
            for m in (2.0,2.5,3.0,4.0):
                t=supertrend_trades(ks,O,H,L,C,p,m,cost); ia,oo=split(t,cut); grid[(p,m)]=(metrics(ia),metrics(oo))
        print('S1 griglia (IS PF / n):')
        for p in (7,10,14,21): print('   p=%2d '%p,' '.join('m%.1f:%.2f/%d'%(m,grid[(p,m)][0]['pf'],grid[(p,m)][0]['n']) for m in (2.0,2.5,3.0,4.0)))
        out[name+'_S1']={'%d_%.1f'%k:v for k,v in grid.items()}
        # S2 breakout baseline
        tr=breakout_trades(ks,O,H,L,C,atr14,4,2.0,cost); a,b=split(tr,cut)
        print('S2 Breakout 4 barre SL2 ATR TP4: IS',fmt(metrics(a)),'| OOS',fmt(metrics(b)))
        g2={}
        for L_ in (4,8,12,20,30,50):
            for s in (1.0,1.5,2.0,3.0):
                t=breakout_trades(ks,O,H,L,C,atr14,L_,s,cost); ia,oo=split(t,cut); g2[(L_,s)]=(metrics(ia),metrics(oo))
        print('S2 griglia (IS PF / n):')
        for L_ in (4,8,12,20,30,50): print('   L=%2d '%L_,' '.join('sl%.1f:%.2f/%d'%(s,g2[(L_,s)][0]['pf'],g2[(L_,s)][0]['n']) for s in (1.0,1.5,2.0,3.0)))
        out[name+'_S2']={'%d_%.1f'%k:v for k,v in g2.items()}
    json.dump(out,open('tv_grid.json','w'),default=float)
