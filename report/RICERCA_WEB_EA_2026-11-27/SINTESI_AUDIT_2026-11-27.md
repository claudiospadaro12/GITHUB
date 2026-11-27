# Sintesi e audit ricerca web EA scorrelati dall'oro (27/11/2026)
Fonti: agente1_mql5.md, agente2_forum_set.md, agente3_github_quant.md. Tutti i numeri sono DICHIARATI dagli autori, nessuno verificato da terzi; nessun file scaricato o eseguito. Punteggi (1-5) miei, confrontati col registro delle prove nostre (CLAUDE.md, REGISTRO_UNICO). Nessun consiglio di acquisto: decide Claudio.

## A. Da testare con i NOSTRI criteri (famiglie non ancora misurate)
| # | Strategia | Asset/TF | Logica | Scorr. oro | Idoneita prop | Fonte |
|---|---|---|---|---|---|---|
| 1 | Intraday momentum: rendimento prime 30 min predice ultime 30 min | Indici, 30 min | Entra a fine sessione nella direzione del mattino, chiude in chiusura | 5 | 4 | paper Gao-Han-Li-Zhou (PDF mql5 forextsd) |
| 2 | GER40 Evening Coil | DAX H1 | Compressione serale, solo long, SL 3,5 ATR / TP 4,5 ATR; sorgente gratuito (regole leggibili) | 4 | 3 | mql5.com/en/code/78380 |
| 3 | RTH Gap fade | Indici/futures M1 | Fade del gap di apertura, MIT, nessun risultato | 5 | 4 | github.com/Dax-giant/RTH_Gap_Backtesting |
| 4 | IBS D1 / Monday Dip | Indici D1 | Chiusura bassa nel range -> long 1-3 giorni, stop 10% | 4 | 3 | mql5.com/en/code/78343 (+ script TradingView) |

Note di test: dati BCM indici solo 2024-26 (DAX), `_EXT` Nasdaq/S&P 2010-26 ma con orari non GMT+1 fisso (diagnostica); FTMO feed tester rotto. Costo swap long indici BCM 10-14% annuo (pesa solo sul punto 4). Soglie campagna non abbassate.

## B. Gia' CHIUSI da noi (non ritestare)
ORB (First Five Breakout US100, ORB EA V2 Samson, orb-mt5, Viking Alpha DAX), RSI(2) US500 M30, Turn of the Month, overnight drift, EURGBP z-score+ADX (OOS PF 0,96 dichiarato dall'autore), Asian range fade (famiglia notte/Bartiromo).

## C. Non valutabili o fuori mandato
- Codice chiuso e parametri non pubblici: Band Reversion AUDNZD (PF 1,34, 268 op/10 anni, ~0,9% annuo), Apex Origin (gratuito, set solo dall'autore), Linear Regression MR PRO, OrdinalEdge USDJPY, DAX Quant Range, Spring Break (logica ignota). Solo provabili come demo nel tester, senza poter verificare SL/griglia.
- Scartati: Nasdaq Dip Buyer (54 operazioni), ZoneUS30 (dipende dallo swap), Janus (modulo oro), Scalp IC (XAU), Argus (DD 36%), mt5-tps-sample-ea (averaging senza stop), Global Session Trading (nessun backtest).

## D. Limiti della ricerca
ForexFactory 403, Reddit, Myfxbook, EarnForex, FXBlue, QuantifiedStrategies non raggiungibili. Nessun EA con regole pubbliche su EURCHF/GBPCAD/AUDCAD. Per i cross forex nessuna strategia con fuori campione positivo (coerente con le nostre chiusure).
