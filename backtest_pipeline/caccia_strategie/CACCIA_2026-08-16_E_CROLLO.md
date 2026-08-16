# 🏹 CACCIA DEL 16/08/2026 — **E · IL CROLLO**

_Bersaglio: motori che **lavorano quando il mercato si rompe** — scorrelati o
positivi nel crollo. Il buco e' misurato, non dedotto (R50, 8 celle congelate
su 4 regimi veri):_

| cella | ORSO 2022 | **CROLLO 2020** | TORO 2021 | LATERALE 2019 |
|---|---:|---:|---:|---:|
| PTE_GBPUSD | +1.245 | **+70** | +1.362 | +5.284 |
| LARRY_GBPUSD | +1.587 | **−708** | +4.095 | −6.445 |
| BB_EURUSD | +932 | **+502** | −1.561 | −2.381 |

---

## 📌 LA RIGA CHE CONTA

> **Su 320 titoli del Code Base e ~25 voci arXiv, 6 sono arrivati al sorgente
> o al testo pieno, 1 lo proverei** — ed e' `BreakoutStrategy` di QuanDuong:
> un canale di Donchian **simmetrico, senza take profit, con lo stop sul
> bordo opposto**, 290 righe e 6 manopole vere.
>
> 🎯 **Ma la cosa piu' importante che porto oggi non e' l'EA: e' la tabella
> di un paper CFM del 2 luglio che spiega, dall'esterno e con 100 futures,
> perche' le nostre ~210 celle ORB sono morte — e dice dove il trend e'
> ancora vivo. Non era il nostro codice: era il settore e la velocita'.**

---

## 1. 🚦 CONTROLLO POSITIVO, FONTE PER FONTE (§2)

Fatto **prima** di cercare, ogni volta su un bersaglio di cui conoscevo gia'
la risposta.

| fonte | controllo positivo | esito |
|---|---|---|
| **MQL5 Code Base** `mql5.com/en/code/mt5/experts` | HTTP **200**, 83.405 byte, 40 titoli/pagina con link reali. Fra i primi: `ProAutoSL DynamicTP`, `Session Opening Range Breakout EA`, `Daily Zone Recovery EA mt5 for GOLD`, `Smart Trade Manager`, `GoldLondonBreakout`, `Nikkei 225 Gap Continuation EA` — **sei file che ho gia' in archivio**: e' il bersaglio di cui sapevo la risposta | 🟢 **PASSA** |
| **arXiv API** `export.arxiv.org` | `cat:q-fin.TR` → 10 voci con titolo, autori, data, id reali | 🟢 **PASSA** |
| **arXiv listing** `arxiv.org/list/q-fin.TR/recent` | HTTP 200 | 🟢 **PASSA** |
| **arXiv full text** `arxiv.org/html/2607.01550v1` | HTTP 200, 299.484 byte, tabelle e appendici leggibili | 🟢 **PASSA** |
| **Quantpedia** `quantpedia.com/screener` | HTTP 200 dopo redirect, 640.878 byte, slug reali (`asset-class-trend-following`, `currency-momentum-factor`, `exploiting-term-structure-of-vix-futures`, …) | 🟢 **PASSA** |
| **QuantConnect** `quantconnect.com` | HTTP 200, titolo reale | 🟢 raggiungibile — **non usata**, vedi §5 |
| **SSRN** `papers.ssrn.com` | **HTTP 403** | 🛑 **NON RAGGIUNTA** |
| **Forex Factory** `forexfactory.com/forum/71-trading-systems` | **HTTP 403** | 🛑 **NON RAGGIUNTA** |

⚠️ **Ricerca interna MQL5 inutilizzabile** (`robots.txt`: `Disallow: /*/search*`,
pagina JavaScript). Aggirata come da mandato: **WebSearch** `site:mql5.com/en/code`
per scoprire, **curl/WebFetch** su `/en/code/NNNNN` per leggere, download da
`/en/code/download/NNNNN/<nome>.mq5`. **Verificato: funziona.**

---

## 2. 📚 COSA HO SFOGLIATO DAVVERO

### MQL5 Code Base — 320 titoli, 5 sorgenti scaricati e letti

