#!/usr/bin/env python3
"""Analisi dei 5 estratti 'Report Cronistorico dei Trade' dell'11/11/2026 06:26-06:28 (trial FTMO, demo 50503392/50504894/50504263, reale 10105439).
Uso: python3 -I analisi_conti_1011.py <dir con gli xlsx> <out.json>"""
import openpyxl, sys, re, json, collections, warnings
warnings.simplefilter('ignore')
D, OUT = sys.argv[1:3]
FILES = {'aea3c541-FVFDS.xlsx':'FTMO_1515150476', '1be76018-FVVD.xlsx':'BCM_50503392', 'd3fa3293-GFSDCX.xlsx':'BCM_50504894', '92a1e188-VSd.xlsx':'BCM_50504263', 'ea05b668-GBGFC.xlsx':'REALE_10105439'}
def num(x):
    try: return float(str(x).replace(' ', '').replace(',', ''))
    except: return None
isd = lambda r: r[0] and re.match(r'\d{4}\.\d\d\.\d\d \d\d:\d\d', str(r[0]))
res = {}
for fn, name in FILES.items():
    ws = openpyxl.load_workbook(D + '/' + fn, data_only=True, read_only=True).worksheets[0]
    rows = [list(r) for r in ws.iter_rows(values_only=True)]
    mk = {r[0]: i for i, r in enumerate(rows) if r[0] in ('Posizioni', 'Ordini', 'Affari', 'Ordini attivi')}
    pos = [r for r in rows[mk['Posizioni']:mk['Ordini']] if isd(r)]; ordi = [r for r in rows[mk['Ordini']:mk['Affari']] if isd(r)]
    aff = [r for r in rows[mk['Affari']:mk['Ordini attivi']] if isd(r)]
    summ = {}
    for r in rows:
        if isinstance(r[0], str) and r[0] in ('Bilancio:', 'Equit\u00e0:', 'Linee di Credito:'):
            summ[r[0]] = next((c for c in r[1:] if isinstance(c, (int, float))), None)
    com = {str(r[1]): (r[11] or '') for r in ordi}
    P = [dict(open=str(r[0]), pid=str(r[1]), sym=r[2], tipo=r[3], vol=num(r[4]), px=num(r[5]), sl=num(r[6]), tp=num(r[7]), close=str(r[8]), cpx=num(r[9]), net=(num(r[10]) or 0) + (num(r[11]) or 0) + (num(r[12]) or 0), ea=com.get(str(r[1]), '')) for r in pos]
    O = [dict(open=str(r[0]), oid=str(r[1]), sym=r[2], tipo=r[3], stato=r[9], close=str(r[8]), ea=r[11] or '') for r in ordi]
    A = [dict(t=str(r[0]), dir=r[4], vol=num(r[5]), bal=num(r[12]), ea=r[13] or '') for r in aff]
    res[name] = dict(summ=summ, P=P, O=O, A=A, nact=len([1 for r in rows[mk['Ordini attivi']:] if isd(r)]))
json.dump(res, open(OUT, 'w'), default=str)
def ev(P, lo, hi): return [p for p in P if lo <= p['open'] < hi and p['sym'] == 'XAUUSD']
for name, d in res.items():
    P, O, A = d['P'], d['O'], d['A']
    print('=====', name, d['summ'], 'ordini attivi', d['nact'])
    for lab, lo, hi in (('E1 09/11 sera', '2026.11.09 20:00', '2026.11.09 23:59'), ('E2 10/11 sera', '2026.11.10 16:00', '2026.11.10 19:00')):
        e = ev(P, lo, hi)
        if not e: print(' ', lab, ': nessuna posizione sull oro'); continue
        bal0 = next((a['bal'] - 0 for a in A if a['t'] >= lo and a['dir'] == 'in'), None)
        net = sum(p['net'] for p in e); lots = sum(p['vol'] for p in e)
        by = collections.defaultdict(lambda: [0, 0.0, 0.0])
        for p in e:
            k = re.sub(r'_XAUUSD.*', '', p['ea']) or '?'; by[k][0] += 1; by[k][1] += p['vol']; by[k][2] += p['net']
        print('  %s: %d posizioni, %.2f lotti, %s, netto %.2f, peggiore %.2f, aperte %s -> %s, ultima chiusura %s, bilancio al primo ingresso %s' % (lab, len(e), lots, collections.Counter(p['tipo'] for p in e), net, min(p['net'] for p in e), min(p['open'] for p in e)[11:], max(p['open'] for p in e)[11:], max(p['close'] for p in e), bal0))
        print('     per EA:', {k: (v[0], round(v[1], 2), round(v[2], 2)) for k, v in sorted(by.items())})
    cs = [o for o in O if o['stato'] == 'canceled']
    print('  ordini: totale %d, cancellati %d, per giorno %s' % (len(O), len(cs), dict(sorted(collections.Counter(o['open'][:10] for o in O).items()))))
    last = max((o['open'] for o in O if o['open'].startswith('2026.11.10')), default=None); first = min((o['open'] for o in O if o['open'] >= '2026.11.10 02:00'), default=None)
    print('  ultimo ordine piazzato il 10/11: %s ; ultima cancellazione: %s' % (last, max((o['close'] for o in cs if o['close'].startswith('2026.11.10')), default=None)))
