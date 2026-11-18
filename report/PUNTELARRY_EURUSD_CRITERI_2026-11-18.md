# PunteLarry su EURUSD (secondo mercato) — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Natura: solo tester (BCM portabile, Modello 1, EURUSD nativo), DEFAULT dell'EA (nessun adattamento all'EURUSD), H1, rischio 1%, una passata per finestra. Seguito di `PUNTELARRY_ORO_2024_26_CRITERI_2026-11-18.md` (oro: PF 1,43 / 1,66 / 1,28 su tre finestre, t < 1,3 ciascuna). Scopo: vedere se il motore regge su un mercato diverso dall'oro. **Limite dichiarato:** le soglie dei default (filtro dimensione, stop) sono nate sull'oro; un fallimento puo dipendere dal pip-size, non dal pattern.
## Finestre (3 obbligatorie + 1 bonus)
W2018_2020, W2021_2023, W2024_2026 (le prime due e l'ultima hanno storico BCM gia usato per Luna/EURUSD). Bonus W2010_2017: conta solo se i dati ci sono (se < 8 operazioni per mancanza di storico, si ignora).
## Porte (nessuna ritoccabile)
- **Finestra CONFERMATA:** PF sui rendimenti per operazione >= 1,20, rendimento > 0, >= 8 operazioni. NON VALUTABILE: < 8 operazioni o errore.
- **SECONDO MERCATO CONFERMATO:** >= 2 delle 3 finestre obbligatorie confermate **e** nessuna finestra con rendimento < -5%.
- **NON CONFERMATO:** tutto il resto. Si riportano operazioni, t, DD, rendimento per anno. Anche CONFERMATO resta un indizio (t basso): non promuove da solo.
## Previsioni
- SECONDO MERCATO CONFERMATO: **20%**. NON CONFERMATO: **70%**. NON VALUTABILE (poche operazioni su forex): **10%**.
- Numero di operazioni per finestra triennale: 15-40 (70%).

## Risultato (18/11/2026; 4 passate OK; `PUNTELARRY_EURUSD_dati/`)
| Finestra | Op. | Rend. | PF | t | DD | Anni (rend. %) |
|---|---|---|---|---|---|---|
| 2018-20 (obbl.) | 88 | +1,81% | 1,08 | 0,28 | 8,6% | 2,35 / 3,15 / -3,45 |
| 2021-23 (obbl.) | 90 | **-8,68%** | 0,74 | -1,22 | 10,8% | 0,39 / -2,82 / -6,39 |
| 2024-26 (obbl.) | 95 | -1,64% | 0,96 | -0,15 | 7,9% | -4,53 / 4,22 / -0,98 |
| 2010-17 (bonus) | 292 | +35,96% | 1,34 | 1,97 | 9,4% | 7 anni positivi su 8 |

**Verdetto scritto prima: NON CONFERMATO.** 0 finestre obbligatorie su 3 passano (PF 1,08 / 0,74 / 0,96, tutte < 1,20) e il 2021-23 e sotto -5%. Previsioni: NON CONFERMATO (70%) -> si; operazioni per finestra 15-40 (70%) -> **sbagliata** (88-95: l'EURUSD genera molti piu setup dell'oro).
**Lettura onesta:** nelle tre finestre 2018-26 (273 op.) il rendimento sommato e -8,5%: nessun vantaggio. Il bonus 2010-17 e forte (PF 1,34, t 1,97, 7 anni su 8) ma e storia vecchia e non e la finestra su cui si decideva; mostra solo che il motore ha funzionato su EURUSD in quel regime e poi e sparito. Non si usa per promuovere. **PunteLarry resta un indizio solo sull'oro** (tre finestre PF > 1,2, p ~ 0,06), non generalizza a EURUSD.
