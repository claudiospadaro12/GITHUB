#!/usr/bin/env python3
"""Lettore CONGELATO: Gold Reaper, Goldbot One, Prop Firm Gold a 80.000 EUR su 2013/2018/2020 + calibrazione 2025. Criteri: report/TRE_ANNI_PROP_80K_3EA_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_tre_anni_80k.py <cartella-contenitore con sottocartelle <anno>_M<modello>\\ANNO80K_<TOKEN>>
      python3 -I leggi_tre_anni_80k.py --autotest
SOLA LETTURA. PROP-ANNI non vuol dire sicuro."""
import sys, os, re, glob, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B
import leggi_regimi_5k as R
import leggi_tre_anni_5k as T
import leggi_giorni_dd_prop as G
DEP = 80000.0
DD_MAX_EUR = 8000.0
ARCH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio')
ANNI = {'2013': 'SHORT', '2018': 'LATERALE', '2020': 'LONG'}
# riferimento Modello 4 gia in repo (primi 12 mesi di una corsa continua da 80.000 il 01/01/2025); Goldbot One: dalla corsa 2025_M4 di questa riga
REF_M4 = {'GOLDREAPER': ('GR80K_20261020', None), 'PROPFIRM': ('TEST80K_20261019/DEEP80K_PROPFIRMGOLDEA', None)}

ETICHETTA = re.compile(r'^finestra girata XAUUSD\|Daily\|(\d{4}\.\d\d\.\d\d)\|00:00\|(\d{4}\.\d\d\.\d\d)\|00:00 invece di XAUUSD,D1 (\d{4}\.\d\d\.\d\d)-(\d{4}\.\d\d\.\d\d)$')

def solo_etichetta_daily(motivi):
    """Correzione DICHIARATA del 26/10 (errore di etichetta dello script v1: il tester scrive Daily, lo script cercava D1): la corsa si legge solo se l'UNICO motivo del KO e questo e le date coincidono. Nessun altro criterio e toccato."""
    m = ETICHETTA.match((motivi or '').strip())
    return bool(m) and m.group(1) == m.group(3) and m.group(2) == m.group(4)

def carica(c, prefisso):
    mf, D = T.carica(c, prefisso)
    if D is not None or not mf or mf.get('stato') != 'KO' or not solo_etichetta_daily(mf.get('motivi')): return mf, D
    mf2 = dict(mf); mf2['stato'] = 'OK'; mf2['_etichetta_daily'] = '1'
    for cand in (os.path.join(c, 'report', mf['report']), os.path.join(c, mf['report'])):
        if os.path.exists(cand): return mf2, B.affari(B.righe(B.leggi(cand)))
        if os.path.exists(cand + '.gz'): return mf2, G.carica_htm(cand + '.gz')
    return mf, None

def dd_eur(s):
    mm = re.match(r'\s*([0-9.]+)', s or ''); return float(mm.group(1)) if mm else 0.0

def valuta_anno(mf, D):
    g = G.giorni(D, DEP); ds = [(k, v) for k, v in g.items() if v['ops'] > 0 or v['net'] != 0]
    mm = R.per_mese(D, DEP); tot = sum(v['net'] for v in mm.values()); peg = min(ds, key=lambda z: z[1]['pct']) if ds else None
    return dict(net=tot, pct=100.0 * tot / DEP, pf=mf.get('pf'), dd=dd_eur(mf.get('dd_equita')), so=int(mf.get('stop_out_log') or 0), nm=int(mf.get('no_money_log') or 0),
                d3=sum(1 for _, v in ds if v['pct'] <= -3), d4=sum(1 for _, v in ds if v['pct'] <= -4), d5=sum(1 for _, v in ds if v['pct'] <= -5),
                peggio=(peg[1]['pct'], peg[1]['net']) if peg else (0.0, 0.0), peggior_mese=min((v['ret'] for v in mm.values()), default=0.0), ops=int(mf.get('trades') or 0))

def prop_anni(anni, cal):
    mot = []
    for a in ('2013', '2018', '2020'):
        v = anni.get(a)
        if v is None: mot.append('anno %s non misurato' % a); continue
        if v['net'] <= 0: mot.append('%s netto %+.0f <= 0' % (a, v['net']))
        if v['dd'] > DD_MAX_EUR: mot.append('%s DD equity %.0f EUR > %.0f' % (a, v['dd'], DD_MAX_EUR))
        if v['so'] > 0: mot.append('%s stop out' % a)
        if v['d5'] > 0: mot.append('%s %d giorni con perdita realizzata >= 5%%' % (a, v['d5']))
    if cal != 'CALIBRAZIONE OK': mot.append('calibrazione: ' + str(cal))
    return ('PROP-ANNI' if not mot else 'NON PROP-ANNI'), mot

