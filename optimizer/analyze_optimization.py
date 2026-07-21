#!/usr/bin/env python3
"""Analizzatore di ottimizzazioni MT5 (anti-overfitting).

Prende il file dei risultati di ottimizzazione esportato dallo Strategy Tester
di MetaTrader 5 e, invece di scegliere il "picco" migliore (che quasi sempre è
sovraottimizzato e non regge in reale), cerca i set di parametri ROBUSTI:

  1. filtri di qualità minima (numero trade, profit factor, drawdown);
  2. rilevamento dei PLATEAU: un buon set è circondato da altri set buoni
     (parametri vicini danno risultati simili) → non è un colpo di fortuna;
  3. punteggio di robustezza = qualità × stabilità del vicinato.

Supporta i file esportati come .xlsx / .csv e l'XML "SpreadsheetML" di MT5.
Gestisce intestazioni sia in inglese sia in italiano.

Uso:
    python optimizer/analyze_optimization.py risultati.xlsx
    python optimizer/analyze_optimization.py risultati.xlsx --min-trades 40 --top 5 --out best.set

Nota onesta: nessuna analisi rende un EA profittevole se non ha un edge reale.
Questo strumento riduce il rischio di illudersi con backtest sovraottimizzati;
la conferma vera resta il forward test / demo out-of-sample.
"""

from __future__ import annotations

import argparse
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass

import pandas as pd

# ------------------------------------------------------------------ #
# Riconoscimento colonne: mappa gli alias (EN/IT) ai nomi canonici.  #
# Tutto ciò che NON è una metrica nota viene trattato come PARAMETRO. #
# ------------------------------------------------------------------ #
METRIC_ALIASES: dict[str, set[str]] = {
    "pass": {"pass", "passaggio", "passo", "#", "n"},
    "result": {"result", "risultato", "back result", "forward result"},
    "profit": {"profit", "profitto"},
    "profit_factor": {"profit factor", "fattore di profitto", "fattore profitto"},
    "expected_payoff": {"expected payoff", "payoff previsto", "payoff atteso"},
    "drawdown": {
        "equity dd %", "equity dd%", "drawdown", "drawdown %",
        "drawdown massimo %", "drawdown equity massimo %",
        "equity drawdown maximal", "drawdown equità massimo %",
        "max drawdown", "drawdown massimo",
    },
    "trades": {"trades", "trade", "operazioni", "scambi", "deals"},
    "recovery": {"recovery factor", "fattore di recupero"},
    "sharpe": {"sharpe ratio", "indice di sharpe", "sharpe"},
    "custom": {"custom", "personalizzato", "custom criterion"},
}

# Metriche in cui "più alto = meglio" o "più basso = meglio".
_HIGHER_BETTER = {"result", "profit", "profit_factor", "expected_payoff", "recovery", "sharpe", "custom"}
_LOWER_BETTER = {"drawdown"}


def _coerce_numeric(df: pd.DataFrame) -> pd.DataFrame:
    """Converte in numerico le colonne dove possibile, lasciando intatte le altre.

    Sostituisce il vecchio df.apply(pd.to_numeric, errors='ignore'), rimosso
    nelle versioni recenti di pandas (che ora alza 'invalid error value').
    """
    out = df.copy()
    for col in out.columns:
        conv = pd.to_numeric(out[col], errors="coerce")
        # tiene la conversione solo se non introduce NaN nuovi (colonna davvero numerica)
        if conv.notna().sum() == out[col].replace("", pd.NA).notna().sum():
            out[col] = conv
    return out


def _norm(h: str) -> str:
    return str(h).strip().lower().replace("\xa0", " ")


def _canonical(header: str) -> str | None:
    h = _norm(header)
    for canon, aliases in METRIC_ALIASES.items():
        if h in aliases:
            return canon
    return None


# ------------------------------------------------------------------ #
# Caricamento file                                                    #
# ------------------------------------------------------------------ #
def _load_mt5_xml(path: str) -> pd.DataFrame:
    """Parser dell'XML SpreadsheetML 2003 esportato da MT5."""
    ns = {"ss": "urn:schemas-microsoft-com:office:spreadsheet"}
    root = ET.parse(path).getroot()
    rows_out: list[list[str]] = []
    for row in root.iter("{urn:schemas-microsoft-com:office:spreadsheet}Row"):
        cells: list[str] = []
        for cell in row.findall("ss:Cell", ns):
            data = cell.find("ss:Data", ns)
            cells.append(data.text if data is not None and data.text is not None else "")
        rows_out.append(cells)
    if not rows_out:
        raise ValueError("XML vuoto o formato non riconosciuto.")
    header = rows_out[0]
    width = len(header)
    body = [r + [""] * (width - len(r)) for r in rows_out[1:] if any(c != "" for c in r)]
    df = pd.DataFrame(body, columns=header)
    return _coerce_numeric(df)


