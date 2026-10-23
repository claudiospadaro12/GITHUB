#!/usr/bin/env python3
# =====================================================================
#  r282_giudizio.py -- LETTORE CONGELATO del round R282 (ABTG_Nasdaq_Apertura_US_Sicuro v1.03: festivi NYSE, ora solare USA, tetto lotto minimo)
#  Scritto il 23/10/2026 PRIMA di aprire lo zip, dai criteri dei file prova R282a-e (par. 1).
#  USO:  python3 backtest_pipeline/r282_giudizio.py <cartella con ROUND_R282a..e e PERTRADE>      |   --autotest
#  Layout: <cartella>/ROUND_R282x/ABTG_Nasdaq_Apertura_US_Sicuro_NASUSD_(IS|OOS)_R282x.csv  e  <cartella>/PERTRADE/abtg_trades_ABTG_Nasdaq_Apertura_US_Sicuro_NASUSD_<magic>.csv
#  Non promuove niente.
# =====================================================================
import csv, os, sys, tempfile, calendar, datetime as dt, collections
EA = 'ABTG_Nasdaq_Apertura_US_Sicuro'
MAGIC = {'R282a': '799111', 'R282b': '799121', 'R282c': '799131', 'R282d': '799141', 'R282e': '799151'}
BASE = {'IS': dict(profit=7014.21, pf=1.22116, dd=7.3069, n=135), 'OOS': dict(profit=8496.74, pf=1.21546, dd=7.8576, n=172)}   # R274a
# ---- calendario (copia della logica dell'EA) ----
def dow(y, m, d): return (dt.date(y, m, d).weekday() + 1) % 7
def nth(y, m, wd, n): return 1 + (7 + wd - dow(y, m, 1)) % 7 + 7 * (n - 1)
def last(y, m, wd):
    L = calendar.monthrange(y, m)[1]; return L - (7 + dow(y, m, L) - wd) % 7
def fisso(y, m, d, hm, hd, cap):
    if m != hm: return False
    w = dow(y, hm, hd); o = hd
    if w == 6:
        if cap: return False
        o = hd - 1
    elif w == 0: o = hd + 1
    return d == o
def pasqua(y):
    a = y % 19; b = y // 100; c = y % 100; d = b // 4; e = b % 4; f = (b + 8) // 25; g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30; i = c // 4; k = c % 4; l = (32 + 2 * e + 2 * i - h - k) % 7; m = (a + 11 * h + 22 * l) // 451
    return (h + l - 7 * m + 114) // 31, ((h + l - 7 * m + 114) % 31) + 1
def festivo(y, m, d):
    if fisso(y, m, d, 1, 1, True): return True
    if m == 1 and d == nth(y, 1, 1, 3): return True
    if m == 2 and d == nth(y, 2, 1, 3): return True
    pm, pd = pasqua(y); gv = dt.date(y, pm, pd) - dt.timedelta(2)
    if (m, d) == (gv.month, gv.day): return True
    if m == 5 and d == last(y, 5, 1): return True
    if y >= 2022 and fisso(y, m, d, 6, 19, False): return True
    if fisso(y, m, d, 7, 4, False): return True
    if m == 9 and d == nth(y, 9, 1, 1): return True
    if m == 11 and d == nth(y, 11, 4, 4): return True
    if fisso(y, m, d, 12, 25, False): return True
    return (y, m, d) == (2025, 1, 9)
def solare(y, m, d):
    md = m * 100 + d; return md < 300 + nth(y, 3, 0, 2) or md >= 1100 + nth(y, 11, 0, 1)
# ---- lettura ----
def leggi(path):
    with open(path, newline='') as f: rows = list(csv.DictReader(f))
    return [dict(profit=float(r['Profit']), pf=float(r['Profit Factor']), dd=float(r['Equity DD %']), n=int(float(r['Trades']))) for r in rows]
def g1(rows):
    if len(rows) != 2: return False
    a, b = rows
    return abs(a['profit'] - b['profit']) <= 1.0 and abs(a['pf'] - b['pf']) <= 0.0002 and a['n'] == b['n'] and abs(a['dd'] - b['dd']) < 1e-9
def carica(cart):
    R = {}
    for tag in MAGIC:
        R[tag] = {}
        for leg in ('IS', 'OOS'):
            p = os.path.join(cart, 'ROUND_' + tag, '%s_NASUSD_%s_%s.csv' % (EA, leg, tag))
            if not os.path.exists(p): R[tag][leg] = None; continue
            rows = leggi(p); R[tag][leg] = dict(g1=g1(rows), **rows[0])
    return R
