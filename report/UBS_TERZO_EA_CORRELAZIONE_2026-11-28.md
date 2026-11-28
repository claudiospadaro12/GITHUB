# Terzo EA oro D1 (n. 4 e riserve): correlazione con GoldenZoe, passo 2 (28/11/2026)
Criteri: `UBS_TERZO_EA_ORO_D1_CRITERI_2026-11-28.md` (soglia |r| mensile <= 0,5; previsione Q1 85%). Script: `backtest_pipeline/ubs_corr_terzo_ea_goldenzoe.py`. GoldenZoe = ricostruzione H4 (breakout 55, stop 3 ATR, chandelier 3) da M1 FTMO, R per operazione alla chiusura; set = profitto per operazione chiusa (R4). Somma per mese, correlazione di Pearson; IC95 con bootstrap.

| Periodo | n. 4 (scelto) | n. 10 | n. 14 | n. 2 |
|---|---|---|---|---|
| mensile 2004-09..2012 (100 mesi) | **-0,10** [-0,36; 0,17] | 0,11 | 0,13 | 0,06 |
| mensile 2025-01..2026-10 (22 mesi) | **0,22** [-0,09; 0,45] | 0,26 | 0,30 | 0,09 |
| trimestrale 2004-12 (34) / 2025-26 (8) | -0,11 / -0,35 | 0,34 / 0,34 | 0,28 / 0,16 | -0,06 / 0,05 |
| settimanale n. 4 | -0,01 (431 sett) / 0,01 (95 sett) | | | |
| con il rendimento mensile dell'oro (n. 4) | -0,02 / 0,40 | | | |

**Esito: passa (Q1 SI).** Il n. 4 e' scorrelato da GoldenZoe in entrambi i periodi (|r| <= 0,22, IC95 comprende lo zero). Nel 2025-26 segue di piu' il rendimento dell'oro (0,40): periodo di rialzo.
Limiti: GoldenZoe e' una ricostruzione, non il live; solo 22 mesi nel 2025-26 e 8 trimestri (indicativi); la correlazione fra due EA oro puo' salire in un anno di crisi/trend comune; correlazione mensile e' sulle chiusure, non sul DD (la sovrapposizione del drawdown va misurata al passo 5).
