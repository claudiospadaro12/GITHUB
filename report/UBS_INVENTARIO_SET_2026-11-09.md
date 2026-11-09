# UBS: inventario dei set del pacchetto di Wim (09/11/2026)

Fonte: `Ultimate-Breakout-System-Set-Files.zip` caricato da Claudio il 09/11/2026 (283 file `.set`, tutti letti; i set originali restano fuori dal repo, qui solo l'inventario). Script: lettura dei campi `ForceSymbol`, `Risk`, `StartLots`, `HistoricalMaxDD`, `MaxRiskPerStrategy_Value`, `EA_MagicNumber`. **Non misurato nulla**: e un inventario, non un test.

## Cosa contiene

| Cartella | N. set | Simboli principali |
|---|---|---|
| client sets | 50 | XAUUSD (16), TSLA.NAS (14), US30 (7) |
| ORB Master | 12 | USTEC (3), DE40 (3), US30 (3) |
| Other sets | 86 | XAUUSD (53), BTCUSD (15), USTEC (10) |
| bitcoin Scalp Pro(H1) | 2 | (nessuno) (1), BTCUSD (1) |
| Bitcoin Reaper | 19 | BTCUSD (19) |
| GOLD | 41 | XAUUSD (38), (nessuno) (3) |
| Advanced Scalper | 10 | USDJPY (4), EURUSD (4), (nessuno) (1) |
| Daytrade Pro | 13 | EURNZD (1), USDCAD (1), NZDUSD (1) |
| Range Breakout | 2 | USDJPY (1), XAUUSD (1) |
| Indicement | 17 | US500 (6), US30 (4), USTEC (4) |
| volatility breakout | 31 | BTCUSD (8), EURUSD (7), USTEC (5) |

**XAUUSD: 113 set** (111 con `HistoricalMaxDD`), BTCUSD 43, USTEC 22, US30 18, EURUSD 16, TSLA.NAS 14, USDJPY 12, US500 12, DE40 5, XAGUSD 3, il resto forex.

## Cosa notiamo nei set

- **Tutti i set sono nel formato `valore||default||passo||min||flag`** (lo stesso dei set combo di Wim): il nostro script del tester li legge con `-SetFile`.
- **`Risk=0` in 281 set su 283, `StartLots=0,1` in 238** (0,01 in 45): i set sono consegnati a **lotto fisso**, cioe nella configurazione con cui Wim misura il DD storico. `MaxRiskPerStrategy_Value=2,0` e `HistoricalMaxDD` sono presenti ma il lotto da rischio si attiva solo cambiando `Risk` (valore da leggere sul manuale: **NON VERIFICATO**; negli EA del bundle `Risk=3` e il lotto da rischio per strategia).
- **I set dei nostri quattro EA oro ci sono, in formato UBS**: cartelle `GOLD/Gold Reaper` (strategy1-9: giornaliere, H4 e H1, `HistoricalMaxDD` 30-700), `GOLD/Gold Phantom` (strat1-9: DD 50-720), `GOLD/Goldbot One` (dailyA-K, DD 25-104), `GOLD/Goldtrade Pro` (8 set, DD 40-100). Conferma che i nostri EA sono insiemi di strategie UBS (come dice Wim).
- **Altri campi, contati su tutti i 283 set**: `UseAutoLoader=false` in 272 (11 senza il campo); `AutoGMT=true`, `OnlyUp=true` e `CheckMargin=true` in **tutti**; `RandomizationValue` 0 in tutti i set in cui compare (10 senza il campo: nei set oro di Wim e **0**, non 50 come nei set prop dei nostri EA); filtro NFP acceso in **102** set e spento in 181; filtro spread acceso in 152; fasce orarie (`UseTradingTimeZones`) accese in 49; `AdjustLotsizeToVariableValues=true` in 246; `PropFirmMaxDailyDD=0` in tutti (nessun limite prop nei set). Licenza: `URLB=https://forexeasolutions.services` e `Lic_key` vuota: la licenza dell'UBS che Claudio ha comprato e **da verificare sul PC** (NON VERIFICATO se il tester la accetta).

## I set oro dei quattro EA di Wim (HistoricalMaxDD in $ a 0,01 lotti, come scritto nel set)

| Famiglia | Set | DD storico dichiarato (set) | Timeframe |
|---|---|---|---|
| Gold Phantom(daily) | Gold_a | 30 | D1 |
| Gold Phantom(daily) | Gold_b | 30 | D1 |
| Gold Phantom(daily) | Gold_c | 50 | D1 |
| Gold Reaper | optimization | None | 0 |
| Gold Reaper | strategy1_Daily | 60 | D1 |
| Gold Reaper | strategy2_Daily | 30 | D1 |
| Gold Reaper | strategy3_Daily | 35 | D1 |
| Gold Reaper | strategy4_H4 | 52 | H4 |
| Gold Reaper | strategy5_H1 | 110 | H1 |
| Gold Reaper | strategy6_H1 | 140 | H1 |
| Gold Reaper | strategy7_H1 | 90 | H1 |
| Gold Reaper | strategy8_H1 | 130 | H1 |
| Gold Reaper | strategy9_H1 | 700 | H1 |
| GOLD (altri) | Gold_Phantom_strat1 | 57 | D1 |
| GOLD (altri) | Gold_Phantom_strat2 | 50 | D1 |
| GOLD (altri) | Gold_Phantom_strat3 | 99 | D1 |
| GOLD (altri) | Gold_Phantom_strat4 | 146 | H4 |
| GOLD (altri) | Gold_Phantom_strat5 | 283 | H4 |
| GOLD (altri) | Gold_Phantom_strat6 | 476 | H1 |
| GOLD (altri) | Gold_Phantom_strat7 | 400 | H1 |
| GOLD (altri) | Gold_Phantom_strat8 | 720 | H1 |
| GOLD (altri) | Gold_Phantom_strat9 | 600 | H1 |
| Goldbot One | Optimization | None | 0 |
| Goldbot One | dailyA | 38 | D1 |
| Goldbot One | dailyB | 75 | D1 |
| Goldbot One | dailyC | 27 | D1 |
| Goldbot One | dailyD | 38 | D1 |
| Goldbot One | dailyE | 25 | D1 |
| Goldbot One | dailyH | 69 | D1 |
| Goldbot One | dailyI | 83 | D1 |
| Goldbot One | dailyK | 104 | D1 |
| Goldtrade Pro | GOLDTRADEPROH4_b | 90 | H4 |
| Goldtrade Pro | GOLDTRADEPRO_E | 40 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_F | 60 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_G | 40 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_H | 50 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_a | 60 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_c | 40 | D1 |
| Goldtrade Pro | GOLDTRADEPRO_d | 100 | D1 |
| Goldtrade Pro | optimization_gold | None | 0 |
| GOLD (altri) | ScalpH1_C | 15 | H1 |
