# 📏 LE UNITÀ NEI PRESET VIVI — la classe 598 portata dentro la challenge FTMO

**Notte del 22→23/09/2026** · branch `lavoro` · conto FTMO `541452707` (`C:\FTMO`), **vivo dal 21/09**
🛑 **SOLA LETTURA ASSOLUTA.** Nessun preset toccato, nessun `.set`, nessun EA, nessun round, nessuna
riga verso il VPS, nessuna proposta di spegnimento. Conto reale `10105439` mai nominato in un comando.
🚫 Nessuna decisione qui dentro: **taglie, spegnimenti e cambi di cella restano di Claudio.**

> ## 🎯 IN UNA RIGA
> **Ho controllato tutte e sei le sedie in campo, input per input, con i `Digits` MISURATI del
> broker FTMO. 🟢 NESSUNA sedia entra con uno stop più largo di quello che crediamo. NESSUNA è
> bloccata da un filtro morto. Il contratto di tutte e sei regge.**
> L'unica sedia che porta soglie «in pip» su un indice — **`770511` SuperWave** — le porta
> **inerti**, 🟢 **ed erano inerti anche nel backtest che l'ha promossa**: il contratto non è rotto,
> è *identico*. Il difetto della classe 598 **non è entrato nella challenge.**

---

# 1. 🔴 LE SEI SEDIE IN CAMPO — una per una, col numero accanto

**Riferimenti MISURATI usati in tutta la sezione** (non assunti):
`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` §`[SIMBOLI]`, sonda
`ABTG_PrevoloFTMO_Specifiche.mq5` del 20/09 alle 17:08 a mercato aperto.

| simbolo FTMO | `Digits` | `Point` | `StopsLevelPts` | spread al tick | spread in punti indice |
|---|---:|---:|---:|---:|---:|
| `GER40.cash` | **2** | 0,01 | **0** | 143 | **1,43** |
| `US30.cash` | **2** | 0,01 | **0** | 263 | **2,63** |
| `US100.cash` | **2** | 0,01 | **0** | 153 | **1,53** |

🟢 **E il confronto che chiude la questione del trasporto**: su BCM `D30EUR`, `U30USD`, `NASUSD`
hanno anche loro **`Digits=2`, `Point=0,01000000`**
(`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` §`[SIMBOLI]`).
👉 **Ogni valore espresso in `*_Point` vale ESATTAMENTE lo stesso numero sui due broker.** Nessun
riscalamento è dovuto, e nessuno ne è stato fatto: è la ragione per cui i contratti reggono.

## 🪑 1.1 `770101` — DAX Apertura · `GER40.cash` M5 · **🟢 PULITA**
`mql5/Presets/FTMO/ABTG_DAX_Apertura_EU_770101_FTMO.set` → `mql5/Experts/ABTG_DAX_Apertura_EU.mq5`
**Zero occorrenze di `PipSize`** nel sorgente: l'unità è `_Point`, che per questo simbolo è fissa.

| input | valore | uso (file:riga) | valore VERO | giudizio |
|---|---:|---|---:|---|
| `InpBufferPoints` | 500 | r.2538 `MathMax(InpBufferPoints,stopsLvl)*_Point` | **5,00 idx** = **3,5× spread** | 🟢 plausibile |
| `InpRetestOffsetPts` | 200 | r.1930/1973 `gRangeHigh − …*_Point` | **2,00 idx** = 1,4× spread | 🟢 plausibile |
| `InpMinStopPts` | **0** | r.1935 `if(InpMinStopPts > 0 && …)` | floor **spento** | ⚪ off dichiarato |
| `InpSkipIfTight` | **true** | dentro il ramo qui sopra | **INERTE**: il ramo non si apre mai | ⚪ inerte |
| `InpTrailFixedPts` | 410 | r.2466 `bid − …*_Point`, ma **solo se `InpTrailMode==ABTG_TRAIL_FIXED`** | **INERTE**: `InpTrailMode=1` = `ABTG_TRAIL_PREVBAR`, e `FIXED` vale **2** (enum **r.242-244** di questo file) | ⚪ inerte |
| `InpRoundMinDistPts` | 50 | r.2366, ma sotto `if(InpUseRoundLevels && InpRoundStep>0)` | **INERTE**: `InpUseRoundLevels=false` | ⚪ inerte |
| `InpGapMinPoints` | 150 | r.2018, ramo GAPFILL | **INERTE**: `InpEntryMode=2` (`ABTG_RETEST`), `ABTG_GAPFILL`=**1** | ⚪ inerte |
| `InpMinRangePts` / `InpMaxRangePts` / `InpFadeOffsetPts` / `InpSlippagePts` | 0 | — | spenti | ⚪ off |

🟢 **Verdetto: PULITA.** Le due manopole vive (5,00 e 2,00 punti indice) sono nell'ordine di
grandezza dello spread misurato. Le quattro inerti **sono inerti per un `if`, non per un'unità**:
non c'è nessun numero che vale 100 volte quello che crediamo.

