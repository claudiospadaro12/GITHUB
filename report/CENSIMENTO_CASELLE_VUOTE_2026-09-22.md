# 🕳️ CENSIMENTO DELLE CASELLE VUOTE — i motori che non sono morti perché non sono mai nati

**22/09/2026** · repo `/home/user/GITHUB`, branch `lavoro` · 🛑 **SOLA LETTURA**: nessun
round lanciato, nessuna riga consegnata, niente sul VPS, niente sul forward, nessun preset
toccato, nessuna sedia promossa o spenta.

> **La differenza che tengo ferma:** gli altri agenti riesaminano i **MORTI** (chi ha un
> verdetto). Qui si censiscono le **CASELLE VUOTE**: codice e file prova che esistono in
> repo e **non hanno mai prodotto un numero**. 🔴 *Un motore mai misurato non è né vivo né
> morto: è un'occasione che nessuno ha ancora aperto.*

---

## 🥇 IL VERDETTO IN CINQUE RIGHE

1. 🔴 **58 `.mq5` su 115 non hanno nemmeno un CSV col proprio nome.** Tolti **11 strumenti**
   (Guardian, logger, sonde, misuratori) e **7 doppioni/ritirati** e **4 varianti
   `_Ottimizzato`**, restano **36 MOTORI VERI MAI MISURATI**. Il censimento di stasera ne
   stimava 33: erano 36, e i tre in più sono `ABTG_Relativo`, `ABTG_LondonFx`,
   `ABTG_DaxReEntry` — quest'ultimo **ha un referto del 31/08 ma nessun CSV in repo**.
2. 🔴 **115 file prova su 831 sono FERMI DURI**: nessun file di risultato con la loro
   etichetta **e** nessuna citazione in nessun documento. (Il numero 201 del brief usa un
   criterio più largo; §2 spiega la differenza e dà tutti e due.)
3. 🟠 **113 CSV hanno `Trades = 0` su TUTTE le passate.** Non sono verdetti: sono misure
   non avvenute. I gruppi che contano: **`PostNews` 4 su 4** (l'intero archivio del motore
   è vuoto), **`SupertrendInvert` 11 su 20**, **`Nightly` 11 su 22**, **`GapFill` regime
   R50/R59 16 su 16**, **`OpeningReversalB` 8 CSV**.
4. 🟢 **E una buona notizia che ribalta il quarto punto del brief:** il buco «girato e mai
   letto» **è chiuso**. `dal_vps` (98 CSV) è stato letto due volte — `LETTURA_BACKLOG_NOTTE_2026-09-13.md`
   (49 etichette) e `LETTURA_BACKLOG_COMPLETA_2026-09-21.md` (98 CSV, 18 motori, 390
   passate) — e `R138a` è stato letto oggi in `CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md`.
   **Cercando un secondo `R138a` con tre metodi indipendenti ne ho trovati ZERO.** §4.
5. 🎯 **La casella vuota più grossa non è un `.mq5`: è un TF.** Undici motori con numeri
   veri hanno girato **su un solo TF** perché `InpTF` era **pinnato**, mai messo ad asse.
   §5 è la mappa. 👉 **E sono le uniche caselle che possono ancora diventare una sedia
   entro il 1 ottobre**, perché il motore è già validato: si apre un TF, non un motore.

### 🛑 La riga scomoda, detta subito
**Nessuno dei 36 motori mai misurati diventa una sedia entro il 1 ottobre.** Nove giorni
non bastano a: misurare + validare a tick + far girare un forward che dica qualcosa. Chi
proponesse il contrario starebbe vendendo speranza. **Il valore di questo dossier è
altrove**: (a) le letture a **costo macchina ZERO**, (b) i **TF mai aperti su motori già
sani**, (c) impedire che 36 caselle vuote vengano archiviate come morti il giorno in cui
qualcuno farà pulizia.

---

## 📐 METODO — come ho deciso cosa è "vuoto" (e dove sbaglia)

