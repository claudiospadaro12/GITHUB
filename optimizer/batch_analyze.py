#!/usr/bin/env python3
"""
Analisi BATCH delle ottimizzazioni MT5: dai una cartella di file esportati
(uno per EA) e ottieni, per ciascuno, il set di parametri ROBUSTO + una
tabella riassuntiva. Pensato per chi ha molti EA (15+).

Riusa il motore di analyze_optimization.py (parser + selezione plateau),
gia' verificato su un export reale.

Uso:
    python optimizer/batch_analyze.py cartella_export/
    python optimizer/batch_analyze.py cartella_export/ --min-trades 40 --min-profit-factor 1.2 --out-dir best_sets/

Ogni file nella cartella deve essere un export di OTTIMIZZAZIONE
(.xml SpreadsheetML / .xlsx / .csv). I file che non sono tabelle di
ottimizzazione vengono saltati con un avviso (niente numeri inventati).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import analyze_optimization as ao


ESTENSIONI = (".xml", ".xlsx", ".xlsm", ".xls", ".csv", ".tsv")


CORE_METRICS = {"profit_factor", "result", "expected_payoff", "recovery"}


def analizza_file(path: Path, f: ao.Filters):
    """Ritorna (riga_migliore, cols) o solleva un'eccezione con motivo chiaro."""
    df = ao.load_optimization(str(path))
    cols = ao.classify_columns(df)

    # Scarta i file che NON sono tabelle di ottimizzazione (es. report di un
    # singolo backtest): niente metriche note o parametri fasulli auto-nominati.
    if not (set(cols.metrics) & CORE_METRICS):
        raise ValueError("non e' un export di ottimizzazione (nessuna metrica riconosciuta)")
    veri_param = [p for p in cols.params if not str(p).startswith("Unnamed")]
    if not veri_param:
        raise ValueError("nessuna colonna di parametri valida: non e' una tabella di ottimizzazione")
    cols.params = veri_param

    ranked = ao.analyze(df, cols, f)
    if ranked.empty:
        raise ValueError("nessun set supera i filtri minimi (trade/PF/drawdown)")
    return ranked.iloc[0], cols


def main() -> int:
    ap = argparse.ArgumentParser(description="Analisi batch ottimizzazioni MT5 (multi-EA).")
    ap.add_argument("cartella", help="Cartella con gli export di ottimizzazione (uno per EA).")
    ap.add_argument("--min-trades", type=int, default=30)
    ap.add_argument("--min-profit-factor", type=float, default=1.1)
    ap.add_argument("--max-drawdown", type=float, default=None)
    ap.add_argument("--steps", type=float, default=1.5, help="ampiezza vicinato (plateau)")
    ap.add_argument("--out-dir", default=None, help="dove salvare i .set migliori")
    args = ap.parse_args()

    cartella = Path(args.cartella)
    if not cartella.is_dir():
        print(f"ERRORE: '{cartella}' non e' una cartella.")
        return 2

    files = sorted(p for p in cartella.iterdir() if p.suffix.lower() in ESTENSIONI)
    if not files:
        print(f"Nessun file {ESTENSIONI} in {cartella}.")
        return 1

    f = ao.Filters(min_trades=args.min_trades,
                   min_profit_factor=args.min_profit_factor,
                   max_drawdown=args.max_drawdown,
                   robustness_steps=args.steps)

    out_dir = Path(args.out_dir) if args.out_dir else None
    if out_dir:
        out_dir.mkdir(parents=True, exist_ok=True)

    righe_ok = []
    saltati = []

    for path in files:
        ea = path.stem
        try:
            best, cols = analizza_file(path, f)
        except Exception as e:
            saltati.append((ea, str(e)))
            continue

        pf = best.get(cols.metrics.get("profit_factor", ""), "")
        dd = best.get(cols.metrics.get("drawdown", ""), "")
        tr = best.get(cols.metrics.get("trades", ""), "")
        rob = best.get("_robustness", "")
        params = ao.to_set(best, cols.params).replace("\n", ", ")
        righe_ok.append((ea, pf, dd, tr, rob, params))

        if out_dir:
            (out_dir / f"{ea}.set").write_text(ao.to_set(best, cols.params) + "\n", encoding="utf-8")

    # --- riepilogo ---
    print(f"\n{'='*70}\nRIEPILOGO BATCH — {len(righe_ok)} EA analizzati, {len(saltati)} saltati\n{'='*70}")
    if righe_ok:
        print(f"\n{'EA':<28} {'PF':>7} {'DD%':>7} {'Trade':>6} {'Robust':>7}")
        print("-" * 70)
        for ea, pf, dd, tr, rob, params in righe_ok:
            def fnum(x, d=2):
                try:
                    return f"{float(x):.{d}f}"
                except Exception:
                    return str(x)
            print(f"{ea[:28]:<28} {fnum(pf):>7} {fnum(dd):>7} {fnum(tr,0):>6} {fnum(rob,3):>7}")
        print("\nParametri robusti per EA:")
        for ea, *_rest, params in righe_ok:
            print(f"  - {ea}: {params}")

    if saltati:
        print(f"\nSALTATI (motivo):")
        for ea, motivo in saltati:
            print(f"  - {ea}: {motivo}")

    if out_dir:
        print(f"\n.set salvati in: {out_dir}/")

    print("\nRicorda: questi set vanno confermati in FORWARD TEST / demo su un "
          "periodo NON usato per l'ottimizzazione (out-of-sample).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
