# 💸 I MORTI E IL PEDAGGIO — tutti i candidati archiviati riletti col **cancello di costo** e col **modo di stop**

**23/09/2026** · branch `lavoro` · famiglia di sigle **`R216`**
🛑 **SOLA LETTURA.** Nessun round lanciato, nessuna riga di lancio consegnata, niente VPS,
niente forward, nessun preset toccato, nessuna sedia toccata, **nessuna taglia e nessun
parametro di rischio proposti** (quelli li firma Claudio). Qui ci sono **numeri**, non decisioni.

---

> ## 🎯 IL VERDETTO IN SETTE RIGHE
> 1. 🔥 **La scoperta di stanotte sull'ORB non è un caso isolato: si ripete IDENTICA su
>    `ABTG_MaxMinNotte`.** Le tre sedie notturne uccise su CAC / Stoxx / FTSE sono girate
>    **tutte e 216 le passate** con `InpSLMode=1` e `InpAtrSLmult=1.5`. Sul DAX quel valore
>    vale **30,9× lo spread — SOTTO la frontiera dei 40×**. La sedia sopravvissuta (`770411`)
>    gira a **2,5 ⇒ 51,5×: PASSA**. 👉 **Le morte stavano sotto il cancello, la viva sopra.**
> 2. 🟢 **E l'asse esiste già misurato, in casa, su RF.** `valid_MaxMin_DAX_short_refine.csv`
>    mette `InpAtrSLmult` ad asse (1,5 / 2,0 / 2,5) su D30EUR: sulle celle filtrate il
>    **Recovery Factor sale monotòno 0,71 → 1,67 → 3,34**, e **2,5 è al BORDO dell'asse**.
>    Su XAUUSD `InpSLMode` è ad asse su 4 TF: il modo **0 (box opposto) batte il modo 1 (ATR)
>    sul RF E sul PF in 4 TF su 4** — e batte il modo 2 (FIXED) in 3 su 4.
> 3. 🔴 **MA il pedaggio da solo NON resuscita quei tre, e l'ho calcolato.** Passare da 1,5 a
>    2,5 vale **+0,037 di PF su F40EUR**, +0,032 su E50EUR, +0,028 su 100GBP. F40EUR va da
>    0,99852 a **1,035**: si avvicina, non arriva. E50EUR e 100GBP restano a 0,87 e 0,70.
>    **Solo F40EUR è un riapribile onesto.**
> 4. 🟢 **`ABTG_Londra_ORB` ha la stessa identica manopola mai toccata** —
>    `LDN_SL_MIDPOINT=0` (metà canale, quella che è girata) contro `LDN_SL_OPPOSITE=1`
>    (canale intero, **il doppio**) — e 🎁 **lo spread di GBPUSD NON è più `[NON MISURATO]`**:
>    l'ho trovato in `data/spread_vivo/`, **0,30 pip mediano** alle ore 07-16.
> 5. 🔴 **La trappola è reale e l'ho trovata dove non me l'aspettavo: su `ABTG_DAX_Live5m` il
>    terzo consumatore dello stop non è il trailing generico, è `InpTrailTF = M1` con
>    `InpTrailStartR = 0`.** Ogni vincente viene chiusa al **minimo della candela M1
>    precedente**. Cambiare `InpSLMode` lì sposta **il lotto e la perdita, non la vincita**.
>    👉 Su L1/L2 la manopola da mettere ad asse **non è lo stop**.
> 6. 🟢 **Il cancello di costo ASSOLVE tre morti su cui si stava per dare la colpa sbagliata**:
>    `Dow_Apertura` U30USD (**61,9×**), `Nasdaq_Apertura` NASUSD (**46,2×**), e tutta la
>    famiglia `SupRev`/`SuperWave` a H1 (**38,5-51,9× misurati**). Per quelli la causa è
>    un'altra, e va cercata altrove.
> 7. 🪦 **E uno muore MEGLIO di prima, con il numero**: `ABTG_ORB_Fibo`. Il suo stop è
>    **0,168 × l'estensione** (dal 61,8% al 78,6% di Fibonacci): per arrivare a 40× su NASUSD
>    servirebbe un'estensione di **429 punti indice all'ingresso tipico (61,8%) — più
>    dell'INTERA ADR giornaliera (384,6)** — e di **252 idx (il 66% dell'ADR) perfino nel
>    caso più favorevole**, ogni giorno. 🔴 **Non esiste un modo di stop nel sorgente che lo salvi.**
>    Il suo «DD 3,10%, il più basso della tabella» **è pedaggio travestito da prudenza**.

---

# 0️⃣ COME HO MISURATO — e le tre righe che tengono in piedi tutto

## 0.1 Le soglie, tenute DISTINTE

| soglia | valore | che cos'è |
|---|---:|---|
| **frontiera di lavoro** | `stop ≥ 40 × spread` | la regola di casa. Sotto ⇒ **escluso per costo** |
| **pavimento duro** | `stop ≥ 13,3 × spread` | sotto questo il motore **paga più del 7,5% del rischio a operazione**: non è un'esclusione, è un'impossibilità |
| 🔴 `[NON CALCOLABILE]` | — | **lo spread di quel simbolo non è mai stato misurato.** 👉 **NON è "escluso per costo"**: è una casella bianca |

## 0.2 Gli spread che ho usato — e **DUE fonti, non una**

**(A) Dai TICK del backtest** — `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv`,
finestra **2024.09.26 → 2026.06.30**, `% solo-bid = 0,000` su tutti e tre (⇒ a Model 4 lo
spread vero è stato usato davvero). **30,9 / 64,7 / 156,1 milioni di tick.**

| simbolo | h07 | h08 | h14 | h15 | h17-20 | h23-06 (notte) |
|---|---:|---:|---:|---:|---:|---:|
| `D30EUR` | **2,80** | **1,70** | 1,70 | 1,70 | 2,6-2,7 | **2,80 - 3,90** |
| `U30USD` | 2,60 | 2,60 | **2,00** | 2,00 | **1,90** | 2,7-2,8 |
| `NASUSD` | 2,40 | 2,50 | **1,80** | 1,80 | **1,70** | 2,3-2,5 |

*(mediane, punti indice, ora SERVER BCM)*

**(B) 🆕 DAL LOGGER VIVO — e questa fonte nei riesami del 22/09 non compare mai.**
`data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` · `ABTG_SpreadLogger`, demo BCM
**50503392**, campioni **04/09 → 11/09/2026**, **5 giornate**, ~3.600 campioni per ora.
🟢 **Copre CINQUE simboli in più** dei tre sopra:

| simbolo | unità | mediana (ore di lavoro) | p95 | 🟢 40× chiede | pavimento 13,3× |
|---|---|---:|---:|---:|---:|
| **`GBPUSD`** | pip | **0,30** (h07-16) | 0,70 | **12,0 pip** | 4,0 pip |
| **`EURUSD`** | pip | **0,20** (h03-08) · 0,30 (notte) | 0,40 | **8,0 - 12,0 pip** | 2,7-4,0 |
| **`USDJPY`** | pip | **0,30** (h02-08) | 0,80-1,00 | **12,0 pip** | 4,0 |
| **`XAUUSD`** | USD | **0,18-0,21** (h14-17) · 0,26-0,27 (notte) | 0,22-0,28 | **7,2 - 10,8 USD** | 2,4-3,6 |
| **`225JPY`** | idx | **22,0** (h01-07) · 35,0 (h08) | 35,0 | **880 - 1.400 idx** | 293-466 |

