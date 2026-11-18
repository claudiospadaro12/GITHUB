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

## Risultato (18/11/2026; `backtest_runner/simulatore/smc_luxalgo_replica.py`)
Prima versione del simulatore: **errore mio** (scartava le operazioni il cui blocco veniva toccato e rotto nella stessa barra: PF 1,95 sull'oro, falso). Corretto prima di leggere i verdetti: il limit che si riempie e va subito a stop e una perdita.
| Mercato | Modulo | Operazioni | R netto | PF | t | 2014-17 / 2018-20 (R) | Verdetto |
|---|---|---|---|---|---|---|---|
| EURUSD | A_INT | 937 | -0,047 | 0,93 | -1,0 | +0,051 / -0,146 | NON PASSA |
| EURUSD | A_SWG | 58 | -0,274 | 0,65 | -1,6 | -0,078 / -0,498 | NON PASSA |
| EURUSD | B_CHOCH | 8 | -0,259 | 0,66 | -0,5 | n.d. | NON PASSA (< 100 operazioni) |
| XAUUSD | A_INT | 1.083 | +0,098 | 1,15 | 2,2 | +0,037 / +0,160 | **NON PASSA** (PF < 1,20) |
| XAUUSD | A_SWG | 61 | +0,040 | 1,06 | 0,2 | +0,243 / -0,121 | NON PASSA |
| XAUUSD | B_CHOCH | **45** | **+0,893** | **3,46** | 4,2 | +0,909 / +0,880 | **NON PASSA per numerosita (< 100)** |
Previsioni: nessun modulo passa (85%) -> **si, per le regole scritte**; almeno un modulo con PF netto > 1 su un mercato (35%) -> si (oro A_INT 1,15 e B_CHOCH 3,46); B_CHOCH piu frequente di A_SWG (90%) -> **falso** (8 e 45 contro 58 e 61).
**Lettura onesta:** gli order block (il pezzo piu "disegnato" dell'indicatore) non danno un vantaggio: EURUSD negativo, oro appena positivo (PF 1,15, sotto la soglia). **B_CHOCH sull'oro e l'unico dato notevole**: dopo la rottura (chiusura sopra/sotto il pivot di swing a 50 barre, nel verso opposto al trend precedente) il prezzo prosegue di almeno 1 volta il rischio nell'84% dei casi (RR 1), di 2 volte nel 64%, di 3 volte nel 50%; positivo in 6 anni su 7, long e short; regge con ingresso ritardato di 1 e 3 barre (R 0,84 e 0,76). **Ma:** 45 operazioni in 7 anni (circa 6 l'anno), un solo mercato (su EURUSD solo 8 operazioni e negative), e le verifiche di robustezza (RR, ritardo, direzione, anno) sono state fatte DOPO aver visto il numero: non e una conferma. Sotto la porta delle 100 operazioni: **indizio da verificare, non un risultato**. Prova utile: altri anni dell'oro (2005-2013, 2021-2026), altri mercati (indici, forex con piu storia), stesso codice, criteri scritti prima.
