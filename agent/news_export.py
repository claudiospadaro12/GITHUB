"""Genera il file `abtg_news.csv` per gli Expert Advisor (filtro news).

Gli EA (PostNews, e i filtri news degli altri) leggono un CSV in
MQL5\\Files con separatore ';' e colonne:  data ora ; impatto ; valuta ; titolo

Questo modulo scarica il calendario di Forex Factory (stesso feed gratuito
usato dal report) per la settimana corrente + la prossima, tiene gli eventi
ad alto impatto, e NORMALIZZA i titoli di ECB e FOMC in modo che contengano
sempre le parole "ECB" / "FOMC" (che è ciò che l'EA cerca).

Uso:
    from agent.news_export import write_abtg_news
    write_abtg_news("abtg_news.csv")
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from zoneinfo import ZoneInfo

import requests

FEEDS = [
    "https://nfs.faireconomy.media/ff_calendar_thisweek.json",
    "https://nfs.faireconomy.media/ff_calendar_nextweek.json",
    "https://nfs.faireconomy.media/ff_calendar_lastweek.json",
]

# parole-chiave per riconoscere gli eventi di politica monetaria
ECB_KEYS = ("ecb", "main refinancing", "monetary policy statement",
            "rate statement", "deposit facility", "marginal lending")
FOMC_KEYS = ("fomc", "federal funds rate", "fed ", "economic projections")


@dataclass
class NewsRow:
    dt: datetime
    impact: str
    currency: str
    title: str


def _fetch_feed(url: str, tz: ZoneInfo, timeout: int = 20) -> list[NewsRow]:
    try:
        r = requests.get(url, timeout=timeout, headers={"User-Agent": "market-agent/1.0"})
        r.raise_for_status()
        raw = r.json()
    except Exception:
        return []
    out: list[NewsRow] = []
    for item in raw:
        ds = item.get("date")
        if not ds:
            continue
        try:
            dt = datetime.fromisoformat(ds).astimezone(tz)
        except ValueError:
            continue
        out.append(NewsRow(
            dt=dt,
            impact=(item.get("impact") or "").strip(),
            currency=(item.get("country") or "").strip(),
            title=(item.get("title") or "").strip(),
        ))
    return out


def _normalize_title(currency: str, title: str) -> str:
    """Se e' un evento ECB/FOMC, garantisce la parola chiave nel titolo."""
    low = title.lower()
    if currency == "EUR" and any(k in low for k in ECB_KEYS):
        return title if "ecb" in low else f"ECB - {title}"
    if currency == "USD" and any(k in low for k in FOMC_KEYS):
        return title if "fomc" in low else f"FOMC - {title}"
    return title


def collect_news(tz_name: str = "Europe/Rome",
                 keep_impacts=("High",)) -> list[NewsRow]:
    """Eventi (deduplicati) dalle 3 settimane, filtrati per impatto."""
    tz = ZoneInfo(tz_name)
    seen = set()
    rows: list[NewsRow] = []
    keep = {k.lower() for k in keep_impacts}
    for url in FEEDS:
        for r in _fetch_feed(url, tz):
            if r.impact.lower() not in keep:
                continue
            r.title = _normalize_title(r.currency, r.title)
            key = (r.dt.strftime("%Y-%m-%d %H:%M"), r.currency, r.title)
            if key in seen:
                continue
            seen.add(key)
            rows.append(r)
    rows.sort(key=lambda x: x.dt)
    return rows


def write_abtg_news(path: str, tz_name: str = "Europe/Rome",
                    keep_impacts=("High",)) -> int:
    """Scrive il CSV nel formato dell'EA. Ritorna il n. di righe scritte."""
    rows = collect_news(tz_name, keep_impacts)
    lines = []
    for r in rows:
        # formato data che StringToTime di MT5 legge: "AAAA.MM.GG HH:MM"
        stamp = r.dt.strftime("%Y.%m.%d %H:%M")
        title = r.title.replace(";", ",")  # ';' e' il separatore
        lines.append(f"{stamp};{r.impact};{r.currency};{title}")
    # MT5 FILE_ANSI = codepage Windows occidentale (cp1252)
    with open(path, "w", encoding="cp1252", errors="replace", newline="\n") as f:
        f.write("\n".join(lines) + ("\n" if lines else ""))
    return len(rows)


def summarize(rows: list[NewsRow]) -> dict:
    """Conteggi utili per il log (quanti ECB/FOMC trovati)."""
    ecb = sum(1 for r in rows if "ecb" in r.title.lower())
    fomc = sum(1 for r in rows if "fomc" in r.title.lower())
    return {"totale": len(rows), "ECB": ecb, "FOMC": fomc}


if __name__ == "__main__":
    import sys
    out = sys.argv[1] if len(sys.argv) > 1 else "abtg_news.csv"
    rows = collect_news()
    n = write_abtg_news(out)
    print(f"Scritte {n} righe in {out}")
    print("Riepilogo:", summarize(rows))
    for r in rows:
        if "ecb" in r.title.lower() or "fomc" in r.title.lower():
            print("  ", r.dt.strftime("%Y.%m.%d %H:%M"), r.currency, r.title)
