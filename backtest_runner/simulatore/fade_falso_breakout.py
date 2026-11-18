#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""fade_falso_breakout.py - criteri: report/CLAU12_FADE_FALSO_BREAKOUT_ORO_CRITERI_2026-11-18.md. Uso: python3 -I fade_falso_breakout.py DIR [DIR..]"""
import sys, itertools, math
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import sim_wim as S, confronta_fase2 as C, orari_fissi as O
PT = 0.01; OPEN = 65; START = 480; END = 1200; CLOSE = 1320

def prepara(xau):
    T = xau['t']; G = O.giorni(xau); ks = sorted(G); gi = {}; tr = []
    prev_c = None; H = {}; L = {}
    for k in ks:
        i0, i1 = G[k]
        a = [i for i in range(i0, i1) if T[i] % 86400 >= OPEN * 60]
        if not a: continue
        h = max(xau['h'][i] for i in a); l = min(xau['l'][i] for i in a); c = xau['c'][a[-1]]
        trg = h - l if prev_c is None else max(h - l, abs(h - prev_c), abs(l - prev_c))
        tr.append((k, trg)); prev_c = c; H[k] = h; L[k] = l
    atr = {}; pk = None
    for n, (k, _) in enumerate(tr):
        if n >= 14: atr[k] = sum(x for _, x in tr[n - 14:n]) / 14
    ord_ = [k for k, _ in tr]
    return G, ord_, H, L, atr

def giorno(xau, G, k, kprev, H, L, atr, lvl, X, W, rr):
    i0, i1 = G[k]; T = xau['t']; base = k * 86400; A = atr[k]
    if lvl == 'PD': up, dn = H[kprev], L[kprev]
    else:
        idx = [i for i in range(i0, i1) if OPEN * 60 <= T[i] - base < START * 60]
        if len(idx) < 60: return []
        up = max(xau['h'][i] for i in idx); dn = min(xau['l'][i] for i in idx)
    idx = [i for i in range(i0, i1) if START * 60 <= T[i] - base < CLOSE * 60]
    out = []
    for side in (1, -1):   # 1 = breakout al rialzo (fade short), -1 = al ribasso (fade long)
        lv = up if side == 1 else dn; tb = None; ext = None; done = False
        for n, i in enumerate(idx):
            tm = T[i] - base
            if tm >= END * 60: break
            h, l, c = xau['h'][i], xau['l'][i], xau['c'][i]
            if tb is None:
                if (side == 1 and h >= lv + X * A) or (side == -1 and l <= lv - X * A): tb = tm; ext = h if side == 1 else l
                else: continue
            else: ext = max(ext, h) if side == 1 else min(ext, l)
            if (tm - tb) > W * 60: break
            if (side == 1 and c <= lv) or (side == -1 and c >= lv):
                if n + 1 >= len(idx): break
                j = idx[n + 1]; o = xau['o'][j]; s = xau['s'][j] * PT
                if side == 1: ent = o; sl = ext + 0.10 * A; R = sl - ent
                else: ent = o + s; sl = ext - 0.10 * A; R = ent - sl
                if R < 0.20 * A: break
                tp = ent - side * rr * R
                pnl = None
                for m in range(n + 1, len(idx)):
                    q = idx[m]; hq, lq, sq = xau['h'][q], xau['l'][q], xau['s'][q] * PT
                    if side == 1:   # short: SL su ask (high+s), TP su ask (low+s)
                        if hq + sq >= sl: pnl = ent - sl; break
                        if lq + sq <= tp: pnl = ent - tp; break
                    else:           # long: SL su bid (low), TP su bid (high)
                        if lq <= sl: pnl = sl - ent; break
                        if hq >= tp: pnl = tp - ent; break
                if pnl is None:
                    q = idx[-1] + 1
                    if q >= i1: break
                    pnl = (ent - (xau['o'][q] + xau['s'][q] * PT)) if side == 1 else (xau['o'][q] - ent)
                out.append((k, pnl)); break
    return out

def serie(xau, eur, P, d0, d1, lvl, X, W, rr):
    G, ord_, H, L, atr = P; res = []
    for n, k in enumerate(ord_):
        if k < d0 or k >= d1 or k not in atr or n == 0 or (k + 3) % 7 >= 5: continue
        for (kk, pnl) in giorno(xau, G, k, ord_[n - 1], H, L, atr, lvl, X, W, rr):
            j = max(0, __import__('bisect').bisect_right(eur['t'], k * 86400 + 12 * 3600) - 1)
            res.append((k, pnl * 10 / eur['c'][j] + O.COMM - O.COSTO))
    return res

if __name__ == '__main__':
    d = sys.argv[1:]
    xau = C.carica_cartelle(d, 'XAUUSD'); eur = C.carica_cartelle(d, 'EURUSD'); P = prepara(xau)
    ep = lambda s: S.epoch(s + ' 00:00') // 86400
    sets = list(itertools.product(('PD', 'AS'), (0.10, 0.25), (30, 60, 120), (1, 2)))
    sel = []
    print('--- SELEZIONE 2015-2017 (24 set): n, netto EUR, PF, t ---')
    for st in sets:
        r = serie(xau, eur, P, ep('2015.01.01'), ep('2018.01.01'), *st); n, tot, pf, t, an = O.metr(r) if r else (0, 0, 0, 0, {})
        ok = n >= 60 and tot > 0 and pf >= 1.2 and t >= 2.0
        print('%s X%.2f W%3d rr%d n=%4d netto %+7.0f PF %.2f t %+.2f %s' % (st[0], st[1], st[2], st[3], n, tot, pf, t, 'PASSA' if ok else ''))
        if ok: sel.append((t, st))
    sel.sort(reverse=True); cand = [s for _, s in sel[:3]]
    print('passano la selezione: %d | candidati: %s' % (len(sel), cand if cand else 'NESSUNO'))
    for st in cand:
        r = serie(xau, eur, P, ep('2018.01.01'), ep('2021.01.01'), *st); n, tot, pf, t, an = O.metr(r)
        ok = n >= 60 and tot > 0 and pf >= 1.2 and t >= 2.0 and sum(1 for v in an.values() if v > 0) >= 2
        print('VALIDAZIONE %s n=%d netto %+.0f PF %.2f t %+.2f anni %s -> %s' % (st, n, tot, pf, t, {y: round(v) for y, v in sorted(an.items())}, 'PASSA' if ok else 'NO'))
