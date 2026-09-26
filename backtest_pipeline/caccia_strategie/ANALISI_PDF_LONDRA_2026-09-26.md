# 📄 ANALISI PDF — «Strategia Operativa Mercati di Londra» (26/09/2026)

**Fonte unica**: il PDF caricato da Claudio (2 pagine), testo estratto in
`scratchpad/londra_pdf.txt`. 🔴 **L'immagine dell'esempio NON e' nel testo**: del grafico si
conoscono solo le etichette sopravvissute all'estrazione (`32 PIP`, `Take profit`, `Stop Loss`,
`32 PIP`, `3 PIP`). Tutto cio' che il grafico mostra e il testo non dice e' **[NON LETTO]**.

**Perimetro**: SOLA LETTURA. Nessun EA, preset, file prova o parametro toccato. Nessuna riga
mandata. I file del round **R258** (in preparazione da un altro agente) **non sono scritti qui**:
questa scheda gli passa le regole, non le righe. Niente proposte di taglia.

**Etichette**: **[PDF]** = c'e' scritto, cito · **[NON DICHIARATO]** = il PDF tace, e un numero
che il PDF non da' **non e' un default**: e' una scelta nostra, da dichiarare come tale ·
**[DERIVATO]** = conto fatto da me sui numeri del PDF o del repo, con la formula ·
**[INFERITO]** = dedotto dal codice o da piu' fonti, dico quali · **[NON MISURATO]**.

---

## 0. 🥇 LE CINQUE RIGHE CHE CONTANO

1. 🟢 **Il PDF e `ABTG_Londra_ORB.mq5` sono LO STESSO MOTORE, con lo stesso orologio.** L'EA e'
   stato scritto da questo documento (intestazione r.7: *"Basato sul documento 'Strategia
   Operativa Mercati di Londra'"*), e le sue ore **06:00-07:00 server + ordini alle 07:00** sono
   **07:00-08:00 ora italiana**, cioe' la finestra del PDF. Quando `REGISTRO_TEST.md` dice che
   l'EA "ha misurato la pre-apertura", **dice la stessa cosa del PDF**: il PDF colloca
   l'apertura di Londra alle 08:00 italiane, la Borsa di Londra apre alle 09:00 italiane.
   👉 **Quale delle due ore rende e' una MISURA da fare, non un errore da correggere.**
2. 🔴 **Il motore del PDF non e' MAI stato misurato.** `ABTG_Londra_ORB` non ha **mai avuto un
   CSV** in tutta la storia di git (riverificato il 22-23/09) e il suo unico `.ini` e' **OHLC**.
   **R45 0/48 NON e' questo motore**: R45 era `ABTG_ORB_Ottimizzato` con range di **15-30
   minuti**, ingresso **alla chiusura M5** (non stop +3 pip), filtro **EMA 9/21**, SL
   all'**estremo opposto**, TP **in R**. Cinque differenze di meccanismo, non di parametro.
3. 🔴 **Il cancello del costo e' il vero ostacolo, e il numero cambia di tre volte a seconda
   che si conti la commissione.** Stop dell'esempio 19 pip: **63x** sul solo spread (0,3 pip
   mediano alle 07-10 server), ma **22,9x all-in** (spread 0,3 + commissione ~0,53 pip
   [DERIVATO]) e **15,4x** allo spread P95. **Per il 40x all-in serve un canale >= 60,4 pip**;
   per il pavimento DURO 13,3x basta >= 16,1 pip. La distribuzione del canale 06-07 su GBPUSD e'
   **[NON MISURATA]**: e' il primo numero che R258 deve stampare.
4. 🟠 **L'orologio "fisso" dell'EA si sposta di un'ora negli INVERNI dal 2025.** In ora di
   Londra il PDF e' SEMPRE 06:00-07:00 (Italia e Regno Unito cambiano ora insieme), ma BCM dal
   cambio di fine 2024/inizio 2025 e' UTC+1 fisso: d'inverno sta un'ora AVANTI a Londra.
   Quindi `InpRangeStartHour=6` e' fedele al PDF d'estate e negli inverni vecchi, e
   **misura 06:00-07:00 italiane negli inverni 2025 e 2025/26**. Nessun EA di casa ha una
   manopola di orologio per data.
5. 🟠 **Tre regole del PDF non sono codificabili tali e quali** (notizie "rilevanti" per
   l'intera giornata, verifica S/R su H1/H4/D1, trailing/TP multipli "a discrezione") e **una
   e' codificata diversa da come la scrive il PDF** (la variante prudente: l'EA dimezza il
   RISCHIO, il PDF dimezza i LOTTI, e cosi' facendo porta l'R:R a **0,91**, contro il suo
   stesso requisito "> 1:1"). Tutte deviazioni da **dichiarare** nel file prova, non da tacere.

---

## 1. 📋 LE REGOLE DEL PDF, UNA PER UNA, COL LORO VALORE

