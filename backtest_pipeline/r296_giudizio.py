#!/usr/bin/env python3
# =====================================================================
#  r296_giudizio.py -- LETTORE CONGELATO della superstringa del giro 3 (R296 EMA200 Dow deposito, R297 pendente ON/OFF, R298 SuperWave 770531,
#  R299 SupRev DAX 970912, R300 SupertrendReversal 225JPY). Scritto il 24/10/2026 PRIMA di aprire lo zip.
#  USO: python3 backtest_pipeline/r296_giudizio.py <cartella con ROUND_R296a..R300a, RIEPILOGO_R296.txt e PERTRADE/> | --autotest
#  Layout: <cartella>/ROUND_<tag>/<EA>_<SIMBOLO>_(IS|OOS)_<tag>.csv (due righe = le due gemelle); per-trade: abtg_trades_<EA>_<SIMBOLO>_<magic g1>.csv cercato ricorsivamente.
#  CRITERI CONGELATI: quelli scritti nelle intestazioni dei file prova R296a-c, R297a-d, R298a, R299a, R300a. In sintesi:
#   G1 gemelle identiche (1 / 0,0002 / uguali / 0,0001); motore = pin (RIEPILOGO) per leggere un job; rc 1 = NON PARTITO.
#   R296: G0 sentinella a = R112 00_metro AL CENTESIMO (IS 4585,40/1,20110/5,7325/237; OOS 23321,47/1,52365/7,8323/517). Poi b e c contro a: dPF e rapporto trade, REGGE (|dPF|<0,10 e rapporto 0,95-1,05 in entrambe le gambe) /
#         DEGRADA (dPF<=-0,10 in entrambe) / MIGLIORA (>=+0,10 in entrambe) / MISTO; sotto 100 deal in una gamba DESCRITTIVO. Quota di chiusure a lotto <= 0,20 (per-trade OOS) riportata.
#   R297: INERTE se ON = OFF al centesimo in IS e OOS (pendente mai eseguito nel tester); ESEGUITO se Trades ON > Trades OFF in entrambe le gambe; altrimenti ANOMALO.
#   R298: settimane ISO, correlazione di Pearson del netto fra 770511 (R297c) e 770531 (R298a), gamba OOS: >=0,50 QUASI UNA SEDIA SOLA, <=0,20 INDIPENDENTI, altrimenti INTERMEDIA; < 30 settimane con chiusure => DESCRITTIVO.
#   R299: lambda_max = deal OOS/7,86; lambda_min = deal OOS/2/7,86; ANOMALO se exp(-lambda_min)<0,05; PLAUSIBILE se exp(-lambda_max)>=0,05; altrimenti INCERTO; 0 deal => MUTA ANCHE NEL TESTER.
#   R300: il job parte = HEAD compila (A4); segno POSITIVA/NEGATIVA/MISTA; < 100 deal in una gamba DESCRITTIVO.
# =====================================================================
import csv, os, sys, glob, math, re, tempfile, datetime
from collections import defaultdict
J = {'R296a': ('ABTG_EMA200', 'U30USD', 800201), 'R296b': ('ABTG_EMA200', 'U30USD', 800202), 'R296c': ('ABTG_EMA200', 'U30USD', 800203),
     'R297a': ('ABTG_SupRev_NAS_H1_Ottimizzato', 'NASUSD', 800204), 'R297b': ('ABTG_SupRev_NAS_H1_Ottimizzato', 'NASUSD', 800205),
     'R297c': ('ABTG_SuperWave_DOW_H1_Ottimizzato', 'U30USD', 800206), 'R297d': ('ABTG_SuperWave_DOW_H1_Ottimizzato', 'U30USD', 800207),
     'R298a': ('ABTG_SuperWave', 'U30USD', 800208), 'R299a': ('ABTG_SupRev_DAX_H4_Ottimizzato', 'D30EUR', 800209), 'R300a': ('ABTG_SupertrendReversal', '225JPY', 800210)}
R112 = {'IS': (4585.40, 1.20110, 5.7325, 237), 'OOS': (23321.47, 1.52365, 7.8323, 517)}
BLOCCHI = 7.86
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) <= 0.0001 + 1e-9
def uguali(x, ref):  # ref = (profit, pf, dd, n)
    return abs(x['profit'] - ref[0]) <= 1.01 and abs(x['pf'] - ref[1]) <= 0.0002 and abs(x['dd'] - ref[2]) <= 0.0001 + 1e-9 and x['n'] == ref[3]
