# RIEPILOGO COMPLETO — Progetto EA + Agente Report

> Documento di salvataggio di tutta la chat "creating agent".
> Aggiornato al 26/07/2026. Tutto il codice è su GitHub, branch `claude/ea-market-openings-d79m8l`.
> Profilo: trader retail, broker **BCM Markets** (conto DEMO Hedge), strumento principale **ORO**.
> Nota broker BCM: ora server = ora italiana − 1h; indici/oro digits=2, tick=0.10.

---

## 1) AGENTE REPORT GIORNALIERO

- **Cosa fa**: ogni mattina (giorni feriali) invia via email un report di mercato: bias, direzione, correlazioni (incl. Oro↔Dollaro/DXY), news imminenti.
- **Orario**: `SEND_HOUR = 7` (07:00 ora italiana). GitHub Actions può ritardare il cron di 30–90 min: per questo la "finestra oraria" è tollerante (non salta più se parte in ritardo).
- **Cron** (`.github/workflows/daily-report.yml`): `0 5 * * 1-5` e `0 6 * * 1-5` (UTC, lun–ven) + `workflow_dispatch` (esecuzione manuale forzata).
- **Resilienza**: se la chiave AI manca/è invalida, l'agente genera comunque il report con un **fallback deterministico** (senza AI). Quindi il report **arriva sempre**.
- **Moduli** (`agent/`): `config.py`, `market_data.py` (yfinance), `analysis.py`, `correlation.py`, `macro_calendar.py`, `report.py`, `notify.py` (SMTP Gmail).

### Segreti da impostare (GitHub → Settings → Secrets and variables → Actions)
| Secret | A cosa serve |
|---|---|
| `SMTP_USER` | la tua email Gmail |
| `SMTP_PASSWORD` | **App Password Gmail di 16 caratteri** (non la password normale) |
| `MAIL_TO` | dove ricevere il report |
| `ANTHROPIC_API_KEY` | *opzionale* — se manca, parte il fallback |

**App Password Gmail**: Account Google → Sicurezza → Verifica in 2 passaggi (attiva) → "Password per le app" → generi i 16 caratteri.
**Regola ferrea**: i segreti si leggono SOLO da variabili d'ambiente. Mai nel codice o nel repository.

---

## 2) EXPERT ADVISOR — REGOLE COMUNI

- Ogni EA è **tutto-in-uno** (.mq5, motore incluso, niente cartella Include): si compila con **F7** sul VPS Contabo senza errori.
- Ogni EA ha **commento ordine** (`InpComment`) e **numero magico** (`InpMagic`) unici → ordini sempre riconoscibili.
- Ogni EA ha un **preset** `.set` abbinato in `mql5/Presets/`.
- Gestione multi-posizione a loop (compatibile Hedge), stop in pari senza stato globale, lotti per rischio %.

---

## 3) ELENCO EA — MAGIC, COMMENTO, CROSS, TIMEFRAME

| EA | Magic | Commento | Cross consigliato | TF | Note |
|---|---|---|---|---|---|
| **ABTG_GoldenCross** | 770301 | — | **XAUUSD (oro)** | M15/H4/D1 | ✅ unico con edge dimostrato (backtest PF ~1.67) |
| ABTG_DAX_M3 | 770501 | — | DAX | M3 | ❌ backtest negativo |
| ABTG_MaxMinNotte | 770401 | — | DAX | — | breakout max/min notte |
| ABTG_ORB / ORB_Fibo | 770601 / 770602 | — | indici US | — | opening range breakout |
| ABTG_Londra_ORB | 770701 | — | **GBP/USD** | H4 | breakout apertura Londra |
| ABTG_SupertrendInvert | 770801 | — | multi | H1 | flip Supertrend "STRONG" |
| ABTG_SupertrendReversal | 770901 | — | forex | H4 | rimbalzo (pip) |
| ABTG_SupertrendReversal_Multi | 771001 | — | oro/indici | H4→H1 | distanze ad ATR |
| ABTG_PointBreak | 771101 | — | — | D1 | Bollinger 37/1.4 + Stoch 5/3/3, mean-reversion |
| ABTG_PostNews (ECB) | 771201 | ECB PostNews | **EUR/JPY** | — | gate news "ECB" stesso giorno |
| ABTG_PostNews (FOMC) | 771202 | FOMC PostNews | **EUR/USD** | — | gate news "FOMC" stesso giorno |
| ABTG_PTE | 771301 | PTE | — | H4 | canali TMA + Doji + Heikin Ashi |
| ABTG_WOL | 771401 | WOL | oro/DAX/forex | D1 | Doji su Weekly Open Line (buffer ATR) |
| ABTG_EMA200 | 771501 | EMA200 | — | H4 | rimbalzo EMA200 con 2 ordini limite; **stop in pari SÌ** |
| ABTG_FiboH4 | 771601 | FIBOH4 | GBPUSD/USDJPY/EURUSD | H4 | engulfing + Fibo (EZ1=1.88, EZ2=2.88, SL=4.236) |
| ABTG_FiboH4_Multi | 771602 | FIBOH4 | multi (`InpSymbols`) | H4 | scansiona più cross da un grafico |
| ABTG_Nightly | 771701 | NIGHTLY | EURUSD/EURGBP/GBPUSD/EURCHF | M1→box | fade box notturno (esclude JPY/AUD/NZD) |
| **ABTG_SuperFilter** | 771801 | SUPERFILTER | forex + oro/indici | H1 | reversal iper-estensione (solo parte meccanica) |

---

## 4) LIMITI ONESTI (cosa NON è automatizzabile)

Alcune strategie usano indicatori **proprietari** o elementi **discrezionali/visivi** che non posso replicare. In quei casi automatizzo solo lo scheletro meccanico e lo dichiaro:

- **SUPERFILTER**: mancano i 2 segnali proprietari **Filter Indicator** e **Supply & Demand**. L'EA fa solo iper-estensione (Bollinger 37/3) + W%R(140) + box asiatico + ATR. → **usalo INSIEME alla dashboard SUPERFILTER**.
- **PTE**: canali TMA (rischio repaint), Doji, Heikin Ashi automatizzati; parte discrezionale no.
- **FIBO H4**: valori proprietari inseriti (1.88 / 2.88 / 4.236) ma la scelta dello swing resta parte critica.
- Larry Williams / Elliott / pattern grafici: non replicabili in modo affidabile.

---

## 5) CONSIGLIO STRATEGICO (ripetuto)

Ci sono **22 EA**. **Solo Golden Cross (oro)** ha un edge dimostrato dai backtest; DAX M3 è risultato negativo. Tutti gli altri sono **da validare col backtest** sullo storico del tuo broker prima del reale.
Strumento disponibile: **ottimizzatore anti-overfitting** (`optimizer/analyze_optimization.py`) che rileva i "plateau" robusti ed esporta il `.set` ottimo.

**Prossimo passo raccomandato**: fermare l'aggiunta di nuovi EA e lanciare una campagna di backtest sui 2–3 più promettenti.

---

## 6) DOVE STA TUTTO

- **Repo**: `claudiospadaro12/GITHUB`, branch `claude/ea-market-openings-d79m8l`
- **EA**: `mql5/Experts/standalone/*.mq5`
- **Preset**: `mql5/Presets/*.set`
- **Agente report**: `agent/` + `.github/workflows/daily-report.yml` + `run_report.py`
- **Ottimizzatore**: `optimizer/`
