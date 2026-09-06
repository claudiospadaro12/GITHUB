# 🎯 CACCIA NOTTURNA — IL BUCO DOPPIO: **LATO SHORT + FREQUENZA ≥ 1/GIORNO** — 06/09/2026 (sera)

**Mandato (Claudio, chiusura di serata):** _"dobbiamo trovare ancora nuovi
motori, non bastano questi"_. Perimetro stretto, dato dall'agente lanciatore:
meccanismi che stiano su **ENTRAMBI** i buchi misurati —
**(1) il LATO SHORT** (`R52_CENSIMENTO_LATI`: la flotta viva è quasi tutta
long) e **(2) la FREQUENZA** (pavimento di casa **1,00 op/giorno**; il miglior
candidato del pomeriggio ne fa **0,14**).

🔒 **Nessun EA scritto o toccato. Nessun `.set`. Nessuna sedia viva toccata.
Nessun parametro di forward toccato. Nessun backtest lanciato. Nessun
candidato promosso al forward.**

---

## ⚡ LA RIGA CHE CONTA — e non è quella che speravo di scrivere

> **Su 9 fonti passate al controllo positivo (5 vive, 4 murate), ho censito
> 400 EA del Code Base MQL5 (10 pagine di elenco), di cui 337 mai citati in
> repo, e ne ho portati 8 fino al SORGENTE LETTO.**
> 🔴 **PROMOSSI A "PROVA SUBITO": ZERO. In coda: ZERO.**
> **Nessun file prova nuovo, perché non c'è niente da provare.**
>
> Questa è una risposta, non una resa — e i tre motivi ricorrenti sono al §5.
> Portare cinque candidati mediocri per non tornare a mani vuote sarebbe
> costato a Claudio più di questa riga.

Ma la nottata **non è vuota**, e le due cose che porto valgono più di un
candidato mediocre:

> 🔓 **1. MQL5 CODE BASE È SBLOCCATO, E IL SORGENTE SI SCARICA.**
> `PROMEMORIA_SBLOCCO_FONTI.md` dà `mql5.com` come **403 al CONNECT** dal
> 16/08, e da allora le cacce hanno lavorato sul **mirror GitHub offline**.
> **Oggi non è più vero, e l'ho verificato fino in fondo**: elenchi 200,
> schede 200 **con autore e data**, e soprattutto il **download diretto del
> `.mq5`** (`/en/code/download/<ID>/<Nome>.mq5` → **HTTP 200, 18.183 byte,
> 466 righe di sorgente vero**). 👉 **Da stanotte il setaccio §4 è
> applicabile al Code Base senza intermediari.**
>
> 📉 **2. E IL CODE BASE RECENTE È ESAURITO — ADESSO CON UN NUMERO GRANDE.**
> Il `REGISTRO_TEST` lo sospettava su **11 id** (_"tutti pannelli/calcolatori/
> logger/demo Renko. Zero motori M5"_). **Io l'ho misurato su 400**: il flusso
> recente della sezione `experts` è **pannelli, calcolatori, copiatori,
> logger, martingala/griglia e incroci di indicatori**. 👉 **Raccomandazione
> operativa: smettere di spendere cacce sugli arrivi nuovi del Code Base.**
> Non è più una fonte di motori; è diventata una fonte di **attrezzi** (§6).

---

## 0. 📡 CONTROLLO POSITIVO — fonte per fonte, fatto PRIMA di cercare

Regola di casa: si verifica il canale su un bersaglio di cui **so già** la
risposta, e una fonte che fallisce **si dichiara**, non si sostituisce con la
memoria.

| fonte | bersaglio noto | esito MISURATO stanotte | verdetto |
|---|---|---|---|
| 🆕 **MQL5 Code Base** `/en/code/mt5/experts` | l'elenco deve dare **titoli veri** | **HTTP 200**, 40 titoli/pagina, fra cui `Chaos Theory Lyapunov Exponent EA` e `Nikkei 225 Gap Continuation EA` (**entrambi già agli atti in casa** = controllo superato) | 🟢 **PASSA** |
| 🆕 **MQL5 scheda singola** `/en/code/76153` | deve dare **autore + data** | 200; meta: _"…by **'Stridz_z'** … in the MQL5 Code Base, **2026.08.15**"_ | 🟢 **PASSA** |
| 🥇 **MQL5 SORGENTE** `/en/code/download/76153/SessionORB_EA_g4y.mq5` | deve dare **il `.mq5`** | **200, 18.183 byte, 466 righe**, intestazione `//| SessionORB_EA.mq5` | 🟢🔓 **PASSA — È LA NOVITÀ DELLA NOTTE** |
| **arXiv API** `export.arxiv.org` | `id_list=2010.01727` = Knuteson, _"Strikingly Suspicious Overnight and Intraday Returns"_ | **200**, titolo corretto | 🟢 **PASSA** |
| **arXiv ricerca** `search_query=cat:q-fin.TR` | deve elencare i preprint recenti | **200** ⚠️ **solo in HTTPS**: la stessa query in `http://` torna **vuota senza errore** — trappola da segnare | 🟢 **PASSA** |
| **TradingView** `/scripts/` e scheda script | pagina raggiungibile | **200** (1,54 MB sulla scheda `dwjybp5i`) | 🟠 **VIVA MA CIECA** — vedi sotto |
| 🔴 **TradingView — SORGENTE Pine** | la scheda deve contenere `strategy(` | **0 occorrenze** di `strategy(` / `indicator(` / `source_code` su 1,54 MB | 🔴 **NULLA per il setaccio**: il Pine è reso in JS. **Stessa identica limitazione dichiarata il 06/09 mattina** |
| 🔴 **GitHub ricerca UI** `/search?q=…` | elenco repo | **HTTP 403** | 🔴 **NULLA** |
| 🔴 **GitHub API** `api.github.com/search/repositories` | elenco repo | **403**: _"sessions are bound to their configured repositories. Use repository-scoped endpoints"_ (⚠️ `rate_limit` risponde **200 con 15.000 crediti**: **non è una quota, è uno scoping**) | 🔴 **NULLA** — e la diagnosi corregge il "429" dei giorni scorsi |
| 🔴 **SSRN** `papers.ssrn.com/…712168` | abstract noto | **403** | 🔴 **NULLA** (muro agli atti dal 29/08) |
| 🔴 **Forex Factory** `/forum/71-trading-systems` | elenco thread | **403** | 🔴 **NULLA** (stesso muro) |
| 🟠 **Quantpedia** `/strategies/` | elenco strategie | **308** (redirect, non seguito cross-host) | 🟠 **NON BATTUTA** |
| 🟠 **QuantConnect** `/` | home | **200**, ma la fonte è **CHIUSA in casa dal 02/09** (_"83 slug, 0 candidati"_) | ⏹️ **non riaperta per mandato** |

**Vive: 5. Murate: 4. Non battute: 2.**
🔴 **E due limiti di canale che condizionano tutto il resto, dichiarati qui:**
la **ricerca interna di MQL5 è in JS** (`?s=`, `?sort=` **vengono ignorati**:
provati e misurati) → **si può leggere solo l'elenco in ordine di data**;
e **il Pine di TradingView non è leggibile** → **da TradingView non può uscire
nessun promosso**, perché senza sorgente il §4 non è applicabile.

---

## 1. 📕 COSA HO LETTO IN CASA PRIMA DI USCIRE

`CLAUDE.md` (per intero: Emendamento della Finestra, Criterio di Uscita delle
Sedie, Regola dei Due Lati, Regola della Seconda Caccia) ·
`backtest_pipeline/REGISTRO_TEST.md` (**il cimitero**, 1.827 righe) ·
`caccia_strategie/CACCIA_NASDAQ_MECCANISMI_2026-09-06.md` (**§4 scarti e §6
lezione, per intero**) · `CACCIA_INDICI_DAX_DOW_MECCANISMI_2026-09-06.md` ·
`CACCIA_ORO_ARGENTO_MECCANISMI_2026-09-06.md` ·
`CACCIA_FREQUENZA5_TASSONOMIA_2026-09-03.md` (**la tassonomia M1-M31**) ·
`prove/R52_CENSIMENTO_LATI.md` (**il censimento dei lati, tabella madre**) ·
`prove/GAPCASH_NAS_PASSO0.txt` (modello di file prova) ·
`caccia_strategie/PROMEMORIA_SBLOCCO_FONTI.md` ·
`caccia_strategie/biblioteca/sorgenti/` (**95 sorgenti già raccolti**) ·
`SETACCIO_MANUALE.md` (indice) · `report/SWEEP_MECCANISMI_2026-08-23.md` (§4.1).

### 1.1 ⛔ Cosa NON ho riaperto, e perché

| famiglia | dove sta la lapide | perché non la riapro |
|---|---|---|
| **ORB / straddle d'apertura** | R97 **0/4** a tick (PF OOS 0,84-0,91) + _"~210 celle"_ | porta chiusa, tre volte |
| **Breakout in ogni forma** | R7-R13, R42, R45, R12 — _"~96 celle"_ | porta chiusa |
| **Fade degli estremi del range** | R42 **0/24 IS e 0/24 OOS**, R43 2/64 ribaltate | _"capitolo CHIUSO DEFINITIVAMENTE"_ |
| **Incroci di medie (EMA cross)** | V8, GoldenCross, SuperWave | ablazione 03/09: il filtro RSI toglie 9-13% → è un EMA(5/20) |
| **Reversione overnight univariata** | 05/09: DAX 1.513 coppie e S&P 1.262, **monotonia fallita** | misurata e sepolta |
| 🆕 **M31 salto statistico (Lee-Mykland)** | **DUE lapidi**: M15 _"CHIUSO"_ e **M5 16 celle su 16 sotto il cancello** | ⚠️ **era il mio candidato migliore sulla carta** — vedi §3 |
| 🆕 **M25 lead-lag direzionale** | **8 celle su 8 negative al netto**, e i 1.534 casi della sonda RELATIVO | frequenza sì, edge no |
| 🆕 **M23 numeri tondi** | **93.000+ segnali**, delta appaiato **da −1,50 a +0,90** | misurata: no |
| 🆕 **Liquidity sweep** | **TRE giri**: BreakinBox a tick 31/08, R95 0/30, e la lapide 05/09 sul range della notizia | _"cambiare il LIVELLO non cambia la geometria"_ |
| 🆕 **`002 - Inside Bar` (Code Base 73884)** | scartato **16/08**, **23/08** e **29/08** | vedi §4 — l'ho riletto lo stesso, e spiego perché |

---

## 2. 🥇 IL RISULTATO PRINCIPALE — **IL CODE BASE È APERTO** (e come si usa)

Questa è la parte che sopravvive alla nottata, e serve a **tutte** le cacce
future. La procedura, verificata passo per passo stanotte:

| passo | URL | cosa dà |
|---|---|---|
| 1. elenco | `https://www.mql5.com/en/code/mt5/experts/page<N>` | **40 titoli + id** per pagina, **in ordine di data** |
| 2. scheda | `https://www.mql5.com/en/code/<ID>` | nel `<meta name="description">` ci sono **descrizione + AUTORE + DATA** |
| 3. 🥇 sorgente | il link `href="/en/code/download/<ID>/<Nome>.mq5"` **dentro la scheda** | **il `.mq5` in chiaro** |

⚠️ **Due trappole misurate, da scrivere adesso per non ripagarle:**
1. **La ricerca e l'ordinamento non funzionano** (`?s=`, `?sort=rating`,
   `?sort=downloads` restituiscono **l'elenco per data, identico**: verificato
   confrontando i primi 6 titoli). 👉 **Si può solo scorrere per data.**
