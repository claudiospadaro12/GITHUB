# 📐 A4 — LA FIRMA SULLA GEOMETRIA DELLO STOP: il numero del piano è SBAGLIATO

> Azione **A4** del piano, dichiarata **Δ +1 sedia** e **−4,04 punti di DD**.
> **Sola lettura**: nessun round lanciato, nessun preset toccato, niente sul
> conto reale. La firma resta di Claudio: qui c'è la **misura**, non la scelta.
>
> 🔴 **Esito: il "−4,04" non regge, e il confronto su cui poggia non è fra due
> celle gemelle. Ma la conclusione operativa NON è "lasciar perdere": è che la
> ragione vera del +1 sedia è un'ALTRA, ed è più solida di quella scritta.**

---

## 1. 🔧 Che cos'è la scelta, in una riga

`ABTG_ORB_Ottimizzato.mq5` r.121 · geometria a r.627-638:

| modo | dove finisce lo stop (long) | distanza |
|---|---|---|
| **OPPRANGE (0)** | l'estremo **opposto** del range | `range + 10 punti` |
| **HALFRANGE (3)** | metà ampiezza sotto l'ingresso | `0,5 × range` |

👉 **OPPRANGE è ~2,2× più largo.** E siccome il lotto è `rischio / distanza
stop` (r.1070), **a parità di `InpRiskPercent` OPPRANGE porta circa METÀ del
nozionale.** Questa riga spiega tutto il resto.

**Cosa gira oggi**, confermato su tutti e due i preset: `InpSLMode=3`
(HALFRANGE) — challenge a **0,3%**, reale a **0,65%** (solo letto).

---

## 2. 📊 I DUE GEMELLI VERI — verificati da me al byte

Fonte unica: `risultati_archivio/r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`
(48 passate/finestra, tick reali, deposito 100.000, rischio **1,0%**).

| | **HALFRANGE (3)** — la cella VIVA | **OPPRANGE (0)** |
|---|---:|---:|
| **Profit OOS** | **41.057,00** | **18.921,52** *(−53,9%)* |
| **PF OOS** | 1,67419 | 1,68012 *(+0,35%)* |
| **DD OOS** | **9,7623%** | **4,2956%** |
| **n OOS** | 119 | 119 |
| **Profit IS** | **+9.509,39** | 🔴 **−738,45** |
| **PF IS** | **1,24979** | 🔴 **0,96232** |
| n IS | 71 | 71 |

### 🧪 IL CONTRO-ESEMPIO — due rotture, e la seconda ribalta la lettura

**(a) `Trades` regge**: 119 in **tutte e 48** le passate OOS, 71 in tutte le IS.
E sono **posizioni**, non deal (`InpTP1Pct=0` ovunque → fattore 1,000). Lo stop
non decide **se** si entra.
🟢 *Conferma laterale*: i lotti variano di oltre 2× fra i due rami e il conteggio
**non si muove di un'unità** — se ci fosse spezzettamento dei fill si vedrebbe.

**(b) Il profitto NON regge, ed è il punto.** Rapporti:
`profitto HALF/OPP = 2,1699` · `DD HALF/OPP = 2,2726` · `PF: +0,35%`.
> 👉 Stessi trade, stesso n, PF invariato, profitto e DD giù **dello stesso
> fattore ~2,2**. **Questo non è un miglioramento: è una DELEVERAGE.** Profitto
> e DD **sono la stessa cosa contata due volte**, sul lato ricavi e sul lato
> rischio. Dimezzare il rischio si può fare **anche senza toccare la
> geometria**: basta la taglia.

**(c) Ma NON è solo deleverage — e questo il piano non lo dice.** Se lo fosse,
il PF sarebbe uguale anche in IS. 🔴 **Non lo è: in campione OPPRANGE PERDE**
(PF 0,962, profitto **−738,45**). Le due geometrie **differiscono davvero**, e
nella finestra IS differiscono **a sfavore di OPPRANGE**.

---

## 3. 🔴 LE DUE CELLE DEL PIANO NON SONO GEMELLE

Il **3,840** del piano è la passata **16**, che ha
`InpSLMode=0` **+ `InpSLBufferPts=500`** **+ `InpTPMode=0`** **+ `InpTP_R=1.5`**:
**QUATTRO input diversi dalla cella viva, non uno.** Il piano lo scrive come
*"OPPRANGE invece di HALFRANGE"*, cioè come una manopola sola.

### 🎯 E la prova che quel 3,840 è un PICCO, non un altopiano
Le passate con `SLMode=0 + buf=500 + TPMode=0` nel CSV sono **due**, e
differiscono **solo per `InpTP_R`**:

| Pass | `InpTP_R` | Profit | PF | **DD** |
|---:|---:|---:|---:|---:|
| **16** | **1,5** | 23.003,35 | 1,83850 | **3,8395** |
| 20 | 2,0 | 23.457,58 | 1,83754 | **5,5805** |

