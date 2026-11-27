# Kill-Switch (STEP 2): BASELINE_OK

PF IS 1.35 >= 1.25 e PF OOS 1.74 >= 1.15 con 381 trade: l'EA non ha bisogno di recupero. Va al verdetto (plateau, anni positivi, DD prop), non si ottimizza.

Baseline PF 1.52 (OOS 1.74). Leve testate: 5 (scelte su IS fino al 2018-02-16, valutate su OOS).

| leva | n IS | PF IS | n OOS | PF OOS | passa |
|---|---|---|---|---|---|
| solo Long | 229 | 1.35 | 152 | 1.74 | no |
| solo Short [NON scelta su IS: solo informativa] | 0 | nan | 0 | nan | no |
| togliere ore [8] (server, scelta su IS) | 208 | 1.43 | 143 | 1.77 | no |
| togliere il terzile di volatilita 2 (0=bassa,2=alta), scelto su IS | 141 | 1.59 | 113 | 1.80 | SI |
| take profit a 1R da MAE/MFE (scelto su IS, stima prudente) | 229 | 1.52 | 152 | 1.13 | no |

Nota: con 5 leve testate un passaggio isolato puo essere caso; in tal caso lo STEP 3 deve confermarlo con IS/OOS e plateau.
