"""Port in Python dei 6 script TV_SCOUT_8 (21,23,24,25,26,27) e backtest IS/OOS. Criteri: report/TV_SCOUT_8_CRITERI_2026-11-19.md"""
import sys,json,itertools
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
import smc_luxalgo_replica as smc
from tv_scout_backtest import metrics,fmt,split,rma,trange
MK={'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',0.0001),'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',0.35)}
def sma(x,p):
    o=np.full(len(x),np.nan); c=np.cumsum(np.insert(x,0,0.0)); o[p-1:]=(c[p:]-c[:-p])/p; return o
def stdev(x,p):
    o=np.full(len(x),np.nan)
    for i in range(p-1,len(x)): o[i]=x[i-p+1:i+1].std()
    return o
def ema(x,p):
    a=2.0/(p+1); o=np.full(len(x),np.nan); o[p-1]=x[:p].mean()
    for i in range(p,len(x)): o[i]=a*x[i]+(1-a)*o[i-1]
    return o
def rsi(C,p):
    d=np.diff(C,prepend=C[0]); up=np.where(d>0,d,0.0); dn=np.where(d<0,-d,0.0)
    ru=rma(up[1:],p); rd=rma(dn[1:],p); o=np.full(len(C),np.nan)
    with np.errstate(divide='ignore',invalid='ignore'): o[1:]=np.where(rd==0,100.0,100-100/(1+ru/rd))
    return o
def xover(a,b,i): return a[i]>b[i] and a[i-1]<=b[i-1]
def xunder(a,b,i): return a[i]<b[i] and a[i-1]>=b[i-1]
class Env:
    def __init__(s,ks,O,H,L,C,cost):
        s.ks,s.O,s.H,s.L,s.C,s.cost=ks,O,H,L,C,cost; s.atr=smc.atr_rma(H,L,C,14)
    def R(s,d,ent,ex,risk): return d*(ex-ent)/risk-s.cost/risk
# ---- motore a posizione-bersaglio: tgt[i] in {None,-1,0,1} deciso alla chiusura di i, eseguito all'apertura di i+1 ----
def run_target(E,tgt):
    O,atr=E.O,E.atr; pos=0; ent=None; tr=[]; n=len(O)
    for i in range(n-1):
        t=tgt[i]
        if t is None or t==pos: continue
        px=O[i+1]
        if pos!=0:
            tr.append((ent[2],E.R(pos,ent[0],px,ent[1])))
        pos=t
        if pos!=0:
            a=atr[i]
            if np.isnan(a) or a<=0: pos=0; continue
            ent=(px,2*a,E.ks[i+1])
    return tr
def s21(E,small=2,big=8,pct=1.0):
    C=E.C; sm=sma(C,small); bg=sma(C,big); buy=(100-pct)/100*bg; tg=[None]*len(C); pos=0
    for i in range(big+1,len(C)-1):
        if pos==0 and xunder(sm,buy,i): tg[i]=1; pos=1
        elif pos==1 and xover(sm,bg,i): tg[i]=0; pos=0
    return run_target(E,tg)
def s23(E,length=20,confirm=True,short=True):
    H,L=E.H,E.L; n=len(H); U=np.full(n,np.nan); Lo=np.full(n,np.nan)
    for i in range(length-1,n): U[i]=H[i-length+1:i+1].max(); Lo[i]=L[i-length+1:i+1].min()
    il=ish=False; tg=[None]*n
    for i in range(length+2,n-1):
        if (not il) and U[i]>U[i-1]:
            if (not confirm) or U[i-1]>U[i-2]: tg[i]=1; il=True; ish=False
        else:
            if (not ish) and Lo[i]<Lo[i-1]:
                if (not confirm) or Lo[i-1]<Lo[i-2]:
                    if il and not short: tg[i]=0; il=False
                    if short: tg[i]=-1; il=False; ish=True
    return run_target(E,tg)
def s24(E,length=20,mult=2.0,os_=30,ob=70):
    C=E.C; b=sma(C,length); sd=stdev(C,length); up=b+mult*sd; lo=b-mult*sd; r=rsi(C,14); tg=[None]*len(C); pos=0
    for i in range(max(length,15),len(C)-1):
        p=pos
        if C[i]<lo[i] and r[i]<os_ and pos<1: p=pos+1
        if C[i]>up[i] and r[i]>50 and pos>0: p=0
        if C[i]>up[i] and r[i]>ob and pos>-1: p=p-1 if p>-1 else p
        if pos<0 and C[i]<=b[i]: p=0 if not(C[i]<lo[i] and r[i]<os_) else p
        p=max(-1,min(1,p))
        if p!=pos: tg[i]=p; pos=p
    return run_target(E,tg)
