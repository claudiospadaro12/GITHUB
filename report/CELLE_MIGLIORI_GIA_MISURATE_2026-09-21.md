# 🏺 CELLE MIGLIORI GIÀ MISURATE — le sei sedie che volano su FTMO
**21/09/2026 · sola lettura · nessun backtest eseguito, nessun EA toccato, nessun preset modificato**

> **La domanda**: esistono ALTRE celle come `770101 InpTP1_ClosePct 50 → 0` —
> cioè **già misurate in archivio**, che battono il preset che vola **su PF E su DD,
> in campione E fuori campione**, a costo zero di tempo macchina?
>
> **La risposta in una riga**: 🟢 **SÌ, ne esistono altre due di sostanza**
> (`770511 InpSLBufferAtr` e `771531 InpTP_RR`), 🟠 **una terza che è un cambio di
> rischio travestito** (`771531 InpSLatr`), e 🔴 **due sedie su sei dove l'archivio
> dice NO e lo dice bene** (`770202`, `770411`). Nessuna delle nuove è pronta per una
> firma stanotte: tutte e due hanno un **buco dichiarato** che costa poche passate.

---

## 📐 IL METODO, prima dei numeri (perché il numero senza il metodo non vuol dire niente)

**Come ho cercato.** Per ognuna delle sei sedie ho preso **ogni** `Inp*` dal `.set`
FTMO che vola, poi ho scandito **2.377 CSV** sotto
`backtest_pipeline/risultati_prove/` e `backtest_pipeline/risultati_archivio/`
cercando, dentro **la stessa corsa**, la coppia (cella-che-vola, cella-a-UNA-manopola)
e tenendo solo i casi con **PF su E DD giù, in tutte le finestre disponibili di
quella corsa**.

**Le cinque decisioni di metodo, dichiarate perché cambiano il risultato:**

1. 🔑 **I knob di AMBIENTE sono esclusi dal confronto di identità.** `InpSessionHour`,
   `InpCloseHour`, `InpCorrSymbol`, `InpRiskPercent`, `InpMagic`, i `InpNews*`.
   Motivo misurato: il preset FTMO porta `InpSessionHour=10` (orologio FTMO) mentre
   ogni CSV d'archivio porta `8` (orologio BCM), e `InpCorrSymbol=US500.cash` contro
   `SPXUSD`. Senza questa esclusione **zero celle sarebbero risultate confrontabili**
   e il referto sarebbe stato "non c'è niente" — che è falso.
2. 🔑 **Le manopole che esistono nel sorgente ma NON nel `.set` sono state confrontate
   contro il DEFAULT del sorgente**, non ignorate. **È questa scelta che ha trovato il
   candidato `770511`**: alla prima passata `InpSLBufferAtr` non era nel preset, quindi
   nove celle diverse mi risultavano "identiche" e l'intero file `r126a` spariva.
   👉 Il difetto e la sua correzione sono la parte più utile di questo dossier.
3. 🔑 **Il DD si guarda anche in VALUTA**, non solo in `Equity DD %`. Misura usata:
   `DD_valuta = Profit / Recovery Factor` (definizione MT5 del Recovery Factor).
   Serve al contro-esempio obbligatorio: *un'equity più alta fa sembrare più piccola
   la stessa discesa*.
4. 🔑 **Tutti i CSV d'archivio girano a `InpRiskPercent=1`**, i preset FTMO a `2.00`.
   Verificato file per file. 👉 **I DD% qui sotto NON sono i DD% che vedrà FTMO**:
   servono a confrontare due celle fra loro (stesso rischio in tutte e due), non a
   promettere un drawdown.
5. 🔑 **Regola di selezione: CENTRO DELL'ALTOPIANO, MAI IL PICCO.** Dichiarata qui,
   applicata sotto cella per cella. Dove l'asse ha **solo due valori** lo scrivo:
   in quel caso l'altopiano **non è valutabile**, e il candidato scende di fascia.

---

## 🎯 § 1 — I CANDIDATI, uno per riga

