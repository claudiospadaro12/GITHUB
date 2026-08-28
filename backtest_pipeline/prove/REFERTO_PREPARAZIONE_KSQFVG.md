# 🧾 REFERTO DI PREPARAZIONE — **KSQ Fair Value Gap EA → `ABTG_FvgRetest`**

**Data:** 28/08/2026 · **Mandato:** preparare il file prova del promosso **P1**
della caccia SMC del 26/08 (`caccia_strategie/CACCIA_SMC_OB_FVG_2026-08-26.md`,
verdetto **🟢 PROVA SUBITO — 9/10**), approvato da Claudio.

---

## 🔴 LA PRIMA COSA DA SAPERE: **il `.mq5` ERA GIÀ FATTO. Non l'ho riscritto.**

Il mandato mi chiedeva di partire dal sorgente d'autore
(`biblioteca/sorgenti/KsqFairValueGapEA_...71467_2026-08-26.mq5`) e correggerne
cinque difetti. **Quel lavoro era già stato fatto due giorni prima**, ed è in
repo:

```
mql5/Experts/ABTG_FvgRetest.mq5      1.495 righe, magic 775501
commit f7f5e71  (26/08/2026)  "ABTG_FvgRetest: adattamento in casa del
                               promosso P1 (KSQ FVG EA, Code Base 71467)"
tesi dichiarata:  FVG_TESI.md        634 righe
```

**Riscriverlo sarebbe stato un doppione**, e un doppione di un EA è il modo più
efficace di far girare in forward la versione sbagliata. Quindi il mio lavoro è
diventato **(a) l'AUDIT** di quel file contro i cinque punti del mandato, e
**(b) i tre artefatti che mancavano davvero** — il file prova, la riga di
lancio, questo referto.

> ⚖️ **Distinzione onesta fatto / inferenza:** l'audit qui sotto è **statico**.
> Ho letto il sorgente e verificato i numeri di riga. **Non ho compilato e non
> ho eseguito niente**: in questo ambiente non esistono MT5, MetaEditor né lo
> Strategy Tester. **L'EA non è mai stato compilato da nessuno.**

---

## 1. ✅ L'AUDIT — i cinque difetti del mandato, uno per uno

Riga per riga su `mql5/Experts/ABTG_FvgRetest.mq5`, confrontato col sorgente
d'autore.

### 🟢 Difetto 1 — `InpLotMode = LOT_FIXED` di default, lotto 0,10

| | |
|---|---|
| **d'autore** | `InpLotMode = LOT_FIXED`, `InpFixedLot = 0.10` (righe 123-124) |
| **richiesta** | "pinna il default su `LOT_RISK`" |
| **come è in casa** | **il lotto fisso NON ESISTE PIÙ**: non c'è nessun `InpLotMode`. C'è **solo** `InpRiskPercent = 1.0` (riga 218) e `LotByRisk()` (riga 1161) |
| **verdetto** | ✅ **RISOLTO, e più a fondo della richiesta.** Non si pinna un default: la strada del lotto fisso è stata **tolta**, quindi non può essere riaperta per sbaglio dall'ottimizzatore |

`LotByRisk()` usa **`OrderCalcProfit()`** come via principale (riga 1169) e il
`tickValue/tickSize` **solo come ripiego** (righe 1173-1176) — più robusto della
formula d'autore, che usava sempre e solo il ripiego.

### 🟢 Difetto 2 — nessun `OnTester()` (il driver rifiuta di partire)

| | |
|---|---|
| **d'autore** | zero occorrenze in 949 righe |
| **come è in casa** | `double OnTester()` **riga 1443**, `OnTesterInit()` **1463**, `OnTesterDeinit()` **1465**, `ExportTrades()` **1415** |
| **verdetto** | ✅ **RISOLTO, ed è l'OPTFRAME standard di casa** |

