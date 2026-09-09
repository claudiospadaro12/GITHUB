# 💎 LA MINIERA — LE MANOPOLE CHE NON HANNO MAI MORSO
### Referto del 09/09/2026 · misura su **2.069 CSV di risultati** e **61.633 passate di tester**

> Claudio, 09/09: _"MAI LASCIARE NULLA INDIETRO, POTREMMO PENTIRCENE."_
> Questo referto e' letteralmente l'inventario di cio' che e' stato lasciato indietro.

**Script che rigenera tutto:** `backtest_pipeline/manopole_inerti.py`
(1,6 secondi, nessuna dipendenza esterna, rilancialo quando vuoi).

---

## 🧪 1. LA METRICA — dichiarata PRIMA dei numeri

Una manopola **HA MORSO** se, girandola **a parita' di tutte le altre**, l'esito cambia.

### Metrica primaria: **TEST CETERIS PARIBUS**
1. Si raggruppano le passate di un CSV per il valore di **tutte le altre** colonne `Inp*`
   (il "contesto"). Dentro un contesto l'unica cosa che cambia e' la manopola in esame.
2. Se in quel contesto la manopola prende **>= 2 valori**, il gruppo e' un
   **CONFRONTO VALIDO**.
3. Se quel gruppo produce **>= 2 esiti distinti**, la manopola **ha morso** li' dentro.
4. `morso% = gruppi_con_esito_diverso / gruppi_confrontabili`
5. `dPF = max(PF) - min(PF)` dentro il gruppo → se ne riporta **mediana e massimo**.

**ESITO** = quadrupla `(Profit, Profit Factor, Trades, Equity DD %)`, arrotondata al 5° decimale.

**Perche' e' questa la metrica giusta e non un'altra.** E' l'unica che **isola** la manopola.
Su una griglia fattoriale del tester le altre colonne sono bilanciate per costruzione, quindi
il confronto e' pulito senza bisogno di modelli. Una varianza spiegata (`eta^2` del PF sulla
colonna) sarebbe **confusa** dagli altri parametri: l'ho implementata come **ripiego** per le
griglie non fattoriali, ma **non e' mai servita** — su **4.508 istanze** (CSV × manopola ad
asse) il confronto ceteris paribus era disponibile **4.508 volte su 4.508**. 🎯

### Tre correzioni di onesta' che cambiano i numeri (e vanno dette)

| Correzione | Perche' | Effetto |
|---|---|---|
| 🔧 **`InpMagic` NON e' spreco** | E' l'**asse tecnico** del cancello G1 di determinismo: due celle gemelle sul magic **devono** dare lo stesso esito. Un `InpMagic` "inerte" e' un **PASS**, non uno spreco | toglie **41 coppie** e **943 passate** dal conto dello spreco |
| 🔧 **Motore muto ≠ manopola inerte** | Se una corsa fa 0-2 operazioni, l'esito e' identico perche' non c'e' niente da misurare. Filtro: conto solo i gruppi con **almeno una passata a >= 30 operazioni** ("gruppi vivi") | separa **1.028** passate di spreco "da motore muto" dalle **1.401** "da manopola morta" |
| 🔧 **Un centesimo non e' non-determinismo** | 4 gruppi su 949 dell'asse `InpMagic` differiscono di **0,01 sul Profit** con PF, Trades e DD **identici** (`risultati_prove/ABTG_Dow_Apertura_US/ABTG_Dow_Apertura_US_U30USD_IS_ptc.csv`: −2156,13 vs −2156,14) | il **cancello G1 e' PASSATO 949/949** a tolleranza di 1 centesimo |

---

## 📊 2. IL CONTEGGIO — i numeri che dicono quanto vale questo lavoro

