"""Genera il PDF del report settimanale (allegato all'email del sabato).

Usa fpdf2 (puro Python, nessuna dipendenza di sistema). Il PDF e' costruito
dai DATI (Stats + verifica bias), non convertito dall'HTML: risultato pulito e
robusto. Se fpdf2 non e' installato, build_weekly_pdf ritorna None e il report
viene inviato lo stesso senza allegato.
"""

from __future__ import annotations

from datetime import datetime


def _eur(x: float) -> str:
    return f"{x:+,.2f}".replace(",", "§").replace(".", ",").replace("§", ".")


# I font base di fpdf2 (Helvetica) sono latin-1: convertiamo i caratteri
# non supportati (trattini lunghi, frecce, emoji) in equivalenti ASCII.
_MAP = {"–": "-", "—": "-", "→": "->", "←": "<-", "·": "-", "•": "-",
        "’": "'", "‘": "'", "“": '"', "”": '"', "…": "...", "€": "EUR",
        "⚠️": "[!]", "⚠": "[!]", "📊": "", "🏆": "", "🩸": ""}


def _s(t) -> str:
    t = str(t)
    for k, v in _MAP.items():
        t = t.replace(k, v)
    return t.encode("latin-1", "replace").decode("latin-1")


def build_weekly_pdf(path: str, *, period: str, st, bias: dict | None,
                     generated: datetime, stale_warning: str = "") -> str | None:
    """Scrive il PDF in `path`. Ritorna il path, o None se fpdf2 manca.
    `st` = Stats dei trade (puo' essere None). `bias` = risultato verify.verify."""
    try:
        from fpdf import FPDF
    except Exception:
        return None

    NAVY = (31, 78, 121)
    GREEN = (31, 122, 61)
    RED = (176, 36, 24)
    GREY = (110, 110, 110)

    pdf = FPDF(orientation="P", unit="mm", format="A4")
    pdf.set_auto_page_break(auto=True, margin=15)
    pdf.add_page()
    epw = pdf.w - pdf.l_margin - pdf.r_margin

    def H1(txt):
        pdf.set_font("Helvetica", "B", 16); pdf.set_text_color(*NAVY)
        pdf.cell(0, 9, _s(txt), new_x="LMARGIN", new_y="NEXT")

    def H2(txt):
        pdf.ln(2); pdf.set_font("Helvetica", "B", 12); pdf.set_text_color(*NAVY)
        pdf.cell(0, 7, _s(txt), new_x="LMARGIN", new_y="NEXT")
        pdf.set_draw_color(220, 220, 220); pdf.line(pdf.l_margin, pdf.get_y(), pdf.w - pdf.r_margin, pdf.get_y())
        pdf.ln(1)

    def P(txt, color=(26, 26, 26), size=10, style=""):
        pdf.set_font("Helvetica", style, size); pdf.set_text_color(*color)
        pdf.multi_cell(0, 5, _s(txt), new_x="LMARGIN", new_y="NEXT")

    def table(headers, rows, widths, aligns):
        pdf.set_font("Helvetica", "B", 9); pdf.set_fill_color(*NAVY); pdf.set_text_color(255, 255, 255)
        for h, w, a in zip(headers, widths, aligns):
            pdf.cell(w, 6, _s(h), border=0, align=a, fill=True)
        pdf.ln()
        pdf.set_font("Helvetica", "", 9)
        for row in rows:
            pdf.set_text_color(26, 26, 26)
            for (val, col), w, a in zip(row, widths, aligns):
                if col: pdf.set_text_color(*col)
                pdf.cell(w, 5.5, _s(val), border="B", align=a)
                pdf.set_text_color(26, 26, 26)
            pdf.ln()

    H1("Report Settimanale di Trading")
    P(f"Periodo: {period}", GREY, 10)
    P(f"Generato: {generated:%d/%m/%Y %H:%M}", GREY, 9)
    pdf.ln(1)

    if stale_warning:
        pdf.set_fill_color(255, 240, 200); pdf.set_draw_color(200, 150, 0)
        pdf.set_font("Helvetica", "B", 9); pdf.set_text_color(150, 90, 0)
        pdf.multi_cell(0, 5, _s(stale_warning), border=1, fill=True, new_x="LMARGIN", new_y="NEXT")
        pdf.ln(1)

    # ---- 1. Trade ----
    H2("1. Andamento dei trade")
    if st and st.trades:
        col = GREEN if st.net_total >= 0 else RED
        P(f"Netto settimana: {_eur(st.net_total)} EUR   -   {len(st.trades)} trade   -   "
          f"win rate {st.win_rate*100:.0f}%   -   profit factor {st.profit_factor:.2f}   -   "
          f"aspettativa {_eur(st.expectancy)}/trade", col, 10, "B")
        P(f"(statement: {st.total_in_file} trade nel file, copertura {st.first_open} -> {st.last_close})", GREY, 8)
        pdf.ln(1)

        def block(title, d):
            P(title, NAVY, 10, "B")
            rows = []
            for k, b in sorted(d.items(), key=lambda x: -x[1]["net"]):
                c = GREEN if b["net"] >= 0 else RED
                rows.append([(k, None), (f"{b['wins']}/{b['n']}", None), (_eur(b["net"]), c)])
            table(["Voce", "Win", "Netto EUR"], rows, [epw*0.55, epw*0.20, epw*0.25], ["L", "C", "R"])
            pdf.ln(1)

        block("Per categoria", st.by_class)
        block("Per simbolo", st.by_symbol)
        block("Per strategia / EA", st.by_strategy)
    else:
        P("Nessuno statement con trade nel periodo.", GREY, 10)

    # ---- 2. Bias ----
    H2("2. Il bias era corretto?")
    if bias and bias.get("total_checked", 0) > 0:
        pct = 100 * bias["total_coherent"] / bias["total_checked"]
        P(f"Affidabilita del bias: {bias['total_coherent']}/{bias['total_checked']} coerenti ({pct:.0f}%)", size=10, style="B")
        rows = []
        for name, b in sorted(bias["by_instrument"].items(), key=lambda x: -x[1]["coherent"]):
            p = 100 * b["coherent"] / b["checked"] if b["checked"] else 0
            rows.append([(name, None), (f"{b['coherent']}/{b['checked']}", None), (f"{p:.0f}%", None)])
        table(["Strumento", "Coerenti", "%"], rows, [epw*0.55, epw*0.25, epw*0.20], ["L", "C", "R"])
    else:
        P("Non ancora abbastanza dati per verificare il bias.", GREY, 10)

    pdf.output(path)
    return path
