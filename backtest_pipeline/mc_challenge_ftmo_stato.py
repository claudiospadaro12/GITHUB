#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mc_challenge_ftmo_stato.py -- 25/09/2026

IL MONTE CARLO DELLA CHALLENGE FTMO 541452707 RIFATTO DALLO STATO DI OGGI.
Referto: report/MC_DALLO_STATO_DI_OGGI_2026-09-25.md

NON modifica mc_challenge_ftmo.py ne' mc_challenge_ftmo_allineati.py: li
IMPORTA (carica, serie, e il calendario sfasato/allineato).

STATO DI PARTENZA (report/TERZO_STOP_FTMO_2026-09-25.md, ricontrollato):
  saldo 76.643,52 a inizio 25/09 (riga Guardian 24/09 23:55, CODA_09 del 25/09)
  - 1.552,80 (stop 770101 del 25/09) = 75.090,72  -> 0,938634 del 80.000
  giorni di trading gia' fatti: 22/09, 24/09, 25/09 = 3  -> ne manca 1
  si parte dall'APERTURA DEL PROSSIMO GIORNO DI BORSA (lun 28/09): il -1.552,80
  di oggi pesa sul giornaliero di OGGI e non entra nella simulazione.

GUARDIAN IN CAMPO (CODA_08 del 25/09, chart06.chr modificato il 24/09 08:06,
= mql5/Presets/ABTG_Guardian_FTMO_2Step.set):
  InpStartBalance=80000  InpDailyLossPct=4.5  InpTotalDDPct=9.3  InpDDMode=0
  InpDailyPausePct=3.5   InpMaxOpenRiskPct=4.00  InpAction=0 (CHIUDI+BLOCCA)
  -> emergenza totale a 72.560 EUR: "CHALLENGE FERMATA" (GV_FAILED, pausa 30 gg).
     Nel modello e' un esito a se': FERMATA_GUARDIAN (conto NON violato, corsa finita).

COSA C'E' DI NUOVO RISPETTO A mc_challenge_ftmo.simula():
  g_tot   : emergenza TOTALE del Guardian (0,093). Se il saldo di fine giornata
            scende a <= 1 - g_tot, la giornata e' tagliata li' e la corsa finisce.
  pausa   : pausa morbida B1 (0,035), APPROSSIMATA con l'ora di CHIUSURA: le
            operazioni che chiudono dopo che il realizzato del giorno ha toccato
            la soglia sono tolte (il per-trade non ha l'ora d'ingresso).
  attivo  : giornate senza operazioni (pool dei FERIALI) non contano come
            trading day per il minimo di 4.
  orizzonte: P(esito entro N giornate simulate).
  CON g_tot=None, pausa=None, attivo=None consuma il generatore ESATTAMENTE
  come m.simula(): e' la prima cosa che --autotest verifica.

IL CAP C1 (InpMaxOpenRiskPct), LETTO NEL CODICE:
  ABTG_Guardian.mq5 r.789: il flag si accende se riskPct >= cap, con riskPct =
  somma entry->SL delle posizioni APERTE; ABTG_PausaGuardian.mqh
  ABTG_MotivoStop_Calc(): l'EA rifiuta l'ingresso se il flag e' acceso.
  NON e' prospettico. Quindi a 2,00% per sedia:
    cap 4,00 -> una posizione (2,0) libera; due (4,0 se la somma e' >= 4,00) bloccano la TERZA
    cap 3,25 -> una posizione (2,0 < 3,25) libera -> entra la SECONDA; due (4,0) bloccano la TERZA
  Il per-trade NON ha l'ora d'ingresso: la sovrapposizione non si misura. Il
  modello ne da' due LIMITI ESTREMI (tutte le operazioni della giornata
  sovrapposte, ordine = ora della prima chiusura):
    cap_max=2 : tiene le prime 2 sedie della giornata  (morso massimo di un cap a 2 posizioni)
    cap_max=1 : tiene la prima sedia sola              (lettura "una alla volta")

USO:
  python3 backtest_pipeline/mc_challenge_ftmo_stato.py            # tabella completa (~2-4 min)
  python3 backtest_pipeline/mc_challenge_ftmo_stato.py --autotest # controlli, poi esce
