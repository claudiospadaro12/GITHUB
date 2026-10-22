#!/usr/bin/env python3
# =====================================================================
#  r279_giudizio.py -- LETTORE CONGELATO del round R279 (regola di Emiliano sul Nasdaq D'INVERNO, apertura 15:30 server)
#  Scritto il 22/10/2026 PRIMA di aprire lo zip, dai criteri dei file prova R279a-d (par. 1).
#  USO:  python3 backtest_pipeline/r279_giudizio.py <cartella con ROUND_R279a..d> [<cartella PERTRADE>]     |   --autotest
#  Le finestre sono W1 (R279a acceso / R279b spento) e W2 (R279c acceso / R279d spento). Si legge il CSV _OOS (@FRAZIONEIS 0.001: il _IS puo essere vuoto).
#  Con la cartella PERTRADE stampa anche (ESPLORATIVO) il PF per posizione delle due finestre messe insieme.
# =====================================================================
import csv, os, sys, tempfile, collections
WIN = {'W1': ('R279a', 'R279b', ('798911', '798921')), 'W2': ('R279c', 'R279d', ('798931', '798941'))}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False, 'righe %d invece di 2' % len(rows)
    a, b = rows
    ok = abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) < 1e-9
    return ok, ('gemelle identiche' if ok else 'GEMELLE DIVERSE: %r %r' % (a, b))
def carica(cart):
    R = {}
    for tag in ('R279a', 'R279b', 'R279c', 'R279d'):
        p = os.path.join(cart, 'ROUND_' + tag, 'ABTG_Nasdaq_Apertura_US_NASUSD_OOS_%s.csv' % tag)
        if not os.path.exists(p): R[tag] = None; continue
        rows = leggi(p); ok, msg = g1(rows)
        R[tag] = dict(g1=ok, msg=msg, pf=rows[0]['pf'], dd=rows[0]['dd'], n=rows[0]['n'], profit=rows[0]['profit'])
    return R
def giudica(R):
    out = []
    for tag in sorted(R):
        x = R[tag]
        out.append('%s OOS: %s' % (tag, 'MANCANTE' if x is None else 'n %d | PF %.4f | DD %.2f%% | Profit %.2f | G1 %s | %s' % (x['n'], x['pf'], x['dd'], x['profit'], x['msg'], 'n < 150: nessun verdetto di merito' if x['n'] < 150 else 'n >= 150')))
    ris = []; valido = True
    for w, (on, off, _) in WIN.items():
        a, b = R[on], R[off]
        if a is None or b is None or not (a['g1'] and b['g1']): valido = False; ris.append('%s: NON VALUTABILE' % w); continue
        c1 = a['pf'] - b['pf'] >= 0.10; c2 = a['dd'] <= 1.10 * b['dd']; c3 = b['n'] > 0 and a['n'] >= 0.40 * b['n']
        ris.append('%s: dPF %+.4f (>=0,10 %s) | DD %.2f vs %.2f (<=1,10x %s) | Trades %d/%d = %.2f (>=0,40 %s)' % (w, a['pf'] - b['pf'], c1, a['dd'], b['dd'], c2, a['n'], b['n'], a['n'] / b['n'] if b['n'] else 0, c3))
        valido = valido and c1 and c2 and c3
    out.append('FILTRO D\'INVERNO (acceso contro spento, in W1 E in W2): %s' % ('UTILE' if valido and all('NON VALUTABILE' not in r for r in ris) else 'NON DIMOSTRATO'))
    out += ['    ' + r for r in ris]
    return out
def pertrade(cart):
    out = []
    for nome, idx in (('ACCESO', 0), ('SPENTO', 1)):
        pos = collections.OrderedDict()
        for w, (_, _, mg) in WIN.items():
            p = os.path.join(cart, 'abtg_trades_ABTG_Nasdaq_Apertura_US_NASUSD_%s.csv' % mg[idx])
            if not os.path.exists(p): out.append('PERTRADE %s %s: MANCANTE' % (nome, w)); continue
            for r in csv.DictReader(open(p), delimiter=';'):
                k = (w, r['position_id']); pos.setdefault(k, 0.0); pos[k] += float(r['net_profit'])
        v = list(pos.values())
        if not v: continue
        g = sum(x for x in v if x > 0); l = -sum(x for x in v if x < 0)
        out.append('PERTRADE (ESPLORATIVO) W1+W2 %s: posizioni %d | netto %.0f | PF %.2f | vincenti %.0f%%' % (nome, len(v), sum(v), g / l if l else float('inf'), 100 * sum(x > 0 for x in v) / len(v)))
    return out
def autotest():
    d = tempfile.mkdtemp(); hdr = ['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades', 'InpMagic']
    for tag, v in {'R279a': (500, 1.40, 6.0, 60), 'R279b': (200, 1.05, 9.0, 120), 'R279c': (300, 1.30, 5.0, 50), 'R279d': (100, 1.00, 8.0, 100)}.items():
        os.makedirs(os.path.join(d, 'ROUND_' + tag))
        with open(os.path.join(d, 'ROUND_' + tag, 'ABTG_Nasdaq_Apertura_US_NASUSD_OOS_%s.csv' % tag), 'w', newline='') as f:
            c = csv.writer(f); c.writerow(hdr)
            for i in (1, 2): c.writerow([i - 1, v[0], v[1], v[2], v[3], i])
    t = '\n'.join(giudica(carica(d)))
    assert "FILTRO D'INVERNO (acceso contro spento, in W1 E in W2): UTILE" in t and 'n < 150' in t, t
    print('AUTOTEST OK'); return 0
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': sys.exit(autotest())
    if len(sys.argv) < 2: sys.exit(__doc__)
    print('\n'.join(giudica(carica(sys.argv[1]))))
    if len(sys.argv) > 2: print('\n'.join(pertrade(sys.argv[2])))
