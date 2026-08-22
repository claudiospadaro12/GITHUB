#!/usr/bin/env python3
"""Report SETTIMANALE (sabato): analisi trade + verifica del bias.

Flusso:
  1. carica gli snapshot della settimana (bias/livelli salvati ogni giorno)
  2. verifica il bias contro il movimento reale del mercato
  3. se disponibile, analizza lo statement dei trade (STATEMENT_FILE)
  4. compone il report HTML e lo invia via email (o lo salva in DRY_RUN)

Variabili d'ambiente:
  STATEMENT_FILE=/percorso/report_storico.xlsx   (opzionale, forza UN file)
  DRY_RUN=1   -> non invia, salva weekly_output.html
  DAYS=7      -> ampiezza della finestra (default 7 giorni)

22/08/2026 -- PIU' CONTI, non solo il "vincitore". La selezione vecchia
prendeva UN file da data/statements/, quello con la chiusura piu' recente:
bene finche' c'era un conto solo, ma con due conti (piccolo 50503392 e
100k 50504263) i loro export si aggiornano nella STESSA finestra e la
scelta finiva per essere un'arbitrarieta' di pochi secondi -- il 21/08 i due
file erano stati committati allo STESSO minuto e l'ultima chiusura del
conto piccolo (14:55:02) ha battuto quella del 100k (14:54:24) per 38
secondi: il report e' uscito SOLO col conto piccolo, il 100k e' sparito
senza nessun avviso. Ora si raggruppa per CONTO (_account_label) e dentro
ogni gruppo si tiene lo stesso criterio di prima (il file piu' aggiornato
vince): niente si perde, e un file piu' vecchio dello stesso conto non
sovrascrive quello buono.
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


def _account_label(path: str) -> str:
    """Un file -> un conto. Euristica sul NOME FILE (non c'e' altro modo:
    i CSV/xlsx non portano il numero di conto in un campo). Se domani entra
    un TERZO conto, questa funzione va estesa esplicitamente: di default
    tutto cio' che non riconosce finisce nel conto piccolo, per compatibilita'
    con l'unico conto che c'era prima del 22/08."""
    name = os.path.basename(path).lower()
    if "100k" in name or "50504263" in name:
        return "100k (dry-run 50504263)"
    return "piccolo (50503392)"


def _trade_section(stats_by_account: dict) -> str:
    if not stats_by_account:
        return ("<p style='color:#666'>Nessuno statement fornito questa settimana "
                "(imposta <code>STATEMENT_FILE</code> o carica l'export dello storico). "
                "L'analisi dei trade comparirà qui.</p>")

    def rows(d):
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

    out = ""
    if len(stats_by_account) > 1:
        tot = sum(st.net_total for st in stats_by_account.values() if st.trades)
        col = "#1f7a3d" if tot >= 0 else "#b02418"
        out += (f"<p><b>Netto totale, tutti i conti:</b> "
                f"<span style='color:{col};font-size:18px'>{_eur(tot)} EUR</span></p>")

    for label, st in stats_by_account.items():
        out += f"<h3 style='margin-top:22px'>Conto: {label}</h3>"
        if not st.trades:
            out += "<p style='color:#666'>Statement senza trade nel periodo.</p>"
            continue

        tc, tcv = top(st.by_class)
        ts, tsv = top(st.by_symbol)
        te, tev = top(st.by_strategy)

        col = "#1f7a3d" if st.net_total >= 0 else "#b02418"
        out += f"""
        <p><b>Netto settimana:</b> <span style='color:{col};font-size:18px'>{_eur(st.net_total)} EUR</span>
           &nbsp;·&nbsp; {len(st.trades)} trade &nbsp;·&nbsp; win rate {st.win_rate*100:.0f}%
           &nbsp;·&nbsp; profit factor {st.profit_factor:.2f}
           &nbsp;·&nbsp; aspettativa {_eur(st.expectancy)}/trade</p>
        <p style='color:#999;font-size:12px'>Statement: {st.total_in_file} trade nel file · copertura {st.first_open} → {st.last_close}</p>
        <div style='background:#eef6ee;border-left:4px solid #1f7a3d;padding:8px 12px;margin:10px 0'>
          <b>🏆 Più profittevoli:</b> &nbsp; categoria <b>{tc}</b> ({_eur(tcv)}) &nbsp;·&nbsp;
          simbolo <b>{ts}</b> ({_eur(tsv)}) &nbsp;·&nbsp; EA <b>{te}</b> ({_eur(tev)})
        </div>
        <h4>Per categoria (Indici / Valute / Cross / Metalli)</h4>
        <table>{rows(st.by_class)}</table>
        <h4>Per simbolo</h4>
        <table>{rows(st.by_symbol)}</table>
        <h4>Per strategia / EA (i tuoi EA)</h4>
        <table>{rows(st.by_strategy)}</table>
        """
    return out


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


def build_html(now: datetime, snaps: list[dict], stats_by_account: dict, res: dict | None,
               week_start: datetime, stale_warning: str = "") -> str:
    period = f"{week_start.strftime('%d/%m')} (lun) – {now.strftime('%d/%m/%Y')}"
    return f"""<!doctype html><html><head><meta charset='utf-8'>
