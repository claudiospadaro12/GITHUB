#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
r250_bande_attese.py -- 25/09/2026

LE SOGLIE E LE BANDE DI R250, SCRITTE PRIMA DEI NUMERI.
Ogni numero dei paragrafi 5-8 di prove/R250a_orologio_R245_d0_A_U30USD.txt
si rifa' da qui, a seme fisso. Sola lettura: legge i per-trade di R247 e
non scrive niente.

DOMANDA (report/IL_MERITO_E_D_INVERNO_2026-09-25.md par. 5): il candidato #1
(cella centrale R245b, ABTG_Nasdaq_Apertura_US U30USD M5, EmaSlow 200, TP
0,50, due lati) guadagna quasi solo d'inverno, quando 14:30 BCM = 8:30 NY.
E' OROLOGIO (armare alle 8:30 NY) o STAGIONE (l'inverno)?
Il 2x2 (BCM UTC+1 fisso; stagione = calendario USA per data di chiusura):
                        armo 8:30 NY            armo 9:30 NY (cash)
   ESTATE (E)           -1h  [R250c/d, NUOVA]   d0   [R247 = R250a/b]
   INVERNO (I)          d0   [R247 = R250a/b]   +1h  [R250e/f, NUOVA]
  H_OROLOGIO: -1h d'estate ~ d0 d'inverno ; +1h d'inverno ~ d0 d'estate.
  H_STAGIONE: -1h d'estate ~ d0 d'estate  ; +1h d'inverno ~ d0 d'inverno.
  Q   = (PF_E-1h - PF_E0) / D            D = PF_I0 - PF_E0
  Q2  = (PF_I0 - PF_I+1)  / D
  Qc  = (Q + Q2) / 2                     (verdetto principale)
  S   = (Q2 - Q) / 2                     (interazione del 2x2, descrittiva:
                                          uno spostamento che peggiora tutte e
                                          due le celle la muove, Qc no -- T10)
  Qf, Qf2, Qfc, Sf: stesse formule con le posizioni per feriale.
  Zone: <= 0,30 STAGIONE, >= 0,70 OROLOGIO, in mezzo MISTO.

RIFERIMENTI FISSI: le celle d0 del round (R250a/b) devono riprodurre i
per-trade di R247 (G0 VERDE, sui campi che decidono). Allora PF_E0, PF_I0,
D, r_E0, r_I0 sono NUMERI NOTI OGGI, e le soglie sono in PF e in posizioni.
Con G0 non VERDE non si legge niente (niente giallo, come R247).

CLASSE 778: l'ipotesi "il merito e' d'inverno" e' nata sulla tranche OOS
(B = 2025.07.01 -> 2026.06.29, R248a par. 7). CAMPIONE DI CONFERMA = SOLO
la tranche A (2024.09.26 -> 2025.06.29). La lettura A+B e B si stampano,
ma NON sono conferma.

METODO DELLE BANDE (come r246_bande_attese.py): bootstrap sulle POSIZIONI
(qui 1 deal = 1 posizione, InpTP1_ClosePct=0), n = posizioni per feriale
della stagione x feriali; frequenza binomiale (al massimo 1 al giorno).
Celle trattate come INDIPENDENTI: sotto H_STAGIONE le celle spostate
girano sugli STESSI giorni della d0, quindi l'errore vero e' PIU' PICCOLO
di quello stampato (prudente).

USO:  python3 backtest_pipeline/r250_bande_attese.py            (~15 s)
      python3 backtest_pipeline/r250_bande_attese.py --autotest (~2 s)
