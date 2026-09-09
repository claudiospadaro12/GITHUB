# 🚪 AUDIT DELLA GESTIONE DELL'USCITA — 09/09/2026

> **La domanda di Claudio, testuale:**
> _"MA ABBIAMO PROVATO TUTTE LE SOLUZIONI POSSIBILI? CON TRAILING, SENZA
> TRAILING, CON BE, SENZA BE, ECC ECC..."_

**Domanda legittima, e la risposta e' un NUMERO, non un'opinione.** Questo
referto conta i meccanismi d'uscita che esistono nel nostro codice, conta
quali sono stati messi **ad asse** in un round (con CSV agli atti), e conta
quali no.

**Perimetro spazzolato oggi:** `mql5/Experts/*.mq5` = **111 EA** ·
`backtest_pipeline/prove/` = **628 file prova** (623 nella radice + 5 in
sottocartelle) · tutti i driver `.ps1` e gli `.ini` di `backtest_pipeline/` ·
`backtest_pipeline/risultati_archivio/` (351 voci) · `report/*.md` (184 file).
**Metodo:** un parametro conta come "messo ad asse" solo se compare nella
forma `Nome=v||start||step||stop||**Y**` (ottimizzazione MT5) **e** esiste un
CSV o un referto che ne riporta l'esito. Tutto il resto e' `[NON MISURATO]`.

---

## 🎯 1. LA RISPOSTA IN TRE RIGHE

> **1.** **NO, non abbiamo provato tutto.** Su **32 meccanismi d'uscita censiti
> nel nostro codice**, **19 sono stati messi ad asse almeno una volta** (4 di
> questi solo parzialmente) e **13 non lo sono MAI stati** — piu' 4 meccanismi
> che nel codice **non esistono proprio**.
>
> **2.** **Ma la parte piu' importante SI', ed e' misurata bene:** trailing
> si/no, tipo di trailing, TF del trailing, soglia del trailing, breakeven
> si/no, breakeven anticipato, parziale si/no, e la distanza del target sono
> stati tutti misurati, su due indici, IS e OOS, con criteri congelati prima.
> **Il buco non e' "il trailing": e' che quelle misure sono state fatte quasi
> tutte su UNA famiglia sola — le APERTURE (DAX/Dow/Nasdaq) — piu' l'ORB.**
>
> **3.** **Sulle sedie che oggi stanno in campo su oro, argento, Nikkei,
> Nasdaq H1, DAX H4 — la famiglia Supertrend (`SupRev`, `SuperWave`,
> `SupertrendReversal`) — la gestione dell'uscita NON E' MAI STATA MESSA AD
> ASSE NEMMENO UNA VOLTA.** `InpTrailOnST` (15 EA), `InpExitOnFlip` (14 EA) e
> `InpFirstFraction` (14 EA) hanno **zero** occorrenze come asse in tutto il
> repo. Girano al default, e nessuno ha mai misurato quanto valgono.

---

## 🏆 2. LA COSA PIU' IMPORTANTE — quanto sposta il PF la gestione dell'uscita?

**LA MISURA ESISTE. Anzi, esiste DUE VOLTE, ed e' grossa.** Questo e' il
regalo dell'audit: non partiamo da zero.

### 2.1 · R46 (14/08) — stesso ingresso, 6 uscite diverse, fuori campione

