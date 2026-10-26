# Candidati da valutare: conto reale senza guardiano e prop FTMO 80K (26/10/2026)
**Natura: LETTURA di misure gia in repo + un calcolo nuovo sul Gold Reaper. Non e una raccomandazione di acquisto**: acquisti, spesa, lotti e taglie sono decisioni di Claudio. Tutto e tester (tick reali 21 mesi gen 2025-set 2026, oro quasi sempre al rialzo, slippage zero salvo dove detto), realizzato = limite inferiore per i giorni.

## Prop FTMO 80K (serve: nessun giorno vicino al 5%, DD totale lontano dal 10%)
| EA | Evidenza | Cosa manca / limite |
|---|---|---|
| The Gold Reaper (set di Claudio) | 80K: +59.796 (+74,7%), PF 2,89, DD equity 4,8% di 80K, 0 giorni con perdita realizzata >= 3% (peggiore -1,2%, -1.514), 18/21 mesi positivi; primi 12 mesi da 80K +35%, +10% il 23/04/2025, nessuna violazione; con costi extra C2 (0,30 USD/giro) netto 56.579, PF 2,76; latenza 1000 ms: -1,2% | NON e il prodotto "as is" (4 input imposti: TradeFrequency=2, MaxAllowedDD=9, PropFirmMaxDailyDD=4, OnlyUp=false: protezioni interne che potrebbero chiudere il flottante, intervento non verificabile dal report); S-NOSCALA alla lettera non passa (11 posizioni, rapporto lotti 6); mai provato su 2013/2018/2020 |
| Goldbot One (step 6000, tick reali) | 80K: +9.537 (+11,9%), PF 1,69, DD equity 4,29%, peggior giorno -1,39%, 15/21 mesi, 8 posizioni, rapporto lotti 3,0 (sul bordo) | step 3000 NON misurato (corsa KO); guadagno lento; con Gold Reaper S-CORR NON passa (0,53 realizzi, 0,67 equity), DD combinato fra 4,5% e 8,8% (step 6000) |
| Prop Firm Gold EA | 80K: +34.130, PF 1,25, DD 9,7%, 0 giorni >= 3% (peggiore -2,3%), S-STAB ok; costi C2: PF 1,22 | PF basso, margine S-M di 1 mese, tempo lungo per il +10% |
Non adatti alla prop senza guardia (giorni >= 5% realizzati): Umbra 3, Microedge 5, Vortex 3, SomaGold 2, Gold Snap 1; con la guardia del venditore Umbra e Microedge peggiorano (3->12, 5->11 giorni a -5%). SixtyNine: 7 giorni >= 3% (max -4,6%). Rocket: 2 giorni >= 3% (max -3,7%), 2013 -30%. Smart Gold Hunter: +276 in 21 mesi (nessun utile utile). Entry Points e ORB: nessun vantaggio. TitanForge, Nebula, EA Super Trend: S-DD fallita.

## Conto reale 5.000 senza guardiano (serve: poco flottante, niente griglia/martingala, nessuna perdita singola enorme rispetto al conto)
- Poco flottante misurato: Gold Reaper (DD equity 4,77% a 5K, 79% netto, PF 2,88), Goldbot One (step 6000: DD 4,3%). Stessa riserva sulle protezioni interne del Reaper.
- Una posizione con SL fisso, DD 11-14% ma con coda su singola operazione: Umbra (SOLIDO-ANNI con riserva, ma 3 anni: perdita singola -607 = 12% del conto), Microedge (calibrazione tre anni NON attendibile), Gold Snap (rischio 2% per operazione, lotto fino a 51 nel tester): etichetta REGGE a 5K, ma perdono 11-30% del netto con i costi.
- Esclusi per il meccanismo che ti ha colpito sul reale (flottante grosso): Vortex (griglia con raddoppio, DD 29,5%, SCOSSO), SomaGold (32 sotto-strategie, 31 posizioni, margine, SCOSSO), Arena (griglia, due mesi su due con stop out a tick reali), SixtyNine (fino a 7 posizioni, DD 12%, 2018 negativo e 2020 DD 39%).
- Rocket: +68% a 5K, DD 7,9%, ma 2013 -30% (DD 34%).

## Passi di verifica che posso fare io (nessun acquisto)
1. Gold Reaper, Goldbot One, Prop Firm Gold sui tre anni 2013/2018/2020 e con la classifica dei costi (oggi mancano).
2. Export M1 (equity giornaliera vera) per i giorni a rischio FTMO.
3. Chiarire se il Gold Reaper "as is" intervenga sul flottante con le sue protezioni (prova con le due protezioni spente, accanto al set).
4. Forward su demo >= 4 settimane, un EA alla volta (regola del 19/10), se la licenza lo consente.
5. Registratore di slippage sull'oro.
