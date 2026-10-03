#!/usr/bin/env python3
# =====================================================================
#  bulge_analisi_contratto.py -- SOLA LETTURA. Rifa' i numeri del dossier
#  report/BULGE_COME_MIGLIORARLO_2026-10-03.md dai file del repo.
#  Non scrive niente, non tocca MT5, non propone nessuna taglia.
#  Seme delle permutazioni: 20261003. Uso (dalla radice del repo):
#      python3 backtest_pipeline/bulge_analisi_contratto.py
#  Fonti: data/statements/trades_auto.csv (forward BCM 50503392),
#         backtest_pipeline/risultati_archivio/ROUND_R92BAB_20261001_2201/PERTRADE/
#         (per-trade v5.20 AMPIA, Modello 1, gamba OOS 2026.05.04-06.29).
# =====================================================================
import collections
import csv
import datetime
import itertools
import os
import random
import statistics as st

RADICE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TRADES = os.path.join(RADICE, "data", "statements", "trades_auto.csv")
PERTR = os.path.join(RADICE, "backtest_pipeline", "risultati_archivio",
                     "ROUND_R92BAB_20261001_2201", "PERTRADE")
T15 = "NZDUSD,USDCAD,USDCHF,EURGBP,EURNZD,GBPAUD,GBPNZD,AUDJPY,AUDCAD,AUDNZD,NZDJPY,NZDCAD,NZDCHF,CADJPY,CADCHF".split(",")
FMT = "%Y.%m.%d %H:%M:%S"
random.seed(20261003)


def netto(r):
    return float(r["profit"]) + float(r["commission"]) + float(r["swap"])


def riassunto(etichetta, valori):
    n = len(valori)
    w = [v for v in valori if v > 0]
    l = [v for v in valori if v <= 0]
    gp, gl = sum(w), -sum(l)
    pf = gp / gl if gl else float("nan")
    aw = gp / len(w) if w else 0.0
    al = gl / len(l) if l else 0.0
    be = (al / (aw + al) * 100) if (aw + al) else float("nan")
    print("%-28s n %4d  vinte %3d (%.1f%%)  netto %9.2f  PF %.2f  vincita media %.2f  perdita media %.2f  payoff %.3f  WR di pareggio %.1f%%"
          % (etichetta, n, len(w), 100.0 * len(w) / n if n else 0, sum(valori), pf, aw, al, aw / al if al else 0, be))