## 🪑 1.2 `770411` — MaxMin Notte DAX Short · `GER40.cash` M15 · **🟢 PULITA**
`ABTG_MaxMinNotte_DAX_Short_770411_FTMO.set` → `mql5/Experts/ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
**Zero occorrenze di `PipSize`.**

| input | valore | uso (file:riga) | valore VERO | giudizio |
|---|---:|---|---:|---|
| `InpBufferPoints` | 1000 | r.425 `MathMax(InpBufferPoints,stops)*_Point` | **10,00 idx** = **7,0× spread** | 🟢 plausibile |
| `InpSLFixedPts` | 3000 | r.277/285, **solo se `InpSLMode==MM_SL_FIXED`** | **INERTE**: `InpSLMode=1` = `MM_SL_ATR` (enum r.45: OPPOSITE 0 / ATR 1 / FIXED 2). Lo stop vivo è `ATR(M15)×2,5` | ⚪ inerte — **e il preset lo dichiara da solo**, nel suo commento |
| `InpMinBoxPts` / `InpMaxBoxPts` | 0 | r.230-231 `if(Inp…>0 && …)` | spenti | ⚪ off |

🟢 Il confronto d'unità a r.229-231 è **coerente**: `widthPts=(gBoxHigh−gBoxLow)/_Point` a sinistra,
soglia in punti a destra. Stessa unità sui due lati del `<`.
🟢 **Verdetto: PULITA.** ✅ E l'inerzia di `InpSLFixedPts` era **già scritta nel preset** prima di
questo controllo (classe 495 del 20/09): non l'ho scoperta io, l'ho **confermata nel sorgente**.

## 🪑 1.3 `770202` — Dow Apertura · `US30.cash` M5 · **🟢 PULITA**
`ABTG_Dow_Apertura_US_770202_FTMO.set` → `mql5/Experts/ABTG_Dow_Apertura_US.mq5`. **Zero `PipSize`.**

| input | valore | uso (file:riga) | valore VERO | giudizio |
|---|---:|---|---:|---|
| `InpBufferPoints` | 1000 | r.1909 `MathMax(InpBufferPoints,stopsLvl)*_Point` | **10,00 idx** = **3,8× spread** | 🟢 plausibile |
| `InpRetestOffsetPts` | 400 | r.1319/1352 | **4,00 idx** = 1,5× spread | 🟢 plausibile |
| `InpMinStopPts` | **500** | r.1324 `if(… dist < InpMinStopPts*_Point)` | floor **5,00 idx** = **1,9× spread** — **ATTIVO** | 🟢 plausibile |
| `InpSkipIfTight` | **false** | r.1326-1327 | il floor **allarga lo stop**, non salta il trade | 🟢 coerente |
| `InpTrailFixedPts` 410 · `InpRoundMinDistPts` 50 · `InpGapMinPoints` 150 | — | stessi rami di §1.1 | **INERTI** (`TrailMode=1≠2`, `UseRoundLevels=false`, `EntryMode=2≠1`) | ⚪ inerti |

🟢 **Verdetto: PULITA.** ⚠️ Nota di merito, non di unità: il floor a 5,00 idx è **1,9×** lo spread
FTMO, cioè ben sotto il pavimento di lavoro `stop ≥ 40 × spread`. **Ma non è una scoperta di
stanotte** — è esattamente il numero già scritto in `report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §0
(*«a 5,00 punti indice su `770202`/`770260`, cioè 21× e 12× sotto la frontiera»*), con la proposta
firmata di **non toccare niente** finché non gira `R152a`. **Io lo confermo, non lo riapro.**

## 🪑 1.4 `771531` — EMA200 Dow · `US30.cash` H1 · **🟢 PULITA PER COSTRUZIONE**
`ABTG_EMA200_771531_FTMO.set` → `mql5/Experts/ABTG_EMA200.mq5`

> ## 🟢 **È IMMUNE ALLA CLASSE 598, e non per fortuna: per come è scritta.**
> - **`grep -c 'PipSize'` = 0**
> - **`grep -n '_Point'` = ZERO RIGHE.** In **690 righe di sorgente, `_Point` non compare mai.**
> - **Zero input** con `Pip`/`Point`/`Pts`/`Punti` nel nome (su 53 input totali).
>
> Ogni distanza è un **multiplo di ATR**: `InpMinDistAtr=0.3`, `InpMaxDistAtr=1.5`,
> `InpOrder1Atr=0.10`, `InpOrder2Atr=0.35`, `InpSLatr=1.0`, `InpTP1_ATRmult`, più il filtro ADR in
> frazioni di ADR. **L'ATR è nell'unità dello strumento**: vale su forex e su indici allo stesso
> modo, e non cambia di 10× o 100× col simbolo.

⚠️ **Trappola evitata, e va detta perché sembra il contrario**: i commenti di `ABTG_EMA200.mq5`
**parlano di pip** — r.56 *«guida ~50/70 pip»*, r.68 *«guida ~5 pip»*, r.69 *«guida ~15 pip»*. Un
censimento fatto **sui commenti** avrebbe marcato questa sedia come sospetta. **Sono note di
documentazione: il codice non le usa.** 👉 È la ragione per cui il censimento va fatto sull'**uso**,
non sul nome né sul commento.

🟢 **Verdetto: PULITA PER COSTRUZIONE** — la più solida delle sei su questa classe di difetto.
📌 *Questa sedia ha preso il primo stop vero della challenge il 22/09
(`report/PRIMO_STOP_FTMO_2026-09-22.md`, −1.757,68 €). **Quello stop non c'entra niente con le
unità**: lo SL era al livello giusto, l'eccesso del 10,5% è slippaggio (7,83 punti) e deriva del
cambio. Lo scrivo per chiudere la domanda prima che venga fatta.*

## 🪑 1.5 `770511` — SuperWave Dow · `US30.cash` H1 · **🟠 DA GUARDARE (ma il contratto TIENE)**
`ABTG_SuperWave_DOW_H1_770511_FTMO.set` → `mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5`

🔴 **È l'UNICA delle sei che contiene `PipSize()`** (r.248-252), nella forma esatta della classe 598:
```
double PipSize(){ int d=SYMBOL_DIGITS; return (d==3 || d==5) ? _Point*10.0 : _Point; }
```
Su `US30.cash` (`Digits=2`) → **`PipSize() = _Point = 0,01`**.

| input | valore | uso (file:riga) | **valore VERO** | vs spread 2,63 | giudizio |
|---|---:|---|---:|---:|---|
| `InpPendingPips` | 20,0 | r.407 `off = InpPendingPips*pip` → `BuyStop(entry+off)` | **0,20 punti indice** | **0,076×** | 🟠 **INERTE** |
| `InpSLBufferPips` | 3,0 | r.367 `buf = InpSLBufferPips*pip` → `sl = min(stLine,ext) − buf` | **0,03 punti indice** | **0,011×** | 🟠 **INERTE** |

