#!/usr/bin/env python3
"""Lettore CONGELATO: 9 EA a 5.000 EUR su tre anni dell'oro (2013 SHORT, 2018 LATERALE, 2020 LONG) + calibrazione 2025 (Modello 1 contro Modello 4).
Criteri: report/TRE_ANNI_REGIMI_5K_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_tre_anni_5k.py <cartella-contenitore con sottocartelle <anno>\\ANNO5K_<TOKEN>> [<cartella DEEP5K_PERSONALE per la calibrazione>]
      python3 -I leggi_tre_anni_5k.py --autotest
SOLA LETTURA. SOLIDO non vuol dire sicuro."""
import sys, os, re, glob, gzip, math, collections, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B
import leggi_regimi_5k as R

ANNI = {'2013': 'SHORT', '2018': 'LATERALE', '2020': 'LONG'}
DEPOSITO = 5000.0
DD_REL_MAX = 25.0
PEGGIOR_MESE_MAX = -10.0
CAL_RAPPORTO = (0.5, 2.0)
CAL_CORR = 0.5
DEFAULT_CAL = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'DEEP5K_PERSONALE_20261026')

def carica(c, prefisso):
    mf = B.manifest(os.path.join(c, 'MANIFEST_%s.csv' % prefisso))
    if not mf: return None, None
    if mf.get('stato') != 'OK': return mf, None
    for cand in (os.path.join(c, 'report', mf['report']), os.path.join(c, mf['report'])):
        if os.path.exists(cand): return mf, B.affari(B.righe(B.leggi(cand)))
        if os.path.exists(cand + '.gz'):
            t = tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(cand + '.gz', 'rb').read()); t.close()
            return mf, B.affari(B.righe(B.leggi(t.name)))
    return mf, None

def dd_rel(s):
    mm = re.search(r'\(([0-9.]+)%\)', s or ''); return float(mm.group(1)) if mm else 0.0

def corr(a, b):
    n = len(a)
    if n < 3: return None
    ma, mb = sum(a) / n, sum(b) / n
    sa = math.sqrt(sum((x - ma) ** 2 for x in a)); sb = math.sqrt(sum((y - mb) ** 2 for y in b))
    if sa == 0 or sb == 0: return None
    return sum((x - ma) * (y - mb) for x, y in zip(a, b)) / (sa * sb)

def calibra(mm1, mm4):
    """mm1/mm4: per_mese dei due modelli sul 2025. Ritorna (esito, motivi, rapporto, correlazione)."""
    # si confrontano i RENDIMENTI mensili (% del saldo a inizio mese), perche il Modello 4 e una corsa unica di 21 mesi che compone e il Modello 1 riparte da 5.000 il 01/01/2025
    t1 = sum(v['ret'] for v in mm1.values()); t4 = sum(v['ret'] for v in mm4.values())
    mesi = sorted(set(mm1) & set(mm4))
    c = corr([mm1[m]['ret'] for m in mesi], [mm4[m]['ret'] for m in mesi])
    mot = []
    if t4 == 0 or (t1 > 0) != (t4 > 0): mot.append('segno della somma dei rendimenti mensili diverso (%.1f%% contro %.1f%%)' % (t1, t4)); rap = None
    else:
        rap = t1 / t4
        if not (CAL_RAPPORTO[0] <= rap <= CAL_RAPPORTO[1]): mot.append('rapporto fra le somme dei rendimenti mensili M1/M4 %.2f fuori da %.1f-%.1f' % (rap, CAL_RAPPORTO[0], CAL_RAPPORTO[1]))
    if c is None or c < CAL_CORR: mot.append('correlazione mensile %s < %.1f' % ('n/d' if c is None else '%.2f' % c, CAL_CORR))
    return ('CALIBRAZIONE OK' if not mot else 'NON ATTENDIBILE'), mot, rap, c

def valuta_anno(mf, mm):
    tot = sum(v['net'] for v in mm.values()); pm = min((v['ret'] for v in mm.values()), default=0.0)
    so = int(mf.get('stop_out_log') or 0); nm = int(mf.get('no_money_log') or 0); dd = dd_rel(mf.get('dd_equita'))
    return dict(net=tot, pct=100.0 * tot / DEPOSITO, pf=mf.get('pf'), dd=dd, so=so, nm=nm, peggior_mese=pm, ops=int(mf.get('trades') or 0))

def solido(anni, cal):
    mot = []
    for a in ('2013', '2018', '2020'):
        v = anni.get(a)
        if v is None: mot.append('anno %s non misurato' % a); continue
        if v['net'] <= 0: mot.append('%s netto %+.0f <= 0' % (a, v['net']))
        if v['dd'] > DD_REL_MAX: mot.append('%s DD relativo %.1f%% > %.0f%%' % (a, v['dd'], DD_REL_MAX))
        if v['so'] > 0: mot.append('%s stop out' % a)
        if v['peggior_mese'] < PEGGIOR_MESE_MAX: mot.append('%s peggior mese %+.1f%% < %.0f%%' % (a, v['peggior_mese'], PEGGIOR_MESE_MAX))
    if cal != 'CALIBRAZIONE OK': mot.append('calibrazione: ' + str(cal))
    return ('SOLIDO-ANNI' if not mot else 'NON SOLIDO-ANNI'), mot

