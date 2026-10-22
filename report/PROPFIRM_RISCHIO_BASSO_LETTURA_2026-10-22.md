# Prop Firm Gold EA v2.5: rischio manuale 0,25 / 0,5 / 0,75%, lettura (22/10/2026)

Fonte: `PF3_PROPFIRMGOLDEA.zip`, non aperto prima di congelare il lettore (`backtest_pipeline/pf3_leggi.py`). Archivio leggero `risultati_archivio/PF3_20261022`. Attese: `PROPFIRM_RISCHIO_BASSO_ATTESE_2026-10-22.md`. Non controllata da agenti. XAUUSD M30, OHLC 1 minuto, 80.000. 10 passate tutte OK, input confermati dal report, EX5 uguale prima e dopo. Primo e ultimo affare: 01/01/2018 e 30/09/2026 in W2, 01/01/2025 e 30/09/2026 in W1: **finestre intere**. DD % = DD equity / 80.000.

## W1 (2025.01 -> 2026.10, 673 operazioni, mesi positivi 14-15 su 21)
| rischio | protezione | netto | PF | DD equity | % di 80K | rapporto lotti |
|---|---|---|---|---|---|---|
| 0,25 | spenta | +5.307 | 1,26 | 1.584 | 1,98% | 2,5 |
| 0,25 | 4% | +5.462 | 1,27 | 1.649 | 2,06% | 2,5 |
| 0,5 | 4% (ripetizione) | +11.272 | 1,26 | 3.615 | 4,52% | 2,0 |
| 0,75 | spenta | +18.651 | 1,28 | 4.886 | 6,11% | 1,9 |
| 0,75 | 4% | +18.308 | 1,27 | 4.933 | 6,17% | 1,9 |

## W2 (2018.01 -> 2026.10, circa 3.828 operazioni, posizioni insieme al massimo 2)
| rischio | protezione | netto | PF | DD equity | % di 80K | mesi + (su 105) | rapporto lotti |
|---|---|---|---|---|---|---|---|
| 0,25 | spenta | +7.043 | 1,07 | 4.135 | 5,17% | 53 (50%) | 6,5 |
| 0,25 | 4% | +7.789 | 1,08 | 4.223 | 5,28% | 56 (53%) | 6,5 |
| 0,5 | 4% (ripetizione) | +17.284 | 1,09 | 7.567 | **9,46%** | 55 (52%) | 5,2 |
| 0,75 | spenta | +25.692 | 1,08 | 11.455 | 14,32% | 55 (52%) | 5,0 |
| 0,75 | 4% | +22.118 | 1,07 | 12.462 | 15,58% | 55 (52%) | 5,0 |

Per anno (0,5% con protezione, W2): 2018 -2.027, 2019 -3.735, 2020 +7.247, 2021 -2.939, 2022 -33, 2023 +32, 2024 +6.879, 2025 +6.080, 2026 +5.781. Le prime cinque annate (2018-2022) sono **negative in tutte e cinque le celle** (da -957 a -2.921 per 0,25%-0,75%): S-H non passa in W2 (divisione per anni di calendario, non al mese esatto).

## Contro le previsioni (scritte prima)
- **F1 CENTRATA**: perdita peggiore -195/-198 (0,25%), -599/-601 (0,75%).
- **F2 CENTRATA**: DD W2 0,25%/0,5% = 0,56 (con protezione).
- **F3 CENTRATA**: 0,25% DD 5,2-5,3% (sotto 10%); 0,75% 14,3-15,6% (sopra).
- **F4 CENTRATA**: la ripetizione dello 0,5% con protezione differisce dalla cella gia misurata di -4% (W1 netto 11.272 contro 11.772) e +8% (W2 17.284 contro 15.973); DD W2 9,46% contro 10,4%. **Il tester non e perfettamente ripetibile: margine ~ +/-10% su netto e DD.** Quindi lo 0,5% sta SULLA soglia del 10% e non si puo dire sotto o sopra.
- **F5 CENTRATA**: netto 0,25%/0,5% = 0,48 (W1), 0,45 (W2).
- **F6 CENTRATA**: in W2 nessuna cella arriva al 60% di mesi positivi (50-53%) ne a rapporto lotti <= 3 (5,0-6,5); **nessuna cella TIENE in W2**.
- **F7 PARZIALE**: W1 63-68 s (centrata); W2 18-24 minuti per 4 celle su 5 ma **la T10 ha impiegato 33,9 minuti** (oltre i 30 prevsti).

## Lettura
- **Il rischio piu basso scala il DD in modo quasi lineare ma non cura l'edge**: PF 1,07-1,09 in tutte le celle del 2018-2026, mesi positivi 50-53%, e le annate 2018, 2019, 2021 sempre in perdita. Guadagna nel 2020 e 2024-26.
- **0,25% passa S-DD con margine in entrambe le finestre (circa 2% e 5%)** ma fallisce S-M, S-H e S-NOSCALA in W2 (il rapporto lotti in W2 e 6,5 perche con la base a 80.000 che cresce/cala i lotti vanno da 0,02 a 0,13).
- **0,5% e al limite**: DD 9,46% in questo giro, 10,4% nel giro precedente.
- **0,75% non passa in W2** (14-16%).
- Resta il limite grosso: BCM e GMT+1, il venditore vuole GMT+2/+3 [NON VERIFICATO l'effetto].
- Nessuna taglia ne consiglio di acquisto: la scelta del rischio e di Claudio.
