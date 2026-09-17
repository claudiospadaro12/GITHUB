# 📐 ATR DEL DAX SU M30/M15 — RICONCILIAZIONE DEI DUE NUMERI DI CASA
**Data: 2026-09-17 · sola lettura · zero costo macchina (tutti i dati erano già in repo)**

---

## 🎯 IL VERDETTO IN UNA RIGA

> 🟡 **SPIEGATO — il conflitto non esiste: i due numeri misuravano cose diverse, e
> NESSUNO dei due era un ATR M30 del DAX.** Il `~60` nasce da una cella la cui
> colonna si chiama **`stop`** e la cui geometria è uno **swing di 5 barre H4**
> (`1200 min = 5 × 240`): leggerla come «ATR H4 = 170» e scalarla a M30 confonde
> una **geometria di stop** con il **range di una barra**. Il `25-40` era
> `[DERIVATO]` (mai `[MISURATO]`) e poggiava su un **ADR troncato**.
>
> 🟢 **Il numero buono, ricavato e validato stasera:**
> **`ATR(14) D30EUR M30 = 36,4 – 41,4 punti indice` `[DERIVATO]`**
> **`ATR(14) D30EUR M15 = 25,7 – 29,2 punti indice` `[DERIVATO]`**
> ancorati a `ADR D30EUR = 252,2 idx` **`[MISURATO]` n=53 giornate**, con la legge
> √T **validata a −1%** sul solo simbolo dove un ATR misurato esiste (U30USD H1).

🔴 **Tag onesto: `[DERIVATO]`, non `[MISURATO]`.** Nessuno ha ancora letto
`iATR(14)` su barre M30 del DAX. Quello che è `[MISURATO]` è l'**ancora** (ADR) e
il **fattore di scala** (verificato contro un ATR misurato su un altro simbolo).
La via più corta alla misura diretta è al **§6**.

---

## 1. 🔬 I DUE NUMERI, VERIFICATI ALLA FONTE