> ⚠️ **Differenza dichiarata fra le due fonti**: (A) è lo spread **dentro la finestra dei
> backtest**, (B) è lo spread **di oggi, cinque giornate, a mercato vivo**. Non sono
> intercambiabili. Dove uso (B) lo scrivo. 🟢 **Sono coerenti dove si sovrappongono**:
> D30EUR ore notturne (A) 2,80-3,90 contro (B) 2,80.

🔴 **Restano `[NON MISURATO]`**: `F40EUR` · `E50EUR` · `100GBP` · `SPXUSD` · `E35EUR` ·
e tutte le coppie forex diverse da EURUSD/GBPUSD/USDJPY (**EURJPY, USDCHF, CHFJPY, EURCHF,
GBPCAD**…). Elenco per nome al §4.

## 0.3 Gli ATR, e come li ho scalati

Ancora **max-per-data** misurata (`report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §2) e legge
`ATR(TF) = ancora × √(minuti / W)` **validata sul simbolo stesso** (D30EUR a H4: +0,3% ·
U30USD a H1: +1,5%).

| simbolo | ancora | W | M3 | **M5** | **M15** | M30 | H1 | H4 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `D30EUR` | 252,5 | 780 | **15,7** | **20,2** | **35,0** | 49,5 | 70,0 | 140,1 |
| `U30USD` | 379,5 | 1380 | 17,7 | **22,8** | 39,6 | 56,0 | 79,1 | 158,3 |
| `NASUSD` | 384,6 | 1380 | 17,9 | **23,2** | 40,1 | 56,7 | 80,2 | 160,4 |

⚠️ **M15/M30/H1/H4 sono `[DERIVATO]` dentro la banda validata. M3 e M5 sono `[DERIVATO] in
ESTRAPOLAZIONE sotto la banda**: la legge non è stata verificata sotto M15 e i numeri M3/M5
vanno letti come **ordine di grandezza**, non come misure. Li uso solo per dire «sopra o sotto
la frontiera», mai per un confronto al decimale.

## 0.4 🔴 La regola del 19/08, applicata caso per caso (non a slogan)

> *«non si allarga sui PARAMETRI di un motore già dichiarato senza edge; si allarga su
> MECCANISMI, simboli, TF, gestione dell'uscita»*

**Il modo di stop è un MECCANISMO**, non un parametro d'ingresso: cambiarlo è legittimo.
🔴 **Ma solo se il motore non era stato bocciato per DIREZIONE su campione ampio.** Ho
controllato il campione di ognuno e la colonna «19/08» della tabella madre dice l'esito.

---

# 1️⃣ 📋 LA TABELLA MADRE

**Legenda**: `MOD` = modello (🟡 tick / 🔴 OHLC) · `RATIO` = stop / spread mediano dell'ora
d'ingresso · `19/08` = il cambio di meccanismo è lecito? (🟢 sì / 🔴 no, bocciato per
direzione su campione ampio).

