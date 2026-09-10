# 🩻 CENSIMENTO DEL RISCHIO VERO — SEDIA PER SEDIA — 10/09/2026

**Perché esiste:** oggi la sedia `ABTG_PostNews` ECB EURJPY (771201) ha fatto la
sua **prima operazione in assoluto** e ha perso **80,90 EUR su 5.427,56 =
1,4905%**, contro lo **0,65% promesso** nel contratto scritto la mattina stessa.
**2,3 volte.** Causa: `mql5/Experts/ABTG_PostNews.mq5` riga **113**,
`input double InpRiskPercent = 3.0;` — il **default compilato**.
Referto dell'esito: `report/POSTNEWS_ECB_ESITO_2026-09-10.md`.

**Cosa misura questo referto:** per ogni sedia viva, **quattro numeri** invece
di uno — il valore che **gira**, il **default compilato** dell'EA, il **rischio
VERO per gamba stoppata**, e il **rischio vero per EVENTO** (gambe che si
sommano). Più il **rapporto sul metro di casa (0,65%)** e il **fattore di
salto se qualcuno preme `Resetta`**.

🛑 **È SOLA LETTURA.** Nessun `.mq5`, nessun `.set`, nessun parametro, nessun
terminale è stato toccato. **Taglie e parametri di rischio restano firma di
Claudio.** Questo file è l'unico prodotto.

---

# 🚦 LE TRE SEDIE DA SISTEMARE PER PRIME

## 🥇 1. `ABTG_PostNews` — **771201 EURJPY e 771202 EURUSD, che girano al 3,0% ADESSO**

Non è un rischio potenziale: è il valore che sta nel `.chr` **stamattina alle
03:30** (`CODA_01_sedie_attaccate_20260910_033002.log`), ed è quello che ha
pagato 80,90 EUR oggi pomeriggio.

| | 771201 EURJPY | 771202 EURUSD | 771203 USDJPY |
|---|---|---|---|
| gira (`.chr` 10/09 03:30) | 🔥 **3.00** | 🔥 **3.00** | ✅ 1.30 |
| preset nel repo | 1.30 | 1.30 | 1.30 |
| **default compilato** | 🔥 **3.0** | 🔥 **3.0** | 🔥 **3.0** |
| rischio VERO **per gamba** | **1,50%** | **1,50%** | 0,65% |
| rischio VERO **per evento** | **1,50%** (OCO on) | **1,50%** (OCO on) | **1,30%** (OCO off) |
| **rapporto su 0,65%** | **2,31×** | **2,31×** | 2,00× |
| DD promesso agli atti | 🔴 **NESSUNO** | 🔴 **NESSUNO** | 🔴 **NESSUNO** |

📌 **Perché 1,50% e non 3,00%:** il lotto è dimensionato su
`InpRiskRefSLpips = 50` (riga 114, usato a riga **325**:
`LotByRisk(InpRiskRefSLpips*pip)`) mentre lo stop piazzato è
`InpSLpips = 25` (riga 98). **Il 3,0 descrive l'evento a doppio stop, non
l'operazione.** ✅ E non è una lettura: è **misurato al centesimo** oggi
(predetto 1,49% → uscito 1,4905%).

🔴 **Le tre sedie girano senza NESSUN DD promesso agli atti**
(`CENSIMENTO_CONTRATTI.md` r.225-227): sono le **uniche 3 sedie della flotta**
in questa condizione.

---

## 🥈 2. `ABTG_MaxMinNotte` — **770402 XAUUSD, viva sull'oro, default 2.0**

| | |
|---|---|
| gira | **0,50** (riduzione firmata 23/08, REVISIONE R100) |
| preset nel repo | **1,0** — 🔴 **SCADUTO**, e ricaricarlo RADDOPPIA |
| **default compilato** | 🔥 **2.0** (`ABTG_MaxMinNotte.mq5` r.171) |
| gambe | **2 pendenti opposti** (BuyStop r.354 / SellStop r.366), OCO **software** a tick (r.239 → r.473) |
| rischio vero **oggi** | 0,50%/gamba · **1,00%** se il gap riempie tutte e due |
| rischio vero **dopo un `Resetta`** | 2,00%/gamba · 🔥 **4,00% per evento** |
| **salto su `Resetta`** | 🔥 **4,00×** |
| DD promesso | **10,0% a 0,5%** (19,72% a 1% su 22 anni, R100) |

🔴 **Da sola, dopo un `Resetta`, questa sedia vale 4,00% = più del cap C1 di
3,25%.** E il DD misurato a 1% è **19,72%**: a 2% i numeri raddoppiano.
📎 È l'unica delle 4 sedie con default 2.0 che sia **viva in forward**.

---

## 🥉 3. `ABTG_Nasdaq_Apertura_US` (**GatedShort**) — **770250 NASUSD: il salto più grande della flotta, 11,4×**

| | |
|---|---|
| gira | **0,35%** |
| preset | **0,35%** ✅ (`mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`) |
| **default compilato** | 🔥 **`#define ABTG_DEF_RISK 2.0`** (r.47) |
| **secondo default che salta** | `InpAllowLong` torna a **`true`** (r.219): oggi il preset ha `InpAllowLong=false`, quindi **una gamba sola** |
| rischio vero **oggi** | **0,35%** (una gamba) |
| rischio vero **dopo un `Resetta`** | 2,00%/gamba × 2 gambe = 🔥 **4,00%** |
| **salto su `Resetta`** | 🔥🔥 **11,43×** — il record del parco |
| DD promesso | ~2,4% a 0,35% (4,54% a 0,65%) |

