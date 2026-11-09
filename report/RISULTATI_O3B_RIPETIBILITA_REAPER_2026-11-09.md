# O-3b: il Reaper a Randomization 50 si ripete uguale? (09/11/2026)

Criteri e previsioni scritti PRIMA: `CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`, sezione O-3b. Dati: `ANNO_ORO_GRADINI_RND50_20261109_0551.zip` (6 passate), parser in `FOREX_OOS_dati/rnd50_rip.json`. Reaper L0 (`Gold_reaper_propfirm.set`, Randomization 50), 80.000 EUR, Modello 1, nessun input cambiato. Ogni anno: la passata del 06/11 (base) + 2 ripetizioni (R1, R2).

## Validita
6 passate su 6 valide: stato OK, qualita 99% (2013) e 100% (2020, 2025), `nessuno_imposto` come nei test base, 0 stop out.

## Risultati: tre percorsi identici per anno
| Anno | Netto base / R1 / R2 (EUR) | Scarto massimo (sul base) | Aperture | DD equity % | Peggior giorno |
|---|---|---|---|---|---|
| 2013 | 24.148 / **13.071** / 21.780 | **46%** | 631 / 601 / 639 | 6,7 / 7,7 / 7,6 | -4.713 / -5.640 / -5.454 (tutti il 18/12/2013) |
| 2020 | 23.657 / 22.487 / 25.442 | **12,5%** | 570 / 591 / 573 | 5,0 / 4,8 / 5,0 | -1.645 / -2.058 / -1.886 |
| 2025 | 35.635 / 33.593 / 33.744 | **5,7%** | 612 / 599 / 621 | 3,3 / 5,6 / 4,3 | -1.016 / -1.007 / -1.123 |

## Classificazione con la regola scritta
- **RUMORE GRANDE in tutti e 3 gli anni** (scarto oltre il 3%); **oltre il 10% in 2 anni su 3** (2013 e 2020). **Il tester NON e deterministico** con Randomization 50: ogni corsa e un percorso diverso.
- Per la regola scritta: **il confronto 50 contro 60 sul Reaper dell'O-3 e NON conclusivo** (la fascia di rumore e piu grande della differenza trovata).

## Previsioni N1-N5 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| N1 | Corse identiche in 3 anni su 3: 45% | **Falso** |
| N2 | Scarto massimo <= 3% in tutti gli anni: 65% | **Falso** (46%, 12,5%, 5,7%) |
| N3 | Scarto oltre il 10% in almeno un anno: 20% | **Vero** (2013 e 2020) |
| N4 | Le aperture variano fra le corse: 85% | **Vero** (601-639, 570-591, 599-621) |
| N5 | 6 passate valide: 90% | **Vero** |

## Cosa cambia per l'O-3 (Randomization 0/60)
- Reaper: i valori con 0 e 60 (2013: 22.289 / 21.754; 2020: 20.465 / 20.574) stanno **dentro la fascia** delle tre corse a 50 (2013: 13.071-24.148; 2020: 22.487-25.442 per il 2020 sono appena sotto). Non si distinguono dal rumore. Nel **2025** sono sotto la fascia a 50 (29,5k e 30,5k contro 33,6-35,6k): indizio, non prova.
- Phantom: non ripetuto, quindi il rumore del Phantom non e misurato: le differenze (-27%, -30% con 0) potrebbero essere in parte rumore.
- Conclusione prudente: **"lasciare 50 come nei set prop di Wim" resta la scelta di default, ma i numeri dell'O-3 non provano che 0 o 60 siano peggiori.** La Randomization **riduce il numero di operazioni** con 0 (O-3: -20-40%), questo e piu robusto della differenza di netto.

## Conseguenze piu larghe (importanti)
1. **Tutti i nostri risultati di Reaper e Phantom con set prop (Randomization 50) sono un solo percorso casuale**, non una media. Per il Reaper il netto annuo varia di circa il 6-46% fra percorsi (2013 il peggiore). Media dei 3 anni: base 27.800, R1 23.000, R2 27.000: scarto di circa +-10% sul reddito medio.
2. **Le stime delle combo con Reaper o Phantom** (P1 con Phantom Gradino 1, P2/P4 con Reaper Combo, P5 con Phantom Prop) hanno quindi un'incertezza in piu di circa il 5-15% sul profitto medio e di qualche punto sul DD, **oltre** ai limiti gia dichiarati. Il Goldbot (Randomization 0 nei set) non ha questo rumore: la sua stima e deterministica.
3. **Il peggior giorno del Reaper L0 nel 2013** (18/12/2013, un vero giorno di caduta dell'oro, non un artefatto di fine test) vale -4.713 / -5.640 / -5.454 EUR su 80k: in 2 percorsi su 3 il Reaper **da solo a L0** perde oltre il 5% in un giorno. Le combo usano il Reaper a livello L3 (piu basso): non e lo stesso numero, ma conferma che il 2013 e un anno critico e che una sola passata non basta a escludere il -5%.
4. **Per decidere qualcosa che dipende da differenze del 10-15% sul Reaper o Phantom servono 3 o piu passate** per configurazione (mediana e minimo), non una.
5. Ipotesi, NON verificata: con piu conti sugli stessi EA la Randomization rende i percorsi diversi fra conti (meno operazioni identiche): resta da chiedere a FTMO.

## Effetto sul cancello (O-3 e O-3b: fatte)
Reaper e Phantom: "TESTATO CON QUESTI LIMITI: un solo percorso casuale per anno nei test; fascia di rumore del Reaper 6-46% sul netto annuo (2013 il peggiore)". Non si promuove nessuna configurazione sul solo 50/60/0.