Ho verificato **cosa si usa già altrove** invece di inventare: è lo stesso
blocco di `ABTG_AtrExhaustVol.mq5` (righe 1090-1142), **identico riga per riga**.
Restituisce il **Recovery Factor** come criterio (`stats[3]`) e scrive un CSV a
**undici colonne**:

```
Pass,Profit,Expected Payoff,Profit Factor,Recovery Factor,Sharpe Ratio,
Equity DD %,Trades,Peggior Giornata %,Perdite Consecutive Max,
Serie Perdente Peggiore
```

🎯 **E questo risponde direttamente al PASSO 0 del mandato:** la colonna
**`Trades`** è il conta-operazioni, e la colonna **`Peggior Giornata %`**
(alimentata da `gWorstDayPct`, aggiornata a ogni tick in `AggiornaPeggiorGiornata()`,
riga 1102) è quella che a **R110 mancava** su tutti e quattro gli EA. **Non
serve costruire tooling nuovo.**

Il gate del driver generico è `$src -notmatch 'double\s+OnTester\s*\('`
(`walkforward_generico.ps1`, righe **157-158**, cercare il marcatore
`NON esporta i risultati`): la firma `double OnTester()` **matcha**.

### 🟢 Difetto 3 — pavimento SL assente (il difetto R109)

| | |
|---|---|
| **d'autore** | solo `stopLevel + spread` del broker (righe 413-430) |
| **richiesta** | "un `InpMinSLPts` vero, riusa la convenzione se esiste" |
| **come è in casa** | **DUE pavimenti, e vale il più largo** |

Ho cercato la convenzione prima di scrivere: `InpMinSLPts` esiste già in
`ABTG_AtrExhaustVol.mq5` (l'EA di R109, cioè quello che è **morto** di questo
difetto). Qui c'è **quello e uno in ATR**:

```
riga 191   InpMinSLAtr = 0.50   // PAVIMENTO in ATR - ATTIVO di default
riga 192   InpMinSLPts = 0      // PAVIMENTO in punti MT5 (0 = spento)
riga 406   PavimentoSL_Calc()   // ALLARGA lo stop, non salta il trade
righe 925-927  pavimento = MathMax(dei due), poi applicato
righe 471-476  OnInit RIFIUTA DI PARTIRE: modo STRUTT senza pavimento -> INIT_FAILED
```

✅ **Verdetto: RISOLTO oltre la richiesta.** Il pavimento in **ATR** si scala da
solo fra DAX, Nasdaq ed EURUSD, dove uno in punti fissi no — ed è **acceso di
default**. Col SL d'autore (1,5×ATR) è **inerte** (0,50 < 1,50): non sposta la
cella d'autore, morde solo dove lo stop può collassare. E `OnInit` che **si
rifiuta di partire** è più forte di un input: il difetto R109 **non è
riproducibile** in modo STRUTT.

### 🟢 Difetto 4 — la corsa fra `UpdateFillStatus` e `CheckFVGEntries`

| | |
|---|---|
| **d'autore** | riga 256 legge `rates[ratesTotal-1]` (barra **viva**), riga 313 legge `rates[ratesTotal-2]` (barra **chiusa**) → un gap toccato in apertura muore **prima** che l'ingresso lo veda, segnale perso in silenzio |
| **richiesta** | "unifica entrambe le funzioni sulla barra CHIUSA" |
| **come è in casa** | **unificato, e per ORDINE oltre che per indice** |

`OnNewBar()` (righe 573-587) è documentato proprio come la correzione del
difetto n.4:

```
1. campione della taglia      (barra [1])
2. RilevaFvgNuovo()           (barra [1])
3. CercaIngresso()            <- LA DECISIONE, letta sulla barra [1]
4. AggiornaMitigazione()      <- SOLO ADESSO lo stato dei gap
5. PurgaFvg()
```

✅ **Verdetto: RISOLTO.** Non solo tutte e due le funzioni leggono la barra
chiusa: **la decisione viene PRIMA dell'aggiornamento di stato**, che è la
correzione vera. Invertire l'ordine ricreerebbe la corsa anche leggendo l'indice
giusto. E `OnTick()` (riga 543) fa `if(!IsNewBar()) return;` prima di ogni
decisione: **niente decisioni intrabarra**.