"""
import collections, datetime as dt, os, random, statistics, sys

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import mc_challenge_ftmo as m                      # noqa: E402
import mc_challenge_ftmo_allineati as al           # noqa: E402  (importa m e ne cambia SALDO_VERO_2209: qui non si usa)

BANCO = 80000.0
SALDO_INIZIO_2509 = 76643.52     # Guardian 24/09 23:55, eq=76643.52 (CODA_09 del 25/09)
STOP_2509 = 1552.80              # report/TERZO_STOP_FTMO_2026-09-25.md par.1
SALDO_OGGI = round(SALDO_INIZIO_2509 - STOP_2509, 2)   # 75.090,72
S_OGGI = SALDO_OGGI / BANCO
GIORNI_FATTI = 3                 # 22/09, 24/09, 25/09 (CODA_09: 23/09 nessuna posizione)
MIN_GIORNI_RESTANTI = max(0, 4 - GIORNI_FATTI)

G_GIORN, G_TOT, G_PAUSA = 0.045, 0.093, 0.035     # Guardian in campo (CODA_08 25/09)
SEME, NSIM = 11, 20000
SLIP_MISURATO = (1757.68 + 1668.46 + 1552.80) / (1590.37 + 1621.03 + 1539.86)  # 3 stop veri: reale / allo SL


# ---------------------------------------------------------------- simulatore
def valore_con_pausa(trade_giorno, fattore, b0, pausa):
    """Valore della giornata (unita' della misura 1,00%) con la pausa B1: si
       sommano le operazioni in ordine di chiusura e ci si ferma DOPO quella che
       porta il realizzato del giorno a >= pausa (in frazione del 80.000)."""
    soglia = pausa / (fattore * b0)
    v = 0.0
    for x in trade_giorno:
        v += x
        if -v >= soglia:
            break
    return v


def simula_stato(fisso, fattore, saldo_iniziale=1.0, guardian=None, slip=1.0,
                 n_sim=NSIM, seme=SEME, target=0.10, muro_stat=0.10, muro_gior=0.05,
                 min_giorni=4, max_giorni=800, g_tot=None, sost=None, donatori=None,
                 intraday=None, pausa=None, attivo=None, orizzonte=5, stake_fisso=False,
                 reimmissione=False):
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
                k = rnd.randrange(N)             # bootstrap iid (sensibilita')
            else:
                if i >= len(s):
                    s2 = idx[:]; rnd.shuffle(s2); s = s + s2
                k = s[i]; i += 1
            b0 = bal
            if pausa is not None and intraday is not None:
                v = valore_con_pausa(intraday[k], fattore, b0, pausa)
            else:
                v = fisso[k]
            if sost is not None and sost[k] is not None:
                pool = donatori[sost[k]]
                v = v + pool[rnd.randrange(len(pool))]
            r = v * fattore
            if r < 0:
                r *= slip
            if stake_fisso:
                perdita = -r
                if guardian is not None and perdita > guardian:
                    r = -guardian
                bal = b0 + r
            else:
                # stessa aritmetica di m.simula (bit per bit)
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
    return {'p': {k: 100.0 * v / tot for k, v in esiti.items()},
            'med_pass': statistics.median(d_pass) if d_pass else None,
            'med_fine': statistics.median(d_fine) if d_fine else None,
            'entro': {k: 100.0 * v / tot for k, v in entro.items()}}


def simula_old_compat(frac1, fattore, saldo_iniziale, guardian, slip=1.0, seme=SEME):
    """simula_stato nelle condizioni di m.simula (per il confronto)."""
    o = simula_stato(frac1, fattore, saldo_iniziale, guardian=guardian, slip=slip, seme=seme)
    return o['p'], o['med_pass']


# ---------------------------------------------------------------- dati
def dati():
    per = m.carica()
    giorni, base = m.serie(per)
    tr = al.trade()
    # per-trade per giornata, in ordine di chiusura (ora completa)
    import csv
    righe = collections.defaultdict(list)
    for nome, rel in m.SORGENTI.items():
        with open(os.path.join(QUI, rel), newline='') as fh:
            for r in csv.DictReader(fh, delimiter=';'):
                righe[r['close_time'][:10]].append((r['close_time'], nome, float(r['net_profit'])))
    intraday = [[p / m.DEPOSITO_MISURA for _, _, p in sorted(righe[gg])] for gg in giorni]
    # ordine delle sedie nella giornata = ora della loro PRIMA chiusura
    ordine = []
    for gg in giorni:
        visti = []
        for t, n, _ in sorted(righe[gg]):
            if n not in visti:
                visti.append(n)
        ordine.append(visti)
    return per, giorni, base, intraday, ordine


def pool_cap(per, giorni, ordine, cap_max):
    out = []
    for gg, od in zip(giorni, ordine):
        tenute = od[:cap_max]
        out.append(sum(per[n].get(gg, 0.0) for n in tenute) / m.DEPOSITO_MISURA)
    return out


def pool_feriali(giorni, base):
    """Tutti i feriali della finestra (zero se nessuna operazione) + le giornate
       con operazioni che cadono nel weekend."""
    D = [al.data(g) for g in giorni]
    val = dict(zip(D, base))
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    tutti = sorted(set(d for d in fer if d.weekday() < 5) | set(D))
    return [val.get(d, 0.0) for d in tutti], [d in val for d in tutti]


def costruisci_v1(per, giorni):
    """Stessa costruzione di V1 in mc_challenge_ftmo_allineati.py (donatori = feriali tutto-allineati)."""
    D = [al.data(g) for g in giorni]
    key = dict(zip(D, giorni))

    def contr(d, sedie):
        g = key.get(d)
        return 0.0 if g is None else sum(per[n].get(g, 0.0) for n in sedie) / m.DEPOSITO_MISURA
    fer = [D[0] + dt.timedelta(k) for k in range((D[-1] - D[0]).days + 1)]
    fer_al = [d for d in fer if d.weekday() < 5 and al.tutto_allineato(d)]
    DON = {'DAX': [contr(d, ['770101 DAX', '770411 MaxMin']) for d in fer_al],
           'USA': [contr(d, ['770202 Dow']) for d in fer_al],
           'ORARIO': [contr(d, al.A_ORARIO) for d in fer_al]}
    fisso, sost = [], []
    for d, g in zip(D, giorni):
        sd, su = al.sfasato(d, 'DAX'), al.sfasato(d, 'USA')
        keep = ['771531 EMA200']
        if not sd: keep += ['770101 DAX', '770411 MaxMin']
        if not su: keep += ['770202 Dow']
        fisso.append(sum(per[n].get(g, 0.0) for n in keep) / m.DEPOSITO_MISURA)
        sost.append('ORARIO' if (sd and su) else 'DAX' if sd else 'USA' if su else None)
    return fisso, sost, DON


# ---------------------------------------------------------------- stampa
def riga(nome, o, o_fer=None):
    p = o['p']; e = o['entro']
    fine5 = sum(v for k, v in e.items() if k != 'PASS')
    s = ("  %-46s PASS %5.1f | FERM.G9,3 %5.1f | FTMO10 %5.1f | FTMO5gg %5.1f | TIMEOUT %4.1f | "
         "ggPASS %5s | ggFINE %5s | fine<=5g %4.1f" % (
             nome, p.get('PASS', 0), p.get('FERMATA_GUARDIAN', 0), p.get('MORTE_STATICA', 0),
             p.get('MORTE_GIORNALIERA', 0), p.get('TIMEOUT', 0), o['med_pass'], o['med_fine'], fine5))
    if o_fer is not None:
        pf = o_fer['p']; ef = o_fer['entro']
        s += " || feriali: PASS %5.1f | ggPASS %5s | ggFINE %5s | fine<=5fer %4.1f | pass<=5fer %4.1f" % (
            pf.get('PASS', 0), o_fer['med_pass'], o_fer['med_fine'],
            sum(v for k, v in ef.items() if k != 'PASS'), ef.get('PASS', 0))
    print(s)


def stop_al_guardian(taglia, slip=1.0):
    """Quanti stop pieni consecutivi (taglia % del saldo, x slip) portano il saldo a <= 72.560."""
    b = SALDO_OGGI; k = 0
    while b > BANCO * (1 - G_TOT):
        b *= (1 - taglia * slip / 100.0); k += 1
    return k, b


# ---------------------------------------------------------------- autotest
def autotest():
    ok = True

    def chk(nome, cond, dettaglio=''):
        nonlocal ok
        print("  [%s] %s %s" % ('PASS' if cond else 'FAIL', nome, dettaglio))
        ok = ok and cond

    print("AUTOTEST mc_challenge_ftmo_stato.py")
    # 1. riproduzione: simula_stato con i ganci spenti == m.simula, al decimale e alla mediana
    per = m.carica(); _, base = m.serie(per)
    for S, gd, sl, atteso in [(76573.86 / BANCO, 0.045, 1.0, 74.6), (78242.32 / BANCO, 0.045, 1.0, 84.0),
                               (76573.86 / BANCO, None, 1.0, 61.8), (76573.86 / BANCO, 0.045, 1.105, 68.4)]:
        o_ref, med_ref = m.simula(base, 2.0, S, guardian=gd, slip=sl)
        o_new, med_new = simula_old_compat(base, 2.0, S, gd, slip=sl)
        chk("riproduce m.simula (S=%.5f, G=%s, slip=%s)" % (S, gd, sl),
            o_ref == o_new and med_ref == med_new and abs(o_ref['PASS'] - atteso) < 0.05,
            "-> %.4f%% / %.4f%%, mediana %s / %s, referto %.1f" % (o_ref['PASS'], o_new['PASS'], med_ref, med_new, atteso))
    # 2. rovina del giocatore, aritmetica esatta in base 2 (passi 1/64, puntata fissa)
    #    start 60/64, target >= 1,10 -> 71/64 (11 passi su); Guardian 9,3% -> <=0,907 -> 58/64 (2 giu')
    #    => P(PASS) = 2/13 = 15,38%. Muro FTMO statico (<0,90) -> 57/64 (3 giu') => 3/14 = 21,43%.
    #    CONTRO-ESEMPIO: se il Guardian fosse codificato come il muro statico, darebbe 21,43 e non 15,38.
    #    Il simulatore di casa pesca SENZA reimmissione a blocchi (un anno rimescolato): con un pool di
    #    2 valori il cammino non si allontana mai piu' di un passo. Qui: reimmissione=True (iid).
    u = 1.0 / 64
    o = simula_stato([u, -u], 1.0, 60 / 64, g_tot=0.093, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True,
                     reimmissione=True)
    chk("rovina con Guardian 9,3%: P(PASS)=2/13=15,38%", abs(o['p'].get('PASS', 0) - 100 * 2 / 13) < 0.8,
        "-> %.2f%%, resto FERMATA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('FERMATA_GUARDIAN', 0)))
    o = simula_stato([u, -u], 1.0, 60 / 64, g_tot=None, min_giorni=0, n_sim=60000, seme=5, stake_fisso=True,
                     reimmissione=True)
    chk("rovina senza Guardian (muro 10%): P(PASS)=3/14=21,43%", abs(o['p'].get('PASS', 0) - 100 * 3 / 14) < 0.8,
        "-> %.2f%%, resto STATICA %.2f%%" % (o['p'].get('PASS', 0), o['p'].get('MORTE_STATICA', 0)))
    # 3. giornata da -6% partendo da oggi: col Guardian -> clamp 4,5% -> 0,8936 <= 0,907 -> FERMATA al giorno 1
    #    senza Guardian -> 6% x 0,9386 = 5,63% > 5% -> MORTE_GIORNALIERA al giorno 1
    o = simula_stato([-0.03], 2.0, S_OGGI, guardian=G_GIORN, g_tot=G_TOT, n_sim=100)
    chk("giornata -6%% col Guardian -> FERMATA_GUARDIAN g1", o['p'] == {'FERMATA_GUARDIAN': 100.0} and o['med_fine'] == 1)
    o = simula_stato([-0.03], 2.0, S_OGGI, n_sim=100)
    chk("giornata -6%% senza Guardian -> MORTE_GIORNALIERA g1", o['p'] == {'MORTE_GIORNALIERA': 100.0} and o['med_fine'] == 1)
    # 4. pausa: trade [-2%, -2%, +3%] a fattore 1, saldo 1 -> dopo due -4% >= 3,5% -> il terzo cade: -4%
    #    a pausa 5% il terzo resta: -1%. A fattore 2 la soglia in unita' 1% e' 1,75%: si ferma al primo (-2%).
    t = [-0.02, -0.02, 0.03]
    chk("pausa 3,5%%: [-2,-2,+3] -> -4%% | pausa 5%% -> -1%% | fattore 2 -> -2%%",
        abs(valore_con_pausa(t, 1.0, 1.0, 0.035) + 0.04) < 1e-12 and abs(valore_con_pausa(t, 1.0, 1.0, 0.05) + 0.01) < 1e-12
        and abs(valore_con_pausa(t, 2.0, 1.0, 0.035) + 0.02) < 1e-12)
    # 5. pool cap: giornata finta con tre sedie
    perf = {'A': {'g': 100.0}, 'B': {'g': -50.0}, 'C': {'g': 30.0}}
    chk("pool_cap: prime 2 = +50, prima sola = +100",
        abs(pool_cap(perf, ['g'], [['A', 'B', 'C']], 2)[0] - 50 / m.DEPOSITO_MISURA) < 1e-15 and
        abs(pool_cap(perf, ['g'], [['A', 'B', 'C']], 1)[0] - 100 / m.DEPOSITO_MISURA) < 1e-15)
    # 6. aritmetica dello stato
    chk("saldo oggi 75.090,72", abs(SALDO_OGGI - 75090.72) < 0.005, "(%.2f)" % SALDO_OGGI)
    chk("DD totale 6,14%", abs(100 * (1 - S_OGGI) - 6.14) < 0.005, "(%.4f%%)" % (100 * (1 - S_OGGI)))
    chk("margine all'emergenza Guardian 72.560 = 2.530,72", abs(SALDO_OGGI - BANCO * (1 - G_TOT) - 2530.72) < 0.005)
    chk("slittamento misurato 3 stop = +4,79%", abs(SLIP_MISURATO - 1.0479) < 0.0005, "(%.4f)" % SLIP_MISURATO)
    # 7. dati: la somma dell'intraday torna al pool per giornata
    per, giorni, base, intra, ordine = dati()
    chk("intraday somma = pool giornaliero (242 giornate)",
        len(intra) == 242 and all(abs(sum(a) - b) < 1e-12 for a, b in zip(intra, base)))
    chk("pool_cap con cap enorme = pool originale",
        all(abs(a - b) < 1e-12 for a, b in zip(pool_cap(per, giorni, ordine, 9), base)))
    # 8. V1 ricostruita qui == V1 di mc_challenge_ftmo_allineati.py (70,8% dal suo stato)
    f1, s1, DON = costruisci_v1(per, giorni)
    o = simula_stato(f1, 2.0, 76573.86 / BANCO, guardian=0.045, sost=s1, donatori=DON)
    ov, mv = al.simula_mix(giorni, f1, s1, DON, 2.0, 76573.86 / BANCO, guardian=0.045)
    chk("V1 riprodotta (referto MC_MESI_ALLINEATI: 70,8%, 103 sostituite)",
        o['p'] == ov and o['med_pass'] == mv and abs(ov['PASS'] - 70.8) < 0.05 and sum(1 for x in s1 if x) == 103,
        "-> %.4f%% / %.4f%%, mediana %s / %s" % (o['p']['PASS'], ov['PASS'], o['med_pass'], mv))
    print("AUTOTEST: %s" % ("TUTTO VERDE" if ok else "ROSSO"))
    return ok


# ---------------------------------------------------------------- main
def main():
    per, giorni, base, intra, ordine = dati()
    fer_pool, fer_att = pool_feriali(giorni, base)
    _, cattiva = m.serie(per, copia='770202 Dow', peggiora=1.157)
    fer_catt, _ = pool_feriali(giorni, cattiva)
    f1, s1, DON = costruisci_v1(per, giorni)
    cap2 = pool_cap(per, giorni, ordine, 2)
    cap1 = pool_cap(per, giorni, ordine, 1)
    fer_cap2, _ = pool_feriali(giorni, cap2)
    fer_cap1, _ = pool_feriali(giorni, cap1)

    print("=" * 110)
    print("MC CHALLENGE FTMO 541452707 DALLO STATO DEL 25/09/2026 -- apertura del prossimo giorno di borsa")
    print("saldo %.2f = %.6f del 80.000 | DD %.2f%% | target 88.000 (+%.2f%% dal saldo) | giorni fatti %d, ne manca %d" % (
        SALDO_OGGI, S_OGGI, 100 * (1 - S_OGGI), 100 * (88000 / SALDO_OGGI - 1), GIORNI_FATTI, MIN_GIORNI_RESTANTI))
    print("Guardian in campo: giorn. %.1f%% | TOTALE %.1f%% (= %.0f EUR, margine %.2f) | pausa %.1f%% | cap C1 4,00" % (
        100 * G_GIORN, 100 * G_TOT, BANCO * (1 - G_TOT), SALDO_OGGI - BANCO * (1 - G_TOT), 100 * G_PAUSA))
    print("pool: %d giornate con operazioni | feriali: %d voci (%d a zero) | seme %d, %d simulazioni" % (
        len(base), len(fer_pool), sum(1 for a in fer_att if not a), SEME, NSIM))
    print("slittamento misurato sui 3 stop veri: x%.4f" % SLIP_MISURATO)
    print("giornate con >=2 sedie: %d | con >=3 sedie: %d" % (sum(1 for o in ordine if len(o) >= 2), sum(1 for o in ordine if len(o) >= 3)))
    nsost = sum(1 for x in s1 if x)
    print("V1 allineati: %d giornate sostituite" % nsost)

    print("\n[STOP PIENI CONSECUTIVI CHE PORTANO A <= 72.560 (emergenza Guardian)]")
    for t in (2.0, 1.0, 0.65):
        for sl in (1.0, SLIP_MISURATO, 1.105):
            k, b = stop_al_guardian(t, sl)
            print("  taglia %.2f%%  slip x%.3f : %d stop (saldo dopo %d-1 = %.2f)" % (t, sl, k, k, stop_al_guardian_prima(t, sl)))

    kw = dict(guardian=G_GIORN, g_tot=G_TOT, min_giorni=MIN_GIORNI_RESTANTI)
    for fatt, etich in [(2.0, "2,00% (a) e (b)"), (1.0, "1,00% [gia' firmata altrove, NESSUNA PROPOSTA]"),
                        (0.65, "0,65% [gia' firmata altrove, NESSUNA PROPOSTA]")]:
        print("\n[TAGLIA %s]" % etich)
        righe = [
            ("M  modello di campo (G 4,5 + 9,3)", base, fer_pool, {}),
            ("M  + slittamento misurato x%.3f" % SLIP_MISURATO, base, fer_pool, dict(slip=SLIP_MISURATO)),
            ("M  + slittamento x1,105", base, fer_pool, dict(slip=1.105)),
            ("M  + pausa 3,5% (approssimata)", base, None, dict(intraday=intra, pausa=G_PAUSA)),
            ("M  V1 sedie a orario -> mesi allineati", f1, None, dict(sost=s1, donatori=DON)),
            ("M  pessimista di casa (5a sedia+x1,157+x1,105)", cattiva, fer_catt, dict(slip=1.105)),
        ]
        if fatt == 2.0:
            righe += [
                ("M  limite cap: max 2 sedie/giornata", cap2, fer_cap2, {}),
                ("M  limite cap: 1 sedia/giornata", cap1, fer_cap1, {}),
            ]
        for nome, pool, pool_f, extra in righe:
            k2 = dict(kw); k2.update(extra)
            o = simula_stato(pool, fatt, S_OGGI, **k2)
            of = None
            if pool_f is not None:
                k3 = dict(k2); k3['attivo'] = fer_att
                of = simula_stato(pool_f, fatt, S_OGGI, **k3)
            riga(nome, o, of)
        o = simula_stato(base, fatt, S_OGGI, reimmissione=True, **kw)
        riga("S  campionamento CON reimmissione (iid)", o)
        # sensibilita' sul Guardian
        o = simula_stato(base, fatt, S_OGGI, guardian=G_GIORN, g_tot=None, min_giorni=MIN_GIORNI_RESTANTI)
        riga("S  Guardian totale NON modellato (muro 10%)", o)
        o = simula_stato(base, fatt, S_OGGI, guardian=0.049, g_tot=0.099, min_giorni=MIN_GIORNI_RESTANTI)
        riga("S  Guardian 4,9/9,9 (valori del task, NON in campo)", o)
        o = simula_stato(base, fatt, S_OGGI, guardian=None, g_tot=None, min_giorni=MIN_GIORNI_RESTANTI)
        riga("S  Guardian SPENTO (fail-open B3)", o)
    print("=" * 110)


def stop_al_guardian_prima(taglia, slip):
    k, _ = stop_al_guardian(taglia, slip)
    b = SALDO_OGGI
    for _ in range(k - 1):
        b *= (1 - taglia * slip / 100.0)
    return b


if __name__ == '__main__':
    if '--autotest' in sys.argv:
        sys.exit(0 if autotest() else 1)
    main()
