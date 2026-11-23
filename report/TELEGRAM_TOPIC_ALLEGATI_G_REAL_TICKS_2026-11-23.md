# Allegati del topic Telegram "My new set files that have potential": inventario e report di Wim sul Dow (23/11/2026)
Fonte: `TG_SET_PARTE1-6.zip` (circa 600 file, 164 MB scompattati). **Mai eseguito niente**: i file `.ex5`, `.rar`, `.py` e `.7z` restano non aperti (dati non fidati). Tutto cio che e di utenti e non verificato.
## Inventario (nomi dei file piu utili)
`real ticks.zip` (report a-h di Wim sul Dow), `CommunitySetfileBench_ICM/TMGM/Vantage.html` (prove dei set della community su tre broker), `Hunting_for_Plateaus_202609.pdf`, `UBS_SETS_ORDERED.zip` (343 file: set per EA e `Ultimate Breakout System Set Files 2025-10.xlsx`), `UBS_EURUSD_M15_VolBreakout_Darwinex_2018-2026.zip`, `new EURUSD VolBreakout.zip`, `ubs-us500-m15-report-sets.zip`, `US30_UBS_C/H_Daily` (report 2018-2025), `Us_500_daily.zip`, `XAGUSD.zip`, `btcusd_Volatility.zip`, `UBS_v2_summary_en.pdf`, `1ohlc vs rt` (confronto barre da 1 minuto contro tick reali), `BitcoinReaper2/3Spread.htm`, `Zairex_Community_Pack.rar` (non aperto), due script `ubs_autopsy3.*.py` di utenti (non eseguiti), `RESULTS.md` e molti `.set` (US30_1H_Scalp A-D, XAG, ETH, AAPL, TSLA, USDJPY D1 e altri).
## Report di Wim sul Dow con tick reali (`real ticks.zip`, set a-h, US30 H1, 2020.01.01-2026.07.19, deposito 100.000, StartLots 0,1)
| Set | Netto | PF | DD equity | Operazioni | RF |
|---|---|---|---|---|---|
| a / e | 1.285,61 | 1,87 | 150,18 (0,15%) | 276 | 8,56 |
| b | 551,95 | 3,99 | 243,22 (0,24%) | 180 | 2,27 |
| c | 540,24 | 1,67 | 157,94 (0,16%) | 335 | 3,42 |
| d | 571,94 | 1,60 | 139,20 (0,14%) | 378 | 4,11 |
| f | 690,59 | 5,25 | 127,78 (0,13%) | 183 | 5,40 |
| **g** | **1.280,48** | **5,39** | **133,28 (0,13%)** | **318** | **9,61** |
| h | 1.071,13 | 2,14 | 156,73 (0,16%) | 317 | 6,83 |
**g anno per anno** (uscite del report, netto di commissioni e swap): 2020: 17 operazioni, +129,2, PF 45,3; 2021: 32, +78,2, PF 6,5; 2022: 41, +156,0, PF 10,5; 2023: 55, +250,7, PF 12,9; 2024: 62, +263,6, PF 8,9; 2025: 70, +201,3, PF 2,3; 2026: 41, +201,4, PF 5,3. **2020-21 (prima dell'in-sample di Wim, 2022-2026): 49 operazioni, PF 13,2; 2022-26: 269 operazioni, PF 4,9.**
## Lettura
- Il report di Wim e coerente con le nostre misure di ordine di grandezza (DD circa 133 per 0,1 lotti contro i nostri circa 95; circa 49-59 operazioni all'anno). Il PF di Wim e molto piu alto del nostro, ma e su un feed e costi suoi.
- **Un PF 13 fuori campione (2020-21) piu alto del PF in-sample (4,9) e insolito**: puo essere campione piccolo (49 operazioni), un feed generoso, o un effetto del set che non dipende dal periodo. **Non e una prova**: la verifica indipendente e il nostro test sul feed FTMO 2020-2026 (riga `RIGA_UBS_G_FTMO.txt`, ancora da lanciare).
- Il netto assoluto e piccolo (circa 4 per operazione a 0,1 lotti): il vantaggio sta nei costi bassi; sul feed con spread reale dipende da cosa costa il Dow.