def tupla(x): return (x['profit'], x['pf'], x['dd'], x['n'])
def riepilogo(cart):
    m = {}; p = os.path.join(cart, 'RIEPILOGO_R296.txt')
    if os.path.exists(p):
        for riga in open(p, encoding='utf-8', errors='replace'):
            mm = re.match(r'^(R29[6-9][a-d]|R300a)\s+fin\s+\S+\s+rc\s+(\d)', riga)
            if mm: m[mm.group(1)] = (int(mm.group(2)), 'motore = pin' in riga)
    return m
def job(cart, tag):
    ea, sym, _ = J[tag]; r = {}
    for leg in ('IS', 'OOS'):
        p = os.path.join(cart, 'ROUND_' + tag, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag))
        if not os.path.exists(p): return None
        rows = leggi(p)
        if not rows: return None
        r[leg] = dict(g1=g1(rows), **rows[0])
    return r
def stato(cart, tag, rie):
    if tag not in rie: return None, 'NON VERIFICATO (manca la riga nel RIEPILOGO)'
    rc, mot = rie[tag]
    if rc == 1: return None, 'NON PARTITO (rc 1: se e un errore di compilazione il sorgente HEAD NON compila)'
    r = job(cart, tag)
    if r is None: return None, 'MANCANTE (CSV IS/OOS)'
    if not (r['IS']['g1'] and r['OOS']['g1']): return None, 'GUASTO: gemelle DIVERSE (G1)'
    if not mot: return None, 'MOTORE DIVERSO DAL PIN: NON LEGGIBILE'
    return r, None
def pertrade(cart, tag):
    ea, sym, mg = J[tag]
    ps = glob.glob(os.path.join(cart, '**', 'abtg_trades_%s_%s_%d.csv' % (ea, sym, mg)), recursive=True)
    if not ps: return None
    out = []
    with open(ps[0], newline='') as f:
        for r in csv.DictReader(f, delimiter=';'):
            if r['magic'] != str(mg): continue
            out.append((r['close_time'], r['position_id'], float(r['volume']), float(r['net_profit'])))
    out.sort(); return out
def quota_min(pt, soglia=0.20):
    return (sum(1 for x in pt if x[2] <= soglia + 1e-9) / len(pt)) if pt else 0.0
def esito(r): return 'IS PF %.5f / %d deal / DD %.2f / %.2f; OOS PF %.5f / %d deal / DD %.2f / %.2f' % (r['IS']['pf'], r['IS']['n'], r['IS']['dd'], r['IS']['profit'], r['OOS']['pf'], r['OOS']['n'], r['OOS']['dd'], r['OOS']['profit'])
def classifica(ra, rb):  # rb = riferimento (a); ra = confronto
    d = {l: ra[l]['pf'] - rb[l]['pf'] for l in ('IS', 'OOS')}; q = {l: (ra[l]['n'] / rb[l]['n'] if rb[l]['n'] else 0.0) for l in d}
    if all(abs(d[l]) < 0.10 and 0.95 <= q[l] <= 1.05 for l in d): v = 'REGGE'
    elif all(d[l] <= -0.10 for l in d): v = 'DEGRADA'
    elif all(d[l] >= 0.10 for l in d): v = 'MIGLIORA'
    else: v = 'MISTO'
    if min(ra[l]['n'] for l in ra) < 100 or min(rb[l]['n'] for l in rb) < 100: v += ' (DESCRITTIVO: <100 deal in una gamba)'
    return v, d, q
def settimana(ct):
    y, m, dd = [int(x) for x in ct.split(' ')[0].split('.')]
    iso = datetime.date(y, m, dd).isocalendar(); return (iso[0], iso[1])
def pearson(a, b):
    n = len(a)
    if n < 3: return None
    ma, mb = sum(a) / n, sum(b) / n
    sa = math.sqrt(sum((x - ma) ** 2 for x in a)); sb = math.sqrt(sum((y - mb) ** 2 for y in b))
    if sa == 0 or sb == 0: return None
    return sum((x - ma) * (y - mb) for x, y in zip(a, b)) / (sa * sb)
def maxdd(serie):
    c = 0.0; picco = 0.0; dd = 0.0
    for v in serie:
        c += v; picco = max(picco, c); dd = max(dd, picco - c)
    return dd
