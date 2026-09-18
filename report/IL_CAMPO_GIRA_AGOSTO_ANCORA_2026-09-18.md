# 🔴 IL CAMPO GIRA ANCORA AGOSTO — **e due fix di RISCHIO firmati non ci sono mai arrivati**

**18/09/2026** · fonte: il **runner**, corsa automatica delle **03:30 del 18/09**, in sola lettura.
Log: `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260918_033004.log`

> # 🔴 **NON È UN CASO ISOLATO COME `EMA200`: È TUTTO IL CONTO PICCOLO.** Sul terminale **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`) i sorgenti di **tutte** le sedie sono di **agosto**, e **nessuno ha il Guardian**.

---

## ① LA FOTO, riga per riga dal log del runner

Colonna `GUARD` = il sorgente contiene `GuardiaIngresso` / `InpUsaGuardian` (legenda dello
script, r.89 di `CODA_06_quale_codice_gira.ps1`).

### Terminale **50503392** (`BCM Markets MT5 Terminal`) — **il conto delle sedie della rosa**
| EA | ver | righe | **GUARD** | compilato |
|---|---|---:|:---:|---|
| `ABTG_DAX_Apertura_EU.mq5` | 1.00 | **2133** | 🔴 **no** | **2026-08-08** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | 1.00 | **564** | 🔴 **no** | **2026-08-06** |
| `ABTG_EMA200.mq5` | 1.00 | **487** | 🔴 **no** | **2026-08-06** |
| `ABTG_MaxMinNotte.mq5` | 1.10 | **540** | 🔴 **no** | **2026-08-06** |
| `ABTG_Nasdaq_Apertura_US.mq5` | 1.00 | **2033** | 🔴 **no** | **2026-08-08** |
| `ABTG_Dow_Apertura_US.mq5` | 1.00 | **2065** | 🔴 **no** | **2026-08-08** |
| `ABTG_ORB_Ottimizzato.mq5` | 1.04 | 1464 | 🟢 **SI** | 🟢 2026-09-03 |

### Lo stesso EA sulla macchina di backtest (`C:\MT5_Backtest`), per confronto
| EA | ver | righe | GUARD | compilato |
|---|---|---:|:---:|---|
| `ABTG_DAX_Apertura_EU.mq5` | 1.01 | **2368** | 🟢 SI | 2026-09-17 |
| `ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` | 1.01 | **775** | 🟢 SI | 2026-09-17 |
| `ABTG_EMA200.mq5` | 1.00 | **691** | 🟢 SI | 2026-09-17 |

🟢 **Le sedie allineate sono DUE, non una** *(corretto il 18/09 sera: ne avevo contata una)*:
`ABTG_ORB_Ottimizzato` v1.04 (**03/09**) e **`ABTG_PostNews` v1.10, 667 righe, `GUARD = SI`
(04/09)** — quest'ultima **viva**, ha operato il 04/09.
Vuol dire che **l'aggiornamento si sa fare** — non è un ostacolo tecnico, è una cosa non fatta.

---

## ② 🔴 E ADESSO LA PARTE CHE COSTA: **due fix di RISCHIO firmati non sono in campo**

### (a) Il **FIX C4** sul DAX — firmato il **02/09**, binario in campo dell'**08/08**
`ABTG_DAX_Apertura_EU.mq5` r.90, testuale:
> *«02/09: era 2.0. Il default compilato era **il DOPPIO** del contratto (1,0%) e della riga rossa
> A4: **ogni RIPRISTINA rimetteva il 2%**. FIX firmato C4.»*

👉 **Il sorgente in campo è precedente al fix**: porta ancora `ABTG_DEF_RISK = 2.0`.
Il preset lo tiene a 1% *finché il preset è caricato* — ma **un «Ripristina» nella finestra input
raddoppia il rischio in silenzio**, che è esattamente lo scenario che la firma C4 doveva chiudere.

### (b) Il fix del **pavimento del lotto minimo** su SuperWave — dell'**08/09**, binario del **06/08**
`ABTG_SuperWave.mq5` rr.383-390, testuale:
> *«CORREZIONE 08/09/2026 … con l'ordine precedente … volume totale `totLot+volMin`, cioè **fino
> al doppio del rischio dichiarato**. **Misurato in campo il 20/08/2026: 1,42% su un contratto da
> 1,0%**.»*

