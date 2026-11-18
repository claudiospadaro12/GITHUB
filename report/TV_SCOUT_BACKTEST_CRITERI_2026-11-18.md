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

## ERRORE DI DATI SCOPERTO E CORRETTO (18/11/2026, prima di scrivere i verdetti)
Nei CSV M1 dell'**oro FTMO** esiste una riga "aggregata" alle **00:00** di ogni giorno (tickvol enorme, spread 0, prezzi falsi: es. 11/08/2020 00:00 `high 2030, low 1901,29, close 1911,20`, poi la barra successiva riparte da 2026,64). Quella riga produce uno spike finto di -116 / +117 dollari in H1 (autocorrelazione lag-1 dei rendimenti H1 -0,335 con la riga, +0,001 senza). **Scartata nel caricamento** (`tickvol > 2000` alle 00:00). EURUSD praticamente non cambia (1 barra su 38.265); l'oro cambia tutto.
**Conseguenza: il risultato "CHoCH di swing sull'oro: 45 operazioni, R +0,89, PF 3,46" scritto in `SMC_LUXALGO_TEST_CRITERI_2026-11-18.md` era un ARTEFATTO dei dati ed e RITIRATO.** Con dati puliti: CHoCH oro 7 operazioni (R +0,69, non valutabile), order block interni oro 856 operazioni R -0,061 PF 0,92, order block di swing 58 operazioni R -0,163. Anche il Supertrend sull'oro in prima lettura (PF 3,79, R +1,04) era falso. Ricontrollati con dati puliti anche i test Python su EURUSD per Bulge (replica, F5, Pine semplice, port Breaking Band): numeri identici. I test MT5 su BCM non sono toccati.

## Risultati con dati puliti (`backtest_runner/simulatore/tv_scout_backtest.py`; in-sample = fino al 27/02/2019, out-of-sample = dopo)
| Strategia | Mercato | IS operazioni | IS R netto | IS PF | IS DD | OOS operazioni | OOS PF | Filtro IS (PF>=1,5, DD<=15%, >=100) |
|---|---|---|---|---|---|---|---|---|
| S1 Supertrend (10;3) | EURUSD | 658 | +0,059 | 1,14 | 24,5% | 288 | 1,05 | NO |
| S1 Supertrend (10;3) | XAUUSD | 631 | -0,042 | 0,91 | 35,2% | 222 | 1,73 | NO (IS < 1) |
| S2 Breakout 4 barre, SL 2 ATR / TP 4 ATR | EURUSD | 1.078 | -0,014 | 0,98 | 47,7% | 454 | 1,00 | NO |
| S2 Breakout 4 barre, SL 2 ATR / TP 4 ATR | XAUUSD | 949 | -0,027 | 0,96 | 45,1% | 373 | 1,16 | NO |
| S3 CHoCH LuxAlgo | XAUUSD | 7 in 6 anni | n.d. | n.d. | | | | NO (< 100) |
**Griglie in-sample:** Supertrend (ATR 7-21 x moltiplicatore 2-4): EURUSD PF massimo 1,19 (14;3), oro massimo 0,93; Breakout (lookback 4-50 x SL 1-3 ATR): EURUSD massimo 1,03, oro massimo 0,99. **Nessuna cella arriva a 1,5 e nessun plateau con PF > 1,3: nessuna ottimizzazione eseguita** (sarebbe adattamento al rumore). Il PF 1,73 del Supertrend oro in out-of-sample (222 operazioni, t 2,3) e un'oscillazione del solo periodo 2019-2020 (rialzo dell'oro): in-sample lo stesso sistema perde.
**Verdetto con le regole scritte: nessuna strategia VALIDATA, nessun Pine finale.** Previsioni: nessuna validata (90%) -> si; Supertrend PF in-sample < 1,2 su entrambi (80%) -> si; Breakout R netto < 0 su EURUSD (85%) -> si; cella con PF in-sample >= 1,5 (35%) -> **no**.
**Controllo placebo (prima del taglio dei dati):** permutando a caso le barre dell'oro il Supertrend dava PF 0,78-1,10: il codice non guarda il futuro; il vantaggio apparente veniva dai dati.
