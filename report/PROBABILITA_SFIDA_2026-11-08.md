# Probabilita di non superare la challenge (stima, 08/11/2026)

**Metodo** (`ORO_GRADINI_dati/sfida_finestre.py`): ogni giorno di trading degli anni 2013, 2020 e 2025 e una possibile data di partenza; si segue il P&L giornaliero **realizzato** delle combo P1, P3, P4 e P5 a 80k (con commissioni/slippage in 3 scenari) fino a +10% (fase 1) e poi +5% (fase 2, nuovo conto), con le regole FTMO: perdita giornaliera 5%, perdita totale 10%, orizzonte di 90 o 180 giorni. Circa 650-690 finestre per combo; sono **sovrapposte** (non indipendenti) e vengono da 3 soli anni.

## Risultati
| Combo | Fasi 1+2 entro 180 gg (costi centrali) | Fasi 1+2 entro 90 gg (costi centrali) | Fallimenti per regola (giorno -5% o totale -10%) |
|---|---|---|---|
| P1 | **70%** | 41% | **0 su 687 finestre** |
| P3 | 56% | 25% | 0 su 647 |
| P4 | 54% | 23% | 0 su 684 |
| P5 | 47% | 18% | 0 su 688 |
Scenario prudente a 180 giorni: P1 65%, P3 48%, P4 47%, P5 42%. Senza costi (tester): P1 73%, P3 59%, P4 60%, P5 53%.

## Come leggerlo
- **Nei dati non ci sono bocciature per le regole**: nessuna finestra ha toccato -5% in un giorno o -10% in totale **a livello realizzato**. Il resto delle finestre e "non finita nel tempo", non fallita. FTMO non indica una durata massima nelle pagine lette (**NON VERIFICATO**): se non c'e un limite di tempo, "non finita" significa solo attendere.
- **Il tempo e il problema principale**: con P1 serve spesso oltre 90 giorni per la sola fase 1+2; con P3-P5 piu spesso oltre 180.
- **Limiti seri**: (1) solo 3 anni; (2) solo P&L **realizzato**: l'equity con posizioni aperte ha toccato 8,2% (P1) e 7,5-7,4% (P3, P4) di DD nel 2013, vicino al 10%; per il 2020 l'equity non e ricostruibile; (3) nel tester niente slippage reale, news, ritardi; (4) un regime peggiore del 2013 (oro -27%) non e nei dati.
- **Stima soggettiva, NON calcolata**: la probabilita di **non** passare una fase per violazione di regola la metterei tra il **10% e il 25%**, piu alta sul P1 (DD piu vicino al limite) che su P5. E un giudizio mio sui limiti sopra, non un risultato.
- Una challenge persa costa la quota (circa 500-1000 EUR per conto, stima tua) e non tocca le altre.
