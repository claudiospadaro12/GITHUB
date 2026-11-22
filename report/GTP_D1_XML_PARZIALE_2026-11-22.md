# GTP oro D1: primo esame dell'XML parziale (22/11/2026)
Fonte: `ReportOptimizer-50503392.xml` (XAUUSD D1, 2013.01.01-2022.12.31, Modello 1, genetica **interrotta dopo 118 passaggi su 10.496**, cioe poco piu della prima popolazione: sono quasi campioni casuali dello spazio, NON un ottimo).
- Profitto > 0 in 107/118 passaggi, PF > 1 in 107, PF >= 1,30 in 89; mediana PF 1,58, mediana 106 operazioni, profitto mediano 897 (lotto 0,1, 100.000 EUR: molto piccolo). Idonei (PF >= 1,30, op >= 100, profitto > 0, Result > 0): 48. Gli anni positivi non si leggono dall'XML.
- Correlazione di rango parametro-profitto: tutte deboli (|rho| <= 0,34). Piu marcate: `ST1_HL_strength_R` -0,34 (pivot destro piccolo meglio), `ST1_TrailSL_Start` -0,22. Nessun parametro e decisivo: il segnale e largo, non si individua una zona migliore con 118 punti.
- Lettura onesta: il fatto che il 91% dei punti casuali sia in utile dice che l'edge del breakout D1 sull'oro nel 2013-2022 e ampio (e che quel decennio ha una deriva rialzista che aiuta ogni inseguitore di trend); NON dice che i parametri si possano migliorare. Il criterio Custom e instabile (Result 26 milioni con profitto 4.649).
## Candidati scelti con la regola della campagna (4 migliori per Result, 3 piu diversi, 3 a caso con seme 20261122)
| id | tipo | pass | profitto | PF | op | DD% | ST1_HL_strength_L | ST1_HL_strength_R | ST1_countback | ST1_MinDist_to_HL | ST1_UpDiff | ST1_DownDiff | MaxTrades | MinDist_orders | ST1_Expiration_hours | Exit_stop | Exit_limit | Exit_TrailSL_size | Exit_TrailSL_Start | Exit_TrailSL_Stop | Exit_TrailTP_size | Exit_TrailTP_Start |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| GTPD1_01 | migliore | 7 | 4649 | 1.95 | 141 | 0.85 | 14 | 6 | 240 | 250 | -120 | 170 | 1 | 30 | 288 | 2900 | 3700 | 950 | 500 | 600 | 0 | 75 |
| GTPD1_02 | migliore | 6 | 3010 | 3.29 | 122 | 0.31 | 19 | 9 | 250 | 200 | -180 | 120 | 3 | 430 | 432 | 3300 | 1700 | 900 | 400 | 4600 | 175 | 170 |
| GTPD1_03 | migliore | 62 | 4322 | 2.29 | 232 | 0.38 | 16 | 2 | 130 | 800 | 50 | 90 | 5 | 30 | 336 | 4900 | 4800 | 850 | 150 | 5000 | 135 | 200 |
| GTPD1_04 | migliore | 9 | 3423 | 2.43 | 153 | 0.39 | 12 | 5 | 140 | 1500 | 50 | -30 | 3 | 430 | 144 | 1200 | 4200 | 550 | 50 | 600 | 40 | 90 |
| GTPD1_05 | diverso | 52 | 1704 | 1.41 | 100 | 1.13 | 11 | 8 | 40 | 1150 | -230 | -50 | 5 | 980 | 312 | 3800 | 1400 | 200 | 800 | 4600 | 30 | 120 |
| GTPD1_06 | diverso | 105 | 2571 | 1.90 | 100 | 0.84 | 7 | 16 | 170 | 150 | 80 | -20 | 1 | 680 | 168 | 4800 | 3700 | 0 | 1000 | 800 | 75 | 200 |
| GTPD1_07 | diverso | 107 | 1380 | 1.44 | 208 | 0.71 | 5 | 7 | 210 | 1900 | 170 | -290 | 5 | 30 | 216 | 4300 | 2900 | 50 | 850 | 2200 | 185 | 60 |
| GTPD1_08 | casuale | 40 | 393 | 1.68 | 101 | 0.15 | 8 | 12 | 50 | 450 | -60 | -80 | 5 | 880 | 336 | 2400 | 2400 | 200 | 50 | 3600 | 135 | 50 |
| GTPD1_09 | casuale | 35 | 1096 | 1.40 | 150 | 0.70 | 6 | 14 | 220 | 100 | 30 | -170 | 1 | 730 | 192 | 3100 | 2900 | 900 | 0 | 3000 | 190 | 200 |
| GTPD1_10 | casuale | 78 | 1769 | 1.42 | 144 | 1.02 | 5 | 15 | 140 | 1100 | 110 | -250 | 5 | 80 | 312 | 1700 | 2800 | 800 | 300 | 800 | 45 | 95 |

Prossimo passo (V1, scritto prima dei numeri): i 10 candidati su 2004-01-01 -> 2012-12-31, Modello 1, stesso deposito, nessuna ottimizzazione. Cancello V1: PF >= 1,20, profitto > 0, operazioni >= 20, anni non negativi >= 60%. Previsione: almeno 1 su 10 passa V1: 45%; PF mediano V1 inferiore al PF IS di almeno il 25%: 75%. Poi V2 (perturbazione), V3 (tick 2025-26), V4 (2023-24).
