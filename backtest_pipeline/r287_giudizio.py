#!/usr/bin/env python3
# =====================================================================
#  r287_giudizio.py -- LETTORE CONGELATO del round R287 (orologio dell'ORB: ora fissa contro ora solare US automatica)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r287_giudizio.py <cartella con ROUND_R287a, ROUND_R287b e PERTRADE> | --autotest
#  Layout: <cartella>/ROUND_R287x/ABTG_ORB_Emiliano_U30USD_(IS|OOS)_R287x.csv ; <cartella>/PERTRADE/abtg_trades_ABTG_ORB_Emiliano_U30USD_<magic g1>.csv (R287a 799951, R287b 799952)
#  CRITERI CONGELATI (anche nei file prova R287a-b):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001). G0: R287a = R283a (IS 7630,13/1,24678/8,2477/71; OOS 33442,57/1,67803/9,9897/119, tolleranza 1,01/0,0002/0,0001/uguali):
#   se fallisce NESSUN altro numero si legge. S1: fuori dall'inverno US (chiusure fuori da 2025-11-03..2026-03-06) le posizioni dei due bracci sono IDENTICHE (stessa data, |diff netto| <= 0,02), altrimenti NON LEGGIBILE.
#   LETTURA SEMPRE DESCRITTIVA (posizioni invernali OOS << 150): posizioni, netto, PF invernali per braccio; differenza di netto (b - a) CON e SENZA gen-feb 2026; direzione "b migliore" solo se > 0 in entrambe.
# =====================================================================
import csv, os, sys, tempfile, collections
EA = 'ABTG_ORB_Emiliano'; SYM = 'U30USD'
REF = {'IS': (7630.13, 1.24678, 8.2477, 71), 'OOS': (33442.57, 1.67803, 9.9897, 119)}
W0, W1 = '2025.11.03', '2026.03.06'; GF0, GF1 = '2026.01.01', '2026.02.28'
MAG = {'R287a': '799951', 'R287b': '799952'}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
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
def posizioni(path):
    pos = collections.OrderedDict()
    with open(path, newline='') as f:
        for r in csv.DictReader(f, delimiter=';'):
            pos.setdefault(r['position_id'], []).append((r['close_time'][:10], float(r['net_profit'])))
    return sorted((max(d for d, _ in v), sum(x for _, x in v)) for v in pos.values())
def pf(L):
    w = sum(x for x in L if x > 0); l = -sum(x for x in L if x < 0)
    return (w / l) if l else None
