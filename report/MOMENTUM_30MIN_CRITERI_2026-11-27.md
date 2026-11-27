# Momentum "prime 30 min predicono ultime 30 min" - CRITERI (scritti prima del test, 27/11/2026)
Fonte: Gao-Han-Li-Zhou (paper SPY 1993-2013, Sharpe 1,08, netto costi 4,5% annuo; dichiarato dall'autore). Dati: `NASUSD_M1_2015..2026` e `SPXUSD_M1_2015..2026` (M1, sul server; orologio MISURATO 27/11: picco di apertura a 09:30 e dati macro 08:30/10:00 in tutti gli anni 2015-26 => timestamp = ora di New York con ora legale, sessione cash 09:30-16:00; il 2010-14 non e' sul server).
## Regole (fissate ora)
- Segnale V1: segno di (chiusura barra 09:59 - chiusura barra 16:00 del giorno di borsa precedente) [paper: primo mezz'ora incl. overnight]. V2: segno di (chiusura 09:59 - apertura 09:30). V3: V1 e rendimento 15:00->15:30 dello stesso segno, altrimenti nessun trade.
- Ingresso all'apertura della barra 15:30, uscita all'apertura della barra 16:00 (nessuna notte, nessuno swap). Nessuno stop (esposizione 30 min); lotto fisso 1 unita-indice.
- Saltare i giorni senza barre 09:59, 15:30, 16:00 o 15:00 (mezze sessioni).
- Costo per operazione (round trip): NASUSD 1,8 punti, SPXUSD 0,6 punti (spread 0 nei CSV); sensibilita x0,5 e x2.
## Celle e cancelli
6 celle (2 indici x V1/V2/V3). Periodi: IS 2015-2020, OOS 2021-2024, hold-out 2025-26 (aperto UNA volta, solo per celle che passano IS e OOS).
Candidata se: IS >= 200 operazioni, PF netto IS >= 1,30 e OOS >= 1,20; hold-out PF > 1,0; >= 60% anni positivi; PF netto con costo x2 > 1,0; concordanza di segno dei due indici; PF del controllo "direzione casuale" (seed fisso, 20 repliche) entro 0,9-1,1 (verifica che l'effetto sia nel segnale e non nel drift) e superiore al "sempre long" nello stesso periodo/finestra. Soglie non abbassate dopo aver visto i risultati.
Previsione scritta: il paper riguarda un periodo precedente (1993-2013) e SPY; atteso PF netto 1,0-1,1 su CFD con costi, 0 candidate.