| # | regola | valore | citazione | etichetta |
|---|---|---|---|---|
| R1 | strumento | **GBP/USD**, uno solo | *"Cross operativo: GBP/USD."* | [PDF] |
| R2 | precondizione notizie | **nessun rilascio macro "significativo" nella GIORNATA** | *"esclusivamente in giornate prive di rilasci macroeconomici significativi"* | [PDF] — quali valute, quale impatto: **[NON DICHIARATO]** |
| R3 | finestra del canale | **l'ora prima dell'apertura di Londra = 07:00-08:00** | *"tra le 07:00 e le 08:00 (CET)"* §3.1 · *"(07:00–08:00 ora italiana)"* §5.1 | [PDF] — vedi §1.1 sul fuso |
| R4 | canale | **max e min** dell'intervallo; ampiezza **W** in pip | *"Tracciare una linea orizzontale sul minimo e una sul massimo"* · *"Calcolare l'ampiezza in pips"* | [PDF] |
| R5 | ingresso long | **Buy Stop a max + 3 pip** | *"Buy Stop a 3 pips sopra il massimo."* | [PDF] |
| R6 | ingresso short | **Sell Stop a min − 3 pip** | *"Sell Stop a 3 pips sotto il minimo."* | [PDF] |
| R7 | stop loss | **centro del canale** = (max+min)/2 → distanza **W/2 + 3 pip** | *"STOP LOSS: al centro del Canale"* | [PDF]; la distanza e' [DERIVATO] |
| R8 | take profit | **ingresso ± W** | *"TAKE PROFIT: livello di ingresso + ampiezza del canale"* | [PDF] |
| R9 | requisito R:R | **> 1:1** | *"Rapporto Rischio Rendimento > 1:1"* | [PDF] — e' **automatico se W > 6 pip** [DERIVATO, §1.2] |
| R10 | validazione | dopo aver messo i pendenti, **verificare S/R "significativi" su H1/H4/D1** nell'area di breakout | §4 | [PDF] — **DISCREZIONALE**, nessuna soglia |
| R11 | esempio | **W = 32 pip · SL 19 pip · TP 32 pip → R:R 1,68** | §5.1-5.2 | [PDF], R:R [DERIVATO] = 32/19 = **1,684** |
| R12 | variante prudente | **size −50%** e **SL sull'estremo OPPOSTO** del canale | *"si riduce la size del 50% e si spostano gli stop loss sui minimi e max opposti"* §5.3 | [PDF] |
| R13 | gestione | **trailing stop o TP multipli "a discrezione dell'operatore"** | §5.4 | [PDF] — **DISCREZIONALE**, nessun numero |
| R14 | performance | **NESSUN numero**: niente win rate, PF, DD, anni, operazioni | *"Il grafico mostra l'efficacia del breakout"* = **un esempio singolo** | 🔴 **[NON DICHIARATO]** — un grafico non e' una statistica |

### 1.1 🕰️ Il fuso: il PDF si contraddice da solo, e la lettura "ora italiana" e' quella che regge

- Il PDF scrive **"CET"** in §3.1 e **"ora italiana"** in §5.1, e **chiama "apertura di Londra"
  le 08:00** di quel fuso.
- 🔴 **In nessuna stagione le tre affermazioni sono vere insieme** [DERIVATO]: la Borsa di
  Londra apre alle **08:00 ora di Londra = 09:00 ora italiana, tutto l'anno** (i due Paesi
  cambiano ora insieme). Quindi "l'ora prima dell'apertura" in ora italiana sarebbe
  **08:00-09:00**, non 07:00-08:00.
- Se "CET" fosse preso alla lettera (UTC+1 fisso), d'estate 07:00-08:00 CET = 07:00-08:00 di
  Londra = davvero l'ora prima della Borsa; d'inverno no. Ma il §5.1 dice **"ora italiana"** in
  chiaro, e l'EA di casa ha gia' scelto quella lettura.
- 👉 **Lettura adottata, come da mandato: finestra 07:00-08:00 ORA ITALIANA = 06:00-07:00 ORA
  DI LONDRA, apertura "del PDF" alle 08:00 italiane.** E' la convenzione "FX London open alle
  07:00 GMT/BST" diffusa nel retail [INFERITO: non e' detta dal PDF], non l'apertura della
  Borsa. **La seconda lettura (07:00-08:00 di Londra) e' l'asse da misurare, non da scegliere.**

### 1.2 📐 La geometria, fatta a conti [DERIVATO]

Con **SL = W/2 + 3** e **TP = W**:

| W (pip) | SL (pip) | TP (pip) | R:R lordo | WR di pareggio lordo |
|---:|---:|---:|---:|---:|
| 6 | 6 | 6 | 1,00 | 50,0% |
| 10 | 8 | 10 | 1,25 | 44,4% |
| 20 | 13 | 20 | 1,54 | 39,4% |
| **32 (esempio)** | **19** | **32** | **1,68** | **37,3%** |
| 60 | 33 | 60 | 1,82 | 35,5% |

- **R:R > 1 ⟺ W > 6 pip.** Il requisito R9, letto come filtro, morde **solo** sui canali sotto
  i 6 pip. Letto come descrizione, e' sempre vero.
- Netto dei costi (all-in 0,83 pip, §6.3) l'esempio fa **31,17 / 19,83 = R:R 1,57** e chiede un
  **WR di pareggio del 38,9%**. Il PDF non dichiara alcun WR.

### 1.3 🔎 L'esempio numerico ha un refuso che si propaga (e va detto, perche' qualcuno lo copiera')

