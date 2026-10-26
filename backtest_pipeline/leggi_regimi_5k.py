#!/usr/bin/env python3
"""Lettore CONGELATO: EA a 5.000 EUR per regime LONG / SHORT / LATERALE. Criteri: report/REGIMI_LONG_SHORT_LATERALE_5K_CRITERI_2026-10-26.md
Uso:  python3 -I leggi_regimi_5k.py <cartella con DEEP5K_<TOKEN>> [<altra cartella con DEEP5K_<TOKEN>> ...]
      python3 -I leggi_regimi_5k.py --autotest
Regime di un mese = rendimento close-to-close mensile dell'oro dalle barre D1 BCM: >= +3% LONG, <= -3% SHORT, altrimenti LATERALE.
SOLA LETTURA. Il regime e ex post: descrive l'ambiente, non prevede."""
import sys, os, re, glob, gzip, collections, tempfile
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B

D1 = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'data', 'prezzi', 'XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv')
SOGLIA = 3.0
REGIMI = ('LONG', 'SHORT', 'LATERALE')
PEGGIOR_MESE_MAX = -10.0
DEPOSITO = 5000.0

def regimi_mesi(path=D1):
    last = {}
    for l in open(path, encoding='utf-8-sig').read().splitlines()[1:]:
        q = l.split('\t')
        if len(q) >= 5: last[q[0][:7]] = float(q[4])
    ms = sorted(last); out = {}
    for i in range(1, len(ms)):
        r = 100.0 * (last[ms[i]] / last[ms[i - 1]] - 1.0)
        out[ms[i]] = ('LONG' if r >= SOGLIA else 'SHORT' if r <= -SOGLIA else 'LATERALE', r)
    return out

def carica(c):
    mf = B.manifest(os.path.join(c, 'MANIFEST_DEEP5K.csv'))
    if not mf or mf.get('stato') != 'OK': return None
    for cand in (os.path.join(c, 'report', mf['report']), os.path.join(c, mf['report'])):
        if os.path.exists(cand): return B.affari(B.righe(B.leggi(cand)))
        if os.path.exists(cand + '.gz'):
            t = tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(cand + '.gz', 'rb').read()); t.close()
            return B.affari(B.righe(B.leggi(t.name)))
    return None

def per_mese(D, deposito=DEPOSITO):
    """realizzi per mese: {mese: dict(net, ret% sul saldo a inizio mese, ops, net_long_pos, net_short_pos)}"""
    D = sorted(D, key=lambda x: x['t']); bal = float(deposito); out = collections.OrderedDict(); cur = None
    for x in D:
        m = x['t'][:7]
        if m not in out: out[m] = dict(start=bal, net=0.0, ops=0, nl=0.0, ns=0.0)
        out[m]['net'] += x['net']; bal += x['net']
        if x['dir'].startswith('out'):
            out[m]['ops'] += 1
            if x['tipo'].startswith('sell'): out[m]['nl'] += x['net']    # un sell chiude una posizione long
            else: out[m]['ns'] += x['net']
        elif x['dir'].startswith('in'):                                   # commissione d'ingresso: va alla direzione dell'apertura
            if x['tipo'].startswith('buy'): out[m]['nl'] += x['net']
            else: out[m]['ns'] += x['net']
    for m, v in out.items(): v['ret'] = 100.0 * v['net'] / v['start'] if v['start'] else 0.0
    return out

def aggrega(mesi_runs, reg):
    A = {r: [] for r in REGIMI}
    for mm in mesi_runs:
        for m, v in mm.items():
            if m in reg: A[reg[m][0]].append((m, v))
    return A

def solido(A):
    cond = []
    for r in REGIMI:
        L = A[r]
        if len(L) < 3: continue
        media = sum(v['ret'] for _, v in L) / len(L); pos = sum(1 for _, v in L if v['net'] > 0) / len(L); pm = min(v['ret'] for _, v in L)
        if media <= 0: cond.append('DEBOLE IN %s: rendimento mensile medio %+.1f%% <= 0' % (r, media))
        if pos < 0.5: cond.append('DEBOLE IN %s: mesi positivi %.0f%% < 50%%' % (r, 100 * pos))
        if pm < PEGGIOR_MESE_MAX: cond.append('DEBOLE IN %s: peggior mese %+.1f%% < %.0f%%' % (r, pm, PEGGIOR_MESE_MAX))
    return ('SOLIDO' if not cond else 'NON SOLIDO'), cond

