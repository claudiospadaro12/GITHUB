#!/usr/bin/env python3
"""Lettore CONGELATO del test a 5.000 EUR (conto personale, senza guardiano). Criteri: report/MARKET_CONTO_PERSONALE_5K_CRITERI_2026-10-25.md
Uso:  python3 -I leggi_deep5k_personale.py <cartella con le DEEP5K_<TOKEN>>
      python3 -I leggi_deep5k_personale.py --autotest
Etichette BRUCIATO / SCOSSO / REGGE (+ PERDE) sono ORDINAMENTO DI LETTURA, non consigli ne soglie di acquisto."""
import sys, os, re, glob, gzip, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B

SOGLIA_BRUC_SALDO = 0.50   # saldo realizzato minimo <= 50% del deposito
SOGLIA_BRUC_DD = 50.0      # DD equity relativo >= 50%
SOGLIA_SCOSSO_DD = 25.0
SOGLIA_SCOSSO_POS = 10
LOTTO_MIN = 0.01
ARCH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio')
CONFRONTO_80K = [os.path.join(ARCH, 'DEEP80K_MARKET_NUOVI_20261025'), os.path.join(ARCH, 'DEEP80K_SOMAGOLD_20261025')]

def metriche(D, deposito):
    D = sorted(D, key=lambda x: x['t'])
    bal = float(deposito); peak = bal; rel = 0.0; minbal = bal
    dstart = {}; day = collections.OrderedDict(); mstart = {}; mon = collections.OrderedDict()
    strk = mstrk = 0
    for x in D:
        d = x['t'][:10]; m = x['t'][:7]
        dstart.setdefault(d, bal); mstart.setdefault(m, bal)
        bal += x['net']
        peak = max(peak, bal); rel = max(rel, (peak - bal) / peak * 100); minbal = min(minbal, bal)
        day[d] = day.get(d, 0) + x['net']; mon[m] = mon.get(m, 0) + x['net']
        if x['dir'].startswith('out'):
            if x['net'] < 0:
                strk += 1; mstrk = max(mstrk, strk)
            else:
                strk = 0
    ins = [x for x in D if x['dir'].startswith('in')]
    outs = [x for x in D if x['dir'].startswith('out')]
    primi = [x['vol'] for x in ins if x['t'][:7] <= '2025.03']
    tutti = [x['vol'] for x in ins]
    q = lambda v: (100.0 * sum(1 for a in v if a <= LOTTO_MIN + 1e-9) / len(v)) if v else 0.0
    ev = sorted([(x['t'], 1 if x['dir'].startswith('in') else -1) for x in D], key=lambda z: (z[0], -z[1]))
    k = mx = 0
    for _, e in ev:
        k += e; mx = max(mx, k)
    return dict(ops=len(outs), tot=bal - deposito, bal=bal, saldo_x=bal / deposito, netto_pct=100.0 * (bal - deposito) / deposito,
                rel_real=rel, min_saldo_pct=100.0 * minbal / deposito,
                peggior_giorno=min((day[d] / dstart[d] * 100 for d in day), default=0.0),
                peggior_mese=min((mon[m] / mstart[m] * 100 for m in mon), default=0.0),
                strisc=mstrk, maxpos=mx, quota_min_primi=q(primi), quota_min_tutti=q(tutti),
                lotto_primi=(sum(primi) / len(primi)) if primi else 0.0, lotto_ultimi=(lambda v: sum(v) / len(v) if v else 0.0)([x['vol'] for x in ins if x['t'][:7] >= '2026.07']))

def etichetta(m, stop_out, no_money, dd_rel_eq):
    if stop_out > 0 or m['min_saldo_pct'] <= 100 * SOGLIA_BRUC_SALDO or dd_rel_eq >= SOGLIA_BRUC_DD:
        e = 'BRUCIATO'
    elif dd_rel_eq >= SOGLIA_SCOSSO_DD or no_money > 0 or m['maxpos'] > SOGLIA_SCOSSO_POS:
        e = 'SCOSSO'
    else:
        e = 'REGGE'
    if m['tot'] <= 0:
        e += ' + PERDE'
    return e

def dd_rel(s):
    mm = re.search(r'\(([0-9.]+)%\)', s or '')
    return float(mm.group(1)) if mm else 0.0

def leggi_rep(c, mf):
    for rep in (os.path.join(c, 'report', mf['report']), os.path.join(c, mf['report'])):
        if os.path.exists(rep):
            return B.affari(B.righe(B.leggi(rep)))
        if os.path.exists(rep + '.gz'):  # archivio: report compresso (correzione di PERCORSO del 26/10, nessun criterio toccato)
            import tempfile
            b = gzip.open(rep + '.gz', 'rb').read()
            t = tempfile.NamedTemporaryFile(delete=False); t.write(b); t.close()
            return B.affari(B.righe(B.leggi(t.name)))
    raise FileNotFoundError(mf['report'])

def confronto80k(tok):
    for base in CONFRONTO_80K:
        for cand in (os.path.join(base, 'DEEP80K_' + tok), base):
            mpath = os.path.join(cand, 'MANIFEST_DEEP80K.csv')
            if os.path.exists(mpath) and tok in cand.upper().replace('_', ''):
                mf = B.manifest(mpath)
                if mf and mf.get('stato') == 'OK':
                    return dict(netto_pct=100.0 * float(mf['profitto']) / 80000.0, dd_rel=dd_rel(mf['dd_equita']))
    return None

