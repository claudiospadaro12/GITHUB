#!/usr/bin/env python3
# =====================================================================
#  r248_bande_vergine.py -- R248, LA FINESTRA VERGINE. SOLA LETTURA.
# ---------------------------------------------------------------------
#  LA DOMANDA: su 2026.07.01 -> 2026.09.18 (58 feriali, mai letti da
#  nessun round di questi due EA), il RISCHIO delle due celle e' quello
#  promesso dal loro contratto? Con ~44 posizioni (cella R245) e ~20
#  (770202) la finestra giudica il RISCHIO (Emendamento B), NON il
#  merito: il PF si stampa e NON decide.
#
#  COSA FA, in tre modi:
#   --bande   le BANDE ATTESE, per bootstrap a blocchi del per-trade di
#             contratto (R247b 765273 per la cella R245; 772505 per
#             770202), proiettate sui feriali della finestra vergine:
#             numero di POSIZIONI, DD del SALDO CHIUSO, peggior giornata,
#             PF (solo informativo). Seme fisso. Da qui escono i numeri
#             CONGELATI nei file prova R248a/R248b.
#   --g0      la banda d'ARROTONDAMENTO del lotto per il cancello G0
#             della gamba IS (2025.07.01 -> 2026.06.30, che rifa' la
#             gamba OOS di R247b / un pezzo di 772505 a deposito 100000).
#   --leggi   la LETTURA CONGELATA del per-trade vergine: cancello dati,
#             n, DD, peggior giornata, PF, e il RAMO (vedi RAMI sotto).
#   --autotest  i contro-esempi (sotto). Esce 1 se uno fallisce.
#
#  CONVENZIONI, dichiarate:
#   - UNITA': la POSIZIONE (position_id). 770202 fa il parziale al TP1:
#     2 deal per posizione. La colonna Trades del CSV conta i DEAL
#     (classe 454).
#   - GIORNO = data di chiusura (ora server BCM): sedie intraday, una
#     posizione al giorno (InpOneTradePerDay=1). Lo script lo CONTROLLA.
#   - RENDIMENTO della posizione = netto della posizione / saldo prima
#     della sua prima chiusura, sul saldo della propria tranche.
#   - DD = DD del SALDO CHIUSO, capitalizzato, dal saldo iniziale (il
#     tester fa ripartire ogni gamba dal deposito). E' un MINORANTE
#     dell'Equity DD % del tester (R247b: 5,94 contro 6,86).
#   - FERIALI: lun-ven, festivi USA COMPRESI in tutte e due le serie
#     (sorgente e finestra): nessuna delle due li toglie, quindi la
#     proporzione e' la stessa (sorgente ~10 su 260, finestra 2 su 58).
#   - FINE ESCLUSIVA DEL TESTER: il log dice "to 2026.06.30 00:00" e su
#     94 per-trade del repo ZERO chiusure cadono il 2026.06.30 (25 file
#     ne hanno il 06.29). Quindi la sorgente R247b finisce il 06.29
#     compreso, e la finestra vergine si chiude con @FINOA 2026.09.19
#     (sabato): se la fine e' esclusiva, venerdi' 18 e' dentro; se fosse
#     inclusiva, il sabato non ha mercato. La scelta regge in tutti e due
#     i casi.
#   - BOOTSTRAP: a blocchi circolari di 5 feriali (una settimana), per
#     conservare il raggruppamento delle perdite; 20000 repliche, seme
#     248. Si stampa anche l'iid (blocco 1) come sensibilita'.
#
#  RAMI (congelati qui E nel file prova, cambiati NELLO STESSO COMMIT):
#   G-DATI ROSSO  se una settimana PIENA (lun-ven dentro la finestra) non
#                 ha nessuna posizione della cella R245, o l'ultima
#                 chiusura e' prima del 2026.09.14. Nel contratto R247b:
#                 0 settimane vuote su 53, buco massimo 4 feriali. Si
#                 guarda solo sulla cella R245 (stesso simbolo, stesso
#                 feed della 770202, che entra troppo poco per dirlo).
#   FREQUENZA     n posizioni fuori [p2,5 ; p97,5] -> FREQ FUORI BANDA:
#                 prima si sospetta il BANCO (dati, orologio, binario),
#                 non il mercato; il ramo del DD si scrive ma e' SOSPESO
#                 finche' la causa non e' trovata.
#   DD            DD chiuso <= p95          -> RISCHIO COERENTE
#                 p95 < DD chiuso <= p99    -> RISCHIO SOPRA BANDA
#                 DD chiuso > p99           -> RISCHIO FUORI CONTRATTO
#   PF            si stampa, NON decide (n piccolo).
#
#  USO
#    python3 backtest_pipeline/r248_bande_vergine.py --autotest
#    python3 backtest_pipeline/r248_bande_vergine.py --bande
#    python3 backtest_pipeline/r248_bande_vergine.py --g0
#    python3 backtest_pipeline/r248_bande_vergine.py --leggi R245 \
#        <abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765281.csv> 100000
#    python3 backtest_pipeline/r248_bande_vergine.py --leggi 770202 \
#        <abtg_trades_ABTG_Dow_Apertura_US_U30USD_765283.csv> 100000
# =====================================================================
from __future__ import annotations

