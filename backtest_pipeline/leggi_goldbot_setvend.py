#!/usr/bin/env python3
"""Lettore: Goldbot One con i set del venditore (Risk=3), zip ANNO80K_GOLDBOT_SETVEND. Per ogni passata: netto, DD equity, peggior giorno REALIZZATO (giorno FTMO, % del saldo di inizio giornata), giorni >= 3/4/5%; PROP-ANNI per configurazione; calibrazione M1/M4 sui 21 mesi (rapporto netto e correlazione mensile). Uso: python3 leggi_goldbot_setvend.py <cartella con le 16 sottocartelle>"""
import os, sys, glob, csv, statistics, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
C = sys.argv[1]; DEP = 80000.0
def mensili(D):
    m = collections.defaultdict(float)
    for x in D: m[x['t'][:7]] += x['net']
    return m
def leggi(sub):
    f = glob.glob('%s/%s/*/MANIFEST_ANNO80K.csv' % (C, sub))[0]; mf = list(csv.DictReader(open(f, encoding='utf-8-sig'), delimiter=';'))[0]
    rep = glob.glob(os.path.join(os.path.dirname(f), 'report', '*.htm*'))[0]
    D = E.affari_p(rep); D = sorted(D, key=lambda x: x['t'])
    bal = DEP; gg = collections.OrderedDict()
    for x in D:
        g = G.giorno_ftmo(x['t']); gg.setdefault(g, [bal, 0.0]); gg[g][1] += x['net']; bal += x['net']
    peg = [(-v[1] / v[0] * 100 if v[1] < 0 else 0.0, g) for g, v in gg.items()]
    w = max(peg)
    return mf, D, w, sum(p >= 3 for p, _ in peg), sum(p >= 4 for p, _ in peg), sum(p >= 5 for p, _ in peg)
RES = {}
print('%-18s %9s %5s %20s %22s %18s' % ('passata', 'netto', 'PF', 'DD equity', 'peggior giorno real.', 'gg >=3/4/5%'))
for sub in sorted(os.listdir(C)):
    mf, D, w, c3, c4, c5 = leggi(sub); RES[sub] = (mf, D, w, c3, c4, c5)
    print('%-18s %9s %5s %20s  -%.2f%% (%s) %9d/%d/%d  stato %s input_ok %s stop_out %s no_money %s' % (sub, mf['profitto'], mf['pf'], mf['dd_equita'], w[0], w[1], c3, c4, c5, mf['stato'], mf['input_ok'], mf['stop_out_log'], mf['no_money_log']))
print()
for cfg in ('PF105', 'PF525', 'LOW3'):
    ok = True; dett = []
    for a in ('2013', '2018', '2020'):
        mf, D, w, c3, c4, c5 = RES['%s_M1_GB_%s' % (a, cfg)]
        net = float(mf['profitto']); dd = float(mf['dd_equita'].split('(')[0])
        c = net > 0 and dd <= 8000 and w[0] < 5 and mf['stop_out_log'] == '0'
        ok = ok and c; dett.append('%s %s' % (a, 'ok' if c else 'FALLISCE(net %+.0f DD %.0f giorno -%.2f%%)' % (net, dd, w[0])))
    print('PROP-ANNI %-6s %s  [%s]' % (cfg, 'SI (sui tre anni)' if ok else 'NO', '; '.join(dett)))
m1 = RES['21M_M1_GB_PF105'][1]; m4 = RES['21M_M4_GB_PF105'][1]
a = mensili(m1); b = mensili(m4); ks = sorted(set(a) & set(b))
n1 = sum(x['net'] for x in m1); n4 = sum(x['net'] for x in m4)
cor = statistics.correlation([a[k] for k in ks], [b[k] for k in ks])
print('calibrazione PF105 21 mesi: netto M1 %.0f / M4 %.0f = rapporto %.2f; correlazione mensile %.2f (%d mesi)' % (n1, n4, n1 / n4, cor, len(ks)))
