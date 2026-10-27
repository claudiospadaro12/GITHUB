# Daytrade Pro Algo (Profalgo) con i set del venditore nei tre mercati: CRITERI e PREVISIONI (27/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta implicita di Claudio (27/10, materiale della pagina Market 97855 e 4 .set: i set sono IDENTICI per impronta a quelli gia in repo `set_venditore/daytrade_pro_v2_4/`). Sostituisce il piano del 20/10 (`DAYTRADE_PRO_TEST_ATTESE_2026-10-20.md`), che non conosceva timeframe e simbolo.

## Fatti letti (pagina del Market, DICHIARATO dal venditore)
- **Daytrade Pro Algo MT5**, Profalgo Limited, **versione 4.51 (19/10/2026)**, pubblicato 02/05/2023, 3.797 demo, 4,18 su 14 recensioni; 599 USD (promo 990), affitto 299 / 399 / 499 USD per 3 / 6 / 12 mesi. **I set che abbiamo sono della v2.4**: la pagina rimanda a un link "Imposta i file" per quelli attuali; potrebbero essere cambiati.
- **Come si esegue**: grafico **EURUSD GIORNALIERO (D1)** con `OneChartSetup` acceso; **13 coppie** da un grafico: EURUSD, GBPUSD, USDJPY, AUDUSD, **XAUUSD**, GBPJPY, USDCAD, EURJPY, EURNZD, EURAUD, NZDUSD, AUDJPY, CHFJPY. Breakout di supporti e resistenze giornalieri, SL e TP per ogni operazione piu stop dinamico; **circa 10 operazioni a settimana**; per il backtest "1 minute OHLC" basta (la differenza con tutti i tick e minima). Saldo consigliato 400 $. Rischio massimo per coppia consigliato: 3 (basso), 7 (medio), 15 (alto) -- i .set v2.4 hanno `MaxRiskMaxDD` 2,7 / 6 / 15.
- **I set**: `LotPerBalance_step` 5000 / 2500 / 1000 e `MaxRiskMaxDD` 2,7 / 6 / 15 (low / medium / high; il nome dei file dice "Max9 / 20 / 50 DD": il drawdown storico dichiarato 9% / 20% / 50%); il set prop e il low con `PropFirmMaxDailyDD=4`. Tutti: `Risk=99999`, `MaxNumberOfTrade=99`, `OnlyUp` spento, `FridayStopHour=25`, `Randomization=0`.
- **Backtest del venditore (non misurati da noi)**: prop 2020-2023 su 100.000, leva 1:500: +217.975, PF 1,96, DD equity **8,57%**, 1.808 operazioni, 76,4% vincenti, vincita media 322 contro perdita media -531 (payoff 0,6), perdita massima -2.268; alto rischio 2020-2023 da 1.000 a 2.130.863 (con DD di saldo **29,7%** e di equity **38,3%**, perdita massima -89.875); lotto fisso 0,01 2000-2023: +18.778 su 100.000, PF 2,21, 7.034 operazioni, DD equity 0,32% (lotto minimo: il DD non dice niente); solo oro (836 operazioni): +473.030, PF 1,91, DD equity **31,55%**, perdita massima -14.116.
- **Segnale live del venditore** (1949810): +71,88% (media 3% al mese): 2023 +34,6% (mag-dic), 2024 +19,5%, 2025 +6,9% (solo gen-mar; il grafico finisce a marzo 2025: sette mesi vecchio); mesi neri 2023-2024 fino a -8,2% (03/2024). Letto il 18/08: 172 settimane, 1.248 operazioni, PF 1,25, DD peggiore 15,61%. **La crescita del live rallenta (34,6% -> 19,5% -> 6,9% in tre mesi)**: DICHIARATO come dato, non come giudizio.
- **Cosa risolve del nostro setaccio**: il 24/10 il Daytrade Pro girato sull'oro con i default (RunOneChartSetup spento, `Risk=0` = lotto fisso 0,01) ha fatto 3 operazioni in due mesi: **non e una misura del prodotto**, e la configurazione sbagliata.

## Passate (riga `RIGA_LANCIA_DTP_80K.txt`, script ANNO80K v5, pin 3e43646d)
13 passate, 80.000 EUR, EURUSD D1 con OneChartSetup e le 13 coppie: 12 a Modello 1 (set PROPFIRM R27, MEDIUM R6, HIGHRISK R15 x 2013, 2018, 2020, 2025), poi UNA corsa continua a tick reali di 21 mesi col set PROPFIRM (riferimento Modello 4 e prova lunga). Il LOW non si ripete (e il prop senza il limite giornaliero). Imposti: `RunOneChartSetup`, le 13 coppie, `Risk=99999`, `StartLots`, `LotPerBalance_step`, `MaxRiskMaxDD`, `PropFirmMaxDailyDD`, `UseEquity`, `OnlyUp`, `CheckMargin`, `MaxNumberOfTrade`, `Randomization`, `FridayStopHour` (nomi verificati nel report del 24/10).

## Criteri
PROP-ANNI come per gli altri EA (netto > 0 in 2013, 2018 e 2020; DD equity <= 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK: stesso segno, rapporto Modello 1 / tick reali 0,5-2,0, correlazione mensile >= 0,5). Lettore `leggi_tre_anni_80k.py`. **La calibrazione e misurata solo sul PROPFIRM**: gli altri due set escono "NON PROP-ANNI per calibrazione" = non valutabile, si leggono a mano come indicativi. Si riportano anche: posizioni insieme (S-NOSCALA: max 10), simboli con operazioni, payoff, DD equity contro DD di saldo. Non misurati qui: correlazione col Reaper (dichiarata bassa dal venditore per Phantom, non per questo), costi, equity intraday (13 coppie: servono le barre M1 di tutte).

## Previsioni dichiarate ORA
- Q1: il PROPFIRM supera PROP-ANNI: 30%.
- Q2: nel 2025 operano almeno 8 coppie su 13: 70%.
- Q3: HIGHRISK ha DD equity > 8.000 o stop out in almeno un anno: 90%.
- Q4: MEDIUM ha DD equity > 8.000 in almeno un anno: 70%.
- Q5: calibrazione OK per il PROPFIRM: 60%.
- Q6: corsa lunga PROPFIRM: netto > 0: 75%; DD equity <= 8.000 EUR: 65%.
- Q7: almeno 10 posizioni aperte insieme in un momento: 55%.
- Q8: payoff (vincita media / perdita media) del PROPFIRM sotto 1: 85%.
- Q9: operazioni nei 21 mesi del PROPFIRM fra 500 e 1.500: 60%.
- Q10: il 2013 ha un'esecuzione valida (storico M1 di tutte le coppie presente): 55%.

## Cosa NON dice
Un percorso per anno; Modello 1 sui tre anni vecchi; nessuna slippage; set v2.4 su un EA alla 4.51; OneChartSetup con 13 coppie richiede lo storico di tutte: la passata mostra quali mancano; il 2013 e a rischio. Nessun giudizio su acquisto, lotto o taglia.