import argparse
import csv
import datetime as dt
import math
import os
import random
import sys

QUI = os.path.dirname(os.path.abspath(__file__))

SEME = 248
REPLICHE = 20000
BLOCCO = 5

VERGINE_DA = dt.date(2026, 7, 1)
VERGINE_A = dt.date(2026, 9, 18)      # compreso (@FINOA 2026.09.19, fine esclusiva)
ULTIMA_SETTIMANA = dt.date(2026, 9, 14)

# Le due celle. "da"/"a" = feriali della SORGENTE, estremi compresi.
CELLE = {
    "R245": {
        "nome": "cella centrale R245b (ABTG_Nasdaq_Apertura_US, EmaSlow 200, TP 0,50, due lati)",
        "pertrade": os.path.join(QUI, "risultati_archivio", "R247", "PERTRADE",
                                 "abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765273.csv"),
        "deposito": 10000.0,
        "da": dt.date(2025, 7, 1), "a": dt.date(2026, 6, 29),
        "dd_contratto_chiuso": 5.9447, "dd_contratto_equity": 6.8640,
    },
    "770202": {
        "nome": "sedia viva 770202 (ABTG_Dow_Apertura_US, cella R47c 772505)",
        "pertrade": os.path.join(QUI, "risultati_prove", "aperture_r47",
                                 "abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv"),
        "deposito": 100000.0,
        "da": dt.date(2025, 6, 10), "a": dt.date(2026, 6, 29),
        "dd_contratto_chiuso": None, "dd_contratto_equity": 4.3941,
    },
}

# G0 della gamba IS di R248 (2025.07.01 -> 2026.06.30, deposito 100000).
G0_DA = dt.date(2025, 7, 1)
G0_DEPOSITO = 100000.0
LOT_STEP = 0.1          # misurato: tutti i volumi dei due per-trade sono multipli di 0,1
LOT_MAX = 100.0         # SYMBOL_VOLUME_MAX U30USD (R114 GSPEC)


# ---------------------------------------------------------------------
#  lettura
# ---------------------------------------------------------------------
def leggi_deal(percorso):
    righe = []
    with open(percorso, newline="", encoding="ascii", errors="replace") as fh:
        for r in csv.DictReader(fh, delimiter=";"):
            righe.append({
                "t": dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S"),
                "pid": r["position_id"],
                "tipo": int(r["deal_type"]),
                "vol": float(r["volume"]),
                "net": float(r["net_profit"]),
            })
    righe.sort(key=lambda x: x["t"])
    return righe


