#!/usr/bin/env python3
"""Lettore CONGELATO del test a fondo a 80.000 EUR dei primi EA del Market (criteri: report/MARKET_TEST_80K_NUOVI_ATTESE_2026-10-25.md).
Uso:  python3 -I leggi_deep80k_nuovi.py <cartella con le DEEP80K_<TOKEN>> [<cartella con le SCREEN80K_<TOKEN> del setaccio>]
      python3 -I leggi_deep80k_nuovi.py --autotest
Non decide acquisti. Soglie: S-N, S-M, S-H (+2026 da solo), S-DD, S-NOSCALA, S-COSTO. S-CORR/S-PORT si fanno dopo, a parte."""
import sys, os, re, html, glob, collections, statistics

DEPOSITO = 80000.0
SOGLIE = dict(N=150, M=0.60, DD=10.0, DDM=15.2, RATIO=3.0, MAXPOS=10, COSTO=3.0, MARTI=1.5)
# S-COSTO: spread del tester sull oro ~20 punti = 0,20 USD per oncia, 100 once per lotto, 1 USD = 0,8927 EUR  => ~17,85 EUR per lotto. INFERITO (sonda 14/10 e 24/10), non letto dal report.
SPREAD_EUR_PER_LOTTO = 20 * 0.01 * 100 * 0.8927

def leggi(p):
    b = open(p, 'rb').read()
    for e in ('utf-16', 'utf-8', 'latin-1'):
        try:
            return b.decode(e)
        except Exception:
            pass

def righe(t):
    return [[html.unescape(re.sub(r'<[^>]+>', '', c)).strip().replace('\xa0', ' ')
             for c in re.findall(r'<t[dh][^>]*>(.*?)</t[dh]>', tr, flags=re.S | re.I)]
            for tr in re.findall(r'<tr[^>]*>(.*?)</tr>', t, flags=re.S | re.I)]

def num(x):
    try:
        return float(x.replace(' ', '').replace(',', ''))
    except Exception:
        return 0.0

def affari(R):
    ii = [k for k, r in enumerate(R) if r and r[0] in ('Affari', 'Deals')]
    if not ii:
        return []
    D = []
    for r in R[ii[0] + 2:]:
        if len(r) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d', r[0]) and r[2] != '' and r[3] != 'balance':
            D.append(dict(t=r[0], dir=r[4].lower(), tipo=r[3].lower(), vol=num(r[5]),
                          net=num(r[8]) + num(r[9]) + num(r[10])))
    return D

def mesi21():
    out = []
    for y, m in [(2025, k) for k in range(1, 13)] + [(2026, k) for k in range(1, 10)]:
        out.append('%d.%02d' % (y, m))
    return out

def metriche(D):
    ins = [x for x in D if x['dir'].startswith('in')]
    outs = [x for x in D if x['dir'].startswith('out')]
    mon = {m: 0.0 for m in mesi21()}
    for x in D:
        k = x['t'][:7]
        mon[k] = mon.get(k, 0.0) + x['net']
    tot = sum(x['net'] for x in D)
    pos = sum(1 for m in mesi21() if mon[m] > 0)
    h1 = sum(v for m, v in mon.items() if m <= '2026.05')
    h2 = sum(v for m, v in mon.items() if m >= '2026.06')
    y26 = sum(v for m, v in mon.items() if m >= '2026.01')
    vols = [x['vol'] for x in ins]
    ratio = (max(vols) / min(vols)) if vols and min(vols) > 0 else 0.0
    ev = sorted([(x['t'], 1 if x['dir'].startswith('in') else -1) for x in D], key=lambda z: (z[0], -z[1]))
    k = mx = 0
    for _, e in ev:
        k += e
        mx = max(mx, k)
    # lotto dopo una perdita contro lotto dopo una vincita (indizio di martingala/recupero)
    dopo_p, dopo_v, last = [], [], None
    for x in sorted(D, key=lambda z: (z['t'], 0 if z['dir'].startswith('out') else 1)):
        if x['dir'].startswith('out'):
            last = x['net']
        elif x['dir'].startswith('in') and last is not None:
            (dopo_p if last < 0 else dopo_v).append(x['vol'])
    mp = statistics.mean(dopo_p) if dopo_p else 0.0
    mv = statistics.mean(dopo_v) if dopo_v else 0.0
    marti = (mp / mv) if mv > 0 else 0.0
    lot_med = statistics.mean(vols) if vols else 0.0
    media_op = tot / len(outs) if outs else 0.0
    costo_x = (media_op / (lot_med * SPREAD_EUR_PER_LOTTO)) if lot_med > 0 else 0.0
    peggior_mese_pct = 100 * min(mon.values()) / DEPOSITO
    return dict(ops=len(outs), tot=tot, mesi_pos=pos, h1=h1, h2=h2, y26=y26, ratio=ratio, maxpos=mx,
                marti=marti, lot_med=lot_med, media_op=media_op, costo_x=costo_x,
                peggior_mese_pct=peggior_mese_pct, mon=mon)

