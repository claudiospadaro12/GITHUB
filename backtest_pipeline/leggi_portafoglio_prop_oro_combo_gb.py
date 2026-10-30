#!/usr/bin/env python3
"""Portafoglio ORO sommato (Reaper prop 9, Goldbot One step 6000, Phantom PROPFIRM D9, Gold Trade Pro PROPFIRM R1): equita ricostruita da barre M1 (2013 e 2025) sommando le corse INDIPENDENTI del tester. Criteri: report/PORTAFOGLIO_PROP_ORO_TRE_ANNI_2026-10-28.md. Uso: python3 -I leggi_portafoglio_prop_oro.py [--barre <cartella con ABTG_M1_XAUUSD*.csv>]"""
import os
import sys, glob, os, bisect, statistics, datetime, collections, itertools
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
A = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio') + '/'
S = A + 'ANNO80K_SUPER_20261028_1933/'
DEP = 80000.0
def f1(p):
    g = glob.glob(p); assert g, p; return g[0]
R = A + 'ANNO80K_REAPER_MAXDD_20261029_0416/'
P = S + 'PHANTOM/'
def VAR(anno, mod):
    m = 'M1'
    return {'Reaper9': f1(R + '%s_M1_GR_DD9/report/*.htm*' % anno), 'Reaper6': f1(R + '%s_M1_GR_DD6/report/*.htm*' % anno),
            'Goldbot': (f1(A + 'ANNO80K_GOLDBOT_ZIP_1608/%s_M4/*/report/*.htm*' % anno) if anno == '2025' else f1(A + 'ANNO80K_GOLDBOT_ZIP_1608/%s_M1/*/report/*.htm*' % anno)),
            'PhD9': f1(P + '%s_M1_PHANTOM_PROPFIRM_D9/report/*.htm*' % anno), 'PhD4': f1(P + '%s_M1_PHANTOM_PROPCOMBO_D4/report/*.htm*' % anno),
            'PhD10': f1(P + '%s_M1_PHANTOM_LOWRISK_D10/report/*.htm*' % anno), 'GTP': f1(S + 'GTP/%s_M1_GTP_PROPFIRM_R1/report/*.htm*' % anno)}
SRC = {a_: VAR(a_, 'M1') for a_ in ('2013', '2018', '2020', '2025')}
GBD = sys.argv[sys.argv.index('--gbsv') + 1]
for a_ in SRC:
    for tag in ('PF105', 'PF525', 'LOW3'): SRC[a_]['Gb' + tag] = f1(GBD + '/%s_M1_GB_%s/*/report/*.htm*' % (a_, tag))
# barre M1 dall'export EXPORT_M1_ORO_V2_TUTTO (27/10/2026), NON nel repo: passare la cartella con --barre <cartella> (default: exp/in)
BD = sys.argv[sys.argv.index('--barre') + 1] if '--barre' in sys.argv else 'exp/in'
BARS = {'2013': BD + '/ABTG_M1_XAUUSD_2013.csv', '2018': BD + '/ABTG_M1_XAUUSD_2018.csv', '2020': BD + '/ABTG_M1_XAUUSD_2020.csv', '2025': BD + '/ABTG_M1_XAUUSD.csv'}
RANGE = {'2013': ('2013.01.03', '2013.12.31'), '2018': ('2018.01.03', '2018.12.31'), '2020': ('2020.01.03', '2020.12.31'), '2025': ('2025.01.03', '2025.12.31')}
COMBI = [('Reaper9+Goldbot(test 26/10)', ['Reaper9', 'Goldbot']), ('Reaper9+GbPF105', ['Reaper9', 'GbPF105']), ('Reaper9+GbPF525', ['Reaper9', 'GbPF525']), ('Reaper9+GbLOW3', ['Reaper9', 'GbLOW3']),
 ('Reaper6+GbPF105', ['Reaper6', 'GbPF105']), ('R9+GbPF105+PhD4', ['Reaper9', 'GbPF105', 'PhD4']), ('R9+GbPF525+PhD4', ['Reaper9', 'GbPF525', 'PhD4']), ('R9+GbPF105+PhD9', ['Reaper9', 'GbPF105', 'PhD9']),
 ('R9+GbPF105+GTP', ['Reaper9', 'GbPF105', 'GTP']), ('GbPF105 solo', ['GbPF105'])]
def serie(D, ks, bars):
    pos, nonacc, esatto = E.accoppia(D)
    ser = E.fx_serie(pos); med = statistics.median([f for _, f in ser]) if ser else 0.9
    n = len(ks); fc = [0.0] * n; fp = [0.0] * n; lots = [0.0] * n
    for (mi, mo, s, v, pi, po, prof) in pos:
        i0 = bisect.bisect_left(ks, mi); i1 = bisect.bisect_left(ks, mo)
        if i0 >= n or i1 <= 0: continue
        i1 = min(i1, n); k_ = v * E.CONTRATTO * E.fx_a(ser, mo, med)
        for i in range(i0, i1):
            o, h, lo, c = bars[i]
            fc[i] += s * (c - pi) * k_; fp[i] += (s * ((lo if s > 0 else h) - pi)) * k_; lots[i] += v
    delta = [0.0] * (n + 1)
    for x in D:
        i = bisect.bisect_left(ks, x['m']); delta[min(i, n)] += x['net']
    cum = []; c = 0.0
    for i in range(n): c += delta[i]; cum.append(c)
    return cum, fc, fp, lots, len(pos), nonacc
