#!/usr/bin/env python3
# =====================================================================
#  sim_bulge_viola_orario.py -- SOLA LETTURA. Domanda di Claudio (08/10/2026):
#  "valutiamo anche un discorso legato all'orario giornaliero e/o notturno".
#  NON propone di restringere l'entrata del VIOLA: misura la FRONTIERA
#  qualita'/frequenza di ogni fascia (quota di segnali trattenuta contro delta di R).
#
#  ORA DI OGNI NUMERO: SERVER BCM = UTC+1 FISSO (misurato il 24/09). D'estate IT = BCM + 1
#  (i log Esperti del VPS sono in ora IT), d'inverno IT = BCM. Il trial FTMO (UTC+3 d'estate)
#  e' riportato a BCM. TUTTE le posizioni di questo script sono estive (apr-giu, 30/09-06/10):
#  le fasce valgono per l'estate; il cambio d'ora (25/10, 02/11) sposta di un'ora il rollover.
#  ORA CHE CONTA: l'ora di APERTURA = ora d'ingresso (primo tick della barra H1 dopo il segnale).
#  Con Signal_Bar_Offset=1 (v5.20) la barra di CONFERMA e' quella PRECEDENTE (ora d'ingresso - 1):
#  una fascia "per ora d'ingresso h" e' una fascia "per barra di conferma h-1". L'antenato (primo
#  tick, offset 0) entra alla stessa ora di apertura della barra letta.
#
#  FASCE FISSATE A PRIORI (08/10/2026, PRIMA di ricalcolare, sulla struttura dei mercati e non sui
#  risultati; l'ex-post "08-13" del 03/10 NON e' una fascia di questo script). Ore d'INGRESSO BCM:
#     F1 notte/asia          00-08  (23-07 UTC)
#     F2 europa mattina      08-12  (07-11 UTC)
#     F3 pausa               12-14  (11-13 UTC)
#     F4 apertura USA        14-17  (13-16 UTC; i dati USA delle 12:30 UTC cadono in F3: dichiarato)
#     F5 pomeriggio USA      17-22  (16-21 UTC)
#     F6 rollover            22-24  (21-23 UTC)
#  CLASSI DI CROSS a priori (priorita' JPY > AUD/NZD > EUR/GBP > altri): JPY = contiene JPY;
#  AUD/NZD = contiene AUD o NZD; EUR/GBP = contiene EUR o GBP; ALTRI = USDCAD, USDCHF, CADCHF, ...
#
#  ATTESE scritte PRIMA dei numeri (08/10/2026; viste le quote orarie grezze del 03/10 ma NON
#  il risultato per queste fasce, e il blocco ex-post 08-13 coincide con F2+meta' di F3):
#   quota di ingressi attesa: F1 20-30%, F2 15-25%, F3 5-12%, F4 10-18%, F5 20-30%, F6 3-10%.
#   Qualita': nessuna fascia distinguibile dal caso nel campione DISGIUNTO (v520 contro antenato):
#   |r medio fascia - r medio pool| < 0,30 R e p > 0,0083 (=0,05/6) in almeno 5 fasce su 6.
#   ROLLOVER: spread mediano alle 22-23 BCM >= 5 volte quello delle altre ore (misurato sui 3 maggiori
#   dal logger del 04-11/09) e quindi fuori dalla frontiera del costo 40x per SL = 3 ATR.
#   H-O2 (asia e cross JPY/AUD-NZD): r medio di (JPY + AUD/NZD) in F1 >= +0,15 R sopra (EUR/GBP + ALTRI) in F1.
#   ALTERNATIVA (nessun effetto di classe): differenza entro +-0,25 R (errore standard della
#   differenza con ~10 posizioni per cella: 0,25 R) -> NON si distingue.
#  SOGLIE CONGELATE: una fascia e' "indizio" se p(una coda, rimozione casuale) < 0,0083 E il segno
#   regge nel campione disgiunto E resta dopo aver tolto il giorno peggiore; altrimenti e' il caso.
#  LIMITI: 83 posizioni (v520 33 + antenato 50) e 19 del trial; R92BAB ha SOLO l'ora di chiusura:
#   NON USATO. Il trial e' lo stesso segnale del piccolo sui cross comuni. Lo spread per ora e' dei
#   soli EURUSD, GBPUSD, USDJPY (dati/spread_vivo): per gli altri 19 cross [NON MISURATO] -> sonda.
#
#  Uso: python3 backtest_pipeline/sim_bulge_viola_orario.py [--autotest]     ASCII, seme 20261008
# =====================================================================
import collections
import csv
import datetime
import os
import random
import statistics as st
import sys

