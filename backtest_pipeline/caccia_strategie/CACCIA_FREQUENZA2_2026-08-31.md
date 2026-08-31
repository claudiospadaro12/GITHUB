# 🏹 CACCIA FREQUENZA — **SECONDA BATTUTA** · forex majors + i sopravvissuti del soffitto — 31/08/2026 (notte)

**Mandato (Claudio, 31/08 sera, testuale):** _"manda ancora a caccia gli
agenti"_ — seconda battuta della caccia-frequenza, su **terreno nuovo**, senza
duplicare la prima (`CACCIA_FREQUENZA_2026-08-31.md`, promosso `M0PB`).

**Le due direzioni assegnate:**
- **A · FOREX MAJORS** — i simboli a minimo attrito. Spread relativo molto piu'
  sottile degli indici → il pavimento `take ≥ 3× spread` e' molto piu' basso.
  Meccanismi di sessione / mean-reversion / momentum intraday con **≥ 1-2
  trade/giorno per costruzione**.
- **B · I SOPRAVVISSUTI DEL SOFFITTO** — arXiv 2605.04004 §6.2 dice che
  sopravvivono le strategie con **tenuta 12-15+ barre**. Cercare meccanismi
  intraday a **tenuta lunga dichiarata (ore, non minuti)** e frequenza ≥ 1/giorno.

---

## ⚡ IL RISULTATO IN TRE RIGHE

> **Su 6 fonti sottoposte a controllo positivo (5 vive — una MAI usata prima —
> e 2 nulle), 3 canali dati ancora murati, ~95 strategie censite da 65 query
> di ricerca e 4 pagine di Code Base, sono arrivato al sorgente su 9 oggetti e
> li ho letti riga per riga. NE PROMUOVO UNO SOLO.**
>
> 🥇 **Il promosso e' `EURUSD 5min london session strategy` (SoftKill21, MPL
> 2.0, 52 righe, 8 input).** E' l'unico oggetto trovato in due battute in cui
> **l'autore stesso dichiara la frequenza sulla pagina**: _"preferably no more
> than 5 trades / day, and no more than 2% risk of equity lost"_ [VERIFICATO].
> Piu' importante: la sua **geometria e' l'opposta di M0PB** — TP 150 / SL 80
> nel sorgente, **RR 1,875**. 👉 **Passa il cancello H8 con un win rate del
> 42%; M0PB, con lo stop a 2,75 ATR, ne chiede fra il 62% e il 79%.**
>
> 🔴 **DIREZIONE B: ZERO CANDIDATI, e la risposta utile non e' un EA — e' una
> cosa che abbiamo gia' in casa e non abbiamo mai acceso.** La `SONDA
> DELL'OROLOGIO` (EA scritto, 7 file prova, riga di lancio pronta, preparata il
> 28/08) **non e' MAI girata**: nessun referto in `risultati_archivio`. E' il
> solo meccanismo FX a **tenuta di ore** con frequenza ≥ 1/giorno che il
> progetto possieda. **Comprarne un altro fuori sarebbe spendere due volte.**
>
> 🔧 **E una correzione al mandato, misurata nel repo prima di uscire (§1-bis):
> il pavimento 1999 del forex e' su OHLC M1, NON sui tick.** La profondita'
> **tick** del forex BCM **non e' mai stata misurata**. Il vantaggio dei
> candidati forex sui candidati indice e' reale ma vale sullo **screening**,
> non sul verdetto.

---

## 0. ⚖️ I CRITERI — gli stessi della prima battuta, non toccati

Ereditati parola per parola da `CACCIA_FREQUENZA_2026-08-31.md` §0 e non
modificati (i criteri si cambiano prima dei numeri, non dopo):

**F1** ≥ 1 trade/giorno **dichiarato dal meccanismo** (preferito 2+) ·
**F2** take mediano lordo ≥ **3 × spread** dello strumento, **con la
spiegazione del perche'** · **F3** frequenza senza taglia = scarto, taglia
senza frequenza = scarto · **F4** niente parametri diversi di motori morti
(`REGISTRO_TEST.md` + `SETACCIO_MANUALE.md` + i 9 dossier di caccia) ·
**F5** niente doppioni del patrimonio interno · **F6** verdetti solo a tick ·
**F7** due lati sempre · **F8** campione ≥ 150 op IS · **F9** pavimento SL ·
**F10** §4 non si ammorbidisce · **F11** non si tocca il forward.

**🖊️ F12 — CANCELLO H8** (`report/FIRME_2026-08-31.md`, FIRMA 2, testuale):
> _"Ogni motore ad alta frequenza entra in flotta SOLO con E >= 0.075R
> misurata A TICK. Frequenza sotto questo cancello = portata finta (DD e
> costi)."_

➕ **Vincolo aggiunto da Claudio per questa battuta:** dove la **geometria e'
nel sorgente**, il cancello si interroga **in aritmetica prima di spendere una
macchina** — e **RR mediano < 0,70 = SCARTO senza corsa**.

### La tabella dell'aritmetica H8, congelata (vale per tutta la battuta)

Da `E = p·RR − (1−p) ≥ 0,075` segue `p ≥ 1,075 / (RR + 1)`:

| RR | win rate necessario | chi ha questa geometria |
|---:|---:|---|
| 0,36 | **79,0%** | M0PB, se il premio vale 1 ATR |
| 0,73 | **62,2%** | M0PB, se il premio vale 2 ATR |
| 1,00 | **53,8%** | `Money maker EURUSD 15min` (P2 del 28/08, TP=SL=30 pip) |
| **1,42** | **44,4%** | 🥇 **il promosso di oggi, al netto di 1,5 pip di costo** |
| **1,56** | **42,0%** | 🥇 **il promosso, al netto di 1,0 pip** |
| **1,875** | **37,4%** | 🥇 **il promosso, geometria lorda letta nel sorgente** |

> 🎯 **Questa tabella e' il risultato tecnico della battuta.** Non dice che il
> promosso guadagna: dice **quanto poco gli serve per non essere portata
> finta** — e che sullo stesso asse M0PB parte con un handicap di 20-37 punti
> di win rate. **Il parametro che decide un motore ad alta frequenza e' la
> GEOMETRIA, non il segnale.**

---

## 1. 📕 IL CIMITERO E I DOSSIER, RILETTI PRIMA DI USCIRE

Letti per intero prima di aprire un browser: `REGISTRO_TEST.md` (602 righe,
aggiornato oggi con CRT, Chaos, BreakinBox, NY Retest, DaxReEntry),
`CACCIA_FREQUENZA_2026-08-31.md`, `PROMEMORIA_SBLOCCO_FONTI.md`,
`CACCIA_INTRADAY_FOREX_ORO_2026-08-28.md`, `FIRME_2026-08-31.md`,
`R102_REFERTO_BLOCCO1/2.md`.

| famiglia caduta / occupata | verdetto misurato | conseguenza su questa battuta |
|---|---|---|
| **breakout · ORB · London breakout** | ~210 celle a tick, **R45 0/48** su GBPUSD/EURUSD/XAUUSD, R12 **48/48 negative OOS**. Capitolo chiuso 26.07.26 | 🔴 **ha ucciso 6 dei 9 sorgenti letti oggi.** Il web forex "di sessione" e' **quasi tutto** London breakout |
| **fade degli estremi / session reversal** | R42 **0/24 IS e 0/24 OOS** | 🔴 chiude la sotto-pista "range asiatico da faidare" |
| **mean reversion senza regime** | R60 **12/12 in perdita** | 🔴 |
| **Bollinger / BreakingBand M15** | R108/R111 **6 finestre su 6 rosse**, gradiente **H1 > M30 > M15 monotono su 3 simboli** | 🟠 **adiacenza vera del promosso**, affrontata al §5.4 |
| **momentum intraday a orario fisso (Gao)** | R98 **−0,31 punti/trade su 410** | 🔴 uccide `Intraday ETF Momentum` di QuantConnect |
| **capitolo M1 · capitolo M5** | chiusi a tick. M1 = _"trappola di costo strutturale"_ | 🔴 uccide `Macketings 1min Scalping` |
| **calendario / stagionalita'** | R63 **0/24 OOS su 11.928 operazioni** | 🔴 uccide meta' del catalogo FX di Quantpedia |
| **filtro appiccicato a motore gia' tarato** | **0 successi su 5** | 🟠 **e' il punto debole dichiarato del promosso** (§5.3) |
| **NY Session Retest** (patrimonio interno) | n=625/21 mesi ~1/gg, **PF 1,002**, gate slope validato ma n=114<150 | 🔴 uccide `Roboquant NY Open Retest` per F5 |
| **`Money maker EURUSD 15min`** (P2, 28/08) | 🟡 **IN CODA, mai girato** | 🟠 **stesso autore, stessa coppia, stessa sessione del promosso.** Affrontato in pieno al §5.5 |
| **`L'OROLOGIO`** (P1, 28/08) | 🔴 **EA scritto, 7 prove, riga pronta, MAI GIRATO** | 🎯 **e' la risposta alla direzione B** (§6) |

### 1-bis. 🔧 LA CORREZIONE AL MANDATO — misurata, non opinata

