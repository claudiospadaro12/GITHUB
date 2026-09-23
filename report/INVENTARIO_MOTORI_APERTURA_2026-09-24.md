# 🔧 INVENTARIO DEI MOTORI "APERTURA" — che cosa il codice sa gia' fare, e che cosa no

**24/09/2026** · censimento di **SOLA LETTURA** · nessun `.mq5` toccato, niente lanciato,
niente in forward · repo `/home/user/GITHUB`, branch `lavoro`, HEAD `5ff4256c`

**File letti riga per riga**: `mql5/Experts/ABTG_DAX_Apertura_EU.mq5` (2885 righe, il
riferimento), `ABTG_Dow_Apertura_US.mq5` (2205), `ABTG_Nasdaq_Apertura_US.mq5` (2644),
`ABTG_Apertura_3Ingressi.mq5` (2681), `ABTG_Apertura_Marco.mq5` (1625), i due
`_Ottimizzato`, i quattro `Experts/standalone/`, `mql5/Include/ABTG_PausaGuardian.mqh`.

---

## 0. 🔴 LA COSA CHE SERVE PRIMA DI TUTTO: **CINQUE MODI SU SEI SONO GIA' MISURATI**

Il mandato parte da una premessa — *«il modo 3 non e' MAI stato provato»*, *«di CINQUE MODI
SU SEI non sappiamo NIENTE: ne' il PF, ne' l'n, ne' il DD»* (`backtest_pipeline/prove/
R241b_modoingresso_DAX_long.txt` r.13, r.55-57). **Quella premessa e' FALSA, ed e' falsa
con dei numeri in archivio.** Ho cercato di romperla prima di consegnarla, e si rompe.

### 0.1 Il 05/08/2026 i sei motori sono stati misurati tutti e sei, per sbaglio
`backtest_pipeline/risultati_archivio/Openconfirm/MOTORI_INGRESSO.md` — titolo testuale
*«I sei motori d'ingresso, misurati — DAX e Nasdaq (05/08)»*. Tick reali, M5,
2024.01→2026.06. Causa dichiarata: **MT5 sugli input `enum` ignora `start||step||stop` e
spazzola tutti i valori**, quindi un round nato per confrontarne due ne ha misurati sei.

DAX: `RANGE_FADE` **−3.676,03 · PF 0,705 · DD 39,74% · n 440** — il peggiore dei sei.
Nasdaq: **−2.783,64 · PF 0,745 · DD 31,66% · n 440**.

### 0.2 Il 06/08/2026 i sei motori hanno fatto un WALK-FORWARD, IS e OOS separati
`backtest_pipeline/risultati_archivio/Walkforward_Aperture/REFERTO_FASE_B_C5.md` — 48 pass
a tick reali, IS 26/09/2024→30/06/2025, OOS 01/07/2025→30/06/2026, **range 35** (la
geometria di oggi), buffer 200, gestione TP 1,5R senza parziale.

| DAX, volumi OFF | IS PF | n IS | OOS | OOS PF | n OOS | DD OOS |
|---|---:|---:|---:|---:|---:|---:|
| BREAKOUT | 1,271 | 179 | −225,44 | 0,966 | 243 | 14,54% |
| GAPFILL | 0,993 | **7** | +33,10 | 1,110 | **9** | 2,68% |
| **RETEST** | 1,168 | 180 | **+392,96** | **1,065** | 244 | 13,32% |
| RANGE_FADE | 0,824 | 179 | −1.660,69 | 0,772 | 245 | 16,91% |
| DELAYED | 1,278 | 179 | −379,23 | 0,946 | 245 | 15,85% |
| OPENCONFIRM | 0,935 | 186 | **+209,36** | **1,035** | 250 | 13,52% |

### 0.3 E il 13/08/2026 il RANGE_FADE ha avuto un round tutto suo: **0 celle positive su 48**
`backtest_pipeline/risultati_archivio/REFERTO_ROUND42_FADE.md` — griglia 12 celle × 2
finestre × 2 simboli, tick reali M5, **campioni 195-214 IS e 300-333 OOS per cella**, PF
sempre fra **0,50 e 0,93**. Ipotesi *«whipsaw DAX»* (il commento del sorgente!) dichiarata
**FALSIFICATA**: sul DAX il fade e' il peggiore del lotto. Prove congelate:
`prove/R42a_fade_NASUSD.txt`, `prove/R42b_fade_DAX.txt`.

### 🔴 Che cosa cambia, operativamente
1. **Il modo 3 non e' un modo vergine: e' un modo con un certificato quasi completo.**
   PF ✅ · n e DD ✅ · gestione d'uscita ad asse ✅ (il round 42 gira con la gestione
   validata sul Dow, non con quella che aveva affossato il test di luglio) · simboli
   gemelli ✅ (D30EUR + NASUSD) · **TF cambiato ❌ (solo M5)**. Gli manca **una** casella.
2. Per la **regola della seconda caccia (19/08)**, su un motore dichiarato senza edge
   **non si allarga sui parametri**: una griglia piu' fitta su 0/48 trova solo picchi di
   rumore. Si puo' allargare su **TF** (casella ⑤ mancante) e su **simboli** — e su
   niente altro.
3. 🟢 **E c'e' una notizia buona che nessuno ha raccolto**: `OPENCONFIRM` volumi OFF sul
   DAX e' **positivo fuori campione** (+209,36 · PF 1,035 · **n 250** · DD 13,52%), con
   un campione sopra i 150 dell'Emendamento A. Sul Nasdaq no (−365,50). E' un candidato
   in piedi, non un morto.

