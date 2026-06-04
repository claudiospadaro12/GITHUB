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

    return Instrument(
        name=name,
        ticker=ticker,
        last_close=round(last, 4),
        change_pct=round(change_pct, 2) if change_pct is not None else None,
        sma20=round(sma20, 4),
        sma50=round(sma50, 4) if sma50 is not None else None,
        sma200=round(sma200, 4) if sma200 is not None else None,
        rsi14=round(rsi, 1),
        bias=_bias_from_score(score),
        score=score,
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
