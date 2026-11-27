# Kill-Switch (STEP 2): SCARTA

nessuna leva porta il PF OOS a >= 1.05 con almeno 100 trade OOS

Baseline PF 1.14 (OOS 0.91). Leve testate: 6 (scelte su IS fino al 2016-10-22, valutate su OOS).

| leva | n IS | PF IS | n OOS | PF OOS | passa |
|---|---|---|---|---|---|
| solo Long | 246 | 1.38 | 170 | 0.71 | no |
| solo Short [NON scelta su IS: solo informativa] | 326 | 1.26 | 211 | 1.12 | no |
| togliere ore [20] (server, scelta su IS) | 452 | 1.37 | 302 | 0.84 | no |
| solo simboli con PF IS>=1: ['EURJPY', 'EURUSD', 'GBPJPY', 'NZDUSD', 'USDCAD', 'EURGBP', 'GBPUSD', 'USDCHF'] | 478 | 1.39 | 302 | 0.83 | no |
| togliere il terzile di volatilita 0 (0=bassa,2=alta), scelto su IS | 450 | 1.32 | 183 | 0.84 | no |
| take profit a 2R da MAE/MFE (scelto su IS, stima prudente) | 572 | 1.42 | 381 | 0.98 | no |

Nota: con 6 leve testate un passaggio isolato puo essere caso; in tal caso lo STEP 3 deve confermarlo con IS/OOS e plateau.
