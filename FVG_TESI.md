# 🕳️ FAIR VALUE GAP — tesi dell'adattamento (26/08/2026)

**File EA:** `mql5/Experts/ABTG_FvgRetest.mq5` · **magic 775501** (blocco
7755xx verificato **VERGINE** nel repo il 26/08/2026)
**Origine:** candidato **P1** della caccia SMC del 26/08/2026
(`backtest_pipeline/caccia_strategie/CACCIA_SMC_OB_FVG_2026-08-26.md`, voto
**9/10 — PROVA SUBITO**, il solo dei venti candidati letti che fosse già MQL5).
**Sorgente d'autore:** `KSQ Fair Value Gap EA — FVG with Regime Detection and
Dual SL TP Mode`, di **Adiec7 / "KSQuantitative — KSQuants"**, MQL5 Code Base
**71467**, pubblicato 2026-04-04, **949 righe, 53 input**, 1.820 download.
⚠️ **Nessuna licenza dichiarata** né sulla pagina né nel sorgente → uso interno
di ricerca, **attribuzione obbligatoria** (è in testa al `.mq5`).
Copia archiviata: `backtest_pipeline/caccia_strategie/biblioteca/sorgenti/KsqFairValueGapEA_Adiec7-KSQuantitative_mql5code71467_2026-08-26.mq5`.
**Le tre manopole di definizione** (taglia a percentile mobile, età minima,
mitigazione in %) vengono dal candidato **P3**, `Order Block Volumatic FVG
Strategy` di **TagsTrading** (TradingView `PjH7wg3n`, **CC BY-NC-SA 4.0**,
derivato dichiarato da *Volumatic Fair Value Gaps* di **BigBeluga**):
attribuzione a entrambi obbligatoria, **NC = uso di ricerca, non commerciale**.

> 🚧 **STATO: CANDIDATO DA BACKTEST.** Non è una sedia, **non va in forward**,
> il round coi criteri **non è questo documento**. Qui c'è solo: il meccanismo,
> la definizione esatta che misuriamo, ogni scostamento dichiarato, e i rischi
> messi sul tavolo *prima* di guardare un numero.

> 🔔 **PERCHÉ SI CHIAMA `FvgRetest` E NON `FvgRevert`.** Il mandato proponeva
> `ABTG_FvgRevert`. **Non è un ritorno alla media**: si compra il RITORNO del
> prezzo dentro un vuoto **nella direzione del movimento che lo ha creato** —
> è continuazione su pullback (lo dice la tabella "perché non è un caduto" del
> dossier: _"a favore del movimento che HA CREATO il gap"_). La parola giusta è
> quella di R42: _"l'unica cosa che ha sempre pagato è il **RETEST** — entrare
> sul RITORNO al livello DOPO la rottura confermata"_. **Nome cambiato e
> dichiarato.**

---

## 1. ⚡ IL MECCANISMO IN UNA PAGINA

**La tesi di mercato, in una riga:**
> _"Un Fair Value Gap è una finestra di prezzo che nessuno ha contrattato: tre
> candele in cui il mercato si è mosso troppo in fretta perché ci fosse un
> venditore per ogni compratore. Quel vuoto non ha padroni, e il prezzo tende a
> tornarci a cercare gli ordini che lì non sono stati eseguiti — chi entra sul
> ritorno compra dove la carta è mancata, non dove è finita."_

### 🔬 LA DEFINIZIONE MECCANICA CHE MISURIAMO — **una sola, dichiarata qui**

La scoperta trasversale n.5 del dossier dice che **"Order Block" non è UNA
cosa**: tre fonti indipendenti danno tre definizioni che sparano su barre
diverse. La stessa trappola vale per il FVG. Quindi la definizione **si dichiara
nei criteri, non si lascia agli input**:

| | **quello che questo EA misura** |
|---|---|
| **FVG RIALZISTA** | tre barre **CHIUSE consecutive** `i-2, i-1, i` con **`low[i] > high[i-2]`** (confronto **stretto**: due barre che si toccano non lasciano vuoto). **Zona = `[ high[i-2] , low[i] ]`** |
| **FVG RIBASSISTA** | **`high[i] < low[i-2]`**. **Zona = `[ high[i] , low[i-2] ]`** |
| **la barra di mezzo** | **nessun requisito**: né corpo minimo, né direzione, né volume. È la **definizione geometrica pura**, quella dell'autore |
| **le tre barre** | devono essere **consecutive NEL TEMPO** (`InpSoloBarreContigue`, default ON) — vedi §4.3 |

🔴 **Le varianti NON implementate e NON misurate** (perché un round misura una
definizione sola, e questo va scritto **prima**):
- *"la barra di mezzo dev'essere d'impulso"* (corpo ≥ X% del range);
- *"serve displacement"* (la spinta deve rompere una struttura);
- *"il gap vale solo dentro un Order Block"* → **è il round di P2, non questo.**

### Il giro completo (LONG; lo short è lo specchio esatto)

| # | pezzo | come si calcola nel `.mq5` |
|---|---|---|
| 1 | **IL VUOTO** | `RilevaFvgNuovo()` sulla barra **[1]** (l'ultima chiusa). Solo quella: la lista è **incrementale**, la scansione all'indietro a ogni tick dell'autore è inutile e col percentile costerebbe 200.000 confronti a barra |
| 2 | **LA TAGLIA** | `TagliaPercentile_Calc()` — il gap, **in % del prezzo**, deve valere ≥ `InpGapPctOfMax`% del **gap più grande delle ultime `InpGapPctLookback` barre**. È la specifica **P3**, ed è l'antidoto esatto al difetto n.1 dell'autore |
| 3 | **L'ETÀ** | `EtaOk_Calc()` — il vuoto deve avere ≥ `InpMinAgeBars` barre. **In modo RITORNO il minimo vero è 1**: entrare sulla barra che crea il gap non è un ritorno (§4.1) |
| 4 | **LA MITIGAZIONE** | `Mitigazione_Calc()` — **quanto in profondità** il prezzo è rientrato nel vuoto, in % dell'altezza del vuoto. 0 = ha sfiorato il bordo, 100 = ha colmato il vuoto, >100 = l'ha sfondato. Si entra se sta fra `InpMinMitigPct` e `InpMaxMitigPct` |
| 5 | **LA CONFERMA** | `Conferma_Calc()` — regola dell'autore: la barra chiude **in direzione** e **oltre il bordo** della zona |
| 6 | **IL REGIME** | `RegimeOk()` — **STACCATO** (`REG_NONE` di default). EMA(50/200) su H4 + ADX ≥ 20 sono i **gradini di ablazione**, non il motore |
| 7 | **INGRESSO** | a mercato, all'apertura della barra successiva. **Una posizione alla volta per magic**, **una sola decisione per barra** |
| 8 | **STOP** | `1,5 × ATR` (autore) — oppure punti fissi, oppure **strutturale oltre il bordo lontano del vuoto**. Poi **PAVIMENTO**, normalizzazione al tick, `SYMBOL_TRADE_STOPS_LEVEL` |
| 9 | **TARGET** | `3,0 × ATR` (autore) — oppure punti, oppure in R |
| 10 | **LOTTO** | dal rischio: `InpRiskPercent` del saldo / distanza dello stop, con `OrderCalcProfit` (converte in valuta conto) e tick value come ripiego |

**Decide SOLO a barra chiusa.** Rilevazione, età, mitigazione, conferma e
regime si leggono **tutti sulla barra [1]**. La barra in formazione **[0] non
entra in nessun calcolo**. Niente look-ahead, niente repaint.

### 🔧 L'ORDINE DELLE OPERAZIONI — è la correzione del difetto n.4

```
1. campione della taglia (finestra del percentile)
2. rileva il vuoto che si chiude sulla barra [1]
3. DECIDI l'ingresso, leggendo la barra [1]
4. SOLO ADESSO aggiorna mitigazione e morte dei vuoti
```
> ⚠️ **L'autore faceva 4 PRIMA di 3, e per giunta guardando la barra VIVA**
> (`rates[ratesTotal-1]`, riga 256 del suo file, contro `ratesTotal-2` della
> riga 313). Conseguenza: se la barra nuova **apriva dentro** la zona, il gap
> veniva marcato `isFilled` **prima** che l'ingresso lo vedesse → **segnale
> perso in silenzio**. Qui l'ordine è invertito e tutto è su barre chiuse.

---

## 2. 🔴 COSA È COSTITUTIVO (non si spegne) e COSA È INPUT

### Costitutivo — se lo togli, è un altro motore

| pezzo | perché è costitutivo |
|---|---|
| **IL VUOTO A TRE BARRE** | **è la tesi.** Non esiste nessun `InpUseFvg`. Il §5B di casa misura la differenza: **filtro appiccicato dopo = 0 successi su 5; filtro che È la strategia = 30 celle su 30** |
| **LA TAGLIA COME SOGLIA RELATIVA** | senza una scala, "gap grande" non vuol dire niente e il motore cambia comportamento fra DAX e EURUSD. Se il riferimento non è misurabile (< 100 campioni, o nessun gap nella finestra) **NON si entra**: un filtro senza dati non deve inventare un veto, ma **un motore senza dati non esiste** |
| **UN VUOTO = UN INGRESSO** | `tradato` (regola dell'autore, `isTraded`). Senza, un gap largo spara a ogni barra che lo tocca |
| **UNA POSIZIONE ALLA VOLTA** | scostamento voluto dall'autore (§4.6) |
| **SL VERO AL BROKER** | mai stealth, mai virtuale (bandiera §4) |
| **DECISIONE A BARRA CHIUSA** | come l'autore (`if(bars == g_prevBars) return;`) |

### 🎛️ Comportamento a dato mancante — scelta dichiarata
`TagliaPercentile_Calc()` con riferimento ≤ 0 **BLOCCA**. `Contigue_Calc()` con
TF non leggibile **BLOCCA**. `Mitigazione_Calc()` su un'altezza nulla torna −1,
che **non passa** nessuna finestra. **Stessa regola di `ABTG_AtrExhaustVol`.**

---

## 3. 📋 GLI INPUT COMPLETI, COL DEFAULT E DA DOVE VIENE

**62 input in 8 gruppi.** Di questi, **quelli che decidono se esiste un trade
sono 14** (rilevazione 8 + ingresso 6): **dentro il tetto di casa (~15)**. Gli
altri 48 sono regime staccabile (6), stop/gestione (18), operativa (10),
rischio (1), news standard (7), generali (5), Guardian (1).
🔴 **I 48 NON entrano nello sweep**: si pinnano nel file prova.

### Motore — rilevazione del vuoto
| input | default | da dove viene |
|---|---|---|
| `InpAllowLong` / `InpAllowShort` | **true / true** | 🏠 casa: **i due lati si misurano SEPARATI** (regola del 25/08) |
| `InpGapMode` | **GAP_PERCENTILE** | 🆕 **P3** — è l'unico modo che gira uguale su indici e forex (§4.2) |
| `InpGapPctOfMax` | **10.0** | 🟰 **P3** (`sizeFVG > 10`) |
| `InpGapPctLookback` | **1000** | 🟰 **P3** (`percentile_nearest_rank(diff, 1000, 100)`) |
| `InpMinGapPts` | 10 | 🟰 autore, **inerte** nel modo PERCENTILE |
| `InpSoloBarreContigue` | **true** | 🏠 casa (§4.3): il vuoto dev'essere **intraday**, non un gap di sessione |
| `InpMaxFvgTrack` | **50** | 🟰 autore (`InpMaxFVGs`) |

### Motore — ingresso nel vuoto
| input | default | da dove viene |
|---|---|---|
| `InpEntryMode` | **ENTRY_RITORNO** | 🔴 **SCOSTAMENTO PESANTE, §4.1** — il codice dell'autore entra sulla FORMAZIONE |
| `InpMinAgeBars` | **0** | 🆕 **P3** (il suo default è **40**: lo mettiamo a 0 perché **0 = "l'età non conta"** è l'ipotesi nulla da falsificare) |
| `InpMinMitigPct` | **5.0** | 🟰 **P3** (`longThreshold = 5`) |
| `InpMaxMitigPct` | **100.0** | 🆕 casa, **inerte** a 100. È l'altra metà della domanda "bordo o dentro?" |
| `InpInvalidPct` | **100.0** | 🆕 **P3** (§4.4: l'autore uccide il gap al **primo tocco**) |
| `InpConfirmCandle` | **true** | 🟰 autore |

### Regime — **staccabile, e parte STACCATO**
| input | default | nota |
|---|---|---|
| `InpRegimeMode` | **REG_NONE** | 🔴 **SCOSTAMENTO: l'autore parte da `REGIME_BOTH`.** Il dossier lo impone: baseline **NUDA**, EMA/ADX come **gradini di ablazione** |
| `InpRegimeHTF` / `InpEmaFast` / `InpEmaSlow` | H4 / 50 / 200 | 🟰 autore, inerti in NONE |
| `InpAdxPeriod` / `InpAdxMin` | 14 / 20.0 | 🟰 autore, inerti in NONE |

### Stop, target, gestione
| input | default | nota |
|---|---|---|
| `InpAtrPeriod` | **14** | 🟰 autore |
| `InpSLMode` | **SL_ATR** | 🟰 autore. `SL_STRUTT` (bordo lontano del vuoto + buffer ATR) è nostro, spento |
| `InpSLAtrMult` | **1.5** | 🟰 autore |
| `InpSLPts` | 150 | 🟰 autore, inerte |
| `InpSLStructBufAtr` | 0.25 | 🆕 nostro, inerte |
| **`InpMinSLAtr`** | **0.50** | 🔴 **PAVIMENTO ATTIVO (C4/R109), §4.5.** Con lo stop dell'autore (1,5 ATR) è **inerte**: non tocca la cella d'autore |
| `InpMinSLPts` | **0** | pavimento in punti MT5. Vale **il più largo** dei due |
| `InpTPMode` | **TP_ATR** | 🟰 autore |
| `InpTPAtrMult` | **3.0** | 🟰 autore. ⚠️ Si spazzola **verso l'ALTO** (2,5/3,0/3,5): sotto c'è il muro dell'attrito |
| `InpTPPts` / `InpTP_RR` | 300 / 2.0 | inerti |
| `InpTP1Pct` | **0** | 🔴 **SCOSTAMENTO §4.7: parziale SPENTO** (autore: 50%) |
| `InpTP1_RR` | **1.0** | a SL 1,5 ATR e TP 3,0 ATR, **1 R = esattamente metà TP** = il trigger `PARTIAL_MIDTP` dell'autore. **Le due regole coincidono ai default d'autore** |
| `InpBreakeven` | true | inerte senza parziale |
| `InpBEAtrTrigger` | **0** | 🔴 **SCOSTAMENTO §4.7: pari autonomo SPENTO** (autore: 1,0 ATR) |
| `InpBEBufferPts` | **0** | autore: 5 |
| `InpUseTrailAtr` | **false** | 🔴 **SCOSTAMENTO §4.7: trailing SPENTO** (autore: acceso) |
| `InpTrailAtrMult` | 1.0 | 🟰 autore, inerte |

### Operativa
| input | default | nota |
|---|---|---|
| `InpMaxTradesPerDay` | **3** | 🔴 **SCOSTAMENTO OBBLIGATO §4.8** (criterio C6). L'autore non ha cap |
| `InpUseHourFilter` / `InpHourStart` / `InpHourEnd` | false / **7** / **20** | 🟰 autore (7-20, **spento** anche da lui). **ORA SERVER**: BCM = ora italiana −1 |
| `InpNoOvernight` / `InpNoOvernightHour` | false / 21 | 🆕 casa, spento (l'autore non ce l'ha) |
| `InpFridayClose` / `InpFridayCloseHour` | false / 20 | 🆕 casa, spento |
| `InpMaxDailyDDPct` / `InpMaxTotalDDPct` | **0 / 0** | 🔴 **SCOSTAMENTO §4.9: i muri dell'autore (5% e 10%) partono SPENTI in backtest** |
| `InpRiskPercent` | **1.0** | 🔴 §4.10 (l'autore ha **lotto fisso 0,10**, vietato dal §4/C8 di casa) |
| news (7 input) | tutti off | blocco standard ABTG |
| `InpComment` / `InpMagic` | `"FVGRET"` / **775501** | blocco 7755xx **vergine** |
| `InpMaxSpread` / `InpVerbose` / `InpAutoTest` | 0 / true / true | |
| `InpUsaGuardian` | true | fail-open: nel tester non esiste → **backtest confrontabili** |

### 🧪 LA "CELLA AUTORE" — e perché **non è riproducibile in pieno**
Chi volesse il KSQ tradotto il più vicino possibile mette:
`InpGapMode=GAP_PUNTI`, `InpMinGapPts=10`, `InpEntryMode=ENTRY_FORMAZIONE`,
`InpMinAgeBars=0`, `InpRegimeMode=REG_BOTH`, `InpTP1Pct=50`, `InpTP1_RR=1.0`,
`InpBEAtrTrigger=1.0`, `InpBEBufferPts=5`, `InpUseTrailAtr=true`,
`InpMaxTradesPerDay=0`, `InpMaxDailyDDPct=5`, `InpMaxTotalDDPct=10`.
🔴 **Ma resterà un'approssimazione**, e il motivo è il §4.1: nell'autore
l'ingresso è un **predicato ambiguo** che copre *sia* la formazione *sia* il
ritorno tardivo (con una tolleranza di **una intera altezza di gap oltre la
zona**), e il suo `isFilled` binario **contraddice** il ritorno tardivo. **Noi
abbiamo separato le due cose in due modi distinti, perché un round misura una
cosa per volta.** Chi confronta i conteggi col Code Base deve saperlo.

---

## 4. 🔍 GLI SCOSTAMENTI DALL'AUTORE — uno per uno, col motivo

**Regola applicata:** ogni scostamento è un `input`, e l'EA **scrive nel log**
quando la cella non è la baseline nuda (`ATTENZIONE: almeno una variante è
accesa...`).

### 4.1 🔴 IL DIFETTO CHE NON ERA NELLA SCHEDA — l'autore entra sulla FORMAZIONE

Il dossier elenca **quattro** difetti di P1. Leggendo le 949 righe ne è uscito
un **quinto**, ed è il più pesante di tutti perché riguarda **il grilletto**:

```mql5
// riga 330-331 del sorgente d'autore
bool priceInZone  = (lastBar.low <= g_fvgArray[i].upper &&
                     lastBar.low  >= g_fvgArray[i].lower - (upper - lower));
