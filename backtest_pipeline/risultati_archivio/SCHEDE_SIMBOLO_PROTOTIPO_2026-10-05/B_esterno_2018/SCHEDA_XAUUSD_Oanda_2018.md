# SCHEDA SIMBOLO -- XAUUSD (Oanda-2018)

Generata da `backtest_pipeline/scheda_simbolo.py` (SCHEDA_SIMBOLO_v1). **DESCRITTIVA: non e' un test di edge, non e' un backtest.**
Unita': **punti** = 1.0000 di prezzo. Giorno: **giorno server BCM (mezzanotte server)**; orologio server: **UTC+1 fisso**; fuso del file: **UTC**.

## 0. Chi sono i dati (i cancelli prima dei numeri)

| voce | valore |
|---|---|
| barre M1 | **349,971** da 2018-01-01 23:05 a 2018-12-31 21:59 (UTC) |
| file / righe / scartate (parse, OHLC, doppi, fuori ordine) | 12 / 349,971 / 0, 0, 0, 1 |
| giorni / giorni pieni (>= 50% della mediana di M1) | 259 / 258 (mediana 1365 M1 al giorno) |
| buchi interni 2-59 min | 3290 eventi, 4259 minuti mancanti |
| M1 mediane per giorno, per anno (copertura: un anno molto sotto gli altri ha buchi, e l'ATR di quell'anno e' leggermente per difetto) | 2018: 1365 |
| barre a range zero | 0.13% |
| prezzo min / max | 1160.2080 / 1366.1550 |
| picco di volatilita' del minuto (UTC): inverno gen-feb / estate giu-ago | 13:30 / 12:30 ; differenza 60 min (attesa: 60 +/- 5 per un evento USA/Europa, 0 +/- 5 per un evento di Tokyo; la tolleranza di 5 minuti serve a non confondere un picco largo con un errore, il controllo cerca errori di ORE) ; ancora assoluta d'inverno: 13:30 dati USA 8:30 ET ; giorni inverno/estate 51/79, nettezza del picco 2.4/2.1 volte la mediana -> **ok** |

_Cosa dice_: se il picco non cade su un'ancora nota (apertura cash, dati USA 8:30 ET) il fuso dichiarato e' sbagliato e **tutte** le etichette orarie sotto sono sbagliate. _Decisione informata_: fidarsi o no delle sezioni 3-4. Limite del controllo: non separa 13:30 da 14:30 UTC (dati USA 8:30 contro apertura cash 9:30), quindi un errore di esattamente un'ora fra questi due non si vede.

> Ranking e correlazioni sulla finestra comune a tutte le serie della corsa: 2018-01-02 -> 2018-12-28.

## 1. Range medio giornaliero (ADR)

Formula: `range = H - L` del giorno (giorni pieni), in punti; in % del prezzo = `100 x (H-L) / open del giorno`.

| | mediana | media | p10 | p25 | p75 | p90 | p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| ADR (punti) | **11.43** | 12.44 | 7.34 | 8.83 | 14.38 | 19.51 | 22.69 |
| ADR (% prezzo) | **0.892** | 0.979 | 0.591 | 0.701 | 1.119 | 1.524 | 1.779 |

n = 258 giorni pieni. Ultimi ~252 giorni pieni: ADR mediano 11.42 punti (0.892%). Volatilita' realizzata annua (close-close D1): 9.5%.
Giorni con range > 1,5 x mediana: 15.5% ; > 2 x mediana: 4.7% ; < 0,5 x mediana: 2.7%.

**Per anno** (mediana del range, giorni pieni)

| anno | n | ADR mediano (punti) | ADR medio (punti) | ADR mediano (%) |
|---:|---:|---:|---:|---:|
| 2018 | 258 | 11.43 | 12.44 | 0.892 |

_Cosa dice_: quanta strada fa il prezzo in un giorno tipico e quanto e' coda grassa (media >> mediana = giornate esplosive). _Decisione informata_: lo stop in ATR/ADR, un TP che stia dentro il giorno (un TP a 1,5 x ADR mediano si raggiunge in una minoranza dei giorni), e la lettura di una giornata anomala. Il confronto fra anni dice se il numero e' di un regime.

## 2. ATR per timeframe

Formula: `ATR(14)` = media SEMPLICE del true range su 14 barre (come `iATR` di MT5, non Wilder); barre costruite sull'orologio server, mai a cavallo di due giorni. Valori in punti.

| TF | barre | ATR mediano | ATR medio | ATR % prezzo (mediana) | ATR ultimi 252 gg |
|---|---:|---:|---:|---:|---:|
| M15 | 23,616 | **1.12** | 1.23 | 0.0883 | 1.12 |
| H1 | 5,906 | **2.34** | 2.43 | 0.1842 | 2.34 |
| H4 | 1,578 | **4.58** | 4.73 | 0.3654 | 4.56 |
| D1 | 245 | **12.13** | 12.44 | 0.9824 | - |

Rapporti: ATR(H1)/ATR(M15) = 2.09 (radice di T atteso 2,00 se i rendimenti fossero indipendenti) ; ATR(H4)/ATR(H1) = 1.95 (atteso 2,00) ; ADR mediano / ATR(H1) = 4.9.

_Cosa dice_: la scala di ogni TF e quanto il simbolo si scosta dalla legge radice-di-T (sopra 2 = tendenza che si accumula, sotto 2 = rumore che si compensa). _Decisione informata_: lo stop in ATR su quel TF, il TF minimo che passa la frontiera del costo (sezione 9).

## 3. Range per sessione (orari reali di borsa, convertiti in ora server UTC+1 fisso)

| sessione | giorni | range mediano | medio | p90 | mediana % prezzo | quota dell'ADR mediano | finestra in ora server inverno | estate |
|---|---:|---:|---:|---:|---:|---:|---|---|
| ASIA | 258 | **4.35** | 4.73 | 7.20 | 0.341 | 38% | 01:00-07:00 | 01:00-07:00 |
| LONDRA | 258 | **8.21** | 9.22 | 13.83 | 0.645 | 72% | 09:00-17:30 | 08:00-16:30 |
| NY | 258 | **6.82** | 7.54 | 12.40 | 0.529 | 60% | 15:30-22:00 | 14:30-21:00 |

Le sessioni si SOVRAPPONGONO (Londra/NY 15:30-17:30 server d'inverno) e non sommano al 100%: sono finestre indipendenti, ognuna con la sua ora legale (Tokyo non ce l'ha). Un simbolo che non scambia in una finestra mostra pochi giorni validi (>= 50% dei minuti presenti).

_Cosa dice_: in quale sessione il simbolo fa il suo movimento. _Decisione informata_: la fascia oraria di un EA (e quanto spazio ha il TP dentro quella fascia).

## 4. Range per ora server e per giorno della settimana

Range = H-L dentro l'ora server (UTC+1 fisso), solo giorni feriali con >= 30 M1 nell'ora. Inverno = dic-feb, estate = giu-ago: gli eventi a ora fissa USA/Europa si spostano di 1 ora fra le due colonne.

| ora server | n | mediana | inverno | estate | quota % del totale |
|---:|---:|---:|---:|---:|---:|
| 00 | 258 | 1.48 | 2.39 | 1.26 | 3.1 |
| 01 | 258 | 1.87 | 2.06 | 1.83 | 3.7 |
| 02 | 258 | 2.37 | 2.75 | 2.47 | 4.5 |
| 03 | 258 | 1.66 | 2.02 | 1.78 | 3.3 |
| 04 | 258 | 1.33 | 1.55 | 1.32 | 2.6 |
| 05 | 258 | 1.25 | 1.28 | 1.27 | 2.5 |
| 06 | 258 | 1.69 | 1.54 | 1.80 | 3.2 |
| 07 | 258 | 2.24 | 1.97 | 2.31 | 4.2 |
| 08 | 258 | 2.52 | 2.42 | 2.42 | 4.8 |
| 09 | 258 | 2.32 | 2.43 | 2.25 | 4.4 |
| 10 | 258 | 1.98 | 2.00 | 1.91 | 3.8 |
| 11 | 258 | 1.93 | 2.03 | 1.87 | 3.7 |
| 12 | 258 | 2.09 | 1.92 | 2.25 | 4.2 |
| 13 | 258 | 3.16 | 2.31 | 3.35 | 6.3 |
| 14 | 258 | 3.51 | 3.51 | 3.23 | 7.0 |
| 15 | 258 | 3.26 | 3.52 | 2.73 | 6.5 |
| 16 | 258 | 2.94 | 3.68 | 2.38 | 5.7 |
| 17 | 258 | 2.32 | 2.82 | 1.84 | 4.6 |
| 18 | 255 | 2.33 | 2.26 | 2.33 | 4.6 |
| 19 | 252 | 2.07 | 2.97 | 1.67 | 4.5 |
| 20 | 250 | 1.83 | 2.40 | 1.57 | 4.1 |
| 21 | 250 | 1.50 | 2.36 | 1.27 | 3.2 |
| 22 | 84 | 1.39 | 1.69 | n.d. | 2.9 |
| 23 | 135 | 1.30 | n.d. | 1.24 | 2.5 |

| giorno | n | range mediano | range medio | indice (media / media dei 5 giorni) |
|---|---:|---:|---:|---:|
| lun | 52 | 10.01 | 10.81 | 0.87 |
| mar | 51 | 11.91 | 13.01 | 1.05 |
| mer | 52 | 11.54 | 13.50 | 1.09 |
| gio | 52 | 11.51 | 12.66 | 1.02 |
| ven | 51 | 11.35 | 12.21 | 0.98 |

Domenica sera e sabato sono attribuiti al lunedi'.
_Cosa dice_: dove sta il movimento nella giornata e nella settimana. _Decisione informata_: la finestra oraria, i giorni da escludere/pesare, dove NON mettere un ordine.

## 5. Gap di apertura

Gap = primo open dopo un buco di quotazioni >= 60 minuti meno l'ultima chiusura. 'pausa' = buco < 36 ore (la notte/la pausa giornaliera), 'weekend' = buco >= 36 ore. Riempito = nel segmento che segue il buco il prezzo torna alla chiusura precedente.

| classe | n | buco mediano (ore) | gap assoluto mediano (punti) | p95 (punti) | mediano in ATR D1 | p95 in ATR D1 | % con gap > 0,25 ATR D1 | % gap su | % riempito | % riempito se > 0,25 ATR |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| pausa | 206 | 1.0 | 0.30 | 0.90 | 0.025 | 0.07 | 0.5% | 50% | 97% | n.d. |
| weekend | 52 | 49.0 | 0.80 | 2.19 | 0.066 | 0.18 | 1.9% | 54% | 92% | n.d. |

_Cosa dice_: quanto salta il prezzo fra una sessione e l'altra e se il salto si ritira. _Decisione informata_: gap-fade o gap-continuation (le sedie GapFill/GapContinuation), il rischio di stop saltato nel weekend, la distanza minima dello stop dall'overnight.

## 6. Ritracciamento dopo un impulso (zigzag a soglia ATR, TF H1)

Procedura: pivot di uno zigzag che inverte quando il prezzo si muove di **0.5 ATR(14) H1** contro l'ultimo estremo (una barra che fa un nuovo estremo non conferma anche l'inversione). **Impulso k** = gamba tra due pivot lunga >= k ATR al suo termine. **Ritracciamento** = la gamba successiva / l'impulso (il massimo ritracciamento prima che il movimento riprenda per 0.5 ATR). Tocco di un livello = frazione di impulsi con ritracciamento >= livello. Un livello <= 0.5/k e' troncato per costruzione (la gamba successiva non puo' essere piu' corta della soglia di inversione): mostrato 'n.d.'.

