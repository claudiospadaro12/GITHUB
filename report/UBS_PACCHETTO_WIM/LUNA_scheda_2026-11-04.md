# Scheda EA "Luna AI Pro V1.60" (pacchetto Wim) — 04/11/2026
Fonte: manuale v1.50 (maggio 2026) incollato da Claudio + 3 set file. `.ex5` non aperto e non nel repository; set originali fuori dal repo.

## Cosa dichiara
- **Scalper notturno a mean reversion** nelle ore a bassa volatilità (sessione asiatica/inizio Europa), ordini limit (o a mercato se il limit è troppo lontano), SL/TP stretti, nessuna griglia/martingala. Un grafico EURUSD M5 con OneChartSetup, fino a 15 coppie.
- Coppie principali: **EURAUD, GBPAUD, AUDCAD, AUDUSD**; altre supportate (EURUSD, GBPUSD, USDCHF, GBPCAD, AUDJPY, USDCAD, EURCAD, EURCHF, EURGBP, GBPCHF).
- Finestra operativa di default **23:00–01:00 in «GMT+2 con ora legale»**. Filtri: notizie (alto rischio acceso), swap (tripla), rollover (EURCHF/GBPCHF/AUDJPY 23:55–00:10), correlazione tra operazioni (spenta), spread massimo 18/23.
- **Monitor di performance per coppia**: riduce il lotto (fino a –50%) sulle coppie che perdono negli ultimi 90 giorni e lo ripristina dopo 30 giorni di profitto. Il lotto parte da `LotsizeStep` (saldo per 0,01 lotti), `OnlyUp`.
- Dichiara «performance live verificata»: da confermare con test.

## I 3 set (differenze: 1 valore)
| Set | `LotsizeStep` ($ per 0,01 lotti) |
|---|---|
| Luna_AI_recommended | 100 |
| Luna_AI_recommended_lowrisk | 300 |
| Luna_4%DD | 700 |
Invariati: 4 coppie (EURAUD;GBPAUD;AUDCAD;AUDUSD), magic 987654, trading Venerdì sera e apertura settimanale spenti, news attivo, performance-based attivo, `OnlyUp=0` (il manuale lo raccomanda a 1). Nota: il manuale suggerisce `LotsizeStep=400` come **conservativo**; il set «recommended» usa 100 (quattro volte più aggressivo).

## Letture di C0 (non misurate)
1. **Orario**: la finestra 23:00–01:00 è in «GMT+2 con ora legale» (server europeo orientale). **BCM è GMT+1 fisso**: la stessa finestra diventa 22:00–00:00 sul server BCM in inverno e **21:00–23:00 in estate**. `AutoGMT` non funziona nel tester (lo dice il manuale): i test su BCM richiedono offset manuali (e un periodo estate/inverno separato). Errore d'orario = si testa un'altra strategia.
2. **Stesse coppie AUD di Apex e Stability Pro** (AUDCAD, più AUDUSD, EURAUD, GBPAUD): logica diversa (mean reversion notturna a ordini singoli, non griglia), ma esposizione agli stessi cross: correlazione da misurare, non da assumere bassa.
3. Scalping in ore sottili: **spread e slippage** sono il fattore decisivo, e il rollover vicino: va testato con tick reali e spread del broker, con scenari più larghi.
4. La riduzione di lotto sulle coppie «in perdita» è un'ipotesi di persistenza (le coppie che vanno male continuano): da valutare se aiuta o se arriva tardi (90 giorni).
5. Come nelle altre griglie/mean reversion, il rischio sta nella coda (gap notturni, notizie inattese), non nel PF.

## Da misurare (criteri da congelare prima di guardare i risultati)
Per i 3 set: PF, DD massimo in % e in giorni, peggior giorno e sequenza, n. trade/anno, per anno e per coppia, sensibilità a spread (×1,5, ×2) e a ritardo di esecuzione, effetto del rollover e dei giorni di notizie, con il fuso corretto (estate/inverno separati); correlazione con Apex/Stability, Reaper/Goldbot/Phantom/GTP; peggior giorno combinato col Guardian.
Stato: **nessun test eseguito**.
