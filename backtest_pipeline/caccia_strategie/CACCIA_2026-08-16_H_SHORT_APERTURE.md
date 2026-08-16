# 🎯 CACCIA 2026-08-16 — H · **IL LATO SHORT DELLE APERTURE DI DAX E NASDAQ**

> **La riga che conta:**
>
> Su **330 titoli guardati su 4 fonti vive** (240 titoli del Code Base su
> 6 pagine nuove, 65 paper arXiv su 5 query, 15 repo GitHub, 10 risultati
> TradingView) — **più 2 fonti dichiarate nulle** —
> **4 arrivano al testo completo**, e **ZERO li proverei**.
>
> 🛑 **Torno a mani vuote sul codice, ed è l'esito che il mandato prevedeva.**
> Ma non torno a mani vuote e basta: porto **due fatti** che cambiano dove si
> cerca, e uno dei due viene dal **nostro archivio**, non da fuori.

**Bersaglio dichiarato:** `CODA_PROSSIMA_SESSIONE.md` §5 punto 3 — _"il lato
SHORT dell'apertura: R54 ha bocciato lo short del Dow (PF OOS 0,840 su 73
trade), ma su DAX e Nasdaq non è mai stato misurato come motore nato short,
solo come ramo aggiunto."_

**Vincolo di mira, preso da R52 + `ROBUSTEZZA.md` prima di uscire:** non cerco
un motore long a cui aggiungere `AllowShort` — quella forma ha **0 successi su
5** (R20, R12, R26, R45, R54). Cerco **motori la cui direzione è costitutiva**,
sul modello `ABTG_GapFill.mq5:424 isLong=(gGap<0.0)`.

---

## 0. 🎣 CONTROLLO POSITIVO — fatto prima di cercare, fonte per fonte

| fonte | esito | la prova (bersaglio di cui conoscevo già la risposta) |
|---|---|---|
| `mql5.com/en/code/mt5/experts` | 🟢 **PASSA** | HTTP 200. Nei primi 40 titoli ci sono **`ProAutoSL DynamicTP`** (76165), **`Session Opening Range Breakout EA`** (76153), **`Daily Zone Recovery EA mt5 for GOLD`** (75922), **`Smart Trade Manager`** (75916), **`GoldLondonBreakout`** (75586), **`Nikkei 225 Gap Continuation EA`** (75301), **`003 - Weekly Day Reversal`** (74137) — **sette file già nel nostro `SETACCIO_MANUALE.md` o nei dossier di oggi.** Il canale restituisce ciò che so già esserci. |
| paginazione `/page5` … `/page9` | 🟢 **PASSA** | 40 titoli distinti per pagina, nessuna ripetizione. Su `/page5` compare **`Simple Yet Effective Breakout Strategy` (49272)**, il promosso della caccia E — secondo riscontro indipendente. |
| `export.arxiv.org` (API) | 🟢 **PASSA** | 4 query, titoli/autori/date reali e verificabili |
| `arxiv.org/abs/NNNN` (scheda singola) | 🟢 **PASSA** | 2 abstract riprodotti **verbatim** |
| GitHub (`search_repositories`) | 🟢 **PASSA** | restituisce repo veri e notori: `geraked/metatrader5` (602 ⭐), `EarnForex/PositionSizer` (586 ⭐), `yulz008/GOLD_ORB` (275 ⭐), `EA31337/EA31337-classes` (263 ⭐) |
| `tradingview.com` | 🟢 **PASSA** | risultati reali, script identificabili per autore |

### 🔴 Fonti NON raggiunte — dichiarate, non sostituite con la memoria

| fonte | esito | nota |
|---|---|---|
| `papers.ssrn.com` | 🔴 **NULLA** | **HTTP 403 — verificato da me oggi**, non ereditato dal brief. |
| `forexfactory.com` | 🔴 **NULLA** | 403 Cloudflare come misurato stamattina. Perdiamo l'unica fonte che racconta **come una strategia è invecchiata**. |
| ricerca interna MQL5 | 🔴 **INUTILIZZABILE** | `robots.txt` → `Disallow: /*/search*` |
| `WebSearch site:mql5.com/en/code` | 🟡 **NON USATA** | la caccia F l'ha misurata a resa quasi nulla. **Ho sfogliato direttamente l'elenco**, come raccomandato. |