```
`ScanFVGs()` aggiunge il gap che si chiude sull'**ultima barra chiusa**, e
`CheckFVGEntries()` valuta **quella stessa barra**. Ma per un FVG rialzista
`upper` **è** `low` di quella barra: quindi `lastBar.low <= upper` è
**vera per costruzione**, e la conferma (`close > open` e `close >= lower`) è
vera su qualunque candela d'impulso. 👉 **Il KSQ EA, coi suoi default, entra
sulla candela che CREA il gap.**

- **È la stessa classe di difetto dello scarto S8** del dossier (*Fair Value
  Gap Continuation Framework*: _"non entra sul ritorno: entra sulla chiusura
  della terza candela del gap"_). Là il cacciatore l'ha visto; **qui era
  nascosto sotto 949 righe**.
- **Non è un dettaglio di taratura: cambia la famiglia.** Formazione =
  **momentum di continuazione**. Ritorno = **retest**, cioè l'unica cosa che
  R42 dice abbia _"sempre pagato"_. **Sono due tesi di mercato diverse.**
- **Cosa ho fatto:** `InpEntryMode` con **default `ENTRY_RITORNO`** (la tesi del
  dossier) e `ENTRY_FORMAZIONE` come **braccio di ablazione gratuito** — esatta-
  mente quello che il dossier chiedeva di ricavare da S8.
- **Come lo impongo meccanicamente:** in modo RITORNO `EtaOk_Calc()` pretende
  **età ≥ 1 barra**, sempre, qualunque sia `InpMinAgeBars`. Non è aggirabile.

> ⚠️ **Conseguenza da mettere agli atti PRIMA del round:** i numeri che
> l'autore mostra sul Code Base — se mai li mostrasse — **non descrivono il
> motore che stiamo misurando**. Nessun numero d'autore entra in questo
> documento né deve entrare nel referto.

### 4.2 🔴 La taglia del gap: da `_Point` a PERCENTILE MOBILE (difetto n.1)
- **Autore:** `g_minGapSize = InpMinGapPoints * _Point` con `InpMinGapPoints=10`.
- **Il problema (scheda P1):** con la conversione C5 (**1 punto indice = 100
  punti MT5** su U30USD/NASUSD, misura R97) quei 10 punti valgono **0,1 punti
  indice**: il filtro è **di fatto spento**. È la classe di difetto del
  *Nightly QB* (soglia assoluta contro una grandezza che cambia scala).
- **Cosa ho fatto:** modo **PERCENTILE** di default (specifica P3): il gap, in %
  del prezzo, deve valere ≥ 10% del **gap più grande delle ultime 1000 barre**.
  **Si ritara da solo** fra DAX, Nasdaq ed EURUSD e fra un 2024 calmo e un 2025
  volatile. La soglia in punti resta come **alternativa spenta**.
- **Scostamento nello scostamento, dichiarato:** il Pine di P3 usa
  `ta.percentile_nearest_rank(diff, 1000, 100)`, che è **il massimo** della
  finestra: qui è calcolato **letteralmente come massimo**, e la finestra
  **include la barra corrente** come nel Pine.
- ✅ **Proprietà che vale oro per la regola dei due lati:** il riferimento è
  calcolato **dalle barre grezze**, non dalla lista dei gap. Quindi **la soglia
  di taglia è IDENTICA se giri long-only, short-only o entrambi.** I due lati
  restano confrontabili.

### 4.3 🆕 IL VUOTO DEVE ESSERE INTRADAY — `InpSoloBarreContigue`
- **Autore:** nessun controllo temporale. Su un indice a sessioni, `low[i] >
  high[i-2]` **a cavallo della chiusura serale** è vero ogni volta che il
  mercato riapre più in alto.
- **Perché è grave, doppiamente:**
  1. **Sarebbe un DOPPIONE**: il gap d'apertura è `ABTG_GapFill` (weekend) e
     `ABTG_GapContinuation` (Nikkei), **già in flotta**. Il dossier promuove P1
     perché _"non esiste un solo EA che riconosca un FVG a tre candele"_ — se
     poi l'EA misura i gap notturni, misura una cosa che abbiamo già.
  2. **Avvelenerebbe la soglia a percentile**: il massimo della finestra
     sarebbe **sempre** un salto notturno, e la soglia intraday diventerebbe
     irraggiungibile. Per questo la contiguità vale **anche sui campioni**.
- **Cosa ho fatto:** `Contigue_Calc()` pretende `t[i] − t[i−2] == 2 × TF`.
  **Default acceso.** ⚠️ **[SCELTA CONSERVATIVA]**: se il feed BCM ha barre
  mancanti per assenza di tick, questa regola **perde** quei gap. Perde
  livelli, **non ne inventa**. Spegnibile per misurare quanto pesa.

### 4.4 🟡 Mitigazione: da BINARIA a CONTINUA (difetto della scheda)
- **Autore:** `UpdateFillStatus()` — il gap muore **al primo tocco**. 0% o morto.
- **P3:** `f_mitigation_pct` → 0..100, con soglia spazzolabile.
- **Cosa ho fatto:** mitigazione **continua e non limitata** (può superare 100 =
  sfondato, o essere negativa = non arrivato), con **tre manopole**:
  `InpMinMitigPct` (P3: 5), `InpMaxMitigPct` (100 = inerte) e `InpInvalidPct`
  (100 = il gap muore quando è **attraversato del tutto**, come P3).
- **Perché il default di morte è 100 e non 0 (l'autore):** con una soglia
  d'ingresso al 5%, la regola dell'autore crea uno **stato irraggiungibile** —
  il gap morirebbe all'1% di tocco, prima che il 5% possa mai scattare. **Le due
  regole sarebbero logicamente incompatibili.** Effetto: **più segnali** dei
  suoi (un gap sfiorato resta vivo per un ritorno più profondo). **Dichiarato.**
- **E sostituisce la generosità nascosta dell'autore:** il suo `priceInZone`
  accettava un tocco fino a **una intera altezza di gap OLTRE** la zona
  (`lower - (upper-lower)`). Non era un bug, era una costante generosa: **ora è
  un parametro** (`InpMaxMitigPct = 200` ≈ la sua tolleranza).

### 4.5 🔴 PAVIMENTO DELLO STOP — attivo di default (difetto n.3, criterio C4)
- **Autore:** solo il minimo del broker (`stopLevel + spread`, riga 425).
- **La lezione, pagata:** R109 è morto **di stop senza pavimento** — DD 44-68%,
  peggior giornata **−9,72%**, e il lotto che sbatteva su `SYMBOL_VOLUME_MAX`
  su **66 trade su 743** (quei trade rischiavano *meno* dell'1%: **i DD
  misurati sottostimavano il rischio**). Più lo slippage misurato: **21,5 punti
  oltre lo stop** su NASUSD.
- **Cosa ho fatto, e perché così:**
  - **`InpMinSLAtr = 0,50` ATTIVO di default.** È **in ATR**, quindi è l'unico
    valore che si può dare *"per simbolo"* senza scrivere una tabella per
    simbolo: si ritara da solo fra D30EUR, U30USD, NASUSD e il forex.
  - 🎯 **E ai default dell'autore è INERTE**: lo stop è 1,5 ATR, il pavimento
    0,5 ATR. **Non cambia un solo trade della cella d'autore** — che è la
    proprietà che un default deve avere.
  - **Morde dove serve**: `SL_STRUTT` (stop al bordo del vuoto, che su un gap
    sottile può nascere a due punti dal prezzo) e `SL_PUNTI` con valori piccoli.
  - 🛑 **`OnInit` RIFIUTA di partire** con `SL_STRUTT` e **entrambi** i pavimenti
    a zero. Il C4 dice _"nessun promosso entra nel tester senza pavimento"_: è
    scritto nel codice, non nella buona volontà di chi compila il file prova.
  - `InpMinSLPts` (punti MT5) resta per una taratura per simbolo. **Valori di
    partenza [STIMA, DA MISURARE AL PASSO 0]:** su U30USD/NASUSD **≥ 2.500
    punti MT5 = 25 punti indice** (≈ lo slippage misurato di R109), su D30EUR
    da leggere sulla distribuzione di R. ⚠️ **Non sono misure: sono un punto
    di partenza da falsificare.**
- **Più la lezione R109 nel log:** quando il lotto sbatte sul tetto del volume,
  `LotByRisk()` **lo scrive** (_"questo trade rischia MENO dell'1% richiesto"_).
  Non si corregge in silenzio un numero che falsa il drawdown.

### 4.6 🔴 Una posizione alla volta (non tre)
- **Autore:** `InpMaxOpenTrades = 3` con `InpMaxTradesPerDir = 1`.
- **Il problema:** su un conto **HEDGING** (il nostro, BCM 50503392) significa
  **long e short aperti insieme** = copertura di fatto, che è una bandiera §4.
- **Cosa ho fatto:** **una posizione alla volta per magic**, come tutti gli
  ABTG. Non è un input: è la richiesta esplicita del dossier (_"Tetto a 1
  posizione totale"_).

### 4.7 🔴 La gestione parte SPENTA (l'autore la ha tutta accesa)
- **Autore:** parziale 50% a metà TP **+** pari a 1 ATR **+** trailing a 1 ATR,
  **tutti e tre di default**.
- **Cosa ho fatto:** `InpTP1Pct = 0`, `InpBEAtrTrigger = 0`,
  `InpUseTrailAtr = false`. **La baseline è SL e TP secchi.**
- **Perché — tre motivi, tutti misurati in casa:**
  1. Il **PASSO 0** deve misurare la **mediana del take LORDO** del meccanismo
     (cancello C2). Con tre strati di gestione accesi **quel numero non esiste**.
  2. **R:R invertito da gestione troppo stretta**: parziale precoce + pari
     immediato **tappano i vincenti** mentre lo stop prende perdite piene
     (lezione dell'EA oro, e la ragione per cui in casa il parziale parte off).
  3. Una cella con tre strati accesi **non è ablabile**: non sapresti mai
     quale dei tre ha spostato i numeri.
- ✅ **La coincidenza fortunata:** ai default d'autore (SL 1,5 ATR, TP 3,0 ATR),
  **metà TP = esattamente 1 R**. Quindi `InpTP1_RR = 1.0` **riproduce** il suo
  `PARTIAL_MIDTP` senza bisogno di un modo in più.

### 4.8 🔴 CAP GIORNALIERO — scostamento per REGOLA DI CASA
- **Autore:** nessun cap.
- **Nostro:** `InpMaxTradesPerDay = 3` (criterio **C6**).
- **Motivo specifico di QUESTO motore, e non è generico:** il dossier lo dice
  in chiaro — _"gli FVG nascono in grappoli sulle giornate di spinta, quindi più
  segnali nella stessa mattina, tutti dallo stesso lato"_. Sono **stop
  correlati in una seduta**, cioè esattamente ciò che ammazza una challenge
  (muro giornaliero −5.000 su 100k; peggior giornata di casa misurata: **−2,06%**).
- ⚠️ **È un default che CAMBIA il comportamento rispetto al Code Base.** Chi
  vuole fedeltà mette `0` e **lo dichiara**.

### 4.9 🔴 I MURI DI DRAWDOWN DELL'AUTORE PARTONO SPENTI
- **Autore:** DD giornaliero 5% e totale 10% **accesi** (sono letteralmente i
  muri prop, ed è la cosa più prop-friendly del suo file).
- **Nostro:** `0 = spento` **in backtest**.
- **Motivo, e viene da R109:** in backtest **un muro NASCONDE il rischio che il
  round deve misurare.** R109 con un muro al 10% avrebbe scritto *"DD 10%"*
  invece del **56%** vero — e a campione sottile **il rischio è l'unica corsia
  che non si sospende mai** (regola B dell'Emendamento). Un muro che tronca la
  misura falsifica proprio il numero che conta.
- Sul conto vivo quel mestiere lo fa il **Guardian** (firme B1/C1 del 18/08).

### 4.10 Lotto: da FISSO a RISCHIO % — imposto dal §4/C8
- **Autore:** `LOT_FIXED` **di default**, 0,10 lotti (il `LOT_RISK` c'era già ed
  è scritto bene: `tickValue/tickSize`).
- **Nostro:** **il lotto fisso non esiste come opzione.** Il criterio C8 lo
  elenca fra le cose che non entrano (_"niente ... lotto fisso"_). Rischio %
  con `OrderCalcProfit` (lezione 08/08 su 225JPY: il tick value non convertito
  faceva uscire lotto ~0) e tick value come ripiego.
- ⚠️ **Il rischio % è un moltiplicatore lineare del P/L e del drawdown**: a
  0,65% (la taglia di campo) tutti i numeri in euro si moltiplicano per 0,65.
  **Nessuna conclusione sul MERITO cambia; tutte quelle sul RISCHIO sì.**

### 4.11 Traduzioni tecniche e cose non portate
- **`ORDER_FILLING_FOK` → `SetTypeFillingBySymbol()`**: l'autore forzava FOK
  (riga 168). Su BCM, se il simbolo non ammette FOK, **gli ordini vengono
  rifiutati** e l'EA sembrerebbe non fare niente. La scheda P1 lo segnalava.
- **Regime letto allo shift 1, non 0**: l'autore leggeva EMA e ADX sulla barra
  **viva** (`CopyBuffer(...,0,3,...)`) e confrontava col prezzo **corrente**.
  Regola di casa: **si legge la barra chiusa**.
- **Rilevazione incrementale** invece della riscansione di 200 barre a ogni
  barra nuova: stesso risultato (l'autore aveva `FVGExists()` come antiduplica),
  costo computazionale compatibile col percentile mobile.
- **NON portati:** il cruscotto `Comment()`/`OnChartEvent` (grafica),
  `Alert`/`SendNotification` (rumore nel tester), `HasSufficientMargin()` (un
  ordine senza margine viene rifiutato dal broker e loggato: caso già gestito).

---

## 5. 🎯 DOVE DEVE GIRARE, E QUANTO DOVREBBE SPARARE

**Simboli, prima corsia:** `D30EUR`, `U30USD`, `NASUSD` (BCM, conto HEDGING).
**TF: M15** — ed è il TF che il mandato chiedeva.
**Finestra:** `@DAQUANDO 2024.09.26` — **misurato**
(`REFERTO_SONDA_STORICO_17-08.md`, stato COMPLETO) ≈ **450 sedute**, ~21 mesi.
⚠️ **La sonda va rifatta prima del round**: se il broker ha allungato lo storico
cambia il conteggio e quindi l'esito dell'Emendamento §A. E c'è il tetto del
tester (~100.000 barre/corsa → M15 ≈ 4 anni: qui non morde).
**Seconda corsia, se la frequenza regge:** FX majors su M15 — **è il motivo per
cui la soglia di taglia è a percentile e non in punti**.

### 📊 Frequenza — 🔶 **STIMA, NON MISURA. È IL PRIMO NUMERO DEL ROUND.**

| | valore | rango |
|---|---|---|
| barre di sessione al giorno, D30EUR M15 | ~56 | 🟢 aritmetica |
| barre che chiudono un FVG a tre candele | **2-4%** | 🔴 **IPOTESI del dossier, non misurata** |
| gap per lato al giorno | 1-2 | 🔶 derivata |
| **operazioni per lato in 21 mesi** | **~150-500** | 🔶 **[STIMA] da falsificare al PASSO 0** |

🔴 **Le tre cose che spingono la stima VERSO IL BASSO, e vanno dette prima:**
1. **`InpMinMitigPct = 5`**: il prezzo deve **tornare** nel vuoto, non sfiorarlo.
2. **una posizione alla volta + una decisione per barra + cap 3/giorno**:
   tre tagli che l'autore non ha (lui ne teneva 3 aperte e non aveva cap).
3. **`InpSoloBarreContigue`**: via i gap di sessione, che su un indice sono
   **ogni notte**.
👉 **Se al PASSO 0 escono < 150 operazioni per lato, scatta la valvola R59** e
il round misura **solo il rischio**. Se ne escono migliaia, si stringe la
taglia (`InpGapPctOfMax` verso l'alto): **è la manopola giusta, non il rischio**.

### 💰 Cancello C2 (il costo si legge PRIMA del PF)
| | valore | rango |
|---|---|---|
| soglia di casa | take mediano **≥ 6,0 punti indice** (3 × 2,0 di spread) | 🟢 `R98_CRITERI` §3.2 / `METRO_PROP` D4 |
| spread BCM indici | 2,0 punti indice | ⚠️ **[SPREAD NON MISURATO]**, lato alto della forchetta 1-2 |
| ATR(14) su DAX M15 | 8-15 punti indice | 🔶 **[STIMA]** |
| TP a 3,0 × ATR | **24-45 punti indice** | 🔶 derivata → **margine 4×-7,5×** |

✅ **Il cancello passa con comodo — sulla carta.** ⚠️ **Ma il numero che conta
non è il TP nominale: è la MEDIANA DEL TAKE LORDO REALIZZATO**, che include
gli stop. **Si misura al PASSO 0.** E la regola di lettura di `METRO_PROP` D4:
**fra 2,5× e 3,5× il verdetto NON si dà** — si misura lo spread col *RealCost
Spread P95 Logger* (Code Base 74148, **promosso il 23/08 e mai usato**) e si
rilegge.

### 🏛️ In ottica prop
🟢 **Scorrelazione alta**: nessuna sedia viva usa **un vuoto di prezzo** come
livello. Su M15 indici oggi gira solo `MaxMinNotte DAX Short` (notte europea):
**fascia oraria diversa, livello diverso, lato diverso.**
🔴 **Il rischio da sorvegliare è la CONCENTRAZIONE**: i vuoti nascono in
grappoli. Il cap giornaliero è un tampone **per sedia, non per famiglia**: con
tre indici accesi serve un limite di famiglia **prima** di qualunque challenge.
E **la peggior giornata si misura**, non si deduce dal DD totale: la colonna
c'è nell'OPTFRAME (metro −2,06%, muro −5,00%).

---

## 6. 🧪 COSA MISURARE, E IN CHE ORDINE (per il round, che non è questo file)

**Una gamba alla volta, tutto il resto pinnato.** Cella base = **BASELINE
NUDA**: `GapMode=PERCENTILE`, `EntryMode=RITORNO`, `RegimeMode=NONE`,
`MinAgeBars=0`, `TP1Pct=0`, `BEAtrTrigger=0`, `TrailAtr=off`, `SLMode=ATR`,
`SoloBarreContigue=on`, muri DD spenti, rischio 1%.

0. **PASSO 0 — CONTARE, PRIMA DI QUALUNQUE PF.** Operazioni per lato,
   operazioni/seduta, **mediana del take lordo in punti indice**, distribuzione
   di R, quante giornate al cap, **quante volte il lotto sbatte sul tetto**.
1. **I DUE LATI SEPARATI** (`InpAllowLong` / `InpAllowShort`, mai insieme al
   primo colpo). Regola di Claudio del 25/08.
2. 🎯 **`InpEntryMode`: RITORNO vs FORMAZIONE.** È **la domanda della caccia**
   (§4.1) e distingue retest da momentum **con lo stesso rilevatore**.
3. 🎯 **`InpMinMitigPct` / `InpMaxMitigPct`: si compra sul BORDO del vuoto o
   DENTRO?** Scoperta n.6 del dossier: _"una domanda di mercato vera,
   misurabile in una griglia a 4 celle"_ — e **nessuna delle venti fonti se
   l'è mai posta**.
4. 🎯 **`InpMinAgeBars`: l'età conta?** (0 / 10 / 40 / 100). P3 dice 40 barre =
   10 ore su M15. **Né P1 né P2 possono rispondere: non hanno il parametro.**
5. **`InpGapPctOfMax`** (5 / 10 / 20): la manopola della frequenza.
6. **`InpTPAtrMult` verso l'ALTO** (2,5 / 3,0 / 3,5). Mai sotto.
7. **Lo stop:** `SL_STRUTT` contro `SL_ATR`, e il **pavimento** sulla base della
   distribuzione di R del PASSO 0.
8. **La gestione:** parziale 1R + pari, poi trailing. **Ultimi**, non primi.
9. **`InpRegimeMode`: gradini di ablazione** NONE → EMA → ADX → BOTH.
   ⚠️ Attesa dichiarata **prima**: in casa il filtro appiccicato fa **0 su 5**.
   Se il motore nudo non regge, **il regime non lo salva** (R101).
10. ❌ **`InpSoloBarreContigue` NON si spegne nella prima griglia**: spegnerlo
    trasforma l'EA in un doppione di `ABTG_GapFill`/`GapContinuation` (§4.3).

⚠️ **4 assi liberi = 81 celle: troppe.** Regola dell'altopiano: **2 assi liberi
per corsa**. E la selezione è **centro dell'altopiano, MAI il picco** — la
regola di selezione si dichiara **insieme** al numero.

---

## 7. 🚨 I RISCHI — dichiarati PRIMA dei numeri

1. 🔴 **VALIDAZIONE SOLO A TICK REALI** (criterio C3). L'OHLC 1-min su M15
   serve a **CONTARE i trade**, mai a dare il segno: R57 ha misurato il segno
   dell'orso **ribaltarsi** cambiando solo il modello (+129k finti sul DAX).
   Qui morde in modo specifico: l'ingresso nasce da un **estremo di barra**
   (`low[1]`/`high[1]`) confrontato con una zona — in OHLC il simulatore non sa
   in che ordine il prezzo ha visitato high e low dentro la barra.
2. 🔴 **UN SOLO REGIME.** 2024.09.26 → oggi sono **~21 mesi prevalentemente
   rialzisti**, storico unico su BCM. È il muro esatto che ha reso R109 _"non
   misurabile per il MERITO"_. **Il verdetto di merito è provvisorio per
   costruzione; quello di rischio vale pieno** (Emendamento §B).
3. 🔴 **IL GRADIENTE DI TF È CONTRO DI NOI, ed è misurato.** R108/R111: Breaking
   Band da H1 a M30 a M15 dà un gradiente **MONOTONO H1 > M30 > M15** su 3
   simboli, e a M15 **6 finestre su 6 rosse**. Non è una proprietà di questo
   motore, ma è la fotografia di *quel* TF su *quel* broker. **Se il PASSO 0
   dice che il take mediano è sottile, questo rischio diventa la spiegazione.**
4. 🔴 **NON C'È LETTERATURA.** Cinque interrogazioni ad arXiv: `"fair value
   gap"` + trading → **0 entry**; `"smart money concepts"` → **0**;
   `"order block"` → 2, ed erano **teoria dei grafi e blockchain**. **Nessuno,
   fuori, ha falsificato al posto nostro.** Sul fade d'apertura il paper Mesfin
   ci ha risparmiato dei round; qui quel risparmio **non c'è**, e il cancello
   del costo e la prova di frequenza **pesano il doppio**.
