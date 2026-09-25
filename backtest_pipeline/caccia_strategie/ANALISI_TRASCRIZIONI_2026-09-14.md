# 📼 ANALISI TRASCRIZIONE — LIVE EMILIANO 14/09/2026 (DAX, regole del lunedì)

**Fonte:** `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-14.txt` (350 righe,
44.413 byte, TurboScribe auto-generato). Archiviata e pushata su `lavoro`
(commit `e87a759`).

> Regola che vale sopra tutto: **da questo materiale non si muove niente.**
> Ogni numero è una dichiarazione di fonte esterna, mai un criterio nostro.
> Nessun EA, preset, forward o conto è stato toccato.

**Su 1 trascrizione: 26 parametri con valore, 21 meccanismi, 5 bandiere (ZERO
rosse), ZERO regole prop.**

---

## 🎯 IL DATO PIÙ SOLIDO

**Non è una convergenza: è una divergenza, e vale di più.** La fonte
prescrive l'ORB a **15 minuti**; noi abbiamo misurato sul DAX, a tick,
walk-forward, con **due motori strutturalmente diversi** (breakout STOP e
retest LIMIT), che la banda **35-45 minuti fa 8 celle su 8 positive fuori
campione** e la banda **5-15 minuti ne fa 0 su 8** — coi due motori concordi
in **18 celle su 20** (`report/DIARIO.md`, 2026-08-06: *"Il confine dei 35
minuti non è del motore, è della mattina del DAX"*).

👉 **Questo è esattamente il caso d'uso delle trascrizioni: non ci dicono
cosa fare, ci dicono dove la nostra misura è già più forte della loro
opinione.** La sedia viva `770101` non si tocca — non perché non ascoltiamo
la fonte, ma perché l'abbiamo già ascoltata, misurata, e il numero ha detto
altro.

---

## 🔑 LE SEI COSE CHE VALGONO

1. **Soglia dei 200 punti sui pendenti**, quantificata (range ≤200pt → 3
   ordini, >200pt → 2 ordini) — ma non applicabile: i nostri EA piazzano
   1-2 pendenti, mai 3.
2. **ORB 15 minuti contraddice la nostra misura** (v. sopra) — non riapre
   il cancello.
3. **Le tre condizioni ORB (rottura + medie 9/21 + volumi crescenti) sono
   già in codice** (`ABTG_ORB.mq5`, `InpUseEmaFilter`/`InpUseVolumeFilter`/
   `InpVolMult=1.5`/`InpVolAvgBars=20`) e già misurate con esiti misti:
   volumi **promossi** su R101 (Dow PF OOS 1,543, DAX 1,550), medie 9/21
   **bocciate** su R84 (EMA filtro peggiore, OOS 0,681). La live è la sesta
   ripetizione della stessa fonte, non una misura nuova.
4. **Il "wrap"** — stop legato a una metrica di volatilità proprietaria di
   Emiliano — è l'unico meccanismo davvero nuovo, ma **non è
   implementabile**: dichiarato esplicitamente come "creato da lui,
   metriche diverse da quelle pubbliche". Sostituto quantificato che lui
   stesso offre: **ATR in H1** (chiude metà del buco G2 del 09/09).
   🔴 Bandiera arancione: la sua regola oggi (range largo → stringi lo
   stop) **contraddice** la sua regola precedente (range largo → salta il
   trade) **e** la nostra misura in campo (`InpMinRangePts`/`InpMaxRangePts`
   17-40pt, vivi sulla `770101`).
5. **Filtro di raggiungibilità sulla media 200** (distanza apertura di
   mezzanotte vs ADR, ~70pip vs ~40pip nell'esempio) — l'unico spunto
   davvero nuovo e numerico. Chiude uno spunto aperto da luglio e mai
   chiuso (`REGISTRO_TEST.md` r.306).
6. **Correzione lessicale**: "pre-section"/"presezione"/"prescrizione" **non
   è "price action": è "zona di PROTEZIONE"** (supply/demand). 20
   occorrenze, 6 rese fonetiche, 2 in italiano corretto. Resta senza una
   regola di costruzione — quinta trascrizione consecutiva — quindi non
   diventa un candidato, ma ora ha il nome giusto.

---

## 🚩 BANDIERE — 3 arancioni, 2 ambra, ZERO rosse

| # | Bandiera | Verdetto |
|---|---|---|
| B1 | Ingresso scalato su 3 pendenti senza tetto di rischio dichiarato | 🟠 attenuata: pianificato prima, con regola quantitativa |
| B2 | Size asimmetrica ("1 lotto sopra, 2 sotto") | 🟠 FTMO Forbidden Practice n.8 — non si tocca, le nostre size restano fisse allo 0,65% |
| B3 | Stop stretto perché il range è largo (wrap) | 🟠 contraddice la nostra misura in campo |
| B4 | Numeri di terzi/di sé senza contesto (2.400€, 100.000€, 7-10%) | 🟡 dichiarato, non verificato |
| B5 | Pre-condizione "stessa direzionalità" autodichiarata sospesa il lunedì | 🟡 autodenunciata dalla fonte stessa |

**Assenze confermate (ricerca sull'intero file):** martingala 0 · griglia/recovery 0
· hedging 0 · no-stop-loss 0 · trucchi anti-prop 0. **Mediazione reattiva 0**
(la bandiera rossa piena del 09/09 non si ripete). Materiale più pulito della media della serie.

---

## 🌀 CYCLE (R148) — zero materiale riusabile

`ciclo`/`cycle`/`stocast*`/`oscillat*`: **0 occorrenze in tutta la live.**
Nessun parametro, nessun verso, nessuna soglia attribuibile. R148a resta
corretto così com'è (asse unico, gestione spenta per default): aggiungere
materiale ora contaminerebbe la domanda "l'incrocio dello zero porta
informazione?". 🔴 Discrepanza da segnalare: R148a gira su NASUSD, mentre
questa live usa il Cycle sul DAX — non chiarisce simbolo/TF d'uso reale
(domanda G6 sotto).

---

## 🟢 SPUNTI (nessuno è un'azione — passano dall'imbuto)

| # | Spunto | Priorità |
|---|---|---|
| S1 | Filtro di raggiungibilità pendente (distanza/ADR) | 🟢 **ALTA** — chiude un debito, numerico, su famiglia viva |
| S2 | Filtro di regime squeeze→expansion sull'incrocio di medie (Paolo) | 🟡 media — ma cade su medie già bocciate (R84) |
| S3 | Soglia 200pt sul numero di pendenti | 🔴 bassa — non abbiamo mai 3 pendenti |
| S4 | Zona di protezione come veto d'ingresso | 🔴 bassa — quinta volta senza definizione costruttiva |

## ❌ Cosa NON diventa spunto, e perché

ORB 15min (misurato contrario) · medie 9/21 (già bocciate) · volumi (già
misurato, candidato R101 già aperto altrove) · size asimmetrica (regola
prop) · wrap/stop stretto su range largo (contraddice la misura in campo) ·
correlazione petrolio→DAX (verso incoerente nel trascritto stesso) · numeri
di performance (zero contesto).

---

## ❓ DOMANDE PER CLAUDIO (screenshot ai minuti giusti)

| # | Cosa manca | Cosa chiedere |
|---|---|---|
| G1 ⭐ | Nome/settaggi del "wrap" | Screenshot proprietà indicatore, minuto r.205 |
| G2 ⭐ | Le "due linee blu" ORB — è un indicatore automatico? | Screenshot lista indicatori, r.131 |
| G3 | Costruzione della "zona di protezione" | Screenshot DAX con la zona disegnata + spiegazione a voce |
| G4 | Prezzi dei livelli citati | Screenshot DAX M15 08:00-09:45 |
| G5 | "Volatilità media 70 pip" — su che strumento/indicatore | Screenshot a r.249 |
| G6 | Il Cycle: simbolo e TF che usa lui davvero | Domanda diretta a Emiliano |
| G7 | "517" (r.331-333): pip, punti, o medie 5/17? | Screenshot grafico di Paolo |
| G8 | Settaggi Supertrend ("supertermine") | Screenshot proprietà, r.319-323 |
| G9 | Strumento di "1 lotto sopra, 2 sotto" | Screenshot finestra ordine, r.311 |

---

## 📌 Nota dell'analista

Trascrizione più pulita sul fronte bandiere delle sette della serie: la
mediazione reattiva (bandiera rossa piena del 09/09) non si ripete, il
breakeven torna dopo la sbandata del 09/09, gli ordini multipli sono
pianificati con una regola quantitativa. Zero martingala/griglia/recovery/
hedging/trucchi anti-prop per la settima volta di fila.

Cambio reale nel repo: la correzione lessicale "pre-section → zona di
protezione" (punto 6). Da propagare in
`backtest_pipeline/caccia_strategie/ANALISI_LIVE_EMILIANO_2026-08-24.md` e
`report/ANALISI_LIVE_EMILIANO_2026-09-09.md` (§2.2, spunto S3).

---

## 🔗 SEGUITO — live del 18/09/2026 (referto separato, non duplicato qui)

👉 **`report/ANALISI_LIVE_EMILIANO_2026-09-18.md`**
(fonte: `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-18.txt`, 472 righe).

Cosa cambia rispetto a questo dossier, in tre righe — **i dettagli stanno là**:

- 🔁 **ORB 15 minuti: terza ripetizione della STESSA fonte** (qui punto 2, là §1.5).
  Nessuna misura nuova ⇒ **il cancello dei 35-45 min non si riapre**. 🔴 Ma là c'è
  un dubbio che qui non era emerso: l'ORB è *"tre candele"* di un **TF non
  dichiarato** — se fossero M15 la contraddizione svanirebbe. → domanda a Emiliano.
- 🆕 **Lo scale-in prende un secondo numero.** Qui avevamo la soglia dei 200 punti
  (3 ordini vs 2). Il 18/09 arriva la **frazione** (*"un terzo o due terzi"*) e la
  **distanza fra gli ordini** (*"circa 20 punti"*, *"40-50 punti non ha senso"*).
  🔴 Cade su `InpFirstFraction`, **voce 17 di `report/AUDIT_USCITE_2026-09-09.md`:
  MAI misurata**, e viva a **0,3333** su `SuperWave 770511/770531`.
- 🚩 **Bandiera nuova, metodologica**: il 18/09 la fonte **approva** un ingresso
  (*"Bravissimo"*, r.333) e venti minuti dopo lo **demolisce** (*"sbagliato
  clamorosamente"*, r.395) **senza informazione nuova in mezzo — solo l'esito del
  trade**. Conseguenza: da quella live **non si estrae** una regola sull'ingresso a
  retest/imbalance.

**Assenze confermate anche all'ottava trascrizione**: martingala 0 · griglia 0 ·
recovery 0 · mediazione 0 · no-stop 0 · trucchi anti-prop 0 · **regole prop 0**.

---

## 🔗 SEGUITO — live del 25/09/2026 (referto separato, non duplicato qui)

👉 **`backtest_pipeline/caccia_strategie/ANALISI_TRASCRIZIONI_2026-09-25.md`**
(fonte: `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-25.txt`, 436 righe).
La sintesi incrociata aggiornata (tabella dei valori convergenti su tutte le live) sta **là**, §1.1.

- 🔁 **Distanza fra i pendenti ~20 punti: seconda live** (18/09 e 25/09) · **size 1:2 verso il
  livello più forte: terza live** (14/09, 18/09, 25/09). Stessa fonte = coerenza, non verifica.
- 🆕 **Il retest del massimo di ieri, rotto nella notte**, è l'ipotesi A di Unger con il terzo
  tipo d'ordine: R249 ha STOP e FADE, **non il RETEST**. A zero codice su `ABTG_DAX_Apertura_EU`.
- 🔴 **Assenze non più confermate**: la media al ribasso pianificata (*"secondo giro"* con la size
  più grande sotto, r.157-161) e l'ingresso *"sbagliato appositamente"* per mostrare il recupero
  (r.341-361) tornano. Marcati **NON ADOTTABILI**.