---

## 1. 🔴 IL PRIMO FATTO, E VIENE DA CASA: **il bersaglio era più piccolo di come è scritto**

Prima di uscire ho letto R52, e poi sono andato a cercare cosa avessimo già
misurato sullo short dell'apertura degli indici. **C'è più di quanto dica la
riga della coda**, ed è decisivo per capire dove un candidato possa ancora
vivere.

### `REFERTO_ROUND43_ORL.md` — 13/08/2026 [VERIFICATO, file in repo]

> _"Agli estremi del range di apertura, su NASUSD e D30EUR, **NON ESISTE edge
> in nessuna combinazione misurata**"_

| lancio R43 | celle verdi IS | celle verdi OOS | migliore OOS |
|---|---:|---:|---|
| a) NASUSD LONG (ORL) | 0/8 | 0/8 | −82 (PF 0,98) |
| **b) NASUSD SHORT (ORH)** | **2/8** | **0/8** | **−1.863 (PF 0,65)** |
| c) D30EUR LONG (ORL) | 0/8 | 0/8 | −311 (PF 0,95) |
| **d) D30EUR SHORT (ORH)** | **0/8** | **0/8** | **−165 (PF 0,97)** |

E il **26° ribaltamento** è proprio sul nostro lato: le due uniche celle verdi
dell'intero round sono **short NASUSD in campione**; la cella scelta dal
criterio fuori campione fa **−2.961 (PF 0,59, DD 31,4%)** — la peggiore del suo
lancio.

Il file prova esiste ed è `prove/R43b_orl_NASUSD_short.txt`, con
`InpAllowLong=0` / `InpAllowShort=1`: **è esattamente la forma "ramo aggiunto"**
di cui parla la coda.

### 🎯 La correzione di mira che ne esce, e va scritta

> **La riga della coda è vera, ma va precisata così:** sul DAX e sul Nasdaq lo
> short dell'apertura **agli estremi del range di apertura è già stato
> misurato**, su 64 celle a tick reali, ed è **morto** — e R43 ha chiuso quel
> capitolo **"DEFINITIVAMENTE, non si riapre senza fatti nuovi esterni"**.
>
> Quindi un candidato esterno che **shorta la rottura o il fade dell'ORH è
> morto in partenza**: non è materiale nuovo, è la 65ª cella.

Sommando le porte già chiuse sulle aperture (R7-R13 ~210 celle, R42 48/48,
R43 64 celle, R45 48 celle, R12 48/48), **restano esattamente due meccaniche
di apertura non chiuse**:

| meccanica | stato |
|---|---|
| **il RETEST** | 🟢 l'unica che paga — ma **ci viviamo già sopra** (`ABTG_DAX_Apertura_EU` live, win rate 81,0%). Un candidato qui sarebbe un doppione (§5.D). |
| **il GAP di apertura** | 🟡 **l'unica porta davvero aperta**: `ABTG_GapFill` misura il gap che si **chiude**; il gap che **continua** non l'abbiamo mai misurato, su nessun indice (CODA §5 punto 2) |

**Quindi la caccia si è ristretta da sola a una domanda sola:** esiste, fuori,
un motore *nato short* sul **gap** di apertura di DAX o Nasdaq?

---

## 2. 🔬 IL SECONDO FATTO: la letteratura ha misurato **proprio quello**, sul nostro mercato

E la risposta che dà è **"quasi"** — che nel nostro metodo vale più di un "sì".

### 2.1 `arXiv 2605.04004` — **Mesfin, falsificazione sistematica su MNQ**

