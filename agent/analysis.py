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

<h2>Bias DAX e correlazione (S&amp;P / Nikkei)</h2>
<p>Usando ESCLUSIVAMENTE i dati della sezione CORRELAZIONE DAX forniti: indica il \
bias del DAX e se è CONFERMATO o meno dall'allineamento con S&amp;P 500 e Nikkei 225 \
sui vari timeframe (D1/H1/M15). Regola ABTG: se sono allineati il bias è più \
affidabile; se divergono (correlazione bassa o direzione opposta) segnala il rischio \
di <strong>falso breakout</strong> e invita a prudenza. Se un timeframe è "non \
verificabile", dillo, non inventare.</p>

<h2>Direzione attesa del trend (oggi)</h2>
<ul>
  <li>Per OGNI indice e per l'oro: nome, direzione attesa (Rialzista / Ribassista \
/ Laterale), e una motivazione di una riga ancorata ai dati (es. prezzo sopra/sotto \
le medie, RSI, eventi macro).</li>
</ul>

<h2>Livelli chiave (supporti e resistenze)</h2>
<ul>
  <li>Per OGNI indice e per l'oro: indica la resistenza più vicina sopra il prezzo \
e il supporto più vicino sotto, scegliendoli tra i livelli forniti (pivot R1/R2/S1/S2, \
max/min del giorno precedente e della settimana precedente, massimi/minimi a 20 sedute). \
Una riga ciascuno, con i valori numerici esatti. Indica anche la <strong>zona per un \
eventuale ordine pendente</strong>: BUY STOP appena sopra la resistenza chiave, SELL STOP \
appena sotto il supporto chiave. Ricorda che è un'indicazione di zona, non un segnale.</li>
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
            f"maxGiornoPrec={it.prev_day_high}",
            f"minGiornoPrec={it.prev_day_low}",
            f"maxSettPrec={it.prev_week_high}",
            f"minSettPrec={it.prev_week_low}",
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
    correlation_text: str = "",
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
        (correlation_text or "CORRELAZIONE DAX: non disponibile."),
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


def _dir_from_bias(bias: str) -> str:
    b = (bias or "").lower()
    if "rialz" in b:
        return "Rialzista"
    if "ribass" in b:
        return "Ribassista"
    return "Laterale"


def _nearest_levels(it: Instrument) -> tuple[float | None, float | None]:
    """Resistenza piu' vicina sopra il prezzo e supporto piu' vicino sotto."""
    last = it.last_close
    if last is None:
        return None, None
    above = [v for v in (it.r1, it.r2, it.prev_day_high, it.prev_week_high, it.recent_high) if v is not None and v > last]
    below = [v for v in (it.s1, it.s2, it.prev_day_low, it.prev_week_low, it.recent_low) if v is not None and v < last]
    res = min(above) if above else None
    sup = max(below) if below else None
    return res, sup


def _fallback_instrument_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error:
            rows.append(f"<li><strong>{it.name}</strong>: dato non disponibile ({it.error}).</li>")
            continue
        direction = _dir_from_bias(it.bias)
        motivo = []
        if it.sma20 is not None and it.last_close is not None:
            motivo.append("sopra SMA20" if it.last_close > it.sma20 else "sotto SMA20")
        if it.sma200 is not None and it.last_close is not None:
            motivo.append("sopra SMA200" if it.last_close > it.sma200 else "sotto SMA200")
        if it.rsi14 is not None:
            motivo.append(f"RSI {it.rsi14}")
        m = ", ".join(motivo) if motivo else "quadro tecnico"
        rows.append(
            f"<li><strong>{it.name}</strong> — {direction} "
            f"(prezzo {it.last_close}, {m}; bias {it.bias}).</li>"
        )
    return "\n".join(rows)


def _fallback_levels_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error or it.last_close is None:
            continue
        res, sup = _nearest_levels(it)
        res_txt = f"resistenza {res} (zona BUY STOP appena sopra)" if res is not None else "resistenza n/d"
        sup_txt = f"supporto {sup} (zona SELL STOP appena sotto)" if sup is not None else "supporto n/d"
        rows.append(f"<li><strong>{it.name}</strong> (prezzo {it.last_close}): {res_txt}; {sup_txt}.</li>")
    return "\n".join(rows)


