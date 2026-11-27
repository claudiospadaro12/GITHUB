#!/usr/bin/env python3
"""ADATTATORE ea_triage_routine: stessa replica ma esporta il log operazioni normalizzato (PRUDENTE). Replica Python di BreakingBand_ALLCROSSES_v42.mq5 (Leonardo) su forex H1. Criteri: report/BB_V42_PORT_CRITERI_2026-11-24.md.
Uso: /usr/bin/python3 -I bb_v42_port.py <cartella_H1> [<out_txt>]"""
import sys, math
import numpy as np, pandas as pd
D = sys.argv[1]; OUT = sys.argv[2]
PAIRS = {'EURUSD':0.8,'USDJPY':1.0,'GBPUSD':1.2,'AUDUSD':1.2,'EURGBP':1.5,'USDCAD':1.5,'USDCHF':1.5,'NZDUSD':1.8,'EURJPY':1.8,'GBPJPY':2.8}
START, END, SPLIT, S2526 = '2005-01-01', '2026-11-20', pd.Timestamp('2016-01-01'), pd.Timestamp('2025-01-01')
out = []
def P(*a):
    s = ' '.join(str(x) for x in a); print(s); out.append(s)
TIMEOUT = 40; SLM = 3.0; BEM = 1.0
def run_pair(name, df, optimistic):
    pip = 0.01 if 'JPY' in name else 0.0001; pt = pip / 10
    o = df.open.values; h = df.high.values; l = df.low.values; c = df.close.values; T = df.t.values
    n = len(df); cs = pd.Series(c)
    ma = cs.rolling(20).mean().values; sd = cs.rolling(20).std(ddof=0).values
    bu = ma + 2 * sd; bl = ma - 2 * sd
    pc = np.r_[np.nan, c[:-1]]
    tr = np.maximum(h - l, np.maximum(np.abs(h - pc), np.abs(l - pc)))
    atr = pd.Series(tr).rolling(14).mean().values
    SCAN, CONT, INVM, INVR, ACT = 0, 1, 2, 3, 4
    st = SCAN; cnt = 0; bdir = 0; bcnt = 0; oppR = False
    imp = opp = med0 = atrs = 0.0
    tr_ = None; trades = []
    def reset():
        nonlocal st, cnt, imp, opp, med0, atrs
        st = SCAN; cnt = 0; imp = opp = med0 = atrs = 0.0
    def hard():
        nonlocal bcnt, bdir, oppR
        bcnt = 0; bdir = 0; oppR = False
    def place(t, d, ent, tag):
        nonlocal tr_
        bid = o[t]
        if d == 1:
            if ent >= bid: ent = bid - 2 * pt
            sl = ent - SLM * atrs
        else:
            if ent <= bid: ent = bid + 2 * pt
            sl = ent + SLM * atrs
        tr_ = dict(d=d, ent=ent, sl=sl, sl0=sl, tp=tpv, atr=atrs, status='pend', tag=tag, fill=None, t=t)
        return True
    for t in range(40, n):
        # --- gestione operazione (inizio barra): aggiornamento TP della posizione aperta
        if tr_ is not None and tr_['status'] == 'open':
            m = ma[t - 1]
            if tr_['d'] == 1 and m > tr_['tp']: tr_['tp'] = m
            if tr_['d'] == -1 and m < tr_['tp']: tr_['tp'] = m
        # --- passo della macchina a stati (apre barra t, usa barra t-1)
        if st == ACT:
            if tr_ is None or tr_['status'] == 'done':
                tr_ = None; reset()
        else:
            hi, lo, cl = h[t - 1], l[t - 1], c[t - 1]; mm = ma[t - 1]
            if st == SCAN:
                if not (np.isnan(bu[t - 1]) or np.isnan(atr[t - 1])):
                    bUp = hi >= bu[t - 1]; bDn = lo <= bl[t - 1]
                    if bUp or bDn:
                        nd = 1 if bUp else -1
                        if bdir == 0 or nd != bdir: bdir = nd; bcnt = 1
                        elif oppR:
                            bcnt = min(bcnt + 1, 3)
                        else: bcnt = 1
                        imp = bu[t - 1] if nd == 1 else bl[t - 1]; opp = bl[t - 1] if nd == 1 else bu[t - 1]
                        med0 = mm; atrs = atr[t - 1]; oppR = False; cnt = 0
                        st = CONT if bcnt <= 2 else INVM
            elif st == CONT:
                if cnt > TIMEOUT: hard(); reset()
                else:
                    reached = False
                    if bdir == 1 and lo <= opp: reached = True; d = 1; ent = opp
                    elif bdir == -1 and hi >= opp: reached = True; d = -1; ent = opp
                    if reached:
                        oppR = True; tpv = mm
                        if abs(tpv - ent) < atrs * 0.5: reset()
                        else:
                            place(t, d, ent, 'CONT'); st = ACT; cnt = 0
            elif st == INVM:
                if cnt > TIMEOUT: hard(); reset()
                elif (bdir == 1 and lo <= opp) or (bdir == -1 and hi >= opp): reset()
                else:
                    atm = (lo <= mm or cl <= mm * 1.001) if bdir == 1 else (hi >= mm or cl >= mm * 0.999)
                    if atm: st = INVR; cnt = 0
            elif st == INVR:
                if cnt > TIMEOUT: hard(); reset()
                elif (bdir == 1 and lo <= opp) or (bdir == -1 and hi >= opp): reset()
                else:
                    reached = False
                    if bdir == 1 and hi >= imp: reached = True; d = -1; ent = imp
                    elif bdir == -1 and lo <= imp: reached = True; d = 1; ent = imp
                    if reached:
                        tpv = mm
                        if abs(tpv - ent) < atrs * 0.5: reset()
                        else:
                            place(t, d, ent, 'INV'); st = ACT; cnt = 0
            if st != ACT: cnt += 1
            else: cnt += 1
        # --- movimento del prezzo nella barra t per l'operazione
        if tr_ is not None and tr_['status'] != 'done':
            x = tr_; d = x['d']
            if x['status'] == 'pend':
                fill = (l[t] <= x['ent']) if d == 1 else (h[t] >= x['ent'])
                if fill:
                    x['fp'] = min(x['ent'], o[t]) if d == 1 else max(x['ent'], o[t])
                    x['status'] = 'open'; x['fill'] = t; x['fillday'] = T[t]; x['be'] = False
                    infill = True
                else: infill = False; continue
            else: infill = False
            ep = x['fp']; sl = x['sl']; tp = x['tp']
            hit_sl = (l[t] <= sl) if d == 1 else (h[t] >= sl)
            hit_tp = (h[t] >= tp) if d == 1 else (l[t] <= tp)
            trig = (h[t] >= ep + x['atr']) if d == 1 else (l[t] <= ep - x['atr'])
            exitp = None
            if optimistic:
                if hit_tp: exitp = max(tp, o[t]) if d == 1 else min(tp, o[t])
                elif hit_sl: exitp = min(sl, o[t]) if d == 1 else max(sl, o[t])
                elif trig and not x['be']: x['be'] = True; x['sl'] = ep + d * pt
            else:
                if hit_sl: exitp = min(sl, o[t]) if d == 1 else max(sl, o[t])
                elif hit_tp: exitp = max(tp, o[t]) if d == 1 else min(tp, o[t])
                elif trig and not x['be']: x['be'] = True; x['sl'] = ep + d * pt
            if exitp is not None:
                risk = abs(x['ent'] - x['sl0'])
                R = d * (exitp - ep) / risk
                f0 = x['fill']; seg_h = h[f0:t+1]; seg_l = l[f0:t+1]
                mfe = ((seg_h.max() - ep) if d == 1 else (ep - seg_l.min())) / risk
                mae = ((ep - seg_l.min()) if d == 1 else (seg_h.max() - ep)) / risk
                ae = atr[f0 - 1] if f0 > 0 else float('nan')
                trades.append((pd.Timestamp(T[f0]), pd.Timestamp(T[t]), name, 'long' if d == 1 else 'short', x['tag'], ep, exitp, risk, R, risk / pip, mae, mfe, ae, PAIRS[name] * pip)); x['status'] = 'done'
    return trades

data = {}
for s in PAIRS:
    df = pd.read_csv(f'{D}/ABTG_H1_{s}.csv', sep=';'); df['t'] = pd.to_datetime(df['date'], format='%Y.%m.%d %H:%M')
    data[s] = df[(df.t >= START) & (df.t < END)].reset_index(drop=True)
rows = []
for s in PAIRS: rows += run_pair(s, data[s], False)
cols = ['ts_open','ts_close','symbol','side','tag','entry','exit','risk_price','R_gross','risk_pips','mae_R','mfe_R','atr_entry','cost_price']
df = pd.DataFrame(rows, columns=cols)
df['cost_R'] = df.cost_price / df.risk_price
df.to_csv(OUT, index=False); print('operazioni', len(df), '->', OUT)