| livello | PDF | coerente con W=32, max 1,3330, min 1,3298 | esito |
|---|---|---|---|
| centro | 1,3314 | (1,3330+1,3298)/2 = **1,3314** | ✅ |
| **Buy Stop** | **1,3360** | 1,3330 + 3 pip = **1,3333** | 🔴 **refuso** (30 pip sopra il max, non 3) |
| SL long | 1,3314 "= 19 PIP" | 1,3333 − 1,3314 = **19** | ✅ solo con 1,3333 (con 1,3360 sarebbero **46**) |
| **TP long** | **1,3392** | 1,3333 + 0,0032 = **1,3365** | 🔴 calcolato dal refuso (1,3360 + 32) |
| Sell Stop | "3.295" | 1,3298 − 3 pip = **1,3295** | 🟡 refuso di battitura, valore giusto |
| SL short | 1,3314 "= 19 PIP" | 1,3314 − 1,3295 = **19** | ✅ |
| TP short | 1,3263 | 1,3295 − 0,0032 = **1,3263** | ✅ |

👉 **Il lato short dell'esempio e' coerente al pip; il lato long ha l'ingresso sbagliato e il TP
calcolato da quell'ingresso.** Le regole R5-R8 (testo) sono univoche: vale il testo, non
l'esempio.

---

## 2. 🕳️ COSA IL PDF NON DICE — ogni buco e' una scelta NOSTRA da dichiarare

| # | domanda | cosa dice il PDF | cosa fa l'EA oggi | etichetta |
|---|---|---|---|---|
| B1 | **OCO**: riempito un lato, l'altro si cancella? | niente: *"Impostare un ordine: Buy Stop... Sell Stop..."* | **si'**, `HandleOCO()` a ogni tick (r.136, r.304) | [NON DICHIARATO] — e conta: dopo uno stop al centro, il prezzo che prosegue di altri **W/2+3** pip fa scattare l'altro lato; con OCO quel trade **non esiste** |
| B2 | **scadenza** dei pendenti | niente | **240 minuti** (r.52) + **cutoff 11:00 server** (r.46): i due coincidono (07:00+4h) | [NON DICHIARATO] |
| B3 | **uscita a tempo** | niente: solo SL e TP | **flat alle 17:00 server** (r.48-50) | [NON DICHIARATO] |
| B4 | **breakout tardivo** (es. nel pomeriggio) | niente | non entra dopo le 11:00 server | [NON DICHIARATO] |
| B5 | **size / rischio** per operazione | niente, salvo *"riduce la size del 50%"* nella variante | `InpRiskPercent=1.0` (r.75), rischio sulla distanza dello stop | [NON DICHIARATO] — la taglia e' di Claudio, **nessuna proposta qui** |
| B6 | **quante operazioni al giorno** / rientri dopo uno stop | niente | **una** (la fase non torna mai a `LP_WAIT` nello stesso giorno, r.155-162) | [NON DICHIARATO] |
| B7 | **anni / operazioni provati**, win rate, PF, DD | **nessun numero** | — | 🔴 [NON DICHIARATO] |
| B8 | **cosa sono le notizie "significative"** (valute, impatto, finestra) | "giornate prive di rilasci" | ±60 min attorno a eventi High GBP/USD, **spento** di default | [NON DICHIARATO] |
| B9 | **quale S/R** e' "significativo", e cosa si fa se c'e' (si cancella? si sposta il TP?) | "verificare... per accertarsi che non siano presenti" | niente | [NON DICHIARATO] |
| B10 | **trailing / TP multipli**: quando, di quanto | "a discrezione" | parziale/BE/trailing ATR, **tutti spenti** di default | [NON DICHIARATO] |
| B11 | **filtro sull'ampiezza** minima o massima del canale | niente (salvo R9 implicito: W > 6) | `InpMinRangePips=0`, `InpMaxRangePips=0` | [NON DICHIARATO] |
| B12 | **TF del grafico** | nessuno per l'operativita'; H1/H4/D1 solo per la verifica S/R | il canale si calcola su **M1** comunque (r.174-184) | [NON DICHIARATO] — e irrilevante per il motore, §6.4 |
| B13 | **spread / slippage** | niente | nessun filtro (`InpMaxSpread=0`) | [NON DICHIARATO] |
| B14 | **ora legale** | niente | orario fisso in ora server | [NON DICHIARATO], §1.1 e §4.2 |

---

## 3. 🚩 BANDIERE ROSSE

