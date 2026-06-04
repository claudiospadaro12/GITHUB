"""Sintesi ragionata del report tramite Claude (Opus 4.8).

Riceve i dati tecnici deterministici (già calcolati) e il calendario macro, e
chiede a Claude di produrre il *commento analitico* in italiano: lettura del
quadro, direzione attesa del trend giornaliero per indici e oro, eventi macro
chiave e cross forex da evitare. Le tabelle numeriche vere e proprie vengono
renderizzate separatamente in `report.py`, così i numeri restano riproducibili.
"""

from __future__ import annotations

import anthropic

from . import config
from .macro_calendar import MacroEvent, high_impact_currencies
from .market_data import Instrument

SYSTEM_PROMPT = """\
Sei un analista finanziario senior specializzato in indici azionari, oro e \
mercato forex. Scrivi in italiano, in modo chiaro, professionale e conciso, \
per un trader che opera in giornata.

Ti vengono forniti dati tecnici GIÀ CALCOLATI (prezzo, variazione %, medie \
mobili SMA20/50/200, RSI14 e un "bias" di trend deterministico) e il calendario \
macro della giornata. Devi usare ESCLUSIVAMENTE questi numeri: non inventarne \
altri, non citare prezzi non presenti nei dati.

Produci SOLO frammenti HTML (niente <html>, <head> o <body>, niente recinti di \
codice markdown). Usa questa struttura, con questi titoli esatti:

<h2>Quadro generale</h2>
<p>2-4 frasi sul tono del mercato (risk-on / risk-off), basate sui bias e sui \
principali eventi macro di oggi.</p>

<h2>Direzione attesa del trend (oggi)</h2>
<ul>
  <li>Per OGNI indice e per l'oro: nome, direzione attesa (Rialzista / Ribassista \
/ Laterale), e una motivazione di una riga ancorata ai dati (es. prezzo sopra/sotto \
le medie, RSI, eventi macro).</li>
</ul>

<h2>Livelli chiave (supporti e resistenze)</h2>
<ul>
  <li>Per OGNI indice e per l'oro: indica la resistenza più vicina sopra il prezzo \
e il supporto più vicino sotto, scegliendoli tra i livelli forniti (pivot R1/R2/S1/S2 \
e massimi/minimi a 20 sedute). Una riga ciascuno, con i valori numerici esatti.</li>
</ul>

<h2>Zona di Fibonacci (golden zone)</h2>
<ul>
  <li>Per OGNI indice e per l'oro: indica la <strong>golden zone</strong> (fascia 50%–61,8% \
del ritracciamento, con i due valori numerici) e dove si trova il prezzo rispetto ad essa \
(sopra / dentro / sotto, usando il campo fib_zone). Spiega in una riga dove il prezzo \
potrebbe fermarsi/reagire: in un ritracciamento sano è proprio nella golden zone che il \
trend tende a riprendere. Tieni conto della direzione dello swing (fib_dir).</li>
</ul>

<h2>Notizie macroeconomiche più importanti</h2>
<ul>
  <li>Gli eventi ad alto impatto di oggi (orario, valuta, evento) e perché contano. \
Se non ce ne sono, dillo esplicitamente.</li>
</ul>

<h2>Cross forex da evitare oggi</h2>
<ul>
  <li>Indica i cross su cui è prudente NON operare o operare con cautela oggi \
(es. perché coinvolti in eventi macro ad alto impatto → volatilità imprevedibile), \
con una riga di motivazione ciascuno.</li>
</ul>

Regole:
- Sii prudente e probabilistico: parla di "scenario atteso", mai di certezze.
- Non dare ordini di acquisto/vendita né livelli di entrata: fornisci lettura di \
contesto, non segnali operativi.
- Niente preamboli, niente conclusioni extra: solo le quattro sezioni richieste.
"""


def _format_instruments(label: str, items: list[Instrument]) -> str:
    lines = [f"## {label}"]
    for it in items:
        if it.error:
            lines.append(f"- {it.name} [{it.ticker}]: dato non disponibile ({it.error})")
            continue
        parts = [
            f"prezzo={it.last_close}",
            f"var={it.change_pct}%",
            f"SMA20={it.sma20}",
            f"SMA50={it.sma50}",
            f"SMA200={it.sma200}",
            f"RSI14={it.rsi14}",
            f"bias={it.bias}",
            f"pivot={it.pivot}",
            f"R1={it.r1}",
            f"R2={it.r2}",
            f"S1={it.s1}",
            f"S2={it.s2}",
            f"max20={it.recent_high}",
            f"min20={it.recent_low}",
            f"fib_dir={it.fib_direction}",
            f"fib_swing={it.fib_swing_low}-{it.fib_swing_high}",
            f"fib38.2={it.fib_382}",
            f"fib50={it.fib_50}",
            f"fib61.8={it.fib_618}",
            f"golden_zone={it.golden_low}-{it.golden_high}",
            f"fib_zone={it.fib_zone}",
        ]
        lines.append(f"- {it.name} [{it.ticker}]: " + ", ".join(str(p) for p in parts))
    return "\n".join(lines)


def _format_events(events: list[MacroEvent]) -> str:
    if not events:
        return "Nessun evento nel calendario (feed non disponibile o giornata senza dati)."
    lines = []
    for e in events:
        lines.append(
            f"- {e.time} | {e.currency} | impatto={e.impact} | {e.title} "
            f"(prev={e.previous or 'n/d'}, forecast={e.forecast or 'n/d'})"
        )
    return "\n".join(lines)


def build_user_content(
    groups: dict[str, list[Instrument]],
    events: list[MacroEvent],
    date_str: str,
) -> str:
    hi_ccy = high_impact_currencies(events)
    sections = [
        f"DATA: {date_str}",
        "",
        "DATI TECNICI:",
        _format_instruments("Indici", groups["Indici"]),
        _format_instruments("Materie prime", groups["Materie prime"]),
        _format_instruments("Forex", groups["Forex"]),
        "",
        "CALENDARIO MACRO DI OGGI:",
        _format_events(events),
        "",
        "VALUTE CON EVENTI AD ALTO IMPATTO OGGI: "
        + (", ".join(sorted(hi_ccy)) if hi_ccy else "nessuna"),
        "",
        "Genera il report HTML come da istruzioni.",
    ]
    return "\n".join(sections)


def generate_commentary(
    settings: config.Settings,
    groups: dict[str, list[Instrument]],
    events: list[MacroEvent],
    date_str: str,
) -> str:
    """Chiama Claude e restituisce il commento analitico in HTML."""
    client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    user_content = build_user_content(groups, events, date_str)

    # Streaming + get_final_message: protegge dai timeout su output lunghi.
    # Prompt caching sul system prompt (stabile) per ridurre i costi nel tempo.
    with client.messages.stream(
        model=config.MODEL,
        max_tokens=8000,
        thinking={"type": "adaptive"},
        output_config={"effort": "high"},
        system=[
            {
                "type": "text",
                "text": SYSTEM_PROMPT,
                "cache_control": {"type": "ephemeral"},
            }
        ],
        messages=[{"role": "user", "content": user_content}],
    ) as stream:
        message = stream.get_final_message()

    return "".join(block.text for block in message.content if block.type == "text").strip()
