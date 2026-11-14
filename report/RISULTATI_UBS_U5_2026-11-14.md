# UBS U5: la candela di conferma dei set V9.0 — RISULTATI (14/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, 100.000 EUR, qualita 98%, lotto fisso 0,1, set cosi come consegnati). Zip `ANNO_ORO_GRADINI_UBSU5_20261114_2152`: 12 passate, tutte OK, stop out 0, "no money" 0; durata circa 1 ora e 15 (le passate durano 55-100 secondi di tester). Criteri e previsioni scritti prima: `UBS_U5_CRITERI_2026-11-14.md` (commit ad935997). Riferimento V0 (candela OFF): `D160_dati/ubsu3m.json` (U3 tappa 1). Validita: nei report i flag sono quelli attesi (V9.0: `UseConfirmationCandleA=true` per tutti, `D=true` per dailyC e dailyI; variante live: `EnableNFP_Filter=true`; controlli: tutti i flag `false`); input imposti nessuno.

## Controlli (set vecchi, candela OFF)
Riproducibili **identici** a U3: dailyC P1 netto 794,09, 163 operazioni, DD 167,32; GTP E P2 netto 3.998,37, 169 operazioni, DD 413,03. Le passate sono deterministiche.

## Celle (V0 = vecchio, V1 = V9.0 candela ON)
| Set | Periodo | Operazioni V0 -> V1 | Netto V0 -> V1 (rapporto) | DD equity EUR V0 -> V1 (rapporto) | PF V0 -> V1 |
|---|---|---|---|---|---|
| dailyC | 2013-18 | 163 -> 164 | 794 -> 705 (0,89) | 167 -> 146 (0,87) | **3,16 -> 2,59** |
| dailyC | 2019-25 | 165 -> 165 | 1.074 -> 1.044 (0,97) | 54 -> 51 (0,94) | ? -> 3,81 |
| dailyI | 2013-18 | 348 -> 359 | 2.320 -> 2.359 (1,02) | 871 -> 773 (0,89) | ? -> 1,30 |
| dailyI | 2019-25 | 375 -> 384 | 4.405 -> 4.132 (0,94) | 698 -> 534 (0,76) | ? -> 1,50 |
| GTP E | 2013-18 | 153 -> 153 | 2.604 -> 2.242 (0,86) | 331 -> 334 (1,01) | ? -> 1,92 |
| GTP E | 2019-25 | 169 -> 169 | 3.998 -> 3.873 (0,97) | 413 -> 380 (0,92) | 2,56 -> 2,64 |
| GTP a | 2013-18 | 428 -> 428 | 7.555 -> 6.797 (0,90) | 970 -> 960 (0,99) | ? -> 1,63 |
| GTP a | 2019-25 | 483 -> 483 | 7.878 -> 7.436 (0,94) | 1.186 -> 1.186 (1,00) | ? -> 1,58 |
**Il PF V0 manca per 6 celle su 8**: nel repo ci sono solo operazioni, netto e DD di U3 tappa 1, non il PF. Per completare la classificazione scritta prima servirebbe lo zip di U3 tappa 1 (`ANNO_ORO_GRADINI_UBSU3M_…`).
Sintesi: **operazioni mai inferiori** (mediana rapporto 1,00; +1/+9/+11 su dailyC e dailyI, identiche sulle altre 5 celle); netto V1 piu basso in 7 celle su 8 (mediana -6%, da -14% a +2%); DD V1 <= V0 in 7 celle su 8 (mediana -7%, da -24% a +1%).
Variante live GTP E (candela ON + NFP ON) contro V1: operazioni 151 contro 153 e 168 contro 169; netto -5% e -1,5%; DD +5% e 0%.
DD01(P1)/DD01(P2): dailyC 3,08 -> **2,85** (fragilita rimane); dailyI 1,25 -> 1,45; GTP E 0,80 -> 0,88; GTP a 0,82 -> 0,81.

## Previsioni (scritte prima) contro risultati
| | Previsione | Esito |
|---|---|---|
| U5-1 | >= 11/12 valide, controllo riproducibile (85%) | **vera**: 12/12 e controlli identici |
| U5-2 | operazioni V1 < V0 in tutte e 8 le celle (80%); mediana 0,70-0,97 (65%) | **FALSA**: mai inferiori, mediana 1,00 |
| U5-3 | netto V1 < V0 in >= 5 celle (55%) | **vera**: 7 su 8 |
| U5-4 | PF V1 >= PF V0 in >= 5 celle (55%) | **NON VALUTABILE** (PF V0 noto in 2 celle: una in calo, una uguale) |
| U5-5 | DD01 V1 <= V0 in >= 5 celle (60%) | **vera**: 7 su 8 |
| U5-6 | dailyC rapporto DD01 P1/P2 resta >= 2 (65%) | **vera**: 2,85 |
| U5-7 | live (NFP ON) operazioni >= 0,90 x V1 in entrambi (75%) | **vera**: 0,99 e 0,99 |
| U5-8 | verdetto: CAMBIA POCO 30%, AIUTA 25%, MISTO 30%, PEGGIORA 15% | **non decidibile con la regola scritta** senza il PF V0; con quello che c'e: nessuna condizione "peggiore" su netto e DD; piu vicino a "cambia poco / effetto misto" |

## Lettura
1. **La candela di conferma non cambia il numero di operazioni** (a differenza della mia previsione): nei daily oro di Wim sembra agire su pochi ingressi o su modalita che non cambiano il conteggio. Cosa faccia esattamente NON e verificato.
2. **Effetto sul risultato: piccolo e di segno quasi sempre uguale**: netto circa -6% e DD circa -7% (mediane): il rapporto netto/DD resta circa invariato (da -15% a +23% a seconda della cella: mescolato).
3. **I nostri verdetti U1-U4 sui 4 set restano sostanzialmente validi**: le differenze sono nell'ordine di -14% / +2% sul netto e -24% / +1% sul DD. Non serve rifare il lavoro fatto.
4. **dailyC resta fragile** (DD01 3 volte piu alto nel 2013-18 che nel 2019-25).
5. **Pacchetto di base per UBS A+C (decisione di Claudio):** V9.0, che e piu recente e piu ampio (382 set contro 283), senza bisogno di rifare U1-U4. Per le famiglie non oro il confronto set per set 283 / V9.0 resta da fare solo se uno dei 43 set cambiati e candidato.

## Cosa NON dice
Solo oro, solo 4 set, Modello 1, lotto fisso, un percorso per cella, due periodi; il PF V0 manca per 6 celle; non misura il tick contro M1 per questi set.