def giudica(cart):
    es = {}; rie = riepilogo(cart); R = {}
    for tag in J:
        r, bad = stato(cart, tag, rie); R[tag] = r
        if bad: es['%s stato' % tag] = bad
    # ---- R296 / B5
    if R['R296a']:
        g0 = all(uguali(R['R296a'][l], R112[l]) for l in ('IS', 'OOS'))
        es['R296 G0 sentinella'] = ('IDENTICA a R112 00_metro al centesimo' if g0 else 'DIVERSA da R112: B5 NON SI LEGGE') + ' | ' + esito(R['R296a'])
        if g0:
            pa = pertrade(cart, 'R296a')
            for t in ('R296b', 'R296c'):
                if R[t]:
                    v, d, q = classifica(R[t], R['R296a']); pt = pertrade(cart, t)
                    extra = ''
                    if pt and pa: extra = ' | quota chiusure a lotto <= 0,20 (OOS): %.1f%% contro %.1f%% della sentinella' % (100 * quota_min(pt), 100 * quota_min(pa))
                    es['R296 ' + t] = '%s | dPF IS %+.5f OOS %+.5f | trade/sentinella IS %.3f OOS %.3f | rendimento%% su 5400: IS %.2f OOS %.2f (sentinella su 100k: IS %.2f OOS %.2f)%s | %s' % (
                        v, d['IS'], d['OOS'], q['IS'], q['OOS'], R[t]['IS']['profit'] / 54.0, R[t]['OOS']['profit'] / 54.0, R['R296a']['IS']['profit'] / 1000.0, R['R296a']['OOS']['profit'] / 1000.0, extra, esito(R[t]))
    # ---- R297 / B6
    for nome, on, off in (('SupRev NAS H1', 'R297a', 'R297b'), ('SuperWave Dow H1', 'R297c', 'R297d')):
        if R[on] and R[off]:
            ident = all(uguali(R[on][l], tupla(R[off][l])) for l in ('IS', 'OOS'))
            ese = all(R[on][l]['n'] > R[off][l]['n'] for l in ('IS', 'OOS'))
            pon = pertrade(cart, on); poff = pertrade(cart, off)
            pos = ''
            if pon and poff: pos = ' | posizioni distinte OOS: ON %d, OFF %d' % (len({x[1] for x in pon}), len({x[1] for x in poff}))
            if ident: v = 'INERTE: ON = OFF al centesimo, il pendente NON viene mai eseguito nel tester'
            elif ese: v = 'ESEGUITO: la gamba 2/3 viene riempita nel tester (rapporto trade ON/OFF IS %.2f OOS %.2f, dPF IS %+.5f OOS %+.5f)' % (R[on]['IS']['n'] / max(1, R[off]['IS']['n']), R[on]['OOS']['n'] / max(1, R[off]['OOS']['n']), R[on]['IS']['pf'] - R[off]['IS']['pf'], R[on]['OOS']['pf'] - R[off]['OOS']['pf'])
            else: v = 'ANOMALO: ON diverso da OFF ma senza piu deal (si descrive)'
            es['R297 ' + nome] = v + pos + ' | ON: ' + esito(R[on]) + ' | OFF: ' + esito(R[off])
    # ---- R298 / B7
    if R['R297c'] and R['R298a']:
        p1 = pertrade(cart, 'R297c'); p2 = pertrade(cart, 'R298a')
        if not p1 or not p2: es['R298 coppia 770511/770531'] = 'PER-TRADE MANCANTE'
        else:
            w1 = defaultdict(float); w2 = defaultdict(float); g1d = set(); g2d = set()
            for ct, pid, vol, net in p1: w1[settimana(ct)] += net; g1d.add(ct.split(' ')[0])
            for ct, pid, vol, net in p2: w2[settimana(ct)] += net; g2d.add(ct.split(' ')[0])
            tutte = sorted(set(w1) | set(w2)); a = [w1.get(k, 0.0) for k in tutte]; b = [w2.get(k, 0.0) for k in tutte]
            c = pearson(a, b); com = (len(g2d & g1d) / len(g2d)) if g2d else 0.0
            ddc = maxdd([x[3] for x in sorted(p1 + p2)]); dds = maxdd([x[3] for x in p1]) + maxdd([x[3] for x in p2])
            if c is None: v = 'NON CALCOLABILE (serie costante o < 3 settimane)'
            elif c >= 0.5: v = 'QUASI UNA SEDIA SOLA (correlazione settimanale %.2f)' % c
            elif c <= 0.2: v = 'INDIPENDENTI (correlazione settimanale %.2f)' % c
            else: v = 'INTERMEDIA (correlazione settimanale %.2f)' % c
            if len(tutte) < 30: v += ' (DESCRITTIVO: %d settimane con chiusure)' % len(tutte)
            es['R298 coppia 770511/770531'] = '%s | giorni di chiusura di 770531 in cui chiude anche 770511: %.0f%% | DD sulle chiusure: coppia %.2f contro somma dei due %.2f (%.0f%%)' % (v, 100 * com, ddc, dds, (100 * ddc / dds) if dds else 0.0)
    # ---- R299 / A3
    if R['R299a']:
        n = R['R299a']['OOS']['n']
        if n == 0: v = 'MUTA ANCHE NEL TESTER (0 deal in OOS)'
        else:
            lmax = n / BLOCCHI; lmin = n / 2 / BLOCCHI; pmin = math.exp(-lmin); pmax = math.exp(-lmax)
            if pmin < 0.05: v = 'ANOMALO: anche col ritmo piu basso (P0 %.1f%%) lo zero in 7 settimane e improbabile' % (100 * pmin)
            elif pmax >= 0.05: v = 'PLAUSIBILE: lo zero in 7 settimane ha P0 fra %.1f%% e %.1f%%' % (100 * pmax, 100 * pmin)
            else: v = 'INCERTO: P0 fra %.1f%% e %.1f%%' % (100 * pmax, 100 * pmin)
        es['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'] = v + ' | ' + esito(R['R299a'])
    # ---- R300 / A4
    if 'R300a stato' not in es or not es['R300a stato'].startswith('NON PARTITO'):
        if R['R300a']:
            r = R['R300a']; pos = all(r[l]['pf'] > 1 for l in r); neg = all(r[l]['pf'] < 1 for l in r)
            v = 'POSITIVA' if pos else ('NEGATIVA' if neg else 'MISTA')
            if min(r['IS']['n'], r['OOS']['n']) < 100: v += ' (DESCRITTIVO: <100 deal in una gamba)'
            es['R300 SupertrendReversal 225JPY (A4: HEAD compila: SI)'] = v + ' | ' + esito(r)
    else: es['R300 A4'] = 'HEAD NON COMPILA (job non partito): il binario del 08/08 non e ricostruibile da HEAD'
    return es
