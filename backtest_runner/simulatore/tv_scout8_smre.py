"""Port delle parti testabili di SMRE (TV n.28): L1 (OU/Hurst/ADF/VR) + L5 (VWAP/VPIN/volume) + moltiplicatore L2 + TCA. Criteri: report/SMRE_CRITERI_2026-11-19.md"""
import sys,csv,glob,math,json
import numpy as np
sys.path.insert(0,'/home/user/GITHUB/backtest_runner/simulatore')
from tv_scout8_backtest import metrics,fmt,split,sma,stdev
import smc_luxalgo_replica as smc
MK={'EURUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_EURUSD_*.csv',0.0001),'XAUUSD':('/tmp/claude-0/dati_ftmo*/ABTG_M1_XAUUSD_*.csv',0.35)}
def load_vol(pat):
    rows={}
    for f in sorted(glob.glob(pat)):
        with open(f) as fh:
            r=csv.reader(fh,delimiter=';'); next(r)
            for t,o,h,l,c,tv,*_ in r:
                tvv=float(tv)
                if t.endswith('00:00') and tvv>2000: continue
                k=t[:13]; o,h,l,c=float(o),float(h),float(l),float(c)
                if k not in rows: rows[k]=[o,h,l,c,tvv]
                else:
                    x=rows[k]; x[1]=max(x[1],h); x[2]=min(x[2],l); x[3]=c; x[4]+=tvv
    ks=sorted(rows); return ks,np.array([rows[k] for k in ks])
def l1_stats(src):  # src[0]=ultima barra
    ln=len(src)-1; X=src[1:ln+1]; Y=src[0:ln]; n=ln
    mx=X.mean(); my=Y.mean(); vx=(X*X).mean()-mx*mx; cov=(X*Y).mean()-mx*my
    b=cov/vx if vx>0 else np.nan; a=my-b*mx if b==b else np.nan
    theta=-math.log(b) if (b==b and 0<b<1) else np.nan
    mu=a/(1-b) if (b==b and b!=1) else np.nan
    hl=math.log(2)/theta if (theta==theta and theta>0) else np.nan
    res=X-(a+b*Y) if b==b else None
    sEps=math.sqrt((res*res).sum()/max(n-2,1)) if res is not None else np.nan
    sEq=sEps/math.sqrt(1-b*b) if (b==b and (1-b*b)>0) else np.nan
    # hurst
    nn=ln-1; r=np.log(src[0:nn]/src[1:nn+1]); m=r.mean()
    cs=np.cumsum((r[::-1]-m)); rng=max(cs.max(),-1e10)-min(cs.min(),1e10) if False else (cs.max()-cs.min())
    sd=math.sqrt(((r-m)**2).sum()/max(nn-1,1)); rs=rng/sd if sd>0 else np.nan
    H=math.log(rs)/math.log(nn) if (rs==rs and rs>0) else np.nan
    # adf
    y=src[1:ln+1]; dy=src[0:ln]-src[1:ln+1]
    my_=y.mean(); mdy=dy.mean(); SSxx=(y*y).sum()-n*my_*my_; SSxy=(y*dy).sum()-n*my_*mdy
    g=SSxy/SSxx if SSxx>0 else np.nan; al=mdy-g*my_ if g==g else np.nan
    if g==g:
        rr=dy-(al+g*y); s2=(rr*rr).sum()/max(n-2,1); se=math.sqrt(s2/SSxx) if SSxx>0 else np.nan
        adf=g/se if (se==se and se>0) else np.nan
    else: adf=np.nan
    def vr(q):
        if ln<=q+1: return np.nan
        c1=ln-1; r1=src[0:c1]-src[1:c1+1]; v1=((r1-r1.mean())**2).sum()/max(c1-1,1)
        cq=ln-q; rq=src[0:cq]-src[q:cq+q]; vq=((rq-rq.mean())**2).sum()/max(cq-1,1)
        return vq/(q*v1) if v1>0 else np.nan
    return mu,hl,sEq,H,adf,vr(2),vr(4),vr(8)
