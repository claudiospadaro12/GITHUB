#!/usr/bin/env python3
# =====================================================================
#  sonda_s3b_giudizio.py -- LETTORE CONGELATO di S3b (ABTG_SONDA_BOX2.csv)
#  Criteri: report/SONDE_S3B_CRITERI_2026-10-23.md (scritti prima dei numeri; soglie arbitrarie, scelte dopo S3 e prima di S3b)
#  USO: python3 backtest_pipeline/sonda_s3b_giudizio.py <cartella o file ABTG_SONDA_BOX2.csv> | --autotest
# =====================================================================
import csv, os, sys, tempfile, statistics
def leggi(p):
    if os.path.isdir(p): p = os.path.join(p, 'ABTG_SONDA_BOX2.csv')
    with open(p, newline='', encoding='utf-8-sig') as f: return list(csv.DictReader(f, delimiter=';'))
def quota(rows):
    ok = [r for r in rows if int(r['n_nom']) >= 1]
    ch = [r for r in ok if r['cambia_alto'] == '1' or r['cambia_basso'] == '1']
    return ok, ch
def giudica(rows):
    ok, ch = quota(rows)
    if not ok: return 'S3b: NESSUN GIORNO VALIDO'
    q = 100.0 * len(ch) / len(ok)
    rel = [100.0 * max(float(r['delta_alto']), float(r['delta_basso'])) / float(r['ampiezza_nom']) for r in ch if float(r['ampiezza_nom']) > 0]
    med = statistics.median(rel) if rel else 0.0
    out = ['S3b: %d giorni validi (n_nom>=1) su %d; la barra della sera cambia il box in %d (%.1f%%); mediana del cambio fra questi %.1f%% dell\'ampiezza nominale' % (len(ok), len(rows), len(ch), q, med)]
    ca = sum(1 for r in ch if r['cambia_alto'] == '1'); cb = sum(1 for r in ch if r['cambia_basso'] == '1')
    out.append('   di cui sul massimo %d, sul minimo %d' % (ca, cb))
    lun = [r for r in ok if r['dow'] == '1']; alt = [r for r in ok if r['dow'] != '1']
    ql = 100.0 * sum(1 for r in lun if r['cambia_alto'] == '1' or r['cambia_basso'] == '1') / len(lun) if lun else 0.0
    qa = 100.0 * sum(1 for r in alt if r['cambia_alto'] == '1' or r['cambia_basso'] == '1') / len(alt) if alt else 0.0
    out.append('   quota lunedi %.1f%% (%d giorni) contro mar-ven %.1f%% (%d giorni): il lunedi e DIVERSO = %s' % (ql, len(lun), qa, len(alt), 'SI' if (ql >= 10.0 and (qa == 0 and ql > 0 or ql >= 2.0 * qa)) else 'NO'))
    ano = [r['data'] + '(n_nom=' + r['n_nom'] + ')' for r in rows if int(r['n_nom']) < 100]
    out.append('   giorni anomali (n_nom < 100): %d %s' % (len(ano), ano[:12]))
    out.append('   -> ' + ('MATERIALE' if (q >= 10.0 and med >= 5.0) else 'NON MATERIALE'))
    return '\n'.join(out)
def autotest():
    d = tempfile.mkdtemp(); p = os.path.join(d, 'ABTG_SONDA_BOX2.csv')
    cols = 'data;dow;n_cont;t_cont;hi_cont;lo_cont;n_nom;hi_box;lo_box;hi_nom;lo_nom;cambia_alto;cambia_basso;delta_alto;delta_basso;ampiezza_nom'.split(';')
    def g(righe):
        with open(p, 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow(cols)
            for i, (dow, ca, cb, da, db, nn) in enumerate(righe):
                w.writerow(['2026.01.%02d' % (i + 1), dow, 1, '', 0, 0, nn, 0, 0, 0, 0, ca, cb, da, db, 100.0])
        return giudica(leggi(p))
    pul = [(2, 0, 0, 0, 0, 300)] * 10
    assert g(pul).endswith('NON MATERIALE')
    assert g([(2, 1, 0, 6, 0, 300)] + pul[:9]).endswith('-> MATERIALE')                      # 10% dei giorni, mediana 6%
    assert g([(2, 1, 0, 2, 0, 300)] + pul[:9]).endswith('NON MATERIALE')                     # 10% ma mediana 2%
    assert g([(2, 1, 0, 9, 0, 300)] + pul[:19]).endswith('NON MATERIALE')                    # 5% dei giorni
    r = g([(1, 1, 0, 9, 0, 300)] * 3 + [(1, 0, 0, 0, 0, 300)] * 2 + pul)                     # lunedi 60% contro 0%
    assert 'DIVERSO = SI' in r, r
    r = g([(1, 1, 0, 9, 0, 300), (2, 1, 0, 9, 0, 300)] * 3 + [(1, 0, 0, 0, 0, 300), (2, 0, 0, 0, 0, 300)] * 3)   # stessa quota
    assert 'DIVERSO = NO' in r, r
    assert 'n_nom=7' in g([(1, 0, 0, 0, 0, 7)] + pul), 'anomalo'
    print('AUTOTEST S3b: 7 casi OK')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    print(giudica(leggi(sys.argv[1]))); print('\nNon promuove niente. Soglie arbitrarie. Un solo terminale, una sola finestra di storia.')