---

## 1. 🔴 CHE COSA **NON SI PUO' FARE OGGI** SENZA SCRIVERE CODICE NUOVO

Questo e' l'elenco che serve per non progettare round impossibili.

| # | non si puo' | perche', con la riga |
|---|---|---|
| **N1** | **Misurare la distanza ingresso→SL dentro un round** | la distanza non e' un output: si legge dal Giornale (`ABTGLog`, r.495-502) e in `Optimization=1` le `Print` non si eseguono. Nessun `OnTester()` la espone (`ABTG_DAX_Apertura_EU.mq5` r.2786-2815). 👉 **il cancello del costo su qualunque modo nuovo resta `[NON MISURATO]` finche' non esiste una FASE 1 a passata singola** |
| **N2** | **Un'ancora che segua il DST della borsa** | l'ancora e' un'ora fissa del server (`InpSessionHour/Min`, r.263-264). EU e USA cambiano ora in date diverse: per ~3 settimane l'anno un'ancora USA su server EU slitta di 60'. La casa *sa* che la distinzione esiste (il sonda oro usa *«la fascia 09:30 di New York col suo calendario DST»*, `report/ORO_FADE_0930_LA_MISURA_2026-09-22.md`), **l'EA no** |
| **N3** | **Filtrare per giorno della settimana** | `grep day_of_week` su DAX/Dow/Nasdaq: **zero occorrenze**. 👉 non si puo' limitare il GAPFILL ai lunedi' (l'unico giorno in cui sui metalli esiste un gap vero), ne' escludere i venerdi' |
| **N4** | **Staccare l'ATR di gestione dal TF del grafico** | `gAtrH = iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriodMgmt)` — r.510. Non esiste un `InpMgmtTF`. (Ce l'ha un altro EA di casa: `ABTG_MaxMinNotte.mq5` r.146 `InpMgmtTF = PERIOD_M15`.) 👉 **su RANGE_FADE lo stop e' 1,5×ATR: cambiare TF del grafico CAMBIA LO STOP**, non si puo' isolare |
| **N5** | **Due modi insieme, o un modo per lato** | `InpEntryMode` e' uno solo e si legge in `PH_BUILDING` (r.847-885). Niente "long in RETEST e short in FADE" |
| **N6** | **Piu' di un ciclo al giorno** (tranne RETEST) | `InpAllowReverse` esiste **solo** nel DAX (r.291) e **solo** per RETEST (r.1029: `if(InpEntryMode != ABTG_RETEST) return;`). Tetto rigido 2 (r.782) |
| **N7** | **Usare Marco / i due `_Ottimizzato` / i 4 `standalone` per misurare il GAPFILL** | in quei 7 file la riga e' `if(InpEntryMode == ABTG_GAPFILL **&& InpUseGapFill**)` (`ABTG_Apertura_Marco.mq5` r.601, `ABTG_DAX_Apertura_EU_Ottimizzato.mq5` r.513, `ABTG_Nasdaq_Apertura_US_Ottimizzato.mq5` r.514, `standalone/*.mq5` r.447-453) e il loro default e' `false` → **la cella GAPFILL ricade in BREAKOUT in silenzio**. Il bug corretto il 05/08 vive ancora li' |
| **N8** | **Un pavimento di stop che non tolga operazioni** — su 5 modi su 6 | `InpMinStopPts` + `InpSkipIfTight=true` **saltano** il trade (r.1204, 1437, 1546, 1928). 🟢 **Unica eccezione: RANGE_FADE**, che il pavimento lo applica **allargando** lo stop e non salta mai (r.1279) |
| **N9** | **Una conferma ATR su RETEST e OPENCONFIRM** | `ConfirmOK()` e' chiamata solo da BREAKOUT (r.1180), FADE (r.1270), DELAYED (r.1375), GAPFILL (r.2026). RETEST usa `VolumeOK()` nudo (r.1926/1969) e OPENCONFIRM `VolumeOKtf(octf)` (r.1527): 👉 **`InpUseAtrFilter` e `InpConfirmMode` sono INERTI sui modi 2 e 5** |
| **N10** | **Portare i filtri dello SPAZIO fuori dal RETEST** | `SpazioFuoriBanda` e' agganciata solo a `MonitorRetest` (r.1941, r.1980). L'EA lo dice da solo in `OnInit` r.571-573. E il filtro esiste **solo nel DAX** |
| **N11** | **Scalare buffer e pavimenti cambiando simbolo** | `InpBufferPoints`/`InpMinStopPts` sono in **PUNTI** e non si riscalano. 500 pt su D30EUR = 5 punti indice; **gli stessi 500 pt su XAUUSD = 5,00 $**, cioe' meta' del range d'apertura dell'oro. Un preset copiato e' un preset sbagliato |
| **N12** | **Sapere quanto vale davvero `EffectiveBuffer()` su un simbolo nuovo** | `max(InpBufferPoints, SYMBOL_TRADE_STOPS_LEVEL)` — r.2535-2541. Se lo stops level del simbolo supera il buffer, il buffer **cresce in silenzio**. Per D30EUR/XAUUSD/XAGUSD il valore e' **`[NON MISURATO]`** nel repo (serve una sonda `ABTG_InfoBroker`) |

---

## 2. 📋 TABELLA DEI SEI MODI (riferimento: `ABTG_DAX_Apertura_EU.mq5`)

