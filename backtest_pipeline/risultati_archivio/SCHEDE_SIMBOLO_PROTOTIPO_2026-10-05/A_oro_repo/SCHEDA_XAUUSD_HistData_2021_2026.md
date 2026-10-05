# SCHEDA SIMBOLO -- XAUUSD (HistData-2021-2026)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **NY**.
Feed: **HistData-2021-2026 -- NON e' il feed BCM** (fuso del file NY): i numeri descrivono QUESTO feed, non i prezzi del conto BCM; le ore sono riportate sull'orologio server BCM solo per confronto.
Nessuna conclusione di trading da questa scheda: le righe _Decisione informata_ dicono a quale decisione servira' la misura, non la prendono.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **1,980,301** da 2021-01-03 23:00 a 2026-09-18 20:58 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 14 / 1,981,357 / 0, 0, 1056, 383 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 1475 / 1474 (mediana 1380 M1 al giorno) |
| buchi interni 2-59 min | 360 eventi, 573 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2021: 1380 ; 2022: 1380 ; 2023: 1319 ; 2024: 1380 ; 2025: 1380 ; 2026: 1380 |
| barre a range zero | 0.10% |
| prezzo min / max | 1614.7100 / 5596.8050 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 13:30 / 12:30 ; differenza 60 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 13:30 dati USA 8:30 ET ; giorni inverno/estate 301/471, nettezza del picco 2.8/3.2 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **29.30** | 45.30 | 14.88 | 19.82 | 49.84 | 97.06 | 125.64 |
| ADR (% prezzo) | **1.349** | 1.586 | 0.760 | 0.987 | 1.883 | 2.574 | 3.303 |

n = 1474 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 97.78 punti (2.188%). Volatilita' realizzata annua (close-close D1): 17.9%.
Giorni con range > 1,5 x mediana: 29.4% ; > 2 x mediana: 20.5% ; < 0,5 x mediana: 9.3%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2021 | 257 | 21.05 | 23.94 | 1.172 |
| 2022 | 258 | 22.97 | 25.76 | 1.270 |
| 2023 | 257 | 20.56 | 23.43 | 1.053 |
| 2024 | 259 | 30.27 | 33.17 | 1.224 |
| 2025 | 258 | 51.35 | 61.13 | 1.492 |
| 2026 | 185 | 105.98 | 127.53 | 2.288 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 132,064 | **2.69** | 4.17 | 0.1216 | 8.97 |
| H1 | 33,033 | **5.57** | 8.57 | 0.2598 | 19.02 |
| H4 | 9,008 | **10.77** | 16.76 | 0.5038 | 38.13 |
| D1 | 1461 | **29.07** | 45.28 | 1.3982 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.07 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 1.93 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.3.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 1475 | **10.76** | 19.90 | 46.58 | 0.508 | 37% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 1472 | **22.51** | 31.72 | 61.57 | 0.995 | 77% | 09:00-17:30 | 08:00-16:30 |
| NY | 1408 | **18.20** | 26.86 | 53.84 | 0.798 | 62% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 1414 | 3.10 | 3.45 | 2.64 | 3.6 |
| 01 | 1475 | 3.80 | 3.59 | 3.54 | 3.9 |
| 02 | 1475 | 5.65 | 4.81 | 6.11 | 5.2 |
| 03 | 1475 | 4.24 | 3.87 | 4.22 | 3.9 |
| 04 | 1475 | 3.44 | 3.33 | 3.43 | 3.0 |
| 05 | 1474 | 3.11 | 2.61 | 3.09 | 2.7 |
| 06 | 1474 | 4.28 | 3.66 | 4.28 | 3.9 |
| 07 | 1474 | 5.11 | 4.14 | 5.09 | 4.0 |
| 08 | 1473 | 5.80 | 5.10 | 5.67 | 4.1 |
| 09 | 1474 | 5.47 | 5.71 | 5.18 | 4.1 |
| 10 | 1460 | 4.97 | 4.66 | 4.56 | 3.7 |
| 11 | 1422 | 4.80 | 4.22 | 4.74 | 3.7 |
| 12 | 1412 | 5.24 | 4.29 | 5.31 | 4.1 |
| 13 | 1423 | 8.27 | 4.89 | 9.44 | 5.9 |
| 14 | 1413 | 10.54 | 9.57 | 11.08 | 7.2 |
| 15 | 1425 | 10.12 | 9.41 | 10.10 | 7.0 |
| 16 | 1413 | 7.71 | 9.07 | 6.70 | 5.9 |
| 17 | 1412 | 5.73 | 6.42 | 5.21 | 4.5 |
| 18 | 1412 | 4.96 | 4.97 | 4.43 | 4.0 |
| 19 | 1389 | 4.37 | 4.67 | 3.70 | 3.8 |
| 20 | 1378 | 4.04 | 3.84 | 3.73 | 3.5 |
| 21 | 1284 | 3.31 | 3.61 | 2.76 | 2.8 |
| 22 | 532 | 2.77 | 2.58 | n.d. | 2.9 |
| 23 | 747 | 2.56 | n.d. | 2.71 | 2.9 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 293 | 27.43 | 44.54 | 0.98 |
| mar | 298 | 28.31 | 44.11 | 0.97 |
| mer | 296 | 28.08 | 44.23 | 0.98 |
| gio | 296 | 30.73 | 46.35 | 1.02 |
| ven | 291 | 30.96 | 47.31 | 1.04 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 1729 | 1.0 | 0.68 | 5.87 | 0.023 | 0.20 | 3.5% | 44% | 81% | 25% |
| weekend | 297 | 49.0 | 1.31 | 27.22 | 0.045 | 0.94 | 15.8% | 54% | 88% | 60% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 5046 (2610/2436) | **0.787** | 0.626 | 0.41-0.95 | n.d. | 79 | 64 | 51 | 36 | 23% | 2.0 |
| 3 | 2062 (1052/1010) | **0.601** | 0.479 | 0.33-0.73 | 90 | 65 | 47 | 34 | 21 | 12% | 2.0 |
| 4 | 815 (425/390) | **0.480** | 0.383 | 0.26-0.58 | 82 | 50 | 34 | 22 | 12 | 7% | 2.0 |

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
| H1 | 24 | 33,009 | **0.198** | 0.228 | 30% | 39% | 0.204 | 0.172 |
| H4 | 20 | 8,988 | **0.220** | 0.253 | 36% | 36% | 0.224 | 0.190 |
| D1 | 20 | 1,454 | **0.203** | 0.240 | 34% | 38% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 32,412 | 57.7% | 4 | 3.56 | 8.46 | 16% | 7.6 | 3.7 | 325 (183/141/1) | **0.56** |
| H4 | 8,387 | 61.4% | 4 | 3.52 | 8.23 | 16% | 7.9 | 3.8 | 78 (39/39/0) | **0.50** |
| D1 | 853 | 92.0% | 8 | 5.43 | 10.06 | 6% | 1.8 | 1.4 | 4 (2/2/0) | **0.50** |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