5. 🟠 **n < 150 → VALVOLA R59.** Sotto le 150 operazioni per lato il round
   misura il **RISCHIO** (drawdown, peggior giornata: fatti accaduti) e
   **sospende il giudizio sul MERITO**.
6. 🟠 **LA SOGLIA A PERCENTILE È OSTAGGIO DEGLI ESTREMI.** Il riferimento è il
   **massimo** di 1000 barre: un singolo gap mostruoso (news, apertura violenta
   sfuggita al filtro di contiguità) **alza l'asticella per 1000 barre**, cioè
   ~18 sedute su M15. È una proprietà di P3, non un bug — ma va **guardata nel
   log** (`RiferimentoMax` viene stampato al riempimento della finestra). Se
   dà problemi, il rimedio è un percentile più basso (es. il 95°), **e sarebbe
   uno scostamento nuovo da dichiarare**.
7. 🟠 **CONCENTRAZIONE E CORRELAZIONE.** Vuoti in grappoli, tre indici che
   spingono insieme. Cap per sedia ≠ cap di famiglia (§5).
8. 🟠 **SLIPPAGE SUGLI STOP: 21,5 punti indice MISURATI** su NASUSD (R109). Con
   stop stretti **non è un dettaglio contabile, è il punto in cui il candidato
   vive o muore**. È la ragione per cui il pavimento è acceso di default.