def leggi_cartella(c):
    nome = os.path.basename(c.rstrip('/\\')); tok = nome.replace('DEEP5K_', '')
    print('=' * 100); print(nome)
    M = os.path.join(c, 'MANIFEST_DEEP5K.csv')
    if not os.path.exists(M):
        print('  NESSUN MANIFEST'); return None
    mf = B.manifest(M)
    if not mf:
        print('  nessuna riga TRANCHE22'); return None
    print('  stato %s  durata %s s  qualita %s  stop_out %s  no_money %s  input_ok %s  motivi: %s' % (mf.get('stato'), mf.get('durata_s'), mf.get('qualita'), mf.get('stop_out_log'), mf.get('no_money_log'), mf.get('input_ok'), mf.get('motivi') or '-'))
    if mf.get('stato') != 'OK':
        print('  CORSA NON VALIDA: non si legge un numero'); return None
    m = metriche(leggi_rep(c, mf), 5000.0)
    so = int(mf.get('stop_out_log') or 0); nm = int(mf.get('no_money_log') or 0); ddr = dd_rel(mf.get('dd_equita'))
    e = etichetta(m, so, nm, ddr)
    print('  operazioni %d (manifest %s)  netto %+.0f EUR = %+.1f%% del deposito  saldo %.2fx  PF %s' % (m['ops'], mf.get('trades'), m['tot'], m['netto_pct'], m['saldo_x'], mf.get('pf')))
    print('  DD equity dal picco %s   DD relativo sul realizzato %.1f%%   saldo realizzato minimo %.0f%% del deposito' % (mf.get('dd_equita'), m['rel_real'], m['min_saldo_pct']))
    print('  peggior giorno %.1f%%   peggior mese %.1f%%   perdite di fila %d   posizioni insieme max %d' % (m['peggior_giorno'], m['peggior_mese'], m['strisc'], m['maxpos']))
    print('  ingressi al lotto minimo 0,01: primi 3 mesi %.0f%%, tutto il periodo %.0f%%   lotto medio primi 3 mesi %.3f, ultimi 3 mesi %.3f' % (m['quota_min_primi'], m['quota_min_tutti'], m['lotto_primi'], m['lotto_ultimi']))
    cf = confronto80k(tok)
    if cf:
        print('  CONFRONTO 80.000: netto %+.1f%% (a 5.000: %+.1f%%)   DD relativo %.1f%% (a 5.000: %.1f%%)' % (cf['netto_pct'], m['netto_pct'], cf['dd_rel'], ddr))
    else:
        print('  confronto con 80.000: NON TROVATO')
    print('  ETICHETTA:', e)
    return dict(m=m, e=e, cf=cf, ddr=ddr, so=so, nm=nm)

def autotest():
    ok = 0
    base = os.path.join(ARCH, 'TEST80K_20261019', 'DEEP80K_PROPFIRMGOLDEA')
    f = glob.glob(os.path.join(base, '*.htm'))
    if f:
        m = metriche(B.affari(B.righe(B.leggi(f[0]))), 80000.0)
        assert m['ops'] == 673 and abs(m['tot'] - 34129.71) < 0.01 and m['maxpos'] == 3, m
        assert abs(m['netto_pct'] - 100 * 34129.71 / 80000) < 0.01
        assert m['min_saldo_pct'] > 90
        ok += 1
    mm = dict(tot=100, min_saldo_pct=100, maxpos=1)
    assert etichetta(mm, 0, 0, 10) == 'REGGE'
    assert etichetta(mm, 1, 0, 10) == 'BRUCIATO'
    assert etichetta(mm, 0, 0, 60) == 'BRUCIATO'
    assert etichetta(dict(tot=100, min_saldo_pct=40, maxpos=1), 0, 0, 10) == 'BRUCIATO'
    assert etichetta(mm, 0, 0, 30) == 'SCOSSO' and etichetta(mm, 0, 3, 5) == 'SCOSSO'
    assert etichetta(dict(tot=100, min_saldo_pct=100, maxpos=11), 0, 0, 5) == 'SCOSSO'
    assert etichetta(dict(tot=-5, min_saldo_pct=95, maxpos=1), 0, 0, 5) == 'REGGE + PERDE'
    ok += 1
    D = []
    for i in range(10):
        d = '2025.01.%02d' % (i + 2)
        D.append(dict(t=d + ' 10:00:00', dir='in', tipo='buy', vol=0.01, net=0.0))
        D.append(dict(t=d + ' 12:00:00', dir='out', tipo='sell', vol=0.01, net=-100.0 if i < 8 else 50.0))
    m = metriche(D, 1000.0)
    assert m['ops'] == 10 and m['strisc'] == 8 and abs(m['tot'] + 700) < 1e-6 and abs(m['min_saldo_pct'] - 20.0) < 1e-6, m
    assert m['quota_min_primi'] == 100.0 and etichetta(m, 0, 0, 10).startswith('BRUCIATO')
    ok += 1
    assert dd_rel('1000.00(9.72%)') == 9.72 and dd_rel('') == 0.0
    ok += 1
    print('AUTOTEST OK (%d gruppi)' % ok)

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest':
        autotest(); sys.exit(0)
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(2)
    cart = sorted(d for d in glob.glob(os.path.join(sys.argv[1], 'DEEP5K_*')) if os.path.isdir(d))
    if not cart:
        print('nessuna cartella DEEP5K_* in', sys.argv[1]); sys.exit(1)
    res = [(os.path.basename(c), leggi_cartella(c)) for c in cart]
    print('=' * 100); print('RIEPILOGO')
    for n, r in res:
        print('  %-36s %s' % (n, (r['e'] + ('  netto %+.0f%%  DDrel %.1f%%' % (r['m']['netto_pct'], r['ddr']))) if r else 'NON LETTO'))
