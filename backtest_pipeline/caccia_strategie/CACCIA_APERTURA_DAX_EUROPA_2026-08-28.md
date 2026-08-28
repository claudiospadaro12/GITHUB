# 🏹 CACCIA — L'APERTURA EUROPEA (DAX / Francoforte 08:00 server) — 28/08/2026, seconda battuta

**Mandato (sessione principale, 28/08, secondo giro):** la caccia
`CACCIA_INTRADAY_INDICI_2026-08-28.md` di stamattina ha guardato ~470 titoli
TradingView e 320 del Code Base, ma **quasi tutti i sorgenti letti erano tarati
sul mercato USA** (NY 09:30, SPY/QQQ/NQ/MES, orari hardcoded americani).
Il **DAX era quasi assente**. Questa battuta non ripete quella caccia: la
**estende sul buco geografico** — meccanismi espliciti per l'**apertura
europea** (Francoforte/Londra, **08:00-09:00 ora server BCM**).

Vincoli identici a stamattina: intraday puro (**mai overnight**, per non
scendere da FTMO Standard 1:100 a Swing 1:15/1:30), **chiusura forzata entro la
sessione**, licenza aperta, sorgente leggibile, rischio in %, stop reale al
broker.

---

## ⚡ IL RISULTATO IN UNA RIGA — ed è una risposta negativa, dichiarata come tale

> **Su 66 interrogazioni TradingView (31 rendono ZERO strategie), 480 titoli del
> Code Base ricrawlati su 12 pagine, 7 query arXiv, 4 ricerche GitHub e — la
> misura che vale più di tutte — un `grep` su 1.185 sorgenti `.mq5` liberi del
> mirror, ho aperto e letto 13 sorgenti Pine + 2 `.mq5` nel corpo della logica
> + 4 `.mq5` a livello di input. PROMOSSI: ZERO. Il campo è arato anche qui, e
> stavolta ho il numero che spiega perché.**

🔴 **Il numero che chiude la questione, e non l'aveva mai fatto nessuno:**

| grep su **1.185 sorgenti `.mq5` liberi** (mirror `GeneralTradingSarl/expert-mt5`) | file trovati |
|---|---:|
| `DAX` \| `GER30` \| `GER40` \| `DE30` \| `DE40` \| `Xetra` \| `Frankfurt` \| `Euro Stoxx` \| `FTSE` \| `CAC40` | **0** |
| `opening range` \| `premarket` \| `pre-market` | **0** |
| un input di **chiusura di fine giornata** (`CloseAtEnd`, `CloseEndOfDay`, `CloseAtSessionEnd`, …) | **0** |
| la parola `session` in qualunque punto del file | **23 su 1.185** |

[VERIFICATO oggi, 28/08/2026, `git clone --depth 1` + conversione UTF-16→UTF-8
di tutti e 1.185 i file, poi `Grep`.] 👉 **Il corpus MQL5 gratuito non è un
corpus di indici europei intraday: è un corpus di indicatori forex.** Non è
"non ho cercato bene": è che l'oggetto non c'è.

🟠 **E su TradingView il DAX c'è ma è CHIUSO A CHIAVE:** ho contato **14
strategie con DAX / GER40 / DE40 / Xetra / "Europe" nel nome**. Di queste
**11 hanno `access=2` o `3`** (sorgente protetto, il `pine-facade` risponde
401). **Le 3 leggibili non parlano dell'apertura** e cadono tutte e tre sul §4.

🟡 **Dove il DAX d'apertura esiste davvero è il MQL5 *Market*** — `DAX Morning
Scalp`, `Ger40 Morning Breakout`, `Viking Alpha DAX`, `Dax Retractor`,
`Neuron Net DAX40`… [VERIFICATO: titoli e URL restituiti dalla ricerca, §1.4].
🔴 **Fuori perimetro permanente** (`/market/` = compilato, a pagamento, senza
sorgente → il setaccio §4 non è applicabile). E per quel poco che le
descrizioni lasciano leggere, il meccanismo dichiarato è **breakout
d'apertura** — cioè il nostro capitolo chiuso da ~210 celle a tick reali.

✅ **Cosa porto a casa comunque, e non è niente:** **3 spunti di meccanica letti
nel sorgente**, di cui **uno è una variante concreta e a costo quasi zero del
round `InpRangeMode=1` che la sessione principale sta già preparando** — e che
**il nostro EA oggi NON sa esprimere** (§4). Più la conferma esterna che
`ABTG_MaxMinNotte_DAX_Short` è un'idea standard, e che la nostra versione è
**costruita meglio** di quella che gira libera (§3.4).

---

## 0. 📕 LETTO PRIMA DI USCIRE

`CACCIA_INTRADAY_INDICI_2026-08-28.md` (per intero), `backtest_pipeline/REGISTRO_TEST.md`,
`report/ROTTA_PROP.md`, `backtest_pipeline/caccia_strategie/SETACCIO_MANUALE.md`,
`CACCIA_2026-08-16_G_APERTURE.md` (la prima caccia sulle aperture DAX/Nasdaq),
`CACCIA_M5M15_INDICI_2026-08-25.md`, `report/SWEEP_MECCANISMI_2026-08-23.md`,
più i sorgenti `ABTG_DAX_Apertura_EU.mq5` e
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE.mq5`.

**Le porte che erano già chiuse e che NON ho riaperto** (mandato esplicito):
famiglia ORB/opening-range in ogni forma · fade del gap d'apertura **senza**
conferma (falsificato fuori: arXiv 2605.04004 tab. 5) · confluenze
multi-timeframe senza tesi economica · tutta la lista dei caduti del
`REGISTRO_TEST.md`.

### ⚠️ Il perimetro di duplicazione, misurato PRIMA di cercare

Questo è il punto che ha deciso metà degli scarti di oggi, e va scritto qui in
alto perché è **specifico del DAX**:

| oggetto **nostro** | cosa fa | dove sta scritto |
|---|---|---|
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (**sedia viva**) | box **23:00-04:59 server**, ordini **STOP piazzati alle 07:59 server**, **cutoff ingressi 08:30 server** ("solo la rottura *fresca* dell'apertura"), flat 17:30, `InpOneTradePerDay` | righe 71-87 del sorgente `..._MFE.mq5` [VERIFICATO] |
| `ABTG_DAX_Apertura_EU.mq5` (**sedia viva**, magic 770101) | `ABTG_RANGE_PREV = 1` esiste (riga 222) con `InpPrevWindowMin` (riga 257) — **range dai minuti PRE-apertura** | [VERIFICATO] |
| lo stato di quell'interruttore sul DAX | **tutti i 23 file prova DAX pinnano `InpRangeMode=0`**. Sul Nasdaq: 0 o 2, **mai 1**. Gli unici 3 file al mondo che pinnano `=1` sono i `PREOPEN_*_DOW_M15*` **creati stamattina** dalla caccia precedente, e sono sul **Dow** | [VERIFICATO con `grep` su `backtest_pipeline/prove/`, 28/08] |

