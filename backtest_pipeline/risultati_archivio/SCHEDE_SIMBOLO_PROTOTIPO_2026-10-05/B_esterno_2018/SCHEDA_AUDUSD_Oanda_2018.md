# SCHEDA SIMBOLO -- AUDUSD (Oanda-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **pip** = 0.0001 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **333,213** da 2018-01-01 22:00 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 333,213 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 261 / 259 (mediana 1290 M1 al giorno) |
| buchi interni 2-59 min | 24686 eventi, 39747 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1290 |
| barre a range zero | 8.54% |
| prezzo min / max | 0.7017 / 0.8136 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 13:30 / 01:30 ; differenza 720 min (attesa 60 +/- 2 se segue l'ora legale) ; ancora assoluta d'inverno: 13:30 dati USA 8:30 ET -> **DA GUARDARE (fuso o feed)** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in pip; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (pip) | **58.60** | 62.32 | 36.98 | 43.50 | 75.40 | 94.42 | 106.62 |
| ADR (% prezzo) | **0.768** | 0.833 | 0.503 | 0.588 | 0.996 | 1.252 | 1.406 |

n = 259 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 59.25 pip (0.789%). Volatilita' realizzata annua (close-close D1): 8.6%.
Giorni con range > 1,5 x mediana: 14.3% ; > 2 x mediana: 1.9% ; < 0,5 x mediana: 1.5%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (pip) | ADR medio (pip) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 259 | 58.60 | 62.32 | 0.768 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in pip.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 24,857 | **5.51** | 5.75 | 0.0737 | 5.53 |
| H1 | 6,216 | **11.42** | 11.86 | 0.1535 | 11.46 |
| H4 | 1,608 | **23.39** | 23.80 | 0.3131 | 23.48 |
| D1 | 246 | **62.61** | 63.04 | 0.8420 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.07 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.05 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.1.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 259 | **27.20** | 30.61 | 48.72 | 0.368 | 46% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 259 | **38.20** | 40.99 | 63.16 | 0.513 | 65% | 09:00-17:30 | 08:00-16:30 |
| NY | 259 | **30.10** | 34.56 | 54.04 | 0.405 | 51% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 254 | 8.00 | 9.70 | 7.30 | 3.2 |
| 01 | 259 | 11.20 | 13.15 | 10.05 | 4.6 |
| 02 | 259 | 13.80 | 15.05 | 14.60 | 5.6 |
| 03 | 259 | 10.60 | 12.60 | 11.20 | 4.2 |
| 04 | 257 | 9.00 | 9.60 | 9.70 | 3.6 |
| 05 | 258 | 7.90 | 9.25 | 7.10 | 3.2 |
| 06 | 259 | 9.10 | 9.40 | 9.60 | 3.6 |
| 07 | 259 | 11.80 | 10.95 | 12.90 | 4.5 |
| 08 | 259 | 13.40 | 13.20 | 12.95 | 5.1 |
| 09 | 259 | 13.20 | 14.85 | 12.95 | 4.9 |
| 10 | 258 | 10.80 | 12.20 | 10.60 | 4.1 |
| 11 | 257 | 10.40 | 11.10 | 9.80 | 3.9 |
| 12 | 257 | 10.40 | 10.70 | 10.15 | 4.1 |
| 13 | 258 | 12.40 | 10.60 | 14.70 | 5.0 |
| 14 | 258 | 13.75 | 15.60 | 13.40 | 5.4 |
| 15 | 259 | 16.00 | 16.10 | 15.00 | 5.8 |
| 16 | 259 | 13.50 | 19.25 | 11.60 | 5.5 |
| 17 | 259 | 11.00 | 13.35 | 9.05 | 4.2 |
| 18 | 258 | 9.35 | 10.20 | 8.90 | 3.8 |
| 19 | 256 | 8.75 | 9.65 | 8.40 | 3.8 |
| 20 | 257 | 7.50 | 10.00 | 6.80 | 3.5 |
| 21 | 242 | 6.90 | 8.30 | 6.40 | 2.8 |
| 22 | 196 | 7.25 | 8.10 | 7.40 | 2.9 |
| 23 | 184 | 6.80 | 9.10 | 5.30 | 2.8 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 52 | 47.35 | 50.19 | 0.81 |
| mar | 51 | 59.50 | 60.38 | 0.97 |
| mer | 52 | 64.10 | 70.04 | 1.12 |
| gio | 52 | 60.95 | 65.65 | 1.05 |
| ven | 52 | 62.00 | 65.30 | 1.05 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (pip) | p95 (pip) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 1 | n.d. | | | | | | | | |
| weekend | 52 | 48.0 | 3.80 | 24.13 | 0.061 | 0.39 | 9.6% | 62% | 98% | 80% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 908 (441/467) | **0.722** | 0.579 | 0.39-0.91 | n.d. | 76 | 58 | 46 | 32 | 21% | 2.0 |
| 3 | 325 (152/173) | **0.546** | 0.429 | 0.30-0.63 | 88 | 58 | 38 | 26 | 18 | 11% | 2.0 |
| 4 | 121 (65/56) | **0.447** | 0.338 | 0.25-0.55 | 78 | 45 | 29 | 21 | 12 | 7% | 2.0 |

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
| H1 | 24 | 6,192 | **0.180** | 0.211 | 27% | 43% | 0.204 | 0.172 |
| H4 | 20 | 1,588 | **0.213** | 0.239 | 31% | 36% | 0.224 | 0.190 |
| D1 | 20 | 239 | **0.165** | 0.182 | 19% | 44% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,595 | 38.8% | 4 | 3.07 | 7.74 | 18% | 9.6 | 4.8 | 60 (28/32/0) | **0.47** |
| H4 | 987 | 25.5% | 6 | 2.60 | 5.94 | 20% | 8.9 | 3.6 | 15 (8/7/0) | **0.53** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (258 giorni): **ADR % mediano 0.772 -> posto 9 su 11** ; volatilita' realizzata annua 8.6% -> posto 9 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
