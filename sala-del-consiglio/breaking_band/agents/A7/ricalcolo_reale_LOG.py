#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ricalcolo_reale_LOG.py - V12/V13 sul run REALE (autorizzato da C0): ricalcolo indipendente di TUTTI i trade del LOG_TRADE
di final/run1/primario.json partendo dalle M1 reali (letture con verifica_generica.load_m1_csv; spread 0 sostituito con
replace_zero_spread scritto da A7). Per ogni trade ricostruisce da zero: ingresso, uscita, motivo, pnl, R; verifica anche i
LIVELLI (ATR(14) a barra j -> stop a 3 ATR dal fill; SMA20 alla chiusura della barra j e delle barre j+r*m) con le MIE
barre H1/M30 e i MIEI indicatori. Confronta n/win/PF/media R per cella con T2. Uso:
python3 -I ricalcolo_reale_LOG.py <primario.json> <cartella_csv> [--stampa-trace N]"""
import json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import verifica_generica as VG

FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
MOT = {"SL": "stop", "TP": "target", "MKT": "mkt", "TF": "forced", "FINE_DATI": "end_of_data"}

def main():
    js = json.load(open(sys.argv[1])); folder = sys.argv[2]
    n_trace = int(sys.argv[sys.argv.index("--stampa-trace") + 1]) if "--stampa-trace" in sys.argv else 0
    LOG = js["tabelle"]["LOG_TRADE"]; T2 = js["tabelle"]["T2_risultati"]
    res_all = {}; livelli_max = {"stop": 0.0, "target0": 0.0, "ricalcoli": 0.0}; ndiff = 0; ntot = 0; trace_txt = []
    for per, fn in FILES.items():
        m1 = VG.load_m1_csv(os.path.join(folder, fn))
        m1, zmask = VG.replace_zero_spread(m1)
        for tf in (60, 30):
            bars = VG.aggregate_m1(m1, tf, min_m1=1)
            atr = VG.atr_wilder(bars["high"], bars["low"], bars["close"], 14)
            sma = np.full(len(bars["close"]), np.nan)
            for i in range(19, len(sma)):
                sma[i] = bars["close"][i - 19:i + 1].mean()
            r_ric = 3 if tf == 60 else 6
            for var in ("CONT", "INV"):
                key = "%s_%s_%s" % (var, "H1" if tf == 60 else "M30", per)
                tr = LOG.get(key, [])
                eng, rec = [], []
                for t in tr:
                    j = t["j"]; side = t["side"]
                    # --- livelli indipendenti
                    fill_entry = t["entry"]
                    stop_mio = fill_entry - side * 3.0 * atr[j]
                    livelli_max["stop"] = max(livelli_max["stop"], abs(stop_mio - t["stop"]))
                    livelli_max["target0"] = max(livelli_max["target0"], abs(sma[j] - t["targets"][0][1]))
                    tg_mio = [(bars["time"][j] + tf, sma[j])]
                    for k, (mt, lv) in enumerate(t["targets"][1:], start=1):
                        livelli_max["ricalcoli"] = max(livelli_max["ricalcoli"], abs(sma[j + r_ric * k] - lv))
                    spec = {"direction": side, "entry_time": int(bars["time"][j]) + tf, "stop": t["stop"], "targets": t["targets"]}
                    r = VG.simulate_trade(m1, spec, spread_model="executable", max_entry_gap_min=180)
                    eng.append({"entry_time": t["entry_time"], "entry_price": t["entry"], "exit_time": t["exit_time"], "exit_price": t["exit"],
                                "exit_reason": MOT[t["motivo"]], "pnl": t["R"] * t["rischio"]})
                    rec.append(r)
                    if len(trace_txt) < n_trace and tf == 60:
                        trace_txt.append("=== %s trade j=%d side=%+d stop=%.4f targets=%s\n%s" % (key, j, side, t["stop"], t["targets"][:4], VG.trace_trade(m1, r, spec, before=1, after=0, max_rows=14)))
                if not tr:
                    res_all[key] = {"n": 0, "wins": 0, "pf": float("nan"), "media_R": float("nan")}
                    continue
                cmp_ = VG.compare_with_engine(eng, rec, tol=1e-6)
                ntot += len(tr); ndiff += (0 if cmp_.passed else len(cmp_.data["diffs"]))
                Rm = [r["pnl"] / t["rischio"] for r, t in zip(rec, tr)]
                s = VG.summarize_pnls(Rm)
                res_all[key] = {"n": s["n"], "wins": s["wins"], "pf": s["pf"], "media_R": float(np.mean(Rm)), "cmp": cmp_.status, "dett": cmp_.detail[:140]}
                print("%-14s n=%2d  %s | %s" % (key, len(tr), cmp_.status, cmp_.detail[:120]), flush=True)
    print("\nLIVELLI: max |stop_mio - stop_A4| = %.2e USD ; max |SMA20_mia(j) - target0| = %.2e ; max |SMA20 ricalcolata - schedule| = %.2e" % (livelli_max["stop"], livelli_max["target0"], livelli_max["ricalcoli"]))
    print("TRADE RICALCOLATI: %d, trade con differenze: %d" % (ntot, ndiff))
    # confronto n/wins/PF/media R con T2
    print("\nCONFRONTO CON T2 (n, vincite, PF netto, attesa R)")
    bad = 0
    for key, v in res_all.items():
        t2 = T2.get(key)
        if t2 is None:
            print(key, "assente in T2"); bad += 1; continue
        pf2 = t2["pf_netto"]; pf2 = float("inf") if pf2 == "inf" else pf2
        okn = (v["n"] == t2["n"]); okw = (v["wins"] == t2["vincite"] if v["n"] else True)
        okp = (v["n"] == 0) or (v["pf"] == pf2) or (v["pf"] == v["pf"] and pf2 == pf2 and abs(v["pf"] - pf2) <= 1e-9 * max(1, abs(pf2)))
        okm = (v["n"] == 0) or abs(v["media_R"] - t2["attesa_R"]) < 1e-9
        if not (okn and okw and okp and okm):
            bad += 1
            print("DIFF", key, v, {k: t2[k] for k in ("n", "vincite", "pf_netto", "attesa_R")})
    print("celle con differenze rispetto a T2: %d su %d" % (bad, len(res_all)))
    for tx in trace_txt:
        print("\n" + tx)
    return 0 if (ndiff == 0 and bad == 0) else 1

if __name__ == "__main__":
    sys.exit(main())
