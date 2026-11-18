# Prompt per Claude in Chrome: Agente 1 "TradingView Scout" (18/11/2026)
Parte 1 del workflow multi-agente (audit, backtest e ottimizzazione li fa Claude Code sui file dello zip). Asset XAUUSD ed EURUSD, H1, due famiglie: mean-reversion e breakout.

```
OBIETTIVO: trovare e salvare il CODICE SORGENTE di 10 indicatori open-source di TradingView adatti a strategie su XAUUSD ed EURUSD in H1: 5 di MEAN-REVERSION e 5 di BREAKOUT. Solo lettura di pagine pubbliche.

REGOLE DI SICUREZZA (obbligatorie)
- Nessun login, nessun acquisto o abbonamento, nessun click su pubblicita o pulsanti Follow/Like/Boost/Pubblica, nessun commento, nessun download di eseguibili. Se compare una richiesta di login o di pagamento, FERMATI su quella pagina e scrivilo.
- Non inventare nulla. Valore non leggibile = "non leggibile". Il codice va copiato ESATTAMENTE come e scritto, senza correggerlo, tradurlo o riassumerlo.
- Se un sorgente non si riesce a leggere come testo, segna "codice non estratto" e passa oltre: non sostituirlo con una tua descrizione.

PASSO 1: CERCARE
Apri https://www.tradingview.com/scripts/ e usa i filtri: tipo "Indicators", "Open-source only" (solo codice aperto), ordinamento "Top" (e, se serve, "Trending"). Cerca con queste parole chiave, una alla volta:
- mean-reversion: "mean reversion", "bollinger reversal", "rsi mean reversion", "z-score", "reversal", "bands reversion"
- breakout: "breakout", "range breakout", "donchian", "volatility squeeze", "opening range breakout", "channel breakout", "support resistance breakout"
Per ogni parola chiave guarda i primi 10-15 risultati.

PASSO 2: ESCLUDERE SUBITO
- script a codice chiuso o protetto (invite-only, protected, closed-source);
- script senza segnali chiari di ingresso/uscita (solo disegno di livelli, zone o dashboard);
- cloni banali di RSI, MACD, media mobile o Bollinger standard senza una logica propria;
- script in Pine versione 3 o 4 se esiste una versione 5/6 dello stesso autore.
Scegli 5 per famiglia, preferendo quelli con piu "Boost" o "Like" e con una logica descritta a parole.

PASSO 3: PER OGNI SCRIPT (10 in tutto)
1. Apri la pagina dello script e la scheda "Source code" (o il codice sorgente mostrato in pagina). Copia TUTTO il codice Pine in un file di testo: <NN>_<nome-script>.pine (NN da 01 a 10; per il nome usa lettere, cifre e trattini).
2. Annota: nome, autore, link (senza parametri di tracciamento), data di pubblicazione o ultimo aggiornamento, versione Pine (//@version=), numero di Like/Boost se mostrato, **licenza** (la riga "This source code is subject to the terms of ..." o "CC BY-NC-SA", "MPL", ecc.), famiglia (mean-reversion o breakout), la logica in UNA frase, i segnali di ingresso e uscita come li descrive l'autore.
3. Cerca nel codice queste parole e scrivi SI o NO per ciascuna: "lookahead", "request.security", "ta.pivothigh", "ta.pivotlow", "barstate.isrealtime", "calc_on_every_tick", "strategy(" (se e gia una strategia o un indicatore). Non giudicare: solo SI/NO.

FORMATO DELL'OUTPUT
1. Una tabella in italiano con una riga per script e le colonne: NN | nome | autore | famiglia | link | data | versione Pine | licenza | like/boost | logica in una frase | lookahead | request.security | pivothigh | pivotlow | realtime | strategy.
2. Crea lo zip TV_SCOUT_<AAAA-MM-GG>.zip con: 00_info.txt (data e ora italiana, parole chiave usate, filtri applicati, pagine che non hai potuto aprire e perche), 01_tabella.csv (la stessa tabella, separatore ;, UTF-8), e i 10 file <NN>_<nome-script>.pine. Dimensione massima 10 MB.
3. Alla fine dimmi: quanti script hai estratto con codice completo, quali no e perche, posizione e dimensione dello zip.

NON dare giudizi su quale indicatore sia il migliore, non suggerire parametri o operativita: riporta solo cio che c'e scritto.
```
