#!/usr/bin/env python3
"""Confronto CONGELATO: Gold Reaper senza il limite giornaliero (PropFirmMaxDailyDD=0) contro le corse di riferimento col limite a 4 (set di Claudio). Criteri: report/REAPER_SENZA_LIMITE_GIORNALIERO_CRITERI_2026-10-27.md
Uso:  python3 -I confronta_reaper_limite.py <cartella-contenitore ANNO80K_REAPER_SENZALIMITE_<data> con le 4 sottocartelle> [--autotest]
SOLA LETTURA. Per ogni corsa: stesse operazioni (istante, direzione, volume) o no; netto, PF, DD equity, giorni con perdita realizzata >= 3/4/5%."""
import sys, os, glob, gzip, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_tre_anni_80k as L
import leggi_equita_prop as E
ARCH = L.ARCH
RIF = {'2013': glob.glob(os.path.join(ARCH, 'ANNO80K_TRE_EA_ZIP_1444', '2013_M1', 'ANNO80K_THEGOLDREAPERMT5', 'report', '*.htm*')),
       '2018': glob.glob(os.path.join(ARCH, 'ANNO80K_TRE_EA_ZIP_1444', '2018_M1', 'ANNO80K_THEGOLDREAPERMT5', 'report', '*.htm*')),
       '2020': glob.glob(os.path.join(ARCH, 'ANNO80K_TRE_EA_ZIP_1444', '2020_M1', 'ANNO80K_THEGOLDREAPERMT5', 'report', '*.htm*')),
       '21MESI': glob.glob(os.path.join(ARCH, 'GR80K_20261020', '*.htm*'))}
def chiave(D): return [(x['t'], x['dir'], x['tipo'], round(x['vol'], 2)) for x in D]
def diff(a, b):
    ka, kb = chiave(a), chiave(b); n = 0; prima = None
    for i in range(max(len(ka), len(kb))):
        x = ka[i] if i < len(ka) else None; y = kb[i] if i < len(kb) else None
        if x != y:
            n += 1
            if prima is None: prima = (i, x, y)
    return n, prima
def main(base):
    for sub in sorted(glob.glob(os.path.join(base, '*_GR_SENZA_LIMITE_GIORNALIERO'))):
        nome = os.path.basename(sub); tag = nome.split('_')[0]
        c = glob.glob(os.path.join(sub, 'ANNO80K_*'))
        c = [x for x in c if os.path.isdir(x)]
        print('=' * 100); print(nome)
        if not c: print('  cartella dati assente'); continue
        mf, Dv = L.carica(c[0], 'ANNO80K')
        if Dv is None: print('  corsa NON valida (stato %s): %s' % (mf.get('stato') if mf else '-', (mf.get('motivi') or '')[:150] if mf else '')); continue
        f = glob.glob(os.path.join(c[0], 'report', '*.htm*'))
        rif = RIF.get(tag, [])
        v = L.valuta_anno(mf, Dv)
        print('  SENZA limite: ops %d netto %+.0f (%+.1f%%) PF %s DD equity %.0f EUR  stop out %d  gg>=3/4/5%% %d/%d/%d  peggior giorno %+.1f%% (%+.0f)' % (v['ops'], v['net'], v['pct'], v['pf'], v['dd'], v['so'], v['d3'], v['d4'], v['d5'], v['peggio'][0], v['peggio'][1]))
        if not rif: print('  riferimento non trovato'); continue
        A = E.affari_p(f[0]); B = E.affari_p(rif[0])
        n, prima = diff(A, B)
        print('  deal senza limite %d, con limite %d: operazioni diverse %d%s' % (len(A), len(B), n, '' if prima is None else '  prima differenza #%d: %s contro %s' % prima))
        print('  netto senza limite %+.0f, con limite %+.0f (differenza %+.0f)' % (sum(x['net'] for x in A), sum(x['net'] for x in B), sum(x['net'] for x in A) - sum(x['net'] for x in B)))
    return 0
if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest':
        a = [dict(t='1', dir='in', tipo='buy', vol=0.1), dict(t='2', dir='out', tipo='sell', vol=0.1)]; b = [dict(a[0]), dict(t='2', dir='out', tipo='sell', vol=0.2)]
        assert diff(a, a)[0] == 0 and diff(a, b)[0] == 1 and diff(a, a[:1])[0] == 1
        assert all(len(v) == 1 for v in RIF.values()), RIF
        print('AUTOTEST OK'); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1]))