| # | motore | sym · TF | **formula dello stop (file:riga)** | stop in punti | spread (fonte) | **RATIO** | vs **40×** | vs **13,3×** | **esiste un modo alternativo? già misurato?** | 19/08 |
|---|---|---|---|---:|---:|---:|---|---|---|:-:|
| **1** | `ABTG_MaxMinNotte` *(morto su CAC)* | `F40EUR` M15 | `sl = entry − ATR(14,InpMgmtTF) × InpAtrSLmult` — `ABTG_MaxMinNotte.mq5:379` · modo scelto a r.377-379 | ATR M15 × **1,5** ⇒ `[NON CALCOLABILE]` in idx (ATR F40EUR mai misurato) | 🔴 **[NON MISURATO]** | 🔴 **[NON CALCOLABILE]** | — | — | 🟢 **SÌ, DUE**: `MM_SL_OPPOSITE=0` (box intero) e `MM_SL_FIXED=2` (`:112`). **Su questo simbolo MAI misurati: 72/72 passate a `InpSLMode=1`.** Sul gemello XAUUSD il modo 0 **batte il modo 1 su RF e PF in 4 TF su 4** | 🟢 |
| **2** | `ABTG_MaxMinNotte` *(morto su Stoxx)* | `E50EUR` M15 | id. | ATR M15 × 1,5 | 🔴 [NON MISURATO] | 🔴 **[NON CALCOLABILE]** | — | — | 🟢 id. — **72/72 a `InpSLMode=1`** | 🟢 |
| **3** | `ABTG_MaxMinNotte` *(morto su FTSE)* | `100GBP` M15 | id. | ATR M15 × 1,5 | 🔴 [NON MISURATO] | 🔴 **[NON CALCOLABILE]** | — | — | 🟢 id. — **72/72 a `InpSLMode=1`** | 🟢 |
| **3b** | ↳ **il gemello CALCOLABILE**, stesso EA, stessa griglia | `D30EUR` M15 | id. | **52,5 idx** (ATR M15 35,0 × 1,5) | 1,70 (A, h08) | 🔴 **30,9×** | 🔴 **NO (77%)** | 🟢 sì | 🟢 **a ×2,0 ⇒ 41,2× PASSA** · **a ×2,5 ⇒ 51,5× PASSA**. E ×2,5 è la sedia `770411` **viva** | 🟢 |
| **4** | `ABTG_Londra_ORB` | `GBPUSD` M5 | `sl = mid` (centro canale) **oppure** `gLow/gHigh` (estremo) — `ABTG_Londra_ORB.mq5:214` e `:229`, enum a `:30` | **metà del canale 06-07** ⇒ `[NON MISURATO]` | 🟢 **0,30 pip** (B, h07) | ⚪ `[NON MISURATO]` — **ma la soglia è nota: 40× ⇒ 12,0 pip · 13,3× ⇒ 4,0 pip** | — | — | 🔥 **SÌ: `LDN_SL_OPPOSITE=1` = canale INTERO, ESATTAMENTE IL DOPPIO. MAI MISURATO** (zero CSV in tutta la storia di git) | 🟢 |
| **5** | `ABTG_DAX_M3` | `D30EUR` M3 | `sl = stLine ∓ buf` (linea Supertrend M3) — `ABTG_DAX_M3.mq5:270` | linea ST M3 ⇒ `[NON MISURATO]`; i modi alternativi valgono **15,0-23,0 idx** (FIXED) e **15,7 idx** (ATR×1,0) | 1,70 (A, h08-16) | ⚪ `[NM]` sul modo girato; **8,8-13,5× sugli alternativi** | 🔴 **NO** | 🔴 **SOTTO o al filo** | 🟠 **Sì (`M3SL_ATR=1`, `M3SL_FIXED=2`, `:28`) ma NON SALVANO**: anche al massimo dell'asse `.ini` (2300 pt = 23,0 idx) si arriva a **13,5×**. 🔴 E `InpSLFixedPts` è stato **spazzolato su 6 valori senza mai essere letto** (inerte per costruzione) | 🟢 |
| **6** | `ABTG_DAX_Live5m` (L1) | `D30EUR` M5 | `sl = livello pendente opposto` (`InpSLMode=0 / ABTG_SL_RANGE`) — `ABTG_DAX_Live5m.mq5:658,675`; enum a `:152` | **2 - 6 idx** (pavimento strutturale = 2 × buffer) | 1,70 (A, h08) | 🔴 **1,2 - 3,5×** | 🔴 **NO** | 🔴 **SOTTO (9-26%)** | 🟠 **Sì (`ABTG_SL_ATR=1`) e alza a ~30,3 idx ⇒ 17,8× — MEGLIO ma ANCORA SOTTO.** 🔴 **E non è la manopola giusta: vedi §5** | 🟢 |
| **7** | `ABTG_Nasdaq_Live5m` (L2) `770203` | `NASUSD` M5 | id. (`ABTG_Nasdaq_Live5m.mq5:661,678`) | 2 - 6 idx | 1,80 (A, h14) | 🔴 **1,1 - 3,3×** | 🔴 **NO** | 🔴 **SOTTO** | 🟠 id. — ATR M5 × 1,5 ⇒ 34,7 idx ⇒ **19,3×**, ancora sotto | 🟢 |
| **8** | `ABTG_DAX_Live5m_v2` (L3) | `D30EUR` M5 | id. **+ floor** `InpMinStopPts` — `ABTG_DAX_Live5m_v2.mq5:678-681` | 2 - 6 idx (floor girato a **2-4 idx**) | 1,70 (A) | 🔴 **1,2 - 3,5×** | 🔴 **NO** | 🔴 **SOTTO** | 🟢 **SÌ, E QUESTA È LA CASELLA PIÙ PULITA DEL DOSSIER**: `InpMinStopPts` **esiste già come floor che ALLARGA** (`InpSkipIfTight=false` ⇒ r.681 riscrive lo stop). È stato provato a **200-400 pt = 2-4 idx contro una frontiera di 6.800 pt = 68 idx**. 🔴 **Non è "provato e non funziona": è provato al valore sbagliato** | 🟢 |
| **9** | `ABTG_ORB_Fibo` (O2) | `NASUSD` M5 | `sl = gExt ∓ InpFibSL × r − buf`, ingresso in `gz2 = 61,8%` — `ABTG_ORB_Fibo.mq5:219, 258-260` ⇒ **stop = (0,786 − 0,618) × r = 0,168 r** | `[NON MISURATO]` (r = estensione) | 1,80 (A, h14) | ⚪ `[NM]` — **ma la soglia è brutale: 40× ⇒ r ≥ 429 idx** (ingresso a 61,8%, stop 0,168 r) o **r ≥ 252 idx** (ingresso al 50%, stop 0,286 r) **contro un'ADR di 384,6** | 🔴 **quasi certamente NO** | 🔴 **a rischio** | 🔴 **NO, nessun modo di stop nel sorgente.** Solo `InpFibSL` (0,786) e `InpSLBufferPts` (0). Per arrivare a 72 idx il buffer dovrebbe valere **~45-60 idx**, cioè **diventare lui lo stop**: è un altro motore | 🟢 |
| **10** | `ABTG_Nightly` (C1-C4) | `EURCHF`·`EURUSD`·`GBPUSD`·`USDCHF` M5 | `slDist = InpSLpips>0 ? InpSLpips : InpSLatrMult × QB` (QB = vol. notturna H1) — `ABTG_Nightly.mq5:220` | `[NON MISURATO]` (QB mai misurato) | 🟢 EURUSD **0,30** · GBPUSD **0,30** (B, notte) · 🔴 EURCHF/USDCHF **[NM]** | ⚪ `[NM]` — soglia: **40× ⇒ 12,0 pip di stop** su EURUSD/GBPUSD | — | — | 🟢 **SÌ: `InpSLpips` (stop fisso) esiste ed è a ZERO in 100% dei CSV. `InpSLatrMult` vale 1,0 in 100% dei CSV. LA MANOPOLA DELLO STOP NON È MAI STATA MOSSA, su 20 file su 20** | 🟢 |
| **11** | `ABTG_CostToCost` (A1-A6) | 28 coppie H4 | `sl = punta ∓ InpSLBufferATR × ATR(InpTF)` — `ABTG_CostToCost.mq5:808-809` | distanza ingresso→punta (grande su H4) | 🔴 EURJPY/USDCHF/CHFJPY **[NM]** | 🔴 **[NON CALCOLABILE]** | — | — | 🟠 **Nessun enum di modo.** Unica manopola `InpSLBufferATR = 0,2` — **costante in 100% dei CSV (mai ad asse)**. 🟢 Ma su H4 forex lo stop è strutturalmente largo: **il pedaggio NON è il sospetto principale** | 🟢 |
| **12** | `ABTG_MeanRevert` (D1) | `GBPUSD` H1 | `sl = 2 × entrata − tp` (**specchio del target**) — `ABTG_MeanRevert.mq5:232` | = distanza del TP | 🟢 0,30 pip (B, h da definire) | ⚪ `[NM]` | — | — | 🔴 **NESSUNO. Non esiste una manopola di stop in tutto l'EA**: lo stop È il target ribaltato. Il punto ③ del certificato su questo motore è **NON APPLICABILE** | 🔴 **12/12 celle in perdita su n fino a 1.160** |
| **13** | `ABTG_TurnaroundTuesday` (D2) | `GBPUSD` H1 | `slDist = ATR(D1, InpATRPeriodD1) × InpSLDailyATRMult` — `ABTG_TurnaroundTuesday.mq5:625` | ATR(D1) × 0,50/0,75/1,00 | 🟢 0,30 pip (B) | ⚪ `[NM]` (ATR D1 GBPUSD non misurato in casa) | — | — | 🟢 **GIÀ MISURATO, e chiude**: `InpSLDailyATRMult` è ad asse su **3 valori** in `Notte_16-08/*_tt1.csv`, e l'esito è **0 celle positive su 24 in OOS** con tutti e tre. 🪦 **Il modo di stop qui NON è una casella libera** | 🔴 **0/24 OOS, 11.928 trade** |
| **14** | `ABTG_SupertrendReversal` / `SupRev_*_Ott` | `U30USD`·`D30EUR`·`NASUSD` H1 | `sl = min(stLine, low di InpSLLookback barre) − InpSLBufferPips` — `ABTG_SupertrendReversal.mq5:386-389` | 🟢 **77,1 - 98,6 idx `[MISURATO]`** (n=4 e n=10, forward `770511`) | 1,90 (A, h17) · 2,00 (h14) | 🟢 **38,5 - 51,9×** | 🟠 **il 40× cade DENTRO la banda** | 🟢 sì | 🟠 **Nessun enum. `InpSLLookback=5` e `InpSLBufferPips=3` sono COSTANTI in 100% dei CSV della famiglia (**72 file**)** — mai ad asse. Ma la geometria è **già la più larga disponibile** | 🟢 |
| **15** | `ABTG_SuperWave` (12-15) | `D30EUR`·`U30USD` H1 | id. + 🆕 `InpSLBufferAtr` (>0 ignora il buffer in pip) — `ABTG_SuperWave.mq5:367` | id. | id. | 🟢 **38,5 - 51,9×** | 🟠 al filo | 🟢 sì | 🟢 **`InpSLBufferAtr` è una manopola di ALLARGAMENTO che esiste, vale 0 di default e non è MAI stata mossa** (0 su 38 CSV di `ABTG_SuperWave`). 👉 casella libera, ma il motore è già sopra il pavimento duro | 🟠 `SuperWave D30EUR H1`: 0/9 celle positive su n=228 ⇒ 🔴 |
| **16** | `ABTG_FiboH4_Multi` (18) | basket + `GBPUSD` H4 | `sl = swingHigh − InpSLratio × range − buf` con `InpSLratio = 4,236` — `ABTG_FiboH4_Multi.mq5:430-431` | **4,236 × range** ⇒ molto largo | 🟢 0,30 pip (B) su GBPUSD | ⚪ `[NM]` ma **strutturalmente enorme** | 🟢 quasi certo PASS | 🟢 | 🟠 **`InpSLratio` costante 4,236 in 16/16 CSV.** 🔴 **Ma qui allargare è il verso SBAGLIATO**: è già morto **per RISCHIO** (DD 17,2-23,3% @1%), e uno stop più largo a rischio fisso **non abbassa il DD in R** | 🔴 **n 548-737 per gamba** |
| **17** | `ABTG_LiquiditySweep` (19) | `GBPUSD` H1 | `InpSLMode=0` strutturale (oltre lo sweep + `InpSLBufferAtr × ATR`) — `ABTG_LiquiditySweep.mq5:191-193` | `[NON MISURATO]` | 🟢 0,30 pip (B) | ⚪ `[NM]` | — | — | 🟠 **Sì (`InpSLMode=1` = ATR puro) ma è più STRETTO, non più largo**: andrebbe nel verso sbagliato. Costante `0` in 4/4 CSV | 🟢 (n=14 IS: campione inesistente) |
| **18** | `ABTG_DAX_Apertura_EU` *(morto su FTSE)* | `100GBP` M5 | `sl = rangeLow − InpBufferPoints`, entry `= rangeHigh − InpRetestOffsetPts` ⇒ **stop = larghezza range + (buffer − offset)** — `ABTG_DAX_Apertura_EU.mq5:1488-1491` | `[NON MISURATO]` su 100GBP | 🔴 **[NON MISURATO]** | 🔴 **[NON CALCOLABILE]** | — | — | 🟠 `ABTG_SL_ATR=1` esiste (`:236`) **ma è più STRETTO**. 🟢 **Il modo RANGE è già il più largo** | 🔴 **72 celle su 96, best 0,90423; + FASE A −0,138 R/op su 431 rotture** |
| **19** | `ABTG_DAX_Apertura_EU` *(cella morta su CAC)* | `F40EUR` M5 | id. | `[NM]` | 🔴 [NM] | 🔴 **[NON CALCOLABILE]** | — | — | 🟠 id. | 🟢 (1 cella sola) |
| **20** | `ABTG_Apertura_Marco` *(morto)* | `NASUSD` M5 | id. (`ABTG_Apertura_Marco.mq5:813,837`) | `[NM]` | 1,80 (A, h14) | ⚪ `[NM]` | — | — | 🟠 `ABTG_SL_ATR` esiste, è più stretto. 🟢 modo RANGE già il più largo | 🔴 **22 celle su 22 sotto 0,85 + conferma 0,92 col motore nudo su 484 uscite** |
| **21** | `ABTG_Apertura_3Ingressi` *(morto)* | `NASUSD` M15 | id. + `VolRegimeSL()` — `ABTG_Apertura_3Ingressi.mq5:1134-1135` | `[NM]` | 1,80 (A) | ⚪ `[NM]` | — | — | 🟢 **`InpUseVolRegime` SCALA lo stop col regime ed è una manopola di allargamento**; 🔴 ma il motore è morto su 3 stili su 3 in OOS | 🔴 **0/3 stili positivi OOS, 260 posizioni** |
| **22** | **OPENCONFIRM / RANGE-FADE** *(morti)* | `D30EUR`·`NASUSD` M5+M15 | id. (stesso ramo RANGE) | `[NM]` | 1,70 / 1,80 | ⚪ `[NM]` | — | — | 🟠 stesso enum, modo più largo già in uso | 🔴 **1 cella su 8 · 0 celle su 8 con 2 mercati × 2 finestre × 2 TF** |
| **23** | `ABTG_CanaleLento` (D3) | `XAUUSD` D1 | 🔴 **nessuna formula di stop nel sorgente**: l'EA piazza `BuyStop`/`SellStop` con lo stop dal canale di Donchian — `ABTG_CanaleLento.mq5:599,627` | `[NM]` | 🟢 **0,26-0,27 USD** (B, notte) · 0,18-0,21 (giorno) | ⚪ `[NM]` — 40× ⇒ **7,2-10,8 USD**; su D1 l'ATR dell'oro è **decine di dollari** | 🟢 quasi certo PASS | 🟢 | 🔴 **nessun modo di stop da mettere ad asse** | 🟢 |

