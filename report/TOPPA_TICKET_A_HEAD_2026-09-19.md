# 🩹 LA TOPPA "CHIUSURA PER TICKET" ENTRA A **HEAD** — i tre Apertura

**19/09/2026** · branch `lavoro` · **lettura statica, NESSUNA compilazione** (qui non c'è
MetaEditor) · prerequisito della partenza prop di **lunedì 21/09 con sei sedie**

---

## 🎯 IN UNA RIGA
I tre `ABTG_*_Apertura_*` a HEAD chiudevano **per SIMBOLO**: su conto HEDGING quella chiamata
chiude la posizione **più vecchia del simbolo, di chiunque sia**. Ora chiudono **per TICKET**,
filtrando sul proprio `InpMagic`. 🟢 **Occorrenze in codice eseguibile: 2 → 0 su tutti e tre.**

---

## 🔴 IL DIFETTO, e perché mordeva lunedì

`gTrade.PositionClose(_Symbol)` passa per `PositionSelect(simbolo)`, che su **HEDGING**
seleziona la posizione **più vecchia** del simbolo — non la nostra
(`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.39).

E la guardia che c'era **peggiorava le cose invece di salvarle**:
`if(SelectMyPosition()) gTrade.PositionClose(_Symbol);` — `SelectMyPosition()` è
**già hedge-safe** (scorre per ticket e filtra sul magic), quindi l'EA **trovava la PROPRIA**
posizione, decideva di chiuderla… e **chiudeva quella del vicino**.

**E non ne chiudeva una: le chiudeva a catena.** Verificato riga per riga su HEAD
(`ABTG_DAX_Apertura_EU.mq5`, numeri di riga PRIMA della toppa):

| riga | codice | conseguenza |
|---|---|---|
| 2209 | `void OnTick() { ABTG_OnTick(); }` | il corpo gira **a ogni tick** |
| 673-677 | `if(TimeInMinutes(now) >= InpCloseHour*60 + InpCloseMin) { EndOfSession(); return; }` | 🔴 **nessuna guardia di stato**: dopo l'ora di chiusura `EndOfSession()` riparte **a ogni tick** |
| 2108 | `gPhase = PH_DONE;` | lo stato **viene scritto ma non viene mai letto** dal cancello di r.673 |

👉 Finché la NOSTRA posizione esisteva, `SelectMyPosition()` restava vera e la chiusura per
simbolo ripartiva: **un vicino per tick**, dal più vecchio in giù, finché la nostra non
diventava la più vecchia.

### La mappa dei conflitti sul conto prop
- **D30EUR** — `770101` (DAX Apertura, col difetto) + `770411` (MaxMin DAX Short, **già per
  ticket**) → 770101 poteva chiudere la posizione di 770411.
- **U30USD** — `770202` (Dow Apertura, col difetto) + `771531` (EMA200) + `770511` (SuperWave)
  → 770202 poteva chiudere le loro.

---

## 🔧 LA TOPPA, tre modifiche e basta

Portata a mano dal patchato collaudato (`backtest_pipeline/toppe_da_applicare/2026-09-19/`,
base **vintage `3af47ed9`**) su HEAD, che **non è il vintage**: HEAD ha in più la guardia A4, il
Guardian e il FIX C4. 🟢 **I due siti d'intervento sono però byte-identici fra vintage e HEAD**
— verificato — quindi il porting è stato meccanico e non interpretativo.

### A) flatten notizie (DAX r.669 · Dow r.609 · Nasdaq r.697)
```diff
-      if(SelectMyPosition()) gTrade.PositionClose(_Symbol);
+      ChiudiMiePosizioni("blackout notizie");   // TOPPA 19/09: per TICKET, non per simbolo
```

### B) `EndOfSession()` (DAX r.2103 · Dow r.1934 · Nasdaq r.2353)
```diff
-   if(InpCloseAtEnd && SelectMyPosition())
-     {
-      gTrade.PositionClose(_Symbol);
-      ABTGLog("fine sessione: posizione chiusa.");
-     }
+   // TOPPA 19/09: per TICKET, non per simbolo. ChiudiMiePosizioni() ha gia'
+   // dentro la guardia (se non abbiamo niente non chiama niente) e chiude
+   // ENTRAMBE le nostre quando il whipsaw ha riempito tutti e due i lati.
+   if(InpCloseAtEnd)
+      ChiudiMiePosizioni("fine sessione");
```

### C) la funzione nuova, ancorata a `bool HasOpenPosition()`
58 righe (commento + `int ChiudiMiePosizioni(const string motivo)`): fotografa **prima** i
ticket propri (`POSITION_SYMBOL == _Symbol && POSITION_MAGIC == InpMagic`), **poi** li chiude
con `gTrade.PositionClose(ticket)`. La lista si legge **una volta sola**: un
`while(SelectMyPosition())` sarebbe un ciclo su una lettura che il terminale aggiorna in modo
**asincrono** → ciclo infinito e doppia chiusura.

🟢 **Non c'è niente di inventato**: è la stessa forma **già in campo** in
`ABTG_ORB_Ottimizzato` v1.04 (`ChiudiPosizioniMie`, r.1001), e ogni primitiva usata
(`%I64u`, `ResultRetcodeDescription`, `ArrayResize`, `StringFormat`) era **già usata a HEAD**
in questi stessi tre file.

---

## ⚠️ QUELLO CHE LA TOPPA **NON** FA — detto, non inventato

🔴 **La toppa NON aggiunge la guardia sul ripetersi a ogni tick.** Il cancello di r.673 resta
senza `if(gPhase != PH_DONE)`: dopo l'ora di chiusura `EndOfSession()` continua a girare a
ogni tick. **Non l'ho aggiunta**, per due ragioni dette prima e non dopo:
1. **non c'è nella toppa collaudata** — e il mandato dice di portare quella, non di scriverne
   una nuova;
2. **cambierebbe comportamento** oltre la chiusura (tocca anche `CancelMyPendings()`), e il
   vincolo di questo giro è: nient'altro si muove.

🟢 **Ma la ripetizione non è più pericolosa, ed è il punto.** Prima la ripetizione **era**
l'arma (un vicino per tick). Ora, quando non abbiamo posizioni, `ChiudiMiePosizioni()` trova
`q = 0` e **non emette NESSUNA chiamata di trade**: resta un giro a vuoto su
`PositionsTotal()`, cioè CPU, non ordini. E `CancelMyPendings()` (definita a r.1833, chiamata
da `EndOfSession()` a r.2101) era **già** per-ticket e filtrata sul magic. 👉 Dopo la toppa, `EndOfSession()` **non tocca più nulla che
non sia nostro**, nemmeno ripetendosi.

---

## 🧪 IL CONTRO-ESEMPIO (obbligatorio) — e quello che NON avrebbe smascherato niente

**Scenario costruito apposta per rompere una correzione incompleta**: due posizioni su
**D30EUR**, magic diversi, **la più vecchia NON è la nostra**.

| ticket | aperta | magic | di chi |
|---|---|---|---|
| **#1000** | 02:00 | `770411` | 🔵 il VICINO (MaxMin DAX Short) |
| **#2000** | 09:05 | `770101` | 🟢 la NOSTRA (DAX Apertura) |

### Lettura riga per riga, **PRIMA** (HEAD col difetto)
1. r.673 — è passata l'ora di chiusura → `EndOfSession()`.
2. r.2103 — `InpCloseAtEnd` è `true` (r.256) e `SelectMyPosition()` scorre `PositionsTotal()-1…0`,
   trova **#2000** col magic 770101 → **vera**.
3. r.2105 — `gTrade.PositionClose(_Symbol)` → `PositionSelect("D30EUR")` → **la più vecchia** →
   🔴 **chiude #1000, quella del VICINO.**
4. tick successivo: r.673 non ha guardia, si riparte; `SelectMyPosition()` è ancora vera (#2000
   è nostra e viva) → chiude #2000. **Bilancio: due morti, e la prima era del vicino.**

### Lettura riga per riga, **DOPO** (HEAD con la toppa)
1. r.673 → `EndOfSession()`; r.2106 `if(InpCloseAtEnd)` → `ChiudiMiePosizioni("fine sessione")`.
2. r.2164-2169 — il ciclo di raccolta: **#2000** ha `POSITION_MAGIC == InpMagic` → entra in
   `miei[0]`; **#1000** ha magic 770411 → **scartato**, `q = 1`.
3. r.2172-2176 — `gTrade.PositionClose(miei[0])` → overload **per ticket**
   (`PositionSelectByTicket`) → ✅ **chiude #2000, la NOSTRA**. #1000 non viene mai nominata.
4. tick successivo: il ciclo trova `q = 0` → **zero chiamate di trade**. 🟢 **Il vicino
   sopravvive.**

### 🔬 E il contro-esempio del contro-esempio: la configurazione che **MASCHERA** il bug
Se la **nostra** fosse la più vecchia (#1000 nostra, #2000 del vicino), il codice **col
difetto** chiuderebbe… **la nostra**, cioè la cosa giusta, **per caso**. Prima e dopo darebbero
lo **stesso** risultato.
👉 **Un collaudo costruito solo su quel layout avrebbe certificato "tutto a posto" su un EA
rotto.** È il motivo per cui il difetto è sopravvissuto finché su quel simbolo c'era **una
posizione sola**: il caso che lo smaschera pretende **il vicino più vecchio**.

Il modello eseguibile dei due comportamenti (ipotesi dichiarata: `PositionSelect(simbolo)` su
hedging = la più vecchia) stampa esattamente i quattro esiti qui sopra.
🔴 **È un modello in Python, NON MetaTrader: la prova vera resta il primo F7 + una corsa.**

---

## 📊 IL NUMERO DI OPERAZIONI CAMBIA? (il vincolo del mandato)

**No, e qui c'è il ragionamento, non un'impressione.**

- **Nel tester** gira **un EA solo**: tutte le posizioni sul simbolo sono nostre → l'insieme
  chiuso è **identico**. In generale il codice nuovo chiude un **sottoinsieme** (solo le
  nostre) di quello vecchio: **mai di più**.
- ⚠️ **L'unico caso in cui qualcosa si muove**, e va detto: con `InpAllowReverse` + `ABTG_RETEST`
  il tetto giornaliero è **2** (r.644) e il whipsaw può lasciare **due posizioni nostre** aperte.
  Prima venivano chiuse **una per tick** (due tick); ora **tutte e due nello stesso tick**. Il
  **numero di operazioni non cambia** — cambia il tick su cui atterra la seconda chiusura, quindi
  il suo **prezzo**, di un tick. 👉 Se un backtest mostrasse un **numero di trade diverso**,
  **è un difetto e va segnalato**, non giustificato.
- Cambia anche il **testo dei log** (`"fine sessione: posizione chiusa."` →
  `"fine sessione: chiusa la posizione #N."`) e compare una riga di log sul flatten notizie, che
  prima era muto. **Solo log.**

---

## 📏 CONTEGGIO RIGHE — con **tutti e due** i righelli (classe 456)

`wc -l` conta i ritorni a capo; il referto notturno di `CODA_06` conta
`@($t -split "\r?\n").Count`, che dà **sempre UNO IN PIÙ**.

| file | `wc -l` prima | `wc -l` dopo | righello `CODA_06` prima | righello `CODA_06` dopo | delta |
|---|---:|---:|---:|---:|---:|
| `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` | 2367 | **2425** | 2368 | **2426** | **+58** |
| `mql5/Experts/ABTG_Dow_Apertura_US.mq5` | 2147 | **2205** | 2148 | **2206** | **+58** |
| `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` | 2566 | **2624** | 2567 | **2625** | **+58** |

🟢 **+58 identico su tutti e tre**: è la firma di una toppa meccanica, la stessa del pacchetto
del 19/09 sul vintage.

---

## ✅ LE VERIFICHE FATTE (e sono due modi diversi, non uno)

1. **Ancoraggi unici prima di scrivere**: ognuno dei tre siti trovato **esattamente 1 volta**
   per file, con `assert`. Se un ancoraggio fosse stato ambiguo, lo script si fermava.
2. **Verifica incrociata con lo strumento di casa**: `backtest_pipeline/genera_toppa_chiusura_ticket.py`
   (implementazione **indipendente**, già in repo) applicato a `git show HEAD:` produce
   **2426 / 2206 / 2625 righe** e il risultato è **IDENTICO byte per byte** al porting fatto a
   mano. Due implementazioni, stesso file.
3. **Blocco inserito identico al collaudato**: `md5 = 63be5799c609ec2c08ef43103f26809e` sulle 58
   righe, **uguale** nei tre file e uguale al riferimento.
4. **Fine riga ed encoding**: i tre file sono **UTF-8 con LF puro** (CR = 0) prima e dopo — nessun
   ritorno a capo misto introdotto.
5. **Audit residuo di TUTTE le scritture di trade** nei tre EA: `PositionModify`,
   `PositionClosePartial`, `PositionClose` → **tutte per ticket**, con `ticket` che arriva da un
   ciclo filtrato su simbolo **e** magic (r.1870-1877). `CancelMyPendings()` era già per ticket.

---

## 🟠 `ABTG_ORB_Ottimizzato`: **NON serve. E il "4" era un abbaglio del grep.**

Le **4 occorrenze** segnalate sono alle righe **362, 799, 990, 1049** e sono **tutte e quattro
dentro COMMENTI** che *documentano la riparazione già fatta*. In codice eseguibile:
**ZERO**. L'EA è a posto dalla **v1.04**: `ChiudiPosizioniMie()` (r.1001), usato sul flatten
notizie (r.370) e a fine giornata (r.1050); le uscite runner chiudono `gTrade.PositionClose(gTicketMio)`
(r.810, r.819).
👉 **Non l'ho toccato, e non va toccato.** È la classe **468** qui sotto.

---

## 🚧 QUELLO CHE RESTA APERTO (misurato, non toccato)

Censimento su tutti i **113** `.mq5` di `mql5/Experts/`: **grep = 44 occorrenze in 21 file**, ma in
**codice eseguibile = 36 in 16 file**. Fra questi, due sono parenti stretti dei file appena
riparati (**classe 462**: il fix di famiglia applicato al generico e non alla variante):

| file | occorrenze in codice | in campo? |
|---|---:|---|
| `ABTG_DAX_Apertura_EU_Ottimizzato.mq5` (magic 770111) | 2 | ❌ no (nessun grafico) |
| `ABTG_Nasdaq_Apertura_US_Ottimizzato.mq5` (magic 770211) | 2 | ❌ no (nessun grafico) |
| altri 14 EA (`Live5m`, `M3`, `Londra_ORB`, `MaxMinNotte`, `ORB`, `ORB_Fibo`, `3Ingressi`, `Marco`, oro…) | 32 | fuori dalle sei sedie |

🟢 **Nessuna delle SEI SEDIE di lunedì resta col difetto**: i file di `770411` (MaxMin DAX Short
Ottimizzato), `771531` (EMA200) e `770511` (SuperWave) hanno **0 occorrenze**, `770101` / `770202`
/ `770201` sono quelli appena riparati, `ABTG_ORB_Ottimizzato` era già a posto.
⚠️ Lo strumento di casa **sa già generare** la toppa per i due `_Ottimizzato` (li ha in elenco e
li produce senza errori): è **una riga di comando**, non un lavoro. **Non l'ho fatto perché non
me l'hai chiesto.**

---

## 👤 COSA DEVE FARE CLAUDIO

### 1️⃣ Ricompilare i tre `.mq5` — 🪟 **bersaglio: il terminale dove girano le sedie**
I file da ricompilare (F7 in MetaEditor), **per nome**:
- `ABTG_DAX_Apertura_EU.mq5` (magic 770101)
- `ABTG_Dow_Apertura_US.mq5` (magic 770202)
- `ABTG_Nasdaq_Apertura_US.mq5` (magic 770201)

🔴 **E QUI SERVE UNA TUA RISPOSTA, PERCHÉ NON È UN FATTO CHE HO IN MANO:**
**su quale terminale sta il conto prop che parte lunedì?** Non lo invento. I terminali censiti
sul VPS sono `50503392` (`C:\Program Files\BCM Markets MT5 Terminal`), `50504263`
(`... MT5 Terminal -V3`), `10105439` (`C:\BCM_Reale`) e `50504400` (`C:\MT5_Backtest`): il conto
prop **non è nessuno di questi**.

### 2️⃣ 🔴 Il **conto reale 10105439** (`C:\BCM_Reale`) resta FUORI
Il DAX Apertura in campo sul reale **è proprio la versione HEAD** che ho appena modificato.
👉 Sostituire lì l'`.ex5` **cambia un binario su conto vero**: è **una tua firma**, non una mia
decisione. Finché non firmi, su `C:\BCM_Reale` **non si tocca niente**.

### 3️⃣ Il primo F7 è anche il primo test di compilazione
Qui MetaEditor non c'è: **questi tre file non sono mai stati compilati**. La correttezza è
**argomentata** (API già usate a HEAD, stessa forma già in campo su `ABTG_ORB_Ottimizzato`),
non collaudata. Se dà errore **non è una sorpresa, è il collaudo che fa il suo mestiere**:
mandami il testo dell'errore e lo chiudo.

### 4️⃣ La verifica che la toppa è entrata davvero
Il referto notturno di `CODA_06` deve mostrare **2426 / 2206 / 2625** (righello `CODA_06`),
**non** 2368 / 2148 / 2567. 🔴 **Attenzione al righello**: con `wc -l` i numeri sono
**2425 / 2205 / 2624**. Chi confronta i due righelli fra loro conclude il falso (classe 456).

---

## 📌 CAVEAT, detti prima
- 🔴 **Lettura statica, non test eseguito.** Non ho compilato né fatto girare niente: qui non
  c'è MetaTrader.
- Il contro-esempio è **argomentato sul codice** e **modellato in Python**, e il modello assume
  la semantica documentata di `PositionSelect(simbolo)` su hedging (fonte: audit del 03/09).
- La toppa **non aggiunge** la guardia anti-ripetizione a ogni tick: vedi il paragrafo dedicato.
- Restano **36 occorrenze in 16 EA** fuori dalle sei sedie: censite, non riparate.
