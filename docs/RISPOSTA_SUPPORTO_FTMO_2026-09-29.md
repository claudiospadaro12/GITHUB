# Risposta del supporto FTMO (Eduardo Oviedo) alle domande di Claudio — ricevuta la notte 28/29-09-2026

Testo integrale incollato da Claudio in chat (in inglese); qui i FATTI che riguardano noi, con la conseguenza per ogni sedia.
Fonte esterna: vale come dichiarazione del supporto, non come regolamento firmato; il regolamento resta `docs/REGOLAMENTO_FTMO_2026-09-20.md`.

| # | Cosa dice FTMO | Conseguenza per noi |
|---|---|---|
| 1 | Il conto `541452707` e' di tipo **Standard** (non Swing); si legge in Account MetriX, campo "Account Type". | Le regole "Swing" NON valgono per noi. |
| 2 | **In Evaluation** (challenge e verification) si puo' tenere posizioni overnight e nel weekend. | Oggi ok: il trade del weekend della 771531 era lecito. |
| 3 | **Da FTMO Trader con conto Standard**: chiudere le posizioni prima della chiusura del weekend e prima di ogni pausa di mercato > 2 ore; rispettare gli orari di ogni strumento (`ftmo.com/en/symbols`). | 🔴 **Alla fase FUNDED le sedie che tengono overnight/weekend devono avere la chiusura del venerdi' e della pausa attiva**: 771531 EMA200 H1 (ha `InpFridayCloseHour=22`), 770511 SuperWave 0-24h [DA VERIFICARE: chiusura del venerdi'?], PostNews (FridayClose 23). Le sedie d'apertura chiudono a 19:00 FTMO: ok. Da mettere nel censimento dei contratti PRIMA del passaggio a funded. |
| 4 | **Da FTMO Trader (Standard)**: finestra vietata **2 minuti prima e 2 dopo** le news selezionate del calendario FTMO: NESSUNA esecuzione (market, TP, SL, aperture/chiusure manuali). Non vale in Evaluation ne' per gli Swing. | 🔴 **Alla fase funded serve un filtro news a livello di CONTO** (Guardian o EA): oggi gli EA hanno `InpNewsFile`/`InpNewsBeforeMin` per singola sedia, spenti nei preset FTMO. Da progettare: chi blocca TP/SL nella finestra di 4 minuti? (uno stop del server scatta comunque: da chiedere a FTMO come lo trattano). Non urgente per la challenge. |
| 5 | "Gap trading" vietato: non aprire posizioni ≤ 2 ore prima di una chiusura di mercato ≥ 2 ore intorno a grandi eventi (Brexit, elezioni USA) annunciati nei Trading Updates. | Da leggere `ftmo.com/en/trading-updates` prima degli eventi grossi; le sedie d'apertura non entrano a fine giornata: ok. |
| 6 | **Hedging nello STESSO conto: PERMESSO** (buy e sell sullo stesso strumento). | ✅ Risponde alla domanda 1 del 25/09: 770101 long + 770105 short sullo stesso GER40.cash sono leciti. |
| 7 | Best Day Rule e hedging per aggirarla: solo **1-Step**. | Non ci riguarda (2-Step). |
| 8 | **Hedging FRA CONTI DIVERSI: VIETATO**, anche fra prop/broker diversi. | 🔴 Conferma il vincolo del 25/09 e **il pacchetto "pausa oro demo"**: una sedia oro LONG su FTMO con la 770402 SHORT viva sul piccolo BCM (o un altro demo) sarebbe hedging fra conti. Prima di schierare l'oro long su FTMO le sedie oro sui demo vanno in pausa (`righe/PACCHETTO_PAUSA_ORO_DEMO.md`, firma di Claudio). Vale anche per il DAX: nessuno short DAX su BCM finche' FTMO e' long DAX. |
