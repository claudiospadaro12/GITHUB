# CACCIA UNGER — INGRESSI, USCITE, FILTRI (24/09/2026)

_Richiesta di Claudio del 24/09/2026: parametri e metodi CONCRETI di Andrea Unger
per migliorare i nostri EA MQL5, niente teoria generica. Perimetro di questo
dossier: pilastri 1 (architettura/ingressi), 2 (uscite), 3 (filtri / data mining)._

Precedente letto prima di uscire (non rifatto): `CACCIA_ANDREA_UNGER_2026-09-14.md`
(16 fonti primarie bloccate, lista della spesa §7), `prove/SMASH_DAY_TESI.md`
(OOPS portato da Claudio), `risultati_archivio/REFERTO_ROUND38_PUNTE_LARRY.md`
(OOPS = 0 trade su 288 celle sul CFD quasi-24h), `report/SECONDA_CACCIA_2026-09-12.md`
§4 (gamba notturna su indice: CHIUSA per rischio).

> ✏️ **ERRATA del 24/09 sera (cancello su `report/METODO_UNGER_2026-09-24.md`)**: al §6 e al §7 ipotesi A, *"D1 mai"* e *"R133a ha girato"* sono **falsi**. R133a non e' mai stato lanciato; D1 come valore FISSO ha gia' girato sul DAX in BREAKOUT (`risultati_archivio/DAX_Apertura/apert_DAX_M5_doc_brk_realtick_D30EUR.csv`, 119 passate, n 61-71, PF 0,52-2,12). E il braccio RANGE_FADE ignora `InpSLMode`/`InpBufferPoints` (stop ATR, r.1277-1279): i due bracci differiscono in stop e livello. Versione corretta nel referto di sintesi. Classe 773.

---

## 0. LA RIGA CHE CONTA

> **Su 87 host provati, 9 rispondono, 73 sono bloccati dal proxy, 5 rifiutano o
> sono murati in altro modo. Le fonti primarie di Unger restano TUTTE
> irraggiungibili. Ma questa volta c'e' UN pezzo di meccanica di Unger letto nel
> sorgente** — il *Weekly Factor* (TASC settembre 2023), ripubblicato in Pine da
> PineCodersTASC su TradingView — **piu' ~50 regole e numeri raccolti dagli
> snippet** (etichettati tali), **e due sonde mie che certificano l'ESISTENZA
> degli eventi di Unger su dati DAX 2011-2018** (lezione OOPS applicata PRIMA
> di proporre un test, non dopo).
>
> **Tre ipotesi di test, tutte su EA che abbiamo gia'. La prima si lancia con i
> soli input, zero righe di codice.**

Etichette usate, una per affermazione:
`[VERIFICATO: <URL>]` pagina/sorgente aperto davvero · `[SNIPPET: <URL>]`
riassunto del motore di ricerca su pagina NON aperta · `[TERZI: <URL>]` fonte
non-Unger che attribuisce a Unger · `[INFERITO]` ragionamento mio (dico da cosa) ·
`[MISURATO-SONDA]` numero prodotto da una sonda mia, su dati non-BCM.

---

## 1. CONTROLLO POSITIVO, FONTE PER FONTE

| fonte | bersaglio noto | esito |
|---|---|---|
| **TradingView** (`pubscripts-suggest-json`) | query `weekly factor` deve restituire `TASC 2023.09 The Weekly Factor` di PineCodersTASC | PASS: restituito con id `PUB;80b17057063a4a54ad73d16e292d1eec` |
| TradingView, stessa API | query `unger` | **0 risultati**. Stavolta la misura DISTINGUE (la stessa API risponde su altre query): chiude l'`[INCERTO]` del 14/09 §2.1 — nessuno script TradingView ha "unger" nel titolo |
| **TradingView** `pine-facade` (sorgente) | sorgente del PUB sopra | PASS: 118 righe Pine v5, `scriptAccess: open_no_auth` |
| **GitHub** ricerca repository (web) | `mql5 expert advisor` | PASS: `yulz008/GOLD_ORB` 295 stelle, `geraked/metatrader5` 648 stelle agg. 15/11/2025 |
| GitHub ricerca **codice** | `unger easylanguage` | NULLA: "Sign in to search code on GitHub" |
| GitHub API `search/*` | qualunque | NULLA strutturale: "sessions are bound to their configured repositories" (come le 5 cacce precedenti) |
| **raw.githubusercontent.com** / `git clone` | FutureSharks/financial-data, ferranfont/Unger_opening_range_breakout | PASS |
| **arXiv** | ricerca `overnight returns index` | PASS (2 risultati), non usato per Unger |
| **WebSearch** | — | FUNZIONA: 70 query fatte |

Fonti NULLE (bloccate, non "inesistenti": vanno riprovate da una postazione senza
blocco): `ungeracademy.com` (blog EN e IT), `bettersystemtrader.com`, `youtube.com`,
`it.wikipedia.org`, **`www.traders.com`** (Traders' Tips con il codice EasyLanguage
ufficiale del Weekly Factor), **`www.prorealcode.com`** (codice ProRealTime "DAX 5 min
automated trading by Andrea Unger" + thread "Compressed candle, an Andrea Unger
strategy"), `benzinga.com` / `it.benzinga.com` (Unger vi pubblica articoli con codice),
`blog.ilgiornale.it` (blog di Unger "Analisi tecnica e trading system"),
`forexup.altervista.org` (porting in MetaTrader del filtro di indecisione).
Elenco completo in §8.

---

## 2. PILASTRO 1 — ARCHITETTURA E LOGICA D'INGRESSO

### 2.1 Il principio: prima il GRILLETTO, poi il setup

- Parte dal **meccanismo d'ingresso** (stop order su un livello, limit su un supporto/
  resistenza) e **solo dopo** cerca i setup/pattern attorno a quell'ingresso; usa
  "around 40 basic patterns" raggruppati in volatilita', direzionali, neutri
  `[SNIPPET: https://bettersystemtrader.com/045-andrea-unger/]`.
- Un modello base (trend-following, contro-trend o BIAS) SENZA pattern, poi si
  aggiungono filtri dalla libreria di pattern
  `[SNIPPET: https://learn.ungeracademy.com/courses/trading-systems-supremacy/lessons/welcome-to-module-3-the-unger-method/]`.
- I pattern sono "not so much as a starting point but rather as a filter applied
  to the 'engine'" `[SNIPPET: https://benzinga.com/trading-ideas/23/11/35701496/trading-the-nasdaq-improving-a-strategy-with-the-day-drop-pattern-as-a-downtrend-filter]`.

> **Attenzione, e va detto subito: questa e' l'architettura che in casa ha fatto
> 0 su 5** ("filtro aggiunto dopo a un motore gia' tarato": R20, R12, R26, R45, R54 —
> mandato §5B). Unger la fa funzionare con 30-40 mercati e un portafoglio; noi no.
> Quindi dal suo metodo si prende **il MOTORE base e il test delle due logiche**,
> e i pattern si provano **solo se dichiarati costitutivi prima dei numeri** (ipotesi C, §7). `[INFERITO]`