Misura DESCRITTIVA, i pivot si conoscono in ritardo: **non e' un segnale**. Accanto, il RANDOM WALK passato dalla stessa procedura (seme fisso, 40.000 barre): se il simbolo ritraccia come il RW, quel numero non e' una proprieta' del simbolo.

| k (ATR) | impulsi (su/giu) | ritr. medio | mediana | p25-p75 | tocco 23.6% | tocco 38.2% | tocco 50.0% | tocco 61.8% | tocco 78.6% | inversione (>=100%) | tempo mediano (barre) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 2 | 832 (405/427) | **0.756** | 0.613 | 0.41-0.91 | n.d. | 80 | 63 | 49 | 34 | 21% | 2.0 |
| 3 | 317 (154/163) | **0.597** | 0.470 | 0.35-0.70 | 92 | 67 | 45 | 32 | 21 | 13% | 2.0 |
| 4 | 105 (51/54) | **0.510** | 0.410 | 0.28-0.56 | 86 | 55 | 35 | 21 | 13 | 9% | 2.0 |

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
| H1 | 24 | 5,882 | **0.184** | 0.214 | 26% | 41% | 0.204 | 0.172 |
| H4 | 20 | 1,558 | **0.197** | 0.225 | 29% | 39% | 0.224 | 0.190 |
| D1 | 20 | 238 | **0.185** | 0.218 | 30% | 39% | 0.224 | 0.190 |

