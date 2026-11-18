# TV_SCOUT (zip parziale del 18/11): audit e backtest — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Zip ricevuto: **solo 3 script con codice esatto** (stato parziale dichiarato dall'estensione): 11 Supertrend (Kivanc Ozbilgic, Pine v4, indicatore), 15 e 16 Breakout Range Long/Short (HPotter, Pine v1, indicatori di 4 righe: nessuna uscita, nessuno stop). Gli altri 4 salvati ma non esatti (indentazione persa) e non inclusi; i restanti link non ancora aperti. Pipeline completa applicata a questi 3, piu il CHoCH di LuxAlgo gia visto.
## Audit anti-repainting (dal codice)
- Supertrend: nessun `request.security`, `lookahead`, pivot. Il segnale usa `close` e valori della barra precedente: stabile a barra chiusa; in tempo reale ricalcola a ogni tick finche la barra e aperta (flip possono sparire): **usare solo a barra chiusa**. Pulito.
- Breakout Range: `high > highest(high,4)[1]`: nessun futuro; il segnale e vero appena il massimo supera i 4 massimi precedenti (intrabar); a barra chiusa e stabile. Pulito.
## Test
- **Dati:** EURUSD e XAUUSD H1, 2014-11 / 2020-12 (CSV M1 FTMO in sessione). **In-sample = primo 70% delle barre (circa 2014-11 / 2019-02), out-of-sample = ultimo 30% (circa 2019-03 / 2020-12).** Costi all-in per operazione (spread + commissione + slippage): **EURUSD 1,0 pip, XAUUSD 0,35 USD**, sottratti in R (costo / rischio iniziale).
- **Metriche:** R medio, PF (sulle R), win rate, operazioni, **drawdown % con rischio 1% per operazione composto**, t. Ingresso sempre all'apertura della barra successiva al segnale.
- **S1 Supertrend** (stop-and-reverse, sempre in mercato): baseline (ATR 10, moltiplicatore 3, hl2, ATR di Wilder). Rischio iniziale = distanza dalla linea di supertrend all'ingresso. Ottimizzazione SOLO in-sample: periodo ATR {7,10,14,21} x moltiplicatore {2,2.5,3,4}.
- **S2 Breakout Range 4 barre** (long e short insieme, una posizione alla volta): il codice non ha uscite, quindi **uscite NOSTRE e fisse**: SL = 2 x ATR(14), TP = 4 x ATR(14) (RR 2). Ottimizzazione SOLO in-sample: lookback {4,8,12,20,30,50} x SL {1,1.5,2,3} ATR (TP = 2 x SL).
- **S3 CHoCH di swing (LuxAlgo)**, oro: size del pivot {30,40,50,60,70}, RR {1,2,3}. Solo oro (su EURUSD < 10 operazioni).
- **Plateau:** i parametri scelti devono avere i vicini della griglia (uno scalino per parametro) con PF in-sample > 1,3. **Si sceglie il centro del plateau piu alto, non il picco.** Poi si valuta una volta sull'out-of-sample.
## Porte (di Claudio, nessuna ritoccata)
**Filtro in-sample: PF >= 1,5, drawdown <= 15%, >= 100 operazioni.** Una strategia e **VALIDATA** se supera il filtro in-sample E sull'out-of-sample ha PF > 1,2 e R medio > 0 con almeno 30 operazioni. Altrimenti NON VALIDATA. Nessuna strategia viene "salvata" a posteriori.
## Previsioni
- Nessuna strategia validata su nessun mercato: **90%**.
- Supertrend baseline: PF in-sample < 1,2 su entrambi i mercati: **80%**.
- Breakout Range 4 barre baseline: R medio netto < 0 su EURUSD: **85%**.
- L'ottimizzazione porta almeno una cella con PF in-sample >= 1,5: **35%**; quella cella tiene l'out-of-sample (PF > 1,2): **8%**.
## Limiti
Un solo periodo di 6 anni, due mercati, H1 senza tick; uscite del Breakout scelte da noi; Supertrend e Breakout sono indicatori classici (non ci si aspetta un vantaggio). Con 3 script la "ricerca" non e avvenuta: il risultato vale per questi tre.
