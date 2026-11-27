# Momentum 30 min con FILTRI DI CONTESTO - criteri (scritti prima, 27/11/2026)
Base: regola del paper (V1 = segno di prezzo 10:00 - chiusura precedente; V2 = segno di prezzo 10:00 - apertura 09:30), entrata 15:30, uscita 16:00, continuazione. Dati NASUSD/SPXUSD M1 2015-26 (ora New York). Costi: stimati (NAS 1,8 / SPX 0,6) E costo zero (richiesta di Claudio, costi reali del broker dopo).
## Filtri (3, fissati ora, soglie non modificabili dopo)
- F1 mossa grande: |segnale| >= mediana dei |segnali| dei 60 giorni precedenti.
- F2 volatilita alta: range 09:30-15:30 del giorno prima... definito come |prezzo 15:30 - prezzo 09:30| medio non usato; usare: range giornaliero precedente (alto-basso 09:30-16:00 approssimato dai prezzi 09:30 e 16:00 e 15:30 non disponibile) -> semplificazione: |apertura 16:00 ieri - apertura 09:30 ieri| >= mediana dei 60 giorni precedenti.
- F4 trend: segno del segnale = segno di (chiusura di ieri - media delle chiusure dei 50 giorni precedenti).
Celle: 3 filtri x 2 varianti (V1, V2) x 2 indici = 12 (+ le 6 senza filtro gia' misurate). Stessi cancelli: IS 2015-20 >= 150 operazioni (il filtro riduce i casi) e PF netto >= 1,30; OOS 2021-24 >= 1,20; entrambi gli indici stessa direzione; >= 60% anni positivi; poi hold-out 2025-26 solo per le passanti. Controllo: stesso filtro con direzione casuale (20 repliche) e confronto col lordo costo zero.
Previsione scritta: 0 candidate (il lordo senza filtro e' negativo e i filtri scelti non possono creare un segnale dove non c'e').
