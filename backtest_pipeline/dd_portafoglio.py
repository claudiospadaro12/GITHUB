#!/usr/bin/env python3
# =====================================================================
#  dd_portafoglio.py -- il DD del CONTO quando piu' EA girano insieme
# ---------------------------------------------------------------------
#  Consuma i CSV per-trade scritti dall'ExportTrades() degli EA
#  (abtg_trades_<EA>_<SIMBOLO>_<magic>.csv, separatore ';').
#  Per ogni giorno somma i netti di tutti gli EA e calcola:
#    1. equity combinata storica e MAX DD (in % del deposito e dal picco)
#    2. DD del singolo EA (per confronto: quanto "si coprono" a vicenda)
#    3. correlazione dei P&L giornalieri fra EA
#    4. MONTE CARLO: rimescola i GIORNI (interi, tutti gli EA insieme:
#       cosi' la correlazione dello stesso giorno si conserva) e stima
#       la distribuzione dei DD possibili (p50 / p95 / p99).
#  Uso:
#    python3 dd_portafoglio.py --deposito 100000 file1.csv file2.csv ...
#  Nota di metodo: il rimescolo dei giorni conserva la correlazione
#  same-day e DISTRUGGE quella seriale (le strisce). Il DD storico e'
#  UNA realizzazione; il Monte Carlo dice quanto e' stata fortunata.
# =====================================================================
import sys, csv, argparse, random
from collections import defaultdict
from datetime import datetime


def leggi_trades(path):
    """-> lista (data 'YYYY.MM.DD', netto float). Tollera l'header."""
    rows = []
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        rd = csv.reader(f, delimiter=";")
        for r in rd:
            if len(r) < 8 or r[0] == "close_time":
                continue
            try:
                giorno = r[0].split(" ")[0]
                datetime.strptime(giorno, "%Y.%m.%d")
                netto = float(r[7])
            except (ValueError, IndexError):
                continue
            rows.append((giorno, netto))
    return rows


def max_dd(equity):
    """-> (dd_assoluto, dd_pct_dal_picco) su una serie di equity."""
    picco = equity[0]
    dd = 0.0
    ddp = 0.0
    for v in equity:
        if v > picco:
            picco = v
        if picco > 0:
            dd = max(dd, picco - v)
            ddp = max(ddp, (picco - v) / picco * 100.0)
    return dd, ddp


def equity_da_giorni(giorni_pl, deposito):
    eq = [deposito]
    for pl in giorni_pl:
        eq.append(eq[-1] + pl)
    return eq


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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--deposito", type=float, default=100000.0)
    ap.add_argument("--mc", type=int, default=2000, help="iterazioni Monte Carlo")
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    per_ea = {}
    for p in args.files:
        nome = p.split("/")[-1].replace("abtg_trades_", "").replace(".csv", "")
        rows = leggi_trades(p)
        if not rows:
            print(f"ATTENZIONE: {p} vuoto o illeggibile, saltato")
            continue
        d = defaultdict(float)
        for g, v in rows:
            d[g] += v
        per_ea[nome] = dict(d)
        print(f"{nome}: {len(rows)} trade, {len(d)} giorni attivi, netto {sum(v for _, v in rows):+.2f}")
    if not per_ea:
        sys.exit("nessun dato.")

    tutti_i_giorni = sorted(set(g for d in per_ea.values() for g in d))
    nomi = list(per_ea)
    matrice = [[per_ea[n].get(g, 0.0) for n in nomi] for g in tutti_i_giorni]

    print(f"\nfinestra: {tutti_i_giorni[0]} -> {tutti_i_giorni[-1]}  ({len(tutti_i_giorni)} giorni con trade)")
    print(f"deposito: {args.deposito:.0f}\n")

    # --- DD singoli --------------------------------------------------
    print("-- DD dei singoli EA (a parita' di deposito) --")
    for j, n in enumerate(nomi):
        serie = [matrice[i][j] for i in range(len(matrice))]
        _, ddp = max_dd(equity_da_giorni(serie, args.deposito))
        print(f"  {n:55s} netto {sum(serie):+10.2f}   DD {ddp:5.2f}%")

    # --- combinato storico ------------------------------------------
    comb = [sum(r) for r in matrice]
    eq = equity_da_giorni(comb, args.deposito)
    dd_abs, dd_pct = max_dd(eq)
    somma_dd_singoli = 0.0
    for j in range(len(nomi)):
        serie = [matrice[i][j] for i in range(len(matrice))]
        _, ddp = max_dd(equity_da_giorni(serie, args.deposito))
        somma_dd_singoli += ddp
    print("\n-- PORTAFOGLIO (storico) --")
    print(f"  netto totale : {sum(comb):+10.2f}")
    print(f"  MAX DD       : {dd_abs:10.2f}  ({dd_pct:.2f}% dal picco)")
    print(f"  somma dei DD singoli: {somma_dd_singoli:.2f}%  -> beneficio di diversificazione: "
          f"{somma_dd_singoli - dd_pct:+.2f} punti")
    peggior_giorno = min(comb)
    print(f"  peggior giornata combinata: {peggior_giorno:+.2f} ({peggior_giorno / args.deposito * 100:+.2f}%)")

    # --- correlazioni ------------------------------------------------
    if len(nomi) > 1:
        print("\n-- correlazione P&L giornalieri --")
        for a in range(len(nomi)):
            for b in range(a + 1, len(nomi)):
                sa = [matrice[i][a] for i in range(len(matrice))]
                sb = [matrice[i][b] for i in range(len(matrice))]
                print(f"  {nomi[a][:30]:30s} vs {nomi[b][:30]:30s}: {correlazione(sa, sb):+.2f}")

    # --- Monte Carlo -------------------------------------------------
    rng = random.Random(args.seed)
    dds = []
    for _ in range(args.mc):
        righe = matrice[:]
        rng.shuffle(righe)
        c = [sum(r) for r in righe]
        _, ddp = max_dd(equity_da_giorni(c, args.deposito))
        dds.append(ddp)
    dds.sort()

    def pct(p):
        return dds[min(len(dds) - 1, int(p / 100.0 * len(dds)))]

    print(f"\n-- MONTE CARLO ({args.mc} rimescoli dei giorni, seed {args.seed}) --")
    print(f"  DD mediano (p50): {pct(50):.2f}%")
    print(f"  DD p95          : {pct(95):.2f}%")
    print(f"  DD p99          : {pct(99):.2f}%")
    print(f"  (storico: {dd_pct:.2f}% -> se lo storico e' molto sotto il p50, e' stato fortunato)")
    print("\nNOTA: il rimescolo conserva la correlazione same-day fra EA e distrugge le")
    print("strisce (correlazione seriale). Per la prop conta il p95/p99, non il migliore.")


if __name__ == "__main__":
    main()