| Misura | Numero |
|---|---:|
| CSV di risultati letti (`risultati_archivio` + `risultati_prove` + `prove`) | **2.069** |
| … di cui con almeno una passata a `Trades > 0` | **1.960** ✅ *coincide col censimento del 09/09* |
| **Passate di tester totali** | **61.633** |
| Esiti distinti totali (per CSV) | **40.692** |
| 🔥 **Passate che NON hanno prodotto un esito nuovo** | **20.941** — **34,0%** |
| Passate con `Trades > 0` | 45.865 ✅ *coincide col censimento* |
| … di cui senza esito nuovo | **5.885** (12,8%), su **874 CSV su 1.960** ✅ *coincide* |
| Passate che hanno prodotto **ZERO operazioni** | **15.768** (25,6%) |
| Colonne `Inp*` distinte presenti nei CSV | **552** |
| … **mai messe ad asse in nessun CSV** | 🕳️ **444** (80,4%) |
| Coppie (motore × manopola) effettivamente misurate | **280** · 239 escluso `InpMagic` |
| **Coppie INERTI** (0 gruppi vivi con esito diverso) | 🔴 **10**, su **8 motori** |
| Coppie **quasi-inerti** (< 50% di morso, >= 10 gruppi vivi) | 🟠 **7** |
| Coppie che mordono nel **100%** dei gruppi | 🟢 **159 su 239** |

### 💸 LE PASSATE SPESE PER NON MISURARE NIENTE

| Voce | Passate | Note |
|---|---:|---|
| 🔴 **Spreco vero su manopole inerti** | **2.429** su **107 CSV** | di cui **1.401** su corse VIVE (>= 30 operazioni) e **1.028** su corse MUTE (il motore non fa trade su quel simbolo) |
| 🟢 Asse tecnico `InpMagic` (cancello G1) | 943 | **NON e' spreco**: e' il controllo di determinismo, e ha passato |

**Costo in tempo macchina — con calibrazione MISURATA, non stimata.**
Da `risultati_archivio/r88_csv/REFERTO_R88.txt` (27 round cronometrati, notte del 19-20/08):
**da 2,9 s/passata** (`R87b_griglia_NZDUSD`, 288 passate in 13,8 min) **a 33,0 s/passata**
(`R86a_nudo_XAUUSD`, 4 passate in 2,2 min), **mediana 13,5 s/passata**.

> **2.429 passate × 13,5 s = 9,1 ore di tester** buttate per non misurare niente.
> Forbice completa: **2,0 – 22,3 ore**.
> ⚠️ **E' una SOTTOSTIMA**: quella calibrazione e' su corse **OHLC**. Ma **632 delle 2.429
> passate sprecate (26%) sono a TICK REALI** — 8 file, i piu' grossi
> `Nasdaq_Apertura/apert_US_M5_doc_brk_realtick_U30USD.csv` (139),
> `apert_fade_realtick/apert_APERT_US_M5_fade_realtick_U30USD.csv` (136),
> `Nasdaq_Apertura/apert_US_M5_doc_brk_realtick_NASUSD.csv` (132),
> `DAX_Apertura/apert_DAX_M5_doc_brk_realtick_D30EUR.csv` (87) — e i tick reali
> costano molto piu' dell'OHLC.
> Il costo a tick reali per passata e' **[NON MISURATO]** (nessun referto cronometrato
> di una corsa realtick nell'archivio).

---

## 🕳️ 3. TABELLA A — LE CASELLE LIBERE
### Manopole girate con esito SEMPRE identico, su corse VIVE (>= 30 operazioni)

**Come si legge:** "Esiti distinti" = 1 significa che quella manopola, in tutti i confronti
a parita' del resto, **non ha cambiato nemmeno un centesimo**. La casella non e' "provata":
e' **libera**.

