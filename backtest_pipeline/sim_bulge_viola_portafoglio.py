#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_portafoglio.py -- SIMULAZIONE DI CARTA, SOLA LETTURA.
#  Applica REGOLE DI PORTAFOGLIO a posizioni gia' accadute del Bulge VIOLA
#  e misura cosa sarebbe cambiato. NON tocca l'EA, i preset, il forward.
#  NON cambia l'entrata del VIOLA ("ogni tocco dopo un impulso" resta):
#  le regole agiscono DOPO il segnale (portafoglio), e un segnale scartato
#  e' un segnale che la regola di portafoglio ha rifiutato.
#
#  Uso (dalla radice del repo):
#      python3 backtest_pipeline/sim_bulge_viola_portafoglio.py            # tutto
#      python3 backtest_pipeline/sim_bulge_viola_portafoglio.py --autotest # solo autotest
#  ASCII puro. Seme fisso 20261008.
#
#  --- ATTESE SCRITTE PRIMA DEI NUMERI (08/10/2026; viste solo le 19 righe del
#      trial e i conteggi grezzi del 08/10, MAI il risultato di una regola) ---
#  Ipotesi nulla H0: la regola toglie posizioni "a caso" rispetto all'esito:
#      il delta (somma di r dopo - prima) cade nella distribuzione di una
#      rimozione CASUALE di k posizioni (k = quante ne toglie la regola).
#  Ipotesi alternativa H1: la regola toglie le perdenti piu' delle vincenti:
#      delta >= +2 R e p(rimozione casuale) < 0.05 in ALMENO DUE fonti
#      indipendenti (v520 e antenato: periodi disgiunti; il trial NON e'
#      indipendente da v520: stesse operazioni sui cross comuni).
#  ATTESA (banda): per ogni regola e fonte |delta| < 3 R e p > 0.10; cioe'
#      "non distinguibile dal caso" (n 19-50 posizioni VIOLA). Cluster cap=1:
#      toglie il 15-45% di trial e v520 (11 posizioni trial su 19 toccano NZD),
#      meno del 15% dell'antenato (~1 apertura/giorno). Kill-switch piu'
#      stretto: toglie 0-3 posizioni. Massimo di aperte osservato: 4-6.
#  SOGLIE CONGELATE: "indizio" se p < 0.05; "promuovibile" solo se p < 0.05/14
#      (Bonferroni sulle 14 regole per fonte) in due fonti indipendenti E con
#      il segno giusto anche su R92BAB dove la regola e' valutabile (qui non
#      lo e': vedi LIMITI). Un'ora sola di un solo regime: mai "promuovibile".
#  LIMITI DICHIARATI:
#   - la simulazione TOGLIE posizioni, non ne AGGIUNGE: se una regola libera
#     uno slot (Max_Trades) o un cluster, un altro segnale che non vediamo
#     sarebbe partito. L'effetto vero ha un'incognita in piu' (conservativa
#     solo se i segnali rimossi non sono rimpiazzati da altri migliori).
#   - R92BAB (190 VIOLA, il campione piu' grande) ha SOLO l'ora di chiusura:
#     le regole che ordinano le aperture NON sono simulabili li'.
#   - nessun MFE/MAE, nessun tracciato intra-trade: BE, trailing, time-stop,
#     TP dinamico NON si simulano (vedi il dossier).
#   - il trial ha 3 istanze con Max_Trades propri: la concorrenza e' sommata.
# =====================================================================
import collections
import datetime
import random
import sys

import sim_bulge_viola_dati as D

SEME = 20261008
N_PERM = 10000
NREGOLE = 14


# ------------------------------------------------------------------ motore
def ordina(pos):
    return sorted(pos, key=lambda p: (p["apre"], D.ordine_simbolo(p["sym"])))


def simula(pos, regola):
    acc, scart = [], []
    for p in ordina(pos):
        (acc if regola(p, acc) else scart).append(p)
    return acc, scart


def aperte_a(acc, t):
    return [q for q in acc if q["apre"] <= t < q["chiude"]]