`R` = `gRangeHigh − gRangeLow` · `B` = `EffectiveBuffer()` (r.2535) · `S` =
`InpSlippagePts` · `O` = `InpRetestOffsetPts` · `F` = `InpFadeOffsetPts` · `A` =
`AtrValue()×InpAtrSlMult`. Tutte le formule sono per `InpSLMode = ABTG_SL_RANGE` (la
configurazione di campo, pin `InpSLMode=0`).

| # | modo | vivo? | dove decide | ordine | ENTRY | **DISTANZA INGRESSO→SL** | input SUOI | tetto/giorno |
|---|---|---|---|---|---|---|---|---|
| **0** | BREAKOUT | 🟢 vivo | `TryPlaceBreakout` r.1167, da `PH_BUILDING` r.881-884 | **2 STOP** (BuyStop r.1210 + SellStop r.1234), scadenza `InpPendingExpiryMin` | `H+B+S` (r.1183,1197) | **`R + 2B + S`** (SL `L−B`, r.1184,1198) | `InpBufferPoints`, `InpSlippagePts`, `InpPendingExpiryMin` | **1 decisione**, ma 🔴 **2 pendenti vivi insieme** → fino a 2 posizioni (vedi §4.2) |
| **1** | GAPFILL | 🟢 vivo (nei 3 EA grandi) | `TryPlaceGapFill` r.2011, r.847-850 | **1 STOP** (lato imposto dal segno del gap) | gap-down → `hi+B` (r.2063); gap-up → `lo−B` (r.2048) | **`R_apertura + 2B`** (SL `lo−B`/`hi+B`, r.2049/2064) — 🔴 **identica al BREAKOUT** | `InpGapMinPoints`, `InpGapMinRR`; `InpUseGapFill` **IGNORATO** (r.574) | 1 |
| **2** | RETEST | 🟢 vivo, **l'unico in campo** | arma r.1569, decide `MonitorRetest` r.1907 in `PH_ARMED` | **1 LIMIT** sul livello rotto (r.1957/1998) | long `H−O` (r.1930); short `L+O` (r.1973) | **`R + B − O`** (SL `L−B` = `sellPx`, r.1915,1931) — **la piu' STRETTA delle sei** | `InpRetestOffsetPts`, `InpAllowReverse`, `InpSpaceMode` (solo qui) | 1 (2 con `InpAllowReverse`, r.782) |
| **3** | RANGE_FADE | 🟢 vivo | `TryPlaceRangeFade` r.1257, r.858-862 | **2 LIMIT** (SellLimit sul massimo r.1292, BuyLimit sul minimo r.1309) | short `H+F` (r.1286); long `L−F` (r.1303) | 🔴 **`A = InpAtrSlMult × ATR(TF del grafico)`** (r.1277,1287,1304) — **NON dipende dal range**, e **ignora `InpSLMode`** | `InpFadeOffsetPts`, `InpAtrSlMult`, `InpAtrPeriodMgmt` | 1 decisione, **2 limit vivi** (come il modo 0) |
| **4** | DELAYED | 🟢 vivo | `TryPlaceDelayed` r.1364, r.870-877 | **MERCATO** (r.1451/1458) | `ask`/`bid` al momento della decisione (r.1427) | **`entry − L`** (SL = `gRangeLow` **NUDO, senza buffer**, r.1429) → dipende da dove sta il prezzo | `InpDelayMinutes`, `InpDelayDirMode`; `InpPendingExpiryMin` come **finestra d'attesa** (r.1399-1403) | 1 |
| **5** | OPENCONFIRM | 🟢 vivo | arma r.1483, decide `MonitorOpenConfirm` r.1506, **una valutazione per candela** (r.1511) | **MERCATO** (r.1560) | `ask`/`bid` quando una candela **apre** oltre `H+B` (r.1517,1534) | **`entry − (L−B)` ≥ `R + 2B`** (r.1536) | `InpOCTimeframe`, `InpUseVolumeFilter` (letto sul TF di conferma, r.1527) | 1 |

### 2.1 Input che nei pin di campo **disattivano o svuotano** un modo
Pin letti da `prove/R241b_modoingresso_DAX_long.txt` (80 pin presi dal `.chr` della sedia viva):
- `InpMaxSpread=0` → `SpreadOK()` **ritorna sempre true** (r.2653): nessun cancello di spread, in nessun modo.
- `InpMinStopPts=0` → il pavimento non morde **mai**, e con lui `InpSkipIfTight` e' inerte.
- `InpUseVolumeFilter=false` + `InpUseAtrFilter=false` → `ConfirmOK()` ritorna true (r.2673): i modi 0/1/3/4 non filtrano niente; i modi 2/5 non filtravano comunque (N9).
- Cinque filtri di trend spenti → `TrendBias()` ritorna **0** (r.2120-2162, ramo per ramo): **tutti e due i lati sempre validi**.
- `InpFadeOffsetPts=0`, `InpDelayMinutes=30`, `InpDelayDirMode=0`, `InpOCTimeframe=0` (=`PERIOD_CURRENT`): **mai tarati**, sono i valori che il modo *trova*, non quelli che gli servono.

---

## 3. ⚠️ DUE MODI POSSONO PRODURRE LA STESSA CELLA? **SI', IN TRE MODI DIVERSI**

