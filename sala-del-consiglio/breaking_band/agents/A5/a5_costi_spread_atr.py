#!/usr/bin/env python3
"""A5 - Costi: distribuzione dello spread dell'oro vs stop 3 ATR(14) su H1 e M15, e geometria del target (2 sigma20 in ATR).
SOLO distribuzioni marginali di spread/ATR/sigma: nessun pattern, nessuna regola, nessun PnL.
Uso: python3 -I a5_costi_spread_atr.py out.md file1.csv file2.csv ...
CSV: time;open;high;low;close;tickvol;spread (spread in punti, 1 punto = 0.01 USD). Dati trattati come non fidati.
Assunzioni dichiarate: ATR = Wilder(14) sul TR; Bollinger/sigma = 20 periodi, std di popolazione (ddof=0) sulle chiusure;
SMA50 della sigma; barre costruite da M1 con bucket = floor(minuti_epoch/tf) in ora server; TR del primo bar dopo un buco > 4*tf = H-L.
Spread d'ingresso = spread dell'ultimo M1 della barra precedente (proxy: ingresso all'apertura della barra dopo).
Perdita = 3ATR + s (stop misurato dal prezzo grafico, eseguito sul lato opposto); guadagno = d - s.
"""
import sys, os
import numpy as np
from numpy.lib.stride_tricks import sliding_window_view as swv

def carica(path):
    t, o, h, l, c, sp = [], [], [], [], [], []
    with open(path, 'r') as f:
        next(f)
        for ln in f:
            p = ln.rstrip('\n').split(';')
            if len(p) < 7:
                continue
            try:
                t.append(np.datetime64(p[0][:10].replace('.', '-') + 'T' + p[0][11:16]))
                o.append(float(p[1])); h.append(float(p[2])); l.append(float(p[3])); c.append(float(p[4])); sp.append(float(p[6]))
            except Exception:
                continue
    t = np.array(t, dtype='datetime64[m]').astype(np.int64)
    idx = np.argsort(t, kind='stable'); t = t[idx]
    return t, np.array(o)[idx], np.array(h)[idx], np.array(l)[idx], np.array(c)[idx], np.array(sp)[idx]

def barre(t, o, h, l, c, sp, tf):
    b = t // tf
    ub, first = np.unique(b, return_index=True)
    last = np.r_[first[1:] - 1, len(t) - 1]
    H = np.maximum.reduceat(h, first); L = np.minimum.reduceat(l, first)
    return dict(t=ub * tf, o=o[first], h=H, l=L, c=c[last], sp_open=sp[first], sp_last=sp[last])

def atr_wilder(B, n, tf):
    h, l, c, t = B['h'], B['l'], B['c'], B['t']
    pc = np.r_[c[0], c[:-1]]
    tr = np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc)))
    gap = np.r_[False, np.diff(t) > 4 * tf]
    tr = np.where(gap, h - l, tr)
    a = np.full(len(tr), np.nan)
    if len(tr) <= n:
        return a
    a[n - 1] = tr[:n].mean()
    for i in range(n, len(tr)):
        a[i] = (a[i - 1] * (n - 1) + tr[i]) / n
    return a

def pct(x, qs=(10, 50, 90, 99)):
    x = x[np.isfinite(x)]
    return [np.percentile(x, q) for q in qs] if len(x) else [np.nan] * len(qs)

out = []
def pr(s=""):
    print(s); out.append(s)

