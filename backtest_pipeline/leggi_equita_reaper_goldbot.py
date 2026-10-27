import sys, glob, os, collections, datetime
sys.path.insert(0, 'lavoro_wt/backtest_pipeline')
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
A = 'lavoro_wt/backtest_pipeline/risultati_archivio/'
def corri(lab, path, csv, dep, da, a):
    ks, bars = E.carica_m1(glob.glob(csv))
    D = [x for x in E.affari_p(path)]
    res, meta = E.equita(D, ks, bars, dep, da, a)
    c1 = E.conta(res, 1); c2 = E.conta(res, 2); c4 = E.conta(res, 4)
    d_da = datetime.date(*[int(z) for z in da.split('.')]); d_a = datetime.date(*[int(z) for z in a.split('.')])
    rl = G.sintesi(collections.OrderedDict((g, v) for g, v in G.giorni(D, dep).items() if d_da <= g < d_a), dep)
    print('%-34s giorni %4d | CENTRALE >=5%% %2d >=4%% %2d >=3%% %2d | PESSIM >=5%% %2d >=4%% %2d >=3%% %2d | eq-base >=5%% %2d | REALIZZATO >=5%% %2d >=4%% %2d >=3%% %2d | meta %s' % (lab, len(res), c1[0], c1[1], c1[2], c2[0], c2[1], c2[2], c4[0], rl['c'][5.0], rl['c'][4.0], rl['c'][3.0], 'fx %.3f ok=%s pos=%d' % (meta['fx_med'], meta['fx_ok'], meta['pos'])))
    # peggiori 5 giorni (centrale e pessimistica)
    for nome, idx in (('centrale', 1), ('pessimistica', 2)):
        top = sorted(res.items(), key=lambda z: -z[1][idx] if len(z[1]) > idx else 0)[:5]
        print('   peggiori 5 (%s): ' % nome + '; '.join('%s %.2f%% (base %.0f)' % (g, v[idx], v[0]) for g, v in top))
    return res
r1 = corri('Reaper set Claudio 21 mesi', A + 'GR80K_20261020/GRSET80K_TRANCHE1_20261020_162333.htm', '../exp/in/ABTG_M1_XAUUSD.csv'.replace('../', ''), 80000, '2025.01.03', '2026.09.30')
f13 = glob.glob(A + 'ANNO80K_TRE_EA_ZIP_1444/2013_M1/ANNO80K_THEGOLDREAPERMT5/report/*.htm.gz')[0]
r2 = corri('Reaper 2013 (Modello 1)', f13, 'exp/in/ABTG_M1_XAUUSD_2013.csv', 80000, '2013.01.03', '2013.12.31')
g13 = glob.glob(A + 'ANNO80K_GOLDBOT_ZIP_1608/2013_M1/*/report/*.htm*')
if g13: corri('Goldbot One 2013 (Modello 1)', g13[0], 'exp/in/ABTG_M1_XAUUSD_2013.csv', 80000, '2013.01.03', '2013.12.31')
g25 = glob.glob(A + 'ANNO80K_GOLDBOT_ZIP_1608/2025_M4/*/report/*.htm*')
if g25: corri('Goldbot One 2025 (tick reali)', g25[0], 'exp/in/ABTG_M1_XAUUSD.csv', 80000, '2025.01.03', '2025.12.31')
