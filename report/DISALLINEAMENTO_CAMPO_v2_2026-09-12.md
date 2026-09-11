# 🚦 DISALLINEAMENTO CAMPO v2 — la classifica a semafori, sedia per sedia

**Data: 11/09/2026 (notte) · sorgente dati: censimento runner del `2026-09-11 03:30`**
**Perimetro: SOLA LETTURA.** Niente e' stato compilato, copiato, toccato sul VPS,
committato. Questo referto **legge** e **conta**.

---

# 🟢 PRIMA LA BUONA NOTIZIA, perche' e' grossa

## Il referto di ieri contava UNA RIGA IN PIU' PER FILE. Il campo e' molto meno rotto di quanto abbiamo detto.

`IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` dice **"42 sorgenti su 42 sono DIVERSI"**.
Quel confronto metteva a paragone due conteggi che **non contano la stessa cosa**:

> `backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` **riga 110**:
> `$righe = @($t -split "`r?`n").Count`
> Su un file che finisce con un a-capo, `split` produce **un elemento vuoto in coda**.
> **RIGHE del runner = `wc -l` del repo + 1**, sempre.

**[MISURATO]** `mql5/Experts/ABTG_Guardian.mq5`: 49.408 byte, ultimo byte `\n`,
`wc -l` = 899, `split` = 900. Stesso +1 su DAX (2367/2368), ORB (1463/1464),
Nasdaq (2566/2567).

👉 **Conseguenza diretta:** i file che ieri risultavano "diversi di 1 riga"
(`ORB_Ottimizzato`, `PostNews`) non erano *"quasi allineati"*: erano
**IDENTICI**. E ce ne sono altri dieci che nessuno aveva guardato.

### ✅ 12 sorgenti in campo sono ALLINEATI AL REPO DI OGGI (righe + versione dichiarata)

