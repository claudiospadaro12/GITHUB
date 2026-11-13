# High Risk: cosa dicono gli archivi (13/11/2026)

**Natura: MISURA dai report gia nei miei archivi** (tester BCM, Modello 1, 80.000 EUR, anni 2013/2018/2020/2025, realizzato SENZA flottante; `GUARDIAN_COMBINAZIONI_RISULTATI_2026-11-04.md` e `ev/events.json`) piu i dati del demo 50504263 (storico del 13/11 e report precedenti). **Correzione**: il 13/11 avevo scritto che l'High Risk sull'oro non era mai stato misurato: era sbagliato per Phantom (`HIGHRISK_D60`) e GTP (`HIGHRISK_R6`); per il Reaper il set piu vicino negli archivi e `LIVE30` (non il `60%maxrisk_HighRisk`), e per il Goldbot l'High (`Max50DD`) NON c'e (solo LOW3, PF105, PF525). Quale set stia davvero sul demo 50504263 NON e verificato.

## Giorni oltre le soglie (realizzato, 4 anni)
| Set | gg >= 4,5% (2013/2018/2020/2025) | gg con perdita dall'iniziale >= 9,5% | peggior giorno | DD massimo |
|---|---|---|---|---|
| Phantom HIGHRISK_D60 | 21 (12/0/5/4) | 8 (tutti 2013) | -22,8% | 42,8% (2013) |
| GTP HIGHRISK_R6 | 32 (9/9/8/6) | 17 (5 nel 2013, 12 nel 2025) | -28,2% | 34,2% |
| Reaper LIVE30 (il piu vicino al High) | 27 (9/3/11/4) | 0 | -28,0% | 28,0% |
| Reaper LIVE30 + Phantom HIGH + GTP HIGH | 79 (24/17/22/16) | 19 (10/5/0/4) | -62,8% (2013) | - |

## Sfida simulata (partenza da ogni giorno, +10%, limiti -5% giorno / -10% totale, realizzato)
| Combinazione | passa | fallisce | giorni mediani per passare |
|---|---|---|---|
| Reaper LIVE30 + Phantom HIGH + GTP HIGH | 54% | 45% | 3 |
| + Goldbot LOW3 | 51% | 48% | 3 |
| Phantom HIGH da solo | 71% | 21% | 9 |
| Medium (Reaper DD12 + Goldbot PF105 + Phantom MED_D30 + GTP MED_R3) | 65% | 31% | 6 |
| Trio con set Prop (Reaper D9 + Goldbot PF525 + Phantom PROPCOMBO D4) | 80% | 6% | 28 |
Con il Guardian simulato (modello B, 4,3% / 9,3%, studio del 04/11, finestre di 14 giorni a +5%): Reaper LIVE30 + Phantom HIGH + GTP HIGH_R6 passa 55,7% e fallisce 28,6% (senza Guardian 34,5%), con 92 tagli in 4 anni; senza il GTP High il fallimento scende a 16-19% (con Guardian). Stima approssimata: il Guardian reale controlla ogni secondo e puo non reggere uno spike.

## Demo 50504263 (dal vivo)
Equity 94.651 (02/11, totDD 5,35%) -> **109.781 il 05/11 (+15,13% in un giorno)** -> -4.120 il 09/11 (-3,75% in 3 minuti) -> +1.265 il 10/11 -> -2.165 l'11/11 -> +3.813 il 12/11 -> 110.377 (13/11). Guadagno complessivo dal 02/11 circa +16,6% in 11 giorni, con giorni singoli da +15% e -3,75%.

## Limiti
Realizzato senza flottante (i fallimenti sono sottostimati); un percorso per anno; il Reaper `60%maxrisk_HighRisk` e il Goldbot `Max50DD` non sono negli archivi; set effettivi del demo non verificati; nessun giudizio su lotti, taglie o acquisti.
