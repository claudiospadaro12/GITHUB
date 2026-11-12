# UBS U3 tappa 1: DD a lotto fisso 0,1 su due periodi — RISULTATI (12/11/2026)

**Natura: MISURA dal tester** (BCM, Modello 1, XAUUSD, deposito 100.000 EUR, qualita 98%, set cosi come consegnati: `Risk=0`, `StartLots=0.1`, nessun input imposto; confermato in tutti i report). Criteri: `UBS_U3_CRITERI_2026-11-12.md`. Script `D160_dati/analisi_ubs_u3m.py`, dati `D160_dati/ubsu3m.json`. Solo tester.

Validita: 18/18 passate valide (report presente, deposito 100.000, qualita 98%, nessuno stop out / no money, tutti gli input uguali al set, lotto 0,1).

## DD01 = DD equity / 10 (a 0,01 lotti, EUR)
| Set | Dich. | P1 2013-18 | P2 2019-25 | Intero 2013-25 (U1b) | max/min fra P1 e P2 |
|---|---|---|---|---|---|
| Phantom strat8 | 720 | 199,43 | 161,23 | 199,43 | 1,24 |
| Phantom strat3 | 99 | 51,94 | 51,17 | 51,94 | 1,02 |
| Goldbot dailyC | 27 | 16,73 | **5,44** | 16,73 | **3,08** |
| Gold Trade Pro E | 40 | 33,12 | 41,30 | 41,30 | 1,25 |
| Phantom Gold_c | 50 | 51,94 | 51,17 | 51,94 | 1,02 |
| Goldbot dailyI | 83 | 87,15 | 69,80 | 87,15 | 1,25 |
| Gold Trade Pro a | 60 | 96,98 | 118,61 | 131,51 | 1,22 |
| Reaper s5 H1 | 110 | 150,28 | 81,02 | 150,28 | **1,85** |
| Reaper s1 D1 | 60 | 232,07 | 205,62 | 239,72 | 1,13 |
Il DD dell'intero periodo coincide con quello di un solo sottoperiodo in 6 set su 9; in 2 (Gold Trade Pro a, Reaper s1 D1) lo supera perche la perdita attraversa il 2019; Gold Trade Pro E coincide con P2.

## Previsioni della tappa 1
- **U3-1** (>= 16/18 valide): confermata, 18/18.
- **U3-2** (DD01 diverso di oltre 1,5 volte in >= 5 set su 9; 70%): **FALSA**, solo 2 set (Goldbot dailyC 3,08; Reaper s5 1,85).

## Lettura
Il DD a lotto fisso e stabile fra i due periodi in 7 set su 9 (entro 1,25 volte). Le due eccezioni sono i set dove una prova fuori periodo puo sbagliare: Goldbot dailyC (misurato su P2, DD01 5,44 contro 16,73 di P1: il lotto sarebbe 3 volte troppo grande se provato su P1) e Reaper s5 (misurato su P2 contro prova su P1: 1,85 volte). Tappa 2: `HistoricalMaxDD` = DD01 x 1,15 (dollari).