def r_cluster(cap, firmato):
    """Max `cap` posizioni aperte per valuta. firmato=True: conta solo la stessa direzione
    sulla valuta (long NZD contro long NZD); False: qualunque posizione che contiene la valuta."""
    def f(p, acc):
        att = aperte_a(acc, p["apre"])
        for c, s in D.esposizione(p["sym"], p["lato"]).items():
            n = 0
            for q in att:
                e = D.esposizione(q["sym"], q["lato"])
                if c in e and (not firmato or e[c] == s):
                    n += 1
            if n >= cap:
                return False
        return True
    return f


def r_stop_cluster(firmato):
    """Dopo uno STOP PIENO (uscita a SL) di una posizione che contiene la valuta, nello stesso giorno
    server, niente altro su quella valuta (stessa direzione se firmato)."""
    def f(p, acc):
        gio = p["apre"].date()
        for q in acc:
            if q["motivo"] != "sl" or q["chiude"].date() != gio or q["chiude"] > p["apre"]:
                continue
            ep, eq = D.esposizione(p["sym"], p["lato"]), D.esposizione(q["sym"], q["lato"])
            for c, s in ep.items():
                if c in eq and (not firmato or eq[c] == s):
                    return False
        return True
    return f


def r_max_aperte(cap):
    return lambda p, acc: len(aperte_a(acc, p["apre"])) < cap


def r_kill(sl_giorno=None, consec=None, perdita_R=None):
    """Replica il kill switch dell'EA (ABTG_Bulge.mq5 r.965-1022): conta le chiusure DEL GIORNO server
    fino all'istante dell'apertura; isSL = uscita a SL oppure netto < 0; consecutivi = coda della
    sequenza in ordine di chiusura; perdita = somma r del giorno (unita' R, 1.0 R = 0.8% nel preset)."""
    def f(p, acc):
        gio = p["apre"].date()
        ch = sorted([q for q in acc if q["chiude"].date() == gio and q["chiude"] <= p["apre"]],
                    key=lambda q: q["chiude"])
        nsl, run, pnl = 0, 0, 0.0
        for q in ch:
            pnl += q["r"]
            if q["motivo"] == "sl" or q["netto"] < 0:
                nsl += 1
                run += 1
            elif q["netto"] > 0:
                run = 0
        if sl_giorno is not None and nsl >= sl_giorno:
            return False
        if consec is not None and run >= consec:
            return False
        if perdita_R is not None and pnl <= -perdita_R:
            return False
        return True
    return f


def r_simbolo_giorno(maxn):
    """CONCENTRAZIONE: al massimo `maxn` aperture sullo stesso simbolo nello stesso giorno server."""
    def f(p, acc):
        return sum(1 for q in acc if q["sym"] == p["sym"] and q["apre"].date() == p["apre"].date()) < maxn
    return f


def max_concorrenza(pos):
    ev = []
    for p in pos:
        ev.append((p["apre"], 1))
        ev.append((p["chiude"], -1))
    ev.sort(key=lambda e: (e[0], e[1]))
    cur = mx = 0
    for _, d in ev:
        cur += d
        mx = max(mx, cur)
    return mx


def dd_chiusure(pos):
    """Drawdown massimo (in R) della somma cumulata di r in ordine di CHIUSURA. Solo chiusure: ignora il
    flottante, quindi e' un LIMITE INFERIORE del drawdown di equity."""
    cum = pk = dd = 0.0
    for p in sorted(pos, key=lambda p: p["chiude"]):
        cum += p["r"]
        pk = max(pk, cum)
        dd = max(dd, pk - cum)
    return dd


def valuta(pos, scart, rng, n_perm=N_PERM):
    """delta = somma r dopo - somma r prima = -(somma r delle scartate). Nullo: k posizioni a caso."""
    k = len(scart)
    delta = -sum(p["r"] for p in scart)
    if k == 0:
        return {"k": 0, "delta": 0.0, "p": 1.0}
    rs = [p["r"] for p in pos]
    ge = 0
    for _ in range(n_perm):
        if -sum(rng.sample(rs, k)) >= delta - 1e-12:
            ge += 1
    return {"k": k, "delta": delta, "p": (ge + 1) / (n_perm + 1)}


