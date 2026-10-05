# LETTURA DEI CSV TRASPORTATI - FAMIGLIE FOREX "DI AGOSTO" (G4) + PTE + SUPERTREND (225JPY, ORO) - 05/10/2026

> **DOCUMENTO INTERNO. PASSATO DAL CANCELLO `controllo-preventivo` il 05/10/2026 CON RISERVE**: le correzioni del cancello sono marcate in corsivo nel testo ("corretto/precisazione del cancello"); le riserve stanno nella sez. 9.3.
> **Cosa e'**: la lettura riga per riga dei CSV che Claudio ha trasportato il 05/10/2026 sul repo (`backtest_pipeline/risultati_prove/dal_vps/`, transcript `backtest_pipeline/risultati_archivio/TRASPORTO_CSV_20261005/TRASPORTO_CSV_20261005_215946.txt`: 254 CSV trovati, 191 scritti, di cui **82 nelle dieci cartelle di questa lettura**). Sono i round che il runner ha girato sul banco `50504400` il 14-20/09 e che i resoconti G3/G4/G5 del 05/10 marcavano "CSV non in repo / NON MISURATO / [DICH]".
> **Cosa NON e'**: nessun round lanciato, nessun contatto col VPS, nessun file di altri agenti toccato, **nessun criterio nuovo**. I verdetti dei resoconti **non sono riscritti**: dove cambierebbero lo scrivo come **proposta** (sez. 7).
> **Regola di precedenza**: il CSV batte il referto, il referto batte la prosa. Dove un dato manca: **NON LEGGIBILE**. Dove un dato e' dedotto e non letto: **[DERIVATO]**.

---

## 0. PERIMETRO, METODO, REGOLE DI LETTURA

**Cartelle lette (10)**: `ABTG_GapFill`, `ABTG_PunteLarry`, `ABTG_BreakingBand`, `ABTG_EasyTrend`, `ABTG_CostToCost`, `ABTG_GapContinuation`, `ABTG_FiboH4_Multi`, `ABTG_PTE`, `ABTG_SupertrendReversal`, `ABTG_SupertrendReversal_Ottimizzato`.
**Numeri**: 82 file = **41 etichette di round** (`rNNN`), **63 file con righe (414 righe-cella)** e **19 file a 0 byte**. Nel transcript: 76 NUOVI, 5 AGGIORNATI (`CostToCost_EURJPY_IS_ohlc_r127c`, `FiboH4_Multi_GBPUSD_{IS,OOS}_ohlc_r139c`, `SupertrendReversal_Ottimizzato_XAUUSD_{IS,OOS}_ohlc_r127b`), 1 IDENTICO (`CostToCost_EURJPY_OOS_ohlc_r127c`).