9. 🟠 **BROKER SINGOLO, COSTI SINGOLI, SPREAD NON MISURATO.** Tutto su BCM. Non
   è una proprietà del mercato. E il *RealCost Spread P95 Logger* (Code Base
   74148) **è ancora mai stato usato**: è la terza caccia che lo scrive.
10. ⚪ **NESSUN NUMERO D'AUTORE È STATO USATO**, in nessun punto, né deve
    entrare nel referto. E per il §4.1 **non descriverebbe nemmeno lo stesso
    motore**.

---

## 8. 👀 DOVE GUARDA PER PRIMO UN REVISORE

Se hai dieci minuti e vuoi trovare l'errore, guarda **in quest'ordine**:

1. **`OnNewBar()` — L'ORDINE DELLE QUATTRO CHIAMATE.** Deve essere: campione →
   `RilevaFvgNuovo` → `CercaIngresso` → `AggiornaMitigazione` → `PurgaFvg`. Se
   qualcuno sposta `AggiornaMitigazione` **prima** di `CercaIngresso`, **torna
   il difetto n.4 dell'autore**: il gap muore prima che l'ingresso lo veda e il
   segnale sparisce **in silenzio** (nessun errore, solo meno trade).
2. **`EtaOk_Calc()` con `modoRitorno = true`.** Deve pretendere **età ≥ 1**
   anche con `InpMinAgeBars = 0`. Se qualcuno toglie quella riga, l'EA torna a
   entrare sulla **formazione** del gap (§4.1) **senza dirlo**: sarebbe un
   motore diverso con la stessa etichetta. **È il punto più delicato del file.**
