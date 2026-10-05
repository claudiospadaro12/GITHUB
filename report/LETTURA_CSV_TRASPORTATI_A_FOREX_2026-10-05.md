# LETTURA DEI CSV TRASPORTATI - FAMIGLIE FOREX "DI AGOSTO" (G4) + PTE + SUPERTREND (225JPY, ORO) - 05/10/2026

> **DOCUMENTO INTERNO. BOZZA, NON PASSATA DAL CANCELLO.** Non va a Claudio ne' al VPS prima del PASS di `controllo-preventivo` (CLAUDE.md, 09/09).
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
8. Le soglie congelate **nei file prova** (S1-S7, B1-B6) le ho applicate **solo a R161a** (sez. 5.1), perche' e' l'unica che ho letto per intero: per gli altri round **[NON COPERTO]** (sez. 9).

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

**I 19 file a 0 byte sono tutti la gamba OOS di un round con `@FRAZIONEIS 1.0`** (una tranche sola: la gamba OOS e' vuota per costruzione, classe 395; `RIGA_SOTTILE_ROUND` la scrive `NON MISURATO -- CSV DA 0 BYTE` e chiude con codice 2): GapFill r157a, r159a, r167a-d, r168a-d, r175a (11) · PunteLarry r156a, r160e, r169a, r169c (4) · BreakingBand r161b · GapContinuation r162a · PTE r158a · SupertrendReversal r166a (4). **Verifica**: in tutti e 19 i casi la gamba IS dello stesso round e' presente e **tutte le sue righe hanno Trades > 0** (minimo n=11). Quindi "uscita 2 = NON MISURATO" del runner e' **una lettura del runner sulla sola gamba OOS vuota**: i numeri della gamba IS (= finestra intera) esistono e li leggo come **finestra piena, senza OOS** (etichetta **s.OOS**: non conta come prova di merito, piano 5.2.2).

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
- **Round con IS e OOS veri**: 22 (r127b, r127c, r139c, r146a, r146c, r153a, r160a-d, r161a, r164a, r169b, r169d-f, r171a, r171b, r174a, r176a, r177a, r178a).
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
- **Asse SL (OOS)**: PF 0,953 / 1,031 / 1,095 / **1,123** / 1,059 / 1,161 / 1,152 con DD 20,69 / 18,63 / 13,11 / **10,31** / 9,79 / 7,79 / 7,91. **Il DD scende (quasi monotono) con lo stop piu' largo** in entrambe le gambe (IS 36,11 -> 16,05 con un'unica risalita, 2,5 = 21,84 -> 3,0 = 21,95; OOS 20,69 -> 7,79 con un'unica risalita, 4,0 = 7,79 -> 4,5 = 7,91). **Il segno non cambia mai con l'uscita**: cambia con la finestra (6 valori su 7 invertiti IS->OOS).
- **EURUSD pattern 0 (772162), finestra intera 1999-2026, s.OOS**: viva **1,075 / 276 / 8,24 / +4.132** (= R102). Asse SL: 1,5 **0,822** (DD 28,44) · 2,0 **0,942** (17,05) · 2,5 1,072 · **3,0 1,075** · 3,5 1,057 · 4,0 1,070 · 4,5 1,004. 5 SOPRA / 2 SOTTO; la viva sta nell'altopiano 2,5-4,0 (PF 1,057-1,075).
- **Ricostruzione 27,5 anni GBPUSD [DERIVATO]** sommando GP e GL delle due gambe (ogni gamba riparte da 100k, quindi non e' una misura): PF ~0,915, profitto ~-10.378, n 521 contro R102 **0,897 / -11.574 / 522**.
- **Sentinelle congelate di R161a lette sul CSV (sez. 5.1)**: S1 PASS (521), S2 PASS (261/260 >= 150), S3 PASS (7 righe/CSV), S4 PASS (7 valori), S5 PASS (n SL 1,5 = n SL 2,0), S6 PASS, **S7 NON PASSA nella gamba IS (DD 36,11% > 35,0% alla cella SL 1,5)**; celle con DD > 10%: **IS 7 su 7, OOS 4 su 7** (viva inclusa, 10,31%).
- **Classe**: GBPUSD viva = **SOTTO in IS 1999-2012 (n261, B-scr) / SOPRA in OOS 2012-2026 (n260, B-scr) = SEGNO INVERTITO**; EURUSD = SOPRA formale s.OOS (n276, B-scr). Regimi dentro la finestra (crisi 2008 in IS; covid 2020, orso 2022 in OOS): **NON separati** nei CSV = NON MISURATO. AUDUSD: NON LEGGIBILE.
- **Certificato (5 caselle, per le celle SOTTO)**: (1) PF si (2) n e DD si (3) **uscita ad asse: LETTA** (4 assi, GBPUSD; EURUSD solo SL; AUDUSD NON LEGGIBILE; `InpTPMode=1` e il TP mai) (4) gemelli si (G4: 7 simboli + 48 di scan) (5) TF si (M15, M30, H1, H4: G4 R3) -> con questi CSV **la casella 3, che G4 teneva "misurata ma illeggibile", si chiude**.

### 4.2 ABTG_CostToCost (H4, long) - round r127c [B], r146a [T], r146c [T]
- **r127c** EURJPY `exit 2`, [B], 2020.01.01-2022.08.06 / 2022.08.07-2026.06.30: IS **8/8 SOPRA** (1,148-1,220; n153-161; DD 10,99-12,17), OOS **8/8 SOPRA** (1,452-1,524; n242-257; DD 12,25-12,26). Viva (100): **IS 1,177 / 153 / 10,99 / +13.369; OOS 1,523 / 242 / 12,26 / +71.284**, peggior giornata **-4,216% IS / -8,016% OOS**. `InpMaxBarsHold` **inerte da 75 a 200** (6 righe su 8 identiche). = G4 2b: **nessuna differenza**.
- **r146a** EURJPY `exit 2`, **tick [T]**, IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30, asse `InpSLBufferATR` 0,0-0,8 (9): **IS 1 su 9 SOPRA** (solo la viva 0,2: **1,016 / 48 / 9,93 / +363**, vicine 0,1 = **0,773** e 0,3 = **0,940**: cella isolata), **OOS 9 su 9 SOPRA** (1,741-2,106; n62-64; DD 5,68-12,11). **8 valori su 9 invertiti IS->OOS**. Viva OOS **1,741 / 64 / 9,45 / +22.252**: e' la **piu' bassa** delle 9 celle OOS. Il buffer alza lo stop e **abbassa il DD in entrambe le gambe** (IS 14,74 -> 6,91; OOS 12,11 -> 5,68; peggior giornata OOS a 0,0 **-6,73%**, a 0,8 **-2,51%**; viva IS -3,74%, OOS -4,00%).
- **r146c** GBPCAD `exit 1`, tick, stesse finestre: **IS 9/9 SOPRA** (1,015-1,298; n39-47; DD 5,07-6,97), **OOS 8/9 SOPRA** (0,920-1,466; n47-66; DD 6,19-9,95). Viva **IS 1,298 / 44 / 5,11 / +7.343; OOS 1,443 / 62 / 6,19 / +15.446**. L'unica SOTTO e' **SLBuffer 0,8 in OOS (0,920, DD 9,95)** mentre in IS la stessa cella e' **1,095**: inversione **nel verso opposto** (SOPRA -> SOTTO).
- **Classe**: EURJPY viva = SOPRA formale (IS 1,016 e' indistinguibile da 1) / SOPRA OOS; **dato tick per r146 (non barre)**; n IS 48, OOS 64 = C. r127c = B-scr (n242). GBPCAD tick = SOPRA C (WF corto) (G4: SOTTO a 6,5 anni [B], 0,92 n382 DD 41,5%: **non in questi CSV**).
- **Certificato**: (1)(2) si (3) **uscita: SLBufferATR a tick letto su 2 simboli + MaxBarsHold [B]** (+ ExitMode in scan G4) -> **si chiude** (4) si (48) (5) si (H1, H4) -> **5/5 sulle celle SOTTO di G4** (short 0,112, L+S 0,770, CHFJPY, XAG, GBPCAD 6,5 anni).

### 4.3 ABTG_EasyTrend (H1, L+S, TP 1,5R, [B]) - round r171a (CHFJPY), r171b (GBPUSD)
- IS **1999.01.01-2019.12.31**, OOS **2020.01.01-2026.06.30** `[DERIVATO]`; asse `InpSLBufferPts` 0-90 (7).
- **CHFJPY**: **IS 0/7 SOPRA** (0,811-0,839; n323-342; DD 31,99-36,19%; profitto -27.638/-32.989) -> **OOS 7/7 SOPRA** (1,002-1,122; n256-271; DD 18,85-21,80). Viva (30): **IS 0,824 / 338 / 34,81 / -31.527; OOS 1,066 / 265 / 21,80 / +9.598**. **Segno invertito 7/7**. Nel round **tutte e 14 le celle hanno DD > 18%**.
- **GBPUSD**: **IS 7/7 SOPRA** (1,158-1,224; n574-589; DD 14,68-17,66; profitto +70.102/+112.089), **OOS 7/7 SOPRA** (1,053-1,090; n241-261; DD 14,68-15,84). Viva (30): **IS 1,184 / 583 / 14,68 / +85.195; OOS 1,053 / 254 / 15,84 / +7.640**. Nessuna inversione; il PF scende da 1,18 a 1,05.
- **Classe**: GBPUSD SOPRA in entrambe le gambe, n >= 150 in entrambe, [B]: **B-scr**, ma **DD > 14% in 14/14 celle** a rischio 1% (nessuna cella sotto il muro del 10%); CHFJPY **SOTTO in IS / SOPRA in OOS (inversione)**, DD 22-35%. Regimi: NON separati.
- **Certificato**: (3) **SLBufferPts letto** (+ `InpTP_R` di R48) -> si; **(5) TF: H1 e basta -> APERTA**. Resta **NON ANCORA MISURATO sul TF** (invariato rispetto a G4).

### 4.4 ABTG_GapFill (H1) - round r157a, r159a, r175a (U30USD), r167d, r168d, r178a (225JPY), r167a-c, r168a-c (forex)
- **Finestra intera, senza OOS (s.OOS)** in 11 round su 12; solo **r178a** ha IS 2024.09.26-2025.06.09 / OOS 2025.06.10-2026.06.30. **n per cella: 20-30 sulle finestre intere, 11 (IS) e 15 (OOS) in r178a**; nessuna cella con Trades=0.
- **Cella viva per simbolo (finestra intera)**: GBPUSD fill100 (**1,763 / 21 / 4,02 / +4.536**, [B] 1999-2026) · EURUSD fill50 (**3,509 / 20 / 1,86 / +5.436**, [B]) · AUDUSD fill100 (**2,369 / 25 / 1,87 / +8.763**, [B]) · 225JPY fill75 (**1,678 / 26 / 4,59 / +5.411**, tick 21 mesi) · U30USD fill100 (**1,376 / 30 / 3,12 / +4.596**, tick 21 mesi). r178a: IS **3,204 / 11 / 1,33 / +4.573**, OOS **1,144 / 15 / 4,36 / +812**.
- **Asse stop `InpSLGapMult` 0,4-2,2** (5 simboli x 7 = 35 celle): **SOTTO 3 celle, tutte a 0,4** (GBPUSD **0,452**, DD 12,30; EURUSD **0,685**, DD 7,70; 225JPY **0,606**, DD 9,09); EURUSD a 0,7 e' 1,006 (sul filo); AUDUSD e U30USD a 0,4 sono SOPRA (1,618; 1,237). **Da 1,0 in su 25 celle su 25 SOPRA** (5 valori x 5 simboli; minimo 1,329). EURUSD sale da 3,509 (1,0) a 6,29 (2,2) con DD 1,86 -> 0,92.
- **Asse time-stop `InpMaxHours` 12-84** (35 celle): **solo U30USD a 12 h e' SOTTO (0,837)**; da 24 h in su **30/30 SOPRA** (minimo 1,376). Da 60 h (GBPUSD, 225JPY, U30USD) o da 48 h (EURUSD, AUDUSD) le celle sono **identiche fra loro**: il time-stop non morde oltre. Rispetto alla viva (48 h) **36 h e' migliore su 5/5 simboli**; **24 h su 4/5** (non su EURUSD: 2,906 contro 3,509).
- **Asse `InpSLMode` 0/1**: U30USD (intera) PF 1,376 -> **1,666**, DD 3,12 -> **1,79**; 225JPY IS 3,204 -> 2,514 e **OOS 1,144 -> 1,002 (profitto +812 -> +5), DD 4,36 -> 2,30**: i due simboli **non vanno nella stessa direzione**.
- **SOTTO totali: 4 celle su 76** (le tre `SLGapMult` 0,4 e `MaxHours` 12 U30USD). **Tutte le altre sono SOPRA, ma tutte su n 11-30 e (salvo r178a) senza OOS: D** (piano 5.4; U30USD n30 e' C al limite).
- **Frequenza**: forex 20-25 trade in **27,5 anni** per simbolo (0,73-0,91/anno); sottraendo le operazioni di R103 (2020-2026, G4: AUDUSD 17, GBPUSD 13, EURUSD 14) restano **8 (AUDUSD) / 8 (GBPUSD) / 6 (EURUSD)** prima del 2020 `[DERIVATO]`. Indici 21 mesi: 26-30 (15-17/anno). **n >= 150 non e' raggiungibile con la storia disponibile** (vedi sez. 8 S2).
- **Certificato**: (3) **SLGapMult, MaxHours, SLMode letti** + FillPct (G4) -> **si chiude**; (4) si (10); **(5) TF: H1 e basta (28 CSV G4 + questi) -> APERTA**. Resta NON ANCORA MISURATO **solo per il TF**.

### 4.5 ABTG_GapContinuation (225JPY M1, tick, 100k, 1%) - round r162a
- Finestra intera 2024.09.26-2026.06.30 (FrazioneIS 1,0), asse `InpPartialTargetR` 0,50-2,50 (9), `InpPartialClosePercent=40`: **9 su 9 SOPRA**, PF 1,269-1,582, **n 84-124 deal** (decresce al crescere dell'asse), DD 6,94-12,78%, profitto +8.928/+13.108. Viva (1,00): **1,385 / 109 / 11,59 / +11.262**, peggior giornata -1,05%. Il massimo (PF 1,582, DD **6,94%**) sta **sul bordo basso dell'asse (0,50)**; DD > 10% in **8 celle su 9**.
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
- **Classe OOS** (n posizioni): EURAUD 216 e EURCAD 154 = **B-scr**; GBPJPY 139, GBPUSD 121 = **C-scr**; U30USD 54 (tick, s.OOS) = **C**.
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
- **Cella viva da SOTTO (IS) a SOPRA (OOS)**: **6 oggetti unici** (BB GBPUSD pattern 2; PunteLarry EURAUD; PunteLarry EURCAD; EZ CHFJPY; PTE 771332; SupRev Ott XAUUSD H4), che compaiono in **11 round** (r127b, r153a, r160a, r160b, r161a, r169b, r169f, r171a, r174a, r176a, r177a). In questi 11 round **69 celle IS su 69 sono SOTTO e 61 celle OOS su 69 sono SOPRA**: **nessun asse d'uscita, in nessuno dei 11 round, riporta una cella IS sopra 1** (le celle contano la viva piu' volte). La gestione dell'uscita sposta PF e DD di qualche decimo ma **non cambia il segno: lo cambia la finestra**.
- **Non invertono**: C2C r127c (SOPRA/SOPRA), EZ GBPUSD (SOPRA/SOPRA, PF cala), Larry GBPJPY e GBPUSD (SOPRA/SOPRA), GapFill 225JPY r178a (SOPRA/SOPRA), Fibo r139c (SOTTO/SOTTO), PTE 771322 r164a (SOTTO/SOTTO sulla viva).
- **Altri versi**: C2C EURJPY r146a (tick) **8 valori su 9** con IS SOTTO e OOS SOPRA (la viva e' l'unica IS sopra 1, isolata); C2C GBPCAD r146c SLBuffer 0,8 **SOPRA in IS (1,095) -> SOTTO in OOS (0,920)**.
- **Regime dichiarato (Regola A del 16/08)**: gli IS lunghi 1999/2000/2004 -> 2012/2013/2019 contengono la crisi 2008; gli OOS (2012/2013/2020 -> 2026) contengono covid 2020, orso 2022, risalita 2025. I CSV **non separano i regimi**: ogni PF e' un numero unico per la gamba = **per regime: NON MISURATO**.

### 5.2 Sentinelle congelate di R161a (le uniche applicate)
Vedi 4.1. L'**unico fallimento** e' S7 (nessuna cella con DD > 35,0%): **IS SL 1,5 = 36,11%**. Il file prova dice "se una cella lo rompe, si scrive SUBITO, prima di qualunque PF". B2: in testa al referto andava scritto "quante celle su sette stanno sopra il 10%": **IS 7/7, OOS 4/7**. B5: "il round non promuove niente". Lettura **del criterio congelato, non una interpretazione nuova**.

---


## [IN LAVORAZIONE] sezioni 6-9 (cosa cambia nei verdetti, smentite, NON COPERTO, dubbi) e Appendice A (414 righe) seguono nel commit successivo.