def inverno(d): return W0 <= d <= W1
def giudica(R):
    es = {}
    for t in MAG:
        for leg in ('IS', 'OOS'):
            r = R[t][leg]
            if r is None: es['GUASTO ' + t + ' ' + leg] = 'MANCANTE'
            elif not r['g1']: es['GUASTO ' + t + ' ' + leg] = 'gemelle DIVERSE (G1)'
            elif r['n'] <= 0: es['GUASTO ' + t + ' ' + leg] = 'zero operazioni'
    if any(k.startswith('GUASTO') for k in es): es['ESITO'] = 'NON LEGGIBILE (guasto)'; return es
    ok = all(abs(R['R287a'][l]['profit'] - REF[l][0]) <= 1.01 and abs(R['R287a'][l]['pf'] - REF[l][1]) <= 0.0002 and abs(R['R287a'][l]['dd'] - REF[l][2]) <= 0.0001 + 1e-9 and R['R287a'][l]['n'] == REF[l][3] for l in ('IS', 'OOS'))
    es['G0 R287a = R283a'] = 'IDENTICO' if ok else 'DIVERSO'
    if not ok: es['ESITO'] = 'NON LEGGIBILE (G0 fallito: la v1.01 non e identica alla cella viva)'; return es
    a, b = R['R287a'], R['R287b']
    for l in ('IS', 'OOS'):
        es['dPF %s (b - a)' % l] = '%+.3f (a %.3f, b %.3f; operazioni a %d, b %d; netto a %.0f, b %.0f)' % (b[l]['pf'] - a[l]['pf'], a[l]['pf'], b[l]['pf'], a[l]['n'], b[l]['n'], a[l]['profit'], b[l]['profit'])
    if a['pt'] is None or b['pt'] is None: es['ESITO'] = 'per-trade MANCANTE: solo i numeri aggregati sopra'; return es
    fa = [(d, x) for d, x in a['pt'] if not inverno(d)]; fb = [(d, x) for d, x in b['pt'] if not inverno(d)]
    s1 = len(fa) == len(fb) and all(da == db and abs(xa - xb) <= 0.02 for (da, xa), (db, xb) in zip(fa, fb))
    es['S1 fuori inverno identiche'] = ('SI (%d posizioni)' % len(fa)) if s1 else 'NO (a %d, b %d posizioni fuori inverno)' % (len(fa), len(fb))
    if not s1: es['ESITO'] = 'NON LEGGIBILE (S1 fallito)'; return es
    wa = [(d, x) for d, x in a['pt'] if inverno(d)]; wb = [(d, x) for d, x in b['pt'] if inverno(d)]
    def netto(L, escl=False): return sum(x for d, x in L if not (escl and GF0 <= d <= GF1))
    da_ = {d: x for d, x in wa}; db_ = {d: x for d, x in wb}
    giorni = sorted(set(da_) | set(db_))
    migl = sum(1 for d in giorni if db_.get(d, 0.0) > da_.get(d, 0.0)); peg = sum(1 for d in giorni if db_.get(d, 0.0) < da_.get(d, 0.0))
    es['inverno OOS posizioni'] = 'a %d (netto %.0f, PF %s), b %d (netto %.0f, PF %s)' % (len(wa), netto(wa), ('%.3f' % pf([x for _, x in wa]) if pf([x for _, x in wa]) else 'n/d'), len(wb), netto(wb), ('%.3f' % pf([x for _, x in wb]) if pf([x for _, x in wb]) else 'n/d'))
    dn = netto(wb) - netto(wa); dne = netto(wb, True) - netto(wa, True)
    es['differenza di netto (b - a)'] = 'CON gen-feb %+.0f; SENZA gen-feb 2026 %+.0f' % (dn, dne)
    es['giorni d\'inverno'] = '%d con posizione in almeno un braccio: b batte a in %d, a batte b in %d, pari %d' % (len(giorni), migl, peg, len(giorni) - migl - peg)
    d = 'b (ora solare automatica) MIGLIORE in entrambe le viste' if (dn > 0 and dne > 0) else ('a (ora fissa) MIGLIORE in entrambe le viste' if (dn < 0 and dne < 0) else 'DIREZIONE NON CONCORDE fra le due viste')
    es['ESITO'] = 'DESCRITTIVO (posizioni invernali %d << 150): %s. Nessun verdetto di merito.' % (max(len(wa), len(wb)), d)
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
    def pt(t, righe):
        with open(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (EA, SYM, MAG[t])), 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit'.split(';'))
            for i, (dt, x) in enumerate(righe): w.writerow([dt + ' 15:30:00', SYM, 0, i + 1, 1, 1, 1, x])
    def base(rows_a, rows_b):
        for l in ('IS', 'OOS'):
            agg('R287a', l, REF[l]); agg('R287b', l, (REF[l][0] + 10, REF[l][1] + 0.01, REF[l][2], REF[l][3]))
        pt('R287a', rows_a); pt('R287b', rows_b)
    fuori = [('2025.07.01', 100.0), ('2025.08.01', -50.0)]
    base(fuori + [('2025.12.01', 100.0), ('2026.01.15', 200.0)], fuori + [('2025.12.01', 300.0), ('2026.01.15', 300.0)])
    es = giudica(carica(d)); assert 'b (ora solare automatica) MIGLIORE' in es['ESITO'] and es['S1 fuori inverno identiche'].startswith('SI'), es
    base(fuori + [('2025.12.01', 100.0), ('2026.01.15', 200.0)], fuori + [('2025.12.01', 50.0), ('2026.01.15', 500.0)])
    es = giudica(carica(d)); assert 'NON CONCORDE' in es['ESITO'] and 'CON gen-feb +250; SENZA gen-feb 2026 -50' in es['differenza di netto (b - a)'], es
    base(fuori + [('2025.12.01', 300.0), ('2026.01.15', 200.0)], fuori + [('2025.12.01', 100.0), ('2026.01.15', 100.0)])
    es = giudica(carica(d)); assert 'a (ora fissa) MIGLIORE' in es['ESITO'], es
    base(fuori + [('2025.12.01', 100.0)], fuori[:1] + [('2025.12.01', 100.0)])
    es = giudica(carica(d)); assert es['ESITO'].startswith('NON LEGGIBILE (S1'), es
    for l in ('IS', 'OOS'): agg('R287a', l, (REF[l][0] + 5, REF[l][1], REF[l][2], REF[l][3]))
    es = giudica(carica(d)); assert es['ESITO'].startswith('NON LEGGIBILE (G0'), es
    base(fuori, fuori); agg('R287b', 'OOS', REF['OOS'], dd2=REF['OOS'][2] + 0.001)
    es = giudica(carica(d)); assert es['ESITO'].startswith('NON LEGGIBILE (guasto'), es
    print('AUTOTEST R287: 6 casi OK (b migliore, direzione non concorde, a migliore, S1 fallito, G0 fallito, G1 fallito)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    R = carica(sys.argv[1]); print('\n'.join(riporta(R))); print()
    for k, v in giudica(R).items(): print('%s: %s' % (k, v))
    print('\nNon promuove niente. Un inverno nell\'OOS. Un solo regime.')