> 🔴 **Cambiando SOLO `InpTP_R` da 1,5 a 2,0 il DD passa da 3,84 a 5,58: +45%
> su una manopola sola.** Il vicino immediato su un altro asse è **la metà
> peggio**. Questa non è una cella robusta: è **il punto più fortunato di una
> griglia**, ed è esattamente la cella che la regola di casa vieta di scegliere
> (*centro dell'altopiano, MAI il picco*).

---

## 4. 🧮 IL VERDETTO SUL "−4,04": da correggere su TRE livelli

1. **L'aritmetica non torna**: `9,7623 − 3,840 = **5,9223**`, non 4,04.
   Il 4,04 è **un'altra grandezza** (un delta di portafoglio a 0,65%) incollata
   dentro una parentesi che dice *"@1%"*. **Due unità nella stessa parentesi.**
2. **Il numero d'arrivo è DERIVATO, non misurato**: il 2,50 a 0,65% è
   `3,840 × 0,65` — un **riscalaggio lineare** — mentre lo stesso archivio
   misura che il DD **non si riscala linearmente** (+3,0% di scarto).
3. **Il numero onesto a UNA manopola è −5,47 punti @1%** (9,7623 → 4,2956) —
   **più grande** del 4,04 — **ma va detto insieme al −53,9% di profitto**,
   perché è lo stesso fatto.

---

## 5. 🚦 E LA DOMANDA CHE DECIDE: passa i cancelli firmati?

I cancelli sono quelli che **Claudio ha firmato il 19/08 a numeri mai visti**
(`R88_CRITERI.md`, *"FIRMO R88"*).

| cancello | VIVA HALFRANGE | gemello OPPRANGE | cella del piano |
|---|:--:|:--:|:--:|
| DD OOS ≤ 7,00% | ❌ 9,76 | ✅ 4,30 | ✅ 3,84 |
| PF OOS ≥ 1,40 | ✅ | ✅ | ✅ |
| **profit IS > 0** | ✅ | 🔴 **−738** | ✅ |
| **PF IS ≥ 1,10** | ✅ 1,250 | 🔴 **0,962** | 🔴 **1,063** |
| **scarto secco (IS negativo)** | — | 🔴 **BOCCIATA** | — |

> ## 🔴 **Nessuna delle due varianti OPPRANGE passa i cancelli firmati.**

### 🎯 E la cosa che chiude il discorso: era PREDETTA, per nome, PRIMA di girare
`R88_CRITERI.md`, scritto **prima** delle passate:
> *"È la trappola già vista, non un'ipotesi: R15 aveva OPPRANGE a OOS PF 1,68,
> DD 4,1% e lo scartò perché 'lì l'IS è rosso o piatto'. **Se R88a ritrova
> quella cella con l'IS ancora rosso, A3 la boccia di nuovo — e stavolta il no
> è scritto prima.**"*

**R88a l'ha ritrovata identica**: OOS PF **1,680**, DD **4,296**, IS **rosso**.
👉 **Terza occorrenza dello stesso pattern.** Il criterio aveva previsto il
proprio caso limite e ha tenuto.

---

## 6. 💡 MA IL "+1 SEDIA" HA UNA RAGIONE VERA — ed è un'ALTRA

🔑 **Non è il DD. È il CANCELLO DEL COSTO.**

| | rapporto `stop / spread` |
|---|---:|
| **HALFRANGE** (quello che gira) | **29,5×** 🔴 *sotto il pavimento di 40×* |
| **OPPRANGE** | **~64,0×** ✅ *e 42,7× anche al P95* |

👉 **Questo è l'unico cancello che OPPRANGE passa e HALFRANGE no**, ed è la
ragione vera per cui quella firma varrebbe una sedia. Il piano la attribuisce
al DD; **il DD è l'argomento debole, il costo è quello forte.**

---

## 7. ✍️ COSA MANCA PER FIRMARE — e non è poco

1. 🔴 **Quale OPPRANGE**: i candidati sono **due**, con esiti di cancello
   diversi, e vanno nominati con **tutti e quattro** gli input.
2. 🔴 **Una DEROGA esplicita al cancello IS**, con la sua data. Senza, i numeri
   dicono **no**. E disapplicarlo ora è precisamente la mossa che
   `R88_CRITERI` vieta: *"i criteri si cambiano prima dei numeri, non dopo"*.
3. 🔴 **`[CSV ASSENTE]`**: **nessuna corsa OPPRANGE a 0,65% né a 0,30%** — cioè
   alle taglie vere. Il DD che finirebbe nel contratto **non è misurato**.
4. ⚠️ R88a girava la **v1.02**; il repo è alla **v1.04**. Differenza dichiarata,
   **non misurata**.
5. ⚠️ **Un solo regime** e **n < 150 in tutte e due le finestre**: il **merito**
   è sospeso (Emendamento C). Il **rischio** invece si legge a qualunque n
   (Emendamento B), e **9,76 contro 4,30 è accaduto**.

---

## 🧭 IN UNA RIGA
**A4 non è "firma questo e guadagni 4 punti di DD".** È: *"la sedia che gira ha
uno stop troppo stretto per il costo (29,5× contro 40×); la geometria che
risolve il costo è bocciata dai cancelli firmati in campione; e il numero
scritto nel piano è sbagliato di aritmetica e di unità."*
👉 **Resta una decisione vera, non una formalità** — e adesso ha i numeri veri
sotto.

*Misura prodotta dall'agente `cercatore-parametri`. I quattro numeri che
decidono — i due gemelli, l'IS negativo, l'aritmetica del 4,04 e il salto del
DD su `InpTP_R` — li ho riverificati io sui CSV primari.*
