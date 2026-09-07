# 🧯 POSTNEWS NEUTRALIZZATE — 07/09/2026, ore 20:46

Decisione di Claudio: **"FERMIAMO"**, dopo che il censimento dei contratti ha
trovato tre sedie in forward al **3,00%** / **1,30%** con **DD promesso NESSUNO**.

## ✅ Cosa è stato fatto
`RIGA_NEUTRALIZZA_POSTNEWS.ps1 -EseguiDavvero` (pin `9f1feb3`) sul VPS.
**ESITO: file trovati 3 · SVUOTATI 3**, tutti con copia datata
`.PRIMA_DI_NEUTRALIZZARE_2026-09-07_204601.bak`.

| file | righe prima | dopo |
|---|---:|---:|
| `Common\Files\abtg_news_live_2026-09-04.csv` | 3 | 1 |
| `215D85D7…\MQL5\Files\abtg_news.csv` | **0** | 1 |
| `215D85D7…\MQL5\Files\abtg_news_live_2026-09-04.csv` | 3 | 1 |

---

## 🔎 TRE COSE CHE L'ESECUZIONE HA RIVELATO — e non erano nell'ipotesi

### 1. 🔴 `Common\Files\abtg_news.csv` **NON ESISTE**
È il calendario che leggono **771201 (ECB)** e **771202 (FOMC)** — `InpNewsFile=abtg_news.csv`
in tutti e due i preset. Nel `Common` non c'è. L'unica copia trovata è nella
sandbox del **piccolo 50503392**, ed era **a ZERO righe**.

👉 **Quelle due sedie erano già cieche PRIMA di stasera.** Non potevano armare:
`NewsToday()` torna false con `gNewsCount==0`, e la riga 251 esce senza piazzare
niente.

⚠️ **Combacia con quanto già agli atti**: l'unica misura mai fatta su quel
motore diceva **«Trades 0»** ed era stata **ritirata perché il calendario non
veniva letto**. Adesso sappiamo che non era un problema del banco: **il
calendario non c'è.**

### 2. 🟠 Il file dell'NFP conteneva **un evento PASSATO**
`2026.09.04 12:30;High;USD;Nonfarm Payrolls` — la **771203** aveva in
calendario solo il proprio evento del 04/09, quello che ha già operato
(+37,36). Nessun evento futuro caricato.

### 3. 🟠 Solo **una** cartella dati su cinque aveva calendari
Il blocco `TROVA_POSTNEWS` aveva contato **5 cartelle dati** (non 3: due non
sono ancora mappate). Di queste, solo `215D85D7…` — il **piccolo 50503392** —
conteneva file di calendario. Sul **conto reale 10105439** non ne è stato
trovato nessuno.

---

## ✅ DOVE SONO — MISURATO alle 20:51, e la risposta cambia la gravità

`RIGA_TROVA_POSTNEWS.ps1` ha girato su **tutte e cinque** le cartelle dati:

| terminale | esito |
|---|---|
| **50503392 PICCOLO demo** | 🟡 **771201 → `chart43.chr` · 771202 → `chart44.chr` · 771203 → `chart42.chr`** |
| SCONOSCIUTA `73B7A242…` | ✅ CONTROLLATA, nessuno |
| SCONOSCIUTA `857385E4…` | ✅ CONTROLLATA, nessuno |
| **50504263 100k demo** | ✅ CONTROLLATA, nessuno |
| **10105439 REALE** | ✅ **CONTROLLATA, nessuno** |

> ### 🟢 **TUTTE E TRE STANNO SUL DEMO PICCOLO. SUL CONTO REALE NON CE N'È NESSUNA.**

### 🔧 CORREZIONE DOVUTA
Nel riferire il censimento avevo scritto che le PostNews erano _"l'unica voce
che tocca soldi adesso"_. **Non era vero, e non potevo saperlo**: la posizione
non era agli atti (ultima foto `.chr` del 25/08) e l'ho scritto anche allora —
ma la frase dava per scontato il caso peggiore. **Il rischio al 3,00% era su un
conto DEMO.** Resta un difetto di METODO grave (sedie in forward senza
contratto), **non un'esposizione di denaro vero.**

### ⚠️ Un dettaglio da leggere bene
Per tutti e tre: **`log recenti che lo nominano: 0`**. Non prova che non abbiano
operato — l'EA scrive `[PostNews] …` **senza il numero di magic** nel testo del
log. Il +37,36 della `771203` viene dal CSV delle operazioni, non dal log.
👉 **"0 nei log" qui vuol dire "il numero non compare nel testo", non "non ha
operato".**

## ❓ COSA RESTA DA FARE
**Staccare i tre EA dai grafici 42, 43 e 44 del piccolo 50503392** — e basta.
Niente da fare sul reale né sul 100k.

🔴 **Perché serve comunque**: il calendario vuoto è un **tampone**. Gli EA sono
ancora attaccati e con un calendario nuovo **ripartono al 3,00%** — su demo, ma
ripartono. E prima di staccarli vale un censimento con `ABTG_ChiudiSedie`
(magic vuoti = non tocca niente) per vedere se hanno posizioni o pendenti
aperti: **`InpContoAtteso = 50503392`**, non altri.

📌 **Da mappare, non urgente**: due cartelle dati (`73B7A242…`, `857385E4…`)
non sono nella tabella dei conti di casa. Sono risultate pulite, ma **cinque
cartelle dati per tre terminali** è un numero che va spiegato.

## 📌 Conseguenza per il CENSIMENTO
Le tre righe 🔴 **NON MISURATO** di `report/CENSIMENTO_CONTRATTI.md` restano
tali. Anzi si chiariscono: per **771201/771202** non è che manchi il DD
promesso — **non esiste nemmeno un'operazione**, perché il calendario non
c'era. Il contratto va scritto **prima** di riaccenderle, non dopo.

---

_Pin della riga usata: `9f1feb3228caf8fa395e4fd6fba9303fd910b214`.
Per tornare indietro: copiare il `.bak` sopra l'originale._
