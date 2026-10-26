# 9 EA a 5.000 EUR su 2013 SHORT, 2018 LATERALE, 2020 LONG — RISULTATI (26/10/2026)
Criteri, calibrazione e SOLIDO-ANNI scritti prima dei numeri: `TRE_ANNI_REGIMI_5K_CRITERI_2026-10-26.md`. Lettore congelato `backtest_pipeline/leggi_tre_anni_5k.py`. Zip `ANNO5K_TRE_ANNI_20261026_1345` (36 corse, tutte stato OK); archivio `risultati_archivio/ANNO5K_TRE_ANNI_ZIP_1345` (solo manifest, referti, ini, report .htm.gz; NB il lettore ricava l'anno dal percorso: il nome della cartella contenitore non deve contenere 20xx). Modello 1 (OHLC 1 minuto), H1, XAUUSD, 5.000 EUR, leva 1:100 (quella del tester), input default, nessun guardiano. Spread storico delle barre: NON VERIFICATO.

## Esito per EA (netto EUR e % di 5.000 / PF / DD equity relativo)
| EA | 2013 SHORT | 2018 LATERALE | 2020 LONG | Calibr. 2025 | SOLIDO-ANNI |
|---|---|---|---|---|---|
| Vortex Turbo | +2.193 (+43,9%) PF 2,64 DD 11,7% | +2.819 PF 4,99 DD 7,1% | +4.535 PF 6,44 DD 11,1% | OK (1,47; 0,82) | **SI** |
| Umbra Vault AI | +4.068 PF 78,5 DD 2,6% | +3.465 PF 114 DD 2,1% | +3.928 PF 6,84 DD 8,0% | OK (1,08; 0,82) | **SI** (vedi sotto) |
| SomaGold | +5.182 PF 2,20 DD 10,8% | +2.222 PF 2,08 DD 12,2% | +12.685 PF 3,34 DD 15,0% | OK | NO: 2020 peggior mese −13,5% |
| Gold Snap | +3.283 PF 1,41 DD 15,9% | +2.748 PF 1,43 DD 18,6% | +6.086 PF 5,71 DD 4,2% | OK | NO: 2018 peggior mese −10,5% |
| Microedge | +4.301 PF 102 DD 5,7% | +2.811 PF 126 DD 3,9% | +4.320 PF 83 DD 4,4% | **NON ATTENDIBILE** (corr. mensile 0,40) | NO: calibrazione |
| SixtyNine | +1.245 PF 1,11 DD 14,2% | −1.172 PF 0,69 DD 24,0% | +356 PF 1,03 DD 39,3% | OK | NO: 2018 negativo; 2020 DD 39,3%, peggior mese −17,7% |
| Entry Points Pro | +886 PF 1,61 | −430 PF 0,79 | −66 PF 0,96 | OK | NO: 2018 e 2020 negativi |
| Rocket Breakout | −1.510 (−30,2%) PF 0,66 DD 34,4% | −250 PF 0,95 | +719 PF 1,15 | OK | NO: 2013 −30%, DD 34%; 2018 negativo; righe no money |
| ORB Revolution | −605 PF 0,74 | −744 PF 0,65 | −671 PF 0,69 | OK | NO: negativo in tutti e tre |

Nessuno stop out in nessuna delle 36 corse.

## Lettura (Claude, nessun merito d'acquisto)
- **Vortex** e il solo con un profilo credibile: 30-40% di operazioni perdenti, perdite piccole (media −5/−10 EUR), positivo e con DD sotto 12% in tutti e tre i regimi; calibrazione OK. Le perdite singole massime: −378 (2013) e circa −25/−29 negli altri.
- **Umbra e Microedge: PF 78-126 NON e robustezza, e la firma di un EA che quasi non chiude in perdita.** Umbra: 167 vincenti su 170 nel 2013, 3 perdenti da 0,3 EUR; nel 2020 5 perdenti con perdita massima −607 EUR (12% del conto) e nel 2025 −512; Microedge 2013/2018/2020: 0-3 perdenti da −0,2, nel 2025 −684. Cioe nelle annate "tranquille" non e stata campionata la coda: la coda esiste (2020 e 2025) e vale circa −10/−14% in una sola operazione. Il confondente dichiarato nei criteri (stop in punti fissi: a 1.200-2.000 USD 3.000 punti sono molto piu larghi in % che a 4.000) agisce qui. SOLIDO-ANNI per Umbra vale per la definizione scritta, ma **la lettura onesta e "nessun fallimento osservato, coda non campionata"**. Microedge non e valutabile (calibrazione fallita).
- **SomaGold e Gold Snap** falliscono SOLO sul peggior mese (−13,5%, −10,5%), per una frazione: sono positivi in tutti e tre gli anni e a DD sotto 19%. SomaGold: "no money" molto alto (474, 406, 284 righe): il margine blocca ordini, il Modello 1 puo gonfiare o ridurre il numero reale di operazioni.
- **SixtyNine** non regge: 2018 negativo e 2020 con DD 39%.
- **ORB Revolution, Entry Points, Rocket** non reggono in questi anni (ORB perde in tutti, in linea col suo 2025 a −9%).
- Calibrazione 2025 M1 contro M4: OK per 8 EA su 9; i rapporti vanno da 0,98 a 1,47 (Vortex 1,47 e SixtyNine 1,42: il Modello 1 sovrastima fino al 50%); per Microedge la correlazione mensile e 0,40 (< 0,5).

## Scorecard delle previsioni
- C1 (calibrazione OK per almeno 6 su 9, 50%): **centrata** (8/9).
- Y1 (almeno un stop out nei tre anni, 40%): **no** (0 su 36).
- Y2 (2013 anno peggiore per almeno 5 su 9, 55%): **mancata**: il 2013 e il peggiore solo per 2 EA (Rocket, Vortex); **il peggiore e il 2018 laterale per 7 EA su 9**.
- Y3 (2018 positivo per almeno 5 su 9, 55%): centrata, di misura (5 su 9).
- Y4 (almeno 2 SOLIDO-ANNI, 35%): centrata (2: Vortex, Umbra), ma con la riserva su Umbra.

## Cosa NON dice
Tre anni sono tre campioni, non una prova; Modello 1 non e tick reale; prezzi molto piu bassi di oggi; i default possono essere fuori taratura negli anni vecchi; nessun merito d'acquisto, taglia o lotto.