---

# 2️⃣ 🎯 LA CLASSIFICA DEI RIAPRIBILI

Ordinata per **quanto avvicina una sedia schierabile**, non per quanto è bello il numero.
Costo in passate col metro di casa misurato il 21/09 (`T = 0,6 + 0,077 × passate` minuti;
banda vera su M5 indici: **20,1 s/passata** nel caso stretto, **89,6 s/passata** nel largo).

| # | candidato | **la misura che lo sblocca** | attesa dichiarata PRIMA | cosa lo uccide (scritto prima) | passate | **minuti** (stretto → largo) |
|---|---|---|---|---|---:|---|
| 🥇 **1** | **`ABTG_Londra_ORB` — `InpSLMode` MIDPOINT vs OPPOSITE, ALL'ORA GIUSTA (08:00 server)** | 2 modi × 2 lati × 2 finestre. 🔴 **E l'ora va corretta insieme**: il canale girava 06-07, cioè **un'ora prima** dell'apertura di Londra (misurata il 03/09) | Sul modo OPPOSITE mi aspetto uno **stop doppio** ⇒ se il canale medio è 10-20 pip, si passa da **16,7-33,3×** a **33,3-66,7×**. Attesa: **RF OOS ≥ 0,8 su almeno 2 celle su 4**, PF ≥ 1,10 | se il canale misura **< 12 pip**, nemmeno OPPOSITE arriva a 40× ⇒ **il simbolo/la sessione si chiudono per costo, col numero** | **8** | **2,7 → 11,9** |
| 🥈 **2** | **`ABTG_MaxMinNotte` `F40EUR` — `InpSLMode` 0/1/2 + `InpAtrSLmult` fino a 3,0** | Asse sul **modo di stop**, tutto il resto pinnato alla cella migliore già trovata (PF 0,99852, n=112) | **+0,037 di PF è il minimo garantito** (solo pedaggio). Sul gemello XAUUSD il cambio di modo ha dato **+0,29 di PF e +4,4 di RF**: se anche solo un terzo si trasferisce, si arriva a **1,13**. Attesa: **PF ≥ 1,10 su almeno 2 celle su 6** | 🔴 **se nessuna cella su 6 supera 1,05, il CAC si chiude definitivamente**: il pedaggio era il migliore argomento che aveva | **12** | **4,0 → 17,9** |
| 🥉 **3** | **`ABTG_DAX_Live5m_v2` — `InpMinStopPts` ai valori VERI (1.000 / 2.000 / 4.000 / 6.800 pt)** | Il floor che ALLARGA, provato finora a 2-4 idx contro una frontiera di **68 idx**. `InpSkipIfTight=false` ⇒ lo stop viene riscritto, non si salta il trade | il rapporto passa da **1,2-3,5×** a **5,9 / 11,8 / 23,5 / 40,0×**. Mi aspetto il PF **monotòno crescente** col floor, e il DD a scendere **per sola taglia** | 🔴 **se il PF NON cresce monotòno con il floor, il pedaggio non era la causa** e la famiglia Live5m si chiude | **8** | **2,7 → 11,9** |
| 4️⃣ | **`ABTG_MaxMinNotte` `D30EUR` — `InpSLMode=0` (box opposto), mai provato sul DAX** | Il modo che **batte il modo girato oggi su XAUUSD in 4 TF su 4** non è mai stato misurato sul DAX, dove la sedia è viva | RF ≥ quello di `InpSLMode=1` a `AtrSLmult` 2,5 (= **51,5×**). 🔴 **Il rapporto del modo 0 è `[NON CALCOLABILE]` finché il box non è misurato**: supera 51,5× **se e solo se** la larghezza del box notturno supera **87,5 idx**. La sonda costa 0 passate (§7.1) | se il RF scende, il modo 0 resta una cosa dell'oro e **il DAX si chiude su quell'asse** | **12** | **4,0 → 17,9** |
| 5️⃣ | **`ABTG_Nightly` — `InpSLpips` / `InpSLatrMult` su EURUSD e GBPUSD** | **La manopola dello stop non è mai stata mossa, su **20 CSV su 20**.** Punto ③ del certificato **vuoto per tutti e quattro i simboli** | soglia nota: **40× ⇒ 12,0 pip**. Attesa: `InpSLatrMult` 1,0 → 2,0 raddoppia lo stop ⇒ il pedaggio si dimezza | 🔴 **il DD è già 15,4-22,6% @1%**: se allargando lo stop il DD **in R** non scende, non è pedaggio, è direzione | **16** | **5,4 → 23,9** |
| 6️⃣ | **`ABTG_DAX_M3` — `InpSLMode` FINALMENTE LETTO (0/1/2) + il TF a M5/M15** | `InpSLFixedPts` è stato spazzolato **su 6 valori senza mai essere letto**: 6 passate identiche | 🔴 **attesa BASSA e la dichiaro**: anche il modo migliore arriva a **13,5×**. Il motore è su **M3**, il TF più caro della scala | **si chiude per COSTO col numero**, non per PF | **12** | **4,0 → 17,9** |