**Che cosa vuol dire, in concreto:**
- 🟠 Il pendente 2/3 di conferma, che il documento voleva a **~20 pip di distanza**, viene piazzato
  **0,20 punti sopra l'ingresso — cioè DENTRO lo spread** (2,63). Si riempie al primo tick utile.
  👉 **L'ingresso frazionato 1/3 + 2/3 è, di fatto, un ingresso pieno a mercato.**
- 🟠 Il cuscinetto sullo stop, voluto a 3 pip, vale **0,03 punti**: lo stop è praticamente **sul**
  minimo a 5 barre, senza margine.

### 🟢 MA — ed è la cosa che conta — **IL CONTRATTO NON È ROTTO. È IDENTICO.**
La domanda giusta non è *«il valore è quello che il documento voleva?»* (no), ma
*«il preset in campo dice la stessa cosa del CSV che ha promosso la sedia?»* (**sì**). Misurato:

| dove | passate | `InpPendingPips` | `InpSLBufferPips` | simbolo · `Digits` |
|---|---:|---:|---:|---|
| `…/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/…_U30USD_IS{,_ohlc,_r3}.csv` | 11+11+5 | **20** | **3** | `U30USD` · **2** |
| `…/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/…_U30USD_OOS{,_ohlc,_r3}.csv` | 11+11+5 | **20** | **3** | `U30USD` · **2** |
| 🥇 `…/risultati_archivio/SuperWave/valid_SuperWaveRT_U30USD_H1_**realtick**.csv` | 9 | **20** | **3** | `U30USD` · **2** |
| `…/risultati_archivio/SuperWave/valid_SuperWave_U30USD_H1.csv` | 9 | **20** | **3** | `U30USD` · **2** |
| **preset vivo** `…/FTMO/ABTG_SuperWave_DOW_H1_770511_FTMO.set` | — | **20** | **3** | `US30.cash` · **2** |

**62 passate su 8 file, `20` e `3` su tutte — compresa la validazione a TICK REALI**, che è il
rango più alto che abbiamo.

👉 **Stesso numero, stessi `Digits`, stesso `Point`: il backtest ha misurato la sedia CON le
manopole già inerti.** Il PF, il DD e la frequenza promessi descrivono **questo** comportamento.
🟢 **Nessuno stop è più largo di quanto crediamo, e nessuna promessa è stata fatta su un meccanismo
che in campo non c'è.** Il difetto è di **progetto** (due manopole di regolazione che non
regolano), non di **trasporto**.

### 🧪 Il caso in cui sarebbe PERICOLOSO — l'ho cercato, e **non si verifica**
L'unico modo in cui un buffer inerte fa danno è indebolendo la guardia dello stop troppo stretto:
**r.372** `minDist = MathMax(buf, STOPS_LEVEL*_Point)` → con `buf=0,03` **e `StopsLevelPts=0` misurato
su FTMO**, `minDist` vale **0,03**, cioè la guardia **r.373** `if(risk<minDist)` non scatta mai. Uno
stop quasi nullo farebbe esplodere il lotto di `LotByRisk`.
**Tre ragioni misurate per cui non morde:**
1. 🟢 **Il lotto ha un tetto duro**: **r.551** `MathMax(mn,MathMin(mx,lot))`, con `mx=SYMBOL_VOLUME_MAX` letto a r.548 e `VolMax=1000,00`
   (misurato nel PREVOLO). Con uno stop minuscolo il rischio in EUR **scende**, non sale.
2. 🟢 **Il margine blocca prima**: 1000 lotti × 900,87 $/lotto = **900.870 $** su un conto da
   80.000 → l'ordine viene **rifiutato**, non eseguito.
3. 🟢 **Non è mai successo**: sui **16 trade veri** di `770511` in `data/statements/trades_auto.csv`
   l'escursione mediana ingresso→uscita è **98,50 punti** e la più piccola non-nulla è **12,70**
   (i sei `0,00` sono stop portati in pari). Distanza dalla guardia: **oltre 400×**.
   ⚠️ `n=16` **non esclude la coda**, e lo scrivo come tale.

🟠 **Verdetto: DA GUARDARE — non da toccare.** Due manopole non regolano niente, ma **non
regolavano niente neanche nel backtest**: cambiarle ADESSO significherebbe **cambiare cella su una
challenge pagata**, con una configurazione mai validata. 🔴 **Questa è una misura, non una
proposta.**

## 🪑 1.6 `770260` — Nasdaq Apertura RETEST · `US100.cash` M5 · **🟢 PULITA**
`ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set` → `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5`
**Zero `PipSize`.** 166 chiavi: è il preset più grande della rosa, e quello con più manopole spente.

| input | valore | uso (file:riga) | valore VERO | giudizio |
|---|---:|---|---:|---|
| `InpBufferPoints` | 200 | r.2342 `bufPts = InpBufferPoints` → `*_Point` | **2,00 idx** = **1,31× spread** | 🟠 **il più stretto della rosa** — ma è il contratto misurato |
| `InpMinStopPts` | 500 | r.1554 | floor **5,00 idx** = **3,3× spread**, **ATTIVO** | 🟢 plausibile |
| `InpSkipIfTight` | false | r.1556-1557 | allarga lo stop, non salta | 🟢 coerente |
| `InpSRProximityPts` | **1500** | r.1986 `thr = InpSRProximityPts*_Point` | sarebbe **15,00 idx**, ma **INERTE**: `InpUseSRFilter=false` | ⚪ inerte |
| `InpGapMinPoints` | 150 | r.1620, ramo GAPFILL | **INERTE**: `InpEntryMode=2`, e r.737 `if(InpEntryMode==ABTG_GAPFILL)` con `ABTG_GAPFILL`=1 | ⚪ inerte |
| `InpTrailFixedPts` 410 · `InpRoundMinDistPts` 50 | — | come §1.1 | **INERTI** | ⚪ inerti |
| `InpRetestOffsetPts` · `InpFadeOffsetPts` · `InpSlippagePts` · `InpMinRangePts` · `InpMaxRangePts` | 0 | — | spenti | ⚪ off |

