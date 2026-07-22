"""Verifica del bias giornaliero contro il movimento reale del mercato.

Per ogni snapshot (bias del mattino per strumento) confronta la direzione
prevista con quella effettiva della giornata, scaricando i dati reali.
Usato dal report settimanale.
"""

from __future__ import annotations

from datetime import datetime, timedelta

import pandas as pd
import yfinance as yf


def _expected_dir(bias: str) -> str | None:
    """Mappa il testo del bias a una direzione attesa: 'up' | 'down' | None (neutro)."""
    b = (bias or "").lower()
    if "rialz" in b:
        return "up"
    if "ribass" in b:
        return "down"
    return None  # neutrale/laterale o dati non disponibili


def _actual_changes(tickers: list[str], start: str, end: str) -> dict:
    """Scarica le barre giornaliere e ritorna {ticker: {AAAA-MM-GG: var% giorno}}."""
    out: dict[str, dict] = {}
    if not tickers:
        return out
    start_d = datetime.strptime(start, "%Y-%m-%d")
    end_d = datetime.strptime(end, "%Y-%m-%d") + timedelta(days=3)
    try:
        data = yf.download(tickers, start=start_d.strftime("%Y-%m-%d"),
                           end=end_d.strftime("%Y-%m-%d"), interval="1d",
                           progress=False, group_by="ticker", auto_adjust=False)
    except Exception:
        return out

    for tk in tickers:
        try:
            df = data[tk] if len(tickers) > 1 else data
            if df is None or df.empty:
                continue
            for idx, row in df.iterrows():
                o, c = row.get("Open"), row.get("Close")
                if pd.isna(o) or pd.isna(c) or o == 0:
                    continue
                day = idx.strftime("%Y-%m-%d")
                out.setdefault(tk, {})[day] = (c - o) / o * 100.0
        except (KeyError, AttributeError):
            continue
    return out


def verify(snapshots: list[dict]) -> dict:
    """Confronta bias vs realta'. Ritorna un riepilogo strutturato.

    { 'rows': [ {date, name, ticker, bias, expected, actual_pct, actual_dir, coherent} ],
      'by_instrument': {name: {checked, coherent}},
      'total_checked': int, 'total_coherent': int }
    """
    if not snapshots:
        return {"rows": [], "by_instrument": {}, "total_checked": 0, "total_coherent": 0}

    dates = [s["date"] for s in snapshots]
    tickers = set()
    for s in snapshots:
        for group in s.get("instruments", {}).values():
            for inst in group:
                if inst.get("ticker"):
                    tickers.add(inst["ticker"])

    changes = _actual_changes(sorted(tickers), min(dates), max(dates))

    rows = []
    by_inst: dict[str, dict] = {}
    total_checked = total_coherent = 0

    for s in snapshots:
        day = s["date"]
        for group in s.get("instruments", {}).values():
            for inst in group:
                exp = _expected_dir(inst.get("bias", ""))
                tk = inst.get("ticker")
                actual_pct = changes.get(tk, {}).get(day)
                if exp is None or actual_pct is None:
                    continue  # niente bias direzionale o dato reale mancante
                actual_dir = "up" if actual_pct > 0.05 else ("down" if actual_pct < -0.05 else "flat")
                coherent = (exp == actual_dir)
                rows.append({
                    "date": day, "name": inst.get("name"), "ticker": tk,
                    "bias": inst.get("bias"), "expected": exp,
                    "actual_pct": round(actual_pct, 2), "actual_dir": actual_dir,
                    "coherent": coherent,
                })
                b = by_inst.setdefault(inst.get("name"), {"checked": 0, "coherent": 0})
                b["checked"] += 1
                b["coherent"] += 1 if coherent else 0
                total_checked += 1
                total_coherent += 1 if coherent else 0

    return {"rows": rows, "by_instrument": by_inst,
            "total_checked": total_checked, "total_coherent": total_coherent}
