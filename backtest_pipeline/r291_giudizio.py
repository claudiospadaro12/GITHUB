#!/usr/bin/env python3
# =====================================================================
#  r291_giudizio.py -- LETTORE CONGELATO del round R291 (varianti di visibilita': MaxMin_Vis, Nasdaq_Vis, ORB_Vis)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r291_giudizio.py <cartella con ROUND_R291a..d e LOG_TESTER> | --autotest
#  Layout: <cartella>/ROUND_R291x/<EA>_<SIMBOLO>_(IS|OOS)_R291x.csv ; <cartella>/LOG_TESTER/*.log (UTF-16 o UTF-8)
#  CRITERI CONGELATI (anche nei file prova R291a-d):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001).
#   G0 ogni variante = la misura storica dell'ORIGINALE al centesimo (tolleranza 1,01/0,0002/0,0001/uguali): a = R246i, b = R286a, c e d = R283a. Se fallisce la variante cambia le decisioni: NON SI USA.
#   VISIBILITA': MaxMin_Vis >= 50 righe '[VIS] CorrBias'; Nasdaq_Vis >= 50 righe '[VIS] gate EMA'; ORB_Vis: '[VIS] anti-duplicato' = 0 (nessun riavvio nel tester) e le righe '[VIS] ... RIFIUTATO' si riportano.
#   Il riavvio a meta' giornata NON e' riproducibile nel tester: l'anti-duplicato sul suo caso vero resta NON TESTATO.
# =====================================================================
import csv, os, sys, glob, tempfile
CASI = {
    'R291a': ('ABTG_MaxMinNotte_DAX_Short_Ottimizzato_Vis', 'D30EUR', {'IS': (4766.96, 1.87803, 3.0977, 20), 'OOS': (6143.38, 2.15985, 1.9213, 21)}),
    'R291b': ('ABTG_Nasdaq_Apertura_US_Vis', 'NASUSD', {'IS': (1052.03, 1.25328, 2.4509, 57), 'OOS': (-192.82, 0.95527, 1.9449, 47)}),
    'R291c': ('ABTG_ORB_Ottimizzato_Vis', 'U30USD', {'IS': (7630.13, 1.24678, 8.2477, 71), 'OOS': (33442.57, 1.67803, 9.9897, 119)}),
    'R291d': ('ABTG_ORB_Ottimizzato_Vis', 'U30USD', {'IS': (7630.13, 1.24678, 8.2477, 71), 'OOS': (33442.57, 1.67803, 9.9897, 119)}),
}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def leggi_log(path):
    b = open(path, 'rb').read()
    if b[:2] == b'\xff\xfe' or (len(b) > 3 and b[1] == 0 and b[3] == 0): return b.decode('utf-16', 'replace')
    return b.decode('utf-8', 'replace')
def conta_log(cart):
    tot = {'[VIS] CorrBias': 0, '[VIS] gate EMA': 0, '[VIS] anti-duplicato': 0, 'RIFIUTATO': 0, 'NON LETTO': 0}
    for p in glob.glob(os.path.join(cart, 'LOG_TESTER', '*.log')):
        try: t = leggi_log(p)
        except Exception: continue
        for riga in t.split('\n'):
            if '[VIS]' not in riga: continue
            for k in tot:
                if k in riga: tot[k] += 1
    return tot
