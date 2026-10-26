# Come si comportano gli EA a 5.000 EUR nei regimi LONG, SHORT e LATERALE: criteri scritti PRIMA dei numeri (26/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): rifare il test "suddiviso su 3 anni, long, short o laterale, per capire come si comportano gli EA che abbiamo misurato sui 5K", **"per vedere se sono solidi"**. Acquisti, lotti e taglie restano sue decisioni.

## Limite dichiarato: non sono 3 anni di tick reali
I tick reali BCM dell'oro iniziano il **10/07/2024** (VERIFICATO nei manifest: `ticks_inizio XAUUSD 2024.07.10`). Prima non c'e un test con la stessa qualita. Si hanno **21 mesi gia misurati** (gen 2025-set 2026, tutti i 9 EA a 5.000 EUR, `DEEP5K_PERSONALE_20261026`) e si possono aggiungerne **6** (lug-dic 2024) per arrivare a 27 mesi (2 anni e 3 mesi). Per i 3 anni pieni servirebbe un modello a barre (Modello 1/M1 OHLC): qualita diversa, **NON VERIFICATO** quanta storia BCM ci sia, e non confrontabile con i numeri di prima.

## Definizione del regime (scritta ORA, dai SOLI prezzi dell'oro, mai dai risultati degli EA)
Fonte: `data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv` (VERIFICATO, barre D1 BCM). Per ogni mese: rendimento = chiusura dell'ultimo giorno del mese / chiusura dell'ultimo giorno del mese prima - 1.
- **LONG**: rendimento >= +3%. **SHORT**: rendimento <= -3%. **LATERALE**: fra -3% e +3%.
- Soglia +-3% scelta da me prima di guardare gli EA; e **ex post** (il regime si conosce a mese finito): descrive in che ambiente l'EA ha lavorato, non e una previsione.
Mesi (rendimento): 
- LONG: 2024.07 (+5,3), 2024.09 (+5,3), 2024.10 (+4,2), 2025.01 (+6,7), 2025.03 (+9,5), 2025.04 (+4,8), 2025.08 (+4,7), 2025.09 (+11,9), 2025.10 (+3,5), 2025.11 (+5,6), 2026.01 (+12,1), 2026.02 (+8,8), 2026.08 (+9,8).
- SHORT: 2024.11 (-3,5), **2026.03 (-11,1), 2026.06 (-11,5), 2026.09 (-6,6)**.
- LATERALE: 2024.08 (+2,3), 2024.12 (-1,0), 2025.02 (+1,9), 2025.05 (+0,6), 2025.06 (+0,5), 2025.07 (-0,5), 2025.12 (+2,3), 2026.04 (-1,1), 2026.05 (-2,1), 2026.07 (+1,0).
Sui 21 mesi gia misurati: **10 LONG, 8 LATERALE, 3 SHORT**; con i 6 mesi del 2024: 13 / 10 / 4. **Il campione SHORT e piccolo (3-4 mesi): ogni conclusione sullo SHORT e debole**, e lo dico.

## Cosa si misura per ogni EA e regime (dai realizzi per data di chiusura, in % del saldo a inizio mese)
Numero di mesi, rendimento mensile medio, mesi positivi, **peggior mese**; il netto in EUR e il numero di operazioni; il netto per **direzione della posizione** (posizioni long o short) dentro ogni regime. I mesi si leggono con i saldi che compongono (il lotto cresce col saldo), per questo il rendimento mensile e in % del saldo di inizio mese.

## "SOLIDO" (definizione scritta ora)
Un EA e **SOLIDO** se, nei regimi con almeno 3 mesi: (a) rendimento mensile medio > 0 in **tutti e tre**; (b) almeno il 50% dei mesi positivi in ciascuno; (c) nessun mese peggiore di -10% del saldo di inizio mese. Altrimenti si scrive **DEBOLE IN <regime>** e quale condizione fallisce. Etichetta di lettura, non una soglia di acquisto: **SOLIDO non vuol dire sicuro** (21-27 mesi, un solo mercato, tester senza slippage, gap, liquidita, ottimizzazione del venditore su periodi non dichiarati).

## Previsioni dichiarate ORA
- Q1: almeno un EA risulta SOLIDO: 35%.
- Q2: il rendimento mensile medio in SHORT e inferiore a quello in LONG per almeno 7 EA su 9: 80%.
- Q3: rendimento mensile medio in SHORT negativo per almeno 4 EA su 9: 55%.
- Q4: in LATERALE almeno 5 EA su 9 hanno rendimento medio positivo: 65%.
- Q5: nei mesi LONG il netto delle posizioni long supera quello delle posizioni short per almeno 7 EA su 9: 70%.
- Q6: nei mesi SHORT almeno 2 EA hanno un mese peggiore di -10% (fra i 3 mesi con calo): 55%.
Lettore: `backtest_pipeline/leggi_regimi_5k.py` (congelato prima dei numeri, con `--autotest`).
