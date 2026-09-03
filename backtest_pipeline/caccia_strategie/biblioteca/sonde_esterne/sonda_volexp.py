#!/usr/bin/env python3
# SONDA DI CONTEGGIO ESTERNA - meccanismo COMPRESSIONE -> ESPANSIONE
# Fonte dati: github FutureSharks/financial-data (histdata M1, GPL-3.0)
# NON e' il nostro broker, NON ci sono costi, NON e' un backtest di merito.
# Conta OCCASIONI e misura la GEOMETRIA. Il merito non si giudica qui.
import sys, os, glob
from collections import defaultdict
from statistics import median

def load_m1(paths):
    bars = []
    for p in sorted(paths):
        with open(p) as f:
            for line in f:
                line = line.strip()
                if not line: continue
                parts = line.split(';')
                if len(parts) < 5: continue
                ts = parts[0]
                o,h,l,c = float(parts[1]),float(parts[2]),float(parts[3]),float(parts[4])
                # ts = YYYYMMDD HHMMSS
                d = ts[0:8]; hh = int(ts[9:11]); mm = int(ts[11:13])
                bars.append((d, hh, mm, o,h,l,c))
    return bars

def aggregate(bars, minutes):
    out = []  # (day, hour, minute, o,h,l,c)
    cur = None
    for (d,hh,mm,o,h,l,c) in bars:
        slot = (d, hh, (mm//minutes)*minutes)
        if cur is None or cur[0] != slot:
            if cur is not None: out.append(cur[1])
            cur = (slot, [slot[0], slot[1], slot[2], o,h,l,c])
        else:
            b = cur[1]
            if h > b[4]: b[4] = h
            if l < b[5]: b[5] = l
            b[6] = c
    if cur is not None: out.append(cur[1])
    return out

def atr(bars, n):
    trs = []
    prev_close = None
    out = [None]*len(bars)
    s = 0.0
    for i,b in enumerate(bars):
        h,l,c = b[4],b[5],b[6]
        tr = h-l if prev_close is None else max(h-l, abs(h-prev_close), abs(l-prev_close))
        trs.append(tr); prev_close = c
        if i >= n:
            s -= trs[i-n]
        s += tr
        if i >= n-1:
            out[i] = s/n
    return out

def sma(vals, n):
    out=[None]*len(vals); s=0.0; cnt=0; buf=[]
    for i,v in enumerate(vals):
        if v is None:
            buf.append(None); continue
        buf.append(v); s+=v; cnt+=1
        if cnt>n:
            s-=buf[i-n]; cnt=n
        if cnt==n: out[i]=s/n
    return out

def run(bars, tf, comp=0.95, exp=1.02, volLen=20, atrMult=1.5, rr=2.0,
        hour_lo=None, hour_hi=None, fwd=20):
    b = aggregate(bars, tf)
    a = atr(b, volLen)
    avg = sma(a, volLen*2)
    lvlH = None; lvlL = None
    sig = {'L':[], 'S':[]}
    per_hour = defaultdict(int)
    prev_close = None
    for i in range(len(b)):
        if a[i] is None or avg[i] is None or avg[i]==0:
            prev_close=b[i][6]; continue
        ratio = a[i]/avg[i]
        c = b[i][6]; hh = b[i][1]
        if ratio < comp:
            lvlH = b[i][4]; lvlL = b[i][5]
        insess = True if hour_lo is None else (hour_lo <= hh <= hour_hi)
        if ratio > exp and prev_close is not None and insess:
            if lvlH is not None and prev_close <= lvlH and c > lvlH:
                sig['L'].append((i, c, a[i])); per_hour[hh]+=1; lvlH=None
            elif lvlL is not None and prev_close >= lvlL and c < lvlL:
                sig['S'].append((i, c, a[i])); per_hour[hh]+=1; lvlL=None
        prev_close = c
    days = len(set(x[0] for x in b))
    # geometria: take = rr * atrMult * ATR ; stop = atrMult*ATR
    res = {}
    for side in ('L','S'):
        S = sig[side]
        takes = [rr*atrMult*x[2] for x in S]
        stops = [atrMult*x[2] for x in S]
        mfes = []; maes = []
        for (i,entry,av) in S:
            hi = -1e18; lo = 1e18
            for j in range(i+1, min(i+1+fwd, len(b))):
                hi = max(hi, b[j][4]); lo = min(lo, b[j][5])
            if hi > -1e17:
                if side=='L': mfes.append(hi-entry); maes.append(entry-lo)
                else: mfes.append(entry-lo); maes.append(hi-entry)
        res[side] = dict(n=len(S), perday=len(S)/days if days else 0,
                         take_med=median(takes) if takes else 0,
                         stop_med=median(stops) if stops else 0,
                         mfe_med=median(mfes) if mfes else 0,
                         mae_med=median(maes) if maes else 0)
    res['_days']=days; res['_bars']=len(b); res['_hours']=dict(sorted(per_hour.items()))
    return res

if __name__ == '__main__':
    S = os.environ['S']
    sym = sys.argv[1]
    files = glob.glob(f"{S}/dati/{sym}_*.csv")
    bars = load_m1(files)
    print(f"### {sym}: {len(bars)} barre M1, file {len(files)}")
    for tf in (5,15):
        for (lo,hi,label) in [(None,None,'24h'),(3,11,'sessione cash EST 03-11')]:
            r = run(bars, tf, hour_lo=lo, hour_hi=hi)
            print(f"\n-- TF M{tf} [{label}] giorni={r['_days']} barre={r['_bars']}")
            for side in ('L','S'):
                d = r[side]
                print(f"   {side}: n={d['n']:5d}  segnali/giorno={d['perday']:.2f}  "
                      f"take(3xATR)={d['take_med']:.1f}  stop(1.5xATR)={d['stop_med']:.1f}  "
                      f"MFE20={d['mfe_med']:.1f}  MAE20={d['mae_med']:.1f}")
            if label.startswith('24h'):
                print("   ore:", r['_hours'])
