# Golden Cross HA (PDF) e Golden Cross di Paolo: risultati (25/11/2026)

Criteri: `GOLDEN_CROSS_V2_CRITERI_2026-11-25.md` (con l'aggiunta sull'oro, scritta prima dei numeri oro). Simulatori: `golden_cross_fx.py` (10 coppie forex, H1 BCM 2005-2026) e `golden_cross_oro.py` (XAUUSD FTMO M1 2004-2026 -> H1; **2014 coperto solo per gennaio-febbraio**, 934 ore; riga 00:00 aggregata scartata).

**Revisione indipendente (1 revisore della Sala ridotta): nessun look-ahead, indicatori e costi corretti. Corretti: (1) B3 contava il fronte salito in modo sbagliato (pandas 3): ora forex 2.579 operazioni invece di circa 12.000, oro 170 invece di 918; (2) il TP e' ora valutato anche nella barra di ingresso (SL prima). Non corretto, dichiarato: lo 'stop dopo 2 perdite consecutive' coincide con il massimo di 2 trade al giorno.** Nessun verdetto cambia.

## Forex, 10 coppie (dopo correzioni)

| cella | periodo | operazioni | PF (R) | % vincenti | R medio | R/anno |
|---|---|---|---|---|---|---|
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | IS 2005-2015 | 1788 | 0.85 | 33 | -0.077 | -12.5 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | OOS 2016-2021 | 894 | 0.74 | 32 | -0.138 | -20.5 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | HO 2022-2026 | 633 | 0.85 | 33 | -0.079 | -9.9 |
| A2 H4 | IS 2005-2015 | 500 | 0.99 | 40 | -0.005 | -0.2 |
| A2 H4 | OOS 2016-2021 | 245 | 0.90 | 36 | -0.053 | -2.2 |
| A2 H4 | HO 2022-2026 | 186 | 0.84 | 35 | -0.079 | -2.9 |
| A3 ADX 25 | IS 2005-2015 | 548 | 0.91 | 35 | -0.045 | -2.3 |
| A3 ADX 25 | OOS 2016-2021 | 252 | 0.72 | 33 | -0.155 | -6.5 |
| A3 ADX 25 | HO 2022-2026 | 162 | 0.92 | 36 | -0.041 | -1.3 |
| A4 target 1R | IS 2005-2015 | 1800 | 0.80 | 40 | -0.091 | -14.9 |
| A4 target 1R | OOS 2016-2021 | 898 | 0.74 | 39 | -0.128 | -19.2 |
| A4 target 1R | HO 2022-2026 | 643 | 0.81 | 40 | -0.091 | -11.7 |
| A5 target 2R | IS 2005-2015 | 1788 | 0.86 | 30 | -0.073 | -11.8 |
| A5 target 2R | OOS 2016-2021 | 891 | 0.75 | 28 | -0.138 | -20.5 |
| A5 target 2R | HO 2022-2026 | 633 | 0.86 | 29 | -0.075 | -9.5 |
| A6 senza uscita EMA21 | IS 2005-2015 | 1774 | 0.87 | 38 | -0.080 | -13.0 |
| A6 senza uscita EMA21 | OOS 2016-2021 | 888 | 0.77 | 35 | -0.146 | -21.6 |
| A6 senza uscita EMA21 | HO 2022-2026 | 631 | 0.87 | 38 | -0.077 | -9.8 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | IS 2005-2015 | 284 | 0.86 | 35 | -0.064 | -1.6 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | OOS 2016-2021 | 170 | 0.77 | 34 | -0.117 | -3.3 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | HO 2022-2026 | 131 | 1.17 | 41 | 0.080 | 2.1 |
| B2 Paolo FLIP+CROSS H4 | IS 2005-2015 | 105 | 0.75 | 35 | -0.127 | -1.2 |
| B2 Paolo FLIP+CROSS H4 | OOS 2016-2021 | 68 | 1.03 | 43 | 0.012 | 0.1 |
| B2 Paolo FLIP+CROSS H4 | HO 2022-2026 | 50 | 1.54 | 48 | 0.193 | 1.9 |
| B3 Paolo bande inclinate H1 | IS 2005-2015 | 2579 | 0.87 | 35 | -0.066 | -15.4 |
| B3 Paolo bande inclinate H1 | OOS 2016-2021 | 1419 | 0.75 | 32 | -0.142 | -33.6 |
| B3 Paolo bande inclinate H1 | HO 2022-2026 | 1063 | 0.75 | 33 | -0.136 | -29.0 |

VERDETTO (soglie dei criteri):
VERDETTO (soglie dei criteri):
- A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA): IS 0.85 (n=1788), OOS 0.74 (n=894), HO 0.85 (n=633) -> non passa
- A2 H4: IS 0.99 (n=500), OOS 0.90 (n=245), HO 0.84 (n=186) -> non passa
- A3 ADX 25: IS 0.91 (n=548), OOS 0.72 (n=252), HO 0.92 (n=162) -> non passa
- A4 target 1R: IS 0.80 (n=1800), OOS 0.74 (n=898), HO 0.81 (n=643) -> non passa
- A5 target 2R: IS 0.86 (n=1788), OOS 0.75 (n=891), HO 0.86 (n=633) -> non passa
- A6 senza uscita EMA21: IS 0.87 (n=1774), OOS 0.77 (n=888), HO 0.87 (n=631) -> non passa
- B1 Paolo FLIP+CROSS H1 (PRIMARIA): IS 0.86 (n=284), OOS 0.77 (n=170), HO 1.17 (n=131) -> non passa
- B2 Paolo FLIP+CROSS H4: IS 0.75 (n=105), OOS 1.03 (n=68), HO 1.54 (n=50) -> non passa
- B3 Paolo bande inclinate H1: IS 0.87 (n=2579), OOS 0.75 (n=1419), HO 0.75 (n=1063) -> non passa