def riferimento_m4(tok, base):
    suf = tok.split('|', 1)[1] if '|' in tok else ''
    if suf:
        m4 = glob.glob(os.path.join(base, '2025_M4_' + suf, 'ANNO80K_*'))
        if m4:
            mf, D = carica(m4[0], 'ANNO80K'); return D
        return None
    for k, (path, _) in REF_M4.items():
        if k in tok:
            c = os.path.join(ARCH, path)
            f = glob.glob(os.path.join(c, '*.htm')) + glob.glob(os.path.join(c, 'report', '*.htm*'))
            if f: return G.carica_htm(f[0])
    m4 = glob.glob(os.path.join(base, '2025_M4', 'ANNO80K_' + tok))
    if m4:
        mf, D = carica(m4[0], 'ANNO80K'); return D
    return None

def main(base):
    per = collections.defaultdict(dict)
    for c in sorted(glob.glob(os.path.join(base, '*', 'ANNO80K_*'))):
        if not os.path.isdir(c): continue
        sub = os.path.basename(os.path.dirname(c)); a = re.match(r'(20\d\d)_M(\d)', sub)
        if not a: continue
        mf, D = carica(c, 'ANNO80K'); suf = re.sub(r'^20\d\d_M\d_?', '', sub)  # corse con piu set per EA (My AI Gold): la cartella porta il nome del set
        per[os.path.basename(c).replace('ANNO80K_', '') + ('|' + suf if suf else '')][(a.group(1), a.group(2))] = (mf, D)
    ris = {}
    for tok in sorted(per):
        print('=' * 110); print(tok); anni = {}; mm25 = None
        for (anno, mod) in sorted(per[tok]):
            mf, D = per[tok][(anno, mod)]
            if D is None: print('  %s M%s NON VALIDO/ASSENTE (stato %s) %s' % (anno, mod, mf.get('stato') if mf else '-', (mf.get('motivi') or '')[:120] if mf else '')); continue
            v = valuta_anno(mf, D)
            print('  %s M%s %-9s ops %5d  netto %+9.0f (%+6.1f%%)  PF %s  DD equity %7.0f EUR  stop out %d no money %d  gg>=3%% %d >=4%% %d >=5%% %d  peggior giorno %+.1f%% (%+.0f)  peggior mese %+.1f%%' % (anno, mod, ANNI.get(anno, 'CALIBRAZ.'), v['ops'], v['net'], v['pct'], v['pf'], v['dd'], v['so'], v['nm'], v['d3'], v['d4'], v['d5'], v['peggio'][0], v['peggio'][1], v['peggior_mese']))
            if anno == '2025' and mod == '1': mm25 = R.per_mese(D, DEP)
            elif anno != '2025': anni[anno] = v
        esito_cal = 'CALIBRAZIONE NON POSSIBILE (2025 Modello 1 assente)'
        if mm25 is not None:
            D4 = riferimento_m4(tok, base)
            if D4:
                mm4 = {m: v for m, v in R.per_mese(D4, DEP).items() if m.startswith('2025.')}
                esito_cal, mot, rap, c = T.calibra(mm25, {m: dict(ret=mm4[m]['ret']) for m in mm4})
                print('  CALIBRAZIONE 2025: %s %s (rapporto %s, correlazione %s)' % (esito_cal, '; '.join(mot), 'n/d' if rap is None else '%.2f' % rap, 'n/d' if c is None else '%.2f' % c))
            else: esito_cal = 'CALIBRAZIONE NON POSSIBILE (nessun Modello 4 di riferimento)'
        e, mot = prop_anni(anni, esito_cal); print('  ->', e, ('; ' + ' | '.join(mot)) if mot else ''); ris[tok] = e
    print('=' * 110); print('RIEPILOGO')
    for t, e in ris.items(): print('  %-34s %s' % (t, e))

def autotest():
    v = lambda net, dd, so, d5: dict(net=net, dd=dd, so=so, d5=d5)
    ok = {'2013': v(100, 3000, 0, 0), '2018': v(50, 8000, 0, 0), '2020': v(200, 100, 0, 0)}
    assert prop_anni(ok, 'CALIBRAZIONE OK')[0] == 'PROP-ANNI' and prop_anni(ok, 'NON ATTENDIBILE')[0] == 'NON PROP-ANNI'
    for k, vv in (('2013', v(-1, 0, 0, 0)), ('2018', v(5, 8001, 0, 0)), ('2020', v(5, 0, 1, 0)), ('2020', v(5, 0, 0, 1))):
        t = dict(ok); t[k] = vv; assert prop_anni(t, 'CALIBRAZIONE OK')[0] == 'NON PROP-ANNI', k
    assert dd_eur('3854.00(3.13%)') == 3854.0
    assert solo_etichetta_daily('finestra girata XAUUSD|Daily|2013.01.01|00:00|2014.01.01|00:00 invece di XAUUSD,D1 2013.01.01-2014.01.01')
    assert not solo_etichetta_daily('finestra girata XAUUSD|Daily|2013.01.01|00:00|2014.01.01|00:00 invece di XAUUSD,D1 2014.01.01-2015.01.01') and not solo_etichetta_daily('qualita 80%') and not solo_etichetta_daily('')
    print('AUTOTEST OK')
if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    main(sys.argv[1])
