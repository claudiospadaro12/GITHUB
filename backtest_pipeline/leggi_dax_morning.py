#!/usr/bin/env python3
"""Lettore CONGELATO: The DAX Morning Scalp (njtrading) su D30EUR M15, 21 mesi a tick reali, 80.000 EUR. Criteri: report/DAX_MORNING_SCALP_CRITERI_2026-10-27.md
Ogni set gira DUE volte (ore d inverno W e d estate S); da ogni corsa si prendono SOLO i deal della stagione giusta (estate = ora legale CEST secondo il server UTC+1 fisso, funzione G.cest).
Uso:  python3 -I leggi_dax_morning.py <cartella contenitore con le sottocartelle 21MESI_M4_DAXMS_<SET>_<W|S>\\ANNO80K_*>   |   --autotest
SOLA LETTURA. Realizzato (nessuna equity intraday: l EA tiene una posizione per poche ore; serve l export M1 del DAX per l equity)."""
import sys, os, glob, datetime, collections, statistics
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_equita_prop as E
import leggi_giorni_dd_prop as G
DEP = 80000.0
SET = ['DEFAULT', 'SENZAAGGR', 'UNOAUNO', 'REVERSAL', 'BRUNCH']

def stagione(t):
    return 'S' if G.cest(datetime.datetime.strptime(t[:19], '%Y.%m.%d %H:%M:%S')) else 'W'

def seleziona(D, stag):
    return [x for x in D if stagione(x['t']) == stag]

def statistiche(D):
    """D = deal gia selezionati per stagione (di entrambe le corse), ordinati per tempo."""
    D = sorted(D, key=lambda x: x['t'])
    out = [x for x in D if x['dir'].startswith('out')]
    net_out = [x['net'] for x in out]
    vin = [v for v in net_out if v > 0]; per = [v for v in net_out if v < 0]
    r = dict(ops=len(out), net=sum(x['net'] for x in D))
    r['pf'] = (sum(vin) / -sum(per)) if per else float('inf')
    r['win'] = 100.0 * len(vin) / len(out) if out else 0.0
    r['avgw'] = statistics.mean(vin) if vin else 0.0; r['avgl'] = statistics.mean(per) if per else 0.0
    r['payoff'] = (r['avgw'] / -r['avgl']) if per and vin else 0.0
    bal = DEP; pk = DEP; dd = 0.0; giorni = collections.OrderedDict(); mesi = collections.OrderedDict()
    for x in D:
        g = G.giorno_ftmo(x['t'])
        if g not in giorni: giorni[g] = [bal, 0.0]
        giorni[g][1] += x['net']
        bal += x['net']; pk = max(pk, bal); dd = max(dd, pk - bal)
        m = x['t'][:7]; mesi[m] = mesi.get(m, 0.0) + x['net']
    r['dd'] = dd
    perd = [(b - (b + s)) / b * 100.0 if s < 0 else 0.0 for b, s in giorni.values()]   # perdita netta del giorno realizzata, % del saldo a inizio giorno
    peggio = min(giorni.items(), key=lambda z: z[1][1]) if giorni else None
    r['d3'] = sum(1 for p in perd if p >= 3.0); r['d4'] = sum(1 for p in perd if p >= 4.0); r['d5'] = sum(1 for p in perd if p >= 5.0)
    r['peggio'] = (peggio[0], 100.0 * peggio[1][1] / peggio[1][0]) if peggio else (None, 0.0)
    r['mesi'] = mesi; r['mpos'] = sum(1 for v in mesi.values() if v > 0); r['nm'] = len(mesi)
    h1 = sum(v for m, v in mesi.items() if m <= '2026.05'); h2 = sum(v for m, v in mesi.items() if m > '2026.05')
    r['h1'] = h1; r['h2'] = h2
    return r