👉 **Anche questo non è in campo.** La sedia `770511` gira il binario **di due giorni PRIMA** che
quel difetto venisse perfino misurato.

### (c) 🔴 ~~E il Guardian non c'è su nessuna delle sette tranne l'ORB~~ — **QUESTO ERA SBAGLIATO**

**CORREZIONE del 18/09 sera, trovata dal censimento e verificata da me alla fonte.**
`GUARD = no` sul piccolo **non è un difetto: è una DECISIONE FIRMATA DA CLAUDIO.**
`HANDOFF.md` r.129, testuale:

> *«**DECISIONE (Claudio, 06/09 notte): NIENTE Guardian sul piccolo (50503392).** Il Guardian
> sta solo su reale (10105439) e 100K (50504263); sul piccolo non c'è mai stato e **resta fuori
> per scelta**. Motivo, dichiarato: "dobbiamo vedere appieno come si comportano gli EA" … **Il
> piccolo è lo strumento di misura, non il conto da proteggere.**»*

E la ragione regge, ed è la nostra: con la rete attiva il DD osservato sarebbe **quello potato
dal Guardian**, non quello vero — e il criterio RISCHIO del 18/08 (*DD forward > DD promesso →
revisione immediata*) confronterebbe un numero potato con un numero intero.

🧪 **E c'è la prova dentro la tabella qui sopra**: l'`ORB_Ottimizzato` il Guardian **ce l'ha**
(`GUARD = SI`) e si comporta **identico** alle altre — perché su quel conto nessun Guardian gira,
e `ABTG_PausaGuardian.mqh` rr.54-56 dice che senza guardiano *«tutto ritorna false (**fail-open**)»*.
👉 Ricompilare quelle sei **per il Guardian** darebbe **zero protezione**.
⚠️ Diventa un problema **il giorno in cui una di quelle sedie passa sul 100k o sul reale**.

📌 **Conseguenza sulla lista di urgenze: da sette voci indistinte a QUATTRO reali.**

---

## ③ 🔴 COSA CAMBIA NELLE MISURE DI OGGI — e va detto, non nascosto

Tutto quello che ho misurato oggi dai P/L del campo — `770101` DAX **+149,16**, `770511`
SuperWave **+244,94**, il rischio realizzato, il rapporto vincita/perdita — **è stato prodotto da
binari di agosto**, non dal codice che ho letto tutto il giorno nel repo.

> ## 🟠 **Non invalida quei numeri: sono successi davvero.** Ma li stacca dal sorgente: **descrivono il codice di agosto, non la sedia che schiereremmo.** Ogni volta che si citano, va detto.

🟢 **E una cosa si chiarisce meglio, non peggio**: i sette stop del DAX al ~2% del saldo
(23/07-14/08) tornano perfettamente — **quel binario ha il 2% compilato dentro**, e ce l'ha
ancora oggi.

---

## ④ IL PUNTO PER IL 1° OTTOBRE

🔴 **Una sedia il cui binario in campo è diverso dal sorgente validato non è una sedia
schierabile: è un'altra sedia.** Qualunque numero promesso dal backtest si riferisce a codice
che su quel conto non gira.

**Non è ponteggio: è il primo cancello dello schieramento**, e oggi è chiuso su sei sedie su sette.

### Cosa serve, e non lo faccio io
Una ricompilazione (F7) di quei sorgenti sul terminale **50503392**
(`C:\Program Files\BCM Markets MT5 Terminal`), dopo aver allineato i file dal repo.
🚫 **Fuori dal perimetro del runner, che è in SOLA LETTURA.** Serve la firma di Claudio, e la
sequenza va preparata e passata al cancello prima di essere dettata.
⚠️ E va fatta **sul terminale giusto**: sul VPS convivono **sette** cartelle dati, fra cui il
**REALE 10105439** (`C:\BCM_Reale`), che **non si tocca**.

---
*Fonte unica: `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260918_033004.log`
(cartella `215D85D767A1C39E22D242C8114BF9F5` = `BCM Markets MT5 Terminal`, rr.81-178; cartella
`04C7A32B575E40027B4FF8724D14D702` = `C:\MT5_Backtest`, rr.5-80) · legenda `GUARD` da
`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` r.89 · `ABTG_DAX_Apertura_EU.mq5` r.90 ·
`ABTG_SuperWave.mq5` rr.383-390.*
