# Quanto avrebbero guadagnato su un conto da 80.000: GoldenZoe e Breaking Band/Bulge di Massimo, anno per anno (23/11/2026)
Script `backtest_runner/simulatore/gz_bb_anni_80k.py`; uscita completa `SIMULAZIONE_ANNI_80K_GZ_BB_dati_2026-11-23.txt`. **Ogni anno riparte da 80.000 (nessun interesse composto fra anni).** Solo misure, nessun consiglio su taglie.
- **GoldenZoe** (oro H4 long, canale 55, stop 3 ATR, Chandelier 3 ATR): oro FTMO M1 2015-nov 2026, costi FTMO (0,35 USD + swap 5,5%), rischio % sull'equity: PROP 0,5 / MEDIO 0,9 / ALTO 1,3; operazioni contate nell'anno di chiusura; DD = massima perdita flottante dentro l'anno (minimi di equity al minuto).
- **Breaking Band / Bulge di Massimo** (BreakingBand v4, EURUSD+EURCHF+EURCAD H1): (a) REPLICA NOSTRA su dati BCM, barre da 1 minuto, 2013-2024, rendimento per operazione al rischio 0,5%, scalato in modo lineare a 2% e 2,5% (come fa lui); (b) i numeri che Massimo dichiara (MetaQuotes-Demo, ogni tick, 2020-2026, 7 anni su 100.000) scalati a 80.000.
## GoldenZoe, utile annuo su 80.000 (DD flottante nell'anno)
| Anno | Ops | PROP 0,5% | MEDIO 0,9% | ALTO 1,3% |
|---|---|---|---|---|
| 2015 | 12 | +698 (0,2%) | +1.242 (0,3%) | +1.773 (0,5%) |
| 2016 | 16 | +1.724 (0,0%) | +3.074 (0,0%) | +4.398 (0,0%) |
| 2017 | 20 | -456 (0,6%) | -829 (1,0%) | -1.210 (1,5%) |
| 2018 | 15 | -554 (0,7%) | -1.023 (1,3%) | -1.514 (1,9%) |
| 2019 | 17 | +1.612 (0,3%) | +2.889 (0,6%) | +4.155 (0,8%) |
| 2020 | 16 | +6.458 (0,0%) | +11.825 (0,1%) | +17.368 (0,1%) |
| 2021 | 19 | **-2.405 (3,3%)** | **-4.289 (5,9%)** | **-6.139 (8,4%)** |
| 2022 | 16 | +115 (1,2%) | +188 (2,1%) | +244 (3,1%) |
| 2023 | 18 | +3.168 (0,6%) | +5.719 (1,0%) | +8.282 (1,5%) |
| 2024 | 18 | +3.543 (0,6%) | +6.417 (1,1%) | +9.323 (1,5%) |
| 2025 | 28 | +2.902 (1,1%) | +5.258 (2,0%) | +7.642 (2,8%) |
| 2026 (a nov) | 11 | +958 (0,1%) | +1.703 (0,2%) | +2.429 (0,3%) |
| **Somma 12 anni** | | **+17.763** | **+32.172** | **+46.751** |
Anni negativi: 3 su 12 (2017, 2018, 2021); il 2020 da solo vale il 36% della somma PROP. Media: PROP circa +1.480 / MEDIO +2.680 / ALTO +3.900 all'anno (+1,9% / 3,4% / 4,9% di 80.000).
## Breaking Band / Bulge di Massimo
| Anno | Ops (3 mercati) | Replica nostra a 0,5% | a 2,0% | a 2,5% |
|---|---|---|---|---|
| 2013 | 7 | +761 | +3.044 | +3.806 |
| 2014 | 3 | +793 | +3.172 | +3.964 |
| 2015 | 3 | +709 | +2.836 | +3.545 |
| 2016 | 9 | +214 | +855 | +1.068 |
| 2017 | 6 | +679 | +2.715 | +3.393 |
| 2018 | 7 | +1.144 | +4.578 | +5.722 |
| 2019 | 3 | +797 | +3.187 | +3.984 |
| 2020 | 7 | +1.457 | +5.826 | +7.283 |
| 2021 | 5 | -291 | -1.165 | -1.456 |
| 2022 | 3 | +55 | +221 | +276 |
| 2023 | 2 | -129 | -517 | -646 |
| 2024 | 3 | -362 | -1.450 | -1.812 |
| **Somma 2013-2024** | 58 | **+5.826** | **+23.302** | **+29.128** |
**Numeri dichiarati da Massimo** (2020-2026, su 100.000 scalati a 80.000): rischio 0,5% +1.920 in 7 anni (+274 all'anno); 2% +9.587 (+1.370 all'anno); 2,5% +11.961 (+1.709 all'anno).
**Lettura:** nella replica nostra il vantaggio c'e fino al 2020 (+6.554 a 0,5% nel 2013-2020) e **poi sparisce**: 2021-2024 sommano -727 a 0,5%. Massimo sul periodo 2020-2026 dichiara invece un risultato positivo (PF 1,41-2,34): la differenza non e spiegata (dati MetaQuotes contro BCM, ogni tick contro 1 minuto, 2025-26 che la nostra serie non copre); i due test non coincidono nel 2021-2024. **Pochissime operazioni** (2-9 all'anno su 3 mercati): campione piccolo, un anno storto pesa molto.
## Insieme (somma aritmetica, non e una simulazione di portafoglio)
GoldenZoe MEDIO + Breaking Band 2% (replica nostra), 2015-2024: 4.078 / 3.929 / 1.886 / 3.555 / 6.076 / 17.651 / **-5.454** / 409 / 5.202 / 4.967 (somma +42.299). Il 2021 e negativo per entrambi.
## Limiti
- Ogni anno riparte da 80.000; l'interesse composto su piu anni darebbe cifre diverse. Il DD a 2% e 2,5% della Breaking Band NON e simulato (scalatura lineare dei rendimenti, come nel documento di Massimo; con 2-9 operazioni l'anno non e garantita).
- GoldenZoe: 12 anni di oro, mercato in forte rialzo dal 2024-25; un solo strumento; correlazione con il resto non misurata in questa simulazione.
- La replica Breaking Band usa dati BCM da 1 minuto, non i tick di Massimo: stessi parametri di default, non identici; la nostra OOS 2021-24 e debole (13 operazioni, PF 0,64-0,75).
- Risultati lordi di eventuali tasse e commissioni dei conti reali; costi FTMO per l'oro, costi BCM per il forex.