| passo | che cosa ho fatto | dove può sbagliare |
|---|---|---|
| 1 | Elenco `.mq5` in `mql5/Experts/`, `/standalone/`, `/esterni/` → **115** | i `.ex5` senza sorgente non entrano (1 caso: `NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5`) |
| 2 | Indice di **2.409 CSV** sotto `risultati_prove/`, `risultati_archivio/`, `risultati_ottimizzazione/` | — |
| 3 | Un EA è **misurato** se esiste ≥1 CSV il cui **percorso contiene il suo nome**. Verificato che la convenzione regge: `walkforward_generico.ps1` r.2077 scrive `<Expert>_<Simbolo>_IS<Suffisso>.csv` e gli scan `scan_<EA>_<TF>_<SIM>.csv` | un CSV rinominato a mano sfugge. **Contro-esempio costruito**: ho cercato ogni EA anche col nome **senza prefisso `ABTG_`** e nei **contenuti** dei referti — 6 EA hanno referti `.md`/`.txt` ma **zero CSV** e li ho classificati a parte |
| 4 | Un file prova è **fermo** se la sua `-Etichetta` non compare in nessun nome di file risultato **e** il suo codice di round non è citato in nessuno dei **1.077 documenti** letti | vedi §2: due definizioni, tutte e due riportate |
| 5 | `Trades = 0`: letto **riga per riga** ogni CSV con colonna `Trades` | — |
| 6 | TF: incrociati **tre** fonti — la colonna `InpTF` **dentro** i CSV (tradotta dall'enum MT5), i nomi `scan_<EA>_<TF>_`, e gli `@PERIODO` dei file prova | §5 dichiara quale fonte dà quale riga |

🔴 **Il buco del metodo, dichiarato**: al passo 3 **"misurato" non vuol dire "misurato
bene"**. `ABTG_PostNews` ha 4 CSV e per questa regola risulta misurato — ma quei 4 CSV
sono **tutti a zero operazioni**. Per questo §3 esiste: senza di lui il censimento
mentirebbe su 113 file.

---

## 1️⃣ I `.mq5` SENZA NEMMENO UN CSV — 58 file, 36 motori veri

### 1.A 🔧 STRUMENTI, non sedie — 11 file, **fuori perimetro e va detto**
Non devono avere un PF: non aprono ordini per guadagnare.

`ABTG_Guardian` · `ABTG_SlippageLogger` · `ABTG_SpreadLogger` · `ABTG_TradeExporter` ·
`ABTG_SondaMargine` · `ABTG_SondaLondonFx` · `ABTG_SondaM0PB` · `ABTG_SondaRsiEmaV8` ·
`ABTG_MIS_SIZING_EMA200` · `ABTG_MIS_SIZING_SWDOW` · `ABTG_Apertura_Study_EA`

### 1.B ♻️ DOPPIONI E RITIRATI — 7 file
| file | di chi è la copia | stato |
|---|---|---|
| `ABTG_Apertura_Marco` | copia di `ABTG_DAX_Apertura_EU` | 🪦 **RITIRATO il 06/08**, scritto nel suo stesso header |
| `BULGE_MASTER` | originale di `ABTG_Bulge` | il motore lo conto una volta sola (in 1.C) |
| `DAX_M3_Supertrend` | riscrittura v2 di `ABTG_DAX_M3` | idem |
| `HARSI_Assistant` | assistente di `ABTG_HARSI` | idem |
| `ORB_GOLD_FIBONACCI_EA_v3.21` | versione di `ORB_GOLD_FIBONACCI_EA` | idem |
| `BREAKOUT_EA_JPY_Multi` | multi-simbolo di `BREAKOUT_EA_JPY` | idem |
| `ABTG_SuperWave_EA` | variante A di `ABTG_SuperWave` (**misurato**, 40 CSV) | non è una casella nuova |

### 1.C ⚙️ VARIANTI `_Ottimizzato` MAI GIRATE COL PROPRIO NOME — 4 file
`ABTG_DAX_Apertura_EU_Ottimizzato` · `ABTG_Nasdaq_Apertura_US_Ottimizzato` ·
`ABTG_Nightly_Ottimizzato` · `ABTG_MaxMinNotte_DAX_Short_Ottimizzato_MFE`

🔴 **Attenzione, è una trappola di lettura**: hanno **magic propri** e girano *in parallelo*
agli originali (regola di casa). Che non esista un CSV col loro nome **non dimostra** che
non siano mai stati misurati — può voler dire che il round girava sull'originale col
preset ottimizzato. **Verdetto onesto: `[NON VERIFICABILE DAI CSV]`.**

### 1.D 🎯 I 36 MOTORI VERI MAI MISURATI — uno per riga, col meccanismo

| # | motore | che inefficienza pretende di sfruttare | somiglia a qualcosa in casa? |
|---:|---|---|---|
| 1 | `ABTG_PointBreak` | mean-reversion sull'**estremo** dopo pattern di inversione (cuore meccanico di Point Break, D1 di default) | 🟢 **NO** — in casa non c'è nessun mean-reversion su estremo giornaliero |
| 2 | `ABTG_SuperFilter` | reversal su **iper-estensione** con confluenza (H1) | 🟡 vicino a `SupertrendReversal`, ma il trigger è l'estensione, non il flip |
| 3 | `ABTG_CRT_TurtleSoup` | **fade della falsa rottura** con wick di rifiuto ≥ K× il corpo (liquidity sweep strutturato) | 🟢 **NO** — la flotta è tutta trend + aperture |
| 4 | `ABTG_ChaosLyapunov` | EMA-cross **gated dall'esponente di Lyapunov** (filtro di regime costitutivo) | 🟢 **NO** — nessun filtro di regime di questo tipo in casa |
| 5 | `ABTG_Cycle` | indicatore «Ciclo» di Emiliano sulla price action DAX | 🔴 **doppione dichiarato nel suo header**: stessa formula di `prove/alta_velocita_ciclo.pine` (11/08) |
| 6 | `ABTG_DaxValueArea` | **Market Profile**: Value Area della seduta precedente governa l'apertura di oggi | 🟢 **NO** — nessun motore volumetrico in flotta |
| 7 | `ABTG_DaxReEntry` | **sweep + reclaim** del range mattutino DAX (08:35-11:05 server) | 🟢 **NO**. 🔴 **Ha un referto (31/08) e ZERO CSV in repo**: i numeri esistono in prosa, non in dati |
| 8 | `ABTG_FvgRetest` | ritorno nel **Fair Value Gap** con regime detection | 🟢 **NO** |
| 9 | `ABTG_HARSI` | Heikin-Ashi applicato all'RSI, **scalping contro-trend** M1-M5 | 🟢 **NO** (ma vedi §6: il TF lo uccide sugli indici) |
| 10 | `ABTG_ImpulsoApertura` | **impulso** della prima barra d'apertura (Market Open Impulse) | 🔴 famiglia aperture, già 3 sedie vive |
| 11 | `ABTG_InvEsaurimento` | inversione da **esaurimento**: giornata che ha speso ≥ 1,0× l'ADR(14) | 🟢 **NO** |
| 12 | `ABTG_NySessionRetest` | **continuazione** di trend su retest in seduta USA, concorde EMA200 H1 | 🟡 vicino a `EMA200` (sedia viva) |
| 13 | `ABTG_OutOfNoise` | intraday **con VWAP**, uscita dal rumore (MIT, Yuri Lopukhov) | 🟢 **NO** — nessun VWAP in flotta |
| 14 | `ABTG_VolExpBreak` | breakout su **espansione di volatilità** | 🟡 vicino a ORB/`BreakingBand` |
| 15 | `ABTG_VwapRevert` | **mean reversion sulla VWAP** | 🟢 **NO** |
| 16 | `ABTG_BreakinBox` | **falsa rottura del box notturno** → reversal verso il lato opposto | 🟡 inverso di `MaxMinNotte` (misurato) — ed è proprio per questo che è interessante |
| 17 | `ABTG_Londra_ORB` | ORB sull'ora **prima** di Londra, OCO, SL al centro del canale | 🟡 famiglia ORB |
| 18 | `ABTG_CrossEmaApertura` | l'apertura USA **costruisce** l'incrocio di medie, non lo filtra | 🟡 aperture + medie |
| 19 | `ABTG_AllineaLondra` | **allineamento di cinque medie** dentro la finestra di Londra | 🟢 **NO** |
| 20 | `ABTG_LondonFx` | contenitore R116: **tre motori a interruttore** (canale nudo / canale+RSI / cinque medie) | 🟢 contiene #19 |
| 21 | `ABTG_Relativo` | **forza relativa** fra due indici (l'EA operativo; la sonda `SondaRelativo` ha 2 CSV) | 🟢 **NO** — nessun motore relativo in flotta |
| 22 | `ABTG_FiboH4_Corso` | geometria Fibo H4 **fedele alle lezioni 18-20** | 🟡 `FiboH4_Multi` è misurato **e bocciato due volte** (PF < 1,00 su 6/6, DD 17-23%) |
| 23 | `ABTG_Bulge` | mean-reversion sul **Bollinger bulge**, basket forex H1 | 🟢 **NO**. Paternità: **è di Claudio** |
| 24 | `ABTG_DAX_M3` | bias Supertrend(3.5) H4 → esecuzione M3 | 🟡 famiglia Supertrend |
| 25 | `Nasdaq_PreOpen_Breakout_EA` | candela **15:25-15:30 Roma**, pendenti ±7 pt | 🔴 il meccanismo ha già un verdetto via `ABTG_Nasdaq_Live5m` (`PREOPEN_NASDAQ_IL_VERDETTO_2026-09-12.md`) |
| 26 | `ORB_DAX_BASE_EA` | ORB 09:00-09:30 CET + filtro EMA9/21 M5 (toolkit Monza) | 🟡 famiglia ORB |
| 27 | `ORB_DAX_PM_EA` | idem, finestra **15:30-16:00 CET** | 🟡 |
| 28 | `ORB_GOLD_FIBONACCI_EA` | ORB oro con estensioni Fibo + filtro D1 EMA200 | 🟡 |
| 29 | `ORB_OpeningRange` | ORB generico, congelamento del range a fine finestra | 🟡 |
| 30 | `GoldBreakout_Levels` | consolidamento vicino a **livello chiave** → breakout, XAUUSD H1 | 🟢 **NO** |
| 31 | `Gold_Ichimoku_TK_ATR_EA` | Ichimoku TK + uscite ATR, XAUUSD H1 | 🟡 famiglia oro |
| 32 | `Gold_Scalper_TK_BB_BE_EA` | scalping oro M5 «core trend» | 🔴 M5 sull'oro: vedi §6 |
| 33 | `IchiCross_Gold_722` | Ichimoku 7/22/44 + BB in espansione + ADX≥30, oro M5 | 🟡 |
| 34 | `IchiTrend_Gold_Base` | Ichimoku base oro M5 (fondamenta di #33) | 🔴 sottoinsieme di #33 |
| 35 | `BREAKOUT_EA_JPY` | Williams %R(140) + Supertrend, **cross JPY M15** | 🟡 `BreakoutCorso` è misurato (14 CSV, M15) |
| 36 | `DAX_MASTER_PROP` | consolidato prop-firm DAX con 5 protezioni low-DD | 🟡 è un **contenitore di protezioni**, non un'inefficienza nuova |

🟢 **I sei che diversificano davvero** (meccanismo che in casa NON esiste, e la flotta è
tutta trend-following + aperture): **#3 CRT TurtleSoup**, **#6 DaxValueArea**,
**#13 OutOfNoise**, **#15 VwapRevert**, **#21 Relativo**, **#23 Bulge**.

---

## 2️⃣ I FILE PROVA FERMI — 115 duri su 831

**Due definizioni, e do tutte e due perché danno numeri diversi:**
- **FERMO DURO (115)**: nessun file risultato con la sua etichetta **E** mai citato in
  nessuno dei 1.077 documenti. È il numero su cui metto la firma.
- **SENZA RISULTATO IDENTIFICABILE (589)**: nessun file risultato con la sua etichetta,
  ma **citato** da qualche parte. 🔴 Qui dentro ci sono moltissimi falsi positivi: i file
  prova **vecchi** (nome `ABTG_<EA>.txt`) non portano `-Etichetta` e i loro CSV si chiamano
  `_IS_ohlc.csv`. **Il 201 del brief sta in mezzo ai due, e non l'ho potuto riprodurre**:
  lo dichiaro in §7.

### 🗂️ I 115 fermi duri, raggruppati per EA (data = ultimo commit del file)

| EA | file prova fermi | quando | motivo probabile |
|---|---|---|---|
| `ABTG_Nasdaq_Apertura_US` | `FASE2_CASSA_00_simm`, `FASE2_CASSA_01_long`, `FASE2_NAS_00_baseline`, `FASE2_NAS_01_F1_k10`, `FASE2_NAS_02_F1_k15`, `FASE2_NAS_03_F3_ema`, `PREOPEN_COSTO_NAS_M15`, `PREOPEN_RETEST_NAS_M15(+_SHORT)`, `PREOPEN_RIF_NAS_M15(+_SHORT)`, `SHORTGATE_CASSA_00` — **12** | 28-30/08 | il filone «PreOpen M15» è stato **superato** dal verdetto del 12/09 su `Nasdaq_Live5m`; FASE2/SHORTGATE sono rimasti indietro |
| `ABTG_PostNews` | `POSTNEWS_1330_00_conta`, `POSTNEWS_ISM_00_conta`, `POSTNEWS_ORO_00_conta`, `_01_SL`, `_02_attesa`, `_03_offset`, `_04_uscita` — **7** | 04-11/09 | 🔴 **il filone ORO è di 11 giorni fa e non è mai partito**. Vedi §3 |
| `ABTG_PTE` | `LATI_B0/B1/B2_PTE_GBPUSD_{METRO,ORSO,TORO}_{long,short}` — **6** | 09/09 | prova di **regime × due lati** scritta il giorno del censimento, mai lanciata |
| `ABTG_BreakoutCorso` | `R82i/l/m/n/o/p_tick_{EURJPY,GBPJPY,AUDJPY,CHFJPY,CADJPY,NZDJPY}` — **6** | 18/08 | **la validazione a tick reali del torneo JPY**: la griglia OHLC è girata, i tick no |
| `ABTG_SondaOrologio` | `02_EURUSD_SHORT`, `04_GBPUSD_SHORT`, `05/06_XAUUSD_{LONG,SHORT}`, `12_D30EUR_SHORT`, `14_U30USD_SHORT` — **6** | 31/08-06/09 | 🔴 **i lati SHORT della sonda d'orologio**: girati i long, non gli short (regola dei due lati, 25/08) |
| `ABTG_LiquiditySweep` | `JPY_LIQSWEEP_BOZZA`, `R95b/c/d/e_liqsweep_h{1,2,3,4}_EURJPY` — **5** | 21/08 | asse **TF della struttura** H1→H4, mai lanciato |
| `ABTG_Dow_Apertura_US` | `PREOPEN_{COSTO,METRO,METRO_SHORT,RETEST,RETEST_SHORT}_DOW_M15` — **5** | 28/08 | stesso filone PreOpen M15 |
| `ABTG_Relativo` | `RELATIVO_R117BIS_NAS(+_GEMELLO)`, `RELATIVO_R117_{D30,NAS}_GEMELLO`, `RELATIVO_R117_NAS_PORTO` — **5** | 05/09 | R117 preparato e mai corso |
| `ABTG_EMA200` | `LATI_A1_EMA200_U30USD_DISCESA_{long,short}`, `LATI_A2_..._TORO_{long,short}` — **4** | 09/09 | 🔴 **prova di REGIME sulla sedia migliore della flotta** (`771531`), scritta e mai girata |
| `ABTG_DAX_Apertura_EU` | `PREOPEN_{COSTO,METRO,METRO_SHORT,RETEST_SHORT}_DAX_M15` — **4** | 28/08 | filone PreOpen M15 |
| `ABTG_FiboH4_Corso` | `R93g/R93i_{stop,ancoraggio}_{GBPUSD,USDJPY}` — **4** | 21/08 | coda di R93 troncata |
| `ABTG_CrossEmaApertura` | `R96a_ancora_{NASUSD,U30USD}`, `R96b_controllo_{NASUSD,U30USD}` — **4** | 21/08 | 🔴 **R96 è il round di nascita del motore: non è mai partito** |
| `ABTG_SupertrendInvert` | `G1PAOLO_10_invert_base`, `_11_invert_adx25`, `_12_invert_stochoff` — **3** | 28/08 | ablazione mai corsa (e l'EA ha 11 CSV a `Trades=0`, §3) |
| `ABTG_InvEsaurimento` | `INVES_NAS_00_baseline`, `_01_E1`, `_02_E3` — **3** | 30/08 | motore nato con contratto firmato il 30/08, mai misurato |
| `ABTG_AllineaLondra` | `PASSO0_ALLINEALONDRA_01_nofinestra`, `_02_long`, `_03_short` — **3** | 28/08 | passo 0 preparato, mai corso |
| `ABTG_PunteLarry` | `R160c/d_maxdayshold_{GBPJPY,GBPUSD}`, `R169c_slbufferatr_XAUUSD` — **3** | 15-17/09 | 🔴 **i più recenti del mucchio**: 5-7 giorni |
| `ABTG_BreakingBand` | `R94a/b/c_bb_{GBPUSD,EURUSD,AUDUSD}_p37` — **3** | 21/08 | — |
| `ABTG_CRT_TurtleSoup` (6 varianti) | `_EXT`, `_EXT_S2`, `_EXT_S2G`, `_GATE`, `_TICK_DIAG`, `_TICK_G` — **6** | 30/08 | 🔴 **2 di questi NON passano il cancello** (2 e 3 assi Y): §8 |
| `ABTG_SupertrendReversal` | `G1PAOLO_00_suprev_base`, `_01_suprev_ema50` — **2** | 28/08 | — |
| `ABTG_OutOfNoise` | `PASSO0_OUTOFNOISE_01_long`, `_02_short` — **2** | 29/08 | passo 0 mai corso |
| `ABTG_VwapRevert` | `PASSO0_VWAPREV_01_long`, `_02_short` — **2** | 03/09 | passo 0 mai corso |
| `ABTG_SondaRsiEmaV8` | `RSIEMAV8_FREQUENZA_{M5,M15}` — **2** | 02/09 | conteggio di frequenza mai fatto |
| *uno ciascuno* | `ABTG_BreakinBox_RRFISSO` (31/08) · `PASSO0_FVGRET_02_short` (28/08) · `ABTG_GapContinuation_R66` (16/08) · `R98rif_nuda_NASUSD` (22/08, IntradayMomentum) · `MIS_SIZING_SWDOW_U30USD` (19/09) · `DAYFLOW_FREQUENZA_BOZZA` (01/09) · `LONDONFX_FREQUENZA_M5` (31/08) · `M0PB_FREQUENZA_M15` (31/08) · `VGRSI_SONDA_CONTEGGIO_M5` (02/09) · `ABTG_Nasdaq_Apertura_US_GAP2` (16/08) | | |
| *senza EA deducibile* | `ABTEST_CONTENTRY_ABTG_BreakingBand_{AUDUSD,EURUSD,GBPUSD}_765xxx` (29/08) · `POSTNEWS_ECB_1009_COLLAUDO` (07/09) · `PTE_BUFFER_TICK_REALI`, `PTE_OTT_BUFFER_ATR`, `PTE_OTT_IGIENE_MODE0` (17/08) · `SONDA_OROLOGIO_FX` (31/08) — **8** | | il file non porta l'intestazione `# EA:` |

🔴 **I due che fanno più male, e sono di questo mese:**
`LATI_A1/A2_EMA200_U30USD` (09/09) — **la prova di regime sulla sedia `771531`, quella che
ha portato la flotta in challenge** — e i tre `POSTNEWS_ORO_*` (11/09).

---

## 3️⃣ I `Trades = 0` — 113 CSV, e **costano ZERO tempo macchina**

Un CSV a zero operazioni su tutte le passate **non è un verdetto**: è una misura che non è
avvenuta (feed mancante, orologio sbagliato, filtro che chiude tutto, simbolo senza storico).

| gruppo | CSV a zero | che cosa significa davvero |
|---|---:|---|
| 🔴 **`ABTG_PostNews`** | **4 su 4** | **L'INTERO ARCHIVIO DEL MOTORE È VUOTO.** `REGISTRO_TEST.md` r.77-81 lo dice già («letto come *nessun edge* il 07/08 — ⚠️ **RITIRATO**») e r.94-97 mostra la causa vera: la v1.10 ha aggiunto `InpNewsCommon` e il log `[PostNews][NEWS] letto da … UTILI per questo preset N`. 👉 Il motore **non ha mai avuto un PF**: è `NON ANCORA MISURATO`, non morto. E i **7 file prova del 04-11/09 sono fermi** (§2) |
| 🟠 `ABTG_SupertrendInvert` | **11 su 20** (225JPY, D30EUR ×2, EURUSD ×2, GBPJPY ×2, NASUSD, U30USD, XAGUSD, XAUUSD) | metà del campione del motore **non esiste**. Le 3 ablazioni `G1PAOLO_1x` sono ferme (§2) |
| 🟠 `ABTG_Nightly` | **11 su 22** (AUDUSD ×2, D30EUR ×2, U30USD ×2, USDJPY ×2, XAGUSD, XAUUSD ×2) | 🔴 **`LETTURA_BACKLOG_COMPLETA_2026-09-21.md` riga 12 lo boccia per rischio (DD 11,10% IS / 15,39% OOS) su `P0_EURCHF`** — cioè su **l'unico simbolo con operazioni**. Gli altri 5 simboli sono **campione vuoto**, non campione brutto |
| 🟠 `GapFill` regime R50/R59 | **16 su 16** (`GAP_{EURUSD,GBPUSD}_{TORO,ORSO,LATERALE,CROLLO,CROLLO_ANNO}_r50/r59`) | 🔴 **la PROVA DI REGIME (regola C del 16/08) su `GapFill` non è mai avvenuta.** Sedici finestre, zero operazioni |
| 🟠 `ABTG_OpeningReversalB` | **8** (`P0A_FAIL`, `P0B_SIGNAL`, `P0CONTA`, `P0C_FT`, ×2 copie) | già letto correttamente il 21/09: *«zero operazioni fuori campione su 11 passate OOS su 11»* → **NON MISURABILE** |
| 🟡 `BreakingBand` scan H1/H4 | **~50 file** da 3 passate (200AUD, D30EUR, E35EUR, E50EUR, EURCHF, EURNZD, NZDJPY, U30USD, USOIL, UKOIL, XAGUSD, XNGUSD, XPTUSD, F40EUR, …) | screening su simboli **dove il motore non arma**: è informazione (il motore non gira su quei simboli), non un vuoto da riempire |
| 🟡 `GoldenCross` XPD/XPT H1 | 2 file da 123 e 127 passate | **250 passate a zero**: palladio e platino non hanno storico utile. Casella da chiudere «per dato mancante», non da riprovare |
| 🟡 vari | `GapFill/tick/valid_..._H1_realtick_E35EUR`, `MaxMinNotte_EURUSD_OOS_ohlc`, `R113_F1_02_short` | singoli |

### 🟠 E i quasi-vuoti, che sono peggio perché **sembrano** misure
| CSV | passate a zero |
|---|---|
| `risultati_archivio/EMA200/H1_OHLC/scan_ABTG_EMA200_H1_XPDUSD.csv` | **116 su 145** |
| `risultati_archivio/EMA200/H1_OHLC/scan_ABTG_EMA200_H1_XPTUSD.csv` | **88 su 135** |
| `risultati_archivio/GoldenCross/H4_OHLC/scan_ABTG_GoldenCross_H4_XPDUSD.csv` | **58 su 111** |
| `risultati_archivio/r91_csv/ABTG_BreakingBand_AUDUSD_OOS_r91c.csv` | 2 su 4 |

---

## 4️⃣ I ROUND GIRATI E MAI LETTI — 🟢 **il buco è chiuso**, e l'ho verificato in tre modi

Il brief chiede: *«`R138a` era elencato fra i round da lanciare ed era già girato. Quanti
altri ce ne sono?»* **Risposta misurata: nessun altro che io sia riuscito a trovare.**

**Perché `R138a` non è più un buco:** è letto oggi in
`report/CHI_ALTRO_PUO_SCHIERARSI_2026-09-22.md` (§4.1, riga 79: PF OOS **0,76965**, n 195,
DD **11,8210%**, profitto **−7.266,30**).

**I tre modi con cui ho cercato il secondo `R138a`:**

1. **La cartella del runner notturno.** `risultati_prove/dal_vps/` contiene **102 file**.
   Sono stati letti **due volte**: `LETTURA_BACKLOG_NOTTE_2026-09-13.md` (49 etichette) e
   `LETTURA_BACKLOG_COMPLETA_2026-09-21.md` (**98 CSV, 18 motori, 390 passate, tabella
   riga per riga, nessuno manca**). Ho verificato **una per una tutte e 48 le etichette**
   di `dal_vps` (`r120b00…r142c`, `P0*`, `R123*`, `cemad02/05`, `q770be`): **ognuna è
   citata in almeno 4 documenti**. Zero orfani.
2. **Il censimento come indice.** `CENSIMENTO_PF_TUTTI_2026-09-09.csv` copre **1.728
   basename** (la colonna `file` contiene coppie `IS;OOS`). Fuori dal censimento e fuori
   da `dal_vps` restano **105 CSV di griglia**: **46 sono i `Trades=0` di §3** (niente da
   leggere: non c'è un numero) e **59 sono round post-09/09** (`r123`, `r127a`, `R172D`,
   `R196A`, `R197A/B`, `R198`, `R199A/B`, `R200A/C/E`, `R201A`, `R202A/B`,
   `gestione_20260909`). Li ho controllati uno per uno: **tutti citati**, il più magro è
   `R197B` con 1 sola citazione — ed è **letto sul serio**
   (`PROFONDITA_RETEST_2026-09-21.md` r.59 e r.71: *«InpRetestOffsetPts = 400 sul Dow
   `770202`: CONFERMATO da R197B»*).
3. **Ricerca per nome file.** Ogni basename CSV cercato dentro **1.077 documenti**. I
   residui sono tutti gruppi di scan già coperti *in blocco* dal censimento.

🔴 **Il contro-esempio che mi sono costruito contro**: *«forse il censimento del 09/09 li
conta come letti senza averli letti davvero»*. **Regge in parte, e va detto**: il
censimento è un **indice automatico**, non una lettura. Ma per i 105 fuori indice ho fatto
la verifica **documento per documento**, e lì la lettura c'è. 👉 **Dove la mia risposta è
debole è sui grandi scan dentro il censimento** (`GoldenCross/H1_OHLC`,
`SupertrendReversal/H4_OHLC`, …): **indicizzati sì, letti cella per cella `[NON
VERIFICATO]`**. È il buco #2 di §7.

---

## 5️⃣ 🆕 I TF MAI PROVATI SUI MOTORI CHE GIRANO GIÀ — **la mappa, non un verdetto**

> Direttiva di Claudio, 22/09: *«DA PROVARE IN + TF MI RACCOMANDO, OGNI STRATEGIA».*
> Un motore con numeri su **un solo TF** è, sugli altri TF, una casella vuota a tutti gli
> effetti.

### 5.A 🧭 Prima una distinzione che cambia il costo
| tipo | come si cambia TF | costo |
|---|---|---|
| **A · EA con `input ENUM_TIMEFRAMES InpTF`** | **una riga nel file prova**, asse sull'enum. `controlla_prova.py` conta i **membri** dell'enum, non fa `(stop−start)/passo` (classe 287) | 🟢 minimo |
| **B · EA senza `InpTF`** | si cambia `@PERIODO` → **un file prova nuovo per TF** | 🟡 basso |
| **C · EA con l'orologio nel motore** (aperture, ORB, notturni) | il TF **è** il meccanismo: cambiarlo cambia la strategia | 🔴 non è una casella vuota, è un altro motore |

### 5.B 📊 LA MAPPA — motori di tipo A (`InpTF` esiste), TF **letti dentro i CSV**

| motore | CSV | TF **girati** (dalla colonna `InpTF`) | TF **MAI girati** | tipo |
|---|---:|---|---|---|
| `ABTG_GapFill` | 28 | **H1** e basta | 🔴 M15 M20 M30 **H2 H3 H4 H6 H8 H12 D1** | A |
| `ABTG_EasyTrend` | 28 | **H1** | 🔴 tutto il resto | A |
| `ABTG_PunteLarry` | 12 | **H1** | 🔴 tutto il resto (*i pattern restano su D1*, dice il codice) | A |
| `ABTG_CostToCost` | 16 | **H4** (censimento: H1+H4) | 🔴 **M30** — e il sorgente dice *«da spazzolare H4/D1»* | A |
| `ABTG_MeanRevert` | 2 | **H1** | 🔴 tutto il resto | A |
| `ABTG_CanaleLento` | 2 | **D1** | 🔴 tutto il resto | A |
| `ABTG_TurnaroundTuesday` | 2 | **H1** | 🔴 tutto il resto | A |
| `ABTG_BreakingBand` | 26 | **H1 · H4** | 🔴 **M30** — e il sorgente dice *«guida: D1/H4/H1/M30»* | A |
| `ABTG_BreakoutCorso` | 14 | **M15** | 🔴 M30 H1 H4 (il corso dice M15) | A |
| `ABTG_FiboH4_Multi` | 18 | **H4** | 🔴 tutto il resto — ma è **bocciato due volte** (21/09) | A |
| `ABTG_LiquiditySweep` | 4 | struttura **H4** | 🔴 H1 H2 H3 — **e i 4 file prova R95b-e esistono già e sono VERDI** | A |

### 5.C ✅ I motori che il TF **l'hanno già spazzolato** (nessuna casella qui)
`ABTG_EMA200`, `ABTG_EMA200_Ottimizzato`, `ABTG_SuperWave`, `ABTG_SuperWave_DAX/DOW_*_Ott`,
`ABTG_SupertrendReversal` (+`_Multi`, `_Ottimizzato`, `_Multi_Ottimizzato`),
`ABTG_SupertrendInvert`, `ABTG_WOL`, `ABTG_SupRev_{CAC,DAX,DOW,NAS}_*_Ottimizzato`:
**M15 M20 M30 H1 H2 H3 H4 H6 H8 H12 D1 — undici TF, letti dentro i CSV.**
🔴 **Il TF che manca a TUTTI e undici è lo stesso: M1 e M5.** §6 spiega perché su indici e
oro è giusto così, e perché **su forex la domanda resta aperta**.

### 5.D 🪑 E le sedie vive — mappa, non proposta
| sedia | motore | TF girati | TF mai girati | si può? |
|---|---|---|---|---|
| `771531` | `ABTG_EMA200` U30USD | **11 TF** M15→D1 | M1, M5 | 🔴 **no**: §6, M5 sul Dow sfonda il costo |
| `770101` | `ABTG_DAX_Apertura_EU` D30EUR | M5 (+M15 nel filone PreOpen, fermo) | — | 🔴 **tipo C**: il TF è l'apertura |
| `770202` / `770260` | `Dow`/`Nasdaq_Apertura_US` | M5 (+M15 fermo) | — | 🔴 tipo C |
| `770511` | `ABTG_SuperWave_DOW_H1_Ott` | 11 TF | M1, M5 | 🔴 §6 |
| `770611` | `ABTG_ORB_Ottimizzato` | M5 | — | 🔴 tipo C |

---

## 6️⃣ 💰 IL COSTO, e la frontiera — **coi numeri, non con le impressioni**

### 6.A Il metro di casa
**Misura del 21/09 sul PC di backtest**, modello 4 (tick reali), finestra
`2024.09.26 → 2026.06.30`, **M5 su indici**: **8 passate fra 2 min 41 s e 11 min 57 s**
→ **20 s ÷ 90 s a passata**.

🔴 **E qui il contro-esempio me lo costruisco contro da solo, perché è importante:**
la direttiva dice *«salendo di TF il costo scende»*. **È vero, ma NON in proporzione al
TF.** A **modello 4** il tester rigioca **lo stesso identico flusso di tick** qualunque sia
il TF del grafico: quello che cala è il lavoro **per barra** (indicatori, `OnTick` a barra
chiusa), non il numero di tick. Quindi *M30 costa 1/6 di M5* è **falso**.
👉 **Nel dossier uso il costo M5 come TETTO SUPERIORE anche per i TF alti**, e segno
**`[NON MISURATO]` il fattore di sconto**. Chiuderlo costa una corsa sola di taratura.

### 6.B La frontiera `stop ≥ 40 × spread`, coi numeri veri
Spread **misurati** (`report/STOP_VS_SPREAD_FTMO_2026-09-20.md` §8, finestra
2024.09.26→2026.06.30):

| simbolo | ora | mediana | p95 | **pavimento 40×** (mediana → p95) | pavimento **duro** 13,3× |
|---|---|---:|---:|---:|---:|
| `D30EUR` | 8 (cash EU) | **1,70** | 2,70 | **68,0 → 108,0** punti indice | 22,6 |
| `U30USD` | 14 (cash USA) | **2,00** | 3,00 | **80,0 → 120,0** | 26,6 |
| `NASUSD` | 14 (cash USA) | **1,80** | 2,70 | **72,0 → 108,0** | 23,9 |
| `U30USD` | 17 (ora modale `771531`) | 1,90 | 2,00 | 76,0 → 80,0 | 25,3 |

🔴 **`U30USD` ora 14 ha un massimo misurato di 47,00 punti indice di spread**: all'apertura
cash la frontiera **non è una media, è una coda**.

👉 **Conseguenza operativa, col numero accanto:** uno scalper su indice a M5 con stop di
15-25 punti indice sta a **7-12×**, cioè **sotto anche il pavimento duro 13,3×**.
Per questo `ABTG_HARSI` (M5), `Gold_Scalper_TK_BB_BE_EA` (M5), `IchiCross_Gold_722` (M5),
`IchiTrend_Gold_Base` (M5) vanno dichiarati **ESCLUSI PER COSTO sugli indici**, non
«scartati perché bassi». Sull'**oro** il numero è `[NON MISURATO]` in questo dossier
(esiste `report/RICERCA_SPREAD_PROP_XAUUSD_2026-09-17.md`, non l'ho aperto: §7).

### 6.C Il tetto delle barre
Regola 25/08: **~100.000 barre per corsa** → M15 ≈ 4 anni, M5 ≈ 1,3 anni.
Sulla finestra standard (21 mesi) **M5 morde già** e va controllato che la prima
operazione stia a ridosso del `2024.09.26`. **Da M30 in su il tetto sparisce.**

### 6.D La frequenza
Pavimento **1,00 op/giorno per FAMIGLIA** (firma 07/09). Salendo di TF le operazioni
calano: un motore che su H1 fa 0,3 op/giorno, su H4 ne farà ~0,1.
🔴 **Con 9 giorni al 1 ottobre, un TF più ALTO allontana il campione, non lo avvicina.**
Un round su TF alto si giustifica **solo** se il TF basso è escluso per costo.

---

## 7️⃣ 🏆 I PRIMI DIECI DA APRIRE — e il contro-esempio che gli ho costruito contro

Ordine = **quello che potrebbero dare ÷ quanto costano**.
`P` = passate (celle × 2 finestre) · costo col tetto superiore M5 (90 s/passata).

---

### 🥇 1 — `ABTG_PostNews`: **leggere 4 CSV e 7 file prova.** Costo: **0 minuti**
| | |
|---|---|
| **casella** | l'intero archivio del motore è `Trades = 0` su 4 CSV su 4 |
| **file prova** | esistono già e sono **fermi**: `POSTNEWS_ORO_00_conta`, `_01_SL`, `_02_attesa`, `_03_offset`, `_04_uscita` (11/09), `POSTNEWS_1330_00_conta`, `POSTNEWS_ISM_00_conta` (04/09) |
| **passate / minuti** | **0 / 0** per la lettura. Il primo conteggio (`_00_conta`) è **2 celle = 4 passate ≈ 6 min** |
| **attesa dichiarata PRIMA** | il conteggio dà **> 0 eventi news utili**. Se desse **0**, la causa è il file news (`InpNewsCommon`/`abtg_news.csv`) e il motore resta `NON MISURATO` — **non diventa morto** |
| **schierabile l'1/10?** | 🔴 **NO** |
| **contro-esempio** | *«è già in `REGISTRO_TEST` come RITIRATO, lascialo stare»* → **non regge**: r.77 dice testualmente *«letto come "nessun edge" il 07/08»*, e un PF di **0,00000 su 0 operazioni non è "nessun edge": è nessuna misura**. Il certificato di morte (09/09) chiede **un PF misurato**: qui manca. Costo del riesame: **zero** |

### 🥈 2 — `ABTG_Nightly`: **rileggere 11 CSV a zero.** Costo: **0 minuti**
| | |
|---|---|
| **casella** | bocciato per rischio il 21/09 su `P0_EURCHF` — **l'unico dei 6 simboli con operazioni**. AUDUSD, D30EUR, U30USD, USDJPY, XAGUSD, XAUUSD: **campione vuoto** |
| **passate / minuti** | **0 / 0** |
| **attesa** | la bocciatura per **RISCHIO** resta valida (il DD è un fatto accaduto, Emendamento B). Ma **la copertura per simbolo scende da 6 a 1**, e il certificato va riscritto |
| **schierabile l'1/10?** | 🔴 NO |
| **contro-esempio** | *«DD 15,39%: è morto e basta»* → **regge sul rischio, non sulla copertura**. La riga di `REGISTRO_TEST` dirà *«bocciato per rischio su EURCHF; sugli altri 5 simboli NON MISURATO»*, che è una frase diversa da *«bocciato»* |

### 🥉 3 — `GapFill`, prova di REGIME: **16 CSV a zero.** Costo: **0 minuti per capirlo**
| | |
|---|---|
| **casella** | `regime_r50/` + `regime_r59/`: **16 CSV su 16 a `Trades = 0`** su TORO/ORSO/LATERALE/CROLLO di EURUSD e GBPUSD |
| **attesa** | la **prova di regime (regola C, 16/08)** su questo motore **non è mai avvenuta**. O le finestre non hanno cambio-settimana utili, o il simbolo non arma |
| **schierabile l'1/10?** | 🔴 NO |
| **contro-esempio** | *«se 16 finestre su 16 danno zero, il motore semplicemente non opera lì»* → **è esattamente il punto**: allora **la prova di regime va rifatta su un simbolo dove opera**, non contata come fatta. Capirlo costa zero |

### 4 — `ABTG_GapFill` · **asse `InpTF` H1 → H4** · **~10 passate, ≈ 15 min**
| | |
|---|---|
| **casella** | **28 CSV, tutti con `InpTF = PERIOD_H1`.** Il TF non è mai stato messo ad asse |
| **file prova** | **da scrivere** (1 file, 1 variabile: `InpTF=16385\|\|16385\|\|1\|\|16388\|\|Y` → 5 membri H1,H2,H3,H4 + M30 se si parte da 30) |
| **passate / minuti** | 4-5 celle × 2 finestre = **8-10 P** → **≤ 15 min** col tetto M5 (meno, in realtà: §6.A) |
| **attesa dichiarata PRIMA** | salendo di TF le operazioni **calano** e il PF **non migliora**: mi aspetto **n in calo del 40-70%** e **PF nella stessa banda ±0,15**. 🔴 **Un PF che sale di oltre 0,30 con n dimezzato sarebbe SOSPETTO**, non bello |
| **soglia congelata** | se nessuna cella batte H1 di **≥ 0,10 di PF** con **n ≥ 150**, la risposta è **«il default va bene»** — ed è un risultato |
| **schierabile l'1/10?** | 🟡 solo se H1 resta il migliore (cioè: nessun cambio) |
| **contro-esempio** | *«è griglia larga su un motore già giudicato: vietato dalla regola del 19/08»* → **non regge, ed è la distinzione centrale di questo dossier**: la regola vieta di infittire i **parametri d'ingresso** di un motore a PF < 1,10. Qui **non si infittisce niente**: si apre **una manopola mai girata**, che la regola mette esplicitamente fra ciò su cui **si allarga** (*«si allarga su MOTORI, MECCANISMI, SIMBOLI, TF, GESTIONE DELL'USCITA»*) |

### 5 — `ABTG_BreakingBand` · **il TF M30 che il suo stesso codice dichiara** · **~6 P, ≈ 9 min**
| | |
|---|---|
| **casella** | girato H1 e H4. Il sorgente r. `input ENUM_TIMEFRAMES InpTF = PERIOD_H1; // TF operativo (guida: D1/H4/H1/M30)` — **M30 è scritto nella guida e non è mai stato provato** |
| **passate / minuti** | 3 celle (M30, H1, H4) × 2 = **6 P** → **≤ 9 min** |
| **attesa** | **più operazioni** a M30 (+50÷150%) e **PF in calo**. Serve a chiudere il requisito «TF cambiato» del certificato di morte |
| **schierabile l'1/10?** | 🔴 NO (250 CSV già in censimento, nessuna cella sopra i cancelli) |
| **contro-esempio** | *«BreakingBand ha 250 righe di censimento: è spremuto»* → **regge sui parametri, non sul TF**: 250 righe su **due** TF. E il costo è 9 minuti |

### 6 — `ABTG_LiquiditySweep` · **i 4 file prova R95b-e esistono già e sono VERDI** · **24 P, ≈ 36 min**
| | |
|---|---|
| **casella** | asse **TF della struttura** (`InpTF_Struttura` H1→H4) su EURJPY, scritto il **21/08**, mai lanciato. Il motore ha **2 CSV in tutto** |
| **file prova** | `R95b_liqsweep_h1_EURJPY.txt`, `R95c_..._h2_`, `R95d_..._h3_`, `R95e_..._h4_` — **`controlla_prova.py` → OK, 3 celle ciascuno, 12 celle, 24 passate, 0 problemi** *(eseguito oggi)* |
| **attesa** | liquidity sweep = **fade**, e in casa non c'è niente di simile: **diversifica**. Mi aspetto **n basso** (< 150) → **merito sospeso, rischio leggibile** |
| **schierabile l'1/10?** | 🔴 NO |
| **contro-esempio** | *«R89 l'aveva chiuso»* → `REGISTRO_TEST` dice che R89 lo chiuse **e che è stato riaperto** su una tesi nuova (reversal, pag. 26/28). E il TF della struttura **non è mai stato girato**: il certificato di morte è **incompleto sulla casella 5** |

### 7 — `ABTG_OutOfNoise` + `ABTG_VwapRevert` · **il PASSO 0 già scritto e verde** · **16 P, ≈ 24 min**
| | |
|---|---|
| **casella** | due motori **VWAP** — meccanismo che **in casa non esiste** — con il passo 0 pronto dal 29/08 e 03/09 e mai corso |
| **file prova** | `PASSO0_OUTOFNOISE_01_long` / `_02_short` (NASUSD M15) e `PASSO0_VWAPREV_01_long` / `_02_short` (D30EUR M15) — **`controlla_prova.py` → OK, 2 celle ciascuno, 8+8 passate, 0 problemi** *(eseguito oggi)* |
| **attesa** | è un **passo 0**: la domanda è *quante operazioni fa*, non *quanto guadagna*. Attesa: **> 0,20 op/giorno** per lato. Sotto, il motore è troppo lento e si dichiara |
| **schierabile l'1/10?** | 🔴 NO — ma **M15 su indici va dichiarato**: lo stop di un VWAP-revert è tipicamente 1-1,5× ATR(M15), cioè **20-40 punti indice** su NASUSD → **11÷22×** contro un pavimento di lavoro di **72,0**. 🔴 **Sotto anche il duro 23,9× nella metà bassa della forbice.** Il passo 0 conta le operazioni, **il verdetto no** |
| **contro-esempio** | *«se è fuori costo, non lanciarlo»* → **il passo 0 non è un verdetto: è un conteggio**, e serve per sapere se vale la pena portarlo su M30/H1 dove il costo passa. Ma **va scritto nel file prova**, e oggi non c'è: è un difetto dei due file, non del candidato |

### 8 — `ABTG_InvEsaurimento` · **contratto firmato il 30/08, mai misurato** · **12 P, ≈ 18 min**
| | |
|---|---|
| **casella** | motore d'**inversione da esaurimento** (giornata che ha speso ≥ 1,0× ADR(14)), con criteri **firmati** (`STUDIO_INVERSIONE_ESAURIMENTO_CRITERI_BOZZA.md`) e **zero CSV** |
| **file prova** | `INVES_NAS_00_baseline`, `_01_E1`, `_02_E3` — **`controlla_prova.py` → OK, 2 celle ciascuno, 12 passate, 0 problemi** *(eseguito oggi)*. `@SIMBOLO NASUSD_EXT @PERIODO M15 @DAQUANDO 2017.01.01 @FINOA 2020.07.01` |
| **attesa** | ADR(14) speso è un evento raro: **n atteso 60-150** su 3,5 anni → **merito probabilmente sospeso**, rischio leggibile |
| **schierabile l'1/10?** | 🔴 NO |
| **contro-esempio** | *«la finestra 2017-2020 non è il mercato di oggi»* → **è il punto, non il difetto**: l'Emendamento A dice di **dichiarare il regime**, e questa finestra è un **regime dichiarato**. 🔴 **Ma il simbolo `NASUSD_EXT` è storico importato**: se non è montato sul banco, il round muore in partenza. **Da verificare PRIMA, costa zero** |

### 9 — `ABTG_CRT_TurtleSoup` · **il fade che manca alla flotta** · **⚠️ 2 file su 8 NON passano il cancello**
| | |
|---|---|
| **casella** | **8 file prova, zero CSV.** Meccanismo: **fade della falsa rottura** con wick ≥ K× il corpo — la flotta è **tutta trend + aperture** |
| **cancello** | 🔴 **`ABTG_CRT_TurtleSoup_GATE.txt` → FALLITO (2 assi Y: `InpAdxMax`, `InpAtrMinPts`)** · 🔴 **`_EXT.txt` → FALLITO (3 assi Y: `InpWickFactor`, `InpUseMidGate`, `InpSide`)** *(eseguito oggi)*. **Vanno spezzati prima di poter anche solo proporre una riga** |
| **passate / minuti** | dopo lo spezzamento: 1 variabile × 3-4 celle = **6-8 P** → **≤ 12 min** per file |
| **attesa** | **n alto** (falsa rottura è un evento frequente), **PF vicino a 1** — ci si aspetta che il **gate del 50%** sia quello che separa, non i parametri |
| **schierabile l'1/10?** | 🔴 NO |
| **contro-esempio** | *«8 file già scritti = motore già considerato e lasciato perdere»* → **il cancello dice il contrario**: 2 su 8 sono **rossi da sempre**, e un file rosso **non può essere lanciato**. Non è stato «lasciato perdere»: **non era lanciabile**, e nessuno l'ha scritto da nessuna parte |

### 10 — `LATI_A1/A2_EMA200_U30USD` · **la prova di regime sulla sedia che sta in challenge** · **16 P, ≈ 24 min**
| | |
|---|---|
| **casella** | 4 file prova del **09/09** (`DISCESA_long/short`, `TORO_long/short`) su `771531`, la sedia migliore della flotta: **scritti e mai girati** |
| **attesa** | la regola C (16/08) dice che **la prova di regime batte la storia contigua**. Attesa dichiarata: il lato **long** regge in TORO e **soffre** in DISCESA; se **anche il long fosse negativo in TORO**, il PF OOS 1,52 su n=517 sarebbe **un artefatto di media** |
| **schierabile l'1/10?** | 🟢 **è GIÀ schierata** — questo round **non la promuove: la CONTROLLA** |
| **contro-esempio** | *«è già in campo, non toccarla»* → **e infatti non si tocca**: è una **misura in sola lettura sul banco**, non un cambio di cella. 🔴 **E il rischio del NON farla è asimmetrico**: se il motore è figlio di un regime solo, lo si scopre dal drawdown sulla challenge invece che da un CSV. Costo: 24 minuti |

### 📊 Il conto totale dei dieci
| | passate | minuti (tetto M5) |
|---|---:|---:|
| **#1-#3 — solo lettura** | **0** | **0** |
| **#4-#10 — misure** | **~90** | **≈ 135 min** (2 h 15) |

---

## 8️⃣ ✅ I FILE PROVA GIÀ VERDI (verificato oggi con `controlla_prova.py`)

```
ABTG_OutOfNoise       PASSO0_OUTOFNOISE_01_long / _02_short        2 celle cad.  8 P   OK
ABTG_VwapRevert       PASSO0_VWAPREV_01_long / _02_short           2 celle cad.  8 P   OK
ABTG_InvEsaurimento   INVES_NAS_00_baseline / _01_E1 / _02_E3      2 celle cad. 12 P   OK
ABTG_FvgRetest        PASSO0_FVGRET_02_short                       2 celle       4 P   OK
ABTG_BreakinBox       ABTG_BreakinBox_RRFISSO                      2 celle       4 P   OK
ABTG_AllineaLondra    PASSO0_ALLINEALONDRA_01/_02/_03              2 celle cad. 12 P   OK
ABTG_LiquiditySweep   R95b / R95c / R95d / R95e                    3 celle cad. 24 P   OK
ABTG_CrossEmaApertura R96a_{NASUSD,U30USD} / R96b_{NASUSD,U30USD}  2 celle cad. 16 P   OK
ABTG_Relativo         RELATIVO_R117_NAS_PORTO / R117BIS_NAS        2 celle cad.  8 P   OK
ABTG_BreakingBand     R94a / R94b / R94c                           2 celle cad. 12 P   OK
ABTG_SupertrendInvert G1PAOLO_10 / _11 / _12                       2 celle cad. 12 P   OK
```
🔴 **E i rossi, che vanno riparati prima di poter essere proposti:**
```
ABTG_CRT_TurtleSoup   _GATE.txt   FALLITO  2 assi Y (InpAdxMax, InpAtrMinPts)
ABTG_CRT_TurtleSoup   _EXT.txt    FALLITO  3 assi Y (InpWickFactor, InpUseMidGate, InpSide)
ABTG_GapContinuation  _R66.txt    FALLITO  2 assi Y (InpMinimumBuyGapPercent, ...SellGap...)
```
⚠️ **Nota di metodo, utile e non ovvia**: i file prova **vecchi** non hanno l'intestazione
`#  EA: <nome>` e `controlla_prova.py` li marca *«EA NON TROVATO → non misurabile»*.
**Non sono rotti**: vanno passati con `--ea mql5/Experts/<EA>.mq5`. Senza quello, un
controllo di massa li fa sembrare tutti guasti.

---

## 9️⃣ 🔴 NON COPERTO — cosa non ho potuto verificare, e perché

| # | buco | perché | come si chiude |
|---|---|---|---|
| 1 | **Il numero 201 del brief** per i file prova fermi | la mia definizione dura dà **115**, quella larga **589**. Non ho la definizione che produce 201 | far girare lo script che ha prodotto il 201 accanto al mio |
| 2 | 🔴 **I grandi scan DENTRO il censimento sono «indicizzati», non necessariamente «letti»** (`GoldenCross/H{1,4}_OHLC`, `SupertrendReversal/H{1,4}_OHLC`, `EMA200/H{1,4}_OHLC`, `csv_R80`, `Walkforward_Aperture`) | il censimento è automatico. La lettura documento-per-documento l'ho fatta solo sui **105 fuori indice** | rileggere per cella i 5 blocchi (costo macchina **zero**, costo di attenzione alto) |
| 3 | **Il fattore di sconto del costo salendo di TF** | a modello 4 il flusso di tick non cambia col TF: il risparmio è reale ma `[NON MISURATO]` | una corsa di taratura: stesso file prova, stesso simbolo, M5 contro H1, e si cronometra |
| 4 | **La frontiera del costo sull'ORO** per i 5 motori oro mai misurati | non ho aperto `RICERCA_SPREAD_PROP_XAUUSD_2026-09-17.md` | leggerlo (costo zero) |
| 5 | **Le 4 varianti `_Ottimizzato` senza CSV** | i loro round possono essere girati sull'EA originale col preset ottimizzato: i CSV non lo distinguono | incrociare i `InpMagic` nei CSV con i magic delle varianti |
| 6 | **`ABTG_DaxReEntry`: referto sì, CSV no** | `REFERTO_DAXREENTRY_2026-08-31.md` cita n=92, PF 1,159, DD 4,6% — ma **nessun CSV di quella corsa è in repo** | recuperare i CSV dal banco, o rifare la corsa |
| 7 | **`NASUSD_EXT` montato sul banco?** | serve a `INVES_NAS_*` (candidato #8) e non l'ho potuto verificare da qui | una riga di sola lettura sul PC di backtest |
| 8 | **I `.ex5` senza sorgente** | `mql5/Experts/esterni/NasdaqOpeningBreakout_EA_v21_OPTIMIZED.ex5` non è leggibile | — |
| 9 | **Non ho aperto i 36 `.mq5` riga per riga** | ho letto **le intestazioni**: meccanismo e attribuzione. Frequenza attesa e geometria dello stop sono `[NON MISURATO]` per quasi tutti | lettura mirata sui soli candidati che passano il passo 0 |

---

## 🔟 📌 IN UNA RIGA

**Non abbiamo 36 motori morti: abbiamo 36 motori mai accesi, 115 file prova scritti e mai
lanciati, 113 CSV che sembrano misure e non lo sono, e 11 motori sani che nessuno ha mai
provato su un secondo TF.** Niente di tutto questo diventa una sedia entro il 1 ottobre —
🟢 **ma tre voci su dieci costano ZERO minuti di macchina, e una quarta (#10) controlla la
sedia che sta girando in challenge in questo momento.**

*Documento di sola lettura. Nessun round lanciato, nessuna riga consegnata, nessun preset
toccato, nessuna sedia promossa o spenta.*
