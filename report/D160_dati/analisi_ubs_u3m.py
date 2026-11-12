#!/usr/bin/env python3
"""UBS U3 tappa 1: DD01 (DD equity / 10) per set e periodo (P1 2013-2018, P2 2019-2025), letto dai REFERTO_ANNO80K_TRANCHE.txt di una cartella ANNO_ORO_GRADINI_UBSU3M_*.
Uso: python3 -I analisi_ubs_u3m.py <cartella> <ubsu1b.json> <out.json>   (stessa logica usata il 12/11/2026; HistoricalMaxDD tappa 2 = DD01 x 1,15)"""
import re, glob, json, sys
W, U1B, OUT = sys.argv[1:4]
u1 = json.load(open(U1B)); out = {}; rows = {}
for ref in sorted(glob.glob(W + '/*/*/REFERTO_ANNO80K_TRANCHE.txt')) + sorted(glob.glob(W + '/*/REFERTO_ANNO80K_TRANCHE.txt')):
    folder = ref.split('/')[-3] if ref.count('/') >= 2 else ref
    mm = re.match(r'UBSU3M_(.+)_100000_(2013-2018|2019-2025)$', folder)
    if not mm: continue
    tag, per = mm.groups(); t = open(ref, encoding='utf-8', errors='replace').read()
    m = re.search(r'operazioni (\d+)\s+netto (-?[\d.]+)\s+PF ([\d.]+|inf|-)\s+DD equita ([\d.]+)\(([\d.]+)%\)', t)
    rows[(tag, per)] = dict(ops=int(m.group(1)), net=float(m.group(2)), dd=float(m.group(4)), stato=re.search(r'STATO (\w+)', t).group(1), q=int(re.search(r'qualita (\d+)%', t).group(1)))
for tag in sorted({k[0] for k in rows}):
    a, b = rows.get((tag, '2013-2018')), rows.get((tag, '2019-2025'))
    if not a or not b: continue
    out[tag] = dict(dd01_P1=a['dd'] / 10, dd01_P2=b['dd'] / 10, full=u1[tag]['2013-2025']['dd01'], ops1=a['ops'], ops2=b['ops'], net1=a['net'], net2=b['net'])
json.dump(out, open(OUT, 'w'), indent=1)