**8 pagine × 40 titoli** (`/experts`, `/experts/page2` … `/page8`), indicizzate
e filtrate per parole del buco (`momentum`, `donchian`, `turtle`, `channel`,
`volatilit`, `ATR`, `trend`, `regime`, `bear`, `short`, `weekly`, `daily`,
`drawdown`, `correlat`) e per parole-veleno (`recovery`, `grid`, `martingal`,
`zone`, `multiplier`): **22 titoli su 320 colpiti dal veleno solo dal titolo.**

Poi WebSearch mirata, che ha aperto la porta vera: `donchian`, `turtle`,
`channel breakout`.

### arXiv q-fin — 4 ricerche, 3 paper letti

`crisis alpha` · `time series momentum` · `tail risk hedging` ·
`trend following AND crisis`. ~25 voci restituite, **3 aperte**, di cui **1
letta nel testo pieno** con le tabelle.

### Quantpedia — screener gratuito, scorso e scartato in blocco

Slug reali e leggibili, ma la sezione libera e' quasi tutta **cross-sectional
azionaria** (13F, ESG, accrual, F-score, cicli sul cross-section dei titoli):
richiede un **universo di titoli** che noi non abbiamo. **§3.A: e' cultura, non
candidati.** L'unica voce sul mio bersaglio — `Time Series Momentum` — e' la
stessa famiglia che arXiv mi ha gia' consegnato meglio e piu' aggiornata.

---

## 3. 🔬 LA SCOPERTA CHE VALE PIU' DELL'EA

### `arXiv:2607.01550` — Kurth, Eisler, Rej & Bouchaud (CFM), 02/07/2026
**"Is Trend Still Your Friend?: A Microstructural Account of the Demise of
Short-Term Trend-Following"** · ~100 futures liquidi, 1995-2025
[VERIFICATO: testo pieno aperto e letto]

#### 🔴 Tabella 1 — il numero che riguarda le nostre ~210 celle

Sharpe del segnale di trend EWM-*n*-4*n*, due sottoperiodi:

| scala veloce *n* | Sharpe **1995-2009** | Sharpe **2009-2025** |
|---:|---:|---:|
| 5 giorni | **0,84** | **0,12** |
| 10 giorni | 0,83 | 0,22 |
| 20 giorni | 0,79 | 0,27 |
| 50 giorni | 0,70 | **0,40** |

> _"pre-2009 Sharpes are monotonically decreasing in n (from 0.84 to 0.70),
> whereas post-2008 **the ordering reverses**, with the fastest signal
> collapsing to 0.12 and the slowest still delivering 0.40."_

**Prima del 2009 il veloce batteva il lento. Dopo il 2008 l'ordine si ribalta.**
E lo Sharpe rolling a 5 anni dell'indice CTA _"collapses from a historical
range of 1-2.5 to a level statistically indistinguishable from zero post-2010"_.

#### 🔴 §3.3 — e questa e' la riga che ci riguarda personalmente

> _"Trend has effectively **vanished for IDX** (equity indices) **and FXR**
> (currencies), while **YLD** (bonds) **and CMD** (commodities) show no
> appreciable degradation."_

E nel catalogo dei 101 contratti dell'Appendice A ci sono, per nome:
**DAX · CAC · EUROSTOXX · DJMINI · AEX · EUR · CHF · AUD · CD**.

> ### 🎯 COSA VUOL DIRE PER NOI, IN UNA RIGA
> **Il nostro universo intero — indici + forex — e' esattamente il sottoinsieme
> dove il trend e' svanito dal 2009. E le nostre ~210 celle ORB a tick reali
> sono la versione piu' veloce che esista di quel segnale.**
>
> Per anni abbiamo letto quel referto come _"il breakout puro al tocco e'
> morto ovunque"_, cioe' come un fatto sul **meccanismo**. Questo paper dice
> che era un fatto su **settore + velocita'**, e lo misura su 100 futures e
> 30 anni. **Non e' una scusa: e' una mappa.** Dice dove NON andare (veloce,
> su indici e valute) e dove il segnale e' ancora integro (lento, su
> obbligazioni e materie prime).