def descr_set(scart):
    w = sum(1 for p in scart if p["netto"] > 0)
    return "%dV/%dP" % (w, len(scart) - w)


REGOLE = [
    ("cluster cap 2 non firmato", r_cluster(2, False)),
    ("cluster cap 2 firmato", r_cluster(2, True)),
    ("cluster cap 1 non firmato", r_cluster(1, False)),
    ("cluster cap 1 firmato", r_cluster(1, True)),
    ("stop pieno -> niente su valuta (non firm.)", r_stop_cluster(False)),
    ("stop pieno -> niente su valuta (firmato)", r_stop_cluster(True)),
    ("max aperte 3", r_max_aperte(3)),
    ("max aperte 2", r_max_aperte(2)),
    ("kill: 3 SL/giorno", r_kill(sl_giorno=3)),
    ("kill: 2 SL/giorno", r_kill(sl_giorno=2)),
    ("kill: 2 SL consecutivi", r_kill(consec=2)),
    ("kill: perdita giorno 1.5 R", r_kill(perdita_R=1.5)),
    ("kill: perdita giorno 1.0 R", r_kill(perdita_R=1.0)),
    ("max 1 apertura/simbolo/giorno", r_simbolo_giorno(1)),
]
assert len(REGOLE) == NREGOLE


def tabella_regole(nome, pos, rng):
    pos = ordina(pos)
    rs = [p["r"] for p in pos]
    print("\n--- %s: n %d, somma r %+.2f, PF(r) %.2f, wr %.0f%%, max aperte contemporanee %d ---"
          % (nome, len(pos), sum(rs), D.pf(rs), 100.0 * sum(1 for p in pos if p["netto"] > 0) / len(pos), max_concorrenza(pos)))
    print("%-44s %4s %5s %7s %9s %7s %s" % ("regola", "tolte", "%", "tolte", "delta R", "p", "lettura"))
    righe = []
    for nome_r, reg in REGOLE:
        acc, scart = simula(pos, reg)
        v = valuta(pos, scart, rng)
        if v["k"] == 0:
            lett = "nessun effetto (non scatta mai)"
        elif v["p"] < 0.05 / NREGOLE:
            lett = "p sotto Bonferroni: da CONFERMARE su altra fonte"
        elif v["p"] < 0.05:
            lett = "indizio (p<0.05, non corretto)"
        else:
            lett = "dentro il caso"
        print("%-44s %4d %4.0f%% %7s %+9.2f %7.3f %s" % (nome_r, v["k"], 100.0 * v["k"] / len(pos), descr_set(scart), v["delta"], v["p"], lett))
        righe.append((nome_r, v))
    return righe


# ------------------------------------------------------------------ (d) orario e giorno
def ora_bcm(p):
    """Apertura riportata all'ora BCM (UTC+1 fisso): fonte -> UTC -> BCM."""
    return p["apre"] + datetime.timedelta(hours=1 - p["off_utc"])


BLOCCHI = [("Asia 00-08", 0, 8), ("Europa 08-13", 8, 13), ("USA 13-17", 13, 17), ("sera 17-24", 17, 24)]


def etichetta_blocco(h):
    for n, a, b in BLOCCHI:
        if a <= h < b:
            return n
    return "?"


def dispersione(gruppi):
    tot = [v for g in gruppi.values() for v in g]
    m = sum(tot) / len(tot)
    return sum(len(g) * (sum(g) / len(g) - m) ** 2 for g in gruppi.values() if g)


def test_gruppi(etichette, valori, rng, n_perm=N_PERM):
    gr = collections.defaultdict(list)
    for e, v in zip(etichette, valori):
        gr[e].append(v)
    obs = dispersione(gr)
    ge = 0
    lab = list(etichette)
    for _ in range(n_perm):
        rng.shuffle(lab)
        g2 = collections.defaultdict(list)
        for e, v in zip(lab, valori):
            g2[e].append(v)
        if dispersione(g2) >= obs - 1e-12:
            ge += 1
    return gr, (ge + 1) / (n_perm + 1)


