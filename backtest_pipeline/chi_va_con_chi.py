#!/usr/bin/env python3
# =====================================================================
#  chi_va_con_chi.py -- COSTRUZIONE DI PORTAFOGLIO: quali sedie si
#  possono schierare INSIEME senza annullarsi a vicenda.
# ---------------------------------------------------------------------
#  Nasce da report/ANOMALIE_PICCOLO_2026-09-11.md: 25 posizioni su 83
#  hanno passato del tempo sovrapposte a una posizione OPPOSTA sullo
#  stesso simbolo. Qui si misura, coppia per coppia:
#    1. quante volte due sedie sono state aperte in direzioni opposte
#       sullo stesso simbolo, per quante ore, con che netto
#       (ogni POSIZIONE contata UNA VOLTA SOLA nel totale: contare le
#        coppie gonfia il numero - classe dichiarata nel referto)
#    2. gli ORIZZONTI delle due sedie (durata mediana): orizzonti
#       diversi = copertura possibile, non conflitto
#    3. la correlazione dei P/L giornalieri fra sedie (stesso metodo di
#       dd_portafoglio.py, R16)
#    4. il rischio aperto simultaneo per CLUSTER (simbolo) contro il
#       cap del 3,0% firmato il 07/09 (firmato, NON attivo)
#    5. un test di permutazione sul netto del gruppo sovrapposto
#  SOLA LETTURA. Nessun backtest, nessun parametro toccato.
# =====================================================================
import csv, argparse, random, itertools
from collections import defaultdict
from datetime import datetime

FMT = "%Y.%m.%d %H:%M:%S"


def leggi(path, da, a, solo_ea=True):
    pos = []
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        for r in csv.DictReader(f, delimiter=";"):
            magic = (r.get("magic") or "0").strip()
            if solo_ea and magic in ("", "0"):
                continue
            try:
                o = datetime.strptime(r["open_time"].strip(), FMT)
                c = datetime.strptime(r["close_time"].strip(), FMT)
            except (ValueError, KeyError):
                continue
            g = c.strftime("%Y.%m.%d")
            if da and g < da:
                continue
            if a and g > a:
                continue
            netto = (float(r["commission"] or 0) + float(r["swap"] or 0)
                     + float(r["profit"] or 0))
            pos.append({
                "pid": r["pid"], "magic": magic, "symbol": r["symbol"],
                "side": r["side"].strip().lower(), "open": o, "close": c,
                "netto": netto, "profit": float(r["profit"] or 0),
                "strategy": (r.get("strategy") or "").strip(),
                "vol": float(r["volume"] or 0),
            })
    return pos


def sovrapp(p, q):
    """minuti di sovrapposizione temporale fra due posizioni."""
    a = max(p["open"], q["open"])
    b = min(p["close"], q["close"])
    return (b - a).total_seconds() / 60.0 if b > a else 0.0


def correlazione(a, b):
    n = len(a)
    if n < 2:
        return float("nan")
    ma, mb = sum(a) / n, sum(b) / n
    va = sum((x - ma) ** 2 for x in a)
    vb = sum((x - mb) ** 2 for x in b)
    if va == 0 or vb == 0:
        return float("nan")
    cov = sum((a[i] - ma) * (b[i] - mb) for i in range(n))
    return cov / (va ** 0.5 * vb ** 0.5)


