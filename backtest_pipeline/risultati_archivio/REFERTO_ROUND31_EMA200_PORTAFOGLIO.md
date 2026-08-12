# REFERTO R31 — EMA200 Dow nel portafoglio (12/08): LA SEDIA 12

## Controlli (tutti superati)
Gemelli del magic-sweep identici al centesimo (riepiloghi E per-trade,
salvo la colonna magic). PF OOS 1,52 = R29 esatto. Chiusure 517 vs 444
di R29: i PARZIALI a taglia 100k (fenomeno noto da R23). Serie:
12/06/2025 -> 26/06/2026, netto OOS **+23.321,47**.

## Il portafoglio da 11 a 12 serie (stesse date, 100k, 1%)

| Metrica | 11 serie | **12 serie** |
|---|---|---|
| Netto OOS | +102.933 | **+126.255 (+23%)** |
| MAX DD storico | 10,08% | **9,50% — SCESO** |
| MC p50 / p95 / p99 | 6,66 / 11,68 / 14,79 | **6,37 / 11,08 / 14,45 — TUTTI giu'** |
| Peggior giornata | -3.843 (-3,84%) | -4.486 (-4,49%) |
| Beneficio diversificazione | +27,8 punti | **+35,9 punti** |

**+23.321 di profitto in piu' e TUTTE le code di rischio MIGLIORATE.**
Alla taratura 0,65%: p99 ~9,4% (<10% FTMO ✓), peggior giornata ~-2,9%
(<5% ✓). Prima volta che un ingresso abbassa il DD storico E le code MC
mentre aggiunge il 23% di profitto.

## La domanda del quinto motore sul Dow: RISPOSTA — scorrelato
| vs | correlazione |
|---|---|
| Dow Apertura | +0,13 (la piu' alta, ed e' poca cosa) |
| **ORB Dow** | **-0,09 (negativa!)** |
| SuperWave Dow | +0,07 |
| PTE Dow | +0,04 |
| Tutto il resto | fra -0,09 e +0,06 |
Cinque motori sullo stesso simbolo, cinque orologi diversi (M5
apertura, M5 range, H1 trend-pullback, H1 breakeven, H2 onda): la
scorrelazione e' vera anche in famiglia.

## Proposta (decisione a Claudio): VIVAIO
Deploy sul demo piccolo, cella CENTRO (TF H1, O1 0,20, O2 0,3, TP 2,0),
rischio 1%, magic forward vergine, commento EMA200 DOW. Nota di
velocita': a ~40 trade/mese, il collaudo (10) arriva in DIECI GIORNI e
il verdetto (30) in UN MESE — il candidato piu' rapido mai avuto.
Bandierina gialla di R29 sempre valida (OOS > IS: una finestra e' un
campione): un motivo in piu' per cui il vivaio decide, non il backtest.