### ⚠️ Difetto 5 — `priceInZone` troppo generoso → da parametrizzare

| | |
|---|---|
| **d'autore** | `lastBar.low >= lower - (upper-lower)` (righe 330-331): accetta un tocco fino a **un'intera altezza di gap SOTTO** la zona |
| **richiesta** | "`InpZoneToleranceMult`, **default 1.0 = comportamento attuale invariato**" |
| **come è in casa** | ❌ **NON è quel parametro.** È una parametrizzazione **diversa e più stretta**, e **cambia il default** |

Al posto della tolleranza *sotto* la zona, il file di casa mette una **finestra
di mitigazione**, in **percentuale dell'altezza del vuoto** (specifica P3):

```
riga 172   InpMinMitigPct = 5.0     // quanto DENTRO il vuoto deve essere entrato
riga 173   InpMaxMitigPct = 100.0   // (100 = inerte)
riga 350   Mitigazione_Calc()       // 0 = tocca il bordo, 100 = bordo opposto
riga 364   FinestraMitig_Calc()
```

🔴 **QUESTO È UNO SCOSTAMENTO DAL MANDATO E VA DICHIARATO, non nascosto.**
Il mandato voleva un parametro **neutro al default**; qui il default **è più
severo dell'autore**: dove lui accettava un tocco *sotto* la zona, qui bisogna
essere **almeno il 5% DENTRO** il vuoto. La conseguenza attesa è **meno
operazioni** della cella d'autore.