🟢 **Verdetto: PULITA.** 🧪 **Il tranello da smontare**: `InpUseGapFill=true` **sembra** accendere il
gap filter con una soglia di 1,50 punti indice (praticamente lo spread). **Non lo accende**: la
logica GAPFILL gira solo se `InpEntryMode == ABTG_GAPFILL` (=1), e il preset è a **2** (RETEST).
Il flag `InpUseGapFill` è **legacy** — r.521-522 del sorgente lo dice testualmente. **Zero impatto.**

---

## 🟢 1.7 LA BUONA NOTIZIA, DETTA FORTE — e misurata

> # 🟢 **SEI SEDIE SU SEI: NESSUNO STOP PIÙ LARGO DEL PREVISTO, NESSUNA SEDIA MUTA.**
> - **5 sedie su 6** (`770101` `770411` `770202` `771531` `770260`) **non contengono `PipSize()`**:
>   ogni distanza è `× _Point`, e `_Point` è **0,01 su BCM e su FTMO** per tutti e tre gli indici.
>   **Il trasporto BCM→FTMO è esatto per costruzione.**
> - **1 sedia su 6** (`771531` EMA200) non usa **nemmeno `_Point`**: è tutta ad ATR. **Immune.**
> - **1 sedia su 6** (`770511`) ha soglie in pip, e sono **inerti — ma lo erano già nel CSV che
>   l'ha promossa**. Contratto **identico**, non rotto.
> - **10 manopole** risultano inerti nella rosa. 🟢 **Nessuna lo è per un errore di unità**: tutte
>   per un `if` esplicito (enum di modalità, flag `false`, valore a `0`). È la differenza fra una
>   manopola *spenta di proposito* e una manopola *rotta*.
> - **Zero casi** in cui il preset vivo contraddice il CSV che ha promosso la sedia.
>
> 🎯 **La domanda che ha aperto il turno — *«o la sedia non entra mai, o entra con uno stop cento
> volte più largo»* — ha risposta NEGATIVA su tutte e sei. La classe 598 non è entrata nella
> challenge.**

---

# 2. 📋 LA TABELLA COMPLETA — input sospetto × EA × preset

## 2.1 I due meccanismi d'unità presenti nel parco EA

| meccanismo | dove | l'unità dipende da…? | rischio classe 598 |
|---|---|---|---|
| **`× _Point`** | tutte le famiglie *Apertura*, *MaxMinNotte*, *AltaVelocita* | dal **simbolo**, ma in modo **monotòno e dichiarato**: 1 punto MT5 = 1 `_Point`, sempre | 🟢 **basso** — trasporta bene fra broker con gli stessi `Digits` |
| **`× PipSize()` / `÷ PipSize()`** | **24** sorgenti su 115 (§2.2) | da un **`if` sui `Digits`**: `_Point*10` se `Digits∈{3,5}`, altrimenti `_Point` → **salto di 10×** | 🔴 **alto** |

## 2.2 Gli EA con `PipSize()` — chi tocca la rosa FTMO e chi no

| EA | riga di `PipSize()` | in campo su FTMO? | preset FTMO | simbolo · `Digits` | esito |
|---|---:|---|---|---|---|
| `ABTG_SuperWave_DOW_H1_Ottimizzato` | 248 | 🔴 **SÌ** (`770511`) | `…770511_FTMO.set` | `US30.cash` · **2** | 🟠 2 input inerti, **contratto intatto** (§1.5) |
| `ABTG_PostNews` | 137 | 🟡 **preset presenti, sedie «blocco a parte»** | `771202`/`771204` EURUSD, `771203` USDJPY | USDJPY · **3** *(misurato)*; EURUSD · `[NON MISURATO]` | 🟢 su `Digits∈{3,5}` `PipSize` è **corretto** (§2.4) |
| `ABTG_Nightly`, `ABTG_Nightly_Ottimizzato` | 109 | ❌ no | — | — | 🔴 **l'origine della classe 598** (§3) |
| `ABTG_PTE`, `ABTG_PTE_Ottimizzato` | 283 / 317 | ❌ no (demo) | — | `771321` su **U30USD** | 🟠 `InpSLbufferPips=5` → **0,05 idx** (§2.5) |
| `ABTG_SupertrendReversal` (+ `_Multi`, `_Ottimizzato`, 6 `ABTG_SupRev_*`) | 247 / 125 / 245 / 122 | ❌ no (demo) | — | `770901` XAU·**2**, `770924` 225JPY·**2**, `970912` D30EUR·**2** | 🟠 stessa coppia 20/3 → **0,20 / 0,03** (§2.5) |
| `ABTG_SuperWave`, `_DAX_H4_Ottimizzato` | 248 | ❌ no | `770512` **non in campo** (`FLOTTA_ATTIVA.md` r.46) | — | ⚪ |
| `ABTG_BreakoutCorso`, `ABTG_FiboH4_Corso`, `ABTG_FiboH4_Multi`, `ABTG_HARSI`, `ABTG_Londra_ORB`, `ABTG_MIS_SIZING_SWDOW` | 666/353/333/280/107/162 | ❌ no | — | — | ⚪ fuori perimetro |

## 2.3 Gli input `Pts`/`Points` della rosa — uso verificato riga per riga

🟢 **Il controllo che conta su questa famiglia è il confronto d'unità ai due lati del `<`**, e
**torna su tutti**: a sinistra una grandezza **divisa** per `_Point`, a destra la soglia in punti.

