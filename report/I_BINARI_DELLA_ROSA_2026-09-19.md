# 🔬 I BINARI DELLA ROSA — **quale codice gira davvero sotto le cinque sedie**

**19/09/2026** · branch `lavoro` · 🚫 **SOLA LETTURA**: nessun EA, nessun preset, nessun forward
toccato. Nessuna ricompilazione fatta né proposta di mia iniziativa. Il conto reale **10105439**
non è stato toccato in nessun modo.

**La domanda:** le quattro sedie della rosa (`report/LA_ROSA_PER_LA_PROP_2026-09-19.md`) più
`771531` girano in campo il codice che abbiamo validato, o un binario vecchio?

**La risposta in una riga:**

> ## 🔴 Su **otto** coppie sedia×terminale della rosa, **due** girano il codice a HEAD. Le altre **sei** girano agosto o luglio. E sul terminale dove vive **tutta** la rosa — il piccolo **50503392** — le sedie allineate sono **ZERO su cinque**.

---

## ⓪ 📏 IL RIGHELLO, dichiarato prima dei numeri (classe 456)

Due righelli, e non coincidono:
- **`wc -l`** (righe di contenuto) — è quello che usa MetaEditor in fondo alla finestra, ed è
  quello che usa lo script della toppa;
- **`CODA_06`** = `@($t -split "\`r?\`n").Count` (`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1`
  r.87) = **`wc -l` + 1**, sempre — sia che il file finisca con newline sia che non ci finisca.

👉 **In questo referto la colonna "righe" è `wc -l`**, e fra parentesi c'è il numero che stampa
`CODA_06`. Chi confronta con un log della coda usa il secondo.

**Fonti di campo:** `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260919_033003.log`
(corsa runner **19/09 03:30**, ora locale VPS) · `CODA_01_sedie_attaccate_20260919_033003.log`
(53 sedie, profilo attivo) · `CODA_03_conti_dei_terminali_20260919_033003.log` (conto ↔ cartella
dati, letto dai **giornali**, non da una tabella a mano).
**Fonte codice:** `git show <commit>:<file>` su tutta la storia dei sei sorgenti.

---

## ① 🗺️ LA TABELLA — sedia per sedia, terminale per terminale

