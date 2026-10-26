#!/usr/bin/env python3
"""Lettura di un anno di prova FTMO su 80.000 EUR dalle corse continue 01/01/2025-01/10/2026 (80K, default venditore, nessun guardiano):
primi 12 mesi (2025) = partenza vera da 80K; poi gennaio-settembre 2026 come contesto. SOLO REALIZZATO (limite inferiore: FTMO misura sull'equita).
Uso: python3 -I leggi_prop80k_anno.py"""
import sys, os, glob, datetime, collections
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import leggi_giorni_dd_prop as G
DEP = 80000.0
def fetta(D, a, b):
    return [x for x in sorted(D, key=lambda x: x['t']) if a <= x['t'][:10].replace('.', '-') < b]
def leggi(D, a='2025-01-01', b='2026-01-01', dep=DEP):
    S = fetta(D, a, b)
    out = G.giorni(S, dep); outs = [x for x in S if x['dir'].startswith('out')]
    w = sum(x['net'] for x in outs if x['net'] > 0); l = -sum(x['net'] for x in outs if x['net'] < 0)
    bal = dep; peak = dep; ddmax = 0.0; minbal = dep; mensile = collections.OrderedDict(); fase1 = None; viol = None; day_end = {}
    for x in S:
        bal += x['net']; peak = max(peak, bal); ddmax = max(ddmax, peak - bal); minbal = min(minbal, bal)
        m = x['t'][:7]; mensile[m] = mensile.get(m, 0.0) + x['net']
        if fase1 is None and viol is None and bal >= dep * 1.10: fase1 = x['t'][:10]
        if viol is None and bal <= dep * 0.90: viol = ('perdita totale 10%', x['t'][:10])
    ds = [(g, v) for g, v in out.items() if v['ops'] > 0 or v['net'] != 0]
    for g, v in ds:
        if viol is None and v['pct'] <= -5.0: viol = ('giorno >= 5%', g.isoformat())
    # prima violazione cronologica reale: ricalcolo ordinato
    cand = []
    bal = dep
    for x in S:
        bal += x['net']
        if bal <= dep * 0.90: cand.append(x['t'][:10]); break
    gv = [g.isoformat() for g, v in sorted(ds) if v['pct'] <= -5.0]
    if gv: cand.append(gv[0])
    prima_viol = min(cand) if cand else None
    return dict(ops=len(outs), netto=bal - dep, pct=100 * (bal - dep) / dep, pf=(w / l if l else float('inf')), ddmax=ddmax, ddmax_pct=100 * ddmax / dep, minbal=minbal,
                d3=sum(1 for g, v in ds if v['pct'] <= -3), d4=sum(1 for g, v in ds if v['pct'] <= -4), d5=len(gv), peggio=min(ds, key=lambda z: z[1]['pct']) if ds else None,
                fase1=fase1, prima_viol=prima_viol, mensile=mensile, giorni_attivi=len(ds))
def main():
    L = {lab: D for lab, dep, D in G.corse()}
    for lab in L:
        if any(k in lab.upper() for k in ('VORTEX', 'UMBRA')): print('corsa:', lab)
    sel = [k for k in L if ('VORTEX' in k.upper() or 'UMBRA' in k.upper()) and not k.startswith('19/10')]
    for lab in sel:
        for nome, a, b in (('2025 (12 mesi da 80K)', '2025-01-01', '2026-01-01'), ('2026 gen-set (contesto)', '2026-01-01', '2026-10-02')):
            r = leggi(L[lab], a, b, DEP) if a == '2025-01-01' else leggi(L[lab], a, b, DEP + sum(x['net'] for x in fetta(L[lab], '2025-01-01', '2026-01-01')))
            pg = r['peggio']
            print('\n== %s | %s' % (lab, nome))
            print('ops %d  netto %+.0f (%+.1f%% di 80K)  PF %.2f  DD realizzato dal picco %.0f (%.1f%% di 80K)  saldo minimo %.0f' % (r['ops'], r['netto'], r['pct'], r['pf'], r['ddmax'], r['ddmax_pct'], r['minbal']))
            print('giorni con perdita >=3%%: %d  >=4%%: %d  >=5%%: %d  su %d giorni attivi; peggior giorno %s %.1f%% (%.0f)' % (r['d3'], r['d4'], r['d5'], r['giorni_attivi'], pg[0], pg[1]['pct'], pg[1]['net']))
            print('target 10%% (88.000) toccato: %s ; prima violazione (giorno>=5%% o saldo<=72.000): %s' % (r['fase1'], r['prima_viol']))
            print('mesi: ' + ' '.join('%s:%+.0f' % (m[2:], v) for m, v in r['mensile'].items()))
if __name__ == '__main__': main()

def mobile():
    """Finestre di 12 mesi con partenza ogni mese (gen 2025 - ott 2025): ogni finestra letta in % del saldo che il conto aveva alla partenza
    (l'auto-lotto scala col saldo, quindi la % e confrontabile; NON e un ricalcolo a 80K esatti). Sfida superata = +10% toccato prima di qualunque violazione (giorno >= 5% o saldo <= 90% della partenza)."""
    L = {lab: D for lab, dep, D in G.corse()}
    for lab in [k for k in L if ('VORTEX' in k.upper() or 'UMBRA' in k.upper()) and not k.startswith('19/10')]:
        D = sorted(L[lab], key=lambda x: x['t']); print('\n== finestre mobili 12 mesi: ' + lab)
        print('partenza  netto%   PF   gg>=3%  gg>=5%  DDreal%  +10% toccato   prima violazione   esito')
        for s in range(0, 10):
            y = 2025 + s // 12; m = s % 12 + 1; a = '%d-%02d-01' % (y, m); y2 = y + (m + 11) // 12 if False else (y + 1 if m != 1 else y + 1); b = '%d-%02d-01' % (y + 1, m)
            pre = sum(x['net'] for x in fetta(D, '2000-01-01', a)); dep = DEP + pre
            r = leggi(D, a, b, dep)
            # violazioni cronologiche
            esito = 'SUPERATA' if (r['fase1'] and (not r['prima_viol'] or r['fase1'].replace('.', '-') < r['prima_viol'])) else ('FALLITA' if r['prima_viol'] else 'NON ARRIVA AL +10%')
            print('%s %7.1f %6.2f %6d %7d %8.1f   %-12s   %-16s   %s' % (a[:7], r['pct'], r['pf'], r['d3'], r['d5'], 100 * r['ddmax'] / dep, r['fase1'] or '-', r['prima_viol'] or '-', esito))
if __name__ == '__main__': mobile()