def sezione_orari(nome, pos, rng, chiusura=False):
    base = "CHIUSURA" if chiusura else "apertura"
    if chiusura:
        f = lambda p: p["chiude"] + datetime.timedelta(hours=1 - p["off_utc"])
    else:
        f = ora_bcm
    rs = [p["r"] for p in pos]
    print("\n--- (d) %s: n %d, per %s (ora BCM = UTC+1) ---" % (nome, len(pos), base))
    for titolo, key in (("blocco orario", lambda p: etichetta_blocco(f(p).hour)),
                        ("giorno settimana", lambda p: ["lun", "mar", "mer", "gio", "ven", "sab", "dom"][f(p).weekday()])):
        et = [key(p) for p in pos]
        gr, pv = test_gruppi(et, rs, rng)
        print("  %s (dispersione, permutazione): p = %.3f" % (titolo, pv))
        for k in sorted(gr):
            g = gr[k]
            print("    %-14s n %3d  media r %+.3f  somma r %+7.2f  PF %.2f" % (k, len(g), sum(g) / len(g), sum(g), D.pf(g)))


# ------------------------------------------------------------------ (e) concentrazione
def stat_worst(pos, etichette_fn, k):
    gr = collections.defaultdict(float)
    for p in pos:
        for e in etichette_fn(p):
            gr[e] += p["r"]
    return sum(sorted(gr.values())[:k]), gr


def sezione_concentrazione(nome, pos, rng, n_perm=N_PERM):
    print("\n--- (e) %s: n %d, concentrazione ---" % (nome, len(pos)))
    cnt = collections.Counter(p["sym"] for p in pos)
    tot = len(pos)
    top = cnt.most_common(3)
    print("  aperture: %d simboli diversi; top3 %s = %.0f%% delle aperture" % (len(cnt), top, 100.0 * sum(c for _, c in top) / tot))
    # nullo "uniforme sui simboli osservati": quanto vale il top1 per puro caso
    simboli = sorted(cnt)
    mx_null = []
    for _ in range(2000):
        c = collections.Counter(rng.choice(simboli) for _ in range(tot))
        mx_null.append(max(c.values()))
    p_top = (sum(1 for m in mx_null if m >= top[0][1]) + 1) / 2001.0
    print("  top1 = %d aperture su %d: P(max >= %d | uniforme su %d simboli) = %.3f (nullo debole: i simboli non sono equiprobabili)"
          % (top[0][1], tot, top[0][1], len(simboli), p_top))
    # perdita: peggiori 3 simboli e peggiore valuta, contro permutazione delle etichette
    simbs = [p["sym"] for p in pos]
    rs = [p["r"] for p in pos]
    obs_s, gr_s = stat_worst(pos, lambda p: [p["sym"]], 3)
    obs_c, gr_c = stat_worst(pos, lambda p: list(D.valute(p["sym"])), 1)
    ge_s = ge_c = 0
    lab = list(simbs)
    for _ in range(n_perm):
        rng.shuffle(lab)
        fk = [dict(p, sym=l) for p, l in zip(pos, lab)]
        if stat_worst(fk, lambda p: [p["sym"]], 3)[0] <= obs_s + 1e-12:
            ge_s += 1
        if stat_worst(fk, lambda p: list(D.valute(p["sym"])), 1)[0] <= obs_c + 1e-12:
            ge_c += 1
    peg = sorted(gr_s.items(), key=lambda kv: kv[1])[:3]
    pc = sorted(gr_c.items(), key=lambda kv: kv[1])[:3]
    print("  tre simboli peggiori: %s, somma %+.2f R; p(permutazione) = %.3f" % ([(k, round(v, 2)) for k, v in peg], obs_s, (ge_s + 1) / (n_perm + 1.0)))
    print("  valute peggiori (esposizione non firmata): %s; la peggiore %+.2f R; p(permutazione) = %.3f (la statistica e' il MINIMO fra le valute: la molteplicita' e' gia' dentro il p, nessun x8)"
          % ([(k, round(v, 2)) for k, v in pc], obs_c, (ge_c + 1) / (n_perm + 1.0)))