def giudica(cart):
    es = {}; ok_tutti = True
    for tag, (ea, sym, ref) in CASI.items():
        r = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag))
            if not os.path.exists(p): r[leg] = None; continue
            rows = leggi(p); r[leg] = dict(g1=g1(rows), **rows[0]) if rows else None
        if any(r[l] is None for l in r): es[tag] = 'MANCANTE'; ok_tutti = False; continue
        if not all(r[l]['g1'] for l in r): es[tag] = 'GUASTO: gemelle DIVERSE (G1)'; ok_tutti = False; continue
        g0 = all(abs(r[l]['profit'] - ref[l][0]) <= 1.01 and abs(r[l]['pf'] - ref[l][1]) <= 0.0002 and abs(r[l]['dd'] - ref[l][2]) <= 0.0001 + 1e-9 and r[l]['n'] == ref[l][3] for l in ('IS', 'OOS'))
        es[tag] = 'G0 %s (IS %.2f/%.5f/%d, OOS %.2f/%.5f/%d)' % ('IDENTICO all\'originale' if g0 else 'DIVERSO DALL\'ORIGINALE: la variante cambia le decisioni, NON SI USA', r['IS']['profit'], r['IS']['pf'], r['IS']['n'], r['OOS']['profit'], r['OOS']['pf'], r['OOS']['n'])
        if not g0: ok_tutti = False
    c = conta_log(cart)
    es['log: righe [VIS]'] = ', '.join('%s=%d' % (k, v) for k, v in c.items())
    es['visibilita MaxMin_Vis (>=50 CorrBias)'] = 'SI' if c['[VIS] CorrBias'] >= 50 else 'NO (%d)' % c['[VIS] CorrBias']
    es['visibilita Nasdaq_Vis (>=50 gate EMA)'] = 'SI' if c['[VIS] gate EMA'] >= 50 else 'NO (%d)' % c['[VIS] gate EMA']
    es['anti-duplicato mai scattato nel tester (atteso 0)'] = 'SI' if c['[VIS] anti-duplicato'] == 0 else 'NO (%d righe)' % c['[VIS] anti-duplicato']
    es['ESITO'] = 'VARIANTI IDENTICHE AGLI ORIGINALI (G0 su tutte e quattro) - la visibilita\' va letta sopra' if ok_tutti else 'ALMENO UNA VARIANTE NON E\' IDENTICA O MANCA: non si usa'
    return es
def autotest():
    d = tempfile.mkdtemp(); os.makedirs(os.path.join(d, 'LOG_TESTER'), exist_ok=True)
    def agg(tag, leg, riga, extra=0.0):
        ea, sym, ref = CASI[tag]; p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades']); w.writerow([0] + list(riga)); r2 = list(riga); r2[0] += extra; w.writerow([1] + r2)
    def tutto(shift=0.0):
        for tag, (ea, sym, ref) in CASI.items():
            for l in ('IS', 'OOS'): agg(tag, l, (ref[l][0] + shift, ref[l][1], ref[l][2], ref[l][3]))
    def log(n_corr, n_gate, n_dup):
        righe = ['CS\t0\t10:00\tX (D30EUR,M15)\t2025.01.01 [MaxMinNotte] [VIS] CorrBias S&P: EMA14=1 EMA100=2 -> bias -1'] * n_corr + ['CS\t0\t10:00\tX\t[VIS] gate EMA50=1 EMA200=2 -> ribassista'] * n_gate + ['CS\t0\t10:00\tX\t[VIS] anti-duplicato: NON ripiazzo'] * n_dup
        open(os.path.join(d, 'LOG_TESTER', '0003_Agent.log'), 'wb').write(('\n'.join(righe) + '\n').encode('utf-16'))
    tutto(); log(60, 60, 0); es = giudica(d); assert es['ESITO'].startswith('VARIANTI IDENTICHE') and es['visibilita MaxMin_Vis (>=50 CorrBias)'] == 'SI' and es['visibilita Nasdaq_Vis (>=50 gate EMA)'] == 'SI' and es['anti-duplicato mai scattato nel tester (atteso 0)'] == 'SI', es
    log(10, 60, 0); es = giudica(d); assert es['visibilita MaxMin_Vis (>=50 CorrBias)'].startswith('NO'), es
    log(60, 60, 3); es = giudica(d); assert es['anti-duplicato mai scattato nel tester (atteso 0)'].startswith('NO'), es
    tutto(5.0); es = giudica(d); assert es['ESITO'].startswith('ALMENO UNA'), es
    tutto(); agg('R291b', 'OOS', (-192.82, 0.95527, 1.9449, 47), extra=3.0); es = giudica(d); assert es['R291b'].startswith('GUASTO'), es
    print('AUTOTEST R291: 5 casi OK (identiche + visibilita, poche righe, anti-dup scattato, G0 fallito, G1 fallito)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    for k, v in giudica(sys.argv[1]).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Il riavvio a meta\' giornata non e\' nel tester.')