Il mandato dice: _"i tick BCM forex partono da gen-1999 (pavimento R102
misurato) → i candidati forex sono testabili **a tick** su decenni"_.

**Ho riletto R102. La prima meta' e' vera, la seconda no.**

| cosa dice davvero R102 | riga |
|---|---|
| modello della corsa | `R102_REFERTO_BLOCCO1.md` riga 6: _"modello **OHLC M1**"_ [VERIFICATO] |
| prima operazione | `BLOCCO2` riga 19: _"Prima operazione **1999.01.04 su tutte e tre**"_ [VERIFICATO] |
| lo storico dichiarato dalla sonda | AUDUSD dal 1993.04.26, EURUSD dal 1971.01.03, GBPUSD dal 1993.05.11 — **e prima del gennaio 1999 non producono nessuna operazione** |
| dichiarazione esplicita del referto | riga 136: _"niente tick reali"_ [VERIFICATO] |

> 🎯 **Traduzione onesta:** sul forex abbiamo **~27 anni di M1 OHLC misurati**
> — che e' un vantaggio enorme e reale **per lo SCREENING e per la PROVA DI
> REGIME** (regola C dell'emendamento della finestra: toro / orso / laterale /
> crollo si scelgono davvero, invece dei 21 mesi di un solo regime degli
> indici).
> 🔴 **Ma la profondita' TICK del forex BCM non e' mai stata misurata**, esattamente
> come quella di XAUUSD (rilievo aperto in `REGISTRO_TEST.md` §G1-PAOLO).
> **`F6 — verdetti solo a tick` non si ammorbidisce**: il verdetto del promosso
> resta appeso a una profondita' tick **da misurare con `scarica_storico.ps1`**.
> ➡️ **E' il motivo per cui il file prova del §7 ha `@DAQUANDO` VUOTO.**

---

## 2. 📡 CONTROLLO POSITIVO — misurato stanotte, fonte per fonte

| fonte | HTTP | bersaglio noto verificato **adesso** | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951** → `<title>`: _"Liquidity Sweep H4 - M15 (Swing Highs and Lows)"_, autore **OsmarSandovalEspinosa**, data **2026.03.23** — identico ai censimenti del 26, 28 e 31/08 | 🟢 **PASSA** |
| **arXiv API** | **200** | `id_list=2605.04004` → _"Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures"_ | 🟢 **PASSA** |
| **TradingView** `pubscripts-suggest-json` + `pine-facade /get/` | **200** | query `london session` → JSON con `scriptIdPart`, `access`, `agreeCount`; 7 sorgenti scaricati in chiaro | 🟢 **PASSA** |
| **`raw.githubusercontent`** | **200** | `n30dyn4m1c/crt-turtlesoup-ea/README.md` | 🟢 **PASSA** |
| 🆕 **QuantConnect** | **200** | pagina nota `investment-strategy-library/intraday-dynamic-pairs-trading...` → `<title>` corretto, **264.951 byte di pagina vera** | 🟢 **PASSA — E NON ERA MAI STATA USATA** (dichiarata bloccata in 6 dossier) |
| **Quantpedia** — sitemap | **200** | `wp-sitemap-posts-pod_cpt_strategy-1.xml` → **1.118 slug** enumerati | 🟢 PASSA come **indice di effetti** |
| **Quantpedia** — pagine strategia | **200 ma FALSO** | 4 slug reali provati (`cross-market-intraday-time-series-momentum`, `sp500-futures-return-during-the-eu-open-period`, `intraday-currency-seasonality`, `jump-only-momentum-and-reversal-in-currency-markets`): **tutte e quattro rendono 302.356 byte IDENTICI** = la home page | 🔴 **PREMIUM, confermato per la seconda volta** |
| **Forex Factory** | **403** | — | 🔴 **NULLA — NONA di fila** |
| **SSRN** | **403** | — | 🔴 **NULLA — NONA di fila** |

### ⛔ Canali che NON funzionano (rimisurati, per non riprovarli)

| canale | esito |
|---|---|
| **Yahoo Finance · Stooq · Dukascopy datafeed** | 🔴 **403 al CONNECT, tutti e tre** — 👉 **anche stanotte NESSUNA frequenza e' stata MISURATA.** Il numero lo fa il PC di Claudio |
| **Ricerca `?keyword=` del Code Base** | 🔴 parametro ignorato (riconfermato) |
| **`api.github.com` / ricerca GitHub via `curl`** | 🔴 403 — nona di fila |
| **`github.com/topics/mql5?o=desc&s=updated`** (via `WebFetch`, 200) | 🟠 **200 ma inutile**: i 4 repo in cima sono `NulveKN/*` e `ZrakD/*`, **0-3 stelle, linguaggio dichiarato `C#` su codice MQL5, tutti aggiornati oggi**. E' lo **spam SEO** gia' descritto nel `PROMEMORIA_SBLOCCO_FONTI` §B. **Confermato: non si parte dai topic** |

### 2-bis. 🔧 CORREZIONE TECNICA UTILE (aggiornamento al `PROMEMORIA_SBLOCCO_FONTI`)

**Lo slug pubblico di uno script TradingView e' il campo `imageUrl` del JSON,
NON il prefisso di `scriptIdPart`.** Misurato stanotte sul promosso:

| URL provato | esito |
|---|---|
| `tradingview.com/script/yMINlAO3-...` (primi 8 di `scriptIdPart`) | 🔴 **404** |
| `tradingview.com/script/E6yr9CoN/` (campo `imageUrl`) | 🟢 **200**, `<title>` corretto |

> ⚠️ **Vale la stessa lezione del 28/08 sul pattern `PUB;`: un identificatore
> sbagliato non da' un errore, da' un "candidato non letto".** Chi cerca la
> pagina pubblica per citarla nel dossier prendeva un 404 e la dichiarava
> inesistente. **Adesso e' misurato.**

---

## 3. 📊 COSA HO SFOGLIATO, fonte per fonte

