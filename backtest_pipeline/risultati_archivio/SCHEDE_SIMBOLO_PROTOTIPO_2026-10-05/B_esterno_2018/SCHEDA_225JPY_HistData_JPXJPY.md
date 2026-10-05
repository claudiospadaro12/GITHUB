# SCHEDA SIMBOLO -- 225JPY (HistData-JPXJPY)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **NY**.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **1,568,018** da 2013-01-02 11:00 a 2018-12-31 20:13 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 6 / 1,568,018 / 0, 0, 0, 0 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 1543 / 1528 (mediana 1025 M1 al giorno) |
| buchi interni 2-59 min | 249475 eventi, 572615 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2013: 996 ; 2014: 969 ; 2015: 1051 ; 2016: 1135 ; 2017: 879 ; 2018: 1159 |
| barre a range zero | 17.30% |
| prezzo min / max | 10363.0000 / 24475.0000 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 00:00 / 00:00 ; differenza 0 min (attesa 60 +/- 2 se segue l'ora legale) ; ancora assoluta d'inverno: 00:00 apertura Tokyo 09:00 JST -> **DA GUARDARE (fuso o feed)** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **280.00** | 326.56 | 150.00 | 200.00 | 395.00 | 558.60 | 673.25 |
| ADR (% prezzo) | **1.599** | 1.878 | 0.814 | 1.117 | 2.311 | 3.253 | 3.913 |

n = 1528 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 335.00 punti (1.470%). Volatilita' realizzata annua (close-close D1): 21.6%.
Giorni con range > 1,5 x mediana: 21.3% ; > 2 x mediana: 9.7% ; < 0,5 x mediana: 7.0%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2013 | 256 | 280.00 | 327.22 | 2.120 |
| 2014 | 252 | 242.50 | 283.48 | 1.588 |
| 2015 | 258 | 305.00 | 350.83 | 1.606 |
| 2016 | 257 | 320.00 | 370.00 | 1.908 |
| 2017 | 247 | 215.00 | 236.79 | 1.071 |
| 2018 | 258 | 332.75 | 386.41 | 1.466 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 140,365 | **24.50** | 28.75 | 0.1393 | 30.71 |
| H1 | 35,928 | **51.79** | 59.84 | 0.2978 | 66.43 |
| H4 | 9,416 | **108.21** | 123.07 | 0.6225 | 132.14 |
| D1 | 1515 | **300.71** | 328.51 | 1.7445 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.11 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.09 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.4.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 1483 | **175.00** | 209.07 | 345.00 | 0.986 | 62% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 1423 | **150.00** | 178.98 | 305.00 | 0.874 | 54% | 09:00-17:30 | 08:00-16:30 |
| NY | 1404 | **140.00** | 173.19 | 305.00 | 0.818 | 50% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 1237 | 60.00 | 65.00 | 60.00 | 4.3 |
| 01 | 1519 | 90.00 | 96.50 | 85.00 | 6.5 |
| 02 | 1494 | 70.00 | 75.00 | 70.00 | 5.3 |
| 03 | 1404 | 55.00 | 55.00 | 55.00 | 4.1 |
| 04 | 1409 | 60.00 | 65.00 | 60.00 | 4.8 |
| 05 | 1386 | 60.00 | 65.00 | 55.00 | 4.7 |
| 06 | 1465 | 65.00 | 70.00 | 63.50 | 5.1 |
| 07 | 1394 | 55.00 | 60.00 | 55.00 | 4.0 |
| 08 | 1461 | 55.00 | 50.00 | 55.00 | 4.2 |
| 09 | 1391 | 55.00 | 60.00 | 50.00 | 4.0 |
| 10 | 1292 | 45.00 | 50.00 | 41.00 | 3.4 |
| 11 | 1172 | 40.00 | 45.00 | 35.00 | 3.1 |
| 12 | 1107 | 40.00 | 45.00 | 35.00 | 3.0 |
| 13 | 1279 | 45.00 | 45.00 | 45.00 | 3.4 |
| 14 | 1450 | 55.00 | 55.00 | 50.00 | 4.0 |
| 15 | 1496 | 60.00 | 65.00 | 55.00 | 4.6 |
| 16 | 1465 | 55.00 | 75.00 | 46.50 | 4.3 |
| 17 | 1338 | 50.00 | 60.00 | 40.00 | 3.8 |
| 18 | 1216 | 45.00 | 55.00 | 45.00 | 3.6 |
| 19 | 1165 | 50.00 | 57.50 | 45.00 | 4.1 |
| 20 | 1202 | 50.00 | 59.00 | 47.00 | 4.1 |
| 21 | 673 | 50.00 | 60.00 | 45.00 | 4.1 |
| 22 | 158 | 50.00 | 51.50 | n.d. | 3.8 |
| 23 | 190 | 50.00 | n.d. | 49.00 | 3.8 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 299 | 260.00 | 310.05 | 0.95 |
| mar | 309 | 285.00 | 323.79 | 0.99 |
| mer | 309 | 275.00 | 321.87 | 0.99 |
| gio | 308 | 305.00 | 346.08 | 1.06 |
| ven | 303 | 275.00 | 330.64 | 1.01 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 719 | 1.0 | 5.00 | 40.00 | 0.017 | 0.13 | 1.5% | 33% | 97% | 73% |
| weekend | 314 | 49.0 | 10.00 | 111.75 | 0.033 | 0.37 | 9.9% | 38% | 87% | 52% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 5530 (2885/2645) | **0.743** | 0.600 | 0.40-0.90 | n.d. | 76 | 62 | 48 | 33 | 21% | 2.0 |
| 3 | 2167 (1079/1088) | **0.560** | 0.464 | 0.31-0.69 | 87 | 63 | 46 | 31 | 19 | 10% | 2.0 |
| 4 | 830 (399/431) | **0.454** | 0.385 | 0.26-0.56 | 80 | 50 | 32 | 20 | 11 | 5% | 1.0 |

RW di riferimento:

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 6177 | 0.715 | 0.593 | 0.40-0.90 | n.d. | 78 | 61 | 47 | 32 | 20% | 2.0 |
| 3 | 2405 | 0.519 | 0.433 | 0.30-0.64 | 88 | 60 | 40 | 27 | 15 | 7% | 2.0 |
| 4 | 836 | 0.412 | 0.349 | 0.24-0.50 | 76 | 43 | 25 | 16 | 8 | 3% | 2.0 |

_Cosa dice_: quanto, tipicamente, un movimento forte viene riassorbito prima di riprendere, e dopo quanto tempo. _Decisione informata_: dove piazzare un ingresso su ritracciamento (limit al 38,2/50/61,8), quanto aspettare, e se lo stop deve stare oltre il 78,6%.

## 7. Trend o laterale (Efficiency Ratio)

`ER(N) = |close_t - close_(t-N)| / somma |variazioni| nelle N barre`: 1 = linea retta, 0 = andata e ritorno. Trend = ER >= 0.30, laterale = ER <= 0.15 (soglie MIE, dichiarate prima dei numeri). Riferimento random walk: ER ~ 1/radice(N).

| serie | N | n finestre | ER mediano | ER medio | % trend | % laterale | rif. RW 1/radice(N) | RW simulato (mediano) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| H1 | 24 | 35,904 | **0.200** | 0.228 | 30% | 39% | 0.204 | 0.172 |
| H4 | 20 | 9,396 | **0.215** | 0.243 | 34% | 36% | 0.224 | 0.190 |
| D1 | 20 | 1,508 | **0.190** | 0.218 | 29% | 41% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 35,307 | 59.6% | 4 | 3.55 | 8.62 | 14% | 7.0 | 3.6 | 366 (173/193/0) | **0.47** |
| H4 | 8,795 | 62.2% | 4 | 3.33 | 7.91 | 16% | 7.6 | 3.8 | 93 (46/47/0) | **0.49** |
| D1 | 907 | 66.4% | 2 | 3.06 | 7.48 | 18% | 9.5 | 5.5 | 11 (6/5/0) | **0.55** |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (257 giorni): **ADR % mediano 1.466 -> posto 3 su 11** ; volatilita' realizzata annua 19.8% -> posto 3 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
