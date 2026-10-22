#!/usr/bin/env python3
# Divisione estate (allineato: server UTC+1 fisso, apertura cash USA 14:30 server) / inverno (apertura 15:30 server, il test guarda 1 ora prima)
# del per-trade OOS di R277. ESPLORATIVO: scritto DOPO aver visto i numeri globali; il verdetto congelato resta r277_giudizio.py.
# USO: python3 r277_stagioni.py <cartella PERTRADE>
import csv, sys, collections
def seas(d):
    t = d[:10]
    if t <= '2024.11.02' or '2025.03.10' <= t <= '2025.10.31' or t >= '2026.03.09': return 'allineato'
    return 'inverno'
for tag, m in (('a PRE ON', 798811), ('b PRE OFF', 798821), ('c POST ON', 798831), ('d POST OFF', 798841)):
    rows = list(csv.DictReader(open('%s/abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_%d.csv' % (sys.argv[1], m)), delimiter=';'))
    pos = collections.OrderedDict()
    for r in rows:
        k = r['position_id']; pos.setdefault(k, [r['close_time'], 0.0]); pos[k][1] += float(r['net_profit']); pos[k][0] = r['close_time']
    S = collections.defaultdict(list)
    for t, p in pos.values(): S[seas(t)].append(p)
    for k, v in sorted(S.items()):
        g = sum(x for x in v if x > 0); l = -sum(x for x in v if x < 0)
        print('%s | %s: posizioni %d netto %.0f PF %.2f vincenti %.0f%%' % (tag, k, len(v), sum(v), g / l if l else float('inf'), 100 * sum(x > 0 for x in v) / len(v)))
