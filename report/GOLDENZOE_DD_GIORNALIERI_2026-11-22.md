# GoldenZoe: drawdown giornalieri e totali, ultimi 4 anni (22/11/2026)
Simulatore (`backtest_runner/simulatore/goldenzoe_dd_giornalieri.py`), oro FTMO M1 dal 22/11/2022 al 18/11/2026, EA base (canale 55, stop 3 ATR, Chandelier 3 ATR, solo acquisti), conto 80.000, capitale composto, equity ai minimi di ogni minuto (perdita flottante inclusa), costi FTMO (0,35 USD + swap 5,5% annuo). 76 operazioni.
Definizioni: **DD giornaliero** = (equity a inizio giornata - minimo di equity della giornata) / 80.000, giorno del server; **DD totale statico** = (80.000 - equity minima) / 80.000; **DD massimo dal picco** = (picco - equity) / 80.000. Un "episodio" e un superamento della soglia, riarmato quando il DD torna sotto meta soglia.
| Rischio per operazione | DD giornaliero massimo | Giorni >= 1% / 2% / 3% / 4% / **5%** / **10%** | DD massimo dal picco | Episodi dal picco >= 5% / 10% | DD statico minimo-conto | Rendimento finale |
|---|---|---|---|---|---|---|
| 0,45% (PROP) | 0,50% | 0 / 0 / 0 / 0 / **0** / **0** | 2,65% | 0 / 0 | 0,58% | +12,8% |
| 0,90% (MEDIO) | 1,07% | 4 / 0 / 0 / 0 / **0** / **0** | 5,97% | 1 / 0 | 1,16% | +26,9% |
| 1,00% (EA di default) | 1,22% | 9 / 0 / 0 / 0 / **0** / **0** | 6,80% | 1 / 0 | 1,29% | +30,2% |
| 1,50% (ALTO) | 2,10% | 63 / 1 / 0 / 0 / **0** / **0** | 11,57% | 7 / 1 | 1,93% | +47,7% |
Giorno peggiore: 24/02/2026 (1,0% e 1,5%), 08/07/2024 (0,45% e 0,9%). Serie giornaliera a 1%: `GOLDENZOE_DD_GIORNALIERI_dati_1pct.csv`.
**Limiti:** costi FTMO (con swap BCM il rendimento scende); 76 operazioni; fuso del giorno = server dei dati; l'oro e salito; il drawdown futuro puo essere maggiore; il simulatore non conosce spread e slittamenti reali. I rischi 0,45/0,90/1,50 corrispondono alle stime provvisorie dei set: il simulatore da' massimi dal picco 2,65% / 5,97% / 11,57% (obiettivi 3 / 6 / 10): il tester BCM li rifinisce.
