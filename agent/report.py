"""Composizione del report HTML finale per l'email.

Unisce il commento analitico di Claude alle tabelle dati deterministiche e a un
disclaimer ben visibile. Lo stile è inline così da renderizzare correttamente
nei client di posta (incluso Gmail).
"""

from __future__ import annotations

from .correlation import RefCorr, verdict as corr_verdict, gold_dxy_verdict
from .macro_calendar import MacroEvent
from .market_data import Instrument

_BIAS_COLOR = {
    "Rialzista forte": "#0a7d32",
    "Rialzista": "#3a9d5d",
    "Neutrale / laterale": "#8a8a8a",
    "Ribassista": "#c45b4d",
    "Ribassista forte": "#b3261e",
}


def _fmt(value, suffix: str = "") -> str:
    if value is None:
        return "—"
    return f"{value}{suffix}"


def _instrument_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error:
            rows.append(
                f'<tr><td style="padding:6px 10px;border-bottom:1px solid #eee;">{it.name}</td>'
                f'<td colspan="6" style="padding:6px 10px;border-bottom:1px solid #eee;color:#999;">'
                f"dato non disponibile</td></tr>"
            )
            continue
        color = _BIAS_COLOR.get(it.bias, "#333")
        chg = it.change_pct
        chg_color = "#0a7d32" if (chg or 0) > 0 else ("#b3261e" if (chg or 0) < 0 else "#666")
        rows.append(
            "<tr>"
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;">{it.name}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.last_close)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;color:{chg_color};">{_fmt(chg, "%")}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.sma20)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.sma50)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.rsi14)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;font-weight:600;color:{color};">{it.bias}</td>'
            "</tr>"
        )
    return "".join(rows)


def _data_table(label: str, items: list[Instrument]) -> str:
    header_cells = ["Strumento", "Prezzo", "Var.", "SMA20", "SMA50", "RSI14", "Bias"]
    ths = "".join(
        f'<th style="padding:6px 10px;text-align:{"left" if i == 0 else "right"};'
        f'border-bottom:2px solid #ddd;font-size:12px;color:#666;">{h}</th>'
        for i, h in enumerate(header_cells)
    )
    return (
        f'<h3 style="margin:18px 0 6px;">{label}</h3>'
        '<table style="width:100%;border-collapse:collapse;font-size:13px;">'
        f"<thead><tr>{ths}</tr></thead>"
        f"<tbody>{_instrument_rows(items)}</tbody></table>"
    )


def _levels_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error or it.pivot is None:
            continue
        cells = [
            (it.name, "left", "#1a1a1a"),
            (_fmt(it.s2), "right", "#b3261e"),
            (_fmt(it.s1), "right", "#c45b4d"),
            (_fmt(it.pivot), "right", "#444"),
            (_fmt(it.r1), "right", "#3a9d5d"),
            (_fmt(it.r2), "right", "#0a7d32"),
            (_fmt(it.recent_low), "right", "#888"),
            (_fmt(it.recent_high), "right", "#888"),
        ]
        tds = "".join(
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:{a};color:{c};">{v}</td>'
            for v, a, c in cells
        )
        rows.append(f"<tr>{tds}</tr>")
    return "".join(rows)


def _levels_table(groups: dict[str, list[Instrument]]) -> str:
    items = groups["Indici"] + groups["Materie prime"] + groups["Forex"]
    body = _levels_rows(items)
    if not body:
        return '<p style="color:#999;">Livelli non disponibili.</p>'
    headers = ["Strumento", "S2", "S1", "Pivot", "R1", "R2", "Min 20g", "Max 20g"]
    ths = "".join(
        f'<th style="padding:6px 10px;text-align:{"left" if i == 0 else "right"};'
        f'border-bottom:2px solid #ddd;font-size:12px;color:#666;">{h}</th>'
        for i, h in enumerate(headers)
    )
    return (
        '<table style="width:100%;border-collapse:collapse;font-size:13px;">'
        f"<thead><tr>{ths}</tr></thead>"
        f"<tbody>{body}</tbody></table>"
        '<p style="font-size:11px;color:#aaa;margin-top:6px;">'
        "S/R = pivot point classici dall'ultima seduta; Min/Max 20g = estremi delle ultime 20 sedute."
        "</p>"
    )


