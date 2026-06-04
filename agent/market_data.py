"""Raccolta dati di mercato e calcolo di indicatori tecnici.

Per ogni strumento scarica lo storico giornaliero da Yahoo Finance (yfinance,
gratuito, senza chiave) e calcola un *bias* di trend deterministico basato su
medie mobili e RSI. Il bias è poi passato a Claude come base fattuale per la
sintesi — così la parte numerica è riproducibile e non "inventata" dal modello.
"""

from __future__ import annotations

from dataclasses import dataclass

import pandas as pd
import yfinance as yf


@dataclass
class Instrument:
    """Snapshot tecnico di uno strumento."""

    name: str
    ticker: str
    last_close: float | None = None
    change_pct: float | None = None  # variazione % sull'ultima seduta
    sma20: float | None = None
    sma50: float | None = None
    sma200: float | None = None
    rsi14: float | None = None
    bias: str = "Dati non disponibili"
    score: int = 0
    # Supporti e resistenze
    pivot: float | None = None
    r1: float | None = None
    r2: float | None = None
    s1: float | None = None
    s2: float | None = None
    recent_high: float | None = None  # massimo a 20 sedute
    recent_low: float | None = None   # minimo a 20 sedute
    # Fibonacci (ritracciamenti sull'ultimo swing significativo)
    fib_direction: str | None = None  # "rialzista" | "ribassista"
    fib_swing_low: float | None = None
    fib_swing_high: float | None = None
    fib_236: float | None = None
    fib_382: float | None = None
    fib_50: float | None = None
    fib_618: float | None = None
    fib_786: float | None = None
    golden_low: float | None = None   # confine inferiore golden zone (50–61,8%)
    golden_high: float | None = None  # confine superiore golden zone
    fib_zone: str | None = None       # posizione del prezzo rispetto alla golden zone
    error: str | None = None


def _rsi(close: pd.Series, period: int = 14) -> pd.Series:
    """RSI di Wilder."""
    delta = close.diff()
    gain = delta.clip(lower=0)
    loss = -delta.clip(upper=0)
    avg_gain = gain.ewm(alpha=1 / period, min_periods=period).mean()
    avg_loss = loss.ewm(alpha=1 / period, min_periods=period).mean()
    rs = avg_gain / avg_loss
    return 100 - 100 / (1 + rs)


def _r(value: float) -> float:
    """Arrotonda con precisione adatta alla scala del prezzo."""
    return round(value, 2) if abs(value) >= 100 else round(value, 4)


def _pivot_levels(high: float, low: float, close: float) -> dict[str, float]:
    """Pivot point classici dall'ultima seduta completata."""
    pivot = (high + low + close) / 3
    rng = high - low
    return {
        "pivot": _r(pivot),
        "r1": _r(2 * pivot - low),
        "s1": _r(2 * pivot - high),
        "r2": _r(pivot + rng),
        "s2": _r(pivot - rng),
    }


def _fibonacci(
    highs: pd.Series, lows: pd.Series, last: float, lookback: int = 60
) -> dict | None:
    """Ritracciamenti di Fibonacci sull'ultimo swing significativo.

    Individua swing high/low nelle ultime `lookback` sedute, deduce la
    direzione dello swing dalla posizione relativa dei due estremi e calcola i
    livelli di ritracciamento. La golden zone è la fascia 50%–61,8%.
    """
    h = highs.tail(lookback).reset_index(drop=True)
    l = lows.tail(lookback).reset_index(drop=True)
    if len(h) < 5 or len(l) < 5:
        return None

    swing_high = float(h.max())
    swing_low = float(l.min())
    rng = swing_high - swing_low
    if rng <= 0:
        return None

    # Lo swing è rialzista se il minimo precede il massimo (movimento dal basso
    # verso l'alto): il ritracciamento atteso è verso il basso, dentro la zona.
    up = int(l.idxmin()) < int(h.idxmax())

    ratios = {"236": 0.236, "382": 0.382, "50": 0.5, "618": 0.618, "786": 0.786}
    levels = {
        k: _r(swing_high - r * rng) if up else _r(swing_low + r * rng)
        for k, r in ratios.items()
    }

    g_low = min(levels["50"], levels["618"])
    g_high = max(levels["50"], levels["618"])
    if last < g_low:
        zone = "Sotto la golden zone"
    elif last > g_high:
        zone = "Sopra la golden zone"
    else:
        zone = "Dentro la golden zone (50–61,8%)"

    return {
        "direction": "rialzista" if up else "ribassista",
        "swing_low": _r(swing_low),
        "swing_high": _r(swing_high),
        "levels": levels,
        "golden_low": g_low,
        "golden_high": g_high,
        "zone": zone,
    }


