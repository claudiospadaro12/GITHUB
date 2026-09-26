# 🏹 CACCIA AI MECCANISMI — SEI FAMIGLIE FERME (26/09/2026)

_Cacciatore di strategie · **SOLA LETTURA**: zero EA scritti o toccati, zero preset, zero file
prova, zero round lanciati, zero terminali, niente sul conto reale `10105439`. L'unica misura
fatta e' una **sonda sui DATI** (larghezza del box asiatico su Oanda M1, §4.1): non e' un
backtest e non e' BCM._

**Mandato** (Claudio, 26/09): _"DOBBIAMO AVERE QUESTE SEDIE!! ASSOLUTAMENTE. NON FERMIAMOCI
DAVANTI A QUALCHE PARAMETRO BASSO. SI CERCA SUL WEB SE QUALCHE PARAMETRO C'E' DA MIGLIORARE."_
Applicato con la **Regola della seconda caccia** (19/08): si cercano **MECCANISMI alternativi
sulla stessa inefficienza**, mai parametri diversi di un motore gia' dichiarato senza edge. I
criteri di casa **non si abbassano** (PF >= 1,10 IS e OOS, n >= 150 posizioni, DD alla taglia
dentro il muro del 10%, stop >= 40 x (spread + commissione)).

**Etichette**: **[VERIFICATO]** letto sulla pagina/sorgente · **[INFERITO]** dedotto, dico da
cosa · **[INCERTO]** · **[DICHIARATO]** numero dell'autore, **mai** un criterio ·
**[LETTO-VIA-SEARCH]** visto solo nel riassunto del motore di ricerca perche' la pagina e'
murata dal proxy · **[STIMA]**.

---

## 0. 🎯 LA RIGA CHE CONTA

> ## Su **~420 candidati guardati su 6 fonti vive** (119 titoli Code Base, ~150 strategie TradingView su 47 interrogazioni, ~200 titoli arXiv su 17 ricerche + 3 elenchi mensili, 1 articolo MQL5, 6 ricerche web), **22 arrivano al sorgente o al testo**, **4 li proverei** — e il primo e' il **box asiatico intero su GBPUSD/EURUSD con `ABTG_MaxMinNotte`**, perche' e' l'unico che si prova **stanotte a codice zero** e perche' in casa **non e' mai stato misurato davvero**: l'unica corsa forex d'archivio (EURUSD) aveva il **buffer del DAX (1000 punti = 100 pip)** e ha fatto **1 operazione in IS e 0 in OOS**.

E la seconda riga, che vale quanto la prima:

> 🥇 **Il miglior sorgente trovato oggi e' nuovo di due giorni**: `Gold Breakout EA for XAUUSD H4`
> (Code Base **77691**, 24/09/2026) — **Donchian 20 H4 + filtro EMA200, solo long, stop 2 ATR,
> target 2R**, 428 righe pulite, rischio in %, nessuna bandiera del §4. E' **esattamente** il
> meccanismo che il mandato elenca per la famiglia F (_"breakout di Donchian su H4 con filtro
> EMA200"_), sull'oro, e copre anche il **lato long dell'oro** della famiglia A.

🔴 **E la verita' scomoda, detta subito**: per **B (DAX long)**, **C (Dow short)** ed **E (fade
notturno)** il web di oggi **non porta nessun meccanismo che la casa non abbia gia' scritto o
misurato**. Non torno con candidati mediocri per riempire la tabella: per ognuno dei meccanismi
suggeriti dal mandato scrivo **la lapide col numero** o **la casella di casa gia' in coda** (§6).
**Nessuno dei quattro promossi puo' diventare una sedia firmabile per il 1° ottobre**: il migliore
dei casi e' un verdetto di screening entro la settimana.

---

## 1. 🧭 IL BERSAGLIO, letto PRIMA di uscire