def _fib_rows(items: list[Instrument]) -> str:
    rows = []
    for it in items:
        if it.error or it.fib_50 is None:
            continue
        dir_label = "▲ rialz." if it.fib_direction == "rialzista" else "▼ ribass."
        dir_color = "#0a7d32" if it.fib_direction == "rialzista" else "#b3261e"
        if it.fib_zone and it.fib_zone.startswith("Dentro"):
            zone_cell = '<span style="color:#a86a00;font-weight:700;">● Dentro</span>'
        elif it.fib_zone and it.fib_zone.startswith("Sopra"):
            zone_cell = '<span style="color:#3a9d5d;">Sopra</span>'
        else:
            zone_cell = '<span style="color:#c45b4d;">Sotto</span>'
        golden = f"{_fmt(it.golden_low)} – {_fmt(it.golden_high)}"
        rows.append(
            "<tr>"
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;">{it.name}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;color:{dir_color};">{dir_label}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.fib_382)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.fib_50)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;">{_fmt(it.fib_618)}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;text-align:right;'
            f'background:#fffbe6;font-weight:600;">{golden}</td>'
            f'<td style="padding:6px 10px;border-bottom:1px solid #eee;">{zone_cell}</td>'
            "</tr>"
        )
    return "".join(rows)


def _fib_table(groups: dict[str, list[Instrument]]) -> str:
    items = groups["Indici"] + groups["Materie prime"] + groups["Forex"]
    body = _fib_rows(items)
    if not body:
        return '<p style="color:#999;">Livelli di Fibonacci non disponibili.</p>'
    headers = ["Strumento", "Swing", "38,2%", "50%", "61,8%", "Golden zone", "Prezzo"]
    ths = "".join(
        f'<th style="padding:6px 10px;text-align:{"left" if i in (0, 1, 6) else "right"};'
        f'border-bottom:2px solid #ddd;font-size:12px;color:#666;">{h}</th>'
        for i, h in enumerate(headers)
    )
    return (
        '<table style="width:100%;border-collapse:collapse;font-size:13px;">'
        f"<thead><tr>{ths}</tr></thead>"
        f"<tbody>{body}</tbody></table>"
        '<p style="font-size:11px;color:#aaa;margin-top:6px;">'
        "La <strong>golden zone</strong> (50%–61,8% del ritracciamento sull'ultimo swing) è "
        "l'area in cui un ritracciamento sano tende a fermarsi prima che il trend riprenda. "
        "&quot;Prezzo&quot; indica dove si trova la quotazione rispetto a questa zona."
        "</p>"
    )


def _calendar_table(events: list[MacroEvent]) -> str:
    if not events:
        return '<p style="color:#999;">Nessun evento macro nel feed di oggi.</p>'
    rows = []
    for e in events:
        if e.impact.lower() == "high":
            badge = '<span style="color:#b3261e;font-weight:700;">● Alto</span>'
        elif e.impact.lower() == "medium":
            badge = '<span style="color:#d28b00;">● Medio</span>'
        else:
            badge = f'<span style="color:#999;">{e.impact or "—"}</span>'
        rows.append(
            "<tr>"
            f'<td style="padding:5px 10px;border-bottom:1px solid #eee;">{e.time}</td>'
            f'<td style="padding:5px 10px;border-bottom:1px solid #eee;font-weight:600;">{e.currency}</td>'
            f'<td style="padding:5px 10px;border-bottom:1px solid #eee;">{e.title}</td>'
            f'<td style="padding:5px 10px;border-bottom:1px solid #eee;">{badge}</td>'
            "</tr>"
        )
    return (
        '<table style="width:100%;border-collapse:collapse;font-size:13px;">'
        '<thead><tr>'
        '<th style="padding:6px 10px;text-align:left;border-bottom:2px solid #ddd;font-size:12px;color:#666;">Ora</th>'
        '<th style="padding:6px 10px;text-align:left;border-bottom:2px solid #ddd;font-size:12px;color:#666;">Valuta</th>'
        '<th style="padding:6px 10px;text-align:left;border-bottom:2px solid #ddd;font-size:12px;color:#666;">Evento</th>'
        '<th style="padding:6px 10px;text-align:left;border-bottom:2px solid #ddd;font-size:12px;color:#666;">Impatto</th>'
        "</tr></thead>"
        f"<tbody>{''.join(rows)}</tbody></table>"
    )


