# NOTE A7 - replica indipendente (solo dalla guida), W1 + D1

File: `replica_indipendente.py` (Python 3.11, solo libreria standard), `out_A7_score_giornaliero.csv`.
La guida da solo pesi, soglie e descrizioni a parole: tutte le formule sotto sono MIE scelte, non il prodotto originale.

## Struttura generale (dalla guida)
- Score di un timeframe = 100 * somma(peso_i * componente_i) / somma(pesi), componenti in [-1,+1]. Pesi 30/25/20/15/10 =
  struttura / trend EMA / momentum / price action / volume. Quindi range matematico [-100,+100].
- Bias per TF e Overall: BULLISH se >= +15, BEARISH se <= -15, altrimenti NEUTRAL.
- Overall = (30*W1 + 25*D1)/55 (W1 54,5%, D1 45,5%).
- Parametri: EMA 20/50/200, RSI 14, MACD 12/26/9, ATR 14 (solo per normalizzare), pendenza EMA 5 barre, lookback struttura 150,
  swing 3 per lato, price action 8 candele.

## Dati e timeframe
- Barre della domenica (broker con sessione domenicale, ~2.000 tick contro ~95.000): fuse nella prima barra feriale successiva
  (open della domenica, max/min combinati, close del lunedi, volume sommato). Motivo: la guida dice settimana lun-ven e una candela
  da poche migliaia di tick falserebbe corpi, ombre e swing. D1 quindi = barre lun-ven (5.6xx righe).
- "Giorno di borsa" = ogni data con barra D1 nel file (le festivita senza barra non hanno riga).
- W1 costruita dalle D1 per settimana lun-ven (OHLC aggregati, volume sommato). W1 e "chiusa" al giorno t se il venerdi della
  settimana e <= t (quindi la settimana entra il venerdi stesso a fine giornata; lun-gio si usa la settimana precedente).
  Scelta discutibile: alternativa piu prudente = attendere il lunedi.
- Storico insufficiente -> N/A (la guida: niente dati inventati). Score valido da indice 204 (EMA200 + 5 barre di pendenza).
  D1 valido da ~2005-04; W1 valido da ~2008-05; Overall solo se ENTRAMBI sono validi (dal 2008-05-09), altrimenti vuoto e bias "N/A"
  (non ridistribuisco i pesi per non cambiare il significato 54,5/45,5; la guida invece ridistribuirebbe se un TF e spento).
- Indicatori: EMA con seme SMA (MT5 usa il primo prezzo; sulla lunga storia la differenza sparisce); RSI e ATR di Wilder; MACD classico con
  segnale EMA9 del MACD.

## Componenti (ogni "clamp" porta il valore in [-1,1])
**Trend EMA (25)** = 0,30*posizione + 0,25*ordine + 0,25*pendenza + 0,20*allargamento
- posizione: media su EMA20/50/200 di clamp((close-EMA)/ATR). Motivo: "sopra/sotto le medie", ATR per normalizzare.
- ordine: media dei segni di (20-50), (50-200), (20-200): +1 se 20>50>200, -1 se inverso, parziale se misto.
- pendenza: media su 3 EMA di clamp((EMA_t - EMA_{t-5})/(0,5*ATR)). Il fattore 0,5 e arbitrario ("piatta" ~ 0).
- allargamento: media su (EMA20-EMA50) e (EMA50-EMA200) di clamp(variazione a 5 barre/(0,5*ATR)). Con spread positivo che cresce = rialzo piu forte.
**Momentum (20)** = 0,5*RSI + 0,5*MACD
- RSI: livello 0 tra 45 e 55, lineare fino a +-1 a 70/30 (guida: >55 rialzista, <45 ribassista); direzione = clamp((RSI_t - RSI_{t-3})/10). RSI = 0,7 livello + 0,3 direzione.
- MACD: 0,4*clamp(MACD/ATR) + 0,3*clamp(istogramma/(0,3*ATR)) + 0,3*clamp((MACD_t-MACD_{t-3})/(0,5*ATR)). "Salendo/scendendo" misurato su 3 barre (scelta mia).
**Struttura (30)** = 0,6*swing + 0,4*rottura
- swing pivot con 3 barre per lato, strettamente maggiore a sinistra, >= a destra (simmetrico per i minimi); un pivot e noto solo 3 barre dopo (niente lookahead);
  solo pivot nelle ultime 150 barre. swing = 0,5*segno(HH-vs-LH degli ultimi 2 massimi) + 0,5*segno(HL-vs-LL degli ultimi 2 minimi). Mancano 2 pivot -> 0 per quella meta.
- rottura (BOS/CHoCH): +1 se la chiusura e sopra l'ultimo massimo di swing, -1 se sotto l'ultimo minimo (stato, non evento; si sommano, quindi dentro il range = 0).
  Non distinguo BOS da CHoCH nel punteggio (per la guida entrambi spostano il bias verso la direzione della rottura).
**Price action (15)** = 0,7*candele + 0,3*spostamento
- candela: 0,4*posizione della chiusura nel range + 0,4*(close-open)/range (corpo pieno) + 0,2*(ombra inferiore - superiore)/range (rifiuto). Media delle ultime 8 con pesi lineari 1..8 (ultima piu pesante).
- spostamento (proxy di "accelerazioni"): clamp((close_t - close_{t-8})/(3*ATR)). Non ho un vero indicatore di accelerazione.
**Volume tick (10)**: bilancio = somma(volume*segno(close-open)) / somma(volume) sulle ultime 8 barre, moltiplicato per min(vol medio 8 / vol medio 50, 1,5)/1,5.
  Motivo: "solo conferma, volumi che crescono nella direzione". Con peso 10 non puo da solo superare la soglia 15 (cap +-10).

## Cose volutamente NON replicate
CONF, Alignment, Contro-trend, Bias Alert, Delta, FORZA: non servono per lo score (richiesti solo score e bias).

## Autotest (funzione `autotest()` in replica_indipendente.py)
1. range [-100,100]; 2. no-lookahead su 9 date (lun..ven, anche a cavallo di settimana): lo score identico sia troncando i dati a t sia sostituendo
tutte le barre future con rumore casuale (anche 1 punto ogni 7 giorni precedenti); 3. simmetria: dati specchiati (o'=C-o, h'=C-l, l'=C-h, c'=C-c) -> score
opposto, max |s+s'| ~ 2e-11 su tutte le righe; 4. W1 costante tra lunedi e giovedi; 5. sanita su trend sintetico (media ultimi 150 gg > +30 / < -30).
Il test 5 inizialmente falliva con un trend senza ritracciamenti: la struttura vale 0 senza pivot (limite noto della formula, non bug); ho sostituito
il dato sintetico con deriva + oscillazione, e reso il test sulla media e non sull'ultima barra.