| voce | esito | prova |
|---|---|---|
| martingala / griglia / mediazione / recovery | 🟢 **ASSENTI** | nessuna riga del PDF aggiunge posizioni o ne ricalcola la size dopo una perdita |
| stop loss vero | 🟢 **SI', sempre**, a prezzo fisso | *"STOP LOSS: al centro del Canale"* |
| trucchi anti-prop | 🟢 **ASSENTI** | il PDF non parla di prop |
| numeri di performance | 🔴 **ZERO**: un esempio singolo presentato come *"efficacia del breakout"* | §5.4 |
| filtro notizie | 🟠 **DISCREZIONALE** ("significativi", "giornate"): non codificabile tale e quale → **deviazione dichiarata** | §2 |
| verifica S/R su H1/H4/D1 | 🟠 **DISCREZIONALE**, nessuna soglia ne' azione: **non codificabile** → deviazione dichiarata; un proxy (es. massimo/minimo del giorno prima dentro il TP) sarebbe **un altro motore**, non il PDF | §4 |
| trailing / TP multipli | 🟠 **DISCREZIONALE** → fedele = **spenti** | §5.4 |
| **variante prudente** | 🔴 **contraddice il requisito del PDF stesso**: SL all'estremo opposto = **W+3 = 35 pip** contro TP **32** → **R:R 0,91 < 1** [DERIVATO]. E dimezzando i LOTTI con uno stop quasi doppio, il rischio in denaro scende solo a **0,5 × 35/19 = 0,92** di quello base [DERIVATO]: "abbassare il rischio" dell'**8%**, non del 50% | §5.3 |

---

## 4. 🔧 IL CONFRONTO CON L'EA DI CASA — `mql5/Experts/ABTG_Londra_ORB.mq5` (490 righe, letto per intero)

### 4.1 Regola per regola