def posizioni(deal, deposito):
    """Lista di posizioni in ordine di prima chiusura:
    {giorno, ret, net, vols, nets}. Il saldo avanza deal per deal."""
    per = {}
    ordine = []
    saldo = deposito
    for d in deal:
        if d["pid"] not in per:
            per[d["pid"]] = {"giorno": d["t"].date(), "saldo0": saldo, "net": 0.0,
                             "vols": [], "nets": [], "giorni": set()}
            ordine.append(d["pid"])
        p = per[d["pid"]]
        p["net"] += d["net"]
        p["vols"].append(d["vol"])
        p["nets"].append(d["net"])
        p["giorni"].add(d["t"].date())
        saldo += d["net"]
    out = []
    for pid in ordine:
        p = per[pid]
        p["ret"] = p["net"] / p["saldo0"]
        out.append(p)
    return out


def feriali(da, a):
    out = []
    d = da
    while d <= a:
        if d.weekday() < 5:
            out.append(d)
        d += dt.timedelta(days=1)
    return out


def serie_feriale(pos, da, a):
    """Per ogni feriale: (entra, rendimento). Controlla una posizione al giorno."""
    per_giorno = {}
    for p in pos:
        if len(p["giorni"]) != 1:
            raise SystemExit("posizione chiusa su piu' giorni: l'unita' 'giorno' non regge")
        g = p["giorno"]
        if g in per_giorno:
            raise SystemExit("due posizioni lo stesso giorno (" + str(g) + "): l'unita' non regge")
        per_giorno[g] = p["ret"]
    fuori = [g for g in per_giorno if not (da <= g <= a) or g.weekday() >= 5]
    if fuori:
        raise SystemExit("posizioni fuori dai feriali della sorgente: " + str(sorted(fuori)[:5]))
    return [(g in per_giorno, per_giorno.get(g, 0.0)) for g in feriali(da, a)]


# ---------------------------------------------------------------------
#  metriche di un percorso
# ---------------------------------------------------------------------
def metriche(percorso):
    """percorso = lista (entra, ret). DD del saldo chiuso capitalizzato."""
    saldo = 1.0
    picco = 1.0
    dd = 0.0
    n = 0
    vinc = 0.0
    perd = 0.0
    peggiore = 0.0
    for entra, r in percorso:
        if not entra:
            continue
        n += 1
        saldo *= (1.0 + r)
        picco = max(picco, saldo)
        dd = max(dd, (picco - saldo) / picco)
        if r > 0:
            vinc += r
        else:
            perd += -r
        peggiore = min(peggiore, r)
    pf = (vinc / perd) if perd > 0 else float("inf")
    return {"n": n, "dd": dd * 100.0, "pf": pf, "ret": (saldo - 1.0) * 100.0,
            "peggiore": peggiore * 100.0}


def bootstrap(serie, lunghezza, blocco, repliche, seme):
    rnd = random.Random(seme)
    L = len(serie)
    out = []
    nb = int(math.ceil(lunghezza / float(blocco)))
    for _ in range(repliche):
        perc = []
        for _b in range(nb):
            s = rnd.randrange(L)
            for k in range(blocco):
                perc.append(serie[(s + k) % L])
        out.append(metriche(perc[:lunghezza]))
    return out


def quantile(valori, q):
    v = sorted(valori)
    if not v:
        return float("nan")
    pos = q * (len(v) - 1)
    i = int(math.floor(pos))
    j = min(i + 1, len(v) - 1)
    return v[i] + (v[j] - v[i]) * (pos - i)