| sedia | magic | terminale (conto · programma) | revisione IN CAMPO | data `.ex5` (locale VPS) | righe `wc -l` (CODA_06) | Guardian nel sorgente | **delta con HEAD** |
|---|---|---|---|---|---:|:--:|---|
| **SuperWave DOW H1 Ott** | `770511` | **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` | **`344a11b9`** · 04/08 | 06/08 19:33 | **563** (564) | ❌ no | 🔴 **+211 righe · 6 commit** |
| **MaxMinNotte DAX Short Ott** | `770411` | **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` | **`6074126d`** · 08/08 | 18/08 14:03 | **604** (605) | ❌ no | 🟠 **+15 righe · 1 commit** (solo Guardian) |
| **MaxMinNotte DAX Short Ott** | `770411` | **50504263** · `C:\Program Files\BCM Markets MT5 Terminal -V3` | **`5fc0bc31`** = **HEAD** | 19/08 23:10 | **619** (620) | ✅ SI | 🟢 **0 — ALLINEATA** |
| **MaxMinNotte ORO** | `770402` | **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` | **`08239510`** · **28/07** | 06/08 19:33 | **539** (540) | ❌ no | 🔴 **+379 righe · 5 commit** |
| **DAX Apertura EU** | `770101` | **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` | **`3af47ed9`** · 08/08 | 08/08 14:23 | **2132** (2133) | ❌ no | 🔴 **+235 righe · 5 commit** |
| **DAX Apertura EU** | `770101` | **50504263** · `C:\Program Files\BCM Markets MT5 Terminal -V3` | **`d83c1960`** · 19/08 | 19/08 23:09 | **2360** (2361) | ✅ SI | 🟠 **+7 righe · 1 commit** (solo C4) |
| **DAX Apertura EU** | `770101` | **10105439** · `C:\BCM_Reale` 🔴 **REALE** | **`9638318f`** = **HEAD** | 06/09 09:58 | **2367** (2368) | ✅ SI | 🟢 **0 — ALLINEATA** |
| **EMA200 Dow** | `771531` | **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` | **`344a11b9`** · 04/08 | 06/08 19:33 | **486** (487) | ❌ no | 🔴 **+204 righe · 4 commit** |

📌 **Dove sono attaccate** (`CODA_01` 19/09, profilo attivo): `770511`, `770402`, `771531` esistono
**solo** sul piccolo 50503392 (chart37, chart29, chart33). `770411` sta su piccolo (chart32) e
100k (chart03). `770101` sta su piccolo (chart30), 100k (chart01) e **reale** (chart01).

### 🟢 E la macchina di backtest è a HEAD, tutta
`C:\MT5_Backtest` (**50504400**), `.ex5` del **18/09**: DAX **2368**, EMA200 **691**, MaxMinNotte
**919**, MaxMin DAX Short **620**, SuperWave DOW **775**. 👉 **La divergenza è fra repo e VPS
operativo, non dentro il repo.** E per `770101` è **misurato** che il round che gli ha scritto il
contratto girava HEAD: `CODA_06` dell'**11/09** (giorno di R119) mostra la macchina di backtest con
DAX **2368** = `9638318f`, mentre il piccolo era ed è a **2133** = `3af47ed9`.

---

## ② 🧨 CHE COSA MANCA, MECCANISMO PER MECCANISMO

### `770511` SuperWave DOW H1 Ott — campo `344a11b9` (04/08)
| commit assente | data | cosa porta | peso |
|---|---|---|---|
| `3af47ed9` | 08/08 | sizing `OrderCalcProfit` al posto del tick value nudo | 🟠 **[NON MISURATO su U30USD]** |
| `6074126d` | 08/08 | export per-trade in `OnTester` | ⚪ non gira in forward |
| `7f80a87a` | 17/08 | `InpPendingAtr` / `InpSLBufferAtr` (default 0) | ⚪ inerte |
| `f8ebc321` | 19/08 | **Guardian B1+C1** | ⚪ sul piccolo · 🔴 su un conto prop |
| **`872dba82`** | **08/09** | 🧨 **pavimento del lotto minimo PRIMA di `lotPend`** | 🔴 **RISCHIO** |
| `b45dd009` | 11/09 | *«IN CORSO D'OPERA — NON COMPILARE»* | 🚫 non è un bersaglio |

🔴 Il difetto del lotto è **verificato nel vintage che gira**, non dedotto:
`git show 344a11b9:...SuperWave_DOW_H1_Ottimizzato.mq5` rr.234-236 —
`lotPend` calcolato **prima** del pavimento, e `if(lotMkt<=0) lotMkt=SYMBOL_VOLUME_MIN` **dopo**:
volume piazzato `totLot + volMin`, **fino al doppio del rischio dichiarato**.

> ✏️ **CORREZIONE a `LA_ROSA_PER_LA_PROP_2026-09-19.md`, e va detta perché è una misura attribuita
> alla sedia sbagliata.** Lì il **1,42% su contratto 1,0%** è scritto sotto `770511`. Il
> `report/DIARIO.md` del **20/08** lo attribuisce testualmente a **`SW DOW H2`, magic `770531`**
> (`ABTG_SuperWave` base, H4) — *«i due lati insieme hanno perso −72,32 su un bilancio di 5.076,62
> = 1,42% … contro un contratto (magic 770531) che dice 1,0%»*. 👉 **Il difetto è lo stesso ed è
> presente anche nel binario di `770511`** (stesso vintage, stesse tre righe), **ma la misura in
> campo è della gemella.** Per `770511` il numero è **[NON MISURATO]**.

### `771531` EMA200 Dow — campo `344a11b9` (04/08)
Mancano `3af47ed9` (sizing), `6074126d` (export), **`26a18566`** (19/08, Guardian) e `b45dd009` (WIP, non compilabile): **4 commit**.
🟢 **Ha** il fix del breakeven: `344a11b9` **è** il commit che lo ha introdotto.
🔴 **HEAD non è il bersaglio**: HEAD è `b45dd009` *«NON COMPILARE»*. L'ultimo stato passato dal
cancello è **`26a18566`** (552 righe / CODA 553).

### `770402` MaxMinNotte ORO — campo `08239510` (**28/07**, il più vecchio della flotta)
| commit assente | data | cosa porta | peso |
|---|---|---|---|
| **`d4da7d7a`** | **06/08 22:40** | 🧨 **breakeven indipendente dal parziale** | 🔴 **RISCHIO, ATTIVO** |
| `3af47ed9` | 08/08 | sizing | 🟠 non misurato su XAUUSD |
| `ec518d54` | 10/08 | export per-trade | ⚪ |
| `5fc0bc31` | 19/08 | Guardian | ⚪ piccolo · 🔴 prop |
| `7d0da9f9` | 03/09 | `InpOneTradePerDay` reso effettivo | 🟠 **cambia la FREQUENZA** |

🔴 Verificato nel vintage che gira (`git show 08239510:...MaxMinNotte.mq5` rr.300-303): il
`gPart1=true; if(InpBreakeven) PositionModify(...)` sta **dentro** il ramo del parziale riuscito, e
`NormVol(vol*50%)` a **0,01 lotti** torna **0**. 👉 **La sedia dell'oro gira a 0,01 lotti: il
parziale non parte mai, e con lui non parte lo stop in pari.** Tre ore e sette minuti fra la
ricompilazione di massa del 06/08 19:33 e il commit che lo chiudeva.
⚠️ E **`7d0da9f9` non è gratis**: il preset porta `InpOneTradePerDay=true`, quindi ricompilare HEAD
**riduce** la frequenza rispetto a quella con cui il contratto (R100, 23/08, ~3,7 posizioni/mese)
è stato misurato. **Va rimisurato prima, non dopo.**

### `770101` DAX Apertura EU — tre vintage su tre terminali
- **piccolo `3af47ed9`**: mancano `6074126d` (export per-trade, ⚪ non gira in forward), `c88d160a` (`InpAllowReverse`, opt-in, default false → inerte),
  **`bc110939`** (14/08, 🧨 **guardia A4 reload-safe**, caso reale del 14/08 16:17:43 a lotto 1,90),
  `d83c1960` (Guardian), **`9638318f`** (02/09, ✍️ **FIX C4 firmato**: `ABTG_DEF_RISK` 2.0→1.0).
  Verificato: nel sorgente in campo `#define ABTG_DEF_RISK 2.0` è ancora lì.
