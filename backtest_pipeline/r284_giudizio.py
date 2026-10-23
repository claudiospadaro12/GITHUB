#!/usr/bin/env python3
# =====================================================================
#  r284_giudizio.py -- LETTORE CONGELATO del round R284 (bracci di controllo di ABTG_ORB_Emiliano v1.00)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r284_giudizio.py <cartella con ROUND_R284a..e> | --autotest
#  Layout: <cartella>/ROUND_R284x/ABTG_ORB_Emiliano_<SIMBOLO>_(IS|OOS)_R284x.csv (due righe = le due gemelle)
#  CRITERI CONGELATI:
#   G1  le due gemelle di ogni file identiche (Profit <= 1 EUR, PF <= 0,0002, Trades e DD% esatti). Se fallisce per un round, quel round NON si legge.
#   IMPIANTO  rc non 1, _OOS con 2 righe, Trades > 0 in IS e OOS.
#   MISURATO  una gamba con meno di 100 operazioni (deal) e' NON MISURATA: nessun verdetto su quel braccio.
#   RIFERIMENTO = numeri di R283c (Nasdaq) e R283d (Dow), stesso EA (SHA256 9F5C82BB...), stessa finestra, congelati qui sotto.
#   VERDETTO per braccio (soglia 0,10 di PF in ENTRAMBE le gambe, stesso segno; soglia NON calibrata sul rumore, dichiarata arbitraria):
#     dPF = PF(braccio) - PF(riferimento), per IS e per OOS.
#     dPF <= -0,10 in IS e OOS -> LA NOVITA' AIUTA (togliendola peggiora in entrambe)
#     dPF >= +0,10 in IS e OOS -> LA NOVITA' PEGGIORA (togliendola migliora in entrambe)
#     altrimenti -> NON DISTINGUIBILE o MISTO (gambe in disaccordo): niente conclusione.
#   Non promuove niente, non giudica la regola di Emiliano; un solo regime (2024-26, toro).
# =====================================================================
import csv, os, sys, tempfile
REF = {  # (profit, pf, dd, trades) congelati da R283c/R283d
    'c': {'IS': (8930.99, 1.18637, 11.1918, 145), 'OOS': (12253.46, 1.14734, 17.2022, 236)},
    'd': {'IS': (-14277.30, 0.77711, 23.8709, 249), 'OOS': (11943.95, 1.10989, 16.0321, 406)},
}
ROUNDS = {  # tag: (simbolo, riferimento, novita' tolta)
    'R284a': ('NASUSD', 'c', 'Piano A'),
    'R284b': ('NASUSD', 'c', 'filtro ampiezza 17-38'),
    'R284c': ('NASUSD', 'c', 'range senza la barra 14:30'),
    'R284d': ('U30USD', 'd', 'Piano A'),
    'R284e': ('U30USD', 'd', 'range senza la barra 14:30'),
}
EA = 'ABTG_ORB_Emiliano'
SOGLIA = 0.10; MIN_OP = 100
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
    for tag, (sym, ref, nov) in ROUNDS.items():
        R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (EA, sym, leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p)
            R[tag][leg] = dict(g1=g1(rows), nrows=len(rows), **rows[0]) if rows else None
    return R
def giudica(R):
    righe = []; esiti = {}
    for tag, (sym, ref, nov) in ROUNDS.items():
        a, b = R[tag]['IS'], R[tag]['OOS']
        if a is None or b is None: esiti[tag] = 'GUASTO: dati mancanti'; continue
        if not (a['g1'] and b['g1']): esiti[tag] = 'GUASTO: gemelle DIVERSE (G1)'; continue
        if a['n'] <= 0 or b['n'] <= 0: esiti[tag] = 'GUASTO: zero operazioni (impianto)'; continue
        if a['n'] < MIN_OP or b['n'] < MIN_OP: esiti[tag] = 'NON MISURATO: meno di %d operazioni in una gamba (IS %d, OOS %d)' % (MIN_OP, a['n'], b['n']); continue
        dis = a['pf'] - REF[ref]['IS'][1]; doo = b['pf'] - REF[ref]['OOS'][1]
        if dis <= -SOGLIA and doo <= -SOGLIA: v = "LA NOVITA' AIUTA (togliendola il PF scende in entrambe le gambe)"
        elif dis >= SOGLIA and doo >= SOGLIA: v = "LA NOVITA' PEGGIORA (togliendola il PF sale in entrambe le gambe)"
        else: v = 'NON DISTINGUIBILE o MISTO (nessuna conclusione)'
        esiti[tag] = 'tolto %s: dPF IS %+.3f, dPF OOS %+.3f -> %s' % (nov, dis, doo, v)
    return esiti
def riporta(R):
    out = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for ref in ('c', 'd'):
        for leg in ('IS', 'OOS'):
            r = REF[ref][leg]; out.append('ref-%s %-4s %12.2f %9.5f %8.4f %7d   (R283%s)' % (ref, leg, r[0], r[1], r[2], r[3], ref))
    for tag in ROUNDS:
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]
            out.append('%-6s %-4s ' % (tag, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return out
def autotest():
    d = tempfile.mkdtemp()
    def scrivi(tag, leg, righe):
        sym = ROUNDS[tag][0]
        p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (EA, sym, leg, tag)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades'])
            for i, r in enumerate(righe): w.writerow([i] + list(r))
    def tutto(pfIS, pfOOS, n=150):
        for t in ROUNDS:
            scrivi(t, 'IS', [(1.0, pfIS, 5.0, n)] * 2); scrivi(t, 'OOS', [(1.0, pfOOS, 5.0, n)] * 2)
    tutto(1.18637 - 0.20, 1.14734 - 0.20)   # per il Nasdaq: sotto in entrambe -> AIUTA
    es = giudica(carica(d)); assert 'AIUTA' in es['R284a'], es
    tutto(1.18637 + 0.20, 1.14734 + 0.20); es = giudica(carica(d)); assert 'PEGGIORA' in es['R284a'], es
    tutto(1.18637 + 0.20, 1.14734 - 0.20); es = giudica(carica(d)); assert 'MISTO' in es['R284a'], es          # gambe in disaccordo
    tutto(1.18637 + 0.05, 1.14734 + 0.05); es = giudica(carica(d)); assert 'NON DISTINGUIBILE' in es['R284a'], es   # sotto soglia
    tutto(1.18637, 1.14734, n=80); es = giudica(carica(d)); assert es['R284a'].startswith('NON MISURATO'), es
    tutto(1.18637, 1.14734); scrivi('R284b', 'OOS', [(1.0, 1.1, 5.0, 150), (9.0, 1.1, 5.0, 150)]); es = giudica(carica(d)); assert 'G1' in es['R284b'], es
    print('AUTOTEST R284: 6 casi OK (aiuta, peggiora, misto, sotto soglia, meno di 100 operazioni, gemelle diverse)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1])
    print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Un solo regime. Soglia 0,10 arbitraria, non calibrata sul rumore.')