def _correlation_table(refs: list[RefCorr] | None) -> str:
    if not refs:
        return "<p style='color:#888;'>Correlazione non disponibile.</p>"
    head = (
        "<tr style='background:#f3f4f6;text-align:left;'>"
        "<th style='padding:6px 10px;'>DAX vs</th><th style='padding:6px 10px;'>TF</th>"
        "<th style='padding:6px 10px;'>Correlazione</th>"
        "<th style='padding:6px 10px;'>Direzioni (DAX / rif.)</th>"
        "<th style='padding:6px 10px;'>Esito</th></tr>"
    )
    rows = ""
    for rc in refs:
        for i, tf in enumerate(rc.per_tf):
            first = (
                f"<td rowspan='{len(rc.per_tf)}' style='padding:6px 10px;font-weight:600;"
                f"border-top:1px solid #eee;'>{rc.name}</td>" if i == 0 else ""
            )
            if tf.note:
                corr_s, dirs, esito, color = "n/d", "—", tf.note, "#8a8a8a"
            else:
                corr_s = f"{tf.corr:.2f}" if tf.corr is not None else "n/d"
                dirs = f"{tf.dax_dir or '—'} / {tf.ref_dir or '—'}"
                esito = "✓ allineati" if tf.aligned else "⚠ divergenza"
                color = "#0a7d32" if tf.aligned else "#b3261e"
            rows += (
                f"<tr style='border-top:1px solid #eee;'>{first}"
                f"<td style='padding:6px 10px;'>{tf.timeframe}</td>"
                f"<td style='padding:6px 10px;'>{corr_s}</td>"
                f"<td style='padding:6px 10px;'>{dirs}</td>"
                f"<td style='padding:6px 10px;color:{color};font-weight:600;'>{esito}</td></tr>"
            )
    v = corr_verdict(refs)
    return (
        f"<table style='border-collapse:collapse;width:100%;font-size:13px;'>{head}{rows}</table>"
        f"<div style='margin-top:8px;padding:8px 12px;background:#eef2ff;border-radius:6px;"
        f"font-size:13px;'><strong>Sintesi bias DAX:</strong> {v}</div>"
    )


def _keylevels_table(groups: dict[str, list[Instrument]]) -> str:
    """Livelli chiave del giorno + zone suggerite per gli ordini pendenti."""
    items = groups["Indici"] + groups["Materie prime"]
    head = (
        "<tr style='background:#f3f4f6;text-align:left;'>"
        "<th style='padding:6px 10px;'>Strumento</th>"
        "<th style='padding:6px 10px;'>Prezzo</th>"
        "<th style='padding:6px 10px;'>Max/Min Giorno Prec.</th>"
        "<th style='padding:6px 10px;'>Max/Min Sett. Prec.</th>"
        "<th style='padding:6px 10px;'>Pivot</th>"
        "<th style='padding:6px 10px;'>Ordini pendenti (idea)</th></tr>"
    )
    rows = ""
    for it in items:
        if it.error:
            continue
        pd_hl = f"{_fmt(it.prev_day_high)} / {_fmt(it.prev_day_low)}"
        pw_hl = f"{_fmt(it.prev_week_high)} / {_fmt(it.prev_week_low)}"
        # idea ordini pendenti: BUY STOP sopra la resistenza vicina, SELL STOP sotto il supporto vicino
        res = it.prev_day_high
        sup = it.prev_day_low
        pend = (
            f"BUY STOP &gt; {_fmt(res)} · SELL STOP &lt; {_fmt(sup)}"
            if res is not None and sup is not None else "—"
        )
        rows += (
            "<tr style='border-top:1px solid #eee;'>"
            f"<td style='padding:6px 10px;font-weight:600;'>{it.name}</td>"
            f"<td style='padding:6px 10px;'>{_fmt(it.last_close)}</td>"
            f"<td style='padding:6px 10px;'>{pd_hl}</td>"
            f"<td style='padding:6px 10px;'>{pw_hl}</td>"
            f"<td style='padding:6px 10px;'>{_fmt(it.pivot)}</td>"
            f"<td style='padding:6px 10px;font-size:12px;'>{pend}</td></tr>"
        )
    note = (
        "<div style='margin-top:6px;font-size:11px;color:#888;'>"
        "Metti il BUY STOP qualche punto <em>sopra</em> la resistenza e il SELL STOP qualche "
        "punto <em>sotto</em> il supporto (buffer ~10 punti indice). Il <strong>box notturno</strong> "
        "(00:00–05:59) leggilo dall'indicatore sul grafico: i dati overnight non sono disponibili qui.</div>"
    )
    return f"<table style='border-collapse:collapse;width:100%;font-size:13px;'>{head}{rows}</table>{note}"