- **100k `d83c1960`**: manca **solo** il C4. 🔴 Latente: al primo **«Ripristina»** nella finestra
  input il default torna al **2%**, cioè il doppio del contratto.
- **reale `9638318f`**: 🟢 **zero delta**. Ha A4, Guardian e C4.

### `770411` MaxMinNotte DAX Short Ott — la sorpresa buona **e** quella cattiva
🟢 **Sul 100k è a HEAD**, Guardian compreso, e il Guardian su quel conto **gira davvero**
(`ABTG_Guardian 779001`, chart07). **È l'unica sedia della rosa che oggi gira, su un conto con la
rete accesa, esattamente il codice che sta in repo.**
🟢 Sul piccolo le manca **un commit solo** (`5fc0bc31`, che è **solo** l'aggiunta del Guardian:
`#include`, l'input e una riga di guardia — verificato nel diff). Ha già breakeven e sizing.

> ### 🔴 MA «ALLINEATA A HEAD» NON VUOL DIRE «SENZA DIFETTI», ed è una scoperta nuova di oggi
> **`InpOneTradePerDay` in `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` è DICHIARATO e MAI LETTO
> anche a HEAD**: `grep -c` = **1 occorrenza** (r.66, la sola dichiarazione). Il fix del **03/09**
> (`7d0da9f9`) è stato applicato ad `ABTG_MaxMinNotte` (5 occorrenze) e ad `ABTG_ORB_Ottimizzato`
> (6), **non alla variante `_Ottimizzato` del MaxMin, che è quella in campo su DUE conti.**
> 👉 Nuova **classe 462**.
>
> 🧪 **E il contro-esempio, perché il difetto non si gonfia**: il censimento del 18/09 attribuiva a
> «MAXMIN DAX» il **+25% di frequenza** misurato su `ABTG_ORB`. **Qui non regge**, e l'ho
> verificato nel codice: questo EA è **short-only** (`InpAllowLong=false`, r.71), piazza **un solo
> pendente**, e `gPhase` va `WAIT → PLACED → DONE` **senza mai tornare a WAIT dentro la giornata**
> (r.162 `ResetDay()` scatta solo al cambio di `day_of_year`). 👉 **Un ingresso al giorno c'è già,
> per costruzione.** Il difetto è di **etichetta** (il pannello promette una cosa che il codice non
> applica), **non di frequenza**: l'impatto sul numero di operazioni è **[NON MISURATO e
> strutturalmente limitato]**. Chiamarlo «+25%» sarebbe stato l'errore del 10/09.