### 💰 Il conto totale dei sei
**68 passate** ⇒ `T = 0,6 + 0,077 × 68` = **5,8 minuti** col metro lineare ·
**22,8 → 101,5 minuti** con la banda vera misurata su M5 indici.
👉 **Tutto il dossier costa meno di due ore di macchina nel caso peggiore.**

---

# 3️⃣ 🔴 I `[NON CALCOLABILE]` — per nome, e cosa li sblocca a ZERO passate

| simbolo | chi ci muore sopra | perché non calcolabile | **la misura che lo sblocca** | costo |
|---|---|---|---|---:|
| **`F40EUR`** (CAC) | `MaxMinNotte` B1 · `DAX_Apertura` H · `SupRev_CAC_H4` | spread `[NON MISURATO]`: `spread_flotta/` ha **3 file su 13 simboli**, e `spread_vivo/` ne ha 8, nessuno dei quali è questo | 🟢 **`ABTG_SpreadLogger` è GIÀ INSTALLATO e raccoglie dal 04/09**: basta **aggiungere il simbolo alla lista e rifare la raccolta**. È una riga di **sola lettura** | **0 passate** |
| **`E50EUR`** (Stoxx) | `MaxMinNotte` B2 | id. | id. | **0 passate** |
| **`100GBP`** (FTSE) | `MaxMinNotte` B3 · `DAX_Apertura` G · `SupRev` 100GBP | id. | id. | **0 passate** |
| **`SPXUSD`** | `CostToCost` scan · `DAX_Apertura` I | id. | id. | **0 passate** |
| **`E35EUR`** (IBEX) | `DAX_Apertura` I · `CostToCost` scan | id. | id. | **0 passate** |
| **`EURJPY` · `USDCHF` · `CHFJPY` · `GBPCAD`** | `CostToCost` A1-A5 (i tre «resuscitabili #1-#3» del dossier notturno) | id. — il logger vivo copre EURUSD/GBPUSD/USDJPY, **non i cross** | id. | **0 passate** |
| **`EURCHF`** | `Nightly` C1 (l'**unico** candidato a tick reali di tutta la famiglia notturna) | id. | id. | **0 passate** |

> 🔴 **E lo dico chiaro perché è la distinzione che il mandato chiede**: nessuna di queste
> righe è *«escluso per costo»*. Sono **caselle bianche**. Chiamarle «escluse» sarebbe
> esattamente l'errore che il 22/09 abbiamo trovato in `REGISTRO_TEST.md` su sei candidati
> archiviati «per frequenza» **senza un solo PF misurato**.

---

# 4️⃣ 🟢 CHI IL CANCELLO DI COSTO **ASSOLVE** — e per cui la causa è un'altra

Un elenco di soli difetti descrive male la realtà. Questi sono **sopra la frontiera**, e il
loro DD **non è pedaggio**:

| candidato | stop | spread | **rapporto** | verdetto | 👉 allora la causa è… |
|---|---:|---:|---:|---|---|
| **`ABTG_Dow_Apertura_US`** `U30USD` M5 *(registro: «morto, a malapena in pari»)* | **123,80** `[MISURATO n=446]` | 2,00 | 🟢 **61,9×** | **PASS (+55%)** — e **41,3×** anche al p95 3,00 | **niente**: il motore è ⚪ NON ANCORA MISURATO sul TF, e in OOS fa **PF 1,27175, DD 4,39% @1%, 40/40 celle in utile**. 🔴 **Qui il registro ha torto, e non per colpa del costo** |
| **`ABTG_Nasdaq_Apertura_US`** `NASUSD` M15 | **83,20** | 1,80 | 🟢 **46,2×** | **PASS (+16%)**, e 43,8× al p95 | **il campione** (102 posizioni OOS < 150), non il pedaggio |
| **`ABTG_DAX_Apertura_EU`** `D30EUR` M5 (geometria forward) | **71,90** | 1,70 | 🟢 **42,3×** | **PASS**, ma **32,3×** sulla geometria viva (54,90) ⇒ 🟠 **FRAGILE** | è la **sedia migliore della famiglia**: il costo la sfiora, non la spiega |
| **`SupRev_DOW_H1` · `SuperWave_DOW_H1` (`770511`)** `U30USD` H1 | **77,1 - 98,6** `[MISURATO]` | 1,90 (h17) | 🟢 **40,6 - 51,9×** | **PASS alla mediana**; 38,5× all'ora 14 ⇒ 🟠 al filo | **il CAMPIONE e la REGOLA DI SELEZIONE**: `SupRev_DOW` è un **picco su 2 assi su 3** (vicino `AtrP 10` = 0,610), `SuperWave` ha n=143 |
| **`ABTG_CanaleLento`** `XAUUSD` D1 | ATR D1 dell'oro (decine di USD) | **0,26** (B) | 🟢 **≫ 40×** | **PASS** con enorme margine | **le celle verdi in OOS sono le rosse in IS**, e il motore è un **doppione** di Donchian 55/20 |
| **`ABTG_FiboH4_Multi`** H4 | 4,236 × range | 0,30 pip | 🟢 **≫ 40×** | **PASS** | 🔴 **il RISCHIO**: DD 17,2-23,3% @1% ⇒ 34-46% alla taglia FTMO. **Allargare lo stop qui peggiora, non aiuta** |
| **`ABTG_TurnaroundTuesday`** `GBPUSD` H1 | ATR(D1) × 0,50-1,00 | 0,30 pip | 🟢 largo | **PASS** | **la direzione, misurata**: 0/24 celle OOS positive su 11.928 trade, **col modo di stop già ad asse su 3 valori** |

🟢 **Sette righe della tabella madre su ventiquattro: il pedaggio NON è la spiegazione.** Chiuderli sul costo
sarebbe stato un errore, e questo capitolo serve proprio a non commetterlo.

---

# 5️⃣ ⚠️ LA TRAPPOLA, e **IL TERZO CONSUMATORE DELLO STOP** — dove l'ho trovato

## 5.1 La trappola aritmetica, detta con la formula

Con sizing a rischio fisso, `lotti = rischio_EUR / (stop × valore_punto)`. Uno stop **k volte**
più largo dà un lotto **k volte** più piccolo ⇒ **profitto e DD scendono INSIEME, per k**.
🔴 **Un DD più basso non è di per sé un miglioramento**: lo stesso risultato si ottiene
abbassando il rischio, **gratis e senza round**.
👉 **L'unica grandezza che discrimina è il RECOVERY FACTOR** (`profitto / DD in soldi`:
il fattore `k` si semplifica), col **PF** secondo. In questo dossier ogni confronto fra modi
di stop è scritto **su RF**.

**E il pedaggio in R è invariante anche lui**: `costo_R = spread / stop`. Ecco perché il
rapporto `stop/spread` è **la** grandezza giusta: è il reciproco del pedaggio per operazione.

| rapporto | pedaggio per operazione |
|---:|---:|
| 13,3× (pavimento duro) | **7,52% del rischio** |
| 30,9× (MaxMinNotte ×1,5) | **3,24%** |
| 40,0× (frontiera) | **2,50%** |
| 51,5× (MaxMinNotte ×2,5) | **1,94%** |
| 71,0× (ORB OPPRANGE) | **1,41%** |

## 5.2 🔴 IL TERZO CONSUMATORE — e non è quello che pensavo

Ho cercato dove il trailing legge lo stop corrente e lo migliora. Ho trovato **tre schemi
diversi**, e **solo uno** è la trappola del brief:

**(a) 🔴 `ABTG_DAX_Live5m` e `ABTG_Nasdaq_Live5m` — QUI IL TRAILING COMANDA DAVVERO.**
Le passate sono girate con `InpTrailMode = 1` (**PREVBAR**, `ABTG_DAX_Live5m.mq5:1060`),
`InpTrailTF = M1` e `InpTrailStartR = 0` (*«arma subito»*, `:220`). Risultato: **ogni
posizione in profitto viene chiusa al minimo della candela M1 precedente.**
👉 Lo stop iniziale governa **la perdita e il lotto**; **la vincita la governa una candela
M1**. Cambiare `InpSLMode` lì è un **cambio di TAGLIA**, non un cambio d'uscita.
🔴 **Conseguenza operativa, ed è la ragione per cui L1/L2 NON sono in cima alla classifica**:
su quella famiglia la manopola da mettere ad asse è **`InpTrailTF` / `InpTrailStartR`**, non
lo stop. *(E infatti `InpTrailTF` è una delle sole due manopole di TF mai confrontate in
tutta la famiglia aperture.)*

**(b) 🟠 `ABTG_MaxMinNotte` — il trailing NON dipende dallo stop, ma i TARGET SÌ.**
Il trail è `bid − ATR × InpTrailAtrMult` e scatta solo sopra l'ingresso
(`ABTG_MaxMinNotte.mq5:465`): è **ancorato al prezzo**, non allo stop. 🔴 **Ma `risk` (=
distanza di stop iniziale, r.407) è il denominatore di `InpTP1_R` e `InpTP2_R`**: allargare lo
stop **allarga anche i target, proporzionalmente**.
👉 **Quindi cambiare `InpSLMode` su questo EA NON è una sola variabile**: è stop **e**
target. **Prova che morde**: su XAUUSD, a parità di tutto, il numero di uscite cambia con il
modo (**353 / 365 / 372** a H1). Va dichiarato nel file prova, non scoperto dopo.

**(c) 🟢 `ABTG_ORB_Ottimizzato` — il modo di stop NON tocca l'ingresso, ed è PROVATO.**
In `r88a` il numero di operazioni è **identico su tutti e quattro i modi**: **71 in IS, 119 in
OOS**. 🟢 È il caso più pulito che abbiamo, ed è il motivo per cui l'ORB è l'esempio giusto.

**(d) 🔴 `ABTG_ORB_Fibo` — il trailing cancella lo stop quasi subito.**
`InpTP1Pct = 50` + `InpBreakeven = true` + `InpUseTrailEMA = true` + `InpExitOnEmaClose = true`
(`:75-78`): dopo il primo target il residuo è trascinato sull'**EMA9 del TF di esecuzione**.
👉 Il suo **«DD 3,10%, il più basso della tabella»** non descrive un motore prudente: descrive
un motore che **non tiene mai una posizione**. E il rischio realizzato è pure **quantizzato**
dal `MathFloor` sul passo lotto (`:414-419`): **`[NON MISURATO]`**.

## 5.3 🎁 E il precedente, letto sul RF invece che sul DD

`r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`, **12 celle per modo**, n costante:

| `InpSLMode` | RF **IS** (mediana) | RF **OOS** (mediana) | PF OOS (mediana) | DD OOS (mediana) |
|---|---:|---:|---:|---:|
| **0 OPPRANGE** (lo stop di Paolo) | −0,15 | 🟢 **4,03** | 🟢 **1,680** | 🟢 **4,25%** |
| 1 ATR | −0,42 | 2,78 | 1,470 | 9,17% |
| 2 FIXED | **+0,57** | 1,21 | 1,369 | 🔴 19,22% |
| **3 HALFRANGE** (quello che gira) | +0,47 | 2,59 | 1,513 | 9,66% |

🟢 **OPPRANGE vince in OOS su RF (+56% contro HALFRANGE) e su DD (4,25% contro 9,66%), a n
identico.** 🔴 **E perde in IS**: mediana RF **−0,15 contro +0,47**, e in IS il modo migliore è
addirittura il **2 (FIXED, +0,57)** — che in OOS è il peggiore. **Il segno si ribalta fra le
due gambe su tutti e quattro i modi.**
👉 **Questo è un motivo in più per rifare la misura al banco giusto (`R211a`), non per darla
per vinta.** Il confronto onesto è *«vince OOS, perde IS»*, non *«vince»*.

---

# 6️⃣ 🧪 IL CONTRO-ESEMPIO CHE HO COSTRUITO **CONTRO OGNI RIAPRIBILE** (regola del 10/09)

### 🥇 #1 `Londra_ORB` — *l'argomento che lo uccide*
> *«`R45` ha già misurato la sessione di Londra a tick reali su tre simboli: **0 celle
> positive su 48**, campioni 149-262 IS e 186-408 OOS, e su GBPUSD il migliore fa **PF 0,61**.
> Il modo di stop non recupera 0,39 di PF.»*

✅ **La premessa è vera e pesante.** 🔴 **Ma non regge, e per un fatto già agli atti**:
`prove/R45c_londra_GBPUSD.txt` r.20-22 porta `InpRangeStartHour = 7`, `InpRangeEndHour = 7`
— **R45 ha misurato la PRE-apertura**, non l'apertura. Londra apre alle **08:00 ora server**
(misurato il 03/09, `allinealondra/REFERTO_PASSO0`). 👉 **R45 falsifica "ORB un'ora prima di
Londra", che è quello che falsifica anche `Londra_ORB`: le due misure sbagliano la stessa
ora, non si confermano a vicenda.**
🔴 **E il secondo argomento contrario regge in parte, quindi lo scrivo**: cambiando `InpSLMode`
**cambia anche `InpHalveOnOpposite`** (r.208: `halve` è attivo **solo** se
`InpSLMode==LDN_SL_OPPOSITE`). 👉 **Non è una variabile sola**: `InpHalveOnOpposite` va
**pinnato a `false`** nel file prova, altrimenti si misurano due cose insieme. *(È scritto
qui perché finisca nel file prova, non perché lo si scopra dopo.)*

### 🥈 #2 `MaxMinNotte F40EUR` — *l'argomento che lo uccide*
> *«0 celle su 54 sopra PF 1,00, con n fino a 196. È un motore che perde, e la regola del
> 19/08 dice che su un motore senza edge una griglia nuova trova solo picchi di rumore.»*

🟠 **Regge a metà, e la metà che regge va detta.** ✅ Vero: 0/54. 🔴 **Ma quelle 54 celle
condividono TUTTE lo stesso identico stop**: l'asse era buffer × lato × `TP2_R`.
Cambiare `InpSLMode` è un **meccanismo**, non un parametro — la regola del 19/08 lo consente
espressamente. 🔴 **E però il conto del pedaggio dice che da solo non basta: +0,037 di PF
porta 0,99852 a 1,035, non a 1,10.** 👉 **Verdetto onesto: riapribile, ma con un'attesa
DICHIARATA BASSA.** Se la cella migliore non supera 1,05, si chiude.

### 🥉 #3 `DAX_Live5m_v2` — *l'argomento che lo uccide*
> *«Il floor a 6.800 punti su un motore che entra su un range di 5 minuti significa che lo
> stop sarà 10-30 volte la finestra d'ingresso: non è più lo stesso motore.»*

🔴 **QUESTO ARGOMENTO REGGE, E VINCE.** A `InpMinStopPts = 6800` (68 idx) contro una finestra
d'ingresso di 5 minuti su D30EUR (ATR M5 ≈ 20 idx) lo stop vale **3,4 ATR**: il motore non è
più un breakout intraday, è un'altra cosa. 👉 **Ho abbassato la proposta**: il file prova deve
fermarsi a **4.000 punti (40 idx ⇒ 23,5×)** e **dichiarare che a quel valore il 40× NON si
raggiunge**, invece di sfondare la geometria per rispettare un pavimento.
🟢 Il pezzo che sopravvive: **a 200-400 punti il floor era 17-34 volte sotto la frontiera**,
quindi «provato» è falso comunque. La casella resta libera, **la proposta si restringe**.

### 4️⃣ `MaxMinNotte D30EUR` modo 0 — *l'argomento che lo uccide*
> *«Il modo 0 ha vinto sull'ORO, che è un altro mercato, in OHLC e su finestra unica. E lo
> stesso referto (`NOTTE_ORO.md`) scrive che i gradienti hanno il massimo **sul bordo della
> griglia**: griglia messa male, non scoperta.»*

🟠 **Regge in parte.** ✅ Vero che è OHLC e finestra unica (⇒ **screening, non verdetto**), e
vero che i massimi sono al bordo. 🔴 **Ma il confronto fra i tre modi è CONTROLLATO** (stesso
file, stesso buffer 200, `n` 353/365/372) e la differenza è **grande**: RF 7,34 contro 2,93 a
H1. Un artefatto dell'OHLC dovrebbe favorire **il modo più stretto** (l'OHLC non vede i
rimbalzi intrabar che fanno scattare gli stop stretti), e invece favorisce **il più largo**:
l'errore del modello lavora **contro** la conclusione, non a favore. 👉 **Il segnale
sopravvive al contro-esempio, il numero no.** Resta al 4° posto, non sale.

