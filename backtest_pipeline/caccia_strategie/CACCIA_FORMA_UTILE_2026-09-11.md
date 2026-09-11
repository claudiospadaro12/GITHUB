# 🎯 CACCIA "FORMA UTILE" — 11/09/2026

> **Mandato:** non "strategie interessanti", ma **motori con la FORMA che i
> nostri cancelli possono promuovere entro il 1° ottobre** (20 giorni).
> Quattro requisiti simultanei: `stop >= 40 x spread` all-in · `>= 1,00 op/giorno
> per FAMIGLIA` · **150 operazioni** raggiungibili nella finestra a tick che
> abbiamo · **DD < 7%** a rischio 1%.

> 🛑 **Questo dossier non tocca niente.** Nessun `.mq5`, nessun `.set`, nessun
> parametro in forward, nessun terminale, nessuna riga verso il VPS. Sola
> lettura + questo file.

---

# 0. 🥇 LA RIGA CHE VA LETTA PER PRIMA

> **Su 1.079 titoli censiti sul Code Base — di cui **984 non compaiono in NESSUN
> dossier o referto del repo** (misurato, non stimato: 95 su 1.079 risultano già
> citati per id) — 16 sorgenti scaricati e letti riga per riga, 2 abstract arXiv
> letti per intero e 8 fonti sottoposte a controllo positivo: i PROMOSSI sono
> ZERO.**
>
> 🔴 **E non è pigrizia: è che il cancello del costo è 13 volte più stretto
> dello standard pubblico.** Lo dimostra un numero trovato stanotte dentro un
> sorgente, non un'opinione: `SMC Liquidity Sweep Scalper` (Code Base 77094,
> pubblicato il 07/09/2026) è **il primo EA del catalogo che implementa il
> NOSTRO stesso cancello** — rifiuta i setup in cui lo stop è troppo piccolo
> rispetto allo spread. La sua soglia è `InpMinSLToSpreadRatio = 3.0`.
> **La nostra di lavoro è 40.** Un autore pubblico che si è posto esattamente
> il nostro problema lo ha risolto a **1/13 della nostra severità**.
>
> 👉 Questo spiega, con un numero, perché sei cacce di fila tornano a mani
> vuote dal materiale gratuito: **non stiamo cercando meglio, stiamo cercando
> una cosa che quasi nessuno costruisce.**

**E la seconda riga, che è la buona notizia onesta:** il censimento di stanotte
ha coperto **le pagine 13-27** del Code Base, cioè la fascia 2016-2020 che
nessun dossier precedente aveva mai aperto. **Adesso il Code Base è chiuso con
una misura, non con un'impressione.**

⚠️ **Precisazione onesta sui 984:** "mai citato per id" **non** vuol dire "mai
visto". Le cacce precedenti hanno sfogliato ~400 titoli e hanno citato solo
quelli che valeva la pena nominare. Il numero difendibile è: **984 id non hanno
una riga di motivo scritta da nessuna parte** — e da oggi 13 di loro ce l'hanno.

---

# 1. 🎯 CONTROLLO POSITIVO — 8 fonti, misurato oggi (11/09/2026)

