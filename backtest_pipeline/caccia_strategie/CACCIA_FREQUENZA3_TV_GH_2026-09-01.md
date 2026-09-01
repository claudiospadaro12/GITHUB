# 🏹 CACCIA FREQUENZA — **TERZA BATTUTA** · TradingView open source + GitHub — 01/09/2026

**Mandato (Claudio, 01/09/2026 mattina, testuale):** _"EA a TF bassi con
**2 TRADE O PIU' AL GIORNO**"_. **Il pavimento e' SALITO da 1 a 2.**

**Perimetro assegnato (per non sovrapporsi all'altro cacciatore, che batte
articoli MQL5 / QuantConnect / paper):** **TradingView open source + GitHub**
(repo MQL5/Pine con sorgente leggibile). Simboli: forex major, XAUUSD, indici.
TF: **M1-M15**.

---

## ⚡ IL RISULTATO IN QUATTRO RIGHE

> **Su 2 fonti sottoposte a controllo positivo (entrambe VIVE), 207 strategie
> TradingView uniche censite con 43 query di ricerca in 8 ondate, piu' 6 repo
> GitHub interrogati, sono arrivato al SORGENTE su 20 oggetti e li ho letti
> riga per riga (16 Pine scaricati integrali + 4 file `.mq5` da GitHub).
> NE PROMUOVO UNO.**
>
> 🥇 **Il promosso e' `DayFlow VWAP Relay — Majors` (© exlux, MPL 2.0, Pine v6,
> 135 righe, 13 input).** E' l'unico oggetto delle TRE battute in cui **il
> regime non FILTRA il motore: SCEGLIE QUALE MOTORE CORRE.** Un punteggio di
> espansione (deviazione del residuo dalla VWAP / deviazione del prezzo) decide
> se la giornata e' bilanciata — e allora si **fada** il residuo — o in
> espansione — e allora si **rompe** la banda. E' la forma `ABTG_EMA200` del
> §5B di `ROBUSTEZZA.md` (**30 celle su 30 a PASS pieno**), non la forma
> "filtro appiccicato" (**0 successi su 5**).
>
> 🔴 **E la cosa piu' importante che ho trovato NON e' il candidato: e' il
> motivo strutturale per cui potrebbe non morire come M0PB.** M0PB armava su
> `RSI(6) >= 90` — un **evento di CODA**, e la sonda del 31/08 l'ha misurato a
> **0,52 segnali/giorno** contro un pavimento di 1,00. DayFlow arma su
> `resid <= percentile_25(resid, 63)` — una soglia **AUTO-NORMALIZZANTE: il 25%
> delle barre la soddisfa PER COSTRUZIONE, su qualunque mercato e qualunque
> regime.** **E' l'unica ragione strutturale per cui vale la pena spendere una
> seconda sonda dopo il fallimento della prima.**
>
> ⚠️ **E il difetto lo scrivo io, in prima riga, perche' e' un criterio del
> mandato: L'AUTORE NON DICHIARA NESSUN NUMERO DI FREQUENZA.** La frequenza di
> questo candidato e' **[DERIVATA DAL CODICE], NON [DICHIARATA]** — vedi §5.4
> per la derivazione completa e §0 per la lettura del criterio che ho applicato.

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DI APRIRE UN SORGENTE

Presi dal mandato, non modificati, in ordine di peso.

