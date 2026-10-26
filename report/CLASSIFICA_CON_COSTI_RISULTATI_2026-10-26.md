# Classifica degli EA con slippage, spread e commissioni: RISULTATI (26/10/2026)
Criteri e previsioni: `CLASSIFICA_CON_COSTI_CRITERI_2026-10-26.md` (commit 0b14bc48); lettore congelato `backtest_pipeline/leggi_classifica_costi.py` (autotest OK). Base: corse continue a 80K, gen 2025-set 2026, tick reali, default del venditore, nessun guardiano. **Gli extra sono IPOTESI (la demo non simula slippage; l'oro sul reale non e misurato).** Tester: commissione gia inclusa (3,46-3,55 EUR/lotto a giro, portata a 4,00 della demo), spread del feed gia incluso, slippage zero.

## Classifica per la regola scritta (margine di costo M = extra per giro, USD/oz, che azzera il netto)
| # | EA | Fascia | M | M 2025 / 2026 | PF C0 -> C2 -> C3 | Netto C0 -> C2 -> C3 (EUR) | DD realizz. C2 | gg >=5% (C2) |
|---|---|---|---|---|---|---|---|---|
| 1 | SomaGold | ROBUSTO | 6,06 | 5,71 / 6,22 | 3,69 -> 3,45 -> 3,23 | 679.489 -> 645.834 -> 612.180 | 15,6% | 2 |
| 2 | Gold Snap | ROBUSTO | 2,67 | 2,80 / 2,63 | 3,14 -> 2,82 -> 2,53 | 1.019.259 -> 904.858 -> 790.457 | 12,5% | 1 |
| 3 | Prop Firm Gold EA | ROBUSTO | 2,47 | 1,80 / 3,75 | 1,25 -> 1,22 -> 1,18 | 34.053 -> 29.912 -> 25.771 | 9,7% | 0 |
| 4 | Rocket Breakout | ROBUSTO | 2,16 | 2,60 / 1,67 | 1,40 -> 1,34 -> 1,27 | 60.332 -> 51.955 -> 43.578 | 9,0% | 0 |
| 5 | SixtyNine | ROBUSTO | 1,81 | 0,99 / 2,13 | 2,01 -> 1,79 -> 1,60 | 301.326 -> 251.415 -> 201.504 | 13,8% | 1 |
| 6 | Smart Gold Hunter | ROBUSTO | 1,35 | 0,76 / 2,23 | 1,77 -> 1,55 -> 1,37 | 276 -> 214 -> 153 | 0,1% | 0 |
| 7 | Umbra Vault | ROBUSTO | 1,16 | 1,07 / 1,22 | 6,81 -> 3,90 -> 2,39 | 194.084 -> 143.779 -> 93.474 | 9,7% | 3 |
| 8 | Entry Points Pro | ROBUSTO | 1,06 | 0,90 / 1,59 | 1,06 -> 1,04 -> 1,03 | 3.023 -> 2.169 -> 1.316 | 9,3% | 0 |
| 9 | Microedge | ROBUSTO | 1,03 | 1,27 / 0,68 | 2,91 -> 2,22 -> 1,64 | 111.551 -> 78.966 -> 46.382 | 9,4% | 5 |
| 10 | Vortex Turbo | TIENE | 0,55 | 1,06 / 0,11 | 1,51 -> 1,22 -> 0,98 | 54.755 -> 25.125 -> -4.505 | **35,3%** | 3 |
| 11 | ORB Revolution | NON TIENE | -0,76 | -1,22 / 0,60 | 0,88 -> 0,84 -> 0,79 | -6.457 -> -8.999 -> -11.540 | 14,7% | 0 |

Scenari (extra per giro sopra il tester): C1 0,15 USD (13 EUR/lotto), C2 0,30 (26 EUR/lotto), C3 0,60 (52 EUR/lotto). Per riferimento lo spread che il tester gia paga e circa 0,20 USD.

## Lettura descrittiva aggiunta DOPO i numeri (dichiarata: la regola scritta ha fasce poco discriminanti, 9 EA su 11 sono ROBUSTO)
Erosione del netto a C2 (quanto netto si perde): SomaGold -5%, Gold Snap -11%, Prop Firm Gold -12%, Rocket -14%, SixtyNine -17%, Smart Gold Hunter -22%, **Umbra -26%, Entry Points -29%, Microedge -30%, Vortex -55%** (a C3 Vortex -108%: va in perdita). Umbra e Microedge perdono molto PF (6,81 -> 3,90; 2,91 -> 2,22) perche vincono quasi sempre piccole cifre per lotto.

## Scorecard delle previsioni
K1 (almeno 3 in FRAGILE o NON TIENE): **NO** (solo ORB). K2 (Gold Snap fra i primi 3 per M): **SI** (2o). K3 (rango per M diverso da rango per netto C0, correlazione < 0,8): **SI** (Spearman 0,61). K4 (SixtyNine sotto la mediana di M, 1,35): **NO** (1,81). K5 (Prop Firm Gold e Smart Gold Hunter in FRAGILE/NON TIENE): **NO**. 2 su 5.

## Limiti
- Extra = ipotesi; lo slippage vero dell'oro si misura solo con un registratore sul reale o su una prop.
- Il costo e sottratto senza ricalcolare il lotto (l'auto-lotto reagirebbe), e **non cresce con la dimensione**: Gold Snap arriva a 51 lotti e SomaGold a 12: a quei lotti lo slippage reale e probabilmente peggiore, quindi per loro il margine e SOVRASTIMATO.
- M e per lotto negoziato; non dice nulla sul drawdown: Vortex ha DD realizzato 35% a C2, SomaGold 15,6%.
- Giorni >=5% sono realizzati (limite inferiore).
- Nessun merito d'acquisto, lotto o taglia.
