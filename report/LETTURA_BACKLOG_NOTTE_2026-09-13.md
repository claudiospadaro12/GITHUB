# 📖 LA NOTTE CHE NESSUNO AVEVA LETTO — 49 coppie IS/OOS, un verdetto per ognuna

**Data lettura:** 13/09/2026 · **Fonte:** `backtest_pipeline/risultati_prove/dal_vps/`
(98 CSV = 49 coppie, caricati dal VPS con `carica_risultati.ps1`)
**Referto della corsa:** `backtest_pipeline/coda/referti/REFERTO_RUNNER_20260913_033003.txt`
**Per-trade (posizioni vere):** `backtest_pipeline/coda/referti/CODA_12_pertrade_posizioni_20260913_033003.log`

> **Perché questo file esiste:** il runner **non pubblica i CSV** (classe 307). Il
> referto della notte dice "ESEGUITO, uscita 0" e si ferma lì: i **numeri** erano
> sul VPS e nessuno li aveva aperti. Questa è la prima lettura.
> **Nessun EA toccato, nessun round eseguito, nessun preset cambiato, il conto
> reale 10105439 non compare da nessuna parte.** Si è solo letto.

---

## 🔢 IL CONTO IN CIMA

| categoria | quante | cosa vuol dire |
|---|---:|---|
| ✅ **PASSANO il proprio criterio congelato** | **7** | r136a · r136b · r136c · cemad02 · cemad05 · r137c · **r127c (il canarino)** |
| ❌ **FALLISCONO** un criterio congelato | **26** | rischio, merito, o **riproduzione** |
| ⏸️ **NON GIUDICABILI** (merito sospeso / screening / passo 0) | **12** | n < 150, oppure OHLC = mai un verdetto |
| 📦 **ancore d'archivio** (non round della notte) | **4** | R123A/B/C/D, rilette per il cancello di r132c |
| | **49** | |

**Etichette girate STANOTTE: 35.** Le altre **14** erano già nella cartella
(round del 08-09/09) e sono state caricate insieme: qui sono lette lo stesso,
ma **dichiarate come archivio**.

---

## 🟢 LE TRE COSE CHE CONTANO (e la prima vale tutta la notte)

### 1. 🐤 **IL CANARINO È VIVO: `r127c` RIPRODUCE L'ARCHIVIO.** Quindi tutti gli altri numeri della notte si possono leggere.

Era **il cancello di tutta la corsa** (`report/IL_WIP_E_DIAGNOSTICA_2026-09-12.md`):
il binario girava dalla TESTA del branch, e la testa portava una patch marcata
*"IN CORSO D'OPERA — NON COMPILARE"*. Se il canarino non tornava, **nessuno degli
altri 34 round era leggibile**.

| | atteso (R103, ancora) | **misurato** | tolleranza | esito |
|---|---|---|---|---|
| n composito (IS+OOS) | 394 | **395** (153 + 242) | ±2% | ✅ **+0,25%** |
| PF composito | 1,41 | **1,39972** | ±0,03 | ✅ dentro |

Il PF composito **non è una stima**: da `Profit = P−L` e `PF = P/L` i lordi sono
determinati in modo unico. IS: P 88.958 / L 75.589 · OOS: P 207.476 / L 136.192
→ PF = 296.434 / 211.781 = **1,39972**. Fonte: i due CSV `ohlc_r127c`.

### 2. ✍️ **`r137c`: LA FIRMA DEL DAX È RIPRODOTTA SUL BINARIO DI OGGI — 8 numeri su 8, al quinto decimale.**

`ABTG_DAX_Apertura_EU` D30EUR M5 LONG, sedia **770101**, `InpTP1_ClosePct` 50 → 0:

| cella | finestra | PF | DD % | posizioni | profit | vs R47 (agosto) |
|---|---|---|---|---|---|---|
| 50 (**viva**) | IS | 1,12634 | 5,4362 | 132 | +3.789,36 | identico |
| 50 (**viva**) | OOS | 1,39709 | 7,2328 | **193** | +18.029,58 | identico |
| **0** | IS | **1,18323** | **4,9576** | 132 | +5.569,37 | identico |
| **0** | OOS | **1,49140** | **6,2719** | **193** | +23.607,28 | identico |

**A parità di 193 posizioni** (misurate nel per-trade, magic 786201: 270 deal /
193 posizioni): togliere la parziale **alza il PF di 0,094 e abbassa il DD di
0,96 punti**, in **tutte e due** le finestre. Non è selezione, è gestione.
🔴 **Questa è una FIRMA DI CLAUDIO, non un round** — e ora ha un numero di oggi,
non di un mese fa. È la cosa che in questa notte **avvicina di più una sedia
schierabile**, e non costa una riga di codice.

### 3. 🧮 **`cemad02`: IL NUMERO CHE MANCAVA AL CERTIFICATO DELLA SEDIA MIGLIORE È ARRIVATO — e l'"uscita 2" del runner era un FALSO ALLARME.**

