#!/usr/bin/env python3
# =====================================================================
#  r292_giudizio.py -- LETTORE CONGELATO del round R292 (MaxMinNotte ORO, variante a ticket, difetto C9)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip. USO: python3 backtest_pipeline/r292_giudizio.py <cartella con ROUND_R292a..e> | --autotest
#  Layout: <cartella>/ROUND_R292x/<EA>_XAUUSD_(IS|OOS)_R292x.csv (due righe = le due gemelle);
#          per-trade: file abtg_trades_<EA>_XAUUSD_<magic>.csv cercato ricorsivamente sotto <cartella> (magic g1: 800041..800045).
#  CRITERI CONGELATI (anche nei file prova R292a-e):
#   G1 gemelle identiche (Profit <= 1 EUR, PF <= 0,0002, Trades uguali, DD% <= 0,0001).
#   G0 b = a e c = a AL CENTESIMO, IS e OOS (1,01 / 0,0002 / 0,0001 / Trades uguali).
#   TARDIVA: chiusura con ora server > 17:30:30 o < 07:00:00; si contano le POSIZIONI proprie (magic proprio, non 999777).
#   VICINO PRESENTE: >= 100 chiusure del magic 999777 in d ed e; zero in a, b, c.
#   DIFETTO RIPRODOTTO: tardive(d) >= 5 E tardive(d) >= tardive(c) + 5.
#   RIMEDIO: tardive(e) <= tardive(c) E >= 95% delle chiusure proprie di c con una chiusura di e allo STESSO secondo (multiinsieme).
#   < 100 chiusure proprie in c (gamba OOS) => DESCRITTIVO. Nessun p-value.
# =====================================================================
import csv, os, sys, glob, tempfile
from collections import Counter
EA = {'a': 'ABTG_MaxMinNotte', 'b': 'ABTG_MaxMinNotte_Ticket', 'c': 'ABTG_MaxMinNotte_Ticket', 'd': 'ABTG_MaxMinNotte_Ticket', 'e': 'ABTG_MaxMinNotte_Ticket'}
MAG = {'a': 800041, 'b': 800042, 'c': 800043, 'd': 800044, 'e': 800045}
SYM = 'XAUUSD'; VIC = '999777'
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def uguali(x, y):
    return abs(x['profit'] - y['profit']) <= 1.01 and abs(x['pf'] - y['pf']) <= 0.0002 and abs(x['dd'] - y['dd']) <= 0.0001 + 1e-9 and x['n'] == y['n']
def carica(cart):
    R = {}
    for t in 'abcde':
        tag = 'R292' + t; r = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (EA[t], SYM, leg, tag))
            r[leg] = leggi(p) if os.path.exists(p) else None
        R[t] = r
    return R
def pertrade(cart, t):
    fn = 'abtg_trades_%s_%s_%d.csv' % (EA[t], SYM, MAG[t])
    ps = glob.glob(os.path.join(cart, '**', fn), recursive=True)
    if not ps: return None
    own = []; vic = 0
    with open(ps[0], newline='') as f:
        for r in csv.DictReader(f, delimiter=';'):
            if r['magic'] == VIC: vic += 1; continue
            if r['magic'] != str(MAG[t]): continue
            own.append((r['close_time'], r['position_id']))
    return own, vic
def tardiva(ct):
    hms = ct.split(' ')[1]
    return hms > '17:30:30' or hms < '07:00:00'
