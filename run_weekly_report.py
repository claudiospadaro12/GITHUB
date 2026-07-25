#!/usr/bin/env python3
"""Report SETTIMANALE (sabato): analisi trade + verifica del bias.

Flusso:
  1. carica gli snapshot della settimana (bias/livelli salvati ogni giorno)
  2. verifica il bias contro il movimento reale del mercato
  3. se disponibile, analizza lo statement dei trade (STATEMENT_FILE)
  4. compone il report HTML e lo invia via email (o lo salva in DRY_RUN)

Variabili d'ambiente:
  STATEMENT_FILE=/percorso/report_storico.xlsx   (opzionale)
  DRY_RUN=1   -> non invia, salva weekly_output.html
  DAYS=7      -> ampiezza della finestra (default 7 giorni)
"""

from __future__ import annotations

import os
import sys
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo

from agent import config, notify, snapshot, verify

try:
    from agent import statement
except Exception:
    statement = None

_MESI = ["gennaio", "febbraio", "marzo", "aprile", "maggio", "giugno", "luglio",
         "agosto", "settembre", "ottobre", "novembre", "dicembre"]


def _eur(x: float) -> str:
    return f"{x:+,.2f}".replace(",", "§").replace(".", ",").replace("§", ".")


def _trade_section(st) -> str:
    if st is None:
        return ("<p style='color:#666'>Nessuno statement fornito questa settimana "
                "(imposta <code>STATEMENT_FILE</code> o carica l'export dello storico). "
                "L'analisi dei trade comparirà qui.</p>")
    if not st.trades:
        return "<p style='color:#666'>Statement senza trade nel periodo.</p>"

    def rows(d, label):
        out = ""
        for k, b in sorted(d.items(), key=lambda x: -x[1]["net"]):
            col = "#1f7a3d" if b["net"] >= 0 else "#b02418"
            out += (f"<tr><td>{k}</td><td style='text-align:center'>{b['wins']}/{b['n']}</td>"
                    f"<td style='text-align:right;color:{col}'>{_eur(b['net'])}</td></tr>")
        return out

    def top(d):
        if not d:
            return ("—", 0.0)
        k = max(d, key=lambda x: d[x]["net"])
        return (k, d[k]["net"])

    tc, tcv = top(st.by_class)
    ts, tsv = top(st.by_symbol)
    te, tev = top(st.by_strategy)

    col = "#1f7a3d" if st.net_total >= 0 else "#b02418"
    return f"""
    <p><b>Netto settimana:</b> <span style='color:{col};font-size:18px'>{_eur(st.net_total)} EUR</span>
       &nbsp;·&nbsp; {len(st.trades)} trade &nbsp;·&nbsp; win rate {st.win_rate*100:.0f}%
       &nbsp;·&nbsp; profit factor {st.profit_factor:.2f}
       &nbsp;·&nbsp; aspettativa {_eur(st.expectancy)}/trade</p>
    <p style='color:#999;font-size:12px'>Statement: {st.total_in_file} trade nel file · copertura {st.first_open} → {st.last_close}</p>
    <div style='background:#eef6ee;border-left:4px solid #1f7a3d;padding:8px 12px;margin:10px 0'>
      <b>🏆 Più profittevoli:</b> &nbsp; categoria <b>{tc}</b> ({_eur(tcv)}) &nbsp;·&nbsp;
      simbolo <b>{ts}</b> ({_eur(tsv)}) &nbsp;·&nbsp; EA <b>{te}</b> ({_eur(tev)})
    </div>
    <h3>Per categoria (Indici / Valute / Cross / Metalli)</h3>
    <table>{rows(st.by_class,'')}</table>
    <h3>Per simbolo</h3>
    <table>{rows(st.by_symbol,'')}</table>
    <h3>Per strategia / EA (i tuoi EA)</h3>
    <table>{rows(st.by_strategy,'')}</table>
    """