### 5️⃣ `Nightly` — *l'argomento che lo uccide*
> *«Il DD è 15,4-22,6% @1%, cioè 30-45% alla taglia FTMO, e l'Emendamento B dice che il
> rischio si legge a qualunque n. È morto per rischio, non per costo.»*

🔴 **REGGE, E VINCE SU DUE DEI QUATTRO SIMBOLI.** `GBPUSD` (IS 22,62%) e `EURCHF` (OOS 15,39%)
sono fuori dal muro con margine: nessun allargamento dello stop li riporta dentro **in R**.
🟢 Quello che sopravvive: il **punto ③ del certificato è vuoto per tutti e quattro** (la
manopola dello stop non è mai stata mossa, su **20 CSV su 20**), quindi il verdetto corretto in
`REGISTRO_TEST.md` è **⚪ NON ANCORA MISURATO sul modo di stop**, non 🔴 morto — anche se la
priorità è bassa e l'ho messo quinto.

### 6️⃣ `DAX_M3` — *l'argomento che lo uccide*
> *«Non arriva a 40× nemmeno col modo migliore: al massimo dell'asse fa 13,5×. È escluso per
> costo e basta.»*

🔴 **REGGE SUL COSTO A M3, E LO ACCETTO.** 🟢 **Ma non regge sul MOTORE**: `InpTriggerTF` è un
`ENUM_TIMEFRAMES` vero e non è **mai** stato mosso da M3. Lo stesso meccanismo (Supertrend +
EMA200 + ADX) è **vivo e validato a tick** in casa a H1/H4. 👉 **Il verdetto giusto non è
«motore morto»: è «M3 escluso per costo, col numero — e il motore non è mai stato misurato
fuori da M3».** Due frasi diverse, e solo una è vera.