def load_optimization(path: str) -> pd.DataFrame:
    """Carica il file di ottimizzazione in un DataFrame (xlsx/csv/xml)."""
    low = path.lower()
    if low.endswith(".xml"):
        return _load_mt5_xml(path)
    if low.endswith((".xlsx", ".xlsm", ".xls")):
        return pd.read_excel(path)
    if low.endswith((".csv", ".tsv")):
        sep = "\t" if low.endswith(".tsv") else None
        return pd.read_csv(path, sep=sep, engine="python")
    raise ValueError(f"Formato non supportato: {path}")


# ------------------------------------------------------------------ #
# Classificazione colonne                                            #
# ------------------------------------------------------------------ #
@dataclass
class Columns:
    metrics: dict[str, str]     # canonico -> nome colonna reale
    params: list[str]           # colonne dei parametri ottimizzati


def classify_columns(df: pd.DataFrame) -> Columns:
    metrics: dict[str, str] = {}
    params: list[str] = []
    for col in df.columns:
        canon = _canonical(col)
        if canon and canon not in metrics:
            metrics[canon] = col
        elif canon is None:
            # È un parametro solo se numerico e con più di un valore testato.
            s = pd.to_numeric(df[col], errors="coerce")
            if s.notna().any() and s.nunique(dropna=True) > 1:
                params.append(col)
    return Columns(metrics=metrics, params=params)


# ------------------------------------------------------------------ #
# Analisi di robustezza                                              #
# ------------------------------------------------------------------ #
@dataclass
class Filters:
    min_trades: int = 30
    min_profit_factor: float = 1.1
    max_drawdown: float | None = None   # in % (se la colonna esiste)
    robustness_steps: float = 1.5       # ampiezza vicinato in "passi di griglia"
    robustness_weight: float = 1.0      # peso della stabilità nel punteggio


def _quality(df: pd.DataFrame, cols: Columns) -> pd.Series:
    """Punteggio di qualità grezzo (0..1) combinando PF, payoff, DD, trade."""
    q = pd.Series(0.0, index=df.index)
    n = 0

    def _rank01(series: pd.Series, higher_better: bool) -> pd.Series:
        s = pd.to_numeric(series, errors="coerce")
        r = s.rank(pct=True)
        return r if higher_better else (1.0 - r)

    for canon in ("profit_factor", "expected_payoff", "recovery", "custom", "result"):
        if canon in cols.metrics:
            q = q + _rank01(df[cols.metrics[canon]], canon in _HIGHER_BETTER)
            n += 1
    if "drawdown" in cols.metrics:
        q = q + _rank01(df[cols.metrics["drawdown"]], higher_better=False)
        n += 1
    if n == 0:
        return pd.Series(0.5, index=df.index)
    return q / n


