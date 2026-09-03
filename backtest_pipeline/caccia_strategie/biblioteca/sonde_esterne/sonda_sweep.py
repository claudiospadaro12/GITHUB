#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - SWEEP DI MICRO-PIVOT + RIENTRO
# (meccanica di "Asia Liquidity Sweep Reversal Scalper", bradenstrock, tv 4IevbowH)
# Domanda: la densita' di livelli che ha ucciso R89 (14 trade IS con swing H4
# a 21 barre/lato) si risolve con un pivot(3,3) sul TF di lavoro?
import os,glob,importlib.util
from statistics import median
S=os.environ['S']
spec=importlib.util.spec_from_file_location("sv",S+"/sonda_volexp.py")
sv=importlib.util.module_from_spec(spec); spec.loader.exec_module(sv)

def rsi(closes,n=14):
    out=[None]*len(closes); g=l=0.0
    for i in range(1,len(closes)):
        d=closes[i]-closes[i-1]
        up=max(d,0.0); dn=max(-d,0.0)
        if i<=n: g+=up; l+=dn
        if i==n: g/=n; l/=n
        if i>n:
            g=(g*(n-1)+up)/n; l=(l*(n-1)+dn)/n
        if i>=n:
            out[i]=100.0 if l==0 else 100-100/(1+g/l)
    return out

def run(bars,tf,left=3,right=3,rsiMaxLong=45,rsiMinShort=55,atrLen=14,
        slM=1.2,tpM=1.4,fwd=25,use_rsi=True):
    b=sv.aggregate(bars,tf); a=sv.atr(b,atrLen)
    cl=[x[6] for x in b]; r=rsi(cl,14)
    lastPH=lastPL=None
    sig={'L':[],'S':[]}
    for i in range(left+right+1,len(b)):
        # pivot confermato: la barra i-right e' un pivot se estremo su left+right intorno
        p=i-right
        if p-left>=0:
            hs=[b[j][4] for j in range(p-left,p+right+1)]
            ls=[b[j][5] for j in range(p-left,p+right+1)]
            if b[p][4]==max(hs): lastPH=b[p][4]
            if b[p][5]==min(ls): lastPL=b[p][5]
        if a[i] is None or r[i] is None: continue
        c=b[i][6]
        if lastPL is not None and b[i][5]<lastPL and c>lastPL and (not use_rsi or r[i]<=rsiMaxLong):
            sig['L'].append((i,c,a[i]))
        elif lastPH is not None and b[i][4]>lastPH and c<lastPH and (not use_rsi or r[i]>=rsiMinShort):
            sig['S'].append((i,c,a[i]))
    days=len(set(x[0] for x in b)); out={}
    for side in ('L','S'):
        Sg=sig[side]; mfe=[];mae=[]
        for (i,e,av) in Sg:
            hi=-1e18;lw=1e18
            for j in range(i+1,min(i+1+fwd,len(b))): hi=max(hi,b[j][4]); lw=min(lw,b[j][5])
            if hi>-1e17:
                if side=='L': mfe.append(hi-e); mae.append(e-lw)
                else: mfe.append(e-lw); mae.append(hi-e)
        out[side]=dict(n=len(Sg),perday=len(Sg)/days if days else 0,
          take=median([tpM*x[2] for x in Sg]) if Sg else 0,
          stop=median([slM*x[2] for x in Sg]) if Sg else 0,
          mfe=median(mfe) if mfe else 0, mae=median(mae) if mae else 0)
    out['_days']=days; return out

for sym in ("GRXEUR","SPXUSD"):
    bars=sv.load_m1(glob.glob(f"{S}/dati/{sym}_*.csv"))
    print(f"\n##### {sym}")
    for tf in (5,15):
        for use_rsi in (True,False):
            o=run(bars,tf,use_rsi=use_rsi)
            tag="con gate RSI" if use_rsi else "SENZA gate RSI (sweep nudo)"
            print(f"  M{tf} [{tag}] giorni={o['_days']}")
            for s in ('L','S'):
                d=o[s]
                print(f"     {s}: n={d['n']:6d} {d['perday']:.2f}/gg take(1.4ATR)={d['take']:.1f} stop(1.2ATR)={d['stop']:.1f} MFE25={d['mfe']:.1f} MAE25={d['mae']:.1f}")
