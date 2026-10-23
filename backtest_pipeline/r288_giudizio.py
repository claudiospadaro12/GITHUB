#!/usr/bin/env python3
# =====================================================================
#  r288_giudizio.py -- LETTORE CONGELATO del round R288 (gestione a pezzi del DAX Apertura 770101)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r288_giudizio.py <cartella con ROUND_R288a..d e PERTRADE> | --autotest
#  Layout: <cartella>/ROUND_R288x/ABTG_DAX_Apertura_EU_D30EUR_(IS|OOS)_R288x.csv ; PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_<magic g1>.csv (800011..800014)
#  CRITERI CONGELATI (anche nei file prova R288a-d):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001). G0: R288a = R47a/R270c (IS 175/3789,36/1,12634/5,4362; OOS 270/18029,58/1,39709/7,2328; tolleranza 1,01/0,0002/0,0001/uguali):
#   se fallisce NESSUN altro numero si legge. dPF = PF(braccio) - PF(R288a), IS e OOS: <= -0,10 in entrambe il pezzo AIUTA; >= +0,10 in entrambe PEGGIORA; altrimenti NON DISTINGUIBILE o MISTO.
#   MISURATO: verdetto solo se braccio e cella viva hanno >= 100 operazioni (deal) in ogni gamba; altrimenti DESCRITTIVO. CONCENTRAZIONE (descrittiva): PF OOS senza le 5 e senza le 10 posizioni migliori.
# =====================================================================
import csv, os, sys, tempfile, collections
EA = 'ABTG_DAX_Apertura_EU'; SYM = 'D30EUR'; SOGLIA = 0.10; MIN_OP = 100
REF = {'IS': (3789.36, 1.12634, 5.4362, 175), 'OOS': (18029.58, 1.39709, 7.2328, 270)}
MAG = {'R288a': '800011', 'R288b': '800012', 'R288c': '800013', 'R288d': '800014'}
PEZZO = {'R288b': 'trailing', 'R288c': 'parziale (e pareggio, annidato)', 'R288d': 'pareggio'}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def posizioni(path):
    pos = collections.OrderedDict()
    with open(path, newline='') as f:
        for r in csv.DictReader(f, delimiter=';'): pos.setdefault(r['position_id'], []).append(float(r['net_profit']))
    return [sum(v) for v in pos.values()]
def pf(L):
    w = sum(x for x in L if x > 0); l = -sum(x for x in L if x < 0)
    return (w / l) if l else None
def carica(cart):
    R = {}
    for t in MAG:
        R[t] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + t, '%s_%s_%s_%s.csv' % (EA, SYM, leg, t))
            if not os.path.exists(p): R[t][leg] = None; continue
            rows = leggi(p); R[t][leg] = dict(g1=g1(rows), **rows[0]) if rows else None
        pt = os.path.join(cart, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SYM, MAG[t]))
        R[t]['pt'] = posizioni(pt) if os.path.exists(pt) else None
    return R
def conc(L):
    if not L: return 'n/d'
    s = sorted(L, reverse=True)
    def f(k):
        p = pf(s[k:]); return ('%.3f' % p) if p else 'n/d'
    return 'PF %s, senza le 5 migliori %s, senza le 10 migliori %s (%d posizioni)' % (('%.3f' % pf(L)) if pf(L) else 'n/d', f(5), f(10), len(L))
def giudica(R):
    es = {}
    for t in MAG:
        for leg in ('IS', 'OOS'):
            r = R[t][leg]
            if r is None: es['GUASTO ' + t + ' ' + leg] = 'MANCANTE'
            elif not r['g1']: es['GUASTO ' + t + ' ' + leg] = 'gemelle DIVERSE (G1)'
            elif r['n'] <= 0: es['GUASTO ' + t + ' ' + leg] = 'zero operazioni'
    if any(k.startswith('GUASTO') for k in es): es['ESITO'] = 'NON LEGGIBILE (guasto)'; return es
    a = R['R288a']
    ok = all(abs(a[l]['profit'] - REF[l][0]) <= 1.01 and abs(a[l]['pf'] - REF[l][1]) <= 0.0002 and abs(a[l]['dd'] - REF[l][2]) <= 0.0001 + 1e-9 and a[l]['n'] == REF[l][3] for l in ('IS', 'OOS'))
    es['G0 R288a = R47a'] = 'IDENTICO' if ok else 'DIVERSO'
    if not ok: es['ESITO'] = 'NON LEGGIBILE (G0 fallito: la cella viva non si riproduce)'; return es
    for t in ('R288b', 'R288c', 'R288d'):
        x = R[t]
        di = x['IS']['pf'] - a['IS']['pf']; do = x['OOS']['pf'] - a['OOS']['pf']
        minimo = min(x['IS']['n'], x['OOS']['n'], a['IS']['n'], a['OOS']['n'])
        if minimo < MIN_OP: v = 'DESCRITTIVO (meno di %d operazioni in una gamba, minimo %d)' % (MIN_OP, minimo)
        elif di <= -SOGLIA and do <= -SOGLIA: v = "il pezzo AIUTA (togliendolo il PF scende in entrambe le gambe)"
        elif di >= SOGLIA and do >= SOGLIA: v = "il pezzo PEGGIORA (togliendolo il PF sale in entrambe le gambe)"
        else: v = 'NON DISTINGUIBILE o MISTO (nessuna conclusione)'
        es[t] = 'tolto %s: dPF IS %+.3f, dPF OOS %+.3f (operazioni IS %d / OOS %d; DD OOS %.2f contro %.2f) -> %s' % (PEZZO[t], di, do, x['IS']['n'], x['OOS']['n'], x['OOS']['dd'], a['OOS']['dd'], v)
    for t in MAG:
        es['concentrazione OOS ' + t] = conc(R[t]['pt']) if R[t]['pt'] is not None else 'per-trade MANCANTE'
    return es