---

# 7️⃣ 🔴 NON COPERTO — per nome, e perché

1. 🔴 **La larghezza vera del box notturno di `MaxMinNotte` su D30EUR/F40EUR/E50EUR/100GBP è
   `[NON MISURATA]`.** Esiste lo strumento (`mql5/Scripts/ABTG_Notte_Study.mq5`) ma è stato
   girato **su XAUUSD e basta**. 👉 Senza, il rapporto `stop/spread` del **modo 0 (box
   opposto)** non è calcolabile: so che è **più largo** dell'ATR×1,5, non **di quanto**.
   **È una sonda, non un round: 0 passate.**
2. 🔴 **L'ampiezza del canale 06:00-07:00 (e di quello 08:00-09:00) su GBPUSD è
   `[NON MISURATA]`.** Senza, non so se il modo MIDPOINT superi i 12,0 pip della frontiera.
   Il mio #1 è costruito **sulla soglia**, non su un numero. **Sonda, 0 passate.**
3. 🔴 **L'estensione `r` di `ABTG_ORB_Fibo` su NASUSD è `[NON MISURATA]`.** La mia conclusione
   («non può passare il 40×») è un **argomento di soglia** (servirebbero 252 idx contro
   un'ADR di 384,6), non una misura. **Sonda, 0 passate.**
4. 🔴 **`InpAtrSLmult` per `MaxMinNotte` su F40EUR/E50EUR/100GBP resta `[NON CALCOLABILE]` in
   punti**: senza l'ancora ADR di quei simboli (n=1 e n=2 giornate, dichiarate
   `[NON CITABILE]` il 18/09) non esiste un ATR da moltiplicare.
