# Gold Trade Pro (Profalgo) con i set del venditore nei tre mercati: CRITERI e PREVISIONI (27/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Materiale di Claudio (27/10): pagina del Market (prezzo 649 USD; affitto 349 / 449 / 549 USD per 3 / 6 / 12 mesi; versione 7.1 del 17/10/2026; 10 attivazioni), 4 file .set del venditore (V4.0: low, medium, high, prop firm), manuale V6.74, tre immagini di backtest del venditore e un grafico del segnale ad alto rischio.

## Fatti letti (pagina, manuale, set)
- **XAUUSD, grafico giornaliero D1** (confermato dalla pagina e dal manuale): chiude l'ipotesi D1 delle tranche del 19/10. Saldo minimo 1.000 $ (manuale: minimo 1.000, consigliato 2.000+; la pagina dice 500-1.000 con le sole strategie 3, 4 e 7 per conti piccoli).
- Breakout dei livelli giornalieri di supporto e resistenza, 8 strategie interne (A-H) in parallelo, SL e TP fissi dall'inizio piu trailing, "niente griglia, martingala, mediazione".
- **I set differiscono SOLO per due input**: `MaxRiskPerStrategy` = 1,0 (prop) / 1,5 (low) / 3,0 (medium) / 6,0 (high) e `PropFirmMaxDailyDD` = 4,0 solo nel prop, 0 negli altri. Tutti: `Risk=3` (metodo di lotto "rischio massimo per strategia"), tutte e 8 le strategie accese, `OnlyUp=true`, `UseEquity=false`, `CheckMargin=true`, filtro NFP acceso (10 minuti prima, 240 dopo, chiude le posizioni), `FridayStopHour=25` (NESSUNA chiusura del venerdi, anche nel set prop), `Randomization=0`.
- **Il rischio totale e la somma delle strategie**: il manuale dice che l'esposizione e circa MaxRiskPerStrategy x numero di strategie attive (8): il set prop a 1% puo avere fino a circa 8% di rischio aperto contemporaneo; il medium 24%, l'high 48%.
- **I test del 19/10 NON erano la configurazione del venditore**: input letti dal report: `Risk=0` (lotto fisso StartLots 0,01), `MaxRiskPerStrategy=3`, `PropFirmMaxDailyDD=0`. Quindi "+2.554 in 21 mesi a 5.000" misurava la strategia a lotto minimo, non il prodotto coi suoi set.
- Dichiarazioni del venditore (NON misurate da noi): set prop 100.000 start 2020->2023 a leva 1:500: +146.071 (+146%), PF 2,38, DD equity 7,79%, 850 operazioni, perdita massima 850; rischio 1% per operazione: +700% in 3 anni, DD equity 12,34%; rischio 2%: +6000%, DD 23,07%; rischio 4%: da 1.000 a 1,5 milioni in 3 anni, DD equity 39,27%; una curva etichettata "out of sample" (prima parte) e "optimized" (parte finale): **il venditore stesso dichiara che una parte del periodo e ottimizzata**. Segnale ad alto rischio (EUR): +645,59% da luglio 2024 a marzo 2026, mesi da -13,1% a +61%; il grafico finisce a marzo 2026 (aggiornamento di aprile-ottobre: NON VISTO). Il segnale "diretto" 2084890 (letto il 18/08): 150 settimane, 725 operazioni, PF 1,59, DD peggiore 31,95%.
- Limiti noti: NFP usa le date interne nel tester (calendario assente), AutoGMT con offset 2/3 (orologio NON verificato su BCM); gli URL da autorizzare servono a licenza, backup, AutoGMT e filtro NFP (nel tester non contano); il filtro IR/CPI e spento.

## Passate (riga `RIGA_LANCIA_GTP_80K.txt`, script ANNO80K v5, pin 3e43646d)
20 passate, 80.000 EUR, XAUUSD D1, dal piu corto al piu lungo. 16 a Modello 1: 4 set (PROPFIRM R1, LOWRISK R15, MEDIUM R3, HIGHRISK R6) x (2013 ribasso, 2018 laterale, 2020 rialzo, 2025 calibrazione). Poi 3 a tick reali del 2025 (low, medium, high). Infine UNA corsa continua a tick reali di 21 mesi (01/01/2025-01/10/2026) col set PROPFIRM: serve da riferimento Modello 4 del set prop (il lettore usa solo i mesi 2025) e da prova lunga. Imposti: `Risk=3`, `MaxRiskPerStrategy`, `PropFirmMaxDailyDD` (gli altri input coincidono col default dell'EA installato e coi set).

## Criteri
PROP-ANNI come per gli altri EA: netto > 0 in 2013, 2018 e 2020; DD equity <= 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK (stesso segno, rapporto Modello 1 / tick reali fra 0,5 e 2,0, correlazione mensile >= 0,5). Lettore `leggi_tre_anni_80k.py` (per set, dal nome della cartella). Sulla corsa lunga del set prop si riportano anche mesi positivi, giorni >= 3% / 4% / 5%, peggior giorno, lotto massimo. Confronto dichiarato con le affermazioni del venditore: DD equity del prop a 1% sul 2020 contro il 7,79% dichiarato (che e su 100.000 a 2020-2023).
Non misurati in questa riga (da fare dopo, se serve): correlazione giornaliera col Gold Reaper (serve la serie giornaliera del set prop; ipotesi del 19/10 a lotto fisso: 0,555), classifica con costi, equity da barre M1.

## Previsioni dichiarate ORA
- G1: il set PROPFIRM supera PROP-ANNI: 40%.
- G2: almeno uno dei 4 set supera PROP-ANNI: 50%.
- G3: HIGHRISK ha DD equity > 8.000 o stop out in almeno un anno: 85%.
- G4: nel set PROPFIRM l'anno peggiore e il 2018 laterale: 55%.
- G5: calibrazione OK per almeno 3 set su 4: 60%.
- G6: PROPFIRM nel 2020: netto tra +10% e +60% di 80.000: 55%.
- G7: corsa lunga PROPFIRM: netto > +20% e DD equity <= 8.000: 55% (insieme).
- G8: corsa lunga PROPFIRM: al massimo 1 giorno con perdita realizzata >= 3%: 70%.

## Cosa NON dice
Un percorso per anno; Modello 1 sui tre anni vecchi; il periodo "ottimizzato" dichiarato dal venditore puo coincidere con anni recenti; nessuna slippage; filtro news non simulato; AutoGMT non verificato; nessun giudizio su acquisto, lotto o taglia.
