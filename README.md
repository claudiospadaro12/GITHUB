# 📊 Agente di Analisi di Mercato Giornaliera

Un agente che ogni mattina alle **07:00 (ora italiana)** ti invia via **email** un
report di mercato:

- **Indici** (DAX, S&P 500, Nasdaq 100, Nikkei 225, FTSE MIB), **oro** e **forex**
  (EUR/USD, GBP/USD, USD/JPY, DXY, …)
- per ogni indice e per l'oro: **direzione attesa del trend** del giorno
- **supporti e resistenze** (pivot point classici + massimi/minimi a 20 sedute)
- **ritracciamenti di Fibonacci** con evidenziata la **golden zone** (50%–61,8%), dove
  un ritracciamento sano tende a fermarsi prima che il trend riprenda
- le **notizie macroeconomiche** più importanti della giornata
- i **cross forex da evitare** (es. quelli esposti a news ad alto impatto)

La parte numerica (prezzi, medie mobili, RSI, *bias* di trend) è calcolata in modo
**deterministico**; **Claude (Opus 4.8)** la trasforma in un commento ragionato in
italiano.

> ⚠️ **Non è consulenza finanziaria.** Le direzioni di trend sono indicazioni
> algoritmiche/probabilistiche, non previsioni certe. Operi sempre in autonomia.

---

## Come funziona

```
GitHub Actions (cron, ogni giorno feriale ~07:00 Italia)
        │
        ▼
   run_report.py
        ├─ market_data.py   → dati + indicatori tecnici (Yahoo Finance)
        ├─ macro_calendar.py→ calendario macro del giorno (Forex Factory)
        ├─ analysis.py      → sintesi con Claude (Opus 4.8)
        ├─ report.py        → composizione HTML
        └─ notify.py        → invio email (SMTP Gmail)
```

L'agente gira su **GitHub Actions**, non su questo ambiente: GitHub esegue il job in
modo affidabile ogni giorno senza tenere acceso nulla. Il workflow parte alle 05:00 e
06:00 UTC; lo script invia solo nell'esecuzione che corrisponde alle 07:00 italiane,
così l'ora legale/solare è gestita in automatico.

---

## Configurazione (una tantum)

### 1. Chiave API Anthropic
Crea una chiave su [console.anthropic.com](https://console.anthropic.com) → **API Keys**.

### 2. App Password di Gmail
La password normale di Gmail non funziona via SMTP. Serve una *App Password*:
1. Attiva la **verifica in due passaggi** sul tuo account Google.
2. Vai su [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords).
3. Crea una password per l'app (16 caratteri) e copiala.

### 3. GitHub Secrets
Nel repository: **Settings → Secrets and variables → Actions → New repository secret**.
Crea questi secret:

| Secret             | Valore                                            |
|--------------------|---------------------------------------------------|
| `ANTHROPIC_API_KEY`| la tua chiave `sk-ant-...`                        |
| `SMTP_HOST`        | `smtp.gmail.com`                                  |
| `SMTP_PORT`        | `465`                                             |
| `SMTP_USER`        | il tuo indirizzo Gmail                            |
| `SMTP_PASSWORD`    | la App Password di 16 caratteri                   |
| `EMAIL_TO`         | `claudiospadaro12@gmail.com`                      |

Fatto questo, l'agente è attivo: riceverai il report ogni mattina.

---

## Test

### Esecuzione manuale su GitHub
Tab **Actions** → *Report di Mercato Giornaliero* → **Run workflow**. Forza l'invio
ignorando il gate orario: utile per verificare che l'email arrivi.

### In locale
```bash
pip install -r requirements.txt
cp .env.example .env        # compila i valori
export $(grep -v '^#' .env | xargs)   # carica le variabili (bash)

# Genera il report SENZA inviare email (lo salva in report_output.html):
FORCE_RUN=1 DRY_RUN=1 python run_report.py

# Genera e invia davvero l'email, ignorando l'orario:
FORCE_RUN=1 python run_report.py
```

---

## Personalizzazione

- **Strumenti monitorati:** modifica `INDICES`, `COMMODITIES`, `FOREX` in
  [`agent/config.py`](agent/config.py) (ticker di Yahoo Finance).
- **Orario:** `SEND_HOUR` / `TIMEZONE` in `agent/config.py` e i `cron` nel workflow.
- **Stile del commento:** il `SYSTEM_PROMPT` in [`agent/analysis.py`](agent/analysis.py).

## Note e limiti

- I dati gratuiti (Yahoo Finance, Forex Factory) possono avere ritardi o buchi; per
  fonti premium si possono integrare provider con chiave API.
- All'orario di invio alcuni mercati potrebbero non aver ancora aperto: l'analisi usa
  l'ultima chiusura disponibile per stimare la direzione attesa della giornata.