## Oro XAUUSD (preset GOLD del Pine, dopo correzioni)

| cella | periodo | operazioni | PF (R) | % vincenti | R medio | R/anno |
|---|---|---|---|---|---|---|
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | IS 2005-2015 | 133 | 0.63 | 28 | -0.218 | -2.6 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | OOS 2016-2021 | 115 | 0.79 | 32 | -0.111 | -2.1 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | HO 2022-2026 | 57 | 0.68 | 26 | -0.167 | -1.9 |
| A2 H4 | IS 2005-2015 | 32 | 0.92 | 31 | -0.038 | -0.1 |
| A2 H4 | OOS 2016-2021 | 24 | 1.14 | 50 | 0.065 | 0.3 |
| A2 H4 | HO 2022-2026 | 17 | 0.74 | 29 | -0.147 | -0.5 |
| A3 ADX 25 | IS 2005-2015 | 46 | 0.74 | 30 | -0.152 | -0.6 |
| A3 ADX 25 | OOS 2016-2021 | 36 | 0.93 | 36 | -0.039 | -0.2 |
| A3 ADX 25 | HO 2022-2026 | 11 | 1.13 | 36 | 0.052 | 0.1 |
| A4 target 1R | IS 2005-2015 | 133 | 0.62 | 35 | -0.207 | -2.5 |
| A4 target 1R | OOS 2016-2021 | 116 | 0.78 | 40 | -0.105 | -2.0 |
| A4 target 1R | HO 2022-2026 | 58 | 0.71 | 34 | -0.137 | -1.6 |
| A5 target 2R | IS 2005-2015 | 133 | 0.67 | 27 | -0.200 | -2.4 |
| A5 target 2R | OOS 2016-2021 | 115 | 0.88 | 30 | -0.066 | -1.3 |
| A5 target 2R | HO 2022-2026 | 57 | 0.80 | 25 | -0.106 | -1.2 |
| A6 senza uscita EMA21 | IS 2005-2015 | 133 | 0.77 | 35 | -0.151 | -1.8 |
| A6 senza uscita EMA21 | OOS 2016-2021 | 114 | 0.76 | 36 | -0.148 | -2.8 |
| A6 senza uscita EMA21 | HO 2022-2026 | 57 | 0.51 | 26 | -0.346 | -3.9 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | IS 2005-2015 | 23 | 0.79 | 30 | -0.097 | -0.2 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | OOS 2016-2021 | 19 | 0.20 | 16 | -0.504 | -1.6 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | HO 2022-2026 | 13 | 1.22 | 38 | 0.104 | 0.3 |
| B2 Paolo FLIP+CROSS H4 | IS 2005-2015 | 10 | 0.33 | 30 | -0.417 | -0.4 |
| B2 Paolo FLIP+CROSS H4 | OOS 2016-2021 | 7 | 0.94 | 43 | -0.029 | -0.0 |
| B2 Paolo FLIP+CROSS H4 | HO 2022-2026 | 6 | 2.55 | 50 | 0.456 | 0.5 |
| B3 Paolo bande inclinate H1 | IS 2005-2015 | 170 | 0.95 | 35 | -0.026 | -0.4 |
| B3 Paolo bande inclinate H1 | OOS 2016-2021 | 126 | 0.74 | 33 | -0.138 | -2.9 |
| B3 Paolo bande inclinate H1 | HO 2022-2026 | 116 | 0.76 | 34 | -0.132 | -3.1 |

VERDETTO (soglie dei criteri):
- A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA): IS 0.63 (n=133), OOS 0.79 (n=115), HO 0.68 (n=57) -> non passa
- A2 H4: IS 0.92 (n=32), OOS 1.14 (n=24), HO 0.74 (n=17) -> non passa
- A3 ADX 25: IS 0.74 (n=46), OOS 0.93 (n=36), HO 1.13 (n=11) -> non passa
- A4 target 1R: IS 0.62 (n=133), OOS 0.78 (n=116), HO 0.71 (n=58) -> non passa
- A5 target 2R: IS 0.67 (n=133), OOS 0.88 (n=115), HO 0.80 (n=57) -> non passa
- A6 senza uscita EMA21: IS 0.77 (n=133), OOS 0.76 (n=114), HO 0.51 (n=57) -> non passa
- B1 Paolo FLIP+CROSS H1 (PRIMARIA): IS 0.79 (n=23), OOS 0.20 (n=19), HO 1.22 (n=13) -> non passa
- B2 Paolo FLIP+CROSS H4: IS 0.33 (n=10), OOS 0.94 (n=7), HO 2.55 (n=6) -> non passa
- B3 Paolo bande inclinate H1: IS 0.95 (n=170), OOS 0.74 (n=126), HO 0.76 (n=116) -> non passa
