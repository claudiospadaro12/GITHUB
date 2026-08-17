# ⚖️ R71 — CON n SOPRA SOGLIA LA RISPOSTA CAMBIA: **la finestra recente NON sceglie meglio**

_Chiude la domanda 2 che R70 aveva **sospeso** per campione insufficiente.
E la prima cosa che deve fare è **correggere R70**._

**Banco:** griglia **identica carattere per carattere** a R68/R69/R70 (28 celle),
**OHLC**, deposito 100.000, rischio 1%, `SLfromDoji` pinnato a 0.
**IS `2016.01.01 → 2021.03.31`** (5,25 anni) · **OOS `2021.04.01 → 2026.06.30`** (5,25 anni),
`-FrazioneIS 0.5`. **Igiene: 4 CSV su 4, 28 celle su 28, cancelli verificati nei
quattro `.ini`.**

### ✅ Il criterio 0 adesso passa — era lui il motivo del round

| | n IS misurato | soglia 150 |
|---|---:|---:|
| GBPUSD | **190 → 256** | ✅ |
| USDJPY | **152 → 253** | ✅ |

---

## 1. ✍️ PRIMA DI TUTTO: **CORREGGO R70**

In R70 §2 avevo scritto che la finestra recente cattura **97,3% e 61,1%**
dell'ottimo OOS contro **51,5% e 54,5%** della vecchia. **Quei numeri usavano la
cella MIGLIORE dell'IS — cioè il PICCO. E il criterio 1 di casa dice
letteralmente _"centro dell'altopiano, MAI il picco"_.**

Rifatto con la regola giusta, meccanica e identica su tutti i round (le tre
righe di buffer col miglior profitto medio IS → si prende **quella di mezzo**):

| round | IS | simbolo | n IS | **picco** (vietato) | **centro altopiano** (regola di casa) |
|---|---|---|---:|---:|---:|
| R69 | 2010-2016 | USDJPY | 220-384 | 54,5% | **92,4%** |
| R70 | 2019-2022 | GBPUSD | 75-125 ❌ | 97,2% | **87,5%** |
| R70 | 2019-2022 | USDJPY | 95-159 ❌ | 61,1% | **71,9%** |
| **R71** | **2016-2021** | **GBPUSD** | **190-256 ✅** | 70,4% | **95,1%** |
| **R71** | **2016-2021** | **USDJPY** | **152-253 ✅** | 68,4% | **83,5%** |

> 🔴 **Il divario 51% → 97% che avevo mostrato a Claudio era un artefatto della
> regola di selezione, non un fatto sui dati. Con la regola che usiamo davvero,
> la finestra vecchia su USDJPY cattura 92,4% — cioè MEGLIO del 83,5% della
> finestra nuova.** Ritirato.

## 2. ⚖️ DOMANDA 2, RISPOSTA CON CAMPIONE PIENO: **NON DIMOSTRATO**

I due simboli **dicono il contrario l'uno dell'altro**:

| simbolo | IS vecchio | IS nuovo | chi sceglie meglio |
|---|---:|---:|---|
| **USDJPY** | **92,4%** (2010-2016) | 83,5% (2016-2021) | 🔵 **il VECCHIO** |
| **GBPUSD** | 57,7% (2010-2016) ⚠️ | **95,1%** (2016-2021) | 🟢 **il NUOVO** |

⚠️ Il 57,7% di GBPUSD viene dalle **tabelle del referto R68**, non dai CSV: i
CSV di R68 **non erano stati archiviati** (errore mio, da R69 in poi lo sono).
È quindi il dato più debole della tabella e non l'ho potuto ricalcolare con la
stessa regola meccanica.

> ### 🚦 **Un simbolo per parte. La domanda 2 si chiude con NON DIMOSTRATO — e si scrive così, non si sceglie il simbolo che dà ragione.**
>
> **Il beneficio di selezione della finestra recente — il punto A
> dell'emendamento — NON è supportato dalla misura.**

## 3. 🎯 MA LA PARTE DELL'EMENDAMENTO CHE REGGE, REGGE FORTISSIMO

### 🔴 L'IS è **0/28 su ENTRAMBI i simboli**, e l'OOS è **28/28 e 27/28**

| finestra IS | GBPUSD | USDJPY |
|---|---:|---:|
| 2010-2016 (R68/R69) | maggioranza positive | **0/28** |
| 2019-2022 (R70) | **3/28** | **0/28** |
| **2016-2021 (R71)** | **0/28** 🔴 | **0/28** 🔴 |
| **OOS 2021-2026** | **28/28** 🟢 | **27/28** 🟢 |

**Tre finestre IS diverse, due simboli, e il motore perde in tutte. Poi dal 2021
guadagna dappertutto.**

> ### 🎯 **NON È IL CALENDARIO. È IL 2021.** Prima: tassi zero, covid, laterale. Dopo: dollaro forte e tassi. Il motore vive di lì.
>
> **È la regola C dell'emendamento — _la prova di regime batte la storia
> contigua_ — e questo round è la sua dimostrazione più netta.** Allungare o
> accorciare la storia contigua non sposta niente: sposta tutto **quale
> regime** ci finisce dentro.

### 📉 E il buffer taglia il drawdown per la **QUINTA e SESTA volta**