### 2.2 Come decide trend-following contro mean-reverting: il test delle "2 righe"

```
IF   test_trend:   buy  next bar at High[ieri] STOP ;  sellshort next bar at Low[ieri] STOP
IF   test_revert:  buy  next bar at Low[ieri]  LIMIT;  sellshort next bar at High[ieri] LIMIT
     (timeframe giornaliero; stessi livelli, cambia solo il TIPO di ordine)
THEN il mercato "e' trend" se vince il primo, "e' mean-reverting" se vince il secondo
```
`[SNIPPET: https://ungeracademy.com/blog/mean-reverting-or-trend-following-find-it-out-with-2-lines-of-code-btc-and-eth]`
— esempio sull'articolo: Bitcoin risulta trend-following (stesso snippet).

- Per mercato, non per test su tutto: indici azionari USA (Mini S&P, Nasdaq) e T-Note
  10 anni nel paniere **mean-reverting**, commodity classiche nei panieri
  **trend-following** `[SNIPPET: https://algoadvantage.substack.com/p/038-andrea-unger-672-returns-sure]`.
- Contraddizione da registrare: un'altra pagina dice che il **Nasdaq** ha
  "a slightly more pronounced trend following tendency" rispetto al Mini S&P
  `[SNIPPET: https://blog.ilgiornale.it/analisi-tecnica/2023/03/10/strategia-trend-following-sul-nasdaq-opening-range-breakout-per-il-trading-automatico/]`,
  e le 4 strategie Nasdaq del blog sono trend-following/breakout
  `[SNIPPET: https://ungeracademy.com/blog/nasdaq-trading-trend-following-breakout-strategies]`.
  I due snippet non sono conciliabili senza aprire le pagine.

### 2.3 Le strategie note, con le regole che si leggono

| # | nome | regole (IF-THEN) | numeri | etichetta |
|---|---|---|---|---|
| E1 | **Weekly Factor** (TASC set. 2023, "Finding Compression And Expansion") | IF corpo 5gg `|O(-5)-C(-1)|` < `RangeFilter` x range 5gg `(maxH-minL)` THEN attiva il giorno. IF attivo AND barra M15 n.2..90 della sessione chiude > High[ieri] THEN long a mercato; chiude < Low[ieri] THEN short. Esci su cambio sessione (`strategy.close_all()`) | `RangeFilter` default **0.5**, range 0..1 passo 0.1; TF **15 minuti obbligatorio** (`runtime.error` altrimenti); finestra barre `BarCounter > 1 and < 91` | `[VERIFICATO: https://www.tradingview.com/script/X4mjqjeE-TASC-2023-09-The-Weekly-Factor/]` sorgente letto via `pine-facade`, PUB;80b17057063a4a54ad73d16e292d1eec, creato 12/08/2023 |
| E2 | **Breakout del giorno prima, DAX** | long alla rottura del massimo della sessione precedente, short al minimo; filtri pattern proprietari; chiusura a fine sessione salvo SL/TP | TF **15 min**, sessione storica **8:00-22:00** | `[SNIPPET: https://ungeracademy.com/blog/breakout-strategies-dax-futures-2025]` |
| E3 | **Breakout intraday DAX** (variante) | long sul **piu' alto fra massimo di oggi e di ieri**, short sul piu' basso fra minimo di oggi e di ieri; flat a fine giornata | — | `[SNIPPET: https://ungeracademy.com/it/blog/strategie-trading-dax-breakout-bias]` |
| E4 | **DAX First Hour** | range della prima ora del **future** (08:00-09:00 CET), ordini nella **seconda ora del future = prima ora del cash**; livelli dal massimo/minimo della prima ora con "displacement of **75%** of the range"; valido tutti i giorni **tranne il venerdi'**; esce a fine giornata o, se ritraccia, sull'estremo della prima ora | 75%; checktime 9:15 su barre 15 min | `[SNIPPET: https://tradingnut.com/step-by-step-trading-strategy/]` · `[SNIPPET: https://ungeracademy.com/blog/dax-first-hour-strategy-last-year-performance]` · `[SNIPPET: https://it.benzinga.com/news/usa/trading/trading-dax-analisi-opening-range-breakout-orb-codice-strategia-ottimizzazioni/]` · `[TERZI: https://www.prorealcode.com/prorealtime-trading-strategies/dax-5-min-trading-strategy-by-andrea-unger/]` ("first hour of trading (08:00-09:00 AM)", richiede un indicatore "Dfactor") |
| E5 | **Euro FX breakout** | long/short alla rottura di massimo/minimo di ieri; filtro orario; filtro di volatilita' sulla sessione precedente; SL + TP + **uscita a tempo 5 giorni** | 5 giorni | `[SNIPPET: https://ungeracademy.com/it/blog/analisi-di-una-strategia-sulleuro-fx-funziona-in-e-out-of-sample]` |
| E6 | **Trend-following "4 giorni"** | TF 1440 minuti; long/short alla rottura del canale degli ultimi **4** giorni; stop monetario **$2.000** | 4 gg, $2.000 | `[SNIPPET: https://ungeracademy.com/blog/the-simplest-trading-strategy-trend-following-mean-reverting-or-breakout]` |
| E7 | **Oro, breakout H1** | TF 60 min; rottura di una barra oraria a canale stretto, conferma in 1-5 barre; short con canale piu' lungo (minimo di 3 barre); long chiuso all'**1:00**, short alle **9:00** ora di borsa | stop **$1.700** | `[SNIPPET: https://ungeracademy.com/blog/breakout-strategy-on-hourly-bars-how-does-it-work-example-on-gold]` |
| E8 | **Nasdaq, esplosione di volatilita'** | livello = **apertura della sessione +/- k x ATR**; ingresso se una barra M15 chiude oltre; flat a fine sessione salvo SL/TP | ottimizzazione k da 1 a 10 passo 0.5: scelti **5.5 long, 8 short**; variante con **ATR a 200 periodi** | `[SNIPPET: https://it.benzinga.com/news/usa/trading/trading-sul-nasdaq-sfruttare-le-esplosioni-di-volatilita-con-una-strategia-basata-su-atr/]` · `[SNIPPET: https://ungeracademy.com/blog/trend-following-nasdaq-volatility]` |
| E9 | **Falso breakout (reversal) DAX / oro** | short sul falso breakout del massimo di ieri, long sul falso breakout del minimo; oro: falsi breakout long misurati su M5, short su M15; short chiusi sempre a fine giornata | — | `[SNIPPET: https://ungeracademy.com/blog/mean-reverting-and-bias-strategies-on-dax-refine-your-portfolio]` · `[SNIPPET: https://ungeracademy.com/blog/intraday-strategies-on-gold-that-trade-against-the-trend-or-or-rules-performance]` |
| E10 | **Bias overnight DAX** | long ogni giorno nel tardo pomeriggio, uscita all'apertura del cash; filtri sul giorno precedente; SL/TP | ingresso **17:15** oppure **17:30** oppure **17:45** (tre snippet discordi), uscita **9:00**; una versione esclude il **venerdi'** | `[SNIPPET: https://ungeracademy.com/it/blog/strategie-trading-dax-breakout-bias]` · `[SNIPPET: https://ungeracademy.com/blog/dax-trading-strategies-breakout-bias]` · `[SNIPPET: https://ungeracademy.com/blog/dax-systematic-trading-how-two-bias-strategies-generated-eur90-000-in-one-month]` ("5:00-6:00 PM", uscita "8:00-9:00 AM") |
| E11 | **Intraweek bias** | medie delle variazioni per giorno della settimana; esempio: long il terzo giorno della settimana alle 5:00, chiuso venerdi' a fine sessione; short domenica 18:15, chiuso la sessione dopo alle 17:00 | — | `[SNIPPET: https://ungeracademy.com/posts/bias-systems-trading-seasonal-market-patterns]` |
| E12 | **Regola "contrarian di ieri"** | IF chiusura di ieri < chiusura dell'altro ieri THEN buy stop sul massimo di ieri; IF chiusura di ieri > altro ieri THEN sell stop sul minimo di ieri | — | `[SNIPPET: https://ungeracademy.com/blog/my-trading-system]` |
| E13 | **Le origini (campionati)** | breakout intraday su DAX e S&P: massimo/minimo delle prime **2-3 ore**, niente take profit, uno stop | — | `[SNIPPET: https://bettersystemtrader.com/016-andrea-unger/]` |
| E14 | **OOPS** | — | — | **GIA' CHIUSO IN CASA**: R38, 0 trade su 288 celle. Non si rifa'. |

