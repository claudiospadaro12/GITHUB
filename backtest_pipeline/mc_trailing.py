#!/usr/bin/env python3
# =====================================================================
#  mc_trailing.py -- M1: Monte Carlo del DD TRAILING del portafoglio
# ---------------------------------------------------------------------
#  Criteri CONGELATI in backtest_pipeline/prove/M1_MC_TRAILING_CRITERI.md
#  (scritti PRIMA di guardare qualunque numero trailing).
#
#  Stesse 27 serie e stesso ricampionamento della MC statica di casa
#  (dd_portafoglio.py, R16->R41): rimescolo dei GIORNI INTERI, 2000
#  iterazioni, seed 42, deposito 100.000. La sequenza dei rimescoli e'
#  IDENTICA a dd_portafoglio.py (stesso rng, stesso ordine iniziale dei
#  giorni), cosi' la statica a fattore 1,0 DEVE riprodurre 5,74/9,89/12,47
#  -- e' il controllo di sanita' interno.
#
#  Modelli misurati (per taglie 0,65 / 0,50 / 0,40 -- scala lineare):
#   A) trailing END-OF-DAY sul saldo massimo di fine giornata, muro in
#      EUR fissi = % del capitale INIZIALE (stile FTMO 1-Step, dossier
#      CONFIG_PROP 2A), SENZA blocco al breakeven.
#   B) trailing EQUITY proxy per-trade (HWM dopo ogni chiusura; minorante
#      onesto dell'equity flottante vera).
#   C) come A ma col pavimento BLOCCATO al capitale iniziale (la clausola
#      "si blocca al breakeven"): solo probabilita' di sfondamento.
#  Piu' la METRICA DI CORSA: target +10% EOD contro muro trailing (A),
#  cosa arriva prima.
#
#  Uso:
#    python3 mc_trailing.py --deposito 100000 file1.csv ... file27.csv
# =====================================================================
import sys, csv, argparse, random
from collections import defaultdict
from datetime import datetime

FATTORI = [1.0, 0.65, 0.50, 0.40]   # 1.0 solo come sanita' della statica
MURI = [10.0, 8.0, 6.0]             # % del capitale iniziale
TARGET = 10.0                       # target challenge 1-Step, % su saldo EOD


def leggi_trades(path):
    """-> lista (close_time 'YYYY.MM.DD HH:MM:SS', netto float)."""
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
            rows.append((r[0], giorno, netto))
    return rows


def max_dd_statico_pct_picco(pl_giorni, deposito):
    """La statica di casa: max DD in % del PICCO corrente (dd_portafoglio)."""
    eq = deposito
    picco = deposito
    ddp = 0.0
    for pl in pl_giorni:
        eq += pl
        if eq > picco:
            picco = eq
        if picco > 0:
            d = (picco - eq) / picco * 100.0
            if d > ddp:
                ddp = d
    return ddp


def max_dd_trailing(pl_seq, deposito):
    """Variante A/B: max (HWM - eq) in % del capitale INIZIALE.
    HWM aggiornato DOPO la misura del giorno/trade."""
    eq = deposito
    hwm = deposito
    dd = 0.0
    for pl in pl_seq:
        eq += pl
        d = (hwm - eq) / deposito * 100.0
        if d > dd:
            dd = d
        if eq > hwm:
            hwm = eq
    return dd


def sfonda_breakeven_lock(pl_giorni, deposito, muro_pct):
    """Variante C: pavimento = min(deposito, HWM - muro). True se toccato."""
    eq = deposito
    hwm = deposito
    muro = muro_pct / 100.0 * deposito
    for pl in pl_giorni:
        floor = hwm - muro
        if floor > deposito:
            floor = deposito
        eq += pl
        if eq <= floor:
            return True
        if eq > hwm:
            hwm = eq
    return False


def corsa(pl_giorni, deposito, muro_pct):
    """Metrica di corsa (variante A): 'PASSA' se il saldo EOD tocca il
    target +10% prima del muro trailing; 'SFONDA' se il muro arriva prima;
    'NESSUNO' se la finestra finisce senza ne' l'uno ne' l'altro."""
    eq = deposito
    hwm = deposito
    muro = muro_pct / 100.0 * deposito
    tgt = deposito * (1.0 + TARGET / 100.0)
    for pl in pl_giorni:
        eq += pl
        if eq <= hwm - muro:
            return "SFONDA"
        if eq >= tgt:
            return "PASSA"
        if eq > hwm:
            hwm = eq
    return "NESSUNO"