| # | sedia | manopola | vola → proposto | PF IS | PF OOS | DD% IS | DD% OOS | n IS/OOS | fascia |
|---|---|---|---|--:|--:|--:|--:|--:|---|
| **A** | `770101` DAX | `InpTP1_ClosePct` | **50 → 0** | 1,12634 → **1,18323** | 1,39709 → **1,49140** | 5,4362 → **4,9576** | 7,2328 → **6,2719** | 132/193 pos. | 🟢 **FIRMA** (già documentato) |
| **B** | `770511` SuperWave | `InpSLBufferAtr` | **0 → 0,625** *(centro)* | 1,48166 → **1,87917** | 1,24312 → **1,30645** | 4,0393 → **3,2341** | 4,1675 → **3,9886** | 67/120 | 🟠 **SECONDA FASCIA** |
| **C** | `771531` EMA200 | `InpTP_RR` | **2,0 → 2,5** | *(finestra unica)* | 1,39181 → **1,42783** tick | — | 7,4298 → **7,3132** tick | 658/669 | 🟠 **SECONDA FASCIA** |
| **D** | `771531` EMA200 | `InpSLatr` | **1,0 → 1,4** | 1,20110 → **1,21824** | 1,52365 → **1,59482** | 5,7325 → **4,2725** | 7,8323 → **5,7684** | 242/529 | 🔴 **DECLASSATO: è un cambio di rischio** |
| **E** | `771531` EMA200 | `InpOrder1Atr` | **0,20 → 0,10** | *(finestra unica)* | 1,40550 → **1,45006** OHLC | — | 6,2894 → **5,8060** OHLC | 603 | 🔴 **DECLASSATO: una corsa sola, OHLC** |

E sotto, i **tre candidati che il contro-esempio ha ucciso** (§ 3) e le **due sedie
senza candidati** (§ 4).

---

## 🟢 § 2A — CANDIDATO A · `770101` `InpTP1_ClosePct` 50 → 0
**Non è una scoperta di questo dossier: è già a referto.** Lo confermo e lo colloco.

| finestra | cella VIVA (50) | cella proposta (0) | DD in VALUTA |
|---|---|---|---|
| IS | PF 1,12634 · DD 5,4362% · +3.789,36 | PF **1,18323** · DD **4,9576%** · +5.569,37 | 5.876 → **5.441** ✅ |
| OOS | PF 1,39709 · DD 7,2328% · +18.029,58 | PF **1,49140** · DD **6,2719%** · +23.607,28 | 8.886 → **7.974** ✅ |

**Fonti (file e riga):**
- `backtest_pipeline/risultati_prove/aperture_r46/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r46a.csv` — righe dati 1 e 2
- `backtest_pipeline/risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r137c.csv` — righe dati 1 e 2
- `backtest_pipeline/risultati_prove/gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv` — righe dati 53/54 (cella 0) contro 55/56 (cella 50)
- criteri e aritmetica: `backtest_pipeline/prove/R137c_parziale_770101_D30EUR.txt`

### 🛑 IL CONTRO-ESEMPIO CHE MI ERA STATO CHIESTO — **superato**
*«il DD scende anche perché il profitto sale»*: il DD in **valuta** scende lo stesso
(8.886 → 7.974 in OOS, 5.876 → 5.441 in IS). **Non è effetto denominatore.**

### ⚠️ Un secondo contro-esempio che ho costruito io, e che è quello vero
**«sono due misure indipendenti?» NO.** `r46a` e `r137c` danno numeri **identici al
quinto decimale** — `r137c` è la **riproduzione** di `r46a` su magic `786201`
(asse tecnico). E `gestione_20260909` gira su `FromDate=2024.09.26 · ToDate=2026.06.30`
(`backtest_pipeline/scan_gestione.ps1` r.191-192), cioè **la stessa finestra di r46a non
spezzata**: infatti `n=445 = 175 IS + 270 OOS`, esattamente.
👉 **Una sola base dati, letta tre volte.** Vale come *riproducibilità*, non come
*indipendenza*. **Detto.**