def main(base, cal_dir):
    per = collections.defaultdict(dict); cal = {}
    for c in sorted(glob.glob(os.path.join(base, '*', 'ANNO5K_*')) + glob.glob(os.path.join(base, 'ANNO5K_*'))):
        if not os.path.isdir(c): continue
        a = re.search(r'(20\d\d)', c.replace(os.path.basename(c), ''))
        if not a: continue
        anno = a.group(1); tok = os.path.basename(c).replace('ANNO5K_', '')
        mf, D = carica(c, 'ANNO5K')
        per[tok][anno] = (mf, D)
    ris = {}
    for tok in sorted(per):
        print('=' * 100); print(tok)
        anni = {}; mm25 = None
        for anno in sorted(per[tok]):
            mf, D = per[tok][anno]
            if D is None:
                print('  %s  NON VALIDO/ASSENTE (stato %s) %s' % (anno, mf.get('stato') if mf else '-', (mf.get('motivi') or '')[:120] if mf else '')); continue
            mm = R.per_mese(D, DEPOSITO); v = valuta_anno(mf, mm)
            print('  %s %-8s ops %5d  netto %+9.0f (%+7.1f%%)  PF %s  DD equity %5.1f%%  stop out %d  no money %d  peggior mese %+6.1f%%  qualita: %s' % (anno, ANNI.get(anno, 'CALIBRAZ.'), v['ops'], v['net'], v['pct'], v['pf'], v['dd'], v['so'], v['nm'], v['peggior_mese'], mf.get('qualita')))
            if anno == '2025': mm25 = mm
            else: anni[anno] = v
        esito_cal = 'CALIBRAZIONE NON POSSIBILE (2025 Modello 1 assente)'
        if mm25 is not None and os.path.isdir(cal_dir):
            d4 = os.path.join(cal_dir, 'DEEP5K_' + tok)
            mf4, D4 = carica(d4, 'DEEP5K')
            if D4 is not None:
                mm4 = {m: v for m, v in R.per_mese(D4, DEPOSITO).items() if m.startswith('2025.')}
                # il Modello 4 e' una corsa unica 2025-2026: i saldi di inizio mese compongono su 21 mesi; per un confronto equo si usano i RENDIMENTI mensili e il netto sommato dei soli mesi 2025 riscalato al saldo iniziale 5.000
                r4 = [mm4[m]['ret'] for m in sorted(mm4)]
                esito_cal, mot, rap, c = calibra(mm25, {m: dict(ret=mm4[m]['ret']) for m in mm4})
                print('  CALIBRAZIONE 2025: %s %s (rapporto %s, correlazione %s)' % (esito_cal, '; '.join(mot), 'n/d' if rap is None else '%.2f' % rap, 'n/d' if c is None else '%.2f' % c))
        e, mot = solido(anni, esito_cal)
        print('  ->', e, ('; ' + ' | '.join(mot)) if mot else ''); ris[tok] = e
    print('=' * 100); print('RIEPILOGO')
    for t, e in ris.items(): print('  %-34s %s' % (t, e))

def autotest():
    mk = lambda net, ret: dict(net=net, ret=ret)
    a = {str(i): mk(100.0 * i, float(i)) for i in range(1, 7)}
    b = {str(i): mk(110.0 * i, 1.1 * i) for i in range(1, 7)}
    e, mot, rap, c = calibra(a, b); assert e == 'CALIBRAZIONE OK' and abs(rap - 1 / 1.1) < 1e-9 and c > 0.99, (e, mot, rap, c)
    e, mot, rap, c = calibra(a, {k: mk(-v['net'], -v['ret']) for k, v in a.items()}); assert e == 'NON ATTENDIBILE' and any('segno' in m for m in mot)
    e, mot, rap, c = calibra(a, {k: mk(v['net'], 5 * v['ret']) for k, v in a.items()}); assert e == 'NON ATTENDIBILE' and any('rapporto' in m for m in mot)
    v = lambda net, dd, so, pm: dict(net=net, dd=dd, so=so, peggior_mese=pm)
    ok = {'2013': v(100, 10, 0, -3), '2018': v(50, 8, 0, -2), '2020': v(200, 12, 0, -4)}
    assert solido(ok, 'CALIBRAZIONE OK')[0] == 'SOLIDO-ANNI'
    assert solido(ok, 'NON ATTENDIBILE')[0] == 'NON SOLIDO-ANNI'
    for k, vv in (('2013', v(-1, 10, 0, -3)), ('2018', v(50, 30, 0, -2)), ('2020', v(200, 12, 1, -4)), ('2020', v(200, 12, 0, -11))):
        t = dict(ok); t[k] = vv; assert solido(t, 'CALIBRAZIONE OK')[0] == 'NON SOLIDO-ANNI'
    t = dict(ok); del t['2018']; assert solido(t, 'CALIBRAZIONE OK')[0] == 'NON SOLIDO-ANNI'
    assert corr([1, 2, 3], [2, 4, 6]) > 0.999 and corr([1, 1, 1], [1, 2, 3]) is None
    assert dd_rel('3362.84(67.10%)') == 67.1
    print('AUTOTEST OK')

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    main(sys.argv[1], sys.argv[2] if len(sys.argv) > 2 else DEFAULT_CAL)
