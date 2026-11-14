# UBS: catalogo del pacchetto UPDATED_SETS_UBS_V9_0 (382 set) e confronto con i 283 set usati nei test U1-U4 (14/11/2026)

**Natura**: inventario e confronto di file, NON un test di rendimento. Fonti: `UPDATED_SETS_UBS_V9_0.zip` (caricato il 31/10, 382 file `.set`, 5,8 MB) e `Ultimate-Breakout-System-Set-Files.zip` (283 `.set`, 09/11; e il pacchetto usato dai test U1-U4, dichiarato nel generatore `gen_riga_ubs_u2.py`: `ZIP = 'Ultimate-Breakout-System-Set-Files.zip'`). I file originali restano fuori dal repo; qui solo i cataloghi (`UBS_CATALOGO_dati/`: due CSV con simbolo, timeframe, HistoricalMaxDD, Risk, lotti, NFP, ecc. per ogni set; elenco delle differenze; script `cat.py`). Pacchetti che abbiamo e non ho aperto in questo giro: `AllSetsAndManuals.zip` (124 set + 13 PDF), zip per singolo EA, `ubs_onechart_live_MainEA_Settings.set`, EA `Ultimate_Breakout_EA_WSC_V9.5.ex5`, manuale V9.0.

## Contenuto del pacchetto V9.0 (382 set)
| Gruppo | N. set |
|---|---|
| Client sets (BK, Till, MisterMember Xmas, BaSa, StoryG, hangsan) | 120 |
| Breakout_Support_Resistance / GOLD (Reaper, Phantom, Goldbot One, Goldtrade Pro, Scalp, vecchie ottimizzazioni) | 84 |
| UBS live portfolio (il portafoglio live di Wim) | 44 |
| Volatility Breakout | 39 |
| Indicement | 21 |
| Bitcoin Reaper | 19 |
| Daytrade Pro | 16 |
| ORB Master | 12 |
| Other sets | 12 |
| Advanced Scalper | 10 |
| Range Breakout, Bitcoin Scalp Pro | 3 + 2 |

Per simbolo: XAUUSD 125, BTCUSD 41, EURUSD 39, US30 35, TSLA.NAS 29, USTEC 24, USDJPY 21, US500 17, XAGUSD 9, XTIUSD 7, DE40 5, altri; 13 senza simbolo (set di ottimizzazione o modelli). `HistoricalMaxDD` presente in 366 set; `Risk=0` in 340 (lotto fisso), `Risk=123` ("use Max Risk Per Strategy") in 39; `StartLots=0,1` in 300 e 0,01 in 81; filtro NFP acceso in 153, spento in 229. La dicitura di Wim "oltre 350 set pronti" (10/11) e coerente con 382, non con 283.

## Confronto con i 283 set dei test U1-U4
- **253 set identici byte per byte** in entrambi; **129 solo nel nuovo**; **44 solo nel vecchio**; **43 con lo stesso nome e contenuto diverso**.
- Dei 43: **40 hanno parametri con valore cambiato**, 3 solo campi aggiunti o tolti (formato V9.0: es. `OnlyLoaderForceSymbol`, `overrideProp`, `MQL5_CalendarDays`, `BacktestSpeed`). I 283 sono quindi in formato piu vecchio.
- **Cambiamento piu rilevante: `UseConfirmationCandleA` (20 set) e `UseConfirmationCandleD` (9 set) da `false` a `true`.** Riguarda TUTTI gli 8 set "daily" del Goldbot One (dailyA-K) e TUTTI gli 8 set del Goldtrade Pro (GOLDTRADEPRO_a..H, H4_b). Cosa faccia l'impostazione (candela di conferma sull'ingresso) NON e verificato sul manuale V9.0 qui: va letto. Il nome dice che aggiunge una conferma di candela all'entrata.
- Altri cambi di valore: `HistoricalMaxDD` in 10 set (es. Gold Phantom strat5 283 -> 74, strat4 146 -> 216; BaSa gold d1: 30 -> 105/146/170/208), `EnableNFP_Filter` da false a true in 7 set (nel "UBS live portfolio": US100_1, US100_4, dailyK, GOLDTRADEPRO_d, E, H), parametri di uscita del Reaper (strategy1_Daily: Exit_TrailTP_size 1600/700, Exit_HL_countback 0 -> 50, ...; strategy7: ST1_UpDiff -60 -> -10; strategy8 e 9: Exit_HL_trailingSL_timeframe 0 -> 16385), `UseEveryTick` false -> true in 2 set Scalp, parametri di Daytrade Pro.

## Il portafoglio live di Wim (cartella "UBS live portfolio", 44 set)
Con `ubs_onechart_live_MainEA_Settings.set` e lo zip `UBS 44Strat_live portfolio.zip`. Per simbolo: XAUUSD 14, EURUSD 8, US30 6, BTCUSD 6, USTEC 4, US500 3, CHFJPY 1, GBPUSD 1. **I 14 set XAUUSD** (HistoricalMaxDD in $ a 0,01 lotti come scritto nel set; nfp = filtro NFP): DaytradePro_XAUUSD 220; GOLDTRADEPRO_E 40, _H 50, _d 100; Gold_a 30, Gold_b 30, Gold_c 50 (Phantom daily); dailyK 104 (Goldbot One); strategy4_H4 52, strategy5_H1 110, strategy6_H1 140, strategy7_H1 90 (Reaper); M5_C 600 e M5_H 530. Dichiarazione del pacchetto, non verificata nel live. Nei set live del Goldbot e del GTP il NFP e acceso e `UseConfirmationCandle=true`.

## Cosa significa per noi
1. **I nostri test UBS (U1-U4) sono stati fatti sul pacchetto da 283 set, che per Goldbot One (daily) e Goldtrade Pro ha la candela di conferma SPENTA; nel pacchetto V9.0 e ACCESA.** I set provati in U3 che cambiano sono `dailyC`, `dailyI` (Goldbot One) e `GOLDTRADEPRO_E`, `GOLDTRADEPRO_a`; i set Phantom (`Gold_Phantom_strat8`, `strat3`, `Gold_c`) sono identici. Non so quale dei due pacchetti rappresenti la versione "corretta" di Wim, ne se la candela di conferma cambia il rendimento: NON MISURATO. Il pacchetto V9.0 ha il formato piu recente (campi V9.0) e coincide con la versione dell'EA (V9.5) che usiamo.
2. **I verdetti U3/U4 sui 4 set interessati vanno considerati validi solo per la versione senza conferma** finche non rifacciamo la prova con il set V9.0.
3. I 44 set live sono il riferimento piu vicino a cio che Wim fa girare davvero: possono servire a confrontare i nostri set oro e il rischio dichiarato (Reaper strategie 4-7, GTP E/H/d, Goldbot dailyK, Phantom Gold_a/b/c).
4. **Nessuna riga e stata lanciata e nessun numero di rendimento e stato misurato in questo giro.**

## Prossimo passo proposto (da decidere: nessun test lanciato)
Rifare la prova U3 solo sui 4 set cambiati (dailyC, dailyI, GOLDTRADEPRO_E, GOLDTRADEPRO_a) con la versione V9.0, stessi periodi, stesso deposito e stesso metodo di U3, e confrontare con le versioni senza conferma. Criteri e previsioni da fissare prima della riga. Costo stimato: poche ore di tester (4 set x 2 versioni x 2 periodi, a candele da 1 minuto).