### 📐 Altopiano o picco?
L'asse ha **solo due valori in tutto l'archivio** (`0` e `50`), quindi **sull'asse
l'altopiano non è valutabile**. È valutabile **sui vicini di configurazione**, e lì
tiene: dentro `gestione_20260909`, con il trailing ACCESO in modalità 1 (come vola),
`ClosePct=0` batte `50` in **tutte e quattro** le combinazioni di `InpBreakevenAtTP1` ×
`InpBEatR` (righe 49/51, 53/55, 57/59, 61/63).
🔴 **E si ribalta quando il trailing è SPENTO**: a `InpUseTrailing=0` + `BE=1`, la cella
`50` vince nettamente (PF 1,16719 · DD 10,2435% contro PF 1,10598 · DD **22,2108%**).
👉 **Il vantaggio è CONDIZIONATO al trailing acceso.** La sedia ce l'ha acceso. Ma la
frase onesta è *"vince con questa gestione"*, non *"vince"*.

### 💰 Costo
**Zero tempo macchina.** Una riga nel `.set` FTMO. È una **firma**, non un round.

---

## 🟠 § 2B — CANDIDATO B · `770511` `InpSLBufferAtr` 0 → 0,625
🔥 **La manopola che vale la pena guardare: non è nel `.set`, quindi vola a `0` per
default — e in archivio c'è un asse a 9 celle che nessuno ha mai letto in questa chiave.**

`InpSLBufferAtr` esiste nel sorgente (`mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`
r.80, default `0`, *«>0: buffer SL in ATR del TF operativo, IGNORA InpSLBufferPips»*) e
**non compare nel preset FTMO** — fatto già segnalato in
`report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` passo 11.

**Fonte:** `backtest_pipeline/risultati_prove/dal_vps/ABTG_SuperWave_DOW_H1_Ottimizzato/ABTG_SuperWave_DOW_H1_Ottimizzato_U30USD_{IS,OOS}_r126a.csv`, 9 righe ciascuno, **tick reali (Modello 4)**, deposito 10.000, rischio 1,0.

| `InpSLBufferAtr` | riga IS | PF IS | DD% IS | DDval IS | riga OOS | PF OOS | DD% OOS | DDval OOS | batte la cella viva? |
|--:|--:|--:|--:|--:|--:|--:|--:|--:|---|
| **0,000 (VOLA)** | 1 (Pass 0) | 1,48166 | 4,0393 | 435 | 1 (Pass 0) | 1,24312 | 4,1675 | 443 | — |
| 0,125 | 4 (Pass 1) | 1,55847 | 3,5872 | 388 | 3 (Pass 1) | 1,27637 | 3,6657 | 388 | ✅ |
| 0,250 | 6 (Pass 2) | 1,62582 | 3,5762 | 388 | 5 (Pass 2) | 1,23362 | 4,3639 | 464 | ❌ (PF e DD OOS) |
| 0,375 | 8 (Pass 3) | 1,68151 | 3,5895 | 391 | 7 (Pass 3) | 1,30686 | 4,2453 | 453 | ❌ (DD OOS) |
| **0,500** | 2 (Pass 4) | 1,73836 | 3,2551 | 354 | 2 (Pass 4) | 1,40233 | 4,0284 | 432 | ✅ |
| **0,625** | 3 (Pass 5) | **1,87917** | 3,2341 | 354 | 4 (Pass 5) | 1,30645 | 3,9886 | 426 | ✅ |
| **0,750** | 5 (Pass 6) | 1,70417 | 3,2778 | 354 | 6 (Pass 6) | 1,32240 | 3,7909 | 404 | ✅ |
| **0,875** | 7 (Pass 7) | 1,81661 | 2,5699 | 277 | 8 (Pass 7) | 1,24706 | 3,3535 | 354 | ✅ |
| **1,000** | 9 (Pass 8) | 1,80377 | 2,3734 | 256 | 9 (Pass 8) | 1,28209 | 3,1454 | 332 | ✅ |

### 📐 ALTOPIANO, e questa volta per davvero
**Cinque celle CONTIGUE** (0,500 · 0,625 · 0,750 · 0,875 · 1,000) passano tutte il
filtro *PF su e DD giù, IS e OOS*. **Non è un picco isolato: è un blocco.**
👉 Il **centro del blocco** è **0,750**; il centro del sotto-blocco che supera anche il
test del profitto (§ sotto) è **0,625**. **Propongo 0,625** e dichiaro che 0,750 è
equivalente entro il rumore.
🔴 **Non propongo 0,500** anche se è la cella col PF OOS più alto (1,40233): **quella è
il picco**, ed è esattamente la cella che `report/I_QUARANTOTTO_2026-09-18.md` r.181 ha
già segnalato scegliendo *"la cella migliore"*. Il picco è rumore.

