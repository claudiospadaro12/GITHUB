#!/usr/bin/env python3
# =====================================================================
#  r293_giudizio.py -- LETTORE CONGELATO dei round R293 (rifacimento originale MaxMin oro), R294 (EMA200_Ott 971501 su AUDCHF e oro)
#  e R295 (deposito 5400 contro 100000 su EasyTrend, PTE, BreakingBand). Scritto il 23/10/2026 PRIMA di aprire lo zip.
#  USO: python3 backtest_pipeline/r293_giudizio.py <cartella con ROUND_R293a, ROUND_R294a-b, ROUND_R295a-j e RIEPILOGO_R293.txt> | --autotest
#  Layout: <cartella>/ROUND_<tag>/<EA>_<SIMBOLO>_(IS|OOS)_<tag>.csv (due righe = le due gemelle). Il RIEPILOGO dice se il motore e' = pin (per job).
#  CRITERI CONGELATI (anche nelle intestazioni dei file prova R293a, R294a-b, R295a-j):
#   G1 gemelle identiche (Profit <= 1, PF <= 0,0002, Trades uguali, DD% <= 0,0001). MOTORE = pin richiesto per leggere un job; se diverso: NON LEGGIBILE.
#   R293a: G0 = R292a = R292b al centesimo (IS 223,45/1,53877/2,1272/74; OOS 622,22/1,94266/3,8721/79; tolleranza 1,01/0,0002/0,0001/uguali).
#   R294a AUDCHF: POSITIVA (PF>1 in IS e OOS) / NEGATIVA (PF<1 in entrambe) / MISTA; < 100 deal in una gamba => DESCRITTIVO.
#   R294b oro: confronto INDICATIVO (non G0) col vecchio scan (IS 0,65795/39; OOS 1,49468/67): coerente se PF entro 0,10 e deal entro +-20% in entrambe le gambe.
#   R295: dPF = PF(5400) - PF(100000); rapporto trade = T(5400)/T(100000). REGGE: |dPF|<0,10 e rapporto in [0,95;1,05] in entrambe le gambe;
#         DEGRADA: dPF <= -0,10 in entrambe; MIGLIORA: dPF >= +0,10 in entrambe; altrimenti MISTO. < 100 deal in una gamba di uno dei due bracci => DESCRITTIVO.
# =====================================================================
import csv, os, sys, tempfile, re
R293 = {'EA': 'ABTG_MaxMinNotte', 'SYM': 'XAUUSD', 'ref': {'IS': (223.45, 1.53877, 2.1272, 74), 'OOS': (622.22, 1.94266, 3.8721, 79)}}
R294 = {'R294a': ('ABTG_EMA200_Ottimizzato', 'AUDCHF'), 'R294b': ('ABTG_EMA200_Ottimizzato', 'XAUUSD')}
ORO_STORICO = {'IS': (0.65795, 39), 'OOS': (1.49468, 67)}
CELLE295 = [('EasyTrend 772421 CHFJPY', 'ABTG_EasyTrend', 'CHFJPY', 'R295a', 'R295b'), ('EasyTrend 772422 GBPUSD', 'ABTG_EasyTrend', 'GBPUSD', 'R295c', 'R295d'),
            ('PTE 771322 GBPUSD', 'ABTG_PTE', 'GBPUSD', 'R295e', 'R295f'), ('PTE 771332 GBPUSD', 'ABTG_PTE', 'GBPUSD', 'R295g', 'R295h'),
            ('BreakingBand 772161 GBPUSD', 'ABTG_BreakingBand', 'GBPUSD', 'R295i', 'R295j')]
DEP = {'a': 5400}
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def job(cart, ea, sym, tag):
    r = {}
    for leg in ('IS', 'OOS'):
        p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag))
        if not os.path.exists(p): return None
        rows = leggi(p)
        if not rows: return None
        r[leg] = dict(g1=g1(rows), **rows[0])
    return r
def motori(cart):
    m = {}; p = os.path.join(cart, 'RIEPILOGO_R293.txt')
    if not os.path.exists(p): return m
    for riga in open(p, encoding='utf-8', errors='replace'):
        mm = re.match(r'^(R29[345][a-j])\s+fin', riga)
        if mm: m[mm.group(1)] = ('motore = pin' in riga)
    return m
def leggibile(r, tag, mot):
    if r is None: return 'MANCANTE'
    if not (r['IS']['g1'] and r['OOS']['g1']): return 'GUASTO: gemelle DIVERSE (G1)'
    if mot.get(tag) is None: return 'MOTORE NON VERIFICATO (manca la riga nel RIEPILOGO)'
    if not mot[tag]: return 'MOTORE DIVERSO DAL PIN: NON LEGGIBILE'
    return None
