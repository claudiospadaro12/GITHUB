# 🏹 SWEEP DEI MECCANISMI LIBERI — 22/08/2026

**Mandato di Claudio:** _"...o un motore che secondo te può essere di spunto.
Facciamola meglio che si può questa ricerca."_ — metà **gratuita** della
caccia (Code Base, TradingView, GitHub, Forex Factory, Quantpedia/SSRN/arXiv,
QuantConnect). I prodotti a pagamento li sta guardando un altro agente.

**Regola d'ingaggio applicata:** REGOLA DELLA SECONDA CACCIA (`CLAUDE.md`) —
si cercano **MECCANISMI alternativi sulla stessa inefficienza**, mai parametri
diversi di un motore già morto. Ogni candidato è passato prima dalla lista dei
caduti (`backtest_pipeline/REGISTRO_TEST.md`, referti R42/R45/R63/R82/R89,
`SETACCIO_MANUALE.md`, le cacce del 16/08, 19/08 e 21/08).

---

## ⚡ IL RISULTATO IN UNA RIGA

> Ho setacciato **l'INTERO Code Base MT5 degli Expert** — **1.595 titoli
> unici, tutte e 40 le pagine, pagina 41 e 42 vuote** [VERIFICATO] — più 4
> interrogazioni all'API arXiv, 4 ricerche web, 2 paper letti **per intero nel
> PDF**. **10 sorgenti `.mq5` scaricati e letti riga per riga.**
>
> **Sul buco NASDAQ-IN-APERTURA porto due cose, e la seconda vale quanto la
> prima**: 🥇 un **meccanismo nuovo con paper letto** (il *market intraday
> momentum*: il primo mezz'ora predice l'ultimo mezz'ora) e 🥈 una
> **falsificazione indipendente su 947 giorni di Nasdaq futures** che ammazza
> 14 famiglie di segnali intraday — fra cui **esattamente l'ORB che abbiamo
> già seppellito noi** — e che dice **per quale motivo strutturale** muoiono.
>
> **Sul buco JPY/NIKKEI la risposta onesta è più magra**: **zero EA gratuiti
> col sorgente** che facciano qualcosa di strutturalmente nuovo. Porto **due
> ipotesi di meccanismo** (una derivata dal paper MNQ, una dal momentum
> intraday applicato alla sessione di Tokyo) e **dichiaro che il paper
> specifico sul Nikkei — che esiste ed è del 2026 — NON sono riuscito a
> leggerlo: ScienceDirect è bloccato dal proxy.**
>
> 🔴 **E porto uno scarto che vale un round risparmiato**: il candidato che
> sembrava il migliore del Code Base (`003 - Weekly Day Reversal`) è **il
> fratello di un motore che abbiamo già misurato MORTO in R63** (0 celle su
> 24 fuori campione). Era già stato scartato per iscritto il 16/08. **Non si
> ricompra.**

---

## 1. 📡 COPERTURA DICHIARATA — controllo positivo, fonte per fonte

Misurato oggi, 22/08/2026, non ipotizzato.

| fonte | HTTP | cosa ho verificato sulla pagina | esito |
|---|---|---|---|
| **MQL5 Code Base** `/en/code/mt5/experts` | **200** | pagine 1→40 rendono `id + titolo` nell'HTML → **1.595 id unici**; pagg. 41-42 **0 elementi** = fine del catalogo. Sulle schede leggo titolo, **autore**, **data**, **`UserDownloads:`**. `/en/code/download/<id>` restituisce lo **ZIP col `.mq5`** | 🟢 **PASSA IN PIENO** (l'unica fonte completa della giornata) |
| **arXiv API** (`export.arxiv.org`) | **200** | 4 query, titoli/autori/date veri; PDF scaricabili (`/pdf/<id>` → 1,1 MB e 2,0 MB, convertiti e letti) | 🟢 **PASSA, e stavolta NON è sterile** |
| **Ricerca web** | 200 | usata solo per **trovare** URL, mai come fonte di fatti | 🟢 passa come indice |
| **Quantpedia** | **466 / 200** | `/strategies/` **redirige** su `/screener` (JS, nessuno slug nell'HTML); `sitemap.xml` → **466 "Access Forbidden"**; 6 slug provati a mano → **5 su 6 in 466**, funziona solo `fx-carry-trade` già noto | 🟡 **QUASI NULLA oggi** (peggiorata rispetto al 21/08, quando rendeva 82 slug) |
| **TradingView** | 200 | `/scripts/meanreversion/` rende **solo la navigazione**: **zero link `/script/`**, **zero `//@version`**, zero `strategy(` | 🔴 **NON SETACCIABILE** — senza sorgente il setaccio non è applicabile |
| **GitHub — ricerca e API** | **403** | `api.github.com/search/...` risponde _"sessions are bound to their configured repositories"_; `github.com/search` idem; `gh` CLI assente | 🔴 **NULLA per la ricerca** (`raw.githubusercontent.com` resta leggibile **se** conosco già l'URL) |
| **Forex Factory** | **403** | — | 🔴 **NULLA.** I thread storici — l'unico posto dove si legge *come una strategia è invecchiata* — **non li ho potuti leggere.** Terza caccia di fila |
| **SSRN** | **403** | Cloudflare | 🔴 **NULLA.** Terza caccia di fila |
| **ScienceDirect** | **EGRESS_BLOCKED** | proxy | 🔴 **NULLA** — ed è dove sta **il paper sul Nikkei** (§4.1) |
| **redfame.com**, **priceactionlab.com** | **EGRESS_BLOCKED** | proxy | 🔴 **NULLE** — sono le due fonti che discutono il *Turnaround Tuesday* (§6.1) |
| **QuantConnect** | 200 | `/learning/articles/investment-strategy-library` scarica 45 KB di **guscio JS**: zero link agli articoli nel testo | 🔴 **contenuto non leggibile** |

### Cosa ho sfogliato dove ha funzionato

- **Code Base:** **1.595 titoli** (catalogo completo), filtrati con
  `nasdaq|nas100|us100|dow|index|opening|orb|gap` ·
  `jpy|yen|nikkei|asian|tokyo|overnight|carry|night|correlat` ·
  `prop|guard|protect|risk|equity|drawdown|limit` ·
  `mean.?rever|fade|sweep|liquidity|vwap|seasonal|session|hour`.
  📌 Reperto di struttura: **535 titoli su 1.595 (34%) sono `Exp_*`**, cioè
  involucri di indicatori della stessa serie. Il catalogo è molto meno vasto
  di quanto sembri.
- **10 sorgenti scaricati e letti:** `73870`, `76288`, `49713`, `76331`
  (+3 `.mqh` inclusi), `76333`, `52043`, `74137`, `19500`, `17474`, `17528`.
- **2 paper letti INTERI nel PDF** (non l'abstract): arXiv **2605.04004v2**
  (15 pagine) e **1501.07778v2** (22 pagine). Più il PDF del paper di
  Gao-Han-Li-Zhou (**1.868 righe di testo estratto**) letto nelle sezioni
  che contano: strategia, out-of-sample, costi di transazione.

---

# 🎯 PARTE A — IL BUCO N.1: NASDAQ IN APERTURA

_Contesto: `ABTG_Nasdaq_Apertura_US` (770201) è **spenta dal 18/08**
(`report/FIRMA_2026-08-21_DUE_SEDIE.md`), e **R97 sta girando adesso** su un
motore diverso (l'ORB a stop largo). Quindi qui non porto un altro ORB: quello
sarebbe il difetto già pagato._

---

## 🥇 A1 — `MARKET INTRADAY MOMENTUM`: il primo mezz'ora predice l'ultimo

```
NOME            Intraday Momentum: The First Half-Hour Return Predicts
                the Last Half-Hour Return  (poi pubblicato come
                "Market Intraday Momentum", Journal of Financial Economics)
AUTORI          Lei Gao (Iowa State) · Yufeng Han (Colorado Denver)
                Sophia Zhengzi Li (Michigan State) · Guofu Zhou (WashU)
DATA            prima stesura marzo 2014 · versione letta: dicembre 2015
FONTE / URL     PDF letto per intero:
                https://c.mql5.com/forextsd/forum/173/intraday_momentum_-_the_first_half-hour_return_predicts_the_last_half-hour_return.pdf
                scheda SSRN (403 dal nostro proxy):
                https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2440866
CAMPIONE        SPY (ETF S&P 500), dati ad alta frequenza 1993-2013
                + 10 ETF fra i più scambiati + 2 futures su indici esteri
CODICE          ❌ NESSUNO. È un paper. L'EA lo scriviamo noi.
```

### 🧭 TESI IN UNA RIGA

> **"Chi ha informazione entra all'apertura e RIBILANCIA alla chiusura: il
> segno dei primi 30 minuti dice da che parte sta l'ordine grosso che tornerà
> a farsi vedere negli ultimi 30 minuti."**

_(Il paper lo dice così: «the intraday momentum is consistent with the trading
behavior of informed traders» — [VERIFICATO], abstract.)_

### ⚙️ MECCANICA — tre righe, ed è tutta qui

| | |
|---|---|
| **SEGNALE** | `r1` = rendimento della **prima mezz'ora** dalla chiusura di ieri |
| **INGRESSO** | all'inizio dell'**ultima mezz'ora**: LONG se `r1 > 0`, SHORT se `r1 ≤ 0` |
| **USCITA** | **alla chiusura del cash, sempre.** Zero overnight, per costruzione |

Variante col doppio segnale (`r1` **e** `r12`, cioè la penultima mezz'ora):
si opera **solo se i due concordano**, altrimenti si sta fuori.

### 📊 I NUMERI DELL'AUTORE — **[DICHIARATI, NON MISURATI DA NOI]**

🔴 Non pesano su nessun punteggio. Li riporto perché descrivono la **forma**
del motore, che è la cosa che ci serve:

| | η(r1) | η(r1,r12) |
|---|---:|---:|
| rendimento medio annuo OOS | **6,67%** | 2,10% |
| deviazione standard | 6,19% | — |
| Sharpe | **1,08** | — |
| **success rate** (giornate ≥ 0) | 54,37% | **77,05%** |

- **R² fuori campione 1,2%** col solo `r1`; sale a 2,6% in campione col
  doppio predittore, e a **3,3% quando la volatilità del primo mezz'ora è
  alta**. [VERIFICATO, §1 e §2.2]
- **Costi di transazione:** l'autore li applica dopo la decimalizzazione
  (post 1/7/2001) e misura una riduzione di **1,22 punti percentuali**
  (da 5,52% a **4,30%** annuo). **L'edge sopravvive, ma si mangia un quinto.**
  [VERIFICATO, §"transaction costs"]
- **La predittività sale** nei giorni **volatili**, ad **alto volume**, in
  **recessione** e nei giorni di **grande news macro**. [VERIFICATO, abstract]

### 🚨 IL LIMITE CHE DEVE STARE IN PRIMA PAGINA, NON IN NOTA

> Il paper dichiara: l'intraday momentum **esiste su FTSE 100 e EuroStoxx 50
> futures**, ma **NON esiste sulle valute né sulle materie prime** — e ne dà
> il motivo strutturale: *«unlike the stock market, the daily open and close
> for currency and commodity futures are [not well defined]»*. [VERIFICATO,
> introduzione, righe 144-148 del testo estratto].
>
> 👉 **Conseguenza operativa, dichiarata prima dei numeri: questo motore vive
> SOLO su strumenti con una campanella vera.** Nasdaq ✅, DAX ✅, Nikkei ✅.
> **Oro ❌, forex ❌.** Chi proverà a spalmarlo sul paniere sta già pescando.

### 🕐 GLI ORARI, IN ORA SERVER BCM — e non li invento

| | ora server BCM | da dove viene |
|---|---|---|
| apertura cash US | **14:30** | `CLAUDE.md`, regola fissa [VERIFICATO] |
| **finestra del segnale** | **14:30 → 15:00** | derivata |
| **ingresso** | **20:30** | derivata |
| **chiusura cash US** | **21:00** | `report/DIARIO.md` — l'ORB live (magic 770611) ha già `chiusura 21:00` [VERIFICATO nel repo] |

📌 **Gli ancoraggi esistono già nel nostro codice**: non c'è niente da
indovinare sul fuso, ed è raro.

### 🏛️ LA RIGA PROP — e qui il motore è forte

1. **Esposizione totale: 30 minuti al giorno.** Il muro giornaliero del 5%
   (−5.000 su 100k) si può violare solo con una candela di mezz'ora
   catastrofica: **è strutturalmente il motore più gentile col cap
   giornaliero** fra tutti quelli guardati oggi.
2. **Zero overnight, per costruzione.** Niente gap contro, niente swap,
   niente sorprese al riavvio del VPS.
3. **Scorrelazione ORARIA vera:** alle 20:30 server **non abbiamo nessuno**.
   Le nostre aperture sparano alle 08:00 e alle 14:30. Questo è il criterio
   §7-bis.3 (_"il DD della prop è UNO"_) preso sul serio: non è un altro EA
   sullo stesso segnale, è un altro **momento della giornata**.
4. **~250 operazioni l'anno**, una al giorno → i 15 trade della regola di casa
   in **tre settimane**, i 30 del `ROTTA_PROP` in **sei**. È il motore più
   veloce da giudicare che abbia trovato.
5. 🔴 **CONTRO — e va detto adesso:** il paper **non ha stop loss**. È uno
   studio sui rendimenti, non un EA. **Lo stop lo mettiamo noi, e cambierà la
   distribuzione.** Senza stop il rischio della mezz'ora è illimitato; con uno
   stop stretto si taglia proprio la coda che paga.
6. 🔴 **CONTRO n.2, quantificato [INFERITO]:** 6,67% annuo su ~250 giorni fa
   **~2,7 punti base al giorno**. Su un Nasdaq a ~20.000 punti sono **~5 punti
   indice lordi per operazione**. Con lo spread di BCM su NASUSD (1-2 punti)
   se ne va **il 20-40% del lordo**. È esattamente la ferita di R55
   (_"lo spread come percentuale dello stop"_) e **il paper A2 qui sotto
   spiega perché quel conto uccide quasi tutto.** Questo numero va **misurato
   sul nostro spread** prima di qualunque entusiasmo.

### 🧮 SCHEDA DI PUNTEGGIO

```
[2] semplicità              -> 1 regola, 0 indicatori, ~5 input veri
[2] il filtro È il motore   -> la direzione la decide r1: non c'è nient'altro
[2] tesi di mercato         -> ribilanciamento degli informati, scritta sopra
[2] riempie un BUCO         -> Nasdaq scoperto + fascia 20:30 server scoperta
[1] testabile senza riscritture -> l'EA NON esiste: va scritto (~250 righe)
------------------------------------------------------------------
PUNTEGGIO 9/10  ->  🟢 PROVA SUBITO
```

**PERCHÉ:** è l'unico oggetto della giornata che ha **una tesi pubblicata, un
campione di vent'anni, i costi dichiarati, e un orario che non collide con
nessuna sedia viva** — e il codice da scrivere è una macchina a stati da un
pomeriggio.

### 📄 BOZZA DEL FILE PROVA (proposta, **non scritta in `prove/`**)

_Come da mandato non scrivo codice né file prova: questa è la forma che
propongo, da rifinire con Claudio. **Nomi degli input vincolanti per chi
scriverà l'EA** (`LEGGIMI.md`: un nome sbagliato e MT5 ignora la riga in
silenzio)._

```
# IPOTESI: sul Nasdaq il SEGNO del primo mezz'ora di cash (14:30-15:00 server)
#          predice il segno dell'ultimo mezz'ora (20:30-21:00 server).
#          Fonte: Gao, Han, Li, Zhou (2015). Nostro edge = zero finché non è misurato.
# CRITERI DI ACCETTAZIONE (congelati PRIMA dei numeri):
#   1. n >= 150 in campione (a ~250 op/anno = ~8 mesi: abbondante)
#   2. il LATO SHORT si legge da solo (malattia R52: mai spegnere un lato
#      guardando i risultati -> due passate diagnostiche, mai un asse)
#   3. peggior giornata > -2,5% al rischio 1% (con 1 op/giorno e 1 posizione
#      un valore peggiore di ~1R è un BUG, non un risultato)
#   4. altopiano, MAI il picco (12 Spearman IS->OOS negative su 13)
#   5. verdetto SOLO a tick reali (R57)
#   6. 🔴 CANCELLO ZERO, da guardare PRIMA di tutto: il profitto lordo medio
#      per operazione in PUNTI INDICE contro lo spread medio misurato di
#      NASUSD nella finestra 20:30-21:00. Se il lordo non è almeno 3x lo
#      spread, il round si chiude qui e non si spazzola nient'altro (A2).
@SIMBOLO  NASUSD
@PERIODO  M5
@DAQUANDO                <- 🔴 VUOTO APPOSTA. Da misurare con
                            scarica_storico.ps1 -Simboli "NASUSD" -SoloReferto.
                            Sugli indici il driver diceva 2024.01.01 e i dati
                            partivano dal 26/09/2024: mezza finestra IS non c'era.
InpSignalStartHour=14||14||0||14||N     # ora SERVER, non si spazzola: è la campanella
InpSignalStartMin=30||30||0||30||N
InpSignalMinutes=30||30||15||60||Y      # 15/30/60: il paper usa 30, gli altri due sono i bordi
InpEntryHour=20||20||0||20||N           # ora SERVER
InpEntryMin=30||30||0||30||N
InpExitHour=21||21||0||21||N            # chiusura cash, ora SERVER
InpUseSecondSignal=0||0||0||1||Y        # r12: il doppio segnale del paper (77% success rate)
InpSLatrMult=...                        # 🔴 DA DECIDERE CON CLAUDIO: il paper NON ha stop
InpRiskPercent=1.0||1.0||0||1.0||N      # 1% per restare confrontabili con l'archivio
```

⚠️ Griglia volutamente **minuscola**: 3 × 2 = 6 celle. È uno **screening**, e
l'asse che conta è il **cancello zero sullo spread**, non la taratura.

---

## 🥈 A2 — LA FALSIFICAZIONE INDIPENDENTE SU 947 GIORNI DI NASDAQ

> **Questo non è un candidato. È il metro.** E secondo me è il pezzo più utile
> che porto oggi, perché **conferma da fuori, con dati che non sono i nostri,
> tre round che abbiamo già pagato di tasca nostra** — e dice **perché**.

```
NOME       Structural Limits of OHLCV-Based Intraday Signals in MNQ Futures:
           A Systematic Falsification Study
AUTORE     Mathias Mesfin (Independent Researcher)
DATA       arXiv 2605.04004v2 — 5 maggio 2026, revisione 13 luglio 2026
URL        https://arxiv.org/abs/2605.04004  ·  PDF letto per intero (15 pagine)
CAMPIONE   72.604 barre 5-min di MNQ (Micro E-mini Nasdaq 100), 09:30-16:00 ET,
           dicembre 2021 - agosto 2025 -> 947 giornate complete
METODO     walk-forward a finestra espansiva · T-stat >= 2,0 OOS · n >= 30 ·
           netto dopo 2,0 punti di attrito · stabilità su TUTTI gli anni ·
           test di permutazione p < 0,05. **Tutti e cinque insieme.**
```

### 💀 QUATTORDICI FAMIGLIE DI SEGNALI, ZERO PROMOSSE

Le righe che ci riguardano direttamente [VERIFICATE, tabelle 3-8 del PDF]:

| famiglia | n | netto medio (punti) | T | il nostro caduto corrispondente |
|---|---:|---:|---:|---|
| **ORB long, uscita a bar+1** | 447 | −0,82 | 1,17 | A4 / R45 / capitolo M5 chiuso |
| **ORB long, uscita a bar+15** | 447 | **+2,82** | **1,50** | ← *la variante meno peggio* |
| **ORB short, bar+1** | 428 | −3,45 | −1,33 | R52, il lato short |
| **ORB con ingresso sul PULLBACK** | 83 | **−4,44** | −1,27 | 🔴 **80,7% di stop-out**, win rate **19,3%** |
| **espansione sessione ASIA, continuazione** | — | −2,27 | **−10,96** | (vedi §B2 — è il reperto JPY) |
| **liquidity grab ASIA, fade** | 6.442 eventi | −2,20 | **−14,12** | ⚠️ vedi il caveat sotto |
| **gap fill fade** | ~240/anno | −1,31…−2,24 | −0,32…−0,59 | — |
| **gap continuation SHORT** | **22** | **+14,52** | **+3,23** | 🟡 bocciato **solo** per n<30 |
| **spike di volume (4 varianti)** | 723-2.409 | −1,94…−2,50 | ~0 | nulli precisi, non inconcludenti |
| **drift post-news, da bar+6** | 993 eventi | — | 0,14-0,69 | ⚠️ riguarda la nostra famiglia PostNews |

### 🎯 LE TRE FRASI CHE VALGONO IL DOCUMENTO

**1. Il soffitto strutturale — e spiega TUTTI i nostri morti sul Nasdaq:**

> _«Across all fourteen signal families, the maximum achievable gross return
> before friction is roughly 1.05 to 1.50 points... The 2.0-point friction
> cost consistently exceeds this.»_ [VERIFICATO, §6.1]

👉 Tradotto in casa nostra: **non abbiamo sbagliato la taratura, stavamo
raccogliendo meno di quanto costava raccoglierlo.** È R55 (_lo spread come
percentuale dello stop_) dimostrato su un campione che non è il nostro.

**2. Come sono fatti i DUE segnali che invece passano** (controlli positivi
dell'autore: *RTH Confluence*, T=5,83, n=538; *London Signal B*, T=5,15,
n=289, PF 2,42):

> _«both of them use regime classification and hold positions for 60-75
> minutes instead of 5-30 minutes... The two strategy types that avoid this
> ceiling share one feature: they hold positions for 12-15 bars rather than
> 1-6.»_ [VERIFICATO, §6.2 e §6.3]

👉 **Questa è la specifica di progetto per qualunque motore Nasdaq nuovo:
(a) tenere la posizione più a lungo, (b) condizionare a un REGIME.** Ed è
esattamente la forma del nostro miglior risultato di sempre — `ABTG_EMA200`
Dow, R29, **30 celle su 30 a PASS**, dove il filtro **È** il motore.

**3. Il modo in cui muoiono, che è il nostro stesso:**

> _«This pattern — one strong year masking flat or negative other years —
> turned out to be the most common failure mode across the whole study.»_
> [VERIFICATO, §4.1: ORB long 2022 −1,42 · 2023 +2,43 · **2024 +7,04**]

### 📌 TRE NOTE OPERATIVE — da consegnare, non da applicare

🔴 **Non tocco R97 né nessun file del round: sono osservazioni, la firma è di
Claudio.**

1. **Per R97 (ORB a stop largo su NASUSD):** il paper dice che l'unica
   variante ORB che si avvicina è **quella a orizzonte lungo** (bar+15, cioè
   ~75 minuti) — coerente con l'idea di stop largo — **ma che regge solo in un
   anno su tre**. Se R97 esce verde, **la prima cosa da guardare è la
   stabilità ANNO PER ANNO**, non il PF aggregato.
2. **Per R97, secondo punto:** l'ingresso **sul pullback** al livello di
   rottura è la variante **peggiore** delle cinque testate (80,7% di stop-out,
   win rate 19,3%). Il nostro R42 diceva _"l'unica cosa che ha sempre pagato è
   il RETEST"_: **queste due frasi sono in conflitto aperto.** Non lo risolvo
   io — lo segnalo perché è misurato da due parti diverse e va deciso a mente
   fredda, non dentro un round.
3. **Per la famiglia PostNews:** il paper dichiara il drift post-news
   **permanentemente respinto** dal bar+6 in poi (T 0,14-0,69 su 993 eventi) e
   aggiunge che la prossimità alle news **non migliora** nemmeno i due segnali
   validi. È un'evidenza esterna scomoda: le nostre due sedie PostNews
   (EURUSD, EURJPY) sono ancora **🟡 da verificare** in `FLOTTA_ATTIVA.md`.

---

# 🎌 PARTE B — IL BUCO N.2: JPY / NIKKEI

_Contesto: `BREAKOUT_EA_JPY_v3` è **scartata** (paniere 7 cross 2022-24:
−20.853 €, PF 0,67-0,95 su tutte, DD 30-48%; torneo R82: **0 vincitori su 7**).
`ABTG_LiquiditySweep` su EURJPY è **già in R95**: sweep+reclaim è **occupato**,
non è un buco. E il 21/08 è già stato dichiarato che su questa inefficienza il
web gratuito offre **quasi solo breakout da inseguire**._

## 🔴 PRIMA LA RISPOSTA ONESTA

> **Su JPY/Nikkei NON ho trovato un solo EA gratuito col sorgente che porti un
> meccanismo nuovo.** Il catalogo completo del Code Base (1.595 titoli) sul
> filtro `jpy|yen|nikkei|asian|tokyo|overnight|carry|night|correlat`
> restituisce **15 titoli**, e sono: 8 involucri `Exp_*` di indicatori,
> 2 scalper notturni **martingala** (§6.4), 1 EA di correlazione **rotto**
> (§6.3), 1 utility di swap, 1 demo che non fa trading, e **il Gap
> Continuation Nikkei che è già una nostra sedia** (774101, dal 16/08).
>
> **Zero candidati con codice.** Quello che porto sono **due ipotesi di
> meccanismo**, entrambe con una fonte letta, entrambe da costruire da zero.

---

## 🥇 B1 — INTRADAY MOMENTUM SULLA CAMPANELLA DI TOKYO

**È lo stesso motore di A1, su un'altra campanella.** Non è una furbizia: è
**l'unico strumento del nostro paniere JPY che ha un'apertura e una chiusura
vere**, cioè l'unica condizione che il paper di Gao et al. pone.

### ⏰ Gli orari, e li abbiamo già misurati noi

| | ora server BCM | da dove viene |
|---|---|---|
| sessione cash di Tokyo | **01:00 → 07:30** | `FLOTTA_ATTIVA.md`, sedia `ABTG_GapContinuation` (774101): _"sessione 01:00-07:30 ora server (cash di Tokyo)"_ [VERIFICATO nel repo] |
| **finestra del segnale** | **01:00 → 01:30** | derivata |
| **ingresso** | **07:00** | derivata |
| **uscita** | **07:30** | derivata |

### 📚 LA FONTE SPECIFICA SUL NIKKEI — **[INCERTO], E LO DICHIARO**

Esiste un paper del 2026 che è **esattamente** su questo:

> *"How the prior day's S&P 500 returns influence the intraday returns of
> Nikkei 225 futures"* — ScienceDirect `S3050700626000204`, febbraio 2026.
> https://www.sciencedirect.com/science/article/pii/S3050700626000204

🔴 **NON L'HO LETTO. ScienceDirect è EGRESS_BLOCKED dal proxy** — provato due
volte, anche via ricerca del PDF: non esiste una copia aperta raggiungibile.
Quello che so viene **solo dallo snippet del motore di ricerca**, e quindi
**non è un fatto, è un indizio**: quando il rendimento del giorno prima
dell'S&P 500 è più alto, si osservano rendimenti **più bassi nei primi 30
minuti** della sessione giapponese e **più alti nei 30 minuti prima della
chiusura**. Se fosse confermato, sarebbe un **ribaltamento** all'apertura e un
**momentum** alla chiusura, condizionati sul mercato americano.

👉 **Cosa serve prima di trasformarlo in un round:** il testo del paper. Se
Claudio ha un accesso istituzionale, è **una richiesta sola** e vale un round.
Senza quel testo, B1 resta la trasposizione di A1 su Tokyo — difendibile,
perché la condizione del paper (campanella vera) è soddisfatta, **ma senza
prova specifica sul Nikkei**.

### 🏛️ La riga prop, e il caveat di scorrelazione

- ✅ 30 minuti di esposizione, zero overnight, **~250 op/anno**.
- ✅ Fascia **07:00-07:30 server**: scoperta.
- 🔴 **ATTENZIONE ALLA CORRELAZIONE COL 774101.** La sedia
  `ABTG_GapContinuation` opera **nella stessa sessione, sullo stesso
  simbolo**. Orari diversi (apertura contro chiusura), ma entrambe
  condizionate sulla direzione del mattino di Tokyo: **è precisamente il caso
  che la regola §7-bis.3 vieta di accendere a rischio pieno senza misura.**
  Se B1 diventa un round, la **correlazione fra i due segnali va misurata
  prima del deploy**, non dopo.

**PUNTEGGIO: 7/10 → 🟡 IN CODA** (perde 2 punti su A1: la fonte specifica non
l'ho potuta leggere, e c'è un rischio di sovrapposizione con una sedia viva).

---

## 🥈 B2 — IL FADE DELL'ESPANSIONE ASIATICA

**Il reperto è dentro il paper A2, ed è il numero più forte di tutto lo
studio — nella direzione sbagliata per chi insegue.**

```
FONTE      arXiv 2605.04004v2, §4.2, tabella 4 [VERIFICATO, PDF letto]
COSA HA MISURATO  barre della sessione asiatica (20:00-02:00 ET) il cui RANGE
                  supera 1,5x / 2,0x / 2,5x il range medio delle ultime 20 barre.
                  Ipotesi testata: CONTINUAZIONE nella direzione dell'espansione.
RISULTATO  soglia 1,5x, orizzonte 1 barra: T = -10,96  ·  win rate 35,5%
           soglia 2,0x, orizzonte 1 barra: T =  -7,42  ·  win rate 36,0%
```

### 🧭 TESI IN UNA RIGA

> **"Il burst di volatilità asiatico si consuma DENTRO la barra: chi entra
> alla chiusura di quella barra non compra il movimento, compra
> l'esaurimento."**

L'autore lo scrive esattamente così:

> _«The expansion burst is real, but it is fully consumed within the expansion
> bar itself... What you end up capturing is the post-exhaustion reversal.»_
> [VERIFICATO, §4.2]

### 🔍 PERCHÉ NON È UN CADUTO NOSTRO RIVERNICIATO — e dove invece si avvicina

| caduto | perché è diverso | onestà |
|---|---|---|
| **R42 — fade degli estremi del range** | R42 fadeva il **tocco di un LIVELLO** (l'estremo di un box di 15'/35'). Qui il grilletto non è un livello: è **l'AMPIEZZA di una barra** rispetto alle 20 precedenti. Trigger diverso, sessione diversa | 🟡 **è la famiglia adiacente, e lo dichiaro.** Se Claudio legge "fade" e pensa R42, ha ragione a diffidare: il carico della prova sta su chi propone |
| **R82 / BREAKOUT JPY** | è l'esatto opposto: quello **inseguiva** l'espansione, questo la **fade**. Il paper misura che inseguirla è statisticamente **sbagliato**, non solo improduttivo | 🟢 differenza netta |
| **`Night Flat Trade` (Code Base 20815)** | quello entra al quarto superiore/inferiore di un range di 3 barre — di nuovo un **livello**. Già scartato il 21/08 | 🟢 differenza netta |
| **R95 sweep+reclaim** | lì serve **bucare un livello e rientrare**. Qui non c'è nessun livello da bucare | 🟢 differenza netta |

### 🔴 IL MOTIVO PER CUI IL PAPER LO BOCCIA — ed è il motivo per cui potrebbe vivere da noi

Il segnale è **direzionalmente giusto e statisticamente enorme** (T −10,96),
ma il contenuto lordo è **0,20-0,80 punti** contro **2,0 punti di attrito** su
MNQ: _«This is a pure friction ceiling result.»_

👉 **La domanda del round è quindi UNA SOLA, e non è "funziona?":**

> **"Esiste uno strumento del paniere JPY dove la stessa espansione asiatica
> vale abbastanza, in rapporto allo SPREAD, da lasciare qualcosa in tasca?"**

Il Nikkei (`225JPY`) e i cross JPY hanno spread e ampiezze **completamente
diversi** da un micro-future su Nasdaq. Il segno del segnale è già stato
misurato da qualcun altro su 947 giornate: **noi dobbiamo misurare solo
l'economia.**

### 🏛️ La riga prop

- 🟡 **Frequenza sconosciuta.** Il paper non dichiara quante barre superano la
  soglia in Asia. Con 1,5x potrebbero essere **molte al giorno** → rischio di
  concentrazione giornaliera, cioè proprio ciò che il muro del 5% punisce.
  **Un tetto di operazioni/giorno va nel disegno fin dall'inizio**, non
  aggiunto dopo (sarebbe un filtro appiccicato: 0 successi su 5).
- 🟢 Fascia oraria **notturna europea**: lì abbiamo solo `MaxMinNotte` (box
  23:00) e il Gap Nikkei. Poca compagnia.

**PUNTEGGIO: 6/10 → 🟡 IN CODA, dietro ad A1 e B1.** Perde punti perché il
campione originale è su **un altro strumento**, la frequenza è ignota, e la
famiglia "fade" è adiacente a un morto nostro.

---

# 🛡️ PARTE C — I FRENI DEL GUARDIAN (priorità 3)

_Riferimento: `report/DOSSIER_EA_NASDAQ_ESTERNI_2026-08-21.md` §7, proposte
P1-P7. Cerco **codice aperto e leggibile** che le implementi già bene._

## 🥇 C1 — `Equity Guard — Daily Loss Limit Guardian with Panic Panel`

```
NOME       Equity Guard - Daily Loss Limit Guardian with Panic Panel (v1.20)
FONTE      https://www.mql5.com/en/code/73870          [VERIFICATO: HTTP 200]
AUTORE     KairosLab  ·  DATA 2026.06.29  ·  UserDownloads: 464
SORGENTE   EquityGuardPanel.mq5 — 1.082 righe, 15 input veri + 5 gruppi
LICENZA    non dichiarata nel file (solo `#property copyright "KairosLab"`);
           scheda Code Base = sorgente aperto. [INCERTO] — uso interno di ricerca
BANDIERE ROSSE   ✅ NESSUNA: zero `#import`, zero `WebRequest`, zero DLL.
           L'unico `ACCOUNT_LOGIN` (riga 908) serve a nominare le
           GlobalVariable per conto, non è un controllo di licenza. [VERIFICATO]
NON È UN EA DI TRADING: non apre posizioni. È un guardiano.
```

### ✅ COSA IMPLEMENTA — e coincide con quattro delle nostre P

| nostra proposta | cosa fa questo codice | riga |
|---|---|---|
| **P3 — flat serale / chiusura forzata** | `EnforceFlat()`: finché è in lock **RICHIAMA la chiusura** ogni secondo finché posizioni e ordini non sono zero; log limitato a uno ogni 30s per non allagare | 375-393 |
| **protezione riavvio VPS** | `SaveState()`/`LoadState()` su **GlobalVariable per conto**: base del giorno, ora della base e stato di lock **sopravvivono al riavvio del terminale** | 152-171 |
| **reset giornaliero in ORA SERVER** | `LastReset()`/`NextReset()` su `TimeTradeServer()`, ora **e minuto** configurabili; alla nuova giornata **rilascia il lock da solo** | 128-147, 197-201 |
| **soglia di ALLARME prima del muro** | `InpTriggerPct = 80%` **del limite giornaliero**: scatta *prima* di toccare il muro. È il concetto della nostra pausa 4,0 contro emergenza 4,9 | 48, 351-368 |

### 🧠 LE TRE FINEZZE CHE VALE LA PENA RUBARE (e sono difetti che abbiamo già pagato altrove)

1. 🥇 **Guardia sull'ora del server non ancora valida:**
   `if((long)now < 1577836800) return;` — **non cattura la base del giorno
   finché il terminale non ha un'ora vera.** È esattamente la classe di bug
   che, dopo un riavvio del VPS, ti fa registrare un "inizio giornata"
   sbagliato e ti spegne il conto per niente. [riga ~176]
2. **Isteresi sul riarmo:** dopo un lock, il trigger si riarma **solo** quando
   la perdita scende sotto il **90% della soglia** (`g_rearmWait`) → niente
   lock che sbatte avanti e indietro sul bordo. [righe 353-362]
3. **`OnTimer(1)` — controlla ogni secondo, non a ogni tick.** Se il simbolo
   del grafico è fermo (weekend, festivo, strumento chiuso) un guardiano
   `OnTick` **non guarda niente**. Il nostro Guardian vive su un grafico solo:
   **questa è una domanda da fargli subito.** [righe 959, 984-989]

### 🧭 IN OTTICA PROP

> Non è un motore, non entra nell'imbuto e non fa numeri: è **materiale di
> costruzione**. La proposta è **leggerlo e prendere le quattro parti sopra**
> per il nostro `ABTG_Guardian` (P1/P2/P3 del dossier del 21/08), citando
> KairosLab in testa al file come da regola di casa. **Non si attacca a un
> grafico del forward**: farebbe `CloseAll` su **tutti i magic**, comprese le
> sedie vive.

**VERDETTO: 🟢 DA LEGGERE E SACCHEGGIARE — fuori imbuto, è un attrezzo.**

---

## 🥈 C2 — `Server Clock and Daily Reset Hour`

```
NOME       Server Clock and Daily Reset Hour
FONTE      https://www.mql5.com/en/code/76288          [VERIFICATO: HTTP 200]
AUTORE     sabari.kalathur (Sabarinathan R) · DATA 2026.08.18 · UserDownloads: 24
SORGENTE   ResetHourClock.mq5 — 487 righe, 14 input (8 sono cosmetici)
COSA FA    "Sends no orders. Reads no account data. Display only."
           Prendi la regola come la scrive la prop ("5:00 pm New York"),
           lui la converte in ORA SERVER, tiene il conto alla rovescia
           e AVVISA PRIMA che il cambio dell'ora legale sposti la risposta.
```

### 🎯 PERCHÉ CI RIGUARDA, e non è un vezzo

Il `report/PIANO_PROP.md` riga B3 ha una questione **ancora aperta e
dichiarata [INCERTO]**: _"resta [INCERTO] SOLO il comportamento
invernale/DST del server"_. E il repo ha già pagato caro il tema: tre valori
diversi per l'apertura di Londra in tre documenti (caccia del 19/08), l'ora
dei log ≠ l'ora del grafico (`CLAUDE.md`), il conflitto col corso su BCM
(IT−1 contro GMT).

👉 Questo attrezzo **risponde proprio a quella domanda**, in lettura, sul
terminale vero, con l'avviso **prima** del cambio di stagione. Costo: zero.

**VERDETTO: 🟢 UTILITY CONSIGLIATA** — da tenere su un grafico di servizio,
non nell'imbuto.

---

## 🥉 C3 — `Breakout Strategy with Prop Firm Helper Functions` — **vale come LEZIONE, non come codice**

```
FONTE   https://www.mql5.com/en/code/49713   AUTORE QuanDuong  DATA 2024.05.11
POPOLARITÀ  UserDownloads: 3.910 (il più scaricato dei nove letti oggi)
SORGENTE    PropFirmHelper.mq5 — 373 righe
MOTORE      Donchian/Turtle: rottura del massimo/minimo a 20 periodi con
            BuyStop/SellStop, uscita sul canale opposto. Rischio in % di EQUITY.
```

🟡 **Il motore è pulito ma è un doppione**: è trend-following su rottura di
canale, cioè la famiglia di `SupertrendReversal`/`EasyTrend` che già occupa
molte sedie. **Non riempie nessun buco** → non lo propongo.

🔴 **Ma le sue due funzioni "prop" sono un manuale di cosa NON fare, e le
segnalo perché noi stiamo scrivendo le nostre:**

1. **`isDailyLimit()` ricostruisce il saldo di inizio giornata sommando i deal
   chiusi di oggi** e fermandosi al primo deal di ieri. Tre difetti in venti
   righe: (a) usa il **giorno di calendario**, non l'**ora di reset** della
   prop; (b) i deal con `profit == 0` li salta **senza fermarsi**, quindi il
   `break` può non arrivare mai; (c) **depositi e prelievi entrano nel
   conteggio come profitto**.
   👉 L'approccio di C1 (**cattura la base all'ora di reset e la persisti**) è
   **strutturalmente più sano**. Se il nostro Guardian ricostruisce la base
   dallo storico invece di fotografarla, **eredita tutti e tre i difetti**.
2. 🔴 **`CalculateLotSize()` finisce con
   `return MathMax(lots, SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN));`** —
   quindi anche quando la funzione ha appena **deciso `lots = 0`** per margine
   insufficiente, **restituisce il lotto minimo e apre lo stesso**. Il tetto
   di rischio viene violato **in silenzio**, e nel backtest non si vede.
   👉 Vale la pena cercare la stessa forma nei nostri sizer.

**VERDETTO: 🔴 SCARTO come candidato · 🟢 TENUTO come referto di difetti.**

---

# 🗑️ PARTE D — GLI SCARTI, con il motivo che li prova

## D1 — 🚨 `003 - Weekly Day Reversal` — **ERA GIÀ MORTO, E DUE VOLTE**

```
FONTE https://www.mql5.com/en/code/74137   AUTORE dj_ermoloff (Sergei Ermolov)
DATA 2026.06.19 · UserDownloads: 435 · 318 righe · 12 input veri
```

Sul Code Base è **il candidato dall'aria migliore di tutta la giornata**:
codice pulitissimo, rischio in %, SL = k×ATR(D1) **vero e mandato al broker**,
TP a multiplo di R, **una posizione, un trade a settimana**, chiusura forzata
a orario. Il motore: **si opera CONTRO il segno della candela di un giorno
scelto della settimana.**

### 🔴 E infatti l'avevamo già comprato. Due volte.

| prova | dove |
|---|---|
| Il **fratello `001 - Turnaround Tuesday`** (Code Base **73674**) è stato promosso **9/10** dalla caccia D e **10/10** dalla caccia F del 16/08 | `caccia_strategie/CACCIA_2026-08-16_D_LATERALE.md`, `..._F_SHORT.md` |
| Ne è nato `ABTG_TurnaroundTuesday.mq5` (918 righe, magic 774201) e il file prova | `report/BILANCIO_16-08.md`, `prove/ABTG_TurnaroundTuesday.txt` |
| **R63: 0 celle positive su 24 fuori campione, su 11.928 operazioni. ⚰️ FAMIGLIA CHIUSA.** | `risultati_archivio/REFERTO_ROUND63_64_NOTTE_16-08.md` |
| **E questo specifico `003` era GIÀ stato scartato per iscritto**, con la motivazione: *"è il motivo per cui promuovo il 001 e SCARTO il suo fratello 003 (`/en/code/74137`), che li mette fra gli input e lascia scegliere all'ottimizzatore SE la tesi è ribaltamento o continuazione"* | `prove/ABTG_TurnaroundTuesday.txt` |

**Prova che è lo stesso oggetto, dal sorgente:** il file scaricato da `74137`
ha in testa `001-Turnaround-Tuesday.mq5` e commenta gli ordini
`"Revers_Tuesday"`. È lo **stesso codice** con giorno e direzione **promossi a
input** — cioè, con la tesi messa fra le manopole dell'ottimizzatore.

> ⚠️ **Il file prova lascia formalmente aperta UNA porta**: _"L'unica
> riapertura ammessa è SU INDICE, con la stessa griglia e i criteri riscritti
> prima"_ (R63 ha misurato su GBPUSD H1). **Io non la apro e non la propongo**:
> aprirla dopo un rosso è pesca, e la decisione è di Claudio, non di una
> caccia. Lo scrivo solo perché non venga riscoperto fra un mese come novità.

## D2 — `HybridMicrostructure EA` — 🔴 **CHIAMA UN SERVIZIO ESTERNO PER DECIDERE**

```
FONTE https://www.mql5.com/en/code/76331  AUTORE RitzFalih  DATA 2026.08.19  DL: 242
```

Il **meccanismo** è ottimo sulla carta e vicino a ciò che cerchiamo: VWAP a
tick + bande di deviazione, **sweep di velocità** oltre la banda, e ingresso
**solo dopo lo SNAPBACK** (il prezzo deve rientrare di N pip dall'estremo).
Ma il codice lo squalifica su tre punti, tutti dal sorgente:

1. 🔴 **`WebRequest("POST", InpAIEndpoint, ...)`** in
   `Include/HybridMicrostructure/AIBridge.mqh:774` — e il commento dice che
   l'URL va messo in whitelist. **Il gate finale della decisione è una
   chiamata di rete**: `// AI gate verdict is the final authority`. Fuori
   perimetro per il §4, senza discussioni.
2. 🔴 **130 input** (30 nel `.mq5` + 68 + 18 + 14 nei tre `.mqh`) contro il
   tetto di casa di ~15.
3. 🔴 **VWAP costruito su un buffer di TICK** → non esiste screening OHLC, e
   il risultato dipende dal flusso di tick del broker.

🟢 **Ma la MECCANICA me la tengo scritta**, perché è la forma giusta per il
buco Nasdaq: *estremo + rientro obbligatorio prima di entrare*, con lo stop
oltre l'estremo. È la stessa grammatica di `ABTG_LiquiditySweep` (R95),
applicata a una banda invece che a uno swing.

## D3 — `AAPL cfd - ORB strategy` — 🔴 il motore già seppellito

`https://www.mql5.com/en/code/76333` · andrewmagar · 2026.08.19 · **49
download** · 773 righe · **25 input**. È un ORB di sessione con buffer, BE,
trailing e cutoff. **È letteralmente la famiglia chiusa** (A4 su NASUSD, O2,
O3, O4, R45 0/48, capitolo M5 chiuso il 26.07.26) — **e il paper A2 la
falsifica di nuovo su 947 giorni**. In più: `Risk_Per_Trade_Pct = 5.0` **sul
capitale iniziale**, cioè rischio fisso travestito da percentuale.
👉 Unica cosa da tenere: ha `MAX_TRADES_PER_DAY` e `MAX_BARS_HOLD`, che sono
la nostra P2.

## D4 — `2-Pair Correlation EA` — 🔴 **senza stop, e rotto**

`https://www.mql5.com/en/code/52043` · sasan31 · 2024.09.10 · 2.637 download.
Sembrava la pista "correlazione" per USDJPY/Nikkei. Dal sorgente:

- `trade.Buy(dynamicLotSize, "BTCUSD", 0, Slippage, 0, ...)` → nella firma di
  `CTrade::Buy(volume, symbol, price, sl, tp, comment)` il quarto argomento è
  lo **stop loss**, e ci finisce dentro `Slippage = 3`. **Lo stop è un livello
  di prezzo "3".** Cioè: **nessuno stop**.
- `iATR(symbol, PERIOD_M5, ATRPeriod)` usato come **valore**: in MQL5 `iATR`
  restituisce un **handle**. Il "filtro di volatilità" confronta un numero di
  handle con una soglia. **Non misura niente.**
- Le coppie sono **cablate a BTCUSD/ETHUSD**, il "segnale" è la **differenza
  grezza dei due prezzi** (non uno spread normalizzato, non uno z-score), e si
  chiude tutto quando il **profitto totale supera 0,30** nella valuta del
  conto: è la chiusura a paniere in profitto, cioè **mediazione**.

## D5 — `20 Pips Opposite Last N Hour Trend` e `10pipsOnceADayOppositeLastNHourTrend` — 🔴 **MARTINGALA, dichiarata negli input**

`https://www.mql5.com/en/code/19500` (barabashkakvn, 2018.01.22, 1.330 DL) e
`https://www.mql5.com/en/code/17474` (2017.03.02, 2.093 DL).

Il **meccanismo** era in tema (fade notturno: *a un'ora fissa apri CONTRO il
movimento delle ultime N ore*), ma il sizing è l'archetipo:

```
input uchar InpFirstMultiplicator  = 2;   // Lot multiplier, if one position is unprofitable
input uchar InpSecondMultiplicator = 4;   // ... if two positions are unprofitable
input uchar InpThirdMultiplicator  = 8;
input uchar InpFourthMultiplicator = 16;
input uchar InpFifthMultiplicator  = 32;
```

Con `InpTakeProfit = 20` pip contro `STOPLOSS = 50` (R:R **0,4**) e fino a
**9 posizioni**. È il §4 al completo. **Scarto immediato.**

## D6 — `EA High and Low last 24 hours` — ⚪ non è un EA

`https://www.mql5.com/en/code/17528`: `OnTick()` è **vuoto**. Disegna una
linea quando premi "H" o "L". È una demo didattica.

## D7 — 📄 `WM/Reuters 4pm Fix` — meccanismo vero, **ma non direzionale**

`https://arxiv.org/abs/1501.07778` (Michelberger & Witte, 2015) — **PDF letto
per intero.** Sembrava la pista giusta per JPY: un'ora fissa, un flusso
d'ordini enorme compresso in un minuto. E infatti l'effetto è misurato:
movimenti estremi di **8,7 bps su USDJPY** e **13,3 bps su EURJPY** nel minuto
del fix (tabella 4).

🔴 **Ma non si può tradare, e il paper stesso lo dice:**
- il numero di **massimi estremi ≈ numero di minimi estremi** → **non c'è
  direzione**: solo volatilità;
- gli autori hanno **cercato** una correlazione con la direzione dell'S&P 500
  e **non l'hanno trovata** (_"the data does not show any significant
  correlations"_);
- l'effetto è confinato al **minuto** prima/dopo le 16:00 Londra — sotto la
  nostra risoluzione operativa;
- il campione è **2010-2014**, cioè **prima della riforma del 2015** che ha
  allargato la finestra del fix da 1 a 5 minuti **proprio per spegnere questa
  dinamica**.

## D8 — `Intra-Day Seasonality in Foreign Exchange Market Transactions`

`https://arxiv.org/abs/1103.5664` (Cotter & Dowd, 2011): stagionalità
intragiornaliera su **DEM/USD** con dati del **Dealing 2000-2**. Il marco
tedesco non esiste dal 2002. **Cultura, non candidato.**

---

# 🕳️ PARTE E — COSA NON HO POTUTO VEDERE

Dichiarato, non taciuto. Un buco dichiarato vale più di una lista che sembra
completa.

| non visto | conseguenza concreta |
|---|---|
| 🔴 **Il paper sul Nikkei** (ScienceDirect bloccato) | **B1 resta a 7/10 invece che a 9.** È la singola cosa che, se sbloccata, cambierebbe la classifica di questo dossier |
| 🔴 **Forex Factory (403, terza caccia di fila)** | Non so **come sono invecchiati** i sistemi sui cross JPY. È l'unico posto dove si legge cosa succede quando una strategia smette di funzionare, e ci manca da tre cacce |
| 🔴 **SSRN (403, terza caccia di fila)** | La versione pubblicata di Gao et al. l'ho letta **solo** nel PDF ospitato su `c.mql5.com`: contenuto verificato, **ma non è la fonte primaria** |
| 🔴 **Tutto il Pine di TradingView** | Zero script valutabili. Non è "non ho trovato niente": è **non ho potuto guardare** |
| 🔴 **Ricerca GitHub (403 dal proxy)** | Ho potuto leggere solo repo di cui conoscevo già l'URL. Il canale è di fatto chiuso |
| 🟡 **Quantpedia** (peggiorata dal 21/08) | La sezione gratuita oggi non si elenca più: 5 slug su 6 in 466 |
| 🟡 **QuantConnect** | Guscio JS: nessun articolo leggibile |
| 🟡 **Le due fonti sul Turnaround Tuesday** (priceactionlab, redfame — EGRESS_BLOCKED) | Irrilevante ai fini pratici: **R63 ha già chiuso la famiglia coi NOSTRI numeri**, che valgono più di entrambe |

---

# 🏁 PARTE F — LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE

> ## 🎯 **"Sul NASUSD, il profitto LORDO medio per operazione del momentum intraday — segno dei primi 30 minuti, ingresso alle 20:30 server, uscita alle 21:00 — vale almeno TRE VOLTE lo spread medio misurato in quella mezz'ora?"**

**Non "quanto guadagna". Non "qual è la cella migliore".** Questa e solo
questa, e va risposta **prima** di aprire qualunque griglia.

Il motivo sta nel paper A2, ed è il numero più importante che porto oggi:
**quattordici famiglie di segnali intraday sul Nasdaq sono morte non perché
non misuravano niente, ma perché misuravano 0,07-1,50 punti contro 2,0 punti
di costo.** Se il nostro lordo non passa quel cancello, la griglia non serve:
serve solo a trovare la cella verde per caso, che è quella che brucia la
challenge.

E se lo passa, allora il round vale — perché quello che c'è dietro è
**l'unico motore trovato oggi con una campanella vera, mezz'ora di
esposizione, zero overnight, ~250 operazioni l'anno e una fascia oraria dove
non abbiamo nessuno.**

---

## 📋 RIEPILOGO PER LA CODA

| # | oggetto | buco | punteggio | verdetto |
|---|---|---|---|---|
| **A1** | **Market Intraday Momentum su NASUSD** | 🎯 Nasdaq apertura + fascia 20:30 | **9/10** | 🟢 **PROVA SUBITO** (EA da scrivere, ~250 righe) |
| **A2** | Falsificazione MNQ (947 giorni, 14 famiglie) | — | — | 📕 **METRO** — 3 note per R97/PostNews, nessuna azione autonoma |
| **B1** | Intraday Momentum sulla campanella di Tokyo | 🎯 Nikkei/JPY | 7/10 | 🟡 **IN CODA** — sale a 9 se qualcuno legge il paper 2026 |
| **B2** | Fade dell'espansione asiatica | 🎯 JPY/Asia | 6/10 | 🟡 **IN CODA** — la domanda è economica, non statistica |
| **C1** | `EquityGuardPanel` (Code Base 73870) | freni Guardian | — | 🟢 **DA SACCHEGGIARE** (fuori imbuto) |
| **C2** | `ResetHourClock` (Code Base 76288) | fuso / B3 [INCERTO] | — | 🟢 **UTILITY** |
| **C3** | `PropFirmHelper` (Code Base 49713) | — | — | 🔴 scarto come EA · 📕 referto di difetti |
| D1-D8 | otto scarti | — | — | 🔴 motivi in §D, uno per uno |

---

_Redatto il 22/08/2026. Nessun EA nostro toccato, nessun parametro in forward
modificato, nessun file di R97 o del Guardian aperto in scrittura. Nessun
numero di autore è stato usato per assegnare un punteggio._
