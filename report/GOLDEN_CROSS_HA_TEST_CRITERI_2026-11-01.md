# Golden Cross HA (MASTERCLASS ABTG v1.0, 01/07/2026) sull'oro: criteri e previsioni scritti PRIMA dei numeri (01/11/2026)
Non controllata da agenti. Richiesta di Claudio: "facciamo il test della strategia Golden Cross HA" (PDF `Piano Trading - GOLDEN CROSS HA Strategy 1`). Nessun parametro e ottimizzato: le soglie sotto sono la traduzione in numeri delle regole del PDF, decise qui prima di guardare i risultati; le tre ambiguita piu pesanti (stoppino, pendenza, stop) sono dichiarate.

## Dati e metodo
Barre M1 BCM dell oro con spread, esportate dal tester: **2013, 2018, 2020 e 2025-2026 (gen 2025 - ott 2026)**; gli anni 2005-2012 e gli altri non sono disponibili in questa sessione (servirebbe un nuovo export). Test in Python (`backtest_pipeline/golden_cross_ha_test.py`): le barre H1 e M15 si costruiscono dalle M1; i segnali si valutano alla chiusura della barra, l ingresso e all apertura della barra successiva (M1) con lo spread pagato; i trade si simulano minuto per minuto; se SL e TP cadono nello stesso minuto si assume lo SL (conservativo). Nessuno slippage. Rischio misurato in R (distanza dallo stop); curva a rischio 1% composto come illustrazione.

## Regole tradotte in numeri
- **Long** (short speculare): chiusura > EMA9 > EMA21 > EMA50; EMA50[i] >= EMA50[i-3]; EMA9[i] > EMA9[i-2] e EMA21[i] > EMA21[i-2]; incrocio rialzista EMA9/EMA21 avvenuto nelle ultime 6 barre.
- **Heiken Ashi:** le ultime 3 candele HA sono rialziste, stoppino inferiore <= 10% del corpo HA, corpo non in riduzione (corpo[i] >= 0,9 x corpo[i-1] >= 0,81 x corpo[i-2]).
- **ADX(14)** >= soglia (20 o 25), ADX[i] >= ADX[i-1] - 0,5, DI+ > DI-.
- **Distanza:** chiusura - EMA21 <= 1,0 ATR(14) (ingresso solo diretto, nessun pullback in questa versione: scelta che il PDF permette ma non impone).
- **Stop:** minimo delle ultime 3 barre - 0,1 ATR; trade scartato se la distanza dallo stop e < 0,3 ATR o > 2 ATR. **Target:** k x R, k in {1, 1,5, 2}. Nessun break even, nessun trailing (il PDF dice "valutare").
- **Limiti del PDF:** una posizione alla volta, massimo 2 trade al giorno, stop per il giorno dopo 2 perdite consecutive.

## Varianti (12, decise ora)
Timeframe H1 e M15 x ADX 20 e 25 x target 1R, 1,5R, 2R. **Variante principale: H1, ADX 25, 1,5R.** Con 12 varianti il rischio di trovarne una bella per caso e alto: si riportano tutte, non solo la migliore.

## Criteri di accettazione (variante principale e tutte)
Profit factor **dopo lo spread** sui 4 periodi insieme >= 1,15; netto positivo in almeno 3 periodi su 4; almeno 100 operazioni in totale. Per dire "promettente" servono tutti e tre; ma anche allora resta da fare il test in avanti.

## Previsioni (probabilita)
- **G1** almeno 100 operazioni nella variante principale: **70%**.
- **G2** profit factor >= 1,15 sui 4 periodi insieme (variante principale): **15%**; fra 1,0 e 1,15: **35%**; sotto 1,0: **50%**.
- **G3** netto positivo in almeno 3 periodi su 4 (variante principale): **25%**.
- **G4** win rate sotto il 45% con target 1,5R (variante principale): **80%**.
- **G5** almeno una delle 12 varianti raggiunge PF >= 1,3 sui 4 periodi: **20%** (e sarebbe da guardare con sospetto: scelta fra 12).
- **G6** le varianti M15 hanno PF piu bassi delle H1 a parita di ADX e target (almeno 4 confronti su 6): **75%**, perche lo spread pesa di piu su R piccole.
- **G7** il periodo migliore e il 2025-2026 (rialzo forte dell oro): **60%**.

## Cosa NON dice
Solo 4 periodi (2013, 2018, 2020, 2025-26) e un percorso per periodo; dati M1 (spread medio dell ora d apertura, nessuno slippage); regole interpretate da me; non include il giudizio discrezionale ("spazio tecnico", "news", "congestione"), che il PDF considera parte della strategia. Un risultato negativo qui non esclude una versione discrezionale; uno positivo non e un conto reale. Nessun giudizio su acquisti, lotti o taglie.
