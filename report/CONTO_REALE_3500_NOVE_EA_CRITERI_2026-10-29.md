# Simulazione dei nove EA su un conto da 3.500 EUR: criteri e previsioni scritti PRIMA dei numeri (29/10/2026)
Non controllata da agenti. Richiesta di Claudio (29/10): "simula questi EA con il mio conto reale da 3.500". STIMA da corse gia in archivio (`DEEP5K_PERSONALE_20261026`: nove EA, 5.000 EUR, XAUUSD H1, tick reali, 01/01/2025-01/10/2026, nessun guardiano) + barre M1 BCM 2025. NON e una corsa nuova a 3.500: serve una corsa vera sul PC di backtest per le conferme (lotto minimo 0,01 e margine).
Il conto reale ha saldo ~3.745 piu 2.500 di credito del broker (note precedenti): qui si parte da 3.500 come detto da Claudio.

## Metodo
- **Caso A (scalato 0,7):** P&L e lotti della corsa a 5.000 moltiplicati per 0,7, partenza 3.500. Equivale a un EA col lotto proporzionale al saldo; NON modella l arrotondamento al lotto minimo 0,01.
- **Caso B (lotti di 5.000 su 3.500):** limite opposto, lotti non ridotti.
- **Costi:** C0 = tester (commissione e spread del feed gia dentro, slippage zero). C2 = +0,30 USD/oz extra per giro (circa 26 EUR/lotto, ipotesi gia usata nella classifica del 26/10), sottratto alla chiusura di ogni posizione, sui lotti scalati.
- **Margine:** 8.580 EUR per lotto (tester BCM, leva 1:100 del tester, DERIVATO); la leva e lo stop out del conto reale NON sono verificati.
- **Un solo percorso** (gen 2025 - ott 2026, oro quasi sempre in rialzo): il lotto cresce col saldo, quindi non si puo rifare la partenza da altre date scalando.

## Misure per EA
Netto e % sui 3.500; equity minima e quando; DD equity dal picco (% e EUR); peggior giorno (% dal saldo di inizio giornata) e giorni >= 5%; **giorni di calendario per portare l equity a 7.000 (+100%)** e l equity minima prima di arrivarci; livello di margine minimo e minuti sotto 100% e sotto 50% (A e B).

## Previsioni (probabilita)
- **R1** In caso A nessuno dei nove scende sotto 1.750 (meta del conto) in equity: 90%.
- **R2** In caso A almeno 3 EA raddoppiano (equity >= 7.000) entro 6 mesi: 55%; Gold Snap raddoppia entro 90 giorni: 55%.
- **R3** Gold Snap e il piu veloce a raddoppiare fra i nove: 65%.
- **R4** In caso A il peggior giorno e >= 5% per almeno 5 EA: 70%.
- **R5** In caso B almeno 2 EA hanno minuti con livello di margine < 100%: 70%; almeno uno sotto 50%: 45%.
- **R6** Con C2 il netto cala di piu del 20% per Umbra e Microedge e di meno del 15% per Gold Snap: 65%.
- **R7** Vortex ha il DD equity piu alto in percentuale (sopra 25%): 80%.
