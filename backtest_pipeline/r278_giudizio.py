#!/usr/bin/env python3
# =====================================================================
#  r278_giudizio.py -- LETTORE CONGELATO del round R278 (regola di Emiliano di 5 minuti sul DOW, U30USD)
#  Scritto il 22/10/2026 PRIMA di aprire lo zip, dai criteri dei file prova R278a-c (par. 1).
#  USO:  python3 backtest_pipeline/r278_giudizio.py <cartella con ROUND_R278a..c>      |   --autotest
#  Layout: <cartella>/ROUND_R278a|b|c/ABTG_Dow_Apertura_US_U30USD_(IS|OOS)_<tag>.csv  (2 righe per CSV: le due gemelle)
#  Non promuove niente. Con Trades < 150 non c'e' verdetto di merito.
# =====================================================================
import csv, os, sys, tempfile
TAGS = ('R278a', 'R278b', 'R278c')          # b = controllo, filtro SPENTO
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades'])), magic=r['InpMagic']) for r in rows]
def g1(rows):
    if len(rows) != 2: return False, 'righe %d invece di 2' % len(rows)
    a, b = rows
    ok = abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) < 1e-9
    return ok, ('gemelle identiche' if ok else 'GEMELLE DIVERSE: %r %r' % (a, b))
def carica(cart):
    R = {}
    for tag in TAGS:
        R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, 'ABTG_Dow_Apertura_US_U30USD_%s_%s.csv' % (leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p); ok, msg = g1(rows)
            R[tag][leg] = dict(g1=ok, msg=msg, pf=rows[0]['pf'], dd=rows[0]['dd'], n=rows[0]['n'], profit=rows[0]['profit'])
    return R
def giudica(R):
    out = []
    for tag in TAGS:
        for leg in ('IS', 'OOS'):
            x = R[tag][leg]
            out.append('%s %s: %s' % (tag, leg, 'MANCANTE' if x is None else 'n %d | PF %.4f | DD %.2f%% | Profit %.2f | G1 %s' % (x['n'], x['pf'], x['dd'], x['profit'], x['msg'])))
    for on in ('R278a', 'R278c'):
        ris = []; valido = True
        for leg in ('IS', 'OOS'):
            a, b = R[on][leg], R['R278b'][leg]
            if a is None or b is None or not (a['g1'] and b['g1']): valido = False; ris.append('%s: NON VALUTABILE (file mancante o G1 rotto)' % leg); continue
            c1 = a['pf'] - b['pf'] >= 0.10; c2 = a['dd'] <= 1.10 * b['dd']; c3 = b['n'] > 0 and a['n'] >= 0.40 * b['n']
            ris.append('%s: dPF %+.4f (>=0,10 %s) | DD %.2f vs %.2f (<=1,10x %s) | Trades %d/%d = %.2f (>=0,40 %s)' % (leg, a['pf'] - b['pf'], c1, a['dd'], b['dd'], c2, a['n'], b['n'], a['n'] / b['n'] if b['n'] else 0, c3))
            valido = valido and c1 and c2 and c3
        out.append('FILTRO %s contro R278b spento: %s' % (on, 'UTILE' if valido and all('NON VALUTABILE' not in r for r in ris) else 'NON DIMOSTRATO'))
        out += ['    ' + r for r in ris]
    for tag in TAGS:
        i, o = R[tag]['IS'], R[tag]['OOS']
        if i is None or o is None or not (i['g1'] and o['g1']): out.append('%s PASSA: NON VALUTABILE' % tag); continue
        passa = i['pf'] >= 1.10 and o['pf'] >= 1.10 and i['n'] >= 150 and o['n'] >= 150
        why = '' if min(i['n'], o['n']) >= 150 else ' (Trades IS %d / OOS %d: sotto 150, nessun verdetto di merito)' % (i['n'], o['n'])
        out.append('%s PASSA (PF >= 1,10 e n >= 150 in IS e OOS): %s%s | DD OOS %.2f%%' % (tag, 'SI' if passa else 'NO', why, o['dd']))
    return out
def autotest():
    d = tempfile.mkdtemp(); hdr = ['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades', 'InpMagic']
    def w(tag, leg, vals):
        os.makedirs(os.path.join(d, 'ROUND_' + tag), exist_ok=True)
        with open(os.path.join(d, 'ROUND_' + tag, 'ABTG_Dow_Apertura_US_U30USD_%s_%s.csv' % (leg, tag)), 'w', newline='') as f:
            c = csv.writer(f); c.writerow(hdr)
            for i, m in enumerate(('1', '2')): c.writerow([i, vals[0], vals[1], vals[2], vals[3], m])
    for tag, v in {'R278a': (500, 1.40, 6.0, 100), 'R278b': (200, 1.05, 9.0, 200), 'R278c': (800, 1.25, 8.0, 180)}.items():
        for leg in ('IS', 'OOS'): w(tag, leg, v)
    t = '\n'.join(giudica(carica(d)))
    assert 'FILTRO R278a contro R278b spento: UTILE' in t, t
    assert 'FILTRO R278c contro R278b spento: UTILE' in t, t
    assert 'R278a PASSA (PF >= 1,10 e n >= 150 in IS e OOS): NO (Trades IS 100' in t, t
    assert 'R278c PASSA (PF >= 1,10 e n >= 150 in IS e OOS): SI' in t, t
    print('AUTOTEST OK'); return 0
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': sys.exit(autotest())
    if len(sys.argv) < 2: sys.exit(__doc__)
    print('\n'.join(giudica(carica(sys.argv[1]))))
