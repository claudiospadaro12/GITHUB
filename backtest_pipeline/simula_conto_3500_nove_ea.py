#!/usr/bin/env python3
"""Nove EA (DEEP5K_PERSONALE, 5.000 EUR, 21 mesi, tick reali) riportati su un conto da 3.500 EUR: caso A (P&L e lotti x0,7) e caso B (lotti di 5.000), costi C0/C2, tempo per +100%, margine. Criteri: report/CONTO_REALE_3500_NOVE_EA_CRITERI_2026-10-29.md. Uso: python3 simula_conto_3500_nove_ea.py --barre <cartella con ABTG_M1_XAUUSD.csv>"""
import os, sys, glob, bisect, datetime, statistics
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
A = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'DEEP5K_PERSONALE_20261026') + '/'
BD = sys.argv[sys.argv.index('--barre') + 1] if '--barre' in sys.argv else 'exp/in'
ks, bars = E.carica_m1(glob.glob(BD + '/ABTG_M1_XAUUSD.csv')); n = len(ks)
giorno = []
for k in ks:
    dt = E.EPOCA + datetime.timedelta(minutes=k)
    if G.cest(dt): dt += datetime.timedelta(hours=1)
    giorno.append(dt.date())
DEP = 3500.0; MARG = 8580.0; C2 = 26.0   # EUR di margine per lotto (tester, derivato); extra C2 in EUR per lotto e giro
NOMI = [('Gold Snap', 'DEEP5K_GOLDSNAP'), ('SomaGold', 'DEEP5K_SOMAGOLD'), ('SixtyNine', 'DEEP5K_SIXTYNINEEA'), ('Umbra Vault', 'DEEP5K_UMBRAVAULTAIEA'),
        ('Microedge', 'DEEP5K_MICROEDGENEURALMATRIXEA'), ('Vortex Turbo', 'DEEP5K_VORTEXTURBOEA'), ('Rocket Breakout', 'DEEP5K_ROCKETBREAKOUTEA'),
        ('Entry Points Pro', 'DEEP5K_ENTRYPOINTSPROROBOT'), ('ORB Revolution', 'DEEP5K_ORBREVOLUTION')]
def serie(path):
    D = E.affari_p(path); pos, nonacc, esatto = E.accoppia(D)
    sr = E.fx_serie(pos); med = statistics.median([f for _, f in sr]) if sr else 0.9
    fc = [0.0] * n; fp = [0.0] * n; lot = [0.0] * n; cd = [0.0] * (n + 1)
    for (mi, mo, s, v, pi, po, prof) in pos:
        i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
        cd[min(i1, n)] += v * C2
        if i0 >= n or i1 <= 0: continue
        i1 = min(i1, n); k_ = v * E.CONTRATTO * E.fx_a(sr, mo, med)
        for i in range(i0, i1):
            o, h, lo, c = bars[i]; fc[i] += s * (c - pi) * k_; fp[i] += s * ((lo if s > 0 else h) - pi) * k_; lot[i] += v
    delta = [0.0] * (n + 1)
    for x in D:
        i = bisect.bisect_left(ks, x['m']); delta[min(i, n)] += x['net']
    sal = []; cst = []; c = 0.0; cc = 0.0
    for i in range(n): c += delta[i]; cc += cd[i]; sal.append(c); cst.append(cc)
    return sal, cst, fc, fp, lot, len(pos)
i0 = next(i for i in range(n) if giorno[i] >= datetime.date(2025, 1, 3)); i1 = n; d0 = giorno[i0]
def sim(S, scala, costo):
    sal, cst, fc, fp, lot, npos = S
    bal = [DEP + scala * (sal[i] - (cst[i] if costo else 0.0)) for i in range(n)]
    eqc = [bal[i] + scala * fc[i] for i in range(n)]; eqp = [bal[i] + scala * fp[i] for i in range(n)]
    pk = eqp[i0]; mdd = 0.0; mde = 0.0; mlev = 1e9; t100 = t50 = 0; mineq = min(eqp[i0:i1]); jm = eqp.index(mineq, i0)
    for i in range(i0, i1):
        pk = max(pk, eqp[i]); mdd = max(mdd, (pk - eqp[i]) / pk * 100); mde = max(mde, pk - eqp[i])
        if lot[i] > 0:
            lv = eqp[i] / (lot[i] * scala * MARG) * 100; mlev = min(mlev, lv); t100 += lv < 100; t50 += lv < 50
    worst = 0.0; wd = None; g5 = 0; i = i0
    while i < i1:
        j = i; g = giorno[i]
        while j < i1 and giorno[j] == g: j += 1
        base = bal[i - 1]; mn = min(eqp[t] for t in range(i, j)); loss = (base - mn) / base * 100
        if loss > worst: worst, wd = loss, g
        g5 += loss >= 5; i = j
    dbl = next((i for i in range(i0, i1) if eqc[i] >= 2 * DEP), None)
    dbb = next((i for i in range(i0, i1) if bal[i] >= 2 * DEP), None)
    dd = lambda x: None if x is None else (giorno[x] - d0).days
    j180 = next(i for i in range(i0, i1) if (giorno[i] - d0).days >= 180); pk2 = eqp[i0]; dd180 = 0.0; dde180 = 0.0; w180 = 0.0
    for i in range(i0, j180):
        pk2 = max(pk2, eqp[i]); dd180 = max(dd180, (pk2 - eqp[i]) / pk2 * 100); dde180 = max(dde180, pk2 - eqp[i])
    pre = min(eqp[i0:dbl]) if dbl else None
    return dict(net=bal[i1 - 1] - DEP, mdd=mdd, mde=mde, mineq=mineq, minq_d=giorno[jm], worst=worst, wd=wd, g5=g5, mlev=mlev, t100=t100, t50=t50,
                dd180=dd180, dde180=dde180, dbl=dd(dbl), dbb=dd(dbb), pre=pre, maxlot=max(lot[i0:i1]) * scala)
S = {}
for nome, d in NOMI:
    S[nome] = serie(glob.glob(A + d + '/report/*.htm.gz')[0]); print('#', nome, 'posizioni', S[nome][5], file=sys.stderr)
def f(x, fmt): return '-' if x is None else fmt % x
for lab, scala, costo in (('A x0,7 C0', 0.7, False), ('A x0,7 C2', 0.7, True), ('B lotti 5K C0', 1.0, False)):
    print('=== %s (partenza 3.500, 01/2025-10/2026) ===' % lab)
    for nome, _ in NOMI:
        r = sim(S[nome], scala, costo)
        print('%-16s netto %+8.0f (%+6.0f%%) | equity min %6.0f (%s) | DD equity %5.1f%% (%5.0f EUR) | peggior giorno -%.1f%% (%s) gg>=5%%: %d | +100%% equity dopo %s gg (saldo %s gg), minima prima %s | margine min %s%% min<100%%: %d <50%%: %d | DD equity primi 180 gg %.1f%% (%.0f EUR) | lotti max %.2f' % (
            nome, r['net'], 100 * r['net'] / DEP, r['mineq'], r['minq_d'], r['mdd'], r['mde'], r['worst'], r['wd'], r['g5'], f(r['dbl'], '%d'), f(r['dbb'], '%d'), f(r['pre'], '%.0f'), f(r['mlev'] if r['mlev'] < 1e8 else None, '%.0f'), r['t100'], r['t50'], r['dd180'], r['dde180'], r['maxlot']))
