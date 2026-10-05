# SCHEDA SIMBOLO -- SPXUSD (HistData-SPXUSD)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **NY**.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **2,117,667** da 2010-11-14 23:00 a 2018-12-31 21:13 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 9 / 2,117,667 / 0, 0, 0, 0 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 2096 / 2066 (mediana 1003 M1 al giorno) |
| buchi interni 2-59 min | 321458 eventi, 796840 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2010: 933 ; 2011: 1096 ; 2012: 980 ; 2013: 883 ; 2014: 915 ; 2015: 1091 ; 2016: 1113 ; 2017: 879 ; 2018: 1228 |
| barre a range zero | 18.13% |
| prezzo min / max | 1068.0000 / 2946.7500 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 14:35 / 13:30 ; differenza 65 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 14:30 apertura cash NY 9:30 ET ; giorni inverno/estate 396/630, nettezza del picco 2.9/3.1 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **18.75** | 22.91 | 9.75 | 13.00 | 27.50 | 39.75 | 51.35 |
| ADR (% prezzo) | **1.010** | 1.235 | 0.497 | 0.685 | 1.513 | 2.210 | 2.794 |

n = 2066 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 31.38 punti (1.146%). Volatilita' realizzata annua (close-close D1): 14.9%.
Giorni con range > 1,5 x mediana: 23.8% ; > 2 x mediana: 12.1% ; < 0,5 x mediana: 8.3%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2010 | 31 | 11.75 | 13.76 | 0.953 |
| 2011 | 256 | 21.50 | 24.13 | 1.676 |
| 2012 | 255 | 16.25 | 17.19 | 1.164 |
| 2013 | 251 | 14.50 | 16.67 | 0.904 |
| 2014 | 250 | 17.50 | 19.86 | 0.905 |
| 2015 | 257 | 24.75 | 27.17 | 1.194 |
| 2016 | 258 | 20.25 | 24.43 | 0.969 |
| 2017 | 250 | 14.25 | 15.55 | 0.565 |
| 2018 | 258 | 30.88 | 38.85 | 1.125 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 190,549 | **1.52** | 1.96 | 0.0828 | 2.60 |
| H1 | 48,997 | **3.32** | 4.05 | 0.1825 | 5.73 |
| H4 | 12,769 | **7.04** | 8.48 | 0.3869 | 11.84 |
| D1 | 2053 | **19.70** | 22.91 | 1.0734 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.19 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 2.12 (atteso 2,00) ; ADR mediano / ATR(H1) = 5.6.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 1100 | **6.50** | 8.59 | 15.13 | 0.351 | 35% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 2057 | **13.13** | 15.59 | 26.75 | 0.704 | 70% | 09:00-17:30 | 08:00-16:30 |
| NY | 2030 | **14.50** | 18.12 | 31.00 | 0.790 | 77% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 972 | 2.75 | 3.25 | 2.38 | 3.4 |
| 01 | 1427 | 2.50 | 2.75 | 2.50 | 3.0 |
| 02 | 1460 | 2.75 | 2.75 | 2.50 | 3.4 |
| 03 | 1118 | 2.50 | 3.00 | 2.50 | 3.1 |
| 04 | 969 | 2.50 | 3.00 | 2.25 | 3.0 |
| 05 | 793 | 2.50 | 2.75 | 2.00 | 2.7 |
| 06 | 1123 | 2.50 | 2.75 | 2.25 | 2.8 |
| 07 | 1381 | 2.75 | 2.75 | 2.50 | 3.0 |
| 08 | 1900 | 3.50 | 2.75 | 3.75 | 3.8 |
| 09 | 2024 | 3.50 | 3.75 | 3.00 | 3.9 |
| 10 | 1959 | 3.00 | 3.00 | 2.75 | 3.4 |
| 11 | 1893 | 2.75 | 2.75 | 2.75 | 3.2 |
| 12 | 1897 | 3.00 | 2.75 | 3.00 | 3.3 |
| 13 | 1969 | 3.50 | 3.25 | 3.50 | 4.0 |
| 14 | 2036 | 5.62 | 4.00 | 6.13 | 6.0 |
| 15 | 2068 | 6.50 | 6.00 | 6.50 | 7.0 |
| 16 | 2059 | 5.50 | 6.00 | 5.00 | 6.3 |
| 17 | 2044 | 4.50 | 4.75 | 4.00 | 5.2 |
| 18 | 2010 | 4.25 | 4.25 | 3.75 | 5.0 |
| 19 | 1993 | 4.38 | 4.00 | 4.25 | 5.4 |
| 20 | 2008 | 5.00 | 4.50 | 5.00 | 6.2 |
| 21 | 1445 | 4.25 | 5.25 | 3.50 | 5.4 |
| 22 | 397 | 4.00 | 4.00 | n.d. | 4.3 |
| 23 | 439 | 2.75 | n.d. | 2.75 | 3.2 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 406 | 17.50 | 22.04 | 0.96 |
| mar | 417 | 18.25 | 22.33 | 0.97 |
| mer | 418 | 19.00 | 23.79 | 1.04 |
| gio | 416 | 19.75 | 23.75 | 1.04 |
| ven | 409 | 18.50 | 22.60 | 0.99 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 735 | 1.0 | 0.37 | 2.50 | 0.019 | 0.13 | 1.5% | 28% | 97% | 64% |
| weekend | 426 | 49.0 | 1.00 | 12.31 | 0.051 | 0.63 | 17.6% | 34% | 86% | 65% |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 8319 (4401/3918) | **0.878** | 0.686 | 0.43-1.08 | n.d. | 80 | 68 | 56 | 42 | 29% | 2.0 |
| 3 | 3733 (1912/1821) | **0.689** | 0.552 | 0.34-0.85 | 89 | 70 | 56 | 43 | 29 | 19% | 2.0 |
| 4 | 1541 (743/798) | **0.577** | 0.453 | 0.28-0.74 | 83 | 59 | 45 | 33 | 23 | 14% | 2.0 |

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
| H1 | 24 | 48,973 | **0.204** | 0.236 | 32% | 38% | 0.204 | 0.172 |
| H4 | 20 | 12,749 | **0.219** | 0.249 | 35% | 35% | 0.224 | 0.190 |
| D1 | 20 | 2,046 | **0.200** | 0.236 | 30% | 37% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 48,376 | 63.7% | 4 | 3.88 | 9.76 | 14% | 7.2 | 3.7 | 528 (254/274/0) | **0.48** |
| H4 | 12,148 | 69.6% | 5 | 3.75 | 9.17 | 14% | 7.4 | 3.8 | 120 (55/65/0) | **0.46** |
| D1 | 1,445 | 89.2% | 4 | 5.06 | 10.41 | 8% | 4.4 | 2.4 | 11 (6/5/0) | **0.55** |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (257 giorni): **ADR % mediano 1.121 -> posto 6 su 11** ; volatilita' realizzata annua 16.7% -> posto 5 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
