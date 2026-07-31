"""Archivio storico del bias giornaliero degli strumenti.

Scrive UNA riga per strumento per giorno in ``data/regime_log.csv``. Serve per
incrociare a posteriori le condizioni di mercato (bias/RSI/score) con i
risultati degli EA → **mappa regime × EA** (in quale regime ogni EA vince/perde).

Idempotente: se un giorno è già archiviato per uno strumento, non lo duplica
(così le ri-esecuzioni del workflow non creano doppioni).
"""

from __future__ import annotations

import csv
import os
from datetime import datetime

FIELDS = [
    "data", "gruppo", "strumento", "prezzo", "var_pct",
    "sma20", "sma50", "rsi14", "score", "bias",
]


def archive(groups: dict, now: datetime, path: str = "data/regime_log.csv") -> int:
    """Aggiunge le righe di oggi al CSV storico. Ritorna quante righe scritte."""
    date_str = now.strftime("%Y-%m-%d")
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)

    # coppie (data, strumento) già presenti → evita duplicati
    existing: set[tuple[str, str]] = set()
    if os.path.exists(path):
        with open(path, newline="", encoding="utf-8") as f:
            for row in csv.DictReader(f):
                existing.add((row.get("data"), row.get("strumento")))

    new_rows: list[dict] = []
    for gruppo, instruments in groups.items():
        for it in instruments:
            if getattr(it, "error", None):
                continue  # niente dati validi per questo strumento
            if (date_str, it.name) in existing:
                continue  # già archiviato oggi
            new_rows.append({
                "data": date_str,
                "gruppo": gruppo,
                "strumento": it.name,
                "prezzo": it.last_close,
                "var_pct": it.change_pct,
                "sma20": it.sma20,
                "sma50": it.sma50,
                "rsi14": it.rsi14,
                "score": it.score,
                "bias": it.bias,
            })

    if not new_rows:
        return 0

    write_header = (not os.path.exists(path)) or os.path.getsize(path) == 0
    with open(path, "a", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=FIELDS)
        if write_header:
            w.writeheader()
        w.writerows(new_rows)
    return len(new_rows)
