#!/usr/bin/env python3
# =====================================================================
#  r285_giudizio.py -- LETTORE CONGELATO del round R285 (scomposizione del Piano A sul Dow, ABTG_ORB_Emiliano v1.01)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r285_giudizio.py <cartella con ROUND_R285a..e> | --autotest
#  Layout: <cartella>/ROUND_R285x/ABTG_ORB_Emiliano_U30USD_(IS|OOS)_R285x.csv (due righe = le due gemelle)
#  CRITERI CONGELATI:
#   G1   gemelle identiche: Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001. Se fallisce per un round, quel round NON si legge.
#   G0a  R285a = R283d (IS e OOS): Profit entro 1,01, PF entro 0,0002, DD entro 0,0001, Trades uguali.
#   G0b  R285e = R284d (IS e OOS): stessa tolleranza. Se G0a o G0b FALLISCE, NESSUN altro numero si legge (la v1.01 non e' identica per default).
#   MISURATO  una gamba con meno di 100 operazioni (deal) = NON MISURATO.
#   VERDETTO per b, c, d: dPF = PF(braccio) - PF(R285a), in IS e in OOS. <= -0,10 in ENTRAMBE: il pezzo AIUTA; >= +0,10 in entrambe: PEGGIORA;
#   altrimenti NON DISTINGUIBILE o MISTO (nessuna conclusione). Soglia 0,10 NON calibrata sul rumore, dichiarata arbitraria.
#   b = senza sospensione del trailing (HoldRunner=0), c = senza parziale (ClosePct=0), d = senza pareggio (BE=0).
#  Non promuove niente; un solo regime (2024-26, toro).
# =====================================================================
import csv, os, sys, tempfile
EA = 'ABTG_ORB_Emiliano'; SYM = 'U30USD'; SOGLIA = 0.10; MIN_OP = 100
REF283D = {'IS': (-14277.30, 0.77711, 23.8709, 249), 'OOS': (11943.95, 1.10989, 16.0321, 406)}
REF284D = {'IS': (-4751.44, 0.92087, 20.4085, 169), 'OOS': (26545.82, 1.19830, 18.6018, 264)}
TAGS = ['R285a', 'R285b', 'R285c', 'R285d', 'R285e']
PEZZO = {'R285b': 'sospensione del trailing', 'R285c': 'parziale', 'R285d': 'pareggio'}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def carica(cart):
    R = {}
    for tag in TAGS:
        R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (EA, SYM, leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p)
            R[tag][leg] = dict(g1=g1(rows), **rows[0]) if rows else None
    return R
def uguale(x, ref):
    return abs(x['profit'] - ref[0]) <= 1.01 and abs(x['pf'] - ref[1]) <= 0.0002 and abs(x['dd'] - ref[2]) <= 0.0001 + 1e-9 and x['n'] == ref[3]