def posizioni(cart, tag):
    p = os.path.join(cart, 'PERTRADE', 'abtg_trades_%s_NASUSD_%s.csv' % (EA, MAGIC[tag]))
    if not os.path.exists(p): return None
    pos = collections.OrderedDict()
    for r in csv.DictReader(open(p), delimiter=';'):
        k = r['position_id']; pos.setdefault(k, [r['close_time'], 0.0]); pos[k][1] += float(r['net_profit']); pos[k][0] = r['close_time']
    return list(pos.values())          # [close_time, netto]
def parse(t): return dt.datetime.strptime(t, '%Y.%m.%d %H:%M:%S')
def uguali(A, B):
    return len(A) == len(B) and abs(sum(x[1] for x in A) - sum(x[1] for x in B)) <= 1.0
def giudica(R, cart):
    out = []
    for tag in sorted(R):
        for leg in ('IS', 'OOS'):
            x = R[tag][leg]
            out.append('%s %s: %s' % (tag, leg, 'MANCANTE' if x is None else 'n %d | PF %.5f | DD %.4f%% | Profit %.2f | gemelle %s' % (x['n'], x['pf'], x['dd'], x['profit'], 'identiche' if x['g1'] else 'DIVERSE')))
    ok_all = all(R[t][l] is not None and R[t][l]['g1'] for t in R for l in ('IS', 'OOS'))
    out.append('G1 (gemelle identiche in tutti i file): %s' % ('PASSA' if ok_all else 'NON PASSA'))
    # G0
    g0 = True; det = []
    for leg in ('IS', 'OOS'):
        a, b = R['R282a'][leg], BASE[leg]
        if a is None: g0 = False; det.append(leg + ' mancante'); continue
        c = abs(a['profit'] - b['profit']) <= 1.01 and abs(a['pf'] - b['pf']) <= 0.0002 and abs(a['dd'] - b['dd']) <= 0.0001 and a['n'] == b['n']
        det.append('%s: Profit %.2f vs %.2f | PF %.5f vs %.5f | DD %.4f vs %.4f | Trades %d vs %d -> %s' % (leg, a['profit'], b['profit'], a['pf'], b['pf'], a['dd'], b['dd'], a['n'], b['n'], 'OK' if c else 'DIVERSO'))
        g0 = g0 and c
    out.append('G0 (R282a tutto spento = R274a): %s' % ('PASSA' if g0 else 'NON PASSA: nessun altro numero si legge come prova'))
    out += ['    ' + d for d in det]
    pa, pb, pe = posizioni(cart, 'R282a'), posizioni(cart, 'R282b'), posizioni(cart, 'R282e')
    # FESTIVI
    if pa is None or pb is None: out.append('FESTIVI: NON VALUTABILE (per-trade mancante)')
    else:
        hol = [x for x in pb if festivo(*[getattr(parse(x[0]), k) for k in ('year', 'month', 'day')])]
        nonhol_a = [x for x in pa if not festivo(*[getattr(parse(x[0]), k) for k in ('year', 'month', 'day')])]
        nonhol_b = [x for x in pb if not festivo(*[getattr(parse(x[0]), k) for k in ('year', 'month', 'day')])]
        rim = [x for x in pa if festivo(*[getattr(parse(x[0]), k) for k in ('year', 'month', 'day')])]
        isok = R['R282b']['IS'] is not None and R['R282a']['IS'] is not None and R['R282b']['IS']['n'] <= R['R282a']['IS']['n']
        ok = (len(hol) == 0) and uguali(nonhol_a, nonhol_b) and isok
        out.append('FESTIVI (R282b contro R282a): %s | OOS: posizioni a festivo in R282b %d; giorni non festivi %d contro %d; posizioni tolte rispetto a R282a (festivi) %d, netto %.0f | IS Trades b %s a' % ('OK' if ok else 'NON OK', len(hol), len(nonhol_b), len(nonhol_a), len(rim), sum(x[1] for x in rim), '<=' if isok else '>'))
    # TETTO
    c, d = R['R282c'], R['R282d']
    if any(c[l] is None or d[l] is None for l in ('IS', 'OOS')): out.append('TETTO: NON VALUTABILE')
    else:
        ris = []; ok = True
        for leg in ('IS', 'OOS'):
            k = d[leg]['n'] < c[leg]['n'] and d[leg]['dd'] <= c[leg]['dd'] and d[leg]['n'] > 0
            ris.append('%s: Trades %d contro %d | DD %.2f contro %.2f -> %s' % (leg, d[leg]['n'], c[leg]['n'], d[leg]['dd'], c[leg]['dd'], 'OK' if k else 'no'))
            ok = ok and k
        out.append('TETTO (R282d contro R282c, deposito 500): %s' % ('OK' if ok else 'NON OK')); out += ['    ' + r for r in ris]
    # DST
    if pa is None or pe is None: out.append('DST: NON VALUTABILE (per-trade mancante)')
    else:
        def stag(P, sol): return [x for x in P if solare(parse(x[0]).year, parse(x[0]).month, parse(x[0]).day) == sol]
        leg_a, leg_e = stag(pa, False), stag(pe, False)
        inv_e = stag(pe, True)
        presto = [x for x in inv_e if (parse(x[0]).hour * 60 + parse(x[0]).minute) < 15 * 60 + 35]
        ok = uguali(leg_a, leg_e) and len(inv_e) > 0 and len(presto) == 0
        out.append('DST (R282e contro R282a): %s | OOS ora legale: %d contro %d posizioni (netto %.0f contro %.0f) | ora solare: %d posizioni, chiuse prima delle 15:35: %d' % ('OK' if ok else 'NON OK', len(leg_e), len(leg_a), sum(x[1] for x in leg_e), sum(x[1] for x in leg_a), len(inv_e), len(presto)))
        inv_a = stag(pa, True)
        if inv_a and inv_e:
            def pf(P):
                g = sum(x[1] for x in P if x[1] > 0); l = -sum(x[1] for x in P if x[1] < 0); return g / l if l else float('inf')
            out.append('    (orientamento, nessun verdetto) ora solare OOS: R282a %d pos PF %.2f netto %.0f | R282e %d pos PF %.2f netto %.0f' % (len(inv_a), pf(inv_a), sum(x[1] for x in inv_a), len(inv_e), pf(inv_e), sum(x[1] for x in inv_e)))
    return out
