# 🕯️ LA CANDELA DELLA NEWS — caccia ai meccanismi SULLA barra del rilascio

> **Ricerca 2 di 2**, 03/09/2026. Gemella: `CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md`.
> Mandato: cercare meccanismi **diversi** dal post-news drift (gia' chiuso, L1)
> e **diversi** dallo straddle OCO pre-rilascio (gia' documentato il 03/09 in
> `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md`).
> I tre bersagli: **spike & fade** · **momentum candle continuation** ·
> **range della candela della notizia come livello**.
>
> ⚠️ Nessun EA toccato, nessun forward toccato, nessuna riga di lancio.

---

## 0. 🔴 IL VERDETTO IN CINQUE RIGHE

**Su 3 meccanismi cercati, 8 implementazioni trovate, 3 sorgenti letti per
intero e 2 paper verificati: ZERO candidati esterni promossi.**
E il motivo non e' che il web sia povero. E' che:

1. 🪦 **Lo "spike & fade" ha una tesi accademica vera — e vive nei SECONDI.**
   Ederington & Lee (JFQA 1995): sovrareazione nei **primi 40 secondi**,
   corretta nel **2º-3º minuto**. 🧱 **E' dentro la finestra vietata FTMO
   (±2 min) e sotto il nostro timeframe minimo (M5).** Non e' un candidato:
   **e' una lapide, e la scrivo come tale.**
2. 🕳️ **Il "momentum candle continuation" NON ha letteratura. Zero.**
   Cercato su arXiv (API), Quantpedia, ricerca generale: quello che torna e'
   **folklore retail** ("news fade", "reversal candle"), **nessuno studio con
   un numero**. Un meccanismo senza tesi non entra: e' una spazzolata.
3. 🎯 **Il terzo meccanismo — il RANGE della candela della notizia come
   livello — CE L'ABBIAMO GIA', ed e' scritto meglio di tutto quello che ho
   letto fuori.** `ABTG_PostNews.mq5` (473 righe, 39 input) **e' esattamente
   quello**: prende max/min di due candele M5 attorno al rilascio, piazza
   BUY STOP e SELL STOP oltre gli estremi, **OCO vero**, SL vero, **rischio in
   percentuale**. §3.
4. 🧱 **Tutte e 3 le implementazioni esterne lette piazzano gli ordini PRIMA o
   SUL rilascio** → **violano FTMO ±2 min**. Il nostro agisce a **news+10 /
   news+15 minuti** → **compatibile**. La differenza fra noi e loro non e' la
   qualita' del codice: e' **il minuto**.
5. 🔑 **La mossa che vale il round non e' un EA nuovo: e' un CSV.** Il motore
   di casa oggi vede **16 eventi l'anno** (FOMC+ECB). NFP+CPI USA escono alla
   **stessa ora (13:30 server)** e **mai lo stesso giorno**: **+24 eventi
   l'anno, +150% di frequenza, zero righe di codice nuove.** §7.

---

## 1. 🎯 CONTROLLO POSITIVO

| fonte | bersaglio noto | esito |
|---|---|---|
| **github.com/search** | `q=mql5` → **2,6k repository** | ✅ **PASSA** — quindi gli zero sotto sono **zeri veri** |
| **mql5.com** Code Base lista | 40 titoli veri | 🟡 **PARZIALE** (autori/date solo nelle pagine singole) |
| **mql5.com** download sorgente | `/en/code/download/55630` → HTTP 200, 7.423 byte, ZIP con 3 file | ✅ **PASSA** |
| **arxiv.org** + API | `cat:q-fin.TR` → 5 titoli | ✅ **PASSA** |
| **quantpedia.com** (blog) | 2 articoli letti interi | ✅ **PASSA** |
| **tradingview.com** pagina script | script aperto, autore e data leggibili | ✅ **PASSA** |
| **forexfactory.com** thread 540134 | — | 🔴 **HTTP 403 — FONTE NULLA** (2ª volta in 24 ore) |
| **ssrn.com · cambridge.org · sciencedirect · researchgate · semanticscholar · nber · federalreserve · ecb.europa.eu** | paper | 🔴 **TUTTE BLOCCATE — FONTI NULLE** |

---

## 2. 🧪 I TRE MECCANISMI, UNO PER UNO

### 2.1 🪦 MECCANISMO A — **SPIKE & FADE** (il primo movimento si esaurisce e ritraccia)

**Tesi in una riga:** *"sul rilascio il prezzo sovrareagisce perche' chi deve
riprezzare colpisce il book vuoto; quando la liquidita' torna, il prezzo
rientra."*

🟢 **La tesi ESISTE e ha un padre accademico.** [VERIFICATO che il paper
esiste — 🔴 **NON ho aperto ne' il PDF ne' l'abstract**: Cambridge Core e IDEAS
sono egress-blocked. Le due frasi qui sotto vengono da **snippet di ricerca**]:

> **Ederington & Lee (1995)**, *"The Short-Run Dynamics of the Price Adjustment
> to New Information"*, **Journal of Financial and Quantitative Analysis
> 30(1), 117-134**.
> [INCERTO, da snippet] *"prices adjust in a series of numerous small, but
> rapid, price changes that begin within 10 seconds of the news release and are
> basically completed within 40 seconds"* — *"there is some evidence that
> prices **overreact in the first 40 seconds** but that this is **corrected in
> the second or third minute**."*

**Finestra e regime dichiarati:** futures su tassi e cambi (Deutschemark),
**1988-1992**. ⚠️ **Trentaquattro anni fa**, prima dell'HFT e del trading
elettronico continuo. **Non e' il nostro regime, e non e' il nostro mercato.**

#### 🧱 Perche' e' SCARTO — tre muri, nessuno superabile con la nostra macchina

| muro | numero |
|---|---|
| **FTMO ±2 minuti** | il fade e' **nel minuto 2-3**. Il testo agli atti vieta di aprire **e chiudere** (SL/TP inclusi) in quella finestra. **Non si puo' eseguire su funded Standard.** |
| **Timeframe** | 40 secondi = **1/7 di candela M5**. Non e' un segnale che esista sul nostro grafico minimo. Servirebbe M1 e tick. |
| **Costo** | il fade e' **il ritorno dentro lo spread allargato**. Le fonti sul rilascio concordano: lo spread si moltiplica **per 3-5**. Il movimento da catturare e' dello stesso ordine di grandezza del costo per catturarlo. |

🎯 **Verdetto: LAPIDE.** Da scrivere in `REGISTRO_TEST.md` per non ricercarlo.
E il rilievo che risparmia il prossimo giro: **il "news fade" del web retail
non e' Ederington-Lee.** Il primo e' un pattern discrezionale a occhio
(*"wick che rientra nel range pre-rilascio"*); il secondo e' una misura a 10
secondi. **Chiamarli con lo stesso nome ha fatto perdere tempo a chi c'era
prima di me.**

### 2.2 🕳️ MECCANISMO B — **MOMENTUM CANDLE CONTINUATION** (il colore della prima candela predice le successive)

**Tesi in una riga:** *"la direzione della prima candela dopo il dato e' il
voto del mercato sul dato, e i ritardatari la seguono."*

🔴 **Cercato, e NON esiste niente da leggere.**

| dove ho cercato | esito |
|---|---|
| arXiv API, `all:"macroeconomic news"` (15 risultati) | nessun paper sul segno della prima barra. I 2 piu' vicini: **2508.06788** (Takahashi, S&P E-mini) e **1405.6047** (Rambaldi-Pennesi-Lillo, FX/Hawkes) — modellano **attivita' e impatto**, non una regola direzionale |
| arXiv API, `abs:"news announcement" AND abs:"reversal"` | **0 risultati** |
| Quantpedia | il post-announcement drift che documentano e' **giornaliero su azioni** (post-earnings), non sulla barra intraday |
| ricerca generale mirata | solo **folklore**: pagine broker su "reversal candles" e "news fade", **zero statistiche** |

🟡 **E l'unico numero vero che abbiamo su questo, ce l'abbiamo IN CASA** — ed e'
la lapide **L1**, che oggi va **precisata**:

> [VERIFICATO oggi su `arxiv.org/abs/2605.04004`: **barre da 5 minuti**, MNQ,
> 947 giorni 2021-2025, Mathias Mesfin]
> §4.7 del paper (gia' citato in `REGISTRO_TEST.md` riga 785):
> *"The drift is real in the **first five bars** after the release. That is
> just the news spike itself. **From bar +6 onward**, T-statistics across all
> tested horizons are between **0.14 and 0.69**."* — 993 eventi 2022-2025.

➡️ **[INFERITO, aritmetica dichiarata: 5 barre × 5 minuti]**
**"prime cinque barre" = minuti 0-25. "da barra +6" = dal minuto 30.**
🔴 **La lapide L1 boccia il post-news DAL MINUTO 30. Non boccia i minuti 0-25.**
⚠️ Ma **non e' una promozione**, e va detto con la stessa forza: l'autore
scrive *"That is just the news spike itself"* — attribuisce la deriva **al
salto**, non a una continuazione prendibile **entrando dopo il salto**.

🎯 **Verdetto: NON PROPONIBILE COME CANDIDATO** (nessuna tesi verificabile,
nessuna implementazione), **ma la correzione a L1 va agli atti** perche' nel
repo L1 era citata come chiusura di tutta la famiglia post-news, e **non lo e'**.

### 2.3 🟢 MECCANISMO C — **IL RANGE DELLA CANDELA DELLA NOTIZIA COME LIVELLO**

**Tesi in una riga:** *"la barra del rilascio stampa in 5 minuti il range che
il mercato considera 'giusto' dopo il dato; chi lo rompe DOPO che si e'
chiuso, rompe un livello che tutti guardano."*

🎯 **E questo meccanismo NON va cercato fuori: e' gia' scritto in casa, ed e'
il migliore che abbia letto oggi.** Vedi §3.

---

## 3. 🏠 IL CANDIDATO E' NOSTRO — `ABTG_PostNews.mq5` letto riga per riga

> Regola di casa: si legge il **sorgente**, non la descrizione. Ho letto le
> 473 righe. Ecco la scheda, **compilata con la stessa griglia degli esterni.**

```
NOME            ABTG_PostNews.mq5
FONTE           in casa - mql5/Experts/ (motore del modulo "Post News" del
                corso Alfio Bardolla, spec: prove/POSTNEWS_CORSO_SPEC.md)
AUTORE/DATA     progetto ABTG, v1.00
LICENZA         nostra
RIGHE / INPUT   473 righe / 39 input  <- 🔴 sopra il tetto di ~15

TESI IN UNA RIGA
  "su una conferenza stampa di banca centrale il prezzo esce dal range dei
   primi 10-15 minuti e non ci rientra" (POSTNEWS_CORSO_SPEC.md riga 80)

MECCANICA (letta nel codice, funzione PlaceOrders, righe 176-230)
  ingresso : all'ora d'azione (server) prende hi = max(H[1],H[2]) e
             lo = min(L[1],L[2]) sulle DUE candele M5 gia' chiuse, poi
             BUY STOP a hi + 3 pip  /  SELL STOP a lo - 3 pip
  uscita   : TP 50 pip / SL 25 pip (RR 2,0), chiusura forzata a scadenza,
             chiusura del venerdi' sera
  OCO      : VERO e implementato (OcoCheck, righe 231-256): appena una gamba
             diventa POSIZIONE, cancella ogni pendente dello STESSO MAGIC

GESTIONE RISCHIO
  % dell'equity (LotByRisk su ACCOUNT_BALANCE * InpRiskPercent)
  🔴 InpRiskPercent = 3.0 di default (il corso dice 3%) -> **fuori dai nostri
     0,65%**: da rimettere in riga prima di qualunque confronto di flotta
  size calcolata su InpRiskRefSLpips = 50 = "worst case doppio stop"
     -> 🟢 il DOPPIO RIEMPIMENTO e' gia' dimensionato, non ignorato
  SL VERO (passato a BuyStop/SellStop), max 1 evento/giorno (gPlacedDay)

BANDIERE ROSSE   🟢 NESSUNA. Niente martingala (il lotto non dipende
                 dall'esito precedente), niente griglia (2 ordini, non N),
                 SL reale, niente DLL/WebRequest, niente iCustom esterni,
                 nessun repaint (opera su iHigh/iLow di barre CHIUSE, [1] e [2])

COSTO DI PORTING  ZERO. E' compilato, e' in casa, ha gia' i .set ECB e FOMC.

PUNTEGGIO (0-2)
  [2] semplicita' di REGOLE (2 pendenti, 1 evento/giorno) -- ma 39 input: -1
      sulla superficie di ottimizzazione  -> 1
  [2] il filtro E' il motore: senza l'evento non esiste il trade
      (InpRestrictToNews) -- e' costitutivo, non appiccicato
  [2] tesi di mercato scrivibile
  [2] riempie un buco: NESSUNA delle nostre sedie e' guidata da un EVENTO,
      sono tutte guidate da un ORARIO o da un LIVELLO
  [2] testabile senza riscritture: CSV gia' in casa
  = 9/10 -> PROVA SUBITO (ma vedi §5: il verdetto e' sulla FREQUENZA, non
    sul motore)
```

### 🧱 In ottica prop, questo motore...
- ✅ **e' compatibile FTMO ±2 min** e lo e' **per costruzione**: agisce a
  **news+15 (ECB)** e **news+10 (FOMC)**, cioe' **8 e 13 minuti dopo la fine
  della finestra vietata**. [VERIFICATO su `POSTNEWS_CORSO_SPEC.md` §2.1,
  tabella orari in ora server BCM]
- ⚠️ **ma il TP/SL puo' scattare dentro la finestra dell'evento SUCCESSIVO.**
  Con **43 giorni l'anno a ≥4 eventi ad alto impatto** (misurato nella Ricerca
  1 §2.4) non e' teorico. 🔴 **Un EA news FTMO-compatibile ha bisogno del
  calendario per USCIRE, non solo per entrare.** Oggi il nostro non ce l'ha.
- 🔴 **Frequenza da fondo classifica: 16 eventi/anno** (8 FOMC + 8 ECB). Contro
  il pavimento di casa (**IS ≥150 operazioni**) servirebbero **~9 anni** di
  storico. **E' il vero problema di questo motore, non il rischio.** → §7
- ⚠️ **Rischio giornaliero:** 1 evento/giorno per magic, 2 pendenti, size sul
  doppio stop → **max 1 R per evento**, contro il cap C1 (3,25% = 5 SL vivi).
  🟢 **Profilo buono.** Diventa cattivo solo se si accendono **piu' simboli
  sullo stesso evento** (e' quello che fa Paolo: USDJPY **e** DAX sull'NFP).

---

## 4. 🔬 COSA HO TROVATO FUORI — e perche' non entra

### 4.1 🔴 `Fundamental EA` — Lapiyano, GitHub — **SORGENTE LETTO, 526 righe**

https://github.com/Lapiyano/Fundamental-Trading-EA-MQL5-
[VERIFICATO] MQL5, **9 stelle**, ultimo aggiornamento **19/04/2023**,
**2 commit**, file: `Fundamental EA.mq5` + `.ex5` + `.gitattributes`.
🔴 **NESSUN file LICENSE.** ➡️ **fuori dal vincolo del mandato** (licenza libera
obbligatoria per i promossi) **prima ancora di leggere il codice.**

**L'ho letto lo stesso, per il meccanismo.** Cinque bandiere rosse, tutte con
la riga:

| # | bandiera | prova nel sorgente |
|---|---|---|
| 1 | 🔴 **GRIGLIA di pendenti** | riga 153: `for(int i=0; i<NumOfOrders1;i++)` → riga 158 `trade.BuyStop(..., Ask+((Layer*10*i + OrderPosition1*10)*_Point), ...)`. L'input si chiama letteralmente **`Layer=1.0; //Barcode/Layer Entries (In Pips)`**. Sono **N ordini a distanza crescente**: setaccio §4, **scarto** |
| 2 | 🔴 **stop loss che si annulla o si inverte** | riga 158: SL = `Ask-(200-OrderPosition1*10)*_Point`. Con `OrderPosition=20` pip → `200-200=0` → **SL sul prezzo d'ingresso**. Con `OrderPosition>20` → **valore negativo** → **SL sopra l'entrata su un BUY**. |
| 3 | 🔴 **lotto fisso 0.01** | riga 15 `input double LotSize=0.01;` |
| 4 | 🔴 **niente OCO** | nessuna cancellazione della gamba opposta: cerca `OrderDelete` — non c'e' |
| 5 | 🔴 **nessun calendario: orario a mano in ora LOCALE** | righe 11-12 `input string Time1="14:29:55"; Time2="14:29:56";` confrontate con `TimeLocal()` (riga 71). ⚠️ E' **l'ora del PC**, non del server: regola di casa `CLAUDE.md` — *"ora dei LOG di MT5 ≠ ora del GRAFICO"* |

+ due difetti di ingegneria che da soli basterebbero: `while(...)` **dentro
`OnTick()`** (righe 55, 68, 82) e `OnTick` che ridisegna oggetti grafici a ogni
tick.
🧱 **E su FTMO:** piazza a `14:29:55`, cioe' **5 secondi prima del dato** →
**violazione diretta della finestra ±2 minuti.**

📁 Salvato: `biblioteca/sorgenti/FundamentalNewsStraddle_Lapiyano-NOLICENSE_gh-mql5_2026-09-03.mq5`

**➡️ SCARTO. Ed e' l'UNICO risultato di GitHub su tutto il tema** (`"news
trading" forex ea` → **1 repo**; `forex news straddle strategy` → **0**;
`"economic calendar" backtest strategy python forex` → **0** — con controllo
positivo passato a 2,6k).

### 4.2 🟡 `Calendar-Based Backtesting: an Event-Driven Trading EA` — Code Base **55630** — **SORGENTE LETTO**

https://www.mql5.com/en/code/55630 · [VERIFICATO] **Peter Mueller**
(`Mullerp04`), pubblicato **06/02/2025**, aggiornato **22/12/2025**.
Tre file, **492 righe** (`CalendarRetriever.mq5` 38 · `CalendarFile.mqh` 276 ·
`NewsBacktest.mq5` 178). 🔴 **Licenza NON dichiarata** (`#property copyright
"Muller Peter"`, termini Code Base) → **non promuovibile**.

**Cosa fa davvero, letto nel codice:**
- 🟢 **La parte utile:** `CalendarFile.mqh` serializza il calendario MQL5 in
  file (`Calendar\\USDEvents.txt`, `News.bin`) e li rilegge **dentro il
  tester** → risolve il limite *"il calendario non gira nel tester"*.
- 🔴 **La parte inutile per noi:** l'EA di esempio e' **lo stesso straddle**
  del suo fratello #55064 (gia' sezionato nel dossier del coach Paolo), con
  **gli stessi difetti** e **due in piu' che ho trovato io leggendo**:

| # | difetto | riga |
|---|---|---|
| 1 | 🔴 **piazza 50 secondi PRIMA dell'evento** | `if(CalendarValue.time > TimeTradeServer() + 50) break;` → **dentro la finestra vietata FTMO** |
| 2 | 🔴 **niente OCO** (i due pendenti restano vivi fino a `ExpirySeconds=500`) | — |
| 3 | 🔴 **lotto fisso 0.1** | `input double Volume = 0.1;` |
| 4 | 🔴 **eventi coperti: solo `cpi`, `ppi`, `interest rate decision`** → **NFP e GDP esclusi** | `bool Filtered = StringContains(...)` |
| 5 | 🔴 **`StringContains` con off-by-one** (`if(ct == containing.Length()-1) return true;`) → **fa match su n−1 caratteri** | — |
| 6 | 🔴🔴 **`DeletePending()` cancella TUTTI i pendenti del terminale** — il commento dice *"orders associated with the EA's magic number"*, **ma nel codice non c'e' nessun controllo del magic**: `ordinfo.SelectByIndex(i); trade.OrderDelete(ordinfo.Ticket());` | — |

🚨 **Il difetto #6 e' il piu' pericoloso e nessuna descrizione lo dice:** su un
conto prop con **piu' EA accesi** (che e' esattamente la rotta di Claudio —
*"accendere N EA a DD basso col guardiano"*), questo EA **cancellerebbe i
pendenti di MaxMinNotte e delle aperture**. 🔴 **Da non far girare mai in
parallelo alla flotta, nemmeno in demo.**