import sim_bulge_viola_dati as D

SEME = 20261008
N_PERM = 10000
FASCE = [("F1 notte/asia", 0, 8), ("F2 europa mattina", 8, 12), ("F3 pausa", 12, 14),
         ("F4 apertura USA", 14, 17), ("F5 pomeriggio USA", 17, 22), ("F6 rollover", 22, 24)]
VERGINE_DA = datetime.datetime(2026, 10, 3)
ORARIO_CSV = os.path.join(D.RADICE, "data", "spread_vivo", "SPREAD_VIVO_2026-09-12_orario.csv")


def ora_bcm(p):
    return p["apre"] + datetime.timedelta(hours=1 - p["off_utc"])


def fascia(h):
    for n, a, b in FASCE:
        if a <= h < b:
            return n
    raise ValueError(h)


def classe(sym):
    if "JPY" in sym:
        return "JPY"
    if "AUD" in sym or "NZD" in sym:
        return "AUD/NZD"
    if "EUR" in sym or "GBP" in sym:
        return "EUR/GBP"
    return "ALTRI"


def pf_r(v):
    return D.pf(v)


def p_basso(rs_pool, n, obs_mean, rng, N=N_PERM):
    """P(media di n r estratti a caso <= obs_mean): una coda, 'la fascia e' peggiore del caso'."""
    ge = 0
    for _ in range(N):
        if sum(rng.sample(rs_pool, n)) / n <= obs_mean + 1e-12:
            ge += 1
    return (ge + 1) / (N + 1.0)


def senza_giorno_peggiore(lista):
    """Media di r togliendo il giorno di calendario con la somma r piu' negativa (l'episodio)."""
    if len(lista) < 3:
        return float("nan")
    per = collections.defaultdict(float)
    for p in lista:
        per[ora_bcm(p).date()] += p["r"]
    peg = min(per, key=per.get)
    resto = [p["r"] for p in lista if ora_bcm(p).date() != peg]
    return sum(resto) / len(resto) if resto else float("nan")


def tabella_fasce(nome, pos, rng, pool_ref=None):
    """Frequenza e r per fascia + frontiera (leave-one-fascia-out). pool_ref = r del pool per il nullo."""
    pool_ref = pool_ref or [p["r"] for p in pos]
    n = len(pos)
    tot = sum(p["r"] for p in pos)
    mp = tot / n
    print("\n--- %s: n %d, somma r %+.2f, media r %+.3f, PF(r) %.2f ---" % (nome, n, tot, mp, pf_r([p["r"] for p in pos])))
    print("%-19s %4s %6s %8s %8s %6s %8s %12s | frontiera se TOLTA: trattenuta  delta somma r  delta media r" % ("fascia (ora BCM)", "n", "quota", "somma r", "media r", "PF", "p basso", "senza gg peg."))
    out = {}
    for nome_f, a, b in FASCE:
        l = [p for p in pos if fascia(ora_bcm(p).hour) == nome_f]
        k = len(l)
        if k == 0:
            print("%-19s %4d %5.0f%%   (nessun ingresso)" % ("%s %02d-%02d" % (nome_f[:2], a, b), 0, 0.0))
            out[nome_f] = None
            continue
        s = sum(p["r"] for p in l)
        m = s / k
        pv = p_basso(pool_ref, k, m, rng) if k >= 3 else float("nan")
        sg = senza_giorno_peggiore(l)
        resto = n - k
        dm = ((tot - s) / resto - mp) if resto else float("nan")
        print("%-19s %4d %5.0f%% %+8.2f %+8.3f %6.2f %8s %12s | %20.0f%% %+13.2f %+14.3f" % (
            "%s %02d-%02d" % (nome_f[:2], a, b), k, 100.0 * k / n, s, m, pf_r([p["r"] for p in l]),
            ("%.3f" % pv) if pv == pv else "n<3", ("%+.3f" % sg) if sg == sg else "n/d",
            100.0 * resto / n, -s, dm))
        out[nome_f] = (k, s, m, pv)
    return out