Materiale di TERZI letto nel sorgente (tutto `[VERIFICATO]` come esistenza, nessuno e' di Unger):
- `ferranfont/Unger_opening_range_breakout` (GitHub, Python, 0 stelle, ultimo commit
  13/05/2025, nessuna licenza nel repo): commento r.1 di `main.py` *"ANDREA UNGER
  TRADING SYSTEM BREAK OUT OPENING RANGE"*, ma la meccanica e' **dell'autore**
  (fractal "patito negro", range 60 minuti prima delle 15:30 Madrid su ES, stop =
  massimo del range meno 4 punti, target = ingresso +10 punti fissi, chiusura a fine
  giornata: `order_entry_managment.py` r.63-67, r.148-152). **Scarto**: target e stop
  in punti fissi, attribuzione non verificabile, ricerca su dati non inclusi.
  `[VERIFICATO: https://github.com/ferranfont/Unger_opening_range_breakout]`
- `Daily Factor Indicator [CC]` di cheatcountry (TradingView, MIT, 29/05/2023):
  `df = |O[1]-C[1]| / (H[1]-L[1])`, soglia default **0.35**, anti-repaint esplicito.
  **Non cita Unger**: il nome coincide con il "Daily Factor" di Unger
  `[SNIPPET: https://ungeracademy.com/blog/the-best-price-pattern-for-trading-you-probably-don-t-know-this-one]`,
  la formula e' quella del suo filtro di indecisione, ma l'attribuzione e' `[INFERITO]`.
- Gist `18182324/83605f58473496cbd49c78398aecd89a` "Range Bound Strategy [EasyLanguage]":
  **non cita Unger**, scartato come rumore della ricerca.

### 2.4 Setaccio §4 sul Weekly Factor (l'unico sorgente di Unger letto)

| bandiera | esito |
|---|---|
| martingala / griglia / recovery | nessuna: `strategy.entry` singolo, nessuna somma di posizioni |
| **stop loss** | **ASSENTE nella versione TASC** (nessun `strategy.exit` con stop). E' una dimostrazione didattica, non un EA: l'uscita e' solo il cambio sessione. Da noi lo stop si aggiunge (rifinitura di casa), non si toglie |
| repaint / look-ahead | `request.security(..., 'D', ...)` senza `lookahead` esplicito = default `lookahead_off` in v5: sullo storico legge i giorni CHIUSI. In tempo reale il valore giornaliero si aggiorna durante la giornata (ridipinge in live) `[INFERITO dal sorgente, r. getOHLCValues]`. Irrilevante per un porting MQL5 che usa `iHigh(_Symbol,PERIOD_D1,1)` |
| codice morto | `if DayCounter > 1 and strategy.openprofit > 0` (una "first profitable open") non scatta mai, perche' `strategy.close_all()` chiude gia' a ogni nuova sessione `[INFERITO dal sorgente]` |
| input | 1 solo (`RangeFilter`) |

---

## 3. PILASTRO 2 — USCITE

### 3.1 Regole (IF-THEN)

```
STOP LOSS   : IF perdita del trade >= importo monetario fisso per contratto THEN chiudi
              (metodi citati: monetario fisso / punti / % / ATR; "a strategy without any
               kind of stops isn't safe at all")
TAKE PROFIT : IF logica trend-following THEN niente TP ("let the trend develop")
              IF contro-trend / rimbalzo / swing / esplosione THEN TP si'
BREAKEVEN   : IF profitto >= soglia BE THEN stop all'ingresso; soglia "ne' troppo
              piccola ne' troppo grande", legata all'orizzonte e agli altri ordini
TRAILING    : di norma NO (DAX, ES, Crude: "doesn't generally give any benefit");
              si' su crypto
TEMPO       : IF intraday THEN flat a fine sessione (SetExitOnClose)
              IF multiday THEN uscita dopo N giorni/barre (BarsSinceEntry > N)
              variante: tieni oltre la fine giornata SOLO le posizioni in PERDITA
              ("Open Position Profit"), per recuperare nella seduta dopo
```

### 3.2 Numeri, ciascuno con la sua fonte

| voce | valore | etichetta |
|---|---|---|
| stop monetario, TF "4 giorni" | **$2.000** | `[SNIPPET: https://ungeracademy.com/blog/the-simplest-trading-strategy-trend-following-mean-reverting-or-breakout]` |
| stop oro H1 | **$1.700** | `[SNIPPET: .../breakout-strategy-on-hourly-bars-how-does-it-work-example-on-gold]` |
| stop OOPS DAX (video del team, gia' in casa) | **2.000 EUR** | `SMASH_DAY_TESI.md` fonte 6 (materiale portato da Claudio) |
| stop OOPS (trascrizione, gia' in casa) | **1.500 EUR** | `SMASH_DAY_TESI.md` r.152 |
| esempio stop FDAX | **2.500 EUR** per contratto | `[SNIPPET: https://ungeracademy.com/posts/how-to-use-stop-loss-in-systematic-trading-complete-guide]` |
| **stop fisso contro stop %** (EUR/USD) | due snippet DISCORDI: "fixed stop of **60-70 pips** (normally, using **100 pips**)" meglio del percentuale · "fixed **100-pip** stop" meglio del percentuale | `[SNIPPET: https://ungeracademy.com/blog/fixed-or-percentage-stop-loss]` (riportati entrambi) |
| stop in dollari contro ATR | Kevin Davey "had found that dollar-based stops actually worked better than ATR stops"; Unger d'accordo | `[TERZI: https://kjtradingsystems.com/algo-trading-tip-dollar-vs-atr-stop-losses.html]` (pagina NON aperta: e' anche SNIPPET) |
| SetStopLoss contro SetProfitTarget in soldi o punti | risultati "identici al 100%" | `[SNIPPET: https://ungeracademy.com/blog/stop-loss-and-take-profit-how-to-set-them-properly-and-avoid-issues-in-live-trading]` |
| breakeven | nessun numero; avvertenza: BE molto stretti non si testano bene se la barra del backtest e' piu' larga della soglia | `[SNIPPET: https://ungeracademy.com/posts/how-to-use-the-breakeven-stop-in-systematic-trading]` |
| trailing | "improved performances very seldom"; inutile su DAX/ES/Crude, utile su crypto; inaffidabile in backtest su alcune piattaforme | `[SNIPPET: https://ungeracademy.com/blog/trailing-stop-loss-and-trading-systems-how-to-use-it-and-does-it-really-work]` |
| uscita a tempo multiday | **5 giorni** (Euro FX); "max **10 barre**" (su H1 = 10 ore) | `[SNIPPET: .../analisi-di-una-strategia-sulleuro-fx...]` · `[SNIPPET: https://ungeracademy.com/blog/6-well-performing-strategies-created-with-the-unger-method-tm-by-our-students]` |
| codice uscita a tempo | `if BarsSinceEntry > 5 then sell next bar at market` (affidabile su D1) | `[SNIPPET: https://ungeracademy.com/blog/power-languages-setexitonclose-how-to-use-it-in-backtest-and-live-trading]` |
| uscita a ora fissa | oro: long all'**1:00**, short alle **9:00**; bias DAX: **9:00** | vedi E7, E10 |
| "Open Position Profit" | tieni oltre la fine giornata solo se in perdita; strategia DAX in uso dal **2017** | `[SNIPPET: https://ungeracademy.com/blog/how-to-set-trading-exits-based-on-the-profit-loss-of-the-current-trade-example-strategy-on-dax]` |

### 3.3 Gia' in casa?

| meccanica Unger | in casa | dove (file:riga) | nota |
|---|---|---|---|
| flat a fine sessione | SI | `ABTG_DAX_Apertura_EU.mq5` r.266-268 (`InpCloseHour/Min`, `InpCloseAtEnd`) · `ABTG_OutOfNoise.mq5` r.158-159 · `ABTG_IntradayMomentum.mq5` r.136 | identico a `SetExitOnClose` |
| uscita a N giorni/barre | SI | `ABTG_PunteLarry.mq5` r.162 (`InpMaxDaysHold=5`) · `ABTG_CostToCost.mq5` r.163 (`InpMaxBarsHold`) | il "5 giorni" di Unger coincide con il nostro default su PunteLarry `[INFERITO: coincidenza, non derivazione]` |
| first profitable open | SI | `ABTG_PunteLarry.mq5` r.148 (`InpExitMode=0`) | |
| uscita a ora fissa | SI | `ABTG_SondaOrologio.mq5` r.176-184; `ABTG_TurnaroundTuesday.mq5` r.258-259 | |
| stop monetario fisso | **NO, per scelta** | rischio % su stop in prezzo ovunque (`LotByRisk`, `ABTG_EMA200.mq5` r.467-495, v. caccia 14/09 §2.2) | un stop in EUR fissi non scala fra simboli (`SMASH_DAY_TESI.md` r.152). L'equivalente nostro e' stop in punti/ATR + rischio % |
| stop ATR | SI | `ABTG_DAX_Apertura_EU.mq5` r.326-327 (`InpSLMode`, `InpAtrSlMult`) · `ABTG_PunteLarry.mq5` r.152-154 (ATR D1) | |
| breakeven | SI | `ABTG_DAX_Apertura_EU.mq5` r.331-332 (`InpBreakevenAtTP1`, `InpBEatR`) · `ABTG_VolExpBreak.mq5` r.229-230 | **coerente con la sua cautela**: sul Dow "niente BE: 6 confronti puliti su 8 in perdita" (`ABTG_Dow_Apertura_US.mq5` r.287) |
| trailing "quasi mai utile" | **CONTRADDETTO in casa** | `ABTG_Dow_Apertura_US.mq5` r.289-292: trailing a base candela M5, PF **1,24 -> 1,37**, DD **6,9% -> 5,3%** | la nostra misura batte il suo generico. Si tiene la nostra |
| "Open Position Profit" (tieni i perdenti la notte) | NO | — | 🔴 **da NON importare**: e' esposizione notturna condizionata alla perdita. La gamba notturna su indice in casa e' **chiusa per rischio** (`report/SECONDA_CACCIA_2026-09-12.md` §4.3: la notte del 16/03/2020 costa **1,51 anni di edge**, invariante allo stop). Non e' una bandiera §4 (lo stop resta), ma e' la forma che il DD giornaliero prop punisce |

---

## 4. PILASTRO 3 — FILTRI E DATA MINING

### 4.1 Regole (IF-THEN) e numeri

| filtro | regola | numero | etichetta |
|---|---|---|---|
| **Weekly Factor** (compressione 5 giorni) | opera solo se `|O(-5)-C(-1)| < RF x (maxH5 - minL5)` | RF = **0.5** default | `[VERIFICATO: sorgente Pine TASC, v. E1]` |
| **Daily Factor / indecisione** | opera solo dopo un giorno con `|O-C| < x x (H-L)` | x = **25%** | `[SNIPPET: https://ungeracademy.com/blog/the-sooner-you-start-to-apply-this-pattern-the-better]` e versione IT `[SNIPPET: https://ungeracademy.com/it/blog/prima-inizierai-ad-applicare-questo-pattern-meglio-sara-per-te]`. Articolo originale del **2012** `[SNIPPET: https://forexup.altervista.org/viewtopic.php?t=3963]` |
| stesso filtro, porting MetaTrader di terzi | "positions are opened only if the candle body size of the previous day is **50%** of the range" | 50% | `[TERZI: https://forexup.altervista.org/viewtopic.php?t=3963]` (bloccato: SNIPPET) — discorde col 25% |
| effetto dichiarato del filtro | "loses one-third of performance" ma trade medio e DD migliorano | — | numero d'autore, **NON verificato, non pesa** |
| **Day Drop** (tendenza ribassista di ieri) | `(closeS(1)-lowS(1)) < DayDropValue*(highS(1)-lowS(1))`, `DayDropValue` fra 0 e 1, piu' basso = piu' selettivo | 0..1 | `[SNIPPET: https://store.traders.com/stcov413ddrp.html]` (S&C V.41:04, a pagamento) · `[SNIPPET: https://benzinga.com/trading-ideas/23/11/35701496/...]` |
| barra d'espansione | "a large range bar that is larger than the previous bar normally inhibits the trend" | — | `[SNIPPET: https://ungeracademy.com/blog/patterns-in-trading]` |
| giorno della settimana | E4: tutti tranne il **venerdi'**; esempio IT: escludere il **lunedi'**; Nasdaq: lun-gio al rialzo, venerdi' al ribasso; Crabel/Nasdaq: filtro weekday che "migliora molto gli short" | — | `[SNIPPET: tradingnut.com]` · `[SNIPPET: https://ungeracademy.com/it/blog/trading-algoritmico-come-costruire-sistema]` · `[SNIPPET: blog.ilgiornale.it 2023/03/10]` · `[SNIPPET: https://ungeracademy.com/blog/testing-toby-crabel-s-opening-range-breakout-does-it-really-work-code-backtest-on-nasdaq]` |
| mese dell'anno | filtri su giorno e **mese** (strategia DAX di uno studente) | — | `[SNIPPET: https://ungeracademy.com/blog/dax-futures-trend-following-strategy-giuseppe]` |
| movimento estremo di ieri | "trading was restricted when there was extreme directional movement in the prior day" | — | `[SNIPPET: https://ungeracademy.com/blog/dax-first-hour-strategy-last-year-performance]` |
| ADX | il suo indicatore preferito, usato **solo come filtro**; soglia da ottimizzare, "the theoretical threshold values aren't actually the best" | — | `[SNIPPET: https://ungeracademy.com/blog/my-favorite-indicator]` · `[SNIPPET: https://ungeracademy.com/blog/trading-with-adx-discover-the-levels-that-really-work-and-why]` |
| VIX | inibisce il sistema se il VIX e' in cima al ranking delle ultime **100** osservazioni | 100 | `[SNIPPET: https://ungeracademy.com/blog/volatility-risk-or-opportunity]` |
| stretch (Crabel, testato da Unger) | media su **10** giorni della distanza fra l'apertura e l'estremo piu' vicino; sessione cash Nasdaq **08:30-15:00 CME** | 10 gg | `[SNIPPET: .../testing-toby-crabel-s-opening-range-breakout...]` — conclusione dichiarata: gli ORB "don't work very well anymore" |

### 4.2 Come li seleziona senza overfitting

- **Non usa il walk-forward**: "Andrea Unger considers WFA a good analysis method,
  nevertheless he doesn't use it", per il modo in cui costruisce i sistemi; al suo
  posto **test di stabilita' dei parametri** (piccole variazioni attorno ai valori
  scelti) `[SNIPPET: https://ungeracademy.com/blog/walk-forward-analysis]` ·
  `[SNIPPET: https://bettersystemtrader.com/074-deeper-optimization-with-andrea-unger/]`.
  **Seconda fonte indipendente che dice la stessa cosa della caccia del 14/09 §3.1**
  — ma resta SNIPPET: la domanda del 14/09 **non e' chiusa**, e' solo piu' probabile.
- L'ottimizzazione serve "not to find the best values, but to get a deeper
  understanding of the markets" `[SNIPPET: bettersystemtrader.com/074]`.
- Pochissime righe: sistemi da **3 righe** di codice (Feeder Cattle, RBOB)
  `[SNIPPET: https://ungeracademy.com/it/blog/mito-o-realta-possiamo-creare-strategie-di-trading-efficaci-con-solo-3-righe-di-codice]`.
- IS/OOS dichiarato nelle schede ("out of sample for many years")
  `[SNIPPET: .../breakout-strategies-dax-futures-2025]`.

### 4.3 Gia' in casa?

| filtro Unger | in casa | dove | nota |
|---|---|---|---|
| **Weekly Factor / Daily Factor sul D1** (corpo/range del giorno o dei 5 giorni prima) | **NO** | grep degli `input` su 115 EA: i filtri corpo/range esistenti sono tutti sulla **candela di segnale**, non sul regime del giorno prima (`ABTG_PTE.mq5` r.64 doji <=10%, `ABTG_ORB.mq5` r.144, `ABTG_BreakingBand.mq5` r.323, `ABTG_FiboH4_Corso.mq5` r.230) | **buco vero**, e piccolo da colmare (1 input, ~15 righe) |
| giorno della settimana | PARZIALE | `DAX_MASTER_PROP.mq5` r.266-271 (maschera lun-ven) + r.1607-1619; `ABTG_TurnaroundTuesday.mq5` r.302-303 (giorno costante); negli EA della famiglia Apertura **manca** | data mining puro: in casa sarebbe un **cerotto** (0 su 5). Non lo propongo |
| bias per ora del giorno | **MISURATO E CHIUSO sul DAX** | `ABTG_SondaOrologio.mq5`; `risultati_archivio/REFERTO_OROLOGIO_INDICI_DAX_2026-09-07.md`: **0 fasce asimmetriche su 72 in OOS**, "LONG = -SHORT" = deriva del toro | il bias orario di Unger (E11) sul nostro DAX non c'e'. Dow (celle 13-14) **non girato** |
| bias overnight | **MISURATO E CHIUSO per rischio** | `report/SECONDA_CACCIA_2026-09-12.md` §4.2-4.3 | merito si' (DAX t=+2,86, 8 anni su 9), rischio no. E10 **non si riapre** con i suoi filtri: il rapporto gap/edge e' invariante |
| ATR / volatilita' | SI | `ABTG_DAX_Apertura_EU.mq5` r.364-365 (`InpUseAtrFilter`: ATR >= media); `ABTG_Nightly.mq5` r.72 (volatilita' notturna); `ABTG_VolExpBreak.mq5` r.202-204 | |
| apertura +/- k x volatilita' (E8) | SIMILE | `ABTG_OutOfNoise.mq5` r.148-150 (cono di rumore dall'apertura, 14 giorni), r.156-159 | meccanismo parente, non identico (cono medio vs k x ATR). Non propongo un doppione |
| filtro orario | SI | `ABTG_VolExpBreak.mq5` r.244-246; tutte le Apertura via `InpSessionHour` | |
| ADX come filtro | gia' provato | R20 (filtro ADX aggiunto dopo: fallito, mandato §5B) | |
| stabilita' dei parametri al posto del WF | SI, e noi facciamo anche IS/OOS | regola del centro dell'altopiano, `report/ROBUSTEZZA.md` §3B | convergenza, non buco |

