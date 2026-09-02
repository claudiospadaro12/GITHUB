# 🏹 CACCIA FREQUENZA — **QUARTA BATTUTA · FRONTE A** · GitHub (query nuove) + TradingView (angoli non battuti) + Forex Factory — 02/09/2026

**Mandato (Claudio, 02/09 sera, testuale):** _"MANDA LA NOSTRA FLOTTA DI AGENTI
A CACCIA DI EA DAL TF BASSO M5,M15"_.

**Perimetro assegnato (FRONTE A):** GitHub con query **diverse** dalla terza
battuta · TradingView su **angoli non battuti** (strategie, non indicatori) ·
Forex Factory Trading Systems.

---

## ⚡ IL RISULTATO IN CINQUE RIGHE

> **Su 3 fonti sottoposte a controllo positivo misurato oggi (2 vive, 1 nulla),
> 68 query TradingView in 7 ondate + 5 ricerche GitHub, ~126 strategie
> TradingView censite e 7 repo GitHub aperti davvero: sono arrivato al
> SORGENTE su 10 oggetti e li ho letti riga per riga (8 Pine + 2 `.mq5`).
> NE PROMUOVO UNO, E NON E' NESSUNO DEI DIECI.**
>
> 🥇 **Il promosso e' un MECCANISMO che tre autori indipendenti descrivono e
> nessuno dei tre implementa in modo usabile: la DIVERGENZA RELATIVA fra due
> indici che quotiamo entrambi** (`z-score del rapporto D30EUR/U30USD`, oppure
> `NASUSD/U30USD`), **fadata a M5/M15 nella sovrapposizione EU-USA.** E' il
> caso da manuale del §5F: **motore sano, gestione da rifare da zero.**
>
> 🔴 **E il numero che riassume la battuta e' questo, ed e' misurato con un
> `grep` su otto sorgenti Pine: SETTE SU OTTO non contengono UN SOLO
> `strategy.exit`.** Zero stop mandato al broker. **Non e' un caso: e' la
> firma della famiglia.** Il "pairs trading" retail non mette stop **perche' la
> tesi stessa dice che lo spread deve tornare**. La riga in §4.2.
>
> 🕳️ **E il buco l'ho verificato nel repo, non l'ho supposto:** `grep` su tutti
> i `.mq5` della flotta → **ZERO motori che scambiano un simbolo usando il
> prezzo di un ALTRO simbolo come segnale.** `ABTG_Bulge` e `ABTG_FiboH4_Multi`
> sono multi-simbolo (**lo stesso motore su N simboli**), che e' un'altra cosa.
> La correlazione S&P in flotta e' un **gate che filtra**; qui sarebbe il
> **motore** — la distinzione che in casa vale **30 celle su 30** (§5B).
>
> ⚠️ **Il difetto lo scrivo in prima riga:** **nessuno dei 10 oggetti letti e'
> promuovibile com'e'.** Il promosso e' una **struttura da scrivere**, non un
> EA da portare. Costo onesto in §5.7. Chi vuole un EA pronto oggi, in questa
> battuta non lo trova — **e la risposta "non c'e'" e' una risposta.**

---

## 0. ⚖️ I CRITERI, CONGELATI PRIMA DI APRIRE UN SORGENTE

Presi dal mandato del 02/09, parola per parola, **scritti prima di aprire una
pagina**. Ereditano F1-F12 delle tre battute precedenti senza modifiche
(i criteri si cambiano prima dei numeri, non dopo).

| # | criterio | soglia |
|---|---|---|
| **C1** | **TF DI LAVORO M5 o M15** | dichiarato dall'autore **o** leggibile nel codice. H1+ e M1 = fuori perimetro |
| **C2** | **FREQUENZA ≥ 2 trade/giorno** | `[MISURATA DALL'AUTORE]` o `[DERIVATA DALLA MECCANICA]` — **e va etichettato quale delle due** |
| **C3** | **§4 non si ammorbidisce** | griglia / martingala / recovery / hedge / `IgnoreSL` / no-SL / SL virtuale / repaint / look-ahead = **scarto immediato, con la riga che lo prova** |
| **C4** | **MECCANISMI nuovi** | ogni candidato passa la **lista dei caduti** PRIMA di entrare nel dossier. Mai "parametri diversi di un motore morto" |
| **C5** | **gratuito / open source, sorgente leggibile riga per riga** | mai promuovere da descrizione |
| **C6** | **GEOMETRIA propria nel sorgente** | **RR < 0,70 = SCARTO PER ARITMETICA**, da `p >= 1,075/(RR+1)` (cancello H8, `FIRME_2026-08-31.md` FIRMA 2) |
| **C7** | **due lati** (regola 25/08) | long-only senza ragione dichiarata = punto in meno, e va scritto |
| **C8** | **numeri d'autore** | si LEGGONO e **non entrano in nessun punteggio** |
| **P5** | **vincolo prop HFT** | max **25%** dei trade sotto 60 secondi (`CONFIG_PROP_2026-08-31.md`) |

---

## 1. 📕 IL CIMITERO E LE FONTI CHIUSE, RILETTI PRIMA DI USCIRE

Letti per intero prima di aprire un browser:
`CACCIA_FREQUENZA3_TV_GH_2026-09-01.md` (687 righe),
`CACCIA_FREQUENZA3_ART_PAPER_2026-09-01.md` (787),
`CACCIA_FREQUENZA_2026-08-31.md` (636), `CACCIA_FREQUENZA2_2026-08-31.md` (780),
`PROMEMORIA_SBLOCCO_FONTI.md` (453), `REGISTRO_TEST.md` (684),
`CACCIA_GITHUB_INDICI_2026-08-30.md`, `CACCIA_DOW_M5M15_2026-08-30.md`,
`CACCIA_M1_TFBASSO_2026-08-29.md`, `SETACCIO_MANUALE.md`.

### 1.1 Cio' che era gia' CHIUSO e che **NON ho riaperto** (per rispetto del mandato)

| oggetto | chiuso quando, e con quale misura |
|---|---|
| **`geraked/metatrader5`** (625 stelle) | **CHIUSO il 01/09**: `Grid=true` di default su **11 EA su 11**, `IgnoreSL=true` su **6 su 11**. Non riaperto |
| **articoli mql5.com/articles** | chiusi **strutturalmente** il 01/09 (1.120 titoli censiti, 0 candidati) |
| **QuantConnect** | chiuso il 31/08 notte: libreria di **portafoglio a ribilancio**, non intraday su CFD |
| **i 16 Pine della terza battuta** | letti e verdettati. **Nessuno riaperto**; ho verificato per `imageUrl` che non rientrassero nei pool di oggi |
| **`?keyword=` del Code Base** | **non esiste** (il parametro viene ignorato): non e' interrogabile per parola |

### 1.2 Le famiglie cadute, e quanti candidati mi hanno ucciso **oggi**

| famiglia caduta | verdetto misurato | scarti di oggi |
|---|---|---:|
| **Bollinger / BreakingBand M15** (R108/R111) | **6 finestre su 6 rosse**, gradiente H1>M30>M15 monotono su 3 simboli | **3** |
| **mean reversion a TF basso senza regime** (R60) | **12 celle su 12 in perdita** | **4** |
| **fade degli estremi** (R42) | **0/24 IS e 0/24 OOS** | **2** |
| **breakout / ORB / range** | ~210 celle a tick, **R45 0/48**, R12 **48/48 negative OOS** | **9** (primo taglio) |
| **EMA-cross / MA-cross nudi** | Chaos 1 cella su 105 | **4** (primo taglio) |
| **trend+pullback** = SupRev, spina dorsale (6 sedie vive) | doppione F5 | **5** (primo taglio) |
| **SMC / OB / FVG** | costo di validazione > valore atteso | **2** |
| **filtro appiccicato** (`ROBUSTEZZA.md` §5B) | **0 successi su 5** | **2** |
| **RSI+EMA / M0PB** (grilletto di CODA) | M0PB **0/12 alla sonda**, lato migliore **0,52 segn./giorno** | **3** |
| **capitolo M1** | _"trappola di costo strutturale"_, chiuso a tick | **1** |
| **volume su forex/CFD** (regola Paolo) | tick volume ≠ volume | **~10** (primo taglio, famiglia order-flow) |

---

## 2. 📡 CONTROLLO POSITIVO — misurato OGGI, 02/09, prima di cercare

| fonte | bersaglio noto | esito misurato oggi | verdetto |
|---|---|---|---|
| **TradingView** `pubscripts-suggest-json` | query `london session` | **HTTP 200, 30.538 byte** (identico al 01/09), JSON con `scriptIdPart`/`access`/`agreeCount` coerenti | 🟢 **PASSA** |
| **TradingView** `pine-facade /get/` | `PUB;e90d6f725fa044dfbbfce3dba1fcd56e` (*Sessions [TradingFinder]*) | **HTTP 200, 11.385 byte**, `scriptAccess=open_no_auth`, `created 2024-03-06`, **10.626 caratteri di `source` in chiaro** | 🟢 **PASSA** |
| **GitHub** `raw.githubusercontent` | `n30dyn4m1c/crt-turtlesoup-ea/main/README.md` | **HTTP 200, 4.711 byte** (identico al 01/09) | 🟢 **PASSA** |
| **GitHub** `WebSearch` + `WebFetch` | 5 query + 7 pagine repo | **200**, URL veri e verificati a valle | 🟢 **PASSA** |
| 🔴 **Forex Factory** `/forum/71-trading-systems` | la sezione Trading Systems, assegnata dal mandato | **HTTP 403 via `curl`** (5.469 byte di pagina di blocco) **E HTTP 403 via `WebFetch`** | 🔴 **NULLA** |

