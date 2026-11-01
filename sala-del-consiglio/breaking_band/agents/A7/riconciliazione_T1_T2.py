#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""riconciliazione_T1_T2.py - V10/V13: coerenza fra T1 (imbuto), T2 (risultati), LOG_TRADE e la mia reimplementazione.
Uso: python3 -I riconciliazione_T1_T2.py <primario.json> <cartella_csv>"""
import json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import verifica_generica as VG
import reimpl_segnali as R

FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
import inspect
_src = inspect.getsource(R._arm_check)
_old = "    den = float(np.sum(np.abs(np.diff(v.c[s:t + 1])))) if t > s else 0.0\n    B4 = bool(den > 0 and abs(v.c[t] - v.c[s]) / den >= cfg.b4_er and v.c[t] > v.c[s])"
_new = ("    ci = np.round(v.c[s:t + 1] * 100).astype(np.int64)\n    den_i = int(np.abs(np.diff(ci)).sum()) if t > s else 0\n"
        "    B4 = bool(den_i > 0 and 2 * abs(int(ci[-1] - ci[0])) >= den_i and ci[-1] > ci[0])")
assert _old in _src
_ns = dict(R.__dict__); exec(_src.replace(_old, _new), _ns); arm_exact = _ns["_arm_check"]
js = json.load(open(sys.argv[1])); folder = sys.argv[2]; oss = []
T1, T2, LOG = js["tabelle"]["T1_imbuto"], js["tabelle"]["T2_risultati"], js["tabelle"]["LOG_TRADE"]
probs = []; info = []
# ---- 1. T1 interno: conteggi di stadio non crescenti, segnali = eseguiti + scartati, 'riconciliato'
for cella, d in T1.items():
    for per, t in d.items():
        st = [r["n"] for r in t["stadi"]]
        if any(b > a for a, b in zip(st[:-1], st[1:])):
            probs.append("T1 %s %s: stadi non monotoni %s" % (cella, per, st))
        sg = t["segnali_e_trade"]
        scart = sum(v for k, v in sg.items() if k.startswith("scartati_"))
        if sg["segnali"] != sg["eseguiti"] + scart:
            probs.append("T1 %s %s: segnali %d != eseguiti %d + scartati %d" % (cella, per, sg["segnali"], sg["eseguiti"], scart))
        if not sg["riconciliato"]:
            probs.append("T1 %s %s: flag riconciliato falso" % (cella, per))
        if st[-1] != sg["segnali"]:
            probs.append("T1 %s %s: ultimo stadio %d != segnali %d" % (cella, per, st[-1], sg["segnali"]))
# ---- 2. T1 TOTALE = somma dei periodi
for cella, d in T1.items():
    pers = [k for k in d if k != "TOTALE"]
    for i, r in enumerate(d["TOTALE"]["stadi"]):
        s = sum(d[p]["stadi"][i]["n"] for p in pers)
        if s != r["n"]:
            probs.append("T1 %s TOTALE stadio %s: %d != somma periodi %d" % (cella, r["stadio"], r["n"], s))
    for k in ("segnali", "eseguiti"):
        if d["TOTALE"]["segnali_e_trade"][k] != sum(d[p]["segnali_e_trade"][k] for p in pers):
            probs.append("T1 %s TOTALE %s non somma" % (cella, k))
# ---- 3. T1 eseguiti = T2 n = len(LOG_TRADE) per ogni cella; TOTALE e POOLED
tot_by = {}
for cella, d in T1.items():
    var, tf = cella.split("_")
    for per in [k for k in d if k != "TOTALE"]:
        key = "%s_%s_%s" % (var, tf, per)
        n1 = d[per]["segnali_e_trade"]["eseguiti"]; n2 = T2[key]["n"]; n3 = len(LOG[key])
        if not (n1 == n2 == n3):
            probs.append("%s: T1 eseguiti %d, T2 n %d, LOG %d" % (key, n1, n2, n3))
        tot_by[(var, tf)] = tot_by.get((var, tf), 0) + n2
for (var, tf), n in tot_by.items():
    if T2["%s_%s_TOTALE" % (var, tf)]["n"] != n:
        probs.append("T2 %s_%s_TOTALE n non somma" % (var, tf))
for tf in ("H1", "M30"):
    if T2["POOLED_" + tf]["n"] != tot_by[("CONT", tf)] + tot_by[("INV", tf)]:
        probs.append("T2 POOLED_%s n non somma" % tf)
info.append("H1: CONT %d + INV %d = POOLED %d ; M30: CONT %d + INV %d = POOLED %d" % (tot_by[("CONT", "H1")], tot_by[("INV", "H1")], T2["POOLED_H1"]["n"], tot_by[("CONT", "M30")], tot_by[("INV", "M30")], T2["POOLED_M30"]["n"]))
# ---- 4. T2: vincite = trade con R>0, per_motivo somma n, eventi/uscite
for key, c in T2.items():
    if c.get("n", 0) == 0: continue
    if sum(c["per_motivo"].values()) != c["n"]:
        probs.append("T2 %s: per_motivo non somma a n" % key)
# ---- 5. imbuto per BARRA (B1..B6) e per EPISODIO contro la mia reimplementazione
ok_b = ok_ep = n_b = n_ep = 0
dettaglio_ep = []
for per, fn in FILES.items():
    m1 = VG.load_m1_csv(os.path.join(folder, fn)); m1, _ = VG.replace_zero_spread(m1)
    for tf, tfn in ((60, "H1"), (30, "M30")):
        bars = VG.aggregate_m1(m1, tf, min_m1=1)
        o, h, l, c = bars["open"], bars["high"], bars["low"], bars["close"]
        cfg = R.Cfg()
        res = R.detect(bars)
        for d in (1, -1):
            v = R.View(o, h, l, c, cfg) if d == 1 else R.View(-o, -l, -h, -c, cfg)
            marg = [0] * 6; cum = [0] * 6; margx = [0] * 6; cumx = [0] * 6
            for t in range(cfg.warmup, len(c)):
                s, fl, ready = R._arm_check(v, t, cfg)
                if not ready: continue
                for i, f in enumerate(fl): marg[i] += f
                for i in range(6):
                    if all(fl[:i + 1]): cum[i] += 1
                s, flx, ready = arm_exact(v, t, cfg)
                for i, f in enumerate(flx): margx[i] += f
                for i in range(6):
                    if all(flx[:i + 1]): cumx[i] += 1
            a4 = T1["CONT_" + tfn][per]["imbuto_barre_criteri_B"][str(d)]
            m4 = list(a4["marginali"].values()); c4 = list(a4["cumulativi"].values())
            n_b += 1
            if m4 == margx and c4 == cumx: ok_b += 1
            else: oss.append("imbuto B per barra %s %s d=%+d: A4 marg %s cum %s | A7 aritmetica ESATTA marg %s cum %s | A7 float marg %s cum %s" % (tfn, per, d, m4, c4, margx, cumx, marg, cum))
            n_b_float = locals().get("n_b_float", 0) + (m4 == marg and c4 == cum); ok_float = locals().get("ok_float", 0)
        # episodi: stadi cumulativi
        cn = res["counters"]
        for var in ("CONT", "INV"):
            rows = {r["stadio"]: r["n"] for r in T1[var + "_" + tfn][per]["stadi"]}
            a4n = [r["n"] for r in T1[var + "_" + tfn][per]["stadi"]]
            names = [r["stadio"] for r in T1[var + "_" + tfn][per]["stadi"]]
            if var == "CONT":
                mine = [cn["armati"], cn["ep_con_barra_p+MIN_RETR"]] + [cn["CONT_ep_stadio%d_%s" % (i, nm)] for i, nm in enumerate(R.STAGES_CONT)]
                mine.insert(4, None)       # C1a non ha controparte (mio C1 = C1a+C1b): salto il confronto
                a4cmp = list(a4n)
                pairs = [(names[k], a4cmp[k], mine[k]) for k in range(len(names)) if k < len(mine) and mine[k] is not None]
                # mio stadio C1 (indice 4 prima dell'inserimento) corrisponde a A4 C1b (indice 5): riallineo
                pairs = [(names[0], a4n[0], cn["armati"]), (names[1], a4n[1], cn["ep_con_barra_p+MIN_RETR"]), (names[2], a4n[2], cn["CONT_ep_stadio0_C0_tocco_banda_opposta"]),
                         (names[3], a4n[3], cn["CONT_ep_stadio1_C3_SEQ_assente"]), (names[5], a4n[5], cn["CONT_ep_stadio2_C1_nessuna_impulsiva"]),
                         (names[6], a4n[6], cn["CONT_ep_stadio3_C2a_sd<S50"]), (names[7], a4n[7], cn["CONT_ep_stadio4_C2b_sd<=sd[-3]"]), (names[8], a4n[8], cn["segnali_CONT"])]
            else:
                pairs = [(names[0], a4n[0], cn["armati"]), (names[1], a4n[1], cn["ep_con_barra_p+MIN_RETR"])] + \
                        [(names[2 + i], a4n[2 + i], cn["INV_ep_stadio%d_%s" % (i, nm)]) for i, nm in enumerate(R.STAGES_INV[:-0 or None])][:6] + [(names[9], a4n[9], cn["segnali_INV"])]
            for nm, x4, x7 in pairs:
                n_ep += 1
                if x4 == x7: ok_ep += 1
                else: dettaglio_ep.append("%s_%s %s stadio '%s': A4=%d A7=%d" % (var, tfn, per, nm, x4, x7))
print("T1/T2/LOG: %d incoerenze interne" % len(probs))
print("OSSERVAZIONI sul confronto per barra B1..B6 (A4 vs aritmetica ESATTA in centesimi, ties ER==0,50): %d celle diverse" % len(oss))
for o_ in oss: print("  OSS:", o_)
for p in probs: print("  PROBLEMA:", p)
for i in info: print(i)
print("imbuto per BARRA B1..B6 (marginali e cumulativi, per direzione), A4 vs A7 (aritmetica esatta): %d/%d celle identiche" % (ok_b, n_b))
print("imbuto per EPISODIO (stadi cumulativi), A4 vs A7: %d/%d conteggi identici" % (ok_ep, n_ep))
for d in dettaglio_ep[:40]: print("  differenza di stadio:", d)
sys.exit(0 if not probs else 1)
