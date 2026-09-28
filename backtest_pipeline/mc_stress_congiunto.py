#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_stress_congiunto.py -- 28/09/2026

LO STRESS CONGIUNTO DEL MONTE CARLO DELLA CHALLENGE FTMO 541452707.
Referto: report/MC_STRESS_CONGIUNTO_2026-09-28.md
Nasce dai punti 1 e 5 del parere di Emiliano (docs/PARERE_EMILIANO_2026-09-28.md):
  (1) "il Guardiano interviene al limite formale, ma slippage, commissioni,
      posizioni simultanee e latenza possono portarti oltre prima che la
      chiusura sia completata";
  (5) "prova stress con clustering delle perdite e peggioramento simultaneo di
      spread e slippage".

NON modifica mc_challenge_ftmo_v2.py (commit 1c0029a6) ne' la v1: li IMPORTA e
ne RIUSA carica_v2(), calendario(), blocchi(), scenari(), simula_v2() e le
costanti dello stato e del Guardian. Aggiunge SOLO le perturbazioni. SOLA
LETTURA: nessun EA, preset, conto o file di campo toccato. NESSUNA PROPOSTA di
taglia, di cap o di soglia del Guardian: sono firme di Claudio.

BASE = la riga "BLK B: 4 sedie + 770105" del v2 (il campo di oggi per quanto i
dati permettono), taglia indici 2,00% (fattore 2,0), Guardian 4,5 / 9,3,
campionamento delle giornate SENZA reimmissione (come la v1 e il v2).