def soglie(m, dd_abs):
    """dd_abs = DD equity ASSOLUTO del report, in EUR. Ritorna {soglia: (esito, riga)}; esito True/False/None (NON MISURATO)."""
    S = SOGLIE
    r = {}
    if m['ops'] < S['N']:
        r['S-N'] = (None, 'NON MISURATO: %d operazioni < %d' % (m['ops'], S['N']))
    else:
        r['S-N'] = (True, '%d operazioni' % m['ops'])
    ok = m['mesi_pos'] / 21.0 >= S['M'] and m['tot'] > 0
    r['S-M'] = (ok, '%d/21 mesi positivi, somma %.0f' % (m['mesi_pos'], m['tot']))
    ok = m['h1'] > 0 and m['h2'] > 0
    r['S-H'] = (ok, 'gen25-mag26 %.0f / giu-set26 %.0f   (2026 da solo %.0f)' % (m['h1'], m['h2'], m['y26']))
    pct = 100 * dd_abs / DEPOSITO if dd_abs is not None else None
    if pct is None:
        r['S-DD'] = (None, 'DD non letto')
    else:
        ok = pct <= S['DD'] and -m['peggior_mese_pct'] <= S['DDM']
        r['S-DD'] = (ok, 'DD equity dal picco %.0f EUR = %.2f%% di 80.000 (tetto %.0f%%; dal picco: SOVRASTIMA la perdita dal deposito); peggior mese realizzato %.2f%% (PROXY del DD mensile: sottostima)' % (dd_abs, pct, S['DD'], m['peggior_mese_pct']))
    ok = m['ratio'] <= S['RATIO'] and m['maxpos'] <= S['MAXPOS'] and m['marti'] < S['MARTI']
    r['S-NOSCALA'] = (ok, 'lotto max/min %.2f, posizioni insieme max %d, lotto dopo perdita / dopo vincita %.2f' % (m['ratio'], m['maxpos'], m['marti']))
    ok = m['costo_x'] >= S['COSTO']
    r['S-COSTO'] = (ok, 'media per operazione %.2f EUR = %.1f x lo spread (INFERITO: 20 punti, %.2f EUR/lotto, lotto medio %.2f)' % (m['media_op'], m['costo_x'], SPREAD_EUR_PER_LOTTO, m['lot_med']))
    return r

def esito(r):
    if any(v[0] is None for k, v in r.items() if k == 'S-N'):
        return 'NON MISURATO (poche operazioni)'
    if all(v[0] for v in r.values()):
        return 'CANDIDATO (S-CORR e S-PORT ancora da fare)'
    return 'NON PASSA: ' + ', '.join(k for k, v in r.items() if not v[0])

def manifest(p):
    L = open(p, encoding='ascii', errors='replace').read().splitlines()
    h = L[0].split(';')
    for l in L[1:]:
        q = l.split(';')
        if q[0] == 'TRANCHE22':
            return dict(zip(h, q))
    return {}

def dd_abs_di(s):
    mm = re.match(r'\s*([0-9.]+)\(', s or '')
    return float(mm.group(1)) if mm else None

