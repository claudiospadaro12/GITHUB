#!/usr/bin/env python3
"""Entry point dell'agente di analisi di mercato.

Flusso:
  1. (gate orario) esegue solo alle 07:00 Europa/Roma, salvo FORCE_RUN=1
  2. raccoglie dati di mercato + indicatori tecnici
  3. raccoglie il calendario macro del giorno
  4. Claude sintetizza il commento analitico
  5. compone il report HTML e lo invia via email (o lo salva in DRY_RUN)

Variabili d'ambiente principali (vedi README):
  ANTHROPIC_API_KEY, SMTP_USER, SMTP_PASSWORD, EMAIL_TO
  FORCE_RUN=1  → ignora il gate orario (utile per test/esecuzione manuale)
  DRY_RUN=1    → non invia email; salva il report in report_output.html
"""

from __future__ import annotations

import sys
from datetime import datetime
from zoneinfo import ZoneInfo

from agent import analysis, config, correlation, market_data, notify, report, snapshot
from agent.macro_calendar import fetch_today_events

# Mesi in italiano per l'intestazione.
_MESI = [
    "gennaio", "febbraio", "marzo", "aprile", "maggio", "giugno",
    "luglio", "agosto", "settembre", "ottobre", "novembre", "dicembre",
]


def _italian_date(dt: datetime) -> str:
    return f"{dt.day} {_MESI[dt.month - 1]} {dt.year} — {dt.strftime('%H:%M')} ({config.TIMEZONE})"


def main() -> int:
    settings = config.Settings()
    now = datetime.now(ZoneInfo(config.TIMEZONE))

    # 1. Gate orario TOLLERANTE: c'è un solo cron (05:00 UTC = 06:00/07:00 Roma),
    #    ma GitHub Actions spesso ritarda i cron di 30-90 min. Quindi invece di
    #    pretendere l'ora esatta, accettiamo qualsiasi firing nella FINESTRA del
    #    mattino: così il report parte comunque, anche se GitHub lo esegue tardi.
    #    (Un solo cron feriale => una sola esecuzione al giorno => un solo invio.)
    morning_lo, morning_hi = config.SEND_HOUR - 1, config.SEND_HOUR + 5  # es. 06:00–12:00
    if not settings.force_run and not (morning_lo <= now.hour < morning_hi):
        print(f"[skip] Ora locale {now:%H:%M} fuori dalla finestra mattutina "
              f"{morning_lo:02d}:00–{morning_hi:02d}:00 {config.TIMEZONE}. FORCE_RUN=1 per forzare.")
        return 0

    # La chiave Claude è OPZIONALE: se manca o è invalida usiamo l'analisi
    # deterministica (fallback), così il report parte sempre. L'email invece
    # serve davvero per recapitarlo.
    if not settings.dry_run:
        settings.require_email()

    date_str = _italian_date(now)
    print(f"[info] Generazione report per {date_str}")

    # 2. Dati di mercato
    print("[info] Raccolta dati di mercato...")
    groups = market_data.collect_all(config.INDICES, config.COMMODITIES, config.FOREX)

    # 3. Calendario macro
    print("[info] Raccolta calendario macro...")
    events = fetch_today_events(tz=config.TIMEZONE)
    print(f"[info] {len(events)} eventi macro oggi.")

    # 3-bis. Correlazione DAX vs S&P/Nikkei (regola ABTG), multi-timeframe
    print("[info] Calcolo correlazione DAX vs S&P/Nikkei...")
    try:
        corr = correlation.compute()
        corr_text = correlation.format_for_prompt(corr)
    except Exception as exc:  # non bloccare il report se la correlazione fallisce
        print(f"[warn] Correlazione non calcolata: {exc}")
        corr, corr_text = None, ""

    # 3-ter. Correlazione oro vs dollaro (DXY), relazione inversa
    print("[info] Calcolo correlazione Oro vs Dollaro (DXY)...")
    try:
        gold_dxy = correlation.compute_gold_dxy()
    except Exception as exc:
        print(f"[warn] Correlazione oro/dollaro non calcolata: {exc}")
        gold_dxy = None

    # 3-quater. Salva lo SNAPSHOT del giorno (bias/livelli/correlazioni) per la
    #           verifica nel report settimanale del sabato. Non blocca l'invio.
    try:
        snap_path = snapshot.save_snapshot(groups, corr, gold_dxy, when=now)
        print(f"[info] Snapshot del giorno salvato: {snap_path}")
    except Exception as exc:
        print(f"[warn] Snapshot non salvato: {exc}")

    # 3-quinquies. Genera il file news per gli EA (abtg_news.csv): calendario
    #              Forex Factory con ECB/FOMC riconosciuti. Serve al PostNews
    #              (e ai filtri news degli altri EA). Non blocca l'invio.
    try:
        from agent import news_export
        rows = news_export.collect_news()
        n = news_export.write_abtg_news("data/abtg_news.csv")
        s = news_export.summarize(rows)
        print(f"[info] abtg_news.csv generato: {n} eventi (ECB={s['ECB']}, FOMC={s['FOMC']}).")
    except Exception as exc:
        print(f"[warn] abtg_news.csv non generato: {exc}")

    # 4. Sintesi con Claude (opzionale): se la chiave manca o l'API fallisce,
    #    ripieghiamo sull'analisi deterministica senza bloccare l'invio.
    if settings.anthropic_api_key:
        try:
            print("[info] Sintesi del commento con Claude...")
            commentary = analysis.generate_commentary(settings, groups, events, date_str, corr_text)
        except Exception as exc:
            print(f"[warn] Commento AI non disponibile ({exc}); uso l'analisi automatica.")
            commentary = analysis.build_fallback_commentary(groups, events, corr, gold_dxy)
    else:
        print("[info] Nessuna chiave Claude: uso l'analisi automatica (deterministica).")
        commentary = analysis.build_fallback_commentary(groups, events, corr, gold_dxy)

    # 5. Composizione e invio
    html = report.build_html(date_str, commentary, groups, events, corr, gold_dxy)
    subject = f"📊 Report di Mercato — {now.day} {_MESI[now.month - 1]} {now.year}"

    if settings.dry_run:
        out = "report_output.html"
        with open(out, "w", encoding="utf-8") as f:
            f.write(html)
        print(f"[dry-run] Report salvato in {out} (nessuna email inviata).")
        return 0

    print(f"[info] Invio email a {settings.email_to}...")
    notify.send_email(settings, subject, html)
    print("[ok] Report inviato.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
