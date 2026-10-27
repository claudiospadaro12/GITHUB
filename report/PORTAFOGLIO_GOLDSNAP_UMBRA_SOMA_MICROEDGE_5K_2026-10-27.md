# Gold Snap + Umbra + SomaGold + Microedge insieme su un conto piccolo: stima dal tester (27/10/2026)
**Natura: STIMA da misure gia in archivio (DEEP5K_PERSONALE, 5.000 EUR, 21 mesi a tick reali) + barre M1 BCM esportate il 27/10. Non controllata da agenti.** Domanda di Claudio: "insieme mi brucerebbero il conto da 5.000 che adesso e 3.500?". Strumento: `leggi_portafoglio_5k_quattro_ea.py`.

## Metodo e limiti
Si sommano i P&L ricostruiti (realizzato + flottante da barre M1) delle quattro corse a 5.000, ognuna col suo dimensionamento (da sole). Insieme su un conto solo ognuna dimensionerebbe sul saldo comune: all'inizio e uguale, dopo no. Margine: 8.580 EUR per lotto (tester BCM, R114, DERIVATO: il margine del conto reale e NON VISTO; livello di stop out del broker NON VISTO). Conto da 3.500: caso A = tutti i lotti e i P&L scalati 0,7 (percentuali invariate); caso B = lotti di 5.000 su 3.500 (SomaGold sta al lotto minimo 0,01 nel 73% degli ingressi, che non scala). Nessuna slippage, nessun gap, nessun ordine rifiutato per margine (SomaGold ne ha 84 da solo a 5.000). Periodo: 21 mesi di oro in forte rialzo.

## Risultati
Da soli, a 5.000, 21 mesi: nessuno stop out. Equity minima: Gold Snap 4.793, Umbra 4.747, SomaGold 4.335, Microedge 4.954. DD equity dal picco: 11,6% / 12,1% / 20,3% / 13,5%.
**Tutti e quattro insieme (somma): equity minima 4.531 (mai sotto), DD equity massimo 14,5% dal picco, peggior giorno -10,1% (03/02/2025, 8 giorni oltre -5%), massimo 6,32 lotti insieme (a conto cresciuto), livello di margine minimo 66%, 83 minuti sotto il 100%.**
**Fase iniziale (primi 90 giorni dal 03/01/2025), conto da 3.500:**
| caso | equity minima | DD max | margine minimo | minuti margine <100% / <50% | lotti insieme max |
|---|---|---|---|---|---|
| A (scalato 0,7) | 3.172 | 14,4% (613 EUR) | 66% | 88 / 0 | 0,71 |
| B (lotti di 5.000) | 3.031 | 19,1% (876 EUR) | **44%** | 390 / **49** | 1,02 |
SomaGold da solo nel caso B: margine minimo 71%, 235 minuti sotto il 100%.

## Lettura
- Nel tester il conto non va a zero e non c'e stop out dichiarato a 50%: ma nel caso B il margine scende a 44% per 49 minuti, e un livello di stop out reale a 50% sarebbe stato superato. Il margine, non il DD, e il rischio concreto dell'insieme.
- Giorni da -10% e DD di 600-900 EUR sui 3.500 nei primi 90 giorni: e il caso migliore (21 mesi di rialzo, nessuna slippage).
- Riserve: somma di corse indipendenti, margine derivato, stop out del broker non visto.