> ✏️ **Seconda correzione al censimento del 18/09**: il difetto **#2 (breakeven)** era elencato per
> «MAXMIN ORO **e MAXMIN DAX**». 🟢 **Su MAXMIN DAX (`770411`) è FALSO**: quella sedia non gira
> `ABTG_MaxMinNotte.mq5`, gira `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`, e il suo vintage in
> campo (`6074126d`) **contiene già** la correzione del 07/08 — verificata riga per riga
> (`bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));`, il breakeven
> **fuori** dal ramo). **Il danno vero era su una sedia sola, non su due.**

---

## ③ 🩹 LA TOPPA PER TICKET DI OGGI — che cosa cambia e che cosa **non** cambia

Fatto dichiarato dalla sessione principale: i tre sorgenti `ABTG_Nasdaq_Apertura_US`,
`ABTG_DAX_Apertura_EU`, `ABTG_Dow_Apertura_US` sul **50503392** sono già stati **sostituiti**
(2032→2090, 2132→2190, 2064→2122 in `wc -l`), **ma l'F7 non è stato fatto**.
⚪ **Da qui non è verificabile**: la corsa `CODA_06` più recente è delle **03:30 di stamattina**,
cioè **prima** della sostituzione, e mostra ancora 2033/2133/2065. **La prova arriva col referto
delle 03:30 del 20/09.** Non lo stimo: lo dichiaro **non misurato**.

### 🔴 Quello che l'F7 porterà — e quello che NON porterà
Ho confrontato il file patchato con il vintage: `diff` fra
`git show 3af47ed9:mql5/Experts/ABTG_DAX_Apertura_EU.mq5` e
`backtest_pipeline/toppe_da_applicare/2026-09-19/ABTG_DAX_Apertura_EU.mq5` = **70 righe, tutte e
sole la toppa** (i due punti di chiamata + la funzione `ChiudiMiePosizioni`).

> ## 🔴 Quindi dopo l'F7 la sedia `770101` sul piccolo girerà **`3af47ed9` + 58 righe**: avrà la chiusura per ticket e continuerà a NON avere la **guardia A4**, il **Guardian** e il **FIX C4 firmato il 02/09**. Verificato: nel file patchato `#define ABTG_DEF_RISK 2.0` è ancora a r.78.

**La toppa non è un allineamento: è una toppa.** Chi legge «ricompilato il 19/09» nella colonna
`COMPILATO IL` del prossimo `CODA_06` leggerà una data fresca su **codice dell'8 agosto**.
👉 Nuova **classe 463**.

🟠 **Rilievo minore, già coperto dalla classe 456 ma non ancora corretto alla fonte**:
`backtest_pipeline/toppe_da_applicare/2026-09-19/LEGGIMI.md` r.44 dice che il referto notturno
«deve mostrare **2090 / 2190 / 2122** al posto di 2032 / 2132 / 2064». 🔴 **Con il righello di
`CODA_06` i numeri sono 2091 / 2191 / 2123 al posto di 2033 / 2133 / 2065.** Il referto della riga
(`report/RIGA_TOPPA_TICKET_50503392_2026-09-19.md` rr.126-131) **lo ha già corretto**; il
`LEGGIMI.md` che viaggia insieme ai sorgenti **no**. Chi verifica leggendo solo il LEGGIMI conclude
che la toppa non è entrata. ⚪ **Non tocco il file** (sola lettura): lo segnalo.