---

## 5. LE DUE SONDE — l'evento deve ESISTERE prima di proporre un test

Lezione OOPS (R38): il pattern era giusto, **l'evento sul nostro CFD non c'era**.
Quindi, prima delle ipotesi, ho contato gli eventi. Script in casa:
`backtest_pipeline/caccia_strategie/biblioteca/sonde_esterne/sonda_unger_eventi.py`
e `sonda_unger_primaora.py`.

**Dati:** `FutureSharks/financial-data`, histdata M1 `GRXEUR` (DAX, GPL-3.0),
2011-2018, 8 file, 200 OK, 1.691.939 barre, 2.016 giornate utili.
**Collaudo dell'orologio, fatto per primo:** minuto a piu' alta |variazione| media =
**file 03:00 = server 08:00** (7,79 punti, n=941) = apertura del cash. PASS.

**Limiti, da ripetere accanto a ogni numero:** non e' BCM; copre **solo server
07:00-21:00** (sessione del future), **la notte non c'e'**; OHLC M1; zero costi;
vecchio orologio (server = IT - 1 tutto l'anno); periodo 2011-2018, **non il
regime 2024-2026**. Misura di OCCASIONI, mai di edge.

### 5.1 Evento A — rottura del massimo/minimo di IERI dopo le 08:00 server

| anno | giorni | gia' fuori prima delle 08 | dentro alle 08 | rotto entro 16:30 | entrambi i lati | rotto entro 21:00 |
|---|---:|---:|---:|---:|---:|---:|
| 2011 | 252 | 113 | 139 | 108 | 9 | 112 |
| 2012 | 254 | 99 | 155 | 127 | 12 | 130 |
| 2013 | 253 | 87 | 166 | 121 | 12 | 127 |
| 2014 | 251 | 74 | 177 | 137 | 16 | 148 |
| 2015 | 253 | 76 | 177 | 131 | 10 | 140 |
| 2016 | 255 | 97 | 158 | 120 | 10 | 126 |
| 2017 | 247 | 93 | 154 | 108 | 9 | 116 |
| 2018 | 251 | 98 | 153 | 115 | 9 | 119 |
| **TOT** | **2.016** | **737 (36,6%)** | **1.279** | **967 (~121/anno)** | **87 (6,8%)** | **1.018** |

`[MISURATO-SONDA]` L'evento **esiste** in tutti gli 8 anni (108-137 rotture/anno).
**Ma il 36,6% dei giorni e' "consumato" gia' fra le 07 e le 08** — e su BCM questo
numero **NON e' un limite in nessun verso**: la notte di oggi consuma di piu', ma i
livelli di ieri su BCM includono la notte di ieri e sono piu' larghi. **Va rimisurato
sui tick BCM.** E' esattamente la domanda che l'OOPS non si era fatto in tempo.

Filtri di Unger sugli stessi 967 eventi `[MISURATO-SONDA]`:
Weekly Factor (RF 0,5) vero su **508** (~64/anno) · Daily Factor 25% su **283**
(~35/anno) · Daily Factor 50% su **587** (~73/anno).

### 5.2 Evento B — la "prima ora del future" (07:00-08:00 server), ordini 08:00-09:00

1.877 giornate con la prima ora completa (375 venerdi'). Rottura del livello
`massimo + k x R` / `minimo - k x R` `[MISURATO-SONDA]`:

| k (spostamento in frazioni del range) | rotto entro 09:00 server | entro 16:30 | senza venerdi', entro 09:00 |
|---:|---:|---:|---:|
| 0,00 | 96,7% | 99,9% | 182/anno |
| 0,25 | 86,8% | 99,1% | 164/anno |
| 0,50 | 71,7% | 96,6% | 136/anno |
| **0,75** (il suo) | **57,6%** | 92,4% | **111/anno** |
| 1,00 | 44,2% | 86,5% | 86/anno |

⚠️ La frase "displacement of 75% of the range" e' ambigua (oltre l'estremo, o
dall'estremo opposto?): qui e' misurata come **oltre** l'estremo. `[INFERITO]`

### 5.3 Frontiera del costo (stop >= 40 x spread; D30EUR in sessione 1,6-1,7 pt)

`[MISURATO-SONDA]` riportato al DAX a 24.000: range giornaliero mediano **1,395% = 335
pt** (p10 165 pt); range della prima ora mediano **0,295% = 71 pt** (p10 37 pt).
- A con stop all'estremo opposto di ieri: 335/1,7 = **~197x**, p10 **~97x** → PASSA largo.
- B con stop all'estremo opposto della prima ora e k=0: 71/1,7 = **~42x** mediano, p10 **~22x** → **al limite / sotto**. Con k=0,75 (stop ~2,5 R) mediano ~105x. **B vive solo con lo spostamento o con il pavimento `InpMinStopPts`.** `[INFERITO dai due numeri]`

---

## 6. SCHEDE (§7 del mandato) — solo il motore che si prova per primo

```
NOME            "Ieri come livello" = E2/E3/E1 senza filtri + il test delle "2 righe" (§2.2)
FONTE / URL     motore: [SNIPPET] ungeracademy breakout-strategies-dax-futures-2025,
                mean-reverting-or-trend-following...; unico sorgente letto: Weekly Factor
                PineCodersTASC [VERIFICATO]
AUTORE / DATA   Andrea Unger (articoli 2021-2025; TASC 08-09/2023)   POPOLARITA' n/d
LICENZA         Pine TASC: open source, regole di ripubblicazione TradingView
RIGHE / INPUT   Pine: 118 righe / 1 input. Porting: ZERO righe, usa un EA nostro

TESI IN UNA RIGA
  "guadagna (se guadagna) perche' la rottura dell'estremo di ieri durante il cash
   segnala un'espansione della giornata; il test stop-contro-limit sugli STESSI
   livelli dice se il DAX di oggi premia chi segue o chi sfuma quella rottura"

MECCANICA        buy stop su High[D1,1] / sell stop su Low[D1,1], armati alle 08:00 server,
                 validi fino alle 16:30; OCO; flat alle 16:30. Gemello "revert": stessi
                 livelli, ordini LIMIT (RANGE_FADE)
GESTIONE RISCHIO rischio % dell'equity (casa), SL vero all'estremo opposto di ieri o ATR
BANDIERE ROSSE   nessuna (l'originale TASC non ha stop: lo mettiamo noi)
COSTO DI PORTING 0 ore: sono input di ABTG_DAX_Apertura_EU (v. §7, ipotesi A)

PUNTEGGIO        semplicita' 2 · filtro=motore 1 (nessun filtro: e' il motore nudo) ·
                 tesi 1 (scrivibile ma non dimostrata da noi) · buco 1 (vedi riga prop) ·
                 testabile 2  = 7  -> IN CODA alta (primo della coda Unger)
PERCHE'          costo zero di codice, evento misurato, e il livello D1 non e' MAI stato
                 messo ad asse in casa (R133a si ferma a H4)
RIGA PROP        un'operazione al giorno per simbolo, flat la sera (zero notte, zero gap);
                 fascia 08:00-16:30 = SOVRAPPOSTA alle aperture DAX gia' vive
                 (770101 lavora dalle 08:00): regola "mai due EA sullo stesso
                 segnale/simbolo/lato a rischio pieno" -> se passa, si misura la
                 correlazione con 770101 PRIMA di qualunque vivaio. Il 6,8% di giorni
                 con entrambi i lati rotti = due stop nella stessa seduta possibili:
                 peggior giornata da misurare, non da stimare.
```

---

## 7. MAX 3 IPOTESI DI TEST, ciascuna col certificato

⚠️ Nessuna di queste righe e' passata dai cancelli (`controlla_riga.py`,
`controlla_prova.py`, agente `controllo-preventivo`, `CHECKLIST_RIGA_DI_LANCIO.md`).
Sono **bozze per il coordinatore**, non righe di lancio. `@DAQUANDO` sugli indici BCM
e' quello gia' misurato in casa (**2024.09.26**, tick BCM, `R133a` r.14 e r.26).
I round girano sul **PC di backtest**, mai sul VPS (regola del 21/09).

### IPOTESI A — "Ieri come livello", stop contro limit (ZERO codice)

- **EA:** `ABTG_DAX_Apertura_EU` (gemelli `ABTG_Dow_Apertura_US`, `ABTG_Nasdaq_Apertura_US`: stesso ramo `PREVBAR`).
- **Input** (tutti esistenti):
  `InpRangeMode=2` (PREVBAR, r.274) · **`InpLevelTF=PERIOD_D1` (16408)** (r.275) ·
  `InpEntryMode` = **0 (BREAKOUT) contro 3 (RANGE_FADE)** (r.273, enum r.203-206) — e'
  il test delle "2 righe" di Unger · `InpPendingExpiryMin=510` (08:00 -> 16:30, r.282) ·
  `InpCloseHour=16 / InpCloseMin=30` (r.266-267) · `InpSLMode=0` estremo opposto (r.326) ·
  `InpMinRangePts=0 / InpMaxRangePts=0` (r.285-286: il range D1 e' ~25.000-35.000 punti
  MT5, un tetto acceso lo ammazzerebbe) · lati separati (`InpAllowLong/Short`, r.283-284,
  regola dei due lati del 25/08).
- **Perche' non e' gia' stato fatto:** `InpLevelTF` in casa ha girato solo H1..H4
  (`prove/R133a_livelliTF_NASUSD.txt` r.29-35: M15..H4, 7 celle) e il DAX
  `RangeMode=2` solo con H1 in RETEST (`risultati_archivio/Walkforward_Aperture/DAX_L_rangemode_OOS.csv`:
  PF OOS 0,884, n=326). **D1 mai.** `[VERIFICATO nel repo]`
- **Certificato dell'evento:** deve ESISTERE, sui **tick BCM D30EUR** dal 2024.09.26,
  un numero di giornate con prezzo **DENTRO** `[Low_D1(1), High_D1(1)]` alle 08:00
  server e rottura di un lato **prima delle 16:30**, tale da dare **>=150 operazioni
  per meta' IS/OOS sulla famiglia** (3 indici). Stima esterna: ~121/anno/simbolo
  (§5.1) → 3 simboli x 1,75 anni ≈ 600 `[INFERITO, da rimisurare]`. **Trappola nota
  che il certificato deve contare:** nei giorni "consumati" (36,6% sulla sonda)
  l'ordine stop dalla parte gia' rotta e' **rifiutato** (prezzo non valido: r.1214 e r.1238
  loggano "BUY/SELL STOP fallito") e resta vivo solo l'altro lato → quei giorni fanno un
  trade **mono-lato non voluto**. Va contato nel log (`BUY/SELL STOP fallito`) prima
  di leggere un PF. `[INFERITO dal codice]`