def uguali(x, ref):
    return abs(x['profit'] - ref[0]) <= 1.01 and abs(x['pf'] - ref[1]) <= 0.0002 and abs(x['dd'] - ref[2]) <= 0.0001 + 1e-9 and x['n'] == ref[3]
def giudica(cart):
    es = {}; mot = motori(cart)
    # R293a
    r = job(cart, R293['EA'], R293['SYM'], 'R293a'); bad = leggibile(r, 'R293a', mot)
    if bad: es['R293a (G0 di R292)'] = bad
    else:
        g0 = all(uguali(r[l], R293['ref'][l]) for l in ('IS', 'OOS'))
        es['R293a (G0 di R292)'] = ('MOTORE = PIN e IDENTICA a R292a/R292b al centesimo: G0 DI R292 CHIUSO' if g0 else 'MOTORE = PIN ma DIVERSA da R292a/b: il motore di R292a era DIVERSO, R292b/c NON sono confrontabili con l\'originale') + ' (IS %.2f/%.5f/%d, OOS %.2f/%.5f/%d)' % (r['IS']['profit'], r['IS']['pf'], r['IS']['n'], r['OOS']['profit'], r['OOS']['pf'], r['OOS']['n'])
    # R294
    rr = {}
    for tag, (ea, sym) in R294.items():
        r = job(cart, ea, sym, tag); bad = leggibile(r, tag, mot); rr[tag] = (r, bad)
    r, bad = rr['R294a']
    if bad: es['R294a AUDCHF'] = bad
    else:
        pos = all(r[l]['pf'] > 1 for l in r); neg = all(r[l]['pf'] < 1 for l in r)
        v = 'POSITIVA' if pos else ('NEGATIVA' if neg else 'MISTA')
        if min(r['IS']['n'], r['OOS']['n']) < 100: v += ' (DESCRITTIVO: deal IS %d, OOS %d < 100)' % (r['IS']['n'], r['OOS']['n'])
        es['R294a AUDCHF'] = '%s: IS PF %.5f / %d deal / DD %.2f; OOS PF %.5f / %d deal / DD %.2f' % (v, r['IS']['pf'], r['IS']['n'], r['IS']['dd'], r['OOS']['pf'], r['OOS']['n'], r['OOS']['dd'])
    r, bad = rr['R294b']
    if bad: es['R294b oro (confronto)'] = bad
    else:
        coer = all(abs(r[l]['pf'] - ORO_STORICO[l][0]) <= 0.10 and abs(r[l]['n'] - ORO_STORICO[l][1]) <= 0.20 * ORO_STORICO[l][1] for l in r)
        es['R294b oro (confronto)'] = '%s col vecchio scan (INDICATIVO, non G0): IS PF %.5f / %d deal; OOS PF %.5f / %d deal' % ('COERENTE' if coer else 'DIVERSO', r['IS']['pf'], r['IS']['n'], r['OOS']['pf'], r['OOS']['n'])
    # R295
    for nome, ea, sym, ta, tb in CELLE295:
        ra = job(cart, ea, sym, ta); rb = job(cart, ea, sym, tb)
        ba = leggibile(ra, ta, mot); bb = leggibile(rb, tb, mot)
        if ba or bb: es['R295 ' + nome] = '5400: %s | 100000: %s' % (ba or 'ok', bb or 'ok'); continue
        d = {l: ra[l]['pf'] - rb[l]['pf'] for l in ('IS', 'OOS')}
        q = {l: (ra[l]['n'] / rb[l]['n'] if rb[l]['n'] else 0.0) for l in ('IS', 'OOS')}
        if all(abs(d[l]) < 0.10 and 0.95 <= q[l] <= 1.05 for l in d): v = 'REGGE'
        elif all(d[l] <= -0.10 for l in d): v = 'DEGRADA'
        elif all(d[l] >= 0.10 for l in d): v = 'MIGLIORA'
        else: v = 'MISTO'
        if min(ra[l]['n'] for l in ra) < 100 or min(rb[l]['n'] for l in rb) < 100: v += ' (DESCRITTIVO: <100 deal in una gamba)'
        es['R295 ' + nome] = '%s | dPF IS %+.5f OOS %+.5f | trade 5400/100k IS %d/%d OOS %d/%d | rendimento%% 5400: IS %.2f OOS %.2f; 100k: IS %.2f OOS %.2f' % (v, d['IS'], d['OOS'], ra['IS']['n'], rb['IS']['n'], ra['OOS']['n'], rb['OOS']['n'], ra['IS']['profit'] / 54.0, ra['OOS']['profit'] / 54.0, rb['IS']['profit'] / 1000.0, rb['OOS']['profit'] / 1000.0)
    return es