def _gold_dxy_table(rc: RefCorr | None) -> str:
    """Correlazione oro↔dollaro (relazione inversa): tabella + sintesi."""
    if not rc:
        return "<p style='color:#888;'>Correlazione oro/dollaro non disponibile.</p>"
    head = (
        "<tr style='background:#f3f4f6;text-align:left;'>"
        "<th style='padding:6px 10px;'>TF</th>"
        "<th style='padding:6px 10px;'>Correlazione</th>"
        "<th style='padding:6px 10px;'>Direzioni (Oro / Dollaro)</th>"
        "<th style='padding:6px 10px;'>Esito (relazione inversa)</th></tr>"
    )
    rows = ""
    for tf in rc.per_tf:
        if tf.note:
            corr_s, dirs, esito, color = "n/d", "—", tf.note, "#8a8a8a"
        else:
            corr_s = f"{tf.corr:.2f}" if tf.corr is not None else "n/d"
            dirs = f"{tf.dax_dir or '—'} / {tf.ref_dir or '—'}"
            esito = "✓ inversa sana" if tf.aligned else "⚠ non inversa"
            color = "#0a7d32" if tf.aligned else "#b3261e"
        rows += (
            "<tr style='border-top:1px solid #eee;'>"
            f"<td style='padding:6px 10px;'>{tf.timeframe}</td>"
            f"<td style='padding:6px 10px;'>{corr_s}</td>"
            f"<td style='padding:6px 10px;'>{dirs}</td>"
            f"<td style='padding:6px 10px;color:{color};font-weight:600;'>{esito}</td></tr>"
        )
    v = gold_dxy_verdict(rc)
    return (
        f"<table style='border-collapse:collapse;width:100%;font-size:13px;'>{head}{rows}</table>"
        f"<div style='margin-top:8px;padding:8px 12px;background:#fffbe6;border-radius:6px;"
        f"font-size:13px;'><strong>Sintesi bias oro:</strong> {v}</div>"
        "<p style='font-size:11px;color:#aaa;margin-top:6px;'>"
        "Oro e dollaro si muovono di norma in <strong>direzione opposta</strong>: dollaro debole "
        "→ oro sostenuto. Correlazione negativa = relazione inversa in atto.</p>"
    )


def build_html(
    date_str: str,
    commentary_html: str,
    groups: dict[str, list[Instrument]],
    events: list[MacroEvent],
    correlation: list[RefCorr] | None = None,
    gold_dxy: RefCorr | None = None,
) -> str:
    """Assembla il corpo HTML completo dell'email."""
    return f"""\
<div style="font-family:-apple-system,Segoe UI,Roboto,Helvetica,Arial,sans-serif;
            max-width:780px;margin:0 auto;color:#1a1a1a;line-height:1.5;">
  <div style="background:#0f1b2d;color:#fff;padding:20px 24px;border-radius:8px 8px 0 0;">
    <h1 style="margin:0;font-size:20px;">📊 Report di Mercato</h1>
    <div style="opacity:.8;font-size:14px;margin-top:4px;">{date_str}</div>
  </div>
  <div style="border:1px solid #e5e5e5;border-top:none;border-radius:0 0 8px 8px;padding:20px 24px;">

    <div style="background:#fff8e1;border:1px solid #ffe082;border-radius:6px;
                padding:10px 14px;font-size:12px;color:#7a5b00;margin-bottom:16px;">
      ⚠️ <strong>Avviso:</strong> questo report ha finalità informative ed educative.
      <strong>Non è consulenza finanziaria</strong> né un invito a operare. Le direzioni
      di trend sono indicazioni algoritmiche/probabilistiche, non previsioni certe. Opera
      sempre in autonomia e con la tua gestione del rischio.
    </div>

    {commentary_html}

    <h2 style="margin-top:26px;">Correlazione DAX ↔ S&amp;P / Nikkei (multi-timeframe)</h2>
    {_correlation_table(correlation)}

    <h2 style="margin-top:26px;">Oro ↔ Dollaro (DXY) — relazione inversa</h2>
    {_gold_dxy_table(gold_dxy)}

    <h2 style="margin-top:26px;">Dati tecnici di riferimento</h2>
    {_data_table("Indici", groups["Indici"])}
    {_data_table("Materie prime", groups["Materie prime"])}
    {_data_table("Forex", groups["Forex"])}

    <h2 style="margin-top:26px;">Livelli chiave del giorno &amp; ordini pendenti</h2>
    {_keylevels_table(groups)}

    <h2 style="margin-top:26px;">Supporti e resistenze</h2>
    {_levels_table(groups)}

    <h2 style="margin-top:26px;">Fibonacci &amp; golden zone</h2>
    {_fib_table(groups)}

    <h2 style="margin-top:26px;">Calendario macro di oggi</h2>
    {_calendar_table(events)}

    <p style="margin-top:24px;font-size:11px;color:#aaa;">
      Fonti dati: Yahoo Finance (prezzi/indicatori), Forex Factory (calendario macro).
      Sintesi generata con Claude. Generato automaticamente dall'agente di analisi.
    </p>
  </div>
</div>"""