### IPOTESI B — La "prima ora del future" con spostamento (1 input nuovo)

- **EA:** `ABTG_DAX_Apertura_EU`.
- **Input esistenti:** `InpRangeMode=1` (PREV, r.274) · `InpPrevWindowMin=60` (r.276) →
  range 07:00-08:00 server · `InpEntryMode=0` BREAKOUT · `InpPendingExpiryMin=60`
  (ordini vivi solo nella "seconda ora", 08:00-09:00) · flat 16:30 ·
  `InpMinStopPts` + `InpSkipIfTight=true` (r.357-358) come pavimento di costo.
- **Il pezzo che manca:** lo spostamento e' in **punti fissi** (`InpBufferPoints`, r.277),
  quello di Unger e' **frazione del range** (k=0,75). Serve **un input nuovo**
  (`InpBufferFracRange`, ~5 righe in `EffectiveBuffer()`), quindi **firma e
  sviluppatore**, non solo una riga. Senza, il test con `InpBufferPoints` e' un
  proxy e va dichiarato tale. Il filtro "no venerdi'" **non c'e'** in questo EA: si
  prova prima SENZA (e' un cerotto, §4.3).
- **Gia' misurato in parte:** `RangeMode=1 / PrevWin=60` ha girato solo in **RETEST**
  (`DAX_L_rangemode_OOS.csv`: PF OOS **0,861**, n=320, DD 15,6%) → in BREAKOUT e'
  **NON ANCORA MISURATO**, non morto. Modello di quel CSV `[INCERTO]`.
- **Certificato dell'evento:** su BCM deve esistere (a) una prima ora 07:00-08:00 server
  **quotata** su D30EUR (la notte c'e': spread 3,5-3,9 pt, `SPREAD_FLOTTA_MISURA_2026-09-03.md`;
  qui il range si CALCOLA soltanto, i riempimenti avvengono dalle 08:00 a spread 1,6-1,7),
  e (b) la rottura di `estremo + 0,75 R` entro le 09:00 server in una quota di giorni
  vicina al **57,6%** della sonda. ⚠️ **Orologio:** dal 26/10 BCM d'inverno = ora italiana
  (CLAUDE.md, correzione 24/09): la prima ora del future diventa **08:00-09:00 server**.
  Una prova che attraversa l'inverno con orari fissi MESCOLA due tempistiche: va
  spezzata per stagione o dichiarata.

### IPOTESI C — Il Weekly/Daily Factor come motore COSTITUTIVO di A (codice piccolo)

- **Tesi, scritta prima dei numeri:** "la rottura di ieri paga dopo una fase di
  indecisione" (Unger 2012, `[SNIPPET: forexup]`; TASC 2023, `[VERIFICATO: Pine]`).
  Se e' vera, la compressione **E' il motore**, non un filtro: la cella con il
  filtro si dichiara e si congela **insieme** ad A, non dopo aver visto A (§5B: il
  filtro-cerotto ha fatto 0 su 5).
- **EA:** `ABTG_DAX_Apertura_EU` + **un input** (`InpFactorMode` 0=off/1=daily/2=weekly
  e `InpFactorMax`), ~15 righe in `TryPlaceBreakout()`. **Firma e sviluppatore.**
- **Certificato dell'evento:** sui tick BCM la condizione deve cadere su abbastanza
  eventi di A. Sonda esterna: Weekly Factor vero sul **52,5%** delle rotture (~64/anno/
  simbolo), Daily Factor 25% sul **29%** (~35/anno). ⚠️ **Frequenza:** con ~35-64
  eventi/anno/simbolo e 1,75 anni di tick BCM, **il singolo simbolo non arriva a 150 per
  meta'**: il verdetto e' **solo di famiglia** (3 indici) e il DF 25% rischia di non
  arrivarci nemmeno cosi' `[INFERITO dai numeri della sonda]`. Per questo C viene
  **dopo** A e solo se A mostra un motore vivo in almeno una delle due logiche.

### La domanda a cui il primo test deve rispondere

> **Sul DAX BCM, a parita' di livelli (massimo/minimo di IERI), vince l'ordine STOP
> o l'ordine LIMIT — e in quanti giorni il livello e' gia' consumato alle 08:00?**
> Se nessuna delle due logiche regge a tick reali, la famiglia "livello di ieri"
> si chiude con un certificato vero (PF, n, DD, uscita, gemelli, TF) e B/C non
> partono.

---

## 8. CONSUNTIVO — coi numeri veri

| misura | valore |
|---|---|
| query WebSearch | **70** (inglese + italiano) |
| query all'API di ricerca TradingView | **16** (`unger`, `andrea unger`, `weekly factor`, `day drop`, `daily factor`, `indecision`, `compressed candle`, `overnight bias`, `first hour breakout`, `TASC 2023.04/05`, `TASC 2024.08/09/12`, `TASC 2025.01`) |
| ricerche GitHub web | 3 + 1 controllo positivo |
| host provati | **87** |
| host che rispondono | **9**: `www.tradingview.com`, `my.tradingview.com`, `pine-facade.tradingview.com`, `github.com`, `gist.github.com`, `raw.githubusercontent.com`, `www.mql5.com`, `arxiv.org`, `www.quantconnect.com` (quest'ultimo solo sondato) |
| host bloccati (EGRESS / CONNECT rifiutato, curl 000) | **73**: `ungeracademy.com`, `vix.ungeracademy.com`, `bettersystemtrader.com`, `www.youtube.com`, `www.youtube-nocookie.com`, `invidious.io`, `it.wikipedia.org`, `www.traders.com`, `technical.traders.com`, `store.traders.com`, `benzinga.com`, `www.benzinga.com`, `it.benzinga.com`, `www.prorealcode.com`, `forexup.altervista.org`, `forum.forexup.biz`, `blog.ilgiornale.it`, `m.uk.investing.com`, `www.investing.com`, `it.investing.com`, `sites.libsyn.com`, `podtail.com`, `www.spreaker.com`, `podcast24.fr`, `podcasts.apple.com`, `open.spotify.com`, `www.buzzsprout.com`, `www.hvst.com`, `tradingnut.com`, `tradingstrategyguides.com`, `ungermethod.com`, `algoadvantage.substack.com`, `easylanguagemastery.com`, `traders-mag.com`, `www.traders-mag.it`, `www.money.it`, `forex-station.com`, `www.futuresmag.com`, `www.priceactionlab.com`, `www.quantifiedstrategies.com`, `www.bing.com`, `duckduckgo.com`, `archive.org`, `www.scribd.com`, `pdfcoffee.com`, `www.dropbox.com`, `www.amazon.com`, `amazon4trader.com`, `books.google.com`, `www.goodreads.com`, `www.worldcupchampionships.com`, `www.multicharts.com`, `www.tradestation.com`, `www.reddit.com`, `old.reddit.com`, `www.elitetrader.com`, `www.bigmiketrading.com`, `www.traderslaboratory.com`, `www.linkedin.com`, `www.facebook.com`, `smtp.bardenay.com`, `stackoverflow.com`, `www.andreaminini.com`, `www.lucagiusti.it`, `www.borsaitaliana.it`, `www.soldionline.it`, `www.finanzaonline.com`, `forum.finanzaonline.com`, `www.traderlink.it`, `www.milanofinanza.it`, `www.ilsole24ore.com`, `www.wallstreetitalia.com`, `www.teleborsa.it` |
| host che rifiutano / murati altrimenti | **5**: `www.ssrn.com` 403, `papers.ssrn.com` 403, `quantpedia.com` 466, `export.arxiv.org` 406 (API), `api.github.com` ricerca "sessions are bound to their configured repositories" |
| pagine/sorgenti aperti davvero | **8**: script TradingView Weekly Factor (pagina + sorgente) · sorgente `Daily Factor Indicator [CC]` · 3 pagine di ricerca GitHub + 1 controllo · gist 18182324 · repo `ferranfont/Unger_opening_range_breakout` (clonato, 3 file letti) · ricerca arXiv · 8 file dati FutureSharks |
| sorgenti di Unger letti | **1** (Weekly Factor, porting PineCoders da TASC) |
| sonde scritte e girate | **2** (`sonda_unger_eventi.py`, `sonda_unger_primaora.py`), collaudo orologio PASS |
| EA toccati | **0**. Parametri in forward toccati: **0**. Acquisti: **0** |

### Cosa NON ho potuto vedere (buchi dichiarati, non riempiti)

1. **Il codice EasyLanguage ufficiale del Weekly Factor** (Traders' Tips set. 2023,
   `www.traders.com`): bloccato. Il Pine e' un porting di terzi (PineCoders), fedele
   per dichiarazione, non confrontato.
2. **Il codice ProRealTime "DAX 5 min by Andrea Unger"** e l'indicatore "Dfactor"
   (`prorealcode.com`): bloccato. E' la fonte piu' vicina alla meccanica esatta di E4.
3. **Il porting MetaTrader del filtro di indecisione** (`forexup.altervista.org`, t=3963):
   bloccato. Se contiene `.mq4` col sorgente, e' il pezzo piu' vicino alla nostra lingua.
4. **Tutto il blog Unger** (EN/IT), YouTube, podcast: i numeri del §3-§4 sono SNIPPET.
5. **La notte BCM**: la sonda non la vede. I certificati di A e B vanno rifatti sui tick BCM.

### Lista della spesa per Claudio (5 pagine, gratis, nessun acquisto)

| # | URL | cosa chiude |
|---|---|---|
| 1 | `https://www.traders.com/Documentation/FEEDbk_docs/2023/09/TradersTips.html` | EasyLanguage ufficiale del Weekly Factor, contro il Pine letto qui |
| 2 | `https://www.prorealcode.com/prorealtime-trading-strategies/dax-5-min-trading-strategy-by-andrea-unger/` | la meccanica esatta di E4 (75%, "Dfactor", orari) |
| 3 | `https://forexup.altervista.org/viewtopic.php?t=3963` | porting MetaTrader del filtro di indecisione (25% o 50%?) |
| 4 | `https://ungeracademy.com/blog/mean-reverting-or-trend-following-find-it-out-with-2-lines-of-code-btc-and-eth` | conferma verbatim del test "2 righe" (ipotesi A) |
| 5 | `https://ungeracademy.com/blog/walk-forward-analysis` | la domanda aperta del 14/09 (oggi 2 snippet concordi, ancora non una pagina) |

---

_Nessun EA toccato. Nessun parametro in forward toccato. Nessun acquisto fatto ne'
consigliato. Nessun commit (lo fa il coordinatore). Due file nuovi oltre a questo:
le due sonde in `biblioteca/sonde_esterne/`. I numeri dichiarati dagli autori
(profitti, "loses one-third", "80% profitability") non pesano su nulla._
