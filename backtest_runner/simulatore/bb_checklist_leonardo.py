#!/usr/bin/env python3
"""[CHECKLIST DI LEONARDO su v4.2] criteri: report/BB_CHECKLIST_LEONARDO_CRITERI_2026-11-25.md
Replica Python di BreakingBand_ALLCROSSES_v42.mq5 (Leonardo) su forex H1. Criteri: report/BB_V42_PORT_CRITERI_2026-11-24.md.
Uso: /usr/bin/python3 -I bb_v42_port.py <cartella_H1> [<out_txt>]"""
import sys, math
import numpy as np, pandas as pd
D = sys.argv[1]; OUT = sys.argv[2] if len(sys.argv) > 2 else None; VAR = sys.argv[3] if len(sys.argv) > 3 else 'P'   # P = primario (criteri scritti), A/B = esplorative dichiarate DOPO i numeri
PAIRS = {'EURUSD':0.8,'USDJPY':1.0,'GBPUSD':1.2,'AUDUSD':1.2,'EURGBP':1.5,'USDCAD':1.5,'USDCHF':1.5,'NZDUSD':1.8,'EURJPY':1.8,'GBPJPY':2.8}
START, END, SPLIT, S2526 = '2005-01-01', '2026-11-20', pd.Timestamp('2016-01-01'), pd.Timestamp('2025-01-01')
out = []
DIAG = []
DIAG2 = []
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
    sd = cs.rolling(20).std(ddof=0).values; width = 4*sd; sdsma = pd.Series(sd).rolling(50).mean().values
    sma50 = cs.rolling(50).mean().values; rng = h - l; body = np.abs(c - o)
    def score(bi, s, kind, bdir, tdir):
        # ritorna dict con valid, motivo, score, bonus
        if bi < 90 or s < bi + 1 or np.isnan(sdsma[s]) or np.isnan(sma50[s]): return None
        i0 = bi - 20 + int(np.argmin(width[bi-20:bi+1]))
        if i0 < 70: return None
        Wi = np.arange(i0-14, i0+1)
        # congestione
        c1 = width[i0] <= 0.9*width[i0-15]
        mprev = rng[i0-65:i0-15].mean()
        c2 = rng[Wi].mean() <= 0.8*mprev and rng[Wi].max() <= 2*rng[Wi].mean()
        c3 = abs(c[i0]-c[i0-15]) <= atr[i0]
        c4 = bool((rng[Wi] <= 1.5*atr[i0]).all())
        c5 = (sd[i0] < sdsma[i0]) and (abs(sd[i0]-sd[i0-5])/sd[i0-5] <= 0.15)
        cs_ok = (int(c1)+int(c2)+int(c3)+int(c4)+int(c5)) >= 4
        if not cs_ok:
            x = np.arange(15); y = c[Wi]; cc = np.corrcoef(x, y)[0, 1]; r2 = cc*cc if not np.isnan(cc) else 0
            ratio = width[i0]/width[i0-15]
            cda = (sd[i0] < sd[i0-10]) and (sd[i0] < sdsma[i0]) and (0.70 <= ratio <= 0.85) and c4 and r2 >= 0.5
        else: cda = False
        cong = 25.0 if (cs_ok or cda) else 0.0
        # bulge
        imp = np.arange(i0+1, bi+1)
        b1 = width[bi] >= 1.5*width[i0]; b2 = sd[bi] > sdsma[bi]
        b3 = int(((rng[imp] >= 1.5*atr[i0]) & (rng[imp] <= 3*atr[i0])).sum()) >= 2
        b4 = ((c[bi]-c[i0])*bdir >= 2.5*atr[i0]) and (float(((c[imp]-o[imp])*bdir > 0).mean()) >= 0.6)
        b5 = abs(c[bi]-ma[bi]) >= 1.5*atr[bi]; b6 = (bi - i0) <= 20
        DIAG.append((b1, b2, b3, b4, b5, b6))
        if not (b1 and b2 and b3 and b4 and b5 and b6): return dict(valid=False, why='bulge', sc=0.0, bonus=0, cong=cong)
        # ritracciamento
        Rr = np.arange(max(bi+1, s-9) if VAR == 'B' else bi+1, s+1)
        ri = rng[imp].mean()
        r1 = rng[Rr].mean() <= 0.7*ri
        r2_ = bool((rng[Rr] <= 1.5*atr[bi]).all())
        sh = (rng[Rr]-body[Rr]) if VAR == 'P' else np.maximum(h[Rr]-np.maximum(o[Rr], c[Rr]), np.minimum(o[Rr], c[Rr])-l[Rr]); big = np.maximum(body[Rr], 0.1*rng[Rr])
        r3 = float((sh <= 1.5*big + 1e-12).mean()) >= 0.8
        agn = ((c[Rr]-o[Rr])*tdir < 0)
        r4 = not bool(((rng[Rr] > atr[bi]) & (body[Rr] >= 0.7*rng[Rr]) & agn).any())
        if kind == 1: r5 = (c[bi]-c[s])*bdir > 0
        else: r5 = bool((l[Rr] <= ma[Rr]).any() if bdir == 1 else (h[Rr] >= ma[Rr]).any()) and not bool(((l[Rr] <= bl[Rr]) if bdir == 1 else (h[Rr] >= bu[Rr])).any())
        r6 = width[s] < width[bi]
        fr = (int(r1)+int(r2_)+int(r3)+int(r4)+int(r5)+int(r6))/6.0
        DIAG2.append((r1, r2_, r3, r4, r5, r6, len(Rr), kind))
        if fr < 0.8: return dict(valid=False, why='ritracciamento', sc=0.0, bonus=0, cong=cong)
        retr = 20.0*fr
        gonf = width[s] <= 1.05*width[s-3]
        upslope = bu[s]-bu[s-3]; lowslope = bl[s]-bl[s-3]
        flat_fav = (upslope <= 0) if bdir == 1 else (lowslope >= 0)
        if kind == 1: bands = 15.0*np.mean([float(r6), float(gonf), 1.0])
        else: bands = 15.0*np.mean([float(r6), float(flat_fav), float(gonf)])
        touchopp = bool(((l[Rr] <= bl[Rr]) if bdir == 1 else (h[Rr] >= bu[Rr])).any())
        if kind == 1: test = 10.0*np.mean([1.0, float(rng[s] <= 1.5*atr[s])])
        else: test = 10.0*np.mean([1.0, float(not touchopp), float(flat_fav)])
        conf = 5.0*np.mean([float(sd[s] < sd[s-3]), float(sd[s] < sdsma[s]), float((sma50[s]-sma50[s-5])*tdir > 0), 1.0])
        # invalidazioni
        spike = bool(((sh > 2*np.maximum(body[Rr], 1e-12)) & (rng[Rr] > atr[bi])).any())
        if kind == 1: inv = bool((rng[Rr] > 1.5*atr[bi]).any()) or spike or (sd[s] >= sdsma[s])
        else:
            tilt = (upslope > 0) if bdir == 1 else (lowslope < 0)
            inv = bool((rng[Rr] > 1.0*atr[bi]).any()) or tilt or (width[s] > 1.05*width[s-3]) or touchopp or (sd[s] >= sdsma[s])
        # bonus
        pin = (max(h[s]-max(o[s], c[s]), min(o[s], c[s])-l[s]) >= 2*max(body[s], 1e-12)) or (body[s] <= 0.3*rng[s])
        grad = len(Rr) >= 5
        inside = (c[s] > bl[s]) if (kind == 1 and bdir == 1) else (c[s] < bu[s]) if (kind == 1) else ((c[s] < bu[s]) if bdir == 1 else (c[s] > bl[s]))
        bonus = int(pin) + int(grad) + int(inside)
        if inv: return dict(valid=False, why='invalidazione', sc=cong+25.0+retr+bands+test+conf, bonus=bonus, cong=cong)
        return dict(valid=True, why='', sc=cong+25.0+retr+bands+test+conf, bonus=bonus, cong=cong)
    SCAN, CONT, INVM, INVR, ACT = 0, 1, 2, 3, 4
    st = SCAN; cnt = 0; bdir = 0; bcnt = 0; oppR = False
    imp = opp = med0 = atrs = 0.0; bi_ = -1
    tr_ = None; trades = []
    def reset():
        nonlocal st, cnt, imp, opp, med0, atrs
        st = SCAN; cnt = 0; imp = opp = med0 = atrs = 0.0
    def hard():
        nonlocal bcnt, bdir, oppR
        bcnt = 0; bdir = 0; oppR = False
    def place(t, d, ent, tag):
        nonlocal tr_, bi_
        bid = o[t]
        if d == 1:
            if ent >= bid: ent = bid - 2 * pt
            sl = ent - SLM * atrs
        else:
            if ent <= bid: ent = bid + 2 * pt
            sl = ent + SLM * atrs
        tr_ = dict(d=d, ent=ent, sl=sl, sl0=sl, tp=tpv, atr=atrs, status='pend', tag=tag, fill=None, t=t, ft=score(bi_, t-1, 1 if tag == 'CONT' else 2, bdir, d))
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
                        bi_ = t - 1; imp = bu[t - 1] if nd == 1 else bl[t - 1]; opp = bl[t - 1] if nd == 1 else bu[t - 1]
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
                trades.append((pd.Timestamp(x['fillday']), name, x['tag'], R, risk / pip, x['ft'])); x['status'] = 'done'
    return trades