def signals(ks,O,H,L,C,V,l2mult=0.5,time_filter=True,ou=24):
    n=len(C); atr=smc.atr_rma(H,L,C,14)
    # session start: gap > 3x mediana barre
    t=np.array([ (int(k[0:4])*372+int(k[5:7])*31+int(k[8:10]))*24+int(k[11:13]) for k in ks],dtype=float)
    import datetime
    ts=np.array([datetime.datetime(int(k[0:4]),int(k[5:7]),int(k[8:10]),int(k[11:13])).timestamp() for k in ks])
    dt=np.diff(ts,prepend=ts[0]); sess=np.zeros(n,bool)
    for i in range(51,n):
        if dt[i]>3*np.median(dt[i-49:i+1]): sess[i]=True
    hour=np.array([int(k[11:13]) for k in ks]); day=np.array([k[:10] for k in ks])
    hlc3=(H+L+C)/3
    # vwap giornaliero
    vw=np.full(n,np.nan); pv=vv=0.0; cur=None
    for i in range(n):
        if day[i]!=cur: cur=day[i]; pv=vv=0.0
        pv+=hlc3[i]*V[i]; vv+=V[i]; vw[i]=pv/vv if vv>0 else np.nan
    dev=C-vw; dm=sma(dev,20); ds=stdev(dev,20); vz=np.where(ds>0,(dev-dm)/np.where(ds>0,ds,1),np.nan)
    # anchor vwap
    az=np.full(n,np.nan); apv=avs=asq=0.0; ab=0
    for i in range(n):
        if sess[i]: apv=avs=asq=0.0; ab=0
        vol=max(V[i],0.0); apv+=hlc3[i]*vol; avs+=vol; ab+=1
        av=apv/avs if avs>0 else np.nan
        if av==av and vol>0: asq+=(hlc3[i]-av)**2*vol
        sd=math.sqrt(asq/avs) if (avs>0 and ab>2) else np.nan
        if sd==sd and sd>0: az[i]=(C[i]-av)/sd
    vma=sma(V,20); spike=V>vma*1.5
    pc=np.diff(C,prepend=C[0]); cstd=stdev(pc,20)
    bf=np.where(cstd>0,1/(1+np.exp(-1.7*pc/np.where(cstd>0,cstd,1))),0.5); bv=V*bf; sv=V*(1-bf)
    ab_=np.abs(bv-sv); cs=lambda x,k:np.convolve(x,np.ones(k),'full')[:n]
    vpin=np.where(cs(V,50)>0,cs(ab_,50)/np.where(cs(V,50)>0,cs(V,50),1),0.0)
    vm=sma(vpin,100); vs_=stdev(vpin,100); vpz=(vpin-vm)/np.maximum(vs_,1e-10)
    ofi=cs(bv-sv,10)/np.maximum(cs(V,10),1)
    out=[]
    bs_since=0; last_sess=-10**9; sessidx=np.where(sess)[0]
    for i in range(max(ou+2,205),n-1):
        if sess[i]: bs_since=0
        else: bs_since+=1
        src=C[i-ou:i+1][::-1]
        mu,hl,sEq,Hu,adf,v2,v4,v8=l1_stats(src)
        gap=bool(sess[i-ou+1:i+1].any())
        hlOK=hl==hl and 0<hl<=60; hOK=Hu==Hu and Hu<0.55; aOK=adf==adf and adf<-2.86; vOK=v4==v4 and v4<1.0
        z=(C[i]-mu)/sEq if (mu==mu and sEq==sEq and sEq>0) else np.nan
        l1v=hlOK and hOK and aOK and vOK and not gap
        l1s=0;l1k=0.0
        if l1v and z==z: l1s=-1 if z>1.5 else (1 if z<-1.5 else 0); l1k=min(abs(z)/2.0,1.5)
        # L5
        rs=0;rk=0.0
        if vz[i]==vz[i]: rs=-1 if vz[i]>1.5 else (1 if vz[i]<-1.5 else 0); rk=min(abs(vz[i])/1.5,1.5)
        ass=0;ak=0.0;aav=az[i]==az[i]
        if aav: ass=-1 if az[i]>2.0 else (1 if az[i]<-2.0 else 0); ak=min(abs(az[i])/2.0,1.5)
        if aav:
            if ass==rs: cb=ass; ck=0.6*ak+0.4*rk
            elif ass!=0 and rs==0: cb=ass; ck=ak*0.6
            elif rs!=0 and ass==0: cb=rs; ck=rk*0.4
            else: cb=0; ck=0.0
        else: cb=rs; ck=rk
        al=(cb>0 and ofi[i]<0) or (cb<0 and ofi[i]>0)
        l5k=ck*(1.25 if spike[i] else 1.0)*(1.15 if al else 1.0)*(0.7 if (vpz[i]==vpz[i] and vpz[i]>2.0) else 1.0)
        raw=l1s*l1k*0.28+cb*l5k*0.22
        mult=max(0.5,min(1.5,l2mult)); comp=raw*mult; ca=abs(comp); d=1 if comp>0 else (-1 if comp<0 else 0)
        if d==0: continue
        hz=0
        if ca>=0.45 and (hl!=hl or hl>20) and (v8==v8 and v8<0.98 if True else True): hz=3
        elif ca>=0.40 and (hl!=hl or hl>10) and (v4==v4 and v4<0.98): hz=2
        elif ca>=0.25 and (v2==v2 and v2<0.98): hz=1
        if hz==0: continue
        emb=abs(C[i]-mu)/C[i]*1e4 if mu==mu else np.nan
        req=4.0*(1.0,1.5,2.0)[hz-1]
        if not (emb==emb and emb>req): continue
        h=hour[i]
        if time_filter:
            mo=(h-9)*60-15; mc=(15-h)*60+30
            if mo<15 or mc<15 or h==12: continue
        if bs_since<1: continue
        out.append((i,d,hz,mu,atr[i]))
    return out,atr
