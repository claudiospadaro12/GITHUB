#!/usr/bin/env python3
# =====================================================================
#  sonde_giudizio.py -- LETTORE CONGELATO delle sonde S1/S2/S3 (mql5/Scripts/ABTG_SondeAperture.mq5)
#  Criteri: report/SONDE_SENZA_MACCHINA_CRITERI_2026-10-23.md (scritti prima dei numeri). Soglie ARBITRARIE.
#  USO: python3 backtest_pipeline/sonde_giudizio.py <cartella con ABTG_SONDA_SPX.csv, ABTG_SONDA_ORB.csv, ABTG_SONDA_BOX.csv> | --autotest
# =====================================================================
import csv, os, sys, tempfile, statistics, datetime
XETRA_CHIUSA = {'2025.12.24','2025.12.25','2025.12.26','2025.12.31','2026.01.01','2026.04.03','2026.04.06','2026.05.01'}
def leggi(p):
    with open(p, newline='', encoding='utf-8-sig') as f: return list(csv.DictReader(f, delimiter=';'))
def s1(rows):
    if not rows: return 'S1: NESSUN DATO'
    imm_ko = [r for r in rows if r['handle_ok'] != '1' or r['imm_ok'] != '1']
    mai = [r for r in rows if r['handle_ok'] == '1' and r['pronto_ok'] != '1']
    div = [r for r in rows if r['pronto_ok'] == '1' and r['bias_pronto'] != r['bias_mano'] and float(r['gap_rel']) > 0.0005]
    ms = [int(r['ms_pronto']) for r in rows if r['pronto_ok'] == '1']
    out = ['S1 filtro S&P: %d iterazioni; lettura immediata FALLITA in %d; mai pronto entro l\'attesa in %d; ms al pronto mediana %s' % (len(rows), len(imm_ko), len(mai), (statistics.median(ms) if ms else 'n/d'))]
    out.append('   FAIL-OPEN RIPRODUCIBILE: ' + ('SI' if imm_ko else 'NO') + '   CALCOLO DIVERGENTE: ' + ('SI (%d iter.)' % len(div) if div else 'NO'))
    if not imm_ko and not div: out.append('   -> NESSUN DIFETTO RIPRODUCIBILE (non esclude il live: cache MT5 diversa)')
    return '\n'.join(out)
def s2(rows):
    ok = [r for r in rows if r['completo'] == '1']
    if not ok: return 'S2: NESSUN GIORNO COMPLETO'
    ext = []
    for r in ok:
        amp = float(r['ampiezza']); e = max(float(r['ext_su']), float(r['ext_giu']))
        ext.append((e, amp))
    est = [(e, a) for e, a in ext if e > 0]
    quota = 100.0 * len(est) / len(ok)
    med = statistics.median([100.0 * e / a for e, a in est]) if est else 0.0
    mat = quota >= 10.0 and med >= 5.0
    return ('S2 barra di fine range ORB: %d giorni completi su %d; la barra estende il range in %d (%.1f%%); mediana estensione fra questi %.1f%% dell\'ampiezza\n'
            '   (LIMITE SUPERIORE: l\'EA vede la barra solo nei primi secondi) -> %s') % (len(ok), len(rows), len(est), quota, med, 'MATERIALE' if mat else 'NON MATERIALE')
def s3(rows):
    if not rows: return 'S3: NESSUN DATO'
    cont = [r for r in rows if r['contaminato'] == '1']; altri = [r for r in rows if r['contaminato'] != '1']
    quota = 100.0 * len(cont) / len(rows)
    mc = statistics.median([float(r['ampiezza']) for r in cont]) if cont else 0.0
    ma = statistics.median([float(r['ampiezza']) for r in altri]) if altri else 0.0
    rel = (mc / ma - 1.0) * 100.0 if (cont and ma > 0) else 0.0
    mat = quota >= 10.0 or (cont and rel >= 20.0)
    byd = {}
    for r in rows: byd.setdefault(r['dow'], [0, 0]); byd[r['dow']][0] += 1; byd[r['dow']][1] += (r['contaminato'] == '1')
    # giorno dopo un festivo Xetra della lista (primo giorno di sonda successivo)
    dopo = set()
    for d in XETRA_CHIUSA:
        dt = datetime.datetime.strptime(d, '%Y.%m.%d').date()
        for k in range(1, 6):
            n = dt + datetime.timedelta(days=k)
            if n.weekday() < 5 and n.strftime('%Y.%m.%d') not in XETRA_CHIUSA: dopo.add(n.strftime('%Y.%m.%d')); break
    rd = [r for r in rows if r['data'].replace('-', '.') in dopo]
    out = ['S3 box notturno MaxMin: %d giorni; contaminati %d (%.1f%%); ampiezza mediana contaminati %.1f contro altri %.1f (%+.0f%%)' % (len(rows), len(cont), quota, mc, ma, rel)]
    out.append('   per giorno della settimana (1=lun): ' + ', '.join('%s: %d/%d' % (k, v[1], v[0]) for k, v in sorted(byd.items())))
    out.append('   giorni dopo un festivo Xetra della lista: %d, contaminati %d' % (len(rd), sum(1 for r in rd if r['contaminato'] == '1')))
    out.append('   -> ' + ('MATERIALE' if mat else 'NON MATERIALE'))
    return '\n'.join(out)