_Cosa dice_: se il simbolo e' piu' direzionale (ER sopra il RW) o piu' di ritorno alla media (sotto). _Decisione informata_: motore a trend (sopra il RW) o a ritorno (sotto) su quel TF; quanto filtro-trend serve.

## 8. Comportamento alla EMA200 (DESCRITTIVO)

**Non e' un test di edge** (regola di casa): conta quanto il prezzo sta vicino/lontano dalla linea e cosa fa dopo un tocco da lontano. Il test vero, col nullo a blocchi, e' `ema200_rimbalzo.py`/`ema200_d1_su_m5.py`. Tocco da lontano = low<=EMA<=high con le 20 barre precedenti tutte dallo stesso lato e almeno una a >= 1 ATR; esito entro 20 barre: **rimbalzo** = ritorna a >= 1 ATR dal lato di origine senza chiudere a >= 0,5 ATR oltre la linea; **rottura** = chiude a >= 0,5 ATR oltre; il resto ambiguo. Un evento ogni 20 barre.

| TF | barre | % sopra la EMA | serie sullo stesso lato (mediana, barre) | distanza assoluta mediana (ATR) | p90 | entro 1 ATR | tocchi per 100 barre | incroci per 100 barre | eventi (B/P/amb) | rimbalzo B/(B+P) |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|
| H1 | 5,285 | 43.6% | 4 | 2.81 | 6.94 | 21% | 10.7 | 4.6 | 63 (31/32/0) | **0.49** |
| H4 | 957 | 33.2% | 6 | 3.69 | 7.31 | 11% | 5.3 | 2.6 | 10 (3/7/0) | **0.30** |
| D1 | campione troppo corto | | | | | | | | | |
| RW (H1-like) | 39,379 | 54.3% | 4 | 3.13 | 8.01 | 17% | 8.8 | 4.8 | 410 (197/213/0) | 0.48 |

_Cosa dice_: quanto 'tiene' la EMA200 come linea e quanto il simbolo ci vive attorno. _Decisione informata_: la distanza-soglia in ATR per gli ingressi sulla EMA (cella O1/O2 del dashboard), se ha senso un limit alla linea. NON dice che rimbalzare sia profittevole.

## 9. Spread medio per ora e costo in ATR (frontiera 40 x spread)

[NON MISURATO] per questa serie: serve un file di spread (`--spread`, formato SPREAD_VIVO orario) con lo stesso simbolo. Lo spread storico del feed esterno non e' lo spread BCM.

## 10. Dove sta nel ranking (stessa finestra per tutti)

Su 11 serie della corsa, finestra 2018-01-02 -> 2018-12-28 (257 giorni): **ADR % mediano 0.893 -> posto 8 su 11** ; volatilita' realizzata annua 9.5% -> posto 8 su 11. Tabella: `ranking_volatilita.csv`.

---
_Riproducibile_: stessa serie di M1 + stesso `SCHEDA_SIMBOLO_v1` -> stessi numeri (nessun elemento casuale tranne il RW di riferimento, a seme fisso 12345)._
