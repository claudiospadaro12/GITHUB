#!/usr/bin/env python3
# =====================================================================
#  r289_giudizio.py -- LETTORE CONGELATO del round congiunto sul parziale (R289a-f + DAX R288a/c)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r289_giudizio.py <cartella con ROUND_R289a..f> | --autotest
#  Layout: <cartella>/ROUND_R289x/<EA>_<SIMBOLO>_(IS|OOS)_R289x.csv (due righe = le due gemelle)
#  CRITERI CONGELATI (anche nei file prova R289a-f; vedi le intestazioni):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001). G0: ogni base = la misura storica della cella (tolleranza 1,01/0,0002/0,0001/uguali), altrimenti la cella non si legge.
#   PER CELLA: dPF = PF(senza parziale) - PF(base), IS e OOS. >= +0,10 in entrambe: senza parziale MEGLIO; <= -0,10 in entrambe: PEGGIO; altrimenti NON DISTINGUIBILE o MISTO.
#     Verdetto di cella solo con >= 100 deal in OGNI gamba di base e braccio; altrimenti DESCRITTIVO. SEGNO CONCORDE POSITIVO: dPF > 0 in IS e OOS.
#   CONGIUNTO su 4 celle (DAX da R288, Dow, Nasdaq 770260, Nasdaq 770250): >= 3 concordi positive E nessuna PEGGIO -> INDIZIO COERENTE (non prova); <= 1 concorde positiva -> NESSUN INDIZIO; altrimenti MISTO.
#   Le celle non sono indipendenti (stesso motore, stesso regime toro): nessun p-value.
# =====================================================================
import csv, os, sys, tempfile
SOGLIA = 0.10; MIN_OP = 100
CELLE = {  # nome: (EA, simbolo, tag base, tag senza, riferimento storico IS/OOS (profit, pf, dd, n))
    'Dow Apertura 770202': ('ABTG_Dow_Apertura_US', 'U30USD', 'R289a', 'R289b', {'IS': (2811.84, 1.22247, 5.6692, 74), 'OOS': (6721.93, 1.27013, 4.3941, 130)}),
    'Nasdaq 770260': ('ABTG_Nasdaq_Apertura_US', 'NASUSD', 'R289c', 'R289d', {'IS': (7014.21, 1.22116, 7.3069, 135), 'OOS': (8496.74, 1.21546, 7.8576, 172)}),
    'Nasdaq 770250': ('ABTG_Nasdaq_Apertura_US', 'NASUSD', 'R289e', 'R289f', {'IS': (1052.03, 1.25328, 2.4509, 57), 'OOS': (-192.82, 0.95527, 1.9449, 47)}),
}
DAX = {'base': {'IS': (3789.36, 1.12634, 5.4362, 175), 'OOS': (18029.58, 1.39709, 7.2328, 270)}, 'senza': {'IS': (5569.37, 1.18323, 4.9576, 132), 'OOS': (23607.28, 1.49140, 6.2719, 193)}}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def carica(cart):
    R = {}
    for nome, (ea, sym, tb, ts, ref) in CELLE.items():
        for t in (tb, ts):
            R[t] = {}
            for leg in ('IS', 'OOS'):
                p = os.path.join(cart, 'ROUND_' + t, '%s_%s_%s_%s.csv' % (ea, sym, leg, t))
                if not os.path.exists(p): R[t][leg] = None; continue
                rows = leggi(p); R[t][leg] = dict(g1=g1(rows), **rows[0]) if rows else None
    return R
def g0(r, ref): return all(abs(r[l]['profit'] - ref[l][0]) <= 1.01 and abs(r[l]['pf'] - ref[l][1]) <= 0.0002 and abs(r[l]['dd'] - ref[l][2]) <= 0.0001 + 1e-9 and r[l]['n'] == ref[l][3] for l in ('IS', 'OOS'))
def classifica(di, do, minimo):
    if minimo < MIN_OP: v = 'DESCRITTIVO (meno di %d deal in una gamba, minimo %d)' % (MIN_OP, minimo); cl = 'D'
    elif di >= SOGLIA and do >= SOGLIA: v = 'senza parziale MEGLIO'; cl = 'M'
    elif di <= -SOGLIA and do <= -SOGLIA: v = 'senza parziale PEGGIO'; cl = 'P'
    else: v = 'NON DISTINGUIBILE o MISTO'; cl = 'N'
    if minimo < MIN_OP and (di <= -SOGLIA and do <= -SOGLIA): cl = 'P'   # una cella descrittiva molto negativa conta comunque come PEGGIO per il congiunto
    return cl, v