### 🔧 UN AGGIORNAMENTO VERO AL `PROMEMORIA_SBLOCCO_FONTI` — Forex Factory **non** e' il caso di GitHub

Il promemoria (§B, 28/08) contiene la lezione preziosa _"GitHub non e'
bloccato: e' bloccato `curl`"_ — il blocco stava sul **trasporto**, non sul
dominio, e `WebFetch` lo aggirava.

🔴 **Su Forex Factory ho verificato oggi che quella scappatoia NON esiste:
403 su ENTRAMBI i trasporti.** Le nove dichiarazioni precedenti di "FF 403"
erano tutte su `curl`; questa e' la prima misura **indipendente dal
trasporto**.

> 📌 **Da scrivere una volta e non riprovare:** _"Forex Factory e' murata al
> dominio, non al trasporto. `curl` **e** `WebFetch` rendono entrambi 403.
> Non e' il caso GitHub. Il mandato 'FF Trading Systems' non e' eseguibile da
> qui, ed e' il decimo dossier che lo dice."_

**Costo dichiarato:** il fronte FF del mandato — **i thread storici che
raccontano come una strategia e' INVECCHIATA**, che nessun'altra fonte
sostituisce — **e' rimasto vuoto. Non l'ho compensato con la memoria.**

### ⛔ Canali NON riprovati (gia' misurati nulli, ripetutamente)

`api.github.com` (ricerca) · `papers.ssrn.com` · `query1.finance.yahoo.com` ·
`stooq.com` · `datafeed.dukascopy.com` · topic GitHub (spam SEO, confermato due
volte) · `?keyword=` del Code Base.

👉 **Conseguenza, per la QUARTA volta di fila: NESSUNA FREQUENZA E' STATA
MISURATA DA QUI.** Le tre fonti dati restano murate al CONNECT. **Il numero lo
fa il PC di Claudio.** E' il motivo per cui il PASSO 0 del promosso e' **una
sonda di conteggio, non una griglia.**

---

## 3. 📊 COSA HO SFOGLIATO

### 3.1 TradingView — 68 query in 7 ondate, tutte su **angoli non battuti**

| # | ondata | query | strategie censite | `access=1` |
|---|---|---:|---:|---:|
| 1 | **pairs / arbitraggio statistico** (`pairs trading`, `spread mean reversion`, `z-score reversion`, `cointegration`, `correlation strategy`, `statistical arbitrage`, `kalman filter strategy`, `hurst exponent`) | 8 | **29** | 17 |
| 2 | **profilo / livelli di giornata** (`initial balance`, `previous day high low`, `value area`, `market profile`, `gap fill`, `time exit`, `close after n bars`, `intraday seasonality`, `hour of day`, `volatility regime switch`) | 10 | **12** | 9 |
| 3 | **order flow** (`order flow`, `volume delta`, `cumulative delta`, `footprint`, `tick imbalance`, `liquidity grab`, `stop hunt`, `spike reversal`, `exhaustion reversal`, `absorption`) | 10 | **21** | 15 |
| 4 | **frequenza dichiarata** (`multiple trades per day`, `high frequency`, `5 min strategy forex`, `15 min strategy forex`, `eurusd 5 minute`, `gbpusd 15 min`, `intraday range reversion`, `band reversion session`, `adaptive regime`, `dual mode`) | 10 | **10** | 5 |
| 5 | **canali e pivot** (`linear regression channel`, `pivot points`, `camarilla`, `opening drive`, `trend day`, `power hour`, `asian range fade`, `news spike fade`, `volatility contraction`, `atr channel`, `standard deviation channel`, `half life`) | 12 | **25** | 17 |
| 6 | **valore relativo** (`lead lag`, `relative strength`, `ratio strategy`, `convergence divergence pairs`, `spread trading`, `index divergence`, `es nq spread`, `dax dow`, `beta neutral`) | 9 | **16** | 10 |
| 7 | **soglia adattiva** (`session mean reversion`, `london session`, `new york session`, `open range fade`, `vwap deviation`, `percentile strategy`, `quantile`, `rank strategy`, `adaptive threshold`) | 9 | **13** | 10 |
| | **TOTALE** | **68** | **~126** (qualche sovrapposizione fra ondate: `TrendShift` ed `Ehlers Combo` compaiono due volte) | **~83** |

### 🏷️ Query TradingView che rendono ZERO strategie — da segnare, valgono per le prossime cacce

`cointegration` (11 risultati, **0 strategie**: sono tutti indicatori) ·
`hurst exponent` (17 → 0) · `kalman filter strategy` (**0 risultati**) ·
`market profile strategy` (0) · `close after n bars` (0) ·
`intraday seasonality` (3 → 0) · `hour of day strategy` (0) ·
`multiple trades per day` (**0**) · `15 min strategy forex` (0) ·
`gbpusd 15 min` (0) · `intraday range reversion` (0) · `asian range fade` (1 → 0) ·
`news spike fade` (0) · `volatility contraction` (8 → 0) ·
`standard deviation channel` (12 → 0) · `half life` (4 → 0) ·
`lead lag` (12 → 0) · `spread trading` (7 → 0) · `index divergence` (46 → **0**) ·
`es nq spread` (1 → 0) · `beta neutral` (0) · `convergence divergence pairs` (0) ·
`new york session strategy` (**0**) · `open range fade` (0) ·
`vwap deviation strategy` (0) · `quantile` (35 → 0) · `tick imbalance` (3 → 0) ·
`cumulative delta strategy` (1 → 0).

> 🔴 **VENTOTTO query su 68 rendono ZERO strategie.** Non e' un dettaglio: e'
> la **misura della saturazione della fonte** sul nostro bersaglio. Sommato ai
> 207 titoli censiti il 01/09 e ai censimenti del 25-31/08, **TradingView per
> "meccanismo intraday nuovo a M5/M15" e' vicino all'esaurimento**, e la resa
> marginale di un'altra battuta su questa fonte e' **bassa e prevedibile**.

### 3.2 GitHub — 5 ricerche, ~30 repo visti, **7 aperti davvero**

| angolo del mandato | query usata (nuova, non della terza battuta) | resa |
|---|---|---|
| M15 + sessione + uscita a tempo | `github mq5 expert advisor M15 session intraday time based exit` | 🟡 3 repo nuovi, 1 aperto nel sorgente |
| mean reversion intraday | `github mql5 expert advisor "mean reversion" M5 M15 no martingale open source .mq5` | 🟡 **stesso pool** — segnale di esaurimento |
| pairs / spread | `github mql5 expert advisor pairs trading spread mean reversion mt5 source` | 🟡 2 repo nuovi |
| arbitraggio statistico / correlazione | `github metatrader5 EA statistical arbitrage correlation two symbols hedge basket .mq5` | 🟢 **ha prodotto la terza conferma indipendente del promosso** (§4.3 G7) |
| canale di regressione / z-score | `github mql5 EA trades one symbol using second symbol ratio z-score divergence indices source` | 🟢 stessa cosa |

> 🔴 **Rilievo di processo:** **quattro query su cinque hanno restituito lo
> STESSO pool di repo** (`geraked`, `nyao_scalper`, `santiago-cruzlopez`,
> `sajidmahamud835`, `coler07`, `NadirAli*`, `abiodunaremu`) — **tutti gia'
> scartati fra il 16/08 e il 01/09.** Con `api.github.com` murata da dieci
> dossier, l'unico canale e' `WebSearch`, che indicizza **il popolare, non il
> nuovo**. **GitHub come giacimento di EA MQL5 e' esaurito per noi**, e va
> scritto invece di ri-cercarlo il giro dopo.

### 3.3 Forex Factory — **0 pagine**. Fonte nulla, §2.

---

## 4. 🗑️ GLI SCARTATI — con la riga di codice che lo prova

### 4.1 🎯 IL RISULTATO MISURATO DELLA BATTUTA — sette sorgenti Pine su otto **non hanno UN SOLO `strategy.exit`**

`grep -c "strategy.exit"` sugli otto Pine scaricati integrali oggi:

| sorgente | righe | `strategy.exit` | stop mandato al broker? |
|---|---:|---:|---|
| `Pair Trade` (wa1one) | 40 | **0** | 🔴 no |
| `Unilateral Pairs Trading` (pietro3334) | 78 | **0** | 🔴 no |
| `Statistical Arbitrage Pairs Trading — Long-Side Only` (piirsalu) | 97 | **0** | 🔴 no |
| `Statistical Arbitrage` (EdgeTools) | 40 | **0** | 🔴 no |
| `Gap Absortion Strategy` (noop42) | 74 | **0** | 🔴 no (stop **virtuale**, §4.2 T6) |
| `Linear Regression Pearson's R — Trend Channel` (x11joe) | 99 | **0** | 🔴 no |
| `Comparative Relative Strength` (HPotter) | 37 | **0** | 🔴 no |
| `Z-Score Mean Reversion Pro` (ayusattv) | 238 | **2** | 🟢 **si'** — e' l'unico |

> ### 🔬 IL PUNTO, E VALE OLTRE QUESTA BATTUTA
> **Non e' sciatteria diffusa: e' una PROPRIETA' DELLA FAMIGLIA.** Il
> valore-relativo/pairs retail **non mette stop perche' la sua tesi dice che lo
> spread DEVE tornare** — se metti uno stop, esci proprio quando la divergenza
> e' massima, cioe' quando il segnale e' piu' forte. **E' la stessa logica che
> giustifica la griglia**, ed e' il motivo per cui questa famiglia va presa
> **solo se lo stop lo mettiamo noi.**
>
> 👉 **Conseguenza diretta sul promosso (§5): lo stop non e' un accessorio
> della rifinitura, e' LA condizione di ammissibilita' del motore.** E il
> primo round deve misurare **quanto costa** quello stop — perche' e' un costo
> che l'autore originale non paga e noi si'.

### 4.2 TradingView — 8 Pine letti riga per riga, **8 scartati**

| # | candidato · autore · `imageUrl` · like | la riga che lo prova |
|---|---|---|
| **T1** | **`Pair Trade`** · wa1one (© vladimirkovalchuk) · `ru23VN0C` · **279 like** · Pine v4, **40 righe** | 🟠 **Scarto per GESTIONE, non per motore — ed e' la fonte primaria del promosso.** Il motore e' pulito: `beta = correlation(x,y,len)*stdev(y,len)/stdev(x,len)`, `spread = sma(y,len) − beta*sma(x,len)`, `spreadfinal = (spread − ms)/stdev(spread,len)` → **z-score di uno spread a beta OLS**, **due lati perfettamente simmetrici** (`±1,85` in ingresso, `∓0,05` in uscita). 🔴 Ma: **`strategy.exit` = 0** (uscita solo su soglia); `default_qty_type=strategy.fixed, default_qty_value=100` = **lotto fisso**, non scalabile a 100k (motivo di scarto ricorrente nel `SETACCIO_MANUALE`); e i simboli sono `security("SPY")` / `security("IVI")` — **azionario US che BCM non quota**, e "IVI" non e' nemmeno un ticker vivo (verosimile refuso di `IVV`) |
| **T2** | **`Unilateral Pairs Trading`** · pietro3334 · `MD5vkc0n` · 30 like · Pine v4, **78 righe** | 🟠 **Stesso caso di T1, forma piu' interessante e stessa condanna.** `ratioSeries = close/spyData`; `deltaNormRatio = (deltaSeries − sma(deltaSeries,20))/stdev(deltaSeries,20)`; ingressi `< −1,05` / `> +1,05`, uscite a `∓0,05`. 🎯 **E' UNILATERALE: scambia SOLO il simbolo del grafico usando l'altro come metro** — quindi e' implementabile su MT5 **senza gamba di copertura**. 🔴 Ma: **`strategy.exit` = 0**, lotto **fisso 100**, e uscite via `strategy.order(id="XL", long=false, qty=strategy.position_size)` = **niente stop, niente take, si esce solo se la soglia torna** |
| **T3** | **`Statistical Arbitrage Pairs Trading — Long-Side Only`** · piirsalu · `Kt6XkQIM` · 269 like · Pine v5, 97 righe | 🔴 **LONG ONLY dichiarato nel titolo** (viola la regola dei due lati del 25/08) **+ nessuno stop** (`strategy.close('Long')` quando `modifiedZScore >= 0`). Simboli `BATS:GOOG` = azionario US. 🟢 **Da tenere agli atti come SPEC, ed e' un pezzo utile:** usa lo **Z-SCORE MODIFICATO** `0.6745*(x − mediana)/MAD` invece di media/deviazione — **una normalizzazione ROBUSTA che una singola candela anomala non fa esplodere.** E' esattamente il difetto che uccide uno z-score classico su un CFD con uno spike di feed |
| **T4** | **`Statistical Arbitrage`** · EdgeTools · `5JVPlEgr` · 133 like · **MPL 2.0**, Pine v5, 40 righe | 🔴 **TRE difetti, e uno e' del §4.** (a) riga 5: **`calc_on_every_tick=true`** — bandiera rossa di casa; (b) **LONG ONLY** e **zero stop** (`strategy.close("Long")` quando lo spread torna alla media); (c) 🔴 **errore dimensionale**: `spread = symbol1 − symbol2` con `symbol1="CBOT_MINI:YM1!"` (~44.000) e `symbol2="CME_MINI:ES1!"` (~5.900) — **la differenza NUDA di due prezzi con moltiplicatori e scale diverse non e' uno spread**, e' quasi solo il prezzo di YM. La `stdev` normalizza il livello ma non il **beta**: la tesi "arbitraggio" non e' implementata |
| **T5** | **`Z-Score Mean Reversion Pro`** · ayusattv · `92rilzXd` · 78 like · **MPL 2.0**, Pine v6, **238 righe** | 🔴 **L'UNICO con una geometria vera (SL 2 ATR / TP 3 ATR → RR 1,50, passa H8) e viene scartato per gli altri due criteri.** (a) **C2 — GRILLETTO DI CODA:** `z_thresh = 2.5` su `rolling_window = 80`: e' **la malattia esatta di M0PB** (`RSI(6)>=90` → **0,52 segnali/giorno** misurati), non la cura; (b) **filtro appiccicato quattro volte, e l'autore lo dichiara con gli interruttori**: `use_rsi_filter`, `use_bb_filter`, `use_ema_filter`, `use_atr_exit` — **un filtro con un interruttore non e' il motore**, ed e' la forma **0 successi su 5** (`ROBUSTEZZA.md` §5B); (c) `use_ema_filter` = _"Long only above EMA200"_ su un motore di **mean reversion** → e' **trend+pullback**, cioe' `SupertrendReversal`, **6 sedie vive**: doppione F5 |
| **T6** | **`Gap Absortion Strategy`** · noop42 · `Di9tH7dZ` · **466 like** · **MPL 2.0**, Pine v5, 74 righe | 🔴 **STOP VIRTUALE + C2 fallita per costruzione.** La riga: `exitSL = strategy.position_size != 0.0 and ta.cross(close, stop)` seguita da `strategy.close(...)` — **lo stop non va al broker**, si esce **alla chiusura della barra**, ed e' il difetto che **sui gap costa il doppio** (e questa e' una strategia **sui gap**). E la frequenza: `gap = close[1] > open ? ...` con `pct_trig = 0.5%` → su un CFD continuo intraday `open[i] == close[i−1]` quasi sempre, quindi **arma solo sul gap di apertura giornaliero**: **massimo 1/giorno, in pratica molto meno.** Pavimento C2 mancato di piu' della meta' |
| **T7** | **`Linear Regression Pearson's R — Trend Channel Strategy`** · x11joe · `6VHnjgfp` · **904 like** · **MPL 2.0**, Pine v4, 99 righe | 🔴 **NESSUNO STOP, NESSUN TAKE, 100% DELL'EQUITY, SEMPRE A MERCATO.** Le uniche due righe operative: `if(PearsonsR<0) strategy.entry("Long", strategy.long)` / `if(PearsonsR>0) strategy.entry("Short", strategy.short)` — **un flip continuo**, con `default_qty_type=strategy.percent_of_equity, default_qty_value=100`. E il commento dell'autore accanto e' _"5 percent loss at any time is OK"_ — **un commento non e' uno stop.** In piu' e' **doppio ciclo annidato su fino a 360 barre a ogni barra** (`for k=maxPeriod to minPeriod`, dentro `for i=0 to periodMinusOne`): costo computazionale che a M5 rende il tester inutilizzabile |
| **T8** | **`Comparative Relative Strength Strategy`** · HPotter · `89R8EgyE` · 143 like · Pine v2, **37 righe** | 🔴 **QUATTRO difetti, e uno lo scrive l'autore.** (a) riga 7, verbatim: _"Please, use it only for learning or paper trading. **Do not for real trading.**"_ [VERIFICATO]; (b) **`strategy.exit` = 0**, nessuno stop; (c) 🔴 **soglie ASSOLUTE cablate**: `BuyBand=0.9988`, `SellBand=0.9960`, `CloseBand=0.9975` sul rapporto `as/bs` — funzionano **solo** perche' ES/SPX500 sta vicino a 1. **Su D30EUR/U30USD il rapporto vale ~0,5: le soglie non significano niente** → non e' portabile, e **conferma per contrasto che la normalizzazione a z-score di T1/T2 e' la parte che vale**; (d) `reverse = input(false, title="Trade reverse")` = **l'interruttore che ribalta la tesi**, gia' scartato due volte (S2 del 31/08, `geraked`). **Un EA la cui direzione e' un parametro non ha una tesi** |