| regola | PDF | EA (`ABTG_Londra_ORB.mq5`) | esito |
|---|---|---|---|
| strumento | GBP/USD | qualunque `_Symbol`; pip = 10 point su 3/5 decimali (r.107-111); preset `ABTG_Londra_ORB_GBPUSD.set` | ✅ uguale (il simbolo si sceglie da fuori) |
| finestra canale | 07:00-08:00 IT | `InpRangeStartHour=6` / `InpRangeEndHour=7` **server** (r.36-39) = 07:00-08:00 IT **d'estate e negli inverni fino al 2024** | ✅ **uguale**, 🟠 tranne gli inverni dal 2025 (§4.2) |
| calcolo max/min | max/min dell'ora | `iHighest`/`iLowest` su **M1** da 06:00 a 07:00 **inclusa** (r.174-184): la barra M1 delle 07:00 e' quella in formazione al primo tick → **61 barre, l'ultima di pochi secondi** | ✅ uguale in sostanza [INFERITO dal codice] |
| ora di piazzamento | "dopo" il canale = 08:00 IT | `InpPlaceHour=7` server (r.44) | ✅ uguale |
| buffer | 3 pip | `InpBufferPips=3.0` (r.55) | ✅ uguale |
| ingresso | Buy Stop / Sell Stop | `BuyStop`/`SellStop` (r.220, r.235) | ✅ uguale |
| SL | centro canale | `LDN_SL_MIDPOINT` = `(gHigh+gLow)/2` (r.203, r.214) | ✅ uguale |
| TP | ingresso ± W | `buyPx + width*InpTPRangeMult` con mult **1,0** (r.62, r.215, r.230) | ✅ uguale (dal prezzo del pendente, non dal prezzo di riempimento) |
| R:R > 1 | requisito | nessun controllo; `InpMinRangePips=0` | ⚪ **assente** — equivale a `InpMinRangePips` > 6 |
| OCO | [NON DICHIARATO] | **si'**, a ogni tick (r.136, r.304) | 🟠 **scelta dell'EA** |
| scadenza | [NON DICHIARATO] | 240 min (r.52) + cutoff 11:00 server (r.46-47, r.148-153) | 🟠 scelta dell'EA |
| uscita a tempo | [NON DICHIARATO] | flat 17:00 server (r.48-50, r.318-323) | 🟠 scelta dell'EA |
| notizie | giornata intera senza rilasci "significativi" | finestra **±60 min** su High GBP/USD (r.77-84, r.415-426), **spento** (`InpUseNewsFilter=false`); se acceso **chiude anche la posizione aperta** (r.142) | 🔴 **diverso**: finestra ≠ giornata, e la chiusura forzata il PDF non la chiede |
| verifica S/R H1/H4/D1 | discrezionale | niente (dichiarato nell'intestazione r.18-19) | ⚪ **assente**, e onestamente dichiarato |
| variante prudente | SL all'estremo opposto + **lotti** −50% | `LDN_SL_OPPOSITE` + `InpHalveOnOpposite` (r.30, r.60-61, r.208, r.219) — ma i lotti sono **gia' ridimensionati sullo stop largo** da `LotByRisk(dist)`, poi dimezzati | 🔴 **diverso**: l'EA dimezza il **rischio in denaro** (1% → 0,5%), il PDF lo porta al **~92%** (§3) |
| trailing / TP multipli | discrezionale | parziale + BE + trailing ATR (r.64-72), **tutti false** | ✅ fedele da spenti |
| rischio | [NON DICHIARATO] | 1,0% del saldo (r.75) | 🟠 scelta dell'EA — **non firmata** |
| rientri | [NON DICHIARATO] | uno per giorno di fatto | 🟠 scelta dell'EA |
| TF | nessuno | indipendente (canale su M1; ordini pendenti) | ✅ |
| spread | [NON DICHIARATO] | `InpMaxSpread=0` = nessun filtro | ✅ fedele |

### 4.2 🕰️ L'orologio, detto chiaro

- 🟢 **Il PDF e l'EA condividono la STESSA convenzione**: canale 07:00-08:00 **italiane** =
  06:00-07:00 **di Londra**, ordini alle 08:00 italiane. Il preset lo scrive in chiaro:
  *"07:00-08:00 CET = 06:00-07:00 SERVER (BCM = ora italiana - 1)"*.
- 🟠 `backtest_pipeline/REGISTRO_TEST.md` **r.127** (e la riga O4, **r.227**) chiama quella
  finestra *"la pre-apertura"* perche' il 03/09 si e' misurato che *"Londra apre alle 08:00
  ora server"* (`risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt` r.240-242).
  **Non e' una contraddizione con il PDF: e' la stessa osservazione vista dall'altra parte.**
  Il PDF chiama "apertura di Londra" le 08:00 italiane (= 07:00 di Londra); il registro chiama
  "apertura di Londra" le 08:00 di Londra (= 09:00 italiane, la Borsa). 👉 **L'EA e' fedele al
  PDF; se il PDF abbia scelto l'ora giusta e' la DOMANDA del round, non il suo difetto.**
  (Il registro sta in `backtest_pipeline/REGISTRO_TEST.md`, non nel `REGISTRO_TEST.md` della
  radice, che ha 149 righe.)
- 🔴 **La correzione che il registro del 03/09 non poteva avere**: `report/OROLOGIO_BCM_2026-09-24.md`
  ha misurato che **dal cambio fra il 26/12/2024 e il 02/02/2025 (forex) BCM e' UTC+1 fisso**.
  Quindi *"server = ora di Londra tutto l'anno"* e' vero **fino al 2024**; dal 2025 e' vero
  **solo d'estate**, e d'inverno il server sta un'ora **avanti** a Londra.

| periodo | PDF in ora server | ora della Borsa di Londra in ora server | l'EA (06-07 server) misura |
|---|---|---|---|
| estati (tutte) | **06:00-07:00** | 08:00 | ✅ il PDF |
| inverni fino al 2024 (e nov-dic 2024) | **06:00-07:00** | 08:00 | ✅ il PDF |
| inverni dal 2025 (gen-mar 2025, fine ott 2025-mar 2026) | 🔴 **07:00-08:00** | 🔴 09:00 | 🔴 **06:00-07:00 italiane**: un'ora **prima** del PDF |
| forchetta del cambio (27/12/2024-02/02/2025) | **[NON MISURATA]** al giorno | idem | ⚪ non attribuibile |

👉 **Su una finestra tick 2024.07.05-2026.06.30 circa un terzo dei giorni di borsa cade negli
inverni "nuovi"** [INFERITO: gen-mar 2025 + fine ottobre 2025-marzo 2026 ≈ 8 mesi su ~24] e
li' l'EA **non** e' il PDF. Nessun EA di casa converte l'ora per data (cercato
`OraLegale`/`DST` negli input: zero).

### 4.3 ⚠️ Difetti dell'EA che non toccano la misura ma toccano il campo

| difetto | dove | peso |
|---|---|---|
| `InpOneTradePerDay` e' **dichiarato e mai letto** | r.51 (unica occorrenza) | ⚪ innocuo: il comportamento "uno al giorno" viene dalla fase, non dall'input. Ma un file prova che lo mette ad asse **misura il nulla** |
| `SelPos()` usa `PositionSelect(_Symbol)` e `gTrade.PositionClose(_Symbol)` | r.377, r.142, r.321 | 🔴 **su conto HEDGING vede e chiude la posizione piu' vecchia del simbolo, di QUALUNQUE magic** (`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`). Nel tester da solo: nullo. In campo accanto a un'altra sedia GBPUSD: pericoloso |
| **nessun Guardian** | nessuna occorrenza di `InpUsaGuardian`/`ABTG_GuardiaIngresso` | 🔴 in campo non rispetterebbe pausa B1 ne' cap C1 |

---

## 5. 🔀 IL CONFRONTO CON `ABTG_LondonFx.mq5` — e' un meccanismo DIVERSO

✏️ **Una precisazione prima**: LondonFx **non e' una sedia promossa**. Il 03/09 Claudio ha
**firmato i criteri** del round (F1-F12, `risultati_archivio/LONDONFX_TICK_CRITERI.md`) e lo
stesso giorno **R116 l'ha BOCCIATO PER RISCHIO su tutti e due i simboli**
(`backtest_pipeline/REGISTRO_TEST.md` r.1263-1283): EURUSD motore 2 **PF OOS 0,843, DD OOS
37,14%**; GBPUSD motore 2 **PF OOS 0,763, DD OOS 55,03%**, IS gia' in perdita (PF 0,688).
*"Da R116 non esce una sedia"* (r.1313).

| asse | PDF / `Londra_ORB` | `ABTG_LondonFx` (R116) |
|---|---|---|
| il livello | **fisso**: max/min di UN'ora, calcolato UNA volta | **mobile**: SMA(5) degli HIGH e dei LOW, ricalcolato a ogni barra (r.349, r.542-549) |
| il grilletto | **ordine stop** 3 pip oltre il livello, al tocco | **chiusura** della barra fuori dal canale (+ RSI(5) > 80 / < 20 nel motore 2), a mercato |
| quando | un colpo alle 07:00 server, pendenti fino alle 11:00 | tutta la sessione **08:00-16:00 server** (r.361-362) |
| quante | max **1** al giorno | max **6** al giorno (r.315), 1 alla volta |
| SL / TP | **proporzionali al canale**: W/2+3 e W | **fissi**: 8 / 15 pip, RR 1,875 (r.311-312) |
| gestione | nessuna (fedele) | nessuna, per costruzione (N2) |
| TF | irrilevante | **M15** |

👉 **Hanno in comune solo la parola "Londra" e il simbolo.** R116 **non dice niente** sul PDF.
L'unica lezione che attraversa i due: su GBPUSD **uno stop da 8 pip e' mangiato dal costo**
(`report/GIACIMENTO_DI_CASA_2026-09-03.md` r.67: *"costo 1,7-3,3x l'edge"*) — e lo stop del
PDF, col canale stretto, **puo' scendere a 8 pip** (W = 10 → SL 8). Vedi §6.3.

---

## 6. 🧪 COSA SERVE PER MISURARLA (per chi prepara R258 — nessun file scritto qui)

### 6.1 Le manopole della FEDELTA' (il PDF alla lettera)

| manopola | valore fedele | stato nell'EA |
|---|---|---|
| `InpBufferPips` | **3,0** | ✅ esiste |
| `InpSLMode` | **0 = MIDPOINT** | ✅ esiste |
| `InpTPRangeMult` | **1,0** | ✅ esiste |
| `InpUsePartial` / `InpBreakeven` / `InpUseTrailing` | **false** | ✅ esistono |
| `InpMaxSpread` | **0** | ✅ |
| `InpRangeStartHour`/`EndHour`/`PlaceHour` | **6/7/7 d'estate e fino al 2024; 7/8/8 negli inverni dal 2025** | 🔴 **manca una manopola per data**: o si scrive (ora italiana → server secondo il calendario UE + cambio BCM) o si **spezza la corsa per stagione** con ore diverse, dichiarandolo. La forchetta 27/12/2024-02/02/2025 va **esclusa o dichiarata** |
| `InpMinRangePips` | **> 6** se R9 e' un filtro; **0** se e' una descrizione | 🟡 esiste; la lettura va **scelta e dichiarata prima dei numeri** |
| `InpHalveOnOpposite` | **false** per qualunque cella `OPPOSITE` | ✅ esiste — gia' chiesto da `report/I_MORTI_E_IL_PEDAGGIO_2026-09-23.md` r.309-313, altrimenti si misurano due cose insieme |

### 6.2 Le DEVIAZIONI da dichiarare (non sono il PDF, e il file prova deve dirlo)

1. 🔴 **Nessun filtro notizie** (la corsa misura il sovrinsieme dei giorni). Il PDF lo vuole
   **a giornata**; l'EA ha solo la **finestra ±60'**. E il calendario storico in repo
   (`mql5/Files/abtg_news_2021_2025_UTC.csv`: 2.972 righe, **240 GBP + 2.311 USD**, High) **si
   ferma al 19/12/2025**: il primo semestre 2026 **non e' coperto** (`abtg_news.csv` ha 17
   eventi). Un filtro "a giornata" e' anche **meno sensibile all'errore di fuso** di una finestra
   da ±60' [INFERITO]: con `InpNewsShiftMinutes` unico non si segue un orologio che cambia.
