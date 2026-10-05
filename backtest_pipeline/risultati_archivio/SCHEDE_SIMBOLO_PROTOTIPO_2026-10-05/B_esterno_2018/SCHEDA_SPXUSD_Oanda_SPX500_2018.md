# SCHEDA SIMBOLO -- SPXUSD (Oanda-SPX500-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.
Feed: **Oanda-SPX500-2018 -- NON e' il feed BCM** (fuso del file UTC): i numeri descrivono QUESTO feed, non i prezzi del conto BCM; le ore sono riportate sull'orologio server BCM solo per confronto.
Nessuna conclusione di trading da questa scheda: le righe _Decisione informata_ dicono a quale decisione servira' la misura, non la prendono.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **296,223** da 2018-01-01 23:00 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 296,223 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 258 / 256 (mediana 1178 M1 al giorno) |
| buchi interni 2-59 min | 28132 eventi, 57292 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1178 |
| barre a range zero | 11.14% |
| prezzo min / max | 2315.6000 / 2942.0000 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 14:31 / 13:31 ; differenza 60 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 14:30 apertura cash NY 9:30 ET ; giorni inverno/estate 51/79, nettezza del picco 3.8/3.1 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **31.20** | 39.08 | 15.50 | 21.20 | 48.15 | 72.60 | 92.40 |
| ADR (% prezzo) | **1.144** | 1.444 | 0.544 | 0.773 | 1.799 | 2.730 | 3.425 |

n = 256 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 31.30 punti (1.150%). Volatilita' realizzata annua (close-close D1): 16.8%.
Giorni con range > 1,5 x mediana: 26.6% ; > 2 x mediana: 16.8% ; < 0,5 x mediana: 10.5%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 256 | 31.20 | 39.08 | 1.144 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 23,277 | **2.57** | 3.39 | 0.0933 | 2.61 |
| H1 | 5,897 | **5.74** | 7.04 | 0.2093 | 5.83 |
| H4 | 1,577 | **11.79** | 14.43 | 0.4270 | 11.86 |
| D1 | 243 | **35.84** | 38.67 | 1.3270 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.23 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.05 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.4.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 228 | **9.20** | 11.58 | 21.66 | 0.332 | 29% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 256 | **20.10** | 23.81 | 44.40 | 0.734 | 64% | 09:00-17:30 | 08:00-16:30 |
| NY | 253 | **24.80** | 32.73 | 65.36 | 0.886 | 79% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 198 | 4.00 | 7.00 | 2.90 | 3.4 |
| 01 | 236 | 4.10 | 5.70 | 3.40 | 2.9 |
| 02 | 248 | 4.60 | 5.60 | 3.40 | 3.4 |
| 03 | 236 | 3.80 | 4.70 | 2.60 | 2.6 |
| 04 | 208 | 3.40 | 4.40 | 2.40 | 2.3 |
| 05 | 168 | 2.80 | 4.00 | 2.00 | 2.3 |
| 06 | 211 | 3.60 | 4.10 | 2.70 | 2.6 |
| 07 | 229 | 3.80 | 4.20 | 3.30 | 2.6 |
| 08 | 244 | 5.00 | 5.50 | 4.00 | 3.4 |
| 09 | 256 | 5.00 | 6.60 | 3.40 | 3.4 |
| 10 | 251 | 4.40 | 5.60 | 3.40 | 3.0 |
| 11 | 245 | 4.60 | 5.00 | 3.60 | 3.0 |
| 12 | 240 | 4.70 | 5.80 | 3.40 | 3.1 |
| 13 | 240 | 5.20 | 5.60 | 3.80 | 3.6 |
| 14 | 251 | 8.20 | 7.60 | 7.00 | 5.4 |
| 15 | 255 | 10.20 | 12.50 | 7.30 | 7.0 |
| 16 | 255 | 10.00 | 14.40 | 6.80 | 7.1 |
| 17 | 255 | 8.60 | 12.00 | 4.80 | 5.9 |
| 18 | 251 | 7.40 | 9.60 | 4.40 | 5.5 |
| 19 | 246 | 8.60 | 11.60 | 5.20 | 6.1 |
| 20 | 246 | 9.60 | 13.30 | 6.10 | 7.1 |
| 21 | 187 | 8.00 | 14.60 | 4.80 | 6.8 |
| 22 | 71 | 7.00 | 8.00 | n.d. | 4.9 |
| 23 | 98 | 3.60 | n.d. | 3.00 | 2.6 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 50 | 28.70 | 39.70 | 1.02 |
| mar | 51 | 31.20 | 37.68 | 0.96 |
| mer | 52 | 33.90 | 41.49 | 1.06 |
| gio | 52 | 31.30 | 38.85 | 0.99 |
| ven | 51 | 32.40 | 37.66 | 0.96 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 207 | 1.0 | 0.60 | 3.54 | 0.017 | 0.10 | 1.4% | 39% | 94% | 100% |
| weekend | 52 | 49.0 | 2.70 | 15.29 | 0.075 | 0.43 | 15.4% | 44% | 79% | 62% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 962 (510/452) | **0.869** | 0.676 | 0.43-1.09 | n.d. | 80 | 67 | 56 | 41 | 29% | 2.0 |
| 3 | 436 (220/216) | **0.697** | 0.537 | 0.36-0.86 | 88 | 71 | 54 | 42 | 28 | 18% | 2.0 |
| 4 | 201 (97/104) | **0.592** | 0.435 | 0.28-0.70 | 81 | 60 | 42 | 30 | 21 | 16% | 2.0 |

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
| H1 | 24 | 5,873 | **0.213** | 0.245 | 34% | 36% | 0.204 | 0.172 |
| H4 | 20 | 1,557 | **0.230** | 0.268 | 37% | 33% | 0.224 | 0.190 |
| D1 | 20 | 236 | **0.191** | 0.211 | 22% | 36% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,276 | 54.1% | 4 | 3.47 | 9.13 | 14% | 7.1 | 3.8 | 54 (24/30/0) | **0.44** |
| H4 | 956 | 61.1% | 4 | 4.05 | 7.92 | 9% | 4.7 | 2.8 | 7 (4/3/0) | **0.57** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (255 giorni): **ADR % mediano 1.141 -> posto 5 su 11** ; volatilita' realizzata annua 16.8% -> posto 4 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