### 🛑 IL CONTRO-ESEMPIO — costruito in tre modi, superato in due e mezzo
1. **Effetto denominatore** (*il DD% scende perché l'equity sale*): **respinto**, il DD
   in **valuta** scende in tutte e cinque le celle, in tutte e due le finestre.
2. 🔴 **Effetto TAGLIA — ed è quello serio, perché è MECCANICO**: un buffer più largo
   **allarga lo stop**; a rischio fisso l'1%, uno stop più largo = **lotto più piccolo**
   = profitto e drawdown che **scalano giù insieme**, senza che il motore sia migliorato
   di una virgola. Il test che separa le due cose è: *il profitto scende quanto il DD?*
   - a **0,500**: profitto IS +29% e OOS **+30%**, DDval −19% / −2% → 🟢 **NON è scala:
     il profitto SALE mentre il DD scende.**
   - a **0,625 / 0,750**: profitto IS +44% / +14%, OOS **−4% / −1%** → 🟡 misto.
   - a **0,875 / 1,000**: profitto OOS **−29% / −21%** contro DDval −20% / −25% →
     🔴 **compatibile con puro ridimensionamento del lotto.**
   👉 **Conclusione onesta: la metà alta dell'altopiano (0,875-1,000) potrebbe essere
   solo una taglia più piccola. La metà bassa (0,500-0,750) no.** È per questo che
   propongo 0,625 e non 1,000, nonostante 1,000 abbia il DD più bello della tabella.
3. **Due passate dello stesso CSV non sono due misure**: 🔴 **vero qui.** `r126a` è
   **UNA corsa sola**. Le due finestre IS/OOS sono due, ma la base dati è una e il
   confronto delle 9 celle è interno a quella corsa. **Nessuna seconda corsa la conferma.**

### 🔴 I DUE BUCHI, dichiarati
- **MERITO SOSPESO**: n = 63-72 (IS) e 115-131 (OOS), **sotto il pavimento dei 150**
  (Emendamento A, 16/08). Il **rischio** si legge lo stesso (Emendamento B) e il rischio
  migliora. Il **merito** no.
- 🔴 **BINARIO DIVERSO DA QUELLO CHE VOLA.** `r126a` è ancorato a `400a462` (08/08) e
  `report/CORRI_OGGI_2026-09-13.md` r.36 lo marca **❌** rispetto a `b45dd00`; il
  binario che si compila per FTMO è **`872dba82`**
  (`report/COMPILAZIONE_771531_770511_2026-09-19.md`). Fra i commit intermedi c'è
  **`3af47ed` (sizing)**, che tocca proprio il lotto — cioè **proprio la grandezza da cui
  dipende il contro-esempio n.2**.

### 💰 Costo
- **Se si accettasse così**: zero macchina (una riga nel `.set`). 🔴 **Non lo raccomando**:
  il binario non è lo stesso.
- **Via corta al numero**: **1 file prova, 1 asse, 4 celle** (`0` · `0,500` · `0,625` ·
  `0,750`) **× 2 finestre = 8 passate** su tick reali, sul binario di oggi.
  Attesa da dichiarare: la riga `0` deve riprodurre PF 1,48166/1,24312 — **se non
  riproduce, il verdetto non è "il buffer non serve", è "il binario è cambiato"**.

---

## 🟠 § 2C — CANDIDATO C · `771531` `InpTP_RR` 2,0 → 2,5

| corsa | modello | PF vola (2,0) | PF proposto (2,5) | DD% | DDval | n |
|---|---|--:|--:|---|--:|--:|
| `risultati_archivio/EMA200/H1_OHLC/scan_ABTG_EMA200_H1_U30USD.csv` r.dati 7 (Pass 159) → r.dati 24 (Pass 279) | OHLC (Modello 1) | 1,36117 | **1,46179** | 6,5810 → **6,1136** | 762 → **724** | 547 → 550 |
| `risultati_prove/risultati_valid_ABTG_EMA200_H1_realtick/valid_ABTG_EMA200_H1_realtick_U30USD.csv` r.dati 67 (Pass 159) → r.dati 110 (Pass 279) | **TICK REALI (Modello 4)** | 1,39181 | **1,42783** | 7,4298 → **7,3132** | 899 → **896** | 658 → 669 |

🟢 **Il pregio**: è **l'unico candidato del dossier con n sopra 150 in tutte e due le
letture** (547-669 deal) e **l'unico confermato a TICK REALI**. Il merito è leggibile.

### 🛑 IL CONTRO-ESEMPIO — **parzialmente FALLITO, e lo scrivo grosso**
🔴 **Nella corsa a tick reali il miglioramento di DD è quasi tutto effetto denominatore.**
Il profitto sale da 2.502,70 a 2.743,22 (**+9,6%**) mentre il **DD in valuta scende da
899 a 896: −0,3%**. Tradotto: **la discesa in euro è la stessa**, il `Equity DD %` scende
perché il denominatore è cresciuto.
👉 **Quindi la riga onesta è: «`TP_RR=2,5` migliora il PF (due modelli, n>150). Sul DD
NON migliora: resta uguale.»** Nella corsa OHLC il DD in valuta scende davvero (−5%), ma
è la corsa meno affidabile delle due.

### 📐 Altopiano o picco? **NON VALUTABILE, ed è il buco che costa meno di tutti.**
Alla configurazione che vola (`Order1Atr=0,20`, `Order2Atr=0,3`, entrambi i lati) le
griglie archiviate contengono **solo** `TP_RR ∈ {2,0 · 2,5}`. I valori `1,5` e `3,0`
esistono nel file **ma solo in combinazione con altre manopole cambiate**.
👉 Non posso dire se `2,5` è il centro di un altopiano o un picco fra `2,0` e `3,0`.

### ⚠️ Altre due cose da dichiarare
- **Non c'è divisione IS/OOS.** Tutte e due le corse sono a finestra unica
  `2024.01.01 → 2026.06.30` (`backtest_pipeline/scan_market.ps1` r.72-73 · `valida_realtick.ps1`
  r.183-184). Il requisito *«sia IS sia OOS»* **non è soddisfatto**: quello che ho sono
  **due MODELLI** sulla stessa finestra, non due finestre.
- 🟢 **E una buona notizia che vale la pena dire**: nello stesso pacchetto `r136*`, le
  manopole d'uscita `InpTP1Pct` (`r136c`), `InpTP1_ATRmult` (`r136b`) e `InpUseTrailing`
  (`r136d`) hanno **la cella migliore esattamente sul valore che vola già**
  (50 · 0,00 · 1). 👉 **Su tre uscite su quattro, «il default va bene» — ed è un
  risultato, non un fallimento.**

### 💰 Costo
**1 file prova, 1 asse, 3 celle** (`2,0` · `2,5` · `3,0`) **× 2 finestre = 6 passate**,
a tick reali, sulla finestra `2024.09.26` dei round `r136*` (così è confrontabile con
tutto il resto del pacchetto EMA200). Chiude l'altopiano **e** la divisione IS/OOS in
un colpo solo.

---

## 🔴 § 2D/2E — I DUE DECLASSATI di `771531`, e perché

### D · `InpSLatr` 1,0 → 1,4 — **è un CAMBIO DI RISCHIO, non una cella migliore**
Fonte: `backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r136a.csv`, righe dati 2 (vola) e 6 (candidata).

| `InpSLatr` | PF IS | PF OOS | DD% IS | DD% OOS | profitto IS | profitto OOS |
|--:|--:|--:|--:|--:|--:|--:|
| 0,8 | 1,18890 | **1,61199** | 5,1313 | 8,1890 | 4.819 | 31.817 |
| **1,0 (VOLA)** | 1,20110 | 1,52365 | 5,7325 | 7,8323 | 4.585 | 23.321 |
| 1,2 | **1,25497** | 1,46170 ❌ | 4,7266 | 5,9670 | 5.205 | 18.534 |
| **1,4** | 1,21824 | **1,59482** | **4,2725** | **5,7684** | 4.019 ↓ | 19.607 ↓ |
| 1,6 | 1,07195 ❌ | 1,45763 ❌ | 4,7553 | 6,2452 | 1.302 | 14.421 |

🔴 **`1,4` è un PICCO, non un centro**: i suoi due vicini `1,2` e `1,6` **falliscono
tutti e due sul PF OOS** (1,46170 e 1,45763 contro 1,52365 della cella viva). La regola
di casa dice picco = rumore → **declassato**.
🟠 **E il contro-esempio della taglia morde forte qui**: il profitto **scende** in tutte
e due le finestre (−12% IS, −16% OOS) mentre il DD scende di più (−25% / −29%). Uno stop
più largo a rischio fisso = lotto più piccolo. 👉 **È una riduzione del rischio, non un
guadagno di merito** — e per regola del compito, **quello è un altro tavolo e una firma
di Claudio.**
🟢 **Sul DD invece un altopiano c'è** (1,2-1,4-1,6 stanno tutti sotto il DD della cella
viva, in tutte e due le finestre): se un giorno servisse **comprare DD pagando in
profitto**, questa è la manopola, e il numero c'è già.

