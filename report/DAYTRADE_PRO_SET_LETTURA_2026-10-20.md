# DayTrade Pro (Market product 97855): i 4 file .set del venditore v2.4 -- lettura (20/10/2026)

**Non controllata da agenti.** Scaricati da `c.mql5.com/31/1077/` (pubblici), copiati in `backtest_pipeline/set_venditore/daytrade_pro_v2_4/`. Pagina: nessun timeframe dichiarato; coppie citate nei commenti: GBPJPY, AUDUSD, AUDJPY, EURNZD, GBPUSD.
- I tre set di rischio (lowrisk "Max9rDD", mediumrisk "Max20oDD", highrisk "Max50qDD") differiscono SOLO per `LotPerBalance_step` (5000 / 2500 / 1000) e `MaxRiskMaxDD` (2,7 / 6,0 / 15,0). Il set "Prop" e' il lowrisk con `PropFirmMaxDailyDD=4`.
- Tutti: `RunOneChartSetup=1` con 13 coppie (EURUSD;GBPUSD;USDJPY;AUDUSD;**XAUUSD**;GBPJPY;USDCAD;EURJPY;EURNZD;EURAUD;NZDUSD;AUDJPY;CHFJPY), `StartLots=0.01`, `MaxNumberOfTrade=99`, `Risk=99999`. **Quindi opera su 13 coppie da UN grafico, compreso l'oro**: l'idea "scorrelato dall'oro" va verificata (e la correlazione con Prop Firm/Gold Reaper si calcola sull'EA intero).
- Il nome dice "Max9/20/50 DD" = drawdown storico dichiarato dal venditore (9%, 20%, 50%): **il set alto dichiara fino a 50%**, oltre il tetto S-DD (10% dal deposito): attesa S1 gia' scritta (non passa).
- `MaxNumberOfTrade=99`: S-NOSCALA (max 10 posizioni) va misurata, non presunta. Test multi-simbolo nel tester = un tester con piu' simboli, ticks reali per tutte le 13 coppie su 21 mesi: da verificare che il BCM li abbia.
