# CLAUDE.md

Guida per Claude (e altri agenti) che lavorano su questo repository.

## Cos'è questo progetto

Due componenti indipendenti:

1. **Agente Python di analisi di mercato** (`agent/`, `run_report.py`) — ogni
   mattina alle 07:00 ora italiana genera un report di mercato (indici, oro,
   forex) e lo invia via email. Gira su **GitHub Actions**
   (`.github/workflows/daily-report.yml`), non in locale.
2. **Expert Advisor MQL5** (`mql5/Experts/`) — EA per MetaTrader 5 su XAUUSD M5.
   - `IchiCross_Gold_722.mq5` — **strategia reale dell'utente**: incrocio
     Ichimoku 7/22/44 + filtro bande Bollinger in espansione, SL/parziale/
     trailing in ATR, uscita su incrocio opposto. Rischio 0,50%.
   - `IchiTrend_Gold_Base.mq5` — scheletro generico preesistente (Ichimoku
     standard + rottura Bollinger). Solo riferimento, non il metodo dell'utente.
   Codice standalone, non collegato all'agente Python. Per svilupparlo/migliorarlo
   c'è il subagent `mql5-ea-developer` (vedi `.claude/agents/`).

### Flusso dell'agente Python

```
run_report.py
  ├─ agent/market_data.py   → dati + indicatori (Yahoo Finance, deterministico)
  ├─ agent/macro_calendar.py→ calendario macro (Forex Factory)
  ├─ agent/analysis.py      → commento sintetico via Claude
  ├─ agent/report.py        → composizione HTML
  └─ agent/notify.py        → invio email (SMTP)
```

I numeri (prezzi, medie, RSI, bias, pivot, Fibonacci) sono calcolati in modo
**deterministico** in `market_data.py`. Claude riceve solo questi numeri già
pronti e produce il commento — **non deve inventare valori**. Questa separazione
è intenzionale: preservarla.

## Comandi

```bash
pip install -r requirements.txt
cp .env.example .env                      # poi compila i valori

# Genera il report SENZA inviare email (salva in report_output.html):
FORCE_RUN=1 DRY_RUN=1 python run_report.py

# Genera e invia davvero, ignorando il gate orario:
FORCE_RUN=1 python run_report.py
```

Non esiste suite di test automatici: la verifica è l'esecuzione `DRY_RUN`.

## Convenzioni dell'API Anthropic (NON regredire)

`agent/analysis.py` usa **Opus 4.8** con parametri verificati corretti. Se
modifichi quella chiamata, mantieni questa forma:

- Modello: `claude-opus-4-8` (in `agent/config.py:MODEL`).
- Thinking: `thinking={"type": "adaptive"}`. **Non** usare
  `{"type": "enabled", "budget_tokens": N}` — su Opus 4.8 restituisce 400.
- Effort: `output_config={"effort": "high"}` (dentro `output_config`, non
  top-level).
- Niente `temperature` / `top_p` / `top_k`: rimossi su Opus 4.8 (400).
- Streaming: `client.messages.stream(...)` + `stream.get_final_message()` per
  evitare timeout su output lunghi.
- Prompt caching: `cache_control: {"type": "ephemeral"}` sul system prompt
  (stabile). Tenere i contenuti volatili (data, numeri) **dopo** il blocco
  cachato — sono già nel messaggio user, lasciarli lì.

Nessun segreto nel codice: chiavi e credenziali si leggono da variabili
d'ambiente (`.env` in locale, GitHub Secrets in CI). Vedi `agent/config.py`.

## Stile di lavoro atteso

- **Accuratezza prima di tutto.** Non affermare come fatto ciò che non puoi
  verificare. Se un dato (numero, versione, comportamento di una libreria) non è
  verificabile dal codice o da fonti, dichiararlo invece di inventarlo.
- **Distingui i livelli.** Separa fatti verificati, inferenze e incertezze;
  non presentare un'inferenza come un fatto.
- **Pensiero critico.** Se la premessa di una richiesta è sbagliata, dirlo prima
  di procedere. Il disaccordo motivato è utile; il silenzio su una premessa
  difettosa no.
- **Densità.** Risposte diritte, senza preamboli né riempitivi. Più corto è
  quasi sempre meglio. Non aggiungere modifiche o testo solo per "sembrare
  approfondito".
- **Non gonfiare il diff.** Cambia solo ciò che serve. Niente astrazioni,
  helper o gestione di errori per casi che non possono accadere, salvo richiesta.

## Convenzioni del codice

- Codice e commenti in **italiano** (coerenza con l'esistente).
- Python: type hints, dataclass, `from __future__ import annotations`.
- Errori di rete/dati non devono bloccare il report: ogni strumento che fallisce
  viene marcato con un campo `error` e il report continua (vedi
  `fetch_instruments`).