def trade(E,sig):
    ks,O,H,L,C,cost=E; n=len(C); tr=[]; busy=-1; touch=[]
    for i,d,hz,mu,a in sig:
        if i<=busy or i>=n-2 or a!=a: continue
        sl=C[i]-d*1.2*a; tg=max(mu,C[i]+2*a) if d>0 else min(mu,C[i]-2*a)
        j=i+1; px=O[j]; risk=abs(px-sl)
        if risk<=0.2*a: continue
        mb=(15,60,150)[hz-1]; res=None
        for m in range(j,min(n,j+mb)):
            if d>0:
                if L[m]<=sl: res=sl; ex=m; break
                if H[m]>=tg: res=tg; ex=m; break
            else:
                if H[m]>=sl: res=sl; ex=m; break
                if L[m]<=tg: res=tg; ex=m; break
        if res is None: ex=min(n-1,j+mb-1); res=C[ex]
        tr.append((ks[j],d*(res-px)/risk-cost/risk)); busy=ex
    return tr
if __name__=='__main__':
    out={}
    for name,(pat,cost) in MK.items():
        ks,A=load_vol(pat); O,H,L,C,V=A.T; cut=ks[int(0.7*len(C))]; print('==',name,len(C),'volume medio',V.mean(),flush=True)
        for tag,(m,tf) in {'V0 mult0.5 filtro ON':(0.5,True),'V1 mult1.0 filtro ON':(1.0,True),'V2 mult0.5 filtro OFF':(0.5,False),'V3 mult1.0 filtro OFF':(1.0,False)}.items():
            sig,atr=signals(ks,O,H,L,C,V,l2mult=m,time_filter=tf)
            E=(ks,O,H,L,C,cost); tr=trade(E,sig); a,b=split(tr,cut)
            hzc=[sum(1 for s in sig if s[2]==h) for h in (1,2,3)]
            print('%-24s segnali %d (scalp/swing/session %s) operazioni %d | IS %s | OOS %s'%(tag,len(sig),hzc,len(tr),fmt(metrics(a)),fmt(metrics(b))),flush=True)
            out[name+'|'+tag]=[len(sig),metrics(a),metrics(b)]
    json.dump(out,open('/tmp/claude-0/smre_res.json','w'),default=float)
