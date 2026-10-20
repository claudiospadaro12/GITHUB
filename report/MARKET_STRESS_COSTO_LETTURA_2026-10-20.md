# Stress del costo (parte 1: analitico sui report esistenti) -- 20/10/2026

**Non controllata da agenti.** Soglia scritta prima (`MARKET_PERCORSO_ACQUISTO_2026-10-19.md`, fase A4): con **costo per operazione doppio** il netto deve restare > 0 e il PF > 1,10. Previsioni scritte prima: Prop Firm passa con ampio margine; Smart Gold Hunter passa "ma con PF sotto 1,3". Strumento `backtest_pipeline/stress_costo_analitico.py` (nuovo, sola lettura): da ogni operazione chiusa toglie un costo extra = K x 0,18 EUR per 0,01 lotto (0,18 = stima dello spread, scritta prima); K=1 e' il costo doppio.

| EA (corsa continua) | op. | netto base | K=1 (doppio) | K=2 (triplo) | K=4 (quintuplo) | K di pareggio |
|---|---|---|---|---|---|---|
| Prop Firm, 5.000 | 673 | 1.591 / PF 1,26 | **1.470 / 1,24** | 1.349 / 1,22 | 1.106 / 1,17 | 13,1 |
| Prop Firm, 80.000 | 673 | 34.130 / 1,25 | **31.254 / 1,22** | 28.378 / 1,20 | 22.627 / 1,16 | 11,9 |
| Smart Gold Hunter | 237 | 276 / 1,75 | **233 / 1,60** | 190 / 1,46 | 105 / 1,23 | 6,5 |
| Gold Reaper (set di Claudio) | 791 | 3.970 / 2,89 | 3.816 / 2,79 | 3.663 / 2,68 | 3.356 / 2,47 | 25,9 |
| Quantum Titan | 462 | 10.987 / 2,21 | 9.210 / 1,97 | 7.433 / 1,75 | 3.880 / 1,35 | 6,2 |
| Ghost Scalper | 2.651 | 1.215 / 1,47 | 738 / 1,26 | 261 / 1,08 | -694 / 0,81 | 2,5 |

## Verdetto alla soglia (costo doppio: netto > 0 e PF > 1,10)
**Prop Firm: PASSA** (5.000 e 80.000). **Smart Gold Hunter: PASSA** (PF 1,60). Gold Reaper, Quantum Titan e Ghost Scalper passano anche loro (Ghost con PF 1,26 e margine sottile: a costo triplo scende a 1,08, sotto soglia).
## Previsioni
Prop Firm "passa con ampio margine": **confermata** (resta positivo fino a 12-13 volte lo spread extra). Smart Gold Hunter "passa ma con PF sotto 1,3": **SBAGLIATA** (PF 1,60 al costo doppio, 1,23 solo al costo quintuplo).
## Cosa NON dice
Aggiunge un costo FISSO per operazione: non cambia quando le operazioni si aprono/chiudono, non simula slippage che cresce con la volatilita', ne' requote, ne' spread che si allarga in news. Il 0,18 e' una stima (20 punti) non riletta sul conto reale BCM. Gli EA a posizioni lunghe (Prop Firm, tenuta media 8 ore) sono poco sensibili a una latenza di poche centinaia di millisecondi; gli EA con ordini pendenti e trailing stretto (Smart Gold Hunter: TP 250, SL 500, trailing 100/50 punti) lo sono di piu': per questo c'e' una parte 2 nel tester con esecuzione ritardata.
