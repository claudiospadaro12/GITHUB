# UBS manuale (40 pag.): procedura di ottimizzazione di Wim — 21/11/2026
Fonte: `ultimate-breakout-manual_1.pdf` (testo in `UBS_MANUALE_TESTO_2026-11-21.txt`, righe 310-680 = procedura, 678+ = parametri).
**L'app non è nel manuale: il manuale descrive l'ottimizzazione fatta a mano nel tester MT5 + Quant Analyzer. È replicabile.**

## Procedura (citata/sintetizzata)
1. Tester: IS **2013-2023** (OOS 2000-2012 e 2024-2025), **1 minuto OHLC** per i swing; deposito 100k; **lotto fisso 0,01** forex (0,1 oro/indici/BTC con "Adjust Lotsize to Variable Values", poi DD/10); ottimizzazione **genetica veloce**; **no forward, no delay**.
2. Criterio: "Balance max" (rischio: 1-2 vincite enormi), "Recovery factor max" (pochi trade), oppure **"Custom max"** = combinazione di n° operazioni, recovery factor (peso maggiore), expected payoff, con minimi nei parametri EA "4. Custom Optimization Settings" (righe 882-897). I minimi sono già nei set di ottimizzazione.
3. Intervalli dei parametri dai set di ottimizzazione (es. SL 30-300 pip): "ranges sbagliati = strategie da backtest che falliscono live". Non ottimizzare tutto: "rough strategies". Volatility Breakout: candela minima 20-70 pip passo 5, ATR 5-50, deviazione 1,5-3,5 passo 0,1.
4. Non usati in ottimizzazione: filtri spread, GMT/news, orari, lotto automatico, MagicTrail (serve tick reali). Si controlla dopo che news/GMT non siano la fonte dell'utile.
5. Selezione: ordinare per "Result", poi per recovery e per DD; backtest dei migliori; scegliere curve **lineari e DIVERSE** tra loro.
6. Stress: (a) **2024-25 a tick reali contro 1 minuto**: stessa forma, entrambi in profitto → 1 minuto accettabile; (b) OOS 2000-2012; (c) ri-ottimizzazione di 1-2 gruppi (SL/TP, trailing, break-even) e ripetizione di (a),(b); (d) altro simbolo/TF correlato (non devono essere orribili).
7. Portafoglio: Quant Analyzer, scegliere solo uno tra curve simili; "max risk per strategy" fisso; confronto live/backtest nelle settimane dopo.
8. Dati: Wim usa MetaQuotes demo per forex/oro, IC Markets per indici ("MetaQuotes non abbastanza buono").

## Differenze con noi
- Il manuale non dà soglie numeriche di accettazione (quelle 0,7/0,5/1,5 sono del video dell'app). Le nostre soglie pre-registrate restano.
- Wim ottimizza 2013-2023 e verifica 2000-2012: per forex BCM serve controllare lo storico disponibile prima del 2013.
- "Custom max" è dentro l'EA: funziona nel tester MT5 senza l'app.