2. 🔴 **Molti `.mq5` del Code Base sono in UTF-16.** Un `grep '^input'` ci
   trova **ZERO input** e fa sembrare pulito un sorgente che pulito non è:
   sul **Currency Strength Expert v3** il primo passaggio ha dato "0 input,
   nessuna bandiera rossa", e la verità — dopo la decodifica — è **42 input e
   una MARTINGALA ATTIVA PER DEFAULT** (§4). **Si decodifica prima di
   setacciare.** È esattamente il tipo di errore che fa passare un martingala.

---

## 3. 🎯 IL MANDATO, E PERCHÉ NON L'HO POTUTO SODDISFARE — con i numeri di casa

Il mandato chiede **short + ≥1 op/giorno**. Cercando, ho trovato che **il
progetto ha già misurato perché quella coppia è difficile**, e la misura non è
mia: è nel `REGISTRO_TEST`.

### 3.1 🔴 La frequenza NON si compra scendendo di timeframe — è misurato tre volte

| misura di casa | numero |
|---|---|
| caccia M1 (29/08) | _"la frequenza NON la compreremo scendendo"_ |
| **M31 su M5** | **16 celle su 16 sotto il cancello**, due mercati |
| **M31 su M15** | l'edge **c'è** ed è **monotono** su 3 strumenti e 6 soglie… ma **la cella con l'edge non ha campione, la cella col campione non ha edge** |
| **il costo su M15** | 1R = **20,85 punti DAX / 10,8 pip EURUSD**, e lo spread vale **0,078-0,095 R per operazione** — cioè **più dell'intero cancello H8 (0,075R)** |
| gradiente R108/R111 | **H1 > M30 > M15** |