| Motore | Manopola | Round / cartella dove e' stata "provata" | Valori provati | Gruppi di confronto | Esiti distinti | HA MORSO? | 🔎 Causa VERIFICATA NEL SORGENTE |
|---|---|---|---|---:|---:|---|---|
| `ingresso` (DAX + NASDAQ) | **`InpTrailFixedPts`** | `risultati_archivio/Aperture_Ingresso/{DAX,NASDAQ}_ingresso.csv` | 100·200·300·400·500·600·700·800 | 40 | **1** | ❌ **NO** | **(c) ramo mai raggiunto.** `InpTrailMode` era pinnato a **1** = `ABTG_TRAIL_PREVBAR`. `InpTrailFixedPts` e' letto **solo** se `InpTrailMode == ABTG_TRAIL_FIXED (=2)`: `mql5/Include/ABTG/ABTG_ApertureCore.mqh:916-917` (long) e `:929-932` (short) |
| `apert_APERT_US` (U30USD) | **`InpTrailFixedPts`** | `risultati_prove/apert_fade_realtick/apert_APERT_US_M5_fade_realtick_U30USD.csv` | 100…800 | 37 | **1** | ❌ **NO** | idem, `InpTrailMode=1`. Nel Dow: `mql5/Experts/ABTG_Dow_Apertura_US.mq5:1834-1836` |
| `trailing` (DAX + NASDAQ) | **`InpTrailFixedPts`** | `risultati_archivio/Aperture_Trailing/{DAX,NASDAQ}_trailing.csv` | 100…800 | 24 | **1** | ❌ **NO** | idem. ⚠️ **E il round si chiamava "aperture_trailing"** |
| `openconfirm` (DAX + NASDAQ) | **`InpTrailFixedPts`** | `risultati_archivio/Openconfirm/{DAX,NASDAQ}_openconfirm_M15.csv` | 100…800 | 24 | **1** | ❌ **NO** | idem |
| `apert_APERT` (DAX/D30EUR) | **`InpBufferPoints`** | `risultati_prove/apert_fade_realtick/apert_APERT_DAX_M5_fade_realtick_D30EUR.csv` | 100·200·300·400 | 37 | **1** | ❌ **NO** | **(c) ramo mai raggiunto.** Con `InpEntryMode=3` (`ABTG_RANGE_FADE`) l'ingresso e' un LIMIT su `gRangeHigh ± InpFadeOffsetPts` (`ABTG_DAX_Apertura_EU.mq5:1148` e `:1165`): **il buffer non entra nel prezzo**. E lo stop usa `AtrValue()*InpAtrSlMult` (`:1139`), con `EffectiveBuffer()` chiamata **solo se** `slDist <= 0` (`:1140`) — e `InpAtrSlMult` era pinnato a **1,5** |
| `apert_APERT_US` (U30USD) | **`InpRangeMinutes`** | stesso file fade realtick | 5·10·…·60 (12 valori) | 32 | **1** | ❌ **NO** | **(c) ramo mai raggiunto.** Con `InpRangeMode=2` (`ABTG_RANGE_PREVBAR`) `ComputeLevels()` **ritorna prima** di leggere `InpRangeMinutes` (`ABTG_Dow_Apertura_US.mq5:810-818`); e in modalita' FADE `refEndMin = openMin` quando `InpRangeMode != OPENING` (`:662`), quindi neanche il tempo di attesa la usa |
| `MaxMin` (DAX) | **`InpMinBoxPts`** | `risultati_archivio/MaxMinNotte/valid_MaxMin_DAX_short_refine.csv` | 0 · 1500 | 18 | **1** | ❌ **NO** | **(a) valore fuori range rispetto ai dati.** Il filtro e' `if(InpMinBoxPts>0 && widthPts<InpMinBoxPts)` (`ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5:230`): con soglia 1500 punti (=15 punti indice) **il box notturno del DAX non e' mai risultato piu' stretto**. ⚠️ La distribuzione delle ampiezze del box e' **[NON MISURATO]**: so che 1500 non morde, non so da dove inizia a mordere |
| `Live5m` (DAX) | **`InpMinStopPts`** | `risultati_archivio/Live5m/valid_DAX_Live5m_v2_D30EUR_realtick.csv` | 200 · 400 | 16 | **1** | ❌ **NO** | **(a) valore fuori range.** Il pavimento agisce solo `if(InpMinStopPts > 0 && dist < InpMinStopPts*_Point)` (`ABTG_DAX_Live5m_v2.mq5:678` long, `:702` short): con 200/400 punti **la condizione non e' mai scattata**. Distribuzione di `dist` **[NON MISURATO]** |
| `Live5m` (DAX) | **`InpSkipIfTight`** | stesso file | 0 · 1 | 16 | **1** | ❌ **NO** | **(b) condizionata da un input spento.** `InpSkipIfTight` e' letto **dentro** quel `if` (`:680` e `:704`): se il pavimento non scatta mai, il flag non viene nemmeno guardato. **Inerte per costruzione, non per merito** |
| `BreakingBand` | `InpBulgeMinBars` | `risultati_prove/ABTG_BreakingBand/cal1/..._EURUSD_OOS_ohlc_cal1.csv` | 2 · 3 | **1** | 1 | ⚠️ **non concludente** | **1 solo gruppo vivo su 36**: il resto delle corse ha < 30 operazioni. Verdetto: **NON ANCORA MISURATO**, non "inerte" |