def bande_di(serie, lunghezza, blocco=BLOCCO, repliche=REPLICHE, seme=SEME):
    b = bootstrap(serie, lunghezza, blocco, repliche, seme)
    n = [x["n"] for x in b]
    dd = [x["dd"] for x in b]
    pf = [x["pf"] for x in b if math.isfinite(x["pf"])]
    pg = [x["peggiore"] for x in b]
    ret = [x["ret"] for x in b]
    return {
        "n_p025": quantile(n, 0.025), "n_p50": quantile(n, 0.50), "n_p975": quantile(n, 0.975),
        "dd_p50": quantile(dd, 0.50), "dd_p90": quantile(dd, 0.90),
        "dd_p95": quantile(dd, 0.95), "dd_p99": quantile(dd, 0.99),
        "pf_p05": quantile(pf, 0.05), "pf_p50": quantile(pf, 0.50), "pf_p95": quantile(pf, 0.95),
        "pg_p05": quantile(pg, 0.05), "pg_p01": quantile(pg, 0.01),
        "ret_p05": quantile(ret, 0.05), "ret_p50": quantile(ret, 0.50), "ret_p95": quantile(ret, 0.95),
        "dd_tutti": dd, "n_tutti": n,
    }


def serie_cella(chiave):
    c = CELLE[chiave]
    pos = posizioni(leggi_deal(c["pertrade"]), c["deposito"])
    return serie_feriale(pos, c["da"], c["a"]), pos


def estate_usa(d):
    """Ora legale USA: la cash alle 14:30 server BCM (UTC+1 fisso)."""
    def domenica(anno, mese, n):
        x = dt.date(anno, mese, 1)
        x += dt.timedelta(days=(6 - x.weekday()) % 7)
        return x + dt.timedelta(weeks=n - 1)
    return domenica(d.year, 3, 2) <= d < domenica(d.year, 11, 1)


# ---------------------------------------------------------------------
#  i rami
# ---------------------------------------------------------------------
def ramo(n, dd, b):
    freq_ok = b["n_p025"] <= n <= b["n_p975"]
    if dd <= b["dd_p95"]:
        rdd = "RISCHIO COERENTE"
    elif dd <= b["dd_p99"]:
        rdd = "RISCHIO SOPRA BANDA"
    else:
        rdd = "RISCHIO FUORI CONTRATTO"
    if not freq_ok:
        return "FREQ FUORI BANDA (DD: " + rdd + ", SOSPESO finche' la causa non e' trovata)"
    return rdd


def g_dati(pos_vergine):
    giorni = sorted(set(p["giorno"] for p in pos_vergine))
    if not giorni:
        return False, "nessuna posizione nella finestra"
    vuote = []
    lun = VERGINE_DA + dt.timedelta(days=(7 - VERGINE_DA.weekday()) % 7)
    while lun + dt.timedelta(days=4) <= VERGINE_A:
        sett = [lun + dt.timedelta(days=k) for k in range(5)]
        if not any(g in giorni for g in sett):
            vuote.append(lun)
        lun += dt.timedelta(days=7)
    msg = ("settimane piene vuote: " + str(len(vuote))
           + (" " + str([str(v) for v in vuote]) if vuote else "")
           + " | ultima chiusura " + str(giorni[-1]) + " | prima " + str(giorni[0]))
    ok = (not vuote) and giorni[-1] >= ULTIMA_SETTIMANA
    return ok, msg