5. 🔴 **La legge `√T` NON è validata sotto M15.** Tutti i numeri M3/M5 di questa tabella sono
   estrapolazioni. Dove decidono un verdetto, il verdetto è *«sotto la frontiera»*, mai
   *«esattamente 17,8×»*.
6. 🔴 **Lo spread del logger vivo è di CINQUE giornate (04-11/09/2026), non della finestra dei
   backtest.** Per GBPUSD/EURUSD/USDJPY/XAUUSD/225JPY non ho un equivalente tick-storico.
   Il confronto con i numeri della finestra 2024-2026 è **indicativo**.
7. 🔴 **Non ho verificato se i `.ex5` sul banco corrispondano ai `.mq5` a HEAD** per nessuno
   dei 23 motori. Tutte le formule di stop di questo dossier vengono dal **sorgente a HEAD**.
8. 🔴 **`ABTG_CanaleLento`: non ho trovato la riga che costruisce lo stop iniziale** (solo le
   `PositionModify`/`*Stop` a r.599/627). Il punto ③ su quel motore resta **non compilato**,
   e l'ho scritto nella tabella invece di inventarlo.
9. ⚪ **Equity Drawdown Absolute** (il campo che FTMO misura davvero) **non è nei CSV**: ho
   usato `Equity DD %`, che è un **limite superiore rigoroso** (classe 562). I miei DD sono
   conservativi, mai ottimisti.

---

# 8️⃣ 📌 LE RIGHE CHE PROPONGO DI CAMBIARE IN `REGISTRO_TEST.md`

*(proposta — non eseguita, perché archiviare o disarchiviare un candidato passa dal cancello)*

| candidato | verdetto di oggi | **verdetto proposto** | cosa manca |
|---|---|---|---|
| `MaxMinNotte` F40EUR | ⏸️ non misurato | ⚪ **NON ANCORA MISURATO sul MODO DI STOP** | `InpSLMode` 0/2 mai provati; spread `[NON MISURATO]` |
| `MaxMinNotte` E50EUR / 100GBP | ⏸️ / 🪦 | ⚪ **NON ANCORA MISURATO sul modo di stop, PRIORITÀ BASSA col numero** (il pedaggio vale +0,032 / +0,028 di PF, contro un divario di 0,26 / 0,43) | id. |
| `ABTG_Londra_ORB` | 🔴 morto | ⚪ **NON ANCORA MISURATO — ora sbagliata E modo di stop mai provato** | zero CSV; `LDN_SL_OPPOSITE` vergine |
| `ABTG_DAX_M3` | 🔴 morto | 🟠 **M3 ESCLUSO PER COSTO (8,8-13,5×)** · ⚪ il motore **mai misurato fuori da M3** | `InpTriggerTF` mai mosso |
| `ABTG_ORB_Fibo` | 🟠 non misurato | 🪦 **ESCLUSO PER COSTO, col numero**: stop = 0,168 × estensione ⇒ servirebbe `r ≥ 429 idx` (ingresso 61,8%) o `r ≥ 252 idx` (ingresso 50%) contro ADR 384,6. **Nessun modo di stop nel sorgente lo salva** | — |
| `ABTG_Nightly` (4 simboli) | ❌ rischio | ⚪ **NON ANCORA MISURATO sul modo di stop** (0 su 20 CSV) · 🔴 **ma GBPUSD ed EURCHF restano fuori per RISCHIO** | `InpSLpips`/`InpSLatrMult` mai ad asse |
| `ABTG_Dow_Apertura_US` U30USD | 🔴 «morto, a malapena in pari» | 🟢 **ASSOLTO DAL COSTO (61,9×)** — e il numero OOS è **PF 1,27175 su 40/40 celle in utile** | il TF (solo M5) |

---

## 🧾 FONTI PRIMARIE (file + riga)

- **Spread (A)**: `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_{D30EUR,U30USD,NASUSD}.csv` + `REFERTO_SPREAD_FLOTTA.txt`
- **Spread (B) 🆕**: `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv` (8 simboli, 24 ore, 5 giornate)
- **Ancore ADR e legge √T**: `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` §2, §3, §8
- **Stop misurati delle sedie**: `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §1, §4.1, §5.1
- **Modo di stop ad asse, ORB**: `backtest_pipeline/risultati_archivio/r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv` (48+48 righe)
- **Modo di stop ad asse, MaxMinNotte**: `backtest_pipeline/risultati_archivio/MaxMin_Oro/oro_maxmin_fase1_{M5,M15,M30,H1}.csv` (12 righe ciascuno) + `NOTTE_ORO.md`
- **Moltiplicatore ad asse, MaxMinNotte DAX**: `backtest_pipeline/risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv` (36 righe)
- **I tre morti notturni**: `backtest_pipeline/risultati_archivio/MaxMinNotte/{4528c79b-valid_MaxMin_F40EUR,8eefb007-valid_MaxMin_E50EUR,efe054b5-valid_MaxMin_100GBP}.csv` (72 righe ciascuno) + i rispettivi `.ini` (`Model=4`)
- **Sorgenti**: `mql5/Experts/ABTG_{ORB_Ottimizzato,MaxMinNotte,Londra_ORB,DAX_M3,DAX_Live5m,DAX_Live5m_v2,Nasdaq_Live5m,ORB_Fibo,Nightly,CostToCost,MeanRevert,TurnaroundTuesday,SupertrendReversal,SuperWave,FiboH4_Multi,LiquiditySweep,DAX_Apertura_EU,Apertura_Marco,Apertura_3Ingressi,CanaleLento}.mq5`
- **I cinque riesami del 22/09**: `report/RIESAME_MORTI_{APERTURE,BREAKOUT_M5,NOTTURNI,TREND_REVERSAL}_2026-09-22.md` + `report/CENSIMENTO_CASELLE_VUOTE_2026-09-22.md`
- **L'ancora di stanotte**: `report/NOTTE_2026-09-23.md` §2.1-2.3 · `backtest_pipeline/prove/R211a_stop_opprange_orb_DOW_U30USD.txt`