**C1 — GAPFILL = BREAKOUT, geometria identica al centesimo.** Entry `hi+B`, SL `lo−B`
(r.2063-2064) sono **le stesse** del BREAKOUT (r.1183-1184,1197-1198). Differenze vere:
(a) il lato lo sceglie il **segno del gap**, non il mercato; (b) il TP e' `prevClose`
(r.2041) invece di `TpTotalR()`; (c) c'e' il cancello `InpGapMinRR` (r.2054); (d)
🔴 **GAPFILL ignora `InpRangeMode`**: calcola sempre la finestra d'apertura
(`ComputeRangeWindow(openMin, openMin+InpRangeMinutes)`, r.2039). 👉 **con
`InpRangeMode=0` le due celle condividono ingresso e stop; con `InpRangeMode=2` no.**
Prova storica che la collisione e' reale: `MOTORI_INGRESSO.md` — *«GAPFILL da' numeri
identici a BREAKOUT»* — e il controllo che l'ha sanata, `REFERTO_FASE_B_C5.md`:
*«GAPFILL ≠ BREAKOUT: prima identici al centesimo su 8 righe, ora diversi su 8 su 8»*.

**C2 — la ricaduta silenziosa, VIVA in 7 file su 12.** Vedi **N7**. In Marco, nei due
`_Ottimizzato` e nei quattro `standalone` la cella 1 **e'** la cella 0.

**C3 — `InpEntryMode` NON SIGNIFICA LA STESSA COSA IN TUTTA LA FAMIGLIA.** 🔴 In
`ABTG_Apertura_3Ingressi.mq5` l'input ha lo stesso nome ma un **altro enum**
(`ENUM_ABTG_STYLE`, r.199-204): **0 = STOP(breakout) · 1 = RETEST · 2 = CLOSECONFIRM**,
tradotto in `OnInit` r.561-566. 👉 un file prova con `InpEntryMode=1` misura **GAPFILL**
sul DAX e **RETEST** su 3Ingressi. E' una trappola da dichiarare in ogni riga.

**Non-collisioni verificate**: 2 vs 0 (LIMIT dentro il livello contro STOP oltre: entry
diverse di `B+O`, stop diversi di `B+O+S`); 5 vs 0 (stesso trigger, ma l'uno entra a
mercato all'apertura di una candela e l'altro con un pendente appoggiato — lo stop del
5 e' `≥` quello dello 0, mai uguale salvo che l'apertura cada esattamente su `H+B`);
4 vs 0 (il 4 non usa il buffer **ne' all'ingresso ne' allo stop**).

---

## 4. 🎯 LO STOP CAMBIA FRA I MODI — e il 33,0x del RETEST **non si trasferisce**

### 4.1 L'algebra, poi i numeri
Sulla geometria viva del DAX (`InpBufferPoints=500` = **5 idx**, `InpRetestOffsetPts=200`
= **2 idx**, `InpSlippagePts=0`, `InpSLMode=0`):

| modo | formula | in punti indice | stop/spread @ **1,70** (BCM ora 8) | 40x? |
|---|---|---|---:|:---:|
| **2 RETEST** | `R + B − O` = `R + 3` | **56,1 [MIS]** n=2 | **33,0x** | 🔴 NO |
| **0 BREAKOUT** | `R + 2B + S` = `R + 10` | 63,1 **[INF]** | **37,1x** | 🔴 NO (ma +12%) |
| **1 GAPFILL** | `R + 2B` = `R + 10` | 63,1 **[INF]** | **37,1x** | 🔴 NO — *identico allo 0* |
| **5 OPENCONFIRM** | `entry − L + B` **≥** `R + 2B` | **≥** 63,1 **[INF, limite inferiore]** | **≥ 37,1x** | 🟠 non deciso |
| **4 DELAYED/BREAK** | `entry − L`, con `entry > H` | **>** 53,1 **[INF, limite inferiore]** | **> 31,2x** | 🟠 non deciso |
| **4 DELAYED/MID** | `entry − L`, con `entry ≥ (H+L)/2` | **[R/2, R]** ≈ 26,6-53,1 | **15,6-31,2x** | 🔴 NO, per costruzione |
| **4 DELAYED/CANDLE** | `entry − L`, `entry` qualunque > `L` | **(0, ∞)** | 🔴 **non limitato in basso** | 🔴 pericoloso (§4.4) |
| **3 RANGE_FADE** | `1,5 × ATR(14, TF del grafico)` | **`[NON MISURATO]`** | soglia: serve **ATR ≥ 45,3 idx** | 🔴 quasi certo NO |

**Fonte del 56,1 e dell'1,70**: `report/CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.398.

**Come ricavo `R ≈ 53,1 idx`**: dalla formula del RETEST, `R = 56,1 − 3`. E' una
**INFERENZA**, non una misura.
🧪 **Contro-esempio, costruito prima di consegnare**: un'altra fonte, indipendente da
questa algebra, scrive *«gli stop veri di queste tre nascono dal range dei primi 35 minuti,
che vale tipicamente 40-80 punti indice»* (`report/SPREAD_APERTURA_FTMO_2026-09-21.md`
§3). **53,1 cade dentro 40-80.** Se fosse caduto fuori, l'algebra sopra sarebbe da buttare.

### 4.2 🔴 Il verdetto del RETEST e' il piu' SEVERO della famiglia, non il piu' mite
Il RETEST ha **la distanza piu' corta di tutte** le geometrie a range (`R+3` contro
`R+10`), perche' entra **dentro** il livello mentre lo stop resta **fuori** dal buffer
opposto. 👉 Conseguenza che vale per il progetto dei round: **il 33,0x e' un LIMITE
INFERIORE per i modi 0, 1 e 5**. Nessuno di loro puo' stare **sotto** il RETEST. Non
"passano" per questo — 37,1x resta sotto 40 — ma **la direzione dell'errore e' nota**, e
non e' quella che si temeva.

