# 🏹 CACCIA M5/M15 — LOTTO INDICI (DAX / Dow / Nasdaq) — 25/08/2026

**Mandato di Claudio (via sessione principale):** _"Dobbiamo avere più strategie
su TF 5 min e 15 min. Ci servono per la challenge."_ Obiettivo dichiarato:
**più frequenza di operazioni per accorciare i giorni di passaggio** (R106:
mediana **16 giorni** con la flotta attuale, **22** con la squadra B ×0,74).

**Clausola di ingaggio (SECONDA CACCIA):** meccanismi **ALTERNATIVI** sulla
stessa inefficienza. Il capitolo **BREAKOUT M5 D'APERTURA è CHIUSO** dal
26.07.26 (`REGISTRO_TEST.md` §2): _"Non costruire altri v2 M5."_

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 fonti sottoposte a controllo positivo (3 vive, 3 nulle), 1.593 titoli
> del Code Base ricrawlati, 399 strategie TradingView uniche raccolte per tag,
> **20 sorgenti letti riga per riga (17 Pine + 3 `.mq5`)**, arrivano al
> sorgente 20 candidati, ne PROMUOVO 3 (di cui 1 in coda).**
>
> 🟢 **E la scoperta che vale più dei candidati è tecnica: TRADINGVIEW SI
> LEGGE.** Per quattro cacce di fila (16/08, 19/08, 21/08, 22/08, 23/08) il
> dominio è stato dichiarato NULLO perché l'HTML delle pagine script non
> contiene il Pine. **Oggi ho trovato il canale che funziona** e ho scaricato
> **17 sorgenti Pine completi**. Dettaglio operativo in §1-bis: è riusabile da
> chiunque, subito, e riapre la fonte più grande che avevamo chiuso.
>
> 🔴 **E la risposta scomoda resta la stessa del 23/08: il MQL5 Code Base non
> ha NIENTE per noi su questo bersaglio.** Su 1.058 titoli veri (tolti i 535
> involucri `Exp_*`): `vwap` → **ZERO**, `dax|de40|ger30` → **ZERO**,
> `retest|pullback` → **UNO**, e i 3 titoli M5/M15 mai setacciati che ho
> aperto oggi cadono tutti e tre su **lotto fisso** e/o **stop virtuale**.

---

## 0. 📕 LA LISTA DEI CADUTI — il metro di questa caccia

Riletta PRIMA di uscire (`REGISTRO_TEST.md` intero, referti R42/R45/R95/R97/
R98/R101, `SETACCIO_MANUALE.md`, le cacce del 16/08 A-L, 19/08, 21/08 e i due
sweep del 22-23/08). È il criterio di scarto, non un contorno.

| caduto | dove | meccanismo | verdetto misurato |
|---|---|---|---|
| **capitolo BREAKOUT M5 APERTURA** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB | **CHIUSO 26.07.26** a tick reali. In OHLC davano **+129k finti sul DAX**; a tick reali: morti |
| **R42 — FADE degli estremi del range d'apertura** | `REFERTO_ROUND42_FADE.md` | fade sugli estremi del box 15'/35' | **0/24 IS e 0/24 OOS**, PF 0,50-0,93. _"è morto il MOTORE, non la gestione"_ |
| **R45 — ORB di sessione (Londra)** | `REFERTO_ROUND45_LONDRA.md` | range 15/30 min + conferma su chiusura M5 + corpo 50% + EMA 9/21 | **0 celle positive su 48** |
| **R12 — ORB + EMA200 + VOLUMI sul Nasdaq** | archivio | breakout filtrato dai volumi | **48 su 48 negative OOS** |
| **R97 — stop all'estremo opposto sull'ORB Nasdaq** | `R97_REFERTO.md` | gestione nuova su motore ORB | **0/4** |
| **R98 — INTRADAY MOMENTUM (Gao et al.) su NASUSD** | `R98_REFERTO.md` | segno dei primi 30' → operazione negli ultimi 30' | **0/6**, e **cancello zero S0 matematicamente impossibile**: lordo medio **−0,31 punti indice** su 410 operazioni |
| **R95 — SWEEP + RECLAIM su EURJPY** | `R95_REFERTO.md` | sweep di swing + rientro, M30→H4 | **30 su 30 in perdita**, PF 0,65-0,80, DD 27-99,9%. _"NON DICE che lo sweep sia morto ovunque"_ |
| **R101 — ablazione dei filtri su Dow e DAX** | `R101_REFERTO.md` | 9 filtri accesi uno alla volta sulle sedie vive | **VWAP di sessione (gradino 07): incoerente fra Dow e DAX → niente candidato.** Solo `02_volumi` sopravvive a G1+G2+G3 |
| **famiglia ORB in generale** | `SETACCIO_MANUALE.md` | ~**210 celle a tick reali** su 4 mercati | _"il breakout puro al tocco è morto ovunque"_ |
| **aperture su FTSE / Dow / Nasdaq** | `REGISTRO_TEST.md` | breakout M5 d'apertura su altri indici | tutti morti. _"è un'anomalia del DAX"_ |

### 📌 Le tre frasi dei nostri referti che ho usato come bussola (citate)

1. **R42:** _"L'unica cosa che ha sempre pagato è il **RETEST** — entrare sul
   RITORNO al livello DOPO la rottura confermata"_.
2. **R95:** _"NON DICE che lo sweep di liquidità sia morto ovunque"_ — ma
   30/30 in perdita su un cross è un fatto, e chiude il filone JPY.
3. **`ROBUSTEZZA.md` / §5B del mandato:** filtro **aggiunto dopo** a un motore
   già tarato = **0 successi su 5**; filtro che **È** la strategia dall'inizio
   = **30 celle su 30** (`ABTG_EMA200` Dow, R29). **È il criterio numero uno
   di questa caccia**, e i tre promossi lo rispettano tutti e tre.

---

## 0-bis. ⚖️ I CRITERI CONGELATI PRIMA DEI NUMERI

Scritti qui **prima** di aver guardato un solo risultato d'autore. Valgono per
ogni candidato di questo dossier.

**C1 — IL COSTO È IL CRITERIO, non un contorno.**
Su M5/M15 lo spread mangia l'edge prima della strategia. Ogni candidato
dichiara **trade/giorno stimati** e **guadagno medio atteso per trade in punti
indice**. Se il take medio è sotto **~3× lo spread tipico**, si scarta a
tavolino, senza accendere il tester.
📏 Il metro: `R98_CRITERI.md` §3.2 — _"lordo medio/operazione ≥ 3× lo spread
medio della fascia"_; spread BCM sugli indici dichiarato **1-2 punti indice**
[FONTE: `R98_CRITERI.md` riga 116 — **[INCERTO]**: non è una misura nostra
ripetibile, va rimisurata con uno script sul simbolo].
👉 **Soglia operativa di questa caccia: take medio atteso ≥ 4-6 punti indice.**

**C2 — OHLC 1-min SU M5/M15 INGANNA.** Misurato in casa: `+129k finti sul
DAX` (`REGISTRO_TEST.md` §2). Ogni candidato di questo dossier è marcato
**validazione SOLO a tick reali**. Lo screening OHLC vale per contare i trade
e leggere la frequenza, **mai** per il segno.

**C3 — NIENTE griglie, martingale, recovery, hedging, lotto fisso, stop
virtuale, repaint.** Il §4 del mandato non si ammorbidisce.

**C4 — CONVERSIONE PUNTI.** Su U30USD e NASUSD **1 punto indice = 100 punti
MT5** (misurato in R97 con due misure indipendenti concordi). Ogni numero in
"punti" di questo dossier è in **punti indice**, e lo dico ogni volta.

**C5 — CAMPIONE.** Indici a BCM: storico dal **2024.09.26** (misurato,
`REFERTO_SONDA_STORICO_17-08.md`, stato `COMPLETO` = il broker non ha altro)
= ~**450 sedute**. Emendamento della Finestra §A: servono **≥150 operazioni
IS**. 👉 **Un candidato che spara meno di ~1 volta a settimana su un indice
non è misurabile da noi.** Su M5/M15 questo di solito non morde — ed è
esattamente il motivo per cui il mandato di Claudio ha senso: *M5/M15 è la
sola fascia dove abbiamo campione in abbondanza.*