```
TITOLO      Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures:
            A Systematic Falsification Study
AUTORE      Mathias Mesfin
DATA        v1 05/05/2026 · v2 13/07/2026
CATEGORIE   q-fin.TR · q-fin.CP · q-fin.ST
CAMPIONE    Micro E-Mini Nasdaq 100 (MNQ) futures — 947 giorni di
            contrattazione, 2021-2025, dati a CINQUE MINUTI
                                            [VERIFICATO, abstract letto verbatim]
```

**Il metodo dell'autore è il nostro**, e questo è il motivo per cui l'ho letto
fino in fondo invece di scartarlo come l'ennesimo paper:

| criterio dichiarato da Mesfin | il nostro equivalente |
|---|---|
| walk-forward **out-of-sample** | l'imbuto IS/OOS |
| **T ≥ 2,0** | il pavimento PF ≥ 1,10 |
| **almeno 30 trade** | _"15 trade per famiglia = verdetto"_ · _"sotto n=20 il PF non si giudica"_ |
| netto dopo **2 punti** di attrito | R55, lo spread come % dello stop |
| **coerenza anno per anno** | la prova di regime |
| ✅ **positive controls dichiarati** | **il §2 del nostro mandato, parola per parola** |

> 🎯 **Un autore che pubblica i propri controlli positivi per dimostrare che il
> suo metodo sa riconoscere un edge quando c'è, e poi pubblica 14 fallimenti,
> sta facendo il nostro mestiere.** È la ragione per cui questo paper pesa più
> dei 61 che ho scorso.

**L'esito complessivo è NEGATIVO** — ed è la prima cosa da dire:

> _"None of the tested strategies satisfied all of these requirements."_
> _"Across all signal families, the maximum gross return before transaction
> costs ranged from roughly 0.07 to 1.50 points per trade, well below the
> assumed two-point friction cost."_

**Ma c'è un'eccezione, ed è esattamente il nostro bersaglio:**

> _"One signal family — **gap continuation short** — produces a T-statistic of
> **3.23** and a mean net return of **14.52 points** but on only **22 trades**
> across three years, falling below the minimum sample threshold and therefore
> failing deployment criteria."_

| | |
|---|---|
| **la meccanica** | gap di apertura → si opera **nella direzione del gap** |
| **la direzione** | **costitutiva**: gap giù → SHORT, gap su → LONG. È `isLong=(gGap>0)`, cioè lo specchio esatto del nostro `ABTG_GapFill.mq5:424` |
| **il lato che sopravvive** | 🎯 **lo SHORT.** Su 14 famiglie testate, l'unica con T sopra soglia è il lato short del gap |
| **perché non è deployabile** | **n = 22 in tre anni**, sotto la soglia di 30 dell'autore |

### 2.2 `arXiv 2605.11423` — il gemello, e **rinforza il no**

```
TITOLO   A Validated Volatility-Volume-Gap Classifier for Regime
         Identification in MNQ Intraday Data
AUTORE   Mathias Mesfin · v1 12/05/2026, v2 20/07/2026
CAMPIONE stesso: 947 giorni, MNQ 5 minuti, 2021-2025   [VERIFICATO, verbatim]
```

Classifica la giornata su **tre osservabili di apertura**: il **gap
overnight**, il **rendimento dei primi 30 minuti**, e il **volume della prima
barra** contro una media mobile a 20 giorni — con le soglie calcolate su
**finestra espandente per evitare il lookahead**.

Trova un profilo ricorrente: **continuazione direzionale al mattino, seguita da
inversione a fine sessione**. E poi:

> _"None of the evaluated strategies satisfy the same validation criteria…
> The primary contribution is descriptive rather than predictive… **the
> observed structure does not translate into a robust standalone trading
> signal under realistic execution assumptions.**"_