### 4.3 🟠 E lo stesso stop, sul feed dove la challenge opera davvero, **passa**
`SPREAD_APERTURA_FTMO_2026-09-21.md` §1: `GER40.cash`, ora 10 server FTMO (= apertura
DAX), **mediana 123 / P95 133 punti MT5** = **1,23 / 1,33 idx**. Sullo stesso stop di
56,1 idx: **42,2x al P95** e **45,6x alla mediana**. 🔴 **Il "33,0x NON passa" e' un
numero BCM**; su FTMO la stessa geometria sta sopra il 40x. Non lo dichiaro come verdetto
— quella misura e' **`GG = 1`**, una giornata sola, e il referto stesso lo marca SOTTILE —
ma **e' la domanda piu' economica sul tavolo**: cinque giornate di spread logger FTMO
costano zero tempo macchina e possono spostare un cancello.

### 4.4 🔴 DUE RISCHI DI SICUREZZA che un round sui modi accenderebbe
1. **DELAYED + `ABTG_DIR_CANDLE`** sceglie la direzione dal **corpo della candela**
   (r.1324-1349) e poi mette lo stop sul bordo opposto del range. Se il prezzo e' gia'
   tornato **vicino a quel bordo**, `dist` e' positiva ma **minuscola** (l'unico controllo
   e' `dist <= 0`, r.1433). Con `InpMinStopPts = 0` (il pin di campo) `CalcLotByRisk`
   (r.2251) divide il rischio per una distanza quasi nulla → **lotto al massimo consentito
   dal broker**. 👉 **prima di girare una cella DELAYED, `InpMinStopPts` va acceso.**
2. **Guardian che brucia il lato**: in `MonitorRetest` il flag `gBrokeHigh` e' messo a
   `true` **prima** del controllo (r.1925) e il Guardian e' interrogato **dopo**
   (r.1955): se blocca in quell'istante, il lato e' consumato per la giornata **senza un
   ordine**. Vale solo per il modo 2 (negli altri il Guardian sta prima di tutto,
   r.1194/1283/1448/2043 → `return false` → si riprova al tick dopo).

---

## 5. 🔁 LA MACCHINA A STATI: il tetto di 1 operazione al giorno vale **quasi** per tutti

### 5.1 Chi mette il tetto **non e' `InpOneTradePerDay`**
`InpOneTradePerDay` (r.269) alimenta solo la **guardia reload-safe A4** (r.767-800), che
legge lo storico deal e serve contro ricompilazioni/riavvii. 👉 **Dentro lo Strategy
Tester non ci sono riavvii: quell'input e' sostanzialmente INERTE.** Metterlo a `false`
in un file prova **non aumenta le operazioni**.

Il tetto vero e' **strutturale**: `gPhase` avanza a `PH_PLACED`/`PH_DONE` e **`ResetDay()`
(r.1077) gira solo al cambio giorno** (r.744-749). In `PH_PLACED` si chiama solo
`MonitorReverse()` (r.899), che esce subito se il modo non e' RETEST (r.1029).

### 5.2 Modo per modo — e **no, i modi a mercato non aprono piu' volte**
| modo | dove si chiude la giornata | puo' aprire 2 volte? |
|---|---|---|
| 0 BREAKOUT | `PH_PLACED` r.883 | 🟠 **una sola DECISIONE, ma DUE pendenti vivi** (r.1210 e r.1234). L'OCO (`HandleOCO`, r.2310) cancella l'altro **al tick successivo**: in un movimento veloce possono riempirsi entrambi. `[NON MISURATO]` quante volte succede |
| 1 GAPFILL | `PH_PLACED` r.850 | 🟢 no — un solo lato, scelto dal segno del gap |
| 2 RETEST | `PH_PLACED` dentro `MonitorRetest` r.1957/1998 | 🟢 no; 🟠 **2 con `InpAllowReverse=true`**, tetto riletto dallo storico (r.782, r.1042) |
| 3 RANGE_FADE | `PH_PLACED` r.862 | 🟠 come lo 0: **due LIMIT opposti vivi insieme** |
| 4 DELAYED | `PH_PLACED` r.877 — e `TryPlaceDelayed` ritorna `true` **anche se l'ordine fallisce** (r.1455/1462) | 🟢 no: al massimo si perde la giornata |
| 5 OPENCONFIRM | `PH_PLACED` r.1563 solo **a ordine riuscito** | 🟢 no. 🟠 Se fallisce resta `PH_ARMED` e **riprova alla candela dopo**: piu' tentativi, **una sola posizione** |

### 5.3 🔴 «Nessuna cella arrivera' a n≥150» — **VERO per R241a/b, FALSO in generale**
- Il round R241 **pinna un lato solo** (`InpAllowShort=false` in b, viceversa in a): con un
  lato solo ogni modo fa **al massimo 1 posizione al giorno**, e l'IS (40% di ~455 giornate
  feriali) vale **~180 giornate**. Per arrivare a 150 servirebbe l'**83% di giornate
  riempite**: col LIMIT del RETEST e' implausibile. ✅ La frase regge **per quel round**.