def giudica(cart):
    out = []
    for f, fn in (('ABTG_SONDA_SPX.csv', s1), ('ABTG_SONDA_ORB.csv', s2), ('ABTG_SONDA_BOX.csv', s3)):
        p = os.path.join(cart, f)
        out.append(fn(leggi(p)) if os.path.exists(p) else '%s: FILE MANCANTE' % f)
    return '\n'.join(out)
def autotest():
    d = tempfile.mkdtemp()
    def scrivi(nome, righe, cols):
        with open(os.path.join(d, nome), 'w', newline='') as f:
            w = csv.writer(f, delimiter=';'); w.writerow(cols); w.writerows(righe)
    cs1 = 'iter;handle_ok;imm_f;imm_s;imm_ok;ms_pronto;pronto_ok;f_pronto;s_pronto;bias_pronto;f_mano;s_mano;bias_mano;gap_rel'.split(';')
    scrivi('ABTG_SONDA_SPX.csv', [[i, 1, 1, 1, 1, 100, 1, 2, 1, 1, 2, 1, 1, 0.01] for i in range(5)], cs1)
    assert 'NESSUN DIFETTO' in s1(leggi(os.path.join(d, 'ABTG_SONDA_SPX.csv')))
    scrivi('ABTG_SONDA_SPX.csv', [[1, 1, 0, 0, 0, 200, 1, 2, 1, 1, 2, 1, 1, 0.01]], cs1)
    assert 'FAIL-OPEN RIPRODUCIBILE: SI' in s1(leggi(os.path.join(d, 'ABTG_SONDA_SPX.csv')))
    scrivi('ABTG_SONDA_SPX.csv', [[1, 1, 1, 1, 1, 200, 1, 2, 1, 1, 1, 2, -1, 0.01]], cs1)
    assert 'DIVERGENTE: SI' in s1(leggi(os.path.join(d, 'ABTG_SONDA_SPX.csv')))
    c2 = 'data;dow;n_barre;prima;ultima;hiR;loR;hiBarra;loBarra;ext_su;ext_giu;ampiezza;completo'.split(';')
    def g2(ext):   # ext: lista di (ext_su, ext_giu) per i giorni, ampiezza 100
        scrivi('o.csv', [['2026.01.%02d' % (i + 1), 1, 16, 0, 0, 0, 0, 0, 0, e[0], e[1], 100, 1] for i, e in enumerate(ext)], c2)
        return s2(leggi(os.path.join(d, 'o.csv')))
    assert g2([(0, 0)] * 8 + [(3, 0), (0, 8)]).endswith('-> MATERIALE')          # 20% dei giorni, mediana 5,5%
    assert g2([(0, 0)] * 9 + [(3, 0)]).endswith('-> NON MATERIALE')              # 10% dei giorni, mediana 3%
    assert g2([(0, 0)] * 19 + [(9, 0)]).endswith('-> NON MATERIALE')             # 5% dei giorni
    c3 = 'data;dow;t_inizio_richiesto;t_barra_inizio;contaminato;n_barre;hi;lo;ampiezza'.split(';')
    def g3(cont_n, tot, ampc):
        rows = [['2026.02.%02d' % (i + 1), 1 + (i % 5), '', '', (1 if i < cont_n else 0), 300, 0, 0, (ampc if i < cont_n else 100)] for i in range(tot)]
        scrivi('b.csv', rows, c3); return s3(leggi(os.path.join(d, 'b.csv')))
    assert g3(1, 10, 130).endswith('-> MATERIALE')                                # 10% contaminati
    assert g3(1, 20, 105).endswith('-> NON MATERIALE')                            # 5%, ampiezza +5%
    assert g3(1, 20, 125).endswith('-> MATERIALE')                                # 5% ma ampiezza +25%
    print('AUTOTEST sonde: 9 casi OK (S1 pulito/fail-open/divergente, S2 x3, S3 x3)')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) != 2: print(__doc__); sys.exit(2)
    print(giudica(sys.argv[1]))
    print('\nNon promuove niente. Soglie arbitrarie. Un solo terminale, una sola finestra di storia.')
