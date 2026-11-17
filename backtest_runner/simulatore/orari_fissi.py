#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""orari_fissi.py - proposta A (criteri report/CLAU12_ORARI_FISSI_ORO_CRITERI_2026-11-18.md). 4 fasce giornaliere sull'oro, una posizione per fascia."""
import bisect, math, sys
sys.path.insert(0, __file__.rsplit('/', 1)[0])
import sim_wim as S, confronta_fase2 as C
FASCE = {'F1': (65, 600), 'F2': (600, 930), 'F3': (930, 1140), 'F4': (1140, 1410)}   # minuti dal mezzanotte server
COSTO = 3.6; COMM = -0.16; PT = 0.01

def giorni(xau):
    T = xau['t']; out = {}
    i = 0; n = len(T)
    while i < n:
        k = T[i] // 86400; j = i
        while j < n and T[j] // 86400 == k: j += 1
        out[k] = (i, j); i = j
    return out

def trade_fascia(xau, i0, i1, k, a, b):
    T = xau['t']; t0 = k * 86400 + a * 60; t1 = k * 86400 + b * 60
    lo = bisect.bisect_left(T, t0, i0, i1); hi = bisect.bisect_left(T, t1, i0, i1) - 1
    if lo >= i1 or hi < lo or T[lo] - t0 > 300 or t1 - T[hi] - 60 > 300: return None
    return lo, hi

def serie(xau, eur, fascia, a, b, d0, d1):
    G = giorni(xau); res = []
    for k in sorted(G):
        if k < d0 or k >= d1: continue
        wd = (k + 3) % 7
        if wd >= 5: continue
        i0, i1 = G[k]; r = trade_fascia(xau, i0, i1, k, a, b)
        if r is None: continue
        lo, hi = r
        o = xau['o'][lo]; c = xau['c'][hi]; so = xau['s'][lo] * PT; sc = xau['s'][hi] * PT
        j = bisect.bisect_right(eur['t'], xau['t'][hi]) - 1; fx = eur['c'][max(j, 0)]
        res.append((k, c - o, (c - (o + so)), ((o) - (c + sc)), fx))
    return res                     # (giorno, lordo_mid, netto_long_usd, netto_short_usd, eurusd)

def stat(v):
    n = len(v); mu = sum(v) / n; sd = math.sqrt(sum((x - mu) ** 2 for x in v) / (n - 1))
    return mu, (mu / (sd / math.sqrt(n)) if sd > 0 else float('nan')), n

def netti_eur(res, direzione):
    out = []
    for (k, g, nl, ns, fx) in res:
        usd = nl if direzione > 0 else ns
        out.append((k, usd * 10 / fx + COMM - COSTO))
    return out

def metr(netti):
    v = [x for _, x in netti]; n = len(v); tot = sum(v)
    gp = sum(x for x in v if x > 0); gl = -sum(x for x in v if x < 0)
    pf = gp / gl if gl > 0 else float('inf'); mu, t, _ = stat(v)
    anni = {}
    for k, x in netti:
        y = int(S.fmt(k * 86400)[:4]); anni[y] = anni.get(y, 0) + x
    return n, tot, pf, t, anni

if __name__ == '__main__':
    d = sys.argv[1:]
    xau = C.carica_cartelle(d, 'XAUUSD'); eur = C.carica_cartelle(d, 'EURUSD')
    ep = lambda s: S.epoch(s + ' 00:00') // 86400
    print('--- 1) SCELTA 2015-2017: deriva lorda (USD/oncia, prezzo di mezzo), t ---')
    cand = {}
    for f, (a, b) in FASCE.items():
        r = serie(xau, eur, f, a, b, ep('2015.01.01'), ep('2018.01.01'))
        mu, t, n = stat([x[1] for x in r]); print('%s n=%d deriva lorda %+.3f USD/oncia t %+.2f' % (f, n, mu, t))
        if abs(t) >= 2.3: cand[f] = 1 if mu > 0 else -1
    print('candidate (|t|>=2,3):', cand if cand else 'NESSUNA')
    print('--- 4) descrittivo 2015-2020 per fascia (long/short netti in EUR, 0,1 lotti, dopo i costi): n, totale, PF, t ---')
    for f, (a, b) in FASCE.items():
        r = serie(xau, eur, f, a, b, ep('2015.01.01'), ep('2021.01.01'))
        for dr, nome in ((1, 'long'), (-1, 'short')):
            n, tot, pf, t, anni = metr(netti_eur(r, dr))
            print('%s %-5s n=%d netto %+8.0f PF %.2f t %+.2f | per anno %s' % (f, nome, n, tot, pf, t, {y: round(v) for y, v in sorted(anni.items())}))
    if cand:
        print('--- 2) VALIDAZIONE 2018-2020 (solo candidate, direzione fissata) ---')
        for f, dr in cand.items():
            a, b = FASCE[f]; r = serie(xau, eur, f, a, b, ep('2018.01.01'), ep('2021.01.01'))
            n, tot, pf, t, anni = metr(netti_eur(r, dr))
            ok = tot > 0 and pf >= 1.2 and t >= 2.0 and n >= 150 and sum(1 for v in anni.values() if v > 0) >= 2
            print('%s %s n=%d netto %+.0f PF %.2f t %+.2f anni %s -> %s' % (f, 'long' if dr > 0 else 'short', n, tot, pf, t, {y: round(v) for y, v in sorted(anni.items())}, 'PASSA' if ok else 'NO'))
