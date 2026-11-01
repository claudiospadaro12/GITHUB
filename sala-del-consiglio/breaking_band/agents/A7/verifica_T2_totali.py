import json, sys, numpy as np
js = json.load(open(sys.argv[1])); T2 = js["tabelle"]["T2_risultati"]; LOG = js["tabelle"]["LOG_TRADE"]
P = ["2013", "2018", "2020", "2025-26"]
def pf(x):
    g = sum(v for v in x if v > 0); l = -sum(v for v in x if v < 0)
    return g / l if l > 0 else float("inf")
bad = 0
for tf in ("H1", "M30"):
    cells = {"%s_%s_TOTALE" % (v, tf): [t["R"] for p in P for t in LOG["%s_%s_%s" % (v, tf, p)]] for v in ("CONT", "INV")}
    cells["POOLED_" + tf] = cells["CONT_%s_TOTALE" % tf] + cells["INV_%s_TOTALE" % tf]
    for k, R in cells.items():
        c = T2[k]; pf2 = float("inf") if c["pf_netto"] == "inf" else c["pf_netto"]
        ok = (c["n"] == len(R) and c["vincite"] == sum(1 for r in R if r > 0) and abs(c["attesa_R"] - np.mean(R)) < 1e-9 and (pf(R) == pf2 or abs(pf(R) - pf2) < 1e-9) and abs(c["netto_R"] - sum(R)) < 1e-9)
        bad += not ok
        print("%-14s n=%3d vincite=%3d media=%+.4f PF=%.4f  %s" % (k, len(R), sum(1 for r in R if r > 0), np.mean(R), pf(R), "OK" if ok else "DIVERSO"))
print("celle TOTALE/POOLED con differenze:", bad)