- 🔴 **Ma il walk-forward gia' in archivio la smentisce come regola**: `REFERTO_FASE_B_C5.md`
  (due lati accesi) riporta **n IS 179-186 e n OOS 243-250** su cinque motori su sei. **Sopra
  150 in IS.** La differenza non e' il motore: e' il **lato pinnato**.
- 🟢 **E c'e' una configurazione che decide TUTTI i giorni, per costruzione**: **DELAYED +
  `ABTG_DIR_MID`**. Il codice dice *«c'e' sempre una direzione»* (r.222) e il ramo e'
  `dir = (bid >= mid) ? +1 : -1` (r.1410) — nessun caso "niente trade". Con i due lati
  accesi, i filtri spenti (`TrendBias()=0`) e `InpMaxSpread=0`, **ogni giornata di mercato
  produce un ingresso**. 👉 **e' l'unica leva di FREQUENZA della famiglia**, ed e' quella
  che l'obiettivo del 1° ottobre chiede. Costo: e' anche la cella con lo stop **piu'
  stretto** fra i modi a range (§4.1, 15,6-31,2x) — la frequenza la paga il costo.

---

## 6. 🌍 I SIMBOLI: le cinque varianti, e che cosa cambia DAVVERO

### 6.1 Nessuna logica e' inchiodata a un simbolo
`grep` su `_Symbol ==`, `StringFind(_Symbol`, `D30EUR`, `NASUSD`, `U30USD` nei tre EA
grandi: **zero occorrenze nella logica**. I nomi compaiono solo in commenti,
nell'etichetta passata al Guardian (r.1194 ecc., stringa letterale
`"ABTG_DAX_Apertura_EU"` — su un altro simbolo il giornale del Guardian mentirebbe sul
nome, senza conseguenze operative) e in `InpCorrSymbol` (r.315, filtro spento).
👉 **Un EA della famiglia gira su un simbolo qualunque cambiando `InpSessionHour`** — con
i due caveat **N11** (buffer/pavimenti in punti) e **N12** (stops level ignoto).