📁 Salvato: `biblioteca/sorgenti/CalendarBacktest_Mullerp04_mql5code55630_NOLICENSE/`

**➡️ SCARTO come motore. 🟡 Segnalato come ATTREZZO** (e non ci serve: il
nostro `ABTG_PostNews` legge gia' un CSV, `LoadNews()` riga 110).

### 4.3 🟡 Articolo MQL5 **22580** — *News Filtering with MT5 Economic Calendar and CSV Fallback*

[VERIFICATO] **Ushana Kevin Iorkumbul**, **28/05/2026**. Modulo `NewsFilter.mqh`
+ script `NewsEventLogger`. Input: `InpPreEventMins=30`, `InpPostEventMins=30`,
`InpFilterHigh=true`, `InpFilterMedium=false`, `InpUseCsvFallback`, `InpCsvFileName`.
Riga che serve agli atti: *"None work in the Strategy Tester because the tester
has no server connection during historical replay."*
➡️ **E' un FILTRO che ESCLUDE le news** — l'opposto del nostro bersaglio.
🟢 Ma conferma su fonte indipendente il vincolo strutturale, e conferma che
**la strada CSV e' la strada giusta** (quella che abbiamo gia' preso).

### 4.4 🔴 TradingView — **fonte strutturalmente inadatta, e ora e' MISURATO**

