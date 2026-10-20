# DayTrade Pro, set prop firm a 80.000 EUR: piano e previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio ha rimandato i 4 file .set della v2.4 (identici per impronta SHA256 a quelli gia' nel repo, `set_venditore/daytrade_pro_v2_4/`) e chiede: "facciamo i backtest su 80K per la prop firm". Contesto: `DAYTRADE_PRO_SET_LETTURA_2026-10-20.md`, criteri `MARKET_ORB_VENDITORE_CRITERI_2026-10-20.md`. Tabella di confronto: `CONFRONTO_DATI_MEMORIZZATI_80K_2026-10-20.md`.

## Cosa NON so (dichiarato prima)
- **Simbolo del grafico e timeframe**: la pagina del venditore non li dichiara. Con `RunOneChartSetup=1` l'EA opera su 13 coppie (EURUSD;GBPUSD;USDJPY;AUDUSD;**XAUUSD**;GBPJPY;USDCAD;EURJPY;EURNZD;EURAUD;NZDUSD;AUDJPY;CHFJPY) da un grafico. **Scelta MIA, non del venditore**: grafico EURUSD (come The ORB Master) e tre timeframe da provare, M5, M15 e H1.
- Il **nome esatto** del file .ex5 sul terminale (la riga cerca `*DayTrade*`; se non ne trova esattamente uno, stampa l'elenco dei .ex5 del Market e si ferma).
- Se il BCM ha ticks reali per 21 mesi per tutte e 13 le coppie: il tester li scarica; il referto elenca l'inizio dei tick per ogni simbolo.
- Se l'EA usa l'orario del broker (GMT+2/+3 vs BCM UTC+1 fisso): il set non ha input di offset [NON VERIFICATO].

## Cosa si fa
Set **prop** (`daytradePro_Prop.set`): `Risk=99999, StartLots=0.01, LotPerBalance_step=5000, MaxRiskMaxDD=2.7, PropFirmMaxDailyDD=4.0, MaxNumberOfTrade=99, UseEquity=0, OnlyUp=0, CheckMargin=1, Randomization=0, FridayStopHour=25, Virtual_expiration=1, ST1_MagicNumber=5656` imposti nel .ini e verificati nel report; `OneChartSetupPairs` e `ST1_Comment` solo verificati (la lista ha punti e virgola). Deposito 80.000, ticks reali (Modello 4), leva 1:100.
Fase 1 (T1-T3): sonda di 2 mesi (01/10/2025-01/12/2025) su EURUSD M5, M15, H1. Fase 2 (T4-T6, stessa riga con altre tranche): corsa continua 21 mesi al timeframe (o ai timeframe) in cui l'EA **opera su piu' simboli**: la regola di scelta e' scritta ora ed e' sul numero di simboli con operazioni, NON sul profitto. Non si sceglie il timeframe piu' redditizio.
## Previsioni dichiarate ORA
- **DT-A**: tutti gli input imposti e quelli verificati coincidono col report (nessun "INPUT NON APPLICATI"). Fiducia 70%.
- **DT-B**: in almeno un timeframe l'EA opera (almeno 1 operazione) su almeno 8 delle 13 coppie nei 2 mesi. Fiducia 60%.
- **DT-C**: l'EA opera anche sull'oro (XAUUSD). Fiducia 70%.
- **DT-D**: lotti mediani fra 0,10 e 0,30 (80.000/5.000 x 0,01 = 0,16 se il lotto e' proporzionale a `LotPerBalance_step`). Fiducia 55%.
- **DT-E**: ogni sonda di 2 mesi dura meno di 60 minuti (esclusi i tick da scaricare la prima volta). Fiducia 50%.
- **DT-F** (continua, dopo): PF fra 0,9 e 1,4; almeno una soglia fra S-N, S-M, S-H, S-DD, S-NOSCALA fallisce (<= 10 posizioni contemporanee con `MaxNumberOfTrade=99` e' dubbia). Fiducia 65% che ne fallisca almeno una.
- **DT-G**: correlazione giornaliera dei realizzi con Prop Firm e Gold Reaper <= 0,3 in valore assoluto (calcolata sull'EA intero, oro compreso). Fiducia 65%.
Soglie invariate. DD sempre anche come % degli 80.000 iniziali.
