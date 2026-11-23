# Terzo EA: trend D1 sul forex - CRITERI scritti PRIMA dei dati (23/11/2026)
Perche: serve un EA NOSTRO con vantaggio misurato e scorrelato da GoldenZoe (oro) e Dow (indice). Famiglie D1 gia chiuse su 33 mercati (non forex, salvo indice dollaro): Donchian 20/55, Supertrend, calendario, RSI(2), momentum. Il forex non e stato testato con dati propri D1 (sul server non c'e). Esportazione: `ABTG_ExportD1.mq5` + `RIGA_EXPORT_D1_FTMO.ps1` (feed FTMO, ora server, solo lettura) -> `ABTG_D1_<simbolo>.csv`. Si esportano 28 cross, ma si testa SOLO l'universo fisso qui sotto.
**Universo fisso (10):** EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, USDCHF, NZDUSD, EURJPY, GBPJPY, EURGBP.
**Metodi (5 celle in totale, a portafoglio: tutte e 10 le coppie insieme, nozionale unitario uguale, long e short):**
- M1 Donchian: ingresso alla rottura del massimo/minimo dei N giorni precedenti (N in {20, 55}), uscita con trailing 3 x ATR(14) dal massimo favorevole; esecuzione all'apertura successiva.
- M2 Momentum di serie temporale: posizione = segno del rendimento a L giorni (L in {60, 120, 250}), rivalutata ogni 5 giorni di borsa, esecuzione all'apertura successiva.
**Costi (prudenti):** 0,02% del nozionale per lato + 1,5% annuo di nozionale tenuto (swap medio sfavorevole).
**Periodi:** IS = dal primo dato disponibile al 2015; OOS = 2016-2023; hold-out = 2024-2026 (aperto UNA volta, solo per le celle finaliste, massimo 3).
**Cancelli (non si allentano; operazioni = episodi di posizione per coppia, P&L netto in % nozionale):**
- G1 IS: PF >= 1,25, >= 150 operazioni, >= 60% degli anni IS con P&L aggregato > 0.
- G2 OOS: PF >= 1,15, >= 60 operazioni.
- G3 plateau: le altre celle dello stesso metodo (1 per M1, 2 per M2) tutte con PF IS > 1,0.
- G4 correlazione: |corr| < 0,20 tra il P&L giornaliero del portafoglio e il rendimento giornaliero di oro e Dow (dati D1 nel server) su IS+OOS.
- G5 hold-out: PF >= 1,10.
**Informativo (non e cancello):** risultato per singola coppia, rendimento annuo e max drawdown del portafoglio a 1x.
**Previsione prima dei numeri:** probabilita che almeno una delle 5 celle superi G1+G2+G3: 15%; che superi tutto: 8%. Motivo: il trend forex D1 e noto come debole dopo il 2010 e i costi/swap lo erodono; Donchian 20/55 sui 33 D1 non ha dato nulla.
