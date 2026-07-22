"""Istantanea giornaliera (snapshot) di bias, livelli e correlazioni.

Ogni mattina il report salva qui — in un file JSON datato — quello che ha
"detto" (bias per strumento, supporti/resistenze, pivot, Fibonacci, correlazioni).
Il report settimanale del sabato rilegge questi snapshot e li CONFRONTA con
quello che il mercato ha fatto davvero: era giusto il bias? hanno tenuto i livelli?

Nota: si puo' verificare solo cio' che si e' salvato. La verifica del bias/livelli
parte quindi dal primo giorno in cui inizia questa raccolta.
"""

from __future__ import annotations

import json
from dataclasses import asdict
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

from agent import config

SNAP_DIR = Path("data/snapshots")


def save_snapshot(groups: dict, corr=None, gold_dxy=None, when: datetime | None = None) -> Path:
    """Serializza bias/livelli/correlazioni del giorno in data/snapshots/AAAA-MM-GG.json.

    - groups: dict {"Indici": [Instrument, ...], ...} da market_data.collect_all
    - corr: list[RefCorr] correlazione DAX vs S&P/Nikkei (opzionale)
    - gold_dxy: RefCorr correlazione oro vs dollaro (opzionale)
    """
    now = when or datetime.now(ZoneInfo(config.TIMEZONE))
    date_str = now.strftime("%Y-%m-%d")

    record = {
        "date": date_str,
        "generated_at": now.strftime("%Y-%m-%d %H:%M %Z"),
        "timezone": config.TIMEZONE,
        "instruments": {
            group: [asdict(inst) for inst in items]
            for group, items in groups.items()
        },
        "correlations": {
            "dax_refs": [asdict(c) for c in corr] if corr else [],
            "gold_dxy": asdict(gold_dxy) if gold_dxy is not None else None,
        },
    }

    SNAP_DIR.mkdir(parents=True, exist_ok=True)
    path = SNAP_DIR / f"{date_str}.json"
    path.write_text(
        json.dumps(record, ensure_ascii=False, indent=2, default=str),
        encoding="utf-8",
    )
    return path


def load_range(start: datetime, end: datetime) -> list[dict]:
    """Rilegge tutti gli snapshot tra start ed end (inclusi). Usato dal report settimanale."""
    out = []
    if not SNAP_DIR.exists():
        return out
    for p in sorted(SNAP_DIR.glob("*.json")):
        try:
            d = datetime.strptime(p.stem, "%Y-%m-%d").date()
        except ValueError:
            continue
        if start.date() <= d <= end.date():
            out.append(json.loads(p.read_text(encoding="utf-8")))
    return out