---

## ④ 🧪 I CONTRO-ESEMPI — ho provato a smontare le mie stesse identificazioni

**Ipotesi da battere: «il conteggio righe non identifica un bel niente».** Tre attacchi, tre esiti.

### (a) ❓ Esiste **un'altra revisione dello stesso file** con lo stesso conteggio?
✅ **NO, su tutte e otto le righe.** Ho ricostruito l'intera storia di ogni file con
`git show <commit>:<file> | wc -l` e il valore in campo compare **una volta sola**:

| file | valore in campo | tutti gli altri valori nella storia |
|---|---:|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | **563** | 555, 556, 577, 614, 621, 636, 645, 774 |
| `ABTG_EMA200` | **486** | 443, 465, 479, 500, 537, 552, 690 |
| `ABTG_MaxMinNotte` | **539** | 530, 531, 552, 566, 600, 615, 918 |
| `ABTG_MaxMinNotte_DAX_Short_Ott.` | **604** | 531, 532, 540, 540, 553, 567, 619 |
| `ABTG_DAX_Apertura_EU` | **2132 / 2360 / 2367** | 1224 … 2169, 2311, 2333 (28 revisioni, nessuna collisione) |

### (b) ❓ E se il file in campo fosse la copia **`standalone/`** (che per disegno non ha il Guardian)?
Era l'alternativa **seria**: spiegherebbe `GUARD = no` senza scomodare nessun vintage vecchio, ed è
persino suggerita dalla legenda di `CODA_06` (*«GUARD = no su un EA che nel repo ce l'ha vuol dire
albero standalone»*). ✅ **Non regge, e il numero lo uccide**: `mql5/Experts/standalone/` ha
`ABTG_EMA200` a **380** righe, `ABTG_MaxMinNotte` a **468**, `ABTG_DAX_Apertura_EU` a **1069** —
contro 486 / 539 / 2132 in campo. **Non è neanche vicino.** Le copie standalone hanno **un solo
commit ciascuna** (luglio) e non sono mai state aggiornate.

### (c) ❓ E se l'`.ex5` non venisse da quel `.mq5`? (nessun hash, buco noto)
Resta **non chiuso crittograficamente** — e lo dichiaro come nel censimento del 18/09. Ma la
**finestra temporale** regge su tutte e otto: ogni `.ex5` cade fra il commit identificato e il
successivo che tocca lo stesso file (log in ora locale VPS = UTC+2 ad agosto, commit in UTC):

| sedia · terminale | commit (UTC) | `.ex5` (UTC) | commit successivo (UTC) | dentro? |
|---|---|---|---|:--:|
| `770511` · piccolo | 04/08 17:39 | 06/08 **17:33** | 08/08 11:48 | ✅ |
| `771531` · piccolo | 04/08 17:39 | 06/08 **17:33** | 08/08 11:48 | ✅ |
| `770402` · piccolo | **28/07** 13:44 | 06/08 **17:33** | 06/08 **22:40** | ✅ per **5h07m** |
| `770411` · piccolo | 08/08 18:23 | 18/08 **12:03** | 19/08 07:50 | ✅ |
| `770411` · 100k | 19/08 07:50 | 19/08 **21:10** | *(nessuno: è HEAD)* | ✅ |
| `770101` · piccolo | 08/08 11:48 | 08/08 **12:23** | 08/08 18:23 | ✅ per **6h00m** |
| `770101` · 100k | 19/08 07:52 | 19/08 **21:09** | 02/09 07:15 | ✅ |
| `770101` · reale | 02/09 07:15 | 06/09 **07:58** | *(nessuno: è HEAD)* | ✅ |

