# "Dove sono i PF sopra 1? Perche' non vincono?" -- FTMO 541452707, 30/09/2026

Fonti: `data/statements/FTMO_541452707_cronistorico_2026-09-30.xlsx` (forward), `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_772501.csv` (per-trade della cella di 770101, R47a OOS, 270 deal = 193 posizioni). Calcolo riproducibile (bootstrap con seme 7, 200.000 estrazioni).

## 1. Il PF forward (flotta, senza le manuali): 0,31
11 posizioni: vincite 2.013,92 contro perdite 6.514,85. Su 11 operazioni il PF non vuol dire niente (soglia di casa: 20 per famiglia).

## 2. I PF sopra 1 sono nel BACKTEST (contratti)
DAX Apertura 770101: PF OOS **1,397**, 193 posizioni (R47a) - MaxMin DAX short 770411: OOS 2,16 su 14 posizioni - EMA200 Dow: PF 1,52 su 517 deal - Dow 770202: 1,27 (cifre dai contratti in `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` e `report/R246*`).

## 3. Il forward e' COMPATIBILE col backtest (DAX Apertura, 5 posizioni forward)
Distribuzione del backtest (R = mediana delle perdite = 1.086 EUR): vince il **74%** delle posizioni (143 su 193), vincita mediana **+0,27 R**, 36% delle vincite sotto +0,15 R, 82% delle perdite a -0,9 R o peggio, **valore atteso +0,086 R per posizione**, il 66% del profitto lordo viene dal 20% delle posizioni (vincite >= +0,5 R).
Forward: 4 vincite da +0,03/+0,06 R e 1 stop a -1,01 R = **-0,815 R**.
Bootstrap sul backtest: con 5 posizioni la somma e' **<= -0,815 R nel 21% dei casi** e **negativa nel 39%**. Quindi il forward non contraddice il backtest: e' un campione corto.

## 4. Il problema vero e' la VARIANZA contro il margine
Valore atteso +0,09 R, scarto tipico ~0,6 R per posizione: per vedere il vantaggio serve dell'ordine di **200 operazioni**. Il conto ha margine per ~0,7 R (997 EUR su ~1.450 EUR di R) prima del muro FTMO: il vantaggio non ha il tempo di emergere. E' un problema di taglia rispetto al vantaggio, non prova che le sedie "non vincano".

## 5. Cosa NON si puo' concludere
- Che il backtest sia vero: l'errore standard del valore atteso (~0,6/radice(193) = 0,043 R) lascia +0,086 R a circa 2 sigma: vantaggio MARGINALE anche nel backtest, con IS/OOS, selezione e feed BCM invece di FTMO ancora da pesare.
- Nulla sulle altre sedie (nessun per-trade di backtest confrontato qui).