def stampa_ea(nome, A):
    print('=' * 100); print(nome)
    print('  %-9s %4s %9s %9s %8s %10s %9s %12s %12s' % ('regime', 'mesi', 'ret.medio', 'positivi', 'peggior', 'netto EUR', 'ops', 'netto long', 'netto short'))
    for r in REGIMI:
        L = A[r]; n = len(L)
        if n == 0: print('  %-9s %4d' % (r, 0)); continue
        print('  %-9s %4d %8.1f%% %8.0f%% %7.1f%% %10.0f %9d %12.0f %12.0f%s' % (r, n, sum(v['ret'] for _, v in L) / n, 100.0 * sum(1 for _, v in L if v['net'] > 0) / n, min(v['ret'] for _, v in L),
              sum(v['net'] for _, v in L), sum(v['ops'] for _, v in L), sum(v['nl'] for _, v in L), sum(v['ns'] for _, v in L), '   (CAMPIONE PICCOLO: meno di 5 mesi)' if n < 5 else ''))
    e, c = solido(A); print('  ->', e, ('; ' + ' | '.join(c)) if c else ''); return e

def autotest():
    reg = regimi_mesi()
    assert reg['2026.03'][0] == 'SHORT' and reg['2025.09'][0] == 'LONG' and reg['2025.05'][0] == 'LATERALE' and reg['2024.11'][0] == 'SHORT', (reg['2026.03'], reg['2025.09'], reg['2025.05'])
    c = collections.Counter(reg[m][0] for m in reg if '2025.01' <= m <= '2026.09'); assert (c['LONG'], c['SHORT'], c['LATERALE']) == (10, 3, 8), c
    base = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio', 'TEST80K_20261019', 'DEEP80K_PROPFIRMGOLDEA')
    f = glob.glob(os.path.join(base, '*.htm'))
    if f:
        mm = per_mese(B.affari(B.righe(B.leggi(f[0]))), 80000.0)
        assert abs(sum(v['net'] for v in mm.values()) - 34129.71) < 0.01 and sum(v['ops'] for v in mm.values()) == 673
        A = aggrega([mm], reg)
        assert abs(sum(v['net'] for r in REGIMI for _, v in A[r]) - 34129.71) < 0.01 and len(A['LONG']) == 10 and len(A['SHORT']) == 3
        assert abs(sum(v['nl'] + v['ns'] for v in mm.values()) - 34129.71) < 0.01
    # sintetico: solido / non solido
    mk = lambda ret, net=1.0: dict(ret=ret, net=net, ops=1, nl=0, ns=0)
    A = {'LONG': [('a', mk(5)), ('b', mk(3)), ('c', mk(2))], 'SHORT': [('d', mk(1)), ('e', mk(0.5)), ('f', mk(2))], 'LATERALE': [('g', mk(1)), ('h', mk(1)), ('i', mk(2))]}
    assert solido(A)[0] == 'SOLIDO'
    A['SHORT'][0] = ('d', mk(-12, -1.0)); e, c = solido(A); assert e == 'NON SOLIDO' and any('peggior mese' in x for x in c), c
    A2 = {'LONG': [('a', mk(5)), ('b', mk(3)), ('c', mk(2))], 'SHORT': [('d', mk(1))], 'LATERALE': [('g', mk(1)), ('h', mk(-1, -1.0)), ('i', mk(-2, -1.0))]}
    e, c = solido(A2); assert e == 'NON SOLIDO' and any('LATERALE' in x for x in c)
    print('AUTOTEST OK')

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    reg = regimi_mesi(); per_ea = collections.OrderedDict()
    for base in sys.argv[1:]:
        for c in sorted(glob.glob(os.path.join(base, 'DEEP5K_*'))):
            if not os.path.isdir(c): continue
            D = carica(c)
            if D is None: print('NON LETTO:', c); continue
            per_ea.setdefault(os.path.basename(c).replace('DEEP5K_', ''), []).append(per_mese(D))
    if not per_ea: print('nessun DEEP5K_* letto'); sys.exit(1)
    ris = {}
    for nome, runs in per_ea.items(): ris[nome] = stampa_ea(nome, aggrega(runs, reg))
    print('=' * 100); print('RIEPILOGO')
    for n, e in ris.items(): print('  %-34s %s' % (n, e))