🎯 **Due finestre strettissime** (5h07m e 6h00m) e nessuna violazione su otto: se i `.ex5` venissero
da sorgenti diversi non ci sarebbe **nessuna ragione** perché cadessero tutti lì dentro.

### (d) ❓ E il righello: `CODA_06` conta davvero sempre uno in più?
✅ **Sì, e vale anche per i file senza newline finale** — verificato sulla semantica di
`-split "\`r?\`n"`: `"a\nb\n"` → 3 elementi (`wc -l`=2), `"a\nb"` → 2 elementi (`wc -l`=1). **In
entrambi i casi `+1`.** Non c'è il caso in cui i due righelli coincidano, quindi il confronto non è
ambiguo. ✅ Prova indipendente già in casa: DAX sulla macchina di backtest, `wc -l`=2367 ↔ log 2368.

### (e) ❓ «Il Guardian manca» è un guasto?
🟢 **NO sul piccolo 50503392, ed è una DECISIONE FIRMATA**, non una dimenticanza:
`HANDOFF.md` rr.129-138, Claudio 06/09 notte — *«NIENTE Guardian sul piccolo… il piccolo è lo
strumento di misura, non il conto da proteggere»*. Confermato dal campo: in `CODA_01` del 19/09
**nessun `ABTG_Guardian` è attaccato sul 50503392** (40 sedie elencate per nome), mentre c'è sul
100k (`779001`) e sul reale (`779002`). E `mql5/Include/ABTG_PausaGuardian.mqh` rr.54-56 dichiara
il **fail-open**: lì il Guardian sarebbe **inerte anche se lo si ricompilasse**.
🔴 **Diventa un guasto il 1° ottobre**, quando queste sedie passano su un conto prop dove la rete
serve davvero.

---

## ⑤ 🎯 **COSA MANCA PER SCHIERARLA IL 1° OTTOBRE** — sedia per sedia

| sedia | è pronta? | cosa manca, esattamente |
|---|:--:|---|
| **`770101` DAX Apertura EU** | 🟢 **CODICE PRONTO** | Il bersaglio (`9638318f` = HEAD) **esiste già compilato** sul reale e sulla macchina di backtest, ed è **la stessa revisione con cui è stato misurato il contratto** (R119, 11/09). Manca: **una ricompilazione** sul terminale prop + ✍️ **la taglia** (`InpRiskPercent`) e la scelta BREAKOUT/RETEST. |
| **`770411` MaxMin DAX Short** | 🟢 **CODICE PRONTO** | `5fc0bc31` = HEAD, **già in campo sul 100k** e già compilato sulla macchina di backtest. Manca: **una ricompilazione** sul terminale prop + ✍️ **la taglia**. ⚠️ Da sapere: `InpOneTradePerDay` resta un'etichetta che il codice non legge (classe 462) — **non cambia il comportamento misurato**, ma il pannello mente. |
| **`770402` MaxMinNotte ORO** | 🟠 **SERVE UNA MISURA** | Il bersaglio (HEAD `7d0da9f9`) **cambia la frequenza**: rende effettivo `InpOneTradePerDay`, che nel preset è `true`. Il contratto (DD 10,0% a 0,5%, ~3,7 posizioni/mese, R100 del 23/08) è stato misurato **prima** di quel commit. 👉 **Una corsa di controllo della stessa cella sul binario nuovo**, poi ricompilazione. E il breakeven cieco oggi in campo è 🔴 **RISCHIO ATTIVO**. |
| **`770511` SuperWave DOW H1** | 🟠 **SERVE UNA FIRMA + UNA MISURA** | HEAD è `b45dd009` *«NON COMPILARE»*: il bersaglio giusto è **`872dba82`** (08/09), che è anche quello che porta il fix del lotto. 🔴 **Quella revisione non è mai stata compilata da nessuna parte** (la macchina di backtest ha `b45dd009`). Serve: ✍️ **una firma** (nessuna firma autorizza oggi questa ricompilazione) + una corsa di controllo + ricompilazione. |
| **`771531` EMA200 Dow** | 🟠 **SERVE UNA FIRMA + UNA MISURA** | Stessa forma: HEAD è `b45dd009` *«NON COMPILARE»*, bersaglio **`26a18566`** (19/08), **mai compilato da nessuna parte**. Serve: ✍️ firma + corsa di controllo + ricompilazione. 🟢 A favore: è l'unica che passa tutti i cancelli alla lettera (PF OOS 1,52 · n=517 · 30/30 PASS). |