def sezione_ripetizioni(nome, pos):
    """H3: stesso simbolo+lato riaperto entro 40 ore dall'apertura precedente (proxy dello STESSO impulso
    ancora vivo; Lookback_Bars*2 = 40 barre H1). Descrittivo, non e' un filtro proposto."""
    by = collections.defaultdict(list)
    for p in ordina(pos):
        by[(p["sym"], p["lato"])].append(p)
    prime, rip = [], []
    for k, l in by.items():
        for i, p in enumerate(l):
            if i > 0 and (p["apre"] - l[i - 1]["apre"]).total_seconds() / 3600.0 <= 40:
                rip.append(p["r"])
            else:
                prime.append(p["r"])
    print("\n--- ripetizioni stesso simbolo+lato entro 40 h (%s, n %d) ---" % (nome, len(pos)))
    print("  prime/isolate n %d somma r %+.2f | ripetizioni n %d somma r %+.2f (descrittivo: n troppo piccolo per un test)" % (len(prime), sum(prime), len(rip), sum(rip)))


# ------------------------------------------------------------------ (f) costi: commissione e swap
def sezione_costi(nome, pos):
    """Scompone il netto in lordo + commissione + swap (in R). Il lordo e' netto - comm - swap. Descrittivo:
    NON simula una regola 'niente notte' (chiudere prima cambierebbe anche il lordo di quelle posizioni)."""
    n = len(pos)
    lordo = [(p["netto"] - p["comm"] - p["swap"]) / p["R"] for p in pos]
    cm = [p["comm"] / p["R"] for p in pos]
    sw = [p["swap"] / p["R"] for p in pos]
    netto = [p["r"] for p in pos]
    notte = [p for p in pos if p["apre"] and p["chiude"] and p["chiude"].date() != p["apre"].date()]
    print("  %-34s n %3d | lordo %+7.2f R | commissioni %+6.2f R | swap %+6.2f R | netto %+7.2f R | PF lordo %.2f -> netto %.2f | cambiano giorno server: %d"
          % (nome, n, sum(lordo), sum(cm), sum(sw), sum(netto), D.pf(lordo), D.pf(netto), len(notte)))


# ------------------------------------------------------------------ autotest
def _mk(sym, lato, ap, ch, r, motivo=None, giorno=1, R=100.0):
    a = datetime.datetime(2026, 10, giorno, 0, 0, 0) + datetime.timedelta(hours=ap)
    c = datetime.datetime(2026, 10, giorno, 0, 0, 0) + datetime.timedelta(hours=ch)
    if motivo is None:
        motivo = "sl" if r <= -0.9 else ("tp" if r > 0 else "altro")
    return D.nuova("fin", (sym, lato, ap), sym, lato, a, c, 1, r * R, R, motivo, "VIOLA", "x")