3. **`RilevaFvgNuovo()` e `CampioneGapPct()` — gli SHIFT.** Il vuoto si chiude
   sulla barra **1**, e le altre due sono **2** e **3**. Se qualcuno usa lo
   shift 0, entra la barra in formazione e **da lì in poi ogni backtest è finto**.
4. **`Contigue_Calc()` — che sia applicata IN DUE POSTI**: nella rilevazione
   *e* nel campione della finestra. Se resta solo nel primo, i gap notturni
   avvelenano la soglia (§4.3).
5. **`Mitigazione_Calc()` — che NON sia limitata a 0..100.** La parte oltre 100
   serve a dichiarare morto il vuoto, quella sotto 0 a distinguere "non
   toccato" da "toccato appena". Un `MathMax(0,...)` di cortesia romperebbe
   entrambe le regole.
6. **`Enter()` — l'ordine:** stop grezzo → **PAVIMENTO** → normalizzazione →
   `STOPS_LEVEL` → target → lotto → **Guardian** → invio. Il Guardian sta
   **immediatamente prima dell'invio**, così l'unico effetto è che l'ordine non
   parte (caso già gestito).
7. **`OnInit()` — il rifiuto C4.** `SL_STRUTT` con entrambi i pavimenti a zero
   **deve** tornare `INIT_FAILED`. È R109 scritto nel codice.
