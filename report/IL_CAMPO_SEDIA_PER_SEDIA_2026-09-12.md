# 🔬 CHE CODICE GIRA DAVVERO, SEDIA PER SEDIA — 12/09/2026

> **Sola lettura.** 51 sedie, ognuna agganciata a un **commit preciso** — non a
> un'impressione. Nasce dal buco **B6** di `A3_IL_DD_DELLA_771531`: *"il DD della
> candidata migliore e' stato misurato con un codice che non e' quello in campo"*.
> Quella frase adesso ha un numero **per ogni sedia**.

---

# 🏆 LA NOTIZIA GROSSA, e va detta per prima

## 💰 IL CONTO CON I SOLDI (10105439) È PULITO: **4 sedie su 4 girano il repo di oggi, al centesimo di riga.**

| sedia | EA | campo | repo | verdetto |
|---|---|---|---|---|
| **770101** DAX | `DAX_Apertura_EU` | v1.01 (`9638318`, 02/09) | v1.01 | 🟢 **allineato** |
| **770611** ORB | `ORB_Ottimizzato` | v1.04 (`19312c8`, 03/09) | v1.04 | 🟢 **hedge-safe incluso** |
| 779002 | `Guardian` | v1.12 | v1.14 | 🟢 divario **innocuo** (vedi §3) |
| — | `SlippageLogger` | v1.00 | v1.00 | 🟢 allineato |

🎯 **E una sedia ha il contratto che descrive davvero l'oggetto in campo**:
**`770611` sul reale** — DD 6,5389% OOS, n 119 **posizioni**, codice ✅,
taglia 0,65% ✅. **Una su 51, ma c'e'.**

---

## 🔴 IL CONTO CHE SIMULA LA CHALLENGE (50504263) È FERMO AL 19-22 AGOSTO

E porta **tre difetti gia' riparati altrove**:

| sedia | cosa manca | perche' morde |
|---|---|---|
| **770611** ORB | 🔴 **fix HEDGE-SAFE assente** (v1.02 contro v1.04) | gestisce e chiude per `_Symbol`, e il vicino sullo stesso U30USD e' **confermato** (`Dow_Apertura_US` 770202) su conto **HEDGING** |
| **770901** STREV | 🔴 **LOTTO DOPPIO** (`872dba8` assente) | misurato in campo **1,42%** su un contratto dell'**1,0%** |
| **779001** Guardian | 🔴 baseline da **saldo** invece che da equita' | meta' neutralizzato da `InpStartBalance` esplicito nel preset |

🔴 **E il 100k e' il conto su cui si prova la challenge.**

---

## 🧪 IL PICCOLO (50503392): 40 sedie, e **NON sono "tutte vecchie uguali"**

| scaglione | quante | verdetto |
|---|---:|---|
| 🟢 **A — allineate al repo** | **5** | ORB, i tre PostNews, TradeExporter |
| 🟠 **B — hanno il fix sizing, manca solo il filo del Guardian** | **17** | 👉 **differenza reale: ZERO** (vedi §3) |
| 🔴 **C — binario PRIMA di un fix che tocca i soldi** | **18** | le loro misure di rischio vanno lette sapendolo |

🟢 **Quindi 22 su 40 sono a posto o indistinguibili.** Il titolo *"il campo e'
fermo ad agosto"* era vero e **troppo grosso**: la meta' di quel campo e'
identica a quello che avremmo ricompilando.

---

# 2. 🚨 E UNA COSA VIVA **ADESSO NEL REPO**, trovata per strada

`ABTG_Nasdaq_Apertura_US.mq5` **riga 47**:

    #define ABTG_DEF_RISK         2.0    // rischio max 2% (money management del piano)

Il **gemello DAX** ha lo stesso `#define` a **1.0**, e accanto c'e' scritto
**perche'** (`ABTG_DAX_Apertura_EU.mq5:90`):

