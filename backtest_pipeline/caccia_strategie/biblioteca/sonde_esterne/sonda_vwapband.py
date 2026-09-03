#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - meccanismo BANDA ATR SU ANCORA DI SESSIONE + RIENTRO
# (dal Pine "VWAP Mean Reversion (2 Candle Rejection)", Spencer1976, tv 3Q98707C)
# LIMITE DICHIARATO: i CSV histdata sugli indici hanno volume = 0.
# La VWAP e' quindi approssimata con la MEDIA CUMULATIVA di hlc3 dall'inizio
# della giornata (ancora di sessione). Non e' la VWAP vera: la frequenza e'
# indicativa, non certificata.
import os, glob, sys
from statistics import median
sys.path.insert(0, os.environ['S'])
import importlib.util
spec = importlib.util.spec_from_file_location("sv", os.environ['S']+"/sonda_volexp.py")
sv = importlib.util.module_from_spec(spec); spec.loader.exec_module(sv)

def ema(vals, n):
    out=[None]*len(vals); k=2/(n+1); e=None
    for i,v in enumerate(vals):
        e = v if e is None else v*k + e*(1-k)
        out[i]=e
    return out

def run(bars, tf, bandMult=2.5, stopMult=4.0, atrLen=14, flatK=0.4, rrMin=1.5,
        flat_on=True, fwd=20, hour_lo=None, hour_hi=None):
    b = sv.aggregate(bars, tf)
    a = sv.atr(b, atrLen)
    closes=[x[6] for x in b]
    e20 = ema(closes,20)
    anchor=None; csum=0.0; cnt=0
    vw=[None]*len(b)
    for i,x in enumerate(b):
        if x[0]!=anchor:
            anchor=x[0]; csum=0.0; cnt=0
        csum += (x[4]+x[5]+x[6])/3.0; cnt += 1
        vw[i]=csum/cnt
    sig={'L':[], 'S':[]}
    for i in range(11,len(b)):
        if a[i] is None: continue
        hh=b[i][1]
        if hour_lo is not None and not (hour_lo<=hh<=hour_hi): continue
        up=vw[i]+a[i]*bandMult; lo=vw[i]-a[i]*bandMult
        upS=vw[i]+a[i]*stopMult; loS=vw[i]-a[i]*stopMult
        upP=vw[i-1]+a[i-1]*bandMult if a[i-1] else None
        loP=vw[i-1]-a[i-1]*bandMult if a[i-1] else None
        flat = abs(e20[i]-e20[i-10]) < a[i]*flatK
        if flat_on and not flat: continue
        c=b[i][6]
        longRej = (loP is not None and b[i-1][5]<loP) or (b[i][5]<lo)
        shortRej= (upP is not None and b[i-1][4]>upP) or (b[i][4]>up)
        if longRej and c>lo:
            risk=c-loS; rew=vw[i]-c
            if risk>0 and rew>=risk*rrMin: sig['L'].append((i,c,risk,rew))
        elif shortRej and c<up:
            risk=upS-c; rew=c-vw[i]
            if risk>0 and rew>=risk*rrMin: sig['S'].append((i,c,risk,rew))
    days=len(set(x[0] for x in b))
    out={}
    for side in ('L','S'):
        S=sig[side]; mfe=[]; mae=[]
        for (i,entry,risk,rew) in S:
            hi=-1e18; lw=1e18
            for j in range(i+1,min(i+1+fwd,len(b))):
                hi=max(hi,b[j][4]); lw=min(lw,b[j][5])
            if hi>-1e17:
                if side=='L': mfe.append(hi-entry); mae.append(entry-lw)
                else: mfe.append(entry-lw); mae.append(hi-entry)
        out[side]=dict(n=len(S), perday=len(S)/days if days else 0,
            take_med=median([x[3] for x in S]) if S else 0,
            stop_med=median([x[2] for x in S]) if S else 0,
            rr_med=median([x[3]/x[2] for x in S]) if S else 0,
            mfe=median(mfe) if mfe else 0, mae=median(mae) if mae else 0)
    out['_days']=days
    return out

if __name__=='__main__':
    S=os.environ['S']
    for sym in ("GRXEUR","SPXUSD"):
        bars=sv.load_m1(glob.glob(f"{S}/dati/{sym}_*.csv"))
        print(f"\n##### {sym} ({len(bars)} barre M1)")
        for tf in (5,15):
            for flat_on in (True,False):
                r=run(bars,tf,flat_on=flat_on,fwd=(60 if tf==5 else 20))
                tag="con filtro FLAT" if flat_on else "SENZA filtro flat"
                print(f"  M{tf} [{tag}] giorni={r['_days']}")
                for side in ('L','S'):
                    d=r[side]
                    print(f"     {side}: n={d['n']:5d} {d['perday']:.2f}/gg  take={d['take_med']:.1f} stop={d['stop_med']:.1f} RR={d['rr_med']:.2f}  MFE={d['mfe']:.1f} MAE={d['mae']:.1f}")