| EA (sedia) | confronto | file:riga | esito |
|---|---|---|---|
| `ABTG_Dow_Apertura_US` (`770202`) | `rangePts=(gRangeHigh−gRangeLow)/_Point` vs `InpMin/MaxRangePts` | r.872-876 | 🟢 coerente |
| `ABTG_Dow_Apertura_US` (`770202`) | `gap=(todayOpen−prevClose)/_Point` vs `InpGapMinPoints` | r.1388-1390 | 🟢 coerente *(e ramo morto)* |
| `ABTG_DAX_Apertura_EU` (`770101`) | idem, 5 occorrenze | r.1173·1262·1369·1488·1574 | 🟢 coerente |
| `ABTG_Nasdaq_Apertura_US` (`770260`) | idem, 6 occorrenze | r.969·1062·1172·1294·1394·1500 | 🟢 coerente |
| `ABTG_MaxMinNotte_DAX_Short_Ott.` (`770411`) | `widthPts=(gBoxHigh−gBoxLow)/_Point` vs `InpMin/MaxBoxPts` | r.229-231 | 🟢 coerente |
| tutte e quattro | `dist < InpMinStopPts*_Point`, log con `dist/_Point` | vedi §1 | 🟢 coerente |

## 2.4 🧪 Il caso in cui i tre PostNews sarebbero SPORCHI — e perché non lo sono
`ABTG_PostNews` usa `PipSize()` a r.313 e r.392, e i suoi preset FTMO portano
`InpSLpips=25`, `InpTPpips=50/30`, `InpTrailTriggerPips=25`, `InpRiskRefSLpips=50`.
**Sarebbero sporchi su un simbolo con `Digits∉{3,5}`.** Non lo sono:
- `USDJPY` **`Digits=3` MISURATO** su FTMO (PREVOLO §`[SIMBOLI]`) → `PipSize=_Point*10=0,01` →
  `InpSLpips=25` = **0,25 yen**. 🟢 Corretto.
- `EURUSD` (`771202`, `771204`): **🔴 `Digits` su FTMO `[NON MISURATO]`** — la sonda del 20/09 ha
  interrogato **5 simboli** e EURUSD non c'era. Su **BCM** è `Digits=5` (misurato) →
  `PipSize=0,0001` → 25 pip. 🟡 **Verosimile, non verificato.** Va in §5.
- 🟢 **Controprova che il meccanismo è stato capito da chi ha scritto i preset**:
  `ABTG_PostNews_USD1330_XAUUSD.set` (XAUUSD, `Digits=2`) porta `InpSLpips=**1200**` e
  `InpTPpips=1440` — cioè **12,00 / 14,40 USD**, i valori giusti **scalati di 100×**. Qualcuno
  **sapeva** e ha compensato. Non è un preset FTMO, ma prova che la compensazione esiste in casa.

### 🔴 2.4-bis — E UN DIFETTO VERO, TROVATO STRADA FACENDO
`mql5/Experts/ABTG_PostNews.mq5` r.183-188 contiene quello che si presenta come un **autotest sul
pip**:
```
int dg = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
double pipAtteso = (dg==3 || dg==5) ? _Point*10.0 : _Point;
bool okPip = (MathAbs(PipSize() - pipAtteso) < 1e-12);
if(!okPip) falliti++;
```
🔴 **`pipAtteso` è la stessa identica formula di `PipSize()` (r.137-141). Il test confronta la
funzione con se stessa: `okPip` è VERO per costruzione e non può fallire mai.**
👉 Stamperebbe `[ok ]` anche su `D30EUR` con `PipSize=0,01`, cioè **proprio nel caso che dovrebbe
segnalare**. È **conferma travestita da verifica** — la classe di errore che `CLAUDE.md` descrive
al 10/09 (*«avevo controllato che la mia risposta fosse COERENTE con quello che mi aspettavo,
invece di provare a ROMPERLA»*), questa volta **scritta dentro un EA**.
⚪ **Impatto operativo oggi: ZERO** (i simboli PostNews hanno i `Digits` giusti, e nessuna delle sei
sedie che aprono posizioni usa questo EA). 🔴 **Impatto latente: è un allarme che non suonerà mai.**

## 2.5 Fuori dalla rosa FTMO, stessa classe — segnalato, non toccato
Sedie **sui conti demo** (`FLOTTA_ATTIVA.md`), non sulla challenge:

| sedia | EA | simbolo · `Digits` | input | valore vero |
|---|---|---|---|---:|
| `771321` PTE DOW | `ABTG_PTE` r.469-470 | `U30USD` · **2** | `InpSLbufferPips=5,0` | **0,05 idx** 🟠 inerte |
| `770901` SupRev Oro | `ABTG_SupertrendReversal` r.388/428 | `XAUUSD` · **2** | `20` / `3` | **0,20 / 0,03 USD** 🟠 inerte |
| `770924` SupRev Nikkei | idem | `225JPY` · **2** | `20` / `3` | **0,20 / 0,03** 🟠 inerte |
| `970912` SupRev DAX H4 | `ABTG_SupRev_DAX_H4_Ott.` r.122 | `D30EUR` · **2** | `20` / `3` | **0,20 / 0,03** 🟠 inerte |
| 🟢 `771322` PTE GBPUSD | `ABTG_PTE` | `GBPUSD` · **5** | `InpSLbufferPips=5,0` | **5,0 pip veri** ✅ |

> 🧪 **Le ultime due righe sono il discriminante della classe, servito su un piatto**: `771321` e
> `771322` sono **lo stesso EA con lo stesso identico `5.0` nel preset**. Su `U30USD` vale **0,05
> punti indice**, su `GBPUSD` vale **5 pip veri**. **Un fattore 100 fra due sedie gemelle, e nel
> file `.set` il numero è lo stesso.** Questa è la classe 598 vista in un solo colpo d'occhio.

🛑 **Non propongo niente su queste**: sono fuori dal perimetro FTMO e la decisione è di Claudio.

---

# 3. 📐 LA REGOLA OPERATIVA — e il conteggio VERIFICATO

## 3.1 🔢 Il conteggio: la stima *«almeno 11 CSV e ~50 passate»* **va corretta**

Ho contato i file, non li ho ricordati. Metodo: lettura diretta dei CSV, colonna `Trades`.