**C6 — MURO PROP GIORNALIERO.** Più frequenza = più rischio di concentrazione
in una sola seduta. Ogni promosso porta la sua riga prop, e ogni promosso
**deve** avere un cap di operazioni al giorno fra i suoi input (`METRO_PROP`:
−5.000 € su 100k butta fuori anche col totale intatto).

---

## 1. 📡 CONTROLLO POSITIVO — misurato oggi, fonte per fonte

| fonte | HTTP | bersaglio noto verificato oggi | esito |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | **200** | su `/en/code/68951` leggo titolo `Liquidity Sweep H4 - M15`, autore `OsmarSandovalEspinosa`, data `2026.03.23`, **`UserDownloads:2383`** (erano 2.383 oggi contro il valore del 19/08 sullo stesso id). 40 pagine → **1.593 id+titolo unici** | 🟢 **PASSA in pieno** — e `/en/code/download/<id>` restituisce lo ZIP col `.mq5` (verificato su 3 id) |
| **TradingView** | **200** | pagina tag `/scripts/vwap/` rende **24 link `/script/` + titoli** nell'HTML; pagina script rende `<title>` con nome+autore+tipo; **e il PINE si scarica** (§1-bis) | 🟢 **PASSA — RIAPERTA DOPO 5 CACCE** |
| **arXiv API** (`https://export.arxiv.org`) | **200** | `cat:q-fin.TR` recenti → titoli e `<published>` veri (24/08/2026) | 🟢 **PASSA** (⚠️ solo `https://`: `http://` risponde 301 e 0 entry) |
| **Quantpedia** (con `-L` + UA) | **200** | `strategies/turn-of-the-month-in-equity-indexes` → 221 KB di testo pieno | 🟢 **PASSA** (ma la ricerca interna non è enumerabile) |
| **GitHub** ricerca web + API | **403** | — | 🔴 **NULLA** — quinta caccia di fila |
| **SSRN** | **403** (Cloudflare) | — | 🔴 **NULLA** — quinta caccia di fila |
| **Forex Factory** `/forum/71-trading-systems` | **403** | — | 🔴 **NULLA** — quinta caccia di fila |
| **alexandria.unisg.ch · researchgate · cxoadvisory · substack · quantitativo** | **CONNECT tunnel 403 dal proxy** | — | 🔴 **EGRESS BLOCCATO**. Sono i mirror del paper Zarattini: **il PDF NON l'ho letto** (§5) |

### 1-bis. 🔓 COME SI LEGGE IL PINE — la scoperta riusabile

Tre passi, e nessuno richiede autenticazione:

1. la pagina tag `https://www.tradingview.com/scripts/<tag>/?script_type=strategies`
   (paginata con `/page-N/`) restituisce nell'HTML **link + titoli** degli
   script — filtrando per `data-qa-id="ui-lib-card-link-title"`;
2. la pagina del singolo script `https://www.tradingview.com/script/<slug>/`
   **non contiene il Pine**, ma contiene **l'identificatore `PUB;<hash a 32
   cifre esadecimali>`**;
3. `https://pine-facade.tradingview.com/pine-facade/get/PUB;<hash>/last`
   restituisce un **JSON col campo `source`: il Pine completo**, più
   `scriptName`, `created`, `scriptAccess` (`open_no_auth` = open source).

⚠️ **Attenzione a non ripetere il mio primo errore**: usare lo *slug* corto
(`PUB;OkbSIHvu`) dà `404 Script is not found`. **Serve l'hash a 32 cifre.**

⚠️ **E il limite resta quello del mandato §3D, che NON è tecnico:** Pine →
MQL5 **non è un porting, è una riscrittura**; lo Strategy Tester di TradingView
è **ottimista di natura**; e i numeri mostrati dagli autori sono su **una sola
sequenza, senza costi**. **Non ho usato nessun numero d'autore in nessun
punteggio di questo dossier.**

### Cosa ho sfogliato dove ha funzionato

- **Code Base:** 40 pagine di listato → **1.593 titoli unici** (erano 1.591 il
  23/08 e 1.595 il 22/08: stesso catalogo). Tolti **535 involucri `Exp_*`**
  restano **1.058 titoli veri**, ritagliati con filtri **specifici di questa
  caccia**: `vwap` · `fade|mean.?rev|reversion|revert|counter.?trend|
  contrarian|exhaust` · `sweep|liquidit|stop.?hunt|smc|order.?block|fvg` ·
  `volume|delta|cvd|footprint|obv` · `intraday|session|scalp|m5|m15|5.?min|
  15.?min` · `gap` · `retest|pullback|throwback` · `pivot|range|bollinger|
  keltner|donchian|squeeze` · `opening|orb|eod|last.?hour|first.?hour` ·
  `index|dax|de40|ger30|us30|dow|nas100|nasdaq|spx|us500|ustec`.
  **3 sorgenti `.mq5` nuovi scaricati e letti** (70796, 20545, 17184): tutti e
  tre scartati, §4.
- **TradingView:** **17 tag × 2-4 pagine** con filtro `script_type=strategies`
  → **399 strategie uniche** con titolo e autore (`meanreversion, vwap, openingrange,
  liquidity, volume, reversal, intraday, session, daytrading, pullback,
  marketprofile, supportandresistance, futures, nasdaq, dax, indices,
  orderflow`). **17 sorgenti Pine scaricati e letti riga per riga.**
- **arXiv:** 3 query (`"intraday mean reversion"`, `VWAP AND "trading
  strategy"`, `intraday AND "index futures" AND reversal`). Il listato
  `q-fin.TR` recente è **di nuovo tutto microstruttura ed esecuzione**
  (parsing di tick giapponesi, matrici di rebalancing, CVaR di esecuzione):
  **zero strategie intraday su indici**. Terza caccia di fila con lo stesso
  esito — **lo scrivo perché smetta di essere una speranza**.

---

## 2. 🟢 I PROMOSSI — tre, in ordine

### 🥇 P1 — `VWAP Mean Reversion Strategy` — **la VWAP come MOTORE, non come filtro**

```
NOME            VWAP Mean Reversion Strategy
FONTE / URL     https://www.tradingview.com/script/YBqnzqDK-VWAP-Mean-Reversion-Strategy/
                [rango: SORGENTE PINE LETTO RIGA PER RIGA]
AUTORE / DATA   sumbloke077 — creato 2026-04-02, versione 2.0   [VERIFICATO
                nel JSON pine-facade: created 2026-04-02T12:30:28Z, kind
                "strategy", scriptAccess "open_no_auth"]
LICENZA         ⚠️ [INCERTO] — nessuna intestazione di licenza nel sorgente
                (il file comincia direttamente da //@version=5). TradingView
                lo classifica open_no_auth = sorgente pubblico. L'attribuzione
                a sumbloke077 va ripetuta in testa a qualunque .mq5 derivato.
RIGHE / INPUT   247 righe · 22 input.() contati nel sorgente
COPIA IN CASA   biblioteca/sorgenti/VwapMeanReversion_sumbloke077_tvYBqnzqDK_2026-08-25.pine
```

**TESI IN UNA RIGA**
> _"Dentro la sessione la VWAP è il prezzo che il flusso istituzionale ha
> davvero pagato: quando il prezzo si allontana oltre una deviazione standard
> E lì dentro stampa una candela di rifiuto all'estremo delle ultime 20 barre,
> chi ha inseguito è in perdita e il ritorno verso la VWAP è il suo costo."_

**MECCANICA — in tre righe, letta nel sorgente**
1. **La banda (il motore):** VWAP di sessione calcolata a mano —
   `cumPV/cumVol` su `hlc3`, **azzerata al cambio giorno** — più la deviazione
   standard volume-pesata (`cumPV2/cumVol − vwap²`), bande a ±1σ.
   `priceBelowLower = close[1] < lowerBand` (**barra chiusa**, mai la corrente).