**Perché lo lascio così invece di riportarlo a neutro** — e la ragione è la
domanda del PASSO 0, non l'eleganza: la scelta d'autore non è una tolleranza, è
**un'altra definizione di "il prezzo è tornato nel vuoto"**. La versione di casa
risponde alla domanda che il dossier pone (_"si compra sul BORDO del vuoto o
DENTRO il vuoto?"_) con **due manopole falsificabili in griglia**. Riportarla a
neutro renderebbe il segnale più largo **e la domanda non misurabile**.
👉 **Chi vuole la fedeltà al Code Base mette `InpMinMitigPct = 0` e lo dichiara.**
**Il numero di operazioni delle due varianti NON è stato misurato da nessuno.**

---

## 2. ⚠️ IL FILTRO DIMENSIONE — risolto, ma **non in ATR**

| | |
|---|---|
| **d'autore** | `InpMinGapPoints = 10` × `_Point` (riga 170) → su un indice dove 1 punto indice = 100 punti MT5 vale **0,1 punti indice**: **il filtro è di fatto spento** |
| **richiesta** | "riscrivilo in **ATR**, tipo `InpMinGapATRMult`, default 0.1-0.2 da stimare" |
| **come è in casa** | **percentile mobile**, non ATR |

```
riga 162   InpGapMode        = GAP_PERCENTILE   (alternativa: GAP_PUNTI)
riga 163   InpGapPctOfMax    = 10.0    // gap >= X% del gap MASSIMO della finestra
riga 164   InpGapPctLookback = 1000    // barre della finestra
riga 165   InpMinGapPts      = 10      // la soglia d'autore, SOPRAVVIVE come alternativa
riga 333   TagliaPercentile_Calc()
```

🔴 **Secondo scostamento dal mandato, dichiarato.** Non è ATR: è la soglia a
**percentile mobile** del candidato **P3** (`Order Block Volumatic FVG Strategy`
di TagsTrading/BigBeluga). **La ragione è del dossier stesso**, che su quel
pezzo scrive: _"La soglia non è una costante: è un percentile mobile… Si ritara
da sola fra DAX e EURUSD… è l'antidoto esatto al difetto n.1 di P1. **Questo
pezzo va copiato.**"_

✅ **Il difetto che il mandato voleva eliminato È eliminato**: la soglia non è
più una costante assoluta confrontata con una grandezza che cambia scala per
simbolo. Sia l'ATR sia il percentile lo risolvono; è stato scelto il secondo, e
**il primo non è implementato**. Se serve il confronto ATR contro percentile, è
un **braccio di ablazione da aggiungere**, non un difetto residuo.

⚠️ **E il default `InpGapPctOfMax = 10` non è misurato**: è il valore del Pine di
P3. **È esattamente la manopola che il PASSO 0 dice di girare** se le operazioni
escono troppe (esito C).

---

## 3. ✅ IL REGIME FILTER — default già a `REGIME_NONE`

| | |
|---|---|
| **d'autore** | `InpRegimeFilter = REGIME_BOTH` (EMA 50/200 su H4 **+** ADX ≥ 20) = lo schema che in casa fa **0 successi su 5** (`ROBUSTEZZA.md` §5B) |
| **richiesta** | "verifica che l'enum esista e porta il default a `REGIME_NONE`" |
| **come è in casa** | ✅ **l'enum esiste** (`ENUM_FVG_REGIME`, riga 143: `REG_NONE=0, REG_EMA=1, REG_ADX=2, REG_BOTH=3`) e il default **è già `REG_NONE`** (riga 178) |

Il nome è `REG_NONE`, non `REGIME_NONE`: il valore numerico è **0**, ed è quello
che finisce nell'`.ini`. Il file prova lo scrive **esplicito** (`InpRegimeMode=0`)
non per cambiarlo, ma perché la baseline dichiarata dev'essere **verificabile
nell'artefatto**, non dedotta.

➕ **Uno scostamento in più, dichiarato dall'autore dell'adattamento** (righe
842-843): l'autore leggeva EMA e ADX allo **shift 0** (barra viva); qui si legge
lo **shift 1** (barra chiusa), regola di casa.

---

## 4. ✅ COSA È RIMASTO INTATTO — il motore, come chiedeva il dossier

| pezzo | dove | stato |
|---|---|---|
| rilevazione FVG a **tre barre**, confronto **stretto** | `FvgRialzista_Calc` 296, `FvgRibassista_Calc` 304 | 🟢 **intatto**, definizione geometrica pura dell'autore |
| esclusione della **barra in formazione** dallo scan | `RilevaFvgNuovo` 695 | 🟢 intatto |
| struttura del gap con `isFilled` / `isTraded` | `struct FvgZona` 243 (`morto` / `tradato`) | 🟢 intatto, **un gap = un solo ingresso** |
| ingresso sul **ritorno** con **candela di conferma** | `Conferma_Calc` 390, `InpConfirmCandle` 175 | 🟢 intatto |
| **SL/TP veri al broker** in ATR | `Enter` 898, `gTrade.Buy/Sell` 961 | 🟢 intatto |
| **parziale 50% / breakeven / trailing** in ATR | `ManageAll` 996, input 197-203 | 🟢 **presenti**, ma **SPENTI di default** ⚠️ |
| **guardie DD** giornaliero 5% / totale 10% | `MuroDrawdown` 1123, input 214-215 | 🟢 **presenti**, ma **SPENTE di default** ⚠️ |

⚠️ **Le due righe con l'asterisco sono scostamenti dal Code Base, e sono
VOLUTI** (`FVG_TESI.md` §4.7 e §4.9), non dimenticanze:

- **gestione spenta** (`InpTP1Pct=0`, `InpBEAtrTrigger=0`, `InpUseTrailAtr=false`):
  con tre strati di gestione accesi **la mediana del take LORDO non esiste**, e
  quella mediana **è il cancello C2**, cioè la seconda misura del PASSO 0. In più
  una cella con tre strati accesi **non è ablabile**.
- **muri DD spenti in backtest**: un muro **nasconde il rischio che il round deve
  misurare**. R109 con un muro al 10% avrebbe scritto *"DD 10%"* invece del
  **56%** vero.

➕ **E un cap che l'autore non ha**: `InpMaxTradesPerDay = 3` (riga 206, criterio
C6). Motivo specifico di questo motore: _"gli FVG nascono in grappoli sulle
giornate di spinta"_ = **stop correlati nella stessa seduta**.