def _fallback_fib_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error or it.golden_low is None or it.golden_high is None:
            continue
        rows.append(
            f"<li><strong>{it.name}</strong>: golden zone {it.golden_low}–{it.golden_high} "
            f"(swing {it.fib_direction}). Prezzo: {it.fib_zone or 'n/d'}.</li>"
        )
    return "\n".join(rows)


def build_fallback_commentary(
    groups: dict[str, list[Instrument]],
    events: list[MacroEvent],
    correlation_obj=None,
    gold_dxy_obj=None,
) -> str:
    """Analisi deterministica (senza AI) con la stessa struttura del report.

    Usata quando la chiave Claude non e' disponibile o l'API non risponde: il
    report parte comunque, completo di bias, direzione, correlazione, livelli,
    Fibonacci, news e cross da evitare, tutto calcolato dai dati.
    """
    from . import correlation as corr_mod

    hi_ccy = sorted(high_impact_currencies(events))
    corr_verdict = corr_mod.verdict(correlation_obj) if correlation_obj else "Correlazione non disponibile."
    gold_verdict = corr_mod.gold_dxy_verdict(gold_dxy_obj)

    all_items = groups["Indici"] + groups["Materie prime"]
    forex = groups["Forex"]

    # Direzione sintetica del quadro: quanti indici/oro rialzisti vs ribassisti
    up = sum(1 for it in all_items if _dir_from_bias(it.bias) == "Rialzista")
    down = sum(1 for it in all_items if _dir_from_bias(it.bias) == "Ribassista")
    if up > down:
        tono = "prevalentemente costruttivo (piu' strumenti sopra le medie)"
    elif down > up:
        tono = "prevalentemente debole (piu' strumenti sotto le medie)"
    else:
        tono = "misto/laterale (segnali contrastanti)"

    news_rows = "\n".join(
        f"<li>{e.time} — {e.currency} — {e.title} (prev {e.previous or 'n/d'}, forecast {e.forecast or 'n/d'}).</li>"
        for e in events if e.impact.lower() == "high"
    ) or "<li>Nessun evento ad alto impatto in calendario oggi.</li>"

    if hi_ccy:
        forex_rows = "\n".join(
            f"<li><strong>{it.name}</strong>: coinvolge una valuta con news ad alto impatto oggi "
            f"({', '.join(c for c in hi_ccy if c in it.name.replace('/', ''))}) → prudenza/volatilita'.</li>"
            for it in forex
            if any(c in it.name.replace('/', '') for c in hi_ccy)
        ) or "<li>Nessun cross direttamente esposto a news ad alto impatto oggi.</li>"
    else:
        forex_rows = "<li>Oggi nessuna valuta con eventi ad alto impatto: nessun cross da evitare per news.</li>"

    return f"""\
<h2>Quadro generale</h2>
<p>Scenario atteso {tono}. {corr_verdict} Le indicazioni sotto sono di contesto, non segnali operativi.</p>

<h2>Bias DAX e correlazione (S&amp;P / Nikkei)</h2>
<p>{corr_verdict}</p>

<h2>Bias oro e dollaro (relazione inversa)</h2>
<p>{gold_verdict}</p>

<h2>Direzione attesa del trend (oggi)</h2>
<ul>
{_fallback_instrument_rows(all_items)}
</ul>

<h2>Livelli chiave (supporti e resistenze)</h2>
<ul>
{_fallback_levels_rows(all_items)}
</ul>

<h2>Zona di Fibonacci (golden zone)</h2>
<ul>
{_fallback_fib_rows(all_items) or "<li>Golden zone non calcolabile con lo storico disponibile.</li>"}
</ul>

<h2>Notizie macroeconomiche più importanti</h2>
<ul>
{news_rows}
</ul>

<h2>Cross forex da evitare oggi</h2>
<ul>
{forex_rows}
</ul>
<p style="color:#666;font-size:0.9em"><em>Analisi generata in modalità automatica (senza commento AI): i numeri sono
calcolati dai dati di mercato. Per il commento discorsivo più raffinato serve la chiave Claude.</em></p>"""


def generate_commentary(
    settings: config.Settings,
    groups: dict[str, list[Instrument]],
    events: list[MacroEvent],
    date_str: str,
    correlation_text: str = "",
) -> str:
    """Chiama Claude e restituisce il commento analitico in HTML."""
    client = anthropic.Anthropic(api_key=settings.anthropic_api_key)
    user_content = build_user_content(groups, events, date_str, correlation_text)

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