2. **Il grilletto:** la barra **precedente** è un `hammer`/`doji` che ha
   toccato il minimo delle ultime 20 (`low <= twentyLow`) **e** la barra
   corrente chiude nel **30% alto del proprio range** (`closePos >= 0,70`)
   **e** è `bullishEngulfing` o `higherLowAndCloseAbovehigh`, **e** il corpo
   sta sotto `1,5 × ATR` (filtro anti-candelone). Specchio esatto per lo short.
3. **L'uscita:** ordine **stop** sopra il massimo del setup + buffer ATR,
   **annullato dopo 2 barre** se non riempie; SL al minimo del setup − buffer,
   con **pavimento a `0,2 × ATR`**; TP a **2R**.

**🔍 PERCHÉ NON È UN CADUTO — punto per punto**

| | i caduti | questo |
|---|---|---|
| **da dove nasce il livello** | high/low del box **15-30 minuti** attorno all'apertura (R42, R45, Live5m) | **banda ±1σ attorno alla VWAP di sessione** + estremo di 20 barre mobili. Nessun box, nessun orario d'ingresso |
| **verso dove entra** | breakout: **con** la rottura (capitolo chiuso). R42: **contro**, ma **sull'estremo secco** | **contro**, ma solo dopo che una **seconda barra ha confermato il rifiuto** — famiglia RETEST/RECLAIM, quella che R42 indica come _"l'unica che ha sempre pagato"_ |
| **la VWAP** | R101 gradino 07: VWAP come **FILTRO DIREZIONALE** appiccicato al motore aperture (`InpUseVwapFilter`) → **incoerente fra Dow e DAX, bocciato** | qui la VWAP **È il motore**: senza banda non c'è segnale. È la differenza misurata **0/5 contro 30/30** del §5B |
| **il calendario** | la strategia **È** un orario | **zero input di orario nel sorgente** (l'unica ancora temporale è il reset giornaliero della VWAP) |

> ✅ **E c'è la conferma incrociata, che vale più della mia opinione:**
> `ANALISI_LIVE_EMILIANO_2026-08-24.md` registra che il corso usa la VWAP
> **giornaliera** per l'intraday e che il nostro gradino 07 (VWAP di sessione
> come filtro) è **già misurato non-candidato**. **Nessuno, né dentro né
> fuori, ha mai misurato la VWAP come MOTORE su un nostro indice.** Questo è
> il buco, ed è scritto agli atti.

**BANDIERE ROSSE §4: NESSUNA.**
✅ **rischio in percentuale** (`riskPerc` default 1%, `qty = equity*risk/risk_
points`) · ✅ **SL vero** al broker via `strategy.exit(stop=...)` · ✅
**simmetrico long+short dallo stesso codice** · ✅ **decide su barre chiuse**
(`close[1]`, `bearishSetupBar[1]`) → **niente repaint, niente look-ahead** ·
✅ **una posizione per lato**, ordine pendente con scadenza a 2 barre ·
❌ niente martingala, griglia, hedge, `request.security` senza `lookahead_off`.