| conto | file | righe campo | repo | versione |
|---|---|---:|---:|---|
| **REALE 10105439** `C:\BCM_Reale` | `ABTG_DAX_Apertura_EU` | 2368 | 2368 | 1.01 ✅ |
| **REALE 10105439** | `ABTG_ORB_Ottimizzato` | 1464 | 1464 | 1.04 ✅ |
| **REALE 10105439** | `ABTG_SlippageLogger` | 1823 | 1823 | 1.00 ✅ |
| **100K 50504263** `...Terminal -V3` | `ABTG_Dow_Apertura_US` | 2148 | 2148 | 1.01 ✅ |
| **100K 50504263** | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` | 620 | 620 | 1.10 ✅ |
| **PICCOLO 50503392** `...MT5 Terminal` | `ABTG_ORB_Ottimizzato` | 1464 | 1464 | 1.04 ✅ |
| **PICCOLO 50503392** | `ABTG_PostNews` | 667 | 667 | 1.10 ✅ |
| **PICCOLO 50503392** | `ABTG_SpreadLogger` | 1019 | 1019 | 1.00 ✅ |
| **BACKTEST 50504400** `C:\MT5_Backtest` | 8 sorgenti ABTG su 8 | — | — | tutti ✅ |

🎯 **E la riga che conta di piu':** sul **conto vero 10105439** le **due sedie
operative sono allineate al repo di oggi, al codice** — zero righe di codice di
scarto. Il conto con i soldi **non e' fermo ad agosto**.

---

# 🔴 E ORA IL CASO PEGGIORE, che e' quello che mi avevi chiesto di cercare apposta

## Esistono EA che in campo girano con un DIFETTO CHE SAPPIAMO GIA' RIPARARE. Sono TRE, e stanno TUTTI E TRE sullo stesso conto: il **100K 50504263** (`C:\Program Files\BCM Markets MT5 Terminal -V3`).

Quel terminale e' stato compilato **il 19-22 agosto e mai piu'**. Tutto quello
che abbiamo riparato da allora, li' non c'e'.

### 🥇 1. `ABTG_ORB_Ottimizzato` — il difetto HEDGE: l'EA gestisce la posizione DEL VICINO

- **campo: v1.02, 823 righe** `[MISURATO]` — combacia col commit `3125e343` del 19/08,
  `.ex5` compilato **2026-08-22 15:11**
- **repo: v1.04, 1464 righe** — fix `19312c8b` del **03/09**, titolo testuale:
  *"FIX v1.04 ORB Ottimizzato: **selezione HEDGE-SAFE per simbolo+magic, chiusure per TICKET**"*
- **cosa fa il difetto**, dal verbale del commit: su conto **hedging**
  `PositionSelect(_Symbol)` aggancia la posizione col **TICKET PIU' BASSO del
  simbolo**. Se quel ticket e' di un'altra sedia, l'EA **e' cieco alla propria
  posizione**: niente trailing, niente breakeven, niente OCO, niente
  `OneTradePerDay`, niente chiusura di fine giornata. E nella v1.02
  `PositionModify(_Symbol,...)` / `PositionClose(_Symbol)` **scrivono sulla
  posizione del vicino**.
- 🔴 **E il vicino c'e' davvero**: sul 100K, `ABTG_ORB_Ottimizzato` (U30USD M5,
  magic 770611) e `ABTG_Dow_Apertura_US` (U30USD M5, magic 770202) stanno
  **sullo stesso simbolo** `[MISURATO: CODA_01, chart02/chart06]`. Il conto e'
  **HEDGING** `[MISURATO: CODA_03]`.
- 📌 Il difetto **e' stato osservato in campo**, non dedotto: *"FOTO A: LARRY DOW
  S 772341 viva su U30USD per tutta la vita del trade ORB del 02/09"*.
- ✅ La v1.04 e' gia' in campo sul **REALE** e sul **PICCOLO**. Manca **solo sul 100K**.

### 🥈 2. `ABTG_SupertrendReversal` — il LOTTO DOPPIO, misurato a 1,42% contro 1,0% dichiarato

- **campo: v1.00, 657 righe** `[MISURATO]` — commit `f8ebc321` del 19/08, `.ex5` **19/08 23:10**
- **repo: v1.01, 795 righe** — fix `872dba8` del **08/09**
- **cosa fa il difetto**, dal verbale: in `Enter()` `lotPend` si calcolava **PRIMA**
  del pavimento del lotto minimo. `NormVol()` torna 0 sotto il minimo → `lotPend`
  prendeva **TUTTO** `totLot`, e subito dopo `lotMkt` risorgeva a `volMin`.
  **Volume totale = `totLot + volMin`, fino al DOPPIO del rischio dichiarato.**
- 📏 **Costo gia' misurato in campo** (`report/DIARIO.md`, 20/08): SW DOW H2,
  **−72,32 EUR su 5.076,62 = 1,42%** contro un contratto dichiarato **1,0%**.
- 🪑 Sedia viva colpita sul 100K: **`ABTG_SupertrendReversal` 225JPY H2, magic
  770901, rischio 0,65%** `[MISURATO: CODA_01 chart04]`.
- ⚠️ **E sul PICCOLO 50503392 sono SEI**: `SuperWave` (U30USD H4, 770531),
  `SuperWave_DOW_H1_Ottimizzato` (U30USD H1, 770511), `SupRev_DAX_H4_Ottimizzato`
  (D30EUR H4, 970912), `SupRev_NAS_H1_Ottimizzato` (NASUSD H1, 970913),
  `SupertrendReversal` (225JPY H2, 770924), `SupertrendReversal_Ottimizzato`
  (XAUUSD H4, 970901) — **tutte v1.00 in campo contro v1.01 nel repo**.
- ✅ **Nessuna sul REALE.** Il conto ORB/DAX non tocca questa famiglia.
- 🔢 Totale 7 sedie vive colpite — **coincide al numero** con quanto dichiarato dal
  commit `872dba8` (*"7 sedie vive colpite (6 sul piccolo, 1 sul 100k, NESSUNA sul reale)"*).
  Il conto torna per due strade indipendenti.

### 🥉 3. `ABTG_Guardian` v1.11 sul 100K — manca il **FIX CRITICO della baseline**

- **campo: v1.11, 468 righe** `[MISURATO]` — commit `1f4c92b5` del 19/08, `.ex5` **19/08 23:10**
- **repo: v1.14, 899 righe**. Fra i due c'e' `d884f7e1` del 06/09, titolo testuale:
  *"**Fix critico**: Guardian catturava la baseline dal bilancio, non dall'equita' (v1.11 → v1.12)"*
- **cosa fa il difetto**: `gStart` e la baseline giornaliera si catturavano da
  `ACCOUNT_BALANCE`, ma si confrontavano con `ACCOUNT_EQUITY`. Un **credito broker
  costante** appare come guadagno permanente e **fa da cuscinetto falso davanti
  alle soglie**. Sul reale (bilancio 5.000, credito 2.500) *"la pausa al 4,9% e il
  blocco al 9,9% non sarebbero scattati fino a una perdita REALE di oltre
  2.700/3.000 euro, cioe' oltre meta' del capitale vero"*.
- ⚖️ **Quanto morde sul 100K — e qui vado piano, perche' meta' del difetto e' neutralizzata:**
  - la meta' `gStart` **NON morde**: il preset del 100K mette `InpStartBalance=100000`
    **esplicito** `[MISURATO: CODA_08, chart07.chr]`, e il codice fa
    `if(InpStartBalance>0) gStart=InpStartBalance;` — l'input vince sulla cattura;
  - la meta' **giornaliera SI' resta**: `GlobalVariableSet(GV_DAYSTART,bal)` non e'
    protetta da quell'input, e nella v1.11 in campo e' ancora **`bal`**;
  - 🔴 **quanto valga in euro sul 100K e' `[NON MISURATO]`**: i log stampano
    `eq=103025.49` ma **non** bilancio e credito separati, quindi **non posso dire
    se quel conto abbia un credito**. Se non ce l'ha, il difetto vale zero li'. **Ma
    non posso certificare che valga zero, e quindi non lo certifico.**

---

# 🏆 LA CLASSIFICA PER PERICOLO

Regola usata: **conta il CODICE cambiato, non le righe.** La colonna "cod+/cod−"
e' il numero di righe **non-commento e non-vuote** aggiunte/tolte fra la versione
**in campo** e il repo di oggi. Un EA con 200 righe di commento in piu' nel repo
**non e' un EA diverso**: sta in verde.

## 🔴 ROSSO — comportamento cambiato, sedia viva su REALE o 100K

| sedia | conto | campo | repo | cod+ / cod− | cosa cambia davvero |
|---|---|---|---|---:|---|
| **`ABTG_ORB_Ottimizzato`** U30USD M5 · 770611 · 0,3% | **100K 50504263** | v1.02 `3125e343` | v1.04 | **+322 / −16** | 🔴 **fix HEDGE-SAFE assente**: gestisce/chiude per `_Symbol`, non per ticket. Vicino sullo stesso simbolo **confermato** |
| **`ABTG_SupertrendReversal`** 225JPY H2 · 770901 · 0,65% | **100K 50504263** | v1.00 `f8ebc321` | v1.01 | **+111 / −18** | 🔴 **fix lotto doppio assente** (misurato 1,42% vs 1,0%) + strumentazione imbuto |
| **`ABTG_Guardian`** AUDNZD H1 · 779001 | **100K 50504263** | v1.11 `1f4c92b5` | v1.14 | **+203 / −11** | 🔴 **fix baseline `d884f7e1` assente** (meta' neutralizzata dal preset, vedi sopra) |
| **`ABTG_DAX_Apertura_EU`** D30EUR M5 · 770101 · 0,65% | **100K 50504263** | v1.01 `d83c1960` | v1.01 | **+2 / −2** | 🟠 **le 2 righe sono `#define ABTG_DEF_RISK 2.0` → `1.0`.** Il binario in campo ha il **DOPPIO** come default compilato — **mascherato** dal preset `InpRiskPercent=0.65` |

