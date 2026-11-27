# Momentum prime/ultime 30 min, controllo 2010-14 - RISULTATI (27/11/2026)
Dati: NASUSD e SPXUSD M1 2010-2014 (zip estratti da Claudio con `RIGA_ESTRAI_INDICI_2010_2014`; il 2010 contiene solo nov-dic). Orologio verificato: picchi a 09:30 / 10:00 / 08:30 ET anche in questi anni (stessa convenzione New York del 2015-26). Regola del paper, V1 (segnale dalla chiusura precedente) e V2 (dalle 09:30), ingresso 15:30, uscita 16:00. Costo proporzionale al prezzo (NAS 1,8 pt e SPX 0,6 pt al livello 2025, scalati): nota di correzione, il costo fisso in punti usato nei test 2015-26 sovrastimava i costi dei primi anni (ma il lordo 2015-26 e' gia' negativo, quindi l'esito non cambia).
| periodo | Nasdaq V1 lordo (PF, t) | netto | S&P V1 lordo | netto |
|---|---|---|---|---|
| 2011-14 | 1,16 (t 1,6) | 1,04 | 1,23 (t 2,0) | 1,10 |
| 2015-20 | 0,99 (t -0,1) | 0,90 | 0,84 (t -1,9) | 0,75 |
| 2021-26 | 0,89 (t -1,3) | 0,81 | 0,87 (t -1,6) | 0,77 |
V2 (senza overnight): 2011-14 Nasdaq 0,99, S&P 1,12 lordo; poi sempre <= 1,05 e netto < 1.
**Lettura:** nel 2011-14 c'e' un lordo debole nella direzione del paper (V1: PF 1,16-1,23, positivo in ciascuno degli anni 2011-14 su S&P, t 1,6-2,0: non significativo a livello conservativo), che nel 2015-26 sparisce e si inverte (t da -0,1 a -1,9). Netto di costi 2011-14 PF 1,04-1,10: nessun vantaggio utilizzabile e comunque fuori dal periodo in cui si opererebbe. Conclusione: l'effetto del paper e' decaduto (o era troppo debole per i CFD); non si recupera con parametri o filtri. **Momentum intraday chiuso.**
