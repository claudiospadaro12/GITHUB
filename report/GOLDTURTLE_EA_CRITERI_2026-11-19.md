# GoldTurtle_H4 (EA MQL5 dell'oro trend following): criteri del test nel tester, scritti PRIMA dei numeri (19/11/2026)
**EA:** `mql5/Experts/GoldTurtle_H4.mq5` (breakout 55 candele H4, stop iniziale 3 ATR, stop mobile Chandelier 3 ATR, solo long di default). Riga: `RIGA_GOLDTURTLE_BCM.txt` (BCM portabile, XAUUSD H4, Modello 1 barre da 1 minuto, 100.000 EUR, rischio 1% dell'EA, spread/commissioni/swap del tester). **Non compilato in questa sessione**: il primo lancio dira' se ci sono errori.
**Differenze note dal simulatore Python (cause attese di scarto):** candele H4 del server BCM (GMT+1 fisso) contro quelle FTMO; iATR di MT5 (media semplice) contro la media di Wilder; spread e swap veri al posto di 0,35 USD fissi; stop in intrabarra del tester. Riferimento Python (solo long, costo 0,35): PF 1,45 (2004-2014), 1,89 (2014-2020), 1,77 (2021-2026), DD 6-8%.
**Varianti:** LONG (default) e LONGSHORT (con vendite) su tre finestre: **W2005_2014, W2015_2023, W2024_2026** (6 passate).
## Porte (scritte ora)
- **Conferma LONG:** in ciascuna delle tre finestre PF del tester >= 1,3, DD equity <= 15%, >= 25 operazioni; e almeno il 60% degli anni positivi. Se in una finestra il PF e' < 1,2: NON CONFERMATO.
- **Il test tiene o no rispetto a Python:** scarto del PF entro +-0,3 dal riferimento. Uno scarto maggiore va spiegato (differenza di dati/orario H4) prima di fidarsi.
- LONGSHORT serve solo come confronto: se le vendite peggiorano il PF (atteso), si resta sul solo long.
## Previsioni
- PF LONG >= 1,3 nella finestra 2005-2014: **55%**; 2015-2023: **60%**; 2024-2026: **55%**; in tutte e tre: **30%**.
- DD LONG <= 15% in tutte e tre: **65%**.
- LONGSHORT con PF inferiore a LONG in almeno due finestre su tre: **70%**.
- Primo lancio con errore di compilazione: **35%**.
## Limiti
Un solo mercato; rialzo strutturale dell'oro; costi 2005-2010 del tester dipendono dal feed BCM; nessun test a tick reali oltre al 2025 (da aggiungere se il risultato regge); regole FTMO e tenuta pluri-giornaliera non verificate; la scelta del rischio per operazione e' di Claudio.
