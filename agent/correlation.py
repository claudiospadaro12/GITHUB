"""Correlazione multi-timeframe del DAX con gli indici di riferimento.

Implementa la regola dei piani ABTG: il *bias* del DAX si conferma quando
S&P 500 e Nikkei 225 sono allineati con esso; una divergenza (correlazione
crollata o direzione opposta) e' un avviso di **possibile falso breakout**.

Per ogni riferimento e ogni timeframe calcola:
  - la correlazione di Pearson sui rendimenti (quanto si muovono insieme);
  - la direzione di ciascuno (prezzo vs EMA20) e se sono allineate.

⚠️ Limiti onesti: i dati intraday di Yahoo hanno ritardi/gap e storico corto;
   inoltre le sessioni non sempre si sovrappongono (DAX cash vs Nikkei). Quando
   i dati non bastano il campo e' marcato "non verificabile", non inventato.
"""

from __future__ import annotations

from dataclasses import dataclass, field

import pandas as pd
import yfinance as yf

DAX_TICKER = "^GDAXI"

# Riferimenti come da piani ABTG: (nome, ticker cash per il D1, proxy futures
# per l'intraday — i futures scambiano ~23h e si sovrappongono col mattino EU).
REFERENCES: list[tuple[str, str, str]] = [
    ("S&P 500", "^GSPC", "ES=F"),
    ("Nikkei 225", "^N225", "NKD=F"),
]

# (etichetta, period, interval, barre minime per un calcolo affidabile)
TIMEFRAMES: list[tuple[str, str, str, int]] = [
    ("D1", "6mo", "1d", 30),
    ("H1", "1mo", "60m", 20),
    ("M15", "5d", "15m", 20),
]

# soglia di variazione prezzo/EMA per considerare una direzione (non laterale)
_DIR_THRESHOLD = 0.0015


@dataclass
class TFCorr:
    """Correlazione DAX-riferimento su un singolo timeframe."""

    timeframe: str
    corr: float | None = None
    dax_dir: str | None = None
    ref_dir: str | None = None
    aligned: bool | None = None
    note: str | None = None


@dataclass
class RefCorr:
    """Tutti i timeframe per un riferimento (es. S&P 500)."""

    name: str
    ticker: str
    per_tf: list[TFCorr] = field(default_factory=list)


def _download_close(ticker: str, period: str, interval: str) -> pd.Series | None:
    try:
        df = yf.download(
            ticker, period=period, interval=interval,
            auto_adjust=False, progress=False, threads=False,
        )
        if df is None or df.empty:
            return None
        close = df["Close"]
        if isinstance(close, pd.DataFrame):
            close = close.iloc[:, 0]
        return close.dropna()
    except Exception:
        return None


def _direction(close: pd.Series) -> str | None:
    """Direzione dello strumento: prezzo vs EMA20 sul timeframe dato."""
    if close is None or len(close) < 20:
        return None
    ema = close.ewm(span=20, min_periods=10).mean()
    last = float(close.iloc[-1])
    ref = float(ema.iloc[-1])
    if ref == 0:
        return None
    diff = (last - ref) / ref
    if diff > _DIR_THRESHOLD:
        return "rialzista"
    if diff < -_DIR_THRESHOLD:
        return "ribassista"
    return "laterale"


def _one(label: str, period: str, interval: str, minbars: int,
         ref_cash: str, ref_fut: str, intraday: bool) -> TFCorr:
    ref_ticker = ref_fut if intraday else ref_cash
    dax = _download_close(DAX_TICKER, period, interval)
    ref = _download_close(ref_ticker, period, interval)
    if dax is None or ref is None:
        return TFCorr(label, note="dati non disponibili")

    joined = pd.concat(
        [dax.rename("dax"), ref.rename("ref")], axis=1, join="inner"
    ).dropna()
    if len(joined) < minbars:
        return TFCorr(label, note="storico/sovrapposizione insufficiente")

    ret = joined.pct_change().dropna()
    try:
        corr = float(ret["dax"].corr(ret["ref"]))
    except Exception:
        corr = None
    dd = _direction(joined["dax"])
    rd = _direction(joined["ref"])
    aligned = (dd is not None and rd is not None and dd == rd and dd != "laterale")
    return TFCorr(label, corr=corr, dax_dir=dd, ref_dir=rd, aligned=aligned)


GOLD_TICKER = "GC=F"
DXY_TICKER = "DX-Y.NYB"