### 🟠 Le quasi-inerti — la manopola morde, ma quasi mai

| Motore | Manopola | Round | morso% (gruppi vivi) | Gruppi | Perche' quasi mai |
|---|---|---|---:|---:|---|
| `apert_US` | `InpTrailFixedPts` | `risultati_archivio/Nasdaq_Apertura` | **13,8%** | 109 | Stessa causa (c) della Tabella A: morde **solo** nelle celle dove `InpTrailMode=2`. Nelle altre e' arredamento |
| `apert_US` | `InpRangeMinutes` | `risultati_archivio/Nasdaq_Apertura` | **27,3%** | 99 | Morde solo con `InpRangeMode=0`; con `InpRangeMode=2` e' morta (causa c) |
| `L_rangemode` | `InpRangeMinutes` | `risultati_archivio/Walkforward_Aperture` | 33,3% | 12 | idem |
| `ORB_Ottimizzato` | **`InpUseVolumeFilter`** | `risultati_archivio/r88_csv` (e **0%** in `risultati_prove/ABTG_ORB_Ottimizzato/..._r12`) | **38,1%** | 84 | **(b) condizionata da un input spento — VERIFICATA.** `VolumeOK()` (`ABTG_ORB_Ottimizzato.mq5:531`) e' chiamata **solo** da `TryCloseConfirmEntry()` (`:573`), che gira **solo** dentro `if(InpUseCloseConfirm)` (`:384` → `:398`). Nel round r12 `InpUseCloseConfirm=0` in **tutte** le passate → **48 passate, filtro volume mai letto** |
| `ORB_Ottimizzato` | `InpEndHour` / `InpEndMin` | `r88_csv` | 41,7% | 12 | 21:00 vs 22:59: quasi sempre non c'e' una posizione aperta a quell'ora |
| `GoldenCross_Ottimizzato` | `InpRequireAdxRising` | `r86_r87_r89_csv` | 48,0% | 25 | ⚠️ sul `GoldenCross` base lo stesso flag sta al **19,9%** su 432 gruppi. **Filtro quasi cieco** |

### 🕳️ E la casella libera piu' grande di tutte: **444 colonne `Inp*` mai messe ad asse**

Su 552 colonne `Inp*` presenti nei CSV di risultati, **444 non sono mai state fatte variare
in nessuna corsa**. Molte sono innocue (`InpVerbose`, `InpComment`, `InpNewsFile`), ma le
prime della lista **non lo sono affatto**:

| Colonna mai ad asse | In quanti CSV | Motori |
|---|---:|---:|
| `InpMaxSpread` | 1.598 | 72 |
| `InpUseNewsFilter` / `InpNewsMinImpact` / `InpNewsBeforeMin` / `InpNewsAfterMin` | ~1.588 | ~70 |
| `InpMaxTradesPerDay` | 1.268 | 35 |
| `InpAtrPeriod` | 1.044 | 21 |
| **`InpBreakeven`** | **987** | **36** |
| `InpPendingExpiryBars` | 661 | 23 |
| `InpEmaFast` | 433 | 38 |
| `InpFridayClose` / `InpFridayCloseHour` | 345 | 9 |

🔴 **`InpBreakeven` presente in 987 CSV e mai girato nemmeno una volta**: e' un meccanismo
di **uscita**, la categoria che l'audit del 09/09 (`report/AUDIT_USCITE_2026-09-09.md`)
indica come la piu' sguarnita. Idem il **filtro news** (~70 motori, sempre pinnato).

---

## ✅ 4. TABELLA B — LE MANOPOLE CHE MORDONO DAVVERO
### Ordinate per **quanto spostano il PF** (dPF mediano nei gruppi vivi). Qui vale la pena spendere passate.

