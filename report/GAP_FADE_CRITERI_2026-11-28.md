# Gap fade sugli indici USA - CRITERI (scritti prima dei numeri, 28/11/2026)
Origine: ricerca web 27/11 (RTH_Gap_Backtesting, Dax-giant, MIT, nessun risultato dichiarato). Dati: NASUSD/SPXUSD M1 2010-2026 (ora New York, apertura cash 09:30, chiusura 16:00; 2010 incompleto). Il DAX (D30EUR 2019-24, HistData) e rimandato: serve prima la diagnostica dell'orologio.
## Regola
Gap = prezzo 09:30 (apertura barra) - chiusura 15:59 del giorno di borsa precedente. Se |gap| >= soglia g (in % del prezzo): FADE, cioe SHORT se gap su, LONG se gap giu, ingresso all'apertura 09:30. Target = riempimento del gap al 50% o 100%. Stop = k x |gap| oltre l'ingresso (k = 1 o 2). Uscita a tempo alle 12:00 oppure alle 15:55. Se stop e target cadono nella stessa barra M1 vale lo stop. Costo per operazione proporzionale al prezzo (NAS 1,8 pt su 19.000 e SPX 0,6 pt su 6.000, cioe circa 0,01%); stress x2; e anche costo ZERO (richiesta di Claudio: i costi reali del broker dopo).
## Celle
g in {0,2%; 0,4%} x target {50%; 100%} x k {1; 2} x uscita {12:00; 15:55} = 16 celle per indice, 32 in totale. Nessun altro parametro.
## Periodi e cancelli (non abbassati)
IS 2011-2018, OOS 2019-2023, hold-out 2024-26 (solo per le passanti). Candidata se, su ENTRAMBI gli indici e con le stesse regole: IS >= 100 operazioni, PF netto IS >= 1,25 e OOS >= 1,15, >= 60% anni positivi, PF con costo x2 > 1,0. Controllo: stessa cella con direzione CASUALE (20 repliche) e miglior cella del casuale (rischio di falsi positivi su 32 celle): una cella reale e credibile solo se supera il miglior PF IS del casuale.
Previsione scritta: 0 candidate. Il gap fade e una delle anomalie piu note e probabilmente arbitraggiata sugli indici USA dopo il 2010; il 2011-14 potrebbe mostrare un vantaggio debole come il momentum.