def input_riga(path):
    if not os.path.exists(path):
        return None
    for l in open(path, encoding='utf-8', errors='replace'):
        if 'TUTTI gli input del report:' in l:
            body = l.split('TUTTI gli input del report:', 1)[1].strip()
            d = {}
            for kv in body.split(' ; '):
                if '=' in kv:
                    a, b = kv.split('=', 1)
                    d[a.strip()] = b.strip()
            return d
    return None

def leggi_cartella(c, cs=None):
    nome = os.path.basename(c.rstrip('/\\'))
    print('=' * 100)
    print(nome)
    M = os.path.join(c, 'MANIFEST_DEEP80K.csv')
    if not os.path.exists(M):
        print('  NESSUN MANIFEST: non letto')
        return None
    mf = manifest(M)
    if not mf:
        print('  nessuna riga TRANCHE22 nel manifest')
        return None
    print('  stato %s  durata %s s  report %s' % (mf.get('stato'), mf.get('durata_s'), mf.get('report')))
    print('  qualita %s  stop_out %s  no_money %s  input_ok %s  motivi: %s' % (mf.get('qualita'), mf.get('stop_out_log'), mf.get('no_money_log'), mf.get('input_ok'), mf.get('motivi') or '-'))
    if mf.get('stato') != 'OK':
        print('  CORSA NON VALIDA: non si legge un numero')
        return None
    rep = os.path.join(c, mf['report'])
    if not os.path.exists(rep):
        rep = os.path.join(c, 'report', mf['report'])  # lo zip del 25/10 ha i report in report\\ (correzione di PERCORSO, nessun criterio cambiato)
    D = affari(righe(leggi(rep)))
    if not D:
        print('  nessun affare letto dal report')
        return None
    m = metriche(D)
    dd = dd_abs_di(mf.get('dd_equita'))
    r = soglie(m, dd)
    print('  profitto del manifest %s  operazioni %s  PF %s  DD equity %s' % (mf.get('profitto'), mf.get('trades'), mf.get('pf'), mf.get('dd_equita')))
    if str(m['ops']) != str(mf.get('trades')):
        print('  ATTENZIONE: operazioni contate dagli affari (%d) diverse dal manifest (%s)' % (m['ops'], mf.get('trades')))
    for k in ('S-N', 'S-M', 'S-H', 'S-DD', 'S-NOSCALA', 'S-COSTO'):
        v = r[k]
        print('  %-10s %-12s %s' % (k, {True: 'OK', False: 'NO', None: 'NON MISURATO'}[v[0]], v[1]))
    print('  mesi:', ' '.join('%s=%.0f' % (a[2:], b) for a, b in sorted(m['mon'].items())))
    print('  ESITO:', esito(r))
    if cs:
        tok = nome.replace('DEEP80K_', '')
        a = input_riga(os.path.join(c, 'REFERTO_DEEP80K_TRANCHE.txt'))
        b = input_riga(os.path.join(cs, 'SCREEN80K_' + tok, 'REFERTO_SCREEN_TRANCHE.txt'))
        if a is None or b is None:
            print('  INPUT: confronto con il setaccio NON POSSIBILE (referto input %s, setaccio %s)' % ('letto' if a else 'assente', 'letto' if b else 'assente'))
        else:
            dif = ['%s: setaccio %s -> test %s' % (k, b.get(k), a.get(k)) for k in sorted(set(a) | set(b)) if a.get(k) != b.get(k)]
            print('  INPUT contro il setaccio: ' + ('IDENTICI (%d input)' % len(a) if not dif else 'DIVERSI (%d): ' % len(dif) + ' | '.join(dif[:8])))
    return m, r

