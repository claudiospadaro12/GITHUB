# R82 - IL CANARINO (USDJPY): PRIMO ELIMINATO, E UN VERDETTO CHE PESA OLTRE IL TORNEO

_18/08/2026 17:30, giro 1 screening OHLC-M1, finestra 2007.02.12->, deposito
10k, rischio 1% per operazione (cella di screening). CSV in r82_csv/._

| finestra | profit | PF | DD% | trades |
|---|---:|---:|---:|---:|
| IS 2007-2014 | -6.642,79 | 0,783 | 70,1 | 927 |
| OOS 2014-2026 | -7.765,11 | 0,884 | 81,0 | 2.138 |

- Celle gemelle identiche al centesimo: banco pulito.
- Autotest del test-case del corso: PASSATO nel log (SL coincide, R 39 vs
  40 del corso = arrotondamento della relatrice, documentato).
- VERDETTO DI TAPPA: USDJPY eliminato (negativo in ENTRAMBE le finestre,
  campione enorme). E' la prima misura dell'implementazione FEDELE del
  corso: rafforza l'ipotesi A (il +133% della lez. 39 non regge), coerente
  col paniere storico a -20.853 e con R77-R80.
- NOTA DD: il 70-81% e' a rischio 1%/operazione senza cap - la cella di
  screening misura segno e campione, non il rischio d'esercizio.
- ANOMALIA DI PERCORSO dichiarata: il passo 0 risulta monco (referto
  storico vuoto, download partito 17:28:54 senza righe di fine nel log
  raccolto). Il canarino pero' dimostra empiricamente che il tester si
  scarica l'M1 da solo su tutta la finestra (3.065 trade distribuiti su
  19 anni). Decisione: si procede col 2B; al traguardo la copertura di
  OGNI cross verra' verificata dai per-trade (data del primo trade +
  densita') e ogni finestra monca sara' dichiarata.