| fonte | bersaglio | esito misurato | verdetto |
|---|---|---|---|
| **MQL5 Code Base** | `/en/code/mt5/experts` + pagine 2-27 | **200** · 85.215 byte · id+titoli estratti (77220 `ZetaBurst Scalper`, 77206 `AurumNeuro`, 77060 `SessionReopenEA`) | 🟢 **PASSA** |
| **MQL5 sorgente** | `/en/code/download/<ID>/<Nome>.mq5` | **200** su 16 id diversi, 16 file `.mq5` salvati | 🟢 **PASSA** |
| **arXiv API** | `export.arxiv.org/api/query?search_query=cat:q-fin.TR` | **200** · 9.699 byte · entry con titolo/data/id | 🟢 **PASSA** — ⚠️ **era 403 al CONNECT il 16/08**: il canale si è aperto |
| **arXiv HTML** | `arxiv.org/list/q-fin.TR/recent` | **200** · 8 `list-title` con titoli veri | 🟢 **PASSA** |
| **QuantConnect** | `/learning/articles/investment-strategy-library` | **200** · 45.841 byte | 🟢 raggiungibile |
| **TradingView** | `/scripts/` | **200** · 732.472 byte · **0 occorrenze di `strategy(`** | 🔴 **NON SETACCIABILE** (il Pine non è nell'HTML) |
| **GitHub** | `/search?q=…&type=repositories` · `/topics/mql5` · `api/search/repositories` | **403** · **403** · *"sessions are bound to their configured repositories"* | 🔴 **SCOPERTA NULLA** (solo `raw.githubusercontent.com` risponde, ma serve il percorso esatto) |
| **earnforex.com** | `/metatrader-expert-advisors/` | **000** (connessione fallita) | 🔴 **NON RAGGIUNTA** |
| **Quantpedia** | `/strategies/` | **308** | 🔴 **NON RAGGIUNTA** |
| **SSRN** | `papers.ssrn.com/sol3/results.cfm` | **403** | 🔴 **NON RAGGIUNTA** |
| **Forex Factory** | `/forum/71-trading-systems` | **403** | 🔴 **NON RAGGIUNTA** |

🔴 **Quattro fonti su otto non sono state raggiunte, e si dichiara.** Non sono
state sostituite con la memoria.

⚠️ **`raw.githubusercontent.com` risponde 200.** Non è inutile: se qualcuno
(Claudio, o un altro agente) porta il **percorso esatto** di un repo, il
sorgente si legge. Quello che **non** si può fare da qui è **cercare** su
GitHub.

---

# 2. 📊 IL CENSIMENTO DEL CODE BASE — 1.079 titoli, 27 pagine

| famiglia (dal titolo) | n | % |
|---|---:|---:|
| motori generici / crossover di indicatori | 669 | 62,0% |
| **wrapper `Exp_*` su indicatore esterno** | 180 | 16,7% |
| attrezzi, pannelli, calcolatori, copier, logger | 109 | 10,1% |
| **griglia / martingala / recovery / hedge / basket** | 63 | 5,8% |
| esempi, blocchi di codice, sorgenti da libro | 22 | 2,0% |
| **scalper** (dichiarati nel titolo) | 15 | 1,4% |
| ML / AI / ONNX / neurale | 15 | 1,4% |
| cripto / arbitraggio / market making | 6 | 0,6% |
| **TOTALE** | **1.079** | |

📌 **La classificazione è dal TITOLO, quindi è una stima grossolana e va detto.**
Il numero che conta non è la percentuale: è che **i 599 titoli nuovi stanno
quasi tutti nella fascia 2016-2020**, che è fatta di **conversioni MT4 con SL
in pip fissi** e di **wrapper `Exp_*` su indicatori non allegati**. Nessuna di
quelle due forme può passare il §4 o il cancello del costo.

---

# 3. 🚫 LA TABELLA DI SCARTO — con IL NUMERO del cancello che uccide

**Costi di casa usati** (misurati, non stimati):
- **forex EURUSD all-in = 0,86 pip** (spread 0,3 + commissione ~0,5 — `report/NOTTE_2026-09-11.md`, conto **a commissione**, 4,0000 EUR/lotto, varianza zero su 84 posizioni)
- **XAUUSD = 0,2603 $** (spread 0,22 + commissione misurata 0,0403 — `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.452)
- **U30USD ora 14 = 2,00 punti indice** (idem, r.396)
- Pavimenti: **DURO `stop >= 13,3 x spread`** · **DI LAVORO `stop >= 40 x spread`**

| # | candidato | fonte | meccanismo | 🔴 IL NUMERO CHE LO UCCIDE |
|---|---|---|---|---|
| 1 | **`Periodic Range Breakout 2.0`** (Mokara, 2020.09.25, [/en/code/31198](https://www.mql5.com/en/code/31198), 522 righe, 19 input) | Code Base · **mai setacciato prima** | rottura di un range periodico | 🔴 **§4 IMMEDIATO — MARTINGALA ATTIVA PER DEFAULT.** r.36 `input MODE_LOTMANAGEMENT lotMode = Martingale;` r.38 `input double lotMultiplier = 2;`. Non si legge oltre |
| 2 | **`Daily BreakPoint`** (barabashkakvn, 2018.01.22, [/en/code/19498](https://www.mql5.com/en/code/19498), 461 righe, 13 input) | Code Base · **mai setacciato prima** | rottura della barra giornaliera | 🔴 **§4 — NESSUNO STOP LOSS PER DEFAULT.** r.22 `input ushort InpStopLoss = 0;` con `InpTakeProfit = 30`. Vince piccolo, perde illimitato |
| 3 | **`Gap DM`** (barabashkakvn, 2019.01.02, [/en/code/23223](https://www.mql5.com/en/code/23223), 605 righe, 8 input) | Code Base · **mai setacciato prima** | gap all'apertura della barra | 🔴 **§4 — NESSUNO STOP LOSS PER DEFAULT.** r.33 `input ushort InpStopLoss = 0;` |
| 4 | **`Daily range`** (barabashkakvn, 2019.02.07, [/en/code/23334](https://www.mql5.com/en/code/23334), 881 righe, 12 input) | Code Base · **mai setacciato prima** | livelli a max/min del range giornaliero ± offset | 🔴 **COSTO, e il conto non ha bisogno di stime.** r.408 `ExtStopLoss = m_daily_range * InpStopLoss` con `InpStopLoss = 0.03`. Perché lo stop arrivi a 40 x 0,86 pip = **34,4 pip**, serve un range giornaliero di **1.147 pip**. EURUSD non li ha mai fatti. 🔴 In più il sizing è `CMoneyFixedMargin` = **% del MARGINE, non del rischio** |
| 5 | **`EURUSD breakout`** (barabashkakvn, 2017.08.10, [/en/code/18704](https://www.mql5.com/en/code/18704), 427 righe, 8 input) | Code Base · **mai setacciato prima** | rottura all'avvio di due sessioni | 🔴 **COSTO: SL 12 pip fissi (r.66) / 0,86 = 14,0x.** Pavimento di lavoro 40x → **35% del richiesto**. Passa il DURO (13,3x) **per 0,7 decimi**: è esattamente la zona in cui R55 misura la fragilità doppia. + lotto fisso 1.0 |
| 6 | **`MostasHaR15 Pivot`** (barabashkakvn, 2018.08.23, [/en/code/21394](https://www.mql5.com/en/code/21394), 1.027 righe, 6 input) | Code Base · **mai setacciato prima** | ADX + 2 MA + OsMA su pivot | 🔴 **COSTO: SL 20 pip fissi (r.20) / 0,86 = 23,3x** → 58% del pavimento di lavoro. + lotto fisso 0.1 + 1.027 righe per 6 input |
| 7 | **`Tuyul GAP`** (zvickyhac, 2025.06.11, [/en/code/60347](https://www.mql5.com/en/code/60347), 328 righe, 13 input) | Code Base · ⚠️ **GIÀ setacciato il 28/08** (`CACCIA_INTRADAY_INDICI`): rileggendolo ho ritrovato gli stessi difetti **più** il conto del costo, che lì non c'era | gap del weekend | 🔴 **COSTO CATASTROFICO: `StopLoss = 60` PUNTI MT5 (r.16).** Su un indice (`Point = 0,01`) sono **0,6 punti indice** contro uno spread di **2,00** = **0,30x**. Su EURUSD 5 cifre sono **6 pip** = **7,0x**. Fuori di un ordine di grandezza su entrambi. + `LotSize = 0.1` fisso |
| 8 | **`Gaps`** (barabashkakvn, 2018.08.23, [/en/code/21617](https://www.mql5.com/en/code/21617), 392 righe, 8 input) | Code Base · **mai setacciato prima** (verificato escludendo questo stesso file) | gap su timeframe indicato | 🟡 **COSTO OK — SL 50 pip = 58,1x** ✅. 🔴 Muore altrove: **`InpTrailingStop = 5` pip = 5,8x il costo** — il trailing vive *dentro* il pedaggio, quindi chiude in perdita per costruzione. + lotto fisso 0.1 |
| 9 | **`BreakOut15`** (barabashkakvn, 2018.07.09, [/en/code/17057](https://www.mql5.com/en/code/17057), 686 righe, **20 input**) | Code Base · **mai setacciato prima** | incrocio 2 MA → si arretra di una distanza → si aspetta la rottura di quel livello | 🟡 **COSTO OK — SL 50 pip = 58,1x** ✅. 🔴 Muore su **§5.A: 20 input contro il tetto di ~15**, geometria in **pip fissi uguale su ogni simbolo**, e **nessuna tesi di mercato scrivibile in una riga** |
| 10 | **`Autotrader Momentum`** (barabashkakvn, 2018.10.25, [/en/code/22409](https://www.mql5.com/en/code/22409), 396 righe, 8 input) | Code Base · **mai setacciato prima** | TSMOM puro: `close[0] > close[15]` → compra (r.124) | 🟡 **IL MIGLIORE DEL LOTTO, e non basta.** COSTO OK (SL 50 pip = **58,1x**), 8 input, tesi vera (time-series momentum) con **appoggio accademico fresco** (arXiv 2607.19497). 🔴 **Muore su TRE cose:** (a) **R:R 1:1 fisso** (`SL 50 / TP 50`) — distrugge la skewness, che è la sola ragione per cui un trend follower esiste (stessa condanna di `TurtleTrader` il 16/08); (b) `InpCurrentBar = 0` → **legge la barra IN FORMAZIONE** (§4 repaint — mitigabile, è un input); (c) 🔴 **DOPPIONE §5.D**: è la stessa tesi di `ABTG_EMA200` (Dow, 30/30 PASS, PF OOS 1,52 su n=517). Un segnale di una riga che sappiamo già scrivere non è un'importazione: è rumore in coda |
| 11 | **`SMC Liquidity Sweep Scalper`** (RanaAli878, 2026.09.07, [/en/code/77094](https://www.mql5.com/en/code/77094), 593 righe, **27 input**) | Code Base · **mai setacciato prima** | sweep di uno swing high/low → order block → candela di conferma → ingresso con HTF trend filter | 🔴 **TRIPLA, e la prima è il numero del titolo di questo dossier.** (a) **`InpMinSLToSpreadRatio = 3.0`** (r.76): il suo cancello di costo è **1/13 del nostro**; il minimo strutturale è `0,5 x ATR` (r.75), che per arrivare a 34,4 pip vuole **ATR = 68,8 pip** — su EURUSD è un ATR **giornaliero**, non di M15/H1. (b) 🔴 **il filtro è stato AGGIUNTO DOPO backtest negativi**, e lo scrive l'autore in testa al file (r.40-50: *"after multi-pair/multi-timeframe backtests came back net negative, three fixes were made… A higher-timeframe trend filter was added"*) → è **esattamente** il pattern che in casa è **0 successi su 5** (§5.B). (c) **stessa inefficienza di CRT Turtle Soup, CHIUSA il 31/08 con PF 0,459 a tick** |
| 12 | **`EA AurumNeuro Vanguard`** (RitzFalih, 2026.09.10, [/en/code/77206](https://www.mql5.com/en/code/77206), 887 righe, **32 input**) | Code Base · **mai setacciato prima** | "Neural Risk Architecture" + "Unified Market Dynamics Engine" su XAUUSD | 🔴 **§5.A: 32 input = più del DOPPIO del tetto.** Con 32 manopole il backtest ha troppo da girare verso il passato. + è oro, dove abbiamo già **5 sedie** (§5.D) |
| 13 | **`SuperTrend TV EA`** (Nikita9995, 2026.09.06, [/en/code/77009](https://www.mql5.com/en/code/77009), 282 righe, 8 input) | Code Base · **mai setacciato prima** | SuperTrend via `iCustom` su barre chiuse | 🔴 **DOPPIONE §5.D** della famiglia `SupertrendReversal` (2 sedie vive: 225JPY H2 DD 0,88% · NASUSD H1 DD 0,86%). + **lotto fisso 0.10** (r.22) + dipende da un **`iCustom` esterno** |
| 14 | `Original Turtle Rules Trader` ([/en/code/16866](https://www.mql5.com/en/code/16866)) | Code Base | Donchian 20/55 + ATR | 🔴 **GIÀ UCCISO IL 16/08** (`CACCIA_2026-08-16_E_CROLLO.md` §5): `OnInit` restituisce `INIT_FAILED` su conto **HEDGING** (r.303-307) — **il nostro BCM è HEDGING**. Non parte nemmeno nel tester. Riportato solo perché non si ricontrolli una terza volta |
| 15 | `001 Turnaround Tuesday` · `002 Inside Bar` · `003 Weekly Day Reversal` · `Universal Breakout Study` · `Session ORB` · `Lazy Bot` · `Liquidity Sweep H4-M15` · `BreakRevertPro` · `Indiana Jones` · `MeanReversionTrendEA` · `TrendMomentumEA` · `Smart Trend Follower` · `Range Follower` · `ExpPinBar` · `HybridMicrostructure` · `Nikkei Gap` · `GoldLondonBreakout` · `Easy Range Breakout` | Code Base | varie | 🔴 **GIÀ SETACCIATI** in dossier precedenti (16/08 · 21/08 · 23/08 · 25/08 · 28/08 · 29/08 · 30/08 · 02/09 · 03/09 · 06/09). `002 Inside Bar` è alla **quarta** riapertura: non si riapre di nuovo per iniziativa di una caccia |
| 16 | **`arXiv 2607.19497`** *The Science and Practice of Trend-Following Systems* (21/07/2026) | arXiv · **letto per intero l'abstract** | teoria spettrale del trend following | 🟡 **NON È UN CANDIDATO, è CULTURA — e utile.** Non ha simboli, non ha codice, non è traducibile. **Ma contiene una cosa che ci serve davvero**: la forma chiusa dello **"span cost-optimal" sotto costi di transazione**. Con il pedaggio misurato stanotte (0,86 pip) quella formula dice **quale lookback minimo** ha senso su ogni nostro simbolo. 👉 **Ponteggio, e si dichiara come tale** |
| 17 | **`arXiv 2602.10785`** *walk-forward optimization con finestre parametrizzate* (11/02/2026) | arXiv · **letto per intero l'abstract** | ottimizzazione walk-forward su Bitcoin 1m-60m | 🔴 **NON TRADUCIBILE (§3.A):** Bitcoin, Binance Coin, Ethereum. **Nessuno dei nostri simboli.** Ed è metodologia, non un motore |
| 18 | **`SessionReopenEA`** ([/en/code/77060](https://www.mql5.com/en/code/77060)) | Code Base | riapertura CME dell'oro | 🟡 **NON È UNA NUOVA SCOPERTA: è GIÀ NELL'IMBUTO.** Dossier `CACCIA_APERTURE_ORO_2026-09-08.md` §2 + bozza `backtest_pipeline/prove/SESSIONREOPEN_ORO_BOZZA.txt`. Riletto il sorgente stanotte per conferma: **pulito, nessuna bandiera §4, SL vero al broker**. 🔴 Resta bloccato su **due misure mancanti, non su un numero brutto**: (1) `@DAQUANDO` — la profondità a tick di XAUUSD **non è mai stata misurata**; (2) l'ora della pausa **in ora server BCM** — e non sappiamo nemmeno se BCM *abbia* una pausa sull'oro. **Verdetto: NON ANCORA MISURATO.** Vedi §5 |

---

# 4. 🟢 I PROMOSSI — **ZERO**, e perché è la risposta giusta

**Nessun candidato viene promosso da questa caccia.** Il mandato lo prevede
esplicitamente, e la ragione per cui è la risposta giusta e non una resa è che
i motivi di scarto **non sono generici**: sono **tre, ricorrenti, e ciascuno
con un numero**.

### 🔴 Motivo 1 — LO STOP IN PIP FISSI (7 candidati su 13 letti)

`InpStopLoss` in pip, uguale su ogni simbolo e ogni ora. I valori trovati:
**0 · 0 · 12 · 20 · 50 · 50 · 50 pip** e `0,03 x range` e `60 punti`.
Contro il nostro costo all-in di **0,86 pip** questo dà rapporti di
**0,30x · 2,4x · 7,0x · 14,0x · 23,3x · 58,1x**. 🔴 **Sotto il pavimento di
lavoro (40x) ce ne sono CINQUE su otto misurabili.**
E i tre che passano il costo muoiono sul resto (R:R 1:1, trailing dentro il
pedaggio, 20 input, doppione).

### 🔴 Motivo 2 — IL FILTRO APPICCICATO DOPO (e stavolta è CONFESSATO)

`SMC Liquidity Sweep Scalper` scrive in testa al sorgente che il filtro di
trend HTF è stato aggiunto **dopo** che i backtest multi-coppia erano tornati
**netti negativi**. In casa quel pattern è **0 successi su 5** (R20 ADX, R12,
R26, R45, R54), contro il **miglior risultato del progetto** quando il filtro
**È** il motore (`ABTG_EMA200` Dow, R29, 30 celle su 30).
👉 È la prima volta che troviamo un autore che **documenta** di averlo fatto.
Vale come conferma esterna del nostro §5.B, e va tenuta.

### 🔴 Motivo 3 — IL DOPPIONE (§5.D)

I tre motori **sani** del lotto (`Autotrader Momentum`, `SuperTrend TV EA`,
`SMC sweep`) fanno cose che **abbiamo già**, e meglio: trend su close =
`ABTG_EMA200` (PF OOS 1,52, n=517); SuperTrend = due sedie vive con DD 0,86-0,88%;
sweep = `CRT Turtle Soup`, **chiuso il 31/08 con PF 0,459 a tick**.
🔴 **Il DD della prop è UNO: aggiungere un EA correlato non diversifica, somma.**

---

# 5. 🔁 "SE POTREBBE PASSARE, SI INSISTE" — l'unico filo vivo, e non è mio

Il mandato di casa (09/09) dice che quando un candidato è fermo per un numero
**mancante** e non per un numero **brutto**, non si archivia: si trova la via
più corta al numero.

**In questa caccia c'è un solo oggetto in quello stato, ed è già nostro:**
`SessionReopenEA` / `SESSIONREOPEN_ORO_BOZZA.txt`. È fermo su **due misure**,
entrambe economiche:

| misura mancante | come si prende | perché blocca |
|---|---|---|
| profondità a **tick di XAUUSD** sul nostro broker | `scarica_storico.ps1` / sonda di casa | senza `@DAQUANDO` il round misura una finestra che non esiste (precedente: indici, driver 2024.01.01 contro dati dal 26/09/2024) |
| **esiste la pausa, e a che ora server?** | conteggio dei tick per ora server su XAUUSD | un'ora sbagliata **non dà errore**: misura un'altra strategia |

🔴 **E la falsificazione è a costo quasi zero:** se il conteggio dei tick NON
mostra un'ora in cui crolla e riparte, **il candidato è morto in un pomeriggio
invece che in un round.**

⚠️ **Non riapro io quella corsa e non scrivo un file prova nuovo**: la bozza
esiste già, con i criteri congelati, ed è più completa di quanto potrei fare
adesso. **Duplicarla sarebbe rumore.**

---

# 6. 🧪 IL CONTRO-ESEMPIO — ho provato a uccidere la mia stessa conclusione

La conclusione di questo dossier è *"il materiale gratuito non produce motori
per la nostra forma"*. Un modo comodo di sbagliare è **confermarla** cercando
dove so già che non c'è.

| tentativo di rottura | esito |
|---|---|
| **"Hai guardato solo il recente, dove gli altri hanno già pescato"** | 🟢 Rotto: ho sceso **15 pagine mai aperte** (13-27); **984 dei 1.079 id censiti non erano mai stati citati** nel repo. Il risultato non cambia, e adesso è misurato |
| **"Hai scartato per il titolo, non per il codice"** | 🟢 Rotto: **16 sorgenti scaricati e letti**, e 9 dei 13 scarti citano **il numero di riga** che li uccide |
| **"I sorgenti in UTF-16 ti hanno fatto vedere 0 input dove ce n'erano 42"** (trappola misurata il 06/09) | 🟢 Coperto: il downloader **decodifica UTF-16 prima di setacciare** (BOM + euristica sui byte nulli). `AurumNeuro` ha restituito **32 input**, non 0 |
| **"Hai deciso che il 40x uccide senza stimare i range"** | 🟢 Rotto senza stime: per `Daily range` il conto è **invertito** — non "quanto vale il range", ma *"quale range servirebbe"*: **1.147 pip al giorno**. Nessuna ipotesi dentro |
| 🔴 **"Hai scritto 'mai setacciato' senza controllare"** | 🟡 **Vero una volta su tredici, e l'ho corretto**: `Tuyul GAP` (60347) era già stato letto il 28/08. Trovato ricontrollando **escludendo questo stesso file** dalla ricerca — perché al primo giro il grep trovava il dossier che stavo scrivendo |
| 🔴 **"Forse la fonte era giù, e la chiami vuota"** | 🟡 **Parzialmente vero, e lo dichiaro**: SSRN, Forex Factory, Quantpedia, GitHub-ricerca e earnforex **non sono state raggiunte oggi**. Non posso escludere che lì dentro ci fosse qualcosa. **404 ≠ 503**: questi restano nel catalogo, non cancellati |

---

# 7. 🏛️ LA RIGA PROP

> **In ottica prop, il risultato utile di questa caccia è una SOTTRAZIONE, e le
> sottrazioni contano.**
>
> Tredici motori che, accesi a fine settembre, avrebbero portato in challenge
> **stop da 12-20 pip** (14-23x il pedaggio), **lotti fissi non scalabili a
> 100k**, **due EA senza stop loss** e **tre doppioni** della flotta che
> avrebbero sommato drawdown invece di diversificarlo — non entrano.
>
> 🔴 **Il muro giornaliero (−5.000 su 100k) non lo sfonda il motore sbagliato:
> lo sfondano DUE motori giusti che perdono lo stesso giorno.** Il §5.D non è
> estetica, è il cancello che ha respinto `Autotrader Momentum`, `SuperTrend TV`
> e `SMC sweep` — tutti e tre sani, tutti e tre già coperti.

---

# 8. ❓ LA DOMANDA A CUI IL PROSSIMO PASSO DEVE RISPONDERE

> **"Sul nostro broker, XAUUSD ha un'ora in cui i tick crollano e ripartono —
> sì o no, e a che ora server?"**

È la domanda più economica del tavolo: **una risposta NO uccide un candidato in
un pomeriggio**; una risposta SÌ trasforma una bozza con i criteri già congelati
in un round lanciabile.

🔴 **E la domanda che NON va posta al web:** *"esiste un EA gratuito con lo stop
a 40 volte lo spread?"*. Su 1.079 titoli e 16 sorgenti, la risposta misurata di
oggi è che **lo standard pubblico è 3x**. Il prossimo motore per la forma che
ci serve, con ogni probabilità, **lo scriviamo noi** — ed è precisamente la cosa
in cui questo progetto è bravo.

---

## 📎 Provenienza e licenze

Tutti i sorgenti citati sono stati scaricati da `mql5.com/en/code/download/`,
liberamente accessibili, **nessuna licenza OSI dichiarata** sulle schede. Se un
giorno un `.mq5` derivasse da uno di questi, **autore e URL vanno in testa al
file** (regola di casa). Autori citati in questo dossier: Mokara, barabashkakvn,
zvickyhac, RanaAli878, RitzFalih, Nikita9995, Oschenker, GianlucaGangemi,
dj_ermoloff.

**Etichette:** ogni riga con un numero di riga di codice è **[VERIFICATO]**
(sorgente aperto e letto). I rapporti stop/spread sono **[INFERITO]** dai
default del sorgente e dai costi misurati in casa. Le fonti a 403/308/000 sono
**[INCERTO]**: non raggiunte, non "vuote".

---

# 🔍 VERIFICA DELLA SESSIONE PRINCIPALE (11/09) — il confronto 3,0x contro 40x NON regge

Il dossier presenta come titolo il fatto che `SMC Liquidity Sweep Scalper` (CB 77094)
implementa **il nostro stesso cancello** a `InpMinSLToSpreadRatio = 3.0`, contro il
nostro **40**, e ne trae: *"un autore che si e' posto esattamente il nostro problema
lo ha risolto a 1/13 della nostra severita'"*.

🔴 **Ho verificato da dove viene il nostro 40x, e le due soglie NON rispondono alla
stessa domanda.** Derivazione, testuale da
`caccia_strategie/CACCIA_TFBASSO_FREQUENZA_2026-09-06.md` r.339-342:

| soglia | da cosa deriva | che domanda risponde |
|---:|---|---|
| **40x** | `spread / stop <= 0,025` — il pedaggio puo' mangiare al massimo il **2,5%** del cancello | *"quanto edge sono disposto a regalare al broker?"* |
| **13,3x** | `spread / stop <= 0,075` — il pedaggio si mangia **tutto** il cancello, il motore deve produrre **il doppio in lordo** | *"sotto quale soglia non vale nemmeno la pena provare?"* |
| **3,0x** (loro) | rifiuta i setup con stop assurdamente piccolo rispetto allo spread | *"questo setup e' degenere?"* |

👉 **Il nostro 40x e' un BUDGET di edge. Il loro 3,0x e' un controllo di SANITA'.**
Sono due strumenti diversi che usano la stessa forma algebrica — e confrontare i
numeri e' come confrontare un limite di velocita' con il giro di motore massimo.

🔁 **Ed e' esattamente la stessa classe dell'errore sciolto ieri notte** (la
commissione: sonda 0,3 contro broker 0,9, *"vere tutte e due, mancava un termine"*):
quando due numeri onesti si contraddicono di un fattore grande, l'ipotesi da provare
per prima e' **"stanno misurando due cose diverse"**, non *"uno dei due sbaglia"*.

## 🛑 E soprattutto: questo NON e' un argomento per abbassare il 40x

La regola di casa dice che insistere vuol dire cercare **una misura in piu'**, mai un
criterio piu' morbido. 👉 La domanda legittima che resta aperta e' un'altra, e va
posta bene:

> ### 🔴 **Il 2,5% e' una SCELTA, non una misura. Non e' mai stato misurato quanto edge il pedaggio si mangi DAVVERO sulle nostre celle.**

E la misura esiste gia' in casa, parzialmente: R55 ha misurato il **costo per trade in
frazione di R** (PTE **0,41% di un R**, ORB **4,5% di un R**: undici volte). 👉 **Quello
e' il numero giusto per tarare il budget**, e a quel metro l'ORB era gia' fuori.

✅ **Quello che il confronto dimostra davvero, e vale:** siamo gli unici a
trattare il costo come un **budget di edge** invece che come un filtro anti-assurdita'.
Non e' severita' eccessiva: e' una domanda diversa — e spiega perche' il catalogo
pubblico non produce candidati per noi.

🎁 **E il bonus del dossier regge ed e' prezioso**: l'autore di CB 77094 dichiara in
testa al sorgente di aver aggiunto il filtro di trend HTF **dopo** che i backtest erano
tornati negativi. E' la **prima conferma esterna documentata** del nostro
**0 successi su 5** sul filtro appiccicato dopo.