> 🎯 **Conseguenza operativa:** sul DAX, **qualunque** candidato esterno del tipo
> "prendi il massimo/minimo delle ore prima dell'apertura e giocalo alle 08:00"
> è **doppione due volte**: della sedia viva `MaxMinNotte` (che quel box lo
> gioca già, a rottura) **e** dell'interruttore interno `InpRangeMode=1` (che
> lo giocherebbe a retest). ⚠️ È esattamente l'allarme che il mandato mi ha
> chiesto di verificare, ed **è confermato**: con una finestra pre-apertura
> larga si rientra nella notte asiatica/europea, cioè **dentro il box di
> MaxMinNotte**. Chi promuove un candidato di questa forma sul DAX deve
> misurare la **sovrapposizione delle giornate**, non stimarla.

---

## 1. 📡 CONTROLLO POSITIVO — fonte per fonte, misurato oggi

| fonte | HTTP | bersaglio noto verificato **oggi** | esito |
|---|---|---|---|
| **TradingView** — `pubscripts-suggest-json/?search=` | **200** | query `opening range` → 38.373 byte di JSON, primo risultato `Opening Range with Breakouts & Targets [LuxAlgo]` con `access`, `agreeCount`, `scriptIdPart` | 🟢 **PASSA** |
| **TradingView** — `pine-facade/get/PUB;<hash>/last` | **200** | restituisce `source` completo + `created` + `scriptAccess` | 🟢 **PASSA** |
| **MQL5 Code Base** | **200** | id **68951** → `UserDownloads:**2424**`. Erano **2.421** stamattina, 2.393 il 26/08, 2.383 il 25/08 → **pagina viva, non cache** | 🟢 **PASSA** |
| **arXiv API** (`https://export.arxiv.org`) | **200** | `cat:q-fin.TR AND all:"opening"` → 20 entry con titoli veri | 🟢 **PASSA** ⚠️ **in `http://` risponde 301 e 0 entry** — la nota del 16/08 regge |
| **GitHub** via `WebFetch` | **429 → 200** | `search?q=DAX+index+trading` → 2 repo con owner, descrizione, linguaggio, stelle | 🟢 **PASSA dopo backoff** |
| **Mirror `GeneralTradingSarl/expert-mt5`** via `git clone` | **OK** | 9.054 file, **1.185 `.mq5`** convertiti da UTF-16 | 🟢 **VIVO** |
| **SSRN** | non tentata | — | ⬜ **non tentata** (403 in otto cacce di fila; non spendo richieste) |
| **Forex Factory** | non tentata | — | ⬜ **non tentata**, stessa ragione |

### ⚠️ 1.1 — Nota tecnica NUOVA, da mettere in `PROMEMORIA_SBLOCCO_FONTI.md`

**La ricerca testuale del Code Base MQL5 NON esiste come GET.** Ho provato tre
strade e le dichiaro tutte:

| tentativo | esito |
|---|---|
| `mql5.com/en/code/mt5/experts?keyword=DAX` | **200 ma il filtro è IGNORATO**: restituisce **esattamente gli stessi 5 primi id** (76605, 76534, 76446, 76518, 76331) della pagina senza parametro. **Falso positivo pericoloso** — sembra una ricerca, è l'elenco |
| `mql5.com/en/search/results?query=DAX` | **404** |
| `mql5.com/en/search/do?query=…&module=mql5_module_codebase` | **404** |

👉 **L'unica strada che funziona resta lo sfoglio delle pagine di elenco**
(confermato per la terza volta, dopo il 16/08 e il 25/08). Chi in futuro vede
`?keyword=` rispondere 200 **non deve crederci**.

### 1.2 — TradingView: 66 interrogazioni, e 31 rendono ZERO

**Le query fatte** (65 + 1 di controllo), in sette tornate:

- **Germania/Europa esplicita:** `DAX`, `DAX open`, `DAX opening`, `German index`,
  `GER40`, `GER30`, `Frankfurt`, `Xetra`, `Euro Stoxx`, `Eurostoxx`, `DE40`,
  `DAX40`, `german dax`, `europe`, `germany`, `eurex`, `index futures europe`,
  `opening range europe`, `FTSE`, `CAC40`, `STOXX`, `IBEX`, `milan`, `paris`,
  `amsterdam`, `EU session`, `European session`, `Europe open`, `european open`
- **Sessione/pre-apertura:** `London open`, `London session`, `morning session`,
  `morning range`, `morning breakout`, `pre market`, `premarket`, `pre-open`,
  `overnight range`, `night range`, `asian range`, `asia range`,
  `asian session`, `globex`, `cash open`, `cash session`, `session open`,
  `opening bell`, `first candle`, `8:00`, `9:00`, `9am`
- **Meccanismo (non-ORB):** `opening auction`, `auction`, `opening drive`,
  `opening gap`, `index gap`, `futures gap`, `index open`, `open reversal`,
  `open fade`, `failed breakout`, `false breakout`, `range midpoint`,
  `midpoint retest`, `liquidity grab open`

🔴 **31 di queste 65 rendono ZERO strategie.** Fra le zero secche ci sono
proprio le più mirate: **`German index`, `GER30`, `Frankfurt`, `Euro Stoxx`,
`Eurostoxx`, `DE40`, `german dax`, `germany`, `eurex`, `index futures europe`,
`opening range europe`, `European session`, `Europe open`, `european open`,
`opening auction`, `cash open`, `cash session`, `night range`, `CAC40`.**

**Resa:** **~61 strategie uniche** con hash, autore, like e flag `access`.

### 1.3 — Il conto del DAX su TradingView, fatto a mano

**14 strategie col DAX/GER/DE/Xetra/Europe nel nome.** Le elenco tutte perché
il valore di questa riga è che sia completa:

| # | titolo | autore | like | `access` |
|---|---|---|---:|---|
| 1 | `DAX Shooter 5M Strategy` | th3web | 1.236 | 🟢 **1** |
| 2 | `Dax Up Down Scalp 15 Minutes` | peba1967 | 112 | 🔴 2 |
| 3 | `Petis Midterm Dax TP 10 Points` | peba1967 | 68 | 🔴 2 |
| 4 | `DAX, on 2-min chart` | UnknownUnicorn4427216 | 51 | 🔴 2 |
| 5 | `Petis Midterm Dax TP 20 Points` | peba1967 | 34 | 🔴 2 |
| 6 | `[pti] DAX 5M 7P TP Scalp` | peba1967 | 34 | 🔴 2 |
| 7 | `Daily Dax Strategy` | Speechless-Trading | 26 | 🔴 3 |
| 8 | `[pti]DAX 1H EMA BB` | peba1967 | 24 | 🔴 2 |
| 9 | `Iriza4 -DAX EMA+HULL+ADX TP40 SL20` | Radoje1984 | 17 | 🟢 **1** |
| 10 | `ASC - DAX Pulse Pyramid` | AndyDemi | 9 | 🔴 3 |
| 11 | `DAX40 Pulse Strategy V1` | AndyDemi | 7 | 🔴 3 |
| 12 | `Xetra DAX Opening Range PRO V3.0` | Steffen_Schubert | 8 | 🔴 3 |
| 13 | `sebbiottino Trailing Stop so good ger40 1m` | sebbiottinofx | 56 | 🟢 **1** |
| 14 | `Europe 07:00 ORB Mode B Expanded \| Crazy Horse` | Witschge | 17 | 🔴 2 |

👉 **11 su 14 protette. 3 leggibili, tutte e tre lette oggi, tutte e tre
scartate (§3.1).** E **le uniche due che nel titolo promettono l'apertura
europea — la #12 `Xetra DAX Opening Range PRO` e la #14 `Europe 07:00 ORB` —
sono protette E sono ORB**, cioè capitolo chiuso anche se le leggessi.

### 1.4 — MQL5: il Code Base non ha DAX, il Market sì (e non ci serve)

**Code Base, 12 pagine `mt5/experts` = 480 titoli** (stamattina ne erano stati
fatti 320 su 8 pagine; il 16/08, 1.200 su 30 pagine).

Filtro del mandato (`dax|ger40|german|frankfurt|us30|index|session|intraday|
eod|opening|premarket|gap|europe|london|day trad`): **13 titoli su 480**.
🔴 **Zero contengono DAX, GER, German, Frankfurt o Europe.**
Dei 13: **5 già noti e già scartati** (60347 Tuyul GAP, 68704 Price Action
Intraday, 71467 KSQ FVG, 75301 Nikkei Gap, 76153 Session ORB), 2 sono script di
test (48137/48139 `Indices Tester`/`Testing`), 1 è un'utility (22674). **3 mai
guardati**, aperti oggi → §3.3.

**Il Market (fuori perimetro, riportato solo per chiudere la domanda):** la
ricerca web restituisce `DAX Morning Scalp` (product/102586), `Ger40 Morning
Breakout` (131037), `DAX Robot MT5` (135313), `Neuron Net DAX40` (102648),
`Dax30 Ea Mt5 Hk` (66243), `Dax Retractor` (89316), `DAX Specialist Pro`
(110182). 🔴 **`/market/` = compilato, a pagamento, senza sorgente.** Non entra
né come candidato né come spunto: **senza sorgente il setaccio §4 non parte** —
non posso escludere un martingala che non posso leggere. Se un giorno servisse
davvero, la porta è una sola ed è `CANCELLO_ACQUISTI_EA.md`. **Non la propongo:
le descrizioni dichiarano "breakout scalping" all'apertura di Francoforte, cioè
la famiglia con ~210 celle rosse a tick reali alle spalle.**

### 1.5 — arXiv: 7 query, zero sull'apertura europea

| query | entry | utili |
|---|---:|---:|
| `all:"DAX" AND all:"intraday"` | 1 | 0 |
| `all:"DAX" AND all:"opening"` | 12 | **0** — collisione di nome: onde gravitazionali, OpenStreetMap, HunyuanVideo, e un paper di *visione artificiale* che si chiama _"Would you still call this Dax?"_ |
| `all:"opening auction" AND all:"European"` | **0** | 0 |
| `all:"opening auction" AND cat:q-fin*` | **0** | 0 |
| `all:"German stock market" AND all:"intraday"` | **0** | 0 |
| `all:"European equity" AND all:"intraday" AND cat:q-fin*` | **0** | 0 |
| `all:"first half hour" AND cat:q-fin*` | **0** | 0 |
| `cat:q-fin.TR AND all:"opening"` | 20 | 1 titolo pertinente ma **USA**: `Dynamical regularities of US equities opening and closing auctions` |
| `cat:q-fin.TR AND all:"overnight"` | 11 | 0 per noi |

🔴 **La letteratura accademica accessibile non ha niente sull'asta d'apertura
europea o sul DAX intraday.** Non è una lacuna della mia ricerca: sei query su
nove tornano **zero entry**. 👉 **Raccomandazione: non rifare queste query.**

### 1.6 — GitHub

4 ricerche. Due hanno risposto **429** (⚠️ **429 ≠ 404**: riprovate con backoff,
poi 200 — regola §2 applicata, il candidato non è stato cancellato).

| ricerca | risultati |
|---|---|
| `mql5 "opening range" expert` | **0 risultati** ("Your search did not match any repositories") |
| `DAX trading strategy backtest intraday` | **0 risultati** |
| `topics/dax` | 20 repo, **tutti Microsoft Power BI / kernel Linux** — collisione di nome totale |
| `DAX index trading` | **2 repo, 0 stelle ciascuno** → §3.4 |

---

## 2. 🟢 I PROMOSSI — **NESSUNO**

E lo scrivo come prima riga del capitolo invece di riempirlo con tre mediocri:
**oggi non c'è un candidato che io metterei nel tester.** Nessun file prova
allegato, perché non c'è un candidato numero uno.

**I tre motivi ricorrenti, in ordine di frequenza** (contati sui 15 sorgenti
letti oggi — e sono gli **stessi tre** che la caccia di stamattina aveva
misurato sui suoi 15 Pine, il che è di per sé un dato):

| motivo | quanti dei 15 |
|---|---:|
| 🔴 **nessuno stop reale** (assente, virtuale su chiusura di barra, o commentato) | **8** |
| 🔴 **nessuna chiusura di fine sessione** (= requisito C0 del mandato, eliminatorio) | **9** |
| 🔴 **lotto fisso / % di equity al posto del rischio %** | **13** |
| 🔴 **doppione di un motore già vivo o già misurato in casa** | **6** |

