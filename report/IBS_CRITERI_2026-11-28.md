# IBS (Internal Bar Strength) giornaliero sugli indici USA - CRITERI (scritti prima dei numeri, 28/11/2026)
Origine: ricerca web 27/11 (Monday Dip EA mql5/code/78343; script TradingView Botnet101 0,2/0,8 e Trading_Alpha01 uscita a 3 barre; CazSyd soglie 0,13/0,5 su ETF). IBS = (chiusura - minimo)/(massimo - minimo) della barra D1.
Dati: barre D1 della sessione cash (09:30-16:00 New York) costruite dagli M1 NASUSD e SPXUSD 2010-2026; chiusura = chiusura barra 15:59. Solo long (mean reversion), ingresso alla chiusura del giorno del segnale, una posizione alla volta.
## Celle
Soglia ingresso IBS <= e con e in {0,13; 0,2; 0,3} x filtro {nessuno; chiusura > SMA(200) giornaliera} x uscita {alla chiusura quando IBS >= 0,5; IBS >= 0,8; dopo 1 giorno; dopo 3 giorni} = 24 celle per indice, 48 in totale.
Costi: round trip 0,01% (NAS 1,8 pt su 19.000, SPX 0,6 su 6.000) + finanziamento long 7,5% annuo per i giorni di calendario in posizione (BCM misurato 10-14%, FTMO 5-10%); stress = costo x2 e 14% annuo. Sono costi prudenti: contano perche si tiene la posizione di notte.
## Periodi e cancelli (non abbassati)
IS 2011-2018, OOS 2019-2023, hold-out 2024-26 (solo per le passanti). Candidata se, su ENTRAMBI gli indici: >= 100 operazioni IS, PF netto IS >= 1,25 e OOS >= 1,15, >= 60% anni positivi, PF con stress > 1,0.
CONTROLLO DEL DRIFT (gli indici sono saliti nel periodo): stessa cella con giorni di ingresso CASUALI (stessa frequenza, 20 repliche, stessa regola di uscita). Una cella reale e credibile solo se il suo PF IS supera il massimo del miglior PF IS casuale su tutta la griglia.
Previsione scritta: 0 candidate (famiglie A-D e RSI(2) del 21/11 hanno dato PF 1,17-1,18 sugli indici, sotto i cancelli; la buona parte e drift).