def _pair_corr(label: str, period: str, interval: str, minbars: int,
               a_ticker: str, b_ticker: str, inverse: bool) -> TFCorr:
    """Correlazione generica tra due strumenti su un timeframe.

    Con `inverse=True` l'allineamento "sano" e' quando i due si muovono in
    direzioni OPPOSTE (caso oro vs dollaro: quando il dollaro scende, l'oro sale).
    """
    a = _download_close(a_ticker, period, interval)
    b = _download_close(b_ticker, period, interval)
    if a is None or b is None:
        return TFCorr(label, note="dati non disponibili")
    joined = pd.concat([a.rename("a"), b.rename("b")], axis=1, join="inner").dropna()
    if len(joined) < minbars:
        return TFCorr(label, note="storico/sovrapposizione insufficiente")
    ret = joined.pct_change().dropna()
    try:
        corr = float(ret["a"].corr(ret["b"]))
    except Exception:
        corr = None
    ad = _direction(joined["a"])
    bd = _direction(joined["b"])
    if inverse:
        aligned = (ad is not None and bd is not None
                   and ad != "laterale" and bd != "laterale" and ad != bd)
    else:
        aligned = (ad is not None and bd is not None and ad == bd and ad != "laterale")
    return TFCorr(label, corr=corr, dax_dir=ad, ref_dir=bd, aligned=aligned)


def compute_gold_dxy() -> RefCorr:
    """Correlazione ORO vs Dollaro (DXY) su D1/H1/M15 — relazione inversa."""
    rc = RefCorr(name="Oro vs Dollaro (DXY)", ticker=DXY_TICKER)
    for label, period, interval, minbars in TIMEFRAMES:
        rc.per_tf.append(
            _pair_corr(label, period, interval, minbars, GOLD_TICKER, DXY_TICKER, inverse=True)
        )
    return rc


def gold_dxy_verdict(rc: RefCorr | None) -> str:
    """Sintesi del bias oro secondo la relazione inversa col dollaro."""
    if rc is None:
        return "Correlazione oro/dollaro non disponibile."
    d1 = next((tf for tf in rc.per_tf if tf.timeframe == "D1"), None)
    if d1 is None or d1.note or d1.dax_dir is None or d1.ref_dir is None:
        return "Correlazione oro/dollaro non verificabile (dati insufficienti)."
    gold, dxy = d1.dax_dir, d1.ref_dir  # dax_dir=oro, ref_dir=dollaro
    corr_s = f" (correlazione {d1.corr:.2f})" if d1.corr is not None else ""
    if gold == "rialzista" and dxy == "ribassista":
        return ("Oro sostenuto dal dollaro DEBOLE: relazione inversa sana, bias oro "
                f"rialzista confermato{corr_s}.")
    if gold == "ribassista" and dxy == "rialzista":
        return ("Oro frenato dal dollaro FORTE: relazione inversa sana, bias oro "
                f"ribassista{corr_s}.")
    if gold != "laterale" and gold == dxy:
        return (f"⚠️ Oro e dollaro nella STESSA direzione ({gold}): relazione inversa "
                f"rotta, cautela{corr_s}.")
    return f"Quadro oro/dollaro poco direzionale (oro {gold}, dollaro {dxy}){corr_s}."


def compute() -> list[RefCorr]:
    """Calcola la correlazione DAX vs S&P e DAX vs Nikkei su D1/H1/M15."""
    out: list[RefCorr] = []
    for name, cash, fut in REFERENCES:
        rc = RefCorr(name=name, ticker=cash)
        for label, period, interval, minbars in TIMEFRAMES:
            rc.per_tf.append(
                _one(label, period, interval, minbars, cash, fut, intraday=(label != "D1"))
            )
        out.append(rc)
    return out


def verdict(refs: list[RefCorr]) -> str:
    """Sintesi testuale del bias DAX in base all'allineamento (regola ABTG)."""
    d1_aligned: list[bool] = []
    diverging: list[str] = []
    for rc in refs:
        for tf in rc.per_tf:
            if tf.timeframe == "D1" and tf.aligned is not None:
                d1_aligned.append(tf.aligned)
                if not tf.aligned and tf.dax_dir and tf.ref_dir and tf.dax_dir != "laterale":
                    diverging.append(f"{rc.name} ({tf.dax_dir} DAX vs {tf.ref_dir})")
    if not d1_aligned:
        return "Correlazione non verificabile (dati insufficienti)."
    if all(d1_aligned):
        return ("Bias DAX CONFERMATO: allineato con S&P e Nikkei sul Daily "
                "(coerente con la regola ABTG di conferma).")
    if diverging:
        return ("⚠️ DIVERGENZA sul Daily: " + "; ".join(diverging)
                + " → cautela, possibile falso breakout (regola ABTG).")
    return "Allineamento parziale: valutare con prudenza."


def format_for_prompt(refs: list[RefCorr]) -> str:
    """Testo compatto per il prompt di Claude."""
    lines: list[str] = ["CORRELAZIONE DAX (regola ABTG: conferma se S&P+Nikkei allineati):"]
    for rc in refs:
        parts: list[str] = []
        for tf in rc.per_tf:
            if tf.note:
                parts.append(f"{tf.timeframe}: n/d ({tf.note})")
            else:
                c = f"{tf.corr:.2f}" if tf.corr is not None else "n/d"
                al = "allineati" if tf.aligned else "divergenza"
                parts.append(f"{tf.timeframe}: corr {c}, DAX {tf.dax_dir}/ref {tf.ref_dir} → {al}")
        lines.append(f"- DAX vs {rc.name}: " + " | ".join(parts))
    lines.append("SINTESI: " + verdict(refs))
    return "\n".join(lines)
