# LuxAlgo "Smart Money Concepts": esame e test — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
L'indicatore (CC BY-NC-SA 4.0, incollato da Claudio) **disegna soltanto**: struttura (BOS/CHoCH, interna con pivot di 5 barre e di swing con 50), order block (OB), EQH/EQL, FVG, livelli e zone. **Non ha segnali, stop o target**: le regole di ingresso qui sotto sono NOSTRE, fissate ora, minime e canoniche; non sono "la regola del corso". Logica dell'indicatore replicata fedelmente in Python (leg, pivot, crossover di chiusura, OB = candela del minimo/massimo del tratto dal pivot alla rottura, mitigazione a High/Low, filtro volatilita ATR(200) a 2x).
## Moduli (3, nient'altro)
- **A_INT:** ordine limit al primo ritorno nell'order block **interno** (pivot 5). Long: limit al massimo dell'OB rialzista, SL = minimo dell'OB, TP = 2 x rischio. Short speculare. L'OB nasce alla rottura di struttura (BOS o CHoCH), scade se mitigato (prezzo oltre l'estremo lontano) o dopo 100 barre.
- **A_SWG:** come A_INT con l'OB **di swing** (pivot 50).
- **B_CHOCH:** ingresso all'apertura della barra successiva a un **CHoCH di swing** (direzione del nuovo trend), SL = estremo opposto dello swing in corso (ultimo pivot opposto), TP = 2 x rischio; scartato se il rischio supera 5 ATR(14).
Una sola posizione alla volta per mercato. SL controllato prima del TP nella stessa barra; nella barra di fill il TP non conta. Costo per operazione sottratto: EURUSD 0,8 pip (0,00008), XAUUSD 0,30 USD, diviso per il rischio dell'operazione.
## Dati
EURUSD H1 (2014-11 / 2020-12, 38.265 barre) e XAUUSD H1 (2014-2020) dai CSV M1 FTMO gia in sessione. Metà 1 = 2014-2017, metà 2 = 2018-2020.
## Porte (nessuna ritoccabile)
**PASSA** (per modulo e per mercato) se: >= 100 operazioni, R netto medio > 0, PF netto >= 1,20, t >= 2,0, **e** R netto medio > 0 in entrambe le metà. **PASSA FORTE** se passa su entrambi i mercati. Altrimenti NON PASSA.
## Previsioni
Nessun modulo passa su nessun mercato: **85%**. Almeno un modulo con PF netto > 1,00 su almeno un mercato: **35%**. B_CHOCH piu frequente di A_SWG: **90%**.
## Limiti
Tre moduli ma due mercati e sei anni: 6 sguardi. Regole nostre. Un percorso storico per mercato, barre H1, nessun tick. Gli OB di LuxAlgo sono pensati per la lettura visiva.