➡️ **Aritmetica che chiude la strada:** un motore M15 a ≥1 op/giorno deve
consegnare **≥ 0,157R LORDI** per pagare 0,075R netti. **M31 aveva un edge
vero, monotono, contro controllo casuale appaiato — e non ci arrivava.**

🎯 **Quindi il candidato che il mandato chiede — short, ≥1/giorno, motore
nuovo — è precisamente la casella che il progetto ha già svuotato due volte
questa settimana.** Non è pigrizia: è che i due meccanismi migliori mai
portati in caccia (M31 e M25) sono morti **entrambi sul costo, non sull'idea**.

### 3.2 💡 La domanda che il REGISTRO lascia aperta — e che secondo me è la strada

Cito testualmente il `REGISTRO_TEST` (non è una mia invenzione):

> _"esiste UN meccanismo che produca 0,16-0,20R LORDI su M5? E se no, **perché
> cerchiamo la portata SCENDENDO di timeframe invece che AGGIUNGENDO SIMBOLI a
> M15-H1?**"_

👉 **E qui i due buchi si toccano.** `R52_CENSIMENTO_LATI` dice che in casa ci
sono **due motori simmetrici PER COSTRUZIONE**, senza nessun input di lato —
cioè con la direzione **costitutiva**, che è la forma che in casa vale **30
celle su 30** (`ROBUSTEZZA.md` §5B):

| cella | come decide il lato | lato mancante |
|---|---|---|
| `ABTG_BreakingBand` (GBPUSD/EURUSD/AUDUSD H1) | `isLong = (gBulgeDir>0)` / `(gBulgeDir<0)` — **nessun input di lato** | **VINCOLATO** (non esiste) |
| `ABTG_GapFill` (GBPUSD/EURUSD/AUDUSD H1 + Dow/Nikkei) | `isLong = (gGap<0.0)` — **nessun input di lato** | **VINCOLATO** |

🔴 **MA QUESTO NON È UN CANDIDATO E NON LO PROPONGO COME TALE.** È
un'osservazione `[INFERITO]` da `R52`, ed è **fuori dal mio mandato** (io
porto materiale esterno; e "più simboli sullo stesso motore" **non è una
caccia**). **La decisione è di Claudio**, e va presa sapendo che quei motori
sono **vivi, non lapidi** — quindi non ricadrebbe sotto il divieto della
seconda caccia. La scrivo perché tacerla, avendo letto il censimento dei lati
stanotte, sarebbe stato disonesto.

---

## 4. 🛑 GLI SCARTI — uno per riga, col motivo. **Sorgente LETTO dove indicato**

### 4.1 Gli 8 sorgenti che ho scaricato e letto davvero

