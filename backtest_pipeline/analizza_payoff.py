#!/usr/bin/env python3
"""
analizza_payoff.py — win rate, payoff ed expectancy da un export per-trade.

Nasce il 14/08/2026 dall'osservazione di Claudio sul conto 100k ("3 trade
positivi e 2 negativi, ma il conto e' in negativo"): il CSV di
ottimizzazione del tester da' profitto/PF/DD ma NON separa vincite e
perdite, quindi non dice il numero che spiega quel fenomeno.

Legge i file per-trade prodotti dagli EA (ExportTrades, separatore ';'):
    abtg_trades_<EA>_<simbolo>_<magic>.csv
e/o il CSV del TradeExporter live (trades_auto.csv / trades_100k.csv).

Per ogni file stampa: numero di chiusure, win rate, vincita media,
perdita media, payoff (vincita/perdita media), expectancy per trade e
il win rate che servirebbe per andare in pari con quel payoff.

Uso:
    python3 backtest_pipeline/analizza_payoff.py <file_o_cartella> [...]
    python3 backtest_pipeline/analizza_payoff.py data/statements/trades_100k.csv
"""
import csv, sys, os, glob


def leggi_profitti(path):
    """Ritorna la lista dei netti. Riconosce da solo il formato."""
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        testa = f.readline()
        f.seek(0)
        sep = ";" if testa.count(";") >= testa.count(",") else ","
        righe = list(csv.reader(f, delimiter=sep))
    if not righe:
        return []
    intest = [c.strip().lower() for c in righe[0]]
    # export per-trade dell'EA: close_time;symbol;magic;position_id;deal_type;volume;price;net_profit
    # export live TradeExporter: ...;profit;strategy;magic;close_reason;...
    idx = None
    for nome in ("net_profit", "profit", "netto"):
        if nome in intest:
            idx = intest.index(nome)
            break
    dati = righe[1:] if idx is not None else righe
    if idx is None:
        idx = len(righe[0]) - 1   # ultima colonna: l'export minimale finisce col netto
    out = []
    for r in dati:
        if len(r) <= idx:
            continue
        try:
            out.append(float(str(r[idx]).replace(",", ".")))
        except ValueError:
            continue
    return out


def referto(nome, p):
    v = [x for x in p if x > 0]
    l = [-x for x in p if x < 0]
    n = len(v) + len(l)
    if n == 0:
        print(f"{nome}: nessuna chiusura leggibile")
        return
    mv = sum(v) / len(v) if v else 0.0
    ml = sum(l) / len(l) if l else 0.0
    wr = len(v) / n
    payoff = (mv / ml) if ml > 0 else float("inf")
    exp = wr * mv - (1 - wr) * ml
    be = 1 / (1 + payoff) if payoff not in (0, float("inf")) else 0.0
    print(f"\n=== {nome} ===")
    print(f"  chiusure {n}  (vinte {len(v)} / perse {len(l)})   netto {sum(p):+.2f}")
    print(f"  win rate      {wr:6.1%}")
    print(f"  vincita media {mv:8.2f}   perdita media {ml:8.2f}")
    print(f"  PAYOFF        {payoff:6.3f}   (win rate per il pareggio: {be:.1%})")
    print(f"  expectancy    {exp:+8.2f} per trade")
    if payoff < 1 and wr < be:
        print("  -> ATTENZIONE: con questo payoff il win rate attuale NON basta.")


def main(argomenti):
    file_da_leggere = []
    for a in argomenti:
        if os.path.isdir(a):
            file_da_leggere += sorted(glob.glob(os.path.join(a, "*.csv")))
        else:
            file_da_leggere += sorted(glob.glob(a))
    if not file_da_leggere:
        print("Uso: analizza_payoff.py <file.csv | cartella> [...]")
        return 1
    for f in file_da_leggere:
        referto(os.path.basename(f), leggi_profitti(f))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