### 📊 Il conto, in chiaro
- **Sedie della rosa che oggi girano in campo codice allineato a HEAD: 2 coppie su 8** —
  `770411`@100k e `770101`@reale.
- **Sul piccolo 50503392, dove vive TUTTA la rosa: 0 su 5.**
- **Sedie con un bersaglio di codice pronto e già collaudato dal compilatore: 2** (`770101`,
  `770411`).
- **Sedie che hanno bisogno di una firma nuova prima ancora di poter essere compilate: 2**
  (`770511`, `771531`).
- **Sedie che hanno bisogno di una MISURA nuova perché il codice giusto cambia il contratto: 2**
  (`770402`, e `770511`/`771531` per il fix del lotto e il Guardian).

---

## ⑥ ✋ I GESTI MANUALI CHE SERVONO A CLAUDIO, in ordine

🔴 **Regola dei terminali multipli (06/09 + emendamento 12/09): ogni gesto porta il numero di conto
e la cartella in chiaro.** Sul VPS convivono **SETTE** cartelle dati.

| # | gesto | 🖥️ dove, per esteso | chi | stato |
|---:|---|---|---|---|
| **1** | **F7** su `ABTG_Nasdaq_Apertura_US.mq5`, `ABTG_DAX_Apertura_EU.mq5`, `ABTG_Dow_Apertura_US.mq5` (la toppa per ticket già copiata) | 🪟 MT5 **50503392** · `C:\Program Files\BCM Markets MT5 Terminal` — 🚫 **NON** `-V3` (50504263), **NON** `C:\BCM_Reale` (**10105439**), **NON** `C:\MT5_Backtest` (50504400), **NON** `C:\MT5_MANUALE`, **NON** Pepperstone, **NON** Tickmill | ✍️ **Claudio** | ✅ **GIÀ FIRMATO** — `report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md` §④ passo 5 |
| **2** | *(niente da fare: verifica automatica)* leggere `CODA_06` del **20/09 03:30**: deve stampare **2091 / 2191 / 2123** al posto di 2033 / 2133 / 2065 | 🖥️ nessun gesto — lo fa il runner | 🤖 | in attesa |
| **3** | ✍️ **decidere il bersaglio di `770402`**: HEAD `7d0da9f9` cambia la frequenza → autorizzare **prima** una corsa di controllo sulla macchina di backtest | 🖥️ **PC/terminale di backtest 50504400** · `C:\MT5_Backtest` (nessun conto vivo) | ✍️ **Claudio** (firma) + 🤖 (corsa) | **da chiedere** |
| **4** | ✍️ **firma nuova** per compilare `872dba82` (SuperWave `770511`) e `26a18566` (EMA200 `771531`): oggi **nessuna firma le copre**, e quelle due revisioni non sono mai state compilate | — | ✍️ **Claudio** | **da chiedere** |
| **5** | 🔴 **il C4 sul 100k**: `770101` su **50504263** è a `d83c1960` e un «Ripristina» nella finestra input rimette il rischio al **2%**. Finché non si ricompila, **non premere «Ripristina»** su quel grafico | 🪟 MT5 **50504263** · `C:\Program Files\BCM Markets MT5 Terminal -V3` — ✋ **avvertenza, NON un'azione** | ✍️ **Claudio** (consapevolezza) | 🔴 **latente oggi** |
| **6** | ✍️ **le taglie** (`InpRiskPercent` per sedia) e **la scelta della prop** (FTMO 1:15 / FundedNext 1:25) | — | ✍️ **Claudio**, esclusivo | aperto |

🚫 **Nessun gesto su `C:\BCM_Reale` (10105439).** Quel terminale oggi è il **più allineato di
tutti** (`770101` a HEAD, `ORB_Ottimizzato` v1.04): non ha bisogno di niente, e il suo perimetro
resta chiuso per firma.