Spread (unita' punti): mediana sulle 24 ore **0.210**, p95 mediano 0.230 (fonte: file di spread passato a `--spread`, orario). ATR = **ultimi 252 giorni** dei dati (non l'intera storia: lo spread e' di oggi). Frontiera: uno stop di 1 ATR deve valere >= 40 x spread.

| TF | ATR (ult. 252 gg) | ATR / spread | ATR / spread p95 | stop minimo in ATR per 40 x spread | esito |
|---|---:|---:|---:|---:|---|
| M15 | 8.969 | **42.7** | 39.0 | 0.94 | dentro |
| H1 | 19.023 | **90.6** | 82.7 | 0.44 | dentro |
| H4 | 38.127 | **181.6** | 165.8 | 0.22 | dentro |

Spread per ora server (mediana, p95, giornate):

| ora | 00 | 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 23 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| mediana | 0.27 | 0.27 | 0.27 | 0.26 | 0.26 | 0.25 | 0.27 | 0.21 | 0.21 | 0.20 | 0.20 | 0.21 | 0.20 | 0.21 | 0.21 | 0.18 | 0.18 | 0.20 | 0.20 | 0.21 | 0.20 | 0.22 | 0.27 |
| p95 | 0.28 | 0.28 | 0.28 | 0.28 | 0.28 | 0.28 | 0.28 | 0.24 | 0.23 | 0.23 | 0.22 | 0.23 | 0.23 | 0.23 | 0.22 | 0.22 | 0.22 | 0.23 | 0.23 | 0.23 | 0.23 | 0.29 | 0.28 |

_Cosa dice_: il pedaggio e la fascia in cui costa di piu'. _Decisione informata_: il TF minimo schierabile, e le ore da evitare per ordini a mercato.

## 10. Dove sta nel ranking (stessa finestra per tutti)

[NON MISURATO] ranking solo con due o piu' simboli nella stessa corsa.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