def main():
    rows = list(csv.DictReader(open(TRADES, encoding="utf-8"), delimiter=";"))
    ant = [r for r in rows if "BULGE_MULTI" in r["strategy"]]
    v520 = [r for r in rows if "V520" in r["strategy"]]
    print("== FORWARD BCM (trades_auto.csv) ==")
    riassunto("antenato BULGE_MULTI", [netto(r) for r in ant])
    riassunto("  solo BLU", [netto(r) for r in ant if "BLU" in r["strategy"]])
    riassunto("  solo VIOLA", [netto(r) for r in ant if "VIOLA" in r["strategy"]])
    riassunto("v5.20 (tutte)", [netto(r) for r in v520])
    riassunto("  v5.20 VIOLA", [netto(r) for r in v520 if "VIOLA" in r["strategy"]])
    riassunto("  v5.20 BLU", [netto(r) for r in v520 if "BLU" in r["strategy"]])
    lordo = [float(r["profit"]) for r in ant]
    print("antenato: lordo (solo profit) %.2f  commissioni %.2f  swap %.2f  -> PF lordo %.2f"
          % (sum(lordo), sum(float(r["commission"]) for r in ant), sum(float(r["swap"]) for r in ant),
             sum(x for x in lordo if x > 0) / -sum(x for x in lordo if x <= 0)))

    # --- durata in posizione (ATTENZIONE: la durata dipende dall'esito, vedi dossier par. 2.6)
    def ore(r):
        return (datetime.datetime.strptime(r["close_time"], FMT) - datetime.datetime.strptime(r["open_time"], FMT)).total_seconds() / 3600.0
    for nome, f in (("<=4h", lambda h: h <= 4), ("4-12h", lambda h: 4 < h <= 12), ("12-24h", lambda h: 12 < h <= 24), (">24h", lambda h: h > 24)):
        riassunto("tenuta " + nome, [netto(r) for r in ant if f(ore(r))])

    # --- blocchi di ora d'ingresso (ora server BCM) e permutazione
    nets = [netto(r) for r in ant]
    idx = [i for i, r in enumerate(ant) if 8 <= int(r["open_time"][11:13]) < 13]
    obs = sum(nets[i] for i in idx)
    N = 20000
    c = sum(1 for _ in range(N) if sum(random.sample(nets, len(idx))) <= obs)
    print("ingresso 08-13 server: n %d netto %.2f  p(sottoinsieme a caso <= osservato) = %.3f  (blocco scelto DOPO aver guardato 4 blocchi)" % (len(idx), obs, c / N))

    # --- SL alle 13:30 server BCM (rilascio dati USA)
    sl = [r for r in rows if "BULGE" in r["strategy"].upper() and r["close_reason"] == "sl"]
    print("SL del Bulge: %d, di cui alle 13:30: %d" % (len(sl), sum(1 for r in sl if r["close_time"][11:16] == "13:30")))

    # --- concordanza di perdita fra ingressi della stessa ora H1
    def expo(r):
        s = r["symbol"]
        b, q = s[:3], s[3:]
        buy = r["side"] == "buy"
        return {b: 1 if buy else -1, q: -1 if buy else 1}
    byh = collections.defaultdict(list)
    for r in ant:
        byh[r["open_time"][:13]].append(r)
    cl = {"stesso segno": [0, 0], "segno opposto": [0, 0], "nessuna valuta": [0, 0]}
    for v in byh.values():
        for a, b in itertools.combinations(v, 2):
            if a["symbol"] == b["symbol"]:
                continue
            ea, eb = expo(a), expo(b)
            same = any(k in eb and ea[k] == eb[k] for k in ea)
            opp = any(k in eb and ea[k] != eb[k] for k in ea)
            k = "stesso segno" if same and not opp else "segno opposto" if opp and not same else "nessuna valuta" if not same and not opp else None
            if k:
                cl[k][0] += 1
                cl[k][1] += (netto(a) <= 0 and netto(b) <= 0)
    tasso = sum(1 for r in ant if netto(r) <= 0) / len(ant)
    print("tasso di perdita %.3f -> doppia perdita attesa se indipendenti %.3f" % (tasso, tasso * tasso))
    for k, (n, b) in cl.items():
        print("  coppie %-15s n %3d  entrambe perse %2d (%.1f%%)" % (k, n, b, 100.0 * b / n if n else 0))

    # --- per-trade v5.20 AMPIA, Modello 1, OOS (magic 799401)
    print("\n== BACKTEST v5.20 AMPIA, Modello 1, OOS 2026.05.04-06.29 (R92BAB_A, magic 799401) ==")
    A = list(csv.DictReader(open(os.path.join(PERTR, "abtg_trades_ABTG_Bulge_GBPUSD_799401_violaEA.csv"), encoding="utf-8"), delimiter=";"))
    A2 = list(csv.DictReader(open(os.path.join(PERTR, "abtg_trades_ABTG_Bulge_GBPUSD_799441_violaEA.csv"), encoding="utf-8"), delimiter=";"))
    print("A e A2 identici nei netti:", [r["net_profit"] for r in A] == [r["net_profit"] for r in A2], " n =", len(A))
    pa = [float(r["net_profit"]) for r in A]
    riassunto("tutte", pa)
    for s in ("VIOLA", "BLU", "ARANCIO"):
        riassunto("  " + s, [float(r["net_profit"]) for r in A if r["signal"] == s])
    riassunto("VIOLA sui 15 cross trial", [float(r["net_profit"]) for r in A if r["signal"] == "VIOLA" and r["symbol"] in T15])
    w = sorted(x for x in pa if x > 0)
    print("quantili vincite (decili):", [round(x, 1) for x in st.quantiles(w, n=10)], " vincite < 10:", sum(1 for x in w if x < 10), "su", len(w))
    syms = [r["symbol"] for r in A]

    def disp(pairs):
        d = collections.defaultdict(float)
        for s, p in pairs:
            d[s] += p
        v = list(d.values())
        return st.pstdev(v), sum(sorted(v)[:4])
    o = disp(list(zip(syms, pa)))
    c1 = c2 = 0
    sh = syms[:]
    for _ in range(5000):
        random.shuffle(sh)
        d = disp(list(zip(sh, pa)))
        c1 += d[0] >= o[0]
        c2 += d[1] <= o[1]
    print("dispersione per cross (dev.std %.1f, peggiori 4 %.1f): p(dev.std>=oss)=%.3f  p(peggiori4<=oss)=%.3f" % (o[0], o[1], c1 / 5000, c2 / 5000))
    k = sum(1 for s in syms if "NZD" in s)
    obsn = sum(p for s, p in zip(syms, pa) if "NZD" in s)
    cc = sum(1 for _ in range(5000) if sum(random.sample(pa, k)) <= obsn)
    print("cross NZD: n %d netto %.1f su totale %.1f: p(sottoinsieme a caso <= osservato) = %.3f (8 valute guardate: x8 per Bonferroni)" % (k, obsn, sum(pa), cc / 5000))
    g = collections.defaultdict(list)
    for r in A:
        g[(r["symbol"], r["close_time"])].append(r)
    dup = [v for v in g.values() if len(v) > 1]
    print("stessa coppia e stesso istante di chiusura: %d gruppi, %d posizioni, netto %.1f" % (len(dup), sum(len(v) for v in dup), sum(float(r["net_profit"]) for v in dup for r in v)))


if __name__ == "__main__":
    main()