Letti: `report/ROBUSTEZZA.md`, `report/ROTTA_PROP.md`, `backtest_pipeline/REGISTRO_TEST.md`
(titoli + le sezioni del 25-26/09), `caccia_strategie/SETACCIO_MANUALE.md`,
`caccia_strategie/biblioteca/CATALOGO.md` (117 sorgenti gia' in biblioteca),
`report/STATO_MAXMIN_DAX_LONG_E_ORO_2026-09-26.md`, `report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md`,
`caccia_strategie/ANALISI_PDF_LONDRA_2026-09-26.md`, `CACCIA_LONDRA_MECCANISMI_2026-08-19.md`,
`CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md`, `CACCIA_NOTTE_2026-09-12.md`,
`report/CACCIA_MECCANISMI_2026-09-23.md`, `report/SEDIA_SHORT_DOW_FTMO_2026-09-26.md`, e
l'elenco dei file prova in coda (`R255`, `R258`, `R259`, `R260`, `R261`, `R264`, `R265`).

| famiglia | stato di casa (numero) | cosa e' gia' in coda |
|---|---|---|
| **A** box notturno ORO, long | `770402` due lati **PF 1,308 · n 693 deal · DD 5,32% @0,5%** (R103, OHLC); bocciata per rischio alla taglia 2% (~19,6-21,3% `[DERIVATO]`) | `R260a/b/c` (solo long / solo short / ancora) |
| **B** box notturno DAX, long | **0/33 celle distinte >= PF 1,00** a tick (max 0,947) | `R261a-d` (filtro S&P a specchio, TF di gestione) |
| **C** apertura USA, short Dow | `R54a` **OOS PF 0,840 su 73** | `R255a-x` (22 file: uscite e TF di stop dello short Dow) |
| **D** Londra forex | `R45` **0/48**; `Londra_ORB` mai con un CSV | `R258a-x` (canale 06-07 del PDF) |
| **E** notte asiatica, fade | Nightly morto su 3 forex | `R259` (sei simboli) |
| **F** trend H4 + EMA200 | `771531` viva sul Dow; forex/oro **finestra unica** (oro H4 PF 1,381 su 187 deal) | `R264a-d`, `R265` (EMA200 su GBPUSD/AUDJPY/GBPJPY/XAUUSD/EURUSD) |

---

## 2. ✅ CONTROLLO POSITIVO — fonte per fonte, misurato oggi 26/09/2026

| fonte | bersaglio noto | esito | uso |
|---|---|---|---|
| **MQL5 Code Base** elenco | `/en/code/mt5/experts` + `/page2`, `/page3` | 🟢 **200**, 88.733 / 83.604 / 86.775 byte, **39+40+40 ID con titolo**; fra questi ID gia' nel nostro setaccio (77535 RegimeRouter, 77220 ZetaBurst, 77060 SessionReopenEA) = il canale risponde sul noto | ✅ 3 pagine |
| **MQL5** scheda + sorgente | `/en/code/77691`, `/77639` + `/en/code/download/<ID>/<file>.mq5` | 🟢 **200**, sorgenti ASCII 428 e 518 righe | ✅ 2 sorgenti letti, 3 schede |
| **MQL5 Articoli** | `/en/articles/17239` | 🟢 **200**, 156.898 byte, codice nel corpo | ✅ 1 |
| **TradingView** ricerca | `pubscripts-suggest-json/?search=asian range` | 🟢 **200**, 18.938 byte, JSON con `scriptIdPart`/`access`/`agreeCount` | ✅ 47 interrogazioni |
| **TradingView** sorgente | `pine-facade/get/PUB;<id>/last` | 🟢 **200**, `scriptAccess: open_no_auth`, `source` in chiaro | ✅ 16 sorgenti scaricati, 14 letti |
| **arXiv** | `arxiv.org/list/q-fin.TR/recent` (ID 2609.29108…) · `/search/` · `/abs/` · `/list/q-fin.TR/2026-0{7,8,9}` | 🟢 **200**; ricerca "intraday momentum" restituisce **2605.04004**, che e' gia' in casa = controllo passato | ✅ 17 ricerche, 99 titoli mensili, 4 abstract |
| 🔴 **arXiv API** | `export.arxiv.org/api/query` | 🔴 **HTTP 406** (anche con `Accept: application/atom+xml`) — **nuovo** rispetto al 05/09 | ❌ sostituita dalla pagina `/search/` |
| **raw.githubusercontent** | `geraked/metatrader5/README.md` | 🟢 **200, 6.941 byte** (identico alle cacce precedenti) | ✅ dati Oanda M1 (FutureSharks, GPL-3.0) |
| 🔴 **GitHub** API / ricerca | `api.github.com/search/...` · `github.com/search` | 🔴 **403** / **403** | ❌ **NULLA** |
| 🔴 **SSRN** | `abstract_id=3138756` | 🔴 **403** (pagina "Content Blocked") | ❌ **NULLA** |
| 🔴 **Forex Factory** | `/forum/71-trading-systems` | 🔴 **403** | ❌ **NULLA** |
| 🟠 **Quantpedia** | `/strategies/` | 🟢 **200** (Screener, 613 KB) **ma** l'articolo GDX: **504**, poi **466** a 5 / 15 / 30 s | ❌ **NULLA oggi** — e' un "non adesso", non un 404 |
| 🔴 **NY Fed / Liberty Street / fedinprint / CBS / gold.org / substack / fxvps / mdpi / quantifiedstrategies** | pagine trovate dalla ricerca | 🔴 **EGRESS_BLOCKED** (WebFetch) e **000** (curl) | ❌ solo **[LETTO-VIA-SEARCH]** |

---

## 3. 📚 COSA HO SFOGLIATO

- **Code Base**: 3 pagine = 119 titoli; ho filtrato anche i ~1.395 titoli gia' scaricati nelle
  pagine 9-40 dalla sessione del 23/09 (cartella di lavoro): **gli unici motori nuovi dal 23/09
  sono 77691 e 77639**, il resto sono pannelli e guardiani (conferma la diagnosi del 23/09: _"il
  giacimento del Code Base si sta esaurendo"_).
- **TradingView**: 47 interrogazioni sul MECCANISMO (14 a zero strategie) (`asian range breakout`, `gold asian`,
  `xauusd breakout`, `gold session`, `US30`, `dow jones`, `premarket high`, `gap down`,
  `first candle`, `opening drive`, `short only`, `night`, `asian session`, `scalper asia`,
  `mean reversion session`, `bollinger reversion`, `london breakout`, `asia range`, `gbpusd`,
  `DAX`, `GER40`, `DE40`, `xetra`, `fdax`, `ema 200 pullback`, `trend pullback`, `donchian`,
  `turtle`, `gold trend`, `break and retest`, `retest`, `session retest`, `range retest`, `YM`).
  **A zero strategie, da non riprovare**: `night scalper`, `asian session mean reversion`,
  `asia fade`, `overnight mean reversion`, `asian scalping`, `rollover`, `fade the open`,
  `opening range fade`, `sell the open`, `gap and go`, `prior day low`, `xetra`, `fdax`, `DE40`.
- **arXiv**: `q-fin` e' **povero sulle sessioni FX e sull'oro intraday** (17 ricerche, 0 paper in
  tema oltre ai due di Mesfin gia' noti). I 99 titoli di `q-fin.TR` luglio-settembre 2026: 1 in
  tema (2607.01550, avvertenza per la famiglia F).
- **Web generico**: 6 ricerche; le pagine utili (NY Fed, WGC, substack) sono **murate**.

---

## 4. 🥇 I PROMOSSI — quattro, in ordine di vicinanza a una sedia

### P1 · 🌏 IL BOX ASIATICO INTERO SU GBPUSD / EURUSD (famiglia D) — `ABTG_MaxMinNotte`, codice zero

```
NOME            (motore di casa) ABTG_MaxMinNotte v1.11 — geometria forex del box asiatico
FONTI ESTERNE   1) TradingView "Asian Breakout - AutoBot & Visuals" — bhanubisen1, 369 like,
                   PUB;ffcf1f5967e94ce1a91aabcf9d1284aa, creato 19/04/2026, 108 righe [VERIFICATO]
                2) MQL5 Articolo 17239 "Automating Trading Strategies in MQL5 (Part 9):
                   Asian Breakout Strategy" — Allan Munene Mutiiria, 25/02/2025 [VERIFICATO]
LICENZA         1) nessuna dichiarata nel sorgente [INCERTO]; 2) "All rights ... MetaQuotes Ltd."
                -> nessuno dei due viene portato: sono SPECIFICHE, il motore e' gia' nostro
RIGHE / INPUT   MaxMinNotte: 918 righe, ~45 input di cui ~8 vere manopole (box, piazza, cutoff,
                buffer, SLMode, TP)
```
**TESI IN UNA RIGA** — _"guadagna perche' la liquidita' si accumula in un range durante le ore
asiatiche e l'apertura europea la rompe con un flusso direzionale che prosegue nella mattinata"_ —
la stessa tesi che in casa **vive sull'oro** (`770402`, PF 1,308 su 693) e che R45 aveva scritto
cosi': _"il box notturno paga sul RANGE DELLA NOTTE (ore di accumulo), non sul quarto d'ora
dell'apertura europea"_.

**MECCANICA** (le due fonti concordano riga per riga) [VERIFICATO]
- **box** = massimo e minimo delle ore asiatiche (AutoBot: `0000-0800 UTC`; art. 17239:
  `23:00-03:00 GMT`);
- **ingresso** = rottura del massimo/minimo (AutoBot: **chiusura** oltre il livello; art. 17239:
  **pendenti** a ±10 pip — cioe' la geometria di `MaxMinNotte`);
- **stop** = **l'estremo opposto del box** (AutoBot `stop=a_low`; art. 17239 idem) · **target**
  AutoBot = 2 x ampiezza del box, art. 17239 = 1,3 R · **flat** a fine giornata (AutoBot fine
  sessione USA, art. 17239 alle 13:00 GMT).

**GESTIONE RISCHIO delle fonti** — AutoBot `default_qty_type=strategy.fixed, 1` e art. 17239
`LotSize = 0.1`: **lotto fisso in entrambe** (bandiera §4 **sulla gestione**, non sul motore:
si usa `MaxMinNotte`, che e' a rischio %). Stop vero in entrambe.

**BANDIERE ROSSE sul MOTORE**: nessuna. Il filtro SMA50 dell'art. 17239 e' un cerotto: **non si
porta** (0 successi su 5 dei filtri aggiunti).

**NUMERI DICHIARATI**: AutoBot **nessuno** nel sorgente; art. 17239 **solo immagini** (un anno,
2023, simbolo non scritto nel testo) → `[NON LETTO]`. **Nessun numero pesa.**

**🔎 IL FATTO DI CASA CHE LO RENDE IL PRIMO** [VERIFICATO sui CSV]
`backtest_pipeline/risultati_prove/ABTG_MaxMinNotte/ABTG_MaxMinNotte_EURUSD_{IS,OOS}_ohlc.csv`:
`InpBufferPoints=1000` (su EURUSD a 5 cifre = **100 pip**: il buffer tarato per il DAX),
`InpSLMode=1` → **Trades 1 in IS, 0 in OOS**. Su **GBPUSD `MaxMinNotte` non e' mai girato**
(censimento `REGISTRO_TEST.md` r.3843-3850: D30EUR 24 CSV, XAUUSD 14, EURUSD 2, GBPUSD **0**).
👉 Per il certificato del 09/09 il box asiatico sul forex e' **NON ANCORA MISURATO**, non morto.

#### 4.1 🧮 LA SONDA DI COSTO — il numero che decide se il canale largo paga (fatta oggi)
Dati **Oanda M1** (FutureSharks/financial-data, GPL-3.0, **UTC**), box **23:00-05:59 UTC** =
**00:00-06:59 server BCM con l'orologio di oggi (UTC+1 fisso)**, solo feriali con >= 300 barre.
Soglia di lavoro **40 x (spread 0,3 + commissione ~0,53) = 33,2 pip** e pavimento duro
**13,3 x = 11,0 pip** (costi da `ANALISI_PDF_LONDRA_2026-09-26.md` §0.3). Con lo stop
all'estremo opposto, stop ≈ ampiezza del box W.

| simbolo | anno | giorni | W mediana | P25 | P75 | quota W >= 33,2 (40x) | quota W >= 11,0 (13,3x) |
|---|---|---:|---:|---:|---:|---:|---:|
| GBPUSD | 2012 | 193 | 26,8 | 21,7 | 36,2 | **33%** | 100% |
| GBPUSD | 2015 | 229 | 28,7 | 22,8 | 37,7 | **37%** | 100% |
| GBPUSD | 2018 | 259 | 26,3 | 20,2 | 34,6 | **29%** | 100% |
| GBPUSD | 2019 | 183 | 25,1 | 18,3 | 33,8 | **26%** | 98% |
| EURUSD | 2012 | 258 | 33,3 | 25,3 | 40,7 | **51%** | 100% |
| EURUSD | 2015 | 257 | 33,4 | 24,8 | 44,3 | **51%** | 100% |
| EURUSD | 2018 | 259 | 24,1 | 18,4 | 33,0 | **24%** | 99% |
| EURUSD | 2019 | 228 | 14,7 | 11,4 | 18,9 | 🔴 **5%** | 78% |

- 🧪 **Contro-esempio sull'orologio** (fatto, non assunto): se i dati non fossero UTC il box
  conterrebbe l'apertura di Londra e la mediana salirebbe. Profilo del range orario mediano GBPUSD
  2018: **8,4-11,4 pip dalle 00 alle 05**, **19,6 alle 06**, **25,8 alle 07**, picco **28,2 alle
  14** (dati USA) → il salto cade dove cade Londra **in UTC**. Orologio confermato.
- 🔴 **Il numero onesto**: il canale largo **non basta da solo**. Con il cancello di costo al 40x
  passa **un giorno su tre su GBPUSD** e fra **uno su due e uno su venti su EURUSD** a seconda
  dell'anno. Il cancello va nel file prova come **`InpMinBoxPts = 332`** (33,2 pip): e' un
  **cancello di costo fissato dall'aritmetica, non una manopola da ottimizzare**.
- Frequenza attesa dopo il cancello: **~0,25-0,35 giorni/simbolo** con box valido `[STIMA dalla
  tabella]`, di cui una parte non rompe → **~0,5 op/giorno di famiglia su due simboli** `[STIMA]`,
  e su ~10 anni di OHLC **>= 150 posizioni per lato** e' raggiungibile.

**MAPPA SU UN EA NOSTRO** — **codice zero**. Pin proposti (ORA SERVER, da verificare contro il
driver): `InpBoxStartHour=0`, `InpBoxEndHour=6`, `InpBoxEndMin=59`, `InpPlaceHour=7`,
`InpPlaceMin=0`, cutoff `10:00`, flat `17:30`, `InpBufferPoints=20` (2 pip), `InpSLMode=0`
(estremo opposto: e' la geometria delle fonti), `InpMinBoxPts=332`, TP/gestione **di default**,
`InpUseCorrelation=false`, lati in **celle separate**.
⚠️ **Orologio**: dal 2025 BCM e' UTC+1 fisso; **prima del cambio (dic-2024/feb-2025) era IT−1 =
UTC d'inverno e UTC+1 d'estate** → nelle estati vecchie `00:00 server` = 23:00 UTC, negli inverni
vecchi = 00:00 UTC: il box **si sposta di un'ora fra le stagioni**. Va dichiarato, non corretto
di nascosto (stessa trappola di `ANALISI_PDF_LONDRA` §0.4).
⚠️ **Non si sovrappone** a `R258` (canale di UN'ora 06-07 del PDF, `ABTG_Londra_ORB`): il box qui
e' di **sette ore**.

**COSTO DI UN PRIMO ROUND** — nessuna ora di codice; **1 file prova per simbolo**, 2 lati x magic
gemella = **4 passate per simbolo, 8 in tutto**, OHLC M1 su finestra lunga (screening, verdetto
solo a tick); base `R260` ~20 s per passata su 6,5 anni d'oro → **~5-10 minuti di macchina**
`[STIMA]`. `@DAQUANDO` **da misurare** con `scarica_storico.ps1` (pavimento forex gen-1999 per R102,
ma non l'ho verificato per questi due simboli).

**PUNTEGGIO** — semplicita' **2** · il filtro E' il motore **2** (il box e' la tesi) · tesi **2** ·
buco **2** (forex mattina europea: in casa nessuna sedia) · testabile senza riscritture **2** →
**10 · PROVA SUBITO**.
**PERCHE'** — il motore che vive sull'oro non e' mai stato misurato sul forex con un buffer da
forex; la prova costa minuti e chiude una casella del certificato.

**IN OTTICA PROP** — un'operazione al giorno per simbolo, stop = ampiezza del box (0,65% a stop
pieno), flat in giornata = **peggior giornata ~ −1,3% con due simboli entrambi a stop**
`[DERIVATO: 2 x 0,65]`; **correlazione alta GBPUSD/EURUSD** (stesso dollaro, stessa ora): mai
tutte e due a rischio pieno lo stesso giorno senza misurare la correlazione sui per-trade. Nessuna
sovrapposizione oraria con le sedie indici d'apertura (08:00 DAX e' la stessa ora: si sommano
**due rischi** alla stessa campanella, dichiararlo al Guardian).

---

### P2 · 🥇 GOLD BREAKOUT EA — DONCHIAN 20 H4 + EMA200, SOLO LONG (famiglie F e A)

```
NOME            Gold Breakout EA for XAUUSD H4 +90 Percent in a 2020 to 2026 Backtest
FONTE / URL     https://www.mql5.com/en/code/77691
                sorgente https://www.mql5.com/en/code/download/77691/GoldBreakoutEA.mq5
AUTORE / DATA   pagina: "Ali Akbar" (utente RanaAli878); sorgente: #property copyright "Ali Rajput"
                -> due nomi per lo stesso autore [VERIFICATO entrambi, identita' INCERTA]
                pubblicato 24/09/2026 23:28   POPOLARITA' 84 download, 402 visite, 1 voto
LICENZA         nessuna dichiarata nel sorgente [INCERTO] — Code Base, download pubblico;
                attribuzione obbligatoria in testa a qualunque ABTG_ derivato
RIGHE / INPUT   428 righe · 16 input (11 manopole vere)
```
**TESI IN UNA RIGA** — _"guadagna perche' sull'oro le rotture di un massimo a 20 barre H4, prese
solo sopra la EMA200, catturano la persistenza del trend dei metalli (flussi lenti e ripetuti:
banche centrali, ETF, compratori asiatici)"_. La seconda meta' e' **[LETTO-VIA-SEARCH]**: World
Gold Council, _Gold Mid-Year Outlook 2026_ (pagina murata), riassunto: _"many pullbacks occurring
during US hours while gold's rebounds generally occurred during Asian hours"_.

**MECCANICA** [VERIFICATO, righe del sorgente]
- **ingresso**: all'apertura di ogni barra H4, se la barra **chiusa** (shift 1) chiude sopra il
  massimo delle 20 precedenti **e** la barra prima non lo faceva (r.`CheckBreakout`: canale da
  `h[2..21]`, `c[1] > up && c[2] <= upPrev`), e `c[1] > EMA200` (shift 1) → **buy a mercato**;
- **stop** = `2,0 x ATR(20)` dal **prezzo di riempimento** (`OpenTrade`), mai sotto la distanza
  minima del broker; **target** = **2R fisso** (`EXIT_FIXED`, default); uscite alternative
  cablate: trailing 3 ATR (A) e canale di Turtle a 10 barre (B);
- **una posizione alla volta**; nessun orario salvo "niente ingressi negli ultimi 15 minuti della
  sessione" e chiusura del venerdi' **opzionale** (`InpCloseFriday=false`).

**GESTIONE RISCHIO** — **rischio % del BALANCE** (`LotForRisk`, via `OrderCalcProfit`, che
aggira il `TICK_VALUE` sbagliato sull'oro) · **cancello spread = 10% dello stop**
(`InpMaxSpreadToRisk=0.10`: e' la **nostra regola R55**, gia' scritta dall'autore) · SL **vero**
al broker · max 1 posizione.

**BANDIERE ROSSE** — **nessuna del §4**. Un rilievo di mestiere: l'ordine parte **senza SL** e lo
stop si attacca subito dopo (`trade.Buy(lot,...,0.0,0.0,...)` poi `PositionModify`); se l'aggancio
fallisce la posizione si chiude. **Finestra nuda di pochi millisecondi**: nel nostro porting lo
stop va **nella richiesta d'ordine**. Look-ahead: **nessuno** (canale su barre 2..21 contro la
chiusura della 1; EMA letta a shift 1).

**NUMERI DICHIARATI** [DICHIARATO, NON VERIFICATO — MetaQuotes-Demo, "every tick generated from
M1", spread e swap inclusi, 10.000 USD, 1%] — 2020.01.01-2026.09.20: **198 operazioni tutte long,
PF 1,77, win 46,97%, DD equity 11,38%, 9 perdite di fila (mid-2021, −8,2%)**, tenuta media ~71 h.
Per anno: 2020 +5,1% · 2021 **−2,9%** · 2022 +4,6% · 2023 +4,8% · 2024 **+24,0%** · 2025
**+27,1%** · 2026 +7,9%. Con gli short accesi: 310 operazioni, **PF 1,28**, gli short **−2.080**.
L'autore **dice da solo** che _"most of the money came from 2024 and 2025"_ e che le tre uscite
sono state provate **anno per anno** prima di scegliere la C (= scelta fatta guardando i
risultati: **l'uscita di default e' il picco dell'autore, non il nostro altopiano**).
🔴 Questi numeri **non entrano nel punteggio**.

**COSTO DI PORTING** — **~2-3 ore** `mql5-ea-developer` (e' gia' MQL5, niente riscrittura):
nuovo `ABTG_GoldBreakout` con (1) SL/TP **nella richiesta d'ordine**, (2) rischio % dell'**equity**,
(3) `OnTester` + export per-trade di casa, (4) chiamata `ABTG_GuardiaIngresso`, (5) magic
vergine, (6) attribuzione in testa. **Motore INTATTO**: canale 20, ATR 20, stop 2 ATR, EMA200,
solo long. **Cosa rifarei** (dopo, e come asse, non al primo giro): la gestione di casa **parziale
1R + BE + runner 2R** come cella contro il 2R secco.

**PRIMO ROUND** — `XAUUSD H4`, OHLC M1 sulla finestra lunga (dal 2004, come R100 `[da rimisurare
sul PC di backtest]`): **gemella di magic (2 passate) + asse dell'uscita A/B/C (6 passate) = 8
passate**, poi **tick** sulla sola finestra con tick (`2024.07.05` → oggi, 2 passate). Con ~30
operazioni/anno `[DICHIARATO]` la finestra 2004-2026 da' **~600 posizioni** `[STIMA lineare]` →
l'Emendamento A (>= 150 IS **e** >= 150 OOS) e' raggiungibile **solo con la finestra lunga**: sui
6,7 anni dell'autore (198 op.) **non lo e'**. **~10-15 minuti di macchina** `[STIMA]`. E subito dopo
i **gemelli** (certificato ④): `XAGUSD` e un forex H4 (l'autore dichiara EURUSD H1 **PF 1,03**:
prior debole, va detto).

**PUNTEGGIO** — semplicita' **2** · il filtro E' il motore **1** (il canale e' il motore; la EMA200
e' stata **aggiunta dall'autore dopo** aver visto le uscite: lo dichiara) · tesi **2** · buco **2**
(oro swing H4 long: nessuna sedia; e' il meccanismo della famiglia F che il mandato chiede) ·
testabile **1** (serve l'`ABTG_` di porting) → **8 · PROVA SUBITO**.
**PERCHE'** — sorgente pulito, una regola, rischio gia' in % e cancello spread gia' in % dello
stop; il rischio che resta e' di **regime** (2020-2023 piatto) e si misura, non si discute.

**IN OTTICA PROP** — una posizione alla volta, **peggior giornata ≈ uno stop (0,65%)** salvo gap
del weekend: tenuta media **71 h** → attraversa i fine settimana. **Evaluation FTMO: weekend
libero**; **FTMO Account Standard: va chiuso prima del weekend** (`docs/REGOLAMENTO_FTMO_2026-08.md`
§5) → o conto **Swing** o `InpCloseFriday=true` come **cella misurata**, non accesa a occhio.
DD dichiarato 11,38% @1% → **~7,4% @0,65%** `[DERIVATO lineare]`: sta nel muro ma **stretto**, e la
curva e' **a scalini con un lungo piatto 2020-2023** = la forma che il **DD trailing punisce**
(§7-bis.4). Correlazione: **lato long dell'oro come `770402`** → mai tutte e due a rischio pieno
senza misurare la sovrapposizione sui per-trade.
⚠️ **Avvertenza di letteratura** [VERIFICATO, abstract]: Kurth, Eisler, Rej, Bouchaud, _Is Trend
Still Your Friend?_ (arXiv **2607.01550**, 02/07/2026): su ~100 futures 1995-2025 il trend
**a breve** ha smesso di pagare dopo il 2009 sui contratti a **tick piccolo** e resiste su quelli
a tick grande. Il nostro H4 e' "breve": e' la ragione per cui il verdetto va chiesto **per epoca**
(Emendamento B/C), non sulla media.

---

### P3 · 🧭 `770402` LATO LONG CON LA DIREZIONE DELL'ORO COME CANCELLO (famiglia A) — codice zero

```
FONTE ESTERNA   TradingView "Asia Range Breakout Scalper (GC/Gold) [Strategy]" — bradenstrock,
                39 like, PUB;8ee9baafc8754294a7b1d9094a870c82, creato 01/03/2026, 127 righe
                [VERIFICATO] — NON e' in biblioteca (il fratello "GC Asia Session Breakout"
                e78e0512 si')
                + la stessa scelta, indipendente, dell'autore di P2: "The 200 EMA filter softens
                that bet: when gold trades below its 200 EMA, the EA simply stops buying"
LICENZA         nessuna dichiarata [INCERTO] — non si porta codice, solo la regola
```
**TESI IN UNA RIGA** — _"la rottura rialzista del box asiatico dell'oro paga quando l'oro e' in
trend rialzista, e perde quando compra contro un mercato che scende"_.

**MECCANICA della fonte** [VERIFICATO] — box `1900-0000 New York` (≈ il nostro 23:00-04:59 BCM
d'estate), finestra d'ingresso `0000-0500 NY`, ingresso su `close > asiaHigh + buffer` **solo se
`close > EMA(200)`**, stop 1,2 ATR / target 1,8 ATR, max 2 operazioni/giorno, chiusura a fine
finestra.
🔴 **Bandiera §4 sulla FONTE**: `calc_on_every_tick=true` → la "chiusura" e' valutata **dentro la
barra** = equivale a un pendente, e i numeri dello Strategy Tester di TradingView **non valgono
nulla**. Nessun numero dichiarato nel sorgente. **Si prende solo la regola di direzione**, che non
ha questo difetto.

**MAPPA SU UN EA NOSTRO** — **codice zero**, sul filtro gia' esistente di `ABTG_MaxMinNotte`
(`CorrBias()` r.698-709, letto oggi): `InpUseCorrelation=true`, **`InpCorrSymbol=XAUUSD`** (l'oro
su se stesso), `InpCorrTF=H4`, **`InpCorrEmaFast=1`** (media a 1 periodo = la chiusura H4 a
shift 1), **`InpCorrEmaSlow=200`** → _"compra la rottura solo se la chiusura H4 e' sopra la
EMA200 H4"_. `CopyBuffer(...,1,1,...)` = barra chiusa, nessun look-ahead [VERIFICATO r.705].
Tutto il resto **identico a `R260a`** (solo long, geometria del preset R103).
⚠️ Da verificare nel primo giro: che `iMA` con periodo 1 restituisca la chiusura (atteso sì
`[INFERITO]`) — si controlla con l'autotest del log, non a occhio.

**COSTO** — **2 passate** (una cella, magic gemella) **accodate a `R260a`**, stessa finestra OHLC
M1 2020-2026: **~1 minuto** `[STIMA dalla base R260: ~20 s/passata]`. `R260a` e' l'ancora (gate
spento), quindi il confronto e' **a una variabile**.

**PUNTEGGIO** — semplicita' **2** · il filtro E' il motore **0** (e' un cancello aggiunto: la
lezione **0 su 5** vale anche qui, e va scritta) · tesi **1** · buco **2** · testabile **2** →
**7 · IN CODA**, ma **dietro solo a `R260a`**: costa un minuto.
**PERCHE'** — sul `770411` il cancello S&P ha **raddoppiato il PF** (1,19 → 2,0); e' l'unico
precedente in casa in cui un cancello di direzione **ha funzionato su questo stesso EA**, e la
domanda qui e' identica.

**IN OTTICA PROP** — il punto non e' il PF: e' il **DD**. `770402` e' **bocciata per rischio** alla
taglia del preset (~19,6-21,3% @2% `[DERIVATO]`). Il cancello serve **se taglia il DD piu' di
quanto tagli il profitto**; con ~meta' delle operazioni il merito puo' finire **sospeso per n**
(~250-370 posizioni long attese da `R260a`, dimezzate ≈ 125-185 `[STIMA]`): il rischio si legge
lo stesso (Emendamento B).

---

### P4 · 🔁 L'INGRESSO DEL BOX NOTTURNO AD ASSE: PENDENTE / CHIUSURA / RITEST (famiglie A e D)

```
FONTE ESTERNA   TradingView "Breakout Session Asiatique avec Retest (RR modifiable)" —
                samuelmathieu050, 37 like, PUB;31855484569b4ab6bc93ed4d55f8b8a3,
                creato 13/08/2025, Pine v6, 87 righe, 5 input [VERIFICATO] — MAI visto in casa
                (grep "Asiatique|samuelmathieu": zero)
                + "Asian Breakout - AutoBot" (P1) per l'ingresso a CHIUSURA
LICENZA         nessuna dichiarata [INCERTO] — si porta la regola, non il codice
```
**TESI IN UNA RIGA** — _"dopo che la chiusura ha confermato la rottura del box, il ritorno sul
livello rotto offre lo stesso trend con uno stop piu' corto e meno false rotture"_. In casa e'
la frase di R42: _"L'unica cosa che ha sempre pagato e' il RETEST"_, e `R197A` sul Dow l'ha
confermato **in tutte e due le finestre** (retest IS 1,21214 / OOS 1,25384 contro breakout IS
**0,96503**).

**MECCANICA della fonte** [VERIFICATO] — box asiatico `2000-2359 + 0000-0800`; **passo 1**:
`crossover(close, rangeHigh)` fuori sessione = rottura confermata; **passo 2**: barra con
`low <= rangeHigh and close > rangeHigh` = ritest → **ingresso alla chiusura**, stop = **minimo
della barra di ritest** − buffer, target 3R; un trade per sessione.
🔴 **Due difetti della fonte, sulla GESTIONE** (quindi si rifanno, non squalificano il motore):
(a) stop = minimo di **una** barra → su M15 oro ~2-4 $ contro 0,24 $ di spread = **8-17x**, sotto
il 40x `[INFERITO dallo spread misurato 0,24 $, CACCIA_APERTURE_ORO]`; (b)
`default_qty_type=percent_of_equity, 1` = taglia, non rischio. **Nessuna finestra oraria di
uscita** (tiene fino alla sessione dopo).

**MAPPA SU UN EA NOSTRO** — serve `mql5-ea-developer`: a `ABTG_MaxMinNotte` un input
**`InpEntryMode`** = `0` pendente (**default, retro-compatibile = ancora R260a**) · `1` chiusura
M15 oltre box+buffer · `2` ritest (limite sul bordo rotto + offset, armato solo dopo la chiusura
oltre il box, scadenza al cutoff). **Stop come oggi** (`InpSLMode`, NON il minimo della barra di
ritest: e' il difetto (a)). Il modulo ritest esiste gia' in `ABTG_Dow_Apertura_US`
(`InpEntryMode`, `InpRetestOffsetPts`): si **trapianta**, non si inventa.

**COSTO** — **~3-4 ore** di codice + cancello (controlla + agente); round **3 celle (0/1/2) x
magic gemella = 6 passate** OHLC M1 2020-2026 sul lato long dell'oro (**~2-3 minuti**), poi le
stesse 6 su GBPUSD **se P1 passa**. Verdetto a tick sulla finestra coi tick.

**PUNTEGGIO** — semplicita' **1** (aggiunge un modo) · il filtro E' il motore **2** (e' l'ingresso,
non un cerotto) · tesi **2** · buco **2** · testabile **1** (serve codice) → **8 · PROVA SUBITO
DOPO P1-P3**.
**PERCHE'** — e' lo stesso asse che ha **incoronato il retest sul Dow e sul DAX** e l'ha
**bocciato sul Nasdaq** (`R198`, segno invertito su 3 celle su 3): la risposta **dipende dal
simbolo**, quindi sull'oro va misurata, non trasportata.

**IN OTTICA PROP** — il ritest **riduce le operazioni** (non tutte le rotture tornano) e accorcia
lo stop solo se lo si ancora al livello: la peggior giornata resta **uno stop**; il rischio vero
e' la **frequenza** (sul Dow `EntryMode=1` ha fatto **2 operazioni** in una finestra, `R197A`).

---

## 5. 🏠 TRE CASELLE DI CASA A COSTO ZERO, EMERSE CACCIANDO (NON promosse: non sono fonti web)

Le scrivo perche' il certificato del 09/09 le chiede, non perche' le raccomandi. Tutte e tre
hanno un **prior sfavorevole scritto accanto**.

| # | motore di casa | simbolo / lato | perche' e' una casella vuota | prior | costo |
|---|---|---|---|---|---|
| V1 | `ABTG_BreakinBox` (falsa rottura del box notturno) | **XAUUSD, lato LONG** (falsa rottura del **minimo** notturno) | girato **solo su D30EUR** (31/08); per il certificato ④ il gemello oro manca | 🔴 su DAX **PF 1,007 · DD 24,1%**, battuto dal proprio controllo (RR fisso **1,106 · DD 19,7%**); geometria sepolta 4 volte (R42, R45+, R95, BreakinBox) | 2-4 passate, ma **i pin in punti** (`InpMinStopPts`, `InpSlBufferPts`, `InpMT5PerPuntoIndice`) vanno riconvertiti per l'oro |
| V2 | `ABTG_GapContinuation` | **U30USD, solo SHORT** (gap-down >= 0,50%) | mai girato su U30USD (solo 225JPY e DAX `R253`) | 🔴 sonda del 25/09 sul gemello **S&P: t 0,49 (NO)**; arXiv 2605.04004 (MNQ): "near-miss", **2024 negativo**; DAX a tick `R253` **PF 0,898 su 29** | 2 passate, ma **~0,09 op/seduta**: merito sospeso per aritmetica in partenza |
| V3 | `ABTG_OutOfNoise` (cono di rumore, Zarattini-Aziz-Barbon via script MIT di Yuri Lopukhov, gia' in biblioteca) | **U30USD, solo SHORT** | `PASSO0_OUTOFNOISE_02_short` esiste **solo su NASUSD** e non e' mai girato | 🔴 cono SOLO corto sul DAX: **−0,028 R, 3/8 anni** (sonda 25/09) e l'edge **crolla allargando lo stop** (+0,054 → +0,012 R, 12/09) | 2 passate (clone del passo 0) |

---

## 6. 📋 FAMIGLIA PER FAMIGLIA — ogni meccanismo suggerito dal mandato, col suo numero

### A — rottura del box notturno ORO, lato long
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| rottura con **ritest** | 🟢 **P4** | mai misurato sul box dell'oro; `R197A` Dow retest > breakout in IS e OOS |
| **falsa rottura** (break-in) | ⚪ **V1** (casa, prior sfavorevole) | `BreakinBox` DAX PF 1,007 DD 24,1% |
| rottura solo dopo **compressione** (box stretto in ATR) | 🔴 **non promosso** | e' un cerotto sul motore (in `MaxMinNotte` esiste gia' come `InpMaxBoxPts`, cioe' **un parametro**); lapide **L3** (indici): **9.723 segnali, 0/8 sopra il pavimento, delta vs caso −1,2 pt** |
| ingresso sulla **chiusura M15** oltre il box | 🟢 dentro **P4** (modo 1) | fonte AutoBot; R45 (chiusura M5 + EMA 9/21 su range di 15-30') **0/48** era un altro livello |
| 🆕 **direzione dell'oro come cancello** | 🟢 **P3** | fonte Braden GC; precedente `770411` + S&P 1,19 → 2,0 |
| 🆕 **Donchian H4 + EMA200 solo long** | 🟢 **P2** | Code Base 77691 |

### B — box notturno DAX, lato long
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| **gap-fill** dell'apertura Xetra (comprare il gap-down) | 🔴 **contro-misurato** | sonda DAX 25/09 (2.017 sedute 2011-2018): il gap-down **CONTINUA** (+0,185 R, t 2,12, 6/8 anni) = chi compra il riempimento sta sul lato perdente; _"lungo speculare senza informazione"_. E `DAX_Apertura_EU` `InpEntryMode=1` misura il gap sulle **D1 del CFD** (7-9 op.): strumento difettoso, non misura |
| rottura del **box del giorno precedente** | 🔴 **misurato** | `R242a` long **7 celle, PF 0,732-0,941** |
| long solo con **futures USA overnight positivi** | ⏳ **gia' in coda** | `R261a` (`InpUseCorrelation` a specchio): ~46 posizioni attese → merito sospeso per costruzione |
| 🆕 **overnight drift all'apertura europea** (Boyarchenko-Larsen-Whelan, NY Fed SR 917) | 🔴 **scarto** | primaria murata; **[LETTO-VIA-SEARCH]** Liberty Street Economics 07/2026 _"The Disappearing Overnight Drift"_: il 3,7%/anno della finestra 02-03 ET **"averaging close to zero since 2021"** — lo dicono gli autori stessi. E' sui futures USA, non sul DAX |
| 👉 **verdetto B** | **zero promossi**: il web non porta niente che `R242`/`R244`/`R261` non abbiano gia' scritto | |

### C — apertura USA, short Dow
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| **fade della prima candela** | 🔴 | R42 fade **0/24 + 0/24**; Nasdaq fade **0,930**; arXiv **2605.11423** (Mesfin, MNQ 2021-2025, letto oggi): sui giorni ad alto gap+volume _"Eight directional configurations were tested. **None passed**"_, miglior T 1,46 |
| **sweep del massimo pre-market** poi short | 🔴 | sweep+reclaim **R95 0/30**; sweep di micro-pivot **L2: 22.616 segnali, delta vs caso −0,2 pt**; TV `TJR asia session sweep` = stessa geometria |
| short **solo nei gap-down** | ⚪ **V2** (casa, prior sfavorevole) | S&P t 0,49 · DAX a tick PF 0,898 su 29 |
| short con range **5'/15'** invece di 35' | 🔴 **non e' un meccanismo** | e' `InpRangeMinutes` dello **stesso motore** di `R54a` (OOS 0,840): regola della seconda caccia, **MAI parametri diversi del motore morto**. E `R255a-x` (22 file) sta gia' ad asse su uscite e TF di stop |
| 🆕 cono di rumore solo short | ⚪ **V3** | DAX −0,028 R |
| 👉 **verdetto C** | **zero promossi dal web** (TV: `US30 ORB 5m` TP 10 punti = **5x**; `US30 Stealth` stop <= 30 punti = **15x**; `Ellis US30` 20+ input) | |

### D — Londra 07-08, GBPUSD/EURUSD
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| rottura del **range ASIATICO intero** | 🟢 **P1** | sonda §4.1: 40x passa **26-37%** dei giorni su GBPUSD |
| **sweep della liquidita' asiatica** e inversione | 🔴 | geometria sepolta (R42, R45+, R95, BreakinBox) + `nsclk/Asian-Range-Breakout-EA` gia' scartato il 12/09 come BreakinBox riga per riga; TV `TJR asia session sweep` idem |
| breakout su **chiusura H1** | 🟢 dentro **P4** (modo 1, sul TF di gestione) | |
| ⏳ il canale 06-07 del PDF | gia' in coda `R258a-x` | |

### E — notte asiatica, fade
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| **mean reversion Bollinger H1 notturna** | 🔴 | i sorgenti trovati **non hanno stop**: `Bollinger Bands Mean Reversion by Kevin Davey` (EdgeTools, MPL 2.0: solo `strategy.close` sulla banda alta, `calc_on_every_tick=true`, solo long) · `Konigs BB (Session Filter)` (gia' visto il 25/08: esce sulla media, nessuno stop). E la famiglia MR su bande in casa: `MeanRevert` **R60 12/12** morto |
| fade del **solo primo impulso** | 🔴 | e' il fade post-impulso: lapide ISM **PF 0,85 / 0,73**; _"invertire una strategia perdente non e' un meccanismo nuovo"_ |
| fade su **oro/indici** dove la notte e' laterale | ⏳ gia' in coda | `R259` Nightly su XAUUSD/XAGUSD/D30EUR/U30USD/AUDUSD/USDJPY (24 passate); D30EUR gia' **escluso per costo** (18,4-20,9x) |
| 👉 **verdetto E** | **zero promossi** | |

### F — trend H4 con EMA200
| meccanismo suggerito | esito | numero / fonte |
|---|---|---|
| **breakout di Donchian H4 con filtro EMA200** | 🟢 **P2** | Code Base 77691; in casa `CanaleLento` e' Donchian 55/20 **senza** EMA e misurato **solo D1 oro, n=20** |
| **pullback alla EMA** con conferma | ⏳ **e' `ABTG_EMA200`** | `R264a-d`, `R265` gia' scritti (oro H4 finestra unica PF 1,381 su 187 deal) |
| **Supertrend H4** | ⏳ in casa | `SupertrendReversal` + 9 EA; ~18 Supertrend TV scartati per doppione il 13/09 |

---

## 7. 🗑️ GLI SCARTATI — una riga di motivo a testa

| fonte | titolo / id | motivo |
|---|---|---|
| Code Base **77639** | `SMC Gold: Liquidity Sweep and Order Block EA for XAUUSD M15` (Ali Akbar, 23/09/2026, 518 righe, sorgente **letto**) | 🔴 **doppione**: sweep dello swing + chiusura oltre il corpo = R95 **0/30** / BreakinBox; stop minimo **3x lo spread** (`InpMinSLToSpread=3.0`) contro il nostro 40x; PF dichiarato **1,12 / 1,10** gia' sul pavimento |
| Code Base 77595 | `EA Trend Follower` (PSAR giornaliero, Syamsurizal Dimjati, 22/09) | 🔴 letta solo la scheda: _"base architecture for research... not optimized"_; PSAR D1 = incrocio senza tesi (§5C) |
| Code Base 77470 | `RiskGuard Lite - Percent-Risk EMA/ATR EA` (21/09) | 🔴 scheda: _"clean template... No profit claim"_; incrocio EMA = §5C |
| Code Base 77653 | `EMA Cross Demo EA with ATR Stops` (24/09) | 🔴 scheda: curva di equity **su dati sintetici**; incrocio EMA |
| TV | `TJR asia session sweep` (antonioreale94, 75 like, 590 righe) | 🔴 sweep + BOS = geometria sepolta; rischio in **USD fissi**; 590 righe quasi tutte grafica |
| TV | `US30 AsianRange 1900-0000 LIMIT OCO (1pct risk)` (shaneeames07) | 🔴 **fade** a limite al 115% del range = R42 **0/24**; SL fisso 30 punti contro spread 2 = **15x** |
| TV | `US30 Stealth Strategy` (LigerzWays, 90 like) | 🔴 insalata MA50+volume+engulfing; stop = candela <= 30 punti = **<= 15x** |
| TV | `Ellis US30 Combo Strategy` (alexmateo1991) | 🔴 SMA 21/50/200 + MACD + StochRSI + divergenze, 20+ input, target giornalieri in $ |
| TV | `US30 ORB 5m / 1m Strategy` (pmaley34, MPL 2.0) | 🔴 ORB della prima 5' (famiglia ~210 celle); **TP 10 punti** = **5x** lo spread |
| TV | `Prop-Firm London Breakout – Optimized PF≥2` (RamonBosch072) | 🔴 EMA50 + ADX>25 appiccicati; "Optimized" nel titolo; `lonHigh` include la barra corrente → la condizione `high > lonHigh + ATR` **non puo' scattare dentro la finestra** (bug di logica) |
| TV | `London Breakout` (Cookedaburra, 2018, Pine v2) | 🔴 `pyramiding = 6`, `qty = 300` fisso, `stop=200` passato come **prezzo** (bug) |
| TV | `Bollinger Bands Mean Reversion by Kevin Davey` (EdgeTools, 125 like) | 🔴 **nessuno stop**, `calc_on_every_tick=true` |
| TV | `Konigs \| Bollinger Band Mean Reversion (Session Filter)` | 🔴 **nessuno stop** (gia' scartato il 25/08) |
| TV | `Follow the Trend - Trade Pullbacks` · `Trend Pullback System` | ⚪ gia' visti il 01/09 (`CACCIA_FREQUENZA3_TV_GH`) |
| MQL5 art. **17239** | Asian Breakout (Munene, 2025) | 🟠 **usato come SPECIFICA di P1**, non come motore: e' `MaxMinNotte` + SMA50 + lotto fisso 0,1; numeri solo in immagine |
| TV | `Asian Breakout - AutoBot` · `Asia Range Breakout Scalper (GC)` · `Breakout Session Asiatique avec Retest` | 🟠 **usati come SPECIFICHE** di P1 / P3 / P4 (difetti di gestione scritti nelle schede) |
| arXiv **2605.11423** | Mesfin, _VVG classifier (MNQ)_ | 🔴 **evidenza negativa** per C: _"None passed"_ |
| arXiv **2607.01550** | Kurth-Eisler-Rej-Bouchaud | ⚪ **cultura/avvertenza** per F (trend a breve degradato dopo il 2009 sui tick piccoli) |
| arXiv 2507.04481 | Glasserman-Krstovski-Laliberte, _Does Overnight News Explain Overnight Returns?_ | ⚪ cultura: cross-sezionale su azioni, nessuna regola per noi |
| arXiv 2510.01542 | Han, _Extended Samuelson Model_ | 🔴 nessuna regola testabile, tono da prospetto (_"Renaissance... Medallion"_) |
| NY Fed SR 917 | Boyarchenko-Larsen-Whelan, _The Overnight Drift_ | 🔴 **svanito dopo il 2021 secondo gli autori** [LETTO-VIA-SEARCH]; primaria murata |
| WGC | _Gold Mid-Year Outlook 2026_ | ⚪ tesi (rimbalzi in Asia, ritracciamenti in USA) [LETTO-VIA-SEARCH], nessuna regola |
| GitHub | `nsclk/Asian-Range-Breakout-EA-for-MT5` | ⚪ gia' scartato il 12/09 (= BreakinBox; `.mq5` 404, UI 403) — ricontrollato oggi: README 200, sorgente ancora 404 |

---

## 8. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

| buco | cosa ci costa |
|---|---|
| 🔴 **GitHub ricerca/API 403** | nessun repo nuovo con storia dei commit |
| 🔴 **SSRN 403** | niente Zarattini-Aziz-Barbon (_Beat the Market_) ne' la primaria di Boyarchenko: le due tesi di C e B restano di seconda mano |
| 🔴 **NY Fed / Liberty Street / fedinprint / CBS: EGRESS_BLOCKED** | _"The Disappearing Overnight Drift"_ l'ho solo nel riassunto della ricerca; **i numeri esatti post-2021 non li ho letti** |
| 🔴 **gold.org: EGRESS_BLOCKED** | la frase del WGC sulle ore asiatiche e' **[LETTO-VIA-SEARCH]**: **periodo e numeri ignoti** |
| 🔴 **backtest.substack.com** (_Intraday Short Setup in ES Futures_, Dave Johnson) | l'unico titolo trovato su **short intraday dell'S&P**: murato. 🙋 **Due minuti del browser di Claudio** potrebbero chiudere questo buco per la famiglia C |
| 🟠 **Quantpedia 504 → 466** | "non adesso": si riprova, non si cancella |
| 🔴 **Forex Factory 403** | resta chiuso il posto dove si legge come invecchia un sistema di Londra |
| 🔴 **arXiv API 406** (nuovo) | ripiegato sulla pagina `/search/`, che funziona |
| ⚪ **Pagina TradingView dei tre script usati come specifica** | ho letto il **sorgente**, non la pagina: eventuali numeri dichiarati li' `[NON LETTI]` |
| ⚪ **`@DAQUANDO` forex e oro sul PC di backtest** | **non misurato**: va misurato con `scarica_storico.ps1` prima di scrivere i file prova |

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **P1** — _"Il box asiatico intero (00:00-06:59 server) rotto con i pendenti di `ABTG_MaxMinNotte`,
> stop all'estremo opposto e cancello di costo `InpMinBoxPts=332`, fa **PF >= 1,10 in entrambe le
> finestre con >= 150 posizioni per lato** su GBPUSD e/o EURUSD — oppure il cancello del 40x lascia
> cosi' pochi giorni (EURUSD 2019: **5%**) che il merito resta sospeso per aritmetica?"_
>
> Attesa scritta prima: **H0 = PF ~1,0 e DD alto** come `Londra_ORB` (OHLC 11% di celle positive,
> DD 23%); **H1 = segno positivo su almeno un simbolo** come sull'oro. Se H0, **il box notturno e'
> un'inefficienza dell'oro e non del forex**, e la famiglia D si chiude con il certificato completo.

E per **P2**, la domanda di regime (Emendamento B/C): _"sulla finestra lunga dal 2004, il
Donchian H4 + EMA200 solo long sull'oro ha un DD <= 10% alla taglia di casa **anche negli anni in
cui l'oro non trendava** (2012-2015, 2021) — o i numeri dell'autore sono il 2024-2025 e basta?"_

---

## 10. 📜 ATTRIBUZIONI E LICENZE

| materiale | autore | licenza | uso |
|---|---|---|---|
| `GoldBreakoutEA.mq5` (Code Base 77691) | Ali Akbar / Ali Rajput (RanaAli878) | **non dichiarata** `[INCERTO]` — download pubblico Code Base | porting in `ABTG_` **con attribuzione in testa**; sorgente **non archiviato** in biblioteca da questo lavoro (sta nella cartella temporanea di sessione) |
| `SMC_Gold.mq5` (77639) | stesso autore | non dichiarata | solo lettura, scartato |
| MQL5 art. 17239 | Allan Munene Mutiiria | riservata MetaQuotes | solo specifica |
| TV `Asian Breakout - AutoBot` | bhanubisen1 | non dichiarata | solo specifica |
| TV `Asia Range Breakout Scalper (GC/Gold)` | bradenstrock | non dichiarata | solo specifica |
| TV `Breakout Session Asiatique avec Retest` | samuelmathieu050 | non dichiarata | solo specifica |
| dati Oanda M1 | FutureSharks/financial-data | **GPL-3.0** | sonda di costo §4.1, **non BCM, mai verdetto** |

_🛑 Nessun EA, preset, file prova, sedia o conto toccato. Nessuna riga di lancio. Nessuna taglia
proposta. Le riprese dei promossi passano, come tutto, da `controlla_prova.py` e dall'agente
`controllo-preventivo` prima di arrivare a Claudio._
