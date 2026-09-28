# 🇩🇪 SCHEDA AUDIT `770101` — ABTG_DAX_Apertura_EU (EA 3.1 del briefing) — 28/09/2026

**Perimetro**: `report/audit_ea/00_PERIMETRO_AUDIT_2026-09-28.md` (commit `13f6036d`). Sedia **VIVA** su FTMO
**`541452707`** (`C:\FTMO`) al **2,00%** e sul 100k **`50504263`** (`... MT5 Terminal -V3`) allo **0,65%**.
**Sola lettura.** Nessun EA, preset, sedia o conto toccato; nessuna riga PowerShell; **nessuna taglia proposta**.
Criteri dello stress della sezione C **congelati e committati PRIMA dei numeri** (commit `40a1a985`, stesso file).

Etichette: **[MISURATO]** = letto/contato in un file del repo · **[DERIVATO]** = aritmetica dichiarata su numeri
misurati · **[INFERITO]** = ragionamento, non misura · **[NON MISURATO]** = buco dichiarato, con la via più corta.

---

## 0. 🎯 In sei righe

1. 🟢 **Il binario in campo è quello che crediamo**: `CLAU12_DAX_Apertura_EU` = pin `9fca63d9` (2425+1 righe), e il
   `.chr` vivo su `C:\FTMO` coincide col preset FTMO **82 input su 82, zero differenze** [MISURATO, §A.1-A.2].
2. 🟢 **Merito OOS pieno sulla carta**: PF **1,39709** su **193 posizioni** (270 deal), DD equity **7,2328%** a 1%
   [MISURATO, rifatto a mano dal per-trade al centesimo, §B.4]. 🔴 **Ma quell'OOS NON è fuori campione per
   `InpRangeMinutes`/`InpBufferPoints`**: la regione 35-45 è stata **scelta guardando la stessa finestra**
   (`REFERTO_FASE_D_C8.md` r.69-73, 06/08). L'unico campione davvero indipendente è il forward.
3. 🔴 **Rischio alla taglia di volo**: DD equity @2,00% = **14,47%** [DERIVATO] / **14,14%** [misurato diretto, R239b]
   contro il muro statico 10% — noto dal 20/09, firma di Claudio, non di questa scheda.
4. 🟠 **Stress dei costi → FRAGILE** (criteri congelati): a **+25%** di spread con slippage 2 punti PF **1,0730**
   (≥ 1,00), a **+50%** PF **1,0451** (< 1,10). Il margine vero: lo slippage massimo che tiene PF ≥ 1,10 a +50% è
   **1,5 punti indice** per deal; il campo BCM reale ha misurato **−0,1 punti** mediani all'ingresso e **0,41** medi
   sugli stop (n=7) [MISURATO, §C.3]. 🔴 **Il FRAGILE viene TUTTO dall'ipotesi dei 2 punti**: con lo slippage
   **misurato** (0,41 su ogni deal, ingresso compreso) a +50% il PF è **1,268** (sopra 1,10); con **1,7** (il massimo
   misurato) su ogni deal è **1,085** [DERIVATO, stesso script, §C.3]. Il verdetto congelato resta FRAGILE.
5. 🟠 **Orologio**: su FTMO la sedia arma **sempre** all'apertura Xetra; il suo backtest d'inverno armava **un'ora
   prima**. La cella "inverno alla cash" è **[NON MISURATO]** (R246o/p pronti, non girati) [§A.3, §B.6].
6. 🟢 **In campo FTMO ha fatto quello che il contratto dice**: 3 ordini (dal giornale Esperti, riga stampata dall'EA
   **dopo** un `BuyLimit` riuscito, §D.1), 2 riempiti (+69,66 e −1.552,80 EUR, dai referti degli stop),
   taglia 2,0% esatta su tutti e tre, slittamento sullo stop 0,65 punti [MISURATO, §D]. Anomalia vera: la **raffica
   di `modify` rifiutate** del trailing (24 e 25/09), lontana dal tetto FTMO delle 2.000 richieste.

---

## A. 🪪 IDENTITÀ E PARAMETRI OPERATIVI

### A.1 Sorgente e binario

| cosa | valore | fonte | etichetta |
|---|---|---|---|
| sorgente a HEAD | `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`, `#property version "1.01"` (r.27), **2885 righe**, ultimo commit `99f58562` (21/09, "Filtro dello spazio") | `git log` / `wc -l` al 28/09 | [MISURATO] |
| binario sul grafico FTMO | **`CLAU12_DAX_Apertura_EU`** (copia rinominata), sorgente in `C:\FTMO` **1.01 / 2426 righe / GUARD SI / compilato 2026-09-20 16:58** | `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260928_033005.log` r.210 (decodifica utf-8-sig) | [MISURATO] |
| pin del binario | **`9fca63d9`** (19/09, "Toppa per ticket"), 2425 righe = 2426 − 1 | `report/SCHIERAMENTO_FTMO_2026-09-20.md` §5.1; `report/GUARDIAN_SEI_SEDIE_2026-09-24.md` r.172 | [MISURATO per numero di righe, **non** per impronta byte] |
| scarto campo ↔ HEAD | **+460 righe a HEAD, 0 tolte** (`git diff 9fca63d9 HEAD`): `5d52a456`/`bfacc1fd`/`99f58562` del 21/09 (filtro dello spazio). L'interruttore è **`InpSpaceMode` r.395, default `ABTG_SPACE_OFF`**: a OFF nessun handle creato e nessun calcolo; `InpSpaceMinR`/`InpSpaceMaxR` r.397-398 (default 0) contano solo a modo ATTIVO — **NON in campo** | `git log` / `git diff` | [MISURATO] |
| stesso EA sul 100k | `C:\Program Files\BCM Markets MT5 Terminal -V3`: 1.01 / **2361 righe** / compilato 19/08 23:09 (= vintage `d83c1960`, pre-toppa per ticket) | `CODA_06_..._20260928` r.378 | [MISURATO] |
| `ABTG_DAX_Apertura_EU.mq5` in `C:\FTMO` | presente, **senza `.ex5`** — non è quello che gira | `CODA_06` r.183 | [MISURATO] |