### 4.3 GitHub — 7 repo aperti, **7 scartati**

| # | repo · licenza · stelle | motivo, con la riga |
|---|---|---|
| **G1** | **`Bongo-Seakhoa/mql5_ea`** · licenza **non dichiarata** · 12 stelle | 🟠 **L'unico `.mq5` letto per intero oggi (748 righe), e lo scarto NON e' per il §4 — il codice e' pulito.** 🟢 Cose giuste, e vanno dette: rischio in **% dell'equity** sulla distanza dello stop, SL ad **ATR**, **circuit breaker giornaliero** (`inp_max_daily_dd = 3.0`) e totale (`10.0`), **sessione in ORA SERVER** (`inp_session_start = 7`, `inp_session_end = 20`), filtro di spread, magic, flat del venerdi'. **Zero occorrenze** di grid/martingale/recovery/IgnoreSL. 🔴 **Ma il MOTORE e' un doppione di una famiglia misurata morta**, riga 441: `bool bb_buy = (c2 < bb_lower \|\| l2 < bb_lower)` = **fade della banda di Bollinger** → **R108/R111, 6 finestre su 6 rosse**, con gradiente **H1>M30>M15 monotono** (cioe' peggiora proprio nel TF del mandato) + **R60, 12 celle su 12 in perdita**. 🔴 **E la frequenza crolla per costruzione**, riga 447: `if(bb_buy && ema_buy && trend_buy && rsi_buy && pat_buy)` — **CINQUE condizioni in AND**, una delle quali e' un pattern di candela. **C2 (≥2/giorno) non e' raggiungibile con un AND a cinque termini.** _(`Black_Box.mq5`, 604 righe, stesso repo: **stessa terna `iBands`+`iMA`+`iATR`**, versione precedente. Stesso verdetto, letto per grep.)_ |
| **G2** | **`zhutoutoutousan/profitable-expert-advisor`** · MIT · 48 stelle | 🔴 **Fuori perimetro C1 + famiglie chiuse.** TF dichiarato **H1/H4**, non M5/M15. Motori: `EMASlopeDistanceCocktail` (**EMA-cross/slope**, famiglia Chaos/SuperWave), `DarvasBox` (**breakout di box** = ~210 celle a tick), `RSIMidPointHijack` (**RSI+EMA**, = scheda `RSI+EMA V8` scartata il 31/08). Tutti su **XAUUSD**. Sorgente **non aperto**, e lo dichiaro: il TF da solo basta a chiudere |
| **G3** | **`PetrJoe/sophisticated-mt5-trading-bot`** · MIT · 5 stelle, **2 commit** | 🔴 **Strumento fuori mercato + tesi nel menu.** Opera su **Deriv Synthetic Indices**, che **BCM non quota**: nessun backtest possibile sul nostro banco. E il motore e' il riconoscimento di **13 pattern di candela** (Engulfing, Hammer, Dragonfly, Morning Star, Harami, Tweezer, Three Soldiers…) + RSI + EMA50 — **la tesi dentro il menu**, gia' caduta cinque volte. 🟢 Nota di merito, e la rubo: **ha il cap giornaliero** (_"maximum trades per day (default: 10)"_) e il **daily loss limit 5%**, che e' esattamente il pezzo di gestione prop che manca a quasi tutto il web |
| **G4** | **`Astralchemist/Expert-Advisor-trading-bot`** · MIT · 23 stelle | 🔴 **Tre volte fuori.** (a) TF dichiarato **M1** → fuori C1, e il **capitolo M1 e' chiuso a tick** (_"trappola di costo strutturale"_); (b) motore **FVG + supply zone + fractal** = **SMC/OB/FVG**, classe scartata per costo di validazione > valore atteso; (c) **SHORT-ONLY** (_"bearish reversal system… sell limit orders at identified supply zones"_) → viola C7 |
| **G5** | **`kabradhruv/MT5-Strategy-in-MQL5`** · — · 4 stelle | 🔴 **§4 dal nome del file:** `Martingle_grid_strategy.mq5`. E lo `Scalping_Bot` e' **`.ex5`, senza sorgente** → il setaccio non e' applicabile |
| **G6** | **`presscafe/mql5-Expert-Advisors`** · MIT · **0 stelle** | 🔴 Due file (`9_1.mq5`, `9_1_v2.mq5`) generati dal **MQL5 Wizard**, motori _"moving averages, ADX and other technical indicators"_: **EMA-cross + ADX**, cioe' la famiglia Chaos **piu'** R20 (uno degli 0/5 del filtro appiccicato). Nessun TF, nessuna sessione, nessuna frequenza dichiarata |
| **G7** | **`m4rk-lewis/price_action_analytics`** · **licenza non dichiarata** · 3 stelle | 🟠 **Scartato come CANDIDATO, decisivo come CONFERMA.** 🔴 Perche' e' scarto: **non e' un EA, e' un INDICATORE** (`ATR Hi Low With Pivots.mq5`, `Delta MA.mq5`, `MJL Price Action 5 Doji Delta.mq5` — **nessun `OrderSend`**, niente da backtestare), TF dichiarato **H4** (fuori C1), **nessuna licenza**. 🎯 **Perche' conta:** il README descrive, in MQL5 e su **indici**, esattamente il meccanismo del promosso — _"the cointegration indicator … to find equity index hedged pairs trades"_, _"long S&P500 … shorting EuroStoxx50 at the same time"_, con **~2 deviazioni standard di divergenza degli z-score** in ingresso e _"exiting on the convergence of the two instrument z-scores"_ in uscita. **E le coppie che nomina sono S&P500↔EuroStoxx50 e S&P500↔Nasdaq: gli analoghi esatti di U30USD↔D30EUR e U30USD↔NASUSD, che quotiamo tutti e tre** |

### 4.4 Scartati al PRIMO TAGLIO (titolo/scheda, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---:|---|
| **order flow / volume delta / footprint / absorption** (`Footprint strategy` 663, `Absorption PRO`, `Delta/Volume Bubble [Quant Z-Score]`, `Post-Absorption VWAP Reversal Engine V1.6`, `Liquidity Grab Strategy (Volume Trap)`, `Delta Volume & POC Pro` ×3, `ZC Footprint Strategy FINAL`, `Falcon Liquidity Grab`) | **~11** | 🔴 **regola Paolo: su forex e CFD il "volume" e' TICK VOLUME**, cioe' il conteggio dei cambi di prezzo, non gli scambi. Un motore la cui variabile di stato e' il volume **non e' misurabile sul nostro feed** |
| **breakout / range / ORB / initial balance** (`Previous Day High and Low Breakout` 954, `Initial Balance BO`, `Initial Balance Panel BTC`, `Range Breakout Strategy`, `Linear Regression Channel Breakout` 736, `CamarillaStrategy -V1 H4/L4 breakout` 2.294, `Camarilla Strategy — breakouts of H4 and L4` 836, `ORB MEEEEEKS`, `HV Spike (HVP + OR Breakout)`) | **9** | 🔴 **famiglia chiusa da ~210 celle a tick** (R45 **0/48**, R12 **48/48 negative OOS**). L'angolo "livelli di giornata" del mandato **cade qui**, e lo dico invece di riaprirlo |
| **trend + pullback / Supertrend / EMA-cross** (`TrendShift Supertrend+ADX`, `AI SuperTrend x Pivot Percentile` **5.335 like**, `Pivot Percentile Trend`, `All-Day Futures Scalper (EMA Trend + Cross + ATR)`, `All-Day Futures Trend Pullback (EMA+RSI)`, `4-EMA Trend & Pullback`, `Gaussian Trend System`, `Ehlers Combo`, `RSI, EMA, SMA Trendtrading — Oil 1H`) | **9** | 🔴 **doppione F5 della spina dorsale** (`SupertrendReversal`, **6 sedie vive**), spesso **piu'** ADX appiccicato (R20, uno degli 0/5) |
| **mean reversion di banda senza regime** (`Konigs \| Bollinger Band Mean Reversion (Session Filter)`, `Mean Reversion — BB + Z-Score + RSI + EMA200`, `Bollinger Bands Fibonacci Ratios` 483, `VWAP Mean Reversion with Session and Volume Filter`) | **4** | 🔴 **R108/R111** (6/6 rosse) + **R60** (12/12 in perdita). E l'ultimo usa **il volume su forex** |
| **cripto / azionario US / fondamentale** (`Put/call ratio cross SPY` 1.027, `Financial Ratios Fundamental`, `Adaptive MVRV & RSI`, `OCC Trend Combo 1 day BTC`, `Crypto BTC Correlation Scalper Gaps`, `BTC Candle Correlation`, `Crypto Volatility Bitcoin Correlation`, `RSI correlation with cryptoindices`, `Sharpe Ratio Forced Selling`, `Velocity To Inverse Correlation to VIX/Bonds`, `Stock Gaps SPY Correlation`, `Heikin Ashi ROC Percentile`) | **~12** | 🔴 fuori strumento (BCM non li quota) oppure **dato fondamentale/derivato che non abbiamo** (put/call ratio, MVRV, VIX) |
| **1 trade al giorno per costruzione** (`Gap Filling Strategy` 1.383, `IU Gap Fill`, `Power Hour Money Strategy`, `Previous Day High Low only for Long`, `Mou Value Areas`, `ORB Heikin Ashi SPY 5min Correlation` 2.305) | **6** | 🔴 **C2 fallita per definizione**: un gap/una fascia/un livello di giornata da' **un'occasione al giorno**, non due |
| **"vN" / marketing / segnale-in-un-menu** (`MNQ 5m V5 AGG Dual Mode`, `TH Dual-Mode-Strategy2.2-5m-Signal-30m-Trend`, `Sunil High-Frequency Strategy with Simple MACD & RSI`, `[XC] Adaptive Strategy V3`, `Tomas Ratio Strategy MTF`, `AxMan Exhaustion Detection Reversal Rider`, `RSI Strategy - Tanner`, `Kaufman's Efficiency Ratio Strategy`, `Gold & EUR/USD` di Fx_Papii **gia' scartato il 01/09**) | **9** | 🔴 il numero di versione **e' il conteggio dei giri di taratura**; MACD+RSI e' famiglia chiusa; `Fx_Papii` era gia' nel §4.4 di ieri |
| **strategie gia' lette in una battuta precedente** (`EURUSD 5min london session strategy` di SoftKill21 = **il promosso del 31/08**, gia' portato in `ABTG_AllineaLondra`; `TrendShift` = S15 del 01/09) | **2** | 🟢 **il dedup ha funzionato**: riconosciute per `imageUrl` e non riaperte |

---

## 5. 🟢 IL PROMOSSO — uno solo, ed e' un MOTORE, non un file

### 🥇 P1 — `RELATIVO` · **la divergenza relativa fra due indici che quotiamo entrambi**, fadata a M5/M15 nella sovrapposizione EU-USA

```
FREQUENZA ATTESA   ~2-3 INGRESSI ESEGUIBILI/GIORNO a M5 (somma dei due lati)
                   ~1 /giorno a M15  (SOTTO il pavimento)
                   [DERIVATA DALLA MECCANICA -- NON dichiarata da nessun
                    autore, NON misurata da noi. Derivazione in 5.4.]
                   🔴 NESSUNO DEI TRE AUTORI SCRIVE UN NUMERO DI FREQUENZA.

NOME               (nostro) RELATIVO -- z-score del rapporto fra due indici
MOTORE PRESO DA    T1 "Pair Trade" (c) vladimirkovalchuk / @wa1one
                     https://www.tradingview.com/script/ru23VN0C/
                     Pine v4, 40 righe, access=1, created 2022-01-15, 279 like
                   T2 "Unilateral Pairs Trading" @pietro3334
                     https://www.tradingview.com/script/MD5vkc0n/
                     Pine v4, 78 righe, access=1, created 2022-01-06, 30 like
NORMALIZZAZIONE    T3 "Statistical Arbitrage Pairs Trading - Long-Side Only"
   ROBUSTA da        @piirsalu  https://www.tradingview.com/script/Kt6XkQIM/
                     (z-score MODIFICATO mediana/MAD -- solo quella formula)
CONFERMA su MT5    G7 m4rk-lewis/price_action_analytics (indicatore, non EA)
                     https://github.com/m4rk-lewis/price_action_analytics
LICENZE            T1/T2: NON DICHIARATE nel sorgente  [VERIFICATO: assenti]
                   T3: non dichiarata · T4 EdgeTools: MPL 2.0
                   🔴 Vedi 5.8: NON si copia codice da T1/T2. Si riscrive
                      la FORMULA (che non e' proteggibile) e si CITA.
COPIE IN CASA      caccia_strategie/biblioteca/sorgenti/
                     PairTrade_OLS_wa1one-vladimirkovalchuk_tv8e024d8c1b75_2026-09-02.pine
                     UnilateralPairsTrading_pietro3334_tvb852187ca0ac_2026-09-02.pine
                     StatArbPairsLongOnly_piirsalu_tvd9bf81d59471_2026-09-02.pine
                   (+ 5 Pine e 2 .mq5 scartati, stessa cartella, stessa data)
```

#### 5.1 🧭 TESI IN UNA RIGA

> _"DAX, Dow e Nasdaq sono lo stesso fattore di rischio guardato da tre fusi
> orari: nella sovrapposizione EU-USA si muovono insieme, ma **non nello stesso
> istante**. Quando uno dei due si stacca dall'altro piu' del suo solito
> — misurato sul **rapporto**, non sul prezzo — la parte di quello scarto che
> e' RUMORE DI ESECUZIONE (e non notizia) rientra. **Non si scambia l'indice:
> si scambia la sua distanza dall'altro.**"_

**Perche' e' una tesi e non una spazzolata:** dice **da dove viene il denaro**
(il ritardo di allineamento fra due mercati sullo stesso fattore) e **quando
NON deve funzionare** (quando lo scarto e' notizia idiosincratica — es. una
trimestrale sulle big tech americane che muove NASUSD e non D30EUR). 🔴 **La
seconda meta' e' la parte falsificabile, e va misurata: se la divergenza non
rientra mai, il motore e' un momentum travestito e si chiude.**

#### 5.2 ⚙️ MECCANICA — letta nel sorgente di T1 e T2, non dalla descrizione

Trascritta dalle righe di T1 (`Pair Trade`) e T2 (`Unilateral Pairs Trading`),
nella variante **UNILATERALE** di T2 (una sola gamba), che e' quella
implementabile senza copertura:

1. **Le due serie, sempre su BARRA CHIUSA (shift 1):**
   `y` = chiusura del simbolo che si scambia (es. `D30EUR`),
   `x` = chiusura del simbolo metro (es. `U30USD`).
2. **Il rapporto** (T2, riga 26): `ratio = y / x`.
   _(T1 usa invece un beta OLS: `beta = correlation(x,y,n)·stdev(y,n)/stdev(x,n)`
   e `spread = sma(y,n) − beta·sma(x,n)`. **Sono due normalizzazioni della
   stessa idea**: il rapporto e' il beta imposto a 1 in log. Vedi 5.6.)_
3. **Lo scarto dalla sua media** (T2, righe 27-30):
   `delta = ratio − sma(ratio, n)` ; `deltaDiff = delta − sma(delta, n)`.
4. **🎯 LA NORMALIZZAZIONE — e' il pezzo che vale** (T2, riga 33):
   `z = deltaDiff / stdev(delta, n)`.
   **Il grilletto non e' un prezzo ne' una soglia fissa: e' un numero di
   deviazioni standard**, quindi **si auto-tara su qualunque coppia, qualunque
   volatilita', qualunque epoca.** E' la stessa proprieta' che ha fatto
   promuovere DayFlow il 01/09 (percentile invece di coda) — qui in forma
   ancora piu' economica. **Il contro-esempio e' T8** (HPotter), che usa
   soglie **assolute** cablate e per questo non e' portabile: la stessa idea,
   morta per non aver normalizzato.
5. **Gli ingressi, simmetrici** (T2, righe 62 e 68):
   `long` se `z < −soglia` (default autore **−1,05**) ·
   `short` se `z > +soglia` (**+1,05**).
6. **L'uscita per convergenza** (T2, righe 64 e 70):
   si chiude quando `z` rientra oltre **∓0,05**, cioe' **quando la divergenza
   e' rientrata** — non a un target di prezzo. **E' un'uscita a EVENTO, con
   tenuta naturale di decine di barre**: e' proprio la forma che il muro
   d'attrito (arXiv 2605.04004 §6.2, tenuta ≥12 barre) premia, e che la
   clausola HFT delle prop (P5) non tocca.
7. **🔴 LA GEOMETRIA NON C'E'.** In T1 e T2 **non esiste stop** (`strategy.exit`
   = 0 in entrambi) e **non esiste take**. **Questo e' il buco, ed e' la parte
   che mettiamo noi** — vedi 5.5 e il §4.1 per il motivo strutturale.

#### 5.3 🚨 BANDIERE ROSSE §4 — **nel MOTORE: nessuna. Nella GESTIONE: tre, tutte nostre da rifare**

🟢 **Nel motore:** niente martingala, niente griglia, niente averaging (i due
Pine hanno `pyramiding=0`), niente hedge di recupero, niente `#import`,
niente `iCustom`, nessun ridipingimento (tutto su `sma`/`stdev`/`correlation`
di serie chiuse), **due lati perfettamente simmetrici**.

🔴 **Nella gestione degli autori (e per questo T1/T2/T3 sono SCARTI):**
**nessuno stop** · **lotto fisso 100** · **niente cap giornaliero**.
Vedi 5.5, tabella "cosa rifarei".

⚠️ **Un rischio §4 che va nominato PRIMA, perche' e' proprio la tentazione di
questa famiglia:** senza stop, un motore di convergenza **e' una griglia a una
gamba** — se lo scarto continua ad allargarsi, la posizione peggiora e la
tesi dice "aspetta ancora". 🔴 **Quindi lo stop non e' rifinitura: e' la
condizione di ammissibilita'. Se dalla misura risultasse che il motore vive
SOLO senza stop, si chiude — non si ammorbidisce il §4.**

#### 5.4 🎯 LA FREQUENZA — la derivazione per intero, perche' sia smontabile

**E' il criterio numero uno del mandato, e nessuno dei tre autori lo scrive.**
Quindi lo derivo, e lo scrivo in modo che si possa falsificare:

| passo | M5 | M15 |
|---|---:|---:|
| finestra 14:30→22:00 server (sovrapposizione EU-USA) = 7,5 h → barre/giorno | **90** | **30** |
| quota di barre con `\|z\| > 1,05` (≈ normale, per costruzione della normalizzazione) | **~29%** | **~29%** |
| segnali **GREZZI**/giorno (somma dei due lati) | ~26 | ~9 |
| 🎯 **ma il grilletto e' un ATTRAVERSAMENTO, non uno stato**: con finestra `n=20` lo z-score compie ~1 ciclo ogni ~30-40 barre | **~2,5 attraversamenti/gg** | **~0,8** |
| ingressi **ESEGUIBILI**/giorno (un solo trade aperto per volta) | 🟢 **~2-3** | 🔴 **~1** |

> ### 🔬 IL PUNTO CHE VALE PIU' DEL CANDIDATO — e la differenza con M0PB **e** con DayFlow
> - **M0PB** armava su un **evento di CODA** (`RSI(6) >= 90`): misurato a
>   **0,52 segnali/giorno**, **0/12 celle**. Morto al PASSO 0.
> - **DayFlow** arma su un **percentile** (25% delle barre per costruzione):
>   frequenza garantita in **STATO**, ma con un cooldown a 10 barre che ne
>   butta via la meta'.
> - **RELATIVO** arma su un **attraversamento di soglia normalizzata**: la
>   frequenza **non dipende dalla volatilita' del mercato**, dipende dalla
>   **finestra `n`** — che e' **un nostro parametro**, non un fatto del
>   mercato. 🎯 **Se n=20 non basta, n=10 raddoppia i cicli. La frequenza e'
>   una MANOPOLA, non una speranza.**
>
> 🔴 **E la conseguenza scomoda, congelata PRIMA della misura: a M15 il
> candidato NON dovrebbe raggiungere il pavimento di 2/giorno (~1).
> Il bersaglio e' M5.** Se la misura dice il contrario, la mia derivazione e'
> sbagliata e va scritto.

#### 5.5 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**🟢 DA TENERE (il motore, ed e' tutto quello che gli autori hanno di buono):**
il **rapporto** fra due simboli come variabile di stato al posto del prezzo ·
la **normalizzazione a z-score** con media e deviazione mobili · la **soglia in
sigma**, non in punti · le **due soglie simmetriche** · **l'uscita per
convergenza** (evento, non target) · `pyramiding=0` · la decisione su **barra
chiusa** di ENTRAMBI i simboli.

**🔧 DA RIFARE (la gestione — la parte che questo progetto sa fare):**

| difetto, con la riga | perche' morde | cosa ci mettiamo |
|---|---|---|
| **`strategy.exit` = 0** in T1, T2, T3 | **senza stop e' una griglia a una gamba** (§5.3) | 🔴 **stop VERO mandato al broker**, a `k × ATR`, dal primo round. E si misura **quanto costa** |
| `default_qty_type=strategy.fixed, default_qty_value=100` (T1 riga 4, T2 riga 3) | **lotto fisso**: non scalabile a 100k, non confrontabile con le altre sedie | **rischio in % dell'equity** sulla distanza dello stop (0,65%) |
| **nessun cap giornaliero** in nessuno dei tre | 2-3 trade/giorno **sullo stesso segnale** concentrano il rischio in una sessione | **`InpMaxTradesPerDay` DAL PRIMO ROUND**, tagliato sul massimo **misurato** dalla sonda |
| **nessun flat di fine sessione** | il muro giornaliero prop si legge solo se la giornata chiude piatta | **flat in ORA SERVER** (BCM = ora italiana − 1) |
| **nessun pavimento SL** | R109 | **`InpMinSLPts` obbligatorio** |
| **nessun filtro di spread** | R55 | **spread come % dello stop**, non in punti — e qui pesa **doppio**, vedi 5.6 |
| z-score classico media/deviazione | **uno spike di feed su un CFD gonfia la `stdev` e SPEGNE il motore per n barre** | 🟢 **lo z-score MODIFICATO di T3** (`0.6745·(x − mediana)/MAD`) come **opzione sweepabile**: e' la sola cosa buona di uno scarto |
| nessun parziale / breakeven | — | **parziale 1R + breakeven + runner**. ⚠️ **NON nel primo round**: prima si misura il motore nudo |
| nessun `OnTester`, nessun magic | il driver non parte | obbligatori |

#### 5.6 ⚠️ I QUATTRO RILIEVI TECNICI — trovati leggendo, e nessuno e' banale

1. 🔴 **IL COSTO SI PAGA DUE VOLTE, MA SI GUADAGNA UNA VOLTA SOLA.**
   Nella forma a **due gambe** (T1, G7) apri due posizioni e paghi **due
   spread** per una sola convergenza. **Per questo il candidato e' la forma
   UNILATERALE di T2**: si scambia **solo** `D30EUR`, usando `U30USD` come
   metro. Un solo spread. 🔴 **La scelta e' NOSTRA e va dichiarata: la forma a
   due gambe e' piu' pura statisticamente e piu' cara operativamente. Non e'
   stata misurata.**
2. ⚠️ **IL SECONDO SIMBOLO NEL TESTER MT5 — la trappola vera.** Il tester
   modella i tick **solo** del simbolo del grafico; del secondo scarica le
   barre. 🔴 **Se si legge il secondo simbolo a `shift 0` si legge una barra
   IN FORMAZIONE, ed e' look-ahead mascherato.** Regola da scrivere nell'EA:
   **entrambe le serie a `shift 1`, e si verifica che i due `time[1]`
   COINCIDANO** — se il secondo simbolo ha un buco (festa americana, DAX
   aperto e Dow no), la barra va **saltata**, non riusata. **Questo controllo
   e' obbligatorio: e' la differenza fra una misura e un artefatto.**
3. 🕳️ **I CALENDARI NON COINCIDONO.** `D30EUR` e `U30USD` hanno **feste
   diverse** (4 luglio, Thanksgiving, Ferragosto, 26 dicembre). Nella finestra
   14:30-22:00 server la sovrapposizione e' quasi piena, ma **i giorni
   spaiati esistono e vanno CONTATI dalla sonda**, non ignorati: sono
   esattamente i giorni in cui il rapporto fa un salto che non e' un segnale.
4. 📏 **IL RAPPORTO NON E' ADIMENSIONALE PER I PUNTI.** `D30EUR/U30USD` ≈ 0,5
   ma la sua **variazione** dipende dai due punti-indice. Lo z-score
   normalizza la **scala**, non il **beta**: se il Dow e' sistematicamente
   piu' volatile del DAX, il rapporto eredita la volatilita' del Dow.
   👉 **Motivo per cui il beta OLS di T1 va tenuto come SECONDA cella
   dell'ablazione, non buttato.**

#### 5.7 💰 IL CANCELLO H8 E LA TAGLIA — l'aritmetica fatta PRIMA di spendere una macchina

🔴 **Qui non posso fare l'aritmetica come per DayFlow, e lo dico invece di
inventarla: il RR non e' nel sorgente, perche' NEL SORGENTE NON C'E' UNA
GEOMETRIA.** Stop e take li mettiamo noi, quindi **RR e' un nostro parametro**
e il cancello H8 si interroga **dopo** la sonda, non prima.

**Quello che la sonda deve restituire perche' H8 sia interrogabile:**

| numero | cancello congelato PRIMA |
|---|---|
| **MFE mediana** dal segnale alla convergenza | **< 3× spread → SCARTO** · 3-6× → **SOSPESO** · > 6× → passa |
| **MAE mediana** dal segnale alla convergenza | dice **dove puo' stare lo stop** senza essere dentro il rumore (R109) |
| **RR = MFE/MAE** | 🖊️ **RR < 0,70 → SCARTO PER ARITMETICA**, senza corsa a tick |

🔴 **E lo spread BCM su `D30EUR`/`U30USD`/`NASUSD` NON esiste in repo.** Il
*RealCost Spread P95 Logger* (Code Base **74148**) e' promosso dal **23/08** e
mai usato: **e' l'OTTAVA caccia che lo scrive.** Finche' non gira, il pavimento
`3× spread` e' tarato su una convenzione, non su una misura.

**Costo di porting, onesto:** **~1 giornata** per l'EA operativo,
**~4-6 ore** per la sola sonda di conteggio riusando lo chassis di
`ABTG_SondaM0PB` (che gia' fa "EA che non fa l'expert": conta, non ordina, ed
esce in colonna da `OnTester`). **La formula e' ~15 righe; il costo sta tutto
nella gestione del secondo simbolo** (rilievi 2 e 3).

#### 5.8 ⚖️ LICENZA E ATTRIBUZIONE — il punto delicato, dichiarato

🔴 **T1 e T2 NON dichiarano licenza nel sorgente** [VERIFICATO: nessuna riga
di licenza in nessuno dei due file; T1 ha solo `// © vladimirkovalchuk wa1`].
Su TradingView `access=1` rende il sorgente **leggibile**, non
automaticamente **riusabile**.

👉 **Regola che applico e che propongo di tenere:** **non si copia una riga di
codice da T1 e T2.** Si riscrive in MQL5 **la formula statistica** — media
mobile, deviazione standard, z-score, correlazione: matematica pubblica, non
proteggibile — e **si cita comunque autore, URL e data in testa al `.mq5`**,
come si e' fatto per `ABTG_AllineaLondra`. 🟢 La sola cosa presa da **T3**
(z-score modificato mediana/MAD) e' anch'essa una formula pubblica
(Iglewicz-Hoaglin), non codice.

#### 5.9 🕳️ IL BUCO CHE RIEMPIE — **verificato nel repo con un `grep`, non supposto**

🟢 **Il buco vero: in flotta NON esiste UN SOLO motore che scambi un simbolo
usando il prezzo di un ALTRO simbolo come SEGNALE.** Misurato:

| cosa c'e' in flotta | cos'e' davvero |
|---|---|
| `ABTG_Bulge`, `ABTG_FiboH4_Multi`, `BREAKOUT_EA_JPY_Multi` | **multi-simbolo** = **lo stesso motore su N simboli**. Non e' valore relativo |
| la correlazione S&P citata nei gate | un **filtro che spegne**, non un motore che decide |
| tutto il resto | **auto-referenziale**: il simbolo contro la propria media, la propria banda, il proprio range |

> 🎯 **E questa e' la distinzione che in casa vale 30 celle su 30.** Il §5B di
> `ROBUSTEZZA.md` dice: filtro **aggiunto dopo** = **0 successi su 5**; filtro
> che **E' la strategia** = `ABTG_EMA200` Dow, R29, **30/30 a PASS pieno**.
> **In RELATIVO il secondo simbolo non filtra niente: senza il secondo simbolo
> NON ESISTE NEMMENO IL SEGNALE.** E' costitutivo per costruzione.

**Gli altri tre buchi che riempie:**
- 🟢 **due lati perfettamente simmetrici** (le celle vive sono quasi tutte
  long-only, `R52_CENSIMENTO_LATI`);
- 🟢 **lavora nel LATERALE**: quando i due indici oscillano senza andare da
  nessuna parte il rapporto continua a divergere e rientrare. E' proprio dove
  **LARRY muore** (**−6.445** nel 2019);
- 🟢 **M5/M15 su indici**, il TF del mandato.

🟠 **E l'adiacenza la nomino io, prima che la trovi Claudio:** la finestra
14:30-22:00 server **si sovrappone all'apertura Nasdaq** (14:30) e alla coda
della sessione DAX. **Regola di rotta 1: mai a rischio pieno insieme alle
sedie di apertura finche' la correlazione fra le serie per-trade non e'
MISURATA.** ⚠️ Ma **il segnale e' di natura diversa** (le aperture sono
direzionali su un evento; questo e' una convergenza su uno scarto), il che e'
la premessa migliore per una scorrelazione vera — **premessa, non misura**.

#### 5.10 🏛️ IN OTTICA PROP

- 🟢 **Attacca il problema vero: la PORTATA.** A ~2-3/giorno il campione dei
  150 si raggiunge in **~3 mesi**, non in anni.
- 🟢 **La clausola HFT non dovrebbe mordere**: l'uscita e' per **convergenza
  dello z-score**, con tenuta naturale di **decine di barre M5** = ore. Il
  vincolo P5 e' max 25% dei trade sotto 60 s; la flotta oggi sta al 4,6%.
  **Ma si misura, non si assume.**
- 🟢 **🎯 E' il candidato piu' interessante di quattro battute sull'asse
  SCORRELAZIONE**, che e' un criterio prop e non estetico: _"il DD della prop
  e' UNO: quello del conto. Accendere N EA a DD basso aiuta solo se NON
  perdono insieme."_ Un motore di **convergenza fra due indici** perde quando
  i due indici **si SCOLLEGANO** — che e' un evento **diverso** da quello che
  fa perdere le sedie direzionali (un movimento contrario). **E' il profilo di
  perdita piu' diverso che abbia trovato.**
- 🔴 **IL RISCHIO PROPRIO, e va scritto per primo perche' e' serio:** questo
  motore ha una **coda a sinistra strutturale.** Tante convergenze piccole e
  poi **una divergenza che non torna** (una notizia che cambia il rapporto in
  modo permanente: cambio di politica BCE/Fed, un crollo settoriale). 🔴 **E'
  ESATTAMENTE la forma che il DD TRAILING punisce** (`DOSSIER_PROP_UPCOMERS`:
  _"trailing drawdowns that shift with your equity"_), e le nostre Monte Carlo
  sono tutte su **DD statico dal deposito**: **col trailing quei numeri non
  valgono, e non e' mai stato ricalcolato.**
  👉 **Conseguenza operativa: su questo candidato la PEGGIOR GIORNATA e la
  peggior SERIE si leggono PRIMA del PF, non dopo.** La nostra peggior
  giornata misurata (R51) e' −2,06%; con 3 trade/giorno correlati a 0,65%
  siamo a **1,95% di rischio aperto**, dentro il cap C1 (3,25%) ma **non
  lontano**.

#### 5.11 📊 PUNTEGGIO

- **[2] semplicita'** — la formula e' **5 righe**; il motore ha **3 parametri
  veri** (finestra `n`, soglia d'ingresso in sigma, soglia d'uscita). Il resto
  degli input e' contenitore (sessione, rischio, cap). **Molto sotto il tetto
  di ~15.**
- **[2] il filtro E' il motore** — 🎯 **voto pieno, ed e' il motivo della
  promozione.** Il secondo simbolo non filtra: **senza di lui non c'e'
  segnale.** Forma `ABTG_EMA200` (30/30), non forma "filtro appiccicato" (0/5).
- **[2] tesi di mercato scrivibile** — §5.1, una riga, **con la condizione di
  falsificazione**.
- **[2] riempie un BUCO** — **quattro insieme, uno verificato col `grep`**:
  (a) **valore relativo**, che in flotta **non esiste**; (b) **due lati
  simmetrici**; (c) **il laterale**, dove LARRY muore; (d) **profilo di
  perdita diverso** = il criterio prop del §7-bis.3.
- **[0] testabile senza riscritture** — 🔴 **voto ZERO, e non lo ammorbidisco.**
  Non esiste **nessun** EA da portare: i tre oggetti letti sono scarti. Si
  scrive da capo (~1 giornata), **piu'** la gestione del secondo simbolo nel
  tester (rilievi 5.6.2 e 5.6.3), che e' la parte in cui si sbaglia.

## **VERDETTO: 🟢 PROVA — 8/10**

**PERCHE':** e' **il primo motore in quattro battute il cui segnale non
esiste senza un secondo strumento** — cioe' l'unico che porta in flotta una
sorgente di rendimento **strutturalmente diversa** da tutte le 14 celle vive,
che sono tutte auto-referenziali. **La frequenza non e' una speranza: e' una
manopola** (la finestra `n`), che e' un argomento piu' forte sia del
percentile di DayFlow sia della coda di M0PB. E la tesi ha una **condizione di
morte scritta prima della misura**. **Perde due punti pieni sul costo**, che e'
il piu' alto di tutte le battute: **niente da portare, tutto da scrivere.**
E come per DayFlow: **questo e' un giudizio DI CARTA prima della misura**,
esattamente come il 9/10 che M0PB aveva la sera del 31/08 prima che la sonda
lo ribaltasse in un'ora.

---

## 6. 📦 IL PASSO 0 — si conta PRIMA, si giudica DOPO

🔴 **Non propongo una griglia. Propongo un CONTATORE**, per la quarta volta e
per la stessa ragione misurata: **le tre fonti dati sono murate e da qui la
frequenza NON si misura** (§2).

📄 **File prova (BOZZA, col cartello):**
`backtest_pipeline/prove/RELATIVO_FREQUENZA_BOZZA.txt`

**I numeri che la sonda deve restituire, coi cancelli congelati LI' DENTRO:**

| # | numero | cancello congelato PRIMA |
|---|---|---|
| 1 | **attraversamenti ESEGUIBILI/giorno per LATO** | 🔴 **< 2,00 (somma dei lati) → SCARTO** |
| 2 | **giorni SPAIATI** (barra presente su un simbolo e non sull'altro) | non e' un cancello: dice quanto sporca il segnale il disallineamento dei calendari (5.6.3) |
| 3 | **MFE mediana** dal segnale alla convergenza | **< 3× spread → SCARTO** · 3-6× → **SOSPESO** |
| 4 | **MAE mediana** dal segnale alla convergenza | dove puo' stare lo stop senza essere dentro il rumore (R109) |
| 5 | **RR = (3)/(4)** | 🖊️ **RR < 0,70 → SCARTO PER ARITMETICA** |
| 6 | **quota di divergenze che NON convergono** entro fine sessione | 🔴 **il numero che uccide o salva la tesi.** Se e' alta, non e' convergenza: e' momentum travestito |
| 7 | **massimo attraversamenti in UNA giornata** | taglia `InpMaxTradesPerDay` **sui dati**. 🚨 se `max × 0,65% > 3,25%` (cap C1) il cap va nell'EA dal primo round |
| 8 | **mediana della TENUTA in barre** + **quota sotto 60 secondi** | **< 12 barre → SOSPESO** (muro d'attrito) · **≥ 25% sotto 60 s → SCARTO PROP** (P5) |
| 9 | **gradiente M5 vs M15** | e' la conseguenza scomoda del §5.4, misurata |

**Coppie:** 🥇 **`D30EUR` scambiato con metro `U30USD`** (lead) ·
**`NASUSD` con metro `U30USD`** (la coppia piu' co-integrata delle tre, e la
stessa che nomina G7) · **`D30EUR` con metro `NASUSD`** (controllo).
**TF: M5 e M15, obbligatorie entrambe. Lati: separati, sempre.**
**Finestra: 14:30 → 22:00 ORA SERVER BCM** (= 15:30-23:00 italiane).

---

## 7. 🧱 DA TENERE AGLI ATTI (spec, non candidati)

### 7.1 🔬 Lo Z-SCORE MODIFICATO (mediana/MAD) — un attrezzo da uno scarto
Da **T3** (`piirsalu`): `0.6745 · (x − mediana(x,n)) / mediana(|x − mediana|,n)`.
Sostituisce media/deviazione con **mediana/MAD**: **una singola candela anomala
non gonfia il denominatore**, quindi il grilletto non si spegne per n barre
dopo uno spike di feed. 👉 **Vale per QUALUNQUE nostro motore normalizzato a
z-score, non solo per RELATIVO.** Costo: 3 righe.

### 7.2 🚨 Il "pairs trading" retail NON mette stop — e ora e' un numero
**7 sorgenti Pine su 8** letti oggi: **zero `strategy.exit`** (§4.1). 👉 **Da
scrivere nel `SETACCIO_MANUALE` come regola di primo taglio:** _"famiglia
pairs/statarb/convergenza: assumere assenza di stop finche' non si e' letta la
riga contraria. Il candidato vale SOLO se lo stop lo mettiamo noi, e il primo
round deve misurare QUANTO COSTA quello stop."_

### 7.3 📏 La soglia ASSOLUTA contro la soglia NORMALIZZATA — il contro-esempio
**T8** (HPotter) e **T1/T2** implementano **la stessa idea**; T8 e' morta
perche' usa `BuyBand=0.9988` cablato, che funziona **solo** su una coppia il
cui rapporto vale ~1. 👉 **Regola generale: una soglia in unita' dello
strumento non e' un parametro, e' un'ipotesi nascosta sullo strumento.**
E' lo stesso argomento del **§R55** (spread come % dello stop, non in punti).

### 7.4 🕳️ Un rilievo di processo — **due giacimenti si stanno chiudendo insieme**
- **TradingView:** **28 query su 68 rendono ZERO strategie** (§3.1).
- **GitHub:** **4 ricerche su 5 rendono lo STESSO pool gia' scartato** (§3.2).

👉 **Non e' "non ho cercato abbastanza": e' che con `api.github.com` murata da
dieci dossier l'unico canale indicizza il POPOLARE, e il popolare l'abbiamo
gia' letto tutto.** **La resa marginale di una QUINTA battuta sulle stesse due
fonti e' bassa e prevedibile**, e va detto prima che qualcuno la ordini.
🎯 **Dove resta materiale non battuto:** i **paper** (arXiv 🟢 200, l'unica
fonte che consegna la tesi prima del codice) e — soprattutto — **il lavoro
gia' pagato in casa**: `ABTG_VwapRevert`, `ABTG_OutOfNoise`, la **Sonda
dell'Orologio**, `ABTG_AllineaLondra` sono **scritti e MAI girati.**

---

## 8. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **FOREX FACTORY, un intero fronte del mandato** | **403 su `curl` E su `WebFetch`** — prima misura indipendente dal trasporto (§2). **Zero pagine viste.** Costo: i thread storici sono l'unico posto dove si legge **come una strategia e' invecchiata**, e quella informazione **non e' stata sostituita con niente** |
| 🔴 **LA FREQUENZA, DI QUALUNQUE CANDIDATO** | **Quarta battuta di fila.** Yahoo, Stooq, Dukascopy: 403 al CONNECT tutte e tre. Quella di P1 e' **[DERIVATA DALLA MECCANICA]**, non misurata |
| 🔴 **UN CLAIM DI FREQUENZA D'AUTORE su P1** | **Non esiste in nessuno dei tre sorgenti.** Il criterio numero uno del mandato e' proprio quello che il web non fornisce mai |
| 🔴 **LO SPREAD BCM MISURATO** su `D30EUR`/`U30USD`/`NASUSD` | **Non esiste in repo.** Code Base **74148** promosso dal 23/08 e mai usato: **OTTAVA caccia** che lo scrive. Finche' non gira, il pavimento `3× spread` e' una convenzione |
| 🔴 **LA CO-INTEGRAZIONE FRA I NOSTRI INDICI** | **Mai misurata.** La tesi di P1 assume che il rapporto `D30EUR/U30USD` sia **stazionario intraday**. **Non e' verificato, ed e' l'ipotesi piu' forte del candidato.** Se non lo e', il motore e' momentum travestito → **e' il numero 6 della sonda** |
| 🟡 **~73 delle ~83 strategie TradingView leggibili** | Ne ho aperte **8**, scelte in bersaglio; le altre sono nel §4.4 col motivo del primo taglio. **8 scarti su 8: il campione dice che il giacimento non e' ricco** |
| 🟡 **`zhutoutoutousan` (48 stelle), sorgente non aperto** | **Dichiarato**: TF H1/H4 = fuori C1. Il TF basta a chiudere senza aprire |
| 🟡 **`Black_Box.mq5` (604 righe) letto per GREP**, non per intero | Verificato: **zero** grid/martingale/recovery, **stessa terna `iBands`+`iMA`+`iATR`** di `DayTradingEA_v2`. Il verdetto si regge su quel grep, ed e' dichiarato cosi' |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato oggi**, tranne gli HTTP e i conteggi di `grep` |
| 🔴 **I numeri di performance degli autori** | **Letti e NON usati in nessun punteggio**, come da C8 |

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Quando D30EUR si stacca da U30USD piu' del solito nella sessione americana, quello scarto RIENTRA — abbastanza spesso da fare 2+ occasioni al giorno a M5, e abbastanza da pagare due volte lo spread di un indice?**

**E' la domanda giusta perche' e' la sola che puo' chiudere il candidato senza
scrivere un EA operativo**, e perche' la risposta **vale oltre il candidato**:

- se la **quota di divergenze che NON convergono** (numero 6) e' alta, allora
  **non e' convergenza, e' momentum travestito**: il candidato muore, e con
  lui muore **l'intera famiglia valore-relativo** per il nostro banco — che e'
  un risultato definitivo, non un forse;
- se **converge ma la MFE non paga 3× spread**, allora la tesi e' vera e
  **inutile sugli indici** — e la domanda si sposta sul **forex major**, dove
  lo spread relativo e' molto piu' sottile (EURUSD↔GBPUSD, entrambi in
  quota di dollaro);
- se **passa a M5 e non a M15**, e' esattamente la conseguenza scomoda scritta
  nel §5.4 **prima** della misura, e la derivazione regge;
- se **passa**, allora la flotta guadagna la sua **prima sorgente di
  rendimento non auto-referenziale**, che e' il pezzo che manca al portafoglio
  prop piu' di un altro motore direzionale.

**E se il contatore dice di no su tutta la linea, quella e' una risposta utile
quanto un promosso**, perche' chiude con un numero una direzione di caccia che
altrimenti si riapre ogni settimana.

---

_Dossier chiuso il 02/09/2026. **68 query TradingView in 7 ondate** (di cui
**28 a resa ZERO**) + **5 ricerche GitHub**; **~126 strategie TradingView
censite**, **~30 repo GitHub visti** e **7 aperti davvero**; **3 fonti
sottoposte a controllo positivo misurato oggi: 2 vive, 1 (Forex Factory)
NULLA su due trasporti indipendenti**; **10 oggetti letti nel sorgente**
(8 Pine scaricati integrali + 1 `.mq5` da 748 righe letto per intero +
1 `.mq5` da 604 righe sondato per grep), **tutti e 10 archiviati in
`biblioteca/sorgenti/`**; **1 promosso (un MOTORE, non un file), 0 in coda,
4 spec, 15 scarti motivati nel sorgente + ~62 scarti al primo taglio**;
**1 aggiornamento misurato al `PROMEMORIA_SBLOCCO_FONTI`** (FF murata al
dominio, non al trasporto).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato, niente
toccato in forward.**_