> *"02/09: era 2.0. **Il default compilato era il DOPPIO del contratto (1,0%) e
> della riga rossa A4: ogni RIPRISTINA rimetteva il 2%.** FIX firmato C4."*

🔴 **Quel fix, sul Nasdaq, non e' MAI stato fatto**: `git log -S` su quella
stringa torna **vuoto**. Il commit `9638318` lo ha fatto **solo** sul DAX.

**Cosa significa in campo**: la sedia **770250** e' viva e gira a **0,35%**
grazie al suo preset (`ABTG_GatedShort_NASUSD_770250_LIVE.set` r.44). 🟢 Finche'
il preset e' caricato, **e' coperta**. 🔴 Ma il difetto che il fix C4 riparava
era **esattamente** *"ogni RIPRISTINA rimetteva il 2%"*: un click su
**Ripristina** nella finestra degli input riporta il default — cioe' **2,0%,
che e' 5,7 volte la taglia con cui quella sedia gira**.

> ⚠️ **Non l'ho toccato, ed e' voluto: e' un parametro di RISCHIO, e quelli sono
> di Claudio.** Qui c'e' la segnalazione, non la modifica. Il gemello DAX dice
> gia' come si fa e chi l'ha firmato.

---

# 3. 🧪 I CONTRO-ESEMPI — e **uno mi ha corretto una regola scritta stanotte**

### ✏️ CORREZIONE: *"la versione e' l'identificatore giusto"* era **mezza vera**

Stanotte, nel referto sul Guardian, ho scritto che il conteggio delle righe non
identifica e la **versione** si'. **Misurato: non basta nemmeno quella.**

| prova | esito |
|---|---|
| *"stessa versione = stesso codice"* | 🔴 **FALSO**: `DAX_Apertura_EU` sul 100k e' **v1.01 come il repo**, ma **2361 righe contro 2367** e porta `DEF_RISK 2.0` invece di `1.0` |
| *"allora conta il numero di righe"* | 🔴 **FALSO anche quello**: il `Guardian` del reale ha **386 righe di scarto** e comportamento **identico** |

> ## 👉 **Versione + righe insieme identificano il COMMIT. Ma per giudicare se la differenza MORDE serve il DIFF. Sempre.**
> 📌 E il contrasto che chiude il ragionamento: `872dba8` e' **+11/−2 righe** —
> piu' piccolo del filo del Guardian — **e raddoppia il lotto**. **Non e' la
> dimensione del diff a decidere: e' cosa tocca.**

### ✅ I quattro casi dove la differenza c'e' e **non cambia niente**
(cercati apposta: se non ne trovassi nemmeno uno su 51, starei classificando male)

1. 🥇 **Le 14 sedie "+3 righe" del piccolo**: il commit aggiunge **un `#include`,
   un `input bool InpUsaGuardian = true`, una chiamata**. Zero righe su sizing,
   stop, uscita. E **sul piccolo il Guardian NON GIRA** (`CODA_09`: *"GUARDIAN:
   nessuna riga"* sia l'11 sia il 12/09, su un log da 432 righe — quindi non e'
   un log vuoto). 👉 **Anche ricompilando, il comportamento sarebbe IDENTICO.**
2. 🥈 **`Guardian` v1.12→v1.14 sul REALE**: 386 righe, tutte dietro **default
   spenti** verificati uno per uno. 👉 **Il conto reale non sta perdendo nessuna
   protezione attiva.**
3. 🥉 **`Dow_Apertura_US`**: stesso commit del gemello DAX, ma il suo `DEF_RISK`
   e' **1.0 dall'origine**. 👉 **Prova che il difetto e' per-FILE, non "il campo
   e' vecchio".**
4. **`Gold_Ichimoku`**: unico commit successivo = le solite +3 righe di Guardian,
   su un terminale dove nessun Guardian gira. **Differenza reale: zero.**

