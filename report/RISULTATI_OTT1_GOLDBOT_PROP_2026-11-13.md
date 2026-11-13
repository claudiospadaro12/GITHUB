# OTT1 tappa 1: Goldbot One Prop, contributo delle strategie A-H — RISULTATI COMPLETI (13/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD D1, 80.000 EUR, qualita 98%, set `Goldbot_PropFirm_5_2.5.set`, `Randomization=0`). Criteri e previsioni scritti prima: `OTT1_GOLDBOT_PROP_CRITERI_2026-11-13.md`. 18/18 passate valide: 16 dalla corsa del 13/11 (sera) piu le 2 ripetute (BASE e senza G, 2019-2025; le prime due erano KO con report vuoto, rieseguite OK con `OTT1R`). Dati `D160_dati/ott1_completo.json`, script `analisi_ott1.py`. Solo tester.

## Tabella (contributo = netto della BASE meno netto "senza X"; %netto = variazione togliendo X)
| Tolta | P1 2013-18: netto | %netto | DD% | PF | P2 2019-25: netto | %netto | DD% | PF |
|---|---|---|---|---|---|---|---|---|
| BASE | 52.706 | - | 10,68 | 1,53 | 85.361 | - | 7,70 | 1,86 |
| A | 46.998 | -10,8% | 9,62 | 1,54 | 74.462 | -12,8% | 7,80 | 1,87 |
| B | 47.208 | -10,4% | 8,65 | 1,52 | 70.564 | -17,3% | 7,04 | 1,81 |
| C | 49.912 | **-5,3%** | 10,31 | 1,53 | 76.473 | **-10,4%** | 6,77 | 1,82 |
| D | 42.360 | -19,6% | 8,09 | 1,50 | 60.902 | **-28,7%** | 6,76 | 1,73 |
| E | 31.511 | **-40,2%** | 6,43 | 1,50 | 65.528 | -23,2% | 5,15 | 2,02 |
| F | 46.888 | -11,0% | 9,70 | 1,57 | 74.951 | -12,2% | 5,88 | 1,92 |
| G | 46.622 | -11,5% | 9,69 | 1,55 | 75.429 | -11,6% | 6,80 | 1,90 |
| H | 46.873 | -11,1% | 9,17 | 1,57 | 69.998 | -18,0% | 7,14 | 1,86 |

## Verdetto (regole fissate prima)
- **Candidate da togliere** (netto sale in entrambi i periodi e DD% non sale di piu di 0,5 punti): **nessuna**. Togliere una strategia abbassa SEMPRE il netto, in entrambi i periodi (8 su 8, stesso segno).
- **Inutili** (netto cala meno del 3% in entrambi): **nessuna**. La piu debole e la C (-5,3% e -10,4%).
- **Conclusione: il Goldbot Prop non si migliora togliendo strategie: lasciarlo com'e.**
- Rapporto netto/DD (informazione fuori dai criteri): nessuna prova "senza X" lo migliora in entrambi i periodi (B, D, H lo migliorano nel 2013-18 e lo peggiorano nel 2019-25; E e F il contrario).
- Contributi piu grandi: E e D (E: -40% nel 2013-18, D: -29% nel 2019-25). Ordine P1: E, D, G, H, F, A, B, C; P2: D, E, H, B, A, F, G, C.

## Previsioni
| | Previsione | Esito |
|---|---|---|
| OTT1-1 | >= 16 passate valide su 18 (90%) | **confermata** (18/18 dopo la ripetizione) |
| OTT1-2 | BASE in profitto in entrambi i periodi con PF > 1,2 (85%) | **confermata** (PF 1,53 e 1,86) |
| OTT1-3 | >= 1 strategia con contributo negativo in P1 (60%); la stessa in entrambi (25%) | **false** (0 su 8) |
| OTT1-4 | segno uguale in P1 e P2 in >= 6 strategie su 8 (55%) | **confermata** (8 su 8) |
| OTT1-5 | >= 1 strategia "inutile" (50%) | **falsa** |
| OTT1-6 | la strategia piu grande in P1 e fra le prime 3 in P2 (60%) | **confermata** (E: 1a in P1, 2a in P2) |

## Limiti
Un percorso per prova (set deterministico); le strategie interagiscono (il leave-one-out non e la somma); due periodi; costi BCM, non FTMO; Modello 1; nessun parametro interno da toccare (non esistono input). Le leve rimaste per un'ottimizzazione sono: Buy/Sell, `FakeOutFilter`, `FridayStopHour`, finestre NFP, rischio.