8. **`LotByRisk()`** — distanza in **prezzo**, perdita per lotto da
   `OrderCalcProfit`. Qualunque conversione in "pip" qui è un bug su un indice.
   E l'avviso sul tetto del volume **non va tolto**: è il numero che falsa i DD.
9. **`RegimeOk()`** — `REG_NONE` deve tornare `true` **subito**, e gli altri
   modi devono leggere lo **shift 1**.
10. **L'AUTOTEST — 9 blocchi** (vuoto, contiguità, taglia, mitigazione,
    finestra, età, conferma, pavimento, orario). Si legge **ESEGUENDO** un test
    singolo nel tester, **non compilando**. Se stampa `DIVERGE`, **i risultati
    non si usano**.
11. **Gli orari** — `OraOK()` legge `iTime(...,1)`, cioè l'**ora SERVER** della
    barra di segnale. **Ora italiana −1.** E i log di MT5 sono in ora **locale
    del PC**: non confrontarli col grafico (lezione 06/08).

---

## 9. ❓ I DUBBI ANCORA APERTI — non li nascondo

1. **Chi vince quando due vuoti qualificano sulla stessa barra?** Ho scelto
   **il più recente** (l'autore prendeva il più vecchio). Motivo: è quello
   dentro cui il prezzo è appena tornato e il più stretto rispetto al prezzo.
   **[SCELTA DICHIARATA, non misurata.]** Con `InpMinAgeBars > 0` la domanda
   cambia forma. Si può misurare, ma non nella prima griglia.
2. **La finestra del percentile è 1000 barre = ~18 sedute su M15.** È il
   default di P3, nato su cripto H1. **Non so se sia la scala giusta per un
   indice su M15** e non l'ho spazzolata. È un asse candidato per il secondo
   round.
3. **`InpMinAgeBars = 0` di default contro il 40 di P3.** Ho messo l'ipotesi
   nulla ("l'età non conta") perché è quella da falsificare. Ma **se il P3
   avesse ragione**, la baseline nuda sta misurando un motore più rumoroso del
   necessario. Il gradino 4 del §6 risponde.
4. **La contiguità stretta (`== 2 × TF`) su un feed CFD.** Se BCM ha barre
   mancanti per assenza di tick, perdo gap veri. **Non ho misurato quante.**
   Prima riga del PASSO 0: contare i gap scartati per contiguità.
5. **`SL_STRUTT` non ha un buffer misurato** (`InpSLStructBufAtr = 0,25` è un
   numero scelto, non trovato). Va tarato **dopo** che il PASSO 0 ha mostrato
   la distribuzione dell'altezza dei vuoti.
6. **62 input sono tanti.** I 14 di segnale stanno nel tetto, ma il file è
   grasso di gestione. **Se dopo il primo round metà di quelle manopole non
   serve, vanno tolte** — non lasciate lì "per sicurezza": ogni input spento è
   un invito a girarlo.

---

## 10. ⚠️ LE DUE RIGHE CHE VALGONO PIÙ DI TUTTO IL RESTO

> **Questo file NON dice che la strategia funziona.** Dice cosa fa il codice,
> dove si scosta dall'autore e perché, e quali sono i rischi. **Il giudizio
> arriva dal round, a tick reali, con i criteri congelati prima dei numeri —
> e con la firma di Claudio su quei criteri.**

> **NON va in forward.** Un backtest profittevole non è una promessa: broker
> singolo, spread non misurato, **un solo regime**, ~21 mesi di storico, un TF
> su cui il gradiente misurato in casa è il peggiore dei tre, e **zero
> letteratura alle spalle**.

---

*Documento della caccia SMC del 26/08/2026 — candidato P1.
EA: `mql5/Experts/ABTG_FvgRetest.mq5`, magic 775501.
Attribuzione: Adiec7 / KSQuantitative (MQL5 Code Base 71467) per il motore;
TagsTrading e BigBeluga (TradingView PjH7wg3n, CC BY-NC-SA 4.0) per le tre
definizioni di taglia, età e mitigazione.*
