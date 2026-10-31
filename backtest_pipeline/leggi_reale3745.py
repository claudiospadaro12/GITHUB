#!/usr/bin/env python3
"""Conto reale 3.745: legge le 5 corse (zip ANNO3745L500_REALE) e calcola per EA e per combinazione: netto, DD saldo, giorno peggiore realizzato, lotti, giorni a +100%.
Uso: python3 -I leggi_reale3745.py <cartella con 21M_M4_*>"""
import sys, os, glob, collections, itertools, datetime
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
DEP = 3745.0
base = sys.argv[1]
RUN = {'GTP_PROP': '21M_M4_GTP_PROP', 'GTP_COMBO': '21M_M4_GTP_COMBO', 'Goldbot': '21M_M4_GOLDBOT_PF525', 'Reaper': '21M_M4_REAPER_D9', 'Phantom': '21M_M4_PHANTOM_D4'}
def rep(d):
    g = glob.glob(os.path.join(base, d, '*', 'report', '*.htm')); assert g, d; return g[0]
S = {}
for k, d in RUN.items():
    D = E.affari_p(rep(d)); S[k] = D
def giorno(t): return t[:10]
def per_run(D):
    net = collections.OrderedDict(); lots = 0.0; maxl = 0.0; sizes = collections.Counter()
    ev = []
    for x in D:
        net[giorno(x['t'])] = net.get(giorno(x['t']), 0.0) + x['net']
        if x['dir'] == 'in': lots += x['vol']; sizes[round(x['vol'], 2)] += 1
        elif x['dir'] == 'out': lots -= x['vol']
        maxl = max(maxl, lots)
    return net, maxl, sizes
def stats(net):
    bal = DEP; pk = DEP; mdd = 0; path = []
    for g, v in net.items():
        bal += v; pk = max(pk, bal); mdd = max(mdd, pk - bal); path.append((g, bal))
    worst = min(net.values()); wd = min(net, key=net.get)
    dbl = next((g for g, b in path if b >= 2 * DEP), None)
    return bal, mdd, worst, wd, dbl, path
print('%-10s %6s %9s %8s %8s %8s %-11s %7s %s' % ('EA', 'op', 'netto', 'netto%', 'DDsal%', 'peggiore', 'giorno', 'maxlot', 'lotti(0.01/0.02/>)'))
NET = {}
for k, D in S.items():
    net, maxl, sizes = per_run(D); NET[k] = net
    bal, mdd, worst, wd, dbl, path = stats(net)
    n_in = sum(sizes.values())
    print('%-10s %6d %+9.0f %+7.1f%% %7.1f%% %+8.0f %-11s %7.2f %s  doppio:%s' % (k, n_in, bal - DEP, (bal - DEP) / DEP * 100, mdd / DEP * 100, worst, wd, maxl, dict(sizes), dbl))
    pos = sum(1 for v in net.values() if v > 0); neg = sum(1 for v in net.values() if v < 0)
    print('           giorni +%d / -%d; peggior giorno %.1f%% del deposito; peggiori 3 giorni %s' % (pos, neg, worst / DEP * 100, [(g, round(v)) for g, v in sorted(net.items(), key=lambda kv: kv[1])[:3]]))
def comb(nomi):
    tot = collections.OrderedDict()
    for n in nomi:
        for g, v in NET[n].items(): tot[g] = tot.get(g, 0.0) + v
    return collections.OrderedDict(sorted(tot.items()))
print()
for nomi in [('Reaper', 'Goldbot'), ('Reaper', 'Phantom'), ('Reaper', 'GTP_PROP'), ('Reaper', 'Goldbot', 'Phantom'), ('Reaper', 'Goldbot', 'GTP_PROP'), ('Reaper', 'Phantom', 'GTP_PROP'), ('Reaper', 'Goldbot', 'Phantom', 'GTP_PROP')]:
    net = comb(nomi)
    # NB: somma delle corse INDIPENDENTI a 3.745 ciascuna: equivale a un conto con il deposito moltiplicato; rapporti in % del DEPOSITO REALE
    bal, mdd, worst, wd, dbl, path = stats(net)
    print('%-34s netto %+7.0f (%+6.1f%% di 3.745)  DDsaldo %6.0f (%5.1f%%)  peggior giorno %+6.0f (%5.1f%%) %s  doppio:%s' % ('+'.join(nomi), bal - DEP, (bal - DEP) / DEP * 100, mdd, mdd / DEP * 100, worst, worst / DEP * 100, wd, dbl))

# lotti aperti insieme (somma delle corse, ordinate per tempo) e mese peggiore
print()
def lots_ev(nomi):
    ev = []
    for n in nomi:
        for x in S[n]:
            if x['dir'] == 'in': ev.append((x['t'], 1, x['vol']))
            elif x['dir'] == 'out': ev.append((x['t'], 0, -x['vol']))
    ev.sort(key=lambda e: (e[0], e[1]))  # a pari tempo prima le uscite
    cur = mx = 0.0; tmx = None
    for t, _, v in ev:
        cur += v
        if cur > mx: mx = cur; tmx = t
    return mx, tmx
def mesi(net):
    m = collections.OrderedDict()
    for g, v in net.items(): m[g[:7]] = m.get(g[:7], 0) + v
    return m
for nomi in [('Reaper',), ('Reaper', 'Goldbot'), ('Reaper', 'Goldbot', 'Phantom'), ('Reaper', 'Goldbot', 'Phantom', 'GTP_PROP'), ('Reaper', 'Phantom')]:
    mx, t = lots_ev(nomi); mm = mesi(comb(nomi))
    pm = min(mm, key=mm.get); neg = sum(1 for v in mm.values() if v < 0)
    print('%-34s lotti max insieme %.2f (%s)  mese peggiore %s %+.0f  mesi negativi %d/%d  mesi a +100%%: %s' % ('+'.join(nomi), mx, t, pm, mm[pm], neg, len(mm), stats(comb(nomi))[4]))