def autotest():
    d = tempfile.mkdtemp(); os.makedirs(os.path.join(d, 'PERTRADE'))
    def put(tag, is_, oos, g1ok=True):
        ea, sym, _ = J[tag]; p = os.path.join(d, 'ROUND_' + tag); os.makedirs(p, exist_ok=True)
        for leg, v in (('IS', is_), ('OOS', oos)):
            with open(os.path.join(p, '%s_%s_%s_%s.csv' % (ea, sym, leg, tag)), 'w', newline='') as f:
                w = csv.writer(f); w.writerow(['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades']); w.writerow([0] + list(v)); w.writerow([1, v[0] + (0 if g1ok else 5)] + list(v[1:]))
    def riep(skip=(), rc=None, mot=True):
        with open(os.path.join(d, 'RIEPILOGO_R296.txt'), 'w') as f:
            for t in J:
                if t in skip: continue
                f.write('%s  fin B   rc %d   %s\n' % (t, (rc or {}).get(t, 0), 'motore = pin (SHA256, 2 file)' if mot else 'MOTORE DIVERSO DAL PIN: x'))
    def pt(tag, righe):
        ea, sym, mg = J[tag]
        with open(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_%s_%d.csv' % (ea, sym, mg)), 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow(['close_time', 'symbol', 'magic', 'position_id', 'deal_type', 'volume', 'price', 'net_profit'])
            for ct, pid, vol, net in righe: w.writerow([ct, sym, mg, pid, 1, '%.2f' % vol, 1, net])
    sa = ((4585.40, 1.20110, 5.7325, 237), (23321.47, 1.52365, 7.8323, 517))
    put('R296a', *sa); put('R296b', (4000.0, 1.19, 5.9, 235), (21000.0, 1.50, 8.0, 515)); put('R296c', (2500.0, 1.00, 5.9, 235), (9000.0, 1.20, 8.0, 515))
    put('R297a', (10.0, 1.3, 2.0, 60), (20.0, 1.4, 3.0, 80)); put('R297b', (10.0, 1.3, 2.0, 60), (20.0, 1.4, 3.0, 80))
    put('R297c', (10.0, 1.3, 2.0, 140), (20.0, 1.4, 3.0, 180)); put('R297d', (5.0, 1.3, 2.0, 70), (9.0, 1.4, 3.0, 90))
    put('R298a', (10.0, 1.3, 2.0, 40), (20.0, 1.4, 3.0, 50)); put('R299a', (10.0, 1.3, 2.0, 40), (20.0, 1.4, 3.0, 60)); put('R300a', (10.0, 1.1, 2.0, 40), (20.0, 1.2, 3.0, 60))
    def settimane(n, f):
        return [('2025.%02d.%02d 10:00:00' % (1 + (7 * i) // 28, 1 + (7 * i) % 28), str(i + 1), 0.10, f(i)) for i in range(n)]
    pt('R296a', [(c, p, 0.5, nn) for c, p, v, nn in settimane(40, lambda i: 1.0)]); pt('R296b', [(c, p, 0.1, nn) for c, p, v, nn in settimane(40, lambda i: 1.0)])
    pt('R296c', [(c, p, 0.1, nn) for c, p, v, nn in settimane(40, lambda i: 1.0)])
    base = lambda i: ((-1) ** i) * (i % 5 + 1.0)
    pt('R297c', settimane(40, base)); pt('R298a', settimane(40, base)); pt('R297a', settimane(10, base)); pt('R297b', settimane(10, base)); pt('R297d', settimane(20, base))
    riep(); es = giudica(d)
    assert es['R296 G0 sentinella'].startswith('IDENTICA'), es
    assert es['R296 R296b'].startswith('REGGE') and es['R296 R296c'].startswith('DEGRADA'), es
    assert 'quota chiusure a lotto' in es['R296 R296b'] and '100.0%' in es['R296 R296b'], es
    assert es['R297 SupRev NAS H1'].startswith('INERTE'), es
    assert es['R297 SuperWave Dow H1'].startswith('ESEGUITO'), es
    assert es['R298 coppia 770511/770531'].startswith('QUASI UNA SEDIA SOLA') and 'correlazione settimanale 1.00' in es['R298 coppia 770511/770531'], es
    assert es['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'].startswith('ANOMALO') or es['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'].startswith('INCERTO'), es
    assert es['R300 SupertrendReversal 225JPY (A4: HEAD compila: SI)'].startswith('POSITIVA (DESCRITTIVO'), es
    put('R299a', (10.0, 1.3, 2.0, 40), (20.0, 1.4, 3.0, 0)); assert giudica(d)['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'].startswith('MUTA'), 1
    put('R299a', (10.0, 1.3, 2.0, 40), (20.0, 1.4, 3.0, 400)); assert giudica(d)['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'].startswith('ANOMALO'), 2
    put('R299a', (10.0, 1.3, 2.0, 40), (20.0, 1.4, 3.0, 8)); assert giudica(d)['R299 SupRev DAX 970912 (A3, il sorgente HEAD compila: SI)'].startswith('PLAUSIBILE'), 3
    put('R296a', (4000.0, 1.1, 5.0, 230), sa[1]); assert giudica(d)['R296 G0 sentinella'].startswith('DIVERSA'), 4
    put('R296a', *sa); riep(rc={'R300a': 1}); es = giudica(d); assert es['R300a stato'].startswith('NON PARTITO') and 'R300 A4' in es, es
    riep(mot=False); es = giudica(d); assert 'NON LEGGIBILE' in es['R296a stato'] and 'R296 G0 sentinella' not in es, es
    riep(skip=('R297b',)); es = giudica(d); assert 'NON VERIFICATO' in es['R297b stato'] and 'R297 SupRev NAS H1' not in es, es
    riep(); put('R297a', (10.0, 1.3, 2.0, 60), (20.0, 1.4, 3.0, 80), g1ok=False); es = giudica(d); assert 'GUASTO' in es['R297a stato'], es
    print('AUTOTEST r296: 17 casi OK (G0, REGGE/DEGRADA, quota lotto, INERTE/ESEGUITO, correlazione, A3 muta/anomalo/plausibile, G0 diversa, non partito, motore diverso, non verificato, G1)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    for k, v in giudica(sys.argv[1]).items(): print('%-48s %s' % (k, v))