def _param_tolerances(df: pd.DataFrame, params: list[str], steps: float) -> dict[str, float]:
    """Tolleranza per-parametro = passo tipico della griglia × `steps`.

    Sulla griglia dell'ottimizzatore MT5 due set sono "vicini" se ogni parametro
    dista al più ~un passo. Deducendo il passo dai valori testati, il vicinato
    funziona a prescindere da quanti valori sono stati provati.
    """
    tol: dict[str, float] = {}
    for p in params:
        vals = sorted(pd.to_numeric(df[p], errors="coerce").dropna().unique())
        if len(vals) < 2:
            tol[p] = 0.0
            continue
        gaps = [b - a for a, b in zip(vals, vals[1:]) if b > a]
        step = sorted(gaps)[len(gaps) // 2] if gaps else 0.0  # mediana dei passi
        tol[p] = step * steps
    return tol


def analyze(df: pd.DataFrame, cols: Columns, f: Filters) -> pd.DataFrame:
    """Restituisce il DataFrame filtrato e ordinato per robustezza."""
    work = df.copy()

    # 1) filtri di qualità minima
    mask = pd.Series(True, index=work.index)
    if "trades" in cols.metrics:
        mask &= pd.to_numeric(work[cols.metrics["trades"]], errors="coerce").fillna(0) >= f.min_trades
    if "profit_factor" in cols.metrics:
        mask &= pd.to_numeric(work[cols.metrics["profit_factor"]], errors="coerce").fillna(0) >= f.min_profit_factor
    if f.max_drawdown is not None and "drawdown" in cols.metrics:
        mask &= pd.to_numeric(work[cols.metrics["drawdown"]], errors="coerce").fillna(1e9) <= f.max_drawdown
    good = work[mask].copy()
    if good.empty:
        return good

    # 2) qualità grezza
    good["_quality"] = _quality(good, cols)

    # 3) stabilità del vicinato (plateau): quanti set BUONI hanno OGNI parametro
    #    entro ~un passo di griglia. Isolato = fragile; affollato = robusto.
    if cols.params:
        tol = _param_tolerances(good, cols.params, f.robustness_steps)
        pvals = {p: pd.to_numeric(good[p], errors="coerce").values for p in cols.params}
        idx = list(range(len(good)))
        dens = []
        for i in idx:
            near = None
            for p in cols.params:
                col = pvals[p]
                close = abs(col - col[i]) <= tol[p]
                near = close if near is None else (near & close)
            dens.append(int(near.sum()) - 1 if near is not None else 0)  # esclude sé stesso
        s = pd.Series(dens, index=good.index, dtype=float)
        good["_neighbors"] = s.astype(int)
        good["_stability"] = (s / s.max()) if s.max() > 0 else 0.0
    else:
        good["_neighbors"] = 0
        good["_stability"] = 0.0

    # 4) punteggio finale
    good["_robustness"] = good["_quality"] * (1.0 + f.robustness_weight * good["_stability"])
    return good.sort_values("_robustness", ascending=False)


# ------------------------------------------------------------------ #
# Output                                                             #
# ------------------------------------------------------------------ #
def to_set(row: pd.Series, params: list[str]) -> str:
    """Genera il contenuto di un file .set MT5 per un pass."""
    lines = []
    for p in params:
        v = row[p]
        if isinstance(v, float) and v.is_integer():
            v = int(v)
        lines.append(f"{p}={v}")
    return "\n".join(lines)


def _fmt_metrics(row: pd.Series, cols: Columns) -> str:
    parts = []
    for canon in ("profit_factor", "expected_payoff", "drawdown", "trades", "recovery", "sharpe"):
        if canon in cols.metrics:
            parts.append(f"{canon}={row[cols.metrics[canon]]}")
    return ", ".join(parts)


def report(ranked: pd.DataFrame, cols: Columns, top: int) -> str:
    if ranked.empty:
        return ("Nessun set supera i filtri di qualità. Allenta i vincoli "
                "(--min-trades / --min-profit-factor) o l'EA non ha un edge su questo storico.")
    out = [f"Trovati {len(ranked)} set validi. Migliori {min(top, len(ranked))} per ROBUSTEZZA:\n"]
    for rank, (_, row) in enumerate(ranked.head(top).iterrows(), 1):
        out.append(f"#{rank}  robustezza={row['_robustness']:.3f}  "
                   f"(qualità={row['_quality']:.2f}, vicini_buoni={int(row['_neighbors'])})")
        out.append(f"     metriche: {_fmt_metrics(row, cols)}")
        params_str = ", ".join(f"{p}={int(row[p]) if float(row[p]).is_integer() else row[p]}" for p in cols.params)
        out.append(f"     parametri: {params_str}\n")
    out.append("Suggerimento: preferisci un set con MOLTI vicini buoni (plateau) anche se il "
               "profitto non è il massimo assoluto: regge meglio in reale. Conferma sempre in "
               "forward test / demo su un periodo NON usato per l'ottimizzazione.")
    return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser(description="Analizza un'ottimizzazione MT5 e trova i set robusti.")
    ap.add_argument("file", help="File esportato da MT5 (.xlsx/.csv/.xml)")
    ap.add_argument("--min-trades", type=int, default=30)
    ap.add_argument("--min-profit-factor", type=float, default=1.1)
    ap.add_argument("--max-drawdown", type=float, default=None, help="Drawdown massimo %% ammesso")
    ap.add_argument("--steps", type=float, default=1.5, help="Ampiezza vicinato in passi di griglia (plateau)")
    ap.add_argument("--top", type=int, default=5)
    ap.add_argument("--out", default=None, help="Salva il .set del set #1 in questo file")
    args = ap.parse_args()

    df = load_optimization(args.file)
    cols = classify_columns(df)
    if not cols.params:
        print("Attenzione: nessuna colonna parametro rilevata. Controlla il file esportato.")
    print(f"Metriche rilevate: {', '.join(cols.metrics) or 'nessuna'}")
    print(f"Parametri rilevati: {', '.join(cols.params) or 'nessuno'}\n")

    f = Filters(min_trades=args.min_trades, min_profit_factor=args.min_profit_factor,
                max_drawdown=args.max_drawdown, robustness_steps=args.steps)
    ranked = analyze(df, cols, f)
    print(report(ranked, cols, args.top))

    if args.out and not ranked.empty:
        best = ranked.iloc[0]
        with open(args.out, "w", encoding="utf-8") as fh:
            fh.write(to_set(best, cols.params) + "\n")
        print(f"\n.set del set #1 salvato in: {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