# ---------------------------------------------------------------------
#  G0: banda d'arrotondamento del lotto (gamba IS a deposito 100000)
# ---------------------------------------------------------------------
def banda_g0(chiave, repliche=2000, seme=SEME):
    """Simula la stessa sequenza di posizioni a G0_DEPOSITO: il lotto
    ideale u sta in [v, v+step) (CalcLotByRisk fa MathFloor, r.2069);
    a saldo diverso il lotto e' floor(u * S_nuovo/S_vecchio). Col
    parziale (770202, 2 deal) il primo deal chiude floor(V*quota) e il
    secondo il resto. P/L per lotto di ogni deal = netto / volume."""
    c = CELLE[chiave]
    deal = leggi_deal(c["pertrade"])
    pos = posizioni(deal, c["deposito"])
    pos = [p for p in pos if p["giorno"] >= G0_DA]
    n_deal = sum(len(p["vols"]) for p in pos)
    rif_profit = sum(p["net"] for p in pos)
    rnd = random.Random(seme)
    pf_l, pr_l = [], []
    for _ in range(repliche):
        s_new = G0_DEPOSITO
        vinc = perd = 0.0
        for p in pos:
            V = sum(p["vols"])
            u = V + rnd.random() * LOT_STEP
            Vn = math.floor(u * (s_new / p["saldo0"]) / LOT_STEP + 1e-9) * LOT_STEP
            Vn = min(Vn, LOT_MAX)
            if len(p["vols"]) == 1:
                vols_n = [Vn]
            else:
                quota = p["vols"][0] / V
                v1 = math.floor(Vn * quota / LOT_STEP + 1e-9) * LOT_STEP
                vols_n = [v1] + [Vn - v1] * (len(p["vols"]) - 1)
            for vo, vn, ne in zip(p["vols"], vols_n, p["nets"]):
                x = (ne / vo) * vn
                s_new += x
                if x > 0:
                    vinc += x
                else:
                    perd += -x
        pf_l.append(vinc / perd if perd > 0 else float("inf"))
        pr_l.append(s_new - G0_DEPOSITO)
    return {"n_deal": n_deal, "n_pos": len(pos), "profit_rif": rif_profit,
            "pf_lo": quantile(pf_l, 0.001), "pf_hi": quantile(pf_l, 0.999),
            "pr_lo": quantile(pr_l, 0.001), "pr_hi": quantile(pr_l, 0.999),
            "pf_med": quantile(pf_l, 0.5)}


# ---------------------------------------------------------------------
#  stampa
# ---------------------------------------------------------------------
def stampa_bande(chiave):
    serie, pos = serie_cella(chiave)
    c = CELLE[chiave]
    Lv = len(feriali(VERGINE_DA, VERGINE_A))
    npos = sum(1 for e, _ in serie if e)
    print("=== " + chiave + " -- " + c["nome"])
    print("  sorgente: " + os.path.relpath(c["pertrade"], os.path.dirname(QUI)))
    print("  feriali sorgente " + str(len(serie)) + " (" + str(c["da"]) + " -> " + str(c["a"])
          + "), posizioni " + str(npos) + ", tasso " + "%.4f" % (npos / float(len(serie)))
          + " | feriali finestra vergine " + str(Lv) + " -> n atteso "
          + "%.1f" % (npos / float(len(serie)) * Lv))
    m = metriche(serie)
    print("  controllo: DD saldo chiuso sull'intera sorgente %.4f%% (contratto chiuso %s, equity %.4f%%)"
          % (m["dd"], ("%.4f%%" % c["dd_contratto_chiuso"]) if c["dd_contratto_chiuso"] else "[non scritto]",
             c["dd_contratto_equity"]))
    for nome, blocco in (("BLOCCHI DA 5 (PRIMARIA)", BLOCCO), ("iid (sensibilita')", 1)):
        b = bande_di(serie, Lv, blocco=blocco)
        print("  -- " + nome + ", " + str(REPLICHE) + " repliche, seme " + str(SEME))
        print("     posizioni  p2,5 %.0f | p50 %.0f | p97,5 %.0f" % (b["n_p025"], b["n_p50"], b["n_p975"]))
        print("     DD chiuso  p50 %.2f%% | p90 %.2f%% | p95 %.2f%% | p99 %.2f%%"
              % (b["dd_p50"], b["dd_p90"], b["dd_p95"], b["dd_p99"]))
        print("     peggior posizione p5 %.2f%% | p1 %.2f%%" % (b["pg_p05"], b["pg_p01"]))
        print("     PF (NON decide) p5 %.2f | p50 %.2f | p95 %.2f" % (b["pf_p05"], b["pf_p50"], b["pf_p95"]))
        print("     rendimento  p5 %.2f%% | p50 %.2f%% | p95 %.2f%%" % (b["ret_p05"], b["ret_p50"], b["ret_p95"]))
    est = [x for x, g in zip(serie, feriali(c["da"], c["a"])) if estate_usa(g)]
    if est:
        b = bande_di(est, Lv)
        ne = sum(1 for e, _ in est if e)
        me = metriche(est)
        print("  -- SOLO MESI D'ESTATE USA della sorgente (cash alle 14:30 server, come la finestra"
              " vergine): INFORMATIVA, non decide")
        print("     feriali " + str(len(est)) + ", posizioni " + str(ne) + ", PF %.3f" % me["pf"])
        print("     posizioni  p2,5 %.0f | p50 %.0f | p97,5 %.0f" % (b["n_p025"], b["n_p50"], b["n_p975"]))
        print("     DD chiuso  p50 %.2f%% | p95 %.2f%% | p99 %.2f%% | PF p50 %.2f"
              % (b["dd_p50"], b["dd_p95"], b["dd_p99"], b["pf_p50"]))
    bc = bande_congelate(chiave)
    print("  >>> BANDE CONGELATE (decidono): posizioni %.0f - %.0f (estate) | DD chiuso p95 %.2f%%"
          " p99 %.2f%% (anno intero)" % (bc["n_p025"], bc["n_p975"], bc["dd_p95"], bc["dd_p99"]))
    print()


