# Kill-Switch (STEP 2): SCARTA

nessuna leva porta il PF OOS a >= 1.05 con almeno 100 trade OOS; movimento lordo medio (+0.014R) inferiore ai costi (0.035R)

Baseline PF 0.92 (OOS 0.87). Leve testate: 8 (scelte su IS fino al 2015-11-04, valutate su OOS).

| leva | n IS | PF IS | n OOS | PF OOS | passa |
|---|---|---|---|---|---|
| solo Long | 2113 | 0.93 | 1412 | 0.83 | no |
| solo Short | 2067 | 0.98 | 1375 | 0.92 | no |
| solo segmento CONT | 4061 | 0.95 | 2697 | 0.87 | no |
| solo segmento INV | 119 | 1.10 | 90 | 1.06 | no |
| togliere ore [6, 7, 8, 9] (server, scelta su IS) | 3363 | 0.99 | 2391 | 0.86 | no |
| solo simboli con PF IS>=1: ['EURGBP', 'GBPJPY', 'EURUSD', 'USDJPY', 'USDCAD'] | 1515 | 1.13 | 1164 | 0.89 | no |
| togliere il terzile di volatilita 2 (0=bassa,2=alta), scelto su IS | 2393 | 1.02 | 2251 | 0.87 | no |
| take profit a 0.5R da MAE/MFE (scelto su IS, stima prudente) | 4180 | 1.02 | 2787 | 0.91 | no |

Nota: con 8 leve testate un passaggio isolato puo essere caso; in tal caso lo STEP 3 deve confermarlo con IS/OOS e plateau.
