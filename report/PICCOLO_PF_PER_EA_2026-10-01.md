# Piccolo 50503392: PF per famiglia di EA dal report MT5 del 01/10/2026 06:38

Fonte: `data/statements/ReportHistory_50503392_2026-10-01.xlsx` (1.127 posizioni dal 30/04 al 30/09, commento letto dal deal di ingresso). Netto = profitto + commissioni + swap, PER POSIZIONE (le gambe parziali 1/3, 2/3 sono posizioni separate e correlate). Conto da circa 5.000 EUR: lotti piccoli, profitti piccoli.
**Cautela**: con n sotto 30 il PF e' dominato da pochissime perdite (errore standard molto grande). NON e' una graduatoria di merito.

| Famiglia | n | win % | netto EUR | PF |
|---|---:|---:|---:|---:|
| (senza commento) | 574 | 57.3 | -18344.80 | 0.74 |
| BULGE_MULTI_SIGNAL_BLU | 147 | 70.7 | -220.47 | 0.92 |
| DAX Apertura EU | 34 | 73.5 | -747.24 | 0.24 |
| ORB | 28 | 39.3 | 142.33 | 1.20 |
| EMA200 DOW | 23 | 43.5 | -54.71 | 0.68 |
| EMA200 | 22 | 50.0 | -52.08 | 0.84 |
| DAX Live 5m | 19 | 52.6 | 410.63 | 1.41 |
| DAX Apertura EU RETEST | 16 | 93.8 | 174.97 | 13.46 |
| Nasdaq Apertura US | 15 | 93.3 | 282.24 | 29.22 |
| SUPERWAVE DOW H1 | 14 | 64.3 | 333.88 | 16.29 |
| SW DOW H2 | 14 | 28.6 | -41.68 | 0.81 |
| MAXMIN ORO | 13 | 53.8 | 60.40 | 1.51 |
| BULGE_MULTI_SIGNAL_VIOLA | 12 | 58.3 | -227.54 | 0.45 |
| DAX M3 | 12 | 50.0 | -165.28 | 0.52 |
| DAX Live5m | 12 | 41.7 | -149.27 | 0.61 |
| STREV NAS H1 | 9 | 33.3 | 53.48 | 2.66 |
| COST EURJPY | 9 | 33.3 | -171.41 | 0.16 |
| Apertura Marco | 8 | 75.0 | -179.51 | 0.20 |
| STREV | 8 | 0.0 | -106.34 | 0.00 |
| COST GBPCAD | 7 | 57.1 | 47.61 | 1.60 |
| Nasdaq Live 5m | 6 | 50.0 | 206.63 | 1.74 |
| NIGHTLY | 6 | 83.3 | 295.55 | 6.29 |
| BULGE_V520_VIOLA | 6 | 100.0 | 36.26 | 99.00 |
| Londra | 5 | 20.0 | -194.16 | 0.23 |
| SUPERWAVE EA 1 | 5 | 60.0 | -22.71 | 0.38 |
| SUPERWAVE EA 2 | 5 | 20.0 | -23.22 | 0.30 |
| STREV DOW H1 | 5 | 40.0 | 42.09 | 1.81 |
| MAXMIN DAX SHORT | 5 | 100.0 | 155.78 | 99.00 |
| EASYTREND GBPUSD | 5 | 60.0 | 67.03 | 1.86 |
| EASYTREND CHFJPY | 5 | 20.0 | 15.11 | 1.25 |
| LARRY DOW | 5 | 40.0 | -1.56 | 0.98 |
| STREV FW Nik | 5 | 40.0 | 2.79 | 1.08 |
| STREV MULTI | 4 | 0.0 | -140.45 | 0.00 |
| LARRY EURAUD | 4 | 50.0 | -32.53 | 0.59 |
| GAPCONT | 4 | 25.0 | -137.91 | 0.12 |

## Letture
- **574 posizioni SENZA commento** (485 su XAUUSD, netto -17.066,92, PF 0,75): sono la parte piu' grossa delle perdite del piccolo; non sono di un EA riconoscibile dal commento (trade manuali o EA senza commento).
- **Bulge (versione vecchia BULGE_MULTI_SIGNAL, difetto del primo tick)**: BLU n=147, win 70,7%, PF 0,92; VIOLA n=12, PF 0,45. **BULGE_V520**: BLU n=4 PF 0,11; VIOLA n=6, 6 vinte su 6 (+36,26). Campione v5.20 troppo piccolo.
- **ORB Ottimizzato (commento 'ORB OTT BUY')**: n=8, 1 vinta su 8, netto -209,18, PF 0,27: da leggere insieme al forward FTMO (3 su 15 previste, -295,58) prima di metterlo sulla trial.
- **PF alti con n piccolo**: Nasdaq Apertura US n=15 PF 29; SuperWave Dow H1 n=14 PF 16; DAX Apertura RETEST n=16 PF 13,5; DAX Live 5m n=19 PF 1,41; MAXMIN ORO n=13 PF 1,51; ORB n=28 PF 1,20.
