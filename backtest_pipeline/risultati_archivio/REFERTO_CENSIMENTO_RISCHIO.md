# 🔎 CENSIMENTO DEL RISCHIO — **TROVATO. Tre sedie dichiarano il 2%, e due sono ESATTAMENTE quelle delle perdite oltre il 2%.**

_17/08/2026, 23:34 — `censimento_rischio.ps1` sul VPS, 60 grafici letti dai
`.chr`. Output grezzo archiviato in `censimento_rischio_2026-08-17.txt`._

---

## 1. 🎯 LA RISPOSTA ALLA DOMANDA — ipotesi (a), CONFERMATA

Le due spiegazioni possibili erano: (a) rischio dichiarato più alto di quanto
crediamo, oppure (b) stop saltato da gap/slippage. **È la (a):**

| EA | simbolo | magic | rischio DICHIARATO |
|---|---|---|---:|
| 🔴 **ABTG_DAX_Apertura_EU** | D30EUR | **770101** | **2.0%** |
| 🔴 **ABTG_Nasdaq_Live5m** | NASUSD | **770203** | **2.0%** |
| 🔴 **ABTG_SupertrendReversal_Ottimizzato** | XAUUSD | **970901** | **2.0%** |

**E i conti tornano al decimale.** Le sei peggiori perdite del conto piccolo:
−2,19% · −2,17% · −2,05% · −2,04% · −2,02% · −2,00% — **tutte su D30EUR e
NASUSD, tutte in apertura/Live5m**. Con rischio dichiarato 2,0%, una perdita
piena fa −2,0% e lo sforamento residuo (0,0–0,19 punti) è spread + slippage
normale d'apertura.

> ## 🔴 **Lo stop NON viene saltato. Quelle sedie sono IMPOSTATE al doppio.**
> Non è un difetto del mercato, non è il broker: è un input. E il 100k lo
> conferma al contrario — le sue copie (770101, 770202, 770411, 770901) stanno
> a **0,65%** e infatti la peggiore perdita là è **−0,65%**: il rischio di casa,
> esatto.