def sezione_classi(nome, pos, rng):
    print("\n--- classi di cross x notte/giorno (%s, n %d) --- ora BCM; notte = F1 (00-08), giorno = F2..F5, rollover F6 a parte" % (nome, len(pos)))
    cell = collections.defaultdict(list)
    for p in pos:
        f = fascia(ora_bcm(p).hour)
        tag = "notte" if f.startswith("F1") else ("rollover" if f.startswith("F6") else "giorno")
        cell[(classe(p["sym"]), tag)].append(p["r"])
    print("  %-9s | %-26s | %-26s | %-18s" % ("classe", "notte (F1)", "giorno (F2-F5)", "rollover (F6)"))
    for c in ("JPY", "AUD/NZD", "EUR/GBP", "ALTRI"):
        cols = []
        for t in ("notte", "giorno", "rollover"):
            v = cell.get((c, t), [])
            cols.append("n %2d media %+.3f" % (len(v), sum(v) / len(v)) if v else "n  0")
        print("  %-9s | %-26s | %-26s | %-18s" % (c, cols[0], cols[1], cols[2]))
    # H-O2: (JPY + AUD/NZD) contro (EUR/GBP + ALTRI) dentro F1
    f1 = [p for p in pos if fascia(ora_bcm(p).hour).startswith("F1")]
    A = [p["r"] for p in f1 if classe(p["sym"]) in ("JPY", "AUD/NZD")]
    B = [p["r"] for p in f1 if classe(p["sym"]) in ("EUR/GBP", "ALTRI")]
    if len(A) >= 3 and len(B) >= 3:
        diff = sum(A) / len(A) - sum(B) / len(B)
        tutti = A + B
        ge = 0
        for _ in range(N_PERM):
            rng.shuffle(tutti)
            a2, b2 = tutti[:len(A)], tutti[len(A):]
            if sum(a2) / len(a2) - sum(b2) / len(b2) >= diff - 1e-12:
                ge += 1
        print("  H-O2 in F1: (JPY+AUD/NZD) n %d media %+.3f contro (EUR/GBP+ALTRI) n %d media %+.3f: differenza %+.3f R, p(una coda, permutazione delle classi) = %.3f"
              % (len(A), sum(A) / len(A), len(B), sum(B) / len(B), diff, (ge + 1) / (N_PERM + 1.0)))
    else:
        print("  H-O2 non eseguibile: celle F1 con n<3 (JPY+AUD/NZD n %d, EUR/GBP+ALTRI n %d)" % (len(A), len(B)))


def spread_per_fascia():
    """Mediana oraria dello spread in pip (logger 04-11/09/2026) per fascia, per i soli 3 maggiori."""
    if not os.path.exists(ORARIO_CSV):
        return {}
    righe = list(csv.DictReader(open(ORARIO_CSV, encoding="utf-8")))
    out = {}
    for s in ("EURUSD", "GBPUSD", "USDJPY"):
        per = {}
        for r in righe:
            if r["simbolo"] == s:
                per[int(r["ora_server"])] = (float(r["mediana_unita"]), float(r["p95_unita"]))
        res = {}
        for nome_f, a, b in FASCE:
            ore = [per[h][0] for h in range(a, b) if h in per]
            p95 = [per[h][1] for h in range(a, b) if h in per]
            if ore:
                res[nome_f] = (st.median(ore), max(p95))
        out[s] = res
    return out