Il referto marcava `cemad02` **codice 2 = NON MISURATO (CSV mancanti/vuoti)**.
Verificato: **il CSV IS è vuoto (0 byte) PERCHÉ DOVEVA ESSERLO.** Il file prova
(`COLLAUDO_EMADOW_02_pertrade_IS.txt`, `@FRAZIONEIS 0.002`) lo dichiara tre volte:
*"il CSV che conta è il \*_OOS\*, non il \*_IS\*… l'atteso è 1"*. La gamba "IS" è
un giorno solo e si butta per costruzione.

E il CSV OOS porta **esattamente l'IS di R112**: `+4.585,40 · PF 1,20110 ·
DD 5,7325% · 237 deal`. 🟢 **Riproduzione PASS.**
Il deliverable vero (per-trade, `CODA_12`, magic 766620/766621):

> 🔴 **L'IS della sedia 771531 ha 132 POSIZIONI** (237 deal, rapporto **1,7955**),
> finestra 2024.10.22 → 2025.06.06.

**Conseguenze, e sono due:**
- ✅ **Requisito 2 del certificato (n e DD) CHIUSO** sull'IS: **132 < 150**, quindi
  il merito in IS resta sospeso — ma ora **per misura**, non per stima.
- ⚠️ **Il fattore IS NON è 2,0117.** È **1,7955** (quello è l'OOS). Tutti i file
  r136 convertivano l'IS con 2,0117 e ne ricavavano **117,8 posizioni [INFERITO]**:
  il numero vero è **132**. Lo scarto non cambia nessun verdetto (entrambi sotto
  150), ma la costante va corretta dove è scritta.

🚩 **E c'è una classe nuova da annotare:** il sentinella generico del runner
("CSV vuoto → codice 2") **non conosce `@FRAZIONEIS`** e marca NON MISURATO un
round riuscito. Un round buono archiviato come rotto è esattamente il difetto
che il 09/09 ci è costato quattro candidati.

---

## 📋 LA TABELLA COMPLETA — 49 etichette

Legenda: **n** = colonna `Trades` = **deal di uscita**, non posizioni (classe 226).
Dove le posizioni sono MISURATE (per-trade `CODA_12`) sono scritte in chiaro.

| etichetta | EA | simbolo/TF | PF IS/OOS (cella di riferimento) | DD% IS/OOS | n IS/OOS | verdetto |
|---|---|---|---|---|---|---|
| **r136a** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 riproduce; altopiano di **6 celle** (SLatr 0,6-1,6); **"il default va bene"** |
| **r136b** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 ✓; altopiano 0,25-0,75, **centro 0,50 NON batte il default** |
| **r136c** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — S1 ✓; altopiano 25-50-75 **col centro = cella viva**; la cella NUDA è peggiore |
| **r136d** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ⏸️ **NON MISURABILE** — S1 ✓ ma **il segno si inverte fra IS e OOS** (criterio 1 del file) |
| **cemad02** | EMA200 | U30USD H1 | — / 1,20110 | — / 5,73 | vuoto / 237 | ✅ **PASS** — riproduce l'IS di R112; **132 posizioni MISURATE**; codice 2 = falso allarme |
| **cemad05** | EMA200 | U30USD H1 | 1,20110 / 1,52365 | 5,73 / 7,83 | 237 / 517 | ✅ **PASS** — G0-B ✓; **requisito 5 (TF) CHIUSO**: H1 confermato, M15/M20/M30 bocciati |
| **r137a** | DAX_Apertura_EU | D30EUR M5 | 1,12634 / 1,39709 | 5,44 / 7,23 | 175 / 270 (**193 pos**) | ❌ **A1 FALLITO** — 1 sola cella a-costo passa; **prezzo di R5 misurato** (vedi §3) |
| **r137b** | DAX_Apertura_EU | D30EUR M5 | 1,12634 / 1,39709 | 5,44 / 7,23 | 175 / 270 | ❌ **FAIL** — ramo SKIP: campione a **24 posizioni** e PF **in calo monotono** |
| **r137c** | DAX_Apertura_EU | D30EUR M5 | 1,18323 / **1,49140** | 4,96 / **6,27** | 132 / **193 pos** | ✅ **PASS** — riproduzione 8/8 → **è una FIRMA** |
| **r138a** | DAX_Apertura_EU | **F40EUR** M5 | 1,44028 / **0,76965** | 7,36 / **11,82** | 130 / 195 (**152 pos**) | ❌ **FAIL F3 (rischio)** — DD OOS 11,82% > 10,0%; merito negativo su campione leggibile |
| **q770be** | DAX_Apertura_EU | D30EUR M5 | 1,18323 / 1,49140 | 4,96 / 6,27 | 132 / 193 | ❌ **FAIL soglia** — peggior giornata **invariata** (-1,0793% su 4 celle su 4) |
| **r139a** | EMA200 | AUDJPY H4 (OHLC) | 0,80 / 0,95-1,01 | **15,4-16,9 / 16,9-20,4** | 757-768 / 1292-1345 | ❌ **FAIL S3 (rischio)** — DD > 14,0% su **tutte** le celle, in **entrambe** le finestre |
| **r139b** | EMA200 | GBPUSD H4 (OHLC) | 0,80-0,84 / 1,13 | **17,7-20,3** / 10,1-11,0 | 856-875 / 1292-1321 (**718 pos**) | ❌ **FAIL S3 + S4** — DD IS > 14,0%; **segno opposto su 4 celle su 4 = REGIME, non edge** |
| **r139c** | FiboH4_Multi | GBPUSD H4 (OHLC) | 0,79-0,83 / 0,94-0,97 | **20,7-23,3 / 17,2-17,7** | 548-572 / 725-737 (**643 pos**) | ❌ **FAIL F1 (rischio)** — DD > 14,0% ovunque; PF < 1,00 in entrambe |
| **r141a** | IntradayMomentum | NASUSD M30 | **0,60887** / 1,24334 | 7,76 / 3,03 | **146** / 261 | ⏸️ **NON GIUDICABILE** — IS a **4 operazioni** dal pavimento; segno nettamente discorde |
| **r141b** | IntradayMomentum | U30USD M30 | **0,59938** / 1,03501 | 6,42 / 4,41 | **146** / 261 | ⏸️ **NON GIUDICABILE** — stesso schema del gemello, **identico nei conteggi** |
| **r141c** | AtrExhaustVol | NASUSD M30 | 0,97227 / 1,22915 (cella ATR) | 5,69 / 4,14 | 70 / 96 | ❌ cella PERC **scartata** (C0 + DD 19,25%) · ⏸️ cella ATR non giudicabile (n<150) |
| **r141d** | HVAncora | U30USD M30 | 1,38464 / 1,92073 (k=1,0) | 3,42 / 2,06 | 22 / 31 | ⏸️ **NON GIUDICABILE sul merito** — ma **PASSO 0 RIUSCITO**: il motore opera (vedi §4) |
| **r142a** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | **116 / 175** (riproduce) | ❌ **merito: scarta** (tutte < 1,10 con n≥150) · ✅ **voce 3 del certificato CHIUSA** |
| **r142b** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | 116 / 175 (riproduce) | ❌ **merito: scarta** — l'asse morde (+0,11 PF) ma **nessuna cella arriva a 1,10** |
| **r142c** | Nasdaq_Live5m | NASUSD M5 | 1,01472 / 0,95624 | 12,3 / 22,5 @2% | 116 / 175 (riproduce) | ❌ **merito: scarta** — senza trailing il DD OOS sale a **33,62%** @2% |
| **r127c** 🐤 | CostToCost | EURJPY H4 (OHLC) | 1,17686 / 1,52341 | 11,0 / 12,3 | 153 / 242 = **395** | ✅ **PASS — IL CANARINO DELLA NOTTE** (vedi §1) |
| **r127b** | SupertrendRev_Ott | XAUUSD H4 (OHLC) | 0,85447 / 1,12525 | 6,58 / 5,91 | 230 / 427 = **657** | ⏸️ ancora **n 657 esatta** ✅ · merito non giudicabile (OHLC + PF IS < 1,00 su 7/7) |
| **r126a** | SuperWave_DOW_H1 | U30USD H1 | **1,48166** / 1,24312 | 4,04 / 4,17 | 72 / 131 | ❌ **ANCORA GRADO C** — PF IS **1,48166 contro 1,84892** (Δ 0,367 > ±0,15) → **round fermo** |
| **r126b** | SuperWave_DOW_H1 | U30USD H1 | 1,48166 / 1,24312 (lookback 5) | 4,04 / 4,17 | 72 / 131 | ⏸️ **non leggibile** (stesso gruppo) — **ma conferma il determinismo interno** |
| **r126d** | SuperWave | NASUSD H1 | 0,71-1,13 / **0,73-0,84** | 1,72 / 2,7-3,2 | 35-38 / **58-63** | ❌ **FAIL G3+G4** — PF OOS < 1,10 su **9 celle su 9**; n OOS < 95 (pavimento) |
| **r132c** | SupRev_DOW_H1_Ott | U30USD H1 | 0,98846 / 1,38900 (NearAtr 1,0) | 6,17 / 5,91 | 117 / 152 | ❌ **ROUND NULLO** — la riproduzione fallisce su **3 celle su 5** (vedi §5) |
| **r120b11** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,48166 / **1,24312** | 4,04 / 4,17 | 72 / 131 | ❌ **G1 metro FALLITO** — PF OOS fuori dalla forbice **1,30-1,55** → le altre 3 celle non si leggono |
| **r120b00** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 0,90317 / 1,18671 | 6,04 / 6,23 | 46 / 90 | ❌ non leggibile (G1 del gruppo) |
| **r120b01** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,40616 / 0,98333 | 4,45 / 5,11 | 71 / 125 | ❌ non leggibile (G1 del gruppo) |
| **r120b10** | SuperWave_DOW_H1 | U30USD H1 (dep 10k) | 1,48914 / 1,24312 | 3,80 / 4,17 | 72 / 131 | ❌ non leggibile (G1 del gruppo) |
| **r120e11** | SuperWave_DOW_H1 | U30USD H1 (**dep 100k**) | 1,39744 / 1,22034 | 3,48 / 4,21 | **106 / 184** | ⏸️ metro del banco — **ha misurato la cosa che spiega tutto** (§5) |
| **r120e00** | SuperWave_DOW_H1 | U30USD H1 (**dep 100k**) | 0,97751 / 1,28437 | 5,07 / 6,53 | 74 / 130 | ⏸️ metro del banco |
| **r133b** | ORB_Ottimizzato | U30USD M30 | 1,24979 / 1,67419 (cella 0) | 7,89 / 9,76 | 71 / 119 | ❌ cella 1 **scartata per rischio** (DD IS **27,21%** > 12,0%) · merito non leggibile (n<150) |
| **r133c** | MaxMinNotte | D30EUR M5 | 1,99749 / 1,01569 (box 0) | 4,89 / 9,05 | 38 / 65 | ⏸️ **NON GIUDICABILE, dichiarato prima** — consegnata la curva Trades(soglia) |
| **P0_IBRETEST** 📦 | IBRetest | U30USD M30 | 0,38242 / 0,69663 | 7,38 / 7,61 | 42 / 53 | ⏸️ archivio — frequenza **0,21 op/g** in banda; merito sospeso; segno negativo concorde |
| **P0IBRTDAX** 📦 | IBRetest | D30EUR M30 | 1,21062 / 0,96493 | 2,80 / 5,25 | 58 / 107 | ⏸️ archivio — merito sospeso (n<150) |
| **P0IBRTNAS** 📦 | IBRetest | NASUSD M30 | 0,56297 / 0,59292 | 5,80 / 5,31 | 35 / 49 | ⏸️ archivio — merito sospeso; segno negativo concorde |
| **P0CONTA (LVN)** 📦 | LVNArbitro | U30USD M30 | 0,97856 / 1,05108 | **18,01** / 11,33 | 392 / 618 | ❌ archivio — **C0 (PF<1,10 con n≥150) + rischio** (DD > 10%) |
| **P0_100K (LVN)** 📦 | LVNArbitro | U30USD M30 | 0,97485 / 1,05227 | **19,35** / 11,76 | 392 / 618 | ❌ archivio — idem, confermato alla taglia 100k |
| **P0CONTA (ORB-B)** 📦 | OpeningReversalB | U30USD M5 | 1,82619 / — | 0,96 / 0,00 | **2 / 0** | ❌ archivio — **bocciato per frequenza** |
| **P0A_FAIL** 📦 | OpeningReversalB | U30USD M5 | 1,82619 / — | 0,96 / 0,00 | 2 / 0 | ❌ archivio — contatori: State1 24-29, State2 16-19, **Entry 2** |
| **P0B_SIGNAL** 📦 | OpeningReversalB | U30USD M5 | 0,00-1,83 / — | ≤0,96 / 0,00 | 1-2 / 0 | ❌ archivio — State1 fino a **49**, ingressi **1-2** |
| **P0C_FT** 📦 | OpeningReversalB | U30USD M5 | 1,75-3,56 / — | ≤0,96 / 0,00 | 2-3 / 0 | ❌ archivio — il PF 3,56 è su **3 operazioni**: numero senza campione |
| **P0_EURCHF** 📦 | Nightly | EURCHF | 0,89113 / 0,81429 | **11,10 / 15,39** | 63 / 85 | ❌ archivio — **BOCCIATO PER RISCHIO** (soglia congelata: DD > 10% su una cella) |
| **R123AGATE** 📦 | SupRev_DOW_H1_Ott | U30USD H1 | 0,98837 / 1,38944 | 6,17 / 5,91 | 117 / 152 | 📦 **ancora d'archivio** (09/09) — termine di paragone di r132c |
| **R123BSTMULT** 📦 | SupRev_DOW_H1_Ott | U30USD H1 | 0,88-2,02 / 0,91-1,42 | 2,9-8,9 / 3,6-12,4 | 97-180 / 112-261 | 📦 ancora d'archivio |
| **R123CATRP** 📦 | SupRev_DOW_H1_Ott | U30USD H1 | 0,56-1,18 / 0,56-1,39 | 4,9-9,1 / 2,8-9,2 | 104-136 / 108-202 | 📦 ancora d'archivio |
| **R123DNEARATR** 📦 | SupRev_DOW_H1_Ott | U30USD H1 | 0,63-1,00 / 0,99-1,39 | 4,6-7,2 / 5,9-6,4 | 64-128 / 122-172 | 📦 **ancora d'archivio — è quella che r132c non riproduce** |

---

## §3 · 💶 `r137a`: IL PREZZO DI R5 SULLA SECONDA SEDIA, CHE NESSUNO CONOSCEVA

La domanda del round era: *allargare gli stop stretti fino alla frontiera del
costo, quanto costa in edge?* Il file congelava **prima** quali celle sono
ESCLUSE PER COSTO (800 / 2800 / 4800) e quali chiudono R5.

| floor | rapporto min @1,70 | @2,70 (p95) | PF OOS | DD OOS | n OOS |
|---|---|---|---|---|---|
| 800 (= OFF) | 4,7x ❌ | 3,0x ❌ | 1,39709 | 7,2328 | 270 |
| 4800 | 28,2x ❌ | 17,8x ❌ | *1,49624* | 7,2465 | 272 |
| **6800** | **40,0x ✅** | 25,2x | **1,42020** | 7,2469 | 272 |
| 8800 | 51,8x ✅ | 32,6x | 1,38128 | 6,3222 | 273 |
| **10800** | 63,5x ✅ | **40,0x ✅** | **1,28751** | 5,6879 | 273 |
| 12800 | 75,3x ✅ | 47,4x | 1,28394 | 6,3422 | 274 |

**A1 (3 celle contigue) FALLISCE**: fra le celle a-costo ne passa **una sola**
(6800). Quindi il verdetto è quello previsto dal file: *"chiudere R5 con questa
manopola COSTA \<quanto\>, ed è un baratto che decide Claudio"*. Il quanto:

> 🟢 **Al pavimento di LAVORO (68 idx, 40x alla mediana): PF 1,39709 → 1,42020.
> Costo ZERO** — anzi, +0,023, che sta **dentro la banda di rumore A9 (0,10)**,
> quindi la frase onesta è **"non si distingue dal default"**.
> 🟡 **Al p95 (108 idx, 40x anche sullo spread cattivo): PF 1,39709 → 1,28751.
> Costa 0,110 punti di PF**, e restituisce 1,54 punti di DD (7,23% → 5,69%).

**Due misure regalate dal round, che non avevamo:**
- la cella 800 torna **identica** alla cella viva (270 / 1,39709 / 7,2328) →
  **ZERO gambe con stop geometrico sotto 8 punti indice**. Era una domanda aperta
  sul rischio della sedia: è chiusa, e la risposta è "non esistono".
- il floor **non tocca il numero di posizioni** (193 in tutte e tre le corse
  7862xx del per-trade): non è selezione, è geometria.

🔴 **La cella che "vince" il round (4800, PF 1,49624) è ESCLUSA PER COSTO** —
scritto prima dei numeri. Vince una cella fuori costo, e questo non è un
miglioramento: è il motivo per cui i criteri si congelano prima.

### `r137b` — l'altra metà: **il ramo SKIP è bocciato, e con il verso opposto a quello temuto**

L'attesa scomoda diceva: *"il PF sale e il campione crolla"*. Misurato: **il
campione crolla E il PF scende, monotonamente**.

| floor | PF OOS | n OOS (deal) | posizioni OOS |
|---|---|---|---|
| 800 | 1,39709 | 270 | 193 (misurate) |
| 2800 | 1,29425 | 264 | — |
| 4800 | 1,29362 | 209 | — |
| 6800 | 1,27113 | 164 | ~117 |
| 10800 | **0,97614** | 65 | ~46 |
| 12800 | **0,87606** | 35 | **24 (misurate)** |

> 🔴 **Su questa sedia i giorni con lo stop stretto sono i giorni in cui c'è
> l'edge.** Buttarli via non "seleziona": distrugge. Il cancello del costo, qui,
> si accende **solo** nel ramo ALLARGA.

---

## §4 · 🔭 `r141c` / `r141d`: DUE MOTORI INVISIBILI HANNO APERTO GLI OCCHI

Erano fermi da 18 giorni, **né vivi né morti**, con zero CSV in archivio.

**`r141c` — AtrExhaustVol NASUSD M30 (rischio 0,65%)**
| cella | PF IS/OOS | DD IS/OOS | n IS/OOS | esito |
|---|---|---|---|---|
| PERC (prossimità larga) | 0,71059 / 0,95222 | **19,25 / 13,45** | **153** / 224 | ❌ **SCARTATA due volte**: C0 (n≥150 con PF<1,10) **e** rischio (DD>10%) |
| ATR (il filtro che morde) | 0,97227 / 1,22915 | 5,69 / 4,14 | 70 / 96 | ⏸️ merito sospeso, **rischio OK** |

Le due celle **danno numeri diversi** → `InpProxMode` arriva all'EA: **niente
catena rotta**. Entrambe le bande di frequenza dichiarate prima **reggono**
(166 e 377 operazioni contro bande 44-220 e 130-530). Frequenza della cella
buona: **0,37 op/giorno di seduta** → su tre indici la famiglia sfiora il
pavimento di 1,00 del 07/09. **Non è un morto: è "non ancora misurato"**, e la
via più corta è il gemello, non un'altra griglia.

**`r141d` — HVAncora U30USD M30 (rischio 0,65%) — e qui una previsione è stata SMENTITA, il che è il punto**

| k = `InpStopAtr` | PF IS/OOS | DD IS/OOS | n IS/OOS | **Reject (costo)** IS/OOS | Ancore scadute IS/OOS |
|---|---|---|---|---|---|
| 1,0 | 1,38464 / **1,92073** | 3,42 / 2,06 | 22 / 31 | **5 / 16** | 91 / 165 |
| 1,5 | 1,78347 / 1,03844 | 2,45 / 3,84 | 25 / 35 | 2 / 10 | 88 / 161 |
| 2,0 | 1,61927 / 1,33304 | 2,15 / 2,79 | 26 / 36 | 1 / 2 | 87 / 160 |
| 2,5 | 1,36137 / 0,92959 | 2,24 / 3,12 | 26 / 37 | 1 / 1 | 87 / 159 |

- ✅ **Trades monotono crescente** su k, come richiesto: nessuna catena rotta.
- 🔴 **La previsione "a k=1,0 rifiuto per costo ~100%, 0-5 operazioni" è
  SMENTITA**: a k=1,0 il motore fa **53 operazioni** e ne rifiuta 21. Il cancello
  interno di costo **non era il tappo**.
- 🟢 Il tappo vero è **misurato e sta altrove**: **91 ancore IS e 165 OOS
  SCADONO** senza convertirsi. È lì che va il prossimo round, non sui parametri.
- ⏸️ Merito **sospeso su tutte le celle** (n 22-37 ≪ 150). **Non scartato per
  frequenza** (63 op in 21 mesi contro la soglia di 30) né **per rischio**
  (DD max 3,84% contro 10%).
- ❌ L'ipotesi *"se il PF è piatto sulle celle che operano, è la conferma
  dell'invarianza in R"*: **il PF NON è piatto** (OOS da 0,93 a 1,92). Ma su
  22-37 operazioni quella variazione **non è distinguibile dal rumore**: il
  verdetto onesto è **[NON MISURABILE]**, non "smentita".

---

## §5 · 🚨 QUATTRO RIPRODUZIONI FALLITE, E UNA SPIEGAZIONE MISURATA

### `r132c` — **ROUND NULLO**, e il criterio era esplicito

Il file congelava: *"LE CINQUE CELLE DEVONO TORNARE IDENTICHE, CIFRA PER CIFRA.
Non 'simili', non 'entro l'1%'"*. Confronto con
`risultati_prove/r123_dal_vps/...R123DNEARATR.csv` (magic 784130) contro r132c
(magic 779460):

| NearAtr | archivio IS (profit/PF) | **r132c IS** | archivio OOS | **r132c OOS** |
|---|---|---|---|---|
| 0,50 | -315,18 / 0,63495 | **-314,65 / 0,63534** ❌ | -12,28 / 0,99155 | **-12,79 / 0,99120** ❌ |
| 0,75 | -284,14 / 0,76952 | **-283,61 / 0,76985** ❌ | 423,33 / 1,28433 | **422,82 / 1,28389** ❌ |
| 1,00 | -15,58 / 0,98837 | **-15,45 / 0,98846** ❌ | 622,79 / 1,38944 | **622,28 / 1,38900** ❌ |
| 1,25 | 6,74 / 1,00474 | 6,74 / 1,00474 ✅ | 643,57 / 1,32197 | 643,57 / 1,32197 ✅ |
| 1,50 | -220,72 / 0,86503 | -220,72 / 0,86503 ✅ | 643,57 / 1,32197 | 643,57 / 1,32197 ✅ |

**3 celle su 5 divergono** (di ~0,51-0,53 EUR di profitto e nella 4ª-5ª cifra di
PF/DD); **`n` è identico su tutte e cinque**. Per il criterio congelato:
🔴 **ROUND NULLO — e R132a e R132b NON si lanciano finché non è spiegato.**
Indizio da consegnare a chi indaga, **senza inventarne la causa**: divergono
esattamente le celle 0,50/0,75/1,00 e **non** le 1,25/1,50, in **entrambe** le
finestre.

### `r126a` + `r120b` — la stessa EA non riproduce agosto, **ma è coerente con sé stessa**

| misura | archivio (agosto) | **stanotte** | tolleranza | esito |
|---|---|---|---|---|
| r126a cella b=0, PF IS | 1,84892 | **1,48166** | ±0,15 | ❌ **GRADO C → round fermo** |
| r126a cella b=0, PF OOS | 1,32770 | **1,24312** | ±0,15 | ✅ dentro |
| r120b cella 11_vivo, PF OOS | forbice 1,30-1,55 | **1,24312** | — | ❌ **G1 metro fallito** |

🟢 **Ma il determinismo di casa è INTATTO, e lo dicono tre round indipendenti
della stessa notte:** `r126a` (cella b=0), `r126b` (cella lookback=5) e
`r120b11` (cella viva) sono **la stessa cella** girata in **tre corse separate**
e danno **1,24312 / 4,1675 / 131 al centesimo**. E il cancello G0 (gemelli sul
magic) passa su tutte e sei le etichette r120. **Non è la macchina.**

🔎 **E la spiegazione più probabile l'ha misurata `r120e`, che esisteva apposta:**

| cella viva 11 | deposito | n IS | n OOS | PF OOS |
|---|---|---|---|---|
| r120b11 | **10.000** | 72 | **131** | 1,24312 |
| r120e11 | **100.000** | 106 | **184** | 1,22034 |
| archivio r3 | *[non dichiarato]* | 75 | 143 | ~1,33 |

> 🔴 **Su `ABTG_SuperWave_DOW_H1_Ottimizzato` il NUMERO DI OPERAZIONI dipende dal
> DEPOSITO: 131 → 184 (+40%) a parità di tutto il resto.** La sentinella di
> R120e (*"se n CROLLA è margine"*) **non scatta**: n **sale**.
> 👉 **Conseguenza operativa:** ogni confronto d'archivio su questa EA fatto a
> depositi diversi **non è confrontabile**, e la differenza con agosto va
> attribuita alla taglia **prima** di parlare di edge. R120e ha fatto il suo
> lavoro: è un metro del banco, e il banco aveva un difetto da misurare.
> ⚠️ **INFERENZA, non misura:** la causa (quantizzazione del lotto / pavimento
> del lotto minimo) è **coerente** coi tre numeri ma **non è stata isolata**.
> Isolarla costa una corsa a deposito d'archivio dichiarato.

---

## §6 · 📘 LE COSE CHIUSE COL NUMERO (caselle del certificato che non erano vuote per sempre)

| candidato | casella chiusa stanotte | col numero |
|---|---|---|
| **EMA200 U30USD (sedia 771531)** | **#2 (n e DD)** | IS = **132 posizioni** misurate, rapporto 1,7955 |
| **EMA200 U30USD** | **#3 (uscita ad asse)** | 4 manopole d'uscita mai mosse in 213 CSV, **ora misurate**: SLatr, TP1_ATRmult, TP1Pct, UseTrailing |
| **EMA200 U30USD** | **#5 (TF cambiato)** | 7 TF misurati: M15 **-9.456 e DD 26,3%**, M20 **-26.415 e DD 30,7%**, M30 **-11.404 e DD 15,9%**, **H1 +23.321 e DD 7,8%**, H2 +4.095, H3 -1.519, H4 +4.604 (n 116) |
| **Nasdaq_Live5m (PreOpen)** | **#3 (uscita ad asse)** | **tre** manopole (parziale, TF del trailing, trailing on/off): **nessuna** porta il PF OOS a 1,10. Restano aperte la #4 e la #5 → **NON si archivia** |
| **FiboH4_Multi** | prima lettura su **un simbolo solo** | il "0/8" d'archivio ora ha un conto: PF 0,79-0,97 e **DD 17-23%** |
| **AtrExhaustVol / HVAncora** | prima riga in assoluto | erano a **zero CSV** da 18 giorni |

### 🔍 Il dettaglio di `cemad05` che vale da solo
H1 **non è un picco isolato** (il vicino H2 è positivo, PF 1,17278), ma **non
esiste un altopiano sopra 1,40**: solo H1. E i TF bassi non sono "un po' peggio",
sono **fuori dal muro prop**: DD 15,9% / 26,3% / 30,7%. La sedia resta H1, e
adesso lo sappiamo **per misura** invece che per abitudine.

### 🔍 Il dettaglio di `r136c` che ribalta un'intuizione
La cella **NUDA** (`InpTP1Pct=0` → niente parziale, **niente breakeven, niente
trailing**: tre meccanismi spenti da una manopola sola) era attesa con **PF più
alto e DD più alto**. Misurato: **PF più BASSO e DD più alto** —
PF OOS **1,28144** contro 1,52365, DD **13,9367%** contro 7,8323%, su 165
posizioni contro 257.
> 🟢 **La gestione di questa sedia vale, ed è misurata: 0,24 punti di PF e 6,1
> punti di DD.** Non è decorazione.
⚠️ E un'attesa è saltata: la cella 0 era prevista a **250-290 deal** in OOS, ne
ha fatti **165**. Il rapporto grezzo 517/165 = 3,13 **non** è una seconda misura
del fattore 2,0117: la durata delle posizioni cambia, e la correzione resta
**[NON MISURATA]**. La conferma vera del fattore arriva da un'altra parte:
la cella 25 fa **602 deal = 257 posizioni**, **le stesse 257 della cella viva** →
le posizioni **sono invariate** sull'asse del parziale. ✅

---

## §7 · ⚠️ LE ATTESE USCITE DI BANDA (si dichiarano, non si nascondono)

| round | grandezza | banda dichiarata prima | misurato | lettura |
|---|---|---|---|---|
| r136b | n OOS | 480-560 | **336-495** (5 celle su 6 fuori) | campanello dichiarato dal file: va capito **prima** del PF |
| r136c | n OOS cella 0 | 250-290 | **165** | vedi sopra |
| r136d | n OOS cella 0 | 470-530 | **427** | fuori in basso |
| r138a | frequenza | 0,49-0,87 pos/g | **0,551** ✅ | previsione scomoda **confermata** (CAC più lento del DAX) |
| r139a | DD IS | 6-14% | **15,4-16,9%** | **sopra**, e l'OHLC **sottostima** il DD → il rifiuto per rischio è **robusto** |
| r139c | n IS | 240-290 deal | **548-572** | il doppio: la stima della frequenza su un simbolo solo era sbagliata |
| r141d | Trades a k=1,0 | 0-5 | **53** | previsione **smentita** (§4) |
| r141a/b | n IS | 160-180 | **146** | 4 operazioni sotto il pavimento: il cancello C0 **non scatta per un soffio** |

---

## §8 · 🕳️ BUCHI DICHIARATI DI QUESTA LETTURA

1. **Un solo regime.** Tutti i round su indici girano su 2024.09.26 → 2026.06.30
   = 21 mesi di **toro**. La regola C dell'Emendamento della Finestra **non è
   soddisfatta da nessuno di questi numeri**. Niente qui è promuovibile.
2. **Peggior giornata per cella: [NON MISURATA]** nella maggior parte dei round —
   in ottimizzazione l'export per-trade viene sovrascritto a ogni passata e
   sopravvive **solo l'ultima cella**.
3. **Le posizioni sono misurate solo dove il per-trade è sopravvissuto**
   (`CODA_12`). Altrove sono **deal**, e la conversione è dichiarata cella per
   cella, mai applicata di nascosto.
4. **r139a/b/c e r127b/c sono OHLC**: screening, **mai un verdetto**. I rifiuti
   **per rischio** reggono lo stesso, e per un motivo aritmetico: su OHLC il DD è
   un **limite inferiore**, quindi un DD OHLC sopra soglia è sopra soglia anche a
   tick.
5. **Il costo (R5) di F40EUR resta [NON MISURATO]**: non esiste un file di spread
   orario per quel simbolo. Nessuna sedia su F40EUR si accende prima.
6. **La sovrapposizione D30EUR/F40EUR è [NON MISURATA]**: due indici europei che
   aprono allo stesso minuto sommano frequenza **senza** sommare
   diversificazione. Il round r138a lo dichiarava e non lo chiude — ed è
   accademico, perché F40EUR è comunque bocciato per rischio.
7. **Questa lettura non promuove niente.** Taglie, rischio, accensioni e il conto
   reale **10105439** sono **[FIRMA DI CLAUDIO]**, sempre.

---

## 🎯 COSA AVVICINA UNA SEDIA SCHIERABILE (e cosa no)

**SÌ, con un numero di oggi:**
1. 🥇 **`r137c` — la riga da firmare.** *770101 `InpTP1_ClosePct` 50 → 0:
   PF OOS 1,39709 → 1,49140, DD OOS 7,2328% → 6,2719%, a parità di 193 posizioni,
   riprodotto sul binario del 12/09.* Meglio su **tutti e due gli assi**, in
   **tutte e due le finestre**. È la terza lettura indipendente della stessa
   cella (R120 del 09/09, setaccio del 12/09, questa). **Manca solo una firma.**
2. 🥈 **`r137a` — R5 sulla seconda sedia si chiude a costo zero** al pavimento di
   lavoro (68 idx): PF 1,39709 → 1,42020, dentro il rumore. Il prezzo del
   pavimento *severo* (p95) è **0,110 punti di PF**, e ora è un numero, non
   un'opinione.
3. 🥉 **`r136a/b/c/d` + `cemad02/05` — la sedia migliore della flotta ha il
   certificato quasi pieno**, e in più: la patch diagnostica dell'11/09 è
   **provata neutra sul trading** da **cinque riproduzioni indipendenti** della
   cella viva in una notte sola.

**NO, e va detto:**
- ❌ **`r138a`**: il gemello CAC ha la frequenza (0,551 pos/g, famiglia a 1,25)
  ma **il DD OOS è 11,82% contro un muro del 10%** e il merito è negativo su un
  campione leggibile. **Non entra.**
- ❌ **`q770be`**: il breakeven non tappa il buco della peggior giornata —
  **-1,0793% in tutte e quattro le celle**, miglioramento **0,0000 pp** contro
  una soglia di 0,05. Costa profitto e non compra niente. Il buco **resta aperto**
  e si scrive che resta aperto.
- 🚧 **La famiglia SuperWave/SupRev è ferma su un cancello di riproduzione**
  (r132c nullo, r126a grado C, r120b metro fallito). Prima di leggerne un PF va
  chiusa la questione della **dipendenza dal deposito**.

---

*13/09/2026 — lettura del backlog della notte 12/13-09. Nessun round eseguito,
nessun EA modificato, nessun preset toccato, perimetro di sola lettura rispettato.*
