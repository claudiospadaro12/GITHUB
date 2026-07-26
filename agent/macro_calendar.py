"""Calendario economico macro della giornata.

Usa il feed JSON gratuito di Forex Factory (faireconomy.media), che non
richiede chiave API. Filtra gli eventi di oggi e segnala quelli ad alto
impatto, utili per capire quali valute/cross potrebbero diventare volatili.
"""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
from zoneinfo import ZoneInfo

import requests

FEED_URL = "https://nfs.faireconomy.media/ff_calendar_thisweek.json"

# Da impact/country a valuta principale, per collegare le news ai cross.
COUNTRY_TO_CCY = {
    "USD": "USD", "EUR": "EUR", "GBP": "GBP", "JPY": "JPY",
    "CHF": "CHF", "AUD": "AUD", "CAD": "CAD", "NZD": "NZD", "CNY": "CNY",
}


@dataclass
class MacroEvent:
    time: str
    currency: str
    title: str
    impact: str  # "High" | "Medium" | "Low" | "Holiday"
    forecast: str
    previous: str


def fetch_today_events(tz: str = "Europe/Rome", timeout: int = 20) -> list[MacroEvent]:
    """Restituisce gli eventi macro di oggi, ordinati per orario."""
    try:
        resp = requests.get(FEED_URL, timeout=timeout, headers={"User-Agent": "market-agent/1.0"})
        resp.raise_for_status()
        raw = resp.json()
    except Exception:
        return []  # senza calendario il report prosegue lo stesso

    zone = ZoneInfo(tz)
    today = datetime.now(zone).date()
    events: list[MacroEvent] = []

    for item in raw:
        date_str = item.get("date")
        if not date_str:
            continue
        try:
            # formato ISO con offset, es. "2026-06-04T08:30:00-04:00"
            dt = datetime.fromisoformat(date_str).astimezone(zone)
        except ValueError:
            continue
        if dt.date() != today:
            continue
        events.append(
            MacroEvent(
                time=dt.strftime("%H:%M"),
                currency=item.get("country", "") or "",
                title=item.get("title", "") or "",
                impact=item.get("impact", "") or "",
                forecast=item.get("forecast", "") or "",
                previous=item.get("previous", "") or "",
            )
        )

    events.sort(key=lambda e: e.time)
    return events


def high_impact_currencies(events: list[MacroEvent]) -> set[str]:
    """Valute con almeno un evento ad alto impatto oggi."""
    return {
        COUNTRY_TO_CCY.get(e.currency, e.currency)
        for e in events
        if e.impact.lower() == "high"
    }


# --- Calendario BANCHE CENTRALI della settimana --------------------------
_GIORNI = ["Lun", "Mar", "Mer", "Gio", "Ven", "Sab", "Dom"]

# Sottostringhe (minuscole) che identificano un evento di politica monetaria.
_CB_KEYWORDS = (
    "fomc", "rate decision", "interest rate", "official bank rate", "bank rate",
    "monetary policy", "policy rate", "rate statement", "cash rate",
    "overnight rate", "refinancing rate", "press conference", "mpc",
    "rate vote", "policy report", "economic bulletin",
)


@dataclass
class CbEvent:
    day: str        # es. "Mer 29/07"
    time: str       # es. "20:00" (ora locale tz) o "Tentative"
    currency: str
    title: str
    impact: str


def fetch_week_central_bank_events(tz: str = "Europe/Rome", timeout: int = 20) -> list[CbEvent]:
    """Eventi di politica monetaria da OGGI a fine settimana (feed FF thisweek).

    Filtra le decisioni sui tassi / conferenze stampa delle banche centrali
    (FOMC, ECB, BoE, BoJ, SNB, RBA, BoC, RBNZ...). Solo impatto Alto/Medio.
    Lista vuota se il feed non risponde.
    """
    try:
        resp = requests.get(FEED_URL, timeout=timeout, headers={"User-Agent": "market-agent/1.0"})
        resp.raise_for_status()
        raw = resp.json()
    except Exception:
        return []

    zone = ZoneInfo(tz)
    today = datetime.now(zone).date()
    out: list[CbEvent] = []

    for item in raw:
        title = (item.get("title", "") or "")
        low = title.lower()
        if not any(k in low for k in _CB_KEYWORDS):
            continue
        impact = (item.get("impact", "") or "")
        if impact.lower() not in ("high", "medium"):
            continue
        date_str = item.get("date")
        if not date_str:
            continue
        try:
            dt = datetime.fromisoformat(date_str).astimezone(zone)
        except ValueError:
            continue
        if dt.date() < today:
            continue
        out.append(
            CbEvent(
                day=f"{_GIORNI[dt.weekday()]} {dt.strftime('%d/%m')}",
                time=dt.strftime("%H:%M"),
                currency=item.get("country", "") or "",
                title=title,
                impact=impact,
            )
        )

    out.sort(key=lambda e: (e.day, e.time))
    return out
