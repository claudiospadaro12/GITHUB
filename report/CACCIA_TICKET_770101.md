# 🕵️ I TRE STOP PIENI DEL 770101 — chi li ha piazzati

_Verifica del 15/08/2026 (00:14), `caccia_ticket.ps1` lanciato su **entrambe**
le macchine. Chiude il sospetto aperto dalla pagella del 14/08 §4._

---

## 0. Come si legge un giornale MT5 (la firma che distingue)

Nel Giornale (`logs\`, non `MQL5\Logs\`) due righe diverse dicono due cose
diverse:

| riga | significato |
|---|---|
| `order #N buy stop ... done in NNN ms` | **questa macchina HA PIAZZATO** l'ordine |
| `deal #M ... done (based on order #N)` | questa macchina **vede l'esecuzione** fatta da qualcun altro |

Il VPS vede il `deal` di tutti e tre gli ordini — è il terminale collegato al
conto, li vede tutti. Solo chi ha **piazzato** scrive l'`order ... done in N ms`.
**Quella è la firma.**

## 0-bis. Controllo positivo: **passato su entrambe le macchine**

`#3160534` (14/08), di cui conoscevamo già la risposta, è uscito dove doveva:
`order ... done` sul PC, solo il `deal` sul VPS. Lo script sa cercare, quindi i
"non trovato" sono risposte vere e non silenzi dello strumento.

---

# ⚖️ VERDETTO: **due su tre, non tre su tre**

| ordine | data | esito | chi ha PIAZZATO | verdetto |
|---|---|---:|---|---|
| **#3088160** | 06/08 BUY 0,9 | −102,96 | **VPS** `09:15:00.397 order #3088160 ... done in 298,475 ms` | ✅ **trade REGOLARE della flotta** |
| **#3109763** | 10/08 SELL 1,7 | −101,83 | **PC** `09:16:12.748 order #3109763 ... done in 57,049 ms` | 🔴 **FANTASMA** |
| **#3160534** | 14/08 BUY 2,0 | −104,60 | **PC** `09:25:01.180 order #3160534 ... done in 70,989 ms` | 🔴 **FANTASMA** (già noto) |

Sul PC il **06/08 non esiste una sola riga su D30EUR**: quel giorno l'istanza
fantasma non ha toccato il DAX.

## 1. La mia inferenza era sbagliata per un terzo — e va detto

Nella pagella del 14/08 avevo scritto, marcandolo **[INFERITO], non provato**,
che tutti e tre gli stop pieni fossero plausibilmente della stessa istanza,
sulla base di tre indizi convergenti (importi ~2% di un conto da ~5.150, la
nota della pagella del 10/08, la giornata rossa del 06/08).

**Due indizi su tre reggevano. Il terzo no.** Il 06/08 il VPS ha piazzato un
buy stop 0,9 regolare alle 09:15:00 locali (08:15 server) e ha perso: è un
trade della flotta, con la sua config, e resta **a carico del portafoglio**.

L'inferenza era etichettata correttamente, ed è servita a far fare la verifica.
Ma "convergente" non vuol dire "vero": la riga che decideva era una sola, ed è
questa.

## 2. La riattribuzione vera

| | importo |
|---|---:|
| 10/08 · #3109763 | **−101,83** |
| 14/08 · #3160534 | **−104,60** |
| **totale NON del portafoglio** | **−206,43** |
| 06/08 · #3088160 (resta alla flotta) | −102,96 |

Coincidenza da segnalare per onestà: avevo stimato "~205 € su tre giornate", e
il numero vero è **206,43 su due**. La cifra combacia quasi, il ragionamento
no. Non è la stessa cosa.

## 3. ✅ Il fuso BCM confermato, di passaggio

| evento | log del PC (ora locale IT) | CSV del VPS (ora server) |
|---|---|---|
| 10/08 · esecuzione del sell 1,7 | 09:16:16 | **08:16:16** |
| 14/08 · piazzamento del buy 2,0 | 09:25:01 | — |

**Esattamente −1 ora.** La regola del progetto ("server BCM = ora italiana −1")
regge su un caso reale con timestamp al secondo, e la nota del CLAUDE.md ("i
log MT5 stanno in ora locale del PC, il grafico in ora server") è confermata
sul campo.

## 4. 🔬 Il difetto della guardia A4, **fotografato nei log**

Il contesto del 14/08 sul PC contiene la prova del bug corretto ieri sera:

```
09:25:01.180  BUY STOP @ 26479.00  lot 2.00      <- primo ciclo, perso 1R
16:17:43.517  BUY STOP @ 26479.00  lot 1.90      <- RIARMA su giornata GIA' operata
16:17:43.575  SELL STOP @ 26426.70 lot 1.90
16:18:43.952  cancel #3165434 ... done           <- cancellati a mano
16:18:48.520  cancel #3165435 ... done
16:38:19.272  "oggi ho GIA' operato ... non riarmo. Guardia reload-safe."
```

Alle **16:17:43** un'istanza appena avviata riarma i pendenti su una giornata
già operata. Dalle **16:38** in poi la stessa guardia dice correttamente "non
riarmo", e lo ripete per ore.

**È esattamente il difetto `storicoOk`**: appena il terminale parte lo storico
dei deal non è ancora sincronizzato, `HistorySelect` ritorna false, la vecchia
guardia leggeva "non ho operato" e — avendo già timbrato la giornata — non ci
riprovava. Venti minuti dopo, a storico caricato, la stessa guardia funziona.

La correzione (`ABTG_DAX_Apertura_EU` v1.01 e ieri sera anche Dow, Nasdaq,
Marco) **non era teorica**: qui c'è la fotografia del caso che doveva impedire.
Per contrasto, il **10/08 la guardia ha funzionato**: dalle 09:17:20 in poi
"oggi ho GIA' operato", ripetuto tutto il giorno.

## 5. 🆕 Due cose nuove viste passando (non diagnosticate qui)

1. **Sei ordini falliti sul VPS il 06/08**, alle 04:18:04 e alle 08:57:07:
   `failed market buy 0.4/0.3/0.3 D30EUR [Invalid stops]`. Tre e tre, stessi
   secondi, stop identico. Non so di quale EA siano. **Da indagare a parte.**
2. **Il 06/08 alle 09:15:00 il VPS piazza `#3088160` e `#3088161`: due buy stop
   0,9 allo STESSO prezzo 26203,10.** È la firma del problema già refertato il
   05/08 (`DAX Apertura EU` + `Apertura Marco`, due EA gemelli che fanno lo
   stesso trade allo stesso secondo). Non è il tema di oggi, ma è ancora lì.

## 6. La domanda che questa verifica apre

Lo script ha cercato **tre** numeri. Sul PC ci sono **52 file di giornale**
negli ultimi 45 giorni, e in quelli letti compaiono **12 righe `order #`**.

> **Quante ALTRE volte il PC ha piazzato ordini sul conto vivo?**

Non lo sappiamo. La domanda giusta non è più "quei tre trade di chi erano", ma
**"quanti trade del conto piccolo non sono del portafoglio"** — e si risponde
elencando *tutti* gli `order #` del giornale del PC e incrociandoli col CSV.
È il passo naturale successivo, e costa quanto questo.