⚠️ **E dice anche una cosa che mi vieta l'entusiasmo:** il discriminante
trasversale vero non e' il settore ma la **tick size normalizzata per la
volatilita'** — _"post-2008 trend PnL has collapsed on small-tick contracts
**across all signal horizons**"_. Cioe': **andare lenti non basta se lo
strumento e' small-tick.** [INCERTO] su quale lato della soglia stiano i
NOSTRI simboli: il paper non pubblica il valore di taglio e io **non ho
misurato** `SYMBOL_TRADE_TICK_SIZE / ATR` sui simboli BCM. E' una misura da
una riga di MQL5 e **va fatta prima di credere a questo dossier fino in fondo**.

### `arXiv:2607.19497` — Sepp & Lucic, 21/07/2026 — la tesi, in forma usabile
**"The Science and Practice of Trend-Following Systems"**

Serve per una cosa sola, ed e' quella che decide un parametro:

> _"we derive the closed-form skewness of aggregated TF returns, which is
> **positive at every horizon** and peaks near half the filter span. […] the
> positive skewness of TF returns is **structural**"_

**La skewness positiva e' il crisis alpha.** Tante perdite piccole, poche
vincite enormi. 👉 **Un take profit su un motore di trend compra un motore
diverso**, perche' taglia l'unica parte che paga. E' il motivo per cui, fra i
due candidati letti, ho scartato quello col nome famoso.

### `arXiv:2409.14510` — "Crisis Alpha", 18/08/2024 — 🔴 SCARTO, ed e' la trappola del §3.A
Khodayari Gharanchaei & Babazadeh. Titolo perfetto, contenuto inutilizzabile:
**1.000 azioni USA, dataset CRSP 1990-2023, modelli di rischio statistici di
portafoglio.** Richiede un universo di mille titoli e un motore di ottimizzazione
di portafoglio. **Non e' traducibile su un simbolo e un timeframe che abbiamo.**
E' cultura, non un candidato — e lo scrivo perche' e' il primo risultato che
esce cercando "crisis alpha" e il prossimo cacciatore non ci perda un'ora.

---

## 4. ✅ IL PROMOSSO — uno solo

# 🥇 `BreakoutStrategy.mq5` — **il canale lento simmetrico**

```
NOME            Simple Yet Effective Breakout Strategy
FONTE / URL     https://www.mql5.com/en/code/49272
                sorgente: /en/code/download/49272/breakoutstrategy.mq5
AUTORE / DATA   Anh Quan Duong ("QuanDuong" / header "QuanAlpha") · 2024.04.17
                [VERIFICATO] pagina aperta, `datePublished 2024-04-17T12:12:06`
POPOLARITA'     [INCERTO] — la pagina non espone il conteggio download
LICENZA         [INCERTO] — `#property copyright "Copyright 2024, QuanAlpha"`,
                nessuna licenza dichiarata nel sorgente
RIGHE / INPUT   290 righe · 9 input dichiarati, di cui **3 stringhe
                decorative + 1 nome bot** -> **6 manopole vere** (VERIFICATO,
                contate nel sorgente)
```

### TESI IN UNA RIGA
> **Quando il mercato si rompe, il prezzo esce dal canale delle ultime N barre
> e ci resta: si entra sulla rottura, dai due lati, senza take profit, e si
> lascia correre la coda.**

### MECCANICA — tre righe

- **INGRESSO**: ordine **stop** (`BuyStop`/`SellStop`) a un tick sopra il
  massimo / sotto il minimo delle ultime `ENTRY_PERIOD` barre **chiuse**
  (`ENTRY_SHIFT = 1`), ripiazzato a ogni nuova barra, `ORDER_TIME_DAY`.
- **STOP**: il **bordo opposto del canale d'uscita** (o la sua mediana), cioe'
  un punto del grafico — non un numero.
- **USCITA**: **nessun take profit** (`tp = 0.0`). Trailing sul canale/mediana
  che si stringe barra dopo barra (`PositionModify`), o chiusura a mercato se
  il prezzo lo attraversa.

### GESTIONE RISCHIO
**Rischio in % dell'equity** (`RISK_PER_TRADE = 0.01`) · **SL vero mandato al
broker** all'ingresso · **una posizione per lato**, contata per **simbolo +
magic** · lotto arrotondato **verso il basso** (`MathFloor`).

### BANDIERE ROSSE (§4)
🟢 **NESSUNA.** Cercate tutte nel sorgente: niente martingala, niente
moltiplicatore sul lotto, niente griglia, niente averaging, niente hedge di
copertura, niente `#import`, niente `WebRequest`, niente `iCustom`, niente
`OnCalculate`. Lo stop e' vero e sta al broker. Decide **su barre chiuse** e
**una volta per barra** (`BarOpen()`): niente repaint, niente look-ahead.