| fonte | quanto | candidati visti | letti nel sorgente |
|---|---|---|---|
| **TradingView** (ricerca testuale) | **65 query** in 4 ondate (sessione FX · mean-reversion/scalping · tenuta lunga/uscita a tempo · catalogo autore) | **~95 strategie uniche**, di cui **47 con sorgente leggibile** (`access=1`) | **7 Pine scaricati integrali** |
| **MQL5 Code Base** | pagine 1-4 di `mt5/experts` + **20 titoli nuovi interrogati uno per uno** (id 76669 → 75473) | 20 titoli con data e autore | **0** — vedi §4.1 |
| **Quantpedia** | sitemap strategie (**1.118 slug**) + sitemap blog (**1.155 post**) | **122 slug in tema** intraday/FX/overnight estratti e letti a nome | **0** (pagine premium) |
| 🆕 **QuantConnect** | indice `investment-strategy-library` + **2 pagine strategia complete** | ~12 strategie in tema | **2 lette per intero** |
| **arXiv q-fin** | **6 query** (`intraday`+`foreign exchange`, `session`+`intraday`, `abs:intraday momentum`, `ti:intraday`, `holding period`, cat TR) | 4 titoli nuovi in tema | **0 nuovi** (i 3 di Mesfin gia' letti nella prima battuta) |
| **GitHub** | 2 `WebSearch` + 1 `WebFetch` sul topic `mql5` | ~8 repo | **0** (spam SEO) |

---

## 4. 🗑️ GLI SCARTATI — con la riga di codice che lo prova

### 4.1 MQL5 Code Base — **il giacimento e' ESAURITO su questo bersaglio, e adesso e' misurato**

Ho interrogato **uno per uno** i 20 id piu' recenti (76669 → 75473), leggendo
titolo, autore e data dalla pagina [VERIFICATO]. **Ecco cosa c'e', per intero:**

| categoria | quanti | esempi con id e data |
|---|---:|---|
| **attrezzi** (pannelli, calcolatori, gestori, logger) | **15** | `Market Replay Tool` 76669 (29/08) · `Interactive On-Chart Risk Panel` 76534 (24/08) · `Trade Transaction Trace Logger` 76106 · **sei** utility `Quantora` di fila (75729-75749, tutte del 06/08) · `Smart Trade Manager` 75916 · `Trade Adjustment Panel` 75818 |
| **§4 dal titolo** (recovery / basket) | **3** | `Sniper Gold Hybrid **Recovery** EA` 76605 (26/08) · `Daily Zone **Recovery** EA for GOLD` 75922 (10/08) · `**Basket** Protective Close` 76518 |
| **gia' setacciati** | **1** | `Chaos Lyapunov` 76446 → **BOCCIATO oggi** (`REFERTO_CHAOS_2026-08-31.md`) |
| **motori generici senza sessione** | **1** | `Relative Moving Average EA` 75473 (30/07) |

> 🔴 **ZERO EA di sessione. ZERO EA forex intraday. ZERO EA con uscita a tempo.
> In quattro pagine.**
> 🎯 **La conclusione, che vale per le prossime cacce:** il Code Base ha
> smesso di produrre motori. Da luglio in poi produce **utility e recovery**.
> Con la ricerca per parola chiave rotta si vede **solo il recente per data**,
> e il recente e' questo. ➡️ **Non aprire piu' il Code Base per cercare
> motori intraday: aprilo per cercare ATTREZZI** — che e' esattamente cio' che
> il *RealCost Spread P95 Logger* (**74148**) e', ed e' **la SESTA caccia che
> lo scrive senza che sia mai stato usato.**

### 4.2 TradingView — **7 Pine letti riga per riga, 6 scartati**

| # | candidato | fonte / autore / data | la riga che lo prova |
|---|---|---|---|
| **S1** | **`USDJPY Only Strategy`** (nome vero nel JSON: **`Chrome`**) — 38 righe, Pine **v3** | [`PUB;5t9d9uFz...`](https://www.tradingview.com/script/5t9d9uFz/) · @MtxTrader · created **2017-05-12** · 238 like | 🔴 **NESSUNO STOP, NESSUN TAKE, LOTTO FISSO.** Il file contiene **due sole righe operative**: `strategy.entry("buy", strategy.long, **25000**, when = close > sma(close,182) and sma(close,10) > sma(close,20) and crossover(vrsi, 30))` e lo specchio. **Zero `strategy.exit`, zero `strategy.close`**: si esce solo sul segnale opposto. §4 tre volte. E il nome interno "Chrome" ≠ il titolo pubblico: e' un file riciclato |
| **S2** | **`Forex Daytrade T3 MA session`** — 111 righe, ~12 input | [`PUB;84c4ef3d...`](https://www.tradingview.com/script/lasK1jNw/) · © exlux99 · **MPL 2.0** · created **2021-08-03** · 148 like | 🔴 **LA TESI E' UN INTERRUTTORE, E LO SHORT NON ESISTE.** (a) `inverse = input(**true**)`: con `inverse` acceso il codice fa `strategy.entry("long", 1, when = **short**)` — **l'input decide se la strategia e' se stessa o il suo contrario**, ed e' acceso di default. Stessa malattia di `Timeshifter` (S17, 28/08) e `003 - Weekly Day Reversal`. (b) `strategy.entry("short", **0**, when=long)`: in Pine v4 il 2º argomento e' un bool, **`0` = short**, ma la riga e' scritta nel ramo sbagliato — il risultato e' che le due gambe si contraddicono. (c) In coda al file, **sette coppie con la loro ora cablata a mano** (`gbpnzd 10-20`, `gbpcad 10-19`, `gbpaud 07-19`, ...): **un orario per simbolo tarato a occhio** = l'overfitting scritto nei commenti |
| **S3** | **`Expert studio strategy 1 - GBPUSD`** — 97 righe | [`PUB;O9xdMy0Y...`](https://www.tradingview.com/script/O9xdMy0Y/) · @03.freeman · created **2019-12-05** · 357 like | 🔴 **L'AUTORE DICHIARA CHE NON C'E' NE' STOP NE' TAKE, in testa al file:** _"Take profit = no / Stop loss = no"_ [VERIFICATO, righe 14-15]. In piu': _"This is part of a series of strategies developed automatically by an online software"_ (riga 2) = **generata a macchina**; `default_qty_type=strategy.fixed, default_qty_value=10000` = **lotto fisso**; `calc_on_every_tick=true`; **timeframe 1D** dichiarato → F1 fallito per definizione |
| **S4** | **`Trade Beta — The Only EURUSD Trading Strategy You Need`** — 205 righe | [`PUB;64ad01bb...`](https://www.tradingview.com/script/CjTnMUWB/) · © Kaspricci · **MPL 2.0** · created **2022-11-07** · 181 like | 🔴 **GIA' SCARTATO IL 28/08 come S19** — e l'ho riconosciuto solo dopo averlo riscaricato, perche' **la ricerca testuale gli assegna uno `scriptIdPart` diverso** dal dossier di tre giorni fa. Motivo di allora, riconfermato leggendolo: **buy-stop sullo swing high + sell-stop sullo swing low in OCO all'apertura NY** = breakout di livello di sessione, **R45 (0/48)** e famiglia chiusa; piu' `calc_on_every_tick = true` (riga 13) e `default_qty_value = 100` con `useRiskMagmt = **false**` di default → **100% dell'equity**. ➡️ 📌 **Rilievo di processo: il `SETACCIO_MANUALE` indicizza gli URL, non i titoli. Serve indicizzare ANCHE `scriptName` + autore**, o si ripaga lo stesso scarto |
| **S5** | **`Momentum Tick Breakout - Futures V10`** (indicizzato come `Large Candle Continuation`) — 112 righe, 14 input | [`PUB;2abf1cbe...`](https://www.tradingview.com/script/2abf1cbe.../) · @Toddwaters72 · created **2026-02-11** | 🔴 **IL BACKTEST E' SENZA MARGINE, SCRITTO NELLA DICHIARAZIONE:** `strategy(..., default_qty_type=strategy.fixed, default_qty_value=1, **margin_long=0, margin_short=0**)`. **Con margine 0 il tester non puo' mai rifiutare un ordine**: qualunque numero prodotto e' a leva infinita. In piu': **"V10"** = dieci giri di taratura; il motore e' `candleMove >= pctThreshold` → **stop order 8 tick oltre la chiusura** = **inseguire l'impulso**, cioe' esattamente cio' che il registro di Mesfin dichiara peggiore del pullback (`D026 — LOCKED`). 🟢 **Da tenere agli atti, ed e' buona:** la gestione (hard stop 40 tick → **breakeven a +15 tick con offset di commissione** → trailing 20 tick → **hard close alle 14:00 NY**) e' scritta bene, e il `beOffset` che paga la commissione e' un dettaglio che i nostri EA non hanno |
| **S6** | **`Roboquant RP Profits NY Open Retest Strategy`** — 205 righe | [`PUB;1fbb0fdf...`](https://www.tradingview.com/script/1fbb0fdf.../) · @semorrickj · created **2025-11-03** · 78 like | 🔴 **DOPPIONE DEL PATRIMONIO INTERNO (F5) + F1 fallito per costruzione.** `preOpenSession = "0900-0915"` + `tradingSession = "0930-1600"` con **un solo ordine limite di retest per giornata** → **1 trade/giorno al massimo, cioe' AL pavimento, mai sopra**. E la geometria (rottura del pre-open, ingresso sul **retest**, SL 0,9 ATR, TP 2R) e' il **NY Session Retest** che in casa gira gia' a **n=625 su 21 mesi con PF 1,002**, gate slope validato a tick. **Non porta un meccanismo nuovo: porta lo stesso, senza i nostri 625 trade di misura** |
| **S7** | **`Simple and Profitable Scalping Strategy (ForexSignals TV)`** — 395 righe, ~15 input | [`PUB;8accc173...`](https://www.tradingview.com/script/8accc173.../) · @kevinmck100 · created **2022-09-14** · **1.598 like** | 🟠 **SCARTO PER QUESTO MANDATO, e non per difetto — e' il Pine meglio scritto della battuta.** Ha `accountRiskPercent = 1` **vero** (quantita' calcolata sulla distanza dello stop), `riskReward` a input, ATR ovunque, e i due `request.security` sul TF superiore con **`barmerge.lookahead_off`** [VERIFICATO righe 118-119] = **niente look-ahead**. 🔴 **Ma fallisce F1 e F3 insieme:** il grilletto e' **tre EMA (8/13/21) sventagliate di ≥ 0,5 ATR per 3 barre consecutive + allineamento EMA 8/21 sul TF a 60 minuti + pullback + stop order oltre il massimo locale a 5 barre**. **Cinque condizioni necessarie in AND**: la frequenza **non e' dichiarata da nessuna parte** e per costruzione e' bassa. In piu': **nessuna finestra di sessione, nessun flat, nessun cap giornaliero** → tiene overnight. 🟠 E l'adiacenza: "trend + pullback" e' la definizione del **SupertrendReversal**, la spina dorsale della flotta (6 sedie vive). 🟢 **Da rubare: il blocco di sizing e i due `lookahead_off`** |

### 4.3 QuantConnect — **fonte nuova, 2 strategie lette per intero, 2 scarti**

| # | candidato | la riga che lo prova |
|---|---|---|
| **S8** | **`Combining Mean Reversion and Momentum in Forex Market`** (paper: Alina F. Serban) — EURUSD, GBPUSD, USDCAD, USDJPY | 🔴 **RIBILANCIO MENSILE.** _"Positions are held for one month, then the portfolio is liquidated and rebalanced using scheduled events at month start"_ → **~1-2 trade al MESE**: due ordini di grandezza sotto il pavimento F1. E **nessuno stop loss**, `set_holdings(symbol, ±1)` = 100% del capitale per gamba. **Il nome prometteva forex intraday: e' un fattore mensile** |
| **S9** | **`Dual Thrust Trading Algorithm`** — SPY, risoluzione oraria | 🔴 **BREAKOUT DI RANGE, FAMIGLIA CHIUSA.** `cap = open + K₁ × range` / `floor = open − K₂ × range` con `range = max(HH−LC, HC−LL)` a 4 giorni: e' l'ORB con un range multi-giorno. **Nessuno stop loss** dichiarato, `set_holdings` a ±1. ~1 setup/giorno → **AL pavimento, mai sopra** |
| **S10** | **`Intraday ETF Momentum`** (letto dall'indice, non aperto: bastava l'enunciato) | 🔴 **E' R98.** _"emit an insight in the direction of the morning window's return"_ negli ultimi 30 minuti, market-on-close: **Market Intraday Momentum di Gao**, in casa **−0,31 punti/trade su 410**, e archiviato come M4 (0/10) dalla caccia accademica del 30/08. **1 trade/giorno per costruzione** |

> 🎯 **Verdetto sulla fonte nuova, e va scritto perche' risparmia una caccia:**
> **QuantConnect e' finalmente raggiungibile, ma la sua libreria e' fatta di
> strategie di PORTAFOGLIO a ribilancio giornaliero/mensile.** Le poche
> etichettate "intraday" sono ETF/azionario US con 1 trade/giorno e senza
> stop. **Per un mandato di FREQUENZA INTRADAY SU CFD non e' una fonte.**
> Resterebbe utile per un mandato di **allocazione**, che non abbiamo.

### 4.4 Quantpedia — **1.118 slug enumerati, 0 leggibili, 0 candidati**

Dalla sitemap ho estratto i **122 slug in tema** (intraday / session / FX /
currency / overnight / open-close). I piu' vicini al bersaglio erano:
`intraday-currency-seasonality` · `intraday-reversal-in-currency-markets` ·
`jump-only-momentum-and-reversal-in-currency-markets` ·
`cross-market-intraday-time-series-momentum` ·
`sp500-futures-return-during-the-eu-open-period` ·
`intraday-closing-momentum-in-futures` · `exponential-fx-mean-reversion-strategy` ·
`overnight-intraday-weekly-reversal-in-currency-futures`.

🔴 **Tutte PREMIUM: quattro provate, quattro volte la home page (302.356 byte
identici).** Dalla sitemap si legge **il nome dell'effetto, non le regole**.
E i **1.155 post di blog gratuiti** in tema FX sono **quasi tutti su carry,
value e momentum di fattore** (mensili) — fuori mandato per definizione.

> 📌 **Da scrivere nel promemoria e non piu' riverificare:** *"Quantpedia si
> usa per SAPERE CHE UN EFFETTO ESISTE e per risalire al paper. Non si usa per
> avere le regole, e sui mandati INTRADAY non ha mai prodotto un candidato in
> tre cacce."*

### 4.5 Scartati al primo taglio (titolo/pagina, sorgente **non** aperto — dichiarato)

| gruppo | quanti | motivo |
|---|---:|---|
| **TradingView — famiglia London/NY/range breakout** (`London BreakOut Classic` 910 like · `London Breakout/Session GBP/USD Forex Daytrade` @SoftKill21 212 · `London breakout GBPUSD daytrade` @SoftKill21 142 · `NY Opening Range Breakout - MA Stop` 151 · `Estrategia de NY ORB` · `CP Strat ORB` · `Range Breakout Strategy` · `Range Break v1` · `AI MES London Open Breakout` · `London Breakout` ×2 · `Breakout Indicator 24/7` · `Multiple Daily Breakouts - Close Only`) | **13** | 🔴 **F4: famiglia chiusa da ~210 celle a tick** (R45 0/48, R12 48/48). Non si riapre senza una ragione economica nuova, e nessuno di questi ne porta una |
| **TradingView — doppioni VWAP** (`VWAP Stdev Bands Strategy` · `VWAP Stdev Bands Reversal` · `VWAP band strategy [Kevin-Patrick]` · `VWAP Mean Reversion Range Bound Forex RSI Volume` · `VWAP Strategy`) | **5** | 🔴 **F5**: doppioni di `ABTG_VwapRevert` (gia' scritto, PASSO 0 preparato) e del NY Retest. L'ultimo usa **il volume su forex** = tick volume, inaffidabile (regola Paolo, `REGISTRO_TEST.md`) |
| **TradingView — M1 / scalping puro** (`Macketings 1min Scalping` 494 · `First time coding - a 5min forex Scalping strategy` 360) | **2** | 🔴 **capitolo M1 chiuso a tick** (_"trappola di costo strutturale"_, caccia 29/08); il secondo lo dichiara nel titolo |
| **TradingView — dati esterni o griglia** (`EURUSD COT Trend Strategy` · `EURUSD Yield Curve Flip (2s10s)` · `[3Commas] EURUSD **Grid** Bot` · `Hourly Bias on BTC` · `take liquidity multi time frame`) | **5** | 🔴 COT e curva dei rendimenti = **serie che BCM non quota** (dipendenza esterna non risolvibile); §4 sulla griglia; cripto fuori strumento |
| **TradingView — sospetti di manopola** (`Full strategy AllinOne MACD RSI PSAR ATR MA` **3.874 like** · `Forex bot full strategy with risk management` · `SuperTrend Multi Time Frame` · `[KL] Double Bollinger Bands` · `Double/Simple MA EURUSD 1H` ×2) | **6** | 🔴 **"AllinOne" = cinque indicatori in AND**: e' la tesi dentro il menu, gia' caduta tre volte (S17/S18 del 28/08). Gli ultimi due sono incroci di media su **H1**, doppioni di `CrossEma`/`GoldenCross` |
| **TradingView — fuori strumento** (cripto BTC/ETH/SOL, azionario indiano NIFTY/BANKNIFTY, FCPO olio di palma, oro-only) | **~35** | 🔴 strumenti che BCM non quota o che non sono nel mandato |
| **Quantpedia — slug in tema ma premium o fuori F1** | **122** | 🔴 §4.4 |
| **arXiv q-fin** — 4 query, titoli in tema letti a nome | **~50** | 🔴 mercati elettrici, LOB/Hawkes, cripto, esecuzione ottimale, ML. `1411.2153` (*Evolving intraday FX strategies*) = **programmazione genetica su multi-strumento** — una macchina per fabbricare overfitting, scarto a titolo+abstract. `2006.08307` (*HMM applied to intraday momentum*) = **stessa classe del GMM non riproducibile** di Mesfin §5, scarto per la stessa ragione gia' verbalizzata |
| **GitHub** topic `mql5` | **~8** | 🔴 spam SEO (§2) |

---

## 5. 🟢 IL PROMOSSO — uno solo, ordinato per frequenza attesa (§ mandato)

### 🥇 P1 — `EURUSD 5min london session strategy` — **canale delle medie a 5 + estremo RSI, dentro la sessione di Londra, con TETTO e CAP DI PERDITA GIORNALIERI dentro il motore**

```
FREQUENZA ATTESA   ~5 SEGNALI/GIORNO  <-- PRIMO CAMPO, come da mandato
                   [DICHIARATA DALL'AUTORE SULLA PAGINA, non misurata da noi]
                   verbatim: "preferably no more than 5 trades / day, and no
                   more than 2% risk of equity lost"   [VERIFICATO]
                   confermata nel SORGENTE da due righe indipendenti:
                     strategy.risk.max_intraday_filled_orders(6)
                     strategy.risk.max_intraday_loss(2, percent_of_equity)
                   -> e' l'UNICO oggetto delle DUE battute in cui la frequenza
                      e' scritta sia in prosa sia in codice.

NOME               EURUSD 5min london session strategy
                   (scriptName nel JSON: "Moving Average" -- file riciclato)
FONTE / URL        https://www.tradingview.com/script/E6yr9CoN-EURUSD-5min-london-session-strategy/
                   sorgente scaricato integrale da pine-facade /get/ (campo "source")
AUTORE / DATA      (c) SoftKill21  ---  created 2020-08-30T11:45:29Z  [VERIFICATO nel JSON]
POPOLARITA'        294 "agree"  [VERIFICATO]      ACCESSO  access=1 / open_no_auth
LICENZA            Mozilla Public License 2.0  [VERIFICATO, riga 1 del sorgente]
RIGHE / INPUT      52 righe Pine v4  ---  8 input (di cui 2 sono i due lati
                   della stessa soglia RSI) -> il piu' corto della battuta
COPIA IN CASA      caccia_strategie/biblioteca/sorgenti/
                   EurUsd5minLondonSession_SoftKill21-MPL2_tvE6yr9CoN_2026-08-31.pine
```

#### 5.1 🧭 TESI IN UNA RIGA

> _"Nella sessione di Londra il flusso su EURUSD arriva a raffiche: quando una
> candela chiude **fuori dal canale stretto** formato dalla media a 5 dei
> massimi e dalla media a 5 dei minimi, quella raffica e' appena partita e non
> e' ancora finita. Si prende un pezzo di raffica con un take piu' grande dello
> stop, si esce a fine sessione comunque, e ci si ferma dopo che la giornata
> ha gia' pagato — o dopo che ha gia' perso il 2%."_

#### 5.2 ⚙️ MECCANICA — letta riga per riga, non dalla descrizione

1. **Il canale (righe 6-17):** `out = sma(high, 5)` e `out2 = sma(low, 5)`.
   Due medie a **5 periodi**, una sui massimi e una sui minimi. Il canale
   **abbraccia il prezzo**: non e' una banda lontana.
2. **Il grilletto (righe 26-27):** long se `close > out **and** close > out2`;
   short lo specchio esatto. 👉 **La chiusura FUORI dal canale, non un tocco.**
3. **La conferma (stesse righe):** `vrsi = rsi(close, 5)` con
   `overBought = 80` / `overSold = **10**`.
   🔴 **Le due soglie sono ASIMMETRICHE, ed e' la firma della taratura
   dell'autore:** `RSI(5) > 80` capita spesso, `RSI(5) < 10` capita molto meno.
   ➡️ **Il lato short dell'autore fa molti meno trade del long.** Da noi la
   soglia si sweepa **SIMMETRICA** (regola dei due lati, 25/08).
4. **La finestra (riga 5 + 26-27):** `timeinrange(timeframe.period, "0300-1100")`.
5. **🎯 IL FLAT OBBLIGATORIO (ultima riga):**
   ```pine
   strategy.close_all(when = not timeinrange(timeframe.period, "0300-1100"))
   ```
   **Non e' un `input.bool`: e' una riga sempre attiva.** Zero overnight per
   costruzione → nessuno swap, nessun problema di leva prop, muro giornaliero
   leggibile.
6. **🎯 I DUE TETTI GIORNALIERI, DENTRO IL MOTORE (righe 43-46):**
   ```pine
   strategy.risk.max_intraday_filled_orders(6)          // max 6 ingressi/giorno
   strategy.risk.max_intraday_loss(2, strategy.percent_of_equity)  // stop al -2%
   ```
   🏛️ **Il secondo e' raro e vale doppio in ottica prop:** e' un **cap di
   perdita giornaliera scritto nell'EA**, cioe' il muro dei −5.000 su 100k
   affrontato dal motore invece che dal Guardiano.
7. **Le uscite (righe 30, 34):**
   `strategy.exit("long_exit","long", profit = tp, loss = sl)` con
   **`tp = 150`, `sl = 80`** → **RR lordo = 1,875**.

#### 5.3 🚩 LA BANDIERA GIALLA CHE ALZO IO, PRIMA DI CLAUDIO

**L'autore stesso chiama l'RSI un accessorio.** Verbatim dalla pagina
[VERIFICATO]:

> _"If the candle close above or below the channel we got a signal. **Then we
> can optionally verify with the RSI** to increase our chances."_

🔴 **Tradotto nel nostro metro: il motore e' la rottura del canale, l'RSI e' un
FILTRO APPICCICATO** — e in casa il filtro appiccicato a un motore gia' tarato
fa **0 successi su 5** (`ROBUSTEZZA.md` §5B: R20 ADX, R12, R26, R45, R54).

✅ **Ma questo non e' un motivo di scarto: e' un'ABLAZIONE GRATIS, e va
congelata PRIMA.** Nel sorgente l'RSI **non e'** opzionale (e' cablato nell'AND):
basta un `InpUsaRsi` per avere le due gambe.

> 🔬 **ABLAZIONE 1, OBBLIGATORIA:** `canale nudo` **contro** `canale + RSI`.
> - se il nudo va **uguale o meglio** → l'RSI e' decorazione, si toglie, e il
>   candidato diventa un motore a **due** parametri;
> - se il nudo **crolla** → l'RSI **e'** il motore e il punteggio sale;
> - se **perdono entrambi** → la classe "rottura di canale stretto a M5 su
>   major" ha la sua falsificazione e si chiude in un round.
>
> **In tutti e tre i casi impariamo un numero.** Senza questa ablazione P1
> **non e' giudicabile.**

#### 5.4 🔍 PERCHE' NON E' NESSUNO DEI MORTI — confronto asse per asse

| | R45/ORB | R42 fade | R60 MeanRevert | **BreakingBand M15 (R108/R111)** | R98 momentum | **P1** |
|---|---|---|---|---|---|---|
| il livello | massimo del box d'apertura, **fisso per la giornata** | estremo del box | estremo a 200 barre | banda Bollinger **20, 2σ** = lontana dal prezzo | nessuno (orario fisso) | **canale SMA5 alto/basso = ADERENTE al prezzo, si rigenera ogni barra** |
| occasioni/giorno | **1** | **1** | poche | poche | **1** | **~5, dichiarate dall'autore e capped a 6 nel codice** |
| direzione | a favore della rottura | **contro** | **contro** | a favore | a favore | **a favore** |
| take | RR fisso | RR fisso | **punto medio, RR 1:1** | banda opposta | orizzonte fisso | **150 tick fissi, RR 1,875** |
| flat di sessione | no | no | no | no | si' | **SI', incondizionato** |
| cap giornaliero | no | no | no | no | no | **SI', doppio (6 ordini + 2% di perdita)** |

**🟠 L'adiacenza vera, e la nomino io: `ABTG_BreakingBand` a M15 e' MORTO**
(R108/R111, **6 finestre su 6 rosse**, PF 0,64-0,87, gradiente **H1 > M30 >
M15 monotono su 3 simboli**), e P1 sta **un gradino piu' in basso, a M5**.

**Perche' sostengo che il meccanismo di morte non si trasferisce:**

| il collo che ha ucciso BreakingBand | perche' qui non c'e' |
|---|---|
| il **take si accorcia col timeframe** (la banda opposta e' piu' vicina a M15 che a H1) → _"incassa 6,65 pip contro perdite da 16,5"_ | 🟢 **il take di P1 e' in PIP FISSI (150 tick), non strutturale**: scendere di TF **non lo accorcia**. E' lo stesso argomento gia' accettato per P2 il 28/08 (_"30 contro 30"_) |
| la banda 2σ e' **lontana**: romperla = movimento gia' esteso = territorio di mean-reversion | 🟢 **il canale SMA5 e' ADERENTE**: romperlo e' un evento di momentum banale, non un estremo. **Sono due segnali opposti con lo stesso nome** |

🔴 **E il rischio residuo lo scrivo lo stesso: se la sonda dice che a M5 il
take mediano realizzato non arriva ai 150 tick, allora il gradiente R108/R111
ha colpito anche qui e P1 si chiude.** E' il cancello F2 del §7.

#### 5.5 ⚠️ IL CONFRONTO PIU' SCOMODO: P1 CONTRO IL P2 DEL 28/08 — **stesso autore, stessa coppia, stessa sessione**

Non lo nascondo, e' il rilievo piu' forte contro questa promozione.

| | **P2 — `Money maker EURUSD 15min`** (28/08, 🟡 in coda, **mai girato**) | **P1 — oggi** |
|---|---|---|
| autore | SoftKill21 | **SoftKill21** |
| simbolo / sessione | EURUSD / Londra | **EURUSD / Londra** |
| timeframe | M15 | **M5** |
| motore | **allineamento di 5 medie** (SMMA 3/6/9/50 + EMA200) | **rottura di un canale a 2 medie** (+ RSI, ablabile) |
| manopole del motore | **5 lunghezze** | **2** (+1 se l'RSI resta) |
| tetto giornaliero | **2 ordini** | **6 ordini + cap di perdita al 2%** |
| geometria | **TP 300 / SL 300 → RR 1,00** | **TP 150 / SL 80 → RR 1,875** |
| **win rate per superare H8** | **53,8%** | **37,4% lordo · 42,0% netto** |
| flat a fine sessione | ✅ incondizionato | ✅ incondizionato |
| rischio in % nel sorgente | ✅ **si'** (la parte migliore di P2) | ❌ **no**, `strategy.entry(...,1)` |

> 🎯 **La verita' onesta: NON sono due candidati, sono due MOTORI dentro LO
> STESSO CONTENITORE** — finestra di sessione, `close_all` incondizionato,
> tetto giornaliero, due lati, decisione su barra chiusa. **Il contenitore e'
> il 70% del lavoro di porting, e si scrive UNA volta sola.**
>
> ✅ **Percio' la proposta operativa non e' "un EA in piu'", e': UN solo EA di
> casa (`ABTG_LondonFx`) con il contenitore condiviso e il MOTORE come
> interruttore** (`InpMotore = 0 canale · 1 canale+RSI · 2 allineamento 5
> medie`). Costo marginale del secondo motore: **~1 ora**. E in cambio si ha
> l'**ABLAZIONE 2** gratis: *lo stesso contenitore, tre motori diversi* —
> che e' il disegno che il §5B di `ROBUSTEZZA.md` chiede da sempre e che in
> casa non abbiamo quasi mai potuto fare.
>
> ⚠️ **E vale anche il contrario, e lo dico:** se **tutti e tre** i motori
> vanno uguale, allora **il contenitore E' l'edge** (la sessione, il flat, il
> cap) e il segnale non conta — che sarebbe la scoperta piu' grossa delle due
> battute, e cambierebbe la caccia.

#### 5.6 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**🟢 DA TENERE (il motore e il contenitore):** il canale a due medie sui
massimi/minimi; il segnale su **chiusura fuori**, non su tocco; la finestra di
sessione; il **`close_all` incondizionato**; il **tetto di ordini giornalieri**;
il **cap di perdita giornaliera al 2%**; la simmetria dei due lati dallo stesso
codice; la decisione su **barra chiusa** (Pine v4, **niente `calc_on_every_tick`**).

**🔧 DA RIFARE (la gestione — la parte che sappiamo fare):**

| difetto, con la riga | perche' morde | cosa ci mettiamo |
|---|---|---|
| `strategy.entry("long", 1, when=longcond)` → **quantita' 1 unita' fissa** | non scalabile a 100k, non confrontabile | **rischio in % dell'equity** sulla distanza dello stop (il blocco esiste gia' in P2 e in `ABTG_VwapRevert`) |
| `tp = 150` / `sl = 80` **in tick fissi** | scollegato dalla volatilita': 15 pip nel 2020 e nel 2026 sono due rischi diversi | **SL in ATR con pavimento `InpMinSLPts`** (R109), TP a multiplo di R. ⚠️ **ma la geometria RR 1,875 va PRESERVATA**: e' l'unica ragione per cui il candidato passa H8 |
| soglie RSI **80 / 10 asimmetriche** | e' la taratura dell'autore, e sbilancia i due lati | **soglia unica simmetrica**, sweepata su 3 valori |
| nessuna gestione (niente parziale, niente breakeven) | — | **parziale 1R + breakeven + runner**, la gestione delle nostre sedie. ⚠️ **NON nel primo round**: prima si misura il motore nudo |
| nessun filtro di spread | R55 | **spread come % dello stop**, non in punti |
| `"0300-1100"` senza argomento di fuso | ⚠️ **`time(res, sess)` senza fuso usa il fuso dello SCAMBIO del simbolo**, che su un grafico FX di TradingView e' **[INCERTO]** (UTC o New York a seconda del feed) | 🔴 **l'ora NON si converte a tavolino: si SWEEPA.** Vedi §5.7 |
| nessun `OnTester`, nessun magic | il driver non parte | obbligatori |

#### 5.7 🕐 L'ORA — dichiarata in ORA SERVER, con l'incertezza scritta

Regola di casa: `ora server BCM = ora italiana − 1`. Ad agosto l'Italia e'
UTC+2, quindi **server BCM = UTC+1**.

| se il fuso del grafico e' | `"0300-1100"` diventa, in ORA SERVER BCM |
|---|---|
| **UTC** (feed tipo FX_IDC) | **04:00 – 12:00 server** |
| **America/New_York** (feed tipo OANDA) | **08:00 – 16:00 server** |

> 🔴 **Non so quale dei due sia, e non lo invento.** [INCERTO]
> 🟢 **Ma la cosa utile e' che entrambe le letture cadono su Londra**
> (04:00-12:00 server = pre-Londra + mattina; 08:00-16:00 server = Londra
> piena + sovrapposizione NY). **La sessione e' quella giusta in tutti e due i
> casi**, e l'incertezza si risolve **sweepando l'ora di inizio su 3 valori**,
> che e' un asse legittimo e non una manopola nascosta.
> ⚠️ E vale il richiamo di `CLAUDE.md`: **i log MT5 sono in ora locale, il
> grafico in ora server.** L'ora si verifica sull'orologio, non a memoria.

#### 5.8 💰 F2 — LA TAGLIA DEL TAKE, e **perche'** batte la frizione

🔴 **Prima l'ambiguita', dichiarata:** in Pine, `profit=` e `loss=` di
`strategy.exit` sono **in TICK**, non in pip. Su un feed EURUSD a **5
decimali** (mintick 0,00001) `tp=150` sono **15 pip** e `sl=80` sono **8 pip**;
su un feed a 4 decimali sarebbero 150 e 80 **pip**. L'autore scrive
_"a TP/SL system made of pips"_, quindi probabilmente intendeva pip.

🟢 **E la buona notizia e' che la conclusione NON dipende da quale sia:**

| lettura | take | spread EURUSD di riferimento | **take / spread** | cancello F2 (≥ 3×) |
|---|---:|---:|---:|---|
| 5 decimali (probabile) | **15 pip** | ~1 pip | **15×** | 🟢 **passa con cinque volte il margine** |
| 4 decimali | 150 pip | ~1 pip | 150× | 🟢 passa |

**E il RR — cioe' il numero che conta davvero — e' 150/80 = 1,875 in ENTRAMBE
le letture**, perche' e' un rapporto.

> 🎯 **Ed ecco il "perche'" che il mandato chiede esplicitamente:** su un major
> lo spread e' ~1 pip contro un movimento di sessione di **60-100 pip**. La
> frizione vale **~1-2%** del range disponibile. Sugli indici la stessa
> frizione (2,0 punti su un range di 60-80) vale **~3%**, e a M5 su un
> movimento di 15-20 punti vale **~12%**. 👉 **Non e' un merito del candidato:
> e' un fatto strutturale del mercato dei cambi**, e va scritto cosi' — come
> gia' misurato il 31/08 sullo scarto S5 (`EURUSD Sniper`: TP 35 pip = 35× la
> frizione).
> ⚠️ **Con l'avvertenza che pesa:** **lo spread BCM su EURUSD non e' mai stato
> MISURATO in repo.** L'1 pip e' una convenzione di mercato, marcata
> **[SPREAD NON MISURATO]**. Il *RealCost Spread P95 Logger* (Code Base
> **74148**) e' promosso dal 23/08 e mai usato: **sesta caccia che lo scrive.**

#### 5.9 🧮 P1 CONTRO IL CANCELLO H8 — l'aritmetica, fatta PRIMA di spendere una macchina

Geometria **letta nel sorgente**, non stimata: rischio = 80 tick, premio = 150
tick → **RR lordo = 1,875**. 🟢 **Sopra 0,70: NON e' uno scarto per aritmetica.**

Con `p ≥ 1,075 / (RR + 1)`:

| scenario di costo | RR netto | **win rate necessario** |
|---|---:|---:|
| nessun costo (geometria pura) | 1,875 | **37,4%** |
| 1,0 pip di costo (spread convenzionale) | 1,556 | **42,0%** |
| 1,5 pip (spread + slippage) | 1,421 | **44,4%** |
| 2,0 pip (scenario pessimista) | 1,300 | **46,7%** |

> 🎯 **Anche nello scenario pessimista serve meno del 47%.** Confronto interno
> che vale piu' di qualunque numero d'autore:
> - **M0PB** (l'altro promosso di oggi): stop **2,75 ATR** contro un premio di
>   ~1-2 ATR → serve **62-79%**;
> - **P2** (28/08): TP=SL → serve **53,8%**;
> - **NY Session Retest** (misurato in casa a tick): **PF 1,002** su n=625.
>
> ➡️ **P1 e' il primo candidato ad alta frequenza che arriva al cancello H8
> con l'aritmetica dalla sua parte invece che contro.**
>
> 🔴 **Il rovescio, che scrivo io:** RR 1,875 significa che il win rate vero
> sara' **basso** (probabilmente 40-50%), e quindi **serie di perdite lunghe**.
> Con **fino a 6 trade al giorno**, sei stop nella stessa mattina sono
> **6 × 0,65% = 3,9%** — 🚨 **dentro il muro giornaliero prop del 5%, ma di
> pochissimo, e sopra il cap C1 di rischio aperto (3,25%)**. Vedi §5.11.

#### 5.10 🏛️ IN OTTICA PROP

- 🟢 **E' il primo candidato che porta il muro giornaliero DENTRO il motore.**
  `strategy.risk.max_intraday_loss(2, percent_of_equity)` e' **esattamente** la
  forma che `METRO_PROP` chiede (−5.000 su 100k). Nessun EA della flotta ce
  l'ha: il cap oggi sta solo nel Guardiano (pausa 4,0 / emergenza 4,9).
- 🟢 **Zero overnight per costruzione** → niente swap, nessun downgrade di leva
  a 1:30, nessuna esposizione al weekend gap.
- 🔴 **Il rischio giornaliero e' il suo punto debole, ed e' strutturale.** Sei
  trade sullo **stesso simbolo, nella stessa sessione, sullo stesso flusso**
  non sono sei rischi indipendenti: sono **uno solo, moltiplicato**. La peggior
  giornata misurata in casa e' **−2,06%** (R51) con motori a ~1 trade/giorno.
  👉 **`InpMaxTradesPerDay` NON e' un'aggiunta: e' un input del primo round**, e
  il suo valore va tagliato **sul massimo di segnali in una giornata misurato
  dalla sonda**, non a occhio. **Prima si legge la peggior giornata, poi il PF.**
- 🔴 **Forma a RR alto = win rate basso = SERIE DI PERDITE LUNGHE.** E' la forma
  **opposta** a quella che il DD trailing punisce (`METRO_PROP`, Upcomers:
  pochi stop grossi dopo tanti take piccoli), quindi **su questo asse e'
  favorito** — ma produce **lunghi ritorni dal picco**, che il trailing
  **punisce comunque**. 🔴 E le nostre Monte Carlo sono tutte su **DD statico
  dal deposito**: col trailing **non valgono**, e non e' mai stato ricalcolato.
- 🎯 **SCORRELAZIONE — e qui la notizia e' buona.** Lavora su **EURUSD** in
  **sessione europea**. La flotta viva e' quasi tutta su **indici** (DAX/Dow/
  Nasdaq/CAC) e **oro**; le sedie forex (PTE GBPUSD/USDJPY, EasyTrend, FiboH4)
  sono su **H1/H4 con tenuta di giorni**. **Un motore M5 intraday su EURUSD non
  esiste in flotta in nessuna forma.** ⚠️ **Ma** sovrappone la **finestra
  oraria** con `ABTG_DAX_Apertura_EU` (08:00 server) e `MaxMinNotte_DAX_Short`
  → **regola di rotta 1: mai a rischio pieno insieme finche' la correlazione
  fra le serie per-trade non e' MISURATA.**

#### 5.11 📊 PUNTEGGIO

- **[2] semplicita'** — **52 righe, 8 input**, di cui il motore ne usa 2 (+1
  per l'RSI). E' il candidato piu' corto delle due battute.
- **[1] il filtro E' il motore** — 🟡 **e questo e' l'unico voto basso, ed e'
  giusto che lo sia.** La sessione e i due cap **sono** costitutivi (`close_all`
  incondizionato, non un `input.bool`); ma **l'RSI e' dichiarato accessorio
  dall'autore stesso** → filtro appiccicato, 0/5 in casa. **Il voto sale a 2
  solo se l'ABLAZIONE 1 mostra che il nudo crolla.**
- **[2] tesi di mercato scrivibile** — sopra, una riga.
- **[2] riempie un BUCO** — **quattro buchi insieme**: (a) la **FREQUENZA**
  (~5/giorno dichiarati, l'unico caso in due battute); (b) **forex major
  intraday a M5**, che in flotta **non esiste**; (c) **due lati simmetrici**
  (14 celle vive quasi tutte long-only); (d) il **cap di perdita giornaliera
  dentro il motore**, che nessun nostro EA ha.
- **[1] testabile senza riscritture** — 🔴 **Pine → MQL5 e' una RISCRITTURA.**
  Onesto: **~1 giornata** per il contenitore + i motori, **~4 ore** se si
  riusa il chassis di `ABTG_SondaM0PB` per la sonda.

## **VERDETTO: 🟢 PROVA — 8/10**

**PERCHE':** e' l'unico oggetto delle due battute che porta **i tre numeri del
mandato tutti e tre, e tutti e tre leggibili prima di accendere una macchina**
— **frequenza dichiarata** (~5/giorno, in prosa E in codice), **taglia** (15×
la frizione, e il perche' e' strutturale), **geometria** (RR 1,875 → 42% di win
rate per superare H8, contro il 62-79% di M0PB). Il suo punto debole non e'
un'opinione: e' **una variabile isolabile** (l'RSI accessorio), con
l'ablazione gia' scritta e congelata sopra.

---

## 6. 🔴 DIREZIONE B — **ZERO CANDIDATI, e la risposta e' in casa**

Il mandato chiedeva meccanismi intraday a **tenuta lunga dichiarata (ore, non
minuti)** con **≥ 1 trade/giorno**. Ho cercato su tutte e tre le fonti indicate.
**Non ne esiste uno nel web gratuito, e il motivo e' strutturale:**

| fonte | cosa ho trovato | perche' non produce candidati per B |
|---|---|---|
| **TradingView** (15 query dedicate: `hold to close`, `time based exit`, `exit after n bars`, `hold 15 bars`, `session drift`, `bar count exit`, ...) | **5 strategie open-source in tutto**, e sono breakout o cripto | 🔴 **Il retail esce su TP/SL, non sul tempo.** L'uscita a tempo come uscita PRIMARIA (il `D041 — LOCKED` di Mesfin) **praticamente non esiste** nel Pine pubblico |
| **QuantConnect** | libreria letta: intraday = ETF US con **1 trade/giorno**; forex = fattori a **ribilancio mensile** | 🔴 **Tiene a lungo ma ribilancia il mese, oppure tiene poco e fa 1/giorno.** Mai le due cose insieme |
| **Quantpedia** | 8 slug in tema (`intraday-closing-momentum-in-futures`, `cross-market-intraday-time-series-momentum`, ...) | 🔴 **PREMIUM: nomi, non regole** |
| **arXiv q-fin** | 6 query, nessun titolo nuovo utilizzabile | 🔴 I due "vincitori" a tenuta 60-65 min di 2605.04004 §5 restano **non riproducibili** (GMM non pubblicato, verificato sui 3 paper dell'autore) **e sotto il pavimento** (0,72 e 0,31 trade/giorno) |

### 🎯 E allora la risposta utile alla direzione B non e' un EA nuovo

C'e' **una sola forma** che soddisfa insieme "tenuta di ore" e "≥1/giorno", ed
e' **strutturale del forex**: il mercato dei cambi ha **tre sessioni al
giorno**; una posizione per sessione = **2-3 trade/giorno**, ciascuno tenuto
**4-8 ore**. E' **esattamente la geometria che il paper dichiara sopra il
soffitto**, e non richiede nessun indicatore.

🔴 **Quel motore ce l'abbiamo gia', e non e' mai stato acceso.**

| artefatto (verificato in repo stanotte) | stato |
|---|---|
| `mql5/Experts/ABTG_SondaOrologio.mq5` | **esiste** (972 righe, nucleo ~120) |
| `prove/SONDA_OROLOGIO_00_GEMELLI.txt` + `_01`…`_06` (3 simboli × 2 lati) | **esistono, 7 file** |
| `prove/SONDA_OROLOGIO_FX.txt` (la specifica congelata) | **esiste** |
| `righe/RIGA_SONDA_OROLOGIO_DA_MANDARE.md` | **esiste, riga di lancio pronta** |
| `prove/REFERTO_PREPARAZIONE_OROLOGIO.md` | **esiste** |
| **un referto di risultati in `risultati_archivio/`** | 🔴 **NON ESISTE. Cercato: zero file. La sonda NON E' MAI GIRATA.** |

> ### 🎯 La raccomandazione, e vale piu' del promosso
> **La direzione B non ha bisogno di un candidato nuovo: ha bisogno che si
> accenda quello che e' gia' pronto da tre giorni.** `L'OROLOGIO` e' il solo
> meccanismo FX a tenuta di ore, con frequenza ≥1/giorno per costruzione, che
> il progetto possieda — e costa **una riga di lancio gia' scritta**, non una
> giornata di porting.
> **Comprarne un altro fuori, stanotte, sarebbe spendere due volte per la
> stessa cosa.** ➡️ Questo e' un rilievo per la **FIRMA 1, punto 4**
> ("sedie nuove per regime + caccia-frequenza"): **prima si raccoglie il
> lavoro gia' pagato.**

---

## 7. 📦 IL PASSO 0 — **si conta PRIMA, si giudica DOPO**

🔴 **Non propongo una griglia. Propongo un CONTATORE** — stessa ragione della
prima battuta: **le tre fonti dati sono murate e la frequenza da qui NON si
misura** (§2). E la frequenza e' il **pavimento**, cioe' la cosa che puo'
uccidere il candidato **prima** che si scriva un EA.

Precedenti di casa, entrambi validi: la **SondaMediazione** (firma di Claudio
del 21/08, _"metro, frequenza"_) e la **SondaM0PB** scritta stasera.

**La sonda deve restituire questi numeri, e i cancelli sono congelati QUI:**

| # | numero da misurare | cancello congelato PRIMA |
|---|---|---|
| 1 | **segnali/giorno per LATO** (chiusura fuori dal canale SMA5 alto/basso, dentro la finestra) | **< 1/giorno → SCARTO IMMEDIATO.** 1-2 passa al minimo, **> 2 fascia preferita** |
| 2 | **stessi segnali, con la conferma RSI accesa** | 🔬 **e' l'ABLAZIONE 1 gratis, al costo di due colonne**: se l'RSI taglia i segnali sotto 1/giorno, **il filtro uccide il pavimento** e va tolto prima ancora di parlare di merito |
| 3 | **mediana dell'escursione favorevole a 12 barre** dall'ingresso, in **pip** | **< 3,0 pip → SCARTO** (F2, `3 × ~1 pip`). Fra 3 e 6 → **SOSPESO**, e si misura finalmente lo spread col Code Base **74148** |
| 4 | **mediana dell'escursione avversa** a 12 barre, in pip | serve a leggere **se lo stop da 8 pip e' sopra o sotto il rumore** (F9) |
| 5 | **RR = (3) / (4)** | 🖊️ **cancello H8.** **RR < 0,70 → SCARTO PER ARITMETICA**, senza corsa a tick |
| 6 | **massimo di segnali in UNA giornata** | e' il numero che taglia `InpMaxTradesPerDay` **sui dati**. 🚨 **Se il massimo × 0,65% supera il cap C1 (3,25%), il cap va messo nell'EA dal primo round** |
| 7 | **gradiente di TF**: gli stessi numeri a **M5 e M15** | e' R108/R111 visto dall'altro lato: **se la taglia crolla a M5, il gradiente ha colpito anche qui** |

**Simboli:** **EURUSD** (lead, il simbolo dell'autore), **GBPUSD**, **USDJPY**
— i tre major a minimo attrito indicati da Claudio, e i tre su cui R102 ha
**misurato** che le operazioni cominciano il **1999.01.04**.
**TF:** **M5** e **M15**. **Lati:** separati, sempre (regola 25/08).

📄 **File prova (BOZZA, col cartello):**
`backtest_pipeline/prove/LONDONFX_FREQUENZA_BOZZA.txt`

⚠️ **Non e' una prova operativa, e non e' pigrizia: e' la regola di casa.**
Ne' l'EA ne' la sonda esistono; un file prova che pinna input inesistenti e'
l'**errore n.3 della `CHECKLIST_RIGA_DI_LANCIO`**, e MT5 **ignora in silenzio**
un pin che non trova — e' cosi' che e' nato il falso "0/8" del FiboH4
(`REGISTRO_TEST.md` §2-bis). **Prima la sonda, poi il numero, poi — solo se il
numero regge — l'EA.**

🔴 **E `@DAQUANDO` resta VUOTO, per una ragione misurata (§1-bis): la
profondita' TICK del forex BCM non e' mai stata sondata.** Il 1999.01.04 di
R102 e' su **OHLC M1**. La data si misura con `scarica_storico.ps1`, non si
copia da un referto che parlava di un altro modello.

---

## 8. 🧱 LE COSE DA TENERE AGLI ATTI (spec e mattoni, non candidati)

### 8.1 🏛️ Il **cap di perdita giornaliera dentro l'EA** — il mattone prop della battuta
Da P1, riga 46: `strategy.risk.max_intraday_loss(2, strategy.percent_of_equity)`.
> **Nessun EA della flotta ha un cap di perdita giornaliera al suo interno**:
> oggi il muro dei −5.000 su 100k e' difeso **solo dal Guardiano** (pausa 4,0 /
> emergenza 4,9). Un motore che si spegne da solo al −2% e' una **seconda
> linea**, e su un motore da 6 trade/giorno **non e' un lusso**. 👉 Da valutare
> come input standard degli EA ad alta frequenza, **non solo di questo**.

### 8.2 🔧 Il **breakeven che paga la commissione** — dallo scarto S5
```pine
beOffset = input.int(1, "Break Even Offset (Ticks for Commission)")
beLevelLong = strategy.position_avg_price + (beOffset * tickSize)
```
> Il nostro breakeven mette lo stop **al prezzo d'ingresso**: un trade portato
> a "pari" chiude **in perdita dello spread**. Su un motore da 6 trade/giorno
> quella perdita e' sistematica. **Un `InpBeOffsetPts` costa tre righe.**

### 8.3 📐 Il blocco di sizing e i `lookahead_off` — dallo scarto S7
Il Pine di kevinmck100 e' il meglio scritto della battuta: quantita' calcolata
da `accountRiskPercent` sulla distanza dello stop, e **entrambi** i
`request.security` con `barmerge.lookahead_off` **e** `barmerge.gaps_off`.
**E' l'idioma no-repaint scritto giusto**, da citare quando serve.

### 8.4 📕 Rilievo di processo — **il `SETACCIO_MANUALE` indicizza URL, non TITOLI**
Stanotte ho riscaricato e riletto `Trade Beta` (S4), gia' scartato il 28/08
come S19, perche' la ricerca testuale gli assegna uno `scriptIdPart` diverso
dall'URL a verbale. **Costo: ~10 minuti.** ➡️ **Il prossimo cacciatore
indicizzi anche `scriptName` + autore**, non solo il link. (Si aggiunge al
rilievo del 28/08 sui `report/SWEEP_*` non indicizzati.)

---

## 9. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perche', e cosa ci costa |
|---|---|
| 🔴 **LA FREQUENZA, DI QUALUNQUE CANDIDATO** | **Tre fonti dati indipendenti, tutte e tre murate al CONNECT** (Yahoo, Stooq, Dukascopy). **Il numero che il mandato mette per PRIMO e' proprio quello che da qui non si misura.** La frequenza del promosso e' **[DICHIARATA DALL'AUTORE + INFERITA DA DUE RIGHE DI CODICE]**, non misurata. **Il numero lo fa il PC di Claudio** |
| 🔴 **LO SPREAD BCM MISURATO** su EURUSD/GBPUSD/USDJPY | **Non esiste in repo.** Uso ~1 pip di convenzione, marcato **[SPREAD NON MISURATO]**. Il Code Base **74148** e' promosso dal 23/08 e mai usato: **sesta caccia**. Finche' non gira, **il cancello F2 e' tarato su una convenzione** |
| 🔴 **LA PROFONDITA' TICK DEL FOREX BCM** | **Mai sondata** (§1-bis). Il 1999.01.04 di R102 e' **OHLC M1**. ➡️ `@DAQUANDO` vuoto nel file prova |
| 🔴 **Forex Factory** (403) | **NONA di fila.** Su una caccia alla frequenza pesa il doppio: i thread lunghi anni sono l'unico posto dove si legge **quanti trade al giorno faceva davvero** un sistema, e quando ha smesso |
| 🔴 **SSRN** (403) | **NONA di fila** |
| 🔴 **Le pagine strategia di Quantpedia** | **Premium, riconfermato su 4 slug**: nomi di effetti, non regole |
| 🔴 **Ricerca GitHub / API** | 403, nona di fila. Il topic `mql5` via `WebFetch` risponde ma e' **spam SEO** |
| 🟡 **40 delle 47 strategie TradingView leggibili** | Ne ho aperte **7**, scelte in bersaglio; le altre sono nel §4.5 con il motivo del primo taglio. **Il giacimento non e' esaurito, ma le 7 lette sono un campione onesto della sua qualita', e la qualita' e' bassa** |
| 🟡 **Il testo dei paper dietro gli slug Quantpedia** | SSRN 403 e mirror bloccati. **Conosco i nomi degli effetti, non le tabelle** |
| ⚠️ **Nessun backtest eseguito** | Qui non esistono MT5 ne' Strategy Tester. **Nessun numero di questo dossier e' stato misurato stanotte.** Quelli di casa vengono dai referti citati; quelli di fuori sono `[VERIFICATO su pagina/sorgente]`, `[DICHIARATO DALL'AUTORE]` o `[STIMA/INFERITO]` |
| 🔴 **I numeri di performance degli autori** | **Nessuno letto, nessuno usato.** L'unica cosa che ho preso dalla pagina del promosso e' la **frequenza dichiarata** — che e' un fatto di costruzione, non una performance, ed e' etichettata come dichiarata |

---

## 10. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Su EURUSD, nella sessione di Londra, quante volte al giorno il prezzo chiude fuori dal canale delle medie a 5 — e quel movimento ha davanti abbastanza spazio da pagare 15 pip di take contro 8 di stop?**

**E' la domanda giusta perche' e' la sola che puo' chiudere il candidato senza
scrivere una riga di EA operativo.** I tre numeri del mandato sono **tutti e
tre misurabili da un contatore**:

- se i segnali sono **meno di 1 al giorno**, P1 muore per **F1**, e con lui
  muore l'idea che la portata si compri sui major a M5;
- se la mediana dell'escursione a 12 barre e' **sotto 3 pip**, P1 muore per
  **F2** — e allora **il gradiente R108/R111 vale anche sul forex**, che
  sarebbe una scoperta che chiude un'intera direzione di caccia;
- se l'**RSI acceso** porta i segnali **sotto il pavimento**, l'RSI si toglie
  **prima** di qualunque discorso di merito (ABLAZIONE 1, gratis);
- se **passano tutti**, allora — e solo allora — si scrive **un solo EA
  contenitore** (`ABTG_LondonFx`) con i **tre motori a interruttore**
  (canale nudo · canale+RSI · allineamento a 5 medie = il P2 del 28/08), e la
  prima cosa che gira e' **l'ABLAZIONE 2: stesso contenitore, tre motori.**

**E se il contatore dice di no, quella e' una risposta utile quanto un
promosso:** vorra' dire che la portata **non si compra nemmeno sui major a
M5**, e allora resta in piedi una sola strada — quella scritta il 29/08 e mai
smentita: **piu' SIMBOLI a M15-H1, non piu' velocita'** — piu' la mossa che
questa battuta raccomanda comunque, e che non costa ricerca: **accendere
`L'OROLOGIO`, che e' pronto da tre giorni.**

---

_Dossier chiuso il 31/08/2026 (notte). **~95 strategie censite** su 6 fonti
(5 vive — **una mai usata prima: QuantConnect** — e 2 nulle) + 3 fonti dati
murate + 1 fonte premium; **65 query di ricerca**, **20 titoli di Code Base
interrogati uno per uno**, **1.118 slug Quantpedia enumerati**, **6 query
arXiv**; **9 oggetti letti nel sorgente o per intero** (7 Pine scaricati
integrali + 2 pagine strategia QuantConnect); **1 promosso, 0 in coda, 4 spec,
10 scarti motivati nel sorgente + ~236 scarti al primo taglio**; **1
correzione misurata al mandato** (§1-bis) e **1 correzione tecnica alle fonti**
(§2-bis).
**Nessun backtest eseguito. Nessun numero d'autore usato in nessun punteggio.
Nessun EA modificato, nessuna sedia toccata, nessun magic assegnato.**_