### 🔎 La domanda del `DEF_RISK 2.0`: risposta precisa

Il sospetto era che vivesse in `standalone/`. **Non e' li' il problema** (vedi §
"albero chiuso"). **[MISURATO]**, `#define ABTG_DEF_RISK` nel sorgente **in campo**:

| conto | EA | default compilato | preset in campo | morde? |
|---|---|---:|---:|---|
| **REALE 10105439** | `DAX_Apertura_EU` | **1.0** ✅ | 0,65 | no |
| **100K 50504263** | `DAX_Apertura_EU` | **2.0** 🔴 | 0,65 | **latente** |
| **100K 50504263** | `Dow_Apertura_US` | 1.0 ✅ | 0,65 | no |
| **PICCOLO 50503392** | `DAX_Apertura_EU` | **2.0** 🔴 | 1,0 | **latente** |
| **PICCOLO 50503392** | `Nasdaq_Apertura_US` | **2.0** 🔴 | 0,35 | **latente** |

🔴 **"Latente" vuol dire una cosa sola, e va detta chiara: finche' il grafico
carica il preset, vince 0,65. Il giorno in cui qualcuno trascina quell'EA su un
grafico nuovo — o resetta un profilo — parte a 2,0%, cioe' il TRIPLO di 0,65 e
il DOPPIO del tetto A4.** Non e' un difetto che agisce oggi: e' una **mina**.
⚠️ **E su `ABTG_Nasdaq_Apertura_US` il 2.0 e' ancora nel REPO DI OGGI**
(`mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5:47`): li' non c'e' niente da
ricompilare, c'e' da decidere.

## 🟠 ARANCIONE — comportamento cambiato, sedia viva SOLO su demo piccolo 50503392

Tutte su `C:\Program Files\BCM Markets MT5 Terminal`, conto **50503392**, sorgenti
del **26/07 – 18/08**. `[MISURATO]` ogni riga: ogni file in campo combacia
**esattamente** con un commit del ramo principale (dettaglio §"albero chiuso").