<style>
 body{{font-family:Arial,Helvetica,sans-serif;color:#1a1a1a;max-width:720px;margin:auto;padding:12px}}
 h1{{color:#1f4e79}} h2{{color:#1f4e79;border-bottom:2px solid #eee;padding-bottom:4px;margin-top:26px}}
 h3{{color:#183a5c;margin:14px 0 6px}} h4{{color:#444;margin:12px 0 4px}}
 table{{width:100%;border-collapse:collapse;font-size:14px;margin:6px 0}}
 td,th{{border-bottom:1px solid #eee;padding:6px 8px;text-align:left}}
 th{{background:#1f4e79;color:#fff}}
</style></head><body>
 <h1>📊 Report Settimanale — {period}</h1>
 <p style='color:#666'>Analisi dei trade e verifica del bias di mercato.</p>
 {_stale_banner(stale_warning)}
 <h2>1. Andamento dei trade</h2>
 {_trade_section(stats_by_account)}
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
    # Selezione DETERMINISTICA per CONTO: fra i file dello stesso conto vince
    # quello che copre piu' avanti nel tempo (ultimo trade piu' recente). Su
    # GitHub Actions le date-file dopo il checkout sono tutte uguali, quindi
    # NON si puo' usare l'mtime: cosi' puoi caricare un export nuovo senza
    # cancellare il vecchio e vince il completo -- MA per conto, non in
    # assoluto (22/08/2026: prima vinceva UN file su tutti i conti insieme,
    # e il 100k spariva ogni volta che il conto piccolo chiudeva un trade
    # anche solo qualche secondo dopo di lui).
    since = week_start.strftime("%Y.%m.%d")
    env_file = os.getenv("STATEMENT_FILE", "")
    candidates = []
    if env_file:
        candidates = [env_file]
    else:
        from pathlib import Path
        sdir = Path("data/statements")
        candidates = ([str(p) for p in sdir.glob("*.xlsx")]
                      + [str(p) for p in sdir.glob("*.csv")]) if sdir.exists() else []

    stats_by_account: dict = {}
    paths_by_account: dict = {}
    if statement:
        best_key_by_account: dict = {}
        for path in candidates:
            if not os.path.exists(path):
                continue
            try:
                cand = statement.parse(path, since=since)
            except Exception as exc:
                print(f"[warn] statement '{os.path.basename(path)}' non leggibile: {exc}")
                continue
            label = "manuale (STATEMENT_FILE)" if env_file else _account_label(path)
            # chiave = ultima chiusura (copertura); a parita', piu' trade nel file
            key = (cand.last_close, cand.total_in_file)
            if label not in best_key_by_account or key > best_key_by_account[label]:
                stats_by_account[label] = cand
                paths_by_account[label] = path
                best_key_by_account[label] = key
        for label, path in paths_by_account.items():
            print(f"[info] conto '{label}': scelto {os.path.basename(path)} "
                  f"(copre fino a {stats_by_account[label].last_close})")

    # --- guardia anti-statement-vecchio: copre fino a venerdi'? ---
    # 15/08/2026: da dove sta girando questo report. La pagella del 15/08 e'
    # uscita vuota perche' il VPS lanciava il workflow sul branch VECCHIO
    # (claude/creating-agents-SgGpD, fermo al 31/07): lo statement li' dentro
    # si ferma al 24/07. Il messaggio diceva "esporta un nuovo storico da MT5",
    # cioe' mandava a cercare nel posto sbagliato. Adesso la provenienza e'
    # scritta nell'avviso: se ricapita, la causa si legge subito.
    _branch = os.getenv("GITHUB_REF_NAME", "") or os.getenv("GITHUB_REF", "")
    _sha    = (os.getenv("GITHUB_SHA", "") or "")[:7]
    _prov   = f" [report generato dal branch '{_branch}'" + (f", commit {_sha}" if _sha else "") + "]" if _branch else ""

    friday = week_start + timedelta(days=4)
    expected = min(now, friday)
    stale_msgs = []
    for label, cst in stats_by_account.items():
        if cst.last_close and cst.last_close < expected.strftime("%Y.%m.%d"):
            lc = cst.last_close.replace(".", "/")
            stale_msgs.append(f"⚠️ Conto {label}: lo statement arriva solo al {lc}, ma la "
                              f"settimana va fino al {expected:%d/%m}. Mancano dei trade: esporta "
                              f"da MT5 un nuovo storico COMPLETO per QUESTO conto e ripubblicalo.")
            print(f"[warn] statement STALE per '{label}': ultimo trade {cst.last_close}, "
                  f"atteso >= {expected:%Y.%m.%d}")
    if not stats_by_account:
        stale_msgs.append("⚠️ Nessuno statement disponibile: l'analisi dei trade è vuota. "
                          "Pubblica l'export dello storico MT5 in data/statements/.")
    stale_warning = " ".join(stale_msgs)
    if stale_warning:
        stale_warning += _prov
        if len(stats_by_account) and any(
                cst.last_close and cst.last_close < expected.strftime("%Y.%m.%d")
                for cst in stats_by_account.values()):
            stale_warning += (" Se il branch qui sopra non e' 'lavoro', il problema NON e' lo "
                              "statement: il report sta leggendo un repo vecchio.")

    res = verify.verify(snaps) if snaps else None

    print(f"[info] Report settimanale (da lun {week_start:%d/%m}): {len(snaps)} snapshot, "
          f"conti={len(stats_by_account)} "
          + ", ".join(f"{label}: {len(cst.trades)} trade->{cst.last_close}"
                       for label, cst in stats_by_account.items()))
    html = build_html(now, snaps, stats_by_account, res, week_start, stale_warning)
    subject = f"📊 Report Settimanale — settimana del {now.day} {_MESI[now.month-1]}"

    # --- PDF allegato ---
    pdf_path = None
    try:
        from agent import pdf as pdfgen
        period = f"{week_start.strftime('%d/%m')} (lun) – {now.strftime('%d/%m/%Y')}"
        out = pdfgen.build_weekly_pdf("weekly_report.pdf", period=period,
                                      stats_by_account=stats_by_account, bias=res,
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
