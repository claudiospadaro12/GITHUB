#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r246_giudizio_d1.py -- 29/09/2026

IL GIUDIZIO DELLA CASELLA d+1 (R246m..r, "orologio +1h letto d'inverno") COI
CRITERI CONGELATI PRIMA (prove/R246m par. 5 e 5.1, R246o, R246q).
Riusa r246_giudizio.py (importato, non ricopiato) e i suoi per-trade d0 di R246.

ORDINE (classe 750: cancelli prima dei numeri): G1 -> G2 -> S1 -> SOLO DOPO
Q2 (PF, solo Dow) e Qf2 (frequenza, tutti e tre).
  Q2  = (PF_I0 - PF_I+1) / D            D = PF_I0 - PF_E0  (d0, A+B, sui feriali d'inverno)
  Qf2 = (r_I0 - r_I+1) / (r_I0 - r_E0)  r = posizioni per feriale
  zone: <=0,30 STAGIONE, >=0,70 OROLOGIO, in mezzo MISTO / NON SEPARATO.
Il PF decide SOLO sul Dow; su DAX e MaxMin non discrimina (classe 178).
In piu' (DESCRITTIVO, [INFERITA] per FTMO): la serie ricostruita come la
vedrebbe FTMO = d0 nei giorni d'estate UE + d+1 nei giorni d'inverno UE.

USO:  python3 backtest_pipeline/r246_giudizio_d1.py
      python3 backtest_pipeline/r246_giudizio_d1.py --autotest
"""
import os
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r246_giudizio as g  # noqa: E402
import r246_bande_attese as rb  # noqa: E402

ARCH_D0, PT_D0, FILES_D0 = g.ARCH, g.PT, dict(g.FILES)
ARCH_D1 = os.path.join(QUI, 'risultati_archivio', 'ROUND_R246_INVERNO_2026-09-29')
PT_D1 = os.path.join(ARCH_D1, 'PERTRADE')
FILES_D1 = {
    'm': ('DOW', 'd+1', 'B', 794605), 'n': ('DOW', 'd+1', 'A', 794606),
    'o': ('DAX', 'd+1', 'B', 794615), 'p': ('DAX', 'd+1', 'A', 794616),
    'q': ('MM', 'd+1', 'B', 794625), 'r': ('MM', 'd+1', 'A', 794626),
}
G2_D1 = [('n', 'm'), ('p', 'o'), ('r', 'q')]
# S1 d+1 (R246m par. 5, R246o, R246q): (uscita minima, uscita massima)
S1_D1 = {'DOW': ('16:05:00', '18:31:00'), 'DAX': ('09:35:00', '18:31:00'), 'MM': ('08:59:00', '18:31:00')}
# soglie all'ancora CONGELATE (R246m par. 5): (OROLOGIO se <=, STAGIONE se >=)
SOGLIE_PF = {'DOW': (1.046, 1.398)}
SOGLIE_POS = {'DOW': (62.3, 70.1), 'DAX': (151.5, 163.2), 'MM': (10.4, 13.6)}
PRE_PF, PRE_F = g.PRE_PF, g.PRE_F


def carica():
    """ritorna (ptc_d0, ptc_d1): {(lettera, magic): righe}"""
    p0, p1 = {}, {}
    for lett, (k, o, f, m) in FILES_D0.items():
        for tw in (m, m + 50):
            p0[(lett, tw)] = g.leggi_pt(g.pertrade_path(lett, tw))
    g.FILES, g.ARCH, g.PT = FILES_D1, ARCH_D1, PT_D1
    try:
        for lett, (k, o, f, m) in FILES_D1.items():
            for tw in (m, m + 50):
                p1[(lett, tw)] = g.leggi_pt(g.pertrade_path(lett, tw))
    finally:
        g.FILES, g.ARCH, g.PT = FILES_D0, ARCH_D0, PT_D0
    return p0, p1


def con_d1(fn, *a):
    g.FILES, g.ARCH, g.PT = FILES_D1, ARCH_D1, PT_D1
    try:
        return fn(*a)
    finally:
        g.FILES, g.ARCH, g.PT = FILES_D0, ARCH_D0, PT_D0


def s1_d1(k, pt, pt_d0_lista):
    lo, hi = S1_D1[k]
    ore = [g.ora(r) for r in pt]
    n = len(ore)
    prima = sum(o < lo for o in ore)
    dopo = sum(o > hi for o in ore)
    ident = any([{a: b for a, b in r.items() if a != 'magic'} for r in pt] ==
                [{a: b for a, b in r.items() if a != 'magic'} for r in d0] for d0 in pt_d0_lista)
    note = [f"identico a un d0: {'SI' if ident else 'no'}", f"prima delle {lo[:5]}: {prima}/{n}",
            f"dopo le {hi[:5]}: {dopo}/{n}", f"min {min(ore)} max {max(ore)}" if n else 'n=0']
    if ident or prima or dopo or n == 0:
        return 'ROSSO', note
    if k == 'MM' and n < 3:
        return 'GIALLO', note
    return 'VERDE', note


def q2(k, d0A, d0B, m1A, m1B):
    cal = g.EA[k][2]
    fer = g.feriali_AB(cal)
    d0 = g.aggrega([('A', d0A), ('B', d0B)], cal)
    p1 = g.aggrega([('A', m1A), ('B', m1B)], cal)
    D = d0['I']['pf'] - d0['E']['pf']
    r = dict(k=k, fer=fer, d0=d0, p1=p1, D=D)
    r['Q2'] = (d0['I']['pf'] - p1['I']['pf']) / D if D else float('nan')
    if k in PRE_PF:
        r['pf_v'] = g.zona(r['Q2']) if D >= PRE_PF[k] else 'DIVARIO NON RIPRODOTTO'
    else:
        r['pf_v'] = 'NON DISCRIMINANTE (classe 178): solo lettura'
    rE0, rI0, rI1 = d0['E']['pos'] / fer['E'], d0['I']['pos'] / fer['I'], p1['I']['pos'] / fer['I']
    Df = rI0 - rE0
    r.update(rE0=rE0, rI0=rI0, rI1=rI1, Df=Df, Qf2=(rI0 - rI1) / Df if Df else float('nan'))
    r['f_v'] = g.zona(r['Qf2']) if Df >= PRE_F[k] else 'DIVARIO NON RIPRODOTTO'
    return r


def jackknife(k, celle):
    base = q2(k, *celle)
    qs, fs = [], []
    for i in range(4):
        for pid in sorted({x['position_id'] for x in celle[i]}):
            cc = list(celle)
            cc[i] = [x for x in celle[i] if x['position_id'] != pid]
            v = q2(k, *cc)
            qs.append((v['Q2'], v['pf_v']))
            fs.append((v['Qf2'], v['f_v']))
    cam = lambda L, b: sum(1 for _, z in L if z != b)
    return dict(n=len(qs), qmin=min(qs)[0], qmax=max(qs)[0], qcam=cam(qs, base['pf_v']),
                fmin=min(fs)[0], fmax=max(fs)[0], fcam=cam(fs, base['f_v']))


def serie_ftmo(k, d0A, d0B, m1A, m1B):
    """d0 nei giorni d'ESTATE UE + d+1 nei giorni d'INVERNO UE (calendario UE, come FTMO)"""
    tutti = []
    for et, pt0, pt1 in (('A', d0A, m1A), ('B', d0B, m1B)):
        for r in pt0:
            if not rb.inverno(g.giorno(r), 'UE'):
                tutti.append((et, r))
        for r in pt1:
            if rb.inverno(g.giorno(r), 'UE'):
                tutti.append((et, r))
    deal = [g.cent(r['net_profit']) / 100.0 for _, r in tutti]
    pos = {(et, r['position_id']) for et, r in tutti}
    seq = sorted([r for _, r in tutti], key=lambda r: r['close_time'])
    dd, ddp = g.dd_saldo(seq)
    fer = g.feriali_AB('UE')
    return dict(pf=rb.pf(deal), pos=len(pos), deal=len(deal), netto=sum(deal), dd=dd, ddp=ddp,
                fer=fer['E'] + fer['I'], per_g=len(pos) / (fer['E'] + fer['I']))


def sfasati_dow(m1A, m1B):
    """d+1 Dow nei giorni UE-inverno ma USA-estate (i 40 feriali disallineati)"""
    n, netto, pos = 0, 0.0, set()
    for et, pt in (('A', m1A), ('B', m1B)):
        for r in pt:
            d = g.giorno(r)
            if rb.inverno(d, 'UE') and not rb.inverno(d, 'USA'):
                n += 1
                netto += g.cent(r['net_profit']) / 100.0
                pos.add((et, r['position_id']))
    return n, len(pos), netto


def main():
    p0, p1 = carica()
    print("=" * 78)
    print("R246 d+1 (R246m..r) -- GIUDIZIO COI CRITERI CONGELATI (R246m par. 5/5.1, o, q)")
    print("=" * 78)
    print("\n### 1. G1 DETERMINISMO (alla lettera)")
    g1 = con_d1(g.cancello_g1, p1)
    for lett in FILES_D1:
        esito, diff, diag = g1[lett]
        print(f"  R246{lett} {FILES_D1[lett][0]:3s} {FILES_D1[lett][2]}: G1 {esito}")
        for d in diff:
            print(f"        - {d}")
    nulli = [l for l in FILES_D1 if g1[l][0] != 'PASS']
    print("  -> file NULLI per G1:", nulli or 'nessuno')

    print("\n### 2. G2 COERENZA FRA FINESTRE (per-trade A contro gamba IS del CSV B)")
    g.FILES, g.ARCH, g.PT = FILES_D1, ARCH_D1, PT_D1
    try:
        g.G2_COPPIE, salva = G2_D1, g.G2_COPPIE
        g2 = g.cancello_g2(p1)
    finally:
        g.G2_COPPIE = salva
        g.FILES, g.ARCH, g.PT = FILES_D0, ARCH_D0, PT_D0
    g2ok = True
    for la, lb, righe in g2:
        for (off, s, n, pb, tb, ok, g26) in righe:
            g2ok &= ok
            print(f"  R246{la} (+{off:2d}) vs R246{lb} IS: somma {s / 100:.2f} / {n} deal contro {pb} / {tb}"
                  f" -> {'IDENTICI' if ok else 'SCARTO'}  (deal del 26/09/2024: {g26})")

    print("\n### 3. S1 SENTINELLA DELL'OROLOGIO (la manopola deve MORDERE)")
    s1 = {}
    for lett, (k, o, f, m) in FILES_D1.items():
        d0lista = [p0[(l, mm)] for l, (kk, oo, ff, m0) in FILES_D0.items()
                   if kk == k and oo == 'd0' for mm in (m0, m0 + 50)]
        s1[lett] = s1_d1(k, p1[(lett, m)], d0lista)
        print(f"  R246{lett} {k:3s} {f}: S1 {s1[lett][0]}  | " + "; ".join(s1[lett][1]))
    nullo = {k: any(s1[l][0] == 'ROSSO' for l, v in FILES_D1.items() if v[0] == k) for k in g.EA}
    print("  -> round NULLO per S1:", [k for k, v in nullo.items() if v] or 'nessuno')

    print("\n### 4. VERDETTI (aperti SOLO ora) -- n = posizioni, PF sui deal, per stagione di CHIUSURA")
    out = {}
    for k in g.EA:
        L0 = {v[1] + v[2]: l for l, v in FILES_D0.items() if v[0] == k}
        L1 = {v[2]: l for l, v in FILES_D1.items() if v[0] == k}
        if nullo[k]:
            print(f"  {k}: ROUND NULLO (S1)")
            continue
        varianti = [0, 50]
        print(f"\n  == {k} ({g.EA[k][0]}, calendario {g.EA[k][2]})  [varianti: gemella m e gemella m+50]")
        for off in varianti:
            celle = [p0[(L0['d0A'], FILES_D0[L0['d0A']][3] + off)], p0[(L0['d0B'], FILES_D0[L0['d0B']][3] + off)],
                     p1[(L1['A'], FILES_D1[L1['A']][3] + off)], p1[(L1['B'], FILES_D1[L1['B']][3] + off)]]
            r = q2(k, *celle)
            out[(k, off)] = (r, celle)
            if off == 0:
                fer = r['fer']
                print(f"     feriali A+B: estate {fer['E']}, inverno {fer['I']}")
                for nome, gg in (('d0 ', r['d0']), ('d+1', r['p1'])):
                    for z, zz in (('E', 'estate '), ('I', 'inverno')):
                        print(f"     {nome} {zz}: PF {gg[z]['pf']:.3f}  posizioni {gg[z]['pos']:3d}  deal {gg[z]['deal']:3d}  netto {gg[z]['netto']:10.2f}")
                print(f"     PF:   PF_I0 {r['d0']['I']['pf']:.3f}  PF_E0 {r['d0']['E']['pf']:.3f}  D {r['D']:.3f}"
                      f"  PF_I+1 {r['p1']['I']['pf']:.3f}  Q2 {r['Q2']:.3f}  -> {r['pf_v']}")
                print(f"     FREQ: r_I0 {r['rI0']:.4f}  r_E0 {r['rE0']:.4f}  Df {r['Df']:.4f} (soglia {PRE_F[k]})"
                      f"  r_I+1 {r['rI1']:.4f}  Qf2 {r['Qf2']:.3f}  -> {r['f_v']}")
                pi = r['p1']['I']['pos']
                lo, hi = SOGLIE_POS[k]
                print(f"     posizioni d+1 inverno {pi}: soglie ancora OROLOGIO<={lo} STAGIONE>={hi} -> "
                      f"{'OROLOGIO' if pi <= lo else ('STAGIONE' if pi >= hi else 'in mezzo')}")
                if k in SOGLIE_PF:
                    x = r['p1']['I']['pf']
                    lo, hi = SOGLIE_PF[k]
                    print(f"     PF d+1 inverno {x:.3f}: soglie ancora OROLOGIO<={lo} STAGIONE>={hi} -> "
                          f"{'OROLOGIO' if x <= lo else ('STAGIONE' if x >= hi else 'in mezzo')}")
                fr = jackknife(k, celle)
                print(f"     fragilita' (jackknife, {fr['n']} posizioni): Q2 [{fr['qmin']:.3f} ; {fr['qmax']:.3f}] verdetto PF cambia in {fr['qcam']};"
                      f" Qf2 [{fr['fmin']:.3f} ; {fr['fmax']:.3f}] verdetto FREQ cambia in {fr['fcam']}")
                seq = [x for c in celle[2:] for x in sorted(c, key=lambda y: y['close_time'])
                       if g.stagione(g.giorno(x), g.EA[k][2]) == 'I']
                print(f"     DD saldo d+1 inverno [DERIVATO]: {g.dd_saldo(seq)[1]:.2%}")
                sf = serie_ftmo(k, *celle)
                print(f"     SERIE COME LA VEDREBBE FTMO [INFERITA] (d0 estate UE + d+1 inverno UE, calendario UE, {sf['fer']} feriali):"
                      f" PF {sf['pf']:.3f}  posizioni {sf['pos']} ({sf['per_g']:.3f}/feriale)  netto {sf['netto']:.2f}  DD saldo {sf['ddp']:.2%}")
                if k == 'DOW':
                    n, npos, net = sfasati_dow(celle[2], celle[3])
                    print(f"     40 feriali sfasati (UE inverno / USA estate) d+1 Dow: deal {n}, posizioni {npos}, netto {net:.2f}  [DESCRITTIVO]")
            else:
                print(f"     invarianza gemella m+50: Q2 {r['Q2']:.6f} -> {r['pf_v']} | Qf2 {r['Qf2']:.6f} -> {r['f_v']}")
    print("\n### 5. RISCHIO (Emendamento B) -- CSV gemella m e per-trade")
    g.FILES, g.ARCH, g.PT = FILES_D1, ARCH_D1, PT_D1
    try:
        for lett, (k, o, f, m) in FILES_D1.items():
            ci, co = g.csv_round(lett, 'IS'), g.csv_round(lett, 'OOS')
            dd, ddp = g.dd_saldo(p1[(lett, m)])
            print(f"  R246{lett} {k:3s} {f}: CSV IS DD {ci[m]['Equity DD %'] if ci else '(vuoto)':>8s} OOS DD {co[m]['Equity DD %']:>8s}"
                  f" PF OOS {co[m]['Profit Factor']:>8s} Trades {co[m]['Trades']:>3s} | per-trade DD saldo {ddp:.2%}")
    finally:
        g.FILES, g.ARCH, g.PT = FILES_D0, ARCH_D0, PT_D0
    return g1, g2ok, s1, out


def autotest():
    # contro-esempio 1: zona() ai bordi congelati
    assert g.zona(0.30) == 'STAGIONE' and g.zona(0.70) == 'OROLOGIO' and g.zona(0.5).startswith('MISTO')
    # contro-esempio 2: S1 deve andare ROSSO se il per-trade d+1 e' identico a un d0 (pin d'orario non arrivato)
    pt = [{'close_time': '2025.01.02 17:00:00', 'magic': '1', 'x': 'a'}]
    pt0 = [{'close_time': '2025.01.02 17:00:00', 'magic': '9', 'x': 'a'}]
    assert s1_d1('DOW', pt, [pt0])[0] == 'ROSSO'
    # ... e ROSSO se esce prima delle 16:05 (l'EA gira a d0)
    assert s1_d1('DOW', [{'close_time': '2025.01.02 15:40:00', 'magic': '1'}], [[]])[0] == 'ROSSO'
    # ... VERDE se tutto dentro e diverso
    assert s1_d1('DOW', [{'close_time': '2025.01.02 17:00:00', 'magic': '1', 'x': 'b'}], [pt0])[0] == 'VERDE'
    # ... MaxMin con <3 uscite non e' ROSSO ma GIALLO
    assert s1_d1('MM', [{'close_time': '2025.01.02 09:00:00', 'magic': '1', 'x': 'b'}], [pt0])[0] == 'GIALLO'
    # contro-esempio 3: Q2 = 1 se d+1 inverno == d0 estate (OROLOGIO puro), 0 se d+1 inverno == d0 inverno
    q = lambda pfI0, pfE0, pfI1: (pfI0 - pfI1) / (pfI0 - pfE0)
    assert abs(q(1.5, 0.9, 0.9) - 1) < 1e-9 and abs(q(1.5, 0.9, 1.5)) < 1e-9
    print("autotest r246_giudizio_d1: OK")


if __name__ == '__main__':
    autotest() if '--autotest' in sys.argv else main()
