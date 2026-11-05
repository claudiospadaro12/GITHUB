# Confronto dei candidati forex a 4k con il trio oro (05/11/2026)

Trio = Reaper D9 + Goldbot PF525 + Phantom D4, i set del conto reale (3.745 EUR, lotti al minimo 0,01, tick reali, 21 mesi 01/2025-10/2026). Candidati = le passate a 4.000 EUR di `RISULTATI_FOREX_4K_2026-11-05.md`. Serie = profitto realizzato per giorno di calendario, giorni senza operazioni a zero. Dati e script: `FOREX_4K_dati/trio_corr.py`, `dtp_gold.py`.

**Perimetro.** Il trio a scala reale c'e' solo per il 2025, quindi il confronto a scala vera (somma in euro) vale solo per il 2025. Per 2013 e 2020 uso il trio a 80.000 (lotti piu' grandi): vale solo per la correlazione, non per gli importi. 2017 e 2022 non hanno il trio: non confrontabili.

## 1. Correlazione giornaliera col trio

| Candidato | corr 2013 (trio 80k) | corr 2020 (trio 80k) | corr 2025 (trio 80k) | corr 2025 (trio reale 3.745) |
|---|---|---|---|---|
| Apex Conservative | +0.08 | +0.04 | +0.00 | -0.01 |
| Apex UltraConservative | +0.08 | +0.04 | +0.02 | +0.01 |
| Daytrade Pro Max9 | +0.19 | +0.15 | +0.15 | +0.17 |
| Daytrade Pro Max20 | +0.14 | +0.12 | +0.09 | +0.11 |
| Daytrade Pro Max50 | +0.16 | +0.15 | +0.09 | +0.11 |
| Luna 4DD | -0.01 | -0.03 | -0.02 | -0.02 |
| Stability low risk | +0.03 | -0.06 | +0.07 | +0.02 |
| Stability medium-low | +0.01 | -0.05 | +0.08 | +0.03 |
| Apex Elevated (grigia) | +0.08 | +0.02 | -0.03 | -0.04 |
| Luna lowrisk (grigia) | -0.00 | -0.04 | -0.00 | -0.00 |

## 2. Giorni di perdita in comune (anni 2013 / 2020 / 2025, osservati contro attesi se indipendenti)

| Candidato | 2013 | 2020 | 2025 |
|---|---|---|---|
| Apex Conservative | 2 su 3 | 7 su 6 | 11 su 8 |
| Apex UltraConservative | 5 su 6 | 9 su 8 | 15 su 10 |
| Daytrade Pro Max9 | 31 su 14 | 26 su 16 | 26 su 16 |
| Daytrade Pro Max20 | 31 su 14 | 25 su 16 | 25 su 16 |
| Daytrade Pro Max50 | 31 su 14 | 24 su 16 | 25 su 15 |
| Luna 4DD | 15 su 11 | 5 su 6 | 7 su 4 |
| Stability low risk | 5 su 6 | 3 su 7 | 12 su 8 |
| Stability medium-low | 5 su 6 | 3 su 7 | 12 su 8 |
| Apex Elevated (grigia) | 2 su 3 | 7 su 5 | 10 su 8 |
| Luna lowrisk (grigia) | 15 su 11 | 5 su 6 | 7 su 4 |

## 3. 2025 a scala reale: trio + candidato sommati (solo realizzato)

Trio da solo 2025: netto +4.240, peggior giorno −160 (01/12/2025), DD sul saldo realizzato 308.

| Candidato | netto candidato | peggior giorno candidato | DD saldo candidato | DD saldo trio + candidato | peggior giorno trio + candidato |
|---|---|---|---|---|---|
| Apex Conservative | +913 | -9 | 9 | 259 | -159 (2025.12.01) |
| Apex UltraConservative | +1,037 | -20 | 22 | 256 | -158 (2025.12.01) |
| Daytrade Pro Max9 | +131 | -87 | 215 | 313 | -159 (2025.12.01) |
| Daytrade Pro Max20 | +134 | -153 | 336 | 332 | -159 (2025.12.01) |
| Daytrade Pro Max50 | +120 | -385 | 937 | 665 | -362 (2025.04.04) |
| Luna 4DD | +1,130 | -49 | 74 | 278 | -158 (2025.12.01) |
| Stability low risk | +562 | -11 | 11 | 285 | -159 (2025.12.01) |
| Stability medium-low | +1,305 | -33 | 33 | 264 | -157 (2025.12.01) |
| Apex Elevated (grigia) | +1,651 | -2 | 2 | 252 | -159 (2025.12.01) |
| Luna lowrisk (grigia) | +3,476 | -127 | 161 | 231 | -154 (2025.12.01) |

## 4. Perche' Daytrade Pro e' l'unico con correlazione 0,09-0,19

Daytrade Pro opera 13 simboli e tra questi c'e' XAUUSD. Separando la gamba oro:

| Set | anno | corr senza oro | corr della sola gamba oro | operazioni oro | netto oro / netto totale |
|---|---|---|---|---|---|
| Max9 | 2013 | +0,05 | +0,64 | 55 | 149 / 463 |
| Max9 | 2020 | 0,00 | +0,48 | 62 | 15 / 1.013 |
| Max9 | 2025 | −0,01 | +0,57 | 48 | 153 / 131 |
| Max20 | 2025 | 0,00 | +0,57 | 48 | 153 / 134 |
| Max50 | 2013 | +0,03 | +0,66 | 55 | 655 / 2.706 |
| Max50 | 2025 | −0,01 | +0,56 | 48 | 418 / 120 |

Nel 2025 tutto l'utile di Daytrade Pro viene dall'oro: senza oro Max9 chiude a circa −22 e Max50 a circa −298. Quella gamba e' la stessa esposizione del trio.

## 5. Letture
- Le correlazioni sono tutte vicine a zero (|r| ≤ 0,19): Apex, Luna e Stability non si muovono col trio. Daytrade Pro lo segue solo per la gamba oro.
- Giorni di perdita in comune: nella norma per Apex e Stability; **piu' del doppio dell'atteso per Daytrade Pro** nel 2013 (31 su 14) e nel 2025 (26 su 16), per via dell'oro. Luna leggermente sopra (7 su 4 nel 2025, numeri piccoli).
- Nel 2025 a scala reale il peggior giorno combinato resta quello del trio (−160 il 01/12/2025): nessun candidato lo peggiora tranne Daytrade Pro Max50 (−362 il 04/04/2025, giorno peggiore suo di −385). Il DD realizzato combinato scende rispetto al trio solo con Apex, Luna, Stability (per lo scalare dei guadagni); con Daytrade Pro e' uguale o peggiore.
- **Apex Conservative/Ultra**: il pericolo non e' il trio ma il giorno di chiusura della griglia (fino a −988 EUR nel 2013, circa 6 volte il peggior giorno del trio). Nei giorni peggiori di Apex il trio era a −0,6…−1,0 deviazioni standard nel 2013, cioe' non c'e' una coincidenza estrema.

## Limiti
- Solo realizzato: il flottante delle griglie (Apex) e di Daytrade Pro non e' contato; il giorno nero vero con le posizioni aperte puo' essere peggiore.
- Somma di corse indipendenti: non simula margine, lotti sul saldo comune, Guardian ne' stop out. Con 4.000 e lotti al minimo e' una buona stima per il trio, meno per i set che scalano col saldo.
- Un solo anno a scala reale (2025, in cui l'oro e' salito molto); 2013/2020 con il trio a 80.000. Nessuna previsione sul prossimo anno.
