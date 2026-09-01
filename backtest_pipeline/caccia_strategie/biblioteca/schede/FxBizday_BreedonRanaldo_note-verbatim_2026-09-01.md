# SCHEDA — `fx-bizday` (QuantRocket) e il paper Breedon–Ranaldo · 01/09/2026

Raccolta di **citazioni verbatim** lette nel sorgente e nei notebook del repo
pubblico `quantrocket-codeload/fx-bizday`, piu' quanto e' stato possibile
leggere del paper accademico che ne e' la fonte.

**Perche' sta in biblioteca:** e' la **conferma esterna** (e insieme la
**falsificazione al costo retail**) del meccanismo che la `SONDA DELL'OROLOGIO`
di casa misura — la deriva oraria del forex. Vedi
`caccia_strategie/CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md`, sezione
**ARMONICHE CON L'OROLOGIO**.

---

## 1. Il paper — [LETTO-VIA-SEARCH, pagina NON aperta]

```
TITOLO     Intraday Patterns in FX Returns and Order Flow
AUTORI     Francis Breedon, Angelo Ranaldo
DATA       working paper 03/04/2012 (Queen Mary, University of London, SEF WP 694)
           SNB Working Paper 2011-04
           pubblicato in Journal of Money, Credit and Banking, luglio 2013
SSRN       https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2099321  -> 403
PDF SNB    https://www.snb.ch/public/asset/.../working_paper_2011_04.n.pdf -> CONNECT 403
ECONSTOR   https://www.econstor.eu/handle/10419/97343                  -> EGRESS_BLOCKED
REPEC      https://ideas.repec.org/p/qmw/qmwecw/694.html                -> EGRESS_BLOCKED
AEA PDF    https://www.aeaweb.org/conference/2009/retrieve.php?pdfid=301 -> CONNECT 403
```

🔴 **Nessuna di queste cinque copie e' apribile da questa sessione.** Cio' che
segue viene da **estratti di motore di ricerca**, etichettati come tali —
stessa etichetta `[LETTO-VIA-SEARCH]` gia' usata in `CONFIG_PROP_2026-08-31.md`
per i normativi prop bloccati.

Frasi riportate dagli estratti:

> "evidence of time-of-day effects in foreign exchange returns through a
> significant tendency for currencies to depreciate during local trading hours"

> "in the case of EUR/USD, it can form a simple, profitable trading strategy.
> Specifically, EUR/USD tends to depreciate in the European morning and then
> appreciate in US trading hours"

> "the pattern is reflected in order flow, suggesting that both patterns relate
> to the tendency of market participants to be net purchasers of foreign
> exchange in their own trading hours"

**Paper precedente dello stesso filone**, stesso esito
(Ranaldo, *Segmentation and Time-of-Day Patterns in Foreign Exchange Markets*,
Journal of Banking & Finance 2009 · SSRN 960209 · **[LETTO-VIA-SEARCH]**):

> "Domestic currencies appreciate (depreciate) systematically during foreign
> (domestic) working hours. These time-of-day patterns are statistically and
> economically highly significant and pervasively persist across many years,
> even after accounting for calendar effects."

---

## 2. L'implementazione pubblica — [VERIFICATO nel sorgente scaricato]

```
REPO       https://github.com/quantrocket-codeload/fx-bizday
FILE       fx_bizday/fx_bizday.py  (raw.githubusercontent, HTTP 200, 3.068 byte)
COPYRIGHT  "Copyright 2020-2024 QuantRocket LLC - All Rights Reserved"
LICENZA    Apache License, Version 2.0   [VERIFICATO, righe 1-13 del file]
COPIA      biblioteca/sorgenti/FxBizday_QuantRocket-Apache2_gh-fx-bizday_2026-09-01.py
```

Le costanti che sono **tutta** la strategia [VERIFICATO, righe 22-31]:

```python
DB               = "fiber-1h"          # barre ORARIE EUR.USD da Interactive Brokers
SIDS             = "FXEURUSD"
SLIPPAGE_BPS     = 0.1
COMMISSION_CLASS = SpotFXCommission
SELL_EUR_START   = "03:00:00"
SELL_EUR_END     = "11:00:00"
BUY_EUR_START    = "11:00:00"
BUY_EUR_END      = "16:00:00"
```

Piu' il filtro dei giorni [VERIFICATO]: `Monday…Friday`, weekend escluso.
Nessuno stop, nessun take, **nessun indicatore**: l'unica variabile e' l'ORA.

**Il fuso, dichiarato dall'autore** [VERIFICATO, `Part2-Time-of-Day-Research.ipynb`]:

> "Note that the timezone for FX is always New York time regardless of the
> currency pair."

e nel commento del grafico:

> "add business day indicators to plot (9 AM - 5 PM Europe time = 3 AM - 11 AM
> New York Time)"

**La regola in prosa** [VERIFICATO, `Part3-Interactive-Strategy-Development.ipynb`]:

> "we will create a strategy which sells EUR.USD from 3 AM to 11 AM New York
> time (9 AM to 5 PM Europe time), then buys EUR.USD from 11 AM to 4 PM."

**Il periodo del backtest** [VERIFICATO, `Part4-Moonshot-Backtest.ipynb`]:
`start_date="2005-03-10", end_date="2024-03-10"` → **19 anni**.
_(Le figure del tearsheet sono immagini: **nessun numero di performance e'
leggibile nel notebook**, e nessuno e' stato usato.)_

---

## 3. 🔴 LA RIGA CHE VALE PIU' DI TUTTE — la falsificazione al costo

**[VERIFICATO, `Part5-Parameter-Scans.ipynb`, cella markdown]:**

> "Because our trading strategy buys and sells EUR.USD every day, we must be
> wary of transaction costs. In the initial backtest we set the one-way
> slippage at 0.1 basis points... We can run a parameter scan to determine how
> sensitive the strategy is to slippage. We check several values from 0.1 to 2
> basis points per trade."

e subito dopo, **il verdetto dell'autore**:

> "Plotting the results using Moonchart reveals that our strategy **cannot
> tolerate much slippage. Even 1 basis point will destroy the profitability**"

Scansione effettiva: `vals1=[0.1, 0.5, 1, 2]` bps **one-way**, su 19 anni.

---

## 4. Lo SPREAD che l'autore ha misurato — e con che strumento

**[VERIFICATO, `Part6-Slippage-Research.ipynb`]** — un mese di barre
bid/ask a 1 minuto (`bar_type="BID_ASK"`, gennaio 2019, 27.270 record):

| ora (New York) | spread medio, in frazione del prezzo |
|---|---|
| 03:00 | 0,000008 |
| 11:00 | 0,000006 |
| 16:00 | 0,000023 |

> "The average spread is about 0.125 basis points. Since the prices used in our
> backtest reflect the midpoint, we only expect to pay half the spread, or
> 0.0675 basis points. Thus, our slippage estimate of 0.1 basis point seems
> reasonable."

📌 **0,125 bp su EURUSD ≈ 0,14 pip.** E' uno spread **Interactive Brokers
IDEALPRO**, non uno spread retail. Il nostro riferimento di casa e' **~1 pip**,
e **non e' mai stato misurato** (`[SPREAD NON MISURATO]`, settima caccia che lo
scrive).

---

## 5. Il terzo tassello — arXiv, letto direttamente

```
arXiv 1103.5664v1 (29/03/2011)
"Intra-Day Seasonality in Foreign Exchange Market Transactions"
export.arxiv.org api -> HTTP 200   [VERIFICATO, abstract letto per intero]
```

> "Empirical analysis of completed transactions data based on the Dealing
> 2000-2 electronic inter-dealer broking system indicates **significant
> evidence of intraday seasonality in returns and return volatilities** under
> usual market conditions."

Coppia: **DEM/USD**. E' la terza fonte indipendente che dice che la stagionalita'
intragiornaliera nei **rendimenti** FX (non solo nella volatilita') esiste.