Aperto `High-Impact News Events with ALERT` (TJalam, **13/02/2025**,
open-source, **nessuna licenza dichiarata**): [VERIFICATO sulla pagina] e' un
**indicatore**, *"does not execute trades automatically"*, e per sapere quando
esce la notizia usa **metodi interni** perche' *"TradingView doesn't support
external API connections"*.

➡️ **[INFERITO, ma robusto]** Pine **non ha un calendario economico con
timestamp di rilascio al minuto**: qualunque script "news" o **hardcoda le
date**, o **disegna finestre a occhio**. **Non esiste su TradingView una
STRATEGY news-driven backtestabile.** 🔴 **Fonte chiusa per questo tema** — e
va scritto, perche' e' la terza caccia che la interroga.

### 4.5 📋 Le altre implementazioni — **gia' sezionate ieri, non le rifaccio**

`report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md` ha gia' letto e
bocciato: Code Base **55064** (lotto fisso, niente OCO, NFP non coperto),
articolo **16752** (lotto fisso, TP=0, niente OCO), Code Base **11003** (MT4,
da ricompilare a mano), e i 3 prodotti Market a pagamento.
**Regola di casa: cio' che e' gia' setacciato non si ricontrolla.**

---

## 5. 📊 LA TABELLA DEGLI SCARTI — una riga di motivo a testa