| # | Motore | Manopola | **dPF mediano** | dTrade mediano | morso% | Gruppi vivi | Valori girati |
|---:|---|---|---:|---:|---:|---:|---|
| 1 | WOL | **`InpTF`** | **8,422** | 92 | 100% | 27 | M15·M20·M30·H1·H2·H3 |
| 2 | SuperWave | **`InpTF`** | **5,066** | 290 | 100% | 42 | M15·M20·M30·H1·H2·H3 |
| 3 | SupRev | **`InpTF`** | **4,238** | 335 | 100% | 20 | M15·M20·M30·H1·H2·H3 |
| 4 | PTE | **`InpTF`** | **3,732** | 27 | 100% | 71 | H1·H2·H3·H4 |
| 5 | SupertrendReversal | **`InpTF`** | **2,918** | 134 | 100% | 20 | M15·M20·M30·H1·H2·H3 |
| 6 | EMA200 | **`InpTF`** | **1,833** | **1245** | 100% | 22 | M15·M20·M30·H1·H2·H3 |
| 7 | GoldenCross_Ottimizzato | `InpMaxDistATR` | 1,105 | 14 | 100% | 38 | 0,5·1,0·1,5 |
| 8 | larry | `InpPatternMode` | 0,971 | 46 | 100% | 249 | 0·1·2 |
| 9 | apert | `InpDelayMinutes` | 0,890 | 3 | 100% | 29 | 15·30·45 |
| 10 | EMA200 | `InpAllowLong` | 0,761 | 332 | 100% | 2705 | 0·1 |
| 11 | EMA200 | `InpAllowShort` | 0,711 | 300 | 100% | 2649 | 0·1 |
| 12 | GoldenCross | `InpAllowLong` | 0,599 | 43 | 100% | 1749 | 0·1 |
| 13 | GoldenCross | `InpAllowShort` | 0,549 | 28 | 100% | 1617 | 0·1 |
| 14 | SupRevScr | `InpStMult` | 0,544 | 36 | 100% | 90 | 2,5·3,0·3,5 |
| 15 | GapContinuation | `InpMinimumBuyGapPercent` | 0,469 | 30 | 100% | 42 | 0,50…1,75 |
| 16 | SupertrendReversal | `InpAllowLong` | 0,465 | 67 | 100% | 1954 | 0·1 |
| 17 | Apertura | `InpGapMinRR` | 0,456 | 16 | 100% | 20 | 0,5·1,0·1,5·2,0 |
| 18 | PTE | `InpTP1_ATRmult` | 0,430 | 2 | 100% | 22 | 0,0·0,5·1,0·1,5 |
| 19 | SupertrendReversal | `InpAllowShort` | 0,373 | 58 | 100% | 1864 | 0·1 |
| 20 | GoldenCross_Ottimizzato | `InpAdxMin` | 0,357 | 12 | 100% | 42 | 10·15·20·25 |
| 21 | SondaOrologio | `InpOreDurata` | 0,327 | 0 | 100% | 44 | 4·8·12 |
| 22 | CanaleLento | `InpExitMiddle` | 0,313 | 28 | 100% | 20 | 0·1 |
| 23 | SupRevScr | `InpStAtrPeriod` | 0,312 | 12 | 100% | 87 | 8·9·10 |
| 24 | ORB_Ottimizzato | `InpSLMode` | 0,291 | 0 | 100% | 144 | 0·1·2·3 |
| 25 | GoldenCross_Ottimizzato | `InpCrossLookback` | 0,291 | 5 | 100% | 26 | 3·5·7 |

*(116 coppie totali con >= 20 gruppi vivi e morso > 0; qui le prime 25.)*

### 🏆 IL VERDETTO DELLA TABELLA B, in una riga