def s25(E,rl=3,osl=40,ob=70):
    r=rsi(E.C,rl); tg=[None]*len(r); pos=0
    for i in range(rl+2,len(r)-1):
        if xover(r,np.full(len(r),osl),i) and pos!=1: tg[i]=1; pos=1
        elif xunder(r,np.full(len(r),ob),i) and pos!=-1: tg[i]=-1; pos=-1
    return run_target(E,tg)
def s26(E,win=80,zt=2.5,rsi_os=30,rsi_ob=70,bbmin=0.02,use_bb=True,ema_len=200,slm=2.0,tpm=3.0,cd=5):
    O,H,L,C,atr=E.O,E.H,E.L,E.C,E.atr; n=len(C)
    m=sma(C,win); sd=stdev(C,win); z=np.where(sd>0,(C-m)/np.where(sd>0,sd,1),0.0)
    r=rsi(C,14); b=sma(C,20); bw=(4*stdev(C,20))/b; em=ema(C,ema_len)
    ls=(z<-zt)&(r<rsi_os)&((bw>bbmin) if use_bb else True)&(C>em)
    ss=(z>zt)&(r>rsi_ob)&((bw>bbmin) if use_bb else True)&(C<em)
    bc=sc=cd; pos=0; sl=tp=np.nan; pend=None; tr=[]; ent=None; prev_close_pos=0
    for i in range(max(win,ema_len)+1,n-1):
        # riempimenti all'apertura di i
        if pend is not None:
            d=pend; pend=None
            if pos!=0 and pos!=d: tr.append((ent[2],E.R(pos,ent[0],O[i],ent[1]))); pos=0
            if pos==0: pos=d; ent=[O[i],None,E.ks[i]]
        # SL/TP calcolati alla chiusura della barra di riempimento (solo se la barra precedente era flat)
        if pos!=0 and prev_close_pos==0:
            sl=C[i]-pos*atr[i]*slm; tp=C[i]+pos*atr[i]*tpm; ent[1]=max(abs(ent[0]-sl),0.5*atr[i])
        elif pos!=0 and ent[1] is None: ent[1]=max(abs(ent[0]-sl),0.5*atr[i])
        elif pos!=0 and ent[1] is not None and prev_close_pos!=pos: ent[1]=max(abs(ent[0]-sl),0.5*atr[i])
        # uscite SL/TP attive dalla barra dopo il riempimento
        if pos!=0 and prev_close_pos==pos:
            ex=None
            if pos==1:
                if L[i]<=sl: ex=min(O[i],sl)
                elif H[i]>=tp: ex=max(O[i],tp)
            else:
                if H[i]>=sl: ex=max(O[i],sl)
                elif L[i]<=tp: ex=min(O[i],tp)
            if ex is not None: tr.append((ent[2],E.R(pos,ent[0],ex,ent[1]))); pos=0
        prev_close_pos=pos
        bc+=1; sc+=1
        if ls[i] and bc>=cd: pend=1; bc=0; sc=cd
        if ss[i] and sc>=cd: pend=-1; sc=0; bc=cd
        if pend is not None and pend==pos: pend=None
    return tr
def s27_signals(E,prd=5,bo_len=200,cw=0.03,mintest=2):
    O,H,L,C=E.O,E.H,E.L,E.C; n=len(C); phv=[];phl=[];plv=[];pll=[]; sig=[]
    for i in range(n):
        if i>=2*prd:
            c=i-prd
            if H[c]>H[c-prd:c].max() and H[c]>H[c+1:i+1].max(): 
                phv.insert(0,H[c]); phl.insert(0,c)
                if len(phv)>1:
                    for x in range(len(phl)-1,0,-1):
                        if i-phl[x]>bo_len: phl.pop(); phv.pop()
            if L[c]<L[c-prd:c].min() and L[c]<L[c+1:i+1].min():
                plv.insert(0,L[c]); pll.insert(0,c)
                if len(plv)>1:
                    for x in range(len(pll)-1,0,-1):
                        if i-pll[x]>bo_len: pll.pop(); plv.pop()
        if i<prd+1: continue
        lll=max(min(i,300),1); chw=(H[i-lll+1:i+1].max()-L[i-lll+1:i+1].min())*cw
        hg=H[i-prd:i].max(); lw=L[i-prd:i].min(); d=0
        if len(phv)>=mintest and C[i]>O[i] and C[i]>hg:
            bm=phv[0]; xx=0
            for x in range(len(phv)):
                if phv[x]>=C[i]: break
                xx=x; bm=max(bm,phv[x])
            if xx>=mintest and O[i]<=bm:
                num=sum(1 for x in range(xx+1) if phv[x]<=bm and phv[x]>=bm-chw)
                if not(num<mintest or hg>=bm): d=1
        if d==0 and len(plv)>=mintest and C[i]<O[i] and C[i]<lw:
            bn=plv[0]; xx=0
            for x in range(len(plv)):
                if plv[x]<=C[i]: break
                xx=x; bn=min(bn,plv[x])
            if xx>=mintest and O[i]>=bn:
                num=sum(1 for x in range(xx+1) if plv[x]>=bn and plv[x]<=bn+chw)
                if not(num<mintest or lw<=bn): d=-1
        if d: sig.append((i,d))
    return sig