`backtest_pipeline/risultati_archivio/REFERTO_ROUND46_GESTIONE.md`
Ingresso **identico e pinnato per nome** (retest, buffer 500, offset 200,
range 35', solo long, SL estremo opposto, rischio 1%). **L'unica cosa che
cambia e' cosa succede DOPO l'ingresso.** Tick reali, finestra OOS.

| DAX (D30EUR) — struttura d'uscita | Profit OOS | **PF** | DD % |
|---|---:|---:|---:|
| trailing PREVBAR, **niente** parziale | +23.607 | **1,49** | 6,27 |
| trailing PREVBAR + parziale 50% *(la sedia viva)* | +18.030 | 1,40 | 7,23 |
| parziale + BE, poi corre a 3R | +2.281 | 1,03 | 8,74 |
| trailing ATR + parziale | +1.951 | 1,03 | 10,85 |
| trailing ATR, niente parziale | −1.834 | 0,97 | 9,82 |
| **TP 3R secco (NESSUNA gestione)** | **−14.343** | **0,88** | **22,50** |

> ### 🔥 **IL NUMERO CHE RISPONDE ALLA DOMANDA: 0,88 → 1,49.**
> **Sullo stesso identico ingresso, la sola gestione dell'uscita muove il
> Profit Factor di 0,61 punti — e il drawdown da 22,50% a 6,27%.**
> Sul Dow (stesso referto) l'escursione e' **PF 1,01 → 1,27**, DD 4,39 → 9,39.
>
> **Tradotto:** l'uscita non e' una rifinitura. Sul DAX e' la differenza fra
> un motore che perde 14.343 e uno che ne guadagna 23.607. **Il 27° ribaltamento
> del progetto vive proprio qui** (TP 3R secco: +48.904 in campione, −14.343
> fuori — 63.000 euro sulla stessa ricetta).

### 2.2 · Dow Apertura, fase trailing (05/08) — 329 trade IDENTICI in ogni pass

`backtest_pipeline/risultati_archivio/Dow_Apertura/DOW_MOTORE.md`
Il confronto piu' pulito che abbiamo: **il trailing non tocca la selezione**,
quindi ogni pass ha gli stessi 329 trade. Cambia SOLO l'uscita.

| gestione | profit | **PF** | **DD %** | Sharpe | recovery |
|---|---:|---:|---:|---:|---:|
| **NUDA** (solo stop + TP) | 3.917 | 1,238 | 6,92 | 8,26 | 4,20 |
| **trailing base candela M5** | 3.882 | **1,371** | **5,32** | **13,99** | **6,51** |
| trailing ATR ×3 | 3.990 | 1,247 | 8,22 | 8,69 | 3,57 |
| trailing a punti fissi 0,24R *(fase distanze)* | — | 1,163 | 5,37 | — | — |

> **A parita' di profitto e di trade: PF +11%, drawdown −23%, Sharpe +69%.**
> ⚠️ **Limite dichiarato: e' IN CAMPIONE.** La FASE I del walk-forward
> (`Walkforward_Aperture/REFERTO_FASE_I_L.md`) ha poi trovato che fuori
> campione l'ordine dei TF si **rovescia** (Spearman −0,60) — ma su una
> geometria d'ingresso gia' bocciata, quindi "ordina modi di perdere".

### 2.3 · R47 — e sappiamo anche COSA compra e COSA vende il parziale

`REFERTO_ROUND46_GESTIONE.md` (sezione FASE 2), per-trade, magic vergini:

| | win rate | vincita media | perdita media | **payoff** | expectancy |
|---|---:|---:|---:|---:|---:|
| DAX **con** parziale (vivo) | **81,0%** | 291 | 890 | 0,327 | +67 |
| DAX **senza** parziale | 74,0% | 505 | 961 | **0,525** | **+123** |
| DOW **con** parziale (vivo) | **72,9%** | 336 | 711 | 0,473 | +52 |
| DOW **senza** parziale | 64,2% | 587 | 837 | **0,701** | **+77** |

> **Il parziale compra win rate vendendo payoff.** Misurato, non ipotizzato.

### 2.4 · ✅ Quindi la domanda di Claudio e' APERTA O CHIUSA?

**Meta' e meta', e vale la pena dirlo esatto:**
- ✅ **CHIUSA** su: trailing si/no, tipo di trailing, TF del trailing, soglia
  del trailing, BE si/no, BE anticipato, parziale 0 vs 50%, distanza del
  target. **Sulla famiglia APERTURE (DAX / Dow / Nasdaq) e sull'ORB.**
- 🔴 **APERTA** su tutto il resto della flotta — e in particolare
  **APERTISSIMA sulla famiglia Supertrend**, dove non esiste **nessuna**
  misura di gestione dell'uscita. Li' la frase giusta e':
  **"non e' mai stato misurato quanto l'uscita sposta il PF."**

---

## 📊 3. TABELLA A — COSA E' STATO PROVATO (con CSV agli atti)

| Motore | Meccanismo d'uscita | Ad asse? | Round / file prova | Valori provati | PF **con** | PF **senza** | Chi ha vinto |
|---|---|---|---|---|---|---|---|
| **DAX Apertura EU** | trailing ON/OFF + tipo (ATR / PREVBAR) + parziale 0/50 | ✅ | **R46a** · `prove/R46a_gestione_DAX.txt` · `risultati_prove/aperture_r46/` | UseTrailing 0/1 · TrailMode 0/1 · TP1_ClosePct 0/50 | PREVBAR+parz **1,40** · PREVBAR senza parz **1,49** | nessuna gestione (TP 3R secco) **0,88** | 🏆 **PREVBAR senza parziale** (ma i cancelli R35 lo bocciano sul Dow → nessun cambio live) |
| **Dow Apertura US** | idem (gemello di controllo) | ✅ | **R46b** · `prove/R46b_gestione_DOW.txt` | idem | LIVE **1,27** · senza parz **1,26** | TP 3R secco **1,13** | 🏆 LIVE (DD 4,39 il migliore) |
| DAX + Dow Apertura | **payoff / win rate** delle 2 strutture | ✅ | **R47** · `risultati_prove/aperture_r47/` (8 CSV per-trade, magic 772501-08) | con / senza parziale | payoff 0,327 (DAX) · 0,473 (DOW) | payoff **0,525** · **0,701** | 🤝 pareggio dichiarato: il parziale compra WR, vende payoff |
| **Dow Apertura US** | **tipo di trailing** (nudo / PREVBAR M1-M5 / ATR 1-3×) | ✅ | 05/08 · `risultati_archivio/Dow_Apertura/DOW_MOTORE.md` (30 pass) | 5 TF + 3 mult ATR + nudo | PREVBAR M5 **1,371** | nudo **1,238** | 🏆 **PREVBAR M5** (+11% PF, −23% DD) |
| **Dow Apertura US** | **TF del trailing, bordo della griglia** | ✅ | 05/08 fase `trailing2` (4 pass) | M5 · M6 · M10 · M12 · M15 · M20 | M5 **1,371** · M6 **1,371** | M20 1,251 | 🏆 M5 (gobba pulita, cima trovata) |
| **Dow Apertura US** | **breakeven anticipato** (`InpBEatR`) | ✅ | 04/08 fase `distanze` (48 pass → 16 combo distinte) · `dow_apertura.ps1` | BE tardi vs **BE a 0,5R** | BE a 0,5R: profit 1.601 | BE tardi: profit **2.575** | 🏆 **NIENTE BE anticipato** — 6 confronti su 8 in perdita, fino a **−38%** |
| **Dow Apertura US** | **distanza del trailing a punti fissi** | ✅ | 04/08 fase `distanze` | 0,24R · 0,72R · 0,96R | 0,96R: PF 1,212 | 0,24R: PF 1,163 | 🏆 largo > stretto, ma **nessun trailing fisso batte il nudo** |
| **DAX + Nasdaq Apertura** | trailing a base candela, TF M1-M6 + gestione NUDA | ✅ | 05/08 · `aperture_trailing.ps1` · `risultati_archivio/Aperture_Trailing/` (24 pass) + `APERTURE_TRAILING_DAX_NASDAQ.md` | UseTrailing 0/1 × TF M1..M6 | DAX M5 **0,994** · NAS M2 **0,965** | DAX nudo **0,961** · NAS nudo **0,955** | ⚠️ **nessuno**: 24 combo, PF sempre <1. Il trailing taglia il DD (DAX 38,96% → 19,74%) ma non crea edge |
| **DAX + Nasdaq Apertura** | **TP 1,5R/3R × parziale 0/50 × BE off/on** | ✅ | **FASE F (B1)** · `walkforward_aperture.ps1` r.259-260 · `Walkforward_Aperture/DAX_F_gestione_{IS,OOS}.csv` · `REFERTO_FASE_F_G_B1.md` | 6 strutture, IS+OOS | TP3R+parz+BE (accesa) **1,237** | TP 1,5R secco **1,164** | 🏆 **la configurazione ACCESA** (piu' profitto, PF piu' alto, DD piu' basso). Tutte e 6 positive OOS |
| **DAX + Nasdaq Apertura** | **TF del trailing, fuori campione** | ✅ | **FASE I** · `walkforward_aperture.ps1` r.296 · `REFERTO_FASE_I_L.md` | TrailTF M1..M5 | — (tutte e 10 le celle OOS negative) | — | ❌ **nessuno**: Spearman IS→OOS **−0,60**. Verdetto: non si tocca niente |
| **DAX Apertura EU** | **soglia di armamento del trailing × TF** | ✅ | **R24** (`prove/R24_trailing_nasdaq.txt`, gemello DAX 08/08) + `REFERTO_TRAILING_SOGLIA.md` (25 celle) | TrailTF M1..M5 × TrailStartR 0 / 0,25 / 0,5 / 0,75 / 1,0 | soglia 1,0R: PF 1,031 | **soglia 0**: PF **1,415** | 🏆 **soglia 0** — vince in **tutte e 5** le righe OOS, discesa monotona. In campione vinceva 1,0R: **8° ribaltamento** |
| **ORB Ottimizzato (Dow)** | **trailing EMA9 off/on + parziale 0/50 + TP range** | ✅ | **R15** · `prove/R15_ORB_gestione_DD.txt` · `REFERTO_ROUND15_ORB_GESTIONE.md` (64 celle) | UseTrailEMA 0/1 · TP1Pct 0/50 · TPRangeMult 1,0/1,5 | trailing ON: **PF OOS 1,657**, DD 9,92% | trailing OFF: PF OOS ~ profit +1.730, DD **16,7%** | 🏆 **trailing EMA9 ON, parziale OFF** — 13° ribaltamento (in campione il trailing sembrava COSTARE) |
| **ORB Ottimizzato (Dow/Nasdaq)** | **distanza del target** (`InpTPRangeMult`) | ✅ | **R44a/b** · `prove/R44{a,b}_target_*.txt` · `REFERTO_ROUND44_TARGET.md` | 1,5× → 3,0× | 3,0×: **PF OOS 1,955**, DD 10,89% | 1,5×: PF OOS 1,66, DD 9,92% | ⚖️ **1,5× resta** — il PF 1,955 perde contro il cancello DD <10% congelato prima |
| **PTE** | **target in ATR** (`InpTP2_ATRmult`) — 48 file prova, il parametro d'uscita piu' spazzolato del repo | ✅ | **R67-R69** · `prove/PTE_*.txt` · `REFERTO_ROUND67_PTE_ACCOPPIAMENTO.md` (32 celle, 16 anni) | 1,5 · 2,0 · 2,5 · 3,0 | TP2=2,5 vince in **8 gruppi su 8** | TP2=2,0 (il vivo) 2° in 8 su 8 | 🤝 **nessun cambio**: differenza piccola, e il target **non si accoppia** allo stop (ipotesi Leung&Li falsificata a costo zero) |
| **EMA200** | **TP finale in R** (`InpTP_RR`) | ✅ | **R29a/b, R32a/b** · `prove/R29*.txt`, `prove/R32*.txt` | 1,5 · 2,0 · 2,5 | — (30 celle su 30 a PASS pieno, PF OOS **1,44-1,61**) | — | 🏆 altopiano intero, nessuna cella sotto 1,10 |
| **SupRev (Supertrend)** | **TP finale in R** (`InpTP_RR`) | ✅ | **R18, R21, R22** · `prove/R18_suprev_ibex.txt`, `R21`, `R22` | 2,0 · 2,5 · 3,0 | — | — | (l'unico parametro d'uscita mai toccato su questa famiglia) |
| **EasyTrend** | **TP in R** (`InpTP_R`) | ✅ | **R48a-d** · `prove/R48*.txt` | 1,0 · 1,5 | — | — | — |
| **Londra ORB / oro** | **TP in R** | ✅ | **R45a-c, R8, R10** | 1,5 · 2,0 | — | — | ❌ R45: **0 celle verdi su 48** — un target diverso non salva un motore morto |
| **ORB Ottimizzato (Dow)** | **modo del TP** (`InpTPMode`: R vs frazione di range) | ✅ | **R88a** · `prove/R88a_stoplargo_U30USD.txt` · `risultati_archivio/r88_csv/` (48 celle × 2 finestre) | TPMode 0/1 × TP_R 1,5/2,0 | vedi CSV | vedi CSV | ⚠️ **[ESITO NON ISOLATO]** — nel round il TP e' un asse secondario accanto allo stop; nessun referto separa l'effetto del solo TP |
| **CostToCost** | **modo d'uscita intero** (`InpExitMode`: cost-to-cost puro / TP a R / flip di struttura) | ✅ | `scan_market.ps1` r.254 · `risultati_prove/ABTG_CostToCost/scan_h1`, `scan_h4` (864 celle, 48 simboli, 2 TF, 4 lati) | 0 · 1 · 2 | **PF mediano** (celle n≥25, calcolato oggi): puro **0,713** · R-based **0,755** · flip **0,655** | — | ⚠️ **nessuno**: e' screening **OHLC**, tutte e 3 le mediane sotto 1. Celle con PF≥1,10: 16 / 8 / 8 su 288 |
| **PunteLarry** | **modo d'uscita** (`InpExitMode`: first-profitable-open di Williams vs TP in R) | ✅ | `notte_larry.ps1` r.118 | 0 · 1 | — | — | ⚠️ **[ESITO NON TROVATO AGLI ATTI]** — l'asse c'e', un referto che ne isoli l'esito no |
| **CanaleLento** | **uscita su canale Donchian** (`InpExitPeriod`, `InpExitMiddle`) | ✅ | `prove/ABTG_CanaleLento.txt` | Period 10/20 · Middle 0/1 | — | — | ⚠️ **[ESITO NON TROVATO AGLI ATTI]** |
| **GapContinuation** | **target finale in R** (`InpFinalTargetR`) | ✅ | `prove/ABTG_GapContinuation.txt` | 2,0 · 3,0 | — | — | — |
| **SondaOrologio** | **time-stop a ore** (`InpOreDurata`) | ✅ | 12 file `prove/SONDA_OROLOGIO_*.txt` · `REFERTO_OROLOGIO_INDICI_DAX_2026-09-07.md` | 4 · 8 · 12 ore | — | — | ❌ **0 fasce asimmetriche su 72 in OOS**: sul DAX l'orologio non esiste. ⚠️ **Qui la durata E' la strategia**, non una gestione aggiunta a un motore |
| **R93f** | **flat del venerdi'** (`InpFridayClose`) | ✅ | `prove/R93f_weekend.txt` | off / on | — | — | ⚠️ **[ESITO NON TROVATO AGLI ATTI]** |
| **BandFade / TurnaroundTuesday / OpeningReversalB / ImpulsoApertura / VwapRevert** | TP in R (`InpTP_R`, `InpRR`, `InpTpR`) | ✅ | `prove/ABTG_*.txt` (bozze) | 1,0-2,5 | — | — | — |

**Totale file prova con almeno un asse d'uscita: 61 su 628 (9,7%).**
**Ma i file prova che mettono ad asse un meccanismo di GESTIONE vero
(trailing / BE / parziale, non la distanza del target): 7 su 628 = 1,1%.**
Sono `R15`, `R24`, `R46a`, `R46b`, `ABTG_DAX_Apertura_EU`, `ABTG_CanaleLento`
e il gemello DAX di R24. Tutto il resto della gestione misurata vive dentro i
driver `.ps1` (`dow_apertura.ps1`, `walkforward_aperture.ps1`,
`aperture_trailing.ps1`, `walkforward_generico.ps1`), **non nei file prova** —
e questo e' un dato di processo da tenere: **chi cerca "cosa abbiamo provato"
guardando solo `prove/` non lo trova.**

---

## 🕳️ 4. TABELLA B — COSA NON E' MAI STATO PROVATO

_"Ad asse" = zero occorrenze `...||Y` in tutto `backtest_pipeline/` (prove,
ini, ps1). Verificato uno per uno oggi._

| Motore / famiglia | Meccanismo mai messo ad asse | Gia' nel codice? | Costo stimato per provarlo |
|---|---|---|---|
| 🔴 **SupRev · SuperWave · SupertrendReversal** (le sedie vive su oro, argento, Nikkei, NAS H1, DAX H4, CAC, DOW) | **trailing sul Supertrend** `InpTrailOnST` (`ABTG_SupertrendReversal.mq5:82`, `ABTG_SuperWave.mq5:85`) | ✅ **15 EA**, default `true` | **2 celle × 2 lati × N simboli.** Su 4 simboli = 16 celle × 2 finestre = **32 passate**. Calibrazione: R88a ha girato 48 celle × 2 finestre in **8,0 min** (`r88_csv/REFERTO_R88.txt`) → **meno di un'ora** |
| 🔴 **idem** | **uscita al flip del Supertrend** `InpExitOnFlip` (`:83` / `:86`) | ✅ **14 EA**, default `true` | stesso ordine di grandezza. **Va spazzolato INSIEME a TrailOnST** (interagiscono: 4 celle invece di 2) → **64 passate su 4 simboli** |
| 🔴 **idem** | **frazione d'ingresso / scale-in** `InpFirstFraction` = 0,3333 (`:70` / `:71`) | ✅ **14 EA** | 3 celle (0,33 / 0,50 / 1,00) × 2 lati × 4 simboli = **24 celle** |
| 🔴 **idem + PTE + EMA200 + LiquiditySweep + MaxMinNotte** | **percentuale del parziale diversa da 0 e 50** (`InpTP1Pct`, `ABTG_PTE.mq5:85`, `ABTG_EMA200.mq5:78`, `ABTG_SupertrendReversal.mq5:79`) | ✅ **56 EA** | 🔥 **Il buco piu' economico di tutti.** Provati SOLO 0 e 50. Mancano 25 / 33 / 75. **3 celle in piu' per motore.** ⚠️ E c'e' un vincolo di campo gia' misurato: sugli indici lo **step del lotto 0,10 rende il parziale impossibile sotto certe taglie** (`report/DIARIO.md` 17/08 e 28/08) → il test va girato a una taglia dove il parziale non e' tassato |
| 🔴 **PTE (oro, GBPUSD, USDJPY)** | **trailing sull'EMA14** `InpUseTrailing` (`ABTG_PTE.mq5:88`, default `true`) | ✅ | **2 celle × 2 lati.** Il PTE ha 48 file prova con `TP2_ATRmult` ad asse e **ZERO** col trailing: il target l'abbiamo spremuto, l'uscita no |
| 🔴 **EMA200** (5 sedie vive) | **trailing sull'EMA14** `InpUseTrailing` (`ABTG_EMA200.mq5:80`) | ✅ | 2 celle × 2 lati × 5 simboli = **20 celle** |
| 🔴 **GoldenCross** (4 sedie vive) | **parziale** `InpPartialR` / `InpPartialPct`, **trailing ATR** `InpTrailMode`/`InpTrailAtrMult`, **uscita su incrocio** `InpExitOnCross` / `InpExitOnHAflip` | ✅ 3-4 EA | **4 assi mai toccati** su un motore con 144 celle gia' girate su altri parametri (R87b). Marginale: **~32 celle** |
| 🔴 tutta la flotta | **BE con buffer/offset** `InpBEBufferPts` (`ABTG_FvgRetest.mq5`), `InpBE_Offset`, `InpBeBufferPoints` | ✅ pochi EA | 3 celle. **Basso valore** (parametro di rifinitura) |
| 🔴 **BreakingBand** | **BE ad ATR** `InpBEatATR` / `InpBEAtrTrigger` / `InpBEMode` | ✅ 1-2 EA | 3 celle |
| 🔴 **SuperWave_EA · Nasdaq Apertura** | **terzo scaglione / runner** `InpTP3_R` (`ABTG_SuperWave_EA.mq5`), `InpRunnerTP_R` (`ABTG_Nasdaq_Apertura_US.mq5`) | ✅ 2 EA | 3 celle. ⚠️ Ma la lezione R46/R47 dice che il **secondo** scaglione gia' costa payoff: prima di aggiungerne un terzo, misurare |
| 🔴 **CostToCost · Relativo · Gold_Scalper** | **time-stop a barre** `InpMaxBarsHold` (pinnato **100** in ogni corsa), `InpMaxBarsInTrade`, `InpBarreMaxTenuta` | ✅ **11 EA** | 4 celle (25/50/100/200). ⚠️ **Nota di campo**: il 24/08 `COST EURJPY` e' stato chiuso **dall'orologio** al 54% catturato — *"COST non ha ne' BE ne' trailing, il suo unico meccanismo di protezione e' l'orologio"* (`report/DIARIO.md`), **e quell'orologio non e' mai stato tarato** |
| 🔴 **37 EA** (aperture, ORB, MaxMinNotte, CRT, BreakinBox...) | **flat di fine seduta / ora di chiusura** `InpCloseAtEnd` (23 EA), `InpCloseHour`, `InpFlatOra`, `InpExitHour` | ✅ **37 EA** | 3-4 celle per motore. **Zero occorrenze ad asse in tutto il repo.** E' l'uscita che decide il P&L di ogni sedia intraday, ed e' sempre stata pinnata |
| 🔴 **16 EA** | **flat su news** `InpNewsFlatten` | ✅ 16 EA | 2 celle. Mai misurato se chiudere prima di una news costa o salva |
| 🔴 **ORB / ORB_Fibo / ORB_Ottimizzato** | **uscita su chiusura oltre la EMA** `InpExitOnEmaClose` | ✅ 3 EA | 2 celle. ⚠️ **Dichiarato ed escluso a mano**: `prove/R15_ORB_gestione_DD.txt` scrive _"niente ExitOnEmaClose in questo giro (un asse alla volta; e' il candidato del giro successivo se serve)"_ — **quel giro successivo non c'e' mai stato** |
| 🔴 **SupertrendInvert · IchiCross · InvEsaurimento · OutOfNoise · VwapRevert** | **uscita su segnale opposto** `InpExitOnOpposite` / `InpCloseOnOpposite` | ✅ 5 EA | 2 celle per motore |
| 🔴 **Londra ORB** | **dimezza su segnale opposto** `InpHalveOnOpposite` | ✅ 1 EA | 2 celle |
| 🔴 **Gold_Scalper** | **trailing solo dopo il parziale** `InpTrailOnlyAfterPartial` | ✅ 1 EA | 2 celle |
| 🔴 **Gold_Ichimoku_TK_ATR** | **chandelier ATR** (`EXIT_ATRTRAIL`, `Gold_Ichimoku_TK_ATR_EA.mq5:61,100`) | ✅ **1 EA solo**, mai portato sulla flotta ABTG | 3 celle sul solo EA che ce l'ha. **Portarlo sugli ABTG = scrivere codice** (~30 righe) |

### 🚫 E i meccanismi che nel codice NON ESISTONO PROPRIO (verificato oggi su 111 EA)

| Meccanismo assente | Verifica | Costo per averlo |
|---|---|---|
| **Time-stop CONDIZIONATO** ("se dopo N barre non sei a +X R, esci") | zero occorrenze in 111 EA | ~20 righe + 6 celle. 🎯 **E' il candidato piu' interessante della lista**: attacca esattamente il fenomeno "trade giusto che torna a casa a pari" registrato **tre volte** (17/08 SuperWave 2,19R → 0% · 18/08 MaxMin DAX 1,63-1,89R → 0% · 19/08 PTE USDJPY uscita = ingresso esatto) |
| **Trailing a scaletta / step** (`InpTrailStep`) | zero occorrenze | ~15 righe |
| **Trailing la cui DISTANZA e' espressa in R** (non in punti, non in ATR) | esiste solo `InpTrailStartR` = **soglia di armamento**, non distanza | ~10 righe. Nota: la fase distanze del Dow ha convertito i punti fissi in R **a posteriori** (0,24 / 0,72 / 0,96 R) — la conversione la faceva l'analista, non l'EA |
| **Uscita parziale a 3+ scaglioni** su un ABTG di flotta | solo `SuperWave_EA` ha `InpTP3_R` | ~25 righe |

---

## 🧰 5. INVENTARIO COMPLETO — 32 meccanismi, EA per EA (per famiglia)

| # | Famiglia di meccanismo | Input | EA che ce l'hanno | Ad asse? |
|---:|---|---|---:|---|
| 1 | Trailing ON/OFF | `InpUseTrailing`, `InpTrailingEnabled`, `InpTrailMode` | 27 | ✅ R46, aperture_trailing, Dow |
| 2 | Trailing ATR | `InpTrailAtrMult`, `InpUseTrailAtr`, `InpATR_Trail` | 29 | ✅ Dow (1×/2×/3×), R46 |
| 3 | Trailing base candela (PREVBAR) | `InpTrailMode=1` | 10 | ✅ R46, Dow, FASE I |
| 4 | Trailing a punti fissi | `InpTrailFixedPts`, `InpTrailNewSLpips`, `InpTrailDollars` | 13 | ✅ Dow fase distanze |
| 5 | TF del trailing | `InpTrailTF` | 11 | ✅ M1..M20 su 4 round diversi |
| 6 | Soglia di armamento del trailing | `InpTrailStartR`, `InpTrailingActivation_R` | 13 | ✅ R24 + 25 celle TF×soglia |
| 7 | Trailing su EMA | `InpUseTrailEMA`, `InpUseEMA21Trail` | 6 | ✅ R15 (off/on) |
| 8 | **Trailing su Supertrend** | `InpTrailOnST` | **15** | 🔴 **MAI** |
| 9 | **Trailing chandelier** | `EXIT_ATRTRAIL`, `InpAtrTrailMult` | 1 | 🔴 **MAI** |
| 10 | **Trailing solo dopo parziale** | `InpTrailOnlyAfterPartial` | 1 | 🔴 **MAI** |
| 11 | BE al primo target | `InpBreakeven`, `InpBreakevenAtTP1` | 62 | ✅ FASE F (off/on) |
| 12 | BE anticipato in R | `InpBEatR` | 10 | ✅ Dow fase distanze (0 vs 0,5R) |
| 13 | **BE ad ATR** | `InpBEatATR`, `InpBEAtrTrigger`, `InpBEMode` | 1-2 | 🔴 **MAI** |
| 14 | **Buffer/offset del BE** | `InpBEBufferPts`, `InpBE_Offset` | 2-3 | 🔴 **MAI** |
| 15 | Parziale al 1° target (%) | `InpTP1_ClosePct`, `InpTP1Pct`, `InpPartialPct` | 56 | ⚠️ **solo 0 vs 50** |
| 16 | Raggio del parziale | `InpTP1_R`, `InpPartialR` | 30+ | ⚠️ solo come scala del TP (FASE F 0,5/1,0) |
| 17 | **Frazione d'ingresso / scale-in** | `InpFirstFraction`, `InpScaleInOrders` | **14** | 🔴 **MAI** |
| 18 | **Runner / 3° scaglione** | `InpTP3_R`, `InpRunnerTP_R`, `InpTPfinal_R` | 11 | 🔴 **MAI** |
| 19 | TP in R | `InpTP_R`, `InpTP_RR` | 35 | ✅ **73 occorrenze come asse** — il piu' misurato del repo |
| 20 | TP in ATR | `InpTP1_ATRmult`, `InpTP2_ATRmult` | 6+ | ✅ PTE, 48 file |
| 21 | TP in frazione di range | `InpTPRangeMult` | 4 | ✅ R12-R15, R44 |
| 22 | Modo/struttura del TP | `InpTPMode`, `InpExitMode`, `InpUseEMA200Target`, `InpUseVwapTP` | 10+ | ⚠️ parziale (R88a, CostToCost OHLC) |
| 23 | **Time-stop a barre** | `InpMaxBarsHold`, `InpMaxBarsInTrade`, `InpBarreMaxTenuta` | **11** | 🔴 **MAI** |
| 24 | Time-stop a ore | `InpOreDurata`, `InpHoldHours` | 3 | ⚠️ solo sulla **sonda dedicata**, mai su una sedia viva |
| 25 | **Flat di fine seduta** | `InpCloseAtEnd`, `InpCloseHour`, `InpFlatOra`, `InpExitHour` | **37** | 🔴 **MAI** |
| 26 | Flat del venerdi' | `InpFridayClose` | 13 | ⚠️ 1 asse (R93f), esito non agli atti |
| 27 | **Flat su news** | `InpNewsFlatten` | **16** | 🔴 **MAI** |
| 28 | **Uscita al flip del Supertrend** | `InpExitOnFlip` | **14** | 🔴 **MAI** |
| 29 | **Uscita su segnale/incrocio opposto** | `InpExitOnOpposite`, `InpCloseOnOpposite`, `InpExitOnCross`, `InpExitOnHAflip`, `InpExitOnEmaClose` | 11 | 🔴 **MAI** (R15 lo esclude per iscritto) |
| 30 | **Dimezza su segnale opposto** | `InpHalveOnOpposite` | 1 | 🔴 **MAI** |
| 31 | Uscita "first profitable open" vs R | `InpExitMode` (Larry, COST) | 2 | ✅ solo screening OHLC |
| 32 | Uscita su canale Donchian | `InpExitPeriod`, `InpExitMiddle` | 1 | ✅ asse presente, esito non agli atti |

**CONTO FINALE: 32 meccanismi · 19 messi ad asse almeno una volta (di cui 4
solo parzialmente) · 13 MAI · + 4 meccanismi assenti dal codice.**

---

## ⚠️ 6. TRE COSE CHE QUESTO AUDIT HA TROVATO E CHE NON CERCAVA

1. **🧊 `scan_gestione.ps1` esiste, e' scritto bene, e non e' MAI STATO
   LANCIATO.** `backtest_pipeline/scan_gestione.ps1` r.38-46: 48 pass che
   spazzolano **parziale × BE-dopo-parziale × BE indipendente (`InpBEatR`) ×
   trailing (OFF/ATR/PREVBAR/FIXED)** — cioe' quasi tutta la Tabella B in un
   colpo — piu' una fase `distanze` (r.60-72) su `TP1_R × BEatR ×
   TrailFixedPts`. Citato in `HANDOFF.md:1672`, `STUDIO_MOVIMENTO_APERTURE.md:54-59`
   e `FORWARD_03-08_PROVA_GESTIONE.md:128`. **Nessun CSV, nessun referto, nessuna
   etichetta di risultato in tutto il repo.** 🎯 **E' pronto: se domani si
   vuole chiudere il buco sulle aperture, il codice c'e' gia'.**

2. **📌 La gestione misurata vive nei driver, non nei file prova.** 61 file
   prova su 628 hanno un asse d'uscita, ma solo 7 hanno un asse di GESTIONE.
   Le misure migliori (R46 a parte) stanno dentro `dow_apertura.ps1`,
   `walkforward_aperture.ps1`, `aperture_trailing.ps1`. **Chi cerca "l'abbiamo
   gia' provato?" nei soli `prove/` risponde NO quando la risposta e' SI'.**

3. **🔁 Il fenomeno che la Tabella B spiega.** Tre ricorrenze registrate in
   pagella — 17/08 `SUPERWAVE DOW H1` (2,19 R disponibili, **0% catturato**,
   _"il trailing sul Supertrend H1 non ha stretto una volta"_) · 18/08
   `MAXMIN DAX SHORT` (1,63-1,89 R, 0%) · 19/08 `PTE USDJPY` (uscita = ingresso
   esatto). **Il meccanismo sotto accusa in due casi su tre e' `InpTrailOnST`,
   che e' esattamente la riga 8 della tabella dei MAI MISURATI.** Non e' un
   sospetto: e' un parametro al default che nessuno ha mai messo su una griglia.

---

## 🚦 7. LIMITI DICHIARATI DI QUESTO AUDIT

- Un asse `||Y` **non garantisce** che il round sia stato girato: dove non ho
  trovato CSV o referto ho scritto **`[ESITO NON TROVATO AGLI ATTI]`**
  (`R93f`, `CanaleLento`, `notte_larry`).
- Le **mediane PF del CostToCost** (0,713 / 0,755 / 0,655) le ho **calcolate
  oggi** dai CSV di `risultati_prove/ABTG_CostToCost/scan_h1` e `scan_h4`,
  celle con n≥25. Sono **OHLC, non tick reali**: valgono come screening, non
  come verdetto (regola di casa: _"un numero OHLC non e' mai un verdetto"_).
- Il conteggio "EA che ce l'hanno" e' sui **111 sorgenti**, non sulle sedie
  vive: alcuni EA sono laboratori o cadaveri.
- **Non ho toccato nessun EA, nessun parametro, nessun forward, e non ho
  committato.** Questo file e' l'unica cosa scritta.

---

## 🎯 8. SE SI VUOLE CHIUDERE IL BUCO PRIMA DI OTTOBRE

Ordinato per **rapporto valore/lavoro**, con la regola di casa
(_centro dell'altopiano, mai il picco_ · criteri congelati prima):

| # | Cosa | Perche' adesso | Costo |
|---|---|---|---|
| 🥇 | **`InpTrailOnST` × `InpExitOnFlip` sulla famiglia Supertrend** | e' la famiglia con **piu' sedie in campo** e **zero** misure di uscita; e il fenomeno "0% catturato" punta li' | 4 celle × 2 lati × 4 simboli × 2 finestre = **64 passate**, < 2 ore per analogia con R88a |
| 🥈 | **Lanciare `scan_gestione.ps1` cosi' com'e'** su DAX e Nasdaq apertura | 48 pass gia' scritti, chiude BE-indipendente + 4 tipi di trailing in un colpo | **2 lanci**, gia' pronti |
| 🥉 | **Parziale al 25% / 33% / 75%** (oggi provati solo 0 e 50) | 56 EA lo hanno; R47 dice che il parziale **compra WR e vende payoff** → la % e' la manopola di quel cambio, e non e' mai stata girata | 3 celle in piu' per motore |
| 4 | **Flat di fine seduta ad asse** su una sedia intraday | 37 EA, mai misurato, ed e' l'uscita che decide il P&L di ogni sedia intraday | 4 celle |
| 5 | **Time-stop condizionato** (da scrivere) | attacca direttamente le 3 ricorrenze del "trade giusto che torna a pari" | ~20 righe + 6 celle |

> 😄 **La buona notizia, e va detta:** la domanda di Claudio non trova una
> lavagna vuota. Trova **R46, R47, R15, R24, R44, la fase distanze e la fase
> trailing del Dow, la FASE F e la FASE I del walk-forward** — cioe' un corpo
> di misure serio, con i criteri scritti prima e i ribaltamenti registrati.
> **La risposta non e' "non abbiamo mai guardato". E' "abbiamo guardato bene,
> ma solo in una stanza della casa".** E le altre stanze sono a poche ore di
> tester di distanza. 🚀

---

## 🎙️ 9. CONFERMA ESTERNA ARRIVATA LO STESSO GIORNO (rimando, non duplicato)

La live di Emiliano del **09/09/2026** contiene, raccontata in diretta e con
l'esito commentato a caldo dal relatore, **la sequenza esatta che il §2.1 misura
come la peggiore**: parziale a meta' posizione preso presto (~20-24 punti su un
target ATR di 28), poi **stop ALLARGATO invece che portato a pari**, poi stop
preso, poi — testuale — _"profitto ridicolo"_ e _"questi erano altri 50 punti"_.

> 🟢 **Due strade indipendenti, stessa conclusione.** La nostra e' una misura su
> tick reali fuori campione (**1,49 senza parziale · 1,40 col parziale · 0,88
> senza gestione**); la sua e' un aneddoto in diretta. **Non hanno lo stesso
> peso — la misura vale, l'aneddoto conferma — e la conferma NON riapre nulla:**
> i cancelli R35 bocciano il cambio sul Dow, quindi **nessun cambio live**.

📌 Ne esce **un solo asse nuovo**, ed e' uno spunto: lui ancora il parziale al
**target di volatilita' (frazione dell'ATR, ~0,71-0,86x)**, noi lo ancoriamo
sempre al **rischio** (`TP1_R` / `TP1_ClosePct`). **Ancoraggio diverso, unita'
diversa: non si copia il numero.**

➡️ **Referto completo: `report/ANALISI_LIVE_EMILIANO_2026-09-09.md`**
(§1.1.1 la sequenza riga per riga · §4 i tre cantieri · §5 lo spunto S1).
🚩 Nello stesso referto la **prima bandiera ROSSA** delle cinque live di Emiliano
(mediazione reattiva insegnata in scalping) — **VIETATA PER NOI**, documentata
come intelligence.
