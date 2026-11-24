# GoldenZoe: r² della curva (linearita) - aggiunta ai report (24/11/2026)
Spunto: la validazione di Till (chat UBS) usa l'r² della curva come misura di regolarita: soglia 0,93 per i suoi migliori set sull'oro. Qui e **solo un riferimento**, non un cancello nostro. Script `backtest_runner/simulatore/goldenzoe_r2.py`; uscita `GOLDENZOE_R2_dati_2026-11-24.txt`. Oro FTMO M1, costi FTMO, conto 80.000, un trade alla volta (stessa catena di segnali dei report del 22/11).
**Definizione:** r² di una regressione lineare tra il numero progressivo dell'operazione (o il tempo) e (a) il saldo composto, (b) il logaritmo del saldo, (c) il P&L cumulato a rischio fisso (non composto). 1,000 = retta perfetta.
| Finestra | Rischio | Trade | Rend. finale (composto) | r² saldo vs n. | r² ln(saldo) vs tempo | r² P&L non composto |
|---|---|---|---|---|---|---|
| dal 2015 | 0,5% | 207 | +24,0% | 0,870 | 0,866 | 0,881 |
| dal 2015 | 0,9% | 207 | +46,2% | 0,860 | 0,862 | 0,881 |
| dal 2015 | 1,3% | 207 | +71,5% | 0,850 | 0,859 | 0,881 |
| ultimi 4 anni | 0,5% | 76 | +14,3% | 0,902 | 0,931 | 0,896 |
| ultimi 4 anni | 0,9% | 76 | +26,9% | 0,906 | 0,931 | 0,896 |
| ultimi 4 anni | 1,3% | 76 | +40,5% | 0,909 | 0,931 | 0,896 |
**Lettura:** su 12 anni la curva e abbastanza regolare (0,85-0,88) ma **sotto il 0,93** che Till chiede ai suoi set migliori; sugli ultimi 4 anni sale a 0,90-0,93 perche l'oro e salito in modo piu continuo. **Il rischio per operazione cambia poco l'r²** (scala la taglia, non la forma). **Per anno l'r² e instabile** (da 0,01 a 0,90, con 11-28 operazioni all'anno): con cosi pochi trade non e una misura da usare su un singolo anno. Dato che l'EA fa circa 17 operazioni l'anno, la regolarita va letta sui periodi lunghi.
Anche `ea_analyzer` (comando `struttura`) stampa ora `r2_curva_saldo` per qualunque report del tester MT5 (esempio: il test di GoldenZoe 2024-2026 sul tester FTMO, 60 operazioni, r² 0,751).
