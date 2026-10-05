# SCHEDA SIMBOLO -- 225JPY (Oanda-JP225-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.
Feed: **Oanda-JP225-2018 -- NON e' il feed BCM** (fuso del file UTC): i numeri descrivono QUESTO feed, non i prezzi del conto BCM; le ore sono riportate sull'orologio server BCM solo per confronto.
Nessuna conclusione di trading da questa scheda: le righe _Decisione informata_ dicono a quale decisione servira' la misura, non la prendono.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **300,680** da 2018-01-01 23:00 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 300,680 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 258 / 254 (mediana 1209 M1 al giorno) |
| buchi interni 2-59 min | 25418 eventi, 52723 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1209 |
| barre a range zero | 7.18% |
| prezzo min / max | 18980.8000 / 24624.8000 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 00:00 / 00:02 ; differenza -2 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 00:00 apertura Tokyo 09:00 JST ; giorni inverno/estate 51/79, nettezza del picco 2.0/3.0 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **337.90** | 390.92 | 179.96 | 235.10 | 484.63 | 671.96 | 826.20 |
| ADR (% prezzo) | **1.482** | 1.765 | 0.792 | 1.033 | 2.199 | 3.068 | 3.718 |

n = 254 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 337.90 punti (1.482%). Volatilita' realizzata annua (close-close D1): 20.1%.
Giorni con range > 1,5 x mediana: 23.2% ; > 2 x mediana: 9.8% ; < 0,5 x mediana: 7.9%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 254 | 337.90 | 390.92 | 1.482 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 23,276 | **30.79** | 35.38 | 0.1364 | 31.11 |
| H1 | 5,894 | **66.75** | 74.07 | 0.2950 | 67.35 |
| H4 | 1,575 | **132.11** | 148.38 | 0.5826 | 133.35 |
| D1 | 241 | **341.46** | 391.06 | 1.5038 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.17 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 1.98 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.1.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 255 | **207.70** | 232.63 | 371.68 | 0.922 | 61% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 248 | **179.35** | 205.86 | 352.26 | 0.800 | 53% | 09:00-17:30 | 08:00-16:30 |
| NY | 248 | **175.00** | 232.49 | 441.72 | 0.773 | 52% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 237 | 61.30 | 97.40 | 50.65 | 4.2 |
| 01 | 258 | 109.00 | 125.55 | 100.00 | 6.6 |
| 02 | 256 | 93.05 | 114.95 | 84.35 | 5.8 |
| 03 | 254 | 66.90 | 79.95 | 60.00 | 4.4 |
| 04 | 252 | 69.90 | 87.70 | 56.90 | 4.4 |
| 05 | 248 | 62.45 | 76.20 | 55.00 | 4.2 |
| 06 | 252 | 68.05 | 76.20 | 55.00 | 4.8 |
| 07 | 240 | 58.20 | 74.95 | 49.40 | 3.7 |
| 08 | 250 | 53.80 | 55.00 | 47.40 | 3.6 |
| 09 | 250 | 61.45 | 74.35 | 43.70 | 3.7 |
| 10 | 239 | 50.00 | 58.80 | 35.05 | 3.1 |
| 11 | 237 | 45.00 | 47.60 | 36.85 | 2.8 |
| 12 | 232 | 42.65 | 49.40 | 31.30 | 2.9 |
| 13 | 238 | 48.15 | 44.95 | 40.00 | 3.1 |
| 14 | 254 | 60.00 | 60.00 | 48.65 | 3.9 |
| 15 | 256 | 77.05 | 90.65 | 56.20 | 4.9 |
| 16 | 253 | 75.10 | 99.90 | 52.50 | 5.1 |
| 17 | 246 | 65.85 | 90.00 | 45.00 | 4.5 |
| 18 | 235 | 57.60 | 67.40 | 40.00 | 4.1 |
| 19 | 228 | 60.10 | 80.10 | 37.50 | 4.4 |
| 20 | 237 | 63.70 | 101.10 | 41.30 | 4.7 |
| 21 | 164 | 65.00 | 98.75 | 38.80 | 4.7 |
| 22 | 67 | 52.70 | 54.25 | n.d. | 3.5 |
| 23 | 66 | 40.25 | n.d. | 42.50 | 3.0 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 49 | 341.00 | 389.32 | 1.00 |
| mar | 51 | 353.80 | 403.56 | 1.03 |
| mer | 52 | 329.00 | 396.08 | 1.01 |
| gio | 52 | 339.75 | 400.17 | 1.02 |
| ven | 50 | 312.90 | 364.60 | 0.93 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 206 | 1.0 | 8.60 | 27.32 | 0.025 | 0.08 | 1.0% | 45% | 96% | n.d. |
| weekend | 52 | 49.0 | 29.40 | 152.66 | 0.086 | 0.45 | 17.3% | 46% | 81% | 67% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 857 (444/413) | **0.759** | 0.619 | 0.41-0.90 | n.d. | 78 | 63 | 50 | 34 | 20% | 2.0 |
| 3 | 334 (157/177) | **0.542** | 0.459 | 0.30-0.69 | 87 | 62 | 44 | 32 | 18 | 7% | 2.0 |
| 4 | 143 (63/80) | **0.478** | 0.381 | 0.26-0.61 | 82 | 50 | 34 | 25 | 14 | 8% | 2.0 |

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
| H1 | 24 | 5,870 | **0.190** | 0.219 | 28% | 41% | 0.204 | 0.172 |
| H4 | 20 | 1,555 | **0.218** | 0.243 | 35% | 36% | 0.224 | 0.190 |
| D1 | 20 | 234 | **0.177** | 0.209 | 31% | 44% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,273 | 51.5% | 4 | 3.37 | 7.92 | 14% | 6.5 | 3.4 | 48 (21/27/0) | **0.44** |
| H4 | 954 | 45.6% | 5 | 2.60 | 6.56 | 17% | 7.4 | 3.4 | 13 (6/7/0) | **0.46** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (253 giorni): **ADR % mediano 1.475 -> posto 2 su 11** ; volatilita' realizzata annua 20.1% -> posto 2 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
