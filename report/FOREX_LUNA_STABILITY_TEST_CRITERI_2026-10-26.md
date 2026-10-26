# Luna AI Pro e Stability Pro a 80.000 EUR, anno 2025: CRITERI (26/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Fonti (DICHIARATO dal venditore, pagine lette da Claudio il 26/10): manuale di Luna AI Pro (blog 753391) e pagina Market di Stability Pro (prodotto 105030, v1.9, pubblicato 11/09/2023, demo scaricata 1.330 volte, 3 recensioni a 5 stelle, noleggio 249/349/399 USD per 3/6/12 mesi).

## Cosa dicono le pagine
- **Luna AI Pro**: scalper notturno (sessione 23:00-01:00 GMT+2 DST), 8 coppie ottimizzate (EURAUD, EURCAD, EURCHF, GBPCHF, AUDUSD, AUDCAD, EURGBP, GBPAUD; di default negli input ne ha 4); test su **EURUSD M5 con OneChartSetup**, tick reali; ordini limite di default; rischio con `LotsizeStep` (conti USD/EUR: **400 basso, 200 medio, 100 alto**, 0,01 lotti ogni X di saldo); `OnlyUp` (il lotto non scende dopo le perdite); riduzione del lotto per coppia in base alle prestazioni; filtro news e GMT automatico che richiedono due URL (worldtimeserver.com, nfs.faireconomy.media) non raggiungibili dal tester; filtro rollover.
- **Stability Pro**: **"Smart Variable Grid" con mediazione** ("smart grid using averaging techniques", "group of trades exit in profit"), solo AUDCAD, AUDNZD, NZDCAD; test su **EURUSD M5 con OneChartSetup**; usa solo i prezzi di apertura delle candele: il venditore dice che **il Modello 1 (OHLC 1 minuto) basta**; rischio con valore 1 (minimo), 5 (medio), 10 (molto alto) e "SL di sicurezza" (`MaxAllowedDD`, di default spento); `OnlyUp`; saldo minimo 200 USD (consigliati 500). Affermazioni commerciali ("a basso rischio", "redditizio in ogni mese dal 2007") NON sono prove.
- Il venditore e "Wim" (commenti degli acquirenti).

## Cosa si fa
Riga `RIGA_LANCIA_FOREX_LUNA_STABILITY_80K.txt` (script ANNO80K v3 con `-Simbolo`, pin f89ba59c): 4 passate a conto vuoto da 80.000 EUR, EURUSD M5, 01/01/2025-01/01/2026, leva 1:100, OneChartSetup acceso, coppie di default: **Luna** a tick reali con LotsizeStep 400 e 200 (AutoGMT spento con offset 1/1 perche BCM e UTC+1 fisso; filtro news spento perche il calendario non esiste nel tester: non simulato); **Stability Pro** a Modello 1 con rischio 5 (default) e 1.
Sono **misure, non scelte di rischio**: i livelli per un conto vero sono decisione di Claudio.

## Cosa si legge (scritto ora)
Netto, PF, operazioni, DD equity, giorni con perdita realizzata >= 3% e >= 5%, peggior giorno, **durata massima di una posizione, posizioni contemporanee massime, lotto massimo/minimo, "no money"**, e il **DD dell equity contro quello del saldo** (il flottante). Per Stability Pro, griglia con mediazione: classe di rischio a parte (come Arena), da valutare con tetti di esposizione, non con i cancelli delle altre EA; quindi si riporta il rapporto fra DD equity e DD realizzato e il numero di cesti aperti oltre N giorni. Nessun cancello di acquisto qui; i cancelli per classe sono in `PACCHETTO_6_SU_12_SELEZIONE_CRITERI_2026-10-26.md`.

## Previsioni dichiarate ORA
- F1: tutte e 4 le corse valide (stato OK, operano): 60% (rischio: coppie non visibili/storico mancante, errore dell'indicatore delle Bande di Bollinger).
- F2: Stability Pro (griglia) ha DD equity almeno 2 volte il DD realizzato del saldo a rischio 5: 55%.
- F3: Luna AI Pro opera almeno 150 volte in 12 mesi: 55%.
- F4: nessun giorno con perdita realizzata >= 5% in nessuna delle 4 corse: 60%.
- F5: Stability Pro a rischio 1 ha DD equity < 10% di 80.000: 55%.

## Cosa NON dice
Un anno, un solo regime di mercato forex (2025); filtro news non simulato (Luna), slippage non simulata; nessun merito di acquisto, lotto o taglia. Apex Trader: nessuna pagina ricevuta, non incluso.
