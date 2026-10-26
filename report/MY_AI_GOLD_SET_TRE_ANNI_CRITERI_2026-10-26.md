# My AI Gold con i set del venditore nei tre mercati: CRITERI e PREVISIONI (26/10/2026, scritti PRIMA dei numeri)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): "My AI Gold: ho trovato il set per la prop firm. Lo avevamo gia analizzato?" ... "poi lo analizziamo coi vari settaggi nei 3 mercati".

## Cosa esisteva prima
Solo il setaccio del 19/10: 5.000 EUR, gennaio-febbraio 2026, input di DEFAULT (balance 300, Recovery=true), tick reali: 43 operazioni, +3.732, PF 1,47, DD equity 45,9% (DD di saldo 36%), 77% vincenti, vincita media 355 contro perdita media -797 -> classe B (recupero/griglia). Nessun test a 80.000, nessun anno lungo, nessun set prop. Il set prop e quindi NUOVO.

## Fatti dei set (letti dai file .set, UTF-16)
- Sei set (aggressive, highrisk, normalrisk, lowrisk, conservative, propftmo) IDENTICI tranne `balance` = 100, 250, 500, 750, 1000, 1500. `myai_propbftmos.set` (primo file mandato) = `propftmo` byte per byte nei valori. Lotto automatico circa 0,01 x saldo / balance: a 80.000 EUR 8,0 / 3,2 / 1,6 / 1,07 / 0,8 / 0,53 lotti.
- Nuovo `myai_propX9ftmoa.set`: balance 2500 (0,32 lotti a 80.000), FrHour 22 (chiusura venerdi alle 22), MaxCountOrders 1, NewsFilter ACCESO con 60 minuti prima e dopo. MaxCountOrders NON esiste nella versione installata (non imponibile); il calendario news nel tester quasi certamente non funziona -> nel tester PROPX9 vale "balance 2500 + chiusura venerdi 22".
- Guida del venditore (v1.0 settembre 2026): configurazione di riferimento prudente = Balance Step 2000, 1 operazione aperta, chiusura venerdi, news spento; "Balance Step" e il controllo principale del rischio; orari = server. La guida non cita il Recovery, che nella versione installata e di default true.
- Limiti noti: AutoGMT di default true senza offset impostabili (orologio non verificato su BCM); filtro news non simulabile; Recovery attivo (griglia/recupero: i danni stanno nella coda).

## Passate (riga `RIGA_LANCIA_MYAI_GOLD_80K.txt`, script ANNO80K v5, pin 3e43646d)
40 passate, 80.000 EUR, XAUUSD H1, dal piu corto al piu lungo: 8 set x (2013, 2018, 2020, 2025 a Modello 1) = 32, poi 8 passate 2025 a tick reali (calibrazione). Set: AGGRESSIVE 100, HIGHRISK 250, NORMAL 500, LOWRISK 750, CONSERVATIVE 1000, PROPFTMO 1500, GUIDA2000 (balance 2000, Balance Step di riferimento della guida), PROPX9 2500 (+FrHour 22, news 60/60). Si impone solo balance (+ gli input extra di PROPX9): gli altri valori dei set coincidono col default. Regimi: 2013 ribasso, 2018 laterale, 2020 rialzo, 2025 calibrazione.

## Criteri (PROP-ANNI, uguali agli altri EA)
Per ogni set: netto > 0 in 2013, 2018 e 2020; DD equity <= 8.000 EUR; nessuno stop out; nessun giorno con perdita realizzata >= 5%; calibrazione 2025 OK (stesso segno, rapporto Modello 1 / tick reali fra 0,5 e 2,0, correlazione mensile >= 0,5). Lettore `leggi_tre_anni_80k.py` (esteso per leggere piu set dello stesso EA dal nome della cartella). Si riportano anche peggior giorno, peggior mese e lotto massimo.
Letture accessorie dichiarate: (a) quanto il DD scala con balance (atteso circa inverso: dal 45,9% a balance 300 -> circa 9% a 1500, 5,5% a 2500); (b) PROPX9 contro GUIDA2000: se il rapporto dei netti e vicino a 2000/2500 il filtro news e la chiusura venerdi 22 non cambiano nulla nel tester.

## Previsioni dichiarate ORA
- M1: AGGRESSIVE e HIGHRISK vanno in stop out o superano 8.000 di DD in almeno un anno: 90%.
- M2: PROPFTMO (1500) PROP-ANNI superato: 30%.
- M3: PROPX9 (2500) PROP-ANNI superato: 40%.
- M4: almeno 1 degli 8 set PROP-ANNI superato: 55%.
- M5: calibrazione OK per almeno 5 degli 8 set: 55%.
- M6: almeno un set con netto negativo in 2013 (anno SHORT): 60%.
- M7: PROPX9 / GUIDA2000 dei netti entro +-25% di 0,8: 65%.
- M8: il DD equity di PROPFTMO nel peggior anno supera 8.000 EUR: 50%.

## Cosa NON dice
Un percorso per anno; Modello 1 (OHLC 1 minuto) non e tick reale; niente slippage; il Recovery fa soffrire nelle code che tre anni possono non contenere; il filtro news non e simulato, quindi PROPX9 non e testato "come lo vende il venditore"; nessun giudizio su acquisto, lotto o taglia. Test sul tester, nessuna prova su server BCM (orologio AutoGMT).
