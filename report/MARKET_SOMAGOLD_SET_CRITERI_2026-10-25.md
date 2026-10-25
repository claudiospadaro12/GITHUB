# SomaGold: pagina del venditore, set da imporre e criteri (25/10/2026, scritti PRIMA di ogni numero)
**Natura: LETTURA di 14 screenshot della pagina del Market + un test di funzionamento nel tester a 80.000 EUR.** Fonte: `SOMAGOLD.zip` di Claudio, pagina `mql5.com/en/market/product/176349` vista il 25/10/2026 (07:26-07:30). Tutto cio che segue sul venditore e **DICHIARATO** (lo dice la pagina), non misurato da noi.

## Cosa dice la pagina (DICHIARATO)
- **SomaGold v3.6** (07/10/2026), 600 USD o 60 USD al mese, pubblicato 15/05/2026, 15 acquisti al mese, 4,62 stelle, autore Andrii Soma. Un EA, **32 strategie di breakout** indipendenti su XAUUSD, D1/H12/H8/H4; "intervallo temporale: qualsiasi, l'EA legge internamente i propri intervalli".
- **Configurazione consigliata:** XAUUSD; conto ECN/RAW; saldo minimo 1.000 USD; VPS; **"Affinche AUTO_GMT funzioni e necessario aggiungere l'URL https://www.worldtimeserver.com/ agli URL consentiti nel terminale"** (Strumenti, Opzioni, Expert Advisor).
- **Input GMT:** `Broker_GMT_OFFSET_Summer`, `Broker_GMT_OFFSET_Winter` (manuali), `AutoGMT` ("rileva automaticamente l'ora GMT del broker, ignora gli offset manuali").
- **Finestra di trading:** `UseTradingTimeZones`, `MondayOpenHour/Minute`, `FridayCloseHour/Minute` (ora del broker); filtri news NFP, IR/FOMC e CPI con calendario integrato statunitense; modalita di conformita prop opzionale (`EnablePropFirmCompliance` e `PF_*`, spenta di default).
- **Lotti:** `Risk` (manuale a lotto fisso oppure automatico dal capitale), `OnlyUp`, `MarginCallProtection` (riduce il lotto in base alla leva: le immagini mostrano a leva 1:33 "effective 0,11x", a 1:200 "0,68x", a 1:500 "1,00x").
- **Backtest del venditore (DICHIARATI, non verificati):** MetaQuotes 22 anni a bilancio fisso 10k: DD balance 13,1%, DD equity 24,7%; IC Markets tick reali 03/07/2023-11/05/2026, 10k: profitto 59.199, PF 5,05, 1726 operazioni, DD balance 3,06%, DD equity 5,92% (relativo 16,05%); perdita massima -377; 41 perdite di fila. Correlazione di profitti giornalieri con altri EA oro: 0,31-0,57 (Gold Reaper 0,31).
- **Dashboard (live):** "License: Valid", 32 strategie, 105 ordini pendenti con lotto totale 1,12 buy / 1,05 sell su saldo 4.890. Il dashboard e spento nel tester di default.

## Perche con i default ha fatto ZERO operazioni nel nostro screening (IPOTESI, non causa trovata)
Nel log del tester: `AutoGMT=true`, `Broker_GMT_OFFSET_Summer=3`, `Broker_GMT_OFFSET_Winter=2` (VERIFICATO nel referto del 24/10). Nel tester non c'e accesso a Internet: **AutoGMT non puo interrogare worldtimeserver.com** (INFERITO dalla frase della pagina) e i default manuali sono quelli di un broker GMT+2/+3, non del nostro server **UTC+1 fisso** (regola di progetto, `OROLOGIO_BCM`). Se l'EA non conosce l'ora GMT non sa quando aprire la finestra dei breakout ne quando fermarsi per le news: puo restare fermo (INFERITO). Seconda ipotesi: `MarginCallProtection` con leva 1:100 nel nostro tester (circa 0,33x, interpolando le tre immagini: INFERITO) e licenza/demo limitata (NON VERIFICATO).

## Il SET da imporre (solo cio che la pagina documenta; il resto resta di default)
`AutoGMT=false`, `Broker_GMT_OFFSET_Summer=1`, `Broker_GMT_OFFSET_Winter=1` (server BCM UTC+1 fisso, DICHIARATO dalla regola di progetto; da riconfermare sul referto). Nessuna taglia, nessun rischio toccato.

## Criteri congelati
- **Test:** `SET80K_TESTER_TRANCHE.ps1`, SomaGold.ex5, **80.000 EUR**, leva 1:100, XAUUSD **H1** (l'EA ignora il periodo), 01/01-01/03/2026, tick reali, input imposti come sopra; il report deve confermare i tre valori imposti, altrimenti la passata e KO.
- **S-A:** con il set l'EA OPERA se fa **almeno 10 operazioni**; con 1-9 "opera poco"; con 0 "non opera anche col set GMT: la causa non e il GMT".
- **Se opera:** passa al test a fondo a 80.000 con lo stesso set (21 mesi, soglie S-*); il setaccio NON giudica il profitto, ne sceglie il periodo ne decide un acquisto. Se NON opera: si prova la seconda ipotesi (leva e MarginCallProtection) prima di scartare.
- **Attese dichiarate ORA:** il giro parte e compila il referto 90%; SomaGold opera col set 55%; opera con 10 o piu operazioni 50%; ancora zero 40%.
- **Limiti:** due mesi, una sola passata, un solo set; la pagina e del venditore e non e verificata; non decide acquisti ne taglie.