| # | candidato | fonte / autore / data | righe · input | verdetto e **la riga che lo prova** |
|---|---|---|---|---|
| S1 | **`Currency Strength Expert v3`** | Code Base [29362](https://www.mql5.com/en/code/29362) | 1.398 · **42** | 🔴 **SCARTO §4 — MARTINGALA ATTIVA PER DEFAULT.** `input bool EnableAveraging = true; // Enable Martingale` · `input double Multiplier = 1.3; // Lot Multiplier` · `PipStep`, `PSM = 2`, `StartPSMAfter = 2`, `TPPlus = 20 // TP Average in Pips`. ⚠️ **La descrizione non lo dice**: è la lezione del §2. Peccato vero — la **forza valutaria** era l'unica famiglia **simmetrica per costruzione** e **mai toccata in casa** (grep: 0 occorrenze come meccanismo) |
| S2 | **`MSNR v5.31Plus AEU EA`** | Code Base [73680](https://www.mql5.com/en/code/73680) | 4.642 · **252** | 🔴 **SCARTO §5A/§5E — 252 input.** Il tetto di casa è ~15. **Non è un motore: è un ottimizzatore che sceglie la strategia.** Costo di validazione ≫ valore atteso |
| S3 | **`ExpPinBar`** | Code Base [63971](https://www.mql5.com/en/code/63971), **MetaQuotes Ltd.** | 955 · **23** | 🔴 **SCARTO doppio:** (a) **licenza MetaQuotes** (`#property copyright "Copyright 2025, MetaQuotes Ltd."`) — **già dichiarata SQUALIFICANTE il 29/08** per un derivato committato; (b) **menu**: `ENUM_TRAILING_TYPE` offre **9 tipi di trailing** selezionabili (SIMPLE/PSAR/AMA/DEMA/FRAMA/MA/TEMA/VIDYA/VALUE) → è l'ottimizzatore a scegliere la gestione |
| S4 | **`002 - Inside Bar`** | Code Base [73884](https://www.mql5.com/en/code/73884), dj_ermoloff, 2026.06.11 | 334 · **11 veri** | 🔴 **NON PROMOSSO — sarebbe la QUARTA riapertura.** Già scartato **16/08** (`F_SHORT`), **23/08** (`SWEEP_MECCANISMI` S1) e **29/08** (`SHORT_INDICI`): _"è un motore di BREAKOUT dalla inside bar, e il breakout è porta chiusa con ~96 celle"_. ⚠️ **E però va scritto, perché è l'unico del lotto che sul mandato ci stava:** direzione **COSTITUTIVA** (`doB = mainBullish; doS = !mainBullish`, **nessun input di lato**), **zero bandiere rosse**, SL reale al broker, `PERIOD_CURRENT` (nessuna riscrittura), pendente che scade. 🔴 **Confermo anche il difetto già trovato il 23/08 leggendo il codice mio: `balance` è letto UNA VOLTA in `OnInit()` → il "rischio %" è LOTTO FISSO TRAVESTITO.** La decisione di riaprirlo è **di Claudio, non di una caccia** |
| S5 | **`003 - Weekly Day Reversal`** | Code Base [74137](https://www.mql5.com/en/code/74137), dj_ermoloff | 318 · 17 | 🔴 **SCARTO PER FREQUENZA — è il buco n.2 in persona.** `input ENUM_DAY_OF_WEEK CHECK_DAY` = **un segnale a SETTIMANA** (~50/anno = **0,2/giorno**), cioè **un quinto del pavimento**. In più `input ENUM_DIRECTION Direction = reverse` **lascia all'ottimizzatore se la tesi è ribaltamento o continuazione** (già scartato il 22/08 con questa stessa motivazione) |
| S6 | **`OHLCMTF Scalper EA`** | Code Base [70796](https://www.mql5.com/en/code/70796) | 143 (`_MAIN`) · **0** | 🔴 **SCARTO §5E — non è autoconsistente**: il file principale non contiene nessun `input` né la logica; è un progetto **multi-file** di cui il Code Base serve solo il capo. Non compila da solo |
| S7 | **`Session Range Desk MT5`** | Code Base [76927](https://www.mql5.com/en/code/76927) | 1.445 | 🔴 **SCARTO — è un DESK, non un motore**: disegna/gestisce il range di sessione. Il §4 e l'imbuto non hanno niente su cui girare |
| S8 | **`Session Opening Range Breakout EA`** | Code Base [76153](https://www.mql5.com/en/code/76153), Stridz_z, 2026.08.15 | 466 · 22 | 🔴 **GIÀ SCARTATO il 23/08** (S3): _"doppione secco del nostro `ABTG_ORB`, senza il retest"_. **Usato stanotte come BERSAGLIO DEL CONTROLLO POSITIVO** sul download del sorgente — ed è servito a quello |

### 4.2 Scartati per **famiglia**, dal censimento dei 400 titoli

| blocco | quanti (stima) | motivo, in una riga |
|---|---:|---|
| **Pannelli, calcolatori, gestori di rischio, copiatori, logger, notificatori Telegram** | **~150** | 🔴 **non sono strategie**: non hanno un ingresso da setacciare né un backtest da far girare |
| **Martingala / griglia / recovery / hedge / locker dichiarati nel TITOLO** | ~25 | 🔴 §4 senza discussione (`Sideways Martingale`, `RSI Grid EA Pro`, `BGC Grid EA`, `XANDER Grid XAUUSD`, `Daily Zone Recovery`, `HedgeCover`, `VR Locker Lite`, `Reversing Martingale`, `MultiMartin`, `Basic Martingale v3`, `Breakout Martin Gale`…) |
| **Incroci di indicatori da manuale** (MA/EMA cross, RSI, MACD, Stocastico, DeMarker, WPR, CCI, SAR) | ~60 | 🔴 famiglia **già morta in casa** (EMA cross, RSI+EMA V8) e **nessuna tesi di mercato scrivibile in una riga** (§5C) |
| **Breakout in ogni salsa** (`Outbreak Trader`, `Periodic Range Breakout`, `Breakdown catcher`, `VR Breakdown level`, `Universal Breakout Study`, `Easy Range Breakout`, `Moving average breakout`) | ~15 | 🔴 **porta chiusa, ~96/210 celle** |
| **Barre consecutive / pattern di candela** (`BullBear candle row`, `Three Typical Candles`, `Simple_Three_Inside_Pattern`, `Heikin Ashi Engulfing`, `Candlestick Analysis EA R1`) | ~10 | 🔴 stessa famiglia del `3 Red / 3 Green` **già scartato il 06/09 mattina** (_"divulgativo"_); e su **Heikin Ashi** il segnale è costruito su candele **sintetiche e lisciate** = trappola di ridipintura |
| **ONNX / ML / reti neurali** (`Market Structure Onnx`, `Larry Williams XGBoost Onnx`, `Neurotest`, `MarketPredictor`, `ONNX Trader`) | ~8 | 🔴 **lapide Mesfin già a registro**: su MNQ nessuna configurazione batte il tasso base 51,8% su 944 giorni, e **l'autore stesso conclude che 4 anni non bastano**. Noi sugli indici ne abbiamo **21 mesi** |
| **Demo Renko** (`GDS Renko` ×4) | 4 | 🔴 barre **sintetiche a soglia di prezzo**: il tempo sparisce, e con lui la frequenza per giorno. Fuori pipeline |
| **Arbitraggio triangolare** (`Triangular Arbitrage`, `Arbitrage Triangle EURGBP-EURUSD-GBPUSD`, `2-Pair Correlation`) | 3 | 🔴 richiede **3 simboli simultanei** e vive su spread **istituzionali**: al nostro costo (1,0-1,5 pip **per gamba**, ×3 gambe) è morto per aritmetica prima di partire |
| **Esempi didattici del libro MQL5** (Parti 1-7), blocchi di codice, rilevatori di nuova barra | ~25 | 🔴 **frammenti**, non EA |

---

## 5. 📌 I TRE MOTIVI RICORRENTI — perché la nottata finisce a zero

1. 🥇 **IL FLUSSO RECENTE DEL CODE BASE NON CONTIENE PIÙ MOTORI.** Su **400
   titoli** censiti, i candidati che arrivano al sorgente sono **8**, e sono
   **8 scarti**. La sezione si è spostata da "robot" ad **attrezzi e
   pannelli** — probabilmente perché i motori veri finiscono nel **Market**
   (a pagamento, fuori perimetro permanente).
2. 🔴 **LE DUE FONTI CHE AVREBBERO I MOTORI NON SONO SETACCIABILI.**
   TradingView **risponde ma non serve il Pine**; GitHub **non ha ricerca**
   (403 UI, API scoped). Senza sorgente non c'è §4, e senza §4 **non promuovo**
   — è la regola, e non l'ammorbidisco perché la nottata è andata male.
3. ⚖️ **IL MANDATO CHIEDE LA CASELLA PIÙ COSTOSA CHE ESISTA.** "Short **e**
   ≥1 op/giorno" significa quasi sempre **timeframe basso**, e lì il costo
   (0,078-0,095 R/op su M15) **è più grande del cancello H8 (0,075R)**. I due
   meccanismi migliori mai portati in caccia — **M31 e M25** — sono morti
   **esattamente lì**, con l'edge intatto.

---

## 6. 🔧 QUELLO CHE PORTO LO STESSO — due attrezzi, e pagano DEBITI GIÀ APERTI

Non sono motori e **non riempiono nessuno dei due buchi**: lo dichiaro subito
per non gonfiare la resa. Ma il `REGISTRO_TEST` li aveva **già chiesti
entrambi** il 05/09, potendo leggere **solo la pagina** (_"sorgente NON letto"_).
🥇 **Stanotte il sorgente l'ho letto, ed entrambi passano il §4 puliti.**

| attrezzo | Code Base | righe · input | 🔴 bandiere rosse | il debito che paga |
|---|---|---|---|---|
| **`Round Trip Cost Reconciler MT5`** | [76117](https://www.mql5.com/en/code/76117), `usamah41`, 2026.08.13 | **235 · 9** | **nessuna** (nessun `#import`, nessun `WebRequest`, **non apre ordini**) | 🎯 **H12 — lo spread FOREX di BCM è `[NON MISURATO]` da sette cacce.** Esporta CSV per *deal* e per *posizione* con `commission`, `swap`, `fee`, `total_costs`, `net_result` |
| **`Position Peak Logger`** | [76934](https://www.mql5.com/en/code/76934), `petrkostal`, 2026.09.04 | **280 · 8** | **nessuna** (**non apre ordini**) | 🎯 **MFE/MAE in R** — _"il dato che manca al censimento dei contratti"_, e il numero che in `GAPCASH_NAS_PASSO0` (P0-4) **fissa lo stop al posto dell'ottimizzatore** |

⚠️ **Perché questo conta più di quanto sembri.** Il §5.3 dice che i motori a
frequenza muoiono **sul costo**. Il costo forex **non l'abbiamo mai misurato**:
ogni riga "netta" su EURUSD di ogni caccia poggia su una **convenzione di
1,0 pip**. 👉 **Finché H12 è aperta, un candidato forex ad alta frequenza non
è giudicabile nemmeno se lo trovassimo** — e il mandato di stanotte diceva
proprio che il forex vale di più *perché è giudicabile*. **Lo è sul campione
(tick dal 1999), non ancora sul costo.**

🛑 **Non li ho scaricati nel repo, non li ho compilati, non li ho lanciati.**
Sono due link verificati e un setaccio passato: **la decisione è di Claudio.**

---

## 7. 🕳️ COSA NON HO POTUTO VEDERE — dichiarato, non riempito

1. 🔴 **Il Pine di TradingView**: 1,54 MB scaricati, **zero** `strategy(`.
   **Nessuno script TV è stato setacciato stanotte**, e quindi nessuno è
   stato né promosso né scartato nel merito.
2. 🔴 **GitHub**: **403 sulla UI** e **403 sull'API di ricerca** (scoping, non
   quota — `rate_limit` dà 15.000 crediti). ⚠️ **Correzione a un dato dei
   giorni scorsi: non è un 429 da riprovare fra un'ora, è un limite
   strutturale di questa sessione.** Il fronte GitHub **non è stato battuto**.
3. 🔴 **SSRN e Forex Factory**: 403, muri già agli atti.
4. 🟠 **Quantpedia**: 308, redirect non seguito. **Non battuta.**
5. 🟠 **Code Base oltre le 10 pagine**: mi sono fermato a **400 EA**
   (fino a id ~11637, cioè il fondo storico). Le pagine più profonde esistono
   ma la resa era già **8 sorgenti / 400 titoli**.
6. 🔴 **La ricerca interna di MQL5 non è utilizzabile** → **non posso cercare
   "short", "mean reversion" o "fade" nel Code Base**: posso solo scorrere per
   data. **È il limite che ha condizionato di più questa caccia**, e va messo
   in `PROMEMORIA_SBLOCCO_FONTI.md`.
7. 🔴 **Nessun numero d'autore è stato verificato**, e infatti **nessun numero
   d'autore compare in questo dossier** (regola C8).

---

## 8. ❓ LA DOMANDA A CUI IL PROSSIMO PASSO DEVE RISPONDERE

Non propongo un file prova, perché **non ho un candidato**. Propongo la
domanda che stanotte è emersa **due volte per strade diverse** — dal
`REGISTRO_TEST` e dal censimento dei lati:

> 🎯 **La portata (≥1 op/giorno) e il lato short si comprano AGGIUNGENDO
> SIMBOLI ai due motori che in casa sono già SIMMETRICI PER COSTRUZIONE
> (`ABTG_BreakingBand`, `ABTG_GapFill` — nessun input di lato, direzione
> costitutiva), invece che cercando un motore nuovo su un timeframe dove il
> costo è più grande del cancello?**

E la domanda che la precede, perché senza risposta **la prima non è
misurabile**:

> 💸 **Quanto costa davvero un giro completo sul forex di BCM?** (H12, aperta
> da sette cacce, e oggi c'è l'attrezzo per chiuderla: Code Base 76117.)

🛑 **Nessuna delle due è una decisione mia.** Le lascio a Claudio con i numeri
sotto, che è il mio mestiere.

---

## 9. ⚖️ RIEPILOGO DEI NUMERI DELLA CACCIA

| | |
|---|---:|
| fonti col controllo positivo tentato | **12 bersagli su 9 fonti** |
| fonti vive | **5** |
| fonti murate (403 / egress / scoping) | **4** |
| fonti non battute (308 / chiuse per mandato) | **2** |
| EA del Code Base censiti (10 pagine di elenco) | **400** |
| di cui **mai citati in repo** | **337** |
| **sorgenti `.mq5` scaricati e letti** | **8** |
| **PROVA SUBITO** | 🔴 **0** |
| **IN CODA** | 🔴 **0** |
| **SCARTI motivati** | **8 nel sorgente + 9 blocchi di famiglia** |
| **attrezzi promossi alla decisione di Claudio** | **2** (76117, 76934) |
| lapidi verificate prima di proporre | **10 famiglie** |
| round risparmiati | **2** (M31 come "meccanismo nuovo" · `002 Inside Bar` alla quarta riapertura) |
| 🔓 **fonti SBLOCCATE per le cacce future** | **1 — MQL5 Code Base, col sorgente** |

---

## 10. 🗂️ LE PAGINE APERTE DAVVERO (per chi verrà dopo)

| URL | esito |
|---|---|
| `mql5.com/en/code/mt5/experts/page1…page10` | 200 · **400 titoli con id** |
| `mql5.com/en/code/76153` · `/76331` · `/68951` · `/56773` · `/58135` · `/57020` · `/60413` · `/70796` · `/62742` · `/73884` · `/68704` | 200 · schede con **autore e data** |
| 🥇 `mql5.com/en/code/download/76153/SessionORB_EA_g4y.mq5` | **200, 18.183 byte** — la prova che il sorgente si scarica |
| `…/download/` di **29362, 63971, 73680, 73884, 74137, 70796, 76927, 76934, 76117** | 200 · **8 sorgenti letti** (+1 usato per il controllo) |
| `mql5.com/en/code/mt5/experts?sort=rating` · `?sort=downloads` · `?s=reversion` | 200 ma **ordinamento IGNORATO** (primi 6 titoli identici) |
| `mql5.com/en/search?keyword=…` | 200 · **0 risultati nell'HTML** (ricerca in JS) |
| `export.arxiv.org/api/query?id_list=2010.01727` | 200 · controllo positivo |
| `export.arxiv.org/api/query?search_query=cat:q-fin.TR` (+4 ricerche mirate) | 200 · **30 preprint recenti letti a titolo**: AMM, cripto, RL, microstruttura teorica → **nessuno traducibile sui nostri simboli** |
| `tradingview.com/scripts/` · `…/script/dwjybp5i-…` | 200 · **ma 0 occorrenze di `strategy(`** |
| `github.com/search?q=…` | **403** |
| `api.github.com/rate_limit` | 200 (15.000 crediti) |
| `api.github.com/search/repositories?q=…` | **403 — scoping, non quota** |
| `papers.ssrn.com/…712168` · `forexfactory.com/forum/71-trading-systems` | **403** |
| `quantpedia.com/strategies/` | **308** |

---

_Caccia eseguita il 06/09/2026 in serata. **Zero EA scritti, zero `.set`,
zero sedie toccate, zero parametri di forward toccati, zero backtest lanciati,
zero candidati promossi.** Ogni riga di questo dossier viene da una pagina
aperta davvero o da un file del repo letto davvero._