def _bias_from_score(score: int) -> str:
    if score >= 3:
        return "Rialzista forte"
    if score >= 1:
        return "Rialzista"
    if score == 0:
        return "Neutrale / laterale"
    if score >= -2:
        return "Ribassista"
    return "Ribassista forte"


def _analyze_frame(name: str, ticker: str, df: pd.DataFrame) -> Instrument:
    close = df["Close"].dropna()
    if len(close) < 30:
        return Instrument(name=name, ticker=ticker, error="storico insufficiente")

    last = float(close.iloc[-1])
    prev = float(close.iloc[-2])
    change_pct = (last - prev) / prev * 100 if prev else None

    sma20 = float(close.rolling(20).mean().iloc[-1])
    sma50 = float(close.rolling(50).mean().iloc[-1]) if len(close) >= 50 else None
    sma200 = float(close.rolling(200).mean().iloc[-1]) if len(close) >= 200 else None
    rsi = float(_rsi(close).iloc[-1])

    # Punteggio composito → bias di trend
    score = 0
    score += 1 if last > sma20 else -1
    if sma50 is not None:
        score += 1 if last > sma50 else -1
        score += 1 if sma20 > sma50 else -1
    if sma200 is not None:
        score += 1 if last > sma200 else -1
    if rsi > 55:
        score += 1
    elif rsi < 45:
        score -= 1

    # Supporti/resistenze: pivot dall'ultima seduta + estremi recenti (20 sedute).
    # Fibonacci: ritracciamenti sull'ultimo swing (~60 sedute) con golden zone.
    levels: dict[str, float] = {}
    recent_high = recent_low = None
    fib: dict | None = None
    if "High" in df.columns and "Low" in df.columns:
        highs = df["High"].dropna()
        lows = df["Low"].dropna()
        if len(highs) and len(lows):
            levels = _pivot_levels(float(highs.iloc[-1]), float(lows.iloc[-1]), last)
            recent_high = _r(float(highs.tail(20).max()))
            recent_low = _r(float(lows.tail(20).min()))
            fib = _fibonacci(highs, lows, last)

    fl = (fib or {}).get("levels", {})
    return Instrument(
        name=name,
        ticker=ticker,
        last_close=_r(last),
        change_pct=round(change_pct, 2) if change_pct is not None else None,
        sma20=_r(sma20),
        sma50=_r(sma50) if sma50 is not None else None,
        sma200=_r(sma200) if sma200 is not None else None,
        rsi14=round(rsi, 1),
        bias=_bias_from_score(score),
        score=score,
        pivot=levels.get("pivot"),
        r1=levels.get("r1"),
        r2=levels.get("r2"),
        s1=levels.get("s1"),
        s2=levels.get("s2"),
        recent_high=recent_high,
        recent_low=recent_low,
        fib_direction=(fib or {}).get("direction"),
        fib_swing_low=(fib or {}).get("swing_low"),
        fib_swing_high=(fib or {}).get("swing_high"),
        fib_236=fl.get("236"),
        fib_382=fl.get("382"),
        fib_50=fl.get("50"),
        fib_618=fl.get("618"),
        fib_786=fl.get("786"),
        golden_low=(fib or {}).get("golden_low"),
        golden_high=(fib or {}).get("golden_high"),
        fib_zone=(fib or {}).get("zone"),
    )


def fetch_instruments(mapping: dict[str, str]) -> list[Instrument]:
    """Scarica e analizza un gruppo di strumenti {nome: ticker}."""
    results: list[Instrument] = []
    for name, ticker in mapping.items():
        try:
            df = yf.download(
                ticker,
                period="1y",
                interval="1d",
                auto_adjust=False,
                progress=False,
                threads=False,
            )
            # yfinance può restituire colonne multi-livello: appiattiamole.
            if isinstance(df.columns, pd.MultiIndex):
                df.columns = df.columns.get_level_values(0)
            if df.empty:
                results.append(
                    Instrument(name=name, ticker=ticker, error="nessun dato restituito")
                )
                continue
            results.append(_analyze_frame(name, ticker, df))
        except Exception as exc:  # rete/ticker errato: non bloccare il report
            results.append(Instrument(name=name, ticker=ticker, error=str(exc)[:200]))
    return results


def collect_all(indices, commodities, forex) -> dict[str, list[Instrument]]:
    """Raccoglie tutti i gruppi di strumenti."""
    return {
        "Indici": fetch_instruments(indices),
        "Materie prime": fetch_instruments(commodities),
        "Forex": fetch_instruments(forex),
    }