### 6.2 Le differenze VERE fra le cinque varianti (non i default)
| EA | modi | ha SOLO lui | non ha |
|---|---|---|---|
| **`ABTG_DAX_Apertura_EU`** 2885 righe | **6** | `InpAllowReverse` (r.291, 2 cicli) · **filtro dello SPAZIO** `InpSpaceMode` (r.395-403) · `MonitorReverse` (r.1026) | F1, VolRegime, SRFilter, RunnerTP |
| **`ABTG_Dow_Apertura_US`** 2205 | **6** | — (e' il motore "nudo" a sei modi) | reverse, spazio, F1, VolRegime, SR, runner |
| **`ABTG_Nasdaq_Apertura_US`** 2644 | **6 + 1** | 🔴 **un SETTIMO meccanismo**: `InpMinBreakoutRangeATR` (r.324) trasforma il BREAKOUT in **entrata a MERCATO sulla CHIUSURA** di una candela ampia (`ArmBreakout` r.1389, `MonitorBreakoutStrength` r.1420) · `InpUseVolRegime` (r.343) · `InpUseSRFilter` (r.361) · `InpRunnerTP_R` (r.282) | reverse, spazio |
| **`ABTG_Apertura_3Ingressi`** 2681 | **3 esposti** (enum diverso!) | 🔴 **un OTTAVO meccanismo**: `CLOSECONFIRM` — la candela deve **CHIUDERE** oltre (`MonitorCloseConfirm` r.1576) · guardia dei magic che rifiuta l'avvio (r.567) | **il Guardian** (include solo `Trade.mqh`, r.118) · reverse · spazio |
| **`ABTG_Apertura_Marco`** 1625 | **2** | `InpMaxPosSimbolo = 1` di default (r.192, *«EA RITIRATO»*) | tutto il resto; 🔴 **ha il bug N7** |
| `*_Ottimizzato` (2) · `standalone/` (4) | **2** | — | 🔴 **tutti col bug N7**: da non usare per misurare il GAPFILL |

🔴 **La famiglia non ha SEI meccanismi: ne ha OTTO** — i sei dell'enum + `F1`
(breakout-a-forza, solo Nasdaq) + `CLOSECONFIRM` (solo 3Ingressi). Due di loro **non
esistono nel binario del DAX**: per provarli sul DAX servirebbe un travaso di codice, che
questo censimento non fa.

### 6.3 Tabella simbolo × (quale EA · gira gia'? · cosa servirebbe)
| simbolo | quale EA | gira gia'? | cosa servirebbe |
|---|---|---|---|
| **D30EUR / GER40.cash** | `DAX_Apertura_EU` 770101 | 🟢 **sedia viva**, RETEST long-only | niente |
| **U30USD / US30.cash** | `Dow_Apertura_US` 770202 | 🟢 viva | niente |
| **NASUSD / US100.cash** | `Nasdaq_Apertura_US` 770260 | 🟢 viva (RETEST due lati) | niente |
| **100GBP (FTSE)** | uno qualunque | 🟠 **misurato una volta** (`risultati_archivio/Apertura_nuovi_indici/valid_Apertura_100GBP_FTSE.csv`) | `InpSessionHour` = apertura Londra in ora server + **N11/N12** |
| **F40EUR (CAC)** | uno qualunque | 🟠 citato in `REGISTRO_TEST.md` come gemello del meccanismo | idem 100GBP |
| **US500.cash / SPXUSD** | uno qualunque | 🔴 mai provato come **sedia** (solo come `InpCorrSymbol`) | idem |
| **XAUUSD** | uno qualunque | 🔴 **mai provato con questa famiglia** | §7 |
| **XAGUSD** | uno qualunque | 🔴 mai provato; 🟠 nessuna misura di spread argento nel repo → il 40x e' **`[NON MISURATO]`** | §7 + una sonda spread |

---

## 7. 🥇 E I METALLI? «Apertura» **di che cosa**

### 7.1 Il codice non sa che cos'e' un'apertura — e questa e' la buona notizia
`ComputeLevels` (r.1111-1128) conosce **tre** ancore, e **nessuna** delle tre nomina una
borsa:
1. `ABTG_RANGE_OPENING` — massimo/minimo **M1** della finestra `[ora, ora+N minuti]`
   (r.1123-1124 → `ComputeRangeWindow` r.1135, che lavora **su `PERIOD_M1`**, r.1145-1146);
2. `ABTG_RANGE_PREV` — la finestra di `InpPrevWindowMin` minuti **PRIMA** di quell'ora (r.1126);
3. `ABTG_RANGE_PREVBAR` — massimo/minimo della **candela precedente su `InpLevelTF`**
   (r.1115-1118): 🟢 **nessun orologio, nessuna sessione**.

👉 **Risposta secca: sull'oro il concetto di "range di apertura" ha senso quanto l'ancora
che gli si da', e il codice OGGI sa gia' ancorarsi a qualunque ora del server.** Non serve
codice nuovo per provare l'oro su: apertura di Londra, apertura di New York, il box
notturno, o nessuna ora affatto (modo 3).

### 7.2 Quale ancora ha senso — e la casa ha gia' un precedente MISURATO
- 🟢 **Il box notturno + rottura all'apertura di Londra esiste gia' su oro**, in un
  **altro** EA: `ABTG_MaxMinNotte` sedia **770402 XAUUSD** — box 00:00→05:59 IT, ordini
  alle 08:00 IT, cutoff 09:30 IT (`mql5/Presets/FTMO/ABTG_MaxMinNotte_ORO_770402_FTMO.set`).
  La famiglia Apertura puo' riprodurre la **stessa** ancora con `InpSessionHour` +
  `InpRangeMinutes`, senza scrivere niente.
- 🔴 **L'ancora 09:30 ET sull'oro e' gia' stata misurata, in tutti e due i versi, ed e'
  BOCCIATA**: seguire l'esplosione perde (`report/ORO_2021_2026_LA_MISURA_2026-09-22.md`),
  e **il fade** e' bocciato *«e non per un pelo»* su **due campioni indipendenti**
  (`report/ORO_FADE_0930_LA_MISURA_2026-09-22.md`). 👉 **una cella "Apertura US su oro"
  nasce con un precedente contrario da citare**, non in terra vergine.
- 🔴 **GAPFILL sull'oro e' quasi inerte, per aritmetica**: legge `iClose(D1,1)` e
  `iOpen(D1,0)` (r.2013-2014). Su un simbolo che tratta ~24h il "gap" infrasettimanale e'
  solo la pausa di rollover; con `InpGapMinPoints=150` (**1,50 $** se `_Point = 0,01`)
  resterebbero **i lunedi'** — e per **N3** non c'e' modo di selezionarli. Frequenza
  attesa ~1/settimana.

### 7.3 Il cancello del costo sull'oro, che e' **piu' duro** di quello degli indici
`report/ORO_1530_CANCELLO_COSTO_2026-09-10.md` §: pavimento **40x** = **6,40 $**
(spread 0,16 $, l'ipotesi piu' favorevole) → **8,01 $** col costo pieno misurato
(spread + commissione 0,0403 $) → **10,41 $** con lo spread prudente 0,22 $. Su FTMO lo
spread oro misurato e' **45 punti** (`SPREAD_APERTURA_FTMO_2026-09-21.md` §1): se
`_Point = 0,01`, sono **0,45 $** → pavimento **18,00 $**.
👉 **Qualunque ancora si scelga sull'oro, lo stop deve stare sopra ~8 $ (BCM) / ~18 $
(FTMO).** Uno stop a range d'apertura di 30' sull'oro vale **`[NON MISURATO]`** — ed e'
**la prima cosa da misurare**, perche' se il range vale 5-10 $ la famiglia e' esclusa
**per costo** prima ancora di girare.
⚠️ `_Point` di `XAUUSD` sui terminali di casa e' **`[NON MISURATO]`** nel repo (assumo 2
decimali). Con 3 decimali tutti i numeri in punti di questo paragrafo vanno divisi per 10.

---

## 8. 📐 I TF: che cosa si sveglia se si cambia il grafico

`PERIOD_CURRENT` / `Period()` compaiono in **4 punti** (`grep`): r.278, r.510, r.1508, r.2720.

| punto | riga | oggi (M5) | se si sale a M30/H1 |
|---|---|---|---|
| **ATR di gestione** | **510** `iATR(_Symbol, PERIOD_CURRENT, InpAtrPeriodMgmt)` | ATR(14) su M5 | 🔴 **si sveglia forte**: ATR(H1) ≈ ATR(M5)×√12 ≈ **3,5×**. Tocca: **lo stop del RANGE_FADE** (r.1277), `InpSLMode=ATR` su tutti i modi, il trailing ATR, `AtrOK()`, e il ripiego di `riskDist` in `ManageOneTicket` (r.2355) |
| **`InpOCTimeframe`** | **278 / 1508** | `PERIOD_CURRENT` → OPENCONFIRM valuta **ogni 5'** | 🔴 **cambia il meccanismo**: su H1 le occasioni sono poche e l'ingresso avviene all'apertura dell'ora. E' un **input**, quindi si puo' pinnare e disaccoppiare dal grafico |
| **`VolumeOK()`** | **2720** | inerte (`InpUseVolumeFilter=false`) | 🟠 si sveglia **solo** se si accende il filtro volumi |
| **la CANDELA di rottura (solo Nasdaq F1)** | `ABTG_Nasdaq_Apertura_US.mq5` r.1421 `(ENUM_TIMEFRAMES)Period()` | — | 🔴 il TF **e' il meccanismo**, non c'e' input per staccarlo |