### COSTO DI PORTING
**MQL5 nativo. ~1,5 ore** — non e' un porting, e' un'adozione: si riscrive
come `ABTG_CanaleLento.mq5` con `OnTester` e i nomi di casa.

### PUNTEGGIO (0-2)

| voce | punti | perche' |
|---|:--:|---|
| semplicita' | **2** | 290 righe, **6 manopole vere** contro il tetto di ~15 |
| il filtro **E'** il motore | **2** | il lato lo decide quale bordo si rompe: non c'e' nessun filtro appiccicato, non c'e' nemmeno un `AllowShort` da spegnere. §5.B: **0 successi su 5** quando e' un cerotto, **30 celle su 30** quando e' costitutivo |
| tesi scrivibile | **2** | una riga, e con due paper dietro |
| riempie un **BUCO** | **2** | **tre in un colpo**: il **CROLLO** (nessuna cella nostra tiene una posizione per settimane), lo **SHORT simmetrico vincolato** (R52: 4 titolari su 5 hanno un lato *SCELTO* su 21 mesi di mercato in salita), e una **banda di frequenza nuova** — le 32 celle censite stanno tutte fra M5 e H4, **nessuna su D1** |
| testabile senza riscritture | **1** | serve un `ABTG_` nuovo: manca `OnTester`, c'e' un bug di unita' da correggere, e il sizing va reso onesto |

### 🏆 **VERDETTO: PROVA SUBITO — 9/10**

---

### 🔧 §5.F — COSA TENGO (il motore) · COSA RIFACCIO (la gestione)

#### 🟢 COSA TENGO — ed e' tutta la ragione per cui il candidato esiste

| tengo | perche' |
|---|---|
| ⭐ **NESSUN TAKE PROFIT** | e' **la** proprieta'. La skewness positiva del trend following e' strutturale (Sepp & Lucic): il guadagno **sta** nella coda destra. Le nostre ~210 celle ORB hanno tutte un TP a multipli di R — **questa domanda non l'abbiamo mai posta** |
| **simmetria VINCOLATA** | il lato non e' un input: e' quale bordo si e' rotto. Impossibile sceglierlo sull'IS, che e' la malattia di R52 |
| **stop STRUTTURALE** sul bordo opposto | non e' un numero di punti da ottimizzare: e' un punto del grafico |
| **`ENTRY_SHIFT = 1` + `BarOpen()`** | decide su barre chiuse, una volta per barra. Zero repaint, e lo fa meglio del suo concorrente famoso |
| **ordine STOP invece del market** | riempimento **al livello**, non inseguendo il prezzo. E `trigger_long - ask >= 0` impedisce di rincorrere se la rottura e' gia' avvenuta |
| **posizioni contate per simbolo + magic** | il difetto n.1 di `MeanReversion` di Yashar (che usava `PositionsTotal()` di conto) qui **non c'e'** |
| **rischio in % dell'equity** | scalabile a 100k |

#### 🟡 COSA RIFACCIO — e sono tutte cose che sappiamo fare