| # | criterio | soglia |
|---|---|---|
| **1** | **FREQUENZA** | **>= 2,0 /giorno**, `[DICHIARATA]` o `[DERIVATA]`, etichettata |
| **2** | **GEOMETRIA PROPRIA** nel sorgente (TP/SL o regola d'uscita esplicita) | **RR < 0,70 = SCARTO PER ARITMETICA**, da `p >= 1,075/(RR+1)` (cancello H8, `FIRME_2026-08-31.md` FIRMA 2) |
| **3** | **TENUTA** | mediana **>= 12 barre** del suo TF (muro d'attrito arXiv 2605.04004 §6.2). Mai "decine di trade al minuto" |
| **4** | **LICENZA aperta + sorgente INTEGRALE letto** | mai promuovere da descrizione |
| **5** | **§4 non si ammorbidisce** | martingala / griglia / recovery / hedge / no-SL / SL virtuale / repaint = scarto immediato |
| **6** | **numeri d'autore** | si LEGGONO e **non entrano in nessun punteggio** |
| **P5** | **vincolo prop HFT** | **max 25% dei trade sotto 60 secondi** (`CONFIG_PROP_2026-08-31.md`, meta' del tetto E8) |

### 🔴 UNA TENSIONE NEL MANDATO, e come l'ho sciolta — dichiarata, non nascosta

L'intestazione del mandato dice **"2/giorno DICHIARATI **O** DERIVABILI DAL
CODICE"**. Il criterio 1, due righe sotto, dice **"dichiarata dall'autore **E**
riscontrabile nel codice ... un claim assente o vago = scarto"**.
**Sono due letture diverse, e su questo candidato danno risposte opposte.**

- Lettura **larga** (intestazione): DayFlow entra, con frequenza `[DERIVATA]`.
- Lettura **stretta** (criterio 1): DayFlow **esce**, e **la battuta chiude a
  ZERO promossi**.

👉 **Ho applicato la lettura LARGA e lo dichiaro qui**, perche' e'
l'enunciazione del pavimento di Claudio; ma **la decisione e' sua**, e con la
lettura stretta il verdetto di questo dossier e' _"guardati 207, nessuno
passa"_. Il resto del dossier regge in entrambi i casi: gli scarti sono
scarti comunque.

📌 **E vale comunque la lezione M0PB, che nessuna delle due letture cancella:
la frequenza DICHIARATA può mentire** (la pagina TradingView di M0PB parlava
di "alta frequenza"; la misura ha detto 0,52/giorno). **Quindi il promosso va
a sonda in ogni caso.**

---

## 1. 📕 IL CIMITERO, RILETTO PRIMA DI USCIRE

Letti per intero prima di aprire un browser: `CACCIA_FREQUENZA_2026-08-31.md`
(636 righe), `CACCIA_FREQUENZA2_2026-08-31.md` (781 righe),
`REGISTRO_TEST.md` (685 righe), `CONFIG_PROP_2026-08-31.md` §HFT + P5,
`PROMEMORIA_SBLOCCO_FONTI.md` (453 righe), `CACCIA_GITHUB_INDICI_2026-08-30.md`.

| famiglia caduta | verdetto misurato | quanti candidati mi ha ucciso oggi |
|---|---|---|
| **M0PB** (RSI impulso + EMA) | **0/12 alla sonda**, lato migliore **0,52 segn./giorno** | la lezione che ha guidato tutta la battuta |
| **EMA-cross nudi** (SuperWave, Chaos ×2) | Chaos: 1 cella su 105; il gate morde **al contrario** | **4** |
| **breakout / ORB** | **~210 celle a tick**, R45 **0/48**, R12 **48/48 negative OOS** | **6** (+13 al primo taglio) |
| **fade degli estremi** (R42) | **0/24 IS e 0/24 OOS** | **3** |
| **mean reversion a TF basso senza regime** (R60) | **12 celle su 12 in perdita** | **3** |
| **Bollinger / BreakingBand M15** (R108/R111) | **6 finestre su 6 rosse**, gradiente H1>M30>M15 monotono | **2** |
| **filtro appiccicato** (`ROBUSTEZZA.md` §5B) | **0 successi su 5** | **2** |
| **trend+pullback** = SupRev, spina dorsale (6 sedie vive) | doppione F5 | **2** |
| **SMC / OB / FVG** | costo di validazione > valore atteso | **2** |
| **RSI+EMA V8** (scheda 31/08) | scartato 31/08 | **1** |

---

## 2. 📡 CONTROLLO POSITIVO — misurato oggi, 01/09, prima di cercare

| fonte | HTTP | bersaglio noto verificato **oggi** | esito |
|---|---|---|---|
| **TradingView** `pubscripts-suggest-json` | **200** | query `london session` → **30.538 byte**, JSON con `scriptIdPart`, `access`, `agreeCount`, `imageUrl` coerenti | 🟢 **PASSA** |
| **TradingView** `pine-facade /get/` | **200** | **16 sorgenti** scaricati in chiaro, campo `source`, con `scriptName`/`created`/`scriptAccess` coerenti | 🟢 **PASSA** |
| **TradingView** pagina pubblica | **200** (dopo `-L`) | `script/muhhiXQs/` → **301** nudo, **200 con `-L`** su `.../muhhiXQs-DayFlow-VWAP-Relay-Forex-Majors-Strategy/`, 442.591 byte, `<title>` corretto | 🟢 **PASSA** |
| **GitHub** `raw.githubusercontent` | **200** | `n30dyn4m1c/crt-turtlesoup-ea/README.md`, 4.711 byte | 🟢 **PASSA** |
| **GitHub** `WebFetch` su pagina repo | **200** | 3 repo letti con stelle, licenza, README | 🟢 **PASSA** |
| **GitHub** `WebSearch` | ok | 4 query, URL veri e verificati a valle | 🟢 **PASSA** |

### 🔧 CORREZIONE TECNICA — aggiornamento al `PROMEMORIA_SBLOCCO_FONTI`

**Lo slug `imageUrl` da solo restituisce 301, non 200.** Il promemoria del
31/08 notte (§2) dice _"`tradingview.com/script/E6yr9CoN/` → 🟢 200"_.
**Misurato oggi: `script/muhhiXQs/` risponde 301 con 0 byte.** Serve `curl -L`,
e l'URL finale e' `script/<imageUrl>-<slug-titolo>/`.
👉 **Non e' un candidato perso, ma chi cita l'URL nudo nel dossier scrive un
link che redirige.** Costo se non lo sai: un "candidato non letto".

### ⛔ Canali NON riprovati (gia' misurati nulli il 31/08, due volte)

`api.github.com` (ricerca) · `papers.ssrn.com` · `forexfactory.com` ·
`query1.finance.yahoo.com` · `stooq.com` · `datafeed.dukascopy.com` ·
ricerca `?keyword=` del Code Base · topic GitHub (spam SEO).

👉 **Conseguenza, per la TERZA volta di fila: NESSUNA FREQUENZA E' STATA
MISURATA DA QUI.** Le tre fonti dati restano murate al CONNECT. **Il numero lo
fa il PC di Claudio.** E' il motivo per cui il PASSO 0 e' **una sonda di
conteggio, non una griglia**.

---

## 3. 📊 COSA HO SFOGLIATO

| fonte | quanto | censiti | letti nel SORGENTE |
|---|---|---|---|
| **TradingView** | **43 query** in 8 ondate (band/deviazione · VWAP forex-oro · struttura HH/LL · cap giornalieri · sessione FX · no-repaint · oro sessione · regime switch) | **207 strategie uniche**, di cui **~120 con `access=1`** | **16 Pine scaricati integrali** |
| **GitHub** | **4 `WebSearch` + 3 `WebFetch` + 12 `curl` su `raw`** | **~25 repo**, 6 aperti davvero | **4 `.mq5`** (1 letto per intero, 11 sondati per grep mirato) |

### 🎯 Gli angoli NUOVI del mandato, e cosa hanno reso

| angolo assegnato | resa |
|---|---|
| mean-reversion con **banda/deviazione** (non EMA-cross) | 🟡 tanti candidati, **tutti nella famiglia R42/R60/R108** — 8 scarti |
| **VWAP intraday su forex/oro** | 🟢 **ha prodotto il promosso.** Gli altri sono doppioni di `ABTG_VwapRevert` |
| **ORB/session-open su forex** | 🔴 **zero**: e' la famiglia chiusa da ~210 celle. Angolo che non andava riaperto, e lo dico |
| **multi-segnale per sessione con cap** | 🔴 **quasi zero su TradingView**: 8 query, 10 strategie in tutto. Il retail non scrive cap giornalieri (l'eccezione era LondonFx, gia' promosso il 31/08) |
| **pullback su struttura (HH/LL)** M5-M15 | 🔴 **4 candidati, 4 scarti**, e due per **codice rotto** (§4.2 S3, S9) |
| **oro intraday sessione EU/US** | 🟡 molti titoli, qualita' molto bassa (`v6`, `v19`, "15s", "$240k/order") |
| **GitHub: repo MQL5 con `.set`, filtrati per licenza** | 🔴 **zero promossi**, ma **un risultato definitivo** (§4.3) |

---

## 4. 🗑️ GLI SCARTATI — con la riga di codice che lo prova

### 4.1 🎯 IL RISULTATO PIU' UTILE DELLA BATTUTA — `geraked/metatrader5` si CHIUDE, ed e' misurato su 11 EA su 11

Il repo MQL5 **piu' grande e piu' serio di GitHub**: **625 stelle**, **MIT
verificata**, 11 EA su libreria condivisa `Include/EAUtils.mqh`, con video e
report di backtest per ognuno.

**Il 30/08 era stato lasciato 🟡 `IN CODA / SCARTO CON RISERVA`**
(`CACCIA_GITHUB_INDICI_2026-08-30.md` §99-118), sulla base di **UN solo file
letto** (`BBRSI.mq5`), con la nota _"si riapre SOLO se un giorno serve un
secondo motore BB-reversion su banco vergine"_.

🔴 **Oggi l'ho misurato su TUTTI E UNDICI, per grep dei default. Il risultato
chiude la porta.**

| default misurato | quanti EA su 11 |
|---|---:|
| `input bool Grid = true;` | 🔴 **11 su 11** |
| `input bool IgnoreSL = true;` | 🔴 **6 su 11** |

E la riga che lo prova, da `Experts/DHLAOS.mq5` (l'EA **piu' vicino al mio
mandato**: "Daily High/Low + Andean Oscillator **for scalping**"), righe 36-40,
verbatim [VERIFICATO]:

```mql5
input group "Strategy: Grid"
input bool   Grid = true;          // Grid Enable
input double GridVolMult = 1.1;    // Grid Volume Multiplier
input double GridTrailingStopLevel = 20;
input int    GridMaxLvl = 50;      // Grid Max Levels
```

E righe 30-31:

```mql5
input bool IgnoreSL = true;        // Ignore SL
input bool IgnoreTP = true;        // Ignore TP
```

> 🔴 **Griglia ACCESA di default, moltiplicatore di volume 1,1, CINQUANTA
> livelli, e stop loss e take profit IGNORATI di default.** E' il §4 quattro
> volte in cinque righe. _(Il 30/08 su `BBRSI` erano stati letti `GridMaxLvl=20`
> — qui sono **50**: il numero cambia da EA a EA, il difetto no.)_
>
> ➕ E c'e' anche `input bool Reverse = false; // Reverse Signal` (riga 25):
> **l'interruttore che ribalta la tesi**, gia' visto e scartato il 31/08
> (`Forex Daytrade T3 MA session`, S2). Un EA la cui direzione e' un parametro
> **non ha una tesi**.

**E i SEGNALI, indipendentemente dalla gestione, sono tutti doppioni di
famiglie gia' morte:** `BBRSI` = Bollinger+RSI (**R108/R111, 6 finestre su 6
rosse**); `3MAF`/`2MAAOS`/`3MACD`/`2MACDSTO` = incroci di medie e MACD
(**SuperWave / Chaos**); `NWERSIASF` = inviluppo Nadaraya-Watson (scartato
oggi anche su TradingView, §4.2 S11); `COT1` = dati **COT**, che **BCM non
quota**.

> ### ✅ VERDETTO DEFINITIVO, da scrivere una volta e non riaprire
> **`geraked/metatrader5` e' CHIUSO.** Non e' "in coda": **11 EA su 11 hanno la
> griglia accesa di default e 6 su 11 non mandano lo stop al broker.** La
> gestione e' esattamente cio' che butteremmo, i segnali sono doppioni di
> famiglie misurate morte. **La porta di rientro del 30/08 e' chiusa: non c'e'
> nessun "banco vergine" che salvi un motore BB-reversion gia' bocciato 6 volte
> su 6.**

### 4.2 TradingView — 16 Pine letti riga per riga, 15 scartati

| # | candidato · autore · id | la riga che lo prova |
|---|---|---|
| **S1** | **`Forex Master v4.0 (EUR/USD Mean-Reversion Algorithm)`** · Stable_Camel · `AIZqyS45` · **3.323 like** · Pine **v2**, 35 righe | 🔴 **E' `ABTG_BreakingBand` con un filtro ADX appiccicato.** Motore: `crossover(Price, Lower)` su banda `sma(20) ± 1,5σ` — **Bollinger fade**, famiglia **R108/R111 (6 finestre su 6 rosse)** + **R60 (12/12 in perdita)** + **R42 (0/24 IS e 0/24 OOS)**. Il gate `SmoothedADX1 < SmoothedADX2` e' **ADX appiccicato a un motore gia' tarato** = **R20, uno degli 0/5**. `Take_Profit = 500` / `Stop_Loss = 500` → **RR 1,00** (passa H8, ma su un motore morto). **Nessuna sessione, nessun cap, nessuna frequenza dichiarata.** Il like piu' alto della battuta e' anche il candidato piu' morto |
| **S2** | **`Keltner bounce from border. No repaint. V2`** · zelibobla · `mQKGzLMD` · 1.995 like · Pine v2, 47 righe | 🔴 **Tre difetti, uno dei quali e' un BUG DI DIREZIONE.** (a) banda = `sma(200) ± ATR(200) × **8**` — **otto ATR su periodo 200**: un tocco ogni molti mesi → **F1 fallita per costruzione di due ordini di grandezza**; (b) `closeOnEMATouch` e' **`false` di default** e non esiste `profit=` da nessuna parte → **nessun take profit**, si esce solo sullo stop in tick fissi; (c) 🔴 riga 43: `if(enterOnBorderTouchFromInside and crossover(price, bottom))` → `strategy.entry("SELL", **strategy.long**, ...)` — **l'ordine chiamato SELL viene aperto LONG.** Il "No repaint" del titolo e' vero e non serve a niente |
| **S3** | **`HIGHER HIGH LOWER LOW STRATEGY`** · Craig_Claussen · `JWsBrWBu` · 1.610 like · Pine v4, 30 righe | 🔴 **NESSUNO STOP, NESSUN TAKE, 100% DELL'EQUITY.** Il file contiene **due sole righe operative** (`strategy.entry("Long"...)` / `("Short"...)`) e **zero `strategy.exit`, zero `strategy.close`**: si esce solo sul segnale opposto. `default_qty_type=strategy.percent_of_equity, default_qty_value=100`. E il motore e' `price > highest(41)[1]` = **breakout di canale**, famiglia chiusa. §4 tre volte |
| **S4** | **`Higher High / Lower Low Strategy`** · FXEngineering · `ocw4jwpV` · 143 like · Pine v4, 40 righe | 🔴 **Nessuno stop, nessun take** (solo `strategy.order`, uscita sul giro dello stocastico) **+ FILTRO DATE ROTTO**: `month>=startMonth and year>=startYear` con `startMonth=10` → **la strategia opera solo da OTTOBRE a DICEMBRE di ogni anno**, e non "dal 10/2020 in poi" come l'autore crede. Un backtest costruito su un quarto dell'anno |
| **S5** | **`Adaptive Dual-Engine Strategy — Momentum + Mean Reversion [BT]`** · patelanishp · `f9xLZqpF` · 456 like · Pine v6, **513 righe, 78 input** | 🔴 **SCARTO PER ARITMETICA, ed e' netto.** Riga 110: `rewardRisk = input.float(**0.3**, "Reward/Risk Target")` con `atrStopMult = 3.0`. **RR = 0,30** → il cancello H8 chiede `p >= 1,075/1,30` = **82,7% di win rate**. **RR < 0,70 → si chiude senza corsa.** In piu': **78 input** contro il tetto di casa di ~15; strumenti **SPY/QQQ/AVGO** (azionario US, non nostri); e i tooltip contengono i numeri fittati dell'autore (_"~76% win on SPY 5-min"_) — **letti, non usati**. 🟡 Peccato, perche' l'ARCHITETTURA e' quella giusta (regime che sceglie il motore + parziale TP1 + time stop): **e' il controllo naturale del promosso, ma con la geometria capovolta** |
| **S6** | **`Trend Pullback System`** · mbedaiwi2 · `T88KNScx` · 229 like · Pine v6, 211 righe | 🔴 **IL CODICE E' ROTTO, e in un modo che nessun backtest rivela.** Le entrate si chiamano `"TKT Long"`/`"TKT Short"` (righe 115, 118); gli exit bracket dicono `strategy.exit(..., from_entry="**TRT** Long", ...)` (righe 128-129) — **un id che non esiste da nessuna parte nel file.** 🔴 **Stop e target non si attaccano MAI a nessuna posizione.** In piu' righe 7-13: un `crossover(sma(14), sma(28))` nudo lasciato nel template = **secondo blocco di entrate parallelo**, famiglia EMA-cross. E `useStopLong = na(longStop) ? **low** : longStop` — uno stop piazzato sul minimo della barra corrente |
| **S7** | **`Coral Trend Pullback Strategy (TradeIQ)`** · kevinmck100 · `kc6Itas8` · 1.169 like · Pine v5, 472 righe, **25 input** | 🟠 **SCARTO, e non per difetto — e' scritto benissimo** (`accountRiskPercent` VERO sulla distanza dello stop, RR 1,5 a input). 🔴 **Ma e' un doppione della spina dorsale (F5):** "trend line + pullback" **e' il `SupertrendReversal`**, che in flotta ha **6 sedie vive**. E il `confirmationInd` (ADX+DI, opzione `"None"` compresa) e' **filtro appiccicato dichiarato tale dall'autore** = 0/5. Frequenza: **nessun claim, nessuna sessione, nessun cap**, e un flip di trend-line strutturalmente vale **1 trade ogni parecchi giorni** → F1 fallita. 25 input > 15 |
| **S8** | **`Gold Scalping Strategy with Precise Entries`** · vishnush326 · `wO3Es23F` · 870 like · Pine v5, 40 righe | 🔴 **Tre condizioni necessarie in AND, tutte da famiglie cadute:** `(ema50 > ema200) **and** (rsi >= 45 and rsi <= 55) **and** bullish_engulfing **and** close > ema50`. E' **EMA-cross + RSI**, cioe' la scheda **`RSI+EMA V8` del 31/08** e la famiglia **M0PB**. La finestra RSI **45-55** e' larga 10 punti su 100: **F1 fallita per costruzione**, nessun claim, nessuna sessione. 🟡 Geometria decente (SL = ATR(14), TP = 2,0 USD fissi) ma **TP fisso in USD su oro** = non scala con la volatilita' |
| **S9** | **`Follow the Trend - Trade Pullbacks`** · SushilKothawade · `HJgxw5dy` · 1.053 like · Pine v4, 67 righe | 🔴 **NON E' UNA STRATEGIA: e' un indicatore travestito.** Dichiara `strategy(...)` ma **non contiene UN SOLO `strategy.entry`** — solo `plotshape`. **Zero ordini = niente da backtestare.** E il motore `calcx()` e' la ricorsione **Supertrend/HalfTrend**, doppione della spina dorsale. 🟢 Unica cosa buona: entrambi i `security()` con `lookahead = barmerge.lookahead_off` |
| **S10** | **`Mean Reversion and Trendfollowing`** · I11L · `LraBV2zv` · 266 like · **MPL 2.0**, Pine v5, 47 righe | 🔴 **NESSUNO STOP LOSS + LONG ONLY.** Uscite solo su `rsi2 > 80` o `close < sma200*0,95`; e `strategy.exit("Exit", **limit = close**)` = un ordine limite al prezzo di chiusura, **che puo' non riempirsi mai**. `qty = (equity/close) × factor` = 100% del nozionale. RSI(2) + SMA200 → **pochi trade al mese**, F1 fallita. 🟢 **Da tenere agli atti come SPEC:** l'architettura (`close < sma200` → motore mean-reversion, `close > sma200` → motore trend) e' **la stessa forma del promosso**, arrivata da un altro autore. Due conferme indipendenti della forma "il regime sceglie il motore" |
| **S11** | **`Nadaraya-Watson Envelope Strategy (Non-Repainting)`** · Julien_Exe · `HrZicISx` · 2.271 like · Pine v5, 77 righe | 🔴 **Nessuno stop:** solo `strategy.close(...)`, mai un `strategy.exit` con `stop=`. `default_qty_value=20` in percent-of-equity = nozionale, non rischio. E il motore e' **fade dell'inviluppo** = R42/R60. Il titolo rivendica "Non-Repainting", ma il difetto che lo squalifica e' un altro |
| **S12** | **`Gaussian Detrended Price Reversion Strategy`** · NantzOS · `CtCca3jD` · 422 like · Pine v5, 55 righe | 🔴 **Nessuno stop** (solo `strategy.close("Long")` / `("Short")`), `overlay=false`, e **fade di un oscillatore detrendizzato** = R42/R60. Nessuna sessione, nessun cap, nessun claim di frequenza |
| **S13** | **`ATR Mean Reversion`** · Bcullen175 · `O4t4zTd3` · 363 like · **MPL 2.0**, Pine v5, 43 righe | 🔴 **STOP VIRTUALE + LONG ONLY.** `stopCondition = strategy.position_size > 0 and low < stopPrice` seguito da `strategy.close(...)`: lo stop **non va al broker**, si esce **all'apertura della barra dopo** — §4, ed e' il difetto che sui gap costa il doppio. `percent_of_equity 100`. Motore `low < open − ATR(10)` = **fade** (R42 0/24). Nessuno short → viola la regola dei due lati (25/08) |
| **S14** | **`XAUUSD STRATEGY 10MIN`** · UnknownUnicorn88398174 · `LxrgnsTO` · 587 like · Pine v5, 124 righe | 🔴 **DUE difetti gravi.** (a) `buyCondition = (macdBuy **or** rsiOversold **or** close < lowerBand)` — **tre famiglie cadute in OR**: un OR di tre condizioni larghe spara quasi ogni barra e **collassa** (stessa malattia dell'`ICE` scartato il 31/08). (b) 🔴 riga 49: `strategy.entry("Buy", strategy.long, **stop**=buyPrice − stopLoss, **limit**=buyPrice + takeProfit)` — in Pine `stop=` e `limit=` dentro `strategy.entry` sono **prezzi dell'ordine DI INGRESSO, non bracket di uscita**. **L'autore crede di aver messo SL e TP e non ne ha messo nessuno dei due** |
| **S15** | **`TrendShift \| Supertrend + ADX Regime-Adaptive`** · blitz_locked · `TbK1rB5B` · 506 like | 🔴 **Scartato al titolo+scheda, e lo dichiaro** (sorgente non aperto): **Supertrend = spina dorsale (F5)** e **ADX = R20, uno degli 0/5 del filtro appiccicato**. Non serve aprirlo per sapere che e' entrambe le cose |

### 4.3 GitHub — 6 repo aperti, 6 scarti

| # | repo · licenza · stelle | motivo |
|---|---|---|
| **G1** | `geraked/metatrader5` · **MIT** · **625** | 🔴 **§4.1 — CHIUSO. `Grid=true` di default su 11 EA su 11; `IgnoreSL=true` su 6 su 11** |
| **G2** | `elrizwiraswara/nyao_scalper_mt5` · **BSD-3** · **146** | 🔴 **Lo dichiara l'autore stesso nel README:** la funzione `Hedge Chain Recovery` **moltiplica il lotto** quando inverte posizioni in perdita, ed e' descritta come portatrice di _"genuine ruin risk"_. In piu': **basket stop con stacking multi-posizione** (griglia) e **sistema di re-ingresso su stop-loss VIRTUALE**. §4 tre volte. E nessuna frequenza dichiarata (solo "Very High"/"Low" per profilo) |
| **G3** | `zharfanzahisham/MQL5-Expert-Advisors` · **GPL-3.0** · **6** | 🔴 **L'autore scrive nel README: _"These bots are not consistently profitable and you SHOULD NOT use it with real money"_**, e definisce il repo in fase di ricerca iniziale. Nessun TF, nessun simbolo, nessuna frequenza dichiarata. I motori (`NYR50`, `TaimaScalperV1` su FVG) sono **ICT/SMC**, classe gia' scartata per costo di validazione > valore atteso |
| **G4** | `coler07/mql5-format` · — | 🔴 **Martingala/Griglia dichiarata nella descrizione del repo.** §4 dal titolo |
| **G5** | `abiodunaremu/openea` · MIT | 🔴 **Dipendenza esterna non risolvibile:** l'EA opera **su segnali del servizio FxChartAI**. Nessun segnale = nessun backtest. E i TF dichiarati sono **M10/H1**, fuori dal perimetro M1-M15 |
| **G6** | `Michael-Ishak/MQL5-XAUUSD-Trading-Expert-Advisor` · — | 🔴 Il repo vende **"backtest results over the last 10 years"** — cioe' esattamente i numeri d'autore che non pesano. Nessuna frequenza dichiarata, nessuna licenza permissiva visibile |

_(Gia' scartati il 30/08 e **non ricontrollati**: `yulz008/GOLD_ORB`,
`sajidmahamud835/grid-master-pro-mt5-ea`, `pipbolt/experts`,
`santiago-cruzlopez/MQL5`, `EarnForex/*`, `TyphooN-/*`,
`llihcchill/*`, `GeneralTradingSarl/*`, `raracraz/*`, `NadirAli*`.)_

### 4.4 Scartati al PRIMO TAGLIO (titolo/scheda, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---:|---|
| **cripto** (BTC/ETH/SOL/LINKUSDT, MVRV ZScore, `[3Commas] Grid Bot`, extradestrategy BTCUSD ×3) | **~34** | 🔴 fuori strumento: BCM non li quota / non sono nel mandato |
| **famiglia breakout / ORB** (`ORB Pro Session Breakout Scalper`, `Session Breakout Scalper Trading Bot` 1.698 like, `[STRATEGY][RS]Open Session Breakout Trader` 2.660, `Pro Trading Art Open Range Breakout`, `Breakout Scalper (Session)`, `Session Opening Range Breakout (ORBO)`, `Gold NY ORB v19`, `Gold NY Open ORB v11`, `Gold Asia Session Breakout`, `NQ Scalping ORB + VWAP Bias`, `Gold - First 5m Candle NY Session`, `IU Range Trading`, `Range Trading Strategy`) | **13** | 🔴 **F4: famiglia chiusa da ~210 celle a tick** (R45 **0/48** proprio su GBPUSD/EURUSD/XAUUSD, R12 48/48 negative OOS). **L'angolo "ORB su forex" del mandato cade qui**, e va detto invece di riaprirlo |
| **doppioni VWAP** (`VWAP-RSI Scalper FINAL v1`, `Clean VWAP ZL Scalper`, `VWAP + EMA9/EMA21 Pullback Scalper`, `Dwaggy Scalping Trio`, `VWAP Mean Reversion Strategy Range Bound Forex RSI Volume`, `Long only strategy VWAP with BB and Golden Cross`, `Dynamic Swing Anchored VWAP STRAT` 2.584 like, `NQ Scalping VWAP Mean Reversion`, `Full Swing Gold Vwap Macd SMO`) | **9** | 🔴 **F5**: doppioni di `ABTG_VwapRevert` (gia' scritto, PASSO 0 preparato, mai girato). L'ultimo usa **il volume su forex** = tick volume, inaffidabile (regola Paolo) |
| **DCA / griglia / incremental entry** (`DCA Strategy with Mean Reversion and Bollinger Band`, `Mean Reversion with Incremental Entry by HedgerLabs`, `Tomukas Wave VWAP DCA Scalper PRO`, `Hulk Strategy x35 Leverage`) | **4** | 🔴 **§4 dal titolo**: averaging / griglia / leva x35 |
| **Keltner / banda fade** (`Keltner Channel - Trend Based` 2.483, `Ichimoku Keltner`, `Optimized Keltner Channels SL/TP for BTC`, `Keltner Channel Backtest`, `Keltner Channel [LINKUSDT] 1H`, `Multi-Band Comparison (CRYPTO)`) | **6** | 🔴 R42 / R60 / R108, oppure fuori strumento |
| **mean reversion generici senza sessione** (`Mean Reversion Pro [tradeviZion]`, `Mean Reversion Strategy v2 [KL]`, `RSI Mean Reversion` ×2, `Moving Average Mean Reversion`, `EMA Mean Reversion`, `Mean Reversion by KrisWaters`, `Mean-Reversion Swing Trading v1`, `Mean Reversion V-F`, `Jaws Mean Reversion`, `Bollinger Bands Mean Reversion using RSI`) | **11** | 🔴 R60 (**12/12 in perdita**) + nessun claim di frequenza + nessuna finestra di sessione |
| **giornalieri / stagionali / swing** (`ETF 3-Day Reversion`, `Gap Reversion`, `14/28 Day SMA Divergence`, `NoNonsense Forex high timeframe`, `Generation 6 Massive Trend Following for Gold`, `SVT 30M Options Swing`, `RSI Strategy EUR/USD 1H 700%`) | **7** | 🔴 **F1 fallita per definizione**: TF sopra M15 o ribilancio giornaliero |
| **"vN" / marketing** (`EURUSD $300 Sniper v8.7` gia' scartato 31/08, `Modular Range-Trading V9.2`, `Customizable OCC Non Repainting Scalper Bot v7.0b`, `Customizable Non-Repainting HTF MACD MFI Scalper Bot v2`, `XAUUSD 5m — NY Supertrend+RSI Optimizer (1:2 RR) — $240k/order`, `Micro Rejection Scalping v6 - XAUUSD 15s`, `WOW no repainting and no security() call! 100% real results!`, `the Father, the Son, and the Holy Spirit`) | **8** | 🔴 il numero di versione **e' il conteggio dei giri di taratura**; `15s` viola P5 (HFT); `$240k/order` e `100% real results` sono claim di performance |
| **indicatori/attrezzi indicizzati come strategie** (`TradingView Alerts to MT4 MT5` 7.603 like, `Table to filter trades per day`, `Understanding order sizes`, `Trading range display with Box`, `Strategy Test - Cancel Limit Order and Position Sizing`, `Non-Repainting Renko Emulation`) | **6** | 🔴 zero ingressi o zero edge: **niente da backtestare** |
| **azionario indiano / FCPO / altro fuori strumento** (NIFTY, BANKNIFTY, `FCPO Session-Based Momentum Scalper`, `SPX Scalper`, `ES Multi-Timeframe SMC`, `NQ Scalper`, `Albtrader-NQ/BTC/Gold`, `Dskyz (DAFE) AI Adaptive Regime` ×2) | **~12** | 🔴 strumenti che BCM non quota, oppure "AI" senza meccanica leggibile |
| **multi-indicatore in AND** (`MULTIPLE TIME-FRAME STRATEGY(TREND, MOMENTUM, ENTRY)` 1.721, `Ichimoku Kinko Hyo Cloud + QQE`, `Ichimoku no offset no repaint`, `Multi Supertrend with no-repaint HTF`, `Heikin/Kaufman Non-Repaint`, `DRSI DMA Scalping`, `ATR_RSI_Strategy v2`, `Heikin Ashi EMA v5`, `RSI versus SMA`, `W%R Pullback+EMA Trend`, `adx efi 50 ema channel`, `Trend Surge with Pullback Filter`, `Axis-Pro System`, `MACD Crossover trend`, `MACD Volume Strategy for XAUUSD`, `Gravity Trend | ADX`, `PowerTrend Pro Gold`, `EMA50 for Gold TF 15M`, `KD The Scalper`, `Sniper Scalping Bot 15M`, `Ultimate Scalping Strategy v2`, `Gold/Spread Algo`, `Gold Scalping BOS & CHoCH`, `XAUUSD Scalping AGRESIV`, `XAUUSD 1-Minute Scalping`, `XAUUSD 1M SCALP BY ELIRAN`, `Bot Scalping XAUUSD`, `Advanced Gold Scalping with RSI Divergence`, `Fx_Papii Gold & EUR/USD`, `USDJPY Fair Value Gap + Session`, `EUR/USD Multi-Layer Statistical Regression`, `EUR/USD 45 MIN FinexBOT`, `Estrategy EURUSD M3 Scalping`, `Adaptive Regime Momentum [JOAT]`, `Premarket/altri`) | **~60** | 🔴 **"cinque indicatori in AND" = la tesi dentro il menu**, gia' caduta quattro volte (S17/S18 del 28/08, S15 di oggi). Piu': M1/M3 = **capitolo chiuso a tick** (_"trappola di costo strutturale"_), e `USDJPY Only Strategy` **gia' letto e scartato il 31/08** (S1) |

---

## 5. 🟢 IL PROMOSSO — uno solo

### 🥇 P1 — `DayFlow VWAP Relay — Majors` — **il punteggio di espansione SCEGLIE il motore: fade nella giornata bilanciata, breakout nella giornata in espansione**

```
FREQUENZA ATTESA   ~3-5 SEGNALI ESEGUIBILI/GIORNO a M5   <-- PRIMO CAMPO
                   ~1,6/giorno a M15 (SOTTO il pavimento nuovo)
                   [DERIVATA DAL CODICE -- NON dichiarata dall'autore,
                    NON misurata da noi. Derivazione completa in 5.4.]
                   🔴 L'AUTORE NON SCRIVE NESSUN NUMERO DI FREQUENZA.
                      Ho letto la pagina intera: descrive l'EFFETTO dei
                      parametri sul conteggio, mai un valore. E dichiara
                      esplicitamente "No performance claims".

NOME               DayFlow VWAP Relay Forex Majors Strategy
                   (scriptName interno: "DayFlow VWAP Relay -- Majors")
FONTE / URL        https://www.tradingview.com/script/muhhiXQs-DayFlow-VWAP-Relay-Forex-Majors-Strategy/
                   sorgente scaricato integrale da pine-facade /get/ (campo "source")
AUTORE / DATA      (c) exlux -- created 2025-10-24, aggiornato 2025-11-03  [VERIFICATO]
POPOLARITA'        111 "agree", 3.755 visualizzazioni  [VERIFICATO]
ACCESSO            access=1 / open_no_auth  [VERIFICATO]
LICENZA            Mozilla Public License 2.0  [VERIFICATO, riga 1 del sorgente]
RIGHE / INPUT      135 righe Pine v6 --- 13 input (di cui 2 sono solo "View")
                   -> 11 input veri, sotto il tetto di casa di ~15
COPIA IN CASA      caccia_strategie/biblioteca/sorgenti/
                   DayFlowVwapRelayMajors_exlux-MPL2_tvmuhhiXQs_2026-09-01.pine
```

#### 5.1 🧭 TESI IN UNA RIGA

> _"La VWAP ancorata al giorno e' il prezzo che il flusso ha davvero pagato, e
> la **distanza** da quella VWAP descrive la giornata meglio del prezzo: se il
> residuo si muove poco rispetto al prezzo la giornata e' **bilanciata** e gli
> estremi del residuo tornano indietro; se il residuo si muove molto la
> giornata sta **espandendo** e le rotture della banda proseguono. Non e' il
> segnale a decidere — **e' il regime a decidere quale segnale corre.**"_

#### 5.2 ⚙️ MECCANICA — letta riga per riga, non dalla descrizione

1. **L'ancora (righe 66-67):** `anchor_daily = timeframe.change("1D")`;
   `[vwap_d, vup, vdn] = ta.vwap(hlc3, anchor_daily, stdev_mult)`.
   VWAP **ri-ancorata ogni giorno**, con bande a deviazione standard.
2. **Il residuo (riga 69):** `resid = close - vwap_d`. **E' la variabile di
   stato di tutta la strategia**, non il prezzo.
3. **🎯 L'ARBITRO (riga 72):**
   `expansion = ta.stdev(resid, 63) / ta.stdev(close, 63)`
   → `balanced_day = expansion < 0,65` · `trend_day = expansion >= 0,65`.
   **Quanta parte della varianza del prezzo e' "allontanamento dalla VWAP".**
4. **La posizione (righe 76-77):** `res_hi`/`res_lo` = **percentili 75 e 25 del
   residuo su 63 barre**. 🔴 **Nota bene: e' un PERCENTILE, non una soglia
   fissa** — vedi §5.4, e' il cuore dell'argomento sulla frequenza.
5. **Il gate di micro-flusso (righe 51-63, 79-80):** legge le barre **M1
   dentro la barra corrente** (`request.security_lower_tf`), conta up meno down
   normalizzati a −1..+1, e **scarta esplicitamente l'elemento piu' fresco**
   (riga 56: `int last = math.max(1, n - 1)  // exclude freshest element`).
   👉 **E' una precauzione anti-lookahead scritta a mano dall'autore.**
6. **I quattro segnali (righe 94-97), simmetrici e mutuamente esclusivi per giornata:**
   ```pine
   long_fade   = balanced_day and resid <= res_lo and mf >  micro_gate and in_sess and cool_ok
   short_fade  = balanced_day and resid >= res_hi and mf < -micro_gate and in_sess and cool_ok
   long_break  = trend_day    and close > vup and v_slope > 0 and mf >  micro_gate and in_sess and cool_ok
   short_break = trend_day    and close < vdn and v_slope < 0 and mf < -micro_gate and in_sess and cool_ok
   ```
7. **La sessione (righe 37, 82):** `input.session("0700-1700", "Trade window UTC")`.
8. **Il cooldown (righe 43, 84-85):** 10 barre dopo ogni chiusura.
9. **🎯 LA GEOMETRIA (righe 41-42, 103-106):**
   ```pine
   sl_atr = input.float(1.2, "Stop ATR x")
   tp_atr = input.float(1.8, "Target ATR x")
   atr = ta.atr(atr_len)
   loss_ticks   = to_ticks(atr * sl_atr)
   profit_ticks = to_ticks(atr * tp_atr)
   ```
   → **RR = 1,8 / 1,2 = 1,50 ESATTO**, e **non dipende dall'ATR** (si
   semplifica): e' 1,50 su qualunque simbolo e qualunque timeframe.
   **Stop e take in ATR, mai in punti fissi** — il metro di casa.

#### 5.3 🚨 BANDIERE ROSSE §4 — ✅ NESSUNA NEL MOTORE, verificato riga per riga

Niente martingala, niente griglia, niente averaging (`pyramiding=0`, riga 7),
niente hedge, niente recovery, **stop sempre presente** (`loss=loss_ticks` in
entrambi i rami), **decisione su barra chiusa** (`calc_on_every_tick=false` +
`process_orders_on_close=true`, righe 12-13), nessun `#import`, nessun
`WebRequest`, nessun `iCustom`, nessuna dipendenza da simboli esterni.

#### 5.4 🎯 LA FREQUENZA — la derivazione per intero, perche' sia falsificabile

**E' il numero su cui si regge la promozione, e l'autore non lo fornisce.**
Quindi lo derivo, e lo scrivo in modo che si possa smontare:

| passo | M5 | M15 |
|---|---:|---:|
| finestra 0700-1700 UTC = 10 ore → barre/giorno | **120** | **40** |
| condizione di posizione `resid <= percentile_25(resid,63)` | **~25%** (per costruzione) | **~25%** |
| gate `mf > 0,20` sotto random walk | **~31%** | **~17%** |
| prodotto → segnali **GREZZI**/giorno/lato | **~9,4** | **~1,7** |
| soffitto **ESEGUIBILI** = barre/gg ÷ (tenuta 15 + cooldown 10) | **~4,8** | **~1,6** |

> ### 🔬 IL PUNTO CHE VALE PIU' DEL CANDIDATO
> **M0PB armava su un evento di CODA** (`RSI(6) >= 90`): quanto spesso capiti
> dipende dalla distribuzione, e la sonda del 31/08 l'ha misurato a **0,52
> segnali/giorno** contro un pavimento di 1,00 — **0/12 celle**.
> **DayFlow arma su un PERCENTILE** (`resid <= percentile_25(resid, 63)`):
> **il 25% delle ultime 63 barre lo soddisfa PER DEFINIZIONE**, su qualunque
> mercato, in qualunque regime, con qualunque volatilita'.
>
> 👉 **Questa e' l'UNICA ragione strutturale per cui vale la pena spendere una
> seconda sonda dopo che la prima ha ucciso il candidato precedente.** Ed e' una
> tesi FALSIFICABILE: se anche il percentile collassa sotto 2/giorno, allora
> l'argomento "percentile invece di coda" e' morto, e vale per ogni caccia
> futura.

> ### 🔴 E LA CONSEGUENZA SCOMODA, congelata PRIMA della misura
> **A M15 — il timeframe della demo dell'autore — il candidato NON dovrebbe
> raggiungere il pavimento nuovo di 2/giorno (~1,6).** Il pavimento salito da 1
> a 2 **sposta il bersaglio su M5**. Se la misura dice il contrario su M15, la
> mia derivazione e' sbagliata e va scritto.

#### 5.5 🔧 IL RILIEVO TECNICO — `micro_span` e' TRONCATO IN SILENZIO a M5

Trovato leggendo il sorgente, **non la descrizione**. `request.security_lower_tf`
restituisce **solo le barre M1 contenute nella barra corrente**:

| TF | barre M1 disponibili | confronti dopo l'esclusione della piu' fresca | `micro_span=10` e' |
|---|---:|---:|---|
| **M5** | 5 | **4** | 🔴 **troncato in silenzio** |
| **M15** | 15 | **10** | 🟢 onorato |

**Tre conseguenze, tutte dichiarate nel file prova:**
1. **A M5 il "micro flow" non e' una conferma da finestra piu' larga: e' la
   FORMA DELLA CANDELA DI SEGNALE.** E' un filtro **diverso**, non lo stesso
   filtro piu' veloce.
2. **La granularita' cambia la SEVERITA' del gate:** con 4 confronti
   `mf > 0,20` significa `mf >= 0,50`; con 10 confronti significa `mf >= 0,40`.
   **Il gate e' PIU' LARGO a M5** — ed e' il motivo del 31% contro 17%.
3. **Quindi M5 e M15 non sono lo stesso motore a due velocita'**, e nel porting
   MQL5 il parametro va reso esplicito **in MINUTI**, non in barre, altrimenti
   si eredita un troncamento silenzioso.

#### 5.6 🧮 IL CANCELLO H8 — l'aritmetica fatta PRIMA di spendere una macchina

Geometria **letta nel sorgente**: rischio `1,2 × ATR(14)`, premio
`1,8 × ATR(14)` → **RR lordo = 1,50**. 🟢 **Sopra 0,70: NON e' uno scarto per
aritmetica.** Con `p >= 1,075/(RR+1)`:

| scenario | RR netto | **win rate necessario** |
|---|---:|---:|
| geometria pura (nessun costo) | 1,50 | **43,0%** |
| **EURUSD M15** (ATR≈10 pip → SL 12 / TP 18) a 1,0 pip di costo | 1,31 | **46,5%** |
| **EURUSD M5** (ATR≈5 pip → SL 6 / TP 9) a 1,0 pip di costo | 1,14 | **50,2%** |
| **XAUUSD M15** (ATR≈3,0 USD → SL 3,6 / TP 5,4) a 0,30 USD | 1,31 | **46,5%** |

> 🎯 **E qui c'e' LA TENSIONE che questa battuta ha scoperto, ed e' il
> contributo tecnico del dossier:**
> - **M5 da' la FREQUENZA (~4,8/giorno) ma assottiglia la GEOMETRIA** (SL da 6
>   pip: il costo si mangia il 17% del rischio, e il win rate necessario sale
>   dal 43% al 50,2%) **e degrada il GATE** (§5.5).
> - **M15 conserva geometria e gate ma non arriva al pavimento** (~1,6/giorno).
>
> 👉 **Il pavimento nuovo di Claudio e la qualita' della geometria tirano in
> direzioni opposte, e il punto d'incontro non si indovina: si misura.**
> 🥇 **Ed e' esattamente per questo che la gamba XAUUSD e' la piu' promettente
> del PASSO 0: sull'oro l'ATR in USD vale molte volte lo spread, quindi si puo'
> scendere a M5 per la frequenza SENZA che il costo divori il rischio.**

#### 5.7 💰 F2 — LA TAGLIA, e il cartello che si ripete da sette cacce

TP = `1,8 × ATR(14)`, quindi **strutturale**, non fisso:

| simbolo / TF | TP tipico | spread di riferimento | rapporto | F2 (>= 3×) |
|---|---:|---:|---:|---|
| EURUSD M15 | ~18 pip | ~1,0 pip | **18×** | 🟢 passa |
| EURUSD M5 | ~9 pip | ~1,0 pip | **9×** | 🟢 passa |
| XAUUSD M15 | ~5,4 USD | ~0,30 USD | **18×** | 🟢 passa |

🔴 **Tutti gli spread qui sopra sono `[SPREAD NON MISURATO]`**: sono convenzioni
di mercato. **Lo spread BCM non esiste in repo, ne' sui major ne' sull'oro.**
Il *RealCost Spread P95 Logger* (Code Base **74148**) e' promosso dal **23/08** e
**mai usato**: **e' la SETTIMA caccia che lo scrive.**

#### 5.8 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**🟢 DA TENERE (il motore):** il residuo dalla VWAP come variabile di stato; il
**punteggio di espansione come ARBITRO fra due motori**; i **percentili** al
posto delle soglie fisse; il gate di micro-flusso **con l'esclusione della
barra piu' fresca**; stop e take **in ATR**; la finestra di sessione; il
cooldown; `pyramiding=0`; la simmetria perfetta dei due lati; la decisione su
**barra chiusa**.

**🔧 DA RIFARE (la gestione — la parte che sappiamo fare):**

| difetto, con la riga | perche' morde | cosa ci mettiamo |
|---|---|---|
| riga 9: `default_qty_type=strategy.percent_of_equity, default_qty_value=3` | **3% del NOZIONALE, non del rischio.** Non scalabile a 100k, non confrontabile | **rischio in % dell'equity** sulla distanza dello stop (0,65%) |
| riga 14: `margin_long=0, margin_short=0` | **leva infinita: il tester non puo' MAI rifiutare un ordine** → la curva di equity pubblicata **non vale niente** | irrilevante per noi (non usiamo numeri d'autore), **ma va dichiarato** |
| **nessun cap giornaliero** | un motore da 4-5 trade/giorno concentra le perdite nella stessa sessione | **`InpMaxTradesPerDay` DAL PRIMO ROUND**, tagliato sul massimo misurato dalla sonda |
| **nessun flat di fine sessione** | il muro giornaliero prop si legge solo se la giornata chiude piatta | **flat in ORA SERVER** |
| riga 82: `time(timeframe.period, sess_str)` **senza argomento di fuso** | il fuso e' quello dello **scambio del simbolo** = **[INCERTO]** su un feed FX | **l'ora non si converte a tavolino: si SWEEPA** (2 celle), e si verifica sull'orologio del server |
| nessun pavimento SL | R109 | **`InpMinSLPts` obbligatorio** |
| nessun filtro di spread | R55 | **spread come % dello stop**, non in punti |
| nessun parziale / breakeven | — | **parziale 1R + breakeven + runner**. ⚠️ **NON nel primo round**: prima si misura il motore nudo |
| nessun `OnTester`, nessun magic | il driver non parte | obbligatori |

#### 5.9 🕳️ IL BUCO CHE RIEMPIE — e l'adiacenza, dichiarata da me

🟢 **Il buco vero: in flotta NON esiste UN SOLO motore in cui il REGIME SCEGLIE
IL MOTORE.** Abbiamo gate che **filtrano** (Supertrend, correlazione S&P, slope
VWAP) — e il §5B dice che i filtri appiccicati fanno **0 successi su 5**.
Abbiamo **un solo** caso di filtro costitutivo (`ABTG_EMA200` Dow, R29,
**30 celle su 30**). **DayFlow e' della seconda specie.**

🟠 **E l'adiacenza la nomino io, perche' e' forte e va scritta prima che la
trovi Claudio:**

| gamba di DayFlow | cosa le somiglia in casa | stato di quella cosa |
|---|---|---|
| **fade** del residuo dalla VWAP | `ABTG_VwapRevert` (banda VWAP + candela di rifiuto, DAX M15) | **scritto, PASSO 0 preparato, MAI GIRATO** |
| **breakout** della banda | `ABTG_OutOfNoise` (cono di rumore + VWAP trailing, indici) | **scritto, 2 file prova, MAI GIRATO** |

> 🎯 **Le due gambe le abbiamo GIA' — separate, e mai accese. Quello che NON
> abbiamo e' l'ARBITRO che decide quale delle due corre oggi.**
> ➡️ **E questo apre una strada che non costa un porting nuovo**, e la segnalo
> perche' e' probabilmente piu' economica del candidato stesso: **misurare il
> punteggio di espansione come arbitro sui NOSTRI due motori gia' scritti.**
> E' la stessa mossa che la seconda battuta raccomandava per L'OROLOGIO —
> **prima si raccoglie il lavoro gia' pagato.**

🟢 **Scorrelazione:** lavora su **EURUSD/GBPUSD/XAUUSD** in sessione
europea+USA. La flotta viva e' quasi tutta su **indici** e su forex a **H1/H4
con tenuta di giorni**. ⚠️ Ma **sovrappone la finestra oraria** con le aperture
DAX (08:00 server) → **regola di rotta 1: mai a rischio pieno insieme finche' la
correlazione fra le serie per-trade non e' MISURATA.**

#### 5.10 🏛️ IN OTTICA PROP

- 🟢 **Attacca il problema vero della challenge: la PORTATA.** A ~4,8/giorno il
  campione dei 150 si raggiunge in **~7 settimane** invece che in anni.
- 🟢 **La clausola HFT non dovrebbe mordere, ed e' la prima volta che una sonda
  di casa la conta.** Con stop e take ad ATR(14) su M5/M15 la tenuta si misura
  in **decine di minuti**. Il vincolo P5 e' **max 25% dei trade sotto 60
  secondi**; la flotta oggi sta al **4,6%**. **Ma si misura, non si assume.**
- 🔴 **Il rischio giornaliero e' il punto debole, ed e' strutturale.** 5 trade
  sullo stesso simbolo nella stessa sessione **non sono 5 rischi indipendenti**:
  a 0,65% l'uno sono **3,25%**, cioe' **esattamente il cap C1** firmato il
  18/08. 👉 **`InpMaxTradesPerDay` non e' un'aggiunta: e' un input del primo
  round.** E la peggior giornata si legge **prima** del PF.
- 🟡 **Forma RR 1,50 = win rate ~45-50% = serie di perdite lunghe.** E' la forma
  **opposta** a quella che il DD trailing punisce (pochi stop grossi dopo tanti
  take piccoli) → **su quell'asse e' favorito**; ma produce **lunghi ritorni dal
  picco**, che il trailing punisce comunque. 🔴 E le nostre Monte Carlo sono
  tutte su **DD statico dal deposito**: col trailing **non valgono**, e non e'
  mai stato ricalcolato.
- 🔴 **Nessun cap di perdita giornaliera dentro il motore** (a differenza di
  LondonFx, che ce l'ha). Va aggiunto.

#### 5.11 📊 PUNTEGGIO

- **[2] semplicita'** — 135 righe, **11 input veri** (2 dei 13 sono solo
  grafici). Sotto il tetto di casa.
- **[2] il filtro E' il motore** — 🎯 **il voto pieno, ed e' il motivo della
  promozione.** L'`expansion` non filtra: **sceglie quale dei due motori corre**.
  Toglilo e non resta una strategia peggiore — **restano due strategie diverse
  senza arbitro**. E' la forma `ABTG_EMA200` (R29, 30/30), non la forma
  "filtro appiccicato" (0/5).
- **[2] tesi di mercato scrivibile** — sopra, una riga.
- **[2] riempie un BUCO** — **quattro insieme**: (a) il **regime che SCEGLIE il
  motore**, che in flotta **non esiste**; (b) la **FREQUENZA**, il buco del
  mandato; (c) **forex major + oro intraday a M5-M15**, che in flotta non
  esiste; (d) **due lati perfettamente simmetrici** (14 celle vive quasi tutte
  long-only).
- **[1] testabile senza riscritture** — 🔴 **Pine → MQL5 e' una RISCRITTURA.**
  Onesto: **~1 giornata** per l'EA, **~4-5 ore** per la sola sonda se si riusa
  lo chassis di `ABTG_SondaLondonFx`. Attenuante: `ta.vwap` ancorata e i
  percentili sono ~40 righe; **il resto del contenitore esiste gia'.**

## **VERDETTO: 🟢 PROVA — 9/10**

**PERCHE':** e' l'unico oggetto delle tre battute in cui **il regime e'
costitutivo invece che appiccicato** — la sola forma che in casa abbia mai
prodotto **30 celle su 30** — e insieme l'unico che porta **una ragione
STRUTTURALE, non una speranza, per superare il pavimento di frequenza**
(percentile auto-normalizzante contro evento di coda). La geometria e' letta
nel sorgente e passa l'aritmetica H8 (**RR 1,50 → 43,0% lordo**). **Il voto
perde un punto solo per il costo di riscrittura** — e va detto che questo e' un
**giudizio DI CARTA prima della misura**, esattamente come il 9/10 che M0PB
aveva la sera del 31/08 prima che la sonda lo ribaltasse in un'ora.

---

## 6. 📦 IL PASSO 0 — si conta PRIMA, si giudica DOPO

🔴 **Non propongo una griglia. Propongo un CONTATORE**, per la terza volta e
per la stessa ragione misurata: **le tre fonti dati sono murate e da qui la
frequenza NON si misura** (§2). E la frequenza e' il pavimento, cioe' la cosa
che puo' uccidere il candidato **prima** che si scriva un EA — come e'
successo a M0PB, **al costo di una compilazione e 12 passate**.

📄 **File prova (BOZZA, col cartello):**
`backtest_pipeline/prove/DAYFLOW_FREQUENZA_BOZZA.txt`

**I numeri che la sonda deve restituire, coi cancelli congelati LI' DENTRO:**

| # | numero | cancello congelato PRIMA |
|---|---|---|
| 1 | **segnali ESEGUIBILI/giorno per LATO e per MOTORE** | 🔴 **< 2,00 → SCARTO IMMEDIATO** (il pavimento nuovo). 2-3 passa al minimo, > 3 fascia preferita |
| 2 | segnali **GREZZI**/giorno | non e' un cancello: il rapporto grezzi/eseguibili dice quanta portata il **cooldown** butta via |
| 3 | **MFE mediana a 12 barre** | **< 3× spread → SCARTO** · 3-6× → **SOSPESO** (e si misura finalmente lo spread col Code Base **74148**) · > 6× → passa |
| 4 | **MAE mediana a 12 barre** | nessun cancello: dice se lo stop da 1,2 ATR sta **sopra o sotto il rumore** (R109) |
| 5 | **RR = (3)/(4)** | 🖊️ **RR < 0,70 → SCARTO PER ARITMETICA**, senza corsa a tick |
| 6 | **massimo segnali in UNA giornata** | taglia `InpMaxTradesPerDay` **sui dati**. 🚨 se `max × 0,65% > 3,25%` (cap C1) il cap va nell'EA dal primo round |
| 7 | **mediana della TENUTA in barre** + **quota sotto 60 secondi** | **< 12 barre → SOSPESO** (muro d'attrito) · **>= 25% sotto 60 s → SCARTO PROP** (P5) |
| 8 | **gradiente M5 vs M15** | e' la **tensione del §5.6** misurata: se M5 passa F1 e fallisce F2, e M15 il contrario, **il candidato vive solo sull'oro** |

**Simboli:** **EURUSD** (lead), **GBPUSD**, **XAUUSD** (🎯 la gamba con la
geometria piu' grassa — ma **la profondita' storica dell'oro su BCM non e' mai
stata misurata**, rilievo G1-PAOLO: quella gamba vuole prima una sonda di
storico). **TF: M5 e M15, obbligatorie entrambe. Lati e motori: separati, sempre.**

---

## 7. 🧱 DA TENERE AGLI ATTI (spec, non candidati)

### 7.1 🎯 L'arbitro di regime si puo' provare SENZA comprare un EA nuovo
Le due gambe di DayFlow **esistono gia' in casa** (`ABTG_VwapRevert` per il
fade, `ABTG_OutOfNoise` per il breakout) e **nessuna delle due e' mai girata**.
Il pezzo che non abbiamo e' **l'arbitro**: una riga,
`expansion = stdev(resid,63)/stdev(close,63)`.
👉 **Misurare quell'arbitro sui nostri due motori costa molto meno di un
porting**, e risponde alla stessa domanda. **E' un'alternativa da mettere
davanti a Claudio insieme al candidato, non dopo.**

### 7.2 🧩 Due conferme indipendenti della forma "il regime sceglie il motore"
Trovate lo stesso giorno da autori diversi: **S10** (`Mean Reversion and
Trendfollowing`, I11L — `close < sma200` → mean-reversion, `close > sma200` →
trend) e **S5** (`Adaptive Dual-Engine`, patelanishp — `entryMode = "Auto (by
timeframe)"`). **Entrambi scartati per altro** (nessuno stop il primo, RR 0,30 il
secondo), **ma la forma ricorre.** Non e' una stranezza di exlux.

### 7.3 🔧 Il troncamento silenzioso del TF inferiore
`request.security_lower_tf` rende **solo le barre contenute nella barra
corrente**: un parametro "span" piu' lungo del rapporto fra i due TF viene
**troncato senza errore**. 👉 **Vale per ogni Pine che legge un TF inferiore**, e
nel porting MQL5 quei parametri vanno espressi **in minuti, non in barre**.

### 7.4 📕 Un rilievo di processo, dalla battuta di oggi
**Tre dei 16 Pine letti erano CODICE ROTTO in modi che nessun backtest
segnala:** id di uscita che non esiste (**S6**), `stop=`/`limit=` di
`strategy.entry` scambiati per bracket di uscita (**S14**), filtro di data che
limita l'anno a un trimestre (**S4**). 👉 **Su TradingView il numero di like non
correla con la correttezza del codice**: S3 ha **1.610 like** e nessuno stop,
S1 ne ha **3.323** ed e' una famiglia morta. **Il sorgente si legge sempre.**

---

## 8. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **LA FREQUENZA, DI QUALUNQUE CANDIDATO** | **Terza battuta di fila.** Yahoo, Stooq, Dukascopy: **403 al CONNECT** tutte e tre. **Il numero che il mandato mette per PRIMO e' proprio quello che da qui non si misura.** Quella di P1 e' **[DERIVATA DAL CODICE]**, non misurata |
| 🔴 **UN CLAIM DI FREQUENZA DELL'AUTORE su P1** | **Non esiste.** Letta la pagina intera: descrive l'effetto dei parametri sul conteggio, **mai un numero**. Vedi §0 per la lettura del criterio che ho applicato |
| 🔴 **LO SPREAD BCM MISURATO** su EURUSD/GBPUSD/XAUUSD | **Non esiste in repo.** Code Base **74148** promosso dal 23/08 e mai usato: **SETTIMA caccia**. Finche' non gira, **F2 e' tarato su una convenzione** |
| 🔴 **LA PROFONDITA' STORICA DI XAUUSD su BCM** | **Mai misurata** (G1-PAOLO). La gamba oro del PASSO 0 — la piu' promettente — **richiede prima una sonda di storico** |
| 🟡 **~104 delle ~120 strategie TradingView leggibili** | Ne ho aperte **16**, scelte in bersaglio; le altre sono nel §4.4 col motivo del primo taglio. **Il giacimento non e' esaurito, ma le 16 lette sono un campione onesto della sua qualita': 15 scarti su 16** |
| 🟡 **10 degli 11 EA di `geraked`** | Letto per intero **solo `DHLAOS.mq5`**; sugli altri 10 ho fatto **grep mirato dei due default** (`Grid`, `IgnoreSL`). **Il verdetto §4.1 si regge su quel grep, ed e' dichiarato cosi'** |
| 🟡 **`S15 TrendShift`** | **Scartato senza aprire il sorgente**, dichiarato: Supertrend (F5) + ADX (R20, uno degli 0/5) sono entrambi nel titolo |
| 🔴 **Forex Factory · SSRN · ricerca GitHub API** | **403, decima di fila.** Non riprovati: gia' misurati nulli due volte |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato oggi.** Ogni riga e' `[VERIFICATO su sorgente/pagina]`, `[DERIVATO]`, `[STIMA]` o `[NON MISURATO]` |
| 🔴 **I numeri di performance degli autori** | **Letti e NON usati in nessun punteggio.** L'autore di P1, a suo merito, **non ne pubblica** ("No performance claims") |

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Un grilletto costruito su un PERCENTILE — che il 25% delle barre soddisfa per definizione — produce davvero le 2+ occasioni al giorno che un grilletto di CODA (M0PB, 0,52/giorno) non ha prodotto? E se si', a quale timeframe sopravvive anche la geometria?**

**E' la domanda giusta perche' e' la sola che puo' chiudere il candidato senza
scrivere un EA operativo**, e perche' la risposta **vale oltre il candidato**:

- se i segnali eseguibili sono **sotto 2/giorno anche a M5**, allora **il
  percentile non salva la frequenza piu' della coda** — e cade l'unico argomento
  strutturale che questa caccia ha prodotto. **La portata a TF basso si chiude
  come direzione**, e resta solo la strada scritta il 29/08 e mai smentita:
  **piu' SIMBOLI a M15-H1, non piu' velocita'**;
- se **M5 passa F1 ma fallisce F2** (la geometria si assottiglia sotto il costo)
  e **M15 fa il contrario**, allora il candidato **vive solo sull'oro**, dove
  l'ATR in USD vale molte volte lo spread — e questo e' un risultato preciso,
  non un forse;
- se **passano entrambi i motori**, allora **l'arbitro di regime E' l'edge**, e
  la mossa piu' economica non e' portare DayFlow: e' **misurare quell'arbitro
  sui due motori che abbiamo gia' scritto e mai acceso** (§7.1).

**E se il contatore dice di no su tutta la linea, quella e' una risposta utile
quanto un promosso**, perche' chiude con un numero una direzione di caccia che
altrimenti si riapre ogni settimana.

---

_Dossier chiuso il 01/09/2026. **207 strategie TradingView censite** con **43
query in 8 ondate** + **~25 repo GitHub** (6 aperti davvero); **2 fonti, 2 vive,
6 canali non riprovati perche' gia' misurati nulli**; **20 oggetti letti nel
sorgente** (16 Pine scaricati integrali + 4 `.mq5`, di cui 1 per intero e 11
sondati per grep mirato); **1 promosso, 0 in coda, 4 spec, 21 scarti motivati
nel sorgente + ~170 scarti al primo taglio**; **1 repo GitHub da 625 stelle
CHIUSO definitivamente** con la misura su 11 EA su 11; **1 correzione tecnica
alle fonti** (§2).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato, niente
toccato in forward.**_