def riporta(R):
    out = ['%-6s %-4s %12s %9s %8s %7s' % ('round', 'leg', 'Profit', 'PF', 'DD%', 'Trades')]
    for t in MAG:
        for leg in ('IS', 'OOS'):
            r = R[t][leg]; out.append('%-6s %-4s ' % (t, leg) + ('MANCANTE' if r is None else '%12.2f %9.5f %8.4f %7d' % (r['profit'], r['pf'], r['dd'], r['n'])))
    return out
def autotest():
    d = tempfile.mkdtemp(); os.makedirs(os.path.join(d, 'PERTRADE'), exist_ok=True)
    def agg(t, leg, riga, dd2=None):
        p = os.path.join(d, 'ROUND_' + t); os.makedirs(p, exist_ok=True)
        with open(os.path.join(p, '%s_%s_%s_%s.csv' % (EA, SYM, leg, t)), 'w', newline='') as f:
            w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades']); w.writerow([0] + list(riga)); r2 = list(riga)
            if dd2 is not None: r2[2] = dd2
            w.writerow([1] + r2)
    def tutto(dpf_is, dpf_oos, n=150):
        for t in MAG:
            for l in ('IS', 'OOS'):
                if t == 'R288a': agg(t, l, REF[l])
                else: agg(t, l, (REF[l][0], REF[l][1] + (dpf_is if l == 'IS' else dpf_oos), REF[l][2], n))
    tutto(-0.2, -0.2); es = giudica(carica(d)); assert 'AIUTA' in es['R288b'], es
    tutto(0.2, 0.2); es = giudica(carica(d)); assert 'PEGGIORA' in es['R288c'], es
    tutto(0.2, -0.2); es = giudica(carica(d)); assert 'MISTO' in es['R288d'], es
    tutto(0.05, 0.05); es = giudica(carica(d)); assert 'NON DISTINGUIBILE' in es['R288b'], es
    tutto(0.2, 0.2, n=60); es = giudica(carica(d)); assert es['R288b'].split('->')[1].strip().startswith('DESCRITTIVO'), es
    agg('R288a', 'OOS', (REF['OOS'][0] + 5, REF['OOS'][1], REF['OOS'][2], REF['OOS'][3])); es = giudica(carica(d)); assert es['ESITO'].startswith('NON LEGGIBILE (G0'), es
    tutto(0.0, 0.0); agg('R288b', 'IS', (1, 1.1, 5.0, 150), dd2=5.001); es = giudica(carica(d)); assert es['ESITO'].startswith('NON LEGGIBILE (guasto'), es
    tutto(0.0, 0.0)
    with open(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SYM, MAG['R288a'])), 'w', newline='') as f:
        w = csv.writer(f, delimiter=';'); w.writerow('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit'.split(';'))
        for i in range(20): w.writerow(['2026.01.01 10:00:00', SYM, 0, i + 1, 1, 1, 1, 100.0 if i < 12 else -50.0])
    es = giudica(carica(d)); assert 'senza le 5 migliori' in es['concentrazione OOS R288a'] and '(20 posizioni)' in es['concentrazione OOS R288a'], es
    print('AUTOTEST R288: 8 casi OK (aiuta, peggiora, misto, sotto soglia, descrittivo, G0 fallito, G1 fallito, concentrazione)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1]); print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Un solo regime (toro). Soglia 0,10 arbitraria, non calibrata sul rumore.')