def s27(E,prd=5,mintest=2,slm=2.0,rr=2.0,sig=None):
    O,H,L=E.O,E.H,E.L; atr=E.atr; n=len(O); tr=[]; busy=-1
    if sig is None: sig=s27_signals(E,prd=prd,mintest=mintest)
    for i,d in sig:
        if i<=busy or i>=n-2 or np.isnan(atr[i]): continue
        j=i+1; px=O[j]; risk=slm*atr[i]; sl=px-d*risk; tp=px+d*rr*risk; res=None
        for m in range(j,min(n,j+300)):
            if d==1:
                if L[m]<=sl: res=-1.0; ex=m; break
                if H[m]>=tp: res=rr; ex=m; break
            else:
                if H[m]>=sl: res=-1.0; ex=m; break
                if L[m]<=tp: res=rr; ex=m; break
        if res is None: continue
        tr.append((E.ks[j],res-E.cost/risk)); busy=ex
    return tr
def show(tag,tr,cut):
    a,b=split(tr,cut); return '%-34s IS %s | OOS %s'%(tag,fmt(metrics(a)),fmt(metrics(b))),metrics(a),metrics(b)
if __name__=='__main__':
    out={}
    for name,(pat,cost) in MK.items():
        ks,A=smc.load(pat); O,H,L,C=A.T; n=len(C); cut=ks[int(0.7*n)]; E=Env(ks,O,H,L,C,cost)
        print('=====',name,'barre',n,'taglio',cut,flush=True)
        base=[('21 Jaws (2,8,1%)',lambda:s21(E)),('23 Donchian (20, conferma)',lambda:s23(E)),('24 Peri BB+RSI (20,2)',lambda:s24(E)),
              ('25 RSI3 40/70',lambda:s25(E)),('26 Z-Score default',lambda:s26(E)),('26 Z-Score BB filtro OFF',lambda:s26(E,use_bb=False)),('27 Breakout Finder SL2/TP4',lambda:s27(E))]
        for tag,f in base:
            line,ma,mb=show(tag,f(),cut); print(line,flush=True); out[name+'|'+tag]=[ma,mb]
        grids={'21':[(f'21 big{b} pct{p}',(lambda b=b,p=p:s21(E,big=b,pct=p))) for b in (5,8,12,20) for p in (0.25,0.5,1.0,2.0)],
               '23':[(f'23 len{l} conf{c}',(lambda l=l,c=c:s23(E,length=l,confirm=c))) for l in (10,20,40,80) for c in (True,False)],
               '24':[(f'24 len{l} m{m}',(lambda l=l,m=m:s24(E,length=l,mult=m))) for l in (10,20,40) for m in (1.5,2.0,2.5)],
               '25':[(f'25 rsi{r} os{o}',(lambda r=r,o=o:s25(E,rl=r,osl=o))) for r in (2,3,5,7) for o in (30,35,40,45)],
               '26':[(f'26 win{w} z{z}',(lambda w=w,z=z:s26(E,win=w,zt=z,use_bb=False))) for w in (40,80,160) for z in (2.0,2.5,3.0)],
               '27':[(f'27 prd{p} min{m}',(lambda p=p,m=m:s27(E,prd=p,mintest=m))) for p in (3,5,8) for m in (1,2,3)]}
        for g,cells in grids.items():
            res=[]
            for tag,f in cells:
                a,b=split(f(),cut); res.append((tag,metrics(a),metrics(b)))
            ok=[r for r in res if r[1]['n']>=100]
            best=max(ok,key=lambda r:r[1]['pf']) if ok else None
            pl=sum(1 for r in ok if r[1]['pf']>=1.3)
            print('  griglia %s: celle %d, con >=100 trade IS %d, con PF IS>=1.3: %d | migliore: %s'%(g,len(res),len(ok),pl,('%s IS PF %.2f n=%d DD %.0f%% | OOS PF %.2f n=%d'%(best[0],best[1]['pf'],best[1]['n'],best[1]['dd'],best[2]['pf'],best[2]['n'])) if best else 'nessuna'),flush=True)
            out[name+'|grid'+g]=[(r[0],r[1],r[2]) for r in res]
    json.dump(out,open('/tmp/claude-0/tv8_grid.json','w'),default=float)