def autotest():
    ko = []

    def ok(c, m):
        print("  [%s] %s" % ("OK" if c else "KO", m))
        if not c:
            ko.append(m)

    rng = random.Random(SEME)
    ok([fascia(h)[:2] for h in (0, 7, 8, 11, 12, 13, 14, 16, 17, 21, 22, 23)] == ["F1", "F1", "F2", "F2", "F3", "F3", "F4", "F4", "F5", "F5", "F6", "F6"], "confini delle fasce: 7|8, 11|12, 13|14, 16|17, 21|22")
    ok(classe("USDJPY") == "JPY" and classe("AUDNZD") == "AUD/NZD" and classe("GBPNZD") == "AUD/NZD" and classe("EURGBP") == "EUR/GBP" and classe("USDCAD") == "ALTRI" and classe("CADJPY") == "JPY", "classi: USDJPY/CADJPY=JPY, AUDNZD/GBPNZD=AUD/NZD (priorita'), EURGBP=EUR/GBP, USDCAD=ALTRI")

    def mk(h, r, giorno=1, sym="EURUSD", off=1):
        a = datetime.datetime(2026, 10, giorno, h)
        return D.nuova("fin", (h, giorno, sym), sym, 1, a, a + datetime.timedelta(hours=2), off, r * 100.0, 100.0, "tp", "VIOLA", "x")
    q = mk(6, 0.1, off=3)  # FTMO 06:00 -> BCM 04:00
    ok(fascia(ora_bcm(q).hour).startswith("F1") and ora_bcm(q).hour == 4, "FTMO UTC+3: 06:00 diventa 04:00 BCM (F1)")
    q2 = mk(0, 0.1, off=3)  # FTMO 00:00 -> BCM 22:00 del giorno prima
    ok(ora_bcm(q2).hour == 22 and ora_bcm(q2).day == 30 and fascia(22).startswith("F6"), "FTMO 00:00 diventa 22:00 BCM del giorno prima (F6, e cambia il giorno)")
    # fascia con 5 perdite NELLO STESSO GIORNO: raw sembra significativa, senza l'episodio no
    pos = [mk(9, -1.0, giorno=1, sym="EURUSD") for _ in range(5)]
    pos += [mk(h, 0.2, giorno=2 + (i % 20), sym="GBPUSD") for i, h in enumerate([1, 2, 3, 4, 5, 6, 15, 16, 18, 19, 20, 3, 4, 5, 15, 16, 18, 19, 20, 3] * 2)]
    rs = [p["r"] for p in pos]
    l = [p for p in pos if fascia(ora_bcm(p).hour).startswith("F2")]
    pv = p_basso(rs, len(l), sum(p["r"] for p in l) / len(l), rng, 4000)
    ok(len(l) == 5 and pv < 0.01, "episodio: 5 perdite in F2 stesso giorno -> p grezzo basso (%.4f)" % pv)
    ok(senza_giorno_peggiore(l) != senza_giorno_peggiore(l) or senza_giorno_peggiore(l) > -0.5, "CONTROESEMPIO: tolto il giorno dell'episodio la fascia non e' piu' peggiore (n<3 residuo = n/d)")
    # frontiera: la somma delle quote = 100% e la somma di r si conserva
    out = tabella_fasce("finto", pos, rng, rs)
    ok(abs(sum(v[1] for v in out.values() if v) - sum(rs)) < 1e-9, "la somma di r per fascia = somma totale (conservazione)")
    ok(sum(v[0] for v in out.values() if v) == len(pos), "ogni ingresso cade in una sola fascia")
    # risposta nota sul nullo: tutti uguali -> p alto
    uguali = [mk(h, 0.1, giorno=1 + i, sym="EURUSD") for i, h in enumerate(range(0, 24))]
    ok(p_basso([p["r"] for p in uguali], 4, 0.1, rng, 500) > 0.99, "dati tutti uguali: nessuna fascia 'peggiore' (p~1)")
    print("AUTOTEST: %s" % ("TUTTO OK" if not ko else "FALLITI: %d" % len(ko)))
    return not ko