**Come ho letto (tutto ricalcolato da me, un piccolo script Python in scratchpad, NON committato)**:
1. Ogni riga del CSV: colonne `Profit Factor`, `Trades`, `Equity DD %`, `Profit` (+ `Peggior Giornata %` dove esiste). **Nessun numero e' copiato da un referto.** Dove il referto esiste nel repo (log del runner per r162a e r178a) l'ho confrontato riga per riga (sez. 3).
2. **Cella** = una riga del CSV (un valore dell'asse spazzolato, per una finestra). **SOPRA** = PF >= 1,00; **SOTTO** = PF < 1,00 (piano 5.3); nessuna soglia di "zona grigia" (non esiste, D2 del piano). Ho letto **sempre tutte le righe, nei due versi** (classe 1127): in ogni tabella ci sono le celle SOPRA **e** le SOTTO.
3. **Cella viva** = il valore di default dell'asse nel file prova (`InpX=<default>||...||Y`, `backtest_pipeline/prove/R*.txt`); e' la cella che coincide con l'ancora di contratto/sedia. Non ho scelto nessuna cella "migliore".
4. **Finestre IS/OOS**: i CSV non portano date. Le ho **calcolate con la regola del driver** (`walkforward_generico.ps1` r.934: `meta = inizio + floor(giorni_totali x FrazioneIS)`; IS = inizio..meta, OOS = meta+1..fine; inizio=`@DAQUANDO`, fine=`@FINOA` o default 2026.06.30, `@FRAZIONEIS` o default 0,40). La regola **riproduce** le due finestre dichiarate in chiaro: IS `2024.09.26-2025.06.09` / OOS `2025.06.10-2026.06.30` (log r178a) e IS BB `1999.01.04-2012.10.01` (testo di `R161a`, sezione "IL PAVIMENTO IS>=150"). Tutte le date di questa lettura sono quindi **[DERIVATO]** (stessa regola, verificata su due casi).
5. **Tipo di dato**: nome con `_ohlc` = barre OHLC M1, modello 1 = **[B] screening**; nome senza suffisso = **tick reali [T]**, modello 4 (convenzione del driver, spiegata in `R146a` r.26-33; confermata dai `-Modello 1/4` letti in `REFERTO_RUNNER_2026091[3-9]/20.txt` per tutti i 41 round). **Deposito 100.000, rischio 1%** per tutti (referti runner), salvo `r139c` a **10.000** e `r166a` a **0,65%**.
6. **Unita' di n**: la colonna `Trades` conta **deal chiusi**. = posizioni dove non c'e' parziale: BB (`InpTPMode=0`, `InpTP1Pct` letto ma spento, verificato da G4 R1), EZ, C2C, GapFill, PunteLarry (nessun input di parziale nell'intestazione dei loro CSV). **= deal, posizioni NON LEGGIBILI** (parziale 40-50% acceso; fattore deal/posizioni 1,00-2,31 del piano 5.4) per `FiboH4_Multi`, `PTE`, `SupertrendReversal`, `SupertrendReversal_Ottimizzato` (`InpTP1Pct=50`) e `GapContinuation` (`InpPartialClosePercent=40`): nessun per-trade in repo per questi round.
7. **Affidabilita'** (piano 5.4): A/B/C/D sul n della finestra; i dati [B] portano il suffisso "-scr"; per i deal uso la soglia del piano (**>= 346 deal per B**).
8. Le soglie congelate **nei file prova** le ho applicate **solo a R161a** (sez. 5.2), perche' e' l'unica che ho letto per intero, e di R161a sono riportate **S1-S7, B2 e B5**; **B1 (lettura di merito sull'altopiano), B4 e B6 non sono scritte** *(precisazione del cancello: qui c'era "S1-S7, B1-B6")*. Per gli altri round **[NON COPERTO]** (sez. 9) — in particolare la sentinella S1 di R160a-d/R169/R171 (replica di R103) **non e' giudicata**: gli scarti di K3 sono riportati, non promossi a PASS/FAIL.

---

## 1. INVENTARIO

| cartella | file | con righe | a 0 byte | righe-cella | etichette di round |
|---|---:|---:|---:|---:|---|
| ABTG_GapFill | 24 | 13 | 11 | 76 | r157a, r159a, r167a, r167b, r167c, r167d, r168a, r168b, r168c, r168d, r175a, r178a |
| ABTG_PunteLarry | 24 | 20 | 4 | 140 | r156a, r160a, r160b, r160c, r160d, r160e, r169a, r169b, r169c, r169d, r169e, r169f |
| ABTG_BreakingBand | 10 | 9 | 1 | 47 | r161a, r161b, r174a, r176a, r177a |
| ABTG_EasyTrend | 4 | 4 | 0 | 28 | r171a, r171b |
| ABTG_CostToCost | 6 | 6 | 0 | 52 | r127c, r146a, r146c |
| ABTG_GapContinuation | 2 | 1 | 1 | 9 | r162a |
| ABTG_FiboH4_Multi | 2 | 2 | 0 | 6 | r139c |
| ABTG_PTE | 6 | 5 | 1 | 35 | r153a, r158a, r164a |
| ABTG_SupertrendReversal | 2 | 1 | 1 | 7 | r166a |
| ABTG_SupertrendReversal_Ottimizzato | 2 | 2 | 0 | 14 | r127b |
| **totale** | **82** | **63** | **19** | **414** | **41 round** |

**I 19 file a 0 byte sono tutti la gamba OOS di un round con `@FRAZIONEIS 1.0`** (una tranche sola: la gamba OOS e' vuota per costruzione, classe 395; `RIGA_SOTTILE_ROUND` la scrive `NON MISURATO -- CSV DA 0 BYTE` e chiude con codice 2): GapFill r157a, r159a, r167a-d, r168a-d, r175a (11) · PunteLarry r156a, r160e, r169a, r169c (4) · BreakingBand r161b · GapContinuation r162a · PTE r158a · SupertrendReversal r166a (4). **Verifica**: in tutti e 19 i casi la gamba IS dello stesso round e' presente e **tutte le sue righe hanno Trades > 0** (minimo n=20, GapFill EURUSD; *corretto dal cancello: qui c'era "minimo n=11", che e' la gamba IS di r178a, round senza file vuoti*). Quindi "uscita 2 = NON MISURATO" del runner e' **una lettura del runner sulla sola gamba OOS vuota**: i numeri della gamba IS (= finestra intera) esistono e li leggo come **finestra piena, senza OOS** (etichetta **s.OOS**: non conta come prova di merito, piano 5.2.2).

**r161c (BreakingBand AUDUSD) NON E' nel repo.** Il suo `IS` (3,5 KB) e il suo `OOS` (**0 byte**: `@FRAZIONEIS 1.0`) esistono **solo nell'ARCHIVIO del Desktop del VPS** (`Archivio_2026-09-16_1942\ROUND_r161c\`, `ARCHIVIO\2026-09-19\ROUND_r161c\`, `ARCHIVIO\2026-09-20\ROUND_r161c\`: `CODA_07_desktop_20260917_033003.log` r.20-24, `..._20261003_033003.log` r.716-720 e 1243-1246): il trasporto del 05/10 copia `abtg_round\risultati_prove` e li' non c'era. **Numeri di r161c: NON LEGGIBILI.** Dei 35 round che G4 dichiarava "girati ma non leggibili" (sez. 3-bis G4), **34 sono ora leggibili, 1 (r161c) no**.

---

## 2. TABELLA PER ROUND (41 etichette)

Legenda. **viva IS / viva OOS** = cella viva, formato `PF / n / DD% / profitto` (profitto in valuta del conto, deposito 100k, o 10k per r139c). **SOPRA/SOTTO** = conteggio righe PF>=1 / PF<1 nella gamba. **segno inv.** = numero di valori dell'asse per cui IS e OOS stanno da parti opposte di 1 (su quanti valori dell'asse). **unita'**: `pos` = posizioni, `deal` = deal (parziale acceso, posizioni NON LEGGIBILI). Finestre **[DERIVATO]** (sez. 0 punto 4).

| round | EA simbolo TF | dato, deposito | finestra IS | finestra OOS | asse = viva | celle IS/OOS | viva IS (PF/n/DD/profitto) | viva OOS | SOPRA/SOTTO IS | SOPRA/SOTTO OOS | segno inv. | unita' |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| r127b | SupertrendReversal_Ottimizzato XAUUSD H4 | barre [B], 100k | 2004.06.11-2013.04.06 | 2013.04.07-2026.06.30 | SLLookback=5 | 7/7 | 0,854 / 230 / 6,58 / -3322 | 1,125 / 427 / 5,91 / 3967 | 0 / 7 | 7 / 0 | 7/7 | deal |
| r127c | CostToCost EURJPY H4 | barre [B], 100k | 2020.01.01-2022.08.06 | 2022.08.07-2026.06.30 | MaxBarsHold=100 | 8/8 | 1,177 / 153 / 10,99 / 13369 | 1,523 / 242 / 12,26 / 71284 | 8 / 0 | 8 / 0 | 0/8 | pos |
| r139c | FiboH4_Multi GBPUSD H4 | barre [B], 10k | 1999.01.04-2010.01.01 | 2010.01.02-2026.06.30 | EngulfLookback=8 | 3/3 | 0,792 / 572 / 23,67 / -1941 | 0,968 / 725 / 17,52 / -382 | 0 / 3 | 0 / 3 | 0/3 | deal |
| r146a | CostToCost EURJPY H4 | tick [T], 100k | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | SLBufferATR=0.2 | 9/9 | 1,016 / 48 / 9,93 / 363 | 1,741 / 64 / 9,45 / 22252 | 1 / 8 | 9 / 0 | 8/9 | pos |
| r146c | CostToCost GBPCAD H4 | tick [T], 100k | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | SLBufferATR=0.2 | 9/9 | 1,298 / 44 / 5,11 / 7343 | 1,443 / 62 / 6,19 / 15446 | 9 / 0 | 8 / 1 | 1/9 | pos |
| r153a | PTE GBPUSD H1 | barre [B], 100k | 2000.01.01-2013.03.31 | 2013.04.01-2026.06.30 | AtrExitPeriod=14 | 7/7 | 0,874 / 439 / 11,74 / -6452 | 1,088 / 477 / 9,97 / 4006 | 0 / 7 | 6 / 1 | 6/7 | deal |
| r156a | PunteLarry U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxDaysHold=5 | 7/0 | 1,784 / 54 / 3,96 / 15042 | - | 7 / 0 | - | - | pos |
| r157a | GapFill U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLGapMult=1.0 | 7/0 | 1,376 / 30 / 3,12 / 4596 | - | 7 / 0 | - | - | pos |
| r158a | PTE U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | AtrExitPeriod=14 | 7/0 | 1,170 / 68 / 3,24 / 1779 | - | 5 / 2 | - | - | deal |
| r159a | GapFill U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxHours=48 | 7/0 | 1,376 / 30 / 3,12 / 4596 | - | 6 / 1 | - | - | pos |
| r160a | PunteLarry EURAUD H1 | barre [B], 100k | 2004.06.16-2019.12.31 | 2020.01.01-2026.06.30 | MaxDaysHold=5 | 7/7 | 0,780 / 475 / 40,45 / -39925 | 1,053 / 216 / 17,12 / 4695 | 0 / 7 | 5 / 2 | 5/7 | pos |
| r160b | PunteLarry EURCAD H1 | barre [B], 100k | 1999.08.01-2019.12.31 | 2020.01.01-2026.06.30 | MaxDaysHold=5 | 7/7 | 0,816 / 236 / 18,86 / -13824 | 1,338 / 154 / 6,96 / 14779 | 0 / 7 | 7 / 0 | 7/7 | pos |
| r160c | PunteLarry GBPJPY H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | MaxDaysHold=5 | 7/7 | 1,071 / 364 / 19,55 / 12001 | 1,288 / 139 / 8,95 / 17221 | 6 / 1 | 7 / 0 | 1/7 | pos |
| r160d | PunteLarry GBPUSD H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | MaxDaysHold=5 | 7/7 | 1,102 / 324 / 12,20 / 12818 | 1,041 / 121 / 8,53 / 1364 | 7 / 0 | 7 / 0 | 0/7 | pos |
| r160e | PunteLarry XAUUSD H1 | barre [B], 100k | 2004.06.11-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxDaysHold=5 | 7/0 | 0,872 / 213 / 29,74 / -12461 | - | 0 / 7 | - | - | pos |
| r161a | BreakingBand GBPUSD H1 | barre [B], 100k | 1999.01.04-2012.10.01 | 2012.10.02-2026.06.30 | SL_ATRmult=3.0 | 7/7 | 0,714 / 261 / 21,95 / -17793 | 1,123 / 260 / 10,31 / 7415 | 0 / 7 | 6 / 1 | 6/7 | pos |
| r161b | BreakingBand EURUSD H1 | barre [B], 100k | 1999.01.04-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SL_ATRmult=3.0 | 7/0 | 1,075 / 276 / 8,24 / 4132 | - | 5 / 2 | - | - | pos |
| r162a | GapContinuation 225JPY M1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | PartialTargetR=1.0 | 9/0 | 1,385 / 109 / 11,59 / 11262 | - | 9 / 0 | - | - | deal |
| r164a | PTE GBPUSD H1 | barre [B], 100k | 2000.01.01-2013.03.31 | 2013.04.01-2026.06.30 | AtrExitPeriod=14 | 7/7 | 0,791 / 414 / 20,55 / -15077 | 0,966 / 447 / 17,91 / -2522 | 0 / 7 | 3 / 4 | 3/7 | deal |
| r166a | SupertrendReversal 225JPY H2 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLBufferPips=3 | 7/0 | 1,535 / 79 / 0,71 / 1461 | - | 7 / 0 | - | - | deal |
| r167a | GapFill GBPUSD H1 | barre [B], 100k | 1993.05.11-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLGapMult=1.0 | 7/0 | 1,763 / 21 / 4,02 / 4536 | - | 6 / 1 | - | - | pos |
| r167b | GapFill EURUSD H1 | barre [B], 100k | 1971.01.03-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLGapMult=1.0 | 7/0 | 3,509 / 20 / 1,86 / 5436 | - | 6 / 1 | - | - | pos |
| r167c | GapFill AUDUSD H1 | barre [B], 100k | 1993.04.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLGapMult=1.0 | 7/0 | 2,369 / 25 / 1,87 / 8763 | - | 7 / 0 | - | - | pos |
| r167d | GapFill 225JPY H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLGapMult=1.0 | 7/0 | 1,678 / 26 / 4,59 / 5411 | - | 6 / 1 | - | - | pos |
| r168a | GapFill GBPUSD H1 | barre [B], 100k | 1999.01.04-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxHours=48 | 7/0 | 1,763 / 21 / 4,02 / 4536 | - | 7 / 0 | - | - | pos |
| r168b | GapFill EURUSD H1 | barre [B], 100k | 1999.01.04-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxHours=48 | 7/0 | 3,509 / 20 / 1,86 / 5436 | - | 7 / 0 | - | - | pos |
| r168c | GapFill AUDUSD H1 | barre [B], 100k | 1999.01.04-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxHours=48 | 7/0 | 2,368 / 25 / 1,87 / 8759 | - | 7 / 0 | - | - | pos |
| r168d | GapFill 225JPY H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | MaxHours=48 | 7/0 | 1,678 / 26 / 4,59 / 5411 | - | 7 / 0 | - | - | pos |
| r169a | PunteLarry U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLBufferATR=0.1 | 7/0 | 1,784 / 54 / 3,96 / 15042 | - | 7 / 0 | - | - | pos |
| r169b | PunteLarry EURAUD H1 | barre [B], 100k | 2004.06.16-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferATR=0.1 | 7/7 | 0,780 / 475 / 40,45 / -39925 | 1,053 / 216 / 17,12 / 4695 | 0 / 7 | 3 / 4 | 3/7 | pos |
| r169c | PunteLarry XAUUSD H1 | barre [B], 100k | 2004.06.11-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLBufferATR=0.1 | 7/0 | 0,872 / 213 / 29,74 / -12461 | - | 0 / 7 | - | - | pos |
| r169d | PunteLarry GBPJPY H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferATR=0.1 | 7/7 | 1,071 / 364 / 19,55 / 12001 | 1,288 / 139 / 8,95 / 17221 | 7 / 0 | 7 / 0 | 0/7 | pos |
| r169e | PunteLarry GBPUSD H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferATR=0.1 | 7/7 | 1,102 / 324 / 12,20 / 12818 | 1,041 / 121 / 8,53 / 1364 | 7 / 0 | 5 / 2 | 2/7 | pos |
| r169f | PunteLarry EURCAD H1 | barre [B], 100k | 1999.08.01-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferATR=0.1 | 7/7 | 0,816 / 236 / 18,86 / -13824 | 1,338 / 154 / 6,96 / 14779 | 0 / 7 | 7 / 0 | 7/7 | pos |
| r171a | EasyTrend CHFJPY H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferPts=30 | 7/7 | 0,824 / 338 / 34,81 / -31527 | 1,066 / 265 / 21,80 / 9598 | 0 / 7 | 7 / 0 | 7/7 | pos |
| r171b | EasyTrend GBPUSD H1 | barre [B], 100k | 1999.01.01-2019.12.31 | 2020.01.01-2026.06.30 | SLBufferPts=30 | 7/7 | 1,184 / 583 / 14,68 / 85195 | 1,053 / 254 / 15,84 / 7640 | 7 / 0 | 7 / 0 | 0/7 | pos |
| r174a | BreakingBand GBPUSD H1 | barre [B], 100k | 1999.01.04-2012.10.01 | 2012.10.02-2026.06.30 | BEMode=0 | 2/2 | 0,714 / 261 / 21,95 / -17793 | 1,123 / 260 / 10,31 / 7415 | 0 / 2 | 2 / 0 | 2/2 | pos |
| r175a | GapFill U30USD H1 | tick [T], 100k | 2024.09.26-2026.06.30 (intera) | nessuna (FrazioneIS 1,0; file OOS = 0 byte) | SLMode=0 | 2/0 | 1,376 / 30 / 3,12 / 4596 | - | 2 / 0 | - | - | pos |
| r176a | BreakingBand GBPUSD H1 | barre [B], 100k | 1999.01.04-2012.10.01 | 2012.10.02-2026.06.30 | BEatATR=1.0 | 6/6 | 0,714 / 261 / 21,95 / -17793 | 1,123 / 260 / 10,31 / 7415 | 0 / 6 | 6 / 0 | 6/6 | pos |
| r177a | BreakingBand GBPUSD H1 | barre [B], 100k | 1999.01.04-2012.10.01 | 2012.10.02-2026.06.30 | TPRefreshBars=1 | 5/5 | 0,714 / 261 / 21,95 / -17793 | 1,123 / 260 / 10,31 / 7415 | 0 / 5 | 5 / 0 | 5/5 | pos |
| r178a | GapFill 225JPY H1 | tick [T], 100k | 2024.09.26-2025.06.09 | 2025.06.10-2026.06.30 | SLMode=0 | 2/2 | 3,204 / 11 / 1,33 / 4573 | 1,144 / 15 / 4,36 / 812 | 2 / 0 | 2 / 0 | 0/2 | pos |

**Letture dirette dalla tabella (tutte ricalcolate):**
- **Round a finestra intera (FrazioneIS 1,0)**: 19 su 41 (r156a, r157a, r158a, r159a, r160e, r161b, r162a, r166a, r167a-d, r168a-d, r169a, r169c, r175a): hanno **solo IS**, nessun OOS (le righe SOPRA/SOTTO sono su finestra piena).
- **Round con IS e OOS veri**: 22 (r127b, r127c, r139c, r146a, r146c, r153a, r160a-d, r161a, r164a, r169b, r169d-f, r171a, r171b, r174a, r176a, r177a, r178a). **Di questi, 10 (r160a-d, r169b, r169d-f, r171a, r171b) hanno un OOS che e' per costruzione la finestra di R103** (il file prova sceglie `@FRAZIONEIS 0.7637/0.7586/0.7052` "perche' l'OOS coincida con la finestra R103": `R160c` r.73-80): quella gamba e' la **replica dell'ancora**, non un fuori campione nuovo (sez. 3 K3, D9). La prova nuova di quei round e' **solo la gamba IS 1999/2004-2019**.
- **Tick [T]**: 13 round (r146a, r146c, r156a, r157a, r158a, r159a, r162a, r166a, r167d, r168d, r169a, r175a, r178a); **barre [B]**: 28.
- **Nessuna cella a tick ha n >= 150 posizioni** (massimo a tick: GapContinuation 124 deal, PunteLarry U30USD 73 pos, PTE U30USD 70 deal, C2C GBPCAD 66 pos). Le celle con n>=150 sono **tutte [B]**, cioe' **screening**.

---

## 3. CONTROLLI DI COERENZA E DIFFERENZE FRA REFERTO E CSV

| # | controllo | esito |
|---|---|---|
| K1 | **Log del runner vs CSV, r162a** (`RIGA_SOTTILE_ROUND_20260916_033005.log`: 9 righe IS, OOS 0 byte) e **r178a** (3 notti: 18, 19, 20/09, 2 righe IS + 2 OOS ogni notte) | **IDENTICI** riga per riga a Profit, PF, DD, Trades (programmatico, tolleranza sull'ultima cifra stampata). **r178a e' deterministico su 3 notti**. L'unica altra fonte di referto con numeri per i miei round e' questa: gli altri `REFERTO_ROUND_rNNN.txt` stanno solo nello zip sul Desktop del VPS (**NON LEGGIBILI**) |
| K2 | **r146a / r146c (tick) vs r41 (13/08, in repo)**: stessa cella viva (SLBufferATR=0,2) | **IDENTICI al centesimo**: EURJPY IS 362,80 / 1,01642 / 9,9258 / n48, OOS 22.252,20 / 1,74084 / 9,4547 / n64; GBPCAD IS 7.343,23 / 1,29824 / 5,1098 / n44, OOS 15.446,36 / 1,44312 / 6,1856 / n62. Il file `r41` **non ha il suffisso `_ohlc`**: e' tick. **Conseguenza**: i numeri R40/R41 che G4 ha etichettato `[B]` (G4 tab. 2a, 2e-2i; consolidato riga 56) sono **tick `[T]`** (sez. 8, S1) |
| K3 | **Gamba OOS dei round PunteLarry (r160a-d, r169b/d/e/f) e EasyTrend (r171a/b) vs R103 (6,5 anni, in G4 6h/3g)**: finestra calcolata 2020.01.01-2026.06.30 = la finestra di R103 | n e DD **uguali**: GBPJPY 139 / 8,95; EURCAD 154 / 6,96; EURAUD 216 / 17,12; GBPUSD short 121 / 8,53; EZ CHFJPY 265 / 21,80. **PF vicino ma non identico**: Larry GBPUSD CSV **1,041** vs G4 "1,05"; EZ GBPUSD CSV **1,053** (n254, DD **15,84**) vs G4 "1,059 (254, 15,77%)". Differenza 0,006-0,009 sul PF e 0,07 sul DD, **causa NON DIMOSTRATA** (versione dell'EA o del driver fra 24/08 e 16-20/09). **L'OOS di questi round NON e' un OOS indipendente rispetto a R103**: e' la stessa finestra e la stessa cella. La parte **nuova** e' la gamba IS, 1999-2019 |
| K4 | **BreakingBand EURUSD r161b (intera 1999-2026) vs R102 Blocco 1** (G4 1i) | cella viva **1,075 / n276 / DD 8,24 / +4.132** = G4 (1,075 / 276 / 8,24%): **IDENTICA** |
| K5 | **BreakingBand GBPUSD r161a: n(IS)+n(OOS) a SL 3,0 vs 522 di R102** | 261 + 260 = **521** (S1 del file prova: banda 480-560: **PASS**; "a meno della singola operazione tagliata dalla cucitura") |
| K6 | **PunteLarry XAUUSD r160e/r169c (intera 2004-2026) vs R100** | n **213** e DD **29,74%** = G4 ("n213, 29,74% @1%"): **IDENTICI**. **Nuovo: il PF, che G4 dichiarava "non pubblicato": 0,872** (profitto -12.461) |
| K7 | **GapFill 225JPY: r178a (IS 11 + OOS 15) vs r167d/r168d (intera, stessa cella SLMode 0, fill 75)** | n 11+15 = **26** = n della finestra intera (26): **coerente**. r178a OOS pass 0 = **+811,56 / PF 1,14398 / DD 4,3639 / n15** = G4 4.5 (R65 par.4-quater): **IDENTICO** |
| K8 | **GapFill U30USD r157a (intera, n30) vs G4 WF R36 (OOS n20 + IS n10)** | 20+10 = **30**: coerente |
| K9 | **GapFill forex: stessa cella su finestra 1971/1993 (r167) e 1999 (r168)** | n e profitto **uguali** (EURUSD fill 50: 20 trade, +5.436,31 in entrambe le finestre di partenza 1971 e 1999; GBPUSD 21 trade, 4.536,29 vs 4.536,24; AUDUSD 25 trade, 8.763,38 vs 8.759,22): **nessuna operazione prima del 1999** (non distinguo "nessun dato" da "nessun gap": **NON DISTINGUIBILE** dai CSV) |
| K10 | **FiboH4_Multi r139c: due versioni dello stesso file** (git: 13/09 `7b329f7e`/`31423aaa`; 05/10 `81122ecd`/`df6ad32c`) | **I NUMERI SONO CAMBIATI** (n uguale): IS PF 0,79807/0,79400/0,83078 (13/09) -> **0,79245/0,79088/0,82965** (05/10), DD 23,33/22,60/20,70 -> 23,67/22,81/20,62; OOS PF 0,97210/0,94208/0,95046 -> **0,96776/0,93861/0,94782**, DD 17,29/17,70/17,21 -> 17,52/17,87/17,39. Il runner ha **rigirato** r139c dopo il 13/09 (compare nei referti 14-20/09) e l'intestazione dei log `RIGA_SOTTILE_ROUND_2026091x` ("AVVERTENZA DICHIARATA") dice che il driver prende l'EA dalla **testa del ramo**, non dal pin. Il G4 ha usato la versione vecchia (0,972/0,942/0,950). **Nessun segno cambia** (6/6 celle SOTTO prima e dopo) |
| K11 | **r127c IS (AGGIORNATO) e r127b IS/OOS (AGGIORNATI) vs versione 13/09 in git** | **stessi valori**, cambia solo l'ordine delle righe: la riscrittura del 05/10 e' innocua |
| K12 | **PTE r153a/r164a (OOS 2013.04-2026.06) vs G3 4.7 (R78, stessa finestra)** | n **uguale** (477 deal; 447 deal); PF **-0,007 / -0,006** (1,0876 vs 1,095; 0,966 vs 0,972), DD **+0,10 / +0,23** (9,97 vs 9,87; 17,91 vs 17,68), profitto +4.006 vs +4.323 e -2.522 vs -2.125. **Causa NON DIMOSTRATA** (R78 e' un round precedente, deposito/EA possibilmente diversi) |
| K13 | **GapContinuation r162a: DD della finestra intera vs DD dell'unica passata OOS di R65** | **11,589 vs 11,59**: uguale. Con n=109 deal intera contro 70 deal OOS (R65): la parte IS (2024.09.26-2025.06.09) pesa 39 deal **[DERIVATO]**, PF IS **~1,35 [DERIVATO da GP/GL, additivita' approssimata: i lotti dipendono dal saldo]** |

---

## 4. SCHEDE BREVI PER EA (numeri dai CSV; classe per cella; casella del certificato)

Formato `PF / n / DD% / profitto`. "Viva" = cella viva (sez. 0 punto 3). Il dettaglio di tutte le 414 righe e' nell'**Appendice A**.

### 4.1 ABTG_BreakingBand (H1, [B], 100k, 1%) - round r161a, r161b, r174a, r176a, r177a (r161c NON LEGGIBILE)
- **GBPUSD pattern 2 (sedia 772161)**, finestra 1999.01.04-2026.06.30 spezzata a meta' (FrazioneIS 0,50): **IS 1999.01.04-2012.10.01**, **OOS 2012.10.02-2026.06.30** `[DERIVATO]`. Viva: **IS 0,714 / 261 / 21,95 / -17.793; OOS 1,123 / 260 / 10,31 / +7.415**.
- **Quattro assi di uscita letti sullo stesso simbolo (20 celle per gamba)**: `InpSL_ATRmult` 1,5-4,5 (7), `InpBEMode` 0/1 (2), `InpBEatATR` 0-2,5 (6), `InpTPRefreshBars` 0-4 (5). **IS: 20 celle su 20 SOTTO** (PF 0,665-0,755, DD 16,05-36,11%). **OOS: 19 su 20 SOPRA** (PF 1,031-1,167; unica SOTTO: SL 1,5 = 0,953), DD 7,79-20,69%. **n identico in tutte le celle** (261 IS / 260 OOS): la catena C3 che il file prova di R161a si aspettava (n diverso lungo l'asse) **non si manifesta**.
- **Asse SL (OOS)**: PF 0,953 / 1,031 / 1,095 / **1,123** / 1,059 / 1,161 / 1,152 con DD 20,69 / 18,63 / 13,11 / **10,31** / 9,79 / 7,79 / 7,91. **Il DD scende (quasi monotono) con lo stop piu' largo** in entrambe le gambe (IS 36,11 -> 16,05 con un'unica risalita, 2,5 = 21,84 -> 3,0 = 21,95; OOS 20,69 -> 7,79 con un'unica risalita, 4,0 = 7,79 -> 4,5 = 7,91). **In IS nessuna cella d'uscita porta il PF sopra 1 (20/20 SOTTO); in OOS l'uscita cambia il segno in 1 cella su 20 (SL 1,5 = 0,953)** e su EURUSD in 2 su 7 (SL 1,5 e 2,0). Il passaggio IS->OOS inverte 6 valori su 7 dell'asse SL. *(Corretto dal cancello: qui c'era "il segno non cambia mai con l'uscita", smentito dalle tre celle citate.)*
- **EURUSD pattern 0 (772162), finestra intera 1999-2026, s.OOS**: viva **1,075 / 276 / 8,24 / +4.132** (= R102). Asse SL: 1,5 **0,822** (DD 28,44) · 2,0 **0,942** (17,05) · 2,5 1,072 · **3,0 1,075** · 3,5 1,057 · 4,0 1,070 · 4,5 1,004. 5 SOPRA / 2 SOTTO; la viva sta nell'altopiano 2,5-4,0 (PF 1,057-1,075).
- **Ricostruzione 27,5 anni GBPUSD [DERIVATO]** sommando GP e GL delle due gambe (ogni gamba riparte da 100k, quindi non e' una misura): PF ~0,915, profitto ~-10.378, n 521 contro R102 **0,897 / -11.574 / 522**.
- **Sentinelle congelate di R161a lette sul CSV (sez. 5.1)**: S1 PASS (521), S2 PASS (261/260 >= 150), S3 PASS (7 righe/CSV), S4 PASS (7 valori), S5 PASS (n SL 1,5 = n SL 2,0), S6 PASS, **S7 NON PASSA nella gamba IS (DD 36,11% > 35,0% alla cella SL 1,5)**; celle con DD > 10%: **IS 7 su 7, OOS 4 su 7** (viva inclusa, 10,31%).
- **Classe**: GBPUSD viva = **SOTTO in IS 1999-2012 (n261, B-scr) / SOPRA in OOS 2012-2026 (n260, B-scr) = SEGNO INVERTITO**; EURUSD = SOPRA formale s.OOS (n276 su finestra intera **senza OOS**: lettera B non applicabile, il piano 5.4 la chiede sull'n OOS *(corretto dal cancello: c'era "B-scr")*). Regimi dentro la finestra (crisi 2008 in IS; covid 2020, orso 2022 in OOS): **NON separati** nei CSV = NON MISURATO. AUDUSD: NON LEGGIBILE.
- **Certificato (5 caselle, per le celle SOTTO)**: (1) PF si (2) n e DD si (3) **uscita ad asse: LETTA** (4 assi, GBPUSD; EURUSD solo SL; AUDUSD NON LEGGIBILE; `InpTPMode=1` e il TP mai) (4) gemelli si (G4: 7 simboli + 48 di scan) (5) TF si (M15, M30, H1, H4: G4 R3) -> con questi CSV **la casella 3, che G4 teneva "misurata ma illeggibile", si chiude A LIVELLO DI EA** (regola 09/09 alla lettera). **Per cella no**: l'uscita e' stata messa ad asse **solo su H1 GBPUSD (4 assi) e H1 EURUSD (SL)**; le celle SOTTO di M15/M30 e di AUDUSD **non hanno un asse d'uscita girato su di loro** e per quelle la casella 3 resta aperta *(precisazione del cancello)*.

### 4.2 ABTG_CostToCost (H4, long) - round r127c [B], r146a [T], r146c [T]
- **r127c** EURJPY `exit 2`, [B], 2020.01.01-2022.08.06 / 2022.08.07-2026.06.30: IS **8/8 SOPRA** (1,148-1,220; n153-161; DD 10,99-12,17), OOS **8/8 SOPRA** (1,452-1,524; n242-257; DD 12,25-12,26). Viva (100): **IS 1,177 / 153 / 10,99 / +13.369; OOS 1,523 / 242 / 12,26 / +71.284**, peggior giornata **-4,216% IS / -8,016% OOS**. `InpMaxBarsHold` **inerte da 75 a 200** (6 righe su 8 identiche). = G4 2b: **nessuna differenza**.
- **r146a** EURJPY `exit 2`, **tick [T]**, IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30, asse `InpSLBufferATR` 0,0-0,8 (9): **IS 1 su 9 SOPRA** (solo la viva 0,2: **1,016 / 48 / 9,93 / +363**, vicine 0,1 = **0,773** e 0,3 = **0,940**: cella isolata), **OOS 9 su 9 SOPRA** (1,741-2,106; n62-64; DD 5,68-12,11). **8 valori su 9 invertiti IS->OOS**. Viva OOS **1,741 / 64 / 9,45 / +22.252**: e' la **piu' bassa** delle 9 celle OOS. Il buffer alza lo stop e **abbassa il DD in entrambe le gambe** (IS 14,74 -> 6,91; OOS 12,11 -> 5,68; peggior giornata OOS a 0,0 **-6,73%**, a 0,8 **-2,51%**; viva IS -3,74%, OOS -4,00%).
- **r146c** GBPCAD `exit 1`, tick, stesse finestre: **IS 9/9 SOPRA** (1,015-1,298; n39-47; DD 5,07-6,97), **OOS 8/9 SOPRA** (0,920-1,466; n47-66; DD 6,19-9,95). Viva **IS 1,298 / 44 / 5,11 / +7.343; OOS 1,443 / 62 / 6,19 / +15.446**. L'unica SOTTO e' **SLBuffer 0,8 in OOS (0,920, DD 9,95)** mentre in IS la stessa cella e' **1,095**: inversione **nel verso opposto** (SOPRA -> SOTTO).
- **Classe**: EURJPY viva = SOPRA formale (IS 1,016 e' indistinguibile da 1) / SOPRA OOS; **dato tick per r146 (non barre)**; n IS 48, OOS 64 = C. r127c = B-scr (n242). GBPCAD tick = SOPRA C (WF corto) (G4: SOTTO a 6,5 anni [B], 0,92 n382 DD 41,5%: **non in questi CSV**).
- **Certificato**: (1)(2) si (3) **uscita: SLBufferATR a tick letto su 2 simboli + MaxBarsHold [B]** (+ ExitMode in scan G4) -> **si chiude a livello di EA** (4) si (48) (5) si (H1, H4). **Non 5/5 sulle singole celle SOTTO di G4** *(corretto dal cancello: qui c'era "5/5 sulle celle SOTTO di G4")*: l'uscita e' stata messa ad asse **solo su EURJPY long (tick e [B]) e GBPCAD long (tick 21 mesi)**; sulle celle SOTTO **short (0,112), L+S (0,770), CHFJPY, XAG e GBPCAD 6,5 anni [B]** nessun asse d'uscita e' stato girato su QUELLA cella -> per loro la casella 3 resta aperta.

### 4.3 ABTG_EasyTrend (H1, L+S, TP 1,5R, [B]) - round r171a (CHFJPY), r171b (GBPUSD)
- IS **1999.01.01-2019.12.31**, OOS **2020.01.01-2026.06.30** `[DERIVATO]`; asse `InpSLBufferPts` 0-90 (7).
- **CHFJPY**: **IS 0/7 SOPRA** (0,811-0,839; n323-342; DD 31,99-36,19%; profitto -27.638/-32.989) -> **OOS 7/7 SOPRA** (1,002-1,122; n256-271; DD 18,85-21,80). Viva (30): **IS 0,824 / 338 / 34,81 / -31.527; OOS 1,066 / 265 / 21,80 / +9.598**. **Segno invertito 7/7**. Nel round **tutte e 14 le celle hanno DD > 18%**.
- **GBPUSD**: **IS 7/7 SOPRA** (1,158-1,224; n574-589; DD 14,68-17,66; profitto +70.102/+112.089), **OOS 7/7 SOPRA** (1,053-1,090; n241-261; DD 14,68-15,84). Viva (30): **IS 1,184 / 583 / 14,68 / +85.195; OOS 1,053 / 254 / 15,84 / +7.640**. Nessuna inversione; il PF scende da 1,18 a 1,05.
- **Classe**: GBPUSD SOPRA in entrambe le gambe, n >= 150 in entrambe, [B]: **B-scr**, ma **DD > 14% in 14/14 celle** a rischio 1% (nessuna cella sotto il muro del 10%); CHFJPY **SOTTO in IS / SOPRA in OOS (inversione)**, DD 22-35%. Regimi: NON separati. **La gamba OOS 2020-2026 e' la finestra di R103 (K3): e' la replica dell'ancora, non un OOS indipendente; la lettura nuova e' la gamba IS 1999-2019** *(precisazione del cancello)*.
- **Certificato**: (3) **SLBufferPts letto** (+ `InpTP_R` di R48) -> si; **(5) TF: H1 e basta -> APERTA**. Resta **NON ANCORA MISURATO sul TF** (invariato rispetto a G4).

### 4.4 ABTG_GapFill (H1) - round r157a, r159a, r175a (U30USD), r167d, r168d, r178a (225JPY), r167a-c, r168a-c (forex)
- **Finestra intera, senza OOS (s.OOS)** in 11 round su 12; solo **r178a** ha IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30. **n per cella: 20-30 sulle finestre intere, 11 (IS) e 15 (OOS) in r178a**; nessuna cella con Trades=0.
- **Cella viva per simbolo (finestra intera)**: GBPUSD fill100 (**1,763 / 21 / 4,02 / +4.536**, [B] 1999-2026) · EURUSD fill50 (**3,509 / 20 / 1,86 / +5.436**, [B]) · AUDUSD fill100 (**2,369 / 25 / 1,87 / +8.763**, [B]) · 225JPY fill75 (**1,678 / 26 / 4,59 / +5.411**, tick 21 mesi) · U30USD fill100 (**1,376 / 30 / 3,12 / +4.596**, tick 21 mesi). r178a: IS **3,204 / 11 / 1,33 / +4.573**, OOS **1,144 / 15 / 4,36 / +812**.
- **Asse stop `InpSLGapMult` 0,4-2,2** (5 simboli x 7 = 35 celle): **SOTTO 3 celle, tutte a 0,4** (GBPUSD **0,452**, DD 12,30; EURUSD **0,685**, DD 7,70; 225JPY **0,606**, DD 9,09); EURUSD a 0,7 e' 1,006 (sul filo); AUDUSD e U30USD a 0,4 sono SOPRA (1,618; 1,237). **Da 1,0 in su 25 celle su 25 SOPRA** (5 valori x 5 simboli; minimo 1,329). EURUSD sale da 3,509 (1,0) a 6,29 (2,2) con DD 1,86 -> 0,92.
- **Asse time-stop `InpMaxHours` 12-84** (35 celle): **solo U30USD a 12 h e' SOTTO (0,837)**; da 24 h in su **30/30 SOPRA** (minimo 1,376). Da 60 h (GBPUSD, 225JPY, U30USD) o da 48 h (EURUSD, AUDUSD) le celle sono **identiche fra loro**: il time-stop non morde oltre. Rispetto alla viva (48 h), **sul PF**, **36 h e' migliore su 5/5 simboli**; **24 h su 4/5** (non su EURUSD: 2,906 contro 3,509).
- **Asse `InpSLMode` 0/1**: U30USD (intera) PF 1,376 -> **1,666**, DD 3,12 -> **1,79**; 225JPY IS 3,204 -> 2,514 e **OOS 1,144 -> 1,002 (profitto +812 -> +5), DD 4,36 -> 2,30**: i due simboli **non vanno nella stessa direzione**.
- **SOTTO totali: 4 celle su 76** (le tre `SLGapMult` 0,4 e `MaxHours` 12 U30USD). **Tutte le altre sono SOPRA, ma tutte su n 11-30 e (salvo r178a) senza OOS: D** (piano 5.4; U30USD n30 e' C al limite).
- **Frequenza**: forex 20-25 trade in **27,5 anni** per simbolo (0,73-0,91/anno); sottraendo le operazioni di R103 (2020-2026, G4: AUDUSD 17, GBPUSD 13, EURUSD 14) restano **8 (AUDUSD) / 8 (GBPUSD) / 6 (EURUSD)** prima del 2020 `[DERIVATO]`. Indici 21 mesi: 26-30 (15-17/anno). **n >= 150 non e' raggiungibile con la storia disponibile** (vedi sez. 8 S2).
- **Certificato**: (3) **SLGapMult, MaxHours, SLMode letti** + FillPct (G4) -> **si chiude**; (4) si (10); **(5) TF: H1 e basta (28 CSV G4 + questi) -> APERTA**. Resta NON ANCORA MISURATO **solo per il TF**.

### 4.5 ABTG_GapContinuation (225JPY M1, tick, 100k, 1%) - round r162a
- Finestra intera 2024.09.26-2026.06.30 (FrazioneIS 1,0), asse `InpPartialTargetR` 0,50-2,50 (9), `InpPartialClosePercent=40`: **9 su 9 SOPRA**, PF 1,269-1,582, **n 84-124 deal** (decresce al crescere dell'asse), DD 6,94-12,78%, profitto +8.928/+13.108. Viva (1,00): **1,385 / 109 / 11,59 / +11.262**, peggior giornata -1,05%. Il massimo (PF 1,582, DD **6,94%**) sta **sul bordo basso dell'asse (0,50)**; DD > 10% in **8 celle su 9**.
- **Lati**: `InpEnableBuyGaps` e `InpEnableSellGaps` entrambi 1 (gap minimo 1,00 e rischio 1% su entrambi): **la cella include il lato short** che in R65 perdeva (-2.182 su 20 pos, G4); il CSV non separa i lati (NON LEGGIBILE per lato).
- **Classe**: SOPRA s.OOS, **C** (109 deal -> posizioni NON LEGGIBILI, >= 47 se fattore 2,31). Il numero **IS a tick** che G4 dava "non misurato" **non e' leggibile separatamente** (nessuna gamba IS/OOS): [DERIVATO] ~1,35 / 39 deal sottraendo la passata OOS di R65 (sez. 3 K13).
- **Certificato**: (3) **PartialTargetR letto** (+ FinalTargetR G4) -> si; **(4) gemelli: nessuno; (5) TF: M1 e basta -> APERTE**.

### 4.6 ABTG_PunteLarry (H1, [B] salvo U30USD [T]) - round r156a, r169a (U30USD), r160a-e, r169b-f
Assi: `InpMaxDaysHold` 1-13 (r156a, r160a-e) e `InpSLBufferATR` 0,00-0,30 (r169a-f), 7 celle ciascuno. Finestre: U30USD intera 2024.09.26-2026.06.30; XAUUSD intera 2004.06.11-2026.06.30; EURAUD IS 2004.06.16-2019.12.31; EURCAD IS 1999.08.01-2019.12.31; GBPJPY e GBPUSD IS 1999.01.01-2019.12.31; **OOS 2020.01.01-2026.06.30 per tutti e quattro (= finestra di R103, sez. 3 K3)** `[DERIVATO]`.

| simbolo, lato, uscita | IS (SOPRA/SOTTO, PF, n, DD%) | OOS (SOPRA/SOTTO, PF, n, DD%) | viva IS -> OOS (PF / n / DD%) |
|---|---|---|---|
| U30USD L+S, R-based (772341), **tick** | intera: 14/0; 1,192-1,966; n41-73; 3,55-6,71 | - | 1,784 / 54 / 3,96 |
| EURAUD L+S, R-based (772342) | **0/14**; 0,748-0,895; n383-620; DD 28,09-40,45 | 8/6 (r160a 5/2, r169b 3/4); 0,922-1,138; n171-306; 9,70-20,97 | **0,780 / 475 / 40,45 -> 1,053 / 216 / 17,12** |
| XAUUSD long, libro, R-based (772343) | intera 2004-2026: **0/14**; 0,756-0,948; n205-217; **DD 25,98-37,03** | - | **0,872 / 213 / 29,74** (-12.461) |
| GBPJPY long, R-based (772344) | 13/1; 0,976-1,103; n326-402; 11,05-19,75 | 14/0; 1,170-1,302; n120-158; 7,79-12,38 | 1,071 / 364 / 19,55 -> 1,288 / 139 / 8,95 |
| GBPUSD short, libro, FPO (772345) | 14/0; 1,087-1,242; n322-327; 7,88-12,52 | 12/2 (r160d 7/0, r169e 5/2); 0,927-1,083; n119-123; 6,73-9,37 | 1,102 / 324 / 12,20 -> 1,041 / 121 / 8,53 |
| EURCAD long, FPO (772346) | **0/14**; 0,816-0,849; n234-244; DD 14,93-19,66 | 14/0; 1,172-1,416; n149-157; 6,34-7,90 | **0,816 / 236 / 18,86 -> 1,338 / 154 / 6,96** |

- **Lettura nei due versi**: SOPRA 89 celle, SOTTO 51 (su 140). Le **SOTTO sono concentrate in 3 oggetti**: EURAUD IS (14), EURCAD IS (14), **XAUUSD intera (14)**; piu' 8 celle OOS (EURAUD 6, GBPUSD 2) e 1 IS (GBPJPY).
- **Segno invertito IS->OOS sulla cella viva: EURAUD e EURCAD** (7/7 su EURCAD; 5/7 e 3/7 su EURAUD). **GBPJPY e GBPUSD non invertono**: GBPUSD **cala** (1,10 -> 1,04, OOS n121 < 150: C), GBPJPY **sale** (1,07 -> 1,29, OOS n139 < 150: C).
- **XAUUSD long: la cella che G4 teneva "SOPRA D" su tick WF (n11, PF 4,233) e' SOTTO su 22 anni [B] in 14 celle su 14** (n213, DD 29,74% a 1%). **G4 dichiarava "PF non pubblicato": e' 0,872.**
- **Rischio vecchio (emendamento B) a 1%, cella viva**: DD IS **40,45%** (EURAUD), **29,74%** (XAU, finestra intera), **19,55%** (GBPJPY), **18,86%** (EURCAD), **12,20%** (GBPUSD): **la cella viva di nessuna delle 5 sedie [B] sta sotto il 10% nella finestra vecchia**.
- **Classe OOS** (n posizioni): EURAUD 216 e EURCAD 154 = **B-scr**; GBPJPY 139, GBPUSD 121 = **C-scr**; U30USD 54 (tick, s.OOS) = **C**. ⚠️ **La lettera dice solo quante posizioni ci sono**: queste gambe OOS sono **la finestra e la cella di R103** (K3, scelta dichiarata in `R160c` r.73-80) e contengono anche la finestra 2024-2026 dei WF a tick su cui le celle vive sono state lette (D9): **non sono una prova fuori campione nuova** e non vanno contate come conferma indipendente di R103 *(precisazione del cancello)*.
- **Certificato**: (3) **MaxDaysHold e SLBufferATR letti su 6 simboli** (+ tipo R/FPO in scan G4) -> **si chiude**; (4) si (48); **(5) TF: H1 e basta -> APERTA**. XAU/EURAUD/EURCAD restano NON ANCORA MISURATO per il TF.

### 4.7 ABTG_FiboH4_Multi (GBPUSD singolo H4, [B], **10k**, 1%) - round r139c
- IS 1999.01.04-2010.01.01, OOS 2010.01.02-2026.06.30 (FrazioneIS 0,40), asse `InpEngulfLookback` 8/12/16 (= **asse d'ingresso**, non d'uscita). **IS 0/3 SOPRA** (0,792 / 0,791 / 0,830; n572/548/557 deal; DD 23,67/22,81/20,62), **OOS 0/3 SOPRA** (0,968 / 0,939 / 0,948; n725/729/737 deal; DD 17,52/17,87/17,39; profitto -382/-730/-629 a 10k). **6/6 SOTTO in entrambe le gambe, nessuna inversione.**
- **I numeri sono la versione del 05/10, diversa da quella che ha letto G4** (sez. 3 K10). **Classe SOTTO, B-scr** (n >= 346 deal in 6/6 celle). **Certificato invariato**: (3) l'unico asse e' l'ingresso -> APERTA; (5) H4 e basta -> APERTA.

### 4.8 ABTG_PTE (H1) - round r153a (771332: buf 25 / TP2 3), r164a (771322: buf 5 / TP2 2), r158a (U30USD 771321, tick)
- GBPUSD [B], IS 2000.01.01-2013.03.31, OOS 2013.04.01-2026.06.30 (FrazioneIS 0,50), asse `InpAtrExitPeriod` 2-26 (7), n in **deal** (`InpTP1Pct=50`).
- **r153a**: IS **0/7 SOPRA** (0,822-0,888; n435-449; DD 9,48-12,94), OOS **6/7 SOPRA** (0,963-1,328; n472-486; DD 6,71-11,51). Viva (14): **IS 0,874 / 439 / 11,74 / -6.452; OOS 1,088 / 477 / 9,97 / +4.006**: **segno invertito** (6/7). Il massimo OOS e' a **10** (1,328) e a **6** (1,297).
- **r164a** (sedia viva 771322): IS **0/7** (0,706-0,806; n408-424; DD 20,55-22,92), OOS **3/7** (2: 1,085; 6: 1,135; 10: 1,103; **14-26: 0,966 / 0,980 / 0,948 / 0,946**). Viva (14): **IS 0,791 / 414 / 20,55 / -15.077; OOS 0,966 / 447 / 17,91 / -2.522**: **SOTTO in entrambe le gambe, 13+13 anni**.
- **r158a** U30USD tick intera 2024.09.26-2026.06.30 (771321): **5/7 SOPRA** (0,932-1,444; n66-70 deal; DD 3,00-3,62); viva (14) **1,170 / 68 / 3,24 / +1.779**; SOTTO a 2 (0,980) e 18 (0,932).
- **Classe**: r153a/r164a OOS **B-scr** (n >= 346 deal); r158a **C/D** (68 deal: posizioni NON LEGGIBILI, 30-68).
- **Certificato** (G3: 5/5 su dato [B]): l'asse `AtrExitPeriod` **non era nell'elenco di G3**: ora e' letto su 3 sedie; **nessuna casella cambia**. Differenze con G3: sez. 3 K12.

### 4.9 ABTG_SupertrendReversal (225JPY H2, tick, 100k, **0,65%**) - round r166a
- Finestra intera 2024.09.26-2026.06.30, asse `InpSLBufferPips` 3-423 (7), `InpTP1Pct=50`: **7/7 SOPRA**, PF 1,434-1,848, **n 79-89 deal**, DD **0,29-0,77%**, profitto +937/+1.461. Viva (3): **1,535 / 79 / 0,71 / +1.461**. PF massimo 1,848 a 353; DD minimo 0,29% a 423.
- **Scala dei P/L**: profitto +1,46% in 21 mesi a rischio 0,65% per trade, DD < 1%: **la scala e' quella delle corse R5 del Nikkei** (profitti dell'ordine di 1.000 su 100k nei `risultati_prove/ABTG_SupertrendReversal/*_225JPY_*_r5.csv`, es. OOS r5 +1.099; sizing noto, G5 scheda 1.1 punto 11(e)). **Il DD% assoluto non e' confrontabile con gli altri simboli; PF e n si.** Perche' la scala sia quella: **NON VERIFICATO**.
- **Classe**: SOPRA s.OOS, **C** (posizioni >= 34). G5 la dava **NM ("nessun CSV in repo")**: ora esiste.

### 4.10 ABTG_SupertrendReversal_Ottimizzato (XAUUSD H4, [B], 100k, 1%) - round r127b
- IS 2004.06.11-2013.04.06 **0/7 SOPRA** (0,792-0,855; n230 deal; DD 6,50-10,24), OOS 2013.04.07-2026.06.30 **7/7 SOPRA** (1,053-1,125; n426-427 deal; DD 5,91-8,43). Viva (5): **IS 0,854 / 230 / 6,58 / -3.322; OOS 1,125 / 427 / 5,91 / +3.967**; segno invertito 7/7. **Valori identici alla versione del 13/09 e a G5 U05** (sez. 3 K11): **nessun cambio**.

---

## 5. LE DUE LETTURE CHE CHIUDONO UNA DOMANDA APERTA

### 5.1 Segno invertito IS -> OOS (classe S4 "regime, non edge"): dove e come
- **Cella viva da SOTTO (IS) a SOPRA (OOS)**: **6 oggetti unici** (BB GBPUSD pattern 2; PunteLarry EURAUD; PunteLarry EURCAD; EZ CHFJPY; PTE 771332; SupRev Ott XAUUSD H4), che compaiono in **11 round** (r127b, r153a, r160a, r160b, r161a, r169b, r169f, r171a, r174a, r176a, r177a). In questi 11 round **69 celle IS su 69 sono SOTTO e 61 celle OOS su 69 sono SOPRA**: **nessun asse d'uscita, in nessuno dei 11 round, riporta una cella IS sopra 1** (le celle contano la viva piu' volte). **In OOS invece l'uscita il segno lo sposta in 8 celle su 69** (r153a 26; r160a 7 e 11; r161a SL 1,5; r169b 0,15-0,30), e fuori da questi 11 round lo sposta anche altrove (r164a OOS: AtrExitPeriod 2-10 SOPRA, 14-26 SOTTO su 443-464 deal; GapFill SLGapMult 0,4; BB EURUSD SL 1,5-2,0). *(Corretto dal cancello: qui c'era "l'uscita non cambia il segno: lo cambia la finestra", vero solo per le gambe IS.)*
- ⚠️ **E' una LETTURA DESCRITTIVA, non un verdetto**: i 6 oggetti sono stati **scelti proprio perche' la viva e' SOTTO in IS** (il 69/69 IS e' in parte una conseguenza della selezione), 20 delle 69 celle sono BB GBPUSD e 28 sono Larry EURAUD/EURCAD (le osservazioni indipendenti sono **6 oggetti**, non 69), tutti e 6 sono dati [B] (screening) e per Larry/EZ la gamba OOS e' la finestra di R103 (K3). I regimi dentro le gambe **non sono separati**: "e' la finestra" e' un'ipotesi compatibile coi numeri, **non misurata**.
- **Non invertono**: C2C r127c (SOPRA/SOPRA), EZ GBPUSD (SOPRA/SOPRA, PF cala), Larry GBPJPY e GBPUSD (SOPRA/SOPRA), GapFill 225JPY r178a (SOPRA/SOPRA), Fibo r139c (SOTTO/SOTTO), PTE 771322 r164a (SOTTO/SOTTO sulla viva).
- **Altri versi**: C2C EURJPY r146a (tick) **8 valori su 9** con IS SOTTO e OOS SOPRA (la viva e' l'unica IS sopra 1, isolata); C2C GBPCAD r146c SLBuffer 0,8 **SOPRA in IS (1,095) -> SOTTO in OOS (0,920)**.
- **Regime dichiarato (Regola A del 16/08)**: gli IS lunghi 1999/2000/2004 -> 2012/2013/2019 contengono la crisi 2008; gli OOS (2012/2013/2020 -> 2026) contengono covid 2020, orso 2022, risalita 2025. I CSV **non separano i regimi**: ogni PF e' un numero unico per la gamba = **per regime: NON MISURATO**.

### 5.2 Sentinelle congelate di R161a (le uniche applicate)
Vedi 4.1. L'**unico fallimento** e' S7 (nessuna cella con DD > 35,0%): **IS SL 1,5 = 36,11%**. Il file prova dice "se una cella lo rompe, si scrive SUBITO, prima di qualunque PF". B2: in testa al referto andava scritto "quante celle su sette stanno sopra il 10%": **IS 7/7, OOS 4/7**. B5: "il round non promuove niente". Lettura **del criterio congelato, non una interpretazione nuova**.

---

## 6. CELLE SOPRA 1 E SOTTO 1 (classe 1127: entrambi i versi) E CASELLE DEL CERTIFICATO

### 6.1 Conteggio delle 414 righe-cella (PF >= 1 / PF < 1)
Una riga = una cella (valore di asse x gamba). **La cella viva compare in piu' round dello stesso EA/simbolo** (es. BB GBPUSD 4 volte, EURAUD 2): le righe non sono celle indipendenti. **Questo conteggio e' un INVENTARIO, non un'evidenza: 286 e 128 non si sommano ne' si confrontano come prove pro o contro un EA** (righe duplicate, assi diversi, finestre e tipi di dato diversi, n da 11 a 737).

| EA | righe | SOPRA | SOTTO | dove stanno le SOTTO |
|---|---:|---:|---:|---|
| BreakingBand | 47 | 24 | 23 | GBPUSD IS 1999-2012 (20/20), OOS SL 1,5 (1), EURUSD intera SL 1,5 e 2,0 (2) |
| CostToCost | 52 | 43 | 9 | r146a IS 8/9 (tick); r146c OOS SLBuffer 0,8 (1) |
| EasyTrend | 28 | 21 | 7 | CHFJPY IS 1999-2019 (7/7) |
| GapFill | 76 | 72 | 4 | SLGapMult 0,4 su GBPUSD, EURUSD, 225JPY; MaxHours 12 su U30USD |
| GapContinuation | 9 | 9 | 0 | - |
| PunteLarry | 140 | 89 | 51 | EURAUD IS (14), EURCAD IS (14), XAUUSD intera (14), EURAUD OOS (6), GBPUSD OOS (2), GBPJPY IS (1) |
| FiboH4_Multi | 6 | 0 | 6 | IS 3/3 e OOS 3/3 |
| PTE | 35 | 14 | 21 | r153a IS 7/7 e OOS 1/7; r164a IS 7/7 e OOS 4/7; r158a U30USD 2/7 |
| SupertrendReversal (225JPY H2) | 7 | 7 | 0 | - |
| SupertrendReversal_Ottimizzato (XAU H4) | 14 | 7 | 7 | IS 7/7 |
| **totale** | **414** | **286** | **128** | (controllo: 286 + 128 = 414) |

**Per tipo di dato**: **tick [T] 107 righe (94 SOPRA / 13 SOTTO)**; **barre [B] 307 righe (192 SOPRA / 115 SOTTO)**; 94 + 192 = 286 e 13 + 115 = 128, come in tabella. (Tick: SOPRA = 63 intere + 12 IS + 19 OOS; SOTTO = 4 intere + 8 IS + 1 OOS. Barre: SOPRA = 45 intere + 42 IS + 105 OOS; SOTTO = 18 intere + 80 IS + 17 OOS.)

### 6.2 Le 5 caselle del certificato di morte (regola 09/09), cosa chiudono i CSV
Per ogni EA con celle SOTTO o NM. "Prima" = come scrivevano G3/G4/G5; "dopo" = con questi CSV. **Non scrivo nessun MORTO**: scrivo quali caselle risultano compilate.

| EA | (1) PF | (2) n e DD | (3) uscita ad asse | (4) gemelli | (5) TF | prima -> dopo |
|---|---|---|---|---|---|---|
| BreakingBand | si | si | **prima: "misurata ma illeggibile" -> ora LETTA** (SL ATR x7, BEMode, BEatATR, TPRefreshBars su GBPUSD; SL su EURUSD; AUDUSD NON LEGGIBILE; `InpTPMode=1` e TP mai) | si (7 simboli + 48 scan) | si (M15, M30, H1, H4) | NON ANCORA MISURATO (casella 3) -> **5 caselle compilate a livello di EA**; **per cella** la casella 3 e' compilata solo sulle celle H1 GBPUSD/EURUSD; M15, M30 e AUDUSD restano aperte |
| CostToCost | si | si | **prima parziale -> ora LETTA** (SLBufferATR tick EURJPY e GBPCAD; MaxBarsHold [B]; ExitMode scan G4) | si (48) | si (H1, H4) | NON ANCORA MISURATO (casella 3) -> **5 compilate a livello di EA**; **per cella** la 3 resta aperta su short, L+S, CHFJPY, XAG, GBPCAD 6,5 anni [B] (nessun asse d'uscita girato su quelle celle) |
| EasyTrend | si | si | `InpTP_R` (G4) + **SLBufferPts letto** | si (48 + 4) | **H1 e basta: APERTA** | NON ANCORA MISURATO (TF) -> **invariato: resta la casella 5** |
| GapFill | si | si | **prima solo FillPct -> ora SLGapMult, MaxHours, SLMode letti** | si (10) | **H1 e basta: APERTA** | mancano 3 e 5 -> **manca solo la 5** |
| GapContinuation | si | si (deal) | FinalTargetR (G4) + **PartialTargetR letto** | **APERTA** (nessun gemello) | **APERTA** (M1) | mancano 3,4,5 -> **mancano 4 e 5** |
| PunteLarry | si | si | tipo R/FPO (scan G4) + **MaxDaysHold e SLBufferATR letti su 6 simboli** | si (48) | **H1 e basta: APERTA** | mancano 3 e 5 -> **manca solo la 5** |
| FiboH4_Multi | si | si (deal) | **APERTA** (r139c muove l'ingresso) | solo GBPUSD singolo + basket | **APERTA** (H4) | **invariato** (3 e 5 aperte) |
| PTE | si | si (deal) | G3: si; **+ AtrExitPeriod su 3 sedie** | si (9) | si (H1-H4) | **invariato** (G3: compilato su dato [B], "NON MORTO") |
| SupertrendReversal (225JPY H2) | si (r166a) | si (deal) | **+ SLBufferPips su 225JPY H2** (G5: PARZIALE: TrailOnST, ExitOnFlip, FirstFraction, TP1Pct mai) | G5: 10 simboli | G5: 11 TF | NM -> **SOPRA s.OOS C; certificato invariato** |
| SupertrendReversal_Ottimizzato | si | si (deal) | SLLookback (G5) | solo oro col suo nome | 11 TF | **invariato** |

La casella 3 la leggo alla lettera della regola 09/09 ("la gestione dell'uscita messa ad asse **almeno una volta**"): dove G4 la dava aperta **perche' illeggibile**, ora e' leggibile. Dove G4/G5 la davano "parziale" per **manopole non mosse** (TPMode=1, TrailOnST, ...) **non le ho toccate**: quelle restano non mosse.

---

## 7. VERDETTI DEI RESOCONTI: COSA CAMBIEREBBE E COSA NO (PROPOSTE, NESSUNA APPLICATA)

| # | dove (resoconto, riga/scheda) | verdetto/dato attuale | cambierebbe? | proposta (con il numero) |
|---|---|---|---|---|
| V1 | G4 tab. 2a, 2e-2i; scheda 4.2 punto 3; consolidato riga 56 | "dato [B] ovunque" per C2C WF R40/R41 (EURJPY, GBPCAD, XAG, CHFJPY): C-screening | **SI (etichetta)** | **[T]**: provato identico al centesimo per EURJPY e GBPCAD (K2); per XAGUSD e CHFJPY dedotto dal nome del file (D1). Affidabilita' "C-screening" -> **C** (n 64 e 62 pos a tick) |
| V2 | G4 scheda 4.1 punti 9-11; consolidato riga 55 | BB: "NON ANCORA MISURATO (casella 3 misurata ma illeggibile)", "migliorabile: non so" | **SI** | casella 3 **leggibile e letta**; 5 caselle compilate **a livello di EA**; per cella solo su H1 GBPUSD (20/20 celle IS 1999-2012 SOTTO) ed EURUSD; M15, M30, AUDUSD: casella 3 aperta per cella. **Nessun MORTO** (ne' per l'EA, che ha 3 sedie e celle SOPRA, ne' per le celle IS, che sono la stessa cella SOPRA in OOS) *(corretto dal cancello: qui c'era "MORTO per le celle, non per l'EA", in contraddizione con la sez. 6.2 e col vocabolario 5.5 del piano)*. La domanda "e' lo stop?" ha risposta numerica: lo stop sposta il **DD** (OOS 10,31 -> 7,79 a SL 4,0) e **non il segno della gamba IS** (20/20 SOTTO); in OOS lo sposta in 1 cella su 20 (SL 1,5 = 0,953), su EURUSD in 2 su 7. AUDUSD resta NON LEGGIBILE |
| V3 | G4 scheda 4.1, riga 1i | "GBPUSD 27 anni 0,897 / n522 / DD 23,43 SOTTO [B]" | **si, scomposto** | IS 1999-2012 **0,714 / 261 / 21,95**; OOS 2012-2026 **1,123 / 260 / 10,31**: il DD della finestra intera (23,43%) e' dello stesso ordine di quello della sola gamba IS (21,95%) [non so dire dove cada nel tempo il massimo: i CSV non lo dicono]; la gamba OOS sta a 10,31, cioe' **sopra il muro 10%** anche nella finestra "buona". Il verdetto "NO PER RISCHIO sul vecchio" **non cambia** |
| V4 | G4 scheda 4.2 punto 9 | C2C: "NO PER RISCHIO" (r127c: DD 10,99 IS / 12,26 OOS; giornata -8,02%) | **NO** | resta. Si aggiungono i numeri a tick (r146a): DD OOS 9,45 / IS 9,93 alla viva, peggior giornata -4,00 / -3,74: **finestra diversa (13,5 mesi, non 3,8 anni)**; non smentisce r127c. Casella 3 compilata **a livello di EA**; per le celle SOTTO di G4 (short, L+S, CHFJPY, XAG, GBPCAD 6,5 anni) **resta aperta per cella** |
| V5 | G4 scheda 4.3 punti 9-10; consolidato 57 | EZ: "MERITO SOSPESO", "NO PER RISCHIO su 6,5 anni", "no sul merito" | **NO (si arricchisce)** | GBPUSD **SOPRA in entrambe le gambe [B]** (IS 1,184 n583; OOS 1,053 n254) ma **DD > 14% in 14/14 celle**; CHFJPY **inverte** (IS 0,824 DD 34,81 -> OOS 1,066). Resta aperta la sola casella 5 (TF). Il DD 6,5 anni 15,77 (G4) e' 15,84 nel CSV |
| V6 | G4 scheda 4.5 punti 9-11; consolidato 59 | GapFill: "NON ANCORA MISURATO (mancano 3 e 5)"; "migliorabile: si, per il campione: le epoche stanno nel nativo 1999-2026" | **SI** | casella 3 chiusa -> **manca solo la 5**. "Migliorabile per n con lo storico lungo": **NO**: 20-25 trade in 27,5 anni per simbolo forex (sez. 8 S2). La via resta TF/simboli, non storico |
| V7 | G4 scheda 4.6 punti 5, 9, 11(b); consolidato 60 | GapCont: "IS tick non misurato"; "NO PER RISCHIO a 1%" | **PARZIALE** | r162a da' la finestra intera a tick: **9/9 SOPRA** (1,269-1,582), n 84-124 deal, DD > 10% in 8/9 celle. **NO PER RISCHIO non cambia**. Il "IS tick" separato resta NON LEGGIBILE (solo [DERIVATO] ~1,35 su 39 deal). Casella 3 chiusa, restano 4 e 5 |
| V8 | G4 scheda 4.7 punti 5-9; consolidato 61 | Larry: "XAU PF non pubblicato", "NO PER RISCHIO XAU a 1% (REVISIONE R100)", "MIGLIORABILE: si, 12 round d'uscita gia' girati" | **SI** | **XAU long = SOTTO [B] su 22 anni, 14/14 celle, PF 0,872, n213, DD 29,74**: la revisione R100 ("taglia 0,3%, se il tagliando non la giustifica spegnere") perde la parte "merito ignoto". EURAUD e EURCAD: **IS vecchio SOTTO 14/14** (DD 40,45 e 18,86), segno invertito sull'OOS; GBPJPY e GBPUSD: SOPRA in entrambe le gambe. "Migliorabile con l'uscita": le uscite lette **non portano sopra 1 nessuna cella IS** (EURAUD, EURCAD 14/14; XAU 14/14 su 22 anni); **in OOS (= finestra R103) l'uscita sposta il segno** su EURAUD (r160a 2/7, r169b 4/7 SOTTO) e GBPUSD (r169e 2/7) (sez. 5.1). Resta la sola casella 5 (TF) |
| V9 | G4 scheda 4.8 punto 5 e tab. 7b; consolidato 62 | Fibo GBPUSD singolo: OOS 0,942-0,972, IS 0,794-0,831; "NO PER RISCHIO"; "NON ANCORA MORTO" | **SOLO NUMERI** | versione del 05/10: OOS **0,939-0,968**, IS **0,791-0,830** (K10); nessun segno cambia; caselle 3 e 5 invariate |
| V10 | G3 scheda 4.7 (PTE), 7a/7b | R78: cella viva 0,972 / 17,68 / 447; candidata 1,095 / 9,87 / 477 | **SOLO NUMERI** | r164a **0,966 / 17,91 / 447**; r153a **1,088 / 9,97 / 477** (K12). Nuovo asse `AtrExitPeriod` letto su 3 sedie: OOS massimo a 6-10 (1,297-1,328 su 771332; 1,103-1,135 su 771322), IS sempre SOTTO. Verdetto G3 invariato |
| V11 | G5 scheda 1.1, riga 226 e D19 | `SupertrendReversal` 225JPY H2 r166a: "scritto/armato, nessun CSV: NM", stato di esecuzione "NON VERIFICATO" | **SI** | **eseguito** (CSV IS, log 14-20/09); **SOPRA s.OOS, C**: 7/7 celle, PF 1,434-1,848, n79-89 deal, DD 0,29-0,77% (scala 225JPY, D7). Certificato invariato |
| V12 | G4 sez. 3-bis | "35 round GIRATI, CSV non in repo; 17 a uscita 2: presenza di operazioni NON VERIFICATA" | **SI** | **34 su 35 in repo**; in **tutti** i round a uscita 2 la gamba IS ha Trades > 0 (min 20). Unico non leggibile: r161c |
| V13 | G5 scheda 1.2 / U05; consolidato 277 | SupRev Ott XAU r127b: IS 7/7 SOTTO, OOS 7/7 SOPRA | **NO** | stessi valori (K11) |

**Cosa NON cambia (verificato)**: C2C r127c (K11: identico alla versione 13/09); BB EURUSD 27,5 anni 1,075 / 276 / 8,24; GapFill 225JPY r178a OOS = R65; GapCont "NO PER RISCHIO a 1%" (11,59%); nessuna cella SOPRA con n >= 150 **posizioni a tick con OOS vero** (la frase di G4 sez. 2 punto 1 resta vera: le celle con n >= 150 nei CSV letti sono **tutte [B]**); il conteggio "EA in SOPRA e in SOTTO" di G4 sez. 2 non cambia per nessuna delle 12 righe.

---

## 8. COSA I CSV SMENTISCONO

| # | affermazione nei resoconti | cosa dicono i CSV |
|---|---|---|
| S1 | **G4 (tab. 2a, 2e-2i, scheda 4.2) e consolidato riga 56: "C2C WF R40/R41 = dato [B] barre"** | **E' tick.** r146a/r146c (modello 4) riproducono il file `r41` (senza `_ohlc`) **al centesimo** (K2). Il tipo di dato dichiarato era sbagliato |
| S2 | **G4 scheda 4.5 punto 11(a): "R168a-c sono 27,5 anni a barre e possono dare n e regimi... a una famiglia che oggi ne ha 8-20"** | n = **21 / 20 / 25** (GBPUSD / EURUSD / AUDUSD) su 27,5 anni; r167a-c (da 1993/1971) danno **gli stessi n e profitti** di r168a-c (da 1999): **zero operazioni prima del 1999**. Dei 21-25 trade, **6-8 sono prima del 2020** (derivato da R103). Nessun n >= 150 ne' regime misurabile |
| S3 | **G4 sez. 3-bis: "GapFill forex fa 0 operazioni 2020-2023: `Trades=0` e' un'ipotesi viva"** per le gambe IS dei round a uscita 2 | **Nessun file/gamba IS ha Trades=0** (min n=11). I CSV a 0 byte sono le gambe OOS di `@FRAZIONEIS 1.0`; il log r162a lo mostra nella finestra stampata: `OOS (2026.07.01 -> 2026.06.30)` = inizio dopo la fine. (Il messaggio "E' la CACHE del tester" del runner e' il testo generico del controllo: **qui non e' la causa**) |
| S4 | **G4 scheda 4.7 punto 11(c) / consolidato 61: "XAU 22 anni: PF non pubblicato"** | **PF 0,872** (n213, DD 29,74 = R100), **14 celle su 14 SOTTO** (0,756-0,948) |
| S5 | **G4 scheda 4.1/4.2/4.3/4.4/4.6 punto 9: "casella 3 misurata ma illeggibile / girata ma non leggibile da qui"** | **leggibile**: 34 round su 35; vedi 6.2 |
| S6 | **G4 scheda 4.8: r139c OOS "0,972 / 0,942 / 0,950", IS "0,798 / 0,794 / 0,831"** | versione 05/10: OOS **0,968 / 0,939 / 0,948**, IS **0,792 / 0,791 / 0,830** (il runner ha rigirato; K10) |
| S7 | **G5 sez. D19 / riga 226: R166a "stato di esecuzione NON VERIFICATO", "nessun CSV in repo: NM"** | **eseguito**, CSV IS presente (r166a, 7 righe, tick, intera) |
| S8 | **G4 scheda 4.7 punto 2/6 e tab. 6c: lato long XAU "SOPRA D" come lettura della cella** | su 22 anni la stessa cella e' SOTTO 14/14: la lettura "SOPRA" era un indizio D di 21 mesi, non un'indicazione sulla cella |
| S9 | **G4 sez. 3-bis (b): per BB, EZ e Larry "esiste gia' sul VPS uno storico lungo [B] con IS/OOS a uscita 3"** (presentato come possibile prova nuova) | per Larry e EZ l'OOS (2020.01.01-2026.06.30) **coincide con la finestra di R103** (K3): quella gamba **non aggiunge un OOS indipendente**; **la gamba nuova e' l'IS 1999-2019** (per BB l'OOS e' 2012-2026, non coincide con R103) |

---

## 9. [NON COPERTO] E PUNTI DUBBI

### 9.1 [NON COPERTO]
1. **r161c (BreakingBand AUDUSD, asse `InpSL_ATRmult`)**: **NON LEGGIBILE** (solo ARCHIVIO Desktop VPS: IS 3,5 KB, OOS 0 byte). Costo del buco: **0 minuti di macchina** (un trasporto): la sorgente del trasporto (`abtg_round\risultati_prove`) non lo contiene, va preso da `Desktop\ARCHIVIO\2026-09-20\ROUND_r161c\` (o dalle altre due copie sopra).
2. I **`REFERTO_ROUND_rNNN.txt`** dei 41 round (stanno nello zip/Desktop del VPS): non letti. Solo per r162a e r178a ho il log del runner nel repo.
3. **Per-trade, per-lato, per-anno, per-regime**: i CSV non li contengono -> **regimi NON MISURATI**, posizioni di GC/PTE/Fibo/SupRev **NON LEGGIBILI**, lato long/short non separabile (BB non ha manopole di lato; G4).
4. **Costo (stop >= 40 x spread)**: nessuna colonna di stop o spread nei CSV: **nessun numero**, e nessuno ne e' stato scritto.
5. **Soglie congelate dei file prova** diverse da R161a (S1-S7/B1-B6 di R146a, R162a, R160a-e, R169, R171, R167/R168, R178a...): **non applicate** (non le ho lette per intero). Gli esiti che il referto di ciascun round avrebbe scritto (PASS/FAIL delle sentinelle) **non sono in questo documento**.
6. **Le altre 22 cartelle `dal_vps/`** (AtrExhaustVol, Cycle, DAX_Apertura_EU, DaxValueArea, Dow_Apertura_US, EMA200, HVAncora, IBRetest, IntradayMomentum, LVNArbitro, MaxMinNotte, MaxMinNotte_DAX_Short_Ottimizzato, Nasdaq_Apertura_US, Nasdaq_Live5m, Nightly, ORB_Ottimizzato, OpeningReversalB, SupRev_DOW_H1_Ottimizzato, SupRev_NAS_H1_Ottimizzato, SuperWave, SuperWave_DOW_H1_Ottimizzato, VolExpBreak): non sono del mio perimetro (G1/G2/G3/G5/G6).
7. **Sorgenti `.mq5`**: non riletti; l'unita' di n (posizioni/deal) per BB, EZ, C2C, GapFill, Larry poggia sull'assenza di input di parziale nell'intestazione del CSV e su G4 (R1).
8. **Combinazioni IS+OOS** (BB 27,5 anni ~0,915; GC IS ~1,35): [DERIVATO] con additivita' approssimata (ogni gamba riparte da 100k, i lotti dipendono dal saldo): **non sono misure**.

### 9.3 Riserve del cancello (05/10/2026)
- Le 414 righe dell'Appendice A e le 41 righe della tabella 2 sono state **ricalcolate dal cancello dai CSV alla fonte, programmaticamente: 0 differenze** (PF, n, DD, profitto, conteggi SOPRA/SOTTO, segni invertiti); finestre IS/OOS riprodotte con la regola del driver sulle frazioni dei file prova.
- **Casella 3 del certificato**: chiusa **a livello di EA** per BB, C2C, GapFill, GapCont, Larry, EZ; **per cella** resta aperta dove l'asse d'uscita non e' mai girato su quella cella (BB M15/M30/AUDUSD; C2C short, L+S, CHFJPY, XAG, GBPCAD 6,5 anni [B]). Prima di scrivere MORTO su una di quelle celle va girato l'asse su di lei.
- **"Lo cambia la finestra"** (sez. 5.1) e' una lettura descrittiva su 6 oggetti tutti [B], selezionati per IS SOTTO: **non e' un verdetto** e non chiude la domanda "regime o edge" (regimi non separati).
- **OOS di Larry/EZ = finestra R103**: replica dell'ancora, non prova fuori campione nuova.

### 9.2 Punti dubbi
- **D1** - "R40/R41 = tick": provato per EURJPY e GBPCAD (identita' al centesimo con r146a/c), **dedotto dal nome (nessun `_ohlc`) per XAGUSD e CHFJPY**. Se qualcuno ha un r41 XAG/CHFJPY a barre con nome senza suffisso, S1 va ristretto.
- **D2** - Le celle vive si ripetono in piu' round: **le 414 righe non sono 414 osservazioni indipendenti**. Il conteggio "69 su 69 / 61 su 69" (sez. 5.1) conta la viva piu' volte.
- **D3** - Scarti piccoli fra CSV e referto che **non so spiegare**: Larry GBPUSD OOS 1,041 vs 1,05 (G4); EZ GBPUSD OOS 1,053 / 15,84 vs 1,059 / 15,77 (G4); PTE r153a/r164a vs R78 (K12); r139c vs sua versione del 13/09 (K10). Candidati: binario dell'EA preso dalla testa del ramo, deposito, quantizzazione del lotto. **Nessuno provato.**
- **D4** - r139c e' stato **rigirato** dopo il 13/09 con un binario diverso; r127b e r127c, rigirati anch'essi, tornano **identici**. Non so quali altri round hanno una versione precedente nel repo che e' stata sovrascritta (il transcript dice solo "AGGIORNATO" su 5 dei miei 82 file, 35 su 254).
- **D5** - **BB: n identico in tutte le celle** (261 IS / 260 OOS su 20 celle per gamba), mentre il file prova R161a si aspettava n diverso lungo l'asse (catena C3). Non l'ho indagato: significa che lo stop piu' largo non ha mai bloccato un setup successivo (`InpMaxPositions=1`) o che l'asse agisce altrove.
- **D6** - **GapFill "nessuna operazione prima del 1999"**: i CSV non distinguono **"niente dati"** da **"niente gap sopra la soglia"**. G4/R103 dicono che il feed BCM parte dal 1993/1999: non ho riletto la profondita' M1 del feed.
- **D7** - **SupRev 225JPY (r166a)**: profitti +0,9/+1,5% in 21 mesi con rischio 0,65% e DD < 1%. La scala e' quella dei CSV R5 del Nikkei, ma **perche'** (sizing/valore del punto) **NON VERIFICATO**: DD% e profitto in valuta non confrontabili con altri simboli.
- **D8** - **C2C: peggior giornata** -8,02% (r127c OOS, 3,8 anni [B]) contro -4,00% (r146a OOS, 13,5 mesi tick): **finestre e dato diversi**, non confrontabili; la lettura "il tappo e' la giornata" di G4 poggia sulla finestra lunga.
- **D9** - **L'OOS di Larry/EZ (R160/R169/R171) e' la finestra R103**: se la cella viva e' stata scelta guardando R103 (2020-2026), quella gamba **non e' fuori campione rispetto alla scelta**; la gamba IS 1999-2019 lo e'. Non ho verificato come furono scelte le celle vive.
- **D10** - **GapFill U30USD / 225JPY a 21 mesi con n 26-30**: tutte le righe SOPRA o SOTTO stanno su campioni D/C: **nessuna e' una prova di merito**; le ho riportate perche' G4 le aspettava.

---

## 10. CONTROLLI FATTI PRIMA DI CONSEGNARE (Sviluppatore -> Agente dei Controlli)
1. **Conti riconciliati**: 82 file = 41 round x 2 gambe, meno r161c (assente); 63 non vuoti + 19 a 0 byte; **414 righe = 286 SOPRA + 128 SOTTO**; per EA le somme tornano (sez. 6.1).
2. **Contro-esempio alla formula delle finestre**: il calcolo ha **riprodotto da solo** quattro date che il repo scrive in chiaro (IS r178a `2024.09.26-2025.06.09`; OOS r178a `2025.06.10-2026.06.30`; IS BB r161a `1999.01.04-2012.10.01`; inizio OOS BB `2012.10.02`; e l'IS r139c ~1999-2010 come G4). Una formula con "due incognite libere" non l'avrebbe fatto.
3. **Contro-esempio alla tesi "R41 e' tick"**: se r146a fosse a barre il nome avrebbe `_ohlc` e **non** potrebbe riprodurre r41 al centesimo (lo dice R146a stesso come falsificatore); invece riproduce 4 righe (2 simboli x IS/OOS) su 4.
4. **Contro-esempio alla tesi "OOS a 0 byte = FrazioneIS 1,0"**: il log r162a stampa la finestra `2026.07.01 -> 2026.06.30` (inizio dopo la fine) e, per tutti i 19 file a 0 byte, il round ha `@FRAZIONEIS 1.0` nel file prova; in nessun round con FrazioneIS < 1 c'e' un file vuoto.
5. **Confronto programmatico con i log del runner** (r162a, r178a x3): 8 file su 8 identici.
6. **Cross-check di additivita'**: r178a 11+15 = r167d 26; BB 261+260 = 521 (S1 480-560); Larry U30 54 = 16+38 (G4).
7. **Cosa non ho potuto rompere**: la causa degli scarti D3 e il motivo del n identico D5: dichiarati, non spiegati.

---

## APPENDICE A - TUTTE LE RIGHE LETTE (82 file, 414 righe-cella)

Formato per riga: `valore asse: PF / n / DD% / profitto` (profitto in valuta del conto; deposito 100k, o 10k per r139c). Gamba `IS` o `OOS` dopo il nome del file; per i round a finestra intera la gamba `IS` e' la finestra intera (sez. 1). Righe ordinate per valore dell'asse. Numeri ricalcolati dal CSV, nessuno copiato da un referto.

- **SupertrendReversal_Ottimizzato_XAUUSD_IS_ohlc_r127b.csv** (IS, 7 righe, asse SLLookback; PF/n/DD%/profitto): 1: 0,792/230/10,24/-5852 | 3: 0,848/230/6,79/-3523 | 5: 0,854/230/6,58/-3322 | 7: 0,855/230/6,57/-3295 | 9: 0,854/230/6,60/-3262 | 11: 0,838/230/6,51/-3518 | 13: 0,835/230/6,50/-3493
- **SupertrendReversal_Ottimizzato_XAUUSD_OOS_ohlc_r127b.csv** (OOS, 7 righe, asse SLLookback; PF/n/DD%/profitto): 1: 1,053/426/8,43/2171 | 3: 1,075/427/6,86/2494 | 5: 1,125/427/5,91/3967 | 7: 1,125/427/6,18/3874 | 9: 1,112/427/6,79/3416 | 11: 1,112/427/6,69/3374 | 13: 1,101/427/6,11/2855
- **CostToCost_EURJPY_IS_ohlc_r127c.csv** (IS, 8 righe, asse MaxBarsHold; PF/n/DD%/profitto): 25: 1,220/161/12,17/17448 | 50: 1,148/153/10,99/11230 | 75: 1,177/153/10,99/13369 | 100: 1,177/153/10,99/13369 | 125: 1,177/153/10,99/13369 | 150: 1,177/153/10,99/13369 | 175: 1,177/153/10,99/13369 | 200: 1,177/153/10,99/13369
- **CostToCost_EURJPY_OOS_ohlc_r127c.csv** (OOS, 8 righe, asse MaxBarsHold; PF/n/DD%/profitto): 25: 1,452/257/12,25/66658 | 50: 1,524/242/12,26/71354 | 75: 1,523/242/12,26/71284 | 100: 1,523/242/12,26/71284 | 125: 1,523/242/12,26/71284 | 150: 1,523/242/12,26/71284 | 175: 1,523/242/12,26/71284 | 200: 1,523/242/12,26/71284
- **FiboH4_Multi_GBPUSD_IS_ohlc_r139c.csv** (IS, 3 righe, asse EngulfLookback; PF/n/DD%/profitto): 8: 0,792/572/23,67/-1941 | 12: 0,791/548/22,81/-1843 | 16: 0,830/557/20,62/-1514
- **FiboH4_Multi_GBPUSD_OOS_ohlc_r139c.csv** (OOS, 3 righe, asse EngulfLookback; PF/n/DD%/profitto): 8: 0,968/725/17,52/-382 | 12: 0,939/729/17,87/-730 | 16: 0,948/737/17,39/-629
- **CostToCost_EURJPY_IS_r146a.csv** (IS, 9 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.0: 0,816/49/14,74/-5372 | 0.1: 0,773/49/14,00/-6064 | 0.2: 1,016/48/9,93/363 | 0.3: 0,940/48/9,35/-1273 | 0.4: 0,914/48/8,91/-1694 | 0.5: 0,934/48/8,65/-1208 | 0.6: 0,886/48/8,48/-2030 | 0.7: 0,975/48/7,11/-376 | 0.8: 0,938/48/6,91/-903
- **CostToCost_EURJPY_OOS_r146a.csv** (OOS, 9 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.0: 1,876/64/12,11/31628 | 0.1: 1,872/64/9,98/27533 | 0.2: 1,741/64/9,45/22252 | 0.3: 1,772/63/8,47/21320 | 0.4: 1,744/63/7,36/19056 | 0.5: 1,754/63/7,07/18011 | 0.6: 1,777/63/6,80/17389 | 0.7: 2,106/62/5,87/20000 | 0.8: 2,038/62/5,68/18147
- **CostToCost_GBPCAD_IS_r146c.csv** (IS, 9 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.0: 1,240/47/6,12/6649 | 0.1: 1,184/46/5,83/4934 | 0.2: 1,298/44/5,11/7343 | 0.3: 1,113/41/6,31/2707 | 0.4: 1,015/40/6,97/357 | 0.5: 1,255/40/5,07/5842 | 0.6: 1,262/40/5,09/5949 | 0.7: 1,213/39/5,09/4772 | 0.8: 1,095/39/6,30/2174
- **CostToCost_GBPCAD_OOS_r146c.csv** (OOS, 9 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.0: 1,460/66/6,93/17201 | 0.1: 1,466/64/6,72/16664 | 0.2: 1,443/62/6,19/15446 | 0.3: 1,382/58/7,24/12331 | 0.4: 1,387/56/8,37/11949 | 0.5: 1,285/56/8,62/9084 | 0.6: 1,271/52/9,00/8032 | 0.7: 1,127/51/8,89/3778 | 0.8: 0,920/47/9,95/-2268
- **PTE_GBPUSD_IS_ohlc_r153a.csv** (IS, 7 righe, asse AtrExitPeriod; PF/n/DD%/profitto): 2: 0,864/449/9,48/-6023 | 6: 0,822/441/12,80/-8360 | 10: 0,888/442/9,71/-5476 | 14: 0,874/439/11,74/-6452 | 18: 0,826/437/12,83/-9401 | 22: 0,838/438/12,94/-8606 | 26: 0,822/435/12,83/-9559
- **PTE_GBPUSD_OOS_ohlc_r153a.csv** (OOS, 7 righe, asse AtrExitPeriod; PF/n/DD%/profitto): 2: 1,078/482/7,15/3011 | 6: 1,297/486/6,71/11219 | 10: 1,328/485/7,82/12471 | 14: 1,088/477/9,97/4006 | 18: 1,055/475/9,69/2603 | 22: 1,011/474/11,06/529 | 26: 0,963/472/11,51/-1800
- **PunteLarry_U30USD_IS_r156a.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,760/73/3,55/9608 | 3: 1,494/60/5,05/10184 | 5: 1,784/54/3,96/15042 | 7: 1,634/49/3,66/12626 | 9: 1,204/45/4,13/4439 | 11: 1,319/44/4,08/6431 | 13: 1,192/41/4,13/3685
- **ABTG_PunteLarry_U30USD_OOS_r156a.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_U30USD_IS_r157a.csv** (IS, 7 righe, asse SLGapMult; PF/n/DD%/profitto): 0.4: 1,237/30/6,85/4616 | 0.7: 1,422/30/4,67/5967 | 1.0: 1,376/30/3,12/4596 | 1.3: 1,947/30/2,86/7610 | 1.6: 1,803/30/2,64/5565 | 1.9: 1,720/30/2,55/4404 | 2.2: 1,628/30/2,48/3470
- **ABTG_GapFill_U30USD_OOS_r157a.csv** (OOS): 0 byte, nessuna riga.
- **PTE_U30USD_IS_r158a.csv** (IS, 7 righe, asse AtrExitPeriod; PF/n/DD%/profitto): 2: 0,980/68/3,42/-213 | 6: 1,234/70/3,19/1916 | 10: 1,444/70/3,00/3766 | 14: 1,170/68/3,24/1779 | 18: 0,932/66/3,59/-853 | 22: 1,077/67/3,62/891 | 26: 1,173/67/3,49/2001
- **ABTG_PTE_U30USD_OOS_r158a.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_U30USD_IS_r159a.csv** (IS, 7 righe, asse MaxHours; PF/n/DD%/profitto): 12: 0,837/30/4,11/-1268 | 24: 1,638/30/3,13/6471 | 36: 1,576/30/3,12/6169 | 48: 1,376/30/3,12/4596 | 60: 1,376/30/3,12/4602 | 72: 1,376/30/3,12/4602 | 84: 1,376/30/3,12/4602
- **ABTG_GapFill_U30USD_OOS_r159a.csv** (OOS): 0 byte, nessuna riga.
- **PunteLarry_EURAUD_IS_ohlc_r160a.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 0,748/620/35,62/-34461 | 3: 0,830/525/33,11/-30724 | 5: 0,780/475/40,45/-39925 | 7: 0,823/429/34,09/-32718 | 9: 0,801/412/38,54/-35840 | 11: 0,861/395/34,45/-25593 | 13: 0,895/383/28,09/-20065
- **PunteLarry_EURAUD_OOS_ohlc_r160a.csv** (OOS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,100/306/9,70/7094 | 3: 1,138/251/12,91/12610 | 5: 1,053/216/17,12/4695 | 7: 0,951/200/20,97/-4587 | 9: 1,069/189/12,71/6428 | 11: 0,922/180/18,87/-7064 | 13: 1,013/171/17,18/1165
- **PunteLarry_EURCAD_IS_ohlc_r160b.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 0,835/244/14,93/-9215 | 3: 0,829/239/18,17/-12523 | 5: 0,816/236/18,86/-13824 | 7: 0,825/235/19,37/-13259 | 9: 0,836/234/19,53/-12436 | 11: 0,831/234/19,51/-12897 | 13: 0,840/234/19,50/-12150
- **PunteLarry_EURCAD_OOS_ohlc_r160b.csv** (OOS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,278/157/6,76/10519 | 3: 1,250/155/6,34/11143 | 5: 1,338/154/6,96/14779 | 7: 1,388/152/7,16/16535 | 9: 1,416/151/7,18/17521 | 11: 1,384/150/7,73/16189 | 13: 1,376/149/7,90/15885
- **PunteLarry_GBPJPY_IS_ohlc_r160c.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 0,976/402/11,05/-2076 | 3: 1,099/388/18,63/15665 | 5: 1,071/364/19,55/12001 | 7: 1,052/343/19,21/9097 | 9: 1,045/335/15,71/8016 | 11: 1,038/332/15,16/6828 | 13: 1,029/326/17,10/5158
- **PunteLarry_GBPJPY_OOS_ohlc_r160c.csv** (OOS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,177/158/8,31/7007 | 3: 1,170/152/8,37/10506 | 5: 1,288/139/8,95/17221 | 7: 1,223/131/12,38/13255 | 9: 1,252/127/12,02/15489 | 11: 1,292/122/10,53/17407 | 13: 1,289/120/10,64/17416
- **PunteLarry_GBPUSD_IS_ohlc_r160d.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,242/327/7,88/21950 | 3: 1,095/324/12,04/11550 | 5: 1,102/324/12,20/12818 | 7: 1,101/324/11,70/12833 | 9: 1,092/324/12,52/11779 | 11: 1,092/324/12,52/11779 | 13: 1,092/324/12,52/11779
- **PunteLarry_GBPUSD_OOS_ohlc_r160d.csv** (OOS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 1,083/123/6,73/2213 | 3: 1,068/123/8,46/2186 | 5: 1,041/121/8,53/1364 | 7: 1,041/121/8,53/1364 | 9: 1,041/121/8,53/1364 | 11: 1,041/121/8,53/1364 | 13: 1,041/121/8,53/1364
- **PunteLarry_XAUUSD_IS_ohlc_r160e.csv** (IS, 7 righe, asse MaxDaysHold; PF/n/DD%/profitto): 1: 0,756/217/25,98/-18355 | 3: 0,883/217/28,28/-10841 | 5: 0,872/213/29,74/-12461 | 7: 0,819/208/34,26/-18795 | 9: 0,808/208/36,30/-20317 | 11: 0,806/206/37,03/-20587 | 13: 0,796/205/37,03/-21942
- **ABTG_PunteLarry_XAUUSD_OOS_ohlc_r160e.csv** (OOS): 0 byte, nessuna riga.
- **BreakingBand_GBPUSD_IS_ohlc_r161a.csv** (IS, 7 righe, asse SL_ATRmult; PF/n/DD%/profitto): 1.5: 0,665/261/36,11/-32803 | 2.0: 0,672/261/29,81/-27327 | 2.5: 0,722/261/21,84/-19749 | 3.0: 0,714/261/21,95/-17793 | 3.5: 0,736/261/18,76/-14441 | 4.0: 0,750/261/16,12/-11955 | 4.5: 0,750/261/16,05/-10635
- **BreakingBand_GBPUSD_OOS_ohlc_r161a.csv** (OOS, 7 righe, asse SL_ATRmult; PF/n/DD%/profitto): 1.5: 0,953/260/20,69/-4858 | 2.0: 1,031/260/18,63/2759 | 2.5: 1,095/260/13,11/6751 | 3.0: 1,123/260/10,31/7415 | 3.5: 1,059/260/9,79/3185 | 4.0: 1,161/260/7,79/7298 | 4.5: 1,152/260/7,91/6156
- **BreakingBand_EURUSD_IS_ohlc_r161b.csv** (IS, 7 righe, asse SL_ATRmult; PF/n/DD%/profitto): 1.5: 0,822/276/28,44/-17558 | 2.0: 0,942/276/17,05/-4687 | 2.5: 1,072/276/10,21/4651 | 3.0: 1,075/276/8,24/4132 | 3.5: 1,057/276/8,90/2763 | 4.0: 1,070/276/7,32/3004 | 4.5: 1,004/276/8,44/175
- **ABTG_BreakingBand_EURUSD_OOS_ohlc_r161b.csv** (OOS): 0 byte, nessuna riga.
- **GapContinuation_225JPY_IS_r162a.csv** (IS, 9 righe, asse PartialTargetR; PF/n/DD%/profitto): 0.50: 1,582/124/6,94/13108 | 0.75: 1,400/115/10,85/10645 | 1.00: 1,385/109/11,59/11262 | 1.25: 1,347/102/12,78/10858 | 1.50: 1,269/97/12,52/8928 | 1.75: 1,313/92/12,27/10540 | 2.00: 1,324/87/12,09/10938 | 2.25: 1,344/85/12,36/11678 | 2.50: 1,330/84/12,28/11304
- **ABTG_GapContinuation_225JPY_OOS_r162a.csv** (OOS): 0 byte, nessuna riga.
- **PTE_GBPUSD_IS_ohlc_r164a.csv** (IS, 7 righe, asse AtrExitPeriod; PF/n/DD%/profitto): 2: 0,706/421/22,15/-19399 | 6: 0,806/424/20,75/-11960 | 10: 0,788/419/20,83/-14157 | 14: 0,791/414/20,55/-15077 | 18: 0,747/411/22,92/-18700 | 22: 0,717/408/22,43/-21619 | 26: 0,734/408/22,11/-19949
- **PTE_GBPUSD_OOS_ohlc_r164a.csv** (OOS, 7 righe, asse AtrExitPeriod; PF/n/DD%/profitto): 2: 1,085/463/11,80/5081 | 6: 1,135/464/9,72/8037 | 10: 1,103/458/10,76/6706 | 14: 0,966/447/17,91/-2522 | 18: 0,980/445/18,15/-1589 | 22: 0,948/443/17,97/-4082 | 26: 0,946/444/19,79/-4206
- **SupertrendReversal_225JPY_IS_r166a.csv** (IS, 7 righe, asse SLBufferPips; PF/n/DD%/profitto): 3: 1,535/79/0,71/1461 | 73: 1,436/89/0,77/1034 | 143: 1,434/89/0,57/940 | 213: 1,537/89/0,45/1010 | 283: 1,819/89/0,37/1241 | 353: 1,848/89/0,32/1149 | 423: 1,765/88/0,29/937
- **ABTG_SupertrendReversal_225JPY_OOS_r166a.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_GBPUSD_IS_ohlc_r167a.csv** (IS, 7 righe, asse SLGapMult; PF/n/DD%/profitto): 0.4: 0,452/21/12,30/-7436 | 0.7: 1,135/21/8,04/1221 | 1.0: 1,763/21/4,02/4536 | 1.3: 2,044/21/3,35/4551 | 1.6: 1,783/21/3,08/3205 | 1.9: 1,572/21/2,98/2243 | 2.2: 2,682/21/1,54/3565
- **ABTG_GapFill_GBPUSD_OOS_ohlc_r167a.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_EURUSD_IS_ohlc_r167b.csv** (IS, 7 righe, asse SLGapMult; PF/n/DD%/profitto): 0.4: 0,685/20/7,70/-3474 | 0.7: 1,006/20/4,89/44 | 1.0: 3,509/20/1,86/5436 | 1.3: 5,697/20/1,65/5162 | 1.6: 6,280/20/1,26/4284 | 1.9: 6,279/20/1,06/3601 | 2.2: 6,294/20/0,92/3111
- **ABTG_GapFill_EURUSD_OOS_ohlc_r167b.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_AUDUSD_IS_ohlc_r167c.csv** (IS, 7 righe, asse SLGapMult; PF/n/DD%/profitto): 0.4: 1,618/25/3,60/7784 | 0.7: 1,739/25/2,93/6891 | 1.0: 2,369/25/1,87/8763 | 1.3: 2,030/25/1,66/5938 | 1.6: 2,209/25/1,53/5556 | 1.9: 1,916/25/1,45/4096 | 2.2: 2,107/25/1,39/3922
- **ABTG_GapFill_AUDUSD_OOS_ohlc_r167c.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_225JPY_IS_r167d.csv** (IS, 7 righe, asse SLGapMult; PF/n/DD%/profitto): 0.4: 0,606/21/9,09/-5573 | 0.7: 1,315/26/5,81/3692 | 1.0: 1,678/26/4,59/5411 | 1.3: 1,329/26/4,45/2528 | 1.6: 1,680/26/3,73/3582 | 1.9: 1,725/26/2,90/3128 | 2.2: 1,585/26/2,77/2363
- **ABTG_GapFill_225JPY_OOS_r167d.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_GBPUSD_IS_ohlc_r168a.csv** (IS, 7 righe, asse MaxHours; PF/n/DD%/profitto): 12: 1,256/21/4,63/1248 | 24: 1,965/21/3,41/4820 | 36: 1,863/21/4,03/4867 | 48: 1,763/21/4,02/4536 | 60: 1,707/21/4,09/4339 | 72: 1,707/21/4,09/4339 | 84: 1,707/21/4,09/4339
- **ABTG_GapFill_GBPUSD_OOS_ohlc_r168a.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_EURUSD_IS_ohlc_r168b.csv** (IS, 7 righe, asse MaxHours; PF/n/DD%/profitto): 12: 1,885/20/1,55/2263 | 24: 2,906/20/1,55/3755 | 36: 4,117/20/1,55/5258 | 48: 3,509/20/1,86/5436 | 60: 3,509/20/1,86/5436 | 72: 3,509/20/1,86/5436 | 84: 3,509/20/1,86/5436
- **ABTG_GapFill_EURUSD_OOS_ohlc_r168b.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_AUDUSD_IS_ohlc_r168c.csv** (IS, 7 righe, asse MaxHours; PF/n/DD%/profitto): 12: 2,539/25/1,95/7931 | 24: 2,900/25/1,53/10140 | 36: 2,783/25/1,53/9742 | 48: 2,368/25/1,87/8759 | 60: 2,368/25/1,87/8759 | 72: 2,368/25/1,87/8759 | 84: 2,368/25/1,87/8759
- **ABTG_GapFill_AUDUSD_OOS_ohlc_r168c.csv** (OOS): 0 byte, nessuna riga.
- **GapFill_225JPY_IS_r168d.csv** (IS, 7 righe, asse MaxHours; PF/n/DD%/profitto): 12: 1,699/26/3,65/4643 | 24: 1,804/26/3,98/5890 | 36: 1,761/26/4,25/5795 | 48: 1,678/26/4,59/5411 | 60: 1,597/26/4,97/4994 | 72: 1,597/26/4,97/4994 | 84: 1,597/26/4,97/4994
- **ABTG_GapFill_225JPY_OOS_r168d.csv** (OOS): 0 byte, nessuna riga.
- **PunteLarry_U30USD_IS_r169a.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,549/55/6,71/12546 | 0.05: 1,762/54/4,07/15634 | 0.10: 1,784/54/3,96/15042 | 0.15: 1,438/53/6,71/8762 | 0.20: 1,627/51/6,51/11023 | 0.25: 1,966/50/5,23/14692 | 0.30: 1,810/50/5,10/12079
- **ABTG_PunteLarry_U30USD_OOS_r169a.csv** (OOS): 0 byte, nessuna riga.
- **PunteLarry_EURAUD_IS_ohlc_r169b.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 0,834/486/33,70/-33049 | 0.05: 0,843/483/31,99/-31356 | 0.10: 0,780/475/40,45/-39925 | 0.15: 0,840/470/30,25/-29672 | 0.20: 0,832/466/31,13/-30577 | 0.25: 0,828/460/30,44/-29908 | 0.30: 0,817/456/31,58/-31073
- **PunteLarry_EURAUD_OOS_ohlc_r169b.csv** (OOS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,048/221/14,18/4856 | 0.05: 1,051/220/14,29/4890 | 0.10: 1,053/216/17,12/4695 | 0.15: 0,983/215/16,15/-1518 | 0.20: 0,982/212/17,10/-1532 | 0.25: 0,970/211/16,40/-2486 | 0.30: 0,950/209/14,90/-3914
- **PunteLarry_XAUUSD_IS_ohlc_r169c.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 0,928/214/29,67/-7438 | 0.05: 0,948/213/29,48/-5196 | 0.10: 0,872/213/29,74/-12461 | 0.15: 0,862/213/29,82/-13214 | 0.20: 0,876/213/27,94/-11862 | 0.25: 0,831/213/27,35/-15763 | 0.30: 0,790/213/29,41/-19265
- **ABTG_PunteLarry_XAUUSD_OOS_ohlc_r169c.csv** (OOS): 0 byte, nessuna riga.
- **PunteLarry_GBPJPY_IS_ohlc_r169d.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,096/369/19,75/18054 | 0.05: 1,103/366/19,02/18909 | 0.10: 1,071/364/19,55/12001 | 0.15: 1,042/362/18,38/6677 | 0.20: 1,043/361/17,17/6617 | 0.25: 1,025/359/18,58/3772 | 0.30: 1,038/358/17,60/5436
- **PunteLarry_GBPJPY_OOS_ohlc_r169d.csv** (OOS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,299/141/9,08/19358 | 0.05: 1,302/139/9,01/18331 | 0.10: 1,288/139/8,95/17221 | 0.15: 1,295/138/8,85/17130 | 0.20: 1,242/138/8,77/14029 | 0.25: 1,192/137/8,65/10993 | 0.30: 1,267/132/7,79/14450
- **PunteLarry_GBPUSD_IS_ohlc_r169e.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,155/324/12,07/21311 | 0.05: 1,129/324/11,52/16917 | 0.10: 1,102/324/12,20/12818 | 0.15: 1,087/324/11,65/10276 | 0.20: 1,097/324/12,22/11088 | 0.25: 1,103/323/10,70/11234 | 0.30: 1,121/322/10,93/12615
- **PunteLarry_GBPUSD_OOS_ohlc_r169e.csv** (OOS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,074/121/9,30/2639 | 0.05: 1,017/121/9,37/607 | 0.10: 1,041/121/8,53/1364 | 0.15: 1,016/121/7,80/524 | 0.20: 0,969/121/7,87/-997 | 0.25: 0,927/121/8,73/-2345 | 0.30: 1,045/119/8,47/1295
- **PunteLarry_EURCAD_IS_ohlc_r169f.csv** (IS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 0,849/236/19,44/-12224 | 0.05: 0,820/236/19,66/-14179 | 0.10: 0,816/236/18,86/-13824 | 0.15: 0,836/236/19,19/-11969 | 0.20: 0,832/236/17,99/-11749 | 0.25: 0,832/236/17,28/-11317 | 0.30: 0,837/236/17,17/-10721
- **PunteLarry_EURCAD_OOS_ohlc_r169f.csv** (OOS, 7 righe, asse SLBufferATR; PF/n/DD%/profitto): 0.00: 1,172/154/6,86/8504 | 0.05: 1,176/154/6,89/8208 | 0.10: 1,338/154/6,96/14779 | 0.15: 1,317/154/6,99/13246 | 0.20: 1,285/154/7,02/11459 | 0.25: 1,272/154/6,87/10569 | 0.30: 1,213/154/6,85/8198
- **EasyTrend_CHFJPY_IS_ohlc_r171a.csv** (IS, 7 righe, asse SLBufferPts; PF/n/DD%/profitto): 0: 0,831/342/34,33/-31015 | 15: 0,817/340/36,19/-32989 | 30: 0,824/338/34,81/-31527 | 45: 0,817/334/34,57/-32191 | 60: 0,811/328/35,91/-32921 | 75: 0,812/328/35,91/-32936 | 90: 0,839/323/31,99/-27638
- **EasyTrend_CHFJPY_OOS_ohlc_r171a.csv** (OOS, 7 righe, asse SLBufferPts; PF/n/DD%/profitto): 0: 1,002/271/20,43/367 | 15: 1,048/267/19,43/7292 | 30: 1,066/265/21,80/9598 | 45: 1,094/264/21,70/13790 | 60: 1,107/260/20,82/15588 | 75: 1,122/258/18,85/17972 | 90: 1,119/256/19,94/17415
- **EasyTrend_GBPUSD_IS_ohlc_r171b.csv** (IS, 7 righe, asse SLBufferPts; PF/n/DD%/profitto): 0: 1,224/589/15,69/112089 | 15: 1,205/587/14,77/96339 | 30: 1,184/583/14,68/85195 | 45: 1,158/582/17,48/70102 | 60: 1,179/580/17,66/78024 | 75: 1,196/579/16,57/89086 | 90: 1,188/574/15,72/84906
- **EasyTrend_GBPUSD_OOS_ohlc_r171b.csv** (OOS, 7 righe, asse SLBufferPts; PF/n/DD%/profitto): 0: 1,071/261/14,76/10670 | 15: 1,073/256/14,68/10784 | 30: 1,053/254/15,84/7640 | 45: 1,065/250/15,80/9393 | 60: 1,085/250/15,75/12258 | 75: 1,090/242/14,69/12882 | 90: 1,081/241/15,19/11251
- **BreakingBand_GBPUSD_IS_ohlc_r174a.csv** (IS, 2 righe, asse BEMode; PF/n/DD%/profitto): 0: 0,714/261/21,95/-17793 | 1: 0,670/261/22,72/-18660
- **BreakingBand_GBPUSD_OOS_ohlc_r174a.csv** (OOS, 2 righe, asse BEMode; PF/n/DD%/profitto): 0: 1,123/260/10,31/7415 | 1: 1,167/260/9,25/8356
- **GapFill_U30USD_IS_r175a.csv** (IS, 2 righe, asse SLMode; PF/n/DD%/profitto): 0: 1,376/30/3,12/4596 | 1: 1,666/30/1,79/3357
- **ABTG_GapFill_U30USD_OOS_r175a.csv** (OOS): 0 byte, nessuna riga.
- **BreakingBand_GBPUSD_IS_ohlc_r176a.csv** (IS, 6 righe, asse BEatATR; PF/n/DD%/profitto): 0.0: 0,754/261/20,75/-15145 | 0.5: 0,719/261/21,26/-17118 | 1.0: 0,714/261/21,95/-17793 | 1.5: 0,751/261/20,36/-15399 | 2.0: 0,754/261/20,75/-15145 | 2.5: 0,754/261/20,75/-15145
- **BreakingBand_GBPUSD_OOS_ohlc_r176a.csv** (OOS, 6 righe, asse BEatATR; PF/n/DD%/profitto): 0.0: 1,131/260/11,41/8124 | 0.5: 1,083/260/11,70/4848 | 1.0: 1,123/260/10,31/7415 | 1.5: 1,089/260/11,40/5633 | 2.0: 1,116/260/11,40/7219 | 2.5: 1,131/260/11,41/8124
- **BreakingBand_GBPUSD_IS_ohlc_r177a.csv** (IS, 5 righe, asse TPRefreshBars; PF/n/DD%/profitto): 0: 0,755/261/20,85/-17093 | 1: 0,714/261/21,95/-17793 | 2: 0,721/261/21,41/-17341 | 3: 0,716/261/21,73/-17790 | 4: 0,736/261/20,58/-16457
- **BreakingBand_GBPUSD_OOS_ohlc_r177a.csv** (OOS, 5 righe, asse TPRefreshBars; PF/n/DD%/profitto): 0: 1,142/260/9,07/9438 | 1: 1,123/260/10,31/7415 | 2: 1,102/260/9,89/6266 | 3: 1,162/260/9,44/9882 | 4: 1,149/260/9,01/9177
- **GapFill_225JPY_IS_r178a.csv** (IS, 2 righe, asse SLMode; PF/n/DD%/profitto): 0: 3,204/11/1,33/4573 | 1: 2,514/11/0,99/1532
- **GapFill_225JPY_OOS_r178a.csv** (OOS, 2 righe, asse SLMode; PF/n/DD%/profitto): 0: 1,144/15/4,36/812 | 1: 1,002/15/2,30/5