STATO DI PARTENZA
  27/09 (referto v2): saldo 75.090,72 (st.SALDO_OGGI) -> serve SOLO al
         contro-esempio: la base deve ridare 55,1 (semi 55,0/54,4/55,2).
  28/09 (questo referto): saldo 75.841,54 = 75.090,72 + 750,82 (trade del
         weekend 771531 chiuso, report/NOTTE_2026-09-28.md, incrociato col
         Guardian eq=75841.54). Giorni di trading ancora da fare: 1 come nel v2
         (se il 28/09 conti gia' come giorno FTMO e' [NON VERIFICATO]; la
         sensibilita' min_giorni=0 si stampa).

LE PERTURBAZIONI (valori scritti PRIMA dei numeri, fonte nel referto par.1)
  (a) SUPERAMENTO ALLA FERMATA. Quando il Guardian chiude (taglio giornaliero
      4,5% del banco o emergenza totale a 72.560 = 9,3%), la perdita finale
      non e' la soglia ma soglia + sup x k x stop, con stop = 1 posizione alla
      taglia (0,01 x fattore x saldo d'inizio giornata) e k = posizioni aperte
      in quel momento (1; 2 = il cap C1 4,00 a 2,00%). sup in {0,10; 0,25;
      0,50} dello stop. Una chiusura sola al giorno: se nella stessa giornata
      scattano taglio e totale, il superamento si applica UNA volta, dal
      livello che scatta per primo (il piu' basso in perdita). Con sup=0 il
      simulatore e' bit per bit quello del v2 (contro-esempio Z1).
  (b) COSTI PEGGIORATI, per posizione, dai VOLUMI veri del per-trade:
        costo_deal = [(ms - 1) x s_simbolo + p] x volume_deal x q_simbolo
      ms = moltiplicatore dello spread (1,5 / 2,0), s = spread di BASE del
      backtest all'ora d'ingresso (D30EUR 1,70, U30USD 3,00 punti indice),
      p = slittamento d'ingresso in punti indice (1 / 3), q = EUR per punto per
      lotto MISURATO dal file (coppie di deal d'uscita della stessa posizione).
      Il costo e' ripartito sui deal d'uscita per volume e datato come il deal
      (stessa datazione delle giornate del v2).
  (c) PERDITE A GRAPPOLO: ricampionamento a BLOCCHI CIRCOLARI di L giornate
      di borsa consecutive del calendario B (L = 5 e 10), e SETTIMANE intere
      (ISO) con il 10% peggiore (per somma della base) a PESO 3. Riferimento a
      disegno neutro: L = 1 (= v2 con reimmissione, bit per bit: Z3). E il
      RUMORE D'ORDINAMENTO (nulla_blocchi): la stessa differenza blocchi - L=1
      su 40 calendari mescolati a caso; il calendario vero si legge CONTRO
      quella nube, non contro lo zero.
  INSIEME (dichiarati prima):
      I1 moderato = (a) 25% k1 + (b) spread x1,5 + 1 punto + (c) blocchi 5
      I2 severo   = (a) 50% k2 + (b) spread x2   + 3 punti + (c) blocchi 10
      I3 severo+  = (a) 50% k2 + (b) spread x2   + 3 punti + (c) settimane peggiori x3

USO
  python3 backtest_pipeline/mc_stress_congiunto.py --autotest   # contro-esempi, esce 0 se verde
  python3 backtest_pipeline/mc_stress_congiunto.py              # tabelle del referto (~6-8 min)
"""
import argparse, bisect, collections, csv, datetime as dt, os, random, statistics, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo_stato as st              # noqa: E402
import mc_challenge_ftmo_v2 as v2                 # noqa: E402

BANCO = st.BANCO
SALDO_2709 = st.SALDO_OGGI                        # 75.090,72 (referto v2)
PNL_WEEKEND = 750.82                              # NOTTE_2026-09-28: +743,56 profitto +7,26 swap
SALDO_2809 = 75841.54                             # NOTTE_2026-09-28, Guardian eq=75841.54
S_2709, S_2809 = SALDO_2709 / BANCO, SALDO_2809 / BANCO
FATT = 2.0                                        # taglia indici in campo 2,00%
SEME, SEMI_BANDA, NSIM = v2.SEME, v2.SEMI_BANDA, v2.NSIM
KW = dict(v2.KW_CAMPO)                            # guardian 0,045 / g_tot 0,093 / min_giorni 1
ANCORA_BASE_2709 = (55.1, (55.0, 54.4, 55.2))     # referto 27/09 par.3, riga "BLK B + 770105"
NOMI_BASE = v2.V1 + ['770105 DAXshort']

# (b) spread di BASE del backtest all'ora d'ingresso, punti indice (report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md
#     r.193-194: D30EUR ora 8 = 1,70; U30USD ora 14 = 2,00 o 3,00 secondo la fonte -> si usa 3,00, il lato pessimista)
SPREAD_BASE = {'D30EUR': 1.70, 'U30USD': 3.00}

SCEN_A = [(0.10, 1), (0.25, 1), (0.50, 1), (0.10, 2), (0.25, 2), (0.50, 2)]
SCEN_B = [('spread x1,5', 1.5, 0.0), ('spread x2', 2.0, 0.0), ('ingresso +1 punto', 1.0, 1.0),
          ('ingresso +3 punti', 1.0, 3.0), ('spread x2 + ingresso +1 punto', 2.0, 1.0)]
SCEN_C = [('IID giornate (L=1, riferimento neutro)', 'blocchi', 1, 1.0), ('blocchi 5 giornate', 'blocchi', 5, 1.0),
          ('blocchi 10 giornate', 'blocchi', 10, 1.0), ('settimane intere, peso 1', 'settimane', 0, 1.0),
          ('settimane intere, 10% peggiori x3', 'settimane', 0, 3.0)]
INSIEME = [('I1 moderato: sup 25% k1 + spread x1,5 + 1 pt + blocchi 5', 0.25, 1, 1.5, 1.0, 'blocchi', 5, 1.0),
           ('I2 severo: sup 50% k2 + spread x2 + 3 pt + blocchi 10', 0.50, 2, 2.0, 3.0, 'blocchi', 10, 1.0),
           ('I3 severo+: sup 50% k2 + spread x2 + 3 pt + settimane peggiori x3', 0.50, 2, 2.0, 3.0, 'settimane', 0, 3.0)]
QUOTA_PEGGIORI = 0.10


# ---------------------------------------------------------------- dati (sola lettura)
def carica_deal(nomi):
    """Per sedia: lista dei deal d'uscita (data, simbolo, volume, prezzo, net, position_id), in ordine di file."""
    out = {}
    for n in nomi:
        rel = v2.SORGENTI_V2[n][0]
        with open(os.path.join(QUI, rel), newline='') as fh:
            out[n] = [(r['close_time'][:10], r['symbol'], float(r['volume']), float(r['price']),
                       float(r['net_profit']), r['position_id']) for r in csv.DictReader(fh, delimiter=';')]
    return out


def misura_q(deal):
    """EUR per punto per lotto, per simbolo, MISURATO: coppie di deal d'uscita della stessa posizione, stesso
       volume, prezzi diversi (> 0,5 punti): q = |net1 - net2| / (|p1 - p2| x vol). Mediana per simbolo."""
    per = collections.defaultdict(list)
    for n, ds in deal.items():
        pos = collections.OrderedDict()
        for d in ds:
            pos.setdefault(d[5], []).append(d)
        for lista in pos.values():
            for i in range(len(lista)):
                for j in range(i + 1, len(lista)):
                    a, b = lista[i], lista[j]
                    if abs(a[3] - b[3]) > 0.5 and abs(a[2] - b[2]) < 1e-9 and a[2] > 0:
                        per[a[1]].append(abs((a[4] - b[4]) / ((a[3] - b[3]) * a[2])))
    return dict((s, (statistics.median(v), len(v), min(v), max(v))) for s, v in per.items())


def costo_giorni(deal, nomi, cal, q, ms, p, dati):
    """(b) Costo extra per giornata del calendario, nelle unita' del v2 (frazione del deposito di misura, alla
       misura 1%): somma su sedie e deal di [(ms-1) x s + p] x vol x q / deposito. None se ms=1 e p=0."""
    if ms == 1.0 and p == 0.0:
        return None
    idx = dict((d, i) for i, d in enumerate(cal))
    c = [0.0] * len(cal)
    for n in nomi:
        dep = dati[n]['dep']
        for d, sim, vol, _, _, _ in deal[n]:
            if d in idx:
                c[idx[d]] += ((ms - 1.0) * SPREAD_BASE[sim] + p) * vol * q[sim][0] / dep
    return c


def costo_R_per_sedia(deal, nomi, q, ms, p, dati):
    """Costo medio per posizione, in R (R = rischio di misura = rmis% del deposito)."""
    out = {}
    for n in nomi:
        pos = collections.defaultdict(float)
        for d, sim, vol, _, _, pid in deal[n]:
            pos[pid] += ((ms - 1.0) * SPREAD_BASE[sim] + p) * vol * q[sim][0]
        R = dati[n]['dep'] * dati[n]['rmis'] / 100.0
        out[n] = (statistics.mean(pos.values()) / R, len(pos))
    return out


def settimane(cal):
    """Indici del calendario raggruppati per settimana ISO, in ordine."""
    g = collections.OrderedDict()
    for i, d in enumerate(cal):
        y, w, _ = v2.data(d).isocalendar()
        g.setdefault((y, w), []).append(i)
    return list(g.values())


def pesi_settimane(sett, fisso, peso):
    """Peso 'peso' al QUOTA_PEGGIORI peggiore delle settimane (somma della base), 1 alle altre."""
    somme = [sum(fisso[i] for i in s) for s in sett]
    n_p = max(1, int(round(QUOTA_PEGGIORI * len(sett))))
    peggiori = sorted(range(len(sett)), key=lambda j: somme[j])[:n_p]
    w = [1.0] * len(sett)
    for j in peggiori:
        w[j] = peso
    return w, peggiori, somme


# ---------------------------------------------------------------- simulatore
def simula_stress(fisso, fattore, saldo_iniziale, guardian=None, g_tot=None, min_giorni=4, attivo=None,
                  n_sim=NSIM, seme=SEME, target=0.10, muro_stat=0.10, muro_gior=0.05, max_giorni=800,
                  orizzonte=5, slip=1.0, reimmissione=False, costo=None, sup=0.0, k_pos=1,
                  campione='perm', L=1, sett=None, pesi=None):
    """Copia di st.simula_stato / v2.simula_v2 (comp=None) con TRE agganci, tutti inerti a valore zero:
         costo[k]  : sottratto al valore della giornata k PRIMA del fattore (b);
         sup,k_pos : superamento alla chiusura del Guardian (a);
         campione  : 'perm' (come la v1: permutazioni senza reimmissione, o reimmissione=True),
                     'blocchi' (blocchi circolari di L giornate), 'settimane' (settimane intere, pesi) (c).
       Il generatore si consuma ESATTAMENTE come la v1 con campione='perm' e come simula_v2(reimmissione=True)
       con 'blocchi' L=1: e' la prima cosa che --autotest verifica (Z1, Z3)."""
    rnd = random.Random(seme)
    N = len(fisso)
    idx = list(range(N))
    esiti = collections.Counter(); d_pass = []; d_fine = []
    entro = collections.Counter()
    if campione == 'settimane':
        cum, t = [], 0.0
        for w in pesi:
            t += w; cum.append(t)
    for _ in range(n_sim):
        s = idx[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; gt = 0; esito = None; i = 0
        pb = 0; start = 0; coda = []
        while esito is None:
            if campione == 'perm':
                if reimmissione:
                    k = rnd.randrange(N)
                else:
                    if i >= len(s):
                        s2 = idx[:]; rnd.shuffle(s2); s = s + s2
                    k = s[i]; i += 1
            elif campione == 'blocchi':
                if pb == 0:
                    start = rnd.randrange(N)
                k = (start + pb) % N
                pb = (pb + 1) % L
            else:
                if not coda:
                    w = bisect.bisect_right(cum, rnd.random() * t)
                    coda = list(sett[min(w, len(sett) - 1)])
                k = coda.pop(0)
            b0 = bal
            v = fisso[k]
            if costo is not None:
                v = v - costo[k]
            r = v * fattore
            if r < 0:
                r *= slip
            perdita = -r * b0
            taglio = False
            if guardian is not None and perdita > guardian:
                perdita = guardian
                r = -perdita / b0
                taglio = True
            bal = b0 + r * b0
            g += 1
            if attivo is None or attivo[k]:
                gt += 1
            ov = sup * k_pos * 0.01 * fattore * b0
            if g_tot is not None and bal <= 1.0 - g_tot:
                bal = (1.0 - g_tot) - ov                 # chiusura d'emergenza dal livello 72.560 (+ superamento)
            elif taglio:
                bal = bal - ov                           # chiusura del taglio giornaliero (+ superamento)
            if (b0 - bal) > muro_gior:
                esito = 'MORTE_GIORNALIERA'
            elif bal < 1.0 - muro_stat:
                esito = 'MORTE_STATICA'
            elif g_tot is not None and bal <= 1.0 - g_tot:
                esito = 'FERMATA_GUARDIAN'
            elif bal >= 1.0 + target and gt >= min_giorni:
                esito = 'PASS'
            elif g >= max_giorni:
                esito = 'TIMEOUT'
        esiti[esito] += 1
        (d_pass if esito == 'PASS' else d_fine).append(g)
        if g <= orizzonte:
            entro[esito] += 1
    tot = float(sum(esiti.values()))
    return {'p': dict((k, 100.0 * v / tot) for k, v in esiti.items()),
            'med_pass': statistics.median(d_pass) if d_pass else None,
            'med_fine': statistics.median(d_fine) if d_fine else None,
            'entro': dict((k, 100.0 * v / tot) for k, v in entro.items())}


def muro(o):
    return o['p'].get('MORTE_GIORNALIERA', 0.0) + o['p'].get('MORTE_STATICA', 0.0)


def fine5(o):
    return sum(v for k, v in o['entro'].items() if k != 'PASS')


def nulla_blocchi(fB, aB, L, n_perm=40, n_sim=5000, seme0=5000):
    """RUMORE D'ORDINAMENTO dei blocchi: per n_perm ordinamenti a caso del calendario (giornate e flag 'attivo'
       mescolati insieme, stessi valori), PASS(blocchi L) - PASS(L=1), seme 11, n_sim simulazioni. Se il
       calendario vero cade dentro questa nube, il suo 'grappolo' non si distingue da un ordine a caso."""
    out = []
    kw = dict(KW, n_sim=n_sim)
    for j in range(n_perm):
        rnd = random.Random(seme0 + j)
        z = list(zip(fB, aB)); rnd.shuffle(z)
        f = [x for x, _ in z]; a = [y for _, y in z]
        o1 = simula_stress(f, FATT, S_2809, attivo=a, campione='blocchi', L=1, **kw)
        oL = simula_stress(f, FATT, S_2809, attivo=a, campione='blocchi', L=L, **kw)
        out.append(oL['p'].get('PASS', 0) - o1['p'].get('PASS', 0))
    return out


# ---------------------------------------------------------------- costruzione della base
def prepara():
    dati = v2.carica_v2()
    S = v2.scenari(dati)
    calB = S['calB']
    fB, aB = v2.blocchi(dati, NOMI_BASE, calB, FATT)
    deal = carica_deal(NOMI_BASE)
    q = misura_q(deal)
    return dati, S, calB, fB, aB, deal, q


def corri(fB, aB, saldo, seme, **pert):
    kw = dict(KW); kw.update(pert)
    return simula_stress(fB, FATT, saldo, attivo=aB, seme=seme, **kw)


def riga(nome, o, banda, rif=None):
    p = o['p']
    s = ("  %-66s PASS %5.1f | FERM %5.1f | muroGG %4.1f | muro10 %4.1f | MURO %4.1f | fine<=5 %4.1f | ggPASS %4s | ggFINE %4s" % (
        nome, p.get('PASS', 0), p.get('FERMATA_GUARDIAN', 0), p.get('MORTE_GIORNALIERA', 0), p.get('MORTE_STATICA', 0),
        muro(o), fine5(o), o['med_pass'], o['med_fine']))
    if banda:
        s += " | semi 12-14 PASS %s FERM %s MURO %s" % tuple("/".join("%.1f" % f(b) for b in banda) for f in (
            lambda b: b['p'].get('PASS', 0), lambda b: b['p'].get('FERMATA_GUARDIAN', 0), muro))
    if rif is not None:
        s += " | dPASS vs %s %+.1f" % (rif[0], p.get('PASS', 0) - rif[1]['p'].get('PASS', 0))
    print(s)
    sys.stdout.flush()


# ---------------------------------------------------------------- autotest
def autotest():
    ok = True

    def chk(nome, cond, dettaglio=''):
        nonlocal ok
        print("  [%s] %s %s" % ('PASS' if cond else 'FAIL', nome, dettaglio))
        ok = ok and bool(cond)

    print("AUTOTEST mc_stress_congiunto.py")
    dati, S, calB, fB, aB, deal, q = prepara()
    base, _ = S['G0_pool']; fer_pool, fer_att = S['G0_fer']
    # Z0 stato
    chk("Z0 stato: 75.090,72 + 750,82 = 75.841,54 (NOTTE_2026-09-28)", round(SALDO_2709 + PNL_WEEKEND, 2) == SALDO_2809,
        "-> %.2f" % (SALDO_2709 + PNL_WEEKEND))
    # Z1 a perturbazione zero == la v1 / il v2, bit per bit
    casi = [(base, None, 1.0, S_2709), (fer_pool, fer_att, 1.0, S_2709), (fer_pool, fer_att, st.SLIP_MISURATO, S_2709),
            (fB, aB, 1.0, S_2709), (fB, aB, 1.0, S_2809)]
    for pool, att, sl, s0 in casi:
        a = st.simula_stato(pool, FATT, s0, attivo=att, slip=sl, **KW)
        b = simula_stress(pool, FATT, s0, attivo=att, slip=sl, **KW)
        chk("Z1 perturbazione zero == st.simula_stato (n=%d, slip %.3f, saldo %.2f)" % (len(pool), sl, s0 * BANCO), a == b,
            "-> %.4f / %.4f" % (a['p']['PASS'], b['p']['PASS']))
    a = st.simula_stato(fB, FATT, S_2809, attivo=aB, guardian=None, g_tot=None, min_giorni=1)
    b = simula_stress(fB, FATT, S_2809, attivo=aB, guardian=None, g_tot=None, min_giorni=1, sup=0.5, k_pos=2)
    chk("Z1' Guardian SPENTO: il superamento non agisce (nessuna chiusura) -> identico alla v1", a == b)
    # Z2 le ancore del referto 27/09
    o = simula_stress(base, FATT, S_2709, **KW)
    chk("Z2 G0 v1 dallo stato del 27/09: PASS 57,2%", abs(o['p']['PASS'] - v2.ANCORA_V1) < 0.05, "-> %.2f" % o['p']['PASS'])
    vals = [corri(fB, aB, S_2709, sm)['p']['PASS'] for sm in (SEME,) + SEMI_BANDA]
    att_ = (ANCORA_BASE_2709[0],) + ANCORA_BASE_2709[1]
    chk("Z2 BLK B + 770105 dallo stato del 27/09: PASS 55,1 (semi 55,0/54,4/55,2) al decimale",
        all(round(x, 1) == y for x, y in zip(vals, att_)), "-> %s" % "/".join("%.2f" % x for x in vals))
    #    e le altre colonne della stessa riga del 27/09 (MC_CON_ORO_E_BLOCCHI r.150): fermata 44,9, fine<=5 25,4, gg 21 / 5
    o = corri(fB, aB, S_2709, SEME)
    chk("Z2 BLK B + 770105 dal 27/09, seme 11: fermata 44,9 | fine<=5gg 25,4 | gg mediani 21 / 5 (r.150 del 27/09)",
        round(o['p'].get('FERMATA_GUARDIAN', 0), 1) == 44.9 and round(fine5(o), 1) == 25.4 and o['med_pass'] == 21
        and o['med_fine'] == 5, "-> %.2f / %.2f / %s / %s" % (o['p'].get('FERMATA_GUARDIAN', 0), fine5(o), o['med_pass'], o['med_fine']))
    # Z3 blocchi L=1 == simula_v2 con reimmissione
    a = v2.simula_v2(fB, FATT, S_2809, attivo=aB, reimmissione=True, **KW)
    b = simula_stress(fB, FATT, S_2809, attivo=aB, campione='blocchi', L=1, **KW)
    chk("Z3 blocchi L=1 == v2.simula_v2(reimmissione=True), bit per bit", a == b, "-> %.4f / %.4f" % (a['p']['PASS'], b['p']['PASS']))
    # Z4 costi: zero == niente; un deal rifatto a mano per simbolo; q misurato contro i numeri gia' in casa
    c0 = [0.0] * len(fB)
    chk("Z4 costo tutto a zero == nessun costo, bit per bit", corri(fB, aB, S_2809, SEME, costo=c0) == corri(fB, aB, S_2809, SEME))
    chk("Z4 q D30EUR misurato %.4f (n=%d) == 1,0000 EUR/punto/lotto (STOP_VS_SPREAD par.2, n=154 trade veri)" % (
        q['D30EUR'][0], q['D30EUR'][1]), abs(q['D30EUR'][0] - 1.0) < 1e-9)
    chk("Z4 q U30USD misurato %.4f (n=%d, %.4f..%.4f) entro 1%% di 0,86091 (STOP_VS_SPREAD par.2, n=62)" % (
        q['U30USD'][0], q['U30USD'][1], q['U30USD'][2], q['U30USD'][3]), abs(q['U30USD'][0] / 0.86091 - 1) < 0.01)
    for n, sim in (('770101 DAX', 'D30EUR'), ('771531 EMA200', 'U30USD'), ('770105 DAXshort', 'D30EUR')):
        d0 = next(d for d in deal[n] if d[0] >= calB[0])
        giorno = [d for d in deal[n] if d[0] == d0[0]]
        mano = sum((1.0 * SPREAD_BASE[sim] + 1.0) * d[2] * q[sim][0] for d in giorno) / dati[n]['dep']
        cc = costo_giorni(deal, [n], calB, q, 2.0, 1.0, dati)
        chk("Z4 %s %s: spread x2 + 1 pt a mano (%d deal, vol %.2f) = %.8f == costo_giorni %.8f" % (
            n, d0[0], len(giorno), sum(d[2] for d in giorno), mano, cc[calB.index(d0[0])]),
            abs(mano - cc[calB.index(d0[0])]) < 1e-15)
    # Z5 soglie del superamento, costruite a mano: la formula deve cadere dal lato giusto
    #    (i) totale: saldo 75.841,54, giornata da -5% di misura (x2 = -10% > taglio): scatta prima il totale
    #        (0,948019 - 0,907 = 0,041 < 0,045). Muro 10% se sup x 0,02 x b0 > 0,007 -> sup* = 0,35 / b0 = 36,92%
    sstar = 0.35 / S_2809
    for sp, att in ((sstar - 0.005, 'FERMATA_GUARDIAN'), (sstar + 0.005, 'MORTE_STATICA')):
        o = simula_stress([-0.05], FATT, S_2809, n_sim=200, sup=sp, **KW)
        chk("Z5 totale: sup %.4f (soglia a mano %.4f) -> %s 100%%" % (sp, sstar, att), o['p'].get(att, 0) == 100.0, "-> %s" % o['p'])
    #    (ii) giornaliero: saldo 80.000 (b0 = 1), giornata -10%: taglio a 4,5 + sup x 0,02 > 5 se sup > 25%
    for sp, att in ((0.24, 'FERMATA_GUARDIAN'), (0.26, 'MORTE_GIORNALIERA')):
        o = simula_stress([-0.05], FATT, 1.0, n_sim=200, sup=sp, **KW)
        chk("Z5 giornaliero: saldo 80.000, sup %.2f (soglia a mano 0,25) -> %s 100%%" % (sp, att), o['p'].get(att, 0) == 100.0, "-> %s" % o['p'])
    o = simula_stress([-0.05], FATT, 1.0, n_sim=200, sup=0.13, k_pos=2, **KW)
    chk("Z5 k=2 dimezza la soglia: sup 0,13 x 2 posizioni -> MORTE_GIORNALIERA 100%", o['p'].get('MORTE_GIORNALIERA', 0) == 100.0)
    # Z6 i blocchi VEDONO il grappolo quando c'e', e NON lo fabbricano quando non c'e'
    ordin = sorted(fB)                                      # giornate peggiori consecutive
    kw6 = dict(KW, n_sim=20000)
    o1s = simula_stress(ordin, FATT, S_2809, campione='blocchi', L=1, **kw6)
    o10s = simula_stress(ordin, FATT, S_2809, campione='blocchi', L=10, **kw6)
    chk("Z6 calendario ORDINATO (perdite in fila): fine<=5gg blocchi 10 %.1f%% >> L=1 %.1f%% (> +5 punti)" % (fine5(o10s), fine5(o1s)),
        fine5(o10s) > fine5(o1s) + 5.0, "-> fermata %.1f / %.1f" % (o10s['p'].get('FERMATA_GUARDIAN', 0), o1s['p'].get('FERMATA_GUARDIAN', 0)))
    #    Prima stesura: UN solo calendario mescolato, tolleranza 2 -> FAIL (+4,5 punti di fermata). Non era un difetto
    #    del campionatore: UN ordinamento a caso ha la sua autocorrelazione per caso, e i blocchi la riproducono.
    #    Il contro-esempio giusto e' la MEDIA su molti ordinamenti a caso (deve essere ~0), e la loro dispersione e'
    #    il RUMORE D'ORDINAMENTO contro cui si legge il calendario vero (nulla_blocchi, stampata in main).
    nl = nulla_blocchi(fB, aB, 10, n_perm=40, n_sim=5000)
    chk("Z6 40 calendari mescolati a caso: media (blocchi 10 - L=1) = %+.2f punti di PASS (|media| < 2,0; dispersione %.2f)" % (
        statistics.mean(nl), statistics.stdev(nl)), abs(statistics.mean(nl)) < 2.0)
    # Z7 il peso delle settimane peggiori e' quello dichiarato
    sett = settimane(calB)
    w, pegg, _ = pesi_settimane(sett, fB, 3.0)
    cum, t = [], 0.0
    for x in w:
        t += x; cum.append(t)
    rnd = random.Random(7); nd = 200000
    hit = sum(1 for _ in range(nd) if bisect.bisect_right(cum, rnd.random() * t) in set(pegg))
    atteso = 100.0 * 3.0 * len(pegg) / t
    chk("Z7 settimane: %d settimane, %d peggiori a peso 3 -> quota pescata %.2f%% contro attesa %.2f%%" % (
        len(sett), len(pegg), 100.0 * hit / nd, atteso), abs(100.0 * hit / nd - atteso) < 0.5)
    chk("Z7 settimane: ogni giornata del calendario B sta in una e una sola settimana", sorted(i for s_ in sett for i in s_) == list(range(len(calB))))
    print("AUTOTEST: %s" % ("TUTTO VERDE" if ok else "ROSSO"))
    return ok


# ---------------------------------------------------------------- main
def main(solo_base=False):
    dati, S, calB, fB, aB, deal, q = prepara()
    print("=" * 130)
    print("MC STRESS CONGIUNTO -- FTMO 541452707 -- base = v2 'BLK B: 4 sedie + 770105', taglia indici 2,00%, Guardian 4,5 / 9,3")
    print("stato 28/09: saldo %.2f = %.6f del banco (DD %.2f%%) | referto 27/09: %.2f = %.6f | differenza %+.2f EUR" % (
        SALDO_2809, S_2809, 100 * (1 - S_2809), SALDO_2709, S_2709, SALDO_2809 - SALDO_2709))
    print("calendario B: %s -> %s, %d giornate di borsa | seme %d, %d sim per riga, banda semi %s" % (
        calB[0], calB[-1], len(calB), SEME, NSIM, SEMI_BANDA))
    print("distanza dal Guardian 9,3%% (72.560): %.2f EUR = %.4f del banco; taglio giornaliero 4,5%% = 3.600 EUR -> "
          "dal saldo di oggi scatta PRIMA l'emergenza totale" % (SALDO_2809 - BANCO * (1 - st.G_TOT), S_2809 - (1 - st.G_TOT)))

    print("\n[q MISURATO dai file, EUR per punto per lotto]")
    for s_, (med, n_, lo, hi) in sorted(q.items()):
        print("  %-7s mediana %.4f su %d coppie (%.4f .. %.4f)" % (s_, med, n_, lo, hi))
    print("\n[COSTO EXTRA MEDIO PER POSIZIONE, in R di misura (1% del deposito)]")
    for nome, _, ms, p in [(x[0], None, x[1], x[2]) for x in SCEN_B]:
        cr = costo_R_per_sedia(deal, NOMI_BASE, q, ms, p, dati)
        print("  %-32s %s" % (nome, " | ".join("%s %.4f R (n=%d)" % (n.split()[0], cr[n][0], cr[n][1]) for n in NOMI_BASE)))

    def blocco(tit, righe, rif=None):
        print("\n[%s]" % tit)
        out = []
        for nome, pert, saldo in righe:
            o = corri(fB, aB, saldo, SEME, **pert)
            banda = [corri(fB, aB, saldo, sm, **pert) for sm in SEMI_BANDA]
            riga(nome, o, banda, rif)
            out.append((nome, o, banda))
        return out

    b27 = blocco("BASE -- contro-esempio: il v2 al decimale dallo stato del 27/09", [("BASE 27/09 (v2: 55,1 / 55,0 / 54,4 / 55,2)", {}, S_2709)])
    b28 = blocco("BASE dallo stato del 28/09", [("BASE 28/09", {}, S_2809)])
    rif = ("BASE 28/09", b28[0][1])
    o = corri(fB, aB, S_2809, SEME, min_giorni=0)
    riga("  sensibilita': min_giorni=0 (se il 28/09 conta gia' come giorno FTMO)", o, None, rif)
    if solo_base:
        return
    blocco("(a) SUPERAMENTO ALLA FERMATA del Guardian (taglio 4,5 / totale 9,3), campionamento come la base",
           [("sup %2.0f%% dello stop x %d posizion%s" % (100 * sp, k, 'e' if k == 1 else 'i'), dict(sup=sp, k_pos=k), S_2809)
            for sp, k in SCEN_A], rif)
    blocco("(b) COSTI PEGGIORATI per posizione (volumi veri), campionamento come la base",
           [(nome, dict(costo=costo_giorni(deal, NOMI_BASE, calB, q, ms, p, dati)), S_2809) for nome, ms, p in SCEN_B], rif)
    sett = settimane(calB)
    w3, pegg, somme = pesi_settimane(sett, fB, 3.0)
    print("\n[settimane del calendario B: %d; le %d peggiori (peso 3), somma della base x fattore 2 in %% del saldo]" % (len(sett), len(pegg)))
    for j in sorted(pegg, key=lambda j: somme[j]):
        print("  %s -> %s  %d giornate  %+.2f%%" % (calB[sett[j][0]], calB[sett[j][-1]], len(sett[j]), 100 * FATT * somme[j]))

    def pert_c(mode, L, peso):
        if mode == 'blocchi':
            return dict(campione='blocchi', L=L)
        return dict(campione='settimane', sett=sett, pesi=pesi_settimane(sett, fB, peso)[0])
    c = blocco("(c) PERDITE A GRAPPOLO (tutte CON reimmissione: il riferimento a disegno neutro e' L=1)",
               [(nome, pert_c(mode, L, peso), S_2809) for nome, mode, L, peso in SCEN_C], rif)
    rif_c = ("L=1", c[0][1])
    print("  (differenze contro L=1, stesso disegno:)")
    for nome, o, banda in c[1:]:
        d = [o['p'].get('PASS', 0) - c[0][1]['p'].get('PASS', 0)] + [b['p'].get('PASS', 0) - bb['p'].get('PASS', 0)
                                                                    for b, bb in zip(banda, c[0][2])]
        df = [o['p'].get('FERMATA_GUARDIAN', 0) - c[0][1]['p'].get('FERMATA_GUARDIAN', 0)] + [
            b['p'].get('FERMATA_GUARDIAN', 0) - bb['p'].get('FERMATA_GUARDIAN', 0) for b, bb in zip(banda, c[0][2])]
        print("    %-40s dPASS %s | dFERM %s (semi 11/12/13/14)" % (nome, "/".join("%+.1f" % x for x in d), "/".join("%+.1f" % x for x in df)))
    print("\n[RUMORE D'ORDINAMENTO dei blocchi: 40 calendari B mescolati a caso, 5.000 sim, seme %d]" % SEME)
    kw5 = dict(KW, n_sim=5000)
    for L in (5, 10):
        nl = nulla_blocchi(fB, aB, L)
        vero = (simula_stress(fB, FATT, S_2809, attivo=aB, campione='blocchi', L=L, **kw5)['p'].get('PASS', 0)
                - simula_stress(fB, FATT, S_2809, attivo=aB, campione='blocchi', L=1, **kw5)['p'].get('PASS', 0))
        rango = sum(1 for x in nl if x < vero)
        print("  L=%2d: nulla dPASS media %+.2f, dev.st %.2f, min %+.2f, max %+.2f | calendario VERO %+.2f (sopra %d dei 40 mescolati)" % (
            L, statistics.mean(nl), statistics.stdev(nl), min(nl), max(nl), vero, rango))
    blocco("INSIEME (a)+(b)+(c)",
           [(nome, dict(sup=sp, k_pos=k, costo=costo_giorni(deal, NOMI_BASE, calB, q, ms, p, dati), **pert_c(mode, L, peso)), S_2809)
            for nome, sp, k, ms, p, mode, L, peso in INSIEME], rif)
    print("  (riferimento a disegno neutro per le righe INSIEME: L=1 PASS %.1f)" % rif_c[1]['p'].get('PASS', 0))

    print("\n[SOGLIA DEL SUPERAMENTO: da quale sup P(muro FTMO) > 0 -- seme %d, %d sim, campionamento come la base]" % (SEME, NSIM))
    print("  a mano: giornaliero sup x k > 0,25 / b0 ; totale sup x k > 0,35 / b0  (b0 = saldo d'inizio giornata / 80.000)")
    print("          oggi b0 = %.4f -> giornaliero %.1f%%, totale %.1f%% dello stop (k=1)" % (S_2809, 100 * 0.25 / S_2809, 100 * 0.35 / S_2809))
    for k in (1, 2):
        primo = None
        for j in range(0, 25):
            sp = 0.025 * j
            o = corri(fB, aB, S_2809, SEME, sup=sp, k_pos=k)
            mu = muro(o)
            if mu > 0 and primo is None:
                primo = sp
            print("  k=%d sup %5.1f%% -> PASS %5.1f | FERM %5.1f | muroGG %5.2f | muro10 %5.2f | MURO %5.2f" % (
                k, 100 * sp, o['p'].get('PASS', 0), o['p'].get('FERMATA_GUARDIAN', 0), o['p'].get('MORTE_GIORNALIERA', 0),
                o['p'].get('MORTE_STATICA', 0), mu))
            sys.stdout.flush()
        print("  k=%d: primo gradino con P(muro) > 0: %s" % (k, "%.1f%%" % (100 * primo) if primo is not None else 'nessuno fino a 60%'))
    print("=" * 130)


if __name__ == '__main__':
    ap = argparse.ArgumentParser(description='MC stress congiunto (superamento, costi, grappoli) sopra il v2, sola lettura')
    ap.add_argument('--autotest', action='store_true', help='contro-esempi, poi esce (0 se verde)')
    ap.add_argument('--solo-base', action='store_true', help='solo le righe base (27/09 e 28/09)')
    a = ap.parse_args()
    if a.autotest:
        sys.exit(0 if autotest() else 1)
    main(a.solo_base)