def stampa_g0():
    for chiave in ("R245", "770202"):
        g = banda_g0(chiave)
        print("=== G0 " + chiave + ": gamba IS 2025.07.01 -> 2026.06.30 a deposito %.0f" % G0_DEPOSITO)
        print("  riferimento (per-trade di contratto, chiusure dal 2025.07.01): "
              + str(g["n_deal"]) + " deal, " + str(g["n_pos"]) + " posizioni, somma "
              + "%.2f al deposito del contratto" % g["profit_rif"])
        print("  banda d'arrotondamento (2000 simulazioni, p0,1-p99,9): PF %.4f - %.4f (mediana %.4f)"
              " | Profit %.0f - %.0f" % (g["pf_lo"], g["pf_hi"], g["pf_med"], g["pr_lo"], g["pr_hi"]))
        print()


def bande_congelate(chiave):
    """LE BANDE CHE DECIDONO, e da dove vengono (scelta fatta PRIMA dei
    numeri, scritta anche nel file prova):
     - DD e peggior posizione: bootstrap a blocchi dell'INTERO per-trade
       di contratto = la promessa (criterio del 18/08: DD promesso dal
       backtest della cella promossa).
     - FREQUENZA: bootstrap a blocchi dei soli feriali d'ESTATE USA della
       sorgente. La finestra vergine e' TUTTA estate (cash alle 14:30
       server) e R246 ha misurato che sul Dow l'orario sposta la
       frequenza: la banda di tutto l'anno darebbe falsi allarmi.
    """
    c = CELLE[chiave]
    serie, _ = serie_cella(chiave)
    Lv = len(feriali(VERGINE_DA, VERGINE_A))
    b = bande_di(serie, Lv)
    est = [x for x, g in zip(serie, feriali(c["da"], c["a"])) if estate_usa(g)]
    be = bande_di(est, Lv)
    b["n_p025"], b["n_p50"], b["n_p975"] = be["n_p025"], be["n_p50"], be["n_p975"]
    return b


