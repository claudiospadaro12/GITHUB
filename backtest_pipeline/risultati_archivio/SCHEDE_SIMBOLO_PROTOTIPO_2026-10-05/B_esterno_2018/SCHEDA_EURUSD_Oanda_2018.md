# SCHEDA SIMBOLO -- EURUSD (Oanda-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **pip** = 0.0001 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.
Feed: **Oanda-2018 -- NON e' il feed BCM** (fuso del file UTC): i numeri descrivono QUESTO feed, non i prezzi del conto BCM; le ore sono riportate sull'orologio server BCM solo per confronto.
Nessuna conclusione di trading da questa scheda: le righe _Decisione informata_ dicono a quale decisione servira' la misura, non la prendono.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **359,807** da 2018-01-01 22:00 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 359,807 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 261 / 259 (mediana 1394 M1 al giorno) |
| buchi interni 2-59 min | 8979 eventi, 13153 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1394 |
| barre a range zero | 2.63% |
| prezzo min / max | 1.1216 / 1.2556 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 13:30 / 12:30 ; differenza 60 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 13:30 dati USA 8:30 ET ; giorni inverno/estate 51/79, nettezza del picco 2.6/2.1 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in pip; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (pip) | **80.20** | 85.29 | 54.72 | 65.25 | 99.30 | 120.64 | 129.73 |
| ADR (% prezzo) | **0.678** | 0.721 | 0.467 | 0.553 | 0.850 | 0.995 | 1.115 |

n = 259 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 80.20 pip (0.678%). Volatilita' realizzata annua (close-close D1): 7.2%.
Giorni con range > 1,5 x mediana: 10.4% ; > 2 x mediana: 2.3% ; < 0,5 x mediana: 0.8%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (pip) | ADR medio (pip) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 259 | 80.20 | 85.29 | 0.678 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in pip.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 24,863 | **7.38** | 7.75 | 0.0625 | 7.42 |
| H1 | 6,216 | **15.29** | 15.71 | 0.1298 | 15.39 |
| H4 | 1,608 | **30.54** | 31.72 | 0.2604 | 30.69 |
| D1 | 246 | **83.18** | 85.46 | 0.7107 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.07 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.00 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.2.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 259 | **23.10** | 26.29 | 41.10 | 0.198 | 29% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 259 | **64.40** | 67.15 | 91.36 | 0.549 | 80% | 09:00-17:30 | 08:00-16:30 |
| NY | 259 | **43.60** | 48.72 | 75.46 | 0.367 | 54% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 259 | 7.00 | 10.00 | 6.70 | 2.3 |
| 01 | 259 | 10.50 | 12.85 | 10.25 | 3.2 |
| 02 | 259 | 10.80 | 13.05 | 10.80 | 3.3 |
| 03 | 259 | 8.90 | 11.75 | 9.40 | 2.8 |
| 04 | 259 | 8.10 | 9.05 | 8.20 | 2.4 |
| 05 | 259 | 7.50 | 9.95 | 7.70 | 2.3 |
| 06 | 259 | 9.70 | 9.75 | 11.80 | 3.1 |
| 07 | 259 | 16.80 | 14.10 | 20.20 | 4.9 |
| 08 | 259 | 20.80 | 19.85 | 20.60 | 6.1 |
| 09 | 259 | 20.10 | 22.25 | 20.55 | 6.0 |
| 10 | 259 | 17.10 | 18.80 | 16.10 | 5.0 |
| 11 | 259 | 15.90 | 17.10 | 15.85 | 4.7 |
| 12 | 258 | 16.90 | 16.90 | 17.45 | 5.0 |
| 13 | 258 | 20.90 | 17.75 | 21.20 | 6.2 |
| 14 | 259 | 19.90 | 22.40 | 18.80 | 6.3 |
| 15 | 259 | 21.80 | 25.10 | 19.85 | 6.5 |
| 16 | 259 | 19.80 | 27.30 | 16.80 | 5.9 |
| 17 | 259 | 16.00 | 19.95 | 13.00 | 4.8 |
| 18 | 259 | 14.70 | 17.40 | 14.25 | 4.5 |
| 19 | 258 | 12.50 | 15.85 | 12.90 | 4.1 |
| 20 | 259 | 10.60 | 13.95 | 9.90 | 3.6 |
| 21 | 259 | 8.70 | 12.05 | 7.25 | 2.8 |
| 22 | 223 | 7.60 | 10.65 | 7.40 | 2.4 |
| 23 | 206 | 5.90 | 8.40 | 5.00 | 1.9 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 52 | 72.25 | 77.01 | 0.90 |
| mar | 51 | 79.90 | 84.33 | 0.99 |
| mer | 52 | 77.40 | 85.85 | 1.01 |
| gio | 52 | 84.30 | 92.53 | 1.08 |
| ven | 52 | 83.75 | 86.72 | 1.02 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (pip) | p95 (pip) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 1 | n.d. | | | | | | | | |
| weekend | 52 | 48.0 | 4.15 | 36.86 | 0.050 | 0.44 | 7.7% | 46% | 100% | 100% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 978 (502/476) | **0.870** | 0.679 | 0.43-1.07 | n.d. | 80 | 67 | 55 | 40 | 28% | 2.0 |
| 3 | 419 (198/221) | **0.673** | 0.511 | 0.35-0.79 | 92 | 68 | 51 | 39 | 25 | 16% | 2.0 |
| 4 | 155 (62/93) | **0.498** | 0.405 | 0.30-0.59 | 85 | 53 | 34 | 23 | 10 | 6% | 2.0 |

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
| H1 | 24 | 6,192 | **0.212** | 0.233 | 33% | 37% | 0.204 | 0.172 |
| H4 | 20 | 1,588 | **0.215** | 0.244 | 34% | 36% | 0.224 | 0.190 |
| D1 | 20 | 239 | **0.133** | 0.180 | 21% | 56% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,595 | 42.8% | 5 | 3.01 | 7.60 | 18% | 9.2 | 4.3 | 71 (40/31/0) | **0.56** |
| H4 | 987 | 24.9% | 3 | 2.48 | 6.55 | 23% | 11.4 | 6.4 | 10 (7/3/0) | **0.70** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (258 giorni): **ADR % mediano 0.678 -> posto 11 su 11** ; volatilita' realizzata annua 7.2% -> posto 11 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