Esce 1 se un'ancora non torna.
"""
import collections
import csv
import datetime as dt
import os
import random
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r246_bande_attese as rb  # noqa: E402  calendario USA (INV) e PF sui deal

P = lambda *a: os.path.join(QUI, *a)  # noqa: E731
PT = {
    'A': P('risultati_archivio', 'R247', 'PERTRADE', 'abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765271.csv'),
    'B': P('risultati_archivio', 'R247', 'PERTRADE', 'abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765273.csv'),
}
# fine del tester ESCLUSIVA (R248a par. 2): l'ultimo giorno e' il 29/06
FIN = {
    'A': (dt.date(2024, 9, 26), dt.date(2025, 6, 29)),
    'B': (dt.date(2025, 7, 1), dt.date(2026, 6, 29)),
}
# ancore scritte da ALTRI (REFERTO_R247 G0; IL_MERITO_E_D_INVERNO par. 2.1)
ANCORE = {
    'A': dict(deal=154, somma=1180.94, nE=79, nI=75, pfE=1.025, pfI=1.444),
    'B': dict(deal=197, somma=2961.61, nE=120, nI=77, pfE=0.954, pfI=2.126),
}
LO, HI = 0.30, 0.70
WARMUP_FINE = dt.date(2024, 11, 15)   # S2: EMA200 H4 senza storia prima (par. 5.4 del file)
# S1 (orari BCM, "HH:MM:SS" confrontati come stringhe)
S1 = {
    'd0':  dict(min_uscita='14:45:00', max_uscita='17:31:00'),
    'm1h': dict(min_uscita='13:45:00', max_uscita='16:31:00', prima_di='14:45:00', quota_min=0.10),
    'p1h': dict(min_uscita='15:45:00', max_uscita='18:31:00', dopo_di='17:31:00', quota_min=0.03),
}
TOL_NET = 0.01      # G1/G0 per riga
TOL_PROFIT = 0.05   # G1/G0 sul CSV
TOL_DD = 0.01


# ------------------------------------------------------------------ dati
def leggi_pt(percorso):
    out = []
    with open(percorso, newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            out.append(dict(d=dt.datetime.strptime(r['close_time'][:10], '%Y.%m.%d').date(),
                            t=r['close_time'][11:], ct=r['close_time'], net=float(r['net_profit']),
                            pid=r['position_id'], tipo=int(r['deal_type']), vol=r['volume'],
                            px=r['price'], magic=r['magic']))
    return out


def stagione(d):
    return 'I' if rb.inverno(d, 'USA') else 'E'


def feriali(a, b):
    e = i = 0
    d = a
    while d <= b:
        if d.weekday() < 5:
            if stagione(d) == 'I':
                i += 1
            else:
                e += 1
        d += dt.timedelta(1)
    return e, i


def per_stagione(rows):
    """posizioni per stagione: lista di liste di netti (deal della stessa posizione insieme)."""
    pos = {'E': collections.OrderedDict(), 'I': collections.OrderedDict()}
    for r in rows:
        pos[stagione(r['d'])].setdefault(r['pid'], []).append(r['net'])
    return {s: list(v.values()) for s, v in pos.items()}


def pf_pos(lista):
    return rb.pf([v for L in lista for v in L])


def riferimenti(pos, fer):
    fE, fI = fer
    pE, pI = pf_pos(pos['E']), pf_pos(pos['I'])
    rE, rI = len(pos['E']) / fE, len(pos['I']) / fI
    return dict(pE=pE, pI=pI, D=pI - pE, rE=rE, rI=rI, Df=rI - rE, fE=fE, fI=fI,
                nE=len(pos['E']), nI=len(pos['I']))


def unisci(*pp):
    return {s: [x for p in pp for x in p[s]] for s in ('E', 'I')}


# ------------------------------------------------------------------ regola
def zona(q):
    if q is None:
        return 'NON LEGGIBILE'
    return 'STAGIONE' if q <= LO else ('OROLOGIO' if q >= HI else 'MISTO')


def statistiche(ref, pf_m=None, pf_p=None, n_m=None, n_p=None):
    """pf_m, n_m: PF e posizioni della -1h sui giorni d'ESTATE; pf_p, n_p: +1h d'INVERNO.
    None = cella NON leggibile (file NULLO o non girato): la statistica non si calcola."""
    D, Df = ref['D'], ref['Df']
    q = None if pf_m is None else (pf_m - ref['pE']) / D
    q2 = None if pf_p is None else (ref['pI'] - pf_p) / D
    qf = None if n_m is None else (n_m / ref['fE'] - ref['rE']) / Df
    qf2 = None if n_p is None else (ref['rI'] - n_p / ref['fI']) / Df
    qc = None if (q is None or q2 is None) else (q + q2) / 2
    qfc = None if (qf is None or qf2 is None) else (qf + qf2) / 2
    # S = componente d'INTERAZIONE del 2x2 (le celle spostate contro le d0, oltre
    # orologio e stagione): (Q2 - Q)/2. Sotto tutte e due le ipotesi vale ~0; uno
    # spostamento che peggiora (o migliora) TUTTE E DUE le celle di delta la sposta
    # di delta/D e lascia Qc INVARIATO (autotest T10). Descrittiva, non vota.
    sc = None if (q is None or q2 is None) else (q2 - q) / 2
    sfc = None if (qf is None or qf2 is None) else (qf2 - qf) / 2
    return dict(Q=q, Q2=q2, Qc=qc, Qf=qf, Qf2=qf2, Qfc=qfc, S=sc, Sf=sfc)


ZONATE = ('Q', 'Q2', 'Qc', 'Qf', 'Qf2', 'Qfc')


def congiunta(z1, z2):
    """lettura congiunta Q/Q2 (R246m par. 5.1): descrittiva."""
    if 'NON LEGGIBILE' in (z1, z2):
        return 'NON LEGGIBILE'
    if z1 == z2 and z1 in ('OROLOGIO', 'STAGIONE'):
        return z1 + ' in tutte e due le stagioni'
    if {z1, z2} == {'OROLOGIO', 'STAGIONE'}:
        return 'INTERAZIONE'
    return 'MISTO'


# file del round per campione: una cella per file; un file che non e' VALIDO
# (G1 NULLO, motore diverso dal pin, S1 ROSSO, PIN DAL CSV rosso, non girato)
# NON VOTA in nessuna statistica (classi 772/775/781).
USA = {
    'A':  dict(d0=['R250a'], m1h=['R250c'], p1h=['R250e']),
    'AB': dict(d0=['R250a', 'R250b'], m1h=['R250c', 'R250d'], p1h=['R250e', 'R250f']),
}


def leggibile(stato, nomi):
    return all(stato.get(n) == 'VALIDO' for n in nomi)


def verdetto(stato, g0, ref, misure, campione='A'):
    """stato: nome file -> 'VALIDO' / altro; g0: nome d0 -> 'VERDE' / altro;
    misure: dict pf_m, n_m, pf_p, n_p del campione. Restituisce le zone."""
    u = USA[campione]
    rif_ok = leggibile(stato, u['d0']) and all(g0.get(n) == 'VERDE' for n in u['d0'])
    ok_m = rif_ok and leggibile(stato, u['m1h'])
    ok_p = rif_ok and leggibile(stato, u['p1h'])
    s = statistiche(ref,
                    misure.get('pf_m') if ok_m else None, misure.get('pf_p') if ok_p else None,
                    misure.get('n_m') if ok_m else None, misure.get('n_p') if ok_p else None)
    z = {k: zona(s[k]) for k in ZONATE}
    z['congiunta_PF'] = congiunta(z['Q'], z['Q2'])
    z['congiunta_FREQ'] = congiunta(z['Qf'], z['Qf2'])
    return s, z


def soglie(ref):
    pE, pI, D = ref['pE'], ref['pI'], ref['D']
    rE, rI, Df, fE, fI = ref['rE'], ref['rI'], ref['Df'], ref['fE'], ref['fI']
    return dict(
        pf_m_stag=pE + LO * D, pf_m_orol=pE + HI * D,           # -1h estate: STAG se <=, OROL se >=
        pf_p_orol=pI - HI * D, pf_p_stag=pI - LO * D,           # +1h inverno: OROL se <=, STAG se >=
        n_m_stag=(rE + LO * Df) * fE, n_m_orol=(rE + HI * Df) * fE,
        n_p_orol=(rI - HI * Df) * fI, n_p_stag=(rI - LO * Df) * fI)


# ------------------------------------------------------------------ cancelli
def s1(rows, orologio, rows_d0=None):
    """la manopola deve MORDERE (classe 156). Ritorna ('VERDE'|'ROSSO', testo)."""
    if not rows:
        return 'ROSSO', 'per-trade vuoto'
    t = [r['t'] for r in rows]
    c = S1[orologio]
    if orologio == 'd0':
        ok = min(t) >= c['min_uscita'] and max(t) < c['max_uscita']
        return ('VERDE' if ok else 'ROSSO'), 'min %s max %s' % (min(t), max(t))
    if rows_d0 is not None and [(r['ct'], r['net']) for r in rows] == [(r['ct'], r['net']) for r in rows_d0]:
        return 'ROSSO', 'per-trade identico alla d0'
    if orologio == 'm1h':
        q = sum(x < c['prima_di'] for x in t) / len(t)
        ok = min(t) >= c['min_uscita'] and max(t) < c['max_uscita'] and q >= c['quota_min']
        return ('VERDE' if ok else 'ROSSO'), 'min %s max %s, quota prima delle %s = %.3f' % (
            min(t), max(t), c['prima_di'], q)
    q = sum(x >= c['dopo_di'] for x in t) / len(t)
    ok = min(t) >= c['min_uscita'] and max(t) < c['max_uscita'] and q >= c['quota_min']
    return ('VERDE' if ok else 'ROSSO'), 'min %s max %s, quota dalle %s = %.3f' % (min(t), max(t), c['dopo_di'], q)


def g1_pertrade(a, b):
    """campi che decidono identici, net_profit entro TOL_NET per riga. Ritorna (esito, motivo)."""
    if len(a) != len(b):
        return 'NULLO', 'righe %d contro %d' % (len(a), len(b))
    for i, (x, y) in enumerate(zip(a, b)):
        for k in ('ct', 'pid', 'tipo', 'vol', 'px'):
            if x[k] != y[k]:
                return 'NULLO', 'riga %d campo %s' % (i + 1, k)
        if abs(x['net'] - y['net']) > TOL_NET + 1e-9:
            return 'NULLO', 'riga %d net_profit %.2f contro %.2f' % (i + 1, x['net'], y['net'])
    return 'PASS', ''


def g1_csv(r1, r2):
    """righe CSV come dict Trades, PF, Profit, DD."""
    if r1['Trades'] != r2['Trades']:
        return 'NULLO'
    if round(r1['PF'], 4) != round(r2['PF'], 4):
        return 'NULLO'
    if abs(r1['Profit'] - r2['Profit']) > TOL_PROFIT + 1e-9 or abs(r1['DD'] - r2['DD']) > TOL_DD + 1e-9:
        return 'NULLO'
    return 'PASS'


def s2(rows_d0, rows_sp, dopo=WARMUP_FINE):
    """sentinella del confondente (classe 768): stesso bias H4 per giorno -> sui giorni
    in cui entrano tutte e due, lo STESSO verso. Conta i giorni in verso opposto dopo il seme."""
    a = {r['d']: r['tipo'] for r in rows_d0}
    b = {r['d']: r['tipo'] for r in rows_sp}
    comuni = [d for d in a if d in b and d >= dopo]
    opp = [d for d in comuni if a[d] != b[d]]
    return len(comuni), len(opp)


# ------------------------------------------------------------------ bande
def q_(b, p):
    s = sorted(b)
    return s[min(len(s) - 1, int(p * len(s)))]


def boot_pf(lista, n):
    return pf_pos([random.choice(lista) for _ in range(n)])


def bande(pos, ref, rip=5000, seme=250):
    """p10-p90 del PF delle celle spostate sotto le due ipotesi. Ritorna dict."""
    random.seed(seme)
    E, I = pos['E'], pos['I']
    out = {}
    for nome, sS, sO, rS, rO, fer in (('m1h_estate', E, I, ref['rE'], ref['rI'], ref['fE']),
                                      ('p1h_inverno', I, E, ref['rI'], ref['rE'], ref['fI'])):
        nS, nO = round(rS * fer), round(rO * fer)
        bS = [boot_pf(sS, nS) for _ in range(rip)]
        bO = [boot_pf(sO, nO) for _ in range(rip)]
        out[nome] = dict(nS=nS, nO=nO, S=(q_(bS, .1), q_(bS, .5), q_(bS, .9)), O=(q_(bO, .1), q_(bO, .5), q_(bO, .9)))
    return out


def regola(pos, ref, rip=6000, seme=2502):
    """probabilita' (STAGIONE ; MISTO ; OROLOGIO) della regola com'e' scritta (classe 764),
    riferimenti FISSI (G0 VERDE), per Q, Q2, Qc (PF) e Qf, Qf2, Qfc (frequenza)."""
    random.seed(seme)
    E, I = pos['E'], pos['I']
    res = {}
    for H in ('STAGIONE', 'OROLOGIO'):
        cont = {k: collections.Counter() for k in ZONATE}
        vals = {'Qc': [], 'Qfc': [], 'S': [], 'Sf': []}
        for _ in range(rip):
            if H == 'STAGIONE':
                srcm, rm, srcp, rp = E, ref['rE'], I, ref['rI']
            else:
                srcm, rm, srcp, rp = I, ref['rI'], E, ref['rE']
            xm = boot_pf(srcm, round(rm * ref['fE']))
            xp = boot_pf(srcp, round(rp * ref['fI']))
            nm = sum(random.random() < rm for _ in range(ref['fE']))
            np_ = sum(random.random() < rp for _ in range(ref['fI']))
            s = statistiche(ref, xm, xp, nm, np_)
            for k in ZONATE:
                cont[k][zona(s[k])] += 1
            for k in vals:
                vals[k].append(s[k])
        res[H] = {k: tuple(c[z] / rip for z in ('STAGIONE', 'MISTO', 'OROLOGIO')) for k, c in cont.items()}
        res[H]['S_banda'] = {k: (q_(vals[k], .1), q_(vals[k], .9)) for k in ('S', 'Sf')}
        res[H]['bande'] = {k: (q_(v, .1), q_(v, .5), q_(v, .9)) for k, v in vals.items()}
    return res


def banda_pos(r, giorni):
    """p10-p90 binomiale (normale) delle posizioni su 'giorni' feriali al tasso r."""
    sd = (r * (1 - r) / giorni) ** 0.5
    return (r - 1.2816 * sd) * giorni, (r + 1.2816 * sd) * giorni


# ------------------------------------------------------------------ ancore
def controlli(dati):
    ok = True
    for k in ('A', 'B'):
        rows, pos, ref = dati[k]
        a = ANCORE[k]
        somma = round(sum(r['net'] for r in rows), 2)
        c = [len(rows) == a['deal'], len({r['pid'] for r in rows}) == a['deal'],
             abs(somma - a['somma']) < 0.005, ref['nE'] == a['nE'], ref['nI'] == a['nI'],
             round(ref['pE'], 3) == a['pfE'], round(ref['pI'], 3) == a['pfI']]
        esito = all(c)
        ok &= esito
        print('  ancora %s: %d deal = %d posizioni, somma %.2f, estate %d PF %.3f, inverno %d PF %.3f -> %s'
              % (k, len(rows), len({r['pid'] for r in rows}), somma, ref['nE'], ref['pE'], ref['nI'], ref['pI'],
                 'OK' if esito else 'ROSSO'))
    return ok


def carica_tutto():
    dati = {}
    for k in ('A', 'B'):
        rows = leggi_pt(PT[k])
        pos = per_stagione(rows)
        dati[k] = (rows, pos, riferimenti(pos, feriali(*FIN[k])))
    posAB = unisci(dati['A'][1], dati['B'][1])
    fA, fB = feriali(*FIN['A']), feriali(*FIN['B'])
    dati['AB'] = (dati['A'][0] + dati['B'][0], posAB, riferimenti(posAB, (fA[0] + fB[0], fA[1] + fB[1])))
    return dati


# ------------------------------------------------------------------ main
def main():
    print('=== 0. ANCORE (per-trade R247 765271 = A, 765273 = B), calendario USA per data di chiusura ===')
    dati = carica_tutto()
    if not controlli(dati):
        print('ANCORA ROSSA: niente soglie.')
        return 1

    print()
    print('=== 1. RIFERIMENTI d0 (fissi se G0 VERDE) E SOGLIE DEL VERDETTO ===')
    for k in ('A', 'B', 'AB'):
        ref = dati[k][2]
        so = soglie(ref)
        print('%-2s feriali E=%d I=%d | pos E=%d I=%d | r E=%.4f I=%.4f Df=%.4f | PF E0=%.4f I0=%.4f D=%.4f'
              % (k, ref['fE'], ref['fI'], ref['nE'], ref['nI'], ref['rE'], ref['rI'], ref['Df'],
                 ref['pE'], ref['pI'], ref['D']))
        print('    PF  -1h estate : STAGIONE se <= %.4f, OROLOGIO se >= %.4f' % (so['pf_m_stag'], so['pf_m_orol']))
        print('    PF  +1h inverno: OROLOGIO se <= %.4f, STAGIONE se >= %.4f' % (so['pf_p_orol'], so['pf_p_stag']))
        print('    POS -1h estate : STAGIONE se <= %.2f, OROLOGIO se >= %.2f (su %d feriali)'
              % (so['n_m_stag'], so['n_m_orol'], ref['fE']))
        print('    POS +1h inverno: OROLOGIO se <= %.2f, STAGIONE se >= %.2f (su %d feriali)'
              % (so['n_p_orol'], so['n_p_stag'], ref['fI']))

    print()
    print('=== 2. BANDE p10-p50-p90 DEL PF DELLE CELLE SPOSTATE, seme 250, 5000 ricampionamenti ===')
    print('    contro-esempio (classe 178): la MEDIANA dell\'altra ipotesi deve cadere FUORI dalla banda p10-p90')
    esiti_ce = {}
    for k in ('A', 'B', 'AB'):
        rows, pos, ref = dati[k]
        bb = bande(pos, ref)
        for nome, v in bb.items():
            fuoriO = not (v['S'][0] <= v['O'][1] <= v['S'][2])
            fuoriS = not (v['O'][0] <= v['S'][1] <= v['O'][2])
            disg = v['S'][2] < v['O'][0] or v['O'][2] < v['S'][0]
            esiti_ce[(k, nome)] = fuoriO and fuoriS
            print('%-2s %-12s H_STAGIONE n=%3d [%.2f ; %.2f ; %.2f]  H_OROLOGIO n=%3d [%.2f ; %.2f ; %.2f]  '
                  'mediane fuori dalla banda altrui: %s / %s  bande %s'
                  % (k, nome, v['nS'], v['S'][0], v['S'][1], v['S'][2], v['nO'], v['O'][0], v['O'][1], v['O'][2],
                     'SI' if fuoriO else 'NO', 'SI' if fuoriS else 'NO', 'DISGIUNTE' if disg else 'SOVRAPPOSTE'))
        for nome, dd, rS, rO in (('POS -1h estate', ref['fE'], ref['rE'], ref['rI']),
                                 ('POS +1h inverno', ref['fI'], ref['rI'], ref['rE'])):
            bS, bO = banda_pos(rS, dd), banda_pos(rO, dd)
            disg = bS[1] < bO[0] or bO[1] < bS[0]
            print('%-2s %-16s H_STAGIONE [%.1f ; %.1f]  H_OROLOGIO [%.1f ; %.1f]  %s'
                  % (k, nome, bS[0], bS[1], bO[0], bO[1], 'DISGIUNTE' if disg else 'SOVRAPPOSTE'))

    print()
    print('=== 3. LA REGOLA COM\'E\' SCRITTA (classe 764), seme 2502, 6000; riferimenti fissi (G0 VERDE) ===')
    print('    triple = (STAGIONE ; MISTO ; OROLOGIO) se e\' vera l\'ipotesi indicata')
    for k in ('A', 'B', 'AB'):
        rows, pos, ref = dati[k]
        rr = regola(pos, ref)
        for H in ('STAGIONE', 'OROLOGIO'):
            t = rr[H]
            print('%-2s se H_%-8s PF: Q %s  Q2 %s  Qc %s | FREQ: Qf %s  Qf2 %s  Qfc %s'
                  % (k, H, *['(%.3f;%.3f;%.3f)' % t[x] for x in ('Q', 'Q2', 'Qc', 'Qf', 'Qf2', 'Qfc')]))
        for st in ('Qc', 'Qfc'):
            bS, bO = rr['STAGIONE']['bande'][st], rr['OROLOGIO']['bande'][st]
            fuoriO = not (bS[0] <= bO[1] <= bS[2])
            fuoriS = not (bO[0] <= bS[1] <= bO[2])
            print('   %-3s p10-p50-p90  H_STAGIONE [%.2f ; %.2f ; %.2f]  H_OROLOGIO [%.2f ; %.2f ; %.2f]  '
                  'mediane fuori dalla banda altrui: %s / %s -> %s'
                  % (st, bS[0], bS[1], bS[2], bO[0], bO[1], bO[2], 'SI' if fuoriO else 'NO',
                     'SI' if fuoriS else 'NO', 'DISCRIMINA' if (fuoriO and fuoriS) else 'NON DISCRIMINANTE'))
        for st in ('S', 'Sf'):
            print('   %-3s (interazione, descrittiva) p10-p90  H_STAGIONE [%.2f ; %.2f]  H_OROLOGIO [%.2f ; %.2f]'
                  % (st, *rr['STAGIONE']['S_banda'][st], *rr['OROLOGIO']['S_banda'][st]))

    print()
    print('=== 4. S1: TARATURA SUL PER-TRADE d0 (R247), ora di chiusura BCM ===')
    for k in ('A', 'B'):
        rows = dati[k][0]
        t = [r['t'] for r in rows]
        n = len(t)
        print('%s n=%d min %s max %s | prima delle 15:45 %d (%.3f) -> a -1h cadono prima delle 14:45 | '
              'dalle 16:31 %d (%.3f) -> a +1h cadono dalle 17:31'
              % (k, n, min(t), max(t), sum(x < '15:45' for x in t), sum(x < '15:45' for x in t) / n,
                 sum(x >= '16:31' for x in t), sum(x >= '16:31' for x in t) / n))
    for k, v in S1.items():
        print('    soglie S1 %-3s: %s' % (k, ', '.join('%s=%s' % kv for kv in sorted(v.items()))))

    print()
    print('=== 5. IL CONFONDENTE H4 (classe 768): candela letta alla decisione (armo + 15\') ===')
    for nome, hh in (('-1h', 13), ('d0', 14), ('+1h', 15)):
        dec = hh * 60 + 30 + 15
        corr = (dec // 240) * 240
        prec = corr - 240
        print('    %-3s decisione %02d:%02d BCM -> H4 in corso %02d:00-%02d:00, shift 1 = %02d:00-%02d:00'
              % (nome, dec // 60, dec % 60, corr // 60, (corr + 240) // 60, prec // 60, corr // 60))
    return 0


# ------------------------------------------------------------------ autotest
def autotest():
    fall = 0

    def chk(nome, cond):
        nonlocal fall
        print('  %-66s %s' % (nome, 'OK' if cond else 'FALLITO'))
        if not cond:
            fall += 1

    dati = carica_tutto()
    rowsA, posA, refA = dati['A']
    chk('T1 ancore A/B rifatte da file scritti da altri', controlli(dati))
    chk('T1b calendario USA: feriali A 107/90, B 170/90',
        feriali(*FIN['A']) == (107, 90) and feriali(*FIN['B']) == (170, 90))
    # T2: celle spostate IDENTICHE alla d0 -> Q = Q2 = 0 -> STAGIONE
    s = statistiche(refA, refA['pE'], refA['pI'], refA['nE'], refA['nI'])
    chk('T2 spostata = d0 -> Q=Q2=Qc=0, Qf=Qf2=0 -> STAGIONE',
        all(abs(s[k]) < 1e-12 for k in s) and zona(s['Qc']) == 'STAGIONE')
    # T3: contro-esempio H_OROLOGIO piantato: -1h estate = pool d'inverno, +1h inverno = pool d'estate
    s = statistiche(refA, pf_pos(posA['I']), pf_pos(posA['E']), round(refA['rI'] * refA['fE']),
                    round(refA['rE'] * refA['fI']))
    chk('T3 H_OROLOGIO piantato -> Qc=1 -> OROLOGIO', abs(s['Qc'] - 1) < 1e-9 and zona(s['Qc']) == 'OROLOGIO')
    chk('T3b ... e la frequenza -> Qfc ~ 1 -> OROLOGIO', zona(s['Qfc']) == 'OROLOGIO')
    # T4: la stessa cella letta con la formula SBAGLIATA (Q2 col segno di Q) darebbe l'opposto
    q2_sbagliato = (pf_pos(posA['E']) - refA['pI']) / refA['D']
    chk('T4 segno di Q2: la formula col segno di Q darebbe -1 (non OROLOGIO)', zona(q2_sbagliato) == 'STAGIONE')
    # T5: S1
    d0 = rowsA

    def sposta(rows, ore):
        out = []
        for r in rows:
            h = int(r['t'][:2]) + ore
            t = '%02d%s' % (h, r['t'][2:])
            out.append(dict(r, t=t, ct=r['ct'][:11] + t))
        return out
    chk('T5a S1 d0 sul per-trade R247 -> VERDE', s1(d0, 'd0')[0] == 'VERDE')
    chk('T5b S1 -1h con il per-trade spostato di -1h -> VERDE', s1(sposta(d0, -1), 'm1h', d0)[0] == 'VERDE')
    chk('T5c S1 -1h con il pin NON arrivato (orari d0) -> ROSSO', s1(d0, 'm1h', d0)[0] == 'ROSSO')
    chk('T5d S1 +1h con il per-trade spostato di +1h -> VERDE', s1(sposta(d0, +1), 'p1h', d0)[0] == 'VERDE')
    chk('T5e S1 +1h con il pin NON arrivato (orari d0) -> ROSSO', s1(d0, 'p1h', d0)[0] == 'ROSSO')
    cap = [dict(r, t=min(r['t'], '17:30:00')) for r in sposta(d0, +1)]
    chk('T5f S1 +1h con InpCloseHour NON arrivato (flat 17:30) -> ROSSO', s1(cap, 'p1h', d0)[0] == 'ROSSO')
    early = [dict(r, t=r['t']) for r in sposta(d0, -1)]
    early = [dict(r, t=max(r['t'], '14:45:00')) for r in early]
    chk('T5g S1 -1h con InpSessionHour NON arrivato (niente prima delle 14:45) -> ROSSO',
        s1(early, 'm1h', d0)[0] == 'ROSSO')
    # T6: G1 sui campi che decidono
    gem = [dict(r) for r in d0]
    chk('T6a G1 gemelle identiche -> PASS', g1_pertrade(d0, gem)[0] == 'PASS')
    gem[1] = dict(gem[1], net=gem[1]['net'] - 0.01)
    chk('T6b G1 un centesimo su un deal (caso R246a) -> PASS (tolleranza scritta prima)',
        g1_pertrade(d0, gem)[0] == 'PASS')
    gem[1] = dict(gem[1], net=gem[1]['net'] - 0.01)
    chk('T6c G1 due centesimi -> NULLO', g1_pertrade(d0, gem)[0] == 'NULLO')
    gem = [dict(r) for r in d0]
    gem[5] = dict(gem[5], px='1.00')
    chk('T6d G1 prezzo diverso -> NULLO', g1_pertrade(d0, gem)[0] == 'NULLO')
    chk('T6e G1 CSV Profit +0,06 -> NULLO',
        g1_csv(dict(Trades=154, PF=1.25176, Profit=1180.94, DD=7.1002),
               dict(Trades=154, PF=1.25176, Profit=1181.00, DD=7.1002)) == 'NULLO')
    # T7: classe 772/775/781 -- un file NULLO non vota
    tutti = {n: 'VALIDO' for n in ('R250a', 'R250b', 'R250c', 'R250d', 'R250e', 'R250f')}
    g0 = {'R250a': 'VERDE', 'R250b': 'VERDE'}
    mis = dict(pf_m=pf_pos(posA['I']), pf_p=pf_pos(posA['E']), n_m=90, n_p=66)
    sOK, zOK = verdetto(tutti, g0, refA, mis, 'A')
    chk('T7a tutto VALIDO -> Qc leggibile', zOK['Qc'] == 'OROLOGIO')
    st = dict(tutti, R250c='NULLO')
    s7, z7 = verdetto(st, g0, refA, mis, 'A')
    chk('T7b R250c NULLO -> Q e Qc NON LEGGIBILE, Q2 si legge',
        z7['Q'] == 'NON LEGGIBILE' and z7['Qc'] == 'NON LEGGIBILE' and z7['Q2'] == 'OROLOGIO')
    s7, z7 = verdetto(tutti, dict(g0, R250a='ROSSO'), refA, mis, 'A')
    chk('T7c G0 della d0 non VERDE -> NIENTE si legge', all(v == 'NON LEGGIBILE' for k, v in z7.items()
                                                           if not k.startswith('congiunta')))
    s7, z7 = verdetto(dict(tutti, R250d='MOTORE DIVERSO'), g0, refA, mis, 'AB')
    chk('T7d classe 775: R250d col motore diverso -> Q e Qc su A+B NON LEGGIBILE',
        z7['Q'] == 'NON LEGGIBILE' and z7['Qc'] == 'NON LEGGIBILE')
    # T8: S2
    sp = [dict(r) for r in d0]
    chk('T8a S2 stesso verso ogni giorno -> 0 opposti', s2(d0, sp)[1] == 0)
    i = next(j for j, r in enumerate(sp) if r['d'] >= WARMUP_FINE)
    sp[i] = dict(sp[i], tipo=1 - sp[i]['tipo'])
    chk('T8b S2 un giorno in verso opposto dopo il seme -> 1', s2(d0, sp)[1] == 1)
    sp = [dict(r) for r in d0]
    sp[0] = dict(sp[0], tipo=1 - sp[0]['tipo'])
    chk('T8c S2 verso opposto nei giorni del seme (bias 0) -> non conta', s2(d0, sp)[1] == 0)
    # T9: il contro-esempio della banda -- con D=0 (niente divario) le mediane NON si separano
    fint = {'E': posA['E'], 'I': posA['E']}
    reff = riferimenti(fint, feriali(*FIN['A']))
    bb = bande(fint, reff, rip=400, seme=9)['m1h_estate']
    chk('T9 divario nullo piantato -> le bande NON separano (mediana dentro)',
        bb['S'][0] <= bb['O'][1] <= bb['S'][2])
    # T10: contro-esempio "lo spostamento peggiora tutto" (d0 = punto selezionato): Qc
    # non si muove, S si'. Sotto H_STAGIONE e sotto H_OROLOGIO.
    dl = 0.15
    for H, xm, xp, att in (('STAGIONE', refA['pE'], refA['pI'], 0.0), ('OROLOGIO', refA['pI'], refA['pE'], 1.0)):
        s10 = statistiche(refA, xm - dl, xp - dl, None, None)
        chk('T10 %s + spostamento che peggiora di 0,15 -> Qc=%.0f, S=+0,15/D' % (H, att),
            abs(s10['Qc'] - att) < 1e-9 and abs(s10['S'] - dl / refA['D']) < 1e-9)
    print('autotest: %d falliti' % fall)
    return 1 if fall else 0


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(autotest())
    sys.exit(main())
