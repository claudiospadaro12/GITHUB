#!/usr/bin/env python3
"""controlli_finali_log.py - V09 (nessuna sovrapposizione per variante), V07 (eventi stop+target stesso minuto vs T9), V16 (completezza celle/tabelle),
V15 (ordine temporale dei file), V17/T7 letture dal JSON. Uso: python3 -I controlli_finali_log.py <primario.json> <csv_dir>"""
import json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import verifica_generica as VG
BB = os.path.abspath(os.path.join(HERE, "..", ".."))
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
js = json.load(open(sys.argv[1])); folder = sys.argv[2]; T = js["tabelle"]; LOG = T["LOG_TRADE"]
bad = []
# V09 + V07 (ricalcolo dei both_touched)
nboth = 0; nov = 0; nbarra_succ = 0; ntr = 0
for per, fn in FILES.items():
    m1 = VG.load_m1_csv(os.path.join(folder, fn)); m1, _ = VG.replace_zero_spread(m1)
    for tf in (60, 30):
        bars = VG.aggregate_m1(m1, tf)
        for var in ("CONT", "INV"):
            tr = LOG["%s_%s_%s" % (var, "H1" if tf == 60 else "M30", per)]
            trades = [{"entry_time": t["entry_time"], "exit_time": t["exit_time"], "signal_known_time": int(bars["time"][t["j"]]) + tf} for t in tr]
            if len(trades) >= 2:
                r = VG.check_no_overlap(trades, signal_key="signal_known_time")
                if not r.passed: bad.append("V09 %s %s %s: %s" % (var, tf, per, r.detail)); nov += 1
            for t in tr:
                ntr += 1
                spec = {"direction": t["side"], "entry_time": int(bars["time"][t["j"]]) + tf, "stop": t["stop"], "targets": t["targets"]}
                rr = VG.simulate_trade(m1, spec, max_entry_gap_min=180)
                nboth += int(rr["both_touched"])
                # ingresso = prima M1 non anteriore alla fine nominale della barra segnale
                if t["entry_time"] < int(bars["time"][t["j"]]) + tf: bad.append("entry anticipata")
print("V09: %d trade, celle (variante x TF x periodo) con sovrapposizioni o segnale noto con trade aperto: %d" % (ntr, nov))
t9 = T["T9_dati_esecuzione"]["primaria_H1"]
print("V07: eventi stop+target nella stessa M1 nel ricalcolo (tutti i 92 trade) = %d ; T9 (H1) = %d" % (nboth, t9["eventi_sl_tp_stesso_minuto"]))
# V16 completezza
T2 = T["T2_risultati"]; need = ["%s_%s_%s" % (v, tf, p) for v in ("CONT", "INV") for tf in ("H1", "M30") for p in FILES] + ["%s_%s_TOTALE" % (v, tf) for v in ("CONT", "INV") for tf in ("H1", "M30")] + ["POOLED_H1", "POOLED_M30"]
miss = [k for k in need if k not in T2]
m15 = [k for k in list(T2) + list(T["T1_imbuto"]) if "M15" in k]
sens = sorted(T["T6_sensibilita"]); tabs = sorted(T)
print("V16: celle T2 attese %d, mancanti %s ; chiavi M15 presenti %s ; sensibilita %s ; tabelle %s" % (len(need), miss, m15, sens, [k for k in tabs]))
need_T = {"LOG_TRADE", "T1_imbuto", "T2_risultati", "T3_fasce", "T4_linea_di_base", "T5_robustezza", "T6_sensibilita", "T7_placebo", "T8_deriva", "T9_dati_esecuzione", "VERDETTO"}
if miss or m15 or need_T - set(tabs) or set(sens) != {"Sa", "Sb", "Sc", "Sd", "Se20", "Se50", "Sf", "Sg"}: bad.append("V16 incompleta")
if any(k not in T["T4_linea_di_base"] for k in ("B1", "B0", "B2")): bad.append("V16 B1/B0/B2")
print("V16 celle con n=0 presenti nel report:", [k for k in need if k in T2 and T2[k].get("n", 0) == 0])
# T7
print("T7 placebo (dal run):")
for k, v in T["T7_placebo"].items():
    if isinstance(v, dict): print("   %-10s n=%s esito=%s z=%s lordo=%s" % (k, v.get("n"), v.get("esito"), v.get("z_lordo"), v.get("lordo_medio_R")))
# V15 mtime
fs = {"specifica": os.path.join(BB, "congelati/specifica_v1.md"), "criteri": os.path.join(BB, "congelati/criteri_previsioni_v1.md"), "HASH_DOCUMENTI": os.path.join(BB, "congelati/HASH_DOCUMENTI.txt"),
      "HASH_DATI": os.path.join(BB, "congelati/HASH_DATI.txt"), "HASH_CODICE": os.path.join(BB, "congelati/HASH_CODICE.txt"), "primario.json": os.path.join(BB, "final/run1/primario.json")}
import time
for k, p in sorted(fs.items(), key=lambda kv: os.path.getmtime(kv[1])): print("   mtime %-15s %s" % (k, time.strftime("%H:%M:%S", time.gmtime(os.path.getmtime(p)))))
ev = os.path.join(BB, "events.jsonl"); print("events.jsonl presente:", os.path.exists(ev))
if os.path.exists(ev):
    for ln in open(ev):
        if "hash" in ln.lower() or "HASH" in ln: print("   ", ln.strip()[:240])
print("\nPROBLEMI:", bad); sys.exit(0 if not bad else 1)