def giudica(R):
    es = {}; celle = []
    for nome, (ea, sym, tb, ts, ref) in CELLE.items():
        gu = [k for t in (tb, ts) for k in ('IS', 'OOS') if R[t][k] is None or not R[t][k]['g1'] or R[t][k]['n'] <= 0]
        if gu: es[nome] = 'GUASTO (dati mancanti, gemelle diverse o zero operazioni): ' + ','.join(gu); continue
        if not g0(R[tb], ref): es[nome] = 'G0 FALLITO: la base non riproduce la misura storica: cella NON leggibile'; continue
        b, s = R[tb], R[ts]
        di = s['IS']['pf'] - b['IS']['pf']; do = s['OOS']['pf'] - b['OOS']['pf']
        cl, v = classifica(di, do, min(b['IS']['n'], b['OOS']['n'], s['IS']['n'], s['OOS']['n']))
        conc = di > 0 and do > 0
        celle.append((nome, cl, conc))
        es[nome] = 'dPF IS %+.3f, OOS %+.3f; profit IS %.0f->%.0f, OOS %.0f->%.0f; DD IS %.2f->%.2f, OOS %.2f->%.2f; deal IS %d->%d, OOS %d->%d -> %s%s' % (di, do, b['IS']['profit'], s['IS']['profit'], b['OOS']['profit'], s['OOS']['profit'], b['IS']['dd'], s['IS']['dd'], b['OOS']['dd'], s['OOS']['dd'], b['IS']['n'], s['IS']['n'], b['OOS']['n'], s['OOS']['n'], v, ' [segno concorde positivo]' if conc else '')
    # DAX da R288
    di = DAX['senza']['IS'][1] - DAX['base']['IS'][1]; do = DAX['senza']['OOS'][1] - DAX['base']['OOS'][1]
    cl, v = classifica(di, do, min(DAX['base']['IS'][3], DAX['base']['OOS'][3], DAX['senza']['IS'][3], DAX['senza']['OOS'][3]))
    celle.append(('DAX Apertura 770101 (R288)', cl, di > 0 and do > 0))
    es['DAX Apertura 770101 (R288)'] = 'dPF IS %+.3f, OOS %+.3f -> %s%s' % (di, do, v, ' [segno concorde positivo]' if (di > 0 and do > 0) else '')
    if len(celle) < 4: es['CONGIUNTO'] = 'NON VALUTABILE: %d celle su 4 leggibili' % len(celle); return es
    nconc = sum(1 for _, _, c in celle if c); npeg = sum(1 for _, cl, _ in celle if cl == 'P')
    if nconc >= 3 and npeg == 0: v = 'INDIZIO COERENTE che il parziale non aiuta (NON una prova)'
    elif nconc <= 1: v = 'NESSUN INDIZIO'
    else: v = 'MISTO'
    es['CONGIUNTO'] = '%d celle su 4 con segno concorde positivo, %d PEGGIO -> %s' % (nconc, npeg, v)
    return es
def riporta(R):
    out = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for t in sorted(R):
        for leg in ('IS', 'OOS'):
            r = R[t][leg]; out.append('%-6s %-4s ' % (t, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return out
def autotest():
    d = tempfile.mkdtemp()
    def agg(ea, sym, t, leg, riga):
        p = os.path.join(d, 'ROUND_' + t); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (ea, sym, leg, t)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades']); w.writerow([0] + list(riga)); w.writerow([1] + list(riga))
    def tutto(dpf, n_extra=0):
        for nome, (ea, sym, tb, ts, ref) in CELLE.items():
            for l in ('IS', 'OOS'):
                agg(ea, sym, tb, l, ref[l]); r = ref[l]; agg(ea, sym, ts, l, (r[0], r[1] + dpf[nome][0 if l == 'IS' else 1], r[2], r[3] + n_extra))
    pos = {n: (0.2, 0.2) for n in CELLE}; neg = {n: (-0.2, -0.2) for n in CELLE}
    tutto(pos, 200); es = giudica(carica(d)); assert 'INDIZIO COERENTE' in es['CONGIUNTO'], es
    tutto(neg, 200); es = giudica(carica(d)); assert 'NESSUN INDIZIO' in es['CONGIUNTO'] or 'MISTO' in es['CONGIUNTO'], es
    tutto({n: (0.01, 0.01) for n in CELLE}, 200); es = giudica(carica(d)); assert 'INDIZIO COERENTE' in es['CONGIUNTO'], es     # segno concorde basta
    m = {n: (0.2, 0.2) for n in CELLE}; m['Nasdaq 770260'] = (-0.2, -0.2)
    tutto(m, 200); es = giudica(carica(d)); assert 'MISTO' in es['CONGIUNTO'] or 'INDIZIO' in es['CONGIUNTO'], es
    assert '1 PEGGIO' in es['CONGIUNTO'] or 'MISTO' in es['CONGIUNTO'], es
    tutto(pos, 200); agg('ABTG_Dow_Apertura_US', 'U30USD', 'R289a', 'OOS', (6721.93 + 5, 1.27013, 4.3941, 130)); es = giudica(carica(d)); assert es['Dow Apertura 770202'].startswith('G0 FALLITO') and 'NON VALUTABILE' in es['CONGIUNTO'], es
    tutto(pos, 200); agg('ABTG_Nasdaq_Apertura_US', 'NASUSD', 'R289c', 'IS', (7014.21, 1.22116, 7.3069, 135)); p = os.path.join(d, 'ROUND_R289c', 'ABTG_Nasdaq_Apertura_US_NASUSD_IS_R289c.csv')
    rows = list(csv.reader(open(p))); rows[2][1] = '9999'; csv.writer(open(p, 'w', newline='')).writerows(rows); es = giudica(carica(d)); assert es['Nasdaq 770260'].startswith('GUASTO'), es
    print('AUTOTEST R289: 6 casi OK (indizio coerente, nessun indizio, segno concorde minimo, misto, G0 fallito, G1 fallito)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1]); print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Stesso motore, stesso regime toro: le celle non sono indipendenti.')
