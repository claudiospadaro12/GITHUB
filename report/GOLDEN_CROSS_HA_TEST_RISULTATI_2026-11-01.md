# Golden Cross HA sull'oro: risultati del test (01/11/2026)
Criteri e previsioni: `GOLDEN_CROSS_HA_TEST_CRITERI_2026-11-01.md` (scritti prima). Codice: `backtest_pipeline/golden_cross_ha_test.py`. Dati: barre M1 BCM con spread, 2013, 2018, 2020 e gen 2025-set 2026; segnali alla chiusura, ingresso alla barra dopo con spread, stop prima del target nello stesso minuto; senza slippage. Non controllata da agenti.

## Risultato principale: le regole, tradotte in numeri, quasi non producono operazioni
Variante principale (H1, ADX 25, 1,5R): **1 operazione in 4 periodi** (perdente). Le 12 varianti pre-registrate danno **da 1 a 13 operazioni** in totale. Imbuto (H1, per periodo, barre in cui il setup si completa progressivamente):

| Periodo | barre | medie ordinate e inclinate | + incrocio 9/21 nelle ultime 6 barre | + distanza <= 1 ATR da EMA21 | + 3 Heiken Ashi (stoppino <= 10% corpo) | + corpo non in riduzione | + ADX >= 20 | + ADX >= 25 |
|---|---|---|---|---|---|---|---|---|
| 2013 | 5.814 | 2.991 | 530 | 232 | 35 | 4 | 1 | 0 |
| 2018 | 5.813 | 2.992 | 582 | 281 | 43 | 11 | 5 | 1 |
| 2020 | 5.844 | 3.027 | 439 | 214 | 28 | 7 | 1 | 0 |
| 2025-26 | 10.220 | 5.328 | 857 | 434 | 45 | 3 | 1 | 0 |
Due elementi bloccano quasi tutto: la richiesta di tre Heiken Ashi consecutive con stoppino trascurabile e **corpo stabile o crescente** (la mia traduzione di una frase del PDF, da 35 casi a 4) e l ADX alto **insieme a un incrocio recente**: l ADX e un indicatore in ritardo come l incrocio e le tre Heiken Ashi, ma il PDF li vuole tutti allineati allo stesso momento. Ho anche provato due traduzioni piu larghe (dichiarate DOPO: stoppino <= 25% del corpo, tolleranza sul corpo 0,5 o nessuna, incrocio nelle ultime 10 barre).

## Varianti con piu operazioni (esplorative, successive ai criteri)
| Variante | n | win | PF netto | netto R | spread pagato | lordo R |
|---|---|---|---|---|---|---|
| larghe 1, M15, ADX 20, 1,5R | 82 | 40% | 1,01 | +0,3 | 8,7 | +9,0 |
| larghe 2, M15, ADX 20, 1,5R | 105 | 39% | 0,96 | -2,7 | 10,8 | +8,2 |
| larghe 2, M15, ADX 20, 2R | 105 | 35% | 1,09 | +5,8 | 11,1 | +16,9 |
| larghe 2, M15, ADX 25, 1,5R | 31 | 39% | 0,95 | -1,0 | 3,1 | +2,1 |
| larghe 2, H1, ADX 20, 2R | 30 | 37% | 1,16 | +3,0 | 2,1 | +5,1 |
Per periodo (larghe 2, M15, ADX 20, 2R): 2013 -14,1R (PF 0,36), 2018 -1,0R, 2020 +9,9R (PF 1,82), 2025-26 +11,0R (PF 1,48). Le varianti H1 e quelle con ADX 25 hanno da 1 a 30 operazioni: nessuna conclusione. Sono 24 varianti in piu delle 12 pre-registrate: le piu "belle" sono quelle con meno operazioni e vanno ignorate.

## Previsioni
- **G1** almeno 100 operazioni nella variante principale: **NO** (1).
- **G2** PF >= 1,15 sui 4 periodi (principale): **NO**, ma non misurabile con 1 operazione.
- **G3** netto positivo in almeno 3 periodi su 4: **NO** (non misurabile).
- **G4** win rate sotto 45% a 1,5R: tecnicamente SI (0% su 1 trade), senza significato; nelle varianti con 80-105 operazioni (M15, ADX 20) il win rate e 39-40%: SI.
- **G5** almeno una delle 12 pre-registrate con PF >= 1,3: tecnicamente **SI** (M15 ADX 20: PF 2,25-2,40) ma **su 13 operazioni**: non e una prova (solo 4-5 periodi in cui dei trade sono avvenuti); il criterio "almeno 100 operazioni" non e soddisfatto.
- **G6** M15 con PF piu bassi di H1: **NO** (i PF M15 sono piu alti, ma sono pochi casi).
- **G7** periodo migliore il 2025-26: nelle varianti larghe M15 il 2020 e il 2025-26 sono i migliori (+9,9R e +11,0R), il 2013 e nettamente negativo: **SI per il 2025-26 insieme al 2020**.

## Lettura
- **Cosi come e scritta, la strategia non e misurabile:** in 4 periodi non genera abbastanza segnali, perche i suoi filtri sono troppo tardivi e troppo numerosi. Se nella pratica Claudio o gli studenti trovano piu setup, e perche valutano a occhio le parti vaghe (stoppino, corpo, ADX "stabile", "spazio tecnico"): la parte discrezionale non e dentro questo test.
- **Con le regole allentate** (varianti esplorative) e piu operazioni (80-105), il profit factor sta fra 0,96 e 1,09: **l edge lordo c e ma e piccolo, e lo spread (8-11R) lo consuma quasi del tutto**. Il 2013 e molto negativo, il 2020 e il 2025-26 positivi: dipende dal regime (trend forte).
- Nessun risultato supera i criteri di accettazione (PF netto >= 1,15 con almeno 100 operazioni e 3 periodi su 4 positivi).

## Cosa NON dice
Solo 4 periodi; regole interpretate da me; nessun giudizio discrezionale; M1 senza slippage. Un esito negativo qui non dimostra che la versione discrezionale non funzioni. Nessun giudizio su acquisti, lotti o taglie.