def giudica(R):
    es = {}
    for tag in TAGS:
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]
            if r is None: es['G1 ' + tag + ' ' + leg] = 'MANCANTE'
            elif not r['g1']: es['G1 ' + tag + ' ' + leg] = 'gemelle DIVERSE'
    if any(k.startswith('G1') for k in es): es['ESITO'] = 'G1 FALLITO per alcuni round: quei round non si leggono'; 
    for nome, tag, ref in (('G0a R285a=R283d', 'R285a', REF283D), ('G0b R285e=R284d', 'R285e', REF284D)):
        ok = all(R[tag][l] is not None and uguale(R[tag][l], ref[l]) for l in ('IS', 'OOS'))
        es[nome] = 'IDENTICO' if ok else 'DIVERSO'
    if es['G0a R285a=R283d'] != 'IDENTICO' or es['G0b R285e=R284d'] != 'IDENTICO':
        es['VERDETTI'] = 'NON LEGGIBILI (G0 fallito: la v1.01 non e identica per default)'; return es
    a = R['R285a']
    for tag in ('R285b', 'R285c', 'R285d'):
        x = R[tag]
        if x['IS'] is None or x['OOS'] is None: es[tag] = 'GUASTO: dati mancanti'; continue
        if not (x['IS']['g1'] and x['OOS']['g1']): es[tag] = 'GUASTO: gemelle DIVERSE (G1)'; continue
        if x['IS']['n'] <= 0 or x['OOS']['n'] <= 0: es[tag] = 'GUASTO: zero operazioni'; continue
        if x['IS']['n'] < MIN_OP or x['OOS']['n'] < MIN_OP: es[tag] = 'NON MISURATO: meno di %d operazioni in una gamba (IS %d, OOS %d)' % (MIN_OP, x['IS']['n'], x['OOS']['n']); continue
        di = x['IS']['pf'] - a['IS']['pf']; do = x['OOS']['pf'] - a['OOS']['pf']
        if di <= -SOGLIA and do <= -SOGLIA: v = "il pezzo AIUTA (togliendolo il PF scende in entrambe le gambe)"
        elif di >= SOGLIA and do >= SOGLIA: v = "il pezzo PEGGIORA (togliendolo il PF sale in entrambe le gambe)"
        else: v = 'NON DISTINGUIBILE o MISTO (nessuna conclusione)'
        es[tag] = 'tolto %s: dPF IS %+.3f, dPF OOS %+.3f -> %s' % (PEZZO[tag], di, do, v)
    return es
def riporta(R):
    out = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for tag in TAGS:
        for leg in ('IS', 'OOS'):
            r = R[tag][leg]; out.append('%-6s %-4s ' % (tag, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return out
def autotest():
    d = tempfile.mkdtemp()
    def scrivi(tag, leg, riga, dd2=None):
        p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (EA, SYM, leg, tag)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades'])
            w.writerow([0] + list(riga)); r2 = list(riga)
            if dd2 is not None: r2[2] = dd2
            w.writerow([1] + r2)
    def base(dpf=(0.0, 0.0), n=150):
        for leg in ('IS', 'OOS'):
            scrivi('R285a', leg, REF283D[leg]); scrivi('R285e', leg, REF284D[leg])
            for t in ('R285b', 'R285c', 'R285d'):
                r = REF283D[leg]; scrivi(t, leg, (r[0], r[1] + dpf[0 if leg == 'IS' else 1], r[2], n))
    base((-0.2, -0.2)); es = giudica(carica(d)); assert 'AIUTA' in es['R285b'], es
    base((0.2, 0.2)); es = giudica(carica(d)); assert 'PEGGIORA' in es['R285b'], es
    base((0.2, -0.2)); es = giudica(carica(d)); assert 'MISTO' in es['R285b'], es
    base((0.05, 0.05)); es = giudica(carica(d)); assert 'NON DISTINGUIBILE' in es['R285b'], es
    base((0.2, 0.2), n=80); es = giudica(carica(d)); assert es['R285b'].startswith('NON MISURATO'), es
    base((0.2, 0.2)); scrivi('R285a', 'OOS', (REF283D['OOS'][0] + 5, REF283D['OOS'][1], REF283D['OOS'][2], REF283D['OOS'][3])); es = giudica(carica(d)); assert es['G0a R285a=R283d'] == 'DIVERSO' and es['VERDETTI'].startswith('NON LEGGIBILI'), es
    base((0.2, 0.2)); scrivi('R285b', 'OOS', (1.0, 1.1, 5.0, 150), dd2=5.0005); es = giudica(carica(d)); assert 'G1 R285b OOS' in es, es
    base((0.2, 0.2)); scrivi('R285b', 'OOS', (1.0, 1.1, 5.0, 150), dd2=5.0001); es = giudica(carica(d)); assert 'G1 R285b OOS' not in es, es   # DD 0,0001 tollerato
    print('AUTOTEST R285: 8 casi OK (aiuta, peggiora, misto, sotto soglia, <100 op., G0 fallito, G1 fallito, DD 0,0001 tollerato)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1]); print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Un solo regime. Soglia 0,10 arbitraria, non calibrata sul rumore.')
