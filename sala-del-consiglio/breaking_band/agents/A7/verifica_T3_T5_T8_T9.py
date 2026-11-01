#!/usr/bin/env python3
"""Ricalcolo indipendente (dal LOG_TRADE e dalle M1) di T5 (media, PF, senza i 3 migliori, leave-one-period-out, quota profitto, bootstrap per
settimana con stessa procedura/seme), T8 (deriva) e T9 (spread 0 sostituiti, scarti) di primario.json. Uso: python3 -I verifica_T3_T5_T8_T9.py <json> <csv_dir>"""
import json, os, sys
import numpy as np
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import verifica_generica as VG
FILES = {"2013": "ABTG_M1_XAUUSD_2013.csv", "2018": "ABTG_M1_XAUUSD_2018.csv", "2020": "ABTG_M1_XAUUSD_2020.csv", "2025-26": "ABTG_M1_XAUUSD.csv"}
js = json.load(open(sys.argv[1])); folder = sys.argv[2]; T = js["tabelle"]; LOG = T["LOG_TRADE"]
prim = [dict(t, periodo=per) for per in FILES for var in ("CONT", "INV") for t in LOG["%s_H1_%s" % (var, per)]]
R = np.array([t["R"] for t in prim]); bad = []
def chk(nome, a, b, tol=1e-9):
    ok = (a == b) if isinstance(a, (int, str)) or a is None or b is None else abs(a - b) <= tol * max(1, abs(a))
    print("  %-46s A4=%-22s A7=%-22s %s" % (nome, a, b, "OK" if ok else "DIVERSO")); 
    if not ok: bad.append(nome)
pf = lambda x: (sum(v for v in x if v > 0) / -sum(v for v in x if v < 0)) if any(v < 0 for v in x) else float("inf")
T5 = T["T5_robustezza"]
print("T5")
chk("con_tutti n", T5["con_tutti"]["n"], len(prim)); chk("con_tutti media_R", T5["con_tutti"]["media_R"], float(R.mean())); chk("con_tutti PF", T5["con_tutti"]["pf_netto"], pf(R))
resto = sorted(prim, key=lambda t: -t["R"])[3:]
chk("senza i 3 migliori: media", T5["senza_i_migliori_3"]["media_R"], float(np.mean([t["R"] for t in resto]))); chk("senza i 3 migliori: PF", T5["senza_i_migliori_3"]["pf_netto"], pf([t["R"] for t in resto]))
for per in FILES:
    r_ = [t["R"] for t in prim if t["periodo"] != per]
    chk("LOPO senza %s: media" % per, T5["leave_one_period_out"][per]["media_R"], float(np.mean(r_))); chk("LOPO senza %s: PF" % per, T5["leave_one_period_out"][per]["pf_netto"], pf(r_))
# bootstrap per settimane: stessa definizione (settimana = (giorno_epoca+3)//7 su entry_time), seme 20261101, 10000 replicati
sett = sorted(set((t["entry_time"] // 1440 + 3) // 7 for t in prim)); idx = {w: k for k, w in enumerate(sett)}
somma = np.zeros(len(sett)); cnt = np.zeros(len(sett))
for t in prim:
    k = idx[(t["entry_time"] // 1440 + 3) // 7]; somma[k] += t["R"]; cnt[k] += 1
rng = np.random.default_rng(20261101); K = len(sett); sel = rng.integers(0, K, size=(10000, K)); m = somma[sel].sum(axis=1) / cnt[sel].sum(axis=1)
lo, hi = np.quantile(m, [0.05, 0.95])
b = T5["bootstrap_settimane"]
chk("bootstrap settimane K", b["settimane"], K); chk("bootstrap IC90 lo", b["ic90_lo"], float(lo)); chk("bootstrap IC90 hi", b["ic90_hi"], float(hi))
# T8 deriva e T9 spread zero
print("T8/T9")
for per, fn in FILES.items():
    m0 = VG.load_m1_csv(os.path.join(folder, fn)); n0 = int((m0.sp_pts == 0).sum())
    m1, z = VG.replace_zero_spread(m0); bars = VG.aggregate_m1(m1, 60)
    atr = VG.atr_wilder(bars["high"], bars["low"], bars["close"], 14)
    chk("T9 spread0 sostituiti %s" % per, T["T9_dati_esecuzione"]["spread0_sostituiti_per_periodo"][per], n0)
    chk("T8 buy&hold in ATR %s (tol 2e-4: mediana ATR, seme diverso)" % per, T["T8_deriva"][per]["buy_and_hold_in_ATR"], float((bars["close"][-1] - bars["close"][0]) / np.nanmedian(atr)), 2e-4)
    tr = [t for t in prim if t["periodo"] == per]
    chk("T8 n long %s" % per, T["T8_deriva"][per]["long"]["n"], sum(1 for t in tr if t["side"] == 1))
V = T["VERDETTO"]
print("VERDETTO:", V["esito"], "N=", V["N"], "media_R=%.4f" % V["media_R"], "PF=%.4f" % V["pf_netto"], "p_B1=%.4f" % V["p_B1"])
chk("VERDETTO N", V["N"], len(prim)); chk("VERDETTO media_R", V["media_R"], float(R.mean())); chk("VERDETTO esito coerente con N<30 -> INCONCLUSIVO", V["esito"], "INCONCLUSIVO" if len(prim) < 30 else V["esito"])
print("\nDIFFERENZE:", len(bad)); sys.exit(0 if not bad else 1)
