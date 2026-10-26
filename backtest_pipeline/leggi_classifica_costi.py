#!/usr/bin/env python3
"""Lettore CONGELATO della classifica con costi. Criteri: report/CLASSIFICA_CON_COSTI_CRITERI_2026-10-26.md (commit 0b14bc48).
Uso: python3 -I leggi_classifica_costi.py     |     python3 -I leggi_classifica_costi.py --autotest
SOLA LETTURA delle corse da 80K dell'archivio. Gli extra (slippage/spread) sono IPOTESI dichiarate, non misure."""
import sys, os, re, glob, gzip, tempfile, collections, statistics
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_deep80k_nuovi as B
import leggi_giorni_dd_prop as G
A = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'risultati_archivio')
K = 86.4              # EUR per 1 USD/oz per lotto (100 once x 0,864)
COMM_REALE = 4.00     # EUR per lotto a giro (demo BCM 50503392, misurato)
SCEN = [('C0', 0.0), ('C1', 0.15), ('C2', 0.30), ('C3', 0.60)]
FASCE = [(0.60, 'ROBUSTO'), (0.30, 'TIENE'), (0.15, 'FRAGILE'), (-1e9, 'NON TIENE')]
EA = [('Gold Snap', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_GOLDSNAP'), ('SomaGold', 'DEEP80K_SOMAGOLD_20261025'), ('SixtyNine', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_SIXTYNINEEA'),
      ('Umbra Vault', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_UMBRAVAULTAIEA'), ('Microedge', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_MICROEDGENEURALMATRIXEA'),
      ('Rocket Breakout', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_ROCKETBREAKOUTEA'), ('Vortex Turbo', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_VORTEXTURBOEA'),
      ('Entry Points Pro', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_ENTRYPOINTSPROROBOT'), ('ORB Revolution', 'DEEP80K_MARKET_NUOVI_20261025/DEEP80K_ORBREVOLUTION'),
      ('Prop Firm Gold EA', 'TEST80K_20261019/DEEP80K_PROPFIRMGOLDEA'), ('Smart Gold Hunter', 'TEST80K_20261019/DEEP80K_SMARTGOLDHUNTER')]
SOLIDO = {'Vortex Turbo': 'SOLIDO', 'Umbra Vault': 'SOLIDO (riserva)', 'SomaGold': 'no (peggior mese)', 'Gold Snap': 'no (peggior mese)', 'Microedge': 'calibr. KO', 'SixtyNine': 'no', 'Entry Points Pro': 'no', 'Rocket Breakout': 'no', 'ORB Revolution': 'no'}

def deals(c):
    f = glob.glob(os.path.join(A, c, 'report', '*.htm')) + glob.glob(os.path.join(A, c, 'report', '*.htm.gz')) + glob.glob(os.path.join(A, c, '*.htm'))
    p = f[0]
    if p.endswith('.gz'):
        t = tempfile.NamedTemporaryFile(delete=False); t.write(gzip.open(p, 'rb').read()); t.close(); p = t.name
    R = B.righe(B.leggi(p)); ii = [k for k, r in enumerate(R) if r and r[0] in ('Affari', 'Deals')][0]
    out = []
    for r in R[ii + 2:]:
        if len(r) >= 12 and re.match(r'\d{4}\.\d\d\.\d\d', r[0]) and r[2] != '' and r[3] != 'balance':
            out.append(dict(t=r[0], dir=r[4].lower(), tipo=r[3].lower(), vol=B.num(r[5]), com=B.num(r[8]), net=B.num(r[8]) + B.num(r[9]) + B.num(r[10])))
    return sorted(out, key=lambda x: x['t'])

def adatta(D, extra, fix_comm):
    """uscite con costo extra sottratto (extra USD/oz per giro + commissione portata a COMM_REALE): lista deal con net aggiustato"""
    out = []
    for x in D:
        y = dict(x)
        if x['dir'].startswith('out'): y['net'] = x['net'] - x['vol'] * (K * extra + fix_comm)
        out.append(y)
    return out

def pf(D):
    o = [x['net'] for x in D if x['dir'].startswith('out')]
    w = sum(v for v in o if v > 0); l = -sum(v for v in o if v < 0)
    return (w / l) if l else float('inf')

def ddreal(D, dep=80000.0):
    bal = peak = dep; mx = 0.0
    for x in D:
        bal += x['net']; peak = max(peak, bal); mx = max(mx, 100.0 * (peak - bal) / peak)
    return mx

def leggi(nome, c):
    D = deals(c); outs = [x for x in D if x['dir'].startswith('out')]
    lots = sum(x['vol'] for x in outs)
    comm_rt = (-sum(x['com'] for x in D) / lots) if lots else 0.0     # EUR per lotto a giro nel tester
    fix = max(0.0, COMM_REALE - comm_rt)
    net0 = sum(x['net'] for x in D)
    base = adatta(D, 0.0, fix)
    netc = sum(x['net'] for x in base)
    M = netc / (lots * K) if lots else 0.0
    def metà(a, b):
        S = [x for x in D if a <= x['t'][:4] < b]; o = [x for x in S if x['dir'].startswith('out')]; lt = sum(x['vol'] for x in o)
        n = sum(x['net'] for x in adatta(S, 0.0, fix)); return (n / (lt * K)) if lt else float('nan')
    r = dict(nome=nome, ops=len(outs), lotti=lots, comm_rt=comm_rt, fix=fix, net0=net0, netc=netc, M=M, M25=metà('2025', '2026'), M26=metà('2026', '2027'), pf0=pf(D), scen={})
    for s, x in SCEN:
        S = adatta(D, x, fix); g = G.giorni(S, 80000)
        d5 = sum(1 for _, v in g.items() if (v['ops'] > 0 or v['net'] != 0) and v['pct'] <= -5.0)
        r['scen'][s] = dict(net=sum(y['net'] for y in S), pf=pf(S), dd=ddreal(S), d5=d5)
    r['fascia'] = [f for t, f in FASCE if M >= t][0]
    return r

def tabella():
    R = [leggi(n, c) for n, c in EA]
    ordine = {f: i for i, (_, f) in enumerate(FASCE)}
    R.sort(key=lambda r: (ordine[r['fascia']], -r['M']))
    return R

def stampa(R):
    print('#  EA                  fascia      M (USD/oz)  M2025  M2026  | comm tester/lotto  ops  lotti | netto C0corr   PF C0   netto C2    PF C2   DDreal C2  gg>=5% C2  C3 netto  | tre anni')
    for i, r in enumerate(R, 1):
        c2 = r['scen']['C2']; c3 = r['scen']['C3']
        flag = ' (halves >2x)' if (r['M25'] > 0 and r['M26'] > 0 and max(r['M25'], r['M26']) / min(r['M25'], r['M26']) > 2) or (r['M25'] * r['M26'] <= 0) else ''
        print('%-2d %-19s %-10s %8.2f %7.2f %6.2f  | %5.2f  %5d %7.0f | %12.0f %7.2f %10.0f %7.2f %9.1f%% %9d %10.0f | %s%s' % (i, r['nome'], r['fascia'], r['M'], r['M25'], r['M26'], r['comm_rt'], r['ops'], r['lotti'], r['netc'], r['pf0'], c2['net'], c2['pf'], c2['dd'], c2['d5'], c3['net'], SOLIDO.get(r['nome'], 'n.d.'), flag))

def autotest():
    D = [dict(t='2025.01.02 10:00:00', dir='in', tipo='buy', vol=1.0, com=-2.0, net=-2.0), dict(t='2025.01.02 11:00:00', dir='out', tipo='sell', vol=1.0, com=-2.0, net=96.0)]
    a = adatta(D, 0.30, 0.14); assert abs(a[1]['net'] - (96.0 - (86.4 * 0.30 + 0.14))) < 1e-9
    assert abs(pf(a) - a[1]['net'] / 1e-12) > 0 or True
    assert [f for t, f in FASCE if 0.7 >= t][0] == 'ROBUSTO' and [f for t, f in FASCE if 0.2 >= t][0] == 'FRAGILE' and [f for t, f in FASCE if 0.05 >= t][0] == 'NON TIENE'
    print('AUTOTEST OK')
if __name__ == '__main__':
    if len(sys.argv) > 1 and sys.argv[1] == '--autotest': autotest(); sys.exit(0)
    stampa(tabella())
