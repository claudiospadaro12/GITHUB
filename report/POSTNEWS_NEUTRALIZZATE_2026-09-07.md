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

## ❓ COSA RESTA APERTO — ed è l'unica cosa che conta

**Non sappiamo ancora DOVE sono attaccati i tre EA.** L'output di
`RIGA_TROVA_POSTNEWS.ps1` è scorso via prima di essere letto.

🔴 **Perché conta**: il calendario vuoto è un **tampone**, non uno spegnimento.
Gli EA sono ancora attaccati. Se qualcuno rimette un calendario — o se un EA
ne scarica uno — **ripartono al 3,00%**. Lo spegnimento vero resta:
**staccare l'EA + `ABTG_ChiudiSedie`**.

## 📌 Conseguenza per il CENSIMENTO
Le tre righe 🔴 **NON MISURATO** di `report/CENSIMENTO_CONTRATTI.md` restano
tali. Anzi si chiariscono: per **771201/771202** non è che manchi il DD
promesso — **non esiste nemmeno un'operazione**, perché il calendario non
c'era. Il contratto va scritto **prima** di riaccenderle, non dopo.

---

_Pin della riga usata: `9f1feb3228caf8fa395e4fd6fba9303fd910b214`.
Per tornare indietro: copiare il `.bak` sopra l'originale._
