# 🇺🇸 SCHEDA AUDIT `770202` — ABTG_Dow_Apertura_US (EA 3.2 del briefing) — 28/09/2026

**Perimetro**: `report/audit_ea/00_PERIMETRO_AUDIT_2026-09-28.md` (commit `13f6036d`). Sedia **VIVA** su FTMO
**`541452707`** (`C:\FTMO`) al **2,00%** e sul 100k **`50504263`** (`... MT5 Terminal -V3`) allo **0,65%**.
**Sola lettura.** Nessun EA, preset, sedia o conto toccato; nessuna riga PowerShell; **nessuna taglia proposta**.
Criteri dello stress della sezione C **congelati e committati PRIMA dei numeri** (commit `40a1a985`, stesso file).

Etichette: **[MISURATO]** = letto/contato in un file del repo · **[DERIVATO]** = aritmetica dichiarata su numeri
misurati · **[INFERITO]** = ragionamento, non misura · **[NON MISURATO]** = buco dichiarato, con la via più corta.

---

## 0. 🎯 In sei righe

1. 🟢 **Il binario in campo è allineato a HEAD**: `CLAU12_Dow_Apertura_US` = pin `9fca63d9` = HEAD (2205+1 righe), e
   il `.chr` vivo su `C:\FTMO` coincide col preset FTMO **81 input su 81, zero differenze** [MISURATO, §A.1-A.2].
2. 🟠 **Merito OOS sulla carta, ma SOSPESO**: PF **1,27013** su **96 posizioni** (130 deal), DD equity **4,3941%** a 1%
   [MISURATO, rifatto a mano al centesimo]; IS PF 1,22247 su **56**. **Sotto 150 in tutte e due le finestre**: il
   merito non si giudica, il rischio sì.
3. 🔴 **La casella che FTMO gira d'estate è quella che perde**: nei mesi con l'ora legale USA (armo alla cash, come
   FTMO) PF **0,782 su 58 posizioni** (73 deal); nei mesi sfasati (armo un'ora prima) **1,663 su 38** [MISURATO,
   rifatto dal per-trade = i numeri di `CLAUDE.md`, che sono in **deal**]. Differenza **non dimostrata**: sui due anni
   A+B (84 estate contro 68 inverno) IC95 [−0,42 ; +1,86], p 0,15 (`IL_MERITO_E_D_INVERNO_2026-09-25.md` §0 punto 2,
   tabella r.138); **sul solo OOS 58/38 un intervallo non è stato calcolato** [NON MISURATO].
4. 🟠 **Stress dei costi → FRAGILE** (criteri congelati): +25% di spread con slippage 2 punti PF **1,0793**, +50%
   PF **1,0513**. Lo slippage massimo che tiene PF ≥ 1,10 a +50% è **1,3 punti**; l'unico stop vero misurato su
   `US30.cash` FTMO (sedia `771531`) ha slittato **7,83 punti** (n=1). E a +50%/slip 2 il DD a saldo chiuso ×2 tocca
   **10,07%** [DERIVATO]. Allo slippage **misurato altrove** il quadro cambia: 0,41 su ogni deal (media stop DAX BCM,
   altro simbolo) → +50% PF **1,174**; 7,83 solo sull'uscita delle posizioni in perdita → **1,095** (§C.3).