---

## 5. 🔍 DUE RILIEVI NUOVI — trovati leggendo, non nel mandato

Nessuno dei due blocca il PASSO 0. Vanno agli atti perché **cambiano come si
leggono i numeri**.

### 🟠 5.1 — `LotByRisk()` è asimmetrico: avvisa quando taglia in alto, **tace quando alza in basso**

```
righe 1185-1190   lotto oltre SYMBOL_VOLUME_MAX -> Log("ATTENZIONE: ... rischia
                  MENO dell'1% richiesto (lezione R109)")   <- AVVISA
riga  1191        if(lot<mn) lot = mn;                      <- NON avvisa
```

Se il lotto per rischio cade **sotto** `SYMBOL_VOLUME_MIN`, viene alzato al
minimo **in silenzio**: quel trade rischia **PIÙ** di `InpRiskPercent`, e il
drawtown misurato **sovrastima** quello che si otterrebbe scalando il rischio.
È lo **specchio esatto** del difetto R109, sull'altro lato — e il lato che
avvisa è già stato scritto, quindi l'asimmetria è probabilmente una svista.

🛡️ **Mitigazione già applicata, senza toccare il codice:** il PASSO 0 gira con
**`-Deposito 100000`** (taglia prop, come R101/R107/R110). Più alto è il
deposito, meno probabile è che il lotto per rischio finisca sotto il minimo.
**Non è una prova che il caso non si presenti**: se i numeri sembreranno strani,
è il primo posto dove guardare.

### 🟠 5.2 — l'export per-trade **si sovrascrive fra IS e OOS**

```
riga 1418   fn = "abtg_trades_" + <programma> + "_" + <simbolo> + "_" + <magic> + ".csv"
```

Il nome porta il **magic**, non la **finestra**. Le due gambe IS e OOS dello
stesso magic scrivono **lo stesso file**: quello che resta a disco è **l'ultima
girata (OOS)**. Il commento nel sorgente (righe 1412-1413) avvisa del caso
griglia, **non di questo**.

👉 **Conseguenza pratica:** la **mediana del take LORDO** del cancello C2 si può
calcolare **solo sull'OOS**, salvo rilanciare le finestre separatamente. È
scritto nel referto che la riga di lancio produce.

---

## 6. 📦 GLI ARTEFATTI PREPARATI — quello che mancava davvero

| file | cosa fa |
|---|---|
| `backtest_pipeline/prove/ABTG_FvgRetest.txt` | **cella `00_nudo`** — motore nudo, due lati insieme. È il nome che il driver generico prende **da solo** con `-Expert ABTG_FvgRetest` |
| `backtest_pipeline/prove/PASSO0_FVGRET_01_long.txt` | **cella `01_long`** — solo long |
| `backtest_pipeline/prove/PASSO0_FVGRET_02_short.txt` | **cella `02_short`** — solo short |
| `backtest_pipeline/righe/RIGA_PASSO0_FVGRET.ps1` | il driver della corsa (marcatore `MARCATORE_RIGA_PASSO0_FVGRET_v1`) |
| `backtest_pipeline/righe/RIGA_PASSO0_FVGRET_DA_MANDARE.md` | **la pagina con la riga di lancio** |

### Perché **tre** celle e non una

**Regola dei DUE LATI** (Claudio, 25/08): *"ogni analisi misura SEMPRE tutti e
due i lati"*. E il dossier stima la frequenza **per lato**: senza le celle 01 e
02 quel numero non è misurabile.

⚠️ **`n(01_long) + n(02_short)` NON farà `n(00_nudo)`** — e non è un guasto.
**Misurato nel sorgente:** `IngressiAmmessi()` (riga 594) esce con
`if(CountPositions()>0) return(false)` **prima** di guardare il lato, e
`CercaIngresso()` (riga 831) fa `return` dopo la prima decisione della barra.
Con un lato spento **lo slot resta libero**.