| gruppo | CSV a `Trades=0` | passate | è davvero classe 598? |
|---|---:|---:|---|
| `Nightly` **D30EUR, U30USD, XAUUSD** (IS+OOS) | **6** | **12** | 🟢 **SÌ** — `Digits=2` → soglia 0,45 |
| `Nightly` **XAGUSD** (solo IS) | **1** | **2** | 🟢 **SÌ** — stessa soglia 0,45 USD |
| `Nightly` **AUDUSD, USDJPY** (IS+OOS) | **4** | **8** | 🔴 **NO** — è il **cancello per NOME** (r.133-137 + r.167). Questa regola **non lo prende** |
| `MaxMinNotte` **EURUSD OOS** | **1** | **2** | 🟢 **SÌ** — `InpBufferPoints=1000` su `Digits=5` = 100 pip |
| `OpeningReversalB` U30USD OOS (×2 copie) | **8** | **22** | 🔴 **NO** — 🧪 **falsificato da me**: gli stessi CSV **IS** hanno `InpMinStopPts=500` **identico** e fanno **3 trade su 3 passate**. Un input uguale nei due rami non può spiegare lo zero di uno solo |

### 🎯 Il numero onesto
| | CSV | passate |
|---|---:|---:|
| ✅ **classe 598 verificata** | **8** | **16** |
| 🟡 *tutti gli zeri di `Nightly`* (la lettura più generosa) | 11 | 22 |
| 🔴 stima ricevuta | 11 | **~50** |

- 🟡 **«11 CSV» è vero solo contando tutti gli zeri di `Nightly`**, e **4 di quegli 11 appartengono a
  un'altra classe**: la regola, applicata alla lettera, **non li avrebbe salvati**. Il numero
  difendibile è **8**.
- 🔴 **«~50 passate» NON è sostenuto da nessun raggruppamento**: gli 11 CSV contengono **22**
  passate (2 per file, verificato su tutti e 20 i CSV di `Nightly`). Il sottoinsieme della classe
  ne contiene **16**. Per arrivare a ~50 bisognerebbe sommare `OpeningReversalB`, **che ho
  falsificato**.
- 🟢 **Ma la sostanza regge**: 8 CSV e 16 passate buttate per una soglia in pip su un simbolo a 2
  decimali, **e soprattutto 8 verdetti «zero trade» che rischiavano di diventare «nessun edge»**.
  Il valore della regola **non è il tempo macchina: è il verdetto sbagliato che evita.**

## 3.2 🧪 E il DISCRIMINANTE oro/argento, come mi è arrivato, **non regge** — ma la conclusione sì
Il brief dice: *«XAGUSD ha `Digits=3` → `PipSize=_Point*10` → **ci sta sotto** → e infatti fa 4
operazioni. Due metalli, stessa soglia nominale, esiti opposti, esattamente come predice
l'aritmetica dei `Digits`»*. **Ho fatto il conto, e l'aritmetica dei `Digits` predice il
contrario:**

| simbolo | `Digits` *(misurato, sonda BCM 17/08)* | `_Point` | `PipSize()` | soglia vera di `InpMaxNightVolPips=45` |
|---|---:|---:|---:|---:|
| `XAUUSD` | **2** | 0,01 | `_Point` = **0,01** | **0,45 USD** |
| `XAGUSD` | **3** | 0,001 | `_Point×10` = **0,01** | **0,45 USD** |

🔴 **La soglia effettiva è la STESSA sui due metalli: 0,45 USD.** I `Digits` diversi **non**
producono soglie diverse — `0,01×1` e `0,001×10` fanno lo stesso numero. Quindi **quel
discriminante non discrimina**, e usarlo come prova sarebbe stato un colpo di fortuna.

🟢 **La causa vera della divergenza è il LIVELLO DI VOLATILITÀ, e l'ho misurata** ricostruendo le
barre H1 dai dati M1 in repo (`backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026/XAUUSD_M1_UTC_2025.csv`):

| XAUUSD, anno 2025 | valore |
|---|---:|
| barre H1 ricostruite | **5.905** |
| range H1 **medio** | **11,625 USD** |
| mediana | 9,280 USD |
| 1° percentile | 2,360 USD |
| **barre H1 sotto la soglia 0,45 USD** | 🔴 **0 su 5.905 = 0,00%** |
| *(solo ore 22-05 UTC, n=1.973)* | media 11,054 · **0,00% sotto soglia** |

👉 **Sull'oro il filtro esclude il 100% delle notti: 25,8 volte troppo stretto.** Sull'argento,
che quota ~40 USD invece di ~3.500, un range H1 sotto 0,45 USD è normale → **passa**, e infatti
l'OOS fa 4 operazioni. 🟢 **Il verdetto «il filtro blocca tutto sui `Digits=2`» resta in piedi — ma
la prova che lo regge è l'ATR misurato, non l'aritmetica dei `Digits`.**
📌 *Nota di giustizia: `report/I_CSV_A_ZERO_PERCHE_2026-09-22.md` riga #4 scrive correttamente
«`XAGUSD` … → soglia **0,45 USD**». L'errore è nella **parafrasi** che mi è arrivata, non
nell'originale.*

## 3.3 📐 LA REGOLA, in forma operativa

> # 📏 **REGOLA DELL'UNITÀ — prima di lanciare un round su un simbolo NUOVO, e prima di caricare un preset su un broker NUOVO**
> **Costo: 3 minuti. Va eseguita in quest'ordine, e il punto 1 non si salta.**

**① Il `Digits` del simbolo si LEGGE, non si assume.**
Fonte ammessa: una **sonda** (`ABTG_InfoBroker`, `ABTG_PrevoloFTMO_Specifiche`) o un CSV di
specifiche. Se non c'è, il verdetto è **`[NON MISURATO]`** e la riga non parte.
*Perché è il punto 1: tutto il resto è una moltiplicazione per un numero che sta qui.*