def leggi(chiave, percorso, deposito):
    Lv = len(feriali(VERGINE_DA, VERGINE_A))
    b = bande_congelate(chiave)
    pos = posizioni(leggi_deal(percorso), deposito)
    fuori = [p["giorno"] for p in pos if not (VERGINE_DA <= p["giorno"] <= VERGINE_A)]
    print("=== LETTURA R248 " + chiave + ": " + os.path.basename(percorso) + " @ %.0f" % deposito)
    if fuori:
        print("  ROSSO: " + str(len(fuori)) + " posizioni FUORI dalla finestra vergine (prima: "
              + str(min(fuori)) + "): il per-trade NON e' quello della gamba OOS")
        return 1
    serie = serie_feriale(pos, VERGINE_DA, VERGINE_A)
    m = metriche(serie)
    ok, msg = g_dati(pos)
    print("  G-DATI: " + ("VERDE" if ok else "ROSSO") + " -- " + msg
          + ("" if chiave == "R245" else "  (per 770202 SOLO INFORMATIVO)"))
    print("  posizioni %d  (banda %.0f - %.0f)" % (m["n"], b["n_p025"], b["n_p975"]))
    print("  DD saldo chiuso %.2f%%  (p95 %.2f%% | p99 %.2f%%)" % (m["dd"], b["dd_p95"], b["dd_p99"]))
    print("  peggior posizione %.2f%% | rendimento %.2f%% | PF %.3f  <- il PF NON decide"
          % (m["peggiore"], m["ret"], m["pf"]))
    c = CELLE[chiave]
    rif = c["dd_contratto_chiuso"] or metriche(serie_cella(chiave)[0])["dd"]
    print("  riferimento 18/08 (NON un ramo): DD chiuso di contratto sull'anno %.2f%% -> la"
          " finestra %s" % (rif, "lo SUPERA" if m["dd"] > rif else "resta sotto"))
    if chiave == "R245" and not ok:
        print("  RAMO: NON LEGGIBILE (G-DATI ROSSO): prima i dati, poi il rischio")
        return 2
    print("  RAMO: " + ramo(m["n"], m["dd"], b))
    return 0


