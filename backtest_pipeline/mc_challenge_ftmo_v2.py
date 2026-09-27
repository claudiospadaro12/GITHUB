#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_challenge_ftmo_v2.py -- 27/09/2026

IL MONTE CARLO DELLA CHALLENGE FTMO 541452707 CON I BLOCCHI PER GIORNATA,
LA SEDIA 770105 (DAX short) E L'ORO LONG 795301.
Referto: report/MC_CON_ORO_E_BLOCCHI_2026-09-27.md

NON modifica mc_challenge_ftmo_stato.py (v1) ne' i suoi due moduli: li IMPORTA
e ne RIUSA simula_stato(), pool_feriali(), le costanti dello stato del conto e
del Guardian di campo. SOLA LETTURA. NESSUNA PROPOSTA DI TAGLIA: le taglie
sono firme di Claudio, qui si stampano curve a taglie DATE.

I DUE BUCHI DELLA v1 CHE QUESTO FILE CHIUDE (o dichiara):
  (1) la v1 non conosce le sedie nuove: 770105 (DAX short, attaccata il 25/09),
      770212 (Dow short, in firma), ORO long (possibile 770421). Qui:
        770105 -> per-trade R251b/792520 [MISURATO], SOLO gamba OOS
                  2025.07.01 -> 2026.06.29, deposito 10.000, rischio 1%;
        ORO    -> per-trade R260a/795301 [MISURATO su OHLC], 2020.01.03 ->
                  2026.06.26, deposito 100.000, rischio 0,5%;
        770212 -> NESSUN per-trade in repo (R54a ha solo i CSV di riepilogo,
                  R255 non e' girato): [NON MODELLATA]. Niente proxy col segno
                  cambiato: sarebbe un numero inventato.
  (2) "trade indipendenti" (docs/RISPOSTA_GEMINI_2026-09-27.md par.2). Fatto
      misurato PRIMA di scrivere una riga: la v1 ricampiona GIA' GIORNATE
      INTERE (m.serie somma per giornata, simula_stato pesca giornate), quindi
      la correlazione intra-giornata fra le QUATTRO sedie della v1 e' GIA'
      conservata (lo dice anche il suo referto, par.6 punto 1). Il buco vero e'
      che le sedie NUOVE vanno agganciate PER DATA alla stessa giornata, non
      appese come pool indipendenti. Qui:
        - BLOCCHI  : unita' = giornata di borsa; tutti i trade di tutte le
                     sedie dello stesso giorno restano insieme (v1 estesa);
        - IID      : lo stesso calendario, ma il P/L di ogni POSIZIONE e'
                     estratto a caso dal pool della sua sedia (conteggio
                     giornaliero per sedia conservato, co-movimento distrutto).
                     E' il modello che Gemini critica, messo accanto per
                     MISURARE quanto vale la correlazione.
        - IID-S    : (aggiunto al cancello del 27/09) stesso calendario, ma il
                     TOTALE DI GIORNATA di ogni sedia presente e' estratto a caso
                     dalle giornate della STESSA sedia: distrugge SOLO il
                     co-movimento FRA sedie (il "crollo insieme" di Gemini) e
                     conserva quello DENTRO la sedia. Serve perche' l'IID per
                     posizione distrugge DUE cose: sulle 4 sedie v1 l'unica con
                     piu' posizioni al giorno e' la 771531 (77 giornate con >=2
                     posizioni, fino a 8, coppia di SELL LIMIT con SL comune), e
                     da sola vale +16 punti di PASS nell'IID per posizione.
        - DISEGNO  : BLK pesca giornate SENZA reimmissione (come la v1), IID e
                     IID-S pescano posizioni/giornate di sedia CON reimmissione.
                     Il confronto pulito (decomposizione in main e contro-esempio
                     iv) si fa con reimmissione=True per tutti e tre; nella
                     tabella il disegno misto vale da ~1 a ~3 punti (contro-
                     esempio i').

UNITA' (regole della v1): valore in frazione del deposito di misura, alla
taglia della misura; simula_stato moltiplica per `fattore` (2,0 = taglia 2,00%
delle sedie indici in campo) e applica la frazione fissa sul saldo del giorno.
  sedie v1     : net / 100.000                (misura 1%   -> x fattore)
  770105       : net /  10.000                (misura 1%   -> x fattore)
  ORO a t%     : net / 100.000 x (t/0,5) / fattore   (taglia ASSOLUTA t, non
                 segue il fattore: 0,5% e 1,0% del saldo, come chiesto)
  [classe 321] l'EA dimensiona sul SALDO CORRENTE del backtest: nella finestra A
  l'oro ha saldo 110.029-114.352, quindi dividere per 100.000 lo porta a ~0,55-0,57%
  effettivo (stop veri -535,56 e -558,68). Rinormalizzato sul saldo corrente l'effetto
  misurato e' <= 0,3 punti su tutte le righe oro: si dichiara, non si corregge (le
  4 sedie v1 hanno lo stesso effetto ereditato, saldi finali 106-123k).
Tutti i coefficienti sono potenze di due: le somme restano bit-per-bit uguali
alla v1 quando le sedie nuove pesano zero (contro-esempio iii).

CALENDARIO: universo = giorni FERIALI della finestra + le giornate con
operazioni (come pool_feriali della v1); una giornata senza operazioni vale 0 e
NON conta come trading day (attivo=False). "giorni" = giorni di borsa.
  finestra A : 2025.06.10 -> 2026.06.29  (le 4 sedie v1; l'oro ha 43 giornate)
  finestra B : 2025.07.01 -> 2026.06.29  (dove esiste anche la 770105)
  ORO INTERA STORIA: variante etichettata in cui l'oro e' pescato da un secondo
  calendario (2020.01.03 -> 2026.06.26) INDIPENDENTE dalla giornata indici:
  piu' regimi per l'oro, ma la correlazione oro-indici e' persa per costruzione.

USO:
  python3 backtest_pipeline/mc_challenge_ftmo_v2.py            # tabelle (~4 min)
  python3 backtest_pipeline/mc_challenge_ftmo_v2.py --autotest # controlli e contro-esempi, poi esce
"""
import collections, csv, datetime as dt, os, random, statistics, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo as m                      # noqa: E402
import mc_challenge_ftmo_stato as st               # noqa: E402  (importa anche al)

BANCO, S_OGGI, SALDO_OGGI = st.BANCO, st.S_OGGI, st.SALDO_OGGI
G_GIORN, G_TOT, MIN_GIORNI = st.G_GIORN, st.G_TOT, st.MIN_GIORNI_RESTANTI
SEME, NSIM, SEMI_BANDA = st.SEME, st.NSIM, (12, 13, 14)
SLIP = st.SLIP_MISURATO
ANCORA_V1 = 57.2                 # report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md par.4 riga (a)

# sedia -> (percorso, deposito di misura, rischio di misura %, segue il fattore?)
SORGENTI_V2 = dict((n, (rel, m.DEPOSITO_MISURA, 1.0, True)) for n, rel in m.SORGENTI.items())
SORGENTI_V2['770105 DAXshort'] = (
    'risultati_archivio/R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv', 10000.0, 1.0, True)
SORGENTI_V2['795301 ORO'] = (
    'risultati_archivio/ROUND_CORTI_B_2026-09-27/PERTRADE/abtg_trades_ABTG_MaxMinNotte_XAUUSD_795301.csv',
    100000.0, 0.5, False)
V1 = list(m.SORGENTI)            # le quattro sedie della v1, nell'ordine di m.serie
NON_MODELLATE = ['770212 Dow short (in firma: nessun per-trade in repo, R255 non girato)',
                 '770260 Nasdaq (in campo, nessun per-trade: gia\' fuori dalla v1)',
                 '770511 SuperWave Dow (in campo, nessun per-trade: gia\' fuori dalla v1)']


# ---------------------------------------------------------------- dati
def data(s):
    return dt.date(*map(int, s[:10].split('.')))


def carica_v2(nomi=None):
    """Per sedia: giornaliero (somma dei deal per data di chiusura, in ordine
       di file come m.carica) e posizioni (somma dei deal per position_id,
       datate all'ULTIMO deal)."""
    out = {}
    for nome in (nomi or SORGENTI_V2):
        rel, dep, rmis, segue = SORGENTI_V2[nome]
        gior = collections.defaultdict(float)
        pos = collections.OrderedDict()
        with open(os.path.join(QUI, rel), newline='') as fh:
            for r in csv.DictReader(fh, delimiter=';'):
                d = r['close_time'][:10]; x = float(r['net_profit'])
                gior[d] += x
                p = pos.setdefault(r['position_id'], [d, 0.0])
                p[0] = d; p[1] += x
        out[nome] = {'giorni': dict(gior), 'posizioni': [(d, x) for d, x in pos.values()],
                     'dep': dep, 'rmis': rmis, 'segue': segue}
    return out


def scala(nome, dati, fattore, taglia_oro):
    """Coefficiente che porta il net EUR della sedia nelle unita' di simula_stato."""
    s = dati[nome]
    if s['segue']:
        return 1.0 / s['dep']
    return (taglia_oro / s['rmis']) / (s['dep'] * fattore)


def calendario(dati, nomi, da=None, a=None):
    """Feriali della finestra + giornate con operazioni delle sedie scelte,
       come pool_feriali della v1 (finestra = dalla prima all'ultima operazione)."""
    con = set()
    for n in nomi:
        con |= set(d for d in dati[n]['giorni'] if (da is None or d >= da) and (a is None or d <= a))
    D = sorted(data(d) for d in con)
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    tutti = sorted(set(d for d in fer if d.weekday() < 5) | set(D))
    return [d.strftime('%Y.%m.%d') for d in tutti]


def blocchi(dati, nomi, cal, fattore, taglia_oro=0.0):
    """(fisso, attivo): valore della giornata e flag 'ha operato' (solo sedie a peso > 0).
       Le sedie che seguono il fattore si sommano PRIMA per deposito e si dividono
       DOPO (stessa aritmetica di m.serie); l'oro si aggiunge col suo coefficiente."""
    fisso, attivo = [], []
    gruppi = collections.OrderedDict()
    for n in nomi:
        if dati[n]['segue']:
            gruppi.setdefault(dati[n]['dep'], []).append(n)
    oro = [n for n in nomi if not dati[n]['segue']]
    for d in cal:
        v = 0.0
        for dep, gr in gruppi.items():
            v += sum(dati[n]['giorni'].get(d, 0.0) for n in gr) / dep
        for n in oro:
            v += dati[n]['giorni'].get(d, 0.0) * scala(n, dati, fattore, taglia_oro)
        fisso.append(v)
        att = any(d in dati[n]['giorni'] for n in nomi if dati[n]['segue'] or taglia_oro > 0)
        attivo.append(att)
    return fisso, attivo


def pool_posizioni(dati, nomi, cal, fattore, taglia_oro=0.0):
    """Per la variante IID: pool dei valori per posizione di ogni sedia (nella finestra)
       e conteggio delle posizioni chiuse per giornata e per sedia."""
    lo, hi = cal[0], cal[-1]
    pools, conta = {}, [dict() for _ in cal]
    idx = dict((d, i) for i, d in enumerate(cal))
    for n in nomi:
        if not dati[n]['segue'] and taglia_oro == 0:
            continue
        k = scala(n, dati, fattore, taglia_oro)
        pools[n] = [x * k for d, x in dati[n]['posizioni'] if lo <= d <= hi]
        for d, _ in dati[n]['posizioni']:
            if d in idx:
                conta[idx[d]][n] = conta[idx[d]].get(n, 0) + 1
    return pools, conta


def comp_sedia_giorno(dati, nomi, cal, fattore, taglia_oro=0.0):
    """IID-S: per ogni sedia PRESENTE nella giornata k estrae a caso il TOTALE di una
       giornata della stessa sedia (nella finestra). Presenza conservata, co-movimento
       FRA sedie distrutto, co-movimento DENTRO la sedia conservato."""
    lo, hi = cal[0], cal[-1]
    usa = [n for n in nomi if dati[n]['segue'] or taglia_oro > 0]
    pools = dict((n, [x * scala(n, dati, fattore, taglia_oro) for d, x in sorted(dati[n]['giorni'].items()) if lo <= d <= hi])
                 for n in usa)
    pres = [[n for n in usa if d in dati[n]['giorni']] for d in cal]

    def f(k, rnd):
        v = 0.0
        for n in pres[k]:
            pool = pools[n]
            v += pool[rnd.randrange(len(pool))]
        return v
    return f


def comp_iid(pools, conta):
    """Componitore della giornata k: per ogni sedia estrae a caso tante posizioni
       quante ne ha chiuse quel giorno. Conteggio conservato, co-movimento distrutto."""
    nomi = list(pools)

    def f(k, rnd):
        v = 0.0
        for n in nomi:
            c = conta[k].get(n, 0)
            pool = pools[n]
            for _ in range(c):
                v += pool[rnd.randrange(len(pool))]
        return v
    return f


# ---------------------------------------------------------------- simulatore
def simula_v2(fisso, fattore, saldo_iniziale=1.0, guardian=None, slip=1.0,
              n_sim=NSIM, seme=SEME, target=0.10, muro_stat=0.10, muro_gior=0.05,
              min_giorni=4, max_giorni=800, g_tot=None, attivo=None, orizzonte=5,
              stake_fisso=False, reimmissione=False, comp=None):
    """Copia di st.simula_stato con UN solo aggancio: comp(k, rnd) -> valore della
       giornata k (variante IID). Con comp=None consuma il generatore ESATTAMENTE
       come simula_stato (senza pausa/sost): e' la prima cosa che --autotest verifica."""
    rnd = random.Random(seme)
    N = len(fisso)
    idx = list(range(N))
    esiti = collections.Counter(); d_pass = []; d_fine = []
    entro = collections.Counter()
    for _ in range(n_sim):
        s = idx[:]; rnd.shuffle(s)
        bal = saldo_iniziale; g = 0; gt = 0; esito = None; i = 0
        while esito is None:
            if reimmissione:
                k = rnd.randrange(N)
            else:
                if i >= len(s):
                    s2 = idx[:]; rnd.shuffle(s2); s = s + s2
                k = s[i]; i += 1
            b0 = bal
            v = fisso[k] if comp is None else comp(k, rnd)
            r = v * fattore
            if r < 0:
                r *= slip
            if stake_fisso:
                perdita = -r
                if guardian is not None and perdita > guardian:
                    r = -guardian
                bal = b0 + r
            else:
                perdita = -r * b0
                if guardian is not None and perdita > guardian:
                    perdita = guardian
                    r = -perdita / b0
                bal = b0 + r * b0
            g += 1
            if attivo is None or attivo[k]:
                gt += 1
            if (b0 - bal) > muro_gior:
                esito = 'MORTE_GIORNALIERA'
            elif g_tot is not None and bal <= 1.0 - g_tot:
                bal = 1.0 - g_tot; esito = 'FERMATA_GUARDIAN'
            elif bal < 1.0 - muro_stat:
                esito = 'MORTE_STATICA'
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


KW_CAMPO = dict(guardian=G_GIORN, g_tot=G_TOT, min_giorni=MIN_GIORNI)


def corsa(fisso, fattore, attivo=None, comp=None, seme=SEME, slip=1.0, sost=None, donatori=None):
    """Una riga della tabella: blocchi -> st.simula_stato (funzione della v1);
       IID -> simula_v2 con comp; oro indipendente -> st.simula_stato con sost/donatori."""
    kw = dict(KW_CAMPO); kw.update(attivo=attivo, seme=seme, slip=slip)
    if comp is not None:
        return simula_v2(fisso, fattore, S_OGGI, comp=comp, **kw)
    if sost is not None:
        kw.update(sost=sost, donatori=donatori)
    return st.simula_stato(fisso, fattore, S_OGGI, **kw)


def fine5(o):
    return sum(v for k, v in o['entro'].items() if k != 'PASS')


def riga_tab(nome, o, banda=None):
    p = o['p']
    s = ("  %-58s PASS %5.1f | FERM.G9,3 %5.1f | FTMO5gg %4.1f | FTMO10 %4.1f | fine<=5gg %4.1f | ggPASS %5s | ggFINE %5s" % (
        nome, p.get('PASS', 0), p.get('FERMATA_GUARDIAN', 0), p.get('MORTE_GIORNALIERA', 0),
        p.get('MORTE_STATICA', 0), fine5(o), o['med_pass'], o['med_fine']))
    if banda:
        s += " | semi 12-14: PASS %s" % "/".join("%.1f" % b['p'].get('PASS', 0) for b in banda)
    print(s)
    return s


# ---------------------------------------------------------------- costruzioni di comodo
def scenari(dati):
    """Tutti i pool della tabella, costruiti una volta."""
    S = collections.OrderedDict()
    calA = calendario(dati, V1)                                  # finestra A = v1
    calB = calendario(dati, V1 + ['770105 DAXshort'], da='2025.07.01')   # finestra B
    S['calA'], S['calB'] = calA, calB
    per = m.carica(); giorni, base = m.serie(per)
    S['G0_pool'] = (base, None)
    S['G0_fer'] = st.pool_feriali(giorni, base)
    for tag, nomi, cal in [('A4', V1, calA), ('B4', V1, calB), ('B5', V1 + ['770105 DAXshort'], calB)]:
        S[tag] = dict(nomi=nomi, cal=cal)
    # oro sull'intera storia: calendario proprio (feriali 2020 -> 2026)
    S['calORO'] = calendario(dati, ['795301 ORO'])
    return S


def pool_oro_intero(dati, fattore, taglia_oro, cal_oro):
    f, _ = blocchi(dati, ['795301 ORO'], cal_oro, fattore, taglia_oro)
    return f


def correlazione(dati, nomi, cal):
    """Descrittiva [MISURATO]: giornate con >=2 sedie in perdita insieme, e
       correlazione di Pearson fra coppie sui giorni in cui operano entrambe."""
    per = dict((n, dati[n]['giorni']) for n in nomi)
    neg2 = sum(1 for d in cal if sum(1 for n in nomi if per[n].get(d, 0.0) < 0) >= 2)
    op2 = sum(1 for d in cal if sum(1 for n in nomi if d in per[n]) >= 2)
    coppie = []
    for i, a in enumerate(nomi):
        for b in nomi[i + 1:]:
            comuni = [d for d in cal if d in per[a] and d in per[b]]
            if len(comuni) < 8:
                coppie.append((a, b, len(comuni), None, None)); continue
            xa = [per[a][d] for d in comuni]; xb = [per[b][d] for d in comuni]
            ma, mb = statistics.mean(xa), statistics.mean(xb)
            cov = sum((x - ma) * (y - mb) for x, y in zip(xa, xb))
            va = sum((x - ma) ** 2 for x in xa); vb = sum((y - mb) ** 2 for y in xb)
            rho = cov / (va * vb) ** 0.5 if va > 0 and vb > 0 else None
            insieme = sum(1 for x, y in zip(xa, xb) if x < 0 and y < 0)
            coppie.append((a, b, len(comuni), rho, insieme))
    return neg2, op2, coppie


# ---------------------------------------------------------------- autotest
def autotest():
    ok = True

    def chk(nome, cond, dettaglio=''):
        nonlocal ok
        print("  [%s] %s %s" % ('PASS' if cond else 'FAIL', nome, dettaglio))
        ok = ok and cond

    print("AUTOTEST mc_challenge_ftmo_v2.py")
    dati = carica_v2()
    S = scenari(dati)
    calA, calB = S['calA'], S['calB']
    base, _ = S['G0_pool']; fer_pool, fer_att = S['G0_fer']

    # 0. la v1 e' ancora quella: 57,2% dallo stato di oggi (ancora G0)
    o = corsa(base, 2.0)
    chk("G0: v1 riprodotta, PASS 57,2%% (pool 242 giornate)", abs(o['p']['PASS'] - ANCORA_V1) < 0.05,
        "-> %.4f%%" % o['p']['PASS'])
    # 1. simula_v2 con comp=None == st.simula_stato bit per bit (anche con attivo, slip, g_tot)
    for pool, att, sl in [(base, None, 1.0), (fer_pool, fer_att, 1.0), (fer_pool, fer_att, SLIP)]:
        a = st.simula_stato(pool, 2.0, S_OGGI, attivo=att, slip=sl, **KW_CAMPO)
        b = simula_v2(pool, 2.0, S_OGGI, attivo=att, slip=sl, **KW_CAMPO)
        chk("simula_v2(comp=None) == st.simula_stato (n=%d, slip %.3f)" % (len(pool), sl), a == b,
            "-> %.4f%% / %.4f%%" % (a['p']['PASS'], b['p']['PASS']))
    # 2. rovina del giocatore, come nella v1 (passi 1/64, puntata fissa, iid)
    u = 1.0 / 64
    o = simula_v2([u, -u], 1.0, 60 / 64, g_tot=0.093, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True, reimmissione=True)
    chk("rovina con Guardian 9,3%: P(PASS)=2/13=15,38%", abs(o['p'].get('PASS', 0) - 100 * 2 / 13) < 0.8,
        "-> %.2f%%, resto FERMATA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('FERMATA_GUARDIAN', 0)))
    o = simula_v2([u, -u], 1.0, 60 / 64, g_tot=None, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True, reimmissione=True)
    chk("rovina senza Guardian (muro 10%): P(PASS)=3/14=21,43%", abs(o['p'].get('PASS', 0) - 100 * 3 / 14) < 0.8,
        "-> %.2f%%, resto STATICA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('MORTE_STATICA', 0)))
    # 3. il costruttore a blocchi con le 4 sedie v1 == pool_feriali della v1, bit per bit
    fA, aA = blocchi(dati, V1, calA, 2.0)
    chk("blocchi(4 sedie, finestra A) == pool_feriali v1 (%d voci, %d a zero)" % (len(fer_pool), sum(1 for a in fer_att if not a)),
        fA == fer_pool and aA == fer_att and len(calA) == 277)
    # 4. somme: giornaliero == posizioni, per ogni sedia; date e conteggi dichiarati
    for n in SORGENTI_V2:
        sg = sum(dati[n]['giorni'].values()); sp = sum(x for _, x in dati[n]['posizioni'])
        chk("%-16s somma giornaliero == somma posizioni (%+.2f), %d posizioni, %d giornate, %s -> %s" % (
            n, sg, len(dati[n]['posizioni']), len(dati[n]['giorni']), min(dati[n]['giorni']), max(dati[n]['giorni'])),
            abs(sg - sp) < 1e-6)
    chk("770105: 181 posizioni, 2025.07.01 -> 2026.06.29, somma +254,74 (RIEPILOGO_R251)",
        len(dati['770105 DAXshort']['posizioni']) == 181 and abs(sum(dati['770105 DAXshort']['giorni'].values()) - 254.74) < 0.005)
    chk("ORO: 279 posizioni, 375 deal (referto CORTI B), 2020.01.03 -> 2026.06.26",
        len(dati['795301 ORO']['posizioni']) == 279 and min(dati['795301 ORO']['giorni']) == '2020.01.03')
    n_oroA = sum(1 for d in calA if d in dati['795301 ORO']['giorni'])
    chk("oro nella finestra A: 43 giornate con operazioni su %d di calendario" % len(calA), n_oroA == 43, "-> %d" % n_oroA)
    chk("finestra B: %d giorni di borsa, 770105 presente in 181" % len(calB),
        calB[0] == '2025.07.01' and sum(1 for d in calB if d in dati['770105 DAXshort']['giorni']) == 181)
    # 5. scala: una giornata con un solo trade oro -500 EUR a 0,5% -> -0,5% del saldo (fattore 2); a 1,0% -> -1,0%
    finto = {'795301 ORO': dict(dati['795301 ORO'])}
    finto['795301 ORO']['giorni'] = {'2030.01.01': -500.0}
    f05, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 2.0, 0.5)
    f10, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 2.0, 1.0)
    chk("scala oro: -500 EUR -> -0,5%% (t=0,5) / -1,0%% (t=1,0) a fattore 2", f05[0] * 2.0 == -0.005 and f10[0] * 2.0 == -0.01,
        "-> %.6f / %.6f" % (f05[0] * 2.0, f10[0] * 2.0))
    f05b, _ = blocchi(finto, ['795301 ORO'], ['2030.01.01'], 1.0, 0.5)
    chk("scala oro NON segue il fattore: a fattore 1 resta -0,5%", f05b[0] * 1.0 == -0.005)
    finto2 = {'770105 DAXshort': dict(dati['770105 DAXshort'])}
    finto2['770105 DAXshort']['giorni'] = {'2030.01.01': -100.0}
    fs, _ = blocchi(finto2, ['770105 DAXshort'], ['2030.01.01'], 2.0)
    chk("scala 770105: -100 EUR su 10.000 = -1%% di misura -> -2%% a fattore 2", fs[0] * 2.0 == -0.02)
    # 6. CONTRO-ESEMPIO (iii): oro a taglia 0 == senza oro, bit per bit (stessa finestra A)
    f0, a0 = blocchi(dati, V1 + ['795301 ORO'], calA, 2.0, 0.0)
    chk("(iii) blocchi con oro a taglia 0 == blocchi senza oro (valori e attivo, bit per bit)", f0 == fA and a0 == aA)
    o0 = corsa(f0, 2.0, attivo=a0); oA = corsa(fA, 2.0, attivo=aA)
    chk("(iii) ... e la tabella e' identica", o0 == oA, "-> %.4f%% / %.4f%%" % (o0['p']['PASS'], oA['p']['PASS']))
    # 7. CONTRO-ESEMPIO (i): un solo trade per giorno -> blocchi == IID entro il rumore
    #    universo sintetico: OGNI posizione delle 4 sedie e' la sua giornata (560 giornate, tutte attive)
    pos1 = [(n, x) for n in V1 for _, x in dati[n]['posizioni']]
    f1 = [x / dati[n]['dep'] for n, x in pos1]
    pools1 = dict((n, [x / dati[n]['dep'] for nn, x in pos1 if nn == n]) for n in V1)
    conta1 = [{n: 1} for n, _ in pos1]
    ob = simula_v2(f1, 2.0, S_OGGI, reimmissione=True, **KW_CAMPO)                       # bootstrap dei blocchi
    oi = simula_v2(f1, 2.0, S_OGGI, reimmissione=True, comp=comp_iid(pools1, conta1), **KW_CAMPO)
    # nota: qui l'IID pesca per sedia; con 1 trade/giorno e' la stessa legge del bootstrap dei blocchi
    d = oi['p'].get('PASS', 0) - ob['p'].get('PASS', 0)
    chk("(i) 1 trade/giorno: IID - blocchi = %+.2f punti (rumore +-0,5 su 20.000 sim; tolleranza 1,5)" % d,
        abs(d) < 1.5, "-> blocchi %.2f%%, IID %.2f%%, %d giornate" % (ob['p'].get('PASS', 0), oi['p'].get('PASS', 0), len(f1)))
    #    (i') la STESSA prova nella configurazione della tabella (blocchi SENZA reimmissione, IID con):
    #    qui la differenza non e' zero ed e' DISEGNO, non correlazione. Si stampa, non si giudica.
    ob = simula_v2(f1, 2.0, S_OGGI, **KW_CAMPO)
    oi = simula_v2(f1, 2.0, S_OGGI, comp=comp_iid(pools1, conta1), **KW_CAMPO)
    print("       (i') informativo, configurazione della tabella (blocchi SENZA reimmissione): blocchi %.2f%%, IID %.2f%% -> "
          "IID - blocchi = %+.2f punti di solo DISEGNO (semi 12/13: -1,00 / -0,72)" % (
              ob['p'].get('PASS', 0), oi['p'].get('PASS', 0), oi['p'].get('PASS', 0) - ob['p'].get('PASS', 0)))
    # 8. CONTRO-ESEMPIO (ii): correlazione artificiale 1 -> P(fermata) blocchi > IID
    #    per ogni sedia i giornalieri ordinati dal peggiore; giornata j = j-esimo peggiore di OGNI sedia
    ordinati = dict((n, sorted(dati[n]['giorni'].values())) for n in V1)
    N2 = max(len(v) for v in ordinati.values())
    cal2 = ['2030.%02d.%02d' % (1 + j // 28, 1 + j % 28) for j in range(N2)]
    finto3 = dict((n, dict(dati[n], giorni=dict((cal2[j], v) for j, v in enumerate(ordinati[n])),
                           posizioni=[(cal2[j], v) for j, v in enumerate(ordinati[n])])) for n in V1)
    #    La misura giusta e' il MURO GIORNALIERO col Guardian SPENTO: una giornata oltre il 5% richiede
    #    piu' sedie in perdita INSIEME, e la copula comonotona (correlazione 1) la rende massima.
    #    Col Guardian ACCESO il taglio B1 a 4,5% rende le perdite concentrate PIU' ECONOMICHE in totale
    #    (oltre il taglio non si perde), e le due forze si oppongono: si stampa, non si giudica.
    f2, a2 = blocchi(finto3, V1, cal2, 2.0)
    p2, c2 = pool_posizioni(finto3, V1, cal2, 2.0)
    kw_off = dict(guardian=None, g_tot=None, min_giorni=MIN_GIORNI)
    ob = simula_v2(f2, 2.0, S_OGGI, attivo=a2, **kw_off)
    oi = simula_v2(f2, 2.0, S_OGGI, attivo=a2, comp=comp_iid(p2, c2), **kw_off)
    mb, mi = ob['p'].get('MORTE_GIORNALIERA', 0), oi['p'].get('MORTE_GIORNALIERA', 0)
    chk("(ii) correlazione 1, Guardian SPENTO: P(muro giornaliero 5%%) blocchi %.1f%% > IID %.1f%%" % (mb, mi), mb > mi + 1.0)
    ob = simula_v2(f2, 2.0, S_OGGI, attivo=a2, **KW_CAMPO)
    oi = simula_v2(f2, 2.0, S_OGGI, attivo=a2, comp=comp_iid(p2, c2), **KW_CAMPO)
    print("       (ii) informativo, Guardian ACCESO: P(fermata 9,3) blocchi %.1f%% / IID %.1f%%; PASS %.1f%% / %.1f%% "
          "(differenza entro il rumore, semi 12-14: -0,6/-0,2/-0,2; il taglio B1 del MODELLO e' perfetto sul realizzato "
          "e assorbe la coda: proprieta' del modello, magnitudo in campo [NON MISURATA])" % (
              ob['p'].get('FERMATA_GUARDIAN', 0), oi['p'].get('FERMATA_GUARDIAN', 0), ob['p'].get('PASS', 0), oi['p'].get('PASS', 0)))
    #    (iv) CONTRO-ESEMPIO della decomposizione: UNA sedia sola (771531, finestra A), tutto CON reimmissione.
    #    Fra sedie non c'e' niente da distruggere: IID-S deve coincidere coi blocchi. L'IID per posizione
    #    invece spezza le sue giornate a piu' posizioni: se se ne allontana, e' quello che misura.
    fE, aE = blocchi(dati, ['771531 EMA200'], calA, 2.0)
    pE, cE = pool_posizioni(dati, ['771531 EMA200'], calA, 2.0)
    kw_r = dict(KW_CAMPO, reimmissione=True, attivo=aE)
    obE = simula_v2(fE, 2.0, S_OGGI, **kw_r)
    osE = simula_v2(fE, 2.0, S_OGGI, comp=comp_sedia_giorno(dati, ['771531 EMA200'], calA, 2.0), **kw_r)
    oiE = simula_v2(fE, 2.0, S_OGGI, comp=comp_iid(pE, cE), **kw_r)
    bE, sE, iE = obE['p'].get('PASS', 0), osE['p'].get('PASS', 0), oiE['p'].get('PASS', 0)
    chk("(iv) 771531 sola: IID-S - blocchi = %+.2f punti (tolleranza 1,5: niente da distruggere fra sedie)" % (sE - bE),
        abs(sE - bE) < 1.5, "-> blocchi %.2f%%, IID-S %.2f%%" % (bE, sE))
    chk("(iv) 771531 sola: IID per posizione - blocchi = %+.2f punti (> 5: misura il co-movimento DENTRO la sedia)" % (iE - bE),
        iE - bE > 5.0, "-> IID per posizione %.2f%%" % iE)
    # 9. IID sui dati veri: il conteggio delle posizioni per giornata torna
    pA, cA = pool_posizioni(dati, V1, calA, 2.0)
    chk("IID: posizioni nel pool == posizioni contate sul calendario A (%d)" % sum(len(v) for v in pA.values()),
        sum(len(v) for v in pA.values()) == sum(sum(c.values()) for c in cA))
    # 10. stato del conto (dalla v1)
    chk("stato: saldo 75.090,72, DD 6,14%%, giorni ancora da fare %d, Guardian 4,5/9,3" % MIN_GIORNI,
        abs(SALDO_OGGI - 75090.72) < 0.005 and MIN_GIORNI == 1 and G_GIORN == 0.045 and G_TOT == 0.093)
    print("AUTOTEST: %s" % ("TUTTO VERDE" if ok else "ROSSO"))
    return ok


# ---------------------------------------------------------------- main
def main():
    dati = carica_v2()
    S = scenari(dati)
    calA, calB, calO = S['calA'], S['calB'], S['calORO']
    base, _ = S['G0_pool']; fer_pool, fer_att = S['G0_fer']
    print("=" * 120)
    print("MC CHALLENGE FTMO 541452707 v2 -- BLOCCHI PER GIORNATA + 770105 + ORO LONG -- dallo stato del 26/09/2026")
    print("saldo %.2f = %.6f del 80.000 | DD %.2f%% | target 88.000 | giorni fatti %d, ne manca %d | Guardian 4,5 / 9,3 / pausa 3,5 / cap 4,00" % (
        SALDO_OGGI, S_OGGI, 100 * (1 - S_OGGI), st.GIORNI_FATTI, MIN_GIORNI))
    print("seme %d, %d simulazioni per riga; banda = semi %s" % (SEME, NSIM, SEMI_BANDA))
    print("finestra A (4 sedie v1): %s -> %s, %d giorni di borsa | finestra B (con 770105): %s -> %s, %d giorni | oro intera storia: %s -> %s, %d giorni" % (
        calA[0], calA[-1], len(calA), calB[0], calB[-1], len(calB), calO[0], calO[-1], len(calO)))
    for n in SORGENTI_V2:
        s = dati[n]
        inA = sum(1 for d in calA if d in s['giorni']); inB = sum(1 for d in calB if d in s['giorni'])
        print("  %-16s %3d posizioni, %3d giornate (%s -> %s) | in A: %3d | in B: %3d | dep %.0f rischio %.1f%% | %s" % (
            n, len(s['posizioni']), len(s['giorni']), min(s['giorni']), max(s['giorni']), inA, inB, s['dep'], s['rmis'],
            'segue la taglia indici' if s['segue'] else 'taglia ASSOLUTA (0,5 / 1,0)'))
    print("NON MODELLATE: " + " | ".join(NON_MODELLATE))

    print("\n[CORRELAZIONE INTRA-GIORNATA, MISURATA sui per-trade]")
    for tag, nomi, cal in [('A: 4 sedie + oro', V1 + ['795301 ORO'], calA), ('B: 4 sedie + 770105 + oro', V1 + ['770105 DAXshort', '795301 ORO'], calB)]:
        neg2, op2, coppie = correlazione(dati, nomi, cal)
        print("  finestra %s: giornate con >=2 sedie operative %d, con >=2 sedie in PERDITA insieme %d" % (tag, op2, neg2))
        for a, b, nc, rho, ins in coppie:
            print("    %-16s x %-16s giorni comuni %3d  rho %s  perdono insieme %s" % (
                a, b, nc, '%+.2f' % rho if rho is not None else '  n/d', ins if ins is not None else 'n/d'))

    print("\n[DECOMPOSIZIONE DEL CO-MOVIMENTO, taglia 2,00%, TUTTO CON reimmissione (disegno neutro), semi 11/12/13]")
    print("  PASS / fine<=5gg.  BLK = blocchi | IID-S = solo FRA sedie distrutto | IID = anche DENTRO la sedia distrutto")
    for tag, nomi, cal in [('A: 4 sedie v1', V1, calA), ('B: 4 sedie + 770105', V1 + ['770105 DAXshort'], calB),
                           ('A: 771531 sola (contro-esempio iv)', ['771531 EMA200'], calA)]:
        f, a = blocchi(dati, nomi, cal, 2.0)
        pp, cc = pool_posizioni(dati, nomi, cal, 2.0)
        cs = comp_sedia_giorno(dati, nomi, cal, 2.0)
        out = []
        for sm in (11, 12, 13):
            kw = dict(KW_CAMPO, reimmissione=True, attivo=a, seme=sm)
            r = [simula_v2(f, 2.0, S_OGGI, comp=c, **kw) for c in (None, cs, comp_iid(pp, cc))]
            out.append(" / ".join("%.1f-%.1f" % (o['p'].get('PASS', 0), fine5(o)) for o in r))
        print("  %-36s BLK / IID-S / IID  ->  %s" % (tag, "  ||  ".join(out)))

    righe_md = []
    for fatt, etich in [(2.0, "2,00% (taglia in campo)"),
                        (1.0, "1,00% [preset demo BCM, tetto PROPOSTO il 19/09 e NON firmato -- solo riferimento, NESSUNA PROPOSTA]"),
                        (0.65, "0,65% [taglia firmata di casa sul 100k e sul REALE -- solo riferimento, NESSUNA PROPOSTA]")]:
        banda_on = (fatt == 2.0)
        print("\n[TAGLIA INDICI %s]  oro sempre a taglia ASSOLUTA 0,5%% o 1,0%% del saldo" % etich)
        righe = []
        # G0
        righe.append(("G0  v1 com'e' (242 giornate con operazioni) [ANCORA 57,2 a 2%]", base, None, None, None, None))
        righe.append(("G0f v1 feriali (277 giorni di borsa, 35 a zero)", fer_pool, fer_att, None, None, None))
        # finestra A
        fA, aA = blocchi(dati, V1, calA, fatt)
        pA, cA = pool_posizioni(dati, V1, calA, fatt)
        righe.append(("IID A: 4 sedie, posizioni indipendenti (modello 'trade indipendenti')", fA, aA, comp_iid(pA, cA), None, None))
        righe.append(("IID-S A: 4 sedie, giornate di sedia indipendenti (solo FRA sedie)", fA, aA,
                      comp_sedia_giorno(dati, V1, calA, fatt), None, None))
        righe.append(("BLK A: 4 sedie a blocchi giornalieri (== G0f)", fA, aA, None, None, None))
        for t in (0.5, 1.0):
            f, a = blocchi(dati, V1 + ['795301 ORO'], calA, fatt, t)
            righe.append(("BLK A: 4 sedie + ORO %.1f%% (43 giornate oro, agganciate per data)" % t, f, a, None, None, None))
        p, c = pool_posizioni(dati, V1 + ['795301 ORO'], calA, fatt, 1.0)
        f, a = blocchi(dati, V1 + ['795301 ORO'], calA, fatt, 1.0)
        righe.append(("IID A: 4 sedie + ORO 1,0%, posizioni indipendenti", f, a, comp_iid(p, c), None, None))
        for t in (0.5, 1.0):
            don = {'ORO': pool_oro_intero(dati, fatt, t, calO)}
            righe.append(("BLK A + ORO %.1f%% INTERA STORIA 2020-26, INDIPENDENTE dagli indici" % t, fA, aA, None, ['ORO'] * len(fA), don))
        # finestra B
        fB, aB = blocchi(dati, V1, calB, fatt)
        righe.append(("BLK B: 4 sedie, finestra B (2025.07.01 -> 2026.06.29)", fB, aB, None, None, None))
        f5, a5 = blocchi(dati, V1 + ['770105 DAXshort'], calB, fatt)
        righe.append(("BLK B: 4 sedie + 770105 (DAX short, 181 giornate)", f5, a5, None, None, None))
        p5, c5 = pool_posizioni(dati, V1 + ['770105 DAXshort'], calB, fatt)
        righe.append(("IID B: 4 sedie + 770105, posizioni indipendenti", f5, a5, comp_iid(p5, c5), None, None))
        righe.append(("IID-S B: 4 sedie + 770105, giornate di sedia indipendenti (solo FRA sedie)", f5, a5,
                      comp_sedia_giorno(dati, V1 + ['770105 DAXshort'], calB, fatt), None, None))
        for t in (0.5, 1.0):
            f, a = blocchi(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, t)
            righe.append(("BLK B: 4 sedie + 770105 + ORO %.1f%%" % t, f, a, None, None, None))
        p, c = pool_posizioni(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, 1.0)
        f, a = blocchi(dati, V1 + ['770105 DAXshort', '795301 ORO'], calB, fatt, 1.0)
        righe.append(("IID B: 4 sedie + 770105 + ORO 1,0%, posizioni indipendenti", f, a, comp_iid(p, c), None, None))
        don = {'ORO': pool_oro_intero(dati, fatt, 1.0, calO)}
        righe.append(("BLK B + 770105 + ORO 1,0% INTERA STORIA, INDIPENDENTE", f5, a5, None, ['ORO'] * len(f5), don))
        righe.append(("BLK B: 4 sedie + 770105 + ORO 1,0%% + slittamento x%.3f" % SLIP, f, a, None, None, 'slip'))
        for nome, pool, att, comp, sost, don in righe:
            slip = SLIP if don == 'slip' else 1.0
            if don == 'slip':
                sost, don = None, None
            o = corsa(pool, fatt, attivo=att, comp=comp, sost=sost, donatori=don, slip=slip)
            banda = None
            if banda_on:
                banda = [corsa(pool, fatt, attivo=att, comp=comp, sost=sost, donatori=don, slip=slip, seme=sm) for sm in SEMI_BANDA]
            s = riga_tab(nome, o, banda)
            righe_md.append((fatt, nome, o, banda))
    print("=" * 120)
    return righe_md


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(0 if autotest() else 1)
    main()
