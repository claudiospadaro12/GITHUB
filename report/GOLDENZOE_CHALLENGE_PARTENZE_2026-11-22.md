# GoldenZoe: simulazione di una challenge prop con partenze diverse (22/11/2026)
Simulatore (`backtest_runner/simulatore/goldenzoe_challenge.py`): oro FTMO M1, EA base (canale 55, stop 3 ATR, Chandelier 3 ATR, solo acquisti), conto 80.000, rischio % dell'equity per operazione (composto), costi FTMO (0,35 USD + swap 5,5%), equity ai minimi del minuto. **Regole ASSUNTE (non verificate: mail a FTMO in sospeso):** challenge a due fasi, obiettivo 10% (fase 1) e 5% (fase 2), perdita massima giornaliera 5% e totale 10% dal capitale iniziale (fallisce se l'equity tocca 72.000), nessun limite di tempo, obiettivo raggiunto a saldo chiuso. Partenze: una a settimana dal 01/01/2015 (603 partenze) e dal 22/11/2022 (192 partenze); a ogni partenza il conto riparte da 80.000 e l'EA aspetta il primo segnale. Percentuali "entro N mesi" calcolate sulle partenze che hanno almeno N mesi di dati dopo; formato passata% / fallita%.
| Set (rischio) | Finestra | Obiettivo | Entro 6 mesi | 12 mesi | 18 mesi | 24 mesi | Fallite in totale | Mediana giorni (solo chi passa) |
|---|---|---|---|---|---|---|---|---|
| PROP 0,5% | dal 2015 | 10% | 0 / 0 | 0 / 0 | 1 / 0 | 11 / 0 | 0 | 1713 |
| PROP 0,5% | ult. 4 anni | 10% | 0 / 0 | 0 / 0 | 0 / 0 | 10 / 0 | 0 | 798 |
| MEDIO 0,9% | dal 2015 | 10% | 3 / 0 | 18 / 0 | 36 / 0 | 45 / 0 | 0 | 785 |
| MEDIO 0,9% | ult. 4 anni | 10% | 8 / 0 | 38 / 0 | 77 / 0 | 99 / 0 | 0 | 393 |
| ALTO 1,3% | dal 2015 | 10% | 10 / 0 | 30 / 1 | 45 / 6 | 53 / 7 | 37 (6%) | 537 |
| ALTO 1,3% | ult. 4 anni | 10% | 16 / 0 | 64 / 0 | 90 / 0 | 100 / 0 | 0 | 294 |
| PROP 0,5% | dal 2015 | 5% (fase 2) | 4 / 0 | 21 / 0 | 38 / 0 | 48 / 0 | 0 | 704 |
| PROP 0,5% | ult. 4 anni | 5% | 8 / 0 | 42 / 0 | 79 / 0 | 100 / 0 | 0 | 379 |
| MEDIO 0,9% | dal 2015 | 5% | 21 / 0 | 46 / 0 | 59 / 0 | 67 / 0 | 0 | 399 |
| MEDIO 0,9% | ult. 4 anni | 5% | 34 / 0 | 76 / 0 | 98 / 0 | 100 / 0 | 0 | 231 |
| ALTO 1,3% | dal 2015 | 5% | 31 / 0 | 55 / 1 | 61 / 6 | 69 / 7 | 37 (6%) | 270 |
| ALTO 1,3% | ult. 4 anni | 5% | 48 / 0 | 90 / 0 | 100 / 0 | 100 / 0 | 0 | 159 |
**Lettura:** (1) **mai un fallimento per perdita giornaliera del 5%** in nessuna partenza; (2) fallimenti solo con ALTO 1,3% nella finestra lunga (6% delle partenze, perdita totale 10%); (3) **il tempo e il vero problema**: nel periodo lungo (2015-2026) servono mediamente 1,5-2 anni per il 10% a 1,3% e anni a 0,5%, perche l'oro e stato piatto fra 2015 e 2019 con questo EA; negli ultimi 4 anni (oro in forte salita) a 1,3% si passa in circa 10 mesi (mediana 294 giorni) e a 0,9% in 13 mesi. La mediana e solo su chi passa entro la fine dei dati: le percentuali "entro N mesi" sono piu oneste. **Limiti:** costi FTMO (con swap BCM peggio), 76 operazioni in 4 anni, partenze molto sovrapposte (non indipendenti), regole FTMO assunte, il futuro dell'oro non e il passato. Nessun consiglio su taglie.
