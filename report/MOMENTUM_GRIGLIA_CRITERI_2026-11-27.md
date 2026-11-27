# Momentum intraday: GRIGLIA COMPLETA - criteri (scritti prima, 27/11/2026)
Dati e orologio come `MOMENTUM_30MIN_CRITERI` (NASUSD/SPXUSD M1 2015-26, ora New York, cash 09:30-16:00). Prezzo a un orario t = apertura della barra t; prezzo di chiusura precedente = chiusura barra 15:59 del giorno prima. Costi come prima (NAS 1,8, SPX 0,6; x2 come stress).
## Griglia
- Riferimento del segnale: chiusura precedente (incl. overnight) oppure apertura 09:30. Fine segnale S in {10:00, 10:30, 11:00, 12:00, 13:00, 14:00, 15:00}. Segnale = segno di prezzo(S) - riferimento.
- Ingresso E in {S, 12:00, 13:00, 14:00, 15:00, 15:30} con E >= S (E=S: ingresso subito). Uscita X in {E+30, E+60 min, 16:00} con X <= 16:00 (barra 16:00).
- Direzione: continuazione (+1) e inversione (-1), entrambe. Stesse regole su Nasdaq e S&P. Totale celle: stampato dallo script.
## Cancelli (non abbassati dopo aver visto)
Cella candidata solo se, su ENTRAMBI gli indici e con la stessa direzione: IS 2015-20 >= 200 operazioni e PF netto >= 1,30; OOS 2021-24 PF netto >= 1,20; con costo x2 PF OOS > 1,0; >= 60% anni positivi. Hold-out 2025-26 aperto solo per le passanti.
## Controllo del "miglior della griglia" (molti test = falsi positivi)
Si ripete l'intera griglia con segnale casuale (20 repliche, seed 20261127): se il miglior PF IS/OOS reale non supera il miglior PF tipico del casuale, nessuna cella e' credibile anche se passa i cancelli. Previsione scritta: 0 candidate; il migliore reale vicino al migliore casuale.
