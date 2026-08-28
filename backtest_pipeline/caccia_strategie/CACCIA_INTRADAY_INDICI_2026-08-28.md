# 🏹 CACCIA — MOTORI INTRADAY su INDICI, CHIUSURA OBBLIGATORIA IN GIORNATA — 28/08/2026

**Mandato (sessione principale, 28/08):** motori **intraday** per DAX / Dow /
Nasdaq su **M15-H1**, con un requisito **non negoziabile**: _"il motore deve
chiudere tutte le posizioni entro la sessione/giornata, mai overnight"_.

**Perché il requisito è vincolante e non un vezzo** (contesto dato dalla
sessione principale, riportato come mi è stato consegnato — **[INCERTO]**, non
l'ho verificato io sul sito FTMO): il conto _FTMO Standard_ (leva 1:100)
impone restrizioni overnight/weekend/news **solo sul conto FINANZIATO**, non
in Evaluation. Un motore che chiude sempre in giornata evita il problema alla
radice e **permette di restare a 1:100 invece di scendere a 1:30** (conto
Swing). Ogni motore intraday vero vale doppio: **frequenza + niente downgrade
di leva**.

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 6 fonti sottoposte a controllo positivo (4 vive, 2 nulle + 1 riaperta),
> ~470 titoli TradingView passati al setaccio su 34 tag e 63 interrogazioni di
> ricerca, 320 titoli del Code Base ricrawlati, 6 query arXiv, ho aperto e
> letto nel sorgente 18 file (15 Pine + 3 `.mq5`). PROMUOVO UNO — e il primo
> non è un import: è un INTERRUTTORE NOSTRO CHE NON È MAI STATO ACCESO.**

🎯 **La scoperta che vale più di tutti i candidati, ed è dentro casa:**
`ABTG_Dow_Apertura_US.mq5` (righe 195-199) sa già costruire il livello dal
**range PRE-apertura** (`ABTG_RANGE_PREV = 1`, righe 825 e 1028:
`fromMin = openMin - InpPrevWindowMin`). **Su 48 file prova del repo, 47
pinnano `InpRangeMode` a 0 e uno solo lo spazzola 0→2: il valore 1 non è mai
stato la modalità di una cella misurata. E `InpPrevWindowMin` è pinnato a 60
in 28 file su 28, mai mosso.** [VERIFICATO con `grep` sul branch `lavoro`,
28/08/2026]. Un pezzo di macchina pagato e mai usato, che **soddisfa il
requisito del mandato da solo** (`InpCloseAtEnd=1` c'è già).

🔓 **E c'è una notizia tecnica che riapre due canali chiusi da sei cacce:**
1. **GitHub si legge**, non con `curl` (403 su web e API, settima caccia di
   fila) ma **con lo strumento `WebFetch`**: ho aperto e listato
   `github.com/topics/expert-advisor`. § 1-ter.
2. **TradingView ha un endpoint di RICERCA TESTUALE**, non solo i tag:
   `pubscripts-suggest-json/?search=...` restituisce **hash `PUB;` completo,
   autore, numero di like e il flag `access`** in un colpo solo. §1-bis. Con
   `access=1` si sa **prima di scaricare** se il sorgente è leggibile
   (`access=2` → `401 User is not allowed to see source code`). È tre volte
   più veloce della procedura a tag del 25/08 e trova cose che i tag non
   indicizzano.

🔴 **E la risposta scomoda, che va detta per prima: il campo È arato quanto
quello forex, e stavolta ho il numero esterno che lo spiega.** Il candidato
esterno più forte per tesi economica — il **fade del gap d'apertura** — è
**già misurato in casa** (R61/R62) **e già falsificato fuori** (arXiv
2605.04004, tabella 5: Gap Fill Fade, N≈240/anno, netto −1,31/−2,24 punti,
T da −0,32 a −0,59). Non è "non ho trovato": è che quella porta è chiusa da
due lati.

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire, è il metro di scarto

Letti per intero prima di aprire un browser: `REGISTRO_TEST.md`,
`CACCIA_M5M15_INDICI_2026-08-25.md` (dossier gemello), `CACCIA_SMC_OB_FVG_2026-08-26.md`,
`report/ROTTA_PROP.md`, i referti R109/R110/R111/R112/R113/R114,
`REFERTO_ROUND62_GAPFILL_SOGLIA_BASSA.md`, `report/BILANCIO_16-08.md`,
`report/SWEEP_MECCANISMI_2026-08-23.md`.

| caduto | dove | meccanismo | verdetto misurato |
|---|---|---|---|
| **capitolo BREAKOUT M5 D'APERTURA** | `REGISTRO_TEST.md` §2 | Live5m, Live5m_v2, DAX_M3, aperture Nasdaq, ORB_Fibo, Londra_ORB | **CHIUSO 26.07.26** a tick reali. _"Non costruire altri v2 M5"_ |
| **famiglia ORB in generale** | `SETACCIO_MANUALE.md` | ~**210 celle a tick reali** su 4 mercati | _"il breakout puro al tocco è morto ovunque"_ |
| **R42 — FADE degli estremi d'apertura** | `REFERTO_ROUND42_FADE.md` | fade sul box 15'/35' | **0/24 IS e 0/24 OOS** |
| **R45 — ORB di sessione (Londra)** | `REFERTO_ROUND45_LONDRA.md` | range 15/30' + conferma | **0 celle positive su 48** |
| **R98 — INTRADAY MOMENTUM (Gao)** | `R98_REFERTO.md` | segno dei primi 30' → operazione | **0/6**, lordo medio **−0,31 punti indice** su 410 op |
| **R109 — ATR Exhaustion & Volume Spike** | `R109_REFERTO.md` | esaurimento + spike di volume su M15 indici | DD **44-68%**, peggior giornata **−9,72%**. _Era il P2 promosso il 25/08: tre giorni dopo è un caduto._ |
| **R108/R111 — la discesa di TF** | `R108_REFERTO.md`, `R111_REFERTO.md` | Breaking Band H1→M30→M15 | gradiente **MONOTONO H1 > M30 > M15**. A M15: **6 finestre su 6 rosse** |
| **R95 — SWEEP + RECLAIM** | `R95_REFERTO.md` | sweep + rientro | **30 su 30 in perdita** |
| **`RangeMode=2`** (candela precedente) | `BILANCIO_16-08.md` §3 | livello = candela H1 precedente | IS +434 → **OOS −2.444,14, PF 0,665, DD 26,29%** |
| **short dell'apertura DAX e Nasdaq** | R43 | — | **64 celle, 0 verdi su 32 OOS** |
| **filtro appiccicato a motore già tarato** | `ROBUSTEZZA.md` §5B | R20 ADX, R12, R26, R45, R54 | **0 successi su 5** |

### 📌 Le tre frasi che ho usato come bussola (citate, non parafrasate)

1. **R42:** _"L'unica cosa che ha sempre pagato è il **RETEST** — entrare sul
   RITORNO al livello DOPO la rottura confermata"_.
2. **`SWEEP_MECCANISMI_2026-08-23.md`**, sul conflitto R42-vs-paper: _"le due
   fonti non si contraddicono: parlano di due mercati diversi, e su quello
   dove il retest gira, gira in live"_. 👉 **Il retest vive sul Dow/DAX, non
   sul Nasdaq.** È il motivo per cui il promosso di oggi è sul **Dow**.
3. **§5B:** filtro **aggiunto dopo** = 0/5; filtro che **È** la strategia =
   **30 celle su 30**.

---

## 0-bis. ⚖️ I CRITERI CONGELATI PRIMA DEI NUMERI

**C0 — IL FLAT DI FINE SESSIONE È ELIMINATORIO, NON UN PLUS.** Un candidato
senza chiusura obbligatoria in giornata non è un candidato di questo mandato.
Se il motore è sano e il flat manca, si dichiara **"motore sì, gestione da
rifare"** (§5F) — ma il flat va nella colonna "cosa rifaremmo", sempre.

**C1 — IL COSTO È IL CANCELLO PRINCIPALE.** Metro: `METRO_PROP.md` D4 +
`R98_CRITERI.md` §3.2 — **take LORDO mediano ≥ 3 × spread**, spread di
riferimento **2,0 punti indice** su D30EUR/U30USD/NASUSD,
**[SPREAD NON MISURATO]** (lato alto della forchetta 1-2 di `R98_CRITERI`).
👉 **Soglia operativa: take mediano ≥ 6,0 punti indice.**
Conversione: **1 punto indice = 100 punti MT5** su U30USD/NASUSD (R97).

**C2 — TICK REALI PER I VERDETTI.** L'OHLC 1-min su questa famiglia ha già
prodotto **+129k finti sul DAX** (`REGISTRO_TEST.md` §2). Serve a contare i
trade, mai a dare il segno.

**C3 — DUE LATI SEMPRE** (regola di Claudio del 25/08).

**C4 — PAVIMENTO SL OBBLIGATORIO** (`InpMinStopPts`). Lezione R109
fotografata: senza pavimento il lotto sbatte su `SYMBOL_VOLUME_MAX` e **i DD
sottostimano il rischio**.

**C5 — CAMPIONE E FINESTRA.** Indici nativi BCM: storico dal **2024.09.26**
(misurato, `REFERTO_SONDA_STORICO_17-08.md`). ⚠️ Rimisurato il 26/08
(`STORICO_INDICI_20260826_2334/REFERTO_STORICO_INDICI.txt`): i simboli `_EXT`
esistono per NASUSD e SPXUSD **ma il cancello zero è ANCORA CHIUSO** (diff
media H1 0,061-0,101% contro ≤0,05% richiesto) e **il Dow e il DAX non hanno
storico esterno**. 👉 **Su questo mandato la finestra è 21 mesi, un solo
regime rialzista, e va dichiarato prima.**

**C6 — NIENTE** griglie, martingale, recovery, hedging, lotto fisso, stop
virtuale, repaint, `WebRequest`, `iCustom` non allegato.

**C7 — I NUMERI DEGLI AUTORI NON ENTRANO IN NESSUN PUNTEGGIO.** Nessuno è
stato usato in questo dossier.

---

## 1. 📡 CONTROLLO POSITIVO — misurato oggi, fonte per fonte

| fonte | HTTP | bersaglio noto verificato oggi | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951**: `Liquidity Sweep H4 - M15`, autore `OsmarSandovalEspinosa`, `2026.03.23`, **`UserDownloads:2421`** — erano **2.393** il 26/08 e **2.383** il 25/08 sullo stesso id → **pagina viva, non cache** | 🟢 **PASSA** |
| **TradingView** | **200** | tag `/scripts/vwap/?script_type=strategies` → 21 anchor `ui-lib-card-link-title`; `pine-facade` restituisce il `source` | 🟢 **PASSA** — e §1-bis: **trovato l'endpoint di ricerca testuale** |
| **arXiv API** (`https://export.arxiv.org`) | **200** | `cat:q-fin.TR` recenti → titoli veri; `id_list=2605.04004` → abstract completo; **PDF scaricato (1,1 MB) e convertito** | 🟢 **PASSA** |
| **arxiv.org** (abs + pdf diretti) | **200** | `arxiv.org/pdf/2605.04004v2` → 1.130.529 byte | 🟢 **PASSA** (⚠️ `arxiv.org/html/...v2` → **404**) |
| **Quantpedia** | **200** | slug noto `turn-of-the-month-in-equity-indexes` → 221.164 byte | 🟡 **VIVA MA NON ENUMERABILE** (confermata la nota del 25 e del 26/08). **Non ricontrollarla per mandati intraday** |
| **GitHub** — `api.github.com/search` e `github.com/search` via `curl` | **403** | — | 🔴 **NULLA via curl — settima caccia di fila** |
| **GitHub** — via strumento `WebFetch` | **200** | `github.com/topics/expert-advisor?l=mql5.` → **20 repo con nome, owner, stelle e descrizione** | 🟢 **RIAPERTA** — §1-ter |
| **`raw.githubusercontent.com`** | **200** | file noto | 🟢 **PASSA** (chi conosce l'URL legge i file) |
| **SSRN** | **403** (Cloudflare) | — | 🔴 **NULLA — settima caccia di fila** |
| **Forex Factory** | **403** | — | 🔴 **NULLA — settima caccia di fila** |

### 1-bis. 🔓 TRADINGVIEW: L'ENDPOINT DI RICERCA — da mettere nel memo fonti

`PROMEMORIA_SBLOCCO_FONTI.md` documenta la strada a **tag** (25/08) e la sua
correzione (26/08: paginazione `/page-N/` inefficace col filtro strategie).
**Oggi ho trovato la strada migliore, ed è una sola richiesta:**

```
https://www.tradingview.com/pubscripts-suggest-json/?search=<query+urlencoded>
```

restituisce un JSON con, per ogni risultato:

| campo | cosa dà |
|---|---|
| `scriptIdPart` | **`PUB;<hash a 32 cifre>` GIÀ PRONTO** — salta del tutto il passo "apri la pagina script per estrarre l'hash" |
| `extra.kind` | `"strategy"` vs `"study"` → **separa le strategie backtestabili dagli indicatori senza filtro esterno** |
| `access` | **`1` = sorgente leggibile · `2`/`3` = protetto** → si sa PRIMA di sprecare una richiesta |
| `agreeCount` | i **like**: l'unica misura di popolarità che TradingView espone |
| `author.username` | l'attribuzione, obbligatoria per noi |

**Verificato oggi:** su `access=2` il `pine-facade` risponde
`{"code":401,"message":"User is not allowed to see source code of pine"}` —
provato su `MNQ Gap-Fade (ETH)` e `Opening Drive Continuation (NQ)`.
Su `access=1` restituisce il `source` completo. **Nessuna eccezione in 20
tentativi.**

⚠️ **Il limite della ricerca:** rende al massimo ~50 risultati per query e
**molte query naturali rendono ZERO** (`"DAX intraday"`, `"US30 intraday"`,
`"nasdaq intraday strategy"`, `"afternoon reversal"`, `"flat at close"`,
`"opening range fade"` → tutte 0). È un motore di **titoli**, non di
contenuti. Vanno usate **tante query corte**, non poche query precise.

### 1-ter. 🔓 GITHUB: È IL TRASPORTO, NON IL DOMINIO

Sei dossier dichiarano GitHub **NULLO**. La diagnosi era incompleta:
**`curl` è bloccato (403), lo strumento `WebFetch` no.** Oggi ho aperto e
letto `github.com/topics/expert-advisor?l=mql5.&o=desc&s=updated`.

🟠 **E il primo sguardo è deludente, e va detto subito:** dei 20 repo listati,
**la maggioranza è spam SEO** — repo `C#`/`HTML` con nomi tipo
`MT5-Trend-Direction-Predictor`, `Prop-Matrix-Engine`,
`PropFirm-Tracker-Elite`, 0-2 stelle su account creati per l'occasione, più
tre repo con **115-117 stelle** e descrizioni da vetrina
(`Risk-Nexus-Command`, `Forex-Trend-Dashboard-Engine`) che è il profilo
classico delle stelle comprate. **Niente `.mq5` di strategia, nessuna storia
dei commit da leggere.** 👉 Il canale è aperto: la miniera, su questo
bersaglio, sembra povera. Chi ci torna parta da **`WebSearch` + `WebFetch` su
un repo specifico**, non dai topic.

### Cosa ho sfogliato, dove ha funzionato

- **TradingView — due strade in parallelo:**
  - **34 tag** con filtro `script_type=strategies`: `pivotpoints,
    initialbalance, previousdayhighlow, gapfill, rangebreakout, endofday,
    timeofday, powerhour, lunch, newyorksession, gap, overnight, fade,
    exhaustion, donchian, keltnerchannel, rangebound, sp500, us30, ger40,
    nasdaq100, indexfutures, volumeprofile, valuearea, poc, tpo,
    cumulativedelta, absorption, swingfailure, dailyrange, firsthour,
    tradingsession, contrarian, reversion`.
    ⚠️ **Nove tag rendono ZERO strategie** (`previousdayhighlow`, `timeofday`,
    `powerhour`, `lunch`, `indexfutures`, `poc`, `tpo`, `dailyrange`,
    `firsthour`): il vocabolario dei tag non copre il nostro bersaglio.
  - **63 interrogazioni** all'endpoint di ricerca (§1-bis) → **~140 strategie
    uniche con hash, autore e like**, di cui **~50 con `access=1`**.
- **MQL5 Code Base — 8 pagine `experts` (le più recenti) → 320 titoli.**
  Filtro di questo mandato (`session|intraday|eod|end of day|camarilla|pivot|
  gap|daily range|adr|day trade`): **5 titoli su 320**, e **tre erano già
  noti** (KSQ FVG = P1 del 26/08, Nikkei Gap Continuation = già in casa,
  Session ORB = famiglia chiusa). **2 sorgenti `.mq5` nuovi scaricati e letti.**
  👉 **Quarta misura consecutiva che dice la stessa cosa.** Il consiglio del
  25/08 (_"smettere di ricrawlare il Code Base per gli indici"_) **regge, e lo
  confermo con un numero mio.**
- **arXiv — 6 query** + **il PDF di 2605.04004v2 scaricato e letto** (§5).

---

## 2. 🟢 IL PROMOSSO — uno, e non è un import

### 🥇 P1 — `Tristan's Box: Pre-Market Range Breakout + Retest` → **l'interruttore `InpRangeMode=1` che non abbiamo mai acceso**

```
NOME            Tristan's Box: Pre-Market Range Breakout + Retest
FONTE / URL     https://www.tradingview.com/script/839e843390ad4d4388a56f4e598fdd3c/
                (hash PUB;839e843390ad4d4388a56f4e598fdd3c)
                [rango: SORGENTE PINE LETTO RIGA PER RIGA, 179 righe]
AUTORE / DATA   OhRayOhRay — creato 2025-09-10T05:12:20Z   [VERIFICATO nel
                JSON pine-facade: scriptAccess "open_no_auth"]
LICENZA         🟢 Mozilla Public License 2.0, dichiarata alla riga 1 del
                sorgente. Attribuzione obbligatoria in testa a qualunque
                .mq5 derivato.
RIGHE / INPUT   179 righe · 8 input.() contati nel sorgente
COPIA IN CASA   biblioteca/sorgenti/TristansBox_PreMarketRangeRetest_
                OhRayOhRay-MPL2_tv839e843390ad_2026-08-28.pine
```

**TESI IN UNA RIGA**
> _"Il livello che conta all'apertura di New York non è il range dei primi
> minuti — che è rumore appena nato — ma il massimo/minimo che l'Europa ha già
> costruito nelle ore prima: ha più scambi dietro e più età, quindi più gente
> che lo difende. Chi rompe quel livello e poi ci torna sopra sta pagando il
> prezzo di chi lo teneva."_

**MECCANICA — tre righe, lette nel sorgente**
1. **Il livello (il motore):** box `04:00-09:30 ET` (righe 21-27, 43-45) —
   **cinque ore e mezza di pre-market**, non quindici minuti. Azzerato al
   cambio giorno (righe 38-41).
2. **Il grilletto:** rottura in **chiusura** oltre il box (righe 110-115),
   poi **tocco di ombra sul livello** (`low <= preHigh and high >= preHigh`,
   riga 121) e **la barra SUCCESSIVA chiude ancora fuori** (righe 128-132).
   **Un solo ingresso per lato al giorno** (`enteredLongToday`).
3. **L'uscita:** 🔴 **non c'è.** Vedi bandiere rosse.

**🔍 PERCHÉ NON È UN CADUTO — e questa è la parte che deve reggere fra un mese**

| | i caduti | questo |
|---|---|---|
| **il livello** | ORB: high/low dei primi **15-35 minuti** dopo la campanella. ~210 celle rosse a tick reali | **max/min delle ore PRIMA** dell'apertura. È un oggetto diverso: nasce da scambi già avvenuti, non dal rumore del primo quarto d'ora |
| **`RangeMode=2`** (candela H1 precedente) | misurato e morto: **OOS −2.444,14, PF 0,665, DD 26,29%** | `RangeMode=**1**` è la terza modalità, **mai misurata**: 47 file su 48 pinnano 0, uno spazzola 0→2. Il valore 1 non compare mai |
| **il modo di entrare** | breakout **al tocco** (capitolo chiuso) | **RETEST con LIMIT** — che non è un ramo mai provato: **è la modalità viva della sedia Dow** (`InpEntryMode=2`, R16d/R35/R46) |
| **MaxMinNotte** | box notturno **con ingresso a ROTTURA** (BUY/SELL STOP), e **misurato solo su DAX/FTSE/CAC/Stoxx** | stesso tipo di livello, **l'altro ingresso**, e **su un simbolo dove il box notturno non è mai stato provato** |

> 🎯 **La riga che riassume: non sto proponendo un motore nuovo. Sto proponendo
> di cambiare UN input di una sedia viva — quello che decide DA DOVE viene il
> livello — e di misurare le tre cose che il mandato chiede (dimensione, età,
> invalidazione del livello) su un asse ciascuna. Zero righe di codice.**

**BANDIERE ROSSE §4 — DUE, e sono nella GESTIONE, non nel motore.**

1. 🔴 **NESSUNO STOP LOSS.** `useStop = input.bool(false, ...)` (riga 9): di
   default non c'è. **E quando lo si accende è rotto:**
   ```pine
   strategy.entry("Long entry", strategy.long)
   ...
   strategy.exit("XL", "Long_PM_Retest", stop=close*(1-stopPerc/100), ...)
   ```
   `strategy.exit` cita l'id di ingresso `"Long_PM_Retest"`, ma l'ingresso si
   chiama **`"Long entry"`**: **lo stop non si aggancia mai a nessuna
   posizione.** Non è un'opinione, è la riga 140 contro la riga 136.
2. 🔴 **NESSUN FLAT DI FINE SESSIONE** — cioè manca proprio il requisito C0 di
   questo mandato. Più `default_qty_value=2` (% dell'equity) al posto del
   rischio in percentuale.

> ✅ **E qui il §5F è esplicito: il marciume nel MOTORE non si rifinisce, una
> gestione assente sì.** Il motore (quale livello, come si conferma) è sano e
> leggibile; la gestione è tutta da mettere — e **noi ce l'abbiamo già scritta
> e validata**: `InpCloseAtEnd=1`, `InpMinStopPts=500` (pavimento SL, lezione
> R109), parziale 1R + breakeven + runner, rischio in %, `InpOneTradePerDay`.

**🔧 COSA TERREI / COSA RIFAREI**

**DA TENERE (il motore):** il livello dal **pre-apertura** invece che dal
post-apertura · la conferma a **due barre** (tocco di ombra, poi chiusura
ancora fuori) · **un solo ingresso per lato al giorno**.

**DA RIFARE (tutta la gestione, e non è un difetto: è la nostra parte):**

| difetto nel Pine | cosa ci mettiamo (già in casa) |
|---|---|
| stop assente e, se acceso, **non agganciato** | SL vero + `InpMinStopPts=500` (pavimento R109) |
| nessun flat di sessione | `InpCloseAtEnd=1` + `InpCloseHour/Min` in **ora server** |
| sizing al 2% fisso dell'equity | `InpRiskPercent` (1% nello screening, 0,65% a taglia prop) |
| TP percentuale secco | parziale 1R + breakeven + runner, la gestione delle sedie vive |
| orari in **ET** hardcoded | ora **SERVER BCM** = ora italiana − 1 (Dow 14:30 server) |

**💰 COSTO DI PORTING: ZERO ORE DI CODICE.** È un file prova.
`ABTG_Dow_Apertura_US.mq5` ha già `ABTG_RANGE_PREV=1` (riga 198) e
`InpPrevWindowMin` (riga 233), usati alle righe 825 e 1028.

**📊 COSTO-SOPRAVVIVENZA (C1) — il conto fatto prima del tester**

| | stima | fonte |
|---|---|---|
| **SL** | estremo opposto del livello + buffer, pavimento **500 punti MT5 = 5 punti indice** | `InpMinStopPts` pinnato nelle celle vive |
| **take atteso** | ≥ 1R al parziale → **≥ 5 punti indice**, e il runner oltre | geometria della sedia viva |
| **rapporto take/spread** | **~2,5-5×** contro una soglia di 3× | ⚠️ **CADE NELLA FASCIA GRIGIA di `METRO_PROP` D4 (2,5×-3,5×): lì il verdetto NON si dà**, si misura lo spread col *RealCost Spread P95 Logger* (Code Base 74148, promosso il 23/08 e **ancora mai usato**) e si rilegge. **Lo dichiaro invece di arrotondare in mio favore.** |
| **trade/giorno** | **≤ 1 per simbolo per lato** (`InpOneTradePerDay`) | tetto meccanico |

⚠️ **Il rischio numero uno, dichiarato prima dei numeri: la FREQUENZA.** Un
ciclo al giorno su ~450 sedute è il tetto assoluto; se il retest non arriva, la
giornata salta. **Se n(OOS) < 30 scatta la valvola R59** — il round misura il
**RISCHIO** (DD, peggior giornata: fatti accaduti) e **sospende il giudizio sul
MERITO**. È scritto nel file prova come PASSO 0, non come nota a piè di pagina.

```
PUNTEGGIO
  [2] semplicita' — 179 righe, 8 input; e da noi diventa DUE assi
  [2] il filtro E' il motore — il livello E' la strategia. Non c'e'
      nessun interruttore appiccicato: si cambia DA DOVE viene il
      livello, tutto il resto resta pinnato alla sedia viva
  [2] tesi di mercato scrivibile — sopra, e dice CHI sta dall'altra parte
  [1] riempie un BUCO — livello pre-apertura mai misurato + Dow mai
      provato col box notturno. Ma NON e' un buco di FASCIA ORARIA:
      lavora alla campanella, dove la flotta gia' sta
  [2] testabile senza riscritture — e' un file prova, zero codice

VERDETTO   🟢 PROVA SUBITO (9/10)
PERCHE'    e' l'unica cosa trovata oggi che si puo' mettere nel tester
           domani mattina senza scrivere una riga, che soddisfa da sola
           il requisito "mai overnight", e che misura le tre domande del
           mandato (dimensione / eta' / invalidazione del livello) su un
           asse ciascuna invece che a chiacchiere.
```

**🏛️ IN OTTICA PROP.** Il pregio: **flat obbligatorio** già nel codice
(`InpCloseAtEnd`), **un ciclo al giorno** già nel codice — il muro giornaliero
dei −5.000 € su 100k non può essere sfondato da questo motore se non con un
singolo stop, e la peggior giornata delle celle vive di questa famiglia è
**−1,03%** (R62) / **−2,45%** (R112 EMADOW). Il difetto, e va detto: **entra
alla campanella del Dow, cioè nella stessa mezz'ora in cui entrano già la
sedia Dow Apertura e la sedia EMADOW.** `ROTTA_PROP` regola 1 — _"mai due EA
sullo stesso segnale/simbolo/lato allo stesso rischio pieno"_ — **morde qui**:
se le celle promosse dovessero scattare negli stessi giorni della sedia viva,
il candidato va scartato per **correlazione**, non promosso perché redditizio.
👉 **La sovrapposizione delle giornate va misurata, non stimata**, ed è un
criterio d'uscita scritto nel file prova.

**📦 FILE PROVA:** `backtest_pipeline/prove/PREOPEN_RETEST_DOW_M15.txt`
(scritto, con ipotesi e criteri congelati prima dei numeri, e il cartello
_"non deve girare finché i criteri non sono firmati"_). Magic vergini
**773500/773501** — verificati liberi in tutto il repo il 28/08/2026.
Gemello short **obbligatorio** (magic 773600/773601, anch'essi verificati
vergini): regola dei due lati del 25/08.

---

## 3. 🗑️ GLI SCARTATI — una riga di motivo a testa

### 3.1 Il caso che merita più di una riga: il **FADE DEL GAP D'APERTURA**

`SP500 Session Gap Fade Strategy` — **exlux**, TradingView, creato
2025-11-16, MPL 2.0, 142 righe, 9 input, **101 like**
([hash `PUB;da73a87567274d51bedae71a254bc9ab`](https://www.tradingview.com/script/da73a8756727/)).
Sorgente letto riga per riga, copia in biblioteca.

Era **il candidato più promettente per tesi** di tutta la caccia: fade del
gap, `flat_before_min=60` (flat forzato 60 minuti prima della chiusura),
SL = 1,0 × la distanza del gap. Cioè **un mean-reversion su un livello
infragiornaliero diverso dalla VWAP**, esattamente ciò che il mandato chiede.

🔴 **È SCARTATO, e per DUE ragioni indipendenti che si sommano.**

**(a) È un doppione di casa, e la nostra versione è MIGLIORE.**
`ABTG_Nasdaq_Apertura_US.mq5` ha `InpEntryMode=GAPFILL`, misurato in **due
round indipendenti**: R61 e R62 danno la stessa cella **al centesimo**
(RR 1,0 / pts 30-50 → OOS **+7.649,67 · PF 2,007 · n=26 · DD 3,91% · peggior
giornata −1,03%**, `REFERTO_ROUND62_GAPFILL_SOGLIA_BASSA.md`).
E la nostra **non è lo stesso meccanismo**: il file prova
`ABTG_Nasdaq_Apertura_US_GAP.txt` (righe 1456-1481 del sorgente, citate lì)
documenta che il GAPFILL entra con uno **STOP dalla parte OPPOSTA al gap** —
cioè **pretende che il gap PRIMA FALLISCA**. È un _failed opening drive_,
non un fade. Il Pine di exlux entra **a mercato, subito, senza conferma**.

**(b) La versione SENZA conferma è falsificata fuori, con un campione grande.**
arXiv **2605.04004v2** (Mesfin 2026), tabella 5, MNQ 5-min, 947 sedute
2021-2025, attrito 2,0 punti — **PDF letto per intero oggi**, e già agli atti
in `report/SWEEP_MECCANISMI_2026-08-23.md`:

| strategia | ingresso | N | netto medio | T | verdetto |
|---|---|---:|---:|---:|---|
| Gap Fill Fade | 09:30 | 238-245/anno | **−1,92 pt** | −0,44 | FAIL |
| Gap Fill Fade | 09:45 | 238-245/anno | **−1,31 pt** | −0,32 | FAIL |
| Gap Fill Fade | 10:00 | 238-245/anno | **−2,24 pt** | −0,59 | FAIL |

> 🎯 **La lettura congiunta è più utile di entrambe le fonti da sole: il fade
> del gap SENZA conferma è morto su ~240 occasioni l'anno; il fade CON
> conferma (il nostro) è vivo su 26. La variabile discriminante è la
> CONFERMA, non il gap.** Questo è il valore vero di aver letto il Pine: non
> un candidato, ma la conferma per contrasto di una cosa che avevamo già e
> non avevamo capito perché funzionava.

🔵 **E resta un compito aperto in casa, che questa caccia ha ri-illuminato:**
`report/BILANCIO_16-08.md` §4 punto 5 chiede la **sonda sessione**
(`ABTG_SondaSessione.mq5`, **scritta e mai lanciata**) per stabilire se il
GAPFILL intercetta il gap della **campanella** o quello del **fine settimana**
— perché su un CFD che gira 24/5 il gap D1 è quasi sempre ~0 [INFERITO nel
file prova dalle righe 1425-1429 del sorgente]. **Dodici giorni dopo la sonda
non è mai stata lanciata.** Finché non lo è, il GAPFILL non si può estendere
a DAX e Dow: si rischia di misurare due volte il gap del weekend, che
`ABTG_GapFill` copre già (e che in forward fa **zero trade su 5 magic**,
`CENSIMENTO_FREQUENZA_FLOTTA_2026-08-22.md` §6).

### 3.2 TradingView — gli altri 13 letti nel sorgente

| candidato | autore / hash | meccanismo | motivo dello scarto |
|---|---|---|---|
| `NY VIX Channel Trend Strategy` | exlux · `cf5339409b5b…` · 106 like · MPL2 | canale = apertura di sessione × (1 ± VIX9D/100/√252), bias = **segno dei primi 30 minuti**, flat 30' prima della chiusura | 🟠 **SCARTATO, SPUNTO TENUTO.** Il predittore di direzione **è quello di R98** (segno dei primi 30 minuti), **0/6 in casa, lordo −0,31 punti su 410 op**. Più: serve il simbolo **VIX**, che non sappiamo se BCM espone (**[INCERTO]**). ✅ **Lo spunto vale**: la larghezza della giornata presa dal **mercato delle opzioni** invece che dall'ATR è l'unica idea davvero nuova vista oggi |
| `Gap Absortion Strategy` | noop42 · `69ecc82a6909…` · MPL2 | fade del gap barra-su-barra, **SL = 0,25 × gap, TP = 0,80 × gap** | 🔴 **stop VIRTUALE** (`exitSL = ta.cross(close, stop)` → chiusura di barra, non ordine al broker) + nessun rischio % + nessun flat. E il fade nudo è §3.1. ✅ Spunto: la geometria **stop = frazione del gap** dà R:R 3,2:1 per costruzione |
| `Initial Balance BO Strategy` | MIKMani · `4732849691c1…` · 369 like · MPL2 | IB di **55 minuti**, rottura in chiusura di IBH/IBL, SL 0,75 × range IB, TP 2 × range IB, `close_all` a fine giornata | 🔴 **famiglia ORB** (capitolo chiuso, ~210 celle). Più `default_qty_type=strategy.fixed, value=1` = **lotto fisso**, orari **hardcoded sul mercato indiano** (09:15 / 15:25), e asimmetria da ottimizzatore: `buy_count < 3` contro `not sell_taken` |
| `Session Opening Range Breakout (ORBO)` | AIScripts · `e36c6ad741f2…` · 166 like | ORB di sessione, 77 righe, 3 input | 🔴 famiglia ORB |
| `Power Hour Money Strategy` | gggoaaat · `1756a6ab1965…` · 186 like · MPL2 | ingresso quando **H4, H1, M15 e M3 sono tutte verdi** nella finestra NY 09:30-11:30, chiusura a fine giornata | 🔴 **confluenza senza tesi** (quattro TF allineati non dicono *perché*), **nessuno SL fisso** (solo trailing 0,2%, cioè stop strettissimo = la causa fotografata dei DD del 56% in R109), nessun rischio %. ✅ Unico pezzo buono: il flat a fine giornata |
| `NQ HMA Midday Strategy` (`Prod_1st_NQ15HMADY`) | QuantByBoji · `f519c1242fb9…` · MPL2 | HMA su high/low + EMA200 + ROC, sessione 08:30-15:45, `close_all` fuori sessione | 🔴 **cicatrice da ottimizzatore visibile nel sorgente**: ~30 condizioni commentate riga per riga, **lo short è definito ma il suo `strategy.entry` è COMMENTATO** (riga 154) e `strategy.exit` cita `from_entry='short'` che non esiste. Tick size **`/0.25` hardcoded** su NQ. Non è misurabile |
| `CamarillaStrategyV1` | cristian.d · `PUB;1913` · **2.293 like** | rottura dei livelli **H4/L4 di Camarilla** calcolati sul giorno precedente + EMA8 | 🔴 Pine **v2**, `trail_points`/`loss` **hardcoded e ASIMMETRICI** (long 40/70, short 10/20 = cicatrice), nessun rischio %, nessun flat. ⚠️ `security()` in v2 non ha `lookahead` esplicito → **[INCERTO]** sul repaint, mitigato dall'uso di `[1]`. ✅ **Spunto forte**: i livelli Camarilla sono una **famiglia di livelli intraday derivati dal giorno prima che non abbiamo** — e sono *statici per tutta la seduta*, cioè l'opposto della VWAP |
| `Previous Day High and Low Breakout Strategy` | ceyhun · `c3wgFOxdo49I…` · **953 like** · MPL2 | rottura del massimo/minimo di ieri | 🔴 **31 righe, ZERO input, NESSUNO stop loss, nessuna uscita** (solo il segnale opposto), nessun flat. È un indicatore travestito da strategia |
| `Yesterday's High` | TheSocialCryptoClub · `a911eb8fc372…` | rottura del massimo di ieri con filtro ROC, trailing | 🔴 **LONG ONLY**, SL/TP in **% del prezzo** (3% / 9%: su un Dow a 45.000 sono 1.350 / 4.050 punti indice), nessun flat. ⚠️ **Licenza CC BY-NC-SA 4.0 = NON COMMERCIALE**: anche se fosse buono, non si porta su un conto prop. ✅ Usa l'idioma anti-repaint `f_security` di LucF/PineCoders — quello sì, è buono |
| `Breakouts With Timefilter Strategy [LuciTech]` | LuciTech · `0abf03b0c999…` | rottura di pivot(5) dentro una finestra oraria, SL ATR/candela/punti, RR 3 | 🔴 **breakout puro al tocco** su livello pivot + **filtro orario e filtro MA entrambi OPZIONALI** = il pattern §5B (0 successi su 5). Nessun flat. ✅ Ha il **sizing a rischio % scritto bene** (`risk_amount / stop_distance`) |
| `Range Trading Strategy` | gyorkyd030829 · `f1645deb9294…` · 117 like | range di sessione/HTF con concetto di **mitigazione** | 🔴 `default_qty_value=10` (% equity, non rischio), **`reverseOnStopLoss`** = apre l'opposto dopo lo stop (**recovery, §4**), nessun flat. ⚠️ **letto solo in parte** (intestazione, 19 input, logica di sessione): 544 righe, e i tre difetti bastavano |
| `[KL] Relative Volume + ATR Strategy` | DojiEmoji · `e01509a19a54…` · 341 like · MPL2 | volume > 1,5 × SMA(20) **e** ATR dentro ±1σ della propria media | 🔴 **LONG ONLY**, `pyramiding=1` con commento `"adding"` (si somma alla posizione), **stop virtuale** (`strategy.close` su chiusura di barra), nessun rischio %, nessun flat. ✅ **Spunto vero e nuovo**: `ATR_volat < media + σ and > media − σ` non è "volatilità alta" né "bassa" — è **volatilità NORMALE**, un filtro di regime che non abbiamo in nessun EA |
| `Daily Open Strategy (DOS)` | xtradernet · `VVkw2nUXcn28…` · 93 like · MPL2 | (il nome inganna) trigger sul corpo della candela precedente | 🔴 **100% dell'equity per trade**, TP/SL in "pips" fissi (200/1000), finestra di date hardcoded 2015-2020. Niente a che vedere con l'apertura giornaliera |

### 3.3 MQL5 Code Base — i 2 sorgenti nuovi letti

| # | file | id / autore / data / DL | righe · input | verdetto |
|---|---|---|---|---|
| 1 | `Price Action Intraday Trading - Expert for MT5` | [68704](https://www.mql5.com/en/code/68704) · `l2carbon` · 2026.01.30 · **DL 5.423** | 1.237 · 29 | 🟠 **Il più vicino al mandato di tutto il Code Base — e comunque scarto.** Ha `CloseAtEndOfDay=true`, `MaxDailyLoss=3.0`, `RiskPercent`, breakeven e trailing: la gestione è seria. **Ma il motore no:** `signal = PinBar OR Engulfing OR InsideBar`, ciascuno filtrato da un incrocio MA — **tre pattern indipendenti in OR** = fabbrica di combinazioni, non una tesi; `StopLossPips=40` **fisso** (non strutturale); **29 input** contro il tetto di ~15; e **nessun `OnTester`** → il nostro driver non parte |
| 2 | `Tuyul GAP` | [60347](https://www.mql5.com/en/code/60347) · `zvickyhac` · 2025.06.11 · DL 1.629 | 327 · 13 | 🔴 **`LotSize=0.1` fisso**, `StopLoss=60` punti fisso, `SecureProfitTarget` **in USD assoluti** (non scalabile a 100k), e il meccanismo è la **doppia pendente del venerdì 23:15** = il gap del **weekend**, che `ABTG_GapFill` copre già |
| 3 | `Session Opening Range Breakout EA` | [76153](https://www.mql5.com/en/code/76153) · `Stridz_z` · 2026.08.15 · DL 286 | 466 · 22 | 🔴 **famiglia ORB, capitolo chiuso.** _Va detto che il codice è pulito_ (rischio %, SL oltre il bordo opposto, RR 2, 1 trade/sessione, due lati): è uno scarto di **famiglia**, non di qualità |

### 3.4 Scartati al primo taglio (titolo + metadati, sorgente NON aperto — e lo dichiaro)

Dalle ~140 strategie raccolte con hash e autore:
- **`access=2` o `3` = sorgente protetto** → `pine-facade` risponde 401. Sono
  **~90**, fra cui `MNQ Gap-Fade (ETH) — RTH 08:30-15:00 CT` (hargo1980),
  `Opening Drive Continuation (NQ)` (joetroyer), `Only CPR Strategy`
  (Manoj-verma, 682 like), `Auction Market Theory: Value Area & VWAP Fade`
  (ra1986ju, 140 like), `Quantcrawler ORB Strategy` (2.008 like),
  `Previous Day Breakout Trend Following` (bsjawle). **Niente sorgente =
  niente setaccio §4 = non esistono come candidati.**
- **famiglia ORB dichiarata nel titolo** → `Session Breakout Scalper Trading
  Bot`, `ORB Pro | Session Breakout Scalper`, `Breakout Scalper (Session)`,
  `Estrategia de NY ORB por CP`, `CP Strat ORB`, `OR Breakout Retest`,
  `Frist 5-Min Breakout + Retest`, `Initial Balance Breakout [samjNQ] v3`,
  `Opening-Range Breakout`, `Pro Trading Art Open Range Breakout`,
  `[STRATEGY][RS]Open Session Breakout Trader` (2.654 like),
  `ORB Heikin Ashi SPY 5min` (2.297 like).
- **overnight per costruzione** (il contrario del mandato) →
  `Overnight Positioning w EMA`, `AI MES Globex Overnight Strategy`.
- **mercato o strumento sbagliato** → tutta la nube `SPY/QQQ/TQQQ/0DTE` di
  `PtGambler`, `exlux`, `TheIndicatorClub` (opzioni, ETF, giornaliero), le
  varianti cripto (`XRP AI 15-m`, `BTC 4H v5.5`, `Bithanos`), i forex
  (`London Breakout GBP/USD`, `DayFlow VWAP Relay`, `Breakout asia USD/CHF`).
- **`TICK` di NYSE** (`TICK Scalping strategy, SPY 1 min`, 1.810 like;
  `TICK strategy for SPY options`, 843) → il dato **non esiste in MT5**.
- **nomi da prodotto / confluenze senza tesi** → `Master Multi-Asset
  Confluence`, `Concordance Execution Mandate [JOAT]`, `TrendPilot AI v2`,
  `AlgoSentry Index-Futures Strategy`, `Quantum`-simili.

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| oggetto | perché |
|---|---|
| **~90 script TradingView con `access=2/3`** | sorgente protetto (401 dal `pine-facade`). Fra questi ci sono i **due più interessanti per titolo** di tutta la caccia: `MNQ Gap-Fade (ETH) — RTH 08:30-15:00 CT` e `Opening Drive Continuation (NQ)`. **Non li ho letti, non li giudico** |
| **SSRN e Forex Factory** | 403, **settima caccia di fila**. Forex Factory resta l'unico posto dove si legge *come invecchia* una strategia, e continua a mancarci |
| **GitHub oltre la pagina topic** | il canale è aperto via `WebFetch` (§1-ter) ma **non ho esplorato repo singoli**: il topic list era spam SEO e il budget è finito. **È il buco che lascio aperto per il prossimo**, con la strada ora documentata |
| **Lo spread reale BCM su U30USD/D30EUR/NASUSD in fascia M15** | **[NON MISURATO]**. Il criterio C1 di questa caccia poggia sul "1-2 punti indice" di `R98_CRITERI.md`, che non è una misura nostra ripetibile. Il *RealCost Spread P95 Logger* (Code Base 74148) è promosso dal 23/08 e **ancora mai usato**: è il pezzo che manca per dare il verdetto del promosso |
| **Se BCM espone un simbolo VIX** | **[INCERTO]**, non verificato. Blocca lo spunto del canale a volatilità implicita |
| **`ABTG_SondaSessione.mq5`** | scritto, **mai lanciato dal 16/08**. Finché non gira, non sappiamo se il GAPFILL vive sul gap della campanella o su quello del weekend |

---

## 5. 🧭 SCOPERTE TRASVERSALI (valgono oltre questa caccia)

1. 🔓 **TradingView: usare l'endpoint di ricerca, non i tag** (§1-bis). Dà
   hash, autore, like e `access` in una richiesta. **Va messo in
   `PROMEMORIA_SBLOCCO_FONTI.md`.**
2. 🔓 **GitHub non è bloccato: è bloccato `curl`.** `WebFetch` passa (§1-ter).
   Sei dossier lo davano per nullo; la diagnosi era sul dominio, il problema
   era sul trasporto.
3. 🧱 **Il Code Base è esaurito su questo bersaglio — quarta misura
   consecutiva.** 320 titoli recenti, **5 match**, **3 già noti**. Il consiglio
   del 25/08 (_"smettere di ricrawlare il Code Base per gli indici"_) è
   confermato con un numero nuovo.
4. 📐 **Il difetto ricorrente non è la martingala: è lo STOP e il FLAT.** Sui
   **15 Pine** letti oggi: **7 non hanno stop loss vero** (assente, virtuale,
   o rotto per bug di id) e **10 su 15 non hanno nessuna chiusura di
   sessione**. 👉 **Filtro di primo taglio per la prossima caccia su questo
   mandato: `strategy.close_all` / `strategy.close(...)` legato a un orario.
   Se non c'è, non si legge oltre.** Costa un `grep` e taglia i due terzi.
5. 🎯 **La variabile discriminante del gap è la CONFERMA, non il gap** (§3.1).
   Fade nudo: 240 occasioni l'anno, T ≈ −0,4, morto. Fade che pretende il
   fallimento del gap: 26 occasioni, PF 2,007. **Vale come regola generale
   per tutta la famiglia "contro il movimento": la conferma non è un filtro
   appiccicato, è ciò che separa i due meccanismi.**
6. 💡 **Tre spunti di meccanica raccolti dagli scartati**, che costano poco:
   - **livelli Camarilla H4/L4** (da `CamarillaStrategyV1`): livelli intraday
     **statici** derivati dal giorno prima — l'opposto della VWAP, e una
     famiglia di livelli che non abbiamo in nessun EA;
   - **volatilità NORMALE come regime** (da `[KL] Relative Volume + ATR`):
     `ATR dentro ±1σ della propria media` — non alta, non bassa: *usuale*;
   - **larghezza della giornata dalla volatilità implicita** (da `NY VIX
     Channel`): il canale della seduta preso dalle opzioni invece che
     dall'ATR. Subordinato a: BCM espone il VIX? **[INCERTO]**
7. 🕐 **La fascia 10:00-16:00 server sugli indici resta VUOTA nella flotta** —
   confermato oggi, e **il promosso di oggi NON la riempie** (entra alla
   campanella). Chi cerca scorrelazione vera deve cercare lì, e in questa
   caccia non ho trovato niente di leggibile che ci lavori.

---

## 6. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> **"Il RETEST — l'unica geometria che nei nostri referti ha sempre pagato, e
> che è già la modalità viva della sedia Dow — cambia risultato se il livello
> smette di essere il range dei primi 35 minuti e diventa il massimo/minimo
> costruito nelle ORE PRIMA dell'apertura?"**
>
> Cioè: **conta la geometria dell'ingresso, o conta l'età e la dimensione del
> livello su cui la si applica?**
>
> Se **sì**: abbiamo un motore che chiude sempre in giornata (requisito del
> mandato soddisfatto dal codice, non da una promessa), a costo zero di
> sviluppo, e sappiamo che la variabile che conta nei livelli è l'**età**.
> Se **no**: abbiamo chiuso `RangeMode=1` — la terza e ultima modalità di
> livello di questa famiglia — e la famiglia "aperture" è misurata per intero
> su tutte e tre le sue definizioni di livello. **Un'informazione che oggi non
> abbiamo, e che vale i prossimi tre agenti che proporranno "proviamo un altro
> range".**

---

_Dossier compilato il 28/08/2026 dall'agente `cacciatore-strategie`._
_Fonti aperte davvero: **TradingView** (34 tag + 63 query di ricerca, ~140
strategie con hash e autore, **15 sorgenti Pine scaricati e letti**),
**MQL5 Code Base** (320 titoli, **3 sorgenti `.mq5` letti**), **arXiv API +
PDF** (6 query, **1 paper letto per intero**), **GitHub via `WebFetch`**
(1 pagina topic), **Quantpedia** (controllo positivo)._
_Fonti dichiarate NULLE: **SSRN**, **Forex Factory**, **GitHub via `curl`**._
_**Nessun numero di performance dichiarato da un autore è stato usato in
nessun punteggio di questo dossier.**_

_Attribuzione, come da regola di casa — va ripetuta in testa a qualunque
`.mq5` o file prova derivato:_
- _`Tristan's Box: Pre-Market Range Breakout + Retest` è di **OhRayOhRay**, **licenza MPL 2.0** (TradingView, 10/09/2025)_
- _`SP500 Session Gap Fade Strategy` è di **exlux**, **licenza MPL 2.0** (TradingView, 16/11/2025)_
- _`NY VIX Channel Trend Strategy` è di **exlux**, **licenza MPL 2.0** (TradingView, 02/11/2025)_
- _`Gap Absortion Strategy` è di **noop42**, **licenza MPL 2.0** (TradingView, 31/12/2021)_
- _`Initial Balance BO Strategy` è di **MIKMani**, **licenza MPL 2.0** (TradingView, 26/06/2026)_
- _`Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures` è di **Mathias Mesfin**, arXiv **2605.04004v2** (05/05/2026)_
