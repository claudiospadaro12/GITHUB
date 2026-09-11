# 🧊 IL CAMPO È FERMO AD AGOSTO — 42 sorgenti su 42 diversi dal repo

**Nato da una domanda di Claudio (11/09):** *"Ricontrollate tutti gli EA sul
conto demo piccolo perché fanno pochi trade."* La risposta alla domanda è nel
referto gemello. **Questo è quello che è saltato fuori per strada, ed è più
grosso della domanda.**

---

## 1. 🔴 IL FATTO

Confrontando i sorgenti che stanno **dentro la cartella del terminale**
(censimento del runner, 11/09 03:30) con quelli del **repo**:

> ## **42 sorgenti su 42 sono DIVERSI. Le date di compilazione stanno fra il 5 e il 18 AGOSTO.**

Non è un artefatto di conteggio: `wc -l` e il conteggio Python danno lo stesso
numero sui file del repo, e gli scarti sono **da decine a centinaia di righe**.

| sorgente | campo | repo | scarto | compilato |
|---|---:|---:|---:|---|
| 🚨 **`ABTG_Guardian`** | **414** | **899** | 🔴 **−485 (meno della metà)** | 09/08 |
| `ABTG_FiboH4_Multi` | 534 | 1013 | −479 | 06/08 |
| `ABTG_MaxMinNotte` | 540 | 918 | −378 | 06/08 |
| `ABTG_ORB` | 595 | 929 | −334 | 06/08 |
| `ABTG_Nasdaq_Apertura_US` | 2033 | 2566 | −533 | 08/08 |
| `ABTG_EMA200_Ottimizzato` | 487 | 606 | −119 | 06/08 |
| ... e altri 36 | | | | 05-18/08 |

## 2. 🚨 LA RIGA CHE PREOCCUPA DI PIÙ

**Il `Guardian` in campo ha 414 righe. Nel repo ne ha 899.** È il sistema che
dovrebbe fermare tutto se il conto va sotto — **la protezione, non una
strategia.** E dal 09/08 ha ricevuto **6 commit** che non sono in campo.

🔴 **Non sappiamo cosa contenga la versione che gira davvero**, e finché non lo
sappiamo **non possiamo dire che le protezioni firmate siano attive.** Va detto
ogni volta che si cita un muro o un cap.

## 3. 💥 COSA SIGNIFICA, IN CONCRETO

**Ogni correzione fatta da metà agosto in poi NON è in campo sul piccolo.** Fra
queste, quelle che stavamo dando per acquisite:

- 🔧 **Il fix del lotto doppio** (`872dba8`, 08/09, 15 sorgenti) — quello del
  pacchetto R4. **Non è in campo.** Il referto gemello lo conferma per un'altra
  strada: lo sforo del volume su SuperWave/SupRev **è ancora vivo**.
- 🔧 Tutte le correzioni a `DAX_Apertura_EU`, `Dow_Apertura_US`, `EMA200`,
  `SupertrendReversal`, `SuperWave`, `MaxMinNotte`.
- 🔧 Il `Guardian` dalla v1.20 in poi.

🔴 **E la conseguenza sul METODO è peggiore del singolo difetto**: quando
leggiamo un backtest e diciamo *"questa sedia fa PF 1,52"*, stiamo descrivendo
**il sorgente del repo**. In campo gira **un altro programma**. 👉 **R1 —
"esiste un round che ha promosso ESATTAMENTE la configurazione che gira" — non
è verificabile per nessuna di queste sedie**, perché il binario in campo non
corrisponde a nessun sorgente che abbiamo testato di recente.

## 4. 🧪 IL CONTRO-ESEMPIO, costruito prima di allarmare

| ipotesi che smonterebbe la lettura | verifica | esito |
|---|---|---|
| *"è l'albero `standalone/`, non il principale"* | costruita e **smentita dall'agente**: su `PTE` il campo ha **526** righe, `standalone/` **455**, il principale **649**. Non coincide con nessuno dei due | ❌ smentita |
| *"il conteggio righe del runner è diverso dal nostro"* | `wc -l` e Python danno **lo stesso numero** sui file del repo | ❌ smentita |
| *"sono differenze di un paio di righe"* | scarti da **14 a 533 righe**; i due casi a ±1 (`ORB_Ottimizzato`, `PostNews`) sono compilati **a settembre** e sono gli **unici due quasi allineati** | ⚠️ **parzialmente vera, e va detta**: 2 su 42 sono praticamente attuali |
| *"il sorgente nella cartella non è quello compilato"* | ✅ **VERA come limite**: MT5 compila l'`.ex5`, e il `.mq5` accanto **potrebbe** essere stato aggiornato senza ricompilare, o viceversa | ⚠️ **`[LIMITE DICHIARATO]`** — la data di compilazione dell'`.ex5` (5-18 agosto) è la prova più forte che abbiamo, ma **non è una prova del contenuto del binario** |

## 5. 🎯 PERCHÉ NESSUNO SE N'ERA ACCORTO

Perché **guardavamo il repo**. Il repo è ordinato, i commit ci sono, i fix sono
scritti. 👉 **Il difetto non era in nessun file: era nello spazio fra il repo e
la macchina** — e nessun controllo del progetto guardava quello spazio, finché
`CODA_06` non ha cominciato a stamparlo.

📌 **È la stessa famiglia della classe 229 di stamattina** (*il difetto che il
banco non può vedere perché dipende dalla taglia*): un difetto che **non sta
dentro l'oggetto esaminato**, quindi nessun esame dell'oggetto lo trova.

---

## ⚠️ COSA SERVE DA CLAUDIO — e non è una ricompilazione al buio

🔴 **NON propongo "ricompila tutto".** Sarebbe il gesto più pericoloso possibile:
porterebbe in campo, **in un colpo solo e senza collaudo**, un mese di modifiche
mai girate su quel conto — comprese quelle che **cambiano le taglie**.

**Propongo invece, in ordine:**
1. 📏 **Chiudere il dubbio sul Guardian per primo** (414 contro 899 righe): è la
   protezione, e sapere cosa protegge davvero viene prima di tutto il resto.
2. 🧾 **Un inventario firmato**: per ogni sedia, *quale versione gira* e *quale
   dovrebbe girare*, con accanto **cosa cambia** fra le due.
3. 🔁 **Una sedia per volta**, non quaranta. Con il rapporto dei lotti prima e
   dopo come prova che il fix ha morso.
