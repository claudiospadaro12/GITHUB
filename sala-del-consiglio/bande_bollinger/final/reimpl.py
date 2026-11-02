import sys, json, datetime
import numpy as np

IDX = sys.argv[1]
OUT = sys.argv[2]
K, TOL, MAXHOLD = 1.5, 0.5, 100
SPBP = {'NASUSD_EXT': 1.0, 'SPXUSD_EXT': 2.2}
FILES = {
 'P2015': ('2015', lambda s: f'ABTG_M1_{s}_2015.csv'),
 'P2020': ('2020', lambda s: f'ABTG_M1_{s}_2020.csv'),
 'P2025': ('2025_26', lambda s: f'ABTG_M1_{s}.csv'),
}
EPOCH = datetime.datetime(1970, 1, 1)

def load(path):
    t=[];o=[];h=[];l=[];c=[]
    bad=0
    with open(path) as f:
        f.readline()
        for line in f:
            p = line.strip().split(';')
            if len(p) < 5: bad+=1; continue
            try:
                d = datetime.datetime.strptime(p[0], '%Y.%m.%d %H:%M')
                vals = [float(x) for x in p[1:5]]
            except Exception:
                bad+=1; continue
            t.append(int((d-EPOCH).total_seconds()//60)+60)   # +60 min shift
            o.append(vals[0]);h.append(vals[1]);l.append(vals[2]);c.append(vals[3])
    t=np.array(t,dtype=np.int64)
    a=[np.array(x) for x in (o,h,l,c)]
    order=np.argsort(t,kind='stable'); 
    t=t[order]; a=[x[order] for x in a]
    # drop duplicate timestamps (keep first)
    keep=np.concatenate(([True], np.diff(t)>0))
    ndup=int((~keep).sum())
    t=t[keep]; a=[x[keep] for x in a]
    return t,a[0],a[1],a[2],a[3],bad,ndup

def month_index(day):
    d = EPOCH + datetime.timedelta(days=int(day))
    return d.year*12 + d.month - 1

def run(inst, per):
    sub, fn = FILES[per]
    t,o,h,l,c,bad,ndup = load(f'{IDX}/{sub}/{fn(inst)}')
    spbp = SPBP[inst]
    sp = spbp*1e-4*o
    n = len(t)
    # H1 bars
    hr = t//60
    starts_idx = np.concatenate(([0], np.nonzero(np.diff(hr))[0]+1))
    nb = len(starts_idx)
    ends_idx = np.concatenate((starts_idx[1:], [n]))  # exclusive
    bs = hr[starts_idx]*60   # bar start minutes
    bo = o[starts_idx]; bc = c[ends_idx-1]
    bh = np.array([h[a:b].max() for a,b in zip(starts_idx,ends_idx)])
    bl = np.array([l[a:b].min() for a,b in zip(starts_idx,ends_idx)])
    # D1, W1, MN
    day = t//1440
    week = (day+3)//7
    mon = np.array([month_index(d) for d in range(int(day.min()), int(day.max())+1)])
    mon_of_day = {d: mon[d-int(day.min())] for d in range(int(day.min()), int(day.max())+1)}
    def agg(keys):
        u, first = np.unique(keys, return_index=True)
        idxs = np.concatenate((first, [len(keys)]))
        # keys sorted nondecreasing since t sorted (day, week, month monotone)
        hi = np.array([h[idxs[i]:idxs[i+1]].max() for i in range(len(u))])
        lo = np.array([l[idxs[i]:idxs[i+1]].min() for i in range(len(u))])
        return u, hi, lo
    mkeys = np.array([mon_of_day[int(d)] for d in day])
    D = agg(day); W = agg(week); M = agg(mkeys)
    def prev(Aggr, key):
        u,hi,lo = Aggr
        i = np.searchsorted(u, key, side='left')-1
        if i < 0: return None
        return hi[i], lo[i]
    # indicators
    from numpy.lib.stride_tricks import sliding_window_view as swv
    sma = np.full(nb, np.nan); sig = np.full(nb, np.nan); atr = np.full(nb, np.nan)
    if nb >= 37:
        w = swv(bc, 37)
        sma[36:] = w.mean(axis=1); sig[36:] = w.std(axis=1, ddof=0)
    tr = np.full(nb, np.nan)
    pc = bc[:-1]
    tr[1:] = np.maximum(bh[1:]-bl[1:], np.maximum(np.abs(bh[1:]-pc), np.abs(bl[1:]-pc)))
    if nb >= 15:
        atr[13:] = swv(tr[1:], 14).mean(axis=1)[0:] if False else np.nan
        # TR_k for k=j-13..j needs k>=1 -> j>=14
        wt = swv(tr[1:], 14).mean(axis=1)   # index i covers tr[1+i .. 14+i] -> j=14+i
        atr[14:] = wt
    upper = sma+3*sig; lower = sma-3*sig

    trades=[]
    last_exit = -10**18
    j = 38   # at least 38 preceding bars in list -> j>=38
    while j < nb-1:
        j0=j; j+=1
        close_j = bs[j0]+60
        if not close_j > last_exit: continue
        if np.isnan(atr[j0]) or np.isnan(upper[j0]): continue
        st = int(bs[j0]); hh = (st%1440)//60
        d = st//1440; wk = (d+3)//7; mo = month_index(d)
        lv_hi=[];lv_lo=[]
        for A,key in ((D,d),(W,wk),(M,mo)):
            r = prev(A,key)
            if r: lv_hi.append(r[0]); lv_lo.append(r[1])
        side=None
        a = atr[j0]
        if bl[j0] <= lower[j0] and any(abs(L-bl[j0])<=TOL*a for L in lv_lo):
            side='LONG'
        if bh[j0] >= upper[j0] and any(abs(L-bh[j0])<=TOL*a for L in lv_hi):
            if side is None: side='SHORT'
            else: print("BOTH", inst, per, j0); side=None
        if side is None: continue
        if hh in (13,14): continue
        if bs[j0+1]-bs[j0] > 120: continue
        ei = starts_idx[j0+1]
        e_open = o[ei]; e_sp = sp[ei]
        if side=='LONG':
            entry = e_open+e_sp; SL = bl[j0]-K*a
            if entry <= SL: continue
            target = sma[j0]
            if target <= entry: continue
        else:
            entry = e_open; SL = bh[j0]+K*a
            if entry >= SL: continue
            target = sma[j0]
            if target >= entry: continue
        R0 = abs(entry-SL)
        # simulate
        exitp=None; reason=None; texit=None
        cur_bar = j0+1
        upd=False
        m = ei
        while m < n:
            hb = hr[m]
            if m>ei and hb != hr[m-1]:
                # new bar begins: previous bar (in list) closed
                cur_bar += 1
                target = sma[cur_bar-1]
                upd=True
            else:
                upd=False if m>ei else False
            o_,h_,l_ = o[m],h[m],l[m]; s_ = sp[m]
            # 1) SL gap at open
            if side=='LONG':
                if o_ <= SL: exitp=o_; reason='SL'; break
                if upd and o_ >= target: exitp=o_; reason='MKT'; break
            else:
                if o_+s_ >= SL: exitp=o_+s_; reason='SL'; break
                if upd and o_+s_ <= target: exitp=o_+s_; reason='MKT'; break
            if upd and cur_bar - (j0+1) >= MAXHOLD:
                exitp = o_ if side=='LONG' else o_+s_; reason='TF'; break
            if side=='LONG':
                if l_ <= SL: exitp=SL; reason='SL'; break
                if h_ >= target: exitp=target; reason='TP'; break
            else:
                if h_+s_ >= SL: exitp=SL; reason='SL'; break
                if l_+s_ <= target: exitp=target; reason='TP'; break
            m += 1
        if reason is None:
            m = n-1
            exitp = c[m] if side=='LONG' else c[m]+sp[m]
            reason='FINE_DATI'
        texit = int(t[m])
        R = (exitp-entry)/R0 if side=='LONG' else (entry-exitp)/R0
        trades.append(dict(strumento=inst, periodo=per, lato=side, t_in=int(t[ei]),
            prezzo_ingresso=float(entry), SL=float(SL), prezzo_uscita=float(exitp),
            motivo=reason, R=float(R), t_out=texit, target_iniziale=float(sma[j0])))
        last_exit = texit
    return trades, dict(n_m1=n, n_bars=nb, bad=bad, ndup=ndup, t0=int(t[0]), t1=int(t[-1]))

allt=[]
for inst in SPBP:
    for per in FILES:
        tr, info = run(inst, per)
        print(inst, per, info, 'N=',len(tr), flush=True)
        allt += tr
json.dump(allt, open(OUT,'w'), indent=0)
R = np.array([x['R'] for x in allt])
print('--- riepilogo')
for inst in SPBP:
    for per in FILES:
        s=[x['R'] for x in allt if x['strumento']==inst and x['periodo']==per]
        print(inst, per, 'N=',len(s), 'Rmedio=', round(float(np.mean(s)),4) if s else None)
print('N tot', len(R), 'R medio', R.mean(), 'win rate', (R>0).mean())
from collections import Counter
print(Counter(x['motivo'] for x in allt), Counter(x['lato'] for x in allt))