### E · `InpOrder1Atr` 0,20 → 0,10 — **una corsa sola, OHLC, e non replicata**
Fonte: `backtest_pipeline/risultati_prove/risultati_scan_ABTG_EMA200_H1/scan_ABTG_EMA200_H1_U30USD.csv`,
riga dati 90 (Pass 159, vola) → riga dati 39 (Pass 151, `0,10`) e riga dati 65 (Pass 147, `0,05`).

| `InpOrder1Atr` | PF | DD% | DDval | n |
|--:|--:|--:|--:|--:|
| 0,05 | 1,42559 | 5,8779 | 710 | 578 |
| **0,10** | **1,45006** | **5,8060** | **703** | 603 |
| **0,20 (VOLA)** | 1,40550 | 6,2894 | 755 | 648 |

📐 `0,05` e `0,10` passano tutte e due → **due celle contigue = altopiano minimo** ✅, e
il DD in valuta scende davvero (755 → 703) ✅.
🔴 **Ma esiste in UNA corsa sola, OHLC (Modello 1), senza divisione IS/OOS.** E nella
corsa **a tick reali** dello stesso identico Pass-set, la cella `0,10` alla configurazione
che vola **non c'è**: la griglia è sparsa e lì è presente solo `0,20`.
👉 **Verdetto: NON MISURATO ABBASTANZA**, non "non funziona". **Via corta**: entra
gratis nel file prova del candidato C (3 celle `TP_RR` × 3 celle `Order1Atr` sarebbero
9×2=18 passate; o due file prova da 6 passate l'uno, che è meglio — una variabile per file).

---

## 🪦 § 3 — I TRE CANDIDATI CHE IL CONTRO-ESEMPIO HA UCCISO
*(li scrivo perché un candidato ucciso ben documentato vale quanto uno vivo: nessuno lo rifarà)*

| sedia | manopola | perché sembrava buono | 🔪 perché è morto |
|---|---|---|---|
| `770101` | `InpBreakevenAtTP1` **1 → 0** | PF 1,29574 → **1,30903** e DD% 6,8866 → **6,8765**: passa il filtro alla lettera | 🔴 **EFFETTO DENOMINATORE PURO.** Il DD in **valuta** PEGGIORA: **873 → 880**. Il DD% scende solo perché il profitto sale da 2.207,74 a 2.329,60. Fonte: `gestione_20260909/gestione_ABTG_DAX_Apertura_EU_D30EUR_gestione.csv` righe 55 → 51 |
| `770260` | `InpEntryMode` **2 → 1** | PF IS 1,1450 → **2,0827**, PF OOS 1,1094 → **1,9369**, DD giù in tutte e due | 🔴 **n = 23 (IS) e 19 (OOS).** Diciannove operazioni. Merito sospeso per aritmetica. E `EntryMode` **è l'identità del motore** (2 = retest): non è una manopola, è un'altra sedia. Fonte: `risultati_archivio/Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` righe 12 → 1 |
| `770101` | `InpUseVolumeFilter` **0 → 1** | PF IS 1,1311 → **1,5031**, PF OOS 1,4152 → **1,5384**, DD giù forte | 🔴 **n crolla a 68 (IS) / 96 (OOS)**: sotto 150 tutte e due. Il filtro **taglia il 61% delle operazioni** — è selezione, non gestione. Fonte: `risultati_prove/ABTG_DAX_Apertura_EU/ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r26.csv` righe 3 → 5 (IS) e 2 → 4 (OOS) |

---

## 🚫 § 4 — LE DUE SEDIE DOVE LA RISPOSTA È **NO**, e il NO è solido

### `770202` ABTG_Dow_Apertura_US (US30.cash M5) — **nessun candidato**
Non è un vuoto d'archivio: la cella che vola è presente **identica in 12+ file**
(`csv_r54/`, `ABTG_Dow_Apertura_US/*_{r6,ptc}`, `aperture_r35`, `aperture_r46`,
`aperture_r47`). Ho esaminato **tutti** i vicini a una manopola. **Zero** passano.

🔎 **E il controllo più istruttivo del dossier**: `InpTP1_ClosePct 50 → 0` — **la cella
che vince sul DAX** — **sul Dow PERDE**:
`risultati_prove/aperture_r46/ABTG_Dow_Apertura_US_U30USD_OOS_r46b.csv`, riga 7 (viva)
PF **1,27013** DD 4,3941% contro riga 5 (candidata) PF **1,25809** DD 5,4280%.
👉 **La stessa manopola, la stessa famiglia, il segno opposto.** Chiunque fosse tentato
di "estendere per simmetria" ha qui il numero che glielo impedisce.

⚠️ **Il vero limite del NO su questa sedia è un altro, e va detto**: l'IS del Dow ha
**n = 74**. Sotto 150. Il filtro *"meglio in IS E in OOS"* su una finestra da 74
operazioni **boccia anche per rumore**: p.es. `InpRangeMinutes 35 → 45` fa PF OOS
1,2751 → **1,6802** con DD 4,1794 → **2,4955**, e viene scartato solo perché l'IS fa
0,8472. 🔴 **Quindi il verdetto corretto è "nessun candidato che passi i cancelli di
casa", non "non c'è niente".**

### `770411` ABTG_MaxMinNotte_DAX_Short (GER40.cash M15) — **nessun candidato, e non è misurabile**
Cella viva presente in 11 file. Vicini a una manopola: `InpBufferPoints` (500/750/1250/1500),
`InpAtrSLmult` (1,5/2,0), `InpUseCorrelation`, `InpMinBoxPts`. **Zero passano.**
🔴 **Ma il numero che conta è un altro: n = 16-41 operazioni per finestra.** Su questa
sedia **il merito non è misurabile per niente**, né a favore né contro. Non è "abbiamo
guardato e non c'è": è **"non si vede"**.

---

## 🔩 § 5 — TRE MANOPOLE INERTI TROVATE STRADA FACENDO
*(mandato del 09/09: «se N passate danno M esiti con M ≪ N, quella manopola non ha morso —
è una casella libera, non una casella provata»)*

| sedia | manopola | dove | cosa ho misurato |
|---|---|---|---|
| `770101` | `InpVolMult` | `risultati_prove/ABTG_DAX_Apertura_EU/..._r26.csv` righe 1·2·3 | **3 passate, 1 esito** (PF 1,41521 · DD 6,7111 · n 270 identici) quando `InpUseVolumeFilter=0`. Ovvio a posteriori, **ma a CSV sembravano tre misure** |
| `770101` | `InpBEatR` | `risultati_prove/dal_vps/ABTG_DAX_Apertura_EU/..._IS_q770be.csv` righe 1·2·4 | **valori 0,0 · 1,0 · 1,5 danno esito IDENTICO in IS** (PF 1,18323). Solo `0,5` morde (PF 1,15177, peggio). 🟢 In OOS `0,0` è il migliore → **il valore che vola è già quello giusto** |
| `770411` | `InpMinBoxPts` | `risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv` righe 30 e 35 | `0` e `1500` → **PF 2,0533 · DD 3,0687 · n 41 identici**. Il filtro **non ha mai tagliato una notte** su quella finestra |

🟢 **E una verifica che è andata BENE**: gli assi tecnici di `770511`
(`r120b00/01/10/11`, `r120e00/11`) fanno **2 passate e 1 esito** — che lì è **esattamente
quello che deve succedere**: sono i gemelli sul magic, e il **cancello G1 di determinismo
è PASSATO**.

---

## 📋 § 6 — I BUCHI DICHIARATI DI QUESTO DOSSIER
1. 🔴 **Nessun numero qui è al rischio 2,00% dei preset FTMO.** Tutto l'archivio gira a
   `InpRiskPercent=1`. I confronti fra celle sono validi, **i DD assoluti no**.
2. 🔴 **Nessun numero qui è sul simbolo FTMO.** L'archivio è `D30EUR`/`U30USD`/`NASUSD`
   (BCM), le sedie volano su `GER40.cash`/`US30.cash`/`US100.cash`. Il trasferimento è
   assunto, **non misurato in questo dossier**.
3. 🔴 **Nessun numero qui è sul binario che vola.** Per `770511` la deriva è **nominata
   e documentata** (§2B). Per le altre cinque **non l'ho verificata**: `[NON MISURATO]`.
4. 🟠 **PROVA DI REGIME: assente ovunque.** 21 mesi (o 30 per EMA200) = **un regime solo**.
   Regola C dell'Emendamento della Finestra **non soddisfatta da nessuno** dei candidati.
5. 🟠 **Il DD in valuta è DERIVATO** (`Profit / Recovery Factor`), non letto dai per-trade.
   I per-trade esistono solo per la cella base di `771531`
   (`risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_76340*.csv`, 517 righe),
   **non per le celle candidate**. Per `770101` la verifica per-trade c'è già ed è
   altrui (`R137c` r.16-22: 193 `position_id` in tutte e due le celle).
6. 🟠 **La copertura d'archivio è asimmetrica**: `770101` ha 95 file sul simbolo,
   `770202` 27, `770411` **24**, `770260` 74 **ma la cella RETEST che vola compare in UN
   SOLO pair di corse** (`Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}`). 👉 Su `770260`
   il "nessun candidato" è **debole**: è quasi assenza di ricerca, non presenza di prova.

---

## 🎬 § 7 — COSA PROPONGO, in ordine di rapporto valore/costo

| pr. | cosa | costo | chi firma |
|--:|---|---|---|
| 1 | **`770101 InpTP1_ClosePct 50 → 0`** nel `.set` FTMO | **0 passate** | ✍️ **Claudio** |
| 2 | **File prova `InpTP_RR` su `771531`**, 3 celle (2,0·2,5·3,0) × 2 finestre, tick reali, finestra `r136*` | **6 passate** | riapre l'altopiano **e** l'IS/OOS del candidato C |
| 3 | **File prova `InpSLBufferAtr` su `770511`**, 4 celle (0·0,500·0,625·0,750) × 2 finestre, tick reali, **sul binario `872dba82`** | **8 passate** | la cella `0` è il cancello di riproduzione: se non torna 1,48166/1,24312 **il verdetto è sul binario, non sul buffer** |
| 4 | **File prova `InpOrder1Atr` su `771531`**, 3 celle (0,05·0,10·0,20) × 2 finestre, tick reali | **6 passate** | replica su tick l'unica misura OHLC |
| — | 🚫 **Niente su `770202` e `770411`** | 0 | una griglia più fitta lì troverebbe solo rumore |

**Totale se si fa tutto: 20 passate.** Due serate, non un weekend.
🚫 **E nessuno dei file prova è stato scritto**: scriverli è il passo dopo, e devono
passare `controlla_prova.py` **e** l'agente `controllo-preventivo` prima di uscire.

---

> 🏁 **La riga da portare a Claudio**: *«La cella del DAX è confermata e costa zero.
> Il SuperWave ha una manopola che non è nemmeno nel preset e che in archivio ha un
> altopiano di cinque celle contigue migliori — ma è stata misurata su un altro binario,
> e otto passate la chiudono. L'EMA200 guadagna PF con TP_RR 2,5 su tick reali con 669
> operazioni, e sul DD NON guadagna niente: quello era denominatore. Sul Dow e sul
> MaxMin l'archivio dice no, e il no sul Dow è interessante perché è la STESSA manopola
> che sul DAX dice sì.»*
