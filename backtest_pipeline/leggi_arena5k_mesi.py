#!/usr/bin/env python3
"""Lettore CONGELATO di Arena a 5.000 EUR mese per mese. Criteri: report/ARENA_5K_MESI_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_arena5k_mesi.py <cartella-contenitore con le sottocartelle AAAA_MM\\ARENA5K_<TOKEN>>
      python3 -I leggi_arena5k_mesi.py --autotest
SOLA LETTURA, nessun merito. I tre mesi del 15-16/10 sono costanti da report/ARENA_TESTER_TRANCHE_*_LETTURA_2026-10-1*.md."""
import sys, os, re, glob, collections, zipfile, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B

DEPOSITO = 5000.0
# (mese, netto, stop out si/no, DD equity %, fonte)  -- da report/ARENA_TESTER_TRANCHE_LUGLIO/_LETTURA (luglio), _TRANCHE_LETTURA (agosto), _SETTEMBRE_LETTURA
NOTI = [('2026.07', 4800.36, False, 45.93), ('2026.08', -3063.29, True, 67.8), ('2026.09', -2505.06, True, 75.17)]

def metriche(D, deposito=DEPOSITO):
    D = sorted(D, key=lambda x: x['t'])
    bal = deposito; peak = bal; minbal = bal; day = collections.OrderedDict(); dstart = {}
    for x in D:
        d = x['t'][:10]; dstart.setdefault(d, bal); bal += x['net']
        peak = max(peak, bal); minbal = min(minbal, bal); day[d] = day.get(d, 0) + x['net']
    ins = [x for x in D if x['dir'].startswith('in')]; outs = [x for x in D if x['dir'].startswith('out')]
    return dict(ops=len(outs), tot=bal - deposito, pct=100.0 * (bal - deposito) / deposito,
                min_saldo_pct=100.0 * minbal / deposito, peggior_giorno=(min(day.values()) if day else 0.0),
                lotto_max=max([x['vol'] for x in ins], default=0.0))

def dd_rel(s):
    mm = re.search(r'\(([0-9.]+)%\)', s or ''); return float(mm.group(1)) if mm else 0.0

def leggi_mese(c):
    M = glob.glob(os.path.join(c, 'MANIFEST_ARENA5K.csv'))
    if not M: return None
    mf = B.manifest(M[0])
    if not mf: return None
    r = dict(stato=mf.get('stato'), stop_out=int(mf.get('stop_out_log') or 0), no_money=int(mf.get('no_money_log') or 0),
             dd=dd_rel(mf.get('dd_equita')), durata=mf.get('durata_s'), motivi=mf.get('motivi') or '', finestra=mf.get('finestra'), qualita=mf.get('qualita'), input_ok=mf.get('input_ok'))
    if mf.get('stato') == 'OK':
        rep = None
        for cand in (os.path.join(c, 'report', mf['report']), os.path.join(c, mf['report'])):
            if os.path.exists(cand): rep = cand; break
        if rep is None: r['stato'] = 'REPORT ASSENTE'; return r
        r['m'] = metriche(B.affari(B.righe(B.leggi(rep))))
    return r

def stampa(mesi):
    print('mese     stato  ops    netto EUR  %dep    DD eq%  stop out  no money  peggior giorno  lotto max  input')
    tot_so = tot_pos = n = 0
    for mese in sorted(mesi):
        r = mesi[mese]
        if r.get('m'):
            m = r['m']; so = 'SI' if r['stop_out'] > 0 else 'no'
            print('%s  %-5s %6d %10.0f %6.1f %7.1f   %-8s %8d %14.0f %10.2f  %s' % (mese, r['stato'], m['ops'], m['tot'], m['pct'], r['dd'], so, r['no_money'], m['peggior_giorno'], m['lotto_max'], r['input_ok']))
            n += 1; tot_so += 1 if r['stop_out'] > 0 else 0; tot_pos += 1 if m['tot'] > 0 else 0
        else:
            print('%s  %-5s  NON VALIDO/ASSENTE  %s' % (mese, r.get('stato'), r.get('motivi', '')[:120]))
    return n, tot_so, tot_pos

def sintesi(nuovi_ok, nuovi_so, nuovi_pos):
    n = nuovi_ok + len(NOTI); so = nuovi_so + sum(1 for x in NOTI if x[2]); pos = nuovi_pos + sum(1 for x in NOTI if x[1] > 0)
    print('NUOVI mesi validi %d: con stop out %d, positivi %d' % (nuovi_ok, nuovi_so, nuovi_pos))
    print('CON I 3 MESI DEL 15-16/10 (luglio +4.800 senza stop out; agosto -3.063 e settembre -2.505 con stop out): %d mesi, stop out in %d (%.0f%%), mesi positivi %d' % (n, so, 100.0 * so / n if n else 0, pos))

def autotest():
    ok = 0
    z = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'ARENA_TESTER_TRANCHE_20261015_SETTEMBRE', 'ARENA_TESTER_TRANCHE.zip')
    if os.path.exists(z):
        zf = zipfile.ZipFile(z); nome = [n for n in zf.namelist() if n.lower().endswith('.htm') and 'TRANCHE3' in n][0]
        t = tempfile.NamedTemporaryFile(delete=False); t.write(zf.read(nome)); t.close()
        m = metriche(B.affari(B.righe(B.leggi(t.name))))
        assert m['ops'] == 14629 and abs(m['tot'] - (-2505.06)) < 0.01, m  # numeri della lettura del 15/10
        ok += 1
    D = [dict(t='2025.01.02 10:00:00', dir='in', tipo='buy', vol=0.01, net=0.0), dict(t='2025.01.02 12:00:00', dir='out', tipo='sell', vol=0.01, net=-3000.0)]
    m = metriche(D); assert m['ops'] == 1 and abs(m['min_saldo_pct'] - 40.0) < 1e-9 and abs(m['pct'] + 60.0) < 1e-9
    ok += 1
    assert dd_rel('3362.84(67.10%)') == 67.1 and dd_rel('') == 0.0
    ok += 1
    n, so, pos = 3, 1, 2
    print('(autotest: sintesi di prova)'); sintesi(n, so, pos)
    ok += 1
    print('AUTOTEST OK (%d gruppi)' % ok)

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest':
        autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    mesi = {}
    for c in sorted(glob.glob(os.path.join(sys.argv[1], '*', 'ARENA5K_*')) + glob.glob(os.path.join(sys.argv[1], 'ARENA5K_*'))):
        if not os.path.isdir(c): continue
        mm = re.search(r'(20\d\d)[_.]?(\d\d)', c.replace(os.path.basename(c), ''))
        chiave = (mm.group(1) + '.' + mm.group(2)) if mm else os.path.basename(c)
        r = leggi_mese(c)
        mesi[chiave] = r if r else dict(stato='NESSUN MANIFEST')
    if not mesi: print('nessuna cartella ARENA5K_* trovata in', sys.argv[1]); sys.exit(1)
    n, so, pos = stampa(mesi); sintesi(n, so, pos)
