# `UBS_sets_profit_factor.xlsx` (Sergio, backtest di Zairex_ su Vantage): analisi (23/11/2026)
Fonte: file allegato da Claudio (copia in `telegram_ubs_2026-11-22/UBS_sets_profit_factor.xlsx`). 3 fogli: "PF above 1.8 (KEEP)" (66), "PF 1.8 or below (REMOVE)" (245), "All sets" (311). Colonne: set, cartella, PF, operazioni, netto, drawdown %, percorso del report. **Periodo, deposito e lotti non sono nel file**; dalla nota Telegram: Vantage, tick reali, 2020 - 22/08/2026, rischio per strategia = 3 (autoloader). Soglia di selezione "keep" = PF > 1,8 (decisa da chi ha fatto il file: **selezione**).
## Distribuzione dei 311 set
Mediana PF **1,41**; PF >= 1,8 in 68 casi (22%), >= 3 in 9. Mediana drawdown 3,1% (max 100%; 60 set sopra il 10%); mediana operazioni 393 (37 set con meno di 100).
| Gruppo (dal nome) | N | PF mediano | DD% mediano |
|---|---|---|---|
| Oro | 74 | 1,74 | 3,5 |
| US30 | 22 | 1,37 | 1,8 |
| EURUSD | 21 | 1,37 | 2,3 |
| Bitcoin | 21 | **0,87** | **45,8** |
| Nasdaq | 20 | 1,42 | 3,5 |
| USDJPY | 14 | 0,92 | 4,2 |
| US500 | 12 | 1,33 | 2,2 |
| TSLA | 11 | 1,75 | 4,8 |
| Argento / Petrolio | 4 / 2 | 1,17 / 1,09 | 19 / 52 |
## Il Dow `g` su un secondo feed
**`US30_VOL_M15_g`: PF 4,23, 319 operazioni, netto 20.459, DD 1,53%** (Vantage, tick reali). Il report di Wim su IC-like: PF 5,39, **318 operazioni**, DD 0,13% (a 0,1 lotti). Stesso numero di operazioni su due feed diversi e PF che resta sopra 4: **il comportamento del `g` e coerente tra feed**; la differenza di PF viene dai costi e dai prezzi del broker.
Gli altri US30 della famiglia: `US30_VOL_M15_b` PF 5,06 (178 operazioni, DD 1,46%), `_c` 1,87, `_a` 1,71. **Solo b e g sono fuori scala** nel gruppo US30 (mediana 1,37): sono i set ottimizzati da Wim a luglio.
## Attenzione
- Il file e un elenco di set di Wim e utenti, ordinato per PF e filtrato a 1,8: ha il problema della selezione. Le percentuali (DD, netto) dipendono dal deposito e dal rischio, ignoti.
- I **Bitcoin hanno PF mediano 0,87 e DD 46%**: coerente con le critiche sulle commissioni e con la nostra difficolta sul BTC.
- Nessun set e nostro; gli EA di Wim restano fuori dal progetto prop.