def _bias_section(snaps: list[dict], res: dict | None) -> str:
    if not snaps:
        return ("<p style='color:#666'>Nessuno snapshot in questa settimana. "
                "La raccolta è appena iniziata: la verifica del bias avrà dati "
                "dopo qualche giorno di report.</p>")
    if res is None:
        res = verify.verify(snaps)
    if res["total_checked"] == 0:
        return (f"<p style='color:#666'>{len(snaps)} snapshot raccolti, ma non ancora "
                "abbastanza dati reali per verificare il bias (servono giornate chiuse).</p>")

    pct = 100 * res["total_coherent"] / res["total_checked"]
    inst_rows = ""
    for name, b in sorted(res["by_instrument"].items(), key=lambda x: -x[1]["coherent"]):
        p = 100 * b["coherent"] / b["checked"] if b["checked"] else 0
        inst_rows += (f"<tr><td>{name}</td><td style='text-align:center'>{b['coherent']}/{b['checked']}</td>"
                      f"<td style='text-align:right'>{p:.0f}%</td></tr>")

    day_rows = ""
    for r in res["rows"]:
        mark = "✅" if r["coherent"] else "❌"
        col = "#1f7a3d" if r["coherent"] else "#b02418"
        day_rows += (f"<tr><td>{r['date']}</td><td>{r['name']}</td><td>{r['bias']}</td>"
                     f"<td style='text-align:right'>{r['actual_pct']:+.2f}%</td>"
                     f"<td style='text-align:center;color:{col}'>{mark}</td></tr>")

    return f"""
    <p><b>Affidabilità del bias:</b> <span style='font-size:18px'>{res['total_coherent']}/{res['total_checked']}
       coerenti ({pct:.0f}%)</span></p>
    <h3>Per strumento</h3>
    <table>{inst_rows}</table>
    <h3>Giorno per giorno</h3>
    <table><tr><th>Data</th><th>Strumento</th><th>Bias previsto</th><th>Reale</th><th>Esito</th></tr>{day_rows}</table>
    """


def _stale_banner(msg: str) -> str:
    if not msg:
        return ""
    return (f"<div style='background:#fff4c8;border:1px solid #c89600;color:#7a5a00;"
            f"padding:10px 12px;margin:10px 0;border-radius:4px;font-weight:bold'>{msg}</div>")


def build_html(now: datetime, snaps: list[dict], st, res: dict | None,
               week_start: datetime, stale_warning: str = "") -> str:
    period = f"{week_start.strftime('%d/%m')} (lun) – {now.strftime('%d/%m/%Y')}"
    return f"""<!doctype html><html><head><meta charset='utf-8'>
<style>
 body{{font-family:Arial,Helvetica,sans-serif;color:#1a1a1a;max-width:720px;margin:auto;padding:12px}}
 h1{{color:#1f4e79}} h2{{color:#1f4e79;border-bottom:2px solid #eee;padding-bottom:4px;margin-top:26px}}
 h3{{color:#444;margin:14px 0 6px}}
 table{{width:100%;border-collapse:collapse;font-size:14px;margin:6px 0}}
 td,th{{border-bottom:1px solid #eee;padding:6px 8px;text-align:left}}
 th{{background:#1f4e79;color:#fff}}
</style></head><body>
 <h1>📊 Report Settimanale — {period}</h1>
 <p style='color:#666'>Analisi dei trade e verifica del bias di mercato.</p>
 {_stale_banner(stale_warning)}
 <h2>1. Andamento dei trade</h2>
 {_trade_section(st)}
 <h2>2. Il bias era corretto?</h2>
 {_bias_section(snaps, res)}
 <hr style='margin-top:28px'>
 <p style='color:#999;font-size:12px'>Report automatico. La verifica del bias parte dalla data di
 inizio raccolta snapshot. Livelli e correlazioni in arrivo nella prossima versione.</p>
</body></html>"""