📌 **Perché è la più insidiosa:** qui i default che saltano sono **DUE** e si
moltiplicano — la taglia (0,35 → 2,0 = **5,71×**) e la direzione (1 gamba → 2
gambe = **2×**). Nessuna delle due, da sola, sarebbe drammatica. **Insieme
fanno 11,4×**, e nessun file `.set` protegge da un `Resetta`.

---

## 🏛️ E IL CONTO REALE **10105439**, che ha priorità assoluta

✅ **Oggi è pulito, ed è l'unico terminale che lo è.** Due sedie, entrambe a
**0,65% vero** (preset `InpAllowShort=false` → una gamba sola), somma **1,30%**
contro un cap di 3,25%. Il Guardian **c'è e gira** (log 09/09 23:55:02,
`eq=7507.65 dayLoss=-0.10% totDD=-0.10%`).

🟠 **Ma ha due esposizioni da scrivere, tutte e due da `Resetta`:**
1. il default compilato è **1.0** e `InpAllowShort` torna **`true`** →
   post-`Resetta` **2,00% per sedia**, cioè **3,08×** quello che gira oggi, e
   **4,00% sul conto** = sopra il cap C1;
2. 🔴 **`mql5/Experts/standalone/ABTG_DAX_Apertura_EU.mq5` r.33 porta ancora
   `#define ABTG_DEF_RISK 2.0`**, mentre la copia buona
   (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` r.90) è a **1.0** dal fix C4 del
   02/09. **Il fix ha toccato una copia sola.** Chi compilasse quella
   metterebbe il conto reale a **4,00% per sedia** dopo un `Resetta`.

---

# 📊 TABELLA MADRE — ORDINATA DAL PEGGIORE (rapporto su 0,65%)

**Fonte del "gira":** `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log`
(lettura 10/09/2026 03:30:04, ora locale).
**Fonte del "default":** riga di `input` / `#define` nel sorgente, citata.

**Legenda colonne**
- `gira` = valore dell'input nel `.chr` del profilo attivo.
- `gamba` = **rischio VERO di UNA gamba stoppata** (= `gira` × correttore di
  sizing; il correttore è 0,5 solo dove il lotto è dimensionato su una
  distanza diversa dallo stop piazzato).
- `n` = **gambe che si sommano davvero nella configurazione di OGGI**.
- `EVENTO` = `gamba × n` = quanto perde la sedia nel suo caso peggiore.
- `su 0,65` = `EVENTO / 0,65%` ← **la colonna d'ordine**.
- `DEF` = default compilato · `evDEF` = evento dopo un `Resetta` ·
  `×Res` = `evDEF / EVENTO`.

| su 0,65 | EA | sym | magic | conto | gira | gamba | n | **EVENTO** | DEF | evDEF | ×Res | meccanismo |
|---:|---|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|
| **3,08** | SupertrendReversal_Ott | XAUUSD | 970901 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 🔥2.0 | 4,00 | 2,00× | bug tranche `NormVol` (r.260-262) |
| **3,08** | SupertrendReversal | 225JPY | 770924 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | bug tranche (r.274-276) |
| **3,08** | SuperWave_DOW_H1_Ott | U30USD | 770511 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | bug tranche (r.253-255) |
| **3,08** | SuperWave | U30USD | 770531 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | bug tranche (r.253-255) |
| **3,08** | SupRev_NAS_H1_Ott | NASUSD | 970913 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | bug tranche (r.261-263) |
| **3,08** | SupRev_DAX_H4_Ott | D30EUR | 970912 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | bug tranche (r.261-263) |
| **3,08** | ORB_Ottimizzato | U30USD | 770611 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | 2 pendenti opposti, OCO software |
| **3,08** | MaxMinNotte_DAX_Short_Ott | D30EUR | 770411 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | 2 pendenti opposti (r.253/265) |
| **3,08** | Dow_Apertura_US | U30USD | 770202 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | 2 pendenti opposti (r.906/930) |
| **3,08** | DAX_Apertura_EU | D30EUR | 770101 | piccolo | 1,00 | 1,00 | 2 | **2,00%** | 1.0 | 2,00 | 1,00× | 2 pendenti opposti (r.1069/1093) |
| **2,31** | 🔥 **PostNews** | EURUSD | 771202 | piccolo | **3,00** | **1,50** | 1 | **1,50%** | 🔥3.0 | 1,50 | 1,00× | size su 50 pip, stop 25 pip |
| **2,31** | 🔥 **PostNews** | EURJPY | 771201 | piccolo | **3,00** | **1,50** | 1 | **1,50%** | 🔥3.0 | 1,50 | 1,00× | **misurato oggi: 1,4905%** |
| **2,00** | PostNews | USDJPY | 771203 | piccolo | 1,30 | 0,65 | **2** | **1,30%** | 🔥3.0 | 1,50 | 1,15× | preset `InpUseOCO=false` → **le gambe si sommano** |
| **2,00** | MaxMinNotte_DAX_Short_Ott | D30EUR | 770411 | **100k** | 0,65 | 0,65 | 2 | **1,30%** | 1.0 | 2,00 | 1,54× | 2 pendenti opposti |
| **2,00** | Dow_Apertura_US | U30USD | 770202 | **100k** | 0,65 | 0,65 | 2 | **1,30%** | 1.0 | 2,00 | 1,54× | 2 pendenti opposti |
| **2,00** | DAX_Apertura_EU | D30EUR | 770101 | **100k** | 0,65 | 0,65 | 2 | **1,30%** | 1.0 | 2,00 | 1,54× | 2 pendenti opposti |
| 1,54 | PunteLarry | U30USD | 772341 | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | una posizione (r.408) |
| 1,54 | PunteLarry | GBPUSD | 772345 | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | una posizione |
| 1,54 | PunteLarry | GBPJPY | 772344 | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | una posizione |
| 1,54 | PunteLarry | EURCAD | 772346 | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | una posizione |
| 1,54 | PTE | U30USD | 771321 | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | `InpMaxPositions 1` |
| 1,54 | **MaxMinNotte** | XAUUSD | 770402 | piccolo | 0,50 | 0,50 | 2 | 1,00% | 🔥**2.0** | **4,00** | 🔥**4,00×** | 2 pendenti opposti |
| 1,54 | GapFill ×5 | GBP/EUR/AUD/U30/225 | 7722 3x | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | una posizione (r.366) |
| 1,54 | EMA200 | U30USD | 771531 | piccolo | 1,00 | 0,50 | 2 | 1,00% | 1.0 | 1,00 | 1,00× | 2 limit, rischio **diviso /2** ✅ |
| 1,54 | BreakingBand ×3 | GBP/EUR/AUD USD | 77216x | piccolo | 1,00 | 1,00 | 1 | 1,00% | 1.0 | 1,00 | 1,00× | `InpMaxPositions 1` |
| 1,00 | SupertrendReversal | 225JPY | 770901 | **100k** | 0,65 | 0,65 | 1 | 0,65% | 1.0 | 1,00 | 1,54× | ⚠️ bug tranche **NON morde a 100k** (vedi contro-esempio 2) |
| 1,00 | 🏛️ **ORB_Ottimizzato** | U30USD | 770611 | **REALE** | 0,65 | 0,65 | 1 | **0,65%** | 1.0 | 2,00 | **3,08×** | preset `AllowShort=false` → 1 gamba |
| 1,00 | 🏛️ **DAX_Apertura_EU** | D30EUR | 770101 | **REALE** | 0,65 | 0,65 | 1 | **0,65%** | 1.0 | 2,00 | **3,08×** | preset `AllowShort=false` → 1 gamba |
| 1,00 | CostToCost | EURJPY | 772361 | piccolo | 0,65 | 0,65 | 1 | 0,65% | 1.0 | 1,00 | 1,54× | una posizione |
| 0,92 | ORB_Ottimizzato | U30USD | 770611 | **100k** | 0,30 | 0,30 | 2 | 0,60% | 1.0 | 2,00 | **3,33×** | 2 pendenti opposti |
| 0,77 | PunteLarry | EURAUD | 772342 | piccolo | 0,50 | 0,50 | 1 | 0,50% | 1.0 | 1,00 | 2,00× | una posizione |
| 0,77 | PTE | GBPUSD | 771332 | piccolo | 0,50 | 0,50 | 1 | 0,50% | 1.0 | 1,00 | 2,00× | `InpMaxPositions 1` |
| 0,77 | PTE | GBPUSD | 771322 | piccolo | 0,50 | 0,50 | 1 | 0,50% | 1.0 | 1,00 | 2,00× | `InpMaxPositions 1` |
| 0,77 | EasyTrend | GBPUSD | 772422 | piccolo | 0,50 | 0,50 | 1 | 0,50% | 1.0 | 1,00 | 2,00× | una posizione |
| 0,54 | **Nasdaq_Apertura_US (GatedShort)** | NASUSD | 770250 | piccolo | 0,35 | 0,35 | 1 | 0,35% | 🔥**2.0** | **4,00** | 🔥🔥**11,43×** | preset `AllowLong=false`; il `Resetta` riapre il long **e** alza la taglia |
| 0,46 | PunteLarry | XAUUSD | 772343 | piccolo | 0,30 | 0,30 | 1 | 0,30% | 1.0 | 1,00 | 3,33× | una posizione |
| 0,46 | EasyTrend | CHFJPY | 772421 | piccolo | 0,30 | 0,30 | 1 | 0,30% | 1.0 | 1,00 | 3,33× | una posizione |
| 0,38 | EMA200_Ottimizzato | XAUUSD | 971501 | piccolo | 0,25 | 0,12 | 2 | 0,25% | 1.0 | 1,00 | 4,00× | 2 limit, rischio diviso /2 ✅ |
| 0,38 | CostToCost | GBPCAD | 772362 | piccolo | 0,25 | 0,25 | 1 | 0,25% | 1.0 | 1,00 | 4,00× | una posizione |
| — | 🧰 TradeExporter (×2) · SlippageLogger · Guardian (×2) | | | tutti | — | — | — | **non aprono** | — | — | — | strumenti / vigile |
| 🔴 | **GapContinuation** | 225JPY | 774101 | piccolo | 🔴 **[NON MISURATO]** | — | 2 | 🔴 **[NON MISURATO]** | 0.50+0.50 | 1,00 | — | vedi §buchi |

### Totali per terminale

| conto | equity misurata | sedie leggibili | somma **dichiarata** | somma **VERA** (caso peggiore) | scarto | somma **dopo un `Resetta` generale** |
|---|---:|---:|---:|---:|---:|---:|
| 🟡 piccolo **50503392** | 5.344,34 € (dopo il trade di oggi) | 38 | 35,90% | 🔥 **43,40%** | **1,21×** | 🔥 **57,50%** |
| 🟠 dry-run 100k **50504263** | 103.025,49 € | 5 | 2,90% ✅ | 🔥 **5,15%** | **1,78×** | 🔥 **9,00%** |
| 🏛️ **REALE 10105439** | 7.507,65 € | 2 | 1,30% ✅ | ✅ **1,30%** | **1,00×** | 🟠 **4,00%** |

📌 La somma dichiarata del piccolo (**35,90%**) coincide **al centesimo** con
quella del censimento dell'08/09: la lista delle sedie è la stessa, quindi lo
scarto che si legge qui è **solo** l'effetto del rischio vero, non un elenco
diverso.

🔴 **I totali del piccolo sono un LIMITE INFERIORE**: manca `GapContinuation`.

---

# ⚖️ IL CONTO DEL CAP C1 — RIFATTO CON I RISCHI VERI

Il cap **C1 = 3,25%** è stato firmato il 18/08 (`report/FIRME_2026-08-18.md`,
FIRMA 3) come **«5 stop pieni vivi da 0,65%»**. È implementato **solo** dentro
`ABTG_Guardian.mq5` (`InpMaxOpenRiskPct`, r.153).

## ✅ Prima la buona notizia, perché è vera: **il Guardian conta BENE**

`OpenRiskPct()` (r.385-412) **non** somma le percentuali dichiarate: gira su
tutte le posizioni aperte e chiama `LossIfStopHit()` (r.352), che usa
**`OrderCalcProfit(ingresso → SL)`** con il **volume vero**. 👉 **Conta euro
veri, non etichette.** Il difetto PostNews (etichetta 3,0 = 1,50% reale) **non
inganna il Guardian**: lui vede 1,50%.

## 🔴 Ma ha tre limiti che cambiano la risposta

### Limite 1 — **I PENDENTI ARMATI CONTANO ZERO**
Il ciclo è su `PositionsTotal()`: **gli ordini pendenti non sono nel conto.**
Una mattina con 5 sedie a due pendenti armati (**6,50% di rischio già in
macchina**) viene letta dal Guardian come **0,00%**. Il cap **non previene: reagisce
dopo il riempimento.** Ed è il caso normale della nostra flotta: 10 delle 40
sedie del piccolo e 4 delle 5 del 100k armano due pendenti opposti.

### Limite 2 — **Il cap è acceso su UN terminale su tre**
Il Guardian gira sul **100k 50504263** (AUDNZD H1, `eq=103025.49`) e sul
**REALE 10105439** (EURGBP H1, `eq=7507.65`) — log del 09/09 alle 23:55.
🔴 **Sul piccolo 50503392, che somma 43,40% di rischio vero, non c'è nessun
Guardian**: nel profilo attivo `ORO` (40 sedie) non compare.

### Limite 3 — **Il tetto per cluster è firmato ma SPENTO**
`InpMaxClusterRiskPct` esiste (r.165) ma il **default è 0 = spento**. Il tetto
del 3,0% per cluster firmato il 07/09 **non è applicato da nessuna riga**.

## 📐 LA RISPOSTA ALLA DOMANDA: **quanti SL vivi per sfondare?**

| rischio VERO per SL | cap C1 **3,25%** | emergenza Guardian **4,9%** | **MURO GIORNALIERO 5%** | DD totale **10%** |
|---|---:|---:|---:|---:|
| **0,65%** — il metro di casa, una gamba | **5° SL** ✅ (com'è scritto nella firma) | 8° | **8°** | 16° |
| **1,30%** — 0,65% × 2 gambe riempite | **3° SL** | 4° | **4°** | 8° |
| **1,50%** — PostNews al default compilato | **3° SL** | 4° | **4°** | 7° |
| **2,00%** — default 1.0 × 2 gambe | **2° SL** | 3° | **3°** | 5° |
| **4,00%** — default 2.0 × 2 gambe | **1° SL** 🔥 | 2° | **2°** | 3° |

### 🔴 **La risposta secca: la firma del 18/08 dice «5 SL». Con la flotta com'è davvero, sono DUE o TRE.**

| conto | oggi, coi valori che girano | dopo un `Resetta` generale |
|---|---|---|
| piccolo **50503392** | cap C1 sfondato al **2° SL** (4,00%) · muro 5% al **3°** (6,00%) | cap C1 al **1° SL** · muro 5% al **2°** |
| 100k **50504263** | cap C1 al **3° SL** (3,90%) · muro 5% al **5°** (5,15%) | cap C1 al **2°** · muro 5% al **3°** |
| 🏛️ **REALE 10105439** | ✅ **mai** (totale 1,30%) | 🟠 cap C1 al **2° SL** (4,00%) |

## 🏛️ E LA DOMANDA CHE DECIDE IL 1° OTTOBRE

> **Su una prop da 100k con muro giornaliero al 5%, quante sedie devono andare a
> stop lo stesso giorno perché la challenge salti?**

**Con la squadra del dry-run com'è oggi (le 5 sedie a 0,65/0,30):**
- se ogni sedia riempie **una** gamba: totale **2,90%** → ✅ **non basta la
  giornata intera** per bucare il muro;
- se ogni sedia riempie **tutte e due** le gambe: totale 🔥 **5,15%** →
  **basta che vadano male TUTTE E CINQUE nello stesso giorno** e il muro è
  passato (l'emergenza 4,9% scatta al 5° SL).
- **dopo un `Resetta` generale**: totale **9,00%**, muro sfondato al **3° SL**.

**Con una squadra ideale a 0,65% vero per sedia e una gamba sola:** servono
**8 SL** per il muro, **5** per il cap C1. 👉 **Il numero di sedie schierabili il
1° ottobre non dipende dal profit factor: dipende da quante gambe arma
ciascuna.** Una sedia a due gambe **occupa due posti**, non uno.

### 📌 La riga operativa che ne esce, in un numero
Con cap C1 = 3,25% e sedie a **una gamba da 0,65%**: **5 sedie simultanee**.
Con le stesse sedie a **due gambe armate** (com'è oggi il DAX, il Dow, il
MaxMin e l'ORB sul 100k): **2 sedie simultanee**. 🔴 **Il dry-run ne ha 4.**

---

# 🧪 I CONTRO-ESEMPI — costruiti PRIMA di consegnare

Regola del 10/09: *«prima di consegnare un numero, costruisci il contro-esempio
che lo farebbe sbagliare»*. Eccoli, con la lettura scelta e il perché.

## 🧪 1. «Il 2× dei due pendenti è teoria: con l'OCO ne parte uno solo»
**Lettura alternativa:** l'OCO cancella la gamba opposta, quindi `n = 1` sempre
e la colonna EVENTO va dimezzata su 14 righe.
**Perché non l'ho scelta come caso peggiore, e cosa dicono le misure:**
- ✅ **A favore dell'alternativa**, misurato **oggi**: su `771201` il
  `SELL STOP → filled` e il `BUY STOP → canceled` sono nello **stesso secondo**
  (14:03:40). L'OCO ha funzionato.
- 🔴 **Contro l'alternativa**, misurato il 03/09: sul gemello nativo `ABTG_ORB`
  ci sono **4 giornate su 16 con il secondo lato riempito**
  (`report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md`). **25% delle giornate.**
- 📐 E l'OCO è **software, a tick** (`HandleOCO()`), **non di broker**: fra il
  primo riempimento e la cancellazione c'è una finestra vera, e un gap la
  attraversa.
👉 **Scelta dichiarata:** la colonna `EVENTO` è il **caso peggiore**, non il
caso tipico. **Caso tipico = metà.** Chi vuole il numero tipico divida per 2 le
righe marcate «2 pendenti opposti» — **ma non le pianifichi così**, perché il
25% misurato non è un'eccezione.

## 🧪 2. «Il bug tranche `NormVol` vale 2× anche su un conto da 100k?»
**Questo contro-esempio ha CAMBIATO un numero, ed è il motivo per cui si fa.**
Il bug (`SuperWave.mq5:253-255` e gemelli) è:
```
lotMkt =NormVol(totLot*InpFirstFraction);   // NormVol -> 0 sotto il lotto minimo
lotPend=NormVol(totLot-lotMkt);             // = totLot intero
if(lotMkt<=0) lotMkt=SYMBOL_VOLUME_MIN;     // risorge DOPO
```
Fa danno **solo** quando `totLot × InpFirstFraction < volMin`, cioè
**`totLot < 3 × volMin`**: è un artefatto del **pavimento del lotto minimo**,
quindi un difetto **del conto piccolo**, non del motore.
👉 Su un **100k** al 0,65% il rischio è ~670 € e `totLot` è largamente sopra
`3 × volMin`: **il bug non morde.** Per questo la riga `SupertrendReversal
225JPY 770901` sul 100k è segnata **`n = 1`, 0,65%** e non 1,30%.
🔴 **Ma è un ragionamento, non una misura**: mi manca `SYMBOL_VOLUME_MIN` dei
simboli. Vedi §buchi, buco B1.

## 🧪 3. «Il PostNews rischia 3,0% per gamba, non 1,50%»
**Lettura alternativa:** l'input dice 3,0, quindi ogni stop costa il 3%.
**Il contro-esempio esiste ed è un fatto:** oggi la gamba stoppata è costata
**80,90 € = 1,4905%** su 5.427,56. Predetto la mattina: **1,49%**. ✅ **La
misura sceglie**, non la lettura del codice.

## 🧪 4. «Il conto reale rischia lo 0,65%?» — **dipende da quale 0,65%**
Sul REALE: **equity 7.507,65 €**, di cui **2.500 € di CREDITO** (bilancio
5.000 €, dal commento in `ABTG_Guardian.mq5` v1.12).
Ma **gli EA dimensionano su `ACCOUNT_BALANCE`** (es. `ABTG_PostNews.mq5:479`),
mentre **il Guardian e le prop misurano sull'EQUITY**. Quindi:
- «0,65% del bilancio» = 32,50 € = **0,433% dell'equity**;
- il Guardian conterà **0,43%**, non 0,65%.
👉 **Scelta dichiarata:** nelle tabelle ho usato la **percentuale nominale
dell'EA** (0,65%), perché è quella confrontabile col metro di casa. 📌 La
divergenza sul reale va **nel verso sicuro** (rischia meno del nominale), ma è
un **1,50× di scarto** che va saputo prima di leggere qualunque referto di quel
conto.
⚠️ **E due EA della flotta fanno il contrario di tutti gli altri**: dimensionano
su `ACCOUNT_EQUITY` — **`ABTG_GapContinuation.mq5:794`** (🔴 **è una sedia
VIVA**) e **`ABTG_CanaleLento.mq5:417`**. Su un conto con credito o con
flottante grosso, quei due rischiano **di più** degli altri a parità di input.

## 🧪 5. «Il default compilato del Dow è 2.0?»
**Il censimento dell'08/09 (`RISCHIO_DICHIARATO_VS_VERO`) dice
`ABTG_Dow_Apertura_US | ABTG_DEF_RISK 2.0`. 🔴 È SBAGLIATO, ed ecco la prova.**
Gli EA della famiglia Aperture hanno il motore incluso **dentro** il file, e i
default stanno in **due strati**:
- `ABTG_Dow_Apertura_US.mq5` **riga 67**: `#define ABTG_DEF_RISK 1.0` ← locale,
  **prima**;
- `ABTG_Dow_Apertura_US.mq5` **riga 139-141**: `#ifndef ABTG_DEF_RISK →
  #define 2.0` ← **è dentro un `#ifndef`**, quindi **non si applica**;
- `input double InpRiskPercent = ABTG_DEF_RISK;` (riga 281) legge **1.0**.
👉 **Il default compilato del Dow è 1.0.** La riga `:281` citata nel referto
dell'08/09 è la riga dell'`input`, non del default. **Correzione agli atti.**

---

# 🗂️ IL CENSIMENTO COMPLETO DEI DEFAULT COMPILATI

**Cercati TUTTI i nomi, non un pattern solo.** Elenco dei nomi di parametro di
rischio trovati nel repo (`mql5/Experts/*.mq5`, 111 file):
`InpRiskPercent` (85) · `InpRiskPct` (5) · `RiskPercent` (3) · `RiskPct` (3) ·
`Total_Risk_Percent` (2) · `Risk_Percent` (2) · `MaxTotalRisk` (2) ·
`InpBuyRiskPercent` · `InpSellRiskPercent` · `InpSmallSellRiskPercent` ·
`InpSellFullRiskFromGapPct` · `InpRiskPerTradePercent` · `InpAfternoonRiskMultiplier` ·
`InpRiskRefSLpips` · `InpRiskMode` · `InpMaxOpenRiskPct` · `InpMaxClusterRiskPct` ·
`InpMaxRiskIdxPts` · `MaxTotalRiskPct` · **`#define ABTG_DEF_RISK`** (famiglia Aperture).

## 🔥 I default sopra 1.0 — l'elenco COMPLETO, corretto

| default | EA | file:riga | vivo in forward? |
|---:|---|---|---|
| 🔥 **5.0** | `ORB_GOLD_FIBONACCI_EA` | `:65 InpRiskPct` | ❌ no (EA di terzi in repo) |
| 🔥 **3.0** | **`ABTG_PostNews`** | `:113` | 🔴 **SÌ — 3 sedie, 2 girano proprio a 3.0** |
| 🔥 **3.0** | `ABTG_PostNews` (copia) | `standalone/:61` | ⚠️ copia doppia |
| 🔥 **3.0** | `ORB_DAX_BASE_EA` · `ORB_DAX_PM_EA` | `:54` · `:55 InpRiskPct` | ❌ no |
| 🟠 **2.0** | **`ABTG_MaxMinNotte`** | `:171` | 🔴 **SÌ — 770402 XAUUSD** |
| 🟠 **2.0** | **`ABTG_Nasdaq_Apertura_US`** | `:47 ABTG_DEF_RISK` | 🔴 **SÌ — 770250 GatedShort** |
| 🟠 **2.0** | **`ABTG_SupertrendReversal_Ottimizzato`** | `:86` | 🔴 **SÌ — 970901 XAUUSD** |
| 🟠 **2.0** | `ABTG_SupertrendReversal_Multi_Ottimizzato` | `:90` | ❌ non nel profilo attivo |
| 🟠 **2.0** | `ABTG_Apertura_3Ingressi` | `:86` | ❌ |
| 🟠 **2.0** | `ABTG_Apertura_Marco` (EA **ritirato**) | `:62` | ❌ |
| 🟠 **2.0** | `ABTG_DAX_Live5m` · `ABTG_Nasdaq_Live5m` | `:108` · `:111` (**nessun define locale**: vince l'`#ifndef` a 2.0) | ❌ |
| 🟠 **2.0** | `ABTG_PointBreak` | `standalone/:66` | ❌ |
| 🟠 **2.0** | `EasyTrend_EURUSD` | `:87 RiskPercent` | ❌ |
| 🔴 **2.0** | **`standalone/ABTG_DAX_Apertura_EU.mq5`** | `:33` | ⚠️ **copia non allineata** del fix C4 — l'EA del **CONTO REALE** |
| 🔴 **2.0** | `standalone/ABTG_Nasdaq_Apertura_US` · `standalone/ABTG_DAX_Live5m` · `standalone/ABTG_Nasdaq_Live5m` · `standalone/ABTG_MaxMinNotte` | `:36` · `:95` · `:98` · `:87` | ⚠️ copie doppie |
| 🟠 **1.5** | `ORB_GOLD_FIBONACCI_EA_v3.21` | `:63` | ❌ |
| 🟡 **1.0** | ~70 EA, fra cui **tutti quelli del conto reale** | — | 🟡 = **1,54× il metro di casa** |

### 🔴 **Nessun EA del parco ha come default il metro di casa (0,65%).**
Il migliore parte da **1,0 = 1,54×**. Il peggiore vivo parte da **3,0**.
🟢 **Le uniche eccezioni sono EA che il metro ce l'hanno scritto dentro** e non
sono vivi in forward: `ABTG_AllineaLondra`, `ABTG_BreakinBox`,
`ABTG_CRT_TurtleSoup`, `ABTG_DaxReEntry`, `ABTG_DaxValueArea`,
`ABTG_FiboH4_Corso`, `ABTG_HVAncora`, `ABTG_IBRetest`, `ABTG_ImpulsoApertura`,
`ABTG_InvEsaurimento`, `ABTG_LVNArbitro`, `ABTG_LondonFx`,
`ABTG_NySessionRetest`, `ABTG_OpeningReversalB`, `ABTG_OutOfNoise`,
`ABTG_Relativo` — **16 EA a 0.65 di default**, tutti nati dopo la firma del
18/08. 👉 **La regola nuova è entrata nei motori nuovi e NON è mai stata portata
indietro sui vecchi.** È quello il buco, ed è di manutenzione, non di analisi.

---

# 🔀 CHI SOMMA LE GAMBE, E CHI NO — la mappa

| famiglia | gambe | si sommano? | prova |
|---|---|---|---|
| **PostNews** con `InpUseOCO=true` (default) | 2 pendenti opposti | ❌ **NO** | misurato 10/09: `filled` e `canceled` nello **stesso secondo** |
| **PostNews** con `InpUseOCO=false` | 2 pendenti opposti | ✅ **SÌ** | preset **NFP `771203`**, **ISM `774701`**, **USD1330 `774801`** ce l'hanno **apposta** → 0,65×2 = **1,30%/evento** |
| **Aperture** (DAX/Dow/Nasdaq/ORB/MaxMin/Londra_ORB) | 2 pendenti opposti | 🟠 **nel 25% delle giornate SÌ** | OCO **software a tick**; misurato **4/16 giornate** su `ABTG_ORB` |
| **EMA200** / `_Ottimizzato` | 2 ordini limite | ✅ sommano, **ma il rischio è già diviso /2** (`:222-224`) | ✅ **corretto**: la somma = il dichiarato |
| **Nightly** / `Nightly_Ottimizzato` | SELL LIMIT + BUY LIMIT | ✅ **SÌ, e NESSUN OCO** | `:232` / `:243`; l'unico `CancelPendings()` è al cutoff (`:150`) → **2× pieno** |
| **CanaleLento** | BuyStop + SellStop | ✅ **SÌ**, guardie separate per lato | `:588` / `:617` |
| **GapContinuation** | BUY + SELL | ✅ **SÌ, nessuna guardia di posizione aperta** | `:987` / `:1041` |
| **FiboH4_Multi** | 3 simboli, guardia **per simbolo** | ✅ **SÌ, ×3** | `:183` · `:185` · `:399` |
| **Bulge** / `BULGE_MASTER` | `Max_Trades = 4` | ✅ **SÌ, ×4** | `:412` · `:1247`; il `/Max_Trades` esiste **solo** in `RISK_TOTAL_CAP`, ma il default è `RISK_PER_TRADE` (`:402`) |
| tutti gli altri (PTE, GapFill, BreakingBand, PunteLarry, CostToCost, EasyTrend, …) | 1 posizione | ❌ NO | guardia `HasPosition` / `InpMaxPositions 1` |

📌 **Il caso `InpUseOCO=false` non è ipotetico**: è la configurazione **scelta**
per NFP, ISM e USD1330, perché sul dato macro il prezzo può fare whipsaw e
prendere tutti e due i lati. **Lì il 2× è voluto e prezzato** (0,65 × 2 = 1,30).
🔴 **Ma se su una di quelle sedie il rischio tornasse al default 3.0 senza che
l'OCO torni `true`** (preset caricato a metà, campo modificato a mano), il conto
è **1,50% × 2 = 3,00% su un solo evento, su un solo simbolo** — **quasi il cap
C1 intero.**

---

# 🕳️ I BUCHI DICHIARATI — dove NON ho un numero

| # | buco | perché non è misurabile da qui | cosa lo chiude |
|---|---|---|---|
| **B1** | 🔴 `SYMBOL_VOLUME_MIN`, `SYMBOL_VOLUME_STEP` e valore-punto dei simboli vivi | Sono dati del **broker**, non del repo. Senza, non so **a quale saldo** il pavimento del lotto minimo comincia a mordere, e il contro-esempio 2 resta un ragionamento | `ABTG_SondaMargine` (già scritto, non tocca niente) su **50503392** e su **50504263** |
| **B2** | 🔴 Rischio vero di **`ABTG_GapContinuation` 225JPY (774101)**, sedia **VIVA** | Il lettore CODA_01 cerca `InpMagic`/`InpRiskPercent`; questo EA usa `InpMagicNumber` / `InpBuyRiskPercent` / `InpSellRiskPercent` → esce `magic -  rischio -`. **I totali del piccolo sono un limite inferiore** | estendere il lettore CODA_01 ai nomi alternativi (già suggerito l'08/09, **non fatto**) |
| **B3** | 🔴 **Il `.chr` dice la verità VIVA?** | 🚨 **`CODA_05` (il controllo di freschezza) È ROTTO**: stampa *«la cartella del profilo attivo non esiste»* su **tutte e 6** le cartelle, e `CODA_08` stampa **«TOTALE SEDIE STAMPATE: 0»`. **Non abbiamo nessun controllo funzionante sull'età della foto** | riparare `CODA_05`/`CODA_08` (probabile bug sui nomi di profilo con spazio, es. `SQUADRA 100K`) |
| **B4** | 🟠 Il profilo `.chr` del **REALE** mostra 3 sedie e **nessun Guardian** — ma il Guardian **scrive nel log alle 23:55 del 09/09** su EURGBP H1 | La foto `.chr` del reale è **stantia**: non contiene una sedia che dimostrabilmente gira. **Conferma indipendente che B3 morde** | idem B3 |
| **B5** | 🔴 **Nessun preset del 100k esiste nel repo** | Le taglie 0,65/0,30 del dry-run vivono **solo** nei `.chr`. Se quel profilo si perde, la configurazione della squadra che va in prop **non è ricostruibile** | esportare i `.set` dal terminale **50504263** (era il compito di CODA_08, che è rotto) |
| **B6** | 🔴 `InpAllowLong`/`InpAllowShort` delle **5 sedie del 100k** | Il log CODA_01 stampa solo magic e rischio. **Ho assunto `n=2` (due gambe) per le 4 sedie Aperture del 100k**, che è il caso peggiore. Se anche lì i preset spegnessero un lato, la somma vera scenderebbe da **5,15% a 2,90%** — cioè **sotto il muro** | leggere `InpAllowShort` dai `.chr` del 100k (idem B5) |
| **B7** | 🔴 DD promesso di **771201** e **771202** | `CENSIMENTO_CONTRATTI.md` r.225-226: **NESSUNO**. Girano al 3,0% senza nessun drawdown misurato agli atti | un round di backtest sul motore PostNews |
| **B8** | 🟠 Il rischio vero **in euro** per sedia | Serve la distanza di stop **tipica** di ogni motore, che è per-cella e non sta in un file unico | i CSV dei round già in archivio, sedia per sedia |

---

# 📋 COSA PROPONGO — e cosa NON decido io

🔴 **Taglie e parametri di rischio sono firma di Claudio. Qui c'è la misura e la
proposta, non un cambiamento.**

| # | proposta | perché, col numero | costo |
|---|---|---|---|
| **1** | Portare il **default compilato** di `ABTG_PostNews` da `3.0` al metro di casa, **e `InpRiskRefSLpips` a `InpSLpips`** o rinominare l'input | il `.set` giusto non protegge da un `Resetta`. Misurato oggi: **1,49% contro 0,65% = 2,3×** | ricompilazione + riattacco 3 sedie |
| **2** | Portare i default `2.0` a `1.0` sui **3 EA vivi** (`MaxMinNotte`, `Nasdaq_Apertura_US`, `SupertrendReversal_Ottimizzato`) | salto su `Resetta`: **4,00× · 11,43× · 2,00×** | ricompilazione |
| **3** | 🔴 **Allineare `standalone/ABTG_DAX_Apertura_EU.mq5` r.33** (2.0 → 1.0) | è la copia dell'EA del **CONTO REALE**; il fix C4 del 02/09 ne ha toccata una sola | 1 riga |
| **4** | **Attaccare il Guardian sul piccolo 50503392** | è il terminale che somma **43,40%** di rischio vero e **non ha nessuna riga che applichi il cap** | trascinare un EA |
| **5** | Riparare **CODA_05 e CODA_08** | senza, **non sappiamo se la foto delle sedie è di oggi o di agosto** (e su B4 è dimostrato che non lo è) | mezz'ora |
| **6** | Estendere CODA_01 a `InpMagicNumber` / `InpBuyRiskPercent` / `InpSellRiskPercent` | una **sedia viva** è invisibile ai censimenti da due giorni | mezz'ora |
| **7** | 📐 **Proposta di metodo per la prop**: contare il cap C1 in **GAMBE ARMATE**, non in sedie | il Guardian non vede i pendenti: 5 sedie a due gambe = **6,50% invisibile** al cap | codice nuovo nel Guardian |
| **8** | 📐 Portare il default `0.65` sui ~70 EA a `1.0` | è **manutenzione**, non analisi: la firma del 18/08 è entrata nei 16 EA nuovi e non è mai tornata indietro sui vecchi | una passata |

---

# ✅ E LE COSE CHE VANNO BENE, perché contano quanto le altre

1. 🏛️ **Il conto REALE 10105439 è pulito, misurato, e con margine 2,5×.**
   Due sedie, rischio dichiarato = rischio vero = **0,65%**, somma **1,30%**
   contro un cap di 3,25%. **È l'unico terminale dove i tre numeri coincidono.**
2. 🛡️ **Il Guardian conta euro veri, non etichette.** `OrderCalcProfit` sul
   volume reale e sulla distanza reale: il difetto PostNews **non lo inganna**.
3. 🛡️ **E il Guardian gira su tutti e due i conti che contano** (100k e REALE),
   con log freschi del 09/09 alle 23:55.
4. 🔁 **L'OCO di PostNews funziona davvero**, e adesso è un fatto in mano
   (`filled` + `canceled` nello stesso secondo).
5. ✅ **Nessun EA del parco entra senza stop.** In tutti i casi letti lo SL è
   calcolato **prima** del lotto e passato nella **stessa** chiamata d'ordine.
6. ✅ **Un solo lotto fisso che scavalca il rischio in tutto il parco**
   (`ABTG_GapContinuation.mq5:157 InpFixedLots`), e il suo **default è 0 =
   spento**.
7. ✅ **`EMA200` divide il rischio fra le due gambe come si deve** (`:222-224`):
   è il modello giusto, ed è già in casa.
8. 🎯 **Il modello del lotto lo abbiamo capito**: predetto 1,49%, uscito
   1,4905%. 👉 **Si corregge con una misura, non a tentativi.**

---

## 📎 FONTI

`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260910_033002.log`
(10/09 03:30:04) · `CODA_02_chi_ha_operato_20260910_033002.log` (equity dei due
Guardian) · `CODA_03_conti_dei_terminali_20260910_033002.log` ·
`CODA_05` / `CODA_08` (🚨 **rotti**) ·
`report/POSTNEWS_ECB_ESITO_2026-09-10.md` ·
`report/CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` ·
`report/RISCHIO_DICHIARATO_VS_VERO_2026-09-08.md` (con **una correzione**: il
default del Dow è **1.0**, non 2.0 — vedi contro-esempio 5) ·
`report/CENSIMENTO_CONTRATTI.md` · `report/FIRME_2026-08-18.md` (cap C1) ·
`report/FIRME_2026-09-07.md` (tetto cluster, 🔴 firmato ma **spento**) ·
`report/VERIFICA_CHIUSURE_INCROCIATE_2026-09-03.md` (4/16 giornate) ·
`report/M27_SEGNO_ASPETTATIVA_2026-08-31.md` (6 sedie a lotto minimo) ·
sorgenti `mql5/Experts/*.mq5` e `mql5/Experts/standalone/*.mq5`,
`mql5/Include/ABTG/ABTG_ApertureCore.mqh`, `mql5/Presets/**/*.set`.

*Referto prodotto in SOLA LETTURA. Nessun EA, preset, parametro o terminale è
stato toccato. Taglie e rischio restano firma di Claudio.*