**② Si cerca `PipSize` nel sorgente — `grep -c 'PipSize' <EA>.mq5`.**
- **= 0** → l'unità è `_Point`, **stabile per simbolo**. Rischio basso: basta il punto ④.
- **> 0** → 🔴 l'unità **salta di 10×** fra `Digits∈{3,5}` e tutto il resto. Si passa al ③.

**③ Si elencano gli input sospetti per USO, non per nome.**
Sospetto = *moltiplicato per `_Point`* · *moltiplicato o diviso per `PipSize()`* · *confrontato con
un prezzo o un ATR*. 🔴 **Il nome e il commento non bastano, e si sbaglia in tutte e due le
direzioni**: `ABTG_EMA200` ha **tre commenti che dicono «pip»** e **zero `_Point` nel codice**
(falso positivo); `ABTG_MaxMinNotte` ha `InpBufferPoints` che su EURUSD vale **100 pip** (falso
negativo del nome, che dice «Points» e sembra innocuo).

**④ Si calcola il valore VERO nell'unità dello strumento e lo si divide per una grandezza MISURATA dello stesso simbolo** — spread al tick, ATR, range d'apertura. **Mai per una memoria.**

**⑤ Si classifica col numero accanto:**
| esito | criterio | esempio di stanotte |
|---|---|---|
| 🟢 **plausibile** | fra **0,5×** e **50×** il riferimento | `770202` buffer 10,00 idx = 3,8× spread |
| 🟠 **inerte** | soglia/buffer **< 0,1×** il riferimento, o tetto **> 10×** la grandezza che dovrebbe limitare | `770511` pendente 0,20 idx = **0,076×** spread |
| 🔴 **pericoloso** | stop/buffer **> 10×** l'atteso, **oppure** un filtro che esclude **> 95%** dei casi | `Nightly` su XAUUSD: **100% delle 5.905 barre H1** escluse |

**⑥ Prima di scrivere 🔴, si cerca la PROVA CHE È INNOCUO — e se c'è, vince quella.**
Tre forme, tutte trovate stanotte: un **enum di modalità** che non seleziona quel ramo
(`InpTrailMode=1` ≠ `FIXED=2` → `InpTrailFixedPts` inerte su **tre** sedie); un **flag a `false`**
(`InpUseSRFilter`, `InpUseRoundLevels`); una **guardia `if(Inp… > 0)`** con l'input a `0`
(`InpMinStopPts=0` su `770101`, che rende inerte anche `InpSkipIfTight=true`).

**⑦ Poi la domanda che vale più di tutte: il valore è lo STESSO nel CSV che ha promosso la cella?**
Se sì → 🟢 **contratto intatto**, anche se la manopola è inerte. Se no → 🔴 **contratto rotto**, e
quello è un fatto da scrivere subito. *È il passo che ha assolto `770511`.*

### 🧪 IL CONTRO-ESEMPIO CHE FA SCATTARE LA REGOLA
> **Due sedie gemelle, stesso EA, stesso numero nel `.set`, comportamento diverso di 10× o 100×.**
> Il caso di riferimento è `771321` / `771322` (§2.5): `InpSLbufferPips=5.0` in tutti e due i
> preset; **0,05 punti indice** su `U30USD` (`Digits=2`), **5 pip veri** su `GBPUSD` (`Digits=5`).
>
> 🔴 **E la forma in cui il difetto si presenta di solito NON è un crash: è un CSV a `Trades=0` che
> qualcuno legge come «il motore non ha edge».** Quando un CSV esce a zero su un simbolo e non a
> zero sul suo gemello, **il punto ① viene PRIMA di qualunque conclusione sul motore.**

---

# 4. 🧪 I CONTRO-ESEMPI — «se avessi torto, cosa dovrei vedere?»

| ciò che ho dichiarato | l'ipotesi che lo ammazzerebbe | che cosa dicono i dati | esito |
|---|---|---|---|
| **`771531` è immune** | «un input ad ATR nascosto viene convertito in punti da qualche parte» | `grep -n '_Point' ABTG_EMA200.mq5` → **zero righe** su 690. `grep -c 'PipSize'` → **0** | 🟢 regge |
| **5 sedie su 6 trasportano bene BCM→FTMO** | «FTMO usa `Digits` diversi da BCM sugli indici» | PREVOLO: GER40/US30/US100 **`Digits=2`, `Point=0,01`**. Sonda BCM: D30EUR/U30USD/NASUSD **`Digits=2`, `Point=0,01000000`**. **Identici** | 🟢 regge |
| **`InpTrailFixedPts=410` è inerte** | «`InpTrailMode=1` **è** FIXED» | enum: `ATR=0`, **`PREVBAR=1`**, `FIXED=2` — verificato in **tutti e tre** i file: DAX r.242-244, Dow r.209-214, Nasdaq r.189-192. I preset portano **1** | 🟢 regge |
| **`InpGapMinPoints` è inerte su `770260`** | «`InpUseGapFill=true` basta ad accendere il gap» | r.737 `if(InpEntryMode==ABTG_GAPFILL)` con `ABTG_GAPFILL=1`; preset a **2**. r.521-522 dichiara `InpUseGapFill` **legacy** | 🟢 regge |
| **`770511` è inerte ma NON pericoloso** | «il buffer a 0,03 disarma la guardia dello stop stretto → lotto enorme» | tetto `VolMax=1000` (r.548-551) · margine 900.870 $ > conto 80.000 → ordine rifiutato · 16 trade veri, mediana **98,50**, minima non-nulla **12,70** | 🟢 regge, ⚠️ con `n=16` |
| **`770511` ha il contratto intatto** | «il backtest girava con valori diversi» | **8 file dell'EA stesso, 62 passate** (IS, OOS *e* `valid_SuperWaveRT_U30USD_H1_realtick`): `InpPendingPips` **sempre 20**, `InpSLBufferPips` **sempre 3**, sempre su `U30USD` `Digits=2` | 🟢 regge |
| **`OpeningReversalB` NON è classe 598** | «`InpMinStopPts=500` strozza l'OOS» | lo **stesso** `500` nei CSV **IS**, che fanno **3 trade su 3 passate**. Un valore identico nei due rami non spiega lo zero di uno solo | 🟢 **falsificata l'attribuzione** |
| **il discriminante XAU/XAG è mal posto** | «i `Digits` diversi danno davvero soglie diverse» | `0,01×1 = 0,001×10`: **0,45 USD su tutti e due**. La divergenza è l'ATR: **0/5.905** barre H1 d'oro sotto 0,45 | 🔴 **ipotesi ricevuta CADUTA**, conclusione salva |
| **la stima «~50 passate»** | «esiste un raggruppamento che ci arriva» | 20 CSV `Nightly` × **2 passate ciascuno** = 40 totali, **22** a zero. Nessun raggruppamento difendibile arriva a 50 | 🔴 **stima CORRETTA a 16** |

