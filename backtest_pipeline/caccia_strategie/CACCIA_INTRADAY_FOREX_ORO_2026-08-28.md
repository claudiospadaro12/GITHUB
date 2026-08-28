# 🏹 CACCIA INTRADAY — FOREX + ORO, CHIUSURA OBBLIGATORIA IN GIORNATA (28/08/2026)

**Mandato (sessione principale, 28/08):** motori **intraday** su **forex
majors** e **oro/argento**, timeframe **M15-H1**, con un requisito **non
negoziabile**: _il motore deve chiudere tutte le posizioni entro la
sessione/giornata, **mai overnight**_.

**Perché il requisito è vincolante (contesto FTMO, scoperto la notte del
28/08):** il conto **FTMO Standard** (leva **1:100**) impone le restrizioni
overnight/weekend/news **solo sul conto FINANZIATO**, non in Evaluation. Un
motore che chiude sempre in giornata **evita il problema alla radice** e ci
permette di restare a 1:100 invece di scendere a **1:30** (conto Swing, che
triplicherebbe il margine). ➡️ **Ogni EA intraday vero trovato oggi vale
doppio: aggiunge frequenza E toglie la dipendenza dal downgrade di leva.**

---

## ⚡ IL RISULTATO IN UNA RIGA

> **Su 9 canali passati al controllo positivo (5 vivi, 3 muti da sette cacce,
> 13 host bloccati all'egress), 1.598 titoli del Code Base ricrawlati
> (catalogo COMPLETO: pagina 41 = 0 elementi), 26 tag TradingView interrogati
> per 236 strategie uniche **più 10 query alla ricerca testuale** (canale
> nuovo, §1-quater), 8 query arXiv, 1.118 slug Quantpedia enumerati e 4 query
> al motore di ricerca — sono arrivato al SORGENTE su 28 oggetti
> (22 Pine + 6 `.mq5`). Ne propongo DUE, più DUE specifiche. E il primo NON è
> un EA: è un MECCANISMO di letteratura peer-review che il progetto non ha
> mai misurato, e la cui prova costa UNA passata di tester.**
>
> 🔴 **La risposta scomoda va detta subito: il web gratuito, sul bersaglio
> "motore intraday con flat obbligatorio a fine sessione su forex/oro", ha
> UN SOLO oggetto leggibile e neanche eccezionale.** Su 236 strategie
> TradingView raccolte e 17 Pine letti riga per riga, **una sola** ha tutte e
> quattro le cose insieme (finestra d'ingresso di sessione + `close_all` a
> fine sessione + rischio in % + take ben sopra il costo). Una. Le altre
> sedici sono senza stop, con la tesi dentro un `input`, col 100% dell'equity
> per operazione, o tengono la posizione per giorni.
>
> 🟢 **La cosa che vale di più, invece, non viene dal codice: viene da due
> paper di prima fascia (Journal of Money, Credit and Banking 2013 e
> Journal of Finance 2024) che dicono la stessa cosa a undici anni di
> distanza — le valute hanno una DERIVA DIREZIONALE legata all'ORA DEL
> GIORNO, con una controparte identificata.** È il motore più semplice che
> abbia mai proposto (zero indicatori, due parametri, flat per costruzione),
> è strutturalmente scorrelato da tutte e 36 le sedie, ed è **misurabile in
> una passata**. ⚠️ **E ha un limite che dichiaro PRIMA del punteggio: i
> due paper NON li ho potuti aprire** (§4).

---

## 0. 📕 LA LISTA DEI CADUTI — riletta PRIMA di uscire

Compresa quella del mandato: `REGISTRO_TEST.md`, i dossier del 25/08 e 26/08,
e — **novità di oggi** — i due file `report/SWEEP_MECCANISMI_*` che
contengono scarti che **non sono indicizzati** in `SETACCIO_MANUALE.md`
(§6, rilievo di processo).

| caduto | dove | verdetto misurato |
|---|---|---|
| **capitolo BREAKOUT M5/ORB** | `REGISTRO_TEST.md` §2, `SETACCIO_MANUALE.md` | **CHIUSO 26.07.26** a tick reali; ~210 celle. _"il breakout puro al tocco è morto ovunque"_ |
| **R45 — ORB di sessione (Londra)** | `REFERTO_ROUND45_LONDRA.md` | **0 celle positive su 48** (GBPUSD/EURUSD/XAUUSD) |
| **R42/R43 — fade degli estremi d'apertura** | `REFERTO_ROUND42_FADE.md` | **0/24 IS e 0/24 OOS**. _"è morto il MOTORE, non la gestione"_ |
| **R60 — `ABTG_MeanRevert`** | `REFERTO_ROUND60_MEANREVERT.md` | **12 celle su 12 in perdita** (fade a N barre senza regime) |
| **R95 — sweep + reclaim** | `R95_REFERTO.md` | **30 passate su 30 in perdita**, n da 149 a 3.641 |
| **R98 — intraday momentum (Gao)** | `R98_REFERTO.md` | **0/6**, cancello zero matematicamente impossibile |
| **R63 — Turnaround Tuesday / calendario** | `REFERTO_ROUND63_64` | **0/24 OOS su 11.928 operazioni. Famiglia chiusa** |
| 🆕 **R108 + R111 — la discesa di TF del Breaking Band** | `R108_REFERTO.md`, `R111_REFERTO.md` | gradiente **MONOTONO H1 > M30 > M15**; a M15 **6 finestre su 6 rosse**. ➡️ **la porta "abbasso il TF di un motore vivo" è CHIUSA** |
| 🆕 **D7 — WM/Reuters 4pm fix** | `SWEEP_MECCANISMI_LIBERI_2026-08-22.md` §D7 | Michelberger & Witte 2015, PDF letto: **volatilità sì, DIREZIONE no** (_"the data does not show any significant correlations"_); effetto confinato al **minuto** delle 16:00; campione **pre-riforma 2015** |
| 🆕 **D5 — `20 Pips Opposite Last N Hour Trend` / `10pipsOnceADay...`** | idem §D5 | **martingala dichiarata negli input** (×2 ×4 ×8 ×16 ×32) |
| 🆕 **D8 — Cotter & Dowd 2011** (arXiv 1103.5664) | idem §D8 | stagionalità intragiornaliera su **DEM/USD**: il marco non esiste dal 2002. **Cultura, non candidato** |
| **S13 — stagionalità dell'ORO** | `SWEEP_MECCANISMI_2026-08-23.md` §S13 | Bartsch/Baur/Dichtl/Drobetz: delle **4.096** allocazioni stagionali testate, **nessuna sopravvive allo SPA-test di Hansen**. Pista chiusa dalla FONTE |
| **volume come conferma su FX/oro** | `REGISTRO_TEST.md` §REGOLE PAOLO | _"Volumi affidabili **SOLO sugli indici**, NON sulle valute"_ (su forex/CFD è tick volume) |
| **filtro appiccicato a motore già tarato** | `ROBUSTEZZA.md` §5B | **0 successi su 5** (R20, R12, R26, R45, R54) |

### ⚠️ Il caduto che riguarda direttamente il mio P1, e lo nomino PRIMA di proporlo

**D7 ha già chiuso "l'ora del fix" il 22/08.** Il mio P1 **non è quello**, e il
carico della prova sta su di me: D7 misurava **la volatilità nel minuto**
delle 16:00 Londra e non trovava direzione; P1 è una **deriva direzionale su
un BLOCCO DI ORE** (la sessione locale intera), misurata su campioni diversi,
da autori diversi, in due riviste diverse, e — nel caso del 2024 — **con dati
POST-riforma**. Sono due affermazioni economiche distinte. **Ma chi legge deve
sapere che il progetto ha già detto NO a un cugino di questo meccanismo**, ed è
esattamente il motivo per cui il primo round che propongo è **una MISURA e non
una strategia** (§2, P1).

---

## 1. 📡 CONTROLLO POSITIVO — misurato oggi, 28/08, canale per canale

| canale | HTTP | bersaglio noto verificato OGGI | esito |
|---|---|---|---|
| **MQL5 Code Base** | **200** | id **68951**: `datePublished":"2026-03-23T13:23:44"`, **`UserDownloads:2421`** — erano **2.393** il 26/08 e **2.383** il 25/08 sullo stesso id → **la pagina è viva, non una cache** | 🟢 **PASSA IN PIENO.** 40 pagine → **1.598 titoli unici**; pagina 41 = **0** (catalogo completo). `/en/code/download/<id>` rende lo ZIP: verificato su **6 id** |
| **TradingView** | **200** | tag `/scripts/vwap/?script_type=strategies` → **21 anchor** `data-qa-id="ui-lib-card-link-title"`; `pine-facade` rende il campo `source` | 🟢 **PASSA, SORGENTE COMPRESO.** ⚠️ **La procedura del memo aveva un secondo difetto: l'ho trovato e corretto — §1-bis** |
| **arXiv API** (`https://export.arxiv.org`) | **200** | `cat:q-fin.TR` rende titoli e date veri (dal 25/11/2024 a oggi) | 🟢 **PASSA come canale** · 🔴 **STERILE sul mandato**: §4 |
| **Quantpedia** | **200** | `wp-sitemap-posts-pod_cpt_strategy-1.xml` rende **1.118 slug** di strategia + `wp-sitemap-posts-post-1.xml` rende **1.155 post** di blog | 🟢 **PASSA — e la nota del 25/08 "non ricontrollarla" era SBAGLIATA: §1-ter** |
| 🆕 **TradingView — RICERCA TESTUALE** (`/pubscripts-suggest-json/`) | **200** | `?search=session%20close` → **34 risultati** con `scriptIdPart`, `extra.kind` (strategy/study) e `access` (1 = sorgente leggibile) | 🟢 **PASSA, ed è NETTAMENTE MIGLIORE del canale a tag: §1-quater** |
| **motore di ricerca web** (tool) | ok | 4 query, risultati con titoli, riviste, volumi e pagine | 🟢 **PASSA per la BIBLIOGRAFIA** · 🔴 **NON per il testo**: i PDF che indica sono tutti dietro egress bloccato |
| **GitHub ricerca** (`api.github.com/search`) | **403** | — | 🔴 **NULLA — settima caccia di fila** |
| **SSRN** (`papers.ssrn.com`) | **403** | — | 🔴 **NULLA — settima di fila** |
| **Forex Factory** | **403** | — | 🔴 **NULLA — settima di fila** |

### 🧱 Gli host bloccati all'egress (CONNECT 403 / `EGRESS_BLOCKED`) — misurati oggi, uno per uno

`www.snb.ch` · `www.bankofcanada.ca` · `acfr.aut.ac.nz` · `sites.insead.edu` ·
`ideas.repec.org` · `www.econstor.eu` · `core.ac.uk` ·
`onlinelibrary.wiley.com` · `www.qmul.ac.uk` · `scholar.google.com` ·
`www.semanticscholar.org` · `www.quantrocket.com` · `quantbuffet.com`

🔴 **Conseguenza diretta e pesante su questo dossier: dei due paper che
reggono il P1, NON HO POTUTO LEGGERE UNA RIGA DEL TESTO.** Ho la scheda
bibliografica (rivista, anno, volume, pagine) e l'enunciato del risultato dal
motore di ricerca, più una citazione **indipendente** trovata su una pagina
Quantpedia che ho aperto davvero. **Non ho le tabelle, quindi non ho la
grandezza dell'effetto né il conto dei costi.** È scritto nella scheda, pesa
sul punteggio, e determina la forma del primo round.

### 1-bis. 🔧 CORREZIONE AL MEMO FONTI — l'identificatore Pine NON è esadecimale

`PROMEMORIA_SBLOCCO_FONTI.md` (agg. 25/08) dice di cercare nell'HTML
**`PUB;<32 cifre esadecimali>`**. È **falso**, e ha già prodotto un buco a
verbale: il 25/08 lo script `9morbD5t-15-Minute-Gold-Trend-Following-Strategy`
è finito nel dossier come **S21, "NON VALUTATO — la pagina non contiene
l'identificatore"**, ed era in pieno bersaglio (oro, 15 minuti).

**Misurato oggi sulla stessa pagina:**

```
PUB;v0d1rwLHjXobyApD15BLp3iWRG8DxwkJ
```

Trentadue caratteri **alfanumerici misti**, non esadecimali. Il pattern giusto è

```
PUB;([0-9A-Za-z]{32})
```

🟢 **Con quello, S21 si è aperto in due secondi** — e il buco del 25/08 si
chiude con un verdetto invece che con un punto interrogativo: sono **8 righe
di Pine v3 del 2017**, un incrocio EMA182/SMA60 **senza stop e senza uscita**
(§3.2, S9). Insieme a lui si sono aperti altri **tre** script che il pattern
vecchio avrebbe scartato in silenzio.

> ⚠️ **La lezione di processo, che vale più dello script:** un pattern
> sbagliato non produce un errore, produce **un candidato "non letto"** — che
> nel dossier sembra un buco dichiarato e invece era un candidato scartato per
> un refuso di regex. **Su 7 script provati il 25/08, 1 era falso-vuoto: il
> 14%.**

### 1-ter. 🔓 QUANTPEDIA: la nota "non ricontrollarla" del 25/08 era SBAGLIATA, e va corretta

Il dossier del 25/08 dice, testualmente: _"Quantpedia, 82 slug enumerati: ZERO
strategie intraday su FX o oro. **Round risparmiato: la sezione gratuita di
Quantpedia, per un mandato intraday, non serve. Non ricontrollarla.**"_

**Misurato oggi:** gli 82 slug erano quelli che la pagina `/strategies` rende
in HTML. **La sitemap ne rende 1.118**:

```
https://quantpedia.com/wp-sitemap-posts-pod_cpt_strategy-1.xml   -> 1.118 slug
https://quantpedia.com/wp-sitemap-posts-post-1.xml               -> 1.155 post di blog
```

E fra i 1.118 ci sono, in tema esatto col mandato di oggi:
`intraday-reversal-in-currency-markets` · **`intraday-currency-seasonality`** ·
`overnight-intraday-weekly-reversal-in-currency-futures` ·
`price-overreactions-in-the-forex` · `exponential-fx-mean-reversion-strategy` ·
`payroll-news-timing-in-fx` · `jump-only-momentum-and-reversal-in-currency-markets` ·
`seasonality-in-gold` · `gold-market-timing`.

🔴 **Ma la vittoria è a metà, e lo dichiaro: quelle pagine sono PREMIUM.**
Aperte, restituiscono **302.356 byte che sono la home page** (Quantpedia
dichiara _"~70 free strategies"_ contro _"900+"_ premium). ➡️ **Dalla sitemap
si legge il NOME dell'effetto, non le regole.** Serve a sapere **che l'effetto
esiste in letteratura e come si chiama**, che è precisamente il gancio da cui
è partito il P1 di oggi — non a copiare una strategia.

> 📌 **Correzione da mettere a verbale:** _"Quantpedia non serve per i mandati
> intraday"_ → **falso**. La forma giusta è: **"la sitemap di Quantpedia è un
> INDICE DI EFFETTI da usare come punto di partenza bibliografico; le regole
> sono a pagamento e non si comprano."**

### 1-quater. 🆕 IL CANALE CHE HO TROVATO A CACCIA IN CORSO — e che mi ha SMENTITO

**Onestà prima di tutto: questo canale non l'ho scoperto io.** Mentre lavoravo,
la **sessione gemella** che oggi batte il lotto INDICI l'ha scritto nel memo
fonti (`PROMEMORIA_SBLOCCO_FONTI.md`, agg. 28/08 §A). **Io l'ho verificato in
proprio e l'ho applicato al mio bersaglio**, e vale la pena dirlo perché **mi
ha falsificato una conclusione che avevo già scritto** (§6.4, corretta).

```
https://www.tradingview.com/pubscripts-suggest-json/?search=<query>
```

Una sola richiesta e rende, per ogni risultato: **`scriptIdPart`
(`PUB;<hash>` già pronto)**, `extra.kind` (`strategy` vs `study`), **`access`
(`1` = sorgente leggibile, `2`/`3` = protetto)**, `agreeCount` (i like) e
`author.username`. ➡️ **Si sa PRIMA se un oggetto è una strategia e se il
sorgente si può leggere**, invece di scoprirlo dopo tre richieste.

**Misurato da me oggi su 10 query in bersaglio** (`intraday forex`,
`gold intraday`, `london session`, `new york session`, `session close`,
`end of day exit`, `forex mean reversion`, `XAUUSD strategy`,
`intraday reversal`, `time of day`) → **21 strategie uniche col sorgente
leggibile**, di cui **5 mai viste dal canale a tag**.

🔴 **E qui viene la parte che mi riguarda: il canale a tag mi aveva fatto
scrivere una conclusione FALSA.** Avevo misurato che i tag `timeofday`,
`hourofday`, `killzone`, `overlap`, `asiansession` rendono **zero strategie**,
e ne avevo dedotto _"su TradingView l'ora del giorno come motore non esiste"_.
**La ricerca testuale `time of day` ne rende TRE, tutte col sorgente
leggibile**, e una di esse è **l'implementazione di riferimento esatta della
sonda che avevo appena specificato per il P1** (§2, P4). ➡️ **La conclusione
corretta è: i tag di TradingView hanno buchi enormi e "zero risultati su un
tag" NON è una misura di assenza.** Correzione applicata al §6.4.

### Cosa ho sfogliato, dove ha funzionato

- **MQL5 Code Base — 1.598 titoli unici** (era 1.597 il 25/08 e 1.591 il
  23/08: stesso catalogo, cresciuto di poco). Filtri **di questo mandato**:
  `hour|clock|time.?of.?day|session|intraday|day.?trad|midnight|end.?of.?day`
  → **14 titoli** · `seasonal|day.?of.?week|weekday|calendar|turn.?of` →
  **3** · `gold|xau|silver|xag` → **18** · `eurusd|gbpusd|usdjpy|forex|currenc`
  → **28** · `revert|reversion|revers|fade|mean` → **12**. **Unione: 73
  titoli in tema.** **6 sorgenti `.mq5` scaricati, decodificati e letti**:
  `19500`, `17474`, `17279`, `22398`, `57020`, `56773`.
- **TradingView — 26 tag interrogati** (`intraday, daytrading, session,
  sessions, londonsession, newyork, newyorksession, asiansession, killzone,
  openingrange, pivotpoints, timeofday, hourofday, dayofweek, seasonality,
  xauusd, xagusd, silver, eurusd, gbpusd, overlap, zscore, standarddeviation,
  statistics, range, volatility`) → **236 strategie uniche**.
  **17 sorgenti Pine scaricati e letti riga per riga.**
  📌 **Reperto di struttura, utile al prossimo cacciatore:** i tag
  `killzone`, `timeofday`, `hourofday`, `overlap`, `asiansession` rendono
  **ZERO strategie**. Su TradingView **l'ora del giorno come motore non
  esiste**: esiste solo come *filtro* appiccicato a un motore di prezzo.
- **arXiv — 8 query**: `all:"London fix" AND all:exchange` (0) ·
  `abs:"intraday seasonality" AND abs:"foreign exchange"` (1, ed è il
  già-scartato Cotter & Dowd) · `abs:"month-end" AND abs:"exchange rate"` (0) ·
  `abs:"order flow" AND abs:"exchange rate" AND abs:intraday` (0) ·
  `all:"WMR fix" OR all:"benchmark fixing"` (0) ·
  `abs:"time of day" AND abs:currency AND abs:returns` (1, sulla volatilità) ·
  `abs:gold AND abs:"time of day"` (0) · `abs:"London fix" AND abs:gold` (0).
- **Quantpedia** — 1.118 slug + 1.155 post enumerati; **3 pagine aperte**, di
  cui **una utile**: `the-daily-volatility-of-foreign-exchange-rates-and-the-
  time-of-day` (§2, P1).

---

## 2. 🥇 I PROMOSSI — due candidati, più DUE specifiche

---

### 🥇 P1 — **`L'OROLOGIO`: la deriva intraday per BLOCCO DI SESSIONE su FX** — il motore più semplice che abbia mai proposto, e il primo round è una MISURA

```
NOME            (non esiste un EA: è un MECCANISMO di letteratura)
FONTE 1         Breedon, F. e Ranaldo, A., "Intraday Patterns in FX Returns
                and Order Flow", Journal of Money, Credit and Banking (2013),
                vol. 45, n. 5, pp. 953-965.
                Working paper SNB 2011-04 / QMUL 694 / SSRN 2099321.
FONTE 2         Krohn, I., Mueller, P., Whelan, P., "Foreign Exchange Fixings
                and Returns around the Clock", The Journal of Finance (2024).
                Anche: Bank of Canada Staff Working Paper 2021-48.
STATO FONTI     🔴 SCHEDA BIBLIOGRAFICA VERIFICATA, TESTO NON LETTO.
                Tutti i mirror sono bloccati all'egress (§1). Ho aperto
                davvero UNA pagina che cita Breedon & Ranaldo 2013 in
                bibliografia: quantpedia.com/the-daily-volatility-of-foreign-
                exchange-rates-and-the-time-of-day/  [VERIFICATO, letta]
LICENZA         non applicabile (nessun codice di terzi)
COSTO           🟢 nessun porting. Serve una SONDA di ~120 righe (§7).
```

#### 🧭 LA TESI IN UNA RIGA — ed è la parte migliore, perché NOMINA LA CONTROPARTE

> _"Una valuta tende a **deprezzarsi durante le proprie ore di contrattazione
> locali** perché in quelle ore i partecipanti locali sono **compratori netti
> di valuta estera** — pagano l'estero quando i loro uffici sono aperti. Non è
> un pattern di prezzo: è un **flusso d'ordini che ha un orario di ufficio**,
> e chi sta dall'altra parte è il tesoriere che deve regolare oggi."_

📌 L'enunciato che ho dal motore di ricerca, e che riporto come tale:
_"a significant tendency for currencies to depreciate during local trading
hours... The pattern is reflected in order flow and relates to the tendency of
market participants to be net purchasers of foreign exchange in their own
trading hours"_ · _"they find no significant pattern during foreign trading
hours"_ (sei valute incrociate).
**[VERIFICATO come risultato di ricerca · NON VERIFICATO nel testo del paper]**

#### ⚙️ MECCANICA, in tre righe (quella che DERIVA dalla tesi, non copiata da un autore)

1. **Nessun indicatore, nessun livello, nessun prezzo.** L'unico ingresso è
   **l'orologio del server**.
2. Si entra all'apertura del blocco orario della sessione locale della valuta
   e **si esce alla sua chiusura**: es. su EURUSD, **short EUR nelle ore
   europee** e **long EUR (= short USD) nelle ore americane**.
3. **Flat per costruzione**: il blocco finisce dentro la giornata. Stop di
   protezione in ATR (nostro, non dell'autore) solo come paracadute.

#### 🎯 PERCHÉ È IL CANDIDATO NUMERO UNO — quattro motivi, in ordine

**1. 🕳️ RIEMPIE IL BUCO PIÙ GROSSO CHE ABBIAMO, e non è un buco di simbolo:
è un buco di NATURA.** Ho listato le 36 sedie: `R52_CENSIMENTO_LATI.md` +
`FLOTTA_ATTIVA`. **Tutte, senza una sola eccezione, decidono guardando il
PREZZO** (medie, bande, Supertrend, gap, punte, range notturno). **Non esiste
una sola sedia che decida guardando l'OROLOGIO.** ➡️ La scorrelazione qui non
è sperata, è **strutturale**: un motore che non guarda il prezzo non può
perdere per lo stesso motivo per cui perde un motore che guarda il prezzo.
Ed è il criterio prop numero 3 (`METRO_PROP.md`): _"il DD della prop è UNO.
Accendere N EA a DD basso aiuta solo se NON perdono insieme."_

**2. ✅ IL FILTRO **È** IL MOTORE, nella forma più estrema possibile.**
Non c'è un motore a cui è stato appiccicato un orario: **l'orario è tutto ciò
che c'è**. Spegnere il filtro non rende l'EA più permissivo, **lo cancella**.
È la forma di `ABTG_EMA200` Dow (R29, **30 celle su 30 a PASS pieno**), portata
all'estremo — e l'esatto opposto dei cinque filtri appiccicati che fanno
**0 successi su 5**.

**3. 🔢 DUE PARAMETRI.** Ora di inizio e ora di fine del blocco, in ora server.
Contro un tetto di casa di ~15 input. **Non c'è quasi niente da ottimizzare, e
quindi quasi niente da sovra-ottimizzare** — che è il difetto che il nostro
imbuto passa la vita a scovare (12 Spearman IS→OOS negative su 13).

**4. ⏱️ IL PRIMO ROUND COSTA UNA PASSATA.** Non è "scriviamo un EA e vediamo":
è **una tabella 24×3** (24 ore × EURUSD/GBPUSD/XAUUSD) che si legge in cinque
minuti e chiude la pista **per sempre**, in un verso o nell'altro, **coi
NOSTRI numeri sul NOSTRO broker**.

#### ✅ PERCHÉ NON È UN CADUTO — punto per punto, e il confronto più duro per primo

| caduto | perché questo è un'altra cosa |
|---|---|
| 🚨 **D7 — WM/Reuters 4pm fix** (chiuso 22/08) | **Il confronto che conta.** D7 misurava **la volatilità nel MINUTO** delle 16:00 e concludeva _"non c'è direzione, solo volatilità"_, su campione **2010-2014 pre-riforma**. Qui l'oggetto è **la deriva media di un BLOCCO DI ORE** (la sessione locale intera), che è una grandezza diversa: una cosa può avere media zero nel minuto del fix e media diversa da zero sulle otto ore precedenti. In più la Fonte 2 è del **2024**, quindi **post-riforma 2015**. ⚠️ **Resta un'adiacenza vera, e il round la deve trattare come tale: se la misura oraria è piatta, D7 viene CONFERMATO ed esteso, e la pista si chiude con un numero nostro** |
| **D8 — Cotter & Dowd 2011** | quello è su **DEM/USD** con dati Dealing 2000-2: il marco non esiste dal 2002. Qui i simboli sono quelli che tradiamo, e la misura è sui NOSTRI dati |
| **D5 — "opposite last N hour trend"** (19500/17474) | quelli sono **fade del movimento delle ultime N ore** a un'ora fissa (più martingala). Qui **non si guarda il movimento**: si guarda solo che ora è. Meccanismo diverso, e senza martingala perché il sizing lo scriviamo noi |
| **R63 — Turnaround Tuesday / calendario** | quello è **il giorno della settimana**, un effetto di calendario su ~52 osservazioni l'anno. Qui è **l'ora del giorno**: ~250 osservazioni l'anno **per ciascuna delle 24 ore**, cioè due ordini di grandezza di campione in più |
| **S13 — stagionalità dell'oro** (chiusa dalla fonte) | quella è **stagionalità di calendario mensile** bocciata dallo SPA-test per data-snooping su 4.096 allocazioni. Qui lo spazio di ricerca è **24 celle**, non 4.096 — e la tesi economica (l'orario d'ufficio del flusso) esiste **prima** della misura, non dopo |
| **R98 — intraday momentum** | quello **condiziona sul segno dei primi 30 minuti** (guarda il prezzo). Qui non si condiziona su niente |
| ⚠️ **"parametri diversi di un motore morto"** | 🟢 **non si applica: non esiste un motore nostro di cui questo sia una variante.** È una famiglia che il progetto **non ha né promosso né bocciato** |

#### 🚨 I TRE RISCHI, dichiarati PRIMA di qualunque numero — e il primo può uccidere il round

**1. 🔴 IL COSTO, ed è IL rischio.** Una deriva di sessione, se esiste, è
dell'ordine di **pochi punti base**. Su EURUSD a 1,10 lo spread di 1 pip vale
**0,9 bp**. ➡️ **Se la deriva media di un blocco vale 2 bp, il costo si mangia
metà del segnale lordo prima ancora di iniziare.** È lo stesso muro che ha
ucciso i nostri M5 (arXiv 2605.04004: _"maximum achievable gross return before
friction is roughly 1,05 to 1,50 points... the 2,0-point friction cost
consistently exceeds this"_). **Per questo il PASSO 0 non è "quanto guadagna":
è "il lordo per blocco vale almeno 3× lo spread mediano di quel blocco?"** —
e lo spread va misurato **nella stessa ora**, non in media sulla giornata
(lezione R55: lo spread si legge in **percentuale dello stop**).

**2. 🟡 L'ORA LEGALE, e stavolta morde davvero.** Il meccanismo è **agganciato
all'orario di ufficio di New York, Londra e Tokyo**, che si spostano rispetto
all'ora server **in date diverse** (USA e UE non cambiano lo stesso giorno; il
Giappone non cambia affatto). ➡️ **Un blocco definito in ora server fissa è
sbagliato per ~4 settimane l'anno.** Il round deve dichiarare se misura in ora
server fissa (semplice, con un errore noto) o in ora locale della piazza
(giusto, più codice). **Va deciso PRIMA, non dopo aver visto la tabella.**

**3. 🟡 LA FONTE È BIBLIOGRAFIA, NON TESTO.** Non ho le tabelle. **Quindi non
so se gli autori dichiarano che l'effetto sopravvive ai costi**, e non lo
invento. ➡️ **Conseguenza operativa: questo NON è un candidato "l'autore dice
che funziona". È un candidato "esiste una ragione economica per guardare lì, e
guardare costa una passata".** Se qualcuno riesce ad aprire uno dei mirror
(§4), la scheda si aggiorna e il punteggio può salire o crollare.

```
PUNTEGGIO (0-2 per voce)
  [2] semplicità — due parametri, zero indicatori. Il minimo storico del progetto
  [2] il filtro È il motore — l'orologio è TUTTO il motore, non un cerotto
  [2] tesi di mercato scrivibile — sopra, e NOMINA la controparte
      (il tesoriere che compra valuta estera nel suo orario d'ufficio)
  [2] riempie un BUCO — 36 sedie su 36 decidono guardando il PREZZO.
      Zero guardano l'orologio. Scorrelazione STRUTTURALE, non sperata
  [1] testabile senza riscritture — NO: serve una sonda nuova (~120 righe).
      È l'unica voce dove perde, ed è anche la più economica da pagare

VERDETTO   🟢 PROVA SUBITO (9/10) — MA COME MISURA, NON COME STRATEGIA
PERCHÉ     è l'unico oggetto trovato in sette cacce che (a) è intraday per
           costruzione, (b) è scorrelato per costruzione, (c) ha due
           parametri, (d) ha due riviste di prima fascia dietro e (e) si
           falsifica in una passata di tester. Se la tabella oraria è
           piatta, la pista si chiude con un numero NOSTRO e si smette di
           ricercarla ogni caccia.
```

#### 🏛️ RIGA PROP

🟢 **Il profilo giornaliero è il migliore che si possa chiedere a una prop:**
esposizione limitata a un blocco di ore noto **a priori**, **una posizione per
blocco**, **zero overnight** (quindi zero gap del weekend, zero swap, zero
restrizioni FTMO sul conto finanziato) e **frequenza altissima e regolare**
(~250 giornate l'anno per blocco), che è ciò che rende il campione leggibile
in fretta invece che in tre anni.
⚠️ **Il rovescio, e va scritto:** un motore che entra **ogni giorno alla
stessa ora** su più simboli è **massimamente concentrato nel tempo** — se il
2 di ogni mese quel blocco è brutto, lo è per tutti i simboli insieme. Il
numero da guardare nel referto **non è il DD totale: è la PEGGIOR GIORNATA**
(muro FTMO **−5.000 su 100k**; la nostra peggiore misurata, R51, è **−2,06%**).
➡️ **Se il PASSO 0 passa, il secondo cancello è la correlazione fra i blocchi
dei tre simboli nello stesso giorno**, e va misurata sulle serie per-trade.

---

### 🥈 P2 — `Money maker EURUSD 15min` (TradingView, Pine letto): **l'unico oggetto del web che ha TUTTE E QUATTRO le cose del mandato**

```
NOME            Money maker EURUSD 15min
FONTE / URL     https://www.tradingview.com/script/jU2JCWZr-Money-maker-EURUSD-15min-daytrader/
                PINE SCARICATO E LETTO (119 righe, via pine-facade)
AUTORE / DATA   © SoftKill21 · created 2020-10-19T09:46:53Z
                scriptAccess: open_no_auth   [VERIFICATO nel JSON]
LICENZA         🟢 Mozilla Public License 2.0, dichiarata alla riga 1 del sorgente
RIGHE / INPUT   119 righe · 11 input operativi (+6 di sole date di backtest)
                -> 🟢 sotto il nostro tetto di ~15
COSTO DI PORTING 🟡 Pine -> MQL5 è una RISCRITTURA, non un porting. Ma è la
                 riscrittura più facile che abbia visto: nessun indicatore
                 esotico, nessun request.security, nessun volume.
                 Stimate 3-5 ore (EA d'agente + collaudo).
```

#### ⚙️ MECCANICA — letta nel Pine, non nella descrizione

1. **Il motore (righe 65-66): allineamento COMPLETO di cinque medie.** Quattro
   SMMA (3, 6, 9, 50) più una EMA200. Serve **contemporaneamente** che il
   prezzo sia sopra tutte e cinque **E** che siano impilate nell'ordine giusto
   (`smma > smma2 > smma3 > smma4 > ema200`). Lo short è lo specchio esatto.
2. **La finestra (righe 55-56):** ingressi ammessi **solo** in
   `londonEntry = "0300-0845"`; la sessione operativa è `london = "0300-1045"`.
3. **🎯 IL FLAT OBBLIGATORIO (riga 111):**
   ```pine
   strategy.close_all(when = not london, comment="london finish")
   ```
   **Non è un'opzione, non è un `input.bool`: è una riga sempre attiva.**
   Alle 10:45 si è piatti, punto.
4. **Il tetto giornaliero (righe 116-117):**
   `strategy.risk.max_intraday_filled_orders(2)` → **massimo 2 ingressi al
   giorno.**
5. **Uscite:** TP e SL **simmetrici a 300 punti = 30 pip** (righe 77-78, 104,
   107).
6. **Sizing (righe 83-94):** `size = (balance × risk%) / sl`, con `risk = 1%`
   → **rischio in percentuale calcolato sulla distanza dello stop.** È il
   nostro standard, ed è raro trovarlo scritto giusto in Pine.

#### 🧭 TESI IN UNA RIGA

> _"Nelle prime ore di Londra il flusso istituzionale è direzionale: quando
> tutte le scale temporali dalla più corta alla più lunga sono già d'accordo,
> quel consenso è flusso e non rumore, e dura fino a metà mattina — dopo di
> che il flusso si esaurisce e la posizione non ha più ragione di esistere."_

🟡 **È una tesi onesta ma di seconda fascia, e lo dico:** non nomina la
controparte come fa il P1. La parte forte non è *perché* l'allineamento
funzioni: è **perché si esce a un'ora fissa** — l'uscita ha una ragione
(il flusso di sessione finisce), l'ingresso un po' meno.

#### ✅ PERCHÉ NON È UN CADUTO — e dove invece è adiacente, dichiarato

| caduto | confronto |
|---|---|
| **breakout M5 / ORB di sessione** (chiuso, ~210 celle) | 🟢 **diverso**: non c'è **nessun livello da rompere**, nessun box d'apertura, nessun massimo/minimo. Il grilletto è uno **stato delle medie**, non un tocco di prezzo |
| **R42/R43 fade degli estremi** | 🟢 opposto: questo va **a favore**, non contro |
| **R95 sweep + reclaim** | 🟢 nessun livello, nessuno sweep |
| **R60 `ABTG_MeanRevert`** | 🟢 opposto per direzione |
| **R108/R111 — la discesa di TF** | 🟢 **non si applica**: qui il motore **nasce** a M15 con una geometria in **pip fissi (30)**, non con un target che si accorcia col timeframe. Il collo che ha ucciso il Breaking Band a M15 (_"incassa 6,65 pip contro perdite da 16,5"_) qui non c'è per costruzione: 30 contro 30 |
| 🟡 **`ABTG_EasyTrend` (GBPUSD H1)** | ⚠️ **adiacenza vera, e la nomino io.** EasyTrend ha già `InpHourStart=8` / `InpHourEnd=18` — cioè una finestra oraria. **Ma è una finestra di INGRESSO su H1, senza flat obbligatorio**; qui il flat è costitutivo e il TF è M15. Diverso, ma il carico della prova sta su chi propone |
| 🟡 **`ABTG_SuperWave` / `ABTG_CrossEma` / `ABTG_GoldenCross`** | ⚠️ **adiacenza CONCETTUALE seria: sono tutti motori di allineamento/incrocio di medie.** La differenza è il **contenitore** (sessione + flat + tetto 2/giorno), non il segnale. ➡️ **Ed è esattamente per questo che il round deve avere una cella di ablazione: lo stesso allineamento SENZA la finestra oraria.** Se il nudo va uguale, la sessione non serve e il candidato è un doppione; se il nudo crolla, il contenitore È il motore |

#### 🔧 COSA TERREI / COSA RIFAREI — la separazione che chiede il §5F

**🟢 DA TENERE (il contenitore, ed è la parte rara):** la finestra d'ingresso
di sessione, il **`close_all` incondizionato** a fine sessione, il **tetto di
2 ingressi al giorno**, il rischio in % sulla distanza dello stop, la
simmetria long/short dallo stesso codice, la decisione su barra chiusa.

**🔧 DA RIFARE (e qui, al contrario del solito, il dubbio è sul MOTORE):**

| difetto, con la riga | perché morde | cosa ci mettiamo |
|---|---|---|
| `tp=300` / `sl=300` **in punti fissi** (righe 77-78) | scollegato dalla volatilità: 30 pip nel 2020 e nel 2026 sono due rischi diversi | **SL in ATR**, TP a multiplo di R |
| R:R **1:1 secco**, nessuna gestione | nessun parziale, nessun runner | **parziale 1R + breakeven + runner a 2R** (le nostre DAX/Dow) |
| 🐛 riga 103: `strategy.entry("long", 1, size, ...)` | in Pine v4 il 2º argomento è un **bool**: `1`=true=long, `0`=short. **Funziona per caso**, come la riga 266 del KA-Gold | in MQL5 sparisce da sé |
| 🕐 `"0300-1045"` è in **fuso dello scambio**, non nostro | su un grafico FX TradingView è tipicamente UTC → in ora server BCM diventa **~05:00-12:45** [INFERITO] | ⚠️ **l'ora va MISURATA sull'orologio del server, non convertita a tavolino.** È la trappola già pagata in casa (`CLAUDE.md`: log in ora locale ≠ grafico in ora server) |
| nessun filtro di spread | R55 | il nostro filtro standard, **in % dello stop** |
| 5 lunghezze di media (3/6/9/50/200) | cinque manopole puntate sul passato | **congelarle ai default dell'autore** nel primo round: si spazzola la SESSIONE, non le medie |

```
PUNTEGGIO
  [2] semplicità — 11 input veri, 119 righe leggibili
  [1] il filtro È il motore — la sessione SÌ (senza, l'EA non esiste);
      ma l'allineamento a 5 medie sono 4 manopole, e la tesi d'ingresso
      è di seconda fascia
  [1] tesi di mercato scrivibile — sì, ma non nomina la controparte
  [2] riempie un BUCO — forex M15 intraday con FLAT OBBLIGATORIO a fine
      sessione: è il bersaglio esatto del mandato FTMO, e in flotta non
      c'è NIENTE del genere
  [1] testabile senza riscritture — NO, ma è la riscrittura più facile
      della giornata (3-5 ore)

VERDETTO   🟡 IN CODA, subito dietro P1 (7/10)
PERCHÉ     è l'unico dei 236 oggetti raccolti che porta a casa il
           contenitore che il mandato chiede — e il contenitore è più
           raro del motore. Il motore, invece, va guardato con sospetto:
           senza la cella di ablazione questo è un doppione del SuperWave
           con un orologio addosso, e la differenza fra le due cose vale
           l'intero round.
```

#### 🏛️ RIGA PROP

🟢 **Ha già dentro due delle tre cose che `METRO_PROP.md` chiede** e che quasi
nessun EA gratuito ha: **tetto di 2 operazioni al giorno** (freno diretto al
muro giornaliero di **−5.000 su 100k**) e **zero overnight** (quindi
compatibile con FTMO Standard a **leva 1:100** senza scendere a Swing 1:30).
Con SL 30 pip e rischio 0,65%, **due stop pieni nella stessa mattina valgono
−1,3%**: dentro il cap, e calcolabile a priori — cosa che con un EA senza
tetto non si può fare.
⚠️ **Il rovescio:** è un motore **a favore del trend**, quindi nelle mattine
di trend forte **è correlato alle sedie long della flotta**. La scorrelazione
va misurata sulle serie per-trade, non sperata.

---

### 🥉 P3 — `SP500 Session Gap Fade Strategy` (© exlux, MPL 2.0): 🟢 **PROMOSSO COME SPECIFICA, 🔴 SCARTATO COME EA**

```
NOME            SP500 Session Gap Fade Strategy  (shorttitle "SPX Gap Fade")
FONTE / URL     https://www.tradingview.com/script/J1U1NNgx-SP500-Session-Gap-Fade-Strategy/
                PINE SCARICATO E LETTO (142 righe)
AUTORE / DATA   © exlux · created 2025-11-16T13:04:22Z · open_no_auth
LICENZA         🟢 Mozilla Public License 2.0 (riga 1)
```

🔴 **Perché NON è un candidato:** (a) il motore è **il fade di un gap pieno di
barra** (`gap_down_full = high < low[1]`, riga 65) — su forex e oro un gap
pieno **intraday** è quasi solo uno spike da notizia, quindi frequenza
bassissima e controparte sbagliata; (b) è su **SP500**, fuori dal mandato;
(c) **è la famiglia gap che abbiamo già in casa** (`ABTG_GapFill`,
`ABTG_GapContinuation`) — doppione; (d) **nessun sizing**: gira a quantità di
default, non è scalabile a 100k.

🟢 **Perché è promosso come SPECIFICA — ed è un pezzo che vale da solo:** è la
migliore implementazione del **flat obbligatorio con anticipo** che ho letto
oggi, ed è **parametrica**:

```pine
flat_before_min = input.int(60, "Minutes before session end to force exit", ...)
int flat_total = sess_end_total - fb_minutes
bool flat_bar  = in_session and cur_hour == flat_hour and cur_min == flat_min
if flat_bar and use_forced_flat
    prev_eod_close := close
    strategy.close("long")
    strategy.close("short")
```

🎯 **Cioè: non "chiudi a fine sessione", ma "chiudi N minuti PRIMA della fine
della sessione", con N come input.** ➡️ **È esattamente la manopola che serve
al mandato FTMO**, e va messa in **qualunque** EA intraday costruiamo da qui
in avanti (P1 e P2 compresi): l'ultima mezz'ora di sessione è quella con lo
spread peggiore e i riempimenti peggiori, e uscire *dentro* la liquidità
invece che *sull'ultima candela* è gratis.
📌 **Attribuzione obbligatoria in testa a qualunque `.mq5` derivato:
© exlux, TradingView `J1U1NNgx`, Mozilla Public License 2.0.**

---

### 4️⃣ P4 — `Mateo's Time of Day Analysis LE-SE`: 🎯 **la SONDA del P1, già scritta da un altro — trovata DOPO aver specificato il P1**

```
NOME            Mateo's Time of Day Analysis LE-SE  (shorttitle "Time of Day LE")
FONTE / URL     TradingView, scriptIdPart PUB;f493382224324212b424bd89b27ddd9f
                https://www.tradingview.com/script/f493382224324212b424bd89b27ddd9f/
                PINE SCARICATO E LETTO (47 righe)
AUTORE / DATA   @MateoH_ · created 2024-05-31T19:41:22Z · access open_no_auth
                POPOLARITA' 35 like  [VERIFICATO nel JSON della ricerca]
LICENZA         [INCERTO] nessuna licenza dichiarata nel sorgente
```

🎯 **Perché è in dossier, e perché è la conferma più forte che il P1 abbia
preso:** il P1 l'ho specificato **prima** di trovare questo (una sonda a due
parametri, ora d'ingresso e ora d'uscita, flat a fine giornata, che misura la
percentuale di giornate positive per fascia oraria). **Poi la ricerca testuale
me l'ha messo davanti già scritto.** Il commento dell'autore, righe 3-4, è la
mia stessa frase con altre parole:

> _"This is a simple script to determine **if entering a long position at a
> specific time has a higher probability of being up if exited at a different
> specific time**. Use the TradingView 'Percent Profitable' to help determine
> this. The inverse is true for short trades, just reverse the percentage."_

**Le quattro righe che contano, e che confermano la specifica riga per riga:**

| cosa serviva al P1 | come lo fa lui |
|---|---|
| **due soli parametri** | `StartTime = input.int(0930)` · `EndTime = input.int(1600)`. **Non ce ne sono altri** (a parte le date di backtest) |
| **flat a fine sessione, incondizionato** | `Strategy.closeAllAtEndOfSession(comment = "End Of Day")` — ultima riga del file, **sempre attiva**, più `strategy.close_all()` nella finestra d'uscita |
| **niente look-ahead** | `process_orders_on_close = true` nell'header |
| **è una MISURA, non una strategia** | **non c'è nessuno stop loss e nessun sizing — e l'autore lo dichiara**: si legge la *Percent Profitable*, non il P/L |

🔴 **Ed è per questo che NON è un candidato EA, ed è promosso come STRUMENTO:**
senza stop loss non passa il §4 come strategia. **Ma come sonda è corretto**,
e serve esattamente il compito che gli chiediamo.

```
VERDETTO   🟢 PROMOSSO COME STRUMENTO / SPECIFICA (non come EA)
COSA VALE  è la CONFERMA INDIPENDENTE che la sonda del P1 è costruibile in
           47 righe, ed è il riferimento da mettere sotto gli occhi di
           mql5-ea-developer quando costruira' ABTG_SondaOrologio.
           Attribuzione: @MateoH_, TradingView PUB;f4933822...
```

---

## 3. 🗑️ GLI SCARTATI — uno per riga, con la riga di codice che lo prova

### 3.1 MQL5 Code Base — **6 sorgenti letti**

| # | candidato | fonte | la riga che lo prova |
|---|---|---|---|
| S1 | **`20 Pips Opposite Last N Hour Trend`** | [Code Base 19500](https://www.mql5.com/en/code/19500) — sorgente letto, 540 righe, 13 input | 🔴 **MARTINGALA + NIENTE STOP.** Righe 52-56: `InpFirstMultiplicator=2` `Second=4` `Third=8` `Fourth=16` `Fifth=32` ("Lot multiplier, if N positions are unprofitable"). Righe 438 e 476: **`sl=0.0;` scritto a mano dentro `OpenBuy`/`OpenSell`**, prima dell'invio. Più `InpMaxPositions=9`. ⚠️ **Già scartato il 22/08** (`SWEEP_MECCANISMI_LIBERI` §D5): riletto oggi perché il suo **meccanismo** (aprire a un'ora fissa, riga 50 `InpTradingHour=hour_07`) era in pieno bersaglio. 🟢 **Reperto tenuto agli atti: il motore a orologio ESISTE nel Code Base, ma solo dentro una martingala** |
| S2 | **`10pipsOnceADayOppositeLastNHourTrend`** | [Code Base 17474](https://www.mql5.com/en/code/17474) — sorgente letto, 422 righe | 🔴 Stessa famiglia, stesso autore-edizione. In più: **ZERO righe `input`** — è tutto `extern` in stile MQL4, quindi **non ottimizzabile** dal nostro driver. Già a verbale il 22/08 |
| S3 | **`21hour`** | [Code Base 17279](https://www.mql5.com/en/code/17279) — sorgente letto, 308 righe, 7 input | 🔴 **STRADDLE SENZA STOP.** Righe 117-131: alle `HourStartFirst` apre **contemporaneamente** un buy e un sell con uno `Step`, e imposta **solo il TP** (`tp=...Ask()+ExtStep+ExtTakeProfit`); chiude tutto a `HourStop`. **Nessun `sl` in nessun ramo.** Più `Lots=0.1` fisso. È una copertura, non un motore |
| S4 | **`High frequency volatility trader (EURUSD H1 ONLY)`** | [Code Base 22398](https://www.mql5.com/en/code/22398) — sorgente letto, 326 righe, 3 input | 🔴 **IL TAKE È SOTTO IL COSTO.** Righe 11-12: `StopLoss=15` e `TakeProfit=15` **in punti**, che su EURUSD a 5 decimali sono **1,5 pip**. Contro ~1 pip di spread → **1,5× lo spread**, sotto il cancello di casa (≥3×). Più lotto non parametrico |
| S5 | **`MeanReversionTrendEA` / `Mean Reverse.mq5`** | [Code Base 57020](https://www.mql5.com/en/code/57020) — sorgente letto, 679 righe, 8 input, © Mustafa Seyyid Sahin | 🔴 **È R60 con un altro nome.** Righe 568-569: `reversion_buy_signal = (current_price < current_slow_ma - current_atr * ATR_Multiplier)` — compra la deviazione **senza nessuna condizione di regime**: è il "coltello che cade" del `SETACCIO_MANUALE`, e in casa fa **12 celle su 12 in perdita** (R60). Più `LotSize=0.1` **fisso** e SL/TP in punti fissi |
| S6 | **`BreakRevertPro EA`** | [Code Base 56773](https://www.mql5.com/en/code/56773) — sorgente letto, 1.700 righe, 12 input, stesso autore | 🔴 **INQUINA IL PROPRIO BACKTEST.** Righe 31-32: `input bool enable_safety_trade = true;` + `safety_trade_interval = 60` e nel codice `m_trade.Buy(lot, symbol, 0, sl, tp, is_safety_trade ? "Safety Trade" : "Signal Trade")` (righe 1497-1502): **l'EA apre operazioni che NON vengono dal segnale, per "avere operazioni durante il test"**. Qualunque numero prodotto da questo EA è una miscela di segnale e rumore iniettato. 🟢 Il rischio **è** in percentuale e `max_positions=1`: l'idraulica è decente, la misura no |

### 3.2 TradingView — **17 Pine letti riga per riga, 15 scartati**

| # | script | autore / data | la riga che lo prova |
|---|---|---|---|
| S7 | **`Session King — ALMA Baseline with Session Filter and Fixed 2R Exit`** | [`u5R6y8cl`](https://www.tradingview.com/script/u5R6y8cl-Session-King-ALMA-with-Session-Filter/) · created **2026-06-04** · 87 righe | 🔴 **VIOLA IL REQUISITO NON NEGOZIABILE: non chiude a fine sessione.** La sessione filtra **solo l'ingresso** (riga 66-67); le uniche uscite sono `strategy.exit` con stop/limit (righe 77-83) → **una posizione aperta alle 15:58 resta aperta tutta la notte.** In più il "filtro" squeeze è `input.bool(false, "Enable Squeeze Filter")` = **filtro appiccicato e pure spento** (0/5 in casa), e il segnale è `close > ta.alma(9)`, cioè un incrocio di media. 🟢 Da rubare: `qty = (strategy.equity * riskPct/100) / sl_distance` (riga 62) è il rischio % scritto giusto |
| S8 | **`Trade Hour V4`** | [`4KxpN6N6`](https://www.tradingview.com/script/4KxpN6N6-Trade-Hour/) · © mablue (Masoud Azizi) · **MPL 2.0** · created **2022-08-31** · 59 righe | 🔴 **NESSUNO STOP, NESSUNA USCITA.** Righe 58-59: `strategy.order("buy", ...)` / `strategy.order("sell", ...)` e **basta** — nessun `strategy.exit`, nessun `strategy.close`. 🐛 In più la funzione `arctan2` (righe 13-19) **non ha il ramo `x<0 and y<0`**: in quel quadrante restituisce `na` e l'ora "migliore" scompare. 🟢 **Reperto: è l'UNICO script su 236 che mette l'ORA DEL GIORNO nel motore** (media circolare delle ore pesata su RSI/MFI). Conferma dal lato retail che il P1 è terreno vergine, non che funzioni |
| S9 | **`15 Minute Gold Trend-Following Strategy`** (nome vero: `MAster Gold Strategy`) | [`9morbD5t`](https://www.tradingview.com/script/9morbD5t-15-Minute-Gold-Trend-Following-Strategy/) · Pine **v3** · created **2017-03-28** · **8 righe** | 🔴 **IL BUCO DEL 25/08 SI CHIUDE COSÌ** (§1-bis): sono otto righe. `strategy.entry("Buy", ..., when = close > ema(close,182) and crossover(close, sma(close,60)))` e lo specchio. **Nessuno stop, nessun take, nessuna uscita, `pyramiding=1`.** Il titolo dice "15 Minute": nel codice non c'è **una sola riga** che riguardi il timeframe |
| S10 | **`Gold/Silver 30m Only Strategy`** (nome vero: `My Strategy`) | [`lx4O1PPu`](https://www.tradingview.com/script/lx4O1PPu-Gold-Silver-30m-Only-Strategy-Buy-Sell-Signals/) · Pine **v2** · created **2017-02-17** · 32 righe | 🔴 **NESSUNO STOP** + 🐛 **uscita short rotta**: riga 31 `strategy.exit("Sell", when = vrsi > RSIOverBought and close > ema(close,162))` — per chiudere uno short pretende **RSI in ipercomprato E prezzo sopra la media**, cioè la condizione peggiore possibile. Secondo script aperto grazie al pattern corretto |
| S11 | **`Gold Friday Anomaly Strategy`** | [`gogCotwE`](https://www.tradingview.com/script/gogCotwE-Gold-Friday-Anomaly-Strategy/) · © piirsalu · **MPL 2.0** · created **2024-12-03** · 60 righe | 🔴 **DUE BUG CHE PROVANO CHE NON È MAI STATO CONTROLLATO.** (1) Riga 53: `if dayofweek == 4` — in Pine `dayofweek.wednesday == 4`, il venerdì è **6**: **la "Friday anomaly" compra di MERCOLEDÌ**. La variabile `isFriday` è definita alla riga 35 con la costante giusta e **non è mai usata**. (2) Riga 57: `if (barCounter % 1 == 0)` → `% 1` è **sempre 0**, quindi la `strategy.close` scatta **a ogni barra**; il commento sopra dice _"Close the position after holding it for 4 candles"_. Più nessuno stop e 10% dell'equity per operazione |
| S12 | **`Gold Trade Setup Strategy`** | [`25wTlm4E`](https://www.tradingview.com/script/25wTlm4E-Gold-Trade-Setup-Strategy/) · created **2024-12-27** · 89 righe | 🔴 **I SEGNALI SONO INVERTITI, E NON C'È USCITA.** `if (buyCondition) ... strategy.entry("SELL", strategy.short)` e `if (sellCondition) ... strategy.entry("BUY", strategy.long)`. `targetPrice` e `stopPrice` sono **calcolati e mai usati** (nessun `strategy.exit` nel file). 🌙 E in fondo c'è il calcolo della **FASE LUNARE** (Amavasya/Purnima) |
| S13 | **`PTS: Golden Edge`** | [`SD5jYZuC`](https://www.tradingview.com/script/SD5jYZuC-Precision-Trading-Strategy-Golden-Edge/) · created **2024-12-09** · 114 righe | 🔴 **NESSUNO STOP LOSS**: nel file ci sono due `strategy.entry` (righe 96, 98) e **zero `strategy.exit`**. La posizione si chiude solo sul segnale opposto |
| S14 | **`Aurum DCX AVE Gold and Silver Strategy`** | [`gwesPgxX`](https://www.tradingview.com/script/gwesPgxX-Aurum-DCX-AVE-Gold-and-Silver-Strategy/) · © exlux · **MPL 2.0** · created **2025-10-22** · 164 righe, 19 input | 🔴 **FUORI MANDATO + MANOPOLA FINTA.** (a) Riga 127: lo stop è `sl_atr_mult * ta.atr` su timeframe **`"W"` (settimanale)** → è un motore **swing multi-giorno**, tiene overnight per settimane. (b) Riga 47: `risk_pct = input.float(2.2, "Risk percent per trade")` **non è referenziato da nessuna parte nel file** — nessun calcolo di quantità esiste: è un input che non fa niente. (c) Dipende da `TVC:DXY` via `request.security` (riga 121): simbolo esterno non replicabile identico in MT5. 🟢 Nota: `lookahead=barmerge.lookahead_off` ovunque, quindi **niente look-ahead** |
| S15 | **`XAUUSD Auto Strategy (Connector Ready)`** | [`Ae37AI2n`](https://www.tradingview.com/script/Ae37AI2n-XAUUSD-Auto-Strategy-Connector-Ready/) · created **2026-04-12** · 60 righe | 🔴 **NESSUNA TESI (§5C) + FUORI MANDATO.** È `ta.crossover(close, ema20)` con `ema20 > ema50`: un incrocio di medie da manuale, doppione di `SuperWave`/`GoldenCross`. Nessuna sessione, nessun flat: tiene fino a SL/TP, quindi **overnight**. 🟢 Onestà: il sizing (righe 33-39, rischio %/distanza SL con guardia sulla divisione per zero) è il più pulito dei 17 |
| S16 | **`Mean Reversion Setup LliterH`** | [`6XPbhz9C`](https://www.tradingview.com/script/6XPbhz9C/) · © LliterH · **MPL 2.0** · created **2026-04-03** · 125 righe | 🔴 **FUORI MANDATO**: l'header dichiara _"Recommended timeframe: 180m, 240m, Daily"_ e non c'è nessuna uscita di sessione → **tiene overnight per giorni**. In più è **long-only** su **indici** e il motore (`close < highest(10) − 2.5×avgRange`) è la famiglia R60. 🟢 **Da rubare, ed è notevole:** la gestione è **la nostra** — parziale 50% su `close > high[1]`, runner su trailing ATR, hard stop 2 ATR — e il filtro **IBS < 0,3** (posizione della chiusura dentro la barra) è un pezzo di meccanica che il progetto **non ha mai misurato** |
| S17 | **`Timeshifter Triple Timeframe Strategy w/ Sessions`** | [`c7N4sz1e`](https://www.tradingview.com/script/c7N4sz1e-Timeshifter-Triple-Timeframe-Strategy-w-Sessions/) · @fenyesk · created **2025-06-20** · 196 righe | 🔴 **LA TESI È UN MENU A TENDINA.** Riga 19: `selectedIndicator = input.string("RMI", options=["RMI","TWAP","TEMA","DEMA","MA","MFI","VWMA","PSAR"])`, più `useADX = input.bool(false)` e `tradeDirection = input.string("Both", options=["Long","Short","Both"])`. **È l'ottimizzatore a decidere quale sia la strategia** — identico motivo per cui il 22/08 è caduto `003 - Weekly Day Reversal` e il 25/08 `Reverse Keltner` |
| S18 | **`Adaptive Dual-Engine Strategy — Momentum + Mean Reversion`** | [`f9xLZqpF`](https://www.tradingview.com/script/f9xLZqpF-Adaptive-Dual-Engine-Strategy-Momentum-Mean-Reversion-BT/) · created **2026-06-19** · 514 righe, **60+ input** | 🔴 **Stessa malattia, in grande.** Riga 24: `entryMode = input.string("Auto (by timeframe)", options=["Auto","Both Agree","Either Signal","EMA MACD Only","BuySell Only","Mean Reversion"])`. **Sessanta input contro un tetto di quindici.** Usa il **volume** (riga 47, 85) — inutilizzabile su FX. `allowShorts = false` di default. E il tooltip vende _"~76% win on SPY 5-min"_: numero dell'autore, peso zero |
| S19 | **`Trade Beta — The Only EURUSD Trading Strategy You Need`** | [`CjTnMUWB`](https://www.tradingview.com/script/CjTnMUWB/) · © Kaspricci · **MPL 2.0** · created **2022-11-07** · 205 righe | 🔴 **È IL CADUTO PIÙ CARO CHE ABBIAMO.** All'apertura della sessione NY piazza **due ordini STOP in OCO** sull'ultimo swing high e swing low (righe 154-186): è **il breakout di un livello all'apertura di una sessione**, cioè R45 (**0/48**) e la famiglia chiusa da ~210 celle. In più `calc_on_every_tick = true` (riga 13 — trappola §4 di TradingView) e `default_qty_value = 100` con `useRiskMagmt = false` **di default** → **100% dell'equity**. 🟢 **Da rubare: il flat di sessione con cancellazione dei pendenti** (righe 190-198) e l'OCO |
| S20 | **`Seasonal Strategies V1`** | [`9PArRAI9`](https://www.tradingview.com/script/9PArRAI9-Seasonal-Strategies-V1/) · created **2025-12-29** · 176 righe | 🔴 **FUORI MANDATO**: entra e esce su **date di calendario** (`mmdd = month*100 + dayofmonth`, riga 12) → posizioni tenute per **settimane**. Famiglia calendario, chiusa da R63 (**0/24 su 11.928 operazioni**) |
| S21 | **`Koala Script` (Koala System EURUSD 15min)** | [`wtx6cq4I`](https://www.tradingview.com/script/wtx6cq4I-Koala-System-EURUSD-15min/) · © SoftKill21 · **MPL 2.0** · created **2020-08-30** · 133 righe | 🟡 **NON è uno scarto per difetto: è il GEMELLO di P2** dello stesso autore (stesso stack di 5 SMMA, stesso `tp/sl=300`, più MACD e ATR sopra). **Scartato in favore di P2 perché ha più condizioni per la stessa tesi** — e la regola di casa dice di prendere la versione con meno manopole. ➡️ **Se P2 dovesse passare, questo è la prima variante da provare come CELLA, non come EA** |

### 3.2-bis TradingView — **5 Pine in più, trovati dalla RICERCA TESTUALE** (§1-quater)

_Questi cinque il canale a tag non me li aveva mostrati. Uno è il P4
(promosso), quattro sono qui._

| # | script | autore / popolarità | la riga che lo prova |
|---|---|---|---|
| 🚨 **S26** | **`Timeframe Time of Day Buying and Selling Strategy`** | [`PUB;185202f4...`](https://www.tradingview.com/script/185202f453a842bd8c84b8eb8300d7c5/) · @tormunddookie · created **2021-08-01** · **193 like** · 151 righe | 🔴 **QUARANTOTTO INPUT CATEGORICI, UNO PER OGNI MEZZ'ORA DELLA GIORNATA:** `array.set(timeframes_options, N, input(defval='None', options=['Long','Short','None'], title='HHMM-HHMM'))` × 48. **L'ottimizzatore sceglie, per ciascuna delle 48 mezz'ore e in modo indipendente, se comprare, vendere o stare fermo.** ➡️ 🎯 **QUESTO SCARTO VALE PIÙ DI MOLTI PROMOSSI, e va letto due volte: è il P1 FATTO NEL MODO SBAGLIATO.** Lo spazio di ricerca è **3^48**. Qualunque risultato positivo di questo script è, con probabilità ~1, rumore. **È l'illustrazione vivente della trappola scritta al §8**, e la ragione per cui il round del P1 deve dichiarare PRIMA quale ora la tesi prevede |
| **S27** | **`Timeframe Time of Day and Day of Week Buying and Selling Strategy`** | stesso autore · created **2021-08-18** · **126 like** · 169 righe | 🔴 **Lo stesso, moltiplicato per cinque giorni.** Non l'ho letto oltre l'intestazione degli input: il §4 non si ammorbidisce, e il motivo è già scritto sopra |
| **S28** | **`Forex Master v4.0 (EUR/USD Mean-Reversion Algorithm)`** | [`PUB;2765`](https://www.tradingview.com/script/2765/) · @Stable_Camel · Pine **v2** · **3.319 like** — 🥇 **la strategia forex più votata che ho incontrato in sette cacce** · **36 righe** | 🔴 **FUORI DAL MANDATO NON NEGOZIABILE: nessuna sessione, nessun flat, tiene overnight.** Le uniche uscite sono `strategy.exit(..., profit = 500, loss = 500)`. 🟢 **Ma il motore merita una riga onesta, perché non è spazzatura:** `Condition1 = crossover(Price, Lower) and SmoothedADX1 < SmoothedADX2`, cioè **fade della banda inferiore SOLO quando l'ADX sta scendendo** (ema6 del DX sotto la ema12). **Il regime è costitutivo, non appiccicato** — non è il "coltello che cade" di R60. ⚠️ **Nessun sizing, Pine v2 del 2014-2018, e i 3.319 like sono popolarità, non evidenza.** ➡️ **Da riprendere in un mandato SENZA il vincolo intraday, non in questo** |
| **S29** | **`Intraday Forex EMA Trend Strategy (MTF + Sessions + DD)`** | [`PUB;81cd4e07...`](https://www.tradingview.com/script/81cd4e0703624c7faf1cc989a8325f76/) · @jams1811 · created **2026-02-02** · 12 like · 112 righe | 🔴 **La sessione filtra SOLO l'ingresso** (righe 17-18): le uscite sono `strategy.exit` con stop/limit (righe 94, 98), **nessun `close_all`** → **tiene overnight**, viola il requisito. Il motore è `ema(9)/ema(20)`: doppione di `CrossEma`. 🟢 Da tenere agli atti: `maxDailyDD = input.float(10.0, "Max Daily Drawdown (%)")` — **un cap di perdita giornaliera dentro l'EA** è raro e in ottica prop è la cosa giusta |

### 3.3 Le piste del mandato che ho dovuto **CHIUDERE**, e con quali prove

| # | pista | verdetto | le prove |
|---|---|---|---|
| **S22** | **"Session open/close reversal" su forex/oro** | 🔴 **CHIUSA — è il caduto R42 con un altro nome** | R42/R43: **0/24 IS e 0/24 OOS**, PF 0,50-0,93, _"è morto il MOTORE, non la gestione"_. Su TradingView, dei 236 titoli, **tutti** i "session reversal" che ho aperto sono fade dell'estremo del box. **Nessuno porta una ragione economica nuova**, e senza quella la pista non si riapre (regola Seconda Caccia) |
| **S23** | **"London/NY overlap" come meccanismo** | 🔴 **NON ESISTE COME MOTORE, né dentro né fuori** | Fuori: il tag TradingView `overlap` rende **0 strategie**; il Code Base ha **un solo** titolo con `london|new.?york|overlap|tokyo` (`GoldLondonBreakout`, già scartato tre volte). Dentro: R45 ha già misurato la finestra di Londra (**0/48**). ➡️ **L'overlap è una fascia oraria, non una tesi.** Diventa una tesi solo dentro il P1, dove l'orario **è** il meccanismo e non il contorno |
| **S24** | **Argento (XAGUSD) come simbolo nuovo** | 🟡 **RINVIATA, non chiusa** | Il tag `xagusd` rende **3 strategie**, tutte lette o adiacenti (S14 fra queste). Sul Code Base, `silver` rende **7 titoli** e **6 sono la famiglia `Exp_SilverTrend_*`** (indicatore custom da compilare a parte). ⚠️ In più c'è un precedente in casa: _"Argento orfano chiuso dallo SL server"_ (censimento 25/08). **Non porto candidati sull'argento: non ce ne sono di leggibili** |
| **S25** | **IBS (Internal Bar Strength) come filtro di mean reversion** | ⚪ **PISTA NUOVA, per un ALTRO mandato** | Comparsa **tre volte** oggi in modo indipendente (S16 + due titoli nel tag `intraday`: `Bollinger Bands Reversal + IBS Strategy`, `Average High-Low Range + IBS Reversal Strategy`). **Il progetto non l'ha mai misurata.** 🔴 **Ma è un meccanismo da barra GIORNALIERA con tenuta overnight**: fuori dal requisito non negoziabile di oggi. **Scritta qui per non perderla**, non per proporla |

---

## 4. ⬜ COSA NON HO POTUTO VEDERE — dichiarato, non taciuto

| non visto | conseguenza concreta su questo dossier |
|---|---|
| 🔴 **Il testo dei due paper del P1** (SNB, Bank of Canada, AUT, INSEAD, RePEc, EconStor, Wiley, QMUL: **tutti egress-bloccati**, misurati uno per uno oggi) | **È il buco più grave.** Ho la scheda bibliografica e l'enunciato, **non le tabelle**: quindi **non conosco la grandezza dell'effetto né se gli autori dichiarano che sopravvive ai costi.** ➡️ È il motivo per cui P1 parte come **MISURA** e non come strategia, e il motivo per cui la voce "testabile senza riscritture" prende 1 e non 2 |
| 🔴 **Le pagine strategia di Quantpedia in tema** (`intraday-currency-seasonality`, `intraday-reversal-in-currency-markets`, ...) | **Sono PREMIUM**: rendono la home page. Dalla sitemap ho **il nome dell'effetto, non le regole**. Utile come indice bibliografico (§1-ter), inutile come sorgente |
| 🔴 **Ricerca GitHub, SSRN, Forex Factory (403, settima caccia di fila)** | Zero repo nuovi, zero letteratura peer-review scaricabile, e continuo a non sapere **come sono invecchiati** i sistemi intraday su forex e oro |
| 🟡 **La grande maggioranza delle strategie TradingView raccolte** | 236 dal canale a tag + 21 leggibili dalla ricerca testuale; ne ho aperte e lette **22**, scelte in bersaglio. Il giacimento non è esaurito — ma le 22 lette sono un campione onesto della sua qualità, e la qualità è bassa |
| 🟡 **67 dei 73 titoli in tema del Code Base** | Ne ho letti **6** nel sorgente. Gli altri erano fuori bersaglio a titolo+sezione (utility, pannelli, calcolatori) o **già setacciati** (il grep degli id già a verbale ne ha esclusi 53) |
| ⚠️ **Nessun backtest è stato eseguito qui** | In questo ambiente non esistono MT5 né Strategy Tester. **Nessun numero di questo dossier è stato misurato oggi**: quelli di casa vengono dai referti citati, quelli di fuori sono etichettati `[DICHIARATO]` o `[NON VERIFICATO]` |

---

## 5. 🔄 LO STATO DEI DUE PROMOSSI DEL 25/08 — verificato in repo, non ricordato

Il mandato chiedeva esplicitamente di controllarlo. **Verificato con `ls` e
`grep` su `mql5/Experts/`, `backtest_pipeline/prove/` e i referti R108-R114:**

| promosso il 25/08 | stato oggi, 28/08 |
|---|---|
| **P1 · `ABTG_BreakingBand` su M15** (9/10) | 🔴 **MISURATO E BOCCIATO.** `R108_REFERTO.md`: **tre simboli, sei finestre su sei, tutte rosse** (GBPUSD PF 0,823 su n=227; EURUSD 0,637; AUDUSD 0,865). `R111_REFERTO.md` ha poi misurato anche M30: gradiente **MONOTONO H1 > M30 > M15**. Causa fotografata: _"non è morto di COSTO: è morto di SEGNALE"_ — a M15 incassa 6,65 pip contro perdite da 16,5. ➡️ **La porta "abbasso il TF di un motore vivo" è chiusa, ed è costata 24 minuti di tester** |
| **P2 · `KA-Gold Bot MT5`** (Code Base 48251, 9/10) | 🟡 **MAI COSTRUITO, MAI TESTATO — ancora in coda.** Nessun `.mq5`, nessun file prova, zero occorrenze fuori da HANDOFF e dai due dossier. ⚠️ **Il suo cancello zero è ancora aperto e non è cambiato: lo spread BCM sull'oro NON È MISURATO IN REPO**, e lo strumento per misurarlo (`RealCost Spread P95 Logger`, [Code Base 74148](https://www.mql5.com/en/code/74148)) è promosso dal 23/08 e **non è mai stato usato**. 📌 R108 lo dichiara esplicitamente ancora valido: _"il verdetto R108 non li tocca: il collo era il segnale della banda, non il TF in sé"_ |
| **P3 · `DayFlow VWAP Relay — Majors`** (TradingView `muhhiXQs`, 9/10) | 🟡 **MAI COSTRUITO, MAI TESTATO — ancora in coda.** Nessun `.mq5`, nessun file prova. Il prezzo dichiarato (6-10 ore di riscrittura Pine→MQL5) non è mai stato pagato |
| **P4 · `London Session Signal B`** (arXiv 2605.04004) | 🟡 **Resta IN CODA**, e per lo stesso motivo del 25/08: il classificatore è un GMM di cui il paper non dà né feature né parametri. **Non riproducibile** |

> 🎯 **La riga che conta per Claudio:** dei tre promossi del 25/08, **uno è
> stato misurato ed è morto, due sono fermi al palo da tre giorni.** Il collo
> di bottiglia della flotta **non è più trovare candidati: è costruirli.**
> ➡️ **Ed è la ragione per cui oggi il mio P1 è quello che costa meno codice
> di tutti** (una sonda di ~120 righe) e il mio P2 è **la riscrittura Pine più
> facile che abbia trovato in tre cacce** (3-5 ore contro le 6-10 del DayFlow).

---

## 6. 🧭 SCOPERTE DI PROCESSO — valgono oltre questa caccia

1. 🔧 **Il pattern Pine del memo era sbagliato** (`[0-9a-f]{32}` invece di
   `[0-9A-Za-z]{32}`) e produceva **falsi "non letti"**: 1 su 7 il 25/08.
   **Corretto oggi in `PROMEMORIA_SBLOCCO_FONTI.md`**, e il buco S21 del 25/08
   è chiuso con un verdetto.
2. 🔓 **La sitemap di Quantpedia rende 1.118 slug contro gli 82 della pagina
   `/strategies`.** La nota _"non ricontrollarla"_ del 25/08 va **cancellata e
   sostituita**: Quantpedia è un **indice di effetti** (gratuito), non un
   ricettario (a pagamento).
3. 📕 **`SETACCIO_MANUALE.md` non è l'indice completo degli scarti.** Il grep
   degli id già setacciati su `caccia_strategie/*.md` ne rende **53**, ma i
   file `report/SWEEP_MECCANISMI_*.md` ne contengono altri **che non sono
   indicizzati lì** — infatti oggi ho riletto 19500 e 17474, già scartati il
   22/08. ⚠️ **Costo: ~15 minuti.** ➡️ **Il prossimo cacciatore deve grep-are
   `report/SWEEP_*` insieme a `caccia_strategie/*`**, oppure qualcuno deve
   consolidare gli id in un unico file.
4. 🚨 **"ZERO RISULTATI SU UN TAG" NON È UNA MISURA DI ASSENZA — e me ne sono
   accorto smentendo me stesso, a caccia in corso.** Avevo misurato che i tag
   `killzone`, `timeofday`, `hourofday`, `overlap`, `asiansession` rendono
   **zero strategie**, e avevo scritto che _"su TradingView l'ora del giorno
   come motore non esiste"_. **La ricerca testuale `time of day` ne rende
   TRE**, tutte col sorgente leggibile — e una è **l'implementazione di
   riferimento della sonda del P1** (P4). ➡️ **Regola nuova per il prossimo
   cacciatore: un tag vuoto va verificato con la ricerca testuale PRIMA di
   scriverne una conclusione.** Costa una richiesta; scriverne una conclusione
   sbagliata costa un dossier.
   🟡 **Quello che resta vero, riformulato onestamente:** l'ora del giorno come
   motore su TradingView è **raro e fatto male** — le tre implementazioni
   trovate sono **una sonda senza stop** (P4) e **due macchine da overfitting
   con 48 e 240 input categorici** (S26, S27). **Nel Code Base esiste, ma solo
   dentro martingale** (S1, S2, S3). ➡️ **Il terreno del P1 non è vergine: è
   calpestato male.** Il che è insieme l'argomento migliore (nessuno l'ha
   misurato con disciplina) e il campanello d'allarme (in 3^48 celle qualcosa
   di verde si trova sempre). **Lo decide la nostra misura, coi criteri
   congelati prima.**

---

## 7. 📦 IL FILE PROVA DEL CANDIDATO NUMERO UNO

Consegnato: **`backtest_pipeline/prove/SONDA_OROLOGIO_FX.txt`**

⚠️ **Non è un file prova di strategia: è un file prova di MISURA**, e il
formato lo dichiara in testa. La sonda (`ABTG_SondaOrologio.mq5`) **non
esiste ancora** e va costruita dalla filiera `mql5-ea-developer` →
`verificatore`: ~120 righe, nessun indicatore, un solo compito — **entrare
all'inizio di ogni blocco orario e uscire alla fine, su tutte e 24 le ore, e
scrivere per ciascuna il lordo medio, il numero di operazioni e lo spread
mediano IN QUELLA ORA.**

**Le date `@DAQUANDO`, MISURATE e non ipotizzate:**

| simbolo | inizio storico misurato | fonte della misura |
|---|---|---|
| GBPUSD | **1993.05.11** | sonda `PrimaDataTF` del 17/08 (`R102_ABTG_BreakingBand_GBPUSD_772161.txt`, riga 117) |
| EURUSD | **1971.01.03** (serie ricostruita) | idem (`R102_..._EURUSD_772162.txt`, riga 117). ⚠️ **L'euro non esiste prima del 1999.01.04** (`R102_CRITERI.md` riga 350): prima è sintetica |
| XAUUSD | **2004.06.11** | R100, dichiarato in `R102_CRITERI.md` riga 156 (2004.06.11 → 2026.06.30) |

**La finestra proposta è 2011.01.01 → 2026.06.30**, e il motivo è aritmetico,
non estetico: il tetto del tester è **100.000 barre**; su H1 il forex fa ~120
barre a settimana → 100.000/120 = **833 settimane = 16,0 anni**. 15,5 anni
stanno dentro con margine, e coprono **quattro regimi** (toro, orso, laterale,
crollo 2020) — che è ciò che chiede l'Emendamento della Finestra, punto C.

---

## 8. ❓ LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## 🎯 **"Su EURUSD, GBPUSD e XAUUSD, esiste UNA fascia oraria in cui il rendimento LORDO medio per giornata vale almeno TRE VOLTE lo spread mediano misurato IN QUELLA STESSA ORA — oppure la tabella oraria è piatta e l'orologio, sul nostro broker, non è un motore?"**

**Non "quanto guadagna l'orologio". Non "qual è l'ora migliore".** Questa e
solo questa, e ha una risposta a due gradini:

1. **PASSO 0 (cancello zero, si legge PRIMA di ogni P/L):** la tabella
   **24 ore × 3 simboli** del lordo medio per giornata, **affiancata alla
   tabella dello spread mediano nella stessa ora**. Se nessuna cella supera
   **3× il suo spread**, ➡️ **il round si chiude qui, la pista dell'orologio
   si chiude con un numero NOSTRO, e il verdetto D7 del 22/08 esce
   CONFERMATO ED ESTESO** da "il minuto del fix" a "tutte le ore della
   giornata". **Sarebbe una risposta scomoda, ma sarebbe una risposta**, e
   costa una passata.
2. **Solo se il PASSO 0 è verde:** IS/OOS coi cancelli di casa,
   **@DAQUANDO come sopra**, cella scelta al **centro dell'altopiano, MAI al
   picco** (12 Spearman IS→OOS negative su 13), e **verdetto SOLO a tick
   reali**.

🚨 **E la trappola da dichiarare PRIMA, perché su 24 celle è la più facile in
cui cadere:** con 24 ore × 3 simboli × 2 lati ci sono **144 celle**, e a caso
qualcuna sarà verde. ➡️ **La cella non si sceglie perché è la più verde: si
sceglie perché è quella che la TESI aveva indicato PRIMA** (le ore locali
della valuta), e le altre 143 servono a dire se l'altopiano esiste o se è
rumore. **Se l'ora verde non è quella che la tesi prevedeva, il round è
NEGATIVO anche se il numero è positivo.** Questa riga va copiata nei criteri
e firmata prima di lanciare.

📌 **E non è una preoccupazione teorica: la trappola ha un nome e un
indirizzo.** È **S26** (§3.2-bis), `Timeframe Time of Day Buying and Selling
Strategy`, **193 like su TradingView**: quarantotto input categorici
Long/Short/None, uno per ogni mezz'ora, spazio di ricerca **3^48**. **È
esattamente il P1 lasciato libero di scegliersi le ore dopo aver visto i
numeri.** ➡️ **Va messo sotto gli occhi di chi firmerà i criteri del round,
come esempio di ciò che il round NON deve diventare.**

---

## 9. 📋 RIEPILOGO PER LA CODA

| # | oggetto | dove vive | buco che riempie | punti | verdetto | cosa serve |
|---|---|---|---|---:|---|---|
| **P1** | **`L'OROLOGIO` — deriva intraday per blocco di sessione** (Breedon & Ranaldo 2013 · Krohn/Mueller/Whelan 2024) | fuori, **bibliografia verificata, TESTO NON LETTO** | **il primo motore della flotta che NON guarda il prezzo.** 36 sedie su 36 guardano il prezzo | **9/10** | 🟢 **PROVA SUBITO, come MISURA** | una sonda di ~120 righe + **una passata**. File prova consegnato: `prove/SONDA_OROLOGIO_FX.txt` |
| **P2** | **`Money maker EURUSD 15min`** (TradingView `jU2JCWZr`, **Pine letto**, MPL 2.0) | fuori | **forex M15 con FLAT OBBLIGATORIO a fine sessione** + tetto 2 op/giorno: il bersaglio esatto del mandato FTMO | **7/10** | 🟡 **IN CODA, subito dietro P1** | 3-5 ore di riscrittura Pine→MQL5 + **la cella di ablazione senza finestra oraria** (senza quella è un doppione del SuperWave) |
| **P3** | **`SP500 Session Gap Fade`** (`J1U1NNgx`, © exlux, MPL 2.0) | fuori | — | — | 🟢 **PROMOSSO COME SPECIFICA, SCARTO COME EA** | copiare il `flat_before_min` (chiusura **N minuti PRIMA** della fine sessione) in **ogni** EA intraday che costruiremo |
| **P4** | **`Mateo's Time of Day Analysis LE-SE`** (`PUB;f4933822...`, @MateoH_, **Pine letto**) | fuori | — | — | 🟢 **PROMOSSO COME STRUMENTO** (senza SL non è un EA) | è la **sonda del P1 già scritta in 47 righe**: riferimento per `mql5-ea-developer` |
| S1-S6 | **sei scarti da sorgente `.mq5`** | — | — | — | 🔴 | motivo + riga di codice, §3.1 |
| S7-S21 | **quindici scarti da sorgente Pine** (canale a tag) | — | — | — | 🔴 | motivo + riga di codice, §3.2 |
| 🚨 **S26** | **`Timeframe Time of Day`** — 48 input categorici, spazio 3^48 | — | — | — | 🔴 | **è il P1 fatto male**: da leggere PRIMA di scrivere i criteri del round, §3.2-bis |
| S27-S29 | tre scarti dalla ricerca testuale (fra cui la strategia forex **più votata** della piattaforma, 3.319 like, fuori mandato perché tiene overnight) | — | — | — | 🔴 | §3.2-bis |
| S22-S25 | **quattro piste del mandato**, chiuse o rinviate con le prove | — | — | — | 🔴/🟡/⚪ | §3.3 — servono a non ricercarle il giro dopo |

---

## 10. 🧾 ONESTÀ FINALE — la riga che Claudio deve leggere due volte

**Il web gratuito, sul bersaglio esatto di oggi — "motore intraday su
forex/oro che chiude in giornata" — ha UN SOLO oggetto leggibile, e non è
nemmeno bello.** 236 strategie TradingView raccolte a tag più 21 dalla ricerca
testuale, **22 Pine letti riga per riga**, 1.598 titoli del Code Base, 6
`.mq5` letti: **uno solo** ha finestra d'ingresso + flat obbligatorio +
rischio in % + take sopra il costo. Degli altri ventuno Pine: **otto sono
senza stop loss**, **quattro mettono la tesi dentro un `input`** (uno di loro
la mette in 48 input), **tre usano il 100% dell'equity per operazione**,
**sette tengono overnight**. **E il Code Base, sull'orologio, ha solo
martingale.**

🎯 **Ma la conclusione operativa NON è "niente da fare". È che oggi la cosa
più preziosa non l'ha portata il codice: l'ha portata la BIBLIOGRAFIA.**
Due riviste di prima fascia, a undici anni di distanza, dicono che le valute
hanno una deriva legata all'orario d'ufficio del flusso — e nessuno,
**né sul Code Base né su TradingView**, l'ha mai messa dentro un motore che
non sia una martingala. **È un terreno vergine con una tesi economica che
nomina la controparte, due parametri, flat per costruzione, e si falsifica
in una passata di tester.**

⚠️ **E il limite va riletto insieme all'entusiasmo: quei due paper non li ho
potuti aprire.** Non ho le tabelle, non ho la grandezza dell'effetto, non so
se sopravvive ai costi — e il progetto ha già detto NO a un cugino stretto di
questo meccanismo (D7, il fix delle 16:00, il 22/08). **Per questo il primo
round non è una strategia: è una tabella 24×3 che costa una passata e che
chiude la pista in un verso o nell'altro, con numeri nostri, per sempre.**

> 🏛️ **E la riga per le prop, che è il vero motivo del mandato:** se
> l'orologio misura qualcosa, quello che ne esce è **il profilo di rischio
> che FTMO preferisce e che noi non abbiamo**: esposizione dentro un blocco di
> ore noto a priori, zero overnight, zero gap del weekend, zero swap, nessuna
> restrizione sul conto finanziato, **e leva 1:100 mantenuta**. Se non misura
> niente, abbiamo speso una passata e chiuso una pista che tornava a bussare
> a ogni caccia.

---

_Dossier compilato il 28/08/2026. Fonti aperte davvero: **MQL5 Code Base**
(catalogo completo 1.598 titoli, 6 sorgenti `.mq5` scaricati, decodificati e
letti), **TradingView** (26 tag → 236 strategie raccolte, **più 10 query alla
ricerca testuale** → 21 strategie leggibili; **22 Pine scaricati e letti via
pine-facade**), **arXiv** (8 query API), **Quantpedia** (sitemap: 1.118 slug
strategia + 1.155 post; 3 pagine aperte), **motore di ricerca web** (4 query,
usato SOLO per la scheda bibliografica). Fonti dichiarate NULLE: GitHub
ricerca via `curl` (403), SSRN (403), Forex Factory (403) — **settima caccia
di fila per tutte e tre**. ⚠️ **Su GitHub la sessione gemella ha misurato oggi
che lo strumento `WebFetch` passa dove `curl` prende 403: il canale NON è
morto, è morto il trasporto** (`PROMEMORIA_SBLOCCO_FONTI.md` agg. 28/08 §B) —
**io non l'ho usato in questa caccia**, e lo dichiaro invece di attribuirmelo.
Host bloccati all'egress: 13, elencati al §1.
**Nessun numero di performance dichiarato da un autore ha pesato su un
punteggio.** Nessun EA nostro è stato toccato, nessun parametro in forward è
stato modificato, nessun codice EA è stato scritto._

_Attribuzione, come da regola di casa — la citazione va ripetuta **in testa a
qualunque `.mq5` derivato**:_
- _`Money maker EURUSD 15min` è di **© SoftKill21** (TradingView `jU2JCWZr`),
  **Mozilla Public License 2.0**_
- _`SP500 Session Gap Fade Strategy` è di **© exlux** (TradingView `J1U1NNgx`),
  **Mozilla Public License 2.0**_
- _`Trade Hour V4` è di **© mablue (Masoud Azizi)** (TradingView `4KxpN6N6`),
  **Mozilla Public License 2.0** — citato come reperto, non promosso_
- _`Mateo's Time of Day Analysis LE-SE` è di **@MateoH_** (TradingView
  `PUB;f493382224324212b424bd89b27ddd9f`) — **licenza [INCERTO]: nessuna
  dichiarata nel sorgente.** ⚠️ Prima di derivarne codice, la licenza va
  chiarita: qui è citato come **riferimento di specifica**, e la sonda va
  scritta da zero_
- _il canale di ricerca testuale di TradingView (§1-quater) e la diagnosi
  GitHub sono stati **trovati dalla sessione gemella del 28/08**
  (`CACCIA_INTRADAY_INDICI_2026-08-28.md`): qui il primo è stato **applicato e
  verificato in proprio**, il secondo solo citato._
- _il meccanismo del P1 è di **Breedon, F. e Ranaldo, A.** (JMCB 2013, 45(5),
  953-965) e **Krohn, I., Mueller, P., Whelan, P.** (Journal of Finance 2024 /
  Bank of Canada SWP 2021-48). **Testo NON letto: egress bloccato.**_
