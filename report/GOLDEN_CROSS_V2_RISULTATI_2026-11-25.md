# Golden Cross HA (PDF) e Golden Cross di Paolo: risultati (25/11/2026)

Criteri: `GOLDEN_CROSS_V2_CRITERI_2026-11-25.md` (con l'aggiunta sull'oro, scritta prima dei numeri oro). Simulatori: `golden_cross_fx.py` (10 coppie forex, H1 BCM 2005-2026) e `golden_cross_oro.py` (XAUUSD FTMO M1 2004-2026 -> H1; **2014 coperto solo per gennaio-febbraio**, 934 ore; riga 00:00 aggregata scartata).

## Forex, 10 coppie

| cella | periodo | operazioni | PF (R) | % vincenti | R medio | R/anno |
|---|---|---|---|---|---|---|
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | IS 2005-2015 | 1787 | 0.84 | 33 | -0.079 | -12.9 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | OOS 2016-2021 | 892 | 0.73 | 31 | -0.144 | -21.5 |
| A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA) | HO 2022-2026 | 633 | 0.84 | 33 | -0.086 | -10.8 |
| A2 H4 | IS 2005-2015 | 499 | 0.97 | 39 | -0.015 | -0.7 |
| A2 H4 | OOS 2016-2021 | 245 | 0.88 | 35 | -0.063 | -2.6 |
| A2 H4 | HO 2022-2026 | 186 | 0.79 | 34 | -0.106 | -3.9 |
| A3 ADX 25 | IS 2005-2015 | 547 | 0.90 | 35 | -0.048 | -2.4 |
| A3 ADX 25 | OOS 2016-2021 | 251 | 0.72 | 33 | -0.151 | -6.3 |
| A3 ADX 25 | HO 2022-2026 | 162 | 0.90 | 35 | -0.056 | -1.8 |
| A4 target 1R | IS 2005-2015 | 1795 | 0.78 | 39 | -0.101 | -16.6 |
| A4 target 1R | OOS 2016-2021 | 893 | 0.71 | 38 | -0.147 | -21.8 |
| A4 target 1R | HO 2022-2026 | 637 | 0.77 | 39 | -0.110 | -14.0 |
| A5 target 2R | IS 2005-2015 | 1787 | 0.85 | 30 | -0.077 | -12.6 |
| A5 target 2R | OOS 2016-2021 | 890 | 0.75 | 28 | -0.141 | -20.9 |
| A5 target 2R | HO 2022-2026 | 633 | 0.84 | 29 | -0.087 | -11.0 |
| A6 senza uscita EMA21 | IS 2005-2015 | 1773 | 0.86 | 38 | -0.083 | -13.4 |
| A6 senza uscita EMA21 | OOS 2016-2021 | 886 | 0.76 | 35 | -0.152 | -22.5 |
| A6 senza uscita EMA21 | HO 2022-2026 | 631 | 0.87 | 38 | -0.081 | -10.3 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | IS 2005-2015 | 284 | 0.86 | 35 | -0.064 | -1.6 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | OOS 2016-2021 | 170 | 0.77 | 34 | -0.117 | -3.3 |
| B1 Paolo FLIP+CROSS H1 (PRIMARIA) | HO 2022-2026 | 131 | 1.17 | 41 | 0.080 | 2.1 |
| B2 Paolo FLIP+CROSS H4 | IS 2005-2015 | 105 | 0.75 | 35 | -0.127 | -1.2 |
| B2 Paolo FLIP+CROSS H4 | OOS 2016-2021 | 68 | 1.03 | 43 | 0.012 | 0.1 |
| B2 Paolo FLIP+CROSS H4 | HO 2022-2026 | 50 | 1.54 | 48 | 0.193 | 1.9 |
| B3 Paolo bande inclinate H1 | IS 2005-2015 | 11976 | 0.81 | 34 | -0.106 | -115.2 |
| B3 Paolo bande inclinate H1 | OOS 2016-2021 | 6496 | 0.78 | 34 | -0.123 | -133.7 |
| B3 Paolo bande inclinate H1 | HO 2022-2026 | 5194 | 0.79 | 34 | -0.116 | -120.5 |

VERDETTO (soglie dei criteri):
- A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA): IS 0.84 (n=1787), OOS 0.73 (n=892), HO 0.84 (n=633) -> non passa
- A2 H4: IS 0.97 (n=499), OOS 0.88 (n=245), HO 0.79 (n=186) -> non passa
- A3 ADX 25: IS 0.90 (n=547), OOS 0.72 (n=251), HO 0.90 (n=162) -> non passa
- A4 target 1R: IS 0.78 (n=1795), OOS 0.71 (n=893), HO 0.77 (n=637) -> non passa
- A5 target 2R: IS 0.85 (n=1787), OOS 0.75 (n=890), HO 0.84 (n=633) -> non passa
- A6 senza uscita EMA21: IS 0.86 (n=1773), OOS 0.76 (n=886), HO 0.87 (n=631) -> non passa
- B1 Paolo FLIP+CROSS H1 (PRIMARIA): IS 0.86 (n=284), OOS 0.77 (n=170), HO 1.17 (n=131) -> non passa
- B2 Paolo FLIP+CROSS H4: IS 0.75 (n=105), OOS 1.03 (n=68), HO 1.54 (n=50) -> non passa
- B3 Paolo bande inclinate H1: IS 0.81 (n=11976), OOS 0.78 (n=6496), HO 0.79 (n=5194) -> non passa

## Oro XAUUSD (preset GOLD del Pine)

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
| A4 target 1R | IS 2005-2015 | 133 | 0.59 | 35 | -0.224 | -2.7 |
| A4 target 1R | OOS 2016-2021 | 116 | 0.75 | 39 | -0.120 | -2.3 |
| A4 target 1R | HO 2022-2026 | 57 | 0.74 | 35 | -0.121 | -1.4 |
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
| B3 Paolo bande inclinate H1 | IS 2005-2015 | 918 | 0.92 | 36 | -0.045 | -3.7 |
| B3 Paolo bande inclinate H1 | OOS 2016-2021 | 629 | 0.89 | 36 | -0.060 | -6.2 |
| B3 Paolo bande inclinate H1 | HO 2022-2026 | 554 | 1.01 | 39 | 0.006 | 0.7 |

VERDETTO (soglie dei criteri):
- A1 HA+ADX H1 ADX20 1,5R EMA21-exit (PRIMARIA): IS 0.63 (n=133), OOS 0.79 (n=115), HO 0.68 (n=57) -> non passa
- A2 H4: IS 0.92 (n=32), OOS 1.14 (n=24), HO 0.74 (n=17) -> non passa
- A3 ADX 25: IS 0.74 (n=46), OOS 0.93 (n=36), HO 1.13 (n=11) -> non passa
- A4 target 1R: IS 0.59 (n=133), OOS 0.75 (n=116), HO 0.74 (n=57) -> non passa
- A5 target 2R: IS 0.67 (n=133), OOS 0.88 (n=115), HO 0.80 (n=57) -> non passa
- A6 senza uscita EMA21: IS 0.77 (n=133), OOS 0.76 (n=114), HO 0.51 (n=57) -> non passa
- B1 Paolo FLIP+CROSS H1 (PRIMARIA): IS 0.79 (n=23), OOS 0.20 (n=19), HO 1.22 (n=13) -> non passa
- B2 Paolo FLIP+CROSS H4: IS 0.33 (n=10), OOS 0.94 (n=7), HO 2.55 (n=6) -> non passa
- B3 Paolo bande inclinate H1: IS 0.92 (n=918), OOS 0.89 (n=629), HO 1.01 (n=554) -> non passa