---

## 3. 🗑️ GLI SCARTATI — riga per riga, con la prova nel codice

### 3.1 I tre DAX/GER leggibili di TradingView — letti nel sorgente

| # | candidato | autore / licenza / righe | meccanica letta nel sorgente | 🔴 perché è scarto |
|---|---|---|---|---|
| 1 | **`DAX Shooter 5M Strategy`** [PUB;ENOEn0SBJXP7Y9QBT1kF85hBE1w8iZm4](https://www.tradingview.com/script/ENOEn0SBJXP7Y9QBT1kF85hBE1w8iZm4/) | th3web · creato **2019-09-09** · **1.236 like** · nessuna licenza dichiarata · Pine **v4**, **79 righe**, 6 input | mean-reversion: `crossover(rsi,30) and adx>32 and low<lowerBB` → LONG con `limit=upper`; specularmente short | 🔴 **NESSUNO STOP, NESSUNA USCITA.** Le uniche due `strategy.exit` del file sono **commentate** (righe **63** e **69**: `//strategy.exit("exit","COMPRA", loss = 90)`). La posizione si chiude **solo** col segnale opposto → **resta aperta overnight a tempo indeterminato**: viola C0 alla radice. Più: soglia `adx > 32` **hardcoded** mentre `th=20` è un input non usato nelle condizioni (cicatrice da ottimizzatore), e **niente di tutto ciò riguarda l'apertura**. ⚠️ 1.236 like: è **esattamente** la firma "curva bella perché non c'è lo stop" del §4 |
| 2 | **`Iriza4 - DAX EMA+HULL+ADX TP40 SL20`** [PUB;d85618d5599b43b892c5ff58bfab9a48](https://www.tradingview.com/script/d85618d5599b43b892c5ff58bfab9a48/) | Radoje1984 · creato **2025-10-27** · 17 like · Pine v6, **103 righe**, 9 input | `close>EMA20` **e** pendenza HULL21 **e** `ADX>20`, con filtro streak di candele e distanza max dall'EMA in ATR | 🔴 **Confluenza di indicatori senza tesi economica** — fuori mandato per definizione. Più: **`tpPoints=40` / `slPoints=20` in punti assoluti** (riga 81), non strutturali e non scalabili; `default_qty_type=percent_of_equity, value=1` = **non è rischio %**; **nessun filtro orario, nessun flat**; e ancora una volta **niente a che vedere con l'apertura** |
| 3 | **`sebbiottino Trailing Stop so good ger40 1m`** [PUB;4c5b4e90b84848b2829653daa66d6851](https://www.tradingview.com/script/4c5b4e90b84848b2829653daa66d6851/) | sebbiottinofx · creato **2026-05-21** · 56 like · Pine v6, **64 righe**, 3 input | canale ZLEMA ± `highest(ATR)×0.2`, filtro EMA15, ingresso al ritorno sulla ZLEMA in direzione del trend | 🔴 **Lo stop iniziale È la banda** (righe 47-53: `longStop := na(longStop) ? lower : max(longStop, lower)`) — cioè **uno stop strettissimo e mobile fin dal primo tick**, che è **la causa fotografata dei DD 44-68% di R109**. **Nessuna sessione, nessun flat, sempre a mercato** → overnight garantito. Nessun rischio %. Su **M1** |

### 3.2 Gli altri 10 sorgenti Pine letti oggi

| # | candidato | autore / creato / licenza | meccanica | 🔴 motivo |
|---|---|---|---|---|
| 4 | `[Pt] Premarket Breakout Strategy` [PUB;6e69ac69318b…](https://www.tradingview.com/script/6e69ac69318b485095fe5a5667c46afa/) | PtGambler · 2022-06-30 · **MPL 2.0** · 193 righe, 812 like | range pre-mercato **09:00-09:30**, la rottura fissa la **direzione**, poi ingresso su **incrocio dello Stoch-RSI** dall'ipervenduto; SL = bordo opposto del range − ATR giornaliero; RR 2,0; `close_all` a 15:55 **e** a 07:55 | 🟠 **Il meglio costruito di oggi, e resta scarto per DOPPIONE.** Stop reale (righe 177/182), flat di sessione (188-189), un trade al giorno, SL **strutturale**: la meccanica è sana. Ma è **la stessa famiglia** del promosso di stamattina (`Tristan's Box`) **e** dell'interruttore interno `InpRangeMode=1` **e**, sul DAX, della sedia viva `MaxMinNotte`. Difetti propri: sizing `initial_capital×margin/close` = **contratti, non rischio %**; `request.security(…,"1D",rma(tr,14))` **senza `lookahead`** → il valore del giorno **in formazione** muove la distanza di stop durante la seduta [INFERITO dalla riga 48; non è look-ahead, è uno stop che respira]. ✅ **Spunto tenuto: §5.2** |
| 5 | `AI MES London Open Breakout` [PUB;22d736951fd2…](https://www.tradingview.com/script/22d736951fd24843ad7066a5fc09b2da/) | lylerh · 2026-04-06 · 265 righe, 15 input | range **02:30-03:00 ET = 07:30-08:00 server BCM**, rottura in chiusura del range **OPPURE** rottura di un pivot(4); SL = `min(pivot−buffer, close−1,5·ATR)`; RR 1,5; `close_all` a fine sessione (06:00 ET = **11:00 server**) | 🔴 **Famiglia ORB** (range 30' + rottura in chiusura) → capitolo chiuso. Più i **due difetti che il §5B punisce a 0/5**: il grilletto è un **OR di due cose diverse** (`rangeBreakLong or breakHigh`, riga 140) = fabbrica di combinazioni; e i due filtri (`useHTFFilter`, `useVolFilter`) sono **opzionali e appiccicati**, non costitutivi. `default_qty=strategy.fixed 1` = lotto fisso. 🟡 **Ma l'idea di TEMPO è l'unica cosa nuova del giro: un indice USA giocato sull'apertura EUROPEA** → §5.4 |
| 6 | `Opening Reversal - Model B (2R Target)` [PUB;a07f1256dc36…](https://www.tradingview.com/script/a07f1256dc364e5396ef76e27fb3e1d8/) | alfredhastings_wk · 2026-05-14 · **MPL 2.0** · **442 righe**, ~13 input | sequenza a 4 stadi al livello chiave (PDH/PDL/PDC, **ONH/ONL**, apertura, H/L delle prime 6 barre): *failure* → *signal bar* → *follow-through* → *pullback*; `close_all` EOD | 🔴 **Macchina a PUNTEGGI = superficie di fitting enorme.** `i_minFailure` (1-6) e `i_minSignalBar` (1-5) sono **soglie su somme di 5 sotto-condizioni binarie** (righe 128-140): girare quelle due manopole ridisegna la strategia. **Nella sostanza è il fade dell'estremo d'apertura = R42, 0/24 IS e 0/24 OOS.** Più `strategy.fixed, 1` e `i_tickSize=0.25` **hardcoded su NQ**. 🔴 Anche la sua nozione di livello (ONH/ONL) è **ancora** il range pre-apertura |
| 7 | `Morning Breakout` [PUB;AxHlK54kCiv…](https://www.tradingview.com/script/AxHlK54kCivNhZRqg6D19ogXougvEo5O/) | hz29po · 2019-06-29 · 101 like · **20 righe** | `if hour(time)==9`: BUY STOP a `high+1` e SELL STOP a `low−1` della candela H1 delle 09:00; TP 40 / SL 25 in tick; `cancel_all + close_all` alle 21:30-22:00 | 🔴 **Famiglia ORB** — ed è **letteralmente lo straddle d'apertura DAX in 20 righe**. `qty=1` fisso, TP/SL in **tick assoluti** non strutturali, ora **hardcoded senza fuso** (`hour(time)` = ora di scambio del simbolo). 📌 **Va detto per onestà: è l'espressione più pulita di "apertura europea" trovata in tutta la caccia, ed è ESATTAMENTE il nostro capitolo chiuso.** Era già stato scartato al primo taglio il 25/08; oggi l'ho letto e **confermo lo scarto sul sorgente** |
| 8 | `ICT Opening Gap - Confirmed Close w/ Breakeven` [PUB;427efd9bd412…](https://www.tradingview.com/script/427efd9bd41240debce0ea182d591c72/) | Toddwaters72 · 2026-02-09 · 110 righe | box del gap `[close[1], open]` del nuovo giorno; conta le **traversate confermate in chiusura**; entra alla N-esima (default 3); uscita a orario o "chiusura oltre il lato opposto" | 🔴 **STOP VIRTUALE.** Prima del breakeven la `strategy.exit` **non ha `stop=`** (righe 95 e 97): l'unica protezione è `strategy.close_all` su **chiusura di barra** (righe 73-74, 100). Non è un ordine al broker. Più: `requiredCrosses` = manopola di fitting su un evento raro; TP/trail/BE in **tick**; nessun sizing. 🔴 E su un CFD 24/5 **il gap giornaliero è ~0**: il box sarebbe degenere — è la stessa incognita che `ABTG_SondaSessione.mq5` doveva risolvere e **non è ancora stata lanciata**. ✅ Spunto §5.3 |
| 9 | `BROSIO TRADES 8:00 15 Min Break and Retest` [PUB;0634ef8287cd…](https://www.tradingview.com/script/0634ef8287cd4c4683e0a72b9e1ddc6c/) | DDBrosio · 2026-04-19 · 128 righe. ⚠️ **il titolo inganna**: il nome interno è `MNQ Midpoint Retest (7x2R + 3xRunner 4R/BE) FINAL` | range **08:00-08:15 ET**; la rottura fissa lo **stato direzionale**; poi ingresso **al ritorno sul PUNTO MEDIO del range** (non sul bordo rotto) nella finestra 09:45-11:00; SL = bordo opposto; **70% a 2R + 30% runner a 4R con BE dopo TP1**; `close_all` a fine finestra | 🔴 **Scarto come candidato:** `calc_on_every_tick=true` (§4 esplicito) → i suoi riempimenti sono ottimisti per costruzione; `pyramiding=10` e `default_qty_value=10` **contratti fissi**; e i due orari (range alle 08:00, ingressi solo dalle 09:45) sono **due finestre arbitrarie separate da 90 minuti morti**. È inoltre **la stessa famiglia pre-apertura+retest** già promossa stamattina sul Dow. ✅ **MA CONTIENE L'UNICA MECCANICA DAVVERO NUOVA DELLA GIORNATA → §5.1** |
| 10 | `THE DOMMY SPLIT` [PUB;f55870d5c54b…](https://www.tradingview.com/script/f55870d5c54b4c3a87731f2a98eeffa0/) | DDBrosio · 2026-04-18 · 140 righe | **versione precedente dello stesso script** (#9), con in più: `if lossStreak >= 2 → lockedForDay := true` | 🔴 Stesso scarto del #9. ✅ **Spunto §5.5**: un **interruttore di giornata dopo 2 perdite consecutive**, dentro l'EA — noi ce l'abbiamo solo a livello di **portafoglio** (Guardian), mai per singolo motore |
| 11 | `FTSE Fridays` [PUB;JlnQ5VYN1kvQ…](https://www.tradingview.com/script/JlnQ5VYN1kvQuLkFUH9fR9nVVQgZPoMh/) | BacktestRookies · 2017-12-19 · 76 like · Pine **v3**, 67 righe | **long ogni venerdì** in pre-mercato 04:00-08:00 così da entrare all'apertura; `close_all` in finestra 12:00-16:00 | 🔴 **Lo stop è OPZIONALE e di default è `"None"`** (input `stp_inp`, riga 32) → niente stop. `default_qty_value=100` = **100% dell'equity**. **LONG ONLY** (viola C3, due lati sempre). ⚠️ `security()` in Pine v3 senza `lookahead` esplicito → **[INCERTO]** sul repaint, non l'ho risolto. 📌 È **stagionalità di giorno della settimana**, non un meccanismo d'apertura: fuori bersaglio |
| 12 | `CK INDEX Strategy Open-source code, Free, No Cost.` [PUB;319908b75854…](https://www.tradingview.com/script/319908b758544edb93db4ac706a2b773/) | musashibruno · 2025-12-26 · 40 like · **33 righe** | `CCI(14)>0 and CCI(50)>0 and PVT>SMA(PVT,50)` → long; specularmente short, **stop-and-reverse** | 🔴 **ZERO stop loss, ZERO uscite** oltre l'inversione; `default_qty_value=100` = **100% dell'equity**; nessuna sessione, nessun flat. Il nome promette "INDEX", il codice non sa cosa sia un indice |
| 13 | `Premarket Gap MomoTrader(SC)` [PUB;7b6b14f3d6e5…](https://www.tradingview.com/script/7b6b14f3d6e547b89f3fc38440abfef1/) | Abdul_Mughees · 2025-03-15 · 108 like · 75 righe | pre-mercato **04:00-09:30** su **azioni**: candela ≥ +5% con volume → long; uscita alla prima candela rossa | 🔴 **Nessuno stop**; uscita **virtuale** (`strategy.close`, riga 70); **sizing 25% / 50% / 100% dell'equity** a scaglioni sulla percentuale di corpo della candela (righe 36-40) — cioè la dimensione della posizione dipende dalla forma di una candela. **LONG ONLY.** Strumento sbagliato (azioni singole) |

### 3.3 MQL5 Code Base — i 3 mai guardati, aperti oggi

| id | titolo / autore / data / DL | esito |
|---|---|---|
| [23223](https://www.mql5.com/en/code/23223) | `Gap DM` · barabashkakvn (orig. Хлыстов Владимир) · 2019.01.02 · **DL 2.742** · 605 righe | 🔴 **SCARTO — e confermo indipendentemente lo scarto già scritto il 16/08.** Sorgente scaricato e convertito da UTF-16 e letto: `input ushort InpStopLoss = 0;` (riga 33) e alla riga 382 `double sl=(InpStopLoss==0)?0.0:…` → **`OrderSend` con `sl=0.0` di default**, §4 alla lettera. Più `InpMaxPositions = 15` (riga 38, controllato a riga 177) = **accumulo fino a 15 posizioni**. Nessuna sessione, nessun flat. Meccanismo = gap `close[1]−open[0] ≥ 1 pip` su **qualunque** barra: su CFD 24/5 è il gap del weekend, che `ABTG_GapFill` copre già (e che in forward fa **zero trade su 5 magic**) |
| [23201](https://www.mql5.com/en/code/23201) | `Day Trading PAMXA` · barabashkakvn · 2019.01.02 · **DL 5.071** | 🔴 **SCARTO al primo taglio, sorgente NON aperto e lo dichiaro.** Descrizione sulla pagina: _"based on two indicators calculated on two timeframes: iAO on the D1 TF and iStochastic on H1"_ → **confluenza multi-timeframe senza tesi economica** (fuori mandato per istruzione esplicita) e **D1/H1 non è un meccanismo d'apertura** |
| [48137](https://www.mql5.com/en/code/48137) | `Indices Tester` · deinschanz · 2025.12.15 · DL 1.181 | 🔴 **SCARTO al primo taglio.** La descrizione della pagina lo dice da sola: _"The EA only trades buy positions and **does not use SL and TP**"_ → niente stop (§4) **e** un lato solo (viola C3). Non ho aperto il sorgente: non serviva |

### 3.4 GitHub — i 2 repo esistenti, entrambi aperti

| repo | cosa c'è | 🔴 esito |
|---|---|---|
| [`rodemkay/dax-overnight-trading`](https://github.com/rodemkay/dax-overnight-trading) · **0 stelle** · Python + `src/EA/the_don.mq5` | _"automated trading system for DAX index **overnight** trading using MetaTrader 5"_, finestra **22:00-08:45**, `Stop Loss: 50 points`, `Take Profit: 500 points`, `Lot Size: 0.10` | 🔴 **TRIPLO scarto.** (a) **overnight per costruzione** = viola il requisito non negoziabile del mandato; (b) **lotto fisso 0,10** + SL/TP in punti assoluti con **RR 1:10** = la firma "tanti piccoli vinti, una perdita enorme"; (c) **licenza PROPRIETARIA** (_"Proprietary software - All rights reserved"_) con **verifica di licenza su server remoto** (`lic.prophelper.org`) = §4, "DLL / WebRequest / licenze / account check". **Non si legge, non si usa, non si compra** |
| [`RodolfoGiuliana/dax-systematic-strategy-framework`](https://github.com/RodolfoGiuliana/dax-systematic-strategy-framework) · **0 stelle** · Python · 22 commit | Monte Carlo, attribuzione per regime, quantificazione delle code e del drawdown. Dichiarato esplicitamente: _"post-trade analytics **rather than signal generation**"_ | 🔴 **Non è una strategia**: nessuna regola di ingresso/uscita/stop. 📌 E per inciso: **fa esattamente le cose che facciamo già in casa** (Monte Carlo p95/p99, celle di regime). Nessun valore da importare |

### 3.5 Il mirror dei 1.185 sorgenti — i 6 nomi promettenti, aperti

Dopo il `grep` a zero (§ riga di apertura), ho aperto comunque i sei file il cui
**nome** suggeriva un meccanismo orario/d'apertura, per non fidarmi solo del grep:

| file | cosa fa davvero | 🔴 esito |
|---|---|---|
| **`breakdownlevelday.mq5`** (Hlystov Vladimir, 2011, ed. barabashkakvn) | `input string TimeSet = "07:32"` = **ora in cui piazzare gli ordini**; a quell'ora mette **BUY STOP a `iHigh(D1,0)+delta`** e **SELL STOP a `iLow(D1,0)−delta`** (righe 172/183/192/203) — cioè lo **straddle sull'estremo accumulato dalla mezzanotte fino alle 07:32** | 🟠 **DOPPIONE INTERNO ESATTO, e inferiore.** È `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` scritto peggio: box grezzo (mezzanotte→ora X invece del box 23:00-04:59 configurabile), **nessun cutoff d'ingresso** (noi abbiamo `InpEntryCutoffHour=8:30`, "solo la rottura fresca"), **nessun flat di fine giornata**, `InpSL=120` punti **fissi**, `risk=0` di default = **lotto fisso 0,10**, e `OpenStop=true` **piazza gli stop anche a posizione già aperta** = accumulo. 💡 **Il valore per noi è di conferma, non di codice: l'idea è standard da 15 anni, e la nostra implementazione è la migliore delle due** |
| `daily_breakpoint.mq5` | rottura del livello giornaliero con filtri di dimensione della candela | 🔴 `input ushort InpStopLoss = 0;` (riga 22) → **nessuno stop di default**. `Risk = 5` (%) ma `InpLotManual=true` di default = **lotto fisso**. Nessun flat |
| `e-skoch-open.mq5` | "salto" all'apertura (Хлыстов, 2010) | 🔴 `InpLot = 0.01` **fisso**, SL/TP in pip fissi (130/200), **nessuna sessione, nessun flat**, `MaxBuyCount`/`MaxSellCount` accettano **−1 = illimitato** |
| `breakout15.mq5` | incrocio di due medie su M15 | 🔴 Non è un meccanismo d'apertura: è un incrocio di medie. SL/TP/trailing in **pip fissi** |
| `21hour.mq5` | due finestre orarie dentro la giornata | 🔴 `Lots = 0.1` **fisso** + `InpStep` = **passo di griglia**. Le "finestre orarie" sono un filtro, non un motore |
| `ea_high_and_low_last_24_hours.mq5` | 🔴 **non è una strategia**: `#property description "Example: gets the history data of highest and lowest bar prices in the last 24 hours"` — è un **esempio didattico** senza logica di trading | — |

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perché |
|---|---|
| **Gli 11 script DAX/GER/Xetra/Europe con `access=2` o `3`** (§1.3) | sorgente protetto → `pine-facade` risponde **401**. Fra questi **`Xetra DAX Opening Range PRO V3.0`** (Steffen_Schubert) e **`Europe 07:00 ORB Mode B Expanded`** (Witschge), che sono **i due titoli più mirati sul bersaglio di questa caccia**. **Non li ho letti, non li giudico** — anche se entrambi dichiarano ORB nel titolo, cioè la famiglia chiusa |
| **`Wunder False Breakout`** (WunderTrading, 143 like) | `access=2`. Era l'unico "false breakout" con un po' di seguito |
| **Il MQL5 Market** (7 EA DAX identificati, §1.4) | **fuori perimetro per regola**: compilato, a pagamento, senza sorgente. Non è "non ho potuto": è "non si fa senza passare da `CANCELLO_ACQUISTI_EA.md`", e **non lo propongo** |
| **SSRN e Forex Factory** | **non tentate oggi.** 403 in otto cacce di fila; ho preferito spendere le richieste sul mirror. Resta il buco noto: Forex Factory è l'unico posto dove si legge *come invecchia* una strategia |
| **Il repaint di `FTSE Fridays`** | `security()` in Pine v3 senza `lookahead` esplicito → **[INCERTO]**, non risolto. Irrilevante ai fini dello scarto (che è deciso da "nessuno stop di default" + "100% equity") |
| **Lo spread reale BCM su D30EUR in fascia 08:00-09:00** | **[NON MISURATO]**, come stamattina. Il *RealCost Spread P95 Logger* (Code Base 74148) è promosso dal 23/08 e **ancora mai usato**. Senza quello, il criterio costo C1 su un motore DAX d'apertura non si può chiudere |

---

## 5. 💡 GLI SPUNTI — cinque, e il primo vale un asse di griglia

Non sono candidati. Sono **pezzi di meccanica letti nel sorgente** che costano
poco e che oggi non sappiamo esprimere.

### 5.1 🎯 IL RETEST SUL **PUNTO MEDIO** DEL RANGE, NON SUL BORDO ROTTO
_(da `MNQ Midpoint Retest`, DDBrosio — righe 45-53 e 78-83 del Pine)_

Il ritorno che aspettano **non è al livello rotto**: è a
**`mid = (rangeHigh + rangeLow) / 2`**, con lo stop al **bordo opposto**.
È un pullback molto più profondo: meno riempimenti, ma R:R strutturalmente
migliore perché la distanza ingresso-stop si dimezza.

🔴 **E il nostro EA oggi NON sa dirlo.** [VERIFICATO nel sorgente
`ABTG_DAX_Apertura_EU.mq5`]: `InpRetestOffsetPts` (riga 270, default **200
punti = 2 punti indice**) entra alla riga **1481** come
`gRangeHigh - InpRetestOffsetPts*_Point` — cioè uno **scostamento FISSO in
punti dal livello**, con il commento del 06/08 che dice cosa fa: _"il LIMIT sta
2 punti indice DENTRO il livello… Costa il 3,9% dei riempimenti"_.
**Un offset pari a metà dell'ampiezza del range — che cambia ogni giorno — non
è esprimibile con quell'input.**

> ✅ **Raccomandazione concreta, e costa un asse:** quando la sessione principale
> gira il round `InpRangeMode=1` su DAX e Nasdaq (i file prova del Dow esistono
> già: `PREOPEN_RETEST_DOW_M15.txt`), **`InpRetestOffsetPts` non va pinnato a
> 200: va spazzolato**, perché è l'unico modo che abbiamo oggi di avvicinarci
> alla domanda "il ritorno paga di più al bordo o a metà range?". ⚠️ Resta una
> **approssimazione dichiarata**: fisso in punti ≠ frazione del range. La
> versione vera richiederebbe un `InpRetestFrac` nuovo — **poche righe, ma è
> codice, e oggi non tocco codice.**

### 5.2 La direzione dalla rottura, l'ingresso da un **pullback di oscillatore**
_(da `[Pt] Premarket Breakout`, righe 111-135)_

Terzo idioma d'ingresso, che non abbiamo: la rottura **non è un ordine**, è solo
uno **stato direzionale** che dura tutta la giornata; l'ordine arriva quando
lo Stoch-RSI incrocia dall'estremo **nella direzione già stabilita**.
Differenza sostanziale dal nostro `ABTG_RETEST`: **non pretende che il prezzo
torni a un prezzo preciso**, quindi non perde le giornate che scappano.
📌 Costo: è un ramo di codice nuovo. **Non lo propongo oggi**, lo lascio scritto.

### 5.3 La **N-esima traversata confermata** di una zona
_(da `ICT Opening Gap — Confirmed Close`, righe 44-54)_

Non "rompi la zona" né "svanisci la zona": **conta quante volte il prezzo l'ha
attraversata in chiusura, ed entra sulla N-esima**. La tesi scrivibile sarebbe:
_"ogni traversata consuma la liquidità che difende il livello; dopo N passaggi
non ne resta abbastanza per respingere il prezzo"_.
⚠️ **Non lo raccomando come round**: `requiredCrosses` è una manopola su un
evento raro, ed è precisamente la forma di curve-fitting contro cui esiste la
regola della seconda caccia. **Lo annoto come vocabolario, non come piano.**

### 5.4 🕐 Un indice **USA** giocato sull'apertura **EUROPEA**
_(da `AI MES London Open Breakout`: range 07:30-08:00 server, sessione fino alle 11:00 server)_

L'unica idea di **tempo** nuova della giornata. Il Dow/Nasdaq alle 08:00 server
è un mercato senza il suo flusso domestico: si muove **per riflesso** di quello
che fa l'Europa.
🔴 **Ma in ottica prop va detto subito che è probabilmente una TRAPPOLA di
correlazione**, non un buco: `ROTTA_PROP` regola 1 vieta due EA sullo stesso
segnale/simbolo/lato — e qui il simbolo è diverso ma **l'ora e il driver sono
gli stessi della sedia viva `DAX Apertura EU`**, su indici che nella stessa
mezz'ora si muovono insieme. **Il DD della prop è UNO.** Se qualcuno lo
provasse, la sovrapposizione delle **giornate** va misurata prima, non dopo.

### 5.5 🏛️ Un **interruttore di giornata** dentro l'EA, dopo 2 perdite di fila
_(da `THE DOMMY SPLIT`: `if lossStreak >= 2 → lockedForDay := true`)_

Noi abbiamo il freno **solo a livello di portafoglio** (Guardian: pausa 4,0 /
emergenza 4,9 e 9,9). **Nessun nostro EA si spegne da solo dopo due stop nella
stessa giornata.** È esattamente il meccanismo che protegge dal muro che butta
fuori più spesso — **il DD GIORNALIERO del 5%, cioè −5.000 su 100k**: a 0,65%
per trade, due stop pieni sono ~1,3%, ma su un motore che spara più cicli al
giorno la coda si allunga in fretta. 📌 **Lo segnalo come idea di GESTIONE per
la flotta, non come candidato**, e non è compito di questa caccia deciderlo.

---

## 6. ❓ LA DOMANDA CHE QUESTA CACCIA LASCIA — e a chi tocca

Non c'è un file prova, perché non c'è un promosso. La domanda che resta è
quella che il round già in preparazione può assorbire senza costi:

> **"Quando accendiamo finalmente `InpRangeMode=1` sul DAX — l'interruttore che
> in 23 file prova su 23 è sempre stato pinnato a 0 — il ritorno sul livello
> conviene farlo aspettare al BORDO rotto (come fanno tutte le nostre celle
> vive, `InpRetestOffsetPts=200`) o PIÙ DENTRO, verso il centro del range?"**
>
> È l'unica domanda che oggi ho raccolto **fuori** e che **dentro** non
> sappiamo ancora rispondere, e costa **un asse di griglia**, non un EA nuovo.
>
> ⚠️ **E porta con sé un vincolo di scorrelazione che va scritto nel file prova
> PRIMA dei numeri:** sul DAX quel motore vive nella stessa ora e sullo stesso
> livello della sedia viva `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (box
> 23:00-04:59, ordini alle 07:59, cutoff 08:30). **Se le celle promosse
> scattassero negli stessi giorni della sedia viva, il verdetto è SCARTO PER
> CORRELAZIONE anche se i numeri sono buoni** — perché il drawdown della prop è
> uno solo.

---

## 7. 🧭 RACCOMANDAZIONI DI ECONOMIA DELLA CACCIA (per chi viene dopo)

1. 🛑 **Non rifare le query arXiv sull'apertura europea.** Sei su nove tornano
   **zero entry**; `DAX` come parola chiave collide con la fisica e con Power BI.
2. 🛑 **Non ricrawlare il Code Base per gli indici — quinta misura consecutiva.**
   480 titoli su 12 pagine oggi, **13 match, 10 già noti, 3 nuovi tutti
   scartati, ZERO col DAX nel nome**. Il 16/08 su 1.200 titoli il risultato era
   lo stesso.
3. 🛑 **Non cercare il DAX nel mirror dei 1.185 `.mq5`:** la parola non c'è, e
   nemmeno `opening range`, `premarket`, o un input di chiusura giornaliera.
   **Ora è misurato e non va rimisurato.**
4. ⚠️ **`mql5.com/en/code/...?keyword=X` risponde 200 e IGNORA il filtro.** Chi
   lo usa crede di aver cercato e ha solo riletto l'elenco. Da mettere in
   `PROMEMORIA_SBLOCCO_FONTI.md`.
5. ✅ **Su TradingView usare la ricerca testuale con TANTE query corte** (§1.2):
   31 su 65 rendono zero, ma le 34 che rendono danno hash + autore + like +
   `access` in una sola richiesta. E **guardare `access` PRIMA di scaricare**:
   su questo bersaglio l'**79%** delle strategie DAX è protetto.
6. 💡 **Se un giorno si vorrà davvero un motore DAX d'apertura diverso dal
   nostro, il materiale gratuito non ce l'ha.** Le uniche due strade residue
   sono: (a) gli 11 sorgenti protetti di TradingView — irraggiungibili;
   (b) il MQL5 Market — a pagamento, senza sorgente, e dichiaratamente
   "breakout". **Entrambe peggiori dell'interruttore che abbiamo già in casa e
   non abbiamo mai acceso.**

---

_Dossier compilato il 28/08/2026 dall'agente `cacciatore-strategie` — seconda
battuta della giornata, sul buco geografico lasciato da
`CACCIA_INTRADAY_INDICI_2026-08-28.md`._

_Fonti aperte davvero: **TradingView** (66 interrogazioni, ~61 strategie uniche
con hash e autore, **13 sorgenti Pine scaricati e letti**), **MQL5 Code Base**
(12 pagine = 480 titoli, 3 schede nuove aperte, **1 sorgente `.mq5` scaricato,
convertito da UTF-16 e letto**), **arXiv API** (7 query), **GitHub via
`WebFetch`** (4 ricerche, 2 repo aperti), **mirror `GeneralTradingSarl/expert-mt5`**
(**1.185 `.mq5` clonati, convertiti e passati al `grep`; 6 aperti a mano**)._

_Fonti NON tentate oggi e dichiarate tali: **SSRN**, **Forex Factory**._

_**Promossi: ZERO. Nessun numero di performance dichiarato da un autore compare
in questo dossier.**_

_Attribuzione (regola di casa — da ripetere in testa a qualunque file derivato,
anche se oggi non ne nasce nessuno):_
- _`[Pt] Premarket Breakout Strategy` è di **PtGambler**, **MPL 2.0** (TradingView, 30/06/2022)_
- _`Opening Reversal - Model B (2R Target)` è di **alfredhastings_wk**, **MPL 2.0** (TradingView, 14/05/2026)_
- _`MNQ Midpoint Retest` (pubblicato come `BROSIO TRADES 8:00 15 Min Break and Retest` e `THE DOMMY SPLIT`) è di **DDBrosio** (TradingView, 18-19/04/2026) — **licenza non dichiarata nel sorgente**_
- _`AI MES London Open Breakout` è di **lylerh** (TradingView, 06/04/2026) — **licenza non dichiarata nel sorgente**_
- _`BreakdownLevelDay` è di **Hlystov Vladimir** (2011), edizione MT5 di **barabashkakvn**_
- _`Gap DM` è di **Хлыстов Владимир / barabashkakvn**, MQL5 Code Base id 23223 (02/01/2019)_