| # | rifaccio | da | a |
|---|---|---|---|
| 1 | 🔴 **`OnTester`** | **assente** | da scrivere. Senza, `walkforward_generico.ps1` **si rifiuta di partire** (22 EA su 61 gia' bocciati cosi'). **E' il vero blocco** |
| 2 | 🔴 **bug di UNITA'** | `cp - trail_long >= SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL)` (righe 119, 132, 255, 269): confronta una **differenza di PREZZO** con un intero in **PUNTI** | `>= stops_level * _Point`. ⚠️ **Su forex con `stops_level > 0` l'EA non aprirebbe MAI** (0,0015 >= 10 e' falso); su oro e indici passa **per caso**, perche' le differenze di prezzo sono numeri grandi. E' lo stesso errore di `NDTP()` in `Mean_Reversion` di Tzadik |
| 3 | 🔴 **sizing disonesto** | `if(lots < minlot) lots = minlot;` + `return MathMax(lots, VOLUME_MIN)`: se il rischio calcolato sta **sotto** il lotto minimo, **apre lo stesso al minimo, rischiando piu' del dichiarato** | **se non ci sta, non si opera.** (E' il pregio che avevo segnato a `BreakoutEA` dello stesso setaccio: li' era fatto giusto) |
| 4 | 🟡 **spread** | non c'e' nessun controllo | `InpMaxSpreadPctSL` — spread come **percentuale dello stop**, mai in punti (R55) |
| 5 | 🟡 **input decorativi** | 3 stringhe `aa`/`bb`/`cc` + `BOT_NAME`, e la sintassi non standard `string input aa` ([INCERTO] se MetaEditor la accetta) | via, e `input` prima del tipo |
| 6 | 🟡 **`OrderManaging()`** | incrementa `orders` mai: **restituisce sempre 0** (codice morto, righe 148/160) | valore di ritorno usato o tolto |
| 7 | 🟡 **`CalculateLotSize`** | per lo short calcola `sl_price` **sotto** il prezzo invece che sopra; il numero esce comunque giusto perche' usa `MathAbs(loss)` | pulito e simmetrico |
| 8 | 🔢 **magic** | `EXPERT_MAGIC = 1` | magic **vergine** nostro |

#### ⛔ E LA COSA CHE **NON** DEVO METTERGLI — la piu' importante del dossier

La nostra grammatica di gestione e' **parziale a 1R + breakeven + runner a 2R**,
ed e' quella delle sedie DAX/Dow. 🔴 **Qui NON va messa.**

> Un parziale a 1R e un target a 2R **tagliano la coda destra**, che su questo
> motore e' **l'unica fonte di guadagno**. Applicargli il nostro standard
> significa comprarlo e poi rompergli il motore. Se lo si vuole misurare, si
> misura **come asse separato e dichiarato**, mai come default.

E' l'unico punto in cui l'esperienza di casa e' la cosa sbagliata da applicare,
e va scritto adesso che non abbiamo ancora numeri davanti.

---

### 🏛️ §7-bis — LA RIGA PROP

> **In ottica prop, questo motore e' una GAMBA DI ASSICURAZIONE, non una gamba
> di rendimento: si accende per quello che fa il giorno del crollo, e si paga
> in rate tutti gli altri giorni.**

| criterio prop | questo motore |
|---|---|
| **peggior giornata** (cap 5% = ~7,7R a 0,65%) | 🟢 **buono.** Una posizione per lato, uno stop strutturale, **poche operazioni all'anno**. Non spara 5 trade correlati la stessa mattina — la nostra peggior giornata misurata (R51, −2,06% ≈ 3,2R) nasce dall'affollamento, e qui l'affollamento non c'e' |
| **scorrelazione** | 🟢 **la piu' forte del giro.** Banda di frequenza **nuova** (settimane contro ore), lato **simmetrico** contro 4 titolari su 5 a lato unico, e su un settore (materie prime) dove non abbiamo nessun motore di trend. _"Mai due EA sullo stesso segnale/simbolo/lato"_ — qui non c'e' sovrapposizione con niente |
| **scalabilita' a 100k** | 🟢 rischio in percentuale |
| 🔴 **DD TRAILING** | **il rischio numero uno.** La skewness positiva **e'** una curva a scalini con lunghi ritorni dal picco — cioe' **esattamente la forma che il trailing punisce** (§7-bis punto 4). Le nostre Monte Carlo sono tutte su DD **statico dal deposito** e col trailing **non valgono**. Su una prop col trailing questo motore e' il piu' pericoloso dell'arsenale, non il piu' sicuro |
| 🔴 **overnight e weekend** | **tiene posizioni per SETTIMANE.** Se la prop vieta l'overnight, questo EA e' fuori **dal giorno uno** — insieme a `MaxMinNotte`, `Nightly` e la variante oro (METRO_PROP domanda 3). Da confermare **per iscritto** prima di qualunque acquisto (regola D3) |
| ⚠️ **slippage** | l'ingresso e' un ordine **stop**: in un crollo che passa attraverso il livello, il riempimento e' **peggiore del trigger**, e proprio nel momento che paga. R55 ha misurato che 1,5 punti indice sfondano il cancello del 10% sull'ORB. **Da misurare, non da sperare** |

---

## 5. ❌ GLI SCARTATI — una riga di motivo a testa

### Letti nel sorgente (o nel testo pieno)

| # | file / paper | fonte | motivo dello scarto |
|---|---|---|---|
| 1 | **`TurtleTrader.mq5`** (`Oschenker`, 2017.01.19, [/en/code/16866](https://www.mql5.com/en/code/16866), 437 righe, 13 input) | MQL5 | 🔴 **il nome famoso, e il file peggiore dei due.** Dettaglio sotto |
| 2 | `Lazy Bot MT5 (Daily Breakout EA)` (`Hungtthanh`, 2022.12.13, [/en/code/41732](https://www.mql5.com/en/code/41732), 481 righe, 16 input) | MQL5 | 🔴 **il lotto non e' ancorato allo stop**: `LotSize = InpRisk * FreeMargin / 100000` — e' una taglia sul nozionale, non sul rischio. E lo stop e' **5 pip fissi** (`Inpuser_SL = 5.0`), cioe' scalping, col difetto di scala dei pip gia' visto in `ProAutoSL` |
| 3 | `PriceChannel_Signal_v2 EA` (`barabashkakvn`, 2022.04.15, [/en/code/39012](https://www.mql5.com/en/code/39012), 1.027 righe, 30 input) | MQL5 | 🔴 **13 chiamate `iCustom`** a un indicatore **non incluso nel download** (bandiera §4: non compila) + **30 input** contro il tetto di ~15. Peccato: il canale di prezzo era la famiglia giusta |
| 4 | `003 - Weekly Day Reversal` (`dj_ermoloff`, 2026.06.19, [/en/code/74137](https://www.mql5.com/en/code/74137)) | MQL5 | 🔴🔴 **doppio fuori.** Il download e' uno **zip da 20 file: 16 PNG e 4 HTML, ZERO sorgenti** (verificato spacchettandolo) → niente da setacciare e niente da compilare. E il concetto — invertire un **giorno della settimana scelto per ottimizzazione** (`Thusday-Reverse-optimize`, `sp500-tuesday-reverse-optimize`) — e' la **cicatrice del backtest altrui** gia' condannata su `Universal Breakout Study` |
| 5 | `TrendMomentumEA` (`mazennafee`, 2026.01.22, [/en/code/68512](https://www.mql5.com/en/code/68512), 199 righe, 17 input) | MQL5 | 🔴 **tripla.** `InpLotSize = 0.1` **lotto fisso**; SL/TP in **punti fissi** (300/600); e il motore e' **EMA50 + EMA200 + RSI + Stocastico + finestra di sessione** = quattro filtri impilati su una tesi di trend che **`ABTG_EMA200` gia' copre meglio di chiunque** (R29: 30 celle su 30) |
| 6 | **`arXiv:2409.14510`** "Crisis Alpha" | arXiv | 🔴 **non traducibile.** 1.000 azioni USA, CRSP 1990-2023, modelli di rischio di portafoglio. Serve un universo di mille titoli. **§3.A: cultura, non un candidato** — e lo scrivo perche' e' il **primo** risultato cercando "crisis alpha" |

### 🔴 Perche' `TurtleTrader` esce, in dettaglio — merita di essere raccontato

E' **il** motore canonico del crisis alpha (Donchian 20/55, sizing in unita' di
ATR, stop in ATR, piramidazione sui vincitori — che e' **anti**-martingala e
**non** e' una bandiera §4). Ha 13 input, il rischio in percentuale
(`MaxRisk = 0.01`), lo stop vero al broker. Sul setaccio automatico **e' pulito**.
Poi si legge il codice, e perde su otto voci su dieci:

| | `TurtleTrader` (16866) | ✅ `BreakoutStrategy` (49272) |
|---|---|---|
| **take profit** | 🔴 **`TakeProfit = 1` ATR** con `StopLoss = 1` ATR: R:R **1:1**. **Distrugge la skewness positiva**, cioe' la sola ragione per cui un trend follower esiste. Il Turtle originale **non ha take profit** | ✅ **nessuno** |
| **conto HEDGING** | 🔴🔴 **`OnInit` restituisce `INIT_FAILED`** (righe 303-307). **Il nostro conto BCM e' HEDGING**: non parte, nemmeno nel tester. E non e' una riga da togliere: tutta la contabilita' della piramide e' scritta in semantica **netting** (`PositionSelect(Symbol())`, `PositionGetDouble(POSITION_VOLUME)`), e in hedging l'uscita `Trade(back_ward, position_volume)` **aprirebbe una posizione opposta invece di chiudere** | ✅ nessun vincolo |
| **magic** | 🔴 mai impostato → magic **0**, indistinguibile dal manuale | ✅ impostato |
| **barre chiuse** | 🟡 il canale si inizializza su `Rates[NLT-1]`, cioe' **la barra in formazione** (riga 139-140) | ✅ `SHIFT = 1` |
| **input di timeframe** | 🔴 usa il `Period()` del grafico | ✅ `TRADING_TIMEFRAME` |
| **macchina a stati** | 🔴 rileva SL/TP **cercando le stringhe `"sl"`/`"tp"` nel commento del deal** (righe 421-431): dipende dal broker | ✅ non serve |
| **bug di sizing** | 🔴 `int digits = (int)log10(volume_min)` → per `volume_min=0.01` vale **−2**, e `NormalizeDouble(x, -2)` con cifre negative non e' definito. Manca il segno meno | ✅ `MathFloor(lots/lotstep)*lotstep` |
| **unita' confuse** | 🟡 `VolumeLimit` usato **sia** come "numero massimo di unita'" **sia** come tetto in **lotti** (righe 67, 309, 353) | — |
| `OnTester` | 🔴 assente | 🔴 assente (pari) |
| piramidazione | 🟡 fino a **4 unita'** = 4× rischio concentrato su un simbolo e un lato: rischio **giornaliero**, non diversificato | ✅ una posizione per lato |

> 🎯 **La lezione, e vale oltre questo file: il nome famoso non e'
> l'implementazione.** "Original Turtle Rules" e' il titolo giusto sul motore
> giusto, ma l'autore gli ha messo un take profit a 1 ATR — cioe' ha preso il
> sistema il cui intero edge e' la coda destra e **gliel'ha tagliata**. Il file
> senza nome, scritto da uno sconosciuto sette anni dopo, e' quello fedele
> alla tesi.

### Scartati dal titolo, senza aprirli — e perche' e' legittimo

**22 titoli su 320** colpiti dalle parole-veleno congelate nel `SETACCIO_MANUALE`
(_recovery · zone · grid · multiplier sul lotto · martingale_). Sono la terza
edizione della stessa correzione di mira: non si riaprono.

Piu' l'intera fascia **utility** della prima pagina (`Quantora Spread Monitor`,
`Round Trip Cost Reconciler`, `Trade Transaction Trace Logger`, `Risk Position
Size Calculator`, `Margin Requirement Calculator`, `Trade Adjustment Panel`,
`Trading Panel EA`, `Equity Guard`, `Trading Performance journal`, `Trade
Manager Panel`…): **non aprono posizioni**, quindi §"attrezzi", **fuori
imbuto**, gia' deciso su `ProAutoSL_DynamicTP` e `SmartTradeManager`. Non ci
sono ricascato.

---

## 6. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

1. 🛑 **SSRN** (`papers.ssrn.com`) — **HTTP 403**. Non raggiunta. E' la fonte
   dove stanno Moskowitz-Ooi-Pedersen (*Time Series Momentum*) e Hurst-Ooi-
   Pedersen (*A Century of Evidence on Trend-Following*), cioe' i due lavori
   che ancorano storicamente questa tesi. **Ho la tesi da arXiv, non da loro.**
2. 🛑 **Forex Factory** — **HTTP 403**. Non raggiunta. E' l'unico posto dove si
   legge **come una strategia e' invecchiata**: per un motore di trend lento,
   che e' proprio la domanda, e' una perdita vera.
3. ⬜ **QuantConnect** — raggiungibile, **non usata**. Scelta, non impedimento:
   le sue strategie sono Python e il costo di traduzione supera il valore
   atteso quando ho gia' un `.mq5` nativo che fa la stessa cosa.
4. ⬜ **Il conteggio download e la licenza** dei due EA MQL5: la pagina non li
   espone in HTML leggibile. **[INCERTO]**, e non pesa sul punteggio (i numeri
   dell'autore non sono un criterio comunque).
5. 🔴 **La tick size normalizzata dei NOSTRI simboli.** E' il discriminante
   centrale del paper CFM e **non l'ho misurata**. Finche' non c'e', la scelta
   dell'oro poggia sul risultato di settore (§3.3), che e' piu' debole del
   risultato di tick size (§5.2). **Va misurata: e' una riga di MQL5.**
6. 🔴 **La prima data vera dello storico `XAUUSD_EXT`.** Il commento del driver
   dice 2018-2024; **un commento non e' una misura**. Per questo `@DAQUANDO`
   nel file prova e' **vuoto**.

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ### **Un canale simmetrico SENZA take profit, tenuto per settimane su barre GIORNALIERE, sopravvive nella finestra dove le nostre celle si dividono — il CROLLO — o muore come le ~210 celle ORB, e allora la famiglia breakout si chiude anche nel suo ramo lento?**

E' una domanda con **due risposte utili**, che e' la ragione per cui vale 20
celle di macchina:

- **Se passa**, abbiamo la prima gamba di portafoglio che vive in una banda di
  frequenza che non copriamo, su un lato simmetrico vincolato, in un settore
  dove la letteratura dice che il segnale e' ancora integro.
- **Se muore**, abbiamo chiuso il breakout **anche nel ramo lento e simmetrico
  e senza TP** — cioe' l'ultima versione della famiglia che non avevamo mai
  provato — e la mappa del paper CFM ci dice di smettere di cercare da quella
  parte. **Vale quasi quanto un successo, e costa un ventesimo.**

⚠️ E c'e' un terzo esito, il piu' probabile, che va messo in conto **adesso**:
**"non giudicabile per campione"**. Su D1 con un canale a 55 barre le
operazioni sono poche decine in sei anni. Se succede, **non si abbassa la
soglia** (R59 ha appena mostrato cosa costa: un PF 2,08 su 7 operazioni
diventava 0,72 su 52): si **allarga ai simboli**, rifacendo la stessa cella
congelata sugli 8 `_EXT`, che e' esattamente il modello di R59.

---

## 8. ▶️ LA RIGA DI LANCIO PROPOSTA

🛑 **NON lanciabile oggi.** Nell'ordine, e nessun passo e' saltabile:

```
1. SCRIVERE  mql5/Experts/ABTG_CanaleLento.mq5
             (adozione di BreakoutStrategy.mq5 + attribuzione in testa,
              con le 8 correzioni del §4 e OnTester)
2. MISURARE  powershell -ExecutionPolicy Bypass -File .\scarica_storico.ps1 `
                        -Simboli "XAUUSD_EXT" -SoloReferto
             -> @DAQUANDO vero da scrivere nel file prova
3. A VUOTO   powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 `
                        ABTG_CanaleLento -SoloControllo
             -> deve dire 20 celle. Se ne dice altre, ci si ferma.
4. LANCIO    powershell -ExecutionPolicy Bypass -File .\walkforward_generico.ps1 `
                        ABTG_CanaleLento -DaQuando <data misurata al passo 2>
```

⚠️ Da passare prima da `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.
⚠️ Il parametro e' `-Expert`, **non** `-EA` (alias di `-ErrorAction`).
⚠️ Questo EA **non ha orari**: la regola del fuso BCM (ora server = ora
italiana − 1) non lo tocca. Lo dichiaro perche' e' la prima cosa che si
controlla, e qui la risposta e' "non si applica".

**File prova gia' scritto:** `backtest_pipeline/prove/ABTG_CanaleLento.txt`

---

## 📊 IL BILANCIO DI QUESTA CACCIA

> **320 titoli indicizzati · 25 voci arXiv · 6 arrivati al sorgente o al testo
> pieno · 1 promosso · 5 scartati con motivo · 22 scartati dal titolo per
> veleno gia' congelato.**

**I tre motivi ricorrenti degli scarti**, in ordine: **sizing non ancorato al
rischio** (lotto fisso o sul nozionale: 2), **manopole oltre il tetto o
dipendenze esterne** (2), **non traducibile sul nostro banco** (2 — un paper su
1.000 azioni USA e uno zip senza sorgente).

E il motivo per cui il migliore e' il migliore, in una riga:
**e' l'unico che non ha un take profit.**
