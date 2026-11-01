# Tick reali 2025 per Reaper, Goldbot One e Phantom: risultati (01/11/2026)
Zip `ANNO80K_TICK_2025_20261031_2143`. Criteri e previsioni scritti prima: `TICK_2025_TRE_EA_CRITERI_2026-10-31.md`. Tre corse sul 2025 (01/01/2025-01/01/2026), XAUUSD, **Modello 4 (tick reali, qualita 100%)**, 80.000 EUR, stessi input dei test a candele (Modello 1). Stato OK, `input_ok = si`, stop out 0, "no money" 0 in tutte e tre. Non controllata da agenti.

| | Reaper D9 | Goldbot PF525 | Phantom D4 |
|---|---|---|---|
| Netto M4 (tick) / M1 (candele) | **+27.985** / +30.457 (-8,1%) | **+8.444** / +8.999 (-6,2%) | **+5.409** / +5.560 (-2,7%) |
| DD equity M4 / M1 | 3.104 / 3.077 (+0,9%) | 1.611 / 1.637 (-1,6%) | 794 / 804 (-1,2%) |
| Netto/DD M4 / M1 | 9,02 / 9,90 (-8,9%) | 5,24 / 5,50 (-4,7%) | 6,81 / 6,91 (-1,5%) |
| Profit factor M4 / M1 | 2,60 / 2,77 | 2,13 / 2,25 | 2,93 / 3,11 |
| Operazioni M4 / M1 | 499 / 497 | 236 / 237 | 713 / 707 |
| Peggior giorno realizzato (M4) | -882 (-1,10%, 20/01) | -891 (-1,11%, 01/12) | -193 (-0,24%, 13/10) |
| Netto da long / short (M4) | 22.184 / 5.936 | 8.199 / 285 | 4.562 / 867 |

## Previsioni
- **T1** valide 3/3: **SI**.
- **T2** netto a tick reali minore di quello a candele: **SI** 3/3.
- **T3** DD a tick reali >= quello a candele: Reaper **SI** (+0,9%), Goldbot **NO** (-1,6%), Phantom **NO** (-1,2%): il DD resta uguale, entro il 2%.
- **T4** netto/DD almeno 10% piu basso a tick reali: **NO** per tutti (-8,9%, -4,7%, -1,5%): la previsione era troppo pessimista; il Reaper e vicino (-8,9%).
- **T5** tutti e tre positivi: **SI**.
- **T6** nessun giorno >= 4.000: **SI** 3/3 (peggior giorno 1,1%).
- **T7** operazioni entro +-10%: **SI** 3/3.

## Lettura
- I test a candele (Modello 1) sovrastimano il netto 2025 di **3-8%**, e lasciano il DD praticamente uguale: l effetto e piccolo per questi tre EA su H1/D1 (per il Reaper e il piu grande, -8%). Non e il -17% dell utente MQL5 (che parlava di un portafoglio ORB su M15).
- **Nel 2025 il netto e quasi tutto da long** (Reaper 79%, Goldbot 97%, Phantom 84%): anno di rialzo forte dell oro. Non e un anno neutro (nel 2005-2012 il profitto era diviso tra long e short).

## Cosa NON dice
Solo il 2025 (unico anno intero con tick reali; non esistono tick reali prima di 10/07/2024), un percorso, lotti a inizio anno, tester senza slippage e gap, margine del tester fisso. Il confronto riguarda l effetto tick contro candele su questo anno, non il 2013-2023. Nessun giudizio su acquisti, lotti o taglie.