def verdetto(r):
    mot = []
    if r['ops'] < 150: mot.append('S-N: %d operazioni < 150' % r['ops'])
    if r['nm'] and r['mpos'] / r['nm'] < 0.60: mot.append('S-M: %d/%d mesi positivi < 60%%' % (r['mpos'], r['nm']))
    if r['net'] <= 0: mot.append('netto <= 0')
    if r['h1'] <= 0 or r['h2'] <= 0: mot.append('S-H: una meta <= 0 (%+.0f / %+.0f)' % (r['h1'], r['h2']))
    if r['d5'] > 0: mot.append('%d giorni con perdita realizzata >= 5%%' % r['d5'])
    if r['dd'] > 8000: mot.append('DD realizzato %.0f EUR > 8000' % r['dd'])
    return ('PASSA I CANCELLI' if not mot else 'NON PASSA'), mot

def carica(sub):
    c = [x for x in glob.glob(os.path.join(sub, 'ANNO80K_*')) if os.path.isdir(x)]
    if not c: return None, 'cartella dati assente'
    f = glob.glob(os.path.join(c[0], 'report', '*.htm*'))
    if not f: return None, 'report assente'
    import leggi_tre_anni_80k as L
    mf, D = L.carica(c[0], 'ANNO80K')
    if D is None: return None, 'corsa NON valida (stato %s) %s' % (mf.get('stato') if mf else '-', (mf.get('motivi') or '')[:120] if mf else '')
    return E.affari_p(f[0]), None

def main(base):
    for s in SET:
        print('=' * 110); print(s)
        sel = []
        for stag in ('W', 'S'):
            sub = os.path.join(base, '21MESI_M4_DAXMS_%s_%s' % (s, stag))
            D, err = carica(sub)
            if D is None: print('  %s: %s' % (stag, err)); continue
            part = seleziona(D, stag); sel += part
            print('  corsa %s (ore %s): deal totali %d, della stagione %d' % (stag, 'd inverno' if stag == 'W' else 'd estate', len(D), len(part)))
        if not sel: continue
        r = statistiche(sel)
        print('  21 MESI (stagioni chiuse): ops %d netto %+.0f (%+.1f%%) PF %.2f vincenti %.0f%% vincita media %+.0f perdita media %+.0f payoff %.2f DD realizzato %.0f EUR (%.1f%%)' % (r['ops'], r['net'], 100 * r['net'] / DEP, r['pf'], r['win'], r['avgw'], r['avgl'], r['payoff'], r['dd'], 100 * r['dd'] / DEP))
        print('  giorni con perdita realizzata >=3/4/5%%: %d/%d/%d  peggior giorno %s %+.2f%%  mesi positivi %d/%d  meta 01/25-05/26 %+.0f, 06/26-09/26 %+.0f' % (r['d3'], r['d4'], r['d5'], r['peggio'][0], r['peggio'][1], r['mpos'], r['nm'], r['h1'], r['h2']))
        for stag in ('W', 'S'):
            rs = statistiche([x for x in sel if stagione(x['t']) == stag])
            print('     solo %s: ops %d netto %+.0f PF %.2f vincenti %.0f%%' % ('inverno' if stag == 'W' else 'estate', rs['ops'], rs['net'], rs['pf'], rs['win']))
        v, mot = verdetto(r); print('  ->', v, ('; ' + ' | '.join(mot)) if mot else '')
    return 0

def autotest():
    D = []
    for i in range(20):
        t = '2025.0%d.1%d 10:00:00' % (1 + i // 10, i % 10)
        D.append(dict(t=t, dir='in', tipo='buy', net=0.0)); D.append(dict(t=t.replace('10:00', '11:00'), dir='out', tipo='sell', net=100.0 if i % 4 else -300.0))
    r = statistiche(D); assert r['ops'] == 20 and abs(r['net'] - (15 * 100 - 5 * 300)) < 1e-9, r
    assert abs(r['pf'] - 1500 / 1500) < 1e-9 and r['win'] == 75.0 and r['dd'] > 0
    assert stagione('2025.01.10 10:00:00') == 'W' and stagione('2025.07.10 10:00:00') == 'S' and stagione('2025.03.29 12:00:00') == 'W' and stagione('2025.03.31 12:00:00') == 'S'
    assert stagione('2025.10.25 12:00:00') == 'S' and stagione('2025.10.27 12:00:00') == 'W'
    print('AUTOTEST OK')

if __name__ == '__main__':
    if len(sys.argv) >= 2 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    if len(sys.argv) < 2: print(__doc__); sys.exit(2)
    sys.exit(main(sys.argv[1]))