### 🟢 E quello che **NON** si sveglia, ed e' la notizia utile
- **I livelli non cambiano**: `ComputeRangeWindow` lavora **sempre su M1** (r.1145-1146) e
  `RANGE_PREVBAR` su `InpLevelTF` (input). 👉 **il range d'apertura e' invariante al TF del
  grafico.**
- **Il trailing non cambia**: `InpTrailTF` e' un input esplicito (r.336, pinnato M5).
- **La macchina a stati non cambia**: e' guidata dai **tick** e dall'orologio
  (`TimeInMinutes`, r.1100), non dalle barre — tranne OPENCONFIRM e F1.
- 👉 **Conseguenza per i round**: salire di TF su questa famiglia **non e' un cambio di
  strategia**, e' un cambio di **due** cose sole (l'ATR di gestione e il passo di
  OPENCONFIRM). 🔴 **E questo rende il TF la casella ⑤ mancante del RANGE_FADE
  spendibile in modo pulito**: su M30/H1 lo stop del fade sarebbe ~2,4-3,5× quello di M5,
  cioe' l'unica strada per cui quel motore potrebbe passare il 40x. Resta un motore
  **0/48 su M5**: e' un tentativo di **meccanismo/TF**, non una griglia di parametri —
  quindi lecito per la regola del 19/08, ma va dichiarato per quello che e'.
- ⚠️ Vincolo di banco: l'EA **pretende comunque la storia M1**. Il modello va a **tick
  reali**; con «solo prezzi di apertura» su TF alto la macchina si spegne.

---

## 9. 🕳️ CHE COSA RESTA `[NON MISURATO]` — con la strada per chiuderlo

| # | cosa | strada piu' corta |
|---|---|---|
| **M1** | la distanza ingresso→SL **di ogni modo**, in punti veri | una **FASE 1** a passata singola (`Optimization=0`) che lasci girare le `Print`: 6 passate, si legge dal Giornale. E' l'unica cosa che sblocca il 40x sulle celle 0,1,3,4,5 |
| **M2** | `ATR(14)` sul TF del grafico per D30EUR/NASUSD/U30USD/XAUUSD | la stessa FASE 1 (la riga del fade stampa `slDist`), oppure una sonda di 10 righe |
| **M3** | `SYMBOL_TRADE_STOPS_LEVEL` e `_Point` dei simboli bersaglio | `ABTG_InfoBroker` (gia' in casa: `sonda_storico_17-08/..._ABTG_InfoBroker.csv`) |
| **M4** | lo spread **FTMO** su 5 giornate (oggi `GG=1`) | lo spread logger gira gia'; si raccoglie venerdi' 25/09. 🟠 **puo' ribaltare il cancello del DAX** (§4.3) |
| **M5** | quante volte **entrambi** i pendenti di BREAKOUT/FADE si riempiono nello stesso giorno | si conta dal per-trade di un round gia' in archivio (`aperture_r42/`), non serve tester |
| **M6** | il range d'apertura dell'**oro** in $ su un'ancora scelta | sonda su M1, zero tempo di tester: decide **prima** se la famiglia e' escludibile per costo |
| **M7** | `RANGE_FADE` su TF ≠ M5 e su simboli ≠ {D30EUR, NASUSD} | la casella ⑤ del certificato di morte. **Unica** estensione lecita su quel motore |

---

## 10. ✅ LE TRE COSE DA PORTARSI VIA

1. 🔴 **Non progettare R241 come uno screening di cinque modi ignoti**: cinque su sei hanno
   gia' **PF, n e DD** in archivio, uno (`RANGE_FADE`) ha un round dedicato **0/48**, e uno
   (`OPENCONFIRM` volumi OFF sul DAX) e' **positivo fuori campione con n=250** e nessuno lo
   ha raccolto. Il round va riscritto attorno a **quello che manca**, non a quello che c'e'.
2. 🔴 **Il 33,0x non si trasferisce, ma la sua direzione si': il RETEST e' il piu' stretto
   della famiglia.** I modi 0/1/5 stanno **sopra** (≈37,1x [INF]); il modo 3 e' un altro
   mondo (ATR, non range) e il modo 4 puo' scendere **sotto** — fino a un pelo, con
   `DIR_CANDLE` e `InpMinStopPts=0`.
3. 🟢 **La frequenza, che e' il requisito n.1 di ottobre, ha una sola leva nel codice di
   oggi: `DELAYED` + `DIR_MID` + due lati** — decide ogni giornata per costruzione. Costa
   lo stop piu' stretto. E' un compromesso da misurare, non da scegliere a tavolino.

---

_Censimento di sola lettura. Nessun `.mq5` modificato, nessuna riga di lancio prodotta,
nessuna sedia toccata. Ogni numero qui dentro o porta il suo file:riga, o porta
`[MIS]`/`[INF]`/`[NON MISURATO]`._