def autotest():
    # calendario: festivi 2025/2026 e ora solare
    H = [(2025, 1, 1), (2025, 1, 20), (2025, 4, 18), (2025, 7, 4), (2026, 1, 19), (2026, 4, 3), (2026, 7, 3), (2026, 11, 26)]
    assert all(festivo(*h) for h in H), 'festivi'
    assert not festivo(2025, 7, 7) and not festivo(2026, 7, 6)
    assert solare(2025, 3, 7) and not solare(2025, 3, 10) and solare(2025, 11, 3) and not solare(2026, 10, 30) and solare(2026, 11, 2)
    d = tempfile.mkdtemp(); hdr = ['Pass', 'Profit', 'Profit Factor', 'Equity DD %', 'Trades', 'InpMagic']
    vals = {'R282a': {'IS': (7014.21, 1.22116, 7.3069, 135), 'OOS': (8496.74, 1.21546, 7.8576, 172)}, 'R282b': {'IS': (6900, 1.2, 7.3, 130), 'OOS': (8300, 1.21, 7.8, 168)},
            'R282c': {'IS': (50, 1.1, 20, 100), 'OOS': (60, 1.1, 22, 150)}, 'R282d': {'IS': (80, 1.2, 15, 60), 'OOS': (90, 1.2, 16, 90)}, 'R282e': {'IS': (7000, 1.2, 7.3, 140), 'OOS': (8400, 1.2, 7.8, 170)}}
    for tag, legs in vals.items():
        os.makedirs(os.path.join(d, 'ROUND_' + tag))
        for leg, v in legs.items():
            with open(os.path.join(d, 'ROUND_' + tag, '%s_NASUSD_%s_%s.csv' % (EA, leg, tag)), 'w', newline='') as f:
                c = csv.writer(f); c.writerow(hdr)
                for i in (1, 2): c.writerow([i - 1, v[0], v[1], v[2], v[3], i])
    os.makedirs(os.path.join(d, 'PERTRADE'))
    def pt(tag, rows):
        with open(os.path.join(d, 'PERTRADE', 'abtg_trades_%s_NASUSD_%s.csv' % (EA, MAGIC[tag])), 'w') as f:
            f.write('close_time;symbol;magic;position_id;deal_type;volume;price;net_profit\n')
            for i, (t, n) in enumerate(rows): f.write('%s;NASUSD;1;%d;1;1.0;1.0;%s\n' % (t, i + 1, n))
    A = [('2025.07.03 16:00:00', 100), ('2025.07.04 16:00:00', -50), ('2025.12.10 16:30:00', 70)]
    pt('R282a', A); pt('R282b', [A[0], A[2]]); pt('R282e', [A[0], A[1], ('2025.12.10 17:00:00', 70)])
    t = '\n'.join(giudica(carica(d), d))
    assert 'G0 (R282a tutto spento = R274a): PASSA' in t, t
    assert 'FESTIVI (R282b contro R282a): OK' in t and 'TETTO (R282d contro R282c, deposito 500): OK' in t and 'DST (R282e contro R282a): OK' in t, t
    print('AUTOTEST OK'); return 0
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': sys.exit(autotest())
    if len(sys.argv) < 2: sys.exit(__doc__)
    print('\n'.join(giudica(carica(sys.argv[1]), sys.argv[1])))