def autotest():
    ko = []

    def ok(cond, msg):
        print("  [%s] %s" % ("OK" if cond else "KO", msg))
        if not cond:
            ko.append(msg)

    rng = random.Random(SEME)
    # --- T1 cluster: risposta nota
    A = _mk("NZDUSD", 1, 10, 15, 0.3)   # +NZD -USD
    B = _mk("NZDJPY", 1, 11, 16, -1.0)  # +NZD -JPY
    C = _mk("EURUSD", 1, 11, 12, 0.2)   # +EUR -USD
    Dd = _mk("GBPNZD", -1, 12, 14, 0.4)  # -GBP +NZD
    E = _mk("NZDCHF", -1, 13, 14, 0.5)  # -NZD +CHF (verso opposto su NZD)
    pos = [A, B, C, Dd, E]
    acc, sc = simula(pos, r_cluster(1, False))
    ok([p["sym"] for p in acc] == ["NZDUSD"] and len(sc) == 4, "cluster cap1 non firmato: passa solo la prima (NZDUSD), tolte 4")
    acc, sc = simula(pos, r_cluster(1, True))
    ok(sorted(p["sym"] for p in acc) == ["NZDCHF", "NZDUSD"], "cluster cap1 firmato: passano NZDUSD e NZDCHF (short NZD non confligge con long NZD)")
    acc, sc = simula(pos, r_cluster(2, True))
    ok([p["sym"] for p in sc] == ["GBPNZD"], "cluster cap2 firmato: scartata solo la terza posizione long-NZD (GBPNZD short), got %s" % [p["sym"] for p in sc])
    # CONTRO-ESEMPIO 1: la regola firmata NON deve bloccare una copertura (short NZD con long NZD aperto)
    ok(E in simula([A, E], r_cluster(1, True))[0], "contro-esempio: la copertura (short NZD con long NZD aperto) NON e' bloccata dalla versione firmata")
    # --- T2 stop pieno -> niente sulla valuta stesso giorno, nuovo giorno libero
    P1 = _mk("AUDJPY", 1, 6, 9, -1.0)           # stop pieno chiuso alle 9
    P2 = _mk("AUDCAD", 1, 10, 12, 0.3)          # +AUD stessa direzione -> tolta
    P3 = _mk("AUDCAD", 1, 10, 12, 0.3, giorno=2)  # giorno dopo -> libera
    P4 = _mk("EURUSD", 1, 11, 12, 0.2)          # nessuna valuta in comune -> libera
    P5 = _mk("AUDNZD", -1, 11, 13, 0.2)         # -AUD: non firmato la blocca, firmato no
    acc, sc = simula([P1, P2, P3, P4, P5], r_stop_cluster(False))
    ok(sorted(p["sym"] + str(p["apre"].day) for p in sc) == ["AUDCAD1", "AUDNZD1"], "stop-cluster non firmato: tolte AUDCAD e AUDNZD del giorno 1")
    acc, sc = simula([P1, P2, P3, P4, P5], r_stop_cluster(True))
    ok(sorted(p["sym"] + str(p["apre"].day) for p in sc) == ["AUDCAD1"], "stop-cluster firmato: tolta solo AUDCAD (AUDNZD short AUD e' direzione opposta)")
    ok(P3 in acc and P4 in acc, "il giorno dopo e le valute estranee restano libere")
    # --- T3 max aperte
    acc, sc = simula([_mk("EURUSD", 1, 1, 5, 0.1), _mk("GBPUSD", 1, 2, 6, 0.1), _mk("USDJPY", 1, 3, 4, 0.1)], r_max_aperte(2))
    ok([p["sym"] for p in sc] == ["USDJPY"], "max aperte 2: la terza contemporanea e' tolta")
    ok(max_concorrenza([_mk("EURUSD", 1, 1, 5, 0.1), _mk("GBPUSD", 1, 2, 6, 0.1), _mk("USDJPY", 1, 3, 4, 0.1)]) == 3, "max concorrenza = 3")
    ok(max_concorrenza([_mk("EURUSD", 1, 1, 2, 0.1), _mk("GBPUSD", 1, 2, 3, 0.1)]) == 1, "chiusura e apertura allo stesso istante NON si sovrappongono")
    # --- T4 kill switch
    L = _mk("EURUSD", 1, 2, 9, -1.2)
    N = _mk("GBPUSD", 1, 10, 11, 0.2)
    ok(simula([L, N], r_kill(perdita_R=1.0))[1] == [N], "kill perdita 1.0 R: dopo -1.2 R niente di nuovo")
    ok(simula([L, N], r_kill(perdita_R=1.5))[1] == [], "kill perdita 1.5 R: soglia non toccata, nessun effetto")
    S1 = _mk("EURUSD", 1, 2, 5, -1.0)
    S2 = _mk("GBPUSD", 1, 3, 6, -1.0)
    W = _mk("AUDUSD", 1, 4, 7, 0.3)
    S3 = _mk("USDJPY", 1, 9, 10, 0.2)
    ok(simula([S1, S2, S3], r_kill(consec=2))[1] == [S3], "kill 2 SL consecutivi: S1,S2 chiusi in fila -> bloccata S3")
    ok(simula([S1, S2, W, S3], r_kill(consec=2))[1] == [], "contro-esempio: la vincita W (chiude alle 7, dopo S1 alle 5 e S2 alle 6) spezza la sequenza -> S3 passa")
    # --- T5 concentrazione per simbolo/giorno
    acc, sc = simula([_mk("EURNZD", 1, 1, 2, -1.0), _mk("EURNZD", 1, 4, 5, 0.3), _mk("EURNZD", 1, 4, 5, 0.3, giorno=2)], r_simbolo_giorno(1))
    ok(len(sc) == 1 and sc[0]["apre"].day == 1, "max 1/simbolo/giorno: la seconda dello stesso giorno e' tolta, il giorno dopo no")
    # --- T6 permutazione: risposta nota
    # (i) la regola toglie TUTTE e SOLE le perdenti -> delta grande, p piccolo
    pos = [_mk("EURUSD", 1, i, i + 1, -1.0 if i < 5 else 0.3, giorno=1 + i) for i in range(30)]
    scart = [p for p in pos if p["r"] < 0]
    v = valuta(pos, scart, rng, 5000)
    ok(v["delta"] > 4.9 and v["p"] < 0.01, "regola che toglie solo perdenti: delta %+.2f p %.4f (atteso p<0.01)" % (v["delta"], v["p"]))
    # (ii) CONTRO-ESEMPIO: toglie solo vincenti -> delta negativo, p ~ 1
    scart = [p for p in pos if p["r"] > 0][:5]
    v = valuta(pos, scart, rng, 5000)
    ok(v["delta"] < 0 and v["p"] > 0.9, "contro-esempio: toglie solo vincenti: delta %+.2f p %.3f (atteso p>0.9)" % (v["delta"], v["p"]))
    # (iii) tutti uguali -> delta 0, nessuna regola puo' sembrare utile
    pos = [_mk("EURUSD", 1, i, i + 1, 0.1, giorno=1 + i) for i in range(20)]
    v = valuta(pos, pos[:6], rng, 2000)
    ok(abs(v["delta"] + 0.6) < 1e-9 and v["p"] > 0.99, "dati tutti uguali: nessun effetto distinguibile (p %.3f)" % v["p"])
    # (iv) tasso di falsi positivi: su esiti CASUALI e regola 'cluster cap 1' il p e' sotto 0.05 al ~5% (<=15% ammesso)
    falsi, rip = 0, 40
    for _ in range(rip):
        pos = []
        for i in range(40):
            sym = rng.choice(["NZDUSD", "NZDJPY", "AUDNZD", "EURUSD", "GBPJPY", "AUDCAD"])
            ap = rng.randint(0, 200)
            r = -1.0 if rng.random() < 0.26 else 0.3
            pos.append(_mk(sym, rng.choice([1, -1]), ap % 24, ap % 24 + rng.randint(1, 12), r, giorno=1 + ap // 24))
        for p in pos:
            p["apre"] = datetime.datetime(2026, 10, 1) + datetime.timedelta(hours=rng.randint(0, 200))
            p["chiude"] = p["apre"] + datetime.timedelta(hours=rng.randint(1, 12))
        acc, sc = simula(pos, r_cluster(1, False))
        if valuta(pos, sc, rng, 400)["p"] < 0.05:
            falsi += 1
    ok(falsi / float(rip) <= 0.15, "falsi positivi su esiti casuali: %d/%d (atteso ~5%%, tetto 15%%)" % (falsi, rip))
    # --- T7 orari: etichette note
    ok(etichetta_blocco(7) == "Asia 00-08" and etichetta_blocco(8) == "Europa 08-13" and etichetta_blocco(23) == "sera 17-24", "blocchi orari: confini 7|8 e 23")
    q = _mk("EURUSD", 1, 6, 7, 0.1)
    q["off_utc"] = 3
    ok(ora_bcm(q).hour == 4, "FTMO UTC+3 -> BCM UTC+1: 06:00 diventa 04:00")
    print("AUTOTEST: %s" % ("TUTTO OK" if not ko else "FALLITI: %d" % len(ko)))
    return not ko


# ------------------------------------------------------------------ main
def main():
    if not autotest():
        print("autotest fallito: non leggo nessun dato")
        return 1
    if "--autotest" in sys.argv:
        return 0
    rng = random.Random(SEME)
    v520, ant = D.carica_bcm()
    trial = D.carica_trial()
    r92 = D.carica_r92bab()
    v520_v = [p for p in v520 if p["segnale"] == "VIOLA"]
    ant_v = [p for p in ant if p["segnale"] == "VIOLA"]
    print("\n=== FONTI (n VIOLA; R = unita' di rischio) ===")
    for nome, l in (("trial FTMO", trial), ("v520 piccolo", v520_v), ("antenato piccolo", ant_v), ("antenato TUTTI (BLU domina)", ant), ("R92BAB VIOLA", r92)):
        rs = [p["r"] for p in l]
        print("  %-28s n %3d  somma netto %10.2f  somma r %+7.2f  R %.2f  DD chiusure %.2f R (= %.1f%% a 0.8%% per R)" % (nome, len(l), sum(p["netto"] for p in l), sum(rs), l[0]["R"], dd_chiusure(l), 0.8 * dd_chiusure(l)))
    print("  [controllo] trial: somma netto 19 posizioni = %.2f (autopsia: -4925.49)" % sum(p["netto"] for p in trial))
    print("  [dispersione R] v520 SL: R=%.2f; trial R per posizione min %.0f max %.0f" % (v520[0]["R"], min(p["R"] for p in trial), max(p["R"] for p in trial)))
    print("\n##### (a)(b)(c)(e) REGOLE DI PORTAFOGLIO: richiedono apertura E chiusura -> trial, v520, antenato (NON R92BAB) #####")
    for nome, l in (("TRIAL FTMO (19, 3 istanze sommate, NON indipendente da v520)", trial),
                    ("V520 piccolo VIOLA (33, 30/09-07/10)", v520_v),
                    ("ANTENATO piccolo VIOLA (50, 01/04-08/06, primo tick)", ant_v),
                    ("ANTENATO TUTTI 297 (stress: BLU 238 occupa gli slot, NON e' il VIOLA)", ant)):
        tabella_regole(nome, l, rng)
    print("\n##### (d) ORARIO / GIORNO #####")
    sezione_orari("v520+antenato VIOLA (83, ora BCM; versioni diverse)", v520_v + ant_v, rng)
    sezione_orari("REPLICA: v520 piccolo VIOLA da solo (33, 30/09-07/10)", v520_v, rng)
    sezione_orari("REPLICA: antenato VIOLA da solo (50, 01/04-08/06)", ant_v, rng)
    print("  NB: i 4 blocchi orari sono stati fissati il 03/10 guardando l'antenato (297, BLU compreso): sull'antenato e' 'visto', non replicato.")
    sezione_orari("trial (19)", trial, rng)
    sezione_orari("R92BAB VIOLA (190)", r92, rng, chiusura=True)
    print("\n##### (f) COSTI SCOMPOSTI (commissione + swap, in R) #####")
    sezione_costi("v520 piccolo VIOLA", v520_v)
    sezione_costi("antenato piccolo VIOLA", ant_v)
    sezione_costi("antenato TUTTI (297)", ant)
    sezione_costi("trial FTMO", trial)
    print("  R92BAB: il per-trade ha un solo netto_profit (commissioni/swap non separati; -203,65 R92BAB_A fra per-trade e CSV non spiegati)")
    print("\n##### (e) CONCENTRAZIONE PER SIMBOLO / VALUTA #####")
    sezione_concentrazione("R92BAB VIOLA", r92, rng)
    sezione_concentrazione("v520 piccolo VIOLA", v520_v, rng)
    sezione_concentrazione("antenato VIOLA", ant_v, rng)
    sezione_concentrazione("trial", trial, rng)
    sezione_ripetizioni("v520", v520_v)
    sezione_ripetizioni("antenato VIOLA", ant_v)
    sezione_ripetizioni("trial", trial)
    print("\nNON SIMULABILE con questi dati: BE, trailing, parziale, time-stop, TP dinamico (nessun tracciato MFE/MAE);")
    print("regole sulle aperture in R92BAB (solo chiusura); perdita da evento (nessun calendario news nel repo).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