def main() -> int:
    settings = config.Settings()
    now = datetime.now(ZoneInfo(config.TIMEZONE))
    # Inizio settimana = LUNEDI' della settimana in corso (00:00).
    week_start = (now - timedelta(days=now.weekday())).replace(hour=0, minute=0, second=0, microsecond=0)
    snaps = snapshot.load_range(week_start, now)

    # --- statement + parse UNA volta (per HTML, PDF e controllo freschezza) ---
    # Selezione DETERMINISTICA: fra tutti gli .xlsx vince quello che copre piu'
    # avanti nel tempo (ultimo trade piu' recente). Su GitHub Actions le date-file
    # dopo il checkout sono tutte uguali, quindi NON si puo' usare l'mtime: cosi'
    # puoi caricare un export nuovo senza cancellare il vecchio e vince il completo.
    since = week_start.strftime("%Y.%m.%d")
    st = None
    statement_path = ""
    env_file = os.getenv("STATEMENT_FILE", "")
    candidates = []
    if env_file:
        candidates = [env_file]
    else:
        from pathlib import Path
        sdir = Path("data/statements")
        candidates = ([str(p) for p in sdir.glob("*.xlsx")]
                      + [str(p) for p in sdir.glob("*.csv")]) if sdir.exists() else []
    if statement:
        best_key = None
        for path in candidates:
            if not os.path.exists(path):
                continue
            try:
                cand = statement.parse(path, since=since)
            except Exception as exc:
                print(f"[warn] statement '{os.path.basename(path)}' non leggibile: {exc}")
                continue
            # chiave = ultima chiusura (copertura); a parita', piu' trade nel file
            key = (cand.last_close, cand.total_in_file)
            if best_key is None or key > best_key:
                st, statement_path, best_key = cand, path, key
        if len(candidates) > 1 and statement_path:
            print(f"[info] scelto lo statement piu' aggiornato: {os.path.basename(statement_path)} "
                  f"(copre fino a {st.last_close})")

    # --- guardia anti-statement-vecchio: copre fino a venerdi'? ---
    stale_warning = ""
    friday = week_start + timedelta(days=4)
    expected = min(now, friday)
    if st is not None and st.last_close and st.last_close < expected.strftime("%Y.%m.%d"):
        lc = st.last_close.replace(".", "/")
        stale_warning = (f"⚠️ Lo statement arriva solo al {lc}, ma la settimana va fino al "
                         f"{expected:%d/%m}. Mancano dei trade: esporta da MT5 un nuovo storico "
                         f"COMPLETO e ripubblicalo, poi rilancia il report.")
        print(f"[warn] statement STALE: ultimo trade {st.last_close}, atteso >= {expected:%Y.%m.%d}")
    elif st is None:
        stale_warning = ("⚠️ Nessuno statement disponibile: l'analisi dei trade è vuota. "
                         "Pubblica l'export dello storico MT5 in data/statements/.")

    res = verify.verify(snaps) if snaps else None

    print(f"[info] Report settimanale (da lun {week_start:%d/%m}): {len(snaps)} snapshot, "
          f"statement={'sì' if st else 'no'}"
          + (f", {len(st.trades)} trade, copertura->{st.last_close}" if st else ""))
    html = build_html(now, snaps, st, res, week_start, stale_warning)
    subject = f"📊 Report Settimanale — settimana del {now.day} {_MESI[now.month-1]}"

    # --- PDF allegato ---
    pdf_path = None
    try:
        from agent import pdf as pdfgen
        period = f"{week_start.strftime('%d/%m')} (lun) – {now.strftime('%d/%m/%Y')}"
        out = pdfgen.build_weekly_pdf("weekly_report.pdf", period=period, st=st, bias=res,
                                      generated=now, stale_warning=stale_warning)
        if out:
            pdf_path = out
            print(f"[ok] PDF generato: {pdf_path}")
        else:
            print("[warn] fpdf2 non disponibile: invio senza PDF.")
    except Exception as exc:
        print(f"[warn] PDF non generato: {exc}")

    if settings.dry_run:
        with open("weekly_output.html", "w", encoding="utf-8") as f:
            f.write(html)
        print("[dry-run] Report salvato in weekly_output.html"
              + (f" + {pdf_path}" if pdf_path else "") + " (nessuna email).")
        return 0

    settings.require_email()
    print(f"[info] Invio a {settings.email_to}...")
    notify.send_email(settings, subject, html, attachments=[pdf_path] if pdf_path else None)
    print("[ok] Report settimanale inviato" + (" con PDF." if pdf_path else "."))
    return 0


if __name__ == "__main__":
    sys.exit(main())
