#!/usr/bin/env python3
"""Lettore CONGELATO: quanti giorni ogni EA tocca il DD giornaliero FTMO (SOLO REALIZZATO = limite inferiore). Criteri: report/GIORNI_DD_GIORNALIERO_PROP_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_giorni_dd_prop.py          (legge le corse dell'archivio e stampa la tabella)
      python3 -I leggi_giorni_dd_prop.py --autotest
Giorno FTMO = mezzanotte CE(S)T; server BCM UTC+1 fisso: in estate (CEST) si somma 1 ora all'ora del server. Soglie: 3%, 4%, 5% del saldo a inizio giorno; a 80K anche 4.000 EUR fissi."""
import sys, os, re, glob, gzip, zipfile, tempfile, datetime, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B

ARCH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio')
SOGLIE = (3.0, 4.0, 5.0)
FISSO_80K = 4000.0

def ultima_domenica(anno, mese):
    d = datetime.date(anno, mese, 31 if mese in (3, 10) else 30)
    while d.weekday() != 6: d -= datetime.timedelta(days=1)
    return d

def cest(dt_server):
    """True se in quel momento (ora del server UTC+1) vige l'ora legale CEST."""
    utc = dt_server - datetime.timedelta(hours=1)
    ini = datetime.datetime.combine(ultima_domenica(utc.year, 3), datetime.time(1, 0))
    fin = datetime.datetime.combine(ultima_domenica(utc.year, 10), datetime.time(1, 0))
    return ini <= utc < fin

def giorno_ftmo(t):
    dt = datetime.datetime.strptime(t[:19], '%Y.%m.%d %H:%M:%S')
    if cest(dt): dt += datetime.timedelta(hours=1)
    return dt.date()

def giorni(D, deposito):
    D = sorted(D, key=lambda x: x['t']); bal = float(deposito); out = collections.OrderedDict()
    for x in D:
        g = giorno_ftmo(x['t'])
        if g not in out: out[g] = dict(start=bal, net=0.0, ops=0)
        out[g]['net'] += x['net']; bal += x['net']
        if x['dir'].startswith('out'): out[g]['ops'] += 1
    for g, v in out.items(): v['pct'] = 100.0 * v['net'] / v['start'] if v['start'] else 0.0
    return out

def sintesi(out, deposito, mesi_primi=6):
    ds = [(g, v) for g, v in out.items() if v['ops'] > 0 or v['net'] != 0]
    n = len(ds)
    c = {s: sum(1 for g, v in ds if v['pct'] <= -s) for s in SOGLIE}
    fisso = sum(1 for g, v in ds if v['net'] <= -FISSO_80K) if deposito == 80000 else None
    peggio = min(ds, key=lambda z: z[1]['pct']) if ds else None
    gs = sorted(g for g, v in ds)
    if gs:
        lim = gs[0] + datetime.timedelta(days=183)
        primi = [z for z in ds if z[0] < lim]
        peggio6 = min(primi, key=lambda z: z[1]['pct']) if primi else None
    else:
        peggio6 = None
    oltre5 = [g.isoformat() for g, v in ds if v['pct'] <= -5.0]
    return dict(n=n, c=c, fisso=fisso, peggio=peggio, peggio6=peggio6, oltre5=oltre5)

def carica_htm(path):
    if path.endswith('.gz'):
        t = tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(path, 'rb').read()); t.close(); path = t.name
    return B.affari(B.righe(B.leggi(path)))