def tardive_pos(own): return len({pid for ct, pid in own if tardiva(ct)})
def giudica(cart):
    R = carica(cart); es = {}; ok = True
    for t in 'abcde':
        r = R[t]
        if r['IS'] is None or r['OOS'] is None: es['G1 ' + t] = 'MANCANTE'; ok = False; continue
        es['G1 ' + t] = 'OK' if g1(r['IS']) and g1(r['OOS']) else 'GUASTO: gemelle DIVERSE'
        if es['G1 ' + t] != 'OK': ok = False
    if not ok: es['ESITO'] = 'GUASTO O MANCANTE: round non leggibile'; return es
    for t in 'bc':
        g = all(uguali(R[t][l][0], R['a'][l][0]) for l in ('IS', 'OOS'))
        es['G0 %s = a' % t] = ('IDENTICO al centesimo' if g else 'DIVERSO: la variante cambia le decisioni, NON SI USA') + ' (IS %.2f/%.5f/%d, OOS %.2f/%.5f/%d)' % (R[t]['IS'][0]['profit'], R[t]['IS'][0]['pf'], R[t]['IS'][0]['n'], R[t]['OOS'][0]['profit'], R[t]['OOS'][0]['pf'], R[t]['OOS'][0]['n'])
        if not g: ok = False
    P = {t: pertrade(cart, t) for t in 'abcde'}
    for t in 'abcde':
        if P[t] is None: es['per-trade ' + t] = 'MANCANTE'
        else: es['per-trade ' + t] = '%d chiusure proprie, %d posizioni tardive, %d chiusure del vicino' % (len(P[t][0]), tardive_pos(P[t][0]), P[t][1])
    if any(P[t] is None for t in 'abcde'):
        es['ESITO'] = 'G0 ' + ('OK' if ok else 'FALLITO') + '; PER-TRADE MANCANTE: difetto e rimedio NON MISURATI'; return es
    vic_ok = P['d'][1] >= 100 and P['e'][1] >= 100 and P['a'][1] == P['b'][1] == P['c'][1] == 0
    es['VICINO PRESENTE (>=100 in d/e, 0 in a/b/c)'] = 'SI' if vic_ok else 'NO'
    n_c = len(P['c'][0]); tc = tardive_pos(P['c'][0]); td = tardive_pos(P['d'][0]); te = tardive_pos(P['e'][0])
    bug = td >= 5 and td >= tc + 5
    es['DIFETTO RIPRODOTTO (tardive d=%d, c=%d)' % (td, tc)] = 'SI' if bug else 'NO: il test non ha misurato il difetto'
    cc = Counter(ct for ct, _ in P['c'][0]); ce = Counter(ct for ct, _ in P['e'][0])
    comuni = sum((cc & ce).values()); frac = comuni / n_c if n_c else 0.0
    fix = te <= tc and frac >= 0.95
    es['RIMEDIO (tardive e=%d <= c=%d; stesso secondo %.1f%%)' % (te, tc, 100 * frac)] = 'SI' if fix else 'NO'
    if n_c < 100: es['campione'] = 'DESCRITTIVO: %d chiusure proprie in c (< 100)' % n_c
    if not ok: es['ESITO'] = 'G0 FALLITO: la variante cambia le decisioni a flag spento/acceso. NON SI USA.'
    elif not vic_ok: es['ESITO'] = 'G0 OK ma il vicino non c\'e\' (o c\'e\' dove non deve): test NON VALIDO'
    elif not bug: es['ESITO'] = 'G0 OK; difetto NON riprodotto: variante NE\' PROVATA NE\' SMENTITA'
    elif fix: es['ESITO'] = 'G0 OK; difetto RIPRODOTTO in d; RIMEDIO riuscito in e' + (' (DESCRITTIVO)' if n_c < 100 else '')
    else: es['ESITO'] = 'G0 OK; difetto riprodotto; il RIMEDIO NON riesce in e'
    return es
def autotest():
    d = tempfile.mkdtemp()
    REF = {'IS': (1000.0, 1.3, 2.0, 100), 'OOS': (2000.0, 1.4, 3.0, 120)}
    def csvs(t, shift=0.0):
        p = os.path.join(d, 'ROUND_R292' + t); os.makedirs(p, exist_ok=True)
        for l in ('IS', 'OOS'):
            with open(os.path.join(p, '%s_%s_%s_R292%s.csv' % (EA[t], SYM, l, t)), 'w', newline='') as f:
                w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades'])
                r = REF[l]; w.writerow([0, r[0] + shift, r[1], r[2], r[3]]); w.writerow([1, r[0] + shift, r[1], r[2], r[3]])
    def pt(t, tarde, vicini, giorni=120, alter=0):
        os.makedirs(os.path.join(d, 'PERTRADE'), exist_ok=True)
        with open(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA[t], SYM, MAG[t])), 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow(['close_time', 'symbol', 'magic', 'position_id', 'deal_type', 'volume', 'price', 'net_profit'])
            for i in range(giorni):
                hms = '19:48:05' if i < tarde else '17:30:%02d' % (i % 20)
                if i < alter: hms = '12:%02d:00' % (i % 60)
                w.writerow(['2025.%02d.%02d %s' % (1 + i // 28, 1 + i % 28, hms), SYM, MAG[t], i + 1, 1, '0.01', 2000, 1.0])
            for i in range(vicini): w.writerow(['2025.01.01 20:00:00', SYM, VIC, 5000 + i, 1, '0.01', 2000, 1.0])
    for t in 'abcde': csvs(t)
    for t in 'abc': pt(t, 0, 0)
    pt('d', 12, 150); pt('e', 0, 150)
    es = giudica(d); assert es['ESITO'].startswith('G0 OK; difetto RIPRODOTTO') and 'RIMEDIO riuscito' in es['ESITO'], es
    pt('d', 2, 150); es = giudica(d); assert 'NE\' PROVATA' in es['ESITO'], es
    pt('d', 12, 150); pt('e', 6, 150); es = giudica(d); assert 'NON riesce' in es['ESITO'], es
    pt('e', 0, 150, alter=20); es = giudica(d); assert 'NON riesce' in es['ESITO'], es
    pt('e', 0, 20); es = giudica(d); assert 'non c\'e\'' in es['ESITO'], es
    pt('e', 0, 150); csvs('c', shift=3.0); es = giudica(d); assert 'FALLITO' in es['ESITO'], es
    csvs('c'); csvs('d', shift=0.0); pt('c', 0, 0, giorni=60); pt('e', 0, 150, giorni=60); pt('d', 12, 150, giorni=60); es = giudica(d); assert 'DESCRITTIVO' in es['ESITO'], es
    os.remove(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (EA['e'], SYM, MAG['e']))); es = giudica(d); assert 'MANCANTE' in es['ESITO'], es
    print('AUTOTEST R292: 8 casi OK (riuscito, non riprodotto, rimedio fallito x2, vicino assente, G0 fallito, descrittivo, per-trade mancante)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    es = giudica(sys.argv[1])
    for k, v in es.items(): print('%-60s %s' % (k, v))