---

# 5. 🔴 NON COPERTO — dichiarato

1. ❌ **Non ho letto i preset VERI sul terminale FTMO: ho letto i `.set` in repo.** MT5 salva i
   parametri vivi nel `.chr` del grafico, e **un input cambiato a mano in MT5 non torna nel `.set`
   di repo.** Tutto §1 vale se e solo se il caricamento è avvenuto senza modifiche manuali.
   *Via più corta: la riga di sola lettura già scritta in `report/BINARI_IN_CAMPO_FTMO_2026-09-21.md`
   legge i `.chr`. 🔴 **Non l'ho eseguita e non la propongo: è una riga verso il VPS.***
2. ❌ **Non so se i binari `.ex5` in campo corrispondono ai sorgenti che ho letto.** È **la stessa
   lacuna** del 12/09 (`ABTG_EMA200` a 486 righe contro 690): un `.ex5` vecchio può avere input
   diversi e **ignora in silenzio** le chiavi che non conosce. Il documento sopra lo dice:
   *«la riga non è ancora stata eseguita»*. 🔴 **Il mio §1 descrive i SORGENTI, non i binari.**
3. ❌ **`Digits` di `EURUSD` su FTMO: `[NON MISURATO]`.** La sonda del 20/09 ha interrogato **5**
   simboli (GER40, US30, US100, XAUUSD, USDJPY) e EURUSD non c'era. Tocca `771202` e `771204`.
   Su BCM è 5. **Verosimile ≠ verificato.**
4. ❌ **`StopsLevelPts` di BCM su `U30USD`/`D30EUR`/`NASUSD`: `[NON MISURATO]`** — la sonda
   `ABTG_InfoBroker` non ha quella colonna. Entra in `EffectiveBuffer()` come `MathMax(…)`. 🟢 Non
   cambia le mie conclusioni (i buffer 200/500/1000 sono ≥ del solo valore noto, 100 su NASUSD),
   ma **non posso escludere** che su BCM il floor mordesse e su FTMO (dove vale **0**) no.
5. ❌ **La coda del lotto su `770511` è bounded, non esclusa.** `n=16` trade veri.
   La guardia `minDist` **è effettivamente disarmata** (0,03 con `StopsLevel=0`): ciò che protegge
   sono `VolMax` e il margine, cioè **un ordine rifiutato**, non una regola di rischio.
6. ❌ **Non ho verificato le sedie dei conti demo** (`50503392`, `50504263`) oltre a nominarle:
   §2.5 elenca **cinque** casi della stessa classe fuori dalla rosa FTMO, **e nessuno di loro è
   stato misurato contro il suo CSV di promozione** come ho fatto per `770511`.
7. ❌ **Ho censito gli input per USO all'interno degli EA della rosa; sugli altri 109 `.mq5` il
   censimento è per NOME e per commento** — cioè con lo stesso limite che denuncio al §3.3 ③.
   Un input che porta un'unità **senza dirlo nel nome** su un EA fuori rosa mi è sfuggito.
8. ❌ **Nessun numero qui dentro viene dal campo di stanotte.** Spread e `Digits` sono del **20/09
   alle 17:08**, l'ora più calma. Lo spread FTMO **all'apertura cash** resta `[NON MISURATO]` —
   è già scritto in `report/STOP_VS_SPREAD_FTMO_2026-09-20.md`, e **peggiorerebbe tutti i
   rapporti «× spread» del §1**, mai migliorarli.

---

## 📎 FONTI
`mql5/Presets/FTMO/*.set` · `mql5/Experts/{ABTG_DAX_Apertura_EU, ABTG_Dow_Apertura_US,
ABTG_Nasdaq_Apertura_US, ABTG_EMA200, ABTG_MaxMinNotte_DAX_Short_Ottimizzato,
ABTG_SuperWave_DOW_H1_Ottimizzato, ABTG_PostNews, ABTG_PTE, ABTG_SupertrendReversal}.mq5` ·
`backtest_pipeline/risultati_prove/PREVOLO_FTMO_specifiche_2026-09-20.csv` ·
`backtest_pipeline/risultati_archivio/sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv` ·
`backtest_pipeline/risultati_prove/ABTG_SuperWave_DOW_H1_Ottimizzato/*.csv` ·
`backtest_pipeline/risultati_archivio/SuperWave/valid_SuperWave{,RT}_U30USD_H1*.csv` ·
`backtest_pipeline/risultati_prove/ABTG_Nightly/*.csv` (20 file) ·
`backtest_pipeline/risultati_prove/oro_m1_utc_2021_2026/XAUUSD_M1_UTC_2025.csv` ·
`data/statements/trades_auto.csv` · `report/{STOP_VS_SPREAD_FTMO_2026-09-20,
SCHIERAMENTO_FTMO_2026-09-20, BINARI_IN_CAMPO_FTMO_2026-09-21, PRIMO_STOP_FTMO_2026-09-22,
I_CSV_A_ZERO_PERCHE_2026-09-22}.md` · `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (classe 598)
· `FLOTTA_ATTIVA.md`
