# UBS (oro D1, forex D1) contro GoldenZoe: correlazione del P&L realizzato (26/11/2026)

**Metodo:** P&L realizzato ordinato per data di uscita, 2021-06-01 -> 2026-10-31 (periodo comune: dati oro FTMO dal 2021, R1/R1b a 1 minuto 2020-26). GoldenZoe = ricostruzione dalle regole (breakout 55 barre H4, stop 3 ATR con chandelier, solo long), 1% di rischio, in R-multipli: NON e' il simulatore di produzione. Set UBS: deal chiusi dei report R1/R1b (oro D1: 13 set sommati; forex: famiglie sommate per simbolo). Script: `backtest_pipeline/ubs_corr_goldenzoe.py`.

| Serie | Mensile (65 mesi) vs GoldenZoe | Trimestrale (23) vs GoldenZoe | vs rendimento oro (mensile) |
|---|---|---|---|
| UBS oro D1 | **0,30** | **0,29** | 0,18 |
| USDJPY | -0,00 | 0,07 | -0,09 |
| EURUSD | 0,07 | 0,11 | -0,06 |
| GBPUSD | 0,21 | -0,10 | 0,20 |
| EURJPY / GBPJPY / AUDUSD / NZDUSD | da -0,20 a 0,13 | da -0,27 a 0,13 | |
GoldenZoe vs rendimento mensile dell'oro: 0,58. Settimanale: tutte le correlazioni UBS-GoldenZoe fra -0,12 e 0,13 (singoli set oro da -0,06 a 0,13); fra famiglie UBS il massimo e' EURUSD-GBPUSD 0,28.

## Lettura e limiti
- **Sotto la soglia 0,5** per tutte le serie: la previsione P4 (correlazione oro UBS-GoldenZoe > 0,5, probabilita' 80%) era SBAGLIATA. Probabilmente perche' il motore UBS opera long e short e con ordini stop/target, non e' un inseguitore di trend come GoldenZoe; la sua correlazione con il rendimento dell'oro e' 0,18 (GoldenZoe 0,58).
- **Il P&L realizzato per data di uscita sottostima la correlazione di sistemi con poche operazioni** (GoldenZoe ~18 trade l'anno): la misura buona e' la curva dell'equity a mercato (non disponibile qui). Il campione e' corto (65 mesi) e GoldenZoe e' ricostruito.
- Correlazione bassa non dimostra un vantaggio: dimostra che, se esiste, diversifica.