def corse():
    """(etichetta, deposito, deals)"""
    L = []
    def da_cartella(base, pref, dep, nome=None):
        for c in sorted(glob.glob(os.path.join(base, pref + '*'))):
            if not os.path.isdir(c): continue
            f = glob.glob(os.path.join(c, 'report', '*.htm')) + glob.glob(os.path.join(c, 'report', '*.htm.gz')) + glob.glob(os.path.join(c, '*.htm'))
            if f: L.append(((nome or '') + os.path.basename(c).replace(pref, ''), dep, carica_htm(f[0])))
    da_cartella(os.path.join(ARCH, 'DEEP80K_MARKET_NUOVI_20261025'), 'DEEP80K_', 80000)
    f = glob.glob(os.path.join(ARCH, 'DEEP80K_SOMAGOLD_20261025', 'report', '*.htm*'))
    if f: L.append(('SOMAGOLD (protezione spenta)', 80000, carica_htm(f[0])))
    for c in sorted(glob.glob(os.path.join(ARCH, 'DEEP80K_GUARDIA_20261025', 'DEEP80K_*'))):
        f = glob.glob(os.path.join(c, 'report', '*.htm*'))
        if f: L.append((os.path.basename(c).replace('DEEP80K_', '') + ' CON GUARDIA venditore', 80000, carica_htm(f[0])))
    da_cartella(os.path.join(ARCH, 'TEST80K_20261019'), 'DEEP80K_', 80000, '19/10 ')
    for lab, z, tag in (('ARENA 2026.07 (5K)', 'ARENA_TESTER_TRANCHE_20261016_LUGLIO', 'TRANCHE1'), ('ARENA 2026.08 (5K)', 'ARENA_TESTER_TRANCHE_20261015', 'TRANCHE2'), ('ARENA 2026.09 (5K)', 'ARENA_TESTER_TRANCHE_20261015_SETTEMBRE', 'TRANCHE3')):
        zp = os.path.join(ARCH, z, 'ARENA_TESTER_TRANCHE.zip')
        if os.path.exists(zp):
            zf = zipfile.ZipFile(zp); n = [x for x in zf.namelist() if x.lower().endswith('.htm') and tag in x]
            if n:
                t = tempfile.NamedTemporaryFile(delete=False); t.write(zf.read(n[0])); t.close()
                L.append((lab, 5000, carica_htm(t.name)))
    return L

def stampa():
    print('%-40s %5s %6s %6s %6s %9s  %-26s %-26s' % ('corsa', 'giorni', '>=3%', '>=4%', '>=5%', '>=4000EUR', 'peggior giorno', 'peggior giorno 6 mesi'))
    for lab, dep, D in corse():
        s = sintesi(giorni(D, dep), dep)
        pg = '%s %.1f%% %.0f' % (s['peggio'][0], s['peggio'][1]['pct'], s['peggio'][1]['net']) if s['peggio'] else '-'
        p6 = '%s %.1f%% %.0f' % (s['peggio6'][0], s['peggio6'][1]['pct'], s['peggio6'][1]['net']) if s['peggio6'] else '-'
        print('%-40s %5d %6d %6d %6d %9s  %-26s %-26s' % (lab[:40], s['n'], s['c'][3.0], s['c'][4.0], s['c'][5.0], '-' if s['fisso'] is None else s['fisso'], pg, p6))
        if s['oltre5']: print('     giorni >= 5%%: %s' % ', '.join(s['oltre5'][:12]) + (' ...' if len(s['oltre5']) > 12 else ''))

def autotest():
    assert cest(datetime.datetime(2026, 7, 1, 12, 0)) and not cest(datetime.datetime(2026, 1, 15, 12, 0))
    assert not cest(datetime.datetime(2026, 3, 29, 1, 59)) and cest(datetime.datetime(2026, 3, 29, 3, 0))   # 29/03/2026 ultima domenica: 01:00 UTC = 02:00 server
    assert cest(datetime.datetime(2026, 10, 25, 1, 30)) and not cest(datetime.datetime(2026, 10, 25, 3, 0))
    assert giorno_ftmo('2026.07.01 23:30:00') == datetime.date(2026, 7, 2)   # estate: +1 ora
    assert giorno_ftmo('2026.01.01 23:30:00') == datetime.date(2026, 1, 1)
    D = [dict(t='2026.01.05 10:00:00', dir='in', tipo='buy', vol=1, net=0.0), dict(t='2026.01.05 11:00:00', dir='out', tipo='sell', vol=1, net=-4100.0),
         dict(t='2026.01.06 10:00:00', dir='in', tipo='buy', vol=1, net=0.0), dict(t='2026.01.06 11:00:00', dir='out', tipo='sell', vol=1, net=200.0)]
    s = sintesi(giorni(D, 80000), 80000)
    assert s['n'] == 2 and s['c'][5.0] == 1 and s['c'][3.0] == 1 and s['fisso'] == 1 and abs(s['peggio'][1]['pct'] + 5.125) < 1e-6
    base = os.path.join(ARCH, 'TEST80K_20261019', 'DEEP80K_PROPFIRMGOLDEA')
    f = glob.glob(os.path.join(base, '*.htm'))
    if f:
        g = giorni(carica_htm(f[0]), 80000)
        assert abs(sum(v['net'] for v in g.values()) - 34129.71) < 0.01
        w = min(g.items(), key=lambda z: z[1]['net'])
        assert str(w[0]) == '2026-02-17' and abs(w[1]['net'] + 2501.65) < 0.01, w   # peggior giorno noto dal lettore del 19/10
    print('AUTOTEST OK')

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    stampa()