def autotest():
    d = tempfile.mkdtemp()
    def put(tag, ea, sym, is_, oos, g1ok=True):
        p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        for leg, v in (('IS', is_), ('OOS', oos)):
            with open(os.path.join(p, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag)), 'w', newline='') as f:
                w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades']); w.writerow([0, v[0], v[1], v[2], v[3]]); w.writerow([1, v[0] + (0 if g1ok else 5), v[1], v[2], v[3]])
    def riep(ok=True, skip=()):
        tags = ['R293a', 'R294a', 'R294b'] + [c[3] for c in CELLE295] + [c[4] for c in CELLE295]
        with open(os.path.join(d, 'RIEPILOGO_R293.txt'), 'w') as f:
            for t in tags:
                if t in skip: continue
                f.write('%s  fin B   rc 0   %s\n' % (t, 'motore = pin (SHA256, 2 file)' if ok else 'MOTORE DIVERSO DAL PIN: x'))
    ref = R293['ref']
    put('R293a', R293['EA'], 'XAUUSD', ref['IS'], ref['OOS'])
    put('R294a', 'ABTG_EMA200_Ottimizzato', 'AUDCHF', (50.0, 1.2, 2.0, 40), (80.0, 1.3, 3.0, 50))
    put('R294b', 'ABTG_EMA200_Ottimizzato', 'XAUUSD', (-170.0, 0.66, 2.2, 38), (400.0, 1.50, 4.5, 66))
    for nome, ea, sym, ta, tb in CELLE295:
        put(ta, ea, sym, (10.0, 1.30, 2.0, 120), (20.0, 1.40, 3.0, 130)); put(tb, ea, sym, (10.0, 1.32, 2.0, 121), (20.0, 1.38, 3.0, 131))
    riep(); es = giudica(d)
    assert es['R293a (G0 di R292)'].startswith('MOTORE = PIN e IDENTICA'), es
    assert es['R294a AUDCHF'].startswith('POSITIVA (DESCRITTIVO'), es
    assert es['R294b oro (confronto)'].startswith('COERENTE'), es
    assert all(es['R295 ' + c[0]].startswith('REGGE') for c in CELLE295), es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.0, 2.0, 120), (20.0, 1.1, 3.0, 130)); es = giudica(d); assert es['R295 EasyTrend 772421 CHFJPY'].startswith('DEGRADA'), es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.6, 2.0, 120), (20.0, 1.5, 3.0, 130)); es = giudica(d); assert es['R295 EasyTrend 772421 CHFJPY'].startswith('MIGLIORA'), es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.6, 2.0, 120), (20.0, 1.3, 3.0, 130)); es = giudica(d); assert es['R295 EasyTrend 772421 CHFJPY'].startswith('MISTO'), es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.30, 2.0, 80), (20.0, 1.40, 3.0, 90)); es = giudica(d); assert 'DESCRITTIVO' in es['R295 EasyTrend 772421 CHFJPY'], es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.30, 2.0, 120), (20.0, 1.40, 3.0, 130), g1ok=False); es = giudica(d); assert 'GUASTO' in es['R295 EasyTrend 772421 CHFJPY'], es
    put('R295a', 'ABTG_EasyTrend', 'CHFJPY', (10.0, 1.30, 2.0, 120), (20.0, 1.40, 3.0, 130)); riep(skip=('R293a',)); es = giudica(d); assert 'NON VERIFICATO' in es['R293a (G0 di R292)'], es
    riep(ok=False); es = giudica(d); assert 'NON LEGGIBILE' in es['R293a (G0 di R292)'], es
    riep(); put('R293a', R293['EA'], 'XAUUSD', (223.45, 1.53877, 2.1272, 74), (600.0, 1.94266, 3.8721, 79)); es = giudica(d); assert 'DIVERSA' in es['R293a (G0 di R292)'], es
    print('AUTOTEST R293-R295: 11 casi OK (G0 chiuso, G0 diverso, motore diverso/non verificato, AUDCHF descrittivo, oro coerente, REGGE/DEGRADA/MIGLIORA/MISTO/DESCRITTIVO, G1 guasto)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    for k, v in giudica(sys.argv[1]).items(): print('%-30s %s' % (k, v))