def main():
    if not autotest():
        print("autotest fallito")
        return 1
    if "--autotest" in sys.argv:
        return 0
    rng = random.Random(SEME)
    v520, ant = D.carica_bcm()
    v_v = [p for p in v520 if p["segnale"] == "VIOLA" and p["sym"] in D.SYM22]
    a_v = [p for p in ant if p["segnale"] == "VIOLA" and p["sym"] in D.SYM22]
    trial = D.carica_trial()
    pool = v_v + a_v
    rs = [p["r"] for p in pool]
    print("\nCAMPIONI (ora di APERTURA, BCM): v520 VIOLA %d (30/09-07/10) | antenato VIOLA %d (01/04-08/06, primo tick) | trial %d (01-06/10, stesse operazioni del piccolo sui cross comuni)" % (len(v_v), len(a_v), len(trial)))
    print("R92BAB (190 VIOLA): SOLO ora di chiusura -> NON usato qui (la chiusura non e' la fascia d'ingresso).")
    verg = [p for p in v_v if p["apre"] >= VERGINE_DA]
    print("CAMPIONE VERGINE (aperte dal 03/10, dopo il dossier del 03/10 e le fasce del 03/10): v520 %d, trial %d" % (len(verg), len([p for p in trial if p["apre"] >= VERGINE_DA])))
    print("\n##### FREQUENZA E R PER FASCIA FISSATA A PRIORI; nullo = estrazione casuale dal pool unito (83) #####")
    tabella_fasce("POOL v520+antenato VIOLA (83)", pool, rng, rs)
    print("\n##### REPLICA IN CAMPIONI DISGIUNTI (stesse fasce) #####")
    r_a = tabella_fasce("ANTENATO da solo (aprile-giugno)", a_v, rng, rs)
    r_v = tabella_fasce("V520 da solo (30/09-07/10)", v_v, rng, rs)
    tabella_fasce("V520 VERGINE (aperte dal 03/10)", verg, rng, rs)
    tabella_fasce("TRIAL FTMO (19; riportato a BCM)", trial, rng, rs)
    print("\n  segno per fascia, antenato contro v520 (media r): ")
    for nome_f, _, _ in FASCE:
        a, v = r_a.get(nome_f), r_v.get(nome_f)
        sa = "%+.2f(n%d)" % (a[2], a[0]) if a else "--"
        sv = "%+.2f(n%d)" % (v[2], v[0]) if v else "--"
        concorde = (a and v and (a[2] < 0) == (v[2] < 0))
        print("    %-19s antenato %-12s v520 %-12s %s" % (nome_f, sa, sv, "stesso segno" if concorde else "segni diversi / mancante"))
    print("\n##### CLASSI DI CROSS #####")
    sezione_classi("pool 83", pool, rng)
    sezione_classi("trial 19", trial, rng)
    print("\n##### SPREAD PER FASCIA (pip, mediana oraria; solo 3 maggiori, logger 04-11/09/2026, ora server BCM) #####")
    sp = spread_per_fascia()
    atr_pip = {"EURUSD": 13.6, "GBPUSD": 18.1, "USDJPY": 10.7}   # ATR H1 al segnale da SL = 3 ATR (n_vol 1, 3, 4: PROXY)
    print("  %-19s %s" % ("fascia", "  ".join("%-26s" % s for s in sp)))
    for nome_f, _, _ in FASCE:
        cols = []
        for s, d in sp.items():
            if nome_f in d:
                m, p95 = d[nome_f]
                cols.append("med %.2f P95 %.2f s/ATR %.1f%%" % (m, p95, 100.0 * m / atr_pip[s]))
            else:
                cols.append("n/d")
        print("  %-19s %s" % (nome_f, "  ".join("%-26s" % c for c in cols)))
    print("\n  ROLLOVER ORA PER ORA (ingresso alle 22 e alle 23 BCM): mediana/P95 dello spread in pip; costo dello spread d'ingresso in R = spread / (3 ATR) e in quota della vincita mediana (0,24 R)")
    for s_, d_ in (("EURUSD", None), ("GBPUSD", None), ("USDJPY", None)):
        righe = [r for r in csv.DictReader(open(ORARIO_CSV, encoding="utf-8")) if r["simbolo"] == s_]
        for h in (3, 12, 22, 23):
            r_ = [x for x in righe if int(x["ora_server"]) == h]
            if r_:
                m, p95 = float(r_[0]["mediana_unita"]), float(r_[0]["p95_unita"])
                cR = m / (3.0 * atr_pip[s_])
                print("    %s ora %02d BCM: med %.2f P95 %.2f pip | s/ATR %.1f%% | spread = %.1f%% di R = %.0f%% della vincita mediana%s"
                      % (s_, h, m, p95, 100.0 * m / atr_pip[s_], 100.0 * cR, 100.0 * cR / 0.24, "  <-- FUORI frontiera 40x" if m / atr_pip[s_] > 0.075 else ""))
    print("  frontiera del costo 40x: stop 3 ATR >= 40 x spread  <=>  spread <= 3 ATR / 40 = 7,5% di ATR (commissione ESCLUSA: flatta). Fuori frontiera = s/ATR > 7,5%.")
    print("  (ATR da pochi trade stoppati: n 1/3/4; ordine di grandezza.)")
    print("\nNON MISURATO: spread e ATR per ora dei 19 cross diversi dai 3 maggiori; ora d'ingresso su R92BAB/M1 (serve open_time: copia di banco); notte invernale (cambio d'ora).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