# ---------------------------------------------------------------------
#  autotest: i contro-esempi
# ---------------------------------------------------------------------
def autotest():
    esiti = []

    def ok(nome, cond, det=""):
        esiti.append(cond)
        print(("  PASS " if cond else "  FAIL ") + nome + ((" -- " + det) if det else ""))

    serie, pos = serie_cella("R245")
    Lv = len(feriali(VERGINE_DA, VERGINE_A))
    ok("feriali della finestra vergine = 58", Lv == 58, str(Lv))
    ok("sorgente R247b: 197 posizioni su 260 feriali",
       sum(1 for e, _ in serie if e) == 197 and len(serie) == 260)
    m = metriche(serie)
    ok("DD chiuso della sorgente = 5,9447% (lettura R247, altro script)", abs(m["dd"] - 5.9447) < 0.001,
       "%.4f" % m["dd"])
    b1 = bande_di(serie, Lv, repliche=4000)
    b2 = bande_di(serie, Lv, repliche=4000)
    ok("T1 determinismo: stesso seme -> stesse bande",
       b1["dd_p95"] == b2["dd_p95"] and b1["n_p025"] == b2["n_p025"])
    b = bande_congelate("R245")
    # T2 contro-esempio letterale: DD doppio del contratto
    ok("T2 serie con DD = 2 x contratto chiuso (11,89%) -> SOPRA p99",
       ramo(44, 2 * 5.9447, b) == "RISCHIO FUORI CONTRATTO", ramo(44, 2 * 5.9447, b))
    # T3 LA POTENZA, MISURATA E NON ASSERITA (contro-esempio forte, classe
    # 178): la STESSA sorgente a rischio x1,5 / x2 / x3 (ogni rendimento
    # moltiplicato) -> in quante finestre da 58 feriali il DD esce sopra
    # il p95 del nullo? Prima stesura: "PASS se la mediana x2 > p95" --
    # passava per 0,01 punti (7,32 contro 7,31), cioe' per caso del seme.
    # Un test che passa sul filo non e' un test: e' una misura, e si
    # stampa come tale. La conseguenza sta nel file prova (par. 6).
    for k in (1.5, 2.0, 3.0):
        serie_k = [(e, k * r) for e, r in serie]
        b_k = bootstrap(serie_k, Lv, BLOCCO, 4000, SEME + 1)
        pot95 = sum(1 for x in b_k if x["dd"] > b["dd_p95"]) / float(len(b_k))
        pot99 = sum(1 for x in b_k if x["dd"] > b["dd_p99"]) / float(len(b_k))
        print("  MISURA T3 potenza a rischio x%.1f: DD mediano %.2f%% | finestre sopra p95 %.1f%%"
              " | sopra p99 %.1f%%" % (k, quantile([x["dd"] for x in b_k], 0.5), 100 * pot95, 100 * pot99))
    # T4 la sorgente stessa, al suo DD mediano, sta DENTRO
    ok("T4 una finestra al DD mediano del nullo -> RISCHIO COERENTE",
       ramo(44, b["dd_p50"], b) == "RISCHIO COERENTE")
    # T5 frequenza dimezzata -> fuori banda; frequenza attesa -> dentro
    ok("T5a frequenza dimezzata (22) -> FREQ FUORI BANDA", ramo(22, 1.0, b).startswith("FREQ FUORI"))
    ok("T5b frequenza attesa (44) -> dentro", not ramo(44, 1.0, b).startswith("FREQ FUORI"))
    # T6 G-DATI: un per-trade tagliato al 31/08 (feed troncato) -> ROSSO
    finto = [{"giorno": g} for g in feriali(VERGINE_DA, dt.date(2026, 8, 31))[::2]]
    okd, msgd = g_dati(finto)
    ok("T6 feed troncato al 31/08 -> G-DATI ROSSO", not okd, msgd)
    finto2 = [{"giorno": g} for g in feriali(VERGINE_DA, VERGINE_A)[::2]]
    okd2, _ = g_dati(finto2)
    ok("T6b feed intero, un feriale su due -> G-DATI VERDE", okd2)
    # T7 G0: l'anno SBAGLIATO (R247a, tranche IS) ha un n diverso: 154 != 197
    g = banda_g0("R245", repliche=300)
    ok("T7 G0 R245: la gamba IS attesa ha 197 deal (R247a ne ha 154: l'anno sbagliato non passa)",
       g["n_deal"] == 197, str(g["n_deal"]))
    ok("T7b G0 R245: il PF del contratto a 10000 (1,48894) sta nella banda a 100000",
       g["pf_lo"] <= 1.48894 <= g["pf_hi"],
       "banda %.4f - %.4f" % (g["pf_lo"], g["pf_hi"]))
    g2 = banda_g0("770202", repliche=300)
    ok("T8 G0 770202: 123 deal / 91 posizioni dal 2025.07.01 (R247 li conta: 91 dei 96 giorni)",
       g2["n_deal"] == 123 and g2["n_pos"] == 91, "%d deal, %d posizioni" % (g2["n_deal"], g2["n_pos"]))
    print()
    print("AUTOTEST: " + ("TUTTO PASS" if all(esiti) else "FALLITO") + " (" + str(sum(esiti)) + "/"
          + str(len(esiti)) + ")")
    return 0 if all(esiti) else 1


def main():
    ap = argparse.ArgumentParser(description="R248: bande attese e lettura della finestra vergine")
    ap.add_argument("--autotest", action="store_true")
    ap.add_argument("--bande", action="store_true")
    ap.add_argument("--g0", action="store_true")
    ap.add_argument("--leggi", nargs=3, metavar=("CELLA", "PERTRADE", "DEPOSITO"))
    a = ap.parse_args()
    if a.autotest:
        return autotest()
    if a.bande:
        for k in ("R245", "770202"):
            stampa_bande(k)
        return 0
    if a.g0:
        stampa_g0()
        return 0
    if a.leggi:
        if a.leggi[0] not in CELLE:
            print("cella sconosciuta: " + a.leggi[0] + " (R245 | 770202)")
            return 1
        return leggi(a.leggi[0], a.leggi[1], float(a.leggi[2]))
    ap.print_help()
    return 1


if __name__ == "__main__":
    sys.exit(main())
