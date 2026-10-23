#!/usr/bin/env python3
# =====================================================================
#  r286_giudizio.py -- LETTORE CONGELATO del round R286 (sedia 770250: gate EMA acceso contro spento)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r286_giudizio.py <cartella con ROUND_R286a e ROUND_R286b> | --autotest
#  Layout: <cartella>/ROUND_R286x/ABTG_Nasdaq_Apertura_US_NASUSD_(IS|OOS)_R286x.csv (due righe = le due gemelle)
#  CRITERI CONGELATI (anche nei file prova R286a-b):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001). IMPIANTO: Trades > 0 in IS e OOS in entrambi i bracci.
#   dPF = PF(senza gate, R286b) - PF(con gate, R286a), per IS e OOS. >= +0,10 in entrambe: il gate PEGGIORA; <= -0,10 in entrambe: il gate AIUTA; altrimenti NON DISTINGUIBILE o MISTO.
#   MISURATO: il verdetto vale solo se ENTRAMBI i bracci hanno >= 100 operazioni (deal) in OGNI gamba; sotto: DESCRITTIVO (numeri, nessun verdetto).
#   COERENZA con la misura storica (NON bloccante): operazioni IS+OOS del braccio con gate entro +-25% di 104.
# =====================================================================
import csv, os, sys, tempfile
EA = 'ABTG_Nasdaq_Apertura_US'; SYM = 'NASUSD'; SOGLIA = 0.10; MIN_OP = 100; STORICO_N = 104
TAGS = ['R286a', 'R286b']
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def carica(cart):
    R = {}
    for t in TAGS:
        R[t] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + t, '%s_%s_%s_%s.csv' % (EA, SYM, leg, t))
            if not os.path.exists(p): R[t][leg] = None; continue
            rows = leggi(p); R[t][leg] = dict(g1=g1(rows), **rows[0]) if rows else None
    return R
def giudica(R):
    es = {}
    for t in TAGS:
        for leg in ('IS', 'OOS'):
            r = R[t][leg]
            if r is None: es['GUASTO ' + t + ' ' + leg] = 'MANCANTE'
            elif not r['g1']: es['GUASTO ' + t + ' ' + leg] = 'gemelle DIVERSE (G1)'
            elif r['n'] <= 0: es['GUASTO ' + t + ' ' + leg] = 'zero operazioni (impianto)'
    if any(k.startswith('GUASTO') for k in es): es['VERDETTO'] = 'NON LEGGIBILE (guasto)'; return es
    a, b = R['R286a'], R['R286b']
    nOn = a['IS']['n'] + a['OOS']['n']
    es['COERENZA storica (non bloccante)'] = 'operazioni con gate IS+OOS = %d contro 104 storiche (%+.0f%%): %s' % (nOn, 100.0 * (nOn - STORICO_N) / STORICO_N, 'ENTRO +-25%' if abs(nOn - STORICO_N) <= 0.25 * STORICO_N else 'FUORI +-25%: non riproduce la misura del 30/08')
    di = b['IS']['pf'] - a['IS']['pf']; do = b['OOS']['pf'] - a['OOS']['pf']
    es['dPF (senza - con gate)'] = 'IS %+.3f, OOS %+.3f' % (di, do)
    es['operazioni'] = 'con gate IS %d / OOS %d; senza gate IS %d / OOS %d' % (a['IS']['n'], a['OOS']['n'], b['IS']['n'], b['OOS']['n'])
    minimo = min(a['IS']['n'], a['OOS']['n'], b['IS']['n'], b['OOS']['n'])
    if minimo < MIN_OP: es['VERDETTO'] = 'DESCRITTIVO: almeno una gamba con meno di %d operazioni (minimo %d): si riportano i numeri, nessun verdetto' % (MIN_OP, minimo); return es
    if di >= SOGLIA and do >= SOGLIA: es['VERDETTO'] = 'il gate PEGGIORA (senza gate il PF sale in entrambe le gambe)'
    elif di <= -SOGLIA and do <= -SOGLIA: es['VERDETTO'] = 'il gate AIUTA (senza gate il PF scende in entrambe le gambe)'
    else: es['VERDETTO'] = 'NON DISTINGUIBILE o MISTO (nessuna conclusione)'
    return es
def riporta(R):
    out = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for t in TAGS:
        for leg in ('IS', 'OOS'):
            r = R[t][leg]; out.append('%-6s %-4s ' % (t, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return out
def autotest():
    d = tempfile.mkdtemp()
    def scrivi(t, leg, riga, dd2=None):
        p = os.path.join(d, 'ROUND_' + t); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (EA, SYM, leg, t)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades'])
            w.writerow([0] + list(riga)); r2 = list(riga)
            if dd2 is not None: r2[2] = dd2
            w.writerow([1] + r2)
    def tutto(pf_on, pf_off, n_on, n_off):
        for leg in ('IS', 'OOS'):
            scrivi('R286a', leg, (100.0, pf_on, 5.0, n_on)); scrivi('R286b', leg, (100.0, pf_off, 5.0, n_off))
    tutto(1.3, 1.1, 60, 300); es = giudica(carica(d)); assert es['VERDETTO'].startswith('DESCRITTIVO'), es
    tutto(1.3, 1.1, 120, 300); es = giudica(carica(d)); assert 'AIUTA' in es['VERDETTO'], es
    tutto(1.1, 1.3, 120, 300); es = giudica(carica(d)); assert 'PEGGIORA' in es['VERDETTO'], es
    tutto(1.2, 1.25, 120, 300); es = giudica(carica(d)); assert 'NON DISTINGUIBILE' in es['VERDETTO'], es
    tutto(1.3, 1.1, 52, 300); es = giudica(carica(d)); assert 'ENTRO' in es['COERENZA storica (non bloccante)'], es      # 104 in tutto
    tutto(1.3, 1.1, 120, 300); scrivi('R286b', 'OOS', (100.0, 1.1, 5.0, 300), dd2=5.001); es = giudica(carica(d)); assert es['VERDETTO'].startswith('NON LEGGIBILE'), es
    scrivi('R286b', 'OOS', (100.0, 1.1, 5.0, 300), dd2=5.0001); es = giudica(carica(d)); assert not es['VERDETTO'].startswith('NON LEGGIBILE'), es
    print('AUTOTEST R286: 7 casi OK (descrittivo, aiuta, peggiora, non distinguibile, coerenza, G1 fallito, DD 0,0001 tollerato)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1]); print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Un solo regime (toro). Soglia 0,10 arbitraria, non calibrata sul rumore.')
