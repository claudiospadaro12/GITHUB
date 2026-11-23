# Terzo EA: valore relativo D1 su coppie (mean reversion del rapporto) - CRITERI scritti PRIMA dei numeri (23/11/2026)
Perche: serve un EA NOSTRO scorrelato da GoldenZoe (oro long, trend H4) e dal Dow (breakout intraday). Un EA su coppie e neutrale al mercato per costruzione. Idea pubblica e generica (z-score del log-rapporto), nessun EA di terzi. Famiglie D1 gia chiuse: trend (Donchian, Supertrend), calendario, RSI(2), momentum, breakout oro/Nasdaq. Questa NON e stata testata.
**Dati:** `/tmp/claude-0/d1/D1_*.csv` (Yahoo, indici e futures continui: possibili salti di rollover, limite noto). Script `backtest_runner/simulatore/rv_d1_coppie.py`.
**Universo fisso (9 coppie, scelte prima di guardare):** Oro/Argento, Oro/Platino, Platino/Palladio, Nasdaq100/SP500, Dow30/SP500, Russell2000/SP500, DAX/EuroStoxx50, DAX/FTSE100, Brent/WTI.
**Regola:** z = (x - media(L)) / dev.std(L) di x = ln(A/B) sulle chiusure fino a t. Segnale a chiusura t, esecuzione all'apertura t+1 (rendimenti apertura-apertura, niente lookahead). z > +E: short A / long B; z < -E: long A / short B; uscita quando |z| < 0,5; stop se |z| > 4 (poi blocco fino a |z| < 1); stop a tempo 60 giorni. Gambe a pari nozionale (0,5 + 0,5 = 1 di nozionale lordo).
**Griglia (6 celle per coppia, 54 in totale):** L in {60,120,250} x E in {2,0 ; 2,5}.
**Costi (ipotesi prudenti):** 0,05% per gamba per lato (0,1% di nozionale lordo per giro completo) + swap 8% annuo sulla gamba long e 2% sulla short (nozionale 0,5 ciascuna: 5% annuo del lordo mentre in posizione).
**Periodi:** IS = inizio dati - 2015; OOS = 2016-2023; hold-out = 2024-2026 (aperto UNA volta, solo per al massimo 3 finalisti).
**Cancelli (non si allentano):**
- G1 IS: PF >= 1,30 sulle operazioni nette, >= 60 operazioni, >= 60% degli anni IS con P&L > 0.
- G2 OOS: PF >= 1,20 con >= 20 operazioni.
- G3 plateau: >= 4 delle altre 5 celle della stessa coppia con PF IS > 1,0 (>= 70%).
- G4 correlazione: |corr| < 0,20 tra il P&L giornaliero della coppia e il rendimento giornaliero di oro (GoldenZoe) e Dow, su IS+OOS.
- G5 hold-out 2024-26: PF >= 1,10 (una volta).
**Previsione prima dei numeri:** probabilita che almeno UNA coppia superi G1+G2+G3: 20%; che superi tutto: 10%. Il rapporto tra indici USA ha costi bassi ma poca ampiezza; oro/argento ha ampiezza ma tendenza lunga. Contatore: 54 celle, attesi 2-3 falsi positivi su G1 da soli: per questo G3 e G2 sono obbligatori.

## RISULTATI (23/11/2026) - FAMIGLIA CHIUSA, nessun candidato
Uscita completa: `RV_D1_COPPIE_RISULTATI_2026-11-23.txt`. **54 celle, 0 passano G1** (PF IS >= 1,30 con >= 60 operazioni e >= 60% anni positivi). Hold-out 2024-26 NON aperto (nessun finalista). Previsione: 20% almeno una coppia: NON verificata.
| Coppia | miglior PF IS (n) | OOS PF (n) |
|---|---|---|
| Oro/Argento | 0,91 (26) | 1,14 (14) |
| Oro/Platino | 0,89 (23) | 1,07 (16) |
| Platino/Palladio | 1,37 (24) | 2,06 (14) |
| Nasdaq100/SP500 | 0,54 (49) | 0,17 (10) |
| Dow30/SP500 | 0,22 (108) | 0,24 (37) |
| Russell2000/SP500 | 0,51 (80) | 0,38 (22) |
| DAX/EuroStoxx50 | 0,32 (15) | 0,22 (13) |
| DAX/FTSE100 | 0,52 (120) | 0,71 (36) |
| Brent/WTI | 1,44 (27) | 2,45 (31) |
**Lettura:** gli indici hanno rapporti che tendono (il ritorno alla media non c'e, PF 0,2-0,5 con molte operazioni). Solo Platino/Palladio e Brent/WTI hanno PF > 1,3 ma con 24-27 operazioni in IS (soglia 60) e plateau debole (1-2 vicini su 5): **non passano, soglie non allentate**; sono campioni piccoli su futures continui con salti di rollover. Limiti: dati Yahoo (non feed del broker), costi prudenti (0,1% del lordo per giro + swap 5% annuo del lordo), nessuna ottimizzazione oltre la griglia. Non testate: coppie su forex, spread con ritardo (lead-lag), altre soglie.
