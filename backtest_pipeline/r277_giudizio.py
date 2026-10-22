#!/usr/bin/env python3
# =====================================================================
#  r277_giudizio.py -- LETTORE CONGELATO dei round R277 (regola di Emiliano sul Nasdaq: candela 5 minuti, filtro ampiezza 17-38)
#  Scritto il 22/10/2026 PRIMA di aprire gli zip, dai criteri dei file prova backtest_pipeline/prove/R277a..R277d (par. 1).
#  USO:  python3 backtest_pipeline/r277_giudizio.py <cartella con ROUND_R277a..d>      |   --autotest
#  Layout: <cartella>/ROUND_R277a|b|c|d/ABTG_Nasdaq_Apertura_US_NASUSD_(IS|OOS)_<tag>.csv  (2 righe per CSV: le due gemelle)
#  Non promuove niente. Con Trades < 150 non c'e' verdetto di merito.
# =====================================================================
import csv, os, sys, tempfile
JOBS = {'R277a': ('PRE', True), 'R277b': ('PRE', False), 'R277c': ('POST', True), 'R277d': ('POST', False)}
BASE_PF_OOS, BASE_DD_OOS = 1.21546, 7.8576
SOGLIA_N = 150
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    out = []
    for r in rows:
        out.append(dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades'])), magic=r['InpMagic']))
    return out
def g1(rows):
    if len(rows) != 2: return False, 'righe %d invece di 2' % len(rows)
    a, b = rows
    ok = abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) < 1e-9
    return ok, ('gemelle identiche' if ok else 'GEMELLE DIVERSE: %r %r' % (a, b))
def carica(cart):
    R = {}
    for tag in JOBS:
        d = os.path.join(cart, 'ROUND_' + tag); R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(d, 'ABTG_Nasdaq_Apertura_US_NASUSD_%s_%s.csv' % (leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p); ok, msg = g1(rows)
            R[tag][leg] = dict(rows=rows, g1=ok, msg=msg, pf=rows[0]['pf'], dd=rows[0]['dd'], n=rows[0]['n'], profit=rows[0]['profit'])
    return R
def giudica(R):
    out = []
    for tag in sorted(JOBS):
        for leg in ('IS', 'OOS'):
            x = R[tag][leg]
            out.append('%s %s: %s' % (tag, leg, 'MANCANTE' if x is None else 'n %d | PF %.4f | DD %.2f%% | Profit %.2f | G1 %s' % (x['n'], x['pf'], x['dd'], x['profit'], x['msg'])))
    for tempo in ('PRE', 'POST'):
        on = [t for t, (tm, f) in JOBS.items() if tm == tempo and f][0]; off = [t for t, (tm, f) in JOBS.items() if tm == tempo and not f][0]
        ris = []; valido = True
        for leg in ('IS', 'OOS'):
            a, b = R[on][leg], R[off][leg]
            if a is None or b is None or not (a['g1'] and b['g1']): valido = False; ris.append('%s: NON VALUTABILE (file mancante o G1 rotto)' % leg); continue
            c1 = a['pf'] - b['pf'] >= 0.10; c2 = a['dd'] <= 1.10 * b['dd']; c3 = b['n'] > 0 and a['n'] >= 0.40 * b['n']
            ris.append('%s: dPF %+.4f (>=0,10 %s) | DD %.2f vs %.2f (<=1,10x %s) | Trades %d/%d = %.2f (>=0,40 %s)' % (leg, a['pf'] - b['pf'], c1, a['dd'], b['dd'], c2, a['n'], b['n'], a['n'] / b['n'] if b['n'] else 0, c3))
            valido = valido and c1 and c2 and c3
        out.append('FILTRO %s (%s acceso contro %s spento): %s' % (tempo, on, off, 'UTILE' if valido and all('NON VALUTABILE' not in r for r in ris) else 'NON DIMOSTRATO'))
        out += ['    ' + r for r in ris]
    for tag in sorted(JOBS):
        x = R[tag]['OOS']
        if x is None or not x['g1']: continue
        batte = x['pf'] > BASE_PF_OOS and x['dd'] <= BASE_DD_OOS and x['n'] >= SOGLIA_N
        why = '' if x['n'] >= SOGLIA_N else ' (Trades %d < %d: NESSUN verdetto di merito)' % (x['n'], SOGLIA_N)
        out.append('%s contro la cella R274a (PF OOS %.5f, DD %.4f): %s%s' % (tag, BASE_PF_OOS, BASE_DD_OOS, 'BATTE' if batte else 'NON batte', why))
    return out
def autotest():
    d = tempfile.mkdtemp(); hdr = ['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades', 'InpMagic']
    def w(tag, leg, vals):
        os.makedirs(os.path.join(d, 'ROUND_' + tag), exist_ok=True)
        with open(os.path.join(d, 'ROUND_' + tag, 'ABTG_Nasdaq_Apertura_US_NASUSD_%s_%s.csv' % (leg, tag)), 'w', newline='') as f:
            c = csv.writer(f); c.writerow(hdr)
            for i, m in enumerate(('1', '2')): c.writerow([i, vals[0], vals[1], vals[2], vals[3], m])
    for tag, v in {'R277a': (500, 1.40, 6.0, 100), 'R277b': (200, 1.05, 9.0, 200), 'R277c': (50, 1.0, 5.0, 40), 'R277d': (60, 1.0, 5.0, 150)}.items():
        for leg in ('IS', 'OOS'): w(tag, leg, v)
    o = giudica(carica(d)); t = '\n'.join(o)
    assert 'FILTRO PRE (R277a acceso contro R277b spento): UTILE' in t, t
    assert 'FILTRO POST (R277c acceso contro R277d spento): NON DIMOSTRATO' in t, t
    assert 'R277a contro la cella R274a' in t and 'NON batte' in t and 'NESSUN verdetto' in t, t
    print('AUTOTEST OK'); return 0
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': sys.exit(autotest())
    if len(sys.argv) < 2: sys.exit(__doc__)
    print('\n'.join(giudica(carica(sys.argv[1]))))