### 🟢 E la validazione incrociata che rende il match un fatto
La colonna `GUARD` del log del runner — prodotta da un **grep indipendente** su
`InpUsaGuardian` — **combacia al 100%** con i blob dei commit pescati da me.
**Due strumenti diversi, stessa risposta.**

---

# 4. 🔴 IL CONTRATTO DESCRIVE L'OGGETTO IN CAMPO?

| risposta | sedie |
|---|---:|
| 🟢 **SI** | **1** |
| 🟠 **NON MISURATO, ma il codice e' allineato** (manca taglia o deposito) | 5 |
| 🔴 **NO, e il CODICE e' una delle cause** | **~34** |
| 🔴 **nessun contratto esiste** | 4 |
| ⚙️ senza contratto per disegno | 7 |

### 🪦 Le tre dove il contratto misura un ALTRO oggetto
1. **`770402` MaxMinNotte oro** — binario del **28/07**: **+533/−369 righe** di
   scarto, manca il breakeven **e** il sizing. 👉 Il **19,72%** del contratto
   **non descrive niente di cio' che gira**. *(E' la stessa sedia di
   `R134_SCATOLA_NOTTE`: due difetti indipendenti sullo stesso posto a sedere.)*
2. **`771531` EMA200 Dow** — 🎯 **il buco B6 e' confermato e ora DATATO AL
   GIORNO**: il binario del 06/08 sta **fra `344a11b` (04/08) e `3af47ed`
   (08/08)**, cioe' **prima del fix di sizing**. Il 7,8323% e' misurato col
   codice di dopo.
3. **`770611` ORB sul 100k** — contratto 9,92%, binario **641 righe indietro**,
   senza hedge-safe e col vicino confermato.

---

# 5. 🕳️ BUCHI DICHIARATI

1. 🔴 **Nessuna prova diretta del contenuto di un `.ex5`**: si misura il `.mq5`
   accanto piu' la data del binario. Su **69 sorgenti su 70** l'`.ex5` e' uguale
   o piu' recente del commit. **L'eccezione**: il `Guardian` del piccolo ha il
   `.mq5` del 18/08 e l'`.ex5` del **09/08** — **nove giorni PRIMA**. Quel
   binario **non ha mai avuto il cap 3,25%**. *(Ininfluente li': non gira.)*
2. 🔴 **`BREAKOUT_EA_JPY_v3`**: nel repo **quel nome non esiste**. `[NON COPERTO]`
   — non si indovina.
3. ⚠️ **Il repo HEAD di oggi NON e' un bersaglio di ricompilazione**: `b45dd00`
   tocca 10 EA vivi ed e' titolato **"IN CORSO D'OPERA — NON COMPILARE"**.
4. 🔴 **Sul REALE le soglie del Guardian sono `[NON MISURATO]`**: il Guardian
   **batte** (`eq=7511.13 dayLoss=-0,05% stato=OK`), ma se fosse partito senza
   preset girerebbe sui default **5,0 / 10,0 / reset 0** invece delle firme
   **4,9 / 9,9 / 23**. 👉 **E' una lettura da trenta secondi e non e' mai stata
   fatta.**
5. 📌 `CODA_06` del 10, 11 e 12/09 sono **identici byte per byte** tranne la
   data: **il campo non si muove da tre giorni.**

---

## 🧭 IN UNA RIGA
🟢 **Il conto con i soldi gira il repo di oggi.** 🔴 Il conto che simula la
challenge e' fermo al 19-22 agosto con tre difetti gia' riparati altrove.
🟠 Sul piccolo 18 sedie su 40 girano un binario precedente a un fix che tocca i
soldi — **ma 22 su 40 sono indistinguibili dal repo**, e questo il titolo
*"il campo e' fermo ad agosto"* non lo diceva.

*Misura prodotta da un agente in sola lettura. Il `DEF_RISK 2.0` ancora vivo nel
repo, il fix C4 mai replicato sul Nasdaq e il preset che oggi copre la sedia li
ho verificati io, file e riga.*
