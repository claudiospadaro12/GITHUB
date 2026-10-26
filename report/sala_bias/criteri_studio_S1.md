# Studio S1 - il bias dei timeframe alti (W1 + D1) prevede il movimento dell'oro? CRITERI scritti PRIMA di ogni numero (26/10/2026)
**Congelato dal coordinatore C0 prima che qualunque agente veda dati o produca numeri.** Una modifica successiva e ammessa solo come nuova decisione Dxxx con motivo, e il verdetto resta quello scritto qui.

## Domanda
La replica del bias (solo W1 e D1, pesi originali 30/25 riportati a 100% come la guida prevede quando si spegne un timeframe: **W1 54,5% e D1 45,5%**) calcolato a candele chiuse prevede il rendimento futuro dell'oro **meglio del caso e meglio della deriva incondizionata**?

## Dati e calcolo
Barre D1 BCM `data/prezzi/XAUUSD_D1_BCM_2004-06-11_2026-10-21.csv` (VERIFICATO nel repo). Barre W1 costruite dalle D1 (settimana = lunedi-venerdi per data, ora del server). Periodo di studio **2005-01-03 / 2026-10-16** (le prime barre servono da riscaldamento per EMA 200 su W1: circa 4 anni; i numeri si leggono dal **2008-07-01**, quando EMA 200 W1 esiste davvero: i mesi precedenti NON entrano nelle statistiche). Il bias a fine giorno t usa solo barre chiuse fino a t (D1) e fino all'ultima settimana chiusa (W1).
Stati dell'Overall (score -100..+100): **BULLISH** se >= +15, **BEARISH** se <= -15, altrimenti NEUTRAL (soglia della guida); **forte** se |score| >= 50 (soglia scelta qui, scritta ora). Si studiano le due definizioni: (a) segno con soglia 15; (b) segno con soglia 50.

## Misura
Ingresso all'**apertura del giorno t+1**, uscita alla chiusura del giorno t+h, con h = **5** e h = **20** giorni di borsa. Rendimento semplice. Nessun costo (orizzonte giornaliero, spread dell'oro trascurabile contro 5-20 giorni): lo scrivo.
Per ogni stato: numero di osservazioni, rendimento medio, % di esiti positivi. **Spread = media(BULLISH) - media(BEARISH)**. **Eccesso sul drift** = media dello stato - media di tutti i giorni (stesso orizzonte).
Per evitare sovrapposizioni, la significativita si calcola su **campioni non sovrapposti** (un'osservazione ogni h giorni, con 5 offset diversi si riporta la mediana dei t).

## Criteri (devono valere TUTTI per dire "il segnale ha un vantaggio misurabile")
1. Spread > 0 sull'intero periodo **per entrambi gli orizzonti (5 e 20 giorni)** e per entrambe le definizioni (a) e (b).
2. **t-statistica >= 2,0** (campioni non sovrapposti, mediana dei 5 offset) dello spread sull'orizzonte 20 giorni, definizione (a).
3. Lo spread e > 0 in **entrambe le meta cronologiche** (2008-07/2016-12 e 2017-01/2026-10).
4. Lo spread e > 0 in almeno il **60% degli anni solari** con almeno 8 osservazioni per stato.
5. BULLISH batte la deriva incondizionata (eccesso sul drift > 0) **e** BEARISH e sotto la deriva (eccesso < 0), sull'orizzonte 20 giorni, definizione (a).
Per regime (anno LONG/SHORT/LATERALE definito come per gli EA: rendimento annuo, pool di tutti gli anni 2009-2025: LONG >= +10%, SHORT <= -5%, altrimenti LATERALE) si **riporta** lo spread, senza criterio di accettazione (campioni piccoli).
Se anche uno solo dei criteri 1-5 manca: **"nessun vantaggio dimostrato"**, e l'EA non si propone sulla base di questo segnale. Se valgono tutti: **"vantaggio misurabile sui soli timeframe alti, nella replica"**, con i limiti sotto.

## Cosa NON dice (dichiarato ora)
Replica non uguale all'originale (formule non note); solo W1+D1: il quadro a cinque timeframe (con H4, H1, M15) resta da studiare dopo l'export M1; solo oro, solo un periodo di 18 anni con deriva positiva forte (gli stati BULLISH saranno piu frequenti): per questo il confronto e con la deriva incondizionata e non con zero; nessun costo di transazione modellato; nessuna conclusione su un EA.

## Previsioni dichiarate ORA (C0)
- P1: spread > 0 a 20 giorni sull'intero periodo: 60%.
- P2: **tutti** e cinque i criteri soddisfatti: 20%.
- P3: BULLISH ha un eccesso sul drift > 0: 50%.
- P4: lo spread e positivo in 6 anni su 10 o piu: 50%.
- P5: il punteggio dei timeframe alti e positivo (BULLISH) in oltre il 55% dei giorni dal 2008-07 (gli anni di rialzo prevalgono): 75%.

## Verifica indipendente prevista
Una seconda implementazione scritta da un agente (A7) **solo dalla guida**, senza vedere il codice di A4: si confrontano i segni degli stati su tutti i giorni. **Accordo sul segno >= 85%** dei giorni per accettare la replica come "ragionevole"; sotto, il verdetto di S1 si riporta con la dicitura "la replica dipende dalle scelte di implementazione" e si studiano entrambe.
