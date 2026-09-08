# 📋 RESOCONTO DEL 08/09/2026 — ore 21:00

> # ⏳ **23 GIORNI AL 1° OTTOBRE**
> **60 commit.** Undici agenti, tutti consegnati. E una porta che si è aperta:
> **da oggi i round girano sul VPS.**

---

## 🤖 COSA HA FATTO LA MACCHINA DA SOLA

**Runner del VPS, 03:30** — `ESITO: COMPLETO`, **4 eseguiti, 0 rifiutati, 0 falliti**.
Seconda notte di fila. Da quei quattro referti sono usciti **due contraddizioni** e
un verde importante:
- ✅ il **quarto MT5** è in piedi: conto **50504400**, **HEDGING**, **zero EA**;
- 🔴 sul terminale del reale `CODA_01` (dai `.chr`) **non vede il Guardian**, ma
  `CODA_02` (dai log) lo vede scrivere **464 righe fino alle 23:56**;
- 🔴 le **PostNews EURJPY/EURUSD** girano ancora al **3,0%** — e **3.0 è il default
  compilato** dell'EA: firma di un EA attaccato **senza preset**.

**Caccia automatica**: nessun dossier nuovo in `caccia_strategie/` oggi (la Routine
gira **ogni 2 giorni**). Le due cacce di oggi le ho lanciate io a mano.

---

## 💶 IL CONTO

| | |
|---|---|
| **Dry-run 100k (50504263)** | saldo **102.854,99** · **27 operazioni** dal via |
| **verso il target +10%** | mancano **7.145,01 €** = **7,15 punti** |
| margine sul muro totale | **+12.854,99** (12,85% del conto) |
| peggior giornata dal via | **−647,82** |
| Guardian reale | `eq=7.500,00 · dayLoss 0,00% · totDD 0,00%` |

🔴 **`SlippageLogger` sul conto reale: ANCORA ZERO.** Dai log:
`[SLIPLOG] fermato (motivo 4): deal registrati 0, campioni 0`. Il conto reale
esiste **per misurare lo slippage**, e quella misura **non si sta facendo**.
**NON MISURATO**: se si ferma perché non ci sono deal (plausibile: quel conto
opera poco) o perché non li vede.

_Il netto del giorno per EA lo fa la **pagella delle 23:00**, in un'altra chat._

---

## 🔬 COSA HO DECISO IO

### 🏁 Ho aperto la fabbrica: **passo 7 superato**
Il quarto MT5 riproduce l'ancora R119 **alla cifra**: `770611` 2484,17 / 1,67490 /
6,5389% / 119 e `770101` 1103,31 / 1,41105 / 4,3501% / 270 — **16 numeri, tutti
identici**, gemelli di determinismo compresi. PID degli altri tre terminali
**uguali prima e dopo**.
👉 **I round non aspettano più che Claudio accenda il PC.**

### 🔬 Ho archiviato un motore, in quattro round e ~25 minuti
`ABTG_OpeningReversalB`: **12 celle a tick reali**, conteggio IS sempre fra **1 e
3**, OOS **zero ovunque**. Frequenza **0,0078 op/giorno** contro un pavimento di
1,00: **128 volte sotto**. **ARCHIVIATO per FREQUENZA**, col criterio congelato
prima del round. Il merito **non è stato giudicato** e non lo sarà: `PF 3,56` su
tre trade non è una scoperta.

### 🐞 Ho corretto quattro difetti che ci avrebbero fatto male
1. il **volume fino al doppio** del dichiarato in **15 sorgenti** (già pagato in
   campo il 20/08: 1,42% su contratto 1,0%);
2. il **canarino del Guardian cieco da due giorni** su 5 variabili su 6 — compresa
   `BLOCKDAY`, il blocco duro: avrebbe stampato *"0 = spenta"* **a bandiera alzata**;
3. lo script dello storico che **spegneva tutti i terminali**, reale compreso;
4. il driver che **non portava gli include** sui terminali nuovi (`error 106`).

### 🏹 Ho riempito l'imbuto
**7 motori nuovi promossi** (4 aperture+oro, 3 M30 indici) · **7 ripescati** dagli
scarti · **2 EA scritti** (`ABTG_ImpulsoApertura` 769800, `ABTG_LVNArbitro` 769900).

### ⚠️ E ho sbagliato quattro volte, tutte agli atti
- **tre previsioni sbagliate** sul conteggio dell'OpeningReversalB (una per asse);
- e soprattutto: **stamattina avevo raccomandato di accendere `SuperWave DAX H4`.
  Stasera l'ho RITIRATA**, con tre fatti verificati: il DD 3,3% è misurato
  all'**1,00%** e non allo 0,65%; sul piccolo il **pavimento del lotto** rende il
  rischio non controllato (DD reale ~6,5%); e **c'era già un "NON ACCENDERE" del
  07/09 che non avevo letto**. Al 1° ottobre avrebbe fatto **~2 operazioni**.

---

## ⚠️ COSA ASPETTA CLAUDIO

Solo tre cose toccano **il reale, il rischio o i soldi**:
1. 🖱️ **Ricompilare + ricaricare le 7 sedie** col fix del lotto → porta le sedie
   schierabili **da 2 a 5**. *(Nessuna sul reale.)*
2. 🖱️ **PostNews EURUSD: `InpRiskPercent` 3.0 → 1.30** (piccolo 50503392).
3. 🖊️ **Quale prop, e quando si paga** — con **due numeri da confermare alla fonte
   prima della fee**: muro **statico o trailing**, e come calcolano **il confine
   della giornata**.

Tutto il resto è in `report/DA_FIRMARE.md`, diviso in **FIRMA / MANO / MISURA**.

---

## 🎯 DOMANI

**03:30, runner, OTTO righe** (da 4 di ieri):
`CODA_01-04` la foto · **`CODA_05`** i `.chr` sono freschi o vecchi? + calendario news
letto riga per riga · **`CODA_06`** quale albero di sorgenti è compilato ·
**`CODA_07`** il **Desktop del VPS** portato a me · **`CODA_08`** i parametri di ogni
sedia in forma di `.set` — che mette al sicuro **la configurazione del 100k, oggi
viva solo dentro i `.chr`**.

**E in attesa del via di Claudio**, due passi 0 già scritti e pinnati:
`ABTG_ImpulsoApertura` (in **standby** per sua decisione) e `ABTG_LVNArbitro`
(atteso: **450-1.100 operazioni** in 21 mesi — sarebbe il primo candidato con
campione sufficiente **su un simbolo solo**).
