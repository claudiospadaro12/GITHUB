# Terzo EA oro D1 (n. 4): drawdown per lotto e portafoglio con GoldenZoe, passo 5 (28/11/2026)
Script `backtest_pipeline/ubs_terzo_ea_dd_portafoglio.py`; dati R4 (n. 4 a 0,1 lotti, deposito 100.000, BCM) e GoldenZoe ricostruito (R per operazione, chiusure, senza costi). Misure, nessun consiglio su taglie. Scalatura lineare dei lotti (verificata sul Dow `g`, non sul n. 4).

## n. 4 a 0,1 lotti
| Periodo | Netto | DD equity max (report) | DD sulle chiusure | Giorno peggiore (chiuso) |
|---|---|---|---|---|
| 2004-09..2012 (1 min) | +4.048 EUR | 749 EUR (0,75%) | 363 | -271 |
| 2025-01..2026-10 (tick) | +455 EUR | 200 EUR (0,20%) | 139 | -111 |

- **DD per lotto instabile fra periodi: 7.492 EUR/lotto (2004-12) contro 2.003 EUR/lotto (2025-26), un fattore 3,7.** I parametri sono in punti fissi, l'oro costava 400-1.800 nel 2004-12 e 2.000+ ora: la stessa taglia in lotti non da' lo stesso rischio nei due periodi. Dimensionare sul periodo peggiore (2004-12) lascia il 2025-26 a circa un quarto del DD.
- Lotti per un DD equity di 2% / 4% / 6% di 80.000: 0,2 / 0,4 / 0,6 (calibrati sul 2004-12) oppure 0,8 / 1,6 / 2,4 (sul 2025-26).
- Il DD sulle chiusure sottostima quello con il flottante: rapporto equity/chiuso 2,1 (2004-12) e 1,4 (2025-26). I numeri del portafoglio qui sotto sono sulle chiusure: vanno letti come minimi.

## Portafoglio GoldenZoe + n. 4 (conto 80.000, DD sulle chiusure)
| Periodo | GoldenZoe | n. 4 (DD eq. solo) | DD GZ | DD n. 4 | **DD insieme** | somma | giorno peggiore | 7 giorni |
|---|---|---|---|---|---|---|---|---|
| 2004-12 | 0,5% | 0,2 lotti (2%) | 2,8% | 1,0% | **1,8%** | 3,7% | -0,72% | -0,94% |
| 2004-12 | 0,5% | 0,4 lotti (4%) | 2,8% | 1,9% | **2,5%** | 4,7% | -1,45% | -1,62% |
| 2004-12 | 0,9% | 0,2 lotti | 5,0% | 1,0% | **3,7%** | 5,9% | -0,90% | -1,70% |
| 2004-12 | 0,9% | 0,4 lotti | 5,0% | 1,9% | **3,4%** | 6,9% | -1,45% | -1,76% |
| 2025-26 | 0,5% | 0,8 lotti (2%) | 1,8% | 1,4% | **2,4%** | 3,2% | -1,11% | -1,11% |
| 2025-26 | 0,5% | 1,6 lotti (4%) | 1,8% | 2,8% | **3,5%** | 4,6% | -2,22% | -2,22% |
| 2025-26 | 0,9% | 0,8 lotti | 3,2% | 1,4% | **3,8%** | 4,6% | -1,11% | -1,11% |
| 2025-26 | 0,9% | 1,6 lotti | 3,2% | 2,8% | **4,6%** | 6,0% | -2,22% | -2,22% |

- Il DD insieme e' sempre inferiore alla somma dei due (diversificazione reale, coerente con r = -0,10 / 0,22), ma nel 2025-26 la riduzione e' minore.
- Il limite prop (4% giornaliero / 8% totale) non e' stato superato in nessuna riga, ma sulle chiusure e senza costi di GoldenZoe; il flottante intragiornaliero non e' misurato.
- Limiti: GoldenZoe ricostruito (senza costi FTMO: il simulatore dei 4 anni dava 2,9% per lo 0,5%, qui 2,8% nel 2004-12 e 1,8% nel 2025-26), n. 4 su due soli periodi, nessuna stima dell'overlap nei giorni di crisi, lotti lineari non verificati.