> 📌 **Perché lo riporto anche se è un no.** È la risposta esterna e misurata
> alla richiesta di Claudio del 15/08 (_"i nostri EA devono capire il mercato e
> quindi entrare o non entrare"_): qualcuno ha costruito **esattamente** quel
> classificatore di apertura, sul Nasdaq, su 947 giorni, senza lookahead — e
> ha misurato che **classificare bene la giornata non basta a farci un
> sistema**. Ce lo risparmia.

### 2.3 ⚠️ LE TRE RISERVE CHE METTO SU QUESTO PAPER — prima che qualcuno lo citi come promessa

**1. C'è un'incoerenza interna nell'abstract, e l'ho notata.** L'autore scrive
che il rendimento lordo di **tutte** le famiglie sta fra 0,07 e 1,50 punti, e
poi che il gap-continuation-short rende **14,52 punti netti** medi. I due numeri
non stanno insieme se non escludendo quella famiglia dal primo intervallo.
**Non ho il testo pieno per scioglierla** → il 14,52 lo tratto come
**[INCERTO]**, non come misura. Il T=3,23 e l'n=22 restano [VERIFICATO].

**2. Quattordici famiglie testate, una sopravvive: è confronto multiplo.** Un
T di 3,23 pescato come migliore di 14 va scontato, e l'autore stesso **non lo
promuove**. Nel nostro linguaggio: è la **cella migliore**, ed è precisamente
ciò che non guardiamo mai (12 Spearman IS→OOS negativi su 13).

**3. MNQ non è NASUSD.** Sono futures a orario quasi continuo su CME; il
"gap overnight" lì è il salto sull'apertura RTH. Da noi è un **CFD BCM con la
sua sessione**. La traduzione non è gratis e non l'ho fatta.

---

## 3. 🧮 IL CONTO CHE CHIUDE LA PORTA — e va fatto prima di scrivere un file prova

Il segnale dell'autore, alla **sua** soglia di gap, scatta:

```
22 trade / 3 anni  =  7,3 trade all'anno
```

Il nostro storico nativo BCM sul Nasdaq è **misurato**, non ipotizzato:
`@DAQUANDO 2024.09.26` — presente in **106 file prova**, di cui **14 con
`@SIMBOLO NASUSD`**, fra cui `R43b_orl_NASUSD_short.txt:21`. [VERIFICATO]

```
26/09/2024 → 16/08/2026  =  22,7 mesi  =  1,89 anni
1,89 anni × 7,3 trade/anno  ≈  14 TRADE IN TUTTO LO STORICO
                                 e sono ~9 IS + ~5 OOS dopo lo split
```

| il nostro metro | il numero |
|---|---|
| _"15 trade per famiglia = verdetto, mai prima"_ | **14 < 15** 🔴 |
| _"sotto n=20 il PF non si giudica"_ | **5 trade OOS** 🔴🔴 |

> ### 🛑 **Il candidato migliore che la letteratura offre su questo bersaglio non è misurabile sul nostro banco nativo.**
> Non è che sia rosso: è che **non arriva al campione minimo che noi stessi ci
> siamo imposti**. Lanciarlo comunque produrrebbe un numero che il nostro
> stesso regolamento vieta di leggere.

**E il dilemma va detto intero, perché ha una via d'uscita apparente che è una
trappola:** si potrebbe **abbassare la soglia di gap** per avere più trade. Ma
la soglia *è* il segnale — l'edge del gap-continuation sta nei gap **grandi**.
Abbassarla per fare campione significa **misurare un'altra cosa** e chiamarla
con lo stesso nome. È la forma pura della manopola girata verso il passato.

**La via d'uscita vera è una sola, ed è già in lista:** lo **storico lungo
esterno** (Pepperstone/import) — cioè la **condizione F della tesi R52**, quella
che tiene bloccate 2 celle su 11 del censimento dei lati. Con 5-6 anni si arriva
a ~40 trade e la domanda diventa lecita.

---

## 4. 🚫 I PROMOSSI: **nessuno.** E perché non ho scritto un file prova

**Non consegno `backtest_pipeline/prove/<NOME>.txt`, di proposito.**

Tre motivi, in ordine di gravità:

1. **Non ho un EA da promuovere.** Il gap-continuation non è un file che ho
   scaricato: è una **tesi misurata in un paper**. Un file prova senza EA è un
   file che il driver non può lanciare.
2. **Il veicolo esiste già, e non è mio.** `Nikkei225_Gap_Continuation_EA`
   (Code Base 75301) è **già in coda dalla caccia C** di stamattina. Il mandato
   di oggi mi vieta di riproporre i promossi delle altre cacce, e ha ragione:
   sarebbe un doppione di coda, non un candidato.
3. 🔴 **E soprattutto: il conto del §3 dice che non è misurabile adesso.**
   Scrivere un file prova per un motore che non raggiunge il campione minimo
   sarebbe **riempire il dossier per non tornare a vuoto** — cioè esattamente
   ciò che il mandato mi vieta.

> ✅ **Ciò che questa caccia consegna alla caccia C non è un file: è un
> ri-orientamento.** Quando il Nikkei Gap Continuation verrà adottato
> (`OnTester` + fuso + sfrondatura), c'è ora una **misura esterna e indipendente
> su 947 giorni del Nasdaq** che dice **dove guardare per primo: il lato
> SHORT del gap** — e un conto che dice **quanto storico serve** perché la
> risposta sia leggibile.

---

## 5. 📋 LA TABELLA DEGLI SCARTATI — 240 titoli nuovi del Code Base

Ho sfogliato le pagine **1, 5, 6, 7, 8, 9** (40 titoli ciascuna = **240**),
scelte perché la caccia F aveva già bruciato **2, 3, 4**. Non elenco i 240:
elenco i motivi ricorrenti e i pochi che meritavano un secondo sguardo.

### 5.1 Arrivati alla scheda o al README, e caduti

| candidato | fonte | motivo dello scarto |
|---|---|---|
| **`Interactive Supply and Demand Zone Trading Prototype`** (DynamicSR4) | `/en/code/75178` — Francis Nyoike Thumbi, 20/07/2026, 2.586 visualizzazioni, **voto 1/5** [VERIFICATO] | Era il più promettente per forma: le zone supply/demand hanno **direzione costitutiva** (supply → short, demand → long). Ma: **4 file, ~106 KB**, e l'autore stesso lo dichiara _"designed purely as a foundational framework and should be utilized **exclusively within a demo environment**"_. §5.E: **costo di validazione ben oltre il valore atteso**. E il voto 1/5 è un segnale, non una prova. |
| **`geraked/metatrader5`** (11 EA, licenza **MIT**) | GitHub, **602 ⭐**, ultimo aggiornamento 15/08/2026 | Repo serio, licenza pulita, ma **tutti e 11 gli EA sono combinazioni di indicatori** (`CEZLSMA`, `3MAF`, `BBRSI`, `3MACD`, `2MACDSTO`, `2MAAOS`, `AFAOSMD`, `NWERSIASF`, `LRCUTB`, `COT1`, `DHLAOS`) — cioè multi-manopola, portati da Pine, **zero motori a direzione costitutiva e zero meccaniche di apertura**. |
| **`Gap Filling Strategy`** (alexgrover) | TradingView | 🔴 **è il nostro `ABTG_GapFill`**: scommette che il gap si chiude. R36/R37 l'hanno già misurato e `225JPY` è fra i promossi. Doppione pieno. |
| `Advanced Market Opening Gap Detector` · `Enhanced Gap Up/Down Analysis` | TradingView | **indicatori, non strategie**: rilevano il gap, non lo operano. Regola del setaccio: `OnCalculate` senza ordini → fuori imbuto. |
| **`Breakout Strategy with Prop Firm Helper Functions`** | `/en/code/49713` | il nome attira in ottica prop, ma il motore è **breakout** — porta chiusa con ~210 celle a tick reali. Non si rimisura. |
| `Indices Testing` | `/en/code/48139` | già scartato dalla caccia F (_"trades buy positions **without stop loss or take profit**"_). Non ricontrollato. |

### 5.2 I motivi ricorrenti che hanno ucciso il resto dei 240

| motivo | quanti (circa) | esempi visti nell'elenco |
|---|---:|---|
| **non è una strategia: è un attrezzo** (pannelli, calcolatori, copier, logger, trailing) | ~85 | `Quantora Spread Monitor`, `Round Trip Cost Reconciler`, `Trade Adjustment Panel`, `Risk Position Size Calculator`, `Quantora Break Even Manager`, `T5Copier`, `Equity Guard`, `CSV Exporter`, `Lotsizer`, `Close panel`, `AutoSet SL TP`, `ChartBrowser`, `Spread Informer` |
| **griglia / martingala / recovery / hedge**, spesso nel titolo | ~25 | `Martingale Trade Simulator`, `Breakout Martin Gale EA`, `Advisor Based on RSI and Martingale`, `Martingale Levels For Money Management`, `Basic Martingale EA v3`, `MA Grid Trade`, `Long and Short Stepped Grid Trade`, `VIDYA N Bars Borders Martingale`, `MACD Four Colors 2 Martingale`, `VR Smart Grid Lite`, `MultiMartin`, `Reversing Grid on Limit orders`, `Reversing Martingale EA`, `Ilan iMA`, `Periodic Range Breakout (Martingale)`, `MT5-CoupleHedgeEA`, `hedger`, `XP Forex Trade Manager Grid` |
| **breakout / opening range** → porta chiusa con ~210 celle | ~10 | `Session Opening Range Breakout EA`, `MA + Envelope Breakouts`, `Moving average breakout`, `Lazy Bot (Daily Breakout EA)`, `Periodic Range Breakout 2.0`, `Range BreakOut EA`, `Range Follower`, `Breakdown catcher`, `Daily range` |
| **motore = combinazione di indicatori** (multi-manopola, tesi non scrivibile) | ~45 | `SuperTrend_Amarnath…`, `Simple EA using Bollinger, RSI and MA`, `CCI + MACD Scalper`, `Macd Divergence Stochastic & BB`, `RSI Dual Cloud EA`, `AO n Stochastic`, `ADX MACD Deev`, `iMA iStdDev`, `Divergence ema rsi`, `AMA Trader 2`, `Classic 2 Moving Averages crossover EA` |
| **scatola nera / ONNX / rete neurale** → tesi non scrivibile, §5.C | ~7 | `EA KCI N-Matrix engine`, `Aegis Quantum Lite`, `Three neural networks`, `Neurotest`, `Examples from the book "Neural networks…"`, `Market Miner`, `MarketPredictor` |
| **codice didattico / frammenti / esempi da libro** | ~30 | `MQL5 Programming for Traders — Parts 1-7`, `A Code block to detect A "New Candle/Bar"`, `Get Nth Closed Trade`, `Detecting the start of a new bar`, `Symbol Filling Policy Determination` |
| **già setacciati** (non li ricontrollo) | 8 | `ProAutoSL DynamicTP`, `Daily Zone Recovery`, `Smart Trade Manager`, `GoldLondonBreakout`, `BreakRevertPro`, `003 - Weekly Day Reversal`, `Nikkei 225 Gap Continuation`, `Simple Yet Effective Breakout Strategy` |
| **fuori perimetro / non serio** | ~4 | `Sudoku`, `time bomb`, `At random`, `At random Full` |

### 5.3 🔎 La conferma del numero della caccia F

> Su **240 titoli nuovi**, i motori con **direzione costitutiva** che valesse la
> pena aprire sono stati **uno** (`Interactive Supply and Demand Zone`) —
> **lo 0,4%**, contro il **3%** misurato dalla caccia F su 119 titoli.
>
> 🎯 **E la differenza non è rumore: è l'ordinamento.** Il Code Base è ordinato
> dal più recente, quindi le pagine 1-4 sono il 2026 e le pagine 5-9 sono il
> **2018-2023** — dove la densità di griglie e martingale è molto più alta e
> quella di EA scritti bene molto più bassa.
>
> 📌 **Conclusione di metodo per le prossime cacce: sotto la pagina 5 il Code
> Base non rende.** Le pagine vecchie sono già state pescate da tutti per
> quindici anni. Se serve materiale, va cercato nelle pagine 1-4 (che sono ora
> esaurite fra F e questa caccia) oppure **fuori dal Code Base**.

---

## 6. 🏛️ IL CANCELLO PROP (§7-bis) — la riga che scrivo anche senza promossi

Non ho promossi, quindi non c'è una scheda. Ma il §7-bis merita una riga sul
**tipo** di motore che questa caccia ha cercato, perché è informazione per la
coda:

> **In ottica prop, un motore di gap-continuation short sull'apertura sarebbe
> il profilo di rischio migliore che abbiamo cercato oggi — e insieme il
> peggiore per il DD trailing.**

| criterio §7-bis | come starebbe messo |
|---|---|
| **1. peggior giornata** | 🟢 **strutturalmente 1R**: un evento al giorno, una posizione, SL vero. A 0,65% su 100k sono **−650**, contro il muro giornaliero di **−5.000**. Non può arrivarci da solo. |
| **2. frequenza / concentrazione** | 🟢🔴 **~7 trade l'anno**: è l'opposto del rischio "5 trade correlati la stessa mattina" (🟢), ma è anche **la ragione per cui non è misurabile** (🔴). Lo stesso numero è la virtù e il difetto. |
| **3. scorrelazione** | 🟢 **la migliore che abbia visto oggi**: sui giorni di gap-giù il nostro `ABTG_GapFill` va **LONG** (contro il gap) e questo andrebbe **SHORT** — stesso evento, stesso istante, **direzione opposta**. È anti-correlazione **per costruzione**, non sperata. ⚠️ Ma `ROTTA_PROP` regola 1 vale anche al contrario: due EA sullo stesso evento vanno misurati insieme con l'export per-trade **prima** di accenderli. |
| **4. DD trailing** | 🔴 **il profilo peggiore possibile.** 7 trade l'anno = mesi interi fermi = **lunghi ritorni dal picco**. È esattamente la forma che una prop con DD che insegue l'equity punisce (Upcomers). **Va segnalato, come chiede il punto 4.** |
| **5. scalabilità a 100k** | 🟡 dipende dall'EA veicolo. Quello in coda (Nikkei Gap Cont.) ha già il rischio in % — è uno dei suoi pregi. |

---

## 7. 🕐 IL FUSO, col calcolo mostrato — regola fissa: **ora server BCM = ora italiana − 1**

Se e quando questo filone si riaprirà, il gap si misura **all'apertura della
sessione**, e l'ora va scritta in **ora server**:

| cosa | ora italiana | calcolo | **ora server (da usare)** |
|---|---|---|---|
| **apertura DAX** (`D30EUR`) | 09:00 | 9 − 1 | **8** |
| **apertura Nasdaq** (`NASUSD`) | 15:30 | 15,5 − 1 | **14:30** → `InpSessionHour=14`, `InpSessionMin=30` |
| chiusura DAX cash | 17:30 | 17,5 − 1 | **16:30** |

✅ **Riscontro nel repo, non un'assunzione:** `prove/R43b_orl_NASUSD_short.txt`
righe **23-24** hanno `InpSessionHour=14||14||0||14||N` e
`InpSessionMin=30||30||0||30||N`. È la campanella del Nasdaq in ora server, ed
è già scritta giusta.

⚠️ **Il controllo di sempre sul CSV che uscirà:** la colonna
`InpSessionHour` deve dire **8** (DAX) o **14** (Nasdaq). Se dice **9** o
**15**, è ora italiana → **numeri da cestinare**.

---

## 8. 🚫 COSA NON HO POTUTO VEDERE

1. **SSRN e Forex Factory: 403.** Su questo bersaglio la perdita di Forex
   Factory è concreta — l'effetto gap di apertura sugli indici è un classico da
   thread decennale, ed è proprio il posto dove si legge **quando ha smesso di
   funzionare**. Buco dichiarato.
2. **Il testo pieno dei due paper di Mesfin.** Ho letto gli **abstract
   verbatim** dalle schede arXiv. Non ho scaricato i PDF, quindi **non ho
   verificato** né la definizione operativa della soglia di gap, né il
   calendario dei 22 trade, né l'incoerenza numerica del §2.3. **[INCERTO]**
3. **Chi sia Mathias Mesfin.** Nessuna affiliazione istituzionale è visibile
   sulla scheda arXiv, e i due lavori sono a **singolo autore, non sottoposti a
   peer review**. Il metodo dichiarato è ottimo; la garanzia esterna è zero.
   **[INCERTO]** — e per questo il paper vale come **indicazione di dove
   cercare**, mai come numero.
4. **Il sorgente di `DynamicSR4`.** Non l'ho scaricato: 4 file per ~106 KB, con
   l'autore che lo dichiara materiale da demo. Ho fermato la lettura alla
   scheda, e lo dico invece di far finta di averlo letto.
5. **Se sul Code Base esistano EA di gap-continuation oltre a quello del
   Nikkei.** La ricerca interna del sito è inutilizzabile e ho sfogliato
   9 pagine su ~30. **Le pagine 10+ non le ho viste** (sono il 2015-2018, dove
   la resa attesa è ancora più bassa — vedi §5.3).

---

## 9. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

Non è più _"quale EA proviamo"_. La caccia l'ha cambiata, e questa è la
consegna vera:

> ### Sul gap di apertura di DAX e Nasdaq — l'unica meccanica di apertura che non abbiamo ancora chiuso — il lato **SHORT** ha un edge fuori campione? E soprattutto: **abbiamo abbastanza storico per poterlo sapere?**
>
> 🔴 **La seconda metà della domanda va risolta PRIMA della prima.** Il conto
> del §3 dice ~14 trade su tutto lo storico nativo: sotto il nostro stesso
> pavimento di 15. **Misurare adesso significa produrre un numero che il
> regolamento vieta di leggere** — ed è il modo più efficiente di fabbricare il
> 31° ribaltamento.
>
> **Il passo giusto non è un round: è lo storico lungo esterno su NASUSD e
> D30EUR** — la stessa condizione F che tiene bloccate 2 celle su 11 di R52.
> Sbloccarla **paga due volte**: apre questo filone e sblocca metà del
> censimento dei lati.

---

## 10. 📎 File di questa caccia

- **questo dossier** — l'unico file che ho scritto nel repo
- ❌ **nessun file prova**, e il §4 spiega perché è la scelta giusta
- ℹ️ **non ho toccato** `SETACCIO_MANUALE.md`, né i file prova o i dossier
  delle cacce D/E/F/C: oggi lavorano più cacciatori in parallelo e sarebbe un
  conflitto di scrittura. Le schede dei 4 testi letti stanno qui in §2 e §5.1,
  pronte da travasare quando le cacce rientrano.

---

> ### 🧭 LA CORREZIONE DI MIRA, QUARTA EDIZIONE
>
> **Sulle aperture degli indici siamo pieni, e adesso lo sappiamo con
> precisione.** Le porte chiuse con numeri: rottura (~210 celle), fade (R42,
> 48/48), estremi del range a lati separati (**R43, 64 celle, capitolo chiuso
> definitivamente**), Londra (R45, 48), ORB+filtri (R12, 48/48), short del Dow
> come ramo (R54, PF OOS 0,840).
>
> **Resta una porta sola: il GAP** — e per attraversarla non serve un altro
> cacciatore. **Serve lo storico.**
>
> | ✅ cerca ancora | ❌ ora chiuso con numeri |
> |---|---|
> | gap continuation · retest (ma è doppione) | breakout · opening range · ORB · fade · **estremi del range** · short come ramo aggiunto |