| candidato | fonte | licenza | FTMO ±2 min | motivo dello scarto |
|---|---|---|---|---|
| `Fundamental EA` | GitHub, Lapiyano | 🔴 **nessuna** | 🔴 **VIOLA** (piazza a −5 s) | griglia "Barcode/Layer", SL che si annulla o si inverte, lotto fisso, niente OCO, ora locale a mano |
| `Calendar-Based Backtesting` | Code Base 55630 | 🔴 non dichiarata | 🔴 **VIOLA** (piazza a −50 s) | lotto fisso 0.1, niente OCO, NFP escluso, `StringContains` bacato, **`DeletePending()` senza filtro magic** |
| `Forex news events reaction EA` | Code Base 55064 | 🔴 non dichiarata | 🔴 **VIOLA** (sul tick dell'evento) | gia' bocciato ieri: lotto fisso, niente OCO, filtro importanza assente nel ramo che trada |
| Articolo 16752 | MQL5 | 🔴 termini MQL5 | 🔴 **VIOLA** | lotto fisso, TP=0, niente OCO |
| `STRADDLE NEWS` 11003 | Code Base | 🔴 non dichiarata | 🔴 **VIOLA** | **MT4**, ricompilazione a mano prima di ogni notizia |
| `NewsFilter.mqh` (art. 22580) | MQL5 | 🔴 termini MQL5 | ✅ n/a | **e' un filtro che esclude le news**: bersaglio opposto |
| `High-Impact News Events with ALERT` | TradingView | 🔴 nessuna | ✅ n/a | **indicatore**, non strategia; nessun calendario reale in Pine |
| **spike & fade** (Ederington-Lee) | letteratura | — | 🔴 **VIOLA per definizione** (il fade e' nel minuto 2-3) | orizzonte **40 secondi**, sotto M5, dentro la finestra vietata, campione **1988-1992** |
| **momentum candle continuation** | — | — | ✅ n/a | 🕳️ **nessuna letteratura, nessuna implementazione**: non e' un meccanismo, e' un'impressione |

📌 **Motivi ricorrenti, in ordine di frequenza:** (1) **lotto fisso** 5 volte
su 5 sorgenti letti · (2) **niente OCO** 4 su 5 · (3) **piazzamento prima del
rilascio** 5 su 5 → **incompatibilita' FTMO al 100% del campione esterno** ·
(4) **nessuna licenza libera** 8 su 8.

---

## 6. 🕳️ IL BUCO DI PORTAFOGLIO — e per una volta e' vero

Letti `report/ROTTA_PROP.md`, `REGISTRO_TEST.md` (917 righe) e
`prove/CELLE_REGIME.txt`. **Le nostre sedie sono guidate da due cose sole:**

| guida | sedie |
|---|---|
| **un ORARIO** | DAX Apertura, MaxMinNotte, LondonFx, NY Retest, Sonda Orologio |
| **un LIVELLO / un indicatore** | SupRev, SuperWave, BreakinBox, CRT, VwapRevert, PTE |
| 🎯 **un EVENTO ESOGENO** | **solo `ABTG_PostNews`** (2 sedie: EURUSD, EURJPY) |

➡️ **La famiglia "evento" e' l'unica del parco che non condivide il fattore di
rischio con nessun'altra.** Il 13:30 e il 19:00 server non sono l'orario di
nessun'altra nostra sedia (Ricerca 1 §2.3). **Per una prop, dove il DD e' UNO,
questa e' la definizione operativa di scorrelazione.**
🔴 **Ed e' anche la famiglia con la frequenza piu' bassa del parco: 16/anno.**
Non e' una contraddizione, e' il prezzo: **la scorrelazione qui si paga in
occasioni.**

---

## 7. 📐 LA SPEC DEL FILE PROVA — quello che il primo test deve chiedere

> 🔴 **Non scrivo il file prova.** Manca `@DAQUANDO`, e la regola di casa e'
> netta: **la data d'inizio storico si MISURA** con `scarica_storico.ps1`, non
> si ipotizza (sugli indici il driver diceva 2024.01.01 e i dati partivano dal
> 26/09/2024). Non ho MT5. **Lascio la spec, non il file.**

### 🎯 La domanda, una sola
> **"Il motore che gia' abbiamo cambia comportamento se gli si dà un evento
> DIVERSO dalla conferenza stampa — cioe' un DATO (NFP/CPI) invece di un
> DISCORSO?"**

E' la domanda giusta perche' separa **il motore** dal **segnale**, che e'
l'ablazione che il progetto sa fare (§S1 di R116) — e perche' se la risposta
e' "no, va uguale", allora **il motore e' l'edge e la famiglia si allarga da
16 a 40 eventi l'anno**; se e' "va peggio", **la conferenza stampa e' speciale
e lo sappiamo**, il che e' comunque un'informazione che non abbiamo.

### 📋 Bozza di spec (da completare con la misura, NON da lanciare)

```
# IPOTESI: il motore range-M5 + OCO di ABTG_PostNews non dipende dal TIPO di
#          evento, ma solo dal fatto che ci sia un rilascio programmato.
#          Se e' vero, NFP e CPI USA (24 eventi/anno, stessa ora 13:30 server,
#          mai lo stesso giorno) raddoppiano la frequenza a codice invariato.
#
# CRITERI DI ACCETTAZIONE (da congelare PRIMA dei numeri, non ancora firmati):
#   - le celle "dato" (NFP/CPI) devono avere segno CONCORDE con le celle
#     "discorso" (FOMC/ECB) su IS e OOS: segno opposto = conflitto dichiarato,
#     nessuna proposta
#   - DD <= 8,0%  ·  peggior giornata >= -4,0% (oltre, il Guardian avrebbe
#     messo in pausa: backtest non riproducibile)
#   - n: 🔴 CANCELLO ARITMETICO DA GUARDARE PRIMA DI TUTTO -- 40 eventi/anno
#     significa che i 150 trade del muro R59 arrivano in ~4 anni. Se la
#     profondita' misurata non li da', il MERITO resta sospeso per costruzione
#     e il round misura solo il RISCHIO (valvola R59 / emendamento B).
#
@SIMBOLO   EURUSD  (evento USD sulla gamba USD; il DAX si aggiunge solo dopo
                    aver chiarito se un evento USD "targeta" un indice -- vedi
                    CACCIA_NOTIZIE_TASSONOMIA_2026-09-03.md §6)
@PERIODO   M5
@DAQUANDO  <<< VUOTO: DA MISURARE con scarica_storico.ps1. NON INVENTARE. >>>

# --- celle: 2 eventi (controllo) x 2 eventi nuovi, motore IDENTICO ---
InpActionHour=?||...    <- ⚠️ ORA SERVER. NFP/CPI escono 13:30 server:
InpActionMin=?||...        news+10 => 13:40  |  news+15 => 13:45
InpNewsTitleMatch=...   <- "Non-Farm Employment Change" | "CPI" | "FOMC" | "ECB"
InpNewsCurrencies=USD||...
InpNewsMinImpact=3
InpRiskPercent=0.65     <- 🔴 NON 3.0: il default del corso va rimesso in riga
InpRestrictToNews=true
```

### ⚠️ Le tre cose da NON dimenticare in quel round
1. **`InpRiskPercent` di default e' 3,0** (il corso). **Va messo a 0,65** o i
   numeri non sono confrontabili con nessun'altra sedia.
2. **Il CSV `abtg_news.csv` va rigenerato** con le righe NFP/CPI: oggi il
   filtro e' `InpNewsTitleMatch="ECB"`. E attenzione — **NFP, Unemployment Rate
   e Average Hourly Earnings escono nello STESSO MINUTO**: se il CSV ne
   contiene tre e il match e' largo, il motore vede **tre eventi** dove ce n'e'
   **uno solo** (Ricerca 1 §3.B).
3. 🧱 **Il cancello FTMO va verificato sul minuto, non sulla famiglia:**
   news+10 = **8 minuti dopo la fine della finestra vietata** → ✅. Ma va
   guardata anche l'**uscita**: SL/TP che scatta dentro la finestra ±2 min di
   un evento successivo **e' un breach**. Con **43 giorni/anno a ≥4 eventi**,
   e' da misurare, non da assumere.

### 🔬 E l'ablazione gia' pensabile
Il corso stesso dice due cose opposte e mai spiegate
(`POSTNEWS_CORSO_SPEC.md` §3.2):
- **ECB**: si **butta via** la candela della notizia (range = 14:50+14:55)
- **FOMC**: si **tiene** la candela della notizia (range = 20:30+20:35)

🎯 **E' un'ablazione A/B perfetta, a costo zero, gia' scritta nel motore**
(basta spostare `InpActionMin` di 5 minuti): *"la candela del rilascio va
tenuta o buttata?"* — nessuna delle due versioni ha mai avuto un numero.

---

## 8. 🚧 COSA NON HO POTUTO VEDERE

- 🔴 **Ederington & Lee (1995) nel testo integrale.** Cambridge Core e IDEAS
  bloccati: le due frasi in §2.1 vengono da **snippet**, e sono marcate
  [INCERTO]. **La lapide regge lo stesso** (l'orizzonte a 40 secondi e' sotto
  M5 comunque, da qualunque fonte lo si legga), ma **se un giorno si volesse
  costruirci sopra, il paper va letto.**
- 🔴 **Forex Factory** — 403 su calendario e thread. Il mandato la citava fra
  le fonti: **non e' stata raggiunta, ne' oggi ne' ieri.**
- 🔴 **SSRN** — 403 (la 14ª volta di fila registrata nel repo).
- 🟡 **arXiv 1405.6047** (Rambaldi-Pennesi-Lillo, FX + news + Hawkes) —
  **trovato, non aperto**: modella l'intensita' dell'attivita', non una regola
  d'ingresso. Se un giorno servisse la **forma temporale** del picco di
  attivita' dopo un dato, e' li' che si va.
- 🟡 **Il codice completo dell'articolo MQL5 22580** — letta la scheda, non il
  sorgente. Non serviva: e' un filtro, bersaglio opposto.

---

## 9. 🔗 FONTI EFFETTIVAMENTE APERTE (03/09/2026)

**Fuori:**
- https://github.com/Lapiyano/Fundamental-Trading-EA-MQL5- — **sorgente letto (526 righe)**
- https://raw.githubusercontent.com/Lapiyano/Fundamental-Trading-EA-MQL5-/main/Fundamental%20EA.mq5 — HTTP 200, scaricato
- https://www.mql5.com/en/code/55630 — pagina + **ZIP scaricato e 3 file letti (492 righe)**
- https://www.mql5.com/en/articles/22580 — Iorkumbul, 28/05/2026
- https://www.mql5.com/en/book/advanced/calendar/calendar_trading — limite tester
- https://www.tradingview.com/script/lfSf2GOZ-High-Impact-News-Events-with-ALERT/ — TJalam, 13/02/2025
- https://arxiv.org/abs/2605.04004 — Mesfin, **barre 5 minuti** (il dato che corregge L1)
- http://export.arxiv.org/api/query — 3 interrogazioni + controllo positivo
- https://github.com/search?q=mql5 (2,6k, controllo positivo) · `?q="news trading" forex ea` (1) · `?q=forex news straddle strategy` (0) · `?q=forexfactory calendar scraper` (13)

**In casa:**
- `mql5/Experts/ABTG_PostNews.mq5` — **473 righe, lette**
- `backtest_pipeline/prove/POSTNEWS_CORSO_SPEC.md`
- `backtest_pipeline/REGISTRO_TEST.md` (917 righe, lette per intero)
- `report/coach_paolo/NEWS_BREAKOUT_OCO_NFP_2026-09-03.md`
- `docs/REGOLAMENTO_FTMO_2026-08.md` §4

**Sorgenti archiviati oggi:**
- `biblioteca/sorgenti/FundamentalNewsStraddle_Lapiyano-NOLICENSE_gh-mql5_2026-09-03.mq5`
- `biblioteca/sorgenti/CalendarBacktest_Mullerp04_mql5code55630_NOLICENSE/` (3 file)

**Fonti NULLE dichiarate:** forexfactory.com (403) · ssrn.com (403) ·
cambridge.org · sciencedirect.com · researchgate.net · semanticscholar.org ·
nber.org · federalreserve.gov · ecb.europa.eu · skidmore.edu · investing.com ·
ftmo.com