data = {}
for s in PAIRS:
    df = pd.read_csv(f'{D}/ABTG_H1_{s}.csv', sep=';'); df['t'] = pd.to_datetime(df['date'], format='%Y.%m.%d %H:%M')
    data[s] = df[(df.t >= START) & (df.t < END)].reset_index(drop=True)
def stats(df, k=1.0):
    if len(df) == 0: return dict(n=0, pf=0, t=0, mean=0, tot=0)
    net = df.R - k * df.pair.map(PAIRS) / df.rp
    gp = net[net > 0].sum(); gl = -net[net <= 0].sum()
    ds = net.groupby(df.day.dt.normalize()).sum()
    t = ds.mean() / (ds.std(ddof=1) / math.sqrt(len(ds))) if len(ds) > 2 and ds.std() > 0 else 0
    return dict(n=len(df), pf=gp / gl if gl > 0 else 99, t=t, mean=net.mean(), tot=net.sum())
allres = {}
for mode, opt in (('PRUDENTE', False), ('OTTIMISTICA', True)):
    rows = []
    for s in PAIRS: rows += run_pair(s, data[s], opt)
    df = pd.DataFrame([r[:5] for r in rows], columns=['day', 'pair', 'tag', 'R', 'rp']); df['valid'] = [None if r[5] is None else r[5]['valid'] for r in rows]; df['why'] = [('nd' if r[5] is None else r[5]['why']) for r in rows]; df['sc'] = [np.nan if r[5] is None else r[5]['sc'] for r in rows]; df['bonus'] = [np.nan if r[5] is None else r[5]['bonus'] for r in rows]; allres[mode] = df
    if mode == 'PRUDENTE':
        df['net'] = df.R - df.pair.map(PAIRS) / df.rp
        P('\n=== CHECKLIST DI LEONARDO su %d setup v4.2 (misura prudente), VARIANTE %s ===' % (len(df), {'P': 'PRIMARIA (criteri scritti)', 'A': 'ESPLORATIVA A: ombra del singolo lato', 'B': 'ESPLORATIVA B: A + ritracciamento sulle ultime 10 barre'}[VAR]))
        P('score non calcolabile (storia insufficiente):', int(df.sc.isna().sum() if False else (df.why == 'nd').sum()))
        d = df[df.why != 'nd'].copy(); P('setup valutati:', len(d), '| validi:', int((d.valid == True).sum()), '(%.0f%%)' % (100 * (d.valid == True).mean()), '| invalidi per motivo:', d[d.valid == False].why.value_counts().to_dict())
        def blk(x, nm):
            if len(x) == 0: return '%-34s n=0' % nm
            gp = x.net[x.net > 0].sum(); gl = -x.net[x.net <= 0].sum(); ds = x.net.groupby(x.day.dt.normalize()).sum()
            t = ds.mean() / (ds.std(ddof=1) / math.sqrt(len(ds))) if len(ds) > 2 and ds.std() > 0 else 0
            return '%-34s n=%5d win %.0f%% R medio %+.3f PF %.2f t %+.1f' % (nm, len(x), 100 * (x.net > 0).mean(), x.net.mean(), gp / gl if gl > 0 else 99, t)
        def grade(v): return 'Ottimo >=85' if v >= 85 else 'Buono 70-84' if v >= 70 else 'Medio 55-69' if v >= 55 else 'Debole <55'
        d['grado'] = [grade(v) if ok else 'INVALIDO' for v, ok in zip(d.sc, d.valid == True)]
        for per, f in (('IS 2005-2015', d.day < SPLIT), ('OOS 2016-2026', d.day >= SPLIT)):
            P('\n--- %s ---' % per); x = d[f]
            for g in ('Ottimo >=85', 'Buono 70-84', 'Medio 55-69', 'Debole <55', 'INVALIDO'): P(blk(x[x.grado == g], g))
            for k in ('CONT', 'INV'): P(blk(x[(x.tag == k) & (x.valid == True)], 'validi ' + k))
            P(blk(x[(x.valid == True) & (x.sc >= 70)], 'validi con solidita >= 70'))
            P(blk(x[x.valid == True], 'validi (tutti)')); P(blk(x[x.valid == False], 'invalidi (tutti)'))
            v = x[x.valid == True]
            if len(v) > 10:
                xs = v.sc.values; ys = v.net.values; sl_ = np.polyfit(xs, ys, 1)[0]; res = ys - np.polyval(np.polyfit(xs, ys, 1), xs)
                se = math.sqrt((res ** 2).sum() / max(len(v) - 2, 1) / ((xs - xs.mean()) ** 2).sum()); P('G1 pendenza R su solidita: %+.5f per punto, t %+.2f (n=%d)' % (sl_, sl_ / se if se > 0 else 0, len(v)))
            bo = v.groupby('bonus').net.agg(['count', 'mean']).round(3); P('R medio per numero di bonus:', bo.to_dict('index'))
D = np.array(DIAG, dtype=float); P('\nDIAGNOSTICA criteri del bulge (quota SI su %d setup; NON cambia le soglie): B1 apertura %.0f%% | B2 sd>SMA50 %.0f%% | B3 candele impulsive %.0f%% | B4 movimento netto %.0f%% | B5 mediana lontana %.0f%% | B6 durata %.0f%% | tutti %.1f%%' % ((len(D),) + tuple(100*D.mean(axis=0)) + (100*D.all(axis=1).mean(),)))
D2 = np.array(DIAG2, dtype=float)
for kk, nm in ((1, 'CONT'), (2, 'INV')):
    q = D2[D2[:, 7] == kk]
    if len(q): P('DIAGNOSTICA ritracciamento %s (%d setup con bulge valido): r1 range ridotto %.0f%% | r2 nessuna >1.5ATR %.0f%% | r3 ombre %.0f%% | r4 no engulfing %.0f%% | r5 direzione %.0f%% | r6 bande restringono %.0f%% | barre medie %.1f' % ((nm, len(q)) + tuple(100*q[:, :6].mean(axis=0)) + (q[:, 6].mean(),)))
if OUT: open(OUT, 'w').write('\n'.join(out) + '\n')
