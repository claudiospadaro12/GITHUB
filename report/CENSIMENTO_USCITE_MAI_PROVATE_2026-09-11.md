# 🚪 CENSIMENTO DELLE USCITE MAI PROVATE — 11/09/2026

> **La casella del CERTIFICATO DI MORTE che risulta vuota più spesso è
> _"la gestione dell'uscita è stata messa ad asse?"_.**
> Ieri quella casella ha prodotto: sull'`ABTG_ORB` il ramo `OPPRANGE`, archiviato,
> a parità di rischio sugli **stessi 119 trade** fa **DD 3,84% dove la geometria viva
> ne fa 9,76%** (`report/ORB_OPPRANGE_RIAPERTURA_2026-09-10.md`).
> Questo referto conta, **sedia per sedia**, quante altre caselle come quella sono ancora aperte.

---

## 🎯 1. LA RISPOSTA IN TRE RIGHE

> **1.** Sulle **41 sedie vive** ci sono **333 coppie (sedia × manopola d'uscita)**.
> **274 di quelle coppie non sono MAI state mosse su quella sedia** 🔴🆕 *(LIMITE SUPERIORE: almeno **271**, vedi §3-bis)* — e **110** non hanno
> **mai preso due valori in NESSUNO dei 2.087 CSV** con colonne `Inp*` del repo
> (65 coppie distinte EA × manopola).
>
> **2.** Ma **27 di quelle 274 sono INERTI PER COSTRUZIONE** nella configurazione viva:
> girarle costa passate e **non misura niente**. Sono **falsi positivi**, verificati
> nel codice e nei preset vivi uno per uno. 👉 Le coppie **mai mosse E vive** sono **247** 🔴🆕 *(limite superiore: almeno **244**, §3-bis)*.
>
> **3.** Le tre che valgono il round: **🥇 `InpSLBufferPips` su `970913` SupRev NAS H1**
> (sedia al **72% del pavimento di costo**, PF 1,57 su n=155) · **🥈 `InpSLLookback` su
> `970901` STREV OTT oro** (DD 9,02% contro il muro del 10% = **0,98 punti di margine**,
> n=657) · **🥉 `InpMaxBarsHold` su `772361` COST EURJPY** (n=394, DD 12,3%, **l'orologio
> è l'unica protezione che quel motore ha** e non è mai stato tarato).
> File prova pronti e passati dal cancello: **24 celle, 48 passate**.

---

## 🔬 2. COME È STATO MISURATO — e il CONTRO-ESEMPIO che l'ha quasi rotto

### 2.1 · Il metodo, in tre passi

1. **Dal sorgente, non a memoria.** Per ognuno dei **22 EA** che reggono le 41 sedie ho
   letto il `.mq5` ed estratto tutti gli `input`, poi ho tenuto quelli che toccano
   l'uscita: modo e misura dello stop, buffer dello stop, trailing e la sua soglia,
   breakeven, parziale, target in R o in frazione di range, chiusura a orario/barre,
   uscita su segnale opposto, flat su news.
2. **Sui CSV, con uno script.** `2.300` CSV nel repo, **2.087 con colonne `Inp*`**,
   **582 colonne `Inp*` distinte**. Per ogni colonna: in quanti file prende **più di un
   valore** (= messa ad asse) e quali valori costanti prende negli altri.
3. **Attribuzione all'EA** per nome file/cartella, così che "mai mossa" significhi
   *"mai mossa su QUESTO motore"* e non *"mai mossa da qualche parte"*.

🔁 **Ed è riproducibile, non raccontato:** `backtest_pipeline/censimento_uscite.py`
rifà il conto da zero in ~40 secondi e stampa esattamente i numeri di questo referto
(`2.087 CSV · 582 colonne · 333 coppie · 274 mai mosse · 27 inerti · 2.436 passate`).
Il dettaglio riga per riga finisce in
`backtest_pipeline/risultati_archivio/CENSIMENTO_USCITE_2026-09-11.json`.
La lista delle **inerti per costruzione** è dentro lo script, **una per una con la riga
di sorgente accanto**: non è dedotta dallo script, è stata letta nel codice e scritta a mano.

### 2.2 · 🔴 IL CONTRO-ESEMPIO, costruito PRIMA di scrivere il verdetto

**«La colonna esiste nel CSV ed è costante» NON vuol dire «non è mai stata provata».**
Tre modi in cui quella frase è falsa. Tutti e tre trovati **veri** nell'archivio:

| # | il modo in cui "costante" inganna | prova che è reale, misurata oggi |
|---|---|---|
| **A** | **provata a file separati**: ogni corsa pinna un valore diverso, quindi dentro ogni CSV la colonna è costante | `InpBreakeven` vale **1 in 985 file e 0 in 14 file**. Costante dentro, variata fuori. Idem `InpExitOnEmaClose` (0 in 45 file, 1 in 22), `InpFridayClose` (0 in 325, 1 in 20), `InpSLFixedPts` (3000 in 41, 1000 in 65) |
| **B** | **inerte per costruzione**: la manopola c'è, ma un'altra la spegne | `InpNewsFlatten` sta dentro il ramo che richiede il blackout notizie, e la funzione di blackout **torna `false` quando `InpUseNewsFilter=false`** — che è il valore di **tutti** i preset vivi. Su `ABTG_ORB_Ottimizzato.mq5` **è il codice stesso a dirlo** (r.662): con `InpTP1Pct=0` «NESSUNO stop in pari, anche se `InpBreakeven=true`» |
| **C** | **provata in un round i cui CSV non sono in archivio** | `InpTrailOnST`/`InpExitOnFlip`/`InpFirstFraction`/`InpSLBufferAtr`/`InpSLLookback` hanno **file prova già scritti** (`R120a-e`, `R124a`, `R126a-d`) che **non sono mai girati**: zero CSV `r120*`, zero `r126*`. Cercare solo nei CSV li avrebbe dati per "mai pensati", cercare solo nei file prova li avrebbe dati per "già fatti" |

> 🛑 **Senza il passo B questo referto avrebbe consegnato 27 caselle false.**
> Il conto delle passate buttate, se le si fosse messe ad asse a occhio: **234 passate**
> su misure il cui esito è noto in anticipo — righe identiche al centesimo, come le
> righe `InpTP_R` 1,5 e 2,0 dell'ORB misurate ieri (Pass 11/15, 27/31, 43/47).

### 2.3 · 🧊 LE 27 INERTI PER COSTRUZIONE, per nome (nessuna dedotta: tutte lette nel codice + preset vivo)

| manopola | sedie | perché è morta nella configurazione VIVA | verifica |
|---|---|---|---|
| `InpNewsFlatten` | 770101 · 770202 · 770250 · 770402 · 770411 · 770611 | il blackout notizie non si accende mai: `InpUseNewsFilter=false` in ogni preset vivo | `ABTG_ORB_Ottimizzato.mq5:1353`, `ABTG_DAX_Apertura_EU.mq5:558`, `ABTG_MaxMinNotte.mq5:812`, + i 5 preset |
| `InpTrailAtrMult` | 770101 · 770202 · 770250 | ramo `TRAIL_ATR` morto: nei preset vivi `InpTrailMode=1` (base candela precedente) | `ABTG_DAX_Apertura_EU.mq5:2003-2008` + `ABTG_GatedShort_..._LIVE.set` |
| `InpTrailFixedPts` | 770101 · 770202 · 770250 | ramo `TRAIL_FIXED` morto, stessa ragione | idem |
| `InpAtrSlMult` | 770101 · 770202 · 770250 | ramo `SL_ATR` morto: `InpSLMode=0` (`SL_RANGE`) nei preset vivi | idem |
| `InpAtrSlMult` | 772231-235 (GapFill ×5) · 772341-346 (PunteLarry ×6) | serve solo con `InpSLMode=1`, che vale **0** in ogni corsa d'archivio | `ABTG_GapFill.mq5:458-459`, `ABTG_PunteLarry.mq5:638` |
| `InpAtrSLmult` + `InpSLFixedPts` | 770611 (ORB, **conto REALE**) | rami `ORB_SL_ATR` e `ORB_SL_FIXED` morti: `InpSLMode=3` (HALFRANGE) nel preset reale | `ABTG_ORB_Ottimizzato.mq5:627-639` + `Presets/conto_reale/..._770611_REALE.set` |
| `InpBreakeven` | 770611 | `InpTP1Pct=0` → nessun parziale, quindi **nessuno stop in pari**. Il codice lo stampa a schermo | `ABTG_ORB_Ottimizzato.mq5:662` |
| `InpSLFixedPts` | 770411 | ramo FIXED morto: `InpSLMode=1` (ATR) nel preset vivo | `Presets/ABTG_MaxMinNotte_DAX.set` |

⚠️ **Un caso a metà, dichiarato:** su **`770402` MaxMinNotte oro** l'archivio mostra
`InpSLMode` a **0 in 6 file e 1 in 2 file** e non esiste un preset vivo per XAUUSD.
👉 **Una fra `InpAtrSLmult` e `InpSLFixedPts` è inerte, ma quale è `[NON MISURATO]`.**
Chiude il buco una foto della configurazione in uso (`config_in_uso.ps1`).

### 2.4 · 🧱 E le tre manopole del round hanno passato il contro-esempio

| manopola | file con >1 valore | valori costanti in tutto l'archivio | attiva nel codice? |
|---|---:|---|---|
| `InpSLBufferPips` | **0** | `3` in **280** file, e basta | ✅ `..._NAS_H1_Ottimizzato.mq5:242-243`, nessuna guardia. L'EA **non ha** `InpSLBufferAtr` |
| `InpSLLookback` | **0** | `5` in **290** file, e basta | ✅ stesso blocco, dentro `iLowest(...)` |
| `InpMaxBarsHold` | **0** | `100` in **128** file, e basta | ✅ `ABTG_CostToCost.mq5:799-804`, e il campo l'ha vista mordere il 24/08 |

---

## 📋 3. LA TABELLA — una riga per SEDIA VIVA

**Perimetro:** le **41 sedie** di `report/CENSIMENTO_CONTRATTI.md` (07/09/2026), che è la
lista più recente costruita sui `.chr`. **Righe: 40** — la quarantunesima è
`BREAKOUT_EA_JPY_v3`, che **non ha sorgente nel repo** (buco dichiarato, §5).

_Legenda della colonna "mai mosse": conta solo le manopole **vive** (le inerti sono nella
colonna dopo). "mai in nessun CSV" = la colonna non ha mai preso due valori in nessuno dei
2.087 CSV, né dentro una griglia né fra corse diverse._

| sedia (magic) | EA | simbolo | TF | manopole dell'USCITA che esistono | **mai mosse su questa sedia** | 🧊 inerti per costruzione | **passate per metterle tutte ad asse** |
|---|---|---|---|---|---|---|---:|
| **770101** | `ABTG_DAX_Apertura_EU` | D30EUR | M5 | 17 — `InpBEatR` `InpBreakevenAtTP1` `InpTP1_ClosePct` `InpTP1_R` `InpAtrSlMult` `InpMinStopPts` `InpSkipIfTight` `InpSLMode` `InpTrailAtrMult` `InpTrailFixedPts` `InpTrailMode` `InpTrailStartR` `InpTrailTF` `InpUseTrailing` `InpNewsFlatten` `InpCloseAtEnd` `InpCloseHour` | 🆕 **3** (di cui **1** mai in nessun CSV) — `InpSLMode`(ABTG_SL_RANGE) `InpCloseAtEnd`(true) `InpCloseHour`(ABTG_DEF_CLOSE_HOUR) · 🔴 **ERRATA 11/09**: qui c'erano anche `InpBEatR` `InpBreakevenAtTP1` `InpTP1_R`, e **sono tutte e tre GIÀ STATE MESSE AD ASSE su questa sedia** — `InpBEatR` **0/1** e `InpBreakevenAtTP1` **0/1** in `backtest_pipeline/risultati_prove/gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv` (96 righe, `InpMagic` 770101/770151); `InpBreakevenAtTP1` **0/1** e `InpTP1_R` **0,5/1,0** anche in `risultati_archivio/Walkforward_Aperture/DAX_F_gestione_IS.csv` e `..._OOS.csv` (8 righe, `InpMagic=770101`) | `InpAtrSlMult` `InpTrailAtrMult` `InpTrailFixedPts` `InpNewsFlatten` | 🆕 **24** *(era 54)* |
| **770202** | `ABTG_Dow_Apertura_US` | U30USD | M5 | 17 — `InpBEatR` `InpBreakevenAtTP1` `InpTP1_ClosePct` `InpTP1_R` `InpAtrSlMult` `InpMinStopPts` `InpSkipIfTight` `InpSLMode` `InpTrailAtrMult` `InpTrailFixedPts` `InpTrailMode` `InpTrailStartR` `InpTrailTF` `InpUseTrailing` `InpNewsFlatten` `InpCloseAtEnd` `InpCloseHour` | **10** (di cui **1** mai in nessun CSV) — `InpBEatR`(0) `InpBreakevenAtTP1`(false) `InpTP1_R`(0.5) `InpMinStopPts`(500) `InpSkipIfTight`(false) `InpSLMode`(ABTG_SL_RANGE) `InpTrailStartR`(0) `InpTrailTF`(PERIOD_M5) `InpCloseAtEnd`(true) `InpCloseHour`(ABTG_DEF_CLOSE_HOUR) | `InpAtrSlMult` `InpTrailAtrMult` `InpTrailFixedPts` `InpNewsFlatten` | **94** |
| **770250** | `ABTG_Nasdaq_Apertura_US` | NASUSD | M15 | 18 — `InpBEatR` `InpBreakevenAtTP1` `InpRunnerTP_R` `InpTP1_ClosePct` `InpTP1_R` `InpAtrSlMult` `InpMinStopPts` `InpSkipIfTight` `InpSLMode` `InpTrailAtrMult` `InpTrailFixedPts` `InpTrailMode` `InpTrailStartR` `InpTrailTF` `InpUseTrailing` `InpNewsFlatten` `InpCloseAtEnd` `InpCloseHour` | **6** (di cui **1** mai in nessun CSV) — `InpBEatR`(0) `InpRunnerTP_R`(0.0) `InpSLMode`(ABTG_SL_RANGE) `InpTrailMode`((ENUM_ABTG_TRAIL)ABTG_DEF_TRAIL_MODE) `InpUseTrailing`(true) `InpCloseAtEnd`(true) | `InpAtrSlMult` `InpTrailAtrMult` `InpTrailFixedPts` `InpNewsFlatten` | **54** |
| **770402** | `ABTG_MaxMinNotte` | XAUUSD | H2 | 15 — `InpBreakeven` `InpTP1Pct` `InpTP1_R` `InpTP2Pct` `InpTP2_R` `InpAtrSLmult` `InpSLFixedPts` `InpSLMode` `InpTPfinal_R` `InpUseEMA200Target` `InpTrailAtrMult` `InpUseTrailing` `InpNewsFlatten` `InpCloseAtEnd` `InpCloseHour` | **13** (di cui **1** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpTP2Pct`(50) `InpTP2_R`(2.5) `InpAtrSLmult`(1.5) `InpSLFixedPts`(3000) `InpTPfinal_R`(4.0) `InpUseEMA200Target`(true) `InpTrailAtrMult`(2.0) `InpUseTrailing`(true) `InpCloseAtEnd`(true) `InpCloseHour`(17) | `InpNewsFlatten` | **124** |
| **770411** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | D30EUR | M15 | 15 — `InpBreakeven` `InpTP1Pct` `InpTP1_R` `InpTP2Pct` `InpTP2_R` `InpAtrSLmult` `InpSLFixedPts` `InpSLMode` `InpTPfinal_R` `InpUseEMA200Target` `InpTrailAtrMult` `InpUseTrailing` `InpNewsFlatten` `InpCloseAtEnd` `InpCloseHour` | **6** (di cui **1** mai in nessun CSV) — `InpTP1_R`(1.0) `InpTP2_R`(3.0) `InpAtrSLmult`(2.5) `InpSLMode`(MM_SL_ATR) `InpCloseAtEnd`(true) `InpCloseHour`(17) | `InpSLFixedPts` `InpNewsFlatten` | **54** |
| **770511** | `ABTG_SuperWave_DOW_H1_Ottimizzato` | U30USD | H1 | 11 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferAtr` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpExitOnFlip` | **11** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferAtr`(0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTP_RR`(3.0) `InpTrailOnST`(true) `InpEndHour`(24) `InpExitOnFlip`(true) | — | **114** |
| **770531** | `ABTG_SuperWave` | U30USD | H2 | 11 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferAtr` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpExitOnFlip` | **11** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferAtr`(0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTP_RR`(2.0) `InpTrailOnST`(true) `InpEndHour`(24) `InpExitOnFlip`(true) | — | **114** |
| **770611** | `ABTG_ORB_Ottimizzato` | U30USD | M5 | 15 — `InpBreakeven` `InpTP1Pct` `InpSLBufferPts` `InpAtrSLmult` `InpSLFixedPts` `InpSLMode` `InpTPMode` `InpTPRangeMult` `InpTP_R` `InpUseTrailEMA` `InpNewsFlatten` `InpCloseAtEnd` `InpEndHour` `InpEndMin` `InpExitOnEmaClose` | **1** (di cui **1** mai in nessun CSV) — `InpCloseAtEnd`(true) | `InpBreakeven` `InpAtrSLmult` `InpSLFixedPts` `InpNewsFlatten` | **4** |
| **770901** | `ABTG_SupertrendReversal` | 225JPY | H2 | 12 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpFridayClose` `InpFridayCloseHour` `InpExitOnFlip` | **11** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTrailOnST`(true) `InpEndHour`(24) `InpFridayClose`(false) `InpFridayCloseHour`(20) `InpExitOnFlip`(true) | — | **106** |
| **770924** | `ABTG_SupertrendReversal` | 225JPY | H2 | 12 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpFridayClose` `InpFridayCloseHour` `InpExitOnFlip` | **11** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTrailOnST`(true) `InpEndHour`(24) `InpFridayClose`(false) `InpFridayCloseHour`(20) `InpExitOnFlip`(true) | — | **106** |
| **771201** | `ABTG_PostNews` | EURJPY | M5 | 10 — `InpSLpips` `InpTrailNewSLpips` `InpTPpips` `InpUseOCO` `InpTrailTriggerPips` `InpUseTrail25` `InpCloseAtExpiry` `InpFridayClose` `InpFridayCloseHour` `InpFridayCloseMin` | **10** (di cui **7** mai in nessun CSV) — `InpSLpips`(25.0) `InpTrailNewSLpips`(15.0) `InpTPpips`(50.0) `InpUseOCO`(true) `InpTrailTriggerPips`(25.0) `InpUseTrail25`(true) `InpCloseAtExpiry`(true) `InpFridayClose`(true) `InpFridayCloseHour`(21) `InpFridayCloseMin`(50) | — | **86** |
| **771202** | `ABTG_PostNews` | EURUSD | M5 | 10 — `InpSLpips` `InpTrailNewSLpips` `InpTPpips` `InpUseOCO` `InpTrailTriggerPips` `InpUseTrail25` `InpCloseAtExpiry` `InpFridayClose` `InpFridayCloseHour` `InpFridayCloseMin` | **10** (di cui **7** mai in nessun CSV) — `InpSLpips`(25.0) `InpTrailNewSLpips`(15.0) `InpTPpips`(50.0) `InpUseOCO`(true) `InpTrailTriggerPips`(25.0) `InpUseTrail25`(true) `InpCloseAtExpiry`(true) `InpFridayClose`(true) `InpFridayCloseHour`(21) `InpFridayCloseMin`(50) | — | **86** |
| **771203** | `ABTG_PostNews` | USDJPY | M5 | 10 — `InpSLpips` `InpTrailNewSLpips` `InpTPpips` `InpUseOCO` `InpTrailTriggerPips` `InpUseTrail25` `InpCloseAtExpiry` `InpFridayClose` `InpFridayCloseHour` `InpFridayCloseMin` | **10** (di cui **7** mai in nessun CSV) — `InpSLpips`(25.0) `InpTrailNewSLpips`(15.0) `InpTPpips`(50.0) `InpUseOCO`(true) `InpTrailTriggerPips`(25.0) `InpUseTrail25`(true) `InpCloseAtExpiry`(true) `InpFridayClose`(true) `InpFridayCloseHour`(21) `InpFridayCloseMin`(50) | — | **86** |
| **771321** | `ABTG_PTE` | U30USD | H1 | 6 — `InpBreakeven` `InpTP1Pct` `InpTP1_ATRmult` `InpTP2_ATRmult` `InpUseTrailing` `InpAtrExitPeriod` | **4** (di cui **1** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpUseTrailing`(true) `InpAtrExitPeriod`(14) | — | **40** |
| **771322** | `ABTG_PTE` | GBPUSD | H1 | 6 — `InpBreakeven` `InpTP1Pct` `InpTP1_ATRmult` `InpTP2_ATRmult` `InpUseTrailing` `InpAtrExitPeriod` | **4** (di cui **1** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpUseTrailing`(true) `InpAtrExitPeriod`(14) | — | **40** |
| **771332** | `ABTG_PTE` | GBPUSD | H1 | 6 — `InpBreakeven` `InpTP1Pct` `InpTP1_ATRmult` `InpTP2_ATRmult` `InpUseTrailing` `InpAtrExitPeriod` | **4** (di cui **1** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpUseTrailing`(true) `InpAtrExitPeriod`(14) | — | **40** |
| **771531** | `ABTG_EMA200` | U30USD | H1 | 8 — `InpBreakeven` `InpTP1Pct` `InpTP1_ATRmult` `InpSLatr` `InpTP_RR` `InpUseTrailing` `InpFridayClose` `InpFridayCloseHour` | **7** (di cui **0** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpTP1_ATRmult`(0.0) `InpSLatr`(1.0) `InpUseTrailing`(true) `InpFridayClose`(false) `InpFridayCloseHour`(20) | — | **70** |
| **772161** | `ABTG_BreakingBand` | GBPUSD | H1 | 7 — `InpBEMode` `InpBEatATR` `InpTP1Pct` `InpSL_ATRmult` `InpMinTPatATR` `InpTPMode` `InpTPRefreshBars` | **7** (di cui **5** mai in nessun CSV) — `InpBEMode`(0) `InpBEatATR`(1.0) `InpTP1Pct`(50.0) `InpSL_ATRmult`(3.0) `InpMinTPatATR`(0.0) `InpTPMode`(0) `InpTPRefreshBars`(1) | — | **68** |
| **772162** | `ABTG_BreakingBand` | EURUSD | H1 | 7 — `InpBEMode` `InpBEatATR` `InpTP1Pct` `InpSL_ATRmult` `InpMinTPatATR` `InpTPMode` `InpTPRefreshBars` | **7** (di cui **5** mai in nessun CSV) — `InpBEMode`(0) `InpBEatATR`(1.0) `InpTP1Pct`(50.0) `InpSL_ATRmult`(3.0) `InpMinTPatATR`(0.0) `InpTPMode`(0) `InpTPRefreshBars`(1) | — | **68** |
| **772163** | `ABTG_BreakingBand` | AUDUSD | H1 | 7 — `InpBEMode` `InpBEatATR` `InpTP1Pct` `InpSL_ATRmult` `InpMinTPatATR` `InpTPMode` `InpTPRefreshBars` | **7** (di cui **5** mai in nessun CSV) — `InpBEMode`(0) `InpBEatATR`(1.0) `InpTP1Pct`(50.0) `InpSL_ATRmult`(3.0) `InpMinTPatATR`(0.0) `InpTPMode`(0) `InpTPRefreshBars`(1) | — | **68** |
| **772231** | `ABTG_GapFill` | GBPUSD | - | 4 — `InpAtrSlMult` `InpSLGapMult` `InpSLMode` `InpMaxHours` | **3** (di cui **2** mai in nessun CSV) — `InpSLGapMult`(1.0) `InpSLMode`(0) `InpMaxHours`(48) | `InpAtrSlMult` | **36** |
| **772232** | `ABTG_GapFill` | EURUSD | - | 4 — `InpAtrSlMult` `InpSLGapMult` `InpSLMode` `InpMaxHours` | **3** (di cui **2** mai in nessun CSV) — `InpSLGapMult`(1.0) `InpSLMode`(0) `InpMaxHours`(48) | `InpAtrSlMult` | **36** |
| **772233** | `ABTG_GapFill` | AUDUSD | - | 4 — `InpAtrSlMult` `InpSLGapMult` `InpSLMode` `InpMaxHours` | **3** (di cui **2** mai in nessun CSV) — `InpSLGapMult`(1.0) `InpSLMode`(0) `InpMaxHours`(48) | `InpAtrSlMult` | **36** |
| **772234** | `ABTG_GapFill` | U30USD | - | 4 — `InpAtrSlMult` `InpSLGapMult` `InpSLMode` `InpMaxHours` | **3** (di cui **2** mai in nessun CSV) — `InpSLGapMult`(1.0) `InpSLMode`(0) `InpMaxHours`(48) | `InpAtrSlMult` | **36** |
| **772235** | `ABTG_GapFill` | 225JPY | - | 4 — `InpAtrSlMult` `InpSLGapMult` `InpSLMode` `InpMaxHours` | **3** (di cui **2** mai in nessun CSV) — `InpSLGapMult`(1.0) `InpSLMode`(0) `InpMaxHours`(48) | `InpAtrSlMult` | **36** |
| **772341** | `ABTG_PunteLarry` | U30USD | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772342** | `ABTG_PunteLarry` | EURAUD | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772343** | `ABTG_PunteLarry` | XAUUSD | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772344** | `ABTG_PunteLarry` | GBPJPY | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772345** | `ABTG_PunteLarry` | GBPUSD | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772346** | `ABTG_PunteLarry` | EURCAD | H1 | 6 — `InpSLBufferATR` `InpAtrSlMult` `InpSLMode` `InpTP_R` `InpMaxDaysHold` `InpExitMode` | **4** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.1) `InpSLMode`(0) `InpTP_R`(1.5) `InpMaxDaysHold`(5) | `InpAtrSlMult` | **44** |
| **772361** | `ABTG_CostToCost` | EURJPY | - | 4 — `InpSLBufferATR` `InpTP_R` `InpMaxBarsHold` `InpExitMode` | **3** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.2) `InpTP_R`(1.5) `InpMaxBarsHold`(100) | — | **36** |
| **772362** | `ABTG_CostToCost` | GBPCAD | - | 4 — `InpSLBufferATR` `InpTP_R` `InpMaxBarsHold` `InpExitMode` | **3** (di cui **1** mai in nessun CSV) — `InpSLBufferATR`(0.2) `InpTP_R`(1.5) `InpMaxBarsHold`(100) | — | **36** |
| **772421** | `ABTG_EasyTrend` | CHFJPY | - | 2 — `InpSLBufferPts` `InpTP_R` | **1** (di cui **0** mai in nessun CSV) — `InpSLBufferPts`(30) | — | **10** |
| **772422** | `ABTG_EasyTrend` | GBPUSD | - | 2 — `InpSLBufferPts` `InpTP_R` | **1** (di cui **0** mai in nessun CSV) — `InpSLBufferPts`(30) | — | **10** |
| **774101** | `ABTG_GapContinuation` | 225JPY | M1 | 7 — `InpMoveStopToBreakEven` `InpPartialClosePercent` `InpPartialTargetR` `InpStopBufferPoints` `InpFinalTargetR` `InpExitMinutesBeforeClose` `InpSessionCloseHour` | **6** (di cui **6** mai in nessun CSV) — `InpMoveStopToBreakEven`(true) `InpPartialClosePercent`(40.0) `InpPartialTargetR`(1.0) `InpStopBufferPoints`(0.0) `InpExitMinutesBeforeClose`(5) `InpSessionCloseHour`(15) | — | **56** |
| **970901** | `ABTG_SupertrendReversal_Ottimizzato` | XAUUSD | H4 | 10 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpExitOnFlip` | **10** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTP_RR`(2.5) `InpTrailOnST`(true) `InpEndHour`(24) `InpExitOnFlip`(true) | — | **96** |
| **970912** | `ABTG_SupRev_DAX_H4_Ottimizzato` | D30EUR | H4 | 10 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpExitOnFlip` | **10** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTP_RR`(3.0) `InpTrailOnST`(true) `InpEndHour`(24) `InpExitOnFlip`(true) | — | **96** |
| **970913** | `ABTG_SupRev_NAS_H1_Ottimizzato` | NASUSD | H1 | 10 — `InpBreakeven` `InpFirstFraction` `InpTP1Pct` `InpTP1_R` `InpSLBufferPips` `InpSLLookback` `InpTP_RR` `InpTrailOnST` `InpEndHour` `InpExitOnFlip` | **10** (di cui **5** mai in nessun CSV) — `InpBreakeven`(true) `InpFirstFraction`(0.3333) `InpTP1Pct`(50) `InpTP1_R`(1.0) `InpSLBufferPips`(3) `InpSLLookback`(5) `InpTP_RR`(3.0) `InpTrailOnST`(true) `InpEndHour`(24) `InpExitOnFlip`(true) | — | **96** |
| **971501** | `ABTG_EMA200_Ottimizzato` | XAUUSD | H4 | 8 — `InpBreakeven` `InpTP1Pct` `InpTP1_ATRmult` `InpSLatr` `InpTP_RR` `InpUseTrailing` `InpFridayClose` `InpFridayCloseHour` | **8** (di cui **0** mai in nessun CSV) — `InpBreakeven`(true) `InpTP1Pct`(50) `InpTP1_ATRmult`(0.0) `InpSLatr`(1.0) `InpTP_RR`(2.0) `InpUseTrailing`(true) `InpFridayClose`(false) `InpFridayCloseHour`(20) | — | **80** |
## 🔴🆕 3-bis. ERRATA DELL'11/09 SERA — `ea_of()` non vede 668 CSV, e il conto è un LIMITE SUPERIORE

**Il fatto, misurato:** la riga della **`770101`** dichiarava «mai mosse: 6», e **tre di
quelle sei erano già state messe ad asse su quella stessa sedia**. I file:

| manopola | valori presi | file (magic verificato dentro il CSV) |
|---|---|---|
| `InpBEatR` | **0 / 1** | `backtest_pipeline/risultati_prove/gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv` — 96 righe, `InpMagic` **770101/770151** |
| `InpBreakevenAtTP1` | **0 / 1** | lo stesso file **+** `risultati_archivio/Walkforward_Aperture/DAX_F_gestione_IS.csv` e `..._OOS.csv` (8 righe, `InpMagic=770101`) |
| `InpTP1_R` | **0,5 / 1,0** | `Walkforward_Aperture/DAX_F_gestione_IS.csv` e `..._OOS.csv` |

🔎 **La causa, letta nel codice, non dedotta:** `censimento_uscite.py` attribuisce un CSV
a un EA con `ea_of()` (r.222-228), che riconosce solo i file il cui **basename comincia**
col nome dell'EA, oppure che stanno in una **cartella chiamata come l'EA**. I file qui
sopra si chiamano `gestione_ABTG_...` (il nome dell'EA c'è, ma **non in testa**) e
`DAX_F_gestione_*` dentro `Walkforward_Aperture/` (il nome dell'EA **non c'è affatto**):
`ea_of()` torna **`None`** e il file **non conta per nessun motore**.

📏 **Quanto è grande il buco, misurato e non stimato: `ea_of()` torna `None` su 668 CSV
dei 2.087 con colonne `Inp*`, e sono CSV che hanno almeno una colonna AD ASSE.**

🔴 **Conseguenza sui numeri di questo referto — e va detta prima di usarli:**
- i **274 «mai mosse»**, i **247 «mai mosse E vive»** e le **2.436 passate** sono un
  **LIMITE SUPERIORE**, non una misura: `[DA RIVERIFICARE]`;
- di sicuro sono **almeno 3 di meno** (271 e 244) e le passate **al più 2.406**, perché
  le tre coppie della `770101` sono **verificate false una per una**;
- 🟢 **il verso dell'errore è quello buono per il RISCHIO** (dice «mai provata» dove
  invece è stata provata: fa **sprecare passate**, non prendere rischi), **ma è quello
  cattivo per il CERTIFICATO DI MORTE**: una casella *«gestione messa ad asse?»* segnata
  vuota quando è piena **è lo stesso errore di misura, rovesciato**.

🛠️ **La correzione vera è una riga di `ea_of()`** (riconoscere il nome dell'EA **ovunque**
nel percorso, e in seconda battuta attribuire per `InpMagic`), **poi si rigira lo script e
si rifà la tabella**. Qui ho corretto **solo la riga della `770101`**, che è quella che ho
verificato a mano file per file: **non dichiaro corrette le altre 39.**

---

> **Totale: 2.436 passate** per mettere ad asse **tutto** il mai-mosso della flotta.
> 🔴🆕 **Limite superiore: al più 2.406** — vedi l'errata del §3-bis.
> 💰 **Nessuno lancerà mai 2.436 passate.** Il numero serve a una cosa sola: dire che
> questa miniera non si esaurisce in un round, e che va scavata **in ordine di valore**.
> È esattamente il senso del §4.

---

## 🏆 4. LA CLASSIFICA — valore diviso costo

Ordine dichiarato **prima** di guardare le sedie, come da mandato:
🥇 sedie **vicine a un cancello** (lì una manopola ribalta un verdetto) ·
🥈 manopole che **allargano lo stop** (leva misurata tre volte in casa: R55, R88, R118) ·
🥉 in fondo le sedie già promosse o già morte con certificato completo.

### 4.0 · ⚠️ PRIMA DI TUTTO: quattro round sono GIÀ PRONTI e non sono mai partiti

**La cosa più economica che esista in questo dossier non è un file nuovo: è una firma.**

| round | cosa mette ad asse | sedia | stato | perché conta |
|---|---|---|---|---|
| **R126a-d** | `InpSLBufferAtr` (+ `InpSLLookback`) | **770511 SuperWave DOW H1** | file scritti, cancello passato, **NON firmato**, **mai girato** | è la sedia al **96% del pavimento di costo** (38,5x contro 40x): la numero 1 per prossimità al cancello. **Il suo file esiste già** |
| **R120a-e** | `InpTrailOnST` × `InpExitOnFlip` | 970913 NAS · 770511 DOW · 970901 oro · 970912 DAX | file scritti, **mai girati** (zero CSV `r120*`) | è il **primo round del progetto che mette ad asse la gestione dell'uscita della famiglia Supertrend**, ed è fermo da due giorni |
| **R124a** | `InpFirstFraction` | 770511 | file scritto, mai girato | la frazione d'ingresso 1/3 gira dal luglio senza una misura |
| **R125a-f** | buffer, parziale, lato, ampiezza | 770611 ORB · 770101 DAX | **FIRMATO il 10/09**, mai girato | 66 passate, ~7 minuti |

🔴 **Queste quattro voci non producono file nuovi in questo dossier, apposta.**
Aggiungere un quinto file su `770511` sarebbe lavoro doppio: quella casella **è già
coperta**, aspetta solo di partire.

### 4.1 · 🥇🥈🥉 I TRE CHE VALGONO IL ROUND (file pronti, cancello passato)

| # | manopola | sedia | perché è in cima | celle | passate |
|---|---|---|---|---:|---:|
| 🥇 | **`InpSLBufferPips`** | **970913** `SupRev_NAS_H1_Ott` NASUSD H1 | **72% del pavimento di costo** (28,7x contro 40x). È l'**unica** manopola di quell'EA che allarga lo stop (non ha `InpSLBufferAtr`). E la sedia ha **MERITO PIENO**: PF 1,57 · DD 1,17% · **n=155**. La soglia dei 40x cade **dentro l'asse** | 9 | **18** |
| 🥈 | **`InpSLLookback`** | **970901** `STREV_Ott` XAUUSD H4 | **DD 9,02% contro il muro prop del 10%** = 0,98 punti di margine, su **n=657** e 22 anni. R99 scrive testualmente «il margine è SOTTILE». Allarga lo stop **in modo stazionario** (barre, non punti: su 22 anni d'oro da 400$ a 3.500$ è l'unica scelta difendibile) | 7 | **14** |
| 🥉 | **`InpMaxBarsHold`** | **772361** `CostToCost` EURJPY H4 | **n=394 → il MERITO si legge** (raro: su 28 righe-sedia su 43 è sospeso). DD 12,3% = terzo più alto della flotta. E il DIARIO del 24/08 lo dice in chiaro: «COST non ha né BE né trailing, **il suo unico meccanismo di protezione è l'orologio**» — e quell'orologio non è **mai** stato tarato | 8 | **16** |
| | | | **TOTALE** | **24** | **48** |

📁 File: `backtest_pipeline/prove/R127a_slbuffer_NASUSD.txt` ·
`R127b_sllookback_XAUUSD.txt` · `R127c_orologio_EURJPY.txt`
📜 Criteri congelati **prima** dei numeri, in un file a parte:
`backtest_pipeline/prove/R127_USCITE_CRITERI.md` — con la procedura `P1..P8` **presa per
riferimento** da `R125_ORB_COSTO_CRITERI.md`, non riscritta.
✅ `controlla_prova.py`: **3 file, 24 celle, 48 passate, 0 problemi**.
✅ `controlla_riga.py --ps1` sui criteri: **ASCII puro, nessun difetto meccanico**.
✅ Magic vergini cercati per grep su tutto il repo: **779410 / 779420 / 779430**, zero occorrenze.

⏱️ **Tempo macchina**: R88a ha girato **48 celle × 2 finestre in 8,0 minuti** (tick, M5,
21 mesi). `R127a` è meno della metà di quel lavoro. 🔴 **Il tempo di `R127b` (22 anni, H4,
OHLC) è `[NON MISURATO]`**: la corsa R99 sullo stesso EA e sulla stessa finestra esiste,
ma il suo tempo non è scritto in nessun referto. Si misura al primo giro.

### 4.2 · 🥈 La panchina — buone, ma dietro alle prime tre

| manopola | sedie | perché non è in cima | passate |
|---|---|---|---:|
| `InpSLGapMult` | 772231-235 (**5 gemelli**) | è la **geometria intera dello stop** di GapFill e non è mai stata mossa; `772234` sta all'**88%** del pavimento. Ma **n=8-20 per sedia** → merito sospeso, e lo stop del cancello è misurato su **una sola gamba** | 12 ×5 |
| `InpMaxHours` | 772231-235 | il time-stop a 48 ore, mai tarato, stesso problema di campione | 14 ×5 |
| `InpSL_ATRmult` | 772161-163 (BreakingBand ×3) | «GUIDA: SL = 3 × ATR (regola fissa)» — mai messa in discussione. Ma n=11-26 | 14 ×3 |
| `InpMaxDaysHold` | 772341-346 (PunteLarry ×6) | 6 sedie in un colpo, orologio mai tarato. Ma PF ~1,05: il motore è al limite | 14 ×6 |
| `InpCloseAtEnd` | 770101 · 770202 · 770250 · 770402 · 770411 · **770611** | il flat di fine seduta **decide il P&L di ogni sedia intraday** e non è mai stato acceso/spento. 🔴 Ma su `770611` la sedia è sul **conto REALE**: si misura, non si tocca | 4 ×6 |
| `InpPartialTargetR` + `InpPartialClosePercent` | 774101 GapContinuation | il parziale 40%/1,0R non è mai stato mosso. ⚠️ Vincolo di codice: `InpPartialClosePercent` deve stare in (0,100) e `InpFinalTargetR > InpPartialTargetR`, altrimenti **INIT_FAILED** | 20 |

### 4.3 · 🥉 In fondo, e perché

- **Le tre `PostNews` (771201/2/3): 30 coppie mai mosse, ma il round giusto non è questo.**
  Quelle sedie hanno **🔴 NESSUN DD misurato** (`CENSIMENTO_CONTRATTI.md` §4d) e il PASSO 0
  non ha mai prodotto un CSV. **Tarare l'uscita di un motore di cui non si conosce il PF
  è mettere il tetto prima delle fondamenta.** Prima il PASSO 0, poi l'uscita.
- **`971501` EMA200 oro (8 manopole mai mosse):** DD 45,91% a 1%, firmato il 23/08 come
  **«prop: NO a nessuna taglia»**. Il merito di una manopola qui non cambia il verdetto.
- **`772362` COST GBPCAD:** PF 0,92 su n=382 → **motore senza edge su quel simbolo**, e la
  regola del 19/08 vieta di infittire. `InpMaxBarsHold` ci resta come **gemello di
  controllo** di 🥉, non come candidato.

---

## 🕳️ 5. I BUCHI, dichiarati

1. **`BREAKOUT_EA_JPY_v3` non ha sorgente nel repo.** 41ª sedia, zero manopole
   censibili. Resta `[NON MISURATO]`, come già nel censimento dei contratti.
2. **Il perimetro eredita i buchi del 07/09**: l'ultima foto `.chr` è del **25/08**, 5
   sedie "aperture" sono contese fra due fonti, e il conto su cui gira `770250` non è
   deducibile dai documenti. **Questo referto non li chiude.**
3. **L'attribuzione CSV → EA è per nome file/cartella.** Su **1.419** CSV su 2.087 l'EA è
   riconosciuto; sugli altri la colonna conta solo nel totale globale. 👉 Effetto: può
   rendere un "mai mossa su questo EA" **più prudente del vero** (cioè dichiarare
   "già provata altrove" qualcosa che era di un altro motore), **mai il contrario**.
4. **Le manopole ferme al proprio valore di spegnimento non sono "inerti per
   costruzione"**: `InpMinTPatATR=0`, `InpRunnerTP_R=0`, `InpBEatR=0`, `InpDivMaxBars=0`.
   Lì **accenderle È il test**. Sono contate fra le mai-mosse vive, e va detto.
5. **`InpSLBufferPips=3` è vivo nel codice ma quasi nullo nei fatti** su indici e oro
   (`_Point`=0,01 → 0,03 punti). 🔴 **Ma NON su 225JPY**, dove `_Point`=1,00: su
   `770901`/`770924` Nikkei quei 3 sono **3 punti indice veri**. Stessa riga di codice,
   due significati: è il motivo per cui la tabella delle unità di
   `CANCELLO_COSTO_FLOTTA_2026-09-10.md` va letta ogni volta.
6. **Nessun backtest è stato eseguito qui.** Tutti i numeri di questo referto vengono da
   CSV e referti già agli atti, o dal conteggio delle colonne. Dove manca: `[NON MISURATO]`.

---

## 📌 6. COSA SERVE DA CLAUDIO

| # | cosa | costo | perché |
|---|---|---|---|
| 1 | **Firmare o bocciare R126** (SuperWave 770511) | una lettura | è la sedia **più vicina a un cancello** di tutta la flotta e il suo file è pronto da ieri |
| 2 | **Firmare o bocciare R127** (questi tre file) | una lettura | 48 passate, ~15 minuti stimati sul terminale di **backtest** |
| 3 | **Lanciare R125**, già firmato il 10/09 | 66 passate, ~7 min | è firmato e fermo |
| 4 | **Una foto `config_in_uso.ps1` di `770402`** (MaxMinNotte oro, conto **piccolo 50503392**, cartella `BCM Markets MT5 Terminal`) | ~2 min | chiude l'unico caso in cui non so **quale** delle due manopole dello stop sia inerte |

🚫 Niente di tutto questo tocca il forward, i preset, i terminali con le sedie vive o il
conto reale **10105439**. Sono solo file di testo e un terminale di backtest.
