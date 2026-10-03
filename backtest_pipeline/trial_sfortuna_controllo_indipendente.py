#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
trial_sfortuna_controllo_indipendente.py -- 03/10/2026, controllo-preventivo (strato 2 del cancello)
Ricostruzione INDIPENDENTE del modello di portafoglio di report/TRIAL_SFORTUNA_O_EA_2026-10-03.md:
cicli espliciti, solo libreria standard, NON importa audit_rischio_flotta ne' trial_sfortuna_o_ea.
SOLA LETTURA: legge i per-trade del repo, stampa in console.
Varianti: R con saldo composto (come l'originale) / R su deposito fisso / posizioni chiuse di domenica
portate al lunedi' (l'originale le scarta in silenzio). Piu': chi fa i "doppi stop DAX" e la scomposizione
della correlazione di P4 per indice (2.000 permutazioni, seme 20261003, random.Random).
USO: python3 backtest_pipeline/trial_sfortuna_controllo_indipendente.py
"""
import csv, datetime as dt, os, random

QUI = os.path.dirname(os.path.abspath(__file__))
C = {  # sedia: (per-trade relativo a backtest_pipeline, quota, deposito, taglia in campo %, indice)
    "770411": ("risultati_prove/trades_portafoglio/abtg_trades_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770413.csv", 1.0, 100000.0, 2.0, "DAX"),
    "770105": ("risultati_archivio/R251/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_792520.csv", 1.0, 10000.0, 2.0, "DAX"),
    "770621": ("risultati_prove/trades_portafoglio/abtg_trades_ABTG_ORB_Ottimizzato_U30USD_770612.csv", 1.0, 100000.0, 0.3, "DOW"),
    "770101": ("risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv", 1.0, 100000.0, 2.0, "DAX"),
    "770202": ("risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv", 1.0, 100000.0, 2.0, "DOW"),
    "771531": ("risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv", 0.5, 100000.0, 2.0, "DOW"),
}
D0, D1 = dt.date(2025, 7, 1), dt.date(2026, 6, 29)
OSS = (-3292.52 - 3110.48 - 537.86) / 160000.0   # 770411 + 770105 + ORB nel trial
TOT_2G = -8811.59 / 160000.0
G1 = -5815.64 / 160000.0
P6 = list(C)
P4 = ["770105", "770202", "770411", "770621"]


def posizioni(s, modo):
    rel, q, dep, tg, _ = C[s]
    righe = list(csv.DictReader(open(os.path.join(QUI, rel)), delimiter=";"))
    righe.sort(key=lambda r: (dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S"), r["position_id"]))
    agg, ordine = {}, []
    for r in righe:
        t = dt.datetime.strptime(r["close_time"], "%Y.%m.%d %H:%M:%S")
        pid = r["position_id"]
        if pid not in agg:
            agg[pid] = {"t1": t, "net": 0.0}
            ordine.append(pid)
        agg[pid]["net"] += float(r["net_profit"])
        agg[pid]["t1"] = t
    bal, out = dep, []
    for pid in ordine:
        base = bal if modo == "composto" else dep
        out.append((agg[pid]["t1"].date(), agg[pid]["net"] / (0.01 * q * base)))
        bal += agg[pid]["net"]
    return out


def calendario():
    out, d = [], D0
    while d <= D1:
        if d.weekday() < 5:
            out.append(d)
        d += dt.timedelta(days=1)
    return out


def serie(modo, domenica_al_lunedi):
    cal = calendario()
    ser, stp, scartate = {}, {}, []
    for s in C:
        rel, q, dep, tg, _ = C[s]
        v, st = {}, {}
        for d, R in posizioni(s, modo):
            if domenica_al_lunedi and d.weekday() == 6:
                d = d + dt.timedelta(days=1)
            if d < D0 or d > D1:
                continue
            if d.weekday() >= 5:
                scartate.append((s, str(d), round(R, 3)))
                continue
            v[d] = v.get(d, 0.0) + R * tg * q / 100.0
            if R <= -0.70:
                st[d] = 1
        ser[s] = [v.get(d, 0.0) for d in cal]
        stp[s] = [st.get(d, 0) for d in cal]
    return cal, ser, stp, scartate


def conta(righe, n):
    g = []
    for i in range(n):
        x = 0.0
        for r in righe:
            x += r[i]
        g.append(x)
    c = {"S1_436": 0, "S1_g1": 0, "S2": 0, "S3": 0, "S4": 0}
    for x in g:
        if x <= -0.0436: c["S1_436"] += 1
        if x <= G1: c["S1_g1"] += 1
    for i in range(n - 1):
        a, b = g[i], g[i + 1]
        if a + b <= TOT_2G: c["S2"] += 1
        if a <= -0.0436 or b <= -0.0436: c["S3"] += 1
        if a + b <= OSS + 1e-12: c["S4"] += 1
    return c, g


def main():
    for modo, dom in (("composto", False), ("fisso", False), ("composto", True)):
        cal, ser, stp, scartate = serie(modo, dom)
        n = len(cal)
        print("== R %s | domenica al lunedi': %s | giorni %d, coppie %d" % (modo, dom, n, n - 1))
        if scartate:
            print("   posizioni chiuse di sabato/domenica SCARTATE dal calendario:", scartate)
        for nome, ins in (("P6", P6), ("P4", P4)):
            c, _ = conta([ser[s] for s in ins], n)
            print("   %s: %s | S4 = %d/%d = %.2f%%" % (nome, c, c["S4"], n - 1, 100.0 * c["S4"] / (n - 1)))
    cal, ser, stp, _ = serie("composto", False)
    n = len(cal)
    # chi fa i doppi stop DAX
    dax = ["770101", "770105", "770411"]
    coppie, tot = {}, 0
    for i in range(n):
        st = tuple(s for s in dax if stp[s][i])
        if len(st) >= 2:
            tot += 1
            coppie[st] = coppie.get(st, 0) + 1
    fr = [sum(stp[s]) / n for s in dax]
    att = n * (fr[0] * fr[1] + fr[0] * fr[2] + fr[1] * fr[2] - 2 * fr[0] * fr[1] * fr[2])
    print("== doppi stop DAX: %d giorni su %d, attesi %.2f, lift %.2f | per coppia: %s" % (tot, n, att, tot / att, coppie))
    co = sum(1 for i in range(n) if ser["770411"][i] != 0 and ser["770105"][i] != 0)
    both = sum(1 for i in range(n) if stp["770411"][i] and stp["770105"][i])
    print("   770411 e 770105: giorni con posizioni di entrambe %d, con stop di entrambe %d" % (co, both))
    # le coppie di giorni di P4 sotto l'osservato, sedia per sedia
    c, g = conta([ser[s] for s in P4], n)
    print("== P4: le %d coppie <= %.3f%%" % (c["S4"], 100 * OSS))
    for i in range(n - 1):
        if g[i] + g[i + 1] <= OSS + 1e-12:
            print("   %s+%s %.3f%% | %s | stop (g1,g2): %s" % (cal[i], cal[i + 1], 100 * (g[i] + g[i + 1]),
                  {s: round(100 * (ser[s][i] + ser[s][i + 1]), 3) for s in P4},
                  {s: (stp[s][i], stp[s][i + 1]) for s in P4}))
    # scomposizione della correlazione di P4 per indice
    rnd = random.Random(20261003)

    def perm_insieme(righe):
        idx = list(range(n)); rnd.shuffle(idx)
        return [[r[j] for j in idx] for r in righe]

    def s4(righe):
        return conta(righe, n)[0]["S4"] / (n - 1)

    acc = {"tutte indipendenti": 0.0, "DAX allineato, resto indip.": 0.0, "DOW allineato, resto indip.": 0.0,
           "DAX e DOW allineati, indici indip.": 0.0}
    REPS = 2000
    for _ in range(REPS):
        acc["tutte indipendenti"] += s4([perm_insieme([ser[s]])[0] for s in P4])
        acc["DAX allineato, resto indip."] += s4(perm_insieme([ser["770105"], ser["770411"]]) + [perm_insieme([ser["770202"]])[0], perm_insieme([ser["770621"]])[0]])
        acc["DOW allineato, resto indip."] += s4(perm_insieme([ser["770202"], ser["770621"]]) + [perm_insieme([ser["770105"]])[0], perm_insieme([ser["770411"]])[0]])
        acc["DAX e DOW allineati, indici indip."] += s4(perm_insieme([ser["770105"], ser["770411"]]) + perm_insieme([ser["770202"], ser["770621"]]))
    print("== P4 S4 calendario %.4f | permutazioni (%d, seme 20261003): %s" % (s4([ser[s] for s in P4]), REPS,
          {k: round(v / REPS, 4) for k, v in acc.items()}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