def mediana(v):
    if not v:
        return float("nan")
    s = sorted(v)
    n = len(s)
    return s[n // 2] if n % 2 else (s[n // 2 - 1] + s[n // 2]) / 2.0


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("csv")
    ap.add_argument("--da", default="2026.08.25")
    ap.add_argument("--a", default="2026.09.11")
    ap.add_argument("--perm", type=int, default=20000)
    ap.add_argument("--seed", type=int, default=42)
    ap.add_argument("--rischio", type=float, default=0.65)
    args = ap.parse_args()

    tutte = leggi(args.csv, args.da, args.a, solo_ea=False)
    pos = [p for p in tutte if p["magic"] not in ("", "0")]
    print("=" * 72)
    print("CHI VA CON CHI  -- finestra %s -> %s" % (args.da, args.a))
    print("righe totali nella finestra: %d   di cui EA (magic!=0): %d"
          % (len(tutte), len(pos)))
    print("netto EA: %+.2f   (solo profit: %+.2f)"
          % (sum(p["netto"] for p in pos), sum(p["profit"] for p in pos)))
    print("=" * 72)

    # ---- 1. sovrapposizioni OPPOSTE, stesso simbolo -----------------
    opposte = []   # (i, j, minuti)
    coinvolte = set()
    for i, j in itertools.combinations(range(len(pos)), 2):
        p, q = pos[i], pos[j]
        if p["symbol"] != q["symbol"] or p["side"] == q["side"]:
            continue
        m = sovrapp(p, q)
        if m > 0:
            opposte.append((i, j, m))
            coinvolte.add(i)
            coinvolte.add(j)

    netto_sov = sum(pos[i]["netto"] for i in coinvolte)
    resto = [k for k in range(len(pos)) if k not in coinvolte]
    netto_res = sum(pos[k]["netto"] for k in resto)
    print("\n-- 1. POSIZIONI CON SOVRAPPOSIZIONE OPPOSTA (contate UNA VOLTA) --")
    print("  posizioni coinvolte : %d su %d (%.0f%%)"
          % (len(coinvolte), len(pos), 100.0 * len(coinvolte) / len(pos)))
    print("  netto del gruppo    : %+.2f" % netto_sov)
    print("  netto delle altre   : %+.2f  (n=%d)" % (netto_res, len(resto)))
    print("  episodi di coppia   : %d  (contarli tutti GONFIA il netto: %+.2f)"
          % (len(opposte),
             sum(pos[i]["netto"] + pos[j]["netto"] for i, j, _ in opposte)))
    per_sym = defaultdict(int)
    for k in coinvolte:
        per_sym[pos[k]["symbol"]] += 1
    print("  per simbolo         : %s"
          % ", ".join("%s %d" % (s, n)
                      for s, n in sorted(per_sym.items(), key=lambda x: -x[1])))
    per_magic = defaultdict(lambda: [0, 0.0])
    for k in coinvolte:
        per_magic[pos[k]["magic"]][0] += 1
        per_magic[pos[k]["magic"]][1] += pos[k]["netto"]
    print("  per sedia (pos, netto):")
    for m, (n, net) in sorted(per_magic.items(), key=lambda x: -x[1][0]):
        print("     %s  %2d pos  %+9.2f" % (m, n, net))

    # ---- 2. matrice per coppia di sedie ------------------------------
    print("\n-- 2. MATRICE DELLE SOVRAPPOSIZIONI OPPOSTE, per coppia --")
    coppie = defaultdict(lambda: {"episodi": 0, "min": 0.0, "pids": set(),
                                  "sym": set()})
    for i, j, m in opposte:
        a, b = sorted((pos[i]["magic"], pos[j]["magic"]))
        c = coppie[(a, b)]
        c["episodi"] += 1
        c["min"] += m
        c["pids"].update((i, j))
        c["sym"].add(pos[i]["symbol"])
    print("  %-9s %-9s %4s %8s %6s %10s  %s"
          % ("A", "B", "ep.", "ore", "pos", "netto", "simbolo"))
    for (a, b), c in sorted(coppie.items(), key=lambda kv: -kv[1]["min"]):
        net = sum(pos[k]["netto"] for k in c["pids"])
        print("  %-9s %-9s %4d %8.1f %6d %+10.2f  %s"
              % (a, b, c["episodi"], c["min"] / 60.0, len(c["pids"]), net,
                 ",".join(sorted(c["sym"]))))

    # ---- 2b. ORIZZONTI ----------------------------------------------
    print("\n-- 2b. ORIZZONTE DELLE SEDIE (durata in ore) --")
    dur = defaultdict(list)
    nomi = {}
    for p in pos:
        dur[p["magic"]].append((p["close"] - p["open"]).total_seconds() / 3600.0)
        if p["strategy"] and p["magic"] not in nomi:
            nomi[p["magic"]] = p["strategy"]
    for m in sorted(dur, key=lambda m: -mediana(dur[m])):
        v = dur[m]
        print("  %-9s n=%2d  mediana %7.2f h  min %6.2f  max %7.2f   %s"
              % (m, len(v), mediana(v), min(v), max(v), nomi.get(m, "?")[:34]))

    print("\n-- 2c. COPPIE: conflitto vero o orizzonti diversi? --")
    print("  (regola: rapporto fra le durate mediane >= 4x = orizzonti"
          " DIVERSI -> copertura possibile; < 4x = conflitto)")
    for (a, b), c in sorted(coppie.items(), key=lambda kv: -kv[1]["min"]):
        ma, mb = mediana(dur[a]), mediana(dur[b])
        rap = max(ma, mb) / min(ma, mb) if min(ma, mb) > 0 else float("inf")
        net = sum(pos[k]["netto"] for k in c["pids"])
        # copertura effettiva: quanto della vita della piu' corta sta
        # dentro la piu' lunga
        etich = "ORIZZONTI DIVERSI" if rap >= 4.0 else "CONFLITTO"
        campione = "n=1 EPISODIO" if c["episodi"] == 1 else "n=%d" % c["episodi"]
        print("  %-9s(%6.2fh) vs %-9s(%6.2fh)  rapporto %5.1fx  %-18s %-12s netto %+9.2f"
              % (a, ma, b, mb, rap, etich, campione, net))

    # ---- 3. correlazione giornaliera --------------------------------
    print("\n-- 3. CORRELAZIONE DEI P/L GIORNALIERI (metodo dd_portafoglio.py) --")
    giorni = sorted({p["close"].strftime("%Y.%m.%d") for p in pos})
    sedie = sorted({p["magic"] for p in pos})
    serie = {m: {g: 0.0 for g in giorni} for m in sedie}
    for p in pos:
        serie[p["magic"]][p["close"].strftime("%Y.%m.%d")] += p["netto"]
    attive = [m for m in sedie if len([p for p in pos if p["magic"] == m]) >= 3]
    print("  giorni nella finestra: %d   sedie con n>=3 posizioni: %d  (%s)"
          % (len(giorni), len(attive), ", ".join(attive)))
    print("  ATTENZIONE: %d giorni sono POCHI. Una correlazione su 13 punti ha"
          % len(giorni))
    print("  errore standard ~%.2f: solo |r| > ~%.2f e' distinguibile da zero."
          % (1.0 / (len(giorni) - 3) ** 0.5, 2.0 / (len(giorni) - 3) ** 0.5))
    for a, b in itertools.combinations(attive, 2):
        sa = [serie[a][g] for g in giorni]
        sb = [serie[b][g] for g in giorni]
        print("    %-9s vs %-9s : %+.2f" % (a, b, correlazione(sa, sb)))

    # ---- 4. rischio aperto per CLUSTER (simbolo) --------------------
    print("\n-- 4. RISCHIO APERTO SIMULTANEO per CLUSTER (simbolo) --")
    print("  cap firmato 07/09: 3,00%% per cluster  (FIRMATO, NON ATTIVO)")
    print("  unita' di rischio: %.2f%% per POSIZIONE (A1)" % args.rischio)
    for sym in sorted({p["symbol"] for p in pos}):
        sp = [p for p in pos if p["symbol"] == sym]
        eventi = []
        for k, p in enumerate(sp):
            eventi.append((p["open"], 1, k))
            eventi.append((p["close"], 0, k))
        eventi.sort(key=lambda e: (e[0], e[1]))
        aperte, best, quando, bestsed = set(), 0, None, set()
        for t, tipo, k in eventi:
            if tipo == 0:
                aperte.discard(k)
            else:
                aperte.add(k)
                if len(aperte) > best:
                    best = len(aperte)
                    quando = t
                    bestsed = {sp[x]["magic"] for x in aperte}
        if best < 2:
            continue
        print("  %-8s picco %2d posizioni (%d sedie) il %s -> %5.2f%% aperto  %s"
              % (sym, best, len(bestsed), quando.strftime("%Y.%m.%d %H:%M"),
                 best * args.rischio,
                 "SFONDA IL CAP" if best * args.rischio > 3.0 else "ok"))
        print("           sedie al picco: %s" % ", ".join(sorted(bestsed)))

    # ---- 5. test di permutazione ------------------------------------
    print("\n-- 5. E' STRANO? test di permutazione sul netto del gruppo --")
    netti = [p["netto"] for p in pos]
    k = len(coinvolte)
    rng = random.Random(args.seed)
    piu_estremi = 0
    for _ in range(args.perm):
        camp = rng.sample(netti, k)
        if sum(camp) <= netto_sov:
            piu_estremi += 1
    p_val = (piu_estremi + 1) / (args.perm + 1.0)
    print("  H0: l'etichetta 'sovrapposta' e' assegnata a caso a %d delle %d"
          % (k, len(pos)))
    print("  osservato: %+.2f   p (una coda, <=) = %.4f  su %d permutazioni"
          % (netto_sov, p_val, args.perm))
    medie = []
    for _ in range(2000):
        medie.append(sum(rng.sample(netti, k)))
    medie.sort()
    print("  distribuzione nulla: p5 %+.1f  p50 %+.1f  p95 %+.1f"
          % (medie[100], medie[1000], medie[1900]))

    # ---- 5b. stesso test sul solo U30USD ----------------------------
    u = [p for p in pos if p["symbol"] == "U30USD"]
    ui = [x for x, p in enumerate(pos) if p["symbol"] == "U30USD"]
    uc = [x for x in ui if x in coinvolte]
    if u and uc:
        netti_u = [p["netto"] for p in u]
        oss = sum(pos[x]["netto"] for x in uc)
        pe = 0
        for _ in range(args.perm):
            if sum(rng.sample(netti_u, len(uc))) <= oss:
                pe += 1
        print("  SOLO U30USD: %d sovrapposte su %d, netto %+.2f, p = %.4f"
              % (len(uc), len(u), oss, (pe + 1) / (args.perm + 1.0)))
        print("  (dentro U30USD la quasi-totalita' e' sovrapposta: il test"
              " ha poca forza, dichiarato)")

    # ---- 6. netto per sedia (per costruire i gruppi) ----------------
    print("\n-- 6. SCHEDA PER SEDIA (finestra) --")
    print("  %-9s %4s %10s %8s %8s %-9s %s"
          % ("magic", "n", "netto", "med.h", "op/gg", "simbolo", "nome"))
    for m in sedie:
        sp = [p for p in pos if p["magic"] == m]
        syms = sorted({p["symbol"] for p in sp})
        print("  %-9s %4d %+10.2f %8.2f %8.2f %-9s %s"
              % (m, len(sp), sum(p["netto"] for p in sp),
                 mediana(dur[m]), len(sp) / 13.0, ",".join(syms),
                 nomi.get(m, "?")[:30]))


if __name__ == "__main__":
    main()