2. 🔴 **Nessuna verifica S/R**: non codificabile tale e quale.
3. 🟠 **OCO acceso**, **scadenza 240'**, **cutoff 11:00**, **flat 17:00**: scelte nostre sui
   buchi B1-B4. L'OCO e' quella che conta di piu' (§2 B1); **l'EA non ha l'interruttore**.
4. 🟠 **Il rischio per operazione** e' quello del file prova, non del PDF (B5). Taglia di Claudio.
5. 🟠 **La variante prudente** dell'EA **non e'** quella del PDF (§3, §4.1).

### 6.3 💰 Il cancello del costo — i numeri, con la fonte

| voce | valore | fonte |
|---|---|---|
| spread GBPUSD ore **07-10 server** | **mediana 0,3 pip · P95 0,7 pip** | `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` (5 giornate di settembre, 3.580-3.600 campioni/ora) |
| spread ore 00-06 server | mediana 0,3 · P95 **1,0** | idem |
| spread "A / B" di casa per GBPUSD | **0,2 / 1,0 pip** | `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.354, r.520 |
| commissione forex BCM | **0,004% del nozionale in valuta base, giro completo** = 4 GBP/lotto → **~0,53 pip a 1,3314** | legge in `CANCELLO_COSTO_FLOTTA` r.176-196; conversione in pip **[DERIVATO]**: 0,00004 × 1,3314 = 0,000053 |
| **costo all-in** | **0,83 pip** (mediana) · **1,23 pip** (P95) | [DERIVATO] |

| stop | / spread 0,3 | / all-in 0,83 | / all-in P95 1,23 | / B 1,0 |
|---|---:|---:|---:|---:|
| **19 pip (esempio PDF)** | 🟢 63,3x | 🔴 **22,9x** | 🔴 15,4x | 🔴 19,0x |

**Le soglie in ampiezza del canale** (SL = W/2 + 3) [DERIVATO]:

| pavimento | costo 0,3 (solo spread) | costo 0,83 (all-in) | costo 1,23 (all-in P95) |
|---|---:|---:|---:|
| **40x** (lavoro) | stop >= 12,0 → **W >= 18,0** | stop >= 33,2 → **W >= 60,4** | stop >= 49,2 → **W >= 92,4** |
| **13,3x** (duro) | stop >= 4,0 → W >= 2,0 | stop >= 11,0 → **W >= 16,1** | stop >= 16,4 → **W >= 26,7** |

- 🔴 **Contraddizione nel repo, da sanare prima del round**: `report/I_MORTI_E_IL_PEDAGGIO_2026-09-23.md`
  r.133 scrive per `Londra_ORB` *"40x ⇒ 12,0 pip"* sullo **spread solo**, e
  `backtest_pipeline/REGISTRO_TEST.md` r.227 *"spread 0,2 pip → il 40x chiede 8,0 pip e il
  pedaggio NON e' la spiegazione"*. **Tutti e due omettono la commissione**, che
  `CANCELLO_COSTO_FLOTTA` ha corretto l'**11/09** proprio sul forex (e che ha ribaltato cinque
  sedie). Con la commissione la soglia 40x **quasi triplica** (12,0 → 33,2 pip di stop).
- 👉 **Il numero che decide non c'e'**: la **distribuzione dell'ampiezza W del canale 06-07**
  su GBPUSD e' **[NON MISURATA]** (lo dice anche `I_MORTI_E_IL_PEDAGGIO` r.133). Se la mediana
  di W sta sotto i ~60 pip, **la maggior parte dei giorni sfonda il 40x all-in**, e la frase
  onesta sara' *"fedele al PDF, sotto il pavimento di costo nei giorni X%"*. Un
  `InpMinRangePips` da cancello di costo sarebbe **una deviazione dal PDF**, non la sua
  attuazione, e va misurato **dopo** la versione fedele.
- ⚠️ Il Buy Stop scatta sull'**Ask**: in prezzo Bid il buffer effettivo e' **3 − spread** pip.
  Irrilevante a 0,3 pip, da ricordare se lo spread si allarga.

### 6.4 📏 TF, campione, finestra

- **Il TF del grafico e' irrilevante per questo motore** [INFERITO dal codice]: il canale si
  calcola su M1 (r.174-184), gli ordini sono pendenti, l'`OnTick` gira a ogni tick. Con
  trailing spento, `@PERIODO` non cambia il risultato. 👉 La casella ⑤ del certificato di
  morte ("TF cambiato") qui **non si applica alla lettera**: l'asse equivalente e' la
  **durata del canale** (60' nel PDF) — e cambiarla e' una **deviazione**.
- **Modello: tick reali.** L'unico `.ini` esistente (`backtest_pipeline/ini/ABTG_Londra_ORB.ini`)
  e' `Model=1` (OHLC) dal 2024.01.01: da **non** riusare. Sulla famiglia breakout M5 degli
  indici l'OHLC ha gonfiato il PF del **71-125%** (`REGISTRO_TEST.md` r.112).
- **Pavimento tick GBPUSD: 2024.07.05** (misurato, `REFERTO_PASSO0_2026-09-03_1651.txt` r.13-14).
  Con **max 1 operazione/giorno** e ~500 giorni di borsa, il campione tick sta sotto i ~500
  trade, e il riempimento e' **[NON MISURATO]**: se riempie meno del ~60% dei giorni, uno split
  IS/OOS con **>= 150 per lato** non ci sta [DERIVATO: 150 × 2 / 500]. Il GBPUSD ha storia
  **nativa dal 1999** (`report/I_MORTI_E_LO_STORICO_2026-09-23.md` r.229), ma solo in OHLC.
- **Frequenza**: 1 simbolo × max 1/giorno = **max 1,00 op/giorno per la famiglia** anche a
  riempimento pieno. I gemelli (EURUSD...) servirebbero al pavimento di famiglia, ma **il PDF e'
  solo GBP/USD**: aggiungerli e' una deviazione, da misurare dopo la versione fedele.
- **Due lati**: il PDF e' simmetrico; la misura va letta **long e short separati**.

### 6.5 🎯 La domanda del round, in una riga

> *"Il PDF alla lettera (06-07 di Londra, stop +3, SL al centro, TP = W) ha un PF misurato a
> tick? E l'ora della Borsa (07-08 di Londra) fa meglio o peggio?"* — **due orologi, stessa
> geometria, criteri e regola di selezione congelati prima dei numeri.**

---

## 7. 🪦 LA LISTA DEI CADUTI — cosa e' morto DAVVERO, e cosa no

| caduto | cosa ha misurato | cosa ha in comune col PDF | cosa NO | copre il PDF? |
|---|---|---|---|---|
| **R45** (14/08, `risultati_archivio/REFERTO_ROUND45_LONDRA.md`, `prove/R45c_londra_GBPUSD.txt`) | `ABTG_ORB_Ottimizzato` su GBPUSD/EURUSD/XAUUSD, **M5, tick**, dal 2024.09.26: range **07:00→07:15/07:30 server**, **conferma su chiusura M5 + corpo 50% + EMA 9/21**, SL **estremo opposto**, TP **1,5/2,0 R**, fine 12:00 → **0/48**, GBPUSD migliore OOS **PF 0,61** | sessione di Londra, GBPUSD, due lati | range **15-30'** (non 60'), ingresso **a mercato su chiusura** (non stop +3), **filtro EMA**, SL **opposto** (non centro), TP **in R** (non W), **finestra un'ora dopo** quella del PDF | 🔴 **NO**: cinque differenze di meccanismo |
| **`Londra_ORB` / O4** (`REGISTRO_TEST.md` r.123, r.227) | **niente**: zero CSV in tutta la storia di git; `.ini` OHLC con asse `InpBufferPips` × `InpTPRangeMult` × lati. L'*"OHLC 11% pos, DD 23%"* citato il 19/08 **non e' verificabile** | **e' il PDF** | — | ⚪ **NON ANCORA MISURATO — 0 caselle su 5** |
| **capitolo breakout M5** (26/07, riscritto 22-23/09, `REGISTRO_TEST.md` r.114-134) | rottura della **candela pre-apertura da 5'** sugli **indici BCM**, due lati, senza trend ne' cancello d'ampiezza: **non paga a tick**, e muore sul **costo** (stop 1,2-8,8x lo spread) | la geometria straddle | **forex** (non indici), canale **60'** (non 5') | 🔴 **NO**. E il verdetto stesso dice: *"«Il breakout in apertura non ha edge» NON e' dimostrato: e' dimostrato che NON PAGA SU M5"* |
| **R42** (13/08) | **FADE** degli estremi del range d'apertura su NASUSD/D30EUR → 48/48 bocciato | gli estremi del range | direzione **opposta**, indici | 🔴 NO |
| **seconda caccia 03/09** (`CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md`) | chiude *"l'apertura di Londra in tutte e due le forme 'a livello'"* | — | la chiusura poggia su **R45** (sopra) e su **`BreakinBox`** misurato su **D30EUR** (falso breakout, non breakout) | 🟠 **NON COPRE il PDF**: nessuna delle due prove e' uno straddle 60' con SL al centro su GBPUSD |
| **R116 LondonFx** | canale SMA5 + RSI, 8/15 pip fissi → bocciato per rischio | Londra, GBPUSD | tutto il resto (§5) | 🔴 NO |
| **frase di famiglia** *"ORB chiuso con ~210 celle a tick"* | somma di R12 (Nasdaq), R45, R97, Live5m | la famiglia | nessuna di quelle celle e' il PDF | 🟠 e' un **prior**, non una misura del PDF |

👉 **Verdetto sul certificato di morte**: il motore del PDF ha **0 caselle su 5** (PF, n/DD,
uscita ad asse, gemelli, TF/durata). **Non e' morto: non e' mai nato.** Misurarlo **non**
viola la regola del 19/08 ("niente parametri nuovi su un motore morto"), perche' questo motore
**non e' mai stato dichiarato morto da una misura sua**.
🔴 **Ma il prior e' pessimo, e va scritto accanto**: stessa sessione, stesso simbolo, stessa
famiglia di R45 (0/48, PF 0,61 su GBPUSD), e un costo all-in che a W < 60 pip sta sotto il 40x.
L'attesa onesta e' **"NO probabile"**, come fu dichiarato per R116 — e **si misura lo stesso**,
perche' un "probabile" non e' un certificato.

---

## 8. 📌 FONTI LETTE

- PDF: `/root/.claude/uploads/.../80c8ce0c-Strategia_Operativa_Mercati_di_Londra.pdf` (testo estratto; immagine **non letta**)
- `mql5/Experts/ABTG_Londra_ORB.mq5` (490 righe, per intero) · `mql5/Presets/ABTG_Londra_ORB_GBPUSD.set` · `backtest_pipeline/ini/ABTG_Londra_ORB.ini`
- `mql5/Experts/ABTG_LondonFx.mq5` (intestazione, input, `#define`, r.1-375 e r.542-549)
- `backtest_pipeline/REGISTRO_TEST.md` r.110-134, r.227, r.1133-1150, r.1263-1343
- `backtest_pipeline/risultati_archivio/REFERTO_ROUND45_LONDRA.md` · `backtest_pipeline/prove/R45c_londra_GBPUSD.txt` · `mql5/Experts/ABTG_ORB_Ottimizzato.mq5` r.121-197 (enum SL/TP, conferma, EMA)
- `backtest_pipeline/caccia_strategie/CACCIA_LONDRA_MECCANISMI_2026-08-19.md` §0 · `CACCIA_LONDRA_ALTERNATIVA_2026-09-03.md` (via registro r.1315-1343)
- `report/OROLOGIO_BCM_2026-09-24.md` §0, §2.1 · `backtest_pipeline/risultati_archivio/allinealondra/REFERTO_PASSO0_2026-09-03_1651.txt` r.240-242
- `report/MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §4.2 · `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.172-209, r.345-358, r.505-520 · `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`
- `report/I_MORTI_E_IL_PEDAGGIO_2026-09-23.md` r.20-32, r.133, r.164, r.296-313 · `report/I_MORTI_E_LO_STORICO_2026-09-23.md` r.229
- `mql5/Files/abtg_news_2021_2025_UTC.csv`, `mql5/Files/abtg_news.csv` (copertura del calendario)