**🎁 E c'è un pezzo che è meglio di quello che facciamo noi:**
```pine
spreadPoints = input.float(0.09, "Broker Spread (in price units)")
effectiveLongEntry := ... + closeEntryBuffer + spreadPoints
strategy.exit("Long Exit", stop = longStopStored - spreadPoints,
                           limit = longTargetStored - spreadPoints)
```
**Lo spread è modellato DENTRO i prezzi di ingresso E di uscita**, non lasciato
al simulatore. È esattamente la lezione R55 (_"lo spread va misurato in % dello
stop"_) applicata a monte. **Da tenere nella riscrittura.**

**🔧 COSA TERREI / COSA RIFAREI** (§5F: motore e gestione, separati)

**DA TENERE (il motore, ~40 righe):** VWAP di sessione volume-pesata con reset
giornaliero · bande ±kσ · estremo di N barre mobili · candela di rifiuto +
**barra di conferma** · filtro anti-candelone in ATR · ordine pendente con
scadenza a 2 barre · modellazione esplicita dello spread.

**DA RIFARE (la gestione — la parte che sappiamo fare):**

| difetto | perché morde | cosa ci mettiamo |
|---|---|---|
| TP secco a **2R**, nessun parziale | è la gestione più povera del file | **parziale 1R + breakeven + runner 2R**, la gestione delle nostre DAX/Dow |
| **22 input** contro il tetto ~15 | troppe manopole da girare verso il passato | sfrondare a mano: la geometria della candela (`bodyPercentSS`, i due `wickMultiple`, `dojiBodyPercent`, `closePercent`) si **pinna ai default** e non entra nello sweep |
| `riskPerc` a **1,0** | in campo giriamo a **0,65%** | `InpRiskPercent = 0.65` e la conversione ×0,65 dichiarata sui DD |
| **nessun cap di operazioni al giorno** | C6: il muro giornaliero prop | `InpMaxTradesPerDay` (parte a 2), input nuovo |
| **nessun filtro di spread runtime** | R55: 1,5 punti indice di slippage sfondano il 10% sull'ORB | spread **in % dello stop**, il nostro standard |
| `entryType = "Close of Confirmation"` usa `strategy.entry(..., limit=...)` per un ingresso **peggiorativo** | in Pine un `limit` sopra il prezzo riempie subito; in MT5 sarebbe un `BUY LIMIT` che **non riempie mai**. **Trappola di traduzione, non difetto dell'autore** | nella riscrittura si usa **solo** il ramo `"Stop"` (BUY STOP sopra il massimo del setup), che è ciò che l'autore intende |
| `volume` = **tick volume** su MT5 | la VWAP diventa tick-volume-pesata | ⚠️ **[INCERTO, da misurare]**: verificare se BCM espone `SYMBOL_VOLUME_REAL` sugli indici. Il nostro `VwapBias()` già usa `tick_volume` |

**💰 COSTO DI PORTING — ed è basso, per un motivo preciso**
**La VWAP di sessione ce l'abbiamo già scritta in MQL5.**
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`, funzione `VwapBias()` righe
**1626-1647** [VERIFICATO nel sorgente]: `CopyRates` su `InpVwapTF`, `hlc3`,
`tick_volume`, ancoraggio al giorno corrente, **e parte da `i=1`, cioè esclude
la barra in formazione**. Manca solo la σ volume-pesata, che è tre righe.
👉 **Stima: 5-7 ore** per un `ABTG_VwapRevert.mq5` completo di `OnTester`,
magic, parziali e cap giornaliero. **Non è una traduzione da zero.**

**📊 COSTO-SOPRAVVIVENZA (C1) — il conto fatto prima del tester**

| | stima | fonte della stima |
|---|---|---|
| **SL** | `range della candela di setup + buffer ATR`, pavimento `0,2×ATR` | sul DAX M15 l'ATR(10) tipico è nell'ordine di **10-20 punti indice** → SL atteso **~12-25 punti** |
| **TP** | **2R** → **~25-50 punti indice** | 2× lo SL, per costruzione |
| **spread BCM indici** | **1-2 punti indice** [INCERTO, da rimisurare] | `R98_CRITERI.md` |
| **rapporto take/spread** | **~12-25×** | ✅ **PASSA C1 con margine larghissimo** |
| **trade/giorno stimati** | **0,5-2 per indice** [STIMATO, non misurato] | serve la contemporaneità di: fuori banda 1σ + estremo di 20 barre + candela di rifiuto + conferma. È un setup **selettivo**, non uno scalping |

⚠️ **E qui c'è il rischio vero, dichiarato prima dei numeri:** se i trade/giorno
sono davvero 0,5, su 450 sedute fanno **~225 operazioni totali**, che divise
IS/OOS 40/60 danno **~90 IS** — **sotto la soglia dei 150** dell'Emendamento
§A. 👉 **Il PASSO 0 di questo round non è opzionale: prima si CONTANO le
operazioni, poi si giudica.** Se n IS < 150 scatta la valvola R59: il round
misura il **RISCHIO** (DD, peggior giornata: fatti accaduti) e **sospende il
giudizio sul MERITO**. Ed è anche la ragione per cui la prima cella va su
**M5 oltre che M15**: su M5 la frequenza quadruplica.

```
PUNTEGGIO
  [1] semplicita' — 247 righe, ma 22 input: sopra il tetto, va sfrondato
  [2] il filtro E' il motore — la banda VWAP E' la strategia, non un cerotto.
      E' letteralmente il contrario del gradino 07 di R101
  [2] tesi di mercato scrivibile — sopra, una riga, e ha una ragione di flusso
  [2] riempie un BUCO — TRE in un colpo: (a) mean reversion intraday su
      indici, che non abbiamo; (b) motore SIMMETRICO vero (le nostre celle
      vive sono quasi tutte long-only, R52); (c) roba che LAVORA NEL
      LATERALE, dove LARRY fa -6.445 nel 2019
  [1] testabile senza riscritture — serve un ABTG_ nuovo, ma la VWAP c'e' gia'

VERDETTO   🟢 PROVA SUBITO (8/10)
PERCHE'    e' l'unico oggetto trovato che trasforma in MOTORE la cosa che in
           casa abbiamo provato solo come FILTRO e bocciato come filtro -- ed
           e' esattamente la distinzione che vale 0/5 contro 30/30 nei nostri
           dati.
```

**🏛️ IN OTTICA PROP.** Motore **selettivo e controtendenza**. Il bene: pochi
segnali, non correlati alle sedie d'apertura (che entrano alla campanella, in
direzione, sul breakout) — **fascia oraria e direzione diverse dalla flotta**,
che è il criterio di scorrelazione di `ROTTA_PROP.md` §1. Il male, e va detto:
**un motore controtendenza incassa serie di stop in un trend forte**, ed è
proprio la forma che il **DD trailing** di alcune prop punisce. 👉 Il cap
giornaliero (C6) non è un vezzo: è il pezzo che rende questo motore
compatibile col muro dei −5.000 €. E l'R:R **2:1 con stop strutturale stretto**
è la geometria giusta per un conto a DD basso: **paga poco spesso, ma quando
sbaglia sbaglia poco.**

---

### 🥈 P2 — `ATR Exhaustion & Volume Spike Strategy` — **il volume come MOTORE (convergenza R101 + corso)**

```
NOME            ATR Exhaustion & Volume Spike Strategy
FONTE / URL     https://www.tradingview.com/script/8ltrS3Yg-ATR-Exhaustion-Volume-Spike-Strategy/
                [rango: SORGENTE PINE LETTO INTEGRALMENTE — 88 righe]
AUTORE / DATA   MyStrategyHub — creato 2026-04-07, versione 1.0   [VERIFICATO
                nel JSON pine-facade]
LICENZA         ⚠️ [INCERTO] — nessuna intestazione di licenza nel sorgente.
                scriptAccess "open_no_auth". Attribuzione obbligatoria.
RIGHE / INPUT   88 righe · 9 input.() contati nel sorgente
COPIA IN CASA   biblioteca/sorgenti/AtrExhaustionVolumeSpike_MyStrategyHub_tv8ltrS3Yg_2026-08-25.pine
```

**TESI IN UNA RIGA**
> _"Un movimento che arriva a un livello strutturale dopo essersi allungato
> più di 2 ATR è un movimento che ha già speso il suo carburante: se lì sopra
> arriva un picco di volume, quel volume non è continuazione — è chi chiude."_

**MECCANICA — tre righe, ed è tutto il file**
1. **Il livello:** `ta.pivothigh(5,5)` / `ta.pivotlow(5,5)` — pivot confermati
   **5 barre dopo**, memorizzati in `last_ph` / `last_pl`. **Confermati, quindi
   in ritardo, quindi NON ridipingenti** [INFERITO dalle righe 30-36: il pivot
   entra in `last_pl` solo quando `not na(pl)`, cioè a conferma avvenuta].
2. **Le tre condizioni, tutte necessarie:** (a) **prossimità** — il minimo
   della barra è entro ±0,5% dal pivot basso; (b) **esaurimento** — la distanza
   percorsa dal pivot opposto supera **2,0 × ATR(14)**; (c) **picco di volume**
   — `volume > SMA(volume,20) × 1,5`. Più un grilletto di price action
   (`close > open` o `close > high[1]`).
3. **L'uscita:** SL al pivot (o al minimo della barra, il più protettivo),
   `qty = equity × 0,5% / risk_points`, TP a **2R**. Specchio esatto per lo
   short.

**🔍 PERCHÉ NON È UN CADUTO, E PERCHÉ QUESTO È IL PUNTO PIÙ IMPORTANTE DEL
DOSSIER**

Il volume come conferma d'ingresso lo abbiamo già misurato **due volte, e due
volte come FILTRO APPICCICATO**:
- **R12**: ORB + EMA200 + volumi sul Nasdaq → **48 su 48 negative OOS**;
- **R101 gradino `02_volumi`**: filtro volumi acceso sul motore aperture → **è
  l'unico dei nove gradini sopravvissuto a G1+G2+G3**, ed è il nostro candidato
  aperto.

E il corso lo prescrive: `ANALISI_LIVE_EMILIANO_2026-08-24.md` — _"ORB: si
entra SOLO con aumento di volume"_, regola mostrata sullo storico. **Due strade
indipendenti, stessa conclusione.** `REGISTRO_TEST.md` §MODIFICHE dà la soglia
di casa: **≥1,5× la media a 20 barre** — che è **identica** al default di
questo script (`vol_multiplier = 1.5`, `vol_sma_len = 20`). **Non l'ho scelta
io per farla combaciare: è il default dell'autore, e combacia.**

> 🎯 **Qui il volume NON è un filtro sopra un motore già tarato: senza il picco
> di volume non c'è nessuna strategia.** È costitutivo. E il §5B dice che
> questa differenza vale **0 successi su 5** contro **30 celle su 30**.
> **Questo candidato è la versione "il filtro È il motore" della regola che in
> casa abbiamo solo nella versione "filtro appiccicato".**

E non è nessuno degli altri caduti: non è un ORB (nessun box, nessun orario);
non è R42 (il livello non è l'estremo del range d'apertura, è un pivot
strutturale a 5+5 barre); **non è R95/Sweep+Reclaim** — e la differenza è
netta: **lo sweep pretende che il livello venga BUCATO e poi RICONQUISTATO;
qui il livello non va bucato affatto**, va solo raggiunto in stato di
esaurimento con volume. Sono due eventi diversi sullo stesso oggetto.

**BANDIERE ROSSE §4: NESSUNA.**
✅ **rischio in percentuale** (0,5% di default — già sotto il nostro 0,65%) ·
✅ **SL vero e strutturale** al pivot · ✅ **simmetrico** · ✅ **una posizione
alla volta** (`strategy.position_size == 0`) · ✅ **9 input, 88 righe: sotto
il tetto di 15 con margine** · ❌ niente martingala/griglia/hedge/DLL.

**🔧 COSA TERREI / COSA RIFAREI**

**DA TENERE:** la tripletta prossimità+esaurimento+volume · il pivot(N,N)
confermato come livello · SL strutturale al pivot · rischio %.

**DA RIFARE:**

| difetto | perché morde | cosa ci mettiamo |
|---|---|---|
| `bullish_trigger = close > open or close > high[1]` | **filtra pochissimo**: è vero circa metà delle volte. È il pezzo più debole del file | grilletto vero: chiusura nel 30% alto del range (**preso da P1**) o candela di rifiuto |
| `level_diff_per` in **percentuale del prezzo** (0,5%) | su un DAX a 24.000 sono **120 punti indice** di tolleranza: enorme. Su un Dow a 45.000, 225 punti | **tolleranza in ATR**, non in % del prezzo. È il difetto della scala già visto in `ProAutoSL_DynamicTP` |
| nessun cap giornaliero | C6 | `InpMaxTradesPerDay` |
| TP secco a 2R | gestione povera | parziale 1R + BE + runner 2R |
| nessuna gestione dei livelli consumati | lo stesso pivot può sparare più volte di seguito | **un livello = un trade**, e invalidazione a chiusura oltre (idea presa dal `Liquidity Sweep H4-M15` già in casa) |

**💰 COSTO DI PORTING: 4-6 ore.** È il file più piccolo dei tre e non ha
dipendenze. `ta.pivothigh/pivotlow` si riscrive in MQL5 in venti righe.

**📊 COSTO-SOPRAVVIVENZA (C1)**

| | stima |
|---|---|
| **SL** | distanza barra→pivot, tipicamente **10-25 punti indice** su M15 |
| **TP** | 2R → **20-50 punti indice** |
| **take/spread** | **~10-25×** → ✅ **PASSA C1** |
| **trade/giorno** | **1-3 per indice** [STIMATO]: i pivot(5,5) su M15 sono frequenti, il collo di bottiglia è la condizione di esaurimento a 2 ATR |

```
PUNTEGGIO
  [2] semplicita' — 88 righe, 9 input: il piu' snello dei tre
  [2] il filtro E' il motore — il volume E' la condizione d'ingresso, non un
      interruttore opzionale
  [2] tesi di mercato scrivibile — sopra
  [2] riempie un BUCO — SHORT simmetrico + laterale, come P1; e in piu' e' il
      primo motore di casa in cui il VOLUME e' costitutivo
  [1] testabile senza riscritture — serve un ABTG_ nuovo, ma e' piccolo

VERDETTO   🟢 PROVA SUBITO (9/10)
PERCHE'    e' il punto di convergenza fra tre cose indipendenti: la regola del
           corso (24/08), il nostro unico gradino sopravvissuto di R101, e un
           motore esterno che quella regola la mette al centro invece che in
           fondo. E costa meno di tutti da portare.
```

**🏛️ IN OTTICA PROP.** **1-3 trade/giorno per indice è la frequenza che
Claudio ha chiesto** (R106: accorciare i 16-22 giorni). Ma è anche il rischio:
tre indici × 3 trade = 9 operazioni al giorno, e se il DAX, il Dow e il Nasdaq
si esauriscono sullo stesso livello nello stesso pomeriggio, **sono tre stop
correlati in una seduta**. 👉 Il cap giornaliero **e** un cap di famiglia
(non più di N posizioni aperte insieme sull'intera famiglia) sono
**prerequisiti**, non rifiniture. La peggior giornata di casa misurata è
**−2,06%** (R51, ~3,2R a 0,65%): due giornate così di fila sono già metà del
cap giornaliero.

---

### 🥉 P3 — `Out of the Noise Intraday Strategy with VWAP` — **la banda di rumore che cresce durante il giorno**

```
NOME            Out of the Noise Intraday Strategy with VWAP [YuL]
FONTE / URL     https://www.tradingview.com/script/gJeM3LZ5-Out-of-the-Noise-Intraday-Strategy-with-VWAP-YuL/
                [rango: SORGENTE PINE LETTO INTEGRALMENTE — 110 righe]
AUTORE / DATA   Yuri_Lopukhov — creato 2025-07-01, v1.01   [VERIFICATO nel
                JSON pine-facade]
LICENZA         🟢 **MIT License**, dichiarata in testa al file: "(c) 2025
                Yuri Lopukhov". L'unico dei tre con licenza esplicita.
PATERNITA'      L'autore dichiara nel file di implementare il paper
                "Beat the Market: An Effective Intraday Momentum Strategy for
                S&P500 ETF (SPY)" di Carlo Zarattini, Andrew Aziz, Andrea
                Barbon. 🔴 **IL PAPER NON L'HO APERTO**: SSRN risponde 403 e
                tutti i mirror (unisg, ResearchGate, cxoadvisory, Substack)
                sono bloccati dal proxy in uscita. **[INCERTO]** su tutto cio'
                che riguarda il paper; **[VERIFICATO]** solo cio' che sta nel
                Pine, che e' cio' che ho letto.
RIGHE / INPUT   110 righe · 6 input.() contati nel sorgente
COPIA IN CASA   biblioteca/sorgenti/OutOfTheNoiseIntraday_YuriLopukhov-MIT_tvgJeM3LZ5_2026-08-25.pine
```

**TESI IN UNA RIGA**
> _"Non ogni movimento è un segnale: attorno all'apertura c'è un cono di
> rumore che si allarga con l'ora del giorno, e solo un prezzo che esce da
> QUEL cono — non da un box di 15 minuti — è squilibrio vero."_

**MECCANICA — tre righe**
1. **Il cono (il motore):** per **ogni barra del giorno**, si calcola la media
   su **14 giorni** del `|close/open_del_giorno − 1|` **alla stessa posizione
   oraria** (`intra_day_idx`). La banda è
   `max(open, close_di_ieri) × (1 + avg_move)` e simmetrica sotto.
   👉 **La banda si allarga da sola man mano che la seduta avanza**, e tiene
   conto del gap notturno (usa `close[1]` accanto a `open`).
2. **Il grilletto:** `close > upper_bound` → long; `close < lower_bound` →
   short. **In qualunque momento della seduta**, escluso solo la prima barra.
3. **L'uscita:** si chiude il long quando `close < max(vwap, upper_bound)` —
   cioè **la VWAP di sessione fa da trailing**, e il cono da secondo binario.
   **`strategy.close_all()` all'ultima barra della sessione**: mai overnight.

**🔍 PERCHÉ NON È UN CADUTO — e qui la dichiarazione dev'essere onesta**

| | i caduti | questo |
|---|---|---|
| **il livello** | high/low **fissati** nei primi 15-30 minuti, poi immobili | banda che **cambia a ogni barra** in funzione della volatilità stagionale di quell'ora, stimata su 14 giorni |
| **la finestra d'ingresso** | quasi sempre la prima ora | **tutta la seduta**. La maggior parte dei segnali NON cade all'apertura |
| **R98 (intraday momentum, 0/6)** | segno dei **primi 30 minuti** → operazione negli **ultimi 30 minuti**, una al giorno | **nessun riferimento ai primi 30 minuti, nessuna finestra di uscita fissa**: sono due predittori diversi dello stesso autore intellettuale (momentum intraday), ma la regola è un'altra |

> ⚠️ **E adesso il pezzo scomodo, che scrivo perché regga fra un mese: questo
> RESTA un breakout.** Non di un'apertura, non di un box, non al tocco — ma
> il grilletto è "il prezzo esce da una banda". Su una famiglia dove abbiamo
> **~210 celle a tick reali** e un capitolo dichiarato chiuso, **questo è il
> candidato che deve dimostrare di più**. Lo metto terzo per questo, non
> perché il codice sia peggiore: il codice è il più pulito dei tre.

**BANDIERE ROSSE §4 — UNA, ed è grave: NESSUNO STOP LOSS.**
```pine
if close > math.min(vwap, lower_bound)
    strategy.close("Short", "Exit Short")
```
L'uscita è **una regola su chiusura di barra**, non uno stop mandato al broker.
Su un gap violento la posizione resta aperta fino alla chiusura della barra
successiva. **E l'autore lo dice da solo**, nel commento in testa al file:
_"there are also margin calls if you enable margin check"_. In più
`leverage_long = 4` e `qty = equity × target / close` = **sizing a leva, non
a rischio**.

> 🔴 **Così com'è NON entra in nessun conto prop.** Ma il §5F è esplicito:
> **il marciume nel MOTORE non si rifinisce; una gestione scadente sì.**
> Qui il motore (il cono di rumore) è sano e la gestione è assente. **È
> letteralmente il profilo che il mandato descrive come "buon candidato".**

**🔧 COSA TERREI / COSA RIFAREI**

**DA TENERE:** il cono `open × (1 ± media a 14 giorni del movimento alla
stessa ora)` · l'aggancio al `close` di ieri per il gap · la VWAP come
trailing · il flat obbligatorio a fine sessione (che è anche la regola di
Emiliano: _"chiusura sempre in giornata, MAI overnight"_).

**DA RIFARE:** **stop loss vero al broker** (ATR o bordo opposto del cono) —
prerequisito assoluto · **rischio 0,65%** al posto della leva 4 · cap
giornaliero · e la scelta del TF: l'originale è **30 minuti**, il mandato
chiede **M5/M15**; su M15 la griglia "media del movimento alla stessa
posizione oraria" diventa più fine e **più rumorosa** — va misurato, non
assunto.

**💰 COSTO DI PORTING: 8-10 ore.** Il più caro dei tre: la matrice
"movimento medio per posizione-oraria su 14 giorni" va costruita a mano in
MQL5 e va gestita la sessione (DAX 08:00-16:30 server ≠ Dow 14:30-21:00
server). ⚠️ E il fuso: **tutti gli orari in ora SERVER**, DAX 08:00, Nasdaq
14:30 (regola fissa di casa).

**📊 COSTO-SOPRAVVIVENZA (C1)**

| | stima |
|---|---|
| **trade/giorno** | **0-2 per indice** [STIMATO]: per costruzione la banda contiene il ~50-70% delle sedute per intero (è "rumore"), e nei giorni di trend spara 1-2 volte |
| **guadagno per trade** | **[NON STIMABILE a tavolino]**: l'uscita è a trailing su VWAP, non a R fisso. 🔴 **Questo è il candidato su cui C1 NON si può giudicare prima del tester** — e lo dichiaro invece di inventare un numero |
| **conseguenza** | il PASSO 0 di questo round **deve** misurare il lordo medio per operazione in punti indice **prima** di leggere qualunque PF. È lo stesso cancello S0 che ha bocciato R98 in una riga |

```
PUNTEGGIO
  [2] semplicita' — 110 righe, 6 input: il piu' semplice dei tre
  [2] il filtro E' il motore — il cono di rumore E' la strategia
  [2] tesi di mercato scrivibile — sopra
  [1] riempie un BUCO — copre la SEDUTA INTERA (nessuna nostra sedia opera
      dalle 10:00 alle 16:00 server sugli indici) e ha lo SHORT simmetrico.
      Ma NON copre il laterale: nel laterale sta fermo per costruzione
  [0] testabile senza riscritture — riscrittura piena + stop loss da
      inventare + gestione della sessione. E' il piu' caro

VERDETTO   🟡 IN CODA (7/10) — PROMOSSO alla coda, non alla macchina
PERCHE'    il motore e' l'unica idea davvero nuova trovata oggi (una banda che
           conosce l'ora del giorno), ma e' un breakout su una famiglia con
           210 celle rosse, senza stop loss, e con il costo di porting piu'
           alto. Va dopo P1 e P2: una macchina, un lavoro.
```

**🏛️ IN OTTICA PROP.** Il pregio grosso: **flat obbligatorio a fine sessione**
= zero rischio overnight, zero gap contro. E la fascia oraria (tutta la
seduta) è **scoperta dalla flotta**. Il difetto grosso: è **direzionale e
correlato al mercato** — sui giorni di trend forte compra insieme a tutte le
nostre sedie long. **Scorrelazione bassa proprio quando conta.**

---

## 3. 🗑️ GLI SCARTATI — una riga di motivo a testa

### 3.1 MQL5 Code Base — i 3 titoli M5/M15 mai setacciati prima

| # | file | id | righe/input | verdetto |
|---|---|---|---|---|
| 1 | `OHLCMTF Scalper EA - Multi-Timeframe Price Action` (KayruYuta, 2026.03.20, **DL 1.886**) | [70796](https://www.mql5.com/en/code/70796) | 143 · 15 | 🔴 **`Fixed_Lot = 0.1`** (bandiera §4: non scalabile a 100k), magic **hardcoded 123456**, **nessun `OnTester`** (il driver rifiuta di partire), `Buy_Cond_1`/`Sell_Cond_1` **spenti di default** = cicatrice di un backtest altrui. _(Nota corretta a mano: l'input `Look_Forward_Bar=10` **non è look-ahead** — è dichiarato e mai usato; il segnale legge `iHigh/iLow` alle barre 1 e 2.)_ |
| 2 | `Momentum-M15` (barabashkakvn, 2018.06.16, DL 1.252) | [20545](https://www.mql5.com/en/code/20545) | 696 · 13 | 🔴 **`InpLots = 0.1` fisso**, **nessuno SL all'ingresso** (solo trailing opzionale, `InpTrailingStop=0` di default = niente stop). Due bandiere §4 |
| 3 | `CashMachine 5min` (barabashkakvn, 2017.01.26, **DL 4.187**) | [17184](https://www.mql5.com/en/code/17184) | 298 · 10 | 🔴🔴 **`hidden_TakeProfit` / `hidden_StopLoss`**: lo stop è **VIRTUALE, e sta nel nome dell'input** — bandiera §4 esplicita. Più `Lots = 0.2` fisso. Port MQL5 di un EA polacco del 2008 |

### 3.2 TradingView — i 15 valutati e scartati (**14 letti nel sorgente**, 1 dichiarato non letto)

| candidato | slug | meccanismo | motivo dello scarto |
|---|---|---|---|
| `VWAP SD2 Reversion (Long)` — jswapnil | [oSV81CXs](https://www.tradingview.com/script/oSV81CXs-VWAP-SD2-Reversion-Long/) | banda VWAP −2σ → RSI risale → MACD incrocia → long, TP alla VWAP | 🟠 **SCARTATO come candidato, TENUTO come SPUNTO.** **LONG ONLY** (il contrario del buco), **`default_qty_type = strategy.fixed, 100000` = lotto fisso**, TP/SL a **5 pip** = tarato su forex, ~30 input. **Ma il suo cuore vale**: una **macchina a stati sequenziale a 3 passi con finestra di conferma** che impedisce di prendere il coltello che cade. 👉 **Da valutare come gradino di P1.** Sorgente archiviato in biblioteca |
| `NY First Candle Break and Retest` — PrincessQuinn | [82pXmSHs](https://www.tradingview.com/script/82pXmSHs-NY-First-Candle-Break-and-Retest/) | rottura della prima candela NY, poi **retest** entro 2-25 barre, + VWAP + volumi + 3 target parziali | 🔴 **DOPPIONE DI CASA.** È la geometria RETEST che `ABTG_DAX_Apertura_EU` fa già (`ANALISI_LIVE_EMILIANO`: _"la nostra geometria RETEST fa già questo. Siamo avanti"_), coi filtri VWAP e volumi che R101 ha già ablato. Più **`default_qty_value=90` = 90% dell'equity** e 29 input. ✅ **Vale però come TERZA conferma indipendente** che retest+volume è la combinazione che il mercato riconosce |
| `VWAP ORB Pullback Strategy` — TraderTed420 | [75epRRh2](https://www.tradingview.com/script/75epRRh2-VWAP-ORB-Pullback-Strategy/) | rottura ORB 15' + pullback alla VWAP + EMA9 | 🔴 famiglia ORB (capitolo chiuso, ~210 celle) e **`percent_of_equity=10` senza rischio %**. Il pullback alla VWAP è l'unica idea, ed è dentro P1 in forma migliore |
| `MNQ ORB Strategy - VWAP + Bias` — dbmeyers | [khcR5SPp](https://www.tradingview.com/script/khcR5SPp-MNQ-ORB-Strategy-VWAP-Bias/) | ORB 10' su Micro Nasdaq, buffer in tick, filtro ATR sul range, uscita all'incrocio VWAP | 🔴 **ORB + `numContracts = 2` fisso** + TP/SL in **tick assoluti** (120/60). I due filtri (max range in ATR, uscita su VWAP) **li abbiamo già** come `InpMaxRangePts` e gradino 07 |
| `Script_Algo - ORB Strategy with Filters` — Script_Algo | [Y0KEwo8o](https://www.tradingview.com/script/Y0KEwo8o-script-algo-orb-strategy-with-filters/) | ORB + filtro volumi + Supertrend | 🔴 ORB + `default_qty_value=10` fisso. **E c'è di peggio**: `long_condition = ... and direction < 0` — entra long **solo se il Supertrend è ribassista**. O è un bug, o è una cicatrice da ottimizzatore. In nessuno dei due casi si misura |
| `Liquidity Sweep Filter Strategy` — AlgoAlpha X PineIndicators | [gx7267BR](https://www.tradingview.com/script/gx7267BR-Liquidity-Sweep-Filter-Strategy-AlgoAlpha-X-PineIndicators/) | liquidazioni + volume profile, uscita su cambio trend | 🔴 **NESSUNO STOP LOSS** (esce solo al ribaltamento del trend) + **`percent_of_equity = 100`** + default **"Long Only"**. Due bandiere §4 |
| `Liquidity Sweep Breakout - LSB` — humayunmha | [MN4tJCT5](https://www.tradingview.com/script/MN4tJCT5-Liquidity-Sweep-Breakout-LSB/) | sweep del box della **sessione di Tokyo** poi breakout | 🔴 **filone JPY chiuso** (R95 0/30 + caccia 21/08 "deserto"), `profitPerPip` tarato sui cross JPY, e c'è un input **`pineConnectorKey` = licenza EA**. Doppio motivo |
| `Price and Volume Breakout Buy` — TradeDots | [jc2hs2qK](https://www.tradingview.com/script/jc2hs2qK-Price-and-Volume-Breakout-Buy-Strategy-TradeDots/) | rottura del massimo a 60 barre **con volume al massimo a 60 barre**, sopra SMA200 | 🔴 **DOPPIONE di `ABTG_EMA200` Dow (R29, 30 celle su 30)**: rottura + trend filter di lungo. E **nessuno stop loss** (esce dopo 5 chiusure sotto la media) + 70% dell'equity |
| `Open Drive` — Marcn5_ | [nyTw4KmR](https://www.tradingview.com/script/nyTw4KmR-Open-Drive/) | candela che **apre a un estremo e chiude all'altro** con espansione oltre il range a 5 barre, nei 15' delle aperture cash | 🟠 **SCARTATO, ma il PATTERN si tiene.** Scarto: **`strategy.entry(..., 2)` = 2 contratti fissi**, **nessuno stop loss**, uscita a `limit=close` dopo 3 barre (che in MT5 non significa niente). ✅ **Lo SPUNTO**: la definizione di "open drive" (apertura entro il 15% di un estremo + chiusura entro il 15% dell'altro + espansione ≥100% del range a 5 barre) è **un filtro di qualità della candela che non abbiamo**, e si aggiunge a costo quasi zero al motore aperture |
| `ChopFlow ATR Scalp Strategy (OBV EMA)` — TheFuturesPlaybook | [TgcbEl6W](https://www.tradingview.com/script/TgcbEl6W-ChopFlow-ATR-Scalp-Strategy/) | Choppiness Index < 60 come regime + **OBV vs la sua EMA come DIREZIONE** | 🟠 **SCARTATO per esecuzione, non per idea.** `default_qty_value=1` fisso, e soprattutto **un bug vero**: `strategy.exit(stop = close − atr*mult)` sta in scope globale, quindi **lo stop viene ricalcolato a ogni barra** e insegue il prezzo in entrambe le direzioni. ✅ **Lo SPUNTO è forte**: usare il **volume cumulato (OBV) come segnale DIREZIONALE** invece che come conferma è l'unica idea "delta" trovata oggi, e in casa il volume l'abbiamo solo come sì/no |
| `Best TradingView Strategy - NASDAQ/DOW30` — The_Bigger_Bull | [wv68sDys](https://www.tradingview.com/script/wv68sDys-Best-TradingView-Strategy-For-NASDAQ-and-DOW30-and-other-Index/) | fade delle Bollinger(9;2) + filtro SMA14/42 | 🔴 **bug nel segnale**: `shortCondition` usa `crossunder(close, lower1)` — la **stessa banda inferiore** del long. Lo short entra dove entra il long. E stop/target **hardcoded a ±50/±100** in unità di prezzo. Non misurabile |
| `Average High-Low Range + IBS Reversal` — Botnet101 | [BTwOiV1h](https://www.tradingview.com/script/BTwOiV1h-Average-High-Low-Range-IBS-Reversal-Strategy/) | IBS (posizione della chiusura nel range) < 0,2 sotto una soglia a 2,5 range medi | 🔴 **LONG ONLY**, **nessuno stop loss**, **100% dell'equity**, `calc_on_every_tick = true` (§4: repaint). Idea di fondo (IBS) documentata, esecuzione no |
| `Bollinger Bands Reversal + IBS` — Botnet101 | [GdlXcHYW](https://www.tradingview.com/script/GdlXcHYW-Bollinger-Bands-Reversal-IBS-Strategy/) | BB(20;2) + IBS < 0,2 | 🔴 stessi tre difetti del precedente. E in casa **`ABTG_BandFade` esiste già** |
| `RVWAP Mean Reversion Strategy` — vvedding | [oZcWZsvU](https://www.tradingview.com/script/oZcWZsvU-RVWAP-Mean-Reversion-Strategy/) | VWAP **rolling** a 5 giorni + bande 3σ | 🔴 **`pyramiding = 3` con `qty` fisso a 1** = si somma sulla posizione, **nessuno stop loss** (esce all'incrocio della VWAP), e dipende da una **libreria Pine esterna** (`PineCoders/ConditionalAverages`) che non si traduce |
| `VWAP Mean Reversion — Range Bound Forex RSI Volume` | [9SEB7IHb](https://www.tradingview.com/script/9SEB7IHb-VWAP-Mean-Reversion-Strategy-Range-Bound-Forex-RSI-Volume/) | VWAP + RSI + volume su forex range-bound | 🟠 **NON LETTO NEL SORGENTE** — chiuso il budget di richieste. Dichiarato, non giudicato. Titolo compatibile con P1: se un giorno serve un secondo motore VWAP, si parte da qui |

### 3.3 Scartati al primo taglio (titolo + tag, sorgente non aperto — e lo dichiaro)

Dalle 399 strategie raccolte, tutto ciò che nel titolo dichiara una famiglia
già seppellita o una bandiera §4:
`Big Daddy Max ORB`, `Opening-Range Breakout` (×2), `Negroni Opening Range`,
`Long-Only ORB with Pivot Points`, `Session Opening Range Breakout (ORBO)`,
`NY Opening Range Breakout - MA Stop`, `Initial Balance Breakout [samjNQ]`,
`ORB Breakout Strategy`, `Morning Breakout`, `[STRATEGY][RS] Open Session
Breakout Trader` → **famiglia ORB, ~210 celle a tick reali, capitolo chiuso**.
`AliceTears Grid`, `(IK) Grid Script`, `Continuous Market Grid bot`,
`[3Commas] ... DCA Strategy`, `SmartDCA`, `Same high/low + DCA`,
`OrangePulse ... DCA`, `Tomukas Wave VWAP **DCA** Scalper` → **griglia / DCA
= §4**. `Hulk Strategy x35 Leverage` → **leva 35 dichiarata nel titolo**.
`Combo Backtest 123 Reversal & <indicatore>` (**14 varianti dello stesso
scheletro**) → fabbrica di combinazioni, non una tesi.
`Turn of the Month on Steroids`, `Turn around Tuesday on Steroids`,
`Seasonal Strategies V1`, `Unlock the Power of Seasonality` → **effetti di
calendario: ~22 osservazioni su 450 sedute, NON MISURABILI da noi** (§C5, ed è
lo stesso muro dichiarato il 23/08).
`[JOAT]` (**8 script**), `Quantum Flux Universal`, `AGNI MOMENTUM Ultimate`,
`Singularity Convergence Protocol` → nomi da prodotto, confluenze multiple
senza tesi singola.

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perché |
|---|---|
| **Il paper Zarattini-Aziz-Barbon** (fonte intellettuale di P3) | **SSRN 403** + **tutti i mirror bloccati dal proxy in uscita** (unisg.ch, researchgate, cxoadvisory, substack, quantitativo). Ho letto **l'implementazione**, non **il paper**. Tutto ciò che riguarda i suoi numeri, il suo campione e i suoi costi è **[INCERTO]** e non pesa su nessun punteggio |
| **GitHub** | 403 su web e API, `gh` non configurato per la ricerca. **Zero repo esaminati — quinta caccia di fila.** È il buco che pesa di più: i repo seri hanno la **storia dei commit**, cioè l'unico posto dove si vede se l'autore ha aggiustato la strategia dopo aver visto i risultati |
| **Forex Factory — thread storici** | 403. È l'unico posto dove si legge **come una strategia è invecchiata**, e continua a mancarci |
| **Il sorgente Pine di `9SEB7IHb`** e delle altre ~382 strategie raccolte ma non aperte | budget di richieste. **Il canale ora funziona (§1-bis): chiunque può riprenderlo da dove l'ho lasciato**, la lista completa dei 399 titoli si rigenera in 3 minuti con lo script descritto |
| **Lo spread reale di BCM su D30EUR/U30USD/NASUSD nelle fasce M5/M15** | non esiste una misura nostra ripetibile: c'è solo il "1-2 punti indice" di `R98_CRITERI.md`. 🔴 **Il criterio C1 di questa caccia poggia su un numero non nostro**, e va sanato con uno script sul simbolo prima del primo verdetto |

---

## 5. 🧭 SCOPERTE TRASVERSALI (valgono oltre questa caccia)

1. 🔓 **TradingView è tornata leggibile, sorgente compreso** (§1-bis). Cinque
   dossier la danno per NULLA. **Va aggiornato `PROMEMORIA_SBLOCCO_FONTI.md`.**
2. 🧱 **Il Code Base è esaurito per gli indici intraday.** Terza misura
   consecutiva, con filtri diversi ogni volta: `vwap` → 0, `dax` → 0,
   `retest` → 1. **Non è "non ho trovato": non esiste.** Suggerimento
   operativo: **smettere di ricrawlare il Code Base per gli indici** e spendere
   quel tempo su TradingView, che ora si legge.
3. 🎯 **Tre fonti indipendenti convergono sulla stessa regola**: il corso
   (Emiliano/Paolo, 24/08: _"si entra SOLO con aumento di volume"_), il nostro
   R101 (`02_volumi` unico gradino sopravvissuto), e il mercato aperto
   (P2 e `NY First Candle Break and Retest` mettono entrambi il volume fra le
   condizioni necessarie). **Quando tre strade indipendenti dicono la stessa
   cosa, la cosa da misurare è quella.**
4. 📐 **Il difetto ricorrente degli EA/script "gratis" su M5/M15 non è la
   martingala: è lo STOP.** Sui 17 Pine letti, **7 non hanno nessuno stop
   loss** e 2 ce l'hanno virtuale/mobile per bug. Sui 3 `.mq5` nuovi, 2 su 3
   hanno lotto fisso e 2 su 3 non hanno stop vero. 👉 **Filtro di primo taglio
   per la prossima caccia: `Ctrl+F` su `strategy.exit(... stop=` in Pine e su
   `sl=` / `SetStopLoss` in MQL5. Se non c'è, non si legge oltre.**
5. 💡 **Tre spunti di meccanica raccolti dagli scartati**, che costano poco e
   non richiedono un round dedicato:
   - la **macchina a stati sequenziale con finestra di conferma** (da
     `VWAP SD2 Reversion`) → gradino per P1;
   - il pattern **"open drive"** (apertura a un estremo + chiusura all'altro +
     espansione ≥100% del range a 5 barre) → filtro di qualità della candela
     per il motore aperture;
   - **OBV come segnale DIREZIONALE** invece che come conferma sì/no (da
     `ChopFlow`) → è il "delta" della pista 4 del mandato, in forma
     misurabile con ciò che MT5 ci dà.
6. 🕐 **La fascia oraria 10:00-16:00 server sugli indici è VUOTA nella
   flotta.** Le sedie vive stanno alla campanella (DAX 08:00, Dow 14:30), di
   notte (MaxMinNotte) o su H1/H4. Chiunque proponga un motore che lavora
   **a metà seduta** parte con un vantaggio di scorrelazione, e P1/P2 lo fanno
   entrambi. _(Nota: la biblioteca ha già un indizio esterno nella stessa
   direzione — il preset `DaxMorningScalp v2.31 "brunch breakout"` archiviato
   il 23/08 entra alle **10:20/10:45 server**, non all'apertura.)_

---

## 6. 📦 IL FILE PROVA DEL CANDIDATO NUMERO UNO

**`backtest_pipeline/prove/VWAPREVERT_DAX_M15_BOZZA.txt`** — scritto, con
ipotesi e criteri **congelati prima dei numeri**.

🛑 **E con un cartello sopra che va rispettato: quel file NON PUÒ GIRARE OGGI.**
L'EA `ABTG_VwapRevert.mq5` **non esiste ancora** — va scritto (5-7 ore, §2 P1).
Il file prova è la **specifica congelata** di cosa dovrà misurare, esattamente
come `R101_DAX_02_volumi.txt` porta in testa _"finché non sono firmati, questo
file non deve girare"_.

**I quattro paletti prima di qualunque riga di lancio** (e passano tutti da
`backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`):
1. **`@DAQUANDO 2024.09.26`** — **MISURATO**, non ipotizzato
   (`REFERTO_SONDA_STORICO_17-08.md`: indici a BCM, stato `COMPLETO`).
2. **PASSO 0 obbligatorio: contare le operazioni prima di leggere il PF.** Se
   n IS < 150 scatta la valvola R59 (rischio sì, merito sospeso).
3. **Magic vergini `773400`/`773401`** — **verificato libero** in tutto il repo
   il 25/08/2026 (nessuna occorrenza in `.mq5`, `.txt`, `.md`). Gemelli
   identici = controllo d'igiene.
4. **Selezione: centro dell'altopiano, MAI il picco.** Dodici Spearman IS→OOS
   negative su tredici, l'ultima (R58) sui tick reali del nostro broker.

---

## 7. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Il ritorno alla VWAP di sessione — la stessa VWAP che come FILTRO
> direzionale R101 ha bocciato per incoerenza fra Dow e DAX — ha un edge
> quando diventa il MOTORE, cioè quando senza la sua banda non esiste nessun
> segnale?"**
>
> Se **sì**: abbiamo un motore **simmetrico**, che lavora **a metà seduta** e
> **nel laterale** — tre buchi in uno — su un TF dove il campione abbonda, che
> è esattamente ciò che serve per accorciare i 16-22 giorni di R106.
> Se **no**: abbiamo chiuso la VWAP in tutte e due le forme (filtro e motore)
> con un round solo, e il verbale dirà che sui **nostri** indici la VWAP non è
> un livello operativo — un'informazione che oggi non abbiamo e che vale i
> prossimi tre agenti che proporranno "mettiamoci la VWAP".

---

_Dossier compilato il 25/08/2026 dall'agente `cacciatore-strategie`._
_Fonti aperte davvero: **TradingView** (399 titoli unici, **17 sorgenti
Pine scaricati e letti**), **MQL5 Code Base** (1.593 titoli, 3 sorgenti `.mq5`
nuovi letti), **arXiv API** (3 query), **Quantpedia** (controllo positivo)._
_Fonti dichiarate NULLE: **GitHub**, **SSRN**, **Forex Factory**, e i cinque
mirror del paper Zarattini bloccati dal proxy in uscita._
_**Nessun numero di performance dichiarato da un autore è stato usato in
nessun punteggio di questo dossier.**_

_Attribuzione, come da regola di casa — va ripetuta in testa a qualunque
`.mq5` derivato:_
- _`VWAP Mean Reversion Strategy` è di **sumbloke077** (TradingView, 02/04/2026)_
- _`ATR Exhaustion & Volume Spike Strategy` è di **MyStrategyHub** (TradingView, 07/04/2026)_
- _`Out of the Noise Intraday Strategy with VWAP` è di **Yuri Lopukhov**, **licenza MIT** (TradingView, 01/07/2025), su implementazione dichiarata del lavoro di **Zarattini, Aziz, Barbon**_