def autotest():
    base = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'TEST80K_20261019', 'DEEP80K_PROPFIRMGOLDEA')
    f = glob.glob(os.path.join(base, '*.htm'))
    ok = 0
    if f:
        m = metriche(affari(righe(leggi(f[0]))))
        # numeri noti dal lettore gr80k_leggi.py (19/10): 673 op, 34129.71, 14/21 mesi, meta 24807.58/9322.13, rapporto lotti 1.94, 3 posizioni insieme
        assert m['ops'] == 673 and abs(m['tot'] - 34129.71) < 0.01 and m['mesi_pos'] == 14, m
        assert abs(m['h1'] - 24807.58) < 0.01 and abs(m['h2'] - 9322.13) < 0.01
        assert abs(m['ratio'] - 1.94) < 0.01 and m['maxpos'] == 3
        r = soglie(m, dd_abs_di(manifest(os.path.join(base, 'MANIFEST_DEEP80K.csv'))['dd_equita']))
        assert r['S-N'][0] is True and r['S-M'][0] is True and r['S-H'][0] is True
        assert r['S-DD'][0] is False, r['S-DD']  # 9.72% del picco ma 11.023 EUR = 13,8% di 80.000
        assert r['S-NOSCALA'][0] is True and r['S-COSTO'][0] is True
        assert esito(r).startswith('NON PASSA: S-DD'), esito(r)
        ok += 1
    # sintetici
    D = [dict(t='2025.01.02 10:00:00', dir='in', tipo='buy', vol=1.0, net=0.0), dict(t='2025.01.02 11:00:00', dir='out', tipo='sell', vol=1.0, net=100.0)]
    m = metriche(D)
    assert m['ops'] == 1 and soglie(m, 100.0)['S-N'][0] is None and esito(soglie(m, 100.0)).startswith('NON MISURATO')
    ok += 1
    # 200 operazioni con lotto che raddoppia dopo ogni perdita: S-NOSCALA deve fallire
    D = []
    lot = 1.0
    for i in range(200):
        d = '2025.%02d.%02d' % (1 + (i // 28) % 12, 1 + i % 28)
        D.append(dict(t=d + ' 10:00:00', dir='in', tipo='buy', vol=lot, net=0.0))
        n = 400.0 if i % 4 == 3 else -50.0
        D.append(dict(t=d + ' 11:00:00', dir='out', tipo='sell', vol=lot, net=n))
        lot = min(lot * 2, 8.0) if n < 0 else 1.0
    m = metriche(D)
    assert m['ratio'] > 3 and m['marti'] > 1.5, m
    assert soglie(m, 100.0)['S-NOSCALA'][0] is False
    ok += 1
    # un EA solido sintetico: 200 operazioni, 21 mesi tutti positivi, DD basso -> CANDIDATO
    D = []
    for i in range(210):
        mi = i % 21
        y, mo = (2025, mi + 1) if mi < 12 else (2026, mi - 11)
        d = '%d.%02d.10' % (y, mo)
        D.append(dict(t=d + ' 10:00:00', dir='in', tipo='buy', vol=0.5, net=0.0))
        D.append(dict(t=d + ' 12:00:00', dir='out', tipo='sell', vol=0.5, net=60.0 if i % 5 else -10.0))
    m = metriche(D)
    r = soglie(m, 2000.0)
    assert esito(r).startswith('CANDIDATO'), (esito(r), r)
    ok += 1
    # DD sopra il tetto
    assert soglie(m, 9000.0)['S-DD'][0] is False
    ok += 1
    assert dd_abs_di('11023.14(9.72%)') == 11023.14 and dd_abs_di('') is None
    ok += 1
    print('AUTOTEST OK (%d gruppi)' % ok)

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest':
        autotest()
        sys.exit(0)
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(2)
    base = sys.argv[1]
    cs = sys.argv[2] if len(sys.argv) > 2 else None
    cart = sorted(d for d in glob.glob(os.path.join(base, 'DEEP80K_*')) if os.path.isdir(d))
    if not cart:
        print('nessuna cartella DEEP80K_* in', base)
        sys.exit(1)
    res = []
    for c in cart:
        res.append((os.path.basename(c), leggi_cartella(c, cs)))
    print('=' * 100)
    print('RIEPILOGO')
    for n, x in res:
        print('  %-40s %s' % (n, esito(x[1]) if x else 'NON LETTO'))
