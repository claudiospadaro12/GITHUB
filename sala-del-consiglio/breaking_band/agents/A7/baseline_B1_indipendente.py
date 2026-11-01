#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""baseline_B1_indipendente.py - ricostruzione INDEPENDENTE delle linee di base B1 (primaria) e B0 (disegno_test_v1 sez. 4) sul run
reale: pool di tutte le barre H1 idonee (dopo warm-up) simulate lato per lato con il MIO simulatore, indicatori e segnali miei;
abbinamento per periodo, lato, distanza D (0,85-1,15 D_i), stato di volatilita (sd<S50 e sd<=sd[-3]), barra non di segnale;
2000 estrazioni con seme 20261101 (stessa sequenza di chiamate rng del disegno). Confronto con T4 di primario.json.
Uso: python3 -I baseline_B1_indipendente.py <primario.json> <cartella_csv>"""
import json, os, sys, math
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import verifica_generica as VG, reimpl_segnali as R
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
js = json.load(open(sys.argv[1])); folder = sys.argv[2]
LOG = js["tabelle"]["LOG_TRADE"]; T4 = js["tabelle"]["T4_linea_di_base"]
TF, RIC, MAXHOLD, WARM = 60, 3, 1000, 200
pools = {}; n_fuori_maxhold = 0
for per, fn in FILES.items():
    m1 = VG.load_m1_csv(os.path.join(folder, fn)); m1, _ = VG.replace_zero_spread(m1)
    b = VG.aggregate_m1(m1, TF); n = len(b["close"]); c = b["close"]
    # indicatori miei
    sma = np.full(n, np.nan); sd = np.full(n, np.nan)
    for i in range(19, n):
        w = c[i - 19:i + 1]; sma[i] = w.mean(); sd[i] = w.std()
    s50 = np.full(n, np.nan)
    for i in range(19 + 49, n): s50[i] = sd[i - 49:i + 1].mean()
    atr = VG.atr_wilder(b["high"], b["low"], b["close"], 14)
    sigs = {s["bar"] for s in R.detect(b)["signals"]}
    # indice M1 della prima M1 di ogni barra (per kend)
    first_m1 = np.searchsorted(m1.t, b["time"], side="left"); last_m1 = np.r_[first_m1[1:] - 1, m1.n - 1]
    out = {1: [], -1: []}
    for j in range(WARM, n - 1):
        if not (math.isfinite(atr[j]) and math.isfinite(sma[j])): continue
        vol = bool(sd[j] < s50[j] and sd[j] <= sd[j - 3])
        e_t = int(b["time"][j]) + TF; i0 = int(np.searchsorted(m1.t, e_t, side="left"))     # spec 6.1: gap misurato dalla FINE nominale della barra tau
        kend = min(j + MAXHOLD, n - 1)
        sched = [(e_t, float(sma[j]))]      # target iniziale valido dalla M1 di ingresso
        k = 1
        while j + 1 + RIC * k <= kend:
            sched.append((int(b["time"][j + 1 + RIC * k]), float(sma[j + RIC * k]))); k += 1
        for side in (1, -1):
            entry = m1.o[i0] + (m1.spread[i0] if side == 1 else 0.0)
            D = 3.0 * atr[j]; stop = entry - side * D
            spec = {"direction": side, "entry_time": e_t, "stop": stop, "targets": sched}
            r = VG.simulate_trade(m1, spec, max_entry_gap_min=180, end_index=int(last_m1[kend]))
            if r.get("status") != "ok": continue
            if r["exit_reason"] == "end_of_data" and r["exit_idx"] == last_m1[kend] and kend == j + MAXHOLD: n_fuori_maxhold += 1
            out[side].append((j, r["pnl"] / D, abs(sma[j] - entry) / atr[j], vol, j in sigs))
    pools[per] = {s: {k: np.array([x[i] for x in out[s]]) for i, k in enumerate(("j", "R", "D", "vol", "sig"))} for s in (1, -1)}
    print("%-8s pool simulato: long %d short %d" % (per, len(out[1]), len(out[-1])), "| A4:", T4["pool_barre_simulate"][per], flush=True)
# trade primari H1 nell'ordine di run_test: (periodo idx, entry_time, variante)
ordp = {k: i for i, k in enumerate(FILES)}
prim = [dict(t, periodo=per) for per in FILES for var in ("CONT", "INV") for t in LOG["%s_H1_%s" % (var, per)]]
prim.sort(key=lambda t: (ordp[t["periodo"]] * 10 ** 10 + t["entry_time"], t["variante"]))
print("trade primari H1:", len(prim))
res = {}
for tipo in ("B1", "B0"):
    rng = np.random.default_rng(20261101); n_draw = 2000
    M = np.full((n_draw, len(prim)), np.nan); mancanti = 0
    for i, t in enumerate(prim):
        pl = pools[t["periodo"]][t["side"]]
        m = (pl["D"] >= 0.85 * t["D_atr"]) & (pl["D"] <= 1.15 * t["D_atr"]) & (pl["sig"] < 0.5)
        if tipo == "B1": m &= (pl["vol"] > 0.5)
        idx = np.flatnonzero(m)
        if idx.size == 0: mancanti += 1; continue
        M[:, i] = pl["R"][idx[rng.integers(0, idx.size, size=n_draw)]]
    ok = ~np.isnan(M[0]); Mo = M[:, ok]
    obs = float(np.mean([t["R"] for t, o in zip(prim, ok) if o])); nulla = Mo.mean(axis=1)
    res[tipo] = {"n_abbinati": int(ok.sum()), "mancanti": mancanti, "obs": obs, "media_nulla": float(nulla.mean()), "p5": float(np.quantile(nulla, .05)), "p50": float(np.quantile(nulla, .5)),
                 "p95": float(np.quantile(nulla, .95)), "perc": float((nulla < obs).mean()), "p_B": (1 + int((nulla >= obs).sum())) / (n_draw + 1)}
bad = 0
for tipo in ("B1", "B0"):
    a4 = T4[tipo]["pooled"]; mine = res[tipo]
    pairs = [("n_abbinati", a4["n_abbinati"], mine["n_abbinati"]), ("media_osservata_R", a4["media_osservata_R"], mine["obs"]), ("media_nulla", a4["media_nulla"], mine["media_nulla"]),
             ("p5", a4["p5"], mine["p5"]), ("p50", a4["p50"], mine["p50"]), ("p95", a4["p95"], mine["p95"]), ("percentile_osservato", a4["percentile_osservato"], mine["perc"]), ("p_B", a4["p_B"], mine["p_B"])]
    print("\n%s pooled (mancanti A4=%s, mia=%s)" % (tipo, T4[tipo]["mancanti_senza_abbinamento"], mine["mancanti"]))
    for nm, x4, x7 in pairs:
        same = (x4 == x7) if isinstance(x4, int) else abs(x4 - x7) <= 1e-9 * max(1.0, abs(x4))
        bad += (not same)
        print("  %-22s A4=%-22s A7=%-22s %s" % (nm, x4, x7, "OK" if same else "DIVERSO"))
print("\nTrade con maxhold raggiunto nel pool (fuori dal confronto esatto):", n_fuori_maxhold)
print("ESITO B1/B0 indipendenti: %s" % ("IDENTICI" if bad == 0 else "%d DIFFERENZE" % bad))
