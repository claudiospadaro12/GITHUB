# RITIRATO (11/11/2026, sera): le conclusioni sotto NON valgono
**Le 3 passate NFP-off del Gold Trade Pro sono CONFUSE da input ereditati dal tester.** Il report mostra `FridayStopHour=19` (nel riferimento D160 era 25) in tutte e 3: il tester ricorda il valore salvato dalla prova GTP del venerdi 19:00 (9/11) quando l'input non e imposto. La riga non lo imponeva (solo Risk, MaxRisk, DD giorno ed `EnableNFP_Filter`). Prova: il braccio C0 del Virtual SL/TP (virtual spento, nessun cambio NFP voluto) da' gli STESSI identici netti (29.650 / 9.439 / 16.705), perche anch'esso aveva ereditato `FridayStopHour=19` ed `EnableNFP_Filter=false` dalla passata precedente. Quindi il -8,9% (e il -28% del 2020) e l'effetto della chiusura del venerdi alle 19:00 (che nel 2020 costa al GTP -31%, misurato), NON dell'NFP. Il test va rifatto imponendo tutti gli input "appiccicosi". Le righe corrette sono rigenerate (`RIGA_LANCIA_NFPOFF_GTP`, `RIGA_LANCIA_NFPOFF_ORO`).

---
# Filtro NFP spento: risultati del Gold Trade Pro (11/11/2026, sera) — 3 passate

**Natura: MISURA, parziale** (solo la riga GTP della coppia; la riga oro non e arrivata). Criteri e previsioni scritti prima: `CRITERI_NFP_OFF_2026-11-11.md`. Gold Trade Pro Combo (Risk 3, MaxRisk 0,5, DD giorno 4,0), XAUUSD D1, 160.000 EUR, Modello 1, 2013 / 2020 / 2025, `EnableNFP_Filter=false` (unico input cambiato), 1 passata per anno (deterministico). Riferimento: D160 GTP (filtro acceso). Script `D160_dati/analisi_nfpoff_gtp.py`.

## Validita
3/3 valide: stato OK, qualita 99-100%, zero stop out e zero "no money", input imposti confermati dal report (Risk, MaxRisk, DD giorno e `EnableNFP_Filter=false`).

## Risultati
| Anno | Netto filtro spento / acceso | PF | DD equity | Peggior giorno realizzato | Operazioni | Posizioni aperte attraverso il rilascio NFP (spento / acceso) |
|---|---|---|---|---|---|---|
| 2013 | 29.650 / 29.858 (-0,7%) | 2,40 / 2,42 | 4,45% / 4,48% | -4.350 / -4.350 | 321 / 325 | 3 / 3 |
| 2020 | 9.439 / 13.087 (**-27,9%**) | 1,52 / 1,75 | 4,67% / 6,15% | -2.286 / -2.023 | 286 / 288 | 1 / 1 |
| 2025 | 16.705 / 18.290 (-8,7%) | 2,52 / 2,70 | 2,05% / 2,00% | -1.696 / -1.696 | 273 / 276 | **0 / 0** |
| **3 anni** | **55.793 / 61.235 (-8,9%)** | | DD massimo +0,05 pt (2025); in 2020 -1,48 pt | peggioramento massimo 263 EUR (0,16 pt di 160k) | -1,1% | |

## Lettura con le regole dei criteri
- **Filtro spento davvero?** La regola scritta ("nel 2025 almeno una posizione attraversa l'NFP") **non e soddisfatta**: 0 posizioni anche con il filtro spento. Tuttavia i numeri cambiano (operazioni -1%, netto -9%), quindi il filtro ha un effetto, ma piccolo e **non visibile come posizioni attraverso il rilascio** nel 2025 (con finestre di 10 minuti prima e 240 dopo, e il GTP D1 che apre in ore diverse). Va detto: la passata non dimostra il caso "il filtro NFP e davvero la causa".
- **Costo (GTP, deterministico): NEUTRO** sui 3 anni (netto -8,9%, entro il 10%; DD non sale oltre 1 punto, anzi cala; peggior giorno entro 0,5 punti). Ma **per anno il 2020 cala del 28%**: la regola e per EA sulla somma, ma l'anno 2020 e il caso piu lontano.
- **Previsioni**: N1 (21 passate valide) in attesa dell'oro; N2 (operazioni in aumento) falsa per il GTP (calano dell'1%); N3 (2025 con almeno una posizione attraverso l'NFP) falsa per il GTP (0); N4 (netto cambia di piu nel 2025 che nel 2013 e 2020) falsa (2020 -28%, 2025 -9%, 2013 -1%); N5 (solo Goldbot); N6 GTP non e PEGGIORE (-8,9% e -15% la soglia); N8 (peggior giorno oltre 0,5 punti) falsa (0,16 pt); N9 verdetto portafoglio: da chiudere con i 4 EA oro.

## Cosa si legge, e cosa NO
Per il GTP spegnere il filtro NFP **non porta niente e costa circa il 9%**: va nella direzione di tenerlo acceso (parere di Massimo e mio). Un solo EA, un percorso per anno, deterministico; il tester non allarga lo spread nelle news; non dice nulla su Phantom, Reaper e Goldbot (riga oro non arrivata); le date NFP sono da una lista mia.
