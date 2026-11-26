# ABTG_MeanRevert v1.00 (A2) - sorgente: ABTG_MeanRevert.mq5, 379 righe
Tag: FV = FATTO_VERIFICATO (file:riga), INF = INFERENZA, DV = DA_VERIFICARE. Nessun file del sorgente contiene istruzioni per l'agente.

## Regole (FV)
- TF H1, lookback 200 barre, rischio 1%, lati separabili, magic 773101, commento "MREV" (r.42-52).
- Una decisione per nuova barra (r.185-187); una sola posizione per simbolo+magic (r.95-107, 193).
- Segnale: la barra chiusa [1] e' il minimo (long) o il massimo (short) delle ultime 200 barre chiuse (r.197-208); se e' entrambe le cose, nessun trade (r.211).
- Ingresso a mercato al primo tick della barra nuova (r.227-228, 247-248). TP = centro del range (r.231); SL = specchio rispetto all'ingresso, quindi R:R 1:1 (r.232). Nessun segnale se il TP e' gia' superato (r.235-236).
- Lotto: il piu' grande che sta dentro 1% del saldo, con OrderCalcProfit e controllo margine (r.113-154). Controllo stops level (r.159-166).
- Nessun orario, nessun filtro, nessuna uscita a tempo. Uscite solo SL/TP.

## Controlli R2
Barra in formazione: NO (shift 1..N, r.197-202). Orari/ora legale: NON APPLICABILE (nessun input orario). Distanze: scalate sul range, non punti fissi (r.204, 231-232). Nuova barra: SI (r.185-187). Stop minimo broker: SI, ma misurato dall'ingresso e non da bid/ask (r.164-165). Spread: filtro opzionale, spento di default (r.50, 221-225). Ordine rifiutato: solo contatore e log, nessun nuovo tentativo (r.256-259). Magic/commento: SI (r.51-52, 83). Dati futuri: NO.

## Difetti
1. media (non falsa il test, falsa il profilo prop): nessuna uscita a tempo, nessuna chiusura a fine settimana (r.238-248). Con TP al centro di un range di 200 barre H1 la posizione puo' durare giorni: swap e gap di weekend sono nel risultato. Su BCM il long costa: oro circa -9,7%/anno, indici 10-14% (CLAUDE.md); il tester li modella, il confronto va letto lordo e netto.
2. media: nessun tetto giornaliero e nessun Guardian. `gWorstDayPct` (r.171-182) e' solo diagnostica. In un trend forte i nuovi estremi consecutivi riaprono la stessa scommessa contro-trend dopo ogni stop, ognuna al 1%.
3. minore: se il lotto minimo supera il budget, lo si usa lo stesso (r.136), quindi rischio sopra il dichiarato; su conto 100.000 EUR di solito non succede.
4. minore: nessun `SetDeviationInPoints` (grep: assente; DV il valore predefinito di CTrade). SL/TP calcolati su ask per il long ma colpiti sul bid.
5. minore: reset giornaliero con `day_of_year` sul tempo server (r.176): per un conto prop il giorno si azzera in un altro orario.
6. INF: il segnale e' frequente. Su una camminata casuale l'ultima barra e' il minimo di 200 con probabilita' dell'ordine del 4% per lato (legge dell'arcoseno), quindi si apre un trade ogni poche decine di barre appena la posizione e' libera. Non e' un setup raro.

## Mediazione / griglia (rischio prop)
NO: una sola posizione (r.193), SL fisso al broker, nessun incremento, nessuna media al ribasso, nessun martingale. E' pero' una strategia anti-breakout: opposta alla Donchian, che sui 17 mercati D1 e' gia' chiusa senza vantaggio (CLAUDE.md).

## Misurabilita'
Nessun orario: i dati `_EXT` degli indici (2010-2026) sono utilizzabili, perche' qui conta solo l'OHLC; spread=0 in quei file, quindi costo fisso da aggiungere. Forex BCM M1 (2005/2013-2026 secondo il simbolo, DV per simbolo), oro FTMO (scartare la riga 00:00 con tickvol>2000), Bitcoin FTMO 2016-2026. In ogni barra H1 va risolto con M1 se SL e TP cadono insieme (come nel test `ema200_rimbalzo_m1.py`). Nessun backtest esiste nello zip.

## Ipotesi (criteri scritti prima dei numeri; soglie dei cancelli della campagna: IS PF >= 1,30, OOS >= 1,20, hold-out > 1,0, anni positivi >= 60%)
- H1 baseline cosi' com'e' (H1, 200 barre, 1%): 28 cross forex + oro + 3 indici, IS / OOS / hold-out con costi reali. Accetta se IS PF >= 1,30 con >= 300 trade, OOS >= 1,20, HO > 1,0 su almeno 60% delle celle. Probabilita' di passare: 4%.
- H2 plateau del lookback pre-registrato {50, 100, 200, 400}: accetta solo se >= 3 su 4 hanno PF > 1,10 in IS e OOS con lo stesso segno. Probabilita': 3% (dipende da H1).
- H3 solo long su oro e indici (l'input esiste, r.47): accetta se PF long >= 1,30 anche dopo aver tolto il drift (confronto con tenere sempre il long, swap incluso). Probabilita': 6%; il rischio principale e' che sia solo deriva rialzista del campione.

## Classe: A (misurare subito)
Nessun difetto "falsa i test" nella logica; difetti 1-2 si leggono come costi e rischio. Prima probabilita' bassa: costo di misura contenuto (replica Python su H1 + M1 per i casi ambigui).