📌 Nota: `report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` misura il terminale **piccolo** `50503392`, non FTMO: su
FTMO il binario è allineato al pin del 19/09. Tutte le righe di codice citate sotto sono **al pin `9fca63d9`**
(estratto con `git show 9fca63d9:mql5/Experts/ABTG_DAX_Apertura_EU.mq5`), con la riga a HEAD tra parentesi quando serve.

### A.2 Il preset che vola, e la prova che è quello caricato

- File: `mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` (82 input).
- 🟢 **Contro-esempio eseguito**: diff input per input fra il preset e il blocco `CLAU12_DAX_Apertura_EU` del `.chr`
  vivo in `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260928_033005.log` r.1794 (`chart01.chr`,
  modificato il **25/09 20:47**, attacco della `770105`): **82 su 82, zero differenze** [MISURATO].
- Simbolo / TF: **`GER40.cash` M5** su FTMO (in backtest `D30EUR` M5 BCM). `Digits=2`, `Point=0,01` su **tutti e due**
  i broker: ogni input in punti vale lo stesso numero (`report/LE_UNITA_NEI_PRESET_VIVI_2026-09-23.md` §1.1) [MISURATO].

| gruppo | input vivi (preset FTMO) | lettura |
|---|---|---|
| sessione | `InpSessionHour=10` · `InpSessionMin=0` · `InpRangeMinutes=35` · `InpCloseHour=19` · `InpCloseMin=30` · `InpCloseAtEnd=true` · `InpOneTradePerDay=true` · `InpMaxPosSimbolo=0` | ora **server FTMO** (§A.3) |
| ingresso | `InpEntryMode=2` (RETEST) · `InpRangeMode=0` (range d'apertura) · `InpBufferPoints=500` (**5,00 idx**) · `InpRetestOffsetPts=200` (**2,00 idx**) · `InpPendingExpiryMin=120` · `InpAllowLong=true` · **`InpAllowShort=false`** · `InpAllowReverse=false` | solo long |
| filtri | EMA / Supertrend / Supertrend3 / correlazione / VWAP / volumi / ATR / news / numeri tondi: **tutti `false`** · `InpMaxSpread=0` · `InpMinRangePts=0` · `InpMaxRangePts=0` · `InpMinStopPts=0` (quindi `InpSkipIfTight=true` è **inerte**) | **nessun filtro acceso** |
| rischio | **`InpRiskPercent=2.00`** · `InpSLMode=0` (stop di range) · `InpUsaGuardian=true` | taglia = firma di Claudio |
| uscita | `InpTP1_R=1.0` · `InpTP1_ClosePct=50` · `InpBreakevenAtTP1=true` · `InpBEatR=0` · `InpUseTrailing=true` · `InpTrailStartR=0` · `InpTrailMode=1` (PREVBAR) · `InpTrailTF=5` (M5) · `InpTrailFixedPts=410` (**inerte**, vale solo con `TrailMode=2`) | |
| altro | `InpMagic=770101` · `InpCorrSymbol=US500.cash` (inerte, correlazione spenta) · `InpVerbose=true` | |

Differenze **preset FTMO ↔ cella di contratto R47a** (`aperture_r47/..._OOS_r47a.csv` r.2), rifatte input per input:
`InpSessionHour` 8→10 e `InpCloseHour` 17→19 (rimappatura oraria), `InpRiskPercent` 1→2,00, `InpMagic`,
`InpCorrSymbol` (inerte), più `InpUsaGuardian` e `InpAllowReverse=false` che il CSV non ha (default inerte). **Nient'altro**
[MISURATO; stessa conclusione di `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.79].

### A.3 🕰️ L'ora di sessione — server FTMO e ora italiana

FTMO = **ora italiana +1 tutto l'anno** se segue il calendario europeo (`docs/REGOLAMENTO_FTMO_2026-08.md` r.130:
GMT+2 inverno / GMT+3 estate). BCM (dove gira il backtest) = **UTC+1 fisso** (`report/OROLOGIO_BCM_2026-09-24.md`).

| evento | server FTMO | ora italiana | nel backtest BCM (08:00 server) |
|---|---|---|---|
| inizio range | **10:00** | **09:00** = apertura Xetra, tutto l'anno | estate 09:00 IT (= cash) · **inverno 08:00 IT = un'ora PRIMA di Xetra** |
| fine range / RETEST armato | 10:35 | 09:35 | idem, +35' |
| sorveglianza della rottura | fino alle 19:30 (nessun'ora limite per armare, `MonitorRetest` r.1465) | fino alle 18:30 | |
| vita del LIMIT | 120' dal piazzamento (r.1475) | | |
| chiusura forzata | **19:30** (r.673 → `EndOfSession` r.2098, per ticket r.2107) | **18:30** (dopo la chiusura Xetra 17:30 IT: la posizione vede l'apertura USA 15:30 IT e i dati delle 10:00 ET = 16:00 IT) | 17:30 BCM |

🔴 **Classe del 24/09, qui morde**: d'inverno la sedia FTMO arma **alla cash**, il backtest d'inverno armava **un'ora
prima**. **Settimana 26-30/10/2026**: se FTMO seguisse il calendario USA (ipotesi B di
`report/IL_CONFINE_DEL_GIORNO_2026-09-23.md` §4.1), la sedia armerebbe **un'ora prima di Xetra** per cinque sedute;
col calendario UE no (`OROLOGIO_BCM` §5.3). Quale dei due valga è **[NON MISURATO]**: una lettura dell'ora
dell'ultima candela M1 contro UTC, a terminale FTMO acceso, il 26/10.

### A.4 🔧 Gestione, letta nel codice (pin `9fca63d9`)

| pezzo | cosa fa | riga |
|---|---|---|
| range | massimo/minimo della finestra 10:00-10:35 server (`ComputeLevels` → `ComputeRangeWindow`) | r.973-992 |
| armo | `ArmRetest`: niente filtri attivi; `SpreadOK()` sempre vero con `InpMaxSpread=0` (r.2191-2195) | r.1431-1455 |
| rottura | `ask >= rangeHigh + buffer(5,00)` → **BUY LIMIT** a `rangeHigh − 2,00` | r.1471-1488 |
| stop | `sl = rangeLow − 5,00` (stop di range: **stop = range + 3,00 idx**) | r.1489 |
| taglia | `CalcLotByRisk`: 2,00% del **saldo**, `MathFloor` sullo step | r.1791-1828 |
| Guardian | `ABTG_GuardiaIngresso` **prima** del `BuyLimit` (pausa B1 + cap C1, solo al piazzamento: classe 645) | r.1503-1504 |
| TP dell'ordine | `entry + 3R` (`TpTotalR` = `InpTP1_R × 3`) | r.1621-1627 |
| parziale | 50% a **+1R** (`PositionClosePartial`) | r.1899-1917 (HEAD r.2377) |
| pareggio | stop a `openP` al 1° obiettivo, anche se la parziale non parte | r.1931 (HEAD r.2391) |
| trailing | minimo della candela **M5 precedente**, solo se `> sl` **e** `> openP`; arma subito (`TrailStartR=0`) | r.1985-1987, r.2001-2004 (HEAD r.2446, r.2461) |
| un ciclo al giorno | guardia reload-safe dallo storico deal | r.628-660 |
| fine sessione | cancella i pendenti e chiude **per ticket** (toppa 19/09) | r.2098-2108 |

---

## B. 📊 VALIDAZIONE ABTG (G0 → G1 → OOS)

### B.1 La tavola dei numeri (cella di contratto, `D30EUR` M5, **tick reali**, deposito 100.000, rischio 1,00%)

| misura | IS 2024.09.26 → 2025.06.09 | OOS 2025.06.10 → 2026.06.30 | fonte e data | etichetta |
|---|---:|---:|---|---|
| **n** | **132 posizioni** (175 deal) | **193 posizioni** (270 deal) | CSV `aperture_r47/..._r47a.csv` r.2; posizioni contate su `R246/PERTRADE/..._794613.csv` (IS) e `aperture_r47/..._772501.csv` (OOS) | [MISURATO] |
| **PF** | **1,12634** | **1,39709** (deal) · 1,39728 (posizioni) | idem | [MISURATO] |
| **DD equity** | 5,4362% | **7,2328%** | idem | [MISURATO] |
| DD a saldo chiuso | — | 6,2516% | per-trade `772501` (script §C) | [MISURATO] |
| **win rate** (posizioni) | 75,8% | **74,1%** | per-trade | [MISURATO] |
| **expectancy** | +28,71 EUR/pos (~0,029 R) | **+93,42 EUR/pos** (~0,093 R) | per-trade; R ≈ 1% del saldo | [DERIVATO] |
| media vincente / perdente | +337,82 / −937,27 | +443,44 / −926,18 | per-trade | [MISURATO] |
| peggior giornata | −1,0194% | −1,0780% | CSV r.2 | [MISURATO] |
| serie perdente max | — | 3 posizioni | per-trade | [MISURATO] |
| **DD @2,00%** | 10,87% | **14,47%** (lineare) · **14,14%** (misurato diretto, R239b) · 14,50% (R201A a 80.000 ×2) | `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.63; `IL_DD_DELLE_SEI_SEDIE_2026-09-24.md` r.71, r.109 (CSV di R239 **non in repo**) | [DERIVATO] / [MISURATO fuori repo] |
| frequenza promessa | — | **0,699 op/giorno** | `CONTRATTI_...` r.63 | [DERIVATO] |
| regime | 9,1 mesi (lo storico BCM parte il 26/09/2024) | **un solo regime (toro)** | `CONTRATTI_...` r.63 | [DERIVATO] |

### B.2 Contro i criteri — le due unità di misura, accanto

| criterio | di casa | esito | del briefing | esito |
|---|---|---|---|---|
| n per il merito | ≥ 150 posizioni | 🟢 OOS 193 · 🔴 **IS 132** (merito IS sospeso, Emendamento A) | n ≥ 30 (≥ 60 per il DD) | 🟢 tutte e due le finestre |
| PF | ≥ 1,10 IS **e** OOS | 🟢 1,126 / 1,397 (l'IS **al filo**: +0,026) | PF < 1,10 = degrado | 🟢 nessun degrado |
| DD alla taglia di volo | entro il muro 10% statico | 🔴 **14,47% / 14,14%** (dal picco: il muro FTMO si misura dal saldo iniziale, `CONTRATTI` §10) | — | — |
| selezione | centro dell'altopiano, mai il picco | 🟠 **bordo nel C8; sull'asse R35 è il MASSIMO OOS** (cresta di due celle 35-40), non un centro (§B.3) | — | — |
| OOS vero | finestra mai usata per scegliere | 🔴 **NO per range e buffer** (§B.3) | — | — |

### B.3 🏔️ Altopiano: la cella in campo è centro o picco?

**Il round che l'ha scelta** è il walk-forward del 05-06/08 (`backtest_pipeline/risultati_archivio/Walkforward_Aperture/`,
FASE A geometria, FASE D retest C8, FASE E riempimento C11, **tick reali**), finestre IS 2024.09.26→2025.06.30 e OOS
2025.07.01→2026.06.30 (`walkforward_aperture.ps1` r.130-131 al commit `7af68e09` del 06/08).

- **Range 35**: il blocco positivo in OOS è **35-45** (8/8 celle, `report/DIARIO.md` r.54) e il centro dichiarato
  era **range 40** (`DIARIO.md` r.53, C8). 👉 **La cella viva sta sul BORDO sinistro, non al centro.** Il sorgente lo
  dice da solo: `#define ABTG_DEF_RANGE_MIN 35 // 06/08: era 15. Fuori campione 8 celle su 8 in utile con 35-45`
  (r.84). Nella griglia C8 (`DAX_D_retest_{IS,OOS}.csv`, due lati, TP1 0,5R senza parziale: **un'altra gestione**) la
  cella 35/500 fa IS **0,999** e OOS **1,198**.
- **Buffer 500**: "centro dell'altopiano" (r.89 del sorgente; C8). 🟢
- **Offset 200**: C11 (`REFERTO_FASE_E_C11.md`): range 35 positivo a tutti e quattro i livelli, crescita monotona
  (PF 1,107 → 1,176) (`DIARIO.md` r.52). 🟢 non è un picco.
- **R35** (`risultati_prove/aperture_r35/`, gestione viva, deposito 10.000, rischio 1%): IS 25-35 positivo
  (1,146 / 1,207 / **1,131**), buco a 40 (0,934), di nuovo positivo 45-60 (1,031 / 1,264 / 1,162 / 1,314), buco anche
  a 20 (0,998): **l'IS è frastagliato, non disegna un altopiano**. OOS: **35 = massimo dell'asse (1,415)**, 40 = 1,405,
  i vicini 30 = 1,101 e 45 = 1,090. 👉 Sull'asse R35 la cella viva è la **cima di una cresta di due celle (35-40)**,
  cioè il **picco OOS**, non il centro di un altopiano: la regola di casa ("mai il picco") qui morde.
- **`InpTP1_R` 1,00**: in R202B (0,25-1,00) è il massimo in IS (1,127) **e** in OOS (1,395), ma è il **bordo destro della
  griglia**: il centro non è noto. `R208b` (TP1_R oltre 1) è pronto e non girato (`ALZARE_IL_PF_2026-09-22.md` r.417).
- **`InpBEatR` 0**: R201A (0-0,90): lo 0,15 è il picco (OOS 1,516) con vicino 0,30 = ultimo — **non selezionabile**
  (`IL_DD_DELLE_SEI_SEDIE` r.269); lo 0 in campo sta in un blocco regolare 0,45-0,90 (OOS 1,34-1,38). 🟢

🔴 **Il punto che pesa più del numero**, scritto dagli stessi referti del 06/08: *«la zona 35-45 è stata scelta guardando
l'OOS della FASE A. Confermarla con l'OOS della FASE D non è una verifica fuori campione — è lo stesso periodo»*
(`REFERTO_FASE_D_C8.md` r.69-73). La finestra OOS di contratto (2025.06.10→2026.06.30) **contiene** quella OOS del
walk-forward (2025.07.01→2026.06.30). 👉 **Il PF OOS 1,397 è "fuori campione" per il motore, ma NON per la scelta di
range e buffer.** `CONTRATTI_DELLE_SEDIE_FTMO` r.63 scrive "✅ OOS vero": sulla lettera delle finestre sì, sulla
selezione no. La verifica indipendente rimasta è il **forward** (§D) e la **finestra IS** (PF 1,126 su 132).

### B.4 🧪 Contro-esempio (rifatto a mano da un CSV vero)

Dal per-trade `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv`:
somma dei `net_profit` positivi / somma dei negativi = **1,39709**, netto **+18.029,58**, 270 righe, **193**
`position_id` distinti → **identici al centesimo** alla riga 2 di `..._OOS_r47a.csv` (PF 1,39709, Profit 18.029,58,
Trades 270). Seconda prova: stagioni UE sulla stessa finestra → estate **107 posizioni PF 1,274**, inverno **86 PF 1,482**,
identici a `REFERTO_R246_2026-09-24.md` §5.2 ("estati d0 … 1,274 (B, 107)", "inverni … 1,481 (25/26, 86)") [MISURATO].

### B.5 📜 La storia del contratto (perché i numeri vecchi non valgono)

- 31/08 `DIAGNOSI_770101_SIZING_2026-08-31.md`: la sedia perdeva il 2% a stop pieno per il **default compilato
  `ABTG_DEF_RISK 2.0`**; oggi il default è 1.0 (r.90) e su FTMO il 2,00 è **scritto nel preset**, quindi "Ripristina"
  non può cambiare taglia.
- 11/09 `CONFLITTO_DD_770101_2026-09-11.md`: il vecchio DD 10,60% era **R83 con il lato corto acceso**, un'altra
  sedia. La cella viva è long-only.

### B.6 ❄️ Stagione e orologio (dove sta il merito)

| casella (finestre A+B, 2024.09.27 → 2026.06.30) | PF | posizioni | fonte |
|---|---:|---:|---|
| d0 estate (alla cash = **come FTMO**) | **1,108** | 157 | `REFERTO_R246` §5.2 [MISURATO] |
| d0 inverno (1h prima di Xetra = come il backtest) | 1,389 | 168 | idem |
| **-1h estate** (1h prima di Xetra) | 🔴 **0,774** | 184 | idem — DD saldo 14,05% |
| inverno **alla cash** (quello che FTMO farà da fine ottobre) | **[NON MISURATO]** | — | R246o/p, file prova pronti (`REGISTRO_TEST.md` r.62-63) |

👉 Sulla casella che FTMO gira d'estate il PF è **1,108 su 157**: sopra 1,10 **per 0,008**. Il verdetto R246 sulla
frequenza è **OROLOGIO** (pieno, n ≥ 150): d'inverno alla cash ci si aspettano **meno ingressi** del contratto
[INFERITO da R246 §7.1].

---

## C. 💸 STRESS E COSTI

### C.1 Cosa esisteva già

| misura | numero | fonte | etichetta |
|---|---|---|---|
| **latenza del tester** 0/50/100/500 ms (cella viva, 0,65%, 10.000) | PF OOS **1,41105 → 1,41755**, DD 4,3501 → 4,3139: **nessun degrado** (entra con un LIMIT) | `risultati_archivio/ritardo_r119b_csv/` + `REFERTO_RITARDO_R119.txt` (07/09) | [MISURATO] |
| costo extra per posizione (MC congiunto) | spread x1,5 **0,0143 R** · x2 **0,0286 R** · ingresso +1 pt 0,0168 R · +3 pt 0,0504 R | `MC_STRESS_CONGIUNTO_2026-09-28.md` §1 | [DERIVATO] |
| spread di base all'ora d'ingresso | `D30EUR` **1,70** (archivio tick, P95 2,70) · `GER40.cash` FTMO all'apertura **1,23** (P95 1,33, 1 giornata) | `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §3.2; `SPREAD_APERTURA_FTMO_2026-09-21.md` §1 | [MISURATO] |
| commissione | **0,00** (302 deal indici BCM; FTMO "swap e commissioni 0,00") | `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.186; `TERZO_STOP_FTMO_2026-09-25.md` r.13 | [MISURATO] |
| stop del tester su `D30EUR` in sessione | P99 8,25 punti, max 25,8 | `MC_STRESS_CONGIUNTO` §1 (da `MISURA_SLIPPAGE_2026-09-05.md` §3.1) | [MISURATO, altra sedia] |
| stress di spread +25/+30/+50% **per questa sedia** | **mai fatto prima di oggi** | — | → §C.2 |

### C.2 Lo stress, fatto oggi a costo zero (criteri: §C.0 in fondo, committati prima)

```bash
python3 backtest_pipeline/stress_pertrade.py --pertrade backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv --k 0 --C 1 --punto 1.0 --deposito 100000 --rischio 1.0 --base-spread 1.70 --base-spread 1.23 --taglio 2026.01.01 --attesa-pf 1.39728 --attesa-dd 6.252
```

Il gradino **+30%** (briefing) è calcolato importando le stesse funzioni (`scenario`, `giornata_e_serie`) senza
modificare lo script. Controesempi dello script: **degrado zero = PF 1,3973 / DD 6,2516% → OK**; +1000% → PF 0,37
**OK**; monotonia **OK**; `q` misurato **1,0000** su 17 ancore. Autotest dello script: **PASS**.

**Scala sulla base 1,70** (PF in **posizioni**, n = 193 in ogni riga; slippage in **punti indice** su ingresso **e** su
ogni deal d'uscita):

| spread | slip 0 | slip 1 | **slip 2 (decide)** | DD chiuso @1% (slip 2) | DD ×2 [DERIVATO] | peggior giornata ×2 (slip 2) |
|---|---:|---:|---:|---:|---:|---:|
| base | 1,3973 | 1,2437 | **1,1016** | 8,20% | 16,41% | 2,57% |
| +25% | 1,3638 | 1,2125 | **1,0730** | 8,46% | 16,92% | 2,62% |
| +30% | 1,3572 | 1,2064 | **1,0674** | 8,51% | 17,02% | 2,63% |
| +50% | 1,3308 | 1,1819 | **1,0451** | 8,72% | 17,44% | 2,67% |
| +100% | 1,2661 | 1,1222 | **0,9910** | 9,26% | 18,52% | 2,78% |

A slippage zero il DD chiuso @1% è **6,25%** (×2 = **12,50%**) e la peggior giornata **1,078%** (×2 = 2,16%).
Sulla base FTMO **1,23**: slip 2 → base 1,1016 · +25% **1,0809** · +30% 1,0768 · +50% **1,0605** · +100% **1,0206**.

### C.3 ⚖️ Verdetto contro i criteri congelati

- **MERITO → 🟠 FRAGILE.** A +25% con slippage 2 PF **1,0730** (≥ 1,00: non BOCCIATO); a +50% **1,0451** (< 1,10:
  non PASS). Anche sulla base FTMO 1,23: +50% → 1,0605. **Decide Claudio.**
- **Quanto margine reale ha** (le soglie dello script sono calcolate per bisezione): a +50% lo slippage massimo che
  tiene PF ≥ 1,10 è **1,5 punti indice** per deal (1,7 sulla base 1,23); a +100% quello che tiene PF ≥ 1,00 è **1,9**.
  🟢 **Il campo misurato sta molto sotto**: `SlippageLogger` sul reale BCM `10105439` (stessa sedia, `D30EUR`, 08-24/09,
  `CODA_10_slippage_20260928_033005.log`): ingressi LIMIT **n=7, mediana −0,1 punti, media +0,06, massimo +0,7**;
  uscite su stop **n=7, media 0,41, P95/massimo 1,7** [MISURATO, n piccolo, **BCM e non FTMO**]. Su FTMO lo stop del
  25/09 ha slittato **0,65 punti** (`TERZO_STOP_FTMO_2026-09-25.md` §1, n=1). 👉 Il gradino che decide applica
  **2 punti su ogni deal** (4 punti per andata e ritorno): è lo scenario pessimista dichiarato, non il campo.
  🔴 **Lo stesso script allo slippage MISURATO** (`scenario` importato, stessa scala; lo slippage si applica a ingresso
  **e** a ogni uscita, quindi 0,41 anche sull'ingresso LIMIT che ne ha misurati 0,06 di media) [DERIVATO]:

  | spread (base 1,70) | slip 0,41 (media stop BCM) | slip 1,7 (massimo misurato) | slip 2 (decide) |
  |---|---:|---:|---:|
  | base | 1,3331 | 1,1430 | 1,1016 |
  | +25% | 1,3005 | 1,1136 | 1,0730 |
  | +50% | **1,2683** | **1,0847** | **1,0451** |

  👉 **Il verdetto FRAGILE dipende interamente dall'ipotesi**: al campo medio la sedia sta sopra 1,10 con margine,
  al massimo misurato su ogni deal no. Lettura **informativa**: il criterio congelato decide a 2 punti e **non si
  cambia dopo i numeri**. Con n=7 BCM (non FTMO), il campo non basta a scegliere fra le due colonne.
- **RISCHIO**: il DD a saldo chiuso ×2 sta **sopra il 10% in OGNI gradino, base compresa** (12,50% a slip 0) — è lo
  stesso fatto del §B.2 (DD equity @2% 14,47%), non una scoperta dello stress. La peggior giornata della sedia **da
  sola** resta sotto la pausa del Guardian (3,5%) in tutta la scala (max 2,78%) [DERIVATO]. Le giornate cattive vere
  sono quelle in cui scattano **più sedie** (§D.3).
- **Frontiera del costo `stop ≥ 40 × (spread + comm.)`** — stop per posizione ricostruito dal lotto (classe 846,
  `--passo 0.1`): **mediana 77,58 idx** (P10 37,75, min 21,90) [DERIVATO dal per-trade]. Mediana/spread = **45,6×**
  a 1,70 e **63,1×** a 1,23: 🟢 **passa alla mediana**. Sotto 40×: **75/193 (38,9%)** a 1,70, **44/193 (22,8%)** a 1,23.
  Coerente in ordine di grandezza con la stima di `IL_COSTO_DEL_DAX_RISOLTO_2026-09-24.md` (~86,5 idx, ~50×).

### C.4 Qualità dei dati e dove sta il verdetto a tick

- Contratto R47a: **tick reali** (Modello 4) su `D30EUR` BCM (`CONTRATTI_...` §1). Il walk-forward di selezione del
  06/08 era **a tick reali** (`REFERTO_FASE_B_C5.md` r.3, `REFERTO_FASE_E_C11.md` r.3).
- 🔴 La serie `GER40.cash` di FTMO **non è mai stata testata**: tutto viene da `D30EUR` BCM (stesse unità, spread
  FTMO più stretto all'apertura). Il per-trade FTMO **non è in repo** (`IL_PERTRADE_FTMO_ESISTE_2026-09-23.md` §4).
- **Non coperto** (dichiarato nei criteri): ingressi che cambiano con lo spread, requote, rifiuti, gap, esecuzione vera FTMO.

---

## D. 🔎 ANOMALIE IN CAMPO

### D.1 Le operazioni su FTMO `541452707` (21/09 → 28/09 03:30)

| giorno | ordine (ora IT del giornale → **server FTMO** +1) | esito | taglia | fonte |
|---|---|---|---|---|
| 21/09 | nessuna posizione chiusa (il per-trade FTMO parte dal 22/09 14:45) | — | — | `CODA_12_..._20260928` r.16-20 [MISURATO]; giornale del 21/09 non letto da `CODA_09` [NON MISURATO] |
| 22/09 | BUY LIMIT 25.630,54 SL 25.462,54 lot 9,52 alle 11:43 IT (**12:43 FTMO**) | **non riempito** | 168,00 pt × 9,52 = 1.599 € = **2,00%** di 80.000 | `CODA_09_..._20260923` §`C:\FTMO`; non riempito [DERIVATO: `dayLoss 2,20%` = solo lo stop EMA200, e le 2 posizioni del 22/09 nel per-trade sono della `771531`] |
| 23/09 | nessuna riga d'ordine | — | — | `CODA_09_..._20260924` [MISURATO] |
| 24/09 | BUY LIMIT 25.392,54 SL 25.249,54 lot 10,70 alle 15:17 IT (16:17 FTMO), riempito ~15:35 IT | **+69,66 €** (stop salito sopra l'ingresso dal trailing) | 143,00 × 10,70 = 1.530 € = 2,00% di 76.573,86 | `CODA_09_..._20260925`; `RESOCONTO_2026-09-24.md` r.16 |
| 25/09 | BUY LIMIT 25.468,24 SL 25.391,24 lot 19,90 alle 10:28 IT, riempito **12:27:10 FTMO** | 🔴 **−1.552,80 €** allo stop alle **17:02:18 FTMO** (= 10:02 New York); slittamento **0,65 pt** | 77,00 × 19,90 = 1.532 € = 2,00% di 76.643,52 | `TERZO_STOP_FTMO_2026-09-25.md` §1 |
| 26/09 → 28/09 03:30 | nessuna riga d'ordine | — | — | `CODA_09` 27 e 28/09 [MISURATO] |

- **Da dove vengono gli ordini (classe 896)**: il giornale Esperti **non** vede gli ordini riusciti di `CTrade`
  (stampa solo gli errori), ma questa sedia stampa **da sé** `BUY LIMIT (retest) @ ... lot ...` **solo dopo** un
  `BuyLimit` riuscito (pin r.1506; il fallimento stampa "fallito", r.1508) con `InpVerbose=true` nel preset e nel
  `.chr`. Quindi le righe d'ordine qui sopra sono ordini **piazzati**; i **riempimenti** vengono dai referti degli
  stop (`RESOCONTO_2026-09-24`, `TERZO_STOP_FTMO`), e le 6 posizioni del per-trade FTMO (`CODA_12` r.16-20) sono
  `771531` ×3, `770411` ×1 e questa sedia ×2 (`HEDGING_FRA_CONTI_2026-09-24.md` §4, `NOTTE_2026-09-28.md`)
  [MISURATO]. I giorni 24-25/09 del giornale sono **troncati** al tetto di 40 righe: un secondo ordine nello stesso giorno è
  escluso dal codice (`gBrokeHigh` si alza alla prima rottura, pin r.1481-1483, con ripristino al riavvio r.1448),
  non dal giornale.
- **Frequenza**: 2 riempimenti in 5 sedute (21-25/09) = 0,40 contro 0,699 promesse. **n = 2: non giudica niente**
  [DERIVATO].
- **Corsia RISCHIO (firma del 18/08)**: DD forward della sedia su FTMO = −1.483,14 € = **1,85%** di 80.000, contro il
  promesso **14,47%** → nessuna revisione dovuta [DERIVATO].
- **Il forward confrontabile**: 100k `50504263` (stessa cella, 0,65%) **17 posizioni, PF 3,00, +1.659,20 €**
  (11/08 → 24/09, `data/statements/trades_100k.csv`) [MISURATO]. **n = 17 < 30**: sotto la soglia del briefing, e
  sotto le 20 della corsia MERITO. Il piccolo `50503392` porta configurazioni miste (righe `BUY`/`SELL`/`RETEST BUY`
  con lo stesso magic) e non si confronta.

### D.2 Anomalie

1. 🟠 **Raffica di `modify` rifiutate (`invalid stops`)** il 24/09 (≥ 38 righe, ≤ ~93 stimate) e il 25/09 (tetto
   339 righe d'ordine nel giorno, 299 non stampate): il trailing PREVBAR propone uno stop **sopra il Bid** subito dopo
   il riempimento RETEST e lo ritenta a ogni tick (r.1985-1987: controlla `> sl` e `> openP`, **mai** `< Bid`)
   (`MODIFY_A_RAFFICA_FTMO_2026-09-25.md` §0-§2). 🟢 Lontano dal tetto FTMO delle **2.000** richieste/giorno; 🔴 il caso
   peggiore teorico con tre sedie Apertura nello stesso giorno è **≤ ~1.971** [INFERITO, stesso referto §2]. La
   correzione è un diff **non applicato** (firma di Claudio). Nel tester il rifiuto avviene uguale: il contratto non
   ne è falsato [INFERITO].
2. 🟠 **Lo stop del 25/09 alle 10:00 ET**: la sedia tiene la posizione fino alle 19:30 FTMO, quindi i dati USA delle
   10:00 ET le cadono dentro ogni giorno. Nel backtest **0 stop su 0,24 attesi** in quella finestra, ma il campione
   **non ha potenza** (escluso solo un effetto oltre ~12,6×); il mercato un grappolo alle 10 ET ce l'ha (16 contro
   6,98 attesi, P 0,001, su un'altra popolazione) (`ORA_10ET_SULLA_770101_2026-09-25.md` §0) [MISURATO/DERIVATO].
3. 🟢 **Riavvii**: nessuno documentato fra 22 e 28/09; il `.chr` è stato riscritto il 25/09 20:47 (attacco della
   `770105`) e i valori sono rimasti **uguali al preset** (§A.2).
4. 🟢 **Orario di volatilità**: d'estate la sedia arma all'apertura Xetra come il backtest d'estate. Il rischio
   d'orologio parte dal **26/10** (§A.3).

### D.3 Sovrapposizioni sullo stesso indice

- **`770105` (DAX short, stesso binario `CLAU12_DAX_Apertura_EU`, magic diverso, viva dal 25/09 20:47)**: sulla
  finestra B le due sono **LEGATE** (lift **1,66**, Fisher p **0,020**), ma **non** perché operino le stesse mattine
  (127 giornate comuni contro 125 attese): quando scattano **tutte e due**, la `770101` perde il **32%** delle volte
  contro il **9%** quando scatta da sola. Con la `770105` le giornate di portafoglio sopra il 4,5% passano da **4 a 7**
  (`DIPENDENZA_NELLO_STRESS_2026-09-28.md` §0 punto 3, §1, §5) [MISURATO]. 🔴 Con Bonferroni su 33 test il legame
  non sopravvive: è un **indizio da rimisurare**, non un legame dimostrato (stesso referto).
- `770101` × `771531` (EMA200 Dow): lift 1,66, p **0,0526** — nessun legame al criterio, sul filo (idem).
- `770101` × `770411` (MaxMin DAX short): lift 0,94, nessun legame (idem, tabella r.225).
- La **chiusura per ticket** (toppa del 19/09) è nel pin in campo: la fine sessione della `770101` non chiude la
  posizione della `770105` sullo stesso `GER40.cash` (r.2098-2108) [MISURATO nel codice].
- **Cap del Guardian**: con `770101` + `770105` aperte insieme il rischio aperto è 4,00% = il cap C1 in campo (4,00):
  il cap scatta solo su ordini inviati **dopo**, non sui pendenti già piazzati (classe 645, `TERZO_STOP_FTMO` §3).

---

## E. 🧭 PROPOSTE

**La condizione del briefing non è soddisfatta**: PF OOS **1,397 ≥ 1,10** e **nessun degrado misurato in campo**
(n = 2 su FTMO, 17 sul 100k con PF 3,00). 👉 **Nessuna proposta di modifica.**

Restano **misure mancanti** (non proposte), ordinate per quanto avvicinano la sedia al 1° ottobre:

| buco | perché conta | via più corta | costo macchina |
|---|---|---|---|
| **inverno alla cash** (cella che FTMO girerà dal 26/10) | il merito di contratto è per metà invernale e **armato un'ora prima** | **R246o/p** (file prova pronti, pin `782d7280`, PASS strato 2) sul **PC di backtest** | ~5 min per tutte le R246m-r (18 passate) |
| **un OOS non consumato dalla selezione** | §B.3: il PF 1,397 non è fuori campione per range/buffer | tempo di forward (nessuna scorciatoia: lo storico BCM parte dal 26/09/2024) | zero macchina, settimane di campo |
| **`InpTP1_R` oltre 1,0** (la cella è al bordo) | centro dell'altopiano non noto | **R208b** (10 passate, pronto) | durata `[NON MISURATO]` su M5 tick |
| **slippage FTMO sulla sedia** | decide fra FRAGILE e PASS (§C.3) | accumulare il ledger dello `SlippageLogger` **su `C:\FTMO`** (oggi non c'è: `CODA_10` "GUARDATO e NIENTE") — è un gesto sul terminale FTMO, quindi **firma di Claudio** | zero macchina |
| **settimana 26-30/10** | quale calendario segue FTMO | una lettura ora-candela contro UTC il 26/10 | secondi |

Per completezza, **non proposta di questa scheda**: esiste già una firma istruita e pendente, `InpTP1_ClosePct` 50 → 0
(`r137c`: PF OOS 1,39709 → 1,49140, DD 7,2328 → 6,2719 a parità di 193 posizioni; `CONTRATTI_...` r.392,
`CELLE_MIGLIORI_GIA_MISURATE_2026-09-21.md` r.56). Resta di Claudio.

---

## ⚠️ Note sulle fonti indicate nel compito

- **R261** (`REFERTO_ROUND_CORTI_B_2026-09-27.md` §2) **non misura la `770101`**: è la versione LONG del box notturno
  `770411` (`ABTG_MaxMinNotte`, `D30EUR` M15). Non entra in questa scheda.
- `CACCIA_MECCANISMI_SEI_FAMIGLIE_2026-09-26.md` sta in `backtest_pipeline/caccia_strategie/`, non in `report/`: per il
  DAX d'apertura registra solo il **gap-fill** Xetra come **contro-misurato** (r.435).

---

## C.0 Criteri dello stress dei costi — CONGELATI PRIMA DEI NUMERI (commit `40a1a985`, testo invariato)

- **Cella**: ABTG_DAX_Apertura_EU, magic di misura della cella OOS di contratto (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §2),
  simbolo D30EUR (BCM) / GER40.cash (FTMO), M5, tick reali, deposito 100.000, rischio 1,00%.
- **Per-trade**: `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv` (solo deal d'uscita, OOS 2025.06.10 -> 2026.06.30).
- **Strumento**: `backtest_pipeline/stress_pertrade.py` (non modificato), `--k 0` (commissione indici misurata 0,0000
  su 302 deal BCM, `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.186; su FTMO "swap e commissioni 0,00",
  `TERZO_STOP_FTMO_2026-09-25.md` r.13), `--C 1` (q misurato dal file), `--punto 1.0` (1 punto INDICE),
  `--deposito 100000 --rischio 1.0`, `--taglio 2026.01.01`.
- **Spread di base**: 1,70. Stampato anche: 1,23 (GER40.cash FTMO all'apertura, SPREAD_APERTURA_FTMO_2026-09-21.md §1, 1 giornata).
- **Scala**: spread +0% / +25% / **+30% (briefing)** / +50% / +100% dello spread di base; slippage 0 / 1 / 2 punti
  indice su ingresso **e** su ogni deal d'uscita (pessimista: l'ingresso e' un LIMIT e nella realta' non slitta
  contro); sensibilita' 5 punti. Il +30% si calcola importando le funzioni dello script (nessuna modifica).
- **Gradino che decide**: slippage **2 punti** (scala severa: sedia d'apertura).
- **MERITO sotto stress** (PF in POSIZIONI):
  - **PASS**: a +50% di spread e slippage 2 il PF resta >= 1,10 (soglia di casa);
  - **FRAGILE**: PF >= 1,00 a +25% ma sotto 1,10 a +50% -> si scrive il margine, decide Claudio;
  - **BOCCIATO**: PF < 1,00 gia' a +25% con slippage 2.
- **RISCHIO sotto stress**: DD a saldo chiuso del per-trade x2 (scala lineare alla taglia di volo 2,00%,
  [DERIVATO], convenzione di casa) contro il muro statico 10% FTMO, e peggior giornata a saldo chiuso x2 contro
  il 5% giornaliero (e, per informazione, contro pausa 3,5% / taglio 4,5% del Guardian in campo). Un DD che sfonda
  un muro in QUALUNQUE gradino si scrive come fatto, a qualunque n. Il DD a saldo chiuso e' un limite INFERIORE
  del DD equity del tester (non vede il flottante).
- **Frontiera del costo**: quota di posizioni con stop < 40 x spread, stop per posizione ricostruito dallo
  script (classe 846), a ogni spread di base.
- **Controesempi obbligatori** (dallo script): degrado zero == PF e DD del per-trade ricontati a mano; +1000% ->
  PF < 1; monotonia del PF sui gradini.
- **Non coperto, dichiarato prima**: l'insieme degli ingressi che cambia con lo spread (un LIMIT con spread largo
  si riempie in giorni diversi), requote, rifiuti, slippage favorevole, gap, esecuzione vera FTMO.
- ⚠️ Il VERDETTO stampato dallo script usa soglie dell'ORO (`COLLAUDO_ORO_770402_LONG_CRITERI.md`): **non si
  legge**. Si legge solo contro le righe qui sopra.