> **Le SEI manopole che spostano di piu' il PF sono tutte e sei `InpTF`.**
> Il timeframe muove il PF di **1,8 – 8,4 punti** (mediana per gruppo); la migliore
> manopola *non-TF* dell'archivio (`InpMaxDistATR` del GoldenCross) si ferma a **1,105**.
> **Il TF vale piu' di qualunque parametro d'ingresso, di un fattore 2-8.** ✅ Questo e' il
> supporto misurato alla regola di casa _"il TF si cambia sempre almeno una volta"_ e al
> mandato di Claudio _"proviamoli con TUTTI i TF"_ — e dice anche **dove** spendere le
> passate quando ce ne sono poche: **prima il TF, poi tutto il resto**.
>
> ⚠️ Con il vincolo di casa che non si sposta: sugli indici la frontiera del costo
> `stop >= 40 × spread` esclude M5/M15 (regola dell'08/09), quindi "provare tutti i TF"
> vuol dire **M30/H1/H2/H4**, non "scendere all'infinito".

---

## 🔓 5. I CANDIDATI DA RIAPRIRE
### Motori dichiarati "gia' provati" la cui griglia era in realta' inerte

Numeri di PF/n/DD presi da `risultati_archivio/CENSIMENTO_PF_TUTTI_2026-09-09.csv`
(**cella MEDIANA**, non il picco — regola di casa del 16/08).

| # | Candidato | Cosa dice l'archivio oggi | Cosa era **finto** nella griglia | Cosa andrebbe rigirato | Costo (passate × 13,5 s) |
|---:|---|---|---|---|---|
| 🥇 **1** | **`apert_APERT_US` U30USD M5 fade (tick reali)** | PF **0,806** · n=**324** · DD 19,7% | 🔴 **137 passate → 1 SOLO ESITO.** Tutte e tre le manopole ad asse (`InpRangeMinutes`, `InpBufferPoints`, `InpTrailFixedPts`) erano morte insieme | Se il fade sul Dow va riaperto, **le manopole vere sono `InpFadeOffsetPts`, `InpAtrSlMult`, `InpLevelTF`** (con `RangeMode=2` il livello viene da li'), **non** quelle girate | 3 assi × 4 celle = 48 celle × 2 finestre = **96 passate ≈ 22 min** (OHLC) · a tick reali **[NON MISURATO]** |
| 🥈 **2** | **`ingresso` DAX** (geometria d'ingresso, tick reali) | PF **1,031** · n=**408** · DD 17,3% | 🔴 **160 passate → 20 esiti.** Il round e' documentato in `Aperture_Ingresso/INGRESSO.md` come "20 combinazioni per mercato": le altre **140 passate** giravano `InpTrailFixedPts` **con il trailing in modalita' PREVBAR** | **Il documento e' onesto** (dichiara 20 combinazioni), ma il tester ha speso 160 passate. Da rigirare: `InpTrailMode` **come asse vero** (0=ATR / 1=PREVBAR / 2=FIXED) — mai fatto su questo motore | 3 celle × 5 RangeMinutes = 15 celle × 2 = **30 passate ≈ 7 min** |
| 🥉 **3** | **`ingresso` NASDAQ** | PF **0,920** · n=264 · DD 15,6% | idem: 160 → 20 | idem | incluso sopra |
| **4** | **`openconfirm` DAX M15** | PF **0,994** · n=**440** · DD 19,7% | 🔴 **96 passate → 9 esiti.** `InpTrailFixedPts` inerte (24 gruppi) | Un motore a PF 0,994 su 440 operazioni e' **a mezzo punto percentuale dal pari**: la sua **uscita non e' mai stata girata davvero**. `InpTrailMode` + `InpTrailTF` | 3 × 4 = 12 celle × 2 = **24 passate ≈ 6 min** |
| **5** | **`openconfirm` NASDAQ M15** | PF **0,909** · n=204 · DD 8,7% | idem 96 → 9 | idem | incluso sopra |
| **6** | **`trailing` DAX/NASDAQ** | PF **0,947** / **0,894** · n=440 / 260 | 🔴 **96 passate → 7 esiti** (per mercato). Il round si chiamava **"aperture_trailing"** e girava `InpTrailFixedPts` in modalita' PREVBAR | 😅 Il round sul trailing **non ha misurato il trailing**. `InpTrailMode` ad asse **e' il round che manca** | **24 passate ≈ 6 min** |
| **7** | **`apert_US` U30USD / NASUSD "doc_brk" (tick reali)** | PF **1,116** (n=111) / **1,214** (n=72) | 🔴 **143 passate → 4 esiti** e **136 → 4** | 🎯 **I due PF piu' alti del gruppo aperture, misurati con 4 esiti in mano.** Qui non serve una griglia nuova: serve **piu' campione** (n=72 e n=111 sono sotto il muro dei 150) | allungare la finestra, non allargare la griglia. **[costo da preventivare sul TF scelto]** |
| **8** | **`MaxMin` DAX short_refine** | PF **1,187** · n=**107** · DD 7,3% | 🟠 36 passate → 18 esiti; `InpMinBoxPts` inerte (18 gruppi) | Il filtro anti-lateralita' non e' mai stato tarato: **prima si misura la distribuzione dell'ampiezza del box**, poi si sceglie la soglia. Girare 0/1500 alla cieca e' stato uno spreco di 18 passate | 1 sonda + 4 celle × 2 = **8 passate ≈ 2 min** dopo la sonda |
| **9** | **`Live5m` DAX v2 (tick reali)** | PF **0,922** · n=**445** · DD 16,8% | 🟠 **32 passate → 8 esiti**: `InpMinStopPts` **e** `InpSkipIfTight` inerti insieme (16 gruppi ciascuna) | Il pavimento dello stop **e' un parametro di RISCHIO**, e non e' mai stato realmente provato: 200/400 punti sono sotto la distanza tipica. Da rigirare con valori **misurati sulla distribuzione**, non scelti a mano | 1 sonda + 4 celle × 2 = **8 passate ≈ 2 min** |
| **10** | **`ORB_Ottimizzato` NASUSD r12** | PF OOS **0,800** · n=267 | 🔴 **48 passate con `InpUseVolumeFilter` mai letto** (`InpUseCloseConfirm=0`) | ⚠️ Attenzione: `ORB_Ottimizzato` **e' una famiglia con celle vive** (`r88a` PF OOS 1,554 n=119, `r44a` 1,736 n=119). **Il filtro volume non e' mai stato provato sulla cella viva**, perche' la cella viva gira con `InpUseCloseConfirm=0`. Per provarlo serve **girare i due flag INSIEME** (2×2) | 4 celle × 2 = **8 passate ≈ 2 min** |

### 🛑 E il limite, che fa parte dello stesso mandato

**Nessuno di questi e' l'autorizzazione a rifare una griglia larga su un motore morto.**
La regola del 19/08 vale intatta: su un motore senza edge una griglia piu' fitta trova solo
**picchi di rumore**. Quello che cambia qui e' **diverso e piu' forte**: su questi 10 casi
la griglia **non e' stata rifatta piu' fitta — non e' mai stata fatta**. Girare `InpTrailMode`
per la prima volta non e' "un'altra griglia sullo stesso motore": e' **un meccanismo di
uscita mai messo ad asse**, che e' esattamente la corsia che il mandato **apre**
(✅ motori, meccanismi, simboli, TF, gestione dell'uscita).

📐 E ogni riapertura si paga: **finestra fuori campione o prova di regime obbligatoria**.

---

## 🧭 6. ORDINE DI PRIORITA' SUGGERITO (decide Claudio)

Con **~3 settimane alla challenge** e la frequenza come requisito n.1:

| Prio | Cosa | Costo | Perche' adesso |
|---|---|---|---|
| 🥇 | **`InpTrailMode` ad asse su `openconfirm` DAX/NASDAQ + `trailing` + `ingresso`** | **78 passate ≈ 18 min** OHLC | 4 sedie a PF 0,89-1,03 su **204-440 operazioni** (campione **sopra** il muro dei 150 ✅) la cui uscita non e' mai stata misurata. E' il rapporto valore/costo migliore dell'intero referto |
| 🥈 | **`InpUseCloseConfirm` × `InpUseVolumeFilter` su ORB_Ottimizzato** | **8 passate ≈ 2 min** | famiglia con celle gia' vive; il filtro e' scritto e mai eseguito |
| 🥉 | **Sonde di distribuzione** (ampiezza box MaxMin, distanza stop Live5m) | 2 corse | senza queste, rigirare quelle manopole e' rifare lo stesso errore |
| 4 | **`InpBreakeven` ad asse** (987 CSV, 36 motori, **mai**) | 2 celle per motore | e' il buco piu' largo per numero di motori toccati |

---

## 🕳️ 7. I BUCHI — dichiarati

1. ⚠️ **La causa "(a) fuori range" e' verificata solo a meta'.** Per `InpMinBoxPts` (MaxMin) e
   `InpMinStopPts` (Live5m) **so dal sorgente qual e' la condizione** e **so dai dati che non
   e' mai scattata**, ma la **distribuzione** di `widthPts` e di `dist` e' **[NON MISURATO]**:
   non posso dire **da quale valore** quelle manopole comincerebbero a mordere. Serve una sonda.
2. ⚠️ **Il costo per passata a TICK REALI e' [NON MISURATO].** Tutta la calibrazione (2,9-33 s)
   viene da round OHLC cronometrati. Le 407 passate sprecate su corse realtick costano di piu',
   di quanto non lo so.
3. ⚠️ **`motore` e' dedotto dal NOME DEL FILE** (stessa funzione `parse_name` di
   `censimento_pf.py`, copiata verbatim per coerenza). Nomi come `ingresso`, `trailing`,
   `apert_APERT_US`, `L_rangemode` sono **etichette di round**, non nomi di EA. L'attribuzione
   all'EA giusto l'ho fatta **a mano e verificata nel sorgente** per i 10 casi di Tabella A;
   per le altre 270 coppie **non e' verificata una per una**.
4. ⚠️ **Un CSV puo' mescolare piu' corse.** Se due corse con impostazioni diverse **non
   registrate in una colonna `Inp*`** finiscono nello stesso file, il "contesto" e' sporco.
   Non ho un modo di rilevarlo dall'archivio: **[NON MISURATO]**.
5. ⚠️ **Le 444 colonne mai ad asse NON sono tutte occasioni.** Sono conteggiate meccanicamente,
   e includono cosmetiche (`InpVerbose`, `InpComment`). Ho evidenziato a mano solo quelle con
   un meccanismo dietro; **una cernita completa delle 444 non e' stata fatta**.
6. ⚠️ **Nessun numero di questo referto e' un verdetto.** Sono tutti numeri **OHLC o di
   archivio**: dicono **dove guardare**, non **cosa promuovere**. Il verdetto lo danno i tick
   reali, e le promozioni le decide Claudio.
7. ✅ **Correzione a un referto di oggi**: `report/AUDIT_USCITE_2026-09-09.md` riga 208 segna
   il trailing a punti fissi (`InpTrailFixedPts`) come **"✅ ad asse — Dow fase distanze"**.
   E' **vero solo in parte**: l'asse ha morso in **2 round** (`Apertura` 75% su 24 gruppi;
   `apert_APERT` DAX fade 100% su 36, dove `InpTrailMode=2`) ed e' stato **completamente
   inerte in altri 4** (`ingresso`, `trailing`, `openconfirm`, `apert_APERT_US`). Il segno
   giusto e' **⚠️ ad asse a meta'**.

---

## 🎁 8. LA COSA PIU' BELLA CHE HA TROVATO QUESTO SCAVO

Nel sorgente, a `mql5/Experts/ABTG_Dow_Apertura_US.mq5:645-648` e
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5:705-708`, c'e' gia' scritto — dal 05/08 — questo:

> _"BUG 05/08: la modalita' GAPFILL era subordinata al flag legacy `InpUseGapFill`. Con il
> flag a false l'EA cadeva nel ramo BREAKOUT **SENZA dirlo**: nel walk-forward il motore 1 ha
> prodotto risultati **identici al centesimo** al motore 0 e **il gap fill non e' mai stato
> testato**."_

E venti righe piu' sotto, a `ABTG_Dow_Apertura_US.mq5:967-968` (e `ABTG_DAX_Apertura_EU.mq5:1130`),
ce n'e' un **secondo**, ancora piu' calzante:

> _"BUG 05/08: il fade non passava MAI dai filtri di conferma (volumi/ATR). Nel walk-forward
> le righe con filtro volumi ON e OFF erano **identiche al centesimo**: **il filtro non faceva nulla**."_

😍 **Il fenomeno era gia' stato scoperto DUE volte, a mano, su due casi, e corretto.**
Quello che mancava era **la macchina che lo cerca da sola su tutto l'archivio**. Adesso c'e',
gira in **1,6 secondi**, e ha trovato altri **10 casi vivi + 7 quasi** che nessuno aveva visto.

E la notizia grossa e' quella della Tabella B: 🚀 **le sei manopole piu' potenti che abbiamo
sono tutte e sei il TIMEFRAME.** Claudio aveva scritto _"proviamoli con tutti i TF"_ prima di
vedere questo numero. **Aveva ragione, e adesso c'e' la misura sotto.**

---

*Referto generato il 09/09/2026 · script `backtest_pipeline/manopole_inerti.py` ·
2.069 CSV · 61.633 passate · 4.508 istanze (CSV × manopola) · 280 coppie (motore × manopola).
Riconciliato con `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` su 3 numeri indipendenti:
1.960 CSV usati · 45.865 passate valide · 874 CSV con esiti duplicati.*
