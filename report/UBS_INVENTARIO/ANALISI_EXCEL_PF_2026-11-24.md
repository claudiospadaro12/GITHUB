# Analisi forense dell'Excel dei PF (312 set, Vantage a tick, 2020-2026) - 24/11/2026
Fonte: `UBS_sets_profit_factor.xlsx` (Zairex_, Telegram UBS). **Colonne disponibili: PF, operazioni, utile netto, DD%.** Recovery Factor e Sharpe NON ci sono nel file (si ricalcolano solo dai report htm dei set, non scaricati). Tutti i numeri sono DICHIARATI dalla fonte, non nostri: sono lo stesso periodo e lo stesso feed per tutti i set, quindi servono per confrontarli fra loro, non come promessa.

- Set: 311; PF mediano 1.41; PF >= 1,80: 68; PF >= 3: 9; PF < 1,2: 86
- Operazioni: mediana 393; set con < 100 operazioni: 37; con < 60: 16
- DD%: mediana 3.14; DD > 3%: 166

## Top 15 per PF (con operazioni e DD)
| set | fam | PF | op | DD% | netto |
|---|---|---|---|---|---|
| DaytradePro_EURUSD | EURUSD | 5.24 | 393 | 1.8 | 22313 |
| US30_VOL_M15_b | US30 | 5.06 | 178 | 1.46 | 7288 |
| e | altro/ignoto | 4.3 | 55 | 3.09 | 58979 |
| US30_VOL_M15_g | US30 | 4.23 | 319 | 1.53 | 20459 |
| d | altro/ignoto | 4.02 | 63 | 3.01 | 52162 |
| g | altro/ignoto | 3.33 | 104 | 3.33 | 59852 |
| DaytradePro_GBPUSD | GBPUSD | 3.01 | 195 | 1.92 | 8982 |
| MT5_B | altro/ignoto | 3.01 | 285 | 1.23 | 15139 |
| dailyF | altro/ignoto | 3.0 | 100 | 2.83 | 26617 |
| 9637069_storyG_eurusd g357 d1 storyg | EURUSD | 2.91 | 31 | 1.31 | 13977 |
| Breakout_Support_Resistance_GOLD_Goldtrade_Pro__GOLDTRADEPRO_E | oro | 2.9 | 113 | 2.0 | 29621 |
| GOLD_Gold_Phantomdaily__Gold_b | oro | 2.89 | 109 | 1.37 | 30525 |
| UBS_live_portfolio__GOLDTRADEPRO_E | oro | 2.88 | 112 | 2.22 | 29219 |
| Breakout_Support_Resistance_GOLD_Gold_Phantomdaily__Gold_b | oro | 2.87 | 109 | 0.83 | 17152 |
| GOLD_Goldbot_One__dailyD | oro | 2.82 | 99 | 3.84 | 38076 |

## Per famiglia (simbolo letto dal nome: indicativo)
| famiglia | set | PF mediano | PF max | op mediane | set PF>=1,8 |
|---|---|---|---|---|---|
| Tesla | 11 | 1.75 | 2.49 | 652 | 4 |
| oro | 74 | 1.74 | 2.90 | 246 | 33 |
| GBPUSD | 3 | 1.59 | 3.01 | 195 | 1 |
| Nasdaq | 20 | 1.42 | 2.00 | 633 | 1 |
| EURUSD | 21 | 1.37 | 5.24 | 117 | 5 |
| US30 | 22 | 1.37 | 5.06 | 374 | 3 |
| ethereum | 1 | 1.37 | 1.37 | 460 | 0 |
| S&P500 | 12 | 1.33 | 1.78 | 446 | 0 |
| altro/ignoto | 113 | 1.32 | 4.30 | 390 | 21 |
| DAX | 5 | 1.21 | 1.49 | 1156 | 0 |
| argento | 4 | 1.17 | 1.22 | 1192 | 0 |
| petrolio | 2 | 1.09 | 1.22 | 1380 | 0 |
| USDJPY | 14 | 0.92 | 1.67 | 114 | 0 |
| bitcoin | 9 | 0.78 | 1.24 | 1239 | 0 |

## Anomalie (da trattare come sospette)
- PF >= 3 con meno di 100 operazioni: 2 -> e (PF 4.3, 55 op), d (PF 4.02, 63 op)
- PF >= 1,8 ma DD > 3%: 29 (DD alto per un conto a lotto fisso piccolo)
- PF >= 1,8 con >= 250 operazioni (le piu credibili statisticamente): 18 -> DaytradePro_EURUSD (5.24, 393), US30_VOL_M15_g (4.23, 319), MT5_B (3.01, 285), 9637011_BK_TSLA_D_1H (2.49, 268), 9637012_BK_TSLA_E_1H (2.49, 268), 9637017_BK_TSLA_D_1H (2.49, 268), 9637018_BK_TSLA_E_1H (2.49, 268), Breakout_Support_Resistance_Other_sets_Grid_XAUUSD__a (2.42, 6875), MT5_longterm_I (2.05, 558), 9637030_Till_UBS-TSLA.NAS-H1-TSV09 (2.0, 325), MT5_longterm_E (1.93, 1286), 9637041_Till_UBS-XAUUSD-H3-H3V113 (1.91, 493)

## Famiglie con molte varianti (spread del PF fra varianti: se alto, il PF dipende dal set e non dal modello)
- Breakout_Support_Resistance_GO: 26 varianti, PF da 1.04 a 2.90, mediano 1.83
- MT5_longterm: 16 varianti, PF da 1.39 a 2.31, mediano 1.66
- H1: 15 varianti, PF da 0.55 a 1.11, mediano 0.83
- M5: 9 varianti, PF da 1.05 a 1.32, mediano 1.12
- : 8 varianti, PF da 1.29 a 4.30, mediano 2.46
- GOLD_Goldbot_One__daily: 8 varianti, PF da 1.06 a 2.82, mediano 1.69
- GOLD_Goldtrade_Pro__GOLDTRADEP: 8 varianti, PF da 1.45 a 2.59, mediano 1.84
- EURUSD: 7 varianti, PF da 1.16 a 1.45, mediano 1.37

## Correlazione tra PF e numero di operazioni (Spearman, rango)
- rho(PF, operazioni) = -0.40: i PF piu alti sono quelli con MENO operazioni (segno di campione piccolo/fortuna)