def giorni_ftmo(ks):
    out = []
    for k in ks:
        dt = E.EPOCA + datetime.timedelta(minutes=k)
        if G.cest(dt): dt += datetime.timedelta(hours=1)
        out.append(dt.date())
    return out
RES = {}
for anno in [a_ for a_ in ('2013', '2018', '2020', '2025') if os.path.exists(BARS[a_])]:
    ks, bars = E.carica_m1(glob.glob(BARS[anno]))
    gg = giorni_ftmo(ks); da, a = RANGE[anno]
    dmin = G.giorno_ftmo(da + ' 00:00:00'); dmax = G.giorno_ftmo(a + ' 00:00:00')
    S_ = {}
    for nome, p in SRC[anno].items():
        D = E.affari_p(p); S_[nome] = (serie(D, ks, bars), D)
        print('  [%s] %s: posizioni accoppiate %d, non accoppiate %d, netto %+.0f' % (anno, nome, S_[nome][0][4], S_[nome][0][5], sum(x['net'] for x in D)))
    # cursore: indici dentro la finestra
    i_lo = next(i for i, g in enumerate(gg) if g >= dmin); i_hi = max(i for i, g in enumerate(gg) if g < dmax) + 1
    price = [b[3] for b in bars]
    for lab, nomi in COMBI:
        n = len(ks)
        sal = [DEP + sum(S_[e][0][0][i] for e in nomi) for i in range(n)]
        fc = [sum(S_[e][0][1][i] for e in nomi) for i in range(n)]
        fp = [sum(S_[e][0][2][i] for e in nomi) for i in range(n)]
        lots = [sum(S_[e][0][3][i] for e in nomi) for i in range(n)]
        # giorni FTMO
        peggio = []; i = 0; c3 = c4 = c5 = 0; mp5 = 0
        while i < n:
            j = i; g = gg[i]
            while j < n and gg[j] == g: j += 1
            if dmin <= g < dmax and i > 0:
                base = sal[i - 1]; mc = min(sal[t] + fc[t] for t in range(i, j)); mpp = min(sal[t] + fp[t] for t in range(i, j))
                lc = 100.0 * (base - mc) / base; lp = 100.0 * (base - mpp) / base
                peggio.append((lc, lp, g))
                if lc >= 3: c3 += 1
                if lc >= 4: c4 += 1
                if lc >= 5: c5 += 1
                if lp >= 5: mp5 += 1
            i = j
        eqc = [sal[t] + fc[t] for t in range(i_lo, i_hi)]; eqp = [sal[t] + fp[t] for t in range(i_lo, i_hi)]
        minc = min(eqc); minp = min(eqp)
        pk = DEP; ddpk_c = 0.0; ddpk_p = 0.0
        for t in range(i_lo, i_hi):
            pk = max(pk, sal[t])  # picco del saldo (il picco di equity usa saldo realizzato)
            ddpk_c = max(ddpk_c, (pk - (sal[t] + fc[t]))); ddpk_p = max(ddpk_p, (pk - (sal[t] + fp[t])))
        netto = sal[i_hi - 1] - DEP
        mxl = max(lots[i_lo:i_hi]); tm = lots.index(mxl, i_lo)
        marg9 = mxl * 100 * price[tm] / 9.0
        w = max(peggio, key=lambda x: x[0]); wp = max(peggio, key=lambda x: x[1])
        RES[(lab, anno)] = (netto, 100*(DEP-minc)/DEP, 100*(DEP-minp)/DEP, w[0], wp[1], c3, c4, c5, mxl)
        print('%s | %-38s netto %+7.0f (%+.1f%%) | equity min %.0f (perdita dal deposito %.2f%%; pess. %.2f%%) | DD dal picco: %.0f (pess. %.0f) | peggior giorno -%.2f%% (pess. -%.2f%%) | gg>=3/4/5%%: %d/%d/%d | lotti max insieme %.2f (margine 1:9 ~%.0f USD)' % (anno, lab, netto, 100 * netto / DEP, minc, 100 * (DEP - minc) / DEP, 100 * (DEP - minp) / DEP, ddpk_c, ddpk_p, w[0], wp[1], c3, c4, c5, mxl, marg9))

print()
for lab, _ in COMBI:
    ok = all(((lab, a_) in RES) and RES[(lab, a_)][0] > 0 and max(RES[(lab, a_)][1:3]) <= 8.0 and max(RES[(lab, a_)][3:5]) < 5.0 for a_ in ('2013', '2018', '2020', '2025'))
    ann = [a_ for a_ in ('2013', '2018', '2020', '2025') if (lab, a_) in RES]
    tot = sum(RES[(lab, a_)][0] for a_ in ann) / max(1, len(ann))
    print('PORT-OK %-4s %-28s netto medio %+.0f' % ('SI' if ok and len(ann) == 4 else 'NO', lab, tot), ' | '.join('%s: loss %.1f/%.1f%% day %.2f/%.2f%%' % (a_, RES[(lab, a_)][1], RES[(lab, a_)][2], RES[(lab, a_)][3], RES[(lab, a_)][4]) for a_ in ann))