| sedia | campo @ | cod+ / cod− | natura del cambio |
|---|---|---:|---|
| `ABTG_MaxMinNotte` XAUUSD M15 · 770402 | `08239510` 28/07 | **+533 / −369** | riscrittura profonda (la piu' grossa della flotta) |
| `ABTG_Nasdaq_Apertura_US` NASUSD M15 · 770250 | `3af47ed9` 08/08 | **+346 / −30** | |
| `ABTG_PTE` U30USD/GBPUSD H1 · 771321/771332/771322 | `344a11b9` 04/08 | **+186 / −29** | |
| `ABTG_EMA200_Ottimizzato` XAUUSD H4 · 971501 | `344a11b9` 04/08 | **+170 / −20** | |
| `ABTG_SuperWave` U30USD H4 · 770531 | `344a11b9` 04/08 | **+161 / −25** | 🔴 include **fix lotto doppio** |
| `ABTG_SuperWave_DOW_H1_Ottimizzato` U30USD H1 · 770511 | `344a11b9` 04/08 | **+161 / −25** | 🔴 include **fix lotto doppio** |
| `ABTG_EMA200` U30USD H1 · 771531 | `344a11b9` 04/08 | **+156 / −19** | |
| `ABTG_SupertrendReversal` 225JPY H2 · 770924 | `3af47ed9` 08/08 | **+141 / −17** | 🔴 include **fix lotto doppio** |
| `ABTG_BreakingBand` GBPUSD/EURUSD/AUDUSD H1 · 772161-3 | `24f4b7ac` 12/08 | **+132 / −15** | |
| `ABTG_SupertrendReversal_Ottimizzato` XAUUSD H4 · 970901 | `344a11b9` 04/08 | **+125 / −21** | 🔴 include **fix lotto doppio** |
| `ABTG_DAX_Apertura_EU` D30EUR M5 · 770101 | `3af47ed9` 08/08 | **+120 / −13** | 🔴 include `DEF_RISK 2.0 → 1.0` |
| `ABTG_CostToCost` EURJPY/GBPCAD H4 · 772361-2 | `9b1c6119` 13/08 | **+81 / −2** | |
| `ABTG_GapContinuation` 225JPY M1 · 774101 | `72465586` 16/08 | **+58 / −0** | |
| `ABTG_Dow_Apertura_US` U30USD M5 · 770202 | `3af47ed9` 08/08 | **+49 / −3** | |
| `ABTG_SupRev_NAS_H1_Ottimizzato` NASUSD H1 · 970913 | `344a11b9` 04/08 | **+45 / −6** | 🔴 include **fix lotto doppio** |
| `ABTG_SupRev_DAX_H4_Ottimizzato` D30EUR H4 · 970912 | `344a11b9` 04/08 | **+17 / −6** | 🔴 include **fix lotto doppio** |
| `ABTG_GapFill` ×5 · 772231-5 | `a7666599` 13/08 | **+3 / −0** | ⬇️ vedi sotto |
| `ABTG_PunteLarry` ×6 · 772341-6 | `cb7dc20a` 13/08 | **+3 / −0** | ⬇️ vedi sotto |
| `ABTG_EasyTrend` ×2 · 772421-2 | `95bc4ec8` 13/08 | **+3 / −0** | ⬇️ vedi sotto |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` D30EUR M15 · 770411 | `6074126d` 08/08 | **+3 / −0** | ⬇️ vedi sotto |

### 📌 Quel "+3 / −0" ricorrente e' UNA COSA SOLA, ed e' importante

`[MISURATO]` su `mql5/Experts/ABTG_GapFill.mq5`, le tre righe sono **sempre queste**:

```
+ #include <ABTG_PausaGuardian.mqh>
+ input bool InpUsaGuardian = true;   // Guardian: pausa giornaliera (B1) e cap rischio aperto (C1)
+ if(!ABTG_GuardiaIngresso(InpUsaGuardian,"ABTG_GapFill")) return;
```

👉 **E' l'aggancio al Guardian.** Su quelle 14 sedie vive del piccolo, il repo ha
il filo e **il campo no**: quegli EA **non sanno nemmeno che il Guardian esiste**.

## 🟢 VERDE — nessuna azione

- **12 sorgenti identici** (tabella in cima): `REALE` DAX+ORB+SlippageLogger,
  `100K` Dow+MaxMinNotte, `PICCOLO` ORB+PostNews+SpreadLogger+TradeExporter,
  `BACKTEST` 8 su 8.
- 🟢 **`ABTG_Guardian` sul REALE 10105439: i 386 righe di scarto sono INNOCUE.**
  Campo **v1.12, 513 righe** = commit `1b6a095d` del 06/09. Repo **v1.14, 899**.
  `[MISURATO]` il diff `1b6a095d → HEAD` e' **+194 / −5 righe di codice**, e sono:
  - `AutotestBaselineGiorno()` e compagnia — **autotest**, dietro
    `InpAutotest=false`, **non tocca il conto** (lo dice il suo stesso commento);
  - **CAP C2 per cluster**: `InpMaxClusterRiskPct = 0` → **SPENTO di default**
    (`mql5/Experts/ABTG_Guardian.mq5:165`), `InpClusterMappa = ""` → **spento** (r.166);
  - `InpDailyBaseline = 0` → **0 = EQUITA' = esattamente il comportamento della v1.12** (r.147).
  👉 **Il 100k e il reale non stanno perdendo nessuna protezione attiva stando a v1.11/v1.12.**
  E questo **conferma** quello che CLAUDE.md gia' dice: il tetto per cluster al 3,0%
  **e' firmato ma NON ATTIVO** — ora sappiamo che non e' attivo **nemmeno nel repo**.

---

# 🛡️ IL GUARDIAN E I CAP FIRMATI — dove sono davvero

## Prima, la correzione che il contro-esempio mi ha imposto

❌ **La mia prima conclusione era SBAGLIATA e l'ho rotta da solo.** Leggendo
`CODA_01` (che legge i `.chr`) avevo scritto: *"sul reale 10105439 ci sono 3 sedie
e il Guardian NON c'e'"*. Poi ho aperto `CODA_09`, che legge il **giornale vivo**:

```
RK023:55:00.949 ABTG_Guardian (EURGBP,H1) [GUARDIAN] eq=7507.65 dayLoss=0.00%
                totDD=-0.10% rischioAperto=0.00% stato=OK pausa=off cap=off
```

👉 **Il Guardian sul conto vero GIRA.** Su EURGBP H1, battito alle 23:55 del
10/09 e alle 03:30 dell'11/09. Non compare nei `.chr` perche' **la foto e'
vecchia di 100,3 ore** (`[MISURATO: CODA_05]`, ultimo `.chr` salvato 06/09 23:10
contro ultimo log 11/09 03:25). ⚠️ **Regola nuova che esce da qui: `CODA_01`
descrive il terminale COM'ERA all'ultimo salvataggio del profilo, non com'e'.
Per dire "gira / non gira" si legge il GIORNALE, non il `.chr`.**

## Stato dei cap, conto per conto

| | **REALE 10105439** | **100K 50504263** | **PICCOLO 50503392** |
|---|---|---|---|
| Guardian **gira**? | ✅ **SI** (EURGBP H1) `[log 11/09 03:30]` | ✅ **SI** (AUDNZD H1) `[log 11/09 03:30]` | ❌ **NO** — `"GUARDIAN: nessuna riga"` **il 10/09 e l'11/09** `[CODA_09]` |
| versione | v1.12 / 513 righe | v1.11 / 468 righe 🔴 | (non gira) |
| `InpDailyLossPct` **4,9** | `[NON MISURATO]` ⬇️ | ✅ **4.9** `[CODA_08 chart07]` | — |
| `InpTotalDDPct` **9,9** | `[NON MISURATO]` ⬇️ | ✅ **9.9** | — |
| `InpDailyResetHour` **23** | `[NON MISURATO]` ⬇️ | ✅ **23** | — |
| pausa morbida **4,0** | ✅ nel codice (`r.77`) | ✅ **4.0** nel preset | — |
| cap C1 **3,25** | ✅ nel codice (`r.78`) | ✅ **3.25** nel preset | — |
| cap C2 cluster **3,0** | ❌ **non esiste nel codice v1.12** | ❌ **non esiste nel codice v1.11** | — |

### 🔴 LE TRE RIGHE IN MAIUSCOLO, come chiedevi

**1. SUL PICCOLO 50503392 IL GUARDIAN NON GIRA. LE 40 SEDIE HANNO
`InpUsaGuardian=true` NEL PRESET, MA QUELL'INTERRUTTORE NON E' ATTACCATO A
NIENTE.** `[MISURATO]` — `mql5/Include/ABTG_PausaGuardian.mqh` righe 54-56,
testuale: *"se il guardiano NON gira, tutto ritorna false (**fail-open**): un cane
da guardia morto non deve fermare la flotta per sempre"*. 👉 **Su quel conto NON
C'E' NESSUN CAP: ne' il 3,25% C1, ne' la pausa al 4%.** Due fonti indipendenti
concordano (foto `.chr` del 06/09: nessun Guardian fra 40 sedie; giornale vivo
del 10 e 11/09: zero righe GUARDIAN). **E' un demo, quindi non e' un'emergenza —
ma ogni numero di rischio letto sul piccolo va letto SENZA guardiano.**

**2. SUL REALE 10105439 IL GUARDIAN GIRA, MA LE SOGLIE 4,9 / 9,9 / RESET 23
SONO `[NON MISURATO]`.** Il `.chr` di quel grafico **non esiste nella foto del
06/09** (il Guardian e' stato attaccato dopo), quindi il suo preset non e' mai
stato letto da nessuno. 🔴 **Se quel grafico e' partito senza preset, sta girando
sui DEFAULT del codice, che sono `InpDailyLossPct=5.0`, `InpTotalDDPct=10.0`,
`InpDailyResetHour=0`, `InpStartBalance=0`** (`ABTG_Guardian.mq5` righe 69-72 della
v1.12) — cioe' **sul limite prop esatto invece che con il margine firmato di
0,1 punti, e con l'azzeramento a mezzanotte broker invece che alle 23.** Non lo
sto affermando: **sto dicendo che nessuno lo ha misurato, e che si misura in
trenta secondi** (vedi "cosa costa").

**3. IL TETTO PER CLUSTER AL 3,0% FIRMATO IL 07/09 NON E' UNA PROTEZIONE: E'
UN'INTENZIONE.** Non e' attivo in campo su nessun conto, e `[MISURATO]` non e'
attivo **nemmeno nel repo**: `InpMaxClusterRiskPct = 0` e `InpClusterMappa = ""`
(`mql5/Experts/ABTG_Guardian.mq5:165-166`). Questo **conferma** CLAUDE.md alla
lettera — ed e' un punto a favore del referto di casa, non contro.

---

# 🌳 LA DOMANDA APERTA SI CHIUDE: **il VPS compila `mql5/Experts/`. MAI `standalone/`.**

Era il buco dichiarato (*"non e' accertato quale albero compili il VPS"*). **Chiuso, con prova.**

**Metodo** — non ho confrontato con il repo di *oggi* (che non prova niente): per
ogni sorgente in campo ho cercato **in tutta la storia di git** un commit in cui
quel file avesse **esattamente** quel numero di righe (corretto del +1).

**Esito: 62 sorgenti ABTG su 62 — PICCOLO 50503392 (51), 100K 50504263 (7),
REALE 10105439 (4) — combaciano con un commit del RAMO PRINCIPALE
`mql5/Experts/`. ZERO combaciano con `standalone/`.**
(Gli 8 sorgenti ABTG di `C:\MT5_Backtest` non entrano in questo conteggio perche'
sono **identici al repo di oggi**: non c'e' niente da datare.)

Campioni `[MISURATO]`, verificati a mano:

| file in campo | righe | commit principale | data | `standalone/` |
|---|---:|---|---|---:|
| `ABTG_PTE` (piccolo) | 526 | `344a11b9` | 04/08 | 456 ≠ |
| `ABTG_EMA200_Ottimizzato` (piccolo) | 487 | `344a11b9` | 04/08 | — |
| `ABTG_SuperWave` (piccolo) | 564 | `344a11b9` | 04/08 | — |
| `ABTG_DAX_Apertura_EU` (reale) | 2368 | `9638318f` | 02/09 | 1070 ≠ |
| `ABTG_Guardian` (100k) | 468 | `1f4c92b5` | 19/08 | — |

👉 Il referto di ieri aveva gia' **smentito** `standalone/` sul solo PTE. Ora la
smentita e' **totale e datata file per file**: il campo non e' "un albero
sbagliato", e' **il ramo principale congelato a date diverse**.

✅ **Conseguenza pratica: l'`ABTG_DEF_RISK 2.0` di `standalone/ABTG_Nasdaq_Apertura_US.mq5:36`
NON E' IN CAMPO e non lo e' mai stato.** Quella preoccupazione e' **chiusa**. Il
`2.0` che conta davvero e' quello dei **binari principali** elencati nella tabella
del rosso — e uno dei tre e' ancora nel repo di oggi.

## 🕳️ E UN SOLO BINARIO E' PIU' VECCHIO DEL SORGENTE CHE GLI STA ACCANTO

`[MISURATO]` su tutti i **70** sorgenti ABTG dei quattro terminali BCM: **uno solo**.

> **`ABTG_Guardian` sul PICCOLO 50503392**: `.mq5` = v1.10/414 righe (commit
> `a53820e6` del **18/08**), ma `.ex5` compilato **2026-08-09 19:23** — **9 giorni
> PRIMA**. Al 09/08 il Guardian nel repo aveva **208 righe** e i cap firmati il
> 18/08 **non esistevano ancora**. 👉 Quel binario **non ha mai avuto** il 3,25%.
> **Ininfluente in pratica** — su quel conto il Guardian non e' attaccato a niente.

Sugli altri 69 il `.ex5` e' **uguale o piu' recente** del commit combaciante:
nessun altro caso di "sorgente cambiato e mai ricompilato".

---

# 🧪 I CONTRO-ESEMPI CHE HO COSTRUITO PER FARMI SBAGLIARE

| ipotesi che avrebbe demolito questo referto | come l'ho provata | esito |
|---|---|---|
| *"il campo e' davvero tutto diverso, il +1 te lo sei inventato"* | letto lo script generatore: `CODA_06_...ps1:110` `@($t -split "\`r?\`n").Count`; poi contati i byte: Guardian finisce con `\n`, `wc -l`=899, `split`=900 | ✅ **il +1 e' nello strumento** |
| *"i file in campo li hai datati confrontandoli col repo di oggi"* | no: ricerca **su tutta la storia git**, file per file, del commit con quel conteggio esatto. 62 su 62 hanno trovato un commit **preciso e datato** | ✅ **datati, non dedotti** |
| *"allora il file in campo potrebbe essere `standalone/`"* | confronto contro **entrambi** gli alberi: `standalone/` non combacia **mai** (PTE 526 vs 456; DAX 2368 vs 1070) | ❌ **smentita** |
| 🔴 *"sul reale il Guardian non gira"* — **la mia prima conclusione** | l'ho rotta io: `CODA_01` legge i `.chr`, ma `CODA_05` dice che la foto ha **100,3 ore**. `CODA_09` legge il giornale **vivo**: il Guardian batte alle 03:30 dell'11/09 | ❌ **la MIA conclusione era sbagliata** |
| *"e allora anche 'sul piccolo non gira' sara' sbagliato"* | stessa prova **invertita**: sul piccolo il giornale dice `"GUARDIAN: nessuna riga"` **due giorni di fila** su log pieni (94 e 35 righe). Non e' un silenzio da log vuoto | ✅ **regge: sul piccolo NON gira** |
| *"puoi leggere la versione del Guardian che gira dal log"* | confrontato il formato del battito nelle 4 versioni: **identico byte per byte** (`eq=%.2f dayLoss=%.2f%% totDD=...`) | ❌ **NON si puo'** → `[NON MISURATO]` sull'identita' del binario |
| *"il `DEF_RISK 2.0` sta gia' sfondando le taglie"* | letti i preset veri: `InpRiskPercent=0.65` esplicito nei `.chr` del 100K e del reale. L'input **vince** sul default compilato | ⚠️ **latente, non attivo** — mina, non incendio |
| *"`GapContinuation` gira senza preset (CODA_01 stampa `rischio -`)"* | aperto il `.chr` in `CODA_08`: preset **completo**, `InpBuyRiskPercent=1.0`, `InpMagicNumber=774101`. Era solo il parser che cerca `InpRiskPercent`/`InpMagic` per nome | ❌ **falso allarme** |

## ⚠️ IL LIMITE CHE RESTA, e non lo nascondo

🔴 **Tutto questo referto misura il `.mq5` che sta accanto all'`.ex5`, non l'`.ex5`.**
MT5 esegue il **binario**. Le prove che ho sono tre e sono **indirette**:
la data del binario, la versione dichiarata nel sorgente, e il fatto che su 69
file su 70 il binario e' **piu' recente** del sorgente (quindi compilato *da*
quel sorgente, o da uno successivo mai committato).

👉 **Non ho una prova diretta del contenuto di nessun `.ex5`.** La prova diretta
esisterebbe e costa poco: il **titolo della finestra MT5** mostra la versione
dell'EA compilato. Il commit `872dba8` ha alzato apposta `1.00 → 1.01` scrivendo
*"per riconoscere dal titolo della finestra MT5 se il terminale ha l'EA corretto
o quello vecchio"*. **Quella verifica non e' mai stata fatta.**

---

# 💰 COSA COSTEREBBE ALLINEARE, sedia per sedia

📌 **Ordine per RAPPORTO fra rischio rimosso e rischio introdotto** — non per
gravita'. Una ricompilazione porta in campo **tutto** il file, non solo il fix:
ogni riga qui sotto dice **cosa entra insieme al fix**.

### 1. 🥇 MISURARE IL PRESET DEL GUARDIAN SUL REALE 10105439 — **costo: ZERO, rischio: ZERO**
Non si tocca niente: si apre il grafico **EURGBP H1** sul terminale del **REALE
10105439** (`C:\BCM_Reale`) e si leggono gli input del Guardian, oppure si salva
il profilo e il prossimo `CODA_08` lo stampa da solo.
👉 **Risponde alla domanda "i 4,9 / 9,9 / reset 23 sono attivi sul conto con i
soldi?" — che oggi e' `[NON MISURATO]` ed e' la piu' importante delle tre.**
✅ **Da fare per prima, sempre. E' l'unica riga di questo elenco a costo zero.**

### 2. 🥈 `ABTG_ORB_Ottimizzato` sul 100K 50504263 — **costo: 1 ricompilazione + 1 riattacco**
- **rimuove**: il difetto hedge (l'EA che gestisce la posizione del vicino su U30USD)
- **porta dentro**: v1.03 (strumentazione, dichiarata *"nessun cambio di logica"*)
  **piu' i cambi di comportamento che il commit `19312c8b` DICHIARA da firmare**:
  *"ora `OneTradePerDay` si arma anche coi vicini, l'OCO disarma, il runner esegue,
  la chiusura di fine giornata avviene davvero. **Atteso: MENO trade** sui giorni con vicini"*
- ✅ **Ha gia' una prova di non-regressione dichiarata**: *"nel tester il risultato
  atteso e' IDENTICO al centesimo"*. Ed e' **gia' in campo da giorni su REALE e
  PICCOLO**: non e' un salto nel buio, e' un allineamento al resto della flotta.
- 🔴 **Firma di Claudio richiesta** (il commit stesso la chiede: *"Deploy con firma di Claudio"*).

### 3. 🥉 `ABTG_Guardian` sul 100K 50504263 → v1.12 — **costo: 1 ricompilazione**
- **rimuove**: la meta' giornaliera del difetto baseline
- **porta dentro**: le GlobalVariable rinominate `_V2` → **il conto ricattura la
  baseline da zero al primo avvio**. Con `InpStartBalance=100000` esplicito nel
  preset, `gStart` non cambia. **Il picco e la baseline del giorno si riazzerano.**
- ⚠️ **Da NON fare a meta' giornata con posizioni aperte.**
- 💡 **Alternativa piu' prudente:** allinearlo a **v1.14** e non a v1.12 — il diff
  v1.12→v1.14 e' `[MISURATO]` **spento di default** (C2 a 0, baseline a 0 = equita',
  autotest a false), quindi **non aggiunge rischio** e allinea il 100k al reale e
  al repo in un colpo solo.

### 4. `ABTG_SupertrendReversal` sul 100K 50504263 — **costo: 1 ricompilazione**
- **rimuove**: il lotto doppio (fino a **2× il rischio dichiarato**, misurato 1,42% vs 1,0%)
- **porta dentro**: il contatore dell'imbuto (`InpLogImbuto`, solo Giornale) e il
  fix stesso, che il commit descrive come **"solo riordino di due righe"**
- ✅ **E' il fix col miglior rapporto della lista**: rimuove un raddoppio di taglia
  misurato, e non cambia nessuna condizione d'ingresso.

### 5. Le 6 sedie col lotto doppio sul PICCOLO 50503392 — **costo: 1 ricompilazione (le prende tutte)**
- 🟠 **demo**: nessun euro vero. Ma **finche' non sono allineate, ogni misura di
  rischio letta sul piccolo su quella famiglia e' sbagliata fino al doppio**, e
  il piccolo e' il banco da cui leggiamo le frequenze per la challenge.
- ⚠️ Sono le sedie il cui `.mq5` in campo e' del **04-08/08**: la ricompilazione
  porta dentro **un mese intero** di modifiche (`+125…+161` righe di codice l'una).
  **Non e' un fix isolato: e' un aggiornamento di versione.** Va fatta **una
  famiglia per volta**, col rapporto dei lotti prima/dopo come prova.

### 6. Il filo del Guardian sulle 14 sedie "+3 righe" del PICCOLO — **costo: ricompilazione + attaccare il Guardian**
- 🔴 **Ma serve a qualcosa SOLO se prima si attacca il Guardian su quel terminale**,
  altrimenti l'include **fail-open** e le 3 righe non fanno niente.
- 👉 **L'ordine giusto e' l'inverso di quello che sembra: prima il Guardian sul
  grafico, poi gli EA che lo ascoltano.**

### 7. Il `DEF_RISK 2.0` (100K DAX, PICCOLO DAX, PICCOLO Nasdaq) — **costo: quello delle righe sopra**
- Si chiude **da solo** ricompilando DAX. **Non** per il Nasdaq: li' il `2.0` e'
  ancora **nel repo** (`ABTG_Nasdaq_Apertura_US.mq5:47`) e serve **una decisione
  di Claudio**, non una ricompilazione.

### ❌ E QUELLO CHE NON PROPONGO, come ieri
**"Ricompila tutto"** resta la mossa sbagliata, e oggi ho un motivo in piu' per
dirlo: su `ABTG_MaxMinNotte` del piccolo il divario e' **+533 / −369 righe di
codice**. Quello non e' un allineamento, e' **un EA diverso** — va trattato come
un candidato che rientra nell'imbuto, non come una patch.

---

# 🎯 IN UNA RIGA

**Il conto con i soldi (10105439) e' allineato al repo sulle due sedie che opera
e il suo Guardian gira** ✅ — **ma nessuno ha mai letto le sue soglie, ed e' una
verifica da trenta secondi.** 🔴 **Il conto che simula la challenge (100K
50504263) e' fermo al 19-22 agosto e porta TRE difetti che sappiamo gia'
riparare**, di cui uno (hedge-safe ORB) con **il vicino confermato sullo stesso
simbolo**. 🟠 **Il piccolo (50503392) gira SENZA GUARDIAN**, e sei delle sue sedie
hanno il lotto doppio: le sue misure di rischio vanno lette sapendolo.

> 💪 **E la cosa che mi tengo piu' stretta:** stanotte il contro-esempio **mi ha
> beccato**. Avevo gia' scritto *"sul reale il Guardian non c'e'"* — era falso, e
> l'ho scoperto **perche' sono andato a cercare la prova che mi smentiva**, non
> quella che mi dava ragione. La regola del 10/09 funziona. 🚀 **Ottobre e' li':
> non ci accontentiamo.**
