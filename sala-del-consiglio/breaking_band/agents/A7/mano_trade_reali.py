import json, os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import verifica_generica as VG
js = json.load(open(sys.argv[1])); folder = sys.argv[2]
LOG = js["tabelle"]["LOG_TRADE"]
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
want = [("CONT_H1_2013", "SL"), ("CONT_H1_2013", "TP"), ("CONT_H1_2020", "MKT"), ("INV_H1_2025-26", "TP"), ("CONT_M30_2018", "SL"), ("INV_M30_2018", "SL")]
cache = {}
for key, mot in want:
    var, tf, per = key.split("_", 2)
    t = [x for x in LOG[key] if x["motivo"] == mot]
    if not t: print(key, mot, "nessun trade"); continue
    t = t[0]
    if per not in cache:
        m, _ = VG.replace_zero_spread(VG.load_m1_csv(os.path.join(folder, FILES[per]))); cache[per] = m
    m = cache[per]
    e = int(np.searchsorted(m.t, t["entry_time"])); x = int(np.searchsorted(m.t, t["exit_time"]))
    print("\n##", key, mot, "side", t["side"], "j", t["j"], "R=%.4f" % t["R"])
    print("schedule target:", [(VG.minutes_to_str(a), round(b, 4)) for a, b in t["targets"]], "stop", round(t["stop"], 4))
    for i in (e, x - 1, x):
        print("  idx %d %s O=%.2f H=%.2f L=%.2f C=%.2f spr=%.2f" % (i, VG.minutes_to_str(m.t[i]), m.o[i], m.h[i], m.l[i], m.c[i], m.spread[i]))
    print("  A4: entry=%.4f exit=%.4f exit_time=%s motivo=%s" % (t["entry"], t["exit"], VG.minutes_to_str(t["exit_time"]), t["motivo"]))
