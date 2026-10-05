# SCHEDA SIMBOLO -- NASUSD (Oanda-NAS100-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.
Feed: **Oanda-NAS100-2018 -- NON e' il feed BCM** (fuso del file UTC): i numeri descrivono QUESTO feed, non i prezzi del conto BCM; le ore sono riportate sull'orologio server BCM solo per confronto.
Nessuna conclusione di trading da questa scheda: le righe _Decisione informata_ dicono a quale decisione servira' la misura, non la prendono.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **347,349** da 2018-01-01 23:00 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 347,349 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 258 / 258 (mediana 1364 M1 al giorno) |
| buchi interni 2-59 min | 2037 eventi, 6121 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1364 |
| barre a range zero | 0.93% |
| prezzo min / max | 5802.4000 / 7701.6000 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 14:31 / 13:30 ; differenza 61 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 14:30 apertura cash NY 9:30 ET ; giorni inverno/estate 51/79, nettezza del picco 4.7/4.3 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **112.45** | 133.88 | 61.04 | 77.25 | 163.03 | 235.76 | 280.26 |
| ADR (% prezzo) | **1.618** | 1.945 | 0.845 | 1.091 | 2.443 | 3.644 | 4.401 |

n = 258 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 114.75 punti (1.625%). Volatilita' realizzata annua (close-close D1): 22.0%.
Giorni con range > 1,5 x mediana: 23.6% ; > 2 x mediana: 12.0% ; < 0,5 x mediana: 8.1%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 258 | 112.45 | 133.88 | 1.618 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 23,314 | **8.86** | 11.50 | 0.1266 | 9.03 |
| H1 | 5,894 | **20.00** | 23.80 | 0.2829 | 20.31 |
| H4 | 1,575 | **41.20** | 48.87 | 0.5791 | 41.90 |
| D1 | 245 | **120.24** | 133.29 | 1.7657 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.26 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.06 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.6.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 258 | **28.25** | 35.17 | 65.65 | 0.403 | 25% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 258 | **76.00** | 86.73 | 145.61 | 1.066 | 68% | 09:00-17:30 | 08:00-16:30 |
| NY | 257 | **93.20** | 111.61 | 209.28 | 1.307 | 83% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 258 | 10.75 | 17.60 | 7.10 | 2.8 |
| 01 | 258 | 12.70 | 13.45 | 9.90 | 2.8 |
| 02 | 258 | 15.70 | 16.25 | 12.50 | 3.3 |
| 03 | 258 | 11.80 | 11.85 | 9.45 | 2.6 |
| 04 | 258 | 9.40 | 11.15 | 7.90 | 2.1 |
| 05 | 258 | 7.70 | 9.40 | 5.90 | 1.8 |
| 06 | 258 | 10.15 | 9.40 | 8.75 | 2.4 |
| 07 | 258 | 11.65 | 10.45 | 10.95 | 2.5 |
| 08 | 258 | 15.55 | 14.60 | 12.30 | 3.2 |
| 09 | 258 | 15.20 | 18.20 | 10.40 | 3.3 |
| 10 | 258 | 13.35 | 14.20 | 10.35 | 3.0 |
| 11 | 258 | 13.65 | 12.95 | 10.80 | 2.9 |
| 12 | 258 | 14.50 | 15.40 | 11.00 | 3.1 |
| 13 | 258 | 16.75 | 14.25 | 14.70 | 3.6 |
| 14 | 258 | 34.35 | 23.50 | 32.00 | 6.9 |
| 15 | 258 | 39.90 | 42.25 | 31.20 | 8.2 |
| 16 | 257 | 37.60 | 39.60 | 24.00 | 7.9 |
| 17 | 257 | 30.20 | 34.80 | 19.40 | 6.4 |
| 18 | 253 | 26.20 | 31.60 | 16.70 | 5.9 |
| 19 | 248 | 28.50 | 31.80 | 18.50 | 6.2 |
| 20 | 248 | 28.50 | 40.20 | 20.20 | 6.8 |
| 21 | 247 | 18.30 | 42.60 | 10.95 | 5.5 |
| 22 | 83 | 22.00 | 22.15 | n.d. | 4.3 |
| 23 | 135 | 9.90 | n.d. | 8.70 | 2.3 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 52 | 117.20 | 135.65 | 1.01 |
| mar | 51 | 117.30 | 131.75 | 0.98 |
| mer | 52 | 112.30 | 142.39 | 1.06 |
| gio | 52 | 113.75 | 132.62 | 0.99 |
| ven | 51 | 106.20 | 126.81 | 0.95 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 205 | 1.0 | 1.90 | 14.36 | 0.016 | 0.12 | 2.0% | 41% | 97% | 75% |
| weekend | 52 | 49.0 | 8.60 | 46.68 | 0.072 | 0.39 | 15.4% | 50% | 83% | 75% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 971 (516/455) | **0.933** | 0.710 | 0.43-1.17 | n.d. | 79 | 68 | 57 | 44 | 32% | 2.0 |
| 3 | 455 (232/223) | **0.750** | 0.569 | 0.34-0.94 | 89 | 70 | 58 | 45 | 33 | 24% | 2.0 |
| 4 | 227 (105/122) | **0.605** | 0.439 | 0.29-0.70 | 83 | 58 | 44 | 32 | 21 | 16% | 2.0 |

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
| H1 | 24 | 5,870 | **0.225** | 0.258 | 37% | 34% | 0.204 | 0.172 |
| H4 | 20 | 1,555 | **0.229** | 0.273 | 39% | 35% | 0.224 | 0.190 |
| D1 | 20 | 238 | **0.163** | 0.193 | 19% | 46% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,273 | 55.4% | 4 | 3.70 | 9.84 | 14% | 7.2 | 3.4 | 58 (29/29/0) | **0.50** |
| H4 | 954 | 57.0% | 4 | 3.66 | 7.86 | 14% | 8.2 | 4.4 | 8 (3/5/0) | **0.38** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (257 giorni): **ADR % mediano 1.619 -> posto 1 su 11** ; volatilita' realizzata annua 22.0% -> posto 1 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