outpath = sys.argv[1]
files = sys.argv[2:]
pr("# A5 costi: spread vs stop 3 ATR(14) (marginali, nessun pattern)")
pr("Spread in USD = punti*0.01. Stop = 3*ATR14. s/stop = spread / (3 ATR).")
for tf, nm in ((60, 'H1'), (15, 'M15')):
    pr(f"\n## {nm}")
    pr("| periodo | barre | spread M1 P10/P50/P90/P99 USD | %spread=0 | ATR14 P10/P50/P90 USD | stop 3ATR P50 USD | s/stop P50 | s/stop P90 | %barre s/stop>10% | d=2sigma20/ATR P10/P50/P90 (tutte) | d (sigma>SMA50) P50 | d (sigma<SMA50) P50 |")
    pr("|---|---|---|---|---|---|---|---|---|---|---|---|")
    allrows = []
    for fp in files:
        t, o, h, l, c, sp = carica(fp)
        B = barre(t, o, h, l, c, sp, tf)
        A = atr_wilder(B, 14, tf)
        # sigma20 (popolazione) e sua SMA50
        c_ = B['c']; n = len(c_)
        sig = np.full(n, np.nan)
        if n >= 20:
            sig[19:] = swv(c_, 20).std(axis=1)
        sma = np.full(n, np.nan)
        ok = np.where(np.isfinite(sig))[0]
        if len(ok) > 50:
            s2 = sig[19:]
            sm = np.convolve(s2, np.ones(50) / 50, mode='valid')
            sma[19 + 49:] = sm
        spent = np.r_[np.nan, B['sp_last'][:-1]] * 0.01        # spread all'ingresso (proxy)
        stop = 3 * A
        valid = np.isfinite(A) & np.isfinite(spent) & (A > 0)
        ratio = spent[valid] / stop[valid]
        d = (2 * sig / A)
        vd = np.isfinite(d) & np.isfinite(sma)
        d_all = d[vd]
        d_hi = d[vd & (sig > sma)]; d_lo = d[vd & (sig <= sma)]
        spm1 = sp * 0.01
        p = pct(spm1)
        pa = pct(A[valid], (10, 50, 90))
        pd_ = pct(d_all, (10, 50, 90))
        name = os.path.basename(fp).replace('ABTG_M1_XAUUSD', 'XAU').replace('.csv', '') or fp
        pr(f"| {name} | {int(valid.sum())} | {p[0]:.2f}/{p[1]:.2f}/{p[2]:.2f}/{p[3]:.2f} | {np.mean(sp==0)*100:.1f}% | {pa[0]:.2f}/{pa[1]:.2f}/{pa[2]:.2f} | {3*pa[1]:.2f} | {np.median(ratio)*100:.1f}% | {np.percentile(ratio,90)*100:.1f}% | {np.mean(ratio>0.10)*100:.1f}% | {pd_[0]:.2f}/{pd_[1]:.2f}/{pd_[2]:.2f} | {np.median(d_hi):.2f} | {np.median(d_lo):.2f} |")
        allrows.append((name, np.median(ratio), np.median(d_all), np.median(d_hi), np.median(d_lo), np.median(spent[valid]/A[valid])))
    # effetto del costo su un target a distanza mediana d (in ATR) con stop 3 ATR
    pr(f"\n### {nm}: effetto dello spread su target a distanza mediana (R = unita di stop 3ATR; win rate 60%)")
    pr("Per periodo: s_ATR = spread mediano all'ingresso / ATR; gain = (d - s)/3 ; loss = 1 + s/3 (in unita 3ATR... d,s in ATR); PF = 0.6*gain/(0.4*loss); WR pareggio = loss/(gain+loss)")
    pr("| periodo | taglio d | d (ATR) | s (ATR) | gain R lordo | gain R netto | loss R | PF a WR60 lordo (s=0, loss=1) | PF a WR60 netto | WR pareggio netto |")
    pr("|---|---|---|---|---|---|---|---|---|---|")
    for name, rr, dall, dhi, dlo, s_atr in allrows:
        for lab, d in (('tutte', dall), ('sigma>SMA50', dhi), ('sigma<SMA50', dlo)):
            g0 = d / 3.0
            gn = (d - s_atr) / 3.0
            ln_ = 1 + s_atr / 3.0
            pf0 = 0.6 * g0 / 0.4
            pfn = 0.6 * gn / (0.4 * ln_) if gn > 0 else 0.0
            wr = ln_ / (gn + ln_) if gn > 0 else float('nan')
            pr(f"| {name} | {lab} | {d:.2f} | {s_atr:.3f} | {g0:.3f} | {gn:.3f} | {ln_:.3f} | {pf0:.2f} | {pfn:.2f} | {wr*100:.1f}% |")
open(outpath, 'w').write("\n".join(out) + "\n")