**DD OOS (colonna TP 2,0):**

| buffer | 0 | 5 | 10 | 15 | 20 | 25 | 30 |
|---|---:|---:|---:|---:|---:|---:|---:|
| **GBPUSD** | 11,07 | 8,02 | 5,25 | 3,98 | 4,07 | **3,42** | 3,46 |
| **USDJPY** | 12,55 | 8,18 | 8,50 | 8,03 | 6,61 | 6,64 | **6,06** |

**Sei misure su sei, in tre finestre diverse, su due simboli: il drawdown scende
col buffer. Sempre.**

**Il profitto invece no**, e continua a spostarsi: qui il massimo OOS sta a
**`buffer 10`** su entrambi (+6.638 e +9.569), mentre in R70 stava a `buffer 0`
su USDJPY e in R69 a `buffer 15`. **Ottimo di rendimento instabile, ottimo di
rischio stabile.**

> **Regola B confermata di nuovo: il buffer è un parametro di RISCHIO
> affidabile e un parametro di RENDIMENTO inaffidabile.**

## 4. 🪑 `buffer 5`, la config viva: **SEI MISURE, SEI VOLTE MALE**

| round | simbolo | esito |
|---|---|---|
| R68 | GBPUSD 2010-2026 | 2ª peggior DD su 7 |
| R69 | USDJPY 2010-2026 | una delle 3 celle **OOS-negative** su 28 |
| R70 | GBPUSD 2019-2026 | DD 6,05% contro 2,88% |
| R70 | USDJPY 2019-2026 | **riga peggiore delle sette** |
| **R71** | **GBPUSD 2016-2026** | DD **8,02%** contro **3,42%**, profitto +4.452 contro +6.638 |
| **R71** | **USDJPY 2016-2026** | **riga peggiore delle sette** (+2.873 medio contro +6.950 di `buf 10`) |

🔴 **Sei su sei. `InpSLbufferPips = 5` non è mai finito bene da nessuna parte.**
**E non si tocca lo stesso**: criterio 3, serve un round **a tick reali** e la
parola di Claudio.

## 5. 📊 NOTA SULLE SPEARMAN — e va detta contro di noi

Su questa griglia le sei misure IS→OOS sono **tutte POSITIVE**
(R69 +0,239 · R70 +0,089 / +0,329 · R71 **+0,565** / +0,259), contro un
contatore di casa che dice 17 negative su 18 su tutte le altre griglie.

**Il motivo è che questo asse porta un effetto vero e monotono (il rischio), non
una taratura.** È la differenza fra un edge e un overfit, e qui sta dalla parte
giusta. **Ma va contato a parte, non sommato al contatore generale**: una griglia
con un asse fisico dentro non è confrontabile con una griglia di taratura.

---

## 6. 🚦 VERDETTO

> **1. ✍️ R70 §2 CORRETTO: il divario di selezione era un artefatto della regola
> del picco. Con la regola di casa la finestra vecchia non è peggiore.**
>
> **2. ⚖️ Domanda 2: NON DIMOSTRATA. Un simbolo per parte. Il punto A
> dell'emendamento non ha il supporto che sembrava avere.**
>
> **3. ✅ Il punto A resta valido PER L'ALTRA METÀ**: la soglia dei 150 trade.
> R70 con n=75-159 ha dato superficie frastagliata e stima gonfiata; R71 con
> n=190-256 dà un altopiano leggibile. **Dimensionare la finestra sui trade
> serve. Spostarla in avanti no.**
>
> **4. 🎯 Il punto C è dimostrato**: tre finestre IS, due simboli, sempre
> negativo — e sempre positivo dopo il 2021. **Conta il regime, non l'epoca.**
>
> **5. 📉 Il buffer taglia il DD in 6 misure su 6, e il valore vivo (5) è finito
> male in 6 su 6.**

## 7. ➡️ PROPOSTA DI EMENDAMENTO **ALL'EMENDAMENTO** (da congelare prima dei prossimi numeri)

Il punto A com'è scritto dice due cose. **Una è misurata, l'altra no:**

| | |
|---|---|
| ✅ **«dimensiona la finestra sulle OPERAZIONI (≥150), non sugli anni»** | **TIENE** — R70 vs R71 lo mostra |
| ❌ **«l'IS dev'essere la finestra più RECENTE»** | **NON DIMOSTRATO** — un simbolo per parte |

**Riscrittura proposta del punto A:**
> _L'IS si dimensiona sulle OPERAZIONI (≥150), non sugli anni. **Dove
> collocarla non è deciso: finché non c'è una misura che lo dica, si usa la
> finestra che lascia un OOS di almeno 150 trade e si DICHIARA quale
> regime contiene.**_

**E il seguito operativo, in ordine:**
1. ⏱️ **Tick reali** sulla cella `buf 25 / TP 3,0` (centro dell'altopiano su
   entrambi i simboli in R71, e sopravvive a tutte le finestre).
2. 🔧 **Buffer in multipli di ATR** (R69 §7) su copia `_Ottimizzato` — rende il
   parametro portabile e rende il Dow misurabile.
3. 🪑 **Solo dopo**, e solo con la parola di Claudio, `PTE` in forward.
