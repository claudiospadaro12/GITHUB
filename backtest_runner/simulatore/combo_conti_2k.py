#!/usr/bin/env python3
# Scenari per 3 conti da 2.000 EUR a partire dai risultati GIA misurati (tester BCM, 4.000 EUR forex per anno; trio oro 3.745 EUR, 21 mesi). Nessun nuovo test.
import json, sys
R = json.load(open("report/FOREX_4K_dati/forex4k_res.json"))
G = json.load(open("report/ORO_REALE21_dati/r21_agg.json"))
ANNI = [2013, 2017, 2020, 2022, 2025]
S = {"STAB_low": "STAB_stabilityprolowriskset", "STAB_mlow": "STAB_stabilitypromediumlowriskset",
     "DTP_9": "DTP_DaytradeProMax9DDlowrisk", "DTP_20": "DTP_DaytradeProMax20DDmediumrisk", "DTP_50": "DTP_DaytradeProMax50DDhighrisk",
     "LUNA_4DD": "LUNA_Luna4DD", "LUNA_low": "LUNA_LunaAIrecommendedlowrisk",
     "APEX_cons": "APEX_ApexConservativeGrid", "APEX_elev": "APEX_ApexElevatedGrid"}
COMBI = {"A prudente": ["STAB_low", "DTP_9", "LUNA_4DD"],
         "B medio": ["STAB_low", "DTP_20", "LUNA_4DD", "APEX_cons"],
         "C alto": ["STAB_mlow", "DTP_50", "LUNA_low", "APEX_elev"]}
def get(k, y):
    return R["%s_%d" % (S[k], y)]
out = []
for nome, es in COMBI.items():
    n = len(es); out.append("### Combinazione %s: %s" % (nome, " + ".join(es)))
    out.append("| Anno | Netto somma (EUR, 4k a EA) | Scenario A: lotti proporzionali (EUR su 2k) | Scenario B: lotto minimo fisso (EUR su 2k) | DD somma (EUR) | DD somma vs 2.000 |")
    out.append("|---|---|---|---|---|---|")
    tot_a = tot_b = 0
    for y in ANNI:
        net = sum(get(k, y)["net"] for k in es); dd = sum(get(k, y)["ddE"] for k in es)
        a = net / (2 * n); b = net; tot_a += a; tot_b += b
        out.append("| %d | %+.0f | %+.0f (%+.0f%%) | %+.0f (%+.0f%%) | %.0f | %.0f%% |" % (y, net, a, a / 20, b, b / 20, dd, dd / 20))
    out.append("| **Media/anno** | | **%+.0f** | **%+.0f** | | |" % (tot_a / 5, tot_b / 5)); out.append("")
out.append("### Gamba oro (trio Reaper+Phantom+Goldbot di Wim, conto da 3.745, 01/2025-10/2026 = 21 mesi)")
out.append("| Livello | Modello | Netto 21 mesi (EUR) | Netto/12 mesi semplice (EUR) | DD limite superiore (EUR, somma dei 3 EA) | DD vs 2.000 |")
out.append("|---|---|---|---|---|---|")
for k in ["1|L3", "4|L3", "1|L0", "1|L1", "4|L1", "1|L2", "4|L2"]:
    if k in G:
        g = G[k]; m = "barre 1 min" if k[0] == "1" else "tick reali"
        out.append("| %s | %s | %+.0f | %+.0f | %.0f | %.0f%% |" % (k[2:], m, g["net"], g["net"] / 21 * 12, g["bound"], g["bound"] / 20))
print("\n".join(out))
