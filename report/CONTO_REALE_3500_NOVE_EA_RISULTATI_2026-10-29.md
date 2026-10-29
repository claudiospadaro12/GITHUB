# Nove EA su un conto da 3.500 EUR: RISULTATI della stima (29/10/2026)
Criteri e previsioni scritti prima: `CONTO_REALE_3500_NOVE_EA_CRITERI_2026-10-29.md` (commit e90bd2cc). Script `backtest_pipeline/simula_conto_3500_nove_ea.py`; uscita completa in `risultati_archivio/CONTO_3500_NOVE_EA_20261029.txt`. **STIMA da corse a 5.000 (tick reali, 21 mesi gen 2025-ott 2026, oro in forte rialzo, nessun guardiano), non una corsa a 3.500.** Non controllata da agenti. Un solo percorso: partenza 03/01/2025.

## Caso A (P&L e lotti x0,7), partenza 3.500, C0 = tester e C2 = +26 EUR/lotto per giro
| EA | Netto C0 (21 mesi) | Netto C2 | +100% equity (giorni) C0 / C2 | DD equity primi 180 gg (C0) | Equity minima | Peggior giorno (data) |
|---|---|---|---|---|---|---|
| Gold Snap | +44.826 | +39.794 | 180 / 185 | 6,1% (336 EUR) | 3.355 | -9,2% (02/07/2026) |
| SomaGold | +26.762 | +25.416 | 175 / 199 | 13,6% (476 EUR) | 3.024 | -16,6% (23/03/2026) |
| SixtyNine | +13.461 | +11.249 | 416 / 451 | 8,3% | 3.258 | -11,0% |
| Umbra Vault | +8.574 | +6.363 (-26%) | 385 / 467 | 12,1% | 3.319 | -8,7% |
| Microedge | +4.869 | +3.442 (-29%) | 362 / 425 | 11,7% | 3.461 | -8,1% |
| Vortex Turbo | +2.509 | +1.190 | 507 / mai | 5,8% (ma 29% in tutto il periodo) | 3.479 | -12,7% |
| Rocket Breakout | +2.370 | +2.033 | mai | 8,2% | 3.269 | -3,6% |
| Entry Points Pro | +139 | +110 | mai | - | 3.492 | -1,9% |
| ORB Revolution | -334 | -444 | mai | 8,6% | 3.093 | -2,4% |
Equity minima, DD e giorno peggiore sono misurati con il flottante pessimistico dalle barre M1. I giorni peggiori cadono spesso a conto gia cresciuto: nei primi mesi la dimensione e piccola, il peso del giorno peggiore cresce col saldo.

## Caso B (lotti di 5.000 su 3.500, limite opposto)
Gold Snap raddoppia in 153 giorni, SomaGold in 118; **SomaGold ha livello di margine minimo 71% e 328 minuti sotto 100%**; Vortex minimo 94% (30 minuti sotto 100%); nessun EA sotto 50%. DD primi 180 giorni: Gold Snap 8,1%, SomaGold 19,4%, Umbra 16,7%, Microedge 14,8%.

## Previsioni contro esito
R1 (nessuno sotto 1.750): **SI** (minimo 2.820 nel caso B, 3.007 in A). R2 (almeno 3 EA raddoppiano entro 6 mesi, 55%; Gold Snap entro 90 giorni, 55%): **NO e NO** (solo Gold Snap e SomaGold, intorno ai 175-180 giorni in A; in B 153 e 118). R3 (Gold Snap il piu veloce, 65%): **NO** (SomaGold 175 contro 180 in A, 118 contro 153 in B). R4 (peggior giorno >= 5% in almeno 5 EA): **SI** (6 su 9). R5 (almeno 2 EA con minuti di margine sotto 100% in B, 70%; almeno uno sotto 50%, 45%): **SI e NO**. R6 (C2 taglia piu del 20% a Umbra e Microedge e meno del 15% a Gold Snap): **SI** (-26%, -29%, -11%). R7 (Vortex DD piu alto, sopra 25%): **SI** (29,0%).

## Lettura
- Nel tester nessuno dei nove porta il conto da 3.500 sotto il 50%; il piu veloce a raddoppiare resta **circa 4-6 mesi** (SomaGold e Gold Snap), gli altri oltre un anno o mai.
- **I due veloci sono quelli con le code:** SomaGold (giorni a -16,6%, 13 giorni >= 5% in A, margine sotto il 100% anche in A con C2: 55 minuti) e Gold Snap (giorni a -9,2%, 6-8 giorni >= 5%, lotto fino a 2,25 su 3.500). Nel tester i giorni brutti arrivano a saldo gia cresciuto; nelle prime settimane il peggior colpo e il DD dei primi 180 giorni (6-14% in A).
- **I costi del reale pesano:** Umbra e Microedge perdono circa un quarto del netto con +0,30 USD/oz; su un conto che deve raddoppiare in fretta e un fattore.
- Il guadagno e frutto di 21 mesi di oro in forte rialzo, con un solo percorso: **non e una previsione**. I tre anni 2013/2018/2020 sono stati misurati a 80.000 solo in parte per questi EA.
- Riserve: lotto minimo 0,01 non modellato in A (a 3.500 il lotto minimo morde piu che a 5.000, in particolare per SomaGold e Entry Points); margine derivato (8.580 EUR/lotto, leva 1:100 del tester) e stop out del tuo broker NON VERIFICATI; slippage e gap non simulati; nessun guardiano; somma di corse indipendenti non applicabile (ogni EA e preso da solo).
- Acquisti, lotti e taglie sono decisioni di Claudio.