| valore | fonte esatta | che cosa è DAVVERO |
|---|---|---|
| **25-40 idx** | `report/CACCIA_SABATO_2026-09-13.md` **r.464-465** | 🔴 **senza tag.** È un `[DERIVATO]` da `ADR × √(t/1440)`. Il `[MISURATO]` di r.461 copre gli **spread**, non l'ATR (classe 408) |
| **~60 idx** | catena da `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.406** (`~170 idx [INF]` su H4) → `170 × √(30/240) = 60,1` | 🔴 **non è un ATR.** Vedi §2 |

---

## 2. 🟢 PERCHÉ IL `~60` CADE — tre conferme indipendenti, tutte nella stessa riga

La riga r.406 è: `970912 · SupRev_DAX_H4_Ott · D30EUR · H4 · swing 5 barre H4 + 3 "pip"
· ~170 idx [INF] · scala: 186,5 × √(1200/1440)`.

1. 📋 **La colonna si chiama `stop`**, non `ATR`. L'intestazione della tabella
   (`CANCELLO_COSTO_FLOTTA_2026-09-10.md` **r.393**) è:
   `| sedia (magic) | EA | simb | TF | conto | geometria dello stop | stop | fonte del numero | spread | stop/spr | 40x? | 13,3x? |`.
   Le righe sorelle confermano: `770101` porta **71,9 idx [MIS] n=7** che è uno
   **stop misurato**, non un ATR.
2. 🧮 **Il `1200` non è un errore: è deliberato e coerente.**
   `1200 min = 5 × 240 min` = **esattamente le «5 barre H4»** scritte nella
   colonna geometria della stessa riga. Le righe sorelle usano i minuti del TF
   quando la geometria **è** un ATR: r.405 `PTE` (`ATR(14) H1 + buffer`) scrive
   `314,5 × √(60/1440)`. 👉 Chi ha scritto r.406 stava stimando **l'ampiezza di
   uno swing di 5 barre**, e ha usato i minuti giusti **per quello**.
3. 📉 **L'ATR(H4) vero del DAX con la convenzione di casa è `76,1 idx`**
   (`186,5 × √(240/1440)`), cioè **2,24 volte meno** di 170. Scalato a M30 dà
   `76,1 × √(30/240) = 26,9 idx` — **identico** al valore che la casa aveva già
   calcolato in diretta in `report/LA_BANDA_BASSA_2026-09-12.md` **r.338**:
   `ADR D30EUR 186,5 idx [MIS, 49 giorni] × sqrt(30/1440) = 26,9 idx`.

🔴 **E una quarta ragione per non fidarsi mai di quel `~170`**: la stessa ricetta
applicata alla riga sorella `970913` (`NASUSD`, **swing 5 barre H1**) predirebbe
`313,8 × √(300/1440) = 143,2 idx`, mentre il **misurato** sulla stessa riga è
**51,65 idx [MIS] n=4**. La ricetta «swing 5 barre» sovrastima di **~2,8×**.
👉 Il `~170` è `[INF]` con un modello che, dove è stato confrontato con la
realtà, ha sbagliato di quasi tre volte.

### 🕵️ E da dove viene, allora, la sensazione che «60 sia il numero giusto»
**`~60 idx È l'ATR(M30) — ma del DOW, non del DAX.**
`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` **r.173** dà `M30 | 55,2 – 62,4`
in una tabella che è di **`U30USD`**, non del DAX: lo dicono la legge di scala a
**r.167** (*«ancorata al misurato H1 78,0-88,2»*, denominatore **1,95** = lo
spread del Dow, non l'1,70 del DAX) e lo stop **104,3 idx n=8** a **r.160**
della sedia **`771531`**, che `CANCELLO_COSTO_FLOTTA` **r.404** dichiara
`U30USD`. Due simboli diversi, due numeri diversi che si somigliano: la
trappola classica.

---

## 3. 🏺 IL VERO DIFETTO CHE HO TROVATO SCAVANDO — **l'ancora ADR è TRONCATA**

Questo è il risultato che vale più della riconciliazione, e non lo cercavo.

L'ADR di casa (`report/ROUND_ORB_ATR_PS5_2026-09-10.md` **r.229-236**: `D30EUR
186,5 · 49 giorni`) è misurato dalle colonne `session_high/session_low` di
`data/statements/trades_auto.csv`. 🔴 **Ma quelle colonne registrano il range di
seduta AL MOMENTO DEL TRADE, non a fine seduta** — e le sedie del DAX aprono
alle 08:00-08:30, cioè **appena dopo l'apertura**, quando la seduta ha ancora
costruito quasi niente.

**La prova, sul file:** su 53 date con dati, **17 hanno range multipli per lo
stesso giorno** (un valore per trade, crescente). Esempi:
`2026.06.08 → [258,4 · 258,9 · 343,6]` · `2026.07.09 → [103,3 · 274,7]`.

| come si aggrega | D30EUR | U30USD | NASUSD |
|---|---:|---:|---:|
| **minimo per data** (= quello che ha fatto la casa) | **184,8** | **314,5** | 300,5 |
| **massimo per data** (range più pieno disponibile) | 🟢 **252,2** | 🟢 **379,5** | 384,6 |

✅ **Il minimo-per-data RIPRODUCE i numeri di casa alla cifra** (`U30USD` esce
**314,5**, identico a r.234; `D30EUR` **184,8** contro **186,5** — n leggermente
diverso, 53 date contro 49). 👉 È la **prova che ho ricostruito la loro
pipeline**, e quindi che il difetto è quello e non un mio artefatto.

### 🎯 E questo SPIEGA la «sottostima del 18-27%» già misurata in casa
`report/EMA200_I_DUE_REQUISITI_2026-09-12.md` **r.182** aveva trovato che la
legge ancorata all'ADR **sottostima del 18-27%** (ADR-ancorato H1 Dow `64,2`
contro misurato `78,0-88,2`), ma la causa era rimasta ignota.

**È l'ancora troncata, e si chiude a 1%:**

| ancora | √T a H1 su U30USD | contro il **MISURATO** 78,0-88,2 |
|---|---:|---|
| ADR troncato **314,5** | **64,2** | 🔴 sotto del **18%** |
| ADR max-per-data **379,5** | 🟢 **77,5** | 🟢 **sotto dell'1%** — dentro/al bordo della banda |

👉 **La legge √T non era rotta: era l'ancora.** Un solo meccanismo spiega tutto,
e **non si deve applicare due volte** (chi corregge l'ADR *e poi* aggiunge il
+18-27% conta due volte lo stesso errore).

---

## 4. 📏 IL NUMERO, con la sua banda e il suo residuo

Ancora: **`ADR D30EUR = 252,2 idx`** `[MISURATO]` n=53 giornate (`trades_auto.csv`,
max-per-data). Legge: `ATR(T) = ADR × √(T/1440)`, **residuo verificato −1%** su
U30USD H1.

🔴 **Il residuo va dichiarato**: anche il max-per-data è l'ultima foto **prima
dell'ultimo trade**, non la campanella, quindi resta un **pavimento**. Sul Dow
il max-per-data atterra sul **bordo BASSO** della banda misurata
(`77,5` contro `78,0-88,2`): porto lo stesso residuo sul DAX come banda
superiore (`×1,006` … `×1,138`).

| TF | `ADR × √(T/1440)` | **banda dichiarata** | confronto coi due numeri in lite |
|---|---:|---:|---|
| **M15** | 25,7 | 🟢 **25,7 – 29,2 idx** | `[NM]` in `CANCELLO` r.408 → **ora c'è un numero** |
| **M30** | 36,4 | 🟢 **36,4 – 41,4 idx** | 🟡 **dentro il bordo ALTO** del `25-40`; **−32%** contro il `~60` |
| **H1** | 51,5 | 51,5 – 58,6 idx | — |

### ✅ CONTROPROVA INDIPENDENTE **sul DAX stesso** (non sul Dow)
La sedia `770411` (`MaxMinNotte_DAX_Short_Ott`, **D30EUR M15**) ha per preset
`mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set`:
`InpSLMode=1` (ATR) · `InpMgmtTF=15` · `InpAtrPeriod=14` · **`InpAtrSLmult=2.5`**.
Su `trades_auto.csv` la gamba **2026.08.20 08:02** chiude a `sl` con
`|close−open| = 55,0 idx`.

Poiché il preset porta anche **`InpBreakeven=true`** e **`InpUseTrailing=true`**
(`InpTrailAtrMult=2.0`), uno stop spostato può solo **avvicinarsi** all'entrata:
quindi `55,0 ≤ 2,5 × ATR(M15)` ⟹ 🟢 **`ATR(14) M15 ≥ 22,0 idx`**
`[DERIVATO da MISURATO, n=1]`.
👉 **Compatibile con `25,7-29,2` e INCOMPATIBILE con l'ipotesi «19,0»** della
derivazione vecchia (che è *sotto* un pavimento osservato). Seconda strada,
altro simbolo-fonte, stesso verdetto.

### 🔴 UNA CORREZIONE DI FATTO da girare a chi tiene `CANCELLO_COSTO_FLOTTA`
r.408 e r.672 scrivono per `770411`: *«**0 gambe in stop** (5 trade, nessuno
chiuso in SL)»*. Sul `data/statements/trades_auto.csv` di oggi le 5 gambe di
`770411` sono **4 con `close_reason = sl`** (18/08 · 20/08 · 24/08 · 31/08) e
**1 `expert`** (26/08) — tutte antecedenti al referto del 10/09. Il `[NM]`
dell'ATR M15 poggiava su quella frase.

---

## 5. 💰 IL CANCELLO DI COSTO, RICALCOLATO

Spread `D30EUR` **`[MISURATO]` su 30.974.789 tick** — `report/I_QUATTRO_INVISIBILI_2026-09-12.md`
**r.298**: ora 08 mediana **1,70** · p95 **2,70** · max 12,00; ore 09-16 **1,60-1,70**.
Soglie: **40×** (lavoro) ⟹ stop ≥ **68,0 idx** · **13,3×** (duro) ⟹ stop ≥ **22,6 idx**.

| TF | stop | stop in idx | **stop/spread** | 40× ? | duro 13,3× ? |
|---|---|---:|---:|---|---|
| **M30** | 1,0 ATR | 36,4 – 41,4 | 21,4 – 24,4× | 🔴 no (54-61%) | 🟢 ok |
| **M30** | 1,5 ATR | 54,6 – 62,1 | 32,1 – 36,5× | 🔴 no (80-91%) | 🟢 ok |
| **M30** | **2,0 ATR** | 72,8 – 82,8 | 🟢 **42,8 – 48,7×** | 🟢 **PASSA** | 🟢 ok |
| **M15** | 1,0 ATR | 25,7 – 29,2 | 15,1 – 17,2× | 🔴 no (38-43%) | 🟢 ok |
| **M15** | 2,0 ATR | 51,4 – 58,4 | 30,2 – 34,4× | 🔴 no (76-86%) | 🟢 ok |
| **M15** | **2,5 ATR** *(la cella VIVA di `770411`)* | 64,2 – 73,0 | 🟠 **37,8 – 42,9×** | 🟠 **FRAGILE: il 40× cade DENTRO la banda** | 🟢 ok |
| **M15** | 3,0 ATR | 77,1 – 87,6 | 🟢 45,4 – 51,5× | 🟢 **PASSA** | 🟢 ok |

**Quanti ATR di stop servono per il 40×:** **M30 → 1,64-1,87 ATR** ·
**M15 → 2,33-2,65 ATR**.

### 🚦 I DUE VERDETTI DI TF, col numero accanto (regola del 09/09)
- 🟢 **M30 sul DAX NON è escluso per costo — ma solo da ~2 ATR in su.**
  A **1 ATR fa 21,4-24,4×** (🔴 escluso per costo, al 54-61% della frontiera);
  a **2 ATR fa 42,8-48,7×** (🟢 passa). 👉 Il vincolo su M30 **non è il costo**:
  è la **larghezza di stop minima**, e quindi il **TP** che ne deriva.
- 🟠 **M15 sul DAX è FRAGILE, non escluso.** La cella viva di `770411`
  (2,5 ATR) fa **37,8-42,9×**: la soglia cade **dentro** la banda, quindi
  `FRAGILE` — né `PASS` né `sfondato`. Serve **≥2,65 ATR** per stare sopra il
  40× su tutta la banda. 🟢 Il pavimento **duro 13,3× è rispettato su tutte le
  celle**, anche a 1 ATR.
- 🔴 **E il numero scomodo, che va detto:** allo **spread p95 dell'ora 08
  (2,70)** *nessuna* delle due celle vive passa il 40× — **M30 a 2 ATR fa
  27,0-30,7×**, **M15 a 2,5 ATR fa 23,8-27,0×**. Il 40× sul DAX all'apertura
  è un cancello che **si passa alla mediana e si perde in coda**.

---

## 6. 🔭 LA VIA PIÙ CORTA ALLA MISURA DIRETTA (proposta, NON eseguita)

Resta `[DERIVATO]`: nessuno ha letto `iATR(14)` su barre M30/M15 del DAX. La via
più economica, in ordine di costo crescente — 🚫 **non ho scritto nessun file
prova, nessuno script e nessuna riga di coda: è materia di Claudio.**

1. 🥇 **Sonda di sola lettura, costo ~0 macchina (secondi, nessuna
   ottimizzazione).** Uno script che apre un grafico `D30EUR` M30 e stampa
   `iATR(14)` mediano sulle ultime N barre, più il range medio di barra per
   fascia oraria. Nessun trade, nessun tester. 👉 **Chiude il buco in una
   corsa sola e ricalibra l'ancora ADR di TUTTA la flotta indici** (il difetto
   del §3 tocca anche `U30USD` e `NASUSD`).
2. 🥈 **Gratis, già pagato**: `Studio_D30EUR.csv`
   (`backtest_pipeline/risultati_archivio/studio_apertura/`) contiene **440
   giornate** con `ampiezza_pt`, `MAE_pt`, `MFE_pt` su D30EUR. Ho già misurato
   lì il **range dei primi 15 minuti**: mediana **54,6 idx** · media **62,5** ·
   p25 **34,4** · p75 **78,3** `[MISURATO]` n=440. Rilanciare quell'EA di studio
   con `InpRangeMinutes = 30` darebbe il range d'apertura a 30 minuti **con la
   stessa macchina già scritta e già validata**.
3. 🥉 **La correzione dell'ancora è invece gratis e immediata**: si rifà l'ADR
   prendendo il **max per data** invece del min (§3), senza toccare MT5.

📌 **Nota di frequenza, per non illudere nessuno**: il range dei primi 15′
misurato (**54,6 idx** mediano) come stop farebbe **32,1×** allo spread 1,70 —
🔴 **sotto il 40×**. Il limite superiore **48,3×** citato in
`LA_BANDA_BASSA_2026-09-12.md` **r.338** poggiava su `26,9 × 3,05`, cioè
sull'ancora troncata **e** su un fattore d'apertura ricavato da un singolo
`58,7` citato: con n=440 la mediana vera è **54,6**, non 82,0.

---

## 7. 🕳️ I BUCHI, DICHIARATI

1. 🔴 **`ATR(14)` M30/M15 del DAX mai letto direttamente.** Il mio numero è
   `[DERIVATO]`. §6 dice come chiuderlo.
2. 🔴 **La legge √T è validata su UN SOLO simbolo** (U30USD H1, residuo −1%).
   Trasportarla su `D30EUR` è `[INFERITO]`. La controprova DAX-nativa del §4
   è **n=1**.
3. 🔴 **L'ADR max-per-data è un PAVIMENTO**, non il range di seduta pieno: manca
   il tratto fra l'ultimo trade e la campanella. Le mie bande sono quindi
   **pavimenti con un tetto stimato**, non stime centrate.
4. 🟡 **L'ADR di casa va ricalibrato su tutta la flotta indici** — `U30USD`
   314,5 → 379,5 e `NASUSD` 300,5 → 384,6. Ogni `stop/spread` `[INF]` costruito
   sull'ancora vecchia è **sottostimato di ~18-27%**, quindi **conservativo**:
   nessun verdetto di *esclusione* per costo si ribalta, ma diversi
   *`FRAGILE`* possono diventare *`PASS`*. 🚫 Non ho toccato quei referti.
5. ⚪ **`Studio_D30EUR.csv` è a 15 minuti**, non a 30: il range d'apertura M30
   del DAX resta non misurato.

---

## 8. 🧾 CHE COSA NON HO FATTO
🚫 Nessun backtest, nessun EA, nessun preset, nessun file prova, nessuna riga di
coda, nessuna riga di lancio verso il VPS. 🚫 Nessun candidato archiviato: questo
referto **non è un giudizio di merito su nessun motore** — `970912` e `770411`
sono citati solo come **fonti di numeri**. 🚫 Conto reale `10105439` non toccato;
nessun commento su taglie o rischio.

---

## 📚 FONTI (file + riga)
- `report/CACCIA_SABATO_2026-09-13.md` r.461, r.464-465
- `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.385, r.393, r.394, r.405, r.406, r.408, r.672
- `report/LA_BANDA_BASSA_2026-09-12.md` r.338
- `report/ROUND_ORB_ATR_PS5_2026-09-10.md` r.229-236 (ADR `[MIS]`)
- `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` r.160, r.166-167, r.173 (M30 del **Dow**), r.182 (sottostima 18-27%)
- `report/I_QUATTRO_INVISIBILI_2026-09-12.md` r.298 (spread `[MIS]` 30.974.789 tick), r.317, r.501
- `report/PROPOSTA_RELATIVO_TICK_REALI_2026-09-04.md` r.352 (**100 punti MT5 = 1 punto indice**, `[MIS]`, T14)
- `data/statements/trades_auto.csv` (166 gambe `D30EUR`, 53 date)
- `backtest_pipeline/risultati_archivio/studio_apertura/Studio_D30EUR.csv` (440 giornate)
- `mql5/Presets/ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_M15_770411_100K.set`
- `mql5/Experts/ABTG_Apertura_Study_EA.mq5` r.27-34 (definizione di `ampiezza_pt`)
