# UBS R: ReverseTrades=true sui set oro: RISULTATI (15/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, 100.000 EUR, lotto fisso 0,1, set come consegnati dal pacchetto da 283 con solo `ReverseTrades=true` imposto; EA `Ultimate_Breakout_EA_WSC_V9.5`). Zip `ANNO_ORO_GRADINI_UBSR_20261115_1039`: 18 passate, **tutte OK, `input_ok=si`** (nel report del tester compare `ReverseTrades=true`, `Risk=0`, `StartLots=0.1`). Criteri e previsioni scritti prima: `UBS_ORO_NON_CORRELATI_REVERSE_CRITERI_2026-11-15.md` (commit 13e07e9a). Riferimento "originale": `D160_dati/ubsu3m.json` (U3 tappa 1); il PF degli originali manca per quasi tutte le celle.

## Tabella (periodo P1 = 2013-2018, P2 = 2019-2025)
| Set | Periodo | Operazioni orig -> inv | Netto orig -> inv (EUR) | PF inv | DD inv |
|---|---|---|---|---|---|
| Goldbot dailyC | P1 / P2 | 163 -> 157 / 165 -> 157 | +794 -> -1.766 / +1.074 -> -1.315 | 0,23 / 0,36 | 1,9% / 1,5% |
| Goldbot dailyI | P1 / P2 | 348 -> 346 / 375 -> 378 | +2.320 -> -5.627 / +4.405 -> -4.906 | 0,59 / 0,65 | 5,9% / 5,0% |
| Reaper s1 D1 | P1 / P2 | 196 -> 188 / 227 -> 226 | +1.552 -> -2.524 / +3.464 -> -5.882 | 0,44 / 0,31 | 3,6% / 6,3% |
| Reaper s5 H1 | P1 / P2 | 816 -> 682 / 954 -> 918 | +2.388 -> -12.183 / +11.324 -> -9.073 | 0,25 / 0,45 | 12,3% / 9,4% |
| Gold Trade Pro E | P1 / P2 | 153 -> 139 / 169 -> 166 | +2.604 -> -2.842 / +3.998 -> -2.190 | 0,29 / 0,52 | 3,0% / 2,2% |
| Gold Trade Pro a | P1 / P2 | 428 -> 379 / 483 -> 472 | +7.555 -> -12.073 / +7.878 -> -8.270 | 0,40 / 0,61 | 12,4% / 8,5% |
| Phantom strat3 (= Gold_c, stessa strategia) | P1 / P2 | 305 -> 322 / 328 -> 346 | +2.775 -> -4.904 / +4.074 -> -3.552 | 0,55 / 0,69 | 5,1% / 3,7% |
| Phantom strat8 | P1 / P2 | 750 -> 611 / 856 -> 831 | +5.273 -> -16.431 / +11.084 -> -11.135 | 0,24 / 0,43 | 16,5% / 11,3% |
Somma dei netti (18 celle, con strat3/Gold_c contata due volte): **originali +79.413, invertiti -113.126 EUR**.

## Previsioni (scritte prima) contro risultati
| | Previsione | Esito |
|---|---|---|
| R-1 | l'input esiste e funziona in >= 60% dei set (70%) | **vera**: 18/18 |
| R-2 | PF invertito < 1 per i set con PF originale > 1,3, in >= 80% (85%) | **vera**: PF invertito < 1 in **18/18** (da 0,23 a 0,69) |
| R-3 | almeno un set invertito passa tutti i filtri (15%) | **FALSA**: nessuno (migliore PF 0,69, tutti in perdita) |
| R-4 | correlazione giornaliera invertito-originale <= -0,5 per la maggior parte (70%) | **NON MISURATA** (servono le serie giornaliere) |
| R-5 | nessun invertito meglio del suo originale (85%) | **vera**: 18/18 peggio |

## Lettura
1. **Invertire un breakout oro non da un rimbalzo, da una perdita**: tutte le 18 celle perdono, di piu di quanto l'originale guadagna (somma -113.126 contro +79.413). I tre motivi probabili, non verificati uno per uno: l'inverso di un PF 1,5-2 vale circa PF 0,5-0,7 gia prima dei costi; SL, TP e trailing dei set sono pensati per il verso del breakout; i costi pesano in entrambi i versi.
2. **Il fatto che i set invertiti non vadano bene non dice niente sulle idee di rimbalzo al livello** con ordini limit e stop propri: e un'altra struttura.
3. **Regola scritta prima:** nessun set passa => **stop alla strada `ReverseTrades`**, niente ritocchi dei parametri per forzare l'esito.

## Cosa NON dice
Solo oro, 9 set (8 strategie distinte), Modello 1, lotto fisso 0,1, 2 periodi; PF degli originali noto solo per alcune celle; correlazione non misurata; non prova nulla sull'idea del rimbalzo con un EA nostro.
