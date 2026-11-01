#!/usr/bin/env python3
"""effetto_ER_esatta.py - il pareggio ER == 0,50 (B4) e sensibile all'aritmetica in virgola mobile (prezzi a 2 decimali:
ER=890/1780 esatto). Questo script ricalcola B4 con aritmetica INTERA (centesimi) nella MIA reimplementazione e confronta i
segnali (H1 e M30, 4 periodi) con quelli del run primario (LOG_TRADE) e con la reimplementazione in virgola mobile.
Non modifica il codice di A4. Uso: python3 -I effetto_ER_esatta.py <primario.json> <cartella_csv>"""
import inspect, json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import verifica_generica as VG, reimpl_segnali as R
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
src = inspect.getsource(R._arm_check)
old = "    den = float(np.sum(np.abs(np.diff(v.c[s:t + 1])))) if t > s else 0.0\n    B4 = bool(den > 0 and abs(v.c[t] - v.c[s]) / den >= cfg.b4_er and v.c[t] > v.c[s])"
new = ("    ci = np.round(v.c[s:t + 1] * 100).astype(np.int64)\n    den_i = int(np.abs(np.diff(ci)).sum()) if t > s else 0\n"
       "    B4 = bool(den_i > 0 and 2 * abs(int(ci[-1] - ci[0])) >= den_i and ci[-1] > ci[0])")
assert old in src
ns = dict(R.__dict__); exec(src.replace(old, new), ns)
exact_fn = ns["_arm_check"]; float_fn = R._arm_check
js = json.load(open(sys.argv[1])); LOG = js["tabelle"]["LOG_TRADE"]; folder = sys.argv[2]
tot_diff = 0
for per, fn in FILES.items():
    m1 = VG.load_m1_csv(os.path.join(folder, fn)); m1, _ = VG.replace_zero_spread(m1)
    for tf, tfn in ((60, "H1"), (30, "M30")):
        bars = VG.aggregate_m1(m1, tf)
        R._arm_check = float_fn; a = R.detect(bars)
        R._arm_check = exact_fn; b = R.detect(bars)
        R._arm_check = float_fn
        sa = sorted((s["bar"], s["side"], s["tipo"]) for s in a["signals"]); sb = sorted((s["bar"], s["side"], s["tipo"]) for s in b["signals"])
        log_sig = sorted((t["j"], t["side"], t["variante"]) for var in ("CONT", "INV") for t in LOG["%s_%s_%s" % (var, tfn, per)])
        # i segnali scartati non sono nel LOG: confronto a insieme
        print("%-8s %-3s segnali A7(float)=%d A7(aritmetica esatta)=%d, uguali=%s, armati float/esatto=%d/%d" % (per, tfn, len(sa), len(sb), sa == sb, a["counters"]["armati"], b["counters"]["armati"]))
        tot_diff += (sa != sb)
print("\nCelle in cui l'aritmetica esatta CAMBIA i segnali: %d su 8" % tot_diff)
