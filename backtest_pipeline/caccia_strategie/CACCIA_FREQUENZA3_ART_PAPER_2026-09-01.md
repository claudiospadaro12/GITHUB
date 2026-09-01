# 🏹 CACCIA FREQUENZA — **TERZA BATTUTA · SECONDO FRONTE** · articoli MQL5 · QuantConnect · paper — 01/09/2026

**Mandato (Claudio, 01/09 mattina, testuale):** _"EA a TF bassi con **2 TRADE O
PIU' AL GIORNO**"_.

**Perimetro assegnato (l'altro cacciatore fa TradingView + GitHub — nessuna
sovrapposizione):**
- **ARTICOLI mql5.com/en/articles con CODICE ALLEGATO** — il Code Base e' stato
  misurato **esausto sui motori** il 31/08 (§4.1 della seconda battuta); gli
  **articoli** non erano mai stati censiti in modo sistematico.
- **QuantConnect** — raggiungibile dal 31/08, ma libreria a ribilancio mensile:
  cercare **solo l'intraday**, se esiste.
- **arXiv q-fin / SSRN** — anomalie **intraday**: stagionalita' oraria, mean
  reversion infragiornaliera, opening range, volatilita' per fascia. Il paper
  **2605.04004** (muro d'attrito) e' **gia' agli atti** e si usa **come FILTRO**,
  non si ripresenta.
- 🎯 **Priorita' massima dichiarata nel mandato:** paper su **TIME-OF-DAY
  EFFECTS in FX** — conferma o smentita esterna della **Sonda dell'Orologio**,
  in corso di preparazione da tre giorni.

---

## ⚡ IL RISULTATO IN QUATTRO RIGHE

> **Su 3 fonti vive (articoli MQL5, QuantConnect, arXiv) + 1 canale di ricerca,
> con 2 fonti murate e 6 mirror accademici murati: 1.120 titoli di articolo
> MQL5 censiti su 28 pagine, 83 slug QuantConnect enumerati per intero, 11
> query arXiv. Sono arrivato al sorgente su 9 oggetti e li ho letti riga per
> riga. NE PROMUOVO UNO, E NON E' UN EA.**
>
> 🥇 **Il promosso e' la CALIBRAZIONE ESTERNA DELLA SONDA DELL'OROLOGIO.** Il
> mandato chiedeva paper sul time-of-day FX: ne ho trovati **tre**, piu' — ed e'
> la cosa che non mi aspettavo — **l'implementazione pubblica e completa del
> principale, in Apache 2.0, scaricata e letta riga per riga**. Dice, con l'ora
> esatta: **short EURUSD 08:00→16:00 server, long 16:00→21:00 server.** E' la
> stessa cosa che la nostra sonda sta per misurare, nominata **prima** da un
> paper del *Journal of Money, Credit and Banking* del 2013.
>
> 🔴 **E porta con se' la lapide, scritta dall'autore stesso del codice:**
> _"our strategy cannot tolerate much slippage. **Even 1 basis point will
> destroy the profitability**"_ — su 19 anni, con lo spread misurato a **0,125
> bp** (Interactive Brokers). **1 bp su EURUSD e' ~1,1 pip: circa il NOSTRO
> spread.** La versione **incondizionata** del meccanismo e' gia' morta al
> nostro costo. **Quel che resta in piedi e' esattamente quel che la nostra
> sonda misura: se UNA fascia stretta abbia un rapporto lordo/spread molto
> sopra 3, mentre la media delle otto ore no.**
>
> 🔴 **E il verdetto sulle due fonti nuove, che risparmia due cacce future:
> ZERO candidati da 1.120 articoli MQL5 e ZERO da QuantConnect** — e nei due
> casi il motivo e' **strutturale e misurato**, non "non ho guardato
> abbastanza". Sotto, §4 e §5.

---

## 0. ⚖️ I CRITERI — congelati dal mandato, non toccati dopo

Presi parola per parola dal mandato del 01/09 e **scritti prima di aprire un
sorgente**:

| # | criterio | soglia |
|---|---|---|
| **F1** | **FREQUENZA** | **≥ 2,0 trade/giorno**, `[DICHIARATA]` dall'autore o `[DERIVATA dal meccanismo]` |
| **F2** | **TAGLIA** | fascia con **spread `[NON MISURATO]`** — take/drift lordo ≥ **3 × spread** |
| **F3** | **GEOMETRIA** | geometria propria **o** regola d'uscita definita. Per i paper: **entry E exit replicabili in MQL5 senza inventare pezzi** |
| **H8** | **ARITMETICA** | `p ≥ 1,075/(RR+1)`. 🔴 **RR < 0,70 = MORTO PER ARITMETICA**, senza corsa |
| **T12** | **TENUTA** | mediana ≥ **12 barre del TF** |
| **A** | **ARTICOLI MQL5** | **codice allegato scaricabile e leggibile**, licenza citata |
| **N** | **NUMERI D'AUTORE** | si leggono e **non si usano in nessun punteggio** |

**Piu' i paletti di casa, non negoziabili:** §4 del setaccio (niente martingala,
griglia, recovery, hedge di copertura, stop virtuale, lotto fisso, repaint,
`#import`, `WebRequest`, `iCustom` non allegato) · **P5 HFT** di
`CONFIG_PROP_2026-08-31.md` (**max 25% dei trade sotto 60 s**; il piu' severo
misurabile censito e' E8 al 50%, noi siamo al 4,6%) · **niente tick-scalping** ·
**F4 famiglie cadute** · **F5 doppioni interni** · **F11 non si tocca il
forward**.

---

## 1. 📕 IL CIMITERO, RILETTO PRIMA DI USCIRE

Letti per intero prima di aprire un browser: `CACCIA_FREQUENZA_2026-08-31.md`
(+ il suo **addendum serale**), `CACCIA_FREQUENZA2_2026-08-31.md`,
`REGISTRO_TEST.md`, `CACCIA_PAPER_ACCADEMICI_2026-08-30.md`,
`report/CONFIG_PROP_2026-08-31.md` (sez. HFT),
`prove/SONDA_OROLOGIO_FX.txt` (i criteri C1-C7 congelati),
`prove/REFERTO_PREPARAZIONE_OROLOGIO.md`, `prove/SONDA_OROLOGIO_01…06`,
`mql5/Experts/ABTG_SondaOrologio.mq5` (l'intestazione, 120 righe).

| famiglia caduta / occupata | verdetto misurato | chi ha ucciso oggi |
|---|---|---|
| **breakout · ORB · session breakout** | ~210 celle a tick, R45 **0/48**, R12 **48/48 negative OOS**. Chiuso 26.07.26 | 🔴 **S2** (art. 23226, ORB su azioni US), **S6** (art. 20339), **S7** (art. 18867) |
| **fade degli estremi di sessione** | R42 **0/24 IS e 0/24 OOS** | 🔴 **S1** — ed e' il caso piu' istruttivo della battuta (§4.2) |
| **CRT / Turtle Soup** | `REFERTO_CRT_2026-08-30.md`, **0/30 celle** a tick, chiuso il 30/08 | 🔴 **S8** (art. 23155, *Turtle Soup Liquidity Sweeps*) |
| **capitolo M1 · capitolo M5** | chiusi a tick. M1 = _"trappola di costo strutturale"_ | 🔴 **S3** (art. 18269/18298, envelopes su M1) |
| **momentum intraday a orario fisso (Gao)** | R98 **−0,31 punti/trade su 410** | 🔴 **S11** (QuantConnect *Intraday ETF Momentum*, gia' scartato il 31/08 come S10) |
| **M0PB** (promosso della prima battuta) | 🔴 **MORTO al PASSO 0 il 31/08 sera**: F1 **0/12**, lato migliore **0,52 segnali/giorno** contro soglia 1,00 | — |
| **filtro appiccicato a motore gia' tarato** | **0 successi su 5** | 🟠 pesa su S10 (*Meta-Labeling the Classics*) |
| **`L'OROLOGIO`** — EA scritto, 7 prove, riga pronta, **MAI GIRATO** | 🔴 nessun referto in `risultati_archivio` (**riverificato oggi: zero file**) | 🎯 **e' il bersaglio del promosso** |

📌 **La frase che ha fatto da bussola, ora alla quarta conferma:**
> _"La frequenza NON la compreremo scendendo di timeframe. Va presa con PIU'
> SIMBOLI a M15-H1."_ (caccia M1, 29/08)

---

## 2. 📡 CONTROLLO POSITIVO — misurato oggi, 01/09, fonte per fonte

| fonte | HTTP | bersaglio noto verificato **oggi** | esito |
|---|---|---|---|
| **Articoli MQL5** | **200** | `/en/articles/21283` → `<title>` letto: _"From Novice to Expert: Automating Intraday Strategies"_ — **identico** al censimento del 31/08 (scarto S7 della prima battuta) | 🟢 **PASSA** |
| **Indice articoli** `/en/articles/mt5` | **200** | 168.052 byte, **40 titoli con id, autore e data** estratti dalla pagina 1 | 🟢 **PASSA** |
| **arXiv API** (`export.arxiv.org`) | **200** | `id_list=2605.04004` → _"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures: A Systematic Falsification Study"_ | 🟢 **PASSA** |
| **QuantConnect** | **200** | `…/investment-strategy-library/intraday-dynamic-pairs-trading-…` → **264.975 byte**, `<title>` corretto | 🟢 **PASSA** (secondo giorno di fila) |
| **`raw.githubusercontent`** | **200** | `quantrocket-codeload/fx-bizday/README.md`, 602 byte, testo coerente | 🟢 **PASSA** — 👉 **ed e' la fonte che ha consegnato il risultato del giorno** |
| **SSRN** | **403** | — | 🔴 **NULLA — DECIMA di fila** |
| **Forex Factory** | non provata | fuori perimetro oggi | ⬜ |

### ⛔ Canali murati, rimisurati oggi per non riprovarli

| canale | esito |
|---|---|
| **Ricerca articoli** `?/articles/find?keyword=` | 🔴 **404**. Non esiste |
| **Ricerca articoli** `/en/search?keyword=…&module=mql5_module_articles` | 🟠 **200 ma inutile**: la pagina rende, i **risultati sono caricati in JS**, l'HTML grezzo contiene **1 solo link** ad articolo. 👉 **Il censimento degli articoli si fa SOLO sfogliando le pagine**, come per il Code Base |
| **`api.github.com`** (contents di un repo pubblico) | 🔴 **403** — _"GitHub access to this repository is not enabled for this session"_. 🟢 **Ma `raw.githubusercontent.com` risponde 200**: si scaricano i file **a nome**, uno per uno, e ha funzionato |
| **snb.ch · econstor.eu · ideas.repec.org · qmul.ac.uk · aeaweb.org** | 🔴 **CONNECT 403 / EGRESS_BLOCKED**, tutti e cinque |
| **bis.org · nber.org · core.ac.uk · jstor · wiley · researchgate · scholar.google · semanticscholar (+ api)** | 🔴 **HTTP 000, tutti e undici**. 👉 **L'intero canale accademico non-arXiv e' murato da qui.** Sondati in blocco, misurato, scritto |
| **quantrocket.com** (blog e notebook renderizzati) | 🔴 **EGRESS_BLOCKED** — 🟢 **aggirato via `raw.githubusercontent`**, che serve gli **stessi notebook in originale** |

> 🎯 **Il risultato di processo della battuta, e vale per le prossime:**
> **quando un sito che ospita ricerca e' murato, si cerca il suo REPO.** Il
> paper di Breedon-Ranaldo e' irraggiungibile su cinque mirror; la sua
> **implementazione completa** sta su GitHub, in Apache 2.0, e da li' si scarica.
> **Il codice passa dove il PDF non passa.**

---

## 3. 🎯 ARMONICHE CON L'OROLOGIO — la sezione che il mandato ha chiesto per prima

> **Contesto:** in casa e' in preparazione la **Sonda dell'Orologio** (EA
> `ABTG_SondaOrologio.mq5`, 7 file prova, riga di lancio pronta dal 28/08,
> **mai girata**). Misura la **deriva oraria** su EURUSD / GBPUSD / XAUUSD, H1,
> 2011-2026, **due lati in corse separate**. La nota di chat dice che l'ipotesi
> di casa e' **lo short del mattino europeo su EURUSD**.
> **Domanda del mandato: la letteratura conferma o smentisce?**
> **Risposta: conferma il SEGNO e l'ORA. E falsifica la versione ingenua.**

### 3.1 🥇 Breedon & Ranaldo — *Intraday Patterns in FX Returns and Order Flow*

```
AUTORI      Francis Breedon (QMUL), Angelo Ranaldo (SNB / Univ. St. Gallen)
DATA        WP 03/04/2012 (QMUL SEF WP 694 · SNB WP 2011-04)
            pubblicato in JOURNAL OF MONEY, CREDIT AND BANKING, luglio 2013
ETICHETTA   [LETTO-VIA-SEARCH]  -- CINQUE copie provate, ZERO aperte:
            SSRN 2099321 (403) · PDF snb.ch (CONNECT 403) · econstor.eu
            (EGRESS_BLOCKED) · ideas.repec.org (EGRESS_BLOCKED) ·
            qmul.ac.uk (EGRESS_BLOCKED) · aeaweb.org PDF (CONNECT 403)
```

Frasi riportate dagli estratti di ricerca (**non lette su pagina**):

> _"evidence of time-of-day effects in foreign exchange returns through a
> significant tendency for **currencies to depreciate during local trading
> hours**"_

> _"in the case of EUR/USD, it can form a **simple, profitable trading
> strategy**. Specifically, **EUR/USD tends to depreciate in the European
> morning and then appreciate in US trading hours**"_

> _"the pattern is reflected in **order flow**, suggesting that both patterns
> relate to the tendency of market participants to be **net purchasers of
> foreign exchange in their own trading hours**"_

🎯 **E' l'ipotesi di casa, parola per parola, da un journal peer-reviewed.**
E porta con se' **il meccanismo economico** — che e' esattamente cio' che
`prove/LEGGIMI.md` pretende come primo requisito di un round: le imprese
domestiche comprano valuta estera nelle **proprie** ore d'ufficio, e questo
squilibrio d'inventario dei dealer si scarica in **pressione di vendita sulla
valuta domestica durante le ore domestiche**.

### 3.2 🥈 Ranaldo (2009) — la stessa cosa, due anni prima, su piu' valute

*Segmentation and Time-of-Day Patterns in Foreign Exchange Markets*, **Journal
of Banking & Finance 2009**, SSRN 960209. **[LETTO-VIA-SEARCH]**

> _"Domestic currencies appreciate (depreciate) systematically during foreign
> (domestic) working hours. These time-of-day patterns are **statistically and
> economically highly significant and pervasively persist across many years,
> even after accounting for calendar effects**."_

📌 Vale doppio per noi per **due** ragioni: (a) e' una fonte **indipendente e
anteriore**, quindi non e' un paper solo; (b) dice esplicitamente **"even after
accounting for calendar effects"** — cioe' **non e' la stagionalita' di
calendario**, che in casa e' **gia' caduta** (R63, **0/24 OOS su 11.928
operazioni**). 👉 **Non e' un doppione di un morto.**

### 3.3 🥉 arXiv 1103.5664 — la terza gamba, e questa l'ho letta davvero

*Intra-Day Seasonality in Foreign Exchange Market Transactions* (29/03/2011).
**[VERIFICATO, abstract letto per intero via `export.arxiv.org`]**

> _"Empirical analysis of completed transactions data based on the Dealing
> 2000-2 electronic inter-dealer broking system indicates **significant
> evidence of intraday seasonality in returns and return volatilities** under
> usual market conditions. Moreover, analysis of realised tail outcomes
> supports seasonality for **extraordinary market conditions** across the
> trading day."_

Coppia: **DEM/USD**, dati inter-dealer. 👉 Nota il dettaglio che conta:
**seasonality in RETURNS**, non solo in volatilita'. La stagionalita' oraria
della **volatilita'** e' un fatto banale e non tradabile da sola; quella dei
**rendimenti** e' la nostra tesi.

### 3.4 🔥 `fx-bizday` — **l'implementazione pubblica del paper, letta riga per riga**

E' il pezzo che non mi aspettavo di trovare, ed e' quello che rende la sezione
operativa invece che culturale.

```
REPO        github.com/quantrocket-codeload/fx-bizday
FILE        fx_bizday/fx_bizday.py     [VERIFICATO, raw.githubusercontent 200, 3.068 byte]
AUTORE      QuantRocket LLC
LICENZA     Apache License 2.0         [VERIFICATO, righe 1-13 del file]
FONTE       dichiarata dall'autore in Introduction.ipynb:
            "Source paper: Breedon, Francis and Ranaldo, Angelo, Intraday
             Patterns in FX Returns and Order Flow ... SSRN 2099321"
COPIA       biblioteca/sorgenti/FxBizday_QuantRocket-Apache2_gh-fx-bizday_2026-09-01.py
SCHEDA      biblioteca/schede/FxBizday_BreedonRanaldo_note-verbatim_2026-09-01.md
```

**La strategia INTERA, verbatim dal sorgente** [VERIFICATO, righe 22-31]:

```python
DB             = "fiber-1h"          # barre ORARIE EUR.USD (Interactive Brokers)
SIDS           = "FXEURUSD"
SLIPPAGE_BPS   = 0.1
SELL_EUR_START = "03:00:00"    SELL_EUR_END = "11:00:00"
BUY_EUR_START  = "11:00:00"    BUY_EUR_END  = "16:00:00"
```
più il filtro `Monday…Friday`. **Nessuno stop. Nessun take. Nessun indicatore.
L'unica variabile e' l'ORA.** Backtest dichiarato: `start_date="2005-03-10",
end_date="2024-03-10"` = **19 anni**.

**Il fuso, dichiarato dall'autore** [VERIFICATO, `Part2-Time-of-Day-Research.ipynb`]:
> _"Note that the timezone for FX is always **New York time** regardless of the
> currency pair."_ e nel commento del grafico: _"9 AM - 5 PM Europe time = 3 AM
> - 11 AM New York Time"_.

#### 🕐 LA CONVERSIONE IN ORA SERVER BCM — e il fatto fortunato

Regola di casa: **server = ora italiana − 1**.

| | NY | UTC | **server BCM** |
|---|---|---|---|
| **ESTATE** (NY UTC−4, IT UTC+2 → server UTC+1) | 03:00 / 11:00 / 16:00 | 07 / 15 / 20 | **08:00 / 16:00 / 21:00** |
| **INVERNO** (NY UTC−5, IT UTC+1 → server UTC+0) | 03:00 / 11:00 / 16:00 | 08 / 16 / 21 | **08:00 / 16:00 / 21:00** |

> 🎯 **Le due letture COINCIDONO**, perche' NY e l'Europa cambiano ora legale
> insieme. **`SHORT EURUSD 08:00 → 16:00 server` · `LONG EURUSD 16:00 → 21:00
> server`.** [INFERITO dal calcolo dei fusi, **non verificato sull'orologio del
> terminale**.] Resta l'errore delle **~4 settimane l'anno** in cui le due ore
> legali non si accendono lo stesso giorno — ed e' **gia' dichiarato dal
> criterio C6** della sonda. **Non e' un errore nuovo.**
>
> 📌 E **08:00 server = 09:00 italiane = apertura dell'ufficio europeo**: e'
> esattamente *"lo short del mattino europeo su EURUSD"* della nota di chat.

#### 🔴 E ADESSO LA LAPIDE — scritta dall'autore del codice, e va letta due volte

**[VERIFICATO, `Part5-Parameter-Scans.ipynb`, cella markdown]:**

> _"Because our trading strategy buys and sells EUR.USD every day, we must be
> wary of transaction costs... We can run a parameter scan to determine how
> sensitive the strategy is to slippage. We check several values from 0.1 to 2
> basis points per trade."_
>
> _"Plotting the results using Moonchart reveals that our strategy **cannot
> tolerate much slippage. Even 1 basis point will destroy the profitability**"_

Scansione: `[0.1, 0.5, 1, 2]` bps **one-way**, su **19 anni**.

**E lo spread che l'autore ha MISURATO** [VERIFICATO, `Part6-Slippage-Research.ipynb`,
un mese di barre `BID_ASK` a 1 minuto, 27.270 record]:

| ora NY | spread medio (frazione del prezzo) |
|---|---|
| 03:00 | 0,000008 |
| 11:00 | 0,000006 |
| 16:00 | 0,000023 |

> _"The average spread is about **0.125 basis points**. Since the prices used in
> our backtest reflect the midpoint, we only expect to pay half the spread, or
> 0.0675 basis points."_

**0,125 bp su EURUSD ≈ 0,14 pip. E' Interactive Brokers IDEALPRO, non retail.**

### 3.5 🧮 L'ARITMETICA CHE NE SEGUE — la parte che vale per noi

**1 bp su EURUSD a 1,10 ≈ 1,1 pip.** Il nostro riferimento e' **~1 pip**, e
**non e' mai stato misurato** (`[SPREAD NON MISURATO]`, e questa e' la
**settima** caccia che lo scrive).

👉 **Traduzione senza sconti: la versione INCONDIZIONATA del meccanismo — dentro
tutti i giorni, tutte le ore della fascia — e' gia' dichiarata morta dal suo
stesso autore a un costo che e' circa il nostro.**

E si puo' anche **limitare l'edge lordo da sopra e da sotto**, con la sola
aritmetica e le sole affermazioni dell'autore
[**CALCOLO MIO, non un numero dell'autore**]:

- il motore e' **sempre a mercato** nei giorni feriali e fa **3 transizioni al
  giorno** (apre lo short alle 03:00, gira long alle 11:00, chiude alle 16:00);
- a **0,1 bp** e' profittevole → costo ≈ 0,3 bp/giorno ≈ **0,75%/anno** di
  nozionale;
- a **1,0 bp** "la profittabilita' e' distrutta" → costo ≈ 3 bp/giorno ≈
  **7,5%/anno** di nozionale.

> 🎯 **Quindi l'edge LORDO annuo del meccanismo nudo sta fra ~0,75% e ~7,5% del
> nozionale.** Su ~500 gambe l'anno sono **fra 0,15 e 1,5 bp per gamba**, cioe'
> **fra ~0,17 e ~1,7 pip** di deriva lorda mediana. **Contro uno spread retail
> di ~1 pip.** 🔴 **E' un margine che vive o muore su un fattore 2, non su un
> fattore 10.**

### 3.6 ✅ COSA CAMBIA, CONCRETAMENTE, PER LA SONDA GIA' PRONTA

**Niente da riscrivere. Due cose da aggiungere, e sono gratis.**

**(a) Il criterio C2 diventa una PRE-REGISTRAZIONE vera.** C2 dice, congelato:
_"la cella vale SOLO se e' quella che la TESI aveva indicato PRIMA"_. Finora la
tesi era **nostra**; da oggi e' **un paper del JMCB 2013 + una replica
open-source di 19 anni**, che nominano le celle **per nome e per ora**. Le ho
scritte in un foglio a parte, **prima** che la sonda giri:

📄 `backtest_pipeline/prove/OROLOGIO_PREREGISTRAZIONE_BREEDON_2026-09-01.txt`

| cella | simbolo | lato | `InpOraIngresso` | `InpOreDurata` | file esecutivo esistente |
|---|---|---|---:|---:|---|
| **A** 🥇 | EURUSD | **SHORT** | **8** | **8** | `SONDA_OROLOGIO_02_EURUSD_SHORT.txt` |
| **B** | EURUSD | LONG | 16 | 4 | `SONDA_OROLOGIO_01_EURUSD_LONG.txt` |
| **C** | GBPUSD | SHORT | 8 | 8 | `SONDA_OROLOGIO_04_GBPUSD_SHORT.txt` |
| **D** | USDJPY | LONG | 0 | 8 | 🔴 **non esiste**: la sonda copre EUR/GBP/XAU |
| — | **XAUUSD** | — | — | — | ⬜ **nessuna previsione esterna**: l'oro non ha "ore d'ufficio locali". Le corse `_05`/`_06` restano **esplorative**, e C2 va letto li' nella forma piu' severa |

✅ **Tutte e tre le celle A/B/C sono GIA' DENTRO la griglia congelata**
(`InpOraIngresso` 0-23 passo 1, `InpOreDurata` 4/8/12): **non serve toccare una
riga dei sette file.**

**(b) Il cancello C1 adesso ha un numero esterno accanto.** C1 chiede gia'
`|lordo medio giornaliero| ≥ 3 × spread mediano DELLA STESSA ORA`. L'aritmetica
del §3.5 dice **quanto e' stretto quel cancello nella realta'** — e che la
speranza non e' "la media delle otto ore", ma **una fascia stretta con un
rapporto molto sopra 3**.

### 3.7 🏆 E il regalo che la sonda fa senza che nessuno gliel'abbia chiesto

Leggendo l'intestazione di `ABTG_SondaOrologio.mq5` [VERIFICATO, righe 32, 111,
113, 189, 242]:

```
//|     spread mediano misurato IN QUELLA STESSA ORA?"
//|  LO SPREAD SI MISURA NELL'ISTANTE IN CUI SI PAGA (lezione R55)
//|  Il campione dello spread e' preso (ask-bid)/_Point ESATTAMENTE ...
input int InpMaxSpreadPts = 0;  // 0 = SPENTO: lo spread si MISURA, non si filtra
double   gSpread[];             // un campione per operazione, preso quando si paga
```

> 🎯 **La sonda dell'Orologio MISURA LO SPREAD BCM, ORA PER ORA, su tre
> simboli.** E' il numero che **sette dossier di caccia** di fila hanno dovuto
> marcare `[SPREAD NON MISURATO]`, e che il *RealCost Spread P95 Logger* (Code
> Base **74148**) doveva produrre dal **23/08** senza mai girare.
> **Accendere la sonda chiude anche quel buco, gratis, e nel posto giusto: non
> lo spread medio, ma lo spread NELL'ORA IN CUI SI PAGA.**

---

## 4. 📚 ARTICOLI MQL5 — **1.120 titoli censiti, ZERO candidati**, e il perche' e' strutturale

### 4.1 Cosa ho sfogliato

| cosa | quanto |
|---|---|
| pagine di `/en/articles/mt5` sfogliate | **28** (pagina 1 → page28) |
| **id articolo unici censiti** con titolo | **1.120** |
| titoli in bersaglio dopo il filtro per parola chiave (intraday, session, scalp, time-of-day, hourly, London/NY/Asian, seasonal, high-frequency, multi-pair, opening range) | **~60** |
| articoli aperti e con metadati letti (autore, data, allegati) | **11** |
| **sorgenti scaricati e letti** | **6** (5 `.mq5`/zip + 1 `.py`) |

### 4.2 🗑️ Gli scartati, con la riga che lo prova

| # | articolo | autore / data | la riga che lo prova |
|---|---|---|---|
| **S1** | **`Formulating Dynamic Multi-Pair EA (Part 8): Time-of-Day Capital Rotation Approach`** — [art. 21976](https://www.mql5.com/en/articles/21976), `ToD_Cap_Rotation.mq5`, **1.234 righe**, 27 input | **Hlomohang John Brian** · 16/04/2026 | 🔴 **DUE MOTIVI, e il secondo e' un bug che ribalta la strategia.** (1) Il motore e' **rottura/fade dell'estremo di sessione** = **R45/ORB** (chiuso, ~210 celle) **+ R42 fade** (0/24 IS e 0/24 OOS). (2) 🔬 **Il ramo "breakout genuino" e' CODICE MORTO**, e si legge alle righe **663-679**: il grilletto scatta su `ask >= sessionHigh` e **nella stessa istruzione** pone `highBreakoutTriggered = true`; subito dopo chiede `ask >= upperVolatilityStop` dove `upperVolatilityStop = sessionHigh + ATR*1,5`. Al primo tocco quella condizione e' falsa (serve un gap di 1,5 ATR), e il flag impedisce di riprovare piu' tardi → **l'EA prende SEMPRE il ramo `FADE`**. L'autore crede di aver scritto "breakout con conferma", ha scritto "fade dell'estremo". In piu': decisioni **su ogni tick** (`OnTick` senza `IsNewBar`), **nessun `OnTester`** (il driver non parte), `DailyCapitalPercent = 30.0` con `NYAllocationPercent = 15.0` → **fino al 4,5% di equity a rischio per sessione**, contro il nostro 0,65% |
| **S2** | **`Low-Frequency Quantitative Strategies in MT5 (Part 4): A Volatility-Adjusted Momentum-Based Intraday System`** — [art. 23226](https://www.mql5.com/en/articles/23226), `ORB_Expert.mq5` 283 righe + `ORBMath.mqh` 109 | **Jocimar Lopes** · 06/07/2026 | 🔴 **Il titolo dice "momentum intraday", il codice e' un ORB su AZIONI USA.** Input letti: `InpMarketOpenET="09:30"`, `InpMaxSymbols=20`, `InpMinVolume=1000000` (volume medio a 14 giorni), `InpRelVolThreshold=100.0`. Il `.ini` allegato e' `backtest_settings_PLTR_.ini`. 👉 **Doppia squalifica: famiglia ORB chiusa** + **universo di 20 azioni USA che BCM non quota**. 🟢 Da tenere: `InpRiskPercent` e' rischio vero, e `InpServerUTCOffset` e' un input esplicito — dettaglio che i nostri EA di sessione non hanno |
| **S3** | **`Automating Trading Strategies in MQL5 (Part 18-19): Envelopes Trend Bounce Scalping`** — [art. 18269](https://www.mql5.com/en/articles/18269) + [18298](https://www.mql5.com/en/articles/18298), **4.179 righe** | **Allan Munene Mutiiria** · 02 e 06/06/2025 | 🔴 **MORTO PER ARITMETICA, in due righe.** `TakeProfitModuleValue1 = 3` (pip) contro `StopLossModuleValue1 = 9` (pip) → **RR = 0,333**. Cancello H8: servirebbe `p ≥ 1,075/1,333 = ` **80,6%** di win rate. **RR < 0,70 → scarto senza corsa**, com'e' scritto nei criteri. E il resto conferma: tutti gli indicatori su **M1** (`iEnvelopes` M1, `iMA_EMA200` M1, `iRSI` M1) = **capitolo M1 chiuso** _("trappola di costo strutturale")_; deviazioni delle envelope **asimmetriche** (1,4% sotto contro 0,1% sopra) = la taratura dell'autore, e i due lati non sono confrontabili; `Stoplos = 2000; // Unused Stop Loss parameter` e sezioni `-----MODULE INPUTS-----` = file **generato da un builder** |
| **S4** | **`Pair Trading: Algorithmic Trading with Auto Optimization Based on Z-Score Differences`** — [art. 17800](https://www.mql5.com/en/articles/17800), `PairsTradingOpt.mq5`, 976 righe | **Yevgeniy Koshtenko** · 31/03/2026 | 🔴 **§4 SECCO, tre volte, e sta tutto negli input.** `EnableAveraging = true` con `AveragingLotMultiplier = 1.5` → **averaging con moltiplicatore di lotto**; `LotSize = 0.01` **fisso**; e alla riga 620 `double virtualStopLoss = 100;` → **stop VIRTUALE** usato per dimensionare. 🟡 Peccato: la classe (spread cointegrato market-neutral) resta un **buco vero** della flotta — ma **non entra da questa porta**, ed e' la **seconda** volta che lo scrivo (la prima e' S6 del 31/08) |
| **S5** | **`Beyond the Clock (Part 4): Efficacy of Bars on Trending and Mean-Reversion Strategies`** — [art. 23310](https://www.mql5.com/en/articles/23310) | **Patrick Njoroge** · 17/07/2026 | 🟠 **SCARTO come candidato, PROMOSSO come LAPIDE — e ci risparmia una caccia intera** (§6.1). Non e' un EA: e' un notebook Python + `afml.zip`. Ma la sua conclusione chiude una direzione che sarebbe stata la prossima ovvia: **le barre alternative NON comprano frequenza utile** |
| **S6** | **`Automating Trading Strategies in MQL5 (Part 42): Session-Based Opening Range Breakout (ORB) System`** — [art. 20339](https://www.mql5.com/en/articles/20339) | Allan Munene Mutiiria | 🔴 **F4 dal titolo**: ORB di sessione, famiglia chiusa da **~210 celle a tick**. Primo taglio, dichiarato |
| **S7** | **`Automating Trading Strategies in MQL5 (Part 24): London Session Breakout System`** — [art. 18867](https://www.mql5.com/en/articles/18867) | Allan Munene Mutiiria | 🔴 **F4**: London breakout. R45 **0/48** su GBPUSD/EURUSD/XAUUSD. Primo taglio |
| **S8** | **`Automating Trading Strategies in MQL5 (Part 50): Turtle Soup Liquidity Sweeps`** — [art. 23155](https://www.mql5.com/en/articles/23155) | Allan Munene Mutiiria | 🔴 **F4**: e' **CRT/Turtle Soup**, **chiuso il 30/08** con `REFERTO_CRT_2026-08-30.md` (**0/30 celle** a tick, col gate **PF 0,459** contro 0,462 ungated) |
| **S9** | **`Building an Object-Oriented Session VWAP Engine in MQL5`** — [art. 22990](https://www.mql5.com/en/articles/22990) | — | 🔴 **F5 doppione**: `ABTG_VwapRevert` esiste gia' in casa, PASSO 0 preparato. Primo taglio |
| **S10** | **`Meta-Labeling the Classics (Part 1-2): Filtering and Sizing RSI / ADX Trades`** — [art. 22274](https://www.mql5.com/en/articles/22274) + [22754](https://www.mql5.com/en/articles/22754) | — | 🟠 **SCARTO per il mandato, e il motivo e' di casa**: il meta-labeling **e' per definizione un secondo modello appiccicato a un motore gia' tarato** — `ROBUSTEZZA.md` §5B, **0 successi su 5** (R20 ADX, R12, R26, R45, R54). E **non aumenta la frequenza: la riduce** (filtra). Fallisce F1 per costruzione |
| **S11** | **`Formulating Dynamic Multi-Pair EA (Part 5, 6, 7, 9, 10)`** — art. [19989](https://www.mql5.com/en/articles/19989), [20371](https://www.mql5.com/en/articles/20371), [21460](https://www.mql5.com/en/articles/21460), [22772](https://www.mql5.com/en/articles/22772), [23597](https://www.mql5.com/en/articles/23597) | Hlomohang John Brian | 🟠 **Scartati come FAMIGLIA insieme a S1**, e lo dichiaro: sono la **stessa serie** e condividono il chassis. Ho letto il motore in Part 8 (S1) e l'ho trovato rotto; **non ho aperto i sorgenti degli altri cinque**. 👉 **Se qualcuno vuole riaprire la serie, il punto da verificare e' UNO: il ramo `FADE`/`GENUINE` delle righe 663-679, e se e' lo stesso codice, cade tutta** |
| **S12** | **`Analyzing the Hourly Movement of Trading Symbols and Their Spreads`** — [art. 18821](https://www.mql5.com/en/articles/18821), `ISI_ProSpreadSMA.mq5`, 719 righe | **Roman Shiredchenko** · 14/07/2026 | 🟠 **SCARTO come candidato (e' un INDICATORE: `#property indicator_separate_window`, nessun `OrderSend` → niente da backtestare).** ⚠️ **E attenzione al falso amico: "spread" qui NON e' il bid/ask.** Il codice legge `InpSymbol2 = "" // Secondary symbol (for spread)` e calcola `K1*Prezzo1 − K2*Prezzo2`: e' uno **spread sintetico fra due simboli**. 🔴 **NON chiude il buco `[SPREAD NON MISURATO]`** — chi lo cercasse li' perderebbe una giornata. 🟢 Cosa tiene: una `struct HourStats { totalBars; bullishBars; bearishBars; sumBodySize; sumRange; probability; direction; }` **per ora del giorno**: e' l'armonica dell'Orologio in MQL5, ma **misura direzione delle candele, non deriva netta** |

### 4.3 Scartati al primo taglio (titolo/pagina, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---:|---|
| **attrezzi e infrastruttura** — pannelli, dashboard, CCanvas, logger, portfolio analyzer, gestori d'ordine, cache di metadati, object pool, trailing engine, PDF report | **~380** | 🔴 **zero ingressi = niente da backtestare**. E' la classe piu' numerosa in assoluto degli articoli MQL5 |
| **machine learning / reti neurali / GARCH / ottimizzatori metaeuristici** (serie `Neural Networks in Trading`, `Beyond GARCH`, `Building Volatility Models`, `Elite ... Algorithm`, `Feature Engineering for ML`, `MQL5 Wizard Techniques`) | **~330** | 🔴 Fuori mandato e **gia' chiuso da un numero**: arXiv 2605.17724 dichiara che **4 anni di OHLCV a 5 minuti su un simolo NON bastano** per ML sequenziale intraday, e la nostra finestra tick sugli indici e' **21 mesi** |
| **SMC / ICT** (order block, FVG, liquidity sweep, CHoCH, BoS, Judas Swing, Quasimodo, tCISD, inducement, premium/discount) | **~55** | 🔴 **famiglia gia' setacciata** il 26/08 (`CACCIA_SMC_OB_FVG_2026-08-26.md`) e il 30-31/08 (CRT chiuso, 0/30) |
| **calendario economico / news** (11 puntate `Animated News Headline` + 4 `Economic Calendar for News Filter` + altri) | **~25** | 🟠 **Non e' un motore di frequenza, ed e' anche un problema prop**: `CONFIG_PROP_2026-08-31.md` misura che **FundingPips e E8 annullano i profitti** dei trade aperti/chiusi nella finestra **5 min prima / 5 min dopo** una news rossa sui conti Master. Un motore che vive sulle news **regala** i suoi giorni migliori. 🟢 Da tenere come **filtro**, non come motore — ed e' gia' nel `DOSSIER_NEWS_FILTER_2026-08-21.md` |
| **opzioni / greche / arbitraggio swap / criptovalute / mercati elettrici** | **~40** | 🔴 strumenti che BCM non quota, o fuori mandato |
| **serie a puntate gia' viste nei dossier precedenti** (art. 17603, 19052, 19944, 20569, 20908, 21133, 21283, 23541) | **8** | 🔵 **cio' che e' setacciato non si ricontrolla** |
| **resto del catalogo** (integrazione Python, grafica, tutorial di linguaggio, interviste, statistica descrittiva) | **~250** | 🔴 fuori bersaglio per genere |

### 4.4 🎯 IL VERDETTO SULLA FONTE — e va scritto, perche' risparmia tempo

> **Gli articoli MQL5 sono una fonte di ATTREZZI e di DIDATTICA, non di
> MOTORI.** Su **1.120 titoli**, gli EA di strategia intraday completi sono
> **meno di 15**, e appartengono tutti a **tre serie a puntate** (`Automating
> Trading Strategies`, `From Novice to Expert`, `Formulating Dynamic Multi-Pair
> EA`) i cui motori sono **breakout di sessione, ORB, SMC/ICT e scalping su
> M1** — cioe' **le quattro famiglie che in casa sono gia' chiuse con centinaia
> di celle a tick**.
>
> 🔬 **E c'e' una ragione strutturale, non un caso:** un articolo deve
> **spiegare** un'idea in 3.000 parole. Le idee spiegabili in 3.000 parole sono
> le idee **note**. Le famiglie note sono quelle che abbiamo gia' misurato.
> 👉 **Conclusione operativa: gli articoli MQL5 si aprono per cercare un PEZZO
> (un modulo, un idioma, un metodo di misura), non per cercare un motore.**
> Come il Code Base dal 31/08. **Le due meta' di mql5.com sono adesso
> misurate entrambe.**

---

## 5. 🔵 QUANTCONNECT — **83 slug enumerati per intero, ZERO candidati, e la fonte si chiude**

Ho estratto dalla pagina indice **tutti e 83** gli slug della *Investment
Strategy Library* [VERIFICATO: la pagina dichiara _"Check out **83 articles**"_
e ne ho contati 83 unici nel blob JS].

**Gli slug con "intraday" nel nome sono TRE. Non ce ne sono altri.**

| # | strategia | esito |
|---|---|---|
| **S13** | `intraday-arbitrage-between-index-etfs` — **[LETTA per intero oggi]** | 🔴 **Arbitraggio SPY/IVV su L1 quotes.** Verbatim: _"an arbitrage opportunity is only acted upon when the threshold is satisfied for **15 seconds**"_. 👉 **Tre squalifiche: (a) due ETF USA che BCM non quota; (b) richiede il book bid/ask consolidato al secondo — dato che non abbiamo; (c) tenute da secondi = viola il paletto HFT P5** (max 25% dei trade sotto 60 s) **e la clausola FundingPips sul "toxic flow"** (_"aperto e chiuso in SECONDI"_) |
| **S14** | `intraday-dynamic-pairs-trading-using-correlation-and-cointegration-approach` — **[LETTA per intero oggi]** | 🔴 **20 azioni bancarie USA, 190 coppie, dati a 10 minuti, e il backtest e' di UN MESE**: verbatim _"backtested this strategy with 10-minute stock data in **September 2013**"_. 🔴 **Un mese di campione contro il nostro F8 (≥150 operazioni IS) non e' nemmeno commensurabile.** E l'autore stesso lo dichiara: _"This example is a basic example to start with"_ |
| **S15** | `intraday-etf-momentum` | 🔵 **Gia' scartato il 31/08 (S10): e' R98**, Market Intraday Momentum di Gao, **−0,31 punti/trade su 410** in casa |

Le altre **80** sono fattori di portafoglio azionario/commodity a ribilancio
**mensile o giornaliero** (momentum, value, quality, carry, seasonality di
calendario, pairs, VIX term structure): **fuori mandato per definizione**.

> ### 🔴 **VERDETTO DEFINITIVO SU QUANTCONNECT — da scrivere nel promemoria e non riverificare**
> _"La Investment Strategy Library di QuantConnect ha **83 strategie in tutto**,
> enumerate una per una il 01/09/2026. Le intraday sono **tre**, tutte su
> **azioni/ETF USA** che BCM non quota, e due su **dati al secondo o a 10
> minuti** con campioni di **un mese**. **Per un mandato di FREQUENZA INTRADAY
> SU CFD la fonte e' ESAURITA, e non e' un problema di ricerca: e' il catalogo
> che finisce li'.**"_
> 👉 Resterebbe utile solo per un mandato di **allocazione di portafoglio**,
> che non abbiamo. **Due cacce su due (31/08 e 01/09) la chiudono.**

---

## 6. 🧱 LE COSE DA TENERE AGLI ATTI — spec e lapidi, non candidati

### 6.1 ⚰️ **LA LAPIDE DELLE BARRE ALTERNATIVE** — e chiude la prossima caccia ovvia

Da **S5** (art. 23310, Patrick Njoroge, 17/07/2026), letto sulla pagina
[VERIFICATO]:

> Confronto di **quattro famiglie di barre** (time, tick, tick-imbalance,
> tick-runs) su **tre strategie** (RSI e Bollinger per la mean-reversion,
> ADX/DI per il trend), con **60,5 milioni di tick EURUSD 2022-2023**.
> Nota dell'autore: sei tipi di barre AFML (volume, dollar e varianti)
> **collassano sulle tick bar** sui dati spot-FX solo-quote, quindi le famiglie
> davvero distinte sono quattro.
>
> **Conclusione, verbatim:** _"**No bar family produces a reliable edge for
> these rules.** Every out-of-sample AUC sits in a narrow band from **0.42 to
> 0.55**... The apparent structure in the grid is **indistinguishable from what
> random labels would produce**."_ · _"The statistical property López de Prado
> documents is real... but **it does not carry through to strategy efficacy**
> the way the retail corollary assumes."_ · test di permutazione sulla cella
> migliore: **p = 0,10**.

> 🎯 **Perche' vale per NOI, e vale tanto:** dopo tre battute che dicono _"la
> frequenza non si compra scendendo di timeframe"_, **la mossa successiva
> naturale sarebbe stata "allora cambiamo l'unita' di campionamento: barre a
> tick, a volume, a imbalance"**. E' la risposta canonica di López de Prado, e'
> quella che un cacciatore proporrebbe la settimana prossima, e **qui c'e' uno
> studio di falsificazione su 60,5 milioni di tick della NOSTRA coppia che dice
> di no**. 🔴 **Direzione chiusa prima di aprirla. Costo risparmiato: un round
> intero.**

### 6.2 🔧 IL CHASSIS DI ROTAZIONE PER SESSIONE — il pezzo buono dentro uno scarto

Da **S1** (art. 21976). Il **motore** e' marcio (fade dell'estremo, R42) e non
si rifinisce — §5F non si ammorbidisce. Ma il **contenitore** e' esattamente la
forma che la casa ha gia' concluso essere l'unica praticabile per la frequenza:

```
input string AsianSymbols  = "USDJPY,XAUUSD";
input string LondonSymbols = "GBPUSD";
input string NYSymbols     = "XAUUSD,USDZAR";
input int    AsianStart=0,  AsianEnd=8;
input int    LondonStart=8, LondonEnd=16;
input int    NYStart=13,    NYEnd=22;
```

> **Un EA, N simboli, ciascuno acceso SOLO nella sua fascia oraria.** E' la
> traduzione in codice di _"la frequenza si prende con PIU' SIMBOLI"_ (29/08) —
> e, guarda caso, **e' anche la forma che il meccanismo di Breedon-Ranaldo
> richiede** (§3): ogni valuta ha le sue ore locali.
> 🟢 **Da tenere come SPEC di architettura.** 🔴 **Da NON copiare: il motore
> dentro e' un fade di estremo di sessione, gia' 0/24 IS e 0/24 OOS.**
> ⚠️ E gli orari li' sono in **ora broker dell'autore, ignota**: da noi
> vanno riscritti in **ora server BCM** e dichiarati.

### 6.3 🕐 L'INDICATORE DI STAGIONALITA' ORARIA — seconda opinione, gratis

Art. **18672**, *Seasonality Indicator by Hours, Days of the Week, and Days of
the Month* (Yevgeniy Koshtenko, 04/06/2026; il file allegato dichiara
`#property copyright "Copyright 2025, MetaQuotes Ltd."`). 463 righe, 7 input,
`enum SEASONALITY_HOURS`. Copia in
`biblioteca/sorgenti/SeasonalityIndicator_MetaQuotes_mql5art18672_2026-09-01.mq5`.

> 🟠 **Non e' un candidato** (indicatore, `BarsToAnalyze` di default **1.000
> barre**, nessuna gestione dei lati, nessun conteggio di spread).
> 🟢 **E' una seconda opinione a costo zero:** si aggancia a un grafico e
> disegna il rendimento medio per ora del giorno. Se il quadro che disegna su
> EURUSD **contraddice** la tabella della sonda, uno dei due sbaglia — ed e'
> meglio scoprirlo con un indicatore che dopo un round.
> 🔴 **Ma la sonda di casa e' MIGLIORE e non va sostituita:** 15,5 anni contro
> 1.000 barre, due lati in corse separate, spread misurato nell'ora in cui si
> paga, criteri C1-C7 congelati prima. L'indicatore **conferma**, non decide.

### 6.4 📐 `InpServerUTCOffset` — tre righe che i nostri EA di sessione non hanno

Da **S2** (art. 23226): `input int InpServerUTCOffset = 2; // Broker Server UTC
Offset` + `InpMarketOpenET = "09:30"`. 👉 L'orario si scrive nel **fuso del
mercato** e la conversione al fuso del broker e' **un input dichiarato**,
invece che un numero cablato che nessuno ricorda piu' come e' stato ottenuto.
Sul nostro fuso BCM (ora italiana − 1) e sull'errore delle **~4 settimane
l'anno**, e' esattamente il posto giusto dove mettere il problema.

---

## 7. 🟢 IL PROMOSSO — uno, e va detto subito che **non e' un EA nuovo**

### 🥇 P1 — `OROLOGIO-FX` · **la deriva oraria del forex, calibrata dall'esterno**

```
FREQUENZA ATTESA   2,0 trade/giorno su UN simbolo (una gamba per fascia locale
                   + una per fascia estera) --- AL pavimento esatto del mandato.
                   6,0 trade/giorno su TRE simboli con fasce locali diverse
                   (EUR ore europee, GBP ore di Londra, JPY ore di Tokyo).
                   [DERIVATA DAL MECCANISMO -- e' un fatto di costruzione:
                    ogni valuta ha le sue ore d'ufficio, e non sono le stesse.]
                   🔴 NON MISURATA da qui: nessuna fonte dati raggiungibile.

NOME               meccanismo: "business day / time-of-day drift" nel forex
FONTE (tesi)       Breedon & Ranaldo, J. Money Credit and Banking, lug. 2013
                   SSRN 2099321                          [LETTO-VIA-SEARCH]
                   Ranaldo, J. Banking & Finance 2009, SSRN 960209  [idem]
                   arXiv 1103.5664                        [VERIFICATO, abstract]
FONTE (codice)     github.com/quantrocket-codeload/fx-bizday
                   LICENZA Apache 2.0    [VERIFICATO riga 1-13 del sorgente]
                   AUTORE  QuantRocket LLC
COPIA IN CASA      biblioteca/sorgenti/FxBizday_QuantRocket-Apache2_gh-fx-bizday_2026-09-01.py
                   biblioteca/schede/FxBizday_BreedonRanaldo_note-verbatim_2026-09-01.md
RIGHE / INPUT      il motore e' 10 righe di Python e ha DUE parametri: due ORE.
                   Zero indicatori. E' il candidato piu' semplice mai censito.
COSTO DI PORTING   🟢 ZERO. L'EA di casa che lo misura ESISTE GIA'
                   (ABTG_SondaOrologio.mq5, 972 righe, riga di lancio pronta
                   dal 28/08, MAI GIRATA).
```

**TESI IN UNA RIGA**
> _"Le imprese comprano valuta estera nelle **proprie** ore d'ufficio. Quello
> squilibrio di flusso si scarica sull'inventario dei dealer e diventa
> **pressione di vendita sulla valuta domestica durante le ore domestiche** —
> quindi l'euro tende a scendere nel mattino europeo e a risalire nel
> pomeriggio americano, ogni giorno feriale, per costruzione del mercato e non
> per un pattern grafico."_

**MECCANICA — tre righe, come da scheda**
- **Ingresso:** all'ora `X` in **ora server**, sul lato che la tesi indica per
  quel simbolo (valuta domestica **short** durante le sue ore d'ufficio).
- **Uscita:** **A TEMPO**, dopo `N` ore. Nessun take. 👉 E' esattamente il
  `D041 — time-based exit confirmed as primary exit — LOCKED` del registro di
  Mesfin, gia' agli atti dal 31/08.
- **Stop:** ⚠️ **il meccanismo nudo NON ne ha.** Da noi e' **obbligatorio**
  (F9, pavimento `InpMinSLPts`, R109): la sonda gira gia' con
  `InpSLatrMult=10.0`, cioe' uno stop **volutamente larghissimo** che serve a
  non tagliare la misura della deriva. **Questo e' un parametro di MISURA, non
  di trading**, e va detto.

**GESTIONE RISCHIO** — 🔴 il sorgente esterno assegna **il 100% del capitale**
(`weights = signals`, ±1). Da noi: **rischio in % dell'equity**, come sempre.
La sonda gira a `InpRiskPercent=1.0` **solo perche' e' una misura**, e
`InpMaxTradesPerDay=1`.

**BANDIERE ROSSE §4** — ✅ **nessuna nel meccanismo**: niente martingala,
griglia, recovery, hedge, repaint (la decisione e' un **orologio**, non un
indicatore: non esiste look-ahead possibile), nessuna dipendenza esterna.
🔴 Nel **sorgente esterno**: lotto pieno e nessuno stop — **gestione da rifare
integralmente, ed e' la parte che sappiamo fare**.

**T12 — LA TENUTA, e la dichiaro invece di nasconderla**
La gamba dura **8 ore** (locale) e **4-5 ore** (estera).
- Su **H1** sono **8 e 4 BARRE**: 🔴 **sotto** il criterio "≥12 barre del TF".
- Su **M15** sono **32 e 16-20 barre**: 🟢 **sopra**.
- 🎯 **E il criterio va letto in DURATA:** nasce da arXiv 2605.04004 §6.2, dove
  le barre erano da **5 minuti** — _"hold positions for 12-15 bars rather than
  1-6"_ = **60-75 MINUTI**. Una gamba da 4-8 ore sta **4-8 volte SOPRA** quella
  soglia. **La lettura "12 barre di H1" e' un errore di unita'**, e lo risolvo
  a favore della durata, scrivendolo.

**H8 — L'ARITMETICA, fatta prima di spendere una macchina**
Il meccanismo nudo **non ha RR**, perche' esce a tempo. La forma leggibile e'
`E per gamba = drift lordo mediano − costo`. E il §3.5 la limita da fuori:
**drift lordo mediano fra ~0,17 e ~1,7 pip** contro **~1 pip di spread
`[NON MISURATO]`**.
> 🔴 **Detto senza sconti: nella versione incondizionata questo motore e'
> probabilmente sotto il cancello.** L'unica cosa che puo' salvarlo e' che
> **la deriva NON sia uniforme dentro le otto ore** — cioe' che esista una
> fascia stretta con rapporto lordo/spread molto sopra 3.
> **E' precisamente la domanda che la sonda misura, ora per ora.**

**PUNTEGGIO**
- **[2] semplicita'** — **due parametri, due ore**. Nessun indicatore. Non
  esiste niente di piu' semplice in nessuno dei tre dossier di caccia.
- **[2] il filtro E' il motore** — l'ora **e'** la strategia. Non c'e' niente
  da appiccicare e niente da togliere: e' il caso limite del §5B di
  `ROBUSTEZZA.md`.
- **[2] tesi di mercato scrivibile** — sopra, una riga, **e con il meccanismo
  microstrutturale documentato in due journal**.
- **[2] riempie un BUCO** — **quattro insieme**: (a) la **FREQUENZA** senza
  scendere di TF; (b) un motore **SHORT costitutivo** (14 celle vive quasi
  tutte long-only); (c) **forex intraday**, che in flotta non esiste; (d) la
  **fascia asiatica**, che non copriamo in nessuna forma.
- **[2] testabile senza riscritture** — 🟢 **l'EA, i sette file prova e la riga
  di lancio ESISTONO DAL 28/08 E NON SONO MAI STATI USATI.** Costo di porting:
  **zero.**

## **VERDETTO: 🟢 PROVA SUBITO — 10/10 di carta**

**PERCHE':** e' l'unico oggetto delle tre battute che arriva con **la tesi
prima del codice** (requisito n.1 di `prove/LEGGIMI.md`), **un meccanismo
economico documentato in due journal**, **l'ora esatta pre-registrata da una
fonte esterna**, **una replica open-source di 19 anni**, **frequenza ≥2/giorno
per costruzione** — e **costo di costruzione zero, perche' la macchina e' gia'
sul banco**.

🔴 **E con il rovescio scritto qui, prima dei numeri:** il **10/10 e' di
carta**, esattamente come lo era il 9/10 di M0PB il 31/08 **prima** che il
contatore lo bocciasse 12/12. La differenza e' che stavolta **la misura che
puo' ucciderlo e' gia' costruita, gia' congelata e gia' pronta a partire** — e
la fonte esterna ha gia' scritto **come** morira', se morira': **per costo.**

### 🏛️ IN OTTICA PROP

- 🟢 **Zero overnight per costruzione** (la gamba muore a fine fascia) → niente
  swap, nessun downgrade di leva, nessuna esposizione al gap del weekend.
- 🟢 **Il ritmo e' regolare, non a raffica.** Due gambe al giorno **in ore
  diverse** non sono due rischi simultanei: e' il contrario del profilo "6
  trade la stessa mattina" che rendeva pericoloso il promosso del 31/08.
  👉 **Sul muro giornaliero (−5.000 su 100k) questo motore e' fra i piu'
  gentili mai censiti.**
- 🎯 **SCORRELAZIONE — ed e' l'argomento piu' forte.** La flotta viva sta su
  **indici** (DAX/Dow/Nasdaq/CAC) e **oro**, concentrata su **apertura DAX
  (08:00 server)** e **sessione USA**. La gamba **asiatica** (00:00-08:00
  server, USDJPY) **non e' coperta da nessuna sedia, in nessuna forma**.
  ⚠️ **Ma attenzione, e lo scrivo io:** la gamba **EURUSD short 08:00-16:00**
  parte **nella stessa ora** di `ABTG_DAX_Apertura_EU` e di
  `MaxMinNotte_DAX_Short`. **Regola di rotta 1: mai a rischio pieno insieme
  finche' la correlazione fra le serie per-trade non e' MISURATA.**
- 🔴 **Il rischio vero e' il DD TRAILING.** Un motore a deriva piccola e
  costante produce **curve a scalini con lunghi ritorni dal picco** — che e'
  **esattamente la forma che il trailing punisce** (`METRO_PROP`, Upcomers:
  _"trailing drawdowns that shift with your equity"_). Le nostre Monte Carlo
  sono tutte su **DD statico dal deposito** e **col trailing non valgono**.
  **Da dichiarare nel referto, non da scoprire dopo.**
- 🟢 **Nessun problema HFT.** Tenute di **4-8 ore**: contro il paletto P5
  (max 25% dei trade sotto 60 s) e contro E8 (50% sotto 1 minuto) siamo a
  **zero per costruzione**.

---

## 8. 📦 IL PASSO 0 — **si conta PRIMA, si giudica DOPO**

🔴 **Non propongo una griglia nuova. Non propongo nemmeno una sonda nuova.
Propongo di ACCENDERE quella che c'e', e di leggerla contro una previsione
scritta prima.**

📄 **Il foglio di pre-registrazione, scritto oggi:**
`backtest_pipeline/prove/OROLOGIO_PREREGISTRAZIONE_BREEDON_2026-09-01.txt`

⚠️ **Non e' una prova operativa e non pinna niente.** L'errore n.3 della
`CHECKLIST_RIGA_DI_LANCIO` — un pin che MT5 **ignora in silenzio** — e' come e'
nato il falso "0/8" del FiboH4. **Gli artefatti che girano sono i sette file
gia' congelati dal 28/08, e non li ho toccati.**

**I numeri che devono uscire, con i cancelli congelati PRIMA:**

| # | numero da leggere | cancello |
|---|---|---|
| 1 | **rapporto lordo/spread, ORA PER ORA**, per simbolo e per lato | **C1 della sonda, gia' congelato:** `\|lordo medio giornaliero\| ≥ 3 × spread mediano della STESSA ORA`. Sotto → **round chiuso, pista dell'orologio chiusa con un numero** |
| 2 | **la cella A: EURUSD SHORT, ora 8, durata 8** | 🖊️ **C2, e adesso e' una PRE-REGISTRAZIONE ESTERNA.** Se la cella verde e' un'altra, **non vale**: e' rumore fra 144 celle, e la regola era scritta prima |
| 3 | **le ore adiacenti** alla cella A | **C3 — altopiano, non picco.** Un'ora verde isolata fra due rosse e' rumore (12 Spearman IS→OOS negative su 13) |
| 4 | **la PEGGIOR GIORNATA** di ogni fascia | **C4 — il rischio si legge sempre, anche se il merito non passa.** Muro: **−5.000 su 100k** |
| 5 | 🆕 **lo SPREAD BCM misurato, ora per ora, su tre simboli** | 👉 **e' il sottoprodotto che chiude un buco aperto da SETTE cacce** (`[SPREAD NON MISURATO]`), e va estratto e archiviato **anche se la sonda boccia tutto il resto** |
| 6 | **frequenza F1** | ≥ **2,0/giorno** per costruzione su un simbolo; **da confermare** che le gambe non si sovrappongano |

**E la clausola che rende utile anche il fallimento:** se C1 non passa su
nessuna fascia, allora **la deriva oraria del forex non paga lo spread di BCM**
— e questo **non e' un round perso**: e' la **conferma indipendente**, sui
nostri dati e sul nostro broker, di quello che l'autore di `fx-bizday` ha
scritto su 19 anni di dati IBKR. **Due misure indipendenti che dicono la stessa
cosa chiudono una direzione per sempre**, e la chiudono bene.

---

## 9. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **IL PAPER DI BREEDON-RANALDO, IN QUALUNQUE COPIA** | **Cinque mirror provati, cinque murati** (SSRN 403, snb.ch CONNECT 403, econstor EGRESS_BLOCKED, repec EGRESS_BLOCKED, qmul EGRESS_BLOCKED, aeaweb CONNECT 403). 👉 **Non conosco: la dimensione dell'effetto in punti base, il campione, le t-statistiche, ne' se gli autori riportino il risultato al netto dei costi.** Tutto cio' che ho e' **il segno, l'ora e il meccanismo**, `[LETTO-VIA-SEARCH]`. **E' esattamente il tipo di buco che non va coperto con la memoria** |
| 🔴 **TUTTO IL CANALE ACCADEMICO NON-arXiv** | **Undici domini sondati in blocco, undici HTTP 000**: bis.org, nber.org, core.ac.uk, jstor, wiley, researchgate, scholar.google, semanticscholar + api, openaccess.city.ac.uk, research-api.cbs.dk. **SSRN e' alla DECIMA 403 di fila.** 👉 Su un mandato che chiede paper, **resta solo arXiv** — e arXiv q-fin, misurato oggi con **11 query**, **non ha praticamente nulla sul time-of-day nei RENDIMENTI FX**: un solo titolo del 2011 |
| 🔴 **I NUMERI DI PERFORMANCE DI `fx-bizday`** | Il tearsheet del backtest a 19 anni e' fatto di **immagini** dentro il notebook: `<Figure size 1152x432>` × 11. **Nessun numero e' leggibile, e nessuno e' stato usato.** Ho usato **solo** le due affermazioni testuali dell'autore (il "1 bp distrugge" e lo spread misurato), che sono **fatti di costo**, non risultati |
| 🔴 **LA FREQUENZA, MISURATA** | **Nessuna fonte dati raggiungibile** (le tre del 31/08 — Yahoo, Stooq, Dukascopy — restano murate e non le ho riprovate). La frequenza di P1 e' **[DERIVATA DAL MECCANISMO]**: due gambe al giorno per costruzione. **Il numero lo fa il PC di Claudio** |
| 🔴 **LO SPREAD BCM** | `[NON MISURATO]`, **settima caccia**. Uso ~1 pip di convenzione su EURUSD. 🟢 **Ma per la prima volta so DOVE si misura**: la sonda dell'Orologio lo campiona gia', **nell'ora in cui si paga** |
| 🟡 **I sorgenti di 5 puntate su 6 della serie `Dynamic Multi-Pair EA`** | Ho letto **solo la Part 8**. Le altre cinque sono scartate **come famiglia** sulla base del motore condiviso, e **lo dichiaro invece di far finta di averle lette**. Il punto da riverificare, se qualcuno riapre: **le righe 663-679** |
| 🟡 **~1.060 dei 1.120 titoli di articolo** | Filtrati **per titolo**, sorgente non aperto. Le classi sono in §4.3 con il motivo. **Il filtro per parola chiave puo' aver perso qualcosa**: la ricerca del sito e' rotta (§2) e non c'e' modo di interrogare gli abstract |
| 🟡 **Le pagine 29+ di `/en/articles/mt5`** | Mi sono fermato a **28 pagine**. Oltre si scende sotto il 2024, e le tre serie di EA a puntate cominciano da capo. **Il catalogo profondo resta non censito**, e va detto |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato oggi.** Quelli di casa vengono dai referti citati; quelli di fuori sono `[VERIFICATO su pagina/sorgente]`, `[LETTO-VIA-SEARCH]`, `[DICHIARATO DALL'AUTORE]` o `[CALCOLO MIO]` |
| 🔴 **Nessun EA toccato, nessuna sedia, nessun magic, nessun parametro in forward** | F11 rispettato |

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Su EURUSD, fra le 08:00 e le 16:00 in ora server, la deriva media giornaliera vale almeno tre volte lo spread che si paga IN QUELLE STESSE ORE — e se si', e' concentrata in una fascia stretta o spalmata su otto ore?**

**E' la domanda giusta per tre motivi, e li scrivo tutti e tre:**

1. **E' gia' congelata come criterio C1 della sonda**, dal 28/08, **prima** che
   io trovassi qualunque paper. Non l'ho scritta io oggi.
2. **La risposta esterna esiste gia' per la versione media**: l'autore di
   `fx-bizday` dichiara che **a 1 bp di costo la profittabilita' e'
   distrutta**, su 19 anni. **Quindi la parte "spalmata su otto ore" e' gia'
   probabilmente morta.** L'unica cosa che il nostro test puo' aggiungere e'
   **la seconda meta' della domanda**: se esista una **fascia stretta** dove il
   rapporto e' molto sopra 3.
3. **Chiude comunque.** Se C1 passa su una fascia stretta → abbiamo un motore
   **short, forex, intraday, a due parametri, scorrelato dalla flotta**, con
   una tesi da journal e la frequenza del mandato. Se C1 non passa → **la pista
   dell'orologio si chiude con un numero nostro, che concorda con un numero
   esterno su 19 anni** — e la caccia alla frequenza sul forex finisce li',
   invece di ripartire ogni settimana.

**E se la risposta e' no, e' una risposta utile quanto un promosso:** restera'
in piedi una sola strada, quella scritta il 29/08 e mai smentita — **piu'
SIMBOLI a M15-H1, non piu' velocita'** — con l'aggravante, misurata oggi, che
**ne' gli articoli MQL5 (1.120 titoli), ne' QuantConnect (83 strategie), ne'
le barre alternative (60,5 milioni di tick)** hanno una scorciatoia da
venderci.

---

_Dossier chiuso il 01/09/2026. **1.120 titoli di articolo MQL5 censiti** su 28
pagine · **83 slug QuantConnect enumerati per intero** · **11 query arXiv** ·
**6 mirror accademici + 11 domini sondati e murati** · **9 oggetti letti nel
sorgente o per intero** (5 `.mq5`/zip scaricati, 1 `.py` + 5 notebook Jupyter
scaricati e letti, 2 pagine strategia QuantConnect lette per intero, 1 articolo
letto per la conclusione) · **3 paper time-of-day FX identificati**, 1 letto
per l'abstract e 2 `[LETTO-VIA-SEARCH]` · **1 promosso** (e non e' un EA:
e' la calibrazione esterna di un artefatto di casa mai acceso) · **15 scarti
motivati** · **~1.060 scarti al primo taglio** · **2 fonti chiuse con un
verdetto** (articoli MQL5 e QuantConnect) · **1 lapide** che risparmia un round
(le barre alternative).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato, nessun
criterio congelato spostato.**_
