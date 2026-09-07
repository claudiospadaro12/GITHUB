# 🤖 PRIMA CORSA DEL RUNNER — 07/09/2026, 22:59. **FUNZIONA.**

`ESITO: COMPLETO` — 2 eseguiti, 0 rifiutati, 0 falliti. Tre file pubblicati sul
repo **dal VPS, da solo**. Letti da Claude **senza che Claudio mandasse niente**:
è la prima volta che succede.

## 🔍 QUATTRO SCOPERTE, dalla prima foto completa della flotta

### 1. ✅ Le due cartelle "SCONOSCIUTE" sono spiegate
Non erano un mistero: **Pepperstone MetaTrader 5** (vuota, 0 EA) e
**Tickmill Europe MT5 Terminal**. Cinque cartelle dati = cinque broker
installati, non cinque conti BCM.

### 2. 🔴 SUL TICKMILL GIRANO DUE EA CHE NON SONO NOSTRI — e li conoscevamo già
| EA | simbolo | magic | rischio |
|---|---|---|---|
| `Gold_Ichimoku_TK_ATR_EA` | XAUUSD M5 | **250604** | 0,5% |
| `BREAKOUT_EA_JPY_v3` | USDJPY M15 | *(non letto)* | *(non letto)* |

- **250604 è la "sedia fantasma"** che il 24/08 era entrata in classifica R103
  e di cui si era scritto *"non gira da giugno"*. 👉 **È ancora attaccata.**
- **`BREAKOUT_EA_JPY_v3`** è quello che il censimento di oggi ha marcato *"magic
  illeggibile, famiglia con DD 30-48% agli atti, mai spenta in sette
  censimenti"*. 👉 **Adesso sappiamo dov'è.**

### 3. ✅ Il conto REALE è pulito e confermato
`ABTG_DAX_Apertura_EU` 770101 (0,65%) · `ABTG_ORB_Ottimizzato` 770611 (0,65%) ·
`ABTG_SlippageLogger`. Nient'altro.

### 4. 🟠 Sul piccolo 50503392 molte sedie girano all'**1,0%**, non allo 0,65%
`ABTG_PTE`, `ABTG_BreakingBand` ×3, `ABTG_GapFill` ×5, `ABTG_PunteLarry` ×4,
`ABTG_SuperWave`, `ABTG_EMA200`… È un **demo**, quindi non brucia soldi — ma
vuol dire che i numeri di quel conto **non si confrontano** con la taglia di
campo senza riscalarli.

---

## 🔧 E QUATTRO DIFETTI MIEI, che il primo giro ha fatto uscire

| | difetto | effetto |
|---|---|---|
| **D1** | tratto `name=Main` come se fosse un EA | il totale **132** è gonfiato: sono finestre di grafico, non sedie |
| **D2** | campo mancante stampato come `System.Object[]` | illeggibile invece che vuoto |
| **D3** | non leggo `period_type` | escono `p24`, `p4`, `p2` invece di H4, M2… |
| **D4** | 🔴 **conto i `.chr` di TUTTI i profili, non solo di quello attivo** | i doppioni sul 100k (770101, 770202, 770411, 770901, 770611 due volte ciascuno) sono quasi certamente **profili non caricati**, non sedie doppie |

### 🔴 D4 è il difetto grave, e la lezione è più grande del difetto

**Ho riscritto una ruota che esisteva già, e ci ho rimesso dentro un bug che
era già stato pagato.** `censimento_rischio.ps1` **v2** esiste apposta, e la
sua pagina racconta due incidenti veri:
- **23/08** — `ORB_Ottimizzato U30USD 770611` contato **due volte**;
- **24/08** — una sedia che **non girava da giugno** entrata in classifica,
  spostando la somma della flotta e la stima al 31/12.

La v2 separa il **profilo attivo** dai **RESIDUI SU DISCO**. Io ho scritto una
riga nuova da zero e ho rifatto **esattamente la v1**.

👉 **Correzione: CODA_01 non va riparata, va sostituita** con una variante che
stampa e che riusa la logica della v2. Regola per la coda, da qui in avanti:
**prima si guarda se lo strumento esiste già.**

---

## ⏱️ E un dato di esercizio
`CODA_01` ha impiegato **270 secondi** (63 `.chr` in una cartella sola, letti
per intero). `CODA_02`: **2 secondi**. Con la coda che cresce, il budget di
tempo va tenuto d'occhio.
