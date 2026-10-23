#!/usr/bin/env python3
# =====================================================================
#  r283_giudizio.py -- LETTORE CONGELATO del round R283 (ABTG_ORB_Emiliano v1.00)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip, dai criteri dei file prova R283a-d (par. 1).
#  USO:  python3 backtest_pipeline/r283_giudizio.py <cartella con ROUND_R283a..d>      |   --autotest
#  Layout: <cartella>/ROUND_R283x/<EA>_<SIMBOLO>_(IS|OOS)_R283x.csv  (colonne Profit, Profit Factor, Equity DD %, Trades; due righe = le due gemelle)
#  Non giudica la regola di Emiliano e non promuove niente: G1, G0 (non-regressione) e IMPIANTO; numeri solo riportati.
# =====================================================================
import csv, os, sys, tempfile
ROUNDS = {
    'R283a': ('ABTG_ORB_Ottimizzato', 'U30USD'),
    'R283b': ('ABTG_ORB_Emiliano', 'U30USD'),
    'R283c': ('ABTG_ORB_Emiliano', 'NASUSD'),
    'R283d': ('ABTG_ORB_Emiliano', 'U30USD'),
}
def leggi(path):
    with open(path, newline='') as f:
        rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) < 1e-9
def carica(cart):
    R = {}
    for tag, (ea, sym) in ROUNDS.items():
        R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p)
            R[tag][leg] = dict(g1=g1(rows), nrows=len(rows), **rows[0]) if rows else None
    return R
def uguali(x, y):
    return (abs(x['profit'] - y['profit']) <= 1.01 and abs(x['pf'] - y['pf']) <= 0.0002 and abs(x['dd'] - y['dd']) <= 0.0001 and x['n'] == y['n'])
def giudica(R):
    out = []; esito = {}
    # G1
    g1ok = True
    for tag in ROUNDS:
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]
            if r is None: out.append('G1 %s %s: MANCANTE' % (tag, leg)); g1ok = False
            elif not r['g1']: out.append('G1 %s %s: gemelle DIVERSE' % (tag, leg)); g1ok = False
    esito['G1'] = 'OK' if g1ok else 'FALLITO'
    # G0
    g0 = True
    for leg in ('IS', 'OOS'):
        a, b = R['R283a'][leg], R['R283b'][leg]
        if a is None or b is None: g0 = False; out.append('G0 %s: dati mancanti' % leg); continue
        ok = uguali(a, b)
        out.append('G0 %s: a=%s b=%s -> %s' % (leg, (a['profit'], a['pf'], a['dd'], a['n']), (b['profit'], b['pf'], b['dd'], b['n']), 'IDENTICI' if ok else 'DIVERSI'))
        g0 = g0 and ok
    esito['G0'] = 'OK' if g0 else 'FALLITO'
    # IMPIANTO
    for tag in ('R283c', 'R283d'):
        ok = True
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]
            if r is None or r['n'] <= 0: ok = False
        esito['IMPIANTO ' + tag] = ('OK' if ok else 'FALLITO') if esito['G0'] == 'OK' else 'NON LEGGIBILE (G0 fallito)'
    return out, esito
def riporta(R):
    righe = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for tag in ROUNDS:
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]
            righe.append('%-6s %-4s ' % (tag, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return righe
def autotest():
    d = tempfile.mkdtemp()
    def scrivi(tag, leg, righe):
        ea, sym = ROUNDS[tag]
        p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades'])
            for i, r in enumerate(righe): w.writerow([i] + list(r))
    base = (100.0, 1.2, 5.0, 50)
    for t in ROUNDS:
        for leg in ('IS', 'OOS'): scrivi(t, leg, [base, base])
    out, es = giudica(carica(d)); assert es['G1'] == 'OK' and es['G0'] == 'OK' and es['IMPIANTO R283c'] == 'OK', es
    # mutante: b diverso da a nell'OOS -> G0 FALLITO
    scrivi('R283b', 'OOS', [(105.0, 1.2, 5.0, 50), (105.0, 1.2, 5.0, 50)])
    out, es = giudica(carica(d)); assert es['G0'] == 'FALLITO' and es['IMPIANTO R283c'].startswith('NON LEGGIBILE'), es
    # mutante: gemelle diverse -> G1 FALLITO
    scrivi('R283b', 'OOS', [base, (999.0, 1.2, 5.0, 50)])
    out, es = giudica(carica(d)); assert es['G1'] == 'FALLITO', es
    # mutante: R283c senza operazioni in IS -> IMPIANTO FALLITO (G0 ok)
    scrivi('R283b', 'OOS', [base, base]); scrivi('R283c', 'IS', [(0.0, 0.0, 0.0, 0), (0.0, 0.0, 0.0, 0)])
    out, es = giudica(carica(d)); assert es['IMPIANTO R283c'] == 'FALLITO' and es['IMPIANTO R283d'] == 'OK', es
    print('AUTOTEST R283: 4 casi OK (tutto ok, G0 mutante, G1 mutante, impianto senza operazioni)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1])
    print('\n'.join(riporta(R))); out, es = giudica(R); print(); print('\n'.join(out)); print()
    for k, v in es.items(): print('%s: %s' % (k, v))
    print('\nNon giudica la regola di Emiliano: un solo regime, gestione assunta. Numeri solo riportati.')