⚠️ **La terza sedia al 2% (`970901`, STREV OTT sull'oro) non è ancora comparsa
fra le perdite grosse — ma è armata allo stesso modo.** È questione di quando,
non di se.

## 2. 📌 Nota di lettura: 60 righe ma NON 60 sedie distinte

Diversi magic compaiono più volte (es. `770101` una volta a 2.0 e due a 0.65;
`770611` a 1.0 e due volte a 0.3): lo script legge **tutti** i `.chr` di
**tutte** le cartelle dati (grafici attivi + profili salvati + secondo
terminale). Le coppie a 0,65% combaciano con le sedie del dry-run 100k.

**Quale copia è quella viva lo dice il conto, non il file**: le perdite reali a
−2,19% su D30EUR/NASUSD dimostrano che per `770101` e `770203` la copia attiva
è quella al 2,0%.

📌 Anche il **totale 49,55%** va letto con questo filtro: depurato dei
duplicati, il conto piccolo dichiara comunque **~45% di rischio cumulato**
(3×2% + ~36×1% + le piccole). Non è rischio simultaneo, ma è la misura di
quanto il conto sia sotto-dimensionato per 28+ magic — come già scritto in
`DOVE_SIAMO_17-08.md`.

## 3. 🟡 Le righe senza input di rischio (da chiarire, non urgenti)

| EA | simbolo | nota |
|---|---|---|
| ABTG_GapContinuation | 225JPY | nessun `InpRiskPercent` e nessun magic letto |
| ABTG_Guardian | AUDCAD | è il guardiano FTMO: non apre trade, ok così |
| ABTG_TradeExporter | EURUSD, NZDCAD | utility di export, ok così |
| BREAKOUT_EA_JPY_v3 | USDJPY | EA esterno: **probabile lotto fisso** — da verificare |
| DAXMasterEA_v2_0 | D30EUR | EA esterno: **probabile lotto fisso** — da verificare |

Un EA a **lotto fisso** su un conto da 5.100 € è rischio non controllato per
definizione: il censimento non lo vede, ma il conto sì.

## 4. ➡️ LA PROPOSTA (decisione di Claudio, come da regola)

**Portare `770101`, `770203` e `970901` da 2,0 a 1,0** (o direttamente a 0,65,
il rischio di casa prop). Tre F7, tre minuti:

1. Sul VPS, grafico per grafico: **F7 → `InpRiskPercent` → 1.0 → OK**
   (D30EUR/DAX_Apertura_EU · NASUSD/Nasdaq_Live5m · XAUUSD/STREV_Ottimizzato)
2. **File → Profili → Salva** (altrimenti il `.chr` resta vecchio)
3. Rilanciare il censimento per verifica: le tre righe rosse devono sparire.

📌 Peraltro `770101` è **anche** la sedia peggiore del conto (−649 storico su
26 op): il 2% raddoppiava proprio il motore che perde di più.

## 4-bis. 🔴 CONTROPROVA delle 23:45 — NON PASSATA (secondo giro archiviato in `censimento_rischio_2026-08-17_2345.txt`)

Il secondo censimento, dopo il tentativo di correzione, dice:

- **`770101` e `970901` sono ANCORA a 2.0** → la correzione non risulta
  applicata su quei file;
- **`770203` (Nasdaq Live5m) è SPARITO del tutto dal censimento** — e con lui
  `770121` (DAX Live5m v2) e `DAXMasterEA_v2_0`: 60 → 57 righe. Un grafico che
  non compare più nei `.chr` è un grafico chiuso: **quell'EA non sta più
  girando**, il che va bene solo se è stato chiuso apposta.

**[IPOTESI, non misurata]** la sequenza più compatibile coi fatti: lo script di
correzione non è mai arrivato in fondo (MT5 ancora aperto → si è rifiutato,
come da progetto), e le tre righe sparite sono grafici chiusi in giornata i cui
`.chr` sono stati ripuliti all'uscita di MT5. Si chiude leggendo
`abbassa_rischio.txt` sul Desktop: se non esiste, lo script non ha mai corretto
niente.

## 4-ter. ✅ CHIUSA — controprova delle 00:01 del 18/08 PASSATA

Percorso completo, coi due inciampi documentati:

1. 23:55 — primo giro correzione: **0 corretti**. Bug mio: `TryParse` senza
   cultura su Windows it-IT legge "2.0" come VENTI. Corretto con
   `InvariantCulture` (commit `81fe75d`).
2. 23:57 — secondo giro: ancora 0, la cache di GitHub raw (~5 min) ha
   riservito la versione vecchia. Risolto puntando la stringa al commit.
3. **23:59 — terzo giro: `CORRETTO 2.0 -> 1` su `770101` (chart10) e `970901`
   (chart05)**, copie 100k a 0.65 lasciate intatte, backup `.prima_rischio`.
4. **00:01 — censimento a MT5 riaperto: ZERO righe rosse**, somma dichiarata
   scesa da 49,55% a **44,55%**. Output in
   `censimento_rischio_2026-08-18_0001.txt`.

📌 Nota di lettura sull'ultimo output: le righe finali *"le perdite da -2%
vengono dallo stop saltato"* sono il testo generico del ramo "niente sopra
l'1%" dello script, scritto per il caso in cui il censimento non avesse
trovato NULLA fin dall'inizio. Qui non si applica: la causa era il 2%
dichiarato, trovata e corretta — lo stop non c'entrava.

**Effetto pratico da oggi: la peggior perdita singola attesa sulle sedie
corrette scende da ~2% a ~1% del conto.**

## 5. 🚦 Cosa resta aperto dopo questo referto

- ✅ ~~perché il 100k va meglio del piccolo~~ → **misurato: rischia meno, non
  va meglio.** Ipotesi (a) confermata, ipotesi (b) esclusa per le perdite viste.
- 🔴 Il **criterio di uscita** per le sedie accese (proposta in
  `DOVE_SIAMO_17-08.md` §5, da congelare).
- 🟡 Verificare il lotto fisso di `BREAKOUT_EA_JPY_v3` e `DAXMasterEA_v2_0`.
- 📥 Downloader M1 + giro nativo R80 (filone separato, già in coda).