---

## ⑦ 🕳️ NON COPERTO — dichiarato, non nascosto

1. 🔴 **Nessun hash degli `.ex5`**, come il 18/09. L'identificazione è **circostanziale forte**
   (conteggio univoco + versione + presenza Guardian + finestra temporale), **non crittografica**.
   Per chiuderla servirebbe un `Get-FileHash` in campo contro una compilazione di controllo — e
   MetaEditor **non è bit-riproducibile**, quindi non è chiudibile a posteriori nemmeno così.
2. ⚪ **Che la toppa per ticket sia davvero entrata sul 50503392 NON è verificabile da qui**: il
   `CODA_06` più recente è delle 03:30, precedente alla sostituzione. Prova attesa: **20/09 03:30**.
3. ⚪ **I tre file patchati non sono MAI stati compilati** (dichiarato dal loro LEGGIMI): il primo
   F7 è anche il primo test di compilazione. Se dà errore, non è una sorpresa.
4. 🟠 **La revisione con cui sono stati misurati i contratti di `770511`, `770402` e `771531` non è
   misurabile**: i referti `CODA_06` in repo partono dal **07/09**, i round che hanno scritto quei
   contratti sono di **luglio-agosto**. Per `770101` **è** misurata (R119 dell'11/09 ↔ `CODA_06`
   dell'11/09: macchina di backtest a 2368 = HEAD). Per gli altri: **[NON MISURATO]**.
5. 🟠 **Il fix di sizing `3af47ed9` non è misurato su U30USD / XAUUSD / D30EUR** (è misurato su
   225JPY). Resta il buco già aperto al §④.2 del censimento del 18/09.
6. ⚪ **Non ho guardato le altre 85 righe del 50503392** né le sedie fuori rosa: il compito erano le
   cinque.
7. ⚪ **`CODA_11`** (canali e attività) non aggiunge niente a questa domanda: non esiste nessuna
   attività pianificata che ricompili o sostituisca EA sui terminali vivi. **Il campo si aggiorna
   solo a mano.**

---

## ⑧ 📌 Classi NUOVE depositate in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`
- **462** — il fix di **famiglia** applicato al file **generico** e non alla variante
  `_Ottimizzato` **che è quella in campo**; e il censimento eredita l'errore attribuendo alla sedia
  i difetti del file che **non gira**.
- **463** — dopo una toppa **retro-applicata a un vintage**, il binario in campo **non corrisponde a
  nessun commit**: il righello delle righe smette di identificare, e la data dell'`.ex5` lo fa
  sembrare fresco.

---
*Fonti, per nome: `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260919_033003.log` ·
`CODA_03_conti_dei_terminali_20260919_033003.log` · `CODA_06_quale_codice_gira_20260919_033003.log`
(e le corse dell'11/09 e 16/09 per la macchina di backtest) ·
`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` r.87 (il righello) ·
`git show` su tutta la storia di `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`, `ABTG_EMA200.mq5`,
`ABTG_MaxMinNotte.mq5`, `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`, `ABTG_DAX_Apertura_EU.mq5` ·
`mql5/Experts/standalone/` (il contro-esempio (b)) ·
`backtest_pipeline/toppe_da_applicare/2026-09-19/` (i tre sorgenti patchati + LEGGIMI) ·
`report/CENSIMENTO_BINARI_50503392_2026-09-18.md` · `report/LA_ROSA_PER_LA_PROP_2026-09-19.md` ·
`report/TOPPA_CHIUSURA_PER_TICKET_2026-09-19.md` · `report/RIGA_TOPPA_TICKET_50503392_2026-09-19.md` ·
`report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md` · `report/FIX_LOTTO_PENDENTE_2026-09-08.md` ·
`report/DIARIO.md` (20/08, il 1,42% di `770531`) · `report/CONTRATTI_SEDIE.md` ·
`HANDOFF.md` rr.129-138 · `mql5/Include/ABTG_PausaGuardian.mqh` rr.54-56 · `mql5/Presets/*.set`*
