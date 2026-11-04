# Scheda EA "Daytrade Pro V4.5" (pacchetto Wim) — 04/11/2026
Fonte: manuale v4.1 (maggio 2026) incollato da Claudio + 4 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- Price action attorno ai **supporti/resistenze giornalieri** («il prezzo viene risucchiato nei livelli»): **13 simboli — EURUSD, GBPUSD, USDJPY, AUDUSD, XAUUSD (oro), GBPJPY, USDCAD, EURJPY, EURNZD, EURAUD, NZDUSD, AUDJPY, CHFJPY**, da un grafico EURUSD **Daily**.
- 8 varianti di strategia per coppia, **al massimo un trade per coppia**; circa **10 trade a settimana** su tutte le coppie. SL/TP fissi + trailing, nessuna griglia/martingala. «Indipendente da spread e broker» (affermazione da verificare).
- Lotto: `use StartLots` o **«Max Risk per pair»** (default 3; consiglia 3 basso, 7–10 medio, 15+ alto), `AdjustLotsizeToVariableValues`. Prop firm: `PropFirmMaxDailyDD`, randomizzazione, aggiustamenti.

## I 4 set
| Set | `MaxRiskMaxDD` (rischio per coppia) | `LotPerBalance_step` | `PropFirmMaxDailyDD` |
|---|---|---|---|
| Max9%DD_lowrisk | 2,7 | 5000 | — |
| Max20%DD_mediumrisk | 6 | 2500 | — |
| Max50%DD_highrisk | 15 | 1000 | — |
| daytradePro_Prop | 2,7 | 5000 | 4 |
Comuni: le 13 coppie, magic 5656, `OnlyUp=0`, chiusura venerdì spenta (25), randomizzazione 0, scadenza virtuale accesa. I nomi dei set dichiarano un **drawdown massimo atteso (9% / 20% / 50%)**: sono dichiarazioni basate sul backtest di Wim, non garanzie.

## Letture di C0 (non misurate)
1. **È il candidato più naturale per diversificare**: timeframe Daily, 13 coppie forex su valute diverse, ~10 trade a settimana, poco sensibile all'orario del server (Daily) e allo spread. Nessun ORB, nessuna griglia.
2. Contiene **XAUUSD** (oro): sovrapposizione col nostro trio. Si può togliere dalla lista (`OneChartSetupPairs`), oppure si misura la correlazione con Reaper/Goldbot/Phantom e si decide.
3. Correlazioni interne forte per JPY (USDJPY, GBPJPY, EURJPY, AUDJPY, CHFJPY) e AUD (AUDUSD, AUDJPY, EURAUD): le 13 coppie non sono 13 fonti indipendenti. Si sovrappone anche con USDJPY dei set UBS e con le coppie AUD di Apex/Luna.
4. Il tetto «Max9%DD / 20% / 50%» dipende dal **drawdown storico** usato per dimensionare i lotti (dentro l'`.ex5`): se sottostimato, il lotto è sovrastimato. Va verificato sul periodo lungo (Wim consiglia 5–10 anni) e in stress (2020, 2022).
5. Il manuale suggerisce di partire da «Max Risk per pair»; i set hanno un valore strano `Risk=99999` (probabile segnaposto del menu a tendina): da leggere nel tester per capire quale metodo di lotto applichino.
6. Lavora con ordini pendenti a livelli giornalieri: la qualità dei dati D1 e il rollover/swap contano meno di uno scalper, ma il **gap del weekend** sì.

## Da misurare (criteri da congelare prima di guardare i risultati)
Per i 4 set (con e senza XAUUSD): PF, DD massimo in % e in giorni (confronto col 9/20/50% dichiarato), peggior giorno/settimana, n. trade/anno, per anno e per coppia, sensibilità a spread; correlazione dei P&L giornalieri con Reaper/Goldbot/Phantom/GTP e con gli altri EA del pacchetto; peggior giorno combinato col Guardian. Test: EURUSD D1 con OneChartSetup, 1-minute OHLC su 2013–oggi (poi tick reali su un periodo breve di confronto), in due tempi (scelta e verifica).
Stato: **nessun test eseguito**.