### I file prova elencano **solo ciò che devia**, ed è voluto

`prove/LEGGIMI.md`: *"Tutto il resto degli input dell'EA viene pinnato
automaticamente al suo default, letto dal `.mq5`"*. **Non ho trascritto i 40+
input a mano**: una riga ricopiata storta è un EA che non esiste. Le uniche
righe scritte sono **la baseline dichiarata** (`InpRegimeMode=0`,
`InpEntryMode=0` — che valgono già il default, ma devono essere verificabili
nell'`.ini`), **i due lati** e **l'asse `InpMagic`**.

### I magic

**Sei numeri vergini** del blocco `776xxx`, cercati uno per uno in tutto il repo
il 28/08 → **zero occorrenze**: `776000/776001`, `776100/776101`,
`776400/776401`. Il magic del **sorgente** (`775501`) è nella lista dei
**vietati** dentro il driver.
⚠️ Il blocco `7762xx` è stato **scartato perché NON vergine** (776200 e 776201
risultano già nel repo): il salto è **voluto, non un refuso**.

---

## 7. 🧪 COSA È STATO VERIFICATO ESEGUENDO

- ✅ `RIGA_PASSO0_FVGRET.ps1` **parsa**: `pwsh` + `[Parser]::ParseFile` →
  **0 errori, 4.592 token**; **ASCII puro** su tutti e quattro i file nuovi
  (0 caratteri non-ASCII — regola del 17/08);
- ⚠️ **CORRETTO dal verificatore-stringhe (28/08): l'audit "zero collisioni"
  era FALSO.** Trovata `$Celle`/`$CELLE` (stessa variabile in PowerShell,
  case-insensitive — il difetto arrivato fino al PC di Claudio, punto 79)
  — innocua per caso in questa versione ma rimossa comunque, l'inizializzazione
  morta dava un falso senso di sicurezza. Restava vera la coppia trovata prima:
  aveva **`$R`** (l'ArrayList del referto) contro
  **`$r`** (tre cicli), **la stessa coppia del difetto di R109**, rinominata
  `$RefTxt`; e usava **`$args`**, che è una **variabile automatica** di
  PowerShell, rinominata `$argv`;
- ✅ **i gate girano DAVVERO sui tre file prova veri**: controllo positivo
  passato (3 celle, 6 magic unici);
- ✅ **e sono stati fatti FALLIRE uno per uno — nove prove, nove fermate**, ognuna
  col messaggio giusto: file dei lati **scambiati**, baseline mossa, magic
  **vietato**, magic **duplicato**, **secondo asse Y**, `@PERIODO` M15→M5 (la
  trappola R102), una **riga in più** non dichiarata, **parametro doppio**, e la
  **corruzione SIMMETRICA** su tutte e tre le celle (quella che il gate della
  stella **non può vedere**, e che qui prende il gate della **baseline**);
- ✅ **la ricetta del pin provata su una copia della pagina**: 5 segnaposto →
  **3 punti d'uso + riquadro + titolo**, **0 residui**. Il pin è poi stato
  **inserito davvero** (`71bbd200…`) e **verificato contenere tutti e sette gli
  artefatti** che lo script scarica, `ABTG_FvgRetest.mq5` compreso;
- ✅ **e anche la ricetta di RI-pinnatura provata su una copia**, con dentro una
  **riga di storia** costruita apposta (*"il pin X è BRUCIATO"*): i **3 punti
  d'uso** cambiano, **la riga di storia resta intatta** — che è il motivo per cui
  il pin vecchio si legge dai punti d'uso e mai con un `grep` largo;
- ✅ verificato che il gate `OnTester` del driver generico
  (`'double\s+OnTester\s*\('`, riga 158) **matcha** la firma dell'EA;
- ✅ verificato che il driver generico **sa risolvere gli enum custom** del
  sorgente (riga 182: `(?s)enum\s+(\w+)\s*\{(.*?)\}`), quindi
  `GAP_PERCENTILE`, `REG_NONE`, `ENTRY_RITORNO`, `SL_ATR`, `TP_ATR` vengono
  blindati al valore giusto invece di finire fra i "non risolti";
- 🔎 **e un buco vero trovato così:** `walkforward_generico.ps1` **NON installa**
  `ABTG_PausaGuardian.mqh` (la stringa non compare nel driver), ma
  `ABTG_FvgRetest.mq5` lo `#include`. Senza quel file **la compilazione fallisce**
  e il driver generico muore con *"compilazione fallita"* **senza dire perché**.
  👉 La riga di lancio adesso **scarica l'include al pin e lo installa** in
  `MQL5\Include` prima di compilare.

🟡 **NON verificato, e va detto forte:** tutto ciò che richiede **MT5** — la
**compilazione dell'EA** (non c'è MetaEditor qui, e **nessuno l'ha mai
compilato**), il comportamento del tester, la durata, e **ogni singolo numero**.
Se MetaEditor si lamenta, **quello è il risultato del PASSO 0** e va riportato
così com'è.

---

## 8. 🚀 LA RIGA DI LANCIO

La pagina completa — con il pin, il giro a vuoto, la corsa vera, le riprese e
cosa guardare nel referto — è:

### 👉 `backtest_pipeline/righe/RIGA_PASSO0_FVGRET_DA_MANDARE.md`

Il pin è **già inserito** in quella pagina — `71bbd2002d42ad75c7404a4d3a39082e7d367d70`,
verificato contenere **tutti e sette** gli artefatti che lo script scarica.
In sintesi, **prima il giro a vuoto** (non apre MT5):

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='71bbd2002d42ad75c7404a4d3a39082e7d367d70'; $p="$env:USERPROFILE\RIGA_PASSO0_FVGRET.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_PASSO0_FVGRET.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_PASSO0_FVGRET_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera.' -ForegroundColor Red } }
```

e **poi la corsa vera**, che è lo stesso blocco **senza `-SoloControllo`**.
Risultati: cartella + **zip** sul Desktop (`PASSO0_FVGRET_<MODO>_<data>_<ora>`)
con `REFERTO_PASSO0_FVGRET.txt`, i file prova girati e i sei CSV.

---

## 9. 🔴 LE QUATTRO COSE CHE QUESTO PASSO 0 **NON** DIRÀ

1. **Non promuove e non boccia niente.** È un **conta-operazioni**. Il PF che
   esce **si legge, non si giudica**: niente criteri firmati, niente ablazione.
2. **Non misura il regime EMA/ADX** né gli altri bracci (`ENTRY_FORMAZIONE`,
   `GAP_PUNTI`, l'età minima, la gestione accesa). Sono **gradini di ablazione
   del round vero**, e partono spenti apposta.
3. **Non chiude la domanda sul lato short.** La finestra è **21 mesi di indici
   che salgono** (criterio C6, un solo regime): lo short parte svantaggiato **per
   regime**, non per merito del motore.
4. **Non dà il cancello C2.** La mediana del take LORDO si legge nell'export
   per-trade, e su **D30EUR il rapporto punti MT5 / punti indice NON è agli
   atti** (R97 lo ha misurato su U30USD e NASUSD, non sul DAX). **[DA
   VERIFICARE sul simbolo prima di convertire qualunque cosa.]**

---

### 📎 Attribuzioni obbligatorie (nessuna licenza dichiarata sul Code Base)

- **Adiec7 / "KSQuantitative — KSQuants"** — `KSQ Fair Value Gap EA`, MQL5 Code
  Base **71467**. ⚠️ Nessuna licenza dichiarata → **uso interno di ricerca**.
- **TagsTrading** e **BigBeluga** — `Order Block Volumatic FVG Strategy` /
  `Volumatic Fair Value Gaps` (TradingView `PjH7wg3n`), **CC BY-NC-SA 4.0**,
  da cui vengono le tre manopole di definizione. **NC = non commerciale.**
