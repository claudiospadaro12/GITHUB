#!/usr/bin/env python3
"""Spread PAGATO dai nove EA nelle corse a 5.000 (tick reali, 01/2025-10/2026): per ogni posizione lo spread della barra M1 all'ingresso e all'uscita (colonna spread dell'export M1 BCM, punti; XAUUSD 2 decimali: 1 punto = 0,01 USD), costo = lotti x 100 oz x media(spread ingresso, spread uscita) x fx. Uso: python3 calcola_spread_pagato_5k.py --barre <cartella con ABTG_M1_XAUUSD.csv>"""
import os, sys, glob, bisect, statistics, datetime, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
A = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'DEEP5K_PERSONALE_20261026') + '/'
BD = sys.argv[sys.argv.index('--barre') + 1] if '--barre' in sys.argv else 'exp/in'
spr = {}
for l in open(BD + '/ABTG_M1_XAUUSD.csv', encoding='utf-8-sig'):
    q = l.rstrip('\r\n').split(';')
    if not q or q[0].startswith('time'): continue
    try: spr[E.minuto(q[0])] = int(q[6])
    except Exception: pass
ks = sorted(spr)
def sp_at(m):
    i = bisect.bisect_right(ks, m) - 1
    return spr[ks[i]] if i >= 0 else None
NOMI = [('Gold Snap', 'DEEP5K_GOLDSNAP'), ('SomaGold', 'DEEP5K_SOMAGOLD'), ('SixtyNine', 'DEEP5K_SIXTYNINEEA'), ('Umbra Vault', 'DEEP5K_UMBRAVAULTAIEA'),
        ('Microedge', 'DEEP5K_MICROEDGENEURALMATRIXEA'), ('Vortex Turbo', 'DEEP5K_VORTEXTURBOEA'), ('Rocket Breakout', 'DEEP5K_ROCKETBREAKOUTEA'),
        ('Entry Points Pro', 'DEEP5K_ENTRYPOINTSPROROBOT'), ('ORB Revolution', 'DEEP5K_ORBREVOLUTION')]
allsp = [v for m, v in spr.items() if m >= E.minuto('2025.01.03 00:00')]
print('spread M1 XAUUSD 2025-26 (punti, 1 punto = 0,01 USD): mediana %.0f, media %.1f, P95 %.0f, P99 %.0f' % (statistics.median(allsp), statistics.mean(allsp), sorted(allsp)[int(.95 * len(allsp))], sorted(allsp)[int(.99 * len(allsp))]))
print('%-16s %6s %8s %9s %9s %9s %11s %9s %9s' % ('EA', 'pos', 'lotti', 'sp_in', 'sp_out', 'mediana', 'costo EUR', '% lordo', '% netto'))
righe = {}
for nome, d in NOMI:
    D = E.affari_p(glob.glob(A + d + '/report/*.htm.gz')[0]); pos, _, _ = E.accoppia(D)
    sr = E.fx_serie(pos); med = statistics.median([f for _, f in sr]) if sr else 0.9
    net = sum(x['net'] for x in D); costo = 0.0; lot = 0.0; si = []; so = []; ora = collections.defaultdict(list); lordo = sum(p[6] for p in pos if p[6] > 0)
    for (mi, mo, s, v, pi, po, prof) in pos:
        a = sp_at(mi); b = sp_at(mo)
        if a is None or b is None: continue
        si.append(a); so.append(b); lot += v
        costo += v * E.CONTRATTO * ((a + b) / 2.0 * 0.01) * E.fx_a(sr, mo, med)
        h = (E.EPOCA + datetime.timedelta(minutes=mi)).hour; ora[h].append(a)
    print('%-16s %6d %8.1f %9.1f %9.1f %9.0f %11.0f %8.1f%% %8.1f%%' % (nome, len(si), lot, statistics.mean(si), statistics.mean(so), statistics.median(si + so), costo, 100 * costo / lordo if lordo else 0, 100 * costo / net if net > 0 else float('nan')))
    righe[nome] = {h: statistics.median(v) for h, v in sorted(ora.items())}
print('\nMediana dello spread all INGRESSO per ora SERVER (punti):')
for nome, r in righe.items():
    top = sorted(r.items(), key=lambda x: -x[1])[:3]
    print('%-16s ore con piu ingressi caldi: %s' % (nome, ', '.join('%02d:00=%.0f' % (h, v) for h, v in top)))
