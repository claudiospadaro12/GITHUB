#!/usr/bin/env python3
"""Simulazione del Guardian FTMO (chiude tutto e blocca la giornata quando la perdita dall'inizio giornata raggiunge InpDailyLossPct 4,5% dell'iniziale = 3.600 EUR) sul portafoglio oro sommato (somma di corse indipendenti, barre M1). Uso: python3 simula_guardian_portafoglio_oro.py --barre <cartella M1>  [BASELINE=saldo per la baseline FTMO; ANNI=2013,2018 per limitare]. Richiede numpy. Report: report/PORTAFOGLIO_PROP_ORO_GUARDIAN_2026-10-29.md"""
import sys, glob, os, bisect, statistics, datetime
import numpy as np
AQUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, AQUI)
src = open(os.path.join(AQUI, 'leggi_portafoglio_prop_oro.py')).read().split("def serie(")[0]
exec(src.replace('os.path.dirname(os.path.abspath(__file__))', repr(AQUI)))
SOGLIA = 4.5 / 100 * DEP        # Guardian FTMO: InpDailyLossPct 4.5 di 80.000 = 3.600
TOT = 9.3 / 100 * DEP
def giorni_ftmo(ks):
    out = []
    for k in ks:
        dt = E.EPOCA + datetime.timedelta(minutes=k)
        if G.cest(dt): dt += datetime.timedelta(hours=1)
        out.append(dt.date())
    return out
def prepara(anno, nomi, ks, bars):
    cl = np.array([b[3] for b in bars]); hi = np.array([b[1] for b in bars]); lo = np.array([b[2] for b in bars]); n = len(ks)
    P = []; delta = np.zeros(n + 1)
    for e in nomi:
        D = E.affari_p(SRC[anno][e]); pos, _, _ = E.accoppia(D); ser = E.fx_serie(pos); med = statistics.median([f for _, f in ser]) if ser else 0.9
        for x in D:
            i = bisect.bisect_left(ks, x['m']); delta[min(i, n)] += x['net']
        for (mi, mo, s, v, pi, po, prof) in pos:
            i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
            if i0 >= n or i1 <= 0: continue
            i1 = min(i1, n); k_ = v * E.CONTRATTO * E.fx_a(ser, mo, med)
            P.append(dict(i0=i0, i1=i1, s=s, v=v, pin=pi, prof=prof, k=k_, vivo=True))
    return P, delta, cl, hi, lo
def somma(P, delta, cl, hi, lo, n):
    sal = DEP + np.cumsum(delta[:n]); fc = np.zeros(n); fp = np.zeros(n)
    for p in P:
        a, b = p['i0'], p['i1']
        fc[a:b] += p['s'] * (cl[a:b] - p['pin']) * p['k']
        ext = lo[a:b] if p['s'] > 0 else hi[a:b]
        fp[a:b] += p['s'] * (ext - p['pin']) * p['k']
    return sal, fc, fp
def sim(anno, nomi, pess):
    ks, bars = E.carica_m1(glob.glob(BARS[anno])); n = len(ks); gg = giorni_ftmo(ks); da, a = RANGE[anno]
    dmin = G.giorno_ftmo(da + ' 00:00:00'); dmax = G.giorno_ftmo(a + ' 00:00:00')
    P, delta, cl, hi, lo = prepara(anno, nomi, ks, bars)
    sal, fc, fp = somma(P, delta, cl, hi, lo, n)
    giorni = []; i = 0
    while i < n:
        j = i; g = gg[i]
        while j < n and gg[j] == g: j += 1
        giorni.append((g, i, j)); i = j
    kills = []
    for (g, i0d, i1d) in giorni:
        if i0d == 0: continue
        E0 = sal[i0d - 1] if os.environ.get('BASELINE') == 'saldo' else (sal[i0d - 1] + fc[i0d - 1])
        eq = (sal[i0d:i1d] + (fp if pess else fc)[i0d:i1d])
        hit = np.nonzero(eq <= E0 - SOGLIA)[0]
        if len(hit) == 0: continue
        t = i0d + int(hit[0]); kills.append((g, t))
        # flatten al bar t: posizioni vive al bar t chiuse al prezzo del bar (centrale: chiusura; pessimistica: estremo); ingressi dopo t nel giorno cancellati
        for p in P:
            if not p['vivo']: continue
            if p['i0'] <= t < p['i1']:
                px = cl[t] if not pess else (lo[t] if p['s'] > 0 else hi[t])
                nuovo = p['s'] * (px - p['pin']) * p['k'] + (p['prof'] - 0.0) * 0  # swap/costi originali conservati sotto
                # realizzato originale: p['prof'] (profit+swap della chiusura originale); costi/swap = prof - usd_orig*fx, non noto qui: si conserva la parte non da prezzo = 0 (stima)
                orig = p['prof']
                sal[t:] += nuovo
                if p['i1'] < n: sal[p['i1']:] -= orig
                # tolgo flottante residuo dopo t
                a_, b_ = t, p['i1']
                if b_ > a_:
                    fc[a_:b_] -= p['s'] * (cl[a_:b_] - p['pin']) * p['k']
                    ext = lo[a_:b_] if p['s'] > 0 else hi[a_:b_]
                    fp[a_:b_] -= p['s'] * (ext - p['pin']) * p['k']
                p['i1'] = t; p['vivo'] = False
            elif t < p['i0'] < i1d:
                a_, b_ = p['i0'], p['i1']
                fc[a_:b_] -= p['s'] * (cl[a_:b_] - p['pin']) * p['k']
                ext = lo[a_:b_] if p['s'] > 0 else hi[a_:b_]
                fp[a_:b_] -= p['s'] * (ext - p['pin']) * p['k']
                if b_ < n: sal[b_:] -= p['prof']
                p['vivo'] = False
    # statistiche
    i_lo = next(i for i, g in enumerate(gg) if g >= dmin); i_hi = max(i for i, g in enumerate(gg) if g < dmax) + 1
    peggio = []; fail = None
    for (g, i0d, i1d) in giorni:
        if not (dmin <= g < dmax) or i0d == 0: continue
        base = sal[i0d - 1]
        lc = 100 * (base - (sal[i0d:i1d] + fc[i0d:i1d]).min()) / base; lp = 100 * (base - (sal[i0d:i1d] + fp[i0d:i1d]).min()) / base
        peggio.append((lc, lp, g))
    eqc = sal[i_lo:i_hi] + fc[i_lo:i_hi]; eqp = sal[i_lo:i_hi] + fp[i_lo:i_hi]
    return dict(netto=sal[i_hi - 1] - DEP, minc=100 * (DEP - eqc.min()) / DEP, minp=100 * (DEP - eqp.min()) / DEP, wc=max(p[0] for p in peggio), wp=max(p[1] for p in peggio), nk=len(kills), kills=kills)
for anno in [a_ for a_ in ('2013', '2018', '2020', '2025') if a_ in os.environ.get('ANNI', '2013,2018,2020,2025').split(',') and os.path.exists(BARS[a_])]:
    for lab, nomi in COMBI:
        r0 = sim(anno, nomi, False)
        r = sim(anno, nomi, True)  # pessimistica
        print('%s | %-38s | scatti Guardian (pess.): %d %s | netto %+7.0f | equity min -%.2f%% (pess. -%.2f%%) | peggior giorno -%.2f%% (pess. -%.2f%%) | scatti (centr.): %d' % (anno, lab, r['nk'], [str(k[0]) for k in r['kills']][:5], r['netto'], r['minc'], r['minp'], r['wc'], r['wp'], r0['nk']))