def pctile(v, p):
    return v[min(len(v) - 1, int(p / 100.0 * len(v)))]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--deposito", type=float, default=100000.0)
    ap.add_argument("--mc", type=int, default=2000)
    ap.add_argument("--seed", type=int, default=42)
    args = ap.parse_args()

    # --- carica: P&L per giorno (somma) e per-trade dentro il giorno ---
    per_ea_giorno = {}
    trade_per_giorno = defaultdict(list)   # giorno -> [(close_time, netto)]
    for p in args.files:
        nome = p.split("/")[-1].replace("abtg_trades_", "").replace(".csv", "")
        rows = leggi_trades(p)
        if not rows:
            print(f"ATTENZIONE: {p} vuoto o illeggibile, saltato")
            continue
        d = defaultdict(float)
        for ct, g, v in rows:
            d[g] += v
            trade_per_giorno[g].append((ct, v))
        per_ea_giorno[nome] = dict(d)
    if not per_ea_giorno:
        sys.exit("nessun dato.")

    giorni = sorted(set(g for d in per_ea_giorno.values() for g in d))
    nomi = list(per_ea_giorno)
    # per-giorno: somma combinata (per A/C/statica) + lista trade ordinata (per B)
    pl_giorno = [sum(per_ea_giorno[n].get(g, 0.0) for n in nomi) for g in giorni]
    trades_giorno = [[v for _, v in sorted(trade_per_giorno[g])] for g in giorni]
    n_trade = sum(len(t) for t in trades_giorno)

    print(f"serie: {len(nomi)} -- giorni con trade: {len(giorni)} "
          f"({giorni[0]} -> {giorni[-1]}) -- trade totali: {n_trade}")
    print(f"netto combinato a rischio 1%: {sum(pl_giorno):+.2f} -- "
          f"deposito {args.deposito:.0f}\n")

    # --- Monte Carlo: STESSA sequenza di rimescoli di dd_portafoglio ----
    rng = random.Random(args.seed)
    idx0 = list(range(len(giorni)))
    res_stat = {f: [] for f in FATTORI}                     # % dal picco
    res_A = {f: [] for f in FATTORI}                        # % dal dep
    res_B = {f: [] for f in FATTORI}
    res_C = {f: {m: 0 for m in MURI} for f in FATTORI}      # conteggi sfondamenti
    res_corsa = {f: {m: defaultdict(int) for m in MURI} for f in FATTORI}

    for _ in range(args.mc):
        ordine = idx0[:]
        rng.shuffle(ordine)
        seq_g = [pl_giorno[i] for i in ordine]
        for f in FATTORI:
            sg = [x * f for x in seq_g]
            res_stat[f].append(max_dd_statico_pct_picco(sg, args.deposito))
            res_A[f].append(max_dd_trailing(sg, args.deposito))
            st = [v * f for i in ordine for v in trades_giorno[i]]
            res_B[f].append(max_dd_trailing(st, args.deposito))
            for m in MURI:
                if sfonda_breakeven_lock(sg, args.deposito, m):
                    res_C[f][m] += 1
                res_corsa[f][m][corsa(sg, args.deposito, m)] += 1

    for f in FATTORI:
        res_stat[f].sort(); res_A[f].sort(); res_B[f].sort()

    # --- sanita': la statica a 1,0 deve riprodurre 5,74/9,89/12,47 ------
    s = res_stat[1.0]
    print("SANITA' (statica a fattore 1,0, % dal picco -- attesi 5,74/9,89/12,47):")
    print(f"  p50 {pctile(s,50):.2f}  p95 {pctile(s,95):.2f}  p99 {pctile(s,99):.2f}\n")

    ncic = float(args.mc)
    for f in FATTORI:
        print(f"=== TAGLIA {f:.2f}% per trade "
              f"(netto medio finestra {sum(pl_giorno)*f:+.0f}) ===")
        print(f"  STATICA (% dal picco)      : p50 {pctile(res_stat[f],50):6.2f}  "
              f"p95 {pctile(res_stat[f],95):6.2f}  p99 {pctile(res_stat[f],99):6.2f}")
        print(f"  TRAILING A (EOD, % dal dep): p50 {pctile(res_A[f],50):6.2f}  "
              f"p95 {pctile(res_A[f],95):6.2f}  p99 {pctile(res_A[f],99):6.2f}")
        print(f"  TRAILING B (per-trade)     : p50 {pctile(res_B[f],50):6.2f}  "
              f"p95 {pctile(res_B[f],95):6.2f}  p99 {pctile(res_B[f],99):6.2f}")
        for m in MURI:
            pa = sum(1 for x in res_A[f] if x >= m) / ncic * 100.0
            pb = sum(1 for x in res_B[f] if x >= m) / ncic * 100.0
            pc = res_C[f][m] / ncic * 100.0
            c = res_corsa[f][m]
            print(f"  muro {m:4.0f}%: sfonda A {pa:5.1f}%  B {pb:5.1f}%  "
                  f"C(lock BE) {pc:5.1f}%  | corsa al +10%: "
                  f"PASSA {c['PASSA']/ncic*100:5.1f}%  SFONDA {c['SFONDA']/ncic*100:5.1f}%  "
                  f"NESSUNO {c['NESSUNO']/ncic*100:5.1f}%")
        print()

    print("NOTE: A/B/C in % del capitale INIZIALE (EUR fissi sotto l'HWM);")
    print("la statica di casa e' in % del PICCO corrente: geometrie diverse,")
    print("dichiarate nei criteri. Violazione = tocco del muro (>=).")


if __name__ == "__main__":
    main()