5. ⚪ **In campo FTMO: zero ordini** nei giornali completi del 22-23/09 (l'EA stampa **da sé** ogni `BuyLimit`
   riuscito o fallito con `InpVerbose=true`: l'assenza qui è una misura, classe 896 rispettata, §D.1), **zero posizioni**
   fino al 28/09 03:30. Sui BCM
   l'ultima operazione è del **28/08**: **20 sedute** di silenzio al 25/09 contro un record OOS di **23** → il
   **30/09** diventa una domanda nuova (`PERCHE_770202_E_MUTA_2026-09-19.md` §8) [MISURATO/DERIVATO].
6. 🟠 **`InpEmaSlow=50` su H4 non è mai stato misurato su questa cella** (0 file in repo), e la griglia H4 di FTMO
   (server UTC+3) legge una chiusura **due ore più recente** di quella del backtest BCM [DERIVATO, §A.3].

---

## A. 🪪 IDENTITÀ E PARAMETRI OPERATIVI

### A.1 Sorgente e binario

| cosa | valore | fonte | etichetta |
|---|---|---|---|
| sorgente a HEAD | `mql5/Experts/ABTG_Dow_Apertura_US.mq5`, `#property version "1.01"` (r.22), **2205 righe**, ultimo commit **`9fca63d9`** (19/09, "Toppa per ticket") | `git log` / `wc -l` al 28/09 | [MISURATO] |
| binario sul grafico FTMO | **`CLAU12_Dow_Apertura_US`**, sorgente in `C:\FTMO` **1.01 / 2206 righe / GUARD SI / compilato 2026-09-20 16:58** | `backtest_pipeline/coda/referti/CODA_06_quale_codice_gira_20260928_033005.log` r.211 (decodifica utf-8-sig) | [MISURATO] |
| pin del binario | **`9fca63d9` = HEAD** (2205 = 2206 − 1) | `report/SCHIERAMENTO_FTMO_2026-09-20.md` §5.1; `report/GUARDIAN_SEI_SEDIE_2026-09-24.md` r.173 ("🟢 0") | [MISURATO per numero di righe, **non** per impronta byte] |
| stesso EA sul 100k | `-V3`: 1.01 / **2148 righe** / compilato 19/08 23:09 (vintage `d83c1960`, pre-toppa) | `CODA_06_..._20260928` r.379 | [MISURATO] |
| `ABTG_Dow_Apertura_US.mq5` in `C:\FTMO` | presente, **senza `.ex5`** — non è quello che gira | `CODA_06` r.184 | [MISURATO] |

Le righe citate sotto sono **a HEAD = pin** (`mql5/Experts/ABTG_Dow_Apertura_US.mq5`).

### A.2 Il preset che vola, e la prova che è quello caricato

- File: `mql5/Presets/FTMO/ABTG_Dow_Apertura_US_770202_FTMO.set` (81 input).
- 🟢 **Contro-esempio eseguito**: diff input per input col blocco `CLAU12_Dow_Apertura_US` del `.chr` vivo in
  `backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260928_033005.log` r.1883 (`chart02.chr`, modificato il
  25/09 20:47): **81 su 81, zero differenze** [MISURATO].
- Simbolo / TF: **`US30.cash` M5** su FTMO (in backtest `U30USD` M5 BCM). `Digits=2`, `Point=0,01` su tutti e due i
  broker (`report/LE_UNITA_NEI_PRESET_VIVI_2026-09-23.md` §1.3) [MISURATO]. Quotato in **USD** su conto **EUR**: il
  valore per punto segue il cambio (`q` misurato dal per-trade: 0,841-0,864, mediana **0,8566**) [MISURATO].

| gruppo | input vivi (preset FTMO) | lettura |
|---|---|---|
| sessione | `InpSessionHour=16` · `InpSessionMin=30` · `InpRangeMinutes=35` · `InpCloseHour=19` · `InpCloseMin=30` · `InpCloseAtEnd=true` · `InpOneTradePerDay=true` · `InpMaxPosSimbolo=0` | ora server FTMO (§A.3) |
| ingresso | `InpEntryMode=2` (RETEST) · `InpRangeMode=0` · `InpBufferPoints=1000` (**10,00 idx**) · `InpRetestOffsetPts=400` (**4,00 idx**) · `InpPendingExpiryMin=120` · `InpAllowLong=true` · **`InpAllowShort=false`** | solo long |
| filtri | 🟠 **`InpUseEmaFilter=true`**, `InpEmaFast=1` (= la chiusura), `InpEmaSlow=50`, `InpFilterTF=16388` (**H4**) · Supertrend / correlazione / VWAP / volumi / ATR / news / numeri tondi: `false` · `InpMaxSpread=0` · `InpMinStopPts=500` (**5,00 idx**) con `InpSkipIfTight=false` (allarga lo stop, non salta) | un solo filtro vivo |
| rischio | **`InpRiskPercent=2.00`** · `InpSLMode=0` (stop di range) · `InpUsaGuardian=true` | taglia = firma di Claudio |
| uscita | `InpTP1_R=1.0` · `InpTP1_ClosePct=50` · `InpBreakevenAtTP1=true` · `InpBEatR=0` · `InpUseTrailing=true` · `InpTrailStartR=0` · `InpTrailMode=1` (PREVBAR) · `InpTrailTF=5` · `InpTrailFixedPts=410` (inerte) | identica alla `770101` |
| altro | `InpMagic=770202` · `InpCorrSymbol=US500.cash` (inerte) | |

Differenze **preset FTMO ↔ cella di contratto R47c** (`aperture_r47/..._OOS_r47c.csv` r.2), input per input:
`InpSessionHour` 14→16, `InpCloseHour` 17→19, `InpRiskPercent` 1→2,00, `InpMagic`, `InpCorrSymbol` (inerte),
`InpUsaGuardian` (assente nel CSV). **Nient'altro** [MISURATO; = `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.80].
🟢 Il floor `InpMinStopPts=500` è **inerte nei fatti**: lo stop più stretto ricostruito dal per-trade è 29,81 idx (§C.3).

### A.3 🕰️ L'ora di sessione — server FTMO e ora italiana

| evento | server FTMO | ora italiana | New York | nel backtest BCM (14:30 server, UTC+1 fisso) |
|---|---|---|---|---|
| inizio range | **16:30** | **15:30** | 9:30 (cash) | estate 9:30 NY · **inverno 8:30 NY = un'ora PRIMA** |
| RETEST armato + `bias` EMA calcolato | 17:05 | 16:05 | 10:05 | +35' |
| sorveglianza rottura | fino alle 19:30 | fino alle 18:30 | fino alle 12:30 | |
| chiusura forzata | **19:30** (r.613 → `EndOfSession` r.1929, per ticket r.1938) | 18:30 | 12:30 | 17:30 BCM |

🔴 **Classe del 24/09**: d'inverno la sedia FTMO arma **alla cash**, il backtest d'inverno armava **alle 8:30 NY**. E
**settimana 26-30/10/2026**: col calendario UE, FTMO arma alle **10:30 NY** (un'ora tardi) per cinque sedute;
col calendario USA, no. Tre ipotesi, **[NON MISURATO]** quale valga (`IL_MERITO_E_D_INVERNO` §0 punto 6;
`OROLOGIO_BCM_2026-09-24.md` §5.3). Misura: ora dell'ultima candela M1 contro UTC, il 26/10, a terminale acceso.

🟠 **La griglia H4 del filtro** (letto nel codice: `TrendBias()` r.1491-1498 legge la **barra H4 chiusa** `shift 1`,
calcolato **una volta** all'armo, r.1281) [DERIVATO dagli orologi, estate]:
- BCM (UTC+1): all'armo delle 15:05 BCM l'ultima H4 chiusa è la 08:00-12:00 BCM → chiusa alle **7:00 NY**;
- FTMO (UTC+3): all'armo delle 17:05 FTMO l'ultima H4 chiusa è la 12:00-16:00 FTMO → chiusa alle **9:00 NY**.
👉 **In campo il filtro legge una chiusura due ore più recente** (dentro il pre-mercato USA) di quella del contratto.
L'effetto sul `bias` è **[NON MISURATO]** (classe 771; già segnalato nel preset r.40-48).

### A.4 🔧 Gestione, letta nel codice (HEAD = pin)

| pezzo | cosa fa | riga |
|---|---|---|
| armo | `ArmRetest`: `SpreadOK()` sempre vero (`InpMaxSpread=0`), `gBias = TrendBias()` | r.1268-1288 |
| rottura | `ask >= rangeHigh + 10,00` e `bias` ≠ −1 → **BUY LIMIT** a `rangeHigh − 4,00` | r.1302-1319 |
| stop | `sl = rangeLow − 10,00` (**stop = range + 6,00 idx**), floor 5,00 che allarga | r.1320-1327 |
| taglia | 2,00% del saldo, `MathFloor` sullo step | r.1622-1658 |
| Guardian | `ABTG_GuardiaIngresso` prima del `BuyLimit` (solo al piazzamento, classe 645) | r.1334-1335 |
| TP dell'ordine | `entry + 3R` | r.1452-1457 |
| parziale / pareggio | 50% a +1R, stop a `openP` | r.1748, r.1762 |
| trailing | minimo della candela M5 precedente, se `> sl` e `> openP`, arma subito | r.1817, r.1832-1835 |
| un ciclo al giorno | guardia reload-safe dallo storico | r.581 |

---

## B. 📊 VALIDAZIONE ABTG (G0 → G1 → OOS)

### B.1 La tavola dei numeri (cella di contratto, `U30USD` M5, **tick reali**, deposito 100.000, rischio 1,00%)

| misura | IS 2024.09.26 → 2025.06.09 | OOS 2025.06.10 → 2026.06.30 | fonte e data | etichetta |
|---|---:|---:|---|---|
| **n** | **56 posizioni** (74 deal) | **96 posizioni** (130 deal) | CSV `aperture_r47/..._r47c.csv` r.2; posizioni su `R246/PERTRADE/..._794603.csv` (IS) e `aperture_r47/..._772505.csv` (OOS) | [MISURATO] |
| **PF** | **1,22247** | **1,27013** (deal) · 1,27044 (posizioni) | idem | [MISURATO] |
| **DD equity** | **5,6692%** | **4,3941%** | idem | [MISURATO] |
| DD a saldo chiuso | — | 4,2235% | per-trade `772505` | [MISURATO] |
| **win rate** (posizioni) | 69,6% | **66,7%** | per-trade | [MISURATO] |
| **expectancy** | +50,21 EUR/pos (~0,050 R) | **+70,02 EUR/pos** (~0,070 R) | per-trade | [DERIVATO] |
| media vincente / perdente | +395,99 / −743,04 | +493,40 / −801,80 | per-trade | [MISURATO] |
| peggior giornata | −1,0062% | −1,0227% | CSV r.2 | [MISURATO] |
| metà OOS (taglio 01/01/2026) | — | 2025: **1,472** su 54 · 2026: 🔴 **1,036** su 42 | `stress_pertrade.py` (§C.2) | [MISURATO] |
| **DD @2,00%** | 🔴 **11,34%** | **8,79%** (lineare) · **8,30%** (misurato diretto, R239) | `CONTRATTI_...` r.64; `IL_DD_DELLE_SEI_SEDIE_2026-09-24.md` r.72 (CSV di R239 **non in repo**) | [DERIVATO] / [MISURATO fuori repo] |
| frequenza promessa | — | **0,348 op/giorno** | `CONTRATTI_...` r.64 | [DERIVATO] |
| regime | 9,1 mesi | **un solo regime** | `CONTRATTI_...` r.64 | [DERIVATO] |

### B.2 Contro i criteri — le due unità di misura, accanto

| criterio | di casa | esito | del briefing | esito |
|---|---|---|---|---|
| n per il merito | ≥ 150 posizioni | 🔴 **IS 56, OOS 96**: merito **sospeso** in tutte e due (Emendamento A) | n ≥ 30 (≥ 60 per il DD) | 🟢 OOS 96 · 🟠 IS 56 (< 60 per il DD) |
| PF | ≥ 1,10 IS e OOS | 🟢 1,222 / 1,270 | < 1,10 = degrado | 🟢 sul totale · 🔴 **0,782** sulla casella allineata (§B.5) · 🟠 1,036 sulla metà 2026 |
| DD alla taglia di volo | entro il 10% statico | 🟢 OOS 8,79% / 8,30% · 🔴 **IS 11,34%** (dal picco) | — | — |
| selezione | centro dell'altopiano | 🟠 misto (§B.3) | — | — |

### B.3 🏔️ Altopiano: la cella in campo è centro o picco?

🔴 **Il round che ha scelto la cella `770202` non è identificabile in repo**: la sedia è viva dal **07/08**
(`PERCHE_770202_E_MUTA` §8) e le misure IS/OOS della cella esatta (R16c `ptc`, R47c) sono **successive**. Gli assi
misurati dopo, uno per uno:

| asse | misura | dove sta il valore vivo | fonte |
|---|---|---|---|
| `InpEntryMode` (retest vs breakout) | breakout: IS **0,965** (in perdita), OOS 1,188 · retest: IS 1,212, OOS 1,254 | 🟢 retest confermato | `risultati_prove/R197A/` (21/09) [MISURATO] |
| `InpRetestOffsetPts` 0-600 | IS 0,973 / 1,071 / **1,212** / 1,110 · OOS 1,125 / 1,280 / **1,254** / 1,259 | 🟠 **picco in IS**, dentro un altopiano piatto in OOS (200-600) | `R197B` (21/09); "centro altopiano" per `PROFONDITA_RETEST_2026-09-21.md` §5 |
| `InpRangeMinutes` 15-60 (R35, 10.000) | IS: 30 = 1,015 · **35 = 1,215** · 40 = 0,907 · OOS: 15-40 tutte 1,25-1,48, 45-50 = 1,68/1,66 | 🔴 **picco a una cella in IS**; in OOS dentro l'altopiano 15-40 | `risultati_prove/aperture_r35/` [MISURATO]; `ALZARE_IL_PF_2026-09-22.md` r.346 |
| `InpRangeMinutes` 25/35/45 × lati (`ptc`) | solo long: OOS 1,487 / **1,270** / 1,639 · IS 1,129 / **1,222** / **0,843** | come sopra | `risultati_prove/ABTG_Dow_Apertura_US/..._ptc.csv` |
| `InpTP1_R` 0,25-1,00 | OOS 0,932 / 1,103 / 1,137 / **1,272** · IS 1,397 / 1,058 / 1,379 / 1,222 | 🟠 **bordo destro** della griglia, massimo in OOS | `R202A` |
| `InpBEatR` 0-0,90 | OOS: 0 = **1,272**, 0,15 = 0,889, 0,30 = 0,891 | 🟢 lo 0 è il migliore in OOS | `R172D` |
| `InpTP1_ClosePct` 50 vs 0 | OOS 1,270 → 1,258, DD 4,39 → 5,43 | 🟢 il 50 vivo è meglio | `ALZARE_IL_PF` r.347 (X3) |
| **`InpEmaSlow` / `InpFilterTF`** | **nessun file in repo** con l'asse sulla cella RETEST long (scansione di tutti i CSV `Dow_Apertura_US` con `EntryMode=2`, `AllowShort=0`: 0) | 🔴 **[NON MISURATO]** — "mai misurato esattamente, sta fra 40 e 60" (`LA_SECONDA_SEDIA_2026-09-12.md` r.233: l'asse 20-200 era del breakout `770201`, il 50 vivo non vi cade sopra) | [MISURATO lo zero] |

⚠️ Il plateau `InpEmaSlow` 160-280 (centro 220) di **R245/R262** è misurato sulla **`770201` BREAKOUT a due lati**, non
su questa cella: per regola di casa una misura su un'altra configurazione **non presta il suo verso**
(`PROFONDITA_RETEST` §4).

### B.4 🧪 Contro-esempio (rifatto a mano da un CSV vero)

Dal per-trade `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv`:
positivi / negativi = **1,27013**, netto **+6.721,93**, 130 righe, **96** `position_id` → **identici al centesimo** a
`..._OOS_r47c.csv` r.2 (PF 1,27013, Profit 6.721,93, Trades 130). Seconda prova, contro il numero di `CLAUDE.md`:
split per ora legale USA (09/03-02/11/2025, 08/03-01/11/2026) sulla data di chiusura → estate **73 deal PF 0,782**,
inverno **57 deal PF 1,662** = *"PF 0,78 su n=73 … 1,66 su n=57"*, **al millesimo** (in posizioni: **58** e **38**)
[MISURATO]. Precisazione sulla casella "come FTMO d'estate": **2** delle 58 posizioni cadono nelle settimane in cui
gli USA sono già (o ancora) in ora legale e l'Europa no (26/10-01/11/2025, 08-28/03/2026): lì BCM arma alla cash, ma
FTMO col calendario UE armerebbe alle 10:30 NY. Sulle altre **56** l'equivalenza regge [DERIVATO].

### B.5 ❄️ Stagione e orologio — dove sta il merito

| casella | PF | posizioni | fonte |
|---|---:|---:|---|
| OOS, mesi allineati (**come FTMO d'estate**) | 🔴 **0,782** | 58 | per-trade `772505` [MISURATO] |
| OOS, mesi sfasati (armo 8:30 NY) | 1,663 | 38 | idem |
| A+B d0 estate | **0,886** | 84 | `REFERTO_R246_2026-09-24.md` §5.1 — 🔴 **SOSPESO dal G1** (un centesimo su un deal, R246a/c NULLI) |
| A+B d0 inverno | 1,492 | 68 | idem |
| A+B **-1h estate** | 1,038 | 137 | idem — DD saldo 10,54% |
| inverno **alla cash** (FTMO dal 02/11) | **[NON MISURATO]** | — | R246m-r pronti, non girati |

- Estate A **1,203** (26 pos.) contro estate B **0,782** (58): il divario è in buona parte **l'estate 2025/26**
  (`REFERTO_R246` §5.1, descrittivo).
- Differenza inverno − estate: IC95 **[−0,42 ; +1,86]**, p **0,15**; **togliendo 2 mesi d'inverno** l'inverno scende a
  **1,004** (`IL_MERITO_E_D_INVERNO` §0 punto 2). 👉 **Causa non dimostrata** (stagione o orologio), ma **il fatto è che
  la casella che vola d'estate su FTMO ha PF sotto 1** a n < 150: **indizio di rischio, non bocciatura**
  (`REFERTO_R246` §7.3).

---

## C. 💸 STRESS E COSTI

### C.1 Cosa esisteva già

| misura | numero | fonte | etichetta |
|---|---|---|---|
| costo extra per posizione (MC congiunto) | spread x1,5 **0,0152 R** · x2 **0,0304 R** · ingresso +1 pt 0,0101 R · +3 pt 0,0304 R | `MC_STRESS_CONGIUNTO_2026-09-28.md` §1 | [DERIVATO] |
| pedaggio FTMO contro BCM | +31,5% (US30.cash 2,63 contro U30USD 2,00, tick del 20/09 17:08); PF su FTMO **1,237-1,244** | `STOP_VS_SPREAD_FTMO_2026-09-20.md` §5, §5.4 | [DERIVATO] |
| spread all'ora d'ingresso | `U30USD` **2,00** (archivio tick) / **3,00** (logger vivo): **si prende 3,00** · `US30.cash` FTMO all'apertura **2,10** (P95 2,48, 1 giornata) | `MAPPA_COSTO_SIMBOLI_TF_2026-09-24.md` §3.2; `SPREAD_APERTURA_FTMO_2026-09-21.md` §1 | [MISURATO] |
| commissione | **0,00** (indici BCM, 302 deal; FTMO "0,00") | `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.186; `TERZO_STOP_FTMO` r.13 | [MISURATO] |
| slittamento vero su `US30.cash` FTMO | **7,83 punti** sullo stop (3,3× lo spread), sedia `771531`, n=1 | `PRIMO_STOP_FTMO_2026-09-22.md` §2 | [MISURATO, altra sedia] |
| latenza del tester | **[NON MISURATO]** su questa sedia (R119 ha girato DAX e ORB, non il Dow Apertura) | `ritardo_r119b_csv/` | — |
| stress di spread +25/+30/+50% **per questa sedia** | **mai fatto prima di oggi** | — | → §C.2 |

### C.2 Lo stress, fatto oggi a costo zero (criteri: §C.0 in fondo, committati prima)

```bash
python3 backtest_pipeline/stress_pertrade.py --pertrade backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv --k 0 --C 1 --punto 1.0 --deposito 100000 --rischio 1.0 --base-spread 3.00 --base-spread 2.00 --base-spread 2.10 --taglio 2026.01.01 --attesa-pf 1.27044 --attesa-dd 4.223
```

Il +30% importando le stesse funzioni, senza modificare lo script. Controesempi: **degrado zero = PF 1,2704 / DD
4,2235% → OK**; +1000% → PF 0,38 **OK**; monotonia **OK**; `q` misurato su 9 ancore (0,8413-0,8638).

**Scala sulla base 3,00** (quella che decide; PF in **posizioni**, n = 96; slippage in punti indice su ingresso **e**
su ogni deal d'uscita):

| spread | slip 0 | slip 1 | **slip 2 (decide)** | DD chiuso @1% (slip 2) | DD ×2 [DERIVATO] | peggior giornata ×2 (slip 2) |
|---|---:|---:|---:|---:|---:|---:|
| base | 1,2704 | 1,1872 | **1,1079** | 4,81% | 9,63% | 2,32% |
| +25% | 1,2387 | 1,1570 | **1,0793** | 4,92% | 9,85% | 2,38% |
| +30% | 1,2324 | 1,1510 | **1,0736** | 4,95% | 9,89% | 2,39% |
| +50% | 1,2076 | 1,1273 | **1,0513** | 5,04% | 🔴 **10,07%** | 2,44% |
| +100% | 1,1470 | 1,0699 | **0,9973** | 5,26% | 🔴 **10,51%** | 2,57% |

A slippage zero il DD chiuso @1% è **4,22%** (×2 = 8,45%) e la peggior giornata 1,023% (×2 = 2,05%).
Base FTMO **2,10**, slip 2: base 1,1079 · +25% **1,0878** · +30% 1,0838 · +50% **1,0680** · +100% **1,0294**.
Base 2,00, slip 2: +25% 1,0888 · +50% 1,0699 · +100% 1,0330.
**Per metà** (base 3,00, slip 2): 2025 **1,269 → 1,130** lungo la scala, 2026 🔴 **0,919 → 0,839**: la metà 2026 è
sotto 1 già al gradino base con slippage 2.

### C.3 ⚖️ Verdetto contro i criteri congelati

- **MERITO → 🟠 FRAGILE.** +25%/slip 2 PF **1,0793** (≥ 1,00); +50%/slip 2 **1,0513** (< 1,10). Sulla base FTMO 2,10:
  1,0878 e 1,0680. **Decide Claudio** — e il merito è già **sospeso** per n < 150 (§B.2).
- **Margine reale**: slippage massimo che tiene PF ≥ 1,10 a +50%: **1,3 punti** (base 3,00), 1,5 (2,10), 1,6 (2,00);
  che tiene PF ≥ 1,00 a +100%: **1,9 punti** (3,00). 🔴 **Qui il campo non aiuta**: la `770202` **non ha mai avuto un
  riempimento su FTMO** né sul reale, e le 3 posizioni del 100k sono tutte vincenti da trailing (nessuno slittamento
  misurabile). L'unico stop vero su `US30.cash` FTMO (`771531`, 22/09) ha slittato **7,83 punti** (n=1).
  🔴 **Lo stesso script a slippage diversi dai 2 punti** (base 3,00, `scenario` importato) [DERIVATO]:

  | spread | slip 0,41 su ogni deal (media stop **DAX** BCM, altro simbolo) | slip 1,7 su ogni deal | 7,83 **solo** sull'uscita delle 31 posizioni in perdita, 0 altrove | slip 2 (decide) |
  |---|---:|---:|---:|---:|
  | +25% | 1,2048 | 1,1021 | 1,1224 | 1,0793 |
  | +50% | **1,1743** | **1,0736** | **1,0952** | **1,0513** |

  👉 Anche con lo slittamento FTMO del 22/09 messo su **ogni** stop perdente la sedia resta sopra 1,00 ma **sotto
  1,10** a +50%: qui, diversamente dalla `770101`, il FRAGILE **non** dipende solo dall'ipotesi dei 2 punti. Lettura
  **informativa**, il criterio congelato decide a 2 punti. (La colonna 7,83 è costruita a mano, q interpolato come lo
  script, spread su tutto il volume, e **non** passa dallo script.)
- **RISCHIO**: il DD a saldo chiuso ×2 **tocca il muro del 10% a +50% con slippage 2** (10,07%) e lo supera a +100%
  (10,51%) [DERIVATO lineare, dal picco]. In IS il DD equity @2% sta **già** a 11,34% al gradino base (§B.1). La
  peggior giornata della sedia da sola resta sotto la pausa 3,5% del Guardian (max 2,57%).
- **Frontiera `stop ≥ 40 × (spread + comm.)`** — stop ricostruito dal lotto (classe 846, `--passo 0.1`): **mediana
  159,53 idx** (P10 46,04, min 29,81) [DERIVATO]. Mediana/spread = **53,2×** a 3,00 e **76,0×** a 2,10: 🟢 **passa alla
  mediana**. Sotto 40×: **39/96 (40,6%)** a 3,00, **29/96 (30,2%)** a 2,10. Per anno di ingresso: 2025 mediana
  136,6 idx (26/54 sotto a 3,00), 2026 mediana 190,0 (13/42).

### C.4 Qualità dei dati

- Contratto R47c: **tick reali** su `U30USD` BCM. La serie `US30.cash` FTMO **non è mai stata testata**.
- R246 sul Dow: G1 **NULLO alla lettera** per un centesimo su un deal (conversione USD→EUR del tester,
  `REFERTO_R246` §1.3): i verdetti stagionali del Dow sono **sospesi**, i numeri no.
- **Non coperto**: ingressi che cambiano con lo spread, requote, rifiuti, gap, esecuzione vera FTMO.

---

## D. 🔎 ANOMALIE IN CAMPO

### D.1 Su FTMO `541452707` (21/09 → 28/09 03:30)

| giorno | ordini `770202` | fonte |
|---|---|---|
| 21/09 | giornale non letto da `CODA_09`; **nessuna posizione** (il per-trade FTMO parte dal 22/09) | `CODA_12_..._20260928` r.16-20 |
| 22/09 · 23/09 | **zero righe d'ordine** (giornali **completi**: 4 e 1 righe, nessuna del Dow Apertura) | `CODA_09_..._20260923`, `..._20260924` [MISURATO] |
| 24/09 · 25/09 | nessuna posizione; **ordini piazzati e scaduti non esclusi** (giornali troncati al tetto di 40 righe: 63 e 299 non stampate) | [DERIVATO: le 6 posizioni del per-trade FTMO (`CODA_12` r.16-20) sono `771531` ×3, `770411` ×1, `770101` ×2 — `HEDGING_FRA_CONTI_2026-09-24.md` §4, `TERZO_STOP_FTMO`, `NOTTE_2026-09-28.md`] |
| 26/09 → 28/09 03:30 | zero righe d'ordine | `CODA_09` 27 e 28/09 [MISURATO] |

- **Perché "zero righe" qui vuol dire "zero ordini" e non solo "zero ordini falliti" (classe 896)**: `CTrade` stampa
  solo gli errori, ma la sedia stampa **da sé** `BUY LIMIT (retest) @ ...` **dopo** un `BuyLimit` riuscito (r.1337) e
  `BUY LIMIT (retest) fallito` se no (r.1339), via `ABTGLog` che scrive solo con `InpVerbose=true` — e `InpVerbose=true`
  è nel `.chr` vivo (`CODA_08_..._20260928` r.1968). Il filtro di `CODA_09` prende `buy` senza maiuscole
  (`CODA_09_giornale_operativo.ps1` r.115): la stessa riga della `770101` il 22/09 compare (`CODA_09_..._20260923`
  r.94). Il rifiuto del Guardian non stampa una riga d'ordine (le righe GUARDIAN sono escluse dal conteggio, r.116), ma
  a fine 22/09 e 23/09 il Guardian FTMO segna `pausa=off cap=off` (`CODA_09_..._20260923`/`..._20260924`): un rifiuto
  quei giorni non aveva motivo di scattare [MISURATO nel codice e nel giornale].
- **Il perché di FTMO è [NON MISURATO]**: il `bias` EMA e le righe `RETEST armato` stanno nel log **Esperti** di
  `C:\FTMO`, che nessuna sonda notturna legge (`CODA_02` guarda solo i BCM). Via più corta: una riga di **sola
  lettura** sul VPS che stampi **intere** le righe `CLAU12_Dow_Apertura_US` di `C:\FTMO\MQL5\Logs` dal 21/09 (come
  `RIGA_PERCHE_770202_MUTA.ps1` fa per i BCM): **secondi, zero tempo macchina**. La scrive la sessione dopo.

### D.2 Sui BCM, e il conto delle sedute mute

- 100k `50504263`: **3 posizioni** (10/08, 13/08, 28/08), tutte vincenti da trailing, **+282,02 €**
  (`data/statements/trades_100k.csv`, aggiornato il 24/09) [MISURATO]. Piccolo `50503392`: 4 posizioni, +0,35 €.
- Giornali BCM: nessuna riga d'ordine del Dow Apertura sul **100k** 22-25/09 e sul **piccolo** 22-23/09 [MISURATO,
  `CODA_09`]; il piccolo **non ha giornali dopo il 23/09** (ultimo file `20260923` anche nella sonda del 28/09), quindi
  il suo 24-25/09 è **[NON MISURATO]**.
- **Sedute mute** dal 31/08 al 25/09: **20** (le 15 fino al 18/09 di `PERCHE_770202_E_MUTA` §0, 07/09 compreso perché BCM
  ha quotato, + 5) [DERIVATO]. Record del motore nel suo OOS: **23** (per-trade `770206`, stesso referto).
  👉 **Il 30/09 la siccità eguaglia il record**: è la data del **TAGLIANDO** già scritta (§8 del referto), il giorno prima
  della scadenza di fine settembre. Il meccanismo provato l'11/09 è il mercato (solo long su un Dow in discesa,
  livello di rottura mai toccato), **non** un guasto.
- **Corsia RISCHIO**: nessuna posizione, nessun DD. **MERITO**: n = 0 su FTMO, 3-4 sui BCM: non si giudica.

### D.3 Orario e sovrapposizioni sugli USA

- 🔴 **La casella che la sedia gira adesso su FTMO** (armo alla cash, estate) è quella a PF **0,782** nell'OOS (§B.5).
  Dal 02/11 (o dal 26/10 con un'ora di ritardo) girerà l'inverno **alla cash**, mai misurato.
- **`771531` EMA200 Dow H1** (stesso `US30.cash`): co-perdite **6 su 277** giornate, **tutte e 6** nelle **22** in cui
  operano insieme (27,3%; lift 1,57, p **0,0588**: nessun legame al criterio, sul filo). Le due giornate peggiori del
  portafoglio al 2% (**2026.02.26: 6,87%** e **2025.10.15: 6,33%**) contengono una perdita della `770202` (−2,16 e −1,96)
  **e** una della `771531` (`DIPENDENZA_NELLO_STRESS_2026-09-28.md` §5-§6) [MISURATO].
- **`770511` SuperWave Dow H1**: il tris con la sedia vera è **[NON MISURATO]** (niente per-trade in repo); col proxy
  H2 `770521` le due giornate con tutte e tre in perdita sono **proprio le due peggiori** [DERIVATO, stesso referto §6].
- **`770260` Nasdaq** arma **allo stesso minuto** (16:30 FTMO) su un indice correlato: sovrapposizione **[NON MISURATO]**
  (nessun per-trade della cella in repo; `DIPENDENZA_NELLO_STRESS` r.370).
- `770101` × `770202`: lift 0,91, nessun legame (`DIPENDENZA_NELLO_STRESS` tabella r.224).
- Anomalia di codice **latente**: lo stesso trailing che il 24-25/09 ha prodotto la raffica di `modify` rifiutate sulla
  `770101` è **identico** qui (r.1817), mai scattato perché la sedia non ha avuto riempimenti
  (`MODIFY_A_RAFFICA_FTMO_2026-09-25.md` §3) [MISURATO nel codice].
- `770212` (lo short gemello): preset in repo, **non** fra le sette sedie in campo (`00_PERIMETRO` §1).

---

## E. 🧭 PROPOSTE — da misurare, mai da applicare

**La condizione del briefing è soddisfatta in parte**: il PF OOS totale è 1,270 ≥ 1,10, ma c'è un **degrado
misurato** nella casella che vola (**0,782 su 58** posizioni, mesi allineati) e nella metà 2026 (**1,036 su 42**), a
n < 150 (indizio). Solo meccanismi **già misurati** o **già nel registro**:

| # | cosa | stato | costo |
|---|---|---|---|
| E1 | **Misurare l'inverno alla cash** (la cella che FTMO girerà) | **R246m-r**: file prova pronti, PASS strato 2, pin `782d7280` (`REGISTRO_TEST.md` r.62-63) | ~5 min, **PC di backtest** |
| E2 | **Leggere il `bias` vero su FTMO** (se la muta è EMA o livello mai toccato) | riga di sola lettura da scrivere (§D.1) | secondi, VPS, sola lettura |
| E3 | **Misurare l'asse `InpEmaSlow` (e `InpFilterTF`) sulla cella RETEST long** | mai misurato (§B.3); non è un parametro nuovo, è un input vivo mai messo ad asse | ~7 celle × 2 finestre a tick, ordine dei minuti (R245 ha fatto 84 passate in 28 min) |

**Già misurati, e NON da riproporre** (per non ripagarli):
- lato **short acceso** sulla stessa cella: OOS PF **1,096**, DD **8,68%** (contro 1,270 / 4,39%), IS migliora mentre OOS
  peggiora (`ptc`, `PERCHE_770202_E_MUTA` §7);
- **range 45**: OOS 1,639 ma IS **0,843** — picco, non selezionabile (`ALZARE_IL_PF` X2);
- `InpTP1_ClosePct` 0 (peggiora OOS, X3) · `InpBEatR` 0,15-0,30 (OOS 0,889-0,891, `R172D`) · breakout (IS in perdita, `R197A`);
- **short da solo** `770212`: R54a OOS PF **0,840** su 73 (`SEDIA_SHORT_DOW_FTMO_2026-09-26.md` §6.2), certificato aperto
  con R255;
- **`770201` breakout due lati** (R245/R262/R263): n ≥ 150 in tutte e due le finestre, PF IS 1,25 / OOS 1,49 al centro
  EmaSlow 200-220, ma DD @2% 13-14% sopra il muro (il muro cade fra 1,25 e 1,50% di rischio), **merito anch'esso
  invernale** (estate 0,982 su 199, `IL_MERITO_E_D_INVERNO` §0 punto 1) ed entra nel **96%** dei giorni della `770202`
  (`REFERTO_R247`). 👉 **Non cura la debolezza d'estate**: la condivide.

---

## ⚠️ Note sulle fonti indicate nel compito

- **R262 e R263** (`REFERTO_ROUND_CORTI_B_2026-09-27.md` §3-§4) **non misurano la `770202`**: sono sulla **`770201`**
  (`ABTG_Nasdaq_Apertura_US` BREAKOUT a due lati su `U30USD`, preset FTMO in **BOZZA**). Citati qui solo in §E.
- Il numero di `CLAUDE.md` (*"PF 0,78 su n=73 … 1,66 su n=57"*) è in **deal**, non in posizioni (58 e 38): rifatto al
  millesimo in §B.4.

---

## C.0 Criteri dello stress dei costi — CONGELATI PRIMA DEI NUMERI (commit `40a1a985`, testo invariato)

- **Cella**: ABTG_Dow_Apertura_US, magic di misura della cella OOS di contratto (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §2),
  simbolo U30USD (BCM) / US30.cash (FTMO), M5, tick reali, deposito 100.000, rischio 1,00%.
- **Per-trade**: `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv` (solo deal d'uscita, OOS 2025.06.10 -> 2026.06.30).
- **Strumento**: `backtest_pipeline/stress_pertrade.py` (non modificato), `--k 0` (commissione indici misurata 0,0000
  su 302 deal BCM, `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.186; su FTMO "swap e commissioni 0,00",
  `TERZO_STOP_FTMO_2026-09-25.md` r.13), `--C 1` (q misurato dal file), `--punto 1.0` (1 punto INDICE),
  `--deposito 100000 --rischio 1.0`, `--taglio 2026.01.01`.
- **Spread di base**: 3,00 (lato pessimista; l'archivio tick dice 2,00: si stampano tutte e due, decide 3,00). Stampato anche: 2,10 (US30.cash FTMO all'apertura, SPREAD_APERTURA_FTMO_2026-09-21.md §1, 1 giornata).
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
